CLASS zcl_example_tab_gen_test_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_example_tab_gen_test_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    GET TIME STAMP FIELD DATA(lv_timestamp).

    DATA lt_example_tab_data_1 TYPE STANDARD TABLE OF zexample_tab_1 WITH EMPTY KEY.

    TRY.
        lt_example_tab_data_1 = VALUE #(
                            ( event_uuid            = cl_system_uuid=>create_uuid_x16_static( )
                              event_id              = 'E001'
                              event_name            = 'Devtoberfest 2023'
                              location              = ''
                              is_online             = abap_true
                              date_from             = '20230918'
                              date_to               = '20231013'
                              local_last_changed_at = lv_timestamp
                              last_changed_at       = lv_timestamp )


                            ( event_uuid            = cl_system_uuid=>create_uuid_x16_static( )
                              event_id              = 'E002'
                              event_name            = 'Steampunk Customer & Partner Roundtable #5'
                              location              = ''
                              is_online             = abap_true
                              date_from             = '20231024'
                              date_to               = '20231024'
                              local_last_changed_at = lv_timestamp
                              last_changed_at       = lv_timestamp )

                            ( event_uuid            = cl_system_uuid=>create_uuid_x16_static( )
                              event_id              = 'E003'
                              event_name            = 'SAP TechEd 2023'
                              location              = 'Bangalore'
                              is_online             = abap_false
                              date_from             = '20231102'
                              date_to               = '20231103'
                              local_last_changed_at = lv_timestamp
                              last_changed_at       = lv_timestamp )

                            ( event_uuid            = cl_system_uuid=>create_uuid_x16_static( )
                              event_id              = 'E004'
                              event_name            = 'SAP TechEd 2023 Virtual'
                              location              = ''
                              is_online             = abap_true
                              date_from             = '20231102'
                              date_to               = '20231103'
                              local_last_changed_at = lv_timestamp
                              last_changed_at       = lv_timestamp )

                            ( event_uuid            = cl_system_uuid=>create_uuid_x16_static( )
                              event_id              = 'E005'
                              event_name            = 'SAPinsider'
                              location              = 'Copenhagen'
                              is_online             = abap_false
                              date_from             = '20231114'
                              date_to               = '20231116'
                              local_last_changed_at = lv_timestamp
                              last_changed_at       = lv_timestamp )

                            ( event_uuid            = cl_system_uuid=>create_uuid_x16_static( )
                              event_id              = 'E006'
                              event_name            = 'Steampunk Customer & Partner Roundtable #6'
                              location              = ''
                              is_online             = abap_true
                              date_from             = '20231123'
                              date_to               = '20231123'
                              local_last_changed_at = lv_timestamp
                              last_changed_at       = lv_timestamp ) ) ##NO_TEXT.
      CATCH cx_uuid_error.
        "handle exception
    ENDTRY.

    DELETE FROM zexample_tab_1.                         "#EC CI_NOWHERE
    INSERT zexample_tab_1 FROM TABLE @lt_example_tab_data_1.
    COMMIT WORK.

    out->write( |ZEXAMPLE_TAB_1: { sy-dbcnt } entries modified| ) ##NO_TEXT.

    DATA lt_example_tab_data_2 TYPE STANDARD TABLE OF zexample_tab_2 WITH EMPTY KEY.

    MOVE-CORRESPONDING lt_example_tab_data_1 TO lt_example_tab_data_2.

    DELETE FROM zexample_tab_2.                         "#EC CI_NOWHERE
    INSERT zexample_tab_2 FROM TABLE @lt_example_tab_data_2.
    COMMIT WORK.

    out->write( |ZEXAMPLE_TAB_2: { sy-dbcnt } entries modified| ) ##NO_TEXT.

  ENDMETHOD.

ENDCLASS.
