view: propensity_by_zip {
  sql_table_name: looker_scratch.propensity_by_zip ;;

  dimension: market {
    type: string
    sql: ${TABLE}."market" ;;
  }

  dimension: rank_1_10 {
    type: number
    sql: ${TABLE}."rank_1_10" ;;
  }

  dimension: total {
    type: number
    sql: ${TABLE}."total" ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}."zipcode_str" ;;
  }



  measure: sum_rank_1_10 {
    type: sum_distinct
    sql_distinct_key: ${zipcode} ;;
    sql: ${rank_1_10} ;;
  }

  measure: sum_total {
    type: sum_distinct
    sql_distinct_key: ${zipcode} ;;
    sql: ${total} ;;
  }

  measure:rank_1_10_percent {
    type: number
    sql: ${sum_rank_1_10}/${sum_total} ;;
    value_format: "0.0%"
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
