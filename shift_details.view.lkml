view: shift_details {
  sql_table_name: looker_scratch.shift_details ;;
  view_label: "ZZZZ - Shift Details"

  dimension: id {
    primary_key: yes
    type: number
    hidden: no
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    # Mod SG
    hidden: yes
    convert_tz: no
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

  dimension_group: deleted {
    type: time
    # Mod SG
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.deleted_at ;;
  }

  dimension: employee_id {
    type: number
    sql: ${TABLE}.employee_id ;;
  }

  dimension: employee_name {
    type: string
    sql: ${TABLE}.employee_name ;;
  }
  dimension: mcfaker {
    type: yesno
    sql: lower(${employee_name}) like '%mcfaker%' ;;
  }

  measure:  sum_valid_app_expected_shift_time_hours_mcfaker {
    type: sum
    label: "McFaker Hours"
    sql: ${expected_shift_time_hours};;
    value_format: "#,##0.00"
    filters: {
      field: employee_name_present
      value: "yes"
    }
    filters: {
      field: mcfaker
      value: "yes"
    }
  }


  dimension_group: local_actual_end {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      hour,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day,
      day_of_week,
      day_of_month
    ]
    sql: ${TABLE}.local_actual_end_time ;;
  }

  dimension_group: local_actual_start {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      hour,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.local_actual_start_time ;;
  }

  dimension: weekday_shift {
    type: string
    description: "A flag indicating the shift was on a weekday or weekend"
    sql: CASE WHEN ${local_actual_start_day_of_week_index} IN (0,1,2,3,4) THEN 'Weekday'
          WHEN ${local_actual_start_day_of_week_index} IN (5,6) THEN 'Weekend'
          ELSE NULL END;;
  }

  measure: first_shift_date {
    type: date
    sql: MIN(${local_actual_start_raw}) ;;
    convert_tz: no
  }

  dimension_group: local_expected_end {
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
      hour_of_day,
      day_of_week,
      day_of_month,
      day_of_week_index
    ]
    sql: ${TABLE}.local_expected_end_time ;;
  }

  dimension_group: local_expected_start {
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
      hour_of_day,
      day_of_week,
      day_of_month
    ]
    sql: ${TABLE}.local_expected_start_time ;;

  }

  dimension: notes {
    type: string
    sql: ${TABLE}.notes ;;
  }

  dimension: schedule_location_id {
    type: number
    sql: ${TABLE}.schedule_location_id ;;
  }


  dimension: schedule_location_id_w_loan {
    type: number
    sql: case when ${shift_name} = 'COS02' and ${local_expected_end_day_of_week_index} in(0,1,2,3,4)  and ${local_expected_end_month} in('2019-09','2019-10') then 565234
           else ${TABLE}.schedule_location_id end  ;;
  }

  dimension: schedule_name {
    type: string
    sql: ${TABLE}.schedule_name ;;
  }

  dimension: shift_role {
    type: string
    description: "Shift role parsed from schedule_name"
    sql: split_part(split_part(${TABLE}.schedule_name,' (H)',1),':',1);;
    # sql: split_part(${TABLE}.schedule_name,':',1) ;;

  }

  dimension: shift_name {
    type: string
    description: "Shift name parsed from the schedule name (e.g. DEN01)"
    sql: CASE WHEN LTRIM(${schedule_name}) LIKE '%SMFR Car' THEN
          split_part(${schedule_name},' ',3) || '_' || split_part(${schedule_name},' ',4)
        WHEN LTRIM(${schedule_name}) LIKE '%WMFR Car' THEN
          split_part(${schedule_name},' ',3) || ' ' || UPPER(split_part(${schedule_name},' ',4))
         ELSE LTRIM(split_part(split_part(${schedule_name},':',2),' (H)',1))
        END;;
  }


  dimension: app_shift {
    type: yesno
    description: "NP/PA in schedule_name"
    # sql: position('NP/PA' in ${TABLE}.schedule_name) > 0 ;;
    sql: ${schedule_name} LIKE '%NP/PA:%';;
  }
dimension: app_shift_or_mcfaker {
  type: yesno
  sql: ${app_shift} or ${mcfaker} ;;
  }

