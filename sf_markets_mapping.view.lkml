view: sf_markets_mapping {
  derived_table: {
    sql:
    select sf.market, m.id as market_id
from
(select market
from looker_scratch.sf_accounts
group by 1) sf
left join public.markets m
on  lower(case when sf.market='Raleigh/Durham (RDU), NC' then 'Raleigh Durham' else sf.market end) like  concat('%', lower(m.name),'%')

;;
    sql_trigger_value: SELECT count(*)+ to_char(CURRENT_DATE, 'YYYYMMDD')::integer FROM looker_scratch.sf_accounts ;;
    indexes: ["market_id", "market"]
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
  }


  }
