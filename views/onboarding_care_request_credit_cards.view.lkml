view: onboarding_care_request_credit_cards {
  sql_table_name: public.onboarding_care_request_credit_cards ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
  }

  dimension: credit_card_id {
    type: number
    sql: ${TABLE}."credit_card_id" ;;
  }


}
