view: athenadwh_clinical_encounters {
  sql_table_name: jasperdb.athenadwh_clinical_encounters ;;
  view_label: "ZZZZ - Athenadwh Clinical Encounters"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: appointment_id {
    type: number
    sql: ${TABLE}.appointment_id ;;
  }

  measure: count_appointments {
    type: count_distinct
    description: "Count of distinct appointment ID's"
    sql: ${appointment_id} ;;
  }

  dimension: chart_id {
    type: number
    sql: ${TABLE}.chart_id ;;
  }

  dimension: claim_id {
    type: number
    sql: ${TABLE}.claim_id ;;
  }

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}.clinical_encounter_id ;;
  }

  measure: count_clinical_encounters {
    type: count_distinct
    description: "Count of distinct clinical encounter ID's"
    sql: ${clinical_encounter_id} ;;
  }

  dimension: closed_datetime {
    type: string
    sql: ${TABLE}.closed_datetime ;;
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

  dimension: encounter_date {
    type: string
    sql: ${TABLE}.encounter_date ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: provider_id {
    type: number
    sql: ${TABLE}.provider_id ;;
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
