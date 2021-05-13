view: genesys_wfm_day_metrics {
  sql_table_name: looker_scratch.genesys_wfm_day_metrics ;;

  dimension: adherenceexceptionthresholdseconds {
    type: number
    sql: ${TABLE}."adherenceexceptionthresholdseconds" ;;
  }

  dimension: adherencescheduleseconds {
    type: number
    sql: ${TABLE}."adherencescheduleseconds" ;;
  }

  dimension: businessunitid {
    type: string
    sql: ${TABLE}."businessunitid" ;;
  }

  dimension: businessunitname {
    type: string
    sql: ${TABLE}."businessunitname" ;;
  }

  dimension: conformanceactualseconds {
    type: number
    sql: ${TABLE}."conformanceactualseconds" ;;
  }

  dimension: conformancescheduleseconds {
    type: number
    sql: ${TABLE}."conformancescheduleseconds" ;;
  }

  dimension_group: daystarttime {
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
    sql: ${TABLE}."daystarttime" ;;
  }

  dimension: exceptioncount {
    type: number
    sql: ${TABLE}."exceptioncount" ;;
  }

  dimension: exceptiondurationadherenceseconds {
    type: number
    sql: ${TABLE}."exceptiondurationadherenceseconds" ;;
  }

  dimension: exceptiondurationseconds {
    type: number
    sql: ${TABLE}."exceptiondurationseconds" ;;
  }

  dimension: managementunitid {
    type: string
    sql: ${TABLE}."managementunitid" ;;
  }

  dimension: managementunitname {
    type: string
    sql: ${TABLE}."managementunitname" ;;
  }

  dimension: schedulelengthseconds {
    type: number
    sql: ${TABLE}."schedulelengthseconds" ;;
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
    drill_fields: [businessunitname, managementunitname, username]
  }
}
