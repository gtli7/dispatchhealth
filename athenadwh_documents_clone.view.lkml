view: athenadwh_documents_clone {
  sql_table_name: looker_scratch.athenadwh_documents_clone ;;
  view_label: "ZZZZ - Athenadwh Documents Clone"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}.clinical_encounter_id ;;
  }

  dimension: clinical_order_genus {
    type: string
    sql: ${TABLE}.clinical_order_genus ;;
  }

  dimension: clinical_order_type {
    type: string
    sql: ${TABLE}.clinical_order_type ;;
  }

  dimension: clinical_order_type_short {
    type: string
    sql: initcap(split_part(${clinical_order_type}, ' ', 1)) ;;
  }

  dimension: pcp_referrals_flag {
    type: yesno
    sql: ${clinical_order_type} = 'PRIMARY CARE REFERRAL' ;;
  }

  dimension: thr_referral {
    description: "A flag indicating the patient received a PCP referral to THR Access Center"
    type: number
    sql:  CASE
            WHEN ${clinical_order_type} = 'PRIMARY CARE REFERRAL' AND
                 ${status} <> 'DELETED' AND ${athenadwh_documents_provider.name} = 'THR ACCESS CENTER' THEN 1
            ELSE 0
          END ;;
  }

  measure: thr_pcp_referral  {
    type: max
    sql: ${thr_referral} ;;
  }

  measure: third_party_lab_imaging {
    type: max
    description: "A flag indicating that third party labs or imaging were ordered"
    sql: CASE
          WHEN ${document_class} = 'ORDER' AND ${athenadwh_order_providers.provider_category} = 'Performed by Third Party' THEN 1
          ELSE 0
        END ;;
  }

  dimension: rapid_strep_test {
    type: yesno
    description: "A flag indicating a rapid strep test"
    sql: ${clinical_order_type} LIKE '%RAPID STREP GROUP A%' ;;
  }

  dimension: referral_type {
    type: string
    sql: CASE
          WHEN ${clinical_order_type} LIKE '%REFERRAL%' THEN INITCAP(SUBSTRING(${clinical_order_type}, 1, POSITION('REFERRAL' in ${clinical_order_type})-1))
          ELSE INITCAP(${clinical_order_type})
        END
          ;;
    drill_fields: [
      athenadwh_referral_providers.name,
      athenadwh_referral_providers.provider_category
    ]
  }

  dimension: reportable_infectious_disease_labs {
    type: yesno
    description: "A flag indicating the order was one of the reportable infectious disease categories"
    sql: ${clinical_order_type} IN (
    'GIARDIA LAMBLIA AG, EIA, STOOL',
    'NOROVIRUS RNA, QUAL, PCR, STOOL',
    'MONONUCLEOSIS, HETEROPHILE AB, BLOOD',
    'GIARDIA LAMBLIA, CULTURE, STOOL',
    'METHICILLIN RESISTANT STAPHYLOCOCCUS AUREUS, CULTURE, UNSPECIFIED SPECIMEN',
    'MRSA SCREEN, PCR',
    'TRICHOMONAS VAGINALIS RNA',
    'HIV 1+2 AB + HIV 1 P24 AG, QUALITATIVE IMMUNOASSAY, SERUM',
    'GIARDIA + CRYPTOSPORIDIUM AG, STOOL',
    'HEPATITIS C VIRUS AB, SERUM',
    'HIV (1+2) ANTIBODIES, EIA, SERUM, REFLEX HIV-1 WESTERN BLOT (WB)',
    'LYME DISEASE IGG+IGM, SERUM, REFLEX WESTERN BLOT',
    'NEISSERIA GONORRHOEAE, CULTURE, UNSPECIFIED SPECIMEN',
    'HBSAG (HEPATITIS B SURFACE AG), EIA, SERUM',
    'HEPATITIS (A+B+C) PANEL, SERUM',
    'HEPATITIS C VIRUS RNA, QUANT, PCR, SERUM OR PLASMA',
    'ROTAVIRUS AG, QUAL, IMMUNOASSAY, STOOL',
    'ESCHERICHIA COLI O157:H7, CULTURE, STOOL',
    'HIV (1+2) AB SCREEN, SERUM',
    'MALARIA SMEAR, BLOOD',
    'BORDETELLA PERTUSSIS, CULTURE, UNSPECIFIED SPECIMEN',
    'GIARDIA LAMBLIA AG, STOOL',
    'HEPATITIS B VIRUS SURFACE AB, QUANTITATIVE IMMUNOASSAY, SERUM',
    'HIV-1 AB, QUANTITATIVE, SERUM',
    'RICKETTSIAL DISEASE PANEL, SERUM',
    'TB (M TUBERCULOSIS), IFN-GAMMA ELISA, BLOOD',
    'WEST NILE VIRUS AB, SERUM',
    'ADENOVIRUS C(40) + B(41) AG, QUAL IMMUNOASSAY, STOOL',
    'BORDETELLA PERTUSSIS, CULTURE, NASOPHARYNX',
    'BORDETELLA PERTUSSIS DNA, RESPIRATORY',
    'BORDETELLA PERTUSSIS + PARAPERTUSSIS DNA, RESPIRATORY',
    'CYTOMEGALOVIRUS (CMV) IGG+IGM AB, SERUM',
    'CYTOMEGALOVIRUS IGM AB, QUANT IMMUNOASSAY, SERUM',
    'DENGUE VIRUS IGG + IGM PANEL, IA, SERUM',
    'HBSAG (HEPATITIS B SURFACE AG) NEUTRALIZATION, SERUM',
    'HEPATITIS A AB, TOTAL, SERUM',
    'HEPATITIS A IGM AB, SERUM',
    'HEPATITIS B SURFACE AB, QUALITATIVE, SERUM',
    'HEPATITIS C AB, QUANTITATIVE, SERUM',
    'HEPATITIS C RNA, QUALITATIVE, SERUM',
    'HIV 1+2 AB + HIV1 P24 AG, QL, RAPID, IMMUNOASSAY, SERUM OR PLASMA OR BLOOD',
    'HIV (1+2) AB, SERUM (DONOR)',
    'HIV-1 DNA, QUALITATIVE, PLASMA',
    'HIV (1+O+2) AB, SERUM',
    'HIV-1 RNA GENOTYPE, PCR, SERUM OR PLASMA',
    'MALARIA THICK SMEAR, BLOOD',
    'MEASLES IGG+IGM AB, SERUM',
    'MEASLES VIRUS IGG AND IGM PANEL, CSF',
    'MUMPS IGG+IGM AB, SERUM',
    'MUMPS IGM AB, SERUM',
    'MUMPS VIRUS, CULTURE, UNSPECIFIED SPECIMEN',
    'SYPHILIS AB, IGG',
    'TOXOPLASMA IGG+IGM AB, SERUM',
    'VARICELLA-ZOSTER IGG AB SCREEN, SERUM');;
  }



  measure: order_type_concat {
    label: "Description Of Items Ordered"
    type: string
    sql: string_agg(DISTINCT ${clinical_order_type}, ' | ') ;;
  }

  measure: prescription_info_concat {
    label: "Description Of Prescription Medications"
    type: string
    sql: array_to_string(array_agg(DISTINCT
         CASE WHEN ${athenadwh_patient_prescriptions.prescribed_yn} = 'Y' THEN
            CONCAT(${clinical_order_type}, ': ',
             ${athenadwh_patient_prescriptions.dosage_route}, ': ',
             ${athenadwh_patient_prescriptions.frequency})
            ELSE NULL END
            ), ' | ')  ;;
  }

  measure: genus_type_concat {
    label: "Genus Of Items Ordered"
    type: string
    sql: string_agg(DISTINCT ${clinical_order_genus}, ' | ') ;;
  }

  dimension: prescriptions_flag {
    type: yesno
    sql: ${document_class} = 'PRESCRIPTION' ;;
  }

  dimension: clinical_letter_flag {
    type: yesno
    sql: ${document_class} LIKE '%LETTER%' OR ${document_class} LIKE '%ENCOUNTERDOCUMENT%' ;;
  }

  dimension: medicine_administered_onscene {
    type: yesno
    description: "A flag indicating that medicine was administered on-scene"
    sql: ${document_class} = 'PRESCRIPTION' AND ${clinical_provider_id} IS NULL ;;
  }

  dimension: labs_flag {
    type: yesno
    sql: ${document_class} = 'LABRESULT' ;;
  }

  dimension: imaging_flag {
    type: yesno
    sql: ${document_class} = 'IMAGINGRESULT' OR (${clinical_order_genus} = 'XR' AND ${document_class} = 'ORDER') ;;
  }

  dimension: dme_flag {
    type: yesno
    sql: ${document_class} = 'DME' ;;
  }

  dimension: orders_flag {
    type: yesno
    sql: ${document_class} = 'ORDER' ;;
  }

  dimension: pending_order_description {
    type: string
    hidden: yes
    sql: CASE WHEN ${document_class} = 'ORDER' AND ${status} LIKE 'SUBMIT%' AND ${clinical_order_type} NOT LIKE '%REFERRAL%' THEN ${clinical_order_type}
         ELSE NULL END  ;;
  }

  measure: pending_order_descriptions {
    type: string
    description: "The descriptions of all pending lab/imaging order"
    sql: array_to_string(array_agg(DISTINCT ${pending_order_description}), ' | ')  ;;
  }

  dimension: provider_referrals_flag {
    type: yesno
    sql: ${clinical_order_type} LIKE '%REFERRAL%' AND ${clinical_order_type} NOT LIKE 'HOME HEALTH%' ;;
  }

  dimension: home_health_referrals_flag {
    type: yesno
    sql: ${clinical_order_type} LIKE 'HOME HEALTH%REFERRAL' ;;
  }

  dimension: pcp_referral_flag {
    type: yesno
    sql: ${clinical_order_type} = 'PRIMARY CARE REFERRAL' ;;
  }

  dimension: clinical_provider_id {
    type: number
    sql: ${TABLE}.clinical_provider_id ;;
  }

  dimension_group: created {
    type: time
    convert_tz: no
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

  dimension: document_class {
    type: string
    sql: ${TABLE}.document_class ;;
  }

  dimension: document_id {
    type: number
    sql: ${TABLE}.document_id ;;
  }

  dimension: document_subclass {
    type: string
    sql: ${TABLE}.document_subclass ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: route {
    type: string
    sql: ${TABLE}.route ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: deleted_status {
    type: yesno
    sql: ${status} = 'DELETED' ;;
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

  measure: count_documents {
    type: count_distinct
    sql: ${document_id} ;;
  }

  measure: count_normal_results {
    type: count_distinct
    description: "Count of all orders where clinical results were normal"
    sql: ${document_id} ;;
    filters: {
      field: athenadwh_documentaction.action_group
      value: "Notify Patient - Normal"
    }
  }

  measure: count_abnormal_results {
    type: count_distinct
    description: "Count of all orders where clinical results were abnormal"
    sql: ${document_id} ;;
    filters: {
      field: athenadwh_documentaction.action_group
      value: "Notify Patient - Abnormal"
    }
  }

  measure: count_encounters {
    type: count_distinct
    sql: ${clinical_encounter_id} ;;
  }

  measure: count_letters {
    type: count_distinct
    sql: ${care_request_flat.care_request_id} ;;
    sql_distinct_key: ${care_request_flat.care_request_id} ;;
    filters: {
      field: clinical_letter_flag
      value: "yes"
    }
    filters: {
      field: care_requests.billable_est
      value: "yes"
    }
  }

  measure: count_pcp_letters {
    type: count_distinct
    description: "Count of clinical notes sent to PCP"
    sql: ${care_request_flat.care_request_id} ;;
    sql_distinct_key: ${care_request_flat.care_request_id} ;;
    filters: {
      field: clinical_letter_flag
      value: "yes"
    }
    filters: {
      field: care_requests.billable_est
      value: "yes"
    }
    filters: {
      field: care_team_members.pcp_provider_flag
      value: "yes"
    }
  }

  measure: count_non_pcp_letters {
    type: count_distinct
    description: "Count of clinical notes sent to someone other than PCP"
    sql: ${care_request_flat.care_request_id} ;;
    sql_distinct_key: ${care_request_flat.care_request_id} ;;
    filters: {
      field: clinical_letter_flag
      value: "yes"
    }
    filters: {
      field: care_requests.billable_est
      value: "yes"
    }
    filters: {
      field: care_team_members.pcp_provider_flag
      value: "no"
    }
  }

  measure: clinical_notes_boolean {
    type: yesno
    description: "A flag indicating that any clinical note was sent to a provider or specialist"
    sql: ${count_letters} > 0 ;;
  }

  dimension: letter_created_date {
    description: "Populates dates that are associated with a 'LETTER' document class only"
    type: date
    sql: CASE
        WHEN ${document_class} LIKE '%LETTER%' THEN ${created_date}
        ELSE NULL
        END;;
  }

  measure: letter_created_date_minimum {
    description: "Populates the minimum athenadwh_documents_clone.created_date value to identify the first document sent date"
    type: date
    sql:  min(${letter_created_date}) ;;

  }
}
