view: tuscon_data {
  sql_table_name: looker_scratch.tuscan_data ;;

  dimension: count {
    type: number
    sql: ${TABLE}.Count ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.ZIP ;;
  }


}
