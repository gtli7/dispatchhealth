view: athenadwh_patientinsurance_clone {
  sql_table_name: looker_scratch.athenadwh_patientinsurance_clone ;;
  view_label: "ZZZZ - Athenadwh Patient Insurance Clone"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: cancellation_date {
    type: string
    sql: ${TABLE}.cancellation_date ;;
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

  dimension: expiration_date {
    type: string
    sql: ${TABLE}.expiration_date ;;
  }

  dimension: insurance_package_id {
    type: number
    sql: ${TABLE}.insurance_package_id ;;
  }

  dimension: issue_date {
    type: string
    sql: ${TABLE}.issue_date ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: patient_insurance_id {
    type: number
    sql: ${TABLE}.patient_insurance_id ;;
  }

  dimension: patient_relationship {
    type: string
    sql: ${TABLE}.patient_relationship ;;
  }

  dimension: policy_group_number {
    type: string
    sql: ${TABLE}.policy_group_number ;;
  }

  dimension: policy_id_number {
    type: string
    sql: ${TABLE}.policy_id_number ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
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
