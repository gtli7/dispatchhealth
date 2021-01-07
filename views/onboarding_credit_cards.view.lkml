view: onboarding_credit_cards {
  sql_table_name: public.onboarding_credit_cards ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."id" ;;
  }

  dimension: card_type {
    type: string
    hidden: yes
    sql: ${TABLE}."card_type" ;;
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

  dimension_group: deleted {
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
    sql: ${TABLE}."deleted_at" ;;
  }

  dimension_group: expiration {
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
    sql: ${TABLE}."expiration" ;;
  }

  dimension: last_four {
    type: string
    hidden: yes
    sql: ${TABLE}."last_four" ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: payment_plan_id {
    type: string
    hidden: yes
    sql: ${TABLE}."payment_plan_id" ;;
  }

  dimension: save_for_future_use {
    type: yesno
    sql: ${TABLE}."save_for_future_use" ;;
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

  measure: count_visits_with_credit_cards {
    type: count_distinct
    description: "Count of distinct care requests where a credit card was captured onboarding"
    sql: ${onboarding_care_request_credit_cards.care_request_id} ;;
  }

  measure: count_visits_with_credit_cards_complete {
    type: count_distinct
    description: "Count of complete care requests where a credit card was captured onboarding"
    sql: ${onboarding_care_request_credit_cards.care_request_id} ;;
    sql_distinct_key: ${onboarding_care_request_credit_cards.care_request_id};;
    filters: {
      field: care_request_flat.complete
      value: "yes"
    }
  }

  measure: percent_credit_card_captured_complete {
    type: number
    description: "Percent of complete care requests where a credit card was captured onboarding"
    sql: case when ${care_request_flat.complete_count}>0 then ${count_visits_with_credit_cards_complete}::float/${care_request_flat.complete_count}::float else 0 end;;
  }
}
