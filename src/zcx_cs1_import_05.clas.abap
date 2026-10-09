CLASS zcx_cs1_import_05 DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_t100_message.

    CONSTANTS:
      BEGIN OF value_too_long,
        msgid TYPE symsgid VALUE 'ZCS1_IMPORT_05',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'FIELD_NAME',
        attr2 TYPE scx_attrname VALUE 'FIELD_VALUE',
        attr3 TYPE scx_attrname VALUE 'MAX_LENGTH',
        attr4 TYPE scx_attrname VALUE '',
      END OF value_too_long.

    DATA field_name  TYPE string READ-ONLY.
    DATA field_value TYPE string READ-ONLY.
    DATA max_length  TYPE i READ-ONLY.

    METHODS constructor
      IMPORTING
        iv_field_name  TYPE string
        iv_field_value TYPE string
        iv_max_length  TYPE i.

ENDCLASS.


CLASS zcx_cs1_import_05 IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor( ).

    field_name =
      iv_field_name.

    field_value =
      iv_field_value.

    max_length =
      iv_max_length.

    if_t100_message~t100key =
      value_too_long.

  ENDMETHOD.

ENDCLASS.
