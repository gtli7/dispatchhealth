view: collective_medical_first_emergency_inpatient_admit_date_post_visit {
  view_label: "Collective Medical First Hospitalization Admit Date Post Visit"
  sql_table_name: collective_medical.first_emergency_inpatient_admit_date_post_visit ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: admitted_ip {
    type: yesno
    sql: ${TABLE}."admitted_ip" ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
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

  dimension: dh_patient_id {
    type: number
    sql: ${TABLE}."dh_patient_id" ;;
  }

  dimension_group: first_emergency_ip_admit {
    label: "First Hospitalization Admit"
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
    sql: ${TABLE}."first_emergency_ip_admit_date" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: major_class {
    type: string
    sql: ${TABLE}."major_class" ;;
  }

  dimension_group: on_scene {
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
    sql: ${TABLE}."on_scene_date" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
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

  dimension: 24_hour_first_admit_inpatient_emergency {
    label: "24 Hour First Admit Hospitalization"
    description: "First Inpatient Emergency admittance recorded by Collective Medical within 24 hours of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 24 and EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' and ${admitted_ip};;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 3_day_first_admit_inpatient_emergency {
    label: "3 Day First Admit Hospitalization"
    description: "First Inpatient Emergency admittance recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 72 and EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' and ${admitted_ip};;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 7_day_first_admit_inpatient_emergency {
    label: "7 Day First Admit Hospitalization"
    description: "First Inpatient Emergency admittance recorded by Collective Medical within 7 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 168 and EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' and ${admitted_ip};;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 14_day_first_admit_inpatient_emergency {
    label: "14 Day First Admit Hospitalization"
    description: "First Inpatient Emergency admittance recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 336 and EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' and ${admitted_ip};;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 30_day_first_admit_inpatient_emergency {
    label: "30 Day First Admit Hospitalization"
    description: "First Inpatient Emergency admittance recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 720 and EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and  lower(${major_class}) = 'emergency' and ${admitted_ip};;
    group_label: "Inpatient Emergency Admittance Intervals"
  }


  measure: count_24_hour_first_admit_inpatient_emergency {
    label: "Count 24 Hour First Admit Hospitalization"
    description: "Count First Inpatient Emergency admittances recorded by Collective Medical within 24 days of the DH care request on-scene date"
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
    description: "Count First Inpatient Emergency admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
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
    description: "Count First Inpatient Emergency admittances recorded by Collective Medical within 7 days of the DH care request on-scene date"
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
    description: "Count First Inpatient Emergency admittances recorded by Collective Medical within 14 days of the DH care request on-scene date"
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
    description: "Count First Inpatient Emergency admittances recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 30_day_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
  }


  measure: count {
    type: count
    drill_fields: [id]
  }

  dimension: 30day_inpatient_emergency_admittance_framework {
    label: "30 Day Hosptialization Framework"
    description: "Categorizes the first recorded Inpatient admittance by day wihtin the first 30 days from the DH on-scene date"
    type: string
    sql: CASE WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 24 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '01'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 48 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '02'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 72 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '03'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 96 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '04'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 120 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '05'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 144 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '06'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 168 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '07'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 192 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '08'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 216 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '09'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 240 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '10'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 264 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '11'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 288 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '12'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 312 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '13'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 336 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '14'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 360 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '15'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 384 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '16'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 408 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '17'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 432 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '18'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 456 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '19'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 480 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '20'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 504 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '21'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 528 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '22'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 552 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '23'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 576 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '24'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 600 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '25'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 624 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '26'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 648 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '27'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 672 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '28'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 696 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '29'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 720 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN '30'
          WHEN ((EXTRACT(EPOCH FROM ${first_emergency_ip_admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) > 720 and lower(${major_class}) = 'emergency' and ${admitted_ip} THEN 'Greater then 30 Days'
          ELSE NULL
          END
          ;;

    }

}
