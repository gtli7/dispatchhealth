view: dates_rolling {
  derived_table: {
    sql: SELECT
        date_trunc('day', dd)::date as day,
        date_trunc('month', date_trunc('day', dd))::date as month,
        to_char(date_trunc('day', dd), 'Day') as dow
      FROM generate_series
              ((date_trunc('month', current_date) - interval '6 month')::date,
               (date_trunc('month', current_date) + interval '6 month' - interval '1 day')::date,
               '1 day'::interval) dd
       ;;
    sql_trigger_value: SELECT current_date ;;
    indexes: ["day", "month", "dow"]
  }

  measure: count {
    type: count
    drill_fields: []
  }

  dimension: primary_key {
    primary_key: yes
    type: date
    sql: ${TABLE}."day_date" ;;
  }

  dimension_group: day {
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
    sql: ${TABLE}."day" ;;
  }

  # dimension: month {
  #   type: date
  #   sql: ${TABLE}."month" ;;
  # }

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

  dimension: dow {
    type: string
    sql: ${TABLE}."dow" ;;
  }

  dimension: months_out {
    type: number
    sql: (DATE_PART('year', ${day_date}) - DATE_PART('year', current_date)) * 12 +
      (DATE_PART('month', ${day_date}::date) - DATE_PART('month', current_date)) ;;
  }

  dimension: present_or_future {
    type: yesno
    sql: ${day_date} >= current_date ;;
  }


}
