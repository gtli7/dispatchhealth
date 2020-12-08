view: athenadwh_icdcodeall {
  view_label: "ZZZZ - ICD Diagnosis Codes and Descriptions"
  sql_table_name: looker_scratch.athenadwh_icdcodeall ;;

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
    sql: SUBSTRING(TRIM(${TABLE}.diagnosis_code), 0, 4) ;;
  }

  dimension: antibiotic_stewardship_diagnosis {
    type: string
    description: "The combined primary diagnoses for bronchitis, sinusitis, pharyngitis, and UTI"
    sql: CASE
          WHEN ${diagnosis_code} = 'J01' THEN 'Sinusitis'
          WHEN ${diagnosis_code} = 'J02' THEN 'Pharyngitis'
          WHEN ${diagnosis_code} IN ('J20','J40') OR ${unstripped_diagnosis_code} = 'J06.9' THEN 'Bronchitis'
          ELSE 'Other'
        END ;;
  }

  measure: diagnosis_code_max {
    type: string
    sql:  MAX(${diagnosis_code}) ;;
  }

  dimension: diagnosis_code_full {
    type: string
    description: "The full diagnosis code (not restricted to first 3 characters)"
    sql: ${TABLE}.diagnosis_code ;;
  }

  dimension: symptom_based_diagnosis {
    type: yesno
    description: "A flag indicating the ICD-10 code is symptoms-based. Use only with ICD Primary Diagnosis Codes"
    sql: ${diagnosis_code_full} IN ('R05','R509','R197','R112','R1110','R42','T148XXA','R070','R410','K5900','R51',
                                    'R5383','R6889','R110','R0981','R0602','R062') AND ${athenadwh_clinicalencounter_diagnosis.ordering} = 0 ;;
  }

  dimension: comorbidity_based_diagnosis {
    type: yesno
    hidden: yes
    description: "A flag indicating the non-primary ICD-10 code is a co-morbidity. Use only to count charts"
    sql: ${diagnosis_code} IN ('E10','E11','E13','I10','I87','J45') AND ${athenadwh_clinicalencounter_diagnosis.ordering} > 0 ;;
  }

  dimension: icd_risk_protocol_match {
    type: yesno
    sql:
    (${diagnosis_code_full} = 'N390' AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Blood In Urine|Urinary Tract Infection|Abdominal Pain)%') OR
    (${diagnosis_code_full} IN ('J069','R05') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Upper Respiratory|Shortness Of Breath|Cough/URI|Cough/Uri|Flu-Like Symptoms)%') OR
    (${diagnosis_code_full} IN ('E860') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Dehydration|Weakness|Lethargy|Lethargic|Nausea/Vomiting)%') OR
    (${diagnosis_code_full} IN ('R509') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Fever|Upper Respiratory Symptoms)%') OR
    (${diagnosis_code_full} IN ('J209', 'J441', 'J189') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Upper Respiratory Symptoms|Shortness Of Breath|Flu-Like Symptoms)%') OR
    (${diagnosis_code_full} IN ('J029') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Sore Throat|Upper Respiratory Symptoms|Sinus Pain)%') OR
    (${diagnosis_code_full} IN ('R197') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Diarrhea|Abdominal Pain)%') OR
    (${diagnosis_code_full} IN ('R112') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Nausea/Vomiting|Dehydration)%') OR
    (${diagnosis_code_full} IN ('J189') AND
    ${risk_assessments.protocol_name} = 'Fever') OR
    (${diagnosis_code_full} IN ('M6281') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Weakness|Lethargy|Lethargic)%') OR
    (${diagnosis_code_full} IN ('R42') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Dizziness|Weakness)%') OR
    (${diagnosis_code_full} IN ('R300') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Blood In Urine|Abdominal Pain)%') OR
    (${diagnosis_code_full} IN ('J0190') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Sinus Pain|Upper Respiratory Symptoms)%') OR
    (${diagnosis_code_full} IN ('B349') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Fever|Upper Respiratory Symptoms|Sinus Pain|Flu-Like Symptoms|Rash)%') OR
    (${diagnosis_code_full} IN ('R600') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Extremity Swelling|Extremity Pain)%') OR
    (${diagnosis_code_full} IN ('I509') AND
    ${risk_assessments.protocol_name} SIMILAR TO '%(Shortness Of Breath|Chest Pain|Upper Respiratory Symptoms)%') OR
    (${diagnosis_code_full} IN ('R1110') AND
    ${risk_assessments.protocol_name} = 'Nausea/Vomiting')
    ;;
  }

  dimension: diagnosis_description {
    type: string
    sql: ${TABLE}.diagnosis_code_description ;;
  }

  measure: diagnosis_description_max {
    type: string
    sql: MAX(${diagnosis_description}) ;;
  }

  dimension: diagnosis_code_group {
    type: string
    sql: ${TABLE}.diagnosis_code_group ;;
  }

  dimension: diagnosis_code_set {
    type: string
    sql: ${TABLE}.diagnosis_code_set ;;
  }

  dimension: disease_state {
    type: string
    description: "Grouped disease state for post-acute reporting"
    sql: CASE
          WHEN ${diagnosis_code} = 'I50' THEN 'CHF'
          WHEN ${diagnosis_code} = 'J44' THEN 'COPD'
          WHEN ${diagnosis_code} = 'A41' THEN 'Sepsis'
          WHEN ${diagnosis_code} IN ('J12', 'J18', 'J84', 'Z87') THEN 'Pneumonia'
          WHEN ${diagnosis_code} IN ('L03', 'K12', 'H05', 'N48') THEN 'Cellulitis'
          WHEN ${diagnosis_code} = 'Z96' THEN 'Post-Op Total Joint'
          ELSE 'Other'
        END;;
    drill_fields: [diagnosis_code,
      diagnosis_description]
  }

  dimension: confusion_altered_awareness {
    type: yesno
    description: "Diagnosis of confusion, altered awareness, weakness, or behavioral disturbance"
    sql: ${diagnosis_code} IN ('R40','R41','R53','F03') ;;
  }

  dimension: wheelchair_homebound {
    type: yesno
    description: "Diagnosis of Hemiplegia, paraplegia or homebound medical necessity"
    sql: ${diagnosis_code} IN ('G81','G82') OR ${medical_necessity_notes.note} SIMILAR TO '%(mobility issues|transportation|leave the home)%' ;;
  }

  measure: diagnosis_codes_concat {
    label: "ICD 10 Diagnosis Codes"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${diagnosis_code}), ' | ') ;;
  }

  measure: count_distinct_icd_10 {
    type: count_distinct
    sql: ${diagnosis_code} ;;
  }

  measure: disease_state_concat {
    label: "Disease State(s)"
    type: string
    sql: array_to_string(array_agg(DISTINCT  ${disease_state}), ', ') ;;
  }

  measure: diagnosis_desc_concat {
    label: "ICD 10 Diagnosis Descriptions"
    type: string
    sql: array_to_string(array_agg(DISTINCT COALESCE(${diagnosis_description},${icd_code_dimensions_clone.diagnosis_description})), ' | ') ;;
  }

  dimension: likely_flu_diganosis {
    type: yesno
    sql: ${diagnosis_code} in('J09', 'J11', 'J10','J06',  'J20', 'J18', 'J20') ;;
  }

  dimension_group: effective {
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
    sql: ${TABLE}.effective_date ;;
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
    sql: ${TABLE}.expiration_date ;;
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
