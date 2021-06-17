# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: expected_care_requests_by_agent_day_queue {
  derived_table: {
    explore_source: genesys_agent_summary {
      column: username {}
      column: conversationstarttime_date {}
      column: queuename {}
      column: count_distinct { field: care_requests.count_distinct }
      column: count_distinct_conversationid {}
      column: max_target_rate { field: queue_targets.max_target_rate }
      column: queue_expected_care_requests {}
      filters: {
        field: genesys_agent_summary.answeredflag
        value: "1"
      }
      filters: {
        field: genesys_agent_summary.direction
        value: "inbound"
      }
      filters: {
        field: genesys_agent_summary.mediatype
        value: "voice"
      }
      filters: {
        field: queue_targets.max_target_rate
        value: "NOT NULL"
      }
    }
    sql_trigger_value: SELECT count(*) FROM looker_scratch.genesys_agent_summary  where genesys_agent_summary.conversationstarttime > current_date - interval '2 day';;
    indexes: ["username","conversationstarttime_date","queuename"]
  }
  dimension: username {}
  dimension: conversationstarttime_date {
    type: date
  }
  dimension: queuename {}

  dimension: count_distinct {
    type: number
  }
  dimension: count_distinct_conversationid {
    type: number
  }
  dimension: max_target_rate {
    type: number
  }
  dimension: queue_expected_care_requests {
    type: number
  }

  measure: expected_care_requests {
    type: sum
    value_format_name: decimal_2
    sql: ${queue_expected_care_requests} ;;
  }

  measure: actual_care_requests {
    type: max
    sql: ${count_distinct} ;;
  }

  measure: actual_minus_expected_vs_care_requests {
    type: number
    value_format_name: decimal_2
    sql: ${actual_care_requests} - ${expected_care_requests} ;;
  }

  measure: percent_of_expected_care_requests {
    type: number
    value_format_name: percent_0
    sql: ${actual_care_requests} / nullif(${expected_care_requests},0) ;;
  }
}
