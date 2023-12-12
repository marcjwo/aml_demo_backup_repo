view: predictions_augmented {
  sql_table_name: `finserv-looker-demo.@{output_dataset}.predictions_augmented` ;;



  dimension: party_exit_augment {
    # hidden: yes
    type: number
    sql: ${TABLE}.party_exit_augment ;;
  }

  dimension: party_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.party_id ;;
  }
  dimension: risk_label_augment {
    label: "Risk Label"
    type: string
    sql: cast(${TABLE}.risk_label_augment as string) ;;
  }
  dimension_group: risk_period {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.risk_period ;;
  }
  dimension: risk_score {
    hidden: yes
    type: number
    sql: ${TABLE}.risk_score ;;
    value_format_name: percent_2
  }
  dimension: risk_score_augment {
    type: number
    sql: ${TABLE}.risk_score_augment ;;
    value_format_name: percent_2
  }

############################################### Helping additions ###########################################

  parameter: risk_score_threshold {
    type: number
  }

  dimension: risk_score_threshold_help_dimension {
    type: yesno
    hidden: no
    sql: ${risk_score_augment} >= ({% parameter risk_score_threshold %}/100)  ;;

  }

############################################### AML AI Measures ###########################################

  measure: false_positive_rate {
    label: "AML AI: False Positive Rate"
    description: "Show rate of total false positives from AML AI"
    type: number
    sql: ${total_investigations_dynamic}/(${total_investigations_dynamic}+${total_new_exits});;
    value_format_name: percent_2
  }


  measure: longitudinal_avg_risk_score {
    label: "AML AI: Longitudinal Avg Risk Scores"
    description: "Show risk scores over time"
    type: average
    sql: ${risk_score_augment} ;;
  }

  measure: total_new_exits{
    label: "AML AI: Total New Exits"
    description: "Show count of total exits from AML AI"
    type: count_distinct
    sql: ${party_id};;
    filters: [party_exit_augment: "1"]
  }

  measure: total_false_positives_dynamic{
    label: "AML AI: Total False Positives"
    description: "Show count of total false positives from AML AI"
    type: count_distinct
    sql: ${party_id};;
    filters: [party_exit_augment: "0", risk_score_threshold_help_dimension: "Yes"]
  }

  measure: total_investigations_dynamic {
    label: "AML AI: Total Investigations"
    description: "Show count of total investigations from AML AI"
    type: count_distinct
    sql: ${party_id};;
    filters: [risk_score_threshold_help_dimension: "Yes"]
  }

  measure: total_parties {
    label: "AML AI: Total Parties"
    description: "Show count of total parties from AML AI"
    type: count_distinct
    sql: ${party_id} ;;
  }

  measure: base_recall_dynamic {
    label: "AML AI: Base Recall"
    description: "Show count of total investigations that also have an exit in the prior systems"
    type: count_distinct
    sql: ${risk_case_event.party_id};;
    filters: [risk_case_event.type: "AML_EXIT", risk_score_threshold_help_dimension: "Yes"]
  }

  measure: recall {
    label: "AML AI: Total Recall"
    description: "Show count of total exits shared between prior systems and AML AI"
    type: count_distinct
    sql: ${risk_case_event.party_id};;
    filters: [risk_case_event.type: "AML_EXIT", party_exit_augment: "1" ]
  }

  measure: cost_savings {
    label: "AML AI: Cost Savings"
    description: "Show estimated cost savings in $"
    type: number
    sql: ((${prev_total_false_positives}-${total_false_positives_dynamic})*60000) + ((${total_prev_exits}-${total_new_exits})*100000) ;;
    value_format_name: usd_0
  }


  # measure: risk_level {
  #   label: "AML AI: Risk Level"
  #   description: "Show estimated risk level in 10 point scale"
  #   type: number
  #   sql: AVG(AVG(POW(0.00003*670000,${recall}))+AVG(POW((2*1.4),${total_performance})));;
  # }


  ############################################### Prior System Measures ###########################################

  measure: prev_false_positive_rate {
    label: "Prior System: False Positive Rate"
    description: "Show rate of total false positives from prior system"
    type: number
    sql: ${total_prev_investigations}/(${total_prev_investigations}+${total_prev_exits});;
    value_format_name: percent_2
  }

  measure: total_prev_exits {
    label: "Prior System: Total Exits"
    description: "Show count of total exits from prior systems"
    type: count_distinct
    sql: ${party_id};;
    filters: [risk_case_event.type: "AML_EXIT"]
  }

  measure: prev_total_false_positives {
    label: "Prior System: Total False Positives"
    description: "Show count of total false positives from prior systems"
    type: count_distinct
    sql: ${risk_case_event.party_id} ;;
    filters: [risk_case_event.prev_false_positive: "Yes"]
  }

  measure: total_prev_investigations {
    label: "Prior System: Total Investigations"
    description: "Show count of total investigations from prior systems"
    type: count_distinct
    sql: ${risk_case_event.party_id} ;;
  }

  measure: prev_total_parties {
    label: "Prior System: Total Parties"
    description: "Show count of total parties from AML AI"
    type: count_distinct
    sql: ${party_id} ;;
  }

  ############################################### Comparison Measures ###########################################

  measure: false_positive_reduction {
    label: "Comparison - False Positive Reduction"
    description: "Show rate of false positive reduction between prior systems and AML AI"
    sql: (${prev_false_positive_rate}-${false_positive_rate})/${prev_false_positive_rate} ;;
    value_format_name: percent_2
  }

  measure: total_performance {
    label: "Comparison - Total Performance Rate"
    description: "Show rate of total performance between prior systems and AML AI"
    type: number
    sql: ${total_new_exits}/${total_prev_exits} ;;
    value_format_name: percent_2
  }

  measure: total_recall_rate {
    label: "Comparison - Total Recall Rate"
    description: "Show rate of recall between prior systems and AML AI"
    type: number
    sql: ${recall}/${total_prev_exits} ;;
    value_format_name: percent_2
  }


  ############################################### OLD MEASURES ###########################################


  # measure: total_missed {
  #   type: number
  #   sql: ${total_detected} - ${total_new_exits};;
  # }



  measure: total_investigations { ## this needs to be dynamic
    type: count_distinct
    sql: ${party_id};;
    filters: [party_exit_augment: "1"]
  }


  measure: total_false_positives{
    type: count_distinct
    sql: ${party_id};;
    filters: [party_exit_augment: "1"]
  }

  measure: false_positives_rate{
    type: number
    sql: ${total_investigations}/(${total_investigations}+${total_new_exits}) ;;
    value_format_name: percent_2
  }

#   measure: recall {
#     label: "Total Recall"
# #    hidden: yes
#     type: count_distinct
#     sql: ${party_id};;
#     filters: [risk_case_event.type: "AML_EXIT", party_exit_augment: "1" ]
#   }

  measure: investigation_rate {
    type: number
    sql: ${total_investigations}/${total_parties} ;;
    value_format_name: percent_2
  }





  measure: average_risk_score {
    label: "Risk Score"
    type: average
    sql: ${risk_score_augment} ;;
    value_format_name: percent_2
  }








  #### all riskscore dynamic measures


  # measure: base_recall_dynamic {
  #   type: count_distinct
  #   sql: ${party_id};;
  #   filters: [risk_case_event.type: "AML_EXIT", party_exit_augment: "1", risk_score_threshold_help_dimension: "Yes"]
  # }

  # measure: total_recall_dynamic {
  #   type: number
  #   sql: ${recall_dynamic}/${total_prev_exits} ;;
  #   value_format_name: percent_2
  # }





  #### further additions








}