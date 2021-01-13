view: service_line_question_responses {
  view_label: "Race and Ethnicity Survey Responses"
  sql_table_name: public.service_line_question_responses ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."id" ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
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

  dimension: responses {
    type: string
    hidden: yes
    sql: ${TABLE}."responses" ;;
  }

  dimension: service_line_id {
    type: number
    hidden: yes
    sql: ${TABLE}."service_line_id" ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
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

  dimension: user_id {
    type: number
    sql: ${TABLE}."user_id" ;;
  }

dimension: ethnicity {
  type: yesno
  description: "Do you identify as Hispanic or Latino?"
  sql: (((${TABLE}.responses #>> '{}')::jsonb ->> 1)::json ->> 'response')::boolean IS TRUE;;
}

  dimension: ethnicity_question_asked {
    type: yesno
    description: "Do you identify as Hispanic or Latino?"
    sql: (((${TABLE}.responses #>> '{}')::jsonb ->> 1)::json ->> 'response') IS NOT NULL;;
  }

  dimension: race_raw {
    type: string
    sql: UPPER(TRIM((((${TABLE}.responses #>> '{}')::jsonb ->> 2)::json ->> 'response')::varchar)) ;;
  }

  dimension: race_question_asked {
    type: yesno
    sql: UPPER(TRIM((((${TABLE}.responses #>> '{}')::jsonb ->> 2)::json ->> 'response')::varchar)) IS NOT NULL ;;
  }

  dimension: race {
    type: string
    description: "Which of the following terms best describes you?
    A.) American Indian or Alaska Native,
    B.) Black/African American,
    C.) Native Hawaiian or Pacific Islander,
    D.) Asian,
    E.) White,
    F.) Other Race,
    G.) Choose not to answer"
    sql: CASE WHEN ${race_raw} = 'A' OR ${race_raw} LIKE '%INDIAN%' THEN 'AMERICAN INDIAN'
          WHEN ${race_raw} = 'B' or ${race_raw} LIKE 'B.%' OR ${race_raw} LIKE '%AFRICAN/AMERICAN%' OR ${race_raw} LIKE '%BLACK%' THEN 'BLACK/AFRICAN AMERICAN'
          WHEN ${race_raw} = 'C' or ${race_raw} LIKE 'C.%' THEN 'NATIVE HAWAIIAN OR PACIFIC ISLANDER'
          WHEN ${race_raw} LIKE 'D%' OR ${race_raw} LIKE '%ASIAN%' OR ${race_raw} LIKE '%ASAIN%' THEN 'ASIAN'
          WHEN ${race_raw} LIKE 'E%' OR ${race_raw} LIKE '%WHITE%' THEN 'WHITE'
          WHEN ${race_raw} LIKE 'F%' OR ${race_raw} LIKE '%OTHER%' THEN 'OTHER'
          WHEN ${race_raw} LIKE 'G%' THEN 'REFUSED'
          ELSE ${race_raw} END;;
  }

}
