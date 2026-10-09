CLASS zcl_cs1_test_rtti_05 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_cs1_test_rtti_05 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    SELECT SINGLE classname,
                  interfacename
      FROM zcs01_sttistk_05
      WHERE active = @abap_true
      INTO @DATA(ls_config).

    IF sy-subrc <> 0.
      out->write( 'No active statistics configuration found.' ).
      RETURN.
    ENDIF.

    DATA(lo_classdescr) =
      CAST cl_abap_classdescr(
        cl_abap_typedescr=>describe_by_name(
          ls_config-classname
        )
      ).

    DATA(lv_interface_found) = abap_false.

    LOOP AT lo_classdescr->interfaces INTO DATA(ls_interface).

      IF ls_interface-name = ls_config-interfacename.
        lv_interface_found = abap_true.
        EXIT.
      ENDIF.

    ENDLOOP.

    IF lv_interface_found = abap_false.
      out->write(
        |Class { ls_config-classname } does not implement interface { ls_config-interfacename }.|
      ).
      RETURN.
    ENDIF.

    DATA lo_object TYPE REF TO object.

    CREATE OBJECT lo_object
      TYPE (ls_config-classname).

    DATA(lo_statistics) =
      CAST zif_statistics05( lo_object ).

    DATA(lv_customerid) = CONV zcustomeridt1( '000001' ).

    DATA(lv_average) =
      lo_statistics->averagesales(
        iv_customerid = lv_customerid
      ).

    DATA(lv_max) =
      lo_statistics->maxsales(
        iv_customerid = lv_customerid
      ).

    DATA(lv_day) =
      lo_statistics->daysales(
        iv_customerid = lv_customerid
      ).

    out->write( |Class: { ls_config-classname }| ).
    out->write( |Interface: { ls_config-interfacename }| ).
    out->write( |Customer: { lv_customerid }| ).
    out->write( |Average Sales: { lv_average }| ).
    out->write( |Max Sales: { lv_max }| ).
    out->write( |Day Sales: { lv_day }| ).

  ENDMETHOD.

ENDCLASS.
