view: athenadwh_payers {
  sql_table_name: jasperdb.athenadwh_payers ;;

  view_label: "ZZZZ - Athenadwh Payers"

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

  dimension: custom_insurance_grouping {
    type: string
    sql: ${TABLE}.custom_insurance_grouping ;;
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

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: global_allowable_category {
    type: string
    sql: ${TABLE}.global_allowable_category ;;
  }

  dimension: insurance_package_id {
    type: string
    sql: ${TABLE}.insurance_package_id ;;
  }

  dimension: insurance_package_name {
    type: string
    sql: ${TABLE}.insurance_package_name ;;
  }

  dimension: insurance_package_type {
    type: string
    sql: ${TABLE}.insurance_package_type ;;
  }

  dimension: insurance_product_type {
    type: string
    sql: ${TABLE}.insurance_product_type ;;
  }

  dimension: insurance_reporting_category {
    type: string
    sql: ${TABLE}.insurance_reporting_category ;;
  }

  dimension: irc_group {
    type: string
    sql: ${TABLE}.irc_group ;;
  }

  dimension: local_allowable_category {
    type: string
    sql: ${TABLE}.local_allowable_category ;;
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
    drill_fields: [id, insurance_package_name]
  }
}
