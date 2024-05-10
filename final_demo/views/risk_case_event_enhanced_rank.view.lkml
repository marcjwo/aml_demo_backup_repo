view: risk_case_event_enhanced_rank {
# If necessary, uncomment the line below to include explore_source.
# include: "output_evaluation.explore.lkml"
    derived_table: {
      sql: select *, ROW_NUMBER() OVER(PARTITION BY party_id, risk_case_id ORDER BY risk_score DESC) as rank_risk from {risk_case_event_enhanced_join.SQL_TABLE_NAME} AS risk_case_event_enhanced_final   ;;
        }

  dimension: pk {
    type: string
    hidden: no
    primary_key: yes
    sql: FARM_FINGERPRINT(CONCAT(${TABLE}.date,${TABLE}.party_id)) ;;
  }

    dimension: party_id {
      description: ""
    }
    dimension: risk_case_id {
      description: ""
    }
    dimension: risk_score {
      description: ""
      type: number
    }
    dimension: risk_rank {
      description: ""
      type: number

    }
  }
