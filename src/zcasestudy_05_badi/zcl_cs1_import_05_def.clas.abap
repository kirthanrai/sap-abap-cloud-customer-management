CLASS zcl_cs1_import_05_def DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_badi_interface.
    INTERFACES zif_cs1_import_exit_05.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_cs1_import_05_def IMPLEMENTATION.

  METHOD zif_cs1_import_exit_05~import_exit.

    LOOP AT it_par1 ASSIGNING FIELD-SYMBOL(<fs>).

      " Customer-specific processing

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
