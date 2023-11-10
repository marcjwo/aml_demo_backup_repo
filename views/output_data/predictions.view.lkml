view: predictions {
  # sql_table_name: `finserv-looker-demo.outputs.predictions` ;;
  sql_table_name: `finserv-looker-demo.outputs.additionally_generated_data` ;;

  dimension: party_id {
    primary_key: yes            #### will this work in combination with risk_period_end? Mock data does not indicate, likely to create surrogate key with farm_fingerprint
    type: string
    hidden: yes
    sql: ${TABLE}.party_id ;;
  }
  dimension_group: risk_period_end {
    type: time
    timeframes: [date]
    # timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.risk_period_end_time ;;
  }
  dimension: risk_score {
    hidden: no
    type: number
    value_format_name: percent_2
    sql: ${TABLE}.risk_score ;;
  }
  measure: count {
    hidden: yes
    type: count
    drill_fields: [party.party_id]
  }



  ### ADDED

  measure: risk_score_measure {
    label: "Risk Score"
    type: average                 #### Need to doublecheck here. Just choosing a type of measure to transform it. Depends on the final data structure and the combination with risk_period_end (as in how this is being used) to determine how to measure this best.
    sql: ${risk_score} ;;
    value_format_name: percent_2
  }

  # measure: low_risk_score {
  #   label: "Risk Score"
  #   sql: ${risk_score} > 25 ;;
  #   value_format_name: percent_2
  # }

  ##added for demo

  measure: low_risk_score {
    type: number
    label: "Low Risk Score"
    sql: ${risk_score} > 25 ;;
    value_format_name: percent_2
  }

  measure: medium_risk_score {
    type: number
    label: "Medium Risk Score"
    sql: ${risk_score} <- 25 and  ${risk_score} > 50  ;;
    value_format_name: percent_2
  }

  measure: high_risk_score {
    type: number
    label: "High Risk Score"
    sql: ${risk_score} < 50  ;;
    value_format_name: percent_2
  }

}
