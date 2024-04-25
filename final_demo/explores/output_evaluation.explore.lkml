include: "/final_demo/views/*"
#include: "/manifest.lkml"
include: "/updated_version/predictions.view.lkml"
include: "/final_demo/views/predictions_refinements.lkml"

explore: risk_case_event_summary {
  label: "Evaluation Summary"

  join: risk_label_mapping {
    type: left_outer
    sql_on: ${risk_case_event_summary.risk_case_id} = ${risk_label_mapping.risk_case_id}  ;;
    sql_where: ((${risk_case_event_summary.type} = 'AML_EXIT' and ${risk_case_event_summary.label} = 'Positive') or
    (${risk_case_event_summary.type} = 'AML_PROCESS_END' and ${risk_case_event_summary.label} = 'Negative'));;
    relationship: many_to_one
    }

  join: predictions {
  type: full_outer
  sql_on: ${risk_case_event_summary.party_id} = ${predictions.party_id} ;;
  relationship: one_to_many
  }
}
