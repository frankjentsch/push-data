CLASS zcl_push_r_comm_arr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.


CLASS zcl_push_r_comm_arr IMPLEMENTATION.

  METHOD if_rap_query_provider~select.
    "https://help.sap.com/docs/abap-cloud/abap-rap/implementing-unmanaged-query?version=sap_btp

    TRY.
        CASE io_request->get_entity_id( ).

          WHEN 'ZPUSH_R_COMM_ARR' .
            " find communication arrangement by communication scenario
            cl_com_arrangement_factory=>create_instance( )->query_ca(
              EXPORTING
                is_query           = VALUE #( cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = zcl_push_helper=>c_comm_scenario_id ) ) )
              IMPORTING
                et_com_arrangement = DATA(comm_arrangements) ).

            DATA results TYPE STANDARD TABLE OF zpush_r_comm_arr WITH EMPTY KEY.

            LOOP AT comm_arrangements INTO DATA(comm_arrangement).
              APPEND VALUE #(
                comm_arrangement_uuid      = comm_arrangement->get_uuid( )
                comm_arrangement_id        = comm_arrangement->get_name( )
                comm_system_id             = comm_arrangement->get_comm_system_id( )
                outb_comm_user_auth_method = comm_arrangement->get_outb_comm_user_auth_method( )
                outb_comm_user_name        = comm_arrangement->get_outb_comm_user_name( )
              ) TO results.
            ENDLOOP.

            SORT results BY comm_arrangement_id comm_arrangement_uuid.

            "filter
            TRY.
                DATA(filter) = io_request->get_filter( )->get_as_ranges( ).
              CATCH cx_rap_query_filter_no_range.
                CLEAR filter.
            ENDTRY.

            IF filter IS NOT INITIAL.
              DATA lt_so_comm_arrangement_uuid    TYPE RANGE OF zpush_r_comm_arr-comm_arrangement_uuid.
              DATA lt_so_comm_arrangement_id      TYPE RANGE OF zpush_r_comm_arr-comm_arrangement_id.
              DATA lt_so_comm_system_id           TYPE RANGE OF zpush_r_comm_arr-comm_system_id.
              DATA lt_so_outb_comm_user_auth_meth TYPE RANGE OF zpush_r_comm_arr-outb_comm_user_auth_method.
              DATA lt_so_outb_comm_user_name      TYPE RANGE OF zpush_r_comm_arr-outb_comm_user_name.

              LOOP AT filter ASSIGNING FIELD-SYMBOL(<filter>).
                CASE to_lower( <filter>-name ).
                  WHEN 'comm_arrangement_uuid'.      lt_so_comm_arrangement_uuid    = CORRESPONDING #( <filter>-range ).
                  WHEN 'comm_arrangement_id'.        lt_so_comm_arrangement_id      = CORRESPONDING #( <filter>-range ).
                  WHEN 'comm_system_id'.             lt_so_comm_system_id           = CORRESPONDING #( <filter>-range ).
                  WHEN 'outb_comm_user_auth_method'. lt_so_outb_comm_user_auth_meth = CORRESPONDING #( <filter>-range ).
                  WHEN 'outb_comm_user_name'.        lt_so_outb_comm_user_name      = CORRESPONDING #( <filter>-range ).
                ENDCASE.
              ENDLOOP.

              DELETE results WHERE comm_arrangement_uuid      NOT IN lt_so_comm_arrangement_uuid
                                OR comm_arrangement_id        NOT IN lt_so_comm_arrangement_id
                                OR comm_system_id             NOT IN lt_so_comm_system_id
                                OR outb_comm_user_auth_method NOT IN lt_so_outb_comm_user_auth_meth
                                OR outb_comm_user_name        NOT IN lt_so_outb_comm_user_name.
            ENDIF.

            "request data
            IF io_request->is_data_requested( ).
              "paging
              DATA(offset) = io_request->get_paging( )->get_offset( ).
              DATA(page_size) = io_request->get_paging( )->get_page_size( ).

              IF offset > 0.
                DELETE results TO offset.
              ENDIF.

              IF page_size <> if_rap_query_paging=>page_size_unlimited.
                DELETE results FROM page_size + 1.
              ENDIF.

              "sorting
              DATA(sort_elements) = io_request->get_sort_elements( ).
              DATA(sort_criteria) = VALUE string_table( FOR sort_element IN sort_elements
                                                         ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true THEN ` DESCENDING`
                                                                                                                                         ELSE `` ) ) ).
              DATA(sort_string) = concat_lines_of( table = sort_criteria sep = ` ` ).
              SORT results BY (sort_string).

              io_response->set_data( results ).
            ENDIF.

            "request count
            IF io_request->is_total_numb_of_rec_requested( ).
              io_response->set_total_number_of_records( lines( results ) ).
            ENDIF.

        ENDCASE.

      CATCH cx_rap_query_provider.
        RETURN.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
