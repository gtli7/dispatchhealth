view: insurance_coalese {
    derived_table: {
      sql:
WITH slf AS (
SELECT
    cr.id AS care_request_id,
    NULLIF(REGEXP_REPLACE(i1.package_id,'\D','','g'),'') AS self_report_package_id,
    i1.member_id
    FROM public.care_requests cr
    INNER JOIN public.insurances i1
        ON cr.patient_id = i1.patient_id
    INNER JOIN (
        SELECT
            patient_id,
            MAX(id) AS id_to_join
        FROM public.insurances
        WHERE priority = '1' AND end_date IS NULL
        GROUP BY 1) AS i2
        ON i1.id = i2.id_to_join
    GROUP BY 1,2,3),
insclm AS (
SELECT
    cr.id AS care_request_id,
    apt.appointment_id,
    pay.insurance_package_id::varchar AS package_id
    FROM public.care_requests cr
    JOIN athena.appointment apt
        ON cr.ehr_id = apt.appointment_char
    LEFT JOIN (
        SELECT
            id,
            claim_appointment_id,
            claim_primary_patient_ins_id,
            MAX(claim_created_datetime) AS claim_created_datetime
            FROM athena.claim
            WHERE primary_claim_status <> 'DELETED'
            GROUP BY 1,2) AS claim
        ON apt.appointment_id = claim.claim_appointment_id
    INNER JOIN (
        SELECT
            claim_appointment_id,
            MAX(id) AS id_to_join
            FROM athena.claim
            WHERE primary_claim_status <> 'DELETED'
            GROUP BY 1) AS clm_to_join
        ON claim.id = clm_to_join.id_to_join
    INNER JOIN athena.patientinsurance pi
        ON claim.claim_primary_patient_ins_id = pi.patient_insurance_id
            AND pi.patient_id = apt.patient_id
    LEFT JOIN athena.payer pay
        ON pi.insurance_package_id = pay.insurance_package_id
    WHERE pi.sequence_number = '1'
    GROUP BY 1,2,3)

SELECT
    slf.care_request_id,
    COALESCE(insclm.package_id,slf.self_report_package_id,NULL) AS package_id_coalese,
    slf.member_id,
    pay.custom_insurance_grouping
    FROM slf
    LEFT JOIN insclm
        ON slf.care_request_id = insclm.care_request_id
    LEFT JOIN athena.payer pay
        ON COALESCE(insclm.package_id,slf.self_report_package_id,NULL) = pay.insurance_package_id::varchar
    GROUP BY 1,2,3,4 ;;

  sql_trigger_value: SELECT MAX(id) FROM public.care_request_insurance_packages ;;
  indexes: ["care_request_id", "package_id_coalese"]
    }

    dimension: care_request_id {
      type: number
      sql: ${TABLE}.care_request_id ;;
    }

  dimension: package_id_coalese {
    type: string
    sql: ${TABLE}.package_id_coalese ;;
  }

  dimension: member_id {
    type: string
    sql: ${TABLE}.member_id ;;
  }

  dimension: custom_insurance_grouping {
    type: string
    sql: ${TABLE}.custom_insurance_grouping ;;
  }

  dimension: member_id_strip_trailing_zeros {
    label: "Member Id (strip trailing zeros)"
    description: "Developed for Optum specific reporting requriements for member ID to strip trailing zeros"
    type: string
    sql: CASE WHEN length(${insurance_coalese.member_id}) = 11 AND
                    substring(${insurance_coalese.member_id}, length(${insurance_coalese.member_id})-1,2)='00' THEN substring(${insurance_coalese.member_id}, 1,length(${insurance_coalese.member_id})-2)
        ELSE ${insurance_coalese.member_id}
        END;;
  }

}
