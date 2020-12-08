view: care_requests {
  sql_table_name: public.care_requests ;;

  dimension: id {
    primary_key: yes
    description: "The care request ID"
    alias: [care_request_id]
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: accepted_order {
    type: number
    sql: ${TABLE}.accepted_order ;;
  }

  dimension: activated_by {
    type: string
    sql: CASE
          WHEN ${TABLE}.activated_by LIKE 'Other:%' THEN 'Other'
          ELSE initcap(replace(${TABLE}.activated_by, '’', ''))
        END ;;
  }

  dimension: appointment_type {
    type: string
    sql: ${TABLE}.appointment_type ;;
  }

  dimension: centura_connect_aco {
    type: string
    sql: ${TABLE}.centura_connect_aco ;;
  }

  dimension: channel_item_id {
    type: number
    sql: ${TABLE}.channel_item_id ;;
  }

  dimension: chief_complaint {
    type: string
    sql: ${TABLE}.chief_complaint ;;
  }

  dimension: chief_complaint_trimmed {
    type: string
    sql: trim(lower(${chief_complaint})) ;;
  }

  dimension: caller_id {
    type: number
    sql: ${TABLE}.caller_id ;;
  }

  # Logic removed from post_acute_followup flag on 11/3/2020: lower(${channel_items.name}) SIMILAR TO '%(pafu|post acute|post-acute|bridge-)%' OR

  dimension: post_acute_follow_up {
    label: "Bridge Care Visit"
    type: yesno
    description: "Chief complaint, risk protocol name, or service line is post acute follow-up"
    sql:  ${chief_complaint_trimmed} SIMILAR TO '%(pafu|post acute|post-acute)%' OR
          lower(${risk_assessments.protocol_name}) LIKE 'post-acute patient%' OR

          lower(${service_lines.name}) LIKE 'post acute follow up%' ;;
  }

  dimension: follow_up {
    type: yesno
    description: "The word follow-up or follow up occurs in Chief Complaint"
    sql:  ${chief_complaint_trimmed} SIMILAR TO '%(follow-up|follow up|dhfu)%' ;;
  }


  # dimension: DHFU_follow_up {
  #   type: yesno
  #   description: " - Dispatch Health Follow Up - The string 'dhfu' occurs in Chief Complaint OR Risk Assessment protocol_name = 'Dispatchhealth Acute Care - Follow Up Visit' (Does NOT include Post-Acute)"
  #   sql:  ${chief_complaint_trimmed} SIMILAR TO '%(dhfu)%' OR  ${risk_assessments.protocol_name} = 'Dispatchhealth Acute Care - Follow Up Visit';;
  # }

  dimension: DHFU_follow_up {
    type: yesno
    description: " - Dispatch Health Follow Up - The string 'dhfu' occurs in Chief Complaint OR Risk Assessment protocol_name = 'Dispatchhealth Acute Care - Follow Up Visit' (Does NOT include Post-Acute)"
    sql:  ${chief_complaint_trimmed} SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
          ${risk_assessments.protocol_name} = 'Dispatchhealth Acute Care - Follow Up Visit';;
  }


  measure: placeholder1 {
    type: number
    sql: NULL ;;
  }

  dimension: chrono_visit_id {
    type: string
    sql: ${TABLE}.chrono_visit_id ;;
  }

  dimension: consent_signature {
    type: string
    sql: ${TABLE}.consent_signature ;;
  }

  dimension: consenter_name {
    type: string
    sql: ${TABLE}.consenter_name ;;
  }

  dimension: consenter_relationship {
    type: string
    sql: ${TABLE}.consenter_relationship ;;
  }

  dimension: credit_card_completed {
    type: yesno
    sql: ${credit_cards.care_request_id} IS NOT NULL ;;
  }

  measure: count_credit_card_completed {
    type: count
    sql: ${TABLE}.id ;;
    filters: {
      field: credit_card_completed
      value: "yes"
    }
  }

  dimension: credit_card_error {
    type: yesno
    sql: ${credit_card_errors.care_request_id} IS NOT NULL ;;
  }

  measure: count_credit_card_errors {
    type: number
    sql: COUNT(${credit_card_errors.care_request_id}) ;;
  }

  dimension: credit_card_attempted {
    type: yesno
    sql: ${credit_card_error} OR ${credit_card_completed} ;;
  }

  measure: count_credit_attempted {
    type: count
    sql: ${TABLE}.id ;;
    filters: {
      field: credit_card_attempted
      value: "yes"
    }
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      time_of_day,
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      week,
      month,
      quarter,
      year, day_of_month
    ]
    sql: ${TABLE}.created_at ;;
  }


  dimension: created_decimal_quarter_hour_increment {
    description: "Care Request Created Time of Day as Decimal rounded to the nearest 1/4 hour increment"
    type: number
    sql: CASE
      WHEN CAST(EXTRACT(MINUTE FROM ${created_raw}) AS FLOAT) < 7.5 THEN FLOOR(CAST(EXTRACT(HOUR FROM ${created_raw}) AS INT)) + 0
      WHEN CAST(EXTRACT(MINUTE FROM ${created_raw} ) AS FLOAT) >= 7.5 AND CAST(EXTRACT(MINUTE FROM ${created_raw} ) AS FLOAT) < 22.5 THEN FLOOR(CAST(EXTRACT(HOUR FROM ${created_raw}) AS INT)) + 0.25
      WHEN CAST(EXTRACT(MINUTE FROM ${created_raw} ) AS FLOAT) >= 22.5 AND CAST(EXTRACT(MINUTE FROM ${created_raw} ) AS FLOAT) < 37.5 THEN FLOOR(CAST(EXTRACT(HOUR FROM ${created_raw}) AS INT)) + 0.5
            WHEN CAST(EXTRACT(MINUTE FROM ${created_raw} ) AS FLOAT) >= 37.5 AND CAST(EXTRACT(MINUTE FROM ${created_raw} ) AS FLOAT) < 52.5 THEN FLOOR(CAST(EXTRACT(HOUR FROM ${created_raw}) AS INT)) + 0.75
      ELSE  FLOOR(CAST(EXTRACT(HOUR FROM ${created_raw}) AS INT)) + 1
      END
      ;;
    value_format: "0.00"
  }


  dimension_group: created_mountain {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week_index,
      day_of_month
    ]
    sql: ${TABLE}.created_at  AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ;;
  }

  dimension: pre_post {
    type: yesno
    sql: ${created_mountain_raw} BETWEEN '2018-04-02'::TIMESTAMP AND '2018-04-13'::TIMESTAMP ;;
  }

  dimension: credit_card_consent {
    type: yesno
    sql: ${TABLE}.credit_card_consent ;;
  }

  dimension: data_use_consent {
    type: yesno
    sql: ${TABLE}.data_use_consent ;;
  }

  dimension_group: deleted {
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
    sql: ${TABLE}.deleted_at ;;
  }

  dimension: dispatch_queue_id {
    type: number
    sql: ${TABLE}.dispatch_queue_id ;;
  }

  dimension: ehr_id {
    type: string
    sql: ${TABLE}.ehr_id ;;
  }

  dimension: dashboard_athena_appt_id_match {
    type: yesno
    sql:  ${care_requests.ehr_id} = ${athena_appointment.appointment_char} ;;
    group_label: "Dashbaord Athena Reconciliation"
  }

  dimension: ehr_name {
    type: string
    sql: ${TABLE}.ehr_name ;;
  }

  dimension_group: eta {
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
    sql: ${TABLE}.eta ;;
  }

  dimension: facility {
    type: string
    sql: ${TABLE}.facility ;;
  }

  dimension: market_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.market_id ;;
  }

  dimension_group: on_accepted_eta {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      hour_of_day,
      time_of_day,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.on_accepted_eta ;;
  }

  measure: average_eta_hour {
    type: average
    sql: ${on_accepted_eta_time_of_day} ;;
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
      year
    ]
    sql: ${TABLE}.on_route_eta AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension_group: on_route_eta_mountain {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      time_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.on_route_eta AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ;;
  }

  dimension_group: on_scene_etc {
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
    sql: ${TABLE}.on_scene_etc ;;
  }

  dimension_group: on_scene_etc_mountain {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      time_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.on_scene_etc AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ;;
  }

  dimension_group: on_scene_etc_local {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      time_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.on_scene_etc AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  dimension: actual_minus_etc {
    type: number
    sql: CASE
          WHEN ABS((EXTRACT(EPOCH FROM ${care_request_flat.complete_raw}) - EXTRACT(EPOCH FROM ${on_scene_etc_local_raw}))::float/60.0) < 720
          THEN (EXTRACT(EPOCH FROM ${care_request_flat.complete_raw}) - EXTRACT(EPOCH FROM ${on_scene_etc_local_raw}))::float/60.0
          ELSE NULL
        END
          ;;
    value_format: "0.00"
  }

  dimension: actual_minus_etc_tier {
    type: tier
    tiers: [-60,-50,-40,-30,-20,-10,0,10,20,30,40,50,60]
    style: integer
    sql: ${actual_minus_etc} ;;
  }

  measure: avg_actual_minus_etc {
    type: average
    sql: ${actual_minus_etc} ;;
    value_format: "0.00"
  }

  measure: median_actual_minus_etc {
    type: median
    sql: ${actual_minus_etc} ;;
    value_format: "0.00"
  }

  dimension: orig_city {
    type: string
    sql: ${TABLE}.orig_city ;;
  }

  dimension: orig_latitude {
    type: number
    sql: ${TABLE}.orig_latitude ;;
  }

  dimension: orig_longitude {
    type: number
    sql: ${TABLE}.orig_longitude ;;
  }

  dimension: orig_state {
    type: string
    sql: ${TABLE}.orig_state ;;
  }

  dimension: orig_street_address_1 {
    type: string
    sql: ${TABLE}.orig_street_address_1 ;;
  }

  dimension: orig_street_address_2 {
    type: string
    sql: ${TABLE}.orig_street_address_2 ;;
  }

  dimension: orig_zipcode {
    type: string
    sql: ${TABLE}.orig_zipcode ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  measure: count_distinct_patients {
    type: count_distinct
    sql: ${patient_id} ;;
  }

  measure: count_visits_within_30_days_first_visit {
    type: count
    description: "Count of patient visits within 30 days of the first visit"
    sql: ${patient_id} ;;

    filters: {
      field: care_request_flat.within_30_days_first_visit
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }

  measure: count_visits_within_30_days_first_pafu_visit {
    label: "Count Visits within 30 Days of First Bridge Care Visit"
    type: count
    description: "Count of patient visits within 30 days of the first post-acute visit"
    sql: ${patient_id} ;;

    filters: {
      field: care_request_flat.within_30_days_first_visit
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: care_request_flat.first_visit_pafu
      value: "yes"
    }
  }

  measure: count_distinct_intended_care_requests {
    description: "Count of distinct care requests where 911 diversions have been removed"
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: care_request_flat.resolved_911_divert
      value: "no"
    }
    filters: {
      field: care_request_flat.booked_shaping_placeholder_resolved
      value: "no"
    }
  }

  measure: count_distinct_intended_care_requests_phone {
    description: "Count of distinct Phone care requests intended (no 911 diverts)"
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: request_type_phone_or_other
      value: "phone"
    }
    filters: {
      field: care_request_flat.resolved_911_divert
      value: "no"
    }
  }

  measure: count_distinct__care_requests_phone {
    description: "Count of distinct Phone care requests"
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: request_type_phone_or_other
      value: "phone"
    }
  }

  measure: count_distinct_complete_phone {
    description: "Count of distinct Phone complete"
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: request_type_phone_or_other
      value: "phone"
    }
    filters: {
      field: care_request_flat.complete
      value: "yes"
    }
  }

  measure: count_distinct_complete_other {
    description: "Count of distinct Other complete"
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: request_type_phone_or_other
      value: "other"
    }
    filters: {
      field: care_request_flat.complete
      value: "yes"
    }
  }


  measure: percent_phone_request_type {
    type: number
    value_format: "0.0%"
    sql: ${count_distinct_intended_care_requests_phone}::float/nullif(${count_distinct_intended_care_requests}::float,0) ;;
  }


  measure: count_distinct_intended_care_requests_other {
    description: "Count of distinct other care requests (911 diversions have been removed)"
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: request_type_phone_or_other
      value: "other"
    }
    filters: {
      field: care_request_flat.resolved_911_divert
      value: "no"
    }
  }

  measure: count_distinct_care_requests_other {
    description: "Count of distinct other care requests "
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: request_type_phone_or_other
      value: "other"
    }

  }


  dimension: place_of_service {
    type: string
    sql: CASE WHEN
      ${TABLE}.place_of_service LIKE '{:%' THEN NULL
      ELSE ${TABLE}.place_of_service
      END;;
  }

  dimension: pos_snf {
    type: yesno
    sql: ${place_of_service} = 'Skilled Nursing Facility' ;;
  }

  dimension: pos_al {
    type: yesno
    sql: ${place_of_service} = 'Assisted Living Facility' ;;
  }

  dimension: pos_home {
    type: yesno
    sql: ${place_of_service} = 'Home' ;;
  }

  dimension: pos_senior_broad {
    type: yesno
    sql: ${place_of_service} in('Assisted Living Facility', 'Independent Living Facility', 'Skilled Nursing Facility', 'Long-term Care Facility', 'Rehabilitation Facility') ;;
  }

  dimension_group: prioritized {
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
    sql: ${TABLE}.prioritized_at ;;
  }

  dimension: prioritized_by {
    type: string
    sql: ${TABLE}.prioritized_by ;;
  }

  dimension: priority_note {
    type: string
    sql: ${TABLE}.priority_note ;;
  }

  dimension: privacy_policy_consent {
    type: yesno
    sql: ${TABLE}.privacy_policy_consent ;;
  }

  dimension_group: prompted_survey {
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
    sql: ${TABLE}.prompted_survey_at ;;
  }

  dimension_group: pulled {
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
    sql: ${TABLE}.pulled_at ;;
  }

  dimension_group: pushed {
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
    sql: ${TABLE}.pushed_at ;;
  }

  dimension: request_type_id {
    type: number
    sql: ${TABLE}.request_type ;;
  }

  dimension: request_type {
    type: string
    sql:  case when ${request_type_id} = 1 OR lower(${channel_items.name}) in('south metro fire rescue', 'smfr employee clinic', 'west metro fire rescue') then 'manual_911'
               when ${request_type_id} = 0 then 'phone'
               when ${request_type_id} = 2 then 'mobile'
               when ${request_type_id} = 3 then 'web'
               when ${request_type_id} = 4 then 'mobile_android'
               when ${request_type_id} = 5 then 'centura_connect'
               when ${request_type_id} = 6 then 'centura_care_coordinator'
               when ${request_type_id} = 7 then 'orderly'
               when ${request_type_id} = 9 then 'dispatchhealth express'
            else 'other' end;;
  }

  dimension: request_type_consolidated {
    type: string
    description: "The care request type, grouped into phone, web, mobile or other"
    sql: CASE
          WHEN ${request_type_id} = 0 THEN 'Phone'
          WHEN ${request_type_id} = 3 THEN 'Web'
          WHEN ${request_type_id} IN (2, 4) THEN 'Mobile'
          ELSE 'Other'
        END ;;
  }

  dimension: request_type_phone_or_other {
    type: string
    sql:  case when  ${request_type} = 'phone' then 'phone'
               else 'other' end;;
  }

  measure: count_phone_care_requests {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: request_type
      value: "phone"
    }
  }

  measure: count_web_care_requests {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: request_type
      value: "web"
    }
  }

  measure: count_mobile_care_requests {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: request_type
      value: "mobile%"
    }
  }

  dimension: chart_signed {
    type: yesno
    sql: ${TABLE}.signed ;;
  }


  dimension: requested_by {
    type: number
    sql: ${TABLE}.requested_by ;;
  }

  dimension: shift_team_id {
    type: number
    sql: ${TABLE}.shift_team_id ;;
  }

  dimension: treatment_consent {
    type: yesno
    sql: ${TABLE}.treatment_consent ;;
  }

  dimension: triage_note_salesforce_id {
    type: string
    sql: ${TABLE}.triage_note_salesforce_id ;;
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
      year
    ]
    sql: ${TABLE}.updated_at ;;
  }

  dimension: use_as_billing_address {
    type: yesno
    sql: ${TABLE}.use_as_billing_address ;;
  }

  dimension_group: verbal_consent {
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
    sql: ${TABLE}.verbal_consent_at ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_distinct {
   type: number
   sql: count(distinct ${id}) ;;
    link: {
      label: "Patient-Level Details"
      url: "https://dispatchhealth.looker.com/looks/1124?&f[markets.name]={{ _filters['markets.name'] | url_encode }}
      &f[markets.name_adj]={{ _filters['markets.name_adj'] | url_encode }}
      &f[care_request_flat.escalated_on_scene]={{ _filters['care_request_flat.escalated_on_scene'] | url_encode }}
      &f[care_request_flat.complete_resolved_date]={{ _filters['care_request_flat.complete_resolved_date'] | url_encode }}
      &f[care_request_flat.lwbs]={{ _filters['care_request_flat.lwbs'] | url_encode }}
      &f[service_lines.name]={{ _filters['service_lines.name'] | url_encode }}"
    }
  }

  measure: count_distinct_pre_logistics {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: care_request_flat.post_logistics_flag
      value: "no"
    }
  }

  measure: count_distinct_post_logistics {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: care_request_flat.post_logistics_flag
      value: "yes"
    }
  }

