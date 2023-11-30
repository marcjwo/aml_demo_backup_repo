
view: recall {
  derived_table: {
    sql: WITH positives AS (
        SELECT DISTINCT  # in case there is more than one exit per party
          party_id
        FROM `finserv-looker-demo.public_dataset.risk_case_event`
        WHERE type = 'AML_EXIT'
      ),
      
      alerts AS (
        SELECT DISTINCT  # in case there is more than one alert per party
          party_id
        FROM `finserv-looker-demo.outputs.predictions`
        WHERE risk_score > 0.5
      ),
      
      true_positives AS (
        SELECT
          COUNT(*) AS result
        FROM
          alerts
        INNER JOIN
          positives
         ON positives.party_id = alerts.party_id
      ),
      
      all_positives AS (
        SELECT
          COUNT(*) AS result
        FROM
          positives
      )
      
      SELECT
        all_positives.result AS all_positives,
        true_positives.result AS true_positives
      FROM all_positives, true_positives ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: all_positives {
    type: number
    sql: ${TABLE}.all_positives ;;
  }

  dimension: true_positives {
    type: number
    sql: ${TABLE}.true_positives ;;
  }

  set: detail {
    fields: [
        all_positives,
	true_positives
    ]
  }
}
