view: slide_8_static_data {
    derived_table: {
      sql:
      SELECT
        'Circularity' AS aml_risk_label, 1 AS missed_by_aml_ai, 2 AS overlap, 56 AS newly_found_by_aml_ai, 3 AS total_previous_exits_based_on_threshold_, 8 AS total_previous_exits_original_, 66.7 AS recall, 25 AS recall___backward_calculation__overlap_percentage_, 1766.67 AS performance, 700 AS performance_uplift_
      UNION ALL
      SELECT
        'Deviation from customer profile' AS aml_risk_label, 0 AS missed_by_aml_ai, 0 AS overlap, 3 AS newly_found_by_aml_ai, 0 AS total_previous_exits_based_on_threshold_, 0 AS total_previous_exits_original_, 0 AS recall, 0 AS recall___backward_calculation__overlap_percentage_, 0 AS performance, 0 AS performance_uplift_
      UNION ALL
      SELECT
        'Deviation from peers' AS aml_risk_label, 0 AS missed_by_aml_ai, 5 AS overlap, 32 AS newly_found_by_aml_ai, 5 AS total_previous_exits_based_on_threshold_, 6 AS total_previous_exits_original_, 100 AS recall, 83.3 AS recall___backward_calculation__overlap_percentage_, 540 AS performance, 533 AS performance_uplift_
      UNION ALL
      SELECT
        'Dormancy accounts or companies' AS aml_risk_label, 0 AS missed_by_aml_ai, 0 AS overlap, 9 AS newly_found_by_aml_ai, 0 AS total_previous_exits_based_on_threshold_, 4 AS total_previous_exits_original_, 0 AS recall, 0 AS recall___backward_calculation__overlap_percentage_, 0 AS performance, 225 AS performance_uplift_
      UNION ALL
      SELECT
        'Funneling' AS aml_risk_label, 5 AS missed_by_aml_ai, 28 AS overlap, 170 AS newly_found_by_aml_ai, 33 AS total_previous_exits_based_on_threshold_, 28 AS total_previous_exits_original_, 84.8 AS recall, 100 AS recall___backward_calculation__overlap_percentage_, 415.15 AS performance, 607 AS performance_uplift_
      UNION ALL
      SELECT
        'High currency amounts' AS aml_risk_label, 0 AS missed_by_aml_ai, 1 AS overlap, 10 AS newly_found_by_aml_ai, 1 AS total_previous_exits_based_on_threshold_, 4 AS total_previous_exits_original_, 100 AS recall, 25 AS recall___backward_calculation__overlap_percentage_, 900 AS performance, 250 AS performance_uplift_
      UNION ALL
      SELECT
        'High risk jurisdiction' AS aml_risk_label, 0 AS missed_by_aml_ai, 1 AS overlap, 17 AS newly_found_by_aml_ai, 1 AS total_previous_exits_based_on_threshold_, 1 AS total_previous_exits_original_, 100 AS recall, 100 AS recall___backward_calculation__overlap_percentage_, 1600 AS performance, 1700 AS performance_uplift_
      UNION ALL
      SELECT
        'KYC activity mismatch' AS aml_risk_label, 1 AS missed_by_aml_ai, 2 AS overlap, 19 AS newly_found_by_aml_ai, 3 AS total_previous_exits_based_on_threshold_, 2 AS total_previous_exits_original_, 66.7 AS recall, 100 AS recall___backward_calculation__overlap_percentage_, 533.33 AS performance, 950 AS performance_uplift_
      UNION ALL
      SELECT
        'Large transaction volume' AS aml_risk_label, 1 AS missed_by_aml_ai, 0 AS overlap, 2 AS newly_found_by_aml_ai, 1 AS total_previous_exits_based_on_threshold_, 4 AS total_previous_exits_original_, 0 AS recall, 0 AS recall___backward_calculation__overlap_percentage_, 100 AS performance, 50 AS performance_uplift_
      UNION ALL
      SELECT
        'Multiple jurisdictions' AS aml_risk_label, 1 AS missed_by_aml_ai, 3 AS overlap, 18 AS newly_found_by_aml_ai, 4 AS total_previous_exits_based_on_threshold_, 3 AS total_previous_exits_original_, 75 AS recall, 100 AS recall___backward_calculation__overlap_percentage_, 350 AS performance, 600 AS performance_uplift_
      UNION ALL
      SELECT
        'Rapid movement of funds' AS aml_risk_label, 0 AS missed_by_aml_ai, 0 AS overlap, 13 AS newly_found_by_aml_ai, 0 AS total_previous_exits_based_on_threshold_, 0 AS total_previous_exits_original_, 0 AS recall, 0 AS recall___backward_calculation__overlap_percentage_, 0 AS performance, 0 AS performance_uplift_
      UNION ALL
      SELECT
        'Smurfing' AS aml_risk_label, 6 AS missed_by_aml_ai, 65 AS overlap, 425 AS newly_found_by_aml_ai, 71 AS total_previous_exits_based_on_threshold_, 72 AS total_previous_exits_original_, 91.5 AS recall, 90.3 AS recall___backward_calculation__overlap_percentage_, 498.59 AS performance, 590 AS performance_uplift_
      UNION ALL
      SELECT
        'Splitting' AS aml_risk_label, 3 AS missed_by_aml_ai, 15 AS overlap, 95 AS newly_found_by_aml_ai, 18 AS total_previous_exits_based_on_threshold_, 24 AS total_previous_exits_original_, 83.3 AS recall, 62.5 AS recall___backward_calculation__overlap_percentage_, 427.78 AS performance, 396 AS performance_uplift_
      UNION ALL
      SELECT
        'Suspicious repetitive patterns' AS aml_risk_label, 0 AS missed_by_aml_ai, 0 AS overlap, 5 AS newly_found_by_aml_ai, 0 AS total_previous_exits_based_on_threshold_, 1 AS total_previous_exits_original_, 0 AS recall, 0 AS recall___backward_calculation__overlap_percentage_, 0 AS performance, 500 AS performance_uplift_
      UNION ALL
      SELECT
        'Tax haven bank secrecy' AS aml_risk_label, 0 AS missed_by_aml_ai, 0 AS overlap, 7 AS newly_found_by_aml_ai, 0 AS total_previous_exits_based_on_threshold_, 1 AS total_previous_exits_original_, 0 AS recall, 0 AS recall___backward_calculation__overlap_percentage_, 0 AS performance, 700 AS performance_uplift_
      UNION ALL
      SELECT
        'Threshold avoidance' AS aml_risk_label, 0 AS missed_by_aml_ai, 4 AS overlap, 41 AS newly_found_by_aml_ai, 4 AS total_previous_exits_based_on_threshold_, 4 AS total_previous_exits_original_, 100 AS recall, 100 AS recall___backward_calculation__overlap_percentage_, 925 AS performance, 1025 AS performance_uplift_
      UNION ALL
      SELECT
        'Transaction volume in short period' AS aml_risk_label, 7 AS missed_by_aml_ai, 58 AS overlap, 361 AS newly_found_by_aml_ai, 65 AS total_previous_exits_based_on_threshold_, 63 AS total_previous_exits_original_, 89.2 AS recall, 92.1 AS recall___backward_calculation__overlap_percentage_, 455.38 AS performance, 573 AS performance_uplift_
      UNION ALL
      SELECT
        'Total' AS aml_risk_label, 25 AS missed_by_aml_ai, 184 AS overlap, 1283 AS newly_found_by_aml_ai, 209 AS total_previous_exits_based_on_threshold_, 225 AS total_previous_exits_original_, 88 AS recall, 81.8 AS recall___backward_calculation__overlap_percentage_, 501 AS performance, 553 AS performance_uplift_

      ;;
    }


  dimension: aml_risk_label {
    type: string
    sql: ${TABLE}.aml_risk_label ;;
  }

  measure: missed_by_aml_ai {
    type: sum
    sql: ${TABLE}.missed_by_aml_ai ;;
  }

  measure: overlap {
    type: sum
    sql: ${TABLE}.overlap ;;
  }

  measure: newly_found_by_aml_ai {
    type: sum
    sql: ${TABLE}.newly_found_by_aml_ai ;;
  }

  measure: total_previous_exits_based_on_threshold_ {
    type: sum
    sql: ${TABLE}.total_previous_exits_based_on_threshold_ ;;
  }

  measure: total_previous_exits_original_ {
    type: sum
    sql: ${TABLE}.total_previous_exits_original_ ;;
  }

  measure: recall {
    type: sum
    sql: (${TABLE}.recall)/100 ;;
    value_format_name: percent_0
  }

  measure: recall___backward_calculation__overlap_percentage_ {
    type: sum
    sql: (${TABLE}.recall___backward_calculation__overlap_percentage_)/100 ;;
    value_format_name: percent_0

  }

  measure: performance {
    type: sum
    sql: (${TABLE}.performance)/100 ;;
    value_format_name: percent_0

  }

  measure: performance_uplift_ {
    type: sum
    sql: (${TABLE}.performance_uplift_)/100 ;;
    value_format_name: percent_0

  }

}
