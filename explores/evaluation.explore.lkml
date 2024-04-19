include: "/updated_version/party.view.lkml"
include: "/flat/party_fullname_mapping.view.lkml"
include: "/flat/evaluation.view.lkml"

explore: flat_evalution {
  from: evaluation

  join: party {
    sql_on: ${flat_evalution.party_id} = ${party.party_id} ;;
    type: left_outer
    relationship: many_to_many
  }
  join: party_fullname_mapping {
    view_label: "Party"
    type: left_outer
    sql: ${party.party_id} = ${party_fullname_mapping.party_id_filter};;
    relationship: one_to_one
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
