view: collective_medical {
  view_label: "Collective Medical Patient Level"
  sql_table_name: collective_medical.collective_medical ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
    group_label: "Ids"
  }

  dimension: 12m_ed_visit_count {
    type: number
    sql: ${TABLE}."12m_ed_visit_count" ;;
  }

  dimension: 3m_ed_visit_count {
    type: number
    sql: ${TABLE}."3m_ed_visit_count" ;;
  }

  dimension: 6m_ed_visit_count {
    type: number
    sql: ${TABLE}."6m_ed_visit_count" ;;
  }

  dimension: __batch_id {
    type: string
    hidden: yes
    sql: ${TABLE}."__batch_id" ;;
    group_label: "Ids"
  }

  dimension: __discharge_date_updated {
    type: yesno
    hidden: yes
    sql: ${TABLE}."__discharge_date_updated" ;;
  }

  dimension: __from_file {
    type: string
    hidden: yes
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: __processed_date {
    type: string
    hidden: yes
    sql: ${TABLE}."__processed_date" ;;
  }

  dimension_group: admit {
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
    sql: ${TABLE}.admit_date AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: admitted_ip {
    type: yesno
    description: "Admitted In-Patient - patient admitted directly to inpatient from preceding emergency admission"
    sql: ${TABLE}."admitted_ip" ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}."patient_id" ;;
    group_label: "Ids"
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
    sql: ${TABLE}."created_at" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: diagnoses {
    type: string
    sql: ${TABLE}."diagnoses" ;;
  }

  dimension: diagnosis_codes {
    type: string
    sql: ${TABLE}."diagnosis_codes" ;;
  }

  measure: diagnosis_codes_concatenated {
    description: "Concatenated Diagnosis Codes"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${diagnosis_codes}), ' | ') ;;
  }

  dimension_group: discharge {
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
    sql: ${TABLE}.discharge_date AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: encounter_account_number {
    type: string
    sql: ${TABLE}."encounter_account_number" ;;
  }

  dimension: encounter_chief_complaint {
    type: string
    sql: ${TABLE}."encounter_chief_complaint" ;;
  }

  dimension: encounter_discharge_disposition {
    type: string
    sql: ${TABLE}."encounter_discharge_disposition" ;;
  }

  measure: discharge_dispositions_concatenated {
    description: "Concatenated Encounter Discharge Dispositions"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${encounter_discharge_disposition}), ' | ') ;;
  }

  dimension: facility_hl7_identifier {
    type: string
    sql: ${TABLE}."facility_hl7_identifier" ;;
  }

  dimension: major_class {
    type: string
    description: "Emergency, Inpatient, or Observation"
    sql: ${TABLE}."major_class" ;;
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
    sql: ${TABLE}."updated_at" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: visit_facility {
    type: string
    sql: ${TABLE}."visit_facility" ;;
  }

  dimension: visit_type {
    type: string
    description: "The reason for the visit: Surgery, Oncology, General Medicine, etc."
    sql: ${TABLE}."visit_type" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }

  # dimension: 12_hour_cm_admit_inpatient {
  #   description: "Inpatient admittance recorded by Collective Medical within 12 hours of the DH care request on-scene date"
  #   type: yesno
  #   sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 12 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  #   group_label: "Inpatient Admittance Intervals"
  # }

  # dimension: 24_hour_cm_admit_inpatient {
  #   description: "Inpatient admittance recorded by Collective Medical within 24 hours of the DH care request on-scene date"
  #   type: yesno
  #   sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 24 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  #   group_label: "Inpatient Admittance Intervals"
  # }

  dimension: 24_hour_first_admit_inpatient_emergency {
    label: "24 Hour First Admit Hospitalization"
    description: "First Inpatient Emergency admittance recorded by Collective Medical within 24 hours of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 24 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' and ${admitted_ip};;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 12_hour_cm_admit_emergency {
    description: "Emergency admittance recorded by Collective Medical within 12 hours of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 12 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency';;
    group_label: "Emergency Admittance Intervals"
  }

  # dimension: 3_day_cm_admit_inpatient {
  #   description: "Inpatient admittance recorded by Collective Medical within 3 days of the DH care request on-scene date"
  #   type: yesno
  #   sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 72 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  #   group_label: "Inpatient Admittance Intervals"
  # }

  dimension: 3_day_first_admit_inpatient_emergency {
    label: "3 Day First Admit Hospitalization"
    description: "First Inpatient Emergency admittance recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 72 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' and ${admitted_ip} = true;;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 3_day_cm_admit_observation {
    description: "Observation admittance recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 72 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'observation';;
    group_label: "Observation Admittance Intervals"
  }

  dimension: 3_day_cm_admit_emergency {
    description: "Emergency admittance recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 72 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency';;
    group_label: "Emergency Admittance Intervals"
  }

  # dimension: 14_day_cm_admit_inpatient {
  #   description: "Inpatient admittance recorded by Collective Medical within 14 days of the DH care request on-scene date"
  #   type: yesno
  #   sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 336 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  #   group_label: "Inpatient Admittance Intervals"
  # }

  dimension: 14_day_first_admit_inpatient_emergency {
    label: "14 Day First Admit Hospitalization"
    description: "First Inpatient Emergency admittance recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 336 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' and ${admitted_ip};;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 14_day_cm_admit_observation {
    description: "Observation admittance recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 336 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and  lower(${major_class}) = 'observation';;
    group_label: "Observation Admittance Intervals"
  }

  dimension: 14_day_cm_admit_emergency {
    description: "Emergency admittance recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 336 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency';;
    group_label: "Emergency Admittance Intervals"
  }

  # dimension: 30_day_cm_admit_inpatient {
  #   description: "Inpatient admittance recorded by Collective Medical within 30 days of the DH care request on-scene date"
  #   type: yesno
  #   sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 720 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  #   group_label: "Inpatient Admittance Intervals"
  # }

  dimension: 30_day_first_admit_inpatient_emergency {
    label: "30 Day First Admit Hospitalization"
    description: "First Inpatient Emergency admittance recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 720 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and  lower(${major_class}) = 'emergency' and ${admitted_ip};;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 30_day_cm_admit_observation {
    description: "Observation admittance recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 720 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and  lower(${major_class}) = 'observation';;
    group_label: "Observation Admittance Intervals"
  }

  dimension: 30_day_cm_admit_emergency {
        description: "Emergency admittance recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 720 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and  lower(${major_class}) = 'emergency';;
    group_label: "Emergency Admittance Intervals"
  }

  measure: count_24_hour_cm_admit_inpatient {
    label: "Count 24 Hour CM Admit Hospitalization"
    description: "Count Inpatient Emergency admittances recorded by Collective Medical within 24 hours of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id} ;;
    filters: {
      field: 24_hour_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  measure: count_12_hour_cm_admit_emergency {
    description: "Count Emergency admittances recorded by Collective Medical within 12 hours of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 12_hour_cm_admit_emergency
      value: "yes"
    }
    group_label: "Emergency Admittance Intervals"
  }

 measure: count_3_day_cm_admit_inpatient {
    label: "Count 3 Day CM Admit  Hospitalization"
    description: "Count Inpatient Emergency admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id} ;;
    filters: {
      field: 3_day_first_admit_inpatient_emergency
      value: "yes"
    }
  group_label: "Inpatient Emergency Admittance Intervals"
  }

  measure: count_3_day_cm_admit_observation {
    description: "Count Observation admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 3_day_cm_admit_observation
      value: "yes"
    }
    group_label: "Observation Admittance Intervals"
  }

    measure: count_3_day_cm_admit_emergency {
      description: "Count Emergency admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
      type: count_distinct
      sql: ${care_request_flat.care_request_id}  ;;
      filters: {
        field: 3_day_cm_admit_emergency
        value: "yes"
      }
      group_label: "Emergency Admittance Intervals"
  }

  measure: count_14_day_cm_admit_inpatient {
    label: "Count 14 Day CM Admit  Hospitalization"
    description: "Count Inpatient Emergency admittances recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 14_day_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  measure: count_14_day_cm_admit_observation {
    description: "Count Observation admittances recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 14_day_cm_admit_observation
      value: "yes"
    }
    group_label: "Observation Admittance Intervals"
  }

  measure: count_14_day_cm_admit_emergency {
    description: "Count Emergency admittances recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 14_day_cm_admit_emergency
      value: "yes"
    }
    group_label: "Emergency Admittance Intervals"
  }

  measure: count_30_day_cm_admit_inpatient {
    label: "Count 30 Day CM Admit  Hospitalization"
    description: "Count Inpatient Emergency admittances recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 30_day_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  measure: count_30_day_cm_admit_observation {
    description: "Count Observation admittances recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 30_day_cm_admit_observation
      value: "yes"
    }
    group_label: "Observation Admittance Intervals"
  }

  measure: count_30_day_cm_admit_emergency {
    description: "Count Emergency admittances recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 30_day_cm_admit_emergency
      value: "yes"
    }
    group_label: "Emergency Admittance Intervals"
  }

  dimension: inpatient_admit_within_24_hours_of_emergency_admit {
    description: "Identifies care requests where an emergency admit occurs within 30 days of a dh visit and a CM Inpatient admit occurrs within 24 hours of a CM emergency admit"
    type: yesno
    sql: ${collective_medical_admit_emergency_and_inpatient_within_24_hours.care_request_id} = care_requests.id ;;
  }


#   measure: count_er_admits {
#     type: count_distinct
#
#   }




}
