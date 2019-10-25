- dashboard: expenses_
  title: Expenses 💵
  layout: newspaper
  elements:
  - title: Expenses by Account Group
    name: Expenses by Account Group
    model: netsuite
    explore: transaction_details
    type: looker_column
    fields: [transaction_details.parent_account_name, transaction_details.sum_transaction_converted_amount,
      transaction_details.transaction_month]
    pivots: [transaction_details.parent_account_name]
    fill_fields: [transaction_details.transaction_month]
    filters:
      transaction_details.is_expense_account: 'Yes'
    sorts: [transaction_details.sum_transaction_converted_amount desc 0, transaction_details.parent_account_name]
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
    stacking: normal
    limit_displayed_rows: false
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    legend_position: center
    series_types: {}
    point_style: none
    show_value_labels: false
    label_density: 25
    label_color: [grey]
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    listen:
      Transaction Date: transaction_details.transaction_date
      Department Name: transaction_details.department_name
      Account Group: transaction_details.parent_account_name
      Location Name: transaction_details.location_name
      Subsidiary Name: transaction_details.subsidiary_name
      Is Account Intercompany: transaction_details.is_account_intercompany
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
    row: 0
    col: 12
    width: 12
    height: 9
  - title: Expenses by Location
    name: Expenses by Location
    model: netsuite
    explore: transaction_details
    type: looker_bar
    fields: [transaction_details.sum_transaction_converted_amount, transaction_details.location_name]
    filters:
      transaction_details.is_expense_account: 'Yes'
    sorts: [transaction_details.sum_transaction_converted_amount desc]
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
    limit_displayed_rows: false
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
      Department Name: transaction_details.department_name
      Account Group: transaction_details.parent_account_name
      Location Name: transaction_details.location_name
      Subsidiary Name: transaction_details.subsidiary_name
      Is Account Intercompany: transaction_details.is_account_intercompany
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
    row: 9
    col: 12
    width: 12
    height: 9
  - title: Expenses by Department
    name: Expenses by Department
    model: netsuite
    explore: transaction_details
    type: looker_bar
    fields: [transaction_details.sum_transaction_converted_amount, transaction_details.department_name]
    filters:
      transaction_details.is_expense_account: 'Yes'
    sorts: [transaction_details.sum_transaction_converted_amount desc]
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
    limit_displayed_rows: false
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
      Department Name: transaction_details.department_name
      Account Group: transaction_details.parent_account_name
      Location Name: transaction_details.location_name
      Subsidiary Name: transaction_details.subsidiary_name
      Is Account Intercompany: transaction_details.is_account_intercompany
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
    row: 0
    col: 0
    width: 12
    height: 9
  - title: Expenses over last 7 days
    name: Expenses over last 7 days
    model: netsuite
    explore: transaction_details
    type: table
    fields: [transaction_details.transaction_date, transaction_details.transaction_id,
      transaction_details.transaction_memo, transaction_details.transaction_type,
      transaction_details.location_name, transaction_details.transaction_status, transaction_details.sum_transaction_converted_amount]
    filters:
      transaction_details.is_expense_account: 'Yes'
      transaction_details.transaction_date: 7 days
    sorts: [transaction_details.sum_transaction_converted_amount desc]
    limit: 500
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    limit_displayed_rows: false
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
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
      Department Name: transaction_details.department_name
      Account Group: transaction_details.parent_account_name
      Location Name: transaction_details.location_name
      Subsidiary Name: transaction_details.subsidiary_name
      Is Account Intercompany: transaction_details.is_account_intercompany
      Is Transaction Intercompany: transaction_details.is_transaction_intercompany
    row: 9
    col: 0
    width: 12
    height: 9
  filters:
  - name: Transaction Date
    title: Transaction Date
    type: field_filter
    default_value: 6 months
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.transaction_date
  - name: Department Name
    title: Department Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.department_name
  - name: Account Group
    title: Account Group
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.parent_account_name
  - name: Location Name
    title: Location Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: transaction_details
    listens_to_filters: []
    field: transaction_details.location_name
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
