#this file contains 2 views
#1. transaction
#2. time_between_transactions

view: transaction {
  sql_table_name: `finserv-looker-demo.public_dataset.transaction` ;;
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
    sql: INITCAP(${TABLE}.direction) ;;
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
    drill_fields: [transaction_id, direction, type, account_id, counterparty_account__account_id, normalized_booked_amount__currency_code, normalized_booked_amount__nanos, normalized_booked_amount__units, book_date, validity_start_date ]
  }


  measure: average_transaction_value {
    type: average
    sql: ${normalized_booked_amount__units} ;;
  }


  ####


  measure: total_number_of_counterparty {
    type: count_distinct
    sql: ${counterparty_account__account_id} ;;
  }

  dimension: direction_helper {
    type: number
    sql: CASE WHEN ${direction} = "Credit" THEN 1 ELSE -1 END ;;
  }

  measure: direction_measure {
    type: sum
    sql: ${direction_helper} ;;
  }

  measure: total_transaction_value {
    label: "AML AI: Total Transaction Value"
    description: "Show total value of transactions per individual"
    type: sum
    sql: ${normalized_booked_amount__units} ;;
    drill_fields: [transaction_id, direction, type, account_id, counterparty_account__account_id, normalized_booked_amount__currency_code, normalized_booked_amount__nanos, normalized_booked_amount__units, book_date, validity_start_date ]
  }


  ####
}

view: time_between_transactions {
  derived_table: {
    sql:
      with data as (
      select t.account_id, book_time, date_diff((lead(book_time) over(partition by t.account_id order by book_time)), book_time, minute) as difference from `finserv-looker-demo.public_dataset.transaction` as t
      group by account_id, book_time),
      data1 as (select account_id, count(*) as total from `finserv-looker-demo.public_dataset.transaction` group by account_id)
      select
      data.account_id as account_id,
      total as total_transactions,
      sum(difference) as total_time_difference,
      round(avg(difference),0) as average_time_difference
      from data, data1
      where data.account_id = data1.account_id
      group by data.account_id, data1.total
    ;;
  }

  dimension: account_id {
    type: string
    description: "MANDATORY: Account ID of the Account in the Account Party Link table."
    sql: ${TABLE}.account_id ;;
  }

  dimension: total_transactions {
    label: "Total Number of Transactions"
    type: number
    sql: ${TABLE}.total_transactions ;;
  }

  dimension: total_time_difference {
    label: "Total time difference between Transactions"
    type: number
    sql: ${TABLE}.total_time_difference ;;
  }

  dimension: average_time_difference {
    label: "Average time difference between Transactions"
    type: number
    sql: ${TABLE}.average_time_difference ;;
  }

  measure: count {
    type: count
    drill_fields: [account_id, total_transactions]
  }


}
