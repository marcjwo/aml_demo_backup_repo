explore: model_performance_mock {}

view: model_performance_mock {
  derived_table: {
    sql: SELECT '2022-01-01' as date, 0.8 as model_performance UNION ALL
      SELECT '2022-02-01', 0.74 UNION ALL
      SELECT '2022-03-01', 0.81 UNION ALL
      SELECT '2022-04-01', 0.85 UNION ALL
      SELECT '2022-05-01', 0.82 UNION ALL
      SELECT '2022-06-01', 0.9 UNION ALL
      SELECT '2022-07-01', 0.73 UNION ALL
      SELECT '2022-08-01', 0.8 UNION ALL
      SELECT '2022-09-01', 0.81 UNION ALL
      SELECT '2022-10-01', 0.83 UNION ALL
      SELECT '2022-11-01', 0.89 UNION ALL
      SELECT '2022-12-01', 0.78 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: date {
    type: time
    sql: DATE(${TABLE}.date) ;;
  }

  dimension: model_performance {
    type: number
    sql: ${TABLE}.model_performance ;;
  }

  measure: _model_performance {
    type: average
    value_format_name: percent_0
    sql: ${model_performance} ;;
  }

  parameter: model_threshold {
    type: number
  }

  measure: _model_threshold {
    type: average
    value_format_name: percent_0
    sql: {% parameter model_threshold %} ;;
  }

  set: detail {
    fields: [
      # date,
      model_performance
    ]
  }
}
