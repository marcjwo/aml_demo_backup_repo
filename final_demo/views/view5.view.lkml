
view: view5 {
  derived_table: {
    sql: SELECT
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
       "label_17" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: risk_label {
    type: string
    sql: ${TABLE}.risk_label ;;
  }

  dimension: label_id {
    type: string
    sql: ${TABLE}.label_id ;;
  }

  set: detail {
    fields: [
        risk_label,
	label_id
    ]
  }
}
