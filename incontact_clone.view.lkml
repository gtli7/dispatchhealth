view: incontact_clone {
  derived_table: {
    sql:
    select contact_type, skll_name, from_number, contact_id, to_number, start_time, end_time, campaign, master_contact_id,
    (select array_agg(a) from unnest(agent_name) a where a is not null) agent_name,
    abandons, short_abandons, transferred, queued, busy, answered, abandon_time, short_abandon_time, ivr_time,  talk_time_sec, contact_time_sec, inqueuetime, prequeue_abandons,
    call_backs, (select array_agg(a) from unnest(disposition) a where a is not null) disposition
    from
    (select incontact_clone.contact_type, incontact_clone.skll_name, incontact_clone.from_number, incontact_clone.contact_id, incontact_clone.to_number, incontact_clone.start_time,
incontact_clone.end_time, campaign, master_contact_id,
array_agg(case when incontact_clone.agent_name = '' then null else agent_name end  order by talk_time_sec desc) as agent_name,
max(abandons) abandons, max(incontact_clone.short_abandons) short_abandons, max(incontact_clone.transferred) transferred, max(incontact_clone.queued) queued, max(incontact_clone.busy) busy,
max(incontact_clone.answered) answered, sum(incontact_clone.abandon_time) as abandon_time,
sum(incontact_clone.short_abandon_time) as short_abandon_time, sum(incontact_clone.ivr_time) as ivr_time,
 sum(incontact_clone.talk_time_sec) as talk_time_sec,
 sum(incontact_clone.contact_time_sec) as contact_time_sec,
 sum(incontact_clone.inqueuetime) as inqueuetime, max(prequeue_abandons) as prequeue_abandons, max(call_backs) as call_backs,
array_agg(DISTINCT case when incontact_clone.disposition = '' then null else disposition end ) as disposition
from looker_scratch.incontact_clone
group by 1,2,3,4,5,6,7,8,9)lq

;;
    sql_trigger_value: SELECT MAX(start_time) FROM incontact_clone ;;
    indexes: ["start_time", "campaign", "skll_name", "contact_id", "master_contact_id"]
    }

  dimension: contact_id {
    type: number
    sql: ${TABLE}.contact_id ;;
  }

  dimension: contact_time_sec {
    type: number
    sql: ${TABLE}.contact_time_sec ;;
  }


  dimension_group: today_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: current_date;;
  }

  dimension_group: yesterday_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: current_date - interval '1 day';;
  }

  dimension: month_to_date  {
    type:  yesno
    sql: ${start_day_of_month} < ${today_mountain_day_of_month}  ;;
  }

  dimension: month_to_date_two_days  {
    type:  yesno
    sql: ${start_day_of_month} < (${today_mountain_day_of_month} -1) ;;
  }


  dimension: until_today {
    type: yesno
    sql: ${start_day_of_week_index} <=  ${yesterday_mountain_day_of_week_index} AND ${start_day_of_week_index} >= 0 ;;
  }

  dimension: inqueuetime {
    type: number

    sql: ${TABLE}.inqueuetime ;;
  }

   measure: avg_inqueuetime {
    label: "Average InQueue Time (s)"
    type: average_distinct
    sql_distinct_key: concat(${master_contact_id}, ${end_time}, ${skll_name}, ${agent_name}, ${start_time}) ;;
    value_format: "#.0"
    sql: ${inqueuetime} ;;
  }

  measure: median_inqueuetime {
    label: "Median InQueue Time (s)"
    type: median_distinct
    sql_distinct_key: concat(${master_contact_id}, ${end_time}, ${skll_name}, ${agent_name}, ${start_time}) ;;
    value_format: "#.0"
    sql: ${inqueuetime} ;;
  }


  measure: avg_talk_time {
    label: "Average Talk Time (s)"
    type: average_distinct
    sql_distinct_key: concat(${master_contact_id}, ${end_time}, ${skll_name}, ${agent_name}, ${start_time}) ;;
    value_format: "#.0"
    sql: ${talk_time_sec} ;;
  }

  measure: median_talk_time  {
    label: "Median Talk Time (s)"
    type: median_distinct
    sql_distinct_key: concat(${master_contact_id}, ${end_time}, ${skll_name}, ${agent_name}, ${start_time}) ;;
    value_format: "#.0"
    sql: ${talk_time_sec} ;;
  }

  measure: sum_talk_time {
    label: "Sum Talk Time (s)"
    type: sum_distinct
    sql_distinct_key: concat(${master_contact_id}, ${end_time}, ${skll_name}, ${agent_name}, ${start_time}) ;;
    value_format: "#.0"
    sql: ${talk_time_sec} ;;
  }

  dimension: abandon_time {
    type: number
    sql: ${TABLE}.abandon_time ;;
  }

  measure: avg_abandontime {
    label: "Average Abandon Time (s)"
    type: average_distinct
    sql_distinct_key: concat(${master_contact_id}, ${end_time}, ${skll_name}, ${agent_name}, ${start_time}) ;;
    value_format: "#.0"
    sql: case when ${abandon_time} = 0 then null else ${wait_time} end ;;
  }

  measure: median_abandontime {
    label: "Median Abandon Time (s)"
    type: median_distinct
    sql_distinct_key: concat(${master_contact_id}, ${end_time}, ${skll_name}, ${agent_name}, ${start_time}) ;;
    value_format: "#.0"
    sql: case when ${abandon_time} = 0 then null else ${wait_time} end ;;
  }



  dimension: contact_type {
    type: string
    sql: ${TABLE}.contact_type ;;
  }

  dimension: campaign {
    type: string
    sql: ${TABLE}.campaign ;;
  }

  dimension: duration {
    type: number
    sql: coalesce(${TABLE}.duration,0) ;;
  }

  dimension: disposition {
    type: string
    sql: ${TABLE}.disposition[1] ;;
  }


  dimension_group: end {
    convert_tz: no
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.end_time ;;
  }

  dimension: end_time_raw {
    type: string
    sql: ${TABLE}.end_time ;;
  }

  dimension: start_time_raw {
    type: string
    sql: ${TABLE}.start_time ;;
  }

  dimension: from_number {
    type: string
    sql:   ${TABLE}.from_number;;
  }

  dimension: skll_name {
    type: string
    sql: ${TABLE}.skll_name ;;
  }


  dimension: mvp {
    type: yesno
    sql: ${campaign}='Care Phone' and lower(${skll_name}) like '%mvp%'  ;;
  }

  dimension_group: start {
    convert_tz: no
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day,
      day_of_month,
      day_of_week_index
    ]
    sql: ${TABLE}.start_time ;;
  }

  dimension: after_pilot {
    type: yesno
    sql: ${start_date} > '2018-09-03' ;;
  }

  dimension: talk_time_sec {
    type: number
    sql: coalesce(${TABLE}.talk_time_sec,0) ;;
  }

  dimension: agent_name {
    type: string
    sql: ${TABLE}.agent_name[1] ;;
  }


  dimension: market_id
  {
    type:  number
    sql:  case when lower(${skll_name}) like '%den%' then 159
           when lower(${skll_name}) like '%cos%' then 160
           when lower(${skll_name}) like '%phx%' then 161
           when lower(${skll_name}) like '%ric%'  then 164
           when lower(${skll_name})  like '%las%' then 162
           when lower(${skll_name})  like '%hou%' then 165
          when lower(${skll_name})  like '%okla%' or lower(${skll_name})  like '%okc%' then 166
           else null end ;;
  }
