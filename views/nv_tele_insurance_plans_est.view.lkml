view: nv_tele_insurance_plans_est {
  sql_table_name: looker_scratch.nv_tele_insurance_plans_est ;;

  dimension: active {
    type: string
    sql: ${TABLE}."active" ;;
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

  dimension: enabled {
    type: string
    sql: ${TABLE}."enabled" ;;
  }

  dimension: insurance_name {
    type: string
    sql: ${TABLE}."insurance_name" ;;
  }

  dimension: insurance_package_id {
    type: number
    sql: ${TABLE}."insurance_package_id" ;;
  }

  dimension: insurance_plan_id {
    type: number
    sql: ${TABLE}."insurance_plan_id" ;;
  }

  dimension: insurance_plan_service_line_id {
    type: number
    sql: ${TABLE}."insurance_plan_service_line_id" ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}."note" ;;
  }

  dimension: service_line_id {
    type: number
    sql: ${TABLE}."service_line_id" ;;
  }

  dimension: state_id {
    type: number
    sql: ${TABLE}."state_id" ;;
  }

  dimension: tele_eligible_plan {
    type: yesno
    sql: ${insurance_plan_id} is not null ;;
  }

  measure: count {
    type: count
    drill_fields: [insurance_name]
  }
}
