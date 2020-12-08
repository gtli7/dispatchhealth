view: care_request_flat {
  derived_table: {
    sql:
WITH ort AS (
    SELECT DISTINCT
        st.id AS shift_team_id,
        st.start_time,
        crst.care_request_id,
        crs.on_route
        FROM (
            SELECT
                care_request_id,
                MAX(started_at) AS on_route
            FROM public.care_request_statuses
            WHERE name = 'on_route' AND deleted_at IS NULL
            GROUP BY 1) AS crs
        LEFT JOIN public.care_requests_shift_teams crst
            ON crs.care_request_id = crst.care_request_id AND crst.is_dispatched
        LEFT JOIN public.shift_teams st
            ON crst.shift_team_id = st.id
        GROUP BY 1,2,3,4)
    SELECT
        markets.id AS market_id,
        cr.id as care_request_id,
        t.pg_tz,
        cr.created_at AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS created_date,
        max(shift_teams.start_time) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS shift_start_time,
        max(shift_teams.end_time) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS shift_end_time,
        max(request.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS requested_date,
        min(accept1.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS accept_date_initial,
        max(accept.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS accept_date,
        max(schedule.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS scheduled_date,
        max(onroute.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS on_route_date,
        max(onscene.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS on_scene_date,
        MIN(coalesce(comp.started_at, esc.started_at)) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS complete_date,
        MIN(archive.started_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS archive_date,
        fst_or.on_route AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS first_on_route_date,
        fst_cra.accepted AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS first_accepted_date,
        fu3.comment AS followup_3day_result,
        fu3.commentor_id AS followup_3day_id,
        fu3.updated_at AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS day3_followup_date,
        fu14.comment AS followup_14day_result,
        fu30.comment AS followup_30day_result,
        --accept1.initial_eta::timestamptz AS initial_eta,
        accept1.initial_eta::timestamptz AT TIME ZONE t.pg_tz AS initial_eta,
        accept1.auto_assigned AS auto_assigned_initial,
        accept1.reassignment_reason AS reassignment_reason_initial,
        accept1.reassignment_reason_other AS reassignment_reason_other_initial,
        accept1.drive_time_seconds AS drive_time_seconds_initial,
        accept1.shift_team_id_initial,
        cars.name AS shift_team_initial,
        accept.auto_assigned AS auto_assigned_final,
        accept.reassignment_reason AS reassignment_reason_final,
        accept.reassignment_reason_other AS reassignment_reason_other_final,
        accept.drive_time_seconds,
        accept.first_name AS accept_employee_first_name,
        accept.last_name AS accept_employee_last_name,
        accept.user_id AS accept_employee_user_id,
        --accept.eta_time::timestamptz AS eta_date,
        accept.eta_time::timestamptz AT TIME ZONE t.pg_tz AS eta_date,
        eta.starts_at AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS initial_eta_start,
        eta.ends_at AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS initial_eta_end,
        resolved.first_name AS resolved_employee_first_name,
        resolved.last_name AS resolved_employee_last_name,
        resolved.resolved_role,
        case when array_to_string(array_agg(distinct comp.comment), ':') = '' then null
        else array_to_string(array_agg(distinct comp.comment), ':')end
        as complete_comment,
        case when array_to_string(array_agg(distinct archive.comment), ':') = '' then null
        else array_to_string(array_agg(distinct archive.comment), ':') end
        as archive_comment,
        case when array_to_string(array_agg(distinct notes.note), ':') = '' then null
        else array_to_string(array_agg(distinct notes.note), ':')end
        as reorder_reason,
        crst.shift_team_id,
        min(to_date(schedule.comment, 'DD Mon YYYY')) as scheduled_care_date,
        insurances.package_id,
        callers.origin_phone,
        callers.contact_id,
        cr.patient_id as patient_id,
        foc.first_on_scene_time,
        onscene.mins_on_scene_predicted,
        n_assign.count_assignments,
        max(callers.created_at) AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz AS caller_date
      FROM care_requests cr
      LEFT JOIN care_requests_shift_teams crst
        ON cr.id = crst.care_request_id AND crst.is_dispatched
      LEFT JOIN care_request_statuses AS request
      ON cr.id = request.care_request_id AND request.name = 'requested' and request.deleted_at is null
      LEFT JOIN care_request_statuses schedule
      ON cr.id = schedule.care_request_id AND schedule.name = 'scheduled'  and schedule.deleted_at is null
      LEFT JOIN
      (SELECT
       cr.patient_id,
       MIN(crs.started_at AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz) AS first_on_scene_time
       FROM
         care_requests cr
         JOIN care_request_statuses crs
           ON cr.id = crs.care_request_id
         LEFT JOIN markets m
           ON cr.market_id = m.id
         LEFT JOIN looker_scratch.timezones t
           ON m.sa_time_zone = t.rails_tz
         WHERE crs.name = 'on_scene'
         GROUP BY cr.patient_id) foc
    ON cr.patient_id = foc.patient_id
      LEFT JOIN
        (SELECT care_request_id,
        name,
        started_at,
        meta_data::Json->> 'eta' AS initial_eta,
        meta_data::json->> 'auto_assigned' AS auto_assigned,
        meta_data::json->> 'drive_time' AS drive_time_seconds,
        meta_data::json->> 'shift_team_id' AS shift_team_id_initial,
        reassignment_reason,
        reassignment_reason_other,
        ROW_NUMBER() OVER(PARTITION BY care_request_id
                                ORDER BY started_at) AS rn
        FROM care_request_statuses
        WHERE name = 'accepted' AND deleted_at IS NULL) AS accept1
      ON cr.id = accept1.care_request_id AND accept1.rn = 1
      LEFT JOIN public.notes
      ON notes.care_request_id = cr.id
      AND notes.note_type = 'reorder_reason'
      LEFT JOIN (SELECT care_request_id,
        name,
        crs.started_at,
        meta_data::json->> 'auto_assigned' AS auto_assigned,
        meta_data::json->> 'drive_time' AS drive_time_seconds,
        meta_data::json->> 'eta' AS eta_time,
        reassignment_reason,
        reassignment_reason_other,
        ROW_NUMBER() OVER(PARTITION BY care_request_id
                                ORDER BY crs.started_at DESC) AS rn,
        first_name,
        last_name,
        users.id AS user_id
        FROM care_request_statuses crs
        LEFT JOIN users
        ON crs.user_id = users.id
        WHERE name = 'accepted' AND crs.deleted_at IS NULL) AS accept
      ON cr.id = accept.care_request_id AND accept.rn = 1
      LEFT JOIN (
          SELECT
              care_request_id,
              COUNT(DISTINCT (meta_data::json ->> 'shift_team_id')) AS count_assignments
          FROM public.care_request_statuses
          WHERE name = 'accepted' AND deleted_at IS NULL
          GROUP BY 1) AS n_assign
      ON cr.id = n_assign.care_request_id
      LEFT JOIN (
          SELECT
              crs.care_request_id,
              MIN(crs.started_at) AS archive_date,
              INITCAP(users.first_name) AS first_name,
              INITCAP(users.last_name) AS last_name,
              roles.name AS resolved_role
          FROM public.care_request_statuses crs
          LEFT JOIN public.users
              ON crs.user_id = users.id
          LEFT JOIN (
              SELECT
                  users.id AS user_id,
                  COALESCE(csc.role_id, prv.role_id) AS role_id
                  FROM public.users
                  LEFT JOIN public.user_roles csc
                      ON users.id = csc.user_id AND csc.role_id = 5
                  LEFT JOIN public.user_roles prv
                      ON users.id = prv.user_id AND prv.role_id = 2) ur
              ON ur.user_id = users.id
          JOIN public.roles
              ON ur.role_id = roles.id AND roles.name IN ('csc','provider')
          WHERE crs.name = 'archived' AND crs.comment IS NOT NULL AND crs.deleted_at IS NULL
          GROUP BY 1,3,4,5) AS resolved
        ON cr.id =resolved.care_request_id
      LEFT JOIN care_request_statuses AS onroute
      ON cr.id = onroute.care_request_id AND onroute.name = 'on_route' and onroute.deleted_at is null
      LEFT JOIN (
        SELECT
                shift_team_id,
                MIN(on_route) AS on_route
            FROM ort
            GROUP BY shift_team_id) AS fst_or
        ON crst.shift_team_id = fst_or.shift_team_id
      LEFT JOIN (
            SELECT
                CAST(meta_data::json->> 'shift_team_id' AS INT) AS shift_team_id,
                MIN(crs.started_at) AS accepted
            FROM public.care_requests cr
            LEFT JOIN public.care_request_statuses crs
                ON cr.id = crs.care_request_id
            WHERE crs.name = 'accepted' AND crs.deleted_at IS NULL AND meta_data::json->> 'shift_team_id' IS NOT NULL AND
                  LOWER(cr.chief_complaint) <> 'test'
            GROUP BY 1) AS fst_cra
        ON crst.shift_team_id = fst_cra.shift_team_id
      LEFT JOIN (
          SELECT
              care_request_id,
              started_at,
              meta_data::jsonb->>'etoc' AS mins_on_scene_predicted,
              ROW_NUMBER() OVER(PARTITION BY care_request_id
                                ORDER BY started_at DESC) AS rn
              FROM public.care_request_statuses
              WHERE name = 'on_scene' AND deleted_at IS NULL
      ) onscene
        ON cr.id = onscene.care_request_id AND onscene.rn = 1
      LEFT JOIN
          (SELECT
              care_request_id,
              starts_at,
              ends_at,
              ROW_NUMBER() OVER(PARTITION BY care_request_id ORDER BY care_request_id, created_at) AS rn
           FROM public.eta_ranges) eta
      ON cr.id = eta.care_request_id AND eta.rn = 1
      LEFT JOIN care_request_statuses comp
      ON cr.id = comp.care_request_id AND comp.name = 'complete' and comp.deleted_at is null
      LEFT JOIN care_request_statuses esc
      ON cr.id = esc.care_request_id AND esc.name = 'archived' and esc.deleted_at is null
      and lower(esc.comment) like '%referred - point of care%'
      LEFT JOIN care_request_statuses archive
      ON cr.id = archive.care_request_id AND archive.name = 'archived' and archive.deleted_at is null
      LEFT JOIN care_request_statuses fu3
      ON cr.id = fu3.care_request_id AND fu3.name in('followup_3', 'followup_2') and fu3.deleted_at is null
      LEFT JOIN care_request_statuses fu14
      ON cr.id = fu14.care_request_id AND fu14.name = 'followup_14' and fu14.deleted_at is null
      LEFT JOIN care_request_statuses fu30
      ON cr.id = fu30.care_request_id AND fu30.name = 'followup_30' and fu30.deleted_at is null
      LEFT JOIN public.shift_teams
      ON crst.shift_team_id = shift_teams.id
      LEFT JOIN public.shift_teams st_init
      ON st_init.id::int = accept1.shift_team_id_initial::int
      LEFT JOIN cars
      ON st_init.car_id = cars.id
      JOIN markets
      ON cr.market_id = markets.id
      JOIN looker_scratch.timezones AS t
      ON markets.sa_time_zone = t.rails_tz
      LEFT join callers
      on callers.id = cr.caller_id
      left join(select  care_requests.id as care_request_id, package_id,  ROW_NUMBER() OVER(PARTITION BY care_requests.id
                                ORDER BY insurances.created_at desc) as rn
        FROM care_requests
        join public.patients
        on patients.id=care_requests.patient_id
        join public.insurances
        on care_requests.patient_id = insurances.patient_id AND insurances.priority = '1'
        AND insurances.patient_id IS NOT NULL
        and care_requests.created_at + interval '1' day >= insurances.created_at
        and insurances.package_id is not null
        and trim(insurances.package_id)!='') as insurances
        ON cr.id = insurances.care_request_id AND insurances.rn = 1
      GROUP BY 1,2,3,4,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,
               insurances.package_id, callers.origin_phone, callers.contact_id,cr.patient_id,crst.shift_team_id,
               foc.first_on_scene_time,onscene.mins_on_scene_predicted, n_assign.count_assignments;;

    # Run trigger every 2 hours
    sql_trigger_value:  SELECT MAX(id) FROM public.care_requests  where care_requests.created_at > current_date - interval '2 day';;

    indexes: ["care_request_id", "patient_id", "origin_phone", "created_date", "on_scene_date", "complete_date", "first_accepted_date"]
  }

  dimension: care_request_id {
    type: number
    primary_key: yes
    group_label: "IDs"
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: self_report_primary_package_id {
    type: number
    hidden: yes
    sql: ${TABLE}.package_id ;;
  }

  dimension: patient_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}.patient_id ;;
  }

  dimension: origin_phone {
    type: string
    hidden: yes
    sql: ${TABLE}.origin_phone ;;
  }

  dimension: contact_id {
    type: string
    group_label: "IDs"
    sql:
    case
          when ${TABLE}.contact_id  ='' then null
          else ${TABLE}.contact_id
         end;;
  }

  measure: complete_count_seasonal_adj {
    type: number
    value_format: "#,##0"
    sql: (${complete_count}/${seasonal_adj.seasonal_adj})/${days_in_month_adj.days_in_month_adj} ;;
  }
  dimension: on_scene_time_seconds {
    type: number
    hidden: yes
    description: "The number of seconds between complete time and on scene time"
    sql: EXTRACT(EPOCH FROM ${complete_raw})-EXTRACT(EPOCH FROM ${on_scene_raw}) ;;
  }

  dimension: drive_time_seconds {
    type: number
    hidden: yes
    description: "The number of seconds between on route time and on scene time"
    sql: EXTRACT(EPOCH FROM ${on_scene_raw})-EXTRACT(EPOCH FROM ${on_route_raw}) ;;
  }

  dimension: in_queue_time_seconds {
    type: number
    hidden: yes
    description: "The number of seconds between requested time and accepted time"
    sql: EXTRACT(EPOCH FROM ${accept_raw})-EXTRACT(EPOCH FROM ${requested_raw}) ;;
  }

  dimension: time_to_call_seconds {
    type: number
    hidden: yes
    value_format: "0"
    description: "The number of seconds between requested time and call time"
    sql: EXTRACT(EPOCH FROM ${call_time_raw})-EXTRACT(EPOCH FROM ${requested_raw}) ;;
  }

  dimension: time_to_call_minutes {
    type: number
    hidden: yes
    value_format: "0.0"
    description: "The number of minutes between requested time and call time"
    sql: ${time_to_call_seconds}/60.0 ;;
  }

  dimension: assigned_time_seconds {
    type: number
    hidden: yes
    description: "The number of seconds between accepted time and on-route time"
    sql: EXTRACT(EPOCH FROM ${on_route_raw})-EXTRACT(EPOCH FROM ${accept_raw}) ;;
  }

  dimension: num_assignments {
    type: number
    description: "The number of times the patient was assigned to a clinical team"
    sql: ${TABLE}.count_assignments ;;
  }

  dimension: on_scene_time_minutes {
    type: number
    group_label: "Care Delivery Times"
    description: "The number of minutes between complete time and on scene time"
    sql: CASE
          WHEN ABS((EXTRACT(EPOCH FROM ${complete_raw})-EXTRACT(EPOCH FROM ${on_scene_raw}))::float/60.0) < 241
          THEN (EXTRACT(EPOCH FROM ${complete_raw})-EXTRACT(EPOCH FROM ${on_scene_raw}))::float/60.0
          ELSE NULL
        END ;;
    value_format: "0.00"
  }

  dimension: created_to_resolved_minutes {
    type: number
    group_label: "Care Delivery Times"
    description: "The number of minutes between created time and archived time"
    sql: (EXTRACT(EPOCH FROM ${archive_raw})-EXTRACT(EPOCH FROM ${created_raw}))::float/60.0 ;;
    value_format: "0.00"
  }

  dimension: accepted_to_resolved_minutes {
    type: number
    group_label: "Care Delivery Times"
    description: "The number of minutes between accepted time and archived time"
    sql: CASE
          WHEN ABS((EXTRACT(EPOCH FROM ${archive_raw})-EXTRACT(EPOCH FROM ${accept_raw}))::float/60.0) < 241
          THEN (EXTRACT(EPOCH FROM ${archive_raw})-EXTRACT(EPOCH FROM ${accept_raw}))::float/60.0
          ELSE NULL
        END ;;
    value_format: "0.00"
  }

  dimension: created_to_on_scene_minutes {
    type: number
    group_label: "Care Delivery Times"
    description: "The number of minutes between care request created time and on scene time"
    sql: EXTRACT(EPOCH FROM ${on_scene_raw})/60 -EXTRACT(EPOCH FROM ${created_raw})/60 ;;
  }

  dimension: accepted_initial_to_on_scene_minutes {
    type: number
    group_label: "Care Delivery Times"
    description: "The number of minutes between when a care request is accepted time and on scene time"
    sql: EXTRACT(EPOCH FROM ${on_scene_raw})/60 -EXTRACT(EPOCH FROM ${accept_initial_raw})/60 ;;
  }

  dimension: on_scene_time_tier {
    type: tier
    group_label: "Care Delivery Times"
    description: "On scene time, grouped in bins of 10 minutes"
    tiers: [10,20,30,40,50,60,70,80,90,100]
    style: integer
    sql: ${on_scene_time_minutes} ;;
  }

  dimension: mins_on_scene_predicted {
    type: number
    group_label: "On Scene Predictions"
    sql: ${TABLE}.mins_on_scene_predicted::int ;;
  }

  dimension: actual_minus_pred_on_scene {
    type: number
    group_label: "On Scene Predictions"
    sql: ${on_scene_time_minutes}::float - ${mins_on_scene_predicted}::float ;;
  }

  dimension: real_minus_pred_tier {
    type: tier
    group_label: "On Scene Predictions"
    tiers: [-60,-50,-40,-30,-20,-10,0,10,20,30,40,50,60]
    style: integer
    sql: ${actual_minus_pred_on_scene} ;;
  }

  dimension: on_scene_time_tier_predicted {
    type: tier
    group_label: "On Scene Predictions"
    tiers: [10,20,30,40,50,60,70,80,90,100]
    style: integer
    sql: ${mins_on_scene_predicted} ;;
  }

  dimension: shift_team_id_initial {
    type: number
    group_label: "IDs"
    description: "The shift team ID of the team initially assigned to the care request"
    sql: ${TABLE}.shift_team_id_initial ;;
  }

  dimension: shift_team_initial {
    type: string
    description: "The name of the shift initially assigned to the care request"
    sql: ${TABLE}.shift_team_initial ;;
  }

  measure: app_months_of_experience {
    type: number
    sql: EXTRACT('year' FROM age(MIN(${on_scene_date})::date, ${shift_details.first_shift_date}::date))*12 +
      EXTRACT('month'FROM age(MIN(${on_scene_date})::date, ${shift_details.first_shift_date}::date)) ;;
  }

  dimension: on_scene_time_30min_or_less {
    type: yesno
    group_label: "Care Delivery Times"
    description: "A flag indicating the on scene time was less than 30 minutes"
    sql: ${on_scene_time_minutes} < 30.0 ;;
  }

  dimension: auto_assigned_initial {
    type: string
    group_label: "Optimizer Details"
    description: "A flag indicating the care request was initially auto-assigned"
    sql: ${TABLE}.auto_assigned_initial ;;
  }

  dimension: reassignment_reason_initial {
    type: string
    group_label: "Optimizer Details"
    description: "The initial reassignment reason logged by the CSC"
    sql: ${TABLE}.reassignment_reason_initial ;;
  }

  dimension: auto_assignment_overridden {
    type: yesno
    group_label: "Optimizer Details"
    sql: ${auto_assigned_initial} = 'true' AND ${auto_assigned_final} = 'false' ;;
  }

  dimension: reassignment_reason_other_initial {
    type: string
    group_label: "Optimizer Details"
    description: "The secondary initial reassignment reason logged by the CSC"
    sql: ${TABLE}.reassignment_reason_other_initial ;;
  }

  dimension: auto_assigned_final {
    type: string
    group_label: "Optimizer Details"
    description: "A flag indicating the care request was auto-assigned (String)"
    sql: ${TABLE}.auto_assigned_final ;;
  }

  dimension: auto_assigned_flag {
    type: yesno
    group_label: "Optimizer Details"
    description: "A flag indicating the care request was auto-assigned (Boolean)"
    sql: ${TABLE}.auto_assigned_final = 'true' ;;
  }

  dimension: board_optimizer_assigned {
    type: yesno
    group_label: "Optimizer Details"
    sql: ${auto_assigned_final} = 'false' AND ${accept_employee_user_id} IN (7419,14804,10941,24564,20171,13134,6620,12582) ;;
  }

  dimension: reassignment_reason_final {
    type: string
    group_label: "Optimizer Details"
    description: "The reassignment reason logged by the CSC"
    sql: ${TABLE}.reassignment_reason_final ;;
  }


  dimension: reassignment_reason_other_final {
    type: string
    group_label: "Optimizer Details"
    description: "The reassignment reason logged by the CSC"
    sql: ${TABLE}.reassignment_reason_other_final ;;
  }

  dimension: drive_time_minutes {
    type: number
    group_label: "Care Delivery Times"
    description: "The number of minutes between on-route time and on-scene time"
    sql: (EXTRACT(EPOCH FROM ${on_scene_raw})-EXTRACT(EPOCH FROM ${on_route_raw}))::float/60.0 ;;
    value_format: "0.0"
  }


  dimension: drive_time_minutes_coalesce {
    type: number
    group_label: "Care Delivery Times"
    description: "google drive time if available, otherwise regular drive time"
    sql: coalesce(${drive_time_minutes_google}, ${drive_time_minutes});;
    value_format: "0.0"
  }


  measure: total_drive_time_minutes {
    type: sum_distinct
    group_label: "Care Delivery Times"
    description: "The number of minutes between on-route time and on-scene time"
    sql_distinct_key: ${care_request_id} ;;
    sql: ${drive_time_minutes};;
    value_format: "0.0"
  }

  measure: total_drive_time_minutes_coalesce {
    type: sum_distinct
    group_label: "Care Delivery Times"
    description: "google drive time if available, otherwise regular drive time"
    sql_distinct_key: ${care_request_id} ;;
    sql: ${drive_time_minutes_coalesce};;
    value_format: "0.0"
  }

  measure: average_drive_time_minutes_coalesce_complete {
    type: number
    group_label: "Care Delivery Times"
    description: "google drive time if available, otherwise regular drive time divided by complete visits"
    sql: case when ${care_request_flat.complete_count_no_arm_advanced}>0 then ${total_drive_time_minutes_coalesce}::float/${care_request_flat.complete_count_no_arm_advanced}::float else null end;;
    value_format: "0.0"
  }

  measure: average_on_scene_minutes_complete {
    type: number
    group_label: "Care Delivery Times"
    description: "On scene time divided by complete visits"
    sql: case when ${care_request_flat.complete_count_no_arm_advanced}>0 then ${total_on_scene_time_minutes}::float/${care_request_flat.complete_count_no_arm_advanced}::float else null end;;
    value_format: "0.0"
  }


  dimension: drive_time_seconds_google {
    type: number
    hidden: yes
    group_label: "Care Delivery Times"
    sql: ${TABLE}.drive_time_seconds ;;
  }

  dimension: drive_time_minutes_google_initial {
    type: number
    group_label: "Care Delivery Times"
    description: "The initial Google drive time for the care request"
    sql: ${TABLE}.drive_time_seconds::float / 60.0 ;;
    value_format: "0.00"
  }

  dimension: drive_time_minutes_google {
    type: number
    group_label: "Care Delivery Times"
    sql: ${TABLE}.drive_time_seconds::float / 60.0 ;;
    value_format: "0.00"
  }

  dimension: initial_drive_time_minutes_google {
    description: "The Google drive time of the care team that was initially assigned"
    type: number
    group_label: "Care Delivery Times"
    sql: ${TABLE}.drive_time_seconds_initial::float / 60.0 ;;
    value_format: "0.00"
  }

  dimension: google_drive_time_tier {
  type: tier
  group_label: "Care Delivery Times"
  description: "Google drive time minutes in groups of 5"
  tiers: [0,5,10,15,20,25,30,35,40,45,50]
  style: integer
  sql: ${drive_time_minutes_google} ;;
  }

  measure:  average_drive_time_minutes_google {
    type: average_distinct
    group_label: "Care Delivery Times"
    description: "The average drive time from Google in minutes"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${drive_time_minutes_google} ;;
  }

  measure: total_drive_time_minutes_google {
    type: sum_distinct
    group_label: "Care Delivery Times"
    description: "The sum of drive time from Google in minutes"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${drive_time_minutes_google} ;;
  }

  dimension: under_20_minute_drive_time {
    type: yesno
    group_label: "Care Delivery Times"
    sql: ${drive_time_minutes_google} <= 20.0 ;;
  }

  dimension: is_reasonable_drive_time {
    type: yesno
    hidden: yes
    sql: ${drive_time_seconds} > 299 AND ${drive_time_seconds} < 14401;;
  }

  dimension: in_queue_time_minutes {
    type: number
    group_label: "Care Delivery Times"
    description: "The number of minutes between requested time and accepted time"
    sql: (EXTRACT(EPOCH FROM ${accept_raw})-EXTRACT(EPOCH FROM ${requested_raw}))::float/60.0 ;;
    value_format: "0.00"
  }

  dimension: is_reasonable_in_queue_time {
    type: yesno
    hidden: yes
    sql: ${in_queue_time_minutes} < 240  ;;
  }

  dimension: assigned_time_minutes {
    type: number
    group_label: "Care Delivery Times"
    description: "The number of minutes between accepted time and on-route time"
    sql: (EXTRACT(EPOCH FROM ${on_route_raw})-EXTRACT(EPOCH FROM ${accept_raw}))::float/60.0;;
    value_format: "0.00"
  }

  dimension: is_reasonable_assigned_time {
    type: yesno
    hidden: yes
    sql: ${assigned_time_minutes} < 720  ;;
  }

  dimension: is_reasonable_on_scene_time {
    type: yesno
    hidden: yes
    sql: ${on_scene_time_seconds} > 299 AND ${on_scene_time_seconds} < 14401 ;;
  }

  dimension: accept_employee_first_name {
    description: "The first name of the user who accepted the patient"
    type: string
    sql: initcap(${TABLE}.accept_employee_first_name) ;;
  }

  dimension: accept_employee_last_name {
    description: "The last name of the user who accepted the patient"
    type: string
    sql: initcap(${TABLE}.accept_employee_last_name) ;;
  }

  dimension: accept_employee_full_name {
    type: string
    sql: concat(${accept_employee_first_name}, ' ', ${accept_employee_last_name}) ;;
  }

  dimension: resolved_employee_full_name {
    type: string
    sql: concat(${resolved_employee_first_name}, ' ', ${resolved_employee_last_name}) ;;
  }

  dimension: accept_employee_user_id {
    description: "The user ID of the user who accepted the patient"
    type: number
    sql: ${TABLE}.accept_employee_user_id ;;
  }

  dimension: resolved_employee_first_name {
    description: "The first name of the user who resolved the care request"
    type: string
    sql: ${TABLE}.resolved_employee_first_name ;;
  }

  dimension: resolved_employee_last_name {
    description: "The last name of the user who resolved the care request"
    type: string
    sql: ${TABLE}.resolved_employee_last_name ;;
  }

  dimension: resolved_employee_role {
    description: "The role of the employee who resolved the care request"
    type: string
    sql: ${TABLE}.resolved_role ;;
  }


  dimension: accepted_patient {
    type: yesno
    hidden: yes
    sql: ${accept_date} IS NOT NULL ;;
  }

  dimension: accepted_or_scheduled {
    label: "Accepted, Scheduled (Acute-Care) or Booked Resolved"
    type: yesno
    sql: ${accepted_patient} or (${scheduled_visit} and not ${pafu_or_follow_up}) or ${booked_resolved};;
  }

  measure: count_accepted_patients {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: accepted_patient
      value: "yes"
    }
  }

  measure:  average_drive_time_seconds{
    type: average_distinct
    description: "The average seconds between on-route time and on-scene time"
    value_format: "0"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${drive_time_seconds} ;;
    filters: {
      field: is_reasonable_drive_time
      value: "yes"
    }
  }

  measure:  average_in_queue_time_seconds{
    type: average_distinct
    description: "The average seconds between requested time and accepted time"
    value_format: "0"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${in_queue_time_seconds} ;;
    filters: {
      field: is_reasonable_in_queue_time
      value: "yes"
    }
  }

  measure:  average_assigned_time_seconds{
    type: average_distinct
    description: "The average seconds between between accepted time and on-route time"
    value_format: "0"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${assigned_time_seconds} ;;
    filters: {
      field: is_reasonable_assigned_time
      value: "yes"
    }
  }

  measure:  average_drive_time_minutes{
    type: average_distinct
    description: "The average minutes between on-route time and on-scene time"
    value_format: "0"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${drive_time_minutes} ;;
    filters: {
      field: is_reasonable_drive_time
      value: "yes"
    }
  }

  measure:  average_drive_time_minutes_coalesce{
    type: average_distinct
    description: "The average minutes between on-route time and on-scene time"
    value_format: "0"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${drive_time_minutes_coalesce} ;;
  }

  measure:  median_drive_time_minutes{
    type: median_distinct
    description: "The median number of minutes between on-route time and on-scene time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${drive_time_minutes} ;;
  }

  measure:  average_in_queue_time_minutes{
    type: average_distinct
    description: "The average minutes between requested time and accepted time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${in_queue_time_minutes} ;;
    filters: {
      field: is_reasonable_in_queue_time
      value: "yes"
    }
  }

  measure:  average_time_to_call_minutes{
    type: average_distinct
    label: "Average Time to Submition of Caller Information in Dashboard"
    description: "The average minutes between requested time and accepted time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${time_to_call_minutes} ;;
  }

  measure:  median_time_to_call_minutes{
    type: median_distinct
    label: "Median Time to Submition of Caller Information in Dashboard"
    description: "The average minutes between requested time and accepted time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${time_to_call_minutes} ;;
  }


  dimension: initial_in_queue_time_minutes {
    type: number
    description: "The number of minutes between requested time and accepted time"
    sql: (EXTRACT(EPOCH FROM ${accept_initial_raw})-EXTRACT(EPOCH FROM ${requested_raw}))::float/60.0 ;;
    value_format: "0.00"
  }


  measure:  average_initial_in_queue_time_minutes{
    type: average_distinct
    description: "The average minutes between requested time and accepted time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${initial_in_queue_time_minutes} ;;
    filters: {
      field: is_reasonable_in_queue_time
      value: "yes"
    }
  }
  measure:  average_assigned_time_minutes{
    type: average_distinct
    description: "The average minutes between accepted time and on-route time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${assigned_time_minutes} ;;
    filters: {
      field: is_reasonable_assigned_time
      value: "yes"
    }
  }

  measure:  average_on_scene_time_minutes{
    type: average_distinct
    description: "The average minutes between complete time and on scene time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${on_scene_time_minutes} ;;
    filters: {
      field: is_reasonable_on_scene_time
      value: "yes"
    }
  }

  measure:  average_on_scene_time_predicted {
    type: average_distinct
    description: "The average predicted minutes between complete time and on scene time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${mins_on_scene_predicted} ;;
  }

  measure:  average_created_to_resolved_minutes{
    type: average_distinct
    description: "The average minutes between created time and archive time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${created_to_resolved_minutes} ;;
  }

  measure:  average_accepted_to_initial_eta_minutes{
    type: average_distinct
    description: "The average minutes between accepted time and initial ETA"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${accepted_to_initial_eta_minutes} ;;
  }

  measure:  average_created_to_on_scene_minutes{
    type: average_distinct
    description: "The average minutes between created time and on on-scene time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${created_to_on_scene_minutes} ;;
  }

  measure: average_accepted_to_resolved_minutes{
    type: average_distinct
    description: "The average minutes between accepted time and Resolved Time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${accepted_to_resolved_minutes} ;;
  }

  measure: average_accepted_initial_to_on_scene_minutes{
    type: average_distinct
    description: "The average minutes between the initial accepted time and On-Scene Time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${accepted_initial_to_on_scene_minutes} ;;
  }



  measure:  total_on_scene_time_minutes{
    type: sum_distinct
    description: "The sum of minutes between complete time and on scene time"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${on_scene_time_minutes} ;;
    filters: {
      field: is_reasonable_on_scene_time
      value: "yes"
    }
  }

  measure:  total_predicted_on_scene_time_minutes{
    type: sum_distinct
    description: "The sum of predicted minutes on scene"
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${mins_on_scene_predicted} ;;
  }

#   Need to get this working for histograms
   parameter: bucket_size {
     default_value: "10"
     type: number
   }

   dimension: assigned_time_dynamic_sort_field {
     sql:
       ${assigned_time_minutes} - mod(CAST(${assigned_time_minutes} AS INT),{% parameter bucket_size %});;
     type: number
     hidden: yes
   }

   dimension: assigned_time_dynamic_bucket  {
     sql:
         concat(${assigned_time_minutes} - mod(CAST(${assigned_time_minutes} AS INT),{% parameter bucket_size %}),
           '-', ${assigned_time_minutes} - mod(CAST(${assigned_time_minutes} AS INT),{% parameter bucket_size %} + {% parameter bucket_size %})
       ;;
     order_by_field: assigned_time_dynamic_sort_field
   }

  measure: average_wait_time_total {
    description: "Total patient wait time: the average minutes between requested time and on-scene time"
    type: number
    value_format: "0"
    sql: ${average_in_queue_time_seconds} + ${average_assigned_time_seconds} + ${average_drive_time_seconds} ;;
  }

  dimension: wait_time_greater_than_3_hours {
    type: yesno
    description: "A flag indicating that total patient wait time is greater than 3 hours"
    sql: (${in_queue_time_seconds} + ${assigned_time_seconds} + ${drive_time_seconds})/3600 >= 3 ;;
  }

  measure: average_wait_time_total_pre_logistics {
    description: "Total patient wait time: the average minutes between requested time and on-scene time"
    type: average_distinct
    value_format: "0"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${in_queue_time_seconds} + ${assigned_time_seconds} + ${drive_time_seconds} ;;
    filters: {
      field: auto_assigned_flag
      value: "no"
    }
    filters: {
      field: is_reasonable_drive_time
      value: "yes"
    }
    filters: {
      field: is_reasonable_in_queue_time
      value: "yes"
    }
    filters: {
      field: is_reasonable_assigned_time
      value: "yes"
    }
  }

  measure: average_wait_time_total_post_logistics {
    description: "Total patient wait time: the average minutes between requested time and on-scene time"
    type: average_distinct
    value_format: "0"
    sql_distinct_key: concat(${care_request_id}) ;;
    sql: ${in_queue_time_seconds} + ${assigned_time_seconds} + ${drive_time_seconds} ;;
    filters: {
      field: auto_assigned_flag
      value: "yes"
    }
    filters: {
      field: is_reasonable_drive_time
      value: "yes"
    }
    filters: {
      field: is_reasonable_in_queue_time
      value: "yes"
    }
    filters: {
      field: is_reasonable_assigned_time
      value: "yes"
    }
  }

  dimension: pre_post {
    type: yesno
    description: "A flag indicating the Denver shift-ladder experiment (4/2/2018 - 4/13/2018)"
    sql: (DATE(${requested_raw}) BETWEEN '2018-04-02' AND '2018-04-13') ;;
  }

  dimension: cc_pre_post {
    type: yesno
    description: "A flag indicating the credit card fix was put into production"
    sql: (DATE(${on_scene_raw}) > '2018-04-13') ;;
  }

  dimension: market_id {
    type: number
    hidden: yes
    sql: ${TABLE}.market_id ;;
  }

  dimension: archive_comment {
    type: string
    description: "The CSC comment provided when a care request is archived"
    sql: ${TABLE}.archive_comment ;;
  }

  dimension: reorder_reason {
    type: string
    description: "The reorder reason"
    sql: ${TABLE}.reorder_reason ;;
  }

  dimension: reassigned_or_reordered {
    type: yesno
    description: "A flag indicating the care request was reassigned OR re-ordered"
    sql: ${reassignment_reason_other_final} IS NOT NULL OR ${reorder_reason} IS NOT NULL ;;
  }

  dimension: reordered_visit {
    type: yesno
    sql: ${reorder_reason} IS NOT NULL ;;
  }

  measure: count_reordered_care_requests {
    description: "Count of care requests that were reordered by CSC"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: reordered_visit
      value: "yes"
    }
  }

  measure: count_reassigned_reordered_care_requests {
    description: "Count of care requests that were reassigned or reordered by CSC"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: reassigned_or_reordered
      value: "yes"
    }
    filters: {
      field: care_requests.billable_est
      value: "yes"
    }
  }

  measure: count_complete_visits_weekends_or_after_hours {
    description: "Count of billable est on weekends or after 3 PM"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: weekend_after_3pm
      value: "yes"
    }
    filters: {
      field: care_requests.billable_est
      value: "yes"
    }
  }

  dimension: complete_comment {
    type: string
    sql: ${TABLE}.complete_comment ;;
  }

  dimension: followup_3day_result {
    type: string
    description: "The 3-day follow-up call result"
    sql: TRIM(${TABLE}.followup_3day_result) ;;
  }

  dimension: followup_3day {
    type: yesno
    description: "A flag indicating the 3-day follow-up call was completed"
    sql: ${complete_date} IS NOT NULL AND
    ${followup_3day_result} is NOT NULL AND ${followup_3day_result} != 'patient_called_but_did_not_answer' ;;
  }

  dimension: followup_3day_id {
    type: number
    sql: ${TABLE}.followup_3day_id ;;
  }

  dimension_group: day3_followup {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.day3_followup_date ;;
  }

  dimension_group: eta {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week,
      day_of_month
    ]
    sql: ${TABLE}.eta_date ;;
  }

  dimension_group: eta_range_start {
    type: time
    description: "The initial ETA range start time that was given to the patient"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time
    ]
    sql: ${TABLE}.initial_eta_start ;;
  }

  dimension_group: eta_range_end {
    type: time
    description: "The initial ETA range end time that was given to the patient"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time
    ]
    sql: ${TABLE}.initial_eta_end ;;
  }

  dimension: eta_window {
    description: "The ETA range given to the patient for care"
    sql: (EXTRACT(EPOCH FROM ${eta_range_end_raw}) - EXTRACT(EPOCH FROM ${eta_range_start_raw}))/3600 ;;
    value_format: "0.0"
    group_label: "ETAs"
  }

  dimension_group: initial_eta {
    type: time
    description: "The initial ETA that was calculated for the patient"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week,
      day_of_month
    ]
    sql: ${TABLE}.initial_eta ;;
  }

  dimension: bounceback_3day {
    type: yesno
    sql: ${followup_3day_result} LIKE '%same_complaint%' ;;
  }

  dimension: raw_followup_14day_result {
    type: string
    description: "The 14-day follow-up result"
    sql: TRIM(${TABLE}.followup_14day_result) ;;
  }


  dimension: followup_14day_result {
    type: string
    description: "The 14-day follow-up result (or 30 day result if the 14 day result is NULL and the 30 day is populated)"
    sql: CASE
    WHEN (TRIM(${raw_followup_14day_result}) IS NULL OR  TRIM(${raw_followup_14day_result}) = 'no_hie_data' OR TRIM(${raw_followup_14day_result}) = '')
    AND (TRIM(${raw_followup_30day_result}) IS NOT NULL AND  TRIM(${raw_followup_30day_result}) != 'no_hie_data' AND TRIM(${raw_followup_30day_result}) != '')
    THEN TRIM(${raw_followup_30day_result})
    ELSE TRIM(${raw_followup_14day_result})
    END;;

  }

  dimension: bounceback_14day {
    type: yesno
    sql: ${followup_14day_result} LIKE '%same_complaint%' OR ${bounceback_3day} ;;
  }


  dimension: bb_14_day_in_sample {
    label: "14-Day Bounce back flag, removing any bouncebacks without a 30 day followup"
    type: yesno
    sql: ((${bounceback_3day} AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL)
         OR ${followup_14day_result} = 'ed_same_complaint' OR ${followup_14day_result} = 'hospitalization_same_complaint')
    ;;
  }
