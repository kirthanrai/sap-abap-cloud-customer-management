CLASS zcl_cs1_fill_status_05 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_cs1_fill_status_05 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DELETE FROM zcs01_status_05.

    DATA lt_status TYPE STANDARD TABLE OF zcs01_status_05.

    lt_status = VALUE #(

      ( spras = 'D'
        status = 'BA'
        status_text = 'Bestellung ausgeliefert' )

      ( spras = 'D'
        status = 'BB'
        status_text = 'Bestellung bezahlt' )

      ( spras = 'D'
        status = 'BN'
        status_text = 'Bestellung neu' )

      ( spras = 'D'
        status = 'BO'
        status_text = 'Bestellung nicht bezahlt' )

      ( spras = 'D'
        status = 'SA'
        status_text = 'Bestellung ausgeliefert - Stornieren' )

      ( spras = 'D'
        status = 'SB'
        status_text = 'Bestellung bezahlt - Stornieren' )

      ( spras = 'D'
        status = 'SN'
        status_text = 'Bestellung neu - Stornieren' )

      ( spras = 'D'
        status = 'SO'
        status_text = 'Bestellung nicht bezahlt - Stornieren' )


      ( spras = 'E'
        status = 'BA'
        status_text = 'Order delivered' )

      ( spras = 'E'
        status = 'BB'
        status_text = 'Order paid' )

      ( spras = 'E'
        status = 'BN'
        status_text = 'New order' )

      ( spras = 'E'
        status = 'BO'
        status_text = 'Order not paid' )

      ( spras = 'E'
        status = 'SA'
        status_text = 'Order delivered - Cancel' )

      ( spras = 'E'
        status = 'SB'
        status_text = 'Order paid - Cancel' )

      ( spras = 'E'
        status = 'SN'
        status_text = 'New order - Cancel' )

      ( spras = 'E'
        status = 'SO'
        status_text = 'Order not paid - Cancel' )

    ).

    INSERT zcs01_status_05 FROM TABLE @lt_status.

    out->write(
      |Status table recreated: { sy-dbcnt } records inserted.|
    ).

  ENDMETHOD.

ENDCLASS.
