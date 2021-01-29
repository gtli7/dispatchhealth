view: athena_document_prescriptions {
  sql_table_name: athena.document_prescriptions ;;
  view_label: "Athena Prescription Orders"
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: medication_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}.medication_id ;;
  }

  dimension: __batch_id {
    type: string
    hidden: yes
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension_group: __file {
    type: time
    hidden: yes
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
    hidden: yes
    sql: ${TABLE}."__from_file" ;;
  }

  dimension_group: alarm {
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
    sql: ${TABLE}."alarm_date" ;;
  }

  dimension: alarm_days {
    type: number
    sql: ${TABLE}."alarm_days" ;;
  }

  dimension: approved_by {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."approved_by" ;;
  }

  dimension_group: approved {
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
    sql: ${TABLE}."approved_datetime" ;;
  }

  dimension: assigned_to {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."assigned_to" ;;
  }

  dimension: chart_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."chart_id" ;;
  }

  dimension: clinical_encounter_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."clinical_encounter_id" ;;
  }

  dimension: clinical_order_type {
    type: string
    group_label: "Descriptions"
    description: "The detailed description of the prescription"
    sql: ${TABLE}."clinical_order_type" ;;
  }

  measure: aggregated_prescriptions {
    description: "Concatenated Prescription Order Descriptions"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${clinical_order_type}), ' | ') ;;
  }

  # measure: prescription_info_concat {
  #   label: "Description Of Prescription Medications"
  #   type: string
  #   sql: array_to_string(array_agg(DISTINCT
  #           CONCAT(${clinical_order_type}, ': ',
  #           ${dosage_route}, ': ',
  #           ${frequency})
  #           ), ' | ')  ;;
  # }

  dimension: clinical_order_type_group {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."clinical_order_type_group" ;;
  }

  dimension: clinical_provider_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."clinical_provider_id" ;;
  }

  dimension_group: created_at {
    type: time
    hidden: yes
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
    group_label: "User Actions"
    sql: ${TABLE}."created_by" ;;
  }

  dimension: created_clinical_encounter_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."created_clinical_encounter_id" ;;
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
    sql: ${TABLE}."created_datetime" ;;
  }

  dimension: deactivated_by {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."deactivated_by" ;;
  }

  dimension_group: deactivated {
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
    sql: ${TABLE}."deactivated_datetime" ;;
  }

  dimension: deleted_by {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."deleted_by" ;;
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
    sql: ${TABLE}."deleted_datetime" ;;
  }

  dimension: denied_by {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."denied_by" ;;
  }

  dimension_group: denied {
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
    sql: ${TABLE}."denied_datetime" ;;
  }

  dimension: department_id {
    type: number
    group_label: "IDs"
    # hidden: yes
    sql: ${TABLE}."department_id" ;;
  }

  dimension: document_class {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."document_class" ;;
  }

  dimension: document_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."document_id" ;;
  }

  dimension: document_subclass {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."document_subclass" ;;
  }

  dimension: external_note {
    type: string
    group_label: "Notes"
    sql: ${TABLE}."external_note" ;;
  }

  dimension: fbd_med_id {
    type: string
    group_label: "IDs"
    sql: ${TABLE}."fbd_med_id" ;;
  }

  dimension_group: future_submit {
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
    sql: ${TABLE}."future_submit_datetime" ;;
  }

  dimension: image_exists_yn {
    type: string
    hidden: yes
    sql: ${TABLE}."image_exists_yn" ;;
  }

  dimension: interface_vendor_name {
    type: string
    hidden: yes
    sql: ${TABLE}."interface_vendor_name" ;;
  }

  dimension: notifier {
    type: string
    hidden: yes
    sql: ${TABLE}."notifier" ;;
  }

  dimension_group: order {
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
    sql: ${TABLE}."order_datetime" ;;
  }

  dimension: order_document_id {
    type: number
    hidden: yes
    sql: ${TABLE}."order_document_id" ;;
  }

  dimension: order_text {
    type: string
    sql: ${TABLE}."order_text" ;;
  }

  dimension: out_of_network_ref_reason_name {
    type: string
    hidden: yes
    sql: ${TABLE}."out_of_network_ref_reason_name" ;;
  }

  dimension: patient_char {
    type: string
    hidden: yes
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_id {
    type: number
    group_label: "IDs"
    # hidden: yes
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: patient_note {
    type: string
    hidden: yes
    sql: ${TABLE}."patient_note" ;;
  }

  dimension: prescriptions_flag {
    type: yesno
    sql: ${document_id} IS NOT NULL ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}."priority" ;;
  }

  dimension: provider_note {
    type: string
    group_label: "Notes"
    sql: ${TABLE}."provider_note" ;;
  }

  dimension: provider_username {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."provider_username" ;;
  }

  dimension_group: received {
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
    sql: ${TABLE}."received_datetime" ;;
  }

  dimension: result_notes {
    type: string
    group_label: "Notes"
    sql: ${TABLE}."result_notes" ;;
  }

  dimension: route {
    type: string
    sql: ${TABLE}."route" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."source" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
  }

  dimension_group: updated_at {
    type: time
    hidden: yes
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

  dimension: vaccine_route {
    type: string
    sql: ${TABLE}."vaccine_route" ;;
  }

  dimension: prescription_created_to_submitted  {
    type: number
    hidden: yes
    value_format: "0.00"
    sql: (EXTRACT(EPOCH FROM ${athena_prescription_submitted.order_submitted_raw}) -
      EXTRACT(EPOCH FROM ${athena_prescription_created.order_created_raw})) / 3600 ;;
  }

  measure: average_created_to_submitted {
    description: "Average time between prescription created and submitted (Hrs)"
    group_label: "Time Cycle Management"
    type: average
    drill_fields: [document_id, patients.ehr_id, clinical_order_type, prescription_created_to_submitted]
    filters: [clinical_order_type_group: "PRESCRIPTION", status: "-DELETED"]
    sql: ${prescription_created_to_submitted} ;;
    value_format: "0.00"
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      out_of_network_ref_reason_name,
      interface_vendor_name,
      provider_username,
      department.department_name,
      department.billing_name,
      department.gpci_location_name,
      department.department_id,
      patient.first_name,
      patient.last_name,
      patient.new_patient_id,
      patient.guarantor_first_name,
      patient.guarantor_last_name,
      patient.emergency_contact_name
    ]
  }
}
