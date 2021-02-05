view: capture_rate_by_market {
    derived_table: {
      sql_trigger_value:  SELECT MAX(care_request_id) FROM ${care_request_flat.SQL_TABLE_NAME} where created_date > current_date - interval '2 days';;
      explore_source: care_requests {
        column: care_request_count { field: care_request_flat.care_request_count }
        column: complete_count { field: care_request_flat.complete_count }
        column: name_adj { field: markets.name_adj }
        column: complete_rate { field: care_request_flat.complete_rate }
        filters: {
          field: care_request_flat.created_date
          value: "42 days ago for 42 days"
        }
        filters: {
          field: care_request_flat.pafu_or_follow_up
          value: "No"
        }
        filters: {
          field: cars.non_actue_car
          value: "No"
        }
        filters: {
          field: care_request_flat.booked_shaping_placeholder_resolved
          value: "No"
        }
      }
    }
    dimension: care_request_count {
      type: number
    }
    dimension: complete_count {
      type: number
    }
    dimension: name_adj {
      description: "Market name where WMFR/SMFR are included as part of Denver"
    }
    dimension: complete_rate {
      value_format: "0%"
      type: number
    }
  }
