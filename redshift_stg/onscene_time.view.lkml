view: onscene_time {
  sql_table_name: stg_care_request_timeline.crt_crstat_is_onscene ;;

  dimension: care_request_id {
    type: number
    value_format: "0"
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: care_request_statuses_id {
    type: number
    hidden: yes
    sql: ${TABLE}.care_request_statuses_id ;;
  }

  dimension_group: started {
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
    sql: ${TABLE}.started_at ;;
  }

  measure: count {
    type: count
    sql: ${care_request_id} ;;
  }

  measure: count_onscene {
    type: count_distinct
    sql_distinct_key: ${care_request_id} ;;
  }
}
