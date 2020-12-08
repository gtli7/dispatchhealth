view: athenadwh_clinical_letters {
  sql_table_name: jasperdb.athenadwh_clinical_letters ;;
  view_label: "ZZZZ - Athenadwh Clinical Letters"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: clinical_letter_id {
    type: number
    sql: ${TABLE}.clinical_letter_id ;;
  }

  dimension: clinical_provider_recipient_id {
    type: number
    sql: ${TABLE}.clinical_provider_recipient_id ;;
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

  dimension: document_id {
    type: number
    sql: ${TABLE}.document_id ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: referring_prov_recipient_id {
    type: number
    sql: ${TABLE}.referring_prov_recipient_id ;;
  }

  dimension: role {
    type: string
    sql: ${TABLE}.role ;;
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
