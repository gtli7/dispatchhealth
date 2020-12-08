view: athenadwh_medical_history_clone {
  sql_table_name: looker_scratch.athenadwh_medical_history_clone ;;
  view_label: "ZZZZ - Athenadwh Medical History Clone"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: answer {
    type: string
    sql: ${TABLE}.answer ;;
  }

  dimension: answer_yes {
    type: yesno
    hidden: yes
    sql: ${answer} = 'Y' ;;
  }

  dimension: chart_id {
    type: number
    sql: ${TABLE}.chart_id ;;
  }

  measure: count_distinct_charts {
    type: count_distinct
    sql: ${chart_id} ;;
  }

  measure: count_positive_responses {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: answer_yes
      value: "yes"
    }
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}.created_by ;;
  }

  dimension_group: created_datetime {
    type: time
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

  dimension: deleted_by {
    type: string
    sql: ${TABLE}.deleted_by ;;
  }

  dimension_group: deleted_datetime {
    type: time
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

  dimension: medical_history_key {
    type: string
    sql: ${TABLE}.medical_history_key ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: question {
    type: string
    sql: ${TABLE}.question ;;
  }

  dimension: comorbidity_category {
    type: string
    sql: CASE
          WHEN ${question} = 'Notes' OR ${question} = 'Reviewed Date' THEN NULL
          ELSE ${question}
        END ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
