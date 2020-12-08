view: athenadwh_patients {
  sql_table_name: jasperdb.athenadwh_patients ;;
  view_label: "ZZZZ - Athenadwh Patients"

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

  dimension: dob {
    type: string
    sql: ${TABLE}.dob ;;
  }

  dimension: employer_id {
    type: number
    sql: ${TABLE}.employer_id ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: new_patient_id {
    type: number
    sql: ${TABLE}.new_patient_id ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: patient_ssn {
    type: string
    sql: ${TABLE}.patient_ssn ;;
  }

  dimension: patient_status {
    type: string
    sql: ${TABLE}.patient_status ;;
  }

  dimension: sex {
    type: string
    sql: ${TABLE}.sex ;;
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
    drill_fields: [id, last_name, first_name]
  }
}
