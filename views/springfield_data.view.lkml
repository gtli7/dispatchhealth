view: springfield_data {
  sql_table_name: looker_scratch.springfield_data ;;

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: total_members {
    type: number
    sql: ${TABLE}.total_members ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
