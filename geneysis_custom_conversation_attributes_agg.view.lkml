view: geneysis_custom_conversation_attributes_agg {
  derived_table: {
    explore_source: geneysis_custom_conversation_attributes {
      column: conversationstarttime {field: geneysis_custom_conversation_attributes.conversationstarttime_date}
      column: market_id {field: markets.id}
      column: ivr_deflection_count {}
      filters: {
        field: geneysis_custom_conversation_attributes.conversationstarttime_date
        value: "365 days ago for 365 days"
      }
    }
    sql_trigger_value: SELECT count(*) FROM looker_scratch.geneysis_custom_conversation_attributes  where geneysis_custom_conversation_attributes.conversationstarttime > current_date - interval '2 day';;
    indexes: ["conversationstarttime"]
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
  dimension: ivr_deflection_count {
    type: number
  }
  dimension: market_id {
    type: number
  }

  measure: sum_ivr_deflections {
    type: sum_distinct
    sql:${ivr_deflection_count};;
    sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;

  }
}
