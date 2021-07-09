view: zipcode_summary {
  derived_table: {
    sql:
           select *,  ROW_NUMBER() OVER(PARTITION BY (market)
                                ORDER BY zipcode_score DESC) as zipcode_rank,
                                PERCENT_RANK() OVER(PARTITION BY (market)
                                ORDER BY zipcode_score DESC) as zipcode_percentile
from
(select
        *,
          2.5*medicare_advantage_part_c_drg_percent_stds+
          2.5*complete_count_ma_percent_stds+
         -2.0*average_drive_time_minutes_stds+
          0.5*population_drg_stds+
          1.0*rank_1_10_propensity_stds+
          1.0*sf_community_broad_density_stds as zipcode_score
from looker_scratch.zipcode_summary)lq;;
  }


  dimension: complete_count_ma_percent_stds {
    type: number
    sql: ${TABLE}."complete_count_ma_percent_stds" ;;
  }

  dimension: complete_count_ma_percent_total {
    type: number
    sql: ${TABLE}."complete_count_ma_percent_total" ;;
  }

  dimension: complete_count_ma_stds {
    type: number
    sql: ${TABLE}."complete_count_ma_stds" ;;
  }

  dimension: complete_count_ma_total {
    type: number
    sql: ${TABLE}."complete_count_ma_total" ;;
  }

  dimension: complete_count_stds {
    type: number
    sql: ${TABLE}."complete_count_stds" ;;
  }

  dimension: complete_count_total {
    type: number
    sql: ${TABLE}."complete_count_total" ;;
  }

  dimension: medicare_advantage_part_c_drg_percent_stds {
    type: number
    sql: ${TABLE}."medicare_advantage_part_c_drg_percent_stds" ;;
  }

  dimension: medicare_advantage_part_c_drg_percent_total {
    type: number
    sql: ${TABLE}."medicare_advantage_part_c_drg_percent_total" ;;
  }

  dimension: medicare_advantage_part_c_drg_stds {
    type: number
    sql: ${TABLE}."medicare_advantage_part_c_drg_stds" ;;
  }

  dimension: medicare_advantage_part_c_drg_total {
    type: number
    sql: ${TABLE}."medicare_advantage_part_c_drg_total" ;;
  }

  dimension: population_drg_stds {
    type: number
    sql: ${TABLE}."population_drg_stds" ;;
  }

  dimension: population_drg_total {
    type: number
    sql: ${TABLE}."population_drg_total" ;;
  }

  dimension: rank_1_10_propensity_percent_stds {
    type: number
    sql: ${TABLE}."rank_1_10_propensity_percent_stds" ;;
  }

  dimension: rank_1_10_propensity_percent_total {
    type: number
    sql: ${TABLE}."rank_1_10_propensity_percent_total" ;;
  }

  dimension: rank_1_10_propensity_stds {
    type: number
    sql: ${TABLE}."rank_1_10_propensity_stds" ;;
  }

  dimension: rank_1_10_propensity_total {
    type: number
    sql: ${TABLE}."rank_1_10_propensity_total" ;;
  }

  dimension: total_propensity_stds {
    type: number
    sql: ${TABLE}."total_propensity_stds" ;;
  }

  dimension: total_propensity_total {
    type: number
    sql: ${TABLE}."total_propensity_total" ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}."zipcode" ;;
  }

  dimension: market {
    type: zipcode
    sql: ${TABLE}."market" ;;
  }

  dimension: primary_key {
    type: string
    sql: concat(${market}, ${zipcode}) ;;
  }

  dimension: average_drive_time_minutes_stds {
    type: number
    sql: ${TABLE}.average_drive_time_minutes_stds ;;
  }

  dimension: aland_sqmi_stds {
    type: number
    sql: ${TABLE}.aland_sqmi_stds ;;
  }

  dimension: aland_sqmi_total {
    type: number
    sql: ${TABLE}.aland_sqmi_total ;;
  }

  dimension: density_stds {
    type: number
    sql: ${TABLE}.density_stds ;;
  }

  dimension: density_total {
    type: number
    sql: ${TABLE}.density_total ;;
  }

  dimension: sf_community_broad_density_stds {
    type: number
    sql: ${TABLE}.sf_community_broad_density_stds ;;
  }

  dimension: sf_community_broad_density_total {
    type: number
    sql: ${TABLE}.sf_community_broad_density_total ;;
  }

  dimension: count_sf_community_broad_total {
    type: number
    sql: ${TABLE}.count_sf_community_broad_total ;;
  }

  dimension: count_sf_community_broad_stds {
    type: number
    sql: ${TABLE}.count_sf_community_broad_stds ;;
  }

  dimension: sf_hospitals_density_stds {
    type: number
    sql: ${TABLE}.sf_hospitals_density_stds ;;

  }

  dimension: sf_hospitals_density_total{
    type: number
    sql: ${TABLE}.sf_hospitals_density_total ;;

  }

  dimension: count_sf_hospitals_stds {
    type: number
    sql: ${TABLE}.count_sf_hospitals_stds ;;

  }

  dimension: count_sf_hospitals_total{
    type: number
    sql: ${TABLE}.count_sf_hospitals_total ;;

  }

  measure: count {
    type: count
    drill_fields: []
  }

  dimension: all_ratio_score {
    type: number
    sql: ${complete_count_stds}+
      ${complete_count_ma_stds}+
      ${population_drg_stds}+
      ${medicare_advantage_part_c_drg_stds}+
      ${total_propensity_stds}+
      ${rank_1_10_propensity_stds}+
      ${complete_count_ma_percent_stds}+
      ${medicare_advantage_part_c_drg_percent_stds}+
      ${rank_1_10_propensity_percent_stds}+
      ${density_stds}+
      ${aland_sqmi_stds}+
      ${average_drive_time_minutes_stds}*-1+
      ${sf_community_broad_density_stds}+
      ${count_sf_community_broad_stds}+
      ${count_sf_hospitals_stds}+
      ${sf_hospitals_density_stds};;
  }

  dimension: zipcode_score {
    type: number
    sql:  ${TABLE}.zipcode_score
          ;;
  }
  dimension: zipcode_rank {
    type: number
    sql:         ${TABLE}.zipcode_rank ;;
  }

  dimension: zipcode_percentile {
    value_format: "0%"
    type: number
    sql:         ${TABLE}.zipcode_percentile ;;
  }


}
