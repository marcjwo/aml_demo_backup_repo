view: transaction {
  sql_table_name: `finserv-looker-demo.input_v3.transaction` ;;
  drill_fields: [transaction_id]

  dimension: transaction_id {
    primary_key: yes
    type: string
    description: "MANDATORY: Unique ID of this transaction, from the point of view of the specified Account. Note that a transfer is between two accounts, both in the Account table, and should be represented by two transactions with separate transaction IDs, one with direction = DEBIT and one with direction = CREDIT."
    sql: ${TABLE}.transaction_id ;;
  }
  dimension: account_id {
    type: string
    description: "MANDATORY: Account ID of the Account in the Account Party Link table."
    sql: ${TABLE}.account_id ;;
  }
  dimension_group: book {
    type: time
    description: "MANDATORY: Time when the transaction was booked. Use NULL if a book time is not yet known."
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.book_time ;;
  }
  dimension: counterparty_account__account_id {
    type: string
    description: "MANDATORY: Account ID of a transaction's counterparty, if in the AccountPartyLink table. Can be NULL if the counterparty account is not represented in the Account Party Link table, for example, the customer of another financial institution."
    sql: ${TABLE}.counterparty_account.account_id ;;
    group_label: "Counterparty Account"
    group_item_label: "Account ID"
  }
  dimension: direction {
    type: string
    description: "MANDATORY: Direction of the transaction assets flow from the point of view of the specified account ID. Uses common definition of credit/debit in banking. Supported values: DEBIT, represents a transfer of value from this account; CREDIT, represents a transfer of value to this account One of: [DEBIT:CREDIT]."
    sql: ${TABLE}.direction ;;
  }
  dimension: is_entity_deleted {
    type: yesno
    description: "RECOMMENDED: If set to TRUE, indicates the Transaction is no longer present in your system of record."
    sql: ${TABLE}.is_entity_deleted ;;
  }
  dimension: normalized_booked_amount__currency_code {
    type: string
    description: "MANDATORY"
    sql: ${TABLE}.normalized_booked_amount.currency_code ;;
    group_label: "Normalized Booked Amount"
    group_item_label: "Currency Code"
  }
  dimension: normalized_booked_amount__nanos {
    type: number
    description: "MANDATORY"
    sql: ${TABLE}.normalized_booked_amount.nanos ;;
    group_label: "Normalized Booked Amount"
    group_item_label: "Nanos"
  }
  dimension: normalized_booked_amount__units {
    type: number
    description: "MANDATORY"
    sql: ${TABLE}.normalized_booked_amount.units ;;
    group_label: "Normalized Booked Amount"
    group_item_label: "Units"
  }

  dimension: helper_normalized_booked_amount__units {
    type: number
    hidden: yes
    description: "MANDATORY"
    sql: CASE WHEN ${direction} = "DEBIT" THEN (-1*${TABLE}.normalized_booked_amount.units) ELSE ${TABLE}.normalized_booked_amount.units END ;;
    group_label: "Normalized Booked Amount"
    group_item_label: "Units"
  }

  measure: _normalized_booked_amount__units {
    type: sum
    value_format_name: usd
    sql: ${helper_normalized_booked_amount__units} ;;
  }


  dimension: source_system {
    type: string
    description: "RECOMMENDED: Name of the system that this row was fetched from."
    sql: ${TABLE}.source_system ;;
  }
  dimension: type {
    type: string
    description: "MANDATORY: High level type of the transaction. Supported values: CARD, transaction involving a credit or debit card (includes GPay); CASH, transaction where cash is paid into or withdrawn from an account; CHECK, transaction where a cheque is used; WIRE, default for other transactions, including transfers between accounts at the same or different banks. One of: [WIRE:CASH:CHECK:CARD:OTHER]."
    sql: ${TABLE}.type ;;
  }
  dimension_group: validity_start {
    type: time
    description: "MANDATORY: Timestamp when the information of this row was the correct state of the entity."
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.validity_start_time ;;
  }
  measure: count {
    type: count
    drill_fields: [transaction_id]
  }

  set: transaction_details {
    fields: [transaction_id,validity_start_date,type,direction,account_id,normalized_booked_amount__currency_code,_normalized_booked_amount__units]
  }
}
