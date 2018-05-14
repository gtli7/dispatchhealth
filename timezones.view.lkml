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
}
