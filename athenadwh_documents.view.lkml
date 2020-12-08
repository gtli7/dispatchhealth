view: athenadwh_documents {
  sql_table_name: jasperdb.athenadwh_documents ;;
  view_label: "ZZZZ - Athenadwh Documents"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}.clinical_encounter_id ;;
  }

  dimension: clinical_order_genus {
    type: string
    sql: ${TABLE}.clinical_order_genus ;;
  }

  dimension: clinical_order_type {
    type: string
    sql: ${TABLE}.clinical_order_type ;;
  }

  dimension: prescriptions_flag {
    type: yesno
    sql: ${document_class} = 'PRESCRIPTION' ;;
  }


  measure: prescriptions_concat {
    label: "Prescriptions Ordered"
    type: string
    sql: GROUP_CONCAT(DISTINCT ${clinical_order_type} SEPARATOR ' | ') ;;
  }


  dimension: clinical_provider_id {
    type: number
    sql: ${TABLE}.clinical_provider_id ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: created_datetime {
    type: string
    sql: ${TABLE}.created_datetime ;;
  }

  dimension: deleted_datetime {
    type: string
    sql: ${TABLE}.deleted_datetime ;;
  }

  dimension: document_class {
    type: string
    sql: ${TABLE}.document_class ;;
  }

  dimension: document_id {
    type: number
    sql: ${TABLE}.document_id ;;
  }

  dimension: document_subclass {
    type: string
    sql: ${TABLE}.document_subclass ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: route {
    type: string
    sql: ${TABLE}.route ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
