CLASS lsc_zr_cs01_custmrs_05 DEFINITION
  INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

ENDCLASS.


CLASS lsc_zr_cs01_custmrs_05 IMPLEMENTATION.

  METHOD adjust_numbers.

    IF mapped-Customers_05 IS INITIAL.
      RETURN.
    ENDIF.

    TRY.

        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr = '01'
            object      = 'ZCUST05NR'
            quantity    = CONV #( lines( mapped-Customers_05 ) )
          IMPORTING
            number            = DATA(lv_number)
            returncode        = DATA(lv_returncode)
            returned_quantity = DATA(lv_returned_quantity)
        ).

      CATCH cx_number_ranges INTO DATA(lx_number_range).

        RAISE SHORTDUMP TYPE cx_number_ranges
          EXPORTING
            previous = lx_number_range.

    ENDTRY.

    DATA(lv_next_number) =
        CONV i( lv_number )
      - CONV i( lv_returned_quantity )
      + 1.

    LOOP AT mapped-Customers_05
      ASSIGNING FIELD-SYMBOL(<ls_customer>).

      <ls_customer>-Customerid =
        |{ lv_next_number WIDTH = 6 PAD = '0' ALIGN = RIGHT }|.

      lv_next_number += 1.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.



CLASS lhc_zr_cs01_custmrs_05 DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations
      FOR GLOBAL AUTHORIZATION
      IMPORTING
      REQUEST requested_authorizations FOR Customers_05
      RESULT result.

    METHODS validateEmail
      FOR VALIDATE ON SAVE
      IMPORTING
        keys FOR Customers_05~validateEmail.

    METHODS setCity
      FOR DETERMINE ON MODIFY
      IMPORTING
        keys FOR Customers_05~setCity.

    METHODS cancelOrders
      FOR MODIFY
      IMPORTING
                keys   FOR ACTION Customers_05~cancelOrders
      RESULT    result.
    METHODS showStatistic FOR MODIFY
       keys FOR ACTION Customers_05~showStatistic RESULT result.

ENDCLASS.



