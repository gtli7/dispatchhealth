view: tele_risk_strat_new {
  sql_table_name: looker_scratch.tele_risk_strat_new ;;

  dimension: primary_key {
    type: string
    primary_key: yes
    sql: concat(${protocol_number}, ${age_band}) ;;
  }

  dimension: age_band {
    type: string
    sql: ${TABLE}."age_band" ;;
  }

  dimension: age_lower_bound {
    type: number
    sql: ${TABLE}."age_lower_bound" ;;
  }

  dimension: age_upper_bound {
    type: number
    sql: ${TABLE}."age_upper_bound" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: protocol_name {
    type: string
    sql: ${TABLE}."protocol_name" ;;
  }

  dimension: protocol_number {
    type: number
    sql: ${TABLE}."protocol_number" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
  }

  dimension: eligible_age_and_protocol {
    type: yesno
    sql: ${protocol_name} is not null
         and ${status} ilike '%yes%'
         and (
          (${protocol_name} ilike '%extremity injury%' and ${age_band} = 'Age> 60' and ${care_requests.chief_complaint} not ilike '%hip%')
          or ${protocol_name} not ilike '%extremity injury%'
          or ${age_band} != 'Age> 60'
          ) ;;
  }

  measure: count {
    type: count
    drill_fields: [protocol_name]
  }
}
