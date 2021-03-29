view: intraday_care_requests {
  sql_table_name: public.intraday_care_requests ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: accepted {
    type: yesno
    sql: ${accepted_time} is not null;;
  }

  dimension: complete {
    type: yesno
    sql: ${complete_time} is not null or lower(${archive_comment}) like '%referred - point of care%';;
  }

  dimension: escalated_on_scene {
    type: yesno
    sql: lower(${archive_comment}) like '%referred - point of care%';;
  }
  dimension: complete_accepted_inqueue{
    sql: case when ${complete} then 'complete'
              when ${accepted} and not ${resolved} then 'accepted'
              when ${current_status} = 'requested' and not ${resolved} and not ${stuck_inqueue} and not ${accepted} then 'inqueue'
              else null end;;
  }

  dimension: resolved {
    type: yesno
    sql: ${complete_time} is null and (${archived_time} is not null and lower(${archive_comment}) not like '%referred - point of care%');;
  }


  dimension: meta_data {
    type: string
    sql: ${TABLE}.meta_data ;;
  }

  dimension: etos {
    type: number
    sql: (${TABLE}.meta_data ->> 'etos')::int *60.0;;
  }

  measure: sum_etos {
    type: sum_distinct
    sql: ${etos} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: complete
      value: "no"
    }
    filters: {
      field: accepted
      value: "yes"
    }
  }

  dimension: drive_time {
    type: number
    sql: (${TABLE}.meta_data ->> 'drive_time')::int ;;


  }

  measure: sum_drive_time {
    type: sum_distinct
    sql: ${drive_time} ;;
    sql_distinct_key: ${care_request_id} ;;
    filters: {
      field: complete
      value: "no"
    }
    filters: {
      field: accepted
      value: "yes"
    }
  }

  dimension: etos_interval {
    type: number
    sql: concat('''', (${TABLE}.meta_data ->> 'etos')::varchar, ' minute''') ;;
  }

  dimension: channel_item_id {
    type: number
    sql: (${TABLE}.meta_data ->> 'channel_item_id')::int ;;
  }

  dimension: market_id {
    type: number
    sql: (${TABLE}.meta_data ->> 'market_id')::int ;;
  }

  dimension: package_id {
    type: number
    sql: case when (${TABLE}.meta_data ->> 'package_id')='' then 9999999999999999
    else (${TABLE}.meta_data ->> 'package_id')::int end;;
  }

  dimension: shift_team_id {
    type: number
    sql: (${TABLE}.meta_data ->> 'shift_team_id')::int ;;
  }

  dimension: current_status {
    type: string
    sql: ${TABLE}.meta_data ->> 'current_status' ;;
  }

  dimension: complete_comment {
    type: string
    sql: ${TABLE}.meta_data ->> 'complete_comment' ;;
  }

  dimension: archive_comment {
    type: string
    sql: ${TABLE}.meta_data ->> 'archived_status_comments' ;;
  }

  dimension: service_line_id {
    type: string
    sql: ${TABLE}.meta_data ->> 'service_line_id'::varchar ;;
  }

  dimension: zipcode {
    type: string
    sql: left(${TABLE}.meta_data ->> 'zipcode',5);;
  }

  dimension: smfr_care_request{
    type: yesno
    sql:  ${zipcode} in('80122', '80123', '80124', '80125', '80126', '80128', '80134', '80135', '80138', '80210', '80222', '80224', '80231', '80235', '80237', '80013', '80014', '80015', '80016', '80018', '80104', '80110', '80111', '80112', '80120', '80121');;
  }

  dimension: wmfr_care_request{
    type: yesno
    sql:  ${zipcode} in('80215', '80226', '80232', '80228', '80214');;
  }



  dimension: care_request_location {
    type: location
    sql_latitude: ${TABLE}.meta_data ->> 'latitude' ;;
    sql_longitude: ${TABLE}.meta_data ->> 'longitude' ;;
  }

  dimension_group: etc {
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
    sql: (meta_data->>'etc')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: care_request_created {
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
      day_of_week
    ]
    sql: (meta_data->>'created_at')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: accepted {
    type: time
    timeframes: [
      raw,
      minute15,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day,
      day_of_week
    ]
    sql: (meta_data->>'accepted_at')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: complete {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day, day_of_week
    ]
    sql: (meta_data->>'completed_at')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: archived {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
       hour_of_day, day_of_week
    ]
    sql: (meta_data->>'archived_at')::timestamp WITH TIME ZONE ;;
  }


  dimension_group: updated {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day, day_of_week
    ]
    sql: ${TABLE}.updated_at ;;
  }

  dimension: stuck_inqueue {
    type: yesno
    sql: ${care_request_id} in(64317) ;;
  }
  measure: inqueue_crs {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: stuck_inqueue
      value: "no"
    }
  }

  measure: inqueue_crs_tricare {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(TC)TRICARE"
    }
    filters: {
      field: stuck_inqueue
      value: "no"
    }

  }

  measure: inqueue_crs_less_than_30_minutes {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: less_than_30_minutes_since_creation
      value: "yes"
    }
    filters: {
      field: stuck_inqueue
      value: "no"
    }

  }

  measure: inqueue_smfr_elgible {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: smfr_care_request
      value: "yes"
    }
    filters: {
      field: stuck_inqueue
      value: "no"
    }


  }

  measure: inqueue_wmfr_elgible {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: wmfr_care_request
      value: "yes"
    }
    filters: {
      field: stuck_inqueue
      value: "no"
    }


  }

  dimension: uhc_care_request {
    type: yesno
    sql:${channel_item_id} in(2851, 2849, 2850, 2852, 2848, 2890, 2900);;
  }

  measure: inqueue_crs_uhc {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: uhc_care_request
      value: "yes"
    }

  }

  measure: resolved_crs_uhc {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: resolved
      value: "yes"
    }
    filters: {
      field: uhc_care_request
      value: "yes"
    }

  }

  measure: accepted_crs_uhc {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "yes"
    }
    filters: {
      field: uhc_care_request
      value: "yes"
    }
    filters: {
      field: resolved
      value: "no"
    }
  }

  measure: complete_crs_uhc {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: complete
      value: "yes"
    }
    filters: {
      field: uhc_care_request
      value: "yes"
    }
  }

  measure: inqueue_crs_medicaid {
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(MAID)MEDICAID"
    }

  }

  measure: inqueue_crs_pafu {
    label: "Inqueue CRS Bridge Care Visits"
    type: count_distinct
    sql: ${care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: service_lines_intra.id
      value: "2,6"
    }

  }

  measure: inqueue_crs_medicaid_tricare {
    type: number
    sql:  ${inqueue_crs_medicaid}+${inqueue_crs_tricare};;
  }

  measure: count_distinct {
    type: count_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${care_request_id} ;;
  }

  dimension: accepted_today {
    type: yesno
    sql: ${accepted_date} = date(now() AT TIME ZONE 'US/Mountain') ;;
  }

  dimension: accepted_mountain_decimal {
    type: number
    value_format: "0.00"
    sql:
    (CAST(EXTRACT(HOUR FROM ${accepted_raw} AT TIME ZONE 'US/Mountain') AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${accepted_raw} AT TIME ZONE 'US/Mountain' ) AS FLOAT)) / 60);;
  }

  dimension: care_request_created_mountain_decimal {
    type: number
    value_format: "0.00"
    sql:
    (CAST(EXTRACT(HOUR FROM ${care_request_created_raw} AT TIME ZONE 'US/Mountain') AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${care_request_created_raw} AT TIME ZONE 'US/Mountain' ) AS FLOAT)) / 60);;
  }

  dimension: complete_mountain_decimal {
    type: number
    value_format: "0.00"
    sql:
    (CAST(EXTRACT(HOUR FROM ${complete_raw} AT TIME ZONE 'US/Mountain') AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${complete_raw} AT TIME ZONE 'US/Mountain' ) AS FLOAT)) / 60);;
  }
  dimension_group: now_mountain{
    type: time
    convert_tz: no
    timeframes: [day_of_week_index, week, month, day_of_month, time_of_day,raw, date]
    sql:  now() AT TIME ZONE 'US/Mountain' ;;
  }

  dimension: now_mountain_decimal {
    type: number
    value_format: "0.00"
    sql:
    (CAST(EXTRACT(HOUR FROM ${now_mountain_raw} ) AS INT)) +
      ((CAST(EXTRACT(MINUTE FROM ${now_mountain_raw} ) AS FLOAT)) / 60);;
  }

  dimension: before_now_accepted {
    type: yesno
    sql: ${accepted_mountain_decimal} <= ${now_mountain_decimal};;
  }

  dimension: before_now_created {
    type: yesno
    sql: ${care_request_created_mountain_decimal} <= ${now_mountain_decimal};;
  }

  dimension: before_now_complete {
    type: yesno
    sql: ${complete_mountain_decimal} <= ${now_mountain_decimal};;
  }

  dimension: created_to_now_diff_hours {
    type: number
    sql: EXTRACT(EPOCH FROM ${now_mountain_raw} - (${care_request_created_raw} AT TIME ZONE 'US/Mountain'))/3600 ;;
  }

  dimension: less_than_30_minutes_since_creation{
    type: yesno
    sql:  ${created_to_now_diff_hours} < .5;;

  }

  dimension: address {
    type: string
    sql:  (meta_data ->> 'street_address_1') ;;
  }

  dimension: patient_dob {
    type: date
    sql:  (meta_data ->> 'patient_dob') ;;
  }

  dimension: risk_protocol_name {
    type: string
    sql:  trim(lower((meta_data ->> 'risk_protocol_name'))) ;;
  }

  dimension: risk_score {
    type: number
    sql:  (meta_data ->> 'risk_score')::float ;;
  }

  dimension: risk_worst_case_score {
    type: string
    sql:  (meta_data ->> 'risk_worst_case_score') ;;
  }

  dimension: risk_protocol {
    type: string
    sql:  (meta_data ->> 'risk_protocol') ;;
  }

  dimension_group: on_accepted_eta {
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
      day_of_week
    ]
    sql: (meta_data->>'on_accepted_eta')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: on_route_eta {
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
      day_of_week
    ]
    sql: (meta_data->>'on_route_eta')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: estimated_eta {
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
      day_of_week
    ]
    sql: (${etc_raw} -${etos_interval}::interval)::timestamp WITH TIME ZONE ;;
  }

  dimension_group: eta_coalesce {
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
      day_of_week
    ]
    sql: coalesce(${estimated_eta_raw}, ${on_route_eta_raw}, ${on_accepted_eta_raw});;
  }

  dimension: risk_category {
    type: string
    description: "0 - 5.4 = Green, 5.5 - 9.9 = Yellow, 10+ = Red"
    sql: CASE
          WHEN ${risk_score} >= 0 AND ${risk_score} < 5.5 THEN 'Green - Low Risk'
          WHEN ${risk_score} >= 5.5 AND ${risk_score} < 10 THEN 'Yellow - Medium Risk'
          WHEN ${risk_score} >= 10 THEN 'Red - High Risk'
          ELSE 'Unknown'
        END ;;
  }

  dimension: age {
    type: number
    sql: CAST(EXTRACT(YEAR from AGE(${now_mountain_date}, ${patient_dob})) AS INT) ;;
  }

  dimension: telemedicine_eligible{
    type: yesno
    sql:
    ${risk_category} = 'Green - Low Risk'
    AND
    ${risk_protocol_name} in('general complaint', 'sore throat', 'sore throat 2', 'headache', 'ear pain', 'rash', 'rash - pediatric', 'cough/upper respiratory symptoms', 'cough/upper respiratory infection', 'cough/uri', 'rash', 'rash - pediatric', 'sinus pain', 'flu-like symptoms')
    AND
    ${markets_intra.name} in ('Denver', 'Colorado Springs')
    and
    ${age} > 2
    and ${primary_payer_dimensions_intra.custom_insurance_grouping} in('(MCARE)MEDICARE', '(MAID)MEDICAID')
    ;;

  }


  dimension: now_to_on_scene {
    label: "Time to On-scene Hours"
    type: number
    value_format: "0.0"
    sql: EXTRACT(EPOCH FROM  (${eta_coalesce_raw} AT TIME ZONE 'US/Mountain') - ${now_mountain_raw})/3600 ;;
  }



 # dimension: inqueue_over_hour {
#    type: yesno
#    sql:  ;;
#  }



  measure: count {
    type: count
    drill_fields: [id]
  }
}
