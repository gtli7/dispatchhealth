view: genesys_agg {
# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"
      derived_table: {
      explore_source: genesys_conversation_summary {
        column: conversationstarttime {  field: genesys_conversation_summary.conversationstarttime_date}
        column: market_id { field: markets.id_adj }
        column: count_answered {field: genesys_conversation_summary.distinct_answer_long_callers}
        column: count_answered_raw {field: genesys_conversation_summary.distinct_answer_callers}
        column: inbound_phone_calls {field: genesys_conversation_summary.distinct_callers}
        column: inbound_phone_calls_first {field: genesys_conversation_summary.count_distinct_first}

        column: count_distinct_sla {field: genesys_conversation_summary.count_distinct_sla}
        column: wait_time_minutes {field: genesys_conversation_summary.average_wait_time_minutes}
        filters: {
          field: genesys_conversation_summary.conversationstarttime_date
          value: "365 days ago for 365 days"
        }
      }
        sql_trigger_value: SELECT count(*) FROM looker_scratch.genesys_conversation_summary  where genesys_conversation_summary.conversationstarttime > current_date - interval '2 day';;
        indexes: ["conversationstarttime", "market_id"]
    }

  dimension: wait_time_minutes {
    label: "Wait Time Minutes (Inbound Demand)"
    value_format: "0.00"
    type: number
  }

  dimension: count_distinct_sla {
    label: "Count Distinct SLA (Inbound Demand)"
    type: number
  }

  measure: sum_distinct_sla {
    type: sum_distinct
    label: "Sum Distinct SLA (Inbound Demand)"
    sql: ${count_distinct_sla} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;
  }

  measure: sla_percent {
    type: number
    value_format: "0%"
    sql: ${sum_distinct_sla}::float/(nullif(${sum_inbound_phone_calls_first},0))::float;;
  }


  dimension: wait_time_minutes_x_inbound_phone_calls {
    type: number
    sql: ${wait_time_minutes}*${inbound_phone_calls_first} ;;
  }

  measure: sum_wait_time_minutes_x_inbound_demand {
    type: sum_distinct
    sql: ${wait_time_minutes_x_inbound_phone_calls} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;
  }

  measure: avg_wait_time_minutes {
    type: number
    value_format: "0.00"
    sql: case when ${sum_inbound_phone_calls_first} >0 then ${sum_wait_time_minutes_x_inbound_demand}::float/${sum_inbound_phone_calls_first}::float else 0 end ;;
  }

  dimension: inbound_demand{
    label: "Contacts w/ Intent"
    description: "Intent Queue, >1 minute talk time w/agent, web/mobille care requests"
    type: number
    sql: ${count_answered} +case when ${non_phone_cr.care_request_count} is not null then ${non_phone_cr.care_request_count} else 0 end;;
  }

  measure: sum_inbound_demand{
    label: "Sum Contacts w/ Intent"
    description: "Intent Queue and >1 minute talk time w/agent, web/mobille care requests"
    type: sum_distinct
    sql: ${inbound_demand} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;
  }

  measure: sum_inbound_demand_phone{
    label: "Sum Phone Contacts w/ Intent"
    description: "Intent Queue and >1 minute talk time w/agent, web/mobille care requests"
    type: sum_distinct
    sql: ${count_answered} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;
  }




  measure: assigned_rate {
    description: "Sum Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled)/Sum Contacts w/ Intent (Intent Queue, >1 minute talk time w/agent)"
    type: number
    value_format: "0%"
    sql: case when ${sum_inbound_demand} >0 then ${accepted_agg.sum_accepted}::float/${sum_inbound_demand}::float else 0 end ;;
  }

  measure: assigned_rate_phone {
    description: "Phone Sum Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled)/Sum Contacts w/ Intent (Intent Queue, >1 minute talk time w/agent)"
    type: number
    value_format: "0%"
    sql: case when ${sum_inbound_demand_phone} >0 then ${accepted_agg.sum_phone_accepted_or_scheduled_phone_count}::float/${sum_inbound_demand_phone}::float else 0 end ;;
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
    dimension: market_id {
      type: number
    }
    dimension: count_answered {
      label: "Count Answered Callers (Intent)"
      type: number
    }

  dimension: count_answered_raw {
    label: "Count Answered Callers (No Time Constraint) (Intent)"
    type: number
  }
  dimension: inbound_phone_calls {
    label: "Count Distinct Phone Callers (Intent)"
    type: number
  }

  dimension: inbound_phone_calls_first {
    label: "Count Distinct Phone Callers Inbound (Intent)"
    type: number
  }

    measure: sum_answered {
      label: "Sum Answered Callers"
      type: sum_distinct
      sql: ${count_answered} ;;
      sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;
    }

  measure: sum_answered_callers {
    label: "Sum Answered Callers (No Time Constraint)"
    type: sum_distinct
    sql: ${count_answered_raw} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;
  }

  measure: sum_inbound_phone_calls {
    label: "Sum Inbound Callers"
    type: sum_distinct
    sql: ${inbound_phone_calls} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;
  }

  measure: sum_inbound_phone_calls_first {
    label: "Sum Inbound Callers First"
    type: sum_distinct
    sql: ${inbound_phone_calls_first} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;
  }

  measure: sum_inbound_demand_month_run_rate {
    label: "Sum Contacts w/ Intent Month Run Rate"
    description: "Intent Queue and >1 minute talk time w/agent, web/mobille care requests"
    type: number
    value_format: "#,##0"
    sql:  ${sum_inbound_demand}/max(${month_percent});;
  }

  measure: sum_inbound_demand_quarterly_run_rate {
    label: "Sum Contacts w/ Intent Quarter Run Rate"
    description: "Intent Queue and >1 minute talk time w/agent, web/mobille care requests"
    type: number
    value_format: "#,##0"
    sql:  ${sum_inbound_demand}/max(${quarter_percent});;
  }

  measure: answer_rate {
    value_format: "0%"
    type: number
    sql: case when ${sum_inbound_phone_calls}>0 then ${sum_answered_callers}::float/${sum_inbound_phone_calls}::float else 0 end;;
  }

  measure: actuals_compared_to_projections {
    value_format: "0%"
    type: number
    sql: case when ${care_team_projected_volume.sum_projected}>0 then ${sum_inbound_phone_calls}::float/${care_team_projected_volume.sum_projected}::float else 0 end;;
  }

  dimension_group: yesterday_mountain{
    type: time
    timeframes: [date, day_of_week_index, week, month, day_of_month, quarter]
    sql: current_date - interval '1 day';;
  }

  dimension: month_percent {
    type: number
    sql:

        case when to_char(${conversationstarttime_date} , 'YYYY-MM') != ${yesterday_mountain_month} then 1
        else
            extract(day from ${yesterday_mountain_date})
          /    DATE_PART('days',
              DATE_TRUNC('month', ${yesterday_mountain_date})
              + '1 MONTH'::INTERVAL
              - '1 DAY'::INTERVAL
          ) end;;
  }

  dimension: quarter_percent{
    type: number
    sql: case when ${conversationstarttime_quarter} != ${yesterday_mountain_quarter} then 1
          else
            (${days_in_quarter}::float-${days_left_in_quarter}::float)/${days_in_quarter}::float end
           ;;
  }

  dimension:  days_in_quarter{
    type: number
    sql: case when EXTRACT(QUARTER FROM ${conversationstarttime_raw}) = 1  then 90
            when EXTRACT(QUARTER FROM ${conversationstarttime_raw}) = 2   then 91
            when EXTRACT(QUARTER FROM ${conversationstarttime_raw}) = 3 then 92
            when EXTRACT(QUARTER FROM ${conversationstarttime_raw}) = 4   then 92
            else null end;;
  }

  dimension: days_left_in_quarter {
    type: number
    sql:
       (  CAST(date_trunc('quarter',  ${conversationstarttime_raw})  + interval '3 months' - interval '1 day' AS date) - CAST( ${yesterday_mountain_date} AS date))
;;
  }


  }
