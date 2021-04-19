view: provider_minmax {
  sql_table_name: looker_scratch.provider_minmax ;;

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

  dimension: email {
    type: string
    sql: ${TABLE}."email" ;;
  }

  dimension_group: end_range {
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
    sql: ${TABLE}."end_range" ;;
  }

  dimension: ideal_hours {
    type: number
    sql: ${TABLE}."ideal_hours" ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}."market" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: max_hours {
    type: number
    sql: ${TABLE}."max_hours" ;;
  }

  dimension: min_hours {
    type: number
    sql: ${TABLE}."min_hours" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."name" ;;
  }

  dimension: provider_type {
    type: string
    sql: ${TABLE}."provider_type" ;;
  }

  dimension_group: start_range {
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
    sql: ${TABLE}."start_range" ;;
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
    drill_fields: [name]
  }
}
