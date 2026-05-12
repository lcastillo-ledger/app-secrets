#pragma once

/**
 * Instruction class of the Boilerplate application.
 */
#define CLA 0xE0

/**
 * Length of APPNAME variable in the Makefile.
 */
#define APPNAME_LEN (sizeof(APPNAME) - 1)

/**
 * Maximum length of MAJOR_VERSION || MINOR_VERSION || PATCH_VERSION.
 */
#define APPVERSION_LEN 3

/**
 * Maximum length of application name.
 */
#define MAX_APPNAME_LEN 64

/**
 * Maximum transaction length (bytes).
 */
#define MAX_TRANSACTION_LEN 510

/**
 * Maximum signature length (bytes).
 */
#define MAX_DER_SIG_LEN 72

/**
 * Exponent used to convert mBOL to BOL unit (N BOL = N * 10^3 mBOL).
 */
#define EXPONENT_SMALLEST_UNIT 3

/**
 * Boilerplate SLIP-44 coin type (TEST coin - 0x8001).
 * Production apps must use their assigned SLIP-44 coin type.
 * @see https://github.com/satoshilabs/slips/blob/master/slip-0044.md
 */
#define BOILERPLATE_SLIP44_COIN_TYPE 0x8001

/**
 * Boilerplate SLIP-44 coin type with hardened bit (0x80008001).
 */
#define BOILERPLATE_SLIP44_COIN_TYPE_HARDENED (0x80000000 | BOILERPLATE_SLIP44_COIN_TYPE)

#define SECRETS_STAGE_INIT 0x00
#define SECRETS_STAGE_UPDATE 0x01
#define SECRETS_STAGE_FINAL 0x02

#define SECRETS_MAX_CHUNK 240
#define SECRETS_MAX_DECRYPT_FINAL_CHUNK 239
#define SECRETS_MAX_METADATA_HEADER 255
#define SECRETS_MAX_METADATA_TLVS_WITHOUT_NONCE 229
#define SECRETS_GCM_NONCE_LEN 12
#define SECRETS_GCM_TAG_LEN 16
#define SECRETS_AES_KEY_LEN 32

#define SECRETS_STRUCTURE_TYPE_FILE_METADATA 0x34
#define SECRETS_VERSION 0x01
#define SECRETS_CIPHER_SUITE_AES_256_GCM_HKDF_SHA256 0x01

#define SECRETS_TAG_STRUCTURE_TYPE 0x01
#define SECRETS_TAG_VERSION 0x02
#define SECRETS_TAG_TRUSTED_NAME 0x20
#define SECRETS_TAG_TIME 0x26
#define SECRETS_TAG_CIPHER_SUITE 0x0101
#define SECRETS_TAG_MIME_TYPE 0x0102
#define SECRETS_TAG_NONCE 0x0103
