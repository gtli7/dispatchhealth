view: callers {
  sql_table_name: public.callers ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: contact_id {
    type: string
    hidden: yes
    sql: ${TABLE}.contact_id ;;
  }

  dimension_group: created {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: dh_phone {
    type: string
    hidden: yes
    sql: ${TABLE}.dh_phone ;;
  }

  dimension: first_name {
    type: string
    sql: trim(initcap(${TABLE}.first_name)) ;;
  }

  dimension: last_name {
    type: string
    sql:trim(initcap(${TABLE}.last_name)) ;;
  }

  dimension: organization_name {
    type: string
    sql: trim(initcap(${TABLE}.organization_name)) ;;
  }

  dimension: origin_phone {
    type: string
    hidden: yes
    sql: ${TABLE}.origin_phone ;;
  }

  dimension: relationship_to_patient {
    type: string
    sql: ${TABLE}.relationship_to_patient ;;
  }

  dimension: relationship_to_patient_family_grouped {
    label: "Relationship to Patient"
    type: string
    sql: CASE WHEN ${TABLE}.relationship_to_patient like '%family%' THEN 'family'
          ELSE ${TABLE}.relationship_to_patient END;;
  }

  dimension: senior_target {
    label: "Community or Home Health Caller"
    type: yesno
    sql: ${relationship_to_patient} in ('facility_staff', 'home_health_team') ;;
  }

  dimension: skill_name {
    type: string
    hidden: yes
    sql: ${TABLE}.skill_name ;;
  }

  dimension: title {
    type: string
    sql: trim(initcap(${TABLE}.title)) ;;
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

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, organization_name, skill_name]
  }
}
