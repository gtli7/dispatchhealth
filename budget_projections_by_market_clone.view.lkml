view: budget_projections_by_market_clone {
  sql_table_name: looker_scratch.budget_projections_by_market_clone ;;

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension_group: month {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      month_num,
      day_of_month,
      quarter,
      year
    ]
    sql: ${TABLE}.month ;;
  }

  dimension: projected_visits {
    type: number
    sql: ${TABLE}.projected_visits ;;
  }

  dimension: days_in_month {
    type: number
    sql: CASE WHEN date_part('month', ${month_date}) IN (4, 6, 9, 11) THEN 30
        WHEN date_part('month', ${month_date}) = 2 AND
             date_part('year', ${month_date})::numeric % 4 = 0 AND
             (date_part('year', ${month_date})::numeric % 100 != 0 OR date_part('year', ${month_date})::numeric % 400 = 0)
             THEN 29
        WHEN date_part('month', ${month_date}) = 2 THEN 28
        ELSE 31 END ;;
  }

  dimension: projected_visits_daily {
    type: number
    sql: 1.0 * ${projected_visits} / ${days_in_month} ;;
  }

  measure: sum_projected_visits {
    label:"Budgeted Visits"
    type: sum_distinct
    sql_distinct_key: concat(${market_dim_id}, ${month_raw})  ;;
    sql: ${projected_visits} ;;
  }

  measure: sum_projected_visits_daily {
    label: "Sum Budgeted Visits Daily"
    type: sum_distinct
    sql_distinct_key: concat(${market_dim_id}, ${month_raw}) ;;
    sql: ${projected_visits_daily} ;;
  }


  measure: sum_projected_visits_daily_prod_agg {
    label: "Sum Budgeted Visits Daily (Prod Agg Explore)"
    value_format: "#,##0"
    type: sum_distinct
    sql_distinct_key: concat(${market_dim_id}, ${productivity_agg.start_date}) ;;
    sql: ${projected_visits_daily} ;;
  }


  measure: percent_of_goal{
    value_format: "0.0%"
    type: number
    sql: case when ${sum_projected_visits}> 0 then ${care_request_flat.monthly_visits_run_rate}::float/${sum_projected_visits}::float else 0 end;;
  }


  measure: sum_projected_visits_weekly {
    label:"Budgeted Visits Weekly"
    type: sum_distinct
    value_format: "#,##0"
    sql_distinct_key: concat(${market_dim_id}, ${month_raw})  ;;
    sql: (${projected_visits}/DATE_PART('days',
              DATE_TRUNC('month', ${care_request_flat.yesterday_mountain_date})
              + '1 MONTH'::INTERVAL
              - '1 DAY'::INTERVAL
          ))*7;;
  }


  measure: count {
    type: count
    drill_fields: []
  }
  measure: projection_visits_month_to_date {
    type: number
    sql: ${sum_projected_visits}*${care_request_flat.month_percent} ;;
  }

  measure: projection_visits_daily_volume{
    label: "Daily Volume Needed for Budget"
    type: number
    sql: round(avg(${projected_visits}/DATE_PART('days',
        DATE_TRUNC('month', current_date)
        + '1 MONTH'::INTERVAL
        - '1 DAY'::INTERVAL
    ))) ;;
  }


}
