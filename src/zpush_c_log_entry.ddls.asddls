@EndUserText.label: 'Log Entry'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'LogUUID' ]
define root view entity zpush_c_log_entry
  as projection on zpush_r_log_entry
{
  key LogUUID,
      ActionType,
      MessageType,
      MessageText,
      LocalLastChangedAt,
      LastChangedAt
}
