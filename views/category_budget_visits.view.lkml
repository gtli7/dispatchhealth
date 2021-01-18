view: category_budget_visits {
  sql_table_name: looker_scratch.category_budget_visits ;;

  dimension: category {
    type: string
    sql: ${TABLE}."category" ;;
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

  dimension: target {
    type: number
    sql: ${TABLE}."target" ;;
  }
  measure: sum_target {
    type: sum_distinct
    sql: ${target} ;;
    sql_distinct_key: concat(${market_id}, ${category}, ${month_month}) ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
