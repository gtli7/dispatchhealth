view: market_fleet_tracker {
  sql_table_name: looker_scratch.market_fleet_tracker ;;

  dimension: cvn {
    type: string
    sql: ${TABLE}."cvn" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."description" ;;
  }

  dimension: in_service {
    type: string
    sql: ${TABLE}."in_service" ;;
  }

  dimension_group: in_service {
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
    sql: ${TABLE}."in_service_date" ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}."market" ;;
  }

  dimension: notes {
    type: string
    sql: ${TABLE}."notes" ;;
  }

  dimension: reason_out_of_service {
    type: string
    sql: ${TABLE}."reason_out_of_service" ;;
  }

  dimension: replacement_vehicle {
    type: string
    sql: ${TABLE}."replacement_vehicle" ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}."title" ;;
  }

  dimension: year {
    type: number
    sql: ${TABLE}."year" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
