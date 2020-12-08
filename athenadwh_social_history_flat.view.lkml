view: athenadwh_social_history_flat {
  view_label: "ZZZZ - Athenadwh Social History Flat"
  derived_table: {
    sql:
    SELECT DISTINCT
  base.chart_id,
  CAST(rd.answer AS DATE) AS review_date,
  ss.answer AS smoking_status,
  cts.answer AS smokeless_tobacco_use,
  drugs.answer AS drugs_abused,
  vape.answer AS vaping_status,
  ms.answer AS marital_status,
  cs.answer AS code_status,
  ad.answer AS advance_directive,
  fru.answer AS fall_risk_unsteady,
  adl.answer AS activities_daily_living,
  trn.answer AS transportation,
  frp.answer AS fall_risk_provider,
  frw.answer AS fall_risk_worry,
  ntra.answer AS nutrition_access,
  ntrs.answer AS nutrition_status,
  sss.answer AS safety_feeling,
  ssa.answer AS taking_advantage,
  meds.answer AS afford_medications,
  hd.answer AS heavy_drinking,
  tyrs.answer AS tobacco_yrs_of_use,
  smk.answer AS smoking_how_much,
  thaz.answer AS fall_hazards,
  gcln.answer AS general_cleanliness,
  nstat.answer AS nutritional_status,
  costs.answer AS cost_concerns,
  hs.answer AS home_situation,
  fis.answer AS food_insecurity,
  fw.answer AS food_insecurity_worry,
  soci.answer AS social_interactions,
  homeis.answer AS housing_insecurity,
  rcs.answer AS resource_help_requested

  FROM (
    SELECT DISTINCT chart_id
      FROM athenadwh_social_history_clone
  ) AS base
LEFT JOIN (
    SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
            FROM athenadwh_social_history_clone
            WHERE question = 'Reviewed Date'
            GROUP BY 1,2,3,4
  ) AS rd
    ON base.chart_id = rd.chart_id AND rd.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
              WHERE question = 'Tobacco Smoking Status'
              GROUP BY 1,2,3,4
    ) AS ss
      ON base.chart_id = ss.chart_id AND ss.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Marital status'
        GROUP BY 1,2,3,4
    ) AS ms
      ON base.chart_id = ms.chart_id AND ms.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Code Status'
        GROUP BY 1,2,3,4
    ) AS cs
      ON base.chart_id = cs.chart_id AND cs.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Advance directive'
        GROUP BY 1,2,3,4
    ) AS ad
      ON base.chart_id = ad.chart_id AND ad.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE social_history_key = 'SOCIALHISTORY.LOCAL.145'
        GROUP BY 1,2,3,4
    ) AS fru
      ON base.chart_id = fru.chart_id AND fru.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE social_history_key = 'SOCIALHISTORY.LOCAL.144'
        GROUP BY 1,2,3,4
    ) AS adl
      ON base.chart_id = adl.chart_id AND adl.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question,
        CASE WHEN created_datetime <= '2019-12-13 14:25:00' AND INITCAP(answer) = 'Yes' THEN 'No'
         WHEN created_datetime <= '2019-12-13 14:25:00' AND INITCAP(answer) LIKE 'No%' THEN 'Yes'
         ELSE INITCAP(answer)
        END
         AS answer,
         created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM looker_scratch.athenadwh_social_history_clone
        WHERE question LIKE '%Has lack of transportation kept you from medical appointments, meetings, work, or from getting things needed for daily living?' AND
        social_history_key = 'SOCIALHISTORY.LOCAL.141'
        GROUP BY 1,2,3,4
    ) AS trn
      ON base.chart_id = trn.chart_id AND trn.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE social_history_key = 'SOCIALHISTORY.LOCAL.147'
        GROUP BY 1,2,3,4
    ) AS frp
      ON base.chart_id = frp.chart_id AND frp.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE social_history_key = 'SOCIALHISTORY.LOCAL.146'
        GROUP BY 1,2,3,4
    ) AS frw
      ON base.chart_id = frw.chart_id AND frw.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE question = 'Nutrition: Do you feel you have access to health foods?'
          GROUP BY 1,2,3,4
      ) AS ntra
        ON base.chart_id = ntra.chart_id AND ntra.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE question = 'Nutrition: What is the overall nutritional status of patient?'
          GROUP BY 1,2,3,4
      ) AS ntrs
        ON base.chart_id = ntrs.chart_id AND ntrs.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE question = 'Social Support: Do you feel safe?'
          GROUP BY 1,2,3,4
      ) AS sss
        ON base.chart_id = sss.chart_id AND sss.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Social Support: Do you feel that anyone is taking advantage of you?'
        GROUP BY 1,2,3,4
    ) AS ssa
      ON base.chart_id = ssa.chart_id AND ssa.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Financial: Can you afford the medications that your medical team has prescribed you?'
        GROUP BY 1,2,3,4
    ) AS meds
      ON base.chart_id = meds.chart_id AND meds.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'How many days in the past year have you had a heavy drinking consumption (4+ female, 5+ male)?'
        GROUP BY 1,2,3,4
    ) AS hd
      ON base.chart_id = hd.chart_id AND hd.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Tobacco-years of use'
        GROUP BY 1,2,3,4
    ) AS tyrs
      ON base.chart_id = tyrs.chart_id AND tyrs.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, LOWER(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Smoking - How much?'
        GROUP BY 1,2,3,4
    ) AS smk
      ON base.chart_id = smk.chart_id AND smk.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Trip/Fall Hazards'
        GROUP BY 1,2,3,4
    ) AS thaz
      ON base.chart_id = thaz.chart_id AND thaz.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Review of the general cleanliness of the home'
        GROUP BY 1,2,3,4
    ) AS gcln
      ON base.chart_id = gcln.chart_id AND gcln.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Overall nutritional status of patient'
        GROUP BY 1,2,3,4
    ) AS nstat
      ON base.chart_id = nstat.chart_id AND nstat.rownum = 1
LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
              WHERE question = 'Smokeless Tobacco Status'
              GROUP BY 1,2,3,4
    ) AS cts
      ON base.chart_id = cts.chart_id AND cts.rownum = 1
LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
              WHERE social_history_key = 'SOCIALHISTORY.DRUGSABUSED'
              GROUP BY 1,2,3,4
    ) AS drugs
      ON base.chart_id = drugs.chart_id AND drugs.rownum = 1
LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
              WHERE social_history_key = 'SOCIALHISTORY.ECIGVAPESTATUS'
              GROUP BY 1,2,3,4
    ) AS vape
      ON base.chart_id = vape.chart_id AND vape.rownum = 1
LEFT JOIN (
        SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE question = 'Home situation'
          GROUP BY 1,2,3,4
      ) AS hs
        ON base.chart_id = hs.chart_id AND hs.rownum = 1
LEFT JOIN (
        SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE social_history_key = 'SOCIALHISTORY.LOCAL.142' AND
          question = 'Has it ever happened within the past 12 months that the food you bought just didn’t last, and you didn’t have money to get more?'
          AND created_datetime >= '2019-12-13 14:25:00'
          GROUP BY 1,2,3,4
      ) AS fis
        ON base.chart_id = fis.chart_id AND fis.rownum = 1
LEFT JOIN (
        SELECT chart_id, question,
CASE WHEN created_datetime <= '2019-12-13 14:25:00' AND INITCAP(answer) = 'Yes' THEN 'No'
         WHEN created_datetime <= '2019-12-13 14:25:00' AND INITCAP(answer) LIKE 'No%' THEN 'Yes'
         ELSE INITCAP(answer)
        END
         AS answer,
         created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM looker_scratch.athenadwh_social_history_clone
        WHERE question LIKE '%Within the past 12 months we worried that our food would run out before we got money to buy more.' AND
        social_history_key = 'SOCIALHISTORY.LOCAL.143'
        GROUP BY 1,2,3,4
      ) AS fw
        ON base.chart_id = fw.chart_id AND fw.rownum = 1
LEFT JOIN (
        SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE social_history_key = 'SOCIALHISTORY.LOCAL.161'
          GROUP BY 1,2,3,4
      ) AS soci
        ON base.chart_id = soci.chart_id AND soci.rownum = 1
