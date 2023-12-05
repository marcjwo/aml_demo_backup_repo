include: "/views/output_data/*.*"
include: "/views/input_data/*.*"
include: "/views/demo_mock/*"

explore: output_data {
  label: "Output Data"
  view_label: "Account Data"
  from: account_party_link

  join: party {
    view_label: "Party: Base Table"
    sql_on: ${output_data.party_id} = ${party.party_id};;
    relationship: one_to_many
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

  # join: predictions {
  #   view_label: "Predictions"
  #   sql_on: ${party.party_id} = ${predictions.party_id} ;;
  #   relationship: one_to_many
  #   type: left_outer
  # }
  join: transaction {
    view_label: "Transactions"
    sql_on: ${output_data.account_id} = ${transaction.account_id}       ;;
    relationship: one_to_many
    type: left_outer
  }

  join: time_between_transactions {
    view_label: "Time between Transactions"
    sql_on: ${output_data.account_id} = ${time_between_transactions.account_id}
      ;;
    relationship: one_to_many
    type: left_outer
  }

  join: risk_case_event {
    view_label: "Risk Case Events"
    sql_on: ${output_data.party_id} = ${risk_case_event.party_id} ;;
    relationship: one_to_many
    type: full_outer
  }

  join: risk_event_type_mapping {
    view_label: "Risk Case Events"
    sql_on: ${risk_case_event.risk_case_id} = ${risk_event_type_mapping.risk_case_id} ;;
    relationship: many_to_one
    type: inner
  }


  join: predictions_augmented {
    view_label: "Predictions"
    sql_on: ${party.party_id} = ${predictions_augmented.party_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: explainability {
    view_label: "Explainability"
    sql_on: ${output_data.party_id} = ${explainability.party_id} ;;
    type: left_outer
    relationship: many_to_one

  }

  join: explainability__attributions {
    view_label: "Explainability: Attributions"
    sql: LEFT JOIN UNNEST(ARRAY(
          (SELECT AS STRUCT *,GENERATE_UUID() as id
          FROM UNNEST(${explainability.attributions}))
          )) as table_name__record_name ;; #### this is required to be able to define a primary key which doesnt exist as is for the nested records.
    # sql: LEFT JOIN UNNEST(${explainability.attributions}) as explainability__attributions ;;
    relationship: one_to_many
    type: left_outer
  }
}
