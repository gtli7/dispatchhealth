view: genesys_queue_conversion {

# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"
    derived_table: {
      sql_trigger_value: SELECT count(*) FROM looker_scratch.genesys_conversation_summary  where genesys_conversation_summary.conversationstarttime > current_date - interval '2 day';;
      indexes: ["conversationstarttime", "queuename", "market_id"]
      explore_source: genesys_conversation_summary {
        column: conversationstarttime {field: genesys_conversation_summary.conversationstarttime_date}
        column: queuename {}
        column: market_id {field:markets.id}

        column: wait_time_minutes {field: genesys_conversation_summary.average_wait_time_minutes}
        column: inbound_phone_calls {field: genesys_conversation_summary.count_distinct}
        column: count_answered {}
        column: care_request_count { field: care_request_flat_number.care_request_count }
        column: accepted_count { field: care_request_flat_number.accepted_count }
        column: complete_count { field: care_request_flat_number.complete_count }
        filters: {
          field: genesys_conversation_summary.conversationstarttime_time
          value: "120 days ago for 120 days"
        }
        filters: {
          field: genesys_conversation_summary.queuename
          value: "General Care,DTC,Partner Direct,DTC Pilot"
        }
        filters: {
          field: markets.id
          value: "NOT NULL"
        }

      }
    }

    dimension: queuename {}

    dimension: market_id {}

    dimension: inbound_phone_calls {
      label: "Genesys Conversation Summary Count Distinct (Inbound Demand Minus Market)"
      type: number
    }
    dimension: count_answered {
      label: "Genesys Conversation Summary Count Answered (Inbound Demand)"
      type: number
    }
    dimension: care_request_count {
      type: number
    }
    dimension: accepted_count {
      type: number
    }
    dimension: complete_count {
      type: number
    }
  dimension_group: conversationstarttime {
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
  dimension: wait_time_minutes {
    value_format: "0.00"
    type: number
  }
  dimension: wait_time_minutes_x_inbound_phone_calls {
    type: number
    sql: ${wait_time_minutes}*${inbound_phone_calls} ;;
  }

  measure: sum_inbound_phone_calls {
    type: sum_distinct
    sql: ${inbound_phone_calls} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${queuename}, ${market_id}) ;;
  }

  measure: sum_inbound_answers {
    type: sum_distinct
    sql: ${count_answered} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${queuename}, ${market_id}) ;;
  }


  measure: sum_wait_time_minutes_x_inbound_demand {
    type: sum_distinct
    sql: ${wait_time_minutes_x_inbound_phone_calls} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${queuename}, ${market_id}) ;;
  }

  measure: sum_accepted_count {
    type: sum_distinct
    sql: ${accepted_count} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${queuename}, ${market_id}) ;;
  }

  measure: avg_wait_time_minutes {
    type: number
    value_format: "0.00"
    sql: case when ${sum_inbound_phone_calls} >0 then ${sum_wait_time_minutes_x_inbound_demand}::float/${sum_inbound_phone_calls}::float else 0 end ;;
  }

  measure: assigned_rate {
    type: number
    value_format: "0%"
    sql: case when ${sum_inbound_answers} >0 then ${sum_accepted_count}::float/${sum_inbound_answers}::float else 0 end ;;
  }

  measure: answer_rate {
    type: number
    value_format: "0%"
    sql: case when ${sum_inbound_phone_calls} >0 then ${sum_inbound_answers}::float/${sum_inbound_phone_calls}::float else 0 end ;;
  }
  measure: actuals_compared_to_projections {
    value_format: "0%"
    type: number
    sql: case when ${care_team_projected_volume.sum_projected}>0 then ${sum_inbound_phone_calls}::float/${care_team_projected_volume.sum_projected}::float else 0 end;;
  }




  }
