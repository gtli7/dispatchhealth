view: athena_medication_details {
  sql_table_name: athena.medication ;;
  drill_fields: [medication_id]

  dimension: medication_id {
    primary_key: yes
    type: number
    group_label: "IDs"
    sql: ${TABLE}."medication_id" ;;
  }

  dimension: __batch_id {
    type: string
    hidden: yes
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension_group: __file {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    hidden: yes
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: brand_or_generic_indicator {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."brand_or_generic_indicator" ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
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

  dimension: dea_schedule {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."dea_schedule" ;;
  }

  dimension: fdb_med_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."fdb_med_id" ;;
  }

  dimension: gcn_clinical_forumulation_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."gcn_clinical_forumulation_id" ;;
  }

  dimension: hic1_code {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."hic1_code" ;;
  }

  dimension: hic1_description {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."hic1_description" ;;
  }

  dimension: hic2_pharmacological_class {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."hic2_pharmacological_class" ;;
  }

  dimension: hic3_code {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."hic3_code" ;;
  }

  dimension: hic3_description {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."hic3_description" ;;
  }

 # Scott bottom 3 new HIC3 medication classes to the antibiotic_medication yes/no on 2021/02/24
      # 'NITROFURAN DERIVATIVES ANTIBACTERIAL AGENTS',
      # 'ABSORBABLE SULFONAMIDE ANTIBACTERIAL AGENTS',
      # 'ANTIBIOTIC ANTIBACTERIAL MISC'

  dimension: antibiotic_medication {
    type: yesno
    group_label: "Descriptions"
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
      'VANCOMYCIN ANTIBIOTICS AND DERIVATIVES',

      'NITROFURAN DERIVATIVES ANTIBACTERIAL AGENTS',
      'ABSORBABLE SULFONAMIDE ANTIBACTERIAL AGENTS',
      'ANTIBIOTIC ANTIBACTERIAL MISC'
      );;
  }

  dimension: hic4_ingredient_base {
    type: string
    hidden: yes
    sql: ${TABLE}."hic4_ingredient_base" ;;
  }

  dimension: med_name_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."med_name_id" ;;
  }

  dimension: medication_name {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."medication_name" ;;
  }

  dimension: medication_name_short {
    description: "The first word of the medication name"
    type: string
    sql: INITCAP(split_part(${medication_name}, ' ', 1)) ;;
  }

  dimension: ndc {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."ndc" ;;
  }

  dimension: rxnorm {
    type: string
    hidden: yes
    sql: ${TABLE}."rxnorm" ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
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

  measure: count {
    type: count
    drill_fields: [medication_id, medication_name]
  }

  measure: count_dea_scheduled_medication {
    label: "Count Visits with DEA Scheduled Medication"
    description: "Counts care requests assoacited with a DEA scheduled substance/medication"
    type: count_distinct
    sql: ${care_requests.id} ;;
    filters: {
      field: dea_schedule
      value: "-NULL"
    }
  }
  dimension: uti_first_line_antibiotics {
    description: "First line antibiotics for UTI treatment (Antibiotic HIC3 classes: %cephalosporin%, %penicillin%, nitrofuran derivatives antibacterial agents, absorbable sulfonamide antibacterial agents AND a subset of medications in the 'antibiotic antibacterial misc' [trimethoprim% and fosfomycin%])"
    type: yesno
    sql: lower(${hic3_description}) in ('nitrofuran derivatives antibacterial agents', 'absorbable sulfonamide antibacterial agents')
      OR lower(${hic3_description}) LIKE '%cephalosporin%'
      OR lower(${hic3_description}) LIKE '%penicillin%'
      OR ((lower(${medication_name}) LIKE '%trimethoprim%'
        OR lower(${medication_name}) LIKE '%fosfomycin%')
        AND lower(${hic3_description}) != 'ophthalmic antibiotics') ;;

    group_label: "Care Pathway First Line Antibiotic Groups"
  }

  measure: count_uti_care_pathway_first_line_antibiotic_appointments {
    description: "Count appointments where first line UTI antibiotics were employed (Antibiotic HIC3 classes: %cephalosporin%, %penicillin%, nitrofuran derivatives antibacterial agents, absorbable sulfonamide antibacterial agents AND a subset of medications in the 'antibiotic antibacterial misc' [trimethoprim% and fosfomycin%])"
    type: count_distinct
    sql:  ${athena_clinicalencounter.clinical_encounter_id};;
    filters: [uti_first_line_antibiotics: "yes"]
    group_label: "Care Pathway First Line Antibiotic Groups"
  }



}
