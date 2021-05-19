view: patients {
  sql_table_name: public.patients ;;

  dimension: chrono_patient_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.chrono_patient_id ;;
  }

  dimension: account_id {
    type: number
    sql: ${TABLE}.account_id ;;
  }

  dimension: first_name {
    type: string
    sql: INITCAP(${TABLE}.first_name) ;;
  }

  dimension: last_name {
    type: string
    sql: INITCAP(${TABLE}.last_name) ;;
  }

  dimension: dob {
    type: date
    sql: ${TABLE}.dob ;;
  }

  dimension: patient_email {
    type: string
    sql: ${TABLE}.patient_email ;;
  }

  dimension: gender {
    type: string
    sql: CASE
          WHEN ${TABLE}.gender = 'f' THEN 'Female'
          WHEN ${TABLE}.gender = 'm' THEN 'Male'
          ELSE INITCAP(${TABLE}.gender)
        END ;;
  }

  dimension: gender_short {
    type: string
    sql: CASE
          WHEN ${gender} = 'Female' THEN 'F'
          WHEN ${gender} = 'Male' THEN 'M'
          ELSE NULL
        END ;;
  }

  dimension: female {
   type: yesno
   sql: ${gender} = 'Female' ;;
  }

  measure: distinct_females {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: female
      value: "yes"
    }
  }

  measure: percent_female {
    type: number
    value_format: "0%"
    sql: ${distinct_females}::float/${count_distinct}::float ;;
  }

  dimension: age {
    type: number
    sql: CASE WHEN ${care_request_flat.created_date} >= ${dob}
              AND CAST(EXTRACT(YEAR from AGE(${care_request_flat.created_date}, ${dob})) AS INT) <= 107 THEN
          CAST(EXTRACT(YEAR from AGE(${care_request_flat.created_date}, ${dob})) AS INT)
         ELSE NULL
        END ;;
    group_label: "Age of Patient"
  }

  dimension: age_in_months {
    hidden: yes
    type: number
    sql: extract(year from age(${care_request_flat.created_date}, ${dob})) * 12 + extract(month from age(${care_request_flat.created_date}, ${dob})) ;;
    group_label: "Age of Patient"
  }

  dimension: hedis_age_group {
    type: string
    description: "Age bands for HEDIS reporting: 3 mos - 17, 18 - 64, 65+"
    sql: CASE
          WHEN ${age_in_months} >= 3 AND ${age} <=17 THEN '3 months - 17'
          WHEN ${age} >= 18 AND ${age} <= 64 THEN '18 - 64'
          WHEN ${age} >= 65 AND ${age} <= 110 THEN '65+'
          ELSE NULL
        END ;;
  }

  dimension: bad_age_filter {
    type: yesno
    hidden: yes
    sql: ${age} >= 110 or ${age}<0;;
    group_label: "Age of Patient"
  }

  dimension: pediatric_patient {
    description: "A flag indicating patients age < 13"
    type: yesno
    sql: ${age} < 13 AND NOT ${bad_age_filter} ;;
  }


  dimension: age_above_65 {
    description: "A flag indicating patients age > 65"
    type: yesno
    sql: ${age} > 65 AND NOT ${bad_age_filter} ;;
    group_label: "Age of Patient"
  }

  dimension: age_18_plus {
    description: "A flag indicating patients age >= 18"
    type: yesno
    sql: ${age} >= 18 AND NOT ${bad_age_filter} ;;
    group_label: "Age of Patient"
  }


  dimension: age_band_sort {
    type: string
    hidden: yes
    alpha_sort: yes
    sql: CASE
          WHEN ${age} >= 0 AND ${age} <= 5 THEN 'a'
          WHEN ${age} >= 6 AND ${age} <= 9 THEN 'b'
          WHEN ${age} >= 10 AND ${age} <= 19 THEN 'c'
          WHEN ${age} >= 20 AND ${age} <= 29 THEN 'd'
          WHEN ${age} >= 30 AND ${age} <= 39 THEN 'e'
          WHEN ${age} >= 40 AND ${age} <= 49 THEN 'f'
          WHEN ${age} >= 50 AND ${age} <= 59 THEN 'g'
          WHEN ${age} >= 60 AND ${age} <= 69 THEN 'h'
          WHEN ${age} >= 70 AND ${age} <= 79 THEN 'i'
          WHEN ${age} >= 80 AND ${age} <= 89 THEN 'j'
          WHEN ${age} >= 90 AND ${age} <= 110 THEN 'k'
          ELSE 'z'
         END ;;
   group_label: "Age of Patient"
  }

  dimension: age_band {
    type: string
    order_by_field: age_band_sort
    sql: CASE
          WHEN ${age} >= 0 AND ${age} <= 5 THEN 'age_0_to_5'
          WHEN ${age} >= 6 AND ${age} <= 9 THEN 'age_6_to_9'
          WHEN ${age} >= 10 AND ${age} <= 19 THEN 'age_10_to_19'
          WHEN ${age} >= 20 AND ${age} <= 29 THEN 'age_20_to_29'
          WHEN ${age} >= 30 AND ${age} <= 39 THEN 'age_30_to_39'
          WHEN ${age} >= 40 AND ${age} <= 49 THEN 'age_40_to_49'
          WHEN ${age} >= 50 AND ${age} <= 59 THEN 'age_50_to_59'
          WHEN ${age} >= 60 AND ${age} <= 69 THEN 'age_60_to_69'
          WHEN ${age} >= 70 AND ${age} <= 79 THEN 'age_70_to_79'
          WHEN ${age} >= 80 AND ${age} <= 89 THEN 'age_80_to_89'
          WHEN ${age} >= 90 AND ${age} <= 110 THEN 'age_90_plus'
          ELSE NULL
         END ;;
    group_label: "Age of Patient"
  }

  dimension: age_categories_risk_strat {
    description: "Age band used to track risk stratification from different risk protocols: 0-5, 6-10, 11-18, 19-39, 40-60, 61-79, 80+"
    type: string
    sql: CASE
          WHEN ${age} >= 0 AND ${age} <= 5 THEN 'a (0 - 5)'
          WHEN ${age} >= 6 AND ${age} <= 10 THEN 'b (6 - 10)'
          WHEN ${age} >= 11 AND ${age} <= 18 THEN 'c (11 - 18)'
          WHEN ${age} >= 19 AND ${age} <= 39 THEN 'd (19 - 39)'
          WHEN ${age} >= 40 AND ${age} <= 60 THEN 'e (40 - 60)'
          WHEN ${age} >= 61 AND ${age} <= 79 THEN 'f (61 - 79)'
          WHEN ${age} >= 80 AND ${age} <= 110 THEN 'g (80+)'
          ELSE NULL
         END ;;
    group_label: "Age of Patient"
  }

  measure: complete_visits_age_0_to_5 {
    description: "Count completed visits with patients between 0 and 5 years old"
    type: count_distinct
    sql: ${care_request_flat.care_request_id};;
    filters: {
      field: care_requests.billable_est
      value: "yes" }
    filters: {
      field: age_categories_risk_strat
      value: "a (0 - 5)" }
}

  measure: complete_visits_age_6_to_10 {
    description: "Count completed visits with patients between 6 and 10 years old"
    type: count_distinct
    sql: ${care_request_flat.care_request_id};;
    filters: {
      field: care_requests.billable_est
      value: "yes" }
    filters: {
      field: age_categories_risk_strat
      value: "b (6 - 10)" }
  }

  measure: complete_visits_age_11_to_18 {
    description: "Count completed visits with patients between 11 and 18 years old"
    type: count_distinct
    sql: ${care_request_flat.care_request_id};;
    filters: {
      field: care_requests.billable_est
      value: "yes" }
    filters: {
      field: age_categories_risk_strat
      value: "c (11 - 18)" }
  }

  measure: complete_visits_age_19_to_39 {
    description: "Count completed visits with patients between 19 to 39 years old"
    type: count_distinct
    sql: ${care_request_flat.care_request_id};;
    filters: {
      field: care_requests.billable_est
      value: "yes" }
    filters: {
      field: age_categories_risk_strat
      value: "d (19 - 39)" }
  }

  measure: complete_visits_age_40_to_60 {
    description: "Count completed visits with patients between 40 and 60 years old"
    type: count_distinct
    sql: ${care_request_flat.care_request_id};;
    filters: {
      field: care_requests.billable_est
      value: "yes" }
    filters: {
      field: age_categories_risk_strat
      value: "e (40 - 60)" }
  }

  measure: complete_visits_age_61_to_79 {
    description: "Count completed visits with patients between 61 and 79 years old"
    type: count_distinct
    sql: ${care_request_flat.care_request_id};;
    filters: {
      field: care_requests.billable_est
      value: "yes" }
    filters: {
      field: age_categories_risk_strat
      value: "f (61 - 79)" }
  }

  measure: complete_visits_age_80_plus{
    description: "Count completed visits with patients above 80 years old"
    type: count_distinct
    sql: ${care_request_flat.care_request_id};;
    filters: {
      field: care_requests.billable_est
      value: "yes" }
    filters: {
      field: age_categories_risk_strat
      value: "g (80+)" }
  }

  dimension: age_band_sort_2 {
    type: string
    hidden: yes
    alpha_sort: yes
    sql: CASE
          WHEN ${age} >= 0 AND ${age} <= 18 THEN 'a'
          WHEN ${age} >= 19 AND ${age} <= 29 THEN 'b'
          WHEN ${age} >= 30 AND ${age} <= 39 THEN 'c'
          WHEN ${age} >= 40 AND ${age} <= 49 THEN 'd'
          WHEN ${age} >= 50 AND ${age} <= 59 THEN 'e'
          WHEN ${age} >= 60 AND ${age} <= 69 THEN 'f'
          WHEN ${age} >= 70 AND ${age} <= 110 THEN 'g'
          ELSE 'z'
         END ;;
    group_label: "Age of Patient"
  }

  dimension: age_band_2 {
    description: "0-18, by decade to 70, older than 70"
    type: string
    order_by_field: age_band_sort_2
    sql: CASE
          WHEN ${age} >= 0 AND ${age} <= 18 THEN 'age_0_to_18'
          WHEN ${age} >= 19 AND ${age} <= 29 THEN 'age_19_to_29'
          WHEN ${age} >= 30 AND ${age} <= 39 THEN 'age_30_to_39'
          WHEN ${age} >= 40 AND ${age} <= 49 THEN 'age_40_to_49'
          WHEN ${age} >= 50 AND ${age} <= 59 THEN 'age_50_to_59'
          WHEN ${age} >= 60 AND ${age} <= 69 THEN 'age_60_to_69'
          WHEN ${age} >= 70 AND ${age} <= 110 THEN 'age_70_plus'
          ELSE NULL
         END ;;
    group_label: "Age of Patient"
  }

  dimension: age_band_life_stage_sort {
    type: string
    hidden: yes
    alpha_sort: yes
    sql: CASE
          WHEN ${age_in_months} >= 0 AND ${age_in_months} < 3  THEN 'a'
          WHEN ${age_in_months} >= 3 AND ${age_in_months} <= 227 THEN 'b'
          WHEN ${age_in_months} >= 228 AND ${age_in_months} <= 779 THEN 'c'
          WHEN ${age_in_months} >= 780 AND ${age_in_months} <= 1320 THEN 'd'
          ELSE 'z'
         END ;;
  }

  dimension: age_band_life_stage {
    type: string
    order_by_field:  age_band_life_stage_sort
    sql:  CASE
          WHEN ${age_in_months} >= 0 AND ${age_in_months} < 3 THEN 'age_less_than_3_months'
          WHEN ${age_in_months} >= 3 AND ${age_in_months} <= 227 THEN 'age_3_months_to_18_years'
          WHEN ${age_in_months} >= 228 AND ${age_in_months} <= 779 THEN 'age_19_to_64_years'
          WHEN ${age_in_months} >= 780 AND ${age_in_months} <= 1320 THEN 'age_65_plus_years'
          ELSE NULL
          END
          ;;
    group_label: "Age of Patient"
  }

  dimension: age_band_wide {
    type: string
    description: "Age bands, grouped into wider buckets"
    sql: CASE
          WHEN ${age} >= 0 AND ${age} <= 24 THEN 'age_0_to_24'
          WHEN ${age} >= 25 AND ${age} <= 39 THEN 'age_25_to_39'
          WHEN ${age} >= 40 AND ${age} <= 54 THEN 'age_40_to_54'
          WHEN ${age} >= 55 AND ${age} <= 64 THEN 'age_55_to_64'
          WHEN ${age} >= 65 AND ${age} <= 74 THEN 'age_65_to_74'
          WHEN ${age} >= 75 AND ${age} <= 84 THEN 'age_75_to_84'
          WHEN ${age} >= 85 AND ${age} <= 94 THEN 'age_85_to_94'
          WHEN ${age} >= 95 AND ${age} <= 110 THEN 'age_95_plus'
          ELSE NULL
         END ;;
    group_label: "Age of Patient"
  }


  measure: median_age {
    type: median_distinct
    sql_distinct_key: ${care_requests.id} ;;
    value_format: "0.0"
    sql:  ${age} ;;
    filters: {
      field: bad_age_filter
      value: "no"
    }
    group_label: "Age of Patient"

  }

  measure: average_age {
    type: average_distinct
    sql_distinct_key: ${care_requests.id} ;;
    value_format: "0.0"
    sql: ${age} ;;
    filters: {
      field: bad_age_filter
      value: "no"
    }
    group_label: "Age of Patient"
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
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: created_mountain {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week_index,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at  AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain'  ;;
  }

  dimension_group: created_local {
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
    sql: ${TABLE}.created_at  AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz}  ;;
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
    sql: ${TABLE}.deleted_at ;;
  }

  dimension: ehr_id {
    type: string
    sql: ${TABLE}.ehr_id ;;
  }

  dimension: ehr_name {
    type: string
    sql: ${TABLE}.ehr_name ;;
  }




  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: is_user {
    type: yesno
    sql: ${TABLE}.is_user ;;
  }



  dimension: mobile_number {
    type: string
    sql: ${TABLE}.mobile_number ;;
  }

  dimension: mobile_number_short {
    type: string
    sql: SUBSTRING(${mobile_number},3) ;;
  }


  dimension: patient_salesforce_id {
    type: string
    sql: ${TABLE}.patient_salesforce_id ;;
  }

  dimension: pcp_name {
    type: string
    sql: ${TABLE}.pcp_name ;;
  }


  dimension_group: pulled {
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
    sql: ${TABLE}.pulled_at ;;
  }

  dimension_group: pushed {
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
    sql: ${TABLE}.pushed_at ;;
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
    sql: ${TABLE}.updated_at ;;
  }

  dimension_group: updated_mountain {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week_index,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at  AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain'  ;;
  }

  dimension: patient_updated_greater_than_created_time {
    type: yesno
    sql: ${updated_mountain_raw} > ${created_mountain_raw} ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: ssn {
    type: string
    sql: CASE WHEN ${TABLE}.ssn = '000-00-0000' THEN NULL
        ELSE ${TABLE}.ssn
        END ;;
  }

  dimension: ssn_present {
    type: yesno
    sql: ${ssn} is not null and trim(${ssn})!='' ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_distinct {
    type: count_distinct
    sql_distinct_key: ${id} ;;
    sql: ${id};;
  }

  measure: count_distinct_patients_updated {
    description: "Count of distinct patients where the updated date is greater than the created date"
    type: count_distinct
    sql_distinct_key: ${id} ;;
    sql: ${id};;
    filters: {
      field: patient_updated_greater_than_created_time
      value: "yes"
    }
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      chrono_patient_id,
      ehr_name,
      power_of_attorneys.count
    ]
  }
}
