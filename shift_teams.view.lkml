view: shift_teams {
  sql_table_name: public.shift_teams ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: compound_primary_key {
    primary_key: no
    hidden: no
    sql: CONCAT(${start_date}::varchar, ${goals_by_day_of_week.market_id}::varchar) ;;
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
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.end_time AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz}  ;;
  }

  dimension_group: end_mountain {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.end_time  AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ;;
  }

  dimension_group: start {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      time_of_day,
      date,
      day_of_month,
      week,
      month,
      quarter,
      day_of_week,
      day_of_week_index,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.start_time AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  dimension: goal_volume {
    type: number
    sql: case when ${start_day_of_week_index} = 5 then ${goals_by_day_of_week.sat_goal}
    when ${start_day_of_week_index} = 6  then ${goals_by_day_of_week.sun_goal}
    else ${goals_by_day_of_week.weekday_goal} end;;
  }

  measure: sum_goal_volume {
    type: sum_distinct
    sql: ${goal_volume} ;;
    sql_distinct_key: ${compound_primary_key} ;;
  }

  dimension_group: start_mountain {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week,
      hour_of_day
    ]
    sql:  ${TABLE}.start_time  AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ;;
  }

  dimension: shift_hours {
    type: number
    sql: (EXTRACT(EPOCH FROM ${end_raw}) - EXTRACT(EPOCH FROM ${start_raw})) / 3600 ;;
  }

  dimension: actual_shift_hours {
    type: number
    sql: COALESCE(${zizzl_rates_hours.clinical_hours}, ${shift_hours}, NULL) ;;
  }

  measure: sum_shift_hours {
    type: sum_distinct
    value_format: "0.0"
    sql_distinct_key: ${id} ;;
    sql: ${shift_hours} ;;
    filters:  {
      field: cars.test_car
      value: "no"
    }
  }

  measure: sum_app_scheduled_shift_hours {
    type: sum_distinct
    value_format: "0.0"
    sql_distinct_key: ${id} ;;
    sql: ${shift_hours} ;;
    filters: [cars.test_car: "no", provider_profiles.position: "advanced practice provider"]
  }

  measure: sum_dhmt_scheduled_shift_hours {
    type: sum_distinct
    value_format: "0.0"
    sql_distinct_key: ${id} ;;
    sql: ${shift_hours} ;;
    filters: [cars.test_car: "no", provider_profiles.position: "emt"]
  }

  measure: sum_shift_hours_coalesce {
    description: "Zizzl APP hours if available.  Otherwise, shift team hours"
    type: number
    value_format: "0.00"
    sql: CASE
          WHEN ${zizzl_rates_hours.sum_direct_app_clinical_hours} > 0 THEN ${zizzl_rates_hours.sum_direct_app_clinical_hours}
               ELSE ${sum_shift_hours}
          END ;;
  }

  measure: sum_app_actual_shift_hours {
    description: "Zizzl APP hours if available.  Otherwise, shift team hours"
    type: sum_distinct
    value_format: "0.0"
    sql_distinct_key: ${zizzl_rates_hours.id} ;;
    sql: ${actual_shift_hours};;
    filters: [provider_profiles.position: "advanced practice provider"]
  }

  measure: sum_dhmt_actual_shift_hours {
    description: "Zizzl DHMT hours if available.  Otherwise, shift team hours"
    type: number
    value_format: "0.00"
    sql: CASE
          WHEN ${zizzl_rates_hours.sum_direct_dhmt_clinical_hours} > 0 THEN ${zizzl_rates_hours.sum_direct_dhmt_clinical_hours}
               ELSE ${sum_dhmt_scheduled_shift_hours}
          END ;;
  }

  # measure: sum_shift_hours_coalesce {
  #   description: "The sum of Zizzl hours (if available) or shift teams hours"
  #   type: sum_distinct
  #   value_format: "0.0"
  #   sql_distinct_key: ${id} ;;
  #   sql: ${shift_hours_coalesce} ;;
  #   filters:  {
  #     field: cars.test_car
  #     value: "no"
  #   }
  # }

  measure: sum_shift_hours_no_arm_advanced {
    label: "Sum Shift Hours (no arm, advanced or tele)"
    type: sum_distinct
    value_format: "0.0"
    sql_distinct_key: ${id} ;;
    sql: ${shift_hours} ;;
    filters:  {
      field: cars.mfr_flex_car
      value: "no"
    }
    filters:  {
      field: cars.advanced_care_car
      value: "no"
    }
    filters:  {
      field: cars.telemedicine_car
      value: "no"
    }
    filters:  {
      field: cars.test_car
      value: "no"
    }
  }

  measure: sum_shift_hours_no_arm_advanced_only {
    label: "Sum Shift Hours (no arm, advanced)"
    type: sum_distinct
    value_format: "0.0"
    sql_distinct_key: ${id} ;;
    sql: ${shift_hours} ;;
    filters:  {
      field: cars.mfr_flex_car
      value: "no"
    }
    filters:  {
      field: cars.advanced_care_car
      value: "no"
    }
    filters:  {
      field: cars.test_car
      value: "no"
    }
  }

  measure: productivity {
    type: number
    value_format: "0.00"
    sql: case when ${sum_shift_hours_no_arm_advanced}>0 then ${care_request_flat.complete_count_no_arm_advanced}/${sum_shift_hours_no_arm_advanced} else 0 end ;;
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

  dimension: car_date_id {
    type: string
    sql: CONCAT(${cars.name}, ${start_mountain_date});;
  }

  dimension: car_id_start_date_id {
  type: string
  sql: CONCAT(${car_id}, ${start_mountain_date});;
}

  dimension: car_hour_id {
    type: string
    sql: CONCAT(${cars.name}, ${start_mountain_date}, ${dates_hours_reference_clone.datehour_timezone_hour_of_day});;
  }

  dimension: shift_type_id {
    type: string
    sql: ${TABLE}.shift_type_id ;;
  }

  measure: count_distinct_shifts {
    type: count_distinct
    sql: ${id} ;;
  }

  measure: count_distinct_car_date_shift {
    label: "Count of Distinct Cars by Date (Shift Teams)"
    type: count_distinct
    sql_distinct_key: ${car_date_id} ;;
    sql: ${car_date_id} ;;
    filters:  {
      field: cars.telemedicine_car
      value: "no"
    }
    filters:  {
      field: cars.test_car
      value: "no"
    }
  }


  measure: count_distinct_car_date_shift_hours_greater_5 {
    label: "Count of Distinct Cars by Date where shift hours > 5 (Shift Teams)"
    type: count_distinct
    sql_distinct_key: ${car_date_id} ;;
    sql: ${car_date_id} ;;
    filters:  {
      field: cars.telemedicine_car
      value: "no"
    }
    filters:  {
      field: cars.test_car
      value: "no"
    }
    filters:  {
      field: shift_hours
      value: ">5"
    }
  }

  measure: count_distinct_car_date_car_assigned_shift_hours_greater_5 {
    label: "Count of Distinct Cars by Date where the total shift/s hours assigned to a car is > 5 (Shift Teams)"
    type: count_distinct
    sql_distinct_key: ${car_date_id} ;;
    sql: ${car_date_id} ;;
    filters:  {
      field: cars.telemedicine_car
      value: "no"
    }
    filters:  {
      field: cars.test_car
      value: "no"
    }
    filters:  {
      field: shifts_by_cars.daily_shift_time_by_car
      value: ">18000"
    }
  }



  measure: count_distinct_car_hour_shift {
    label: "Count of Distinct Cars by Hour (Shift Teams)"
    type: count_distinct
    sql_distinct_key: ${car_hour_id} ;;
    sql: ${car_hour_id} ;;
    filters:  {
      field: cars.telemedicine_car
      value: "no"
    }
    filters:  {
      field: cars.test_car
      value: "no"
    }
  }

  measure: hourly_productivity {
    value_format: "0.00"
    type: number
    sql: case when  ${count_distinct_car_date_shift}>0 then ${care_request_flat.complete_count}::float / ${count_distinct_car_date_shift}::float else 0 end;;
  }

  measure: daily_productivity {
    value_format: "0.00"
    type: number
    sql: ${care_request_flat.complete_count}::float / ${count_distinct_car_hour_shift}::float ;;
  }


  measure: count {
    type: count
    drill_fields: [id, shift_team_members.count]
  }
}
