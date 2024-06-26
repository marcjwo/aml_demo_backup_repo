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
  sql_table_name: `finserv-looker-demo.input_v3.party` ;;
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
    sql: CASE WHEN ${TABLE}.gender = 'F' THEN 'Female' WHEN ${TABLE}.gender = 'M' THEN 'Male' else 'N/A' END;;
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
    sql: ${TABLE}.type ;;
  }
  dimension_group: validity_start {
    type: time
    description: "MANDATORY: Timestamp of when the information in this row reflected the state of the entity and was known to the bank."
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.validity_start_time ;;
  }
  measure: count {
    type: count
    drill_fields: [party_id]
  }

  dimension: first_name {
    type: string
    sql: "Jane" ;;
  }

  dimension: last_name {
    type: string
    sql: " Doe" ;;
  }

  dimension: name {
    type: string
    sql:
    CASE WHEN ${type} = 'CONSUMER' THEN CONCAT(${first_name},${last_name})
    WHEN ${type} = 'COMPANY' THEN 'Symbol Corp'
    END
    ;;
  }

  # dimension: risk_score {
  #   type: number
  #   value_format_name: percent_2
  #   sql: RAND();;
  # }

}

view: party__residencies {

  dimension: party__residencies {
    type: string
    description: "RECOMMENDED: One or more of the Party's tax residencies (for natural persons), with an empty list in exceptional cases. Empty list for companies."
    hidden: yes
    sql: party__residencies ;;
  }
  dimension: region_code {
    type: string
    description: "MANDATORY: Country or region in two-letter Unicode CLDR code format."
    sql: case when region_code is null then 'US' else region_code end;;
  }
}

view: party__nationalities {

  dimension: party__nationalities {
    type: string
    description: "RECOMMENDED: One or more nationalities for natural persons, with an empty list in exceptional cases when your do not have information on the tax residency of the party. Empty for companies. Typically also used for fairness evaluation."
    hidden: yes
    sql: party__nationalities ;;
  }
  dimension: region_code {
    type: string
    description: "MANDATORY: Country or region in two-letter Unicode CLDR code format."
    sql: region_code ;;
  }
}
