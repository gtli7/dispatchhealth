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
}
