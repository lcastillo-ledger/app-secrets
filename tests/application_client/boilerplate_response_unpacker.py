from typing import Tuple
from struct import unpack


def unpack_get_app_name_response(response: bytes) -> str:
    return response.decode("ascii")


def unpack_get_version_response(response: bytes) -> Tuple[int, int, int]:
    assert len(response) == 3
    major, minor, patch = unpack("BBB", response)
    return (major, minor, patch)
