# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: granular_full_shift_agg {
  derived_table: {
    sql_trigger_value:  SELECT MAX(care_request_id) FROM ${care_request_flat.SQL_TABLE_NAME} where created_date > current_date - interval '2 days';;
    explore_source: productivity_agg {
      column: car_name { field: granular_shift_tracking_agg.car_name }
      column: market_name_adj { field: granular_shift_tracking_agg.market_name_adj }
      column: shift_date { field: granular_shift_tracking_agg.shift_date }
      column: app_car_staff { field: granular_shift_tracking_agg.app_car_staff }
      column: dhmt_car_staff { field: granular_shift_tracking_agg.emt_car_staff }
      column: shift_team_id { field: granular_shift_tracking_agg.shift_team_id }
      column: shift_productivity { field: granular_shift_tracking_agg.shift_productivity }
      column: overflow_percent { field: funnel_agg.overflow_percent }
      column: distinct_shifts { field: granular_shift_tracking_agg.count_distinct_shifts }
      column: sum_shift_time_hours { field: granular_shift_tracking_agg.sum_shift_time_hours }
      column: sum_complete_count { field: granular_shift_tracking_agg.sum_complete_count }
      column: deadtime_start_of_shift_minutes { field: granular_shift_tracking_agg.avg_deadtime_start_of_shift_minutes }
      column: percent_assigned_at_start { field: granular_shift_tracking_agg.percent_assigned_at_start }
      column: deadtime_start_of_shift_minutes_w_assigned { field: granular_shift_tracking_agg.avg_deadtime_start_of_shift_minutes_w_assigned }
      column: dead_time_intra_minutes { field: granular_shift_tracking_agg.avg_dead_time_intra_minutes }
      column: dead_time_intra_minutes_w_assigned { field: granular_shift_tracking_agg.avg_dead_time_intra_minutes_w_assigned }
      column: deadtime_end_of_shift_minutes { field: granular_shift_tracking_agg.avg_deadtime_end_of_shift_minutes }
      column: drive_back_to_office_minutes { field: granular_shift_tracking_agg.avg_drive_back_to_office_minutes }
      column: dead_time_at_office_after_shift_high_overflow { field: granular_shift_tracking_agg.avg_dead_time_at_office_after_shift_high_overflow }
      column: drive_time_minutes { field: granular_shift_tracking_agg.avg_drive_time_minutes }
      column: on_scene_time_minutes { field: granular_shift_tracking_agg.avg_on_scene_time_minutes }
      column: drive_time_minutes_shift { field: granular_shift_tracking_agg.avg_drive_time_minutes_shift }
      column: on_scene_time_minutes_shift { field: granular_shift_tracking_agg.avg_on_scene_time_minutes_shift }
      column: dead_time_at_office_after_shift { field: granular_shift_tracking_agg.avg_dead_time_at_office_after_shift }
      column: accept_date { field: granular_shift_tracking_agg.min_accept_date }


      filters: {
        field: granular_shift_tracking_agg.shift_date
        value: "180 days ago for 180 days"
      }
    }
  }
  dimension: car_name {}
  dimension: market_name_adj {
    description: "Market name where WMFR is included as part of Denver"
  }
  dimension: shift_date {
    type: date
  }

  dimension: accept_date_diff {
    type: yesno
    sql: ${accept_date} != ${shift_date} ;;
  }

  dimension: accept_date {
    type: date
  }
  dimension: app_car_staff {}
  dimension: dhmt_car_staff {}
  dimension: shift_team_id {
    type: number
  }
  dimension: shift_productivity {
    value_format: "0.00"
    type: number
  }
  dimension: overflow_percent {
    value_format: "0%"
    type: number
  }
  dimension: distinct_shifts {
    value_format: "0"
    type: number
  }
  dimension: sum_shift_time_hours {
    value_format: "0"
    type: number
  }
  dimension: sum_complete_count {
    value_format: "0"
    type: number
  }
  dimension: deadtime_start_of_shift_minutes {
    value_format: "0"
    type: number
  }
  dimension: percent_assigned_at_start {
    value_format: "0%"
    type: number
  }
  dimension: deadtime_start_of_shift_minutes_w_assigned {
    value_format: "0"
    type: number
  }
  dimension: dead_time_intra_minutes {
    value_format: "0"
    type: number
  }
  dimension: dead_time_intra_minutes_w_assigned {
    value_format: "0"
    type: number
  }
  dimension: deadtime_end_of_shift_minutes {
    value_format: "0"
    type: number
  }
  dimension: drive_back_to_office_minutes {
    value_format: "0"
    type: number
  }

  dimension: default_drive_back_to_office {
    type: yesno
    sql:  ${drive_back_to_office_minutes} = 30;;
  }

  dimension: dead_time_at_office_greater_than_0 {
    type: yesno
    sql: ${dead_time_at_office_after_shift}>0 ;;
  }

  dimension:  dead_time_at_office_greater_bands{
    type: number
    sql: round((${dead_time_at_office_after_shift}/10))*10 ;;
  }

  dimension:  dead_time_after_last_complete_bands{
    type: number
    sql: round(((${drive_back_to_office_minutes}+${dead_time_at_office_after_shift})/10))*10  ;;
  }


  dimension: dead_time_at_office_greater_than_30 {
    type: yesno
    sql: ${dead_time_at_office_after_shift}>30 ;;
  }

  dimension: dead_time_after_last_complete_greater_than_60{
    type: yesno
    sql: (${drive_back_to_office_minutes}+${dead_time_at_office_after_shift})>60 ;;
  }
  dimension: dead_time_at_office_after_shift_high_overflow {
    value_format: "0"
    type: number
  }
  dimension: drive_time_minutes {
    value_format: "0"
    type: number
  }
  dimension: on_scene_time_minutes {
    value_format: "0"
    type: number
  }
  dimension: drive_time_minutes_shift {
    value_format: "0"
    type: number
  }
  dimension: on_scene_time_minutes_shift {
    value_format: "0"
    type: number
  }
  dimension: dead_time_at_office_after_shift {
    value_format: "0"
    type: number
  }

  measure:median_deadtime_at_office {
    type: median_distinct
    sql: ${dead_time_at_office_after_shift} ;;
    sql_distinct_key: ${shift_team_id} ;;
    filters: [dead_time_at_office_greater_than_0: "yes"]
  }

  measure:median_deadtime_after_last_complete {
    type: median_distinct
    sql: ${drive_back_to_office_minutes}+${dead_time_at_office_after_shift} ;;
    sql_distinct_key: ${shift_team_id} ;;
    filters: [dead_time_at_office_greater_than_0: "yes"]
  }
  measure:count_dead_time_at_office_greater_than_0  {
    type: count_distinct
    sql: ${shift_team_id} ;;
    sql_distinct_key: ${shift_team_id} ;;
    filters: [dead_time_at_office_greater_than_0: "yes"]
  }

  measure:count_dead_time_at_office_greater_than_30  {
    type: count_distinct
    sql: ${shift_team_id} ;;
    sql_distinct_key: ${shift_team_id} ;;
    filters: [dead_time_at_office_greater_than_30: "yes"]
  }

  measure:count_default_drive_back_to_office {
    type: count_distinct
    sql: ${shift_team_id} ;;
    sql_distinct_key: ${shift_team_id} ;;
    filters: [default_drive_back_to_office : "yes"]
  }

  measure:count_dead_time_after_last_complete_greater_than_60 {
    type: count_distinct
    sql: ${shift_team_id} ;;
    sql_distinct_key: ${shift_team_id} ;;
    filters: [dead_time_after_last_complete_greater_than_60 : "yes"]
  }

  measure:count_distinct_shifts {
    type: count_distinct
    sql: ${shift_team_id} ;;
    sql_distinct_key: ${shift_team_id} ;;
  }
}
