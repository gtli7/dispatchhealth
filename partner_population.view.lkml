view: partner_population {
  derived_table: {
    sql:

WITH ep AS (
    SELECT
        patient_id,
        channel_item_id
        FROM public.eligible_patients
        WHERE deleted_at IS NULL AND patient_id IS NOT NULL),
referral AS (
SELECT
    ord.clinical_encounter_id,
    cp.name AS referral_provider
    FROM athena.document_orders ord
    INNER JOIN athena.clinicalprovider cp
        ON ord.clinical_provider_id = cp.clinical_provider_id
    WHERE ord.clinical_encounter_id IS NOT NULL
        AND ord.clinical_order_type LIKE '%REFERRAL%'
        AND ord.status <> 'DELETED'),
ltr AS (
SELECT
    dl.clinical_encounter_id,
    lr.name AS letter_recipient,
    lr.npi,
    pn.name AS provider_network
    FROM athena.document_letters dl
    LEFT JOIN athena.clinicalletter cl
        ON dl.document_id = cl.document_id
    LEFT JOIN athena.clinicalprovider lr
        ON cl.clinical_provider_recipient_id = lr.clinical_provider_id
    LEFT JOIN looker_scratch.provider_roster pr
        ON lr.npi = pr.npi::varchar
    INNER JOIN looker_scratch.provider_network pn
        ON pr.provider_network_id = pn.id
    WHERE (dl.document_subclass <> 'LETTER_PATIENTCORRESPONDENCE' OR dl.document_subclass IS NULL)
    AND dl.status <> 'DELETED'
    AND lr.npi IS NOT NULL)

SELECT
    ce.clinical_encounter_id,
    apt.appointment_id,
    cr.id AS care_request_id,
    ci.name AS channel,
    ph.name AS pop_health_channel,
    referral.referral_provider,
    ltr.provider_network
    FROM public.care_requests cr
    INNER JOIN public.care_request_statuses crs
        ON cr.id = crs.care_request_id AND crs.name = 'complete'
    LEFT JOIN athena.appointment apt
        ON cr.ehr_id = apt.appointment_char
    LEFT JOIN athena.clinicalencounter ce
        ON ce.appointment_id = apt.appointment_id
    LEFT JOIN public.channel_items ci
        ON cr.channel_item_id = ci.id
    LEFT JOIN ep
        ON cr.patient_id = ep.patient_id
    LEFT JOIN public.channel_items ph
        ON ep.channel_item_id = ph.id
    LEFT JOIN referral
        ON ce.clinical_encounter_id = referral.clinical_encounter_id
    LEFT JOIN ltr
        ON ce.clinical_encounter_id = ltr.clinical_encounter_id
    GROUP BY 1,2,3,4,5,6,7 ;;

      sql_trigger_value: SELECT MAX(id) FROM public.care_requests where care_requests.created_at > current_date - interval '2 day' ;;
      indexes: ["care_request_id"]
    }

    dimension: care_request_id {
      type: number
      sql: ${TABLE}.care_request_id ;;
    }

    dimension: channel_name {
      type: string
      sql: ${TABLE}.channel ;;
    }

    dimension: population_health_channel_name {
      type: string
      sql: ${TABLE}.pop_health_channel ;;
    }

    dimension: referral_provider {
      type: string
      sql: ${TABLE}.referral_provider ;;
    }

    dimension: provider_network {
      type: string
      sql: ${TABLE}.provider_network ;;
    }

  dimension: partner_population {
    type: string
    group_label: "Partner Specific Descriptions"
    sql:  CASE WHEN  lower(${channel_name}) LIKE '%bon secours%' OR
          lower(${population_health_channel_name}) = 'bon secours mssp' THEN 'Bon Secours'

          WHEN substring(lower(${channel_name}),1,3) = 'ou ' OR
          lower(${channel_name}) LIKE '%stephenson cancer center%' THEN 'OUMI & OU Physicians'

          WHEN  lower(${channel_name}) LIKE '%vcu%' OR
          lower(${referral_provider}) LIKE '%vcuhs%' THEN 'VCU Health'

          WHEN lower(${channel_name}) LIKE '%renown%' OR
          lower(${population_health_channel_name}) = '%renown%' THEN 'Renown Medical Group'


          WHEN (lower(${channel_name}) = 'healthcare provider' AND lower(${provider_network}) = 'bon secours medical group') THEN 'Bon Secours'
          WHEN lower(${provider_network}) = 'ou physicians' THEN 'OUMI & OU Physicians'
          WHEN lower(${provider_network}) = 'virginia commonwealth university health system' THEN 'VCU Health'
          WHEN lower(${provider_network}) = 'renown medical group' THEN 'Renown Medical Group'
          ELSE NULL END ;;
  }



  }
