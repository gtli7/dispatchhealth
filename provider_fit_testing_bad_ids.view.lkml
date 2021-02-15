view: provider_fit_testing_bad_ids {
  sql_table_name: looker_scratch.provider_fit_testing_bad_ids ;;

  dimension: approval_status {
    type: string
    sql: ${TABLE}."approval_status" ;;
  }

  dimension: date_approved {
    type: date
    sql: ${TABLE}."date_approved" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension: mask_type {
    type: string
    sql: ${TABLE}."mask_type" ;;
  }

  dimension: id {
    type: number
    hidden: yes
    sql: ${TABLE}."id" ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}."user_id" ;;
  }

  measure: count {
    type: count
    drill_fields: [first_name, last_name]
  }
}
