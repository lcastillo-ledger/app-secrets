#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

#include "cx.h"
#include "io.h"
#include "os.h"

#include "constants.h"
#include "encrypt_decrypt.h"
#include "display.h"
#include "menu.h"
#include "sw.h"

typedef enum {
    SESSION_NONE = 0,
    SESSION_ENCRYPT,
    SESSION_DECRYPT,
} session_direction_t;

typedef struct {
    session_direction_t direction;
    cx_aes_gcm_context_t gcm;
    uint32_t bytes_done;
} secrets_session_t;

typedef struct {
    bool structure_type;
    bool version;
    bool trusted_name;
    const uint8_t *trusted_name_ptr;
    uint8_t trusted_name_len;
    bool time;
    bool cipher_suite;
    bool mime_type;
    bool nonce;
    const uint8_t *nonce_ptr;
} metadata_state_t;

typedef struct {
    bool active;
    bool is_encrypt;
    uint8_t trusted_name[65];
    uint16_t tlvs_len;
    uint8_t tlvs[SECRETS_MAX_METADATA_TLVS_WITHOUT_NONCE];
    uint16_t header_len;
    uint8_t header[SECRETS_MAX_METADATA_HEADER];
    uint8_t nonce[SECRETS_GCM_NONCE_LEN];
} consent_request_t;

static secrets_session_t G_session;
static consent_request_t G_consent;

static const uint8_t MAGIC[] = {'L', 'D', 'G', '_', 'E', 'N', 'C', 'R'};
static const uint8_t HKDF_SALT[] = {'l', 'e', 'd', 'g', 'e', 'r', '-', 'e', 'n', 'c', 'r', 'y', 'p', 't', ' ', 'v', '1'};
static const uint8_t HKDF_INFO[] = {'l', 'e', 'd', 'g', 'e', 'r', '-', 'e', 'n', 'c', 'r', 'y', 'p', 't', ' ', 'v', '1', ' ', 'f', 'i', 'l', 'e', ' ', 'a', 'e', 's', '-', '2', '5', '6', '-', 'g', 'c', 'm'};
static const uint32_t DERIVATION_PATH[] = {
    0x8000002c,  // 44'
    0x8000e2c1,  // 0xE2C1'
    0x80000000,  // 0'
    0x00000000,  // 0
    0x00000000   // 0
};

static void session_clear(void) {
    explicit_bzero(&G_session, sizeof(G_session));
}

static void consent_clear(void) {
    explicit_bzero(&G_consent, sizeof(G_consent));
}

static cx_err_t derive_aes_key(uint8_t key[static 32]);

static int start_gcm_session(session_direction_t direction,
                             const uint8_t *key,
                             const uint8_t *nonce,
                             const uint8_t *aad,
                             size_t aad_len);

static bool read_der_u16(const uint8_t *data, size_t len, size_t *offset, uint16_t *value) {
    if (*offset >= len) {
        return false;
    }
    uint8_t first = data[(*offset)++];
    if ((first & 0x80) == 0) {
        *value = first;
        return true;
    }
    uint8_t n = first & 0x7F;
    if ((n == 0) || (n > 2) || (*offset + n > len)) {
        return false;
    }
    uint16_t out = 0;
    for (uint8_t i = 0; i < n; i++) {
        out = (uint16_t) ((out << 8) | data[(*offset)++]);
    }
    if (out < 0x80) {
        return false;
    }
    *value = out;
    return true;
}

static bool append_der_u16(uint8_t *out, size_t out_len, size_t *offset, uint16_t value) {
    if (value < 0x80) {
        if (*offset + 1 > out_len) return false;
        out[(*offset)++] = (uint8_t) value;
    } else if (value <= 0xFF) {
        if (*offset + 2 > out_len) return false;
        out[(*offset)++] = 0x81;
        out[(*offset)++] = (uint8_t) value;
    } else {
        if (*offset + 3 > out_len) return false;
        out[(*offset)++] = 0x82;
        out[(*offset)++] = (uint8_t) (value >> 8);
        out[(*offset)++] = (uint8_t) value;
    }
    return true;
}

