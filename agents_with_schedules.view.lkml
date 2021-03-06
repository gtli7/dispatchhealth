view: agents_with_schedules {
  derived_table: {
    sql: select
      distinct
      userid
    from looker_scratch.geneysis_wfm_schedules
    where date(activitystarttime) > date(now()) - interval '36 days';;
    sql_trigger_value: SELECT count(*) FROM looker_scratch.geneysis_wfm_schedules ;;
    indexes: ["userid"]
  }

  dimension: userid {
    type: string
    sql: ${TABLE}."userid" ;;
  }
}
