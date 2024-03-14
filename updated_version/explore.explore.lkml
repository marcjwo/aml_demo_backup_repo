include: "/updated_version/risk_case_event_enhanced.view.lkml"
include: "/updated_version/predictions.view.lkml"
include: "/updated_version/party.view.lkml"
include: "/updated_version/engineconfigmetadata.view.lkml"
include: "/updated_version/predictions_enhanced.view.lkml"
include: "/updated_version/explainability.view.lkml"
include: "/updated_version/transaction.view.lkml"
include: "/updated_version/account_party_link.view.lkml"
include: "/views/demo_mock/feature_family_desc.view.lkml"

include: "/flat/evaluation.view.lkml"
# explore: risk_case_event_enhanced {

#   join:  predictions {
#     type: left_outer
#     sql_on: ${risk_case_event_enhanced.party_id} = ${predictions.party_id} ;;
#     relationship: many_to_one
#   }

#   join: party {
#     type: left_outer
#     sql_on: ${risk_case_event_enhanced.party_id} = ${party.party_id} ;;
#     relationship: many_to_one
#   }
# }

# explore: test {
#   from: risk_case_event_enhanced
# }

# explore: evaluation {
#   from: risk_case_event_enhanced

#   join: predictions {
#     sql_on: ${evaluation.party_id} = ${predictions.party_id} AND ${predictions.risk_period_end_month} = ${evaluation.event_month} ;;
#     type: full_outer
#     relationship: many_to_one
#   }

#   join: predictions_enhanced {
#     sql_on: ${predictions.party_id} = ${predictions_enhanced.party_id} AND ${predictions.risk_period_end_month} = ${predictions_enhanced.risk_period_end_time_month};;
#     fields: [predictions_enhanced.risk_label]
#     type: left_outer
#     relationship: one_to_one
#   }
# }

explore: engineconfigmetadata {}

explore: explainability {
  sql_always_where: ${explainability__attributions.feature_family} NOT LIKE '%\\_supplementary\\_data%' ;;
  from: explainability
  label: "Explainability"

  join: explainability__attributions {
    view_label: "Explainability: Attributions"
    sql: LEFT JOIN UNNEST(${explainability.attributions}) as explainability__attributions ;;
    relationship: one_to_many
  }
  join: party {
    sql_on: ${explainability.party_id} = ${party.party_id} ;;
    relationship: many_to_one
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
  join: account_party_link {
    type: left_outer
    sql_on: ${account_party_link.party_id} = ${explainability.party_id} ;;
    relationship: many_to_one
  }
  join: transaction {
    sql_on: ${account_party_link.account_id} = ${transaction.account_id} ;;
    relationship: one_to_many
    type: left_outer
  }
  join: feature_family_desc {
    type: left_outer
    relationship: many_to_one
    sql_on: ${feature_family_desc.feature_family_name} = ${explainability__attributions.feature_family};;
  }
}
