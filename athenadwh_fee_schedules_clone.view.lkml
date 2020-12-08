view: athenadwh_fee_schedules_clone {
  sql_table_name: looker_scratch.athenadwh_fee_schedules_clone ;;
  view_label: "ZZZZ - Athenadwh Fee Schedules Clone"

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

  dimension_group: deleted_datetime {
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
    sql: ${TABLE}.deleted_datetime ;;
  }

  dimension: effective_date {
    type: string
    sql: ${TABLE}.effective_date ;;
  }

  dimension: expiration_date {
    type: string
    sql: ${TABLE}.expiration_date ;;
  }

  dimension: fee_schedule_id {
    type: number
    sql: ${TABLE}.fee_schedule_id ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
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
    drill_fields: [id, name]
  }
}
