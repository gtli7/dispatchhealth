view: athenadwh_documentaction {
  sql_table_name: looker_scratch.athenadwh_documentaction ;;
  view_label: "ZZZZ - Athenadwh Documentaction"
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."id" ;;
  }

  dimension: action {
    type: string
    description: "The action taken on the document e.g. 'Notify by Staff'"
    sql: ${TABLE}."action" ;;
  }

  dimension: action_group {
    type: string
    description: "The group of the action taken e.g. 'Approve'"
    sql: ${TABLE}."action_group" ;;
  }

  dimension: assigned_to {
    type: string
    description: "The Athena user assigned to the action"
    sql: ${TABLE}."assigned_to" ;;
  }

  dimension_group: created {
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
    description: "The Athena user who created the action"
    sql: ${TABLE}."created_by" ;;
  }

  dimension_group: created_datetime {
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
    sql: ${TABLE}."created_datetime" ;;
  }

  dimension: deleted_by {
    type: string
    sql: ${TABLE}."deleted_by" ;;
  }

  dimension_group: deleted_datetime {
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
    sql: ${TABLE}."deleted_datetime" ;;
  }

  dimension: document_action_id {
    type: number
    hidden: no
    sql: ${TABLE}."document_action_id" ;;
  }

  dimension: document_category {
    type: string
    hidden: yes
    sql: ${TABLE}."document_category" ;;
  }

  dimension: document_class {
    type: string
    description: "The high level description of the document e.g. 'LETTER'"
    sql: ${TABLE}."document_class" ;;
  }

  dimension: document_error_reason {
    type: string
    description: "The error reason given, if an error occurred"
    sql: ${TABLE}."document_error_reason" ;;
  }

  dimension: document_id {
    type: number
    hidden: yes
    sql: ${TABLE}."document_id" ;;
  }

  dimension: document_pre_class {
    type: string
    hidden: yes
    sql: ${TABLE}."document_pre_class" ;;
  }

  dimension: document_sub_class {
    type: string
    description: "The second order description of the document e.g. 'LETTER-PATIENTCORRESPONDENCE'"
    sql: ${TABLE}."document_sub_class" ;;
  }

  dimension: erroryn {
    type: string
    description: "A flag indicating that an error occurred"
    sql: ${TABLE}."erroryn" ;;
  }

  dimension: mobile {
    type: string
    hidden: yes
    sql: ${TABLE}."mobile" ;;
  }

  dimension: note {
    type: string
    description: "The note attached to the document by the Athena user"
    sql: ${TABLE}."note" ;;
  }

  dimension_group: patient_notified_datetime {
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
    sql: ${TABLE}."patient_notified_datetime" ;;
  }

  dimension: priority {
    type: string
    description: "The priority number of the document action"
    sql: ${TABLE}."priority" ;;
  }

  dimension: send_fax_unique_id {
    type: string
    hidden: yes
    sql: ${TABLE}."send_fax_unique_id" ;;
  }

  dimension: status {
    type: string
    description: "The current status of the document action e.g. 'SUBMITTED'"
    sql: ${TABLE}."status" ;;
  }

  dimension: system_key {
    type: string
    description: "The description of the document action e.g. 'DOCUMENT_REOPEN'"
    sql: ${TABLE}."system_key" ;;
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

  measure: count {
    type: count
    drill_fields: [id]
  }
}
