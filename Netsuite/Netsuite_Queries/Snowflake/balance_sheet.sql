with period_exchange_rate_map as ( -- exchange rates used, by accounting period, to convert to parent subsidiary
  select
    consolidated_exchange_rates.accounting_period_id,
    consolidated_exchange_rates.average_rate,
    consolidated_exchange_rates.current_rate,
    consolidated_exchange_rates.historical_rate,
    consolidated_exchange_rates.from_subsidiary_id,
    consolidated_exchange_rates.to_subsidiary_id
  from netsuite.consolidated_exchange_rates
  where consolidated_exchange_rates.to_subsidiary_id in (select subsidiary_id from netsuite.subsidiaries where parent_id is null)  -- constrait - only the primary subsidiary has no parent
    and consolidated_exchange_rates.accounting_book_id in (select accounting_book_id from netsuite.accounting_books where lower(is_primary) = 'yes')
    and not consolidated_exchange_rates._fivetran_deleted
), accountxperiod_exchange_rate_map as ( -- account table with exchange rate details by accounting period
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
), transaction_lines_w_accounting_period as ( -- transaction line totals, by accounts, accounting period and subsidiary
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
), period_id_list_to_current_period as ( -- period ids with all future period ids.  this is needed to calculate cumulative totals by correct exchange rates.
  select
    base.accounting_period_id,
    array_agg(multiplier.accounting_period_id) within group (order by multiplier.accounting_period_id) as accounting_periods_to_include_for
  from netsuite.accounting_periods as base
  join netsuite.accounting_periods as multiplier
    on multiplier.starting >= base.starting
    and multiplier.quarter = base.quarter
    and multiplier.year_0 = base.year_0
    and multiplier.fiscal_calendar_id = base.fiscal_calendar_id
    and multiplier.starting <= current_timestamp()
  where lower(base.quarter) = 'no'
    and lower(base.year_0) = 'no'
    and base.fiscal_calendar_id = (select fiscal_calendar_id from netsuite.subsidiaries where parent_id is null) -- fiscal calendar will align with parent subsidiary's default calendar
  group by 1
), flattened_period_id_list_to_current_period as (
  select
    accounting_period_id,
    reporting_accounting_period_id.value as reporting_accounting_period_id
  from period_id_list_to_current_period,
    lateral flatten (input => accounting_periods_to_include_for) reporting_accounting_period_id
), transactions_in_every_calculation_period_w_exchange_rates as (
  select
    transaction_lines_w_accounting_period.*,
    reporting_accounting_period_id,
    exchange_reporting_period.exchange_rate as exchange_rate_reporting_period,
    exchange_transaction_period.exchange_rate as exchange_rate_transaction_period
  from transaction_lines_w_accounting_period
  inner join flattened_period_id_list_to_current_period on flattened_period_id_list_to_current_period.accounting_period_id = transaction_lines_w_accounting_period.transaction_accounting_period_id 
  left join accountxperiod_exchange_rate_map as exchange_reporting_period
    on exchange_reporting_period.accounting_period_id = flattened_period_id_list_to_current_period.reporting_accounting_period_id
    and exchange_reporting_period.account_id = transaction_lines_w_accounting_period.account_id
    and exchange_reporting_period.from_subsidiary_id = transaction_lines_w_accounting_period.subsidiary_id
  left join accountxperiod_exchange_rate_map as exchange_transaction_period
    on exchange_transaction_period.accounting_period_id = flattened_period_id_list_to_current_period.accounting_period_id
    and exchange_transaction_period.account_id = transaction_lines_w_accounting_period.account_id
    and exchange_transaction_period.from_subsidiary_id = transaction_lines_w_accounting_period.subsidiary_id
), transactions_with_converted_amounts as (
  select
    transactions_in_every_calculation_period_w_exchange_rates.*,
    unconverted_amount * exchange_rate_transaction_period as converted_amount_using_transaction_accounting_period,
    unconverted_amount * exchange_rate_reporting_period as converted_amount_using_reporting_month,
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
      else null 
      end as account_category
  from transactions_in_every_calculation_period_w_exchange_rates
  left join netsuite.accounts on accounts.account_id = transactions_in_every_calculation_period_w_exchange_rates.account_id 
)

