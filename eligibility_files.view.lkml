view: eligibility_files {
  sql_table_name: public.eligibility_files ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: ansi_format {
    type: yesno
    sql: ${TABLE}."ansi_format" ;;
  }

  dimension: aws_subdir {
    type: string
    sql: ${TABLE}."aws_subdir" ;;
  }

  dimension: completed {
    type: yesno
    sql: ${TABLE}."completed" ;;
  }

  dimension_group: completed {
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
    sql: ${TABLE}."completed_at" ;;
  }

  dimension_group: created {
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

  dimension: eligibility_file {
    type: string
    sql: ${TABLE}."eligibility_file" ;;
  }

  dimension: file_template_used_id {
    type: number
    sql: ${TABLE}."file_template_used_id" ;;
  }

  dimension: filename {
    type: string
    sql: ${TABLE}."filename" ;;
  }

  dimension: import_errors {
    type: number
    sql: ${TABLE}."import_errors" ;;
  }

  dimension: needs_attention {
    type: number
    sql: ${TABLE}."needs_attention" ;;
  }

  dimension: num_loaded {
    type: number
    sql: ${TABLE}."num_loaded" ;;
  }

  dimension: population_health_folder_id {
    type: number
    sql: ${TABLE}."population_health_folder_id" ;;
  }

  dimension: replacement {
    type: yesno
    sql: ${TABLE}."replacement" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, filename]
  }
}
