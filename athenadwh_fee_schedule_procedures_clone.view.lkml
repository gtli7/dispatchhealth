view: athenadwh_fee_schedule_procedures_clone {
  sql_table_name: looker_scratch.athenadwh_fee_schedule_procedures_clone ;;
  view_label: "ZZZZ - Athenadwh Fee Schedule Procedures Clone"

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

  dimension: fee_amount {
    type: string
    sql: ${TABLE}.fee_amount ;;
  }

  dimension: fee_schedule_id {
    type: number
    sql: ${TABLE}.fee_schedule_id ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: procedure_code {
    type: string
    sql: ${TABLE}.procedure_code ;;
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
    drill_fields: [id]
  }
}
