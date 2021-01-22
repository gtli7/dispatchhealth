view: addresses {
  sql_table_name: public.addresses ;;
  label: "Address of Care Request"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: city {
    type: string
    group_label: "Description"
    sql: ${TABLE}.city ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: latitude {
    type: number
    group_label: "Description"
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    group_label: "Description"
    sql: ${TABLE}.longitude ;;
  }

  dimension: care_request_location {
    description: "The Latitude/Longitude combination of the care request (used for maps)"
    type: location
    group_label: "Description"
    sql_latitude:${latitude} ;;
    sql_longitude:${longitude} ;;
  }

  dimension: care_request_location_string {
    type: string
    sql: concat(${latitude}, ${longitude});;
  }

  dimension: state {
    type: string
    group_label: "Description"
    sql: UPPER(TRIM(${TABLE}.state)) ;;
  }

  dimension: street_address_1 {
    type: string
    group_label: "Description"
    sql: ${TABLE}.street_address_1 ;;
  }

  dimension: full_addresss {
    type: string
    description: "Add1, Add2, City, State ZIP"
    group_label: "Description"
    sql: concat(${street_address_1},', ', ${street_address_2},', ', ${city},', ', ${state},' ', ${zipcode_short}) ;;
  }

  dimension: street_address_2 {
    type: string
    group_label: "Description"
    sql: ${TABLE}.street_address_2 ;;
  }

  measure: count_unique_addresses {
    type: count_distinct
    group_label: "Counts"
    sql: ${street_address_1} ;;
  }

  dimension_group: updated {
    type: time
    hidden: no
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ;;
  }

  dimension: zipcode {
    type: zipcode
    group_label: "Description"
    sql: ${TABLE}.zipcode ;;
  }

  dimension: zipcode_short {
    label: "Five Digit Zip Code"
    type: zipcode
    group_label: "Description"
    sql: left(${zipcode}, 5) ;;
  }

  dimension: zip_code_in_dh_market {
    description: "The address of the care rquest zip code is in a DH market assigned zip code and is not a saftey warned zip code"
    type:  yesno
    sql:${zipcodes.zip} IS NOT NULL AND
    ${zipcodes.safety_warning} != 'yes';;
  }

  measure: zipcode_list {
    type: string
    group_label: "Aggregated Lists"
    sql: array_agg(${zipcode_short}) ;;
  }

  dimension: scf_code {
    type: string
    group_label: "Description"
    description: "The sectional center facility code (first 3 digits of the zip)"
    sql: left(${zipcode}, 3) ;;
  }

  measure: count_distinct_states {
    type: count_distinct
    group_label: "Counts"
    sql: ${state} ;;
  }

  measure: visit_state_concat {
    label: "List of Care Request States"
    type: string
    group_label: "Aggregated Lists"
    sql: array_to_string(array_agg(DISTINCT COALESCE(upper(${addresses.state}))), ' | ') ;;
  }

}
