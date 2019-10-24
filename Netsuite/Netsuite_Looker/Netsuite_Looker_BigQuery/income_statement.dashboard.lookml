- dashboard: income_statement
  title: Income Statement
  layout: newspaper
  elements:
  - title: Income Statement
    name: Income Statement
    model: netsuite
    explore: income_statement
    type: looker_grid
    fields: [income_statement.income_statement_sort_helper, income_statement.account_type_name,
      income_statement.account_number_and_name, income_statement.sum_converted_amount,
      income_statement.accounting_period_ending_month]
    pivots: [income_statement.accounting_period_ending_month]
    fill_fields: [income_statement.accounting_period_ending_month]
    filters: {}
    sorts: [income_statement.income_statement_sort_helper, income_statement.account_type_name
        desc, income_statement.accounting_period_ending_month 0]
    subtotals: [income_statement.account_type_name, income_statement.income_statement_sort_helper]
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
      income_statement.sum_converted_amount: Total
    series_column_widths: {}
    series_cell_visualizations:
      income_statement.sum_converted_amount:
        is_active: true
    series_text_format:
      income_statement.account_type_name:
        align: left
    table_theme: white
    limit_displayed_rows: false
    series_collapsed:
      income_statement.account_type_name: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting: [{type: less than, value: 0, background_color: '', font_color: red,
        color_application: {collection_id: legacy, palette_id: legacy_diverging1,
          options: {constraints: {min: {type: minimum}, mid: {type: number, value: 0},
              max: {type: maximum}}, mirror: true, reverse: false, stepped: false}},
        bold: true, italic: false, strikethrough: false, fields: []}, {type: greater
          than, value: 0, background_color: '', font_color: black, color_application: {
          collection_id: legacy, palette_id: legacy_diverging1, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: true, italic: false,
        strikethrough: false, fields: []}]
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    truncate_column_names: false
    series_types: {}
    hidden_fields: [income_statement.income_statement_sort_helper]
    y_axes: []
    title_hidden: true
    listen:
      Period: income_statement.accounting_period_ending_month
      Is Accounting Period Closed: income_statement.is_accounting_period_closed
    row: 0
    col: 0
    width: 24
    height: 9
  - title: Income Trend
    name: Income Trend
    model: netsuite
    explore: income_statement
    type: looker_line
    fields: [income_statement.sum_converted_amount, income_statement.accounting_period_ending_month,
      income_statement.account_type_name]
    pivots: [income_statement.account_type_name]
    fill_fields: [income_statement.accounting_period_ending_month]
    filters:
      income_statement.account_type_name: Income,Other Income
    sorts: [income_statement.accounting_period_ending_month, income_statement.account_type_name]
    limit: 500
    dynamic_fields: [{table_calculation: account_format_calculation, label: Account
          Format Calculation, expression: "if(${income_statement.account_type_name}\
          \ = \"Income\", 1,\n  if(${income_statement.account_type_name} = \"Cost\
          \ of Goods Sold\", 2,\n    if(${income_statement.account_type_name} = \"\
          Expense\", 3,\n      if(${income_statement.account_type_name} = \"Other\
          \ Income\", 4,\n        if(${income_statement.account_type_name} = \"Other\
          \ Expense\", 5,null)))))", value_format: !!null '', value_format_name: !!null '',
        is_disabled: true, _kind_hint: dimension, _type_hint: number}, {table_calculation: gross_profit_margin,
        label: Gross Profit Margin, expression: "${income_statement.sum_converted_amount:total}/\n\
          if(${income_statement.account_type_name} = \"Income\",${income_statement.sum_converted_amount},null)",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number, is_disabled: true}]
    query_timezone: America/Los_Angeles
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: income_statement.sum_converted_amount,
            id: Cost of Goods Sold - income_statement.sum_converted_amount, name: Cost
              of Goods Sold}, {axisId: income_statement.sum_converted_amount, id: Expense
              - income_statement.sum_converted_amount, name: Expense}, {axisId: income_statement.sum_converted_amount,
            id: Income - income_statement.sum_converted_amount, name: Income}, {axisId: income_statement.sum_converted_amount,
            id: Other Expense - income_statement.sum_converted_amount, name: Other
              Expense}, {axisId: income_statement.sum_converted_amount, id: Other
              Income - income_statement.sum_converted_amount, name: Other Income}],
        showLabels: false, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
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
      num_rows: '12'
    hide_legend: false
    legend_position: center
    label_value_format: "$#,##0"
    series_types: {}
    point_style: none
    show_value_labels: true
    label_density: 25
    label_color: [grey]
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    custom_color_enabled: true
    custom_color: green
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting: [{type: less than, value: 0, background_color: '', font_color: red,
        color_application: {collection_id: legacy, palette_id: legacy_diverging1,
          options: {constraints: {min: {type: minimum}, mid: {type: number, value: 0},
              max: {type: maximum}}, mirror: true, reverse: false, stepped: false}},
        bold: true, italic: false, strikethrough: false, fields: []}, {type: greater
          than, value: 0, background_color: '', font_color: black, color_application: {
          collection_id: legacy, palette_id: legacy_diverging1, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: true, italic: false,
        strikethrough: false, fields: []}]
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    hidden_fields: []
    listen:
      Period: income_statement.accounting_period_ending_month
      Is Accounting Period Closed: income_statement.is_accounting_period_closed
    row: 9
    col: 0
    width: 12
    height: 10
  - title: Expense Trend
    name: Expense Trend
    model: netsuite
    explore: income_statement
    type: looker_line
    fields: [income_statement.sum_converted_amount, income_statement.accounting_period_ending_month,
      income_statement.account_type_name]
    pivots: [income_statement.account_type_name]
    fill_fields: [income_statement.accounting_period_ending_month]
    filters:
      income_statement.account_type_name: Cost of Goods Sold,Expense,Other Expense
    sorts: [income_statement.accounting_period_ending_month, income_statement.account_type_name]
    limit: 500
    dynamic_fields: [{table_calculation: account_format_calculation, label: Account
          Format Calculation, expression: "if(${income_statement.account_type_name}\
          \ = \"Income\", 1,\n  if(${income_statement.account_type_name} = \"Cost\
          \ of Goods Sold\", 2,\n    if(${income_statement.account_type_name} = \"\
          Expense\", 3,\n      if(${income_statement.account_type_name} = \"Other\
          \ Income\", 4,\n        if(${income_statement.account_type_name} = \"Other\
          \ Expense\", 5,null)))))", value_format: !!null '', value_format_name: !!null '',
        is_disabled: true, _kind_hint: measure, _type_hint: number}, {table_calculation: gross_profit_margin,
        label: Gross Profit Margin, expression: "${income_statement.sum_converted_amount:total}/\n\
          if(${income_statement.account_type_name} = \"Income\",${income_statement.sum_converted_amount},null)",
        value_format: !!null '', value_format_name: percent_1, is_disabled: true,
        _kind_hint: measure, _type_hint: number}, {table_calculation: converted_amount,
        label: Converted Amount, expression: "-${income_statement.sum_converted_amount}",
        value_format: !!null '', value_format_name: decimal_0, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: income_statement.sum_converted_amount,
            id: Cost of Goods Sold - income_statement.sum_converted_amount, name: Cost
              of Goods Sold}, {axisId: income_statement.sum_converted_amount, id: Expense
              - income_statement.sum_converted_amount, name: Expense}, {axisId: income_statement.sum_converted_amount,
            id: Income - income_statement.sum_converted_amount, name: Income}, {axisId: income_statement.sum_converted_amount,
            id: Other Expense - income_statement.sum_converted_amount, name: Other
              Expense}, {axisId: income_statement.sum_converted_amount, id: Other
              Income - income_statement.sum_converted_amount, name: Other Income}],
        showLabels: false, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
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
      num_rows: '12'
    hide_legend: false
    legend_position: center
    label_value_format: "$#,##0"
    series_types: {}
    point_style: none
    show_value_labels: true
    label_density: 25
    label_color: [grey]
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    custom_color_enabled: true
    custom_color: green
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting: [{type: less than, value: 0, background_color: '', font_color: red,
        color_application: {collection_id: legacy, palette_id: legacy_diverging1,
          options: {constraints: {min: {type: minimum}, mid: {type: number, value: 0},
              max: {type: maximum}}, mirror: true, reverse: false, stepped: false}},
        bold: true, italic: false, strikethrough: false, fields: []}, {type: greater
          than, value: 0, background_color: '', font_color: black, color_application: {
          collection_id: legacy, palette_id: legacy_diverging1, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: true, italic: false,
        strikethrough: false, fields: []}]
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    hidden_fields: [income_statement.sum_converted_amount]
    listen:
      Period: income_statement.accounting_period_ending_month
      Is Accounting Period Closed: income_statement.is_accounting_period_closed
    row: 9
    col: 12
    width: 12
    height: 10
  filters:
  - name: Period
    title: Period
    type: field_filter
    default_value: 2019/05/01 to 2019/09/30
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: income_statement
    listens_to_filters: []
    field: income_statement.accounting_period_ending_month
  - name: Is Accounting Period Closed
    title: Is Accounting Period Closed
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: income_statement
    listens_to_filters: []
    field: income_statement.is_accounting_period_closed
