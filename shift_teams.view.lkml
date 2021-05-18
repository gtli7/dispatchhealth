view: shift_teams {
  sql_table_name: public.shift_teams ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: compound_primary_key {
    primary_key: no
    hidden: yes
    sql: CONCAT(${start_date}::varchar, ${goals_by_day_of_week.market_id}::varchar) ;;
  }

  dimension: car_id {
    type: number
    hidden: yes
    sql: ${TABLE}.car_id ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
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
      day_of_week,
      month,
      quarter,
      year,
      hour_of_day,
      time_of_day
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

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
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

  dimension: exclude_short_shifts {
    type: yesno
    sql: ${shift_hours} > 0.25 ;;
  }

  dimension: exclude_long_shifts {
    type: yesno
    sql: ${shift_hours} <= 12 ;;
  }

  # dimension: actual_app_hours {
  #   type: number
  #   description: "Zizzl hours if available.  Otherwise scheduled hours"
  #   sql: CASE
  #         WHEN ${zizzl_rates_hours.clinical_hours} > 0
  #         AND ${provider_profiles.position} = 'advanced practice provider' THEN ${zizzl_rates_hours.clinical_hours}
  #       WHEN ${shift_hours} > 0.1
  #       AND ${provider_profiles.position} = 'advanced practice provider' THEN ${shift_hours}
  #       ELSE NULL
  #       END;;
  # }

  # dimension: actual_dhmt_hours {
  #   type: number
  #   description: "Zizzl hours if available.  Otherwise scheduled hours"
  #   sql: CASE
  #         WHEN ${zizzl_rates_hours.clinical_hours} > 0
  #         AND ${provider_profiles.position} = 'emt' THEN ${zizzl_rates_hours.clinical_hours}
  #       WHEN ${shift_hours} > 0.1
  #       AND ${provider_profiles.position} = 'emt' THEN ${shift_hours}
  #       ELSE NULL
  #       END;;
  # }

  # measure: sum_actual_app_hours {
  #   type: sum_distinct
  #   sql_distinct_key: CONCAT(${id},${zizzl_rates_hours.id}) ;;
  #   description: "Zizzl APP hours if available.  Otherwise, scheduled APP hours"
  #   group_label: "Hours"
  #   value_format: "0.00"
  #   sql: ${actual_app_hours} ;;
  #   filters: [cars.test_car: "no"]
  # }

  # measure: sum_actual_dhmt_hours {
  #   type: sum_distinct
  #   sql_distinct_key: CONCAT(${id},${zizzl_rates_hours.id}) ;;
  #   description: "Zizzl DHMT hours if available.  Otherwise, scheduled DHMT hours"
  #   group_label: "Hours"
  #   value_format: "0.00"
  #   sql: ${actual_dhmt_hours} ;;
  #   filters: [cars.test_car: "no"]
  # }

  dimension: st_app_hours {
    type: number
    sql: case when ${provider_profiles.position} = 'advanced practice provider'
          and ${shift_hours} >= 0
        then ${shift_hours}
        else 0 end;;
  }

  dimension: st_dhmt_hours {
    type: number
    sql: case when ${provider_profiles.position} = 'emt'
          and ${shift_hours} >= 0
        then ${shift_hours}
        else 0 end;;
  }

  measure: sum_app_hours_no_advanced_mc {
    type: sum_distinct
    value_format: "0.00"
    sql: ${st_app_hours} ;;
    sql_distinct_key: ${id} ;;
    label: "APP Actual Hrs (no advanced, multicare)"
    filters: [st_app_hours: ">0.24",
              cars.test_car: "no",
              cars.advanced_care_car: "no",
              cars.name: "-NULL",
              shift_types.name: "-multicare",
              provider_profiles.position: "advanced practice provider"]

  }

  measure: sum_dhmt_hours_no_advanced_mc {
    type: sum_distinct
    value_format: "0.00"
    sql: ${st_dhmt_hours} ;;
    sql_distinct_key: ${id} ;;
    label: "DHMT Actual Hrs (no advanced, multicare)"
    filters: [st_dhmt_hours: ">0.24",
      cars.test_car: "no",
      cars.advanced_care_car: "no",
      cars.name: "-NULL",
      shift_types.name: "-multicare",
      provider_profiles.position: "emt"]

  }

  measure: sum_shift_hours {
    type: sum_distinct
    value_format: "0.00"
    description: "Scheduled shift hours based on start and end times"
    group_label: "Hours"
    sql_distinct_key: ${id} ;;
    sql: ${shift_hours} ;;
    filters: [cars.test_car: "no",
      exclude_short_shifts: "yes",
      exclude_long_shifts: "yes"]
  }

  measure: sum_shift_hours_no_advanced_mc {
    type: sum_distinct
    value_format: "0.00"
    label: "Shift Hours (no advanced, multicare)"
    sql_distinct_key: ${id} ;;
    sql: ${shift_hours} ;;
    filters:  [shift_hours: ">0.24",
      cars.test_car: "no",
      cars.advanced_care_car: "no",
      cars.name: "-NULL",
      shift_types.name: "-multicare"]
  }

  # measure: sum_shift_hours_coalesce {
  #   description: "DO NOT USE"
  #   group_label: "Hours"
  #   type: number
  #   value_format: "0.00"
  #   sql: CASE
  #         WHEN ${zizzl_rates_hours.sum_direct_app_clinical_hours} > 0 THEN ${zizzl_rates_hours.sum_direct_app_clinical_hours}
  #             ELSE ${sum_shift_hours}
  #         END ;;
  # }

  measure: sum_shift_hours_no_arm_advanced {
    label: "Sum Shift Hours (no arm, advanced or tele)"
    group_label: "Hours"
    type: sum_distinct
    value_format: "0.0"
    sql_distinct_key: ${id} ;;
    sql: ${shift_hours} ;;
    filters: [cars.mfr_flex_car: "no", cars.advanced_care_car: "no",
              cars.telemedicine_car: "no", cars.test_car: "no"]
  }

  measure: sum_shift_hours_no_arm_advanced_only {
    label: "Sum Shift Hours (no arm, advanced)"
    type: sum_distinct
    group_label: "Hours"
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

  measure: sum_app_hours_no_arm_advanced_only {
    label: "Sum Shift Hours APP (no arm, advanced)"
    type: sum_distinct
    group_label: "Hours"
    value_format: "0.0"
    sql_distinct_key: ${id} ;;
    sql: ${shift_hours} ;;
    filters: [
      cars.mfr_flex_car: "no",
      cars.advanced_care_car: "no",
      cars.test_car: "no",
      provider_profiles.position: "advanced practice provider",
      cars.name: "-NULL",
      shift_types.name: "-multicare"
      ]
  }

  measure: sum_dhmt_hours_no_arm_advanced_only {
    label: "Sum Shift Hours DHMT (no arm, advanced)"
    type: sum_distinct
    group_label: "Hours"
    value_format: "0.0"
    sql_distinct_key: ${id} ;;
    sql: ${shift_hours} ;;
    filters: [
      cars.mfr_flex_car: "no",
      cars.advanced_care_car: "no",
      cars.test_car: "no",
      provider_profiles.position: "emt",
      cars.name: "-NULL",
      shift_types.name: "-multicare"
    ]
  }

  measure: productivity {
    type: number
    value_format: "0.00"
    sql: case when ${sum_shift_hours_no_arm_advanced_only}>0 then ${care_request_flat.complete_count_no_arm_advanced}/${sum_shift_hours_no_arm_advanced_only} else 0 end ;;
    }

  dimension_group: updated {
    type: time
    hidden: yes
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
    group_label: "Counts"
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
    group_label: "Counts"
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
    group_label: "Counts"
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
    group_label: "Counts"
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

  measure: shift_start_min {
    type: number
    sql: min(${start_hour_of_day}) ;;
  }

  measure: shift_end_max {
    type: number
    sql: max(${end_hour_of_day}) ;;
  }


  measure: count {
    type: count
    drill_fields: [id, shift_team_members.count]
  }
}
