view: survey_responses_flat {
  derived_table: {
    sql:
      SELECT
          srf.visit_dim_number,
          srf.care_request_id,
          srf.visit_date,
          nps.answer_range_value AS nps_response,
          alt.answer_selection_value AS alternative_dh_response,
          ovr.answer_selection_value AS overall_rating_response
          FROM survey_response_facts srf
          LEFT JOIN survey_response_facts nps
            ON srf.visit_dim_number = nps.visit_dim_number  AND nps.question_dim_id = 4
          LEFT JOIN survey_response_facts alt
            ON srf.visit_dim_number  = alt.visit_dim_number  AND alt.question_dim_id = 3
          LEFT JOIN survey_response_facts ovr
            ON srf.visit_dim_number  = ovr.visit_dim_number  AND ovr.question_dim_id = 5 ;;
  }


  dimension: visit_dim_number {
    type: number
    primary_key: yes
    description: "Athena EHR ID"
    sql: ${TABLE}.visit_dim_number ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: answer_open_ended_value {
    label: "Open End Value Answer"
    type: string
    sql: ${TABLE}.answer_open_ended_value ;;
  }

  dimension: answer_range_value {
    label: "NPS Selected Range Value"
    type: number
    sql: ${TABLE}.nps_response ;;
  }

  dimension: promoter {
    label: "Promoter"
    type: yesno
    sql: ${answer_range_value} > 8 AND ${answer_range_value} IS NOT NULL;;
  }

  dimension: detractor {
    label: "Detractor"
    type: yesno
    sql: ${answer_range_value} < 7 AND ${answer_range_value} IS NOT NULL;;
  }

  dimension: nps_respondent {
    label: "NPS survey respondent"
    type: yesno
    sql: ${answer_range_value} IS NOT NULL;;
  }

  dimension: answer_selection_dh_alternative {
    label: "Selected Value Alternative to DH"
    type: string
    sql: ${TABLE}.alternative_dh_response ;;
  }

  dimension: answer_selection_overall {
    label: "Selected Value Overall Rating"
    type: string
    sql: ${TABLE}.overall_rating_response ;;
  }
  measure: nps_score {
    type: number
    label: "0.00"
    sql: ((${promoter} -${detractor})/${nps_respondent})*100;;
  }

}
