view: predictions_augmented {
  sql_table_name: `finserv-looker-demo.outputs.predictions_augmented` ;;

  dimension: party_exit_augment {
    # hidden: yes
    type: number
    sql: ${TABLE}.party_exit_augment ;;
  }

  dimension: party_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.party_id ;;
  }
  dimension: risk_label_augment {
    type: string
    sql: cast(${TABLE}.risk_label_augment as string) ;;
  }
  dimension_group: risk_period {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.risk_period ;;
  }
  dimension: risk_score {
    hidden: yes
    type: number
    sql: ${TABLE}.risk_score ;;
    value_format_name: percent_2
  }
  dimension: risk_score_augment {
    type: number
    sql: ${TABLE}.risk_score_augment ;;
    value_format_name: percent_2
  }

  measure: total_parties {
    type: count
  }

  measure: total_new_exits{
    label: "Total New Exits"
    type: count_distinct
    sql: ${party_id};;
    filters: [party_exit_augment: "1"]
  }

  measure: total_investigations {
    type: count_distinct
    sql: ${party_id};;
    filters: [party_exit_augment: "1,0"]

  }

  measure: total_prev_exits {
    label: "Total Prev Exits"
    type: count_distinct
    sql: ${party_id};;
    filters: [risk_case_event.type: "AML_EXIT"]
  }

  # measure: total_missed {
  #   type: number
  #   sql: ${total_detected} - ${total_new_exits};;
  # }
  measure: total_false_positives{
    type: number
    sql: ${total_investigations} - ${total_new_exits}  ;;
  }

  measure: false_positives_rate{
    type: number
    sql: ${total_false_positives}/${total_investigations} ;;
    value_format_name: percent_2
  }

  measure: recall {
    hidden: yes
    type: count_distinct
    sql: ${party_id};;
    filters: [risk_case_event.type: "AML_EXIT", party_exit_augment: "1" ]
  }

  measure: investigation_rate {
    type: number
    sql: ${total_investigations}/${total_parties} ;;
    value_format_name: percent_2
  }

  measure: total_performance {
    type: number
    sql: ${total_new_exits}/${total_prev_exits} ;;
    value_format_name: percent_2
  }

  # measure: prev_false_positive_rate {
  #   type: number
  #   sql:  ;;
  # }


  measure: total_recall {
    type: number
    sql: ${recall}/${total_prev_exits} ;;
    value_format_name: percent_2

  }


}
