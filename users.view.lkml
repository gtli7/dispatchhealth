view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    value_format: "0"
    sql: ${TABLE}.id ;;
  }

  dimension: documentation_training_provider {
    type: yesno
    sql: ${id} IN (38670,47248,37554,45743,50085,54178,45829,22934,41281,40719,35561,53968,
                   47384,20172,42915,38958,28141,35175,42915,11376,58230,45337,36293,61509,
                   62304,61433,16387,27008,59851) ;;
  }

  dimension: authentication_token {
    type: string
    hidden: yes
    sql: ${TABLE}.authentication_token ;;
  }

  dimension_group: confirmation_sent {
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
    sql: ${TABLE}.confirmation_sent_at ;;
  }

  dimension: confirmation_token {
    type: string
    hidden: yes
    sql: ${TABLE}.confirmation_token ;;
  }

  dimension_group: confirmed {
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
    sql: ${TABLE}.confirmed_at ;;
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

  dimension_group: current_sign_in {
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
    sql: ${TABLE}.current_sign_in_at ;;
  }

  dimension: current_sign_in_ip {
    type: string
    hidden: yes
    sql: ${TABLE}.current_sign_in_ip ;;
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
    sql: ${TABLE}.deleted_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: encrypted_password {
    type: string
    hidden: yes
    sql: ${TABLE}.encrypted_password ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: csc_name {
    label: "Full Name"
    type: string
    sql: case when initcap(concat(trim(${first_name}), ' ', trim(${last_name}))) = ' ' then null else initcap(concat(trim(${first_name}), ' ', trim(${last_name}))) end;;
  }

  filter: provider_select {
    suggest_dimension: csc_name
  }

  dimension: provider_comparitor {
    type: string
    sql:
    CASE
      WHEN {% condition provider_select %} ${csc_name} {% endcondition %}
        THEN ${csc_name}
      ELSE ${id}::varchar
    END ;;

#     html:
#     {% if value == {{ _name }}%}
#     <font color="blue">{{ rendered_value }}</font>
#     {% endif %};;
  }

  dimension: selected_provider {
    type: string
    sql: {% parameter provider_select %} ;;
  }

  dimension: chart_scrubbing_name {
    type: string
    sql: CASE
          WHEN ${last_name} = 'Riddleberger' THEN 'Dashboard'
          ELSE ${first_name} || ' ' || ${last_name}
        END  ;;
  }

  dimension_group: last_sign_in {
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
    sql: ${TABLE}.last_sign_in_at ;;
  }

  dimension: last_sign_in_ip {
    type: string
    hidden: yes
    sql: ${TABLE}.last_sign_in_ip ;;
  }

  dimension: mobile_number {
    type: string
    sql: ${TABLE}.mobile_number ;;
  }

  dimension_group: remember_created {
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
    sql: ${TABLE}.remember_created_at ;;
  }

  dimension_group: reset_password_sent {
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
    sql: ${TABLE}.reset_password_sent_at ;;
  }

  dimension: reset_password_token {
    type: string
    hidden: yes
    sql: ${TABLE}.reset_password_token ;;
  }

  dimension: sign_in_count {
    type: number
    sql: ${TABLE}.sign_in_count ;;
  }

  dimension: in_contact_agent_id {
    type: number
    sql: ${TABLE}.in_contact_agent_id ;;
  }

  dimension: genesys_id {
    type: number
    sql: ${TABLE}.genesys_id ;;
  }

  dimension: genesys_token {
    type: number
    sql: ${TABLE}.genesys_token ;;
  }




  dimension: unconfirmed_email {
    type: string
    hidden: yes
    sql: ${TABLE}.unconfirmed_email ;;
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
    drill_fields: [id, first_name, last_name, user_roles.count]
  }
}
