view: athena_cpt_codes {
  derived_table: {
    sql:
    SELECT
    ts.claim_id,
    ts.procedure_code,
    ts.cpt_code,
    pc.procedure_code_description,
    pc.procedure_code_group,
    em.em_patient_type,
    CASE WHEN em.em_care_level = '' THEN NULL ELSE em.em_care_level::int END AS em_care_level
    FROM (
        SELECT
            claim_id,
            unnest(procedure_codes) AS procedure_code,
            split_part(unnest(procedure_codes),' ',1) AS cpt_code
            FROM ${athena_transaction_summary.SQL_TABLE_NAME}) AS ts
    LEFT JOIN athena.procedurecode pc
        ON ts.procedure_code = pc.procedure_code
    LEFT JOIN looker_scratch.cpt_em_references_clone em
        ON ts.cpt_code = em.cpt_code;;

      indexes: ["claim_id", "procedure_code"]
      sql_trigger_value: SELECT MAX(claim_id) FROM athena.claim ;;
    }

  dimension: claim_id {
    type: number
    sql: ${TABLE}.claim_id ;;
  }

  dimension: procedure_code {
    type: string
    description: "The CPT procedure code, including modifiers (e.g. 99215, 99215 QW)"
    sql: ${TABLE}.procedure_code ;;
  }

  dimension: cpt_code {
    type: string
    description: "The CPT procedure code without modifiers"
    sql: ${TABLE}.cpt_code ;;
  }

  dimension: em_patient_type {
    type: string
    description: "E&M Patient Type (e.g. NP or EP)"
    sql: ${TABLE}.em_patient_type ;;
  }

  dimension: em_care_level {
    type: number
    description: "The Evaluation & Management care level"
    sql: ${TABLE}.em_care_level ;;
  }

  measure: avg_em_care_level {
    label: "Average E&M Code Care Level"
    type: average
    sql: ${em_care_level};;
    value_format: "0.00"
  }

  measure: procedure_codes_concatenated {
    description: "Concatenated CPT Codes"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${procedure_code}), ' | ') ;;
    group_label: "Procedure Codes"
  }

  dimension: procedure_code_description {
    type: string
    group_label: "Descriptions"
    description: "The CPT Procedure description"
    sql: ${TABLE}.procedure_code_description ;;
  }

  measure: procedure_descriptions_concatenated {
    description: "Concatenated CPT Code Descriptions"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${procedure_code_description}), ' | ') ;;
    group_label: "Procedure Codes"
  }

  dimension: procedure_code_group {
    type: string
    group_label: "Descriptions"
    description: "The CPT Procedure group (e.g. E&M, Labs, Procedures)"
    sql: ${TABLE}.procedure_code_group ;;
  }

  dimension: e_and_m_cpt_code {
    type: yesno
    description: "A flag indicating the CPT code is an E&M code"
    sql: ${procedure_code_group} = 'E&M' ;;
  }

  measure: count_cpt_codes {
    type: count
    description: "Count of All Non-E&M CPT Codes"
    sql: ${cpt_code} ;;
    filters: [e_and_m_cpt_code: "no"]
  }

}
