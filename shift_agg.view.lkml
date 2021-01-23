# If necessary, uncommentf the line below to include explore_source.
# include: "dashboard.model.lkml"

view: shift_agg {
  derived_table: {
    sql_trigger_value:  SELECT MAX(care_request_id) FROM ${care_request_flat.SQL_TABLE_NAME} where created_date > current_date - interval '2 days';;
    indexes: ["shift_start", "name_adj"]
    explore_source: care_requests {
      column: shift_start { field: care_request_flat.shift_start_raw }
      column: name { field: cars.name }
      column: shift_end_time { field: care_request_flat.max_shift_end_time }
      column: last_update_time_time { field: shifts_end_of_shift_times.last_update_time_time }
      column: max_on_scene_time {}
      column: shift_start_first_on_route_diff {}
      column: shift_end_last_cr_diff_adj {}
      column: first_accepted_decimal { field: care_request_flat.first_accepted_decimal }
      column: min_on_route_time {}
      column: app_car_staff { field: cars.app_car_staff }
      column: count_billable_est {}
      column: name_adj { field: markets.name_adj }
      column: id_adj { field:markets.id_adj}
      column: cpr_market { field: markets.cpr_market }
      column: emt_car_staff { field: cars.emt_car_staff }
      column: total_drive_time_minutes_coalesce { field: care_request_flat.total_drive_time_minutes_coalesce }
      column: total_on_scene_time_minutes { field: care_request_flat.total_on_scene_time_minutes }
      filters: {
        field: provider_profiles.position
        value: "advanced practice provider,emt"
      }
      filters: {
        field: care_request_flat.shift_start_date
        value: "365 days ago for 365 days"
      }
      filters: {
        field: service_lines.name
        value: "-Advanced Care,-COVID-19 Facility Testing"
      }
      filters: {
        field: cars.name
        value: "-%Swab%,-%Advanced%,-%MFR%"
      }
    }
  }

  dimension_group:shift_start {
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

  dimension: name {
    label: "Car Name"
  }

  dimension: shift_end_time {
    description: "The local date/time of a shift end"
    type: date_time
  }

  dimension: last_update_time_time {
    description: "The local date and time when the care request team is back at the office"
    type: date_time
  }
  dimension: max_on_scene_time {
    label: "Care Requests Last Care Request Completed Time"
    type: number
  }
  dimension: shift_start_first_on_route_diff {
    label: "Care Requests Hours Between Shift Start and First On Route"
    value_format: "0.00"
    type: number
  }
  dimension: shift_end_last_cr_diff_adj {
    label: "Care Requests Hours between Last Patient Seen and Shift End Adj"
    description: "Hours between last completed care request and shift end.  Does not account for requests cancelled while on-route"
    type: number
  }

  dimension: shift_end_last_cr_diff_positive {
    label: "Care Requests Hours between Last Patient Seen and Shift End positive"
    description: "Hours between last completed care request and shift end.  Does not account for requests cancelled while on-route"
    type: number
    sql: ${shift_end_last_cr_diff_adj}*-1 ;;
  }
  dimension: dead_time_after_last_complete_greater_than_60{
    type: yesno
    sql: ${shift_end_last_cr_diff_positive} > 1 ;;
  }
  dimension: first_accepted_decimal {
    description: "The first accepted time of day, represented as a decimal"
    value_format: "0.00"
    type: number
  }
  dimension: min_on_route_time {
    label: "Care Requests First Care Request On Route Time"
    type: number
  }
  dimension: app_car_staff {
    type: string
  }
  dimension: count_billable_est {
    description: "Count of completed care requests OR on-scene escalations"
    type: number
  }
  dimension: name_adj {
    label: "Market Name"
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
  dimension: emt_car_staff {
    label: "DHMT Car Staff"
    type: string
  }
  dimension: total_drive_time_minutes_coalesce {
    description: "google drive time if available, otherwise regular drive time"
    value_format: "0.0"
    type: number
  }
  dimension: total_on_scene_time_minutes {
    description: "The sum of minutes between complete time and on scene time"
    value_format: "0.00"
    type: number
  }

  dimension: shift_hours {
    type: number
    value_format: "0.0"
    sql:EXTRACT(EPOCH FROM (${shift_end_time}::timestamp- ${shift_start_time}::timestamp))::float/(60.0*60.0);;
  }

  dimension: shift_productivity {
    type: number
    sql:case when ${shift_hours} >0 then
      ${count_billable_est}::float / ${shift_hours}::float else 0 end;;
  }

  dimension: productive_shift_hours {
    type: number
    sql: ${shift_hours} + ${shift_end_last_cr_diff_adj} - ${shift_start_first_on_route_diff};;
  }

  dimension: shift_productivity_no_dead_time {
    type: number
    sql:
    case when (${shift_hours} + ${shift_end_last_cr_diff_adj} - ${shift_start_first_on_route_diff}) >0
    ${count_billable_est} / (${shift_hours} + ${shift_end_last_cr_diff_adj} - ${shift_start_first_on_route_diff}) else 0 end;;
  }

  dimension: primary_key {
    type: string
    sql: concat(${shift_start_time}, ${name}, ${name_adj}, ${shift_end_time}) ;;
  }


  dimension: care_request_assigned_at_shift_start {
    type: yesno
    sql: ${first_accepted_decimal} < ${shift_start_time_decimal} ;;
  }

  dimension: shift_start_time_decimal{
    type: number
    value_format: "0.00"
    sql: (CAST(EXTRACT(HOUR FROM ${shift_start_time}::timestamp) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${shift_start_time}::timestamp ) AS FLOAT)) / 60) ;;
  }

  dimension: minutes_early_or_late {
    type: yesno
    sql: diff_minutes(${last_update_time_time}, ${shift_end_time});;
  }

  dimension: hours_to_first_assignment {
    type: number
    sql: ${first_accepted_decimal} - (extract(hour from timestamp ${shift_start_time}::timestamp)+ extract(minute from timestamp ${shift_start_time}::timestamp));;
  }

  dimension: dead_time {
    type: number
    value_format: "0"
    sql: ${shift_hours}*60 - ${total_drive_time_minutes_coalesce} -${total_on_scene_time_minutes} ;;
  }

  dimension: dead_time_percent {
    type: number
    value_format: "0%"
    sql: case when ${shift_hours} >0 then
      ${dead_time}::float/(${shift_hours}*60)::float else 0 end ;;
  }

  measure: sum_visits{
    type: sum_distinct
    value_format: "0"
    sql: ${count_billable_est} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_hours{
    type: sum_distinct
    value_format: "0"
    sql: ${shift_hours} ;;
    sql_distinct_key: ${primary_key} ;;
  }


  measure: avg_shift_productivity {
    type: number
    value_format: "0.00"
    sql: case when ${sum_hours}::float>0 then ${sum_visits}::float/ ${sum_hours}::float else 0 end;;

  }


  measure: avg_dead_time{
    type: average_distinct
    value_format: "0"
    sql: ${dead_time} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: avg_dead_time_percent{
    type: average_distinct
    value_format: "0%"
    sql: ${dead_time_percent} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: avg_shift_start_first_on_route_diff{
    label: "DT Start of Shift (avg)"
    type: average_distinct
    value_format: "0"
    sql: ${shift_start_first_on_route_diff}*60 ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: avg_shift_start_first_on_route_diff_w_patient{
    label: "(W/Assigned) DT Start of Shift (avg)"
    type: average_distinct
    value_format: "0"
    sql: ${shift_start_first_on_route_diff}*60 ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: care_request_assigned_at_shift_start
      value: "yes"
    }
  }

  measure: count_distinct_shifts_w_assigned{
    type: count_distinct
    value_format: "0"
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key};;
    filters: {
      field: care_request_assigned_at_shift_start
      value: "yes"
    }
  }

  measure: percent_assigned_shifts {
    label: "Percent w/Patient Assigned at Start of Shift"
    type: number
    value_format: "0%"
    sql: case when ${count_distinct_shifts}::float>0 then ${count_distinct_shifts_w_assigned}::float/ ${count_distinct_shifts}::float else 0 end;;
  }

  measure: avg_shift_shift_end_last_cr_diff_positive{
    label: "DT End of Shift (avg)"
    type: average_distinct
    value_format: "0"
    sql: ${shift_end_last_cr_diff_positive}::float*60 ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: avg_dead_time_intra_shift{
    label: "DT Intra Shift (avg)"
    type: average_distinct
    value_format: "0"
    sql: ${dead_time_intra_shift} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_total_on_scene_time_minutes {
    label: "Sum of All Of Scene Time"
    type: sum_distinct
    value_format: "0"
    sql: ${total_on_scene_time_minutes} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_total_drivetime_minutes {
    label: "Sum of All Of Drive Time"
    type: sum_distinct
    value_format: "0"
    sql: ${total_drive_time_minutes_coalesce} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: count_distinct_shifts {
    type: count_distinct
    value_format: "0"
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: count_distinct_dead_time_after_last_complete_greater_than_60 {
    type: count_distinct
    value_format: "0"
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: [dead_time_after_last_complete_greater_than_60: "yes"]
  }


  measure: avg_on_scene_hours{
    label: "On-Scene Time Minutes (avg)"
    type: number
    value_format: "0"
    sql: case when ${productivity_agg.total_complete_count_no_arm_advanced} >0 then
      ${sum_total_on_scene_time_minutes}::float/${productivity_agg.total_complete_count_no_arm_advanced}::float else 0 end ;;
  }

  measure: avg_drivetime_hours{
    label: "Drivetime Minutes (avg)"
    type: number
    value_format: "0"
    sql: case when ${productivity_agg.total_complete_count_no_arm_advanced} >0  then ${sum_total_drivetime_minutes}::float/${productivity_agg.total_complete_count_no_arm_advanced}::float else 0 end;;
  }




  dimension: dead_time_intra_shift {
    type: number
    sql: (${shift_hours}*60 - ${total_drive_time_minutes_coalesce} -${total_on_scene_time_minutes} + ${shift_end_last_cr_diff_adj}*60 - ${shift_start_first_on_route_diff}*60) ;;
  }


}
