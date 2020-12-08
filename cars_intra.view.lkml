view: cars_intra {
  sql_table_name: public.cars_intra ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: now_mountain{
    type: time
    convert_tz: no
    timeframes: [day_of_week_index, week, month, day_of_month, time, raw]
    sql: now() AT TIME ZONE 'US/Mountain' ;;
  }


  dimension: market_id {
    type: number
    sql: case when ${name} = 'COS02' and ${now_mountain_day_of_week_index} in(999)  then 159
           else ${TABLE}.market_id end ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
