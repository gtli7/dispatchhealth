view: target_staffing {
  derived_table: {
    sql: SELECT
          hrs.month,
          hrs.market_short,
          hrs.market_id,
          hrs.shift_type,
          hrs.dow,
          hrs.dow_order,
          frac.provider_type,
          hrs.hours * frac.fraction AS target_hours
        FROM looker_scratch.daily_target_hours hrs
        JOIN looker_scratch.provider_fractions frac
          ON hrs.month = frac.month
          AND hrs.market_short = frac.market_short
          AND hrs.shift_type = frac.shift_type
      ;;
    indexes: ["month", "market_short", "market_id", "dow", "provider_type"]
  }

  dimension: acute_tele_flag {
    type: yesno
    sql: (${TABLE}.provider_type = 'APP' AND ${TABLE}.shift_type = 'Acute') OR
          (${TABLE}.provider_type = 'DHMT' and ${TABLE}.shift_type = 'Tele') ;;
  }

  dimension: dow {
    type: string
    sql: ${TABLE}.dow ;;
  }

  dimension: dow_order {
    type: number
    sql: ${TABLE}.dow_order ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: market_short {
    type: string
    sql: ${TABLE}.market_short ;;
  }

  dimension_group: month {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.month ;;
  }

  dimension: provider_type {
    type: string
    sql: ${TABLE}.provider_type ;;
  }

  dimension: shift_type {
    type: string
    sql: ${TABLE}.shift_type ;;
  }

  dimension: target_hours {
    type: number
    sql: ${TABLE}.target_hours ;;
  }

  measure: sum_acute_hours {
    label: "Target Car Hours (acute only)"
    type: sum_distinct
    sql_distinct_key: concat(${shift_teams.start_date}::varchar, ${markets.name});;
    sql: ${target_hours} ;;
    filters: [provider_type: "APP", shift_type: "Acute"]
  }

  measure: sum_acute_tele_hours {
    label: "Target Car Hours (acute, tele only)"
    type: sum_distinct
    sql_distinct_key: concat(${shift_teams.start_date}::varchar, ${markets.name}, ${TABLE}.shift_type);;
    sql: ${target_hours} ;;
    filters: [acute_tele_flag: "yes"]
  }

  measure: sum_acute_tele_hours_adj_dual {
    type: sum_distinct
    sql_distinct_key: concat(${dates_rolling.day_date}::varchar, ${markets.name_adj_dual}, ${TABLE}.shift_type);;
    sql: ${target_hours} ;;
    filters: [acute_tele_flag: "yes"]
  }

  measure: sum_acute_tele_hours_adj_dual_by_dow {
    type: sum_distinct
    sql_distinct_key: concat(${month_month}, ${dow}, ${markets.name_adj_dual}, ${shift_type});;
    sql: ${target_hours} ;;
    filters: [acute_tele_flag: "yes"]
  }

  measure: sum_app_acute_tele_hours {
    label: "Target APP Hours (acute, tele only)"
    type: sum_distinct
    sql_distinct_key: concat(${dates_rolling.day_date}::varchar, ${markets.name_adj_dual}, ${TABLE}.shift_type, ${TABLE}.provider_type);;
    sql: ${target_hours} ;;
    filters: [provider_type: "APP", shift_type: "Acute, Tele"]
  }

  measure: sum_dhmt_acute_tele_hours {
    label: "Target DHMT Hours (acute, tele only)"
    type: sum_distinct
    sql_distinct_key: concat(${dates_rolling.day_date}::varchar, ${markets.name_adj_dual}, ${TABLE}.shift_type, ${TABLE}.provider_type);;
    sql: ${target_hours} ;;
    filters: [provider_type: "DHMT", shift_type: "Acute, Tele"]
  }

  measure: dashboard_hours_adj {
    value_format: "0"
    type: number
    sql:${shift_teams.sum_shift_hours_no_arm_advanced_only}-${daily_variable_shift_tracking.sum_actual_recommendation_captured}-${daily_on_call_tracking.sum_on_call_diff}  ;;
  }

  measure: diff_to_target_hours {
    value_format: "0"
    type: number
    sql:${dashboard_hours_adj}-${sum_acute_tele_hours_adj_dual}  ;;
  }

  measure: diff_to_target_percent {
    type: number
    value_format: "0%"
    sql:  case when ${sum_acute_tele_hours_adj_dual} >0 then (${diff_to_target_hours}::float)/(${sum_acute_tele_hours_adj_dual}::float) else 0 end;;
  }

  measure: percent_to_plan {
    type: number
    value_format: "0%"
    sql:  1+${diff_to_target_percent};;
  }

  measure: sum_app_hours {
    label: "APP Target Hrs"
    type: sum_distinct
    sql_distinct_key: concat(${dates_rolling.day_date}::varchar, ${markets.id_adj_dual}, ${TABLE}.shift_type)  ;;
    sql: ${target_hours} ;;
    filters: [provider_type: "APP"]
  }

  measure: sum_dhmt_hours {
    label: "DHMT Target Hrs"
    type: sum_distinct
    sql_distinct_key: concat(${dates_rolling.day_date}::varchar, ${markets.id_adj_dual}, ${TABLE}.shift_type)  ;;
    sql: ${target_hours} ;;
    filters: [provider_type: "DHMT"]
  }

  measure: sum_target_hours_datetime_explore {
    label: "Target Hours (acute only)"
    type: sum_distinct
    sql_distinct_key: concat(${date_placeholder.date_placeholder_date}::varchar, ${markets.name});;
    sql: ${target_hours} ;;
    filters: [provider_type: "APP", shift_type: "Acute"]
  }

  measure: sum_acute_tele_hours_datetime_explore {
    label: "Target Hours (acute, tele only)"
    type: sum_distinct
    sql_distinct_key: concat(${date_placeholder.date_placeholder_date}::varchar, ${markets.name_adj_dual}, ${TABLE}.shift_type);;
    sql: ${target_hours} ;;
    filters: [acute_tele_flag: "yes"]
  }

  measure: sum_target_hours_future {
    label: "Target Hours"
    type: sum_distinct
    sql_distinct_key: concat(${shift_details.local_expected_end_date}::varchar, ${markets_loan.name});;
    sql: ${target_hours} ;;
    filters: [provider_type: "APP", shift_type: "Acute"]
  }

  measure: dashboard_app_hours_adj {
    value_format: "0"
    type: number
    sql:${shift_teams.sum_app_hours_no_arm_advanced_only}-${daily_variable_shift_tracking.sum_actual_recommendation_captured}-${daily_on_call_tracking.sum_on_call_diff}  ;;
  }

  measure: diff_to_target_app_hours {
    value_format: "0"
    type: number
    sql:${dashboard_app_hours_adj}-${sum_app_acute_tele_hours}  ;;
  }

  measure: diff_to_target_app_percent {
    type: number
    value_format: "0%"
    sql:  case when ${sum_app_acute_tele_hours} >0 then ${diff_to_target_app_hours}::float/${sum_app_acute_tele_hours}::float else 0 end;;
  }

  measure: percent_to_app_plan {
    type: number
    value_format: "0%"
    sql:  1+${diff_to_target_app_percent};;
  }

  measure: dashboard_dhmt_hours_adj {
    value_format: "0"
    type: number
    sql:${shift_teams.sum_dhmt_hours_no_arm_advanced_only}-${daily_variable_shift_tracking.sum_actual_recommendation_captured}-${daily_on_call_tracking.sum_on_call_diff}  ;;
  }

  measure: diff_to_target_dhmt_hours {
    value_format: "0"
    type: number
    sql:${dashboard_dhmt_hours_adj}-${sum_dhmt_acute_tele_hours}  ;;
  }

  measure: diff_to_target_dhmt_percent {
    type: number
    value_format: "0%"
    sql:  case when ${sum_dhmt_acute_tele_hours} >0 then ${diff_to_target_dhmt_hours}::float/${sum_dhmt_acute_tele_hours}::float else 0 end;;
  }

  measure: percent_to_dhmt_plan {
    type: number
    value_format: "0%"
    sql:  1+${diff_to_target_dhmt_percent};;
  }

}
