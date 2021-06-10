view: novel_lift_projects {
  sql_table_name: looker_scratch.novel_lift_projects ;;

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: market_short {
    type: string
    sql: ${TABLE}."market_short" ;;
  }

  dimension_group: month {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."month" ;;
  }

  dimension_group: month_insert {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."month_insert" ;;
  }

  dimension: owner_name {
    type: string
    sql: ${TABLE}."owner_name" ;;
  }

  dimension: partner {
    type: string
    sql: ${TABLE}."partner" ;;
  }

  dimension: partner_type {
    type: string
    sql: ${TABLE}."partner_type" ;;
  }

  dimension: visits {
    type: number
    sql: ${TABLE}."visits" ;;
  }
  dimension: primary_key {
    type: string
    sql: concat(${partner}, ${market_short}, ${month_raw}) ;;
  }

  dimension: market_short_adj_dual {
    type: string
    description: "Market short name where WMFR/SMFR are included in Denver, and dual markets are combined (TACOLY) "
    sql: case when ${market_short} in('WMFR', 'SMFR') then 'DEN'
      when ${market_short} in('TAC', 'OLY') then 'TACOLY'
      else ${market_short} end;;
  }

  measure: sum_visits {
    type: sum_distinct
    sql: ${visits} ;;
    sql_distinct_key: ${primary_key} ;;
  }

  measure: count {
    type: count
    drill_fields: [owner_name]
  }
}
