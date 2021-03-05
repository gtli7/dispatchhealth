view: daily_on_call_tracking {

    derived_table: {
      explore_source: on_call_tracking {
        column: date_date {}
        column: on_call_diff {field:on_call_tracking.sum_on_call_diff}
        column: short_name_adj_dual { field: markets.short_name_adj_dual }
        filters: {
          field: on_call_tracking.date_date
          value: "180 days ago for 180 days"
        }
        filters: {
          field: on_call_tracking.on_call_active
          value: "Yes"
        }
        filters: {
          field: on_call_tracking.on_call_diff_positive
          value: "Yes"
        }
      }
    }
    dimension: date_date {
      type: date
    }
    dimension: on_call_diff {
      type: number
    }
    dimension: short_name_adj_dual {
      description: "Market short name where WMFR/SMFR are included in Denver, and dual markets are combined respectively (TACOLY AND NJRMOR) "
    }
    measure: sum_on_call_diff {
      type: sum_distinct
      sql: ${on_call_diff} ;;
      sql_distinct_key: concat(${date_date}, ${short_name_adj_dual});;
    }


  }
