view: athena_patientmedication_prescriptions {
  sql_table_name: athena.patientmedication_prescriptions ;;
  view_label: "Athena Prescription Details"
  drill_fields: [id]

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

  dimension_group: administered_expiration {
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
    sql: ${TABLE}."administered_expiration_date" ;;
  }

  dimension: administered_yn {
    type: string
    group_label: "Prescription Details"
    sql: ${TABLE}."administered_yn" ;;
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
    group_label: "User Actions"
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

  dimension: deactivation_reason {
    type: string
    hidden: yes
    sql: ${TABLE}."deactivation_reason" ;;
  }

  dimension_group: deleted_datetime {
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
    sql: ${TABLE}."deleted_datetime" ;;
  }

  dimension: dispensed_yn {
    type: string
    group_label: "Prescription Details"
    sql: ${TABLE}."dispensed_yn" ;;
  }

  dimension: display_dosage_units {
    type: string
    hidden: yes
    group_label: "Prescription Details"
    sql: ${TABLE}."display_dosage_units" ;;
  }

  dimension: document_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."document_id" ;;
  }

  dimension: dosage_action {
    type: string
    group_label: "Prescription Details"
    sql: ${TABLE}."dosage_action" ;;
  }

  dimension: dosage_form {
    type: string
    group_label: "Prescription Details"
    sql: ${TABLE}."dosage_form" ;;
  }

  dimension: dosage_quantity {
    type: number
    hidden: yes
    group_label: "Prescription Details"
    sql: ${TABLE}."dosage_quantity" ;;
  }

  dimension: dosage_route {
    type: string
    hidden: yes
    group_label: "Prescription Details"
    sql: ${TABLE}."dosage_route" ;;
  }

  dimension: frequency {
    type: string
    hidden: yes
    group_label: "Prescription Details"
    sql: ${TABLE}."frequency" ;;
  }

  dimension_group: med_administered_datetime {
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
    sql: ${TABLE}."med_administered_datetime" ;;
  }

  dimension: medication_type {
    type: string
    hidden: yes
    group_label: "Prescription Details"
    sql: ${TABLE}."medication_type" ;;
  }

  dimension: patient_medication_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."patient_medication_id" ;;
  }

  dimension: prescribed_yn {
    type: string
    group_label: "Prescription Details"
    sql: ${TABLE}."prescribed_yn" ;;
  }

  dimension: prescription_fill_quantity {
    type: number
    hidden: yes
    group_label: "Prescription Details"
    sql: ${TABLE}."prescription_fill_quantity" ;;
  }

  dimension: sig {
    type: string
    hidden: yes
    group_label: "Prescription Details"
    sql: ${TABLE}."sig" ;;
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
    sql: ${TABLE}."start_date" ;;
  }

  dimension_group: stop {
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
    sql: ${TABLE}."stop_date" ;;
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

  dimension: prescriptions_written_on_scene {
    description: "Identifies new first-time prescription/s written on-scene"
    type: yesno
    hidden: yes
    sql:  upper(${athena_document_prescriptions.document_subclass}) = 'PRESCRIPTION_NEW'
          AND ${prescribed_yn} = 'Y' AND upper(${athena_document_prescriptions.status}) != 'DELETED';;
  }

  measure: count_appointments_with_prescriptions {
    description: "Count of appointments with prescriptions written on-scene"
    type: count_distinct
    sql: ${athena_clinicalencounter.clinical_encounter_id};;
    filters: [prescriptions_written_on_scene: "yes"]
    group_label: "Medication Appointment Counts"
  }

  measure: count_medications_prescribed {
    description: "Count of unique prescription written on-scene"
    type: count_distinct
    sql: ${document_id};;
    filters: {
      field: prescriptions_written_on_scene
      value: "yes"
    }
    group_label: "Prescription Counts"
  }

  dimension: prescriptions_administered_on_scene {
    label: "Medications Administered On-Scene"
    description: "Identifies medications administered on-scene"
    type: yesno
    hidden: yes
    sql:  ${administered_yn} = 'Y' AND upper(${athena_document_prescriptions.status}) != 'DELETED';;
  }

  measure: count_appointments_with_administered_medications {
    description: "Count of appointments with medications administered on-scene"
    type: count_distinct
    sql: ${athena_clinicalencounter.clinical_encounter_id};;
    filters: [prescriptions_administered_on_scene: "yes"]
    group_label: "Medication Appointment Counts"
  }

  dimension: prescriptions_dispensed {
    description: "Identifies medications dispensed"
    type: yesno
    hidden: yes
    sql:  ${dispensed_yn} = 'Y' AND upper(${athena_document_prescriptions.status}) != 'DELETED';;
  }

  measure: count_appointments_with_dispensed_medications {
    description: "Count of appointments with medications dispensed on-scene"
    type: count_distinct
    sql: ${athena_clinicalencounter.clinical_encounter_id};;
    filters: [prescriptions_dispensed: "yes"]
    group_label: "Medication Appointment Counts"
  }

  dimension: medications_prescribed_or_administered_or_dispensed {
    description: "Identifies medications prescribed, administered, or dispensed"
    type: yesno
    hidden: yes
    sql:  ((${prescribed_yn} = 'Y' AND ${athena_document_prescriptions.document_subclass} = 'PRESCRIPTION_NEW')
        OR ${administered_yn} = 'Y'
        OR ${dispensed_yn} = 'Y')
      AND upper(${athena_document_prescriptions.status}) != 'DELETED';;
  }

  measure: count_appointments_with_prescribed_or_administered_or_dispensed_medications {
    description: "Count of appointments with medicatins prescribed, administered, or dispensed"
    type: count_distinct
    sql: ${athena_clinicalencounter.clinical_encounter_id};;
    filters: [medications_prescribed_or_administered_or_dispensed: "yes"]
    group_label: "Medication Appointment Counts"
  }



  measure: count {
    type: count
    drill_fields: [id]
  }
}
