view: provider_network {
  sql_table_name: looker_scratch.provider_network ;;

  dimension: id {
    primary_key: yes
    hidden: no
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension_group: deleted {
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
    sql: ${TABLE}."deleted_at" ;;
  }

  dimension: name {
    type: string
    description: "The name of the provider network"
    sql: ${TABLE}."name" ;;
  }

  filter: provider_network_select
  { type: string
    suggest_dimension: provider_network.name
    sql: EXISTS (SELECT name FROM provider_network WHERE {% condition %}
      provider_network.name {% endcondition %}) ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, provider_roster.count]
  }
}
