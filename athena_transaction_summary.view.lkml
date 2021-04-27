view: athena_transaction_summary {
  sql_table_name: athena.transactions_summary ;;


  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: claim_id {
    primary_key: no
    type: number
    sql: ${TABLE}.claim_id ;;
  }

  dimension: gpci_work_multiplier {
    type: number
    group_label: "GPCI Multipliers"
    description: "The GPCI work multiplier for Medicare reimbursement"
    sql: CASE WHEN ${markets.short_name_adj} IN ('ATL','BOI','CLE','COS','DEN','IND',
    'KNX','MIA','NSH','OKC','OLY','PHX','RDU','RIC','SPO','TAC','TPA') THEN 1.000
  WHEN ${markets.short_name_adj} IN ('LAS','RNO') THEN 1.004
  WHEN ${markets.short_name_adj} = 'FTW' THEN 1.011
  WHEN ${markets.short_name_adj} = 'POR' THEN 1.016
  WHEN ${markets.short_name_adj} = 'DAL' THEN 1.018
WHEN ${markets.short_name_adj} = 'SPR' THEN 1.023
WHEN ${markets.short_name_adj} = 'HOU' THEN 1.026
WHEN ${markets.short_name_adj} = 'HRT' THEN 1.029
WHEN ${markets.short_name_adj} = 'SEA' THEN 1.031
WHEN ${markets.short_name_adj} IN ('MOR','NJR') THEN 1.045
ELSE NULL END ;;
value_format: "0.0000"
  }

  dimension: gpci_facility_multiplier {
    type: number
    group_label: "GPCI Multipliers"
    description: "The GPCI facility multiplier for Medicare reimbursement"
    sql: CASE
WHEN ${markets.short_name_adj} = 'OKC' THEN 0.886
WHEN ${markets.short_name_adj} = 'ATL' THEN 0.889
WHEN ${markets.short_name_adj} = 'BOI' THEN 0.890
WHEN ${markets.short_name_adj} = 'KNX' THEN 0.897
WHEN ${markets.short_name_adj} = 'NSH' THEN 0.897
WHEN ${markets.short_name_adj} = 'IND' THEN 0.910
WHEN ${markets.short_name_adj} = 'CLE' THEN 0.915
WHEN ${markets.short_name_adj} = 'RDU' THEN 0.930
WHEN ${markets.short_name_adj} = 'TPA' THEN 0.946
WHEN ${markets.short_name_adj} = 'PHX' THEN 0.961
WHEN ${markets.short_name_adj} = 'RIC' THEN 0.991
WHEN ${markets.short_name_adj} = 'FTW' THEN 0.991
WHEN ${markets.short_name_adj} = 'LAS' THEN 1.000
WHEN ${markets.short_name_adj} = 'RNO' THEN 1.000
WHEN ${markets.short_name_adj} = 'OLY' THEN 1.012
WHEN ${markets.short_name_adj} = 'SPO' THEN 1.012
WHEN ${markets.short_name_adj} = 'TAC' THEN 1.012
WHEN ${markets.short_name_adj} = 'DAL' THEN 1.020
WHEN ${markets.short_name_adj} = 'HOU' THEN 1.020
WHEN ${markets.short_name_adj} = 'MIA' THEN 1.026
WHEN ${markets.short_name_adj} = 'COS' THEN 1.033
WHEN ${markets.short_name_adj} = 'DEN' THEN 1.033
WHEN ${markets.short_name_adj} = 'POR' THEN 1.059
WHEN ${markets.short_name_adj} = 'SPR' THEN 1.064
WHEN ${markets.short_name_adj} = 'HRT' THEN 1.113
WHEN ${markets.short_name_adj} = 'SEA' THEN 1.170
WHEN ${markets.short_name_adj} = 'MOR' THEN 1.190
WHEN ${markets.short_name_adj} = 'NJR' THEN 1.190
ELSE NULL END ;;
value_format: "0.0000"
  }

  dimension: gpci_malpractice_multiplier {
    type: number
    group_label: "GPCI Multipliers"
    description: "The GPCI malpractice multiplier for Medicare reimbursement"
    sql: CASE
WHEN ${markets.short_name_adj} = 'IND' THEN 0.422
WHEN ${markets.short_name_adj} = 'BOI' THEN 0.464
WHEN ${markets.short_name_adj} = 'KNX' THEN 0.509
WHEN ${markets.short_name_adj} = 'NSH' THEN 0.509
WHEN ${markets.short_name_adj} = 'FTW' THEN 0.643
WHEN ${markets.short_name_adj} = 'DAL' THEN 0.657
WHEN ${markets.short_name_adj} = 'POR' THEN 0.659
WHEN ${markets.short_name_adj} = 'RDU' THEN 0.757
WHEN ${markets.short_name_adj} = 'OLY' THEN 0.823
WHEN ${markets.short_name_adj} = 'SPO' THEN 0.823
WHEN ${markets.short_name_adj} = 'TAC' THEN 0.823
WHEN ${markets.short_name_adj} = 'PHX' THEN 0.846
WHEN ${markets.short_name_adj} = 'SEA' THEN 0.854
WHEN ${markets.short_name_adj} = 'OKC' THEN 0.868
WHEN ${markets.short_name_adj} = 'RIC' THEN 0.903
WHEN ${markets.short_name_adj} = 'COS' THEN 0.905
WHEN ${markets.short_name_adj} = 'DEN' THEN 0.905
WHEN ${markets.short_name_adj} = 'HOU' THEN 0.918
WHEN ${markets.short_name_adj} = 'MOR' THEN 0.949
WHEN ${markets.short_name_adj} = 'NJR' THEN 0.949
WHEN ${markets.short_name_adj} = 'SPR' THEN 0.952
WHEN ${markets.short_name_adj} = 'ATL' THEN 0.989
WHEN ${markets.short_name_adj} = 'CLE' THEN 1.049
WHEN ${markets.short_name_adj} = 'HRT' THEN 1.094
WHEN ${markets.short_name_adj} = 'LAS' THEN 1.130
WHEN ${markets.short_name_adj} = 'RNO' THEN 1.130
WHEN ${markets.short_name_adj} = 'TPA' THEN 1.396
WHEN ${markets.short_name_adj} = 'MIA' THEN 2.598
ELSE NULL END ;;
    value_format: "0.0000"
  }

  dimension: rvu_goal_medicare {
    type: number
    group_label: "Goals"
    description: "The RVU Goal for Medicare"
    sql: CASE
WHEN ${markets.short_name_adj} = 'DEN' THEN 122.29
WHEN ${markets.short_name_adj} = 'RIC' THEN 125.34
WHEN ${markets.short_name_adj} = 'LAS' THEN 136.35
WHEN ${markets.short_name_adj} = 'PHX' THEN 127.62
WHEN ${markets.short_name_adj} = 'OKC' THEN 136.56
WHEN ${markets.short_name_adj} = 'HOU' THEN 127.03
WHEN ${markets.short_name_adj} = 'COS' THEN 116.13
WHEN ${markets.short_name_adj} = 'SPO' THEN 132.21
WHEN ${markets.short_name_adj} = 'FTW' THEN 120.67
WHEN ${markets.short_name_adj} = 'TAC' THEN 128.61
WHEN ${markets.short_name_adj} = 'SPR' THEN 116.67
WHEN ${markets.short_name_adj} = 'NJR' THEN 133.16
WHEN ${markets.short_name_adj} = 'ATL' THEN 127.06
WHEN ${markets.short_name_adj} = 'DAL' THEN 127.72
WHEN ${markets.short_name_adj} = 'SEA' THEN 141.28
WHEN ${markets.short_name_adj} = 'POR' THEN 136.38
WHEN ${markets.short_name_adj} = 'BOI' THEN 140.13
ELSE NULL
END;;
}

  dimension: is_valid_claim {
    type: yesno
    description: ""
    sql: ${athena_appointment.no_charge_entry_reason} IS NULL AND
      ${expected_allowable} > 0.01 ;;
  }

  measure: count_claims {
    type: count_distinct
    description: "Count of claims where no charge entry reason is NULL and exp. allowable > 0.01"
    sql: ${claim_id} ;;
    filters: [is_valid_claim: "yes"]
  }

  dimension: payments {
    type: number
    hidden: yes
    value_format: "$#,##0.00"
    group_label: "Payments"
    sql: ${TABLE}.payments ;;
  }

  measure: total_payments {
    type: sum_distinct
    value_format: "$#,##0.00"
    group_label: "Payments"
    sql_distinct_key: ${claim_id} ;;
    sql: ${payments} ;;
  }

  dimension: work_rvu {
    type: number
    hidden: no
    group_label: "RVUs"
    value_format: "0.00"
    sql: ${TABLE}.work_rvu ;;
  }

  measure: sum_work_rvu {
    type: sum_distinct
    group_label: "RVUs"
    value_format: "0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${work_rvu} ;;
    filters: [is_valid_claim: "yes"]
  }

  measure: average_work_rvus {
    type: average_distinct
    group_label: "RVUs"
    value_format: "0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${work_rvu} ;;
    filters: [is_valid_claim: "yes"]
  }

  dimension: practice_expense_rvu {
    type: number
    hidden: no
    group_label: "RVUs"
    value_format: "0.00"
    sql: ${TABLE}.practice_expense_rvu ;;
  }

  dimension: malpractice_rvu {
    type: number
    hidden: no
    group_label: "RVUs"
    value_format: "0.00"
    sql: ${TABLE}.malpractice_rvu ;;
  }

  # measure: sum_practice_expense_rvu {
  #   type: sum_distinct
  #   group_label: "RVUs"
  #   value_format: "0.00"
  #   sql_distinct_key: ${claim_id} ;;
  #   sql: ${practice_expense_rvu} ;;
  #   filters: [is_valid_claim: "yes"]
  # }

  # measure: average_practice_expense_rvus {
  #   type: average_distinct
  #   group_label: "RVUs"
  #   value_format: "0.00"
  #   sql_distinct_key: ${claim_id} ;;
  #   sql: ${work_rvu} ;;
  #   filters: [is_valid_claim: "yes"]
  # }

  dimension: total_rvu {
    type: number
    hidden: yes
    group_label: "RVUs"
    value_format: "0.00"
    sql: ${TABLE}.total_rvu ;;
  }

  measure: sum_total_rvus {
    type: sum_distinct
    group_label: "RVUs"
    value_format: "0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${total_rvu} ;;
    filters: [is_valid_claim: "yes"]
  }

  measure: average_total_rvus {
    type: average_distinct
    group_label: "RVUs"
    value_format: "0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${total_rvu} ;;
    filters: [is_valid_claim: "yes"]
    drill_fields: [users.app_name, care_requests.count_billable_est, average_total_rvus]
  }

  dimension: allowed_amount {
    type: number
    group_label: "Expected Allowable"
    description: "The allowed amount for Medicare reimbursement (RVU's x GPCI Multipliers x $36.09 x 17% discount)"
    value_format: "$#,##0.00"
    sql: ((${work_rvu} * ${gpci_work_multiplier}) +
          (${practice_expense_rvu} * ${gpci_facility_multiplier}) +
          (${malpractice_rvu} * ${gpci_malpractice_multiplier})) * 36.09 * 0.83 ;;
  }

  measure: total_allowed_amount {
    type: sum_distinct
    group_label: "Expected Allowable"
    description: "The total allowed amount for Medicare reimbursement"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${allowed_amount} ;;
    filters: [is_valid_claim: "yes"]
  }

  measure: average_allowed_amount {
    type: average_distinct
    group_label: "Expected Allowable"
    description: "The average allowed amount for Medicare reimbursement"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${allowed_amount} ;;
    filters: [is_valid_claim: "yes"]
  }

  # dimension: expected_allowable {
  #   type: number
  #   value_format: "0.00"
  #   group_label: "Expected Allowable"
  #   sql: ${TABLE}.expected_allowable ;;
  # }

  dimension: expected_allowable {
    description: "Expected Allowable values sourced from Athena. $0.01 placeholder values (defined as pre-paid) are hard coded to return a value of $210.00"
    type: number
    value_format: "0.00"
    group_label: "Expected Allowable"
    sql: CASE WHEN ${TABLE}.expected_allowable = 0.01 THEN 210.00
    ELSE ${TABLE}.expected_allowable
    END;;
  }

  measure: total_expected_allowable {
    type: sum_distinct
    group_label: "Expected Allowable"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${expected_allowable} ;;
  }

  measure: average_expected_allowable {
    type: average_distinct
    group_label: "Expected Allowable"
    value_format: "$#,##0.00"
    sql_distinct_key: ${id} ;;
    sql: ${expected_allowable} ;;
    filters: [is_valid_claim: "yes"]
  }

  dimension: work_expected_allowable {
    type: number
    description: "Expected allowable associated with provider work (excludes transactions where work RVU is zero)"
    value_format: "0.00"
    group_label: "Expected Allowable"
    sql: ${TABLE}.work_expected_allowable ;;
  }

  measure: total_work_expected_allowable {
    type: sum_distinct
    description: "Expected allowable associated with provider work (excludes transactions where work RVU is zero)"
    group_label: "Expected Allowable"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${work_expected_allowable} ;;
  }

  measure: average_work_expected_allowable {
    type: average_distinct
    description: "Expected allowable associated with provider work (excludes transactions where work RVU is zero)"
    group_label: "Expected Allowable"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${work_expected_allowable} ;;
    filters: [is_valid_claim: "yes"]
  }

  dimension: patient_responsibility {
    type: number
    hidden: yes
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility ;;
  }

  measure: total_patient_responsibility {
    type: sum_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility} ;;
  }

  measure: average_patient_responsibility {
    type: average_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility} ;;
  }

  dimension: patient_responsibility_copay {
    type: number
    hidden: yes
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility_copay ;;
  }

  measure: total_patient_responsibility_copay {
    type: sum_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_copay} ;;
  }

  measure: average_patient_responsibility_copay {
    type: average_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_copay} ;;
  }

  dimension: patient_responsibility_coinsurance {
    type: number
    hidden: yes
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility_coinsurance ;;
  }

  measure: total_patient_responsibility_coinsurance {
    type: sum_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_coinsurance} ;;
  }

  measure: average_patient_responsibility_coinsurance {
    type: average_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_coinsurance} ;;
  }

  dimension: patient_responsibility_deductible {
    type: number
    hidden: yes
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility_deductible ;;
  }
  measure: total_patient_responsibility_deductible {
    type: sum_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_deductible} ;;
  }
  measure: average_patient_responsibility_deductible {
    type: average_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_deductible} ;;
  }

  dimension: patient_responsibility_without_secondary {
    type: number
    hidden: yes
    value_format: "$#,##0.00"
    sql: ${TABLE}.patient_responsibility_without_secondary ;;
  }

  measure: total_patient_responsibility_without_secondary {
    type: sum_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_without_secondary} ;;
  }

  measure: average_patient_responsibility_without_secondary {
    type: average_distinct
    group_label: "Patient Responsibility"
    value_format: "$#,##0.00"
    sql_distinct_key: ${claim_id} ;;
    sql: ${patient_responsibility_without_secondary} ;;
  }

}
