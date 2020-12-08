view: athenadwh_patient_insurances_clone {
  sql_table_name: looker_scratch.athenadwh_patient_insurances_clone ;;

  view_label: "ZZZZ - Athenadwh Patient Insurances Clone"

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

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: insurance_package_id {
    type: string
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
