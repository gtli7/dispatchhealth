view: visit_facts {
  sql_table_name: jasperdb.visit_facts ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: accepted {
    description: "The timestamp the care request was accepted by Provider in UTC"
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
    sql: ${TABLE}.accepted_time ;;
  }

  dimension: car_dim_id {
    type: number
    sql: ${TABLE}.car_dim_id ;;
  }

  measure: count_distinct_car_id {
    description: "The number of unique car ID's"
    type: count_distinct
    sql: ${car_dim_id} ;;
  }

  dimension: care_request_id {
    description: "The ID assigned by DispatchHealth Dashboard software"
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  measure: count_distinct_care_requests {
    description: "The number of unique care request ID's"
    type: count_distinct
    sql: ${care_request_id} ;;
  }

  measure: count_mobile_care_requests {
    description: "The number of unique care request ID's from mobile"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: request_type_dimensions.mobile_requests
      value: "yes"
    }
  }

  measure: count_phone_care_requests {
    description: "The number of unique care request ID's from phone"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: request_type_dimensions.phone_requests
      value: "yes"
    }
  }

  measure: count_web_care_requests {
    description: "The number of unique care request ID's from web"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: request_type_dimensions.web_requests
      value: "yes"
    }
  }

  dimension: channel_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.channel_dim_id ;;
  }

  dimension: chief_complaint {
    description: "The main description of patient symptoms for the care request"
    type: string
    sql: ${TABLE}.chief_complaint ;;
  }

  dimension: post_acute_follow_up {
    type: yesno
    description: "Chief complaint, risk protocol name, or channel name is post-acute follow-up"
    sql:  TRIM(LOWER(${chief_complaint})) REGEXP 'pafu|post acute|post-acute' OR
          ${risk_assessments_bi.protocol_name} = 'Post-Acute Patient' OR
          ${channel_dimensions.organization} REGEXP 'pafu|post acute|post-acute' ;;
  }

  dimension_group: complete {
    description: "The timestamp the care request was completed by the Provider in UTC"
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
    sql: ${TABLE}.complete_time ;;
  }

  dimension_group: created {
    hidden: yes
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

  dimension: csc_shift_id {
    hidden: yes
    type: string
    sql: ${TABLE}.csc_shift_id ;;
  }

  dimension: day_14_followup_outcome {
    description: "The outcome of the provider visit 14 days after seeing patient"
    type: string
    sql: ${TABLE}.day_14_followup_outcome ;;
  }

  dimension: day_30_followup_outcome {
    description: "The outcome of the provider visit 30 days after seeing patient"
    type: string
    sql: TRIM(${TABLE}.day_30_followup_outcome) ;;
  }

  dimension: day_3_followup_outcome {
    description: "The outcome of the provider visit 3 days after seeing patient"
    type: string
    sql: TRIM(${TABLE}.day_3_followup_outcome) ;;
  }

  dimension: emt_shift_id {
    hidden: yes
    type: string
    sql: ${TABLE}.emt_shift_id ;;
  }

  dimension: facility_type_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.facility_type_dim_id ;;
  }

  dimension: latitude {
    hidden: yes
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: letter_recipient_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.letter_recipient_dim_id ;;
  }

  dimension: letter_sent {
    label: "Clinical Letter Sent flag"
    type: yesno
    sql: ${TABLE}.letter_sent ;;
  }

  dimension_group: local_accepted {
    description: "The timestamp the care request was accepted by Provider in local time"
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_accepted_time ;;
  }

  dimension_group: local_complete {
    description: "The timestamp the care request was completed by the Provider in local time"
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      hour_of_day,
      time_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_complete_time ;;
  }

  dimension: local_complete_decimal {
    description: "Completed Time of Day as Decimal"
    type: number
    sql: ${local_complete_hour_of_day} + (MINUTE(${local_complete_raw}) / 60) ;;
  }

  dimension_group: local_on_route {
    description: "The timestamp the Provider was on route to the appointment in local time"
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      hour_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_on_route_time ;;
  }

  dimension_group: local_on_scene {
    description: "The timestamp the Provider was on scene at the appointment in local time"
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      minute,
      hour_of_day,
      time_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_on_scene_time ;;
  }

  dimension: local_on_scene_decimal {
    description: "On Scene Time of Day as Decimal"
    type: number
    sql: ${local_on_scene_hour_of_day} + (MINUTE(${local_on_scene_raw}) / 60) ;;
  }

  dimension_group: local_requested {
    description: "The timestamp the care request was created in the Provider Dashboard in local time"
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      hour_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_requested_time ;;
  }

  dimension: location_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.location_dim_id ;;
  }

  dimension: visit_location {
    description: "The geocode (latitude and longitude) for the care request"
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: longitude {
    hidden: yes
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: market_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension: new_patient {
    label: "New Patient flag"
    type: yesno
    sql: ${TABLE}.new_patient ;;
  }

  measure: count_new_patients {
    type: count
    description: "Count of new patients"
    sql: ${new_patient} ;;
  }

  dimension: no_charge_entry_reason {
    description: "The provided reason for a no-charge claim"
    type: string
    sql: ${TABLE}.no_charge_entry_reason ;;
  }

  dimension: nppa_shift_id {
    hidden: yes
    type: string
    sql: ${TABLE}.nppa_shift_id ;;
  }

  dimension_group: on_route {
    description: "The timestamp the Provider was on route to the appointment in UTC"
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
    sql: ${TABLE}.on_route_time ;;
  }

  dimension_group: on_scene {
    description: "The timestamp the Provider was on scene at the appointment in UTC"
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
    sql: ${TABLE}.on_scene_time ;;
  }

  dimension: other_resolve_reason {
    description: "The text field contents for the resolve reason other field"
    type: string
    sql: ${TABLE}.other_resolve_reason ;;
  }

  dimension: patient_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.patient_dim_id ;;
  }

  dimension: patient_employer_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.patient_employer_dim_id ;;
  }

  dimension: provider_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.provider_dim_id ;;
  }

  dimension: request_type_dim_id {
    hidden: yes
    type: number
    sql: ${TABLE}.request_type_dim_id ;;
  }

  dimension_group: requested {
    description: "The timestamp the care request was created in the Provider Dashboard in UTC"
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
    sql: ${TABLE}.requested_time ;;
  }

  dimension: resolve_reason {
    description: "The reason the care request of resolved"
    type: string
    sql: ${TABLE}.resolve_reason ;;
  }

  dimension: resolved {
    label: "Resolved flag"
    type: yesno
    sql: ${TABLE}.resolved ;;
  }

  dimension: on_scene_escalation_flag {
    label: "On scene escalation (yes/no)"
    type: yesno
    sql: ${resolve_reason} = 'Referred - Point of Care';;
  }

  dimension: phone_escalation_flag {
    label: "Phone escalation (yes/no)"
    type: yesno
    sql: ${resolve_reason} = 'Referred - Phone Triage';;
  }

  measure: count_resolved_requests {
    label: "Resolved Requests Count"
    type: count
    filters: {
      field: resolved
      value: "yes"
    }

    drill_fields: [details*]
  }

  measure: count_on_scene_escalations {
    label: "Count of on-scene care escalations"
    type: count
    filters: {
      field: on_scene_escalation_flag
      value: "yes"
    }
  }

  dimension: complete_visit {
    label: "Complete Visit flag"
    type: yesno
    sql: ${local_complete_raw} IS NOT NULL;;
  }

  measure: count_complete_visits {
    label: "Complete Visits Count"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: complete_visit
      value: "yes"
    }

    drill_fields: [details*]
  }

  measure: count_prescriptions_written {
    label: "Prescriptions Written Count"
    type: count
    filters: {
      field: athenadwh_documents.prescriptions_flag
      value: "yes"
    }
  }

  dimension: centura_mssp_request_flag {
    type: yesno
    sql: ${centura_mssp_eligible.group_member_id} IS NOT NULL ;;
  }

  measure: count_centura_mssp_requests {
    type: count
    filters: {
      field: centura_mssp_request_flag
      value: "yes"
    }
  }

  dimension: centura_mssp_complete_flag {
    type: yesno
    sql: ${centura_mssp_eligible.group_member_id} IS NOT NULL AND NOT ${resolved};;
  }

  measure: count_centura_mssp_completed_visits {
    type: count
    filters: {
      field: centura_mssp_complete_flag
      value: "yes"
    }
  }

  dimension: bonsecours_mssp_request_flag {
    type: yesno
    sql: ${bonsecours_mssp_eligible.group_member_id} IS NOT NULL ;;
  }

  measure: count_bonsecours_mssp_requests {
    label: "Count of Bon Secours MSSP Requests"
    type: count
    filters: {
      field: bonsecours_mssp_request_flag
      value: "yes"
    }
  }

  dimension: bonsecours_mssp_complete_flag {
    type: yesno
    sql: ${bonsecours_mssp_eligible.group_member_id} IS NOT NULL AND NOT ${resolved};;
  }

  measure: count_bonsecours_mssp_completed_visits {
    label: "Count of Bon Secours MSSP Completed Visits"
    type: count
    filters: {
      field: bonsecours_mssp_complete_flag
      value: "yes"
    }
  }

  dimension: secondary_resolve_reason {
    description: "Addition information regarding the care request resolve reason"
    type: string
    sql: ${TABLE}.secondary_resolve_reason ;;
  }

  dimension: seconds_in_queue {
    label: "In-Queue Time (seconds)"
    type: number
    sql: ${TABLE}.seconds_in_queue ;;
  }

  dimension: minutes_in_queue {
    label: "In-Queue Time (minutes)"
    type: number
    sql: 1.0 * ${TABLE}.seconds_in_queue / 60 ;;
  }

  dimension: seconds_of_travel_time {
    label: "Travel Time (seconds)"
    type: number
    sql: ${TABLE}.seconds_of_travel_time ;;
  }

  dimension: seconds_on_scene {
    label: "On-Scene Time (seconds)"
    type: number
    sql: ${TABLE}.seconds_on_scene ;;
  }

  dimension: hours_on_scene {
    label: "On-Scene Time (hours)"
    type: number
    sql: 1.0 * ${seconds_on_scene} / 3600 ;;
  }

  dimension: total_acct_receivable_payments {
    label: "Total Amount AR payments"
    type: number
    sql: ${TABLE}.total_acct_receivable_payments * -1 ;;
  }

  dimension: acct_receivable_payment_exists {
    type: yesno
    hidden: yes
    sql: ${total_acct_receivable_payments} IS NOT NULL ;;
  }

  measure: count_acct_receivable_payments {
    type: count
    filters: {
      field: acct_receivable_payment_exists
      value: "yes"
    }
  }

  measure: avg_ar_payments {
    label: "Avg. Accts Receivable Payments"
    type: average
    sql: ${total_acct_receivable_payments} ;;
  }

  measure: sum_ar_payments {
    label: "Sum Accts Receivable Payments"
    type: sum
    sql: ${total_acct_receivable_payments} ;;
  }

  dimension: total_acct_receivable_transactions {
    label: "Total Amount AR Transactions"
    type: number
    sql: ${TABLE}.total_acct_receivable_transactions ;;
  }

  dimension: total_charge {
    label: "Total Charge Amount"
    type: number
    sql: ${TABLE}.total_charge ;;
  }

  dimension: total_expected_allowable {
    description: "The total of all expected allowed charge amounts for a patient visit"
    type: number
    sql: ${TABLE}.total_expected_allowable ;;
  }

  dimension: total_rvus {
    label: "Total RVUs"
    description: "Total RVU for the care request includes Work, Practice Expense, and Malpractice RVU, also adjusted for number of charges and units. Not adjusted for GPCI location."
    type: number
    sql: ${TABLE}.total_rvus ;;
  }

  measure: sum_rvus {
    label: "Sum of RVUs"
    type: sum
    sql: ${total_rvus} ;;
  }

  dimension_group: updated {
    hidden: yes
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

  dimension: visit_dim_number {
    label: "EHR Appointment ID"
    type: string
    sql: ${TABLE}.visit_dim_number ;;
  }

  dimension: work_rvus {
    label: "Work RVUs"
    description: "The total Work RVU value for the care request for the procedure code adjusted for the number of charges and units. Not adjusted for GPCI location."
    type: number
    sql: ${TABLE}.work_rvus ;;
  }

  dimension: billable_visit {
    label: "Billable Visit flag"
    type: yesno
    sql: ${visit_dim_number} IS NOT NULL AND ${no_charge_entry_reason} IS NULL ;;
  }

  dimension: billable_visit_with_cpt_flag {
    type: yesno
    sql: ${cpt_code_dimensions_clone.non_em_cpt_flag} AND ${billable_visit} ;;
  }

  measure: count_billable_visit_with_cpt {
    description: "Count of billable visits with non E&M CPT codes"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: billable_visit_with_cpt_flag
      value: "yes"
    }
  }

  dimension: billable_visit_with_expected_allowable {
    label: "Billable Visits with Expected Allowable flag"
    type: yesno
    sql: ${visit_dim_number} IS NOT NULL AND ${no_charge_entry_reason} IS NULL
        and ${total_expected_allowable}>0;;
  }

  dimension: non_smfr_billable_visit {
    label: "Non-SMFR Billable visit flag"
    type: yesno
    sql: ${visit_dim_number} IS NOT NULL AND ${no_charge_entry_reason} IS NULL AND ${car_dimensions.car_name} != 'SMFR_Car';;
  }

  dimension: season {
    type: string
    sql: Case when MONTH(${local_requested_time}) between 3 and 5 then 'Spring'
            when MONTH(${local_requested_time}) between 6 and 8 then 'Summer'
            when MONTH(${local_requested_time}) between 9 and 11 then 'Autumn'
            when MONTH(${local_requested_time}) >= 12 or MONTH(${local_requested_time}) <= 2 then 'Winter'
       end;;
  }

  measure: count {
    type: count
    drill_fields: [details*]
  }

  measure: visits  {
    label: "Total Care Requests"
    type: count_distinct
    sql: ${care_request_id} ;;
  }

  measure: count_of_billable_visits {
    label: "Billable Visit Count"
    type: count_distinct
    sql: CASE
          WHEN (${visit_dim_number} IS NOT NULL AND ${no_charge_entry_reason} IS NULL) THEN ${care_request_id}
          ELSE NULL
        END ;;

#     filters: {
#       field: billable_visit
#       value: "yes"
#     }

    drill_fields: [details*]
  }

  measure: count_of_touchworks_letters_sent {
    label: "Touchworks Notes Sent Count"
    type: count_distinct
    sql: CASE
          WHEN (${visit_dim_number} IS NOT NULL AND ${no_charge_entry_reason} IS NULL) THEN ${care_request_id}
          ELSE NULL
        END ;;
    filters: {
     field: athenadwh_clinical_providers.touchworks_flag
    value: "yes"
    }
  }

# Create measures by metrics of interest for use in data export for health system scorecard
# Dan Edstrom
# 2/22/2018
  dimension: female_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${patient_dimensions.gender} = 'F' AND ${billable_visit} IS TRUE ;;
  }

  dimension: male_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${patient_dimensions.gender} = 'M' AND ${billable_visit} IS TRUE ;;
  }

  dimension: age_0_to_5_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${patient_dimensions.age_0_to_5} IS TRUE AND ${billable_visit} IS TRUE ;;
  }
  dimension: age_6_to_9_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${patient_dimensions.age_6_to_9} IS TRUE AND ${billable_visit} IS TRUE ;;
  }
  dimension: age_10_to_19_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${patient_dimensions.age_10_to_19} IS TRUE AND ${billable_visit} IS TRUE ;;
  }
  dimension: age_20_to_29_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${patient_dimensions.age_20_to_29} IS TRUE AND ${billable_visit} IS TRUE ;;
  }
  dimension: age_30_to_39_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${patient_dimensions.age_30_to_39} IS TRUE AND ${billable_visit} IS TRUE ;;
  }
  dimension: age_40_to_49_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${patient_dimensions.age_40_to_49} IS TRUE AND ${billable_visit} IS TRUE ;;
  }
  dimension: age_50_to_59_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${patient_dimensions.age_50_to_59} IS TRUE AND ${billable_visit} IS TRUE ;;
  }
  dimension: age_60_to_69_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${patient_dimensions.age_60_to_69} IS TRUE AND ${billable_visit} IS TRUE ;;
  }
  dimension: age_70_to_79_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${patient_dimensions.age_70_to_79} IS TRUE AND ${billable_visit} IS TRUE ;;
  }
  dimension: age_80_to_89_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${patient_dimensions.age_80_to_89} IS TRUE AND ${billable_visit} IS TRUE ;;
  }
  dimension: age_90_plus_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${patient_dimensions.age_90_plus} IS TRUE AND ${billable_visit} IS TRUE ;;
  }

  dimension: clinical_notes_sent_billable_visit_flag {
    type: yesno
    hidden: yes
    sql: ${athenadwh_documents.document_class} IN ('LETTER', 'ENCOUNTERDOCUMENT') AND
         ${athenadwh_documents.document_subclass} != 'LETTER_PATIENTCORRESPONDENCE' AND ${billable_visit} IS TRUE ;;
  }

  dimension: referred_on_scene_flag {
    type: yesno
    hidden: yes
    sql: ${resolve_reason} = 'Referred - Point of Care';;
  }

  dimension: referred_phone_flag {
    type: yesno
    hidden: yes
    sql: ${resolve_reason} = 'Referred - Phone Triage';;
  }

  measure: count_female_billable_visits {
    label: "Billable Visit Count - Female"
    type: count
    filters: {
      field: female_billable_visit_flag
      value: "yes"
    }
  }

  measure: count_male_billable_visits {
    label: "Billable Visit Count - Male"
    type: count
    filters: {
      field: male_billable_visit_flag
      value: "yes"
    }
  }

  measure: count_age_0_to_5_billable_visits {
    label: "Billable Visit Count - Age 0 to 5"
    type: count
    filters: {
      field: age_0_to_5_billable_visit_flag
      value: "yes"
    }
  }

  measure: count_age_6_to_9_billable_visits {
    label: "Billable Visit Count - Age 6 to 9"
    type: count
    filters: {
      field: age_6_to_9_billable_visit_flag
      value: "yes"
    }
  }

  measure: count_age_10_to_19_billable_visits {
    label: "Billable Visit Count - 10 to 19"
    type: count
    filters: {
      field: age_10_to_19_billable_visit_flag
      value: "yes"
    }
  }

  measure: count_age_20_to_29_billable_visits {
    label: "Billable Visit Count - 20 to 29"
    type: count
    filters: {
      field: age_20_to_29_billable_visit_flag
      value: "yes"
    }
  }

  measure: count_age_30_to_39_billable_visits {
    label: "Billable Visit Count - 30 to 39"
    type: count
    filters: {
      field: age_30_to_39_billable_visit_flag
      value: "yes"
    }
  }

  measure: count_age_40_to_49_billable_visits {
    label: "Billable Visit Count - 40 to 49"
    type: count
    filters: {
      field: age_40_to_49_billable_visit_flag
      value: "yes"
    }
  }

  measure: count_age_50_to_59_billable_visits {
    label: "Billable Visit Count - 50 to 59"
    type: count
    filters: {
      field: age_50_to_59_billable_visit_flag
      value: "yes"
    }
  }

  measure: count_age_60_to_69_billable_visits {
    label: "Billable Visit Count - 60 to 69"
    type: count
    filters: {
      field: age_60_to_69_billable_visit_flag
      value: "yes"
    }
  }

  measure: count_age_70_to_79_billable_visits {
    label: "Billable Visit Count - 70 to 79"
    type: count
    filters: {
      field: age_70_to_79_billable_visit_flag
      value: "yes"
    }
  }

  measure: count_age_80_to_89_billable_visits {
    label: "Billable Visit Count - 80 to 89"
    type: count
    filters: {
      field: age_80_to_89_billable_visit_flag
      value: "yes"
    }
  }

  measure: count_age_90_plus_billable_visits {
    label: "Billable Visit Count - 90+"
    type: count
    filters: {
      field: age_90_plus_billable_visit_flag
      value: "yes"
    }
  }

  measure: clinical_notes_sent {
    label: "Billable Visits Where Clinical Notes Sent"
    type: count
    filters: {
      field: clinical_notes_sent_billable_visit_flag
      value: "yes"
    }
  }

  measure: referred_on_scene_count {
    label: "Referred On Scene Count"
    type: count
    filters: {
      field: referred_on_scene_flag
      value: "yes"
    }
  }

  measure: referred_phone_count {
    label: "Referred Phone Count"
    type: count
    filters: {
      field: referred_phone_flag
      value: "yes"
    }
  }


