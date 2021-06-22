view: queue_targets {
  sql_table_name: looker_scratch.queue_targets ;;

  dimension: queuename {
    type: string
    sql: ${TABLE}."queuename" ;;
  }

  measure: target_rate {
    type: number
    sql: ${TABLE}."target_rate" ;;
  }

  measure: max_target_rate {
    type: number
    sql: max(${TABLE}."target_rate") ;;
  }


  measure: count {
    type: count
    drill_fields: [queuename]
  }
}
