view: athena_social_history_zcode {

# sql_table_name: athena.patientsocialhistory ;;
# drill_fields: [id]
derived_table: {
  sql: SELECT
          ROW_NUMBER() OVER () AS id,
          chart_id,
          CASE  WHEN social_history_key = 'SOCIALHISTORY.LOCAL.91' AND (social_history_answer LIKE 'I Have Housing Today But%' OR
            social_history_answer LIKE 'I Do Not Have Housing%' OR
            social_history_answer LIKE 'Needs %') THEN 'Z59.1'
              --OR
              --TODO
          ELSE NULL
          END AS z_code
        FROM athena.patientsocialhistory
        WHERE (social_history_key = 'SOCIALHISTORY.LOCAL.91' AND (social_history_answer LIKE 'I Have Housing Today But%' OR
            social_history_answer LIKE 'I Do Not Have Housing%' OR
            social_history_answer LIKE 'Needs %'))
            --OR
            --TODO - Add additional where clause logic here
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
    sql:  ${TABLE}.z_code;
  }


  dimension: chart_id {
    type: number
    sql: ${TABLE}."chart_id" ;;
  }
}