static uint16_t validate_metadata_tlvs(const uint8_t *tlvs,
                                       size_t tlvs_len,
                                       bool require_nonce,
                                       bool reject_nonce,
                                       metadata_state_t *state) {
    size_t offset = 0;
    uint16_t tag = 0;
    uint16_t length = 0;
    uint8_t index = 0;
    memset(state, 0, sizeof(*state));

    while (offset < tlvs_len) {
        if (!read_der_u16(tlvs, tlvs_len, &offset, &tag) ||
            !read_der_u16(tlvs, tlvs_len, &offset, &length) ||
            offset + length > tlvs_len) {
            return SW_INVALID_DATA;
        }

        const uint8_t *value = tlvs + offset;
        if (index == 0 && tag != SECRETS_TAG_STRUCTURE_TYPE) return SW_INVALID_DATA;
        if (index == 1 && tag != SECRETS_TAG_VERSION) return SW_INVALID_DATA;

        switch (tag) {
            case SECRETS_TAG_STRUCTURE_TYPE:
                if (state->structure_type || length != 1 || value[0] != SECRETS_STRUCTURE_TYPE_FILE_METADATA) return SW_INVALID_DATA;
                state->structure_type = true;
                break;
            case SECRETS_TAG_VERSION:
                if (state->version || length != 1) return SW_INVALID_DATA;
                if (value[0] != SECRETS_VERSION) return SW_UNSUPPORTED_VERSION;
                state->version = true;
                break;
            case SECRETS_TAG_TRUSTED_NAME:
                if (state->trusted_name || length == 0 || length > 64) return SW_INVALID_DATA;
                state->trusted_name = true;
                state->trusted_name_ptr = value;
                state->trusted_name_len = (uint8_t) length;
                break;
            case SECRETS_TAG_TIME:
                if (state->time || length != 4) return SW_INVALID_DATA;
                state->time = true;
                break;
            case SECRETS_TAG_CIPHER_SUITE:
                if (state->cipher_suite || length != 1) return SW_INVALID_DATA;
                if (value[0] != SECRETS_CIPHER_SUITE_AES_256_GCM_HKDF_SHA256) return SW_UNSUPPORTED_CIPHER_SUITE;
                state->cipher_suite = true;
                break;
            case SECRETS_TAG_MIME_TYPE:
                if (state->mime_type || length == 0 || length > 64) return SW_INVALID_DATA;
                state->mime_type = true;
                break;
            case SECRETS_TAG_NONCE:
                if (reject_nonce || state->nonce || length != SECRETS_GCM_NONCE_LEN) return SW_INVALID_DATA;
                state->nonce = true;
                state->nonce_ptr = value;
                break;
            default:
                break;
        }
        offset += length;
        index++;
    }

    if (!state->structure_type || !state->version || !state->trusted_name || !state->time ||
        !state->cipher_suite || !state->mime_type) {
        return SW_INVALID_DATA;
    }
    if (require_nonce && !state->nonce) {
        return SW_INVALID_DATA;
    }
    return SWO_SUCCESS;
}

static bool consent_copy_name(const metadata_state_t *state) {
    if ((state->trusted_name_ptr == NULL) || (state->trusted_name_len >= sizeof(G_consent.trusted_name))) {
        return false;
    }

    memcpy(G_consent.trusted_name, state->trusted_name_ptr, state->trusted_name_len);
    G_consent.trusted_name[state->trusted_name_len] = '\0';
    return true;
}

