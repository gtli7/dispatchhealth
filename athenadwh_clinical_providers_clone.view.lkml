view: athenadwh_clinical_providers_clone {
  sql_table_name: looker_scratch.athenadwh_clinical_providers_clone ;;
  view_label: "ZZZZ - Athenadwh Clinical Providers Clone"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: address1 {
    type: string
    sql: ${TABLE}.address1 ;;
  }

  dimension: address2 {
    type: string
    sql: ${TABLE}.address2 ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: clinical_provider_id {
    type: number
    sql: ${TABLE}.clinical_provider_id ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: thr_access_center_provider {
    type: yesno
    sql: ${name} = 'THR ACCESS CENTER' ;;
  }

  dimension: provider_category {
    description: "A flag indicating that the provider is DispatchHealth"
    type: string
    sql:
      CASE
        WHEN ${name} IS NULL THEN 'Provider Unknown'
        WHEN ${name} LIKE '%'|| TRIM(${markets.short_name}) ||'%'
          OR ${name}  = 'SOUTH METRO FIRE AND RESCUE'
          OR ${name} LIKE 'DISPATCHHEALTH' THEN 'Performed On-Scene'
        ELSE 'Performed by Third Party'
    END;;
    drill_fields: [
      athenadwh_lab_imaging_providers.name,
      athenadwh_lab_imaging_results.clinical_order_type
    ]
  }

  dimension: labcorp_provider {
    type: yesno
    description: "A flag indicating the provider is Labcorp"
    sql: ${name} LIKE '%LABCORP%' ;;
  }

  dimension: touchworks_flag {
    type: yesno
    sql: ${name} = 'SOUTHWEST MEDICAL TOUCHWORKS' ;;
  }

  dimension: touchworks_name {
    type: string
    sql: ${name} ;;
    html:{% if value == 'SOUTHWEST MEDICAL TOUCHWORKS' %}<b><span style="color: black;">SOUTHWEST MEDICAL TOUCHWORKS</span></b>{% else %} {{ linked_value }}{% endif %};;
  }

  dimension: npi {
    type: string
    sql: CASE WHEN ${TABLE}.npi LIKE '%/%' THEN NULL
          ELSE ${TABLE}.npi END;;
  }

  dimension: npi_set {
    type: yesno
    sql: ${npi} is not null ;;
  }


  dimension: multicare_provider_flag {
    description: "A flag indicating the provider is Multicare - Use only with the Athena letter recipient provider view"
    type: yesno
    sql: COALESCE(${multicare_providers.last_name}, NULL) IS NOT NULL ;;
  }

  dimension: thpg_provider_flag {
    description: "A flag indicating the provider is THPG - Use only with the Athena letter recipient provider view"
    type: yesno
    sql: COALESCE(${thpg_providers.last_name}, NULL) IS NOT NULL ;;
    #sql: ${thpg_providers.last_name} IS NOT NULL ;;
  }

  measure: thpg_provider_count {
    description: "A flag indicating the provider is THPG - Use only with the Athena letter recipient provider view"
    type: count_distinct
    sql: ${thpg_providers.npi} ;;
  }

  measure: thpg_provider_boolean {
    description: "A flag indicating the provider is THPG - Use only with the Athena letter recipient provider view"
    type: yesno
    sql: ${thpg_provider_count} > 0 ;;
  }

  dimension: network_provider_flag
  { hidden: no
    type: yesno
    sql: {% condition provider_network.provider_network_select %}
      ${provider_network.name} {% endcondition %} ;;
  }

  measure: count_provider {
    type: count_distinct
    sql: ${provider_roster.npi} ;;
    filters:

    { field: network_provider_flag value: "yes" }
  }

  measure: network_provider_boolean {
    description: "A flag indicating the provider is in the network roster - Use only with the Athena letter recipient provider view"
    type: yesno
    sql: ${count_provider} > 0 ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension_group: updated {
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

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: first_name_aggregated {
    type: string
    sql: array_to_string(array_agg(DISTINCT ${first_name}), ' | ') ;;
  }

  measure: last_name_aggregated {
    type: string
    sql: array_to_string(array_agg(DISTINCT ${last_name}), ' | ') ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, name, last_name]
  }

  measure: names_aggregated {
    type: string
    sql: array_to_string(array_agg(DISTINCT ${name}), ' | ') ;;
  }

  measure: npi_aggregated {
    type: string
    sql: array_to_string(array_agg(DISTINCT ${npi}), ' | ') ;;
  }

  measure: address_aggregated {
    type: string
    sql: array_agg(distinct ${address_full}) ;;
  }
  dimension: address_full {
    type: string
    sql: concat(${address1},': ',coalesce(${address2}, ''),': ', ${city}, ': ', left(${zip},5)) ;;
  }

  measure: ids_aggregated {
    type: string
    sql: array_agg(distinct ${id}) ;;
  }

}
