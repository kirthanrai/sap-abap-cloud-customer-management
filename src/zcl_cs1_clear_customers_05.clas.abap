CLASS zcl_cs1_clear_customers_05 DEFINITION
  PUBLIC
  INHERITING FROM cl_xco_cp_adt_simple_classrun
  FINAL
  CREATE PUBLIC.

  PROTECTED SECTION.
    METHODS main REDEFINITION.

ENDCLASS.


CLASS zcl_cs1_clear_customers_05 IMPLEMENTATION.

  METHOD main.

    DELETE FROM zcs01_custmrs_05.

    out->write(
      |All records deleted from ZCS01_CUSTMRS_05|
    ).

  ENDMETHOD.

ENDCLASS.
