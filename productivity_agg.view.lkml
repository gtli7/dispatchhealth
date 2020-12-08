# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: productivity_agg {

  derived_table: {
    sql_trigger_value:  SELECT MAX(care_request_id) FROM ${care_request_flat.SQL_TABLE_NAME} where created_date > current_date - interval '2 days';;
    indexes: ["start", "name_adj"]

    explore_source: shift_teams {
      column: start { field: shift_teams.start_date}
      column: sum_shift_hours_no_arm_advanced { field:  shift_teams.sum_shift_hours_no_arm_advanced_only}
      column: complete_count { field: care_request_flat.complete_count }
      column: complete_count_no_arm_advanced { field: care_request_flat.complete_count_no_arm_only }
      column: count_wmfr_billable { field: care_requests.count_wmfr_billable }
      column: count_smfr_billable { field: care_requests.count_smfr_billable }
      column: complete_count_advanced { field: care_request_flat.complete_count_advanced }
      column: productivity {}
      column: sum_goal_volume {}
      column: id_adj { field: markets.id_adj }
      column: name_adj { field: markets.name_adj }
      column: cpr_market { field: markets.cpr_market }
      column: count_complete_overflow { field: care_request_flat.count_complete_overflow }
      column: escalated_on_scene_count { field: care_request_flat.escalated_on_scene_count }
      column: complete_count_asymptomatic_covid_testing { field: care_request_flat.complete_count_asymptomatic_covid_testing }
      column: complete_count_communicable_protocol { field: care_request_flat.complete_count_communicable_protocol }
      filters: {
        field: shift_teams.start_date
        value: "365 days ago for 365 days"
      }
      filters: {
        field: service_lines.name
        value: "-COVID-19 Facility Testing,-Advanced Care"
      }

    }
  }

  dimension_group: start {
    type: time
    timeframes: [
      raw,
      time,
      time_of_day,
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      week,
      month,
      quarter,
      year, day_of_month
    ]
  }

  dimension: complete_count_asymptomatic_covid_testing {
    type: number
  }

  dimension: complete_count_communicable_protocol {
    type: number
  }


  dimension: sum_shift_hours_no_arm_advanced {
    label: "Shift Teams Sum Shift Hours (no arm, advanced or tele)"
    value_format: "0.0"
    type: number
  }

  dimension: after_15_minutes_experiment {
    type: yesno
    sql: ${start_date} >= '2020-09-10' ;;
  }

  measure: total_shift_hours_no_arm_advanced {
    type: sum_distinct
    value_format: "0"
    sql: ${sum_shift_hours_no_arm_advanced} ;;
    sql_distinct_key: concat(${start_date}, ${name_adj}) ;;
  }
  dimension: complete_count {
    type: number
  }
  dimension: complete_count_no_arm_advanced {
    label: "Care Request Flat Complete Count (no arm, advanced or tele)"
    type: number
  }
  measure: total_complete_count_no_arm_advanced {
    type: sum_distinct
    sql: ${complete_count_no_arm_advanced} ;;
    sql_distinct_key: concat(${start_date}, ${name_adj}) ;;
  }

  measure: total_complete_count_asymptomatic {
    type: sum_distinct
    sql: ${complete_count_asymptomatic_covid_testing} ;;
    sql_distinct_key: concat(${start_date}, ${name_adj}) ;;
  }

  measure: total_complete_count_communicable_protocol {
    type: sum_distinct
    sql: ${complete_count_communicable_protocol} ;;
    sql_distinct_key: concat(${start_date}, ${name_adj}) ;;
  }

  measure: total_complete_count_communicable_asymptomatic_protocol {
    type: number
    sql: ${total_complete_count_communicable_protocol}+${total_complete_count_asymptomatic} ;;
  }

  measure: communicable_asymptomatic_protocol_percent {
    type: number
    value_format: "0%"
    sql:case when ${total_complete_count}>0 then${total_complete_count_communicable_asymptomatic_protocol}::float/${total_complete_count}::float else 0 end;;
  }

  measure: asymptomatic_protocol_percent {
    type: number
    value_format: "0%"
    sql:case when ${total_complete_count}>0 then${total_complete_count_asymptomatic}::float/${total_complete_count}::float else 0 end;;
  }

  measure: communicable_protocol_percent {
    type: number
    value_format: "0%"
    sql:case when ${total_complete_count}>0 then${total_complete_count_communicable_protocol}::float/${total_complete_count}::float else 0 end;;
  }

  measure: total_complete_count {
    type: sum_distinct
    sql: ${complete_count} ;;
    sql_distinct_key: concat(${start_date}, ${name_adj}) ;;
  }

  measure: count_distinct_days {
    type: count_distinct
    sql:  ${start_date} ;;
    sql_distinct_key: ${start_date} ;;
  }

  measure: total_productivity {
    type: number
    value_format: "0.00"
    sql: case when ${total_shift_hours_no_arm_advanced}>0 then ${total_complete_count_no_arm_advanced}::float/${total_shift_hours_no_arm_advanced}::float else 0 end ;;
  }
  dimension: count_wmfr_billable {
    type: number
  }
  dimension: count_smfr_billable {
    type: number
  }
  dimension: complete_count_advanced {
    type: number
  }
  dimension: productivity {
    value_format: "0.00"
    type: number
  }
  dimension: sum_goal_volume {
    type: number
  }
  dimension: name_adj {
    description: "Market name where WMFR is included as part of Denver"
  }
  dimension: id_adj {
    type: number
    description: "Market ID"
  }
  dimension: cpr_market {
    label: "Markets Cpr Market (Yes / No)"
    description: "Flag to identify CPR markets (hard-coded)"
    type: yesno
  }
  dimension: count_complete_overflow {
    description: "Count of completed care requests OR on-scene escalations (Not Same Day)"
    type: number
  }
  dimension: escalated_on_scene_count {
    type: number
  }
}
