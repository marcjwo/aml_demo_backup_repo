#explore: risk_case_event_enhanced_join {}

view: risk_case_event_enhanced_join {
#  sql_table_name: `finserv-looker-demo.enhancements_v3.risk_case_event_enhanced_join` ;;

#try this https://www.googlecloudcommunity.com/gc/Technical-Tips-Tricks/How-do-I-do-a-ROW-NUMBER-OVER-PARTITION-BY-with-a-table-calc/ta-p/588151
derived_table: {
  sql:
SELECT
   b.party_id,
   b.risk_score,
   b.risk_period_end_time,
   FORMAT_DATETIME("%b-%y",b.risk_period_end_time) AS risk_period_end_time_format,
   a.risk_case_event_id,
   a.event_time,
   FORMAT_DATETIME("%b-%y",a.event_time) AS event_time_format,
   a.type,
   a.party_id AS party,
   a.risk_case_id,
   a.risk_label,
   case when date(risk_period_end_time) between date_sub(date(date_trunc(minimum, month)), Interval 2 month) and date_sub(date(date_trunc(maximum, month)), Interval 2 month) and type = "AML_EXIT" then "Positive"
   else "Negative" end as label, a.minimum, a.maximum,
   ROW_NUMBER() OVER(PARTITION BY a.party_id, a.risk_case_id ORDER BY b.risk_score DESC) AS rank_risk
 FROM
   finserv-looker-demo.output_v3.predictions b
 FULL OUTER JOIN
   finserv-looker-demo.looker_view.view_4  a
 ON
   a.party_id = b.party_id
;;
persist_for: "24 hours"
}


  dimension: pk {
    type: string
    hidden: no
    primary_key: yes
    sql: FARM_FINGERPRINT(CONCAT(${party_id},${risk_period_end_raw},${event_raw},${risk_case_id},${risk_case_event_id}) ;;
  }

  dimension_group: event {
    type: time
    timeframes: [raw, time, date, week, month, month_name, quarter, year]
    sql: ${TABLE}.event_time ;;
  }
  dimension: event_time_format {
    type: string
    sql: ${TABLE}.event_time_format ;;
  }
  dimension: label {
    type: string
    sql: ${TABLE}.label ;;
  }
  dimension_group: maximum {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.maximum ;;
  }
  dimension_group: minimum {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.minimum ;;
  }
  dimension: party {
    type: string
    sql: ${TABLE}.party ;;
  }
  dimension: party_id {
    type: string
    sql: ${TABLE}.party_id ;;
  }
  dimension: risk_case_event_id {
    type: string
    sql: ${TABLE}.risk_case_event_id ;;
  }
  dimension: risk_case_id {
    type: string
    sql: ${TABLE}.risk_case_id ;;
  }
  dimension: risk_label {
    type: string
    sql: case when ${TABLE}.risk_label is null then 'Suspicious repetitive patterns' else ${TABLE}.risk_label end;;
  }
  dimension_group: risk_period_end {
    type: time
    timeframes: [raw, time, date, week, month,month_name, quarter, year]
    sql: ${TABLE}.risk_period_end_time ;;
  }
  dimension: risk_period_end_time_format {
    type: string
    sql: ${TABLE}.risk_period_end_time_format ;;
  }
  dimension: risk_score {
    type: number
    sql: ${TABLE}.risk_score ;;
  }
  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }
  dimension: rank_risk {
    type: number
    sql: ${TABLE}.rank_risk ;;
  }


  measure: party_count {
    type: count_distinct
    sql: ${party_id} ;;
  }

  measure: party_count_rank {
    type: count_distinct
    sql: ${party_id} ;;
    filters: [rank_risk: "1"]
  }

  # parameter: investigation_threshold {
  #   type: unquoted
  # }

  # measure: count_of_parties {
  #   type: number
  #   sql: CASE WHEN ${classification} =  'True Negative - Not in Rule'then count(${party_id})*{% parameter investigation_threshold %}
  #       WHEN ${classification}  = 'True Positive - Not in Rule' THEN count(${party_id})
  #   WHEN (${classification}  != 'True Positive - Not in Rule' OR ${classification}  !=  'True Negative - Not in Rule')
  #   AND ${rank_risk} = 1 THEN count(${party_id})*(1-{% parameter investigation_threshold %}) END;;
  # }


  ###added

  parameter: threshold { ## AML AI
    type: number
  }

  dimension: classification { ##classify
    type: string
    sql: CASE
      WHEN ${aml_ai} = true AND ${label} = 'Positive' AND ${type} IS NOT NULL AND ${rank_risk} = 1 THEN 'True Positive'
      WHEN ${aml_ai} = true AND ${label} = 'Negative' AND ${type} IS NOT NULL AND ${rank_risk} = 1 THEN 'True Positive - Not in Rule'
      WHEN ${aml_ai} = false AND ${label} = 'Negative' AND ${type} IS NOT NULL AND ${rank_risk} = 1 THEN 'True Negative'
      WHEN ${aml_ai} = false AND ${label} = 'Positive' AND ${type} IS NOT NULL AND ${rank_risk} = 1 THEN 'False Negative'
      WHEN ${aml_ai} = true AND ${label} = 'Negative' AND  ${type} IS NOT NULL THEN 'False Positive'
      WHEN ${aml_ai} = false AND ${label} = 'Negative'  AND ${type} IS NOT NULL THEN 'True Negative - Not in Rule'
      END ;;
   }


  dimension: aml_ai {
    type: string
    sql: CASE
          WHEN  ${risk_score} IS NOT NULL
          AND ${risk_score} >= {% parameter threshold %} THEN true
          ELSE false
          end;;
  }


  parameter: threshold_fp {
    type: unquoted
  }


  dimension: rule_based {
    type: string
       sql: CASE
              WHEN ${type} = 'AML_PROCESS_END' AND ${label} = 'Negative' THEN 'False positive'
              WHEN ${type} = 'AML_EXIT' AND ${label} = 'Positive' THEN 'True positive'
                ELSE 'True Positive'
          END;;
    }

  # dimension: venn_diagram { ## not needed
  #   type: string
  #   sql:     CASE
  #     WHEN ${classification} = 'True Positive'  then 'Rules Based & AML AI'
  #     WHEN (${classification} = 'False Negative' or  ${classification} = 'True Positive') then 'Rules Based'
  #     WHEN ( ${classification} = 'True Positive - Not in Rule' or ${classification} = 'True Positive') then 'AML AI'
  #   END
  #   ;;
  # }

  dimension: venn_diagram { ## not needed
    type: string
    sql:     CASE
      WHEN ${classification} = 'True Positive'  then 'Rules Based & AML AI'
      WHEN ${classification} = 'False Negative' then 'Rules Based'
      WHEN ${classification} = 'True Positive - Not in Rule'  then 'AML AI'
    END
    ;;
    }

  measure: total_rules_based {
    type: count_distinct
    sql:  case when ${venn_diagram} = 'Rules Based'or ${venn_diagram} = 'Rules Based & AML AI' then ${party_id} end  ;;
  }

  measure: total_aml_ai{
    type: count_distinct
    sql: case when ${venn_diagram} = 'AML AI'or ${venn_diagram} = 'Rules Based & AML AI' then ${party_id} end ;;
  }

  measure: total_rules_based_and_aml_ai {
    type: count_distinct
    sql:  case when ${venn_diagram} = 'Rules Based & AML AI' then ${party_id} end  ;;
  }





  #############################
    ##old logic
  # sql: CASE
  # WHEN ${type} = 'AML_PROCESS_END' AND (${label} = 'Negative' AND ${type} IS NOT NULL) THEN 'False positive'
  # WHEN ${type} = 'AML_EXIT' AND (${label} = 'Positive'  AND ${type} IS  NULL) THEN 'True positive'
  # END;;
  ##############################

    # dimension: aml_ai_fp_ind {
  #   type: string
  #   sql:
  #   CASE
  #     WHEN ${aml_ai} AND ${investigation_threshold} <= {% parameter threshold_fp %} THEN 'True positive'
  #     WHEN ${aml_ai} AND ${investigation_threshold} > {% parameter threshold_fp %} THEN 'False positive'
  #   END
  #   ;;
  # }
  # dimension: investigation_threshold { ##fp
  #   type: number
  #   sql:
  #     CASE
  #             WHEN ${risk_period_end_raw} IS NOT NULL AND ${event_raw} IS NULL THEN RAND()
  #             WHEN ${risk_period_end_raw} IS NOT NULL AND  ${event_raw} IS NOT NULL THEN RAND()
  #             END;;
  # }

  # dimension: net_new_indicator { ## venn diagram
  #   type: string
  #   sql:
  #   CASE
  #     WHEN ${rule_based} = 'True positive' AND ${aml_ai_fp_ind} = 'True positive' then 'AML AI & Rules Based' --aml ai & rules based
  #     WHEN ${rule_based} = 'True positive' AND ${aml_ai_fp_ind} IS NULL then 'Rules Based'
  #     WHEN ${rule_based} = 'False positive'AND ${aml_ai_fp_ind} = 'True positive' then 'AML AI'
  #     WHEN ${rule_based} IS NULL and ${aml_ai_fp_ind} = 'True positive' then 'AML AI'
  #   END;;
  # }


  # dimension: model_output {
  #   type: string
  #   sql: case when ${classification} = 'True Positive' ;;
  # }





}
