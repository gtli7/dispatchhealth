
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


    }
