view: income_statement {
  derived_table: {
    sql:
      select
        reporting_accounting_periods.accounting_period_id as accounting_period_id,
        reporting_accounting_periods.ending as accounting_period_ending,
        reporting_accounting_periods.full_name as accounting_period_full_name,
        reporting_accounting_periods.name as accounting_period_name,
        lower(reporting_accounting_periods.is_adjustment) = 'yes' as is_accounting_period_adjustment,
        lower(reporting_accounting_periods.closed) = 'yes' as is_accounting_period_closed,
        accounts.name as account_name,
        accounts.type_name as account_type_name,
        accounts.account_id as account_id,
        accounts.accountnumber as account_number,
        concat(accounts.accountnumber, ' - ', accounts.name) as account_number_and_name,
        classes.full_name as class_full_name,
        locations.full_name as location_full_name,
        departments.full_name as department_full_name,
        -converted_amount_using_transaction_accounting_period as converted_amount,
        transactions_with_converted_amounts.account_category as account_category,
        case when lower(accounts.type_name) = 'income' then 1
          when lower(accounts.type_name) = 'cost of goods sold' then 2
          when lower(accounts.type_name) = 'expense' then 3
          when lower(accounts.type_name) = 'other income' then 4
          when lower(accounts.type_name) = 'other expense' then 5
          else null
          end as income_statement_sort_helper
      from ${transactions_with_converted_amounts.SQL_TABLE_NAME} as transactions_with_converted_amounts
      left join netsuite.transaction_lines as transaction_lines
        on transaction_lines.transaction_line_id = transactions_with_converted_amounts.transaction_line_id
        and transaction_lines.transaction_id = transactions_with_converted_amounts.transaction_id
      left join netsuite.classes on classes.class_id = transaction_lines.class_id
      left join netsuite.locations on locations.location_id = transaction_lines.location_id
      left join netsuite.departments on departments.department_id = transaction_lines.department_id
      left join netsuite.accounts on accounts.account_id = transactions_with_converted_amounts.account_id
      left join netsuite.accounting_periods as reporting_accounting_periods on reporting_accounting_periods.accounting_period_id = transactions_with_converted_amounts.reporting_accounting_period_id
      where reporting_accounting_periods.fiscal_calendar_id  = (select
                                                                  fiscal_calendar_id
                                                                from netsuite.subsidiaries
                                                                where parent_id is null)
        and transactions_with_converted_amounts.transaction_accounting_period_id = transactions_with_converted_amounts.reporting_accounting_period_id
        and transactions_with_converted_amounts.is_income_statement
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

  dimension: account_type_name {
    group_label: "Account"
    type: string
    sql: ${TABLE}.account_type_name ;;
  }

  dimension: account_number_and_name {
    group_label: "Account"
    type: string
    sql: ${TABLE}.account_number_and_name ;;
  }

  dimension: account_category {
    group_label: "Account"
    description: "Category of the account. Options include Asset, Liability, Equity, Expense or Income."
    type: string
    sql: ${TABLE}.account_category ;;
  }

  dimension: income_statement_sort_helper {
    description: "Helper dimension used to sort income statement based on account type name"
    type: number
    sql: ${TABLE}.income_statement_sort_helper ;;
  }

  dimension: class_full_name {
    type: string
    sql: ${TABLE}.class_full_name ;;
  }

  dimension: location_full_name {
    type: string
    sql: ${TABLE}.location_full_name ;;
  }

  dimension: department_full_name {
    type: string
    sql: ${TABLE}.department_full_name ;;
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
      accounting_period_id,
      accounting_period_ending_month,
      accounting_period_full_name,
      accounting_period_name,
      is_accounting_period_adjustment,
      account_name,
      account_type_name,
      account_id,
      account_number,
      class_full_name,
      location_full_name,
      department_full_name,
      account_category,
      income_statement_sort_helper
    ]
  }
}
