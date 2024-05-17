# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
# explore: explainability {
#   hidden: yes
#     join: explainability__attributions {
#       view_label: "Explainability: Attributions"
#       sql: LEFT JOIN UNNEST(${explainability.attributions}) as explainability__attributions ;;
#       relationship: one_to_many
#     }
# }
view: explainability {
  sql_table_name: `finserv-looker-demo.output_v3.explainability` ;;

  dimension: attributions {
    hidden: yes
    sql: ${TABLE}.attributions ;;
  }
  dimension: party_id {
    type: string
    sql: ${TABLE}.party_id ;;
  }
  dimension_group: risk_period_end {
    type: time
    timeframes: [raw, time, date, week, month, month_name,quarter, year]
    sql: ${TABLE}.risk_period_end_time ;;
  }
  measure: count {
    type: count
  }
}

view: explainability__attributions {

  dimension: attribution {
    type: number
    sql: attribution ;;
  }
  dimension: explainability__attributions {
    type: string
    hidden: yes
    sql: explainability__attributions ;;
  }
  dimension: feature_family {
    type: string
    sql: UPPER(SUBSTR(REPLACE(feature_family,'_',' '),1,1))||SUBSTR(REPLACE(feature_family,'_',' '),2) ;;
  }
  measure: _attribution {
    type: average
    sql: ${attribution} ;;
    value_format_name: decimal_2
    link: {
      label: "View Attribution Overview"
      url: "/dashboards/15?&Feature+Family={{ feature_family_desc.feature_family_name }}&Party+ID={{ _filters['explainability.party_id'] | url_encode }}&Party+Name={{ _filters['party_fullname_mapping.full_name'] | url_encode }}&Risk+Period+End+Month={{ _filters['explainability.risk_period_end_month'] | url_encode }}&Risk+Period+End+Date={{ _filters['explainability.risk_period_end_date'] | url_encode }}"
    }
  }
}
