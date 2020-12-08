view: athenadwh_claims_clone {
  sql_table_name: looker_scratch.athenadwh_claims_clone ;;
  view_label: "ZZZZ - Athenadwh Claims Clone"

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: claim_appointment_id {
    type: number
    hidden: yes
    sql: ${TABLE}.claim_appointment_id ;;
  }

  dimension_group: claim_created_datetime {
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
    sql: ${TABLE}.claim_created_datetime ;;
  }

  dimension: claim_id {
    type: number
    sql: ${TABLE}.claim_id ;;
  }

  dimension: claim_primary_patient_ins_id {
    type: number
    hidden: yes
    sql: ${TABLE}.claim_primary_patient_ins_id ;;
  }

  dimension: claim_secondary_patient_ins_id {
    type: number
    hidden: yes
    sql: ${TABLE}.claim_secondary_patient_ins_id ;;
  }

  dimension: claim_service_date {
    type: date
    sql: ${TABLE}.claim_service_date::date ;;
  }

  dimension_group: service {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: ${TABLE}.claim_service_date::date ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: feed_dates {
    type: string
    hidden: yes
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: patient_claim_status {
    type: string
    sql: ${TABLE}.patient_claim_status ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: primary_claim_status {
    type: string
    sql: ${TABLE}.primary_claim_status ;;
  }

  dimension: secondary_claim_status {
    type: string
    sql: ${TABLE}.secondary_claim_status ;;
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
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
