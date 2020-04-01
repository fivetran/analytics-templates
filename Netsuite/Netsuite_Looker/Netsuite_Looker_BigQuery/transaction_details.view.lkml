view: transaction_details {
  derived_table: {
    sql:
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
      left join ${transactions_with_converted_amounts.SQL_TABLE_NAME} as transactions_with_converted_amounts
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
       ;;
  }

  dimension: transaction_id {
    group_label: "Transaction"
    description: "Netsuite internal transaction ID"
    type: number
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: transaction_line_id {
    group_label: "Transaction"
    description: "Netsuite internal transaction line ID"
    type: number
    sql: ${TABLE}.transaction_line_id ;;
  }

  dimension: is_transaction_non_posting {
    group_label: "Transaction"
    description: "Yes/No field, indicating whether or not the transaction line is non-posting"
    type: yesno
    sql: ${TABLE}.is_transaction_non_posting ;;
  }

  dimension: transaction_memo {
    group_label: "Transaction"
    type: string
    sql: ${TABLE}.transaction_memo ;;
  }

  dimension: transaction_amount {
    group_label: "Transaction"
    description: "Total amount of the transaction line"
    type: number
    value_format_name: usd_0
    sql: ${TABLE}.transaction_amount ;;
  }

  dimension: transaction_status {
    group_label: "Transaction"
    type: string
    sql: ${TABLE}.transaction_status ;;
  }

  dimension: transaction_type {
    group_label: "Transaction"
    type: string
    sql: ${TABLE}.transaction_type ;;
  }

  dimension: is_transaction_intercompany {
    group_label: "Transaction"
    description: "Yes/No field, indicating whether or not the transaction is an intercompany transaction or an advanced intercompany transaction"
    type: yesno
    sql: ${TABLE}.is_transaction_intercompany ;;
  }

  dimension_group: transaction {
    description: "Date of the transaction"
    type: time
    timeframes: [raw, date, week, month]
    sql: ${TABLE}.transaction_date ;;
  }

  dimension_group: transaction_due {
    description: "Due date of the transaction"
    type: time
    timeframes: [raw, date, month]
    sql: ${TABLE}.transaction_due_date ;;
  }

  dimension: days_past_due_date_tier {
    description: "Tiered days difference between the current date and the due date"
    type: string
    sql: ${TABLE}.days_past_due_date_tier ;;
  }

  dimension: currency_name {
    group_label: "Transaction"
    type: string
    sql: ${TABLE}.currency_name ;;
  }

  dimension: currency_symbol {
    group_label: "Transaction"
    type: string
    sql: ${TABLE}.currency_symbol ;;
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

  dimension_group: accounting_period_ending {
    group_label: "Accounting Period"
    description: "End date of the accounting period"
    type: time
    timeframes: [raw, month]
    sql: ${TABLE}.accounting_period_ending ;;
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

  dimension: account_type_name {
    group_label: "Account"
    type: string
    sql: ${TABLE}.account_type_name ;;
  }

  dimension: account_id {
    group_label: "Account"
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: account_number {
    group_label: "Account"
    type: string
    sql: ${TABLE}.account_number ;;
  }

  dimension: parent_account_name {
    group_label: "Account"
    description: "Name of the parent account, if parent account relationship exists.  Otherwise, the name of the account."
    type: string
    sql: ${TABLE}.parent_account_name ;;
  }

  dimension: is_income_account {
    group_label: "Account"
    description: "Yes/No field indicating whether or not the account is an income account"
    type: yesno
    sql: ${TABLE}.is_income_account ;;
  }

  dimension: is_expense_account {
    group_label: "Account"
    description: "Yes/No field indicating whether or not the account is an expense account"
    type: yesno
    sql: ${TABLE}.is_expense_account ;;
  }

  dimension: is_accounts_payable {
    group_label: "Account"
    description: "Yes/No field indicating whether or not the account type name includes 'accounts payable'"
    type: yesno
    sql: ${TABLE}.is_accounts_payable ;;
  }

  dimension: is_accounts_receivable {
    group_label: "Account"
    description: "Yes/No field indicating whether or not the account type name includes 'accounts receivable'"
    type: yesno
    sql: ${TABLE}.is_accounts_receivable ;;
  }

  dimension: is_account_intercompany {
    group_label: "Account"
    description: "Yes/No field indicating whether or not the account type name includes 'intercompany'"
    type: yesno
    sql: ${TABLE}.is_account_intercompany ;;
  }

  dimension: is_account_leftside {
    group_label: "Account"
    description: "Yes/No field indicating whether or not the account is leftside"
    type: yesno
    sql: ${TABLE}.is_account_leftside ;;
  }

  dimension: customer_name {
    group_label: "Customer"
    type: string
    sql: ${TABLE}.customer_company_name ;;
  }

  dimension: customer_city {
    group_label: "Customer"
    type: string
    sql: ${TABLE}.customer_city ;;
  }

  dimension: customer_state {
    group_label: "Customer"
    type: string
    sql: ${TABLE}.customer_state ;;
  }

  dimension: customer_zipcode {
    group_label: "Customer"
    type: zipcode
    sql: ${TABLE}.customer_zipcode ;;
  }

  dimension: customer_country {
    group_label: "Customer"
    type: string
    sql: ${TABLE}.customer_country ;;
  }

  dimension_group: customer_first_order {
    group_label: "Customer"
    description: "Date customer placed first order"
    type: time
    timeframes: [raw, date, month]
    sql: ${TABLE}.customer_date_first_order ;;
  }

  dimension: vendor_name {
    group_label: "Vendor"
    type: string
    sql: ${TABLE}.vendor_name ;;
  }

  dimension: vendor_type_name {
    group_label: "Vendor"
    type: string
    sql: ${TABLE}.vendor_type_name ;;
  }

  dimension_group: vendor_created {
    group_label: "Vendor"
    description: "Date vendor was created"
    type: time
    timeframes: [raw, date, month]
    sql: ${TABLE}.vendor_create_date ;;
  }

  dimension: item_name {
    group_label: "Item"
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: item_type_name {
    group_label: "Item"
    type: string
    sql: ${TABLE}.item_type_name ;;
  }

  dimension: item_sales_description {
    group_label: "Item"
    type: string
    sql: ${TABLE}.item_sales_description ;;
  }

  dimension: location_name {
    group_label: "Location"
    type: string
    sql: ${TABLE}.location_name ;;
  }

  dimension: location_city {
    group_label: "Location"
    type: string
    sql: ${TABLE}.location_city ;;
  }

  dimension: location_country {
    group_label: "Location"
    type: string
    sql: ${TABLE}.location_country ;;
  }

  dimension: department_name {
    group_label: "Department"
    type: string
    sql: ${TABLE}.department_name ;;
  }

  dimension: subsidiary_name {
    group_label: "Subsidiary"
    type: string
    sql: ${TABLE}.subsidiary_name ;;
  }

  measure: sum_transaction_amount {
    type: sum
    value_format_name: usd
    sql: ${TABLE}.transaction_amount ;;
    drill_fields: [detail*]
  }

  measure: sum_transaction_converted_amount {
    type: sum
    value_format_name: usd
    sql: ${TABLE}.converted_amount ;;
    drill_fields: [detail*]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      transaction_id,
      transaction_line_id,
      transaction_amount,
      transaction_memo,
      accounting_period_ending_month,
      accounting_period_full_name,
      accounting_period_name,
      is_accounting_period_adjustment,
      is_accounting_period_closed,
      transaction_date,
      transaction_type,
      account_name,
      account_type_name,
      account_id,
      account_number,
      is_accounts_payable,
      is_accounts_receivable,
      parent_account_name,
      is_income_account,
      is_expense_account,
      customer_name,
      customer_city,
      customer_state,
      customer_zipcode,
      customer_country,
      customer_first_order_date,
      item_name,
      item_type_name,
      item_sales_description,
      location_name,
      location_city,
      location_country,
      vendor_type_name,
      vendor_name,
      vendor_created_date,
      currency_name,
      currency_symbol,
      department_name,
      days_past_due_date_tier
    ]
  }
}