static void finish_encrypt_init(bool confirmed) {
    uint8_t key[SECRETS_AES_KEY_LEN] = {0};
    uint8_t nonce[SECRETS_GCM_NONCE_LEN] = {0};
    uint16_t sw;
    size_t out_len = 0;

    if (!confirmed) {
        consent_clear();
        io_send_sw(SW_DENIED);
        return;
    }

    cx_rng_no_throw(nonce, sizeof(nonce));
    if (derive_aes_key(key) != CX_OK) {
        explicit_bzero(key, sizeof(key));
        consent_clear();
        io_send_sw(SW_EXECUTION_ERROR);
        return;
    }

    memcpy(G_io_apdu_buffer, MAGIC, sizeof(MAGIC));
    out_len = sizeof(MAGIC) + 2;
    memcpy(G_io_apdu_buffer + out_len, G_consent.tlvs, G_consent.tlvs_len);
    out_len += G_consent.tlvs_len;
    if (!append_der_u16(G_io_apdu_buffer, SECRETS_MAX_METADATA_HEADER, &out_len, SECRETS_TAG_NONCE) ||
        !append_der_u16(G_io_apdu_buffer, SECRETS_MAX_METADATA_HEADER, &out_len, SECRETS_GCM_NONCE_LEN) ||
        out_len + sizeof(nonce) > SECRETS_MAX_METADATA_HEADER) {
        explicit_bzero(key, sizeof(key));
        explicit_bzero(nonce, sizeof(nonce));
        consent_clear();
        io_send_sw(SW_EXECUTION_ERROR);
        return;
    }
    memcpy(G_io_apdu_buffer + out_len, nonce, sizeof(nonce));
    out_len += sizeof(nonce);
    uint16_t full_tlvs_len = (uint16_t) (out_len - sizeof(MAGIC) - 2);
    G_io_apdu_buffer[sizeof(MAGIC)] = (uint8_t) (full_tlvs_len >> 8);
    G_io_apdu_buffer[sizeof(MAGIC) + 1] = (uint8_t) full_tlvs_len;

    sw = start_gcm_session(SESSION_ENCRYPT, key, nonce, G_io_apdu_buffer, out_len);
    explicit_bzero(key, sizeof(key));
    explicit_bzero(nonce, sizeof(nonce));
    consent_clear();
    if (sw != SWO_SUCCESS) {
        session_clear();
        io_send_sw(sw);
        return;
    }
    (void) io_send_response_pointer(G_io_apdu_buffer, out_len, SWO_SUCCESS);
    ui_menu_main();
}

static void finish_decrypt_init(bool confirmed) {
    uint8_t key[SECRETS_AES_KEY_LEN] = {0};
    uint16_t sw;

    if (!confirmed) {
        consent_clear();
        io_send_sw(SW_DENIED);
        return;
    }

    if (derive_aes_key(key) != CX_OK) {
        explicit_bzero(key, sizeof(key));
        consent_clear();
        io_send_sw(SW_EXECUTION_ERROR);
        return;
    }
    sw = start_gcm_session(SESSION_DECRYPT, key, G_consent.nonce, G_consent.header, G_consent.header_len);
    explicit_bzero(key, sizeof(key));
    consent_clear();
    if (sw != SWO_SUCCESS) {
        session_clear();
        io_send_sw(sw);
        return;
    }
    (void) io_send_sw(SWO_SUCCESS);
    ui_menu_main();
}

static void encrypt_consent_callback(bool confirmed) {
    finish_encrypt_init(confirmed);
}

static void decrypt_consent_callback(bool confirmed) {
    finish_decrypt_init(confirmed);
}

static cx_err_t hkdf_sha256(const uint8_t *ikm, size_t ikm_len, uint8_t out[static 32]) {
    uint8_t prk[32] = {0};
    uint8_t info_block[sizeof(HKDF_INFO) + 1] = {0};

    cx_hmac_sha256((uint8_t *) HKDF_SALT, sizeof(HKDF_SALT), (uint8_t *) ikm, ikm_len, prk, sizeof(prk));

    memcpy(info_block, HKDF_INFO, sizeof(HKDF_INFO));
    info_block[sizeof(HKDF_INFO)] = 0x01;
    cx_hmac_sha256(prk, sizeof(prk), info_block, sizeof(info_block), out, 32);
    explicit_bzero(prk, sizeof(prk));
    explicit_bzero(info_block, sizeof(info_block));
    return CX_OK;
}

static cx_err_t derive_aes_key(uint8_t key[static 32]) {
    uint8_t private_key[64] = {0};
    uint8_t chain_code[32] = {0};
    cx_err_t err;

    os_perso_derive_node_bip32(CX_CURVE_Ed25519,
                               DERIVATION_PATH,
                               sizeof(DERIVATION_PATH) / sizeof(DERIVATION_PATH[0]),
                               private_key,
                               chain_code);
    err = hkdf_sha256(private_key, 32, key);
    explicit_bzero(private_key, sizeof(private_key));
    explicit_bzero(chain_code, sizeof(chain_code));
    return err;
}

