CLASS zcl_cs1_fill_customers_05 DEFINITION
  PUBLIC
  INHERITING FROM cl_xco_cp_adt_simple_classrun
  FINAL
  CREATE PUBLIC.



  PUBLIC SECTION.

*Reuabale import method

    METHODS run_import
      RETURNING VALUE(rv_count) TYPE i.



  PROTECTED SECTION.

    METHODS main REDEFINITION.



  PRIVATE SECTION.

    CONSTANTS:
      cv_nr_object TYPE c LENGTH 10 VALUE 'ZCUST05NR',
      cv_nr_range  TYPE c LENGTH 2  VALUE '01'.

    CONSTANTS cv_salutation_company
      TYPE string
      VALUE 'Firma'.

    CONSTANTS:
      cv_company_pcre_1 TYPE string VALUE
        '(\bGmbH\b|\bmbH\b|\bAG\b|\bKG\b|\bOHG\b|\bGbR\b|\bUG\b|',
      cv_company_pcre_2 TYPE string VALUE
        '\be\.\s?K\.|\be\.\s?V\.|&\s?Co|\bInh\b|\bLtd\b|\bSE\b|',
      cv_company_pcre_3 TYPE string VALUE
        'Autohaus|Automobile|Auto-|Autoh|Motors|Vermietung|Handel|',
      cv_company_pcre_4 TYPE string VALUE
        'Hdl\.|Service|Center|Zentrum|Group|Company|Werkstatt|Betrieb)'.

    TYPES:
      BEGIN OF ty_source,
        salutation TYPE string,
        last_name  TYPE string,
        first_name TYPE string,
        company    TYPE string,
        street     TYPE string,
        postcode   TYPE string,
        city       TYPE string,
        medium     TYPE string,
        value1     TYPE string,
        value2     TYPE string,
      END OF ty_source,

      tt_source TYPE STANDARD TABLE OF ty_source
        WITH EMPTY KEY,

      BEGIN OF ty_customer,
        salutation          TYPE string,
        last_name           TYPE string,
        first_name          TYPE string,
        company             TYPE string,
        street              TYPE string,
        city                TYPE string,
        postcode            TYPE string,

        original_salutation TYPE string,
        original_last_name  TYPE string,
        original_first_name TYPE string,
        original_company    TYPE string,
        original_street     TYPE string,
        original_city       TYPE string,
        original_postcode   TYPE string,

        phone               TYPE string,
        fax                 TYPE string,
        email               TYPE string,
        memo                TYPE string,
      END OF ty_customer,

      tt_customer TYPE SORTED TABLE OF ty_customer
        WITH UNIQUE KEY
          last_name
          first_name
          company
          street
          city
          postcode.

    DATA:
      mv_next_number TYPE i,
      mv_last_number TYPE i.

    DATA mt_invalid_ids
      TYPE zif_cs1_import_exit_05=>tt_string.

    DATA mt_badi_par1
      TYPE zif_cs1_import_exit_05=>tt_string.

    DATA mt_badi_par2
      TYPE zif_cs1_import_exit_05=>tt_string.

    DATA mt_badi_par3
      TYPE zif_cs1_import_exit_05=>tt_string.

    METHODS strip
      IMPORTING
        iv_value        TYPE clike
      RETURNING
        VALUE(rv_value) TYPE string.

    METHODS cut
      IMPORTING
        iv_value        TYPE string
        iv_length       TYPE i
      RETURNING
        VALUE(rv_value) TYPE string.

    METHODS split_name
      IMPORTING
        iv_raw_name   TYPE string
      EXPORTING
        ev_salutation TYPE string
        ev_company    TYPE string
        ev_last_name  TYPE string
        ev_first_name TYPE string.

    METHODS reserve_numbers
      IMPORTING
        iv_quantity TYPE i
      RAISING
        cx_number_ranges.

    METHODS get_next_customerid
      RETURNING
        VALUE(rv_customerid) TYPE zcustomeridt1
      RAISING
        cx_number_ranges.

    METHODS write_out
      IMPORTING
        iv_msg TYPE string.

    METHODS check_length
      IMPORTING
        iv_field      TYPE string
        iv_value      TYPE string
        iv_length     TYPE i
        iv_customerid TYPE zcustomeridt1 OPTIONAL
      RAISING
        zcx_cs1_import_05.

    METHODS fit
      IMPORTING
        iv_field        TYPE string
        iv_value        TYPE string
        iv_length       TYPE i
        iv_customerid   TYPE zcustomeridt1
        iv_run_id       TYPE sysuuid_x16
      RETURNING
        VALUE(rv_value) TYPE string.

    METHODS write_log
      IMPORTING
        iv_run_id     TYPE sysuuid_x16
        iv_customerid TYPE zcustomeridt1
        iv_field      TYPE string
        iv_value      TYPE string
        iv_message    TYPE string
        iv_severity   TYPE c.

    METHODS call_badi.

