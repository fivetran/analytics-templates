connection: "private_internal" #this needs to be personalized

include: "*.view.lkml"                       # include all views in this project
include: "*.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# fiscal_month_offset:0   #customize based on your company's fiscal calendar set up

explore: balance_sheet {
  label: "Balance Sheet"
}

explore: income_statement {
  label: "Income Statement"
}

explore: transaction_details {
  label: "Transaction Details"
}
