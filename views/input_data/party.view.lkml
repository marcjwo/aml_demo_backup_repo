# Un-hide and use this explore, or copy the joins into another explore, to get all the fully nested relationships from this view
explore: party {
  hidden: yes
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
view: party {
  sql_table_name: `finserv-looker-demo.@{input_dataset}.party` ;;
  drill_fields: [party_id]

  dimension: party_id {
    primary_key: yes
    type: string
    description: "MANDATORY: Unique ID for your customers. Use a pseudo-ID or an internal customer ID instead of an externally facing customer ID."
    sql: ${TABLE}.party_id ;;
  }
  dimension_group: birth {
    type: time
    description: "RECOMMENDED: Date of birth for the Party for natural persons, for example, where Party.type = CONSUMER. Where Party.type = COMPANY, use NULL. Typically also used for fairness evaluation."
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.birth_date ;;
  }
  dimension_group: establishment {
    type: time
    description: "RECOMMENDED: Party's date of establishment with Party.type = COMPANY. Where Party.type = CONSUMER, use NULL."
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.establishment_date ;;
  }
  dimension_group: exit {
    type: time
    description: "MANDATORY: The date when the party stopped being a customer. Use NULL if the Party is still a customer, or never was a customer."
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.exit_date ;;
  }
  dimension: gender {
    type: string
    description: "RECOMMENDED: Gender string for individuals. Typically used for fairness evaluation."
    sql: CASE WHEN ${TABLE}.gender = "F" then "Female" WHEN ${TABLE}.gender = "M" THEN "Male" else "NA" END ;;
  }
  dimension: is_entity_deleted {
    type: yesno
    description: "RECOMMENDED: If set to TRUE, indicates the party as deleted from your system of reference."
    sql: ${TABLE}.is_entity_deleted ;;
  }
  dimension_group: join {
    type: time
    description: "MANDATORY: Date when the Party first became your customer. Use NULL if the PARTY never was a customer."
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.join_date ;;
  }
  dimension: nationalities {
    hidden: yes
    sql: ${TABLE}.nationalities ;;
  }
  dimension: residencies {
    hidden: yes
    sql: ${TABLE}.residencies ;;
  }
  dimension: source_system {
    type: string
    description: "RECOMMENDED: Name of the system this row was fetched from."
    sql: ${TABLE}.source_system ;;
  }
  dimension: type {
    type: string
    description: "MANDATORY: Type of this party, to differentiate between a natural person or a legal entity. One of: [COMPANY:CONSUMER]."
    sql: CASE WHEN ${TABLE}.type = "COMPANY" THEN "Company" ELSE "Consumer" END ;;
  }
  dimension_group: validity_start {
    type: time
    description: "MANDATORY: Timestamp of when the information in this row reflected the state of the entity and was known to the bank."
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.validity_start_time ;;
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  party_id,
  risk_case_event.count,
  account_party_link.count,
  party_registration.count,
  explainability.count,
  predictions.count
  ]
  }

}

####### FOR THE BELOW:

# the nested fields can contain a list of region codes for example. Need to find out what the desired outcome is here. Can a party have multiple nationalities and if so, should they stick in one column, or result in a repeated record?

#######


view: party__residencies {

  dimension: party__residencies {
    type: string
    description: "RECOMMENDED: One or more of the Party's tax residencies (for natural persons), with an empty list in exceptional cases. Empty list for companies."
    hidden: yes
    sql: party__residencies ;;
  }
  dimension: residencies_region_code {
    type: string
    description: "MANDATORY: Country or region in two-letter Unicode CLDR code format."
    sql: party__residencies.region_code;;
  }
}

view: party__nationalities {

  dimension: party__nationalities {
    type: string
    description: "RECOMMENDED: One or more nationalities for natural persons, with an empty list in exceptional cases when your do not have information on the tax residency of the party. Empty for companies. Typically also used for fairness evaluation."
    hidden: yes
    sql: party__nationalities ;;
  }
  dimension: nationalities_region_code {
    type: string
    description: "MANDATORY: Country or region in two-letter Unicode CLDR code format."
    sql: party__nationalities.region_code ;;
  }
}
