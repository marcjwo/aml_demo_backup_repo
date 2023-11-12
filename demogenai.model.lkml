connection: "looker-private-demo"

 include: "/views/*/*.view.lkml"                # include all views in the views/ folder in this project

include: "/explores/input_data.explore.lkml"

include: "/explores/output_data.explore.lkml"

include: "/views/input_data/risk_event_type_evaluation.view.lkml"

include: "/views/input_data/risk_development_augmented.view.lkml"


# include: "/views/explainability.view.lkml"

# include: "/views/input_data/risk_event_type_mapping_aiaml.view.lkml"


# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }
