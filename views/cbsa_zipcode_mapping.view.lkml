view: cbsa_zipcode_mapping {
  sql_table_name: looker_scratch.cbsa_zipcode_mapping ;;

  dimension: cbsa {
    type: string
    sql: ${TABLE}."cbsa" ;;
  }

  dimension: cbsa_id {
    type: string
    sql: ${TABLE}."cbsa_id" ;;
  }

  dimension: cbsa_id_name {
    type: string
    sql: ${TABLE}."cbsa_id_name" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."city" ;;
  }

  dimension: city_proper {
    type: string
    sql: ${TABLE}."city_proper" ;;
  }

  dimension: county {
    type: string
    sql: ${TABLE}."county" ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}."region" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
  }

  dimension: state_short {
    type: string
    sql: ${TABLE}."state_short" ;;
  }

  measure: cbsa_agg
  {
    type: string
    sql: array_agg(distinct ${cbsa}) ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}."zipcode" ;;
  }

  dimension: zipcode_raw {
    type: number
    sql: ${TABLE}."zipcode_raw" ;;
  }

  measure: count {
    type: count
    drill_fields: [cbsa_id_name]
  }
}
