# Warning! This is auto-generated SQL & LookML, generated by csv-sql.web.app.
# Doublecheck the dimensions and their datatypes and adjust where necessary.

explore: feature_family_desc {}

view: feature_family_desc {
  derived_table: {
    sql:
      SELECT
        'Unusual wire debit activity' AS feature_family,
        'Characteristics of wire debit activity for this party in the context of all wire debit transactions for the same party over a period of up to 2 years.' AS description,
        'This feature family focuses on surfacing potentially suspicious party behavior based on their wire debit activities over the period up to two years.' AS what_does_this_feature_family_do,
        'Transaction type: wire Transaction direction: debit' AS data_filtering_suggestion,
        '24 months' AS lookback_window,
        'Monthly total transaction value and counts Transactions over the reportable threshold Repeated transactions with the same counterparty account within a 14 day window, amounting to more than the reportable threshold Time between wire debit transactions in the last month' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual wire credit activity' AS feature_family,
        'Characteristics of wire credit activity for this party in the context of all wire debit transactions for the same party over a period of up to 2 years.' AS description,
        'This feature family focuses on surfacing potentially suspicious party behavior based on their wire credit activities over the period up to two years.' AS what_does_this_feature_family_do,
        'Transaction type: wire Transaction direction: credit' AS data_filtering_suggestion,
        '24 months' AS lookback_window,
        'Monthly total transaction value and counts Transactions over the reportable threshold Repeated transactions with the same counterparty account within a 14 day window, amounting to more than the reportable threshold Time between wire credit transactions in the last month Monthly ratio of total wire credit to cash debit value' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual wire credit and debit activity' AS feature_family,
        'Characteristics of wire activity for this party in the context of all wire transactions for the same party over a 1 year period.' AS description,
        'This feature family focuses on surfacing potentially suspicious party behavior based on their average wire transaction amounts over a 1 year period.' AS what_does_this_feature_family_do,
        'Transaction type: wire Transaction direction: all' AS data_filtering_suggestion,
        '12 months' AS lookback_window,
        'Monthly average transaction amounts ' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual round value wire activity' AS feature_family,
        'Characteristics of round values in the context of all wire transactions for the same party over a 1 year period.' AS description,
        'This feature family focuses on surfacing potentially suspicious party behavior based on the transactions with amounts that are divisible by 100.' AS what_does_this_feature_family_do,
        'Transaction type: wire Transaction direction: all' AS data_filtering_suggestion,
        '12 months' AS lookback_window,
        'Monthly total value of wire transactions with amounts that are divisible by 100 The monthly share of total wire transaction value from transactions with amounts that are divisible by 100' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual card debit activity' AS feature_family,
        'Characteristics of card debit activity for this party in the context of all card debit transactions for the same party over a 1 year period.' AS description,
        'This feature family focuses on surfacing potentially suspicious structuring and reportable transactions based on card debit activities over a period of 12 months.' AS what_does_this_feature_family_do,
        'Transaction type: card Transaction direction: debit ' AS data_filtering_suggestion,
        '12 months' AS lookback_window,
        'Transactions over the reportable threshold Repeated transactions with the same counterparty account within a 14 day window, amounting to more than the reportable threshold' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual monthly proportions of different credit and debit transaction types' AS feature_family,
        'Characteristics of the usage of different transaction types in the context of all transactions for the same party over a 1 year period.' AS description,
        'This feature family focuses on surfacing potentially suspicious activities for cash, wire and card ratios related to the party behavior based on transactions over the period of 12 months.' AS what_does_this_feature_family_do,
        'Transaction type: ALL Transaction direction: ALL ' AS data_filtering_suggestion,
        '12 months' AS lookback_window,
        'Monthly share of transaction value from card debit transactions Monthly share of transaction value from cash transactions Monthly share of transaction value from wire transactions' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual monthly proportions of different debit transaction types' AS feature_family,
        'Characteristics of debit usage for different transaction types in the context of all debit transactions for the same party over a period of up to 2 years.' AS description,
        'This feature family focuses on surfacing potentially suspicious activities for cash and wire debit as a share of total debit value, related to the party behavior based on transactions over the period of 24 months.' AS what_does_this_feature_family_do,
        'Transaction type: WIRE, CASH vs all transaction types Transaction direction: DEBIT ' AS data_filtering_suggestion,
        '24 months' AS lookback_window,
        'Monthly cash debit transaction value vs total debit transaction value Monthly wire debit transaction value vs total debit transaction value ' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual monthly proportions of different credit transaction types' AS feature_family,
        'Characteristics of credit usage for different transaction types in the context of all credit transactions for the same party over a period of up to 2 years.' AS description,
        'This feature family focuses on surfacing potentially suspicious activities for cash and wire credit as a share of total credit value, related to the party behavior based on transactions over the period of 24 months.' AS what_does_this_feature_family_do,
        'Transaction type: WIRE, CASH vs all transaction types Transaction direction: CREDIT ' AS data_filtering_suggestion,
        '24 months' AS lookback_window,
        'Monthly cash credit transaction value vs total cash and wire credit transaction value Monthly wire credit transaction value vs total cash and wire credit transaction value' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual counterparty activity' AS feature_family,
        'Characteristics of activity or level of activity of counterparties transacting with this party in the context of all transactions for the same party and counterparties within a 2 month period.' AS description,
        "This feature family helps identify potentially suspicious activities involving the party's counterparties (network) based on both inbound and outbound transactions over a two-month period." AS what_does_this_feature_family_do,
        'Transaction type: ALL Transaction direction: ALL' AS data_filtering_suggestion,
        '2 months' AS lookback_window,
        'Number of distinct counterparties of this party in the last 2 months In credit transactions In debit transactions Number of distinct counterparties of each counterparty of this party in the last 2 months In credit transactions In debit transactions' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual debit activity' AS feature_family,
        'Characteristics of debit activity for this party in the context of all debit transactions for the same party over a period of up to 2 years.' AS description,
        'This feature family focuses on surfacing potentially suspicious party behavior based on their debit activities over the period up to two years.' AS what_does_this_feature_family_do,
        'Transaction type: ALL Transaction direction: debit ' AS data_filtering_suggestion,
        '24 months' AS lookback_window,
        'Monthly total count and value of debit transactions Monthly highest value debit transaction Average time between debit transactions in the last month' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual cross border wire activity' AS feature_family,
        'Characteristics of wire activity initiated by a party residing in a high risk jurisdiction or with a nationality from a high risk jurisdiction, in the context of all wire transactions for the same party over a 1 year period.' AS description,
        'This feature family focuses on surfacing potentially suspicious activities related to transaction counterparties from high risk geographies based on transactions over the period of 12 months.' AS what_does_this_feature_family_do,
        'Transaction type: ALL Transaction direction: ALL Counterparty residence or counterparty nationality: high risk geography (high risk for money laundering according to FATF as of October 2021) ' AS data_filtering_suggestion,
        '12 months' AS lookback_window,
        'Counterparties with residencies in FATF high risk geographies Counterparties with nationalities from FATF high risk geographies' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual credit activity' AS feature_family,
        'Characteristics of credit activity for this party in the context of all credit transactions for the same party over a period of up to 2 years.' AS description,
        'This feature family focuses on surfacing potentially suspicious party behavior based on their credit activities over the period up to two years.' AS what_does_this_feature_family_do,
        'Transaction type: ALL Transaction direction: credit ' AS data_filtering_suggestion,
        '24 months' AS lookback_window,
        'Monthly total count and value of credit transactions Monthly highest value credit transaction Average time between credit transactions in the last month' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual cash debit activity' AS feature_family,
        'Characteristics of cash debit activity in the context of all cash debit activities for the same party over a period of maximum 2 years back from the target month.' AS description,
        'This feature family focuses on surfacing potentially suspicious party behavior based on their cash debit activities over the period up to two years.' AS what_does_this_feature_family_do,
        'Transaction type: CASH Transaction direction: debit ' AS data_filtering_suggestion,
        '24 months' AS lookback_window,
        'Monthly total count and value of cash debit transactions Average time between cash debit transactions in the last month' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual cash credit activity' AS feature_family,
        'Characteristics of cash credit activity in the context of all cash credit activities for the same party over a period of maximum 2 years back from the target month.' AS description,
        'This feature family focuses on surfacing potentially suspicious party behavior based on their cash credit activities over the period up to two years.' AS what_does_this_feature_family_do,
        'Transaction type: CASH Transaction direction: CREDIT ' AS data_filtering_suggestion,
        '24 months' AS lookback_window,
        'Monthly total count and value of cash credit transactions Average time between cash credit transactions in the last month' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual cash credit and debit activity' AS feature_family,
        'Characteristics of cash activity for this party in the context of all cash transactions for the same party over a 1 year period.' AS description,
        'This feature family focuses on surfacing potentially suspicious activities for cash credit and cash debit ratios related to the party behavior based on transactions over the period of 12 months.' AS what_does_this_feature_family_do,
        'Transaction type: CASH Transaction direction: ALL ' AS data_filtering_suggestion,
        '12 months' AS lookback_window,
        'Ratio of total cash credit to total cash debit value per month' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual rapid movement of funds' AS feature_family,
        'Characteristics of movement of funds over a smaller number of consecutive days in the context of all transactions for the same party over a 3 month period.' AS description,
        'This feature family focuses on surfacing potentially suspicious activities related to balance of inbound vs outbound movements or balance of cash vs. wire movements in a short space of time.' AS what_does_this_feature_family_do,
        'Transaction type: CASH, WIRE Transaction direction: ALL ' AS data_filtering_suggestion,
        '3 months' AS lookback_window,
        '3 day periods in which credit and debit transaction value are well balanced 3 day periods in which cash credit and wire debit transaction value are well balanced' AS what_to_look_at
      UNION ALL
      SELECT
        'Unusual cash and wire inactivity' AS feature_family,
        'Consecutive periods of no party activity over the last 1 year period' AS description,
        'This feature family focuses on surfacing potentially suspicious activities by identifying inactivity periods in different transaction types followed by activity.' AS what_does_this_feature_family_do,
        'Transaction type: CASH, WIRE Transaction direction: ALL ' AS data_filtering_suggestion,
        '12 months' AS lookback_window,
        'Consecutive months without any credit wire transfers followed by wire credit activity Consecutive months without any debit wire transfers followed by wire debit activity Consecutive months without any cash deposits followed by cash deposit activity Consecutive months without any cash withdrawals followed by cash withdrawal activity' AS what_to_look_at

      ;;
  }

  dimension: feature_family {
    type: string
    sql: ${TABLE}.feature_family ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: what_does_this_feature_family_do {
    type: string
    sql: ${TABLE}.what_does_this_feature_family_do ;;
  }

  dimension: data_filtering_suggestion {
    type: string
    sql: ${TABLE}.data_filtering_suggestion ;;
  }

  dimension: lookback_window {
    type: string
    sql: ${TABLE}.lookback_window ;;
  }

  dimension: what_to_look_at {
    type: string
    sql: ${TABLE}.what_to_look_at ;;
  }

}