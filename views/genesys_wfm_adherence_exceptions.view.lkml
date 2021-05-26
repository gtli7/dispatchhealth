view: genesys_wfm_adherence_exceptions {
  sql_table_name: looker_scratch.genesys_wfm_adherence_exceptions ;;

  dimension: actualactivitycategory {
    type: string
    sql: ${TABLE}."actualactivitycategory" ;;
  }

  dimension: durationseconds {
    type: number
    sql: ${TABLE}."durationseconds" ;;
  }

  dimension_group: exceptionendtime {
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
    sql: ${TABLE}."exceptionendtime" ;;
  }

  dimension_group: exceptionstarttime {
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
    sql: ${TABLE}."exceptionstarttime" ;;
  }

  dimension: impact {
    type: string
    sql: ${TABLE}."impact" ;;
  }

  dimension: managementunitid {
    type: string
    sql: ${TABLE}."managementunitid" ;;
  }

  dimension: managementunitname {
    type: string
    sql: ${TABLE}."managementunitname" ;;
  }

  dimension: routingstatus {
    type: string
    sql: ${TABLE}."routingstatus" ;;
  }

  dimension: scheduledactivitycategory {
    type: string
    sql: ${TABLE}."scheduledactivitycategory" ;;
  }

  dimension: scheduledactivityname {
    type: string
    sql: ${TABLE}."scheduledactivityname" ;;
  }

  dimension: systempresence {
    type: string
    sql: ${TABLE}."systempresence" ;;
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
    drill_fields: [managementunitname, scheduledactivityname, username]
  }
}
