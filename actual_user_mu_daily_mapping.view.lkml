view: actual_user_mu_daily_mapping {
  derived_table: {
    sql: select
      distinct
      username
      ,userid
      ,managementunitname
      ,date(activitystarttime at time zone 'utc' at time zone 'America/Denver') as date
    from looker_scratch.genesys_wfm_adherence_actual_activities
      ;;
    sql_trigger_value: SELECT count(*) FROM looker_scratch.genesys_wfm_adherence_actual_activities  where genesys_wfm_adherence_actual_activities.activitystarttime > current_date - interval '2 day';;
    indexes: ["userid","userid","date"]
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
