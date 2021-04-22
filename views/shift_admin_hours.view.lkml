view: shift_admin_hours {
  sql_table_name: looker_scratch.shift_admin_hours ;;

  dimension: count_as_shift {
    type: number
    sql: ${TABLE}."count_as_shift" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."created_at" ;;
  }

  dimension: employee_id {
    type: number
    sql: ${TABLE}."employee_id" ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}."facility_ext_id" ;;
  }

  dimension: facility_id {
    type: number
    sql: ${TABLE}."facility_id" ;;
  }

  dimension: facility_name {
    type: string
    sql: ${TABLE}."facility_name" ;;
  }

  dimension: facility_short_name {
    type: string
    sql: ${TABLE}."facility_short_name" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension: group_id {
    type: number
    sql: ${TABLE}."group_id" ;;
  }

  dimension: is_night {
    type: number
    sql: ${TABLE}."is_night" ;;
  }

  dimension: is_weekend {
    type: number
    sql: ${TABLE}."is_weekend" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension: npi {
    type: number
    sql: ${TABLE}."npi" ;;
  }

  dimension: num_shifts {
    type: number
    sql: ${TABLE}."num_shifts" ;;
  }

  dimension_group: shift_day {
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
    sql: ${TABLE}."shift_day" ;;
  }

  dimension_group: shift_end {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week
    ]
    sql: ${TABLE}."shift_end" ;;
  }

  dimension: shift_hours {
    type: number
    sql: ${TABLE}."shift_hours" ;;
  }

  dimension: shift_id {
    type: number
    sql: ${TABLE}."shift_id" ;;
  }

  dimension: shift_name {
    type: string
    sql: ${TABLE}."shift_name" ;;
  }

  dimension: shift_short_name {
    type: string
    sql: ${TABLE}."shift_short_name" ;;
  }

  dimension_group: shift_start {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week
    ]
    sql: ${TABLE}."shift_start" ;;
  }

  dimension: short_note {
    type: string
    sql: ${TABLE}."short_note" ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."user_id" ;;
  }

  dimension: primary_key {
    type: string
    sql: concat(${user_id}, ${shift_id}, ${shift_start_raw}) ;;
  }

  dimension: app_shift {
    type: yesno
    sql: ${shift_short_name} ~* '(?:np\/pa|app).*(?:\d{2,}|smfr|wmfr).*' ;;
    #sql: lower(${shift_short_name}) like '%np/pa%' or lower(${shift_short_name}) like '%app%' ;;
  }

  dimension: dhmt_shift {
    type: yesno
    sql: ${shift_short_name} ~* 'dhmt.*(?:\d{2,}|smfr|wmfr).*' ;;
    #sql: lower(${shift_short_name}) like '%dhmt%' ;;
  }

  dimension: tele_shift {
    type: yesno
    sql: lower(${shift_short_name}) like '%tele%'  ;;
  }

  dimension: on_call_shift {
    type: yesno
    sql: lower(${shift_name}) like '%on%call%' ;;
  }

  dimension: mfr_shift {
    type: yesno
    sql: ${facility_short_name} IN ('SMFR', 'WMFR') ;;
  }

  dimension: pierce_county_shift {
    type: yesno
    sql: lower(${shift_name}) like '%pierce county%'  ;;
  }

  dimension: delta_shift {
    type: yesno
    sql: lower(${shift_name}) like '%delta%'  ;;
  }

  dimension: closed_shift {
    type: yesno
    sql: lower(${first_name}) = 'closed' and lower(${last_name}) = 'closed'  ;;
  }

  dimension: total_shift_hours {
    type: number
    sql: ${TABLE}."shift_hours" * ${TABLE}."num_shifts" ;;
  }

  dimension: months_out {
    type: number
    sql: (DATE_PART('year', ${shift_day_date}) - DATE_PART('year', now()::date)) * 12 +
              (DATE_PART('month', ${shift_day_date}::date) - DATE_PART('month', now()::date)) ;;
  }

  dimension: acute_tele_flag {
    type: yesno
    sql: (${app_shift} = 'yes' and ${tele_shift} = 'no') OR (${dhmt_shift} = 'yes' and ${tele_shift} = 'yes') ;;
  }

  measure: sum_shift_car_hours {
    type: sum_distinct
    label: "Scheduled Car Hours (acute, tele only)"
    sql: ${total_shift_hours} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: [
      acute_tele_flag: "yes",
      mfr_shift: "no",
      pierce_county_shift: "no",
      delta_shift: "no",
      on_call_shift: "no",
      closed_shift: "no",
      count_as_shift: "1"
    ]
  }


  measure: sum_shift_hours {
    type: sum_distinct
    sql:  ${total_shift_hours} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_shift_app_hours {
    type: sum_distinct
    sql: ${total_shift_hours} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: [
      app_shift: "yes",
      pierce_county_shift: "no",
      delta_shift: "no",
      on_call_shift: "no",
      count_as_shift: "1",
      closed_shift: "no",
      tele_shift: "no"
      ]
    label: "APP Scheduled Hrs"
  }

  measure: sum_shift_dhmt_hours {
    type: sum_distinct
    sql: ${total_shift_hours} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: [
      dhmt_shift: "yes",
      pierce_county_shift: "no",
      delta_shift: "no",
      on_call_shift: "no",
      closed_shift: "no",
      count_as_shift: "1"
      ]
    label: "DHMT Scheduled Hrs"
  }

  measure: pct_target_app_hours {
    type: number
    sql: ${shift_admin_hours.sum_shift_app_hours} / nullif(${target_staffing.sum_app_hours}, 0) ;;
    value_format: "0.00%"
    order_by_field: pct_target_app_hours_order
    label: "% APP Scheduled / Target"
  }

  measure: pct_target_app_hours_order {
    type: number
    sql: case when ${shift_admin_hours.pct_target_app_hours} is null then -1 else ${shift_admin_hours.pct_target_app_hours} end ;;
  }

  measure: pct_target_dhmt_hours {
    type: number
    sql: ${shift_admin_hours.sum_shift_dhmt_hours} / nullif(${target_staffing.sum_dhmt_hours}, 0) ;;
    value_format: "0.00%"
    order_by_field: pct_target_dhmt_hours_order
    label: "% DHMT Scheduled / Target"
  }

  measure: pct_target_dhmt_hours_order {
    type: number
    sql: case when ${shift_admin_hours.pct_target_dhmt_hours} is null then -1 else ${shift_admin_hours.pct_target_dhmt_hours} end ;;
  }

  measure: pct_scheduled_app_hours {
    type: number
    sql: ${shift_teams.sum_app_hours_no_advanced_mc} / nullif(${shift_admin_hours.sum_shift_app_hours}, 0) ;;
    value_format: "0.00%"
    label: "% APP Actual / Scheduled"
  }

  measure: pct_scheduled_dhmt_hours {
    type: number
    sql: ${shift_teams.sum_dhmt_hours_no_advanced_mc} / nullif(${shift_admin_hours.sum_shift_dhmt_hours}, 0) ;;
    value_format: "0.00%"
    label: "% DHMT Actual / Scheduled"
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      first_name,
      last_name,
      facility_name,
      facility_short_name,
      shift_name,
      shift_short_name
    ]
  }
}
