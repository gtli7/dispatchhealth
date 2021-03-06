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
    sql: CASE WHEN athena_diagnosis_codes.diagnosis_code_short = ${icd_10_code} AND athena_diagnosis_sequence.sequence_number = 1 THEN true
    WHEN athena_diagnosis_codes.diagnosis_code_short = ${icd_10_code} AND athena_diagnosis_sequence.sequence_number = 2 THEN true
    WHEN athena_diagnosis_codes.diagnosis_code_short = ${icd_10_code} AND athena_diagnosis_sequence.sequence_number = 3 THEN true
    ELSE false
    END;;
  }


  measure: count {
    type: count
    drill_fields: [id]
  }
}
