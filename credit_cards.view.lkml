view: credit_cards {
  sql_table_name: public.credit_cards ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: card_number_last_4 {
    type: string
    sql: ${TABLE}.card_number_last_4 ;;
  }

  dimension: card_type {
    type: string
    sql: ${TABLE}.card_type ;;
  }

  dimension: care_request_id {
    type: number
    # hidden: yes
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

  dimension: ehr_id {
    type: string
    sql: ${TABLE}.ehr_id ;;
  }

  dimension: ehr_name {
    type: string
    sql: ${TABLE}.ehr_name ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: dispatch_email {
    type: yesno
    sql: ${email} =  'Payments@dispatchhealth.com' ;;
  }


  dimension: epaymentid {
    type: string
    sql: ${TABLE}.epaymentid ;;
  }

  dimension_group: expires {
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
    sql: ${TABLE}.expires ;;
  }

  dimension: name_on_card {
    type: string
    sql: ${TABLE}.name_on_card ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
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

  dimension: cc_captured_at_onboarding {
    type: yesno
    hidden: yes
    sql: ${onboarding_care_request_credit_cards.care_request_id} IS NOT NULL ;;
  }

  dimension: cc_captured_on_scene {
    type: yesno
    hidden: yes
    sql: ${care_request_id} IS NOT NULL ;;
  }

  dimension: cc_captured_any {
    type: yesno
    hidden: yes
    sql: ${cc_captured_at_onboarding} OR ${cc_captured_on_scene} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, ehr_name, care_requests.ehr_name, care_requests.consenter_name, care_requests.id]
  }

  measure: credit_card_count_onboarding {
    type: count_distinct
    description: "Count of credit cards captured during patient onboarding"
    sql: ${care_requests.id} ;;
    filters: [cc_captured_at_onboarding: "yes"]
  }

  measure: credit_card_count_onscene {
    type: count_distinct
    description: "Count of credit cards captured by DHMT on-scene"
    sql: ${care_requests.id} ;;
    filters: [cc_captured_on_scene: "yes"]
  }

  measure: credit_card_count_any {
    type: count_distinct
    description: "Count of credit cards captured either during onboarding or on-scene"
    sql: ${care_requests.id} ;;
    filters: [cc_captured_any: "yes"]
  }

  measure: credit_card_count_commercial {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: primary_payer_dimensions_clone.commercial_flag
      value: "yes"
    }
  }

  measure: credit_card_count_medicare_advantage {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: primary_payer_dimensions_clone.medicare_advantage_flag
      value: "yes"
    }
  }

  measure: credit_card_count_medicaid {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: primary_payer_dimensions_clone.medicaid_flag
      value: "yes"
    }
  }

  measure: credit_card_count_medicare {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: primary_payer_dimensions_clone.medicare_flag
      value: "yes"
    }
  }

  measure: dh_credit_card_count {
    label: "Dispatch Health Credit Card Count"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: dispatch_email
      value: "yes"
    }
  }

    measure: non_dh_credit_card_count {
      label: "Non-Dispatch Health Credit Card Count"
      type: count_distinct
      sql: ${care_request_id} ;;
      filters: {
        field: dispatch_email
        value: "no"
      }
  }
}
