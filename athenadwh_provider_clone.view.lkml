view: athenadwh_provider_clone {
  sql_table_name: looker_scratch.athenadwh_provider_clone ;;
  view_label: "ZZZZ - Athenadwh Provider Clone"

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
    sql: ${TABLE}.created_datetime ;;
  }

  dimension: deleted_by {
    type: string
    sql: ${TABLE}.deleted_by ;;
  }

  dimension: provider_first_name {
    type: string
    sql: CASE
          WHEN ${TABLE}.provider_first_name = 'MARY' AND ${provider_last_name} = 'WILLIAMS' THEN 'ELIZABETH'
          ELSE ${TABLE}.provider_first_name
        END ;;
  }

  dimension: provider_group_id {
    type: number
    sql: ${TABLE}.provider_group_id ;;
  }

  dimension: provider_id {
    type: number
    sql: ${TABLE}.provider_id ;;
  }

  dimension: provider_last_name {
    type: string
    sql: ${TABLE}.provider_last_name ;;
  }

  dimension: provider_npi_number {
    type: string
    sql: ${TABLE}.provider_npi_number ;;
  }

  dimension: provider_type {
    type: string
    sql: ${TABLE}.provider_type ;;
  }

  dimension: provider_type_category {
    type: string
    sql: ${TABLE}.provider_type_category ;;
  }

  dimension: provider_type_name {
    type: string
    sql: ${TABLE}.provider_type_name ;;
  }

  dimension: provider_user_name {
    type: string
    sql: ${TABLE}.provider_user_name ;;
  }

  dimension: specialty {
    type: string
    sql: ${TABLE}.specialty ;;
  }

  dimension: supervising_provider_id {
    type: number
    sql: ${TABLE}.supervising_provider_id ;;
  }

  dimension: taxonomy {
    type: string
    sql: ${TABLE}.taxonomy ;;
  }

  measure: count {
    type: count
    drill_fields: [provider_first_name, provider_last_name, provider_user_name, provider_type_name]
  }
}
