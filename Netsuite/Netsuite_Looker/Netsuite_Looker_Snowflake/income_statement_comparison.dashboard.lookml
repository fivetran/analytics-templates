- dashboard: income_statement_comparison
  title: Income Statement Comparison
  layout: newspaper
  elements:
  - title: Gross Profit Margin (%)
    name: Gross Profit Margin (%)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: Income,Cost of Goods Sold
    sorts: [gross_profit_margin desc]
    limit: 500
    dynamic_fields: [{table_calculation: gross_profit_margin, label: Gross Profit
          Margin, expression: "(sum(if(${income_statement.account_type_name} = \"\
          Income\",${income_statement.sum_converted_amount},0)) \n+ \nsum(if(${income_statement.account_type_name}\
          \ = \"Cost of Goods Sold\",${income_statement.sum_converted_amount},0))\
          \ )\n/\nsum(if(${income_statement.account_type_name} = \"Income\",${income_statement.sum_converted_amount},1))",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#E57947"
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount, income_statement.account_type_name]
    y_axes: []
    listen:
      Period 1 (Left): income_statement.accounting_period_ending_month
    row: 7
    col: 6
    width: 6
    height: 2
  - title: Net Income (%)
    name: Net Income (%)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: ''
    sorts: [net_income desc]
    limit: 500
    dynamic_fields: [{table_calculation: net_income, label: Net Income, expression: "(sum(if(${income_statement.account_type_name}\
          \ = \"Income\",${income_statement.sum_converted_amount},0)) \n- \nsum(if(${income_statement.account_type_name}\
          \ = \"Cost of Goods Sold\",${income_statement.sum_converted_amount},0))\n\
          -\nsum(if(${income_statement.account_type_name} = \"Expense\",${income_statement.sum_converted_amount},0))\n\
          -\nsum(if(${income_statement.account_type_name} = \"Other Expense\",${income_statement.sum_converted_amount},0))\n\
          +\nsum(if(${income_statement.account_type_name} = \"Other Income\",${income_statement.sum_converted_amount},0))\n\
          )\n/\nsum(if(${income_statement.account_type_name} = \"Income\",${income_statement.sum_converted_amount},1))",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#E57947"
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount, income_statement.account_type_name]
    y_axes: []
    listen:
      Period 1 (Left): income_statement.accounting_period_ending_month
    row: 11
    col: 6
    width: 6
    height: 2
  - title: Operating Profit Margin (%)
    name: Operating Profit Margin (%)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: Cost of Goods Sold,Income,Expense
    sorts: [operating_profit_margin desc]
    limit: 500
    dynamic_fields: [{table_calculation: operating_profit_margin, label: Operating
          Profit Margin, expression: "(sum(if(${income_statement.account_type_name}\
          \ = \"Income\",${income_statement.sum_converted_amount},0)) \n+ \nsum(if(${income_statement.account_type_name}\
          \ = \"Cost of Goods Sold\",${income_statement.sum_converted_amount},0))\n\
          +\nsum(if(${income_statement.account_type_name} = \"Expense\",${income_statement.sum_converted_amount},0))\n\
          )\n/\nsum(if(${income_statement.account_type_name} = \"Income\",${income_statement.sum_converted_amount},1))",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#E57947"
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount, income_statement.account_type_name]
    y_axes: []
    listen:
      Period 1 (Left): income_statement.accounting_period_ending_month
    row: 9
    col: 6
    width: 6
    height: 2
  - title: Revenue ($)
    name: Revenue ($)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: Income
    sorts: [income_statement.sum_converted_amount desc]
    limit: 500
    dynamic_fields: [{table_calculation: account_format_calculation, label: Account
          Format Calculation, expression: "if(${income_statement.account_type_name}\
          \ = \"Income\", 1,\n  if(${income_statement.account_type_name} = \"Cost\
          \ of Goods Sold\", 2,\n    if(${income_statement.account_type_name} = \"\
          Expense\", 3,\n      if(${income_statement.account_type_name} = \"Other\
          \ Income\", 4,\n        if(${income_statement.account_type_name} = \"Other\
          \ Expense\", 5,null)))))", value_format: !!null '', value_format_name: !!null '',
        _kind_hint: dimension, _type_hint: number, is_disabled: true}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#E57947"
    show_single_value_title: true
    value_format: "$#,##0"
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting: []
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Period 1 (Left): income_statement.accounting_period_ending_month
    row: 4
    col: 0
    width: 6
    height: 3
  - title: Period 2
    name: Period 2
    model: netsuite
    explore: income_statement
    type: looker_grid
    fields: [income_statement.accounting_period_name]
    sorts: [income_statement.accounting_period_name]
    limit: 500
    total: true
    dynamic_fields: [{table_calculation: account_format_calculation, label: Account
          Format Calculation, expression: "if(${income_statement.account_type_name}\
          \ = \"Income\", 1,\n  if(${income_statement.account_type_name} = \"Cost\
          \ of Goods Sold\", 2,\n    if(${income_statement.account_type_name} = \"\
          Expense\", 3,\n      if(${income_statement.account_type_name} = \"Other\
          \ Income\", 4,\n        if(${income_statement.account_type_name} = \"Other\
          \ Expense\", 5,null)))))", value_format: !!null '', value_format_name: !!null '',
        _kind_hint: dimension, _type_hint: number, is_disabled: true}]
    query_timezone: America/Los_Angeles
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    series_labels:
      income_statement.accounting_period_name: Period Name(s)
    series_text_format:
      income_statement.accounting_period_name:
        align: center
        bold: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: center
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting: []
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    truncate_column_names: false
    custom_color_enabled: true
    custom_color: black
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    series_types: {}
    hidden_fields: []
    y_axes: []
    title_hidden: true
    listen:
      Period 2 (Right): income_statement.accounting_period_ending_month
    row: 0
    col: 12
    width: 12
    height: 2
  - title: Revenue ($)
    name: Revenue ($_)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: Income
    sorts: [income_statement.sum_converted_amount desc]
    limit: 500
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#3EB0D5"
    show_single_value_title: true
    value_format: "$#,##0"
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting: []
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Period 2 (Right): income_statement.accounting_period_ending_month
    row: 2
    col: 12
    width: 6
    height: 3
  - title: Gross Profit Margin (%)
    name: Gross Profit Margin (%_)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: Income,Cost of Goods Sold
    sorts: [gross_profit_margin desc]
    limit: 500
    dynamic_fields: [{table_calculation: gross_profit_margin, label: Gross Profit
          Margin, expression: "(sum(if(${income_statement.account_type_name} = \"\
          Income\",${income_statement.sum_converted_amount},0)) \n+\nsum(if(${income_statement.account_type_name}\
          \ = \"Cost of Goods Sold\",${income_statement.sum_converted_amount},0))\
          \ )\n/\nsum(if(${income_statement.account_type_name} = \"Income\",${income_statement.sum_converted_amount},1))",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#3EB0D5"
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount, income_statement.account_type_name]
    y_axes: []
    listen:
      Period 2 (Right): income_statement.accounting_period_ending_month
    row: 5
    col: 18
    width: 6
    height: 2
  - title: Operating Profit Margin (%)
    name: Operating Profit Margin (%_)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: Cost of Goods Sold,Income,Expense
    sorts: [operating_profit_margin desc]
    limit: 500
    dynamic_fields: [{table_calculation: operating_profit_margin, label: Operating
          Profit Margin, expression: "(sum(if(${income_statement.account_type_name}\
          \ = \"Income\",${income_statement.sum_converted_amount},0)) \n+ \nsum(if(${income_statement.account_type_name}\
          \ = \"Cost of Goods Sold\",${income_statement.sum_converted_amount},0))\n\
          +\nsum(if(${income_statement.account_type_name} = \"Expense\",${income_statement.sum_converted_amount},0))\n\
          )\n/\nsum(if(${income_statement.account_type_name} = \"Income\",${income_statement.sum_converted_amount},1))",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#3EB0D5"
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount, income_statement.account_type_name]
    y_axes: []
    listen:
      Period 2 (Right): income_statement.accounting_period_ending_month
    row: 7
    col: 18
    width: 6
    height: 2
  - title: Net Income (%)
    name: Net Income (%_)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: ''
    sorts: [net_income desc]
    limit: 500
    total: true
    dynamic_fields: [{table_calculation: net_income, label: Net Income, expression: "(sum(if(${income_statement.account_type_name}\
          \ = \"Income\",${income_statement.sum_converted_amount},0)) \n+ \nsum(if(${income_statement.account_type_name}\
          \ = \"Cost of Goods Sold\",${income_statement.sum_converted_amount},0))\n\
          +\nsum(if(${income_statement.account_type_name} = \"Expense\",${income_statement.sum_converted_amount},0))\n\
          +\nsum(if(${income_statement.account_type_name} = \"Other Expense\",${income_statement.sum_converted_amount},0))\n\
          +\nsum(if(${income_statement.account_type_name} = \"Other Income\",${income_statement.sum_converted_amount},0))\n\
          )\n/\nsum(if(${income_statement.account_type_name} = \"Income\",${income_statement.sum_converted_amount},1))",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#3EB0D5"
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount, income_statement.account_type_name]
    y_axes: []
    listen:
      Period 2 (Right): income_statement.accounting_period_ending_month
    row: 9
    col: 18
    width: 6
    height: 2
  - title: Revenue (%)
    name: Revenue (%)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: Income
    sorts: [income_statement.sum_converted_amount desc]
    limit: 500
    dynamic_fields: [{table_calculation: calculation, label: "%", expression: "${income_statement.sum_converted_amount}/${income_statement.sum_converted_amount}",
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#E57947"
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount]
    y_axes: []
    listen:
      Period 1 (Left): income_statement.accounting_period_ending_month
    row: 4
    col: 6
    width: 6
    height: 3
  - title: Gross Profit ($)
    name: Gross Profit ($)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: Income,Cost of Goods Sold
    sorts: [gross_profit desc]
    limit: 500
    dynamic_fields: [{table_calculation: account_format_calculation, label: Account
          Format Calculation, expression: "if(${income_statement.account_type_name}\
          \ = \"Income\", 1,\n  if(${income_statement.account_type_name} = \"Cost\
          \ of Goods Sold\", 2,\n    if(${income_statement.account_type_name} = \"\
          Expense\", 3,\n      if(${income_statement.account_type_name} = \"Other\
          \ Income\", 4,\n        if(${income_statement.account_type_name} = \"Other\
          \ Expense\", 5,null)))))", value_format: !!null '', value_format_name: !!null '',
        is_disabled: true, _kind_hint: dimension, _type_hint: number}, {table_calculation: gross_profit,
        label: Gross Profit, expression: "sum(if(${income_statement.account_type_name}\
          \ = \"Income\",${income_statement.sum_converted_amount},0)) \n+ \nsum(if(${income_statement.account_type_name}\
          \ = \"Cost of Goods Sold\",${income_statement.sum_converted_amount},0))\
          \ \n", value_format: !!null '', value_format_name: usd_0, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#E57947"
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount, income_statement.account_type_name]
    y_axes: []
    listen:
      Period 1 (Left): income_statement.accounting_period_ending_month
    row: 7
    col: 0
    width: 6
    height: 2
  - title: Gross Profit ($)
    name: Gross Profit ($_)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: Income,Cost of Goods Sold
    sorts: [gross_profit desc]
    limit: 500
    dynamic_fields: [{table_calculation: gross_profit, label: Gross Profit, expression: "sum(if(${income_statement.account_type_name}\
          \ = \"Income\",${income_statement.sum_converted_amount},0)) \n+ \nsum(if(${income_statement.account_type_name}\
          \ = \"Cost of Goods Sold\",${income_statement.sum_converted_amount},0))\
          \ \n", value_format: !!null '', value_format_name: usd_0, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#3EB0D5"
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount, income_statement.account_type_name]
    y_axes: []
    listen:
      Period 2 (Right): income_statement.accounting_period_ending_month
    row: 5
    col: 12
    width: 6
    height: 2
  - title: Revenue (%)
    name: Revenue (%_)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: Income
    sorts: [income_statement.sum_converted_amount desc]
    limit: 500
    dynamic_fields: [{table_calculation: calculation_1, label: Calculation 1, expression: "${income_statement.sum_converted_amount}/${income_statement.sum_converted_amount}",
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#3EB0D5"
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount]
    y_axes: []
    listen:
      Period 2 (Right): income_statement.accounting_period_ending_month
    row: 2
    col: 18
    width: 6
    height: 3
  - title: Operating Profit ($)
    name: Operating Profit ($)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: Cost of Goods Sold,Income,Expense
    sorts: [operating_profit desc]
    limit: 500
    dynamic_fields: [{table_calculation: operating_profit, label: Operating Profit,
        expression: "sum(if(${income_statement.account_type_name} = \"Income\",${income_statement.sum_converted_amount},0))\
          \ \n+ \nsum(if(${income_statement.account_type_name} = \"Cost of Goods Sold\"\
          ,${income_statement.sum_converted_amount},0))\n+\nsum(if(${income_statement.account_type_name}\
          \ = \"Expense\",${income_statement.sum_converted_amount},0))\n", value_format: !!null '',
        value_format_name: usd_0, _kind_hint: measure, _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#E57947"
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount, income_statement.account_type_name]
    y_axes: []
    listen:
      Period 1 (Left): income_statement.accounting_period_ending_month
    row: 9
    col: 0
    width: 6
    height: 2
  - title: Operating Profit ($)
    name: Operating Profit ($_)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: Cost of Goods Sold,Income,Expense
    sorts: [operating_profit desc]
    limit: 500
    dynamic_fields: [{table_calculation: operating_profit, label: Operating Profit,
        expression: "sum(if(${income_statement.account_type_name} = \"Income\",${income_statement.sum_converted_amount},0))\
          \ \n+ \nsum(if(${income_statement.account_type_name} = \"Cost of Goods Sold\"\
          ,${income_statement.sum_converted_amount},0))\n+\nsum(if(${income_statement.account_type_name}\
          \ = \"Expense\",${income_statement.sum_converted_amount},0))\n", value_format: !!null '',
        value_format_name: usd_0, _kind_hint: measure, _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#3EB0D5"
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount, income_statement.account_type_name]
    y_axes: []
    listen:
      Period 2 (Right): income_statement.accounting_period_ending_month
    row: 7
    col: 12
    width: 6
    height: 2
  - title: Net Income ($)
    name: Net Income ($)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: ''
    sorts: [net_income desc]
    limit: 500
    dynamic_fields: [{table_calculation: net_income, label: Net Income, expression: "sum(if(${income_statement.account_type_name}\
          \ = \"Income\",${income_statement.sum_converted_amount},0)) \n+ \nsum(if(${income_statement.account_type_name}\
          \ = \"Cost of Goods Sold\",${income_statement.sum_converted_amount},0))\n\
          +\nsum(if(${income_statement.account_type_name} = \"Expense\",${income_statement.sum_converted_amount},0))\n\
          +\nsum(if(${income_statement.account_type_name} = \"Other Expense\",${income_statement.sum_converted_amount},0))\n\
          +\nsum(if(${income_statement.account_type_name} = \"Other Income\",${income_statement.sum_converted_amount},0))\n",
        value_format: !!null '', value_format_name: usd_0, _kind_hint: measure, _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#E57947"
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount, income_statement.account_type_name]
    y_axes: []
    listen:
      Period 1 (Left): income_statement.accounting_period_ending_month
    row: 11
    col: 0
    width: 6
    height: 2
  - title: Net Income ($)
    name: Net Income ($_)
    model: netsuite
    explore: income_statement
    type: single_value
    fields: [income_statement.account_type_name, income_statement.sum_converted_amount]
    filters:
      income_statement.account_type_name: ''
    sorts: [income_statement.sum_converted_amount desc]
    limit: 500
    dynamic_fields: [{table_calculation: net_income, label: Net Income, expression: "sum(if(${income_statement.account_type_name}\
          \ = \"Income\",${income_statement.sum_converted_amount},0)) \n+ \nsum(if(${income_statement.account_type_name}\
          \ = \"Cost of Goods Sold\",${income_statement.sum_converted_amount},0))\n\
          +\nsum(if(${income_statement.account_type_name} = \"Expense\",${income_statement.sum_converted_amount},0))\n\
          +\nsum(if(${income_statement.account_type_name} = \"Other Expense\",${income_statement.sum_converted_amount},0))\n\
          +\nsum(if(${income_statement.account_type_name} = \"Other Income\",${income_statement.sum_converted_amount},0))\n",
        value_format: !!null '', value_format_name: usd_0, is_disabled: false, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    custom_color: "#3EB0D5"
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
    show_view_names: false
    show_row_numbers: false
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: transparent
    limit_displayed_rows: false
    series_types: {}
    hidden_fields: [income_statement.sum_converted_amount, income_statement.account_type_name]
    y_axes: []
    listen:
      Period 2 (Right): income_statement.accounting_period_ending_month
    row: 9
    col: 12
    width: 6
    height: 2
  - title: Period 1
    name: Period 1
    model: netsuite
    explore: income_statement
    type: looker_grid
    fields: [income_statement.accounting_period_name]
    sorts: [income_statement.accounting_period_name]
    limit: 500
    total: true
    dynamic_fields: [{table_calculation: account_format_calculation, label: Account
          Format Calculation, expression: "if(${income_statement.account_type_name}\
          \ = \"Income\", 1,\n  if(${income_statement.account_type_name} = \"Cost\
          \ of Goods Sold\", 2,\n    if(${income_statement.account_type_name} = \"\
          Expense\", 3,\n      if(${income_statement.account_type_name} = \"Other\
          \ Income\", 4,\n        if(${income_statement.account_type_name} = \"Other\
          \ Expense\", 5,null)))))", value_format: !!null '', value_format_name: !!null '',
        _kind_hint: dimension, _type_hint: number, is_disabled: true}]
    query_timezone: America/Los_Angeles
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    series_labels:
      income_statement.accounting_period_name: Period Name(s)
    series_text_format:
      income_statement.accounting_period_name:
        align: center
        bold: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: center
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting: []
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    truncate_column_names: false
    custom_color_enabled: true
    custom_color: black
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    series_types: {}
    hidden_fields: []
    y_axes: []
    title_hidden: true
    listen:
      Period 1 (Left): income_statement.accounting_period_ending_month
    row: 0
    col: 0
    width: 12
    height: 2
  filters:
  - name: Period 1 (Left)
    title: Period 1 (Left)
    type: field_filter
    default_value: 2018/08/01 to 2018/08/31
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: income_statement
    listens_to_filters: []
    field: income_statement.accounting_period_ending_month
  - name: Period 2 (Right)
    title: Period 2 (Right)
    type: field_filter
    default_value: 2019/08/01 to 2019/08/31
    allow_multiple_values: true
    required: false
    model: netsuite
    explore: income_statement
    listens_to_filters: []
    field: income_statement.accounting_period_ending_month
