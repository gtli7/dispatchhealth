view: athenadwh_chart_closing {
  derived_table: {
    sql: SELECT
        ce.clinical_encounter_id,
        ce.patient_id,
        ce.chart_id,
        ce.appointment_id,
        ce.provider_id,
        ce.encounter_date,
        ce.encounter_status,
        MIN(ce.created_datetime) AS created_datetime,
        MIN(ce.closed_datetime) AS closed_datetime,
        ce.closed_by
        FROM athenadwh_clinical_encounters_clone_full ce
        JOIN (
              SELECT
                clinical_encounter_id,
                closed_datetime,
                ROW_NUMBER() OVER(PARTITION BY clinical_encounter_id
                                      ORDER BY closed_datetime) AS rn
              FROM athenadwh_clinical_encounters_clone_full
              WHERE encounter_status = 'CLOSED') ce_first
        ON ce.clinical_encounter_id = ce_first.clinical_encounter_id AND ce_first.rn = 1
        JOIN athenadwh_patients_clone p
          ON ce.patient_id = p.patient_id AND p.new_patient_id IS NULL
        WHERE ce.encounter_status = 'CLOSED'
        GROUP BY 1,2,3,4,5,6,7,10 ;;

  indexes: ["clinical_encounter_id", "patient_id", "chart_id", "appointment_id", "provider_id"]
  sql_trigger_value: SELECT COUNT(*) FROM athenadwh_clinical_encounters_clone ;;
  }

  view_label: "ZZZZ - Athenadwh Chart Closing"

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}.clinical_encounter_id ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: chart_id {
    type: number
    sql: ${TABLE}.chart_id ;;
  }

  dimension: closed_by_provider {
    type: yesno
    sql: ${closed_by} IS NOT NULL AND ${closed_by} = ${athenadwh_provider_clone.provider_user_name} ;;
  }

  dimension: appointment_id {
    type: number
    sql: ${TABLE}.appointment_id ;;
  }

  dimension: provider_id {
    type: number
    sql: ${TABLE}.provider_id ;;
  }

  dimension_group: encounter {
    type: time
    convert_tz: no
    timeframes: [
      date,
      week,
      month,
      day_of_week,
      day_of_month
    ]
    sql: ${TABLE}.encounter_date ;;
  }

  dimension: encounter_status {
    type: string
    sql: ${TABLE}.encounter_status ;;
  }

  dimension_group: created {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week,
      day_of_month
    ]
    sql: ${TABLE}.created_datetime ;;
  }

  dimension_group: closed {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week,
      day_of_month
    ]
    sql: ${TABLE}.closed_datetime AT TIME ZONE 'US/Eastern' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: closed_by {
    type: string
    sql: ${TABLE}.closed_by ;;
  }

  dimension: hours_to_chart_sign {
    description: "The number of hours between the on-scene time and the chart signature"
    type: number
    sql: (EXTRACT(EPOCH FROM ${closed_raw}) - EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}))/3600;;
    value_format: "0.0"
  }

  measure: count_distinct_charts {
    description: "The count of distinct charts"
    type: count_distinct
    sql: ${chart_id} ;;
  }

  dimension: chart_signed_on_time {
    description: "A flag indicating that the chart was signed within 24 hours of visit"
    type: yesno
    sql: ${hours_to_chart_sign} <= 24 ;;
  }

  dimension: chart_signed_48_hours {
    description: "A flag indicating that the chart was signed within 48 hours of visit"
    type: yesno
    sql: ${hours_to_chart_sign} <= 48 ;;
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

  measure: count_charts_by_clinical_encounter_signed_on_time {
    description: "The count of distinct charts by clinical encounter that were signed by the provider within 24 hours of the visit"
    type: count_distinct
    sql: ${clinical_encounter_id} ;;
    filters: {
      field: chart_signed_on_time
      value: "yes"
    }
  }

  measure: count_charts_by_clinical_encounter_signed_48_hours {
    description: "The count of distinct charts by clinical encounter that were signed by the provider within 48 hours of the visit"
    type: count_distinct
    sql: ${clinical_encounter_id} ;;
    filters: {
      field: chart_signed_48_hours
      value: "yes"
    }
  }


}
