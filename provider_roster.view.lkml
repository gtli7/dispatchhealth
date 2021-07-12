view: provider_roster {
  sql_table_name: looker_scratch.provider_roster ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: address1 {
    type: string
    sql: ${TABLE}."address1" ;;
  }

  dimension: address2 {
    type: string
    sql: ${TABLE}."address2" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."city" ;;
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

  dimension: degree {
    type: string
    sql: ${TABLE}."degree" ;;
  }

  dimension_group: deleted {
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
    sql: ${TABLE}."deleted_at" ;;
  }

  dimension: fax {
    type: string
    sql: ${TABLE}."fax" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension: medical_group {
    type: string
    sql: ${TABLE}."medical_group" ;;
  }

  dimension: middle {
    type: string
    sql: ${TABLE}."middle" ;;
  }

  dimension: npi {
    type: string
    sql: ${TABLE}."npi" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."phone" ;;
  }

  dimension: provider_network_id {
    type: number
    hidden: yes
    sql: ${TABLE}."provider_network_id" ;;
  }

  dimension: specialty {
    type: string
    sql: ${TABLE}."specialty" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
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

  dimension: zipcode {
    type: string
    sql: ${TABLE}."zipcd" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, provider_network.id, provider_network.name]
  }

  dimension: optum_provider_reporting_category {
    description: "UHC partner profile based on provider roster, market, and payor category"
    type: string
    group_label: "Partner Specific Descriptions"
    sql:  CASE
          WHEN ${markets.name_adj} = 'Phoenix'
              AND ${insurance_coalese_crosswalk.insurance_reporting_category} = 'Optum Medical Network'
              then 'Optum Medical Network Phoenix'
          WHEN ${markets.name_adj} in ('Reno', 'Las Vegas')
              AND ${insurance_coalese_crosswalk.insurance_reporting_category} = 'Optum Medical Network'
              then 'Optum Medical Network Nevada'
          WHEN ${provider_network.name} in ('The Everett Clinic', 'The Polyclinic - Seattle')
              then 'Optumcare Washington'
          WHEN ${provider_network.name} = 'Wellmed Florida Employed'
              then 'WellMed Tampa'
          WHEN ${provider_network.name} = 'WellMed - TX'
              AND ${markets.name_adj} in ('Dallas', 'Fort Worth')
               then 'WellMed Dallas'
          WHEN ${provider_network.name} = 'WellMed - TX'
              AND ${markets.name_adj} = 'Houston'
              then 'WellMed Houston'
          WHEN ${provider_network.name} = 'WellMed - TX'
              AND ${markets.name_adj} = 'San Antonio'
              then 'WellMed San Antonio'
          WHEN ${provider_network.name} = 'ProHealth - Connecticut'
              then 'ProHealth'
          WHEN ${provider_network.name} = 'American Health Network - Indianapolis'
              then 'American Health Network'
          END;;
  }


}