select
  reporting_accounting_periods.accounting_period_id as accounting_period_id,
  reporting_accounting_periods.ending as accounting_period_ending,
  reporting_accounting_periods.full_name as accounting_period_full_name,
  reporting_accounting_periods.name as accounting_period_name,
  lower(reporting_accounting_periods.is_adjustment) = 'yes' as is_accounting_period_adjustment,
  lower(reporting_accounting_periods.closed) = 'yes' as is_accounting_period_closed,
  transactions_with_converted_amounts.account_category as account_category,
  case
    when (lower(accounts.is_balancesheet) = 'f' and reporting_accounting_periods.year_id = transaction_accounting_periods.year_id) then 'Net Income'
    when lower(accounts.is_balancesheet) = 'f' then 'Retained Earnings'
    else accounts.name
    end as account_name,
  case
    when (lower(accounts.is_balancesheet) = 'f' and reporting_accounting_periods.year_id = transaction_accounting_periods.year_id) then 'Net Income'
    when lower(accounts.is_balancesheet) = 'f' then 'Retained Earnings'
    else accounts.type_name
    end as account_type_name,
  case
    when lower(accounts.is_balancesheet) = 'f' then null
    else accounts.account_id
    end as account_id,
  case
    when lower(accounts.is_balancesheet) = 'f' then null
    else accounts.accountnumber
    end as account_number,
  case
    when lower(accounts.is_balancesheet) = 'f' or lower(account_category) = 'equity' then -converted_amount_using_transaction_accounting_period
    when lower(accounts.is_leftside) = 'f' then -converted_amount_using_reporting_month
    when lower(accounts.is_leftside) = 't' then converted_amount_using_reporting_month
    else 0 
    end as converted_amount,
  case
    when lower(account_type_name) = 'bank' then 1
    when lower(account_type_name) = 'accounts receivable' then 2
    when lower(account_type_name) = 'unbilled receivable' then 3
    when lower(account_type_name) = 'other current asset' then 4
    when lower(account_type_name) = 'fixed asset' then 5
    when lower(account_type_name) = 'other asset' then 6
    when lower(account_type_name) = 'deferred expense' then 7
    when lower(account_type_name) = 'accounts payable' then 8
    when lower(account_type_name) = 'credit card' then 9
    when lower(account_type_name) = 'other current liability' then 10
    when lower(account_type_name) = 'long term liability' then 11
    when lower(account_type_name) = 'deferred revenue' then 12
    when lower(account_type_name) = 'equity' then 13
    when (lower(accounts.is_balancesheet) = 'f' and reporting_accounting_periods.year_id = transaction_accounting_periods.year_id) then 15
    when lower(accounts.is_balancesheet) = 'f' then 14
    else null
    end as balance_sheet_sort_helper
from transactions_with_converted_amounts as transactions_with_converted_amounts
left join netsuite.accounts on accounts.account_id = transactions_with_converted_amounts.account_id
left join netsuite.accounting_periods as reporting_accounting_periods on reporting_accounting_periods.accounting_period_id = transactions_with_converted_amounts.reporting_accounting_period_id
left join netsuite.accounting_periods as transaction_accounting_periods on transaction_accounting_periods.accounting_period_id = transactions_with_converted_amounts.transaction_accounting_period_id
where reporting_accounting_periods.fiscal_calendar_id = (select fiscal_calendar_id from netsuite.subsidiaries where parent_id is null)
  and transaction_accounting_periods.fiscal_calendar_id = (select fiscal_calendar_id from netsuite.subsidiaries where parent_id is null)
  and (lower(accounts.is_balancesheet) = 't' 
    or transactions_with_converted_amounts.is_income_statement)
  
union all

select
  reporting_accounting_periods.accounting_period_id as accounting_period_id,
  reporting_accounting_periods.ending as accounting_period_ending,
  reporting_accounting_periods.full_name as accounting_period_full_name,
  reporting_accounting_periods.name as accounting_period_name,
  lower(reporting_accounting_periods.is_adjustment) = 'yes' as is_accounting_period_adjustment,
  lower(reporting_accounting_periods.closed) = 'yes' as is_accounting_period_closed,
  'Equity' as account_category,
  'Cumulative Translation Adjustment' as account_name,
  'Cumulative Translation Adjustment' as account_type_name,
  null as account_id,
  null as account_number,
  case
    when lower(account_category) = 'equity' or is_income_statement then converted_amount_using_transaction_accounting_period
    else converted_amount_using_reporting_month end as converted_amount,
  16 as balance_sheet_sort_helper
from transactions_with_converted_amounts as transactions_with_converted_amounts
left join netsuite.accounts on accounts.account_id = transactions_with_converted_amounts.account_id
left join netsuite.accounting_periods as reporting_accounting_periods on reporting_accounting_periods.accounting_period_id = transactions_with_converted_amounts.reporting_accounting_period_id
where reporting_accounting_periods.fiscal_calendar_id = (select fiscal_calendar_id from netsuite.subsidiaries where parent_id is null)
  and (lower(accounts.is_balancesheet) = 't'
    or transactions_with_converted_amounts.is_income_statement)