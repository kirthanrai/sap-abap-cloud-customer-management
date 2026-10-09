CLASS zcl_cs1_setup_nr_05 DEFINITION
  PUBLIC
  INHERITING FROM cl_xco_cp_adt_simple_classrun
  FINAL
  CREATE PUBLIC.

  PROTECTED SECTION.
    METHODS main REDEFINITION.

ENDCLASS.


CLASS zcl_cs1_setup_nr_05 IMPLEMENTATION.

  METHOD main.

    CONSTANTS:
      lc_nr_object TYPE c LENGTH 10 VALUE 'ZCUST05NR',
      lc_nr_range  TYPE c LENGTH 2  VALUE '01'.

    DATA lt_interval
      TYPE cl_numberrange_intervals=>nr_interval.


    lt_interval = VALUE #(
      (
        nrrangenr  = lc_nr_range
        fromnumber = '000001'
        tonumber   = '999999'
      )
    ).


    cl_numberrange_intervals=>create(
      EXPORTING
        object   = lc_nr_object
        interval = lt_interval

      IMPORTING
        error    = DATA(ls_error)
        warning  = DATA(ls_warning)
    ).


    IF ls_error IS NOT INITIAL.

      out->write(
        'Interval could not be created. It may already exist.'
      ).

    ELSEIF ls_warning IS NOT INITIAL.

      out->write(
        'Interval 01 created with a warning.'
      ).

    ELSE.

      out->write(
        'Interval 01 successfully created: 000001 - 999999'
      ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
