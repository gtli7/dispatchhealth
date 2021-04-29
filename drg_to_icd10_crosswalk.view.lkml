view: drg_to_icd10_crosswalk {
  sql_table_name: athena.drg_to_icd10_crosswalk ;;
  view_label: "athena_drg_to_icd10_crosswalk"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: drg_code {
    type: number
    sql: ${TABLE}.drg_code ;;
  }

  dimension: drg_description {
    type: string
    sql: ${TABLE}.drg_description ;;
  }

  dimension: icd_10_code {
    type: string
    sql: ${TABLE}.icd_10_code ;;
  }

  dimension: icd_10_description {
    type: string
    sql: ${TABLE}.icd_10_description ;;
  }

  dimension: advanced_care_drg_top_3_diagnoses {
    type: yesno
    sql: athena_primary_diagnosis_codes.diagnosis_code_short = ${icd_10_code} OR
    athena_secondary_diagnosis_codes.diagnosis_code_short = ${icd_10_code} OR
    athena_tertiary_diagnosis_codes.diagnosis_code_short = ${icd_10_code};;
  }


  measure: count {
    type: count
    drill_fields: [id]
  }
}
