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

  measure: count {
    type: count
    drill_fields: [id, ehr_name, care_requests.ehr_name, care_requests.consenter_name, care_requests.id]
  }

  measure: credit_card_count {
    type: count_distinct
    sql: ${care_request_id} ;;
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
