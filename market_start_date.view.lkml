view: market_start_date {
  sql_table_name: looker_scratch.market_start_date ;;

  dimension: market_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension_group: market_start {
    description: "Date market opened"
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
    sql: ${TABLE}.market_start ;;
  }

  dimension: mbo_2020_markets {
    type: yesno
    description: "The markets that are being tracked in 2020 for MBO's"
    sql: ${market_start_date} <= '2019-06-01' ;;
  }

  measure: count {
    description: "Count market start dates"
    hidden: yes
    type: count
    drill_fields: []
  }

  dimension: market_age {
    description: "Age in months from market open"
    type:  number
    sql: extract(year from age(date_trunc('month', ${care_request_flat.complete_raw}), date_trunc('month',${market_start_raw})))*12 + extract(month from age(date_trunc('month', ${care_request_flat.complete_raw}), date_trunc('month',${market_start_raw}))) ;;
  }

  dimension: clinical_market_region {
    description: "Market Region"
    type:  string
    sql: ${TABLE}.clinical_market_region ;;

  }

#   dimension: market_start_month_flag {
#     type: yesno
#     sql: ${market_age} = 0 ;;
#   }

#   measure: count_market_start_month {
#     type: count
#     filters: {
#       field: market_start_month_flag
#       value: "yes"
#     }
#   }

  dimension: market_age_quarter {
    type: number
    value_format: "0"
    sql: floor(${market_age}/3) ;;
  }

  dimension: market_age_year {
    type: number
    value_format: "0"
    sql: floor(${market_age}/12) ;;
  }

  dimension: launched {
    type: yesno
    sql: ${market_start_month} <= ${dates_rolling.day_month} ;;
  }


}
