view: clia_licensure_dh {
  sql_table_name: looker_scratch.clia_licensure_dh ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: car_naming {
    type: string
    sql: ${TABLE}."car_naming" ;;
  }

  dimension: dh_clia_number {
    description: "Only valid for labs conducted in-house by DispatchHealth"
    type: string
    sql: ${TABLE}."clia_number" ;;
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

  dimension: facility_name_tax_id_name {
    type: string
    sql: ${TABLE}."facility_name_tax_id_name" ;;
  }

  dimension: lab {
    type: string
    sql: ${TABLE}."lab" ;;
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
    drill_fields: [id, facility_name_tax_id_name]
  }
}
