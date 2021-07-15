view: agent_tenure {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: select userid
        ,date_part('day',max(activityendtime) - min(activitystarttime)) as tenure
        from looker_scratch.genesys_wfm_adherence_actual_activities
        group by userid
      ;;
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
