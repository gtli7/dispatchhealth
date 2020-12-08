view: icd_visit_joins_clone {
  label: "ZZZZ - ICD Code Visit Join Table Clone"
  sql_table_name: looker_scratch.icd_visit_joins_clone ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: icd_dim_id {
    hidden: yes
    type: string
    sql: ${TABLE}.icd_dim_id ;;
  }

  measure: count_distinct_icds {
    type: count_distinct
    sql: ${icd_dim_id} ;;
    sql_distinct_key: ${care_request_id} ;;
  }

  dimension: sequence_number {
    description: "The ordered number for the ICD code used in the claim"
    type: number
    sql: ${TABLE}.sequence_number ;;
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
    sql: ${TABLE}.updated_at ;;
  }

  dimension: visit_dim_number {
    label: "EHR Appointment ID"
    type: string
    sql: ${TABLE}.visit_dim_number ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
