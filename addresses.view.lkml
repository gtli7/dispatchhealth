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

  dimension: state_abbreviation_standardized {
    type: string
    group_label: "Description"
    sql: CASE
      WHEN UPPER(${state}) = 'ALABAMA' THEN 'AL'
      WHEN UPPER(${state}) = 'ALASKA' THEN 'AK'
      WHEN UPPER(${state}) = 'ARIZONA' THEN 'AZ'
      WHEN UPPER(${state}) = 'ARKANSAS' THEN 'AR'
      WHEN UPPER(${state}) = 'CALIFORNIA' THEN 'CA'
      WHEN UPPER(${state}) = 'COLORADO' THEN 'CO'
      WHEN UPPER(${state}) = 'CONNECTICUT' THEN 'CT'
      WHEN UPPER(${state}) = 'DELAWARE' THEN 'DE'
      WHEN UPPER(${state}) = 'FLORIDA' THEN 'FL'
      WHEN UPPER(${state}) = 'GEORGIA' THEN 'GA'
      WHEN UPPER(${state}) = 'HAWAII' THEN 'HI'
      WHEN UPPER(${state}) = 'IDAHO' THEN 'ID'
      WHEN UPPER(${state}) = 'ILLINOIS' THEN 'IL'
      WHEN UPPER(${state}) = 'INDIANA' THEN 'IN'
      WHEN UPPER(${state}) = 'IOWA' THEN 'IA'
      WHEN UPPER(${state}) = 'KANSAS' THEN 'KS'
      WHEN UPPER(${state}) = 'KENTUCKY' THEN 'KY'
      WHEN UPPER(${state}) = 'LOUISIANA' THEN 'LA'
      WHEN UPPER(${state}) = 'MAINE' THEN 'ME'
      WHEN UPPER(${state}) = 'MARYLAND' THEN 'MD'
      WHEN UPPER(${state}) = 'MASSACHUSETTS' THEN 'MA'
      WHEN UPPER(${state}) = 'MICHIGAN' THEN 'MI'
      WHEN UPPER(${state}) = 'MINNESOTA' THEN 'MN'
      WHEN UPPER(${state}) = 'MISSISSIPPI' THEN 'MS'
      WHEN UPPER(${state}) = 'MISSOURI' THEN 'MO'
      WHEN UPPER(${state}) = 'MONTANA' THEN 'MT'
      WHEN UPPER(${state}) = 'NEBRASKA' THEN 'NE'
      WHEN UPPER(${state}) = 'NEVADA' THEN 'NV'
      WHEN UPPER(${state}) = 'NEW HAMPSHIRE' THEN 'NH'
      WHEN UPPER(${state}) = 'NEW JERSEY' THEN 'NJ'
      WHEN UPPER(${state}) = 'NEW MEXICO' THEN 'NM'
      WHEN UPPER(${state}) = 'NEW YORK' THEN 'NY'
      WHEN UPPER(${state}) = 'NORTH CAROLINA' THEN 'NC'
      WHEN UPPER(${state}) = 'NORTH DAKOTA' THEN 'ND'
      WHEN UPPER(${state}) = 'OHIO' THEN 'OH'
      WHEN UPPER(${state}) = 'OKLAHOMA' THEN 'OK'
      WHEN UPPER(${state}) = 'OREGON' THEN 'OR'
      WHEN UPPER(${state}) = 'PENNSYLVANIA' THEN 'PA'
      WHEN UPPER(${state}) = 'RHODE ISLAND' THEN 'RI'
      WHEN UPPER(${state}) = 'SOUTH CAROLINA' THEN 'SC'
      WHEN UPPER(${state}) = 'SOUTH DAKOTA' THEN 'SD'
      WHEN UPPER(${state}) = 'TENNESSEE' THEN 'TN'
      WHEN UPPER(${state}) = 'TEXAS' THEN 'TX'
      WHEN UPPER(${state}) = 'UTAH' THEN 'UT'
      WHEN UPPER(${state}) = 'VERMONT' THEN 'VT'
      WHEN UPPER(${state}) = 'VIRGINIA' THEN 'VA'
      WHEN UPPER(${state}) = 'WASHINGTON' THEN 'WA'
      WHEN UPPER(${state}) = 'WEST VIRGINIA' THEN 'WV'
      WHEN UPPER(${state}) = 'WISCONSIN' THEN 'WI'
      WHEN UPPER(${state}) = 'WYOMING' THEN 'WY'
      WHEN UPPER(${state}) = 'AMERICAN SAMOA' THEN 'AS'
      WHEN UPPER(${state}) = 'DISTRICT OF COLUMBIA' THEN 'DC'
      WHEN UPPER(${state}) = 'GUAM' THEN 'GU'
      WHEN UPPER(${state}) = 'MARSHALL ISLANDS' THEN 'MH'
      WHEN UPPER(${state}) = 'NORTHERN MARIANA ISLAND' THEN 'MP'
      WHEN UPPER(${state}) = 'PUERTO RICO' THEN 'PR'
      WHEN UPPER(${state}) = 'VIRGIN ISLANDS' THEN 'VI'
      WHEN UPPER(${state}) = 'ARMED FORCES AFRICA' THEN 'AE'
      WHEN UPPER(${state}) = 'ARMED FORCES AMERICAS' THEN 'AA'
      WHEN UPPER(${state}) = 'ARMED FORCES CANADA' THEN 'AE'
      WHEN UPPER(${state}) = 'ARMED FORCES EUROPE' THEN 'AE'
      WHEN UPPER(${state}) = 'ARMED FORCES MIDDLE EAST' THEN 'AE'
      WHEN UPPER(${state}) = 'ARMED FORCES PACIFIC' THEN 'AP'
      ELSE ${state}
      END;;
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
