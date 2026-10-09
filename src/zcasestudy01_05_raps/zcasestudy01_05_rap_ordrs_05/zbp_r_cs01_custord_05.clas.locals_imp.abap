CLASS lhc_zr_cs01_custord_05 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Orders_05
        RESULT result,
      convertCurrency FOR DETERMINE ON SAVE
       keys FOR Orders_05~convertCurrency.
ENDCLASS.

CLASS lhc_zr_cs01_custord_05 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD convertCurrency.

  READ ENTITIES OF ZR_CS01_CUSTORD_05 IN LOCAL MODE
    ENTITY Orders_05
      FIELDS (
        OrderTotal
        Currency
        TargetCurrency
        ChangeRateDate
        OrderTotalConverted
      )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_orders).


  LOOP AT lt_orders INTO DATA(ls_order).

    IF ls_order-OrderTotal IS INITIAL
       OR ls_order-Currency IS INITIAL
       OR ls_order-TargetCurrency IS INITIAL.

      CONTINUE.

    ENDIF.


    "----------------------------------------------------------
    " Same currency -> no conversion necessary
    "----------------------------------------------------------

    IF ls_order-Currency = ls_order-TargetCurrency.

      IF ls_order-OrderTotalConverted <> ls_order-OrderTotal.

        MODIFY ENTITIES OF ZR_CS01_CUSTORD_05 IN LOCAL MODE
          ENTITY Orders_05
            UPDATE FIELDS ( OrderTotalConverted )
            WITH VALUE #(
              (
                %tky                 = ls_order-%tky
                OrderTotalConverted = ls_order-OrderTotal
              )
            ).

      ENDIF.

      CONTINUE.

    ENDIF.


    "----------------------------------------------------------
    " Determine which date should be used for the rate lookup
    "----------------------------------------------------------

    DATA(lv_rate_date) =
      ls_order-ChangeRateDate.

    IF lv_rate_date IS INITIAL.

      lv_rate_date =
        cl_abap_context_info=>get_system_date( ).

    ENDIF.


    "----------------------------------------------------------
    " Find newest applicable exchange rate
    "----------------------------------------------------------

    SELECT FROM zcs01_rates_05
      FIELDS rate
      WHERE from_curr  = @ls_order-Currency
        AND to_curr    = @ls_order-TargetCurrency
        AND valid_from <= @lv_rate_date
      ORDER BY valid_from DESCENDING
      INTO TABLE @DATA(lt_rates)
      UP TO 1 ROWS.


    IF lt_rates IS INITIAL.
      CONTINUE.
    ENDIF.


    DATA(lv_rate) =
      lt_rates[ 1 ]-rate.


    "----------------------------------------------------------
    " Calculate converted amount
    "----------------------------------------------------------

    DATA lv_calc TYPE p LENGTH 16 DECIMALS 5.
    DATA lv_converted TYPE zorder_totalt1.

    lv_calc =
      ls_order-OrderTotal * lv_rate.

    lv_converted =
      lv_calc.


    "----------------------------------------------------------
    " Update ONLY the calculated field.
    " Do NOT modify ChangeRateDate here because it is a
    " trigger field of this determination.
    "----------------------------------------------------------

    IF ls_order-OrderTotalConverted <> lv_converted.

      MODIFY ENTITIES OF ZR_CS01_CUSTORD_05 IN LOCAL MODE
        ENTITY Orders_05
          UPDATE FIELDS ( OrderTotalConverted )
          WITH VALUE #(
            (
              %tky                 = ls_order-%tky
              OrderTotalConverted = lv_converted
            )
          ).

    ENDIF.

  ENDLOOP.

ENDMETHOD.

ENDCLASS.