# AND ${followup_3day_result} != 'REMOVED'
  measure: bb_14_day_count_in_sample {
    label: "14-Day Bounce back Count With No Followups Removed"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: bb_14_day_in_sample
      value: "yes"
    }
  }

  dimension: ed_any_14day_followup_in_sample {
    type: yesno
    sql: ((UPPER(${followup_3day_result}) LIKE 'ED_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'ED_SAME_COMPLAINT') AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL)  OR
      ((UPPER(${followup_3day_result}) LIKE 'ED_DIFFERENT_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'ED_DIFFERENT_COMPLAINT') AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL) ;;
  }

  measure: count_ed_any_14day_followup_in_sample {
    label: "14-Day Any ED (same or different complaint) Bounce back Count With No Followups Removed"
    type: count_distinct
    sql: ${care_request_id} ;;

    filters: {
      field: ed_any_14day_followup_in_sample
      value: "yes"
    }
  }

  dimension: hospitalization_any_14day_followup_in_sample {
    type: yesno
    sql: ((UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT') AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL)  OR
      ((UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT') AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL) ;;
  }

  measure: count_hospitalization_any_14day_followup_in_sample {
    label: "14-Day Any Hospitalization (same or different complaint) Bounce back Count With No Followups Removed"
    type: count_distinct
    sql: ${care_request_id} ;;

    filters: {
      field: hospitalization_any_14day_followup_in_sample
      value: "yes"
    }
  }

  dimension: raw_followup_30day_result {
    type: string
    description: "The 30-day follow-up result"
    sql: TRIM(${TABLE}.followup_30day_result) ;;
  }

  dimension: followup_30day_result {
    type: string
    description: "The 30-day follow-up result (or the 14 day result if the 30 day result is NULL and the 14 day is populated)"
    sql: CASE
    WHEN (TRIM(${raw_followup_30day_result}) IS NULL OR TRIM(${raw_followup_30day_result}) = 'no_hie_data' OR TRIM(${raw_followup_30day_result}) = '')
    AND (TRIM(${raw_followup_14day_result}) IS NOT NULL AND  TRIM(${raw_followup_14day_result}) != 'no_hie_data' AND TRIM(${raw_followup_14day_result}) != '')
    THEN TRIM(${raw_followup_14day_result})
    ELSE TRIM(${raw_followup_30day_result})
    END;;
  }


  dimension: followup_30day {
    type: yesno
    description: "A flag indicating the 14/30-day follow-up was completed (also includes 3 day bouncebacks)"
    sql: ${complete_date} IS NOT NULL AND
    ((${followup_30day_result} IS NOT NULL AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} != '') OR
    ${bounceback_3day} OR ${bounceback_14day}) ;;
  }

  dimension: followup_30day_sample_only {
    type: yesno
    description: "A flag indicating the 14/30-day follow-up was completed"
    sql: ${complete_date} IS NOT NULL AND
          (${followup_30day_result} IS NOT NULL AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} != '')  ;;
  }

  measure: count_followup_30day_sample_only {
    type: count_distinct
    sql: ${care_request_id}    ;;
    filters: {
      field: followup_30day_sample_only
      value: "yes"
    }
  }

  # Add 3 or 30 day followup measures
  dimension: followup_3day_or_30day {
    type: yesno
    description: "A flag indicating that either the 3 or 30-day follow-up was completed"
    sql: ${complete_date} IS NOT NULL AND
          (${followup_30day_result} IS NOT NULL AND ${followup_30day_result} != 'no_hie_data') OR
          (${followup_3day}) ;;
  }

  measure: count_3_or_30day_followups {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: followup_3day_or_30day
      value: "yes"
    }
  }
  # End 3 or 30 day followup measures

  #   Add consolidated dimensions and measures to combine 3, 14 and 30 day Followup results to a single value for inclusive reporting

  dimension: followup_results_consolidated {
    type: string
    description: "Consolidated followup results from 3, 14 and 30 day results. This returns a single value from the three possible results based on the hierarchy of hospitalization_same, ed_same, Hospitalization_differing, Ed_differing, No_ed_hosptilization, and NULL'"
    sql: CASE
      WHEN UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' THEN 'hospitalization_same_complaint'
      WHEN UPPER(${followup_3day_result}) LIKE 'ED_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'ED_SAME_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'ED_SAME_COMPLAINT' THEN 'ed_same_complaint'
      WHEN UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT' THEN 'hospitalization_different_complaint'
      WHEN UPPER(${followup_3day_result}) LIKE 'ED_DIFFERENT_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'ED_DIFFERENT_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'ED_DIFFERENT_COMPLAINT' THEN 'ed_different_complaint'
      WHEN (UPPER(${followup_3day_result}) LIKE 'NO_ED-HOSPITALIZATION' OR UPPER(${followup_3day_result}) LIKE 'NO ED/HOSPITALIZATION') OR (UPPER(${followup_14day_result}) LIKE 'NO_ED-HOSPITALIZATION' OR UPPER(${followup_14day_result}) LIKE 'NO ED/HOSPITALIZATION') OR (UPPER(${followup_30day_result}) LIKE 'NO_ED-HOSPITALIZATION' OR UPPER(${followup_30day_result}) LIKE 'NO ED/HOSPITALIZATION') THEN 'no_ed-hospitalization'
      ELSE NULL
      END
      ;;
  }

  dimension: followup_results_3_14day_bounceback {
    description: "Consolidated followup results from 3 and 14 day results with 14 day followup segmented into separate categories. This returns a single value from the three possible results based on the hierarchy of hospitalization_same, ed_same, Hospitalization_differing, Ed_differing, No_ed_hosptilization, and NULL'"
    sql: CASE
      WHEN ((UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT')) AND (${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL) THEN 'Hospitilization Same Complaint with 30 Day Followup'
      WHEN ((UPPER(${followup_3day_result}) LIKE 'ED_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'ED_SAME_COMPLAINT' )) AND (${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL) THEN 'ED Same Complaint with 30 Day Followup'

      WHEN UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' THEN 'Hospitilization Same Complaint NO 30 Day Followup'
      WHEN UPPER(${followup_3day_result}) LIKE 'ED_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'ED_SAME_COMPLAINT' THEN 'ED Same Complaint NO 30 Day Followup'
      WHEN UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT' THEN 'Hospitilization Different Complaint'
      WHEN UPPER(${followup_3day_result}) LIKE 'ED_DIFFERENT_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'ED_DIFFERENT_COMPLAINT' THEN 'ED Different Complaint'
      WHEN (UPPER(${followup_3day_result}) LIKE 'NO_ED-HOSPITALIZATION' OR UPPER(${followup_3day_result}) LIKE 'NO ED/HOSPITALIZATION') OR (UPPER(${followup_14day_result}) LIKE 'NO_ED-HOSPITALIZATION' OR UPPER(${followup_14day_result}) LIKE 'NO ED/HOSPITALIZATION') THEN 'No Hospilization/ED'
      ELSE NULL
      END
      ;;
  }

  dimension: followup_results_3_14_30day_bounceback {
  description: "Consolidated followup results from 3, 14 and 30 day results with 30 day followup segmented into separate categories. This returns a single value from the three possible results based on the hierarchy of hospitalization_same, ed_same, Hospitalization_differing, Ed_differing, No_ed_hosptilization, and NULL'"
    sql: CASE
      WHEN ((UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT') AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL) THEN 'Hospitilization Same Complaint with 30 Day Followup'
      WHEN ((UPPER(${followup_3day_result}) LIKE 'ED_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'ED_SAME_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'ED_SAME_COMPLAINT') AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL) THEN 'ED Same Complaint with 30 Day Followup'

      WHEN UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' THEN 'Hospitilization Same Complaint NO 30 Day Followup'
      WHEN UPPER(${followup_3day_result}) LIKE 'ED_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'ED_SAME_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'ED_SAME_COMPLAINT' THEN 'ED Same Complaint NO 30 Day Followup'
      WHEN UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT' THEN 'Hospitilization Different Complaint'
      WHEN UPPER(${followup_3day_result}) LIKE 'ED_DIFFERENT_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'ED_DIFFERENT_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'ED_DIFFERENT_COMPLAINT' THEN 'ED Different Complaint'
      WHEN (UPPER(${followup_3day_result}) LIKE 'NO_ED-HOSPITALIZATION' OR UPPER(${followup_3day_result}) LIKE 'NO ED/HOSPITALIZATION') OR (UPPER(${followup_14day_result}) LIKE 'NO_ED-HOSPITALIZATION' OR UPPER(${followup_14day_result}) LIKE 'NO ED/HOSPITALIZATION') OR (UPPER(${followup_30day_result}) LIKE 'NO_ED-HOSPITALIZATION' OR UPPER(${followup_30day_result}) LIKE 'NO ED/HOSPITALIZATION') THEN 'No Hospilization/ED'
      ELSE NULL
      END
      ;;
  }

# WHEN (UPPER(${followup_3day_result}) LIKE 'NO_HIE_DATA' OR UPPER(${followup_3day_result}) LIKE 'PATIENT_CALLED_BUT_DID_NOT_ANSWER') OR (UPPER(${followup_14day_result}) LIKE 'NO_HIE_DATA' OR UPPER(${followup_14day_result}) LIKE 'PATIENT_CALLED_BUT_DID_NOT_ANSWER') OR (UPPER(${followup_30day_result}) LIKE 'NO_HIE_DATA' OR UPPER(${followup_30day_result}) LIKE 'PATIENT_CALLED_BUT_DID_NOT_ANSWER') THEN 'contact_attempt_unsucessful'
# End consolidated dimensions and measures

  dimension: bb_30_day_in_sample {
    label: "30-Day Bounce back flag, removing any bouncebacks without a 30 day followup"
    type: yesno
    sql: (((${bounceback_3day} OR ${bounceback_14day}) AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL)
         OR ${followup_30day_result} = 'ed_same_complaint' OR ${followup_30day_result} = 'hospitalization_same_complaint')
      ;;
  }
# AND ${followup_3day_result} != 'REMOVED';;
  measure: bb_30_day_count_in_sample {
    label: "30-Day Bounce back Count With No Followups Removed"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: bb_30_day_in_sample
      value: "yes"
    }
  }

  dimension: hospitalization_any_30day_followup_in_sample {
    type: yesno
    sql: ((UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT') AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL)  OR
    ((UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT') AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL) ;;
  }

  measure: count_hospitalization_any_30day_followup_in_sample {
    label: "30-Day Any Hospitalization (same or different complaint) Bounce back Count With No Followups Removed"
    type: count_distinct
    sql: ${care_request_id} ;;

    filters: {
      field: hospitalization_any_30day_followup_in_sample
      value: "yes"
    }
  }

  dimension: hospitalization_same_complaint_30day_followup_in_sample {
    type: yesno
    sql: ((UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT') AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL) ;;
  }

  measure: count_hospitalization_same_complaint_30day_followup_in_sample {
    label: "30-Day Hospitalization Same Complaint Bounce back Count With No Followups Removed"
    type: count_distinct
    sql: ${care_request_id} ;;

    filters: {
      field: hospitalization_same_complaint_30day_followup_in_sample
      value: "yes"
    }
  }

  dimension: ed_any_30day_followup_in_sample {
    type: yesno
    sql: ((UPPER(${followup_3day_result}) LIKE 'ED_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'ED_SAME_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'ED_SAME_COMPLAINT') AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL)  OR
      ((UPPER(${followup_3day_result}) LIKE 'ED_DIFFERENT_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'ED_DIFFERENT_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'ED_DIFFERENT_COMPLAINT') AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL) ;;
  }

  measure: count_ed_any_30day_followup_in_sample {
    label: "30-Day Any ed (same or different complaint) Bounce back Count With No Followups Removed"
    type: count_distinct
    sql: ${care_request_id} ;;

    filters: {
      field: ed_any_30day_followup_in_sample
      value: "yes"
    }
  }

  dimension: ed_same_complaint_30day_followup_in_sample {
    type: yesno
    sql: ((UPPER(${followup_3day_result}) LIKE 'ED_SAME_COMPLAINT' OR UPPER(${followup_14day_result}) LIKE 'ED_SAME_COMPLAINT' OR UPPER(${followup_30day_result}) LIKE 'ED_SAME_COMPLAINT') AND ${followup_30day_result} != 'no_hie_data' AND ${followup_30day_result} IS NOT NULL) ;;
  }

  measure: count_ed_same_complaint_30day_followup_in_sample {
    label: "30-Day ed Same Complaint Bounce back Count With No Followups Removed"
    type: count_distinct
    sql: ${care_request_id} ;;

    filters: {
      field: ed_same_complaint_30day_followup_in_sample
      value: "yes"
    }
  }

  dimension: no_hie_data {
    type: yesno
    sql: ${complete_date} IS NOT NULL AND (${followup_14day_result} = 'no_hie_data' OR ${followup_30day_result} = 'no_hie_data') ;;
  }

  measure: count_no_hie_data {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: no_hie_data
      value: "yes"
    }
  }

  dimension: bounceback_30day {
    type: yesno
    sql: ${followup_30day_result} LIKE '%same_complaint%' OR ${bounceback_3day} OR ${bounceback_14day} ;;
  }

  measure: count_3day_bb {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: bounceback_3day
      value: "yes"
    }
  }

  dimension: ed_any_3day_followup {
    type: yesno
    sql: UPPER(${followup_3day_result}) LIKE 'ED_SAME_COMPLAINT' OR
      UPPER(${followup_3day_result}) LIKE 'ED_DIFFERENT_COMPLAINT'  ;;
  }

  measure: count_ed_any_3day_followup {
    label: "3-Day Any ED (same or different complaint) Bounce back Count"
    type: count_distinct
    sql: ${care_request_id} ;;

    filters: {
      field: ed_any_3day_followup
      value: "yes"
    }
  }

  dimension: hospitalization_any_3day_followup {
    type: yesno
    sql: UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_SAME_COMPLAINT' OR
      UPPER(${followup_3day_result}) LIKE 'HOSPITALIZATION_DIFFERENT_COMPLAINT' ;;
  }

  measure: count_hospitalization_any_3day_followup {
    label: "3-Day Any Hospitalization (same or different complaint) Bounce back Count With No Followups Removed"
    type: count_distinct
    sql: ${care_request_id} ;;

    filters: {
      field:  hospitalization_any_3day_followup
      value: "yes"
    }
  }


  measure: count_3day_followups {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: followup_3day
      value: "yes"
    }
  }

  measure: count_14day_bb {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: bounceback_14day
      value: "yes"
    }
  }

  measure: count_30day_bb {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: bounceback_30day
      value: "yes"
    }
  }

  measure: count_30day_followups {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: followup_30day
      value: "yes"
    }
  }

  dimension_group: on_route {
    type: time
    description: "The local date and time when the care request team is on-route"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_month
      ]
    sql: ${TABLE}.on_route_date ;;
  }

  dimension_group: first_on_route {
    type: time
    description: "The first local date and time when the shift team went on-route"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.first_on_route_date ;;
  }

  dimension_group: first_accepted {
    type: time
    description: "The first local date and time when the shift team was assigned a care request"
    convert_tz: no
    hidden: yes
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.first_accepted_date ;;
  }

  dimension: accepted_cr_at_shift_start {
    description: "Flag indicating if the shift had an accepted care request time occurring before or equal to the shirt start time"
    type: yesno
    sql: ${first_accepted_raw} <= ${shift_start_raw} ;;
  }

  dimension_group: drive_start {
    type: time
    description: "The on-scene date and time minus the Google drive time"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month
    ]
    sql: ${on_scene_raw} - (${drive_time_seconds_google}::int * INTERVAL '1' second) ;;
  }

  dimension_group: scheduled_care {
    type: time
    description: "The date where we are trying to complete a scheduled care_request"
    convert_tz: no
    timeframes: [
      raw,
      date,
      week,
      month,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.scheduled_care_date ;;
  }

  dimension_group: created {
    type: time
    description: "The local date/time that the care request was created."
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      year,
      day_of_week,
      day_of_week_index,
      day_of_month,
      month_num,
      quarter
    ]
    sql: ${TABLE}.created_date ;;
  }

  dimension_group: scheduled_care_created_coalese {
    type: time
    description: "The local date/time that the care request was created."
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      year,
      day_of_week,
      day_of_week_index,
      day_of_month,
      month_num,
      quarter
    ]
    sql: coalesce(case when ${pafu_or_follow_up} then ${scheduled_care_raw} else null end, ${created_raw}) ;;
  }

  dimension_group: scheduled_or_accepted_coalese {
    group_label: "Scheduled/Accepted/Created Coalese"
    type: time
    description: "The local date/time that the care request was created."
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      year,
      day_of_week,
      day_of_week_index,
      day_of_month,
      month_num,
      quarter
    ]
    sql: coalesce(${scheduled_raw}, ${accept_raw}, ${created_raw}) ;;
  }


  measure: count_distinct_days_created {
    type: count_distinct
    sql_distinct_key: ${created_date} ;;
    sql: ${created_date} ;;

  }

  measure: distinct_days_scheduled_care_created_coalese_date {
    type: count_distinct
    sql_distinct_key: ${scheduled_care_created_coalese_date} ;;
    sql: ${scheduled_care_created_coalese_date} ;;

  }

  measure: count_distinct_days_accepted {
    type: count_distinct
    sql_distinct_key: ${accept_date} ;;
    sql: ${accept_date} ;;

  }

  dimension: time_group_sort {
    type: number
    hidden: yes
    sql: CASE
          WHEN ${created_hour_of_day} BETWEEN 0 AND 8 THEN 1
          WHEN ${created_hour_of_day} BETWEEN 9 AND 10 THEN 2
          WHEN ${created_hour_of_day} BETWEEN 11 AND 12 THEN 3
          WHEN ${created_hour_of_day} BETWEEN 13 AND 14 THEN 4
          WHEN ${created_hour_of_day} BETWEEN 15 AND 16 THEN 5
          WHEN ${created_hour_of_day} BETWEEN 17 AND 18 THEN 6
          WHEN ${created_hour_of_day} BETWEEN 19 AND 24 THEN 7
    ELSE NULL
    END
    ;;
  }

  dimension: created_time_group {
    type: string
    order_by_field: time_group_sort
    description: "Created time of day split into 4 broad groups"
    sql: CASE
          WHEN ${created_hour_of_day} BETWEEN 0 AND 8 THEN '8:59 or Earlier'
          WHEN ${created_hour_of_day} BETWEEN 9 AND 10 THEN '9:00 - 10:59'
          WHEN ${created_hour_of_day} BETWEEN 11 AND 12 THEN '11:00 - 12:59'
          WHEN ${created_hour_of_day} BETWEEN 13 AND 14 THEN '13:00 - 14:59'
          WHEN ${created_hour_of_day} BETWEEN 15 AND 16 THEN '15:00 - 16:59'
          WHEN ${created_hour_of_day} BETWEEN 17 AND 18 THEN '17:00 - 18:59'
          WHEN ${created_hour_of_day} BETWEEN 19 AND 24 THEN '19:00 or Later'
          ELSE NULL
        END
          ;;
  }

  dimension: etc_model_in_place {
    type: yesno
    sql: ${created_raw} >= '2018-03-29'::TIMESTAMP ;;
  }

  measure: distinct_day_of_week {
    type: count_distinct
    sql: ${complete_date};;
  }

  dimension: requested_after_6_pm  {
    type: yesno
    sql: ${created_hour_of_day} >= 18 ;;
  }

  dimension_group: scheduled {
    type: time
    description: "The local date/time that the care request was scheduled."
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.scheduled_date ;;
  }

  dimension: on_route_decimal {
    description: "The local on-route time of day, represented as a decimal (e.g. 10:15 AM = 10.25)"
    type: number
    value_format: "0.00"
    sql: (CAST(EXTRACT(HOUR FROM ${on_route_raw}) AS INT)) +
        ((CAST(EXTRACT(MINUTE FROM ${on_route_raw} ) AS FLOAT)) / 60) ;;
  }

  dimension: drive_start_decimal {
    description: "The Google on-route time of day, represented as a decimal (e.g. 10:15 AM = 10.25)"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${drive_start_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${drive_start_raw} ) AS FLOAT)) / 60) ;;
  }

  dimension_group: on_scene {
    type: time
    description: "The local date/time that the care request team arrived on-scene"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      month_num,
      day_of_week,
      day_of_week_index,
      day_of_month,quarter,
      hour,
      year
      ]
    sql: ${TABLE}.on_scene_date ;;
  }

  dimension_group: call_time {
    type: time
    description: "The local date/time that the care request team arrived on-scene"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      month_num,
      day_of_week,
      day_of_week_index,
      day_of_month,quarter,
      hour,
      year
    ]
    sql: ${TABLE}.caller_date ;;
  }


  measure: max_on_scene {
    type: time
    description: "The local date/time that the care request team arrived on-scene"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      month_num,
      day_of_week,
      day_of_week_index,
      quarter,
      hour,
      year
    ]
    sql: max(${TABLE}.on_scene_date) ;;
  }

  measure: max_created {
    type: time
    description: "The local date/time that the care request team arrived on-scene"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      month_num,
      day_of_week,
      day_of_week_index,
      quarter,
      hour,
      year
    ]
    sql: max(${TABLE}.created_date) ;;
  }

  measure: min_on_scene {
    type: time
    description: "The local date/time that the care request team arrived on-scene"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      month_num,
      day_of_week,
      day_of_week_index,
      day_of_month,quarter,
      hour,
      year
    ]
    sql: min(${TABLE}.on_scene_date) ;;
  }

  dimension_group: first_visit {
    type: time
    description: "The first local date/time that the patient was seen by DispatchHealth"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      month_num,
      day_of_week,
      day_of_week_index,
      day_of_month,
      quarter,
      hour,
      year
    ]
    sql: ${TABLE}.first_on_scene_time ;;
  }

  dimension: within_30_days_first_visit {
    type: yesno
    description: "A flag indicating that the visit is within 30 days of the first visit"
    sql: ${on_scene_raw} <= ${first_visit_raw} + interval '30 day' ;;
  }

  dimension: first_visit_pafu {
    label: "First Visit Bridge Care Visit"
    type: yesno
    description: "A flag indicating that the first visit is a post-acute follow up"
    sql: ${first_visit_raw} IS NOT NULL AND ${care_requests.post_acute_follow_up} ;;
  }


  dimension: first_half_of_month_on_scene {
    type: yesno
    sql: ${on_scene_day_of_month} <= 15 ;;
  }

  dimension: pg_tz {
    type: string
    sql: ${TABLE}.pg_tz ;;
  }

  dimension_group: on_scene_mountain {
    type: time
    description: "The mountain time that the care request team arrived on-scene"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      month_num,
      day_of_week,
      day_of_week_index,
      day_of_month,quarter,
      hour
    ]
    sql: ${TABLE}.on_scene_date AT TIME ZONE ${pg_tz} AT TIME ZONE 'US/Mountain' ;;
  }

  dimension_group: accept_mountain_intial {
    type: time
    description: "The mountain time that the care request team arrived on-scene"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      month_num,
      day_of_week,
      day_of_week_index,
      day_of_month,quarter,
      hour
    ]
    sql: ${TABLE}.accept_date_initial AT TIME ZONE ${pg_tz} AT TIME ZONE 'US/Mountain' ;;
  }

  dimension_group: accept_mountain {
    type: time
    description: "The mountain time that the care request team arrived on-scene"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      month_num,
      day_of_week,
      day_of_week_index,
      day_of_month,quarter,
      hour
    ]
    sql: ${TABLE}.accept_date AT TIME ZONE ${pg_tz} AT TIME ZONE 'US/Mountain' ;;
  }

  dimension_group: created_mountain {
    type: time
    description: "The mountain time that the care request team arrived on-scene"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      month_num,
      day_of_week,
      day_of_week_index,
      day_of_month,quarter,
      hour
    ]
    sql: ${TABLE}.created_date AT TIME ZONE ${pg_tz} AT TIME ZONE 'US/Mountain' ;;
  }



  dimension_group: accept {
    type: time
    description: "The local date/time that the care request was accepted.
                  This is also used as a surrogate for when the care team is assigned."
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      minute,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_month,
      day_of_week
    ]
    sql: ${TABLE}.accept_date ;;
  }

  dimension_group: accept_initial {
    type: time
    description: "The local date/time that the care request was first accepted.
                  If an auto assignment is overridden this will be different than accept date."
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.accept_date_initial ;;
  }

  dimension_group: requested {
    type: time
    description: "The date/time that the care request was requested.
                  If scheduled for the next day, this will be the next day date/time
                  stamp of when the office opens.  In these cases, use 'created' date instead"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.requested_date ;;
  }

  dimension: requested_rounded_integer {
    description: "The requested visit time of day, represented as a rounded decimal (e.g. 10:15 AM = 10)"
    type: number
    sql: round((CAST(EXTRACT(HOUR FROM ${requested_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${requested_raw} ) AS FLOAT)) / 60)) ;;
      value_format: "0"
  }

  # dimension: accepted_15_min_groups {
  #   type: number
  #   sql: date_trunc('hour', ${accept_raw}) +
  #       date_part('minute', ${accept_raw})::int / 15 * interval '15 min' ;;
  # }


  dimension: on_scene_decimal {
    description: "The on-scene time of day, represented as a decimal (e.g. 10:15 AM = 10.25)"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${on_scene_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${on_scene_raw} ) AS FLOAT)) / 60) ;;
  }

  dimension: on_scene_rounded_integer {
    description: "The on-scene time of day, represented as a decimal (e.g. 10:15 AM = 10)"
    type: number
    sql: round((CAST(EXTRACT(HOUR FROM ${on_scene_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${on_scene_raw} ) AS FLOAT)) / 60)) ;;
      value_format: "0"
  }

  dimension: accepted_decimal {
    description: "The accepted time of day, represented as a decimal (e.g. 10:15 AM = 10.25)"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${accept_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${accept_raw} ) AS FLOAT)) / 60) ;;
    value_format: "0.00"
  }

  dimension: accepted_rounded_integer {
    description: "The accepted time of day, represented as a rounded decimal (e.g. 10:15 AM = 10)"
    type: number
    sql: round((CAST(EXTRACT(HOUR FROM ${accept_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${accept_raw} ) AS FLOAT)) / 60)) ;;
    value_format: "0"
  }

  measure: first_accepted_decimal {
    description: "The first accepted time of day, represented as a decimal"
    type: min
    sql: ${accepted_decimal} ;;
    value_format: "0.00"
  }

  dimension: shift_start_decimal {
    description: "The shift start time of day, represented as a decimal"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${shift_start_raw}) AS INT)) +
    ((CAST(EXTRACT(MINUTE FROM ${shift_start_raw}) AS FLOAT)) / 60) ;;
    value_format: "0.00"
  }

  dimension: shift_end_decimal {
    description: "The shift start time of day, represented as a decimal"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${shift_end_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${shift_end_raw}) AS FLOAT)) / 60) ;;
    value_format: "0.00"
  }

  dimension_group: complete {
    type: time
    description: "The local date/time that the care request was completed or
                  resolved/escalated on-scene"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      hour,
      week,
      month,
      day_of_week,
      day_of_week_index,
      day_of_month,
      quarter,
      month_num,
      year
      ]
    sql: ${TABLE}.complete_date ;;
  }

  dimension: month_to_date_last_complete_month_on_first {
    description: "Designed to be used for reports that require month-to-date reporting daily where the 1st of every new month returns the last full complete month"
    type: string
    sql: CASE
           WHEN extract(day FROM NOW() AT TIME ZONE ${timezones.pg_tz}) != 1 AND extract(month FROM NOW() AT TIME ZONE ${timezones.pg_tz}) != 1 AND extract(year FROM ${complete_raw}) = extract(year FROM NOW() AT TIME ZONE ${timezones.pg_tz}) AND extract(month FROM ${complete_raw}) = extract(month FROM NOW() AT TIME ZONE ${timezones.pg_tz}) AND (NOW() AT TIME ZONE ${timezones.pg_tz})::DATE != ${complete_raw}::DATE THEN extract(year FROM NOW() AT TIME ZONE ${timezones.pg_tz})::varchar || '-' ||  extract(month FROM NOW() AT TIME ZONE ${timezones.pg_tz})::varchar
           WHEN extract(day FROM NOW() AT TIME ZONE ${timezones.pg_tz}) = 1 AND extract(month FROM ${complete_raw}) = extract(month FROM (NOW()  AT TIME ZONE ${timezones.pg_tz} - interval '1' month)) AND extract(year FROM ${complete_raw}) = extract(year FROM NOW() AT TIME ZONE ${timezones.pg_tz}) THEN extract(year FROM NOW() AT TIME ZONE ${timezones.pg_tz})::varchar || '-' || extract(month FROM (NOW() AT TIME ZONE ${timezones.pg_tz}  - interval '1' month)::date)::varchar
           WHEN extract(day FROM NOW() AT TIME ZONE ${timezones.pg_tz}) = 1 AND extract(month FROM NOW() AT TIME ZONE ${timezones.pg_tz}) = 1 AND extract(year FROM ${complete_raw}) = extract(year FROM NOW() AT TIME ZONE ${timezones.pg_tz}) THEN  extract(year FROM (NOW()  AT TIME ZONE ${timezones.pg_tz} - interval '1' year)::date)::varchar || '-' || '12'
           ELSE 'Exclude'
           END;;
  }

   parameter: care_request_complete_timeframe_picker {
    label: "Select care request Complete Date grouping "
    type: string
    allowed_value: { value: "Date" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    allowed_value: { value: "Quarter" }
    allowed_value: { value: "Year" }
    default_value: "Date"
  }

  dimension: dynamic_care_request_complete_timeframe {
    type: string
    sql:
    CASE
    WHEN {% parameter care_request_complete_timeframe_picker %} = 'Date' THEN TO_CHAR(${care_request_flat.complete_date},'YYYY-MM-DD')
    WHEN {% parameter care_request_complete_timeframe_picker %} = 'Week' THEN ${care_request_flat.complete_week}
    WHEN{% parameter care_request_complete_timeframe_picker %} = 'Month' THEN ${care_request_flat.complete_month}
    WHEN{% parameter care_request_complete_timeframe_picker %} = 'Quarter' THEN
      CASE
      WHEN substring(${care_request_flat.complete_quarter},6,2) = '01' THEN substring(${care_request_flat.complete_quarter},1,5)||'Q1'
      WHEN substring(${care_request_flat.complete_quarter},6,2) = '04' THEN substring(${care_request_flat.complete_quarter},1,5)||'Q2'
      WHEN substring(${care_request_flat.complete_quarter},6,2) = '07' THEN substring(${care_request_flat.complete_quarter},1,5)||'Q3'
      WHEN substring(${care_request_flat.complete_quarter},6,2) = '10' THEN substring(${care_request_flat.complete_quarter},1,5)||'Q4'
      END
    WHEN{% parameter care_request_complete_timeframe_picker %} = 'Year' THEN to_char(${care_request_flat.complete_date},'YYYY')
    END ;;
  }

  dimension: complete_decimal_half_hour_increment {
    description: "Complete Time of Day as Decimal rounded to the nearest 1/2 hour increment"
    type: number
    sql: CASE
      WHEN CAST(EXTRACT(MINUTE FROM ${complete_raw}) AS FLOAT) < 15 THEN FLOOR(CAST(EXTRACT(HOUR FROM ${complete_raw}) AS INT)) + 0
      WHEN CAST(EXTRACT(MINUTE FROM ${complete_raw} ) AS FLOAT) >= 15 AND CAST(EXTRACT(MINUTE FROM ${complete_raw} ) AS FLOAT) < 45 THEN FLOOR(CAST(EXTRACT(HOUR FROM ${complete_raw}) AS INT)) + 0.5
      ELSE  FLOOR(CAST(EXTRACT(HOUR FROM ${complete_raw}) AS INT)) + 1
      END
      ;;
    value_format: "0.0"
  }

  dimension: weekday_complete {
    type: string
    description: "A flag indicating the complete date is during the week"
    sql: CASE WHEN ${complete_day_of_week_index} IN (0,1,2,3,4) THEN 'Weekday'
            WHEN ${complete_day_of_week_index} IN (5,6) THEN 'Weekend'
            ELSE NULL END;;
  }

  dimension_group: archive {
    type: time
    description: "The local date/time that the care request was archived or resolved"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_week,
      day_of_month
    ]
    sql: ${TABLE}.archive_date ;;
  }

  dimension: scheduled_visit {
    type: yesno
    sql: ${scheduled_date} IS NOT NULL ;;
  }

  measure: scheduled_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: scheduled_visit
      value: "yes"
    }
  }

  dimension_group: complete_resolved {
    type: time
    description: "The complete date or archive date, depending on whether the request was complete or resolved"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_week,
      day_of_month
    ]
    sql: CASE
          WHEN ${archive_comment} IS NOT NULL THEN ${archive_raw}
          ELSE ${complete_raw}
         END ;;
  }

  dimension_group: claim_created_resolved {
    type: time
    description: "The claim created date or archive date, depending on whether the request was complete or resolved"
    convert_tz: no
    timeframes: [
      raw,
      date,
      time,
      week,
      month
    ]
    sql: CASE
          WHEN ${archive_comment} IS NOT NULL AND LOWER(${primary_resolved_reason}) <> 'referred - point of care' THEN ${archive_raw}
          ELSE ${athenadwh_claims_clone.claim_created_datetime_raw}
         END ;;
  }

  dimension: eta_to_on_scene_resolved_minutes  {
    type: number
    group_label: "ETAs"
    description: "The number of minutes between the initial ETA and either the on-scene or resolved time"
    sql: EXTRACT(EPOCH FROM COALESCE(${on_scene_raw},${archive_raw}) - ${eta_raw})/60 ;;
  }

  dimension: initial_eta_end_to_on_scene_minutes  {
    type: number
    group_label: "ETAs"
    description: "The number of minutes between the initial ETA end time and the on-scene time"
    sql: EXTRACT(EPOCH FROM ${on_scene_raw} - ${eta_range_end_raw})/60;;
    value_format: "0.0"
  }

  dimension: initial_eta_start_to_on_scene_minutes  {
    type: number
    group_label: "ETAs"
    description: "The number of minutes between the initial ETA start time and the on-scene time"
    sql: EXTRACT(EPOCH FROM ${on_scene_raw} - ${eta_range_start_raw})/60;;
    value_format: "0.0"
  }

  dimension: initial_eta_window_to_on_scene_2_groups {
    type: string
    group_label: "ETAs"
    description: "On-scene time relative to initial ETA window grouping (2 bins)"
    sql: CASE
          WHEN ${initial_eta_end_to_on_scene_minutes} <= 15 THEN 'Arrived as Expected'
          WHEN ${initial_eta_end_to_on_scene_minutes} > 15 THEN 'Arrived 15 Minutes or Later'
          ELSE NULL
          END
          ;;
  }

  dimension: initial_eta_window_to_on_scene_expanded_groups {
    type: string
    group_label: "ETAs"
    description: "On-scene time relative to initial ETA window grouping (5 bins)"
    sql:  CASE
          WHEN ${on_scene_raw} <  ${eta_range_start_raw} THEN '(1) Early'
          WHEN ${initial_eta_end_to_on_scene_minutes} <= 15 THEN '(2) On Time'
          WHEN ${initial_eta_end_to_on_scene_minutes} > 15 AND ${initial_eta_end_to_on_scene_minutes} <= 60 THEN '(3) 16-60 Minutes Late'
          WHEN ${initial_eta_end_to_on_scene_minutes} > 60 AND ${initial_eta_end_to_on_scene_minutes} <= 240 THEN '(4) 61 Minutes to 4 Hours Late'
          WHEN ${initial_eta_end_to_on_scene_minutes} > 240 THEN '(5) Greater than 4 Hours Late'
          ELSE NULL
          END
          ;;
  }

  dimension: initial_eta_window_to_on_scene_granular_groups {
    type: string
    group_label: "ETAs"
    description: "On-scene time relative to initial ETA window grouping (5 bins)"
    sql:  CASE

          WHEN ${initial_eta_start_to_on_scene_minutes} < -60 THEN '(01) Greater than 60 Minutes Early'
          WHEN ${initial_eta_start_to_on_scene_minutes} >= -60 AND ${initial_eta_start_to_on_scene_minutes} < -50 THEN '(02) 51 to 60 Minutes Early'
          WHEN ${initial_eta_start_to_on_scene_minutes} >= -50 AND ${initial_eta_start_to_on_scene_minutes} < -40 THEN '(03) 41 to 50 Minutes Early'
          WHEN ${initial_eta_start_to_on_scene_minutes} >= -40 AND ${initial_eta_start_to_on_scene_minutes} < -30 THEN '(04) 31 to 40 Minutes Early'
          WHEN ${initial_eta_start_to_on_scene_minutes} >= -30 AND ${initial_eta_start_to_on_scene_minutes} < -20 THEN '(05) 21 to 30 Minutes Early'
          WHEN ${initial_eta_start_to_on_scene_minutes} >= -20 AND ${initial_eta_start_to_on_scene_minutes} < -10 THEN '(06) 11 to 20 Minutes Early'
          WHEN ${initial_eta_start_to_on_scene_minutes} >= -10 AND ${initial_eta_start_to_on_scene_minutes} < 0 THEN '(07) 1 to 10 Minutes Early'
          WHEN ${initial_eta_start_to_on_scene_minutes} >= 0 AND ${initial_eta_end_to_on_scene_minutes} <= 0 THEN '(08) On Time'
          WHEN ${initial_eta_end_to_on_scene_minutes} > 0 AND ${initial_eta_end_to_on_scene_minutes} <= 10 THEN '(09) 1 to 10 Minutes Late'
          WHEN ${initial_eta_end_to_on_scene_minutes} > 10 AND ${initial_eta_end_to_on_scene_minutes} <= 20 THEN '(10) 11 to 20 Minutes Late'
          WHEN ${initial_eta_end_to_on_scene_minutes} > 20 AND ${initial_eta_end_to_on_scene_minutes} <= 30 THEN '(11) 21 to 30 Minutes Late'
          WHEN ${initial_eta_end_to_on_scene_minutes} > 30 AND ${initial_eta_end_to_on_scene_minutes} <= 40 THEN '(12) 31 to 40 Minutes Late'
          WHEN ${initial_eta_end_to_on_scene_minutes} > 40 AND ${initial_eta_end_to_on_scene_minutes} <= 50 THEN '(13) 41 to 50 Minutes Late'
          WHEN ${initial_eta_end_to_on_scene_minutes} > 50 AND ${initial_eta_end_to_on_scene_minutes} <= 60 THEN '(14) 51 to 60 Minutes Late'
          WHEN ${initial_eta_end_to_on_scene_minutes} > 60 THEN '(15) Greater than 60 Minutes Late'
          ELSE NULL
          END
          ;;
  }

  dimension: accepted_to_initial_eta_minutes  {
    type: number
    view_label: "Accepted to ETA Minutes"
    group_label: "ETAs"
    description: "The number of minutes between when the care request was accepted and the ETA"
    sql: ROUND(CAST(EXTRACT(EPOCH FROM ${eta_raw} - ${accept_raw})/60 AS integer), 0) ;;
    value_format: "0"
  }

  dimension: accepted_initial_to_eta_initial_minutes  {
    type: number
    group_label: "ETAs"
    description: "The number of minutes between when the care request was first accepted and the initial ETA"
    sql: ROUND(CAST(EXTRACT(EPOCH FROM ${initial_eta_raw} - ${accept_initial_raw})/60 AS integer), 0) ;;
    value_format: "0"
  }

  dimension: mins_early_late_tier {
    type: tier
    group_label: "ETAs"
    tiers: [-60, -45, -30, -15, 0, 10, 15, 30, 45, 60]
    style: integer
    sql: ${eta_to_on_scene_resolved_minutes} ;;
  }

  dimension: mins_to_eta_tier {
    type: tier
    group_label: "ETAs"
    description: "The grouped number of minutes between accepted and ETA"
    tiers: [30, 60, 90, 120, 150, 180, 210, 240]
    style: integer
    sql: ${accepted_to_initial_eta_minutes} ;;
  }

  dimension: mins_to_eta_tier_wide {
    type: tier
    group_label: "ETAs"
    description: "The grouped number of minutes between accepted and ETA"
    tiers: [60, 120, 180, 240]
    style: integer
    sql: ${accepted_to_initial_eta_minutes} ;;
  }

  dimension: eta_150_mins_or_less {
    type: yesno
    description: "The accept to ETA time is 150 minutes or less"
    sql: ${accepted_to_initial_eta_minutes} <= 150 ;;
  }

  dimension: days_to_complete {
    type: number
    description: "The number of days required to complete or resolve the care request.
                  If null, the request may be scheduled for a day in the future"
    sql: CASE
    WHEN ${complete_raw} IS NOT NULL THEN DATE_PART('day', ${complete_raw}::timestamp) - DATE_PART('day', ${created_raw}::timestamp)
    WHEN ${complete_raw} IS NULL AND ${archive_raw} IS NOT NULL THEN DATE_PART('day', ${archive_raw}::timestamp) - DATE_PART('day', ${created_raw}::timestamp)
    ELSE NULL
    END ;;
  }

  dimension: different_day_complete {
    description: "A flag indicating that the request date was different than completed or resolved date"
    type: yesno
    sql: ${days_to_complete} >= 1 ;;
  }

  dimension_group: shift_start {
    type: time
    description: "The local date/time of a shift start"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_week,
      day_of_month
    ]
    sql: ${TABLE}.shift_start_time ;;
  }

  dimension_group: shift_end {
    type: time
    description: "The local date/time of a shift end"
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.shift_end_time ;;
  }

  measure: max_shift_end_time{
    sql: max(${shift_end_raw}) ;;
  }

  dimension: shift_hours  {
    type: number
    sql: EXTRACT(EPOCH FROM ${shift_end_raw} - ${shift_start_raw})/3600 ;;
  }

  dimension: shift_start_to_first_onroute {
      type: number
      description: "The number of minutes between shift start and first on route"
      sql: EXTRACT(EPOCH FROM ${first_on_route_raw} - ${shift_start_raw})/60 ;;
      value_format: "0.0"
  }

  dimension: end_of_shift_dead_time {
    type: number
    description: "The number of hours between last updated and shift end"
    sql: (EXTRACT(EPOCH FROM ${shift_end_raw}) - EXTRACT(EPOCH FROM ${shifts_end_of_shift_times.last_update_time_raw}))/3600 ;;
    value_format: "0.00"
  }

  dimension: end_of_shift_dead_time_45_mins {
    type: yesno
    description: "A flag indicating that the end of shift dead time > 45 minutes"
    sql: ${end_of_shift_dead_time} >= 0.75 ;;
  }

