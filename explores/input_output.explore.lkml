include: "/views/output_data/*.*"
include: "/views/input_data/*.*"
include: "/views/demo_mock/*"
include: "/explores/input_data.explore.lkml"

explore: input_output_data {
  extends: [input_data]

  join: predictions_augmented {
    view_label: "Predictions"
    sql_on: ${party.party_id} = ${predictions_augmented.party_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: explainability {
    view_label: "Explainability"
    sql_on: ${input_data.party_id} = ${explainability.party_id} ;;
    type: left_outer
    relationship: many_to_one

  }

  # join: explainability__attributions {
  #   view_label: "Explainability: Attributions"
  #   sql: LEFT JOIN UNNEST(ARRAY(
  #         (SELECT AS STRUCT *,GENERATE_UUID() as id
  #         FROM UNNEST(${explainability.attributions}))
  #         )) as table_name__record_name ;; #### this is required to be able to define a primary key which doesnt exist as is for the nested records.
  #   # sql: LEFT JOIN UNNEST(${explainability.attributions}) as explainability__attributions ;;
  #     relationship: one_to_many
  #     type: left_outer
  #   }
}
