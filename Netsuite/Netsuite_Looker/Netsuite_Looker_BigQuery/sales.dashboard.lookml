- dashboard: sales_
  title: Sales 💰
  layout: newspaper
  elements:
  - title: Sales by Customer Country
    name: Sales by Customer Country
    model: netsuite
    explore: transaction_details
    type: looker_bar
    fields: [transaction_details.sum_transaction_amount, transaction_details.customer_country]
    filters:
      transaction_details.is_income_account: 'Yes'
      transaction_details.transaction_type: Sales Order
    sorts: [transaction_details.sum_transaction_amount desc]
    limit: 500
    query_timezone: America/Los_Angeles
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: bottom, series: [{axisId: transaction_details.sum_transaction_converted_amount,
            id: transaction_details.sum_transaction_converted_amount, name: Sum Transaction
              Converted Amount}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    legend_position: center
    series_types: {}
    point_style: none
    show_value_labels: true
    label_density: 25
    label_color: [grey]
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    listen:
      Transaction Date: transaction_details.transaction_date
      Item Name: transaction_details.item_name
      Customer Name: transaction_details.customer_name
      Is Account Intercompany: transaction_details.is_account_intercompany
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
      Subsidiary Name: transaction_details.subsidiary_name
    row: 7
    col: 0
    width: 12
    height: 8
  - title: Sales Orders, by Customer
    name: Sales Orders, by Customer
    model: netsuite
    explore: transaction_details
    type: table
    fields: [transaction_details.customer_name, transaction_details.transaction_date,
      transaction_details.currency_symbol, transaction_details.sum_transaction_amount]
    filters:
      transaction_details.transaction_type: Sales Order
      transaction_details.is_income_account: 'Yes'
    sorts: [transaction_details.transaction_date desc]
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
      Transaction Date: transaction_details.transaction_date
      Item Name: transaction_details.item_name
      Customer Name: transaction_details.customer_name
      Is Account Intercompany: transaction_details.is_account_intercompany
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
      Subsidiary Name: transaction_details.subsidiary_name
    row: 0
    col: 0
    width: 12
    height: 7
  - title: Sales Orders, Popular Items
    name: Sales Orders, Popular Items
    model: netsuite
    explore: transaction_details
    type: table
    fields: [transaction_details.item_name, transaction_details.sum_transaction_amount,
      transaction_details.count]
    filters:
      transaction_details.transaction_type: Sales Order
      transaction_details.is_income_account: 'Yes'
    sorts: [transaction_details.sum_transaction_amount desc, transaction_details.item_name]
    limit: 500
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    series_labels: {}
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    legend_position: center
    series_types: {}
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    listen:
      Transaction Date: transaction_details.transaction_date
      Item Name: transaction_details.item_name
      Customer Name: transaction_details.customer_name
      Is Account Intercompany: transaction_details.is_account_intercompany
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
      Subsidiary Name: transaction_details.subsidiary_name
    row: 0
    col: 12
    width: 12
    height: 7
  - title: Sales by Customer State
    name: Sales by Customer State
    model: netsuite
    explore: transaction_details
    type: looker_bar
    fields: [transaction_details.customer_state, transaction_details.sum_transaction_amount]
    filters:
      transaction_details.is_income_account: 'Yes'
      transaction_details.transaction_type: Sales Order
    sorts: [transaction_details.sum_transaction_amount desc]
    limit: 500
    query_timezone: America/Los_Angeles
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: bottom, series: [{axisId: transaction_details.sum_transaction_converted_amount,
            id: transaction_details.sum_transaction_converted_amount, name: Sum Transaction
              Converted Amount}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    legend_position: center
    series_types: {}
    point_style: none
    show_value_labels: true
    label_density: 25
    label_color: [grey]
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    listen:
      Transaction Date: transaction_details.transaction_date
      Item Name: transaction_details.item_name
      Customer Name: transaction_details.customer_name
      Is Account Intercompany: transaction_details.is_account_intercompany
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
      Subsidiary Name: transaction_details.subsidiary_name
    row: 7
    col: 12
    width: 12
    height: 8
  - title: 'Sales Orders: Pending Approval'
    name: 'Sales Orders: Pending Approval'
    model: netsuite
    explore: transaction_details
    type: table
    fields: [transaction_details.customer_name, transaction_details.transaction_id,
      transaction_details.transaction_date, transaction_details.currency_symbol, transaction_details.sum_transaction_amount]
    filters:
      transaction_details.transaction_type: Sales Order
      transaction_details.is_income_account: 'Yes'
      transaction_details.transaction_status: Pending Approval
    sorts: [transaction_details.transaction_date desc]
    limit: 500
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    series_labels:
      transaction_details.sum_transaction_amount: Amount
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen:
      Item Name: transaction_details.item_name
      Customer Name: transaction_details.customer_name
      Is Account Intercompany: transaction_details.is_account_intercompany
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
    row: 15
    col: 12
    width: 12
    height: 7
  - title: 'Sales Orders: Pending Billing'
    name: 'Sales Orders: Pending Billing'
    model: netsuite
    explore: transaction_details
    type: table
    fields: [transaction_details.customer_name, transaction_details.transaction_id,
      transaction_details.transaction_date, transaction_details.currency_symbol, transaction_details.sum_transaction_amount]
    filters:
      transaction_details.transaction_type: Sales Order
      transaction_details.is_income_account: 'Yes'
      transaction_details.transaction_status: Pending Billing
    sorts: [transaction_details.transaction_date desc]
    limit: 500
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    series_labels:
      transaction_details.sum_transaction_amount: Amount
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    listen:
      Item Name: transaction_details.item_name
      Customer Name: transaction_details.customer_name
      Is Account Intercompany: transaction_details.is_account_intercompany
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
      Subsidiary Name: transaction_details.subsidiary_name
    row: 15
    col: 0
    width: 12
    height: 7
  filters:
  - name: Transaction Date
    title: Transaction Date
    type: field_filter
    default_value: 6 weeks
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.transaction_date
  - name: Item Name
    title: Item Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.item_name
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
