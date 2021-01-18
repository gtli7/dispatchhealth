view: employee_roster {
  sql_table_name: zizzl.employee_roster ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension_group: __file {
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
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    sql: ${TABLE}."__from_file" ;;
  }

  dimension_group: __turnover_file {
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
    sql: ${TABLE}."__turnover_file_date" ;;
  }

  dimension: __turnover_from_file {
    type: string
    sql: ${TABLE}."__turnover_from_file" ;;
  }

  dimension_group: __turnover_processed {
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
    sql: ${TABLE}."__turnover_processed_date" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: date_hired {
    type: string
    sql: ${TABLE}."date_hired" ;;
  }

  dimension: date_re_hired {
    type: string
    sql: ${TABLE}."date_re_hired" ;;
  }

  dimension: default_jobs_full_path {
    type: string
    sql: ${TABLE}."default_jobs_full_path" ;;
  }

  dimension: default_location_full_path {
    type: string
    sql: ${TABLE}."default_location_full_path" ;;
  }

  dimension: default_provider_type_full_path {
    type: string
    sql: ${TABLE}."default_provider_type_full_path" ;;
  }

  dimension: employee_ein {
    type: string
    sql: ${TABLE}."employee_ein" ;;
  }

  dimension: employee_id {
    type: number
    sql: ${TABLE}."employee_id" ;;
  }

  dimension: employee_status {
    type: string
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

  dimension: termination_date {
    type: string
    sql: ${TABLE}."termination_date" ;;
  }

  dimension: termination_reason {
    type: string
    sql: ${TABLE}."termination_reason" ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name]
  }
}
