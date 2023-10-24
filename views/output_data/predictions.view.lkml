view: predictions {
  sql_table_name: `finserv-looker-demo.outputs.predictions` ;;

  dimension: party_id {
    type: string
    # hidden: yes
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
    type: count
    drill_fields: [party.party_id]
  }
}
