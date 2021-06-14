view: insurance_plan_service_lines {
  sql_table_name: public.insurance_plan_service_lines ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: all_channel_items {
    type: yesno
    sql: ${TABLE}."all_channel_items" ;;
  }

  dimension: capture_cc_on_scene {
    type: yesno
    sql: ${TABLE}."capture_cc_on_scene" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: enabled {
    type: yesno
    sql: ${TABLE}."enabled" ;;
  }

  dimension: existing_patient_appointment_type {
    type: string
    sql: ${TABLE}."existing_patient_appointment_type" ;;
  }

  dimension: insurance_plan_id {
    type: number
    sql: ${TABLE}."insurance_plan_id" ;;
  }

  dimension: new_patient_appointment_type {
    type: string
    sql: ${TABLE}."new_patient_appointment_type" ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}."note" ;;
  }

  dimension: schedule_future {
    type: yesno
    sql: ${TABLE}."schedule_future" ;;
  }

  dimension: schedule_now {
    type: yesno
    sql: ${TABLE}."schedule_now" ;;
  }

  dimension: service_line_id {
    type: number
    sql: ${TABLE}."service_line_id" ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
