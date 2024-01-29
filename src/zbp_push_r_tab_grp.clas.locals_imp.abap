CLASS lhc_TableGroup DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR TableGroup RESULT result.

    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR TableGroup RESULT result.

    METHODS Push FOR MODIFY
      IMPORTING keys FOR ACTION TableGroup~Push.

ENDCLASS.

CLASS lhc_TableGroup IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD get_global_features.

    IF requested_features-%action-Push = if_abap_behv=>mk-on.
      DATA(has_ca) = zcl_push_helper=>get_instance( )->has_ca_for_target_tenant( ).

      result-%action-Push = COND #( WHEN has_ca = abap_false
                                    THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled ).
    ENDIF.

  ENDMETHOD.

  METHOD Push.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).

      zcl_push_helper=>get_instance( )->push_tab_grp_to_target_tenant(
          tab_grp_name        = <key>-TableGroupName
          comm_arrangement_id = <key>-%param-comm_arrangement_id
      ).

*      zcl_push_helper=>get_instance( )->write_log_entry(
*          log_entry = VALUE #( action_type         = 'I'
*                               tab_grp_name        = <key>-TableGroupName
*                               comm_arrangement_id = <key>-%param-comm_arrangement_id
*                               message_type        = 'S'
*                               message_text        = 'Data has been successfully pushed'
*                               num_tables          = 0
*                               num_rows            = 0 )
*      ).
    ENDLOOP.

*    APPEND VALUE #( %msg = new_message_with_text(
*                               severity = if_abap_behv_message=>severity-error
*                               text = |{ l2 } - { l3 }|
*                            ) ) TO reported-tablegroup.


  ENDMETHOD.

ENDCLASS.
