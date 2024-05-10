view: view4 {
  derived_table: {
    sql: SELECT
      a.*,
      b.risk_label
      FROM (with data_1 as (
      select risk_case_id, count(*) as counter, min(event_time) as minimum, max(event_time) as maximum from finserv-looker-demo.input_v3.risk_case_event group by risk_case_id)
      select a.*,b.minimum,b.maximum, CASE
           WHEN counter = 2 THEN "Negative"
           WHEN counter = 3 THEN "Positive"
       END as label
       from finserv-looker-demo.input_v3.risk_case_event a join data_1 b on
       a.risk_case_id = b.risk_case_id) a
      LEFT JOIN `${view1.SQL_TABLE_NAME} b
      ON a.risk_case_id = b.risk_case_id
      where ((type = 'AML_EXIT' and label = "Positive") or (type = 'AML_PROCESS_END' and label = "Negative")) ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: risk_case_event_id {
    type: string
    sql: ${TABLE}.risk_case_event_id ;;
  }

  dimension_group: event_time {
    type: time
    sql: ${TABLE}.event_time ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: party_id {
    type: string
    sql: ${TABLE}.party_id ;;
  }

  dimension: risk_case_id {
    type: string
    sql: ${TABLE}.risk_case_id ;;
  }

  dimension_group: minimum {
    type: time
    sql: ${TABLE}.minimum ;;
  }

  dimension_group: maximum {
    type: time
    sql: ${TABLE}.maximum ;;
  }

  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }

  dimension: risk_label {
    type: string
    sql: ${TABLE}.risk_label ;;
  }

  set: detail {
    fields: [
      risk_case_event_id,
      event_time_time,
      type,
      party_id,
      risk_case_id,
      minimum_time,
      maximum_time,
      label,
      risk_label
    ]
  }
}
