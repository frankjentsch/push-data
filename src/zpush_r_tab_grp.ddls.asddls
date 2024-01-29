@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Table Group'
define root view entity zpush_r_tab_grp
  as select from zpush_tab_grp
{
  key tab_grp_name as TableGroupName,
      tab_grp_desc as TableGroupDescription

}
