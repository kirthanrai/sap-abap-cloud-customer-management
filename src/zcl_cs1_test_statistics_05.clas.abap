CLASS zcl_cs1_test_statistics_05 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_cs1_test_statistics_05 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(lo_statistics) = NEW zcl_statistics05( ).

    DATA(lv_customerid) = CONV zcustomeridt1( '000001' ).

    DATA(lv_average) =
      lo_statistics->zif_statistics05~averagesales(
        iv_customerid = lv_customerid
      ).

    DATA(lv_max) =
      lo_statistics->zif_statistics05~maxsales(
        iv_customerid = lv_customerid
      ).

    DATA(lv_day) =
      lo_statistics->zif_statistics05~daysales(
        iv_customerid = lv_customerid
      ).

    out->write( |Customer: { lv_customerid }| ).
    out->write( |Average Sales: { lv_average }| ).
    out->write( |Max Sales: { lv_max }| ).
    out->write( |Day Sales: { lv_day }| ).

  ENDMETHOD.

ENDCLASS.
