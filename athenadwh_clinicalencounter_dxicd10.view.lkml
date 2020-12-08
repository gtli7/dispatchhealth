view: athenadwh_clinicalencounter_dxicd10 {
  sql_table_name: looker_scratch.athenadwh_clinicalencounter_dxicd10 ;;
  view_label: "ZZZZ - Athenadwh Dx ICD10"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: clinical_encounter_dx_id {
    type: number
    sql: ${TABLE}.clinical_encounter_dx_id ;;
  }

  dimension: clinical_encounter_dxicd10_id {
    type: number
    sql: ${TABLE}.clinical_encounter_dxicd10_id ;;
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

  dimension: icd_code_id {
    type: number
    sql: ${TABLE}.icd_code_id ;;
  }

  dimension: ordering {
    type: number
    sql: ${TABLE}.ordering ;;
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
    drill_fields: [id]
  }
}