measure: sum_end_of_shift_dead_time {
  type: sum
  description: "A sum of end of shift dead time from last updated to shift end"
  sql: ${end_of_shift_dead_time} ;;
}

measure:  count_end_of_shift_dead_time_45_mins {
  type:  count_distinct
  description: "count of shifts where the end of shift dead time > 45 minutes"
  sql: ${care_requests.shift_team_id}  ;;
  filters: {
    field: end_of_shift_dead_time_45_mins
    value: "yes"
  }
}

measure: avg_first_on_route_mins {
  type: average
  description: "The average minutes between shift start and first on-route"
  sql: ${shift_start_to_first_onroute} ;;
  value_format: "0.0"
}


  dimension: shift_team_id  {
    type: number
    sql:${TABLE}.shift_team_id ;;
  }


  measure: sum_shift_hours {
    type: sum
    description: "The sum of all scheduled shift hours"
    sql: ${shift_hours} ;;
  }

  measure: sum_distinct_shift_hours {
    type: sum_distinct
    description: "The sum of each scheduled shift hours"
    sql: ${shift_hours} ;;
    #sql_distinct_key: ${cars.name} ;;
    sql_distinct_key: ${care_requests.shift_team_id} ;;
  }

  measure: max_complete_time {
    label: "Last Care Request Completion Time"
    type: date_time
    sql:  MAX(${complete_raw}) ;;
  }

  dimension: created_decimal {
    description: "Complete Time of Day as Decimal"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${created_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${created_raw} ) AS FLOAT)) / 60) ;;
      value_format: "0.00"
  }

  dimension: created_rounded_integer {
    description: "Complete Time of Day as Decimal"
    type: number
    sql: round((CAST(EXTRACT(HOUR FROM ${created_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${created_raw} ) AS FLOAT)) / 60)) ;;
    value_format: "0"
  }

  dimension: complete_decimal {
    description: "Complete Time of Day as Decimal"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${complete_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${complete_raw} ) AS FLOAT)) / 60) ;;
  }

  dimension: complete_resolved_decimal {
    description: "Complete or Resolved Time of Day as Decimal"
    type: number
    sql: (CAST(EXTRACT(HOUR FROM ${complete_resolved_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${complete_resolved_raw} ) AS FLOAT)) / 60) ;;
      value_format: "0.00"
  }

  dimension: complete_decimal_after_midnight {
    description: "Complete Time of Day as Decimal Accounting for Time After Midnight"
    type: number
    sql: CASE
          WHEN (CAST(EXTRACT(HOUR FROM ${complete_raw}) AS INT)) <=3 THEN 24
          ELSE 0
        END +
        (CAST(EXTRACT(HOUR FROM ${complete_raw}) AS INT)) +
        ((CAST(EXTRACT(MINUTE FROM ${complete_raw} ) AS FLOAT)) / 60) ;;
    value_format: "0.00"
  }

  dimension_group: today_mountain{
    type: time
    description: "Today's date/time, given in Mountain time"
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: CURRENT_DATE ;;
  }

  dimension_group: yesterday_mountain{
    type: time
    timeframes: [date, day_of_week_index, week, month, day_of_month, quarter]
    sql: current_date - interval '1 day';;
  }

  dimension_group: last_week_mountain{
    type: time
    timeframes: [date, day_of_week_index, week, month, day_of_month]
    sql: current_date - interval '7 day';;
  }

  dimension:  same_day_of_week_on_scene {
    type: yesno
    sql:  ${yesterday_mountain_day_of_week_index} = ${on_scene_day_of_week_index};;
  }

  dimension:  same_day_of_week_created {
    type: yesno
    sql:  ${yesterday_mountain_day_of_week_index} = ${created_day_of_week_index};;
  }

  dimension:  same_day_of_week_created_today {
    type: yesno
    sql:  ${today_mountain_day_of_week_index} = ${created_day_of_week_index};;
  }



  dimension: until_today_on_scene {
    type: yesno
    sql: ${on_scene_day_of_week_index} <=  ${yesterday_mountain_day_of_week_index} AND ${on_scene_day_of_week_index} >= 0 ;;
  }

  dimension: until_today_created {
    type: yesno
    sql: ${created_day_of_week_index} <=  ${yesterday_mountain_day_of_week_index} AND ${created_day_of_week_index} >= 0 ;;
  }

  dimension: this_week_on_scene {
    type:  yesno
    sql: ${yesterday_mountain_week} =  ${on_scene_week};;

  }

  dimension: last_week_on_scene {
    type:  yesno
    sql: ${last_week_mountain_week} =  ${on_scene_week};;

  }

  dimension: last_week_created {
    type:  yesno
    sql: ${last_week_mountain_week} =  ${created_week};;

  }


  dimension: this_week_created {
    type:  yesno
    sql: ${yesterday_mountain_week} =  ${created_week};;

  }
  dimension: this_month_on_scene {
    type:  yesno
    sql: ${yesterday_mountain_month} =  ${on_scene_month};;
  }

  dimension: month_to_date_on_scene  {
    type:  yesno
    sql: ${on_scene_day_of_month} <= ${yesterday_mountain_day_of_month} ;;
  }

  dimension: month_to_date_created {
    type:  yesno
    sql: ${created_day_of_month} <= ${yesterday_mountain_day_of_month} ;;
  }

  dimension: month_to_date_created_two_days{
    type:  yesno
    sql: ${created_day_of_month} <= (${yesterday_mountain_day_of_month}-1) ;;
  }

  measure: distinct_months_on_scene {
    type: number
    sql: count(DISTINCT ${on_scene_month}) ;;
  }


  measure: distinct_days_on_scene {
    type: number
    sql: count(DISTINCT ${on_scene_date}) ;;
  }



  measure: distinct_days_created {
    type: number
    sql: count(DISTINCT ${created_date}) ;;
  }

  measure: distinct_weeks_created {
    type: number
    sql: count(DISTINCT ${created_week}) ;;
  }



  measure: distinct_weeks_on_scene {
    type: number
    sql: count(DISTINCT ${on_scene_week}) ;;
  }

  measure: daily_average_complete {
    type: number
    value_format: "0.0"
    sql: ${complete_count}::float/(nullif(${distinct_days_on_scene},0))::float  ;;
  }


  measure: daily_average_created {
    type: number
    value_format: "0.0"
    sql: ${care_request_count}::float/(nullif(${distinct_days_created},0))::float  ;;
  }


  measure: weekly_average_complete {
    type: number
    value_format: "0.0"
    sql: ${complete_count}/(nullif(${distinct_weeks_on_scene},0))::float  ;;
  }

  measure: weekly_average_created{
    type: number
    value_format: "0.0"
    sql: ${care_request_count}/(nullif(${distinct_weeks_created},0))::float  ;;
  }


  measure: monthly_average_complete {
    type: number
    value_format: "0.0"
    sql: ${complete_count}/(nullif(${distinct_months_on_scene},0))::float ;;
  }


  measure: min_day_on_scene {
    type: date
    sql: min(${on_scene_date}) ;;
  }

  measure: max_day_on_scene {
    timeframes: [date, day_of_week_index, week, month, day_of_month, quarter]
    type: date
    sql:max(${on_scene_date}) ;;
  }

  measure: min_day_created {
    type: date
    sql: min(${created_date}) ;;
  }

  measure: max_day_created{
    type: date
    sql:max(${created_date}) ;;
  }


  measure: min_week_on_scene {
    type: string
    sql: min(${on_scene_week}) ;;
  }

  measure: min_week_created{
    type: string
    sql: min(${created_week}) ;;
  }

  measure: max_week_on_scene {
    type: string
    sql:max(${on_scene_week}) ;;
  }
  measure: min_month_on_scene {
    type: string
    sql: min(${on_scene_month}) ;;
  }

  measure: max_month_on_scene {
    type: string
    sql:max(${on_scene_month}) ;;
  }

  measure: min_max_range_day_on_scene {
    type: string
    sql:
      case when ${min_week_on_scene} =  ${yesterday_mountain_week} then ${min_day_on_scene}::text
      else concat(trim(to_char(current_date - interval '1 day', 'day')), 's ', ${min_day_on_scene}, ' thru ', ${max_day_on_scene}) end ;;

    }

  measure: min_max_range_day_created {
    type: string
    sql:
      case when ${min_week_on_scene} =  ${yesterday_mountain_week} then ${min_day_on_scene}::text
      else concat(trim(to_char(current_date - interval '1 day', 'day')), 's ', ${min_day_on_scene}, ' thru ', ${max_day_on_scene}) end ;;

    }

    measure: min_max_range_week {
      type: string
      sql:
      case when ${min_week_on_scene} =  ${yesterday_mountain_week} then concat(${min_day_on_scene}, ' thru ', ${max_day_on_scene})
      else concat('Week to date for weeks ', ${min_week_on_scene}, ' thru ', ${max_week_on_scene}) end ;;

      }

      measure: min_max_range {
        type: string
        sql: concat(${min_day_on_scene}, ' thru ', ${max_day_on_scene});;

      }

  measure: projections_diff {
    label: "Diff to budget"
    type: number
    sql: round(${monthly_visits_run_rate}-${budget_projections_by_market_clone.sum_projected_visits}) ;;
  }

  measure: projections_diff_target {
    label: "Diff to productivity target"
    type: number
    sql: round(${monthly_visits_run_rate}-${shift_hours_by_day_market_clone.productivity_target}) ;;
  }

  measure: productivity {
    type: number
    sql: round(${complete_count}/NULLIF(${shift_hours_by_day_market_clone.sum_total_hours}::DECIMAL,0), 2) ;;
  }

  measure: resolved_reason {
    type: string
    sql:array_agg(distinct concat(${complete_comment}, ${archive_comment}))::text ;;
  }

  dimension: resolved_reason_full {
    type: string
    sql: coalesce(${complete_comment}, ${archive_comment}) ;;
  }

