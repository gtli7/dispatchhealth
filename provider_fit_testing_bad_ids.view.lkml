view: provider_fit_testing_bad_ids {
  sql_table_name: looker_scratch.provider_fit_testing_bad_ids ;;

  dimension: approval_status {
    type: string
    sql: ${TABLE}."approval_status" ;;
  }

  dimension: date_approved {
    type: string
    sql: ${TABLE}."date_approved" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension_group: fit_test {
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
    sql: ${TABLE}."fit_test_date" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension: mask_type {
    type: string
    sql: ${TABLE}."mask_type" ;;
  }

  dimension: odata_etag {
    type: string
    hidden: yes
    sql: ${TABLE}."@odata.etag" ;;
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
