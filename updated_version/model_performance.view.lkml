explore: model_performance {}

view: model_performance {
  derived_table: {
    sql: SELECT "ExpectedRecallPreTuning" as cat, "v1" as version, 0.7 as value UNION ALL
      SELECT "ExpectedRecallPreTuning", "v2", 0.84 UNION ALL
      SELECT "ExpectedRecallPreTuning", "v3", 0.88 UNION ALL
      SELECT "ExpectedRecallPostTuning", "v1", 0.75 UNION ALL
      SELECT "ExpectedRecallPostTuning", "v2", 0.87 UNION ALL
      SELECT "ExpectedRecallPostTuning", "v3", 0.91 UNION ALL
      SELECT "ObservedRecallValues", "v1", 0.49 UNION ALL
      SELECT "ObservedRecallValues", "v2", 0.9 UNION ALL
      SELECT "ObservedRecallValues", "v3", 0.94 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: cat {
    type: string
    sql: ${TABLE}.cat ;;
  }

  dimension: version {
    type: string
    sql: ${TABLE}.version ;;
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
  }

  measure: _value {
    type: average
    sql: ${value} ;;
  }

  set: detail {
    fields: [
      cat,
      version,
      value
    ]
  }
}
