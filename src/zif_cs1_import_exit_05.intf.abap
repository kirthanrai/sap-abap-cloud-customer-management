INTERFACE zif_cs1_import_exit_05
  PUBLIC.

  INTERFACES if_badi_interface.

  TYPES tt_string
    TYPE STANDARD TABLE OF string
    WITH EMPTY KEY.

  METHODS import_exit
    IMPORTING
      it_par1 TYPE tt_string
      it_par2 TYPE tt_string
      it_par3 TYPE tt_string.

ENDINTERFACE.

