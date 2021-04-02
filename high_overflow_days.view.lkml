view: high_overflow_days {
# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"
    derived_table: {
      sql_trigger_value:  SELECT MAX(care_request_id) FROM ${care_request_flat.SQL_TABLE_NAME} where created_date > current_date - interval '2 days';;
      indexes: ["start_date", "name_adj"]
      explore_source: productivity_agg {

        column: start_date {}
        column: inefficiency_index { field: funnel_agg.inefficiency_index }
        column: overflow_percent { field: funnel_agg.overflow_percent }
        column: total_productivity {}
        column: avg_shift_shift_end_last_cr_diff_positive { field: shift_agg.avg_shift_shift_end_last_cr_diff_positive }
        column: avg_drivetime_hours { field: shift_agg.avg_drivetime_hours }
        column: avg_on_scene_hours { field: shift_agg.avg_on_scene_hours }
        column: name_adj {}
        column: after_15_minutes_experiment {}
        filters: {
          field: productivity_agg.start_week
          value: "20 weeks"
        }
        filters: {
          field: funnel_agg.overflow_plus_booked_shaping_percent
          value: ">.25"
        }
      }
    }
  dimension: after_15_minutes_experiment {
    label: "Productivity Agg After 15 Minutes Experiment (Yes / No)"
    type: yesno
  }
    dimension: start_date {
      type: date
    }
    dimension: inefficiency_index {
      value_format: "0.00"
      type: number
    }
    dimension: overflow_percent {
      value_format: "0%"
      type: number
    }
    dimension: total_productivity {
      value_format: "0.00"
      type: number
    }
    dimension: avg_shift_shift_end_last_cr_diff_positive {
      label: "Shift Agg DT End of Shift (avg)"
      value_format: "0"
      type: number
    }
    dimension: avg_drivetime_hours {
      label: "Shift Agg Drivetime Minutes (avg)"
      value_format: "0"
      type: number
    }
    dimension: avg_on_scene_hours {
      label: "Shift Agg On-Scene Time Minutes (avg)"
      value_format: "0"
      type: number
    }
    dimension: name_adj {
      description: "Market name where WMFR is included as part of Denver"
    }
    dimension: high_overflow_bool {
      type: yesno
      sql:  ${start_date} is not null;;
    }
  }
