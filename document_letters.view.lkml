view: document_letters {
  sql_table_name: athena.document_letters ;;
  drill_fields: [id]
  view_label: "Athena Clinical Letters"

  dimension: id {
    primary_key: yes
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
    hidden: yes
    sql: ${TABLE}."denied_by" ;;
  }

  dimension_group: denied_datetime {
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
    description: "LETTER"
    sql: ${TABLE}."document_class" ;;
  }

  dimension: document_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."document_id" ;;
  }

  dimension: document_subclass {
    type: string
    group_label: "Description"
    description: "LETTER_PATIENTCORRESPONDENCE or NULL"
    sql: ${TABLE}."document_subclass" ;;
  }

  dimension: image_exists_yn {
    type: string
    hidden: yes
    sql: ${TABLE}."image_exists_yn" ;;
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

  dimension: route {
    type: string
    sql: ${TABLE}."route" ;;
  }

  dimension: source {
    type: string
    description: "ENCOUNTER"
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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: clinical_letters_sent_all {
    description: "Identifies clinical letters sent to any recipient"
    hidden: yes
    type: yesno
    sql: (upper(${document_subclass}) != 'LETTER_PATIENTCORRESPONDENCE' OR ${document_subclass} IS NULL) and upper(${status}) != 'DELETED' ;;
  }

  measure: count_appointments_clinical_letters_sent_all {
    description: "Count appointments where the clinical letter was sent to any recipient"
    type: count_distinct

    sql: ${clinical_encounter_id} ;;
    filters: {
      field: clinical_letters_sent_all
      value: "yes"
    }
    group_label: "Clinical Letters"
  }

  dimension: clinical_letters_sent_pcp {
    description: "Identifies clinical letters sent to any recipient"
    hidden: yes
    type: yesno
    sql:  (upper(${document_subclass}) != 'LETTER_PATIENTCORRESPONDENCE' OR ${document_subclass} IS NULL) and upper(${status}) != 'DELETED' AND upper(${clinicalletter.role}) = 'PRIMARY CARE PROVIDER' ;;
  }

  measure: count_appointments_clinical_letters_sent_pcp {
    description: "Count appointments where the clinical letter was sent to the primary care provider"
    type: count_distinct

    sql: ${clinical_encounter_id} ;;
    filters: {
      field: clinical_letters_sent_pcp
      value: "yes"
    }
    group_label: "Clinical Letters"
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
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
