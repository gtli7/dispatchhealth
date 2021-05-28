view: geneysis_evaluations {
  sql_table_name: looker_scratch.geneysis_evaluations ;;

  dimension: primary_key {
    type: string
    sql: concat(${questiongroupid},${agentid},${conversationid},${queuename},${answerid},${evaluatorid},${evaluationformid},${evaluationid},${questionid}) ;;
  }

  dimension: agenthasread {
    type: string
    sql: ${TABLE}."agenthasread"::text='1' ;;
  }

  dimension: agentid {
    type: string
    sql: ${TABLE}."agentid" ;;
  }

  dimension: agentname {
    type: string
    sql: ${TABLE}."agentname" ;;
  }

  dimension: answerid {
    type: string
    sql: ${TABLE}."answerid" ;;
  }

  dimension: answertext {
    type: string
    sql: ${TABLE}."answertext" ;;
  }

  dimension: answervalue {
    type: number
    sql: ${TABLE}."answervalue" ;;
  }

  dimension: anyfailedkillquestions {
    type: string
    sql: ${TABLE}."anyfailedkillquestions" ;;
  }

  dimension_group: assigneddate {
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
    sql: ${TABLE}."assigneddate" ;;
  }

  dimension_group: changeddate {
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
    sql: ${TABLE}."changeddate" ;;
  }

  dimension: conversationid {
    type: string
    sql: ${TABLE}."conversationid" ;;
  }

  dimension_group: conversationstarttime {
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
    sql: ${TABLE}."conversationstarttime" AT TIME ZONE 'UTC' ;;
  }

  measure: max_start {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      month_num,
      day_of_week,
      day_of_week_index,
      quarter,
      hour,
      year
    ]
    sql: max(${conversationstarttime_raw}) ;;
  }


  dimension: evaluationcomments {
    type: string
    sql: ${TABLE}."evaluationcomments" ;;
  }

  dimension: evaluationformid {
    type: string
    sql: ${TABLE}."evaluationformid" ;;
  }

  dimension: evaluationformname {
    type: string
    sql: ${TABLE}."evaluationformname" ;;
  }

  dimension: evaluationid {
    type: string
    sql: ${TABLE}."evaluationid" ;;
  }

  dimension: evaluatorid {
    type: string
    sql: ${TABLE}."evaluatorid" ;;
  }

  dimension: evaluatorname {
    type: string
    sql: ${TABLE}."evaluatorname" ;;
  }

  dimension: failedkillquestion {
    type: yesno
    sql: ${TABLE}."failedkillquestion"::text='1';;
  }


  dimension: markedna {
    type: yesno
    sql: ${TABLE}."markedna"::text='1' ;;
  }

  dimension: maxgrouptotalcriticalscore {
    type: string
    sql: ${TABLE}."maxgrouptotalcriticalscore" ;;
  }

  dimension: maxgrouptotalcriticalscoreunweighted {
    type: number
    sql: ${TABLE}."maxgrouptotalcriticalscoreunweighted" ;;
  }

  dimension: maxgrouptotalscore {
    type: string
    sql: ${TABLE}."maxgrouptotalscore" ;;
  }

  dimension: maxgrouptotalscoreunweighted {
    type: number
    sql: ${TABLE}."maxgrouptotalscoreunweighted" ;;
  }

  dimension: maxquestionscore {
    type: number
    sql: ${TABLE}."maxquestionscore" ;;
  }

  dimension: neverrelease {
    type: string
    sql: ${TABLE}."neverrelease" ;;
  }

  dimension: questiongroupid {
    type: string
    sql: ${TABLE}."questiongroupid" ;;
  }

  dimension: questiongroupmarkedna {
    type: string
    sql: ${TABLE}."questiongroupmarkedna" ;;
  }

  dimension: questiongroupname {
    type: string
    sql: ${TABLE}."questiongroupname" ;;
  }

  dimension: questiongroupweight {
    type: number
    sql: ${TABLE}."questiongroupweight" ;;
  }

  dimension: questionid {
    type: string
    sql: ${TABLE}."questionid" ;;
  }

  dimension: questionscore {
    type: number
    sql: case when ${questiongroupname} = 'Caller Experience' then ${TABLE}."questionscore"::float/13.0 else  ${TABLE}."questionscore"::float end  ;;
  }

  dimension: question_score_less_than_1 {
    type: yesno
    sql: ${questionscore} <0 ;;
  }


  dimension: question_score_na {
    type: yesno
    sql: ${questionscore} <0 ;;
  }



  dimension: questionscorecomment {
    type: string
    sql: ${TABLE}."questionscorecomment" ;;
  }

  dimension: questiontext {
    type: string
    sql: ${TABLE}."questiontext" ;;
  }

  dimension: queuename {
    type: string
    sql: ${TABLE}."queuename" ;;
  }

  dimension_group: releasedate {
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
    sql: ${TABLE}."releasedate" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
  }

  dimension: totalevaluationcriticalscore {
    type: number
    sql: ${TABLE}."totalevaluationcriticalscore" ;;
  }

  dimension: totalevaluationscore {
    type: number
    sql: ${TABLE}."totalevaluationscore" ;;
  }

  dimension: totalgroupcriticalscore {
    type: string
    sql: ${TABLE}."totalgroupcriticalscore" ;;
  }

  dimension: sykes {
    type: yesno
    sql: lower(${agentname}) like '%(sykes)%' ;;
  }

  dimension: covid {
    type: yesno
    sql: lower(${agentname}) like '%(covid)%' ;;
  }

  dimension: MA {
    type: yesno
    sql: lower(${agentname}) like '%(ma/%)%' ;;
  }

  dimension: optum {
    type: yesno
    sql: lower(${agentname}) like '%(optum care)%' ;;
  }

  dimension: QA {
    type: yesno
    sql: ${agentname} like '%(QA)%' ;;
}
  dimension: chat_agent {
    type: yesno
    sql: lower(${agentname}) like '%(chat)%' ;;
  }


  dimension: totalgroupcriticalscoreunweighted {
    type: number
    sql: ${TABLE}."totalgroupcriticalscoreunweighted" ;;
  }


  measure: count {
    type: count
    drill_fields: [agentname, evaluationformname, evaluatorname, questiongroupname, queuename]
  }


  measure: total_number_of_questions_yes{
    type: count_distinct
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: [questionscore: ">0",failedkillquestion: "no",markedna: "no"]

  }

  measure: total_number_of_questions_no{
    type: count_distinct
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: [questionscore: "0",failedkillquestion: "no",markedna: "no"]

  }

  measure: total_number_of_questions{
    type: count_distinct
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key} ;;

  }

  measure: total_number_of_failed_kill_questions {
    type: count_distinct
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: failedkillquestion
      value: "yes"
    }

  }

  measure: total_number_marked_na {
    type: count_distinct
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: markedna
      value: "yes"
    }
    filters: {
      field: failedkillquestion
      value: "no"
    }
  }


  measure: avg_question_score {
    type: average_distinct
    value_format: "0%"
    sql: ${questionscore}/${maxquestionscore} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: number_complete_evaluations {
    type: count_distinct
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: evaluationformname
      value: "Complete Ambassador Evaluation Form"
    }
  }

  measure: number_short_calls {
    type: count_distinct
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: evaluationformname
      value: "Short Call Monitoring Assessment"
    }
  }

  measure: number_of_ma_adherence_evaluations {
    type: count_distinct
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: evaluationformname
      value: "MA - Adherence and Unique Features Quality Assessment"
    }
  }


  measure: avg_total_evaluation_score {
    type: average_distinct
    value_format: "0%"
    sql: ${totalevaluationscore}::float/100.0 ;;
    sql_distinct_key: ${primary_key} ;;
  }


  measure: avg_total_evaluation_critical {
    label: "Avg Total Evaluation Critical Score"
    type: average_distinct
    value_format: "0%"
    sql: ${totalevaluationcriticalscore}::float/100.0 ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: count_agent_read {
    type: count_distinct
    sql: ${primary_key} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: agenthasread
      value: "yes"
    }
  }

  measure: introduction_avg_total_evaluation_score {
    type: average_distinct
    value_format: "0%"
    sql: ${questionscore} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: questiongroupname
      value: "Introduction"
    }
  }

  measure: body_avg_total_evaluation_score {
    label: "Body Avg Question Score"
    type: average_distinct
    value_format: "0%"
    sql: ${questionscore} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: questiongroupname
      value: "Body"
    }
  }

  measure: risk_avg_total_evaluation_score {
    type: average_distinct
    value_format: "0%"
    sql: ${questionscore} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: questiongroupname
      value: "Risk Stratification"
    }
  }

  measure: transfers_avg_total_evaluation_score {
    type: average_distinct
    value_format: "0%"
    sql: ${questionscore} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: questiongroupname
      value: "Transfers and External Communication"
    }
  }

  measure: close_avg_total_evaluation_score {
    label: "Close Avg Total Question Score"

    type: average_distinct
    value_format: "0%"
    sql: ${questionscore}::float;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: questiongroupname
      value: "Call Close (Based on Result)"
    }
  }

  measure: caller_experience_avg_total_evaluation_score {
    label: "Caller Experience Avg Total Question Score"
    type: average_distinct
    value_format: "0%"
    sql: ${questionscore}::float;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: questiongroupname
      value: "Caller Experience"
    }
  }

  measure: adherence_avg_total_evaluation_score {
    type: average_distinct
    value_format: "0%"
    sql: ${questionscore} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: questiongroupname
      value: "Adherence and Unique Features"
    }
  }

  measure: number_of_evaluations {
    type: count_distinct
    sql: ${evaluationid} ;;
    sql_distinct_key: ${evaluationid} ;;
  }

  measure: number_of_evaluations_read {
    type: count_distinct
    sql: ${evaluationid} ;;
    sql_distinct_key: ${evaluationid} ;;
    filters: {
      field: agenthasread
      value: "true"
    }
  }


  measure: number_of_evaluations_unread {
    type: count_distinct
    sql: ${evaluationid} ;;
    sql_distinct_key: ${evaluationid} ;;
    filters: {
      field: agenthasread
      value: "false"
    }
  }












}
