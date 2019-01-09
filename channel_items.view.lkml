view: channel_items {
  sql_table_name: public.channel_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
  }

  dimension: agreement {
    type: yesno
    sql: ${TABLE}.agreement ;;
  }

  dimension: blended_bill {
    type: yesno
    sql: ${TABLE}.blended_bill ;;
  }

  dimension: blended_description {
    type: string
    sql: ${TABLE}.blended_description ;;
  }

  dimension: case_policy_number {
    type: string
    sql: ${TABLE}.case_policy_number ;;
  }

  dimension: channel_id {
    type: number
    sql: ${TABLE}.channel_id ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: contact_person {
    type: string
    sql: ${TABLE}.contact_person ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: deactivated {
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
    sql: ${TABLE}.deactivated_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: emr_provider_id {
    type: string
    sql: ${TABLE}.emr_provider_id ;;
  }

  dimension: name {
    type: string
    sql: TRIM(INITCAP(${TABLE}.name)) ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: preferred_partner {
    type: yesno
    sql: ${TABLE}.preferred_partner ;;
  }

  dimension: preferred_partner_description {
    type: string
    sql: ${TABLE}.preferred_partner_description ;;
  }

  dimension: send_clinical_note {
    type: yesno
    sql: ${TABLE}.send_clinical_note IS TRUE ;;
  }

  dimension: send_note_automatically {
    type: yesno
    sql: ${TABLE}.send_note_automatically IS TRUE ;;
  }

  dimension: source_name {
    type: string
    sql: ${TABLE}.source_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: type_name {
    type: string
    sql: ${TABLE}.type_name ;;
  }

  dimension: sub_type {
    type: string
    sql: CASE
          WHEN ${source_name} LIKE 'Emergency Medical Service%' THEN ${name}
          WHEN ${source_name} = 'Direct Access' THEN ${source_name}
          WHEN ${source_name} = 'Healthcare Partners' THEN ${type_name}
          ELSE 'Undocumented'
        END ;;
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
    sql: ${TABLE}.updated_at ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  dimension: zipcode_short {
    type: zipcode
    sql: left(${zipcode},5) ;;
  }

  dimension: digital_bool_self_report {
    type: yesno
    sql:  ${name} in('Google or other search', 'Social Media (Facebook, LinkedIn, Twitter, Instagram)', 'Social Media(Facebook, LinkedIn, Twitter, Instagram)')


;;
  }


  dimension: digital_bool {
    type:  yesno
    sql: ${ga_pageviews_clone.source_final} is not null or ${web_ga_pageviews_clone.source_final} is not null;;
  }
  dimension: channel_name_fixed {
    type: string
    sql:  case when trim(lower(${name})) in('social media (facebook, linkedin, twitter, instagram)', 'social media(facebook, linkedin, twitter, instagram)') then 'Social Media (Facebook, LinkedIn, Twitter, Instagram)'
          else ${name} end;;
  }
  measure: count {
    type: count
    drill_fields: [id, name, source_name, type_name]
  }

  dimension: non_dtc_self_report {
    type: yesno
    sql:${type_name} in('Senior Care', 'Hospice & Palliative Care', 'SNF' , 'Home Health', 'Health System', 'Employer', 'Payer', 'Provider Group')
    OR ${name} in('Employer', 'Employer Organization', 'Health Insurance Company', '911 Channel', 'West Metro Fire Rescue', 'South Metro Fire Rescue', 'Healthcare provider', 'Healthcare Provider')
    OR (${name} = 'Family or friend' and  ${dtc_ff_patients.patient_id} is null and ${ga_pageviews_full_clone.high_level_category} is null)  ;;

  }

  dimension: name_no_tabs {
    type: string
    sql:  regexp_replace(${name}, '\s+$', '')
;;
  }

  dimension: high_level_category {
    type: string
    sql: case
         when  (${type_name} is null and lower(${name_no_tabs}) not in('family or friend', 'healthcare provider', 'healthcare provider', 'employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue'))  then 'Direct to Consumer'
          when lower(${type_name}) in('senior care', 'hospice & palliative care', 'snf' , 'home health') or  lower(${name_no_tabs}) in('healthcare provider', 'healthcare provider')  then 'Senior Care'
          when lower(${type_name}) in('health system', 'employer', 'payer', 'provider group', 'injury finance') or lower(${name_no_tabs}) in('employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue') then 'Strategic'          when ${digital_bool} then 'Direct to Consumer'
          when ${dtc_ff_patients.patient_id} is not null then 'Direct to Consumer'
          when lower(${name_no_tabs}) ='family or friend' then 'Family or Friends'
          when ${name_no_tabs} is null then 'No Channel'
        else concat(coalesce(${type_name}, 'Direct'), ': ', ${name_no_tabs}) end;;
  }

  dimension: high_level_category_new {
    type: string
    label: "High Level Category (HH+Provider)"
    sql: case
         when  (${type_name} is null and lower(${name_no_tabs}) not in('family or friend', 'healthcare provider', 'healthcare provider', 'employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue'))  then 'Direct to Consumer'
         when lower(${name_no_tabs}) in('home health') then 'Home Health'
         when lower(${name_no_tabs}) in('healthcare provider', 'healthcare provider') or lower(${type_name}) in('provider group') then 'Provider'
         when lower(${type_name}) in('senior care', 'hospice & palliative care', 'snf' , )  then 'Senior Care'
         when lower(${type_name}) in('health system', 'employer', 'payer', 'provider group', 'injury finance') or lower(${name_no_tabs}) in('employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue') then 'Strategic'          when ${digital_bool} then 'Direct to Consumer'
         when ${dtc_ff_patients.patient_id} is not null then 'Direct to Consumer'
         when lower(${name_no_tabs}) ='family or friend' then 'Family or Friends'
         when ${name_no_tabs} is null then 'No Channel'
        else concat(coalesce(${type_name}, 'Direct'), ': ', ${name_no_tabs}) end;;
  }

}
