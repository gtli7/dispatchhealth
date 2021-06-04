view: summer_camp_teams {
  sql_table_name: looker_scratch.summer_camp_teams ;;

  dimension: team {
    type: string
    sql: ${TABLE}."team" ;;
  }

  dimension: userid {
    type: string
    sql: ${TABLE}."userid" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
