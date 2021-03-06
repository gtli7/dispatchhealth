view: visit_dimensions {
  sql_table_name: jasperdb.visit_dimensions ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: dashboard_patient_id {
    hidden: yes
    type: number
    sql: ${TABLE}.dashboard_patient_id ;;
  }

  dimension: ehr_name {
    label: "EHR Name"
    type: string
    sql: ${TABLE}.ehr_name ;;
  }

  dimension_group: local_visit {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      hour_of_day,
      date,
      day_of_month,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.local_visit_date ;;
  }

  dimension: pre_post {
    type: yesno
    sql: (DATE(${local_visit_raw}) BETWEEN '2018-04-02' AND '2018-04-13') ;;
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

  dimension_group: visit {
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
    sql: ${TABLE}.visit_date ;;
  }

  dimension: visit_number {
    label: "EHR Appointment ID"
    type: string
    sql: ${TABLE}.visit_number ;;
  }

  measure: month_percent {
    type: number
    sql:day(${visit_dimensions.max_billable_visit_date})/DAY(LAST_DAY(curdate())) ;;
  }

  measure: count {
    type: count
    drill_fields: [id, ehr_name]
  }
  measure: max_billable_visit_date {
    convert_tz: no
    type:  date
    sql: max(${local_visit_date}) ;;
  }


}
