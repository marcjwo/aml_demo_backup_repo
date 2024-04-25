# include: "/updated_version/predictions.view.lkml"
# view: +predictions{


#   parameter: threshold {
#     type: unquoted
#   }

#   dimension: aml_ai {
#     type: string
#     sql: CASE
#           WHEN ${risk_score} IS NOT NULL
#           AND (${risk_score}*100) >= {% parameter threshold %} THEN true
#           ELSE false
#           end;;
#   }

#   parameter: threshold_fp {
#     type: unquoted
#   }

#   # dimension: aml_ai_fp_ind {
#   #   type: string
#   #   sql:
#   #   CASE
#   #     WHEN ${aml_ai} AND (${investigation_threshold}*100) <= {% parameter threshold_fp %}  'True positive'
#   #     WHEN ${aml_ai} AND (${investigation_threshold}*100) > {% parameter threshold_fp %} THEN 'False positive'
#   #   END
#   #   ;;
# # }
#   dimension: aml_ai_fp_ind {
#     type: string
#     sql:
#     CASE
#       WHEN ${aml_ai} AND (${investigation_threshold}*100) <= {% parameter threshold_fp %} AND ${label} = 'Positive' THEN  'True positive'
#       WHEN ${aml_ai} AND (${investigation_threshold}*100) > {% parameter threshold_fp %} AND ${label} = 'Negative' THEN 'False positive'
#     END
#     ;;
#   }
#   #   CASE
#   # WHEN aml_ai = TRUE AND label = "Positive" AND type IS NOT NULL THEN 'True Positive'
#   # WHEN aml_ai = TRUE AND label = "Negative" AND type IS NOT NULL THEN 'False Positive'
#   # WHEN aml_ai = FALSE AND label = "Negative" AND type IS NOT NULL THEN 'True Negative'
#   # WHEN aml_ai = FALSE AND label = "Positive" AND type IS NOT NULL THEN 'False Negative'
#   # WHEN aml_ai = TRUE AND label = "Negative" AND type IS NULL THEN 'True Positive - Not in Rule'
#   # WHEN aml_ai = FALSE AND label = "Negative"AND type IS NULL THEN 'True Negative - Not in Rule'



#   dimension: indicator {
#     type: string
#     sql:CASE
#               WHEN ${risk_period_end_raw}  IS NOT NULL AND ${risk_case_event_summary.event_time_raw} IS NOT NULL THEN "Present in both"
#               WHEN ${risk_period_end_raw} IS NOT NULL
#             AND  ${risk_case_event_summary.event_time_raw} IS NULL THEN "Present in AML AI"
#               WHEN ${risk_period_end_raw} IS NULL AND ${risk_case_event_summary.event_time_raw} IS NOT NULL THEN "Present in rule based only"
#           END
#         ;;
#   }
#   dimension: investigation_threshold {
#     type: string
#     sql: CASE
#           WHEN ${risk_period_end_raw} IS NOT NULL
#             AND ${risk_case_event_summary.event_time_raw} IS NULL THEN RAND()
#           WHEN ${risk_period_end_raw} IS NOT NULL AND ${risk_case_event_summary.event_time_raw} IS NOT NULL THEN RAND()
#           END;;
#   }


#   dimension: label {
#     type: string
#     sql:case when (${risk_period_end_date} >= date_sub(${risk_case_event_summary.minimum_date}, Interval 2 month) and ${risk_period_end_date} <= date_sub(${risk_case_event_summary.maximum_date}, Interval 2 month)) and type = "AML_EXIT"
#     then "Positive"
#     else "Negative" end;;
#   }

#     dimension: rule_based {
#       type: string
#       sql: CASE
#               WHEN ${type} = 'AML_PROCESS_END' THEN 'False positive'
#               WHEN ${type} = 'AML_EXIT' THEN 'True positive'
#           END;;
#         }

#   dimension: net_new_indicator {
#     type: string
#     sql:
#     CASE
#       WHEN ${rule_based} = 'True positive' AND ${aml_ai_fp_ind} = 'True positive' then '1_Detected'
#       WHEN ${rule_based} = 'True positive' AND ${aml_ai_fp_ind} IS NULL then '2_Rule based exit'
#       WHEN ${rule_based} = 'False positive'AND ${aml_ai_fp_ind} = 'True positive' then '3_AML AI Exit'
#       WHEN ${rule_based} IS NULL and ${aml_ai_fp_ind} = 'True positive' then '3_AML AI Exit'
#     END
#     ;;
#   }