#   dimension: primary_resolved_reason {
#     type:  string
#     sql: trim(split_part(${resolved_reason_full}, ':', 1)) ;;
#     drill_fields: [secondary_resolved_reason]
#   }

  dimension: primary_resolved_reason {
    type:  string
    sql: CASE
        WHEN UPPER(trim(split_part(${resolved_reason_full}, ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
        WHEN UPPER(trim(split_part(${resolved_reason_full}, ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
        ELSE  trim(split_part(${resolved_reason_full}, ':', 1))
        END;;
        drill_fields: [secondary_resolved_reason]
  }

  dimension: secondary_resolved_reason {
    type:  string
    sql: CASE
          WHEN ${resolved_reason_full} LIKE '%Spoke to my family doctor%' THEN 'Spoke to my Family Doctor'
          WHEN trim(split_part(${resolved_reason_full}, ':', 2)) SIMILAR TO '%(Going to an Emergency Department|Going to Emergency Department)%' THEN 'Going to Emergency Department'
          WHEN trim(split_part(${resolved_reason_full}, ':', 2)) SIMILAR TO '%(Going to an Urgent Care|Going to Urgent Care)%' THEN 'Going to Urgent Care'
          ELSE trim(split_part(${resolved_reason_full}, ':', 2))
        END ;;
  }

  dimension: primary_and_secondary_resolved_reason {
    type: string
    sql: concat(${primary_resolved_reason},': ', ${secondary_resolved_reason}) ;;
  }


  dimension: other_resolved_reason {
    type:  string
    sql: trim(split_part(${resolved_reason_full}, ':', 3)) ;;
  }

  dimension: resolved_to_advanced_care {
    description: "Resolved to Advanced Care (resolved reason contains 'Advanced Care)"
    type: yesno
    sql: lower(${resolved_reason_full}) LIKE '%advanced care%' or lower(${resolved_reason_full}) LIKE '%advancedcare%' or lower(${resolved_reason_full}) LIKE '%escalated to advanced%';;
  }

  measure: resolved_to_advanced_care_count {
    description: "Count of Resolved to Advanced Care (resolved reason contains 'Advanced Care)"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: resolved_to_advanced_care
      value: "yes"
    }

  }


  dimension: escalation_type {
    type: string
    sql: CASE
          WHEN UPPER(${complete_comment}) LIKE '%REFERRED - POINT OF CARE%' OR
          ${primary_resolved_reason} = 'Referred - Point of Care' THEN 'Escalated On Scene'
          WHEN ${archive_comment} LIKE '%Referred - Phone Triage%' THEN 'Escalated Over Phone'
          ELSE NULL
         END ;;
  }


#   dimension: escalated_on_scene {
#     type: yesno
#     sql: UPPER(${complete_comment}) LIKE '%REFERRED - POINT OF CARE%' OR
#     ${primary_resolved_reason} = 'Referred - Point of Care';;
#   }


  dimension: escalated_on_scene {
    description: "Escalated to emergency department or 911 on-scene"
    label: "Escalated On-Scene to Ed"
    type: yesno
    sql:UPPER(${complete_comment}) LIKE '%REFERRED - POINT OF CARE: EMERGENCY DEPARTMENT%' OR
        UPPER(${complete_comment}) LIKE '%REFERRED - POINT OF CARE: ED%' OR
        (UPPER(${primary_resolved_reason}) = 'REFERRED - POINT OF CARE' AND
        (UPPER(${secondary_resolved_reason}) LIKE '%EMERGENCY DEPARTMENT%' OR
        SUBSTRING(UPPER(${secondary_resolved_reason}),1,2) = 'ED')) ;;

  }

  dimension: escalated_non_ed_on_scene {
    description: "Escalated or referred on-scene to non Emergency Department or 911 source"
    label: "Escalated or Referred On-Scene to Non ED"
    type: yesno
    sql:  ${care_request_flat.complete_date} is not null AND
        ((${care_request_flat.primary_resolved_reason} IS NULL OR
        UPPER(${care_request_flat.complete_comment}) LIKE '%REFERRED - POINT OF CARE%' OR
        UPPER(${care_request_flat.primary_resolved_reason}) = 'REFERRED - POINT OF CARE') AND
        NOT ${escalated_on_scene});;
  }



  dimension: lwbs_going_to_ed {
    type: yesno
    sql: ${archive_comment} SIMILAR TO '%(Cancelled by Patient: Going to an Emergency Department|Going to Emergency Department)%' ;;
  }

  dimension: duplicate {
    type: yesno
    sql: lower(${archive_comment}) SIMILAR TO '%(duplicate)%' and not ${accepted_or_scheduled} ;;

  }


  dimension: lwbs_going_to_urgent_care {
    type: yesno
    sql: LOWER(${archive_comment}) SIMILAR TO '%(going to an urgent care|going to urgent care)%' ;;
  }

  dimension: lwbs_wait_time_too_long {
    type: yesno
    sql: LOWER(${archive_comment}) LIKE '%wait time too long%' ;;
  }

  dimension: lwbs_going_to_pcp {
    type: yesno
    sql: ${archive_comment} LIKE '%Going to PCP%' ;;
  }

  dimension: lwbs_no_longer_need_care {
    type: yesno
    sql: ${archive_comment} LIKE '%Cancelled by Patient: No longer need care%'
          or
          ${archive_comment} LIKE '%Cancelled by Patient or Partner: Symptoms Resolved / Wait it Out%' ;;
  }

  dimension: cancelled_by_patient_reason {
    type: yesno
    sql: ${primary_resolved_reason} = 'Cancelled by Patient' ;;
  }

  dimension: lwbs {
    type: yesno
    description: "Going to ED/Urgent Care, Wait Time Too Long, No Longer Need Care"
    sql: (${lwbs_going_to_ed} OR ${lwbs_going_to_urgent_care} OR
      ${lwbs_wait_time_too_long} OR ${lwbs_no_longer_need_care} OR ${lwbs_going_to_pcp}) and not ${booked_shaping_placeholder_resolved} ;;
  }

  dimension: resolved_no_answer_no_show {
    type: yesno
    sql: (${archive_comment} LIKE '%No Answer%' OR ${archive_comment} LIKE '%No Show%') and not ${booked_shaping_placeholder_resolved};;
  }

  dimension: resolved_no_show {
    type: yesno
    sql: (${archive_comment} LIKE '%No Show%') and not ${booked_shaping_placeholder_resolved};;
  }

  dimension: resolved_911_divert {
    type: yesno
    sql: ${archive_comment} LIKE '%911 Divert%' ;;
  }

  dimension: resolved_other {
    type: yesno
    sql:  ${complete_date} IS NULL AND ((${lwbs} IS NOT TRUE AND ${escalated_on_phone} IS NOT TRUE AND ${resolved_911_divert} IS NOT TRUE AND ${resolved_no_answer_no_show} IS NOT TRUE and ${booked_shaping_placeholder_resolved} is not true)
          OR ${archive_comment} IS NULL);;
  }

  dimension: resolved_category {
    type: string
    sql: CASE
          WHEN ${lwbs} THEN 'Left Without Being Seen'
          WHEN ${resolved_no_answer_no_show} THEN 'No Answer/No Show'
          WHEN ${resolved_911_divert} THEN '911 Diversion'
          WHEN ${escalated_on_phone} THEN 'Escalated Over Phone'
          WHEN ${resolved_other} THEN 'Other Resolved'
          WHEN ${booked_shaping_placeholder_resolved} THEN 'Booked or Shaping'
          ELSE 'Billable Visit'
        END
          ;;
  }

  measure: lwbs_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: lwbs
      value: "yes"
    }
    link: {
      label: "Patient-Level Details"
      url: "https://dispatchhealth.looker.com/looks/1124?&f[markets.name]={{ _filters['markets.name'] | url_encode }}
      &f[markets.name_adj]={{ _filters['markets.name_adj'] | url_encode }}
      &f[care_request_flat.escalated_on_scene]={{ _filters['care_request_flat.escalated_on_scene'] | url_encode }}
      &f[care_request_flat.complete_resolved_date]=1+month+ago+for+1+month
      &f[care_request_flat.lwbs]={{ _filters['care_request_flat.lwbs'] | url_encode }}
      &f[care_request_flat.secondary_resolved_reason]={{ _filters['care_request_flat.secondary_resolved_reason'] | url_encode }}
      &f[athenadwh_payers_clone.custom_insurance_grouping]={{ _filters['athenadwh_payers_clone.custom_insurance_grouping'] | url_encode }}"
    }
    drill_fields: [
      secondary_resolved_reason,
      care_request_flat.lwbs_count
    ]
  }

  measure: cancelled_by_patient_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: cancelled_by_patient_reason
      value: "yes"
    }
    drill_fields: [
      secondary_resolved_reason,
      care_request_count
      ]
  }

  measure: no_answer_no_show_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: resolved_no_answer_no_show
      value: "yes"
    }
  }

  measure: no_show_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: resolved_no_show
      value: "yes"
    }
  }

  measure: resolved_non_lwbs_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: care_requests.billable_est
      value: "no"
    }
    filters: {
      field: lwbs
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: resolved_911_divert
      value: "no"
    }
    filters: {
      field: resolved_no_answer_no_show
      value: "no"
    }
    drill_fields: [
      secondary_resolved_reason,
      care_request_count
    ]
  }

  measure: lwbs_rate {
    type: number
    value_format: "0.0%"
    sql: ${lwbs_count}::float/nullif(${care_requests.count_distinct_intended_care_requests},0) ;;

  }

  dimension: not_resolved_or_complete {
    type: yesno
    sql:not ${complete} and ${archive_comment} is null ;;
  }

  measure: not_resolved_or_complete_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: not_resolved_or_complete
      value: "yes"
    }

  }

  # dimension: pafu_or_follow_up {
  #   label: "Bridge Care Visit OR DH Follow Up"
  #   description: "DH Followup AND Post Acute Followups are counted. Use the 'Post Acute Followups' flag in the 'Care Request' view to report on PAFU only"
  #   type: yesno
  #   sql: ${care_requests.follow_up} or ${care_requests.post_acute_follow_up} or lower(${service_lines.name}) like '%post acute%' or lower(${service_lines.name}) like '%post-acute%' ;;
  # }

  dimension: pafu_or_follow_up {
    label: "Bridge Care Visit OR DH Follow Up"
    description: "DH Followup AND Post Acute Followups are counted. Use the 'Post Acute Followups' flag in the 'Care Request' view to report on PAFU only"
    type: yesno
    sql: ${care_requests.post_acute_follow_up} or ${care_requests.DHFU_follow_up} ;;
  }

  measure: follow_up_limbo_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: not_resolved_or_complete
      value: "yes"
    }

    filters: {
      field: pafu_or_follow_up
      value: "yes"
    }

  }

  measure: non_follow_up_limbo_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: not_resolved_or_complete
      value: "yes"
    }
    filters: {
      field: pafu_or_follow_up
      value: "no"
    }

  }

  measure: resolved_other_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: care_requests.billable_est
      value: "no"
    }
    filters: {
      field: lwbs
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: resolved_911_divert
      value: "no"
    }
    filters: {
      field: booked_shaping_placeholder_resolved
      value: "no"
    }
    filters: {
      field: resolved_no_answer_no_show
      value: "no"
    }

    filters: {
      field: complete
      value: "no"
    }

    filters: {
      field: not_resolved_or_complete
      value: "no"
    }
    drill_fields: [
      secondary_resolved_reason,
      care_request_count
    ]
  }

  measure: resolved_other_wo_shaping_booked_placeholder_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: care_requests.billable_est
      value: "no"
    }
    filters: {
      field: lwbs
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: resolved_911_divert
      value: "no"
    }
    filters: {
      field: resolved_no_answer_no_show
      value: "no"
    }

    filters: {
      field: complete
      value: "no"
    }

    filters: {
      field: not_resolved_or_complete
      value: "no"
    }

    filters: {
      field: booked_resolved
      value: "no"
    }

    filters: {
      field: shaping_resolved
      value: "no"
    }

    filters: {
      field: placeholder_resolved
      value: "no"
    }

    drill_fields: [
      secondary_resolved_reason,
      care_request_count
    ]
  }


  measure: lwbs_count_pre_logistics {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: lwbs
      value: "yes"
    }
    filters: {
      field: post_logistics_flag
      value: "no"
    }
  }

  measure: lwbs_count_post_logistics {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: lwbs
      value: "yes"
    }
    filters: {
      field: post_logistics_flag
      value: "yes"
    }
  }

  measure: lwbs_no_longer_need_count {
    type: count_distinct
    description: "Count of care requests where resolve reason is 'No longer need care'"
    sql: ${care_request_id} ;;
    filters: {
      field: lwbs_no_longer_need_care
      value: "yes"
    }
  }

  measure: lwbs_wait_time_too_long_count {
    type: count_distinct
    description: "Count of care requests where resolve reason is 'Wait time too long'"
    sql: ${care_request_id} ;;
    filters: {
      field: lwbs_wait_time_too_long
      value: "yes"
    }
  }

  measure: escalated_on_scene_count {
    label: "Escalated On-Scene to Ed Count"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_scene
      value: "yes"
    }
  }

  measure: escalated_on_scene_to_ed_acute_ems_cost_savings_count {
    label: "Escalated On-Scene to ED Excluding Bridge Care and DH Followups"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_scene
      value: "yes"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  dimension: escalated_on_phone {
    type: yesno
    sql: (${archive_comment} SIMILAR TO '%(Referred via Phone|Referred - Phone Triage)%') and not ${booked_shaping_placeholder_resolved};;
  }

  dimension: escalated_on_phone_ed {
    type: yesno
    sql:  (${archive_comment} LIKE '%Referred - Phone Triage: ED%' or  ${archive_comment} LIKE '%Referred via Phone: ED%' or ${archive_comment} LIKE '%Referred via Phone: Emergency Department%')  ;;

  }


  measure: escalated_on_phone_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone
      value: "yes"
    }
  }

  measure: lwbs_ed_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: lwbs_going_to_ed
      value: "yes"
    }
  }

  dimension: booked_shaping_placeholder_resolved {
    type: yesno
    sql:  lower(${archive_comment}) SIMILAR TO '%( cap|book|medicaid|tricare)%' and lower(${archive_comment}) not like '%capability%';;
  }

  dimension: out_of_service_out_of_scope {
    type: yesno
    sql:  lower(${archive_comment}) SIMILAR TO '%(oos|ooa|out of service area)%';;
  }

  dimension: shaping_resolved {
    type: yesno
    sql:  lower(${archive_comment}) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(${archive_comment}) not like '%capability%';;
  }

  dimension: booked_resolved {
    type: yesno
    sql:  lower(${archive_comment}) like '%book%' and not ${shaping_resolved} ;;
  }

  dimension: placeholder_resolved {
    type: yesno
    sql:  lower(${patients.last_name}) ='resolved' and not ${shaping_resolved} and not ${booked_resolved} ;;
  }

  measure: booked_shaping_placeholder_resolved_count {
    description: "Care requests resolved for booked, shaping or placeholder"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: booked_shaping_placeholder_resolved
      value: "yes"
    }
  }

  measure: shaping_resolved_count {
    description: "Care requests resolved for shaping"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: shaping_resolved
      value: "yes"
    }
  }

  measure: booked_resolved_count {
    description: "Care requests resolved for booked"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: booked_resolved
      value: "yes"
    }
  }

  measure: placeholder_resolved_count {
    description: "Care requests resolved with placeholder"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: placeholder_resolved
      value: "yes"
    }
  }

  measure: screened_escalated_phone_count {
    description: "Care requests secondary screened and escalated over the phone"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone
      value: "yes"
    }
    filters: {
      field: secondary_screening
      value: "yes"
    }
  }

  measure: screened_escalated_ed_phone_count {
    description: "Care requests secondary screened and escalated over the phone ED"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone_ed
      value: "yes"
    }
    filters: {
      field: secondary_screening
      value: "yes"
    }
  }

  measure: not_screened_escalated_onscene_count {
    description: "Care requests not secondary screened that were escalated on scene"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_scene
      value: "yes"
    }
    filters: {
      field: secondary_screening
      value: "no"
    }
  }

  measure: non_screened_escalated_phone_count {
    description: "Care requests NOT secondary screened and escalated over the phone"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone
      value: "yes"
    }
    filters: {
      field: secondary_screening
      value: "no"
    }
  }

  measure: non_screened_escalated_phone_count_ed {
    description: "Care requests NOT secondary screened and escalated over the phone to the ED"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone
      value: "yes"
    }
    filters: {
      field: escalated_on_phone_ed
      value: "yes"
    }
    filters: {
      field: secondary_screening
      value: "no"
    }
  }

  measure: non_screened_escalated_phone_count_other {
    description: "Care requests NOT secondary screened and escalated over the phone not to th ED"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone
      value: "yes"
    }
    filters: {
      field: escalated_on_phone_ed
      value: "no"
    }
    filters: {
      field: secondary_screening
      value: "no"
    }
  }

  measure: non_screened_escalated_on_phone_ed_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone_ed
      value: "yes"
    }
    filters: {
      field: secondary_screening
      value: "no"
    }
  }

  measure: escalated_on_phone_ed_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone_ed
      value: "yes"
    }
  }

  measure: non_screeened_escalated_on_phone_ed_percent{
    type: number
    sql: ${non_screened_escalated_on_phone_ed_count}::float/(nullif(${care_request_count},0))::float ;;
    value_format: "0%"
  }


  measure: escalated_on_phone_ed_percent{
    type: number
    sql: ${escalated_on_phone_ed_count}::float/(nullif(${care_request_count},0))::float ;;
    value_format: "0%"
  }

  measure: escalated_on_phone_ed_percent_green{
    type: number
    sql: ${risk_assessments.count_green_escalated_phone}::float/(nullif(${risk_assessments.count_green},0))::float  ;;
    value_format: "0%"
  }

  measure:  non_screeened_escalated_on_phone_ed_percent_green{
    type: number
    sql: ${risk_assessments.non_screened_count_green_escalated_phone}::float/(nullif(${risk_assessments.count_green},0))::float  ;;
    value_format: "0%"
  }


  measure: escalated_on_phone_ed_percent_yellow{
    type: number
    sql: ${risk_assessments.count_yellow_escalated_phone}::float/(nullif(${risk_assessments.count_yellow},0))::float ;;
    value_format: "0%"
  }

  measure: non_screened_escalated_on_phone_ed_percent_yellow{
    type: number
    sql: ${risk_assessments.non_screened_count_yellow_escalated_phone}::float/(nullif(${risk_assessments.count_yellow},0))::float ;;
    value_format: "0%"
  }





  measure: escalated_on_phone_ed_percent_red{
    type: number
    sql:  ${risk_assessments.count_red_escalated_phone}::float/(nullif(${risk_assessments.count_red},0))::float ;;
    value_format: "0%"
  }

  measure: non_screened_escalated_on_phone_ed_percent_red{
    type: number
    sql:  ${risk_assessments.non_screened_count_red_escalated_phone}::float/(nullif(${risk_assessments.count_red},0))::float ;;
    value_format: "0%"
  }

  dimension: hours_to_archive {
    value_format: "0.0"
    type: number
    sql: round(EXTRACT(EPOCH FROM ${archive_raw}-${requested_raw})/3600) ;;
  }

  dimension: escalated_on_phone_reason {
    type: string
    sql: CASE
          WHEN ${escalated_on_phone} THEN split_part(${complete_comment}, ':', 2)
          ELSE NULL
        END ;;
  }

