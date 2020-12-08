view: athenadwh_patient_current_medications {
    derived_table: {
      sql: SELECT DISTINCT
        patient_id,
        chart_id,
        medication_id,
        MAX(medication_name) AS medication_name,
        MAX(fill_date) AS fill_date,
        MAX(DATE(created_datetime)) AS created_date,
        MAX(created_by) AS created_by,
        MAX(updated_at) AS updated_at
        from athenadwh_patient_medication_clone
        WHERE medication_type = 'PATIENTMEDICATION' AND deactivation_datetime IS NULL
        GROUP BY 1,2,3 ;;

  sql_trigger_value: SELECT MAX(created_datetime) FROM athenadwh_patient_medication_clone ;;
  indexes: ["patient_id", "chart_id", "medication_id"]
    }

  view_label: "ZZZZ - Athenadwh Patient Current Medications"

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}.patient_id::varchar, ' ', ${TABLE}.medication_id::varchar) ;;
  }

    dimension: chart_id {
      type: number
      sql: ${TABLE}.chart_id ;;
    }

    dimension: created_by {
      type: string
      sql: ${TABLE}.created_by ;;
    }

    dimension_group: created_datetime {
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
      sql: ${TABLE}.created_datetime ;;
    }

    dimension: deactivated_by {
      type: string
      sql: ${TABLE}.deactivated_by ;;
    }

    dimension_group: fill {
      type: time
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.fill_date ;;
    }

    dimension: medication_id {
      type: number
      sql: ${TABLE}.medication_id ;;
    }

    dimension: medication_name {
      type: string
      sql: ${TABLE}.medication_name ;;
    }

    measure: medications_list {
      label: "List of all medications"
      type: string
      sql: string_agg(DISTINCT ${medication_name}, ' | ') ;;
    }

  dimension: medication_name_short {
    description: "The first word of the medication name"
    type: string
    sql: INITCAP(split_part(${medication_name}, ' ', 1)) ;;
  }

  measure: medications_list_short {
    description: "List of all medications (first word only)"
    type: string
    sql: string_agg(DISTINCT ${medication_name_short}, ' | ') ;;
  }

    dimension: patient_id {
      type: number
      sql: ${TABLE}.patient_id ;;
    }

    dimension: patient_id_short_med_name {
      description: "Concatenate patient ID and medication short name for counting"
      hidden: yes
      type: string
      sql: CONCAT(${patient_id}::varchar,' ', ${medication_name_short}) ;;
    }

    dimension: valid_patient_id {
      type: yesno
      hidden: yes
      sql: ${patient_id} IS NOT NULL ;;
    }

    dimension: dme_equipment_medicine {
      type: yesno
      description: "A flag indicating the medicine is DME or Medical Supplies"
      sql: ${athenadwh_medication_clone.hic1_description} SIMILAR TO '%(MEDICAL SUPPLIES AND DEVICES|DURABLE MEDICAL EQUIPMENT)%' ;;
    }

    measure: count_medications {
      type: count_distinct
      sql: ${compound_primary_key} ;;
      filters: {
        field: valid_patient_id
        value: "yes"
      }
    }

  measure: count_medications_short {
    type: count_distinct
    sql: ${patient_id_short_med_name} ;;
    filters: {
      field: valid_patient_id
      value: "yes"
    }
  }

  measure: count_dme_equipment_medications_short {
    type: count_distinct
    sql: ${patient_id_short_med_name} ;;
    filters: {
      field: valid_patient_id
      value: "yes"
    }
    filters: {
      field: dme_equipment_medicine
      value: "yes"
    }
  }

  measure: count_dme_equipment_medications {
    type: count_distinct
    sql: ${compound_primary_key} ;;
    filters: {
      field: valid_patient_id
      value: "yes"
    }
    filters: {
      field: dme_equipment_medicine
      value: "yes"
    }
  }

  # dimension: num_medication_range {
  #   type: tier
  #   tiers: [5,10,15,25,35,50]
  #   style: integer
  #   sql: ${count_medications} ;;
  # }

    measure: count_distinct_patients {
      type: count_distinct
      sql: ${patient_id} ;;
    }

  }
