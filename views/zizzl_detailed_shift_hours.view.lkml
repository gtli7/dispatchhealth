view: zizzl_detailed_shift_hours {
  sql_table_name: looker_scratch.zizzl_detailed_shift_hours ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: activities {
    type: string
    sql: ${TABLE}."activities" ;;
  }

  dimension: clinical_non_clinical {
    type: string
    sql: ${TABLE}."clinical_non_clinical" ;;
  }

  dimension_group: counter {
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
    sql: ${TABLE}."counter_date" ;;
  }

  dimension: counter_hours {
    type: number
    sql: ${TABLE}."counter_hours" ;;
  }

  dimension: counter_name {
    type: string
    sql: ${TABLE}."counter_name" ;;
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

  dimension: department {
    type: string
    sql: ${TABLE}."department" ;;
  }

  dimension: employee_ein {
    type: string
    sql: ${TABLE}."employee_ein" ;;
  }

  dimension: employee_id {
    type: number
    sql: ${TABLE}."employee_id" ;;
  }

  dimension: employee_job_title {
    type: string
    sql: ${TABLE}."employee_job_title" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension: gross_pay {
    type: number
    sql: ${TABLE}."gross_pay" ;;
  }

  dimension: hourly_rate {
    type: number
    sql: ${TABLE}."hourly_rate" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension: location {
    type: string
    sql: ${TABLE}."location" ;;
  }

  dimension: partner {
    type: string
    sql: ${TABLE}."partner" ;;
  }

  dimension: shift_name {
    type: string
    sql: ${TABLE}."position" ;;
  }

  dimension: provider_type {
    type: string
    sql: ${TABLE}."provider_type" ;;
  }

  dimension: time_off {
    type: string
    sql: ${TABLE}."time_off" ;;
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
    drill_fields: [id, first_name, last_name, counter_name]
  }
}
