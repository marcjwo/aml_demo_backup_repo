view: engineconfigmetadata {
  derived_table: {
    sql:
    SELECT
  JSON_EXTRACT_SCALAR(feature_family, '$.featureFamily') AS feature_family,
  CAST(JSON_EXTRACT_SCALAR(feature_family, '$.missingnessValue') AS NUMERIC) AS missingness_value,
  "Tuning" as operation
FROM `finserv-looker-demo.output_v3.engine-config-metadata`,
     UNNEST(JSON_QUERY_ARRAY(value, '$.featureFamilies')) AS feature_family
     WITH OFFSET where name = "Missingness"

UNION ALL

SELECT
  JSON_EXTRACT_SCALAR(feature_family, '$.featureFamily') AS feature_family,
  CAST(JSON_EXTRACT_SCALAR(feature_family, '$.missingnessValue') AS NUMERIC) AS missingness_value,
  "Training" as operation
FROM `finserv-looker-demo.output_v3.model-metadata`,
     UNNEST(JSON_QUERY_ARRAY(value, '$.featureFamilies')) AS feature_family
     WITH OFFSET where name = "Missingness"

UNION ALL

  SELECT
  JSON_EXTRACT_SCALAR(feature_family, '$.featureFamily') AS feature_family,
  CAST(JSON_EXTRACT_SCALAR(feature_family, '$.missingnessValue') AS NUMERIC) AS missingness_value,
  "Backtest" as operation
FROM `finserv-looker-demo.output_v3.backtest`,
     UNNEST(JSON_QUERY_ARRAY(value, '$.featureFamilies')) AS feature_family
     WITH OFFSET where name = "Missingness"

UNION ALL

SELECT
  JSON_EXTRACT_SCALAR(feature_family, '$.featureFamily') AS feature_family,
  CAST(JSON_EXTRACT_SCALAR(feature_family, '$.missingnessValue') AS NUMERIC) AS missingness_value,
  "Prediction" as operation
FROM `finserv-looker-demo.output_v3.prediction-results-metadata`,
     UNNEST(JSON_QUERY_ARRAY(value, '$.featureFamilies')) AS feature_family
     WITH OFFSET where name = "Missingness" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }
  dimension: resource_id {
    type: string
    sql: ${TABLE}.resource_id ;;
  }
  dimension: resource_type {
    type: string
    sql: ${TABLE}.resource_type ;;
  }
  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }
  measure: count {
    type: count
    drill_fields: [name]
  }

  ###

  dimension: operation {
    type: string
    sql: ${TABLE}.operation ;;
  }

  dimension: feature_family {
    type: string
    sql: ${TABLE}.feature_family ;;
  }

  dimension: missingness_value {
    type: number
    sql: ${TABLE}.missingness_value ;;
  }

  measure: sum_missingness_value {
    type: sum
    value_format_name: decimal_2
    sql: ${missingness_value} ;;
  }
}
