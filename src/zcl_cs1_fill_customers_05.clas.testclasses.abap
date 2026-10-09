CLASS ltc_email_validator_05 DEFINITION
  FINAL
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT.

  PRIVATE SECTION.

    METHODS:
      test_valid_email_1    FOR TESTING,
      test_valid_email_2    FOR TESTING,
      test_invalid_no_at    FOR TESTING,
      test_invalid_no_tld   FOR TESTING,
      test_invalid_empty    FOR TESTING,
      test_invalid_too_long FOR TESTING.

ENDCLASS.


CLASS ltc_email_validator_05 IMPLEMENTATION.

  METHOD test_valid_email_1.

    DATA lv_email TYPE string.
    DATA lv_result TYPE abap_bool.

    lv_email = 'test@example.com'.

    lv_result =
      zcl_cs1_email_validator_05=>is_valid(
        iv_email = lv_email
      ).

    cl_abap_unit_assert=>assert_true(
      act = lv_result
      msg = 'Valid email was rejected'
    ).

  ENDMETHOD.


  METHOD test_valid_email_2.

    DATA lv_email TYPE string.
    DATA lv_result TYPE abap_bool.

    lv_email = 'john.doe@test-company.de'.

    lv_result =
      zcl_cs1_email_validator_05=>is_valid(
        iv_email = lv_email
      ).

    cl_abap_unit_assert=>assert_true(
      act = lv_result
      msg = 'Valid email was rejected'
    ).

  ENDMETHOD.


  METHOD test_invalid_no_at.

    DATA lv_email TYPE string.
    DATA lv_result TYPE abap_bool.

    lv_email = 'testexample.com'.

    lv_result =
      zcl_cs1_email_validator_05=>is_valid(
        iv_email = lv_email
      ).

    cl_abap_unit_assert=>assert_false(
      act = lv_result
      msg = 'Email without @ was accepted'
    ).

  ENDMETHOD.


  METHOD test_invalid_no_tld.

    DATA lv_email TYPE string.
    DATA lv_result TYPE abap_bool.

    lv_email = 'test@example'.

    lv_result =
      zcl_cs1_email_validator_05=>is_valid(
        iv_email = lv_email
      ).

    cl_abap_unit_assert=>assert_false(
      act = lv_result
      msg = 'Email without TLD was accepted'
    ).

  ENDMETHOD.


  METHOD test_invalid_empty.

    DATA lv_email TYPE string.
    DATA lv_result TYPE abap_bool.

    lv_email = ''.

    lv_result =
      zcl_cs1_email_validator_05=>is_valid(
        iv_email = lv_email
      ).

    cl_abap_unit_assert=>assert_false(
      act = lv_result
      msg = 'Empty email was accepted'
    ).

  ENDMETHOD.


  METHOD test_invalid_too_long.

    DATA lv_email TYPE string.
    DATA lv_result TYPE abap_bool.

    lv_email =
      'veryveryveryveryveryveryveryveryveryveryverylongname@example.com'.

    lv_result =
      zcl_cs1_email_validator_05=>is_valid(
        iv_email = lv_email
      ).

    cl_abap_unit_assert=>assert_false(
      act = lv_result
      msg = 'Email longer than 60 characters was accepted'
    ).

  ENDMETHOD.

ENDCLASS.
