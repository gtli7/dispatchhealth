view: markets_intra {
  sql_table_name: public.markets_intra ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
#         when trim(${cars_intra.name}) = 'Virtual Visit' then 'Telemedicine'

  dimension: name {
    type: string
    sql: case when ${cars_intra.name} = 'SMFR_Car' then 'South Metro Fire Rescue'
             when ${cars_intra.name} = 'Denver_Advanced Care ' then 'Denver Advanced Care'

         else ${TABLE}.name end ;;
  }
  dimension: fee_for_service {
    type: yesno
    sql: ${name} in('Denver', 'Colorado Springs', 'Las Vegas', 'Phoenix', 'Richmond', 'Houston', 'Oklahoma City') ;;
  }

  dimension: sa_time_zone {
    type: string
    sql: ${TABLE}.sa_time_zone ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
