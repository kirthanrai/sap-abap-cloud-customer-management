CLASS zcl_cs1_badi_test_05 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_cs1_badi_test_05 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA lv_field TYPE string.

    out->write( 'BAdI Erweiterung' ).

    " Step 1: reference to the BAdI definition
    DATA lo_exit TYPE REF TO zbadi_cs1_api_05.

    " PAR1 = all relevant/new IDs
    DATA lt_par1 TYPE zif_cs1_import_exit_05=>tt_string.

    " PAR2 = problematic IDs
    DATA lt_par2 TYPE zif_cs1_import_exit_05=>tt_string.

    " PAR3 = problematic ID + problematic source row
    DATA lt_par3 TYPE zif_cs1_import_exit_05=>tt_string.


    APPEND '112233' TO lt_par1.
    APPEND '223344' TO lt_par1.
    APPEND '223346' TO lt_par1.
    APPEND '223347' TO lt_par1.
    APPEND '223348' TO lt_par1.


    APPEND '112233' TO lt_par2.
    APPEND '223344' TO lt_par2.


    APPEND
      '112233 -> "Test-5 ffffffffffffffffffffffffaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa Team-1";"Hammer Str. 62";"22043";"Hamburg";"";"040";"6526613"'
      TO lt_par3.

    APPEND
      '223344 -> "Adomeit Herbert";"Borner Stieg 43";"22417";"Hamburg";"";"040";"5202829"'
      TO lt_par3.


    " Step 2: get active BAdI implementation(s)
    TRY.

        GET BADI lo_exit.

      CATCH cx_root INTO DATA(lx_root).

        out->write(
          |GET BADI failed: { lx_root->get_text( ) }|
        ).

        RETURN.

    ENDTRY.


    " Step 3: call the BAdI
    TRY.

        CALL BADI lo_exit->import_exit
          EXPORTING
            it_par1 = lt_par1
            it_par2 = lt_par2
            it_par3 = lt_par3.

      CATCH cx_root INTO lx_root.

        out->write(
          |CALL BADI failed: { lx_root->get_text( ) }|
        ).

        RETURN.

    ENDTRY.


    out->write( 'BAdI call completed successfully' ).

  ENDMETHOD.

ENDCLASS.
