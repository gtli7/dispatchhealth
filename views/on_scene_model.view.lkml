view: model_versions {
  sql_table_name: on_scene_model.model_versions ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
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

  dimension_group: date_decommissioned {
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
    sql: ${TABLE}."date_decommissioned" ;;
  }

  dimension_group: date_deployed {
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
    sql: ${TABLE}."date_deployed" ;;
  }

  dimension: is_active {
    type: yesno
    sql: ${TABLE}."is_active" ;;
  }

  dimension: model_version {
    type: string
    sql: ${TABLE}."model_version" ;;
  }

  dimension: notes {
    type: string
    sql: ${TABLE}."notes" ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }


  dimension: actual_minus_predicted {
    type: number
    group_label: "On Scene Predictions"
    description: "The actual car stopping time minus the predicted on-scene time"
    sql: CASE WHEN ${geolocations_stops_by_care_request.stop_duration} IS NOT NULL
          THEN ${geolocations_stops_by_care_request.stop_duration} - ${care_request_flat.mins_on_scene_predicted}
          ELSE NULL
        END;;
  }

  dimension: predicted_minus_actual {
    type: number
    group_label: "On Scene Predictions"
    description: "The predicted on-scene time minus the actual car stopping time minus"
    sql: CASE WHEN ${geolocations_stops_by_care_request.stop_duration} IS NOT NULL
          THEN ${care_request_flat.mins_on_scene_predicted} - ${geolocations_stops_by_care_request.stop_duration}
          ELSE NULL
        END;;
  }


  dimension: squared_error {
    type:  number
    group_label: "On Scene Predictions"
    description: "The actual car stopping time minus the predicted on-scene time SQUARED"
    sql: CASE WHEN ${geolocations_stops_by_care_request.stop_duration} IS NOT NULL
          THEN POWER(${geolocations_stops_by_care_request.stop_duration} - ${care_request_flat.mins_on_scene_predicted}, 2)
          ELSE NULL
        END;;
  }

  dimension: absolute_error {
    type: number
    group_label: "On Scene Predictions"
    description: "The absolute value of the actual car stopping time minus the predicted on-scene time"
    sql: CASE WHEN ${geolocations_stops_by_care_request.stop_duration} IS NOT NULL
          THEN ABS(${geolocations_stops_by_care_request.stop_duration} - ${care_request_flat.mins_on_scene_predicted})
          ELSE NULL
          END;;
  }

  dimension: perc_error {
    type: number
    group_label: "On Scene Predictions"
    description: "The percentage that the prediction is off by absolut_error/actual"
    sql: CASE WHEN ${geolocations_stops_by_care_request.stop_duration} IS NOT NULL
          THEN ${absolute_error}/${geolocations_stops_by_care_request.stop_duration}
          ELSE NULL
        END;;
  }


  dimension: perc_error_tier_stop_duration {
    type: tier
    description: "Predicted on-scene time minus geolocations stop duration, in tiers"
    group_label: "On Scene Predictions"
    tiers: [0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
    style: relational
    sql: ${perc_error} ;;
  }

  dimension: actual_minus_pred_tier {
    type: tier
    description: "Geolocations on-scene time minus predicted on-scene time, in 10 minute tiers"
    group_label: "On Scene Predictions"
    tiers: [-60,-50,-40,-30,-20,-10,0,10,20,30,40,50,60]
    style: integer
    sql: ${actual_minus_predicted} ;;
  }

  dimension: pred_minus_actual_tier {
    type: tier
    description: "Predicted on-scene time minus geolocations on-scene time, in 10 minute tiers"
    group_label: "On Scene Predictions"
    tiers: [-60,-50,-40,-30,-20,-10,0,10,20,30,40,50,60]
    style: integer
    sql: ${actual_minus_predicted} ;;
  }

  dimension: abs_residual_tier_stop_duration {
    type: tier
    description: "Predicted on-scene time minus geolocations stop duration, in tiers"
    group_label: "On Scene Predictions"
    tiers: [0,5,10,15,30,60]
    style: relational
    sql: abs(${geolocations_stops_by_care_request.stop_duration} - ${care_request_flat.mins_on_scene_predicted}) ;;
  }


  measure: average_actual_minus_pred {
    type: average_distinct
    sql_distinct_key: ${geolocations_stops_by_care_request.primary_key} ;;
    description: "The average car stop time - predicted on scene time (residual)"
    sql: ${actual_minus_predicted} ;;
  }

  measure: average_pred_minus_actual {
    type: average_distinct
    sql_distinct_key: ${geolocations_stops_by_care_request.primary_key} ;;
    description: "The average car stop time - predicted on scene time (residual)"
    sql: ${predicted_minus_actual} ;;
  }

  measure: mean_absolue_error{
    type: average_distinct
    sql_distinct_key: ${geolocations_stops_by_care_request.primary_key} ;;
    description: "The average car stop time - predicted on scene time ABSOLUTE errror"
    sql: ${absolute_error} ;;
  }

  measure: mse_actual_minus_pred {
    type: average_distinct
    sql_distinct_key: ${geolocations_stops_by_care_request.primary_key} ;;
    description: "The average car stop time - predicted on scene time error SQUARED"
    sql: ${squared_error} ;;
  }

  measure: total_on_scene_time {
    type: sum_distinct
    description: "The sum of all car stop times for care requests"
    sql_distinct_key: ${geolocations_stops_by_care_request.primary_key} ;;
    sql: ${geolocations_stops_by_care_request.stop_duration} ;;
  }

  measure: average_on_scene_time {
    type: average_distinct
    sql_distinct_key: ${geolocations_stops_by_care_request.primary_key} ;;
    description: "The average of all car stop times for care requests"
    sql: ${geolocations_stops_by_care_request.stop_duration} ;;
  }

  measure: on_scene_time_25th_percentile {
    type: percentile_distinct
    percentile: 25
    sql_distinct_key: ${geolocations_stops_by_care_request.care_request_id} ;;
    sql: ${geolocations_stops_by_care_request.stop_duration} ;;
  }

  measure: on_scene_time_75th_percentile {
    type: percentile_distinct
    percentile: 75
    sql_distinct_key: ${geolocations_stops_by_care_request.care_request_id} ;;
    sql: ${geolocations_stops_by_care_request.stop_duration} ;;
  }

  dimension: abs_actual_minus_predicted_greater_than_15_min {
    type:  yesno
    sql: ${absolute_error} >= 15  ;;
  }

  dimension: abs_actual_minus_predicted_less_than_15_min {
    type:  yesno
    sql: ${absolute_error} <= 15  ;;
  }

  parameter: perc_error_within_param {
    type:  number
    default_value: "0.25"
  }

  dimension: perc_error_within {
    type:  yesno
    sql:  ${perc_error} <= {% parameter perc_error_within_param %} ;;
  }

  measure:count_perc_error_within {
    type:  count_distinct
    sql: ${geolocations_stops_by_care_request.care_request_id} ;;
    filters: {
      field: perc_error_within
      value: "yes"
    }
  }

  measure: count_abs_actual_minus_predicted_greater_than_15_min {
    type: count_distinct
    sql: ${geolocations_stops_by_care_request.care_request_id} ;;
    filters: {
      field: abs_actual_minus_predicted_greater_than_15_min
      value: "yes"
    }
  }

  measure: count_abs_actual_minus_predicted_less_than_15_min {
    type: count_distinct
    sql: ${geolocations_stops_by_care_request.care_request_id} ;;
    filters: {
      field: abs_actual_minus_predicted_less_than_15_min
      value: "yes"
    }
  }
}
