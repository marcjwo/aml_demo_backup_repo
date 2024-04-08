include: "/updated_version/party.view.lkml"

explore: flat_evalution {
  from: evaluation

  join: party {
    sql_on: ${flat_evalution.party_id} = ${party.party_id} ;;
    type: left_outer
    relationship: many_to_many
  }

  join: party__residencies {
    view_label: "Party: Residencies"
    sql: LEFT JOIN UNNEST(${party.residencies}) as party__residencies ;;
    relationship: one_to_many
  }
  join: party__nationalities {
    view_label: "Party: Nationalities"
    sql: LEFT JOIN UNNEST(${party.nationalities}) as party__nationalities ;;
    relationship: one_to_many
  }
}

view: evaluation {
  derived_table: {
 #   persist_for: "168 hours"
    persist_for: "24 hours"
    sql: SELECT
    a.*,
    b.* EXCEPT(party_id)
  FROM (
    SELECT
      CASE
        WHEN a.party_id IS NOT NULL THEN a.party_id
      ELSE
      b.party_id
    END
      AS party_id,
      CASE
        WHEN a.risk_period_end_time IS NOT NULL THEN a.risk_period_end_time
      ELSE
      b.event_time
    END
      AS date,
      a.* EXCEPT(party_id,
        risk_period_end_time),
      b.* EXCEPT(party_id,
        event_time),
      CASE
        WHEN a.risk_period_end_time IS NOT NULL AND b.event_time IS NOT NULL THEN "Present in both"
        WHEN a.risk_period_end_time IS NOT NULL
      AND b.event_time IS NULL THEN "Present in AML AI"
        WHEN a.risk_period_end_time IS NULL AND b.event_time IS NOT NULL THEN "Present in rule based only"
    END
      AS indicator,
      CASE
        WHEN b.type = 'AML_PROCESS_END' THEN 'False positive'
        WHEN b.type = 'AML_EXIT' THEN 'True positive'
    END
      AS rule_based,
    CASE
    WHEN a.risk_period_end_time IS NOT NULL
      AND b.event_time IS NULL THEN RAND()
    WHEN a.risk_period_end_time IS NOT NULL AND b.event_time IS NOT NULL THEN RAND()
    END
      as investigation_threshold
    FROM
      (

      SELECT
        *
      FROM
        `finserv-looker-demo.output_v3.predictions`
      WHERE
       party_id IN (
        SELECT
          DISTINCT party_id
       FROM
         `finserv-looker-demo.input_v3.risk_case_event`)
      UNION ALL
      SELECT
       *
      FROM
       `finserv-looker-demo.output_v3.predictions`
     WHERE
        party_id NOT IN (
       SELECT
          DISTINCT party_id
       FROM
         `finserv-looker-demo.input_v3.risk_case_event`)
       AND RAND() <= 0.2 ) a

    FULL OUTER JOIN (
      SELECT
        * EXCEPT(rn)
      FROM (
        SELECT
          *,
          ROW_NUMBER() OVER (PARTITION BY party_id, risk_case_id ORDER BY event_time DESC, type ASC) AS rn
        FROM
          `finserv-looker-demo.input_v3.risk_case_event` )
      WHERE
        rn = 1 ) b
    ON
      a.party_id = b.party_id
      AND FORMAT_DATE("%Y-%m", a.risk_period_end_time) = FORMAT_DATE("%Y-%m", b.event_time) ) a
  LEFT JOIN (
    SELECT
      a.* EXCEPT(label_id),
      c.risk_label
    FROM (
      SELECT
        DISTINCT party_id,
        ARRAY['label_1', 'label_2', 'label_3', 'label_4', 'label_5', 'label_6', 'label_7', 'label_8', 'label_9', 'label_10', 'label_11', 'label_12', 'label_13', 'label_14', 'label_15', 'label_16', 'label_17']
       [SAFE_OFFSET(ABS(MOD(FARM_FINGERPRINT(CAST(party_id AS STRING)), 17)))] AS label_id
      FROM (
        SELECT
        distinct party_id
        FROM (

        SELECT
          party_id
        FROM
          `finserv-looker-demo.output_v3.predictions`
        UNION ALL
        SELECT
          party_id
        FROM
          `finserv-looker-demo.input_v3.risk_case_event`)
        )
          ) a
    LEFT JOIN
      `finserv-looker-demo.enhancements_v3.risk_labels` c
    ON
      a.label_id=c.label_id ) b
  ON
    a.party_id = b.party_id ;;
  }

  ### additions   ###   ###   ###   ###   ### ###   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ###

  # dimension: is_rule_based {
  #   type: yesno
  #   sql: ${type} = 'AML_EXIT' ;;
  # }

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

  dimension: aml_ai_fp_ind {
    type: string
    sql:
    CASE
      WHEN ${aml_ai} AND (${investigation_threshold}*100) <= {% parameter threshold_fp %} THEN 'True positive'
      WHEN ${aml_ai} AND (${investigation_threshold}*100) > {% parameter threshold_fp %} THEN 'False positive'
    END
    ;;
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



  dimension: classification {
    type: string
    sql: CASE

          WHEN ${aml_ai} = true AND ${rule_based} = 'True positive' THEN "True positive"
          WHEN ${aml_ai} = true AND ${rule_based} = 'False positive' THEN "False positive"
          WHEN ${aml_ai} = false AND ${rule_based} = 'False positive' THEN "True negative"
          WHEN ${aml_ai} = false AND ${rule_based} = 'True positive' THEN "False negative"
          WHEN ${indicator} = 'Present in rule based only' THEN "Out of Scope AML AI"
          WHEN ${aml_ai} = true AND ${rule_based} IS NULL THEN 'True Positive - Not in Rule'
          WHEN ${aml_ai} = false AND ${rule_based} IS NULL THEN 'True negative - Not in Rule'
        END
    ;;
  }

  dimension: classification_v2{
    type: string
    sql: CASE

                WHEN ${aml_ai} = true AND ${rule_based} = 'True positive' THEN "True positive"
                WHEN ${aml_ai} = true AND ${rule_based} = 'False positive' THEN "False positive"
                WHEN ${aml_ai} = false AND ${rule_based} = 'False positive' THEN "True negative"
                WHEN ${aml_ai} = false AND ${rule_based} = 'True positive' THEN "False negative"
                WHEN ${indicator} = 'Present in rule based only' THEN "Out of Scope AML AI"
                WHEN ${aml_ai} = true AND ${rule_based} IS NULL THEN 'True Positive - Not in Rule'
                WHEN ${aml_ai} = false AND ${rule_based} IS NULL THEN 'True negative - Not in Rule'
              END
          ;;
  }

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

  ### ###   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ######   ###   ###   ###   ###

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: investigation_threshold {
    type: number
    sql: ${TABLE}.investigation_threshold ;;
  }

  dimension: party_id {
    type: string
    sql: ${TABLE}.party_id ;;
  }

  dimension_group: date {
    type: time
    sql: ${TABLE}.date ;;
  }

  dimension: risk_month_year {
    type: string
    sql:concat(${date_month_name}, ' ',${date_year});;
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
