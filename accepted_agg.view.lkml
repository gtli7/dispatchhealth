view: accepted_agg {
  derived_table: {
    explore_source: care_requests {
      column: first_accepted_date { field: care_request_flat.scheduled_or_accepted_coalese_date }
      column: accepted_count { field: care_request_flat.accepted_or_scheduled_count }
      column: accepted_or_scheduled_phone_count { field: care_request_flat.accepted_or_scheduled_phone_count }
      column: complete_count { field: care_request_flat.complete_count }
      column: market_id { field: markets.id_adj }
      filters: {
        field: care_request_flat.scheduled_or_accepted_coalese_date
        value: "365 days ago for 365 days"
      }
    }
    sql_trigger_value:  SELECT MAX(care_request_id) FROM ${care_request_flat.SQL_TABLE_NAME} where created_date > current_date - interval '2 days';;
    indexes: ["first_accepted_date", "market_id"]
  }
  dimension: first_accepted_date {
    label: "Scheduled/Accepted/Created Coalese Date"
    type: date
  }
  dimension: accepted_count {
    label: "Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled)"

    type: number
  }

  dimension: accepted_or_scheduled_phone_count {
    label: "Phone Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled)"

    type: number
  }

  dimension: complete_count {
    type: number
  }
  dimension: market_id {
    type: number
  }
  measure: sum_accepted {
    label: "Sum Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled)"
    value_format: "0"
    type: sum_distinct
    sql: ${accepted_count} ;;
    sql_distinct_key: concat(${first_accepted_date}, ${market_id}) ;;
  }

  measure: sum_phone_accepted_or_scheduled_phone_count {
    label: "Sum Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled)"
    value_format: "0"
    type: sum_distinct
    sql: ${accepted_or_scheduled_phone_count} ;;
    sql_distinct_key: concat(${first_accepted_date}, ${market_id}) ;;
  }

  measure: sum_complete {
    type: sum_distinct
    sql: ${complete_count} ;;
    sql_distinct_key: concat(${first_accepted_date}, ${market_id}) ;;
  }


}
