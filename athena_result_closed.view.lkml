view: athena_result_closed {
  # sql_table_name: athena_test.res_close ;;
  view_label: "Athena Result Closed"

  derived_table: {
    sql: SELECT
        dr.order_document_id,
        MAX(res_close.document_id) AS document_id,
        MAX(res_close.result_closed) AS result_closed
        FROM athena_test.res_close
        LEFT JOIN athena.document_results dr
            ON res_close.document_id = dr.document_id
        GROUP BY 1 ;;
    sql_trigger_value: SELECT MAX(document_id) FROM athena_test.res_crt ;;
    indexes: ["order_document_id", "document_id"]
  }

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

    dimension: order_document_id {
      type: number
      primary_key: yes
      hidden: no
      sql: ${TABLE}."order_document_id" ;;
    }

  dimension: document_id {
    type: number
    primary_key: no
    hidden: no
    sql: ${TABLE}."document_id" ;;
  }

  dimension_group: result_closed {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."result_closed" ;;
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
