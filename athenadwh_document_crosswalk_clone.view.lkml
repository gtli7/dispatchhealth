view: athenadwh_document_crosswalk_clone {
  sql_table_name: looker_scratch.athenadwh_document_crosswalk_clone ;;
  view_label: "ZZZZ - Athenadwh Document Crosswalk Clone"

  dimension: document_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.document_id ;;
  }

  dimension: chart_id {
    type: number
    sql: ${TABLE}.chart_id ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
