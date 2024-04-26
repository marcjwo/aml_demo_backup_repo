view: risk_case_event_enhanced_join {
  sql_table_name: `finserv-looker-demo.enhancements_v3.risk_case_event_enhanced_join` ;;

  dimension: pk {
    type: string
    hidden: no
    primary_key: yes
    sql: FARM_FINGERPRINT(CONCAT(${TABLE}.date,${TABLE}.party_id)) ;;
  }

  dimension_group: event {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.event_time ;;
  }
  dimension: event_time_format {
    type: string
    sql: ${TABLE}.event_time_format ;;
  }
  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }
  dimension_group: maximum {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.maximum ;;
  }
  dimension_group: minimum {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.minimum ;;
  }
  dimension: party {
    type: string
    sql: ${TABLE}.party ;;
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
  dimension_group: risk_period_end {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.risk_period_end_time ;;
  }
  dimension: risk_period_end_time_format {
    type: string
    sql: ${TABLE}.risk_period_end_time_format ;;
  }
  dimension: risk_score {
    type: number
    sql: ${TABLE}.risk_score ;;
  }
  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }
  measure: count {
    type: count
  }


  ###added
  parameter: threshold { ## AML AI
    type: unquoted
  }

  dimension: aml_ai {
    type: string
    sql: CASE
          WHEN  ${risk_case_event_enhanced_rank.risk_score} IS NOT NULL
          AND (${risk_case_event_enhanced_rank.risk_score}*100) >= {% parameter threshold %} THEN true
          ELSE false
          end;;
  }

  dimension: classification { ##classify
    type: string
    sql: CASE
      WHEN ${aml_ai} = true AND ${label} = 'Positive' AND ${type} IS NOT NULL THEN "True Positive"
      WHEN ${aml_ai} = true AND ${label} = 'Negative' AND ${type} IS NOT NULL THEN "False Positive"
      WHEN ${aml_ai} = false AND ${label} = 'Negative' AND ${type} IS NOT NULL THEN "True Negative"
      WHEN ${aml_ai} = false AND ${label} = 'Positive' AND ${type} IS NOT NULL THEN "False Negative"
      WHEN ${aml_ai} = true AND ${label} = 'Negative' AND  ${type} IS NOT NULL THEN 'True Positive - Not in Rule'
      WHEN ${aml_ai} = false AND ${label} = 'Negative' AND ${type} IS NOT NULL THEN 'True Negative - Not in Rule'
      END ;;
  }

  parameter: threshold_fp {
    type: unquoted
  }

  dimension: aml_ai_fp_ind {
    type: string
    sql:
    CASE
      WHEN ${aml_ai} AND (${investigation_threshold}*100) <= {% parameter threshold_fp %} THEN 'True positive'
      WHEN ${aml_ai} AND (${investigation_threshold}*100) > {% parameter threshold_fp %} THEN 'False positive'
    END
    ;;
  }


  dimension: net_new_indicator {
    type: string
    sql:
    CASE
      WHEN ${rule_based} = 'True positive' AND ${aml_ai_fp_ind} = 'True positive' then '1_Detected'
      WHEN ${rule_based} = 'True positive' AND ${aml_ai_fp_ind} IS NULL then '2_Rule based exit'
      WHEN ${rule_based} = 'False positive'AND ${aml_ai_fp_ind} = 'True positive' then '3_AML AI Exit'
      WHEN ${rule_based} IS NULL and ${aml_ai_fp_ind} = 'True positive' then '3_AML AI Exit'
    END
    ;;
  }

  dimension: investigation_threshold {
    type: number
    sql:
   CASE
          WHEN ${risk_period_end_raw} IS NOT NULL AND ${event_raw} IS NULL THEN RAND()
          WHEN ${risk_period_end_raw} IS NOT NULL AND  ${event_raw} IS NOT NULL THEN RAND()
          END;;
}
  dimension: rule_based {
    type: string
    sql: CASE
              WHEN ${type} = 'AML_PROCESS_END' AND ${label} = 'Negative' THEN 'False positive'
              WHEN ${type} = 'AML_EXIT' AND ${label} = 'Positive' THEN 'True positive'
          END;;
  }

}
