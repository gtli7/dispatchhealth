view: genesys_queue_conversion {

# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"
    derived_table: {
      sql_trigger_value: SELECT count(*) FROM looker_scratch.genesys_conversation_summary  where genesys_conversation_summary.conversationstarttime > current_date - interval '2 day';;
      indexes: ["conversationstarttime", "queuename", "market_id"]
      explore_source: genesys_conversation_summary {
        column: conversationstarttime {field: genesys_conversation_summary.conversationstarttime_date}
        column: queuename {}
        column: direction {}
        column: market_id {field:markets.id}
        column: count_distinct_sla {field: genesys_conversation_summary.count_distinct_sla}
        column: wait_time_minutes {field: genesys_conversation_summary.average_wait_time_minutes}
        column: inbound_phone_calls {field: genesys_conversation_summary.distinct_callers}
        column: count_answered { field: genesys_conversation_summary.distinct_answer_long_callers}
        column: care_request_count { field: care_request_flat.care_request_count }
        column: accepted_count { field: care_request_flat.accepted_or_scheduled_count }
        column: complete_count { field: care_request_flat.complete_count }
        column: count_answered_raw {field: genesys_conversation_summary.distinct_answer_callers}
        column: inbound_phone_calls_first {field: genesys_conversation_summary.count_distinct_first}

        column: sem_covid {field: number_to_market.sem_covid}
        filters: {
          field: genesys_conversation_summary.conversationstarttime_time
          value: "180 days ago for 180 days"
        }
        filters: {
          field: genesys_conversation_summary.distinct_answer_long_callers
          value: ">0"
        }
        filters: {
          field: markets.id
          value: "NOT NULL"
        }
      }
    }


    dimension: queuename {
    type: string
    sql: ${TABLE}."queuename" ;;
    }

  dimension: inbound_phone_calls_first {
    label: "Count Distinct Phone Callers First (Inbound Demand)"
    type: number
  }

  dimension: count_answered_raw {
    label: "Count Answered Callers (No Time Constraint) (Inbound Demand)"
    type: number
  }
    dimension: market_id {}
    dimension: direction {}


    dimension: inbound_phone_calls {
      label: "Count Distinct Phone Callers (Intent Queue)"
      type: number
    }
    dimension: count_answered {
      label: "Contacts w/ Intent"
      description: "(Intent Queue, >1 minute talk time w/agent) "
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


  dimension: count_distinct_sla {
    label: "Count Distinct SLA (Inbound Demand)"
    type: number
  }

  dimension: sem_covid {
    label: "SEM Covid"
    type: yesno
  }
  dimension: primary_key {
    type: string
    sql: concat(${conversationstarttime_date}, ${queuename}, ${market_id}, ${sem_covid}, ${direction}) ;;
  }

  measure: sum_distinct_sla {
    type: sum_distinct
    label: "Sum Distinct SLA (Inbound Demand)"
    sql: ${count_distinct_sla} ;;
    sql_distinct_key: ${primary_key} ;;
    }

  measure: sla_percent {
    type: number
    value_format: "0%"
    sql: ${sum_distinct_sla}::float/(nullif(${sum_inbound_phone_calls_first},0))::float;;
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
    sql: ${wait_time_minutes}*${inbound_phone_calls_first} ;;
  }

  dimension: queuename_adj {
    type: string
    sql: case when ${queuename} in('TIER 1', 'TIER 2') then 'TIER 1/TIER 2'
      when ${queuename} in ('Partner Direct', 'ATL Optum Care', 'LAS RCC', 'Humana Partner Direct', 'BOI Regence', 'POR Regence', 'SEA Regence', 'SPO Regence') then 'Partner Direct (Broad)'
    else ${queuename}  end ;;
  }

  measure: sum_inbound_phone_calls {
    label: "Sum Callers (Intent Queue)"
    type: sum_distinct
    sql: ${inbound_phone_calls} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_inbound_answers {
    label: "Sum Contacts w/ Intent"
    description: "Intent Queue, >1 minute talk time w/agent"
    type: sum_distinct
    sql: ${count_answered} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_answered_callers {
    label: "Sum Answered Callers (No Time Constraint)"
    type: sum_distinct
    sql: ${count_answered_raw} ;;
    sql_distinct_key: ${primary_key};;
  }

  measure: sum_inbound_phone_calls_first {
    label: "Sum Inbound Callers First"
    type: sum_distinct
    sql: ${inbound_phone_calls_first} ;;
    sql_distinct_key:${primary_key} ;;
  }


  measure: sum_wait_time_minutes_x_inbound_demand {
    type: sum_distinct
    sql: ${wait_time_minutes_x_inbound_phone_calls} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_accepted_count {
    label: "Sum Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled)"
    type: sum_distinct
    sql: ${accepted_count} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: avg_wait_time_minutes {
    type: number
    value_format: "0.00"
    sql: case when ${sum_inbound_phone_calls_first} >0 then ${sum_wait_time_minutes_x_inbound_demand}::float/${sum_inbound_phone_calls_first}::float else 0 end ;;
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
    sql: case when ${sum_inbound_phone_calls}>0 then ${sum_answered_callers}::float/${sum_inbound_phone_calls}::float else 0 end;;

  }
  measure: actuals_compared_to_projections {
    value_format: "0%"
    type: number
    sql: case when ${care_team_projected_volume.sum_projected}>0 then ${sum_inbound_phone_calls}::float/${care_team_projected_volume.sum_projected}::float else 0 end;;
  }




  }
