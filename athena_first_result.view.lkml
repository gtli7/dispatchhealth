view: athena_first_result {
  sql_table_name: athena_test.fres ;;
  view_label: "Athena First Result (DO NOT USE)"

  dimension_group: created {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."created_at" ;;
  }

  dimension: document_id {
    type: number
    hidden: yes
    sql: ${TABLE}."document_id" ;;
  }

  dimension: result_document_id {
    type: number
    sql: ${TABLE}."result_document_id" ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
