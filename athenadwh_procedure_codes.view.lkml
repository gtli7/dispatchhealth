view: athenadwh_procedure_codes {
  sql_table_name: jasperdb.athenadwh_procedure_codes ;;
  view_label: "ZZZZ - Athenadwh Procedure Codes"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: created_datetime {
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
    sql: ${TABLE}.created_datetime ;;
  }

  dimension_group: deleted_datetime {
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
    sql: ${TABLE}.deleted_datetime ;;
  }

  dimension: feed_dates {
    type: string
    hidden: yes
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: procedure_code {
    type: string
    sql: ${TABLE}.procedure_code ;;
  }

  dimension: procedure_code_description {
    type: string
    sql: ${TABLE}.procedure_code_description ;;
  }

  dimension: procedure_code_group {
    type: string
    sql: ${TABLE}.procedure_code_group ;;
  }

  dimension: procedure_code_type {
    type: string
    description: "The procedure code type for reporting: E&M, LAB, PROCEDURE, MEDICINE, or SUPPLY"
    sql: CASE
          WHEN (${procedure_code_group} IS NULL AND
               ${procedure_code} IN ('87880','87807','87804','86308','85610','85014','83605','81003','80047')) OR
              ${procedure_code_group} = 'Labs' THEN 'LAB'
          WHEN ${procedure_code_group} IS NULL AND ${cpt_code_dimensions.e_and_m_code} IS TRUE THEN 'E&M'
          WHEN ${procedure_code_group} IS NULL AND ${cpt_code_dimensions.e_and_m_code} IS NOT TRUE THEN 'PROCEDURE'
          WHEN ${procedure_code_group} = 'Medications' THEN 'MEDICINE'
          WHEN ${procedure_code_group} = 'Supplies' THEN 'SUPPLY'
          ELSE NULL
        END
    ;;
  }

  dimension: procedure_code_id {
    type: number
    sql: ${TABLE}.procedure_code_id ;;
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
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
