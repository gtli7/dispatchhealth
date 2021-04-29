view: geneysis_custom_conversation_attributes {
  sql_table_name: looker_scratch.geneysis_custom_conversation_attributes ;;

  dimension: contactid {
    type: string
    sql: ${TABLE}."contactid" ;;
  }

  dimension: conversationduration {
    type: number
    sql: ${TABLE}."conversationduration" ;;
  }

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
    sql: ${TABLE}."conversationstarttime" AT TIME ZONE 'UTC' ;;
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
    sql: max(${conversationstarttime_raw}) ;;
  }


  dimension_group: customdatetime01 {
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
    sql: ${TABLE}."customdatetime01" ;;
  }

  dimension_group: customdatetime02 {
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
    sql: ${TABLE}."customdatetime02" ;;
  }

  dimension_group: customdatetime03 {
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
    sql: ${TABLE}."customdatetime03" ;;
  }

  dimension: customerid {
    type: string
    sql: ${TABLE}."customerid" ;;
  }

  dimension: customnumber01 {
    type: number
    sql: ${TABLE}."customnumber01" ;;
  }

  dimension: customnumber02 {
    type: number
    label: "Verification"
    sql: ${TABLE}."customnumber02" ;;
  }

  dimension: customnumber03 {
    type: number
    sql: ${TABLE}."customnumber03" ;;
  }

  dimension: customstring01 {
    type: string
    label: "Applicationname"
    sql: ${TABLE}."customstring01" ;;
  }

  dimension: direct_to_queue_bool {
    type: yesno
    sql: trim(lower(${customstring01})) ='directtoqueue' ;;
  }

  dimension: customstring02 {
    type: string
    label: "Exittype"
    sql: ${TABLE}."customstring02" ;;
  }

  dimension: customstring03 {
    type: string
    label: "Exitdata"
    sql: ${TABLE}."customstring03" ;;
  }

  dimension: customstring04 {
    type: string
    label: "IVRflow"
    sql: ${TABLE}."customstring04" ;;
  }

  dimension: customstring05 {
    type: string
    sql: ${TABLE}."customstring05" ;;
  }

  dimension: customstring06 {
    type: string
    sql: ${TABLE}."customstring06" ;;
  }

  dimension: customstring07 {
    type: string
    sql: ${TABLE}."customstring07" ;;
  }

  dimension: customstring08 {
    type: string
    sql: ${TABLE}."customstring08" ;;
  }

  dimension: customstring09 {
    type: string
    sql: ${TABLE}."customstring09" ;;
  }

  dimension: customstring10 {
    type: string
    sql: ${TABLE}."customstring10" ;;
  }

  dimension: participantid {
    type: string
    sql: ${TABLE}."participantid" ;;
  }

  dimension: participantname {
    type: string
    sql: ${TABLE}."participantname" ;;
  }

  dimension_group: participantstarttime {
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
    sql: ${TABLE}."participantstarttime" ;;
  }

  dimension: purpose {
    type: string
    sql: ${TABLE}."purpose" ;;
  }

  dimension: ivrexit {
    type: string
    sql: reverse(split_part(reverse(${customstring04}), '|', 1));;
  }

  dimension: ivrexitdisconnect {
    type: string
    sql:  reverse(split_part(reverse(${customstring04}), '|', 2));;
  }

  dimension: ivr_deflection {
    type: yesno
    sql: (lower(${customstring02}) like '%abandon%' or ${customstring02} is null) and (lower(${customstring03}) like '%abandon%' or ${customstring03} is null) ;;
  }

  measure: count {
    type: count
    drill_fields: [participantname]
  }


measure: number_of_abandons {
  type: count
  sql: ${TABLE}."customstring02" ;;
  filters: {
    field: customstring02
    value: "abandon"
  }
}

measure: number_of_queued{
  type: count
  sql: ${TABLE}."customstring02" ;;
  filters: {
    field: customstring02
    value: "Queue"
  }
}



measure: ivr_deflection_count {
  type: count_distinct
  sql: ${conversationid} ;;
  sql_distinct_key: ${conversationid}  ;;
  filters: {
    field: ivr_deflection
    value: "yes"
  }
}

measure: exit_type_count {
  type: count
  sql: ${TABLE}."customstring03" ;;
  sql_distinct_key: ${conversationid} ;;

}


measure: exit_type_disconnect_count {
  type: count
  sql: ${ivrexitdisconnect};;


  }



}
