include: "/updated_version/party.view.lkml"
include: "/flat/party_fullname_mapping.view.lkml"
include: "/flat/evaluation.view.lkml"
#include: "/final_demo/views/risk_case_event_summary.view.lkml"

# explore: flat_evalution {
#   from: evaluation
include: "/final_demo/views/*"
#include: "/manifest.lkml"
include: "/updated_version/predictions.view.lkml"
include: "/final_demo/views/predictions_refinements.lkml"
#include: "/manifest.lkml"
include: "/final_demo/views/*"
# include: "/updated_version/predictions.view.lkml"
# include: "/final_demo/views/predictions_refinements.lkml"

explore: evaluation {
  from: risk_case_event_enhanced_join
  label: "Flat Evaluation"

  join: view1 {
    type: left_outer
    sql_on: ${evaluation.risk_case_id} = ${view1.risk_case_id}  ;;
    # sql_where: ((${risk_case_event_enhanced_join.type} = 'AML_EXIT' and ${risk_case_event_enhanced_join.label} = 'Positive') or
    # (${risk_case_event_enhanced_join.type} = 'AML_PROCESS_END' and ${risk_case_event_enhanced_join.label} = 'Negative'));;
    relationship: many_to_one
  }

  join: predictions_enhanced {
    type: left_outer ## full_outer
    sql_on: ${evaluation.party_id} = ${evaluation.party_id} ;;
    relationship: one_to_many
  }
  join: risk_case_event_enhanced_rank {
    type: left_outer
    sql_on: ${predictions_enhanced.party_id} = ${risk_case_event_enhanced_rank.party_id};;
    relationship: many_to_one
    sql_where: ${risk_case_event_enhanced_rank.risk_rank} = 1 ;;
  }

  join: party {
    sql_on: ${evaluation.party_id} = ${party.party_id} ;;
    type: left_outer
    relationship: many_to_many
  }
  join: party_fullname_mapping {
    view_label: "Party"
    type: left_outer
    sql_on: ${evaluation.party_id} = ${party_fullname_mapping.party_party_id};;
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
