view: primary_payer_dimensions_intra {
  sql_table_name: public.primary_payer_dimensions_intra ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: custom_insurance_grouping {
    type: string
    sql: case when ${insurance_package_id} in(22741, 47756, 54360, 75708) then '(MMCD)MANAGED MEDICAID'
              else ${TABLE}.custom_insurance_grouping end;;
  }
  dimension: medicaid_tricare {
    type: string
    sql: case when ${custom_insurance_grouping} in('(MAID)MEDICAID', '(TC)TRICARE') then 'Medicaid/Tricare'
        else 'Preferred Payer' end;;
  }

  dimension: insurance_package_id {
    type: string
    sql: (${TABLE}.insurance_package_id)::int ;;
  }

  dimension: insurance_package_name {
    type: string
    sql: ${TABLE}.insurance_package_name ;;
  }

  dimension: insurance_package_type {
    type: string
    sql: ${TABLE}.insurance_package_type ;;
  }

  dimension: insurance_reporting_category {
    type: string
    sql: ${TABLE}.insurance_reporting_category ;;
  }

  dimension: irc_group {
    type: string
    sql: ${TABLE}.irc_group ;;
  }

  dimension: kaiser_colorado {
    type: yesno
    sql: ${insurance_package_id} in('58390', '12225', '23794') ;;
  }

  dimension: expected_allowable {
    type: number
    sql: case when ${markets_intra.name} = 'Colorado Springs' and ${custom_insurance_grouping} = '(CM)COMMERCIAL' then 252.63
              when ${markets_intra.name} = 'Colorado Springs' and ${custom_insurance_grouping} = '(MA)MEDICARE ADVANTAGE' then 251.37
              when ${markets_intra.name} = 'Colorado Springs' and ${custom_insurance_grouping} = '(MAID)MEDICAID' then 102.25
              when ${markets_intra.name} = 'Colorado Springs' and ${custom_insurance_grouping} = '(MCARE)MEDICARE' then 135.00
              when ${markets_intra.name} = 'Colorado Springs' and ${custom_insurance_grouping} = '(PSP)PATIENT SELF-PAY' then 273.04
              when ${markets_intra.name} = 'Colorado Springs' and ${custom_insurance_grouping} = '(TC)TRICARE' then  118.12
              when ${markets_intra.name} = 'Colorado Springs' then 162.46
              when ${markets_intra.name} = 'Denver' and ${custom_insurance_grouping} = '(CB)CORPORATE BILLING' then 133.10
              when ${markets_intra.name} = 'Denver' and ${custom_insurance_grouping} = '(CM)COMMERCIAL' then 251.08
              when ${markets_intra.name} = 'Denver' and ${custom_insurance_grouping} = '(MA)MEDICARE ADVANTAGE' then 261.99
              when ${markets_intra.name} = 'Denver' and ${custom_insurance_grouping} = '(MAID)MEDICAID' then  108.83
              when ${markets_intra.name} = 'Denver' and ${custom_insurance_grouping} = '(MCARE)MEDICARE' then 135.00
              when ${markets_intra.name} = 'Denver' and ${custom_insurance_grouping} = '(PSP)PATIENT SELF-PAY' then 274.32
              when ${markets_intra.name} = 'Denver' and ${custom_insurance_grouping} = '(TC)TRICARE' then  127.44
              when ${markets_intra.name} = 'Denver' then  200.10
              when ${markets_intra.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(CB)CORPORATE BILLING' then 133.10
              when ${markets_intra.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(CM)COMMERCIAL' then 255.83
              when ${markets_intra.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(MA)MEDICARE ADVANTAGE' then 261.99
              when ${markets_intra.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(MAID)MEDICAID' then  99.29
              when ${markets_intra.name}  = 'Las Vegas' and ${custom_insurance_grouping} = '(MCARE)MEDICARE' then 135.00
              when ${markets_intra.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(PSP)PATIENT SELF-PAY' then 241.50
              when ${markets_intra.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(TC)TRICARE' then  87.31
              when ${markets_intra.name} = 'Las Vegas' and ${custom_insurance_grouping} = '(MMCD)MANAGED MEDICAID' then 223.88
              when ${markets_intra.name} = 'Las Vegas' then  220.13
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

  measure: avg_expected_allowable {
    type: average_distinct
    value_format: "0.00"
    sql_distinct_key:  concat(intraday_care_requests.care_request_id, ${insurance_package_id});;
    sql: ${expected_allowable} ;;
    }

  measure: count {
    type: count
    drill_fields: [id, insurance_package_name]
  }
}
