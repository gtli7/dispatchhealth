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
    CASE WHEN cr.request_type = 9 THEN 'DH Express' ELSE NULL END,
    CASE WHEN ep.patient_id IS NOT NULL
        OR pn.provider_network IS NOT NULL THEN 'Pop Health/Provider Network' ELSE NULL END,
    CASE WHEN cr.place_of_service LIKE '%Facility%' THEN 'Senior Living Facility' ELSE NULL END,
    CASE WHEN gcs_dtc.conversationid is not null
    THEN 'SEM Phone Number' ELSE NULL END,
    CASE WHEN gcs.conversationid is not null
    THEN 'Partner Phone Number' ELSE NULL END,

    CASE WHEN ci.name IS NOT NULL THEN 'CARE Team Channel' ELSE NULL END
    ) AS primary_channel,
    CASE
        WHEN cr.request_type = 9
        THEN COALESCE(
            CASE WHEN ep.patient_id IS NOT NULL
                OR pn.provider_network IS NOT NULL THEN 'Pop Health/Provider Network' ELSE NULL END,
            CASE WHEN cr.place_of_service LIKE '%Facility%' THEN 'Senior Living Facility' ELSE NULL END,
            CASE WHEN gcs_dtc.conversationid is not null THEN 'SEM Phone Number' ELSE NULL END,
            CASE WHEN gcs.conversationid is not null
            THEN 'Partner Phone Number'
            ELSE NULL END,
            CASE WHEN ci.name IS NOT NULL THEN 'CARE Team Channel' ELSE NULL END
            )
        WHEN ep.patient_id IS NOT NULL OR pn.provider_network IS NOT NULL
        THEN COALESCE(
            CASE WHEN cr.place_of_service LIKE '%Facility%' THEN 'Senior Living Facility' ELSE NULL END,
            CASE WHEN gcs_dtc.conversationid is not null
    THEN 'SEM Phone Number' ELSE NULL END,
            CASE WHEN  gcs.conversationid is not null
            THEN 'Partner Phone Number'
            ELSE NULL END,
            CASE WHEN ci.name IS NOT NULL THEN 'CARE Team Channel' ELSE NULL END
            )
        WHEN cr.place_of_service LIKE '%Facility%'
        THEN COALESCE(
             CASE WHEN gcs_dtc.conversationid is not null
    THEN 'SEM Phone Number' ELSE NULL END,
                        CASE WHEN gcs.conversationid is not null
            THEN 'Partner Phone Number'
            ELSE NULL END,
            CASE WHEN ci.name IS NOT NULL THEN 'CARE Team Channel' ELSE NULL END
            )
        WHEN gcs.queuename IS NOT NULL THEN 'CARE Team Channel'
        ELSE NULL
    END AS secondary_channel,
    CASE
        WHEN cr.request_type = 9
        THEN
            CASE
                WHEN ep.patient_id IS NOT NULL OR pn.provider_network IS NOT NULL
                THEN COALESCE(
                    CASE WHEN cr.place_of_service LIKE '%Facility%' THEN 'Senior Living Facility' ELSE NULL END,
                    CASE WHEN gcs_dtc.conversationid is not null
    THEN 'SEM Phone Number' ELSE NULL END,
                    CASE WHEN gcs.conversationid is not null
            THEN 'Partner Phone Number'
            ELSE NULL END,
                    CASE WHEN ci.name IS NOT NULL THEN 'CARE Team Channel' ELSE NULL END
                    )
                WHEN cr.place_of_service LIKE '%Facility%'
                THEN COALESCE(
                      CASE WHEN trim(lower(gcs.queuename)) in('dtc pilot','den las sem vip') THEN 'SEM Phone Number' ELSE NULL END,
                                 CASE WHEN gcs.conversationid is not null
            THEN 'Partner Phone Number'
            ELSE NULL END,
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
                   CASE WHEN gcs.conversationid is not null
            THEN 'Partner Phone Number'
            ELSE NULL END,
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
    LEFT JOIN public.channel_items ci
        ON cr.channel_item_id = ci.id
    LEFT JOIN public.callers clr
        ON cr.caller_id = clr.id
    left join looker_scratch.genesys_conversation_summary gcs_dtc
    ON gcs_dtc.conversationid = clr.contact_id
    AND gcs_dtc.queuename in('DTC Pilot', 'DEN LAS SEM VIP')
    LEFT JOIN looker_scratch.genesys_conversation_summary gcs
        ON gcs.conversationid = clr.contact_id
        and (gcs.queuename in('Partner Direct', 'ATL Optum Care', 'LAS RCC', 'Humana Partner Direct', 'BOI Regence', 'POR Regence', 'SEA Regence', 'SPO Regence' )
    OR
    gcs.dnis in('+18889020922', '+18336520539', '+16783218305', '+16785686682', '+16783903016', '+18884890212', '+16784003240', '+16785037909', '+16787225440', '+16786608360', '+16782038288', '+16783839048', '+16785676239', '+16788794668', '+16783653380', '+16789414068', '+12082688029', '+12082694709', '+12082989653', '+12082735583', '+12082680544', '+12082989893', '+12083159838', '+12084251378', '+12084252226', '+17193006474', '+17194458249', '+17193005385', '+17194010147', '+17194676591', '+17194010127', '+17193784170', '+17194135051', '+12164789449', '+12164789448', '+12164789205', '+12167589707', '+12165103160', '+12167589949', '+12162580157', '+14693970485', '+12143771791', '+12149034262', '+14694449341', '+14696597570', '+12148656283', '+14695818160', '+14695051172', '+14693970047', '+14695812859', '+14695819010', '+14694154633', '+14693431162', '+14695928809', '+14692003379', '+14693974647', '+17206476419', '+17204879530', '+17205889686', '+18889050858', '+17206479927', '+17207389539', '+17202951986', '+17207389786', '+17207389538', '+17206179626', '+17208266460', '+17207226114', '+17206799834', '+17206739769', '+17206738434', '+17197599589', '+17206799843', '+18174351727', '+18176770692', '+18176427764', '+18177794077', '+18177538518', '+18178096809', '+18177538912', '+18176319056', '+19593019618', '+19592070455', '+19592070456', '+19592025890', '+19598819570', '+19594562406', '+19598819691', '+19598819690', '+19598819572', '+19598819693', '+12815038089', '+12818628551', '+12819427075', '+13462785077', '+12815423971', '+18329750876', '+12817219086', '+12819305429', '+12818456351', '+12818849904', '+12819374445', '+12815472908', '+13176681989', '+13176802143', '+13177398540', '+13175970701', '+13176200400', '+13179434730', '+13177850995', '+18652133445', '+18652804094', '+18652804092', '+18652948755', '+18652948750', '+18652590389', '+17028734226', '+17028748811', '+17026596193', '+17027447828', '+17028055711', '+17028995190', '+17029899910', '+17029706634', '+17026595292', '+17026758133', '+17252019473', '+17029961709', '+17025534051', '+17025512822', '+17028275579', '+17026257886', '+17028275511', '+17866446415', '+17866446417', '+17866446416', '+17866385853', '+17866525563', '+17866985127', '+19737862468', '+19737862227', '+19737671685', '+19739526370', '+19739394607', '+16156370877', '+16155053591', '+16154555874', '+16157519490', '+16155702202', '+16156370987', '+12018246428', '+12018827527', '+12013352933', '+12018704540', '+12015469247', '+12017209798', '+12018853706', '+14052947762', '+14053370838', '+14052548708', '+14052547619', '+14052547616', '+14053387272', '+14053696049', '+14053587723', '+13602008247', '+13602008249', '+13603506407', '+13602005876', '+13608364855', '+13606390859', '+13608229590', '+13603387107', '+15208155137', '+14805810509', '+14805816774', '+16232462430', '+16026442474', '+14808770765', '+16028990555', '+14805817269', '+16026619366', '+16232574996', '+14806459418', '+14805874446', '+14805270556', '+14804779401', '+15037148991', '+15037148541', '+15034683350', '+15039174904', '+15034953163', '+15039174089', '+15038202525', '+15039371809', '+19198978786', '+19198975715', '+19198978788', '+19194430766', '+19198745172', '+19193912120', '+17753168406', '+17754391529', '+17754425871', '+17754425870', '+17753751572', '+17753167559', '+17753463018', '+17753399838', '+18042800240', '+18042860307', '+18042941871', '+18043488866', '+18042941872', '+18042236078', '+18043614601', '+18044240637', '+18044664994', '+18044629992', '+12108915233', '+12108915231', '+12108915232', '+12108915230', '+12109606565', '+12103010013', '+14255534976', '+14253725441', '+14253725440', '+14255280217', '+14255281307', '+14256512473', '+14255281429', '+14256699540', '+12064299968', '+12064299969', '+12068863551', '+15094082109', '+15099563817', '+15095427295', '+15095373587', '+15097614502', '+15093502415', '+15093816858', '+15095910822', '+15098223232', '+15097035022', '+14139981981', '+14132404469', '+14132132623', '+14132395662', '+14132529372', '+14132486314', '+14132529377', '+14132486318', '+14132486323', '+14132395897', '+12539484672', '+12532719721', '+12532403465', '+12533728763', '+12536669459', '+12535271931', '+12533414072', '+12535617080', '+12539543354', '+14252508054', '+12533192848', '+12533934321', '+12534421064', '+18135436945', '+18135650224', '+18135536314', '+18136025311', '+18135787114', '+18137554667', '+18136860371', '+18135787116', '+15203855684', '+15204422267', '+15204422388', '+15204423235', '+15203959411', '+15203914188', '+18889050616', '+18889050859', '+18889050858', '+18889050617', '+18884411146', '+18889050851', '+18884411269', '+18884411302', '+18884411423', '+18884411303', '+18884411545', '+18884411425', '+18337570964', '+18337570449', '+18335890988', '+18334860661', '+18884011510', '+18339870809', '+18336721641', '+18885980726', '+18337600748', '+18337601833', '+18887280258', '+18336851060', '+18336851062', '+18339013127', '+18339722343', '+18334100839', '+18339192334', '+18337230490', '+18887161458', '+18884890212', '+18334311989', '+18334811807', '+18334851437', '+18334920263', '+18337881366', '+18337881365', '+18337441441', '+18334471138', '+18336660798', '+18339761528', '+18339401609', '+18336431786'))
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

  dimension: primary_channel_source {
    type: string
    description: "The primary channel source to the patient"
    sql: ${TABLE}.primary_channel ;;
  }

  dimension: secondary_channel_source {
    type: string
    description: "The secondary channel source to the patient"
    sql: ${TABLE}.secondary_channel ;;
  }

  dimension: tertiary_channel_source {
    type: string
    description: "The tertiary channel source to the patient"
    sql: ${TABLE}.tertiary_channel ;;
  }

  dimension: primary_channel_attribution {
    type: string
    sql: case when ${primary_channel_source} in('DH Express', 'Senior Living Facility') then 'Community'
              when ${primary_channel_source}  in('Pop Health/Provider Network', 'Partner Phone Number') then 'Strategic'
              when ${primary_channel_source} in('SEM Phone Number') then 'Direct to Consumer'
              when ${channel_items.high_level_category_new} in('Home Health', 'Senior Care')  then 'Community'
              when ${channel_items.high_level_category_new} in('Strategic', 'Provider Group', 'Provider (Generic)') then 'Strategic'
              when ${channel_items.high_level_category_new} in('Family or Friends','Direct to Consumer')  then 'Direct to Consumer'
              else 'None Attributed' end

              ;;
  }

  dimension: secondary_channel_attribution_raw {
    type: string
    hidden: yes
    sql: case when ${secondary_channel_source} in('DH Express', 'Senior Living Facility') then 'Community'
              when ${secondary_channel_source}  in('Pop Health/Provider Network', 'Partner Phone Number') then 'Strategic'
              when ${secondary_channel_source} in('SEM Phone Number') then 'Direct to Consumer'
              when ${channel_items.high_level_category_new} in('Home Health', 'Senior Care')  then 'Community'
              when ${channel_items.high_level_category_new} in('Strategic', 'Provider Group', 'Provider (Generic)') then 'Strategic'
              when ${channel_items.high_level_category_new} in('Family or Friends','Direct to Consumer')  then 'Direct to Consumer'
              else 'None Attributed' end

              ;;
  }

  dimension: tertiary_channel_attribution_raw {
    hidden: yes
    type: string
    sql: case when ${tertiary_channel_source} in('DH Express', 'Senior Living Facility') then 'Community'
              when ${tertiary_channel_source}  in('Pop Health/Provider Network', 'Partner Phone Number') then 'Strategic'
              when ${tertiary_channel_source} in('SEM Phone Number') then 'Direct to Consumer'
              when ${channel_items.high_level_category_new} in('Home Health', 'Senior Care')  then 'Community'
              when ${channel_items.high_level_category_new} in('Strategic', 'Provider Group', 'Provider (Generic)') then 'Strategic'
              when ${channel_items.high_level_category_new} in('Family or Friends','Direct to Consumer')  then 'Direct to Consumer'
              else 'None Attributed' end

              ;;
  }
  dimension: secondary_channel_attribution  {
    type: string
    sql: case when ${primary_channel_attribution} != ${secondary_channel_attribution_raw} then ${secondary_channel_attribution_raw} else null end ;;
  }

  dimension: tertiary_channel_attribution  {
    type: string
    sql: case when ${primary_channel_attribution} != ${secondary_channel_attribution_raw} and ${secondary_channel_attribution} !=${tertiary_channel_attribution_raw} then ${tertiary_channel_attribution_raw} else null end ;;
  }

  dimension: community_attribution {
    type: string
    sql: case when ${primary_channel_attribution} ='Community' then 'Primary Community'
              when ${secondary_channel_attribution} = 'Community' then 'Secondary Community'
               when ${tertiary_channel_attribution} = 'Community' then 'Tertiary Community'
              else null end;;
  }

  dimension: strategic_attribution {
    type: string
    sql: case when ${primary_channel_attribution} ='Strategic' then 'Primary Strategic'
              when ${secondary_channel_attribution} = 'Strategic' then 'Secondary Strategic'
               when ${tertiary_channel_attribution} = 'Strategic' then 'Tertiary Strategic'
              else null end;;
  }

  dimension: dtc_attribution {
    type: string
    sql: case when ${primary_channel_attribution} ='Direct to Consumer' then 'Primary Direct to Consumer'
              when ${secondary_channel_attribution} = 'Direct to Consumer' then 'Secondary Direct to Consumer'
               when ${tertiary_channel_attribution} = 'Direct to Consumer' then 'Tertiary Direct to Consumer'
              else null end;;
  }


}
