view: protocol_requirements {
  sql_table_name: public.protocol_requirements ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: color {
    type: number
    sql: ${TABLE}."color" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."name" ;;
  }

  dimension: service_line_id {
    type: number
    sql: ${TABLE}."service_line_id" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