#   # dimension: evaluation_output {
#   #   type: string
#   #   sql:
#   #   CASE
#   #     WHEN ${rule_based} = 'True positive' AND ${aml_ai_fp_ind} = 'True positive' then 'Missed by AML AI'
#   #     WHEN ${rule_based} = 'True positive' AND ${aml_ai_fp_ind} IS NULL then 'Overlap'
#   #     WHEN ${rule_based} = 'False positive'AND ${aml_ai_fp_ind} = 'True positive' then 'Newly found by AML AI'
#   #     WHEN ${rule_based} IS NULL and ${aml_ai_fp_ind} = 'True positive' then 'Newly found by AML AI'
#   #   END
#   #   ;;
#   # }


#   dimension: aml_classification {
#     type: string
#     sql:
#     CASE

#                             WHEN ${aml_ai} = true AND ${rule_based} = 'True Positive' THEN "True positive"
#                             WHEN ${aml_ai} = true AND ${rule_based} = 'False positive' THEN "False positive"
#                             WHEN ${aml_ai} = false AND ${rule_based} = 'False positive' THEN "True negative"
#                             WHEN ${aml_ai} = false AND ${rule_based} = 'True positive' THEN "False negative"
#                             WHEN ${indicator} = 'Present in rule based only' THEN "Out of Scope AML AI"
#                             WHEN ${aml_ai} = true AND ${rule_based} IS NULL THEN 'True Positive - Not in Rule'
#                             WHEN ${aml_ai} = false AND ${rule_based} IS NULL THEN 'True negative - Not in Rule'
#                           END
#                       ;;

#   }



#   dimension: classification {
#     type: string
#     sql: CASE

#                             WHEN ${aml_ai} = true AND ${rule_based} = 'True Positive' THEN "True positive"
#                             WHEN ${aml_ai} = true AND ${rule_based} = 'False positive' THEN "False positive"
#                             WHEN ${aml_ai} = false AND ${rule_based} = 'False positive' THEN "True negative"
#                             WHEN ${aml_ai} = false AND ${rule_based} = 'True positive' THEN "False negative"
#                             WHEN ${indicator} = 'Present in rule based only' THEN "Out of Scope AML AI"
#                             WHEN ${aml_ai} = true AND ${rule_based} IS NULL THEN 'True Positive - Not in Rule'
#                             WHEN ${aml_ai} = false AND ${rule_based} IS NULL THEN 'True negative - Not in Rule'
#                           END
#                       ;;
#   }

#   dimension: classification_v2{
#     type: string
#     sql: CASE

#                                   WHEN ${aml_ai} = true AND ${rule_based} = 'True positive' THEN "True positive"
#                                   WHEN ${aml_ai} = true AND ${rule_based} = 'False positive' THEN "False positive"
#                                   WHEN ${aml_ai} = false AND ${rule_based} = 'False positive' THEN "True negative"
#                                   WHEN ${aml_ai} = false AND ${rule_based} = 'True positive' THEN "False negative"
#                                   WHEN ${indicator} = 'Present in rule based only' THEN "Out of Scope AML AI"
#                                   WHEN ${aml_ai} = true AND ${rule_based} IS NULL THEN 'True Positive - Not in Rule'
#                                   WHEN ${aml_ai} = false AND ${rule_based} IS NULL THEN 'True negative - Not in Rule'
#                                 END
#                             ;;
#   }


#   measure: party_count {
#     type: count_distinct
#     sql: ${party_id} ;;
#   }

#   measure: slider {
#     type: number
#   }

#   measure: slider_fp {
#     type: number
#   }

#   dimension: pk {
#     type: string
#     hidden: no
#     primary_key: yes
#     sql: FARM_FINGERPRINT(CONCAT(${TABLE}.date,${TABLE}.party_id)) ;;
#   }

#   measure: avg_risk_score {
#     type: average
#     label: "Risk Score"
#     value_format_name: percent_2
#     sql: ${risk_score} ;;
#   }

# }