LEFT JOIN (
        SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE social_history_key = 'SOCIALHISTORY.LOCAL.91' AND
          question LIKE '%Do you have any concerns about your current housing situation?'
          GROUP BY 1,2,3,4
      ) AS homeis
        ON base.chart_id = homeis.chart_id AND homeis.rownum = 1
LEFT JOIN (
        SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE social_history_key = 'SOCIALHISTORY.LOCAL.94' AND
          question = 'Would you like help connecting to resources?'
          GROUP BY 1,2,3,4
      ) AS rcs
        ON base.chart_id = rcs.chart_id AND rcs.rownum = 1
LEFT JOIN (
        SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE social_history_key = 'SOCIALHISTORY.LOCAL.85'
          GROUP BY 1,2,3,4
      ) AS costs
        ON base.chart_id = costs.chart_id AND costs.rownum = 1
ORDER BY base.chart_id  ;;

      sql_trigger_value: SELECT COUNT(*) FROM athenadwh_social_history_clone ;;
      indexes: ["chart_id"]
    }

  dimension: chart_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.chart_id ;;
  }

  dimension: review_date {
    type: date
    description: "The date that the social history questions were reviewed with the patients"
    convert_tz: no
    sql: ${TABLE}.review_date ;;
  }

  dimension: smoking_status {
    type: string
    sql: ${TABLE}.smoking_status ;;
  }

  dimension: smoking_flag {
    type: yesno
    sql: ${smoking_how_much} !='n' and ${smoking_how_much} is not null ;;
  }

  dimension: smokeless_tobacco_use {
    type: string
    sql: ${TABLE}.smokeless_tobacco_use ;;
  }

  dimension: drugs_abused {
    type: string
    sql: ${TABLE}.drugs_abused ;;
  }
  dimension: vaping_status {
    type: string
    sql: ${TABLE}.vaping_status ;;
  }

  dimension: marital_status {
    type: string
    sql: ${TABLE}.marital_status ;;
  }

  dimension: code_status {
    type: string
    sql: ${TABLE}.code_status ;;
  }

  dimension: advance_directive {
    type: string
    sql: ${TABLE}.advance_directive ;;
  }

  dimension: fall_risk_unsteady {
    type: string
    description: "Fall Risk: Do you feel unsteady when standing or walking?"
    sql: ${TABLE}.fall_risk_unsteady ;;
  }

  measure: count_fall_risk_unsteady {
    type: count_distinct
    description: "Count of patients who indicate they feel unsteady when standing or walking"
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
    filters: {
      field: fall_risk_unsteady
      value: "Y%"
    }
  }

  dimension: activities_daily_living {
    type: string
    description: "ADL: Do you need help with daily activities such as bathing, preparing meals, dressing, or cleaning?"
    sql: ${TABLE}.activities_daily_living ;;
  }

  measure: count_activities_daily_living {
    type: count_distinct
    description: "Count of patients who indicate they need help with activities of daily living"
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
    filters: {
      field: activities_daily_living
      value: "Y"
    }
  }

  dimension: transportation {
    type: string
    description: "Has lack of transportation kept you from medical appointments, meetings, work,
    or from getting things needed for daily living?"
    sql: ${TABLE}.transportation ;;
  }

  dimension: lack_of_transportation_flag {
    type: yesno
    sql: ${transportation} LIKE 'Yes%' ;;
  }

  dimension: fall_risk_provider {
    type: string
    description: "Fall Risk: In your opinion (provider), does the home or patient potentially predispose them to an increase fall risk?"
    sql: ${TABLE}.fall_risk_provider ;;
  }

  dimension: fall_risk_per_provider_flag {
    type: yesno
    sql: ${fall_risk_provider} IS NOT NULL AND ${fall_risk_provider} <> 'N' ;;
  }

  dimension: fall_risk_worry {
    type: string
    hidden: yes
    description: "Fall Risk: Do you worry about falling?"
    sql: ${TABLE}.fall_risk_worry ;;
  }

  dimension: fall_risk_worry_flag {
    type: yesno
    hidden: yes
    sql: ${fall_risk_worry} = 'Y' ;;
  }

  dimension: advanced_directive_flag {
    type: yesno
    sql: ${advance_directive} = 'Y' ;;
  }

  dimension: nutrition_access {
    type: string
    description: "Nutrition: Do you feel you have access to health foods?"
    sql: ${TABLE}.nutrition_access ;;
  }

  dimension: lack_of_access_healthy_foods {
    type: yesno
    hidden: yes
    description: "Does the patient indicate they have a lack of access to healthy foods"
    sql: lower(${nutrition_access}) SIMILAR TO '%(no:|no,|moc )%'  ;;
  }

  dimension: nutrition_status {
    type: string
    hidden: yes
    description: "Nutrition: What is the overall nutritional status of patient?"
    sql: ${TABLE}.nutrition_status ;;
  }

  dimension: safety_feeling {
    type: string
    description: "Social Support: Do you feel safe?"
    sql: ${TABLE}.safety_feeling ;;
  }

  measure: count_feels_unsafe {
    type: count_distinct
    description: "Count of patients who indicate 'N' when asked if they feel safe (does not include other free-form text)"
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
    filters: {
      field: safety_feeling
      value: "N"
    }
  }

  dimension: taking_advantage {
    type: string
    hidden: yes
    description: "Social Support: Do you feel that anyone is taking advantage of you?"
    sql: ${TABLE}.taking_advantage ;;
  }

  dimension: afford_medications {
    type: string
    hidden: yes
    description: "Financial: Can you afford the medications that your medical team has prescribed you?"
    sql: ${TABLE}.afford_medications ;;
  }

  dimension: cant_afford_medications_flag {
    type: yesno
    hidden: yes
    sql: ${afford_medications} = 'N' OR LOWER(${afford_medications}) SIMILAR TO '%(t afford|struggl)%';;
  }

  dimension: heavy_drinking {
    type: string
    hidden: yes
    description: "How many days in the past year have you had a heavy drinking consumption (4+ female, 5+ male)?"
    sql: ${TABLE}.heavy_drinking ;;
  }

  dimension: tobacco_yrs_of_use {
    type: string
    description: "Tobacco-years of use"
    sql: ${TABLE}.tobacco_yrs_of_use ;;
  }

  dimension: smoking_how_much {
    type: string
    description: "Smoking-How much?"
    sql: ${TABLE}.smoking_how_much ;;
  }

  dimension: current_smoker_flag {
    type: yesno
    sql: ${smoking_how_much} IS NOT NULL AND ${smoking_how_much} <> 'n' ;;
  }

  dimension: fall_hazards {
    type: string
    hidden: yes
    description: "Trip/Fall Hazards"
    sql: ${TABLE}.fall_hazards ;;
  }

  dimension: general_cleanliness {
    type: string
    hidden: yes
    description: "Review of the general cleanliness of the home"
    sql: ${TABLE}.general_cleanliness ;;
  }

  dimension: nutritional_status {
    type: string
    hidden: yes
    description: "Overall nutritional status of the patient"
    sql: ${TABLE}.nutritional_status ;;
  }

  dimension: cost_concerns {
    type: string
    sql: ${TABLE}.cost_concerns ;;
    description: "In the past year, have you been unable to get any of the following when it was really needed?"
  }

  dimension: cost_concerns_flag {
    type: yesno
    sql: ${cost_concerns} <> 'No' AND ${cost_concerns} <> 'Choose Not To Answer This Question'
    AND ${cost_concerns} IS NOT NULL ;;
  }

  measure: count_cost_concerns {
    type: count_distinct
    description: "Count of patients who indicate they have financial concerns"
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
    filters: {
      field: cost_concerns_flag
      value: "yes"
    }
  }

  dimension: home_situation {
    type: string
    hidden: yes
    sql: ${TABLE}.home_situation ;;
    description: "Home situation"
  }

  dimension: food_insecurity {
    type: string
    sql: CASE WHEN ${TABLE}.food_insecurity IN ('Yes','No') THEN ${TABLE}.food_insecurity
        ELSE NULL END ;;
    description: "Has it ever happened within the past 12 months that the food you bought
    just didn’t last, and you didn’t have money to get more?"
  }

  measure: count_food_insecurity {
    type: count_distinct
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
    filters: {
      field: food_insecurity
      value: "Yes"
    }
  }

  dimension: food_insecurity_worry {
    type: string
    sql: ${TABLE}.food_insecurity_worry ;;
    description: "Within the past 12 months we worried that our food would run out before we got money to buy more."
  }

  measure: count_food_insecurity_worry {
    type: count_distinct
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
    filters: {
      field: food_insecurity_worry
      value: "Yes"
    }
  }

  dimension: social_interactions {
    type: string
    sql: ${TABLE}.social_interactions ;;
    description: "How often do you have the opportunity to see or talk to people that you care about
    and feel close to?"
  }

  measure: count_lack_social_interactions {
    type: count_distinct
    description: "Count of patients who have social interactions less than once per week"
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
    filters: {
      field: social_interactions
      value: "Less Than Once Per Week"
    }
  }

  dimension: housing_insecurity {
    type: string
    sql: ${TABLE}.housing_insecurity ;;
    description: "Do you have any concerns about your current housing situation?"
  }

  dimension: housing_insecurity_flag {
    type: yesno
    sql: ${housing_insecurity} LIKE 'I Have Housing Today But%' OR
    ${housing_insecurity} LIKE 'I Do Not Have Housing%' OR
    ${housing_insecurity} LIKE 'Needs %';;
  }

  measure: count_lack_housing_security {
    type: count_distinct
    description: "Count of patients who have indicated they have housing insecurity"
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
    filters: {
      field: housing_insecurity_flag
      value: "yes"
    }
  }


  dimension: resource_help_requested {
    type: string
    sql: ${TABLE}.resource_help_requested ;;
    description: "Would you like help connecting to resources?"
  }

  dimension: resource_requested_flag {
    type: yesno
    sql: ${resource_help_requested} IN ('Food','Housing','Medicine','Transportation','Utilities (gas or heat)') ;;
  }

  measure: count_requested_resources {
    type: count_distinct
    description: "Count of patients who have indicated they would like to be connected to resources"
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
    filters: {
      field: resource_requested_flag
      value: "yes"
    }
  }

  dimension: overweight_obese_flag {
    type: yesno
    hidden: yes
    sql: LOWER(${nutrition_status}) SIMILAR TO '(overweight|obese)%' ;;
  }

  dimension: number_questions_asked {
    type: number
    sql:
      (CASE WHEN athenadwh_social_history_flat.review_date IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN smoking_status IS NULL AND smokeless_tobacco_use IS NULL AND vaping_status IS NULL AND
      tobacco_yrs_of_use IS NULL AND smoking_how_much IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN drugs_abused IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN marital_status IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN code_status IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN advance_directive IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN fall_risk_unsteady IS NULL AND fall_risk_provider IS NULL AND fall_risk_worry IS NULL AND fall_hazards IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN activities_daily_living IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN transportation IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN nutrition_access IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN safety_feeling IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN taking_advantage IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN afford_medications IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN heavy_drinking IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN general_cleanliness IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN cost_concerns IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN home_situation IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN food_insecurity IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN food_insecurity_worry IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN social_interactions IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN housing_insecurity IS NULL THEN 0 ELSE 1 END) +
      (CASE WHEN resource_help_requested IS NULL THEN 0 ELSE 1 END)
    ;;
  }

  measure: avg_questions_asked {
    type: average_distinct
    sql_distinct_key: ${chart_id} ;;
    sql: ${number_questions_asked} ;;
    value_format: "0.0"
  }

  dimension: number_questions_asked_primary_10_sdoh {
    type: number
    sql:
    (CASE WHEN ${fall_risk_unsteady} IS NULL THEN 0 ELSE 1 END) +
    (CASE WHEN ${activities_daily_living} IS NULL THEN 0 ELSE 1 END) +
    (CASE WHEN ${safety_feeling} IS NULL THEN 0 ELSE 1 END) +
    (CASE WHEN ${cost_concerns} IS NULL THEN 0 ELSE 1 END) +
    (CASE WHEN ${food_insecurity} IS NULL THEN 0 ELSE 1 END) +
    (CASE WHEN ${food_insecurity_worry} IS NULL THEN 0 ELSE 1 END) +
    (CASE WHEN ${social_interactions} IS NULL THEN 0 ELSE 1 END) +
    (CASE WHEN ${housing_insecurity} IS NULL THEN 0 ELSE 1 END) +
    (CASE WHEN ${resource_help_requested} IS NULL THEN 0 ELSE 1 END) +
    (CASE WHEN ${transportation} IS NULL THEN 0 ELSE 1 END)
    ;;
  }

  measure: avg_questions_asked_primary_10_sdoh {
    type: average_distinct
    sql_distinct_key: ${chart_id} ;;
    sql: ${number_questions_asked_primary_10_sdoh} ;;
    value_format: "0.0"
  }

  measure: count_one_or_more_10_SDOH_asked {
    label: "Count Distinct Charts Where One or More SDOH Questions Asked"
    description: "Counts the number of distinct patient charts where one or more of the primary SDOH questions were asked"
    type: count_distinct
    sql: ${chart_id} ;;
    value_format: "0"
    filters: {
      field: number_questions_asked_primary_10_sdoh
      value: ">0"
    }
  }

  measure: qn_asked_fall_risk_per_provider {
    type: count_distinct
    sql: ${chart_id} ;;
    filters: {
      field: fall_risk_provider
      value: "-NULL"
    }
  }

  measure: sdoh_qn_asked_fall_risk_unsteady {
    type: count_distinct
    sql: ${chart_id} ;;
    filters: {
      field: fall_risk_unsteady
      value: "-NULL"
    }
    }

  measure: sdoh_qn_asked_activities_daily_living {
    type: count_distinct
    sql: ${chart_id} ;;
    filters: {
      field: activities_daily_living
      value: "-NULL"
    }
  }

  measure: sdoh_qn_asked_safety_feeling {
    type: count_distinct
    sql: ${chart_id} ;;
    filters: {
      field: safety_feeling
      value: "-NULL"
    }
  }

  measure: sdoh_qn_asked_cost_concerns {
    type: count_distinct
    sql: ${chart_id} ;;
    filters: {
      field: cost_concerns
      value: "-NULL"
    }
  }

  measure: sdoh_qn_asked_food_insecurity {
    type: count_distinct
    sql: ${chart_id} ;;
    filters: {
      field: food_insecurity
      value: "-NULL"
    }
  }

  measure: sdoh_qn_asked_food_insecurity_worry {
    type: count_distinct
    sql: ${chart_id} ;;
    filters: {
      field: food_insecurity_worry
      value: "-NULL"
    }
  }

  measure: sdoh_qn_asked_social_interactions {
    type: count_distinct
    sql: ${chart_id} ;;
    filters: {
      field: social_interactions
      value: "-NULL"
    }
  }

  measure: sdoh_qn_asked_housing_insecurity {
    type: count_distinct
    sql: ${chart_id} ;;
    filters: {
      field: housing_insecurity
      value: "-NULL"
    }
  }

  measure: sdoh_qn_asked_resource_help_requested {
    type: count_distinct
    sql: ${chart_id} ;;
    filters: {
      field: resource_help_requested
      value: "-NULL"
    }
  }

  measure: sdoh_qn_asked_transportation {
    type: count_distinct
    sql: ${chart_id} ;;
    filters: {
      field: transportation
      value: "-NULL"
    }
  }

  measure: count_distinct_charts {
    type: count_distinct
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
  }

  measure: count_fall_risk_per_provider {
    type: count_distinct
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
    filters: {
      field: fall_risk_per_provider_flag
      value: "yes"
    }
  }

  measure: count_lack_of_transportation {
    type: count_distinct
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
    filters: {
      field: lack_of_transportation_flag
      value: "yes"
    }
  }

  measure: count_lack_of_access_healthy_foods {
    type: count_distinct
    hidden: yes
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
    filters: {
      field: lack_of_access_healthy_foods
      value: "yes"
    }
  }

  measure: count_cant_afford_medications {
    type: count_distinct
    hidden: yes
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
    filters: {
      field: cant_afford_medications_flag
      value: "yes"
    }
  }


}
