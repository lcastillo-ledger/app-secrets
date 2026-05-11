# APDU Specification: Encrypt and Decrypt

This document specifies the APDU commands needed to encrypt/decrypt files using the encrypted file container defined in `docs/encrypted_file_format.md`.

The application interface can be accessed over HID or BLE.

## APDUs List

| Description | Instruction |
| --- | --- |
| Encrypt file content | `0x10` |
| Decrypt file content | `0x11` |

## Constants

| Symbol | Value | Description |
| --- | --- | --- |
| `CLA` | `0xE0` | Application class byte. |
| `STAGE_INIT` | `0x00` | Start a streaming session. |
| `STAGE_UPDATE` | `0x01` | Process one streaming chunk. |
| `STAGE_FINAL` | `0x02` | Process final chunk and return/verify GCM tag. |
| `P2` | `0x00` | Reserved, MUST be zero. |
| `MAX_CHUNK` | `240` | Maximum plaintext/ciphertext bytes in one `UPDATE` or `FINAL` APDU. |
| `MAX_SESSION_BYTES` | `0xFFFFFFFF` | Maximum plaintext/ciphertext bytes in one streaming session. |
| `MAX_METADATA_HEADER` | `255` | Maximum `Magic || metadata_len || metadata TLVs` bytes returned by `ENCRYPT_INIT` or accepted by `DECRYPT_INIT`. |
| `MAX_METADATA_TLVS_WITHOUT_NONCE` | `229` | Maximum metadata TLV bytes accepted by `ENCRYPT_INIT`, leaving room for the device-generated `NONCE` TLV in a 255-byte metadata header. |
| `GCM_NONCE_LEN` | `12` | AES-GCM nonce length. |
| `GCM_TAG_LEN` | `16` | AES-GCM tag length. |

The device supports one in-flight streaming session at a time. Any `STAGE_INIT` wipes the previous session. `STAGE_FINAL` wipes the session whether it succeeds or fails. The device MUST track bytes processed and reject a session that would exceed `MAX_SESSION_BYTES` with `0x6700 WRONG_LENGTH`.

## Status Words

| SW | Name | Meaning |
| --- | --- | --- |
| `0x9000` | `OK` | Operation succeeded. |
| `0x6985` | `DENIED` | User rejected the confirmation prompt. |
| `0x6700` | `WRONG_LENGTH` | `Lc` or data length does not match the instruction. |
| `0x6A80` | `INVALID_DATA` | Malformed data, malformed DER TLV, missing required tag, or invalid metadata order. |
| `0x6A86` | `WRONG_P1P2` | Bad `P1`/`P2`, unknown stage, wrong direction, or no active session. |
| `0x6D00` | `INS_NOT_SUPPORTED` | Unknown instruction. |
| `0x6E00` | `CLA_NOT_SUPPORTED` | `CLA` is not `0xE0`. |
| `0x6F00` | `EXECUTION_ERROR` | Unexpected internal failure. |
| `0x6F01` | `INVALID_TAG` | AES-GCM tag verification failed. |
| `0x6F02` | `UNSUPPORTED_VERSION` | Metadata `VERSION` is not supported. |
| `0x6F03` | `UNSUPPORTED_CIPHER_SUITE` | Metadata `CIPHER_SUITE` is not supported. |

## Common Coding

_Command_

| CLA | INS | P1 | P2 | Lc | Le |
| --- | --- | --- | --- | --- | --- |
| `E0` | instruction | stage | `00` | variable | variable |

`P1` is the stage byte for `ENCRYPT` and `DECRYPT`:

| P1 | Stage |
| --- | --- |
| `0x00` | `STAGE_INIT` |
| `0x01` | `STAGE_UPDATE` |
| `0x02` | `STAGE_FINAL` |

## ENCRYPT FILE CONTENT

### Description

This command encrypts a plaintext stream using AES-256-GCM. The device derives the AES key from the SLIP-10 path, generates a random 96-bit nonce, adds it to metadata, starts AES-GCM with the full metadata header as AAD, then streams ciphertext back to the host.

### `ENCRYPT_INIT` — `0xE0 0x10 0x00 0x00`

_Input data_

| Description | Length |
| --- | --- |
| Metadata TLV length | 2, big-endian |
| Metadata TLVs without `NONCE` | variable, `<= 229` |

The input metadata TLVs MUST include all required non-nonce metadata fields:

