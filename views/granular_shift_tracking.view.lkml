view: granular_shift_tracking {
  sql_table_name: looker_scratch.granular_shift_tracking ;;

  dimension: accept_time_of_day {
    type: number
    sql: ${TABLE}."accept_time_of_day" ;;
  }


  dimension: accept_date {
    type: date
    sql: ${TABLE}."accept_date" ;;
  }

  measure: min_accept_date {
    type: date
    sql: min(${accept_date}) ;;
  }

  measure: max_accept_date {
    type: date
    sql: max(${accept_date}) ;;
  }

  measure: max_accept_time_of_day {
    type: number
    sql: max(${accept_time_of_day}) ;;
  }

  measure: min_accept_time_of_day {
    type: number
    sql: min(${accept_time_of_day}) ;;
  }

  dimension: app_car_staff {
    type: string
    sql: ${TABLE}."app_car_staff" ;;
  }

  dimension: car_id {
    type: number
    sql: ${TABLE}."car_id" ;;
  }

  dimension: car_name {
    type: string
    sql: ${TABLE}."car_name" ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
  }


  measure: care_request_id_agg {
    type: string
    sql: ARRAY_AGG(${care_request_id}) ;;

  }

  measure: address_name_agg {
    type: string
    sql: ARRAY_AGG(distinct ${address_name}) ;;

  }


  dimension: complete_bool {
    type: yesno
    sql: ${TABLE}."complete_bool"=1 ;;
  }

  dimension: complete_time_of_day {
    type: number
    sql: ${TABLE}."complete_time_of_day" ;;
  }

  measure: max_complete_time_of_day {
    type: number
    sql: max(${complete_time_of_day}) ;;
  }

  measure: min_complete_time_of_day {
    type: number
    sql: min(${complete_time_of_day}) ;;
  }

  dimension: diff_on_route_to_last_action {
    type: number
    sql: ${TABLE}."diff_on_route_to_last_action" ;;
  }

  measure: max_diff_on_route_to_last_action {
    type: number
    sql: max(${diff_on_route_to_last_action}) ;;
  }

  measure: min_diff_on_route_to_last_action {
    type: number
    sql: min(${diff_on_route_to_last_action}) ;;
  }


  dimension: drive_time{
    type: number
    value_format: "0.00"

    sql: ${TABLE}."drive_time_minutes"::float/60.0 ;;
  }

  measure: max_drive_time {
    value_format: "0.00"

    type: number
    sql: max(${drive_time}) ;;
  }

  measure: min_drive_time {
    value_format: "0.00"

    type: number
    sql: min(${drive_time}) ;;
  }


  dimension: emt_car_staff {
    type: string
    sql: ${TABLE}."emt_car_staff" ;;
  }

  dimension: first_accepted_bool {
    type: yesno
    sql: ${TABLE}."first_accepted_bool"=1 ;;
  }
  measure: max_first_accepted_bool{
    type: number
    sql: max(${TABLE}."first_accepted_bool") ;;

  }

  dimension: last_care_request_bool {
    type: yesno
    sql: ${TABLE}."last_care_request_bool"=1 ;;
  }

  measure: max_last_care_request_bool{
    type: number
    sql: max(${TABLE}."last_care_request_bool") ;;

  }

  dimension: last_update_time_time_of_day {
    type: number
    sql: ${TABLE}."last_update_time_time_of_day" ;;
  }

  measure: max_last_update_time_time_of_day{
    type: number
    sql: max(${last_update_time_time_of_day}) ;;
  }

  measure: min_last_update_time_time_of_day {
    type: number
    sql: min(${last_update_time_time_of_day}) ;;
  }


  dimension: diff_between_last_update_shift_end {
    type: number
    sql: ${shift_end_time_of_day}-${last_update_time_time_of_day} ;;
  }

  measure: max_diff_between_last_update_shift_end{
    type: number
    sql: max(${diff_between_last_update_shift_end}) ;;
  }

  measure: min_diff_between_last_update_shift_end {
    type: number
    sql: min(${diff_between_last_update_shift_end}) ;;
  }


  dimension: diff_between_complete_shift_end {
    type: number
    sql: ${shift_end_time_of_day}-${complete_time_of_day} ;;
  }

  measure: max_diff_between_complete_shift_end{
    type: number
    sql: max(${diff_between_complete_shift_end}) ;;
  }

  measure: min_diff_between_complete_shift_end {
    type: number
    sql: min(${diff_between_complete_shift_end}) ;;
  }



  dimension: diff_between_complete_last_action {
    type: number
    sql: ${last_update_time_time_of_day}-${complete_time_of_day} ;;
  }

  measure: max_diff_between_complete_last_action{
    type: number
    sql: max(${diff_between_complete_last_action}) ;;
  }

  measure: min_diff_between_complete_last_action {
    type: number
    sql: min(${diff_between_complete_last_action}) ;;
  }


  dimension: on_route_time_of_day {
    type: number
    sql: ${TABLE}."on_route_time_of_day" ;;
  }


  measure: max_on_route_time_of_day{
    type: number
    sql: max(${on_route_time_of_day}) ;;
  }

  measure: min_on_route_time_of_day {
    type: number
    sql: min(${on_route_time_of_day}) ;;
  }


  dimension: on_scene_time {
    type: number
    sql: ${TABLE}."on_scene_minutes"::float/60.0 ;;
  }

  measure: max_on_scene_time{
    type: number
    value_format: "0.00"
    sql: max(${on_scene_time}) ;;
  }

  measure: min_on_scene_time {
    type: number
    value_format: "0.00"

    sql: min(${on_scene_time}) ;;
  }


  dimension: on_scene_time_of_day {
    type: number
    sql: ${TABLE}."on_scene_time_of_day" ;;
  }

  measure: max_on_scene_time_of_day{
    type: number
    sql: max(${on_scene_time_of_day}) ;;
  }

  measure: min_on_scene_time_of_day {
    type: number
    sql: min(${on_scene_time_of_day}) ;;
  }

  dimension: patient_assigned_bool {
    type: yesno
    sql: ${TABLE}."patient_assigned_bool"=1;;
  }

  measure: max_patient_assigned_bool{
    type: number
    sql: max(${TABLE}."patient_assigned_bool") ;;

  }

  dimension: patient_assigned_at_start_bool {
    type: yesno
    sql: ${TABLE}."patient_assigned_bool"=1 and ${TABLE}."first_accepted_bool"=1;;
  }

  measure: max_patient_assigned_at_start_bool{
    type: number
    sql: max(case when ( ${TABLE}."patient_assigned_bool"=1 and ${TABLE}."first_accepted_bool"=1) then 1 else 0 end) ;;

  }

  dimension: prior_complete_time {
    type: number
    sql: ${TABLE}."prior_complete_time" ;;
  }

  measure: max_prior_complete_time{
    type: number
    sql: max(${prior_complete_time}) ;;
  }

  measure: min_prior_complete_time {
    type: number
    sql: min(${prior_complete_time}) ;;
  }

  dimension: resolved_reason_full {
    type: string
    sql: ${TABLE}."resolved_reason_full" ;;
  }

  dimension: address_lat {
    type: string
    sql: ${TABLE}."address_lat" ;;
  }
  dimension: address_name {
    type: string
    sql: ${TABLE}."address_name" ;;
  }

  dimension_group: shift {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."shift_date" ;;
  }

  dimension: shift_end_time_of_day {
    type: number
    sql: ${TABLE}."shift_end_time_of_day" ;;
  }

  measure: max_shift_end_time_of_day{
    type: number
    sql: max(${shift_end_time_of_day}) ;;
  }

  measure: min_shift_end_time_of_day {
    type: number
    sql: min(${shift_end_time_of_day}) ;;
  }

  dimension: shift_start_time_of_day {
    type: number
    sql: ${TABLE}."shift_start_time_of_day" ;;
  }

  measure: max_shift_start_time_of_day{
    type: number
    sql: max(${shift_start_time_of_day}) ;;
  }

  measure: min_shift_start_time_of_day {
    type: number
    sql: min(${shift_start_time_of_day}) ;;
  }

  dimension: shift_team_id {
    type: number
    sql: ${TABLE}."shift_team_id" ;;
  }

  dimension: primary_key {
    type: number
    sql: concat(${shift_date}, ${shift_team_id}, ${care_request_id});;
  }

  dimension: primary_key_shift {
    type: number
    sql: concat(${shift_date}, ${shift_team_id});;
  }

  dimension: shift_time {
    type: number
    sql: ${shift_end_time_of_day}-${shift_start_time_of_day} ;;
  }

  measure: max_shift_time{
    type: number
    sql: max(${shift_end_time_of_day}) ;;
  }

  measure: min_shift_time {
    type: number
    sql: min(${shift_end_time_of_day}) ;;
  }

  measure: avg_drive_time_minutes {
    type: average_distinct
    value_format: "0"
    sql: ${drive_time}*60 ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: avg_on_scene_time_minutes {
    type: average_distinct
    value_format: "0"
    sql: ${on_scene_time} *60;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_drive_time_minutes {
    type: sum_distinct
    value_format: "0"
    sql: ${drive_time}*60 ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_on_scene_time_minutes {
    type: sum_distinct
    value_format: "0"
    sql: ${on_scene_time} *60;;
    sql_distinct_key: ${primary_key} ;;
  }




  measure: sum_shift_time{
    type: sum_distinct
    value_format: "0"
    sql: ${shift_time} ;;
    sql_distinct_key: ${primary_key_shift} ;;
  }

  measure: sum_time_since_last_action{
    type: sum_distinct
    value_format: "0.00"
    sql: ${diff_on_route_to_last_action} ;;
    sql_distinct_key: ${primary_key} ;;
  }


  measure: count_distinct_shifts {
    type: count_distinct
    value_format: "0"
    sql: ${primary_key_shift} ;;
    sql_distinct_key: ${primary_key_shift} ;;
  }

  measure: count_distinct_care_requests {
    type: count_distinct
    value_format: "0"
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: count_distinct_care_requests_w_assigned {
    type: count_distinct
    value_format: "0"
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: patient_assigned_bool
      value: "yes"
    }
  }


  measure: count_distinct_shifts_w_assigned {
    type: count_distinct
    value_format: "0"
    sql: ${primary_key_shift} ;;
    sql_distinct_key: ${primary_key_shift} ;;
    filters: {
      field: patient_assigned_at_start_bool
      value: "yes"
    }
  }




  measure:  sum_dead_time_proxy_minutes{
    value_format: "0"
    type: number
    sql: ${sum_shift_time}*60 -${sum_drive_time_minutes}-${sum_on_scene_time_minutes} ;;
  }

  measure: avg_dead_time_proxy_minutes {
    value_format: "0"
    type: number
    sql: ${sum_dead_time_proxy_minutes}/${count_distinct_shifts} ;;
  }

  measure:  sum_dead_time{
    type: number
    sql: ${sum_diff_on_route_to_last_action}+${sum_diff_between_last_update_shift_end}+${sum_drive_time_home} ;;
  }


  measure: sum_diff_on_route_to_last_action{
    type: sum_distinct
    value_format: "0.00"
    sql: ${diff_on_route_to_last_action} ;;
    sql_distinct_key: ${primary_key} ;;

  }

  measure: sum_deadtime_start_of_shift_minutes{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_on_route_to_last_action}*60 ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: first_accepted_bool
      value: "yes"
    }
  }

  measure: sum_deadtime_end_of_shift_minutes{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_between_complete_shift_end}*60 ;;
    sql_distinct_key: ${primary_key_shift} ;;
    filters: {
      field: last_care_request_bool
      value: "yes"
    }

  }

  measure: avg_deadtime_end_of_shift_minutes{
    value_format: "0"
    type: number
    sql: ${sum_deadtime_end_of_shift_minutes}/${count_distinct_shifts} ;;
  }

  measure: sum_dead_time_at_office_after_shift{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_between_last_update_shift_end}*60 ;;
    sql_distinct_key: ${primary_key_shift} ;;

  }

  measure: avg_dead_time_at_office_after_shift{
    value_format: "0"
    type: number
    sql: ${sum_dead_time_at_office_after_shift}/${count_distinct_shifts} ;;
  }

  measure: sum_drive_back_to_office{
    type: number
    value_format: "0"
    sql: ${sum_deadtime_end_of_shift_minutes}-${sum_dead_time_at_office_after_shift};;

  }

  measure: avg_drive_back_to_office{
    value_format: "0"
    type: number
    sql: ${sum_drive_back_to_office}/${count_distinct_shifts} ;;
  }




  measure: avg_deadtime_start_of_shift_minutes{
    value_format: "0"
    type: number
    sql: ${sum_deadtime_start_of_shift_minutes}/${count_distinct_shifts} ;;
}

  measure: sum_deadtime_start_of_shift_minutes_w_assigned{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_on_route_to_last_action}*60 ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: patient_assigned_at_start_bool
      value: "yes"
    }
  }

  measure: avg_deadtime_start_of_shift_minutes_w_assigned{
    value_format: "0"
    type: number
    sql: ${sum_deadtime_start_of_shift_minutes_w_assigned}/${count_distinct_shifts_w_assigned} ;;
  }


  measure: sum_dead_time_intra_minutes{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_on_route_to_last_action}*60;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: last_care_request_bool
      value: "no"
    }
    filters: {
      field: first_accepted_bool
      value: "no"
    }
  }

  measure: avg_dead_time_intra_minutes{
    value_format: "0"
    type: number
    sql: ${sum_dead_time_intra_minutes}/${count_distinct_shifts} ;;
  }
  measure: complete_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: [complete_bool: "yes"]
  }


}
