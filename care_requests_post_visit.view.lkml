view:care_requests_post_visit {
  derived_table: {
    sql:

WITH pi AS (
  SELECT
  cr.id AS care_request_id,
  cr.service_line_id,
  cr.patient_id,
  cr.chief_complaint,
  rp.protocol_name,
  crs.on_scene_time
  FROM public.care_requests cr
  INNER JOIN (
  SELECT
    care_request_id,
    MIN(created_at) AS on_scene_time
  FROM public.care_request_statuses
  WHERE name = 'complete'
  GROUP BY 1) AS crs
  ON cr.id = crs.care_request_id
  LEFT JOIN (
  SELECT care_request_id,
    protocol_name,
    updated_at,
    ROW_NUMBER() OVER (PARTITION BY care_request_id ORDER BY updated_at DESC) AS rownum
  FROM public.risk_assessments
  WHERE score IS NOT NULL
  GROUP BY 1,2,3) as rp
  ON cr.id = rp.care_request_id and rp.rownum = 1)

SELECT
  pi1.patient_id,
  pi1.care_request_id as anchor_care_request_id,
  pi1.service_line_id as anchor_service_line_id,
  pi1.on_scene_time as anchor_on_scene_time,
  pi2.care_request_id as post_anchor_care_request_id,
  pi2.service_line_id as post_anchor_service_line_id,
  pi2.protocol_name as post_anchor_risk_protocol_name,
  pi2.chief_complaint as post_anchor_chief_complaint,
  pi2.on_scene_time as post_anchor_on_scene_time,
  (extract(epoch from pi2.on_scene_time) -  extract(epoch from pi1.on_scene_time))::INT AS seconds_from_anchor_visit
FROM pi AS pi1
LEFT JOIN pi AS pi2
ON pi1.patient_id = pi2.patient_id
WHERE pi2.on_scene_time > pi1.on_scene_time
GROUP BY 1,2,3,4,5,6,7,8,9
ORDER BY 1,2,3,4,5,6,7,8,9;;


sql_trigger_value: SELECT COUNT(*) FROM care_requests ;;

indexes: ["patient_id", "anchor_care_request_id", "anchor_service_line_id", "anchor_on_scene_time", "post_anchor_care_request_id", "post_anchor_service_line_id", "post_anchor_on_scene_time"]
  }

  dimension: concat_anchor_post_care_request_id {
    primary_key: yes
    description: "Concatenated base care request id and future care request id for a given patient"
    type: string
    sql:  ${anchor_care_request_id} || '-' || ${post_anchor_care_request_id} ;;
  }

  dimension: patient_id {
    description: "DH Patient Id"
    type: number
    sql:  ${TABLE}.patient_id ;;
  }

  dimension: anchor_care_request_id {
    description: "Base Care Request Id for which future visits will be counted for a given patient"
    type: number
    sql:  ${TABLE}.anchor_care_request_id ;;
  }

  dimension: anchor_service_line_id {
    description: "Base visit service Line Id for which future visits will be counted for a given patient"
    type: string
    sql:  ${TABLE}.anchor_service_line_id ;;
  }

  dimension_group: anchor_on_scene_time {
    description: "Base visit on-scene time for which future visits will be counted for a given patient"
    type: time
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
    sql:  ${TABLE}.anchor_on_scene_time AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ;;
  }

  dimension: post_anchor_care_request_id {
    description: "Future Care Request Id (occurring after initial visit) for a given patient"
    type: number
    sql:  ${TABLE}.post_anchor_care_request_id ;;
  }

  dimension: post_anchor_service_line_id {
    description: "Future visit Service Line Id (occurring after initial visit) for a given patient"
    type: string
    sql:  ${TABLE}.post_anchor_service_line_id ;;
  }

  dimension: post_anchor_risk_protocol_name {
    description: "Future visit Risk Protocol Name (occurring after initial visit) for a given patient"
    type: string
    sql:  ${TABLE}.post_anchor_risk_protocol_name ;;
  }

  dimension: post_anchor_chief_complaint {
    description: "Future visit Chief Complaint (occurring after initial visit) for a given patient"
    type: string
    sql:  ${TABLE}.post_anchor_chief_complaint ;;
  }

  dimension_group: post_anchor_on_scene_time {
    description: "Future visit on-scene time (occurring after initial visit) for a given patient"
    type: time
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
    sql:  ${TABLE}.post_anchor_on_scene_time AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ;;
  }

  dimension: seconds_from_anchor_visit {
    description: "Future visit time in seconds from initial visit time (occurring after base visit) for a given patient"
    type: number
    sql:  ${TABLE}.seconds_from_anchor_visit ;;
  }

  dimension: visits_within_30_days_of_base_visit {
    description: "Identifies future visits that occur wihtin 30 days after the initial visit "
    type: yesno
    sql: ${seconds_from_anchor_visit} / 3600 <= 720 ;;
  }

  dimension: visits_within_3_days_of_base_visit {
    description: "Identifies future visits that occur wihtin 30 days after the initial visit "
    type: yesno
    sql: ${seconds_from_anchor_visit} / 3600 <= 72 ;;
  }

  dimension: dhfu_visits_post_base_visit {
    description: "Identifies DHFU visits for the same patient occurring after the initial visit (DHFU identified by Risk Protocol Name and Cheif Complaint)"
    type: yesno
    sql: lower(trim(${post_anchor_chief_complaint})) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
         trim(${post_anchor_risk_protocol_name}) SIMILAR TO 'DispatchHealth Acute Care - follow up visit%';;
  }

  measure:  count_visits_within_30_days_of_base_visit {
    description: "Count the number of future visits that occur within 30 days after the initial visit"
    type: count_distinct
    sql: ${concat_anchor_post_care_request_id} ;;
    filters: {
      field: visits_within_30_days_of_base_visit
      value: "yes"
    }
  }

  measure:  count_visits_within_3_days_of_base_visit {
    description: "Count the number of future visits that occur within 3 days after the initial visit"
    type: count_distinct
    sql: ${concat_anchor_post_care_request_id} ;;
    filters: {
      field: visits_within_3_days_of_base_visit
      value: "yes"
    }
  }

  measure:  count_distinct_dhfu_patient_visit_within_3_days_of_base_visit {
    label: "Count Distinct Patients With DHFU Within 3 Days"
    description: "Count the number of distinct patients with a DHFU follow up occurring within 3 days after the initial visit"
    type: count_distinct
    sql: ${patient_id} ;;
    filters: [dhfu_visits_post_base_visit: "yes",visits_within_3_days_of_base_visit: "yes"]
  }

  measure:  count_distinct_dhfu_patient_visit_within_30_days_of_base_visit {
    label: "Count Distinct Patients With DHFU Within 30 Days"
    description: "Count the number of distinct patients with a DHFU follow up occurring within 30 days after the initial visit"
    type: count_distinct
    sql: ${patient_id} ;;
    filters: [dhfu_visits_post_base_visit: "yes",visits_within_30_days_of_base_visit: "yes"]
  }

  measure:  count_dhfu_visits_within_30_days_of_base_visit {
    description: "Count DHFU visits for the same patient occurring within 30 days of the initial visit (DHFU identified by Risk Protocol Name and Cheif Complaint)"
    type: count_distinct
    sql: ${concat_anchor_post_care_request_id} ;;
    filters: [dhfu_visits_post_base_visit: "yes",visits_within_30_days_of_base_visit: "yes"]
  }

  measure:  count_distinct_visits_for_patient_in_30_days {
    description: "Counts the distinct visits for the same patient occurring within 30 days"
    type: count_distinct
    sql: ${post_anchor_care_request_id} ;;
    filters: [dhfu_visits_post_base_visit: "yes",visits_within_30_days_of_base_visit: "yes"]
  }

 }
