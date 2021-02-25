view: care_requests_shift_teams {
  sql_table_name: (SELECT * FROM public.care_requests_shift_teams)
 -- WHERE ${is_dispatched} IS TRUE)
;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
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

  dimension: is_dispatched {
    type: yesno
    sql: ${TABLE}."is_dispatched" ;;
  }

  dimension: shift_team_id {
    type: number
    sql: ${TABLE}."shift_team_id" ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
