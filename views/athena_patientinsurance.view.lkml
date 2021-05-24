view: athena_patientinsurance {
  sql_table_name: athena.patientinsurance ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: __batch_id {
    type: string
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension_group: __file {
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
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}."address" ;;
  }

  dimension: address2 {
    type: string
    sql: ${TABLE}."address2" ;;
  }

  dimension_group: cancellation {
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
    sql: ${TABLE}."cancellation_date" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."city" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."country" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}."created_by" ;;
  }

  dimension_group: created_datetime {
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
    sql: ${TABLE}."created_datetime" ;;
  }

  dimension_group: dob {
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
    sql: ${TABLE}."dob" ;;
  }

  dimension_group: eligibility_last_checked {
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
    sql: ${TABLE}."eligibility_last_checked" ;;
  }

  dimension: eligibility_last_checked_by {
    type: string
    sql: ${TABLE}."eligibility_last_checked_by" ;;
  }

  dimension_group: eligibility_service {
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
    sql: ${TABLE}."eligibility_service_date" ;;
  }

  dimension: eligibility_status {
    type: string
    sql: ${TABLE}."eligibility_status" ;;
  }

  dimension: entity_type {
    type: string
    sql: ${TABLE}."entity_type" ;;
  }

  dimension_group: expiration {
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
    sql: ${TABLE}."expiration_date" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension: insurance_package_id {
    type: number
    sql: ${TABLE}."insurance_package_id" ;;
  }

  dimension_group: issue {
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
    sql: ${TABLE}."issue_date" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension: middle_name {
    type: string
    sql: ${TABLE}."middle_name" ;;
  }

  dimension: patient_char {
    type: string
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: patient_insurance_id {
    type: number
    sql: ${TABLE}."patient_insurance_id" ;;
  }

  dimension: patient_relationship {
    type: string
    sql: ${TABLE}."patient_relationship" ;;
  }

  dimension: sequence_number {
    type: string
    sql: ${TABLE}."sequence_number" ;;
  }

  dimension: sex {
    type: string
    sql: ${TABLE}."sex" ;;
  }

  dimension: ssn {
    type: string
    sql: ${TABLE}."ssn" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
  }

  dimension: status_reason {
    type: string
    sql: ${TABLE}."status_reason" ;;
  }

  dimension: suffix {
    type: string
    sql: ${TABLE}."suffix" ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."zip" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, middle_name]
  }
}
