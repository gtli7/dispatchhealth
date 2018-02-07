connection: "dashboard"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

explore: care_requests {

  access_filter: {
    field: markets.name
    user_attribute: "market_name"
  }

  join: credit_cards {
    relationship: many_to_one
    sql_on: ${care_requests.id} = ${credit_cards.care_request_id} ;;
  }

  join: markets {
    relationship: many_to_one
    sql_on: ${care_requests.market_id} = ${markets.id} ;;
  }

  join: care_request_providers {
    relationship: one_to_many
    sql_on: ${care_requests.id} = ${care_request_providers.care_request_id} ;;
  }

  join: provider_profiles {
    relationship: many_to_one
    sql_on: ${care_request_providers.user_id} = ${provider_profiles.user_id} ;;
  }
}
