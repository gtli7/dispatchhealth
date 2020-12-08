view: channel_attribution {
  derived_table: {
    sql:
    WITH pn AS (
SELECT
    cr.id,
    pn.name AS provider_network
    FROM public.care_requests cr
    INNER JOIN athena.clinicalencounter ce
        ON cr.ehr_id = ce.appointment_char
    INNER JOIN athena.document_letters dl
        ON ce.clinical_encounter_id = dl.clinical_encounter_id
    INNER JOIN athena.clinicalletter cl
        ON dl.document_id = cl.document_id
    INNER JOIN athena.clinicalprovider cp
        ON cl.clinical_provider_recipient_id = cp.clinical_provider_id
    LEFT JOIN looker_scratch.provider_roster pr
        ON cp.npi = pr.npi::varchar
    LEFT JOIN looker_scratch.provider_network pn
        ON pr.provider_network_id = pn.id
    WHERE dl.document_subclass IS NULL AND pn.name IS NOT NULL)

SELECT
    cr.id AS care_request_id,
    COALESCE(
    CASE WHEN cr.request_type = 9
        OR trim(lower(gcs.queuename)) = 'dtc pilot' THEN 'DH Express/DTC Pilot' ELSE NULL END,
    CASE WHEN ep.patient_id IS NOT NULL
        OR pn.provider_network IS NOT NULL THEN 'Pop Health/Provider Network' ELSE NULL END,
    CASE WHEN cr.place_of_service LIKE '%Facility%' THEN 'Senior Living Facility' ELSE NULL END,
    CASE WHEN gcs.queuename IS NOT NULL THEN 'SEM Phone Number' ELSE NULL END,
    CASE WHEN ci.name IS NOT NULL THEN 'CARE Team Channel' ELSE NULL END
    ) AS primary_channel,
    CASE
        WHEN cr.request_type = 9 OR trim(lower(gcs.queuename)) = 'dtc pilot'
        THEN COALESCE(
            CASE WHEN ep.patient_id IS NOT NULL
                OR pn.provider_network IS NOT NULL THEN 'Pop Health/Provider Network' ELSE NULL END,
            CASE WHEN cr.place_of_service LIKE '%Facility%' THEN 'Senior Living Facility' ELSE NULL END,
            CASE WHEN gcs.queuename IS NOT NULL THEN 'SEM Phone Number' ELSE NULL END,
            CASE WHEN ci.name IS NOT NULL THEN 'CARE Team Channel' ELSE NULL END
            )
        WHEN ep.patient_id IS NOT NULL OR pn.provider_network IS NOT NULL
        THEN COALESCE(
            CASE WHEN cr.place_of_service LIKE '%Facility%' THEN 'Senior Living Facility' ELSE NULL END,
            CASE WHEN gcs.queuename IS NOT NULL THEN 'SEM Phone Number' ELSE NULL END,
            CASE WHEN ci.name IS NOT NULL THEN 'CARE Team Channel' ELSE NULL END
            )
        WHEN cr.place_of_service LIKE '%Facility%'
        THEN COALESCE(
            CASE WHEN gcs.queuename IS NOT NULL THEN 'SEM Phone Number' ELSE NULL END,
            CASE WHEN ci.name IS NOT NULL THEN 'CARE Team Channel' ELSE NULL END
            )
        WHEN gcs.queuename IS NOT NULL THEN 'CARE Team Channel'
        ELSE NULL
    END AS secondary_channel,
    CASE
        WHEN cr.request_type = 9 OR trim(lower(gcs.queuename)) = 'dtc pilot'
        THEN
            CASE
                WHEN ep.patient_id IS NOT NULL OR pn.provider_network IS NOT NULL
                THEN COALESCE(
                    CASE WHEN cr.place_of_service LIKE '%Facility%' THEN 'Senior Living Facility' ELSE NULL END,
                    CASE WHEN gcs.queuename IS NOT NULL THEN 'SEM Phone Number' ELSE NULL END,
                    CASE WHEN ci.name IS NOT NULL THEN 'CARE Team Channel' ELSE NULL END
                    )
                WHEN cr.place_of_service LIKE '%Facility%'
                THEN COALESCE(
                    CASE WHEN gcs.queuename IS NOT NULL THEN 'SEM Phone Number' ELSE NULL END,
                    CASE WHEN ci.name IS NOT NULL THEN 'CARE Team Channel' ELSE NULL END
                    )
                WHEN gcs.queuename IS NOT NULL AND ci.name IS NOT NULL THEN 'CARE Team Channel'
                ELSE NULL
            END
        WHEN ep.patient_id IS NOT NULL OR pn.provider_network IS NOT NULL
        THEN
            CASE
                WHEN cr.place_of_service LIKE '%Facility%'
                THEN COALESCE(
                    CASE WHEN gcs.queuename IS NOT NULL THEN 'SEM Phone Number' ELSE NULL END,
                    CASE WHEN ci.name IS NOT NULL THEN 'CARE Team Channel' ELSE NULL END
                    )
                WHEN gcs.queuename IS NOT NULL AND ci.name IS NOT NULL THEN 'CARE Team Channel'
                ELSE NULL
            END
        WHEN cr.place_of_service LIKE '%Facility%'
        THEN
            CASE WHEN gcs.queuename IS NOT NULL AND ci.name IS NOT NULL THEN 'CARE Team Channel'
            ELSE NULL END
        ELSE NULL
    END AS tertiary_channel
    FROM public.care_requests cr
    INNER JOIN public.care_request_statuses crs
        ON cr.id = crs.care_request_id AND crs.name = 'on_scene'
    LEFT JOIN public.channel_items ci
        ON cr.channel_item_id = ci.id
    LEFT JOIN public.callers clr
        ON cr.caller_id = clr.id
    LEFT JOIN looker_scratch.genesys_conversation_summary gcs
        ON gcs.conversationid = clr.contact_id
    LEFT JOIN public.eligible_patients ep
        ON cr.patient_id = ep.patient_id AND ep.deleted_at IS NULL
    LEFT JOIN pn
        ON cr.id = pn.id
    GROUP BY 1,2,3,4
    ;;

      sql_trigger_value:  SELECT MAX(id) FROM public.care_requests  where care_requests.created_at > current_date - interval '2 day';;
      indexes: ["care_request_id"]
    }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: primary_channel {
    type: string
    description: "The primary channel attributed to the patient"
    sql: ${TABLE}.primary_channel ;;
  }

  dimension: secondary_channel {
    type: string
    description: "The secondary channel attributed to the patient"
    sql: ${TABLE}.secondary_channel ;;
  }

  dimension: tertiary_channel {
    type: string
    description: "The tertiary channel attributed to the patient"
    sql: ${TABLE}.tertiary_channel ;;
  }

}
