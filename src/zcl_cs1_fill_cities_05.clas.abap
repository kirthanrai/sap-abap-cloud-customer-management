CLASS zcl_cs1_fill_cities_05 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_cs1_fill_cities_05 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA lt_cities TYPE STANDARD TABLE OF zcs01_cities_05.

    lt_cities = VALUE #(
      ( postcode = '11111' city = 'München' )
      ( postcode = '22222' city = 'Berlin' )
      ( postcode = '33333' city = 'Hamburg' )
      ( postcode = '44444' city = 'Köln' )
      ( postcode = '55555' city = 'Frankfurt' )
    ).

    DELETE FROM zcs01_cities_05.

    INSERT zcs01_cities_05
      FROM TABLE @lt_cities.

    out->write(
      |Inserted { lines( lt_cities ) } cities.|
    ).

  ENDMETHOD.

ENDCLASS.
