view: patient_satisfaction {
  sql_table_name: surveys.patient_satisfaction ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension_group: __file {
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
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    hidden: yes
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: alternative_dh_response {
    type: string
    sql: ${TABLE}."alternative_dh_response" ;;
  }

  dimension: care_request_id {
    type: number
    hidden: yes
    sql: ${TABLE}."care_request_id" ;;
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

  dimension: nps_response {
    type: number
    sql: ${TABLE}."nps_response" ;;
  }

  dimension: nps_response_rate {
    type: number
    hidden: yes
    sql: CASE WHEN ${nps_response} > 0 THEN 100 ELSE 0 END ;;
  }

  measure: nps_survey_response_rate {
    type: average_distinct
    description: "The NPS survey response rate for all completed visits"
    value_format: "0.0\%"
    group_label: "NPS Metrics"
    sql: ${nps_response_rate} ;;
    sql_distinct_key: ${care_requests.id} ;;
    filters: [care_requests.billable_est: "yes"]
  }

  measure: count_distinct_promoters {
    description: "NPS survey response is 9 or 10"
    group_label: "NPS Metrics"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: [nps_response: ">8"]
  }

  measure: count_distinct_detractors {
    description: "NPS survey response is 6 or less"
    group_label: "NPS Metrics"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: [nps_response: "<7"]
  }

  measure: count_distinct_respondents {
    description: "Count of distinct NPS survey respondents"
    group_label: "NPS Metrics"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: [nps_response: ">0"]
  }

  dimension: net_promoter_score {
    type: number
    hidden: yes
    sql: CASE WHEN ${nps_response}>8 THEN 100
          WHEN ${nps_response} < 7 THEN -100
          ELSE 0 END ;;
  }

  measure: average_net_promoter_score {
    type: average_distinct
    description: "Promoters minus detractors divided by respondents * 100"
    group_label: "NPS Metrics"
    sql: ${net_promoter_score} ;;
    sql_distinct_key: ${care_request_id} ;;
    value_format: "0"
  }

  dimension: overall_rating_response {
    type: string
    sql: ${TABLE}."overall_rating_response" ;;
  }

  dimension_group: survey_created {
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
    sql: ${TABLE}."survey_created" ;;
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

}
