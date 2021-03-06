view: athena_procedurecode {
  sql_table_name: athena.procedurecode ;;

  dimension: __batch_id {
    type: string
    sql: ${TABLE}."__batch_id" ;;
    group_label: "ID's"
  }

  dimension_group: __file {
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
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    sql: ${TABLE}."__from_file" ;;
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

  dimension_group: created_datetime {
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
    sql: ${TABLE}."created_datetime" ;;
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
    sql: ${TABLE}."deleted_datetime" ;;
  }

  dimension: procedure_code {
    type: string
    sql: ${TABLE}."procedure_code" ;;
    group_label: "Description"
  }

  dimension: procedure_code_description {
    type: string
    sql: ${TABLE}."procedure_code_description" ;;
    group_label: "Description"
  }

  dimension: procedure_code_group {
    type: string
    sql: ${TABLE}."procedure_code_group" ;;
    group_label: "Description"
  }

  dimension: procedure_code_id {
    type: number
    sql: ${TABLE}."procedure_code_id" ;;
    group_label: "ID's"
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
    drill_fields: []
  }
}
