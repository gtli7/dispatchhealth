view: athenadwh_clinical_providers_fax_clone {
  derived_table: {
    sql:
    select case
  when fax is not null and fax not in('nan') and  fax not in('') then trim(replace(replace(replace(replace(replace(fax, '(', ''), ')', ''), '-', ''), ' ', ''), '.', ''))::bigint
  else null end
  as fax, clinical_provider_id
from looker_scratch.athenadwh_clinical_providers_fax_clone
group by 1,2

;;
    sql_trigger_value: select max(athenadwh_clinical_providers_clone.created_at)
      from looker_scratch.athenadwh_clinical_providers_clone ;;
    indexes: ["clinical_provider_id", "fax"]
  }

  view_label: "ZZZZ - Athenadwh Clinical Providers Fax Clone"

  dimension: clinical_provider_id {
    type: number
    sql: ${TABLE}.clinical_provider_id;;
  }

  dimension: fax {
    type: string
    sql: ${TABLE}.fax;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
