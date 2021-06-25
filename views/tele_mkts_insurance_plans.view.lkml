view: tele_mkts_insurance_plans {
  derived_table: {
    sql: select
          s.id as state_id,
          s.name as state_name,
          ips.insurance_plan_id,
          i.name as insurance_name,
          i.package_id::int as insurance_package_id,
          ips.id as insurance_plan_service_line_id,
          ips.service_line_id,
          ips.enabled,
          i.active,
          left(i.note, 255) as note
        from insurance_plan_service_lines ips
        left join insurance_plans i on ips.insurance_plan_id = i.id
        join states s on i.state_id = s.id
        where ips.service_line_id = 17 -- Telepres
        and ((s.name in ('Colorado', 'Oklahoma', 'Texas', 'Virginia') and ips.enabled = 'true')
          or (s.name = 'Nevada' and i.package_id in ('69455', '70443', '447247', '75708', '136902', '81629')))
        order by s.name, i.name ;;
    indexes: ["state_id", "insurance_plan_id", "insurance_package_id", "insurance_plan_service_line_id", "service_line_id"]
  }

  dimension: active {
    type: string
    sql: ${TABLE}."active" ;;
  }

  dimension: enabled {
    type: string
    sql: ${TABLE}."enabled" ;;
  }

  dimension: insurance_name {
    type: string
    sql: ${TABLE}."insurance_name" ;;
  }

  dimension: insurance_package_id {
    type: number
    sql: ${TABLE}."insurance_package_id" ;;
  }

  dimension: insurance_plan_id {
    type: number
    sql: ${TABLE}."insurance_plan_id" ;;
  }

  dimension: insurance_plan_service_line_id {
    type: number
    sql: ${TABLE}."insurance_plan_service_line_id" ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}."note" ;;
  }

  dimension: service_line_id {
    type: number
    sql: ${TABLE}."service_line_id" ;;
  }

  dimension: state_id {
    type: number
    sql: ${TABLE}."state_id" ;;
  }

  dimension: state_name {
    type: string
    sql: ${TABLE}."state_name" ;;
  }

  dimension: tele_eligible_plan {
    type: yesno
    sql: ${insurance_plan_id} is not null ;;
  }

  dimension: cap_payer_tele_10pct {
    type: yesno
    sql: ${insurance_package_id} in ('447247', '75708', '136902', '81629') ;;
  }

  measure: count {
    type: count
    drill_fields: [state_name, insurance_name]
  }
}
