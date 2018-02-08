view: channel_dimensions {
  sql_table_name: jasperdb.channel_dimensions ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    hidden: yes
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

  dimension: dashboard_channel_item_id {
    hidden: yes
    type: number
    sql: ${TABLE}.dashboard_channel_item_id ;;
  }

  dimension: main_type {
    type: string
    sql: ${TABLE}.main_type ;;
  }

  dimension: sub_type {
    label: "Subtype"
    type: string
    sql: ${TABLE}.sub_type ;;
  }

  dimension: organization {
    type: string
    sql: ${TABLE}.organization ;;
  }

  dimension: organization_label {
    type: string
    order_by_field: org_label_order
    sql: CASE WHEN ${subtotal_over.row_type_description} = '' THEN ${organization}
              ELSE 'Subtotal' END ;;
    html:{% if value == 'Subtotal' %}<b><i><span style="color: black;">Subtotal</span></i></b>{% else %} {{ linked_value }}{% endif %};;
  }

  dimension: org_label_order {
    type: string
    hidden: yes
    #For order by fields, use a similar calculation, but use values that correctly put nulls at min and subtotals at max of sort order positioning
    sql:  CASE WHEN ${organization_label} = ${organization} THEN ${sub_type}||${organization}
               ELSE ${sub_type}||'ZZZZZZZZ' END ;;
  }

  dimension: digital {
    type: yesno
    sql: ${organization} in('google or other search', 'social media (facebook, linkedin, twitter, instagram)', 'social media(facebook, linkedin, twitter, instagram)') ;;
  }

  dimension_group: updated {
    hidden: yes
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
    drill_fields: [id]
  }
}
