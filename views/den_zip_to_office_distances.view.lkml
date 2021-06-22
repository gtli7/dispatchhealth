view: den_zip_to_office_distances {
  sql_table_name: looker_scratch.den_zip_to_office_distances ;;

  dimension: closest_office {
    type: string
    sql: ${TABLE}."closest_office" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."created_at" ;;
  }

  dimension: dist_broomfield {
    type: number
    sql: ${TABLE}."dist_broomfield" ;;
  }

  dimension: dist_denver_north {
    type: number
    sql: ${TABLE}."dist_denver_north" ;;
  }

  dimension: dist_denver_south {
    type: number
    sql: ${TABLE}."dist_denver_south" ;;
  }

  dimension: mean_lat {
    type: number
    sql: ${TABLE}."mean_lat" ;;
  }

  dimension: mean_long {
    type: number
    sql: ${TABLE}."mean_long" ;;
  }

  dimension: p_zc_65plus {
    type: number
    sql: ${TABLE}."p_zc_65plus" ;;
  }

  dimension: p_zc_under65 {
    type: number
    sql: ${TABLE}."p_zc_under65" ;;
  }

  dimension: pct_population_65plus {
    type: number
    sql: ${TABLE}."pct_population_65plus" ;;
  }

  dimension: pop_65plus {
    type: number
    sql: ${TABLE}."pop_65plus" ;;
  }

  dimension: pop_under65 {
    type: number
    sql: ${TABLE}."pop_under65" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
  }

  dimension: total_population {
    type: number
    sql: ${TABLE}."total_population" ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}."zipcode" ;;
  }

  measure: count_distinct_zips {
    type: count_distinct
    sql_distinct_key: ${zipcode} ;;
    sql: ${zipcode} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
