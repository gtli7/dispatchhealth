connection: "intraday"

include: "target_staffing_intra.view.lkml"
include: "channel_items_intra.view.lkml"
include: "insurance_classifications_intra.view.lkml"
include: "cars_intra.view.lkml"
include: "intraday_shift_teams.view.lkml"
include: "intraday_potential_care_requests.view.lkml"
include: "last_care_request_etc_intra.view.lkml"
include: "intraday_care_requests.view.lkml"
include: "service_lines_intra.view.lkml"
include: "primary_payer_dimensions_intra.view.lkml"
include: "insurance_plans_intra.view.lkml"
include: "markets_intra.view.lkml"
include: "timezones_intra.view.lkml"

explore:  intraday_shift_teams {

  join: intraday_care_requests {
    sql_on: ${intraday_care_requests.shift_team_id} = ${intraday_shift_teams.shift_team_id}
    and ${intraday_care_requests.updated_raw} > current_date - interval '2 day' and ${intraday_care_requests.service_line_id} not in('15');;
  }

  join: intraday_potential_care_requests {
    relationship: one_to_many
    sql_on: ${markets_intra.id} = ${intraday_potential_care_requests.market_id} AND
    ${intraday_potential_care_requests.created_raw} > current_date - interval '2 day' ;;
  }

  join: primary_payer_dimensions_intra {
    sql_on: ${intraday_care_requests.package_id} = ${primary_payer_dimensions_intra.insurance_package_id} ;;
  }
  join: insurance_plans_intra {
    sql_on: ${insurance_plans_intra.package_id} = ${intraday_care_requests.package_id} ;;
  }
  join: insurance_classifications_intra {
    sql_on: ${insurance_classifications_intra.id} = ${insurance_plans_intra.insurance_classification_id} ;;
  }
  join: cars_intra {
    sql_on: ${intraday_shift_teams.car_id} = ${cars_intra.id} ;;
  }
  join: markets_intra {
    sql_on: ${markets_intra.id}= ${cars_intra.market_id} ;;
  }
  join: timezones_intra {
    sql_on: ${markets_intra.sa_time_zone}=${timezones_intra.rails_tz} ;;
  }
  join: channel_items_intra {
    sql_on: ${intraday_care_requests.channel_item_id} =${channel_items_intra.id} ;;
  }
  join: last_care_request_etc_intra {
    relationship: one_to_one
    sql_on: ${intraday_shift_teams.shift_team_id} = ${last_care_request_etc_intra.shift_team_id} ;;
  }

}

explore:  intraday_care_requests {
  sql_always_where: ${updated_raw} > current_date - interval '1 day';;

  join: intraday_shift_teams {
    sql_on: ${intraday_care_requests.shift_team_id} = ${intraday_shift_teams.shift_team_id};;
  }

  join: last_care_request_etc_intra {
    relationship: one_to_one
    sql_on: ${intraday_shift_teams.shift_team_id} = ${last_care_request_etc_intra.shift_team_id} ;;
  }

  join: primary_payer_dimensions_intra {
    sql_on: ${intraday_care_requests.package_id} = ${primary_payer_dimensions_intra.insurance_package_id} ;;
  }
  join: insurance_plans_intra {
    sql_on: ${insurance_plans_intra.package_id} = ${intraday_care_requests.package_id} ;;
  }
  join: insurance_classifications_intra {
    sql_on: ${insurance_classifications_intra.id} = ${insurance_plans_intra.insurance_classification_id} ;;
  }
  join: cars_intra {
    sql_on: ${intraday_shift_teams.car_id} = ${cars_intra.id} ;;
  }
  join: markets_intra {
    sql_on: ${markets_intra.id}= ${intraday_care_requests.market_id} ;;
  }
  join: timezones_intra {
    sql_on: ${markets_intra.sa_time_zone}=${timezones_intra.rails_tz} ;;
  }
  join: channel_items_intra {
    sql_on: ${intraday_care_requests.channel_item_id} =${channel_items_intra.id} ;;
  }

  join: service_lines_intra {
    sql_on: ${intraday_care_requests.service_line_id}::int =${service_lines_intra.id} ;;
  }
}

explore:  intraday_care_requests_full {
  from: intraday_care_requests
  join: intraday_shift_teams {
    sql_on: ${intraday_care_requests_full.shift_team_id} = ${intraday_shift_teams.shift_team_id};;
  }
  join: primary_payer_dimensions_intra {
    sql_on: ${intraday_care_requests_full.package_id} = ${primary_payer_dimensions_intra.insurance_package_id} ;;
  }
  join: insurance_plans_intra {
    sql_on: ${insurance_plans_intra.package_id} = ${intraday_care_requests_full.package_id} ;;
  }
  join: insurance_classifications_intra {
    sql_on: ${insurance_classifications_intra.id} = ${insurance_plans_intra.insurance_classification_id} ;;
  }
  join: cars_intra {
    sql_on: ${intraday_shift_teams.car_id} = ${cars_intra.id} ;;
  }
  join: markets_intra {
    sql_on: ${markets_intra.id}= ${intraday_care_requests_full.market_id} ;;
  }
  join: timezones_intra {
    sql_on: ${markets_intra.sa_time_zone}=${timezones_intra.rails_tz} ;;
  }
  join: channel_items_intra {
    sql_on: ${intraday_care_requests_full.channel_item_id} =${channel_items_intra.id} ;;
  }
}

explore: target_staffing_intra {
  join: markets_intra {
    sql_on: ${markets_intra.id}= ${target_staffing_intra.market_id} ;;
  }
  join: cars_intra {
    sql_on: ${markets_intra.id} = ${cars_intra.market_id} ;;
  }

  join: intraday_shift_teams {
    sql_on: ${cars_intra.id} = ${intraday_shift_teams.car_id}
      and ${intraday_shift_teams.start_month}=${target_staffing_intra.month_month}
      and  ${intraday_shift_teams.start_day_of_week} = ${target_staffing_intra.dow};;
  }
}
