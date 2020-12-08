view: athena_clinicalencounter {
  sql_table_name: athena.clinicalencounter ;;
  drill_fields: [id]
  view_label: "Athena Clinical Encounters"

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."id" ;;
  }

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

  dimension: appointment_char {
    type: string
    hidden: yes
    sql: ${TABLE}."appointment_char" ;;
  }

  dimension: appointment_id {
    type: number
    group_label: "IDs"
    # hidden: yes
    sql: ${TABLE}."appointment_id" ;;
  }

  dimension: appointment_tickler_id {
    type: number
    hidden: yes
    sql: ${TABLE}."appointment_tickler_id" ;;
  }

  dimension: assigned_to {
    type: string
    hidden: yes
    sql: ${TABLE}."assigned_to" ;;
  }

  dimension: billing_tab_reviewed {
    type: string
    description: "The user and date/time that the billing tab was reviewed"
    sql: ${TABLE}."billing_tab_reviewed" ;;
  }

  dimension: chart_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."chart_id" ;;
  }

  dimension: claim_id {
    type: number
    group_label: "IDs"
    # hidden: yes
    sql: ${TABLE}."claim_id" ;;
  }

  dimension: clinical_encounter_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."clinical_encounter_id" ;;
  }

  dimension: clinical_encountertype {
    type: string
    description: "The encounter type: VISIT or ORDERSONLY"
    sql: ${TABLE}."clinical_encountertype" ;;
  }

  dimension: closed_by {
    type: string
    description: "The Athena user that closed the encounter"
    sql: ${TABLE}."closed_by" ;;
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
    sql: ${TABLE}."closed_datetime" ;;
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
    hidden: yes
    sql: ${TABLE}."created_by" ;;
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

  dimension: department_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."department_id" ;;
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
    sql: ${TABLE}."encounter_date" ;;
  }

  dimension: encounter_status {
    type: string
    description: "The status of the encounter e.g. 'checked in', etc."
    sql: ${TABLE}."encounter_status" ;;
  }

  dimension: patient_char {
    type: string
    hidden: yes
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: patient_location {
    type: string
    hidden: yes
    sql: ${TABLE}."patient_location" ;;
  }

  dimension: patient_status {
    type: string
    hidden: yes
    sql: ${TABLE}."patient_status" ;;
  }

  dimension: provider_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."provider_id" ;;
  }

  dimension: specialty {
    type: string
    hidden: yes
    sql: ${TABLE}."specialty" ;;
  }

  dimension: supervising_provider_id {
    type: number
    hidden: yes
    sql: ${TABLE}."supervising_provider_id" ;;
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

  dimension_group: chart_first_closed {
    type: time
    description: "The timestamp when the chart was first closed by the provider"
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."__chart_first_closed_datetime" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  measure: count_distinct_charts {
    type: count_distinct
    sql: ${chart_id} ;;
    filters: [encounter_status: "-DELETED"]
    group_label: "Counts"
  }

  measure: count_symptom_based_charts {
    type: count_distinct
    sql: ${chart_id} ;;
    group_label: "Counts"
    filters: {
      field: athena_diagnosis_codes.symptom_based_diagnosis
      value: "yes"
    }
  }

  measure: count_comorbidity_based_charts {
    type: count_distinct
    description: "Count of charts that have non-primary comorbidity diagnoses"
    sql: ${chart_id} ;;
    group_label: "Counts"
    filters: {
      field: athena_diagnosis_codes.comorbidity_based_diagnosis
      value: "yes"
    }
  }

  dimension: hours_to_chart_sign {
    description: "The number of hours between the on-scene time and the chart signature"
    type: number
    hidden: yes
    sql: CASE
          WHEN ${chart_first_closed_raw} >= ${chart_first_closed_raw}
                THEN (EXTRACT(EPOCH FROM ${chart_first_closed_raw}) - EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}))/3600
                ELSE NULL END ;;
    value_format: "0.0"
  }

  dimension: chart_signed_24_hours {
    description: "A flag indicating that the chart was signed within 24 hours of visit"
    type: yesno
    hidden: yes
    sql: ${hours_to_chart_sign} <= 24 ;;
  }

  dimension: chart_signed_48_hours {
    description: "A flag indicating that the chart was signed within 48 hours of visit"
    type: yesno
    hidden: yes
    sql: ${hours_to_chart_sign} <= 48 ;;
  }

  measure: count_charts_signed_24_hours {
    description: "The count of distinct charts that were signed by the provider within 24 hours of the visit"
    type: count_distinct
    group_label: "Counts"
    sql: ${clinical_encounter_id} ;;
    filters: [chart_signed_24_hours: "yes"]
  }

  measure: count_charts_signed_48_hours {
    description: "The count of distinct charts that were signed by the provider within 48 hours of the visit"
    type: count_distinct
    group_label: "Counts"
    sql: ${clinical_encounter_id} ;;
    filters: [chart_signed_48_hours: "yes"]
  }

  measure: count {
    type: count
    drill_fields: [id, appointment.rescheduled_appointment_id, claim.original_claim_id]
  }
}