ENDCLASS.


CLASS zcl_cs1_fill_customers_05 IMPLEMENTATION.

  METHOD main.

    DATA(lv_count) = run_import( ).

    write_out(
      iv_msg = |New customers inserted: { lv_count }|
    ).

  ENDMETHOD.



  METHOD run_import.

*Reusable import method implementation

    CLEAR:
      mt_invalid_ids,
      mt_badi_par1,
      mt_badi_par2,
      mt_badi_par3.

    DATA lv_run_id TYPE sysuuid_x16.

    TRY.

        lv_run_id =
          cl_system_uuid=>create_uuid_x16_static( ).

      CATCH cx_uuid_error INTO DATA(lx_uuid).

        write_out(
          iv_msg =
            |Could not create import RUN_ID: { lx_uuid->get_text( ) }|
        ).

        RETURN.

    ENDTRY.


    SELECT FROM ztl_00_casestudy AS source
      FIELDS source~import AS raw_line
      INTO TABLE @DATA(lt_raw).

    IF lt_raw IS INITIAL.

      write_out(
        iv_msg = 'No source data found.'
      ).

      RETURN.

    ENDIF.


    DATA lt_source    TYPE tt_source.
    DATA lt_customers TYPE tt_customer.


    LOOP AT lt_raw INTO DATA(ls_raw).

      IF ls_raw-raw_line IS INITIAL.
        CONTINUE.
      ENDIF.


      SPLIT ls_raw-raw_line
        AT ';'
        INTO TABLE DATA(lt_parts).


      IF lines( lt_parts ) < 7.
        CONTINUE.
      ENDIF.


      DATA(lv_name) =
        strip( lt_parts[ 1 ] ).

      DATA(lv_street) =
        strip( lt_parts[ 2 ] ).

      DATA(lv_postcode) =
        strip( lt_parts[ 3 ] ).

      DATA(lv_city) =
        strip( lt_parts[ 4 ] ).

      DATA(lv_medium) =
        strip( lt_parts[ 5 ] ).

      DATA(lv_value1) =
        strip( lt_parts[ 6 ] ).

      DATA(lv_value2) =
        strip( lt_parts[ 7 ] ).


      IF lv_name = 'Firma'
         AND lv_street = 'Strasse'.

        CONTINUE.

      ENDIF.


      IF lv_name IS INITIAL.
        CONTINUE.
      ENDIF.


      DATA:
        lv_salutation TYPE string,
        lv_company    TYPE string,
        lv_last_name  TYPE string,
        lv_first_name TYPE string.


      split_name(
        EXPORTING
          iv_raw_name   = lv_name
        IMPORTING
          ev_salutation = lv_salutation
          ev_company    = lv_company
          ev_last_name  = lv_last_name
          ev_first_name = lv_first_name
      ).


      DATA(lv_last_name_cut) =
        cut(
          iv_value  = lv_last_name
          iv_length = 25
        ).

      DATA(lv_first_name_cut) =
        cut(
          iv_value  = lv_first_name
          iv_length = 20
        ).

      DATA(lv_company_cut) =
        cut(
          iv_value  = lv_company
          iv_length = 60
        ).

      DATA(lv_street_cut) =
        cut(
          iv_value  = lv_street
          iv_length = 50
        ).

      DATA(lv_city_cut) =
        cut(
          iv_value  = lv_city
          iv_length = 30
        ).

      DATA(lv_postcode_cut) =
        cut(
          iv_value  = lv_postcode
          iv_length = 8
        ).


      APPEND VALUE ty_source(
        salutation = lv_salutation
        last_name  = lv_last_name_cut
        first_name = lv_first_name_cut
        company    = lv_company_cut
        street     = lv_street_cut
        postcode   = lv_postcode_cut
        city       = lv_city_cut
        medium     = lv_medium
        value1     = lv_value1
        value2     = lv_value2
      ) TO lt_source.


      DATA(ls_customer) =
        VALUE ty_customer(

          salutation =
            lv_salutation

          last_name =
            lv_last_name_cut

          first_name =
            lv_first_name_cut

          company =
            lv_company_cut

          street =
            lv_street_cut

          postcode =
            lv_postcode_cut

          city =
            lv_city_cut

          original_salutation =
            lv_salutation

          original_last_name =
            lv_last_name

          original_first_name =
            lv_first_name

          original_company =
            lv_company

          original_street =
            lv_street

          original_postcode =
            lv_postcode

          original_city =
            lv_city
        ).


      INSERT ls_customer
        INTO TABLE lt_customers.

    ENDLOOP.


    LOOP AT lt_customers
      ASSIGNING FIELD-SYMBOL(<ls_customer>).


      LOOP AT lt_source INTO DATA(ls_source)

        WHERE last_name  = <ls_customer>-last_name
          AND first_name = <ls_customer>-first_name
          AND company    = <ls_customer>-company
          AND street     = <ls_customer>-street
          AND postcode   = <ls_customer>-postcode
          AND city       = <ls_customer>-city.


        DATA(lv_medium_upper) =
          to_upper( ls_source-medium ).


        CASE lv_medium_upper.


          WHEN 'EMAIL'.

            IF ls_source-value1 IS INITIAL.
              CONTINUE.
            ENDIF.


            DATA(lv_email) =
              to_lower( ls_source-value1 ).


            IF zcl_cs1_email_validator_05=>is_valid(
                 iv_email = lv_email
               ) = abap_false.


              IF <ls_customer>-memo IS INITIAL.

                <ls_customer>-memo =
                  |Invalid Email: { lv_email }|.

              ELSE.

                <ls_customer>-memo =
                  |{ <ls_customer>-memo }, Invalid Email: { lv_email }|.

              ENDIF.


              CONTINUE.

            ENDIF.


            IF <ls_customer>-email IS INITIAL.

              <ls_customer>-email =
                lv_email.

            ELSEIF <ls_customer>-email <> lv_email.


              IF <ls_customer>-memo IS INITIAL.

                <ls_customer>-memo =
                  |Additional Email: { lv_email }|.

              ELSE.

                <ls_customer>-memo =
                  |{ <ls_customer>-memo }, Additional Email: { lv_email }|.

              ENDIF.


            ENDIF.


          WHEN 'TELEFAX' OR 'FAX'.

            IF ls_source-value1 IS INITIAL
               AND ls_source-value2 IS INITIAL.

              CONTINUE.

            ENDIF.


            DATA(lv_fax) =
              |{ ls_source-value1 }/{ ls_source-value2 }|.


            IF <ls_customer>-fax IS INITIAL.

              <ls_customer>-fax =
                lv_fax.

            ELSEIF <ls_customer>-fax <> lv_fax.


              IF <ls_customer>-memo IS INITIAL.

                <ls_customer>-memo =
                  |Additional Fax: { lv_fax }|.

              ELSE.

                <ls_customer>-memo =
                  |{ <ls_customer>-memo }, Additional Fax: { lv_fax }|.

              ENDIF.


            ENDIF.


          WHEN OTHERS.

            IF ls_source-value1 IS INITIAL
               AND ls_source-value2 IS INITIAL.

              CONTINUE.

            ENDIF.


            DATA(lv_phone) =
              |{ ls_source-value1 }/{ ls_source-value2 }|.


            IF <ls_customer>-phone IS INITIAL.

              <ls_customer>-phone =
                lv_phone.

            ELSEIF <ls_customer>-phone <> lv_phone.


              IF <ls_customer>-memo IS INITIAL.

                <ls_customer>-memo =
                  |Additional Tel: { lv_phone }|.

              ELSE.

                <ls_customer>-memo =
                  |{ <ls_customer>-memo }, Additional Tel: { lv_phone }|.

              ENDIF.


            ENDIF.


        ENDCASE.

      ENDLOOP.

    ENDLOOP.


    SELECT
      last_name,
      first_name,
      company,
      street,
      city,
      postcode

      FROM zcs01_custmrs_05

      INTO TABLE @DATA(lt_existing).


    DATA lt_new TYPE tt_customer.


    LOOP AT lt_customers
      INTO DATA(ls_candidate).


      DATA(lv_exists) =
        abap_false.


      LOOP AT lt_existing
        INTO DATA(ls_existing)

        WHERE last_name  = ls_candidate-last_name
          AND first_name = ls_candidate-first_name
          AND company    = ls_candidate-company
          AND street     = ls_candidate-street
          AND city       = ls_candidate-city
          AND postcode   = ls_candidate-postcode.


        lv_exists =
          abap_true.


        EXIT.


      ENDLOOP.


      IF lv_exists = abap_true.
        CONTINUE.
      ENDIF.


      INSERT ls_candidate
        INTO TABLE lt_new.

    ENDLOOP.


    IF lt_new IS INITIAL.

      write_out(
        iv_msg = 'No new addresses found.'
      ).

      RETURN.

    ENDIF.


    TRY.


        reserve_numbers(
          iv_quantity = lines( lt_new )
        ).


        DATA lt_target
          TYPE STANDARD TABLE OF zcs01_custmrs_05.


        LOOP AT lt_new
          INTO DATA(ls_new).


          DATA(lv_customerid) =
            get_next_customerid( ).


          " PAR1 contains every newly assigned customer ID.

          APPEND
            CONV string( lv_customerid )
            TO mt_badi_par1.


          DATA(ls_target) =
            VALUE zcs01_custmrs_05(

              customerid =
                lv_customerid

              salutation =
                fit(
                  iv_field      = 'SALUTATION'
                  iv_value      = ls_new-original_salutation
                  iv_length     = 15
                  iv_customerid = lv_customerid
                  iv_run_id     = lv_run_id
                )

              last_name =
                fit(
                  iv_field      = 'LAST_NAME'
                  iv_value      = ls_new-original_last_name
                  iv_length     = 25
                  iv_customerid = lv_customerid
                  iv_run_id     = lv_run_id
                )

              first_name =
                fit(
                  iv_field      = 'FIRST_NAME'
                  iv_value      = ls_new-original_first_name
                  iv_length     = 20
                  iv_customerid = lv_customerid
                  iv_run_id     = lv_run_id
                )

              company =
                fit(
                  iv_field      = 'COMPANY'
                  iv_value      = ls_new-original_company
                  iv_length     = 60
                  iv_customerid = lv_customerid
                  iv_run_id     = lv_run_id
                )

              street =
                fit(
                  iv_field      = 'STREET'
                  iv_value      = ls_new-original_street
                  iv_length     = 50
                  iv_customerid = lv_customerid
                  iv_run_id     = lv_run_id
                )

              postcode =
                fit(
                  iv_field      = 'POSTCODE'
                  iv_value      = ls_new-original_postcode
                  iv_length     = 8
                  iv_customerid = lv_customerid
                  iv_run_id     = lv_run_id
                )

              city =
                fit(
                  iv_field      = 'CITY'
                  iv_value      = ls_new-original_city
                  iv_length     = 30
                  iv_customerid = lv_customerid
                  iv_run_id     = lv_run_id
                )

              phone =
                fit(
                  iv_field      = 'PHONE'
                  iv_value      = ls_new-phone
                  iv_length     = 15
                  iv_customerid = lv_customerid
                  iv_run_id     = lv_run_id
                )

              fax =
                fit(
                  iv_field      = 'FAX'
                  iv_value      = ls_new-fax
                  iv_length     = 15
                  iv_customerid = lv_customerid
                  iv_run_id     = lv_run_id
                )

              email =
                fit(
                  iv_field      = 'EMAIL'
                  iv_value      = ls_new-email
                  iv_length     = 60
                  iv_customerid = lv_customerid
                  iv_run_id     = lv_run_id
                )

              memo =
                fit(
                  iv_field      = 'MEMO'
                  iv_value      = ls_new-memo
                  iv_length     = 255
                  iv_customerid = lv_customerid
                  iv_run_id     = lv_run_id
                )

              country =
                'DE'

              currency =
                'EUR'

              currency_target =
                'EUR'

              language =
                'D'

              last_date =
                cl_abap_context_info=>get_system_date( )

            ).


          " If this customer had a transfer problem,
          " PAR3 contains ID plus the original address data.

          IF line_exists(
               mt_invalid_ids[
                 table_line = CONV string( lv_customerid )
               ]
             ).


            DATA(lv_problem_row) =
                |{ lv_customerid } -> |
              && |"{ ls_new-original_company }";|
              && |"{ ls_new-original_last_name }";|
              && |"{ ls_new-original_first_name }";|
              && |"{ ls_new-original_street }";|
              && |"{ ls_new-original_postcode }";|
              && |"{ ls_new-original_city }";|
              && |"{ ls_new-phone }";|
              && |"{ ls_new-fax }";|
              && |"{ ls_new-email }"|.


            APPEND lv_problem_row
              TO mt_badi_par3.


          ENDIF.


          APPEND ls_target
            TO lt_target.


        ENDLOOP.


        INSERT zcs01_custmrs_05
          FROM TABLE @lt_target
          ACCEPTING DUPLICATE KEYS.


        rv_count =
          lines( lt_target ).


        " Call the tutor-style BAdI interface with:
        " PAR1 = all new IDs
        " PAR2 = problematic IDs
        " PAR3 = problematic IDs plus original rows/details

        call_badi( ).


        write_out(
          iv_msg =
            |Unique addresses in source: { lines( lt_customers ) }|
        ).

        write_out(
          iv_msg =
            |New addresses: { lines( lt_new ) }|
        ).

        write_out(
          iv_msg =
            |Inserted: { rv_count }|
        ).


        SELECT COUNT( * )
          FROM zcs01_custmrs_05
          INTO @DATA(lv_total).


        write_out(
          iv_msg =
            |Total rows in ZCS01_CUSTMRS_05: { lv_total }|
        ).


      CATCH cx_number_ranges
        INTO DATA(lx_nr).


        write_out(
          iv_msg =
            |Number range error: { lx_nr->get_text( ) }|
        ).


        RETURN.


    ENDTRY.

  ENDMETHOD.


  METHOD split_name.

    CLEAR:
      ev_salutation,
      ev_company,
      ev_last_name,
      ev_first_name.


    DATA(lv_name) =
      iv_raw_name.


    REPLACE ALL OCCURRENCES OF `"`
      IN lv_name
      WITH ``.


    lv_name =
      condense(
        val = lv_name
      ).


    IF lv_name IS INITIAL.
      RETURN.
    ENDIF.


    DATA(lv_company_pcre) =
        cv_company_pcre_1
      && cv_company_pcre_2
      && cv_company_pcre_3
      && cv_company_pcre_4.


    IF find(
         val  = lv_name
         pcre = lv_company_pcre
         case = abap_false
       ) >= 0.


      ev_company =
        lv_name.


      ev_salutation =
        cv_salutation_company.


      RETURN.


    ENDIF.


    SPLIT lv_name AT ` `
      INTO TABLE DATA(lt_name_parts).


    DELETE lt_name_parts
      WHERE table_line IS INITIAL.


    CASE lines( lt_name_parts ).


      WHEN 0.

        RETURN.


      WHEN 1.

        ev_last_name =
          lt_name_parts[ 1 ].


      WHEN OTHERS.

        ev_last_name =
          lt_name_parts[ 1 ].


        LOOP AT lt_name_parts
          INTO DATA(lv_part)
          FROM 2.


          IF ev_first_name IS INITIAL.

            ev_first_name =
              lv_part.

          ELSE.

            ev_first_name =
              |{ ev_first_name } { lv_part }|.

          ENDIF.


        ENDLOOP.


    ENDCASE.

  ENDMETHOD.


  METHOD strip.

    rv_value =
      iv_value.


    REPLACE ALL OCCURRENCES OF `"`
      IN rv_value
      WITH ``.


    rv_value =
      condense(
        val = rv_value
      ).

  ENDMETHOD.


  METHOD cut.

    IF strlen( iv_value ) > iv_length.


      rv_value =
        substring(
          val = iv_value
          off = 0
          len = iv_length
        ).


    ELSE.


      rv_value =
        iv_value.


    ENDIF.

  ENDMETHOD.


  METHOD check_length.

    IF strlen( iv_value ) <= iv_length.
      RETURN.
    ENDIF.


    RAISE EXCEPTION TYPE zcx_cs1_import_05
      EXPORTING
        iv_field_name  = iv_field
        iv_field_value = iv_value
        iv_max_length  = iv_length.

  ENDMETHOD.


  METHOD fit.

    rv_value =
      iv_value.


    TRY.


        check_length(
          iv_field      = iv_field
          iv_value      = iv_value
          iv_length     = iv_length
          iv_customerid = iv_customerid
        ).


      CATCH zcx_cs1_import_05
  INTO DATA(lx_import).

        " PAR2 contains problematic customer IDs only once.
        IF iv_customerid IS NOT INITIAL
           AND NOT line_exists(
             mt_invalid_ids[
               table_line = CONV string( iv_customerid )
             ]
           ).

          APPEND
            CONV string( iv_customerid )
            TO mt_invalid_ids.

          APPEND
            CONV string( iv_customerid )
            TO mt_badi_par2.

        ENDIF.

        " Get error text from Message Class ZCS1_IMPORT_05
        DATA(lv_message) = lx_import->get_text( ).

        write_log(
          iv_run_id     = iv_run_id
          iv_customerid = iv_customerid
          iv_field      = lx_import->field_name
          iv_value      = lx_import->field_value
          iv_message    = lv_message
          iv_severity   = 'E'
        ).

        rv_value =
          cut(
            iv_value  = iv_value
            iv_length = iv_length
          ).

    ENDTRY.

  ENDMETHOD.


  METHOD write_log.

    DATA lv_log_id TYPE sysuuid_x16.


    TRY.


        lv_log_id =
          cl_system_uuid=>create_uuid_x16_static( ).


      CATCH cx_uuid_error INTO DATA(lx_uuid).


        write_out(
          iv_msg =
            |Could not create LOG_ID: { lx_uuid->get_text( ) }|
        ).


        RETURN.


    ENDTRY.


    DATA lv_created_at TYPE abp_creation_tstmpl.


    GET TIME STAMP FIELD lv_created_at.


    DATA(ls_log) =
      VALUE zcs01_implog_05(

        log_id =
          lv_log_id

        run_id =
          iv_run_id

        customerid =
          iv_customerid

        field_name =
          CONV #( iv_field )

        field_value =
          CONV #(
            cut(
              iv_value  = iv_value
              iv_length = 255
            )
          )

        message_text =
          CONV #(
            cut(
              iv_value  = iv_message
              iv_length = 255
            )
          )

        severity =
          iv_severity

        created_by =
          cl_abap_context_info=>get_user_technical_name( )

        created_at =
          lv_created_at

      ).


    INSERT zcs01_implog_05
      FROM @ls_log.

  ENDMETHOD.


  METHOD call_badi.

    " Step 1: declare reference to the BAdI definition.

    DATA lo_exit
      TYPE REF TO zbadi_cs1_api_05.


    " Step 2: get active BAdI implementation(s).

    TRY.


        GET BADI lo_exit.


      CATCH cx_root INTO DATA(lx_root).


        write_out(
          iv_msg =
            |GET BADI failed: { lx_root->get_text( ) }|
        ).


        RETURN.


    ENDTRY.


    " Step 3: call the customer-specific extension.

    TRY.


        CALL BADI lo_exit->import_exit
          EXPORTING
            it_par1 = mt_badi_par1
            it_par2 = mt_badi_par2
            it_par3 = mt_badi_par3.


      CATCH cx_root INTO lx_root.


        write_out(
          iv_msg =
            |CALL BADI failed: { lx_root->get_text( ) }|
        ).


        RETURN.


    ENDTRY.

  ENDMETHOD.


  METHOD reserve_numbers.

    IF iv_quantity <= 0.
      RETURN.
    ENDIF.


    cl_numberrange_runtime=>number_get(

      EXPORTING

        nr_range_nr =
          cv_nr_range

        object =
          cv_nr_object

        quantity =
          CONV #( iv_quantity )

      IMPORTING

        number =
          DATA(lv_number)

        returncode =
          DATA(lv_returncode)

        returned_quantity =
          DATA(lv_returned_quantity)

    ).


    mv_last_number =
      CONV i( lv_number ).


    mv_next_number =
        mv_last_number
      - CONV i( lv_returned_quantity )
      + 1.


    IF lv_returncode IS NOT INITIAL.


      write_out(
        iv_msg =
          |Number range return code: { lv_returncode }|
      ).


    ENDIF.

  ENDMETHOD.


  METHOD get_next_customerid.

    IF mv_next_number = 0
       OR mv_next_number > mv_last_number.


      reserve_numbers(
        iv_quantity = 1
      ).


    ENDIF.


    rv_customerid =
      |{ mv_next_number WIDTH = 6 PAD = '0' ALIGN = RIGHT }|.


    mv_next_number += 1.

  ENDMETHOD.


  METHOD write_out.

    IF out IS BOUND.


      out->write(
        iv_msg
      ).


    ENDIF.

  ENDMETHOD.

ENDCLASS.

