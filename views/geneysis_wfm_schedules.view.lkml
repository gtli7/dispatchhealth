view: geneysis_wfm_schedules {
  sql_table_name: looker_scratch.geneysis_wfm_schedules ;;

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
    sql: ${TABLE}."activityendtime" ;;
  }

  dimension: activityname {
    type: string
    sql: ${TABLE}."activityname" ;;
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
    sql: ${TABLE}."activitystarttime" ;;
  }

  dimension: businessunitid {
    type: string
    sql: ${TABLE}."businessunitid" ;;
  }

  dimension: businessunitname {
    type: string
    sql: ${TABLE}."businessunitname" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."description" ;;
  }

  dimension: durationminutes {
    type: number
    sql: ${TABLE}."durationminutes" ;;
  }

  dimension: managementunitid {
    type: string
    sql: ${TABLE}."managementunitid" ;;
  }

  dimension: managementunitname {
    type: string
    sql: ${TABLE}."managementunitname" ;;
  }

  dimension: manuallyedited {
    type: string
    sql: ${TABLE}."manuallyedited" ;;
  }

  dimension: paid {
    type: string
    sql: ${TABLE}."paid" ;;
  }

  dimension: shiftid {
    type: number
    value_format_name: id
    sql: ${TABLE}."shiftid" ;;
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
    drill_fields: [businessunitname, managementunitname, username, activityname]
  }
}
