view: athenadwh_appointments_clone {
  sql_table_name: looker_scratch.athenadwh_appointments_clone ;;
  view_label: "ZZZZ - Athenadwh Appointments Clone"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: appointment_created_datetime {
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
    sql: ${TABLE}.appointment_created_datetime ;;
  }

  dimension: appointment_id {
    type: number
    sql: ${TABLE}.appointment_id ;;
  }

  dimension: appointment_status {
    type: string
    sql: ${TABLE}.appointment_status ;;
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

  dimension: department_id {
    type: number
    sql: ${TABLE}.department_id ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: no_charge_entry_reason {
    type: string
    sql: ${TABLE}.no_charge_entry_reason ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: primary_patient_insurance_id {
    type: number
    sql: ${TABLE}.primary_patient_insurance_id ;;
  }

  dimension: secondary_patient_insurance_id {
    type: number
    sql: ${TABLE}.secondary_patient_insurance_id ;;
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