#   dimension:  complete_visit {
#     type: yesno
#     sql: ${care_request_flat.complete_date} is not null AND (${care_request_flat.primary_resolved_reason} IS NULL OR ${care_request_flat.escalated_on_scene});;
#   }


  dimension:  complete_visit {
    type: yesno
    sql: ${care_request_flat.complete_date} is not null AND
      (${care_request_flat.primary_resolved_reason} IS NULL OR
      UPPER(${care_request_flat.complete_comment}) LIKE '%REFERRED - POINT OF CARE%' OR
      UPPER(${care_request_flat.primary_resolved_reason}) = 'REFERRED - POINT OF CARE' OR
      UPPER(${care_request_flat.primary_resolved_reason}) = 'ESCALATED TO ADVANCED' OR
      UPPER(${care_request_flat.other_resolved_reason}) LIKE '%ESCALATED%') ;;
  }

  dimension:  complete_non_escalated_visit {
    type: yesno
    sql: ${care_request_flat.complete_date} is not null AND ${primary_resolved_reason} IS NULL;;
  }

  dimension:  archived_visit {
    type: yesno
    sql: ${care_request_flat.archive_date} is not null;;
  }

  dimension: complete_visit_with_procedure {
    type: yesno
    sql: ${complete_visit} AND ${cpt_code_dimensions_clone.non_em_cpt_flag} ;;
  }

  measure: count_complete_visit_with_procedures {
    type: count_distinct
    description: "The count of completed visits where the CPT code group is Procedure, Medication or Labs"
    sql: ${id} ;;
    filters: [athena_cpt_codes.procedure_code_group: "Procedure, Medication, Labs",
              complete_visit: "yes"]
  }

  dimension:  referred_point_of_care {
    type: yesno
    sql: LOWER(${care_request_flat.complete_comment}) like '%referred - point of care%';;
  }

  dimension:  billable_est {
    type: yesno
    sql: ${referred_point_of_care} or ${care_requests.complete_visit};;
  }

  dimension:  billable_with_cpt {
    type: yesno
    sql: ${billable_est} AND ${cpt_code_dimensions_clone.cpt_code_flag};;
  }

  dimension: billable_actual {
    type: yesno
    sql: ${billable_est} AND ${athena_appointment.no_charge_entry_reason} IS NULL ;;
  }

  dimension: billable_est_excluding_bridge_care_and_dh_followups {
      label: "Exclude Bridge Care and DH Followup Cost Savings"
      description: "Logic to Exclude Billable Est excluding Bridge Care and DH Followups for Cost Savings (field retained to allow us to easily change the Cost Savings population moving forward (numerator and Denominator)"
      type: yesno
      sql:  ${DHFU_follow_up} OR ${post_acute_follow_up} ;;
    }

  measure: count_billable_est {
    type: count_distinct
    description: "Count of completed care requests OR on-scene escalations"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    link: {
      label: "Patient-Level Details"
      url: "https://dispatchhealth.looker.com/looks/1124?&f[markets.name]={{ _filters['markets.name'] | url_encode }}
      &f[markets.name_adj]={{ _filters['markets.name_adj'] | url_encode }}
      &f[care_request_flat.escalated_on_scene]={{ _filters['care_request_flat.escalated_on_scene'] | url_encode }}
      &f[care_request_flat.complete_resolved_date]={{ _filters['care_request_flat.complete_resolved_date'] | url_encode }}
      &f[care_request_flat.complete_date]={{ _filters['care_request_flat.complete_date'] | url_encode }}
      &f[care_request_flat.complete_month]={{ _filters['care_request_flat.complete_month'] | url_encode }}
      &f[drg_to_icd10_crosswalk.drg_code]={{ _filters['drg_to_icd10_crosswalk.drg_code'] | url_encode }}
      &f[insurance_coalese_crosswalk.insurance_package_name]={{ _filters['insurance_coalese_crosswalk.insurance_package_name'] | url_encode }}
      &f[care_request_flat.lwbs]={{ _filters['care_request_flat.lwbs'] | url_encode }}"

   }
  }

  dimension: billable_est_numeric {
    description: "Numeric representation of Billable Est to use in LookML to allow billable_Est to be summed"
    hidden: yes
    type: number
    sql: CASE WHEN ${billable_est} = 'yes' THEN 1
    ELSE 0
    END;;
  }

  measure: sum_billable_est {
    description: "Sum of billable Est to use in LookML calculations in place of count_billable_est (return the same results)"
    hidden: yes
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${billable_est_numeric} ;;
  }


  measure: count_billable_est_acute_ems_cost_savings {
    label: "Count Billable Est Excluding Bridge Care and DH Followups"
    type: count_distinct
    description: "Count of Billable Est excluding Bridge Care and DH Followups"
    sql: ${id} ;;

    filters: {
      field: billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
    # filters: {
    #   field: escalated_on_scene
    #   value: "no"
    # }
    }

  measure: sum_billable_est_excluding_bridge_care_and_dh_followups {
    description: "Sum of Billable Est excluding Bridge Care and DH Followups"
    hidden: yes
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${billable_est_numeric} ;;
    filters: {
      field: billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: count_antibiotics_prescriptions {
    type: count_distinct
    description: "Count of completed care requests where antibiotics were prescribed"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: prescribed_medications.antibiotic_medication
      value: "yes"
    }
  }


  measure: count_board_optimizer_requests {
    description: "A count of all care requests that were assigned by the board optimizers"
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: care_request_flat.board_optimizer_assigned
      value: "yes"
    }
  }

  measure: count_visits_fluids_blood {
    type: count_distinct
    description: "Count of completed non-escalated visits where IV or blood work was done"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: cpt_code_dimensions_clone.blood_iv
      value: "yes"
    }
    filters: {
      field: care_request_flat.escalated_on_scene
      value: "no"
    }
  }

  measure: count_post_acute_followups {
    label: "Count Bridge Care Visits"
    type: count_distinct
    description: "Count of post-acute follow-up visits"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: post_acute_follow_up
      value: "yes"
    }
  }

  measure: count_dhfu_followups {
    type: count_distinct
    description: "Count of post-acute follow-up visits"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: DHFU_follow_up
      value: "yes"
    }
  }

  measure: count_complete_out_of_network_ins {
    type: count_distinct
    description: "Count of completed care requests with out of network insurance"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: insurances.out_of_network_insurance
      value: "yes"
    }
  }

  measure: count_billable_est_phone {
    type: count_distinct
    description: "Count of completed care requests OR on-scene escalations"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }

    filters: {
      field: request_type_phone_or_other
      value: "phone"
    }
  }


  measure: count_optimum_drive_time {
    type: count_distinct
    description: "Count of complete visits where drive time < 20 minutes"
    sql: ${id} ;;
    filters: {
      field: care_request_flat.under_20_minute_drive_time
      value: "yes"
    }
  }

  measure: count_visits_with_onscene_meds {
    type: count_distinct
    description: "Count of completed care requests where medications were administered"
    sql: ${id} ;;
    filters: [billable_est: "yes", athena_patientmedication_prescriptions.administered_yn: "Y"]
  }

  measure: count_visits_with_onscene_labs {
    type: count_distinct
    description: "Count of completed care requests where labs were performed on-scene"
    sql: ${id} ;;
    filters: [billable_est: "yes",
              document_order_fulfilling_provider.provider_category: "Performed On-Scene",
              athena_document_orders.clinical_order_type_group: "LAB"]
  }

  measure: count_visits_with_third_party_labs {
    type: count_distinct
    description: "Count of completed care requests where labs were performed by 3rd party"
    sql: ${id} ;;
    filters: [billable_est: "yes",
      document_order_fulfilling_provider.provider_category: "Performed by Third Party",
      athena_document_orders.clinical_order_type_group: "LAB"]
  }

  measure: count_billable_actual {
    type: count_distinct
    description: "Count of completed care requests OR on-scene escalations where Athena no charge entry reason is NULL"
    sql: ${id} ;;
    filters: {
      field: billable_actual
      value: "yes"
    }
    drill_fields: [
      count_billable_est
    ]
  }

  measure: count_auto_assigned {
    type: count_distinct
    description: "Count of auto-assigned care requests"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: care_request_flat.auto_assigned_final
      value: "true"
    }
  }

  measure: count_auto_assignment_overridden {
    type: count_distinct
    description: "Count of overridden auto-assigned care requests"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
    filters: {
      field: care_request_flat.reassigned_or_reordered
      value: "yes"
    }
  }

  measure: count_visits_prescriptions {
    type: count_distinct
    description: "Count of completed care requests where 1 or more prescriptions were written"
    sql: ${id} ;;
    filters: [billable_est: "yes", athena_patientmedication_prescriptions.prescribed_yn: "Y"]
  }

  measure: count_visits_labs {
    type: count_distinct
    description: "Count of completed care requests where 1 or more labs were ordered"
    sql: ${id} ;;
    filters: {
      field: athena_document_orders.labs_flag
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }

  measure: count_visits_imaging {
    type: count_distinct
    description: "Count of completed care requests where one or more ultrasound/imaging orders were made"
    sql: ${id} ;;
    filters: {
      field: athena_document_orders.imaging_flag
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }

  measure: count_visits_dme {
    type: count_distinct
    description: "Count of completed care requests where one or more durable medical equipment orders was placed"
    sql: ${id} ;;
    filters: {
      field: athena_document_orders.dme_flag
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }

  measure: count_home_health_referrals {
    type: count_distinct
    description: "Count of completed care requests where a home health referral was made"
    sql: ${id} ;;
    filters: {
      field: athenadwh_referrals.home_health_referrals_flag
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }

  measure: count_pcp_referrals {
    type: count_distinct
    description: "Count of completed care requests where a primary care physician referral was made"
    sql: ${id} ;;
    filters: {
      field: athenadwh_referrals.pcp_referrals_flag
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }

  measure: count_provider_referrals {
    type: count_distinct
    description: "Count of completed care requests where a referral to a provider was made"
    sql: ${id} ;;
    filters: {
      field: athenadwh_orders.provider_referrals_flag
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }


  measure: count_billable_with_cpt {
    type: count
    description: "Count of completed care requests OR on-scene escalations that include a CPT code"
    filters: {
      field: billable_with_cpt
      value: "yes"
    }
  }

  dimension: smfr_billable {
    type: yesno
    sql: ${cars.name} LIKE '%SMFR%' AND ${billable_est};;
  }

  dimension: wmfr_billable {
    type: yesno
    sql: ${cars.name} LIKE '%WMFR%' AND ${billable_est};;
  }

  measure: count_smfr_billable {
    type: count
    filters: {
      field: smfr_billable
      value: "yes"
    }
  }

  measure: count_wmfr_billable {
    type: count
    filters: {
      field: wmfr_billable
      value: "yes"
    }
  }

  measure: count_cpr_market_visits {
    label: "count_partner_revenue_market_visits"
    description: "Counts the number of visits for a partner revenue market"
    type: count_distinct
    sql: ${id} ;;
    filters:  {
      field: markets.cpr_market
      value: "yes"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }

  measure: count_non_cpr_market_visits {
    label: "count_non_partner_revenue_market_visits"
    description: "Counts the number of visits for a Non-partner revenue market"
    type: count_distinct
    sql: ${id} ;;
    filters:  {
      field: markets.cpr_market
      value: "no"
    }
    filters: {
      field: billable_est
      value: "yes"
    }
  }


  dimension:  accepted_visit {
    type: yesno
    sql: ${care_request_flat.accept_date} is not null;;
  }

  dimension:  requested_visit {
    type: yesno
    sql: ${care_request_flat.requested_date} is not null;;
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

dimension: dashboard_image {
  sql: ('https://s3.amazonaws.com/dispatchhealth-analytics/Dispatch-Desktop-Dashboard-R3-Blank.png')  ;;
}

dimension: client_overview_image {
  sql: ${dashboard_image} ;;
  html:<img src={{value}} width="1200" height="672" alt="DispatchHealth"> ;;
}

dimension:  same_day_of_week {
  type: yesno
  sql:  ${yesterday_mountain_day_of_week_index}= ${created_mountain_day_of_week_index};;
}

dimension: until_today {
    type: yesno
    sql: ${created_mountain_day_of_week_index} <=  ${yesterday_mountain_day_of_week_index} AND ${created_mountain_day_of_week_index} >= 0 ;;
  }

dimension: this_week {
  type:  yesno
  sql: ${yesterday_mountain_week} =  ${created_mountain_week};;
}

  dimension: this_month {
    type:  yesno
    sql: ${yesterday_mountain_month} =  ${created_mountain_month};;
  }
measure: distinct_days {
  type: number
  sql: count(DISTINCT ${created_mountain_date}) ;;
}

measure: distinct_day_of_week {
  type: count_distinct
  sql: ${created_mountain_day_of_week_index} ;;
}

  dimension: month_to_date  {
    type:  yesno
    sql: ${created_mountain_day_of_month} <= ${yesterday_mountain_day_of_month} ;;
  }

  dimension: current_day_string {
    type: string
    sql:trim(to_char(current_date - interval '1 day', 'day')) ;;
  }
  measure: distinct_weeks {
    type: number
    sql: count(DISTINCT ${created_mountain_week}) ;;
  }

  measure: distinct_months {
    type: number
    sql: count(DISTINCT ${created_mountain_month}) ;;
  }


  measure: daily_average {
    type: number
    sql: ${count}/${distinct_days} ;;
  }


  measure: weekly_average {
    type: number
    sql: ${count}/${distinct_weeks} ;;
  }

  measure: monthly_average {
    type: number
    sql: ${count}/${distinct_months} ;;
  }
  measure: min_day {
    type: date
    sql: min(${created_mountain_date}) ;;
  }

  measure: max_day {
    type: date
    sql:max(${created_mountain_date}) ;;
  }

  measure: min_week {
    type: string
    sql: min(${created_mountain_week}) ;;
  }

  measure: max_week {
    type: string
    sql:max(${created_mountain_week}) ;;
  }
  measure: min_month {
    type: string
    sql: min(${created_mountain_month}) ;;
  }

  measure: max_month {
    type: string
    sql:max(${created_mountain_month}) ;;
  }


  measure: min_max_range_day {
    type: string
    sql:
  case when ${min_week} =  ${yesterday_mountain_week} then ${min_day}::text
  else concat(${current_day_string}, 's ', ${min_day}, ' thru ', ${max_day}) end ;;

  }

  measure: max_on_scene_time {
    label: "Last Care Request Completed Time"
    type: date_time
    sql:  max(${care_request_flat.complete_time}::timestamp) ;;
  }

  measure: min_on_route_time {
    label: "First Care Request On Route Time"
    type: date_time
    sql:  min(${care_request_flat.on_route_time}::timestamp) ;;
  }

  measure: shift_end_last_cr_diff{
    label: "Hours between Last Patient Seen and Shift End "
    type: number
    sql:  round(((EXTRACT(EPOCH FROM ${max_on_scene_time}::timestamp - max(${care_request_flat.shift_end_time}::timestamp)))/3600)::decimal,2);;
  }

  measure: shift_end_90_mins_early {
    label: "Hours Btwn Last Pt and Shift End > 90 Mins"
    type: yesno
    sql:  round(((EXTRACT(EPOCH FROM ${max_on_scene_time}::timestamp - max(${care_request_flat.shift_end_time}::timestamp)))/3600)::decimal,2) <= -1.50 ;;
  }

  measure: shift_start_first_on_route_diff{
    label: "Hours Between Shift Start and First On Route"
    type: number
    sql:  round(((EXTRACT(EPOCH FROM ${min_on_route_time}::timestamp - MIN(${care_request_flat.shift_start_time})::timestamp))/3600)::decimal,2);;
    value_format: "0.00"
  }

  measure: shift_end_last_cr_diff_adj{
    label: "Hours between Last Patient Seen and Shift End Adj"
    type: number
    description: "Hours between last completed care request and shift end.  Does not account for requests cancelled while on-route"
    sql:  case when  ${shift_end_last_cr_diff} > 18.0  then ${shift_end_last_cr_diff} - 24.0
               when  ${shift_end_last_cr_diff} < -18.0 then ${shift_end_last_cr_diff} + 24.0
           else ${shift_end_last_cr_diff} end;;
    }

  measure: min_max_range_week {
    type: string
    sql:
      case when ${min_week} =  ${yesterday_mountain_week} then concat(${min_day}, ' thru ', ${max_day})
      else concat('Week to date for weeks ', ${min_week}, ' thru ', ${max_week}) end ;;

    }

  measure: min_max_range {
    type: string
    sql: concat(${min_day}, ' thru ', ${max_day});;

    }
  dimension: care_request_patient_create_diff {
    type: number
    sql:EXTRACT(EPOCH FROM (${created_mountain_raw}- ${patients.created_mountain_raw} )) ;;
  }

  dimension: new_care_request_bool {
    type:  yesno
    sql:  (${care_request_patient_create_diff}< (60*60) or ${visit_facts_clone.new_patient}=1) ;;
  }

  dimension: marketing_meta_data {
    type: string
    sql:  ${TABLE}.marketing_meta_data;;
  }

  dimension: ga_client_id {
    type: string
    sql: (${TABLE}.marketing_meta_data->>'ga_client_id')::text ;;
  }



  dimension: days_in_month {
    type: number
    sql:  DATE_PART('days',
        DATE_TRUNC('month', ${created_mountain_date})
        + '1 MONTH'::INTERVAL
        - '1 DAY'::INTERVAL
    ) ;;
  }

  measure: resolved_reason {
    type: string
    sql:array_agg(distinct concat(${care_request_flat.archive_comment}, ${care_request_flat.complete_comment}))::text ;;
  }

  dimension: resolved_reason_full {
    type: string
    sql: coalesce(${care_request_flat.complete_comment}, ${care_request_flat.archive_comment}) ;;
  }

#   dimension: primary_resolved_reason {
#     type:  string
#     sql: trim(split_part(${resolved_reason_full}, ':', 1)) ;;
#   }

  dimension: primary_resolved_reason {
    type:  string
    sql: CASE
        WHEN UPPER(trim(split_part(${resolved_reason_full}, ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
        WHEN UPPER(trim(split_part(${resolved_reason_full}, ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
        ELSE  trim(split_part(${resolved_reason_full}, ':', 1))
        END;;
        drill_fields: [secondary_resolved_reason]
  }

  dimension: secondary_resolved_reason {
    type:  string
    sql: trim(split_part(${resolved_reason_full}, ':', 2)) ;;
  }

  dimension: primary_and_secondary_resolved_reason {
    type: string
    sql: concat(${primary_resolved_reason},': ', ${secondary_resolved_reason}) ;;
  }

  dimension: other_resolved_reason {
    type:  string
    sql: trim(split_part(${resolved_reason_full}, ':', 3)) ;;
  }

  dimension: other_resolved_booked {
    type: yesno
    description: "A flag indicating resolved - booked for the day"
    sql: LOWER(${other_resolved_reason}) LIKE '%booked%' ;;
  }


#   dimension: escalated_on_scene {
#     type: yesno
#     sql: UPPER(${care_request_flat.complete_comment}) LIKE '%REFERRED - POINT OF CARE%' ;;
#   }

  dimension: escalated_on_scene {
    hidden: yes
    type: yesno
    sql:UPPER(${care_request_flat.complete_comment}) LIKE '%REFERRED - POINT OF CARE: EMERGENCY DEPARTMENT%' OR
      UPPER(${care_request_flat.complete_comment}) LIKE '%REFERRED - POINT OF CARE: ED%' OR
      (UPPER(${primary_resolved_reason}) = 'REFERRED - POINT OF CARE' AND
      (UPPER(${secondary_resolved_reason}) LIKE '%EMERGENCY DEPARTMENT%' OR
      SUBSTRING(UPPER(${secondary_resolved_reason}),1,2) = 'ED')) ;;

    }

# Removing these for now.  These should be calculated in care_request_flat, not duplicated here -- DE 01/17/2019
#   dimension: lwbs_going_to_ed {
#     type: yesno
#     sql: ${care_request_flat.archive_comment} = 'Cancelled by Patient: Going to an Emergency Department' ;;
#   }
#
#   dimension: lwbs_going_to_urgent_care {
#     type: yesno
#     sql: ${care_request_flat.archive_comment} = 'Cancelled by Patient: Going to an Urgent Care' ;;
#   }
#
#   dimension: lwbs_wait_time_too_long {
#     type: yesno
#     sql: ${care_request_flat.archive_comment} = 'Cancelled by Patient: Wait time too long' ;;
#   }
#
#   dimension: lwbs_no_longer_need_care {
#     type: yesno
#     sql: ${care_request_flat.archive_comment} = 'Cancelled by Patient: No longer need care' ;;
#   }
#
#   dimension: lwbs {
#     type: yesno
#     description: "Going to ED/Urgent Care, Wait Time Too Long, or No Longer Need Care"
#     sql: ${lwbs_going_to_ed} OR ${lwbs_going_to_urgent_care} OR ${lwbs_wait_time_too_long} OR ${lwbs_no_longer_need_care} ;;
#   }
#
#   measure: lwbs_count {
#     type: count_distinct
#     sql: ${id} ;;
#     filters: {
#       field: lwbs
#       value: "yes"
#     }
#     drill_fields: [care_request_flat.archive_comment]
#   }

  measure: escalated_on_scene_count {
    label: "Escalated On-Scene to Ed"
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: escalated_on_scene_ed
      value: "yes"
    }
  }

  dimension: escalated_on_scene_ed {
    type: yesno
    sql: ${care_request_flat.complete_comment} = 'Referred - Point of Care: ED'
      OR ${care_request_flat.complete_comment} = 'Referred - Point of care: ED'
      OR ${care_request_flat.complete_comment} = 'Referred - Point of Care: Emergency Department';;
  }

  dimension: escalated_on_phone {
    type: yesno
    sql: ${care_request_flat.complete_comment} SIMILAR TO '(%Referred via Phone%|%Referred - Phone Triage%)' ;;
  }

  # dimension: escalated_on_phone_reason {
  #   type: string
  #   sql: CASE
  #         WHEN ${escalated_on_phone} THEN split_part(${care_request_complete.comment}, ':', 2)
  #         ELSE NULL
  #       END ;;
  # }

  dimension: no_credit_card_reason {
    type: string
    sql:${TABLE}.no_credit_card_reason ;;
  }

  dimension: no_credit_card_reason_other {
    type: string
    sql:${TABLE}.no_credit_card_reason_other ;;
  }

  dimension: no_credit_card_collected {
    type: yesno
    hidden: yes
    sql: ${no_credit_card_reason} = '' IS FALSE;;
  }

  measure: count_no_credit_card_collected {
    type: count_distinct
    description: "Count of care requests where no credit card was collected"
    sql: ${id} ;;
    filters: {
      field: no_credit_card_collected
      value: "yes"
    }
  }

  dimension: market_id_adj {
    type: number
    hidden: yes
    sql: case when ${market_id} = 167 then 159 else ${market_id} end;;
  }

  dimension: service_line_id {
    type: number
    sql: ${TABLE}.service_line_id ;;
  }

  dimension: smfr_eligible{
    type: yesno
    sql:  ${addresses.zipcode_short} in('80122', '80123', '80124', '80125', '80126', '80128', '80134', '80135', '80138', '80210', '80222', '80224', '80231', '80235', '80237', '80013', '80014', '80015', '80016', '80018', '80104', '80110', '80111', '80112', '80120', '80121');;
  }

  dimension: wmfr_eligble{
    type: yesno
    sql:  ${addresses.zipcode_short} in('80215', '80226', '80232', '80228', '80214');;
  }


  measure: count_no_asnwer_secondary_resolved_reason  {
    type: count
    label: "Count No Answer Secondary Resolved Type"
    description: "Count for No Answer Secondary Resolved Type"
    sql: ${secondary_resolved_reason} ;;
    filters: {
      field: secondary_resolved_reason
      value: "No Answer"
    }
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      ehr_name,
      consenter_name,
      markets.id,
      markets.name,
      markets.provider_group_name,
      markets.short_name,
      credit_cards.count
    ]
  }
}
