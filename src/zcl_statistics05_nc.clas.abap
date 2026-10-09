CLASS zcl_statistics05_nc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_statistics05 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_statistics05_nc IMPLEMENTATION.


 METHOD zif_statistics05~averagesales.

  SELECT SINGLE value
    FROM zcs01_settigs_05
    WHERE key_code = 'FINANCIALYEAR'
      AND active   = @abap_true
    INTO @DATA(lv_year).

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  DATA(lv_date_from) = CONV d( |{ lv_year }0101| ).
  DATA(lv_date_to)   = CONV d( |{ lv_year }1231| ).

  SELECT SUM( order_total ),
         COUNT( * )
    FROM zcs01_custord_05
    WHERE customerid = @iv_customerid
      AND order_date >= @lv_date_from
      AND order_date <= @lv_date_to
      AND status NOT IN ( 'SA', 'SB', 'SN', 'SO' )
    INTO (@DATA(lv_total_sales), @DATA(lv_order_count)).

  IF lv_order_count > 0.
    rv_average_sales =
      CONV decfloat34( lv_total_sales )
      / CONV decfloat34( lv_order_count ).
  ELSE.
    rv_average_sales = 0.
  ENDIF.

ENDMETHOD.


  METHOD zif_statistics05~daysales.

  SELECT SINGLE value
    FROM zcs01_settigs_05
    WHERE key_code = 'FINANCIALYEAR'
      AND active   = @abap_true
    INTO @DATA(lv_year).

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  DATA(lv_date_from) = CONV d( |{ lv_year }0101| ).
  DATA(lv_date_to)   = CONV d( |{ lv_year }1231| ).

  SELECT SUM( order_total )
    FROM zcs01_custord_05
    WHERE customerid = @iv_customerid
      AND order_date >= @lv_date_from
      AND order_date <= @lv_date_to
      AND status NOT IN ( 'SA', 'SB', 'SN', 'SO' )
    INTO @DATA(lv_total_sales).

  DATA(lv_days) = lv_date_to - lv_date_from + 1.

  IF lv_days > 0.
    rv_day_sales =
      CONV decfloat34( lv_total_sales )
      / CONV decfloat34( lv_days ).
  ELSE.
    rv_day_sales = 0.
  ENDIF.

ENDMETHOD.


  METHOD zif_statistics05~maxsales.

  SELECT SINGLE value
    FROM zcs01_settigs_05
    WHERE key_code = 'FINANCIALYEAR'
      AND active   = @abap_true
    INTO @DATA(lv_year).

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  DATA(lv_date_from) = CONV d( |{ lv_year }0101| ).
  DATA(lv_date_to)   = CONV d( |{ lv_year }1231| ).

  SELECT MAX( order_total )
    FROM zcs01_custord_05
    WHERE customerid = @iv_customerid
      AND order_date >= @lv_date_from
      AND order_date <= @lv_date_to
      AND status NOT IN ( 'SA', 'SB', 'SN', 'SO' )
    INTO @DATA(lv_max_sales).

  IF lv_max_sales IS NOT INITIAL.
    rv_max_sales = CONV decfloat34( lv_max_sales ).
  ELSE.
    rv_max_sales = 0.
  ENDIF.

ENDMETHOD.
ENDCLASS.
