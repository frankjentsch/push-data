@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Table Group'
@ObjectModel.semanticKey: [ 'TableGroupName' ]
define root view entity zpush_c_tab_grp
  provider contract transactional_query
  as projection on zpush_r_tab_grp
{
  key TableGroupName,
      TableGroupDescription
}
