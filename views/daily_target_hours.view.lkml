view: daily_target_hours {
  sql_table_name: looker_scratch.daily_target_hours ;;

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

  dimension: dow {
    type: string
    sql: ${TABLE}."dow" ;;
  }

  dimension: dow_order {
    type: number
    sql: ${TABLE}."dow_order" ;;
  }

  dimension: hours {
    type: number
    sql: ${TABLE}."hours" ;;
  }

  dimension: market_short {
    type: string
    sql: ${TABLE}."market_short" ;;
  }

  dimension_group: month {
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
    sql: ${TABLE}."month" ;;
  }

  dimension: shift_type {
    type: string
    sql: ${TABLE}."shift_type" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
