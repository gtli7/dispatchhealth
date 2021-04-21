view: timezones {
  sql_table_name: looker_scratch.timezones ;;

  dimension: rails_tz {
    type: string
    primary_key: yes
    sql: ${TABLE}.rails_tz ;;
  }

  dimension: pg_tz {
    type: string
    sql: ${TABLE}.pg_tz ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  dimension: car_visit_timezone_diff {
    type: number
    sql: EXTRACT(EPOCH FROM now() AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} -  now() AT TIME ZONE 'UTC' AT TIME ZONE ${car_timezones.pg_tz})::float/3600;;
  }

  dimension: all_on_route_car_visit_timezone_diff {
    type: number
    sql: EXTRACT(EPOCH FROM now() AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} -  now() AT TIME ZONE 'UTC' AT TIME ZONE ${all_on_route_car_timezones.pg_tz})::float/3600;;
  }
}