dimension: dhmt_shift {
  type:  yesno
  description: "DHMT in schedule_name"
  sql: ${schedule_name} LIKE '%DHMT:%' ;;
}

  dimension: shift_time_hours {
    type: number
    description: "The number of hours between Local Actual Start time and Local Actual End Time for APP Shifts"
    sql:
    ((EXTRACT(EPOCH FROM ${local_actual_end_raw})-EXTRACT(EPOCH FROM ${local_actual_start_raw}))/3600) ;;
    value_format: "#,##0.00"

  }

  dimension: expected_shift_time_hours {
    type: number
    description: "The number of hours between Local Actual Start time and Local Actual End Time for APP Shifts"
    sql:
    ((EXTRACT(EPOCH FROM ${local_expected_end_raw})-EXTRACT(EPOCH FROM ${local_expected_start_raw}))/3600) ;;
    value_format: "#,##0.00"

  }

  dimension: on_call_placeholder {
    type: yesno
    description: "A flag indicating that the shift is 15 minutes long (placeholder for on-call)"
    sql:(${shift_name} = 'DEN12' and ${local_expected_end_month} = '2020-03')
           OR
        (${shift_time_hours} = 0.25)
          OR
        (${shift_name} = 'DEN13' and ${local_expected_end_month} in('2020-04', '2020-05', '2020-06'));;
  }


  dimension: valid_shift {
    type: yesno
    description: "Employee is assinged to shift and shift is not on-call placeholder"
    sql: ${employee_name} IS NOT NULL AND NOT ${on_call_placeholder};;
  }

  dimension: employee_name_present {
    type: yesno
    description: "Employee is assinged to shift and shift is not on-call placeholder"
    sql: ${employee_name} IS NOT NULL;;
  }

  dimension: holiday_shift {
    type: yesno
    description: "Shift occurred on a holiday"
    sql: ${schedule_name} LIKE '%(H)' ;;
  }

  dimension: shift_id {
    type: number
    hidden: yes
    sql: ${TABLE}.shift_id ;;
  }

  dimension_group: updated {
    type: time
    # Mod SG
    hidden: yes
    convert_tz: no
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

  measure: count {
    type: count
    drill_fields: [id, schedule_name, employee_name]
  }

  measure: shift_count {
    type: count_distinct
    sql: ${TABLE}.shift_id;;
  }

  measure: count_valid_app_shifts {
    type: count_distinct
    description: "NP/PA shift and valid name assigned to the shift"
    sql: ${TABLE}.shift_id;;

    filters: {
      field: app_shift
      value: "yes"
    }
    filters: {
      field: valid_shift
      value: "yes"
    }
  }

measure:  sum_valid_shift_time_hours {
  type: sum
  description: "sum of shift hours"
  sql: ${shift_time_hours} ;;
  value_format: "#,##0.00"

  filters: {
    field: valid_shift
    value: "yes"
  }
}

  measure:  sum_valid_app_expected_shift_time_hours {
    type: sum
    label: "Sum Expected App Assigned Hours"
    sql: ${expected_shift_time_hours};;
    value_format: "#,##0.00"
    filters: {
      field: employee_name_present
      value: "yes"
    }
    filters: {
      field: app_shift
      value: "yes"
    }
  }

  measure:  sum_invalid_app_expected_shift_time_hours {
    type: sum_distinct
    label: "Sum Expected App Unassigned Hours"
    sql_distinct_key: concat(${shift_id}, ${local_expected_start_date}) ;;
    sql: ${expected_shift_time_hours};;
    value_format: "#,##0.00"
    filters: {
      field: employee_name_present
      value: "no"
    }
    filters: {
      field: app_shift
      value: "yes"
    }
  }

  measure:  sum_valid_app_shift_time_hours {
    type: sum
    description: "sum of APP valid shift hours"
    sql: ${shift_time_hours} ;;
    value_format: "#,##0.00"

    filters: {
      field: app_shift
      value: "yes"
    }
    filters: {
      field: valid_shift
      value: "yes"
    }
  }

  measure:  sum_valid_dhmt_shift_time_hours {
    type: sum
    description: "sum of DHMT valid shift hours"
    sql: ${shift_time_hours} ;;
    value_format: "#,##0.00"

    filters: {
      field: dhmt_shift
      value: "yes"
      }
    filters: {
      field: valid_shift
      value: "yes"
    }
    }

measure: count_total_app_shift {
  type:  count_distinct
  description: "NP/PA shift Total (invalid and valid)"
  sql: ${TABLE}.shift_id;;

  filters:  {
    field: app_shift
    value: "yes"
}


}

}
