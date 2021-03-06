view: bill_processors {
  sql_table_name: public.bill_processors ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: billing_option {
    type: string
    hidden: yes
    sql: ${TABLE}.billing_option ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: checked_billing_fields {
    type: string
    hidden: yes
    sql: ${TABLE}.checked_billing_fields ;;
  }

  dimension: checked_billing_fields_counts {
    type: string
    hidden: yes
    sql: ${TABLE}.checked_billing_fields_counts ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: sent {
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
    sql: ${TABLE}.sent_at ;;
  }

  dimension_group: sent_mountain {
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
    sql: ${TABLE}.sent_at - interval '7 hour' ;;
  }

  dimension: scrubbed_flag {
    type: yesno
    hidden: yes
    sql: ${sent_raw} IS NOT NULL ;;
  }

  measure: scrubbed_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: scrubbed_flag
      value: "yes"
    }
  }

  measure: auto_scrubbed_count {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: scrubbed_flag
      value: "yes"
    }
    filters: {
      field: csc_names.chart_scrubbing_name
      value: "Dashboard"
    }
  }


  dimension: settle_case {
    type: yesno
    hidden: yes
    sql: ${TABLE}.settle_case ;;
  }

  dimension_group: settle {
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
    sql: ${TABLE}.settle_date ;;
  }

  dimension: settle_notes {
    type: string
    hidden: yes
    sql: ${TABLE}.settle_notes ;;
  }

  dimension: settled_by {
    type: string
    hidden: yes
    sql: ${TABLE}.settled_by ;;
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

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: [id]
  }
}
