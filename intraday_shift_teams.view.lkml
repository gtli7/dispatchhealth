view: intraday_shift_teams {
  sql_table_name: public.intraday_shift_teams ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: car_id {
    type: number
    sql: ${TABLE}.car_id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: end {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.end_time ;;
  }

  dimension: shift_id {
    type: number
    sql: ${TABLE}.shift_id ;;
  }

  dimension: shift_team_id {
    type: number
    sql: ${TABLE}.shift_team_id ;;
  }

  dimension_group: start {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.start_time ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at ;;
  }


  dimension_group: now_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month, time]
    sql: now() ;;
  }


  measure: max_accepted {
    type: time
    sql: max(${intraday_care_requests.accepted_time}) ;;
  }

  measure: max_etc {
    type: time
    sql: max(${intraday_care_requests.etc_raw}) ;;
  }

  measure:max_etc_or_now
  {
    type: time
    sql: case when ${max_etc_raw} is not null then ${max_etc_raw}
         else now() end;;
  }

  measure: available_time_shift {
    type: number
    value_format: "0.00"
    sql:EXTRACT(EPOCH FROM max(${end_raw})-${max_etc_or_now_raw})/3600;;
  }

  measure: patient_slots{
    type: number
    sql:case when floor(${available_time_shift}-.5/1.15) >0 then floor(${available_time_shift}-.5/1.15)
              else 0 end;;

  }

  measure: sum_available_time_shift {
    type: sum_distinct
    sql_distinct_key: concat(${shift_team_id}, ${start_date});;
    sql: ${available_time_shift};;

  }

  measure: accepted_crs {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.accepted
      value: "yes"
    }
  }

  measure: accepted_crs_medicaid {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.accepted
      value: "yes"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(MCARE)MEDICARE"
    }
  }

  measure: accepted_crs_tricare {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.accepted
      value: "yes"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(TC)TRICARE"
    }
  }


  measure: complete_crs {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.complete
      value: "yes"
    }
  }

  measure: complete_crs_medicaid {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.complete
      value: "yes"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(MCARE)MEDICARE"
    }
  }

  measure: complete_crs_tricare {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.complete
      value: "yes"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(TC)TRICARE"
    }
  }

  measure: resolved_crs {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.resolved
      value: "yes"
    }
  }



  measure: count {
    type: count
    drill_fields: [id]
  }
}
