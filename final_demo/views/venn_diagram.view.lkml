# If necessary, uncomment the line below to include explore_source.
include: "/final_demo/explores/output_evaluation.explore.lkml"


view: venn_diagram {
  derived_table: {
    explore_source: risk_case_event_enhanced_join {
      column: venn_diagram {}
      column: party_count {}
      column: total_aml_ai {}
      column: total_rules_based {}
      column: total_rules_based_and_aml_ai {}
bind_all_filters: yes
    }
  }
  dimension: venn_diagram {
    description: ""
  }
  dimension: party_count {
    description: ""
    type: number
  }
  dimension: total_aml_ai {
    description: ""
    type: number
  }
  dimension: total_rules_based {
    description: ""
    type: number
  }
  dimension: total_rules_based_and_aml_ai {
    description: ""
    type: number
  }

  measure: total_output {
    type: number
    sql: case when ${venn_diagram} = 'Rules Based' then sum(${total_rules_based})
    when ${venn_diagram} = 'AML AI' then sum(${total_aml_ai})
     when ${venn_diagram} = 'Rules Based & AML AI ' then sum(${total_rules_based_and_aml_ai})
    end;;
  }
}


# # If necessary, uncomment the line below to include explore_source.
# include: "/final_demo/explores/output_evaluation.explore.lkml"

# view: venn_diagram {
#   derived_table: {
#     explore_source: risk_case_event_enhanced_join {
#       column: party_id {}
#       column: is_aml_ai {}
#       column: is_rules_based {}
#       column: is_rules_based_and_aml_ai {}
#       bind_all_filters: yes
#     }
#   }
#   dimension: party_id {
#     primary_key: yes
#     description: ""
#   }
#   dimension: is_aml_ai {
#     label: "Risk Case Event Enhanced Join Is Aml Ai (Yes / No)"
#     description: ""
#     type: yesno
#   }
#   dimension: is_rules_based {
#     label: "Risk Case Event Enhanced Join Is Rules Based (Yes / No)"
#     description: ""
#     type: yesno
#   }
#   dimension: is_rules_based_and_aml_ai {
#     label: "Risk Case Event Enhanced Join Is Rules Based and Aml Ai (Yes / No)"
#     description: ""
#     type: yesno
#   }

#   dimension: venn_diagram_output {
#     type:       string
#     sql: case WHEN ${is_rules_based} = 'Yes' then 'Rules Based'
#     WHEN ${is_rules_based_and_aml_ai} = 'Yes' then 'Rules Based & AML AI'
#     WHEN ${is_rules_based_and_aml_ai} = 'Yes' then 'AML AI'
#     end
#   ;;
#   }

#   measure: total_parties {
#     type: count_distinct
#     sql: ${party_id} ;;
#   }
#   }

# #   measure: total_rules_based { ## not needed
# #     type: count_distinct
# #     sql:     CASE
# #       WHEN ${is_rules_based} = 'Yes' then ${party_id}
# #     END
# #     ;;
# #   }

# #   measure: total_aml_ai{ ## not needed
# #     type: count_distinct
# #     sql:     CASE
# #       WHEN ${is_aml_ai} = 'Yes' then ${party_id}
# #     END
# #     ;;
# #   }

# #   measure: total_rules_based_and_aml_ai{ ## not needed
# #     type: count_distinct
# #     sql:     CASE
# #       WHEN ${is_rules_based_and_aml_ai} = 'Yes' then ${party_id}
# #     END
# #     ;;
# #   }
# # }


# # # If necessary, uncomment the line below to include explore_source.

# # include: "/final_demo/explores/output_evaluation.explore.lkml"

# # view: venn_diagram {
# #   derived_table: {
# #     explore_source: risk_case_event_enhanced_join {
# #       column: party_count {}
# #       column: venn_diagram {}
# #       bind_all_filters: yes
# #     }
# #   }
# #   dimension: party_count {
# #     description: ""
# #     type: number
# #   }
# #   dimension: venn_diagram {
# #     description: ""
# #   }


# # measure: total_parties { ## not needed
# #   type: sum
# #   sql:     CASE
# #       WHEN ${venn_diagram} =  'Rules Based & AML AI' then ${party_count}
# #       WHEN (${venn_diagram} = 'Rules Based'or ${venn_diagram} = 'Rules Based & AML AI' )then ${party_count}
# #       WHEN (${venn_diagram} = 'AML AI' or ${venn_diagram} = 'Rules Based & AML AI' ) then ${party_count}
# #     END
# #     ;;

# # }
# # }
