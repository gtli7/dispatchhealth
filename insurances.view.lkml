view: insurances {
  sql_table_name: public.insurances ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: card_back {
    type: string
    hidden: yes
    sql: ${TABLE}.card_back ;;
  }

  dimension: card_front {
    type: string
    hidden: no
    sql: ${TABLE}.card_front ;;
  }

  dimension: card_front_image_file {
  sql: ('https://s3-us-west-2.amazonaws.com/dispatchhealthimages/uploads/insurance/card_front/'||${id}||'/'||${card_front}) ;;
    # sql: ('https://s3-us-west-2.amazonaws.com/dispatchhealth-web-qa/uploads/testimonial/image/18/builtincoloradotop50startups.jpg') ;;
  }

  dimension: insurance_card_front {
    sql: ${card_front_image_file};;
    html: <img src="{{ value }}" width="120" height="100"/> ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }

  dimension: copay_office_visit {
    type: string
    sql: ${TABLE}.copay_office_visit ;;
  }

  dimension: copay_specialist {
    type: string
    sql: ${TABLE}.copay_specialist ;;
  }

  dimension: copay_urgent_care {
    type: string
    sql: ${TABLE}.copay_urgent_care ;;
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
    sql: ${TABLE}.created_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  dimension: ehr_id {
    type: string
    sql: ${TABLE}.ehr_id ;;
  }

  dimension: ehr_name {
    type: string
    sql: ${TABLE}.ehr_name ;;
  }

  dimension: eligibility_message {
    type: string
    sql: ${TABLE}.eligibility_message ;;
  }

  dimension: eligible {
    type: string
    sql: ${TABLE}.eligible ;;
  }

  dimension: employer {
    type: string
    sql: ${TABLE}.employer ;;
  }

  dimension_group: end {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.end_date ;;
  }

  dimension: group_number {
    type: string
    sql: ${TABLE}.group_number ;;
  }

  dimension: insured_same_as_patient {
    type: yesno
    sql: ${TABLE}.insured_same_as_patient ;;
  }

  dimension: list_phone {
    type: string
    sql: ${TABLE}.list_phone ;;
  }

  dimension: member_id {
    type: string
    sql: ${TABLE}.member_id ;;
  }

  dimension: package_id {
    type: string
    sql: ${TABLE}.package_id ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: patient_relation_to_subscriber {
    type: string
    sql: ${TABLE}.patient_relation_to_subscriber ;;
  }

  dimension: plan_type {
    type: string
    sql: ${TABLE}.plan_type ;;
  }

  dimension: policy_holder_type {
    type: string
    sql: ${TABLE}.policy_holder_type ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}.priority ;;
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

  dimension: scanned_data {
    type: string
    sql: ${TABLE}.scanned_data ;;
  }

  dimension_group: start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.start_date ;;
  }

  dimension: subscriber_city {
    type: string
    sql: ${TABLE}.subscriber_city ;;
  }

  dimension_group: subscriber_dob {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.subscriber_dob ;;
  }

  dimension: subscriber_first_name {
    type: string
    sql: ${TABLE}.subscriber_first_name ;;
  }

  dimension: subscriber_gender {
    type: string
    sql: ${TABLE}.subscriber_gender ;;
  }

  dimension: subscriber_last_name {
    type: string
    sql: ${TABLE}.subscriber_last_name ;;
  }

  dimension: subscriber_middle_initial {
    type: string
    sql: ${TABLE}.subscriber_middle_initial ;;
  }

  dimension: subscriber_phone {
    type: string
    sql: ${TABLE}.subscriber_phone ;;
  }

  dimension: subscriber_state {
    type: string
    sql: ${TABLE}.subscriber_state ;;
  }

  dimension: subscriber_street_address {
    type: string
    sql: ${TABLE}.subscriber_street_address ;;
  }

  dimension: subscriber_zipcode {
    type: string
    sql: ${TABLE}.subscriber_zipcode ;;
  }

  dimension: out_of_network_insurance {
    description: "The insurance package ID is not in the list of in-network packages for a state, or the patient is self-pay"
    type: yesno
    sql: ${insurance_plans.package_id} IS NULL AND ${athenadwh_patient_insurances_clone.insurance_package_id} <> '-100' ;;
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
    sql: ${TABLE}.updated_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  measure: last_updated_date {
    type: date
    sql: MAX(${updated_raw}) ;;
    convert_tz: no
  }

  dimension: insurance_updated_flag {
    type: yesno
    sql: ${updated_date} = ${care_request_flat.complete_date}::date;;
  }

  dimension: insurance_card_captured_flag {
    type: yesno
    sql: ${card_front} IS NOT NULL ;;
  }

  measure: count_insurances_updated {
    type: count_distinct
    description: "The count of patients where the insurance information was updated the same date as the visit"
    sql: ${patient_id} ;;
    filters: {
      field: insurance_updated_flag
      value: "yes"
    }
  }

  measure: count_insurance_image_captured {
    type: count_distinct
    description: "The count of patients where the insurance card image was stored at the same date as the visit"
    sql: ${patient_id} ;;
    filters: {
      field: insurance_card_captured_flag
      value: "yes"
    }
  }

  dimension: web_address {
    type: string
    sql: ${TABLE}.web_address ;;
  }

  measure: count_distinct_priority_one{
    type: count_distinct
    sql: ${package_id} ;;
    filters: {
      field:  priority
      value: "1"

    }
  }

  measure: count {
    type: count
    drill_fields: [id, company_name, subscriber_first_name, subscriber_last_name, ehr_name]
  }
}