dimension: skill_category {
  type:  string
  sql: case
    when lower(${skll_name}) like '%voicemail%' or lower(${skll_name}) like '% vm%' then 'Voicemail'
    when lower(${skll_name}) like '%outbound%' then 'Outbound'
    else ${campaign} end ;;
}

dimension: abandons {
  type: number
  sql: ${TABLE}.abandons ;;
}

  dimension: answered {
    type: number
    sql: ${TABLE}.answered ;;
  }
  dimension: call_back {
    type: number
    sql: ${TABLE}.call_backs ;;
  }
  dimension: handled {
    type: number
    sql: ${answered} + ${call_back} ;;
  }
  dimension: master_contact_id {
    type: number
    sql: ${TABLE}.master_contact_id ;;
  }
  dimension: prequeue_abandons {
    type: number
    sql: ${TABLE}.prequeue_abandons ;;
  }


  measure: count {
    type: count
    drill_fields: [skll_name]
  }
  measure: count_distinct {
    label: "Contacts"
    type: count_distinct
    sql_distinct_key:  ${master_contact_id};;
    sql: ${master_contact_id} ;;
  }

  measure: count_distinct_inbound {
    label: "Inbound Calls"
    type: number
    sql:count(distinct case when ${campaign} in('Care Phone') then ${master_contact_id} else null end) ;;
  }

  measure: count_distinct_outbound {
    label: "Outbound Calls"
    type: number
    sql:count(distinct case when ${campaign} in('Care Outbound') then ${master_contact_id} else null end) ;;
  }

  measure: close_rate {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat.complete_count}::float/${count_distinct_inbound}::float));;

  }

  measure: cr_create_rate {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat.care_request_count}::float/${count_distinct_inbound}::float));;

  }

  measure: cr_create_rate_exact {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat_exact.care_request_count}::float/${count_distinct_inbound}::float));;

  }

  measure: cr_create_rate_exact_answer {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat_exact.care_request_count}::float/nullif(${count_distinct_live_answers}::float,0)));;

  }

  measure: cr_create_rate_exact_phone {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat_exact.care_request_count}::float/nullif(${count_distinct_phone_number}::float,0)));;

  }

  measure: cr_create_rate_contact_id {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat_contact_id.care_request_count}::float/${count_distinct_inbound}::float));;

  }

  measure: close_rate_contact_id {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat_contact_id.complete_count}::float/${count_distinct_inbound}::float));;

  }



  measure: close_rate_exact {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat_exact.complete_count}::float/${count_distinct}::float));;

  }

  measure: close_rate_exact_answer {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat_exact.complete_count}::float/nullif(${count_distinct_live_answers}::float,0)));;

  }

  measure: close_rate_exact_phone {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat_exact.complete_count}::float/nullif(${count_distinct_phone_number}::float,0)));;

  }



  dimension: phone_call  {
    type: yesno
    sql: ${campaign} not in ('Care Electronic') ;;
  }

  measure: count_distinct_calls {
    label: "Calls"
    type: number
    sql:count(distinct case when (${campaign} != 'Care Electronic')  then ${master_contact_id} else null end);;

  }

  measure: count_distinct_live_answers {
    label: "Live Answers"
    type: number
    sql:  count(distinct case when (${answered}=1 and ${campaign} != 'VM')  then ${master_contact_id} else null end);;

  }

  measure: count_distinct_handled {
    label: "Handles"
    type: number
    sql:  count(distinct case when (${answered}=1 or ${call_back}=1 or ${campaign} = 'VM') then ${master_contact_id} else null end);;

  }

  measure: count_distinct_voicemails {
    type: number
    label: "Voicemails"
    sql:  count(distinct case when ${campaign} = 'VM' then ${master_contact_id} else null end);;
  }


  measure: count_distinct_abandoned {
    type: number
    label: "Total Abandons"
    sql:  count(distinct case when (${abandons}=1 or ${prequeue_abandons}=1) and ${campaign} !='VM'  then ${master_contact_id} else null end);;
  }

  measure: count_distinct_long_abandoned {
    type: number
    label: "Long Abandons (>20s)"
    sql:  count(distinct case when ((${abandons}=1 or ${prequeue_abandons}=1) and ${campaign} !='VM') and ${wait_time} > 20  then ${master_contact_id} else null end);;
  }

  measure: count_distinct_long_abandoned_15 {
    type: number
    label: "Abandons (>15s)"
    sql:  count(distinct case when ((${abandons}=1 or ${prequeue_abandons}=1) and ${campaign} !='VM') and ${wait_time} > 15  then ${master_contact_id} else null end);;
  }

  measure: count_distinct_long_abandoned_10 {
    type: number
    label: "Abandons (>10s)"
    sql:  count(distinct case when ((${abandons}=1 or ${prequeue_abandons}=1) and ${campaign} !='VM') and ${wait_time} > 10  then ${master_contact_id} else null end);;
  }

  measure: count_distinct_long_abandoned_5 {
    type: number
    label: "Abandons (>5s)"
    sql:  count(distinct case when ((${abandons}=1 or ${prequeue_abandons}=1) and ${campaign} !='VM') and ${wait_time} > 5  then ${master_contact_id} else null end);;
  }

  measure: live_answer_rate {
    type: number
    value_format: "#.0\%"
    sql: ((${count_distinct_live_answers}::float/${count_distinct_calls}::float))*100;;
  }

  measure: handled_rate {
    type: number
    value_format: "#.0\%"
    sql: ((${count_distinct_handled}::float/${count_distinct_calls}::float))*100;;
  }

  measure: abandoned_rate {
    type: number
    label: "Total Abandon Rate"
    value_format: "#.0\%"
    sql: ((${count_distinct_abandoned}::float/${count_distinct_calls}::float))*100;;
  }

  measure: long_abandoned_rate {
    type: number
    label: "Long Abandon Rate (>20s)"
    value_format: "#.0\%"
    sql: ((${count_distinct_long_abandoned}::float/${count_distinct_calls}::float))*100;;
  }

  measure: long_abandoned_rate_10 {
    type: number
    label: "Abandon Rate (>10s)"
    value_format: "#.0\%"
    sql: ((${count_distinct_long_abandoned_10}::float/${count_distinct_calls}::float))*100;;
  }

  measure: long_abandoned_rate_5 {
    type: number
    label: "Abandon Rate (>5s)"
    value_format: "#.0\%"
    sql: ((${count_distinct_long_abandoned_5}::float/${count_distinct_calls}::float))*100;;
  }

  measure: long_abandoned_rate_15 {
    type: number
    label: "Abandon Rate (>15s)"
    value_format: "#.0\%"
    sql: ((${count_distinct_long_abandoned_15}::float/${count_distinct_calls}::float))*100;;
  }







