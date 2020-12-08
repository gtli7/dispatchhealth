view: athena_document_orders {
  sql_table_name: athena.document_orders ;;
  drill_fields: [id]
#   view_label: "Athena Document Orders"

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
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
    description: "The number of days set before an inbox alarm is triggered"
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

  dimension: clinical_order_genus {
    type: string
    description: "The high-level description of the order e.g. 'URINALYSIS', 'CMP', etc."
    group_label: "Description"
    sql: ${TABLE}."clinical_order_genus" ;;
  }

  dimension: imaging_clinical_order_genus {
    type: string
    description: "The clinical order genus associated with all imaging orders"
    group_label: "Description"
    sql: CASE WHEN ${clinical_order_genus} IN ('XR','US','CT','MR') AND ${status} <> 'DELETED' THEN ${clinical_order_genus}
         ELSE NULL END;;
  }

  dimension: labs_flag {
    description: "A flag indicating labs were ordered (Athena clinical order type group = 'LAB')"
    type: yesno
    sql: ${clinical_order_type_group} = 'LAB' ;;
  }

  dimension: imaging_flag {
    description: "A flag indicating all non-deleted imaging, CT, MRI and ultrasound orders (Athena clinical order genus = 'US' or 'XR')"
    type: yesno
    sql: ${clinical_order_genus} IN ('US','XR', 'CT','MR') AND ${status} <> 'DELETED' ;;
  }

  measure: count_imaging_us_orders {
    description: "Count of all imaging and ultrasound orders"
    group_label: "Counts"
    type: count_distinct
    sql: ${document_id} ;;
    filters: [clinical_order_genus: "US, XR, CT, MR", status: "-DELETED"]
  }

  measure: count_xray_orders {
    description: "Count of all X-ray orders"
    group_label: "Counts"
    type: count_distinct
    sql: ${document_id} ;;
    filters: [clinical_order_genus: "XR", status: "-DELETED"]
  }

  measure: count_ultrasound_orders {
    description: "Count of all ultrasound orders"
    group_label: "Counts"
    type: count_distinct
    sql: ${document_id} ;;
    filters: [clinical_order_genus: "US", status: "-DELETED"]
  }

  measure: count_ct_scan_orders {
    description: "Count of all CT scan orders"
    group_label: "Counts"
    type: count_distinct
    sql: ${document_id} ;;
    filters: [clinical_order_genus: "CT", status: "-DELETED"]
  }

  measure: count_mri_orders {
    description: "Count of all MRI orders"
    group_label: "Counts"
    type: count_distinct
    sql: ${document_id} ;;
    filters: [clinical_order_genus: "MR", status: "-DELETED"]
  }

  dimension: dme_flag {
    type: yesno
    description: "A flag indicating durable medical equipment was ordered (Athena document class = 'DME')"
    sql: ${document_class} = 'DME' ;;
  }

  dimension: clinical_order_type {
    type: string
    description: "The detailed description of the order e.g. 'URINALYSIS DIPSTICK', etc."
    group_label: "Description"
    sql: ${TABLE}."clinical_order_type" ;;
  }

  dimension: urinalysis_performed {
    type: yesno
    description: "A flag indicating a Urinalysis was performed (culture, panel, dipstick or complete)"
    group_label: "Description"
    sql: ${clinical_order_type} IN ('URINALYSIS REFLEX CULTURE',
        'URINALYSIS PANEL AUTO',
        'URINALYSIS DIPSTICK REFLEX MICRO',
        'URINALYSIS DIPSTICK AUTO',
        'URINALYSIS DIPSTICK',
        'URINALYSIS COMPLETE REFLEX CULTURE',
        'URINALYSIS COMPLETE') ;;
  }

  measure: aggregated_orders {
    type: string
    description: "Aggregation of all document orders"
    group_label: "Description"
    sql: array_to_string(array_agg(DISTINCT ${clinical_order_type}), ' | ') ;;
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
    description: "The order type as defined by the fulfilling provider"
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

  dimension: created_clinical_encounter_id {
    type: number
    hidden: yes
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

  dimension: cvx {
    type: string
    hidden: yes
    sql: ${TABLE}."cvx" ;;
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
    # hidden: yes
    group_label: "IDs"
    sql: ${TABLE}."department_id" ;;
  }

  dimension: document_class {
    type: string
    description: "ORDER or DME"
    group_label: "Description"
    sql: ${TABLE}."document_class" ;;
  }

  dimension: document_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."document_id" ;;
  }

  measure: count_distinct_orders {
    type: count_distinct
    group_label: "Order Counts"
    sql: ${document_id} ;;
  }

  measure: count_positive_poc_covid_tests {
    type: count_distinct
    description: "Count of DH rapid POC COVID tests that were positive"
    group_label: "COVID Counts"
    sql: ${document_id} ;;
    filters: [clinical_order_type: "RAPID SARS COV + SARS COV 2 AG QL IA RESPIRATORY SPECIMEN",
      athena_clinicalresultobservation.result: "positive"]
  }

  measure: count_poc_covid_tests {
    type: count_distinct
    description: "Count of DH rapid POC COVID tests administered"
    group_label: "COVID Counts"
    sql: ${document_id} ;;
    filters: [clinical_order_type: "RAPID SARS COV + SARS COV 2 AG QL IA RESPIRATORY SPECIMEN"]
  }

  dimension: is_narrow_network_order {
    type: yesno
    hidden: no
    sql: ${insurance_networks.id} IS NOT NULL ;;
  }

  dimension: is_narrow_network_default_provider {
    type: yesno
    hidden: no
    sql: ${clinical_provider_id} = ${narrow_network_providers.athena_id} ;;
  }

#   dimension: is_narrow_network_default_provider {
#     type: yesno
#     hidden: yes
#     sql: ${narrow_network_orders.clinical_provider_id} IS NOT NULL ;;
#   }

  measure: count_narrow_network_orders {
    type: count_distinct
    description: "Count of distinct orders where patient is part of a narrow network"
    group_label: "Order Counts"
    sql: ${document_id} ;;
    filters: [is_narrow_network_order: "yes", status: "-DELETED", document_order_fulfilling_provider.provider_category: "Performed by Third Party"  ]
  }

  measure: count_narrow_network_orders_default_provider {
    type: count_distinct
    description: "Count of distinct orders where default narrow network provider is chosen"
    group_label: "Order Counts"
    sql: ${document_id} ;;
    filters: [is_narrow_network_default_provider: "yes", status: "-DELETED", document_order_fulfilling_provider.provider_category: "Performed by Third Party"  ]
  }

  dimension: document_results_document_id {
    type: number
    group_label: "IDs"
    description: "The document ID associated with the order result"
    sql: ${TABLE}."document_results_document_id" ;;
  }

  dimension: document_results_id {
    type: number
    hidden: yes
    sql: ${TABLE}."document_results_id" ;;
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
    sql: ${TABLE}."image_exists_yn" ;;
  }

  dimension: interface_vendor_name {
    type: string
    hidden: yes
    sql: ${TABLE}."interface_vendor_name" ;;
  }

  dimension: notifier {
    type: string
    group_label: "User Actions"
    description: "The entity creating the notification of the order e.g. 'ATHENA', 'HOU - HOME STAFF', etc."
    sql: ${TABLE}."notifier" ;;
  }

  dimension_group: observation {
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
    group_label: "Notes"
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
    group_label: "Notes"
    sql: ${TABLE}."patient_note" ;;
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
    sql: ${TABLE}."provider_username" ;;
  }

  # dimension_group: received {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}."received_datetime" ;;
  # }

  dimension: result_notes {
    type: string
    group_label: "Notes"
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
    hidden: yes
    sql: ${TABLE}."route" ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}."source" ;;
  }

  dimension: specimen_collected_by {
    type: string
    group_label: "User Actions"
    sql: ${TABLE}."specimen_collected_by" ;;
  }

  dimension_group: specimen_collected {
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
    sql: ${TABLE}."specimen_collected_datetime" ;;
  }

  dimension: specimen_description {
    type: string
    sql: ${TABLE}."specimen_description" ;;
  }

  dimension: specimen_draw_location {
    type: string
    sql: ${TABLE}."specimen_draw_location" ;;
  }

  dimension: specimen_source {
    type: string
    sql: ${TABLE}."specimen_source" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
  }

  dimension_group: updated {
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
    hidden: yes
    sql: ${TABLE}."vaccine_route" ;;
  }

  dimension_group: submitted_order {
    description: "The date the order was submitted"
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
    sql: ${athena_order_submitted.order_submitted_raw} ;;
  }

  dimension: order_created_to_submitted  {
    type: number
    hidden: yes
    value_format: "0.00"
    sql: (EXTRACT(EPOCH FROM ${athena_order_submitted.order_submitted_raw}) -
          EXTRACT(EPOCH FROM ${athena_order_created.order_created_raw})) / 3600 ;;
  }

  measure: average_created_to_submitted {
    description: "Average time between order created and submitted (Hrs)"
    group_label: "Time Cycle Management"
    type: average
    drill_fields: [document_id, patients.ehr_id, clinical_order_type, order_created_to_submitted]
    filters: [clinical_order_type_group: "LAB, IMAGING"]
    sql: ${order_created_to_submitted} ;;
    value_format: "0.00"
  }

  dimension_group: received_order_result {
    description: "The date the order was received"
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
    sql: ${athena_result_created.result_created_raw} ;;
  }

  dimension: order_submitted_to_result_rcvd  {
    type: number
    hidden: yes
    value_format: "0.00"
    sql: (EXTRACT(EPOCH FROM ${athena_result_created.result_created_raw}) -
      EXTRACT(EPOCH FROM ${athena_order_submitted.order_submitted_raw})) / 3600 ;;
  }

  measure: average_submitted_to_result_rcvd {
    description: "Average time between order submitted and result received (Hrs)"
    group_label: "Time Cycle Management"
    type: average
    drill_fields: [document_id, patients.ehr_id, clinical_order_type, order_submitted_to_result_rcvd]
    filters: [clinical_order_type_group: "LAB, IMAGING", status: "-DELETED"]
    sql: ${order_submitted_to_result_rcvd} ;;
    value_format: "0.00"
  }

  dimension_group: status_order_closed {
    description: "The date the order was received"
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
    sql: ${athena_result_closed.result_closed_raw} ;;
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
    type: average
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
    type: average
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
    type: average
    drill_fields: [document_id, patients.ehr_id, clinical_order_type, result_rcvd_to_closed]
    filters: [clinical_order_type_group: "LAB, IMAGING"]
    sql: ${result_tat_ma} ;;
    value_format: "0.00"
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: labs_ordered_3rd_party {
    description: "Lab ordered from third party"
    type: yesno
    hidden: no
    sql: upper(${clinical_order_type_group}) = 'LAB'
     AND upper(${status}) != 'DELETED'
     AND upper(${document_class}) = 'ORDER'
     AND UPPER(${document_order_fulfilling_provider.provider_category}) = 'PERFORMED BY THIRD PARTY'  ;;
  }

  measure: count_lab_orders_from_3rd_party {
    description: "Count of lab orders from third party"
    type: count_distinct
    sql: ${document_id} ;;
    filters: {
      field: labs_ordered_3rd_party
      value: "yes"
    }
    group_label: "Order Counts"
  }

#   measure: count_eligible_narrow_network_lab_orders {
#     description: "Count lab orders for patients that are part of a narrow network"
#     type: count_distinct
#     sql: ${document_id} ;;
#     filters: [labs_ordered_3rd_party: "yes", is_narrow_network_order: "yes"]
#
#     group_label: "Order Counts"
#   }
#
#   measure: count_lab_orders_narrow_network_default_provider {
#     description: "Count of lab orders from an in network provider"
#     type: count_distinct
#     sql: ${document_id} ;;
#     filters: [labs_ordered_3rd_party: "yes", is_narrow_network_default_provider: "yes"]
#     group_label: "Order Counts"
#   }

  dimension: imaging_ordered_3rd_party {
    description: "Imaging ordered from third party"
    type: yesno
    hidden: yes
    sql: upper(${clinical_order_type_group}) = 'IMAGING' AND upper(${status}) != 'DELETED' AND upper(${document_class}) = 'ORDER' AND UPPER(${document_order_fulfilling_provider.provider_category}) = 'PERFORMED BY THIRD PARTY';;
  }

  measure: count_imaging_orders_from_3rd_party {
    description: "Count of imaging orders from thrid party"
    type: count_distinct
    sql: ${document_id} ;;
    filters: {
      field: imaging_ordered_3rd_party
      value: "yes"
    }
    group_label: "Order Counts"
  }

#   measure: count_eligible_narrow_network_imaging_orders {
#     description: "Count imaging orders for patients that are part of a narrow network"
#     type: count_distinct
#     sql: ${document_id} ;;
#     filters: [imaging_ordered_3rd_party: "yes", is_narrow_network_order: "yes"]
#
#     group_label: "Order Counts"
#   }
#
#   measure: count_imaging_orders_narrow_network_default_provider {
#     description: "Count of imaging orders from an in network provider"
#     type: count_distinct
#     sql: ${document_id} ;;
#     filters: [imaging_ordered_3rd_party: "yes", is_narrow_network_default_provider: "yes"]
#     group_label: "Order Counts"
#   }

  dimension: procedures_performed {
    description: "Identifies care requests where one or more procedures were performed"
    type: yesno
    hidden: yes
    sql: upper(${clinical_order_type_group}) = 'PROCEDURE' AND upper(${status}) != 'DELETED' AND upper(${document_class}) = 'ORDER'  ;;
  }

  measure: count_appointments_with_procedures {
    description: "Count of care requests where one or more procedures were performed"
    type: count_distinct
    sql: ${clinical_encounter_id} ;;
    filters: {
      field: procedures_performed
      value: "yes"
    }
    group_label: "Order Counts"
  }

  measure: order_type_concat {
    label: "Description Of Items Ordered"
    type: string
    sql: string_agg(DISTINCT ${clinical_order_type}, ' | ') ;;
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
      document_results.provider_username,
      document_results.id,
      document_results.interface_vendor_name,
      document_results.out_of_network_ref_reason_name
    ]
  }
}
