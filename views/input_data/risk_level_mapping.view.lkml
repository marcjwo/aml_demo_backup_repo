##Mock data by Lyndsey
view: risk_level_mapping {
    derived_table: {
      sql:
      SELECT
        'Circularity' AS risk_typology, 'High' AS risk_level
      UNION ALL
      SELECT
        'Deviation from customer profile' AS risk_typology, 'Medium' AS risk_level
      UNION ALL
      SELECT
        'Deviation from peers' AS risk_typology, 'Medium' AS risk_level
      UNION ALL
      SELECT
        'Dormany accounts or companies' AS risk_typology, 'Medium' AS risk_level
      UNION ALL
      SELECT
        'Funneling' AS risk_typology, 'High' AS risk_level
      UNION ALL
      SELECT
        'High currency amounts' AS risk_typology, 'High' AS risk_level
      UNION ALL
      SELECT
        'High risk jurisdiction' AS risk_typology, 'High' AS risk_level
      UNION ALL
      SELECT
        'KYC activity mismatch' AS risk_typology, 'High' AS risk_level
      UNION ALL
      SELECT
        'Large transaction volume' AS risk_typology, 'Medium' AS risk_level
      UNION ALL
      SELECT
        'Multiple jurisdictions' AS risk_typology, 'High' AS risk_level
      UNION ALL
      SELECT
        'Rapid movement of funds' AS risk_typology, 'High' AS risk_level
      UNION ALL
      SELECT
        'Smurfing' AS risk_typology, 'High' AS risk_level
      UNION ALL
      SELECT
        'Splitting' AS risk_typology, 'High' AS risk_level
      UNION ALL
      SELECT
        'Suspicious repetitive patterns' AS risk_typology, 'Medium' AS risk_level
      UNION ALL
      SELECT
        'Tax haven bank secrecy' AS risk_typology, 'High' AS risk_level
      UNION ALL
      SELECT
        'Threshold avoidance' AS risk_typology, 'High' AS risk_level
      UNION ALL
      SELECT
        'Transaction volume in short period' AS risk_typology, 'Medium' AS risk_level ;;
    }

    dimension: risk_typology {
      hidden: yes
      type: string
      sql: ${TABLE}.risk_typology ;;
    }

    dimension: risk_level {
      type: string
      sql: ${TABLE}.risk_level ;;
    }

  }
