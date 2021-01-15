view:care_requests_post_visit {
  derived_table: {
    sql:

WITH pi AS (
SELECT
cr.id AS care_request_id,
cr.service_line_id,
cr.patient_id,
crs.on_scene_time
FROM public.care_requests cr
INNER JOIN (
SELECT
care_request_id,
MIN(created_at) AS on_scene_time
FROM public.care_request_statuses
WHERE name = 'complete'
GROUP BY 1) AS crs
ON cr.id = crs.care_request_id)
SELECT
pi1.patient_id,
pi1.care_request_id as anchor_care_request_id,
pi1.service_line_id as anchor_service_line_id,
pi1.on_scene_time as anchor_on_scene_time,
pi2.care_request_id as post_anchor_care_request_id,
pi2.service_line_id as post_anchor_service_line_id,
pi2.on_scene_time as post_anchor_on_scene_time,
(extract(epoch from pi2.on_scene_time) -  extract(epoch from pi1.on_scene_time))::INT AS seconds_from_anchor_visit
FROM pi AS pi1
LEFT JOIN pi AS pi2
ON pi1.patient_id = pi2.patient_id
WHERE pi2.on_scene_time > pi1.on_scene_time
GROUP BY 1,2,3,4,5,6,7,8
ORDER BY 1,2,3,4,5,6,7,8;;

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
    description: "Base Care Request Id of which future visits will be counted for a given patient"
    type: number
    sql:  ${TABLE}.anchor_care_request_id ;;
  }

  dimension: anchor_service_line_id {
    description: "Base visit service Line Id of which future visits will be counted for a given patient"
    type: string
    sql:  ${TABLE}.anchor_service_line_id ;;
  }

  dimension: anchor_on_scene_time {
    description: "Base visit on-scene time of which future visits will be counted for a given patient"
    type: date_time
    sql:  ${TABLE}.anchor_on_scene_time ;;
  }

  dimension: post_anchor_care_request_id {
    description: "Future Care Request Id (occurring after base visit) for a given patient"
    type: number
    sql:  ${TABLE}.post_anchor_care_request_id ;;
  }

  dimension: post_anchor_service_line_id {
    description: "Future visit Service Line Id (occurring after base visit) for a given patient"
    type: string
    sql:  ${TABLE}.post_anchor_service_line_id ;;
  }

  dimension: post_anchor_on_scene_time {
    description: "Future visit on-scene time (occurring after base visit) for a given patient"
    type: date_time
    sql:  ${TABLE}.post_anchor_on_scene_time ;;
  }

  dimension: seconds_from_anchor_visit {
    description: "Future visit seconds from base visit time (occurring after base visit) for a given patient"
    type: number
    sql:  ${TABLE}.seconds_from_anchor_visit ;;
  }

  dimension: visits_within_30_days_of_base_visit {
    description: "Identifies future visits that occur wihtin 30 days after the base visit "
    type: yesno
    sql: ${seconds_from_anchor_visit} / 3600 <= 720 ;;
  }

  measure:  count_visits_within_30_days_of_base_visit {
    description: "Count the number of future visits that occur within 30 days afterthe base visit"
    type: count_distinct
    sql: ${concat_anchor_post_care_request_id} ;;
    filters: {
      field: visits_within_30_days_of_base_visit
      value: "yes"
    }

    }


 }
