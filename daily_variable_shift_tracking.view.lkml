view: daily_variable_shift_tracking {
    derived_table: {
      explore_source: bulk_variable_shift_tracking {
        column: short_name_adj_dual { field: markets.short_name_adj_dual }
        column: date_date {}
        column: actual_recommendation_captured {}
        filters: {
          field: bulk_variable_shift_tracking.date_date
          value: "180 days ago for 180 days"
        }
      }
    }
    dimension: short_name_adj_dual {
      description: "Market short name where WMFR/SMFR are included in Denver, and dual markets are combined respectively (TACOLY AND NJRMOR) "
    }
    dimension: date_date {
      type: date
    }
    dimension: actual_recommendation_captured {
      value_format: "0.0"
      type: number
    }

    measure:  sum_actual_recommendation_captured{
      type: sum_distinct
      sql: ${actual_recommendation_captured} ;;
      sql_distinct_key: concat(${short_name_adj_dual}, ${date_date}) ;;
    }
  }
