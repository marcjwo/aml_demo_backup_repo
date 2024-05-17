include: "/final_demo/views/*"
include: "/flat/party_fullname_mapping.view.lkml"
include: "/updated_version/explainability.view.lkml"

explore: risk_case_event_enhanced_join {
  label: "Flat Evaluation"
  join: predictions_enhanced {
  type: left_outer ## full_outer
  sql_on: ${risk_case_event_enhanced_join.party_id} = ${predictions_enhanced.party_id} ;;
  relationship: many_to_one
  }
  join: party_fullname_mapping {
    view_label: "Party"
    type: left_outer
    sql_on: ${risk_case_event_enhanced_join.party_id} = ${party_fullname_mapping.party_party_id};;
    relationship: many_to_one
  }
  join: explainability {
    type: left_outer
    sql_on: ${explainability.party_id} = ${risk_case_event_enhanced_join.party_id} ;;
    relationship: many_to_many
  }
  join: venn_diagram {
    type: inner
    relationship: one_to_one
    sql: ${venn_diagram.venn_diagram} = ${risk_case_event_enhanced_join.venn_diagram};;

  }

  # join: view1 {
  #   type: left_outer
  #   sql_on: ${risk_case_event_enhanced_join.risk_case_id} = ${view1.risk_case_id}  ;;
  #   # sql_where: ((${risk_case_event_enhanced_join.type} = 'AML_EXIT' and ${risk_case_event_enhanced_join.label} = 'Positive') or
  #   # (${risk_case_event_enhanced_join.type} = 'AML_PROCESS_END' and ${risk_case_event_enhanced_join.label} = 'Negative'));;
  #   relationship: many_to_one
  #   }


  # join: risk_case_event_enhanced_rank {
  #   type: left_outer
  #   sql_on: ${predictions_enhanced.party_id} = ${risk_case_event_enhanced_rank.party_id};;
  #   relationship: many_to_one
  # }
}
