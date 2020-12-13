view: athena_inbox_turnaround {
    derived_table: {
      sql:
      WITH prv AS (
    SELECT
        document_id,
        MIN(created_datetime) AS received_provider
        FROM athena.documentaction
        WHERE LOWER(assigned_to) LIKE '%provider%'
            AND document_class IN ('LABRESULT','IMAGINGRESULT')
            AND status = 'REVIEW'
        GROUP BY 1),
ma AS (
    SELECT
        document_id,
        MIN(created_datetime) AS received_ma,
        COUNT(*) AS num_ma_touches
        FROM athena.documentaction
        WHERE LOWER(assigned_to) LIKE '%maonshift%'
            AND document_class IN ('LABRESULT','IMAGINGRESULT')
            AND status = 'REVIEW'
        GROUP BY 1),
dr AS (
SELECT
    document_id,
    ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY __file_date DESC) AS rn
    FROM athena.document_results
    WHERE status <> 'DELETED' AND patient_id <> 999999999 AND document_class IN ('LABRESULT','IMAGINGRESULT')
    AND order_document_id IS NOT NULL)
SELECT
    dr.document_id,
    prv.received_provider,
    ma.received_ma,
    ma.num_ma_touches
    FROM dr
    INNER JOIN prv
        ON dr.document_id = prv.document_id
    LEFT JOIN ma
        ON dr.document_id = ma.document_id
    WHERE dr.rn = 1
    GROUP BY 1,2,3,4 ;;

        sql_trigger_value: SELECT MAX(created_at) FROM athena.document_results ;;
        indexes: ["document_id"]
      }

      dimension: document_id {
        primary_key: yes
        type: number
        sql: ${TABLE}.document_id ;;
      }

  dimension_group: received_provider {
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
    sql: ${TABLE}."received_provider" ;;
  }

  dimension_group: received_ma {
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
    sql: ${TABLE}."received_ma" ;;
  }

  dimension: num_ma_touches {
    type: number
    sql: ${TABLE}.num_ma_touches ;;
  }

    }
