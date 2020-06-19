view: channel_items {
  sql_table_name: public.channel_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}.address_old ;;
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
    sql: ${TABLE}.city_old ;;
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
    sql: CASE
    WHEN INITCAP(${TABLE}.name) LIKE '%Google Or Other Search%' THEN 'Google or Other Search'
    WHEN INITCAP(${TABLE}.name) LIKE '%911 Channel%' THEN '911 Channel'
    ELSE INITCAP(regexp_replace(${TABLE}.name, '\s+$', ''))
    END ;;
  }

  dimension: multicare_charity_patient {
    type: yesno
    description: "Channel name is Multicare Charity Care OR CSC note references MultiCare - Charity"
    sql: ${name} = 'Multicare Charity Care' OR ${notes.note} LIKE '%MultiCare - Charity%' ;;
  }

  dimension: divert_from_911 {
    description: "Channel is 911"
    type: yesno
    sql: ${name} LIKE '%911 Channel%' OR ${sub_type} LIKE '%911 Channel%';;
  }

  dimension: referred_from_hh_pcp_cm {
    description: "The care request was referred from PCP, home health or care management"
    type: yesno
    sql: ${type_name} SIMILAR TO '%(Home Health|Provider Group)%' OR LOWER(${care_requests.activated_by}) SIMILAR TO '%(home health|s clinician)%' ;;
  }

  dimension: uhc_hpn_channel {
    description: "The business line acronym for UHC Health Plan of Nevada patients"
    type: string
    sql: CASE
          WHEN lower(${name}) LIKE 'hpn/shl access center%' THEN 'AC'
          WHEN lower(${name}) LIKE 'hpn/shl willing hands%' THEN 'WH'
          WHEN lower(${name}) LIKE 'hpn/shl ed education%' THEN 'EDED'
          WHEN lower(${name}) LIKE 'hpn/shl asthma education%' THEN 'ASTH'
          WHEN lower(${name}) LIKE 'hpn/shl hedis%' THEN 'HEDG'
          WHEN lower(${name}) LIKE 'hpn/shl post acute follow up%' OR (${name} LIKE 'Bridge-%' AND ${name} LIKE '%Hpn') THEN 'PAFU'
          WHEN lower(${name}) LIKE 'hpn/shl opcm%' THEN 'OPCM'
          WHEN lower(${name}) LIKE 'hpn/shl tcm%' THEN 'TCM'
          ELSE ${name}
        END;;
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
    sql: ${TABLE}.state_old ;;
  }

  dimension: type_name {
    type: string
    sql: ${TABLE}.type_name ;;
  }

  dimension: type_name_direct_access {
    type: string
    sql: case
    when ${name_no_tabs} in ('Healthcare Provider','Provider Group') or ${type_name} = 'Provider Group' then 'Provider or Provider Group'
    when ${name_no_tabs} = 'Family Or Friend' then 'Family Or Friend'
    when ${name_no_tabs} in('Employer', 'Employer Organization') then 'Employer'
    when ${name_no_tabs} = 'Health Insurance Company' then 'Payer'
    when ${name_no_tabs} in('West Metro Fire Rescue', 'South Metro Fire Rescue', '911 channel') then '911 channel'
    when ${type_name} is null then 'Direct to Consumer'
    else ${type_name} end ;;
  }

  dimension: sub_type {
    type: string
    sql: CASE
        WHEN lower(${channel_items.name}) LIKE 'healthcare provider' THEN 'Provider Group'
        WHEN lower(${channel_items.name}) LIKE 'health insurance company' THEN 'Payer'
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
    sql: ${TABLE}.zipcode_old ;;
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
    sql:  regexp_replace(case when trim(lower(${name})) in('social media (facebook, linkedin, twitter, instagram)', 'social media(facebook, linkedin, twitter, instagram)') then 'Social Media (Facebook, LinkedIn, Twitter, Instagram)'
          else ${name} end, '\s+$', '')

;;
  }
  measure: count {
    type: count_distinct
    sql: ${id} ;;
    sql_distinct_key: ${id} ;;
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
          when ${name_no_tabs} is null then 'No Channel'
          when  (${type_name} is null and lower(${name_no_tabs}) not in('family or friend', 'healthcare provider', 'healthcare provider', 'employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue', 'central pierce fire & rescue', 'ymca/jcc/rec center/community event', 'lighthouse of houston/council of the blind', 'presentation / meeting','event/in-service', 'bridgewater assisted living avondale', 'dementia conference', 'harris county aging and disability resource center- care connection', 'fort bend senior event/expo', 'jcc/jewish community'))  then 'Direct to Consumer'
          when lower(${type_name}) in('senior care', 'hospice & palliative care', 'snf' , 'home health') or  lower(${name_no_tabs}) in('healthcare provider', 'healthcare provider', 'ymca/jcc/rec center/community event', 'lighthouse of houston/council of the blind','presentation / meeting', 'event/in-service', 'bridgewater assisted living avondale','dementia conference', 'harris county aging and disability resource center- care connection', 'fort bend senior event/expo', 'jcc/jewish community')  then 'Senior Care'
          when lower(${type_name}) in('health system', 'employer', 'payer', 'provider group', 'injury finance') or lower(${name_no_tabs}) in('employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue', 'central pierce fire & rescue') then 'Strategic'
          when lower(${name_no_tabs}) ='family or friend' then 'Family or Friends'
        else concat(coalesce(${type_name}, 'Direct'), ': ', ${name_no_tabs}) end;;
  }

  dimension: high_level_category_new {
    type: string
    label: "High Level Category (HH+Provider)"
    sql: case
         when ${name_no_tabs} is null then 'No Channel'
         when  (${type_name} is null and lower(${name_no_tabs}) not in('family or friend', 'healthcare provider', 'healthcare provider', 'employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue', 'central pierce fire & rescue', 'ymca/jcc/rec center/community event', 'lighthouse of houston/council of the blind', 'presentation / meeting','event/in-service', 'bridgewater assisted living avondale', 'dementia conference', 'harris county aging and disability resource center- care connection', 'fort bend senior event/expo', 'jcc/jewish community', 'senior event/tradeshow/expo', 'community fair/event','stafford center expo/event'))  then 'Direct to Consumer'
         when lower(${type_name}) in('home health') then 'Home Health'
         when lower(${name_no_tabs}) in('healthcare provider') then 'Provider (Generic)'
         when lower(${type_name}) in('provider group') then 'Provider Group'
         when lower(${type_name}) in('senior care', 'hospice & palliative care', 'snf') or  lower(${name_no_tabs}) in('ymca/jcc/rec center/community event', 'lighthouse of houston/council of the blind','presentation / meeting', 'event/in-service', 'bridgewater assisted living avondale','dementia conference', 'harris county aging and disability resource center- care connection', 'fort bend senior event/expo','jcc/jewish community', 'senior event/tradeshow/expo', 'community fair/event','stafford center expo/event')  then 'Senior Care'
         when lower(${type_name}) in('health system', 'employer', 'payer', 'injury finance') or lower(${name_no_tabs}) in('employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue', 'central pierce fire & rescue') then 'Strategic'
         when lower(${name_no_tabs}) ='family or friend' then 'Family or Friends'
        else concat(coalesce(${type_name}, 'Direct'), ': ', ${name_no_tabs}) end;;
  }

  dimension: high_level_clinical_integration {
    type: string
    label: "High Level Category (Clinical Integration)"
    sql: case
         when ${name_no_tabs} is null then 'No Channel'
         when  (${type_name} is null and lower(${name_no_tabs}) not in('family or friend', 'healthcare provider', 'healthcare provider', 'employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue', 'central pierce fire & rescue', 'ymca/jcc/rec center/community event', 'lighthouse of houston/council of the blind', 'presentation / meeting','event/in-service', 'bridgewater assisted living avondale', 'dementia conference', 'harris county aging and disability resource center- care connection', 'fort bend senior event/expo', 'jcc/jewish community', 'senior event/tradeshow/expo', 'community fair/event','stafford center expo/event'))  then 'Direct to Consumer'
         when lower(${name_no_tabs}) in('healthcare provider') then 'Provider (Generic)'
         when lower(${type_name}) in('senior care', 'hospice & palliative care', 'home health') or  lower(${name_no_tabs}) in('ymca/jcc/rec center/community event', 'lighthouse of houston/council of the blind','presentation / meeting', 'event/in-service', 'bridgewater assisted living avondale','dementia conference', 'harris county aging and disability resource center- care connection', 'fort bend senior event/expo','jcc/jewish community', 'senior event/tradeshow/expo', 'community fair/event','stafford center expo/event')  then 'Senior Care'
         when lower(${type_name}) in('health system', 'snf', 'payer', 'provider group') or lower(${name_no_tabs}) in('health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue', 'central pierce fire & rescue') then 'Clinical Integration'
         when lower(${type_name}) in('employer', 'injury finance') or lower(${name_no_tabs}) in('employer', 'employer organization') then 'Other'
         when lower(${name_no_tabs}) ='family or friend' then 'Family or Friends'
        else concat(coalesce(${type_name}, 'Direct'), ': ', ${name_no_tabs}) end;;
  }


  dimension: high_level_category_new_percent {
    type: number
    sql: case when ${high_level_category_new} =  'Direct to Consumer' then .05
    when ${high_level_category_new} =  'Home Health' then 1.0
    when ${high_level_category_new} =  'Provider (Generic)' then .5
    when ${high_level_category_new} =  'Provider Group' then .5
    when ${high_level_category_new} =  'Senior Care' then 1.0
    when ${high_level_category_new} =  'Strategic' then .05
    else 0 end;;
  }

  dimension: high_level_dallas {
    type: string
    label: "High Level Dallas"
    sql: case
         when ${name_no_tabs} is null then 'No Channel'
         when  (${type_name} is null and lower(${name_no_tabs}) not in('family or friend', 'healthcare provider', 'healthcare provider', 'employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue', 'central pierce fire & rescue', 'ymca/jcc/rec center/community event', 'lighthouse of houston/council of the blind', 'presentation / meeting','event/in-service', 'bridgewater assisted living avondale', 'dementia conference', 'harris county aging and disability resource center- care connection','fort bend senior event/expo', 'jcc/jewish community'))  then 'Direct to Consumer'
         when lower(${type_name}) in('home health') then 'Home Health'
         when lower(${type_name}) in('provider group') or  lower(${name_no_tabs}) in('healthcare provider') then 'Provider'
         when lower(${name_no_tabs}) in('employer') then 'Employer'
         when lower(${type_name}) in('senior care', 'hospice & palliative care', 'snf') or  lower(${name_no_tabs}) in('ymca/jcc/rec center/community event', 'lighthouse of houston/council of the blind','presentation / meeting', 'event/in-service', 'bridgewater assisted living avondale','dementia conference', 'harris county aging and disability resource center- care connection','fort bend senior event/expo', 'jcc/jewish community')  then 'Senior Care'
         when lower(${type_name}) in('health system', 'payer', 'injury finance') or lower(${name_no_tabs}) in('employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue', 'central pierce fire & rescue') then 'Strategic'
         when lower(${name_no_tabs}) ='family or friend' then 'Family or Friends'
        else concat(coalesce(${type_name}, 'Direct'), ': ', ${name_no_tabs}) end;;
  }


  dimension: uhc_care_request {
    type: yesno
    sql: ${id} in(2851, 2849, 2850, 2852, 2848, 2890, 2900) OR
         (${name} LIKE 'Bridge-%' AND ${name} LIKE '%Hpn');;
  }

  dimension: er_diversion {
    type: number
    description: "The cost savings associated with ER diversions for the Channel package"
    sql: ${TABLE}.er_diversion ;;
  }

  dimension: nine_one_one_diversion {
    type: number
    description: "The cost savings associated with 911 diversions for the Channel package"
    sql: ${TABLE}.nine_one_one_diversion ;;
  }

  dimension: observation_diversion {
    type: number
    description: "The cost savings associated with observation diversions for the Channel package"
    sql: ${TABLE}.observation_diversion ;;
  }

  dimension: hospitalization_diversion {
    type: number
    description: "The cost savings associated with hospitalization diversions for the Channel package"
    sql: ${TABLE}.hospitalization_diversion ;;
  }

  dimension: senior {
    type: yesno
    sql: lower(${type_name}) in('senior care', 'hospice & palliative care', 'snf')  ;;
  }

  dimension: growth_target {
    type: yesno
    sql: ${sf_accounts.priority_account_timestamp_raw} >=  date_trunc('month', now())::date - 30 ;;
  }

  dimension: generic_organization {
    type: yesno
    sql: ${name_no_tabs} in('Home Health Organization', 'Hospice & Palliative Care Organization',   'Provider Group Organization', 'Senior Care Organization', 'Snf Organization') ;;
  }

  dimension: senior_umbrella_org {
    type: string
    sql: case when lower(${name_no_tabs}) like '%bayada%' or lower(${preferred_partner_description}) like '%bayada%' then 'bayada'
when lower(${name_no_tabs}) like '%encompass%' or lower(${preferred_partner_description}) like '%encompass%' then 'encompass'
when lower(${name_no_tabs}) like '%team select%' or lower(${preferred_partner_description}) like '%team select%' then 'team select'
when lower(${name_no_tabs}) like '%amedisys%' or lower(${preferred_partner_description}) like '%amedisys%' then 'amedisys'
when lower(${name_no_tabs}) like '%kindred%' or lower(${preferred_partner_description}) like '%kindred%' then 'kindred'
when lower(${name_no_tabs}) like '%brookdale%' or lower(${preferred_partner_description}) like '%brookdale%' then 'brookdale'
when lower(${name_no_tabs}) like '%clc %' or lower(${preferred_partner_description}) like '%clc %' then 'christian living'
when lower(${name_no_tabs}) like '%(rcm)%' or lower(${preferred_partner_description}) like '%(rcm)%' then '(rcm)'
when lower(${name_no_tabs}) like '%sunrise%' or lower(${preferred_partner_description}) like '%sunrise%' then 'sunrise'
when lower(${name_no_tabs}) like '%morningstar%' or lower(${preferred_partner_description}) like '%morningstar%' then 'morningstar'
when lower(${name_no_tabs}) like '%holiday retirement%' or lower(${preferred_partner_description}) like '%holiday retirement%' then 'holiday retirement'
when lower(${name_no_tabs}) like '%atria%' or lower(${preferred_partner_description}) like '%atria%' then 'atria'
when lower(${name_no_tabs}) like '%life care center%' or lower(${preferred_partner_description}) like '%life care center%' then 'life care center'
else null end;;
  }

  dimension: partner_pop_bon_secours {
    type: yesno
    sql: lower(${name}) LIKE '%bon secours%' OR
    ${population_health_channels.name} = 'bon secours mssp' OR
    (lower(${name}) = 'healthcare provider' AND lower(${provider_network.name}) = 'bon secours medical group') ;;
  }

  dimension: partner_population {
    type: string
    sql:  CASE WHEN  lower(${name}) LIKE '%bon secours%' OR
    ${population_health_channels.name} = 'bon secours mssp' OR
    (lower(${name}) = 'healthcare provider' AND lower(${provider_network.name}) = 'bon secours medical group') THEN 'Bon Secours'

    WHEN substring(lower(${name}),1,3) = 'ou ' OR
    lower(${name}) LIKE '%stephenson cancer center%' OR
    lower(${provider_network.name}) = 'ou physicians' THEN 'OU Physicians'

    ELSE NULL END ;;
  }

}
