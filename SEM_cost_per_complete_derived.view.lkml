
  view: sem_cost_per_complete_derived {
# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

# If necessary, uncomment the line below to include explore_source.
 # include: "dashboard.model.lkml"

      derived_table: {
        explore_source: ga_adwords_cost_clone {
          column: short_name_adj { field: markets.short_name_adj }
          column: sum_total_adcost {}
          column: sum_total_adclicks {}
          column: count_distinct { field: genesys_conversation_summary.count_distinct }
          column: count_answered { field: genesys_conversation_summary.count_answered }
          column: date {field:ga_adwords_cost_clone.date_date}
          column: accepted_count { field: care_request_flat.accepted_count }
          column: complete_count { field: care_request_flat.complete_count }
          column: diversion_savings_911 { field: diversions_by_care_request.diversion_savings_911 }
          column: diversion_savings_er { field: diversions_by_care_request.diversion_savings_er }
          column: diversion_savings_hospitalization { field: diversions_by_care_request.diversion_savings_hospitalization }
          column: diversion_savings_obs { field: diversions_by_care_request.diversion_savings_obs }
          column: total_expected_allowable_test { field: athenadwh_transactions_clone.total_expected_allowable_test }
          column: count_claims { field: athenadwh_transactions_clone.count_claims }
          column: sem_covid { field: number_to_market.sem_covid }
          filters: {
            field: adwords_campaigns_clone.brand
            value: "No"
          }
          filters: {
            field: adwords_campaigns_clone.sem
            value: "Yes"
          }
          filters: {
            field: ga_adwords_cost_clone.date_date
            value: "after 2020/09/22"
          }
          filters: {
            field: markets.name_adj
            value: ""
          }
          filters: {
            field: number_to_market.sem_covid
            value: "Yes"
          }
        }
        sql_trigger_value: SELECT count(*) FROM looker_scratch.genesys_conversation_summary  where genesys_conversation_summary.conversationstarttime > current_date - interval '2 day';;
        indexes: ["date"]
      }

      dimension: short_name_adj {
        description: "Market short name where WMFR is included in Denver"
      }
      dimension: sum_total_adcost {
        value_format: "$#;($#)"
        type: number
      }
      dimension: sum_total_adclicks {
        type: number
      }
      dimension: count_distinct {
        label: "Genesys Conversation Summary Count Distinct (Inbound Demand)"
        type: number
      }
      dimension: count_answered {
        label: "Genesys Conversation Summary Count Answered (Inbound Demand)"
        type: number
      }
      dimension: accepted_count {
        type: number
      }
      dimension: complete_count {
        type: number
      }
      dimension: diversion_savings_911 {
        value_format: "$#,##0"
        type: number
      }
      dimension: diversion_savings_er {
        value_format: "$#,##0"
        type: number
      }
      dimension: diversion_savings_hospitalization {
        value_format: "$#,##0"
        type: number
      }

      dimension: date {
        type: date
      }
      dimension: diversion_savings_obs {
        value_format: "$#,##0"
        type: number
      }
      dimension: total_expected_allowable_test {
        label: "ZZZZ - Athenadwh Transactions Clone Total Expected Allowable Test"
        description: "Transaction type is CHARGE and transfer type is PRIMARY or patient is self-pay"
        value_format: "$#,##0.00"
        type: number
      }
      dimension: count_claims {
        label: "ZZZZ - Athenadwh Transactions Clone Count Claims"
        description: "Count of claims where expected allowable > $0.01"
        type: number
      }
      dimension: sem_covid {
        label: "Number to Market Sem Covid (Yes / No)"
        type: yesno
      }

      measure: total_adcost_sum {
        type: sum_distinct
        sql: ${sum_total_adcost} ;;
        sql_distinct_key: ${date} ;;
      }

    measure: sum_count_distinct_inbound {
      type: sum_distinct
      sql: ${count_distinct} ;;
      sql_distinct_key: ${date} ;;
    }

    measure: sum_count_answered_inbound {
      type: sum_distinct
      sql: ${count_answered} ;;
      sql_distinct_key: ${date} ;;
    }

    measure: sum_accepted_count {
      type: sum_distinct
      sql: ${accepted_count} ;;
      sql_distinct_key: ${date} ;;
    }

    measure: sum_complete_count {
      type: sum_distinct
      sql: ${complete_count} ;;
      sql_distinct_key: ${date} ;;
    }

    measure: sum_diversion_savings_911 {
      type: sum_distinct
      sql: ${diversion_savings_911} ;;
      sql_distinct_key: ${date} ;;
    }

    measure: sum_total_expected_allowable_test {
      type: sum_distinct
      sql: ${total_expected_allowable_test} ;;
      sql_distinct_key: ${date} ;;
    }

    measure: sum_total_count_claims {
      type: sum_distinct
      sql: ${count_claims} ;;
      sql_distinct_key: ${date} ;;
    }

    measure: sum_diversion_savings_er {
      type: sum_distinct
      sql: ${diversion_savings_er} ;;
      sql_distinct_key: ${date} ;;
    }

    measure: sum_diversions_savings_hospitalization {
      type: sum_distinct
      sql: ${diversion_savings_hospitalization} ;;
      sql_distinct_key: ${date} ;;
    }

    measure: sum_diversion_savings_obs {
      type: sum_distinct
      sql: ${diversion_savings_obs} ;;
      sql_distinct_key: ${date} ;;
    }

    measure: total_ad_clicks_sum {
      type: sum_distinct
      sql: ${sum_total_adclicks} ;;
      sql_distinct_key: ${date} ;;
    }

    measure: total_cost_savings {
      type: number
      sql: ${sum_diversion_savings_911}+${sum_diversion_savings_er}+${sum_diversions_savings_hospitalization}+${sum_diversions_savings_hospitalization} ;;
    }

    measure: total_cost_savings_romi {
      type: number
      sql: ((${total_cost_savings}-${total_adcost_sum}/${total_adcost_sum}))+1 ;;
    }

    measure: call_to_answer_rate {
      type: number
      sql: ${sum_count_answered_inbound}/${sum_count_distinct_inbound} ;;
    }

    measure: answer_to_assign_rate {
      type: number
      sql: ${sum_accepted_count}/${sum_count_distinct_inbound} ;;
    }

    measure: assigned_to_complete_rate {
      type: number
      sql: ${sum_complete_count}/${sum_accepted_count} ;;
    }

    measure: cost_per_call {
      type: number
      sql: ${total_adcost_sum}/${sum_count_distinct_inbound} ;;
    }

    measure: cost_per_answered {
      type: number
      sql: ${total_adcost_sum}/${sum_count_answered_inbound} ;;
    }

    measure: cost_per_complete {
      type: number
      sql: ${total_adcost_sum}/${sum_complete_count} ;;
    }

    measure: average_expected_allowable {
      type: number
      sql: ${sum_total_expected_allowable_test}/${sum_total_count_claims}  ;;
    }

    measure: expected_allowable_savings {
      type: number
      sql: ${average_expected_allowable}*${sum_complete_count} ;;
    }

    measure: expected_allowable_romi {
      type: number
      sql: ((${expected_allowable_savings}-${total_adcost_sum})/${total_adcost_sum})+1 ;;
    }

    measure: expected_allowable_romi_200_visit {
      type: number
      sql: (((${sum_complete_count}*200)-${total_adcost_sum})/${total_adcost_sum}))+1 ;;
    }

    measure: cost_per_click {
      type: number
      sql: ${total_adcost_sum}/${total_ad_clicks_sum} ;;
    }


    }
