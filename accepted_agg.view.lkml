view: accepted_agg {
  derived_table: {
    explore_source: care_requests {
      column: first_accepted_date { field: care_request_flat.scheduled_or_accepted_coalese_date }
      column: accepted_count { field: care_request_flat.accepted_or_scheduled_count }
      column: accepted_or_scheduled_phone_count { field: care_request_flat.accepted_or_scheduled_phone_count }
      column: complete_count { field: care_request_flat.complete_count }

      column: booked_resolved_count {field: care_request_flat.booked_resolved_count}
      column: lwbs_accepted {field: care_request_flat.lwbs_accepted_count}
      column: lwbs_scheduled {field:care_request_flat.lwbs_scheduled_count}
      column: care_request_created_count {field: care_request_flat.care_request_count}
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

  dimension: booked_resolved_count {
    type: number
  }

  dimension: lwbs_accepted {
    type: number
  }

  dimension: lwbs_scheduled {
    type: number
  }

  dimension: care_request_created_count {
    type: number
  }

  measure: sum_accepted {
    label: "Sum Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled)"
    value_format: "0"
    type: sum_distinct
    sql: ${accepted_count} ;;
    sql_distinct_key: concat(${first_accepted_date}, ${market_id}) ;;
  }

  measure: resolved_wo_accepted_scheduled_booked{
    type: number
    sql: ${sum_care_request_created}-${sum_lwbs_accepted}-${sum_lwbs_scheduled}-${sum_booked_resolved}-${sum_complete} ;;
  }



  measure: sum_phone_accepted_or_scheduled_phone_count {
    label: "Sum Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled)"
    value_format: "0"
    type: sum_distinct
    sql: ${accepted_or_scheduled_phone_count} ;;
    sql_distinct_key: concat(${first_accepted_date}, ${market_id}) ;;
  }

  measure: sum_complete {
    label: "Complete Care Requests"
    type: sum_distinct
    sql: ${complete_count} ;;
    sql_distinct_key: concat(${first_accepted_date}, ${market_id}) ;;
  }

  measure: sum_booked_resolved {
    type: sum_distinct
    sql: ${booked_resolved_count} ;;
    sql_distinct_key: concat(${first_accepted_date}, ${market_id}) ;;
  }

  measure: sum_care_request_created {
    label: "Contacts w/ Intent"
    description: "Care Requests Created"

    type: sum_distinct
    sql: ${care_request_created_count} ;;
    sql_distinct_key: concat(${first_accepted_date}, ${market_id}) ;;
  }

  measure: sum_lwbs_accepted {
    type: sum_distinct
    sql: ${lwbs_accepted} ;;
    sql_distinct_key: concat(${first_accepted_date}, ${market_id}) ;;
  }

  measure: sum_lwbs_scheduled {
    type: sum_distinct
    sql: ${lwbs_scheduled} ;;
    sql_distinct_key: concat(${first_accepted_date}, ${market_id}) ;;
  }

  measure: accepted_care_requests{
    type: number
    sql: ${sum_complete}+${sum_lwbs_accepted} ;;
  }
  measure: captured_sum {
    label: "Captured Care Requests"
    description: "Capture (Accepted, Scheduled Acute, .7*Booked)"
    type: number
    value_format: "#,##0"
    sql:
      ${sum_lwbs_accepted}+${sum_lwbs_scheduled}+${sum_booked_resolved}::float*.7+${sum_complete};;
  }

  measure: assigned_rate {
    description: "Sum Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled)/Contacts w/Intent"
    label: "Percent Captured"
    type: number
    value_format: "0%"
    sql: case when ${sum_care_request_created} >0 then ${sum_accepted}::float/${sum_care_request_created}::float else 0 end ;;
  }

  measure: percent_loss_after_capture {
    label: "Percent Accepted"
    type: number
    value_format: "0%"
    sql: case when ${captured_sum} >0 then ${accepted_care_requests}::float/${captured_sum}::float else 0 end;;
  }
  measure: lwbs_rate {
    label: "Percent LWBS"
    type: number
    value_format: "0%"
    sql: (1-case when ${accepted_care_requests} >0 then ${sum_complete}::float/${accepted_care_requests}::float else 0 end);;
  }

}
