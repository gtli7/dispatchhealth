view: geolocations_stops_by_care_request {
  derived_table: {
    sql:
    SELECT
    ROW_NUMBER() OVER () AS my_primary_key,
    shift_teams_id AS shift_team_id,
    car_id,
    unnest(care_request_ids) AS care_request_id,
    num_care_requests,
    ROUND(SUM(minutes_stopped)::numeric,1) AS on_scene_time,
    ROUND((SUM(minutes_stopped) / num_care_requests::float)::numeric,1) AS stop_time_per_care_request
    FROM geolocation.stops_summary
    GROUP BY 2,3,4,5;;

      indexes: ["shift_team_id", "car_id", "care_request_id"]
      sql_trigger_value: SELECT MAX(geolocations_id) FROM geolocation.stops_summary ;;
  }

  dimension: primary_key {
    type: number
    primary_key: yes
    sql: ${TABLE}.my_primary_key ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: num_care_requests_at_location {
    type: number
    description: "The number of care requests seen at the same location"
    sql: ${TABLE}.num_care_requests ;;
  }

  measure: count_distinct_care_requests {
    type: count_distinct
    description: "The count of all distinct care requests.  May not match billable_est
    due to inability to match certain care requests to car stops"
    sql: ${care_request_id} ;;
  }

  dimension: stop_duration {
    type: number
    description: "The total stop time for the care request.
      Total stop time is divided by the number of patients when multiple patients are treated
      at the same location"
    value_format: "0.0"
    sql: ${TABLE}.on_scene_time ;;
  }

  dimension: actual_minus_predicted {
    type: number
    group_label: "On Scene Predictions"
    description: "The actual car stopping time minus the predicted on-scene time"
    sql: CASE WHEN ${stop_duration} IS NOT NULL
          THEN ${stop_duration} - ${care_request_flat.mins_on_scene_predicted}
          ELSE NULL
        END;;
  }

  dimension: predicted_minus_actual {
    type: number
    group_label: "On Scene Predictions"
    description: "The predicted on-scene time minus the actual car stopping time minus"
    sql: CASE WHEN ${stop_duration} IS NOT NULL
          THEN ${care_request_flat.mins_on_scene_predicted} - ${stop_duration}
          ELSE NULL
        END;;
  }

  dimension: squared_error {
    type:  number
    group_label: "On Scene Predictions"
    description: "The actual car stopping time minus the predicted on-scene time SQUARED"
    sql: CASE WHEN ${stop_duration} IS NOT NULL
          THEN POWER(${stop_duration} - ${care_request_flat.mins_on_scene_predicted}, 2)
          ELSE NULL
        END;;
  }

  dimension: absolute_error {
    type: number
    group_label: "On Scene Predictions"
    description: "The absolute value of the actual car stopping time minus the predicted on-scene time"
    sql: CASE WHEN ${stop_duration} IS NOT NULL
    THEN ABS(${stop_duration} - ${care_request_flat.mins_on_scene_predicted})
    ELSE NULL
    END;;
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
    sql: abs(${stop_duration} - ${care_request_flat.mins_on_scene_predicted}) ;;
  }



  measure: average_actual_minus_pred {
    type: average_distinct
    sql_distinct_key: ${primary_key} ;;
    description: "The average car stop time - predicted on scene time (residual)"
    sql: ${actual_minus_predicted} ;;
  }

  measure: average_pred_minus_actual {
    type: average_distinct
    sql_distinct_key: ${primary_key} ;;
    description: "The average car stop time - predicted on scene time (residual)"
    sql: ${predicted_minus_actual} ;;
  }

  measure: mean_absolue_error{
    type: average_distinct
    sql_distinct_key: ${primary_key} ;;
    description: "The average car stop time - predicted on scene time ABSOLUTE errror"
    sql: ${absolute_error} ;;
  }

  measure: mse_actual_minus_pred {
    type: average_distinct
    sql_distinct_key: ${primary_key} ;;
    description: "The average car stop time - predicted on scene time error SQUARED"
    sql: ${squared_error} ;;
  }

  measure: total_on_scene_time {
    type: sum_distinct
    description: "The sum of all car stop times for care requests"
    sql_distinct_key: ${primary_key} ;;
    sql: ${stop_duration} ;;
  }

  measure: average_on_scene_time {
    type: average_distinct
    sql_distinct_key: ${primary_key} ;;
    description: "The average of all car stop times for care requests"
    sql: ${stop_duration} ;;
  }

  measure: on_scene_time_25th_percentile {
    type: percentile_distinct
    percentile: 25
    sql_distinct_key: ${care_request_id} ;;
    sql: ${stop_duration} ;;
  }

  measure: on_scene_time_75th_percentile {
    type: percentile_distinct
    percentile: 75
    sql_distinct_key: ${care_request_id} ;;
    sql: ${stop_duration} ;;
  }

  dimension: abs_actual_minus_predicted_greater_than_15_min {
    type:  yesno
    sql: ${absolute_error} >= 15  ;;
  }

  dimension: abs_actual_minus_predicted_less_than_15_min {
    type:  yesno
    sql: ${absolute_error} <= 15  ;;
  }

  measure: count_abs_actual_minus_predicted_greater_than_15_min {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: abs_actual_minus_predicted_greater_than_15_min
      value: "yes"
    }
  }

  measure: count_abs_actual_minus_predicted_less_than_15_min {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: abs_actual_minus_predicted_less_than_15_min
      value: "yes"
    }
  }


}
