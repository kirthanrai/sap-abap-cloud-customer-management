CLASS zcl_cs1_import_job_05 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.

ENDCLASS.



CLASS zcl_cs1_import_job_05 IMPLEMENTATION.

  METHOD if_apj_dt_exec_object~get_parameters.

    CLEAR:
      et_parameter_def,
      et_parameter_val.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    DATA(lo_import) =
      NEW zcl_cs1_fill_customers_05( ).

    DATA(lv_count) =
      lo_import->run_import( ).

  ENDMETHOD.

ENDCLASS.

