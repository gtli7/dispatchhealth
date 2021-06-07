view: genesys_wfm_adherence_actual_activities {
  sql_table_name: looker_scratch.genesys_wfm_adherence_actual_activities ;;

  dimension: activitycategory {
    type: string
    sql: ${TABLE}."activitycategory" ;;
  }

  dimension_group: activityendtime {
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
    sql: ${TABLE}."activityendtime" AT TIME ZONE 'UTC';;
  }

  dimension_group: activitystarttime {
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
    sql: ${TABLE}."activitystarttime" AT TIME ZONE 'UTC';;
  }

  dimension: durationseconds {
    type: number
    sql: ${TABLE}."durationseconds" ;;
  }

  dimension: managementunitid {
    type: string
    sql: ${TABLE}."managementunitid" ;;
  }

  dimension: managementunitname {
    type: string
    sql: ${TABLE}."managementunitname" ;;
  }

  dimension: userid {
    type: string
    sql: ${TABLE}."userid" ;;
  }

  dimension: username {
    type: string
    sql: ${TABLE}."username" ;;
  }

  measure: count {
    type: count
    drill_fields: [managementunitname, username]
  }

  dimension: primary_key {
    type: string
    sql: concat(${userid},${managementunitid},${activitystarttime_raw},${activitycategory}) ;;
    primary_key: yes
  }

  measure: conformance_numerator {
    type: sum_distinct
    sql: ${durationseconds} ;;
    sql_distinct_key: ${primary_key};;
    filters: [activitycategory: "OnQueueWork"]
  }

  measure: conformance_denominator {
    type: sum_distinct
    sql: ${geneysis_wfm_schedules.durationminutes} * 60 ;;
    sql_distinct_key: concat(${geneysis_wfm_schedules.userid},${geneysis_wfm_schedules.managementunitid},${geneysis_wfm_schedules.activitystarttime_raw},${geneysis_wfm_schedules.activitycategory}) ;;
    filters: [geneysis_wfm_schedules.activityname : "OnQueueWork, Extended Hours, Mandatory OT, MR OT, On Queue, OT"]
  }

  measure: conformance {
    type: number
    value_format_name: percent_1
    sql: coalesce(${conformance_numerator},0)/nullif(${conformance_denominator},0) ;;
  }

  measure: qualified_rate_inbound_numerator {
    type: sum_distinct
    value_format: "0.0"
    sql:  (case when ${care_request_flat.booked_resolved} then .7 else 1 end)::float ;; #this is the logic from ${care_request_flat.accepted_or_scheduled_count_inbound}
    sql_distinct_key:  ${care_request_flat.care_request_id} ;;
    filters: [care_request_flat.accepted_or_scheduled: "yes", genesys_conversation_summary.inbound_demand: "yes", genesys_conversation_summary.queuename_adj: "DTC Pilot, General Care, Partner Direct (Broad)"]
  }

  measure: qualified_rate_inbound_denominator {
    type: count_distinct
    sql: concat(${genesys_conversation_summary.patient_number}, ${genesys_conversation_summary.conversationstarttime_hour_of_day}, ${genesys_conversation_summary.conversationstarttime_date});; #logic from ${genesys_conversation_summary.distinct_answer_long_callers}
    sql_distinct_key: concat(${genesys_conversation_summary.patient_number}, ${genesys_conversation_summary.conversationstarttime_hour_of_day}, ${genesys_conversation_summary.conversationstarttime_date}) ;;
    filters: [genesys_conversation_summary.inbound_demand: "yes", genesys_conversation_summary.answered_long: "yes", genesys_conversation_summary.has_queue: "yes", genesys_conversation_summary.queuename_adj: "DTC Pilot, General Care, Partner Direct (Broad)"]
  }

  measure: qualified_rate_inbound {
    label: "Qualified Rate"
    type: number
    value_format: "0%"
    sql: ${qualified_rate_inbound_numerator}::float/(nullif(${qualified_rate_inbound_denominator},0))::float;;
    #filters: [genesys_conversation_summary.queuename_adj: "DTC Pilot, General Care, Partner Direct (Broad)"]
  }

  measure: conversion_rate_inbound_numerator {
    type: count_distinct
    sql: ${care_request_flat.care_request_id} ;; #logic from ${care_request_flat.complete_count}
    filters: [care_request_flat.complete: "yes", genesys_conversation_summary.queuename_adj: "DTC Pilot, General Care, Partner Direct (Broad)"]
  }

  measure: conversion_rate_inbound_denominator {
    type: count_distinct
    sql: ${care_request_flat.care_request_id} ;; #logic from ${care_request_flat.care_request_count}
    filters: [genesys_conversation_summary.queuename_adj: "DTC Pilot, General Care, Partner Direct (Broad)"]
  }

  measure: conversion_rate_inbound {
    label: "Conversion Rate"
    type: number
    value_format: "0%"
    sql: ${conversion_rate_inbound_numerator}::float/nullif(${conversion_rate_inbound_denominator},0)::float;;
    #filters: [genesys_conversation_summary.queuename_adj: "DTC Pilot, General Care, Partner Direct (Broad)"]
  }


}
