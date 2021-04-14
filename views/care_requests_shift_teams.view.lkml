view: care_requests_shift_teams {
  derived_table: {
    sql:select
    id,
    care_request_id,
     on_scene_shift_team_id,
    virtual_shift_team_id,
    is_dispatched,
    created_at,
    updated_at, rn
from
(SELECT ROW_NUMBER() OVER(PARTITION BY st1.care_request_id
                                ORDER BY st1.updated_at DESC) AS rn,
    st1.id,
    st1.care_request_id,
    st1.shift_team_id AS on_scene_shift_team_id,
    st2.shift_team_id AS virtual_shift_team_id,
    st1.is_dispatched,
    st1.created_at,
    st1.updated_at
    FROM public.care_requests_shift_teams st1
    LEFT JOIN (
        SELECT
            care_request_id,
            shift_team_id
            FROM public.care_requests_shift_teams
            join shift_teams
            on care_requests_shift_teams.shift_team_id=shift_teams.id
            join shift_types
            on shift_types.id=shift_teams.shift_type_id
            WHERE NOT is_dispatched and shift_types.name='telepresentation_virtual_app') AS st2
        ON st1.care_request_id = st2.care_request_id
    WHERE st1.is_dispatched)lq
    where rn=1;;

      sql_trigger_value: select max(care_requests_shift_teams.care_request_id from public.care_requests_shift_teams where care_requests_shift_teams.created_at > current_date- interval '3 day'' ;;
      indexes: ["care_request_id", "on_scene_shift_team_id", "virtual_shift_team_id"]
    }

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
    sql: ${TABLE}."on_scene_shift_team_id" ;;
  }

  dimension: virtual_shift_team_id {
    type: number
    sql: ${TABLE}."virtual_shift_team_id" ;;
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
