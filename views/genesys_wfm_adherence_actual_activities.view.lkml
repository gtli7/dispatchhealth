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
    filters: [geneysis_wfm_schedules.activityname : "OnQueueWork"]#, Extended Hours, On Queue,OT,'Mandatory OT','MR OT'"]
  }
}
