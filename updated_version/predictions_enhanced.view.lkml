
# view: predictions_enhanced {
#   sql_table_name:'finserv-looker-demo.enhancements_v3.predictions_enhanced`;;


#   measure: count {
#     type: count
#     drill_fields: [detail*]
#   }

#   dimension: party_id {
#     type: string
#     sql: ${TABLE}.party_id ;;
#   }

#   dimension_group: risk_period_end_time {
#     type: time
#     sql: ${TABLE}.risk_period_end_time ;;
#   }

#   dimension: risk_score {
#     type: number
#     sql: ${TABLE}.risk_score ;;
#   }

#   dimension: risk_label {
#     label: "AI AML Risk Label"
#     type: string
#     sql: ${TABLE}.risk_label ;;
#   }

#   dimension: usable_risk_label {
#     label: " Usable Risk Label"
#     type: string
#     sql: CASE WHEN ${evaluation.risk_label} IS NOT NULL THEN ${evaluation.risk_label} ELSE ${risk_label} END;;
#   }


#   set: detail {
#     fields: [
#       party_id,
#       risk_period_end_time_time,
#       risk_score,
#       risk_label
#     ]
#   }

# }
