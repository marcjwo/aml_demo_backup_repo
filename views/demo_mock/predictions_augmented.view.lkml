view: predictions_augmented {
  sql_table_name: `finserv-looker-demo.outputs.predictions_augmented` ;;

  dimension: augmented {
    label: "Risk Score"
    type: number
    sql: ${TABLE}.augmented ;;
  }
  dimension: new_risk_label {
    label: "Risk Label"
    type: string
    sql: ${TABLE}.new_risk_label ;;
  }
  dimension: party_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.party_id ;;
  }
  dimension: risk_period {
    type: string
    sql: ${TABLE}.risk_period ;;
  }
  measure: risk_score_measure {
    label: "Risk Score"
    type: average                 #### Need to doublecheck here. Just choosing a type of measure to transform it. Depends on the final data structure and the combination with risk_period_end (as in how this is being used) to determine how to measure this best.
    sql: ${augmented} ;;
    value_format_name: percent_2
}
}
