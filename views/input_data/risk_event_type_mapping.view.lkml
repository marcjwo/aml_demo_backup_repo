view: risk_event_type_mapping {
  sql_table_name: `finserv-looker-demo.public_dataset.risk_event_type_mapping` ;;

  dimension: risk_case_id {
    type: string
    hidden: yes
    primary_key: yes
    description: "The ID of the overall case to which this event belongs."
    sql: ${TABLE}.risk_case_id ;;
  }
  dimension: risk_label {
    type: string
    description: "The risk type of this risk case id as per customer classification."
    sql: ${TABLE}.risk_label ;;
  }
  measure: positive_cases {
    type: count
  }

  ####

  dimension: detected {
    type: string
    sql: ${TABLE}.detected ;;
  }

  measure: detected_cases {
    type: count
    # sql: ${risk_case_id} ;;
    filters: [detected: "Yes"]
  }

  measure: missed_cases {
    type: count
    # sql: ${risk_case_id} ;;
    filters: [detected: "No"]
  }

  measure: recall_percentage {
    type: number
    value_format_name: percent_2
    sql: ${detected_cases}/${positive_cases} ;;
  }

  measure: missed_percentage {
    type: number
    value_format_name: percent_2
    sql: ${missed_cases}/${positive_cases} ;;
  }

  dimension: model_improv {
    type: number
    sql: ${TABLE}.model_improv ;;
  }

  measure: model_improv_measure {
    type: average
    sql: ${model_improv} ;;
  }

  measure: additional_finds {
    type: number
    sql: Round(${model_improv_measure}*${detected_cases}) ;;
  }

  measure: total_performance {
    type: number
    value_format_name: percent_2
    sql: (${detected_cases}+${additional_finds})/${positive_cases} ;;
  }

  ####
}
