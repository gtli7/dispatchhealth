view: custom_five_types {
  sql_table_name: looker_scratch.custom_five_types ;;

  dimension: custom5 {
    type: string
    sql: ${TABLE}."custom5" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."type" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
