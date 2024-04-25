view: predictions {
  sql_table_name: `finserv-looker-demo.output_v3.predictions` ;;

  dimension: party_id {
    type: string
    sql: ${TABLE}.party_id ;;
  }
  dimension_group: risk_period_end {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.risk_period_end_time ;;
  }
  dimension: risk_score {
    type: number
    sql: ${TABLE}.risk_score ;;
  }
  measure: count {
    type: count_distinct
    sql: ${party_id} ;;
  }

  parameter: threshold {
    type: unquoted
  }

  dimension: ai_aml {
    type: yesno
    sql: ${risk_score} > {% parameter threshold %} ;;
  }

  # dimension: true_positive_aml_ai {
  #   type: yesno
  #   sql: ${risk_score} > {% parameter threshold %} ;;
  # }

  # dimension: false_positive_aml_ai {
  #   type: yesno
  #   sql: ${risk_score} > {% parameter threshold %} and ${risk_case_event_enhanced.true_positive_rule_based} = false ;;
  # }

  # ### evaluations

  # dimension: true_positive {
  #   type: yesno
  #   sql: ${true_positive_aml_ai} and ${risk_case_event_enhanced.true_positive_rule_based} ;;
  # }

  # dimension: false_positive {
  #   type: yesno
  #   sql: ${true_positive_aml_ai} and ${risk_case_event_enhanced.true_positive_rule_based} = false ;;
  # }

  # dimension: true_negative {
  #   type: yesno
  #   sql: ${true_positive_aml_ai} = false and ${risk_case_event_enhanced.true_positive_rule_based} = false ;;
  # }

  # dimension: false_negative {
  #   type: yesno
  #   sql: ${true_positive_aml_ai} = false and ${risk_case_event_enhanced.true_positive_rule_based} ;;
  # }

  # dimension: classification { ## 4/25 - can we comment this out?
  #   type: string
  #   sql: CASE
  #         WHEN ${ai_aml} = true AND ${evaluation.true_positive_rule_based} = true AND ${party_id} IS NOT NULL and ${evaluation.type} = "AML_EXIT" THEN "True positive"
  #         WHEN ${ai_aml} = true AND ${evaluation.true_positive_rule_based} = false AND ${party_id} IS NOT NULL and ${evaluation.type} = "AML_PROCESS_END" THEN "False positive"
  #         WHEN ${ai_aml} = false AND ${evaluation.true_positive_rule_based} = false AND ${party_id} IS NOT NULL and ${evaluation.type} = "AML_PROCESS_END" THEN "True negative"
  #         WHEN ${ai_aml} = false AND ${evaluation.true_positive_rule_based} = true AND ${party_id} IS NOT NULL and ${evaluation.type} = "AML_EXIT" THEN "False negative"
  #         WHEN ${party_id} IS NULL THEN "Out of Scope AML AI"
  #         WHEN ${ai_aml} = true AND ${evaluation.true_positive_rule_based} is NULL THEN 'True Positive - Not in Rule'
  #         when ${ai_aml} = false AND ${evaluation.true_positive_rule_based} is NULL THEN 'True negative - Not in Rule'
  #       END
  #   ;;
  # }

  # dimension: classification_rule_based {
  #   type: string
  #   sql: CASE
  #         WHEN ${true_positive_aml_ai} = true AND ${risk_case_event_enhanced.true_positive_rule_based} = true AND ${risk_period_end_month} = ${risk_case_event_enhanced.event_month} THEN "True positive"
  #         WHEN ${true_positive_aml_ai} = true AND ${risk_case_event_enhanced.true_positive_rule_based} = false AND ${risk_period_end_month} = ${risk_case_event_enhanced.event_month} THEN "False positive"
  #         WHEN ${true_positive_aml_ai} = false AND ${risk_case_event_enhanced.true_positive_rule_based} = false AND ${risk_period_end_month} = ${risk_case_event_enhanced.event_month} THEN "True negative"
  #         WHEN ${true_positive_aml_ai} = false AND ${risk_case_event_enhanced.true_positive_rule_based} = true AND ${risk_period_end_month} = ${risk_case_event_enhanced.event_month} THEN "False positive"
  #       END
  #   ;;
  # }



  # dimension: usable_party_id {
  #   sql: case when ${party_id} is null then ${evaluation.party_id} else ${party_id} end ;;
  # }

  # measure: count_parties {
  #   type: count_distinct
  #   sql: ${usable_party_id} ;;
  # }

  # measure: count_net_new_rule_based {
  #   type: count_distinct
  #   sql: ${usable_party_id} ;;
  #   filters: [evaluation.legacy_confirmed: "true"]
  # }

  # measure: count_net_new_ai_aml {
  #   type: count_distinct
  #   sql: ${usable_party_id} ;;
  #   filters: [evaluation.is_true_positive_rule_based: "No"]
  # }


  # measure: count_overlap {
  #   type: count_distinct
  #   sql: ${usable_party_id} ;;
  #   filters: [classification: "True positive"]
  # }

  # measure: count_tp_rule_based {
  #   type: count_distinct
  #   sql: ${usable_party_id} ;;
  #   filters: [classification: "False negative"]
  # }
}
