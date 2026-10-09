CLASS zcl_cs1_fill_rates_05 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_cs1_fill_rates_05 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA lt_rates TYPE STANDARD TABLE OF zcs01_rates_05.

    lt_rates = VALUE #(

      " Euro -> US Dollar
      ( from_curr  = 'EUR'
        to_curr    = 'USD'
        valid_from = '20260101'
        rate       = '1.08000' )

      " US Dollar -> Euro
      ( from_curr  = 'USD'
        to_curr    = 'EUR'
        valid_from = '20260101'
        rate       = '0.92593' )

      " Euro -> Swiss Franc
      ( from_curr  = 'EUR'
        to_curr    = 'CHF'
        valid_from = '20260101'
        rate       = '0.95000' )

      " Swiss Franc -> Euro
      ( from_curr  = 'CHF'
        to_curr    = 'EUR'
        valid_from = '20260101'
        rate       = '1.05263' )

      " Euro -> British Pound
      ( from_curr  = 'EUR'
        to_curr    = 'GBP'
        valid_from = '20260101'
        rate       = '0.86000' )

      " British Pound -> Euro
      ( from_curr  = 'GBP'
        to_curr    = 'EUR'
        valid_from = '20260101'
        rate       = '1.16279' )

    ).

    DELETE FROM zcs01_rates_05.

    INSERT zcs01_rates_05
      FROM TABLE @lt_rates.

    out->write(
      |Inserted { lines( lt_rates ) } exchange rates.|
    ).

  ENDMETHOD.

ENDCLASS.
