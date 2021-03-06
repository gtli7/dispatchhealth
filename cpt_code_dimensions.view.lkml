view: cpt_code_dimensions {
  label: "CPT Code Dimensions"
  sql_table_name: jasperdb.cpt_code_dimensions ;;

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
    sql: ${TABLE}.cpt_code ;;
  }

  measure: cpt_code_concat {
    label: "CPT Codes"
    type: string
    sql: GROUP_CONCAT(DISTINCT ${cpt_code} SEPARATOR ' | ') ;;
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
    sql: GROUP_CONCAT(DISTINCT ${description} SEPARATOR ' | ') ;;
  }

  dimension: cpt_code_and_description {
    description: "The CPT code only (less prefixes and suffixes) with the description"
    type: string
    sql: CONCAT(${cpt_code}, " - ", ${description}) ;;
  }

  dimension: e_and_m_code {
    label: "E&M CPT code flag"
    description: "Flag to indicate whether the CPT code is an E&M code"
    type: yesno
    sql: ${TABLE}.e_and_m_code ;;
  }

  dimension: em_care_level {
    label: "E&M Code Care Level"
    description: "Indicates the level of care received by patient"
    type: string
    sql: ${TABLE}.em_care_level ;;
  }

  measure: em_care_level_concat {
    label: "E&M Code Care Levels"
    type: string
    sql:  GROUP_CONCAT(DISTINCT ${em_care_level} SEPARATOR '');;
  }

  dimension: em_patient_type {
    label: "E&M Code Patient Type"
    description: "Code for Established v. New patient"
    type: string
    sql: ${TABLE}.em_patient_type ;;
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
