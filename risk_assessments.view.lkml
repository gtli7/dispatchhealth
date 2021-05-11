view: risk_assessments {
  sql_table_name: public.risk_assessments ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: protocol_name {
    type: string
    sql: CASE
      WHEN ${TABLE}.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
      WHEN ${TABLE}.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
      WHEN ${TABLE}.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
      ELSE INITCAP(split_part(lower(${TABLE}.protocol_name),' (non covid-19)',1))
    END;;
  }

  dimension: tele_eligible_protocol {
    type: yesno
    sql: ${protocol_name} in('General Complaint', 'Sore Throat', 'Sore Throat 2', 'Headache', 'Ear Pain', 'Rash', 'Rash - Pediatric', 'Cough/Upper Respiratory Symptoms', 'Cough/Upper Respiratory Infection', 'Cough/Uri', 'Rash', 'Rash - Pediatric', 'Sinus Pain', 'Flu-Like Symptoms', 'Post-Acute Patient Follow Up (Post Hospital/Skilled Nursing Facility/Rehabilitation Facility Discharge Patient)', 'Wound Evaluation', 'Dental/Oral Pain', 'Fever', 'Pain With Urinating And/Or Blood In Urine', 'Pain With Urinating And/Or Blood In Urine (Non Covid-19)', 'Ear Pain (Non Covid-19)', 'Allergic Reaction', 'Dental/Oral Pain (Non Covid-19)', 'Sinus Pain (Non Covid-19)', 'Cough/Upper Respiratory Symptoms  (Non Covid-19)', 'Wound Evaluation (Non Covid-19)', 'Shortness Of Breath', 'Shortness Of Breath (Non Covid-19)', 'Dispatchhealth Acute Care - Follow Up Visit', 'Dispatchhealth Acute Care - Follow Up Visit (Non Covid-19)', 'Back Pain', 'Back Pain (Non Covid-19)', 'Neck/Spine Pain', 'Neck/Spine Pain (Non Covid-19)', 'Fall - Without Injury', 'Constipation', 'Constipation (Non Covid-19)', 'Rash (Non Covid-19)', 'Vision/Eye Problem', 'Vision/Eye Problem (Non Covid-19)', 'Skin Rash(Cellulitis)/Skin Abscesses - Extremities, Torso (Trunk)', 'Skin Rash(Cellulitis)/Skin Abscesses - Extremities, Torso (Trunk) (Non Covid-19)', 'Fever (Non Covid-19)', 'Diarrhea', 'Diarrhea (Non Covid-19)', 'Nausea/Vomiting', 'Nausea/Vomiting (Non Covid-19)', 'Abdominal Pain', 'Abdominal Pain (Non Covid-19)', 'Extremity Injury/Pain', 'Extremity Injury/Pain (Non Covid-19)', 'Extremity Swelling', 'Covid-19 Testing Request (For Patients Without Symptoms)', 'Post-Acute Patient', 'Post-Acute Patient (Post Hospital Discharge Patient)', 'Post-Acute Patient (Post Hospital/Skilled Nursing Facility/Rehabilitation Facility Discharge Patient)') ;;
  }

  dimension: communicable_protocol{
    type: yesno
    sql: trim(lower(${protocol_name})) in('cough/upper respiratory infection', 'cough/upper respiratory symptoms', 'nausea/vomiting', 'fever', 'flu-like symptoms', 'sore throat', 'cough/uri', 'diarrhea', 'nausea/vomiting (non covid-19)', 'cough/upper respiratory symptoms  (non covid-19)') ;;
  }

  dimension: asymptomatic_covid_testing {
    type: yesno
    sql: lower(${protocol_name}) in('covid-19 testing request (for patients without symptoms)');;
  }

  dimension: advanced_care_protocol {
    type: yesno
    sql: trim(lower(${protocol_name})) in(
          'cough/upper respiratory symptoms',
          'dehydration',
          'extremity swelling',
          'fever',
          'flu-like symptoms',
          'general respiratory complaint - senior living',
          'hypotension (low blood pressure)',
          'pain with urinating and/or blood in urine',
          'rash',
          'shortness of breath',
          'skin rash(cellulitis)/skin abscesses - extremities, torso (trunk)',
          'unable to urinate',
          'wound evaluation',
          'dispatchhealth acute care - follow up visit');;
  }




  measure: protocol_count {
    type: count_distinct
    sql: ${protocol_name} ;;
  }

  dimension: general_complaint {
    type: yesno
    sql: UPPER(${protocol_name}) = 'GENERAL COMPLAINT' ;;
  }

  dimension: age_impacted_protocol {
    type: yesno
    sql: lower(${TABLE}.protocol_name) in('extremity swelling', 'extremity injury', 'weakness', 'uti/blood in urine', 'diarrhea', 'n/v', 'constipation', 'lethargic', 'fall', 'chest pain', 'syncope', 'abdominal pain', 'allergic reaction', 'palpitations', 'numbness', 'head injury', 'blood in stool', 'confusion', 'fever', 'wound eval', 'back pain', 'neck/spine pain', 'dehydration', 'cough/uri', 'dizziness', 'blood sugar issues', 'general complaint', 'blood sugar concerns', 'nausea/vomiting', 'syncope (passing out)', 'urinary tract infection', 'urinary tract infection and blood in urine', 'wound evaluation')
 ;;
  }

  measure: count_general_complaint {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: general_complaint
      value: "yes"
    }
  }

  measure: general_complaint_percent{
    type: number
    value_format: "0.0%"
    sql: (${count_general_complaint}::float/${count_distinct}::float) ;;
  }

  dimension: responses {
    type: string
    sql: ${TABLE}.responses ;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}.score ;;
  }

  dimension: score_old {
    type: number
    sql: case
              when not ${age_impacted_protocol} then ${score}
              when ${age_impacted_protocol} and ${patients.age} < 60 then ${score}-.5
              when ${age_impacted_protocol} and ${patients.age} between 60 and 69 then ${score}-1
              when ${age_impacted_protocol} and ${patients.age} between 70 and 79 then ${score}-1.5
              when ${age_impacted_protocol} and ${patients.age} >=80 then ${score}-2
              else ${score} end

    ;;
  }

  measure: average_score {
    type: average_distinct
    value_format: "0.0"
    sql_distinct_key: ${id} ;;
    sql: ${score} ;;
  }

  dimension: risk_category {
    type: string
    description: "0 - 5.4 = Green, 5.5 - 9.9 = Yellow, 10+ = Red"
    sql: CASE
          WHEN ${score} >= 0 AND ${score} < 5.5 THEN 'Green - Low Risk'
          WHEN ${score} >= 5.5 AND ${score} <= 10 THEN 'Yellow - Medium Risk'
          WHEN ${score} > 10 THEN 'Red - High Risk'
          ELSE 'Unknown'
        END ;;
  }

  dimension: risk_category_old {
    type: string
    sql: CASE
          WHEN ${score_old} >= 0 AND ${score_old} <= 5 THEN 'Green - Low Risk'
          WHEN ${score_old} > 5 AND ${score_old} < 10 THEN 'Yellow - Medium Risk'
          WHEN ${score_old} >= 10 THEN 'Red - High Risk'
          ELSE 'Unknown'
        END ;;
  }

  dimension: green_category {
    type: yesno
    sql: ${risk_category} = 'Green - Low Risk' ;;
  }

  measure: count_green {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: green_category
      value: "yes"
    }
  }

  dimension: green_category_old {
    type: yesno
    sql: ${risk_category_old} = 'Green - Low Risk' ;;
  }

  measure: count_green_old {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: green_category_old
      value: "yes"
    }
  }

  dimension: yellow_category {
    type: yesno
    sql: ${risk_category} = 'Yellow - Medium Risk' ;;
  }

  dimension: worst_case_score {
    type: number
    description: "The worst case score if certain risk questions are not answered"
    sql: ${TABLE}.worst_case_score ;;
  }

  dimension: requires_secondary_screening {
    type: yesno
    description: "The risk score OR the worst case score is between 5.5 and 9.99 OR the visit ID is in the secondary screenings table"
    sql: ${yellow_category} OR (${worst_case_score} >= 5.5 AND NOT ${red_category}) OR ${secondary_screenings.care_request_id} IS NOT NULL ;;
  }

  measure: count_requires_secondary_screening {
    description: "Count of all care requests that require secondary screening"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: requires_secondary_screening
      value: "yes"
    }
  }

  dimension: yellow_category_old {
    type: yesno
    sql: ${risk_category_old} = 'Yellow - Medium Risk' ;;
  }

  measure: count_yellow {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: yellow_category
      value: "yes"
    }
  }

  measure: count_yellow_old {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: yellow_category_old
      value: "yes"
    }
  }



  measure: count_yellow_escalated_phone_incontact {
    type: count_distinct
    sql: case when ${care_request_flat_exact.escalated_on_phone_ed} and ${yellow_category}  then ${care_request_id}  else null end ;;
    sql_distinct_key: ${care_request_id} ;;
  }

  measure: count_red_escalated_phone_incontact {
    type: count_distinct
    sql: case when ${care_request_flat_exact.escalated_on_phone_ed} and ${red_category}  then ${care_request_id}  else null end ;;
    sql_distinct_key: ${care_request_id} ;;

  }

  measure: count_green_escalated_phone_incontact {
    type: count_distinct
    sql: case when ${care_request_flat_exact.escalated_on_phone_ed} and ${green_category}  then ${care_request_id}  else null end ;;
    sql_distinct_key: ${care_request_id} ;;
  }


  measure: count_green_escalated_phone {
    type: count_distinct
    label: "Count Green Escalated Phone ED"
    sql: ${care_request_id} ;;
    filters: {
      field: care_request_flat.escalated_on_phone_ed
      value: "yes"
    }
    filters: {
      field: green_category
      value: "yes"
    }
    sql_distinct_key: ${care_request_id} ;;

  }

  measure: non_screened_count_green_escalated_phone {
    type: count_distinct
    label: "Non-Screened Count Green Escalated Phone ED"
    sql: ${care_request_id} ;;
    filters: {
      field: care_request_flat.escalated_on_phone_ed
      value: "yes"
    }

    filters: {
      field: care_request_flat.secondary_screening
      value: "no"
    }

    filters: {
      field: green_category
      value: "yes"
    }
    sql_distinct_key: ${care_request_id} ;;

  }

  measure: non_screened_count_yellow_escalated_phone {
    type: count_distinct
    label: "Non-Screened Count Yellow Escalated Phone ED"
    sql: ${care_request_id} ;;
    filters: {
      field: care_request_flat.escalated_on_phone_ed
      value: "yes"
    }

    filters: {
      field: care_request_flat.secondary_screening
      value: "no"
    }

    filters: {
      field: yellow_category
      value: "yes"
    }
    sql_distinct_key: ${care_request_id} ;;

  }

  measure: non_screened_count_red_escalated_phone {
    type: count_distinct
    label: "Non-Screened Count Red Escalated Phone ED"
    sql: ${care_request_id} ;;
    filters: {
      field: care_request_flat.escalated_on_phone_ed
      value: "yes"
    }

    filters: {
      field: care_request_flat.secondary_screening
      value: "no"
    }

    filters: {
      field: red_category
      value: "yes"
    }
    sql_distinct_key: ${care_request_id} ;;

  }


  measure: count_yellow_escalated_phone {
    type: count_distinct
    label: "Count Yellow Escalated Phone ED"
    sql: ${care_request_id} ;;
    filters: {
      field: care_request_flat.escalated_on_phone_ed
      value: "yes"
    }
    filters: {
      field: yellow_category
      value: "yes"
    }
    sql_distinct_key: ${care_request_id} ;;

  }


  measure: count_red_escalated_phone {
    type: count_distinct
    label: "Count Red Escalated Phone ED"
    sql: ${care_request_id} ;;
    filters: {
      field: care_request_flat.escalated_on_phone_ed
      value: "yes"
    }
    filters: {
      field: red_category
      value: "yes"
    }
    sql_distinct_key: ${care_request_id} ;;

  }


  dimension: red_category {
    type: yesno
    sql: ${risk_category} = 'Red - High Risk' ;;
  }
  dimension: red_category_old {
    type: yesno
    sql: ${risk_category_old} = 'Red - High Risk' ;;
  }

  measure: count_red {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: red_category
      value: "yes"
    }
  }

  measure: count_red_old {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: red_category_old
      value: "yes"
    }
  }

  measure: count_distinct {
    type: count_distinct
    sql: ${care_request_id} ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, protocol_name]
  }
}
