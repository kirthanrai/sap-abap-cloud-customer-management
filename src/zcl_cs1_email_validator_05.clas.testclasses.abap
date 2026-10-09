*"* use this source file for your ABAP unit test classes
CLASS ltc_email_validator DEFINITION
  FINAL
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS:
      test_valid_email_1     FOR TESTING,
      test_valid_email_2     FOR TESTING,
      test_valid_email_3     FOR TESTING,
      test_invalid_no_at     FOR TESTING,
      test_invalid_no_domain FOR TESTING,
      test_invalid_empty     FOR TESTING.

ENDCLASS.


CLASS ltc_email_validator IMPLEMENTATION.

  METHOD test_valid_email_1.

    DATA(lv_result) =
      zcl_cs1_email_validator_05=>is_valid(
        iv_email = 'test@example.com'
      ).

    cl_abap_unit_assert=>assert_true(
      act = lv_result
      msg = 'test@example.com should be valid'
    ).

  ENDMETHOD.


  METHOD test_valid_email_2.

    DATA(lv_result) =
      zcl_cs1_email_validator_05=>is_valid(
        iv_email = 'john.doe@company.de'
      ).

    cl_abap_unit_assert=>assert_true(
      act = lv_result
      msg = 'john.doe@company.de should be valid'
    ).

  ENDMETHOD.


  METHOD test_valid_email_3.

    DATA(lv_result) =
      zcl_cs1_email_validator_05=>is_valid(
        iv_email = 'user123@test.co.uk'
      ).

    cl_abap_unit_assert=>assert_true(
      act = lv_result
      msg = 'user123@test.co.uk should be valid'
    ).

  ENDMETHOD.


  METHOD test_invalid_no_at.

    DATA(lv_result) =
      zcl_cs1_email_validator_05=>is_valid(
        iv_email = 'testexample.com'
      ).

    cl_abap_unit_assert=>assert_false(
      act = lv_result
      msg = 'Email without @ should be invalid'
    ).

  ENDMETHOD.


  METHOD test_invalid_no_domain.

    DATA(lv_result) =
      zcl_cs1_email_validator_05=>is_valid(
        iv_email = 'test@'
      ).

    cl_abap_unit_assert=>assert_false(
      act = lv_result
      msg = 'Email without domain should be invalid'
    ).

  ENDMETHOD.


  METHOD test_invalid_empty.

    DATA(lv_result) =
      zcl_cs1_email_validator_05=>is_valid(
        iv_email = ''
      ).

    cl_abap_unit_assert=>assert_false(
      act = lv_result
      msg = 'Empty email should be invalid'
    ).

  ENDMETHOD.

ENDCLASS.
