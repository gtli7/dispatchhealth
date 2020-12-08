view: zizzl_rates_hours {
  sql_table_name: zizzl.weekly_rates_hours ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension_group: __file {
    type: time
    hidden: yes
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
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    hidden: yes
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: activities_full_path {
    type: string
    group_label: "Shift Description"
    description: "The shift activity note (if available)"
    sql: ${TABLE}."activities_full_path" ;;
  }

  dimension: clinical_or_non_clinical {
    type: string
    hidden: yes
    sql: ${TABLE}."clinical_or_non_clinical" ;;
  }

  dimension: clinical_shift {
    type: yesno
    group_label: "Shift Description"
    description: "A flag indicating clinical shifts"
    sql: ${TABLE}."clinical_shift" ;;
  }

  dimension_group: shift {
    type: time
    description: "Shift date"
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
    sql: ${TABLE}."counter_date" ;;
  }

  dimension: counter_hours {
    type: number
    sql: ${TABLE}."counter_hours" ;;
  }

  dimension: counter_name {
    type: string
    group_label: "Shift Description"
    description: "The description of hours (Holiday, Ambassador, Salary Plus, etc.)"
    sql: ${TABLE}."counter_name" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: employee_job_title {
    type: string
    group_label: "Employee Details"
    description: "The default job title of the employee"
    sql: ${TABLE}."default_jobs_full_path" ;;
  }

  dimension: provider_type {
    type: string
    group_label: "Employee Details"
    description: "The default provider type (APP, DHMT), if applicable"
    sql: ${TABLE}."default_provider_type_full_path" ;;
  }

  dimension: employee_department {
    type: string
    group_label: "Employee Details"
    description: "The department of the employee"
    sql: ${TABLE}."department_full_path" ;;
  }

  dimension: employee_ein {
    type: string
    hidden: yes
    sql: ${TABLE}."employee_ein" ;;
  }

  dimension: employee_id {
    type: number
    description: "The user ID of the employee"
    sql: ${TABLE}."employee_id" ;;
  }

  dimension: first_name {
    type: string
    group_label: "Employee Details"
    sql: ${TABLE}."first_name" ;;
  }

  dimension: gross_pay {
    type: number
    sql: ${TABLE}."gross_pay" ;;
  }

  dimension: last_name {
    type: string
    group_label: "Employee Details"
    sql: ${TABLE}."last_name" ;;
  }

  dimension: latest {
    type: yesno
    hidden: yes
    description: "A flag indicating the hours provided are the most recent posted for the shift"
    sql: ${TABLE}."latest" ;;
  }

  dimension: shift_location {
    type: string
    group_label: "Shift Description"
    description: "The location of the shift, or Corporate/Headquarters"
    sql: ${TABLE}."location_full_path" ;;
  }

  dimension: partner_full_path {
    type: string
    hidden: yes
    sql: ${TABLE}."partner_full_path" ;;
  }

  dimension: shift_position {
    type: string
    description: "The position being filled e.g. NP/PA/DEN01, etc."
    group_label: "Shift Description"
    sql: ${TABLE}."position_full_path" ;;
  }

  dimension: rate {
    type: number
    hidden: yes
    sql: ${TABLE}."rate" ;;
  }

  dimension: time_off_name {
    type: string
    hidden: yes
    sql: ${TABLE}."time_off_name" ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  dimension: clinical_position_flag {
    type: yesno
    description: "A flag indicating the position is direct clinical"
    hidden: yes
    sql: ${shift_position} LIKE '%DHMT%' OR ${shift_position} LIKE '%NP/PA%'
      OR ${shift_position} IN ('Telepresentation','Virtual Visit(s)','');;
  }

  dimension: clinical_hours {
    type: number
    sql: CASE WHEN ${counter_name} IN ('Regular', 'Overtime', 'Salary Plus', 'Holiday', 'Time and Half')
          AND ${latest} AND ${clinical_position_flag} THEN ${counter_hours}
         ELSE NULL
        END;;
  }

  measure: sum_direct_app_clinical_hours {
    type: sum
    group_label: "Clinical Hours"
    value_format: "0.00"
    description: "The sum of all direct APP clinical hours"
    sql: ${counter_hours} ;;
    filters: [counter_name: "Regular, Overtime, Salary Plus, Holiday, Time and Half",
      provider_type: "APP", latest: "yes", clinical_position_flag: "yes"]
  }

  measure: sum_direct_dhmt_clinical_hours {
    type: sum
    group_label: "Clinical Hours"
    value_format: "0.00"
    description: "The sum of all direct DHMT clinical hours"
    sql: ${counter_hours} ;;
    filters: [counter_name: "Regular, Overtime, Salary Plus, Holiday, Time and Half",
      provider_type: "DHMT", latest: "yes", clinical_position_flag: "yes"]
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, counter_name, time_off_name]
  }
}
