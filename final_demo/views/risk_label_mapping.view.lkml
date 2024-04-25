
view: risk_label_mapping {
  derived_table: {
    sql: WITH
       A AS (
       SELECT
         DISTINCT risk_case_id
       FROM
         `finserv-looker-demo.input_v3.risk_case_event`
       WHERE
         type = "AML_EXIT"),
       B AS (
       SELECT
         *,
         CASE
           WHEN MOD(ROW_NUMBER() OVER (), 3) = 0 THEN 'label_1'
           WHEN MOD(ROW_NUMBER() OVER (), 5) = 0 THEN 'label_2'
           WHEN MOD(ROW_NUMBER() OVER (), 7) = 0 THEN 'label_3'
           WHEN MOD(ROW_NUMBER() OVER (), 11) = 0 THEN 'label_4'
           WHEN MOD(ROW_NUMBER() OVER (), 13) = 0 THEN 'label_5'
           WHEN MOD(ROW_NUMBER() OVER (), 17) = 0 THEN 'label_6'
           WHEN MOD(ROW_NUMBER() OVER (), 19) = 0 THEN 'label_7'
           WHEN MOD(ROW_NUMBER() OVER (), 23) = 0 THEN 'label_8'
           WHEN MOD(ROW_NUMBER() OVER (), 29) = 0 THEN 'label_9'
           WHEN MOD(ROW_NUMBER() OVER (), 31) = 0 THEN 'label_10'
           WHEN MOD(ROW_NUMBER() OVER (), 37) = 0 THEN 'label_11'
           WHEN MOD(ROW_NUMBER() OVER (), 41) = 0 THEN 'label_12'
           WHEN MOD(ROW_NUMBER() OVER (), 43) = 0 THEN 'label_13'
           WHEN MOD(ROW_NUMBER() OVER (), 47) = 0 THEN 'label_14'
           WHEN MOD(ROW_NUMBER() OVER (), 53) = 0 THEN 'label_15'
           WHEN MOD(ROW_NUMBER() OVER (), 56) = 0 THEN 'label_16'
         ELSE
         'label_17'
       END
         AS label_id
       FROM
         A )
      SELECT
       B.risk_case_id,
       C.risk_label
      FROM
       B
      LEFT JOIN
       (SELECT
       "Smurfing" AS risk_label,
       "label_1" AS label_id
      UNION ALL
      SELECT
       "Funneling",
       "label_2"
      UNION ALL
      SELECT
       "Splitting",
       "label_3"
      UNION ALL
      SELECT
       "Circularity",
       "label_4"
      UNION ALL
      SELECT
       "Threshold avoidance",
       "label_5"
      UNION ALL
      SELECT
       "Deviation from peers",
       "label_6"
      UNION ALL
      SELECT
       "High currency amounts",
       "label_7"
      UNION ALL
      SELECT
       "KYC activity mismatch",
       "label_8"
      UNION ALL
      SELECT
       "High risk jurisdiction",
       "label_9"
      UNION ALL
      SELECT
       "Multiple jurisdictions",
       "label_10"
      UNION ALL
      SELECT
       "Tax haven bank secrecy",
       "label_11"
      UNION ALL
      SELECT
       "Rapid movement of funds",
       "label_12"
      UNION ALL
      SELECT
       "Large transaction volume",
       "label_13"
      UNION ALL
      SELECT
       "Dormancy accounts or companies",
       "label_14"
      UNION ALL
      SELECT
       "Suspicious repetitive patterns",
       "label_15"
      UNION ALL
      SELECT
       "Deviation from customer profile",
       "label_16"
      UNION ALL
      SELECT
       "Transaction volume in short period",
       "label_17") C
      ON
       B.label_id=C.label_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: risk_case_id {
    type: string
    sql: ${TABLE}.risk_case_id ;;
  }

  dimension: risk_label {
    type: string
    sql: ${TABLE}.risk_label ;;
  }

  set: detail {
    fields: [
        risk_case_id,
        risk_label
    ]
  }
}