# End block for health system scorecard export

  measure: count_of_billable_visit_with_expected_allowable {
    label: "Billable Visit with Expected Allowable Count"
    type: count
    filters: {
      field: billable_visit_with_expected_allowable
      value: "yes"
    }

    drill_fields: [details*]
  }

  dimension: capped_expected_allowable {
    description: "Flag of whether or not expected allowable is greater than $350"
    type: yesno
    sql: ${visit_facts.total_expected_allowable} < 350 ;;
  }

  measure: average_expected_allowable {
    label: "Average Expected Allowable"
    type: number
    sql: round(avg(${visit_facts.total_expected_allowable}),2) ;;
  }

  measure: average_expected_allowable_capped {
    label: "Average Capped Expected Allowable"
    description: "Average Expected Allowable, excluding amounts over $350"
    type: average
    filters: {
      field: capped_expected_allowable
      value: "yes"
    }
    sql: round(${visit_facts.total_expected_allowable},2) ;;
  }

  measure: count_of_non_smfr_billable_visits {
    label: "Non-SMFR Billable Visit Count"
    type: count
    filters: {
      field: non_smfr_billable_visit
      value: "yes"
    }

    drill_fields: [details*]
  }

  dimension: resolved_request {
    label: "Resolved flag"
    type: yesno
    sql: ${resolved} IS TRUE ;;
  }

  measure: count_of_resolved_requests {
    label: "Resolved Request Count"
    type: count
    filters: {
      field: resolved
      value: "yes"
    }

    drill_fields: [details*]
  }

  dimension: on_scene_visit {
    label: "On-Scene Visit flag"
    type: yesno
    sql: (${complete_visit} OR ${resolved_seen_flag}) ;;
  }

  measure: count_of_on_scene_visits {
    label: "On-Scene Visit Count"
    type: count
    filters: {
      field: on_scene_visit
      value: "yes"
    }

    drill_fields: [details*]
  }

  dimension: in_queue {
    label: "In-Queue flag"
    type: yesno
    sql: ${local_requested_raw} IS NOT NULL AND
         ${local_accepted_raw} IS NOT NULL AND
        TIMESTAMPDIFF(SECOND, ${local_requested_raw}, ${local_accepted_raw}) > 0 AND
        TIMESTAMPDIFF(SECOND, ${local_requested_raw}, ${local_accepted_raw}) < 43201;;
  }

  dimension: in_queue_mins {
    label: "In-Queue Time (mins)"
    type: number
    sql: TIMESTAMPDIFF(SECOND, ${local_requested_raw}, ${local_accepted_raw}) / 60 ;;
  }

  measure: avg_queue_mins {
    label: "In-Queue Avg Time (mins)"
    type: average
    sql: ${in_queue_mins} ;;
    filters: {
      field: in_queue
      value: "yes"
    }
    drill_fields: [details*]
  }

  dimension: in_accepted_queue {
    label: "In-Accepted Queue flag"
    type: yesno
    sql: ${local_accepted_raw} IS NOT NULL AND
         ${local_on_route_raw} IS NOT NULL AND
        TIMESTAMPDIFF(SECOND, ${local_accepted_raw}, ${local_on_route_raw}) > 0 AND
        TIMESTAMPDIFF(SECOND, ${local_accepted_raw}, ${local_on_route_raw}) < 43201;;
  }

  dimension: in_accepted_queue_mins {
    label: "In-Accepted Queue Time (mins)"
    type: number
    sql: TIMESTAMPDIFF(SECOND, ${local_accepted_raw}, ${local_on_route_raw}) / 60 ;;
  }

  measure: avg_accepted_queue_mins {
    label: "In-Accepted Queue Avg Time (mins)"
    type: average
    sql: ${in_accepted_queue_mins} ;;
    filters: {
      field: in_accepted_queue
      value: "yes"
    }
    drill_fields: [details*]
  }

  dimension: in_on_route_queue {
    label: "On-Route flag"
    type: yesno
    sql: ${local_on_route_raw} IS NOT NULL AND
         ${local_on_scene_raw} IS NOT NULL AND
        TIMESTAMPDIFF(SECOND, ${local_on_route_raw}, ${local_on_scene_raw}) > 299 AND
        TIMESTAMPDIFF(SECOND, ${local_on_route_raw}, ${local_on_scene_raw}) < 14401;;
  }

  dimension: in_on_route_queue_mins {
    label: "On-Route Time (mins)"
    type: number
    sql: TIMESTAMPDIFF(SECOND, ${local_on_route_raw}, ${local_on_scene_raw}) / 60 ;;
  }

  measure: avg_on_route_queue_mins {
    label: "On-Route Avg Time (mins)"
    type: average
    value_format: "0.##"
    sql: ${in_on_route_queue_mins} ;;
    filters: {
      field: in_on_route_queue
      value: "yes"
    }
    drill_fields: [details*]
  }

  dimension: in_on_scene_queue {
    label: "On-Scene Queue flag"
    type: yesno
    sql: ${local_on_scene_raw} IS NOT NULL AND
         ${local_complete_raw} IS NOT NULL AND
        TIMESTAMPDIFF(SECOND, ${local_on_scene_raw}, ${local_complete_raw}) > 299 AND
        TIMESTAMPDIFF(SECOND, ${local_on_scene_raw}, ${local_complete_raw}) < 14401;;
  }

  dimension: in_on_scene_queue_mins {
    label: "On-Scene Time (mins)"
    type: number
    sql: ROUND(TIMESTAMPDIFF(SECOND, ${local_on_scene_raw}, ${local_complete_raw}) / 60, 2) ;;
  }

  measure: avg_on_scene_queue_mins {
    label: "On-Scene Avg Time (mins)"
    type: average
    value_format: "0.##"
    sql: ${in_on_scene_queue_mins} ;;
    filters: {
      field: in_on_scene_queue
      value: "yes"
    }
    drill_fields:
    [payer_dimensions.custom_insurance_grouping,
     avg_on_scene_queue_mins
    ]
  }

  measure: average_time_in_queue {
    type: average
    sql: ${minutes_in_queue};;
    filters: {
      field: in_queue
      value: "yes"
    }
    drill_fields: [details*]
    value_format_name: decimal_1
  }

  measure: average_time_in_accepted_queue {
    type: average
    sql: ${minutes_in_queue};;
    filters: {
      field: in_accepted_queue
      value: "yes"
    }
    drill_fields: [details*]
    value_format_name: decimal_1
  }

  measure: average_time_in_on_route_queue {
    type: average
    sql: ${minutes_in_queue};;
    filters: {
      field: in_on_route_queue
      value: "yes"
    }
    drill_fields: [details*]
    value_format_name: decimal_1
  }

  measure: average_time_in_on_scene_queue {
    type: average
    sql: ${minutes_in_queue};;
    filters: {
      field: in_on_scene_queue
      value: "yes"
    }
    drill_fields: [details*]
    value_format_name: decimal_1
  }

  measure: total_average_time {
    description: "The total of the averages of queue time"
    type: number
    sql: ${avg_queue_mins} + ${avg_accepted_queue_mins} + ${avg_on_route_queue_mins} + ${avg_on_scene_queue_mins} ;;
  }

  measure: total_wait_time {
    label: "Total Avg Wait Time"
    description: "The total average time in the 'in-queue' and 'in-accepted queue' time"
    type: number
    sql: ${avg_queue_mins} + ${avg_accepted_queue_mins} ;;
  }

  dimension: bb_3_day {
    label: "3-Day Bounce back flag"
    type: yesno
    sql: (${day_3_followup_outcome} != 'INACTIVE' AND ${day_3_followup_outcome} != 'patient_called_but_did_not_answer' AND
        ${day_3_followup_outcome} != 'REMOVED') AND
        (${day_3_followup_outcome} = 'ed_same_complaint' OR ${day_3_followup_outcome} = 'hospitalization_same_complaint');;
  }

  measure: bb_3_day_count {
    label: "3-Day Bounce back Count"
    type: count
    filters: {
      field: bb_3_day
      value: "yes"
    }
  }

  dimension: followup_3day {
    type: yesno
    description: "A flag indicating the 3-day follow-up was completed"
    sql: ${billable_visit} AND ${resolve_reason} LIKE '%NOT APPLICABLE%' AND
      (${day_3_followup_outcome} NOT IN ('PENDING', 'REMOVED', 'patient_called_but_did_not_answer', 'UNDOCUMENTED')) ;;
  }

  measure: count_3day_followups {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: followup_3day
      value: "yes"
    }
  }

  dimension: bb_14_day {
    label: "14-Day Bounce back flag"
    type: yesno
    sql: (${bb_3_day} IS TRUE OR ${day_14_followup_outcome} = 'ed_same_complaint' OR ${day_14_followup_outcome} = 'hospitalization_same_complaint')
      AND ${day_3_followup_outcome} != 'REMOVED';;
  }

  measure: bb_14_day_count {
    label: "14-Day Bounce back Count"
    type: count
    filters: {
      field: bb_14_day
      value: "yes"
    }
  }

  dimension: bb_14_day_test {
    label: "14-Day Bounce back flag, removing any bouncebacks without a 30 day followup"
    type: yesno
    sql: ((${bb_3_day} AND ${day_30_followup_outcome} NOT IN ('REMOVED', 'PENDING', 'no_hie_data', 'UNDOCUMENTED'))
    OR ${day_14_followup_outcome} = 'ed_same_complaint' OR ${day_14_followup_outcome} = 'hospitalization_same_complaint')
    AND ${day_3_followup_outcome} != 'REMOVED';;
  }

  measure: bb_14_day_count_test {
    label: "14-Day Bounce back Count With No Followups Removed"
    type: count
    filters: {
      field: bb_14_day_test
      value: "yes"
    }
  }


  dimension: bb_30_day {
    label: "30-Day Bounce back flag"
    type: yesno
    sql: (${bb_3_day} OR ${bb_14_day} OR ${day_30_followup_outcome} = 'ed_same_complaint' OR ${day_30_followup_outcome} = 'hospitalization_same_complaint')
      AND ${day_3_followup_outcome} != 'REMOVED';;
  }

  dimension: bb_30_day_test {
    label: "30-Day Bounce back flag, removing any bouncebacks without a 30 day followup"
    type: yesno
    sql: (((${bb_3_day} OR ${bb_14_day}) AND ${day_30_followup_outcome} NOT IN ('REMOVED', 'PENDING', 'no_hie_data', 'UNDOCUMENTED'))
         OR ${day_30_followup_outcome} = 'ed_same_complaint' OR ${day_30_followup_outcome} = 'hospitalization_same_complaint')
      AND ${day_3_followup_outcome} != 'REMOVED';;
  }

  measure: bb_30_day_count_test {
    label: "30-Day Bounce back Count With No Followups Removed"
    type: count
    filters: {
      field: bb_30_day_test
      value: "yes"
    }
  }

  measure: bb_30_day_count {
    label: "30-Day Bounce back Count"
    type: count
    filters: {
      field: bb_30_day
      value: "yes"
    }
  }

  dimension: followup_30day {
    type: yesno
    description: "A flag indicating the 30-day follow-up was completed"
    sql: ${billable_visit} AND ${resolve_reason} LIKE '%NOT APPLICABLE%' AND
      (${day_30_followup_outcome} NOT IN ('REMOVED', 'PENDING', 'no_hie_data', 'UNDOCUMENTED') OR
      ${bb_3_day} OR ${bb_14_day}) ;;
  }

  measure: count_30day_followups {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: followup_30day
      value: "yes"
    }
  }

  dimension: followup_removed {
    label: "Removed from Followup Queue"
    type: yesno
    sql: ${day_3_followup_outcome} = 'REMOVED';;
  }

  measure: followup_removed_count {
    label: "Removed from Followup Queue Count"
    type: count
    filters: {
      field: followup_removed
      value: "yes"
    }
  }

  dimension: no_followup_3_day {
    label: "No 3-Day followup flag"
    type: yesno
    sql: ${local_complete_raw} IS NOT NULL AND (${day_3_followup_outcome} = 'UNDOCUMENTED' OR ${day_3_followup_outcome} = 'PENDING') ;;
  }

  measure: no_followup_3_day_count {
    label: "No 3-Day followup Count"
    type: count
    filters: {
      field: no_followup_3_day
      value: "yes"
    }
  }

  dimension: no_followup_14_day {
    label: "No 14-Day followup flag"
    type: yesno
    sql: ${local_complete_raw} IS NOT NULL AND (${day_14_followup_outcome} = 'UNDOCUMENTED' OR ${day_14_followup_outcome} = 'PENDING');;
  }

  measure: no_followup_14_day_count {
    label: "No 14-Day followup Count"
    type: count
    filters: {
      field: no_followup_14_day
      value: "yes"
    }
  }

  dimension: no_followup_30_day {
    label: "No 30-Day followup flag"
    type: yesno
    sql: ${local_complete_raw} IS NOT NULL AND (${day_30_followup_outcome} = 'UNDOCUMENTED' OR ${day_30_followup_outcome} = 'PENDING');;
  }

  measure: no_followup_30_day_count {
    label: "No 30-Day followup Count"
    type: count
    filters: {
      field: no_followup_30_day
      value: "yes"
    }
  }

  measure: average_on_scene_time {
    type: average
    sql: ${hours_on_scene} ;;
    drill_fields: [details*]
    value_format_name: decimal_2
  }

  dimension: market_age_months {
    type: number
    sql:  TIMESTAMPDIFF(MONTH, ${market_start_date.first_accepted_time}, ${local_requested_time}) ;;

  }

  dimension: channel_age_months {
    type: number
    sql:  TIMESTAMPDIFF(MONTH, ${channel_start_date.first_accepted_time}, ${local_requested_time}) ;;

  }
  dimension: month_number {
    type: number
    sql:month(${local_requested_time}) ;;

  }

  dimension: resolved_seen_flag {
    type: yesno
    sql: (${resolved} AND ${local_on_scene_time} IS NOT NULL);;
  }

  measure: count_of_resolved_seen {
    label: "Resolved & Seen Count"
    type: count
    filters: {
      field: resolved_seen_flag
      value: "yes"
    }

    drill_fields: [details*]
  }

  set: details {
    fields: [id, hours_on_scene, total_charge]
  }

  measure: sum_total_expected_allowable {
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql:  ${total_expected_allowable} ;;
  }

  measure: expected_allowable_per_hour {
    type: number
    sql:  round(${sum_total_expected_allowable}/${app_shift_planning_facts.sum_hours_worked},2) ;;
  }

  measure: projected_billable_difference {
    type: number
    sql:  ${count_of_billable_visits}-${budget_projections_by_market.projection_visits_month_to_date};;
  }

measure: monthly_billable_visits_run_rate {
  type: number
  sql: round(${count_of_billable_visits}/${visit_dimensions.month_percent},0) ;;
}

  measure: monthly_total_expected_allowable_rate {
    type: number
    sql: round(${sum_total_expected_allowable}/${visit_dimensions.month_percent},0) ;;
  }

measure: projected_billable_difference_run_rate {
    type: number
    sql:  ${monthly_billable_visits_run_rate}-${budget_projections_by_market.projected_visits_measure};;
  }

dimension: scheduled {
  type: yesno
  sql:  abs(TIME_TO_SEC(timediff(${visit_facts.requested_time}, ${visit_facts.accepted_time})))>(12*60*60);;
}
  measure: scheduled_count {
    type: count
    filters: {
      field: scheduled
      value: "yes"
    }
  }

}
