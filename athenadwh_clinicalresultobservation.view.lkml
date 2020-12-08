view: athenadwh_clinicalresultobservation {
  sql_table_name: looker_scratch.athenadwh_clinicalresultobservation ;;
  view_label: "ZZZZ - Athenadwh Clinicalresultobservation"
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: clinical_observation_id {
    type: number
    hidden: yes
    sql: ${TABLE}."clinical_observation_id" ;;
  }

  dimension: clinical_result_id {
    type: number
    hidden: yes
    sql: ${TABLE}."clinical_result_id" ;;
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

  dimension: created_by {
    type: string
    description: "The Athena user that created the clinical lab"
    sql: ${TABLE}."created_by" ;;
  }

  dimension_group: created_datetime {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."created_datetime" ;;
  }

  dimension: deleted_by {
    type: string
    sql: ${TABLE}."deleted_by" ;;
  }

  dimension_group: deleted_datetime {
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
    sql: ${TABLE}."deleted_datetime" ;;
  }

  dimension: loinc_id {
    type: number
    hidden: yes
    sql: ${TABLE}."loinc_id" ;;
  }

  dimension: observation_abnormal_flag_id {
    type: string
    description: "An indicator that the clinical observation is outside the normal range e.g. 'HIGH'"
    sql: ${TABLE}."observation_abnormal_flag_id" ;;
  }

  dimension: observation_identifier {
    type: string
    hidden: yes
    sql: ${TABLE}."observation_identifier" ;;
  }

  dimension: observation_identifier_text {
    type: string
    description: "The description of the test being performed"
    sql: ${TABLE}."observation_identifier_text" ;;
  }

  dimension: observation_units {
    type: string
    description: "The units that correspond to the test e.g. 'MG/DL'"
    sql: ${TABLE}."observation_units" ;;
  }

  dimension: observation_value_type {
    type: string
    hidden: yes
    sql: ${TABLE}."observation_value_type" ;;
  }

  dimension: performing_lab_key {
    type: string
    hidden: yes
    sql: ${TABLE}."performing_lab_key" ;;
  }

  dimension: reference_range {
    type: string
    description: "The normal range for the lab test results"
    sql: ${TABLE}."reference_range" ;;
  }

  dimension: result {
    type: string
    description: "The recorded result of the test"
    sql: ${TABLE}."result" ;;
  }

  dimension: template_analyte_name {
    type: string
    description: "The template of the test if one was selected"
    sql: ${TABLE}."template_analyte_name" ;;
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

  measure: count {
    type: count
    drill_fields: [id, template_analyte_name]
  }
}
