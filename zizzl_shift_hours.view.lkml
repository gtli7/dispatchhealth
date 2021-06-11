view: zizzl_shift_hours {
  derived_table: {
    sql:
WITH z AS (
SELECT
    employee_id,
    counter_date,
    first_name,
    last_name,
    clinical_or_non_clinical,
    COUNT(DISTINCT default_jobs_full_path) AS count_job_titles,
    COUNT(DISTINCT position_full_path) AS count_shift_names,
    COUNT(*) AS row_num,
    SUM(CASE WHEN counter_name IN ('Regular', 'Overtime', 'Salary Plus', 'Holiday', 'Time and Half')
        AND counter_hours >= 15 THEN (counter_hours/2)
        WHEN counter_name IN ('Regular', 'Overtime', 'Salary Plus', 'Holiday', 'Time and Half')
          THEN counter_hours
        ELSE NULL END) / COUNT(DISTINCT default_jobs_full_path) AS direct_clinical_hours,

    ROUND((SUM(CASE WHEN counter_name IN ('Holiday Worked 0.5','Double Pay','Overtime','Regular','Time and Half',
                                   'Solo Shift','On Call Premium','Training','Salary Plus','Ambassador','Overtime 0.5')
                         AND counter_hours >= 15 THEN (gross_pay/2)
                    WHEN counter_name IN ('Holiday Worked 0.5','Double Pay','Overtime','Regular','Time and Half',
                                   'Solo Shift','On Call Premium','Training','Salary Plus','Ambassador','Overtime 0.5')
              THEN gross_pay ELSE NULL END)/COUNT(DISTINCT default_jobs_full_path))::numeric,2) AS direct_clinical_pay
    FROM zizzl.weekly_rates_hours
    WHERE counter_name IN ('Holiday Worked 0.5','Double Pay','Overtime','Regular','Time and Half',
                           'Solo Shift','On Call Premium','Training','Salary Plus','Ambassador','Overtime 0.5')
    AND latest AND clinical_shift AND (position_full_path SIMILAR TO '%(DHMT/|NP/PA/)%'
      OR (default_provider_type_full_path in ('APP', 'DHMT') AND position_full_path = ''))
    GROUP BY 1,2,3,4,5)

   SELECT
    st.id AS shift_team_id,
    stm.user_id,
    DATE(st.start_time) AS shift_date,
    pp.position,
    ((EXTRACT(EPOCH FROM end_time) - EXTRACT(EPOCH FROM start_time)) / 3600) AS scheduled_hours,
    CASE
      WHEN z.direct_clinical_hours >= 15 THEN z.direct_clinical_hours / count_shift_names
      ELSE z.direct_clinical_hours
    END AS punched_clinical_hours,
    CASE
      WHEN ((EXTRACT(EPOCH FROM end_time) - EXTRACT(EPOCH FROM start_time)) / 3600) < 0.25  AND z.direct_clinical_hours IS NULL THEN NULL
      ELSE COALESCE(z.direct_clinical_hours, ((EXTRACT(EPOCH FROM end_time) - EXTRACT(EPOCH FROM start_time)) / 3600), NULL)
    END AS actual_clinical_hours,
    z.direct_clinical_pay,
    z.count_job_titles,
    z.count_shift_names,
    COUNT(*) AS tot_rows
    FROM public.shift_teams st
    LEFT JOIN public.shift_team_members stm
        ON st.id = stm.shift_team_id
    INNER JOIN public.provider_profiles pp
        ON stm.user_id = pp.user_id
    LEFT JOIN z
        ON stm.user_id = z.employee_id AND DATE(st.start_time) = z.counter_date
    WHERE pp.position IN ('emt','advanced practice provider')
    GROUP BY 1,2,3,4,5,6,7,8,9,10
    HAVING CASE
      WHEN ((EXTRACT(EPOCH FROM end_time) - EXTRACT(EPOCH FROM start_time)) / 3600) < 0.25  AND z.direct_clinical_hours IS NULL THEN NULL
      ELSE COALESCE(z.direct_clinical_hours, ((EXTRACT(EPOCH FROM end_time) - EXTRACT(EPOCH FROM start_time)) / 3600), NULL)
    END IS NOT NULL  ;;

      sql_trigger_value: SELECT SUM(counter_hours) FROM zizzl.weekly_rates_hours ;;
      indexes: ["shift_team_id", "user_id"]
    }

  dimension: primary_key {
    type: number
    primary_key: yes
    sql: CONCAT(${shift_team_id},${user_id}) ;;
  }

  dimension: shift_team_id {
    type: number
    sql: ${TABLE}.shift_team_id ;;
  }

dimension_group: shift_date {
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
  sql: ${TABLE}.shift_date ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: actual_clinical_hours {
    type: number
    value_format: "0.00"
    description: "Zizzl hours if available, otherwise scheduled hours"
    sql: ${TABLE}.actual_clinical_hours ;;
  }

  dimension: punched_clinical_hours {
    type: number
    value_format: "0.00"
    description: "Zizzl hours only"
    sql: ${TABLE}.punched_clinical_hours ;;
  }

  dimension: scheduled_hours {
    type: number
    value_format: "0.00"
    description: "Scheduled hours only"
    sql: ${TABLE}.scheduled_hours ;;
  }

  dimension: direct_clinical_pay {
    type: number
    value_format: "0.00"
    description: "Total pay for clinical hours, including overtime, holiday pay, etc."
    sql: ${TABLE}.direct_clinical_pay ;;
  }

  measure: sum_direct_clinical_pay {
    type: sum_distinct
    sql_distinct_key: ${primary_key} ;;
    value_format: "$#,##0.00"
    description: "Total pay for clinical hours, including overtime, holiday pay, etc."
    sql: ${TABLE}.direct_clinical_pay ;;
  }

  measure: sum_direct_clinical_pay_daily {
    type: sum_distinct
    sql_distinct_key: CONCAT(${shift_date_date}, ${user_id}) ;;
    value_format: "$#,##0.00"
    description: "Total pay for clinical hours, including overtime, holiday pay, etc."
    sql: ${TABLE}.direct_clinical_pay ;;
  }

  dimension: position {
    type: string
    sql: ${TABLE}.position ;;
  }

  measure: sum_clinical_hours {
    type: sum_distinct
    value_format: "0.00"
    group_label: "Hours Worked"
    sql_distinct_key: ${primary_key} ;;
    description: "Sum of APP and DHMT clinical hours"
    sql: ${actual_clinical_hours} ;;
    filters: [actual_clinical_hours: ">0.24"]
    drill_fields: [users.first_name, users.last_name, shift_teams.start_date, position, cars.name, actual_clinical_hours]
  }

  measure: sum_punched_hours {
    type: sum_distinct
    value_format: "0.00"
    group_label: "Hours Worked"
    sql_distinct_key: ${primary_key} ;;
    description: "Zizzl Punched Hours"
    sql: ${punched_clinical_hours} ;;
    filters: [cars.test_car: "no"]
  }

  measure: sum_punched_hours_daily {
    type: sum_distinct
    value_format: "0.00"
    group_label: "Hours Worked"
    sql_distinct_key: CONCAT(${shift_date_date}, ${user_id}) ;;
    description: "Zizzl Punched Hours Daily"
    sql: ${punched_clinical_hours} ;;
    filters: [cars.test_car: "no"]
  }

  measure: sum_clinical_hours_no_arm_advanced_only {
    type: sum_distinct
    value_format: "0.00"
    group_label: "Hours Worked"
    sql_distinct_key: CONCAT(${shift_date_date}, ${user_id}) ;;
    # sql_distinct_key: ${primary_key} ;;
    label: "Sum Clinical hours (no arm, advanced)"
    sql: case when ${shift_teams.start_date} >= '2020-09-14' and lower(${shift_types.name}) like '%tele%' and ${position} = 'emt' then ${actual_clinical_hours}
              when ${shift_teams.start_date} >= '2020-09-14' and lower(${shift_types.name}) not like '%tele%' and ${position} = 'advanced practice provider' then ${actual_clinical_hours}
              when ${shift_teams.start_date} < '2020-09-14' and ${position} = 'advanced practice provider' then ${actual_clinical_hours}
              else 0 end;;
    filters: [
      actual_clinical_hours: ">0.24",
      cars.mfr_flex_car: "no",
      cars.advanced_care_car: "no",
      cars.test_car: "no"
      ]
  }

  measure: productivity {
    type: number
    value_format: "0.00"
    sql: case when ${sum_clinical_hours_no_arm_advanced_only}>0 then ${care_request_flat.complete_count_no_arm_advanced}/${sum_clinical_hours_no_arm_advanced_only} else 0 end ;;
    drill_fields: [users.app_name, shift_teams.count_distinct_shifts, sum_app_clinical_hours, productivity]
  }

  measure: sum_app_clinical_hours {
    type: sum_distinct
    value_format: "0.00"
    group_label: "Hours Worked"
    sql_distinct_key: ${primary_key} ;;
    description: "Sum of APP clinical hours"
    sql: ${actual_clinical_hours} ;;
    filters: [position: "advanced practice provider", actual_clinical_hours: ">0.24"]
    drill_fields: [users.first_name, users.last_name, shift_teams.start_date, position, cars.name, actual_clinical_hours]
  }

  measure: sum_dhmt_clinical_hours {
    type: sum_distinct
    value_format: "0.00"
    group_label: "Hours Worked"
    sql_distinct_key: ${primary_key} ;;
    description: "Sum of DHMT clinical hours"
    sql: ${actual_clinical_hours} ;;
    filters: [position: "emt", actual_clinical_hours: ">0.24"]
    drill_fields: [users.first_name, users.last_name, shift_teams.start_date, position, cars.name, actual_clinical_hours]
  }

  measure: sum_app_clinical_hours_no_advanced_mc {
    type: sum_distinct
    value_format: "0.00"
    sql_distinct_key: ${primary_key} ;;
    label: "APP Paid Hrs (no advanced, multicare)"
    sql: ${actual_clinical_hours} ;;
    filters: [position: "advanced practice provider",
      actual_clinical_hours: ">0.24",
      cars.test_car: "no",
      cars.advanced_care_car: "no",
      shift_types.name: "-multicare",
      cars.name: "-NULL"]
  }

  measure: sum_dhmt_clinical_hours_no_advanced_mc {
    type: sum_distinct
    value_format: "0.00"
    sql_distinct_key: ${primary_key} ;;
    label: "DHMT Paid Hrs (no advanced, multicare)"
    sql: ${actual_clinical_hours} ;;
    filters: [position: "emt",
      actual_clinical_hours: ">0.24",
      cars.test_car: "no",
      cars.advanced_care_car: "no",
      shift_types.name: "-multicare",
      cars.name: "-NULL"]
  }

  measure: pct_app_clinical_hours_paid {
    type: number
    sql: ${sum_app_clinical_hours_no_advanced_mc} / nullif(${shift_teams.sum_app_hours_no_advanced_mc}, 0) ;;
    value_format: "0.00%"
    label: "% APP Paid / Actual"
  }

  measure: pct_dhmt_clinical_hours_paid {
    type: number
    sql: ${sum_dhmt_clinical_hours_no_advanced_mc} / nullif(${shift_teams.sum_dhmt_hours_no_advanced_mc}, 0) ;;
    value_format: "0.00%"
    label: "% DHMT Paid / Actual"
  }



  }
