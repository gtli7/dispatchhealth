connection: "dashboard"

include: "care_request_flat.view.lkml"
include: "care_requests_user.view.lkml"
include: "most_recent_intraday.view.lkml"
# include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

explore: care_requests_user {

  sql_always_where: ${deleted_raw} IS NULL AND
  (${care_request_flat.secondary_resolved_reason} NOT IN ('Test Case', 'Duplicate') OR ${care_request_flat.secondary_resolved_reason} IS NULL) ;;

  join: care_request_flat {
    relationship: one_to_one
    sql_on: ${care_request_flat.care_request_id} = ${care_requests_user.id} ;;
  }

}

explore: most_recent_intraday {}
