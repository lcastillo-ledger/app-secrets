import pytest

from Crypto.Cipher import AES
from Crypto.Protocol.KDF import HKDF
from Crypto.Hash import SHA256
from ragger.backend.interface import BackendInterface
from ragger.navigator import NavInsID
from ragger.error import ExceptionRAPDU

from application_client.boilerplate_command_sender import BoilerplateCommandSender, Errors
from application_client.tlv import format_tlv


MAGIC = b"LDG_ENCR"
TAG_NONCE = 0x0103
MAX_CHUNK = 240


def metadata_tlvs(version: int = 1, cipher_suite: int = 1) -> bytes:
    return b"".join([
        format_tlv(0x01, 0x34),
        format_tlv(0x02, version),
        format_tlv(0x20, "demo"),
        format_tlv(0x26, bytes.fromhex("6553f100")),
        format_tlv(0x0101, cipher_suite),
        format_tlv(0x0102, "text/plain"),
    ])


def read_der(data: bytes, offset: int) -> tuple[int, int]:
    first = data[offset]
    offset += 1
    if first < 0x80:
        return first, offset
    count = first & 0x7F
    value = int.from_bytes(data[offset:offset + count], "big")
    return value, offset + count


def parse_tlvs(data: bytes) -> dict[int, list[bytes]]:
    out: dict[int, list[bytes]] = {}
    offset = 0
    while offset < len(data):
        tag, offset = read_der(data, offset)
        length, offset = read_der(data, offset)
        value = data[offset:offset + length]
        offset += length
        out.setdefault(tag, []).append(value)
    assert offset == len(data)
    return out


def split_chunks(data: bytes) -> list[bytes]:
    return [data[i:i + MAX_CHUNK] for i in range(0, len(data), MAX_CHUNK)]


def encrypt_with_consent(client: BoilerplateCommandSender,
                         backend: BackendInterface,
                         navigator,
                         plaintext: bytes) -> tuple[bytes, bytes, bytes]:
    with client.encrypt_init_async(metadata_tlvs()):
        navigator.navigate([NavInsID.USE_CASE_CHOICE_CONFIRM], screen_change_after_last_instruction=False)

    rapdu = backend.last_async_response
    assert rapdu is not None
    header = rapdu.data
    assert header.startswith(MAGIC)
    tlv_len = int.from_bytes(header[8:10], "big")
    assert tlv_len == len(header) - 10
    tlvs = parse_tlvs(header[10:])
    assert tlvs[TAG_NONCE][0] and len(tlvs[TAG_NONCE][0]) == 12

    chunks = split_chunks(plaintext)
    ciphertext = b""
    for chunk in chunks[:-1]:
        ciphertext += client.encrypt_update(chunk).data
    final_chunk = chunks[-1] if chunks else b""
    final = client.encrypt_final(final_chunk).data
    ciphertext += final[:-16]
    tag = final[-16:]
    assert len(ciphertext) == len(plaintext)
    return header, ciphertext, tag


def decrypt(client: BoilerplateCommandSender,
            backend: BackendInterface,
            navigator,
            header: bytes,
            ciphertext: bytes,
            tag: bytes) -> bytes:
    with client.decrypt_init_async(header):
        navigator.navigate([NavInsID.USE_CASE_CHOICE_CONFIRM], screen_change_after_last_instruction=False)

    rapdu = backend.last_async_response
    assert rapdu is not None
    assert rapdu.status == 0x9000
    chunks = split_chunks(ciphertext)
    plaintext = b""
    for chunk in chunks[:-1]:
        plaintext += client.decrypt_update(chunk).data
    final_chunk = chunks[-1] if chunks else b""
    plaintext += client.decrypt_final(final_chunk, tag).data
    return plaintext


def test_encrypt_decrypt_roundtrip(backend: BackendInterface, navigator) -> None:
    client = BoilerplateCommandSender(backend)
    plaintext = bytes(range(256)) + b"Ledger secrets" * 20
    header, ciphertext, tag = encrypt_with_consent(client, backend, navigator, plaintext)
    assert decrypt(client, backend, navigator, header, ciphertext, tag) == plaintext


def test_empty_plaintext_roundtrip(backend: BackendInterface, navigator) -> None:
    client = BoilerplateCommandSender(backend)
    header, ciphertext, tag = encrypt_with_consent(client, backend, navigator, b"")
    assert ciphertext == b""
    assert decrypt(client, backend, navigator, header, ciphertext, tag) == b""


def test_tampered_tag_is_rejected(backend: BackendInterface, navigator) -> None:
    client = BoilerplateCommandSender(backend)
    header, ciphertext, tag = encrypt_with_consent(client, backend, navigator, b"authenticated plaintext")
    with client.decrypt_init_async(header):
        navigator.navigate([NavInsID.USE_CASE_CHOICE_CONFIRM], screen_change_after_last_instruction=False)
    bad_tag = tag[:-1] + bytes([tag[-1] ^ 1])
    with pytest.raises(ExceptionRAPDU) as err:
        client.decrypt_final(ciphertext, bad_tag)
    assert err.value.status == Errors.SW_INVALID_TAG


def test_update_without_session_is_rejected(backend: BackendInterface) -> None:
    client = BoilerplateCommandSender(backend)
    with pytest.raises(ExceptionRAPDU) as err:
        client.encrypt_update(b"abc")
    assert err.value.status == Errors.SWO_INCORRECT_P1_P2


def test_unsupported_version_is_rejected(backend: BackendInterface) -> None:
    client = BoilerplateCommandSender(backend)
    with pytest.raises(ExceptionRAPDU) as err:
        client.encrypt_init(metadata_tlvs(version=2))
    assert err.value.status == Errors.SW_UNSUPPORTED_VERSION


def test_unsupported_cipher_suite_is_rejected(backend: BackendInterface) -> None:
    client = BoilerplateCommandSender(backend)
    with pytest.raises(ExceptionRAPDU) as err:
        client.encrypt_init(metadata_tlvs(cipher_suite=2))
    assert err.value.status == Errors.SW_UNSUPPORTED_CIPHER_SUITE


def test_missing_trusted_name_is_rejected(backend: BackendInterface) -> None:
    client = BoilerplateCommandSender(backend)
    tlvs = b"".join([
        format_tlv(0x01, 0x34),
        format_tlv(0x02, 1),
        format_tlv(0x26, bytes.fromhex("6553f100")),
        format_tlv(0x0101, 1),
        format_tlv(0x0102, "text/plain"),
    ])
    with pytest.raises(ExceptionRAPDU) as err:
        client.encrypt_init(tlvs)
    assert err.value.status == Errors.SW_INVALID_DATA


def test_documented_aes_gcm_vector() -> None:
    ikm = bytes.fromhex("000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f")
    key = HKDF(ikm, 32, b"ledger-encrypt v1", SHA256, context=b"ledger-encrypt v1 file aes-256-gcm")
    assert key.hex() == "59d7e64f89c29f403ebc9f42cd4a329a2c73aab922622ca0e1028e6660e1bfbb"
    aad = bytes.fromhex("4c44475f454e43520035010134020101200464656d6f26046553f10082010101018201020a746578742f706c61696e8201030c101112131415161718191a1b")
    nonce = bytes.fromhex("101112131415161718191a1b")
    cipher = AES.new(key, AES.MODE_GCM, nonce=nonce)
    cipher.update(aad)
    ciphertext, tag = cipher.encrypt_and_digest(b"hello")
    assert ciphertext.hex() == "ac3a07080f"
    assert tag.hex() == "fa29bcdbe0d9253ffb601dcb79e564b4"
