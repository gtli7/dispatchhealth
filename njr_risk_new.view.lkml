view: njr_risk_new {
  sql_table_name: looker_scratch.njr_risk_new ;;

  dimension: count {
    type: number
    sql: ${TABLE}.count ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: right(concat('0', ${TABLE}.zipcode),5);;
  }


}
