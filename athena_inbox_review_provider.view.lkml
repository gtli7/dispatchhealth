view: athena_inbox_review_provider {
  derived_table: {
    sql:
    SELECT
    da.document_action_id,
    da.document_id,
    da.document_class,
    da.action_group,
    da.system_key,
    da.created_by,
    da.created_datetime,
    da.note,
    prv.provider_first_name,
    prv.provider_last_name,
    prv.provider_npi_number
    FROM (
        SELECT
            document_action_id,
            document_id,
            document_class,
            action_group,
            system_key,
            created_by,
            created_datetime,
            note
        FROM athena.documentaction
        WHERE status = 'REVIEW' AND document_class IN ('LABRESULT','IMAGINGRESULT')
            AND created_by NOT IN ('INTERFACE','ATHENA')) AS da
    INNER JOIN athena.provider prv
        ON (prv."provider_user_name") = (da."created_by") ;;

    sql_trigger_value: SELECT MAX(document_action_id) FROM athena.documentaction ;;
    indexes: ["document_action_id","document_id","provider_npi_number"]

  }

  dimension: document_action_id {
    type: number
    sql: ${TABLE}.document_action_id ;;
  }

  dimension: document_id {
    type: number
    sql: ${TABLE}.document_id ;;
  }

  dimension: npi {
    type: number
    sql: ${TABLE}.provider_npi_number ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}.created_by ;;
  }

  dimension_group: created {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week,
      day_of_month
    ]
    sql: ${TABLE}.created_datetime AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain';;
  }

  measure: count_review_touches {
    description: "Count times lab or imaging result were in REVIEW status"
    type: count_distinct
    sql: ${document_action_id} ;;
    group_label: "Document Review Metrics"

  }

  measure: result_review_users {
    description: "List of users and dates who performed action on results"
    type: string
    sql: array_to_string(array_agg(DISTINCT CONCAT(${created_by},' - ', to_char(${created_date}, 'MM/DD')::varchar)), ', ') ;;
    group_label: "Document Review Metrics"
  }
}
