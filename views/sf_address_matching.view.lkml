view: sf_address_matching {
  sql_table_name: looker_scratch.sf_address_matching ;;

  dimension: account_id {
    type: string
    sql: ${TABLE}."account_id" ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
