- dashboard: accounts_receivable
  title: Accounts Receivable
  layout: newspaper
  elements:
  - title: Open Accounts Receivable Balance
    name: Open Accounts Receivable Balance
    model: netsuite
    explore: transaction_details
    type: single_value
    fields: [transaction_details.sum_transaction_converted_amount]
    sorts: [transaction_details.sum_amount desc]
    limit: 500
    query_timezone: America/Los_Angeles
    listen:
      Transaction Status: transaction_details.transaction_status
      Is Accounts Receivable: transaction_details.is_accounts_receivable
      Transaction Type: transaction_details.transaction_type
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
      Is Account Intercompany: transaction_details.is_account_intercompany
      Account Name: transaction_details.account_name
      Subsidiary Name: transaction_details.subsidiary_name
      Customer Name: transaction_details.customer_name
    row: 0
    col: 0
    width: 12
    height: 4
  - title: Aging Summary
    name: Aging Summary
    model: netsuite
    explore: transaction_details
    type: table
    fields: [transaction_details.days_past_due_date_tier, transaction_details.sum_transaction_converted_amount]
    sorts: [transaction_details.sum_amount desc, transaction_details.days_past_due_date_tier]
    limit: 500
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen:
      Transaction Status: transaction_details.transaction_status
      Is Accounts Receivable: transaction_details.is_accounts_receivable
      Transaction Type: transaction_details.transaction_type
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
      Is Account Intercompany: transaction_details.is_account_intercompany
      Account Name: transaction_details.account_name
      Subsidiary Name: transaction_details.subsidiary_name
      Customer Name: transaction_details.customer_name
    row: 0
    col: 12
    width: 12
    height: 4
  - title: Upcoming Invoices
    name: Upcoming Invoices
    model: netsuite
    explore: transaction_details
    type: table
    fields: [transaction_details.customer_name, transaction_details.transaction_due_date,
      transaction_details.transaction_memo, transaction_details.sum_transaction_amount,
      transaction_details.currency_symbol]
    filters:
      transaction_details.transaction_due_date: after 0 minutes ago
    sorts: [transaction_details.transaction_due_date]
    limit: 500
    total: true
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen:
      Transaction Status: transaction_details.transaction_status
      Is Accounts Receivable: transaction_details.is_accounts_receivable
      Transaction Type: transaction_details.transaction_type
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
      Is Account Intercompany: transaction_details.is_account_intercompany
      Account Name: transaction_details.account_name
      Subsidiary Name: transaction_details.subsidiary_name
      Customer Name: transaction_details.customer_name
    row: 4
    col: 12
    width: 12
    height: 19
  - title: Overdue Invoices
    name: Overdue Invoices
    model: netsuite
    explore: transaction_details
    type: table
    fields: [transaction_details.customer_name, transaction_details.transaction_due_date,
      transaction_details.transaction_memo, transaction_details.sum_transaction_amount,
      transaction_details.currency_symbol]
    filters:
      transaction_details.transaction_due_date: before 0 minutes ago
    sorts: [transaction_details.transaction_due_date desc]
    limit: 500
    total: true
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen:
      Transaction Status: transaction_details.transaction_status
      Is Accounts Receivable: transaction_details.is_accounts_receivable
      Transaction Type: transaction_details.transaction_type
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
      Is Account Intercompany: transaction_details.is_account_intercompany
      Account Name: transaction_details.account_name
      Subsidiary Name: transaction_details.subsidiary_name
      Customer Name: transaction_details.customer_name
    row: 4
    col: 0
    width: 12
    height: 19
  filters:
  - name: Transaction Status
    title: Transaction Status
    type: field_filter
    default_value: Open
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.transaction_status
  - name: Is Accounts Receivable
    title: Is Accounts Receivable
    type: field_filter
    default_value: 'Yes'
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.is_accounts_receivable
  - name: Transaction Type
    title: Transaction Type
    type: field_filter
    default_value: Invoice,Credit Memo
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.transaction_type
  - name: Is Transaction Intercompany
    title: Is Transaction Intercompany
    type: field_filter
    default_value: 'No'
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.is_transaction_intercompany
  - name: Is Account Intercompany
    title: Is Account Intercompany
    type: field_filter
    default_value: 'No'
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.is_account_intercompany
  - name: Account Name
    title: Account Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.account_name
  - name: Subsidiary Name
    title: Subsidiary Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.subsidiary_name
  - name: Customer Name
    title: Customer Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.customer_name
