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
