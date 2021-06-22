view: wellmed_optum_care_requests {
    derived_table: {
      explore_source: care_requests {
        column: care_request_id { field: care_request_flat.care_request_id }
        filters: {
          field: markets.name_adj
          value: "Tampa"
        }
        filters: {
          field: provider_network.name
          value: "Wellmed Florida Employed,Optum Florida Contracted,Optum Florida Employed"
        }
      }
      sql_trigger_value:  SELECT MAX(care_request_id) FROM ${care_request_flat.SQL_TABLE_NAME} where created_date > current_date - interval '2 days';;
      indexes: ["care_request_id"]
    }
    dimension: care_request_id {
      type: number
    }

  }
