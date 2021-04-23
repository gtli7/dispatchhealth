view: shifts_by_cars {

  derived_table: {

    sql: select
    car_id,
    concat(car_id,date(start_time at time zone 'utc' at time zone 'US/Mountain')) as car_id_start_date_id,
    sum(EXTRACT(EPOCH FROM end_time at time zone 'utc' at time zone 'US/Mountain') - EXTRACT(EPOCH FROM start_time at time zone 'utc' at time zone 'US/Mountain')) as sum_shift_time_by_car,
    count(id) as count_shifts
    from public.shift_teams
    group by car_id, car_id_start_date_id order by count_shifts desc
    ;;

#     sql_trigger_value: SELECT MAX(start) FROM shift_teams ;;
    # sql_trigger_value: SELECT FLOOR(EXTRACT(epoch from NOW()) / (2*60*60));;
    indexes: ["car_id"]




  }

  dimension: car_id {
    hidden: yes
    type: number
    sql: ${TABLE}.car_id ;;
  }

  dimension: car_id_start_date_id {
    description: "Concatenation of shift_teams.car_id and shift_teams.start_date (converted to MST)"
        type: string
    sql: ${TABLE}.car_id_start_date_id;;
  }

  dimension: daily_shift_time_by_car {
    description: "Sum of total shift seconds assigned to a car_id on a given date"
    type: number
    sql: ${TABLE}.sum_shift_time_by_car ;;
  }

  dimension: count_shifts {
    description: "Count of shifts assigned assigned to a car_id on a given date"
    type: number
    sql: ${TABLE}.count_shifts ;;
  }

  dimension: daily_shift_hours_by_car {
    type: number
    sql: ${daily_shift_time_by_car} / 3600 ;;
    value_format: "0.0"
  }

}
