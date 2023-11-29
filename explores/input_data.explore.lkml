include: "/views/input_data/*.*"

# include: "/views/input_data/risk_level_mapping.view.lkml"

explore: input_data {
  label: "Input Data"
  view_label: "Account Data"
  from: account_party_link

  join: party {
    view_label: "Party: Base Table"
    sql_on: ${input_data.party_id} = ${party.party_id}
    --AND ${input_data.validity_start_date} = ${party.validity_start_date}
    ;;
    relationship: one_to_many
#    relationship: many_to_one
    type: left_outer
  }

  join: party__residencies {
    view_label: "Party: Residencies"
    sql: LEFT JOIN UNNEST(${party.residencies}) as party__residencies ;;
    relationship: one_to_many
  }
  join: party__nationalities {
    view_label: "Party: Nationalities"
    sql: LEFT JOIN UNNEST(${party.nationalities}) as party__nationalities ;;
    relationship: one_to_many
  }

  join: transaction {
    view_label: "Transactions"
    sql_on: ${input_data.account_id} = ${transaction.account_id}
    --AND ${input_data.validity_start_date} = ${transaction.validity_start_date}
    ;;
    relationship: one_to_many
    type: left_outer
  }

  join: time_between_transactions {
    view_label: "Time between Transactions"
    sql_on: ${input_data.account_id} = ${time_between_transactions.account_id}
          ;;
    relationship: one_to_many
    type: left_outer
  }

  join: risk_case_event {
    view_label: "Risk Case Events"
    sql_on: ${input_data.party_id} = ${risk_case_event.party_id} ;;
    relationship: one_to_many
    type: inner
  }

  join: risk_event_type_mapping {
    view_label: "Risk Case Events"
    sql_on: ${risk_case_event.risk_case_id} = ${risk_event_type_mapping.risk_case_id} ;;
    relationship: many_to_one
    type: inner
  }

  join: party_registration {
    view_label: "Party: Sizes"
    sql_on: ${input_data.party_id} = ${party_registration.party_id} ;;
    relationship: many_to_one
    type: left_outer
  }
  join: risk_level_mapping {
    view_label: "Risk Case Events"
    relationship: one_to_one
    type: inner
    sql_on: ${risk_level_mapping.risk_typology} = ${risk_event_type_mapping.risk_label} ;;
  }

}
