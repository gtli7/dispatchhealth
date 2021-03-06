view: rs_block_group_facts {
  sql_table_name: looker_demographic.fast_facts ;;

  dimension: logrecno_bg_map_block_group {
    hidden: yes
    type: number
    sql: ${TABLE}.logrecno_bg_map_block_group ;;
    primary_key: yes
  }

  measure: total_population {
    description: "Total Population"
    type: sum
    sql: CAST(${TABLE}.total_population AS DECIMAL);;
  }

  # Household Measures
  measure: housing_units {
    type: sum
    group_label: "Households"
    sql: CAST(${TABLE}.housing_units AS DECIMAL) ;;
  }
  measure: avg_persons_house {
    type: number
    group_label: "Households"
    label: "Average Persons per Household"
    sql: ${total_population}/nullif(${housing_units}, 0) ;;
    value_format_name: decimal_2
  }

  # Income Measure
  measure: aggregate_income {
    hidden: yes
    type: sum
    group_label: "Households"
    sql: CAST(${TABLE}.aggregate_income as DECIMAL) ;;
  }

  measure: avg_income_house {
    type: number
    group_label: "Households"
    label: "Average Income per Household"
    sql: ${aggregate_income}/nullif(${housing_units}, 0) ;;
    value_format_name: usd_0
  }

  # Sex Measures
  measure: female_population {
    type: sum
    sql: CAST(${TABLE}.female AS DECIMAL) ;;
    group_label: "Sex"
  }
  measure: male_population {
    type: sum
    sql: CAST(${TABLE}.male AS DECIMAL) ;;
    group_label: "Sex"
  }
  measure:  pct_male{
    type: number
    label: "Male % of Population"
    group_label: "Sex"
    sql: ${male_population}/nullif(${total_population}, 0) ;;
    value_format_name: percent_2
  }
  measure:  pct_female{
    type: number
    label: "Female % of Population"
    group_label: "Sex"
    sql: ${female_population}/nullif(${total_population}, 0) ;;
    value_format_name: percent_2
  }

  # Racial Measures

  measure: white_alone_or_in_combo {
    label: "White Population (Alone or in Combo with Other Races)"
    group_label: "Race"
    type: sum
    sql: CAST(${TABLE}.white_alone_or_in_combo AS DECIMAL) ;;
  }
  measure: black_alone_or_in_combo {
    label: "Black or African American Population (Alone or in Combo with Other Races)"
    group_label: "Race"
    type: sum
    sql: CAST(${TABLE}.black_alone_or_in_combo AS DECIMAL) ;;
  }
  measure: amind_alone_or_in_combo {
    label: "American Indian or Native Alaskan Population (Alone or in Combo with Other Races)"
    group_label: "Race"
    type: sum
    sql: CAST(${TABLE}.amind_alone_or_in_combo AS DECIMAL) ;;
  }
  measure: asian_alone_or_in_combo {
    label: "Asian Population (Alone or in Combo with Other Races)"
    group_label: "Race"
    type: sum
    sql: CAST(${TABLE}.asian_alone_or_in_combo AS DECIMAL) ;;
  }
  measure: nat_haw_alone_or_in_combo {
    label: "Native Hawaiian or Other Pacific Islander (Alone or in Combo with Other Races)"
    group_label: "Race"
    type: sum
    sql: CAST(${TABLE}.nat_haw_alone_or_in_combo AS DECIMAL) ;;
  }
  measure: white_non_hisp {
    label: "White, Non-Hispanic Population"
    group_label: "Race"
    type: sum
    sql: CAST(${TABLE}.white_non_hisp AS DECIMAL) ;;
  }
  measure: pct_white {
    label: "White % of Population"
    group_label: "Race"
    type: number
    value_format_name: percent_2
    sql: ${white_alone_or_in_combo}/nullif(${total_population}, 0) ;;
  }
  measure: pct_black {
    label: "Black/African American % of Population"
    group_label: "Race"
    type: number
    value_format_name: percent_2
    sql: ${black_alone_or_in_combo}/nullif(${total_population}, 0) ;;
  }
  measure: pct_asian {
    label: "Asian % of Population"
    group_label: "Race"
    type: number
    value_format_name: percent_2
    sql: ${asian_alone_or_in_combo}/nullif(${total_population}, 0) ;;
  }
  measure: pct_amind {
    label: "American Indian or Native Alaskan % of Population"
    group_label: "Race"
    type: number
    value_format_name: percent_2
    sql: ${amind_alone_or_in_combo}/nullif(${total_population}, 0) ;;
  }
  measure: pct_nathaw {
    label: "Native Hawaiian or Other Pacific Islander % of Population"
    group_label: "Race"
    type: number
    value_format_name: percent_2
    sql: ${nat_haw_alone_or_in_combo}/nullif(${total_population}, 0) ;;
  }
  measure: pct_white_nh {
    label: "White, Non-Hispanic % of Population"
    group_label: "Race"
    type: number
    value_format_name: percent_2
    sql: ${white_non_hisp}/nullif(${total_population}, 0) ;;
  }

  measure: hispanic_or_latino {
    label: "Hispanic or Latino Population (Any Race)"
    type: sum
    sql: CAST(${TABLE}.hispanic_or_latino AS DECIMAL) ;;
    group_label: "Hispanic/Latino"
  }
  measure: pct_hispanic_or_latino {
    label: "Hispanic or Latino % of Population (Any Race)"
    type: number
    sql: ${hispanic_or_latino}/nullif(${total_population}, 0) ;;
    group_label: "Hispanic/Latino"
    value_format_name: percent_2
  }
  measure: pct_non_hispanic_or_latino {
    label: "Non-Hispanic, Non-Latino % of Population (Any Race)"
    type: number
    sql: 1-(${hispanic_or_latino}/nullif(${total_population}, 0)) ;;
    group_label: "Hispanic/Latino"
    value_format_name: percent_2
  }
  measure: pct_white_nh2 {
    label: "White, Non-Hispanic % of Population"
    group_label: "Hispanic/Latino"
    type: number
    value_format_name: percent_2
    sql: ${white_non_hisp}/nullif(${total_population}, 0) ;;
  }

  measure: under_18 {
    label: "Population 17 years and younger"
    type: sum
    sql: CAST(${TABLE}.under_18 AS DECIMAL) ;;
    group_label: "Age"
  }
  measure: eighteen_to_64 {
    label: "Population 18 to 64 years"
    type: sum
    sql: CAST(${TABLE}.eighteen_to_64 AS DECIMAL) ;;
    group_label: "Age"
  }
  measure: sixty_five_and_over {
    label: "Population 65 years and older"
    type: sum
    sql: CAST(${TABLE}.sixty_five_and_over AS DECIMAL) ;;
    group_label: "Age"
  }
  measure: pct_under_18 {
    label: "% of Population 17 years and younger"
    type: number
    sql: ${under_18}/nullif(${total_population}, 0) ;;
    group_label: "Age"
    value_format_name: percent_2
  }
  measure: pct_18_64 {
    label: "% of Population 18 and 64 years"
    type: number
    sql: ${eighteen_to_64}/nullif(${total_population}, 0) ;;
    group_label: "Age"
    value_format_name: percent_2
  }
  measure: pct_65_over {
    label: "% of Population 65 and older"
    type: number
    sql: ${sixty_five_and_over}/nullif(${total_population}, 0) ;;
    group_label: "Age"
    value_format_name: percent_2
  }
}
