view: shift_planning_shifts {
  label: "APP Shift Planning Shifts"
  sql_table_name: jasperdb.shift_planning_shifts ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: confirmed {
    type: string
    sql: ${TABLE}.confirmed ;;
  }

  dimension: cost_dollars {
    hidden: yes
    type: string
    sql: ${TABLE}.cost_dollars ;;
  }

  dimension: cost_hours {
    hidden: yes
    type: string
    sql: ${TABLE}.cost_hours ;;
  }

  dimension: cost_staff {
    hidden: yes
    type: string
    sql: ${TABLE}.cost_staff ;;
  }

  dimension_group: created {
    hidden: yes
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: employee_name {
    type: string
    sql: ${TABLE}.employee_name ;;
  }

  dimension: employee_rate {
    hidden: yes
    type: string
    sql: ${TABLE}.employee_rate ;;
  }

  dimension: employee_wage {
    hidden: yes
    type: string
    sql: ${TABLE}.employee_wage ;;
  }

  dimension: imported_after_shift {
    type: yesno
    sql: ${TABLE}.imported_after_shift ;;
  }
  dimension: imported_after_shift_or_future {
    type: yesno
    sql: ${local_shift_start_date} >= curdate() or ${imported_after_shift}   ;;
  }

  dimension_group: local_shift_end {
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
    sql: ${TABLE}.local_shift_end_time ;;
  }

  dimension_group: local_shift_start {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,day_of_week_index
    ]
    sql: ${TABLE}.local_shift_start_time ;;
  }
  measure: count_distinct_days{
    type: number
    sql:count(distinct ${local_shift_start_date}) ;;
  }

  dimension: notes {
    type: string
    sql: ${TABLE}.notes ;;
  }

  dimension: schedule_location_id {
    type: string
    sql: ${TABLE}.schedule_location_id ;;
  }

  dimension: schedule_name {
    type: string
    sql: ${TABLE}.schedule_name ;;
  }

  dimension: shift_id {
    type: string
    sql: ${TABLE}.shift_id ;;
  }

  dimension_group: updated {
    hidden: yes
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
    sql: ${TABLE}.updated_at ;;
  }
  dimension:  market_dim_id {
    type: number
    sql: case when ${schedule_name} like '%den%'  then 1
     when ${schedule_name} like "%cos%" then 2
     when ${schedule_name} like "%phx%" then 3
     when ${schedule_name} like "%ric%" then 4
     when ${schedule_name} like "%las%" then 5
    when ${schedule_name} like "%hou%" then 6
    when ${schedule_name} like "%okc%" then 7
     else 0 end ;;
  }

  measure: count {
    type: count
    drill_fields: [id, employee_name, schedule_name]
  }
  measure: shift_hours {
    type: number
    sql:  TIME_TO_SEC(TIMEDIFF(${local_shift_end_time}, ${local_shift_start_time}))/3600 ;;
  }

  measure: total_shift_hours {
    type: number
    sql:  sum(${shift_hours}) ;;
  }
  measure: distinct_cars {
    type:  number
    sql: count(distinct ${shift_id}) ;;
  }
  measure: needed_volume {
    label: "Needed Volume for .7 productivity"
    type:  number
    sql: round(.7*${total_shift_hours},0) ;;
  }
}
