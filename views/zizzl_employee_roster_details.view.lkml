view: zizzl_employee_roster_details {
  sql_table_name: zizzl.employee_roster ;;
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

  dimension_group: __turnover_file {
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
    sql: ${TABLE}."__turnover_file_date" ;;
  }

  dimension: __turnover_from_file {
    type: string
    hidden: yes
    sql: ${TABLE}."__turnover_from_file" ;;
  }

  dimension_group: __turnover_processed {
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
    sql: ${TABLE}."__turnover_processed_date" ;;
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

  dimension_group: date_hired {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."date_hired" ;;
  }

  dimension_group: date_re_hired {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."date_re_hired" ;;
  }

  dimension: employee_position {
    type: string
    sql: ${TABLE}."default_jobs_full_path" ;;
  }

  dimension: ambassador_flag {
    type: yesno
    description: "A flag indicating the provider is an ambassador"
    sql: ${employee_position} IN ('Advanced Practice Provider Ambassador', 'New Market/Lead Ambassador') ;;
  }

  dimension: employee_location {
    type: string
    sql: ${TABLE}."default_location_full_path" ;;
  }

  dimension: default_provider_type_full_path {
    type: string
    hidden: yes
    sql: ${TABLE}."default_provider_type_full_path" ;;
  }

  dimension: employee_ein {
    type: string
    hidden: yes
    sql: ${TABLE}."employee_ein" ;;
  }

  dimension: employee_id {
    type: number
    sql: ${TABLE}."employee_id" ;;
  }

  dimension: employee_status {
    type: string
    hidden: no
    sql: ${TABLE}."employee_status" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension_group: termination_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."termination_date" ;;
  }

  dimension: termination_reason {
    type: string
    hidden: yes
    sql: ${TABLE}."termination_reason" ;;
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

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name]
  }
}
