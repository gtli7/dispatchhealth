view: service_lines {
  sql_table_name: public.service_lines ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: existing_pt_appointment_type {
    type: string
    sql: ${TABLE}.existing_patient_appointment_type ->> 'name';;
  }

  dimension: followup_14_30_day {
    type: yesno
    sql: ${TABLE}.followup_14_30_day ;;
  }

  dimension: followup_3_day {
    type: yesno
    sql: ${TABLE}.followup_3_day ;;
  }

  dimension: is_911 {
    type: yesno
    sql: ${TABLE}.is_911 ;;
  }

  # dimension: name {
  #   type: string
  #   sql: CASE
  #     WHEN lower(TRIM(BOTH ' ' FROM ${TABLE}.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
  #     ELSE TRIM(BOTH ' ' FROM ${TABLE}.name)
  #     END;;
  # }

  dimension: name {
    type: string
    sql: CASE
           WHEN lower(TRIM(BOTH ' ' FROM ${TABLE}.name)) in('tele-presentation', 'do not use -- old telepres') THEN 'Tele-Presentation'
           WHEN ${TABLE}.name LIKE '%Post Acute Follow Up%' THEN ${TABLE}.name
           WHEN ${care_requests.chief_complaint_trimmed} SIMILAR TO '%(pafu|post acute|post-acute)%' OR
               lower(${risk_assessments.protocol_name}) LIKE 'post-acute patient%' THEN 'Post Acute Follow up'
           ELSE TRIM(BOTH ' ' FROM ${TABLE}.name)
           END;;
  }

#   dimension: service_line_name_consolidated {
#     description: "Similar Service Line categories combined. In addition, request type / channel is considered for '911 Service' and 'Advanced Care' is considered 'Acute Care'"
#     type:  string
#     sql:  CASE
#       WHEN ${care_requests.request_type} = 'manual_911' OR lower(${name}) = '911 service' THEN '911 Service'
#       WHEN lower(${name}) in('acute care', 'acute care (non covid-19)','acute care (hpn)', 'acute care (senior living)', 'asthma education', 'advanced care', 'acute care (hpn- case management initiated)') THEN 'Acute Care'
#       WHEN lower(${name}) in('post acute follow up', 'post acute follow up (hpn)', 'post acute follow up (hpn- case management initiated)') THEN 'Post Acute Follow Up'
#       ELSE ${name}
#     END
# ;;

#     }

  dimension: service_line_name_consolidated {
    description: "Similar Service Line categories combined. In addition, request type / channel is considered for '911 Service' and 'Advanced Care' is considered 'Acute Care'"
    type:  string
    sql:  CASE
           WHEN lower(${name}) in('post acute follow up', 'post acute follow up (hpn)', 'post acute follow up (hpn- case management initiated)') THEN 'Bridge Care'
           WHEN ${care_requests.request_type} = 'manual_911' OR lower(${name}) = '911 service' OR
                (${channel_items.name} like '%Ems%' OR  ${channel_items.name} LIKE '%Fire%' OR  ${channel_items.name} like '%911%') THEN 'EMS Service'
           WHEN lower(${name}) in('acute care', 'acute care (non covid-19)','acute care (hpn)', 'acute care (senior living)', 'asthma education',  'acute care (hpn- case management initiated)') THEN 'Acute Care'
          WHEN lower(${name}) = 'covid-19 facility testing' THEN 'Mass Testing'
          ELSE ${name}
         END
      ;;

    }


  dimension: new_pt_appointment_type {
    type: string
    sql: ${TABLE}.new_patient_appointment_type ->> 'name';;
  }

  dimension: out_of_network_insurance {
    type: yesno
    sql: ${TABLE}.out_of_network_insurance ;;
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

  measure: count {
    type: count
    drill_fields: [id, name]
  }

  measure: tele_presentation_count {
    type: count_distinct
    sql: ${care_request_flat.care_request_id} ;;
    filters: {
      field: service_lines.name
      value: "Tele-Presentation"
    }
  }

  measure: virtual_visit_count {
    type: count_distinct
    sql: ${care_request_flat.care_request_id} ;;
    filters: {
      field: service_lines.name
      value: "Virtual Visit"
    }
  }
}
