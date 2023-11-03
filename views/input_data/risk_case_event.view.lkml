view: risk_case_event {
  sql_table_name: `finserv-looker-demo.public_dataset.risk_case_event` ;;
  drill_fields: [risk_case_event_id]

  dimension: risk_case_event_id {
    primary_key: yes
    type: string
    description: "MANDATORY: Unique ID for this event."
    sql: ${TABLE}.risk_case_event_id ;;
  }
  dimension_group: event {
    type: time
    description: "MANDATORY: Timestamp when this event occurs."
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.event_time ;;
  }
  dimension: party_id {
    type: string
    description: "MANDATORY: The ID in the Party table of the Party that is the subject of this investigation process."
    # hidden: yes
    sql: ${TABLE}.party_id ;;
  }
  dimension: risk_case_id {
    type: string
    description: "MANDATORY: The ID of the overall case to which this event belongs."
    sql: ${TABLE}.risk_case_id ;;
  }
  dimension: type {
    type: string
    description: "MANDATORY: Type of risk case event. Only AML events are supported. The minimum requirement for the AML product to work is to provide a single AML_PROCESS_START, AML_PROCESS_END and where applicable AML_EXIT event per Party and risk_case_id. It is strongly recommended to also include AML_SUSPICIOUS_ACTIVITY_START and AML_SUSPICIOUS_ACTIVITY_END events for best model performance. One of: [AML_SUSPICIOUS_ACTIVITY_START:AML_SUSPICIOUS_ACTIVITY_END:AML_PROCESS_START:AML_PROCESS_END:AML_ALERT_GOOGLE:AML_ALERT_LEGACY:AML_ALERT_ADHOC:AML_ALERT_EXPLORATORY:AML_SAR:AML_EXTERNAL:AML_EXIT]."
    sql: ${TABLE}.type ;;
  }

  # measure: positive_cases {
  #   type: count_distinct
  #   sql: ${risk_case_event_id} ;;
  #   filters: [type: "AML_EXIT"]
  #   drill_fields: [risk_case_id, party_id]
  # }

  dimension: negative_case_flag {}
  measure: count {
    type: count
    drill_fields: [risk_case_event_id, party.party_id]
  }

}
