view: incontact {
  sql_table_name: looker_scratch.incontact ;;

  dimension: contact_id {
    type: number
    sql: ${TABLE}.contact_id ;;
  }

  dimension: contact_time_sec {
    type: number
    sql: ${TABLE}.contact_time_sec ;;
  }

  dimension: contact_type {
    type: string
    sql: ${TABLE}.contact_type ;;
  }

  dimension: duration {
    type: number
    sql: coalesce(${TABLE}.duration,0) ;;
  }

  dimension_group: end {
    convert_tz: no
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
  sql: ${TABLE}.end_time ;;
  }

  dimension: end_time_raw {
    type: string
    sql: ${TABLE}.end_time ;;
  }

  dimension: start_time_raw {
    type: string
    sql: ${TABLE}.start_time ;;
  }

  dimension: from_number {
    type: string
    sql: ${TABLE}.from_number ;;
  }

  dimension: skll_name {
    type: string
    sql: ${TABLE}.skll_name ;;
  }

  dimension_group: start {
    convert_tz: no
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.start_time ;;
  }

  dimension: talk_time_sec {
    type: number
    sql: coalesce(${TABLE}.talk_time_sec,0) ;;
  }
  measure:  sum_talk_time_sec {
    type: sum_distinct
    sql_distinct_key:  concat(${contact_id}, ${skll_name}, ${end_time_raw});;
    sql: ${talk_time_sec} ;;
  }

  dimension: to_number {
    type: string
    sql: ${TABLE}.to_number ;;
  }

  measure: count {
    type: count
    drill_fields: [skll_name]
  }
  measure: count_distinct {
    type: number
    sql:count(distinct ${contact_id}) ;;
  }

  measure: count_distinct_phone_number {
    type: number
    sql:count(distinct ${from_number}) ;;
  }

  measure: count_distinct_answers {
    type: number
    sql:count(distinct case when ${talk_time_sec}>0  then ${contact_id} else null end) ;;
  }

  measure: count_distinct_answers_phone_number {
    type: number
    sql:count(distinct case when ${talk_time_sec}>0  then ${from_number} else null end) ;;
  }
  measure:  wait_time{
    type: number
    sql: ${contact_time_sec} - ${talk_time_sec} ;;
  }
  measure:  average_wait_time{
    type: number
    sql: round(avg(${wait_time}),1) ;;
  }


  dimension: month_to_date  {
    type:  yesno
    sql: DAYOFMONTH(${start_date}) <= DAYOFMONTH(curdate() - interval 1 day) ;;
  }

  dimension: month_to_date_two_days  {
    type:  yesno
    sql: DAYOFMONTH(${start_date}) <= (DAYOFMONTH(curdate() - interval 2 day) ;;
  }
}
