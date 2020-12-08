view: diversion_categories_flat {
    sql_table_name: looker_scratch.diversion_categories_by_care_request ;;

dimension: care_request_id {
  primary_key: yes
  type: number
  sql: ${TABLE}.care_request_id ;;
}
  dimension: diagnosis_code1 {
    type: string
    sql: ${TABLE}.diagnosis_code1 ;;
  }
  dimension: diagnosis_code2 {
    type: string
    sql: ${TABLE}.diagnosis_code2 ;;
  }
  dimension: diagnosis_code3 {
    type: string
    sql: ${TABLE}.diagnosis_code3;;
  }
  dimension: diagnosis_only {
    description: "Diagnosis Only"
    type: number
    sql: ${TABLE}.diagnosis_only ;;
  }
  dimension: survey_yes_to_er {
    description: "Survey Response YES to ER"
    type: number
    sql: ${TABLE}.survey_yes_to_er ;;
  }
  dimension: diversion_911 {
    description: "911 Diversion Program"
    type: number
    sql: ${TABLE}.diversion_911 ;;
  }
  dimension: pos_snf {
    description: "POS SNF"
    type: number
    sql: ${TABLE}.pos_snf ;;
  }
  dimension: pos_al {
    description: "POS Assisted Living"
    type: number
    sql: ${TABLE}.pos_al ;;
  }
  dimension: referral {
    description: "Referred from Home Health, PCP or Care Mgmt"
    type: number
    sql: ${TABLE}.referral ;;
  }

  measure: count_referrals {
    type: sum
    sql: ${referral} ;;
  }
  dimension: after_hours {
    description: "Weekends or After 3 PM"
    type: number
    sql: ${TABLE}.after_hours ;;
  }
  dimension: abnormal_vitals {
    description: "Abnormal Vitals (O2 sat < 90%, HR > 100, SBP < 90 for adults)"
    type: number
    sql: ${TABLE}.abnormal_vitals ;;
  }
  dimension: confusion {
    description: "Additional Dx of Confusion or Altered Awareness"
    type: number
    sql: ${TABLE}.confusion ;;
  }
  dimension: wheelchair_hb {
    description: "Wheelchair or Homebound"
    type: number
    sql: ${TABLE}.wheelchair_hb ;;
  }
  dimension: ekg {
    description: "EKG Performed"
    type: number
    sql: ${TABLE}.ekg ;;
  }
  dimension: nebulizer {
    description: "Nebulizer Treatment"
    type: number
    sql: ${TABLE}.nebulizer ;;
  }
  dimension: iv_fluids {
    description: "IV/Fluids Administered"
    type: number
    sql: ${TABLE}.iv_fluids ;;
  }
  dimension: blood_tests {
    description: "Blood Tests Performed"
    type: number
    sql: ${TABLE}.blood_tests ;;
  }
  dimension: catheter_placement {
    description: "Catheter Adjustment or Placement"
    type: number
    sql: ${TABLE}.catheter_placement ;;
  }
  dimension: laceration_repair {
    description: "Laceration Repair"
    type: number
    sql: ${TABLE}.laceration_repair ;;
  }
  dimension: epistaxis {
    description: "Epistaxis Tx"
    type: number
    sql: ${TABLE}.epistaxis ;;
  }
  dimension: hernia_rp_reduction {
    description: "Rectal Prolapse Reduction or Hernia Reduction"
    type: number
    sql: ${TABLE}.hernia_rp_reduction ;;
  }
  dimension: joint_reduction {
    description: "Nursemaids elbow reduction or other joint reduction"
    type: number
    sql: ${TABLE}.joint_reduction ;;
  }
  dimension: gastronomy_tube {
    description: "Gastrostomy Tube replacement or repair"
    type: number
    sql: ${TABLE}.gastronomy_tube ;;
  }
  dimension: abscess_drain {
    description: "I&D of Abscess"
    type: number
    sql: ${TABLE}.abscess_drain ;;
  }
  dimension: dc22 {
    description: "POS SNF AND (abnormal vital signs  OR altered mental status)"
    type: number
    sql: ${TABLE}.dc22 ;;
  }
  dimension: dc23 {
    description: "POS SNF AND any procedures"
    type: number
    sql: ${TABLE}.dc23 ;;
  }
  dimension: dc24 {
    description: "POS SNF AND referral"
    type: number
    sql: ${TABLE}.dc24 ;;
  }
  dimension: dc25 {
    description: "POS SNF AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    sql: ${TABLE}.dc25 ;;
  }
  dimension: dc26 {
    description: "POS SNF AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    sql: ${TABLE}.dc26 ;;
  }
  dimension: dc27 {
    description: "POS AL AND (abnormal vital signs OR altered mental status)"
    type: number
    sql: ${TABLE}.dc27 ;;
  }
  dimension: dc28 {
    description: "POS AL AND procedures"
    type: number
    sql: ${TABLE}.dc28 ;;
  }
  dimension: dc29 {
    description: "POS AL AND referral"
    type: number
    sql: ${TABLE}.dc29 ;;
  }
  dimension: dc30 {
    description: "POS AL AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    sql: ${TABLE}.dc30 ;;
  }
  dimension: dc31 {
    description: "POS AL AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    sql: ${TABLE}.dc31 ;;
  }
  dimension: dc32 {
    description: "POS HOME AND (abnormal vital signs OR altered mental status)"
    type: number
    sql: ${TABLE}.dc32 ;;
  }
  dimension: dc33 {
    description: "POS HOME AND any procedures"
    type: number
    sql: ${TABLE}.dc33 ;;
  }
  dimension: dc34 {
    description: "POS HOME AND referral"
    type: number
    sql: ${TABLE}.dc34 ;;
  }
  dimension: dc35 {
    description: "POS HOME AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    sql: ${TABLE}.dc35 ;;
  }
  dimension: dc36 {
    description: "POS HOME AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    sql: ${TABLE}.dc36 ;;
  }
  dimension: dc37 {
    description: "POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status)"
    type: number
    sql: ${TABLE}.dc37 ;;
  }
  dimension: dc38 {
    description: "POS HOME AND wheelchair/homebound AND any procedures"
    type: number
    sql: ${TABLE}.dc38 ;;
  }
  dimension: dc39 {
    description: "POS HOME AND wheelchair/homebound AND referral"
    type: number
    sql: ${TABLE}.dc39 ;;
  }
  dimension: dc40 {
    description: "POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    sql: ${TABLE}.dc40 ;;
  }
  dimension: dc41 {
    description: "POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    sql: ${TABLE}.dc41 ;;
  }

  dimension: identify_pops_exclude_from_diversion_cats {
    description: "Excludes post acute follow ups, dh follow ups and escalated on-scene care requests from the diversion category sum measures"
    type: yesno
    sql: ${care_request_flat.escalated_on_scene} ;;
  }

measure: sum_diagnosis_olny {
  label: "DC01: Diagnosis Only"
  type: sum_distinct
  sql_distinct_key: ${care_request_id} ;;
  sql: ${diagnosis_only} ;;
  group_label: "Diversion Category Sum Measures"
  filters: {
    field: identify_pops_exclude_from_diversion_cats
    value: "no"
  }
  filters: {
    field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
    value: "No"
  }
}

  measure: sum_survey_yes_to_er {
    label: "DC02: Survey Response YES to ER"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${survey_yes_to_er} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_diversion_911 {
    label: "DC03: 911 Diversion Program"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${diversion_911} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_pos_snf {
    label: "DC04: POS Skilled Nursing Facility"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${pos_snf} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_pos_al {
    label: "DC05: POS Assisted Living"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${pos_al} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_referral {
    label: "DC06: Referred from Home Health, PCP or Care Mgmt"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${referral} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_after_hours {
    label: "DC07: Weekends or After 3 PM"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${after_hours} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_abnormal_vitals {
    label: "DC08: Abnormal Vitals (O2 sat < 90%, HR > 100, SBP < 90 for adults)"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${abnormal_vitals} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_confusion {
    label: "DC09: Additional Dx of Confusion or Altered Awareness"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${confusion} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_wheelchair_hb {
    label: "DC10: Wheelchair or Homebound"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${wheelchair_hb} ;;
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_ekg {
    label: "DC11: EKG Performed"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${ekg} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_nebulizer {
    label: "DC12: Nebulizer Treatment"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${nebulizer} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_iv_fluids {
    label: "DC13: IV/Fluids Administered"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${iv_fluids} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_blood_tests {
    label: "DC14: Blood Tests Performed"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${blood_tests} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_catheter_placement {
    label: "DC15: Catheter Adjustment or Placement"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${catheter_placement} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_laceration_repair {
    label: "DC16: Laceration Repair"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${laceration_repair} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_epistaxis {
    label: "DC17: Epistaxis Tx"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${epistaxis} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_hernia_rp_reduction {
    label: "DC18: Rectal Prolapse Reduction or Hernia Reduction"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${hernia_rp_reduction} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_joint_reduction {
    label: "DC19: Nursemaids elbow reduction or other joint reduction"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${joint_reduction} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_gastronomy_tube {
    label: "DC20: Gastrostomy Tube replacement or repair"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${gastronomy_tube} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_abscess_drain {
    label: "DC21: I&D of Abscess"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${abscess_drain} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc22 {
    label: "DC22: POS SNF AND (abnormal vital signs  OR altered mental status)"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc22} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc23 {
    label: "DC23: POS SNF AND any procedures"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc23} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc24 {
    label: "DC24: POS SNF AND referral"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc24} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc25 {
    label: "DC25: POS SNF AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc25} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc26 {
    label: "DC26: POS SNF AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc26} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc27 {
    label: "DC27: POS AL AND (abnormal vital signs OR altered mental status)"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc27} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc28 {
    label: "DC28: POS AL AND procedures"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc28} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc29 {
    label: "DC29: POS AL AND referral"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc29} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc30 {
    label: "DC30: POS AL AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc30} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc31 {
    label: "DC31: POS AL AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc31} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc32 {
    label: "DC32: POS HOME AND (abnormal vital signs OR altered mental status)"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc32} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc33 {
    label: "DC33: POS HOME AND any procedures"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc33} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc34 {
    label: "DC34: POS HOME AND referral"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc34} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc35 {
    label: "DC35: POS HOME AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc35} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc36 {
    label: "DC36: POS HOME AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc36} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc37 {
    label: "DC37: POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status)"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc37} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc38 {
    label: "DC38: POS HOME AND wheelchair/homebound AND any procedures"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc38} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc39 {
    label: "DC39: POS HOME AND wheelchair/homebound AND referral"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc39} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc40 {
    label: "DC40: POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc40} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: sum_dc41 {
    label: "DC41: POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: sum_distinct
    sql_distinct_key: ${care_request_id} ;;
    sql: ${dc41} ;;
    group_label: "Diversion Category Sum Measures"
    filters: {
      field: identify_pops_exclude_from_diversion_cats
      value: "no"
    }
    filters: {
      field: care_requests.billable_est_excluding_bridge_care_and_dh_followups
      value: "No"
    }
  }

  measure: pct_diagnosis_olny_of_billable_est {
    label: "DC01: Pct Diagnosis Only"
    type: number
    sql:  ${sum_diagnosis_olny} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups};;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_survey_yes_to_er_of_billable_est {
    label: "DC02: Pct Survey Response YES to ER"
    type: number
    sql:  ${sum_survey_yes_to_er} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups};;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_diversion_911_of_billable_est {
    label: "DC03: Pct 911 Diversion Program"
    type: number
    sql:  ${sum_diversion_911} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_pos_snf_of_billable_est {
    label: "DC04: Pct POS Skilled Nursing Facility"
    type: number
    sql:  ${sum_pos_snf} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups};;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_pos_al_of_billable_est {
    label: "DC05: Pct POS Assisted Living"
    type: number
    sql:  ${sum_pos_al} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_referral_of_billable_est {
    label: "DC06: Pct Referred from Home Health, PCP or Care Mgmt"
    type: number
    sql:  ${sum_referral} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_after_hours_of_billable_est {
    label: "DC07: Pct Weekends or After 3 PM"
    type: number
    sql:  ${sum_after_hours} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_abnormal_vitals_of_billable_est {
    label: "DC08: Pct  Abnormal Vitals (O2 sat < 90%, HR > 100, SBP < 90 for adults)"
    type: number
    sql:  ${sum_abnormal_vitals} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_confusion_of_billable_est {
    label: "DC09: Pct Additional Dx of Confusion or Altered Awareness"
    type: number
    sql:  ${sum_confusion} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_wheelchair_hb_of_billable_est {
    label: "DC10: Pct Wheelchair or Homebound"
    type: number
    sql:  ${sum_wheelchair_hb} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_ekg_of_billable_est {
    label: "DC11: Pct EKG Performed"
    type: number
    sql:  ${sum_ekg} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_nebulizer_of_billable_est {
    label: "DC12: Pct Nebulizer Treatment"
    type: number
    sql:  ${sum_nebulizer} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_iv_fluids_of_billable_est {
    label: "DC13: Pct IV/Fluids Administered"
    type: number
    sql:  ${sum_iv_fluids} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_blood_tests_of_billable_est {
    label: "DC14: Pct Blood Tests Performed"
    type: number
    sql:  ${sum_blood_tests} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_catheter_placement_of_billable_est {
    label: "DC15: Pct Catheter Adjustment or Placement"
    type: number
    sql:  ${sum_catheter_placement} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_laceration_repair_of_billable_est {
    label: "DC16: Pct Laceration Repair"
    type: number
    sql:  ${sum_laceration_repair} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_epistaxis_of_billable_est {
    label: "DC17: Pct Epistaxis Tx"
    type: number
    sql:  ${sum_epistaxis} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_hernia_rp_reduction_of_billable_est {
    label: "DC18: Pct Rectal Prolapse Reduction or Hernia Reduction"
    type: number
    sql:  ${sum_hernia_rp_reduction} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_joint_reduction_of_billable_est {
    label: "DC19: Pct Nursemaids elbow reduction or other joint reduction"
    type: number
    sql: ${sum_joint_reduction} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_gastronomy_tube_of_billable_est {
    label: "DC20: Pct Gastrostomy Tube replacement or repair"
    type: number
    sql:  ${sum_gastronomy_tube} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
   group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_abscess_drain_of_billable_est {
    label: "DC21: Pct I&D of Abscess"
    type: number
    sql:  ${sum_abscess_drain} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups};;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc22_of_billable_est {
    label: "DC22: Pct POS SNF AND (abnormal vital signs  OR altered mental status)"
    type: number
    sql:  ${sum_dc22} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc23_of_billable_est {
    label: "DC23: Pct POS SNF AND any procedures"
    type: number
    sql:  ${sum_dc23} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc24_of_billable_est {
    label: "DC24: Pct POS SNF AND referral"
    type: number
    sql:  ${sum_dc24} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc25_of_billable_est {
    label: "DC25: Pct POS SNF AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    sql:  ${sum_dc25} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc26_of_billable_est {
    label: "DC26: Pct POS SNF AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    sql:  ${sum_dc26} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc27_of_billable_est {
    label: "DC27: Pct POS AL AND (abnormal vital signs OR altered mental status)"
    type: number
    sql:  ${sum_dc27} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc28_of_billable_est {
    label: "DC28: Pct POS AL AND procedures"
    type: number
    sql: ${sum_dc28} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc29_of_billable_est {
    label: "DC29: Pct POS AL AND referral"
    type: number
    sql:  ${sum_dc29} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc30_of_billable_est {
    label: "DC30: Pct POS AL AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    sql:  ${sum_dc30} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc31_of_billable_est {
    label: "DC31: Pct POS AL AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    sql:  ${sum_dc31} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc32_of_billable_est {
    label: "DC32: Pct POS HOME AND (abnormal vital signs OR altered mental status)"
    type: number
    sql:  ${sum_dc32} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc33_of_billable_est {
    label: "DC33: Pct POS HOME AND any procedures"
    type: number
    sql:  ${sum_dc33} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc34_of_billable_est {
    label: "DC34: Pct POS HOME AND referral"
    type: number
    sql:  ${sum_dc34} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc35_of_billable_est {
    label: "DC35: Pct POS HOME AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    sql:  ${sum_dc35} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc36_of_billable_est {
    label: "DC36: Pct POS HOME AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    sql:  ${sum_dc36} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc37_of_billable_est {
    label: "DC37: Pct POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status)"
    type: number
    sql:  ${sum_dc37} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc38_of_billable_est {
    label: "DC38: Pct POS HOME AND wheelchair/homebound AND any procedures"
    type: number
    sql:  ${sum_dc38} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc39_of_billable_est {
    label: "DC39: Pct POS HOME AND wheelchair/homebound AND referral"
    type: number
    sql:  ${sum_dc39} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc40_of_billable_est {
    label: "DC40: Pct POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    sql:  ${sum_dc40} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

  measure: pct_dc41_of_billable_est {
    label: "DC41: Pct POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    sql:  ${sum_dc41} / ${care_requests.sum_billable_est_excluding_bridge_care_and_dh_followups} ;;
    value_format: "0.00%"
    group_label: "Diversion Category Pct of Billable Est Measures"
  }

}
