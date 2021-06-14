view: sf_accounts {
  sql_table_name: looker_scratch.sf_accounts ;;

  dimension: account_id {
    type: string
    sql: ${TABLE}."account_id" ;;
  }

  dimension: account_name {
    type: string
    sql: ${TABLE}."account_name" ;;
  }

  dimension: al_il_distinction {
    type: string
    sql: case when
     lower(${account_name}) like '%-mc%' or lower(${channel_items.name}) like '%-mc%' or lower(${account_name}) like '% mc%' or lower(${channel_items.name}) like '% mc%'  OR
     lower(${account_name}) like '%memory%' or lower(${channel_items.name}) like '%memory%' or
     lower(${account_name}) like '% al%' or lower(${account_name}) like '%-al%' or lower(${channel_items.name}) like '%-al%' or lower(${account_name}) like '%assisted%'  OR lower(${channel_items.name}) like '% al%' or lower(${channel_items.name}) like '%assisted%' then 'Senior Living Community: AL/MC'
              when  lower(${account_name}) like '% il%' or lower(${account_name}) like '%independent%'  OR lower(${channel_items.name}) like '% il%' or lower(${channel_items.name}) like '%independent%'  then 'Senior Living Community: IL'
              else null end ;;
  }

  dimension: channel_items_id {
    type: number
    sql: ${TABLE}."channel_items_id" ;;
  }

  dimension: al_id {
    type: number
    sql: ${TABLE}."al_id" ;;
  }

  dimension: il_id {
    type: number
    sql: ${TABLE}."il_id" ;;
  }

  dimension: definitive_health_id {
    type: number
    sql: ${TABLE}."definitive_health_id" ;;
  }


  dimension: channel_items_id_is_set {
    type: yesno
    sql:  ${channel_items_id} is not null;;
  }


  dimension: channel_type {
    label: "Channel Type (Senior Community, Home Health etc.)"
    type: string
    sql: ${TABLE}."channel_type" ;;
  }
  dimension: community_broad{
    type: yesno
    sql:  ${channel_type} in('Senior Living Community', 'Home Health Agency (Medical)', 'Hospice / Palliative Care', 'Non-Medical Home Health', 'Other - Community');;
  }

  measure: count_community_broad {
    type: count_distinct
    sql: ${account_id} ;;
    sql_distinct_key: ${account_id} ;;
    filters: [community_broad: "yes"]
  }

  dimension_group: last_activity {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."last_activity" ;;
  }

  dimension_group: now {
    type: time
    convert_tz: no

    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: now();;
  }

  dimension_group: last_month {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: now() - interval '1' month;;
  }


  dimension: market {
    type: string
    sql: ${TABLE}."market" ;;
  }

  dimension: neighborhood {
    type: string
    sql: ${TABLE}."neighborhood" ;;
  }


  dimension: priority {
    type: yesno
    sql: ${priority_account_timestamp_month} =  ${now_month} ;;
  }

  dimension: priority_last_month {
    type: yesno
    sql: ${sf_priority_accounts.date_month} =  ${last_month_month} ;;
  }


  dimension_group: priority_account_timestamp {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."priority_account_timestamp" + interval '7' day ;;
  }

  dimension: priority_action {
    type: string
    sql: ${TABLE}."priority_action" ;;
  }

  dimension: priority_action_set {
    type: yesno
    sql: ${priority_action} is not null ;;
  }

  dimension: quadrant {
    type: string
    sql: ${TABLE}."quadrant" ;;
  }

  dimension: parent_account_id {
    type: string
    sql: ${TABLE}."parent_account_id" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."phone" ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}."address" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."city" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
  }

  dimension: zipcode {
    type: string
    sql: ${TABLE}."zipcode" ;;
  }

  dimension: record_type {
    label: "Record Type (Account, Health System etc.)"
    type: string
    sql: ${TABLE}."record_type" ;;
  }

  dimension: type {
    label: "Type (Prospect etc.)"
    type: string
    sql: ${TABLE}."type" ;;
  }

  dimension: website {
    type: string
    sql: ${TABLE}."website" ;;
  }

  dimension: projected_volume {
    type: number
    sql: ${TABLE}."projected_volume" ;;
  }

  dimension: number_of_beds {
    type: number
    sql: ${TABLE}."number_of_beds" ;;
  }

  dimension: collaborative_agreement {
    type: yesno
    sql: ${TABLE}."collaborative_agreement" is true ;;
  }

  dimension: account_owner {
    type: string
    sql: ${TABLE}."account_owner" ;;
  }

  dimension_group: id_campaign {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."id_campaign" ;;
  }

  measure: count {
    type: count_distinct
    sql: ${account_id} ;;
    sql_distinct_key: ${account_id} ;;
  }

  measure: count_priority {
    label: "Count Priority (current month)"
    type: count_distinct
    sql: ${account_id} ;;
    sql_distinct_key: ${account_id} ;;
    filters:  {
      field: priority
      value: "yes"
    }
  }

  measure: count_priority_last_month {
    label: "Count Priority (last month)"
    type: count_distinct
    sql: ${account_id} ;;
    sql_distinct_key: ${account_id} ;;
    filters:  {
      field: priority_last_month
      value: "yes"
    }
  }


  measure: count_priority_action_set {
    type: count_distinct
    sql: ${account_id} ;;
    sql_distinct_key: ${account_id} ;;
    filters:  {
      field: priority
      value: "yes"
    }
    filters:  {
      field: priority_action_set
      value: "yes"
    }
  }

  measure: count_priority_dashboard_id_set {
    type: count_distinct
    sql: ${account_id} ;;
    sql_distinct_key: ${account_id} ;;
    filters:  {
      field: priority
      value: "yes"
    }
    filters:  {
      field: channel_items_id_is_set
      value: "yes"
    }
  }
}
