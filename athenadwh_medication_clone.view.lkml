view: athenadwh_medication_clone {
  sql_table_name: looker_scratch.athenadwh_medication_clone ;;

  view_label: "ZZZZ - Athenadwh Medication Clone"

  dimension: dea_schedule {
    type: string
    sql: ${TABLE}.dea_schedule ;;
  }

  measure: dea_schedule_concat {
    type: string
    description: "A concatenated list of all DEA medication schedules"
    sql: array_to_string(array_agg(DISTINCT ${dea_schedule}), ' | ') ;;
  }

  dimension: fdb_med_id {
    type: number
    sql: ${TABLE}.fdb_med_id ;;
  }

  dimension: gcn_clinical_forumulation_id {
    type: number
    sql: ${TABLE}.gcn_clinical_forumulation_id ;;
  }

  dimension: hic1_code {
    type: string
    sql: ${TABLE}.hic1_code ;;
  }

  dimension: hic1_description {
    type: string
    sql: ${TABLE}.hic1_description ;;
    drill_fields: [medication_name]
    #link: {label: "Explore Top 20 Results" url: "{{ link }}&limit=20" }
  }

  dimension: hic2_pharmacological_class {
    type: string
    sql: ${TABLE}.hic2_pharmacological_class ;;
  }

  dimension: hic3_code {
    type: string
    sql: ${TABLE}.hic3_code ;;
  }

  dimension: hic3_description {
    type: string
    sql: ${TABLE}.hic3_description ;;
  }

  dimension: antibiotic_medication {
    type: yesno
    sql: ${hic3_description} IN
    ('AMINOGLYCOSIDE ANTIBIOTICS',
'ANTIBIOTICS, MISCELLANEOUS, OTHER',
'ANTITUBERCULAR ANTIBIOTICS',
'CEPHALOSPORIN ANTIBIOTICS - 1ST GENERATION',
'CEPHALOSPORIN ANTIBIOTICS - 2ND GENERATION',
'CEPHALOSPORIN ANTIBIOTICS - 3RD GENERATION',
'CEPHALOSPORIN ANTIBIOTICS - 4TH GENERATION',
'LINCOSAMIDE ANTIBIOTICS',
'MACROLIDE ANTIBIOTICS',
'OXAZOLIDINONE ANTIBIOTICS',
'PENICILLIN ANTIBIOTICS',
'QUINOLONE ANTIBIOTICS',
'RIFAMYCINS AND RELATED DERIVATIVE ANTIBIOTICS',
'TETRACYCLINE ANTIBIOTICS',
'VANCOMYCIN ANTIBIOTICS AND DERIVATIVES');;
  }

  dimension: hic4_ingredient_base {
    type: string
    sql: ${TABLE}.hic4_ingredient_base ;;
  }

  dimension: med_name_id {
    type: number
    sql: ${TABLE}.med_name_id ;;
  }

  dimension: medication_id {
    type: number
    sql: ${TABLE}.medication_id ;;
  }

  dimension: medication_name {
    type: string
    sql: ${TABLE}.medication_name ;;
  }

  dimension: ndc {
    type: string
    sql: ${TABLE}.ndc ;;
  }

  dimension: rxnorm {
    type: string
    sql: ${TABLE}.rxnorm ;;
  }

  measure: count {
    type: count
    drill_fields: [medication_name]
  }

  dimension: dea_scheduled_medication {
    description: "Identifies a prescription that is a Scheduled substance/medication by the DEA"
    type: yesno
    sql: ${dea_schedule} IS NOT NULL ;;

  }

  measure: count_dea_scheduled_medication {
    description: "Counts prescriptions that are Scheduled substances/medications by the DEA"
    type: count_distinct
    sql: ${care_requests.id} ;;
    filters: {
      field: dea_scheduled_medication
      value: "yes"
    }

  }
}
