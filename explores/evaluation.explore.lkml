include: "/updated_version/party.view.lkml"
include: "/flat/party_fullname_mapping.view.lkml"
include: "/flat/evaluation.view.lkml"
include: "/final_demo/views/risk_case_event_summary.view.lkml"

# explore: flat_evalution {
#   from: evaluation
include: "/final_demo/views/*"
#include: "/manifest.lkml"
include: "/updated_version/predictions.view.lkml"
include: "/final_demo/views/predictions_refinements.lkml"

explore: flat_evalution {
  from: risk_case_event_summary {}

  join: risk_label_mapping {
    type: left_outer
    sql_on: ${flat_evalution.risk_case_id} = ${risk_label_mapping.risk_case_id}  ;;
    # sql_where: ((${flat_evalution.type} = 'AML_EXIT' and ${flat_evalution.label} = 'Positive') or
    #   (${risk_case_event_summary.type} = 'AML_PROCESS_END' and ${risk_case_event_summary.label} = 'Negative'));;
    relationship: many_to_one
  }

  join: predictions {
    type: full_outer
    sql_on: ${flat_evalution.party_id} = ${predictions.party_id} ;;
    relationship: one_to_many
  }

  join: party {
    sql_on: ${flat_evalution.party_id} = ${party.party_id} ;;
    type: left_outer
    relationship: many_to_many
  }
  join: party_fullname_mapping {
    view_label: "Party"
    type: left_outer
    sql_on: ${flat_evalution.party_id} = ${party_fullname_mapping.party_party_id};;
    relationship: many_to_one
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
}
