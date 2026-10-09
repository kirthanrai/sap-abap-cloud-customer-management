CLASS zcl_cs1_order_count_05 DEFINITION

  PUBLIC

  FINAL

  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_sadl_exit_calc_element_read.

ENDCLASS.


CLASS zcl_cs1_order_count_05 IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    IF line_exists(
         it_requested_calc_elements[
           table_line = 'ORDERCOUNT'
         ] ).

      INSERT CONV string( 'CUSTOMERID' )
        INTO TABLE et_requested_orig_elements.

    ENDIF.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.

    TYPES:

      BEGIN OF ty_original,
        customerid TYPE zcustomeridt1,
      END OF ty_original,

      BEGIN OF ty_calculated,
        ordercount TYPE i,
      END OF ty_calculated.

    DATA lt_original   TYPE STANDARD TABLE OF ty_original.
    DATA lt_calculated TYPE STANDARD TABLE OF ty_calculated.

    lt_original = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original INTO DATA(ls_original).

      SELECT COUNT( * )
        FROM zcs01_custord_05
        WHERE customerid = @ls_original-customerid
          AND status NOT IN ( 'SA', 'SB', 'SN', 'SO' )
        INTO @DATA(lv_count).

      APPEND VALUE #(
        ordercount = lv_count
      ) TO lt_calculated.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_calculated ).

  ENDMETHOD.

ENDCLASS.
