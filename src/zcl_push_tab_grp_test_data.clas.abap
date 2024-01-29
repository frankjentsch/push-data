CLASS zcl_push_tab_grp_test_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_push_tab_grp_test_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "fill table ZPUSH_TAB_GRP
    DATA lt_tab_grp TYPE STANDARD TABLE OF zpush_tab_grp WITH EMPTY KEY.

    lt_tab_grp = VALUE #(
        ( tab_grp_name = 'EXAMPLE_GROUP_1' tab_grp_desc = 'Table ZEXAMPLE_TAB_1' )
        ( tab_grp_name = 'EXAMPLE_GROUP_2' tab_grp_desc = 'Table ZEXAMPLE_TAB_2' )
        ( tab_grp_name = 'EXAMPLE_GROUP_3' tab_grp_desc = 'Tables ZEXAMPLE_TAB_1 and ZEXAMPLE_TAB_2' )
    ) ##NO_TEXT.

    DELETE FROM zpush_tab_grp.                          "#EC CI_NOWHERE
    INSERT zpush_tab_grp FROM TABLE @lt_tab_grp.
    COMMIT WORK.

    out->write( |ZPUSH_TAB_GRP: { sy-dbcnt } entries modified| ) ##NO_TEXT.

    "fill table ZPUSH_TAB_GRP_I
    DATA lt_tab_grp_i TYPE STANDARD TABLE OF zpush_tab_grp_I WITH EMPTY KEY.

    lt_tab_grp_I = VALUE #(
        ( tab_grp_name = 'EXAMPLE_GROUP_1' tab_name = 'ZEXAMPLE_TAB_1' )
        ( tab_grp_name = 'EXAMPLE_GROUP_2' tab_name = 'ZEXAMPLE_TAB_2' )
        ( tab_grp_name = 'EXAMPLE_GROUP_3' tab_name = 'ZEXAMPLE_TAB_1' )
        ( tab_grp_name = 'EXAMPLE_GROUP_3' tab_name = 'ZEXAMPLE_TAB_2' )
    ) ##NO_TEXT.

    DELETE FROM zpush_tab_grp_I.                        "#EC CI_NOWHERE
    INSERT zpush_tab_grp_I FROM TABLE @lt_tab_grp_I.
    COMMIT WORK.

    out->write( |ZPUSH_TAB_GRP_I: { sy-dbcnt } entries modified| ) ##NO_TEXT.

  ENDMETHOD.

ENDCLASS.