static int start_gcm_session(session_direction_t direction,
                             const uint8_t *key,
                             const uint8_t *nonce,
                             const uint8_t *aad,
                             size_t aad_len) {
    uint32_t mode = direction == SESSION_ENCRYPT ? CX_ENCRYPT : CX_DECRYPT;
    cx_err_t err;

    cx_aes_gcm_init(&G_session.gcm);
    err = cx_aes_gcm_set_key(&G_session.gcm, key, SECRETS_AES_KEY_LEN);
    if (err != CX_OK) return SW_EXECUTION_ERROR;
    err = cx_aes_gcm_start(&G_session.gcm, mode, nonce, SECRETS_GCM_NONCE_LEN);
    if (err != CX_OK) return SW_EXECUTION_ERROR;
    err = cx_aes_gcm_update_aad(&G_session.gcm, aad, aad_len);
    if (err != CX_OK) return SW_EXECUTION_ERROR;
    G_session.direction = direction;
    G_session.bytes_done = 0;
    return SWO_SUCCESS;
}

static int encrypt_init(const command_t *cmd) {
    uint16_t tlvs_len;
    uint16_t sw;
    metadata_state_t state;
    uint8_t tlvs_copy[SECRETS_MAX_METADATA_TLVS_WITHOUT_NONCE] = {0};
    const uint8_t *tlvs;

    session_clear();
    consent_clear();
    if (cmd->lc < 2) return io_send_sw(SWO_WRONG_DATA_LENGTH);
    tlvs_len = (uint16_t) ((cmd->data[0] << 8) | cmd->data[1]);
    if (tlvs_len != cmd->lc - 2 || tlvs_len > SECRETS_MAX_METADATA_TLVS_WITHOUT_NONCE) {
        return io_send_sw(SWO_WRONG_DATA_LENGTH);
    }
    tlvs = cmd->data + 2;
    memcpy(tlvs_copy, tlvs, tlvs_len);
    tlvs = tlvs_copy;
    sw = validate_metadata_tlvs(tlvs, tlvs_len, false, true, &state);
    if (sw != SWO_SUCCESS) return io_send_sw(sw);

    if (!consent_copy_name(&state)) return io_send_sw(SW_INVALID_DATA);
    memcpy(G_consent.tlvs, tlvs, tlvs_len);
    G_consent.tlvs_len = tlvs_len;
    G_consent.is_encrypt = true;
    G_consent.active = true;
    if (ui_display_metadata_consent("Approve encryption", (const char *) G_consent.trusted_name, encrypt_consent_callback) < 0) {
        consent_clear();
        return io_send_sw(SW_EXECUTION_ERROR);
    }
    return 0;
}

static int decrypt_init(const command_t *cmd) {
    uint8_t header_len;
    uint16_t tlvs_len;
    uint16_t sw;
    metadata_state_t state;
    const uint8_t *header;
    const uint8_t *tlvs;

    session_clear();
    consent_clear();
    if (cmd->lc < 1) return io_send_sw(SWO_WRONG_DATA_LENGTH);
    header_len = cmd->data[0];
    if (header_len != cmd->lc - 1 || header_len > SECRETS_MAX_METADATA_HEADER || header_len < sizeof(MAGIC) + 2) {
        return io_send_sw(SWO_WRONG_DATA_LENGTH);
    }
    header = cmd->data + 1;
    if (memcmp(header, MAGIC, sizeof(MAGIC)) != 0) return io_send_sw(SW_INVALID_DATA);
    tlvs_len = (uint16_t) ((header[sizeof(MAGIC)] << 8) | header[sizeof(MAGIC) + 1]);
    if (tlvs_len != header_len - sizeof(MAGIC) - 2) return io_send_sw(SW_INVALID_DATA);
    tlvs = header + sizeof(MAGIC) + 2;
    sw = validate_metadata_tlvs(tlvs, tlvs_len, true, false, &state);
    if (sw != SWO_SUCCESS) return io_send_sw(sw);

    if (!consent_copy_name(&state)) return io_send_sw(SW_INVALID_DATA);
    memcpy(G_consent.header, header, header_len);
    memcpy(G_consent.nonce, state.nonce_ptr, sizeof(G_consent.nonce));
    G_consent.header_len = header_len;
    G_consent.is_encrypt = false;
    G_consent.active = true;
    if (ui_display_metadata_consent("Approve decryption", (const char *) G_consent.trusted_name, decrypt_consent_callback) < 0) {
        consent_clear();
        return io_send_sw(SW_EXECUTION_ERROR);
    }
    return 0;
}

