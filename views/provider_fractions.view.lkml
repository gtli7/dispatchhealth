view: provider_fractions {
  sql_table_name: looker_scratch.provider_fractions ;;

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

  dimension: fraction {
    type: number
    sql: ${TABLE}."fraction" ;;
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

  dimension: provider_type {
    type: string
    sql: ${TABLE}."provider_type" ;;
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
