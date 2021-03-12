view: geneysis_pre_ivr_abandons_by_date_and_dnis {
  derived_table: {
    sql: select date(n.conversationstarttime) as conversationstarttime, n.dnis,
    count(case when n.totalivrduration >15000 then n.conversationid else null end) as long_ivr_abandons,
    count(case when n.totalivrduration between 7000 and 15000 then n.conversationid else null end) as short_ivr_abandons,
    count(case when n.totalivrduration <7000 or n.totalivrduration is null then n.conversationid else null end) as prompt_abandons

from looker_scratch.genesys_conversation_summary_null n
left join looker_scratch.genesys_conversation_summary g
on g.conversationid=n.conversationid
where g.conversationid is null and  extract(hour from n.conversationstarttime AT TIME ZONE 'UTC') between 9 and 18
group by 1,2 ;;
indexes: ["conversationstarttime", "dnis"]
    sql_trigger_value: select sum(num) from
    (SELECT count(*) as num FROM looker_scratch.genesys_conversation_summary  where genesys_conversation_summary.conversationstarttime > current_date - interval '2 day'
    UNION ALL
    SELECT count(*) as num FROM looker_scratch.genesys_conversation_summary_null  where genesys_conversation_summary_null.conversationstarttime > current_date - interval '2 day')lq
    ;;}
  dimension_group: conversationstarttime {
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
    sql: ${TABLE}."conversationstarttime" ;;
  }

  dimension: dnis {
    type: string
    sql: ${TABLE}."dnis" ;;

  }

  dimension: primary_key {
    type: string
    sql: concat(${dnis},${conversationstarttime_date}) ;;
  }
  dimension: pre_ivr_abandons {
    label: "Long IVR Abandons (over 15 seconds)"
    type: number
    sql: ${TABLE}."long_ivr_abandons" ;;
  }
  measure: sum_pre_ivr_abandons {
    label: "Long IVR Abandons (over 15 seconds)"
    type: sum_distinct
    sql: ${pre_ivr_abandons} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  dimension: short_ivr_abandons {
    label: "Short IVR Abandons (Between 7 and 15 seconds)"
    type: number
    sql: ${TABLE}."short_ivr_abandons" ;;
  }
  measure: sum_short_ivr_abandons {
    label: "Short IVR Abandons (Between 7 and 15 seconds)"
    type: sum_distinct
    sql: ${short_ivr_abandons} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  dimension: prompt_abandons {
    label: "Prompt IVR Abandons (under 7 seconds)"
    type: number
    sql: ${TABLE}."prompt_abandons" ;;
  }
  measure: sum_prompt_abandons {
    label: "Prompt IVR Abandons (under 7 seconds)"
    type: sum_distinct
    sql: ${prompt_abandons} ;;
    sql_distinct_key: ${primary_key} ;;
  }

}
