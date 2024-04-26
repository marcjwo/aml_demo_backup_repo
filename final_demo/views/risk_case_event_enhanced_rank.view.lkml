view: risk_case_event_enhanced_rank {
# If necessary, uncomment the line below to include explore_source.
# include: "output_evaluation.explore.lkml"
    derived_table: {
      explore_source: evaluation {
        column: party_id {}
        column: risk_case_id { field: risk_label_mapping.risk_case_id }
        column: risk_score {}
        derived_column: risk_rank {
          sql: ROW_NUMBER() OVER(PARTITION BY party_id, risk_case_id ORDER BY risk_score DESC)  ;;
        }
      }
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
