explore: risk_development_augmented {}

view: risk_development_augmented {
  derived_table: {
    sql: SELECT CAST("2022-01-01" as DATE) as risk_period_end_time, 0.52 as average_recall, 700 as false_positives UNION ALL
      SELECT CAST("2021-12-01" as DATE) as risk_period_end_time, 0.67 as average_recall, 800 as false_positives UNION ALL
      SELECT CAST("2021-11-01" as DATE) as risk_period_end_time, 0.72 as average_recall, 900 as false_positives ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: risk_period_end_time {
    type: date
    datatype: date
    sql: ${TABLE}.risk_period_end_time ;;
  }

  dimension: average_recall {
    type: number
    sql: ${TABLE}.average_recall ;;
  }

  measure: avg_recall {
    type: average
    value_format_name: percent_2
    sql: ${average_recall} ;;
  }

  dimension: false_positives {
    type: number
    sql: ${TABLE}.false_positives ;;
  }

  measure: total_false_positives {
    type: sum
    sql: ${false_positives} ;;
  }

  set: detail {
    fields: [
      risk_period_end_time,
      average_recall,
      false_positives
    ]
  }
}
