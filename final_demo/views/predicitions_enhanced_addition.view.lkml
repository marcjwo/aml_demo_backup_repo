view: predicitions_enhanced_addition {
  sql_table_name: `finserv-looker-demo.enhancements_v3.predicitions_enhanced_addition` ;;

  dimension: party_id {
    type: string
    sql: ${TABLE}.party_id ;;
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
  dimension: risk_score {
    type: number
    sql: ${TABLE}.risk_score ;;
  }
  measure: count {
    type: count
  }
}
