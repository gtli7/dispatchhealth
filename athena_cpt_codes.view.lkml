view: athena_cpt_codes {
  derived_table: {
    sql:
    SELECT
    claim.claim_appointment_id AS appointment_id,
    ts.claim_id,
    ts.procedure_code,
    ts.cpt_code,
    pc.procedure_code_description,
    pc.procedure_code_group,
    em.em_patient_type,
    CASE WHEN em.em_care_level = '' THEN NULL ELSE em.em_care_level::int END AS em_care_level,
    ROW_NUMBER() OVER () AS primary_key
    FROM athena.claim
    INNER JOIN
        (
        SELECT
            claim_id,
            unnest(procedure_codes) AS procedure_code,
            split_part(unnest(procedure_codes),' ',1) AS cpt_code
            FROM athena.transactions_summary) AS ts
        ON claim.claim_id = ts.claim_id
    LEFT JOIN athena.procedurecode pc
        ON ts.procedure_code = pc.procedure_code
    LEFT JOIN looker_scratch.cpt_em_references_clone em
        ON ts.cpt_code = em.cpt_code;;

      indexes: ["appointment_id","primary_key","claim_id", "procedure_code"]
      sql_trigger_value: SELECT MAX(claim_id) FROM athena.claim ;;
    }

  dimension: primary_key {
    type: number
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.primary_key ;;
  }

  dimension: appointment_id {
    type: number
    sql: ${TABLE}.appointment_id ;;
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
    view_label: "E&M Care Level"
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

  dimension: cpt_code_and_description {
    description: "The CPT code only (less prefixes and suffixes) with the description"
    type: string
    sql: CASE
          WHEN ${cpt_code} IS NOT NULL THEN CONCAT(${cpt_code}, ' - ', ${procedure_code_description})
          ELSE NULL
        END ;;
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

  dimension: dhmt_solo_approved_procedures {
    type: yesno
    group_label: "Descriptions"
    description: "The list of CPT codes that a DHMT can administer without an APP on-scene (e.g. Tele-Presentation). Use with caution given a visit can have more than one procedure"
    sql: lower(${cpt_code}) in(
        '81002',
        '87426',
        '87804',
        '87880',
        '81025',
        '86308',
        '93005',
        '93010',
        '81003',
        '29125',
        '29130',
        '29105',
        '29505')
        OR ${e_and_m_cpt_code}
        OR ${cpt_code} IS NULL;;
  }

  measure: count_appointments_with_procedures_not_approved_dhmt_solo {
    description: "Count of appointments where a procedure was performed that is not approved for a solo DHMT"
    type: count_distinct
    sql: ${athena_clinicalencounter.clinical_encounter_id};;
    group_label: "Grouped Procedure: Appointment Counts"
    filters: [dhmt_solo_approved_procedures: "no"]

  }

  dimension: e_and_m_cpt_code {
    type: yesno
    description: "A flag indicating the CPT code is an E&M code"
    sql: ${procedure_code_group} = 'E&M' ;;
  }

  measure: count_appointments_with_non_em_cpt_code {
    description: "Count of appointments with an associated CPT Code (Excludes E&M codes)"
    type: count_distinct
    sql: ${athena_clinicalencounter.clinical_encounter_id};;
    filters: [cpt_code: "-NULL",e_and_m_cpt_code: "no"]
    group_label: "Grouped Procedure: Appointment Counts"
  }

  dimension: blood_tests {
    type: yesno
    sql: ${cpt_code} IN ('80047', '36415', '36410', '85014', '83605', '85610', '34616') ;;
    group_label: "Grouped Procedures"
  }

  measure: count_appointments_with_blood_tests {
    description: "Count of appointments with a blood test"
    type: count_distinct
    sql: ${athena_clinicalencounter.clinical_encounter_id};;
    group_label: "Grouped Procedure: Appointment Counts"
    filters: [blood_tests: "yes"]

  }

  measure: count_cpt_codes {
    type: count
    description: "Count of All Non-E&M CPT Codes"
    sql: ${cpt_code} ;;
    filters: [e_and_m_cpt_code: "no"]
  }

}
