view: athena_social_history_zcode {

# sql_table_name: athena.patientsocialhistory ;;
# drill_fields: [id]
derived_table: {
  sql:
    WITH z AS (
    SELECT
          chart_id,
          CASE WHEN social_history_key = 'SOCIALHISTORY.LOCAL.91' AND (social_history_answer LIKE 'I Have Housing Today But%' OR
            social_history_answer LIKE 'I Do Not Have Housing%' OR
            social_history_answer LIKE 'Needs %') THEN 'Z59.1'
                WHEN ((social_history_key = 'SOCIALHISTORY.LOCAL.145' AND (social_history_answer LIKE 'Y%')) OR
                (social_history_key = 'SOCIALHISTORY.LOCAL.146' AND (social_history_answer LIKE 'Y%')) OR
                (social_history_key = 'SOCIALHISTORY.LOCAL.147' AND (social_history_answer LIKE 'Y%'))) THEN 'Z91.81'
                WHEN (social_history_key = 'SOCIALHISTORY.LOCAL.161' AND (social_history_answer LIKE 'Less Than Once%')) THEN 'ZSOC1'
                WHEN (social_history_key = 'SOCIALHISTORY.LOCAL.141' AND (social_history_answer LIKE 'Yes%')) THEN 'ZTRAN1'
                WHEN (social_history_key = 'SOCIALHISTORY.LOCAL.142' AND (social_history_answer LIKE 'Yes%')) THEN 'Z59.4'
                WHEN (social_history_key = 'SOCIALHISTORY.LOCAL.94' AND (social_history_answer IN ('Food','Housing','Medicine','Transportation','Utilities (gas or heat)'))) THEN 'Z59.8'
                WHEN (social_history_key = 'SOCIALHISTORY.LOCAL.85' AND (social_history_answer IN('Phone', 'Utilities (gas or heat)',
                                                                                                  'Medicine or any Healthcare (medical or dental or mental health or vision)',
                                                                                                  'Internet', 'Child care', 'Clothing'))) THEN 'ZOTH'
                WHEN (social_history_key = 'SOCIALHISTORY.LOCAL.144' AND (social_history_answer LIKE 'Y%')) THEN 'Z74.1'
          ELSE NULL
          END AS z_code
        FROM athena.patientsocialhistory
        WHERE ((social_history_key = 'SOCIALHISTORY.LOCAL.91' AND (social_history_answer LIKE 'I Have Housing Today But%' OR
            social_history_answer LIKE 'I Do Not Have Housing%' OR
            social_history_answer LIKE 'Needs %'))
            OR (social_history_key = 'SOCIALHISTORY.LOCAL.145' AND (social_history_answer LIKE 'Y%'))
            OR (social_history_key = 'SOCIALHISTORY.LOCAL.146' AND (social_history_answer LIKE 'Y%'))
            OR (social_history_key = 'SOCIALHISTORY.LOCAL.147' AND (social_history_answer LIKE 'Y%'))
            OR (social_history_key = 'SOCIALHISTORY.LOCAL.161' AND (social_history_answer LIKE 'Less Than Once%'))
            OR (social_history_key = 'SOCIALHISTORY.LOCAL.141' AND (social_history_answer LIKE 'Yes%'))
            OR (social_history_key = 'SOCIALHISTORY.LOCAL.142' AND (social_history_answer LIKE 'Yes%'))
            OR (social_history_key = 'SOCIALHISTORY.LOCAL.94' AND (social_history_answer IN('Food','Housing','Medicine','Transportation','Utilities (gas or heat)')))
            OR (social_history_key = 'SOCIALHISTORY.LOCAL.85' AND (social_history_answer IN('Phone', 'Utilities (gas or heat)',
                                                                                                  'Medicine or any Healthcare (medical or dental or mental health or vision)',
                                                                                                  'Internet', 'Child care', 'Clothing')))
            OR (social_history_key = 'SOCIALHISTORY.LOCAL.144' AND (social_history_answer LIKE 'Y%')))
            AND deleted_datetime IS NULL
    GROUP BY 1,2)
    SELECT
      ROW_NUMBER() OVER () AS id,
      chart_id,
      z_code
      FROM z
      ;;
  sql_trigger_value: SELECT MAX(chart_id) FROM athena.patientsocialhistory ;;
  indexes: ["chart_id"]
}

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }


  dimension: z_code {
    type: string
    description: "ICD-10 Z code that corresponds to SDOH response"
    sql:  ${TABLE}.z_code;;
  }


  dimension: chart_id {
    type: number
    sql: ${TABLE}."chart_id" ;;
  }
}
