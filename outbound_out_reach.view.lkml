view: outbound_out_reach {
# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"
      derived_table: {
        sql_trigger_value: select sum(num) from
        (SELECT count(*) as num FROM looker_scratch.genesys_conversation_summary  where genesys_conversation_summary.conversationstarttime > current_date - interval '2 day'
        UNION ALL
        SELECT MAX(care_request_id) as num FROM ${care_request_flat.SQL_TABLE_NAME} where created_date > current_date - interval '2 days')lq
        ;;
      explore_source: care_requests {
        column: created { field: care_request_flat.created_raw }
        column: care_request_id { field: care_request_flat.care_request_id }
        column: request_type { }
        column: caller_id {field:callers.id}
        column: resolved_no_answer_no_show {field: care_request_flat.resolved_no_answer_no_show}
        column: complete {field: care_request_flat.complete}
        column: accepted_scheduled_or_booked {field: care_request_flat.accepted_or_scheduled_count}
        column: accepted {field: care_request_flat.accepted}
        column: created_to_accepted_minutes {field: care_request_flat.created_to_accepted_minutes}
        column: time_call_to_creation_minutes {field:care_request_flat.time_call_to_creation_minutes}

        column: min_diff_to_outbound_call_minutes { field: care_request_flat.min_diff_to_outbound_call_minutes }
        column: max_diff_to_outbound_call_minutes { field: care_request_flat.max_diff_to_outbound_call_minutes }
        column: count_distinct_outbound_calls { field: care_request_flat.count_distinct_outbound_calls }
        filters: {
          field: care_request_flat.created_date
          value: "365 days ago for 365 days"
        }
        filters: {
          field: care_requests.request_type
          value: "web,mobile,mobile_android,dispatchhealth express"
        }
      }
    }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      time_of_day,
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      week,
      month,
      quarter,
      year, day_of_month
    ]
  }
  dimension: time_call_to_creation_minutes {
    type: number

  }

  dimension: complete {
    type: yesno

  }


  dimension: accepted_scheduled_or_booked {
    type: number

  }

  dimension: accepted {
    type: yesno

  }
  dimension: resolved_no_answer_no_show {
    type: yesno
  }
  dimension: caller_id {
    type: number
  }
  dimension: caller_present {
    type: yesno
    sql: ${caller_id} is not null ;;
  }
    dimension: care_request_id {
      type: number
    }
  dimension: request_type {
    type: string
  }
    dimension: min_diff_to_outbound_call_minutes {
      value_format: "0.0"
      type: number
    }
    dimension: max_diff_to_outbound_call_minutes {
      value_format: "0.0"
      type: number
    }
    dimension: created_to_accepted_minutes {
      type: number
    }
    dimension: count_distinct_outbound_calls {
      type: number
    }
    dimension: outbound_call_occured {
      type: yesno
      sql: ${count_distinct_outbound_calls}!=0 ;;
    }
  dimension: reasonable_call_creation_time {
    type: yesno
    sql: ${time_call_to_creation_minutes} < 120   ;;
  }
  dimension: min_diff_to_outbound_call_minutes_bands {
    type: number
    sql: ROUND(${min_diff_to_outbound_call_minutes}/1) * 1 ;;
  }

  dimension: min_diff_to_outbound_call_minutes_bands_complex {
    type: string
    sql: case
              when ${min_diff_to_outbound_call_minutes} < 1 then '<1 minute'
              when ${min_diff_to_outbound_call_minutes} < 2 then '<2 minutes'
              when ${min_diff_to_outbound_call_minutes} < 4 then '<4 minutes'
              when ${min_diff_to_outbound_call_minutes} < 8 then '<8 minutes'
              when ${min_diff_to_outbound_call_minutes} < 16 then '<16 minutes'
              when ${min_diff_to_outbound_call_minutes} < 32 then '<32 minutes'
              when ${min_diff_to_outbound_call_minutes} < 64 then '<64 minutes'
              when ${min_diff_to_outbound_call_minutes} >= 64 then '>=64 minutes'
              else null end;;

}


    measure: median_min_diff_to_outbound_call_minutes {
      value_format: "0.0"
      type: median_distinct
      sql: ${min_diff_to_outbound_call_minutes} ;;
      sql_distinct_key: ${care_request_id} ;;
      filters: [outbound_call_occured: "yes"]
    }

  measure: median_created_to_accepted_minutes {
    value_format: "0.0"
    type: median_distinct
    sql: ${created_to_accepted_minutes} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: [accepted: "yes"]
  }
  measure: avg_min_diff_to_outbound_call_minutes {
    value_format: "0.0"
    type: average_distinct
    sql: ${min_diff_to_outbound_call_minutes} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: [outbound_call_occured: "yes"]

  }

  measure: median_max_diff_to_outbound_call_minutes {
    value_format: "0.0"
    type: median_distinct
    sql: ${max_diff_to_outbound_call_minutes} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: [outbound_call_occured: "yes"]

  }
  measure: avg_max_diff_to_outbound_call_minutes {
    value_format: "0.0"
    type: average_distinct
    sql: ${max_diff_to_outbound_call_minutes} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: [outbound_call_occured: "yes"]

  }

  measure: median_count_distinct_outbound_calls {
    value_format: "0.0"
    type: median_distinct
    sql: ${count_distinct_outbound_calls} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: [outbound_call_occured: "yes"]

  }
  measure: avg_count_distinct_outbound_calls {
    value_format: "0.0"
    type: average_distinct
    sql: ${count_distinct_outbound_calls} ;;
    sql_distinct_key: ${care_request_id} ;;
  }

  measure: count_distinct_care_requests {
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
  }

  measure: count_distinct_care_requests_w_outbound {
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: [outbound_call_occured: "yes"]

  }
  measure: percent_with_outbound {
    type: number
    value_format: "0%"
    sql: case when ${count_distinct_care_requests}>0 then ${count_distinct_care_requests_w_outbound}::float/${count_distinct_care_requests} else 0 end ;;
  }

  measure: count_distinct_care_requests_w_caller {
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: [caller_present: "yes"]

  }
  measure: percent_with_caller {
    type: number
    value_format: "0%"
    sql: case when ${count_distinct_care_requests}>0 then ${count_distinct_care_requests_w_caller}::float/${count_distinct_care_requests} else 0 end ;;
  }

  measure: count_resolved_no_answer_no_show {
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: [resolved_no_answer_no_show: "yes"]

  }

  measure: count_accepted {
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: [accepted: "yes"]
  }

  measure: count_complete {
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: [complete: "yes"]
  }

  measure: count_accepted_scheduled_or_booked {
    type: sum_distinct
    sql: ${accepted_scheduled_or_booked} ;;
    sql_distinct_key: ${care_request_id} ;;
  }
  measure: percent_resolved_no_answer_no_show {
    type: number
    value_format: "0%"
    sql: case when ${count_distinct_care_requests}>0 then ${count_resolved_no_answer_no_show}::float/${count_distinct_care_requests} else 0 end ;;
  }

  measure: percent_converted {
    type: number
    value_format: "0%"
    sql: case when ${count_distinct_care_requests}>0 then ${count_complete}::float/${count_distinct_care_requests} else 0 end ;;
  }

  measure: percent_captured {
    type: number
    value_format: "0%"
    sql: case when ${count_distinct_care_requests}>0 then ${count_accepted_scheduled_or_booked}::float/${count_distinct_care_requests} else 0 end ;;
  }

  measure: percent_assigned {
    type: number
    value_format: "0%"
    sql: case when ${count_distinct_care_requests}>0 then ${count_accepted}::float/${count_distinct_care_requests} else 0 end ;;
  }
  measure: median_time_call_to_creation_minutes {
    label: "Median Time to Caller Creation"
    value_format: "0.0"
    type: median_distinct
    sql: ${time_call_to_creation_minutes} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: [caller_present: "yes"]

  }
  measure: avg_time_call_to_creation_minutes {
    label: "Average Time to Caller Creation"
    value_format: "0.0"
    type: average_distinct
    sql: ${time_call_to_creation_minutes} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: [caller_present: "yes"]




}

  }
