CLASS zcl_cs1_email_validator_05 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    CONSTANTS cv_max_length
      TYPE i
      VALUE 60.

    CLASS-METHODS is_valid
      IMPORTING
        iv_email TYPE string
      RETURNING
        VALUE(rv_is_valid) TYPE abap_bool.

    CLASS-METHODS validate
      IMPORTING
        iv_email    TYPE string
      EXPORTING
        ev_is_valid TYPE abap_bool
        ev_reason   TYPE string.

    CLASS-METHODS normalize
      IMPORTING
        iv_email TYPE string
      RETURNING
        VALUE(rv_email) TYPE string.

ENDCLASS.


CLASS zcl_cs1_email_validator_05 IMPLEMENTATION.

  METHOD normalize.

    " Remove quotation marks and unnecessary spaces.

    rv_email = iv_email.

    REPLACE ALL OCCURRENCES OF `"`
      IN rv_email
      WITH ``.

    rv_email =
      to_lower(
        condense(
          val = rv_email
        )
      ).

  ENDMETHOD.


  METHOD is_valid.

    " Call the central validation method.

    validate(
      EXPORTING
        iv_email    = iv_email
      IMPORTING
        ev_is_valid = rv_is_valid
    ).

  ENDMETHOD.


  METHOD validate.

    " Validate one email address.

    CLEAR:
      ev_is_valid,
      ev_reason.

    DATA(lv_email) =
      normalize(
        iv_email = iv_email
      ).


    " Empty email addresses are invalid.

    IF lv_email IS INITIAL.

      ev_is_valid =
        abap_false.

      ev_reason =
        'E-Mail ist leer'.

      RETURN.

    ENDIF.


    " Email must fit into the target EMAIL field.

    IF strlen( lv_email ) > cv_max_length.

      ev_is_valid =
        abap_false.

      ev_reason =
        |E-Mail laenger als { cv_max_length } Zeichen: { lv_email }|.

      RETURN.

    ENDIF.


    " Validate the basic email syntax using PCRE.
    " Local part allows letters, numbers and common special characters.
    " Domain requires at least one dot and a TLD of at least two letters.

    DATA(lv_pcre) =
        '^[A-Za-z0-9!#$%&''*+/=?^_`{|}~-]+'
      && '(\.[A-Za-z0-9!#$%&''*+/=?^_`{|}~-]+)*'
      && '@([A-Za-z0-9]([A-Za-z0-9-]*[A-Za-z0-9])?\.)+'
      && '[A-Za-z]{2,}$'.


    IF NOT matches(
             val  = lv_email
             pcre = lv_pcre
           ).

      ev_is_valid =
        abap_false.

      ev_reason =
        |E-Mail syntaktisch ungueltig: { lv_email }|.

      RETURN.

    ENDIF.


    " Email passed all validation checks.

    ev_is_valid =
      abap_true.

  ENDMETHOD.

ENDCLASS.
