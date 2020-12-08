view: athenadwh_clinical_results_clone {
  sql_table_name: looker_scratch.athenadwh_clinical_results_clone ;;
  view_label: "ZZZZ - Athenadwh Clinical Results Clone"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: clinical_order_type {
    type: string
    sql: ${TABLE}.clinical_order_type ;;
  }

  dimension: clinical_order_type_group {
    type: string
    sql: ${TABLE}.clinical_order_type_group ;;
  }

  dimension: labs_flag {
    type: yesno
    sql: ${clinical_order_type_group} = 'LAB' ;;
  }

  dimension: clinical_provider_id {
    type: number
    sql: ${TABLE}.clinical_provider_id ;;
  }

  dimension: clinical_result_id {
    type: number
    sql: ${TABLE}.clinical_result_id ;;
  }

  dimension: document_is_from_care_request {
    type: yesno
    hidden: no
    sql: ${created_datetime_date} >= ${athenadwh_clinical_encounters_clone.encounter_date}::date AND
         ${created_datetime_date} <= ${athenadwh_clinical_encounters_clone.encounter_date}::date + interval '2 day';;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}.created_by ;;
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
    sql: ${TABLE}.created_datetime ;;
  }

  dimension: document_id {
    type: number
    sql: ${TABLE}.document_id ;;
  }

  dimension: specimen_source {
    type: string
    sql: ${TABLE}.specimen_source ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
