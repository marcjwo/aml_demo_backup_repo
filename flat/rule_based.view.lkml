
view: rule_based {
  derived_table: {
    sql: SELECT
            * EXCEPT(rn)
            FROM (
            SELECT
            *,
            ROW_NUMBER() OVER (PARTITION BY party_id, risk_case_id ORDER BY event_time DESC, type ASC) AS rn
            FROM
            `finserv-looker-demo.input_v3.risk_case_event` )
            WHERE
            rn = 1 ;;
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

  set: detail {
    fields: [
        risk_case_event_id,
	event_time_time,
	type,
	party_id,
	risk_case_id
    ]
  }
}
