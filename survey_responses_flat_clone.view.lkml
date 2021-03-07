view: survey_responses_flat_clone {
  view_label: "ZZZZ - Survey Responses Flat Clone"
  derived_table: {
    sql:
      SELECT DISTINCT
          srf.visit_dim_number,
          srf.care_request_id,
          srf.visit_date,
          nps.answer_range_value AS nps_response,
          mnps.max_nps_answer_range_value,
          CASE
            WHEN v2.answer_selection_value = 'Yes' THEN 'Emergency Room'
            ELSE alt.answer_selection_value
          END AS alternative_dh_response,
          v2.answer_selection_value AS alternative_emergency_room,
          ovr.answer_selection_value AS overall_rating_response
          FROM (
            SELECT DISTINCT
              visit_dim_number,
              care_request_id,
              MAX(visit_date) AS visit_date
            FROM survey_response_facts_clone
            WHERE care_request_id IS NOT NULL
            GROUP BY 1,2
          ) srf
          LEFT JOIN survey_response_facts_clone nps
            ON srf.care_request_id = nps.care_request_id AND nps.question_dim_id = 4
          LEFT JOIN (SELECT
                    care_request_id,
                    MAX(answer_range_value) as max_nps_answer_range_value
            FROM survey_response_facts_clone
            WHERE question_dim_id = 4
            GROUP BY 1) mnps
            ON srf.care_request_id = mnps.care_request_id
          LEFT JOIN survey_response_facts_clone alt
            ON srf.care_request_id = alt.care_request_id AND alt.question_dim_id = 3
          LEFT JOIN survey_response_facts_clone ovr
            ON srf.care_request_id  = ovr.care_request_id AND ovr.question_dim_id = 5
          LEFT JOIN survey_response_facts_clone v2
            ON srf.care_request_id  = v2.care_request_id  AND v2.question_dim_id = 9
          ORDER BY care_request_id DESC  ;;

    sql_trigger_value: SELECT MAX(care_request_id) FROM survey_response_facts_clone ;;
    indexes: ["visit_dim_number", "care_request_id"]
  }

  dimension: care_request_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: visit_dim_number {
    type: number

    description: "Athena EHR ID"
    sql: ${TABLE}.visit_dim_number ;;
  }

  dimension: alternative_emergency_room {
    type: string
    description: "Responses to emergency room alternative"
    sql: ${TABLE}.alternative_emergency_room ;;
  }

  dimension: alternative_dh_response {
    type: string
    sql: ${TABLE}.alternative_dh_response ;;
  }

  dimension: answer_range_value {
    label: "NPS Selected Range Value"
    type: number
    sql: ${TABLE}.nps_response ;;
  }

  dimension: max_nps_answer_range_value {
    label: "Max NPS Selected Range Value"
    type: number
    sql: ${TABLE}.max_nps_answer_range_value ;;
  }

  dimension: promoter {
    label: "Promoter"
    type: yesno
    sql: ${max_nps_answer_range_value} > 8 AND ${max_nps_answer_range_value} IS NOT NULL;;
  }

  dimension: detractor {
    label: "Detractor"
    type: yesno
    sql: ${max_nps_answer_range_value} < 7 AND ${max_nps_answer_range_value} IS NOT NULL;;
  }

  dimension: nps_respondent {
    label: "NPS survey respondent"
    type: yesno
    sql: ${answer_range_value} IS NOT NULL;;
  }

  dimension: alternative_dh_respondent {
    label: "Alternative to DH survey respondent"
    type: yesno
    sql: ${alternative_emergency_room} IS NOT NULL OR ${alternative_dh_response} IS NOT NULL ;;
  }

  dimension: alternative_dh_emergency_room {
    type: yesno
    description: "Survey response that alternative to DispatchHealth = Emergency Room is yes"
    sql: ${alternative_emergency_room} = 'Yes' OR ${alternative_dh_response} = 'Emergency Room' ;;
  }

  measure: count_nps_respondent {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: nps_respondent
      value: "yes"
    }
  }

  measure: count_alternate_dh_respondent {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: alternative_dh_respondent
      value: "yes"
    }
  }

  measure: count_er_alternative {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: alternative_dh_emergency_room
      value: "yes"
    }
  }


  dimension: answer_selection_dh_alternative {
    label: "Selected Value Alternative to DH"
    type: string
    sql: CASE
          --WHEN ${alternative_dh_respondent} AND ${TABLE}.alternative_dh_response = 'Emergency Room' THEN ${TABLE}.alternative_dh_response
          --WHEN ${alternative_dh_respondent} AND ${TABLE}.alternative_dh_response <> 'Emergency Room' THEN 'Other'
          WHEN ${alternative_dh_respondent} THEN ${TABLE}.alternative_dh_response
          ELSE 'No Survey Response'
        END ;;
  }

  dimension: answer_selection_overall {
    label: "Selected Value Overall Rating"
    type: string
    sql: ${TABLE}.overall_rating_response ;;
  }

  measure: distinct_promoters{
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: promoter
      value: "yes"
    }
  }

  measure: distinct_detractors{
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: detractor
      value: "yes"
    }
  }

  measure: distinct_nps_respondent{
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: nps_respondent
      value: "yes"
    }
  }

# Currently doesn't work - Needs division by zero fixed
  measure: nps_score {
    type: number
    value_format: "0"
    # sql: CASE
    #       WHEN ${distinct_nps_respondent} > 0 THEN ((${distinct_promoters} -${distinct_detractors})/${distinct_nps_respondent})*100
    #       ELSE 0
    #     END ;;

    sql: CASE WHEN ${distinct_nps_respondent} > 0 THEN
         (COUNT(DISTINCT CASE WHEN ${promoter} THEN ${care_request_id} ELSE NULL END)::float(4)
         - COUNT(DISTINCT CASE WHEN ${detractor} THEN ${care_request_id} ELSE NULL END)::float(4))*100
         / COUNT(DISTINCT ${care_request_id})::float(4)
        ELSE NULL END ;;
  }

  measure: count_respondents {
    type: count_distinct
    sql: ${care_request_id} ;;
  }

}
