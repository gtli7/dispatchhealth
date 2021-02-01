view: zizzl_shift_hours_daily {
  derived_table: {
    explore_source: shift_teams {
      column: start {
        field: shift_teams.start_date
      }
      column: market_id {
        field: markets.id
      }
      column: sum_clinical_hours_no_arm_advanced {
        field: zizzl_shift_hours.sum_clinical_hours_no_arm_advanced_only
      }
    }
  }

  dimension_group: start {
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

  dimension: sum_clinical_hours_no_arm_advanced {
    label: "Zizzl Sum Shift Hours (no arm, advanced)"
    value_format: "0.0"
    type: number
  }

  measure: total_clinical_hours_no_arm_advanced {
    type: sum_distinct
    value_format: "0"
    sql: ${sum_clinical_hours_no_arm_advanced} ;;
    sql_distinct_key: concat(${start_date}, ${market_id}) ;;
  }


  }
