# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: inbound_not_answered_or_abandoned {
derived_table: {

    sql: SELECT
  genesys_conversation_summary.conversationid  AS conversationid,
  genesys_conversation_summary.dnis  AS dnis
FROM looker_scratch.genesys_conversation_summary  AS genesys_conversation_summary

WHERE (genesys_conversation_summary.abandoned  = 0) AND ((case when (genesys_conversation_summary.totalagenttalkduration) >0 or  genesys_conversation_summary.answered >0 then 1 else 0 end  = 0))
GROUP BY 1,2
;;
  sql_trigger_value: SELECT count(*) FROM looker_scratch.genesys_conversation_summary  where genesys_conversation_summary.conversationstarttime > current_date - interval '2 day';;
  indexes: ["conversationid", "dnis"]
  }
  dimension: conversationid {
    type: string
    sql: ${TABLE}.conversationid;;
  }
  dimension: dnis {
    type: string
    sql: ${TABLE}.dnis;;
  }

}
