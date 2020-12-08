view: athena_clinicalprovider {
  sql_table_name: athena.clinicalprovider ;;
  view_label: "Athena Clinical Provider"

  dimension: __batch_id {
    type: string
    hidden: yes
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension: __file_date {
    type: string
    hidden: yes
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    hidden: yes
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: address1 {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."address1" ;;
  }

  dimension: address2 {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."address2" ;;
  }

  dimension: city {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."city" ;;
  }

  dimension: clinical_provider_id {
    type: number
    sql: ${TABLE}."clinical_provider_id" ;;
  }

  dimension: country {
    type: string
    hidden: yes
    group_label: "Contact Information"
    map_layer_name: countries
    sql: ${TABLE}."country" ;;
  }

  dimension_group: created_at {
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
    sql: ${TABLE}."created_datetime" ;;
  }

  dimension_group: deleted {
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
    sql: ${TABLE}."deleted_datetime" ;;
  }

  dimension: fax {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."fax" ;;
  }

  dimension: first_name {
    type: string
    group_label: "Personal/Practice Information"
    sql: ${TABLE}."first_name" ;;
  }

  dimension: gender {
    type: string
    group_label: "Personal/Practice Information"
    sql: ${TABLE}."gender" ;;
  }

  dimension: last_name {
    type: string
    description: "Provider last name. In the case of a practice or entity, use 'name' instead"
    group_label: "Personal/Practice Information"
    sql: ${TABLE}."last_name" ;;
  }

  dimension: middle_name {
    type: string
    group_label: "Personal/Practice Information"
    sql: ${TABLE}."middle_name" ;;
  }

  dimension: name {
    type: string
    group_label: "Personal/Practice Information"
    sql: ${TABLE}."name" ;;
  }

  dimension: npi {
    type: string
    group_label: "Personal/Practice Information"
    sql: ${TABLE}."npi" ;;
  }

  dimension: phone {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."phone" ;;
  }

  dimension: state {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."state" ;;
  }

  dimension: title {
    type: string
    group_label: "Personal/Practice Information"
    sql: ${TABLE}."title" ;;
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

  dimension: zip {
    type: zipcode
    group_label: "Contact Information"
    sql: ${TABLE}."zip" ;;
  }

  dimension: provider_category {
    description: "A flag indicating that the provider is DispatchHealth"
    type: string
    sql:
      CASE
        WHEN CONCAT(${markets.short_name}, ' -') = SUBSTRING(${name}, 1, 5)
             OR ${name} LIKE '%DISPATCHHEALTH%' THEN 'Performed On-Scene'
        WHEN ${name} IS NULL THEN 'No Provider Name Given'
        ELSE 'Performed by Third Party'
    END;;
  }

  dimension: provider_role {
    type: string
    sql: ${athena_clinicalletter.role} ;;
  }

  measure: first_names_aggregated {
    type: string
    sql: array_to_string(array_agg(DISTINCT ${first_name}), ' | ') ;;
  }

  measure: last_names_aggregated {
    type: string
    sql: array_to_string(array_agg(DISTINCT ${last_name}), ' | ') ;;
  }

  measure: pcp_names_aggregated {
    type: string
    sql: array_to_string(array_agg(DISTINCT
    CASE WHEN ${provider_role} = 'Primary Care Provider' THEN ${name} ELSE NULL END), ' | ') ;;
  }

  measure: names_aggregated {
    type: string
    sql: array_to_string(array_agg(DISTINCT ${name}), ' | ') ;;
  }

  measure: count {
    type: count
    drill_fields: [name, first_name, middle_name, last_name]
  }
}
