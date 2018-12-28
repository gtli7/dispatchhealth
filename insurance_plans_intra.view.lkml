view: insurance_plans_intra {
  sql_table_name: looker_scratch.insurance_plans_intra ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: active {
    type: yesno
    sql: ${TABLE}.active ;;
  }

  dimension: insurance_classification_id {
    type: number
    sql: ${TABLE}.insurance_classification_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}.note ;;
  }

  dimension: package_id {
    type: string
    sql: ${TABLE}.package_id ;;
  }

  dimension: plan_type {
    type: number
    sql: ${TABLE}.plan_type ;;
  }

  dimension: state_id {
    type: number
    sql: ${TABLE}.state_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
