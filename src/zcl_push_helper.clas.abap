CLASS zcl_push_helper DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.
    TYPES BEGIN OF ty_log_entry.
    TYPES   action_type         TYPE zpush_log_entry-action_type.
    TYPES   tab_grp_name        TYPE zpush_log_entry-tab_grp_name.
    TYPES   comm_arrangement_id TYPE zpush_log_entry-comm_arrangement_id.
    TYPES   message_type        TYPE zpush_log_entry-message_type.
    TYPES   message_text        TYPE zpush_log_entry-message_text.
    TYPES   num_tables          TYPE zpush_log_entry-num_tables.
    TYPES   num_rows            TYPE zpush_log_entry-num_rows.
    TYPES END OF ty_log_entry.

    CONSTANTS c_comm_scenario_id TYPE if_com_scenario=>ty_cscn-id VALUE 'ZPUSH_DATA'.

    CLASS-DATA singleton TYPE REF TO zcl_push_helper.

    CLASS-METHODS get_instance
      RETURNING VALUE(result) TYPE REF TO zcl_push_helper.

    METHODS has_ca_for_target_tenant
      RETURNING VALUE(result) TYPE abap_bool.

    METHODS push_tab_grp_to_target_tenant
      IMPORTING tab_grp_name        TYPE zpush_log_entry-tab_grp_name
                comm_arrangement_id TYPE zpush_log_entry-comm_arrangement_id.

    METHODS write_Log_entry
      IMPORTING log_entry TYPE TY_Log_entry.

ENDCLASS.


CLASS zcl_push_helper IMPLEMENTATION.

  METHOD get_instance.

    IF singleton IS NOT BOUND.
      CREATE OBJECT singleton.
    ENDIF.

    result = singleton.

  ENDMETHOD.

  METHOD has_ca_for_target_tenant.

    cl_com_arrangement_factory=>create_instance( )->query_ca(
      EXPORTING
        is_query           = VALUE #( cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = c_comm_scenario_id ) ) )
      IMPORTING
        et_com_arrangement = FINAL(comm_arrangements) ).

    result = boolc( comm_arrangements IS NOT INITIAL ).

  ENDMETHOD.

  METHOD push_tab_grp_to_target_tenant.

    "get database tables
    SELECT FROM zpush_tab_grp_i FIELDS ( tab_name ) WHERE tab_grp_name = @tab_grp_name ORDER BY tab_name INTO TABLE @FINAL(tab_names).
    IF tab_names IS INITIAL.
      RETURN.
    ENDIF.

    "get RFC destination
    IF comm_arrangement_id IS INITIAL.
      RETURN.
    ENDIF.

    cl_com_arrangement_factory=>create_instance( )->query_ca(
      EXPORTING
        is_query           = VALUE #( cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = c_comm_scenario_id ) ) )
      IMPORTING
        et_com_arrangement = FINAL(comm_arrangements) ).

    LOOP AT comm_arrangements INTO FINAL(comm_arrangement).
      IF comm_arrangement->get_name( ) = comm_arrangement_id.
        FINAL(comm_system_id) = comm_arrangement->get_comm_system_id( ).
        EXIT.
      ENDIF.
    ENDLOOP.

    IF comm_system_id IS INITIAL.
      RETURN.
    ENDIF.

    TRY.
        DATA(destination) = cl_rfc_destination_provider=>create_by_comm_arrangement(
            comm_scenario  = c_comm_scenario_id
            comm_system_id = comm_system_id
        ).

        FINAL(destination_name) = destination->get_destination_name( ).

      CATCH cx_rfc_dest_provider_error.
        RETURN.
    ENDTRY.

    "select data
    TYPES BEGIN OF ty_table_w_payload.
    TYPES   tabname_source      TYPE c LENGTH 30.
    TYPES   payload             TYPE xstring.
    TYPES END OF ty_table_w_payload.
    TYPES ty_tables_w_payload TYPE STANDARD TABLE OF ty_table_w_payload WITH DEFAULT KEY .

    DATA tables_w_payload TYPE ty_tables_w_payload.
    DATA lv_dbtab_xml TYPE xstring.

    FIELD-SYMBOLS <lt_dbtab_data> TYPE STANDARD TABLE.

    DATA r_dbtab_data TYPE REF TO data.

    LOOP AT tab_names INTO DATA(tab_name).
      CREATE DATA r_dbtab_data TYPE STANDARD TABLE OF (tab_name) WITH EMPTY KEY.
      ASSIGN r_dbtab_data->* TO <lt_dbtab_data>.

      TRY.
          DATA(lv_table_name_checked) = cl_abap_dyn_prg=>check_table_name_str(
              val      = CONV string( tab_name )
              packages = space
          ).

          SELECT FROM (lv_table_name_checked) FIELDS * INTO TABLE @<lt_dbtab_data>.

        CATCH cx_root.
          RETURN.
      ENDTRY.

      TRY.
          "serialize table data to xml or json
          IF 1 = 2.
            "xml
            CALL TRANSFORMATION id
              SOURCE root = <lt_dbtab_data>
              RESULT XML lv_dbtab_xml.
          ELSE.
            "json
            DATA(lo_xml_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
            CALL TRANSFORMATION id
              SOURCE root = <lt_dbtab_data>
              RESULT XML lo_xml_writer.

            lv_dbtab_xml = lo_xml_writer->get_output( ).
            FREE lo_xml_writer.
          ENDIF.

        CATCH cx_root INTO DATA(lx_root) ##catch_all.
          DATA(error_code) = 1.
          DATA(error_message) = lx_root->get_text( ).
          RETURN.
      ENDTRY.

      APPEND VALUE #( tabname_source = tab_name
                      payload        = lv_dbtab_xml ) TO tables_w_payload.
      FREE lv_dbtab_xml.
    ENDLOOP.

    DATA lv_payload_xml TYPE xstring.

    CALL TRANSFORMATION id
      SOURCE root = tables_w_payload
      RESULT XML lv_payload_xml.

    FREE tables_w_payload.

    CALL FUNCTION 'Z_PUSH_WRITE_TAB_DATA' DESTINATION destination_name
      EXPORTING
        iv_payload    = lv_payload_xml
      IMPORTING
        ev_error_code = error_code
*       et_return     = et_return
      EXCEPTIONS
        OTHERS        = 1.
    IF sy-subrc <> 0.
      error_code = sy-subrc.
      error_message = 'RFC error occurred' ##NO_TEXT.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD write_log_entry.

    GET TIME STAMP FIELD FINAL(current_timestamp).

    TRY.
        FINAL(insert_log_entry) = VALUE zpush_log_entry(
          log_uuid              = cl_system_uuid=>create_uuid_x16_static( )
          action_type           = log_entry-action_type
          tab_grp_name          = log_entry-tab_grp_name
          comm_arrangement_id   = log_entry-comm_arrangement_id
          message_type          = log_entry-message_type
          message_text          = log_entry-message_text
          num_tables            = log_entry-num_tables
          num_rows              = log_entry-num_rows
          local_last_changed_by = cl_abap_context_info=>get_user_alias( )
          local_last_changed_at = current_timestamp
          last_changed_at       = current_timestamp
        ).

      CATCH cx_uuid_error INTO FINAL(x_uuid_error).
        RAISE SHORTDUMP x_uuid_error.
    ENDTRY.

    INSERT zpush_log_entry FROM @insert_log_entry.

  ENDMETHOD.

ENDCLASS.
