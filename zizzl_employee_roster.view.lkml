view: zizzl_employee_roster {
  sql_table_name: zizzl.employee_summary ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: count_active_employees {
    type: number
    sql: ${TABLE}."count_active_employees" ;;
  }

  measure: avg_active_employees {
    type: average
    description: "The average number of active employees."
    value_format: "0.0"
    sql: ${count_active_employees} ;;
  }

  measure: sum_active_employees {
    type: sum
    description: "The sum of all active employees."
    sql: ${count_active_employees} ;;
  }

  dimension: count_involuntary_terminations {
    type: number
    sql: ${TABLE}."count_involuntary_terminations" ;;
  }

  measure: sum_involuntary_terminations {
    type: sum
    sql: ${count_involuntary_terminations} ;;
  }

  dimension: count_other_terminations {
    type: number
    sql: ${TABLE}."count_other_terminations" ;;
  }

  measure: sum_other_terminations {
    type: sum
    sql: ${count_other_terminations} ;;
  }

  dimension: count_voluntary_terminations {
    type: number
    sql: ${TABLE}."count_voluntary_terminations" ;;
  }

  measure: sum_voluntary_terminations {
    type: sum
    sql: ${count_voluntary_terminations} ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
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

  dimension: employee_category {
    type: string
    description: "The employee category: APP, DHMT, CARE Team, CORP"
    sql: ${TABLE}."employee_category" ;;
  }

  dimension: employee_category_aggregated {
    type: string
    description: "Employee Category where APP and DHMT are combined into Clinical"
    sql: CASE WHEN ${employee_category} IN ('APP','DHMT') THEN 'Clinical'
         ELSE ${employee_category} END;;
  }

  dimension: employee_location {
    type: string
    sql: CASE
          WHEN ${TABLE}."employee_location" LIKE 'Advanced Care%' THEN 'Headquarters/Corporate'
          ELSE ${TABLE}."employee_location"
        END;;
  }

  dimension_group: report {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."report_date" ;;
  }

  measure: count_distinct_days {
    type: count_distinct
    sql: ${report_date} ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
