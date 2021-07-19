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

  dimension: agent_raw {
    type: string
    sql: case when ${username} like '%(%' then
trim(left(${username}, strpos(${username}, '(') - 1))
else trim(${username}) end   ;;
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

  #start wrap up code compliance measures
  measure: blank_wrap_up_code {
    type: count
    sql: ${conversationid} ;;
    filters: [firstwrapupcodename: "EMPTY", answeredflag: "1"]
  }

  measure: inin_wrap_up_timeout_code {
    type: count
    sql: ${conversationid} ;;
    filters: [firstwrapupcodename: "ININ-WRAP-UP-TIMEOUT", answeredflag: "1"]
  }

  measure: no_wrap_up_code {
    type: number
    sql: ${blank_wrap_up_code} + ${inin_wrap_up_timeout_code} ;;
  }

  measure: interactions {
    type: count
    sql: ${conversationid} ;;
    filters: [answeredflag: "1"]
  }

  measure: wrap_up_code_compliance {
    label: "Wrap Compliance"
    type: number
    value_format_name: "percent_2"
    sql: (${interactions} - ${no_wrap_up_code} - ${blank_wrap_up_code})::float
            / nullif((${interactions} - ${blank_wrap_up_code}),0)::float;;
  }

  #start "Nordmark" metrics
  measure: queue_expected_care_requests {
    type: number
    #value_format_name: decimal_2
    sql: ${queue_targets.max_target_rate} * ${count_distinct_conversationid} ;;
  }

  measure: daily_expected_care_requests {
    type: sum_distinct
    sql_distinct_key: concat(${username},${conversationstarttime_date}) ;;
    # sql: ${queue_expected_care_requests} ;;
    sql: (${queue_targets.max_target_rate} * ${count_distinct_conversationid}) ;;
  }

  # measure: percentage_of_target {
  #   type: number
  #   sql: ${daily_expected_care_requests} / ${care_requests.count_distinct} ;;

  # }
}
