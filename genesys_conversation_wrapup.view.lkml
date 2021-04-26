view: genesys_conversation_wrapup {
  sql_table_name: looker_scratch.genesys_conversation_wrapup ;;

  dimension_group: conversationendtime {
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
    sql: ${TABLE}."conversationendtime" ;;
  }

  dimension: agent_name_raw {
    type: string
    sql: ${TABLE}."agent_name_raw";;
  }
  measure: min_conversationendtime {
    type: time
    sql: min(${conversationendtime_raw}) ;;
  }

  measure: max_conversationendtime {
    type: time
    sql: max(${conversationendtime_raw}) ;;
  }

  dimension: agent_days_experience {
    label: "Log"
    type: number
    sql: round(log(${agent_days_experience_raw})::numeric,1)  ;;
  }

  dimension: agent_days_experience_raw {
    type: number
    sql: EXTRACT(DAY FROM ${conversationendtime_raw}-${care_agent_min_max_dates.min_conversationendtime_raw});;
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
    sql: ${TABLE}."conversationstarttime" ;;
  }

  dimension: purpose {
    type: string
    sql: ${TABLE}."purpose" ;;
  }

  dimension: queuename {
    type: string
    sql: ${TABLE}."queuename" ;;
  }

  dimension: sessionid {
    type: string
    sql: ${TABLE}."sessionid" ;;
  }

  dimension: username {
    type: string
    sql: ${TABLE}."username" ;;
  }
  dimension: tesfaye_bool {
    label: "DTC Test Variable"
    type: string
    sql: case when lower(${username}) SIMILAR TO '%(tesfaye bihonegne|melissa dosch|tamara brown|laketha stevenson|amber myers|amanda menges|ash balderston)%'
    then ${username}
              else 'Control' end;;
  }

  dimension: superuser_bool {
    type: yesno
    sql:  lower(${username}) like '%sabrina wilder%' OR
          lower(${username}) like '%ashley salvador%' OR
          lower(${username}) like '%ellen dameron%' OR
          lower(${username}) like '%maria ibarra%' OR
          lower(${username}) like '%najolie abellard%' OR
          lower(${username}) like '%karen stokes%' OR
          lower(${username}) like '%tiffany alvarado%' ;;
  }

  dimension: sykes {
    type: yesno
    sql: lower(${username}) like '%sykes%' ;;
  }


  dimension: wrapupcodename {
    type: string
    sql: trim(${TABLE}."wrapupcodename") ;;
  }

  measure: count {
    type: count
    drill_fields: [queuename, username, wrapupcodename]
  }
}
