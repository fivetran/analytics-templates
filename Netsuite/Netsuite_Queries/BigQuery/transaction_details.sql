with transactions_with_converted_amounts as (
  with period_exchange_rate_map as ( /* exchange rates used, by accounting period, to convert to parent subsidiary */
    select
      consolidated_exchange_rates.accounting_period_id,
      consolidated_exchange_rates.average_rate,
      consolidated_exchange_rates.current_rate,
      consolidated_exchange_rates.historical_rate,
      consolidated_exchange_rates.from_subsidiary_id,
      consolidated_exchange_rates.to_subsidiary_id
    from netsuite.consolidated_exchange_rates
    where consolidated_exchange_rates.to_subsidiary_id in (select subsidiary_id from netsuite.subsidiaries where parent_id is null)  /* constrait - only the primary subsidiary has no parent */
      and consolidated_exchange_rates.accounting_book_id in (select accounting_book_id from netsuite.accounting_books where lower(is_primary) = 'yes' )
      and not consolidated_exchange_rates._fivetran_deleted
  ), accountXperiod_exchange_rate_map as ( /* account table with exchange rate details by accounting period */
    select
      period_exchange_rate_map.accounting_period_id,
      period_exchange_rate_map.from_subsidiary_id,
      period_exchange_rate_map.to_subsidiary_id,
      accounts.account_id,
      case
        when lower(accounts.general_rate_type) = 'historical' then period_exchange_rate_map.historical_rate
        when lower(accounts.general_rate_type) = 'current' then period_exchange_rate_map.current_rate
        when lower(accounts.general_rate_type) = 'average' then period_exchange_rate_map.average_rate
        else null
        end as exchange_rate
    from netsuite.accounts
    cross join period_exchange_rate_map
  ), transaction_lines_w_accounting_period as ( /* transaction line totals, by accounts, accounting period and subsidiary */
    select
      transaction_lines.transaction_id,
      transaction_lines.transaction_line_id,
      transaction_lines.subsidiary_id,
      transaction_lines.account_id,
      transactions.accounting_period_id as transaction_accounting_period_id,
      coalesce(transaction_lines.amount, 0) as unconverted_amount
    from netsuite.transaction_lines
    join netsuite.transactions on transactions.transaction_id = transaction_lines.transaction_id
    where not transactions._fivetran_deleted
      and lower(transactions.transaction_type) != 'revenue arrangement'
      and lower(non_posting_line) != 'yes'
  ), period_id_list_to_current_period as ( /* period ids with all future period ids.  this is needed to calculate cumulative totals by correct exchange rates. */
    select
      base.accounting_period_id,
      array_agg(multiplier.accounting_period_id order by multiplier.accounting_period_id) as accounting_periods_to_include_for
    from netsuite.accounting_periods as base
    join netsuite.accounting_periods as multiplier
      on multiplier.starting >= base.starting
      and multiplier.quarter = base.quarter
      and multiplier.year_0 = base.year_0
      and multiplier.fiscal_calendar_id = base.fiscal_calendar_id
      and multiplier.starting <= current_timestamp()
    where lower(base.quarter) = 'no'
      and lower(base.year_0) = 'no'
      and base.fiscal_calendar_id = (select fiscal_calendar_id from netsuite.subsidiaries where parent_id is null) /* fiscal calendar will align with parent subsidiary's default calendar */
    group by 1
  ), transactions_in_every_calculation_period as (
    select
      transaction_lines_w_accounting_period.*,
      reporting_accounting_period_id
    from transaction_lines_w_accounting_period,
      unnest((select
                accounting_periods_to_include_for
              from period_id_list_to_current_period
              where period_id_list_to_current_period.accounting_period_id
              = transaction_lines_w_accounting_period.transaction_accounting_period_id)) as reporting_accounting_period_id
  ), transactions_in_every_calculation_period_w_exchange_rates as (
    select
      transactions_in_every_calculation_period.*,
      exchange_reporting_period.exchange_rate as exchange_rate_reporting_period,
      exchange_transaction_period.exchange_rate as exchange_rate_transaction_period
    from transactions_in_every_calculation_period
    join accountXperiod_exchange_rate_map as exchange_reporting_period
      on exchange_reporting_period.accounting_period_id = transactions_in_every_calculation_period.reporting_accounting_period_id
      and exchange_reporting_period.account_id = transactions_in_every_calculation_period.account_id
      and exchange_reporting_period.from_subsidiary_id = transactions_in_every_calculation_period.subsidiary_id
    join accountXperiod_exchange_rate_map as exchange_transaction_period
      on exchange_transaction_period.accounting_period_id = transactions_in_every_calculation_period.transaction_accounting_period_id
      and exchange_transaction_period.account_id = transactions_in_every_calculation_period.account_id
      and exchange_transaction_period.from_subsidiary_id = transactions_in_every_calculation_period.subsidiary_id
  )
  select
    transactions_in_every_calculation_period_w_exchange_rates.*,
    unconverted_amount * exchange_rate_reporting_period as converted_amount_using_reporting_month,
    unconverted_amount * exchange_rate_transaction_period as converted_amount_using_transaction_accounting_period,
    case
      when lower(accounts.type_name) in ('income','other income','expense','other expense','other income','cost of goods sold') then true
      else false
      end as is_income_statement,
    case
      when lower(accounts.type_name) in ('accounts receivable', 'bank', 'deferred expense', 'fixed asset', 'other asset', 'other current asset', 'unbilled receivable') then 'Asset'
      when lower(accounts.type_name) in ('cost of goods sold', 'expense', 'other expense') then 'Expense'
      when lower(accounts.type_name) in ('income', 'other income') then 'Income'
      when lower(accounts.type_name) in ('accounts payable', 'credit card', 'deferred revenue', 'long term liability', 'other current liability') then 'Liability'
      when lower(accounts.type_name) in ('equity', 'retained earnings', 'net income') then 'Equity'
      else null end as account_category
  from transactions_in_every_calculation_period_w_exchange_rates
  join netsuite.accounts on accounts.account_id = transactions_in_every_calculation_period_w_exchange_rates.account_id
)
select
  transaction_lines.transaction_line_id,
  transaction_lines.memo as transaction_memo,
  lower(transaction_lines.non_posting_line) = 'yes' as is_transaction_non_posting,
  transactions.transaction_id,
  transactions.status as transaction_status,
  transactions.trandate as transaction_date,
  transactions.due_date as transaction_due_date,
  transactions.transaction_type as transaction_type,
  (lower(transactions.is_advanced_intercompany) = 'yes' or lower(transactions.is_intercompany) = 'yes') as is_transaction_intercompany,
  accounting_periods.ending as accounting_period_ending,
  accounting_periods.full_name as accounting_period_full_name,
  accounting_periods.name as accounting_period_name,
  lower(accounting_periods.is_adjustment) = 'yes' as is_accounting_period_adjustment,
  lower(accounting_periods.closed) = 'yes' as is_accounting_period_closed,
  accounts.name as account_name,
  accounts.type_name as account_type_name,
  accounts.account_id as account_id,
  accounts.accountnumber as account_number,
  lower(accounts.is_leftside) = 't' as is_account_leftside,
  lower(accounts.type_name) like 'accounts payable%' as is_accounts_payable,
  lower(accounts.type_name) like 'accounts receivable%' as is_accounts_receivable,
  lower(accounts.name) like '%intercompany%' as is_account_intercompany,
  coalesce(parent_account.name, accounts.name) as parent_account_name,
  income_accounts.income_account_id is not null as is_income_account,
  expense_accounts.expense_account_id is not null as is_expense_account,
  customers.companyname as customer_company_name,
  customers.city as customer_city,
  customers.state as customer_state,
  customers.zipcode as customer_zipcode,
  customers.country as customer_country,
  customers.date_first_order as customer_date_first_order,
  items.name as item_name,
  items.type_name as item_type_name,
  items.salesdescription as item_sales_description,
  locations.name as location_name,
  locations.city as location_city,
  locations.country as location_country,
  vendor_types.name as vendor_type_name,
  vendors.companyname as vendor_name,
  vendors.create_date as vendor_create_date,
  currencies.name as currency_name,
  currencies.symbol as currency_symbol,
  departments.name as department_name,
  subsidiaries.name as subsidiary_name,
  case
    when lower(accounts.type_name) = 'income' or lower(accounts.type_name) = 'other income' then -converted_amount_using_transaction_accounting_period
    else converted_amount_using_transaction_accounting_period
    end as converted_amount,
  case
    when lower(accounts.type_name) = 'income' or lower(accounts.type_name) = 'other income' then -transaction_lines.amount
    else transaction_lines.amount
    end as transaction_amount,
  case
    when date_diff(current_date, date(transactions.due_date), day)  < 0 then '< 0.0'
    when date_diff(current_date, date(transactions.due_date), day)  >= 0 and date_diff(current_date, date(transactions.due_date), day)  < 30 then '>= 0.0 and < 30.0'
    when date_diff(current_date, date(transactions.due_date), day)  >= 30 and date_diff(current_date, date(transactions.due_date), day)  < 60 then '>= 30.0 and < 60.0'
    when date_diff(current_date, date(transactions.due_date), day)  >= 60 and date_diff(current_date, date(transactions.due_date), day)  < 90 then '>= 60.0 and < 90.0'
    when date_diff(current_date, date(transactions.due_date), day)  >= 90 then '>= 90.0'
    else 'Undefined'
    end as days_past_due_date_tier
