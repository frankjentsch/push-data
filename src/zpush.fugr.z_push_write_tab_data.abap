FUNCTION z_push_write_tab_data.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(PAYLOAD) TYPE  XSTRING
*"  EXPORTING
*"     VALUE(ERROR_CODE) TYPE  I
*"     VALUE(ERROR_MESSAGE) TYPE  BAPIRET2
*"----------------------------------------------------------------------
  TYPES BEGIN OF ty_table_w_payload.
  TYPES   tabname_source      TYPE c LENGTH 30.
  TYPES   payload             TYPE xstring.
  TYPES END OF ty_table_w_payload.
  TYPES ty_tables_w_payload TYPE STANDARD TABLE OF ty_table_w_payload WITH DEFAULT KEY .

  DATA tables_w_payload TYPE ty_tables_w_payload.

  TRY.
      CALL TRANSFORMATION id
        SOURCE XML payload
        RESULT root = tables_w_payload.

      FREE payload.

      DATA r_dbtab_data TYPE REF TO data.

      LOOP AT tables_w_payload ASSIGNING FIELD-SYMBOL(<table_w_payload>).
        CREATE DATA r_dbtab_data TYPE STANDARD TABLE OF (<table_w_payload>-tabname_source) WITH EMPTY KEY.

        CALL TRANSFORMATION id
          SOURCE XML <table_w_payload>-payload
          RESULT root = r_dbtab_data->*.

        FREE <table_w_payload>-payload.

        DATA(lv_table_name_checked) = cl_abap_dyn_prg=>check_table_name_str(
            val      = <table_w_payload>-tabname_source
            packages = space
        ).

        INSERT (lv_table_name_checked) FROM TABLE @r_dbtab_data->*.

        FREE r_dbtab_data.
      ENDLOOP.

      COMMIT WORK.

    CATCH cx_root INTO DATA(x_root) ##catch_all.
      ROLLBACK WORK.
      error_code = 1.
      error_message = VALUE #( type = 'E' message = x_root->get_text( ) ).
  ENDTRY.

ENDFUNCTION.
