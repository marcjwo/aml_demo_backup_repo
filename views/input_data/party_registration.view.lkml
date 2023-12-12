view: party_registration {
  sql_table_name: `finserv-looker-demo.@{input_dataset}.party_registration` ;;

  dimension: party_id {
    type: string
    description: "MANDATORY: Unique identifier of the party in the instance's datasets."
    # hidden: yes
    sql: ${TABLE}.party_id ;;
  }
  dimension: party_size {
    type: string
    description: "Requested party size. The tier is based on the average number of monthly transactions for the party over the preceding 365 days: SMALL for small commercial parties with less than 500 average monthly transactions, LARGE for large commercial parties with greater than or equal to 500 average monthly transactions. All values are case sensitive."
    sql: ${TABLE}.party_size ;;
  }
  measure: count {
    type: count
    drill_fields: [party.party_id]
  }
}