| Field | Tag |
| --- | --- |
| `STRUCTURE_TYPE` | `0x01` |
| `VERSION` | `0x02` |
| `TRUSTED_NAME` | `0x20` |
| `TIME` | `0x26` |
| `CIPHER_SUITE` | `0x0101` |
| `MIME_TYPE` | `0x0102` |

The device MUST reject malformed TLVs, missing required TLVs, unsupported `VERSION`, unsupported `CIPHER_SUITE`, unexpected `STRUCTURE_TYPE`, or a host-supplied `NONCE` tag.

After user approval, the device generates a random 12-byte nonce, appends the `NONCE` TLV, constructs the full metadata header, and initializes AES-GCM with that header as AAD.

_Output data_

| Description | Length |
| --- | --- |
| Metadata header bytes | variable, `<= 255` |

`Metadata header bytes` is:

```text
Magic || Metadata TLV length || Metadata TLVs including NONCE
```

The host writes this header at the beginning of the encrypted file.

### `ENCRYPT_UPDATE` — `0xE0 0x10 0x01 0x00`

_Input data_

| Description | Length |
| --- | --- |
| Plaintext chunk | `1..240` |

_Output data_

| Description | Length |
| --- | --- |
| Ciphertext chunk | same as plaintext chunk |

Returns `0x6A86 WRONG_P1P2` if no encrypt session is active.

### `ENCRYPT_FINAL` — `0xE0 0x10 0x02 0x00`

_Input data_

| Description | Length |
| --- | --- |
| Trailing plaintext chunk | `0..240` |

_Output data_

| Description | Length |
| --- | --- |
| Trailing ciphertext chunk | same as trailing plaintext chunk |
| GCM tag | 16 |

The host appends the trailing ciphertext and tag to the encrypted file. The session is wiped before returning.

## DECRYPT FILE CONTENT

### Description

This command decrypts a ciphertext stream using AES-256-GCM. The host sends the metadata header from the encrypted file at init time. The device parses it, extracts the random nonce, prompts the user, starts AES-GCM with the metadata header as AAD, then streams provisional plaintext back to the host. The final tag verification decides whether the provisional plaintext is valid.

### `DECRYPT_INIT` — `0xE0 0x11 0x00 0x00`

_Input data_

| Description | Length |
| --- | --- |
| Metadata header length | 1 |
| Metadata header bytes | variable, `<= 255` |

The metadata header bytes contain:

```text
Magic || Metadata TLV length || Metadata TLVs including NONCE
```

The device MUST validate:

1. The magic word is `LDG_ENCR`.
2. Metadata TLV length matches the actual TLV byte length.
3. TLV tags and lengths are DER encoded.
4. Required metadata TLVs are present and valid.
5. `NONCE` exists exactly once and is 12 bytes.
6. `VERSION` and `CIPHER_SUITE` are supported.

If metadata is malformed, the device MUST abort without a consent prompt.

_Output data_

None. `0x9000 OK` means the user confirmed and AES-GCM was initialized.

### `DECRYPT_UPDATE` — `0xE0 0x11 0x01 0x00`

_Input data_

| Description | Length |
| --- | --- |
| Ciphertext chunk | `1..240` |

_Output data_

| Description | Length |
| --- | --- |
| Plaintext chunk | same as ciphertext chunk |

Plaintext returned by `DECRYPT_UPDATE` is provisional until `DECRYPT_FINAL` verifies the GCM tag.

### `DECRYPT_FINAL` — `0xE0 0x11 0x02 0x00`

_Input data_

| Description | Length |
| --- | --- |
| Trailing ciphertext chunk | `0..240` |
| GCM tag | 16 |

_Output data_

| Description | Length |
| --- | --- |
| Trailing plaintext chunk | same as trailing ciphertext chunk |

If the GCM tag verifies, the device returns `0x9000 OK` and the plaintext from the session is authentic. If verification fails, the device returns `0x6F01 INVALID_TAG`; host software MUST discard all plaintext returned by the session.

The session is wiped before returning in both cases.

## Host File Assembly

Encryption output is assembled as:

```text
Metadata header from ENCRYPT_INIT
|| ciphertext chunks from ENCRYPT_UPDATE / ENCRYPT_FINAL
|| GCM tag from ENCRYPT_FINAL
```

Decryption input is split as:

```text
Metadata header -> DECRYPT_INIT
Ciphertext except final tag -> DECRYPT_UPDATE / DECRYPT_FINAL
Final 16 bytes -> GCM tag in DECRYPT_FINAL
```

Host software MUST buffer or write decrypt output to a temporary file until `DECRYPT_FINAL` returns `0x9000 OK`.
