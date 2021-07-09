view: on_call_tracking {
  sql_table_name: looker_scratch.on_call_tracking ;;

  dimension_group: date {
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
    sql: ${TABLE}."date" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: on_call_status {
    type: string
    sql: ${TABLE}."on_call_status" ;;
  }

  dimension: on_call_active {
    type: yesno
    sql: lower(${on_call_status}::text) like '%yes%';;
  }

  dimension: on_call_diff {
    type: number
    sql:${intraday_monitoring_after.total_hours} - ${intraday_monitoring_prior.total_hours} ;;
  }

  dimension: on_call_diff_positive {
    type: yesno
    sql: ${on_call_diff}>0  ;;
  }

  dimension: on_call_diff_greater_than_6{
    type: yesno
    sql: ${on_call_diff}>5  ;;
  }


  measure: count_on_call_active_attempt{
    type: count_distinct

    sql_distinct_key: concat(${date_date}, ${market_id}) ;;
    sql: concat(${date_date}, ${market_id}) ;;
    filters: {
      field: on_call_active
      value: "yes"
    }
  }

  measure: count_on_call_active_success{
    type: count_distinct

    sql_distinct_key: concat(${date_date}, ${market_id}) ;;
    sql: concat(${date_date}, ${market_id}) ;;
    filters: {
      field: on_call_active
      value: "yes"
    }
    filters: {
      field: on_call_diff_greater_than_6
      value: "yes"
    }
  }


  measure: sum_on_call_diff{
    type: sum_distinct
    sql_distinct_key: concat(${date_date}, ${market_id}) ;;
    sql: ${on_call_diff} ;;
    filters: {
      field: on_call_diff_positive
      value: "yes"
    }
    filters: {
      field: on_call_active
      value: "yes"
    }
  }


  measure: sum_hours_prior {
    type: sum_distinct
    sql_distinct_key: concat(${date_date}, ${market_id}) ;;
    sql: ${intraday_monitoring_prior.total_hours} ;;
    filters: [on_call_active: "yes",
      intraday_monitoring_prior.created_hour_timezone: "10"
      ]
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
