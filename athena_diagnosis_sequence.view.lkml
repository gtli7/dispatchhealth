view: athena_diagnosis_sequence {
  derived_table: {
    sql:
    SELECT
    apt.appointment_id,
    apt.appointment_char,
    clm.claim_id,
    ce.clinical_encounter_id,
    COALESCE(icd.icd_code_id, clmd.icd_code_id, NULL) AS icd_code_id,
    COALESCE(ced.ordering + 1, clmd.sequence_number, NULL) AS sequence_number
    FROM athena.appointment apt
    LEFT JOIN athena.claim clm
        ON apt.appointment_id = clm.claim_appointment_id
    LEFT JOIN athena.clinicalencounter ce
        ON apt.appointment_id = ce.appointment_id
    LEFT JOIN (
        SELECT
            ced.clinical_encounter_id,
            ced.ordering,
            MAX(cedx.clinical_encounter_dx_id) AS clinical_encounter_dx_id,
            cedx.icd_code_id
        FROM athena.clinicalencounterdiagnosis ced
        LEFT JOIN athena.clinicalencounterdxicd10 cedx
            ON ced.clinical_encounter_dx_id = cedx.clinical_encounter_dx_id
        WHERE ced.deleted_datetime IS NULL
        GROUP BY 1,2,4) fced
        ON ce.clinical_encounter_id = fced.clinical_encounter_id
    INNER JOIN athena.clinicalencounterdiagnosis ced
        ON fced.clinical_encounter_dx_id = ced.clinical_encounter_dx_id
    LEFT JOIN athena.icdcodeall icd
        ON fced.icd_code_id = icd.icd_code_id
    LEFT JOIN (
        SELECT
            claim_id,
            sequence_number,
            icd_code_id
            FROM athena.claimdiagnosis
            WHERE deleted_datetime IS NULL) AS clmd
        ON clm.claim_id = clmd.claim_id AND ced.ordering + 1 = clmd.sequence_number
    WHERE ced.deleted_datetime IS NULL AND icd.icd_code_id IS NOT NULL
    GROUP BY 1,2,3,4,5,6,ced.ordering ;;

    sql_trigger_value: SELECT MAX(created_at) FROM athena.clinicalencounterdiagnosis ;;
    indexes: ["appointment_id", "appointment_char", "claim_id", "clinical_encounter_id", "sequence_number", "icd_code_id"]
  }

  dimension: appointment_id {
    type: number
    sql: ${TABLE}.appointment_id ;;
  }

  dimension: appointment_char {
    type: string
    sql: ${TABLE}.appointment_char ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
  }

  dimension: icd_code_id {
    type: number
    sql: ${TABLE}.icd_code_id ;;
  }


}
