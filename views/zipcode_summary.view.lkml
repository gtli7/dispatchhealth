view: zipcode_summary {
  sql_table_name: looker_scratch.zipcode_summary ;;

  dimension: complete_count_ma_percent_ratio_to_average {
    type: number
    sql: ${TABLE}."complete_count_ma_percent_ratio_to_average" ;;
  }

  dimension: complete_count_ma_percent_total {
    type: number
    sql: ${TABLE}."complete_count_ma_percent_total" ;;
  }

  dimension: complete_count_ma_ratio_to_average {
    type: number
    sql: ${TABLE}."complete_count_ma_ratio_to_average" ;;
  }

  dimension: complete_count_ma_total {
    type: number
    sql: ${TABLE}."complete_count_ma_total" ;;
  }

  dimension: complete_count_ratio_to_average {
    type: number
    sql: ${TABLE}."complete_count_ratio_to_average" ;;
  }

  dimension: complete_count_total {
    type: number
    sql: ${TABLE}."complete_count_total" ;;
  }

  dimension: medicare_advantage_part_c_drg_percent_ratio_to_average {
    type: number
    sql: ${TABLE}."medicare_advantage_part_c_drg_percent_ratio_to_average" ;;
  }

  dimension: medicare_advantage_part_c_drg_percent_total {
    type: number
    sql: ${TABLE}."medicare_advantage_part_c_drg_percent_total" ;;
  }

  dimension: medicare_advantage_part_c_drg_ratio_to_average {
    type: number
    sql: ${TABLE}."medicare_advantage_part_c_drg_ratio_to_average" ;;
  }

  dimension: medicare_advantage_part_c_drg_total {
    type: number
    sql: ${TABLE}."medicare_advantage_part_c_drg_total" ;;
  }

  dimension: population_drg_ratio_to_average {
    type: number
    sql: ${TABLE}."population_drg_ratio_to_average" ;;
  }

  dimension: population_drg_total {
    type: number
    sql: ${TABLE}."population_drg_total" ;;
  }

  dimension: rank_1_10_propensity_percent_ratio_to_average {
    type: number
    sql: ${TABLE}."rank_1_10_propensity_percent_ratio_to_average" ;;
  }

  dimension: rank_1_10_propensity_percent_total {
    type: number
    sql: ${TABLE}."rank_1_10_propensity_percent_total" ;;
  }

  dimension: rank_1_10_propensity_ratio_to_average {
    type: number
    sql: ${TABLE}."rank_1_10_propensity_ratio_to_average" ;;
  }

  dimension: rank_1_10_propensity_total {
    type: number
    sql: ${TABLE}."rank_1_10_propensity_total" ;;
  }

  dimension: total_propensity_ratio_to_average {
    type: number
    sql: ${TABLE}."total_propensity_ratio_to_average" ;;
  }

  dimension: total_propensity_total {
    type: number
    sql: ${TABLE}."total_propensity_total" ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}."zipcode" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  dimension: zipcode_score {
    type: number
    sql: ${complete_count_ratio_to_average}+
${complete_count_ma_ratio_to_average}+
${population_drg_ratio_to_average}+
${medicare_advantage_part_c_drg_ratio_to_average}+
${total_propensity_ratio_to_average}+
${rank_1_10_propensity_ratio_to_average}+
${complete_count_ma_percent_ratio_to_average}+
${medicare_advantage_part_c_drg_percent_ratio_to_average}+
${rank_1_10_propensity_percent_ratio_to_average} ;;
  }
}
