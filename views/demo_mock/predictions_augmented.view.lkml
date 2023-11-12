view: predictions_augmented {
  sql_table_name: `finserv-looker-demo.outputs.predictions_augmented` ;;

  dimension: augment_party_exit {
    type: number
    sql: ${TABLE}.augment_party_exit ;;
  }
  dimension: augment_risk_label {
    type: string
    sql: ${TABLE}.augment_risk_label ;;
  }
  dimension: augmented_risk_score {
    type: number
    sql: ${TABLE}.augmented_risk_score ;;
  }
  dimension: party_exit {
    type: number
    sql: ${TABLE}.party_exit ;;
  }
  dimension: party_id {
    type: string
    sql: ${TABLE}.party_id ;;
  }
  dimension: risk_label {
    type: string
    sql: ${TABLE}.risk_label ;;
  }
  dimension_group: risk_period {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.risk_period ;;
  }
  dimension: risk_score {
    type: number
    sql: ${TABLE}.risk_score ;;
  }
  dimension: unknown_flag {
    type: number
    sql: ${TABLE}.unknown_flag ;;
  }
  measure: count {
    type: count
  }
}
