view: athenadwh_patientaudit {
  sql_table_name: looker_scratch.athenadwh_patientaudit ;;
  view_label: "ZZZZ - Patient Audit"
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."id" ;;
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

  dimension: entity_id {
    type: number
    hidden: yes
    sql: ${TABLE}."entity_id" ;;
  }

  dimension_group: event_datetime {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."event_datetime" ;;
  }

  dimension: field_name {
    type: string
    description: "The Athena field that was modified"
    sql: ${TABLE}."field_name" ;;
  }

  dimension: new_value {
    type: string
    description: "The new value that was entered for the field"
    sql: ${TABLE}."new_value" ;;
  }

  dimension: old_value {
    type: string
    description: "The old value that was replaced for the field"
    sql: ${TABLE}."old_value" ;;
  }

  dimension: operation {
    type: string
    description: "The operation performed on the field e.g. 'CREATE' or 'UPDATE'"
    sql: ${TABLE}."operation" ;;
  }

  dimension: source_id {
    type: number
    hidden: yes
    sql: ${TABLE}."source_id" ;;
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

  dimension: username {
    type: string
    description: "The Athena user that completed the operation"
    sql: ${TABLE}."username" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, field_name, username]
  }
}
