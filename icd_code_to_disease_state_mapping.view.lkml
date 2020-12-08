view: icd_code_to_disease_state_mapping {
  sql_table_name: looker_scratch.icd_code_to_disease_state_mapping ;;
  view_label: "ZZZZ - ICD Code to Disease State Mapping"
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: diagnosis_code {
    type: string
    sql: ${TABLE}."diagnosis_code" ;;
  }

  dimension: disease_state {
    type: string
    sql: ${TABLE}."disease_state" ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
