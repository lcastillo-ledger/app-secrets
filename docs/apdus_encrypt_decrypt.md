# APDU Specification: Encrypt and Decrypt

This document specifies the APDU commands needed to encrypt/decrypt relatively small files using the encrypted file container defined in `docs/encrypted_file_format.md`.

The application interface can be accessed over HID or BLE.

## APDUs List

| Description | Instruction |
| --- | --- |
| Encrypt file content | `0x10` |
| Decrypt file content | `0x11` |

## Common Coding

| Field | Value |
| --- | --- |
| `CLA` | `0xE0` |
| `P1 = 0x00` | First data block |
| `P1 = 0x80` | Subsequent data block |
| `P2 = 0x00` | More data blocks follow |
| `P2 = 0x80` | Last data block |

For each flow, the host streams input bytes in one or more APDUs. For non-final chunks, the response data length MUST match the transformed input chunk length.

Before starting encryption or decryption, the device MUST ask for user consent and abort if the user rejects. For decryption, metadata signature verification happens before the consent prompt so unauthenticated metadata is never displayed as trusted content.

## ENCRYPT FILE CONTENT

### Description

This command encrypts a plaintext stream using the metadata and cryptography defined in `docs/encrypted_file_format.md`.

The device derives the AES key through the SDK BIP32 API from the encryption path, runs AES-128-CTR with the SDK AES implementation, computes `SHA-256(plaintext)` while streaming, and signs the metadata header with the SDK ECDSA implementation only after the claimed hash has been verified.

### Coding

_Command_

| CLA | INS | P1 | P2 | Lc | Le |
| --- | --- | --- | --- | --- | --- |
| `E0` | `10` | `00`: first block<br>`80`: subsequent block | `00`: more blocks<br>`80`: last block | variable | variable |

_Input data, first block_

| Description | Length |
| --- | --- |
| Metadata TLV length | 2, big-endian |
| Metadata TLVs without `DER_SIGNATURE` | variable |
| Plaintext chunk | variable |

`Metadata TLV length` is the byte length of the following DER-encoded metadata TLVs, excluding the magic word and excluding the final `DER_SIGNATURE` TLV that the device appends after successful encryption. The first block metadata TLVs MUST include all required non-signature metadata fields from the file format specification:

| Field | Tag |
| --- | --- |
| `STRUCTURE_TYPE` | `0x01` |
| `VERSION` | `0x02` |
| `TRUSTED_NAME` | `0x20` |
| `TIME` | `0x26` |
| `CONTENT_HASH` | `0x0100` |
| `CIPHER_SUITE` | `0x0101` |
| `MIME_TYPE` | `0x0102` |

The metadata TLVs are encoded with DER tag and DER length fields. The device MUST reject malformed TLVs, missing required TLVs, unsupported `VERSION`, unsupported `CIPHER_SUITE`, or unexpected `STRUCTURE_TYPE`.

_Input data, subsequent block_

| Description | Length |
| --- | --- |
| Plaintext chunk | variable |

_Output data, non-final block_

| Description | Length |
| --- | --- |
| Ciphertext chunk | same as plaintext chunk |

_Output data, final block_

| Description | Length |
| --- | --- |
| Ciphertext chunk | same as plaintext chunk |
| Metadata header length | 2, big-endian |
| Metadata header bytes | variable |

The returned metadata header is:

```text
Magic || metadata TLVs || DER_SIGNATURE TLV
```

The `DER_SIGNATURE` signature covers `Magic` and all metadata TLVs except the entire `DER_SIGNATURE` TLV. If the computed plaintext hash does not match the `CONTENT_HASH` TLV, the device MUST return an error status word instead of returning a valid metadata header. Host software MUST discard all ciphertext produced by that session.

## DECRYPT FILE CONTENT

### Description

This command decrypts a ciphertext stream using a metadata header produced by `ENCRYPT FILE CONTENT`.

The device parses DER TLVs, verifies the metadata signature before user consent, derives the AES key through the SDK BIP32 API from the encryption path, runs AES-128-CTR with the SDK AES implementation, and checks `SHA-256(plaintext)` at the end of the stream.

### Coding

_Command_

| CLA | INS | P1 | P2 | Lc | Le |
| --- | --- | --- | --- | --- | --- |
| `E0` | `11` | `00`: first block<br>`80`: subsequent block | `00`: more blocks<br>`80`: last block | variable | variable |

_Input data, first block_

| Description | Length |
| --- | --- |
| Metadata header length | 2, big-endian |
| Metadata header bytes | variable |
| Ciphertext chunk | variable |

The metadata header bytes contain `Magic || metadata TLVs || DER_SIGNATURE TLV`. The device MUST validate:

1. The magic word is `LDG_ENCR`.
2. TLV tags and lengths are DER encoded.
3. Required metadata TLVs are present and valid.
4. `DER_SIGNATURE` is the final metadata TLV.
5. The signature verifies over the magic word and all metadata TLVs except the entire `DER_SIGNATURE` TLV.

If signature verification fails, the device MUST abort without a consent prompt.

_Input data, subsequent block_

| Description | Length |
| --- | --- |
| Ciphertext chunk | variable |

_Output data, non-final block_

| Description | Length |
| --- | --- |
| Plaintext chunk | same as ciphertext chunk |

_Output data, final block_

| Description | Length |
| --- | --- |
| Plaintext chunk | same as ciphertext chunk |

When the device finishes decrypting, it compares `SHA-256(plaintext)` to the `CONTENT_HASH` metadata TLV. If they differ, the device MUST return an error status word and host software MUST treat plaintext from this session as invalid.

## Status Words

The exact values are application-defined. The following symbolic errors SHOULD be mapped by the implementation:

| Name | Description |
| --- | --- |
| `SW_USER_REJECTED` | User declined consent. |
| `SW_INVALID_SIGNATURE` | Metadata signature verification failed. |
| `SW_HASH_MISMATCH` | Claimed hash during encryption or decrypted hash during decryption did not match. |
| `SW_INVALID_METADATA` | Malformed metadata header, malformed DER TLV, missing required tag, or invalid tag order. |
| `SW_UNSUPPORTED_VERSION` | Metadata version is not recognized. |
| `SW_UNSUPPORTED_CIPHER_SUITE` | Cipher suite is not supported. |