#   dimension: complete {
#     type: yesno
#     sql: ${complete_date} is not null AND (${primary_resolved_reason} IS NULL OR ${escalated_on_scene}) ;;
#   }

  dimension:  complete {
    type: yesno
    sql: ${care_request_flat.complete_date} is not null AND
      (${care_request_flat.primary_resolved_reason} IS NULL OR
      UPPER(${care_request_flat.complete_comment}) LIKE '%REFERRED - POINT OF CARE%' OR
      UPPER(${care_request_flat.primary_resolved_reason}) = 'REFERRED - POINT OF CARE') ;;
  }

  dimension: accepted {
    type: yesno
    sql: ${accept_date} is not null ;;
  }


  dimension: prior_complete_week_flag {
    description: "The complete date is in the past complete week"
    type: yesno
    sql: ((((${complete_date}) >= ((SELECT (DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL))) AND
         (${complete_date}) < ((SELECT ((DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL) + (1 || ' week')::INTERVAL)))))) ;;
  }

  dimension: prior_complete_month_flag {
    description: "The complete date is in the past complete month"
    type: yesno
    sql: ((((${complete_date}) >= ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL))) AND
      (${complete_date}) < ((SELECT ((DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL) + (1 || ' month')::INTERVAL)))))) ;;
  }

  dimension: prior_on_scene_month_flag {
    description: "The complete date is in the past complete month"
    type: yesno
    sql: ((((${on_scene_date}) >= ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL))) AND
      (${on_scene_date}) < ((SELECT ((DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL) + (1 || ' month')::INTERVAL)))))) ;;
  }

  dimension: prior_archive_week_flag {
    description: "The archive date is in the past complete week"
    type: yesno
    sql: ((((${archive_date}) >= ((SELECT (DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL))) AND
      (${archive_date}) < ((SELECT ((DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL) + (1 || ' week')::INTERVAL)))))) ;;
  }

  dimension: prior_created_week_flag {
    description: "The created date is in the past complete week"
    type: yesno
    sql: ((((${created_date}) >= ((SELECT (DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL))) AND
      (${created_date}) < ((SELECT ((DATE_TRUNC('week', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' week')::INTERVAL) + (1 || ' week')::INTERVAL)))))) ;;
  }

  dimension: prior_created_month_flag {
    description: "The created date is in the past complete month"
    type: yesno
    sql: ((((${created_date}) >= ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL))) AND
      (${created_date}) < ((SELECT ((DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-1 || ' month')::INTERVAL) + (1 || ' month')::INTERVAL)))))) ;;
  }


  dimension: resolved {
    type: yesno
    sql: ${archive_comment} is not null or ${complete_comment} is not null  ;;
  }

  dimension: esclated {
    type: yesno
    sql: ${complete_comment} is not null ;;
  }

  dimension: dx_visit {
    type: yesno
    sql: ${dx_conversions.patient_id} is not null ;;
  }

  dimension: self_report_sem_visit {
    type: yesno
    sql:  trim(lower(${channel_items.name})) = 'google or other search' ;;
  }


  dimension: phone_sem_visit {
    type: yesno
    sql:  ${genesys_conversation_summary_sem.queuename} is not null ;;
  }


  dimension: dx_or_self_report_or_phone_dtc_visit {
    type: yesno
    sql: ${dx_visit} or ${phone_sem_visit} or ${self_report_dtc_visit_no_sem} or ${self_report_sem_visit} ;;
  }

  dimension: self_report_dtc_visit{
    type: yesno
    sql: ${channel_items.high_level_category_new} = 'Direct to Consumer';;
  }

  dimension: self_report_dtc_visit_no_sem{
    type: yesno
    sql: ${channel_items.high_level_category_new} = 'Direct to Consumer' and not ${self_report_sem_visit};;
  }



  measure: complete_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
  }

  measure: complete_count_dx {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: dx_visit
      value: "yes"
    }
  }

  measure: complete_count_dx_or_self_report_or_phone_dtc{
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: dx_or_self_report_or_phone_dtc_visit
      value: "yes"
    }
  }

  measure: complete_count_phone_sem {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: phone_sem_visit
      value: "yes"
    }
  }


  measure: complete_count_self_report_sem {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: self_report_sem_visit
      value: "yes"
    }
    filters: {
      field: phone_sem_visit
      value: "no"
    }
  }

  measure: complete_count_dx_exclude{
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: dx_visit
      value: "yes"
    }
    filters: {
      field: self_report_sem_visit
      value: "no"
    }
    filters: {
      field: phone_sem_visit
      value: "no"
    }
  }

  measure: complete_dt_self_report_no_sem{
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: self_report_dtc_visit_no_sem
      value: "yes"
    }
    filters: {
      field: dx_visit
      value: "no"
    }
    filters: {
      field: self_report_sem_visit
      value: "no"
    }
    filters: {
      field: phone_sem_visit
      value: "no"
    }
  }

  measure: dtc_check {
    type: number
    sql: ${complete_dt_self_report_no_sem}+${complete_count_dx_exclude}+${complete_count_self_report_sem}+${complete_count_phone_sem} ;;
  }


  measure: dx_percent {
    type: number
    value_format: "0%"
    sql: case when  ${complete_count}>0 then  ${complete_count_dx}::float/ ${complete_count}::float else 0 end;;
    }

  measure: dx_or_self_report_or_phone_percent {
    type: number
    value_format: "0%"
    sql: case when  ${complete_count}>0 then  ${complete_count_dx_or_self_report_or_phone_dtc}::float/ ${complete_count}::float else 0 end;;
  }

  measure: phone_sem_percent {
    type: number
    value_format: "0%"
    sql: case when  ${complete_count}>0 then  ${complete_count_phone_sem}::float/ ${complete_count}::float else 0 end;;
  }

  measure: report_sem_percent {
    type: number
    value_format: "0%"
    sql: case when  ${complete_count}>0 then  ${complete_count_self_report_sem}::float/ ${complete_count}::float else 0 end;;
  }

  measure: dx_exclude_percent {
    type: number
    value_format: "0%"
    sql: case when  ${complete_count}>0 then  ${complete_count_dx_exclude}::float/ ${complete_count}::float else 0 end;;
  }


  measure: dt_self_report_no_sem_percent {
    type: number
    value_format: "0%"
    sql: case when  ${complete_count}>0 then  ${complete_dt_self_report_no_sem}::float/ ${complete_count}::float else 0 end;;
  }













  measure: complete_count_no_arm_advanced{
    label: "Complete Count (no arm, advanced or tele)"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters:  {
      field: cars.mfr_flex_car
      value: "no"
    }
    filters:  {
      field: cars.advanced_care_car
      value: "no"
    }
    filters:  {
      field: cars.telemedicine_car
      value: "no"
    }
    filters: {
      field: complete
      value: "yes"
    }
  }

  measure: complete_count_no_arm_only{
    label: "Complete Count (no arm, advanced)"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters:  {
      field: cars.mfr_flex_car
      value: "no"
    }
    filters:  {
      field: cars.advanced_care_car
      value: "no"
    }
    filters: {
      field: complete
      value: "yes"
    }
  }


  dimension: tele_eligible {
    type: yesno
    sql: ${risk_assessments.tele_eligible_protocol} and ${patients.age} > 2 and ${risk_assessments.score} <5.5 and ${insurance_coalese_crosswalk.tele_packages};;
  }


  measure: complete_count_kaiser{
    label: "Complete Count (Kaiser)"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters:  {
      field: insurance_coalese_crosswalk.kaiser_colorado
      value: "yes"
    }
    filters: {
      field: complete
      value: "yes"
    }
  }


  measure: complete_tele_eligible{
    type: count_distinct
    sql: ${care_request_id} ;;
    filters:  {
      field: tele_eligible
      value: "yes"
    }
    filters: {
      field: complete
      value: "yes"
    }
  }


  measure: tele_eligible_percent{
    type: number
    value_format: "0%"
    sql: case when ${complete_count}>0 then ${complete_tele_eligible}::float /${complete_count}::float else 0 end;;
  }




  measure: complete_count_advanced{
    type: count_distinct
    sql: ${care_request_id} ;;
    filters:  {
      field: cars.advanced_care_car
      value: "yes"
    }
    filters: {
      field: complete
      value: "yes"
    }
  }

  measure: complete_count_telemedicine{
    type: count_distinct
    sql: ${care_request_id} ;;
    filters:  {
      field: cars.telemedicine_car
      value: "yes"
    }
    filters: {
      field: complete
      value: "yes"
    }
  }




  measure: accepted_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: accepted
      value: "yes"
    }
  }

  measure: accepted_or_scheduled_count {
    label: "Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled) Count"
    type: sum_distinct
    value_format: "0"
    sql: case when ${booked_resolved} then .7 else 1 end ;;
    sql_distinct_key:  ${care_request_id} ;;
    filters: {
      field: accepted_or_scheduled
      value: "yes"
    }
  }

  measure: accepted_or_scheduled_phone_count {
    label: "Accepted, Scheduled (Acute-Care) or Booked Resolved (.7 scaled) Count"
    type: sum_distinct
    value_format: "0"
    sql: case when ${booked_resolved} then .7 else 1 end ;;
    sql_distinct_key:  ${care_request_id} ;;
    filters: {
      field: accepted_or_scheduled
      value: "yes"
    }
    filters: {
      field: care_requests.request_type_phone_or_other
      value: "phone"
    }
  }


    measure: complete_count_medicaid {
      type: count_distinct
      sql: ${care_request_id} ;;
      filters: {
        field: complete
        value: "yes"
      }
      filters: {
        field: insurance_coalese_crosswalk.custom_insurance_grouping
        value: "(MAID)MEDICAID"
      }
    }

  measure: complete_count_tricare {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: insurance_coalese_crosswalk.custom_insurance_grouping
      value: "(TC)TRICARE"
    }
  }

  dimension: payer_tricare {
    type:  yesno
    description: "Insurance/Payer custom group is Tricare"
    sql: trim(lower(${insurance_coalese_crosswalk.custom_insurance_grouping})) LIKE '(tc)tricare' ;;

  }

  measure: complete_count_medicaid_tricare {
    type: number
    sql: ${complete_count_medicaid}+${complete_count_tricare} ;;
  }


  dimension: flu_chief_complaint {
    type: yesno
    sql:
    (lower(${care_requests.chief_complaint}) like '%cough%'
    OR
    lower(${care_requests.chief_complaint}) like '%fever%'
    OR
    lower(${care_requests.chief_complaint}) like '%diarrhea%'
    OR
    lower(${care_requests.chief_complaint}) like '%upper respiratory%'
    OR
    lower(${care_requests.chief_complaint}) like '%sore throat%'
    OR
    lower(${care_requests.chief_complaint}) like '%uri'
    OR
    lower(${care_requests.chief_complaint}) like '%uri %'
    OR
    lower(${care_requests.chief_complaint}) like '%uri/%'
    OR
    trim(lower(${care_requests.chief_complaint})) = 'uri'
    OR
    lower(${care_requests.chief_complaint}) like '%flu'
    OR
    lower(${care_requests.chief_complaint}) like '%flu %'
    OR
    lower(${care_requests.chief_complaint}) like '%flu/%'
    OR
    trim(lower(${care_requests.chief_complaint})) = 'flu')
    and not ${risk_assessments.asymptomatic_covid_testing};;
  }

  measure: complete_count_flu {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: athenadwh_icdcodeall.likely_flu_diganosis
      value: "yes"
    }
  }

  measure: complete_count_flu_chief_complaint {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: flu_chief_complaint
      value: "yes"
    }
  }

  measure: complete_count_communicable_protocol {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: risk_assessments.communicable_protocol
      value: "yes"
    }
  }

  measure: complete_count_asymptomatic_covid_testing {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: risk_assessments.asymptomatic_covid_testing
      value: "yes"
    }
  }

  measure: complete_count_asymptomatic_covid_testing_overflow {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: risk_assessments.asymptomatic_covid_testing
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "yes"
    }
  }



  measure: flu_percent {
    type: number
    value_format: "0.0%"
    sql: ${complete_count_flu}::float/nullif(${complete_count}::float,0);;
  }


  measure: asymptomatic_covid_testing_percent {
    type: number
    value_format: "0.0%"
    sql: ${complete_count_asymptomatic_covid_testing}::float/nullif(${complete_count}::float,0);;
  }

  measure: communicable_protocol_percent{
    type: number
    value_format: "0.0%"
    sql: ${complete_count_communicable_protocol}::float/nullif(${complete_count}::float,0);;
  }

  measure: communicable_and_asymptomatic_covid_testing_percent{
    type: number
    value_format: "0.0%"
    sql: ${communicable_protocol_percent}::float+${asymptomatic_covid_testing_percent}::float;;
  }


  measure: flu_percent_chief_complaint {
    type: number
    value_format: "0.0%"
    sql: ${complete_count_flu_chief_complaint}::float/nullif(${complete_count}::float,0);;
  }




  dimension: new_care_request_complete_bool {
    type:  yesno
    sql:  (${care_requests.care_request_patient_create_diff}< (60*60) or ${visit_facts_clone.new_patient}=1)  and  ${complete_date} is not null;;
  }



  measure: complete_count_new {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: new_care_request_complete_bool
      value: "yes"
    }
  }

  measure: care_request_count {
    type: count_distinct
    sql: ${care_request_id} ;;
  }

  measure: care_request_count_uhc {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: channel_items.uhc_care_request
      value: "yes"
    }
  }


  measure: resolved_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: resolved
      value: "yes"
    }
  }

  measure: complete_rate {
    type: number
    value_format: "0%"
    sql: ${complete_count}::float/nullif(${care_request_count}::float,0) ;;
  }

  measure: max_on_scene_day_of_month {
    type: number
    sql: max(${on_scene_day_of_month}) ;;
  }

  measure: max_created_day_of_month {
    type: number
    sql: max(${created_day_of_month}) ;;
  }

  measure: month_percent {
    type: number
    sql:

        case when to_char(${max_day_on_scene} , 'YYYY-MM') != ${yesterday_mountain_month} then 1
        else
            extract(day from ${yesterday_mountain_date})
          /    DATE_PART('days',
              DATE_TRUNC('month', ${yesterday_mountain_date})
              + '1 MONTH'::INTERVAL
              - '1 DAY'::INTERVAL
          ) end;;
  }

 measure:  days_in_quarter{
   type: number
  sql: case when EXTRACT(QUARTER FROM ${max_on_scene_raw}) = 1  then 90
            when EXTRACT(QUARTER FROM ${max_on_scene_raw}) = 2   then 91
            when EXTRACT(QUARTER FROM ${max_on_scene_raw}) = 3 then 92
            when EXTRACT(QUARTER FROM ${max_on_scene_raw}) = 4   then 92
            else null end;;
 }
  measure: days_left_in_quarter {
    type: number
    sql:
       (  CAST(date_trunc('quarter',  ${yesterday_mountain_date})  + interval '3 months' - interval '1 day' AS date) - CAST( ${yesterday_mountain_date} AS date))
;;
  }

  measure: quarter_percent{
    type: number
    sql: case when ${max_on_scene_quarter} != ${yesterday_mountain_quarter} then 1
    else
      (${days_in_quarter}::float-${days_left_in_quarter}::float)/${days_in_quarter}::float end
     ;;
  }
  measure: month_percent_created {
    type: number
    sql:

        case when to_char(${max_created_date} , 'YYYY-MM') != ${yesterday_mountain_month} then 1
        else
            extract(day from ${yesterday_mountain_date})
          /    DATE_PART('days',
              DATE_TRUNC('month', ${yesterday_mountain_date})
              + '1 MONTH'::INTERVAL
              - '1 DAY'::INTERVAL
          ) end;;
  }


  measure: monthly_visits_run_rate {
    type: number
    sql: round(${complete_count}/${month_percent});;
  }

  measure: quarterly_complete_run_rate {
    type: number
    sql: round(${complete_count}/${quarter_percent});;
  }

  measure: quarterly_complete_run_rate_seaosonal_adj {
    label: "Quarterly Complete Run Rate Seasonal Adj"
    type: number
    sql: round(${complete_count_seasonal_adj}/${quarter_percent});;
  }


  measure: monthly_accepted_run_rate {
    type: number
    sql: round(${accepted_count}/${month_percent});;
  }

  measure: monthly_new_patients_run_rate{
    type: number
    sql: round(${count_new_patient_first_visits}/${month_percent});;
  }

  measure: overflow_visits_run_rate {
    type: number
    value_format: "0"
    sql: round(${count_overflow}::float/${month_percent});;
  }


  measure: care_request_count_run_rate {
    type: number
    value_format: "0"
    sql:  ${care_request_count}/${month_percent};;
  }

  measure: complete_count_flu_run_rate {
    type: number
    value_format: "0"
    sql:  ${complete_count_flu}/${month_percent};;
  }

  measure: count_distinct_care_requests_phone_run_rate {
    type: number
    value_format: "0"
    sql:  ${care_requests.count_distinct__care_requests_phone}/${month_percent};;
  }

  measure: count_distinct_care_requests_other_run_rate {
    type: number
    value_format: "0"
    sql:  ${care_requests.count_distinct_care_requests_other}/${month_percent};;
  }

  measure: monthly_complete_run_rate_seasonal_adj {
    type: number
    value_format: "#,##0"
    sql: (
           (
            ${complete_count}/${month_percent}
           )
          /${seasonal_adj.seasonal_adj}
         )
        /${days_in_month_adj.days_in_month_adj};;
  }


  dimension: rolling_30_day {
    type: string
    sql:
    case when ${on_scene_date} >= current_date - interval '30 day' then 'past 30 days'
    when  ${on_scene_date} between current_date - interval '60 day' and  current_date - interval '30 day' then 'previous 30 days'
    else null end;;
  }

  dimension: rolling_90_day {
    type: string
    sql:
    case when ${on_scene_date} >= current_date - interval '90 day' then 'past 90 days'
    when  ${on_scene_date} between current_date - interval '180 day' and  current_date - interval '90 day' then 'previous 90 days'
    else null end;;
  }

  dimension: complete_month_number {
    type:  number
    sql: EXTRACT(MONTH from ${complete_raw}) ;;
  }

  dimension: days_in_month {
    type: number
    sql:
     case when to_char(${requested_date} , 'YYYY-MM') = ${yesterday_mountain_month} then ${yesterday_mountain_day_of_month}
    else
      DATE_PART('days',
        DATE_TRUNC('month', ${requested_date})
        + '1 MONTH'::INTERVAL
        - '1 DAY'::INTERVAL
    ) end ;;
  }

  dimension: days_in_month_on_scene {
    type: number
    sql:
     case when to_char(${on_scene_date} , 'YYYY-MM') = ${yesterday_mountain_month} then ${yesterday_mountain_day_of_month}
    else
      DATE_PART('days',
        DATE_TRUNC('month', ${on_scene_date})
        + '1 MONTH'::INTERVAL
        - '1 DAY'::INTERVAL
    ) end ;;
  }

  dimension: days_in_month_complete {
    type: number
    sql:
     case when to_char(${complete_date} , 'YYYY-MM') = ${yesterday_mountain_month} then ${yesterday_mountain_day_of_month}
    else
      DATE_PART('days',
        DATE_TRUNC('month', ${on_scene_date})
        + '1 MONTH'::INTERVAL
        - '1 DAY'::INTERVAL
    ) end ;;
  }

  dimension: days_in_month_created {
    type: number
    sql:
     case when to_char(${created_date} , 'YYYY-MM') = ${yesterday_mountain_month} then ${yesterday_mountain_day_of_month}
    else
      DATE_PART('days',
        DATE_TRUNC('month', ${created_date})
        + '1 MONTH'::INTERVAL
        - '1 DAY'::INTERVAL
    ) end ;;
  }

  dimension: first_half_month {
    type: yesno
    sql: ${complete_day_of_month} <= 15 ;;
  }

  dimension: ga_high_level_category {
    type: string
    label: "Direct to Consumer Category"
    sql: coalesce((case when ${ga_pageviews_clone.high_level_category} in('Other', 'Self Report Direct to Consumer') then null else ${ga_pageviews_clone.high_level_category} end), ${web_ga_pageviews_clone.high_level_category}) ;;
  }

  measure: dtc_agg_category {
    type: string
    sql: array_agg(${ga_high_level_category})::text ;;
  }

  measure: dtc_agg_category_hiearchy{
    type: string
    sql: case when ${dtc_agg_category} like '%SEM: Non-Brand%' then 'SEM: Non-Brand'
     when ${dtc_agg_category}  like '%SEM: Brand%' then 'SEM: Brand'
    when ${dtc_agg_category}  like '%Display%' then 'Display'
     when ${dtc_agg_category}  like '%Local Listings%' then 'Local Listings'
     when ${dtc_agg_category} like '%Organic Search%' then 'Organic Search'
      when ${dtc_agg_category}  like '%Other%' then 'Other'
      when ${dtc_agg_category}  like '%Self Report Direct to Consumer%' then 'Self Report Direct to Consumer'
   else null
end  ;;
  }


  dimension: ga_projections_category {
    type: string
    label: "Projections Direct to Consumer Category"
    sql: coalesce((case when ${ga_pageviews_clone.projection_category} = 'Other' then null else ${ga_pageviews_clone.projection_category} end), ${web_ga_pageviews_clone.projection_category}) ;;
  }

  dimension: ga_intent {
    type: string
    label: "High/Low Intent"
    sql: coalesce(${ga_pageviews_clone.high_low_intent}, ${web_ga_pageviews_clone.high_low_intent}) ;;
  }

  measure: min_complete_timestamp {
    type: date_time
    sql: min(${complete_raw}) ;;
  }

  measure: max_complete_timestamp {
    type: date_time
    sql: max(${complete_raw}) ;;
  }

  dimension: weekend_after_3pm {
    description: "A flag indicating the care request took place after 3PM or on the weekend"
    type: yesno
    sql: ${on_scene_hour_of_day} > 15 OR ${on_scene_day_of_week_index} IN (5, 6)  ;;
  }

  dimension: high_acuity_visit {
    type: yesno
    sql: ${diversions_by_care_request.diversion} OR ${care_request_flat.escalated_on_scene} OR ${care_requests.post_acute_follow_up};;
  }

  measure: count_high_acuity_visits {
    type: count_distinct
    description: "Count of visits that met a diversion criteria or were PAFU or were escalated on scene"
    sql: ${care_request_id} ;;
    filters: {
      field: high_acuity_visit
      value: "yes"
    }
  }

  dimension: patient_age_month {
    type: number
    sql:  extract(year from age(${care_requests.created_raw}, ${patients.created_raw}))*12 + extract(month from age(${care_requests.created_raw},  ${patients.created_raw})) ;;
  }

  dimension: patient_age_month_min_complete_date {
    type: number
    sql:  extract(year from age(${care_requests.created_raw}, ${min_patient_complete_visit.min_complete_raw}))*12 + extract(month from age(${care_requests.created_raw},  ${min_patient_complete_visit.min_complete_raw})) ;;
  }

  dimension: patient_age_month_absolute {
    type: number
    sql:  extract(year from age('2018-10-01', ${patients.created_raw}))*12 + extract(month from age('2018-10-01',  ${patients.created_raw})) ;;
  }
  dimension: secondary_screening {
    type: yesno
    sql: ${secondary_screenings.care_request_id} is not null;;
  }

  dimension_group: now_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month, time_of_day,raw]
    sql:  now();;
  }

  dimension: created_mountain_decimal {
    type: number
    value_format: "0.00"
    sql:
    (CAST(EXTRACT(HOUR FROM ${created_mountain_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${created_mountain_raw} ) AS FLOAT)) / 60);;
  }

  dimension: now_mountain_decimal {
    type: number
    value_format: "0.00"
    sql:
    (CAST(EXTRACT(HOUR FROM ${now_mountain_raw}) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${now_mountain_raw} ) AS FLOAT)) / 60);;
  }

  dimension: timezone_too_late {
    type: number
    value_format: "0.00"
    sql:case when ${markets.name} in('Richmond', 'Olympia') then
   (CAST(EXTRACT(HOUR FROM '2099-12-01 18:30'::timestamp  AT TIME ZONE ${timezones.pg_tz}) AS INT)) +
    ((CAST(EXTRACT(MINUTE FROM '2099-12-01 18:30'::timestamp  AT TIME ZONE ${timezones.pg_tz} ) AS FLOAT)) / 60)
    else
        (CAST(EXTRACT(HOUR FROM '2099-12-01 19:30'::timestamp  AT TIME ZONE ${timezones.pg_tz}) AS INT)) +
    ((CAST(EXTRACT(MINUTE FROM '2099-12-01 19:30'::timestamp  AT TIME ZONE ${timezones.pg_tz} ) AS FLOAT)) / 60)
    end;;
  }


  dimension: before_now {
    type: yesno
    sql:  ${created_mountain_decimal} <= ${now_mountain_decimal} OR ${created_mountain_decimal} >= ${timezone_too_late}  ;;
  }

  dimension: too_late_for_overflow {
    type: yesno
    sql: ${created_mountain_decimal} >= case when ${markets.name} in('Richmond', 'Olympia') then
    (CAST(EXTRACT(HOUR FROM '2099-12-01 18:30'::timestamp  AT TIME ZONE ${timezones.pg_tz}) AS INT)) +
    ((CAST(EXTRACT(MINUTE FROM '2099-12-01 18:30'::timestamp  AT TIME ZONE ${timezones.pg_tz} ) AS FLOAT)) / 60)
    else
        (CAST(EXTRACT(HOUR FROM '2099-12-01 19:30'::timestamp  AT TIME ZONE ${timezones.pg_tz}) AS INT)) +
    ((CAST(EXTRACT(MINUTE FROM '2099-12-01 19:30'::timestamp  AT TIME ZONE ${timezones.pg_tz} ) AS FLOAT)) / 60)
    end;;
  }


  dimension: max_time_mountain_predictions {
    type: number
    sql:  case when ${markets.id} in(159, 160, 167) then 21
               when ${markets.id} in(164, 168) then 19
               when ${markets.id} in(166, 169, 165) then 20
               when ${markets.id} in(162, 170, 161) then 22
              else 21 end;;
  }

  dimension: prediction_elgible {
    type: yesno
    sql: ${created_mountain_decimal} < ${max_time_mountain_predictions} ;;
  }

  dimension: origin_phone_not_populated {
    type: yesno
    sql: ${origin_phone} IS NULL
         OR LENGTH(${origin_phone}) = 0
        OR (${origin_phone}) = '';;
  }

  measure: origin_phone_populated_count {
    type: count_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${care_request_id} ;;
    filters: {
      field: origin_phone_not_populated
      value: "no"
    }
  }
  measure: percent_origin_phone_populated {
    type: number
    value_format: "0%"
    sql: ${origin_phone_populated_count}::float/${care_request_count}::float ;;

  }

  dimension: contact_id_not_populated {
    type: yesno
    sql: ${contact_id} IS NULL;;
  }

  measure: contact_id_populated_count {
    type: count_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${care_request_id} ;;
    filters: {
      field: contact_id_not_populated
      value: "no"
    }
  }
  measure: percent_contact_id_populated {
    type: number
    value_format: "0%"
    sql: ${contact_id_populated_count}::float/${care_request_count}::float ;;

  }

  dimension: new_patient_first_visit {
    description: "Flags a patient that had their first visit date occurr within the date range of the filtered population (patient may have 1+ visits in range)."
    type: yesno
    sql: ${first_visit_date} = ${on_scene_date};;
  }

  measure: count_new_patient_first_visits {
    description: "Counts the number of distinct patients visited for the first time wihtin the date range of the fitered population (patient may have 1+ visits in range)"
    type: count_distinct
    sql: ${patient_id} ;;
    filters: {
      field: new_patient_first_visit
      value: "yes"
    }
  }

  dimension: return_patient {
    description: "Determines a patient that has been visited more than one time on separate days"
    type: yesno
    sql: ${first_visit_date} != ${on_scene_date};;
  }

  measure: count_return_patients {
    description: "Count of the number of distinct patients that have been visited more than one time by DH on separate days"
    type: count_distinct
    sql: ${patient_id} ;;
    filters: {
      field: return_patient
      value: "yes"
    }
  }

  measure: count_return_patient_visits {
    description: "Counts the number visits associated with a repeat patient for spearate days"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: return_patient
      value: "yes"
    }
  }

  dimension: overflow_visit {
    description: "Care Requests that were pushed to next day from their intended visit date. Excludes PAFU and only includes 'acute' service lines."
    type: yesno
    sql: (not ${pafu_or_follow_up}) and ${scheduled_visit} and lower(${service_lines.name}) like '%acute%'
         AND
        (
          ${created_date} != ${on_scene_date}
          OR
         ${on_scene_date} is null
        )
        AND
        (
          ${created_date} != ${archive_date}
        OR
          ${archive_date} is NULL
        )
        AND
        ${created_date} != ${scheduled_care_date}
        AND
        ${notes_aggregated.notes_aggregated} not like '%pushed pt: pt availability%'
        and not ${too_late_for_overflow}
        ;;
  }

  dimension: accepted_date_same_created_date {
    type: yesno
    sql: ${accept_initial_date} = ${created_date} ;;
  }

  dimension: archived {
    type: yesno
    sql: ${archive_date} is not null ;;
  }

  measure: count_distinct_bottom_funnel_care_requests {
    description: "Count of distinct care requests w/o phone screened"
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: escalated_on_phone
      value: "no"
    }
  }

  measure: count_complete_same_day {
    type: count_distinct
    description: "Count of completed care requests OR on-scene escalations (Same Day)"
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
  }



  measure: count_complete_overflow {
    type: count_distinct
    description: "Count of completed care requests OR on-scene escalations (Not Same Day)"
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "yes"
    }
  }



  measure: limbo_overflow {
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: not_resolved_or_complete
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "yes"
    }
  }

  measure: limbo_non_overflow {
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: not_resolved_or_complete
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
  }

    measure: count_overflow {
    type: count_distinct
    description: "Count of all Overflow visits"
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: overflow_visit
      value: "yes"
    }
  }



  measure: count_resolved_overflow {
    type: count_distinct
    description: "Count of completed care requests OR on-scene escalations (Not Same Day)"
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: complete
      value: "no"
    }
    filters: {
      field: archived
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "yes"
    }
  }

  measure: lwbs_minus_overflow {
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: lwbs
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: complete
      value: "no"
    }
  }

  measure: no_answer_no_show_count_minus_overflow{
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: resolved_no_answer_no_show
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: complete
      value: "no"
    }
  }

  dimension: clinical_service_not_offered {
    type: yesno
    sql: lower(${archive_comment}) LIKE '%clinical service not offered (scope)%' and not ${covid_resolved};;
  }
  measure: clinical_service_not_offered_minus_overflow{
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: clinical_service_not_offered
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: complete
      value: "no"
    }
  }

  dimension: covid_resolved {
    type: yesno
    sql: lower(${archive_comment}) LIKE '%covid%' or lower(${archive_comment}) LIKE '%corona%'  ;;
  }

  measure: covid_resolved_minus_overflow{
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: covid_resolved
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: complete
      value: "no"
    }
  }

  dimension: insurance_resolved {
    type: yesno
    sql: lower(${archive_comment}) LIKE '%no insurance / financial%' or lower(${archive_comment}) LIKE '%insurance not contracted (out of network)%'  ;;
  }

  measure: insurance_resolved_minus_overflow{
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: insurance_resolved
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: complete
      value: "no"
    }
  }

  dimension: poa_resolved {
    type: yesno
    sql: lower(${archive_comment}) LIKE '%unable to obtain consent from poa or patient%'  ;;
  }

  measure: poa_resolved_minus_overflow{
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: poa_resolved
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: complete
      value: "no"
    }
  }

  dimension: zipcode_resolved {
    type: yesno
    sql: lower(${archive_comment}) LIKE '%not in service area%'  ;;
  }

  measure: zipcode_resolved_minus_overflow{
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: zipcode_resolved
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: complete
      value: "no"
    }
  }

  dimension: cancelled_by_patient_other_resolved {
    type: yesno
    sql: lower(${archive_comment}) LIKE '%cancelled by patient%' and lower(${archive_comment}) LIKE '%other%' and not ${covid_resolved} and not ${booked_shaping_placeholder_resolved} ;;
  }

  measure: cancelled_by_patient_other_resolved_minus_overflow{
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: cancelled_by_patient_other_resolved
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: complete
      value: "no"
    }
  }

  dimension: insufficient_information_resolved {
    type: yesno
    sql: lower(${archive_comment}) LIKE '%unable to fulfill request: insufficient information to create care request (referral)%' and not ${booked_shaping_placeholder_resolved}  ;;
  }

  measure: insufficient_information_resolved_minus_overflow{
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: insufficient_information_resolved
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: complete
      value: "no"
    }
  }
  measure: lwbs_rate_bottom_funnel_minus_overflow
  {
    value_format: "0%"
    type: number
    sql: case when${count_distinct_bottom_funnel_care_requests} >0 then ${lwbs_minus_overflow}/${count_distinct_bottom_funnel_care_requests} else 0 end ;;
  }

  measure: lwbs_lost_raw
  {
    type: number
    sql: (${lwbs_rate_bottom_funnel_minus_overflow}-(.08))*${count_distinct_bottom_funnel_care_requests}*(.63);;
  }

  measure: lwbs_lost
  {
    type: number
    value_format: "#,##0"
    sql: case when ${lwbs_lost_raw} > 0 then ${lwbs_lost_raw} else 0 end  ;;
  }

  measure: overflow_complete_rate
  {
    value_format: "0%"
    type: number
    sql:
    case when  (${count_resolved_overflow}::float+${count_complete_overflow}::float) > 0.0 then  ${count_complete_overflow}::float/(${count_resolved_overflow}::float+${count_complete_overflow}::float)
    else 0.0
    end
    ;;
  }

  measure: overflow_lost
  {
    type: number
    value_format: "#,##0"
    sql: case when (.93-${overflow_complete_rate})*(${count_resolved_overflow}+${count_complete_overflow}) >0 then (.93-${overflow_complete_rate})*(${count_resolved_overflow}+${count_complete_overflow})
      else 0 end
      ;;
  }

  measure: booked_shaping_lost
  {
    type: number
    value_format: "#,##0"
    sql: .63*${booked_shaping_placeholder_resolved_count_minus_overflow}
      ;;
  }

  measure: limbo_overflow_lost
  {
    type: number
    value_format: "#,##0"
    sql: ${care_request_flat.limbo_overflow}*(.3)
      ;;
  }

  measure: total_lost
  {
    type: number
    label: "Total Lost Due to Capacity Constraints"
    value_format: "#,##0"
    sql: case when ${booked_shaping_lost} is not null then ${booked_shaping_lost} else 0 end
        +
        case when ${lwbs_lost} is not null then ${lwbs_lost} else 0 end
        +
        case when ${overflow_lost} is not null then ${overflow_lost} else 0 end
        +
        case when ${limbo_overflow_lost} is not null then ${limbo_overflow_lost} else 0 end
      ;;
  }

  measure: complete_plus_total_lost {
    value_format: "0"
    type: number
    sql:  ${total_lost}+${complete_count};;
  }

  measure: total_lost_percent{
    label: "Total Captured Percent (Bottom of Funnel)"
    value_format: "0%"
    type: number
    sql:  case when ${complete_plus_total_lost}>0 then ${complete_count}::float/${complete_plus_total_lost}::float else 0 end;;
  }

  measure: total_lost_above_baseline
  {
    type: number
    label: "Total Lost Due to Capacity Constraints Above Baseline (2.5%)"
    value_format: "#,##0"
    sql: case when ${total_lost}-(${count_distinct_bottom_funnel_care_requests}*.025) >0 then ${total_lost}-(${count_distinct_bottom_funnel_care_requests}*25/1000)
    else 0 end
      ;;
  }


  measure: booked_shaping_placeholder_resolved_count_minus_overflow {
    description: "Care requests resolved for booked, shaping or placeholder"
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: booked_shaping_placeholder_resolved
      value: "yes"
    }
    filters: {
      field: overflow_visit
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: complete
      value: "no"
    }
  }

  measure: resolved_other_count_bottom_funnel {
    type: count_distinct
    sql: ${care_request_id} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: complete
      value: "no"
    }
    filters: {
      field: lwbs
      value: "no"
    }
    filters: {
      field: escalated_on_phone
      value: "no"
    }
    filters: {
      field: booked_shaping_placeholder_resolved
      value: "no"
    }
    filters: {
      field: resolved_no_answer_no_show
      value: "no"
    }

    filters: {
      field: complete
      value: "no"
    }

    filters: {
      field: not_resolved_or_complete
      value: "no"
    }
    filters: {
      field: overflow_visit
      value: "no"
    }
    filters: {
      field: clinical_service_not_offered
      value: "no"
    }

    filters: {
      field: covid_resolved
      value: "no"
    }

    filters: {
      field: insurance_resolved
      value: "no"
    }
    filters: {
      field: poa_resolved
      value: "no"
    }
    filters: {
      field: zipcode_resolved
      value: "no"
    }
    filters: {
      field: cancelled_by_patient_other_resolved
      value: "no"
    }
    filters: {
      field: insufficient_information_resolved
      value: "no"
    }
  }


}
