explore: skew {}

view: skew {
  derived_table: {
    sql: SELECT
        JSON_EXTRACT_SCALAR(feature_family, '$.featureFamily') AS feature_family,
        JSON_EXTRACT_SCALAR(feature_family, '$.familySkewValue') AS skew,
        JSON_EXTRACT_SCALAR(feature_family, '$.maxSkewValue') AS threshold

      FROM `finserv-looker-demo.output_v3.prediction-results-metadata`,
           UNNEST(JSON_QUERY_ARRAY(value, '$.featureFamilies')) AS feature_family
           WITH OFFSET where name = "Skew" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: feature_family {
    type: string
    sql: UPPER(SUBSTR(REPLACE(${TABLE}.feature_family,'_',' '),1,1))||SUBSTR(REPLACE(${TABLE}.feature_family,'_',' '),2) ;;
  }

  dimension: skew {
    type: number
    sql: CAST(${TABLE}.skew as NUMERIC) ;;
  }

  dimension: threshold {
    type: number
    sql: CAST(${TABLE}.threshold as NUMERIC) ;;
  }

  measure: _skew {
    type: average
    value_format_name: decimal_2
    sql: ${skew} ;;
  }

  measure: _threshold {
    type: average
    value_format_name: decimal_2
    sql: ${threshold} ;;
  }

  parameter: skew_threshold {
    type: unquoted
  }

  dimension: skew_relevant {
    type: yesno
    sql: ${skew} > {% parameter skew_threshold %};;
  }

  set: detail {
    fields: [
      feature_family,
      skew,
      threshold
    ]
  }
}