from netsuite.transaction_lines
join netsuite.transactions on transactions.transaction_id = transaction_lines.transaction_id
  and not transactions._fivetran_deleted
left join transactions_with_converted_amounts as transactions_with_converted_amounts
  on transactions_with_converted_amounts.transaction_line_id = transaction_lines.transaction_line_id
  and transactions_with_converted_amounts.transaction_id = transaction_lines.transaction_id
  and transactions_with_converted_amounts.transaction_accounting_period_id = transactions_with_converted_amounts.reporting_accounting_period_id
left join netsuite.accounts on accounts.account_id = transaction_lines.account_id
left join netsuite.accounts as parent_account on parent_account.account_id = accounts.parent_id
left join netsuite.accounting_periods on accounting_periods.accounting_period_id = transactions.accounting_period_id
left join netsuite.income_accounts on income_accounts.income_account_id = accounts.account_id
left join netsuite.expense_accounts on expense_accounts.expense_account_id = accounts.account_id
left join netsuite.companies on companies.company_id = transaction_lines.company_id
  and not companies._fivetran_deleted
left join netsuite.vendors on vendors.vendor_id = companies.company_id
  and not vendors._fivetran_deleted
left join netsuite.vendor_types on vendor_types.vendor_type_id = vendors.vendor_type_id
  and not vendor_types._fivetran_deleted
left join netsuite.customers on customers.customer_id = companies.company_id
  and not customers._fivetran_deleted
left join netsuite.partners on partners.partner_id = companies.company_id
  and not partners._fivetran_deleted
left join netsuite.items on items.item_id = transaction_lines.item_id
  and not items._fivetran_deleted
left join netsuite.locations on locations.location_id = transaction_lines.location_id
left join netsuite.currencies on currencies.currency_id = transactions.currency_id
  and not currencies._fivetran_deleted
left join netsuite.departments on departments.department_id = transaction_lines.department_id
join netsuite.subsidiaries on subsidiaries.subsidiary_id = transaction_lines.subsidiary_id
where (accounting_periods.fiscal_calendar_id is null
  or accounting_periods.fiscal_calendar_id  = (select fiscal_calendar_id from netsuite.subsidiaries where parent_id is null))
