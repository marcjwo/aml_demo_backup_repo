view: risk_case_event_enhanced_join {
  sql_table_name: `finserv-looker-demo.enhancements_v3.risk_case_event_enhanced_join` ;;

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
  parameter: threshold_aml_ai { ## previously called threshold
    type: unquoted
  }

  dimension: aml_ai {
    type: string
    sql: CASE
          WHEN ${risk_score} IS NOT NULL
          AND (${risk_score}*100) >= {% parameter threshold_aml_ai %} THEN true
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

dimension: rank_risk {
  type: number
  sql: ROW_NUMBER() OVER(PARTITION BY ${party_id}, ${risk_case_id} ORDER BY ${risk_score} DESC) ;;
}


}
