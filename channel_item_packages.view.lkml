view: channel_item_packages {
  sql_table_name: public.channel_item_packages ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: channel_item_id {
    hidden: yes
    type: number
    sql: ${TABLE}."channel_item_id" ;;
  }

  dimension_group: created {
    hidden: yes
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

  dimension: package_id {
    hidden: yes
    type: string
    sql: ${TABLE}."package_id" ;;
  }

  dimension_group: updated {
    hidden: yes
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

  measure: emr_insurance_packages_concatenated {
    description: "Concatenated insruance packages by Channel EMR Provider"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${package_id}), ' | ') ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
