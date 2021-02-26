view: target_staffing_old {
  sql_table_name: looker_scratch.target_staffing ;;

  dimension: dow {
    type: string
    sql: ${TABLE}."dow" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: market_short {
    type: string
    sql: ${TABLE}."market_short" ;;
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
    sql: ${TABLE}."month" ;;
  }

  dimension: target_hours {
    type: number
    sql: ${TABLE}."target_hours" ;;
  }

  dimension: tele_hours {
    type: number
    sql: ${TABLE}."tele_hours" ;;
  }

  dimension: arm_hours {
    type: number
    sql: ${TABLE}."arm_hours" ;;
  }

  dimension: other_hours {
    type: number
    sql: ${TABLE}."other_hours" ;;
  }

  dimension: app_hours {
    type: number
    sql: ${TABLE}."target_hours" + ${TABLE}."arm_hours" ;;
  }

  dimension: dhmt_hours {
    type: number
    sql: ${TABLE}."target_hours" + ${TABLE}."tele_hours" ;;
  }


  measure: sum_target_hours {
    type: sum_distinct
    sql_distinct_key: concat(${shift_teams.start_date}::varchar, ${markets.name});;
    sql: ${target_hours} ;;
  }

  measure: sum_car_hours {
    label: "Sum Target Car Hours (acute, tele only)"
    type: sum_distinct
    sql_distinct_key: concat(${shift_teams.start_date}::varchar, ${markets.name});;
    sql: ${target_hours} + ${tele_hours} ;;
  }

  measure: sum_target_hours_datetime_explore {
    type: sum_distinct
    sql_distinct_key: concat(${date_placeholder.date_placeholder_date}::varchar, ${markets.name});;
    sql: ${target_hours} ;;
  }

  measure: sum_target_hours_future {
    label: "Target Hours"
    type: sum_distinct
    sql_distinct_key: concat(${shift_details.local_expected_end_date}::varchar, ${markets_loan.name});;
    sql: ${target_hours} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: sum_app_hours {
    type: sum_distinct
    sql_distinct_key: concat(${dates_rolling.day_date}::varchar, ${markets.id_adj_dual}) ;;
    sql: ${app_hours} ;;
    label: "APP Target Hrs"
  }

  measure: sum_dhmt_hours {
    type: sum_distinct
    sql_distinct_key: concat(${dates_rolling.day_date}::varchar, ${markets.id_adj_dual}) ;;
    sql: ${dhmt_hours} ;;
    label: "DHMT Target Hrs"
  }
}
