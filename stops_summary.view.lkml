view: stops_summary {
  sql_table_name: geolocation.stops_summary ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension_group: break_begin {
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
    sql: ${TABLE}."break_begin" ;;
  }

  dimension_group: break_end {
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
    sql: ${TABLE}."break_end" ;;
  }

  dimension: breaks_id {
    type: number
    hidden: yes
    sql: ${TABLE}."breaks_id" ;;
  }

  dimension: car_id {
    type: number
    hidden: yes
    sql: ${TABLE}."car_id" ;;
  }

  dimension: care_request_ids {
    type: string
    sql: ${TABLE}."care_request_ids" ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
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

  dimension: geolocations_id {
    type: number
    hidden: yes
    sql: ${TABLE}."geolocations_id" ;;
  }

  dimension: minutes_stopped {
    type: number
    sql: ${TABLE}."minutes_stopped" ;;
  }

  measure: average_minutes_stopped {
    type: average
    description: "Average minutes stopped"
    group_label: "Stop Metrics"
    sql: ${minutes_stopped} ;;
  }

  dimension: num_care_requests {
    type: number
    description: "The number of care requests being serviced at the stop location"
    sql: ${TABLE}."num_care_requests" ;;
  }

  dimension_group: shift_start {
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
    sql: ${TABLE}."shift_start_time" ;;
  }

  dimension: shift_teams_id {
    type: number
    hidden: yes
    sql: ${TABLE}."shift_teams_id" ;;
  }

  dimension_group: stop_begin {
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
    sql: ${TABLE}."stop_begin" ;;
  }

  dimension_group: stop_end {
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
    sql: ${TABLE}."stop_end" ;;
  }

  dimension: stop_latitude {
    type: number
    hidden: yes
    sql: ${TABLE}."stop_latitude" ;;
  }

  dimension: stop_longitude {
    type: number
    hidden: yes
    sql: ${TABLE}."stop_longitude" ;;
  }

  dimension: stop_location {
    type: location
    description: "Car top location"
    sql_latitude: ${stop_latitude} ;;
    sql_longitude: ${stop_longitude} ;;
  }

  dimension: stop_type {
    type: string
    description: "The type of stop: care request, break, or other"
    sql: ${TABLE}."stop_type" ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."updated_at" ;;
  }

}
