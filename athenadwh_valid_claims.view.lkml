view: athenadwh_valid_claims {
  view_label: "ZZZZ - Athenadwh Valid Claims"
    derived_table: {
      sql:
  SELECT DISTINCT
  claim_id
  FROM looker_scratch.athenadwh_transactions_clone
  GROUP BY claim_id
  HAVING COUNT(transaction_id) > COUNT(CASE WHEN voided_date IS NOT NULL THEN transaction_id ELSE NULL END) ;;

        sql_trigger_value: SELECT MAX(created_at) FROM athenadwh_claims_clone ;;
        indexes: ["claim_id"]
      }

dimension: claim_id {
  description: "A valid claim where less than 100% of transactions have been voided"
  type: number
  sql: ${TABLE}.claim_id ;;
}

}
