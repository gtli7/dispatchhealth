view: sql_runner_query_weekly_care_requests_per_ca {
  derived_table: {
    sql: -- use existing inbound_not_answered_or_abandoned in looker_scratch.LR$7NKF21624921228076_inbound_not_answered_or_abandoned
      -- use existing care_request_flat in looker_scratch.LR$7N5IA1624874904300_care_request_flat
      SELECT
          genesys_conversation_wrapup."username"  AS "genesys_conversation_wrapup.username",
              (TO_CHAR(DATE_TRUNC('week', genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC'), 'YYYY-MM-DD')) AS "genesys_conversation_summary.conversationstarttime_week",
          COUNT(DISTINCT CASE WHEN ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') THEN ( genesys_conversation_summary."conversationid"  )  ELSE NULL END) AS "genesys_conversation_summary.count_answered_total",
          COUNT(DISTINCT CASE WHEN (((genesys_conversation_summary."mediatype")='voice' and trim(lower((genesys_conversation_summary."queuename"))) not like '%outbound%' and trim(lower((genesys_conversation_summary."queuename"))) not like '%after hours%' and trim(lower((genesys_conversation_summary."queuename"))) not like '%optimizer%' and trim(lower((genesys_conversation_summary."queuename"))) not in('mobile requests','ma', 'rcm / billing', 'backline', 'development', 'secondary screening', 'dispatchhealth help desk', 'dispatch health nurse line', 'zzavtextest', 'pay bill', 'testing', 'initial follow up', 'rn1', 'rn2', 'rn3', 'rn4', 'rn5', 'rn6', 'rn7', 'rn8', 'rn9', 'ivr fail safe', 'covid testing results', 'ebony testing', 'ma/nurse', 'dispatchhealth help desk vendor', 'do not use ma/nurse', 'sem vip', 'covid task force', 'covid pierce county mass testing', 'acute care covid results & care request', 'phx', 'mobile request callbacks', 'click to call', 'dialer results', 'cancels', 'care team escalations', 'rn10', 'advance care fax queue', 'rn11', 'rn12', 'rn13','rn14', 'vip help line', 'kaiser ma email', 'care web chat lab results', 'zztest_delete', 'none', 'care web chat covid', 'care web chat', 'advanced care', 'talent acquisition', 'rn15', 'rn16', 'rn17', 'rn18', 'sykes cancels','sykes ma','ppx billing','ppx workflow')) and (markets.id is not null)) AND ((genesys_conversation_summary."totalagenttalkduration") >60000) AND ((genesys_conversation_summary."queuename")!='None') THEN concat(( case when  (genesys_conversation_summary."direction") ='inbound' then (genesys_conversation_summary."ani")
                    when (genesys_conversation_summary."direction") = 'outbound' then (case when  (genesys_conversation_summary."direction") ='inbound' then genesys_conversation_summary."dnis"
                    when (genesys_conversation_summary."direction") = 'outbound' then  inbound_not_answered_or_abandoned.dnis
                    else null end)
                    else null end ), ( CAST(EXTRACT(HOUR FROM genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC') AS INT) ), ( DATE(genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC') )) ELSE NULL END) AS "genesys_conversation_summary.distinct_answer_long_callers",
          COUNT(DISTINCT care_request_flat.care_request_id ) AS "care_request_flat.care_request_count",
          COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN  ((DATE(care_request_flat.accept_date )) IS NOT NULL) or (((((not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      )) and lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) like '%acute%'
               AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.on_scene_date ))
                OR
               (DATE(care_request_flat.on_scene_date )) is null
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.archive_date ))
              OR
                (DATE(care_request_flat.archive_date )) is NULL
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.most_recent_eta_start ))
              OR
                (DATE(care_request_flat.most_recent_eta_start )) is null
              )
      ) and not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      ))
      )) or (lower(care_request_flat.archive_comment) like '%book%' and not (lower(care_request_flat.archive_comment) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(care_request_flat.archive_comment) not like '%capability%'))  THEN  (case when ( lower(care_request_flat.archive_comment) like '%book%' and not (lower(care_request_flat.archive_comment) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(care_request_flat.archive_comment) not like '%capability%') ) then .7 else 1 end)::float   ELSE NULL END
      ,0)*(1000000*1.0)) AS DECIMAL(65,0))) + ('x' || MD5(CASE WHEN  ((DATE(care_request_flat.accept_date )) IS NOT NULL) or (((((not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      )) and lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) like '%acute%'
               AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.on_scene_date ))
                OR
               (DATE(care_request_flat.on_scene_date )) is null
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.archive_date ))
              OR
                (DATE(care_request_flat.archive_date )) is NULL
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.most_recent_eta_start ))
              OR
                (DATE(care_request_flat.most_recent_eta_start )) is null
              )
      ) and not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      ))
      )) or (lower(care_request_flat.archive_comment) like '%book%' and not (lower(care_request_flat.archive_comment) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(care_request_flat.archive_comment) not like '%capability%'))  THEN  care_request_flat.care_request_id   ELSE NULL END
      ::varchar))::bit(64)::bigint::DECIMAL(65,0)  *18446744073709551616 + ('x' || SUBSTR(MD5(CASE WHEN  ((DATE(care_request_flat.accept_date )) IS NOT NULL) or (((((not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      )) and lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) like '%acute%'
               AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.on_scene_date ))
                OR
               (DATE(care_request_flat.on_scene_date )) is null
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.archive_date ))
              OR
                (DATE(care_request_flat.archive_date )) is NULL
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.most_recent_eta_start ))
              OR
                (DATE(care_request_flat.most_recent_eta_start )) is null
              )
      ) and not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      ))
      )) or (lower(care_request_flat.archive_comment) like '%book%' and not (lower(care_request_flat.archive_comment) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(care_request_flat.archive_comment) not like '%capability%'))  THEN  care_request_flat.care_request_id   ELSE NULL END
      ::varchar),17))::bit(64)::bigint::DECIMAL(65,0) ) - SUM(DISTINCT ('x' || MD5(CASE WHEN  ((DATE(care_request_flat.accept_date )) IS NOT NULL) or (((((not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      )) and lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) like '%acute%'
               AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.on_scene_date ))
                OR
               (DATE(care_request_flat.on_scene_date )) is null
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.archive_date ))
              OR
                (DATE(care_request_flat.archive_date )) is NULL
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.most_recent_eta_start ))
              OR
                (DATE(care_request_flat.most_recent_eta_start )) is null
              )
      ) and not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      ))
      )) or (lower(care_request_flat.archive_comment) like '%book%' and not (lower(care_request_flat.archive_comment) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(care_request_flat.archive_comment) not like '%capability%'))  THEN  care_request_flat.care_request_id   ELSE NULL END
      ::varchar))::bit(64)::bigint::DECIMAL(65,0)  *18446744073709551616 + ('x' || SUBSTR(MD5(CASE WHEN  ((DATE(care_request_flat.accept_date )) IS NOT NULL) or (((((not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      )) and lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) like '%acute%'
               AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.on_scene_date ))
                OR
               (DATE(care_request_flat.on_scene_date )) is null
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.archive_date ))
              OR
                (DATE(care_request_flat.archive_date )) is NULL
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.most_recent_eta_start ))
              OR
                (DATE(care_request_flat.most_recent_eta_start )) is null
              )
      ) and not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      ))
      )) or (lower(care_request_flat.archive_comment) like '%book%' and not (lower(care_request_flat.archive_comment) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(care_request_flat.archive_comment) not like '%capability%'))  THEN  care_request_flat.care_request_id   ELSE NULL END
      ::varchar),17))::bit(64)::bigint::DECIMAL(65,0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0) AS "care_request_flat.accepted_or_scheduled_count",
          COUNT(DISTINCT CASE WHEN (DATE(care_request_flat.complete_date )) is not null AND
            ((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END) IS NULL OR
            UPPER(care_request_flat.complete_comment) LIKE '%REFERRED - POINT OF CARE%' OR
            UPPER((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END)) = 'REFERRED - POINT OF CARE')  THEN care_request_flat.care_request_id  ELSE NULL END) AS "care_request_flat.complete_count",
          (COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  ( coalesce((genesys_conversation_summary."totalagentholdduration"),0)+coalesce((genesys_conversation_summary."totalagenttalkduration"),0)+coalesce((genesys_conversation_summary."totalagentwrapupduration"),0) )::float/1000/60   ELSE NULL END
      ,0)*(1000000*1.0)) AS DECIMAL(65,0))) + ('x' || MD5(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END
      ::varchar))::bit(64)::bigint::DECIMAL(65,0)  *18446744073709551616 + ('x' || SUBSTR(MD5(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END
      ::varchar),17))::bit(64)::bigint::DECIMAL(65,0) ) - SUM(DISTINCT ('x' || MD5(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END
      ::varchar))::bit(64)::bigint::DECIMAL(65,0)  *18446744073709551616 + ('x' || SUBSTR(MD5(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END
      ::varchar),17))::bit(64)::bigint::DECIMAL(65,0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0) / NULLIF(COUNT(DISTINCT CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (((genesys_conversation_summary."direction") = 'inbound'))  AND  ( coalesce((genesys_conversation_summary."totalagentholdduration"),0)+coalesce((genesys_conversation_summary."totalagenttalkduration"),0)+coalesce((genesys_conversation_summary."totalagentwrapupduration"),0) )::float/1000/60   IS NOT NULL THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END), 0)) AS "genesys_conversation_summary.average_handle_time",
          (COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (care_request_flat.care_request_id is not null) AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  ( coalesce((genesys_conversation_summary."totalagentholdduration"),0)+coalesce((genesys_conversation_summary."totalagenttalkduration"),0)+coalesce((genesys_conversation_summary."totalagentwrapupduration"),0) )::float/1000/60   ELSE NULL END
      ,0)*(1000000*1.0)) AS DECIMAL(65,0))) + ('x' || MD5(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (care_request_flat.care_request_id is not null) AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END
      ::varchar))::bit(64)::bigint::DECIMAL(65,0)  *18446744073709551616 + ('x' || SUBSTR(MD5(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (care_request_flat.care_request_id is not null) AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END
      ::varchar),17))::bit(64)::bigint::DECIMAL(65,0) ) - SUM(DISTINCT ('x' || MD5(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (care_request_flat.care_request_id is not null) AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END
      ::varchar))::bit(64)::bigint::DECIMAL(65,0)  *18446744073709551616 + ('x' || SUBSTR(MD5(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (care_request_flat.care_request_id is not null) AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END
      ::varchar),17))::bit(64)::bigint::DECIMAL(65,0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0) / NULLIF(COUNT(DISTINCT CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (care_request_flat.care_request_id is not null) AND (((genesys_conversation_summary."direction") = 'inbound'))  AND  ( coalesce((genesys_conversation_summary."totalagentholdduration"),0)+coalesce((genesys_conversation_summary."totalagenttalkduration"),0)+coalesce((genesys_conversation_summary."totalagentwrapupduration"),0) )::float/1000/60   IS NOT NULL THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END), 0)) AS "gcs.average_handle_time_care_request_created",
          (COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (((DATE(care_request_flat.complete_date )) is not null AND
            ((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END) IS NULL OR
            UPPER(care_request_flat.complete_comment) LIKE '%REFERRED - POINT OF CARE%' OR
            UPPER((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END)) = 'REFERRED - POINT OF CARE'))) AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  ( coalesce((genesys_conversation_summary."totalagentholdduration"),0)+coalesce((genesys_conversation_summary."totalagenttalkduration"),0)+coalesce((genesys_conversation_summary."totalagentwrapupduration"),0) )::float/1000/60   ELSE NULL END
      ,0)*(1000000*1.0)) AS DECIMAL(65,0))) + ('x' || MD5(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (((DATE(care_request_flat.complete_date )) is not null AND
            ((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END) IS NULL OR
            UPPER(care_request_flat.complete_comment) LIKE '%REFERRED - POINT OF CARE%' OR
            UPPER((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END)) = 'REFERRED - POINT OF CARE'))) AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END
      ::varchar))::bit(64)::bigint::DECIMAL(65,0)  *18446744073709551616 + ('x' || SUBSTR(MD5(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (((DATE(care_request_flat.complete_date )) is not null AND
            ((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END) IS NULL OR
            UPPER(care_request_flat.complete_comment) LIKE '%REFERRED - POINT OF CARE%' OR
            UPPER((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END)) = 'REFERRED - POINT OF CARE'))) AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END
      ::varchar),17))::bit(64)::bigint::DECIMAL(65,0) ) - SUM(DISTINCT ('x' || MD5(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (((DATE(care_request_flat.complete_date )) is not null AND
            ((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END) IS NULL OR
            UPPER(care_request_flat.complete_comment) LIKE '%REFERRED - POINT OF CARE%' OR
            UPPER((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END)) = 'REFERRED - POINT OF CARE'))) AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END
      ::varchar))::bit(64)::bigint::DECIMAL(65,0)  *18446744073709551616 + ('x' || SUBSTR(MD5(CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (((DATE(care_request_flat.complete_date )) is not null AND
            ((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END) IS NULL OR
            UPPER(care_request_flat.complete_comment) LIKE '%REFERRED - POINT OF CARE%' OR
            UPPER((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END)) = 'REFERRED - POINT OF CARE'))) AND (((genesys_conversation_summary."direction") = 'inbound'))  THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END
      ::varchar),17))::bit(64)::bigint::DECIMAL(65,0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0) / NULLIF(COUNT(DISTINCT CASE WHEN  ((case when (genesys_conversation_summary."totalagenttalkduration") >0 or  genesys_conversation_summary."answered" >0 then 1 else 0 end  = 1)) AND ((genesys_conversation_summary."queuename")!='None') AND (((DATE(care_request_flat.complete_date )) is not null AND
            ((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END) IS NULL OR
            UPPER(care_request_flat.complete_comment) LIKE '%REFERRED - POINT OF CARE%' OR
            UPPER((CASE
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'CANCELLED BY PATIENT'  THEN 'Cancelled by Patient or Partner'
              WHEN UPPER(trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))) LIKE 'REFERRED VIA PHONE' THEN 'Referred - Phone Triage'
              ELSE  trim(split_part((coalesce(care_request_flat.complete_comment, care_request_flat.archive_comment)), ':', 1))
              END)) = 'REFERRED - POINT OF CARE'))) AND (((genesys_conversation_summary."direction") = 'inbound'))  AND  ( coalesce((genesys_conversation_summary."totalagentholdduration"),0)+coalesce((genesys_conversation_summary."totalagenttalkduration"),0)+coalesce((genesys_conversation_summary."totalagentwrapupduration"),0) )::float/1000/60   IS NOT NULL THEN  concat(( genesys_conversation_summary."conversationid"  ), ( genesys_conversation_summary."queuename"  ))  ELSE NULL END), 0)) AS "gcs.average_handle_time_complete_care_request",
          ROUND(CAST((SELECT AVG((a / 1000000000000000000000000000000000000000000000)::float) FROM UNNEST((ARRAY(SELECT UNNEST(ARRAY_AGG(DISTINCT ((CASE WHEN ((genesys_conversation_summary."queuename")!='None') AND ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') is not null) THEN ((EXTRACT(EPOCH FROM ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') - (genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC')))-(genesys_conversation_summary."firstacdwaitduration")/1000)/60)  ELSE NULL END::DECIMAL(59, 6) * 1000000)::DECIMAL(65,0) * 1000000000000000000000000000000000000000::DECIMAL(65, 0) + ('x' || MD5(concat((genesys_conversation_summary."conversationid"), care_request_flat.care_request_id) ::varchar))::bit(64)::bigint::DECIMAL(65,0)  *18446744073709551616 + ('x' || SUBSTR(MD5(concat((genesys_conversation_summary."conversationid"), care_request_flat.care_request_id) ::varchar),17))::bit(64)::bigint::DECIMAL(65,0)))) ORDER BY 1))[(SELECT CAST(FLOOR(COUNT(DISTINCT CASE WHEN CASE WHEN ((genesys_conversation_summary."queuename")!='None') AND ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') is not null) THEN ((EXTRACT(EPOCH FROM ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') - (genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC')))-(genesys_conversation_summary."firstacdwaitduration")/1000)/60)  ELSE NULL END IS NULL THEN NULL ELSE concat((genesys_conversation_summary."conversationid"), care_request_flat.care_request_id)  END) * 0.5 - 0.0000001) AS INTEGER) + 1):(SELECT CAST(FLOOR(COUNT(DISTINCT CASE WHEN CASE WHEN ((genesys_conversation_summary."queuename")!='None') AND ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') is not null) THEN ((EXTRACT(EPOCH FROM ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') - (genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC')))-(genesys_conversation_summary."firstacdwaitduration")/1000)/60)  ELSE NULL END IS NULL THEN NULL ELSE concat((genesys_conversation_summary."conversationid"), care_request_flat.care_request_id)  END) * 0.5) AS INTEGER) + 1)]) a) AS NUMERIC), 6) AS "genesys_conversation_summary.median_onboard_delay",
          (COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN  ((genesys_conversation_summary."queuename")!='None') AND ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') is not null)  THEN  ( (EXTRACT(EPOCH FROM ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') - (genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC')))-(genesys_conversation_summary."firstacdwaitduration")/1000)/60 )   ELSE NULL END
      ,0)*(1000000*1.0)) AS DECIMAL(65,0))) + ('x' || MD5(CASE WHEN  ((genesys_conversation_summary."queuename")!='None') AND ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') is not null)  THEN  concat(( genesys_conversation_summary."conversationid"  ),  care_request_flat.care_request_id  )   ELSE NULL END
      ::varchar))::bit(64)::bigint::DECIMAL(65,0)  *18446744073709551616 + ('x' || SUBSTR(MD5(CASE WHEN  ((genesys_conversation_summary."queuename")!='None') AND ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') is not null)  THEN  concat(( genesys_conversation_summary."conversationid"  ),  care_request_flat.care_request_id  )   ELSE NULL END
      ::varchar),17))::bit(64)::bigint::DECIMAL(65,0) ) - SUM(DISTINCT ('x' || MD5(CASE WHEN  ((genesys_conversation_summary."queuename")!='None') AND ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') is not null)  THEN  concat(( genesys_conversation_summary."conversationid"  ),  care_request_flat.care_request_id  )   ELSE NULL END
      ::varchar))::bit(64)::bigint::DECIMAL(65,0)  *18446744073709551616 + ('x' || SUBSTR(MD5(CASE WHEN  ((genesys_conversation_summary."queuename")!='None') AND ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') is not null)  THEN  concat(( genesys_conversation_summary."conversationid"  ),  care_request_flat.care_request_id  )   ELSE NULL END
      ::varchar),17))::bit(64)::bigint::DECIMAL(65,0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0) / NULLIF(COUNT(DISTINCT CASE WHEN  ((genesys_conversation_summary."queuename")!='None') AND ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') is not null)  AND  ( (EXTRACT(EPOCH FROM ((care_request_flat.accept_date_initial AT TIME ZONE care_request_flat.pg_tz AT TIME ZONE 'US/Mountain') - (genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC')))-(genesys_conversation_summary."firstacdwaitduration")/1000)/60 )   IS NOT NULL THEN  concat(( genesys_conversation_summary."conversationid"  ),  care_request_flat.care_request_id  )   ELSE NULL END), 0)) AS "genesys_conversation_summary.average_onboard_delay",
          ( COUNT(DISTINCT care_request_flat.care_request_id ) )::float/(nullif( COUNT(DISTINCT CASE WHEN (((genesys_conversation_summary."mediatype")='voice' and trim(lower((genesys_conversation_summary."queuename"))) not like '%outbound%' and trim(lower((genesys_conversation_summary."queuename"))) not like '%after hours%' and trim(lower((genesys_conversation_summary."queuename"))) not like '%optimizer%' and trim(lower((genesys_conversation_summary."queuename"))) not in('mobile requests','ma', 'rcm / billing', 'backline', 'development', 'secondary screening', 'dispatchhealth help desk', 'dispatch health nurse line', 'zzavtextest', 'pay bill', 'testing', 'initial follow up', 'rn1', 'rn2', 'rn3', 'rn4', 'rn5', 'rn6', 'rn7', 'rn8', 'rn9', 'ivr fail safe', 'covid testing results', 'ebony testing', 'ma/nurse', 'dispatchhealth help desk vendor', 'do not use ma/nurse', 'sem vip', 'covid task force', 'covid pierce county mass testing', 'acute care covid results & care request', 'phx', 'mobile request callbacks', 'click to call', 'dialer results', 'cancels', 'care team escalations', 'rn10', 'advance care fax queue', 'rn11', 'rn12', 'rn13','rn14', 'vip help line', 'kaiser ma email', 'care web chat lab results', 'zztest_delete', 'none', 'care web chat covid', 'care web chat', 'advanced care', 'talent acquisition', 'rn15', 'rn16', 'rn17', 'rn18', 'sykes cancels','sykes ma','ppx billing','ppx workflow')) and (markets.id is not null)) AND ((genesys_conversation_summary."totalagenttalkduration") >60000) AND ((genesys_conversation_summary."queuename")!='None') THEN concat((case when  (genesys_conversation_summary."direction") ='inbound' then (genesys_conversation_summary."ani")
                    when (genesys_conversation_summary."direction") = 'outbound' then (case when  (genesys_conversation_summary."direction") ='inbound' then genesys_conversation_summary."dnis"
                    when (genesys_conversation_summary."direction") = 'outbound' then  inbound_not_answered_or_abandoned.dnis
                    else null end)
                    else null end), (CAST(EXTRACT(HOUR FROM genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC') AS INT)), (DATE(genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC'))) ELSE NULL END) ,0))::float  AS "genesys_conversation_summary.care_request_created_rate",
          COALESCE(COALESCE(CAST( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN ((DATE(care_request_flat.accept_date )) IS NOT NULL) or (((((not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      )) and lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) like '%acute%'
               AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.on_scene_date ))
                OR
               (DATE(care_request_flat.on_scene_date )) is null
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.archive_date ))
              OR
                (DATE(care_request_flat.archive_date )) is NULL
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.most_recent_eta_start ))
              OR
                (DATE(care_request_flat.most_recent_eta_start )) is null
              )
      ) and not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      ))
      )) or (lower(care_request_flat.archive_comment) like '%book%' and not (lower(care_request_flat.archive_comment) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(care_request_flat.archive_comment) not like '%capability%')) THEN (case when (lower(care_request_flat.archive_comment) like '%book%' and not (lower(care_request_flat.archive_comment) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(care_request_flat.archive_comment) not like '%capability%')) then .7 else 1 end)::float  ELSE NULL END
      ,0)*(1000000*1.0)) AS DECIMAL(65,0))) + ('x' || MD5(CASE WHEN ((DATE(care_request_flat.accept_date )) IS NOT NULL) or (((((not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      )) and lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) like '%acute%'
               AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.on_scene_date ))
                OR
               (DATE(care_request_flat.on_scene_date )) is null
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.archive_date ))
              OR
                (DATE(care_request_flat.archive_date )) is NULL
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.most_recent_eta_start ))
              OR
                (DATE(care_request_flat.most_recent_eta_start )) is null
              )
      ) and not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      ))
      )) or (lower(care_request_flat.archive_comment) like '%book%' and not (lower(care_request_flat.archive_comment) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(care_request_flat.archive_comment) not like '%capability%')) THEN care_request_flat.care_request_id  ELSE NULL END
      ::varchar))::bit(64)::bigint::DECIMAL(65,0)  *18446744073709551616 + ('x' || SUBSTR(MD5(CASE WHEN ((DATE(care_request_flat.accept_date )) IS NOT NULL) or (((((not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      )) and lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) like '%acute%'
               AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.on_scene_date ))
                OR
               (DATE(care_request_flat.on_scene_date )) is null
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.archive_date ))
              OR
                (DATE(care_request_flat.archive_date )) is NULL
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.most_recent_eta_start ))
              OR
                (DATE(care_request_flat.most_recent_eta_start )) is null
              )
      ) and not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      ))
      )) or (lower(care_request_flat.archive_comment) like '%book%' and not (lower(care_request_flat.archive_comment) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(care_request_flat.archive_comment) not like '%capability%')) THEN care_request_flat.care_request_id  ELSE NULL END
      ::varchar),17))::bit(64)::bigint::DECIMAL(65,0) ) - SUM(DISTINCT ('x' || MD5(CASE WHEN ((DATE(care_request_flat.accept_date )) IS NOT NULL) or (((((not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      )) and lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) like '%acute%'
               AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.on_scene_date ))
                OR
               (DATE(care_request_flat.on_scene_date )) is null
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.archive_date ))
              OR
                (DATE(care_request_flat.archive_date )) is NULL
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.most_recent_eta_start ))
              OR
                (DATE(care_request_flat.most_recent_eta_start )) is null
              )
      ) and not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      ))
      )) or (lower(care_request_flat.archive_comment) like '%book%' and not (lower(care_request_flat.archive_comment) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(care_request_flat.archive_comment) not like '%capability%')) THEN care_request_flat.care_request_id  ELSE NULL END
      ::varchar))::bit(64)::bigint::DECIMAL(65,0)  *18446744073709551616 + ('x' || SUBSTR(MD5(CASE WHEN ((DATE(care_request_flat.accept_date )) IS NOT NULL) or (((((not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      )) and lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) like '%acute%'
               AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.on_scene_date ))
                OR
               (DATE(care_request_flat.on_scene_date )) is null
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.archive_date ))
              OR
                (DATE(care_request_flat.archive_date )) is NULL
              )
              AND
              (
                (DATE(care_request_flat.created_date )) != (DATE(care_request_flat.most_recent_eta_start ))
              OR
                (DATE(care_request_flat.most_recent_eta_start )) is null
              )
      ) and not (((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' OR

                lower((CASE
                 WHEN lower(TRIM(BOTH ' ' FROM service_lines.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
                 WHEN service_lines.name LIKE '%Post Acute Follow Up%' THEN service_lines.name
                 WHEN (trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(pafu|post acute|post-acute)%' OR
                     lower((CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END)) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
                 ELSE TRIM(BOTH ' ' FROM service_lines.name)
                 END
      )) LIKE 'post acute follow up%'
      ) or ((trim(lower(care_requests.chief_complaint))) SIMILAR TO '%(dhfu|dh followup|dh follow up|dh follow-up|dh f/u|dispatchhealth followup|dispatchhealth follow up|dispatchhealth follow-up)%' OR
                (CASE
            WHEN risk_assessments.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
            WHEN risk_assessments.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
            WHEN risk_assessments.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
            ELSE INITCAP(split_part(lower(risk_assessments.protocol_name),' (non covid-19)',1))
          END) SIMILAR TO 'Dispatchhealth Acute Care - Follow Up Visit%')
      ))
      )) or (lower(care_request_flat.archive_comment) like '%book%' and not (lower(care_request_flat.archive_comment) SIMILAR TO '%( cap|medicaid|tricare)%'  and lower(care_request_flat.archive_comment) not like '%capability%')) THEN care_request_flat.care_request_id  ELSE NULL END
      ::varchar),17))::bit(64)::bigint::DECIMAL(65,0)) )  AS DOUBLE PRECISION) / CAST((1000000*1.0) AS DOUBLE PRECISION), 0), 0) ::float/(nullif( COUNT(DISTINCT CASE WHEN (((genesys_conversation_summary."mediatype")='voice' and trim(lower((genesys_conversation_summary."queuename"))) not like '%outbound%' and trim(lower((genesys_conversation_summary."queuename"))) not like '%after hours%' and trim(lower((genesys_conversation_summary."queuename"))) not like '%optimizer%' and trim(lower((genesys_conversation_summary."queuename"))) not in('mobile requests','ma', 'rcm / billing', 'backline', 'development', 'secondary screening', 'dispatchhealth help desk', 'dispatch health nurse line', 'zzavtextest', 'pay bill', 'testing', 'initial follow up', 'rn1', 'rn2', 'rn3', 'rn4', 'rn5', 'rn6', 'rn7', 'rn8', 'rn9', 'ivr fail safe', 'covid testing results', 'ebony testing', 'ma/nurse', 'dispatchhealth help desk vendor', 'do not use ma/nurse', 'sem vip', 'covid task force', 'covid pierce county mass testing', 'acute care covid results & care request', 'phx', 'mobile request callbacks', 'click to call', 'dialer results', 'cancels', 'care team escalations', 'rn10', 'advance care fax queue', 'rn11', 'rn12', 'rn13','rn14', 'vip help line', 'kaiser ma email', 'care web chat lab results', 'zztest_delete', 'none', 'care web chat covid', 'care web chat', 'advanced care', 'talent acquisition', 'rn15', 'rn16', 'rn17', 'rn18', 'sykes cancels','sykes ma','ppx billing','ppx workflow')) and (markets.id is not null)) AND ((genesys_conversation_summary."totalagenttalkduration") >60000) AND ((genesys_conversation_summary."queuename")!='None') THEN concat((case when  (genesys_conversation_summary."direction") ='inbound' then (genesys_conversation_summary."ani")
                    when (genesys_conversation_summary."direction") = 'outbound' then (case when  (genesys_conversation_summary."direction") ='inbound' then genesys_conversation_summary."dnis"
                    when (genesys_conversation_summary."direction") = 'outbound' then  inbound_not_answered_or_abandoned.dnis
                    else null end)
                    else null end), (CAST(EXTRACT(HOUR FROM genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC') AS INT)), (DATE(genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC'))) ELSE NULL END) ,0))::float  AS "genesys_conversation_summary.qualified_rate"
      FROM looker_scratch.genesys_conversation_summary  AS genesys_conversation_summary
      LEFT JOIN looker_scratch.LR$7NKF21624921228076_inbound_not_answered_or_abandoned AS inbound_not_answered_or_abandoned ON (genesys_conversation_summary."conversationid")=inbound_not_answered_or_abandoned.conversationid
      LEFT JOIN looker_scratch.number_to_market  AS number_to_market ON ((number_to_market."number")=(case when  (genesys_conversation_summary."direction") ='inbound' then genesys_conversation_summary."dnis"
                    when (genesys_conversation_summary."direction") = 'outbound' then  inbound_not_answered_or_abandoned.dnis
                    else null end))
      LEFT JOIN looker_scratch.genesys_conversation_wrapup  AS genesys_conversation_wrapup ON (genesys_conversation_summary."conversationid")=(genesys_conversation_wrapup."conversationid") and (genesys_conversation_wrapup."queuename")=(genesys_conversation_summary."queuename")
           and (genesys_conversation_wrapup."purpose")='agent'
      LEFT JOIN public.markets  AS markets ON (markets.id=(case when (number_to_market."market_id") is not null then  (number_to_market."market_id")
           when trim(lower((genesys_conversation_summary."queuename"))) in ('las pafu callback') then 162
          when trim(lower((genesys_conversation_summary."queuename"))) in ('tac pafu callback') then 170
          when trim(lower((genesys_conversation_summary."queuename"))) in ('phx pafu callback', 'phx') then 161
          when trim(lower((genesys_conversation_summary."queuename"))) in ('hrt care') then 186
           when trim(lower((genesys_conversation_summary."queuename"))) in ('boi regence') then 176
          when trim(lower((genesys_conversation_summary."queuename"))) in ('atl optum care') then 177
          when trim(lower((genesys_conversation_summary."queuename"))) in ('spo regence','spo post acute') then 173
           when trim(lower((genesys_conversation_summary."queuename"))) in ('dfw home health dallas') then 169
           when trim(lower((genesys_conversation_summary."queuename"))) in ('den php', 'kaiser') then 159
          when trim(lower((genesys_conversation_summary."queuename"))) in ('rno post acute') then 179
          when trim(lower((genesys_conversation_summary."queuename"))) in ('sea regence') then 174
           when trim(lower((genesys_conversation_summary."queuename"))) in ('por regence', 'por legacy health charity care') then 175
           when trim(lower((genesys_conversation_summary."queuename"))) in ('fort worth home health') then 178
           when (genesys_conversation_summary."direction") = 'outbound' and trim(lower((genesys_conversation_summary."queuename"))) in ('general care', 'partner direct', 'pafu callback', 'sweeper callback', 'dtc', 'dtc pilot', 'care web chat', 'aoc premier', 'sms dcm campaign', 'national pafu callback', 'uhc partner direct', 'humana partner direct') then 167


          else null end))
      LEFT JOIN looker_scratch.LR$7N5IA1624874904300_care_request_flat AS care_request_flat ON (genesys_conversation_summary."conversationid") =care_request_flat.contact_id
      LEFT JOIN public.care_requests  AS care_requests ON care_request_flat.care_request_id = care_requests.id
      LEFT JOIN public.risk_assessments  AS risk_assessments ON care_request_flat.care_request_id = risk_assessments.care_request_id
      LEFT JOIN public.service_lines  AS service_lines ON care_requests.service_line_id =service_lines.id
      WHERE ((( genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC' ) >= ((SELECT (DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-2 || ' month')::INTERVAL))) AND ( genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC' ) < ((SELECT ((DATE_TRUNC('month', DATE_TRUNC('day', CURRENT_TIMESTAMP AT TIME ZONE 'America/Denver')) + (-2 || ' month')::INTERVAL) + (3 || ' month')::INTERVAL))))) AND ((case when (genesys_conversation_summary."queuename") in('TIER 1', 'TIER 2', 'Sykes General Care', 'General Care') then 'General Care'
            when (genesys_conversation_summary."queuename") in('Partner Direct', 'ATL Optum Care', 'LAS RCC', 'Humana Partner Direct', 'BOI Regence', 'POR Regence', 'SEA Regence', 'SPO Regence', 'Sykes Partner Care', 'Partner Care') then 'Partner Direct (Broad)'
            when (genesys_conversation_summary."queuename") in('DEN LAS SEM VIP', 'DTC Pilot') then 'DTC Pilot'
          else (genesys_conversation_summary."queuename")  end ) = 'General Care' OR (case when (genesys_conversation_summary."queuename") in('TIER 1', 'TIER 2', 'Sykes General Care', 'General Care') then 'General Care'
            when (genesys_conversation_summary."queuename") in('Partner Direct', 'ATL Optum Care', 'LAS RCC', 'Humana Partner Direct', 'BOI Regence', 'POR Regence', 'SEA Regence', 'SPO Regence', 'Sykes Partner Care', 'Partner Care') then 'Partner Direct (Broad)'
            when (genesys_conversation_summary."queuename") in('DEN LAS SEM VIP', 'DTC Pilot') then 'DTC Pilot'
          else (genesys_conversation_summary."queuename")  end ) = 'Partner Direct (Broad)' OR (case when (genesys_conversation_summary."queuename") in('TIER 1', 'TIER 2', 'Sykes General Care', 'General Care') then 'General Care'
            when (genesys_conversation_summary."queuename") in('Partner Direct', 'ATL Optum Care', 'LAS RCC', 'Humana Partner Direct', 'BOI Regence', 'POR Regence', 'SEA Regence', 'SPO Regence', 'Sykes Partner Care', 'Partner Care') then 'Partner Direct (Broad)'
            when (genesys_conversation_summary."queuename") in('DEN LAS SEM VIP', 'DTC Pilot') then 'DTC Pilot'
          else (genesys_conversation_summary."queuename")  end ) = 'DTC Pilot') AND ((genesys_conversation_summary."conversationid") not in('c7673a97-04df-4d22-af20-8dbed34ddb10', '915f11ff-17ab-4491-9cf0-ab44422fefbd', '96017792-9b4e-461b-8e47-4c0f7f92ba19', 'd3a1d1f5-95fe-4515-9d7a-591176877575', '9ffb7c0b-065a-4a34-b2fc-bb2d0fc67c89', '461d7648-e167-4ac5-af63-1d8bdb12329d', '13cdebf6-ceef-4d3c-9c34-471084666602', 'e507a389-53da-4861-a2a5-b7b080a067c1') )
      GROUP BY
          (DATE_TRUNC('week', genesys_conversation_summary."conversationstarttime" AT TIME ZONE 'UTC')),
          1
      ORDER BY
          3 DESC
       ;;
  }

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}."genesys_conversation_wrapup.username" , ' ', ${TABLE}."genesys_conversation_summary.conversationstarttime_week") ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  measure: avg_care_requests_per_ca {
    type: average
    description: "Average Care Requests per Care Ambassador"
    sql: ${TABLE}."care_request_flat.care_request_count" ;;
    value_format: "0.0"

  }

  dimension: genesys_conversation_wrapup_username {
    type: string
    sql: ${TABLE}."genesys_conversation_wrapup.username" ;;
  }

  dimension: genesys_conversation_summary_conversationstarttime_week {
    type: string
    sql: ${TABLE}."genesys_conversation_summary.conversationstarttime_week" ;;
  }

  dimension: genesys_conversation_summary_count_answered_total {
    type: number
    sql: ${TABLE}."genesys_conversation_summary.count_answered_total" ;;
  }

  dimension: genesys_conversation_summary_distinct_answer_long_callers {
    type: number
    sql: ${TABLE}."genesys_conversation_summary.distinct_answer_long_callers" ;;
  }

  dimension: care_request_flat_care_request_count {
    type: number
    sql: ${TABLE}."care_request_flat.care_request_count" ;;
  }

  dimension: care_request_flat_accepted_or_scheduled_count {
    type: number
    sql: ${TABLE}."care_request_flat.accepted_or_scheduled_count" ;;
  }

  dimension: care_request_flat_complete_count {
    type: number
    sql: ${TABLE}."care_request_flat.complete_count" ;;
  }

  dimension: genesys_conversation_summary_average_handle_time {
    type: number
    sql: ${TABLE}."genesys_conversation_summary.average_handle_time" ;;
  }

  dimension: gcs_average_handle_time_care_request_created {
    type: number
    sql: ${TABLE}."gcs.average_handle_time_care_request_created" ;;
  }

  dimension: gcs_average_handle_time_complete_care_request {
    type: number
    sql: ${TABLE}."gcs.average_handle_time_complete_care_request" ;;
  }

  dimension: genesys_conversation_summary_median_onboard_delay {
    type: number
    sql: ${TABLE}."genesys_conversation_summary.median_onboard_delay" ;;
  }

  dimension: genesys_conversation_summary_average_onboard_delay {
    type: number
    sql: ${TABLE}."genesys_conversation_summary.average_onboard_delay" ;;
  }

  dimension: genesys_conversation_summary_care_request_created_rate {
    type: number
    sql: ${TABLE}."genesys_conversation_summary.care_request_created_rate" ;;
  }

  dimension: genesys_conversation_summary_qualified_rate {
    type: number
    sql: ${TABLE}."genesys_conversation_summary.qualified_rate" ;;
  }

  set: detail {
    fields: [
      genesys_conversation_wrapup_username,
      genesys_conversation_summary_conversationstarttime_week,
      genesys_conversation_summary_count_answered_total,
      genesys_conversation_summary_distinct_answer_long_callers,
      care_request_flat_care_request_count,
      care_request_flat_accepted_or_scheduled_count,
      care_request_flat_complete_count,
      genesys_conversation_summary_average_handle_time,
      gcs_average_handle_time_care_request_created,
      gcs_average_handle_time_complete_care_request,
      genesys_conversation_summary_median_onboard_delay,
      genesys_conversation_summary_average_onboard_delay,
      genesys_conversation_summary_care_request_created_rate,
      genesys_conversation_summary_qualified_rate
    ]
  }
}
