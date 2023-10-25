view: account_party_link {
  sql_table_name: `finserv-looker-demo.public_dataset.account_party_link` ;;

  dimension: account_id {
    type: string
    description: "MANDATORY: Unique ID for this Account."
    sql: ${TABLE}.account_id ;;
  }
  dimension: is_entity_deleted {
    type: yesno
    description: "RECOMMENDED: If set to TRUE, indicates the link is no longer present."
    sql: ${TABLE}.is_entity_deleted ;;
  }
  dimension: party_id {
    type: string
    description: "MANDATORY: Unique ID for this Party in the Party table."
    # hidden: yes
    sql: ${TABLE}.party_id ;;
  }
  dimension: role {
    type: string
    description: "MANDATORY: Describes how the party is related to the account. In particular, capturing primary and secondary account holders. Each Account should have at least one PRIMARY_HOLDER at any given time. Supported values: PRIMARY_HOLDER, SECONDARY_HOLDER, SUPPLEMENTARY_HOLDER. Do not use NULL for this field. One of: [PRIMARY_HOLDER:SECONDARY_HOLDER:SUPPLEMENTARY_HOLDER]."
    sql: ${TABLE}.role ;;
  }
  dimension: source_system {
    type: string
    description: "RECOMMENDED: Name of the system this row was fetched from."
    sql: ${TABLE}.source_system ;;
  }
  dimension_group: validity_start {
    type: time
    description: "MANDATORY: Timestamp when the information of this row was in the correct state for the entity"
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.validity_start_time ;;
  }
  measure: count {
    type: count
    drill_fields: [party.party_id]
  }


  #### Added for UX

  dimension: button {
    sql: ${account_id} ;;
    type: string
    html: <div style="text-align: center; min-height: 60px; padding: 25px;">
<a style="
  color: #fff;
    background-color: #4285F4;
    border-color: #4285F4;
    font-weight: 400;
    text-align: center;
    vertical-align: middle;
    cursor: pointer;
    user-select: none;
    padding: 10px;
    margin: 5px;
    font-size: 1rem;
    line-height: 1.5;
    border-radius: 5px;"
    href="https://cloudcenorthamfinserv.cloud.looker.com/dashboards/29?Account+ID={{ value }}">
    See transactions for account {{ value }}!
</a>
</div> ;;
  }

  ####

}
