view: granular_shift_tracking_agg {
    derived_table: {
      sql_trigger_value:  SELECT count(*) FROM looker_scratch.granular_shift_tracking where shift_date > current_date - interval '10 days';;
      indexes: ["shift_date", "shift_team_id", "car_name", "market_id", "market_name_adj"]
      explore_source: granular_shift_tracking {
        column: shift_date {}
        column: shift_team_id {}
        column: car_name { field: cars.name }
        column: id { field: cars.id }
        column: address_lat {}
        column: app_car_staff {}
        column: emt_car_staff {}
        column: complete_count {}
        column: care_request_id_agg {}
        column: patient_assigned_at_start_bool {field: granular_shift_tracking.max_patient_assigned_at_start_bool}
        column: last_care_request_bool {field: granular_shift_tracking.max_last_care_request_bool}
        column: patient_assigned_bool {field: granular_shift_tracking.max_patient_assigned_bool}
        column: first_accepted_bool {field: granular_shift_tracking.max_first_accepted_bool}
        column: complete_time_of_day {field: granular_shift_tracking.max_complete_time_of_day}
        column: last_update_time_time_of_day {field: granular_shift_tracking.max_last_update_time_time_of_day}
        column: prior_complete_time {field: granular_shift_tracking.max_prior_complete_time}
        column: shift_end_time_of_day {field: granular_shift_tracking.max_shift_end_time_of_day}
        column: shift_start_time_of_day {field: granular_shift_tracking.max_shift_start_time_of_day}
        column: on_route_time_of_day {field: granular_shift_tracking.min_on_route_time_of_day}
        column: on_scene_time_of_day {field: granular_shift_tracking.min_on_scene_time_of_day}
        column: accept_time_of_day {field: granular_shift_tracking.min_accept_time_of_day}

        column: address_name_agg {}
        column: shift_type { field: shift_types.name}
        column: market_id { field: markets.id }
        column: market_name_adj { field: markets.name_adj }
        #filters: {
        #  field: granular_shift_tracking.shift_team_id
        #  value: "33772,31634,41532,33082,36386,46166,36840,30460,37166,37821,34306,34790,42828,36961,43881,35109,30390,39859,31480,39126,35205,44160,31620,35445,35968,37615,33353,30370,44389"
        #}
        filters: {
          field: cars.name
          value: "-%Swab%,-%Advanced%,-%MFR%"
        }
      }
    }

  dimension_group: shift {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year, day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."shift_date" ;;
  }

    dimension: shift_team_id {
      type: number
    }
    dimension: car_name {}
  dimension: shift_type {}
  dimension: telepresentation {
    type: yesno
    sql: lower( ${shift_type}) like '%telepresentation%';;
  }


    dimension: id {
      type: number
    }
    dimension: address_lat {}
    dimension: app_car_staff {}
    dimension: emt_car_staff {}
    dimension: complete_count {
      type: number
    }
    dimension: care_request_id_agg {
      type: string
    }

    dimension: address_name_agg {
      type: string
    }

    dimension: patient_assigned_at_start_bool {
      type: number
    }
    dimension: last_care_request_bool {
      type: number
    }
    dimension: patient_assigned_bool {
      type: number
    }
    dimension: first_accepted_bool {
      type: number
    }
    dimension: complete_time_of_day {
      type: number
    }

  dimension: accept_time_of_day {
    type: number
  }


    dimension: last_update_time_time_of_day {
      type: number
    }

    dimension: prior_complete_time {
      type: number
    }
    dimension: shift_end_time_of_day {
      type: number
    }
    dimension: shift_start_time_of_day {
      type: number
    }

    dimension: on_route_time_of_day {
      type: number
    }

    dimension: on_scene_time_of_day {
      type: number
    }


  dimension: market_id {
    type: number
  }


  dimension: market_name_adj {
    description: "Market name where WMFR is included as part of Denver"
  }
  dimension: primary_key {
    sql: concat(${address_lat}, ${shift_team_id}, ${on_scene_time_of_day}) ;;
  }
  dimension: primary_key_shift {
    sql:  concat(${shift_team_id}, ${car_name}) ;;
  }
  dimension: on_scene_time {
    sql:${complete_time_of_day}- ${on_scene_time_of_day} ;;

  }
  dimension: drive_time {
    sql:${on_scene_time_of_day}- ${on_route_time_of_day} ;;
  }

  dimension: diff_on_route_to_prior_complete {
    type: number
    sql:${on_route_time_of_day}- ${prior_complete_time};;
  }
  dimension: diff_first_on_route_to_shift_start{
    type: number
    sql:case when ${first_accepted_bool} = 1 then ${on_route_time_of_day}- ${shift_start_time_of_day} else null end;;
  }



  measure: sum_drive_time_minutes {
    type: sum_distinct
    value_format: "0"
    sql: ${drive_time}*60 ;;
    sql_distinct_key: ${primary_key} ;;
  }
  measure: avg_drive_time_minutes {
    type: average_distinct
    value_format: "0"
    sql: ${drive_time}*60 ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: avg_drive_time_minutes_shift {
    type: number
    value_format: "0"
    sql: ${sum_drive_time_minutes}/${count_distinct_shifts} ;;
  }

  measure: sum_on_scene_time_minutes {
    type: sum_distinct
    value_format: "0"
    sql: ${on_scene_time} *60;;
    sql_distinct_key: ${primary_key} ;;
  }
  measure: avg_on_scene_time_minutes {
    type: average_distinct
    value_format: "0"
    sql: ${on_scene_time} *60;;
    sql_distinct_key: ${primary_key} ;;
  }
  measure: avg_on_scene_time_minutes_shift {
    type: number
    value_format: "0"
    sql: ${sum_on_scene_time_minutes}/${count_distinct_shifts} ;;
  }



  dimension: shift_time {
    type: number
    sql: ${shift_end_time_of_day}-${shift_start_time_of_day} ;;
  }
  dimension: diff_between_last_complete_shift_end {
    type: number
    sql: case when ${last_care_request_bool} =1 then ${shift_end_time_of_day}-${complete_time_of_day} else null end ;;
  }

  dimension: diff_between_last_update_shift_end {
    type: number
    sql: case when ${last_care_request_bool}=1 then ${shift_end_time_of_day}-${last_update_time_time_of_day} else null end;;
  }

  dimension: diff_between_last_complete_last_update {
    type: number
    sql: case when ${last_care_request_bool}=1 then ${last_update_time_time_of_day}-${complete_time_of_day} else null end;;
  }
  measure: sum_shift_time_minutes{
    type: sum_distinct
    value_format: "0"
    sql: ${shift_time}*60 ;;
    sql_distinct_key: ${primary_key_shift} ;;
  }

  measure: sum_shift_time_hours{
    type: sum_distinct
    value_format: "0"
    sql: ${shift_time} ;;
    sql_distinct_key: ${primary_key_shift} ;;
  }

  measure:  sum_dead_time_proxy_minutes{
    value_format: "0"
    type: number
    sql: ${sum_shift_time_minutes} -${sum_drive_time_minutes}-${sum_on_scene_time_minutes} ;;
  }

  measure:  avg_dead_time_proxy_minutes{
    value_format: "0"
    type: number
    sql: case when ${count_distinct_shifts} >0 then ${sum_dead_time_proxy_minutes}/${count_distinct_shifts} else 0 end ;;
  }
  measure: count_distinct_shifts {
    type: count_distinct
    value_format: "0"
    sql: ${primary_key_shift} ;;
    sql_distinct_key: ${primary_key_shift} ;;
  }
  measure: sum_deadtime_start_of_shift_minutes{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_first_on_route_to_shift_start}*60 ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: first_accepted_bool
      value: "1"
    }
  }
  measure: avg_deadtime_start_of_shift_minutes{
    value_format: "0"
    type: number
    sql: ${sum_deadtime_start_of_shift_minutes}/${count_distinct_shifts} ;;
  }

  measure: sum_deadtime_total_minutes {
    value_format: "0"
    type: number
    sql: ${sum_dead_time_intra_minutes}+${sum_deadtime_start_of_shift_minutes}+${sum_deadtime_end_of_shift_minutes} ;;
  }

  measure: avg_deadtime_total_minutes {
    value_format: "0"
    type: number
    sql: case when ${count_distinct_shifts}>0 then  ${sum_deadtime_total_minutes}/${count_distinct_shifts} else 0 end;;
  }

  measure: sum_deadtime_diff_minutes {
    value_format: "0"
    type: number
    sql: abs(${sum_dead_time_proxy_minutes} -${sum_deadtime_total_minutes});;
  }

  measure: avg_deadtime_diff_minutes {
    value_format: "0"
    type: number
    sql: case when ${count_distinct_shifts}>0 then  ${sum_deadtime_diff_minutes}/${count_distinct_shifts} else 0 end;;
  }



  measure: sum_deadtime_start_of_shift_minutes_w_assigned{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_first_on_route_to_shift_start}*60 ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: patient_assigned_at_start_bool
      value: "1"
    }
  }

  measure: count_distinct_shifts_w_assigned {
    type: count_distinct
    value_format: "0"
    sql: ${primary_key_shift} ;;
    sql_distinct_key: ${primary_key_shift} ;;
    filters: {
      field: patient_assigned_at_start_bool
      value: "1"
    }
  }

  measure: count_distinct_shifts_w_high_overflow {
    type: count_distinct
    value_format: "0"
    sql: ${primary_key_shift} ;;
    sql_distinct_key: ${primary_key_shift} ;;
    filters: {
      field: high_overflow_days.high_overflow_bool
      value: "yes"
    }
  }





  measure: avg_deadtime_start_of_shift_minutes_w_assigned{
    value_format: "0"
    type: number
    sql: case when ${count_distinct_shifts_w_assigned}>0 then ${sum_deadtime_start_of_shift_minutes_w_assigned}/${count_distinct_shifts_w_assigned} else 0 end;;
  }
  measure: sum_deadtime_end_of_shift_minutes{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_between_last_complete_shift_end}*60 ;;
    sql_distinct_key: ${primary_key_shift} ;;
    filters: {
      field: last_care_request_bool
      value: "1"
    }
  }

  measure: sum_deadtime_end_of_shift_minutes_high_overflow{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_between_last_complete_shift_end}*60 ;;
    sql_distinct_key: ${primary_key_shift} ;;
    filters: {
      field: last_care_request_bool
      value: "1"
    }
    filters: {
      field: high_overflow_days.high_overflow_bool
      value: "yes"
    }
  }



  measure: avg_deadtime_end_of_shift_minutes{
    value_format: "0"
    type: number
    sql: ${sum_deadtime_end_of_shift_minutes}/${count_distinct_shifts} ;;
  }

  measure: avg_deadtime_end_of_shift_minutes_high_overflow{
    value_format: "0"
    type: number
    sql: case when ${count_distinct_shifts_w_high_overflow}>0  then ${sum_deadtime_end_of_shift_minutes_high_overflow}/${count_distinct_shifts_w_high_overflow} else 0 end;;
  }

  measure: sum_dead_time_at_office_after_shift{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_between_last_update_shift_end}*60 ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_dead_time_at_office_after_shift_high_overflow{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_between_last_update_shift_end}*60 ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: high_overflow_days.high_overflow_bool
      value: "yes"
    }
  }


  measure: avg_dead_time_at_office_after_shift{
    value_format: "0"
    type: number
    sql: ${sum_dead_time_at_office_after_shift}/${count_distinct_shifts} ;;
  }

  measure: avg_dead_time_at_office_after_shift_high_overflow{
    value_format: "0"
    type: number
    sql: case when ${count_distinct_shifts_w_high_overflow}>0  then ${sum_dead_time_at_office_after_shift_high_overflow}/${count_distinct_shifts_w_high_overflow} else 0 end ;;
  }



  measure: sum_drive_back_to_office_minutes{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_between_last_complete_last_update}*60;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: last_care_request_bool
      value: "1"
    }
  }

  measure: sum_drive_back_to_office_minutes_high_overflow{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_between_last_complete_last_update}*60;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: last_care_request_bool
      value: "1"
    }
    filters: {
      field: high_overflow_days.high_overflow_bool
      value: "yes"
    }
  }

  measure: avg_drive_back_to_office_minutes{
    value_format: "0"
    type: number
    sql: ${sum_drive_back_to_office_minutes}/${count_distinct_shifts} ;;
  }

  measure: avg_drive_back_to_office_minutes_high_overflow{
    value_format: "0"
    type: number
    sql: case when ${count_distinct_shifts_w_high_overflow}>0  then ${sum_drive_back_to_office_minutes_high_overflow}/${count_distinct_shifts_w_high_overflow} else 0 end;;
  }


  measure: sum_dead_time_intra_minutes{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_on_route_to_prior_complete}*60;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: first_accepted_bool
      value: "0"
    }
  }

  measure: sum_complete_count{
    type: sum_distinct
    value_format: "0"
    sql: ${complete_count};;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_dead_time_intra_minutes_w_assigned{
    type: sum_distinct
    value_format: "0"
    sql: ${diff_on_route_to_prior_complete}*60;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: first_accepted_bool
      value: "0"
    }
    filters: {
      field: patient_assigned_bool
      value: "1"
    }
  }

  measure: avg_dead_time_intra_minutes_w_assigned{
    value_format: "0"
    type: number
    sql: case when ${count_distinct_shifts}> 0 then ${sum_dead_time_intra_minutes_w_assigned}/${count_distinct_shifts} else 0 end ;;
  }

  measure: shift_productivity{
    value_format: "0.00"
    type: number
    sql: case when ${sum_shift_time_hours} >0 then ${sum_complete_count}::float/(${sum_shift_time_hours}::float) else 0 end ;;
  }



  measure: avg_dead_time_intra_minutes{
    value_format: "0"
    type: number
    sql: case when ${count_distinct_shifts}> 0 then ${sum_dead_time_intra_minutes}/${count_distinct_shifts} else 0 end ;;
  }

  measure: percent_assigned_at_start {
    value_format: "0%"
    type: number
    sql: case when ${count_distinct_shifts}>0 then ${count_distinct_shifts_w_assigned}::float/${count_distinct_shifts}::float else 0 end ;;
  }

}
