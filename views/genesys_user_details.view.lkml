view: genesys_user_details {
  sql_table_name: looker_scratch.genesys_user_details ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}."id" ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}."department" ;;
  }

  dimension: divisionid {
    type: string
    sql: ${TABLE}."divisionid" ;;
  }

  dimension: divisionname {
    type: string
    sql: ${TABLE}."divisionname" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."email" ;;
  }

  dimension: employeeid {
    type: string
    sql: ${TABLE}."employeeid" ;;
  }

  dimension_group: insert {
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
    sql: ${TABLE}."insert_date" ;;
  }

  dimension: managerid {
    type: string
    sql: ${TABLE}."managerid" ;;
  }

  dimension: managername {
    type: string
    sql: ${TABLE}."managername" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."name" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}."title" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, divisionname, managername, name]
  }
}
