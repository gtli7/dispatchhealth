view: athena_claim {
  # sql_table_name: athena.claim ;;
  # drill_fields: [original_claim_id]
  derived_table: {
    sql:
    SELECT
    c1.*
    FROM athena.claim c1
    INNER JOIN (
        SELECT
            claim_appointment_id,
            MAX(claim_id) AS claim_id
            FROM athena.claim
            WHERE claim_appointment_id IS NOT NULL
            GROUP BY 1) AS c2
        ON c1.claim_id = c2.claim_id;;
  sql_trigger_value: SELECT MAX(claim_id) FROM athena.claim ;;
  indexes: ["claim_appointment_id", "claim_id"]
  }
  view_label: "Athena Claims"

  dimension: id {
    type: number
    hidden: yes
    primary_key: yes
    sql: ${TABLE}."id" ;;
  }

  dimension: original_claim_id {
    primary_key: no
    hidden: yes
    type: number
    sql: ${TABLE}."original_claim_id" ;;
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

  dimension: claim_appointment_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."claim_appointment_id" ;;
  }

  dimension_group: claim_created {
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
    sql: ${TABLE}."claim_created_datetime" ;;
  }

  dimension: claim_id {
    type: number
    # hidden: yes
    group_label: "IDs"
    sql: ${TABLE}."claim_id" ;;
  }

  dimension: is_valid_claim {
    description: "Claim ID is not null and no charge entry reason is null"
    type: yesno
    hidden: yes
    sql:
         ${athena_valid_claims.claim_id} IS NOT NULL AND
         ${athena_appointment.no_charge_entry_reason} IS NULL ;;
  }

  measure: count_distinct_claims {
    description: "Count of distinct claims"
    group_label: "Counts"
    type: count_distinct
    sql: ${claim_id} ;;
    filters: [is_valid_claim: "yes"]
  }

  dimension: claim_primary_patient_ins_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."claim_primary_patient_ins_id" ;;
  }

  dimension: claim_referral_auth_id {
    type: number
    group_label: "IDs"
    hidden: yes
    sql: ${TABLE}."claim_referral_auth_id" ;;
  }

  dimension: claim_referring_provider_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."claim_referring_provider_id" ;;
  }

  dimension: claim_scheduling_provider_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."claim_scheduling_provider_id" ;;
  }

  dimension: claim_secondary_patient_ins_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."claim_secondary_patient_ins_id" ;;
  }

  dimension_group: claim_service {
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
    sql: ${TABLE}."claim_service_date" ;;
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
    sql: ${TABLE}."created_by" ;;
  }

  dimension_group: hospitalization_from {
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
    sql: ${TABLE}."hospitalization_from_date" ;;
  }

  dimension_group: hospitalization_to {
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
    sql: ${TABLE}."hospitalization_to_date" ;;
  }

  dimension: patient_char {
    type: string
    hidden: yes
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_claim_status {
    type: string
    sql: ${TABLE}."patient_claim_status" ;;
  }

  dimension: patient_department_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."patient_department_id" ;;
  }

  dimension: patient_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: patient_rounding_list_id {
    type: number
    hidden: yes
    sql: ${TABLE}."patient_rounding_list_id" ;;
  }

  dimension: primary_claim_status {
    type: string
    group_label: "Claim Status"
    sql: ${TABLE}."primary_claim_status" ;;
  }

  dimension: rendering_provider_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."rendering_provider_id" ;;
  }

  dimension: reserved19 {
    type: string
    label: "Claim Note"
    sql: ${TABLE}."reserved19" ;;
  }

  dimension: secondary_claim_status {
    type: string
    group_label: "Claim Status"
    sql: ${TABLE}."secondary_claim_status" ;;
  }

  dimension: service_department_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."service_department_id" ;;
  }

  dimension: supervising_provider_id {
    type: number
    group_label: "IDs"
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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      original_claim_id,
      claim.original_claim_id,
      appointment.count,
      claim.count,
      clinicalencounter.count,
      transaction.count
    ]
  }
}
