view: agent_current_management_unit {
  derived_table: {
    sql: select userid, managementunitname
        from
        (
          select
            aa.userid
            ,aa.managementunitname
            ,case when max(activityendtime) = max(max(activityendtime)) over (partition by aa.userid) then 1 else 0 end as most_recent_MU
          from looker_scratch.genesys_wfm_adherence_actual_activities aa
          group by
            aa.userid
            ,aa.managementunitname
        ) b
        where most_recent_MU = 1
      ;;
    sql_trigger_value: SELECT count(*) FROM looker_scratch.genesys_wfm_adherence_actual_activities  where genesys_wfm_adherence_actual_activities.activitystarttime > current_date - interval '2 day';;
    indexes: ["userid"]
  }

  dimension: userid {
    type: string
    sql: ${TABLE}."userid" ;;
  }

  dimension: managementunitname {
    type: string
    sql: ${TABLE}."managementunitname";;
  }
}
