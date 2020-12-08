view: collective_medical_first_major_class_admit_date_post_visit {
  view_label: "Collective Medical First Emergency Admit Date Post Visit"
  sql_table_name: (select * from collective_medical.first_major_class_admit_date_post_visit where lower(major_class) = 'emergency');;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
    group_label: "Ids"
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: dh_patient_id {
    type: number
    sql: ${TABLE}."dh_patient_id" ;;
    group_label: "Ids"
  }

  dimension_group: first_admit_post_visit {
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
    sql: ${TABLE}."first_admit_post_visit" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
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

  measure: count {
    type: count
    drill_fields: [id]
  }

  # dimension: 12_hour_first_admit_inpatient {
  #   description: "First Inpatient admittance recorded by Collective Medical within 12 hours of the DH care request on-scene date"
  #   type: yesno
  #   sql: ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 12 and EXTRACT(EPOCH FROM ${first_admit_post_visit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  #   group_label: "Inpatient First Admittance Intervals"
  # }

  # dimension: 24_hour_first_admit_inpatient {
  #   description: "First Inpatient admittance recorded by Collective Medical within 24 hours of the DH care request on-scene date"
  #   type: yesno
  #   sql: ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 24 and EXTRACT(EPOCH FROM ${first_admit_post_visit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  #   group_label: "Inpatient First Admittance Intervals"
  # }

  dimension: 12_hour_first_admit_emergency {
    description: "First Emergency admittance recorded by Collective Medical within 12 hours of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 12 and EXTRACT(EPOCH FROM ${first_admit_post_visit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency';;
    group_label: "Emergency First Admittance Intervals"
  }

  # dimension: 3_day_first_admit_inpatient {
  #   description: "First Inpatient admittance recorded by Collective Medical within 3 days of the DH care request on-scene date"
  #   type: yesno
  #   sql: ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 72 and EXTRACT(EPOCH FROM ${first_admit_post_visit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  #   group_label: "Inpatient First Admittance Intervals"
  # }

  # dimension: 3_day_first_admit_observation {
  #   description: "First Observation admittance recorded by Collective Medical within 3 days of the DH care request on-scene date"
  #   type: yesno
  #   sql: ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 72 and EXTRACT(EPOCH FROM ${first_admit_post_visit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'observation';;
  #   group_label: "Observation First Admittance Intervals"
  # }

  dimension: 3_day_first_admit_emergency {
    description: "First Emergency admittance recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 72 and EXTRACT(EPOCH FROM ${first_admit_post_visit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency';;
    group_label: "Emergency First Admittance Intervals"
  }

  dimension: 7_day_first_admit_emergency {
    description: "First Emergency admittance recorded by Collective Medical within 7 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 168 and EXTRACT(EPOCH FROM ${first_admit_post_visit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency';;
    group_label: "Emergency First Admittance Intervals"
  }

  # dimension: 14_day_first_admit_inpatient {
  #   description: "First Inpatient admittance recorded by Collective Medical within 14 days of the DH care request on-scene date"
  #   type: yesno
  #   sql: ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 336 and EXTRACT(EPOCH FROM ${first_admit_post_visit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  #   group_label: "Inpatient First Admittance Intervals"
  # }

  # dimension: 14_day_first_admit_observation {
  #   description: "First Observation admittance recorded by Collective Medical within 14 days of the DH care request on-scene date"
  #   type: yesno
  #   sql: ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 336 and EXTRACT(EPOCH FROM ${first_admit_post_visit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and  lower(${major_class}) = 'observation';;
  #   group_label: "Observation First Admittance Intervals"
  # }

  dimension: 14_day_first_admit_emergency {
    description: "First Emergency admittance recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 336 and EXTRACT(EPOCH FROM ${first_admit_post_visit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency';;
    group_label: "Emergency First Admittance Intervals"
  }

  # dimension: 30_day_first_admit_inpatient {
  #   description: "First Inpatient admittance recorded by Collective Medical within 30 days of the DH care request on-scene date"
  #   type: yesno
  #   sql: ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 720 and EXTRACT(EPOCH FROM ${first_admit_post_visit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  #   group_label: "Inpatient First Admittance Intervals"
  # }

  # dimension: 30_day_first_admit_observation {
  #   description: "First Observation admittance recorded by Collective Medical within 30 days of the DH care request on-scene date"
  #   type: yesno
  #   sql: ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 720 and EXTRACT(EPOCH FROM ${first_admit_post_visit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and  lower(${major_class}) = 'observation';;
  #   group_label: "Observation First Admittance Intervals"
  # }

  dimension: 30_day_first_admit_emergency {
    description: "First Emergency admittance recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 720 and EXTRACT(EPOCH FROM ${first_admit_post_visit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and  lower(${major_class}) = 'emergency';;
    group_label: "Emergency First Admittance Intervals"
  }

  # measure: count_12_hour_first_admit_inpatient {
  #   description: "Count First Inpatient admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
  #   type: count_distinct
  #   sql: ${care_request_flat.care_request_id} ;;
  #   filters: {
  #     field: 12_hour_first_admit_inpatient
  #     value: "yes"
  #   }
  #   group_label: "Inpatient First Admittance Intervals"
  # }

  measure: count_12_hour_first_admit_emergency {
    description: "Count First Emergency admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 12_hour_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
  }

  # measure: count_24_hour_first_admit_inpatient {
  #   description: "Count First Inpatient admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
  #   type: count_distinct
  #   sql: ${care_request_flat.care_request_id}  ;;
  #   filters: {
  #     field: 24_hour_first_admit_inpatient
  #     value: "yes"
  #   }
  #   group_label: "Inpatient First Admittance Intervals"
  # }

  # measure: count_3_day_first_admit_inpatient {
  #   description: "Count First Inpatient admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
  #   type: count_distinct
  #   sql: ${care_request_flat.care_request_id} ;;
  #   filters: {
  #     field: 3_day_first_admit_inpatient
  #     value: "yes"
  #   }
  #   group_label: "Inpatient First Admittance Intervals"
  # }

  # measure: count_3_day_first_admit_observation {
  #   description: "Count First Observation admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
  #   type: count_distinct
  #   sql: ${care_request_flat.care_request_id}  ;;
  #   filters: {
  #     field: 3_day_first_admit_observation
  #     value: "yes"
  #   }
  #   group_label: "Observation First Admittance Intervals"
  # }

  measure: count_3_day_first_admit_emergency {
    description: "Count First Emergency admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 3_day_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
  }

  measure: count_7_day_first_admit_emergency {
    description: "Count First Emergency admittances recorded by Collective Medical within 7 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 7_day_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
  }

  # measure: count_14_day_first_admit_inpatient {
  #   description: "Count First Inpatient admittances recorded by Collective Medical within 14 days of the DH care request on-scene date"
  #   type: count_distinct
  #   sql: ${care_request_flat.care_request_id}  ;;
  #   filters: {
  #     field: 14_day_first_admit_inpatient
  #     value: "yes"
  #   }
  #   group_label: "Inpatient First Admittance Intervals"
  # }

  # measure: count_14_day_first_admit_observation {
  #   description: "Count First Observation admittances recorded by Collective Medical within 14 days of the DH care request on-scene date"
  #   type: count_distinct
  #   sql: ${care_request_flat.care_request_id}  ;;
  #   filters: {
  #     field: 14_day_first_admit_observation
  #     value: "yes"
  #   }
  #   group_label: "Observation First Admittance Intervals"
  # }

  measure: count_14_day_first_admit_emergency {
    description: "Count First Emergency admittances recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 14_day_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
  }

  # measure: count_30_day_first_admit_inpatient {
  #   description: "Count First Inpatient admittances recorded by Collective Medical within 30 days of the DH care request on-scene date"
  #   type: count_distinct
  #   sql: ${care_request_flat.care_request_id}  ;;
  #   filters: {
  #     field: 30_day_first_admit_inpatient
  #     value: "yes"
  #   }
  #   group_label: "Inpatient First Admittance Intervals"
  # }

  # measure: count_30_day_first_admit_observation {
  #   description: "Count First Observation admittances recorded by Collective Medical within 30 days of the DH care request on-scene date"
  #   type: count_distinct
  #   sql: ${care_request_flat.care_request_id}  ;;
  #   filters: {
  #     field: 30_day_first_admit_observation
  #     value: "yes"
  #   }
  #   group_label: "Observation First Admittance Intervals"
  # }

  measure: count_30_day_first_admit_emergency {
    description: "Count First Emergency admittances recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 30_day_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
  }


  dimension: 30day_emergency_admittance_framework {
    description: "Categorizes the first recorded Emergency admittance by day wihtin the first 30 days from the DH on-scene date"
    type: string
    sql: CASE WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 24 and lower(${major_class}) = 'emergency' THEN '01'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 48 and lower(${major_class}) = 'emergency' THEN '02'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 72 and lower(${major_class}) = 'emergency' THEN '03'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 96 and lower(${major_class}) = 'emergency' THEN '04'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 120 and lower(${major_class}) = 'emergency' THEN '05'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 144 and lower(${major_class}) = 'emergency' THEN '06'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 168 and lower(${major_class}) = 'emergency' THEN '07'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 192 and lower(${major_class}) = 'emergency' THEN '08'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 216 and lower(${major_class}) = 'emergency' THEN '09'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 240 and lower(${major_class}) = 'emergency' THEN '10'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 264 and lower(${major_class}) = 'emergency' THEN '11'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 288 and lower(${major_class}) = 'emergency' THEN '12'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 312 and lower(${major_class}) = 'emergency' THEN '13'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 336 and lower(${major_class}) = 'emergency' THEN '14'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 360 and lower(${major_class}) = 'emergency' THEN '15'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 384 and lower(${major_class}) = 'emergency' THEN '16'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 408 and lower(${major_class}) = 'emergency' THEN '17'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 432 and lower(${major_class}) = 'emergency' THEN '18'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 456 and lower(${major_class}) = 'emergency' THEN '19'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 480 and lower(${major_class}) = 'emergency' THEN '20'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 504 and lower(${major_class}) = 'emergency' THEN '21'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 528 and lower(${major_class}) = 'emergency' THEN '22'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 552 and lower(${major_class}) = 'emergency' THEN '23'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 576 and lower(${major_class}) = 'emergency' THEN '24'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 600 and lower(${major_class}) = 'emergency' THEN '25'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 624 and lower(${major_class}) = 'emergency' THEN '26'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 648 and lower(${major_class}) = 'emergency' THEN '27'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 672 and lower(${major_class}) = 'emergency' THEN '28'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 696 and lower(${major_class}) = 'emergency' THEN '29'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 720 and lower(${major_class}) = 'emergency' THEN '30'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) > 720 and lower(${major_class}) = 'emergency' THEN 'Greater then 30 Days'
          ELSE NULL
          END
          ;;

    }

#     dimension: 30day_inpatient_admittance_framework {
#       description: "Categorizes the first recorded Inpatient admittance by day wihtin the first 30 days from the DH on-scene date"
#       type: string
#       sql: CASE WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 24 and lower(${major_class}) = 'inpatient' THEN '01'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 48 and lower(${major_class}) = 'inpatient' THEN '02'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 72 and lower(${major_class}) = 'inpatient' THEN '03'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 96 and lower(${major_class}) = 'inpatient' THEN '04'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 120 and lower(${major_class}) = 'inpatient' THEN '05'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 144 and lower(${major_class}) = 'inpatient' THEN '06'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 168 and lower(${major_class}) = 'inpatient' THEN '07'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 192 and lower(${major_class}) = 'inpatient' THEN '08'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 216 and lower(${major_class}) = 'inpatient' THEN '09'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 240 and lower(${major_class}) = 'inpatient' THEN '10'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 264 and lower(${major_class}) = 'inpatient' THEN '11'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 288 and lower(${major_class}) = 'inpatient' THEN '12'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 312 and lower(${major_class}) = 'inpatient' THEN '13'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 336 and lower(${major_class}) = 'inpatient' THEN '14'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 360 and lower(${major_class}) = 'inpatient' THEN '15'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 384 and lower(${major_class}) = 'inpatient' THEN '16'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 408 and lower(${major_class}) = 'inpatient' THEN '17'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 432 and lower(${major_class}) = 'inpatient' THEN '18'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 456 and lower(${major_class}) = 'inpatient' THEN '19'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 480 and lower(${major_class}) = 'inpatient' THEN '20'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 504 and lower(${major_class}) = 'inpatient' THEN '21'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 528 and lower(${major_class}) = 'inpatient' THEN '22'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 552 and lower(${major_class}) = 'inpatient' THEN '23'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 576 and lower(${major_class}) = 'inpatient' THEN '24'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 600 and lower(${major_class}) = 'inpatient' THEN '25'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 624 and lower(${major_class}) = 'inpatient' THEN '26'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 648 and lower(${major_class}) = 'inpatient' THEN '27'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 672 and lower(${major_class}) = 'inpatient' THEN '28'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 696 and lower(${major_class}) = 'inpatient' THEN '29'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 720 and lower(${major_class}) = 'inpatient' THEN '30'
#           WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) > 720 and lower(${major_class}) = 'inpatient' THEN 'Greater then 30 Days'
#           ELSE NULL
#           END
#           ;;

#       }

}
