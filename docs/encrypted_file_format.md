# Encrypted File Format Specification

This document defines a device-encrypted file container designed for relatively small files that can be streamed through a Ledger-style application.

## Goals

1. Provide user-visible provenance during encryption/decryption.
2. Bind encryption/decryption to a plaintext content hash.
3. Make the metadata tamper-evident with a device signature derived from a dedicated BIP32 signing key.
4. Allow streaming of encrypted content while keeping metadata compact.
5. Reuse Ledger common descriptor fields and Ledger SDK cryptographic primitives where possible.

## High-level layout

An encrypted file is made of:

| Description | Length |
| --- | --- |
| Magic word | 8 |
| Metadata TLVs | variable |
| Ciphertext | variable |

The content section begins immediately after the final metadata TLV. The metadata length is provided by the APDU flow that creates or consumes the container.

## Magic Word

The file starts with the 8-byte ASCII string `LDG_ENCR`.

| ASCII | Hex |
| --- | --- |
| `LDG_ENCR` | `4C 44 47 5F 45 4E 43 52` |

## Byte Order

All integer values inside TLV values use big-endian encoding unless a field explicitly specifies another encoding.

## TLV Encoding

Metadata uses the Ledger common-fields TLV encoding.

| Description | Length |
| --- | --- |
| Tag | DER encoded integer |
| Length | DER encoded integer |
| Value | `Length` bytes |

Tag and length MUST be DER encoded, not fixed-size `u8`/`u16` fields. For values from `0x00` to `0x7f`, the DER encoding is a single byte. For larger values, use the long form: `0x80 | byte_count` followed by the minimal big-endian representation of the value.

TLVs are concatenated in the order chosen by the application, except:

1. `STRUCTURE_TYPE` and `VERSION` MUST be the first two TLVs.
2. `DER_SIGNATURE` MUST be the final metadata TLV.

Implementations SHOULD reuse the Ledger SDK/common TLV parser when available rather than adding a second ad hoc parser.

## Metadata TLVs

The format reuses tags from the common Nano certificates and descriptors field registry when a matching field exists. File-specific tags are allocated above the current common-field registry to avoid conflicts.

| Field | Tag | Value length | Value type | Required | Description |
| --- | --- | --- | --- | --- | --- |
| `STRUCTURE_TYPE` | `0x01` | 1 | enum | Yes | Must be `TYPE_FILE_METADATA = 0x34`, proposed as the next value after the currently assigned common `StructType` values. |
| `VERSION` | `0x02` | 1 | `u1` | Yes | Must be `1` for this version. |
| `DER_SIGNATURE` | `0x15` | variable | DER ECDSA signature | Yes | Signature over the magic word and all metadata TLVs except the entire `DER_SIGNATURE` TLV. |
| `TRUSTED_NAME` | `0x20` | variable | UTF-8 | Yes | User-visible display name. Recommended maximum: 64 bytes. |
| `TIME` | `0x26` | 4 | `s4` | Yes | Creation time, encoded as Unix time in seconds. |
| `CONTENT_HASH` | `0x0100` | 32 | `bytes` | Yes | SHA-256 hash of the plaintext content. New file-specific tag. |
| `CIPHER_SUITE` | `0x0101` | 1 | enum | Yes | Must be `1` for `AES-128-CTR-HKDF-SHA256-SHA256`. New file-specific tag. |
| `MIME_TYPE` | `0x0102` | variable | UTF-8 | Yes | MIME type such as `text/plain` or `application/octet-stream`. New file-specific tag. |

Additional TLVs MAY be added later. They are protected if they are placed before `DER_SIGNATURE`, because the signature covers every non-signature metadata TLV.

## Signature Coverage

The signature MUST be computed over the magic word and the metadata TLVs excluding the entire `DER_SIGNATURE` TLV.

Let `SIGNATURE_INPUT` be:

```text
Magic || TLV[0] || TLV[1] || ... || TLV[n-1]
```

Where none of `TLV[0..n-1]` is the `DER_SIGNATURE` TLV. The `DER_SIGNATURE` tag, DER length, and value bytes are not included.

