view: cpt_code_dimensions_clone {
  label: "ZZZZ - CPT Code Dimensions Clone"
  sql_table_name: looker_scratch.cpt_code_dimensions_clone ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: code_suffix {
    description: "CPT code part"
    type: string
    sql: ${TABLE}.code_suffix ;;
  }

  dimension: cpt_code {
    label: "CPT code"
    type: string
    sql: CASE WHEN ${TABLE}.cpt_code = 'S9083' THEN NULL ELSE ${TABLE}.cpt_code END ;;
  }

  dimension: cpt_code_acuity_category {
    description: "Category of CPT code based on high/low acuity and new/existing patient"
    type: string
    sql: CASE
          WHEN ${cpt_code} = '99345' THEN 'High Acuity New Patient'
          WHEN ${cpt_code} = '99350' THEN 'High Acuity Existing Patient'
          WHEN ${cpt_code} = '99342' THEN 'Low Acuity New Patient'
          WHEN ${cpt_code} = '99348' THEN 'Low Acuity Existing Patient'
          ELSE 'Other'
        END ;;
  }

  measure: cpt_code_concat {
    label: "CPT Codes"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${cpt_code}), ' | ') ;;
  }

  dimension: cpt_code_flag {
    description: "Flag indicating whether or not a CPT code exists"
    type: yesno
    sql:  COALESCE(${cpt_code}) IS NOT NULL;;
  }

  dimension: cpt_edition {
    label: "CPT edition"
    description: "The verson of the CPT code used"
    type: string
    sql: ${TABLE}.cpt_edition ;;
  }

  dimension_group: created {
    hidden: yes
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

  dimension: description {
    description: "The code describes medical, surgical, and diagnostic services and is designed to communicate uniform information about medical services and procedures."
    type: string
    sql: ${TABLE}.description ;;
  }

  measure: cpt_descrip_concat {
    label: "CPT Descriptions"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${description}), ' | ') ;;
  }

  dimension: cpt_code_and_description {
    description: "The CPT code only (less prefixes and suffixes) with the description"
    type: string
    sql: CASE
          WHEN ${cpt_code} IS NOT NULL THEN CONCAT(${cpt_code}, ' - ', ${description})
          ELSE NULL
        END ;;
  }

  dimension: e_and_m_code {
    type: number
    sql: ${TABLE}.e_and_m_code ;;
  }

  dimension: ekg_performed {
    type: yesno
    sql: ${cpt_code} IN ('93005', '93010', '93000') ;;
  }

  dimension: nebulizer {
    type: yesno
    sql: ${cpt_code} = '94640' ;;
  }

  dimension: iv_fluids {
    type: yesno
    sql: ${cpt_code} IN ('96360', '96361') ;;
  }

  dimension: blood_tests {
    type: yesno
    sql: ${cpt_code} IN ('80047', '36415', '36410', '85014', '83605', '85610', '34616') ;;
  }

  dimension: blood_iv {
    type: yesno
    sql: ${iv_fluids} OR ${blood_tests} ;;
  }

  dimension: catheter_placement {
    type: yesno
    sql: ${cpt_code} IN ('51702', '51701', '51703', '51705') ;;
  }

  dimension: laceration_repair {
    type: yesno
    sql: ${cpt_code} IN ('12001', '12002', '12004', '12011', '12013', '12014', '12015', '12031', '12032', '12034', '12035', '12036', '12041', '12042', '12044', '12051', '12052', '12053', '12054') ;;
  }

  dimension: epistaxis {
    type: yesno
    sql: ${cpt_code} IN ('30901', '30903', '30905', '30906') ;;
  }

  dimension: hernia_rp_reduction {
    type: yesno
    sql: ${cpt_code} IN ('49999') ;;
  }

  dimension: joint_reduction {
    type: yesno
    sql: ${cpt_code} IN ('24640', '26770') ;;
  }

  dimension: gastronomy_tube {
    type: yesno
    sql: ${cpt_code} IN ('49450', '43760') ;;
  }

  dimension: abscess_drain {
    type: yesno
    sql: ${cpt_code} IN ('10060', '10061') ;;
  }

  dimension: any_cs_procedure {
    description: "Any procedure that impacts cost savings calculation"
    type: yesno
    sql: ${ekg_performed} OR ${nebulizer} OR ${iv_fluids} OR ${blood_tests} OR ${catheter_placement} OR ${laceration_repair} OR ${epistaxis} OR
    ${hernia_rp_reduction} OR ${joint_reduction} OR ${gastronomy_tube} OR ${abscess_drain} ;;
  }

  dimension: e_and_m_flag {
    label: "E&M CPT code flag"
    description: "Flag to indicate whether the CPT code is an E&M code"
    type: yesno
    sql: ${e_and_m_code} = 1 ;;
  }

  dimension: non_em_cpt_flag {
    type: yesno
    sql: ${cpt_code_flag} AND NOT ${e_and_m_flag} ;;
  }

  dimension: em_care_level {
    label: "E&M Code Care Level"
    description: "Indicates the level of care received by patient"
    type: number
    sql: (case when cpt_code_dimensions_clone.em_care_level='' then NULL
      else cpt_code_dimensions_clone.em_care_level  end)::int;;
  }

  measure: avg_em_care_level {
    label: "Average E&M Code Care Level"
    type: average
    sql: ${em_care_level};;
    value_format: "0.00"
  }

  measure: em_care_level_concat {
    label: "E&M Code Care Levels"
    type: string
    sql:  array_to_string(array_agg(DISTINCT ${em_care_level}), ' ');;
  }

  dimension: em_patient_type {
    label: "E&M Code Patient Type"
    description: "Code for Established v. New patient"
    type: string
    sql: CASE
          WHEN ${TABLE}.em_patient_type = 'NP' THEN 'New'
          WHEN ${TABLE}.em_patient_type = 'EP' THEN 'Established'
          ELSE ''
        END ;;
  }

  dimension: facility_type {
    description: "The type of facility where care was delivered"
    type: string
    sql: ${TABLE}.facility_type ;;
  }

  dimension: modifiers {
    label: "CPT code modifiers"
    description: "CPT code part"
    type: string
    sql: ${TABLE}.modifiers ;;
  }

  dimension_group: updated {
    hidden: yes
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
