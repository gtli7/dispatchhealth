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
      ELSE INITCAP(${TABLE}.protocol_name)
    END;;
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
    type: average
    sql: ${score} ;;
  }

  dimension: risk_category {
    type: string
    sql: CASE
          WHEN ${score} >= 0 AND ${score} <= 5 THEN 'Green - Low Risk'
          WHEN ${score} > 5 AND ${score} < 10 THEN 'Yellow - Medium Risk'
          WHEN ${score} >= 10 THEN 'Red - High Risk'
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


  measure: count_yellow_escalated_phone {
    type: count_distinct
    sql: case when ${care_request_flat.escalated_on_phone} and ${yellow_category}  then ${care_request_id}  else null end ;;
    sql_distinct_key: ${care_request_id} ;;
  }

  measure: count_red_escalated_phone {
    type: count_distinct
    sql: case when ${care_request_flat.escalated_on_phone} and ${red_category}  then ${care_request_id}  else null end ;;
    sql_distinct_key: ${care_request_id} ;;

  }

  measure: count_green_escalated_phone {
    type: count_distinct
    sql: case when ${care_request_flat.escalated_on_phone} and ${green_category}  then ${care_request_id}  else null end ;;
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
