view: athena_result_created {
  # sql_table_name: athena_test.res_crt ;;
  view_label: "Athena Result Created (DO NOT USE)"
  derived_table: {
    sql: SELECT
    dr.order_document_id,
    MAX(res_crt.document_id) AS document_id,
    MAX(res_crt.result_created) AS result_created
    FROM athena_test.res_crt
    LEFT JOIN athena.document_results dr
        ON res_crt.document_id = dr.document_id
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
    sql: ${TABLE}.order_document_id ;;
  }

  dimension: document_id {
    type: number
    primary_key: no
    hidden: no
    sql: ${TABLE}."document_id" ;;
  }

  dimension_group: result_created {
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
    sql: ${TABLE}."result_created" ;;
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
