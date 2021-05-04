view: dnis_partner_dnis_list {
  sql_table_name: looker_scratch.dnis_partner_dnis_list ;;
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

  dimension: partner_dnis_grouping_id {
    type: number
    sql: ${TABLE}."partner_dnis_grouping_id" ;;
  }

  dimension: partner_dnis_number {
    type: string
    sql: ${TABLE}."partner_dnis_number" ;;
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
}
