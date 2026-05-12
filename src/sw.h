#pragma once
#include "status_words.h"

/**
 * Status word for dynamic token TLV parsing/validation failed.
 */
#define SW_INVALID_DYNAMIC_TOKEN 0xB009
/**
 * Status word for swap failure
 */
#define SW_SWAP_FAIL 0xC000

#define SW_INVALID_DATA 0x6A80
#define SW_EXECUTION_ERROR 0x6F00
#define SW_INVALID_TAG 0x6F01
#define SW_UNSUPPORTED_VERSION 0x6F02
#define SW_UNSUPPORTED_CIPHER_SUITE 0x6F03

/**
 * Application specific swap error code context
 */
typedef enum swap_error_application_specific_code_t {
    SWAP_ERROR_CODE = 0x00,
    SWAP_ERROR_WRONG_TOKEN_INFO = 0x01,
} swap_error_application_specific_code_t;
