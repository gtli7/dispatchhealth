view: all_on_route_shifts {
  derived_table: {
    sql:       select lq.care_request_id, lq.on_route_cs_id, lq.accept_cs_id, lq.shift_team_id::int as cs_shift_team_id, cst.shift_team_id as cst_shift_team_id,t.pg_tz, min(lq.started_at)  AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz started_at, min(lq.created_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz created_at, min(lq.accepted_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz accepted_at, 'deleted' as type
from
(select on_route.care_request_id, on_route.id as on_route_cs_id, accept.id accept_cs_id, accept.meta_data::json->> 'shift_team_id' as shift_team_id, on_route.created_at, on_route.started_at, accept.created_at as accepted_at,
ROW_NUMBER() OVER(PARTITION BY accept.care_request_id
                                ORDER BY accept.started_at DESC) AS rn
from
(select       *
from public.care_request_statuses on_route
where on_route.name='on_route' and  deleted_at is not null)on_route
join public.care_request_statuses accept
on accept.care_request_id=on_route.care_request_id and accept.meta_data::json->> 'shift_team_id' is not null
and accept.name = 'accepted' and on_route.created_at > accept.created_at)lq
left join public.care_requests_shift_teams cst
on cst.care_request_id=lq.care_request_id and cst.is_dispatched is true
join public.care_requests cr
on lq.care_request_id=cr.id
JOIN markets
ON cr.market_id = markets.id
JOIN looker_scratch.timezones t
ON markets.sa_time_zone = t.rails_tz
left join public.care_request_statuses real_on_route
on real_on_route.care_request_id=cr.id and real_on_route.name='on_route' and  real_on_route.deleted_at is null
where lq.rn=1 and lq.shift_team_id is not null
and (lq.shift_team_id::int  != cst.shift_team_id or cst.shift_team_id is null or real_on_route.care_request_id is null)
group by 1,2,3,4,5,6
union all
select
on_route.care_request_id, 0 as on_route_cs_id, 0 as accept_cs_id, cst.shift_team_id as cs_shift_team_id, cst.shift_team_id as cst_shift_team_id, t.pg_tz, max(on_route.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz as started_at, max(on_route.created_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz as created_at, null as accepted_at, 'final' as type
from public.care_request_statuses on_route
join public.care_requests_shift_teams cst
on cst.care_request_id=on_route.care_request_id and cst.is_dispatched is true
join public.care_requests cr
on cr.id=on_route.care_request_id
JOIN markets
ON cr.market_id = markets.id
JOIN looker_scratch.timezones AS t
ON markets.sa_time_zone = t.rails_tz
where on_route.name='on_route' and on_route.deleted_at is null
group by 1,2,3,4,5,6;;

    sql_trigger_value: select max(id) from public.care_request_statuses where care_request_statuses.created_at > current_date- interval '2 day' ;;
    indexes: ["care_request_id", "started_at", "cs_shift_team_id"]
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


    dimension: shift_team_id {
      type: number
      sql: ${TABLE}."cs_shift_team_id" ;;
    }

    dimension_group: on_route {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year,
        time_of_day
      ]
      sql: ${TABLE}."started_at" ;;
    }

  dimension_group: min_accepted_at {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      time_of_day
    ]
    sql: ${TABLE}."accepted_at" ;;
  }

  }
