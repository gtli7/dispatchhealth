view: tele_shifts_by_market {
  derived_table: {
    sql: SELECT
          st.id AS shift_team_id,
          st.start_time at time zone 'UTC' at time zone m.tz_name AS shift_start,
          st.end_time at time zone 'UTC' at time zone m.tz_name AS shift_end,
          to_char(st.start_time at time zone 'UTC' at time zone m.tz_name, 'Day') AS dow,
          m.id AS market_id,
          m.name AS market,
          c.name AS car
        FROM shift_teams st
        JOIN markets m ON st.market_id = m.id
        JOIN cars c ON st.car_id = c.id
        JOIN shift_types ty ON st.shift_type_id = ty.id
        -- where st.market_id in (159, 160)
        -- and st.start_time::date >= current_date - interval '30 days'
        WHERE ty.name = 'telepresentation_solo_dhmt'  ;;
    sql_trigger_value: SELECT MAX(id) FROM public.shift_teams ;;
    indexes: ["shift_team_id"]
    }

    dimension: primary_key {
      type: number
      primary_key: yes
      sql: CONCAT(${shift_team_id}) ;;
    }

    dimension: shift_team_id {
      type: number
      sql: ${TABLE}.shift_team_id ;;
    }

    dimension_group: shift_start {
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
      sql: ${TABLE}.shift_start ;;
    }

  dimension_group: shift_end {
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
    sql: ${TABLE}.shift_end ;;
  }

  dimension: dow {
    type: string
    sql: ${TABLE}.dow ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
  }

  dimension: car {
    type: string
    sql: ${TABLE}.car ;;
  }

  # dimension: tele_car_available {
  #   type: number
  #   sql: case when ${shift_team_id} is not null then 1 else 0 end ;;
  # }

  dimension: tele_car_available {
    type: yesno
    sql: ${shift_team_id} is not null ;;
  }

  }
