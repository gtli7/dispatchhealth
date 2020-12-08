view: athenadwh_clinicalencounter_diagnosis {
  view_label: "ZZZZ - Athenadwh Clinical Encounter Diagnoses"
  sql_table_name: looker_scratch.athenadwh_clinicalencounter_diagnosis ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: clinical_encounter_dx_id {
    type: number
    sql: ${TABLE}.clinical_encounter_dx_id ;;
  }

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}.clinical_encounter_id ;;
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

  dimension: ordering {
    type: number
    hidden: yes
    sql: ${TABLE}.ordering ;;
  }


  dimension: sequence_number {
    type: number
    description: "The priority number of the diagnosis code"
    hidden: no
    sql: ${ordering} + 1 ;;
  }

  measure: num_diagnoses {
    type: max
    description: "The number of diagnosis codes recorded by the provider"
    sql: ${sequence_number} ;;
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
