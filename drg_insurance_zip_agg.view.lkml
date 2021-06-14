view: drg_insurance_zip_agg {
    derived_table: {
      explore_source: drg_insurance_data {
        column: zip { field: zipcodes.zip }
        column: population_drg {field:drg_insurance_data.sum_population}
        column: commercial_fi_drg {field:drg_insurance_data.sum_commercial_fi}
        column: medicare_advantage_part_c_drg { field:drg_insurance_data.sum_medicare_advantage_part_c}
        column: complete_count { field: care_request_flat.complete_count }
        column: complete_count_commercial { field: care_request_flat.complete_count_commercial }
        column: complete_count_ma { field: care_request_flat.complete_count_ma }
        column: count { field: sf_accounts.count }
        column: name_adj { field: markets.name_adj }
        column: total_propensity { field: propensity_by_zip.sum_total }
        column: rank_1_10_propensity { field: propensity_by_zip.sum_rank_1_10 }
        column: aland_sqmi  {field: zipcode_squaremiles.aland_sqmi}
        filters: {
          field: zipcodes.zip
          value: "-NULL"
        }
        filters: {
          field: care_request_flat.on_scene_month
          value: "18 months"
        }
        filters: {
          field: markets.name_adj
          value: "Denver"
        }
      }
      sql_trigger_value:  SELECT MAX(care_request_id) FROM ${care_request_flat.SQL_TABLE_NAME} where created_date > current_date - interval '2 days';;

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
  }
