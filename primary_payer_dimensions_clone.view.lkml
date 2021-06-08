view: primary_payer_dimensions_clone {
  # sql_table_name: looker_scratch.primary_payer_dimensions_clone ;;
  derived_table: {
    sql:
    SELECT
  claim.claim_id,
  claim.claim_appointment_id::varchar AS appointment_id,
  pay.insurance_package_id,
  pay.insurance_package_name,
  pay.insurance_package_type,
  pay.insurance_reporting_category,
  pay.irc_group,
  pay.custom_insurance_grouping
    FROM athena.claim
    INNER JOIN athena.patientinsurance pi
        ON claim.claim_primary_patient_ins_id = pi.patient_insurance_id
    LEFT JOIN athena.payer pay
        ON pi.insurance_package_id = pay.insurance_package_id
    WHERE pi.sequence_number = '1' AND claim.primary_claim_status = 'CLOSED'
    GROUP BY 1,2,3,4,5;;
    indexes: ["claim_id","insurance_package_id"]

  sql_trigger_value: SELECT MAX(claim_id) FROM athena.claim ;;

  }

  dimension: claim_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.claim_id ;;
  }

  dimension: appointment_id {
    type: string
    sql: ${TABLE}.appointment_id ;;
  }
  # dimension_group: created {
  #   hidden: yes
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}.created_at ;;
  # }

  dimension: custom_insurance_grouping {
    type: string
    order_by_field: insurance_sort_value
    # sql: case when ${insurance_package_id}::int in(22741, 47756, 54360, 75708) then '(MMCD)MANAGED MEDICAID'
    #   else ${TABLE}.custom_insurance_grouping end;;
    sql: ${TABLE}.custom_insurance_grouping;;
    drill_fields: [insurance_package_type, insurance_reporting_category, insurance_package_name]
  }

  dimension: medicare_advantage_flag {
    type: yesno
    hidden: yes
    sql: ${custom_insurance_grouping} =  '(MA)MEDICARE ADVANTAGE';;
  }

  dimension: commercial_flag {
    type: yesno
    hidden: yes
    sql: ${custom_insurance_grouping} =  '(CM)COMMERCIAL';;
  }

  dimension: medicare_flag {
    type: yesno
    hidden: yes
    sql: ${custom_insurance_grouping} =  '(MCARE)MEDICARE';;
  }

  dimension: medicaid_flag {
    type: yesno
    hidden: yes
    sql: ${custom_insurance_grouping} =  '(MAID)MEDICAID';;
  }

  dimension: custom_insurance_label {
    type: string
    description: "The custom insurance grouping, printed nicely for reporting"
    sql: CASE ${custom_insurance_grouping}
         WHEN '(CB)CORPORATE BILLING' THEN 'Corporate Billing'
        WHEN '(MA)MEDICARE ADVANTAGE' THEN 'Medicare Advantage'
        WHEN '(MAID)MEDICAID' THEN 'Medicaid'
        WHEN '(MMCD)MANAGED MEDICAID' THEN 'Managed Medicaid'
        WHEN '(MCARE)MEDICARE' THEN 'Medicare'
        WHEN '(PSP)PATIENT SELF-PAY' THEN 'Patient Self Pay'
        WHEN 'PATIENT RESPONSIBILITY' THEN 'Patient Self Pay'
        WHEN '(CM)COMMERCIAL' THEN 'Commercial'
        WHEN '(TC)TRICARE' THEN 'Tricare'
        ELSE 'Other'
        END;;
    drill_fields: [insurance_package_type, insurance_reporting_category, insurance_package_name]
  }

  dimension: custom_insurance_label_grouped {
    type: string
    description: "Custom insurance grouping where Commercial/MA and Medicaid/Tricare are grouped"
    sql: CASE
            when ${custom_insurance_label} in('Corporate Billing', 'Patient Self Pay', 'Commercial', 'Medicare Advantage') then 'Commercial/Medicare Advantage/Self-Pay'
            when ${custom_insurance_label} in('Managed Medicaid') then 'Managed Medicaid'
            when ${custom_insurance_label} in('Medicare') then 'Medicare'
            when ${custom_insurance_label} in('Medicaid', 'Tricare') then 'Medicaid/Tricare'
            else 'Other'
         END;;
    drill_fields: [custom_insurance_grouping, insurance_package_type, insurance_reporting_category, insurance_package_name]
  }


  dimension: insurance_sort_value {
    type: number
    hidden: yes
    sql: CASE ${custom_insurance_grouping}
         WHEN '(CB)CORPORATE BILLING' THEN 8
        WHEN '(MA)MEDICARE ADVANTAGE' THEN 2
        WHEN '(MAID)MEDICAID' THEN 4
        WHEN '(MMCD)MANAGED MEDICAID' THEN 7
        WHEN '(MCARE)MEDICARE' THEN 3
        WHEN '(PSP)PATIENT SELF-PAY' THEN 6
        WHEN 'PATIENT RESPONSIBILITY' THEN 6
        WHEN '(CM)COMMERCIAL' THEN 1
        WHEN '(TC)TRICARE' THEN 5
        ELSE 9
        END;;
  }

  dimension: payer_type {
    type: string
    description: "Payer type grouped into a concise number of groups"
    sql: CASE
          WHEN ${custom_insurance_grouping} IN ('(CM)COMMERCIAL', '(MA)MEDICARE ADVANTAGE') THEN 'Commercial/Medicare Advantage'
          WHEN ${custom_insurance_grouping} IN ('(MAID)MEDICAID', '(MMCD)MANAGED MEDICAID', '(MCARE)MEDICARE', '(TC)TRICARE') THEN 'Medicare/Medicaid/Tricare'
          WHEN ${custom_insurance_grouping} IN ('(PSP)PATIENT SELF-PAY', 'PATIENT RESPONSIBILITY') THEN 'Patient Self Pay'
          WHEN ${custom_insurance_grouping} = '(CB)CORPORATE BILLING' THEN 'Corporate Billing'
          ELSE 'Other'
          END;;
    drill_fields: [custom_insurance_grouping, insurance_package_type, insurance_reporting_category, insurance_package_name]
  }

  dimension: insurance_package_id {
    label: "Insurance Package ID"
    type: string
    sql: case when ${TABLE}.insurance_package_id = '' then '9999999999999999'
      else ${TABLE}.insurance_package_id end;;
  }

  dimension: insurance_package_name {
    type: string
    sql: ${TABLE}.insurance_package_name ;;
    drill_fields: [insurance_package_type, insurance_reporting_category]
  }

  dimension: insurance_package_name_consolidated {
    type: string
    sql: CASE
          WHEN when UPPER(${insurance_package_name}) LIKE '%HEALTH PLAN OF NEVADA%' THEN 'Health Plan of Nevada'
          WHEN when UPPER(${insurance_package_name}) LIKE '%CULINARY%' THEN 'Culinary'
          ELSE ${insurance_package_name}
        END ;;
    drill_fields: [insurance_package_type, insurance_reporting_category]
  }

  dimension: united_healthcare_category {
    type: string
    sql: case when ${insurance_package_name} in('HEALTH PLAN OF NEVADA - SIERRA HEALTH & LIFE - SENIOR DIMENSION (MEDICARE REPLACEMENT HMO)') then 'HPN Medicare Advantage'
              when ${insurance_package_name} in('HEALTH PLAN OF NEVADA - SMARTCHOICE (MEDICAID HMO)') then 'HPN Managed Medicaid'
              when ${insurance_package_name} in('HEALTH PLAN OF NEVADA - UNITED HEALTHCARE CHOICE PLUS (POS)', 'SIERRA HEALTH LIFE') then 'HPN Commercial'
              when ${insurance_package_name} in('UHC WEST - AARP - MEDICARE SOLUTIONS - MEDICARE COMPLETE (MEDICARE REPLACEMENT HMO)', 'UHC - AARP - MEDICARE SOLUTIONS - MEDICARE COMPLETE (MEDICARE REPLACEMENT PPO) ') then 'UHC Medicare Advantage'
              when ${insurance_package_name} in('UMR', 'UNITED HEALTHCARE', 'UNITED HEALTHCARE (PPO)') then 'UHC Commercial'
              else null end;;
  }

  dimension: uhc_reporting_category {
    description: "Consolidated insurance package names for Nevada UHC payer reporting"
    type: string
    sql: case when ${insurance_package_name} in('HEALTH PLAN OF NEVADA - SIERRA HEALTH & LIFE - SENIOR DIMENSION (MEDICARE REPLACEMENT HMO)',
                                                'UHC - AARP - MEDICARE SOLUTIONS - MEDICARE COMPLETE (MEDICARE REPLACEMENT PPO)',
                                                'UHC WEST - AARP - MEDICARE SOLUTIONS - MEDICARE COMPLETE (MEDICARE REPLACEMENT HMO)')
          then 'HPN Medicare Advantage'
              when ${insurance_package_name} in('HEALTH PLAN OF NEVADA - SMARTCHOICE (MEDICAID HMO)')
          then 'HPN Managed Medicaid'
              when ${insurance_package_name} in('HEALTH PLAN OF NEVADA - UNITED HEALTHCARE CHOICE PLUS (POS)',
                                                'SIERRA HEALTH LIFE',
                                                'UMR',
                                                'UNITED HEALTHCARE',
                                                'UNITED HEALTHCARE (PPO)')
          then 'HPN Commercial'
              else null end;;
  }

  dimension: insurance_package_type {
    type: string
    sql: ${TABLE}.insurance_package_type ;;
    drill_fields: [insurance_reporting_category, insurance_package_name]
  }

  dimension: insurance_reporting_category {
    type: string
    sql: ${TABLE}.insurance_reporting_category ;;
    drill_fields: [insurance_package_name]
  }

  dimension: irc_group {
    label: "IRC Group"
    type: string
    sql: ${TABLE}.irc_group ;;
  }

  # dimension_group: updated {
  #   hidden: yes
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}.updated_at ;;
  # }

  dimension: expected_allowable_est_hardcoded {
    type: number
    sql: case when ${markets.name} = 'Colorado Springs' and ${custom_insurance_grouping} = '(CM)COMMERCIAL' then 252.63
    when ${markets.name} = 'Colorado Springs' and ${custom_insurance_grouping} = '(MA)MEDICARE ADVANTAGE' then 251.37
    when ${markets.name} = 'Colorado Springs' and ${custom_insurance_grouping} = '(MAID)MEDICAID' then 102.25
    when ${markets.name} = 'Colorado Springs' and ${custom_insurance_grouping} = '(MCARE)MEDICARE' then 135.00
    when ${markets.name} = 'Colorado Springs' and ${custom_insurance_grouping} = '(PSP)PATIENT SELF-PAY' then 273.04
    when ${markets.name} = 'Colorado Springs' and ${custom_insurance_grouping} = '(TC)TRICARE' then  118.12
    when ${markets.name} = 'Colorado Springs' then 162.46
    when ${markets.name} = 'Denver' and ${custom_insurance_grouping} = '(CB)CORPORATE BILLING' then 133.10
    when ${markets.name} = 'Denver' and ${custom_insurance_grouping} = '(CM)COMMERCIAL' then 251.08
    when ${markets.name} = 'Denver' and ${custom_insurance_grouping} = '(MA)MEDICARE ADVANTAGE' then 261.99
    when ${markets.name} = 'Denver' and ${custom_insurance_grouping} = '(MAID)MEDICAID' then  108.83
    when ${markets.name} = 'Denver' and ${custom_insurance_grouping} = '(MCARE)MEDICARE' then 135.00
    when ${markets.name} = 'Denver' and ${custom_insurance_grouping} = '(PSP)PATIENT SELF-PAY' then 274.32
    when ${markets.name} = 'Denver' and ${custom_insurance_grouping} = '(TC)TRICARE' then  127.44
    when ${markets.name} = 'Denver' then  200.10
    when ${markets.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(CB)CORPORATE BILLING' then 133.10
    when ${markets.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(CM)COMMERCIAL' then 255.83
    when ${markets.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(MA)MEDICARE ADVANTAGE' then 261.99
    when ${markets.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(MAID)MEDICAID' then  99.29
    when ${markets.name}  = 'Las Vegas' and ${custom_insurance_grouping} = '(MCARE)MEDICARE' then 135.00
    when ${markets.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(PSP)PATIENT SELF-PAY' then 241.50
    when ${markets.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(TC)TRICARE' then  87.31
    when ${markets.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(MMCD)MANAGED MEDICAID' then 223.88
    when ${markets.name} = 'Las Vegas' then  220.13
    when  ${custom_insurance_grouping} = '(CB)CORPORATE BILLING' then 133.10
    when  ${custom_insurance_grouping} = '(CM)COMMERCIAL' then 251.08
    when  ${custom_insurance_grouping} = '(MA)MEDICARE ADVANTAGE' then 261.99
    when  ${custom_insurance_grouping} = '(MAID)MEDICAID' then  108.83
    when  ${custom_insurance_grouping} = '(MCARE)MEDICARE' then 135.00
    when  ${custom_insurance_grouping} = '(PSP)PATIENT SELF-PAY' then 274.32
    when  ${custom_insurance_grouping} = '(TC)TRICARE' then  127.44
    when  ${custom_insurance_grouping} = '(MMCD)MANAGED MEDICAID' then 223.88
    else 200.10
    end
              ;;
  }

  measure: avg_expected_allowable_est_hardcoded {
    type: average_distinct
    value_format: "0.00"
    sql_distinct_key: concat(${care_request_flat.care_request_id}, ${insurance_package_id}, ${custom_insurance_grouping});;
    sql: ${expected_allowable_est_hardcoded} ;;
  }

measure: revenue_per_hour {
  type:  number
  value_format: "0.00"
  sql: ${avg_expected_allowable_est_hardcoded}*${care_request_flat.productivity} ;;
}

  dimension: kaiser_colorado {
    type: yesno
    sql: ${insurance_package_id} in('58390', '12225', '23794', '261973') ;;
  }

  dimension: tele_packages {
    type: yesno
    sql: ${insurance_package_id} in('42863', '64369', '2800', '22523', '17272', '70443', '36797', '12379', '1207', '69455', '38381', '476403', '44814', '130563', '15282', '725', '55649', '74324', '564', '22741', '65091', '447247', '128554', '16040', '476401', '31360', '2799', '2232', '12299', '2544', '29776', '79751', '457689', '17271', '476381', '475714', '12380', '484630', '44580', '1625', '113519', '42863', '725', '22523', '42862', '12059', '54360') ;;
  }

}