static int update_chunk(const command_t *cmd, session_direction_t direction) {
    if (G_session.direction != direction) return io_send_sw(SWO_INCORRECT_P1_P2);
    if (cmd->lc == 0 || cmd->lc > SECRETS_MAX_CHUNK) return io_send_sw(SWO_WRONG_DATA_LENGTH);
    if (G_session.bytes_done > UINT32_MAX - cmd->lc) return io_send_sw(SWO_WRONG_DATA_LENGTH);
    if (cx_aes_gcm_update(&G_session.gcm, cmd->data, G_io_apdu_buffer, cmd->lc) != CX_OK) {
        session_clear();
        return io_send_sw(SW_EXECUTION_ERROR);
    }
    G_session.bytes_done += cmd->lc;
    return io_send_response_pointer(G_io_apdu_buffer, cmd->lc, SWO_SUCCESS);
}

static int final_chunk(const command_t *cmd, session_direction_t direction) {
    uint8_t tag[SECRETS_GCM_TAG_LEN] = {0};
    uint8_t chunk_len;
    uint16_t sw = SWO_SUCCESS;

    if (G_session.direction != direction) return io_send_sw(SWO_INCORRECT_P1_P2);
    if (direction == SESSION_ENCRYPT) {
        if (cmd->lc > SECRETS_MAX_CHUNK) return io_send_sw(SWO_WRONG_DATA_LENGTH);
        chunk_len = cmd->lc;
    } else {
        if (cmd->lc < SECRETS_GCM_TAG_LEN ||
            cmd->lc > SECRETS_MAX_DECRYPT_FINAL_CHUNK + SECRETS_GCM_TAG_LEN) {
            return io_send_sw(SWO_WRONG_DATA_LENGTH);
        }
        chunk_len = (uint8_t) (cmd->lc - SECRETS_GCM_TAG_LEN);
    }
    if (G_session.bytes_done > UINT32_MAX - chunk_len) return io_send_sw(SWO_WRONG_DATA_LENGTH);
    if (chunk_len > 0 && cx_aes_gcm_update(&G_session.gcm, cmd->data, G_io_apdu_buffer, chunk_len) != CX_OK) {
        session_clear();
        return io_send_sw(SWO_EXECUTION_ERROR);
    }
    G_session.bytes_done += chunk_len;

    if (direction == SESSION_ENCRYPT) {
        if (cx_aes_gcm_finish(&G_session.gcm, tag, sizeof(tag)) != CX_OK) {
            sw = SW_EXECUTION_ERROR;
        } else {
            memcpy(G_io_apdu_buffer + chunk_len, tag, sizeof(tag));
        }
    } else {
        if (cx_aes_gcm_check_tag(&G_session.gcm, cmd->data + chunk_len, SECRETS_GCM_TAG_LEN) != CX_OK) {
            sw = SW_INVALID_TAG;
        }
    }
    session_clear();
    explicit_bzero(tag, sizeof(tag));
    if (sw != SWO_SUCCESS) return io_send_sw(sw);
    return io_send_response_pointer(G_io_apdu_buffer,
                                    direction == SESSION_ENCRYPT ? chunk_len + SECRETS_GCM_TAG_LEN : chunk_len,
                                    SWO_SUCCESS);
}

int handler_encrypt_decrypt(const command_t *cmd) {
    if (cmd->p2 != 0) return io_send_sw(SWO_INCORRECT_P1_P2);
    switch (cmd->p1) {
        case SECRETS_STAGE_INIT:
            return cmd->ins == ENCRYPT ? encrypt_init(cmd) : decrypt_init(cmd);
        case SECRETS_STAGE_UPDATE:
            return update_chunk(cmd, cmd->ins == ENCRYPT ? SESSION_ENCRYPT : SESSION_DECRYPT);
        case SECRETS_STAGE_FINAL:
            return final_chunk(cmd, cmd->ins == ENCRYPT ? SESSION_ENCRYPT : SESSION_DECRYPT);
        default:
            return io_send_sw(SWO_INCORRECT_P1_P2);
    }
}
