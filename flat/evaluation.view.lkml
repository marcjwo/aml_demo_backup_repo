explore: flat_evalution {
  from: evaluation
}

view: evaluation {
  derived_table: {
    persist_for: "72 hours"
    sql: SELECT
        a.* EXCEPT (label_id),
        c.risk_label,
      FROM
      (SELECT
      CASE
        WHEN a.party_id IS NOT NULL THEN a.party_id ELSE b.party_id end as party_id,
      CASE
        WHEN a.risk_period_end_time IS NOT NULL THEN a.risk_period_end_time ELSE b.event_time end as date,
      a.* except(party_id, risk_period_end_time),
      b.* except(party_id, event_time),
      CASE
        WHEN a.risk_period_end_time IS NOT NULL AND b.event_time IS NOT NULL then "Present in both"
        WHEN a.risk_period_end_time IS NOT NULL AND b.event_time IS NULL then "Present in AML AI"
        WHEN a.risk_period_end_time IS NULL AND b.event_time IS NOT NULL then "Present in rule based only" END as indicator,
      CASE
        WHEN b.type = 'AML_PROCESS_END' THEN 'False positive'
        WHEN b.type = 'AML_EXIT' THEN 'True positive' END as rule_based,
      CASE
            WHEN MOD(ROW_NUMBER() OVER (), 3) = 0 THEN 'label_1'
            WHEN MOD(ROW_NUMBER() OVER (), 5) = 0 THEN 'label_2'
            WHEN MOD(ROW_NUMBER() OVER (), 7) = 0 THEN 'label_3'
            WHEN MOD(ROW_NUMBER() OVER (), 11) = 0 THEN 'label_4'
            WHEN MOD(ROW_NUMBER() OVER (), 13) = 0 THEN 'label_5'
            WHEN MOD(ROW_NUMBER() OVER (), 17) = 0 THEN 'label_6'
            WHEN MOD(ROW_NUMBER() OVER (), 19) = 0 THEN 'label_7'
            WHEN MOD(ROW_NUMBER() OVER (), 23) = 0 THEN 'label_8'
            WHEN MOD(ROW_NUMBER() OVER (), 29) = 0 THEN 'label_9'
            WHEN MOD(ROW_NUMBER() OVER (), 31) = 0 THEN 'label_10'
            WHEN MOD(ROW_NUMBER() OVER (), 37) = 0 THEN 'label_11'
            WHEN MOD(ROW_NUMBER() OVER (), 41) = 0 THEN 'label_12'
            WHEN MOD(ROW_NUMBER() OVER (), 43) = 0 THEN 'label_13'
            WHEN MOD(ROW_NUMBER() OVER (), 47) = 0 THEN 'label_14'
            WHEN MOD(ROW_NUMBER() OVER (), 53) = 0 THEN 'label_15'
            WHEN MOD(ROW_NUMBER() OVER (), 56) = 0 THEN 'label_16'
          ELSE
          'label_17'
        END
          AS label_id
      FROM `finserv-looker-demo.output_v3.predictions` a
      FULL OUTER JOIN (
      SELECT * EXCEPT(rn)
      FROM(
      SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY party_id, risk_case_id order by event_time desc, type asc) as rn
       FROM `finserv-looker-demo.input_v3.risk_case_event`
      )
      WHERE rn = 1
      ) b
      ON a.party_id = b.party_id AND FORMAT_DATE("%Y-%m", a.risk_period_end_time) = FORMAT_DATE("%Y-%m", b.event_time)
      -- where b.party_id is not null
      ) a
      LEFT JOIN
        `finserv-looker-demo.enhancements_v3.risk_labels` c
      ON
        a.label_id=c.label_id ;;
  }

  ### additions   ###   ###   ###   ###   ### ###   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ###

  parameter: threshold {
    type: unquoted
  }

  dimension: ai_aml {
    type: yesno
    sql: ${risk_score} > {% parameter threshold %} ;;
  }


  dimension: classification {
    type: string
    sql: CASE

          WHEN ${ai_aml} = true AND ${rule_based} = 'True positive' THEN "True positive"
          WHEN ${ai_aml} = true AND ${rule_based} = 'False positive' THEN "False positive"
          WHEN ${ai_aml} = false AND ${rule_based} = 'False positive' THEN "True negative"
          WHEN ${ai_aml} = false AND ${rule_based} = 'True positive' THEN "False negative"
          WHEN ${indicator} = 'Present in rule based only' THEN "Out of Scope AML AI"
          WHEN ${ai_aml} = true AND ${rule_based} IS NULL THEN 'True Positive - Not in Rule'
          WHEN ${ai_aml} = false AND ${rule_based} IS NULL THEN 'True negative - Not in Rule'
        END
    ;;
  }

  dimension: aml_ai_ind {
    type: string
    sql:
    CASE
      WHEN ${classification} IN ('True positive', 'True Positive - Not in Rule') THEN 'True positive'
      WHEN ${classification} IN ('False positive') THEN 'False positive'
    END
    ;;
  }

  dimension: net_new_indicator {
    sql: CASE
          WHEN ${classification} IN ("True positive","False positive") THEN "Overlap"
          WHEN ${classification} IN ('True Positive - Not in Rule') THEN "Net New AML AI"
          WHEN ${classification} IN ("False negative") THEN "Net New Rule based"
          END
          ;;
  }

  # dimension: net_new_indicator_ {
  #   type: string
  #   sql:
  #   CASE
  #     WHEN ${ai_aml} AND ${rule_based} = 'True positive' then 'Overlap'
  #     WHEN ${ai_aml} AND ${rule_based} = 'False positive' then 'AML AI Net New'
  #     WHEN NOT ${ai_aml} and ${rule_based} = 'True positive' then 'Rule based Net New'
  #     WHEN NOT ${ai_aml} and ${rule_based} is NULL then 'AML AI Net New'
  #   END
  #   ;;
  # }

  measure: party_count {
    type: count_distinct
    sql: ${party_id} ;;
  }

  ### ###   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ###

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: party_id {
    type: string
    sql: ${TABLE}.party_id ;;
  }

  dimension_group: date {
    type: time
    sql: ${TABLE}.date ;;
  }

  dimension: risk_score {
    type: number
    sql: ${TABLE}.risk_score ;;
  }

  dimension: risk_case_event_id {
    type: string
    sql: ${TABLE}.risk_case_event_id ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: risk_case_id {
    type: string
    sql: ${TABLE}.risk_case_id ;;
  }

  dimension: indicator {
    type: string
    sql: ${TABLE}.indicator ;;
  }

  dimension: rule_based {
    type: string
    sql: ${TABLE}.rule_based ;;
  }

  dimension: risk_label {
    type: string
    sql: ${TABLE}.risk_label ;;
  }

  set: detail {
    fields: [
      party_id,
      date_time,
      risk_score,
      risk_case_event_id,
      type,
      risk_case_id,
      indicator,
      rule_based,
      risk_label
    ]
  }
}