dimension: care_line {
  type: yesno
  sql: (${campaign} in('Care Phone', 'VM') and ${contact_type} != 'Transfer to Agent') or ${invoca_clone.call_record_ikd} is not null;;
}


  measure: count_distinct_phone_number {
    type: number
    sql:count(distinct ${from_number}) ;;
  }


  measure: count_distinct_answers_phone_number {
    type: number
    sql:count(distinct case when ${talk_time_sec}>0  then ${from_number} else null end) ;;
  }

  dimension:  wait_time{
    type: number
    sql: ${contact_time_sec} - ${talk_time_sec} ;;
  }

  dimension:  wait_time_band{
  type: string
  sql:round(ln(${wait_time}),0)
            ;;
 }

  measure:  average_wait_time{
    label: "Average Wait Time (s)"
    type: average_distinct
    value_format: "0.0"
    sql_distinct_key: concat(${master_contact_id}, ${end_time}, ${skll_name}, ${agent_name}, ${start_time}) ;;
    sql: ${wait_time} ;;
  }


  measure:  median_wait_time{
    label: "Median Wait Time (s)"
    type: median_distinct
    value_format: "0.0"
    sql_distinct_key: concat(${master_contact_id}, ${end_time}, ${skll_name}, ${agent_name}, ${start_time}) ;;
    sql: ${wait_time} ;;
  }

  dimension: conversion_rate_eligible  {
    type: yesno
    sql: ${abandons} > 0 or lower(${disposition}) not in ('junk', 'spam') or ${disposition} is null or lower(${campaign}) = 'care electronic';;

  }

  measure: care_contacts {
    type: count_distinct
    sql_distinct_key: ${master_contact_id} ;;
    sql: ${master_contact_id} ;;
    filters: {
      field: campaign
      value: "Care Electronic, Care Phone"
    }

  }

  measure: electronic_contacts {
    type: count_distinct
    label: "Web or Mobile Contacts"
    sql_distinct_key: ${master_contact_id} ;;
    sql: ${master_contact_id} ;;
    filters: {
      field: campaign
      value: "Care Electronic"
    }
  }

  measure: requesting_care_calls{
    type: count_distinct
    sql_distinct_key: ${master_contact_id} ;;
    sql: ${master_contact_id} ;;
    filters: {
      field: disposition
      value: "Requesting Care"
    }
    filters: {
      field: answered
      value: "1"
    }
  }

  measure: general_inquiry_calls{
    type: count_distinct
    sql_distinct_key: ${master_contact_id} ;;
    sql: ${master_contact_id} ;;
    filters: {
      field: disposition
      value: "General Inquiry"
    }
    filters: {
      field: answered
      value: "1"
    }
  }
    measure: junk_calls{
      type: count_distinct
      sql_distinct_key: ${master_contact_id} ;;
      sql: ${master_contact_id} ;;
      filters: {
        field: disposition
        value: "Junk"
      }
      filters: {
        field: answered
        value: "1"
      }
  }

  measure: booked_calls{
    type: count_distinct
    sql_distinct_key: ${master_contact_id} ;;
    sql: ${master_contact_id} ;;
    filters: {
      field: disposition
      value: "Booked"
    }
    filters: {
      field: answered
      value: "1"
    }
  }

  dimension: non_answered_care_calls {
    type: yesno
    sql:  ${campaign} = 'Care Phone' and ${answered}= 0 ;;
  }

  measure: no_answer_calls{
    type: count_distinct
    label: "Abandoned Phone Calls"
    sql_distinct_key: ${master_contact_id} ;;
    sql: ${master_contact_id} ;;
    filters: {
      field: non_answered_care_calls
      value: "Yes"
    }
  }

  dimension: other_or_null_disposition {
    type: yesno
    label: "Other/Null Disposition"
    sql: (${disposition} not in('Junk', 'Booked', 'Requesting Care', 'General Inquiry') or ${disposition} is null) and ${campaign} = 'Care Phone' and ${answered}!= 0 ;;
  }

  measure: other_calls {
    type: count_distinct
    sql_distinct_key: ${master_contact_id} ;;
    sql: ${master_contact_id} ;;
    filters: {
      field: other_or_null_disposition
      value: "yes"
    }
  }





}
