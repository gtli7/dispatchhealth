view: athenadwh_transactions {
  sql_table_name: jasperdb.athenadwh_transactions ;;
  view_label: "ZZZZ - Athenadwh Transactions"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: payment_amount {
    type: number
    sql: ${amount} * -1 ;;
  }

  measure: total_amount {
    type: sum
    sql: ${amount} ;;
    value_format: "0.00"
    filters: {
      field: voided_flag
      value: "no"
    }
  }

  dimension: patient_payment {
    type: yesno
    sql: ${transaction_transfer_type} = 'Patient' AND ${transaction_type} = 'PAYMENT' ;;
  }

  dimension: patient_responsibility {
    type: yesno
    sql: ${transaction_transfer_type} = 'Patient' AND ${transaction_type} = 'TRANSFERIN' ;;
  }

  dimension: patient_responsibility_without_secondary {
    description: "Patient responsibility when not taking secondary payers into account"
    type: yesno
    sql: ${patient_responsibility} OR
        (${transaction_transfer_type} = 'Secondary' AND ${transaction_type} = 'TRANSFERIN') OR
        (${transaction_transfer_type} = 'Secondary' AND ${transaction_type} = 'TRANSFEROUT') ;;
  }

  measure: total_oop_paid {
    type: sum
    sql: ${payment_amount} ;;
    value_format: "0.00"
    filters: {
      field: patient_payment
      value: "yes"
    }
  }

  measure: total_patient_responsibility {
    type: sum
    sql: ${amount} ;;
    value_format: "0.00"
    filters: {
      field: patient_responsibility
      value: "yes"
    }
  }

  measure: total_patient_responsibility_without_secondary {
    type: sum
    sql: ${amount} ;;
    value_format: "0.00"
    filters: {
      field: patient_responsibility_without_secondary
      value: "yes"
    }
  }

  dimension: charge_id {
    type: number
    sql: ${TABLE}.charge_id ;;
  }

  dimension: claim_id {
    type: number
    sql: ${TABLE}.claim_id ;;
  }

  measure: count_claims {
    type: count_distinct
    sql: ${claim_id} ;;
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

  dimension: expected_allowable_schedule_id {
    type: number
    sql: ${TABLE}.expected_allowable_schedule_id ;;
  }

  dimension: expected_allowed_amount {
    type: number
    sql: ${TABLE}.expected_allowed_amount ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension_group: first_billed_datetime {
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
    sql: ${TABLE}.first_billed_datetime ;;
  }

  dimension_group: last_billed_datetime {
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
    sql: ${TABLE}.last_billed_datetime ;;
  }

  dimension: other_modifier {
    type: string
    sql: ${TABLE}.other_modifier ;;
  }

  dimension: post_date {
    type: string
    sql: ${TABLE}.post_date ;;
  }

  dimension: procedure_code {
    type: string
    sql: ${TABLE}.procedure_code ;;
  }

  dimension: reversal_flag {
    type: number
    sql: ${TABLE}.reversal_flag ;;
  }

  dimension: voided_flag {
    type: yesno
    sql: ${voided_date} IS NOT NULL ;;
  }

  dimension: total_rvu {
    type: string
    sql: ${TABLE}.total_rvu ;;
  }

  dimension_group: transaction_created_datetime {
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
    sql: ${TABLE}.transaction_created_datetime ;;
  }

  dimension: transaction_id {
    type: number
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: transaction_reason {
    type: string
    sql: ${TABLE}.transaction_reason ;;
  }

  dimension: transaction_transfer_intent {
    type: string
    sql: ${TABLE}.transaction_transfer_intent ;;
  }

  dimension: transaction_transfer_type {
    type: string
    sql: ${TABLE}.transaction_transfer_type ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}.transaction_type ;;
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

  dimension: voided_date {
    type: string
    sql: ${TABLE}.voided_date ;;
  }

  dimension: work_rvu {
    type: string
    sql: ${TABLE}.work_rvu ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
