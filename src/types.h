#pragma once

/**
 * Enumeration with expected INS of APDU commands.
 */
typedef enum {
    GET_VERSION = 0x03,   /// version of the application
    GET_APP_NAME = 0x04,  /// name of the application
    ENCRYPT = 0x10,       /// encrypt file content
    DECRYPT = 0x11        /// decrypt file content
} command_e;
