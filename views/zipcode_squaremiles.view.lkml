view: zipcode_squaremiles {
  sql_table_name: looker_scratch.zipcode_squaremiles ;;

  dimension: aland {
    type: number
    sql: ${TABLE}."aland" ;;
  }

  dimension: aland_sqmi {
    type: number
    sql: ${TABLE}."aland_sqmi" ;;
  }

  dimension: awater {
    type: number
    sql: ${TABLE}."awater" ;;
  }

  dimension: awater_sqmi {
    type: number
    sql: ${TABLE}."awater_sqmi" ;;
  }

  dimension: geoid {
    type: number
    value_format_name: id
    sql: ${TABLE}."geoid" ;;
  }

  dimension: intptlat {
    type: number
    sql: ${TABLE}."intptlat" ;;
  }

  dimension: intptlong {
    type: number
    sql: ${TABLE}."intptlong" ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode_str ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
