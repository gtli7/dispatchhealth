view: eligible_patients_full_table {
  view_label: "Eligible Patients Data Validation"
  sql_table_name: public.eligible_patients ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: distinct_patient {
    type: string
    sql: UPPER(concat(replace(${last_name}, '''', '')::text, to_char(${dob_date}, 'MM/DD/YYYY'), ${gender})) ;;
  }


  measure: count_distinct_patients {
    type: count_distinct
    sql: ${distinct_patient} ;;
  }

  measure: count_distinct_eligible_active_patients {
    type: count_distinct
    sql: ${distinct_patient} ;;
    filters: {
      field: deleted_date
      value: "NULL"
    }
   }

  measure: count_distinct_eligible_deacivated_patients {
    type: count_distinct
    sql: ${distinct_patient} ;;
    filters: {
      field: deleted_date
      value: "-NULL"
    }
  }

  dimension: channel_item_id {
    type: number
    sql: ${TABLE}.channel_item_id ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension_group: dob {
    type: time
    timeframes: [
      raw,
      date,
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dob ;;
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

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  measure: count_at_risk_patients {
    label: "Count Distinct At Risk Patients matched to a DH patient"
    type: count_distinct
    sql: ${patient_id} ;;
  }

  measure: count_active_patients_matched_to_dh_patient {
    type: count_distinct
    sql: ${patient_id} ;;
    filters: {
      field: deleted_date
      value: "NULL"
    }
  }

  measure: count_deactivated_patients_matched_to_dh_patient {
    type: count_distinct
    sql: ${patient_id} ;;
    filters: {
      field: deleted_date
      value: "-NULL"
    }
  }

  dimension: population_health_patient {
    description: "Identifies 'At Risk' patients"
    type: yesno
    sql: ${patient_id} IS NOT NULL ;;
  }

  dimension: pcp {
    type: string
    sql: ${TABLE}.pcp ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name]
  }

}
