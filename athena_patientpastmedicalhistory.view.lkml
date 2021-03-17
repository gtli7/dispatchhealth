view: athena_patientpastmedicalhistory {
  sql_table_name: athena.patientpastmedicalhistory ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: __batch_id {
    type: string
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension_group: __file {
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
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: chart_id {
    type: number
    sql: ${TABLE}."chart_id" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}."created_by" ;;
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
    sql: ${TABLE}."created_datetime" ;;
  }

  dimension: deleted_by {
    type: string
    sql: ${TABLE}."deleted_by" ;;
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
    sql: ${TABLE}."deleted_datetime" ;;
  }

  dimension: answer {
    type: string
    sql: ${TABLE}."past_medical_history_answer" ;;
  }

  dimension: past_medical_history_id {
    type: number
    sql: ${TABLE}."past_medical_history_id" ;;
  }

  dimension: past_medical_history_key {
    type: string
    sql: ${TABLE}."past_medical_history_key" ;;
  }

  dimension: question {
    type: string
    sql: ${TABLE}."past_medical_history_question" ;;
  }

  dimension: comorbidity_category {
    type: string
    sql: CASE
          WHEN ${question} = 'Notes' OR ${question} = 'Reviewed Date' THEN NULL
          ELSE ${question}
        END ;;
  }

  dimension: answer_yes {
    type: yesno
    hidden: yes
    sql: ${answer} = 'Y' ;;
  }

  measure: count_distinct_charts {
    type: count_distinct
    sql: ${chart_id} ;;
  }

  measure: count_positive_responses {
    type: count_distinct
    sql: ${id} ;;
    filters: [answer_yes: "yes"]
  }

  dimension: patient_char {
    type: string
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}."type" ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
