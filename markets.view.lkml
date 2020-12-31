view: markets {
  sql_table_name: public.markets ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }


  dimension: id_adj {
    type: string
    description: "Market ID where WMFR or SMFR is included as part of Denver (159)"
    sql: case when ${TABLE}.name = 'West Metro Fire Rescue' OR
        ${TABLE}.name = 'South Metro Fire Rescue' then 159
      else ${id} end;;
  }

  dimension: id_adj_dual {
    type: string
    description: "Market ID where WMFR or SMFR is included as part of Denver (159), and dual markets are combined respectively (TACOLY AND NJRMOR)"
    sql: case when ${TABLE}.name = 'West Metro Fire Rescue' OR ${TABLE}.name = 'South Metro Fire Rescue' then 159
      when ${TABLE}.name = 'Olympia' then 170
      when ${TABLE}.name = 'Morristown' then 171
      else ${id} end;;
  }


  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: contact_phone {
    type: string
    hidden: yes
    sql: ${TABLE}.contact_phone ;;
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

  dimension: breaks_enabled {
    type: yesno
    description: "A flag indicating that provider breaks have been enabled for the market"
    sql: ${TABLE}.enable_breaks IS TRUE ;;
  }

  dimension: enabled {
    type: yesno
    hidden: yes
    sql: ${TABLE}.enabled ;;
  }

  dimension: enroute_audio {
    type: string
    hidden: yes
    sql: ${TABLE}.enroute_audio ;;
  }

  dimension: humanity_id {
    type: number
    hidden: no
    sql: ${TABLE}.humanity_id ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: office_latitude {
    type: number
    sql: CASE
          WHEN ${id} = 162 THEN 36.1577462
          WHEN ${id} = 161 THEN 33.4213962
          WHEN ${id} = 164 THEN 37.606789
          WHEN ${id} = 159 THEN 39.7722937
          WHEN ${id} = 160 THEN 38.8851405
          WHEN ${id} = 166 THEN 35.5256793
          WHEN ${id} = 165 THEN 29.73728509999999
          WHEN ${id} = 167 THEN 39.709569
          WHEN ${id} = 168 THEN 42.105445
          WHEN ${id} = 169 THEN 32.979254
        END;;
  }

  dimension: office_longitude {
    type: number
    sql: CASE
          WHEN ${id} = 162 THEN -115.19155599999999
          WHEN ${id} = 161 THEN -111.96673450000003
          WHEN ${id} = 164 THEN -77.528929
          WHEN ${id} = 159 THEN -104.9835581
          WHEN ${id} = 160 THEN -104.83465469999999
          WHEN ${id} = 166 THEN -97.55798500000003
          WHEN ${id} = 165 THEN -95.59298539999998
          WHEN ${id} = 167 THEN -105.086286
          WHEN ${id} = 168 THEN -72.619331
          WHEN ${id} = 169 THEN -96.714748
        END;;
  }

  dimension: office_location {
    type: location
    sql_latitude:${office_latitude} ;;
    sql_longitude:${office_longitude} ;;
  }

  dimension: distance_home {
    type: distance
    start_location_field: addresses.care_request_location
    end_location_field: office_location
    units: miles
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: market_image {
    type: string
    hidden: yes
    sql: ${TABLE}.market_image ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    drill_fields: [users.full_name]
  }

  dimension: name_adj {
    type: string
    description: "Market name where WMFR is included as part of Denver"
    sql: case when ${TABLE}.name = 'West Metro Fire Rescue'
      OR ${TABLE}.name = 'South Metro Fire Rescue' then 'Denver'
    else ${name} end;;

  }

  dimension: name_adj_dfw {
    type: string
    description: "Market name where WMFR is included as part of Denver and merges Dallas FTW"
    sql: case when ${TABLE}.name = 'West Metro Fire Rescue' then 'Denver'
    when ${TABLE}.name in('Dallas', 'Fort Worth') then 'Dallas/Fort Worth'
      else ${name} end;;

  }

  dimension: name_adj_dual {
    type: string
    description: "Market name where WMFR is included as part of Denver, and merges dual markets Tacoma/Olympia and Ridgewood/Morristown"
    sql: case when ${TABLE}.name = 'West Metro Fire Rescue' then 'Denver'
          when ${TABLE}.name in('Tacoma', 'Olympia') then 'Tacoma/Olympia'
          when ${TABLE}.name in('Ridgewood', 'Morristown') then 'Ridgewood/Morristown'
            else ${name} end;;

    }


  dimension: name_adj_productivity_url {
    type: string
    description: "ONLY USE for Productivty dashboard: Contains URL Link to Market Productivity Detail. Market name where WMFR is included as part of Denver"
    sql: case when ${TABLE}.name = 'West Metro Fire Rescue' or ${TABLE}.name = 'South Metro Fire Rescue' then 'Denver'
      else ${name} end;;
      link: {
        label: "Productivity Details by Market by Day"
        url: "https://dispatchhealth.looker.com/looks/2248?&f[markets.name_adj_productivity_url]={{ value }}"
      }
  }

  dimension: name_smfr {
    type: string
    sql: case when ${cars.name} = 'SMFR_Car' then 'South Metro Fire Rescue'
           when ${cars.name} = 'Denver_Advanced Care ' then 'Denver Advanced Care'
          when trim(${cars.name}) = 'Virtual Visit' then 'Telemedicine'
         else ${name} end ;;
  }

  dimension: old_close_at {
    type: string
    hidden: yes
    sql: ${TABLE}.old_close_at ;;
  }

  dimension: old_open_at {
    type: string
    hidden: yes
    sql: ${TABLE}.old_open_at ;;
  }

  dimension: old_open_duration {
    type: number
    sql: ${TABLE}.old_open_duration ;;
  }

  dimension: primary_insurance_search_enabled {
    type: yesno
    sql: ${TABLE}.primary_insurance_search_enabled ;;
  }

  dimension: provider_group_name {
    type: string
    sql: ${TABLE}.provider_group_name ;;
  }

  dimension: sa_time_zone {
    type: string
    sql: ${TABLE}.sa_time_zone ;;
  }

  dimension: service_area_image {
    type: string
    hidden: yes
    sql: ${TABLE}.service_area_image ;;
  }

  dimension: short_name {
    type: string
    sql: ${TABLE}.short_name ;;
  }

  dimension: short_name_adj {
    type: string
    description: "Market short name where WMFR/SMFR are included in Denver"
    sql: case when ${short_name} in('WMFR', 'SMFR') then 'DEN'
      else ${short_name} end;;
  }

  dimension: short_name_adj_dual {
    type: string
    description: "Market short name where WMFR/SMFR are included in Denver, and dual markets are combined respectively (TACOLY AND NJRMOR) "
    sql: case when ${short_name} in('WMFR', 'SMFR') then 'DEN'
      when ${short_name} in('TAC', 'OLY') then 'TACOLY'
      when ${short_name} in('NJR', 'MOR') then 'NJRMOR'
      else ${short_name} end;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
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
    sql: ${TABLE}.updated_at ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, provider_group_name, short_name, care_requests.count]
  }

  dimension: cpr_market {
    label: "partner_revenue_market"
    description: "Flag to identify CPR markets (hard-coded)"
    type: yesno
    sql: ${id} in(168, 169, 170, 171, 172, 173, 174, 175, 176, 178, 177, 179, 181);;
  }

  dimension: national_market {
    description: "Market has been active for 90 Days or more."
    type: yesno
    sql: ((EXTRACT(EPOCH from now()) - EXTRACT(EPOCH from ${market_start_date.market_start_raw}))::FLOAT / 86400) > 90;;

  }

  dimension: market_active_22_months {
    description: "Market has been active for 699.7 days or more (roughly 23 months considering an average month of 30.42 days)."
    type: yesno
    sql: ((EXTRACT(EPOCH from now()) - EXTRACT(EPOCH from ${market_start_date.market_start_raw}))::FLOAT / 86400) >= 669.24;;
  }

  dimension: finance_market_id {
    type: number
    sql: case when ${short_name} in('DEN', 'SMFR', 'WMFR') then 1
when ${short_name} = 'COS' then 2
when ${short_name} = 'PHX' then 3
when ${short_name} = 'RIC' then 4
when ${short_name} = 'LAS' then 5
when ${short_name} = 'HOU' then 6
when ${short_name} = 'OKC' then 7
when ${short_name} = 'DAL' then 8
when ${short_name} = 'SPR' then 9
when ${short_name} = 'TAC' then 10
when ${short_name} = 'NJR' then 11
when ${short_name} = 'OLY' then 12
when ${short_name} = 'SPO' then 13
when ${short_name} = 'SEA' then 14
when ${short_name} = 'FTW' then 15
when ${short_name} = 'POR' then 16
when ${short_name} = 'BOI' then 17
when ${short_name} = 'ATL' then 18
when ${short_name} = 'RNO' then 19
when ${short_name} = 'TPA' then 20
when ${short_name} = 'MOR' then 21
when ${short_name} = 'HRT' then 22
when ${short_name} = 'IND' then 23
when ${short_name} = 'RDU' then 24
when ${short_name} = 'CLE' then 25
when ${short_name} = 'NSH' then 26
when ${short_name} = 'KNX' then 27
when ${short_name} = 'MIA' then 28
    else null end ;;
  }

  # measure: digital_adjusted {
  #   type: number
  #   sql: ${care_request_complete.count_distinct}+${incontact_spot_check_by_market.spot_check_care_requests} ;;
  # }
  # measure: non_digital_adjusted {
  #   type: number
  #   sql: ${care_request_complete.count_distinct} - ${incontact_spot_check_by_market.spot_check_care_requests} ;;
  # }
}
