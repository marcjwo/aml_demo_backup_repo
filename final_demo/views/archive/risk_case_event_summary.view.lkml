view: risk_case_event_summary {
 derived_table: {
#   sql: with data_1 as (
#       select risk_case_id, count(*) as counter, min(event_time) as minimum, max(event_time) as maximum
#       from finserv-looker-demo.input_v3.risk_case_event group by risk_case_id)
#       select a.*,b.minimum,b.maximum, CASE
#           WHEN counter = 2 THEN "Negative"
#           WHEN counter = 3 THEN "Positive"
#       END as label
#       from finserv-looker-demo.input_v3.risk_case_event a join data_1 b on
#       a.risk_case_id = b.risk_case_id ;;
  sql: with view_4 as (  SELECT
      a.*,
      b.risk_label
      FROM (with data_1 as (
      select risk_case_id, count(*) as counter, min(event_time) as minimum, max(event_time) as maximum from finserv-looker-demo.input_v3.risk_case_event group by risk_case_id)
      select a.*,b.minimum,b.maximum, CASE
           WHEN counter = 2 THEN "Negative"
           WHEN counter = 3 THEN "Positive"
       END as label
       from finserv-looker-demo.input_v3.risk_case_event a join data_1 b on
       a.risk_case_id = b.risk_case_id) a
      LEFT JOIN `finserv-looker-demo.looker_view.view_1` b
      ON a.risk_case_id = b.risk_case_id
      where ((type = 'AML_EXIT' and label = "Positive") or (type = 'AML_PROCESS_END' and label = "Negative"))
  )

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
         else "Negative" end as label,
        a.minimum,
        a.maximum
       FROM
         finserv-looker-demo.output_v3.predictions b
       FULL OUTER JOIN view_4 a
       ON
         a.party_id = b.party_id ;;
}

measure: count {
  type: count
  drill_fields: [detail*]
}

dimension: party_id {
  type: string
  sql: ${TABLE}.party_id ;;
}

dimension: risk_score {
  type: number
  sql: ${TABLE}.risk_score ;;
}

dimension_group: risk_period_end_time {
  type: time
  sql: ${TABLE}.risk_period_end_time ;;
}

dimension: risk_period_end_time_format {
  type: string
  sql: ${TABLE}.risk_period_end_time_format ;;
}

dimension: risk_case_event_id {
  type: string
  sql: ${TABLE}.risk_case_event_id ;;
}

  dimension_group: event_time {
    label: "Event"
    timeframes: [raw,time,date,month,year]
    type: time
    sql: ${TABLE}.event_time ;;
  }
  dimension_group: event_time_formatted {
    type: time
    timeframes: [raw,time,date,month,year]
    label: "Event"
    sql: FORMAT_DATETIME("%b-%y",${event_time_raw});;
  }

dimension: type {
  type: string
  sql: ${TABLE}.type ;;
}

dimension: party {
  type: string
  sql: ${TABLE}.party ;;
}

dimension: risk_case_id {
  type: string
  sql: ${TABLE}.risk_case_id ;;
}

dimension: risk_label {
  type: string
  sql: ${TABLE}.risk_label ;;
}

dimension: label {
  type: string
  sql: ${TABLE}.label ;;
}

dimension_group: minimum {
  type: time
  sql: ${TABLE}.minimum ;;
}

dimension_group: maximum {
  type: time
  sql: ${TABLE}.maximum ;;
}

set: detail {
  fields: [
    party_id,
    risk_score,
    risk_period_end_time_time,
    risk_period_end_time_format,
    risk_case_event_id,
    event_time_raw,
    event_time_formatted_raw,
    type,
    party,
    risk_case_id,
    risk_label,
    label,
    minimum_time,
    maximum_time
  ]
}

### added

  parameter: threshold {
    type: unquoted
  }

  dimension: aml_ai {
    type: string
    sql: CASE
          WHEN ${risk_score} IS NOT NULL
          AND (${risk_score}*100) >= {% parameter threshold %} THEN true
          ELSE false
          end;;
  }

  parameter: threshold_fp {
    type: unquoted
  }

  # dimension: aml_ai_fp_ind {
  #   type: string
  #   sql:
  #   CASE
  #     WHEN ${aml_ai} AND (${investigation_threshold}*100) <= {% parameter threshold_fp %}  'True positive'
  #     WHEN ${aml_ai} AND (${investigation_threshold}*100) > {% parameter threshold_fp %} THEN 'False positive'
  #   END
  #   ;;
  # }
  dimension: aml_ai_fp_ind {
    type: string
    sql:
    CASE
      WHEN ${aml_ai} AND (${investigation_threshold}*100) <= {% parameter threshold_fp %} AND ${label} = 'Positive' THEN  'True positive'
      WHEN ${aml_ai} AND (${investigation_threshold}*100) > {% parameter threshold_fp %} AND ${label} = 'Negative' THEN 'False positive'
    END
    ;;
  }



  dimension: indicator {
    type: string
    sql:CASE
              WHEN ${predictions.risk_period_end_raw}  IS NOT NULL AND ${event_time_raw} IS NOT NULL THEN "Present in both"
              WHEN ${predictions.risk_period_end_raw} IS NOT NULL
            AND  ${event_time_raw} IS NULL THEN "Present in AML AI"
              WHEN ${predictions.risk_period_end_raw} IS NULL AND ${event_time_raw} IS NOT NULL THEN "Present in rule based only"
          END
        ;;
  }
  dimension: investigation_threshold {
    type: string
    sql: CASE
          WHEN ${predictions.risk_period_end_raw} IS NOT NULL
            AND ${event_time_raw} IS NULL THEN RAND()
          WHEN ${predictions.risk_period_end_raw} IS NOT NULL AND ${event_time_raw} IS NOT NULL THEN RAND()
          END;;
  }


  # dimension: label {
  #   type: string
  #   sql:case when (${predictions.risk_period_end_date} >= date_sub(${risk_case_event_summary.minimum_date}, Interval 2 month) and ${risk_period_end_date} <= date_sub(${risk_case_event_summary.maximum_date}, Interval 2 month)) and type = "AML_EXIT"
  #         then "Positive"
  #         else "Negative" end;;
  # }

  dimension: rule_based {
    type: string
    sql: CASE
              WHEN ${type} = 'AML_PROCESS_END' THEN 'False positive'
              WHEN ${type} = 'AML_EXIT' THEN 'True positive'
          END;;
  }

  dimension: net_new_indicator {
    type: string
    sql:
    CASE
      WHEN ${rule_based} = 'True positive' AND ${aml_ai_fp_ind} = 'True positive' then '1_Detected'
      WHEN ${rule_based} = 'True positive' AND ${aml_ai_fp_ind} IS NULL then '2_Rule based exit'
      WHEN ${rule_based} = 'False positive'AND ${aml_ai_fp_ind} = 'True positive' then '3_AML AI Exit'
      WHEN ${rule_based} IS NULL and ${aml_ai_fp_ind} = 'True positive' then '3_AML AI Exit'
    END
    ;;
  }


  # dimension: evaluation_output {
  #   type: string
  #   sql:
  #   CASE
  #     WHEN ${rule_based} = 'True positive' AND ${aml_ai_fp_ind} = 'True positive' then 'Missed by AML AI'
  #     WHEN ${rule_based} = 'True positive' AND ${aml_ai_fp_ind} IS NULL then 'Overlap'
  #     WHEN ${rule_based} = 'False positive'AND ${aml_ai_fp_ind} = 'True positive' then 'Newly found by AML AI'
  #     WHEN ${rule_based} IS NULL and ${aml_ai_fp_ind} = 'True positive' then 'Newly found by AML AI'
  #   END
  #   ;;
  # }


  # dimension: classification {
  #   type: string
  #   sql:
  #   CASE

  #                                       WHEN ${aml_ai} = true AND ${rule_based} = 'True Positive' THEN "True positive"
  #                                       WHEN ${aml_ai} = true AND ${rule_based} = 'False positive' THEN "False positive"
  #                                       WHEN ${aml_ai} = false AND ${rule_based} = 'False positive' THEN "True negative"
  #                                       WHEN ${aml_ai} = false AND ${rule_based} = 'True positive' THEN "False negative"
  #                                       WHEN ${indicator} = 'Present in rule based only' THEN "Out of Scope AML AI"
  #                                       WHEN ${aml_ai} = true AND ${rule_based} IS NULL THEN 'True Positive - Not in Rule'
  #                                       WHEN ${aml_ai} = false AND ${rule_based} IS NULL THEN 'True negative - Not in Rule'
  #                                     END
  #                                 ;;

  # }



  dimension: classification {
    type: string
    sql: CASE

                                        WHEN ${aml_ai} = true AND ${label} = 'True Positive' THEN "True positive"
                                        WHEN ${aml_ai} = true AND ${label} = 'False positive' THEN "False positive"
                                        WHEN ${aml_ai} = false AND ${label} = 'False positive' THEN "True negative"
                                        WHEN ${aml_ai} = false AND ${label} = 'True positive' THEN "False negative"
                                        WHEN ${indicator} = 'Present in rule based only' THEN "Out of Scope AML AI"
                                        WHEN ${aml_ai} = true AND ${label} IS NULL THEN 'True Positive - Not in Rule'
                                        WHEN ${aml_ai} = false AND ${label} IS NULL THEN 'True negative - Not in Rule'
                                      END
                                  ;;
  }

  # dimension: classification_v2{
  #   type: string
  #   sql: CASE

  #                                             WHEN ${aml_ai} = true AND ${rule_based} = 'True positive' THEN "True positive"
  #                                             WHEN ${aml_ai} = true AND ${rule_based} = 'False positive' THEN "False positive"
  #                                             WHEN ${aml_ai} = false AND ${rule_based} = 'False positive' THEN "True negative"
  #                                             WHEN ${aml_ai} = false AND ${rule_based} = 'True positive' THEN "False negative"
  #                                             WHEN ${indicator} = 'Present in rule based only' THEN "Out of Scope AML AI"
  #                                             WHEN ${aml_ai} = true AND ${rule_based} IS NULL THEN 'True Positive - Not in Rule'
  #                                             WHEN ${aml_ai} = false AND ${rule_based} IS NULL THEN 'True negative - Not in Rule'
  #                                           END
  #                                       ;;
  # }


  measure: party_count {
    type: count_distinct
    sql: ${party_id} ;;
  }

  measure: slider {
    type: number
  }

  measure: slider_fp {
    type: number
  }

  dimension: pk {
    type: string
    hidden: no
    primary_key: yes
    sql: FARM_FINGERPRINT(CONCAT(${TABLE}.date,${TABLE}.party_id)) ;;
  }

  measure: avg_risk_score {
    type: average
    label: "Risk Score"
    value_format_name: percent_2
    sql: ${risk_score} ;;
  }



 }
