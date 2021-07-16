view: agent_tenure {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: select userid
        ,date_part('day',max(activityendtime) - min(activitystarttime)) as tenure
        from looker_scratch.genesys_wfm_adherence_actual_activities
        group by userid
      ;;
    sql_trigger_value: SELECT count(*) FROM looker_scratch.genesys_wfm_adherence_actual_activities  where genesys_wfm_adherence_actual_activities.activitystarttime > current_date - interval '2 day';;
    indexes: ["userid"]
  }

  dimension: userid {
    type: string
    sql: ${TABLE}."userid" ;;
  }

  dimension: tenure {
    type: number
    sql: ${TABLE}."tenure";;
  }
}
