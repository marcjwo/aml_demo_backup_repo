# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
# explore: explainability {
#   hidden: yes
#     join: explainability__attributions {
#       view_label: "Explainability: Attributions"
#       sql: LEFT JOIN UNNEST(${explainability.attributions}) as explainability__attributions ;;
#       relationship: one_to_many
#     }
# }
view: explainability {
  sql_table_name: `finserv-looker-demo.output_v3.explainability` ;;

  dimension: attributions {
    hidden: yes
    sql: ${TABLE}.attributions ;;
  }
  dimension: party_id {
    type: string
    sql: ${TABLE}.party_id ;;
  }
  dimension_group: risk_period_end {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.risk_period_end_time ;;
  }
  measure: count {
    type: count
  }
}

view: explainability__attributions {

  dimension: attribution {
    type: number
    sql: attribution ;;
  }
  dimension: explainability__attributions {
    type: string
    hidden: yes
    sql: explainability__attributions ;;
  }
  dimension: feature_family {
    type: string
    sql: feature_family ;;
  }
  measure: _attribution {
    type: average
    sql: ${attribution} ;;
    # value_format_name: decimal_4
  }
}
