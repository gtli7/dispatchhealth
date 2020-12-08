view: genesys_agent_conversion {

# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"
  derived_table: {
    sql_trigger_value: SELECT count(*) FROM looker_scratch.genesys_conversation_wrapup  where conversationstarttime > current_date - interval '2 day';;
    indexes: ["conversationstarttime", "queuename", "market_id", "agent_name"]
    explore_source: genesys_conversation_summary {
      column: conversationstarttime {field: genesys_conversation_summary.conversationstarttime_date}
      column: queuename {}
      column: market_id {field:markets.id}

      column: wait_time_minutes {field: genesys_conversation_summary.average_wait_time_minutes}
      column: inbound_phone_calls {field:  genesys_conversation_summary.distinct_callers}
      column: count_answered { field: genesys_conversation_summary.distinct_answer_long_callers}
      column: care_request_count { field: care_request_flat.care_request_count }
      column: accepted_count { field: care_request_flat.accepted_or_scheduled_count }
      column: complete_count { field: care_request_flat.complete_count }
      column: agent_name { field: genesys_conversation_wrapup.username }
      filters: {
        field: genesys_conversation_summary.conversationstarttime_time
        value: "120 days ago for 120 days"
      }
      filters: {
        field: genesys_conversation_summary.queuename
        value: "General Care,DTC,Partner Direct,DTC Pilot,ATL Optum Care"
      }
      filters: {
        field: markets.id
        value: "NOT NULL"
      }
      filters: {
        field: genesys_conversation_wrapup.username
        value: "-NULL"
      }

    }
  }

  dimension: queuename {}

  dimension: market_id {}
  dimension: agent_name {}


  dimension: inbound_phone_calls {
    label: "Count Ditinct Phone Callers (Inbound Demand)"
    type: number
  }
  dimension: count_answered {
    label: "Contacts w/ Intent"
    description: "(Intent Queue, >1 minute talk time w/agent)"
    type: number
  }
  dimension: care_request_count {
    type: number
  }
  dimension: accepted_count {
    label: "Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled)"
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
    label: "Sum Inbound Callers"
    sql: ${inbound_phone_calls} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${queuename}, ${market_id}, ${agent_name}) ;;
  }

  measure: sum_inbound_answers {
    label: "Sum Contacts w/ Intent"
    description: "(Intent Queue, >1 minute talk time w/agent) "
    type: sum_distinct
    sql: ${count_answered} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${queuename}, ${market_id},  ${agent_name}) ;;
  }


  measure: sum_wait_time_minutes_x_inbound_demand {
    type: sum_distinct
    sql: ${wait_time_minutes_x_inbound_phone_calls} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${queuename}, ${market_id},  ${agent_name}) ;;
  }

  measure: sum_accepted_count {
    label: "Sum Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled)"
    type: sum_distinct
    sql: ${accepted_count} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${queuename}, ${market_id},  ${agent_name}) ;;
  }

  measure: avg_wait_time_minutes {
    type: number
    value_format: "0.00"
    sql: case when ${sum_inbound_phone_calls} >0 then ${sum_wait_time_minutes_x_inbound_demand}::float/${sum_inbound_phone_calls}::float else 0 end ;;
  }

  measure: assigned_rate {
    description: "Sum Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled)/Sum Contacts w/ Intent (Intent Queue, >1 minute talk time w/agent)"
    type: number
    value_format: "0%"
    sql: case when ${sum_inbound_answers} >0 then ${sum_accepted_count}::float/${sum_inbound_answers}::float else 0 end ;;
  }

  measure: answer_rate {
    type: number
    value_format: "0%"
    sql: case when ${sum_inbound_phone_calls} >0 then ${sum_inbound_answers}::float/${sum_inbound_phone_calls}::float else 0 end ;;
  }
}
