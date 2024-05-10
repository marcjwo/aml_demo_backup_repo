include: "/final_demo/views/*"
#include: "/manifest.lkml"
include: "/final_demo/views/*"
# include: "/updated_version/predictions.view.lkml"
# include: "/final_demo/views/predictions_refinements.lkml"

explore: risk_case_event_enhanced_join {
  label: "Flat Evaluation"

  join: view1 {
    type: left_outer
    sql_on: ${risk_case_event_enhanced_join.risk_case_id} = ${view1.risk_case_id}  ;;
    # sql_where: ((${risk_case_event_enhanced_join.type} = 'AML_EXIT' and ${risk_case_event_enhanced_join.label} = 'Positive') or
    # (${risk_case_event_enhanced_join.type} = 'AML_PROCESS_END' and ${risk_case_event_enhanced_join.label} = 'Negative'));;
    relationship: many_to_one
    }

  join: predictions_enhanced {
  type: left_outer ## full_outer
  sql_on: ${risk_case_event_enhanced_join.party_id} = ${risk_case_event_enhanced_join.party_id} ;;
  relationship: one_to_many
  }
  join: risk_case_event_enhanced_rank {
    type: left_outer
    sql_on: ${predictions_enhanced.party_id} = ${risk_case_event_enhanced_rank.party_id};;
    relationship: many_to_one
  }
}
