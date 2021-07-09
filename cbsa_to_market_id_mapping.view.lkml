view: cbsa_to_market_id_mapping {
  derived_table: {
    sql:
           select markets.id as market_id, cbsa_zipcode_mapping.cbsa, cbsa_id
from public.zipcodes
LEFT JOIN public.billing_cities  AS billing_cities ON zipcodes.billing_city_id = (billing_cities."id")
LEFT JOIN public.markets  AS markets ON (billing_cities."market_id") = markets.id
LEFT JOIN looker_scratch.cbsa_zipcode_mapping  AS cbsa_zipcode_mapping ON (cbsa_zipcode_mapping."zipcode") = (zipcodes."zip")
where cbsa is not null and cbsa_zipcode_mapping.cbsa_id not in('37980')
group by 1,2,3;;
  }


  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: cbsa_id {
    type: number
    sql: ${TABLE}."cbsa_id" ;;
  }



  dimension: cbsa {
    type: string
    sql: ${TABLE}."cbsa" ;;
  }


}
