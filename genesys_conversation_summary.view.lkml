view: genesys_conversation_summary {
  sql_table_name: looker_scratch.genesys_conversation_summary ;;

  dimension: inbound_demand {
    type: yesno
    sql:${inbound_demand_minus_market} and (${markets.id} is not null);;
  }

  dimension: inbound_demand_minus_market {
    type: yesno
    sql:
    ${mediatype}='voice' and trim(lower(${queuename})) not like '%outbound%' and trim(lower(${queuename})) not like '%after hours%' and trim(lower(${queuename})) not like '%optimizer%' and trim(lower(${queuename})) not in('mobile requests','ma', 'rcm / billing', 'backline', 'development', 'secondary screening', 'dispatchhealth help desk', 'dispatch health nurse line', 'zzavtextest', 'pay bill', 'testing', 'initial follow up', 'rn1', 'rn2', 'rn3', 'rn4', 'rn5', 'rn6', 'rn7', 'rn8', 'rn9', 'ivr fail safe', 'covid testing results', 'ebony testing', 'ma/nurse', 'dispatchhealth help desk vendor', 'do not use ma/nurse', 'sem vip', 'covid task force', 'covid pierce county mass testing', 'acute care covid results & care request', 'phx', 'mobile request callbacks', 'click to call', 'dialer results', 'cancels', 'care team escalations', 'rn10', 'advance care fax queue', 'rn11', 'rn12', 'rn13','rn14', 'spanish ivr', 'vip help line', 'kaiser ma email', 'care web chat lab results', 'zztest_delete');;

  }

  dimension: abandoned {
    type: number
    sql: ${TABLE}."abandoned" ;;
  }


  dimension: ani {
    label: "incoming phone numbers"
    type: string
    sql: ${TABLE}."ani" ;;
  }

  dimension: patient_number {
    type: number
    sql: case when  ${direction} ='inbound' then ${ani}
              when ${direction} = 'outbound' then ${dnis}
              else null end;;
  }

  dimension: answered {
    type: number
    sql: case when ${totalagenttalkduration} >0 or  ${TABLE}."answered" >0 then 1 else 0 end ;;
  }

  dimension: answered_long {
    type: yesno
    sql: ${totalagenttalkduration} >60000  ;;
  }


  dimension: campaignname {
    type: string
    sql: ${TABLE}."campaignname" ;;
  }

  dimension: conversationid {
    type: string
    sql: ${TABLE}."conversationid" ;;
  }
  dimension: after_ivr_turned_off {
    type: yesno
    sql: ${conversationstarttime_date} >='2021-03-09' ;;
  }

  dimension_group: conversationstarttime {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      day_of_week,
      day_of_week_index,
      hour_of_day,
      quarter,
      year
    ]
    sql: ${TABLE}."conversationstarttime" AT TIME ZONE 'UTC';;
  }
  dimension: hhs_removed {
    type: yesno
    sql: ${conversationstarttime_date} >='2021-03-04';;
  }

  dimension_group: month_placeholder {
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
    sql: '2019-07-05 00:00:00'::timestamp  ;;
  }


  dimension: direction {
    type: string
    sql: ${TABLE}."direction" ;;
  }

  dimension: dnis {
    type: string
    sql: case when  ${direction} ='inbound' then ${TABLE}."dnis"
              when ${direction} = 'outbound' then  ${inbound_not_answered_or_abandoned.dnis}
              else null end
    ;;
  }

  dimension: dnis_raw {
    type: string
    sql:  ${TABLE}."dnis"
    ;;
  }

  dimension: partner_dnis_adj{
    type: string
    sql: case when ${dnis_raw}='+17205889686' then 'Kaiser'
              when ${dnis_raw}='+17028748811' then 'HPN'
               when ${dnis_raw}='+17026596193' then 'RCC'
              when ${dnis_raw}='+18136025311' then 'WellMed'
              else ${queuename_adj} end
              ;;
  }



  dimension: market_id {
    type: string
    sql: case when ${number_to_market.market_id} is not null then  ${number_to_market.market_id}
     when trim(lower(${queuename})) in ('las pafu callback') then 162
    when trim(lower(${queuename})) in ('tac pafu callback') then 170
    when trim(lower(${queuename})) in ('phx pafu callback', 'phx') then 161
    when trim(lower(${queuename})) in ('hrt care') then 186
     when trim(lower(${queuename})) in ('boi regence') then 176
    when trim(lower(${queuename})) in ('atl optum care') then 177
    when trim(lower(${queuename})) in ('spo regence','spo post acute') then 173
     when trim(lower(${queuename})) in ('dfw home health dallas') then 169
     when trim(lower(${queuename})) in ('den php', 'kaiser') then 159
    when trim(lower(${queuename})) in ('rno post acute') then 179
    when trim(lower(${queuename})) in ('sea regence') then 174
     when trim(lower(${queuename})) in ('por regence', 'por legacy health charity care') then 175
     when trim(lower(${queuename})) in ('fort worth home health') then 178
     when ${direction} = 'outbound' and trim(lower(${queuename})) in ('general care', 'partner direct', 'pafu callback', 'sweeper callback', 'dtc', 'dtc pilot', 'care web chat', 'aoc premier', 'sms dcm campaign', 'national pafu callback', 'uhc partner direct', 'humana partner direct') then 167


    else null end;;
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

  dimension: queuename_adj {
    type: string
    sql: case when ${queuename} in('TIER 1', 'TIER 2') then 'TIER 1/TIER 2'
      when ${queuename} in('Partner Direct', 'ATL Optum Care', 'LAS RCC', 'Humana Partner Direct', 'BOI Regence', 'POR Regence', 'SEA Regence', 'SPO Regence' ) then 'Partner Direct (Broad)'
      when ${queuename} in('DEN LAS SEM VIP', 'DTC Pilot') then 'DTC Pilot'
    else ${queuename}  end ;;
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

  dimension: long_abandon {
    type: yesno
    sql: ${abandoned} = 1 and ${firstacdwaitduration} > 20000 ;;
  }

  dimension: short_abandon {
    type: yesno
    sql: ${abandoned} = 1 and ${firstacdwaitduration} between 1 and  20000 ;;
  }

  dimension: service_level_target {
    type: number
    sql: case when lower(${queuename}) in('partner direct', 'humana partner direct', 'atl optum care', 'uhc partner direct', 'uhc nurse line') then 10000
          when ${inbound_demand} then 20000
          else null end;;
  }

  dimension: service_level {
    type: yesno
    sql: ${service_level_target} is not null and (${firstacdwaitduration} < ${service_level_target} or ${firstacdwaitduration} is null) ;;
  }

  measure: count {
    type: count
    drill_fields: [campaignname, queuename]
  }

  measure: count_distinct {
    label: "Count Distinct (Inbound Demand)"
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key:  ${conversationid};;
    filters: {
      field: inbound_demand
      value: "yes"
    }
  }

  measure: distinct_callers_raw {
    type: count_distinct
    sql: ${patient_number};;
    sql_distinct_key: ${patient_number};;
    filters: {
      field: inbound_demand
      value: "yes"
    }
  }

  measure: count_distinct_first {
    label: "Count Distinct (Inbound Demand First)"
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key:  ${conversationid};;
    filters: {
      field: inbound_demand
      value: "yes"
    }
    filters: {
      field: direction
      value: "inbound"
    }
  }

  measure: not_answered {
    label: "Not Answered (Inbound Demand)"
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid} ;;
    filters: {
      field: inbound_demand
      value: "yes"
    }
    filters: {
      field: answered
      value: "0"
    }
  }

  measure: count_distinct_sla {
    label: "Count Distinct SLA (Inbound Demand)"
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key:  ${conversationid};;
    filters: {
      field: inbound_demand
      value: "yes"
    }
    filters: {
      field: service_level
      value: "yes"
    }
    filters: {
      field: direction
      value: "inbound"
    }
  }

  measure: count_distinct_sla_callers {
    label: "Count Distinct SLA (Inbound Demand)"
    type: count_distinct
    sql: ${patient_number} ;;
    sql_distinct_key:  ${patient_number};;
    filters: {
      field: inbound_demand
      value: "yes"
    }
    filters: {
      field: service_level
      value: "yes"
    }
    filters: {
      field: direction
      value: "inbound"
    }
  }

  measure: answer_rate {
    type: number
    value_format: "0%"
    sql: ${distinct_answer_callers}::float/(nullif(${distinct_callers},0))::float ;;
  }

  measure: sla_percent {
    type: number
    value_format: "0%"
    sql: ${count_distinct_sla}::float/(nullif(${count_distinct_first},0))::float;;
  }


  measure: daily_average_inbound_demand {
    type: number
    value_format: "0.0"
    sql: ${count_distinct}::float/(nullif(${count_distinct_days},0))::float  ;;
  }

  measure: weekly_average_inbound_demand {
    type: number
    value_format: "0.0"
    sql: ${count_distinct}/(nullif(${count_distinct_weeks},0))::float  ;;
  }



  measure: count_distinct_days {
    type: count_distinct
    sql_distinct_key: ${conversationstarttime_date} ;;
    sql: ${conversationstarttime_date} ;;

  }


  measure: count_distinct_weeks {
    type: count_distinct
    sql_distinct_key: ${conversationstarttime_week} ;;
    sql: ${conversationstarttime_week} ;;

  }

  measure: distinct_callers {
    type: count_distinct
    sql: concat(${patient_number}, ${conversationstarttime_hour_of_day}, ${conversationstarttime_date}) ;;
    sql_distinct_key: concat(${patient_number}, ${conversationstarttime_hour_of_day}, ${conversationstarttime_date});;
    filters: {
      field: inbound_demand
      value: "yes"
    }
  }

  measure: distinct_answer_long_callers{
    type: count_distinct
    sql: concat(${patient_number}, ${conversationstarttime_hour_of_day}, ${conversationstarttime_date});;
    sql_distinct_key: concat(${patient_number}, ${conversationstarttime_hour_of_day}, ${conversationstarttime_date}) ;;
    filters: {
      field: inbound_demand
      value: "yes"
    }
    filters: {
      field: answered_long
      value: "yes"
    }
  }

  measure: distinct_answer_callers{
    type: count_distinct
    sql: concat(${patient_number}, ${conversationstarttime_hour_of_day}, ${conversationstarttime_date}) ;;
    sql_distinct_key:concat(${patient_number}, ${conversationstarttime_hour_of_day}, ${conversationstarttime_date}) ;;
    filters: {
      field: inbound_demand
      value: "yes"
    }
    filters: {
      field: answered
      value: "1"
    }
  }


  measure: distinct_repeat_callers {
    type: number
    sql: ${count_distinct}-${distinct_callers_raw} ;;
  }


  dimension:  same_day_of_week {
    type: yesno
    sql:  ${yesterday_mountain_day_of_week_index} = ${conversationstarttime_day_of_week_index};;
  }

measure: distinct_one_time_callers{
  type:  number
  sql: ${count_distinct}-${distinct_repeat_callers} ;;
}

measure: percent_repeat_callers {
  type: number
  value_format: "0%"
  sql:${distinct_repeat_callers}::float/(nullif(${count_distinct},0))::float  ;;
}

  dimension_group: last_week_mountain{
    type: time
    timeframes: [date, day_of_week_index, week, month, day_of_month]
    sql: current_date - interval '7 day';;
  }


  dimension: last_week {
    type:  yesno
    sql: ${last_week_mountain_week} =  ${conversationstarttime_week};;

  }

  dimension: this_week {
    type:  yesno
    sql: ${yesterday_mountain_week} =  ${conversationstarttime_week};;

  }



  measure: count_distinct_minus_market {
    label: "Count Distinct (Inbound Demand Minus Market)"
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key:  ${conversationid};;
    filters: {
      field: inbound_demand_minus_market
      value: "yes"
    }
  }

  measure: count_distinct_non_inbound {
    label: "Count Distinct (Non-Inbound Demand)"
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key:  ${conversationid};;
    filters: {
      field: inbound_demand
      value: "no"
    }
  }

  measure: non_initiating_care_count {
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key:  ${conversationid};;
    filters: {
      field: inbound_demand
      value: "no"
    }
    filters: {
      field: direction
      value: "inbound"
    }
  }

  measure: number_abandons {
    label: "Number of Abandons (Inbound Demand)"
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid}  ;;
    filters: {
      field: abandoned
      value: "1"
    }
    filters: {
      field: inbound_demand
      value: "yes"
    }
  }

  measure: max_start {
    type: time
    description: "The local date/time that the care request team arrived on-scene"
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


  dimension_group: yesterday_mountain{
    type: time
    timeframes: [date, day_of_week_index, week, month, day_of_month]
    sql: current_date - interval '1 day';;
  }


  measure: month_percent_created {
    type: number
    sql:

        case when to_char(${max_start_date} , 'YYYY-MM') != ${yesterday_mountain_month} then 1
        else
            extract(day from ${yesterday_mountain_date})
          /    DATE_PART('days',
              DATE_TRUNC('month', ${yesterday_mountain_date})
              + '1 MONTH'::INTERVAL
              - '1 DAY'::INTERVAL
          ) end;;
  }

  measure: long_abandons {
    label: "Number of Long Abandons (Inbound Demand)"

    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid}  ;;
    filters: {
      field: abandoned
      value: "1"
    }
    filters: {
      field: long_abandon
      value: "yes"
    }
    filters: {
      field: inbound_demand
      value: "yes"
    }
  }

  measure: short_abandons {
    label: "Number of Short Abandons (Inbound Demand)"
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid}  ;;
    filters: {
      field: abandoned
      value: "1"
    }
    filters: {
      field: short_abandon
      value: "yes"
    }
    filters: {
      field: inbound_demand
      value: "yes"
    }
  }

  measure: average_wait_time {
    label: "Average Wait Time (Inbound Demand)"
    type: average_distinct
    value_format: "0.00"
    sql_distinct_key: concat(${conversationid}) ;;
    sql: ${firstacdwaitduration} ;;

  }

  measure: average_talk_time {
    label: "Average Talk Time (Inbound Demand)"
    type: average_distinct
    value_format: "0.00"
    sql_distinct_key: concat(${conversationid}, ${queuename}) ;;
    sql: ${totalagenttalkduration} ;;
    filters: {
      field: inbound_demand
      value: "yes"
    }

  }

  measure: average_talk_time_minutes {
    label: "Average Talk Time Minutes (Inbound Demand)"
    type: average_distinct
    value_format: "0.00"
    sql_distinct_key: concat(${conversationid}, ${queuename}) ;;
    sql: ${totalagenttalkduration}::float/1000/60 ;;
    filters: {
      field: inbound_demand
      value: "yes"
    }
  }

  measure: average_talk_time_minutes_non_inbound {
    label: "Average Talk Time Minutes (non-Inbound Demand)"
    type: average_distinct
    value_format: "0.00"
    sql_distinct_key: concat(${conversationid}, ${queuename}) ;;
    sql: ${totalagenttalkduration}::float/1000/60 ;;
    filters: {
      field: inbound_demand
      value: "no"
    }



  }

  measure: median_talk_time_minutes_non_inbound {
    label: "Median Talk Time Minutes (non-Inbound Demand)"
    type: median_distinct
    value_format: "0.00"
    sql_distinct_key: concat(${conversationid}, ${queuename}) ;;
    sql: ${totalagenttalkduration}::float/1000/60 ;;
    filters: {
      field: inbound_demand
      value: "no"
    }



  }


  measure: actuals_compared_to_projections {
    value_format: "0%"
    type: number
    sql: case when ${care_team_projected_volume.sum_projected}>0 then ${count_distinct}::float/${care_team_projected_volume.sum_projected}::float else 0 end;;
  }

  measure: median_talk_time {
    label: "Median Talk Time (Inbound Demand)"
    type: median_distinct
    value_format: "0.00"
    sql_distinct_key: concat(${conversationid}, ${queuename}) ;;
    sql: ${totalagenttalkduration} ;;
    filters: {
      field: inbound_demand
      value: "yes"
    }

  }

  measure: sum_talk_time {
    label: "Sum Talk Time (Inbound Demand)"
    type: sum_distinct
    value_format: "0.00"
    sql_distinct_key: concat(${conversationid}, ${queuename}) ;;
    sql: ${totalagenttalkduration} ;;
    filters: {
      field: inbound_demand
      value: "yes"
    }

  }

  measure: sum_talk_time_non_inbound {
    label: "Sum Talk Time (Non-Inbound Demand)"
    type: sum_distinct
    value_format: "0.00"
    sql_distinct_key: concat(${conversationid}, ${queuename}, ${direction}, ${mediatype}) ;;
    sql: ${totalagenttalkduration} ;;
    filters: {
      field: inbound_demand
      value: "no"
    }

  }


  measure: sum_talk_time_minutes {
    label: "Sum Talk Time (Inbound Demand) Minutes"
    type: sum_distinct
    value_format: "0.00"
    sql_distinct_key: concat(${conversationid}, ${queuename}, ${direction}, ${mediatype}) ;;
    sql: ${totalagenttalkduration}::float/1000/60 ;;
    filters: {
      field: inbound_demand
      value: "yes"
    }

  }

  measure: sum_talk_time_non_inbound_minutes {
    label: "Sum Talk Time (Non-Inbound Demand) Minutes"
    type: sum_distinct
    value_format: "0.00"
    sql_distinct_key: concat(${conversationid}, ${queuename}, ${direction}, ${mediatype}) ;;
    sql: ${totalagenttalkduration}/1000/60 ;;
    filters: {
      field: inbound_demand
      value: "no"
    }

  }


  measure: average_wait_time_minutes {
    label: "Average Wait Time Minutes (Inbound Demand)(First Only)"
    type: average_distinct
    value_format: "0.00"
    sql_distinct_key: concat(${conversationid}) ;;
    sql: ${firstacdwaitduration}::float/1000/60 ;;
    filters: {
      field: inbound_demand
      value: "yes"
    }
    filters: {
      field: direction
      value: "inbound"
    }

  }

  measure: median_wait_time {
    label: "Median Wait Time Minutes (Inbound Demand)"
    type: median_distinct
    value_format: "0.00"
    sql_distinct_key: concat(${conversationid}) ;;
    sql: ${firstacdwaitduration} ;;
    filters: {
      field: inbound_demand
      value: "yes"
    }
  }

  measure: count_general_inquiry {
    label: "Count General Inquiry (Inbound Demand)"
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid}  ;;
    filters: {
      field: genesys_conversation_wrapup.wrapupcodename
      value: "General Inquiry"
    }
    filters: {
      field: inbound_demand
      value: "yes"
    }
  }


  measure: count_care_request_disposition {
    label: "Count Care Request (Inbound Demand)"

    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid}  ;;
    filters: {
      field: genesys_conversation_wrapup.wrapupcodename
      value: "Care Request Created"
    }
    filters: {
      field: inbound_demand
      value: "yes"
    }
  }

  measure: count_answered {
    label: "Count Answered (Inbound Demand)"
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid}  ;;
    filters: {
      field: answered
      value: "1"
    }
    filters: {
      field: inbound_demand
      value: "yes"
    }
  }

  measure: count_answered_non_inbound {
    label: "Count Answered (non-Inbound Demand)"
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid}  ;;
    filters: {
      field: answered
      value: "1"
    }
    filters: {
      field: inbound_demand
      value: "no"
    }
  }

  dimension:  inqueue_time_greater_30{
    type: yesno
    sql: ${firstacdwaitduration}>30000 ;;

  }

  measure:  count_inqeue_time_greater_30s{
    label: "Count Inqeue Time Greater 30s (Inbound Demand)"

    type: count_distinct
    value_format: "0"
    sql_distinct_key: ${conversationid} ;;
    sql: ${conversationid} ;;
    filters: {
      field: inqueue_time_greater_30
      value: "yes"
    }
    filters: {
      field: inbound_demand
      value: "yes"
    }



  }

  dimension:  inqueue_time_greater_10{
    type: yesno
    sql: ${firstacdwaitduration}>10000 ;;
  }

  measure:  count_inqeue_time_greater_10s{
    label: "Count Inqeue Time Greater 10s (Inbound Demand)"

    type: count_distinct
    value_format: "0"
    sql_distinct_key: ${conversationid} ;;
    sql: ${conversationid} ;;
    filters: {
      field: inqueue_time_greater_10
      value: "yes"
    }
    filters: {
      field: inbound_demand
      value: "yes"
    }

  }

  dimension:  inqueue_time_greater_45{
    type: yesno
    sql: ${firstacdwaitduration}>45000 ;;
  }

  measure:  count_inqeue_time_greater_45s{
    label: "Count Inqeue Time Greater 45 (Inbound Demand)"

    type: count_distinct
    value_format: "0"
    sql_distinct_key: ${conversationid} ;;
    sql: ${conversationid} ;;
    filters: {
      field: inqueue_time_greater_45
      value: "yes"
    }
    filters: {
      field: inbound_demand
      value: "yes"
    }
  }

  dimension: handle_time {
    type: number
    sql: coalesce(${totalagentholdduration},0)+coalesce(${totalagenttalkduration},0)+coalesce(${totalagentwrapupduration},0);;
  }

  measure: average_handle_time {
    label: "Average Handle Time (Minutes)"

    type: average_distinct
    sql: ${handle_time}::float/1000/60 ;;
    sql_distinct_key:  concat(${conversationid}, ${queuename});;
    value_format: "0.00"
    filters: {
      field: answered
      value: "1"
    }
  }

  measure: total_handle_time {
    label: "Total Handle Time (Minutes)"

    type: sum_distinct
    sql: ${handle_time}::float/1000/60 ;;
    sql_distinct_key:  concat(${conversationid}, ${queuename});;
    value_format: "0.00"
    filters: {
      field: answered
      value: "1"
    }
  }

  dimension: onboard_delay {
    type: number
    sql: (EXTRACT(EPOCH FROM (${care_request_flat.accept_mountain_intial_raw} - ${conversationstarttime_raw}))-${firstacdwaitduration}/1000)/60;;
  }

  measure: median_onboard_delay {
    type: median_distinct
    value_format: "0.0"
    sql_distinct_key: concat(${conversationid}, ${care_request_flat.care_request_id}) ;;
    sql: ${onboard_delay} ;;
  }

  measure: average_onboard_delay {
    type: average_distinct
    value_format: "0.0"
    sql_distinct_key: concat(${conversationid}, ${care_request_flat.care_request_id}) ;;
    sql: ${onboard_delay} ;;
  }

  dimension: anthem_eligible {
    type: yesno
    sql: ${transfered} = 0 and ${markets.name_adj} = 'Richmond' ;;
  }

  #dimension: dispositions_raw {
  #  type: string
  #  sql: array_agg(DISTINCT case when ${genesys_conversation_wrapup.wrapupcodename} = '' then null else ${genesys_conversation_wrapup.wrapupcodename} end ) ;;
  #}

  #measure: dispositions {
  #  type: string
  #  sql: (select array_agg(a) from ${genesys_conversation_wrapup.wrapupcodename} where a is not null);;
  #}



  #dimension: disposition {
  #  type: string
  #  sql: ${dispositions}[1] ;;
  #}
}
