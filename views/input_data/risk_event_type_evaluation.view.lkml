explore: risk_event_type_evaluation {}

view: risk_event_type_evaluation {
  sql_table_name: `finserv-looker-demo.@{input_dataset}.risk_event_type_evaluation` ;;

  dimension: legacy_confirmed {
    type: string
    sql: ${TABLE}.legacy_confirmed ;;
  }
  dimension: legacy_detected {
    type: string
    sql: ${TABLE}.legacy_detected ;;
  }
  dimension: risk_case_id {
    type: string
    sql: ${TABLE}.risk_case_id ;;
  }
  measure: count {
    type: count
  }

  #####

  dimension: legacy_result {
    type: string
    sql: CASE
            WHEN ${legacy_detected} = "Yes" AND ${legacy_confirmed} = "Yes" THEN "True Positive"
            WHEN ${legacy_detected} = "No" AND ${legacy_confirmed} = "Yes" THEN "True Negative"
            WHEN ${legacy_detected} = "Yes" and ${legacy_confirmed} = "No" THEN "False Positive"
            WHEN ${legacy_detected} = "No" and ${legacy_confirmed} = "No" THEN "False Negative"
        END;;
  }

  ####
}