The device computes:

```text
digest = SHA-256(SIGNATURE_INPUT)
signature = ECDSA_sign(metadata_signature_private_key, digest)
```

The verifier MUST recompute the same input bytes and verify with the public key derived from the metadata signature BIP32 path.

Implementations SHOULD use Ledger SDK SHA-256 and ECDSA functions for signing and verification.

## BIP32 Key Derivation

The application uses BIP32 for both metadata signing and encryption-key derivation. The two paths MUST be distinct and domain-separated.

Proposed hardened derivation paths:

| Purpose | Path |
| --- | --- |
| Metadata header signature | `m/83696968'/0'/0'` |
| File encryption key root | `m/83696968'/1'/0'` |

The first hardened component is an application-specific purpose and is intentionally not one of the known blockchain/account purposes such as `44'`, `49'`, `84'`, `86'`, or `12381'`. This keeps the paths outside known blockchain namespaces.

Implementations SHOULD derive nodes with the Ledger SDK BIP32 API, for example `os_perso_derive_node_bip32`, using a curve supported by the target app. The signing path derives the private key used by the SDK ECDSA signing function. The encryption path derives an internal root secret used only as input keying material for the symmetric KDF.

## Encryption Key Derivation

Input values:

| Description | Source |
| --- | --- |
| `enc_root_secret` | private key material derived from `m/83696968'/1'/0'` |
| `content_hash` | `CONTENT_HASH` TLV (`0x0100`) |

Derivation:

```text
aes_key_material = HKDF-SHA256(
    ikm = enc_root_secret,
    salt = content_hash,
    info = "LDG_ENCR_AES_V1",
    length = 32
)

aes_key = aes_key_material[0:16]
iv      = SHA-256("LDG_ENCR_IV_V1" || content_hash)[0:16]
```

HKDF SHOULD be implemented with the Ledger SDK HMAC-SHA256/SHA-256 primitives rather than an unrelated cryptography implementation.

The application MUST clear derived secrets from memory as soon as possible.

## Content Encryption Algorithm

Version 1 supports exactly one cipher suite:

| `CIPHER_SUITE` | Algorithm |
| --- | --- |
| `1` | `AES-128-CTR-HKDF-SHA256-SHA256` |

Encryption uses AES-128 in CTR mode with the IV/counter derived above. AES-CTR is selected because it supports chunked streaming and is available in the Ledger cryptography SDK through the AES API with CTR chaining mode. Implementations SHOULD use the SDK AES primitives, for example `cx_aes_init_key_no_throw` and `cx_aes_iv_no_throw` with `CX_CHAIN_CTR`.

CTR mode does not authenticate ciphertext. Integrity is enforced by verifying the metadata signature before decryption and by checking the SHA-256 plaintext hash after encryption/decryption.

## Encryption Checks

During encryption, the device:

1. Prompts user consent using `TRUSTED_NAME`, `MIME_TYPE`, and `TIME` when useful.
2. Derives the AES key from the encryption BIP32 path and `CONTENT_HASH`.
3. Streams plaintext, encrypts it, and returns ciphertext chunks.
4. Computes `real_hash = SHA-256(plaintext)` while streaming.
5. On the final chunk, compares `real_hash` to `CONTENT_HASH`.
6. If the hash matches, signs the metadata and returns the metadata header.
7. If the hash does not match, aborts; host MUST discard ciphertext from this session.

## Decryption Checks

During decryption, the device:

1. Parses metadata using DER TLV rules.
2. Verifies the metadata signature over `SIGNATURE_INPUT` before showing any trusted metadata to the user.
3. Prompts user consent using verified metadata.
4. Derives the AES key from the encryption BIP32 path and `CONTENT_HASH`.
5. Streams ciphertext, decrypts it, and returns plaintext chunks.
6. Computes `real_hash = SHA-256(plaintext)` while streaming.
7. On the final chunk, compares `real_hash` to `CONTENT_HASH` and returns an error if they differ.
