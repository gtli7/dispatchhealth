view: adt_first_encounter_report {
  sql_table_name: external_adt_merged.adt_first_encounter_report ;;

  dimension_group: care_request_begin {
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
    sql: ${TABLE}."care_request_begin_time" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
  }

  dimension: cr_to_er_diff {
    type: string
    sql: ${TABLE}."cr_to_er_diff" ;;
  }

  dimension: cr_to_hosp_diff {
    type: string
    sql: ${TABLE}."cr_to_hosp_diff" ;;
  }

  dimension: dh_patient_id {
    type: number
    sql: ${TABLE}."dh_patient_id" ;;
  }

  dimension_group: er_admit {
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
    sql: ${TABLE}."er_admit_time" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: er_data_source {
    type: string
    sql: ${TABLE}."er_data_source" ;;
  }

  dimension: er_diagnoses {
    type: string
    sql: ${TABLE}."er_diagnoses" ;;
  }

  dimension: er_facility_name {
    type: string
    sql: ${TABLE}."er_facility_name" ;;
  }

  dimension: first_er_encounter_id {
    type: string
    sql: ${TABLE}."first_er_encounter_id" ;;
  }

  dimension: first_er_is_hospitalization {
    type: yesno
    sql: ${TABLE}."first_er_is_hospitalization" ;;
  }

  dimension: first_hosp_encounter_id {
    type: string
    sql: ${TABLE}."first_hosp_encounter_id" ;;
  }

  dimension_group: hosp_admit {
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
    sql: ${TABLE}."hosp_admit_time" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: hosp_data_source {
    type: string
    sql: ${TABLE}."hosp_data_source" ;;
  }

  dimension: hosp_diagnoses {
    type: string
    sql: ${TABLE}."hosp_diagnoses" ;;
  }

  dimension: hosp_facility_name {
    type: string
    sql: ${TABLE}."hosp_facility_name" ;;
  }

  measure: count {
    type: count
    drill_fields: [er_facility_name, hosp_facility_name]
  }

  dimension: 12_hour_first_admit_emergency {
    description: "First Emergency admittance identified within 12 hours of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 12;;
    group_label: "Emergency First Admittance Intervals"
  }

  dimension: 3_day_first_admit_emergency {
    description: "First Emergency admittance identified within 3 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 72;;
    group_label: "Emergency First Admittance Intervals"
  }

  dimension: 7_day_first_admit_emergency {
    description: "First Emergency admittance identified within 7 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 168;;
    group_label: "Emergency First Admittance Intervals"
  }

  dimension: 14_day_first_admit_emergency {
    description: "First Emergency admittance identified within 14 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 336;;
    group_label: "Emergency First Admittance Intervals"
  }

  dimension: 30_day_first_admit_emergency {
    description: "First Emergency admittance identified within 30 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 720;;
    group_label: "Emergency First Admittance Intervals"
  }

  measure: count_12_hour_first_admit_emergency {
    description: "Count First Emergency admittances identified within 12 hours of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 12_hour_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
  }

  measure: count_3_day_first_admit_emergency {
    description: "Count First Emergency admittances identified within 3 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 3_day_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
  }

  measure: count_7_day_first_admit_emergency {
    description: "Count First Emergency admittances identified within 7 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 7_day_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
  }


  measure: count_14_day_first_admit_emergency {
    description: "Count First Emergency admittances identified within 14 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 14_day_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
  }

  measure: count_30_day_first_admit_emergency {
    description: "Count First Emergency admittances identified within 14 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 30_day_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
  }

  dimension: 24_hour_first_admit_inpatient_emergency {
    label: "24 Hour First Admit Hospitalization"
    description: "First Hospitalization admittance (transer from Emergency) identified within 24 hours of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 24 ;;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 3_day_first_admit_inpatient_emergency {
    label: "3 Day First Admit Hospitalization"
    description: "First Hospitalization admittance (transer from Emergency) identified within 3 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 72 ;;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 7_day_first_admit_inpatient_emergency {
    label: "7 Day First Admit Hospitalization"
    description: "First Hospitalization admittance (transer from Emergency) identified within 7 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 168 ;;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 14_day_first_admit_inpatient_emergency {
    label: "14 Day First Admit Hospitalization"
    description: "First Hospitalization admittance (transer from Emergency) identified within 14 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 336 ;;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 30_day_first_admit_inpatient_emergency {
    label: "30 Day First Admit Hospitalization"
    description: "First Hospitalization admittance (transer from Emergency) identified within 30 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 720 ;;
    group_label: "Inpatient Emergency Admittance Intervals"
  }


  measure: count_24_hour_first_admit_inpatient_emergency {
    label: "Count 24 Hour First Admit Hospitalization"
    description: "Count First Hospitalization admittance (transer from Emergency) identified within 24 hours of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 24_hour_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  measure: count_3_day_first_admit_inpatient_emergency {
    label: "Count 3 Day First Admit Hospitalization"
    description: "Count First Hospitalization admittance (transer from Emergency) identified within 3 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_request_flat.care_request_id} ;;
    filters: {
      field: 3_day_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  measure: count_7_day_first_admit_inpatient_emergency {
    label: "Count 7 Day First Admit Hospitalization"
    description: "Count First Hospitalization admittance (transer from Emergency) identified within 7 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_request_flat.care_request_id} ;;
    filters: {
      field: 7_day_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  measure: count_14_day_first_admit_inpatient_emergency {
    label: "Count 14 Day First Admit Hospitalization"
    description: "Count First Hospitalization admittance (transer from Emergency) identified within 14 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 14_day_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  measure: count_30_day_first_admit_inpatient_emergency {
    label: "Count 30 Day First Admit Hospitalization"
    description: "Count First Hospitalization admittance (transer from Emergency) identified within 30 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 30_day_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
  }

}
