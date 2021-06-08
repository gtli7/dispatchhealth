view: genesys_agent_summary {
  sql_table_name: looker_scratch.genesys_agent_summary ;;

  dimension: alertduration {
    type: number
    sql: ${TABLE}."alertduration" ;;
  }

  dimension: ani {
    type: string
    sql: ${TABLE}."ani" ;;
  }

  dimension: answeredflag {
    type: number
    sql: ${TABLE}."answeredflag" ;;
  }

  dimension: campaignname {
    type: string
    sql: ${TABLE}."campaignname" ;;
  }

  dimension: contactingduration {
    type: number
    sql: ${TABLE}."contactingduration" ;;
  }

  dimension: conversationid {
    type: string
    sql: ${TABLE}."conversationid" ;;
  }

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
    sql: ${TABLE}."conversationstarttime" AT TIME ZONE 'UTC';;
  }

  dimension: conversationstartdatemt {
    type: date_raw
    sql: ${TABLE}."conversationstartdatemt";;
  }

  dimension: dialingduration {
    type: number
    sql: ${TABLE}."dialingduration" ;;
  }

  dimension: direction {
    type: string
    sql: ${TABLE}."direction" ;;
  }

  dimension: dnis {
    type: string
    sql: ${TABLE}."dnis" ;;
  }

  dimension: firstwrapupcodename {
    type: string
    sql: ${TABLE}."firstwrapupcodename" ;;
  }

  dimension: holdcount {
    type: number
    sql: ${TABLE}."holdcount" ;;
  }

  dimension: holdduration {
    type: number
    sql: ${TABLE}."holdduration" ;;
  }

  dimension: interactduration {
    type: number
    sql: ${TABLE}."interactduration" ;;
  }

  dimension_group: interactstarttime {
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
    sql: ${TABLE}."interactstarttime" AT TIME ZONE 'UTC';;
  }

  dimension: mediatype {
    type: string
    sql: ${TABLE}."mediatype" ;;
  }

  dimension: purpose {
    type: string
    sql: ${TABLE}."purpose" ;;
  }

  dimension: queuename {
    type: string
    sql: ${TABLE}."queuename" ;;
  }

  dimension: transfercount {
    type: number
    sql: ${TABLE}."transfercount" ;;
  }

  dimension: userid {
    type: string
    sql: ${TABLE}."userid" ;;
  }

  dimension: username {
    type: string
    sql: ${TABLE}."username" ;;
  }

  dimension: wrapupduration {
    type: number
    sql: ${TABLE}."wrapupduration" ;;
  }

  measure: count {
    type: count
    drill_fields: [campaignname, firstwrapupcodename, queuename, username]
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${TABLE}.conversationid,${TABLE}.userid,${TABLE}.direction,${TABLE}.mediatype)  ;;
  }

  measure: count_distinct_conversationid {
    type: count_distinct
    sql: ${conversationid} ;;
  }

  measure: answered {
    type: sum
    sql: ${answeredflag} ;;
  }

  measure: inbound {
    type: sum
    sql: CASE WHEN ${direction} = 'inbound' then 1
          ELSE 0 END;;
  }

  measure: outbound {
    type: sum
    sql: CASE WHEN ${direction} = 'outbound' then 1
          ELSE 0 END;;
  }

  measure: avg_talk_time {
    type: average
    sql: ${interactduration}/1000;;
    value_format_name: decimal_0
  }

  measure: avg_wrap_time {
    type: average
    sql: ${wrapupduration}/1000;;
    value_format_name: decimal_0
  }

  measure: average_handle_time {
    type: average
    sql: coalesce(${interactduration},0)/1000 + coalesce(${holdduration},0)/1000 + coalesce(${wrapupduration},0)/1000 ;;
    value_format_name: decimal_0
  }

  measure: AHT_voice {
    type: average
    sql: coalesce(${interactduration},0)/1000 + coalesce(${holdduration},0)/1000 + coalesce(${wrapupduration},0)/1000;;
    filters: [mediatype: "voice"]
    value_format_name: decimal_0
  }

  measure: AHT_callback {
    type: average
    sql: coalesce(${interactduration},0)/1000 + coalesce(${holdduration},0)/1000 + coalesce(${wrapupduration},0)/1000;;
    filters: [mediatype: "callback", direction: "outbound"]
    value_format_name: decimal_0
  }

  measure: AHT_chat {
    type: average
    sql: coalesce(${interactduration},0)/1000 + coalesce(${holdduration},0)/1000 + coalesce(${wrapupduration},0)/1000;;
    filters: [mediatype: "chat", direction: "inbound"]
    value_format_name: decimal_0
  }

  measure: AHT_email {
    type: average
    sql: coalesce(${interactduration},0)/1000 + coalesce(${holdduration},0)/1000 + coalesce(${wrapupduration},0)/1000;;
    filters: [mediatype: "email", direction: "inbound"]
    value_format_name: decimal_0
  }
}
