view: target_staffing_intra {
  sql_table_name: public.target_staffing_intra ;;

  dimension: dow {
    type: string
    sql: ${TABLE}."dow" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: market_short {
    type: string
    sql: ${TABLE}."market_short" ;;
  }

  dimension_group: month {
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
    sql: ${TABLE}."month" ;;
  }

  dimension: target_hours {
    type: number
    sql: ${TABLE}."target_hours" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
