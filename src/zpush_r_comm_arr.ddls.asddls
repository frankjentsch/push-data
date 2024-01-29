@ObjectModel.query.implementedBy:'ABAP:ZCL_PUSH_R_COMM_ARR'
@EndUserText.label: 'Comm. Arrangements for Target Tenants'

@UI: {
    headerInfo: {
        typeName: 'Target Tenant',
        typeNamePlural: 'Target Tenants',
        title: { type: #STANDARD, value: 'comm_arrangement_id' }
    }
}
@Consumption.valueHelpDefault.fetchValues: #AUTOMATICALLY_WHEN_DISPLAYED
define custom entity ZPUSH_R_COMM_ARR
{
      @UI.facet                  : [ {
        id                       : 'idIdentification',
        type                     : #IDENTIFICATION_REFERENCE,
        label                    : 'Target Tenant',
        position                 : 10
      } ]
      @UI.hidden                 : true
  key comm_arrangement_uuid      : abap.raw(16);

      @UI.lineItem               : [ {
        position                 : 10,
        importance               : #HIGH
      } ]
      @UI.identification         : [ {
        position                 : 10,
        importance               : #HIGH
      } ]
      @UI.selectionField         : [ {
        position                 : 10
      } ]
      comm_arrangement_id        : ZPUSH_T_COMM_ARRANGEMENT_ID;

      @UI.lineItem               : [ {
        position                 : 20 ,
        importance               : #HIGH
      } ]
      @UI.identification         : [ {
        position                 : 20 ,
        importance               : #HIGH
      } ]
      @UI.selectionField         : [ {
        position                 : 20
      } ]
      comm_system_id             : ZPUSH_T_COMM_SYSTEM_ID;

      @UI.lineItem               : [ {
        position                 : 30 ,
        importance               : #MEDIUM
      } ]
      @UI.identification         : [ {
        position                 : 30 ,
        importance               : #MEDIUM
      } ]
      outb_comm_user_auth_method : ZPUSH_T_OUTB_COMM_USER_AUTH_M;

      @UI.lineItem               : [ {
        position                 : 40 ,
        importance               : #MEDIUM
      } ]
      @UI.identification         : [ {
        position                 : 40 ,
        importance               : #MEDIUM
      } ]
      outb_comm_user_name        : ZPUSH_T_OUTB_COMM_USER_NAME;
}