CLASS lhc_zr_cs01_custmrs_05 IMPLEMENTATION.

  METHOD get_global_authorizations.

  ENDMETHOD.


  METHOD validateEmail.

    READ ENTITIES OF zr_cs01_custmrs_05 IN LOCAL MODE
      ENTITY Customers_05
        FIELDS ( Email )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_customers).

    LOOP AT lt_customers INTO DATA(ls_customer).

      APPEND VALUE #(
        %tky        = ls_customer-%tky
        %state_area = 'VALIDATE_EMAIL'
      ) TO reported-Customers_05.

      IF ls_customer-Email IS INITIAL.
        CONTINUE.
      ENDIF.

      IF zcl_cs1_email_validator_05=>is_valid(
           iv_email = CONV string( ls_customer-Email )
         ) = abap_false.

        APPEND VALUE #(
          %tky = ls_customer-%tky
        ) TO failed-Customers_05.

        APPEND VALUE #(
          %tky        = ls_customer-%tky
          %state_area = 'VALIDATE_EMAIL'
          %msg        = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text     = |Invalid email address: { ls_customer-Email }|
                        )
          %element-Email = if_abap_behv=>mk-on
        ) TO reported-Customers_05.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD setCity.

    READ ENTITIES OF zr_cs01_custmrs_05 IN LOCAL MODE
      ENTITY Customers_05
        FIELDS ( Postcode City )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_customers).

    LOOP AT lt_customers INTO DATA(ls_customer).

      IF ls_customer-Postcode IS INITIAL.
        CONTINUE.
      ENDIF.

      SELECT SINGLE city
        FROM zcs01_cities_05
        WHERE postcode = @ls_customer-Postcode
        INTO @DATA(lv_city).

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF ls_customer-City = lv_city.
        CONTINUE.
      ENDIF.

      MODIFY ENTITIES OF zr_cs01_custmrs_05 IN LOCAL MODE
        ENTITY Customers_05
          UPDATE FIELDS ( City )
          WITH VALUE #(
            (
              %tky = ls_customer-%tky
              City = lv_city
            )
          ).

    ENDLOOP.

  ENDMETHOD.


  METHOD cancelOrders.

    READ ENTITIES OF zr_cs01_custmrs_05 IN LOCAL MODE
      ENTITY Customers_05
        FIELDS ( Customerid )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_customers).

    LOOP AT lt_customers INTO DATA(ls_customer).

      SELECT customerid,
             orderid,
             status
        FROM zcs01_custord_05
        WHERE customerid = @ls_customer-Customerid
        INTO TABLE @DATA(lt_orders).

      LOOP AT lt_orders INTO DATA(ls_order).

        DATA(lv_new_status) = ls_order-status.

        CASE ls_order-status.

          WHEN 'BA'.
            lv_new_status = 'SA'.

          WHEN 'BB'.
            lv_new_status = 'SB'.

          WHEN 'BN'.
            lv_new_status = 'SN'.

          WHEN 'BO'.
            lv_new_status = 'SO'.

          WHEN OTHERS.
            CONTINUE.

        ENDCASE.

        MODIFY ENTITIES OF zr_cs01_custord_05
          ENTITY Orders_05
            UPDATE FIELDS ( Status )
            WITH VALUE #(
              (
                Customerid = ls_order-customerid
                Orderid    = ls_order-orderid
                Status     = lv_new_status
              )
            )
          FAILED DATA(lt_failed_orders)
          REPORTED DATA(lt_reported_orders).

      ENDLOOP.

      APPEND VALUE #(
        %tky = ls_customer-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-success
                 text     =
                   |Bestellungen des Kunden { ls_customer-Customerid } wurden storniert!|
               )
      ) TO reported-Customers_05.

      APPEND VALUE #(
        %tky   = ls_customer-%tky
        %param = ls_customer
      ) TO result.

    ENDLOOP.

  ENDMETHOD.

  METHOD showStatistic.

  READ ENTITIES OF zr_cs01_custmrs_05 IN LOCAL MODE
    ENTITY Customers_05
      FIELDS ( Customerid )
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_customers).

  READ ENTITIES OF zr_cs01_custmrs_05 IN LOCAL MODE
    ENTITY Customers_05
      ALL FIELDS
      WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

  result = VALUE #(
    FOR ls_result IN lt_result
    (
      %tky   = ls_result-%tky
      %param = ls_result
    )
  ).

  SELECT SINGLE classname,
                interfacename
    FROM zcs01_sttistk_05
    WHERE active = @abap_true
    INTO @DATA(ls_config).

  IF sy-subrc <> 0.

    LOOP AT lt_customers INTO DATA(ls_customer_no_config).

      APPEND VALUE #(
        %tky = ls_customer_no_config-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-information
                 text     = 'No active statistics configuration found'
               )
      ) TO reported-Customers_05.

    ENDLOOP.

    RETURN.

  ENDIF.


  DATA lo_typedescr TYPE REF TO cl_abap_typedescr.

  CALL METHOD cl_abap_typedescr=>describe_by_name
    EXPORTING
      p_name      = ls_config-classname
    RECEIVING
      p_descr_ref = lo_typedescr
    EXCEPTIONS
      type_not_found = 1
      OTHERS         = 2.

  IF sy-subrc <> 0.

    LOOP AT lt_customers INTO DATA(ls_customer_invalid_class).

      APPEND VALUE #(
        %tky = ls_customer_invalid_class-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-information
                 text     = |Cannot show statistics. Class { ls_config-classname } is invalid.|
               )
      ) TO reported-Customers_05.

    ENDLOOP.

    RETURN.

  ENDIF.


  DATA(lo_classdescr) =
    CAST cl_abap_classdescr( lo_typedescr ).


  DATA(lv_interface_found) = abap_false.

  LOOP AT lo_classdescr->interfaces INTO DATA(ls_interface).

    IF ls_interface-name = ls_config-interfacename.
      lv_interface_found = abap_true.
      EXIT.
    ENDIF.

  ENDLOOP.


  IF lv_interface_found = abap_false.

    LOOP AT lt_customers INTO DATA(ls_customer_wrong_interface).

      APPEND VALUE #(
        %tky = ls_customer_wrong_interface-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-information
                 text     = |{ ls_config-classname } must implement { ls_config-interfacename }.|
               )
      ) TO reported-Customers_05.

    ENDLOOP.

    RETURN.

  ENDIF.


  DATA lo_object TYPE REF TO object.

  CREATE OBJECT lo_object
    TYPE (ls_config-classname).


  DATA(lo_statistics) =
    CAST zif_statistics05( lo_object ).


  LOOP AT lt_customers INTO DATA(ls_customer).

    DATA(lv_average) =
      lo_statistics->averagesales(
        iv_customerid = ls_customer-Customerid
      ).

    DATA(lv_max) =
      lo_statistics->maxsales(
        iv_customerid = ls_customer-Customerid
      ).

    DATA(lv_day) =
      lo_statistics->daysales(
        iv_customerid = ls_customer-Customerid
      ).


    APPEND VALUE #(
      %tky = ls_customer-%tky
      %msg = new_message_with_text(
               severity = if_abap_behv_message=>severity-information
               text     = |Day Sales: { lv_day DECIMALS = 2 }|
             )
    ) TO reported-Customers_05.


    APPEND VALUE #(
      %tky = ls_customer-%tky
      %msg = new_message_with_text(
               severity = if_abap_behv_message=>severity-information
               text     = |Max Sales: { lv_max DECIMALS = 2 }|
             )
    ) TO reported-Customers_05.


    APPEND VALUE #(
      %tky = ls_customer-%tky
      %msg = new_message_with_text(
               severity = if_abap_behv_message=>severity-information
               text     = |Average Sales: { lv_average DECIMALS = 2 }|
             )
    ) TO reported-Customers_05.

  ENDLOOP.

ENDMETHOD.

ENDCLASS.
