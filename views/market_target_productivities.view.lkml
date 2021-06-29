view: market_target_productivities {
  sql_table_name: looker_scratch.market_target_productivities ;;

  dimension: primary_key {
    type: string
    primary_key: yes
    sql: ${market_short} ;;
  }

  dimension: avg_drive_time_minutes_30day {
    type: number
    sql: ${TABLE}."avg_drive_time_minutes_30day" ;;
  }

  dimension: avg_drive_time_minutes_7day {
    type: number
    sql: ${TABLE}."avg_drive_time_minutes_7day" ;;
  }

  dimension: avg_drive_time_minutes_90day {
    type: number
    sql: ${TABLE}."avg_drive_time_minutes_90day" ;;
  }

  dimension: avg_on_scene_time_minutes_30day {
    type: number
    sql: ${TABLE}."avg_on_scene_time_minutes_30day" ;;
  }

  dimension: avg_on_scene_time_minutes_7day {
    type: number
    sql: ${TABLE}."avg_on_scene_time_minutes_7day" ;;
  }

  dimension: avg_on_scene_time_minutes_90day {
    type: number
    sql: ${TABLE}."avg_on_scene_time_minutes_90day" ;;
  }

  dimension: complete_visits_per_site_30day {
    type: number
    sql: ${TABLE}."complete_visits_per_site_30day" ;;
  }

  dimension: complete_visits_per_site_7day {
    type: number
    sql: ${TABLE}."complete_visits_per_site_7day" ;;
  }

  dimension: complete_visits_per_site_90day {
    type: number
    sql: ${TABLE}."complete_visits_per_site_90day" ;;
  }

  dimension: count_on_site_30day {
    type: number
    sql: ${TABLE}."count_on_site_30day" ;;
  }

  dimension: count_on_site_7day {
    type: number
    sql: ${TABLE}."count_on_site_7day" ;;
  }

  dimension: count_on_site_90day {
    type: number
    sql: ${TABLE}."count_on_site_90day" ;;
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

  dimension: market_short {
    type: string
    sql: ${TABLE}."market_short" ;;
  }

  dimension: max_active_time_hr_30day {
    type: number
    sql: ${TABLE}."max_active_time_hr_30day" ;;
  }

  dimension: max_active_time_hr_7day {
    type: number
    sql: ${TABLE}."max_active_time_hr_7day" ;;
  }

  dimension: max_active_time_hr_90day {
    type: number
    sql: ${TABLE}."max_active_time_hr_90day" ;;
  }

  dimension: max_productivity_30day {
    type: number
    sql: ${TABLE}."max_productivity_30day" ;;
  }

  dimension: max_productivity_7day {
    type: number
    sql: ${TABLE}."max_productivity_7day" ;;
  }

  dimension: max_productivity_90day {
    type: number
    sql: ${TABLE}."max_productivity_90day" ;;
  }

  dimension: overflow_plus_booked_shaping_percent_30day {
    type: number
    sql: ${TABLE}."overflow_plus_booked_shaping_percent_30day" ;;
  }

  dimension: overflow_plus_booked_shaping_percent_7day {
    type: number
    sql: ${TABLE}."overflow_plus_booked_shaping_percent_7day" ;;
  }

  dimension: overflow_plus_booked_shaping_percent_90day {
    type: number
    sql: ${TABLE}."overflow_plus_booked_shaping_percent_90day" ;;
  }

  dimension: sum_complete_count_30day {
    type: number
    sql: ${TABLE}."sum_complete_count_30day" ;;
  }

  dimension: sum_complete_count_7day {
    type: number
    sql: ${TABLE}."sum_complete_count_7day" ;;
  }

  dimension: sum_complete_count_90day {
    type: number
    sql: ${TABLE}."sum_complete_count_90day" ;;
  }

  dimension: target_productivity_30day {
    type: number
    sql: ${TABLE}."target_productivity_30day" ;;
  }

  dimension: target_productivity_7day {
    type: number
    sql: ${TABLE}."target_productivity_7day" ;;
  }

  dimension: target_productivity_90day {
    type: number
    sql: ${TABLE}."target_productivity_90day" ;;
  }

  dimension: total_productivity_30day {
    type: number
    sql: ${TABLE}."total_productivity_30day" ;;
  }

  dimension: total_productivity_7day {
    type: number
    sql: ${TABLE}."total_productivity_7day" ;;
  }

  dimension: total_productivity_90day {
    type: number
    sql: ${TABLE}."total_productivity_90day" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
