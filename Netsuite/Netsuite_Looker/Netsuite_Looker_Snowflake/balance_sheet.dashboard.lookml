- dashboard: balance_sheet
  title: Balance Sheet
  layout: newspaper
  elements:
  - name: ''
    type: text
    title_text: ''
    body_text: <font color="#000000" size="6"><center><strong>ASSETS</center></strong></font>
    row: 9
    col: 0
    width: 24
    height: 2
  - name: 'placeholder_1'
    type: text
    title_text: ''
    body_text: <font color="#000000" size="6"><center><strong>LIABILITIES & EQUITY</center></strong></font>
    row: 31
    col: 0
    width: 24
    height: 2
  - title: Summary
    name: Summary
    model: netsuite
    explore: balance_sheet
    type: looker_grid
    fields: [balance_sheet.balance_sheet_sort_helper, balance_sheet_category, balance_sheet.account_type_name,
      balance_sheet.sum_converted_amount]
    filters:
      balance_sheet.accounting_period_ending_month: 1 months ago for 1 months
    sorts: [balance_sheet.balance_sheet_sort_helper]
    limit: 500
    dynamic_fields: [{dimension: balance_sheet_category, label: Balance Sheet Category,
        expression: "if(${balance_sheet.account_type_name} = \"Retained Earnings\"\
          , \"Equity\", \n  if(${balance_sheet.account_type_name} = \"Net Income\"\
          , \"Equity\",\n    ${balance_sheet.account_category}\n    ))", value_format: !!null '',
        value_format_name: !!null '', _kind_hint: dimension, _type_hint: string}]
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    series_labels:
      balance_sheet_2.name: Account
      balance_sheet.sum_converted_amount: Total
    series_cell_visualizations:
      balance_sheet.sum_converted_amount:
        is_active: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    theme: white
    show_full_field_name: true
    truncate_column_names: true
    hidden_fields: [balance_sheet_2.type_sequence, balance_sheet.balance_sheet_sort_helper]
    y_axes: []
    series_types: {}
    title_hidden: true
    listen: {}
    row: 2
    col: 14
    width: 10
    height: 7
  - title: Asset
    name: Asset
    model: netsuite
    explore: balance_sheet
    type: single_value
    fields: [balance_sheet.sum_converted_amount]
    filters:
      balance_sheet.account_category: Asset
      balance_sheet.accounting_period_ending_month: 1 months ago for 1 months
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: true
    hide_totals: false
    hide_row_totals: false
    series_labels:
      balance_sheet_2.account_type_name: Account Type
      balance_sheet.name: Account
      balance_sheet.sum_converted_amount: Total
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    hidden_fields:
    series_types: {}
    y_axes: []
    listen: {}
    row: 2
    col: 0
    width: 6
    height: 7
  - title: Liabilities
    name: Liabilities
    model: netsuite
    explore: balance_sheet
    type: single_value
    fields: [balance_sheet.sum_converted_amount]
    filters:
      balance_sheet.account_category: Liability
      balance_sheet.accounting_period_ending_month: 1 months ago for 1 months
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: true
    hide_totals: false
    hide_row_totals: false
    series_labels:
      balance_sheet_2.account_type_name: Account Type
      balance_sheet.name: Account
      balance_sheet.sum_converted_amount: Total
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    hidden_fields:
    series_types: {}
    y_axes: []
    listen: {}
    row: 2
    col: 6
    width: 8
    height: 3
  - title: Equity
    name: Equity
    model: netsuite
    explore: balance_sheet
    type: single_value
    fields: [balance_sheet.sum_converted_amount]
    filters:
      balance_sheet.account_category: Equity,Income,Expense
      balance_sheet.accounting_period_ending_month: 1 months ago for 1 months
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: true
    hide_totals: false
    hide_row_totals: false
    series_labels:
      balance_sheet_2.account_type_name: Account Type
      balance_sheet.name: Account
      balance_sheet.sum_converted_amount: Total
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    hidden_fields:
    series_types: {}
    y_axes: []
    listen: {}
    row: 5
    col: 6
    width: 8
    height: 4
  - name: 'placeholder_2'
    type: text
    body_text: <font color="#000000" size="5"><center><strong>Last Month's Balance
      Sheet Totals</center></strong></font>
    row: 0
    col: 0
    width: 24
    height: 2
  - title: Assets
    name: Assets
    model: netsuite
    explore: balance_sheet
    type: looker_grid
    fields: [balance_sheet.balance_sheet_sort_helper, balance_sheet.account_type_name,
      balance_sheet.account_number_and_name, balance_sheet.sum_converted_amount, balance_sheet.accounting_period_ending_month]
    pivots: [balance_sheet.accounting_period_ending_month]
    fill_fields: [balance_sheet.accounting_period_ending_month]
    filters:
      balance_sheet.account_category: Asset
      balance_sheet.is_accounting_period_adjustment: 'No'
    sorts: [balance_sheet.balance_sheet_sort_helper, balance_sheet.account_type_name,
      balance_sheet.accounting_period_ending_month]
    subtotals: [balance_sheet.balance_sheet_sort_helper, balance_sheet.account_type_name]
    limit: 500
    total: true
    query_timezone: America/Los_Angeles
    column_order: [balance_sheet.balance_sheet_sort_helper, balance_sheet.account_type_name,
      balance_sheet.account_number_and_name, 2019-04_balance_sheet.sum_converted_amount,
      2019-05_balance_sheet.sum_converted_amount, 2019-06_balance_sheet.sum_converted_amount,
      2019-07_balance_sheet.sum_converted_amount, 2019-08_balance_sheet.sum_converted_amount,
      2019-09_balance_sheet.sum_converted_amount]
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    series_labels:
      balance_sheet_2.name: Account
      balance_sheet_2.account_type_name: Account Type
      balance_sheet.sum_converted_amount: Total
    series_cell_visualizations:
      balance_sheet.sum_converted_amount:
        is_active: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting: []
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    theme: white
    show_full_field_name: true
    truncate_column_names: true
    hidden_fields: [balance_sheet_2.type_sequence, balance_sheet.balance_sheet_sort_helper]
    y_axes: []
    series_types: {}
    title_hidden: true
    listen:
      Timeframe: balance_sheet.accounting_period_ending_month
      Is Accounting Period Closed: balance_sheet.is_accounting_period_closed
    row: 11
    col: 0
    width: 24
    height: 20
  - title: Liabilities & Equity
    name: Liabilities & Equity
    model: netsuite
    explore: balance_sheet
    type: looker_grid
    fields: [balance_sheet.balance_sheet_sort_helper, balance_sheet.account_type_name,
      balance_sheet.account_number_and_name, balance_sheet.sum_converted_amount, balance_sheet.accounting_period_ending_month]
    pivots: [balance_sheet.accounting_period_ending_month]
    fill_fields: [balance_sheet.accounting_period_ending_month]
    filters:
      balance_sheet.account_category: Equity,Liability,Expense,Income
      balance_sheet.is_accounting_period_adjustment: 'No'
    sorts: [balance_sheet.balance_sheet_sort_helper, balance_sheet.account_type_name,
      balance_sheet.accounting_period_ending_month]
    subtotals: [balance_sheet.balance_sheet_sort_helper, balance_sheet.account_type_name]
    limit: 500
    total: true
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    series_labels:
      balance_sheet_2.name: Account
      balance_sheet_2.account_type_name: Account Type
      balance_sheet.sum_converted_amount: Total
    series_cell_visualizations:
      balance_sheet.sum_converted_amount:
        is_active: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting: []
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: true
    theme: white
    show_full_field_name: false
    truncate_column_names: true
    hidden_fields: [balance_sheet_2.type_sequence, balance_sheet.balance_sheet_sort_helper]
    y_axes: []
    series_types: {}
    column_order: [balance_sheet.balance_sheet_sort_helper, balance_sheet.account_type_name,
      balance_sheet.account_number_and_name, 2019-04_balance_sheet.sum_converted_amount,
      2019-05_balance_sheet.sum_converted_amount, 2019-06_balance_sheet.sum_converted_amount,
      2019-07_balance_sheet.sum_converted_amount, 2019-08_balance_sheet.sum_converted_amount,
      2019-09_balance_sheet.sum_converted_amount]
    title_hidden: true
    listen:
      Timeframe: balance_sheet.accounting_period_ending_month
      Is Accounting Period Closed: balance_sheet.is_accounting_period_closed
    row: 33
    col: 0
    width: 24
    height: 21
  filters:
  - name: Timeframe
    title: Timeframe
    type: field_filter
    default_value: 6 months ago for 6 months
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: balance_sheet
    listens_to_filters: []
    field: balance_sheet.accounting_period_ending_month
  - name: Is Accounting Period Closed
    title: Is Accounting Period Closed
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: balance_sheet
    listens_to_filters: []
    field: balance_sheet.is_accounting_period_closed
