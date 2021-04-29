view: genesys_conversation_summary_null {
  sql_table_name: looker_scratch.genesys_conversation_summary_null ;;

  dimension: abandoned {
    type: number
    sql: ${TABLE}."abandoned" ;;
  }

  dimension: ani {
    type: string
    sql: ${TABLE}."ani" ;;
  }

  dimension: answered {
    type: number
    sql: ${TABLE}."answered" ;;
  }

  dimension: campaignname {
    type: string
    sql: ${TABLE}."campaignname" ;;
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

  measure: max_start {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      month_num,
      day_of_week,
      day_of_week_index,
      quarter,
      hour,
      year
    ]
    sql: max(${conversationstarttime) ;;
  }

  dimension: direction {
    type: string
    sql: ${TABLE}."direction" ;;
  }

  dimension: dnis {
    type: string
    sql: ${TABLE}."dnis" ;;
  }

  dimension: firstacdwaitduration {
    type: number
    sql: ${TABLE}."firstacdwaitduration" ;;
  }

  dimension: mediatype {
    type: string
    sql: ${TABLE}."mediatype" ;;
  }

  dimension: offered {
    type: number
    sql: ${TABLE}."offered" ;;
  }

  dimension: queuename {
    type: string
    sql: ${TABLE}."queuename" ;;
  }

  dimension: totalacdwaitduration {
    type: number
    sql: ${TABLE}."totalacdwaitduration" ;;
  }

  dimension: totalagentalertduration {
    type: number
    sql: ${TABLE}."totalagentalertduration" ;;
  }

  dimension: totalagentholdduration {
    type: number
    sql: ${TABLE}."totalagentholdduration" ;;
  }

  dimension: totalagenttalkduration {
    type: number
    sql: ${TABLE}."totalagenttalkduration" ;;
  }

  dimension: totalagentwrapupduration {
    type: number
    sql: ${TABLE}."totalagentwrapupduration" ;;
  }

  dimension: transfered {
    type: number
    sql: ${TABLE}."transfered" ;;
  }

  measure: count {
    type: count
    drill_fields: [queuename, campaignname]
  }
}
