view: icd_code_dimensions_clone {
  label: "ICD Code Dimensions Clone"
  sql_table_name: looker_scratch.icd_code_dimensions_clone ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: alpha_extension {
    type: string
    sql: ${TABLE}.alpha_extension ;;
  }

  dimension: category_header {
    type: string
    sql: ${TABLE}.category_header ;;
  }

  dimension: coding_system {
    type: string
    sql: ${TABLE}.coding_system ;;
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

  dimension: diagnosis_code_decimal {
    type: string
    sql: ${TABLE}.diagnosis_code_decimal ;;
  }

  dimension: diagnosis_description {
    type: string
    sql: ${TABLE}.diagnosis_description ;;
  }

  measure: diagnosis_codes_concat {
    label: "ICD 10 Diagnosis Codes"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${diagnosis_code}), ' | ') ;;
  }

  measure: diagnosis_desc_concat {
    label: "ICD 10 Diagnosis Descriptions"
    type: string
    sql: array_to_string(array_agg(DISTINCT  ${diagnosis_description}), ' | ') ;;
  }

  dimension: diagnosis_group {
    type: string
    sql: ${TABLE}.diagnosis_group ;;
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
