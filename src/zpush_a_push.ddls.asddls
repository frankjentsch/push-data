@EndUserText.label: 'Action Parameters for Push'
define abstract entity ZPUSH_A_PUSH
{
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZPUSH_R_COMM_ARR', element: 'comm_arrangement_id' }}]
  comm_arrangement_id : ZPUSH_T_COMM_ARRANGEMENT_ID;
}
