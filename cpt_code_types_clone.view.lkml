view: cpt_code_types_clone {
  view_label: "ZZZZ - CPT Code Types Clone"
  sql_table_name: looker_scratch.cpt_code_types_clone ;;

  dimension: cpt_code {
    type: string
    sql: ${TABLE}.cpt_code ;;
  }

  dimension: cpt_code_type {
    type: string
    sql: ${TABLE}.cpt_code_type ;;
  }

  dimension: cpt_description {
    type: string
    sql: ${TABLE}.cpt_description ;;
  }

  dimension: e_m_level {
    type: string
    sql: UPPER(${TABLE}.e_m_level) ;;
  }

  dimension: fee {
    type: number
    sql: ${TABLE}.fee ;;
  }

  dimension: new_existing_patient {
    type: string
    sql: ${TABLE}.new_existing_patient ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  dimension: cpt_type_procedure_flag {
    label: "CPT Code Type 'Procedure' Flag"
    description: "Flag to indicate 'Procedure' contained in the cpt_code_type field"
    type: yesno
    sql: UPPER(${cpt_code_type}) LIKE 'PROCEDURE' ;;
  }


}
