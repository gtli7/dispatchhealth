view: athena_document_results {
  sql_table_name: athena.document_results ;;
  drill_fields: [id]
  # view_label: "Athena Document Results"

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."id" ;;
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
    hidden: yes
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

  dimension: clinical_order_genus {
    type: string
    group_label: "Description"
    description: "High level result genus e.g. 'XR', 'CBC W/ DIFF', etc."
    sql: ${TABLE}."clinical_order_genus" ;;
  }

  dimension: clinical_order_type {
    type: string
    description: "Detailed description of result e.g. 'XR CHEST 2 VIEW', etc."
    group_label: "Description"
    sql: ${TABLE}."clinical_order_type" ;;
  }

  dimension: clinical_order_type_group {
    type: string
    description: "LAB or IMAGING"
    group_label: "Description"
    sql: ${TABLE}."clinical_order_type_group" ;;
  }

  dimension: clinical_provider_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."clinical_provider_id" ;;
  }

  dimension: clinical_provider_order_type {
    type: string
    description: "The description associated with the clinical provider fulfilling the order"
    group_label: "Description"
    sql: ${TABLE}."clinical_provider_order_type" ;;
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
    group_label: "Description"
    description: "LABRESULT or IMAGINGRESULT"
    sql: ${TABLE}."document_class" ;;
  }

  dimension: document_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."document_id" ;;
  }

  dimension: external_note {
    type: string
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
    sql: ${TABLE}."image_exists_yn" ;;
  }

  dimension: interface_vendor_name {
    type: string
    sql: ${TABLE}."interface_vendor_name" ;;
  }

  dimension: notifier {
    type: string
    sql: ${TABLE}."notifier" ;;
  }

  dimension_group: observation_ {
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
    sql: ${TABLE}."observation_datetime" ;;
  }

  dimension_group: order {
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
    sql: ${TABLE}."order_datetime" ;;
  }

  dimension: order_document_id {
    type: number
    description: "The document ID associated with the order"
    group_label: "IDs"
    sql: ${TABLE}."order_document_id" ;;
  }

  dimension: order_text {
    type: string
    sql: ${TABLE}."order_text" ;;
  }

  dimension: out_of_network_ref_reason_name {
    type: string
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
    sql: ${TABLE}."patient_note" ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}."priority" ;;
  }

  dimension: provider_note {
    type: string
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
    sql: ${TABLE}."result_notes" ;;
  }

  dimension: reviewed_by {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."reviewed_by" ;;
  }

  dimension_group: reviewed {
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
    sql: ${TABLE}."reviewed_datetime" ;;
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

  dimension: result_rcvd_to_closed  {
    type: number
    hidden: yes
    value_format: "0.00"
    sql: (EXTRACT(EPOCH FROM ${athena_result_closed.result_closed_raw}) -
      EXTRACT(EPOCH FROM ${athena_result_created.result_created_raw})) / 3600 ;;
  }

  measure: average_result_rcvd_to_closed {
    description: "Average time between order result received and closed (Hrs)"
    group_label: "Time Cycle Management"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    drill_fields: [document_id, patients.ehr_id, clinical_order_type, result_rcvd_to_closed]
    filters: [clinical_order_type_group: "LAB, IMAGING"]
    sql: ${result_rcvd_to_closed} ;;
    value_format: "0.00"
  }

  dimension: result_tat_provider  {
    type: number
    # hidden: yes
    value_format: "0.00"
    sql: CASE WHEN ${athena_inbox_turnaround.received_ma_raw} IS NOT NULL
        THEN (EXTRACT(EPOCH FROM ${athena_inbox_turnaround.received_ma_raw}) -
              EXTRACT(EPOCH FROM ${athena_inbox_turnaround.received_provider_raw})) / 3600
        WHEN ${athena_result_closed.result_closed_raw} IS NOT NULL
        THEN (EXTRACT(EPOCH FROM ${athena_result_closed.result_closed_raw}) -
         EXTRACT(EPOCH FROM ${athena_inbox_turnaround.received_provider_raw})) / 3600
        ELSE NULL END;;
  }

  measure: average_turnaround_time_provider {
    description: "Average result turnaround time - provider (Either sent to MA or closed)"
    group_label: "Time Cycle Management"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    drill_fields: [document_id, patients.ehr_id, clinical_order_type, result_rcvd_to_closed]
    filters: [clinical_order_type_group: "LAB, IMAGING"]
    sql: ${result_tat_provider} ;;
    value_format: "0.00"
  }

  dimension: result_tat_ma  {
    type: number
    # hidden: yes
    value_format: "0.00"
    sql: CASE WHEN ${athena_inbox_turnaround.received_ma_raw} IS NOT NULL AND
        ${athena_result_closed.result_closed_raw} IS NOT NULL
        THEN (EXTRACT(EPOCH FROM ${athena_result_closed.result_closed_raw}) -
         EXTRACT(EPOCH FROM ${athena_inbox_turnaround.received_ma_raw})) / 3600
        ELSE NULL END;;
  }

  measure: average_turnaround_time_ma {
    description: "Average result turnaround time - MA (Received by MA to closed)"
    group_label: "Time Cycle Management"
    type: average_distinct
    sql_distinct_key: ${id} ;;
    drill_fields: [document_id, patients.ehr_id, clinical_order_type, result_rcvd_to_closed]
    filters: [clinical_order_type_group: "LAB, IMAGING"]
    sql: ${result_tat_ma} ;;
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
      provider_username,
      interface_vendor_name,
      out_of_network_ref_reason_name,
      patient.first_name,
      patient.last_name,
      patient.new_patient_id,
      patient.guarantor_first_name,
      patient.guarantor_last_name,
      patient.emergency_contact_name,
      department.department_name,
      department.billing_name,
      department.gpci_location_name,
      department.department_id,
      document_orders.count
    ]
  }
}
