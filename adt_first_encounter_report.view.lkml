view: adt_first_encounter_report {
  sql_table_name: adt_merged.adt_first_encounter_report ;;
  view_label: "Bouncebacks All Cause"
# Pending view updates. Consider changing all measures using count_distinct sql to use the adt_first_encounter_report.care_request_id.


# Always update active_market_bounceback_data AND active_market_bounceback_go_live_date when any new ADT vendor or market of coverage is added. This, when added as a filter to a report, ensure that only valid data is populated
  # dimension: active_market_bounceback_data {
  #   description: "Flag defining market and time period valid ADT (bunceback) data is avilable for. Settng this flag to 'yes' will ensure the report only populates valid data "
  #   type:  yesno
  #   sql: CASE
  #         WHEN lower(${markets.name_adj}) IN (
  #             'springfield',
  #             'richmond',
  #             'seattle',
  #             'spokane',
  #             'olympia',
  #             'tacoma')
  #           AND ${care_request_flat.complete_date} > '2020/03/01' THEN true
  #         WHEN lower(${markets.name_adj}) IN (
  #             'denver',
  #             'colorado springs')
  #           AND ${care_request_flat.complete_date} > '2020/11/01' THEN true
  #           ELSE false
  #           END

  #           ;;
  # }

  # Add new CORHIO markets once data is available - modify date to when data is available
            # WHEN ${markets.state} IN (
            #   'AZ',
            #   'IN',
            #   'NC',
            #   'OK',
            #   'TX')
            #   AND ${care_request_flat.complete_date} > '2021/05/10' THEN true

  dimension: active_market_bounceback_data {
    description: "Flag defining market and time period valid ADT (bunceback) data is avilable for. Settng this flag to 'yes' will ensure the report only populates valid data "
    type:  yesno
    sql: CASE
          WHEN ${markets.state} IN (
              'WA',
              'MA',
              'VA')
              AND ${care_request_flat.complete_date} > '2020/03/01' THEN true
          WHEN ${markets.state} IN (
              'CO')
              AND ${care_request_flat.complete_date} > '2020/11/01' THEN true
          WHEN ${markets.state} IN (
              'ID',
              'NJ',
              'NV',
              'OR')
              AND ${care_request_flat.complete_date} > '2021/05/10' THEN true

          ELSE false
            END

            ;;
  }


  # dimension: active_market_bounceback_go_live_date {
  #   description: "Go live date for valid data dependent on vendor and market.  "
  #   type: string
  #   sql: CASE
  #         WHEN lower(${markets.name}) IN (
  #             'springfield',
  #             'richmond',
  #             'seattle',
  #             'spokane',
  #             'olympia',
  #             'tacoma')
  #           AND ${care_request_flat.complete_date} > '2020/03/01' THEN '2020/03/01'
  #         WHEN lower(${markets.name}) IN (
  #             'denver',
  #             'colorado springs')
  #           AND ${care_request_flat.complete_date} > '2020/11/01' THEN '2020/11/01'
  #           ELSE NULL
  #           END

  #           ;;
  # }




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
    sql: ${TABLE}."er_facility_names" ;;
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
    sql: ${TABLE}."hosp_facility_names" ;;
  }

  measure: count {
    type: count
    drill_fields: [er_facility_name, hosp_facility_name]
  }

  dimension: 12_hour_first_admit_emergency {
    label: "12 Hour First Emergency Bounceback"
    description: "First Emergency admittance identified within 12 hours of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 12;;
    group_label: "Emergency First Admittance Intervals"
  }

  dimension: 24_hour_first_admit_emergency {
    label: "24 Hour First Emergency Bounceback"
    description: "First Emergency admittance identified within 24 hours of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 24;;
    group_label: "Emergency First Admittance Intervals"
  }

  dimension: 3_day_first_admit_emergency {
    label: "3 Day First Emergency Bounceback"
    description: "First Emergency admittance identified within 3 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 72;;
    group_label: "Emergency First Admittance Intervals"
  }

  dimension: 7_day_first_admit_emergency {
    label: "7 Day First Emergency Bounceback"
    description: "First Emergency admittance identified within 7 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 168;;
    group_label: "Emergency First Admittance Intervals"
  }

  dimension: 14_day_first_admit_emergency {
    label: "14 Day First Emergency Bounceback"
    description: "First Emergency admittance identified within 14 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 336;;
    group_label: "Emergency First Admittance Intervals"
  }

  dimension: 30_day_first_admit_emergency {
    label: "30 Day First Emergency Bounceback"
    description: "First Emergency admittance identified within 30 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_er_diff})/3600 <= 720;;
    group_label: "Emergency First Admittance Intervals"
  }

  measure: count_12_hour_first_admit_emergency {
    label: "Count 12 Hour First Emergency Bounceback"
    description: "Count First Emergency admittances identified within 12 hours of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_requests.id}  ;;
    filters: {
      field: 12_hour_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
    drill_fields: [care_request_flat.detail*,bb_detail*]
  }

  measure: count_24_hour_first_admit_emergency {
    label: "Count 24 Hour First Emergency Bounceback"
    description: "Count First Emergency admittances identified within 24 hours of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_requests.id}  ;;
    filters: {
      field: 24_hour_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
    drill_fields: [care_request_flat.detail*,bb_detail*]
  }

  measure: count_3_day_first_admit_emergency {
    label: "Count 3 Day First Emergency Bounceback"
    description: "Count First Emergency admittances identified within 3 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_requests.id}  ;;
    filters: {
      field: 3_day_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
    drill_fields: [care_request_flat.detail*,bb_detail*]
  }

  measure: count_7_day_first_admit_emergency {
    label: "Count 7 Day First Emergency Bounceback"
    description: "Count First Emergency admittances identified within 7 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_requests.id}  ;;
    filters: {
      field: 7_day_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
    drill_fields: [care_request_flat.detail*,bb_detail*]
  }


  measure: count_14_day_first_admit_emergency {
    label: "Count 14 Day First Emergency Bounceback"
    description: "Count First Emergency admittances identified within 14 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_requests.id}  ;;
    filters: {
      field: 14_day_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
    drill_fields: [care_request_flat.detail*,bb_detail*]
  }

  measure: count_30_day_first_admit_emergency {
    label: "Count 30 Day First Emergency Bounceback"
    description: "Count First Emergency admittances identified within 14 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_requests.id}  ;;
    filters: {
      field: 30_day_first_admit_emergency
      value: "yes"
    }
    group_label: "Emergency First Admittance Intervals"
    drill_fields: [care_request_flat.detail*,bb_detail*]
  }

  dimension: 24_hour_first_admit_inpatient_emergency {
    label: "24 Hour First Hospitalization Bounceback"
    description: "First Hospitalization admittance (transer from Emergency) identified within 24 hours of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_hosp_diff})/3600 <= 24 ;;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 3_day_first_admit_inpatient_emergency {
    label: "3 Day First Hospitalization Bounceback"
    description: "First Hospitalization admittance (transer from Emergency) identified within 3 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_hosp_diff})/3600 <= 72 ;;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 7_day_first_admit_inpatient_emergency {
    label: "7 Day First Hospitalization Bounceback"
    description: "First Hospitalization admittance (transer from Emergency) identified within 7 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_hosp_diff})/3600 <= 168 ;;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 14_day_first_admit_inpatient_emergency {
    label: "14 Day First Hospitalization Bounceback"
    description: "First Hospitalization admittance (transer from Emergency) identified within 14 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_hosp_diff})/3600 <= 336 ;;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 30_day_first_admit_inpatient_emergency {
    label: "30 Day First Hospitalization Bounceback"
    description: "First Hospitalization admittance (transer from Emergency) identified within 30 days of the DH care request on-scene date (3rd party vendor reported)"
    type: yesno
    sql: extract(epoch from ${cr_to_hosp_diff})/3600 <= 720 ;;
    group_label: "Inpatient Emergency Admittance Intervals"
  }

  dimension: 7_day_bb_pct {
    type: number
    hidden: yes
    sql: CASE WHEN ${7_day_first_admit_emergency} OR ${7_day_first_admit_inpatient_emergency} THEN 100
         ELSE 0
        END;;
  }

  measure: 7_day_avg_bounceback_rate {
    description: "Average BB rate (all cause) at 7 days post-visit"
    type: average_distinct
    value_format: "0.0\%"

    sql: ${7_day_bb_pct} ;;
    sql_distinct_key: ${care_requests.id} ;;
    filters: [care_requests.billable_est: "yes", provider_profiles.position: "advanced practice provider"]
    drill_fields: [care_request_flat.detail*,bb_detail*]
  }

  dimension: 30_day_bb_pct {
    type: number
    hidden: yes
    sql: CASE WHEN ${30_day_first_admit_emergency} OR ${30_day_first_admit_inpatient_emergency} THEN 100
         ELSE 0
        END;;
  }

  measure: 30_day_avg_bounceback_rate {
    description: "Average BB rate (all cause) at 30 days post-visit"
    type: average_distinct
    value_format: "0.0\%"

    sql: ${30_day_bb_pct} ;;
    sql_distinct_key: ${care_requests.id} ;;
    filters: [care_requests.billable_est: "yes"]
  }


  measure: count_24_hour_first_admit_inpatient_emergency {
    label: "Count 24 Hour First Hospitalization Bounceback"
    description: "Count First Hospitalization admittance (transer from Emergency) identified within 24 hours of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_requests.id}  ;;
    filters: {
      field: 24_hour_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
    drill_fields: [care_request_flat.detail*,bb_detail*]
  }

  measure: count_3_day_first_admit_inpatient_emergency {
    label: "Count 3 Day First Hospitalization Bounceback"
    description: "Count First Hospitalization admittance (transer from Emergency) identified within 3 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_requests.id} ;;
    filters: {
      field: 3_day_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
    drill_fields: [care_request_flat.detail*,bb_detail*]
  }

  measure: count_7_day_first_admit_inpatient_emergency {
    label: "Count 7 Day First Hospitalization Bounceback"
    description: "Count First Hospitalization admittance (transer from Emergency) identified within 7 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_requests.id} ;;
    filters: {
      field: 7_day_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
    drill_fields: [care_request_flat.detail*,bb_detail*]
  }

  measure: count_14_day_first_admit_inpatient_emergency {
    label: "Count 14 Day First Hospitalization Bounceback"
    description: "Count First Hospitalization admittance (transer from Emergency) identified within 14 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_requests.id}  ;;
    filters: {
      field: 14_day_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
    drill_fields: [care_request_flat.detail*,bb_detail*]
  }

  measure: count_30_day_first_admit_inpatient_emergency {
    label: "Count 30 Day First Hospitalization Bounceback"
    description: "Count First Hospitalization admittance (transer from Emergency) identified within 30 days of the DH care request on-scene date (3rd party vendor reported)"
    type: count_distinct
    sql: ${care_requests.id}  ;;
    filters: {
      field: 30_day_first_admit_inpatient_emergency
      value: "yes"
    }
    group_label: "Inpatient Emergency Admittance Intervals"
    drill_fields: [care_request_flat.detail*,bb_detail*]
  }

  dimension: 1_to_48_hour_cumulative_emergency_admittance_framework {
    label: "1 to 48 Hour Cululative Emergency Bounceback Framework"
    description: "Categorizes the first recorded Emergency admittance by day for the first 30 days from the DH on-scene date"
    type: string
    sql: CASE WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 1 THEN '01 Hour'
    WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 2 THEN '02 Hours'
    WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 3 THEN '03 Hours'
    WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 5 THEN '05 Hours'
    WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 8 THEN '08 Hours'
    WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 12 THEN '12 Hours'
    WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 18 THEN '18 Hours'
    WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 24 THEN '24 Hours'
    WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 36 THEN '36 Hours'
    WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 48 THEN '48 Hours'
    ELSE NULL
    END
    ;;

    }

  dimension: 1_to_48_hour_inclusive_emergency_admittance_framework {
    label: "1 to 48 Hour Inclusive Emergency Bounceback Framework"
    description: "Categorizes the first recorded Emergency admittance by day for the first 30 days from the DH on-scene date"
    type: string
    sql: CASE WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 1 THEN '(01) 1 Hour or Less'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 > 1 AND  extract(epoch from ${cr_to_er_diff})/3600 <= 2 THEN '(02) 1 to 2 Hours'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 > 2 AND  extract(epoch from ${cr_to_er_diff})/3600 <= 3 THEN '(03) 2 to 3 Hours'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 > 3 AND  extract(epoch from ${cr_to_er_diff})/3600 <= 5 THEN '(05) 3 to 5 Hours'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 > 5 AND  extract(epoch from ${cr_to_er_diff})/3600 <= 8 THEN '(08) 5 to 8 Hours'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 > 8 AND  extract(epoch from ${cr_to_er_diff})/3600 <= 12 THEN '(12) 8 to 12 Hours'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 > 12 AND  extract(epoch from ${cr_to_er_diff})/3600 <= 18 THEN '(18) 12 to 18 Hours'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 > 18 AND  extract(epoch from ${cr_to_er_diff})/3600 <= 24 THEN '(24) 18 to 24 Hours'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 > 24 AND  extract(epoch from ${cr_to_er_diff})/3600 <= 36 THEN '(36) 24 to 36 Hours'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 > 36 AND  extract(epoch from ${cr_to_er_diff})/3600 <= 48 THEN '(48) 36 to 48 Hours'
          ELSE NULL
          END
          ;;

    }



  dimension: 30day_emergency_admittance_framework {
    label: "30 Day First Emergency Bounceback Framework"
    description: "Categorizes the first recorded Emergency admittance by day for the first 30 days from the DH on-scene date"
    type: string
    sql: CASE WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 24 THEN '01'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 48 THEN '02'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 72 THEN '03'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 96 THEN '04'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 120 THEN '05'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 144 THEN '06'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 168 THEN '07'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 192 THEN '08'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 216 THEN '09'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 240 THEN '10'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 264 THEN '11'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 288 THEN '12'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 312 THEN '13'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 336 THEN '14'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 360 THEN '15'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 384 THEN '16'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 408 THEN '17'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 432 THEN '18'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 456 THEN '19'
          WHEN  extract(epoch from ${cr_to_er_diff})/3600 <= 480 THEN '20'
          WHEN  extract(epoch from ${cr_to_er_diff})/3600 <= 504 THEN '21'
          WHEN  extract(epoch from ${cr_to_er_diff})/3600 <= 528 THEN '22'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 552 THEN '23'
          WHEN  extract(epoch from ${cr_to_er_diff})/3600 <= 576 THEN '24'
          WHEN  extract(epoch from ${cr_to_er_diff})/3600 <= 600 THEN '25'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 624 THEN '26'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 648 THEN '27'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 672 THEN '28'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 696 THEN '29'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 <= 720 THEN '30'
          WHEN extract(epoch from ${cr_to_er_diff})/3600 > 720 THEN 'Greater then 30 Days'
          ELSE NULL
          END
          ;;

    }
  dimension: 30day_emergency_hospitalization_admittance_framework {
    label: "30 Day First Hospitalization Bounceback Framework"
    description: "Categorizes the first recorded Hospitalization admittance (defined as transfer from Emergency admittance) by day for the first 30 days from the DH on-scene date"
    type: string
    sql: CASE WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 24 THEN '01'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 48 THEN '02'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 72 THEN '03'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 96 THEN '04'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 120 THEN '05'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 144 THEN '06'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 168 THEN '07'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 192 THEN '08'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 216 THEN '09'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 240 THEN '10'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 264 THEN '11'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 288 THEN '12'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 312 THEN '13'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 336 THEN '14'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 360 THEN '15'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 384 THEN '16'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 408 THEN '17'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 432 THEN '18'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 456 THEN '19'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 480 THEN '20'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 504 THEN '21'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 528 THEN '22'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 552 THEN '23'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 576 THEN '24'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 600 THEN '25'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 624 THEN '26'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 648 THEN '27'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 672 THEN '28'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 696 THEN '29'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 <= 720 THEN '30'
          WHEN extract(epoch from ${cr_to_hosp_diff})/3600 > 720 THEN 'Greater then 30 Days'
          ELSE NULL
          END
          ;;

    }

  set: bb_detail {
    fields: [
      er_admit_date,
      hosp_admit_date,
      count_12_hour_first_admit_emergency,
      count_3_day_first_admit_emergency,
      count_7_day_first_admit_emergency,
      count_14_day_first_admit_emergency,
      count_30_day_first_admit_emergency,
      count_24_hour_first_admit_inpatient_emergency,
      count_3_day_first_admit_inpatient_emergency,
      count_7_day_first_admit_inpatient_emergency,
      count_14_day_first_admit_inpatient_emergency,
      count_30_day_first_admit_inpatient_emergency
    ]
  }

}
