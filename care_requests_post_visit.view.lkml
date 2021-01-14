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

  dimension: patient_id {
    description: "DH Patient Id"
    type: number
    sql:  ${TABLE}.patient_id ;;
  }


  dimension: anchor_care_request_id {
    description: "Care Request Id"
    type: number
    sql:  ${TABLE}.anchor_care_request_id ;;
  }

 }
