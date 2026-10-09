INTERFACE zif_statistics05
  PUBLIC.

  METHODS averageSales
    IMPORTING
      iv_customerid TYPE zcustomeridt1
    RETURNING
      VALUE(rv_average_sales) TYPE decfloat34.

  METHODS maxSales
    IMPORTING
      iv_customerid TYPE zcustomeridt1
    RETURNING
      VALUE(rv_max_sales) TYPE decfloat34.

  METHODS daySales
    IMPORTING
      iv_customerid TYPE zcustomeridt1
    RETURNING
      VALUE(rv_day_sales) TYPE decfloat34.

ENDINTERFACE.

