view: drg_insurance_data {
  sql_table_name: looker_scratch.drg_insurance_data ;;

  dimension: commercial_fi {
    type: number
    sql: ${TABLE}."commercial_fi" ;;
  }

  dimension: county {
    type: string
    sql: ${TABLE}."county" ;;
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."date" ;;
  }

  dimension: dual_eligible {
    type: number
    sql: ${TABLE}."dual_eligible" ;;
  }

  dimension: est_commercial {
    type: number
    sql: ${TABLE}."est_commercial" ;;
  }

  dimension: est_commercial_si {
    type: number
    sql: ${TABLE}."est_commercial_si" ;;
  }

  dimension: est_total_with_coverage {
    type: number
    sql: ${TABLE}."est_total_with_coverage" ;;
  }

  dimension: fi_hmo {
    type: number
    sql: ${TABLE}."fi_hmo" ;;
  }

  dimension: fi_indemnity {
    type: number
    sql: ${TABLE}."fi_indemnity" ;;
  }

  dimension: fi_pos {
    type: number
    sql: ${TABLE}."fi_pos" ;;
  }

  dimension: fi_ppo {
    type: number
    sql: ${TABLE}."fi_ppo" ;;
  }

  dimension: fips_county_code {
    type: number
    sql: ${TABLE}."fips_county_code" ;;
  }

  dimension: medicaid {
    type: number
    value_format_name: id
    sql: ${TABLE}."medicaid" ;;
  }

  dimension: medicare {
    type: number
    sql: ${TABLE}."medicare" ;;
  }

  dimension: medicare_advantage_part_c {
    type: number
    sql: ${TABLE}."medicare_advantage_part_c" ;;
  }

  dimension: medicare_ffs_parts_a_b {
    type: number
    sql: ${TABLE}."medicare_ffs_parts_a_b" ;;
  }

  dimension: payer_managed_medicaid {
    type: number
    value_format_name: id
    sql: ${TABLE}."payer_managed_medicaid" ;;
  }

  dimension: population {
    type: number
    sql: ${TABLE}."population" ;;
  }

  dimension: public_hix_individual {
    type: number
    sql: ${TABLE}."public_hix_individual" ;;
  }

  dimension: public_hix_shop {
    type: number
    sql: ${TABLE}."public_hix_shop" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
  }

  dimension: state_managed_medicaid {
    type: number
    value_format_name: id
    sql: ${TABLE}."state_managed_medicaid" ;;
  }

  dimension: tricare {
    type: number
    sql: ${TABLE}."tricare" ;;
  }

  dimension: uninsured {
    type: number
    sql: ${TABLE}."uninsured" ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}."zipcode" ;;
  }

  dimension: primary_key {
    type: string
    sql: concat(${zipcode}, ${fips_county_code}) ;;
  }

  measure: sum_commercial_fi {
    type: sum_distinct
    sql: ${commercial_fi} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_population {
    type: sum_distinct
    sql: ${population} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_medicare_advantage_part_c {
    type: sum_distinct
    sql: ${medicare_advantage_part_c} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: sum_medicare_advantage_part_c_plus_commercial_fi  {
    type: number
    sql: ${sum_medicare_advantage_part_c}+${sum_commercial_fi} ;;
  }

  measure: medicare_advantage_part_c_plus_commercial_fi_percent  {
    type: number
    value_format: "0%"
    sql: case when ${sum_population}>0 then ${sum_medicare_advantage_part_c_plus_commercial_fi}::float/${sum_population}::float  else 0 end;;
  }

  measure: medicare_advantage_part_c_percent  {
    type: number
    value_format: "0%"
    sql:  case when ${sum_population}>0 then ${medicare_advantage_part_c}::float/${sum_population}::float else 0 end ;;
  }

  measure: sum_commercial_fi_percent  {
    type: number
    value_format: "0%"
    sql:  case when ${sum_population}>0 then ${sum_commercial_fi}::float/${sum_population}::float else 0 end ;;
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
