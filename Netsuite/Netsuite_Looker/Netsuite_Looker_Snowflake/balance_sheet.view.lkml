view: balance_sheet {
  derived_table: {
    sql:
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
      from ${transactions_with_converted_amounts.SQL_TABLE_NAME} as transactions_with_converted_amounts
      join netsuite.accounts on accounts.account_id = transactions_with_converted_amounts.account_id
      join netsuite.accounting_periods as reporting_accounting_periods on reporting_accounting_periods.accounting_period_id = transactions_with_converted_amounts.reporting_accounting_period_id
      join netsuite.accounting_periods as transaction_accounting_periods on transaction_accounting_periods.accounting_period_id = transactions_with_converted_amounts.transaction_accounting_period_id
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
      from ${transactions_with_converted_amounts.SQL_TABLE_NAME} as transactions_with_converted_amounts
      join netsuite.accounts on accounts.account_id = transactions_with_converted_amounts.account_id
      join netsuite.accounting_periods as reporting_accounting_periods on reporting_accounting_periods.accounting_period_id = transactions_with_converted_amounts.reporting_accounting_period_id
      where reporting_accounting_periods.fiscal_calendar_id = (select fiscal_calendar_id from netsuite.subsidiaries where parent_id is null)
        and (lower(accounts.is_balancesheet) = 't'
          or transactions_with_converted_amounts.is_income_statement)
      ;;
  }

  dimension: accounting_period_id {
    group_label: "Accounting Period"
    type: number
    sql: ${TABLE}.accounting_period_id ;;
  }

  dimension_group: accounting_period_ending {
    group_label: "Accounting Period"
    description: "End date of the accounting period"
    type: time
    timeframes: [raw, month]
    sql: ${TABLE}.accounting_period_ending ;;
  }

  dimension: accounting_period_full_name {
    group_label: "Accounting Period"
    type: string
    sql: ${TABLE}.accounting_period_full_name ;;
  }

  dimension: accounting_period_name {
    group_label: "Accounting Period"
    type: string
    sql: ${TABLE}.accounting_period_name ;;
  }

  dimension: is_accounting_period_adjustment {
    group_label: "Accounting Period"
    description: "Yes/No field, indicating whether or not the selecting accounting period is an adjustment period"
    type: yesno
    sql: ${TABLE}.is_accounting_period_adjustment ;;
  }

  dimension: is_accounting_period_closed {
    group_label: "Accounting Period"
    description: "Yes/No field, indicating whether or not the selecting accounting period is closed"
    type: yesno
    sql: ${TABLE}.is_accounting_period_closed ;;
  }

  dimension: account_name {
    group_label: "Account"
    type: string
    sql: ${TABLE}.account_name ;;
  }

  dimension: account_id {
    group_label: "Account"
    type: number
    sql: ${TABLE}.account_id ;;
  }

  dimension: account_number {
    group_label: "Account"
    type: string
    sql: ${TABLE}.account_number ;;
  }

  dimension: account_number_and_name {
    group_label: "Account"
    type: string
    sql: concat(${account_number}, ' - ', ${account_name}) ;;
  }

  dimension: account_type_name {
    group_label: "Account"
    type: string
    sql: ${TABLE}.account_type_name ;;
  }

  dimension: account_category {
    group_label: "Account"
    description: "Category of the account.  Options include Asset, Liability, Equity, Expense or Income."
    type: string
    sql: ${TABLE}.account_category ;;
  }

  dimension: balance_sheet_sort_helper {
    description: "Helper dimension used to sort balance sheet based on account type name"
    type: number
    sql: ${TABLE}.balance_sheet_sort_helper ;;
  }

  measure: sum_converted_amount {
    description: "Sum of amount, converted into the primary subsidiary's default currency"
    type: sum
    value_format_name: usd
    sql: ${TABLE}.converted_amount ;;
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      account_number,
      account_name,
      account_category,
      account_id,
      accounting_period_ending_month,
      accounting_period_full_name,
      accounting_period_name,
      sum_converted_amount
    ]
  }
}
