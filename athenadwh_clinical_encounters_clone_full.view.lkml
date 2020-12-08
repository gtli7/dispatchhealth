view: athenadwh_clinical_encounters_clone_full {
  sql_table_name: looker_scratch.athenadwh_clinical_encounters_clone_full ;;
  view_label: "ZZZZ - Athenadwh Clinical Encounters Clone (Full)"

  dimension: appointment_id {
    type: number
    sql: ${TABLE}.appointment_id ;;
  }

  dimension: chart_id {
    type: number
    sql: ${TABLE}.chart_id ;;
  }

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}.clinical_encounter_id ;;
  }

  dimension: closed_by {
    type: string
    sql: ${TABLE}.closed_by ;;
  }

  dimension: closed_by_supervisor {
    type: yesno
    sql: ${closed_by} IS NOT NULL AND ${closed_by} = ${athenadwh_supervising_provider_clone.provider_user_name} ;;
  }

  dimension: closed_by_provider {
    type: yesno
    sql: ${closed_by} IS NOT NULL AND ${closed_by} = ${athenadwh_provider_clone.provider_user_name} ;;
  }

  dimension_group: closed_datetime {
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
    sql: ${TABLE}.closed_datetime ;;
  }

  dimension: hours_to_chart_sign {
    description: "The number of hours between the on-scene time and the chart signature"
    type: number
    sql: (EXTRACT(EPOCH FROM ${closed_datetime_raw}) - EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}))/3600;;
    value_format: "0.0"
  }

  dimension: chart_signed_on_time {
    description: "A flag indicating that the chart was signed within 24 hours of visit"
    type: yesno
    sql: ${hours_to_chart_sign} <= 24 ;;
  }

  measure: count_charts_signed_on_time {
    description: "The count of distinct charts that were signed by the provider within 24 hours of the visit"
    type: count_distinct
    sql: ${chart_id} ;;
    filters: {
      field: chart_signed_on_time
      value: "yes"
    }
  }

  measure: last_closed_datetime {
    type: date
    sql: MAX(${closed_datetime_raw}) ;;
    convert_tz: no
  }

  dimension_group: created_datetime {
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
    sql: ${TABLE}.created_datetime ;;
  }

  dimension_group: encounter {
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
    sql: ${TABLE}.encounter_date ;;
  }

  dimension: encounter_status {
    type: string
    sql: ${TABLE}.encounter_status ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: provider_id {
    type: number
    sql: ${TABLE}.provider_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
