view: eligible_patients {
  # sql_table_name: public.eligible_patients ;;
  derived_table: {
    sql:
select
  ep.id,
  ep.first_name,
  ep.last_name,
  ep.email,
  ep.dob,
  ep.gender,
  ep.city,
  ep.state,
  ep.zipcode,
  ep.pcp,
  ep.channel_item_id,
  p.id AS patient_id
from public.eligible_patients ep
left join public.patients p
  on trim(initcap(ep.first_name)) = trim(initcap(p.first_name))
  and trim(initcap(ep.last_name)) = trim(initcap(p.last_name))
  and ep.dob = p.dob
where (ep.patient_id is not null or COALESCE(ep.patient_id, p.id) is not null)
  AND ep.deleted_at IS NULL AND (ep.first_name is not null or ep.first_name <> '')
  and (ep.last_name is not null or ep.last_name <> '')
  and ep.dob is not null
  AND p.deleted_at IS NULL;;

  sql_trigger_value: SELECT MAX(id) FROM public.eligible_patients ;;
  indexes: ["patient_id", "channel_item_id"]
  }

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: distinct_patient {
    type: string
    sql: UPPER(concat(replace(${last_name}, '''', '')::text, to_char(${dob_date}, 'MM/DD/YYYY'), ${gender})) ;;
  }

  measure: count_distinct_patients {
    type: count_distinct
    sql: ${distinct_patient} ;;
  }

  dimension: channel_item_id {
    type: number
    sql: ${TABLE}.channel_item_id ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      date,
    ]
    convert_tz: no
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: dob {
    type: time
    timeframes: [
      raw,
      date,
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dob ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  measure: count_at_risk_patients {
    label: "Count Distinct At Risk Patients"
    type: count_distinct
    sql: ${patient_id} ;;
  }

  dimension: population_health_patient {
    description: "Identifies 'At Risk' patients"
    type: yesno
    sql: ${patient_id} IS NOT NULL ;;
  }

  dimension: pcp {
    type: string
    sql: ${TABLE}.pcp ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name]
  }
}
