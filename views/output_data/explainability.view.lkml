# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: explainability {
  hidden: no
    join: explainability__attributions {
      view_label: "Explainability: Attributions"
      sql: LEFT JOIN UNNEST(${explainability.attributions}) as explainability__attributions ;;
      relationship: one_to_many
    }
}
view: explainability {
  sql_table_name: `finserv-looker-demo.outputs.explainability` ;;

  dimension: attributions {
    hidden: yes
    sql: ${TABLE}.attributions ;;
  }
  dimension: party_id {
    link: {label: "Open dashboard with customer risk events"
           url: "https://cloudcenorthamfinserv.cloud.looker.com/dashboards/27?Risk+Case+Event+ID=-NULL&Party+ID={{value}}"}
    type: string
    # hidden: yes
    sql: ${TABLE}.party_id ;;
  }
  dimension_group: risk_period_end {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.risk_period_end_time ;;
  }
  measure: count {
    type: count
    drill_fields: [party.party_id]
  }
}

view: explainability__attributions {

  dimension: attribution {
    type: number
    sql: attribution ;;
  }
  dimension: explainability__attributions {
    type: string
    hidden: no
    sql: explainability__attributions ;;
  }
  dimension: feature_family {
    type: string
    sql: INITCAP(REPLACE(feature_family, '_', ' ')) ;;
  }

  ### ADDED

  dimension: id {
    type: string
    sql: id ;;
    hidden: yes
    primary_key: yes
  }

  measure: attribution_measure {
    label: "Attribution"
    type: average
    sql: ${attribution} ;;
    value_format_name: percent_2
  }

}
