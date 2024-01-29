@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Log Entry'
define root view entity zpush_r_log_entry
  as select from zpush_log_entry as LogEntry

{
  key log_uuid              as LogUUID,
      action_type           as ActionType,
      message_type          as MessageType,
      message_text          as MessageText,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt

}
