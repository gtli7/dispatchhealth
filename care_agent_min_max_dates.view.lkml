view: care_agent_min_max_dates {
  derived_table: {
    sql_trigger_value: select sum(num) from
    (SELECT count(*) as num FROM looker_scratch.genesys_conversation_summary  where genesys_conversation_summary.conversationstarttime > current_date - interval '1 day'
    UNION ALL
    SELECT count(*) as num FROM looker_scratch.genesys_conversation_wrapup  where genesys_conversation_wrapup.conversationstarttime > current_date - interval '1 day')lq
    ;;
    indexes: ["agent_name_raw"]

      explore_source: genesys_conversation_summary {
        column: agent_name_raw { field: genesys_conversation_wrapup.agent_name_raw }
        column: min_conversationendtime { field: genesys_conversation_wrapup.min_conversationendtime_time }
        column: max_conversationendtime { field: genesys_conversation_wrapup.max_conversationendtime_time }
        filters: {
          field: genesys_conversation_summary.queuename_adj
          value: "DTC Pilot,DTC,Partner Direct (Broad),General Care"
        }
        filters: {
          field: genesys_conversation_summary.direction
          value: "inbound"
        }
        filters: {
          field: genesys_conversation_wrapup.agent_name_raw
          value: "-NULL"
        }
      }
    }
    dimension: agent_name_raw {}
    dimension_group: min_conversationendtime {
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
    dimension_group: max_conversationendtime {
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

  }
