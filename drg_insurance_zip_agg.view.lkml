view: drg_insurance_zip_agg {
    derived_table: {
      explore_source: drg_insurance_data {
        column: zip { field: drg_insurance_data.zipcode }
        column: population_drg {field:drg_insurance_data.sum_population}
        column: commercial_fi_drg {field:drg_insurance_data.sum_commercial_fi}
        column: medicare_advantage_part_c_drg { field:drg_insurance_data.sum_medicare_advantage_part_c}
        column: complete_count { field: care_request_flat.complete_count }
        column: complete_count_commercial { field: care_request_flat.complete_count_commercial }
        column: complete_count_ma { field: care_request_flat.complete_count_ma }
        column: count { field: sf_accounts.count }
        column: name_adj { field: cbsa_dh_markets.name_or_cbsa }
        column: total_propensity { field: propensity_by_zip.sum_total }
        column: rank_1_10_propensity { field: propensity_by_zip.sum_rank_1_10 }
        column: aland_sqmi  {field: zipcode_squaremiles.aland_sqmi}
        column: average_drive_time_minutes  {field: care_request_flat.average_drive_time_minutes_coalesce}
        column: count_sf_community_broad  {field: sf_accounts.count_community_broad}
        column: count_sf_hospitals {field: sf_accounts.count_hospitals}
      }
      sql_trigger_value: select sum(num) from
      (SELECT count(*) as num FROM looker_scratch.sf_accounts
      UNION ALL
      SELECT MAX(care_request_id) as num FROM ${care_request_flat.SQL_TABLE_NAME} where created_date > current_date - interval '2 days')lq

      ;;

    }
    dimension: zip {
      type: zipcode
    }
    dimension: population_drg {
      type: number
    }
    dimension: commercial_fi_drg {
      type: number
    }
    dimension: medicare_advantage_part_c_drg {
      type: number
    }
    dimension: complete_count {
      type: number
    }
    dimension: complete_count_commercial {
      label: "Complete Count (Commercial)"
      type: number
    }
    dimension: complete_count_ma {
      label: "Complete Count (MA)"
      type: number
    }
    dimension: count {
      type: number
    }
    dimension: name_adj {
      description: "Market name where WMFR/SMFR are included as part of Denver"
    }
    dimension: total_propensity {
      type: number
    }
    dimension: rank_1_10_propensity {
      type: number
    }
    dimension: aland_sqmi {
      type: number
    }
  dimension: average_drive_time_minutes {
    value_format: "0.00"
    type: number
  }
  dimension: count_sf_community_broad {
    type: number
  }
  dimension: count_sf_hospitals {
    type: number
  }
  }
