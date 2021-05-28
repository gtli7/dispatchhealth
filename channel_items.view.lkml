view: channel_items {
  sql_table_name: public.channel_items ;;

  dimension: id {
    primary_key: yes
    type: number
    hidden: no
    sql: ${TABLE}.id ;;
  }

  dimension: address {
    type: string
    hidden: yes
    sql: ${TABLE}.address_old ;;
  }

  dimension: agreement {
    type: yesno
    hidden: yes
    sql: ${TABLE}.agreement ;;
  }

  dimension: blended_bill {
    type: yesno
    hidden: yes
    sql: ${TABLE}.blended_bill ;;
  }

  dimension: blended_description {
    type: string
    hidden: yes
    sql: ${TABLE}.blended_description ;;
  }

  dimension: case_policy_number {
    type: string
    hidden: yes
    sql: ${TABLE}.case_policy_number ;;
  }

  dimension: channel_id {
    type: number
    sql: ${TABLE}.channel_id ;;
  }

  dimension: city {
    type: string
    hidden: yes
    sql: ${TABLE}.city_old ;;
  }

  dimension: contact_person {
    type: string
    hidden: yes
    sql: ${TABLE}.contact_person ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
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
    hidden: yes
    sql: ${TABLE}.email ;;
  }

  dimension: emr_provider_id {
    type: string
    hidden: yes
    sql: ${TABLE}.emr_provider_id ;;
  }

  dimension: name_orig {
    type: string
    hidden: yes
    sql: ${TABLE}.name ;;
  }

  dimension: name {
    type: string
    description: "Channel Name"
    group_label: "Description"
    sql: CASE
    WHEN INITCAP(${name_orig}) LIKE '%Google Or Other Search%' THEN 'Google or Other Search'
    WHEN INITCAP(${name_orig}) LIKE '%911 Channel%' THEN '911 Channel'
    ELSE INITCAP(regexp_replace(${name_orig}, '\s+$', ''))
    END ;;
  }

  dimension: multicare_charity_patient {
    type: yesno
    group_label: "Partner Specific Descriptions"
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
    group_label: "Partner Specific Descriptions"
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
    hidden: yes
    sql: ${TABLE}.phone ;;
  }

  dimension: preferred_partner {
    type: yesno
    hidden: yes
    sql: ${TABLE}.preferred_partner ;;
  }

  dimension: preferred_partner_description {
    type: string
    hidden: yes
    sql: ${TABLE}.preferred_partner_description ;;
  }

  dimension: send_clinical_note {
    type: yesno
    group_label: "Dashboard Defaults"
    sql: ${TABLE}.send_clinical_note IS TRUE ;;
  }

  dimension: send_note_automatically {
    type: yesno
    group_label: "Dashboard Defaults"
    sql: ${TABLE}.send_note_automatically IS TRUE ;;
  }

  dimension: source_name {
    type: string
    description: "Direct Access, Healthcare Partners, Emergency Medical Service, Mass Testing or Payer"
    group_label: "Description"
    sql: CASE WHEN ${TABLE}.source_name LIKE 'Emergency Medical Service%' THEN 'Emergency Medical Service'
         ELSE ${TABLE}.source_name
         END ;;
    drill_fields: [type_name, type_name_direct_access, sub_type, name]
  }

  dimension: state {
    type: string
    hidden: yes
    sql: ${TABLE}.state_old ;;
  }

  dimension: type_name {
    type: string
    group_label: "Description"
    description: "Payer, Health System, Employer, Provider Group, Senior Care, etc."
    sql: ${TABLE}.type_name ;;
  }

  dimension: type_name_direct_access {
    type: string
    group_label: "Description"
    description: "Type name where direct access channels are grouped e.g. Employer, Family or Friend, etc."
    sql: case
    when ${name_no_tabs} in ('Healthcare Provider','Provider Group') or ${type_name} = 'Provider Group' then 'Provider or Provider Group'
    when ${name_no_tabs} = 'Family Or Friend' then 'Family Or Friend'
    when ${name_no_tabs} in('Employer', 'Employer Organization') then 'Employer'
    when ${name_no_tabs} = 'Health Insurance Company' then 'Payer'
    when ${name_no_tabs} in('West Metro Fire Rescue', 'South Metro Fire Rescue', '911 channel') then '911 channel'
    when ${type_name} is null then 'Direct to Consumer'
    else ${type_name} end ;;
    drill_fields: [sub_type, name]
  }

  dimension: sub_type {
    type: string
    group_label: "Description"
    description: "Source name split into more granular groups"
    sql: CASE
        WHEN lower(${channel_items.name}) LIKE 'healthcare provider' THEN 'Provider Group'
        WHEN lower(${channel_items.name}) IN ('health insurance company', 'employer') THEN 'Payer'
        WHEN ${source_name} LIKE 'Emergency Medical Service%' THEN ${name}
        WHEN ${source_name} = 'Direct Access' THEN ${source_name}
        WHEN ${source_name} = 'Healthcare Partners' THEN ${type_name}
        ELSE 'Undocumented'
        END ;;
    drill_fields: [name]
  }

measure: count_direct_access_sub_type {
  description: "Count of care requests channeled through direct access sub type"
  type: count_distinct
  sql: ${care_requests.id};;
  filters: {
    field: sub_type
    value: "Direct Access"
  }
  group_label: "Sub Type Measures"
}

  measure: count_provider_group_sub_type {
    description: "Count of care requests channeled through provider group sub type"
    type: count_distinct
    sql: ${care_requests.id};;
    filters: {
      field: sub_type
      value: "Provider Group"
    }
    group_label: "Sub Type Measures"
    }

  measure: count_senior_care_sub_type {
    description: "Count of care requests channeled through senior care sub type"
    type: count_distinct
    sql: ${care_requests.id};;
    filters: {
      field: sub_type
      value: "Senior Care"
    }
    group_label: "Sub Type Measures"
  }

  measure: count_home_health_sub_type {
    description: "Count of care requests channeled through home health sub type"
    type: count_distinct
    sql: ${care_requests.id};;
    filters: {
      field: sub_type
      value: "Home Health"
    }
    group_label: "Sub Type Measures"
  }


  measure: count_health_system_sub_type {
    description: "Count of care requests channeled through health system sub type"
    type: count_distinct
    sql: ${care_requests.id};;
    filters: {
      field: sub_type
      value: "Health System"
    }
    group_label: "Sub Type Measures"
  }


  measure: count_payer_sub_type {
    description: "Count of care requests channeled through payer sub type"
    type: count_distinct
    sql: ${care_requests.id};;
    filters: {
      field: sub_type
      value: "Payer"
    }
    group_label: "Sub Type Measures"
  }

  measure: count_employer_sub_type {
    description: "Count of care requests channeled through employer sub type"
    type: count_distinct
    sql: ${care_requests.id};;
    filters: {
      field: sub_type
      value: "Employer"
    }
    group_label: "Sub Type Measures"
  }

  measure: count_hospice_palliative_sub_type {
    description: "Count of care requests channeled through hospice & palliative sub type"
    type: count_distinct
    sql: ${care_requests.id};;
    filters: {
      field: sub_type
      value: "Hospice & Palliative Care"
    }
    group_label: "Sub Type Measures"
  }

  dimension_group: updated {
    type: time
    hidden: yes
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
    hidden: yes
    sql: ${TABLE}.zipcode_old ;;
  }

  dimension: zipcode_short {
    type: zipcode
    hidden: yes
    sql: left(${zipcode},5) ;;
  }

  dimension: digital_bool_self_report {
    type: yesno
    description: "A yes/no field indicating self-reported digital channel (social media, search engine, etc.)"
    group_label: "Description"
    sql:  ${name} in('Google or other search', 'Social Media (Facebook, LinkedIn, Twitter, Instagram)', 'Social Media(Facebook, LinkedIn, Twitter, Instagram)')
;;
  }


  dimension: digital_bool {
    type:  yesno
    group_label: "Description"
    description: "A yes/no field indicating digital channel (social media, search engine, etc.)"
    sql: ${ga_pageviews_clone.source_final} is not null or ${web_ga_pageviews_clone.source_final} is not null;;
  }

  dimension: channel_name_fixed {
    type: string
    description: "Channel name where special characters have been removed"
    group_label: "Description"
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
    group_label: "Description"
    description: "Self-reported non direct-to-consumer channels"
    sql:${type_name} in('Senior Care', 'Hospice & Palliative Care', 'SNF' , 'Home Health', 'Health System', 'Employer', 'Payer', 'Provider Group')
    OR ${name} in('Employer', 'Employer Organization', 'Health Insurance Company', '911 Channel', 'West Metro Fire Rescue', 'South Metro Fire Rescue', 'Healthcare provider', 'Healthcare Provider')
    OR (${name} = 'Family or friend' and  ${dtc_ff_patients.patient_id} is null and ${ga_pageviews_full_clone.high_level_category} is null)  ;;

  }

  dimension: name_no_tabs {
    type: string
    hidden: yes
    description: "DO NOT USE: Use channel_name_fixed instead"
    sql:  regexp_replace(${name}, '\s+$', '')
;;
  }

  dimension: high_level_category {
    type: string
    description: "DTC, Senior Care, Family/Friend or Direct <channel name>"
    group_label: "Description"
    sql: case
          when ${name_no_tabs} is null then 'No Channel'
          when  (${type_name} is null and lower(${name_no_tabs}) not in('family or friend', 'healthcare provider', 'healthcare provider', 'employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue', 'central pierce fire & rescue', 'ymca/jcc/rec center/community event', 'lighthouse of houston/council of the blind', 'presentation / meeting','event/in-service', 'bridgewater assisted living avondale', 'dementia conference', 'harris county aging and disability resource center- care connection', 'fort bend senior event/expo', 'jcc/jewish community', 'senior event/tradeshow/expo', 'community fair/event','stafford center expo/event', 'tacoma fire', 'business network group','humana at home',
          'multicare clinic without walls', 'mass covid testing', 'medstar - 911', 'south metro fire rescue clinic', 'seniorific news', 'richmond ambulance authority', 'medstar / ems'))  then 'Direct to Consumer'
          when lower(${type_name}) in('senior care', 'hospice & palliative care', 'snf' , 'home health') or  lower(${name_no_tabs}) in('healthcare provider', 'healthcare provider', 'ymca/jcc/rec center/community event', 'lighthouse of houston/council of the blind','presentation / meeting', 'event/in-service', 'bridgewater assisted living avondale','dementia conference', 'harris county aging and disability resource center- care connection', 'fort bend senior event/expo', 'jcc/jewish community', 'senior event/tradeshow/expo', 'community fair/event','stafford center expo/event', 'seniorific news')  then 'Senior Care'
          when lower(${type_name}) in('health system', 'employer', 'payer', 'provider group', 'injury finance') or lower(${name_no_tabs}) in('tacoma fire', 'business network group','humana at home', 'employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue', 'central pierce fire & rescue', 'multicare clinic without walls', 'mass covid testing', 'medstar - 911', 'south metro fire rescue clinic', 'richmond ambulance authority', 'medstar / ems') then 'Strategic'
          when lower(${name_no_tabs}) ='family or friend' then 'Family or Friends'
        else concat(coalesce(${type_name}, 'Direct'), ': ', ${name_no_tabs}) end;;
    drill_fields: [sub_type, name]
  }

  dimension: high_level_category_new {
    type: string
    label: "High Level Category (HH+Provider)"
    group_label: "Description"
    sql: case
         when ${name_no_tabs} is null then 'No Channel'
         when  (${type_name} is null and lower(${name_no_tabs}) not in('family or friend', 'healthcare provider', 'healthcare provider', 'employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue', 'central pierce fire & rescue', 'ymca/jcc/rec center/community event', 'lighthouse of houston/council of the blind', 'presentation / meeting','event/in-service', 'bridgewater assisted living avondale', 'dementia conference', 'harris county aging and disability resource center- care connection', 'fort bend senior event/expo', 'jcc/jewish community', 'senior event/tradeshow/expo', 'community fair/event','stafford center expo/event', 'tacoma fire', 'business network group','humana at home',
        'multicare clinic without walls', 'mass covid testing', 'medstar - 911','south metro fire rescue clinic', 'seniorific news', 'richmond ambulance authority', 'medstar / ems'))  then 'Direct to Consumer'
         when lower(${type_name}) in('home health') then 'Home Health'
         when lower(${name_no_tabs}) in('healthcare provider') then 'Provider (Generic)'
         when lower(${type_name}) in('provider group') then 'Provider Group'
         when lower(${type_name}) in('senior care', 'hospice & palliative care', 'snf') or  lower(${name_no_tabs}) in('ymca/jcc/rec center/community event', 'lighthouse of houston/council of the blind','presentation / meeting', 'event/in-service', 'bridgewater assisted living avondale','dementia conference', 'harris county aging and disability resource center- care connection', 'fort bend senior event/expo','jcc/jewish community', 'senior event/tradeshow/expo', 'community fair/event','stafford center expo/event', 'seniorific news')  then 'Senior Care'
         when lower(${type_name}) in('health system', 'employer', 'payer', 'injury finance') or lower(${name_no_tabs}) in('tacoma fire', 'business network group','humana at home', 'employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue', 'central pierce fire & rescue', 'multicare clinic without walls', 'mass covid testing', 'medstar - 911', 'south metro fire rescue clinic', 'richmond ambulance authority', 'medstar / ems') then 'Strategic'
         when lower(${name_no_tabs}) ='family or friend' then 'Family or Friends'
        else concat(coalesce(${type_name}, 'Direct'), ': ', ${name_no_tabs}) end;;
    drill_fields: [sub_type, name]
  }

  dimension: high_level_clinical_integration {
    type: string
    label: "High Level Category (Clinical Integration)"
    group_label: "Description"
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
    group_label: "Description"
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
    group_label: "Partner Specific Descriptions"
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
    group_label: "Partner Specific Descriptions"
    sql: ${id} in(2851, 2849, 2850, 2852, 2848, 2890, 2900) OR
         (${name} LIKE 'Bridge-%' AND ${name} LIKE '%Hpn');;
  }

  dimension: er_diversion {
    type: number
    group_label: "Dashboard Defaults"
    description: "The cost savings associated with ER diversions for the Channel package"
    sql: ${TABLE}.er_diversion ;;
  }

  dimension: nine_one_one_diversion {
    type: number
    group_label: "Dashboard Defaults"
    description: "The cost savings associated with 911 diversions for the Channel package"
    sql: ${TABLE}.nine_one_one_diversion ;;
  }

  dimension: observation_diversion {
    type: number
    group_label: "Dashboard Defaults"
    description: "The cost savings associated with observation diversions for the Channel package"
    sql: ${TABLE}.observation_diversion ;;
  }

  dimension: hospitalization_diversion {
    type: number
    group_label: "Dashboard Defaults"
    description: "The cost savings associated with hospitalization diversions for the Channel package"
    sql: ${TABLE}.hospitalization_diversion ;;
  }

  dimension: ems_channel {
    description: "Channel name contains 'Ems', 'Fire' or '911'"
    group_label: "Description"
    type: yesno
    sql: ${name} like '%Ems%' OR  ${name} LIKE '%Fire%' OR  ${name} like '%911%' ;;
  }

  dimension: senior {
    type: yesno
    group_label: "Description"
    description: "Channel name contains 'Senior Care', 'Hospice', or 'SNF'"
    sql: lower(${type_name}) in('senior care', 'hospice & palliative care', 'snf')  ;;
  }

  dimension: growth_target {
    type: yesno
    group_label: "Description"
    sql: ${sf_accounts.priority_account_timestamp_year} =  '2021';;
  }

  dimension: generic_organization {
    type: yesno
    hidden: yes
    group_label: "Description"
    sql: ${name_no_tabs} in('Home Health Organization', 'Hospice & Palliative Care Organization',   'Provider Group Organization', 'Senior Care Organization', 'Snf Organization') ;;
  }

  dimension: senior_umbrella_org {
    type: string
    group_label: "Description"
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
    group_label: "Partner Specific Descriptions"
    sql: lower(${name}) LIKE '%bon secours%' OR
    ${population_health_channels.name} = 'bon secours mssp' OR
    (lower(${name}) = 'healthcare provider' AND lower(${provider_network.name}) = 'bon secours medical group') ;;
  }

  dimension: express_channel{
    type: string
    sql: case when ${id} in(9,83,1842, 504,10, 4633) then ${name}
      else 'Express Not Implented' end;;
  }

  # dimension: partner_population_old {
  #   type: string
  #   group_label: "Partner Specific Descriptions"
  #   sql:  CASE WHEN  lower(${name}) LIKE '%bon secours%' OR
  #         ${population_health_channels.name} = 'bon secours mssp' THEN 'Bon Secours'

  #         WHEN substring(lower(${name}),1,3) = 'ou ' OR
  #         lower(${name}) LIKE '%stephenson cancer center%' THEN 'OUMI & OU Physicians'

  #         WHEN  lower(${name}) LIKE '%vcu%' OR
  #         ((${athenadwh_referrals.clinical_order_type}) IS NOT NULL AND
  #         lower(${athenadwh_referral_providers.name}) LIKE '%vcuhs%') THEN 'VCU Health'

  #         WHEN lower(${name}) LIKE '%renown%' OR
  #         ${population_health_channels.name} = 'bon secours mssp' THEN 'Renown Medical Group'


  #         WHEN (lower(${name}) = 'healthcare provider' AND lower(${provider_network.name}) = 'bon secours medical group') THEN 'Bon Secours'
  #         WHEN lower(${provider_network.name}) = 'ou physicians' THEN 'OUMI & OU Physicians'
  #         WHEN lower(${provider_network.name}) = 'virginia commonwealth university health system' THEN 'VCU Health'
  #         WHEN lower(${provider_network.name}) = 'renown medical group' THEN 'Renown Medical Group'


  #         ELSE NULL END ;;
  # }

  dimension: partner_population {
    type: string
    group_label: "Partner Specific Descriptions"
    sql: ${partner_population.partner_population} ;;
  }
  dimension: high_level_category_consolidated {
    type: string
    sql:  case
          when ${high_level_category_new} in('Home Health', 'Senior Care')  then 'Community'
          when ${high_level_category_new} in('Strategic', 'Provider Group', 'Provider (Generic)') then 'Strategic'
          when ${high_level_category_new} in('Family or Friends','Direct to Consumer')  then 'Direct to Consumer'

          else 'None Attributed' end;;
  }


dimension: uhc_partner_profile {
  description: "The UHC program based on dnis and channel name"
  type: string
  group_label: "Partner Specific Descriptions"
  sql:  CASE
          WHEN ${genesys_conversation_summary.dnis} in('+18884890212') OR ${channel_items.name} = 'Public Sector Nurse Line (Uhc Nurseline)' then 'UHC Nurse Line'
          WHEN ${genesys_conversation_summary.dnis} in('+18334311989') OR ${channel_items.name} = 'UHC Call Us First' then 'UHC Nurse Line'
          WHEN ${genesys_conversation_summary.dnis} in('+18334811807') OR ${channel_items.name} = 'UHC Navigate for Me' then 'UHC Navigate for Me'
          WHEN ${genesys_conversation_summary.dnis} in('+18334851437') OR ${channel_items.name} = 'UHC Patient Connect' then 'UHC Patient Connect'
          WHEN ${genesys_conversation_summary.dnis} in(
                                                      '+16783903016',
                                                      '+12082989653',
                                                      '+12164789205',
                                                      '+17194010147',
                                                      '+14694449341',
                                                      '+17207389539',
                                                      '+18176427764',
                                                      '+19598819570',
                                                      '+19592025890',
                                                      '+12818628551',
                                                      '+13175970701',
                                                      '+13177398540',
                                                      '+18652804092',
                                                      '+17028055711',
                                                      '+17866446416',
                                                      '+19737862227',
                                                      '+16154555874',
                                                      '+12018704540',
                                                      '+14053370838',
                                                      '+13602005876',
                                                      '+14805816774',
                                                      '+15034683350',
                                                      '+19198978788',
                                                      '+17754425870',
                                                      '+18042941871',
                                                      '+12108915230',
                                                      '+14255280217',
                                                      '+15095427295',
                                                      '+14132395662',
                                                      '+12533728763',
                                                      '+18135536314',
                                                      '+15204423235',
                                                      '+18334920263',
                                                      '+17372271842',
                                                      '+14074901364',
                                                      '+15132756491',
                                                      '+16146969714',
                                                      '+13868684767',
                                                      '+12393223524',
                                                      '+19133088455',
                                                      '+15022094305',
                                                      '+15713851946',
                                                      '+13524150987')
                                                      OR ${channel_items.name} in (
                                                                                    'UHC General',
                                                                                    'Unitedhealthcare Community Plan (Uhccp)',
                                                                                    'United Healthcare Hou',
                                                                                    'United Healthcare Community Plan / Whole Person Care Team',
                                                                                    'Optum',
                                                                                    'Optum Medical Group',
                                                                                    'Unitedhealthcare/Optumcare/Health Plan Of Nevada (Hpn)/Sierra Health & Life Medicare Plans'
                                                                                    )
                                                      then 'UHC General'
          WHEN ${genesys_conversation_summary.dnis} in('+18336660798') OR ${channel_items.name} = 'naviHealth' then 'naviHealth'
          WHEN ${genesys_conversation_summary.dnis} in( '+18339761528',
                                                        '+18336721641') OR ${channel_items.name} = 'Optum I-SNP' then 'Optum I-SNP'
          WHEN ${genesys_conversation_summary.dnis} in(
                                                        '+18339013127',
                                                        '+16783839048',
                                                        '+12083159838',
                                                        '+12167589707',
                                                        '+17194010127',
                                                        '+14694154633',
                                                        '+17207226114',
                                                        '+18178096809',
                                                        '+19598819691',
                                                        '+12818849904',
                                                        '+13176200400',
                                                        '+18652948755',
                                                        '+17028275579',
                                                        '+17866385853',
                                                        '+19737671685',
                                                        '+16157519490',
                                                        '+12015469247',
                                                        '+14053387272',
                                                        '+13606390859',
                                                        '+14805874446',
                                                        '+15039174089',
                                                        '+19194430766',
                                                        '+17753167559',
                                                        '+18044240637',
                                                        '+12108915231',
                                                        '+14256699540',
                                                        '+15093816858',
                                                        '+14132486318',
                                                        '+12533192848',
                                                        '+18137554667',
                                                        '+15204422267',
                                                        '+17372346255',
                                                        '+14077435380',
                                                        '+15132160157',
                                                        '+16146622340',
                                                        '+13863102841',
                                                        '+12393223491',
                                                        '+19133088456',
                                                        '+15022253216',
                                                        '+15713273130',
                                                        '+13524030068')
                                                      OR ${channel_items.name} in (
                                                                                    'Optum Housecalls (Apc)',
                                                                                    'UHC Housecalls National')
                                                      then 'UHC Housecalls'
          WHEN ${genesys_conversation_summary.dnis} in(
                                                        '+18889050616',
                                                        '+18333892576') OR ${channel_items.name} = 'Direct Mail or Door Hanger' then 'Optum National Mailer'
          WHEN ${channel_items.name} in ( 'Uhc/Optum Case Management',
                                          'Uhc / Optum Care Manager',
                                          'Optum (Complex Care Management Team)',
                                          'Uhc Case Management') then 'UHC/Optum Case Management'
          WHEN ${channel_items.name} in (
                                          'Optum At Home/United Healthcare At Home Care Navigators',
                                          'United Healthcare At Home Care Navigators') then 'Optum At Home/United Healthcare At Home Care Navigators'
          WHEN ${genesys_conversation_summary.dnis} in ('+16783218305')
                                                    OR ${channel_items.name} in ('Optum At Home / United Healthcare At Home',
                                                                                  'Optum - Other') then 'Optum at Home'
          WHEN ${channel_items.name} = 'Optumcare Primary Care-Deer Valley' then 'Optum Primary Care-Deer Valley'
          WHEN ${genesys_conversation_summary.dnis} in('+17026596193') OR ${channel_items.name} = 'Optumcare Resource Coordination Center (Rcc)' then 'Optumcare Resource Coordination Center (Rcc)'
          WHEN ${genesys_conversation_summary.dnis} in(
                                                      '+18339143500',
                                                      '+18334100839')
                                                    OR ${channel_items.name} = 'Optum Ctp (Community Transitions Program)' then 'Optum Transitions to Home CTP'
          WHEN ${genesys_conversation_summary.dnis} in('+17202951986',
                                                      '+12064299968')
                                                    OR ${channel_items.name} in('Denver Optum Vivage',
                                                                                'Optum Snf Program Pnw',
                                                                                'Seattle Optum Snf') then 'Optum SNF'
          WHEN ${genesys_conversation_summary.dnis} in('+18336851060') OR ${channel_items.name} = 'Uhc C&S Ltss' then 'UHC C&S LTSS'
          WHEN ${genesys_conversation_summary.dnis} in('+14808770765') OR ${channel_items.name} = 'Optumcare' then 'Optumcare'
          WHEN ${genesys_conversation_summary.dnis} in('+18336371670') OR ${channel_items.name} = 'Prospero' then 'Prospero'
          WHEN ${genesys_conversation_summary.dnis} in('+18336370622') OR ${channel_items.name} in ('Aspire Health', 'Aspire Home Care') then 'Aspire'
          WHEN ${genesys_conversation_summary.dnis} in('+18336792314') then 'Optum Oncology'
          WHEN ${genesys_conversation_summary.dnis} in('+18652900579','+16153344869') OR ${channel_items.name} = 'Somatus' then 'Somatus'
          WHEN ${genesys_conversation_summary.dnis} = '+18337171858' then 'Optum KRS'
          WHEN ${genesys_conversation_summary.dnis} = '+18336851062' then 'UHC C&S Post Acute'
          WHEN ${genesys_conversation_summary.dnis} = '+18337171870' then 'CareAngel'
          END;;
}




}
