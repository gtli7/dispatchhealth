view: athenadwh_clinical_encounters_clone {
  sql_table_name: looker_scratch.athenadwh_clinical_encounters_clone ;;
  view_label: "ZZZZ - Athenadwh Clinical Encounters Clone"

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
    description: "Count of distinct clinical encounters"
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

  measure: count_distinct_charts {
    type: count_distinct
    sql: ${chart_id} ;;
  }

  measure: count_symptom_based_charts {
    type: count_distinct
    sql: ${chart_id} ;;
    filters: {
      field: athenadwh_icdcodeall.symptom_based_diagnosis
      value: "yes"
    }
  }

  measure: count_comorbidity_based_charts {
    type: count_distinct
    description: "Count of charts that have non-primary comorbidity diagnoses"
    sql: ${chart_id} ;;
    filters: {
      field: athenadwh_icdcodeall.comorbidity_based_diagnosis
      value: "yes"
    }
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
