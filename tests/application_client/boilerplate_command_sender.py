from enum import IntEnum

from ragger.backend.interface import BackendInterface, RAPDU
from ragger.error import StatusWords

CLA: int = 0xE0


class P1(IntEnum):
    P1_START = 0x00
    STAGE_INIT = 0x00
    STAGE_UPDATE = 0x01
    STAGE_FINAL = 0x02


class P2(IntEnum):
    P2_LAST = 0x00


class InsType(IntEnum):
    GET_VERSION        = 0x03
    GET_APP_NAME       = 0x04
    ENCRYPT            = 0x10
    DECRYPT            = 0x11


custom_errors = {
    "SW_INVALID_DATA":          0x6A80,
    "SW_INVALID_TAG":           0x6F01,
    "SW_UNSUPPORTED_VERSION":   0x6F02,
    "SW_UNSUPPORTED_CIPHER_SUITE": 0x6F03,
}

_errors_dict = {m.name: m.value for m in StatusWords}
_errors_dict.update(custom_errors)
Errors = IntEnum("Errors", _errors_dict)  # type: ignore[misc]


class BoilerplateCommandSender:
    def __init__(self, backend: BackendInterface) -> None:
        self.backend = backend

    def get_app_and_version(self) -> RAPDU:
        return self.backend.exchange(cla=0xB0,  # specific CLA for BOLOS
                                     ins=0x01,  # specific INS for get_app_and_version
                                     p1=P1.P1_START,
                                     p2=P2.P2_LAST,
                                     data=b"")


    def get_version(self) -> RAPDU:
        return self.backend.exchange(cla=CLA,
                                     ins=InsType.GET_VERSION,
                                     p1=P1.P1_START,
                                     p2=P2.P2_LAST,
                                     data=b"")


    def get_app_name(self) -> RAPDU:
        return self.backend.exchange(cla=CLA,
                                     ins=InsType.GET_APP_NAME,
                                     p1=P1.P1_START,
                                     p2=P2.P2_LAST,
                                     data=b"")

    def encrypt_init(self, metadata_tlvs: bytes) -> RAPDU:
        return self.backend.exchange(cla=CLA,
                                     ins=InsType.ENCRYPT,
                                     p1=P1.STAGE_INIT,
                                     p2=0x00,
                                     data=len(metadata_tlvs).to_bytes(2, "big") + metadata_tlvs)

    def encrypt_update(self, chunk: bytes) -> RAPDU:
        return self.backend.exchange(cla=CLA,
                                     ins=InsType.ENCRYPT,
                                     p1=P1.STAGE_UPDATE,
                                     p2=0x00,
                                     data=chunk)

    def encrypt_final(self, chunk: bytes = b"") -> RAPDU:
        return self.backend.exchange(cla=CLA,
                                     ins=InsType.ENCRYPT,
                                     p1=P1.STAGE_FINAL,
                                     p2=0x00,
                                     data=chunk)

    def decrypt_init(self, metadata_header: bytes) -> RAPDU:
        assert len(metadata_header) <= 255
        return self.backend.exchange(cla=CLA,
                                     ins=InsType.DECRYPT,
                                     p1=P1.STAGE_INIT,
                                     p2=0x00,
                                     data=len(metadata_header).to_bytes(1, "big") + metadata_header)

    def decrypt_update(self, chunk: bytes) -> RAPDU:
        return self.backend.exchange(cla=CLA,
                                     ins=InsType.DECRYPT,
                                     p1=P1.STAGE_UPDATE,
                                     p2=0x00,
                                     data=chunk)

    def decrypt_final(self, chunk: bytes, tag: bytes) -> RAPDU:
        return self.backend.exchange(cla=CLA,
                                     ins=InsType.DECRYPT,
                                     p1=P1.STAGE_FINAL,
                                     p2=0x00,
                                     data=chunk + tag)
