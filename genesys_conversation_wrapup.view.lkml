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
