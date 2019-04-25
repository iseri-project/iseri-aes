CLASS zcl_aes_mode_cfb DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_aes_mode .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AES_MODE_CFB IMPLEMENTATION.


  METHOD zif_aes_mode~decrypt_raw16_table.
    DATA: converter_block      TYPE xstring,
          origin_plain_block   TYPE xstring,
          working_plain_block  TYPE xstring,
          working_cipher_block TYPE xstring,
          origin_cipher_block  TYPE xstring.

    FIELD-SYMBOLS:  <raw16>       TYPE zif_aes_mode=>ty_raw16.


    CLEAR et_data.

    working_plain_block = i_initialization_vector.

    LOOP AT it_data INTO origin_cipher_block.
      io_rijndael->encrypt_xstring(
        EXPORTING
          i_data  = working_plain_block
          i_key   = i_key
        IMPORTING
          e_data  = working_cipher_block ).

      converter_block = working_cipher_block.

      origin_plain_block = origin_cipher_block BIT-XOR converter_block.

      APPEND INITIAL LINE TO et_data ASSIGNING <raw16>.
      <raw16> = origin_plain_block.

      working_plain_block = origin_cipher_block.
    ENDLOOP.

  ENDMETHOD.                    "zif_aes_mode~decrypt_raw16_table


  METHOD zif_aes_mode~encrypt_raw16_table.
    DATA: converter_block        TYPE xstring,
          origin_plain_block     TYPE xstring,
          working_plain_block    TYPE xstring,
          working_cipher_block   TYPE xstring,
          converted_cipher_block TYPE xstring.

    FIELD-SYMBOLS:  <raw16>       TYPE zif_aes_mode=>ty_raw16.


    CLEAR et_data.

    working_plain_block = i_initialization_vector.

    LOOP AT it_data INTO origin_plain_block.
      converter_block = origin_plain_block.

      io_rijndael->encrypt_xstring(
        EXPORTING
          i_data  = working_plain_block
          i_key   = i_key
        IMPORTING
          e_data  = working_cipher_block ).

      converted_cipher_block = working_cipher_block BIT-XOR converter_block.

      APPEND INITIAL LINE TO et_data ASSIGNING <raw16>.
      <raw16> = converted_cipher_block.

      working_plain_block = converted_cipher_block.
    ENDLOOP.

  ENDMETHOD.                    "zif_aes_mode~encrypt_raw16_table
ENDCLASS.
