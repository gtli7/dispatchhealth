view: athenadwh_icd_codes_clone {
  sql_table_name: looker_scratch.athenadwh_icd_codes_clone ;;
  view_label: "ZZZZ - Athenadwh ICD Codes Clone"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: diagnosis_code {
    type: string
    sql: ${TABLE}.diagnosis_code ;;
  }

  dimension: diagnosis_code_description {
    type: string
    sql: ${TABLE}.diagnosis_code_description ;;
  }

  dimension: diagnosis_code_group {
    type: string
    sql: ${TABLE}.diagnosis_code_group ;;
  }

  dimension: diagnosis_code_set {
    type: string
    sql: ${TABLE}.diagnosis_code_set ;;
  }

  dimension: effective_date {
    type: string
    sql: ${TABLE}.effective_date ;;
  }

  dimension: expiration_date {
    type: string
    sql: ${TABLE}.expiration_date ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: icd_code_id {
    type: number
    sql: ${TABLE}.icd_code_id ;;
  }

  dimension: parent_diagnosis_code {
    type: string
    sql: ${TABLE}.parent_diagnosis_code ;;
  }

  dimension: unstripped_diagnosis_code {
    type: string
    sql: ${TABLE}.unstripped_diagnosis_code ;;
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
