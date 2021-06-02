view: diversions_final_redshift {
  sql_table_name: cost_savings.stg_diversions_final ;;

  dimension: care_request_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: div_911 {
    type: number
    label: "911 Diversion (0/1)"
    description: "Boolean indicating the visit would have resulted in a 911 diversion"
    sql: ${TABLE}.div_911 ;;
  }

  dimension: div_911_prob {
    type: number
    label: "911 Diversion (Probability)"
    description: "Probability that the visit would have resulted in a 911 diversion"
    sql: ${TABLE}.div_911_prob ;;
  }

  measure: count_911_diversions {
    type: count_distinct
    description: "Count of all 911 diversions"
    sql: ${care_request_id} ;;
    filters: [div_911: ">0"]
  }

  measure: sum_911_diversion_probs {
    type: sum_distinct
    sql: ${div_911_prob} ;;
    sql_distinct_key: ${care_request_id} ;;
  }

  dimension: div_er {
    type: number
    sql: ${TABLE}.div_er ;;
  }

  dimension: div_er_prob {
    type: number
    sql: ${TABLE}.div_er_prob ;;
  }

  dimension: div_hosp {
    type: number
    sql: ${TABLE}.div_hosp ;;
  }

  dimension: div_hosp_prob {
    type: number
    sql: ${TABLE}.div_hosp_prob ;;
  }

  dimension: div_obs {
    type: number
    sql: ${TABLE}.div_obs ;;
  }

  dimension: div_obs_prob {
    type: number
    sql: ${TABLE}.div_obs_prob ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
