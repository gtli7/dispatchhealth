view: actual_user_mu_daily_mapping {
  derived_table: {
    sql: select
      distinct
      username
      ,userid
      ,managementunitname
      ,managementunitid
      ,date(activitystarttime at time zone 'utc' at time zone 'America/Denver') as date
    from looker_scratch.genesys_wfm_adherence_actual_activities
      ;;
  }

  dimension: username {
    type: string
    sql: ${TABLE}."username" ;;
  }

  dimension: userid {
    type: string
    sql: ${TABLE}."userid" ;;
  }

  dimension: managementunitname {
    type: string
    sql: ${TABLE}."managementunitname" ;;
  }

  dimension: managementunitid {
    type: string
    sql: ${TABLE}."managementunitid" ;;
  }

  dimension: date {
    type: date_raw
    sql: ${TABLE}."date" ;;
  }
}
