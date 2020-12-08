view: athena_transaction {
  sql_table_name: athena.transaction ;;
  drill_fields: [transaction_id]
  view_label: "Athena Transactions (DO NOT USE - Use Transaction Summary)"

  dimension: transaction_id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."transaction_id" ;;
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

  dimension: amount {
    type: number
    description: "The dollar amount of the transaction.  Negative numbers represent payments, positive represent charges"
    sql: ${TABLE}."amount" ;;
  }

  dimension_group: charge_from {
    type: time
    hidden: yes
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
    sql: ${TABLE}."charge_from_date" ;;
  }

  dimension: charge_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."charge_id" ;;
  }

  dimension_group: charge_to {
    type: time
    hidden: yes
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
    sql: ${TABLE}."charge_to_date" ;;
  }

  dimension: charge_void_parent_id {
    type: number
    hidden: yes
    sql: ${TABLE}."charge_void_parent_id" ;;
  }

  dimension: claim_id {
    type: number
    group_label: "IDs"
    # hidden: yes

    sql: ${TABLE}."claim_id" ;;
  }

  dimension_group: closed_post {
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
    sql: ${TABLE}."closed_post_date" ;;
  }

  dimension_group: created_at {
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

  dimension: custom_transaction_code {
    type: string
    hidden: yes
    sql: ${TABLE}."custom_transaction_code" ;;
  }

  dimension: emgyn {
    type: string
    hidden: yes
    sql: ${TABLE}."emgyn" ;;
  }

  dimension: expected_allowable_schedule_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."expected_allowable_schedule_id" ;;
  }

  dimension: expected_allowed_amount {
    type: number
    description: "The dollar amount of the expected allowable from the exp. allowable schedule"
    sql: ${TABLE}."expected_allowed_amount" ;;
  }

  dimension_group: first_billed {
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
    sql: ${TABLE}."first_billed_datetime" ;;
  }

  dimension: id {
    type: number
    hidden: yes
    sql: ${TABLE}."id" ;;
  }

  dimension_group: last_billed {
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
    sql: ${TABLE}."last_billed_datetime" ;;
  }

  dimension: malpractice_rvu {
    type: number
    group_label: "RVUs"
    sql: ${TABLE}."malpractice_rvu" ;;
  }

  dimension: number_of_charges {
    type: number
    hidden: yes
    sql: ${TABLE}."number_of_charges" ;;
  }

  dimension: orig_posted_payment_batch_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."orig_posted_payment_batch_id" ;;
  }

  dimension: other_modifier {
    type: string
    description: "Any non-fee-affecting modifiers for the procedurecode, separated by commas."
    sql: ${TABLE}."other_modifier" ;;
  }

  dimension: parent_charge_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."parent_charge_id" ;;
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

  dimension: patient_payment_id {
    type: number
    hidden: yes
    sql: ${TABLE}."patient_payment_id" ;;
  }

  dimension: payment_batch_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."payment_batch_id" ;;
  }

  dimension: place_of_service {
    type: string
    hidden: yes
    sql: ${TABLE}."place_of_service" ;;
  }

  dimension_group: post {
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
    sql: ${TABLE}."post_date" ;;
  }

  dimension: practice_expense_rvu {
    type: number
    group_label: "RVUs"
    sql: ${TABLE}."practice_expense_rvu" ;;
  }

  dimension: procedure_code {
    type: string
    description: "The CPT code on the charge. This includes the full procedurecode, followed by any fee-affecting modifiers."
    sql: ${TABLE}."procedure_code" ;;
  }

  dimension: reversal_flag {
    type: yesno
    sql: ${TABLE}."reversal_flag" ;;
  }

  dimension: total_rvu {
    type: number
    group_label: "RVUs"
    sql: ${TABLE}."total_rvu" ;;
  }

  measure: sum_total_rvu {
    description: "Sum Total RVU's"
    type: sum
    group_label: "RVU Measures"
    sql: ${total_rvu} ;;
    value_format: "0.0"
    filters: [is_valid_claim: "yes"]
  }

  measure: sum_work_rvu {
    description: "Sum Work RVU's"
    type: sum
    group_label: "RVU Measures"
    sql: ${work_rvu} ;;
    value_format: "0.0"
    filters: [is_valid_claim: "yes"]
  }

  measure: average_total_rvu {
    type: number
    description: "Average total RVU's"
    group_label: "RVU Measures"
    sql: ${sum_total_rvu} / ${count_claims} ;;
    value_format: "0.00"
  }

  measure: average_work_rvu {
    type: number
    description: "Average work RVU's"
    group_label: "RVU Measures"
    sql: CASE WHEN ${count_claims} > 0 THEN ${sum_work_rvu} / ${count_claims}
         ELSE NULL END ;;
    value_format: "0.00"
  }

  dimension: is_valid_claim {
    description: "Claim ID is not null and expected allowed amount is greater than 0.01"
    type: yesno
    hidden: yes
    sql:
         ${athena_valid_claims.claim_id} IS NOT NULL AND
         ${athena_appointment.no_charge_entry_reason} IS NULL AND
         ${expected_allowed_amount}::float > 0.01 ;;
  }

  dimension: is_zero_exp_allow_claim {
    description: "Claim ID is not null and expected allowed amount is $0.00"
    type: yesno
    sql: ${voided_date} IS NULL AND
      ${expected_allowed_amount}::float = 0.0 ;;
  }

  measure: count_valid_transactions {
    type: count_distinct
    sql: ${transaction_id} ;;
    filters: [voided_date: "NULL"]
  }

  measure: count_claims {
    type: count_distinct
    description: "Count of claims where expected allowable > $0.01,
                  no charge entry reason is null and < 100% of claims have been voided"
    sql: ${claim_id} ;;
    filters: {
      field: is_valid_claim
      value: "yes"
    }
  }

  dimension_group: transaction_created {
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
    sql: ${TABLE}."transaction_created_datetime" ;;
  }

  dimension: transaction_method {
    type: string
    group_label: "Transaction Details"
    group_item_label: "Method"
    sql: ${TABLE}."transaction_method" ;;
  }

  dimension: transaction_patient_ins_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."transaction_patient_ins_id" ;;
  }

  dimension: transaction_posted_by {
    type: string
    group_label: "Transaction Details"
    group_item_label: "Posted By"
    sql: ${TABLE}."transaction_posted_by" ;;
  }

  dimension: transaction_reason {
    type: string
    group_label: "Transaction Details"
    group_item_label: "Reason"
    description: "The reason for the transaction e.g. CONTRACTUAL, COPAY, COINSURANCE, etc."
    sql: ${TABLE}."transaction_reason" ;;
  }

  dimension: transaction_transfer_intent {
    type: string
    hidden: yes
    sql: ${TABLE}."transaction_transfer_intent" ;;
  }

  dimension: transaction_transfer_type {
    type: string
    group_label: "Transaction Details"
    group_item_label: "Transfer Type"
    description: "Patient, Primary or Secondary"
    sql: ${TABLE}."transaction_transfer_type" ;;
  }

  dimension: transaction_type {
    type: string
    group_label: "Transaction Details"
    group_item_label: "Type"
    description: "PAYMENT, TRANSFERIN, TRANSFEROUT, ADJUSTMENT, CHARGE, etc."
    sql: ${TABLE}."transaction_type" ;;
  }

  dimension: units {
    type: number
    hidden: yes
    sql: ${TABLE}."units" ;;
  }

  dimension_group: updated_at {
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

  dimension: void_payment_batch_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."void_payment_batch_id" ;;
  }

  dimension_group: voided {
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
    sql: ${TABLE}."voided_date" ;;
  }

  dimension: work_rvu {
    type: number
    description: "The Work RVU value for the procedure code adjusted for the number of charges and units. Not adjusted for GPCI location."
    group_label: "RVUs"
    sql: ${TABLE}."work_rvu" ;;
  }

  dimension: is_valid_exp_allowable {
    type: yesno
    hidden: yes
    sql: ${transaction_type} = 'CHARGE' AND (
          (${transaction_transfer_type} = 'Primary')
          OR (${transaction_transfer_type} != 'Primary' AND ${insurance_coalese_crosswalk.insurance_package_id}::int IN (0,-100)));;
  }

  dimension: fixed_expected_allowable {
    description: "Expected allowable where charge reversals are dealt with effectively"
    type: number
    hidden: yes
    sql: CASE
          WHEN ${reversal_flag} THEN ${expected_allowed_amount}::float * -1
          ELSE ${expected_allowed_amount}::float
        END ;;
  }

  dimension: voided_date_is_null {
    description: "A flag indicating that the voided date is null."
    type: yesno
    hidden: yes
    sql: ${voided_date} IS NULL ;;
  }

  measure: total_expected_allowable {
    type: sum_distinct
    alias: [total_expected_allowable]
    description: "Transaction type is CHARGE and transfer type is PRIMARY or patient is self-pay"
    sql: ${fixed_expected_allowable}::float ;;
    sql_distinct_key: ${transaction_id} ;;
    value_format: "$#,##0.00"
    filters: [is_valid_exp_allowable: "yes", is_valid_claim: "yes", voided_date_is_null: "yes"]
  }

  measure: count {
    type: count
    drill_fields: [transaction_id, claim.original_claim_id]
  }
}
