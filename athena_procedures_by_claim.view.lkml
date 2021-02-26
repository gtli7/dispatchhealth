view: athena_procedures_by_claim {
    derived_table: {
      sql:
          SELECT
    ROW_NUMBER() OVER() AS id,
    claim_id,
    unnest(procedure_codes) AS procedure_code
    FROM athena.transactions_summary;;
    sql_trigger_value: SELECT MAX(claim_id) FROM athena.claim ;;
      indexes: ["procedure_code", "claim_id"]
    }

  dimension: id {
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;
  }
  dimension: claim_id {
    type: number
    sql: ${TABLE}.claim_id ;;
  }
  dimension: procedure_code {
    type: string
    sql: ${TABLE}.procedure_code ;;
  }

}
