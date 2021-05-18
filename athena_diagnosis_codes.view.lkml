view: athena_diagnosis_codes {
  sql_table_name: athena.icdcodeall ;;

  dimension: __batch_id {
    type: string
    hidden: yes
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension_group: __file {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    hidden: yes
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: bodily_system {
    type: string
    sql: ${TABLE}."bodily_system" ;;
    group_label: "Diagnosis Descriptions"
    drill_fields: [diagnosis_code_group, diagnosis_description]
  }

  dimension: code_class {
    type: string
    hidden: yes
    sql: ${TABLE}."code_class" ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
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
    description: "The long diagnosis code without decimal e.g. T79A21A"
    sql: ${TABLE}."diagnosis_code" ;;
    group_label: "Diagnosis Codes"
  }

  dimension: diagnosis_description {
    type: string
    description: "e.g. Mucopurulent chronic bronchitis"
    sql: ${TABLE}."diagnosis_code_description" ;;
    group_label: "Diagnosis Descriptions"
    drill_fields: [bodily_system, diagnosis_code_group, athena_medication_details.medication_name_short]
  }

  dimension: factors_of_health_status_and_contact_health_services_diagnoses {
    description: "Identifies 'z' prefixed ICD-10 codes (Bodily System = 'Factors influencing health status and contact with health services' OR diagnosis_group = 'Persons encountering health services in circumstances related to reproduction')"
    type: yesno
    sql: lower(${bodily_system}) = 'factors influencing health status and contact with health services'
          OR lower(${diagnosis_code_group}) = 'persons encountering health services in circumstances related to reproduction (z30-z39)';;
  }

  dimension: asymptomatic_covid_related {
    type: yesno
    group_label: "Diagnosis Descriptions"
    sql: ${diagnosis_code}  in('Z20828', 'Z03818','Z0389', 'Z209') ;;
    drill_fields: [diagnosis_description, bodily_system, diagnosis_code_group]
  }

  dimension: diagnosis_code_group {
    type: string
    description: "e.g. CHRONIC LOWER RESPIRATORY DISEASES (J40-J47)"
    sql: INITCAP(${TABLE}."diagnosis_code_group") ;;
    group_label: "Diagnosis Descriptions"
    drill_fields: [diagnosis_code_short, diagnosis_description]
  }

  dimension: sequence_number {
    type: number
    description: "The priority of the diagnosis e.g. 1 = first diagnosis code, etc."
    group_label: "Diagnosis Priority"
    sql: ${athena_diagnosis_sequence.sequence_number} ;;
  }

  dimension: diagnosis_code_short {
    type: string
    description: "First 3 characters of the diagnosis code"
    sql: ${TABLE}."diagnosis_code_short" ;;
    group_label: "Diagnosis Codes"
    drill_fields: [diagnosis_code]
  }

  dimension: drg_code {
    type: string
    description: "The associated DRG code, if any"
    sql: ${TABLE}."drg_code" ;;
    group_label: "Diagnosis Codes"
  }

  dimension: antibiotic_stewardship_diagnosis {
    type: string
    group_label: "Diagnosis Descriptions"
    description: "The combined primary diagnoses for bronchitis, sinusitis, pharyngitis, and UTI"
    sql: CASE
          WHEN ${diagnosis_code_short} = 'J01' THEN 'Sinusitis'
          WHEN ${diagnosis_code_short} = 'J02' THEN 'Pharyngitis'
          WHEN ${diagnosis_code_short} IN ('J20','J40') OR ${unstripped_diagnosis_code} = 'J06.9' THEN 'Bronchitis'
          ELSE 'Other'
        END ;;
  }

  dimension_group: effective {
    type: time
    hidden: yes
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."effective_date" ;;
  }

  dimension_group: expiration {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."expiration_date" ;;
  }

  dimension: icd_code_id {
    type: number
    hidden: yes
    sql: ${TABLE}."icd_code_id" ;;
  }

  dimension: parent_diagnosis_code {
    type: string
    hidden: yes
    sql: ${TABLE}."parent_diagnosis_code" ;;
  }

  dimension: sub_category {
    type: string
    hidden: yes
    sql: ${TABLE}."sub_category" ;;
  }

  dimension: unstripped_diagnosis_code {
    type: string
    description: "Diagnosis code with decimal e.g. Z3A.31"
    sql: ${TABLE}."unstripped_diagnosis_code" ;;
    group_label: "Diagnosis Codes"
  }

  dimension_group: updated {
    type: time
    hidden: yes
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

  dimension: symptom_based_diagnosis {
    type: yesno
    group_label: "Diagnosis Descriptions"
    description: "A flag indicating the ICD-10 code is symptoms-based. Use only with ICD Primary Diagnosis Codes"
    sql: ${diagnosis_code} IN ('R05','R509','R197','R112','R1110','R42','T148XXA','R070','R410','K5900','R51',
      'R5383','R6889','R110','R0981','R0602','R062') AND ${athena_diagnosis_sequence.sequence_number} = 1 ;;
  }

  dimension: comorbidity_based_diagnosis {
    type: yesno
    hidden: yes
    description: "A flag indicating the non-primary ICD-10 code is a co-morbidity. Use only to count charts"
    sql: ${diagnosis_code_short} IN ('E10','E11','E13','I10','I87','J45') AND ${athena_diagnosis_sequence.sequence_number} > 1 ;;
  }

  dimension: disease_state {
    type: string
    description: "Grouped disease state for post-acute reporting"
    sql: CASE
          WHEN ${diagnosis_code_short} = 'I50' THEN 'CHF'
          WHEN ${diagnosis_code_short} = 'J44' THEN 'COPD'
          WHEN ${diagnosis_code_short} = 'A41' THEN 'Sepsis'
          WHEN ${diagnosis_code_short} IN ('J12', 'J18', 'J84', 'Z87') THEN 'Pneumonia'
          WHEN ${diagnosis_code_short} IN ('L03', 'K12', 'H05', 'N48') THEN 'Cellulitis'
          WHEN ${diagnosis_code_short} = 'Z96' THEN 'Post-Op Total Joint'
          ELSE 'Other'
        END;;
    drill_fields: [diagnosis_code,
      diagnosis_description]
    group_label: "Diagnosis Descriptions"
  }

  measure: diagnosis_codes_concatenated {
    description: "Concatenated ICD-10 Diagnosis Codes"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${diagnosis_code_short}), ' | ') ;;
    group_label: "Diagnosis Codes"
  }

  measure: diagnosis_codes_parent_concatenated {
    description: "Concatenated ICD-10 Diagnosis Codes"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${parent_diagnosis_code}), ' | ') ;;
    group_label: "Diagnosis Codes"
  }

  measure: disease_states_concatenated {
    label: "Concatenated Disease State(s)"
    type: string
    sql: array_to_string(array_agg(DISTINCT  ${disease_state}), ', ') ;;
    group_label: "Diagnosis Descriptions"
  }

  measure: diagnosis_descriptions_concatenated {
    description: "Concatenated ICD-10 Diagnosis Descriptions"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${diagnosis_description}), ' | ') ;;
    group_label: "Diagnosis Descriptions"
  }

  dimension: likely_flu_diganosis {
    type: yesno
    description: "Diagnosis code is one of: J06, J09, J10, J11, J18"
    group_label: "Diagnosis Descriptions"
    sql: ${diagnosis_code_short} in('J09', 'J11', 'J10','J06', 'J20', 'J18') ;;
  }

  dimension: abscess_based_diagnosis {
    description: "Diagnosis descritpion contians the word 'abscess'"
    type: yesno
    group_label: "Diagnosis Descriptions"
    sql: lower(${diagnosis_description}) LIKE '%abscess%';;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: count_distinct_diagnosis_codes {
    description: "Counts the number of distinct ICD-10 diagnosis codes assigned to a care request"
    type: count_distinct
    sql: ${care_requests.id}||${diagnosis_code} ;;
  }

  measure: count_distinct_bodily_systems {
    description: "Counts the number of distinct bodily systems assigned to a care request"
    type: count_distinct
    sql: ${care_requests.id}||${bodily_system} ;;
  }

}
