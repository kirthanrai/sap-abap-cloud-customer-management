CLASS zcl_cs1_setup_settings_05 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_cs1_setup_settings_05 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

  DELETE FROM zcs01_settigs_05
    WHERE key_code = 'FINANCIALYEAR'.

  INSERT zcs01_settigs_05 FROM @(
    VALUE #(
      key_code = 'FINANCIALYEAR'
      value    = '2026'
      active   = abap_true
    )
  ).

  DELETE FROM zcs01_sttistk_05
    WHERE interfacename = 'ZIF_STATISTICS05'
      AND classname     = 'ZCL_STATISTICS05'.

  INSERT zcs01_sttistk_05 FROM @(
    VALUE #(
      interfacename = 'ZIF_STATISTICS05'
      classname     = 'ZCL_STATISTICS05'
      descr         = 'Default Statistics'
      active        = abap_true
    )
  ).

  out->write( 'Settings and statistics configuration created successfully.' ).

ENDMETHOD.

ENDCLASS.
