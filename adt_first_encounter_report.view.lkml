view: adt_first_encounter_report {
  sql_table_name: external_adt_merged.adt_first_encounter_report ;;

  dimension_group: care_request_begin {
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
    sql: ${TABLE}."care_request_begin_time" ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
  }

  dimension: cr_to_er_diff {
    type: string
    sql: ${TABLE}."cr_to_er_diff" ;;
  }

  dimension: cr_to_hosp_diff {
    type: string
    sql: ${TABLE}."cr_to_hosp_diff" ;;
  }

  dimension: dh_patient_id {
    type: number
    sql: ${TABLE}."dh_patient_id" ;;
  }

  dimension_group: er_admit {
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
    sql: ${TABLE}."er_admit_time" ;;
  }

  dimension: er_data_source {
    type: string
    sql: ${TABLE}."er_data_source" ;;
  }

  dimension: er_diagnoses {
    type: string
    sql: ${TABLE}."er_diagnoses" ;;
  }

  dimension: er_facility_name {
    type: string
    sql: ${TABLE}."er_facility_name" ;;
  }

  dimension: first_er_encounter_id {
    type: string
    sql: ${TABLE}."first_er_encounter_id" ;;
  }

  dimension: first_er_is_hospitalization {
    type: yesno
    sql: ${TABLE}."first_er_is_hospitalization" ;;
  }

  dimension: first_hosp_encounter_id {
    type: string
    sql: ${TABLE}."first_hosp_encounter_id" ;;
  }

  dimension_group: hosp_admit {
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
    sql: ${TABLE}."hosp_admit_time" ;;
  }

  dimension: hosp_data_source {
    type: string
    sql: ${TABLE}."hosp_data_source" ;;
  }

  dimension: hosp_diagnoses {
    type: string
    sql: ${TABLE}."hosp_diagnoses" ;;
  }

  dimension: hosp_facility_name {
    type: string
    sql: ${TABLE}."hosp_facility_name" ;;
  }

  measure: count {
    type: count
    drill_fields: [er_facility_name, hosp_facility_name]
  }
}
