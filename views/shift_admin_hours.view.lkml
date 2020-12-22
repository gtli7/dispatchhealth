view: shift_admin_hours {
  sql_table_name: looker_scratch.shift_admin_hours ;;

  dimension: count_as_shift {
    type: number
    sql: ${TABLE}."count_as_shift" ;;
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

  dimension: employee_id {
    type: number
    sql: ${TABLE}."employee_id" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."facility_ext_id" ;;
  }

  dimension: facility_id {
    type: number
    sql: ${TABLE}."facility_id" ;;
  }

  dimension: facility_name {
    type: string
    sql: ${TABLE}."facility_name" ;;
  }

  dimension: facility_short_name {
    type: string
    sql: ${TABLE}."facility_short_name" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension: group_id {
    type: number
    sql: ${TABLE}."group_id" ;;
  }

  dimension: is_night {
    type: number
    sql: ${TABLE}."is_night" ;;
  }

  dimension: is_weekend {
    type: number
    sql: ${TABLE}."is_weekend" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension: npi {
    type: number
    sql: ${TABLE}."npi" ;;
  }

  dimension: num_shifts {
    type: number
    sql: ${TABLE}."num_shifts" ;;
  }

  dimension_group: shift_day {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."shift_day" ;;
  }

  dimension_group: shift_end {
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
    sql: ${TABLE}."shift_end" ;;
  }

  dimension: shift_hours {
    type: number
    sql: ${TABLE}."shift_hours" ;;
  }

  dimension: shift_id {
    type: number
    sql: ${TABLE}."shift_id" ;;
  }

  dimension: shift_name {
    type: string
    sql: ${TABLE}."shift_name" ;;
  }

  dimension: shift_short_name {
    type: string
    sql: ${TABLE}."shift_short_name" ;;
  }

  dimension_group: shift_start {
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
    sql: ${TABLE}."shift_start" ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."user_id" ;;
  }

  dimension_group: work_day {
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
    sql: ${TABLE}."work_day" ;;
  }

  dimension_group: work_end {
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
    sql: ${TABLE}."work_end" ;;
  }

  dimension: work_hours {
    type: number
    sql: ${TABLE}."work_hours" ;;
  }

  dimension_group: work_start {
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
    sql: ${TABLE}."work_start" ;;
  }

  dimension: primary_key {
    type: string
    sql: concat(${user_id}, ${shift_id}, ${shift_start_raw}::varchar) ;;
  }

  dimension: app_shift {
    type: yesno
    sql: lower(${shift_name}) like '%np/pa%' ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_distinct_employees {
    type: count_distinct
    sql: ${employee_id} ;;
    sql_distinct_key: ${employee_id} ;;
  }

  measure: sum_shift_hours {
    type: sum_distinct
    sql: ${shift_hours} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      first_name,
      last_name,
      facility_name,
      facility_short_name,
      shift_name,
      shift_short_name
    ]
  }
}
