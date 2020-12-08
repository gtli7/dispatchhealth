view: athenadwh_departments_clone {
  sql_table_name: looker_scratch.athenadwh_departments_clone ;;
  view_label: "ZZZZ - Athenadwh Departments Clone"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: department_group {
    type: string
    sql: ${TABLE}.department_group ;;
  }

  dimension: department_id {
    type: number
    sql: ${TABLE}.department_id ;;
  }

  dimension: department_name {
    type: string
    sql: ${TABLE}.department_name ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: place_of_service_type {
    type: string
    sql: ${TABLE}.place_of_service_type ;;
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
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, department_name]
  }
}
