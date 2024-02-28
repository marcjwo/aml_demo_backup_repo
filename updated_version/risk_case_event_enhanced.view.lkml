view: risk_case_event_enhanced {
  sql_table_name: `finserv-looker-demo.enhancements_v3.risk_case_event_enhanced` ;;

  dimension_group: event {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.event_time ;;
  }
  dimension: legacy_confirmed {
    type: string
    sql: ${TABLE}.legacy_confirmed ;;
  }
  dimension: legacy_detected {
    type: string
    sql: ${TABLE}.legacy_detected ;;
  }
  dimension: party_id {
    type: string
    sql: ${TABLE}.party_id ;;
  }
  dimension: risk_case_event_id {
    type: string
    sql: ${TABLE}.risk_case_event_id ;;
  }
  dimension: risk_case_id {
    type: string
    sql: ${TABLE}.risk_case_id ;;
  }
  dimension: risk_label {
    type: string
    sql: ${TABLE}.risk_label ;;
  }

  dimension: usable_risk_label {
    label: "Usable risk label"
    type: string
    sql: CASE WHEN ${risk_label} is not null then ${risk_label} ELSE ${predictions_enhanced.risk_label} END;;
  }

  dimension: usable_party_id {
    label: "Usable party id"
    type: string
    sql: CASE WHEN ${party_id} is not null then ${party_id} ELSE ${predictions_enhanced.party_id} END;;
  }

  dimension: true_positive_rule_based {
    type: string
    sql: ${TABLE}.true_positive_rule_based ;;
  }

  dimension: is_true_positive_rule_based {
    type: yesno
    sql: ${true_positive_rule_based} = true ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }
  measure: count {
    type: count_distinct
    sql: ${party_id} ;;
  }

  measure: count_usable {
    label: "Count parties"
    type: count_distinct
    sql: ${usable_party_id} ;;
  }

  ## v3 enhancements

  dimension: evaluation {
    sql: CASE
          WHEN ${true_positive_rule_based} AND ${type} = 'AML_EXIT' AND ${indicator} IN ('Rule based', 'Both' ) then 'TP'
          WHEN NOT ${true_positive_rule_based} and ${type} = 'AML_PROCESS_END' AND ${indicator} IN ('Rule based', 'Both' ) then 'FP'
          WHEN ${indicator} = 'AML AI' then 'AI'
        END
        ;;
  }

  dimension_group: usable_date {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CASE WHEN ${event_raw} IS NULL THEN ${predictions.risk_period_end_raw} ELSE ${event_raw} END;;
  }

  # measure: net_new_addition_AML_AI {
  #   type: count_distinct
  #   sql: ${predictions.usable_party_id} ;;
  #   filters: [evaluation: "AI"]
  # }

  # measure: net_new_addition_RB {
  #   type: count_distinct
  #   sql: ${predictions.usable_party_id} ;;
  #   filters: [evaluation: "FP"]
  # }

  # measure: overlap {
  #   type: count_distinct
  #   sql: ${predictions.usable_party_id} ;;
  #   filters: [evaluation: "TP"]
  # }


  dimension: indicator {
    type: string
    sql: CASE
          WHEN ${event_date} IS NOT NULL and ${predictions.risk_period_end_date} IS NOT NULL THEN "Both"
          WHEN ${predictions.risk_period_end_date} IS NULL THEN "Rule based"
          WHEN ${event_date} IS NULL THEN "AML AI"
        END
    ;;
  }

  # dimension: usable_party_id {
  #   sql: case when ${party_id} is null then ${party_id} else ${predictions.party_id} end ;;
  # }

}
