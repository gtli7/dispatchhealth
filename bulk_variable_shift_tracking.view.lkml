view: bulk_variable_shift_tracking {
  sql_table_name: looker_scratch.bulk_variable_shift_tracking ;;

  dimension_group: date {
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
    sql: ${TABLE}."date" ;;
  }

  dimension: hour {
    type: number
    sql: ${TABLE}."hour" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: recommendation {
    type: number
    sql: ${TABLE}."recommendation" ;;
  }
  dimension: negative_recommendation {
    type: yesno
    sql: ${recommendation} <0 ;;
  }
  dimension: recommendation_total_hours {
    type: number
    sql: ${total_hours} + ${recommendation} ;;
  }

  measure: sum_recommendation {
    type: sum_distinct
    sql: ${recommendation} ;;
    sql_distinct_key: concat(${date_date}, ${market_id}) ;;
  }

  measure: sum_total_hours {
    type: sum_distinct
    sql: ${total_hours} ;;
    sql_distinct_key: concat(${date_date}, ${market_id}) ;;
  }



  measure: sum_recommendation_total_hours {
    type: sum_distinct
    sql: ${recommendation_total_hours} ;;
    sql_distinct_key: concat(${date_date}, ${market_id}) ;;
  }

  measure: actual_diff_to_recommendation {
    type: number
    value_format: "0.0"
    sql:  ${sum_recommendation_total_hours}::float - ${shift_teams.sum_shift_hours}::float    ;;
  }

  measure: actual_recommendation_captured {
    type: number
    value_format: "0.0"
    sql: ${shift_teams.sum_shift_hours}::float - ${sum_total_hours}::float    ;;
  }

#  measure: zizzl_vs_recommendation_diff {
#    type: number
#    value_format: "0.0"
#    sql: ${zizzl_detailed_shift_hours.sum_direct_hours}::float - ${sum_total_hours}::float
#    ;;

  #}





  dimension: total_hours {
    type: number
    sql: ${TABLE}."total_hours" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
