view: saved_care_requests {
  derived_table: {
    sql: SELECT
    cr1.id AS resolved_id,
    cr2.id AS completed_id
    FROM public.care_requests cr1
    INNER JOIN public.care_request_statuses crs1
        ON cr1.id = crs1.care_request_id AND crs1.name = 'archived' AND crs1.comment IS NOT NULL
    INNER JOIN public.care_requests cr2
        ON cr1.patient_id = cr2.patient_id AND DATE(cr1.created_at) = DATE(cr2.created_at)
    INNER JOIN public.care_request_statuses crs2
        ON cr2.id = crs2.care_request_id AND crs2.name = 'complete'
WHERE crs1.comment NOT LIKE '%Duplicate%' AND crs1.comment NOT LIKE '%Test%'
    GROUP BY 1,2
    ORDER BY 1 desc ;;
    sql_trigger_value:  SELECT MAX(id) FROM public.care_requests  where care_requests.created_at > current_date - interval '2 day';;
    indexes: ["resolved_id", "completed_id"]
    }

    dimension: resolved_id {
      sql: ${TABLE}.resolved_id ;;
    }
  dimension: completed_id {
    sql: ${TABLE}.completed_id ;;
  }

}
