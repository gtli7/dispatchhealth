connection: "data-warehouse-stg"

# include: "/redshift_stg/*.view.lkml"
include: "/redshift_stg/*.view.lkml"

explore: diversions_final_redshift {
  join: onscene_time {
    relationship: one_to_one
    sql_on: ${diversions_final_redshift.care_request_id} = ${onscene_time.care_request_id} ;;
  }
}

# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }
