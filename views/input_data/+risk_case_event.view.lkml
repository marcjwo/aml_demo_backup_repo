include: "/views/input_data/risk_case_event.view.lkml"

view: +risk_case_event {

dimension: recalls {
  hidden: yes
  case: {
    when: {
      sql: ${type} != "AML_EXIT" OR ${type} != "AML_SAR";;
      label: "Recall"
    }
    else: "Other"
  }
}


measure: total_recalls {
  group_label: "Lyndsey Test"
  type: count_distinct
  sql: ${risk_case_id} ;;
  filters: [recalls: "Recall"]
}


measure: total_investigations_started {
  group_label: "Lyndsey Test"
  type: count_distinct
  sql: ${risk_case_id} ;;
  filters: [type: "AML_PROCESS_START"]
  drill_fields: [risk_case_id, party_id]
}

measure: total_investigations_completed {
  group_label: "Lyndsey Test"
  type: count_distinct
  sql: ${risk_case_id} ;;
  filters: [type: "AML_PROCESS_START"]
  drill_fields: [risk_case_id, party_id]
}

measure: total_sars_filed {
  group_label: "Lyndsey Test"
  type: count_distinct
  sql: ${risk_case_id} ;;
  filters: [type: "AML_SAR"]
  drill_fields: [risk_case_id, party_id]
}

measure: total_false_positives{
  group_label: "Lyndsey Test"
  type: count_distinct
  sql: ${risk_case_id} ;;
  filters: [type: "AML_EXIT"]
  drill_fields: [risk_case_id, party_id]
}

measure: total_alerts {
  group_label: "Lyndsey Test"
  type: count_distinct
  sql: ${risk_case_id} ;;
  drill_fields: [risk_case_id, party_id]
}

}
