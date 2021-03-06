view: payer_dimensions {
  sql_table_name: jasperdb.payer_dimensions ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    hidden: yes
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

  dimension: custom_insurance_grouping {
    type: string
    sql: ${TABLE}.custom_insurance_grouping ;;
    drill_fields: [
      insurance_reporting_category,
      market_dimensions.market_name
    ]
  }

  dimension: custom_insurance_label {
    type: string
    sql: CASE ${custom_insurance_grouping}
         WHEN '(CB)CORPORATE BILLING' THEN 'Corporate Billing'
        WHEN '(MA)MEDICARE ADVANTAGE' THEN 'Medicare Advantage'
        WHEN '(MAID)MEDICAID' OR '(MMCD)MANAGED MEDICAID' THEN 'Medicaid'
        WHEN '(PSP)PATIENT SELF-PAY' OR 'PATIENT RESPONSIBILITY' THEN 'Patient Self Pay'
        WHEN '(CM)COMMERCIAL' THEN 'Commercial'
        WHEN '(CB)CORPORATE BILLING' THEN 'Corporate Billing'
        ELSE 'OTHER'
        END;;
  }

  dimension: insurance_package_id {
    label: "Insurance Package ID"
    type: string
    sql: ${TABLE}.insurance_package_id ;;
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
    label: "IRC Group"
    type: string
    sql: ${TABLE}.irc_group ;;
  }

  dimension_group: updated {
    hidden: yes
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
    drill_fields: [id, insurance_package_name, insurance_reporting_category]
  }
}
