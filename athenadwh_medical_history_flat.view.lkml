view: athenadwh_medical_history_flat {
  derived_table: {
    sql:
    SELECT DISTINCT
  base.chart_id,
  CAST(rd.answer AS DATE) AS review_date,
  notes.answer AS notes,
  hyp.answer AS hypertension,
  hch.answer AS high_cholesterol,
  diabetes.answer AS diabetes,
  copd.answer AS copd,
  asthma.answer AS asthma,
  cnc.answer AS cancer,
  kd.answer AS kidney_disease,
  stroke.answer AS stroke,
  dep.answer AS depression,
  cad.answer AS coronary_artery_disease,
  pe.answer AS pulmonary_embolism
  FROM (
    SELECT DISTINCT chart_id
      FROM athenadwh_medical_history_clone
  ) AS base
  LEFT JOIN (
    SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
            FROM athenadwh_medical_history_clone
            WHERE question = 'Reviewed Date'
            GROUP BY 1,2,3,4
  ) AS rd
    ON base.chart_id = rd.chart_id AND rd.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
              WHERE question = 'Notes'
              GROUP BY 1,2,3,4
    ) AS notes
      ON base.chart_id = notes.chart_id AND notes.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'Hypertension'
        GROUP BY 1,2,3,4
    ) AS hyp
      ON base.chart_id = hyp.chart_id AND hyp.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'High Cholesterol'
        GROUP BY 1,2,3,4
    ) AS hch
      ON base.chart_id = hch.chart_id AND hch.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'Diabetes'
        GROUP BY 1,2,3,4
    ) AS diabetes
      ON base.chart_id = diabetes.chart_id AND diabetes.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'COPD'
        GROUP BY 1,2,3,4
    ) AS copd
      ON base.chart_id = copd.chart_id AND copd.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'Asthma'
        GROUP BY 1,2,3,4
    ) AS asthma
      ON base.chart_id = asthma.chart_id AND asthma.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'Cancer'
        GROUP BY 1,2,3,4
    ) AS cnc
      ON base.chart_id = cnc.chart_id AND cnc.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'Kidney Disease'
        GROUP BY 1,2,3,4
    ) AS kd
      ON base.chart_id = kd.chart_id AND kd.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'Stroke'
        GROUP BY 1,2,3,4
    ) AS stroke
      ON base.chart_id = stroke.chart_id AND stroke.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_medical_history_clone
          WHERE question = 'Depression'
          GROUP BY 1,2,3,4
      ) AS dep
        ON base.chart_id = dep.chart_id AND dep.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_medical_history_clone
          WHERE question = 'Coronary Artery Disease'
          GROUP BY 1,2,3,4
      ) AS cad
        ON base.chart_id = cad.chart_id AND cad.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_medical_history_clone
          WHERE question = 'Pulmonary Embolism'
          GROUP BY 1,2,3,4
      ) AS pe
        ON base.chart_id = pe.chart_id AND pe.rownum = 1
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14
    ORDER BY base.chart_id ;;

      sql_trigger_value: SELECT COUNT(*) FROM athenadwh_medical_history_clone ;;
      indexes: ["chart_id"]
    }

  view_label: "ZZZZ - Athenadwh Medical History Flat"

  dimension: chart_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.chart_id ;;
  }


  dimension: review_date {
    type: date
    sql: ${TABLE}.review_date ;;
  }

  dimension: history_captured {
    type: yesno
    sql: ${review_date} IS NOT NULL AND ${number_comorbidities} ;;
  }

  dimension: notes {
    type: string
    sql: ${TABLE}.notes ;;
  }

  dimension: hypertension {
    type: string
    sql: ${TABLE}.hypertension ;;
  }

  dimension: hypertension_flag {
    type: yesno
    sql: ${hypertension} IS NOT NULL AND ${hypertension} <> 'N' AND LOWER(${hypertension}) NOT SIMILAR TO '%(managed|resolved|borderline)%' ;;
  }

  dimension: high_cholesterol {
    type: string
    sql: ${TABLE}.high_cholesterol ;;
  }

  dimension: high_cholesterol_flag {
    type: yesno
    sql: ${high_cholesterol} = 'Y' OR LOWER(${high_cholesterol}) LIKE '%triglyceride%' ;;
  }

  dimension: diabetes {
    type: string
    sql: ${TABLE}.diabetes ;;
  }

  dimension: diabetes_flag {
    type: yesno
    sql: ${diabetes} = 'Y' OR LOWER(${diabetes}) SIMILAR TO '%(type|insulin|t2dm|t1dm|neuropathy|hypergly)%' ;;
  }

  dimension: copd {
    type: string
    sql: ${TABLE}.copd ;;
  }

  dimension: copd_flag {
    type: yesno
    sql: ${copd} IS NOT NULL AND ${copd} <> 'N' AND ${copd} NOT LIKE '%?%' ;;
  }

  dimension: asthma {
    type: string
    sql: ${TABLE}.asthma ;;
  }

  dimension: asthma_flag {
    type: yesno
    sql: ${asthma} IS NOT NULL AND ${asthma} <> 'N' AND LOWER(${asthma}) NOT LIKE '%unknown%' ;;
  }

  dimension: cancer {
    type: string
    sql: ${TABLE}.cancer ;;
  }

  dimension: cancer_flag {
    type: yesno
    sql: ${cancer} IS NOT NULL AND ${cancer} <> 'N' ;;
  }

  dimension: kidney_disease {
    type: string
    sql: ${TABLE}.kidney_disease ;;
  }

  dimension: kidney_disease_flag {
    type: yesno
    sql: ${kidney_disease} IS NOT NULL AND ${kidney_disease} <> 'N' ;;
  }

  dimension: stroke {
    type: string
    sql: ${TABLE}.stroke ;;
  }

  dimension: stroke_flag {
    type: yesno
    sql: ${stroke} IS NOT NULL AND ${stroke} <> 'N' ;;
  }

  dimension: depression {
    type: string
    sql: ${TABLE}.depression ;;
  }

  dimension: depression_flag {
    type: yesno
    sql: ${depression} IS NOT NULL AND ${depression} <> 'N' ;;
  }

  dimension: coronary_artery_disease {
    type: string
    sql: ${TABLE}.coronary_artery_disease ;;
  }

  dimension: coronary_artery_disease_flag {
    type: yesno
    sql: ${coronary_artery_disease} IS NOT NULL AND ${coronary_artery_disease} <> 'N' AND ${coronary_artery_disease} NOT LIKE '%?%' ;;
  }

  dimension: pulmonary_embolism {
    type: string
    sql: ${TABLE}.pulmonary_embolism ;;
  }

  dimension: pulmonary_embolism_flag {
    type: yesno
    sql: ${pulmonary_embolism} IS NOT NULL AND ${pulmonary_embolism} <> 'N' ;;
  }

  dimension: number_comorbidities {
    type: number
    description: "The number of patient's comorbidities"
    sql: CASE WHEN ${medical_history_collected} THEN (
          (CASE WHEN ${hypertension_flag} THEN 1 ELSE 0 END) +
          (CASE WHEN ${high_cholesterol_flag} THEN 1 ELSE 0 END) +
          (CASE WHEN ${diabetes_flag} THEN 1 ELSE 0 END) +
          (CASE WHEN ${copd_flag} THEN 1 ELSE 0 END) +
          (CASE WHEN ${asthma_flag} THEN 1 ELSE 0 END) +
          (CASE WHEN ${cancer_flag} THEN 1 ELSE 0 END) +
          (CASE WHEN ${kidney_disease_flag} THEN 1 ELSE 0 END) +
          (CASE WHEN ${stroke_flag} THEN 1 ELSE 0 END) +
          (CASE WHEN ${depression_flag} THEN 1 ELSE 0 END) +
          (CASE WHEN ${coronary_artery_disease_flag} THEN 1 ELSE 0 END) +
          (CASE WHEN ${pulmonary_embolism_flag} THEN 1 ELSE 0 END))
        ELSE NULL END ;;
  }

dimension: comorbidities_greater_0 {
  type: yesno
  sql: ${number_comorbidities} > 0 ;;
}

  measure: count_comorbidities_greater_0 {
    type: count_distinct
    sql: ${patients.id} ;;
    sql_distinct_key:  ${patients.id} ;;
    filters: {
      field: comorbidities_greater_0
      value: "yes"
    }
  }



  dimension: medical_history_collected {
    type: yesno
    sql: ${chart_id} IS NOT NULL;;
  }

  dimension: comorbidity_range {
    type: tier
    tiers: [2,5]
    style: integer
    sql: ${number_comorbidities} ;;
  }

  measure: count_distinct_charts {
    type: count_distinct
    sql: ${chart_id} ;;
  }

  measure: avg_num_comorbidities {
    type: average
    sql: ${number_comorbidities} ;;
  }

  measure: avg_distinct_num_comorbidities {
    type: average_distinct
    value_format: "0.00"
    sql_distinct_key: ${care_request_flat.care_request_id} ;;
    sql: ${number_comorbidities} ;;
  }

  measure: count {
    type: count
  }


}
