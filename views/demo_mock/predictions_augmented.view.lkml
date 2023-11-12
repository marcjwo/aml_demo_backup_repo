view: predictions_augmented {
  sql_table_name: `finserv-looker-demo.outputs.predictions_augmented` ;;

  dimension: party_exit_augment {
   # hidden: yes
    type: number
    sql: ${TABLE}.party_exit_augment ;;
  }
  dimension: party_exit_result {
    case: {
      when: {
        sql: ${TABLE}.party_exit_augment = 0 ;;
        label: "Investigated"
      }
      when: {
        sql: ${TABLE}.party_exit_augment = 1 ;;
        label: "Exited"
      }
      else: "Not Investigated"
    }
  }

  dimension: party_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.party_id ;;
  }
  dimension: risk_label_augment {
    type: string
    sql: ${TABLE}.risk_label_augment ;;
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

  measure: total_exits {
    type: count_distinct
    sql: ${party_id};;
    filters: [party_exit_result: "Exited"]
  }

  measure: total_investigations {
    type: count_distinct
    sql: ${party_id};;
    filters: [party_exit_result: "Investigated"]
  }

  measure: total_not_investigated {
    type: count_distinct
    sql: ${party_id};;
    filters: [party_exit_result: "Not Investigated"]
  }
  measure: total_false_positives{
    type: number
    sql: ${total_investigations} - ${total_exits} ;;
  }

  measure: false_positives_rate{
    type: number
    sql: ${total_false_positives}/${total_exits} ;;
    value_format_name: percent_2
  }


}
