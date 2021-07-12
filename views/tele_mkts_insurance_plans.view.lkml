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
          or (s.name = 'Nevada' and i.package_id in ('69455', '70443')) -- medicaid/medicare
          or (s.name = 'Nevada' and i.package_id in ('447247', '75708', '136902', '81629')) -- capped plans
          or (s.name = 'Colorado' and i.package_id in ('54360', '81644', '58389', '164536', '58390', '38982', '264985', '56872', '59255', '59346')) -- capped plans
          or (s.name = 'Oklahoma' and i.package_id in ('406800', '58124', '60678', '47006', '98660', '20995', '133950', '289218')) -- capped plans
          or (s.name = 'Texas' and i.package_id in ('57267', '70603', '397211', '482913', '112439', '2768', '82079', '555051', '38982', '476476', '18782', '205249', '83355', '70075')) -- capped plans
          or (s.name = 'Virginia' and i.package_id in ('73620', '60678', '47006', '98660', '20995', '133950', '448219', '478635', '74229')) -- capped plans
          or (s.name = 'Massachusetts' and i.package_id in ('564', '1207')) -- medicaid/medicare
          or (s.name = 'Massachusetts' and i.package_id in ('104428', '122548', '81233', '289647')) -- capped plans
          or (s.name = 'Washington' and i.package_id in ('65091', '64369')) -- medicaid/medicare
          or (s.name = 'Washington' and i.package_id in ('273667', '173728', '173741')) -- capped plans
          )
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
    sql:(
    (${state_name} = 'Nevada' and ${insurance_package_id} in ('447247', '75708', '136902', '81629'))
    or (${state_name} = 'Colorado' and ${insurance_package_id} in ('54360', '81644', '58389', '164536', '58390', '38982', '264985', '56872', '59255', '59346'))
    or (${state_name} = 'Oklahoma' and ${insurance_package_id} in ('406800', '58124', '60678', '47006', '98660', '20995', '133950', '289218'))
    or (${state_name} = 'Texas' and ${insurance_package_id} in ('57267', '70603', '397211', '482913', '112439', '2768', '82079', '555051', '38982', '476476', '18782', '205249', '83355', '70075'))
    or (${state_name} = 'Massachusetts' and ${insurance_package_id} in ('104428', '122548', '81233', '289647'))
    or (${state_name} = 'Virginia' and ${insurance_package_id} in ('73620', '60678', '47006', '98660', '20995', '133950', '448219', '478635', '74229'))
    or (${state_name} = 'Washington' and ${insurance_package_id} in ('273667', '173728', '173741'))
    ) and ${enabled} = 'false' ;;
  }

  measure: count {
    type: count
    drill_fields: [state_name, insurance_name]
  }
}
