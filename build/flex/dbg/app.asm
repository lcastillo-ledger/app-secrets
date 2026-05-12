
build/flex/bin/app.elf:     file format elf32-littlearm


Disassembly of section .text:

c0de0000 <main>:
}
// --8<-- [end:library_app_main]
#endif  // HAVE_SWAP

WEAK __attribute__((section(".boot"))) int main(int arg0)
{
c0de0000:	b510      	push	{r4, lr}
c0de0002:	4604      	mov	r4, r0
    // exit critical section
    __asm volatile("cpsie i");
c0de0004:	b662      	cpsie	i

    // Ensure exception will work as planned
    os_boot();
c0de0006:	f008 fdf3 	bl	c0de8bf0 <os_boot>

    if (arg0 == 0) {
c0de000a:	2c00      	cmp	r4, #0
        // Called from dashboard as standalone App
        standalone_app_main();
c0de000c:	bf08      	it	eq
c0de000e:	f008 fb66 	bleq	c0de86de <standalone_app_main>
            app_exit();
        }
    }
#endif  // HAVE_SWAP

    return 0;
c0de0012:	2000      	movs	r0, #0
c0de0014:	bd10      	pop	{r4, pc}

c0de0016 <apdu_dispatcher>:

#include "get_version.h"
#include "get_app_name.h"
#include "encrypt_decrypt.h"

int apdu_dispatcher(const command_t *cmd) {
c0de0016:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0018:	b081      	sub	sp, #4
    LEDGER_ASSERT(cmd != NULL, "NULL cmd");
c0de001a:	b388      	cbz	r0, c0de0080 <apdu_dispatcher+0x6a>

    if (cmd->cla != CLA) {
c0de001c:	7801      	ldrb	r1, [r0, #0]
c0de001e:	29e0      	cmp	r1, #224	@ 0xe0
c0de0020:	d110      	bne.n	c0de0044 <apdu_dispatcher+0x2e>
        return io_send_sw(SWO_INVALID_CLA);
    }

    switch (cmd->ins) {
c0de0022:	7841      	ldrb	r1, [r0, #1]
c0de0024:	f1a1 0210 	sub.w	r2, r1, #16
c0de0028:	2a02      	cmp	r2, #2
c0de002a:	d310      	bcc.n	c0de004e <apdu_dispatcher+0x38>
c0de002c:	2904      	cmp	r1, #4
c0de002e:	d012      	beq.n	c0de0056 <apdu_dispatcher+0x40>
c0de0030:	2903      	cmp	r1, #3
c0de0032:	d119      	bne.n	c0de0068 <apdu_dispatcher+0x52>
        case GET_VERSION:
            if (cmd->p1 != 0 || cmd->p2 != 0) {
c0de0034:	7881      	ldrb	r1, [r0, #2]
c0de0036:	b991      	cbnz	r1, c0de005e <apdu_dispatcher+0x48>
c0de0038:	78c0      	ldrb	r0, [r0, #3]
c0de003a:	b980      	cbnz	r0, c0de005e <apdu_dispatcher+0x48>
                return io_send_sw(SWO_INCORRECT_P1_P2);
            }
            return handler_get_version();
c0de003c:	f000 fd34 	bl	c0de0aa8 <handler_get_version>
            return handler_encrypt_decrypt(cmd);

        default:
            return io_send_sw(SWO_INVALID_INS);
    }
}
c0de0040:	b001      	add	sp, #4
c0de0042:	bdf0      	pop	{r4, r5, r6, r7, pc}
 * @return zero or positive integer if success, -1 otherwise.
 *
 */
static inline int io_send_sw(uint16_t sw)
{
    return io_send_response_buffers(NULL, 0, sw);
c0de0044:	2000      	movs	r0, #0
c0de0046:	2100      	movs	r1, #0
c0de0048:	f44f 42dc 	mov.w	r2, #28160	@ 0x6e00
c0de004c:	e010      	b.n	c0de0070 <apdu_dispatcher+0x5a>
            return handler_encrypt_decrypt(cmd);
c0de004e:	f000 f8bd 	bl	c0de01cc <handler_encrypt_decrypt>
}
c0de0052:	b001      	add	sp, #4
c0de0054:	bdf0      	pop	{r4, r5, r6, r7, pc}
            if (cmd->p1 != 0 || cmd->p2 != 0) {
c0de0056:	7881      	ldrb	r1, [r0, #2]
c0de0058:	b909      	cbnz	r1, c0de005e <apdu_dispatcher+0x48>
c0de005a:	78c0      	ldrb	r0, [r0, #3]
c0de005c:	b160      	cbz	r0, c0de0078 <apdu_dispatcher+0x62>
c0de005e:	2000      	movs	r0, #0
c0de0060:	2100      	movs	r1, #0
c0de0062:	f646 2286 	movw	r2, #27270	@ 0x6a86
c0de0066:	e003      	b.n	c0de0070 <apdu_dispatcher+0x5a>
c0de0068:	2000      	movs	r0, #0
c0de006a:	2100      	movs	r1, #0
c0de006c:	f44f 42da 	mov.w	r2, #27904	@ 0x6d00
c0de0070:	f008 faae 	bl	c0de85d0 <io_send_response_buffers>
}
c0de0074:	b001      	add	sp, #4
c0de0076:	bdf0      	pop	{r4, r5, r6, r7, pc}
            return handler_get_app_name();
c0de0078:	f000 fd00 	bl	c0de0a7c <handler_get_app_name>
}
c0de007c:	b001      	add	sp, #4
c0de007e:	bdf0      	pop	{r4, r5, r6, r7, pc}
    LEDGER_ASSERT(cmd != NULL, "NULL cmd");
c0de0080:	4674      	mov	r4, lr
c0de0082:	467d      	mov	r5, pc
c0de0084:	f24b 0021 	movw	r0, #45089	@ 0xb021
c0de0088:	f2c0 0000 	movt	r0, #0
c0de008c:	4478      	add	r0, pc
c0de008e:	f008 fdcd 	bl	c0de8c2c <mcu_usb_printf>
c0de0092:	f24b 365a 	movw	r6, #45914	@ 0xb35a
c0de0096:	f2c0 0600 	movt	r6, #0
c0de009a:	447e      	add	r6, pc
c0de009c:	4630      	mov	r0, r6
c0de009e:	f008 fdc5 	bl	c0de8c2c <mcu_usb_printf>
c0de00a2:	f24b 1033 	movw	r0, #45363	@ 0xb133
c0de00a6:	f2c0 0000 	movt	r0, #0
c0de00aa:	4478      	add	r0, pc
c0de00ac:	f008 fdbe 	bl	c0de8c2c <mcu_usb_printf>
c0de00b0:	f640 10b0 	movw	r0, #2480	@ 0x9b0
c0de00b4:	f2c0 0000 	movt	r0, #0
c0de00b8:	eb09 0700 	add.w	r7, r9, r0
c0de00bc:	4638      	mov	r0, r7
c0de00be:	4631      	mov	r1, r6
c0de00c0:	2209      	movs	r2, #9
c0de00c2:	f009 fe71 	bl	c0de9da8 <__aeabi_memcpy>
c0de00c6:	4638      	mov	r0, r7
c0de00c8:	f009 feda 	bl	c0de9e80 <strlen>
c0de00cc:	220a      	movs	r2, #10
c0de00ce:	1839      	adds	r1, r7, r0
c0de00d0:	543a      	strb	r2, [r7, r0]
c0de00d2:	2000      	movs	r0, #0
c0de00d4:	7048      	strb	r0, [r1, #1]
c0de00d6:	f24b 26be 	movw	r6, #45758	@ 0xb2be
c0de00da:	f2c0 0600 	movt	r6, #0
c0de00de:	447e      	add	r6, pc
c0de00e0:	4630      	mov	r0, r6
c0de00e2:	2121      	movs	r1, #33	@ 0x21
c0de00e4:	f008 fcaa 	bl	c0de8a3c <assert_print_file_info>
c0de00e8:	4630      	mov	r0, r6
c0de00ea:	2121      	movs	r1, #33	@ 0x21
c0de00ec:	f008 fc8a 	bl	c0de8a04 <assert_display_file_info>
c0de00f0:	4620      	mov	r0, r4
c0de00f2:	4629      	mov	r1, r5
c0de00f4:	f008 fc6c 	bl	c0de89d0 <assert_print_lr_and_pc>
c0de00f8:	4620      	mov	r0, r4
c0de00fa:	4629      	mov	r1, r5
c0de00fc:	f008 fc46 	bl	c0de898c <assert_display_lr_and_pc>
c0de0100:	f008 fcd2 	bl	c0de8aa8 <assert_display_exit>

c0de0104 <app_main>:
#include "menu.h"

/**
 * Handle APDU command received and send back APDU response using handlers.
 */
void app_main() {
c0de0104:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de0108:	b088      	sub	sp, #32
    // Length of APDU command received in G_io_apdu_buffer
    int input_len = 0;
    // Structured APDU command
    command_t cmd;

    io_init();
c0de010a:	f008 fa44 	bl	c0de8596 <io_init>
    ui_menu_main();
c0de010e:	f000 fce4 	bl	c0de0ada <ui_menu_main>

    for (;;) {
        // Receive command bytes in G_io_apdu_buffer
        if ((input_len = io_recv_command()) < 0) {
c0de0112:	f008 fa49 	bl	c0de85a8 <io_recv_command>
c0de0116:	2800      	cmp	r0, #0
c0de0118:	d44d      	bmi.n	c0de01b6 <app_main+0xb2>
c0de011a:	f64a 6ad5 	movw	sl, #44757	@ 0xaed5
c0de011e:	f2c0 0a00 	movt	sl, #0
c0de0122:	f64a 38bb 	movw	r8, #43963	@ 0xabbb
c0de0126:	f2c0 0800 	movt	r8, #0
c0de012a:	f64a 7ba0 	movw	fp, #44960	@ 0xafa0
c0de012e:	f240 067c 	movw	r6, #124	@ 0x7c
c0de0132:	f2c0 0b00 	movt	fp, #0
c0de0136:	4604      	mov	r4, r0
c0de0138:	f2c0 0600 	movt	r6, #0
c0de013c:	ad05      	add	r5, sp, #20
c0de013e:	44fa      	add	sl, pc
c0de0140:	44f8      	add	r8, pc
c0de0142:	44fb      	add	fp, pc
c0de0144:	e011      	b.n	c0de016a <app_main+0x66>
c0de0146:	bf00      	nop
            return;
        }

        // Parse APDU command from G_io_apdu_buffer
        if (!apdu_parser(&cmd, G_io_apdu_buffer, input_len)) {
            PRINTF("=> /!\\ BAD LENGTH: %.*H\n", input_len, G_io_apdu_buffer);
c0de0148:	eb09 0206 	add.w	r2, r9, r6
c0de014c:	4658      	mov	r0, fp
c0de014e:	4621      	mov	r1, r4
c0de0150:	f008 fd6c 	bl	c0de8c2c <mcu_usb_printf>
c0de0154:	2000      	movs	r0, #0
c0de0156:	2100      	movs	r1, #0
c0de0158:	f646 2287 	movw	r2, #27271	@ 0x6a87
c0de015c:	f008 fa38 	bl	c0de85d0 <io_send_response_buffers>
        if ((input_len = io_recv_command()) < 0) {
c0de0160:	f008 fa22 	bl	c0de85a8 <io_recv_command>
c0de0164:	4604      	mov	r4, r0
c0de0166:	2800      	cmp	r0, #0
c0de0168:	d42a      	bmi.n	c0de01c0 <app_main+0xbc>
        if (!apdu_parser(&cmd, G_io_apdu_buffer, input_len)) {
c0de016a:	eb09 0106 	add.w	r1, r9, r6
c0de016e:	4628      	mov	r0, r5
c0de0170:	4622      	mov	r2, r4
c0de0172:	f008 fae5 	bl	c0de8740 <apdu_parser>
c0de0176:	2800      	cmp	r0, #0
c0de0178:	d0e6      	beq.n	c0de0148 <app_main+0x44>

        PRINTF("=> CLA=%02X | INS=%02X | P1=%02X | P2=%02X | Lc=%02X | CData=%.*H\n",
               cmd.cla,
               cmd.ins,
               cmd.p1,
               cmd.p2,
c0de017a:	f89d 0017 	ldrb.w	r0, [sp, #23]
               cmd.lc,
c0de017e:	f89d 4018 	ldrb.w	r4, [sp, #24]
               cmd.cla,
c0de0182:	f89d 1014 	ldrb.w	r1, [sp, #20]
               cmd.ins,
c0de0186:	f89d 2015 	ldrb.w	r2, [sp, #21]
               cmd.p1,
c0de018a:	f89d 3016 	ldrb.w	r3, [sp, #22]
               cmd.lc,
               cmd.data);
c0de018e:	9f07      	ldr	r7, [sp, #28]
        PRINTF("=> CLA=%02X | INS=%02X | P1=%02X | P2=%02X | Lc=%02X | CData=%.*H\n",
c0de0190:	e9cd 0400 	strd	r0, r4, [sp]
c0de0194:	4650      	mov	r0, sl
c0de0196:	9402      	str	r4, [sp, #8]
c0de0198:	9703      	str	r7, [sp, #12]
c0de019a:	f008 fd47 	bl	c0de8c2c <mcu_usb_printf>

        // Dispatch structured APDU command to handler
        if (apdu_dispatcher(&cmd) < 0) {
c0de019e:	4628      	mov	r0, r5
c0de01a0:	f7ff ff39 	bl	c0de0016 <apdu_dispatcher>
c0de01a4:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
c0de01a8:	dcda      	bgt.n	c0de0160 <app_main+0x5c>
c0de01aa:	f64a 380f 	movw	r8, #43791	@ 0xab0f
c0de01ae:	f2c0 0800 	movt	r8, #0
c0de01b2:	44f8      	add	r8, pc
c0de01b4:	e004      	b.n	c0de01c0 <app_main+0xbc>
c0de01b6:	f64a 383d 	movw	r8, #43837	@ 0xab3d
c0de01ba:	f2c0 0800 	movt	r8, #0
c0de01be:	44f8      	add	r8, pc
c0de01c0:	4640      	mov	r0, r8
c0de01c2:	f008 fd33 	bl	c0de8c2c <mcu_usb_printf>
            PRINTF("=> apdu_dispatcher failure\n");
            return;
        }
    }
}
c0de01c6:	b008      	add	sp, #32
c0de01c8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de01cc <handler_encrypt_decrypt>:
    return io_send_response_pointer(G_io_apdu_buffer,
                                    direction == SESSION_ENCRYPT ? chunk_len + SECRETS_GCM_TAG_LEN : chunk_len,
                                    SWO_SUCCESS);
}

int handler_encrypt_decrypt(const command_t *cmd) {
c0de01cc:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de01d0:	b0cc      	sub	sp, #304	@ 0x130
c0de01d2:	4604      	mov	r4, r0
    if (cmd->p2 != 0) return io_send_sw(SWO_INCORRECT_P1_P2);
c0de01d4:	78c0      	ldrb	r0, [r0, #3]
c0de01d6:	b140      	cbz	r0, c0de01ea <handler_encrypt_decrypt+0x1e>
c0de01d8:	2000      	movs	r0, #0
c0de01da:	2100      	movs	r1, #0
c0de01dc:	f646 2286 	movw	r2, #27270	@ 0x6a86
c0de01e0:	f008 f9f6 	bl	c0de85d0 <io_send_response_buffers>
        case SECRETS_STAGE_FINAL:
            return final_chunk(cmd, cmd->ins == ENCRYPT ? SESSION_ENCRYPT : SESSION_DECRYPT);
        default:
            return io_send_sw(SWO_INCORRECT_P1_P2);
    }
}
c0de01e4:	b04c      	add	sp, #304	@ 0x130
c0de01e6:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
    switch (cmd->p1) {
c0de01ea:	78a0      	ldrb	r0, [r4, #2]
c0de01ec:	2802      	cmp	r0, #2
c0de01ee:	f000 8082 	beq.w	c0de02f6 <handler_encrypt_decrypt+0x12a>
c0de01f2:	2801      	cmp	r0, #1
c0de01f4:	f000 809b 	beq.w	c0de032e <handler_encrypt_decrypt+0x162>
c0de01f8:	2800      	cmp	r0, #0
c0de01fa:	d1ed      	bne.n	c0de01d8 <handler_encrypt_decrypt+0xc>
            return cmd->ins == ENCRYPT ? encrypt_init(cmd) : decrypt_init(cmd);
c0de01fc:	7860      	ldrb	r0, [r4, #1]
c0de01fe:	2810      	cmp	r0, #16
c0de0200:	f040 80c8 	bne.w	c0de0394 <handler_encrypt_decrypt+0x1c8>
c0de0204:	2000      	movs	r0, #0
    uint8_t nonce[SECRETS_GCM_NONCE_LEN] = {0};
c0de0206:	9045      	str	r0, [sp, #276]	@ 0x114
c0de0208:	e9cd 0043 	strd	r0, r0, [sp, #268]	@ 0x10c
    uint8_t key[SECRETS_AES_KEY_LEN] = {0};
c0de020c:	e9cd 0041 	strd	r0, r0, [sp, #260]	@ 0x104
c0de0210:	e9cd 003f 	strd	r0, r0, [sp, #252]	@ 0xfc
c0de0214:	e9cd 003d 	strd	r0, r0, [sp, #244]	@ 0xf4
c0de0218:	e9cd 003b 	strd	r0, r0, [sp, #236]	@ 0xec
c0de021c:	a801      	add	r0, sp, #4
    uint8_t tlvs_copy[SECRETS_MAX_METADATA_TLVS_WITHOUT_NONCE] = {0};
c0de021e:	21e5      	movs	r1, #229	@ 0xe5
c0de0220:	f009 fdcc 	bl	c0de9dbc <__aeabi_memclr>
    explicit_bzero(&G_session, sizeof(G_session));
c0de0224:	f240 0700 	movw	r7, #0
c0de0228:	f2c0 0700 	movt	r7, #0
c0de022c:	eb09 0007 	add.w	r0, r9, r7
c0de0230:	217c      	movs	r1, #124	@ 0x7c
c0de0232:	f009 fdd1 	bl	c0de9dd8 <explicit_bzero>
    if (cmd->lc < 2) return io_send_sw(SWO_WRONG_DATA_LENGTH);
c0de0236:	7921      	ldrb	r1, [r4, #4]
c0de0238:	2901      	cmp	r1, #1
c0de023a:	f240 810c 	bls.w	c0de0456 <handler_encrypt_decrypt+0x28a>
    tlvs_len = (uint16_t) ((cmd->data[0] << 8) | cmd->data[1]);
c0de023e:	68a0      	ldr	r0, [r4, #8]
    if (tlvs_len != cmd->lc - 2 || tlvs_len > SECRETS_MAX_METADATA_TLVS_WITHOUT_NONCE) {
c0de0240:	3902      	subs	r1, #2
    tlvs_len = (uint16_t) ((cmd->data[0] << 8) | cmd->data[1]);
c0de0242:	7802      	ldrb	r2, [r0, #0]
c0de0244:	7843      	ldrb	r3, [r0, #1]
c0de0246:	ea43 2402 	orr.w	r4, r3, r2, lsl #8
    if (tlvs_len != cmd->lc - 2 || tlvs_len > SECRETS_MAX_METADATA_TLVS_WITHOUT_NONCE) {
c0de024a:	428c      	cmp	r4, r1
c0de024c:	f040 8103 	bne.w	c0de0456 <handler_encrypt_decrypt+0x28a>
c0de0250:	2ce6      	cmp	r4, #230	@ 0xe6
c0de0252:	f080 8100 	bcs.w	c0de0456 <handler_encrypt_decrypt+0x28a>
c0de0256:	ad01      	add	r5, sp, #4
    tlvs = cmd->data + 2;
c0de0258:	1c81      	adds	r1, r0, #2
    memcpy(tlvs_copy, tlvs, tlvs_len);
c0de025a:	4628      	mov	r0, r5
c0de025c:	4622      	mov	r2, r4
c0de025e:	f009 fda3 	bl	c0de9da8 <__aeabi_memcpy>
c0de0262:	ae46      	add	r6, sp, #280	@ 0x118
    sw = validate_metadata_tlvs(tlvs, tlvs_len, false, true, &state);
c0de0264:	4628      	mov	r0, r5
c0de0266:	4621      	mov	r1, r4
c0de0268:	2200      	movs	r2, #0
c0de026a:	2301      	movs	r3, #1
c0de026c:	9600      	str	r6, [sp, #0]
c0de026e:	f000 f9fd 	bl	c0de066c <validate_metadata_tlvs>
    if (sw != SWO_SUCCESS) return io_send_sw(sw);
c0de0272:	f5b0 4f10 	cmp.w	r0, #36864	@ 0x9000
c0de0276:	f040 812b 	bne.w	c0de04d0 <handler_encrypt_decrypt+0x304>
c0de027a:	a843      	add	r0, sp, #268	@ 0x10c
    cx_rng_no_throw(nonce, sizeof(nonce));
c0de027c:	210c      	movs	r1, #12
c0de027e:	f008 fb78 	bl	c0de8972 <cx_rng_no_throw>
c0de0282:	a83b      	add	r0, sp, #236	@ 0xec
    if (derive_aes_key(key) != CX_OK) {
c0de0284:	f000 fb56 	bl	c0de0934 <derive_aes_key>
    memcpy(G_io_apdu_buffer, MAGIC, sizeof(MAGIC));
c0de0288:	f240 0a7c 	movw	sl, #124	@ 0x7c
c0de028c:	f2c0 0a00 	movt	sl, #0
c0de0290:	204c      	movs	r0, #76	@ 0x4c
c0de0292:	f809 000a 	strb.w	r0, [r9, sl]
c0de0296:	eb09 010a 	add.w	r1, r9, sl
c0de029a:	204e      	movs	r0, #78	@ 0x4e
c0de029c:	7148      	strb	r0, [r1, #5]
c0de029e:	205f      	movs	r0, #95	@ 0x5f
c0de02a0:	70c8      	strb	r0, [r1, #3]
c0de02a2:	2047      	movs	r0, #71	@ 0x47
c0de02a4:	7088      	strb	r0, [r1, #2]
c0de02a6:	2044      	movs	r0, #68	@ 0x44
c0de02a8:	2245      	movs	r2, #69	@ 0x45
c0de02aa:	7048      	strb	r0, [r1, #1]
    memcpy(G_io_apdu_buffer + out_len, tlvs, tlvs_len);
c0de02ac:	f101 000a 	add.w	r0, r1, #10
    memcpy(G_io_apdu_buffer, MAGIC, sizeof(MAGIC));
c0de02b0:	f801 2f04 	strb.w	r2, [r1, #4]!
c0de02b4:	2252      	movs	r2, #82	@ 0x52
c0de02b6:	70ca      	strb	r2, [r1, #3]
c0de02b8:	2243      	movs	r2, #67	@ 0x43
c0de02ba:	708a      	strb	r2, [r1, #2]
c0de02bc:	a901      	add	r1, sp, #4
    memcpy(G_io_apdu_buffer + out_len, tlvs, tlvs_len);
c0de02be:	4622      	mov	r2, r4
c0de02c0:	f009 fd72 	bl	c0de9da8 <__aeabi_memcpy>
        if (*offset + 3 > out_len) return false;
c0de02c4:	f1a4 00f3 	sub.w	r0, r4, #243	@ 0xf3
c0de02c8:	f510 7f80 	cmn.w	r0, #256	@ 0x100
    out_len += tlvs_len;
c0de02cc:	f104 060a 	add.w	r6, r4, #10
        if (*offset + 3 > out_len) return false;
c0de02d0:	d30a      	bcc.n	c0de02e8 <handler_encrypt_decrypt+0x11c>
        out[(*offset)++] = 0x82;
c0de02d2:	eb09 010a 	add.w	r1, r9, sl
c0de02d6:	2282      	movs	r2, #130	@ 0x82
c0de02d8:	558a      	strb	r2, [r1, r6]
c0de02da:	4421      	add	r1, r4
c0de02dc:	2201      	movs	r2, #1
        out[(*offset)++] = (uint8_t) (value >> 8);
c0de02de:	72ca      	strb	r2, [r1, #11]
        out[(*offset)++] = (uint8_t) value;
c0de02e0:	f104 060d 	add.w	r6, r4, #13
c0de02e4:	2203      	movs	r2, #3
c0de02e6:	730a      	strb	r2, [r1, #12]
    if (!append_der_u16(G_io_apdu_buffer, SECRETS_MAX_METADATA_HEADER, &out_len, SECRETS_TAG_NONCE) ||
c0de02e8:	f510 7f80 	cmn.w	r0, #256	@ 0x100
c0de02ec:	f080 8115 	bcs.w	c0de051a <handler_encrypt_decrypt+0x34e>
c0de02f0:	a83b      	add	r0, sp, #236	@ 0xec
        explicit_bzero(key, sizeof(key));
c0de02f2:	2120      	movs	r1, #32
c0de02f4:	e047      	b.n	c0de0386 <handler_encrypt_decrypt+0x1ba>
    if (G_session.direction != direction) return io_send_sw(SWO_INCORRECT_P1_P2);
c0de02f6:	f240 0700 	movw	r7, #0
            return final_chunk(cmd, cmd->ins == ENCRYPT ? SESSION_ENCRYPT : SESSION_DECRYPT);
c0de02fa:	7866      	ldrb	r6, [r4, #1]
    if (G_session.direction != direction) return io_send_sw(SWO_INCORRECT_P1_P2);
c0de02fc:	f2c0 0700 	movt	r7, #0
c0de0300:	2002      	movs	r0, #2
c0de0302:	f819 1007 	ldrb.w	r1, [r9, r7]
            return final_chunk(cmd, cmd->ins == ENCRYPT ? SESSION_ENCRYPT : SESSION_DECRYPT);
c0de0306:	2e10      	cmp	r6, #16
c0de0308:	bf08      	it	eq
c0de030a:	2001      	moveq	r0, #1
    if (G_session.direction != direction) return io_send_sw(SWO_INCORRECT_P1_P2);
c0de030c:	4281      	cmp	r1, r0
c0de030e:	f04f 0000 	mov.w	r0, #0
    uint8_t tag[SECRETS_GCM_TAG_LEN] = {0};
c0de0312:	e9cd 0003 	strd	r0, r0, [sp, #12]
c0de0316:	e9cd 0001 	strd	r0, r0, [sp, #4]
    if (G_session.direction != direction) return io_send_sw(SWO_INCORRECT_P1_P2);
c0de031a:	f47f af5d 	bne.w	c0de01d8 <handler_encrypt_decrypt+0xc>
c0de031e:	7920      	ldrb	r0, [r4, #4]
    if (direction == SESSION_ENCRYPT) {
c0de0320:	2e10      	cmp	r6, #16
c0de0322:	f040 808f 	bne.w	c0de0444 <handler_encrypt_decrypt+0x278>
        if (cmd->lc > SECRETS_MAX_CHUNK) return io_send_sw(SWO_WRONG_DATA_LENGTH);
c0de0326:	28f1      	cmp	r0, #241	@ 0xf1
c0de0328:	f0c0 808f 	bcc.w	c0de044a <handler_encrypt_decrypt+0x27e>
c0de032c:	e093      	b.n	c0de0456 <handler_encrypt_decrypt+0x28a>
            return update_chunk(cmd, cmd->ins == ENCRYPT ? SESSION_ENCRYPT : SESSION_DECRYPT);
c0de032e:	7860      	ldrb	r0, [r4, #1]
    if (G_session.direction != direction) return io_send_sw(SWO_INCORRECT_P1_P2);
c0de0330:	f240 0500 	movw	r5, #0
c0de0334:	f2c0 0500 	movt	r5, #0
            return update_chunk(cmd, cmd->ins == ENCRYPT ? SESSION_ENCRYPT : SESSION_DECRYPT);
c0de0338:	2810      	cmp	r0, #16
    if (G_session.direction != direction) return io_send_sw(SWO_INCORRECT_P1_P2);
c0de033a:	f819 0005 	ldrb.w	r0, [r9, r5]
c0de033e:	f04f 0102 	mov.w	r1, #2
            return update_chunk(cmd, cmd->ins == ENCRYPT ? SESSION_ENCRYPT : SESSION_DECRYPT);
c0de0342:	bf08      	it	eq
c0de0344:	2101      	moveq	r1, #1
    if (G_session.direction != direction) return io_send_sw(SWO_INCORRECT_P1_P2);
c0de0346:	4288      	cmp	r0, r1
c0de0348:	f47f af46 	bne.w	c0de01d8 <handler_encrypt_decrypt+0xc>
    if (cmd->lc == 0 || cmd->lc > SECRETS_MAX_CHUNK) return io_send_sw(SWO_WRONG_DATA_LENGTH);
c0de034c:	7923      	ldrb	r3, [r4, #4]
c0de034e:	f103 000f 	add.w	r0, r3, #15
c0de0352:	b2c0      	uxtb	r0, r0
c0de0354:	280f      	cmp	r0, #15
c0de0356:	d97e      	bls.n	c0de0456 <handler_encrypt_decrypt+0x28a>
    if (G_session.bytes_done > UINT32_MAX - cmd->lc) return io_send_sw(SWO_WRONG_DATA_LENGTH);
c0de0358:	eb09 0005 	add.w	r0, r9, r5
c0de035c:	6f80      	ldr	r0, [r0, #120]	@ 0x78
c0de035e:	18c0      	adds	r0, r0, r3
c0de0360:	d279      	bcs.n	c0de0456 <handler_encrypt_decrypt+0x28a>
    if (cx_aes_gcm_update(&G_session.gcm, cmd->data, G_io_apdu_buffer, cmd->lc) != CX_OK) {
c0de0362:	f240 067c 	movw	r6, #124	@ 0x7c
c0de0366:	68a1      	ldr	r1, [r4, #8]
c0de0368:	f2c0 0600 	movt	r6, #0
c0de036c:	eb09 0005 	add.w	r0, r9, r5
c0de0370:	eb09 0206 	add.w	r2, r9, r6
c0de0374:	3004      	adds	r0, #4
c0de0376:	f008 faf2 	bl	c0de895e <cx_aes_gcm_update>
c0de037a:	2800      	cmp	r0, #0
c0de037c:	f000 80aa 	beq.w	c0de04d4 <handler_encrypt_decrypt+0x308>
    explicit_bzero(&G_session, sizeof(G_session));
c0de0380:	eb09 0005 	add.w	r0, r9, r5
c0de0384:	217c      	movs	r1, #124	@ 0x7c
c0de0386:	f009 fd27 	bl	c0de9dd8 <explicit_bzero>
c0de038a:	2000      	movs	r0, #0
c0de038c:	2100      	movs	r1, #0
c0de038e:	f44f 42de 	mov.w	r2, #28416	@ 0x6f00
c0de0392:	e725      	b.n	c0de01e0 <handler_encrypt_decrypt+0x14>
c0de0394:	f240 0b00 	movw	fp, #0
c0de0398:	2000      	movs	r0, #0
c0de039a:	f2c0 0b00 	movt	fp, #0
    uint8_t key[SECRETS_AES_KEY_LEN] = {0};
c0de039e:	e9cd 0007 	strd	r0, r0, [sp, #28]
c0de03a2:	e9cd 0005 	strd	r0, r0, [sp, #20]
c0de03a6:	e9cd 0003 	strd	r0, r0, [sp, #12]
c0de03aa:	e9cd 0001 	strd	r0, r0, [sp, #4]
    explicit_bzero(&G_session, sizeof(G_session));
c0de03ae:	eb09 000b 	add.w	r0, r9, fp
c0de03b2:	217c      	movs	r1, #124	@ 0x7c
c0de03b4:	f009 fd10 	bl	c0de9dd8 <explicit_bzero>
    if (cmd->lc < 1) return io_send_sw(SWO_WRONG_DATA_LENGTH);
c0de03b8:	7920      	ldrb	r0, [r4, #4]
c0de03ba:	2800      	cmp	r0, #0
c0de03bc:	d050      	beq.n	c0de0460 <handler_encrypt_decrypt+0x294>
    header_len = cmd->data[0];
c0de03be:	68a7      	ldr	r7, [r4, #8]
c0de03c0:	f646 2687 	movw	r6, #27271	@ 0x6a87
c0de03c4:	783c      	ldrb	r4, [r7, #0]
    if (header_len != cmd->lc - 1 || header_len > SECRETS_MAX_METADATA_HEADER || header_len < sizeof(MAGIC) + 2) {
c0de03c6:	2c0a      	cmp	r4, #10
c0de03c8:	d34f      	bcc.n	c0de046a <handler_encrypt_decrypt+0x29e>
c0de03ca:	3801      	subs	r0, #1
c0de03cc:	42a0      	cmp	r0, r4
c0de03ce:	d14c      	bne.n	c0de046a <handler_encrypt_decrypt+0x29e>
    if (memcmp(header, MAGIC, sizeof(MAGIC)) != 0) return io_send_sw(SW_INVALID_DATA);
c0de03d0:	f24b 0123 	movw	r1, #45091	@ 0xb023
    header = cmd->data + 1;
c0de03d4:	1c7d      	adds	r5, r7, #1
    if (memcmp(header, MAGIC, sizeof(MAGIC)) != 0) return io_send_sw(SW_INVALID_DATA);
c0de03d6:	f2c0 0100 	movt	r1, #0
c0de03da:	4479      	add	r1, pc
c0de03dc:	4628      	mov	r0, r5
c0de03de:	2208      	movs	r2, #8
c0de03e0:	f009 fd00 	bl	c0de9de4 <memcmp>
c0de03e4:	2800      	cmp	r0, #0
c0de03e6:	d13e      	bne.n	c0de0466 <handler_encrypt_decrypt+0x29a>
    tlvs_len = (uint16_t) ((header[sizeof(MAGIC)] << 8) | header[sizeof(MAGIC) + 1]);
c0de03e8:	7a78      	ldrb	r0, [r7, #9]
c0de03ea:	7ab9      	ldrb	r1, [r7, #10]
c0de03ec:	ea41 2100 	orr.w	r1, r1, r0, lsl #8
    if (tlvs_len != header_len - sizeof(MAGIC) - 2) return io_send_sw(SW_INVALID_DATA);
c0de03f0:	f1a4 000a 	sub.w	r0, r4, #10
c0de03f4:	4281      	cmp	r1, r0
c0de03f6:	d136      	bne.n	c0de0466 <handler_encrypt_decrypt+0x29a>
    tlvs = header + sizeof(MAGIC) + 2;
c0de03f8:	f107 000b 	add.w	r0, r7, #11
c0de03fc:	af3b      	add	r7, sp, #236	@ 0xec
    sw = validate_metadata_tlvs(tlvs, tlvs_len, true, false, &state);
c0de03fe:	2201      	movs	r2, #1
c0de0400:	2300      	movs	r3, #0
c0de0402:	9700      	str	r7, [sp, #0]
c0de0404:	f000 f932 	bl	c0de066c <validate_metadata_tlvs>
c0de0408:	4606      	mov	r6, r0
    if (sw != SWO_SUCCESS) return io_send_sw(sw);
c0de040a:	f5b0 4f10 	cmp.w	r0, #36864	@ 0x9000
c0de040e:	d12c      	bne.n	c0de046a <handler_encrypt_decrypt+0x29e>
c0de0410:	f10d 0a04 	add.w	sl, sp, #4
    if (derive_aes_key(key) != CX_OK) {
c0de0414:	4650      	mov	r0, sl
c0de0416:	f000 fa8d 	bl	c0de0934 <derive_aes_key>
    cx_aes_gcm_init(&G_session.gcm);
c0de041a:	eb09 000b 	add.w	r0, r9, fp
c0de041e:	1d06      	adds	r6, r0, #4
    sw = start_gcm_session(SESSION_DECRYPT, key, state.nonce_ptr, header, header_len);
c0de0420:	f8dd 80f4 	ldr.w	r8, [sp, #244]	@ 0xf4
    cx_aes_gcm_init(&G_session.gcm);
c0de0424:	4630      	mov	r0, r6
c0de0426:	f008 fa86 	bl	c0de8936 <cx_aes_gcm_init>
    err = cx_aes_gcm_set_key(&G_session.gcm, key, SECRETS_AES_KEY_LEN);
c0de042a:	4630      	mov	r0, r6
c0de042c:	4651      	mov	r1, sl
c0de042e:	2220      	movs	r2, #32
c0de0430:	f008 fa86 	bl	c0de8940 <cx_aes_gcm_set_key>
    if (err != CX_OK) return SW_EXECUTION_ERROR;
c0de0434:	2800      	cmp	r0, #0
c0de0436:	f000 80e6 	beq.w	c0de0606 <handler_encrypt_decrypt+0x43a>
c0de043a:	f44f 46de 	mov.w	r6, #28416	@ 0x6f00
c0de043e:	f04f 0800 	mov.w	r8, #0
c0de0442:	e0f7      	b.n	c0de0634 <handler_encrypt_decrypt+0x468>
        if (cmd->lc < SECRETS_GCM_TAG_LEN ||
c0de0444:	280f      	cmp	r0, #15
c0de0446:	d906      	bls.n	c0de0456 <handler_encrypt_decrypt+0x28a>
        chunk_len = (uint8_t) (cmd->lc - SECRETS_GCM_TAG_LEN);
c0de0448:	3810      	subs	r0, #16
    if (G_session.bytes_done > UINT32_MAX - chunk_len) return io_send_sw(SWO_WRONG_DATA_LENGTH);
c0de044a:	eb09 0107 	add.w	r1, r9, r7
c0de044e:	6f89      	ldr	r1, [r1, #120]	@ 0x78
c0de0450:	b2c5      	uxtb	r5, r0
c0de0452:	1949      	adds	r1, r1, r5
c0de0454:	d30d      	bcc.n	c0de0472 <handler_encrypt_decrypt+0x2a6>
c0de0456:	2000      	movs	r0, #0
c0de0458:	2100      	movs	r1, #0
c0de045a:	f646 2287 	movw	r2, #27271	@ 0x6a87
c0de045e:	e6bf      	b.n	c0de01e0 <handler_encrypt_decrypt+0x14>
c0de0460:	f646 2687 	movw	r6, #27271	@ 0x6a87
c0de0464:	e001      	b.n	c0de046a <handler_encrypt_decrypt+0x29e>
c0de0466:	f44f 46d5 	mov.w	r6, #27264	@ 0x6a80
c0de046a:	2000      	movs	r0, #0
c0de046c:	2100      	movs	r1, #0
c0de046e:	4632      	mov	r2, r6
c0de0470:	e6b6      	b.n	c0de01e0 <handler_encrypt_decrypt+0x14>
    if (chunk_len > 0 && cx_aes_gcm_update(&G_session.gcm, cmd->data, G_io_apdu_buffer, chunk_len) != CX_OK) {
c0de0472:	0600      	lsls	r0, r0, #24
c0de0474:	d017      	beq.n	c0de04a6 <handler_encrypt_decrypt+0x2da>
c0de0476:	f240 007c 	movw	r0, #124	@ 0x7c
c0de047a:	f2c0 0000 	movt	r0, #0
c0de047e:	68a1      	ldr	r1, [r4, #8]
c0de0480:	eb09 0200 	add.w	r2, r9, r0
c0de0484:	eb09 0007 	add.w	r0, r9, r7
c0de0488:	3004      	adds	r0, #4
c0de048a:	462b      	mov	r3, r5
c0de048c:	f008 fa67 	bl	c0de895e <cx_aes_gcm_update>
c0de0490:	b148      	cbz	r0, c0de04a6 <handler_encrypt_decrypt+0x2da>
    explicit_bzero(&G_session, sizeof(G_session));
c0de0492:	eb09 0007 	add.w	r0, r9, r7
c0de0496:	217c      	movs	r1, #124	@ 0x7c
c0de0498:	f009 fc9e 	bl	c0de9dd8 <explicit_bzero>
c0de049c:	2000      	movs	r0, #0
c0de049e:	2100      	movs	r1, #0
c0de04a0:	f44f 42c8 	mov.w	r2, #25600	@ 0x6400
c0de04a4:	e69c      	b.n	c0de01e0 <handler_encrypt_decrypt+0x14>
    G_session.bytes_done += chunk_len;
c0de04a6:	eb09 0007 	add.w	r0, r9, r7
c0de04aa:	6f81      	ldr	r1, [r0, #120]	@ 0x78
    if (direction == SESSION_ENCRYPT) {
c0de04ac:	2e10      	cmp	r6, #16
    G_session.bytes_done += chunk_len;
c0de04ae:	4429      	add	r1, r5
c0de04b0:	6781      	str	r1, [r0, #120]	@ 0x78
    if (direction == SESSION_ENCRYPT) {
c0de04b2:	d11d      	bne.n	c0de04f0 <handler_encrypt_decrypt+0x324>
        if (cx_aes_gcm_finish(&G_session.gcm, tag, sizeof(tag)) != CX_OK) {
c0de04b4:	eb09 0007 	add.w	r0, r9, r7
c0de04b8:	3004      	adds	r0, #4
c0de04ba:	a901      	add	r1, sp, #4
c0de04bc:	2210      	movs	r2, #16
c0de04be:	f008 fa35 	bl	c0de892c <cx_aes_gcm_finish>
c0de04c2:	2800      	cmp	r0, #0
c0de04c4:	d067      	beq.n	c0de0596 <handler_encrypt_decrypt+0x3ca>
c0de04c6:	f44f 44de 	mov.w	r4, #28416	@ 0x6f00
c0de04ca:	f04f 0800 	mov.w	r8, #0
c0de04ce:	e070      	b.n	c0de05b2 <handler_encrypt_decrypt+0x3e6>
c0de04d0:	4602      	mov	r2, r0
c0de04d2:	e08c      	b.n	c0de05ee <handler_encrypt_decrypt+0x422>
    G_session.bytes_done += cmd->lc;
c0de04d4:	eb09 0105 	add.w	r1, r9, r5
c0de04d8:	7920      	ldrb	r0, [r4, #4]
c0de04da:	6f8a      	ldr	r2, [r1, #120]	@ 0x78
c0de04dc:	4402      	add	r2, r0
c0de04de:	678a      	str	r2, [r1, #120]	@ 0x78
        &(const buffer_t){.ptr = (uint8_t *) ptr, .size = size, .offset = 0}, 1, sw);
c0de04e0:	eb09 0106 	add.w	r1, r9, r6
c0de04e4:	e9cd 1001 	strd	r1, r0, [sp, #4]
c0de04e8:	2000      	movs	r0, #0
c0de04ea:	9003      	str	r0, [sp, #12]
c0de04ec:	a801      	add	r0, sp, #4
c0de04ee:	e079      	b.n	c0de05e4 <handler_encrypt_decrypt+0x418>
        if (cx_aes_gcm_check_tag(&G_session.gcm, cmd->data + chunk_len, SECRETS_GCM_TAG_LEN) != CX_OK) {
c0de04f0:	68a0      	ldr	r0, [r4, #8]
c0de04f2:	2210      	movs	r2, #16
c0de04f4:	1941      	adds	r1, r0, r5
c0de04f6:	eb09 0007 	add.w	r0, r9, r7
c0de04fa:	3004      	adds	r0, #4
c0de04fc:	f008 fa11 	bl	c0de8922 <cx_aes_gcm_check_tag>
c0de0500:	fab0 f180 	clz	r1, r0
c0de0504:	ea4f 1851 	mov.w	r8, r1, lsr #5
c0de0508:	f646 7401 	movw	r4, #28417	@ 0x6f01
c0de050c:	2800      	cmp	r0, #0
c0de050e:	bf04      	itt	eq
c0de0510:	f249 0400 	movweq	r4, #36864	@ 0x9000
c0de0514:	f6cf 74ff 	movteq	r4, #65535	@ 0xffff
c0de0518:	e04b      	b.n	c0de05b2 <handler_encrypt_decrypt+0x3e6>
        if (*offset + 1 > out_len) return false;
c0de051a:	1c70      	adds	r0, r6, #1
c0de051c:	28ff      	cmp	r0, #255	@ 0xff
c0de051e:	d804      	bhi.n	c0de052a <handler_encrypt_decrypt+0x35e>
        out[(*offset)++] = (uint8_t) value;
c0de0520:	eb09 010a 	add.w	r1, r9, sl
c0de0524:	220c      	movs	r2, #12
c0de0526:	558a      	strb	r2, [r1, r6]
c0de0528:	4606      	mov	r6, r0
        !append_der_u16(G_io_apdu_buffer, SECRETS_MAX_METADATA_HEADER, &out_len, SECRETS_GCM_NONCE_LEN) ||
c0de052a:	28ff      	cmp	r0, #255	@ 0xff
c0de052c:	f63f aee0 	bhi.w	c0de02f0 <handler_encrypt_decrypt+0x124>
c0de0530:	f1a6 00f4 	sub.w	r0, r6, #244	@ 0xf4
c0de0534:	f510 7f80 	cmn.w	r0, #256	@ 0x100
c0de0538:	f4ff aeda 	bcc.w	c0de02f0 <handler_encrypt_decrypt+0x124>
    memcpy(G_io_apdu_buffer + out_len, nonce, sizeof(nonce));
c0de053c:	eb09 050a 	add.w	r5, r9, sl
c0de0540:	f50d 7886 	add.w	r8, sp, #268	@ 0x10c
c0de0544:	19a8      	adds	r0, r5, r6
c0de0546:	4641      	mov	r1, r8
c0de0548:	220c      	movs	r2, #12
c0de054a:	f009 fc2d 	bl	c0de9da8 <__aeabi_memcpy>
    uint16_t full_tlvs_len = (uint16_t) (out_len - sizeof(MAGIC) - 2);
c0de054e:	1cb0      	adds	r0, r6, #2
    G_io_apdu_buffer[sizeof(MAGIC)] = (uint8_t) (full_tlvs_len >> 8);
c0de0550:	0a01      	lsrs	r1, r0, #8
c0de0552:	ac3b      	add	r4, sp, #236	@ 0xec
    out_len += sizeof(nonce);
c0de0554:	f106 0b0c 	add.w	fp, r6, #12
    G_io_apdu_buffer[sizeof(MAGIC)] = (uint8_t) (full_tlvs_len >> 8);
c0de0558:	7229      	strb	r1, [r5, #8]
    G_io_apdu_buffer[sizeof(MAGIC) + 1] = (uint8_t) full_tlvs_len;
c0de055a:	7268      	strb	r0, [r5, #9]
    sw = start_gcm_session(SESSION_ENCRYPT, key, nonce, G_io_apdu_buffer, out_len);
c0de055c:	2001      	movs	r0, #1
c0de055e:	4621      	mov	r1, r4
c0de0560:	4642      	mov	r2, r8
c0de0562:	462b      	mov	r3, r5
c0de0564:	f8cd b000 	str.w	fp, [sp]
c0de0568:	f000 fa4c 	bl	c0de0a04 <start_gcm_session>
c0de056c:	4605      	mov	r5, r0
    explicit_bzero(key, sizeof(key));
c0de056e:	4620      	mov	r0, r4
c0de0570:	2120      	movs	r1, #32
c0de0572:	f009 fc31 	bl	c0de9dd8 <explicit_bzero>
    explicit_bzero(nonce, sizeof(nonce));
c0de0576:	4640      	mov	r0, r8
c0de0578:	210c      	movs	r1, #12
c0de057a:	f009 fc2d 	bl	c0de9dd8 <explicit_bzero>
    if (sw != SWO_SUCCESS) {
c0de057e:	b2ac      	uxth	r4, r5
c0de0580:	f5b4 4f10 	cmp.w	r4, #36864	@ 0x9000
c0de0584:	d136      	bne.n	c0de05f4 <handler_encrypt_decrypt+0x428>
c0de0586:	eb09 000a 	add.w	r0, r9, sl
c0de058a:	e9cd 0b49 	strd	r0, fp, [sp, #292]	@ 0x124
c0de058e:	2000      	movs	r0, #0
c0de0590:	904b      	str	r0, [sp, #300]	@ 0x12c
c0de0592:	a849      	add	r0, sp, #292	@ 0x124
c0de0594:	e026      	b.n	c0de05e4 <handler_encrypt_decrypt+0x418>
            memcpy(G_io_apdu_buffer + chunk_len, tag, sizeof(tag));
c0de0596:	f240 007c 	movw	r0, #124	@ 0x7c
c0de059a:	f2c0 0000 	movt	r0, #0
c0de059e:	4448      	add	r0, r9
c0de05a0:	4428      	add	r0, r5
c0de05a2:	a901      	add	r1, sp, #4
c0de05a4:	2210      	movs	r2, #16
c0de05a6:	f009 fbff 	bl	c0de9da8 <__aeabi_memcpy>
c0de05aa:	f44f 4410 	mov.w	r4, #36864	@ 0x9000
c0de05ae:	f04f 0801 	mov.w	r8, #1
    explicit_bzero(&G_session, sizeof(G_session));
c0de05b2:	eb09 0007 	add.w	r0, r9, r7
c0de05b6:	217c      	movs	r1, #124	@ 0x7c
c0de05b8:	f009 fc0e 	bl	c0de9dd8 <explicit_bzero>
c0de05bc:	a801      	add	r0, sp, #4
    explicit_bzero(tag, sizeof(tag));
c0de05be:	2110      	movs	r1, #16
c0de05c0:	f009 fc0a 	bl	c0de9dd8 <explicit_bzero>
    if (sw != SWO_SUCCESS) return io_send_sw(sw);
c0de05c4:	f1b8 0f00 	cmp.w	r8, #0
c0de05c8:	d010      	beq.n	c0de05ec <handler_encrypt_decrypt+0x420>
c0de05ca:	f240 007c 	movw	r0, #124	@ 0x7c
c0de05ce:	f2c0 0000 	movt	r0, #0
c0de05d2:	4448      	add	r0, r9
                                    direction == SESSION_ENCRYPT ? chunk_len + SECRETS_GCM_TAG_LEN : chunk_len,
c0de05d4:	2e10      	cmp	r6, #16
c0de05d6:	bf08      	it	eq
c0de05d8:	3510      	addeq	r5, #16
c0de05da:	e9cd 053b 	strd	r0, r5, [sp, #236]	@ 0xec
c0de05de:	2000      	movs	r0, #0
c0de05e0:	903d      	str	r0, [sp, #244]	@ 0xf4
c0de05e2:	a83b      	add	r0, sp, #236	@ 0xec
c0de05e4:	2101      	movs	r1, #1
c0de05e6:	f44f 4210 	mov.w	r2, #36864	@ 0x9000
c0de05ea:	e5f9      	b.n	c0de01e0 <handler_encrypt_decrypt+0x14>
    return io_send_response_buffers(NULL, 0, sw);
c0de05ec:	b2a2      	uxth	r2, r4
c0de05ee:	2000      	movs	r0, #0
c0de05f0:	2100      	movs	r1, #0
c0de05f2:	e5f5      	b.n	c0de01e0 <handler_encrypt_decrypt+0x14>
    explicit_bzero(&G_session, sizeof(G_session));
c0de05f4:	eb09 0007 	add.w	r0, r9, r7
c0de05f8:	217c      	movs	r1, #124	@ 0x7c
c0de05fa:	f009 fbed 	bl	c0de9dd8 <explicit_bzero>
c0de05fe:	2000      	movs	r0, #0
c0de0600:	2100      	movs	r1, #0
c0de0602:	4622      	mov	r2, r4
c0de0604:	e5ec      	b.n	c0de01e0 <handler_encrypt_decrypt+0x14>
    err = cx_aes_gcm_start(&G_session.gcm, mode, nonce, SECRETS_GCM_NONCE_LEN);
c0de0606:	eb09 000b 	add.w	r0, r9, fp
c0de060a:	3004      	adds	r0, #4
c0de060c:	2100      	movs	r1, #0
c0de060e:	4642      	mov	r2, r8
c0de0610:	230c      	movs	r3, #12
c0de0612:	f04f 0800 	mov.w	r8, #0
c0de0616:	f008 f998 	bl	c0de894a <cx_aes_gcm_start>
    if (err != CX_OK) return SW_EXECUTION_ERROR;
c0de061a:	b948      	cbnz	r0, c0de0630 <handler_encrypt_decrypt+0x464>
    err = cx_aes_gcm_update_aad(&G_session.gcm, aad, aad_len);
c0de061c:	eb09 000b 	add.w	r0, r9, fp
c0de0620:	3004      	adds	r0, #4
c0de0622:	4629      	mov	r1, r5
c0de0624:	4622      	mov	r2, r4
c0de0626:	f008 f995 	bl	c0de8954 <cx_aes_gcm_update_aad>
c0de062a:	f04f 0800 	mov.w	r8, #0
    if (err != CX_OK) return SW_EXECUTION_ERROR;
c0de062e:	b188      	cbz	r0, c0de0654 <handler_encrypt_decrypt+0x488>
c0de0630:	f44f 46de 	mov.w	r6, #28416	@ 0x6f00
c0de0634:	a801      	add	r0, sp, #4
    explicit_bzero(key, sizeof(key));
c0de0636:	2120      	movs	r1, #32
c0de0638:	f009 fbce 	bl	c0de9dd8 <explicit_bzero>
    if (sw != SWO_SUCCESS) {
c0de063c:	f1b8 0f00 	cmp.w	r8, #0
c0de0640:	d002      	beq.n	c0de0648 <handler_encrypt_decrypt+0x47c>
c0de0642:	f44f 4610 	mov.w	r6, #36864	@ 0x9000
c0de0646:	e710      	b.n	c0de046a <handler_encrypt_decrypt+0x29e>
    explicit_bzero(&G_session, sizeof(G_session));
c0de0648:	eb09 000b 	add.w	r0, r9, fp
c0de064c:	217c      	movs	r1, #124	@ 0x7c
c0de064e:	f009 fbc3 	bl	c0de9dd8 <explicit_bzero>
c0de0652:	e70a      	b.n	c0de046a <handler_encrypt_decrypt+0x29e>
c0de0654:	2002      	movs	r0, #2
    G_session.direction = direction;
c0de0656:	f809 000b 	strb.w	r0, [r9, fp]
c0de065a:	eb09 000b 	add.w	r0, r9, fp
    G_session.bytes_done = 0;
c0de065e:	f8c0 8078 	str.w	r8, [r0, #120]	@ 0x78
c0de0662:	f44f 4610 	mov.w	r6, #36864	@ 0x9000
c0de0666:	f04f 0801 	mov.w	r8, #1
c0de066a:	e7e3      	b.n	c0de0634 <handler_encrypt_decrypt+0x468>

c0de066c <validate_metadata_tlvs>:
                                       metadata_state_t *state) {
c0de066c:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de0670:	b084      	sub	sp, #16
c0de0672:	9d0c      	ldr	r5, [sp, #48]	@ 0x30
c0de0674:	9302      	str	r3, [sp, #8]
c0de0676:	9200      	str	r2, [sp, #0]
c0de0678:	2200      	movs	r2, #0
    while (offset < tlvs_len) {
c0de067a:	1e43      	subs	r3, r0, #1
c0de067c:	f04f 0c00 	mov.w	ip, #0
c0de0680:	2400      	movs	r4, #0
c0de0682:	2700      	movs	r7, #0
    memset(state, 0, sizeof(*state));
c0de0684:	e9c5 2200 	strd	r2, r2, [r5]
c0de0688:	60aa      	str	r2, [r5, #8]
c0de068a:	9303      	str	r3, [sp, #12]
    while (offset < tlvs_len) {
c0de068c:	428a      	cmp	r2, r1
c0de068e:	f080 8138 	bcs.w	c0de0902 <validate_metadata_tlvs+0x296>
    uint8_t first = data[(*offset)++];
c0de0692:	5683      	ldrsb	r3, [r0, r2]
c0de0694:	f102 0b01 	add.w	fp, r2, #1
    if ((first & 0x80) == 0) {
c0de0698:	2b00      	cmp	r3, #0
c0de069a:	d405      	bmi.n	c0de06a8 <validate_metadata_tlvs+0x3c>
        *value = first;
c0de069c:	fa5f fc83 	uxtb.w	ip, r3
c0de06a0:	2201      	movs	r2, #1
c0de06a2:	bbba      	cbnz	r2, c0de0714 <validate_metadata_tlvs+0xa8>
c0de06a4:	e140      	b.n	c0de0928 <validate_metadata_tlvs+0x2bc>
c0de06a6:	bf00      	nop
    uint8_t n = first & 0x7F;
c0de06a8:	f003 037f 	and.w	r3, r3, #127	@ 0x7f
c0de06ac:	46b0      	mov	r8, r6
    if ((n == 0) || (n > 2) || (*offset + n > len)) {
c0de06ae:	1ede      	subs	r6, r3, #3
c0de06b0:	b2f6      	uxtb	r6, r6
c0de06b2:	2efe      	cmp	r6, #254	@ 0xfe
c0de06b4:	d303      	bcc.n	c0de06be <validate_metadata_tlvs+0x52>
c0de06b6:	eb0b 0603 	add.w	r6, fp, r3
c0de06ba:	428e      	cmp	r6, r1
c0de06bc:	d901      	bls.n	c0de06c2 <validate_metadata_tlvs+0x56>
c0de06be:	2200      	movs	r2, #0
c0de06c0:	e024      	b.n	c0de070c <validate_metadata_tlvs+0xa0>
c0de06c2:	46a2      	mov	sl, r4
    for (uint8_t i = 0; i < n; i++) {
c0de06c4:	b1bb      	cbz	r3, c0de06f6 <validate_metadata_tlvs+0x8a>
c0de06c6:	9c03      	ldr	r4, [sp, #12]
c0de06c8:	1e5e      	subs	r6, r3, #1
c0de06ca:	fa5f fe86 	uxtb.w	lr, r6
c0de06ce:	18a6      	adds	r6, r4, r2
c0de06d0:	2500      	movs	r5, #0
c0de06d2:	2400      	movs	r4, #0
c0de06d4:	9701      	str	r7, [sp, #4]
c0de06d6:	bf00      	nop
        out = (uint16_t) ((out << 8) | data[(*offset)++]);
c0de06d8:	78b7      	ldrb	r7, [r6, #2]
    for (uint8_t i = 0; i < n; i++) {
c0de06da:	3501      	adds	r5, #1
        out = (uint16_t) ((out << 8) | data[(*offset)++]);
c0de06dc:	ea47 2404 	orr.w	r4, r7, r4, lsl #8
    for (uint8_t i = 0; i < n; i++) {
c0de06e0:	b2ef      	uxtb	r7, r5
c0de06e2:	429f      	cmp	r7, r3
c0de06e4:	f106 0601 	add.w	r6, r6, #1
c0de06e8:	d3f6      	bcc.n	c0de06d8 <validate_metadata_tlvs+0x6c>
c0de06ea:	4472      	add	r2, lr
c0de06ec:	9d0c      	ldr	r5, [sp, #48]	@ 0x30
c0de06ee:	9f01      	ldr	r7, [sp, #4]
c0de06f0:	f102 0b02 	add.w	fp, r2, #2
c0de06f4:	e000      	b.n	c0de06f8 <validate_metadata_tlvs+0x8c>
c0de06f6:	2400      	movs	r4, #0
    if (out < 0x80) {
c0de06f8:	b2a3      	uxth	r3, r4
c0de06fa:	2b7f      	cmp	r3, #127	@ 0x7f
c0de06fc:	f04f 0200 	mov.w	r2, #0
c0de0700:	bf88      	it	hi
c0de0702:	2201      	movhi	r2, #1
c0de0704:	2b80      	cmp	r3, #128	@ 0x80
c0de0706:	bf28      	it	cs
c0de0708:	46a4      	movcs	ip, r4
c0de070a:	4654      	mov	r4, sl
c0de070c:	4646      	mov	r6, r8
        if (!read_der_u16(tlvs, tlvs_len, &offset, &tag) ||
c0de070e:	2a00      	cmp	r2, #0
c0de0710:	f000 810a 	beq.w	c0de0928 <validate_metadata_tlvs+0x2bc>
    if (*offset >= len) {
c0de0714:	458b      	cmp	fp, r1
c0de0716:	d20b      	bcs.n	c0de0730 <validate_metadata_tlvs+0xc4>
    uint8_t first = data[(*offset)++];
c0de0718:	f910 300b 	ldrsb.w	r3, [r0, fp]
c0de071c:	f10b 0201 	add.w	r2, fp, #1
    if ((first & 0x80) == 0) {
c0de0720:	2b00      	cmp	r3, #0
c0de0722:	d408      	bmi.n	c0de0736 <validate_metadata_tlvs+0xca>
        *value = first;
c0de0724:	b2dc      	uxtb	r4, r3
c0de0726:	2301      	movs	r3, #1
c0de0728:	4693      	mov	fp, r2
c0de072a:	bbdb      	cbnz	r3, c0de07a4 <validate_metadata_tlvs+0x138>
c0de072c:	e0fc      	b.n	c0de0928 <validate_metadata_tlvs+0x2bc>
c0de072e:	bf00      	nop
c0de0730:	2300      	movs	r3, #0
c0de0732:	bbbb      	cbnz	r3, c0de07a4 <validate_metadata_tlvs+0x138>
c0de0734:	e0f8      	b.n	c0de0928 <validate_metadata_tlvs+0x2bc>
    uint8_t n = first & 0x7F;
c0de0736:	f003 037f 	and.w	r3, r3, #127	@ 0x7f
c0de073a:	46b8      	mov	r8, r7
    if ((n == 0) || (n > 2) || (*offset + n > len)) {
c0de073c:	1edf      	subs	r7, r3, #3
c0de073e:	b2ff      	uxtb	r7, r7
c0de0740:	2ffe      	cmp	r7, #254	@ 0xfe
c0de0742:	d302      	bcc.n	c0de074a <validate_metadata_tlvs+0xde>
c0de0744:	18d7      	adds	r7, r2, r3
c0de0746:	428f      	cmp	r7, r1
c0de0748:	d901      	bls.n	c0de074e <validate_metadata_tlvs+0xe2>
c0de074a:	2300      	movs	r3, #0
c0de074c:	e024      	b.n	c0de0798 <validate_metadata_tlvs+0x12c>
    for (uint8_t i = 0; i < n; i++) {
c0de074e:	b1bb      	cbz	r3, c0de0780 <validate_metadata_tlvs+0x114>
c0de0750:	46a2      	mov	sl, r4
c0de0752:	9c03      	ldr	r4, [sp, #12]
c0de0754:	1e5a      	subs	r2, r3, #1
c0de0756:	9601      	str	r6, [sp, #4]
c0de0758:	46ae      	mov	lr, r5
c0de075a:	b2d2      	uxtb	r2, r2
c0de075c:	eb04 060b 	add.w	r6, r4, fp
c0de0760:	2500      	movs	r5, #0
c0de0762:	2400      	movs	r4, #0
        out = (uint16_t) ((out << 8) | data[(*offset)++]);
c0de0764:	78b7      	ldrb	r7, [r6, #2]
    for (uint8_t i = 0; i < n; i++) {
c0de0766:	3501      	adds	r5, #1
        out = (uint16_t) ((out << 8) | data[(*offset)++]);
c0de0768:	ea47 2404 	orr.w	r4, r7, r4, lsl #8
    for (uint8_t i = 0; i < n; i++) {
c0de076c:	b2ef      	uxtb	r7, r5
c0de076e:	429f      	cmp	r7, r3
c0de0770:	f106 0601 	add.w	r6, r6, #1
c0de0774:	d3f6      	bcc.n	c0de0764 <validate_metadata_tlvs+0xf8>
c0de0776:	445a      	add	r2, fp
c0de0778:	9e01      	ldr	r6, [sp, #4]
c0de077a:	3202      	adds	r2, #2
c0de077c:	4675      	mov	r5, lr
c0de077e:	e001      	b.n	c0de0784 <validate_metadata_tlvs+0x118>
c0de0780:	46a2      	mov	sl, r4
c0de0782:	2400      	movs	r4, #0
    if (out < 0x80) {
c0de0784:	b2a7      	uxth	r7, r4
c0de0786:	2f7f      	cmp	r7, #127	@ 0x7f
c0de0788:	f04f 0300 	mov.w	r3, #0
c0de078c:	bf88      	it	hi
c0de078e:	2301      	movhi	r3, #1
c0de0790:	2f80      	cmp	r7, #128	@ 0x80
c0de0792:	bf28      	it	cs
c0de0794:	46a2      	movcs	sl, r4
c0de0796:	4654      	mov	r4, sl
c0de0798:	4693      	mov	fp, r2
c0de079a:	4647      	mov	r7, r8
            !read_der_u16(tlvs, tlvs_len, &offset, &length) ||
c0de079c:	2b00      	cmp	r3, #0
c0de079e:	f000 80c3 	beq.w	c0de0928 <validate_metadata_tlvs+0x2bc>
c0de07a2:	bf00      	nop
            offset + length > tlvs_len) {
c0de07a4:	fa1f fe84 	uxth.w	lr, r4
c0de07a8:	eb0b 080e 	add.w	r8, fp, lr
        if (!read_der_u16(tlvs, tlvs_len, &offset, &tag) ||
c0de07ac:	4588      	cmp	r8, r1
c0de07ae:	f200 80bb 	bhi.w	c0de0928 <validate_metadata_tlvs+0x2bc>
        if (index == 0 && tag != SECRETS_TAG_STRUCTURE_TYPE) return SW_INVALID_DATA;
c0de07b2:	063a      	lsls	r2, r7, #24
c0de07b4:	d103      	bne.n	c0de07be <validate_metadata_tlvs+0x152>
c0de07b6:	fa1f f28c 	uxth.w	r2, ip
c0de07ba:	2a01      	cmp	r2, #1
c0de07bc:	d106      	bne.n	c0de07cc <validate_metadata_tlvs+0x160>
        if (index == 1 && tag != SECRETS_TAG_VERSION) return SW_INVALID_DATA;
c0de07be:	b2fa      	uxtb	r2, r7
c0de07c0:	2a01      	cmp	r2, #1
c0de07c2:	d10d      	bne.n	c0de07e0 <validate_metadata_tlvs+0x174>
c0de07c4:	fa1f f28c 	uxth.w	r2, ip
c0de07c8:	2a02      	cmp	r2, #2
c0de07ca:	d009      	beq.n	c0de07e0 <validate_metadata_tlvs+0x174>
c0de07cc:	f44f 46d5 	mov.w	r6, #27264	@ 0x6a80
c0de07d0:	f04f 0a00 	mov.w	sl, #0
c0de07d4:	f1ba 0f00 	cmp.w	sl, #0
c0de07d8:	465a      	mov	r2, fp
c0de07da:	f47f af57 	bne.w	c0de068c <validate_metadata_tlvs+0x20>
c0de07de:	e0a5      	b.n	c0de092c <validate_metadata_tlvs+0x2c0>
        switch (tag) {
c0de07e0:	fa1f f38c 	uxth.w	r3, ip
c0de07e4:	2b25      	cmp	r3, #37	@ 0x25
c0de07e6:	eb00 020b 	add.w	r2, r0, fp
c0de07ea:	dd18      	ble.n	c0de081e <validate_metadata_tlvs+0x1b2>
c0de07ec:	f5b3 7f81 	cmp.w	r3, #258	@ 0x102
c0de07f0:	da28      	bge.n	c0de0844 <validate_metadata_tlvs+0x1d8>
c0de07f2:	2b26      	cmp	r3, #38	@ 0x26
c0de07f4:	9401      	str	r4, [sp, #4]
c0de07f6:	d03d      	beq.n	c0de0874 <validate_metadata_tlvs+0x208>
c0de07f8:	f240 1401 	movw	r4, #257	@ 0x101
c0de07fc:	42a3      	cmp	r3, r4
c0de07fe:	9c01      	ldr	r4, [sp, #4]
c0de0800:	d170      	bne.n	c0de08e4 <validate_metadata_tlvs+0x278>
                if (state->cipher_suite || length != 1) return SW_INVALID_DATA;
c0de0802:	792b      	ldrb	r3, [r5, #4]
c0de0804:	f04f 0a00 	mov.w	sl, #0
c0de0808:	2b00      	cmp	r3, #0
c0de080a:	d177      	bne.n	c0de08fc <validate_metadata_tlvs+0x290>
c0de080c:	f1be 0f01 	cmp.w	lr, #1
c0de0810:	d174      	bne.n	c0de08fc <validate_metadata_tlvs+0x290>
                if (value[0] != SECRETS_CIPHER_SUITE_AES_256_GCM_HKDF_SHA256) return SW_UNSUPPORTED_CIPHER_SUITE;
c0de0812:	7812      	ldrb	r2, [r2, #0]
c0de0814:	2a01      	cmp	r2, #1
c0de0816:	d16a      	bne.n	c0de08ee <validate_metadata_tlvs+0x282>
                state->cipher_suite = true;
c0de0818:	2201      	movs	r2, #1
c0de081a:	712a      	strb	r2, [r5, #4]
c0de081c:	e062      	b.n	c0de08e4 <validate_metadata_tlvs+0x278>
        switch (tag) {
c0de081e:	2b01      	cmp	r3, #1
c0de0820:	d034      	beq.n	c0de088c <validate_metadata_tlvs+0x220>
c0de0822:	2b02      	cmp	r3, #2
c0de0824:	d040      	beq.n	c0de08a8 <validate_metadata_tlvs+0x23c>
c0de0826:	2b20      	cmp	r3, #32
c0de0828:	d15c      	bne.n	c0de08e4 <validate_metadata_tlvs+0x278>
                if (state->trusted_name || length == 0 || length > 64) return SW_INVALID_DATA;
c0de082a:	78aa      	ldrb	r2, [r5, #2]
c0de082c:	f04f 0a00 	mov.w	sl, #0
c0de0830:	2a00      	cmp	r2, #0
c0de0832:	d163      	bne.n	c0de08fc <validate_metadata_tlvs+0x290>
c0de0834:	0422      	lsls	r2, r4, #16
c0de0836:	d061      	beq.n	c0de08fc <validate_metadata_tlvs+0x290>
c0de0838:	f1be 0f40 	cmp.w	lr, #64	@ 0x40
c0de083c:	d85e      	bhi.n	c0de08fc <validate_metadata_tlvs+0x290>
                state->trusted_name = true;
c0de083e:	2201      	movs	r2, #1
c0de0840:	70aa      	strb	r2, [r5, #2]
c0de0842:	e04f      	b.n	c0de08e4 <validate_metadata_tlvs+0x278>
c0de0844:	9601      	str	r6, [sp, #4]
c0de0846:	4626      	mov	r6, r4
        switch (tag) {
c0de0848:	d03b      	beq.n	c0de08c2 <validate_metadata_tlvs+0x256>
c0de084a:	f240 1403 	movw	r4, #259	@ 0x103
c0de084e:	42a3      	cmp	r3, r4
c0de0850:	4634      	mov	r4, r6
c0de0852:	9e01      	ldr	r6, [sp, #4]
c0de0854:	d146      	bne.n	c0de08e4 <validate_metadata_tlvs+0x278>
                if (reject_nonce || state->nonce || length != SECRETS_GCM_NONCE_LEN) return SW_INVALID_DATA;
c0de0856:	9b02      	ldr	r3, [sp, #8]
c0de0858:	2b00      	cmp	r3, #0
c0de085a:	d1b7      	bne.n	c0de07cc <validate_metadata_tlvs+0x160>
c0de085c:	79ab      	ldrb	r3, [r5, #6]
c0de085e:	f04f 0a00 	mov.w	sl, #0
c0de0862:	2b00      	cmp	r3, #0
c0de0864:	d14a      	bne.n	c0de08fc <validate_metadata_tlvs+0x290>
c0de0866:	f1be 0f0c 	cmp.w	lr, #12
c0de086a:	d147      	bne.n	c0de08fc <validate_metadata_tlvs+0x290>
                state->nonce = true;
c0de086c:	2301      	movs	r3, #1
c0de086e:	71ab      	strb	r3, [r5, #6]
                state->nonce_ptr = value;
c0de0870:	60aa      	str	r2, [r5, #8]
c0de0872:	e037      	b.n	c0de08e4 <validate_metadata_tlvs+0x278>
                if (state->time || length != 4) return SW_INVALID_DATA;
c0de0874:	78ea      	ldrb	r2, [r5, #3]
c0de0876:	f04f 0a00 	mov.w	sl, #0
c0de087a:	2a00      	cmp	r2, #0
c0de087c:	bf08      	it	eq
c0de087e:	f1be 0f04 	cmpeq.w	lr, #4
c0de0882:	d02c      	beq.n	c0de08de <validate_metadata_tlvs+0x272>
c0de0884:	9c01      	ldr	r4, [sp, #4]
c0de0886:	f44f 46d5 	mov.w	r6, #27264	@ 0x6a80
c0de088a:	e7a3      	b.n	c0de07d4 <validate_metadata_tlvs+0x168>
                if (state->structure_type || length != 1 || value[0] != SECRETS_STRUCTURE_TYPE_FILE_METADATA) return SW_INVALID_DATA;
c0de088c:	782b      	ldrb	r3, [r5, #0]
c0de088e:	f04f 0a00 	mov.w	sl, #0
c0de0892:	bb9b      	cbnz	r3, c0de08fc <validate_metadata_tlvs+0x290>
c0de0894:	f1be 0f01 	cmp.w	lr, #1
c0de0898:	d130      	bne.n	c0de08fc <validate_metadata_tlvs+0x290>
c0de089a:	7812      	ldrb	r2, [r2, #0]
c0de089c:	2a34      	cmp	r2, #52	@ 0x34
c0de089e:	f47f af95 	bne.w	c0de07cc <validate_metadata_tlvs+0x160>
                state->structure_type = true;
c0de08a2:	2201      	movs	r2, #1
c0de08a4:	702a      	strb	r2, [r5, #0]
c0de08a6:	e01d      	b.n	c0de08e4 <validate_metadata_tlvs+0x278>
                if (state->version || length != 1) return SW_INVALID_DATA;
c0de08a8:	786b      	ldrb	r3, [r5, #1]
c0de08aa:	f04f 0a00 	mov.w	sl, #0
c0de08ae:	bb2b      	cbnz	r3, c0de08fc <validate_metadata_tlvs+0x290>
c0de08b0:	f1be 0f01 	cmp.w	lr, #1
c0de08b4:	d122      	bne.n	c0de08fc <validate_metadata_tlvs+0x290>
                if (value[0] != SECRETS_VERSION) return SW_UNSUPPORTED_VERSION;
c0de08b6:	7812      	ldrb	r2, [r2, #0]
c0de08b8:	2a01      	cmp	r2, #1
c0de08ba:	d11b      	bne.n	c0de08f4 <validate_metadata_tlvs+0x288>
                state->version = true;
c0de08bc:	2201      	movs	r2, #1
c0de08be:	706a      	strb	r2, [r5, #1]
c0de08c0:	e010      	b.n	c0de08e4 <validate_metadata_tlvs+0x278>
                if (state->mime_type || length == 0 || length > 64) return SW_INVALID_DATA;
c0de08c2:	796a      	ldrb	r2, [r5, #5]
c0de08c4:	f04f 0a00 	mov.w	sl, #0
c0de08c8:	b9ba      	cbnz	r2, c0de08fa <validate_metadata_tlvs+0x28e>
c0de08ca:	4634      	mov	r4, r6
c0de08cc:	0432      	lsls	r2, r6, #16
c0de08ce:	d015      	beq.n	c0de08fc <validate_metadata_tlvs+0x290>
c0de08d0:	f1be 0f40 	cmp.w	lr, #64	@ 0x40
c0de08d4:	d812      	bhi.n	c0de08fc <validate_metadata_tlvs+0x290>
                state->mime_type = true;
c0de08d6:	2201      	movs	r2, #1
c0de08d8:	9e01      	ldr	r6, [sp, #4]
c0de08da:	716a      	strb	r2, [r5, #5]
c0de08dc:	e002      	b.n	c0de08e4 <validate_metadata_tlvs+0x278>
                state->time = true;
c0de08de:	2201      	movs	r2, #1
c0de08e0:	9c01      	ldr	r4, [sp, #4]
c0de08e2:	70ea      	strb	r2, [r5, #3]
        index++;
c0de08e4:	3701      	adds	r7, #1
c0de08e6:	f04f 0a01 	mov.w	sl, #1
c0de08ea:	46c3      	mov	fp, r8
c0de08ec:	e772      	b.n	c0de07d4 <validate_metadata_tlvs+0x168>
c0de08ee:	f646 7603 	movw	r6, #28419	@ 0x6f03
c0de08f2:	e76d      	b.n	c0de07d0 <validate_metadata_tlvs+0x164>
c0de08f4:	f646 7602 	movw	r6, #28418	@ 0x6f02
c0de08f8:	e76a      	b.n	c0de07d0 <validate_metadata_tlvs+0x164>
c0de08fa:	4634      	mov	r4, r6
c0de08fc:	f44f 46d5 	mov.w	r6, #27264	@ 0x6a80
c0de0900:	e768      	b.n	c0de07d4 <validate_metadata_tlvs+0x168>
    if (!state->structure_type || !state->version || !state->trusted_name || !state->time ||
c0de0902:	7828      	ldrb	r0, [r5, #0]
c0de0904:	b180      	cbz	r0, c0de0928 <validate_metadata_tlvs+0x2bc>
c0de0906:	7868      	ldrb	r0, [r5, #1]
c0de0908:	b170      	cbz	r0, c0de0928 <validate_metadata_tlvs+0x2bc>
c0de090a:	78a8      	ldrb	r0, [r5, #2]
c0de090c:	b160      	cbz	r0, c0de0928 <validate_metadata_tlvs+0x2bc>
c0de090e:	78e8      	ldrb	r0, [r5, #3]
c0de0910:	b150      	cbz	r0, c0de0928 <validate_metadata_tlvs+0x2bc>
        !state->cipher_suite || !state->mime_type) {
c0de0912:	7928      	ldrb	r0, [r5, #4]
c0de0914:	b140      	cbz	r0, c0de0928 <validate_metadata_tlvs+0x2bc>
c0de0916:	7968      	ldrb	r0, [r5, #5]
    if (!state->structure_type || !state->version || !state->trusted_name || !state->time ||
c0de0918:	b130      	cbz	r0, c0de0928 <validate_metadata_tlvs+0x2bc>
    if (require_nonce && !state->nonce) {
c0de091a:	9800      	ldr	r0, [sp, #0]
c0de091c:	b108      	cbz	r0, c0de0922 <validate_metadata_tlvs+0x2b6>
c0de091e:	79a8      	ldrb	r0, [r5, #6]
c0de0920:	b110      	cbz	r0, c0de0928 <validate_metadata_tlvs+0x2bc>
c0de0922:	f44f 4610 	mov.w	r6, #36864	@ 0x9000
c0de0926:	e001      	b.n	c0de092c <validate_metadata_tlvs+0x2c0>
c0de0928:	f44f 46d5 	mov.w	r6, #27264	@ 0x6a80
}
c0de092c:	b2b0      	uxth	r0, r6
c0de092e:	b004      	add	sp, #16
c0de0930:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de0934 <derive_aes_key>:
static cx_err_t derive_aes_key(uint8_t key[static 32]) {
c0de0934:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de0938:	b0ac      	sub	sp, #176	@ 0xb0
c0de093a:	f10d 0b2c 	add.w	fp, sp, #44	@ 0x2c
c0de093e:	4682      	mov	sl, r0
    uint8_t private_key[64] = {0};
c0de0940:	4658      	mov	r0, fp
c0de0942:	2140      	movs	r1, #64	@ 0x40
c0de0944:	f009 fa3a 	bl	c0de9dbc <__aeabi_memclr>
c0de0948:	2500      	movs	r5, #0
    uint8_t chain_code[32] = {0};
c0de094a:	e9cd 5509 	strd	r5, r5, [sp, #36]	@ 0x24
c0de094e:	e9cd 5507 	strd	r5, r5, [sp, #28]
c0de0952:	e9cd 5505 	strd	r5, r5, [sp, #20]
c0de0956:	e9cd 5503 	strd	r5, r5, [sp, #12]
    os_perso_derive_node_bip32(CX_CURVE_Ed25519,
c0de095a:	f64a 21a4 	movw	r1, #43684	@ 0xaaa4
c0de095e:	f2c0 0100 	movt	r1, #0
c0de0962:	af03      	add	r7, sp, #12
c0de0964:	4479      	add	r1, pc
c0de0966:	2071      	movs	r0, #113	@ 0x71
c0de0968:	2205      	movs	r2, #5
c0de096a:	465b      	mov	r3, fp
c0de096c:	9700      	str	r7, [sp, #0]
c0de096e:	f009 f85a 	bl	c0de9a26 <os_perso_derive_node_bip32>
c0de0972:	af1b      	add	r7, sp, #108	@ 0x6c
    uint8_t info_block[sizeof(HKDF_INFO) + 1] = {0};
c0de0974:	4638      	mov	r0, r7
c0de0976:	2123      	movs	r1, #35	@ 0x23
    uint8_t prk[32] = {0};
c0de0978:	e9cd 552a 	strd	r5, r5, [sp, #168]	@ 0xa8
c0de097c:	e9cd 5528 	strd	r5, r5, [sp, #160]	@ 0xa0
c0de0980:	e9cd 5526 	strd	r5, r5, [sp, #152]	@ 0x98
c0de0984:	e9cd 5524 	strd	r5, r5, [sp, #144]	@ 0x90
    uint8_t info_block[sizeof(HKDF_INFO) + 1] = {0};
c0de0988:	f009 fa18 	bl	c0de9dbc <__aeabi_memclr>
c0de098c:	ad24      	add	r5, sp, #144	@ 0x90
    cx_hmac_sha256((uint8_t *) HKDF_SALT, sizeof(HKDF_SALT), (uint8_t *) ikm, ikm_len, prk, sizeof(prk));
c0de098e:	9500      	str	r5, [sp, #0]
c0de0990:	f64a 2080 	movw	r0, #43648	@ 0xaa80
c0de0994:	f2c0 0000 	movt	r0, #0
c0de0998:	f04f 0820 	mov.w	r8, #32
c0de099c:	4478      	add	r0, pc
c0de099e:	2111      	movs	r1, #17
c0de09a0:	465a      	mov	r2, fp
c0de09a2:	2320      	movs	r3, #32
c0de09a4:	f8cd 8004 	str.w	r8, [sp, #4]
c0de09a8:	f007 ffde 	bl	c0de8968 <cx_hmac_sha256>
    memcpy(info_block, HKDF_INFO, sizeof(HKDF_INFO));
c0de09ac:	f64a 207c 	movw	r0, #43644	@ 0xaa7c
c0de09b0:	f2c0 0000 	movt	r0, #0
c0de09b4:	4478      	add	r0, pc
c0de09b6:	c85c      	ldmia	r0!, {r2, r3, r4, r6}
c0de09b8:	4639      	mov	r1, r7
c0de09ba:	c15c      	stmia	r1!, {r2, r3, r4, r6}
c0de09bc:	c85c      	ldmia	r0!, {r2, r3, r4, r6}
c0de09be:	8800      	ldrh	r0, [r0, #0]
c0de09c0:	c15c      	stmia	r1!, {r2, r3, r4, r6}
c0de09c2:	8008      	strh	r0, [r1, #0]
c0de09c4:	2001      	movs	r0, #1
    info_block[sizeof(HKDF_INFO)] = 0x01;
c0de09c6:	f88d 008e 	strb.w	r0, [sp, #142]	@ 0x8e
    cx_hmac_sha256(prk, sizeof(prk), info_block, sizeof(info_block), out, 32);
c0de09ca:	4628      	mov	r0, r5
c0de09cc:	2120      	movs	r1, #32
c0de09ce:	463a      	mov	r2, r7
c0de09d0:	2323      	movs	r3, #35	@ 0x23
c0de09d2:	f8cd a000 	str.w	sl, [sp]
c0de09d6:	f8cd 8004 	str.w	r8, [sp, #4]
c0de09da:	f007 ffc5 	bl	c0de8968 <cx_hmac_sha256>
    explicit_bzero(prk, sizeof(prk));
c0de09de:	4628      	mov	r0, r5
c0de09e0:	2120      	movs	r1, #32
c0de09e2:	f009 f9f9 	bl	c0de9dd8 <explicit_bzero>
    explicit_bzero(info_block, sizeof(info_block));
c0de09e6:	4638      	mov	r0, r7
c0de09e8:	2123      	movs	r1, #35	@ 0x23
c0de09ea:	f009 f9f5 	bl	c0de9dd8 <explicit_bzero>
    explicit_bzero(private_key, sizeof(private_key));
c0de09ee:	4658      	mov	r0, fp
c0de09f0:	2140      	movs	r1, #64	@ 0x40
c0de09f2:	f009 f9f1 	bl	c0de9dd8 <explicit_bzero>
    explicit_bzero(chain_code, sizeof(chain_code));
c0de09f6:	a803      	add	r0, sp, #12
c0de09f8:	2120      	movs	r1, #32
c0de09fa:	f009 f9ed 	bl	c0de9dd8 <explicit_bzero>
    return err;
c0de09fe:	b02c      	add	sp, #176	@ 0xb0
c0de0a00:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de0a04 <start_gcm_session>:
                             size_t aad_len) {
c0de0a04:	e92d 45f0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, lr}
c0de0a08:	b081      	sub	sp, #4
    cx_aes_gcm_init(&G_session.gcm);
c0de0a0a:	f240 0a00 	movw	sl, #0
c0de0a0e:	f2c0 0a00 	movt	sl, #0
c0de0a12:	4604      	mov	r4, r0
c0de0a14:	eb09 000a 	add.w	r0, r9, sl
c0de0a18:	1d05      	adds	r5, r0, #4
c0de0a1a:	4628      	mov	r0, r5
c0de0a1c:	4698      	mov	r8, r3
c0de0a1e:	4616      	mov	r6, r2
c0de0a20:	460f      	mov	r7, r1
c0de0a22:	f007 ff88 	bl	c0de8936 <cx_aes_gcm_init>
    err = cx_aes_gcm_set_key(&G_session.gcm, key, SECRETS_AES_KEY_LEN);
c0de0a26:	4628      	mov	r0, r5
c0de0a28:	4639      	mov	r1, r7
c0de0a2a:	2220      	movs	r2, #32
c0de0a2c:	f007 ff88 	bl	c0de8940 <cx_aes_gcm_set_key>
    if (err != CX_OK) return SW_EXECUTION_ERROR;
c0de0a30:	b9a0      	cbnz	r0, c0de0a5c <start_gcm_session+0x58>
    uint32_t mode = direction == SESSION_ENCRYPT ? CX_ENCRYPT : CX_DECRYPT;
c0de0a32:	1e60      	subs	r0, r4, #1
c0de0a34:	fab0 f080 	clz	r0, r0
c0de0a38:	0940      	lsrs	r0, r0, #5
c0de0a3a:	0081      	lsls	r1, r0, #2
    err = cx_aes_gcm_start(&G_session.gcm, mode, nonce, SECRETS_GCM_NONCE_LEN);
c0de0a3c:	eb09 000a 	add.w	r0, r9, sl
c0de0a40:	3004      	adds	r0, #4
c0de0a42:	4632      	mov	r2, r6
c0de0a44:	230c      	movs	r3, #12
c0de0a46:	f007 ff80 	bl	c0de894a <cx_aes_gcm_start>
    if (err != CX_OK) return SW_EXECUTION_ERROR;
c0de0a4a:	b938      	cbnz	r0, c0de0a5c <start_gcm_session+0x58>
c0de0a4c:	9a08      	ldr	r2, [sp, #32]
    err = cx_aes_gcm_update_aad(&G_session.gcm, aad, aad_len);
c0de0a4e:	eb09 000a 	add.w	r0, r9, sl
c0de0a52:	3004      	adds	r0, #4
c0de0a54:	4641      	mov	r1, r8
c0de0a56:	f007 ff7d 	bl	c0de8954 <cx_aes_gcm_update_aad>
    if (err != CX_OK) return SW_EXECUTION_ERROR;
c0de0a5a:	b120      	cbz	r0, c0de0a66 <start_gcm_session+0x62>
c0de0a5c:	f44f 40de 	mov.w	r0, #28416	@ 0x6f00
}
c0de0a60:	b001      	add	sp, #4
c0de0a62:	e8bd 85f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, pc}
    G_session.direction = direction;
c0de0a66:	eb09 000a 	add.w	r0, r9, sl
c0de0a6a:	2100      	movs	r1, #0
c0de0a6c:	f809 400a 	strb.w	r4, [r9, sl]
    G_session.bytes_done = 0;
c0de0a70:	6781      	str	r1, [r0, #120]	@ 0x78
c0de0a72:	f44f 4010 	mov.w	r0, #36864	@ 0x9000
}
c0de0a76:	b001      	add	sp, #4
c0de0a78:	e8bd 85f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, pc}

c0de0a7c <handler_get_app_name>:
#include "get_app_name.h"
#include "constants.h"
#include "sw.h"
#include "types.h"

int handler_get_app_name() {
c0de0a7c:	b580      	push	{r7, lr}
c0de0a7e:	b084      	sub	sp, #16
    _Static_assert(APPNAME_LEN < MAX_APPNAME_LEN, "APPNAME must be at most 64 characters!");

    return io_send_response_pointer(PIC(APPNAME), APPNAME_LEN, SWO_SUCCESS);
c0de0a80:	f24a 2099 	movw	r0, #41625	@ 0xa299
c0de0a84:	f2c0 0000 	movt	r0, #0
c0de0a88:	4478      	add	r0, pc
c0de0a8a:	f008 ff93 	bl	c0de99b4 <pic>
        &(const buffer_t){.ptr = (uint8_t *) ptr, .size = size, .offset = 0}, 1, sw);
c0de0a8e:	9001      	str	r0, [sp, #4]
c0de0a90:	2007      	movs	r0, #7
c0de0a92:	9002      	str	r0, [sp, #8]
c0de0a94:	2000      	movs	r0, #0
c0de0a96:	9003      	str	r0, [sp, #12]
c0de0a98:	a801      	add	r0, sp, #4
    return io_send_response_buffers(
c0de0a9a:	2101      	movs	r1, #1
c0de0a9c:	f44f 4210 	mov.w	r2, #36864	@ 0x9000
c0de0aa0:	f007 fd96 	bl	c0de85d0 <io_send_response_buffers>
c0de0aa4:	b004      	add	sp, #16
c0de0aa6:	bd80      	pop	{r7, pc}

c0de0aa8 <handler_get_version>:
#include "get_version.h"
#include "constants.h"
#include "sw.h"
#include "types.h"

int handler_get_version() {
c0de0aa8:	b580      	push	{r7, lr}
c0de0aaa:	b084      	sub	sp, #16
c0de0aac:	2002      	movs	r0, #2
c0de0aae:	2101      	movs	r1, #1
                   "MINOR version must be between 0 and 255!");
    _Static_assert(PATCH_VERSION >= 0 && PATCH_VERSION <= UINT8_MAX,
                   "PATCH version must be between 0 and 255!");

    return io_send_response_pointer(
        (const uint8_t *) &(uint8_t[APPVERSION_LEN]){(uint8_t) MAJOR_VERSION,
c0de0ab0:	f88d 0001 	strb.w	r0, [sp, #1]
c0de0ab4:	2003      	movs	r0, #3
c0de0ab6:	f88d 1003 	strb.w	r1, [sp, #3]
c0de0aba:	f10d 0101 	add.w	r1, sp, #1
c0de0abe:	f88d 0002 	strb.w	r0, [sp, #2]
        &(const buffer_t){.ptr = (uint8_t *) ptr, .size = size, .offset = 0}, 1, sw);
c0de0ac2:	e9cd 1001 	strd	r1, r0, [sp, #4]
c0de0ac6:	2000      	movs	r0, #0
c0de0ac8:	9003      	str	r0, [sp, #12]
c0de0aca:	a801      	add	r0, sp, #4
    return io_send_response_buffers(
c0de0acc:	2101      	movs	r1, #1
c0de0ace:	f44f 4210 	mov.w	r2, #36864	@ 0x9000
c0de0ad2:	f007 fd7d 	bl	c0de85d0 <io_send_response_buffers>
    return io_send_response_pointer(
c0de0ad6:	b004      	add	sp, #16
c0de0ad8:	bd80      	pop	{r7, pc}

c0de0ada <ui_menu_main>:

static const nbgl_contentInfoList_t infoList = {.nbInfos = 0,
                                                 .infoTypes = NULL,
                                                 .infoContents = NULL};

void ui_menu_main(void) {
c0de0ada:	b580      	push	{r7, lr}
c0de0adc:	b084      	sub	sp, #16
    nbgl_useCaseHomeAndSettings(APPNAME,
c0de0ade:	f240 0c13 	movw	ip, #19
c0de0ae2:	f2c0 0c00 	movt	ip, #0
c0de0ae6:	f64a 1168 	movw	r1, #43368	@ 0xa968
c0de0aea:	f2c0 0100 	movt	r1, #0
c0de0aee:	f64a 125a 	movw	r2, #43354	@ 0xa95a
c0de0af2:	f2c0 0200 	movt	r2, #0
c0de0af6:	2000      	movs	r0, #0
c0de0af8:	4479      	add	r1, pc
c0de0afa:	447a      	add	r2, pc
c0de0afc:	e9cd 2100 	strd	r2, r1, [sp]
c0de0b00:	9002      	str	r0, [sp, #8]
c0de0b02:	f24a 200d 	movw	r0, #41485	@ 0xa20d
c0de0b06:	f2c0 0000 	movt	r0, #0
c0de0b0a:	f249 415b 	movw	r1, #37979	@ 0x945b
c0de0b0e:	f2c0 0100 	movt	r1, #0
c0de0b12:	44fc      	add	ip, pc
c0de0b14:	4478      	add	r0, pc
c0de0b16:	4479      	add	r1, pc
c0de0b18:	2200      	movs	r2, #0
c0de0b1a:	23ff      	movs	r3, #255	@ 0xff
c0de0b1c:	f8cd c00c 	str.w	ip, [sp, #12]
c0de0b20:	f006 fa14 	bl	c0de6f4c <nbgl_useCaseHomeAndSettings>
                                INIT_HOME_PAGE,
                                &settingContents,
                                &infoList,
                                NULL,
                                app_quit);
}
c0de0b24:	b004      	add	sp, #16
c0de0b26:	bd80      	pop	{r7, pc}

c0de0b28 <app_quit>:
    os_sched_exit(-1);
c0de0b28:	20ff      	movs	r0, #255	@ 0xff
c0de0b2a:	f008 ffe1 	bl	c0de9af0 <os_sched_exit>

c0de0b2e <os_io_handle_default_apdu>:
bolos_err_t os_io_handle_default_apdu(uint8_t                  *buffer_in,
                                      size_t                    buffer_in_length,
                                      uint8_t                  *buffer_out,
                                      size_t                   *buffer_out_length,
                                      os_io_apdu_post_action_t *post_action)
{
c0de0b2e:	e92d 45f0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, lr}
c0de0b32:	b0a1      	sub	sp, #132	@ 0x84
c0de0b34:	f8dd 80a0 	ldr.w	r8, [sp, #160]	@ 0xa0
    bolos_err_t err = SWO_CONDITIONS_NOT_SATISFIED;

    if (!buffer_in || !buffer_in_length || !buffer_out || !buffer_out_length) {
c0de0b38:	2800      	cmp	r0, #0
c0de0b3a:	bf18      	it	ne
c0de0b3c:	2900      	cmpne	r1, #0
c0de0b3e:	d105      	bne.n	c0de0b4c <os_io_handle_default_apdu+0x1e>
        return *post_action;
c0de0b40:	f898 4000 	ldrb.w	r4, [r8]
        }
    }

end:
    return err;
}
c0de0b44:	4620      	mov	r0, r4
c0de0b46:	b021      	add	sp, #132	@ 0x84
c0de0b48:	e8bd 85f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, pc}
c0de0b4c:	4616      	mov	r6, r2
    if (!buffer_in || !buffer_in_length || !buffer_out || !buffer_out_length) {
c0de0b4e:	2a00      	cmp	r2, #0
c0de0b50:	d0f6      	beq.n	c0de0b40 <os_io_handle_default_apdu+0x12>
c0de0b52:	461c      	mov	r4, r3
c0de0b54:	2b00      	cmp	r3, #0
c0de0b56:	d0f3      	beq.n	c0de0b40 <os_io_handle_default_apdu+0x12>
c0de0b58:	4605      	mov	r5, r0
    if (post_action) {
c0de0b5a:	f1b8 0f00 	cmp.w	r8, #0
c0de0b5e:	bf1c      	itt	ne
c0de0b60:	2000      	movne	r0, #0
        *post_action = OS_IO_APDU_POST_ACTION_NONE;
c0de0b62:	f888 0000 	strbne.w	r0, [r8]
    if (DEFAULT_APDU_CLA == buffer_in[APDU_OFF_CLA]) {
c0de0b66:	7828      	ldrb	r0, [r5, #0]
c0de0b68:	28b0      	cmp	r0, #176	@ 0xb0
c0de0b6a:	d10e      	bne.n	c0de0b8a <os_io_handle_default_apdu+0x5c>
               buffer_in[APDU_OFF_INS],
c0de0b6c:	786a      	ldrb	r2, [r5, #1]
               DEFAULT_APDU_INS_STR(buffer_in[APDU_OFF_INS]),
c0de0b6e:	2a05      	cmp	r2, #5
c0de0b70:	dd0e      	ble.n	c0de0b90 <os_io_handle_default_apdu+0x62>
c0de0b72:	2a06      	cmp	r2, #6
c0de0b74:	d016      	beq.n	c0de0ba4 <os_io_handle_default_apdu+0x76>
c0de0b76:	2a10      	cmp	r2, #16
c0de0b78:	d01a      	beq.n	c0de0bb0 <os_io_handle_default_apdu+0x82>
c0de0b7a:	2a57      	cmp	r2, #87	@ 0x57
c0de0b7c:	d124      	bne.n	c0de0bc8 <os_io_handle_default_apdu+0x9a>
c0de0b7e:	f24a 4335 	movw	r3, #42037	@ 0xa435
c0de0b82:	f2c0 0300 	movt	r3, #0
c0de0b86:	447b      	add	r3, pc
c0de0b88:	e02b      	b.n	c0de0be2 <os_io_handle_default_apdu+0xb4>
c0de0b8a:	f646 1485 	movw	r4, #27013	@ 0x6985
c0de0b8e:	e7d9      	b.n	c0de0b44 <os_io_handle_default_apdu+0x16>
c0de0b90:	2a01      	cmp	r2, #1
c0de0b92:	d013      	beq.n	c0de0bbc <os_io_handle_default_apdu+0x8e>
c0de0b94:	2a02      	cmp	r2, #2
c0de0b96:	d117      	bne.n	c0de0bc8 <os_io_handle_default_apdu+0x9a>
c0de0b98:	f24a 5373 	movw	r3, #42355	@ 0xa573
c0de0b9c:	f2c0 0300 	movt	r3, #0
c0de0ba0:	447b      	add	r3, pc
c0de0ba2:	e01e      	b.n	c0de0be2 <os_io_handle_default_apdu+0xb4>
c0de0ba4:	f24a 23e0 	movw	r3, #41696	@ 0xa2e0
c0de0ba8:	f2c0 0300 	movt	r3, #0
c0de0bac:	447b      	add	r3, pc
c0de0bae:	e018      	b.n	c0de0be2 <os_io_handle_default_apdu+0xb4>
c0de0bb0:	f24a 7326 	movw	r3, #42790	@ 0xa726
c0de0bb4:	f2c0 0300 	movt	r3, #0
c0de0bb8:	447b      	add	r3, pc
c0de0bba:	e012      	b.n	c0de0be2 <os_io_handle_default_apdu+0xb4>
c0de0bbc:	f24a 730e 	movw	r3, #42766	@ 0xa70e
c0de0bc0:	f2c0 0300 	movt	r3, #0
c0de0bc4:	447b      	add	r3, pc
c0de0bc6:	e00c      	b.n	c0de0be2 <os_io_handle_default_apdu+0xb4>
c0de0bc8:	f24a 30f3 	movw	r0, #41971	@ 0xa3f3
c0de0bcc:	f2c0 0000 	movt	r0, #0
c0de0bd0:	f24a 23f2 	movw	r3, #41714	@ 0xa2f2
c0de0bd4:	f2c0 0300 	movt	r3, #0
c0de0bd8:	447b      	add	r3, pc
c0de0bda:	4478      	add	r0, pc
c0de0bdc:	2aa7      	cmp	r2, #167	@ 0xa7
c0de0bde:	bf08      	it	eq
c0de0be0:	4603      	moveq	r3, r0
               buffer_in[APDU_OFF_P1],
c0de0be2:	78a8      	ldrb	r0, [r5, #2]
               buffer_in[APDU_OFF_LC],
c0de0be4:	792f      	ldrb	r7, [r5, #4]
               buffer_in[APDU_OFF_P2],
c0de0be6:	78e9      	ldrb	r1, [r5, #3]
        PRINTF("[DEFAULT_APDU] => CLA=%02x, INS=%02x (%s), P1=%02x, P2=%02x, LC=%02x, CDATA=%.*h\n",
c0de0be8:	e88d 0083 	stmia.w	sp, {r0, r1, r7}
c0de0bec:	9703      	str	r7, [sp, #12]
c0de0bee:	f24a 10fd 	movw	r0, #41469	@ 0xa1fd
c0de0bf2:	f2c0 0000 	movt	r0, #0
               &buffer_in[APDU_OFF_DATA]);
c0de0bf6:	f105 0a05 	add.w	sl, r5, #5
        PRINTF("[DEFAULT_APDU] => CLA=%02x, INS=%02x (%s), P1=%02x, P2=%02x, LC=%02x, CDATA=%.*h\n",
c0de0bfa:	4478      	add	r0, pc
c0de0bfc:	21b0      	movs	r1, #176	@ 0xb0
c0de0bfe:	f8cd a010 	str.w	sl, [sp, #16]
c0de0c02:	f008 f813 	bl	c0de8c2c <mcu_usb_printf>
        switch (buffer_in[APDU_OFF_INS]) {
c0de0c06:	7868      	ldrb	r0, [r5, #1]
c0de0c08:	28a7      	cmp	r0, #167	@ 0xa7
c0de0c0a:	d00d      	beq.n	c0de0c28 <os_io_handle_default_apdu+0xfa>
c0de0c0c:	2806      	cmp	r0, #6
c0de0c0e:	d012      	beq.n	c0de0c36 <os_io_handle_default_apdu+0x108>
c0de0c10:	2801      	cmp	r0, #1
c0de0c12:	d10d      	bne.n	c0de0c30 <os_io_handle_default_apdu+0x102>
                if (!buffer_in[APDU_OFF_P1] && !buffer_in[APDU_OFF_P2]) {
c0de0c14:	78a8      	ldrb	r0, [r5, #2]
c0de0c16:	b958      	cbnz	r0, c0de0c30 <os_io_handle_default_apdu+0x102>
c0de0c18:	78e8      	ldrb	r0, [r5, #3]
c0de0c1a:	b948      	cbnz	r0, c0de0c30 <os_io_handle_default_apdu+0x102>
                    err = get_version(buffer_out, buffer_out_length);
c0de0c1c:	4630      	mov	r0, r6
c0de0c1e:	4621      	mov	r1, r4
c0de0c20:	f000 f82a 	bl	c0de0c78 <get_version>
c0de0c24:	4604      	mov	r4, r0
c0de0c26:	e78d      	b.n	c0de0b44 <os_io_handle_default_apdu+0x16>
                if (!buffer_in[APDU_OFF_P1] && !buffer_in[APDU_OFF_P2]) {
c0de0c28:	78a8      	ldrb	r0, [r5, #2]
c0de0c2a:	b908      	cbnz	r0, c0de0c30 <os_io_handle_default_apdu+0x102>
c0de0c2c:	78e8      	ldrb	r0, [r5, #3]
c0de0c2e:	b1c0      	cbz	r0, c0de0c62 <os_io_handle_default_apdu+0x134>
c0de0c30:	f44f 44dc 	mov.w	r4, #28160	@ 0x6e00
c0de0c34:	e786      	b.n	c0de0b44 <os_io_handle_default_apdu+0x16>
c0de0c36:	2100      	movs	r1, #0
                *buffer_out_length = 0;
c0de0c38:	6021      	str	r1, [r4, #0]
                    &buffer_in[APDU_OFF_LC + 1], buffer_in[APDU_OFF_LC], buffer_in[APDU_OFF_P1]);
c0de0c3a:	78a8      	ldrb	r0, [r5, #2]
c0de0c3c:	792a      	ldrb	r2, [r5, #4]
c0de0c3e:	ad06      	add	r5, sp, #24
    err = os_pki_load_certificate(key_usage, buffer, buffer_len, NULL, NULL, &public_key);
c0de0c40:	9100      	str	r1, [sp, #0]
c0de0c42:	4651      	mov	r1, sl
c0de0c44:	2300      	movs	r3, #0
c0de0c46:	9501      	str	r5, [sp, #4]
c0de0c48:	f008 fefd 	bl	c0de9a46 <os_pki_load_certificate>
c0de0c4c:	4604      	mov	r4, r0
    if (err == 0) {
c0de0c4e:	2800      	cmp	r0, #0
    explicit_bzero(&public_key, sizeof(cx_ecfp_384_public_key_t));
c0de0c50:	4628      	mov	r0, r5
c0de0c52:	f04f 016c 	mov.w	r1, #108	@ 0x6c
    if (err == 0) {
c0de0c56:	bf08      	it	eq
c0de0c58:	f44f 4410 	moveq.w	r4, #36864	@ 0x9000
    explicit_bzero(&public_key, sizeof(cx_ecfp_384_public_key_t));
c0de0c5c:	f009 f8bc 	bl	c0de9dd8 <explicit_bzero>
c0de0c60:	e770      	b.n	c0de0b44 <os_io_handle_default_apdu+0x16>
c0de0c62:	2000      	movs	r0, #0
                    if (post_action) {
c0de0c64:	f1b8 0f00 	cmp.w	r8, #0
                    *buffer_out_length = 0;
c0de0c68:	6020      	str	r0, [r4, #0]
c0de0c6a:	bf1c      	itt	ne
c0de0c6c:	2001      	movne	r0, #1
                        *post_action = OS_IO_APDU_POST_ACTION_EXIT;
c0de0c6e:	f888 0000 	strbne.w	r0, [r8]
c0de0c72:	f44f 4410 	mov.w	r4, #36864	@ 0x9000
c0de0c76:	e765      	b.n	c0de0b44 <os_io_handle_default_apdu+0x16>

c0de0c78 <get_version>:
{
c0de0c78:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0c7a:	b081      	sub	sp, #4
c0de0c7c:	4604      	mov	r4, r0
    size_t      max_buffer_out_length = *buffer_out_length;
c0de0c7e:	6808      	ldr	r0, [r1, #0]
c0de0c80:	460d      	mov	r5, r1
c0de0c82:	2100      	movs	r1, #0
    if (max_buffer_out_length >= 3) {
c0de0c84:	2803      	cmp	r0, #3
    *buffer_out_length = 0;
c0de0c86:	6029      	str	r1, [r5, #0]
    if (max_buffer_out_length >= 3) {
c0de0c88:	d32a      	bcc.n	c0de0ce0 <get_version+0x68>
c0de0c8a:	2601      	movs	r6, #1
        buffer_out[(*buffer_out_length)++] = 1;  // format ID
c0de0c8c:	602e      	str	r6, [r5, #0]
c0de0c8e:	7026      	strb	r6, [r4, #0]
                                              &buffer_out[(*buffer_out_length) + 1],
c0de0c90:	682a      	ldr	r2, [r5, #0]
                                              max_buffer_out_length - *buffer_out_length - 3);
c0de0c92:	1ec7      	subs	r7, r0, #3
                                              &buffer_out[(*buffer_out_length) + 1],
c0de0c94:	1911      	adds	r1, r2, r4
c0de0c96:	3101      	adds	r1, #1
                                              max_buffer_out_length - *buffer_out_length - 3);
c0de0c98:	1aba      	subs	r2, r7, r2
            = os_registry_get_current_app_tag(BOLOS_TAG_APPNAME,
c0de0c9a:	2001      	movs	r0, #1
c0de0c9c:	f008 ff1c 	bl	c0de9ad8 <os_registry_get_current_app_tag>
        buffer_out[(*buffer_out_length)++] = str_length;
c0de0ca0:	6829      	ldr	r1, [r5, #0]
c0de0ca2:	1c4a      	adds	r2, r1, #1
c0de0ca4:	602a      	str	r2, [r5, #0]
c0de0ca6:	5460      	strb	r0, [r4, r1]
        *buffer_out_length += str_length;
c0de0ca8:	6829      	ldr	r1, [r5, #0]
c0de0caa:	4408      	add	r0, r1
                                              &buffer_out[(*buffer_out_length) + 1],
c0de0cac:	1901      	adds	r1, r0, r4
        *buffer_out_length += str_length;
c0de0cae:	6028      	str	r0, [r5, #0]
                                              &buffer_out[(*buffer_out_length) + 1],
c0de0cb0:	3101      	adds	r1, #1
                                              max_buffer_out_length - *buffer_out_length - 3);
c0de0cb2:	1a3a      	subs	r2, r7, r0
            = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION,
c0de0cb4:	2002      	movs	r0, #2
c0de0cb6:	f008 ff0f 	bl	c0de9ad8 <os_registry_get_current_app_tag>
        buffer_out[(*buffer_out_length)++] = str_length;
c0de0cba:	6829      	ldr	r1, [r5, #0]
c0de0cbc:	1c4a      	adds	r2, r1, #1
c0de0cbe:	602a      	str	r2, [r5, #0]
c0de0cc0:	5460      	strb	r0, [r4, r1]
        *buffer_out_length += str_length;
c0de0cc2:	6829      	ldr	r1, [r5, #0]
c0de0cc4:	4408      	add	r0, r1
        buffer_out[(*buffer_out_length)++] = 1;
c0de0cc6:	1c41      	adds	r1, r0, #1
c0de0cc8:	6029      	str	r1, [r5, #0]
c0de0cca:	5426      	strb	r6, [r4, r0]
        buffer_out[(*buffer_out_length)++] = os_flags();
c0de0ccc:	f008 feee 	bl	c0de9aac <os_flags>
c0de0cd0:	6829      	ldr	r1, [r5, #0]
c0de0cd2:	1c4a      	adds	r2, r1, #1
c0de0cd4:	602a      	str	r2, [r5, #0]
c0de0cd6:	5460      	strb	r0, [r4, r1]
c0de0cd8:	f44f 4010 	mov.w	r0, #36864	@ 0x9000
    return err;
c0de0cdc:	b001      	add	sp, #4
c0de0cde:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de0ce0:	f646 1085 	movw	r0, #27013	@ 0x6985
c0de0ce4:	b001      	add	sp, #4
c0de0ce6:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de0ce8 <os_io_seph_cmd_printf>:
    }
}
#else   // ! HAVE_PRINTF_CDC
void os_io_seph_cmd_printf(const char *str, uint16_t charcount)
{
    if (charcount) {
c0de0ce8:	2900      	cmp	r1, #0
        hdr[1] = charcount >> 8;
        hdr[2] = charcount;
        os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, hdr, 3, NULL);
        os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, (const uint8_t *) str, charcount, NULL);
    }
}
c0de0cea:	bf08      	it	eq
c0de0cec:	4770      	bxeq	lr
c0de0cee:	b5b0      	push	{r4, r5, r7, lr}
c0de0cf0:	b082      	sub	sp, #8
c0de0cf2:	4605      	mov	r5, r0
c0de0cf4:	205f      	movs	r0, #95	@ 0x5f
        hdr[0] = SEPROXYHAL_TAG_PRINTF;
c0de0cf6:	f88d 0005 	strb.w	r0, [sp, #5]
        hdr[1] = charcount >> 8;
c0de0cfa:	0a08      	lsrs	r0, r1, #8
c0de0cfc:	460c      	mov	r4, r1
c0de0cfe:	f88d 0006 	strb.w	r0, [sp, #6]
        hdr[2] = charcount;
c0de0d02:	f88d 1007 	strb.w	r1, [sp, #7]
c0de0d06:	f10d 0105 	add.w	r1, sp, #5
        os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, hdr, 3, NULL);
c0de0d0a:	2001      	movs	r0, #1
c0de0d0c:	2203      	movs	r2, #3
c0de0d0e:	2300      	movs	r3, #0
c0de0d10:	f008 ff1c 	bl	c0de9b4c <os_io_tx_cmd>
        os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, (const uint8_t *) str, charcount, NULL);
c0de0d14:	2001      	movs	r0, #1
c0de0d16:	4629      	mov	r1, r5
c0de0d18:	4622      	mov	r2, r4
c0de0d1a:	2300      	movs	r3, #0
c0de0d1c:	f008 ff16 	bl	c0de9b4c <os_io_tx_cmd>
c0de0d20:	b002      	add	sp, #8
c0de0d22:	e8bd 40b0 	ldmia.w	sp!, {r4, r5, r7, lr}
}
c0de0d26:	4770      	bx	lr

c0de0d28 <os_io_seph_cmd_piezo_play_tune>:
    return os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, buffer, 4, NULL);
}
#endif  // HAVE_SE_TOUCH

int os_io_seph_cmd_piezo_play_tune(tune_index_e tune_index)
{
c0de0d28:	b5b0      	push	{r4, r5, r7, lr}
c0de0d2a:	b082      	sub	sp, #8
    int status = 0;
#ifdef HAVE_PIEZO_SOUND
    uint8_t buffer[4];
    if (tune_index >= NB_TUNES) {
c0de0d2c:	280b      	cmp	r0, #11
c0de0d2e:	d902      	bls.n	c0de0d36 <os_io_seph_cmd_piezo_play_tune+0xe>
c0de0d30:	f06f 0515 	mvn.w	r5, #21
c0de0d34:	e023      	b.n	c0de0d7e <os_io_seph_cmd_piezo_play_tune+0x56>
c0de0d36:	4604      	mov	r4, r0
        status = -22;  // EINVAL
        goto end;
    }

    uint32_t sound_setting = os_setting_get(OS_SETTING_PIEZO_SOUND, NULL, 0);
c0de0d38:	2009      	movs	r0, #9
c0de0d3a:	2100      	movs	r1, #0
c0de0d3c:	2200      	movs	r2, #0
c0de0d3e:	2500      	movs	r5, #0
c0de0d40:	f008 febe 	bl	c0de9ac0 <os_setting_get>

    if ((!IS_NOTIF_ENABLED(sound_setting)) && (tune_index < TUNE_TAP_CASUAL)) {
c0de0d44:	2c08      	cmp	r4, #8
c0de0d46:	d802      	bhi.n	c0de0d4e <os_io_seph_cmd_piezo_play_tune+0x26>
c0de0d48:	f010 0102 	ands.w	r1, r0, #2
c0de0d4c:	d117      	bne.n	c0de0d7e <os_io_seph_cmd_piezo_play_tune+0x56>
        goto end;
    }
    if ((!IS_TAP_ENABLED(sound_setting)) && (tune_index >= TUNE_TAP_CASUAL)) {
c0de0d4e:	2c09      	cmp	r4, #9
c0de0d50:	f04f 0500 	mov.w	r5, #0
c0de0d54:	d302      	bcc.n	c0de0d5c <os_io_seph_cmd_piezo_play_tune+0x34>
c0de0d56:	f010 0001 	ands.w	r0, r0, #1
c0de0d5a:	d110      	bne.n	c0de0d7e <os_io_seph_cmd_piezo_play_tune+0x56>
c0de0d5c:	2056      	movs	r0, #86	@ 0x56
        goto end;
    }

    buffer[0] = SEPROXYHAL_TAG_PLAY_TUNE;
c0de0d5e:	f88d 0004 	strb.w	r0, [sp, #4]
c0de0d62:	2001      	movs	r0, #1
    buffer[1] = 0;
    buffer[2] = 1;
c0de0d64:	f88d 0006 	strb.w	r0, [sp, #6]
c0de0d68:	a901      	add	r1, sp, #4
    buffer[3] = (uint8_t) tune_index;
    status    = os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, buffer, 4, NULL);
c0de0d6a:	2001      	movs	r0, #1
c0de0d6c:	2204      	movs	r2, #4
c0de0d6e:	2300      	movs	r3, #0
    buffer[1] = 0;
c0de0d70:	f88d 5005 	strb.w	r5, [sp, #5]
    buffer[3] = (uint8_t) tune_index;
c0de0d74:	f88d 4007 	strb.w	r4, [sp, #7]
    status    = os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, buffer, 4, NULL);
c0de0d78:	f008 fee8 	bl	c0de9b4c <os_io_tx_cmd>
c0de0d7c:	4605      	mov	r5, r0
end:
#else
    UNUSED(tune_index);
#endif  // HAVE_PIEZO_SOUND

    return status;
c0de0d7e:	4628      	mov	r0, r5
c0de0d80:	b002      	add	sp, #8
c0de0d82:	bdb0      	pop	{r4, r5, r7, pc}

c0de0d84 <io_process_itc_ux_event>:
    G_ux_os.button_mask              = 0;
    G_ux_os.button_same_mask_counter = 0;
}

int io_process_itc_ux_event(uint8_t *buffer_in, size_t buffer_in_length)
{
c0de0d84:	b510      	push	{r4, lr}
    int status = buffer_in_length;

    switch (buffer_in[3]) {
c0de0d86:	78c2      	ldrb	r2, [r0, #3]
c0de0d88:	2a20      	cmp	r2, #32
c0de0d8a:	d035      	beq.n	c0de0df8 <io_process_itc_ux_event+0x74>
c0de0d8c:	2a23      	cmp	r2, #35	@ 0x23
c0de0d8e:	d03b      	beq.n	c0de0e08 <io_process_itc_ux_event+0x84>
c0de0d90:	2a22      	cmp	r2, #34	@ 0x22
        default:
            break;
    }

    return status;
}
c0de0d92:	bf1c      	itt	ne
c0de0d94:	4608      	movne	r0, r1
c0de0d96:	bd10      	popne	{r4, pc}
            G_ux_params.ux_id = BOLOS_UX_ASYNCHMODAL_PAIRING_REQUEST;
c0de0d98:	f640 1c84 	movw	ip, #2436	@ 0x984
c0de0d9c:	f2c0 0c00 	movt	ip, #0
c0de0da0:	eb09 020c 	add.w	r2, r9, ip
c0de0da4:	2318      	movs	r3, #24
c0de0da6:	2400      	movs	r4, #0
            G_ux_params.len   = sizeof(G_ux_params.u.pairing_request);
c0de0da8:	e9c2 3401 	strd	r3, r4, [r2, #4]
            memset(&G_ux_params.u.pairing_request, 0, sizeof(G_ux_params.u.pairing_request));
c0de0dac:	e9c2 4403 	strd	r4, r4, [r2, #12]
c0de0db0:	e9c2 4405 	strd	r4, r4, [r2, #20]
c0de0db4:	61d4      	str	r4, [r2, #28]
            G_ux_params.u.pairing_request.type = buffer_in[4];
c0de0db6:	7903      	ldrb	r3, [r0, #4]
c0de0db8:	2406      	movs	r4, #6
c0de0dba:	7213      	strb	r3, [r2, #8]
#define U2(hi, lo) ((((hi) &0xFFu) << 8) | ((lo) &0xFFu))
#define U4(hi3, hi2, lo1, lo0) \
    ((((hi3) &0xFFu) << 24) | (((hi2) &0xFFu) << 16) | (((lo1) &0xFFu) << 8) | ((lo0) &0xFFu))
static inline uint16_t U2BE(const uint8_t *buf, size_t off)
{
    return (buf[off] << 8) | buf[off + 1];
c0de0dbc:	7842      	ldrb	r2, [r0, #1]
c0de0dbe:	7883      	ldrb	r3, [r0, #2]
            G_ux_params.ux_id = BOLOS_UX_ASYNCHMODAL_PAIRING_REQUEST;
c0de0dc0:	f809 400c 	strb.w	r4, [r9, ip]
c0de0dc4:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
                || (pairing_info_len > sizeof(G_ux_params.u.pairing_request.pairing_info))
c0de0dc8:	f1a2 0313 	sub.w	r3, r2, #19
c0de0dcc:	b29b      	uxth	r3, r3
c0de0dce:	f64f 74f0 	movw	r4, #65520	@ 0xfff0
c0de0dd2:	42a3      	cmp	r3, r4
c0de0dd4:	f06f 0315 	mvn.w	r3, #21
c0de0dd8:	d327      	bcc.n	c0de0e2a <io_process_itc_ux_event+0xa6>
c0de0dda:	3a02      	subs	r2, #2
c0de0ddc:	b292      	uxth	r2, r2
c0de0dde:	3905      	subs	r1, #5
c0de0de0:	4291      	cmp	r1, r2
c0de0de2:	d322      	bcc.n	c0de0e2a <io_process_itc_ux_event+0xa6>
            G_ux_params.u.pairing_request.pairing_info_len = pairing_info_len;
c0de0de4:	eb09 040c 	add.w	r4, r9, ip
                   &buffer_in[5],
c0de0de8:	1d41      	adds	r1, r0, #5
            memcpy(G_ux_params.u.pairing_request.pairing_info,
c0de0dea:	f104 0010 	add.w	r0, r4, #16
            G_ux_params.u.pairing_request.pairing_info_len = pairing_info_len;
c0de0dee:	60e2      	str	r2, [r4, #12]
            memcpy(G_ux_params.u.pairing_request.pairing_info,
c0de0df0:	f008 ffda 	bl	c0de9da8 <__aeabi_memcpy>
            os_ux(&G_ux_params);
c0de0df4:	4620      	mov	r0, r4
c0de0df6:	e015      	b.n	c0de0e24 <io_process_itc_ux_event+0xa0>
            nbgl_objAllowDrawing(true);
c0de0df8:	2001      	movs	r0, #1
c0de0dfa:	f007 fe91 	bl	c0de8b20 <nbgl_objAllowDrawing>
            nbgl_screenRedraw();
c0de0dfe:	f007 fe9e 	bl	c0de8b3e <nbgl_screenRedraw>
            nbgl_refresh();
c0de0e02:	f007 fe74 	bl	c0de8aee <nbgl_refresh>
c0de0e06:	e00f      	b.n	c0de0e28 <io_process_itc_ux_event+0xa4>
            G_ux_params.ux_id                       = BOLOS_UX_ASYNCHMODAL_PAIRING_STATUS;
c0de0e08:	f640 1284 	movw	r2, #2436	@ 0x984
c0de0e0c:	f2c0 0200 	movt	r2, #0
c0de0e10:	eb09 0102 	add.w	r1, r9, r2
c0de0e14:	2301      	movs	r3, #1
            G_ux_params.len                         = sizeof(G_ux_params.u.pairing_status);
c0de0e16:	604b      	str	r3, [r1, #4]
            G_ux_params.u.pairing_status.pairing_ok = buffer_in[4];
c0de0e18:	7900      	ldrb	r0, [r0, #4]
c0de0e1a:	2307      	movs	r3, #7
c0de0e1c:	7208      	strb	r0, [r1, #8]
            os_ux(&G_ux_params);
c0de0e1e:	4608      	mov	r0, r1
            G_ux_params.ux_id                       = BOLOS_UX_ASYNCHMODAL_PAIRING_STATUS;
c0de0e20:	f809 3002 	strb.w	r3, [r9, r2]
c0de0e24:	f008 fe35 	bl	c0de9a92 <os_ux>
c0de0e28:	2300      	movs	r3, #0
}
c0de0e2a:	4618      	mov	r0, r3
c0de0e2c:	bd10      	pop	{r4, pc}

c0de0e2e <io_seproxyhal_io_heartbeat>:
{
    os_io_stop();
}

void io_seproxyhal_io_heartbeat(void)
{
c0de0e2e:	b570      	push	{r4, r5, r6, lr}
c0de0e30:	b082      	sub	sp, #8
    uint16_t      err = SWO_COMMAND_NOT_ACCEPTED;
    unsigned char err_buffer[2];
    int           status = os_io_rx_evt(G_io_rx_buffer, sizeof(G_io_rx_buffer), NULL, true);
c0de0e32:	f240 158d 	movw	r5, #397	@ 0x18d
c0de0e36:	f2c0 0500 	movt	r5, #0
c0de0e3a:	eb09 0005 	add.w	r0, r9, r5
c0de0e3e:	f240 1111 	movw	r1, #273	@ 0x111
c0de0e42:	2200      	movs	r2, #0
c0de0e44:	2301      	movs	r3, #1
c0de0e46:	2601      	movs	r6, #1
c0de0e48:	f008 fe8c 	bl	c0de9b64 <os_io_rx_evt>
c0de0e4c:	4604      	mov	r4, r0

    if (os_perso_is_pin_set() == BOLOS_TRUE && os_global_pin_is_validated() != BOLOS_TRUE) {
c0de0e4e:	f008 fe0a 	bl	c0de9a66 <os_perso_is_pin_set>
c0de0e52:	28aa      	cmp	r0, #170	@ 0xaa
c0de0e54:	d10a      	bne.n	c0de0e6c <io_seproxyhal_io_heartbeat+0x3e>
c0de0e56:	f008 fe11 	bl	c0de9a7c <os_global_pin_is_validated>
c0de0e5a:	2615      	movs	r6, #21
c0de0e5c:	28aa      	cmp	r0, #170	@ 0xaa
c0de0e5e:	f04f 0055 	mov.w	r0, #85	@ 0x55
c0de0e62:	bf08      	it	eq
c0de0e64:	2601      	moveq	r6, #1
c0de0e66:	bf08      	it	eq
c0de0e68:	2069      	moveq	r0, #105	@ 0x69
c0de0e6a:	e000      	b.n	c0de0e6e <io_seproxyhal_io_heartbeat+0x40>
c0de0e6c:	2069      	movs	r0, #105	@ 0x69
    }

    err_buffer[0] = err >> 8;
    err_buffer[1] = err;

    if (status > 0) {
c0de0e6e:	2c01      	cmp	r4, #1
    err_buffer[0] = err >> 8;
c0de0e70:	f88d 0006 	strb.w	r0, [sp, #6]
    err_buffer[1] = err;
c0de0e74:	f88d 6007 	strb.w	r6, [sp, #7]
    if (status > 0) {
c0de0e78:	db15      	blt.n	c0de0ea6 <io_seproxyhal_io_heartbeat+0x78>
        switch (G_io_rx_buffer[0]) {
c0de0e7a:	f819 0005 	ldrb.w	r0, [r9, r5]
c0de0e7e:	282f      	cmp	r0, #47	@ 0x2f
c0de0e80:	dc13      	bgt.n	c0de0eaa <io_seproxyhal_io_heartbeat+0x7c>
c0de0e82:	f1a0 0110 	sub.w	r1, r0, #16
c0de0e86:	2913      	cmp	r1, #19
c0de0e88:	d814      	bhi.n	c0de0eb4 <io_seproxyhal_io_heartbeat+0x86>
c0de0e8a:	2201      	movs	r2, #1
c0de0e8c:	fa02 f101 	lsl.w	r1, r2, r1
c0de0e90:	2201      	movs	r2, #1
c0de0e92:	f2c0 020f 	movt	r2, #15
c0de0e96:	4211      	tst	r1, r2
c0de0e98:	d00c      	beq.n	c0de0eb4 <io_seproxyhal_io_heartbeat+0x86>
c0de0e9a:	f10d 0106 	add.w	r1, sp, #6
            case OS_IO_PACKET_TYPE_USB_CCID_APDU:
            case OS_IO_PACKET_TYPE_USB_WEBUSB_APDU:
            case OS_IO_PACKET_TYPE_USB_U2F_HID_APDU:
            case OS_IO_PACKET_TYPE_BLE_APDU:
            case OS_IO_PACKET_TYPE_NFC_APDU:
                os_io_tx_cmd(G_io_rx_buffer[0], err_buffer, sizeof(err_buffer), 0);
c0de0e9e:	2202      	movs	r2, #2
c0de0ea0:	2300      	movs	r3, #0
c0de0ea2:	f008 fe53 	bl	c0de9b4c <os_io_tx_cmd>

            default:
                break;
        }
    }
}
c0de0ea6:	b002      	add	sp, #8
c0de0ea8:	bd70      	pop	{r4, r5, r6, pc}
        switch (G_io_rx_buffer[0]) {
c0de0eaa:	2830      	cmp	r0, #48	@ 0x30
c0de0eac:	d0f5      	beq.n	c0de0e9a <io_seproxyhal_io_heartbeat+0x6c>
c0de0eae:	2840      	cmp	r0, #64	@ 0x40
c0de0eb0:	d0f3      	beq.n	c0de0e9a <io_seproxyhal_io_heartbeat+0x6c>
c0de0eb2:	e7f8      	b.n	c0de0ea6 <io_seproxyhal_io_heartbeat+0x78>
c0de0eb4:	3801      	subs	r0, #1
c0de0eb6:	2802      	cmp	r0, #2
c0de0eb8:	d2f5      	bcs.n	c0de0ea6 <io_seproxyhal_io_heartbeat+0x78>
                memcpy(G_io_seproxyhal_spi_buffer, &G_io_rx_buffer[1], status - 1);
c0de0eba:	f640 0070 	movw	r0, #2160	@ 0x870
c0de0ebe:	f2c0 0000 	movt	r0, #0
c0de0ec2:	eb09 0105 	add.w	r1, r9, r5
c0de0ec6:	1e62      	subs	r2, r4, #1
c0de0ec8:	4448      	add	r0, r9
c0de0eca:	3101      	adds	r1, #1
c0de0ecc:	f008 ff6c 	bl	c0de9da8 <__aeabi_memcpy>
                io_event(CHANNEL_APDU);
c0de0ed0:	2000      	movs	r0, #0
c0de0ed2:	f007 fb44 	bl	c0de855e <io_event>
}
c0de0ed6:	b002      	add	sp, #8
c0de0ed8:	bd70      	pop	{r4, r5, r6, pc}

c0de0eda <io_legacy_apdu_tx>:

    return status;
}

int io_legacy_apdu_tx(const unsigned char *buffer, unsigned short length)
{
c0de0eda:	b5b0      	push	{r4, r5, r7, lr}
    int status = os_io_tx_cmd(io_os_legacy_apdu_type, buffer, length, 0);
c0de0edc:	f240 24ac 	movw	r4, #684	@ 0x2ac
c0de0ee0:	f2c0 0400 	movt	r4, #0
c0de0ee4:	460a      	mov	r2, r1
c0de0ee6:	f819 1004 	ldrb.w	r1, [r9, r4]
c0de0eea:	4603      	mov	r3, r0
c0de0eec:	4608      	mov	r0, r1
c0de0eee:	4619      	mov	r1, r3
c0de0ef0:	2300      	movs	r3, #0
c0de0ef2:	2500      	movs	r5, #0
c0de0ef4:	f008 fe2a 	bl	c0de9b4c <os_io_tx_cmd>

    G_io_app.apdu_media    = IO_APDU_MEDIA_NONE;
c0de0ef8:	f240 21a0 	movw	r1, #672	@ 0x2a0
c0de0efc:	f2c0 0100 	movt	r1, #0
c0de0f00:	4449      	add	r1, r9
c0de0f02:	718d      	strb	r5, [r1, #6]
    io_os_legacy_apdu_type = APDU_TYPE_NONE;
#ifdef HAVE_IO_U2F
    G_io_u2f.media = U2F_MEDIA_NONE;
c0de0f04:	f640 11a4 	movw	r1, #2468	@ 0x9a4
c0de0f08:	f2c0 0100 	movt	r1, #0
    io_os_legacy_apdu_type = APDU_TYPE_NONE;
c0de0f0c:	f809 5004 	strb.w	r5, [r9, r4]
    G_io_u2f.media = U2F_MEDIA_NONE;
c0de0f10:	f809 5001 	strb.w	r5, [r9, r1]
#endif  // HAVE_IO_U2F

    return status;
c0de0f14:	bdb0      	pop	{r4, r5, r7, pc}

c0de0f16 <io_legacy_apdu_rx>:
{
c0de0f16:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
c0de0f1a:	b084      	sub	sp, #16
    status = os_io_rx_evt(G_io_rx_buffer, sizeof(G_io_rx_buffer), NULL, true);
c0de0f1c:	f240 178d 	movw	r7, #397	@ 0x18d
c0de0f20:	4606      	mov	r6, r0
c0de0f22:	2000      	movs	r0, #0
c0de0f24:	f2c0 0700 	movt	r7, #0
    os_io_apdu_post_action_t post_action = OS_IO_APDU_POST_ACTION_NONE;
c0de0f28:	f88d 000f 	strb.w	r0, [sp, #15]
    status = os_io_rx_evt(G_io_rx_buffer, sizeof(G_io_rx_buffer), NULL, true);
c0de0f2c:	eb09 0007 	add.w	r0, r9, r7
c0de0f30:	f240 1111 	movw	r1, #273	@ 0x111
c0de0f34:	2200      	movs	r2, #0
c0de0f36:	2301      	movs	r3, #1
c0de0f38:	f008 fe14 	bl	c0de9b64 <os_io_rx_evt>
c0de0f3c:	4604      	mov	r4, r0
    if (status > 0) {
c0de0f3e:	2801      	cmp	r0, #1
c0de0f40:	f2c0 810f 	blt.w	c0de1162 <io_legacy_apdu_rx+0x24c>
        switch (G_io_rx_buffer[0]) {
c0de0f44:	f819 0007 	ldrb.w	r0, [r9, r7]
c0de0f48:	2500      	movs	r5, #0
c0de0f4a:	282f      	cmp	r0, #47	@ 0x2f
c0de0f4c:	dc62      	bgt.n	c0de1014 <io_legacy_apdu_rx+0xfe>
c0de0f4e:	f1a0 0110 	sub.w	r1, r0, #16
c0de0f52:	2916      	cmp	r1, #22
c0de0f54:	d871      	bhi.n	c0de103a <io_legacy_apdu_rx+0x124>
c0de0f56:	2201      	movs	r2, #1
c0de0f58:	fa02 f101 	lsl.w	r1, r2, r1
c0de0f5c:	2201      	movs	r2, #1
c0de0f5e:	f2c0 027f 	movt	r2, #127	@ 0x7f
c0de0f62:	4211      	tst	r1, r2
c0de0f64:	d069      	beq.n	c0de103a <io_legacy_apdu_rx+0x124>
                io_os_legacy_apdu_type = G_io_rx_buffer[0];
c0de0f66:	f240 26ac 	movw	r6, #684	@ 0x2ac
c0de0f6a:	f2c0 0600 	movt	r6, #0
c0de0f6e:	f809 0006 	strb.w	r0, [r9, r6]
                if (os_perso_is_pin_set() == BOLOS_TRUE
c0de0f72:	f008 fd78 	bl	c0de9a66 <os_perso_is_pin_set>
                    && os_global_pin_is_validated() != BOLOS_TRUE) {
c0de0f76:	28aa      	cmp	r0, #170	@ 0xaa
c0de0f78:	d103      	bne.n	c0de0f82 <io_legacy_apdu_rx+0x6c>
c0de0f7a:	f008 fd7f 	bl	c0de9a7c <os_global_pin_is_validated>
                if (os_perso_is_pin_set() == BOLOS_TRUE
c0de0f7e:	28aa      	cmp	r0, #170	@ 0xaa
c0de0f80:	d175      	bne.n	c0de106e <io_legacy_apdu_rx+0x158>
                else if (G_io_rx_buffer[APDU_OFF_CLA + 1] == DEFAULT_APDU_CLA) {
c0de0f82:	eb09 0007 	add.w	r0, r9, r7
c0de0f86:	7840      	ldrb	r0, [r0, #1]
c0de0f88:	28b0      	cmp	r0, #176	@ 0xb0
c0de0f8a:	d137      	bne.n	c0de0ffc <io_legacy_apdu_rx+0xe6>
c0de0f8c:	f240 1011 	movw	r0, #273	@ 0x111
                    bolos_err_t err               = os_io_handle_default_apdu(&G_io_rx_buffer[1],
c0de0f90:	f240 087c 	movw	r8, #124	@ 0x7c
                    size_t      buffer_out_length = sizeof(G_io_rx_buffer);
c0de0f94:	9002      	str	r0, [sp, #8]
                    bolos_err_t err               = os_io_handle_default_apdu(&G_io_rx_buffer[1],
c0de0f96:	f2c0 0800 	movt	r8, #0
c0de0f9a:	eb09 0007 	add.w	r0, r9, r7
                                                                status - 1,
c0de0f9e:	1e61      	subs	r1, r4, #1
c0de0fa0:	f10d 050f 	add.w	r5, sp, #15
                    bolos_err_t err               = os_io_handle_default_apdu(&G_io_rx_buffer[1],
c0de0fa4:	eb09 0208 	add.w	r2, r9, r8
c0de0fa8:	3001      	adds	r0, #1
c0de0faa:	ab02      	add	r3, sp, #8
c0de0fac:	9500      	str	r5, [sp, #0]
c0de0fae:	f7ff fdbe 	bl	c0de0b2e <os_io_handle_default_apdu>
c0de0fb2:	4605      	mov	r5, r0
                    if (err != SWO_SUCCESS) {
c0de0fb4:	f5b0 4f10 	cmp.w	r0, #36864	@ 0x9000
c0de0fb8:	bf1c      	itt	ne
c0de0fba:	2000      	movne	r0, #0
                        buffer_out_length = 0;
c0de0fbc:	9002      	strne	r0, [sp, #8]
                    if (err == SWO_NO_RESPONSE) {
c0de0fbe:	b1c5      	cbz	r5, c0de0ff2 <io_legacy_apdu_rx+0xdc>
                    G_io_tx_buffer[buffer_out_length++] = err >> 8;
c0de0fc0:	9a02      	ldr	r2, [sp, #8]
c0de0fc2:	0a28      	lsrs	r0, r5, #8
c0de0fc4:	eb09 0108 	add.w	r1, r9, r8
c0de0fc8:	188b      	adds	r3, r1, r2
c0de0fca:	5488      	strb	r0, [r1, r2]
                    G_io_tx_buffer[buffer_out_length++] = err;
c0de0fcc:	3202      	adds	r2, #2
                        io_os_legacy_apdu_type, G_io_tx_buffer, buffer_out_length, 0);
c0de0fce:	f819 0006 	ldrb.w	r0, [r9, r6]
                    G_io_tx_buffer[buffer_out_length++] = err;
c0de0fd2:	9202      	str	r2, [sp, #8]
c0de0fd4:	705d      	strb	r5, [r3, #1]
                    status                              = os_io_tx_cmd(
c0de0fd6:	b292      	uxth	r2, r2
c0de0fd8:	2300      	movs	r3, #0
c0de0fda:	2400      	movs	r4, #0
c0de0fdc:	f008 fdb6 	bl	c0de9b4c <os_io_tx_cmd>
                    if (post_action == OS_IO_APDU_POST_ACTION_EXIT) {
c0de0fe0:	f89d 100f 	ldrb.w	r1, [sp, #15]
                    io_os_legacy_apdu_type = APDU_TYPE_NONE;
c0de0fe4:	f809 4006 	strb.w	r4, [r9, r6]
                    if (post_action == OS_IO_APDU_POST_ACTION_EXIT) {
c0de0fe8:	2901      	cmp	r1, #1
c0de0fea:	f000 80da 	beq.w	c0de11a2 <io_legacy_apdu_rx+0x28c>
                    if (status > 0) {
c0de0fee:	ea00 74e0 	and.w	r4, r0, r0, asr #31
c0de0ff2:	2d00      	cmp	r5, #0
c0de0ff4:	4625      	mov	r5, r4
c0de0ff6:	bf08      	it	eq
c0de0ff8:	2500      	moveq	r5, #0
c0de0ffa:	e0b3      	b.n	c0de1164 <io_legacy_apdu_rx+0x24e>
                    G_io_app.apdu_media = get_media_from_apdu_type(io_os_legacy_apdu_type);
c0de0ffc:	f819 6006 	ldrb.w	r6, [r9, r6]
    if (apdu_type == APDU_TYPE_RAW) {
c0de1000:	2e21      	cmp	r6, #33	@ 0x21
c0de1002:	dd4b      	ble.n	c0de109c <io_legacy_apdu_rx+0x186>
c0de1004:	2e2f      	cmp	r6, #47	@ 0x2f
c0de1006:	dc51      	bgt.n	c0de10ac <io_legacy_apdu_rx+0x196>
c0de1008:	2e22      	cmp	r6, #34	@ 0x22
c0de100a:	d05c      	beq.n	c0de10c6 <io_legacy_apdu_rx+0x1b0>
c0de100c:	2e23      	cmp	r6, #35	@ 0x23
c0de100e:	d162      	bne.n	c0de10d6 <io_legacy_apdu_rx+0x1c0>
c0de1010:	2007      	movs	r0, #7
c0de1012:	e061      	b.n	c0de10d8 <io_legacy_apdu_rx+0x1c2>
        switch (G_io_rx_buffer[0]) {
c0de1014:	2830      	cmp	r0, #48	@ 0x30
c0de1016:	d0a6      	beq.n	c0de0f66 <io_legacy_apdu_rx+0x50>
c0de1018:	2840      	cmp	r0, #64	@ 0x40
c0de101a:	d0a4      	beq.n	c0de0f66 <io_legacy_apdu_rx+0x50>
c0de101c:	2842      	cmp	r0, #66	@ 0x42
c0de101e:	f040 80a1 	bne.w	c0de1164 <io_legacy_apdu_rx+0x24e>
                memmove(G_io_apdu_buffer, &G_io_rx_buffer[1], status);
c0de1022:	f240 007c 	movw	r0, #124	@ 0x7c
c0de1026:	f2c0 0000 	movt	r0, #0
c0de102a:	eb09 0107 	add.w	r1, r9, r7
c0de102e:	4448      	add	r0, r9
c0de1030:	3101      	adds	r1, #1
c0de1032:	4622      	mov	r2, r4
c0de1034:	f008 feb8 	bl	c0de9da8 <__aeabi_memcpy>
c0de1038:	e093      	b.n	c0de1162 <io_legacy_apdu_rx+0x24c>
        switch (G_io_rx_buffer[0]) {
c0de103a:	3801      	subs	r0, #1
c0de103c:	2802      	cmp	r0, #2
c0de103e:	f080 8091 	bcs.w	c0de1164 <io_legacy_apdu_rx+0x24e>
                memcpy(G_io_seproxyhal_spi_buffer, &G_io_rx_buffer[1], status - 1);
c0de1042:	f640 0570 	movw	r5, #2160	@ 0x870
c0de1046:	3c01      	subs	r4, #1
c0de1048:	f2c0 0500 	movt	r5, #0
c0de104c:	444f      	add	r7, r9
c0de104e:	eb09 0005 	add.w	r0, r9, r5
c0de1052:	1c79      	adds	r1, r7, #1
c0de1054:	4622      	mov	r2, r4
c0de1056:	f008 fea7 	bl	c0de9da8 <__aeabi_memcpy>
                if (G_io_rx_buffer[1] == SEPROXYHAL_TAG_ITC_EVENT) {
c0de105a:	7878      	ldrb	r0, [r7, #1]
c0de105c:	281a      	cmp	r0, #26
c0de105e:	d12b      	bne.n	c0de10b8 <io_legacy_apdu_rx+0x1a2>
                    status = io_process_itc_ux_event(G_io_seproxyhal_spi_buffer, status - 1);
c0de1060:	eb09 0005 	add.w	r0, r9, r5
c0de1064:	4621      	mov	r1, r4
c0de1066:	f7ff fe8d 	bl	c0de0d84 <io_process_itc_ux_event>
c0de106a:	4605      	mov	r5, r0
c0de106c:	e07a      	b.n	c0de1164 <io_legacy_apdu_rx+0x24e>
                    G_io_tx_buffer[0] = err >> 8;
c0de106e:	f240 007c 	movw	r0, #124	@ 0x7c
c0de1072:	f2c0 0000 	movt	r0, #0
c0de1076:	2155      	movs	r1, #85	@ 0x55
c0de1078:	f809 1000 	strb.w	r1, [r9, r0]
c0de107c:	eb09 0100 	add.w	r1, r9, r0
c0de1080:	2215      	movs	r2, #21
                    status            = os_io_tx_cmd(io_os_legacy_apdu_type, G_io_tx_buffer, 2, 0);
c0de1082:	f819 0006 	ldrb.w	r0, [r9, r6]
                    G_io_tx_buffer[1] = err;
c0de1086:	704a      	strb	r2, [r1, #1]
                    status            = os_io_tx_cmd(io_os_legacy_apdu_type, G_io_tx_buffer, 2, 0);
c0de1088:	2202      	movs	r2, #2
c0de108a:	2300      	movs	r3, #0
c0de108c:	2400      	movs	r4, #0
c0de108e:	f008 fd5d 	bl	c0de9b4c <os_io_tx_cmd>
                    io_os_legacy_apdu_type = APDU_TYPE_NONE;
c0de1092:	f809 4006 	strb.w	r4, [r9, r6]
                    if (status > 0) {
c0de1096:	ea00 75e0 	and.w	r5, r0, r0, asr #31
c0de109a:	e063      	b.n	c0de1164 <io_legacy_apdu_rx+0x24e>
    if (apdu_type == APDU_TYPE_RAW) {
c0de109c:	2e10      	cmp	r6, #16
c0de109e:	d014      	beq.n	c0de10ca <io_legacy_apdu_rx+0x1b4>
c0de10a0:	2e20      	cmp	r6, #32
c0de10a2:	d014      	beq.n	c0de10ce <io_legacy_apdu_rx+0x1b8>
c0de10a4:	2e21      	cmp	r6, #33	@ 0x21
c0de10a6:	d116      	bne.n	c0de10d6 <io_legacy_apdu_rx+0x1c0>
c0de10a8:	2005      	movs	r0, #5
c0de10aa:	e015      	b.n	c0de10d8 <io_legacy_apdu_rx+0x1c2>
c0de10ac:	2e30      	cmp	r6, #48	@ 0x30
c0de10ae:	d010      	beq.n	c0de10d2 <io_legacy_apdu_rx+0x1bc>
c0de10b0:	2e40      	cmp	r6, #64	@ 0x40
c0de10b2:	d110      	bne.n	c0de10d6 <io_legacy_apdu_rx+0x1c0>
c0de10b4:	2003      	movs	r0, #3
c0de10b6:	e00f      	b.n	c0de10d8 <io_legacy_apdu_rx+0x1c2>
                    if (!handle_ux_events) {
c0de10b8:	2e00      	cmp	r6, #0
c0de10ba:	d062      	beq.n	c0de1182 <io_legacy_apdu_rx+0x26c>
c0de10bc:	2000      	movs	r0, #0
c0de10be:	2500      	movs	r5, #0
c0de10c0:	f007 fa4d 	bl	c0de855e <io_event>
c0de10c4:	e04e      	b.n	c0de1164 <io_legacy_apdu_rx+0x24e>
c0de10c6:	2004      	movs	r0, #4
c0de10c8:	e006      	b.n	c0de10d8 <io_legacy_apdu_rx+0x1c2>
c0de10ca:	2006      	movs	r0, #6
c0de10cc:	e004      	b.n	c0de10d8 <io_legacy_apdu_rx+0x1c2>
c0de10ce:	2001      	movs	r0, #1
c0de10d0:	e002      	b.n	c0de10d8 <io_legacy_apdu_rx+0x1c2>
c0de10d2:	2002      	movs	r0, #2
c0de10d4:	e000      	b.n	c0de10d8 <io_legacy_apdu_rx+0x1c2>
c0de10d6:	2000      	movs	r0, #0
                    G_io_app.apdu_media = get_media_from_apdu_type(io_os_legacy_apdu_type);
c0de10d8:	f240 28a0 	movw	r8, #672	@ 0x2a0
c0de10dc:	f2c0 0800 	movt	r8, #0
c0de10e0:	eb09 0108 	add.w	r1, r9, r8
c0de10e4:	7188      	strb	r0, [r1, #6]
                    memmove(G_io_apdu_buffer, &G_io_rx_buffer[1], status);
c0de10e6:	f240 007c 	movw	r0, #124	@ 0x7c
                    status -= 1;
c0de10ea:	1e65      	subs	r5, r4, #1
                    memmove(G_io_apdu_buffer, &G_io_rx_buffer[1], status);
c0de10ec:	f2c0 0000 	movt	r0, #0
c0de10f0:	eb09 0107 	add.w	r1, r9, r7
c0de10f4:	4448      	add	r0, r9
c0de10f6:	3101      	adds	r1, #1
c0de10f8:	462a      	mov	r2, r5
c0de10fa:	f008 fe55 	bl	c0de9da8 <__aeabi_memcpy>
                    if (io_os_legacy_apdu_type == APDU_TYPE_USB_HID) {
c0de10fe:	2e23      	cmp	r6, #35	@ 0x23
c0de1100:	dd0b      	ble.n	c0de111a <io_legacy_apdu_rx+0x204>
c0de1102:	2e24      	cmp	r6, #36	@ 0x24
c0de1104:	d018      	beq.n	c0de1138 <io_legacy_apdu_rx+0x222>
c0de1106:	2e25      	cmp	r6, #37	@ 0x25
c0de1108:	d021      	beq.n	c0de114e <io_legacy_apdu_rx+0x238>
c0de110a:	2e40      	cmp	r6, #64	@ 0x40
c0de110c:	d12a      	bne.n	c0de1164 <io_legacy_apdu_rx+0x24e>
                        G_io_u2f.media      = U2F_MEDIA_NFC;
c0de110e:	f640 10a4 	movw	r0, #2468	@ 0x9a4
c0de1112:	f2c0 0000 	movt	r0, #0
c0de1116:	2102      	movs	r1, #2
c0de1118:	e008      	b.n	c0de112c <io_legacy_apdu_rx+0x216>
                    if (io_os_legacy_apdu_type == APDU_TYPE_USB_HID) {
c0de111a:	2e20      	cmp	r6, #32
c0de111c:	d026      	beq.n	c0de116c <io_legacy_apdu_rx+0x256>
c0de111e:	2e23      	cmp	r6, #35	@ 0x23
c0de1120:	d120      	bne.n	c0de1164 <io_legacy_apdu_rx+0x24e>
                        G_io_u2f.media      = U2F_MEDIA_USB;
c0de1122:	f640 10a4 	movw	r0, #2468	@ 0x9a4
c0de1126:	f2c0 0000 	movt	r0, #0
c0de112a:	2101      	movs	r1, #1
c0de112c:	f809 1000 	strb.w	r1, [r9, r0]
c0de1130:	200a      	movs	r0, #10
c0de1132:	f809 0008 	strb.w	r0, [r9, r8]
c0de1136:	e015      	b.n	c0de1164 <io_legacy_apdu_rx+0x24e>
                        G_io_u2f.media      = U2F_MEDIA_USB;
c0de1138:	f640 10a4 	movw	r0, #2468	@ 0x9a4
c0de113c:	f2c0 0000 	movt	r0, #0
c0de1140:	2101      	movs	r1, #1
c0de1142:	f809 1000 	strb.w	r1, [r9, r0]
c0de1146:	200b      	movs	r0, #11
                        G_io_app.apdu_state = APDU_U2F_CBOR;
c0de1148:	f809 0008 	strb.w	r0, [r9, r8]
c0de114c:	e00a      	b.n	c0de1164 <io_legacy_apdu_rx+0x24e>
                        G_io_u2f.media      = U2F_MEDIA_USB;
c0de114e:	f640 10a4 	movw	r0, #2468	@ 0x9a4
c0de1152:	f2c0 0000 	movt	r0, #0
c0de1156:	2101      	movs	r1, #1
c0de1158:	f809 1000 	strb.w	r1, [r9, r0]
c0de115c:	200c      	movs	r0, #12
                        G_io_app.apdu_state = APDU_U2F_CANCEL;
c0de115e:	f809 0008 	strb.w	r0, [r9, r8]
c0de1162:	4625      	mov	r5, r4
}
c0de1164:	4628      	mov	r0, r5
c0de1166:	b004      	add	sp, #16
c0de1168:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
                        G_io_u2f.media      = U2F_MEDIA_USB;
c0de116c:	f640 10a4 	movw	r0, #2468	@ 0x9a4
c0de1170:	f2c0 0000 	movt	r0, #0
c0de1174:	2101      	movs	r1, #1
c0de1176:	f809 1000 	strb.w	r1, [r9, r0]
c0de117a:	2008      	movs	r0, #8
                        G_io_app.apdu_state = APDU_USB_HID;
c0de117c:	f809 0008 	strb.w	r0, [r9, r8]
c0de1180:	e7f0      	b.n	c0de1164 <io_legacy_apdu_rx+0x24e>
                        if ((G_io_seproxyhal_spi_buffer[0] != SEPROXYHAL_TAG_FINGER_EVENT)
c0de1182:	f819 0005 	ldrb.w	r0, [r9, r5]
                            && (G_io_seproxyhal_spi_buffer[0] != SEPROXYHAL_TAG_BUTTON_PUSH_EVENT)
c0de1186:	2815      	cmp	r0, #21
c0de1188:	d898      	bhi.n	c0de10bc <io_legacy_apdu_rx+0x1a6>
c0de118a:	2101      	movs	r1, #1
c0de118c:	fa01 f000 	lsl.w	r0, r1, r0
c0de1190:	f245 0120 	movw	r1, #20512	@ 0x5020
c0de1194:	f2c0 0120 	movt	r1, #32
c0de1198:	4208      	tst	r0, r1
c0de119a:	f43f af8f 	beq.w	c0de10bc <io_legacy_apdu_rx+0x1a6>
c0de119e:	2500      	movs	r5, #0
c0de11a0:	e7e0      	b.n	c0de1164 <io_legacy_apdu_rx+0x24e>
                        os_sched_exit(-1);
c0de11a2:	20ff      	movs	r0, #255	@ 0xff
c0de11a4:	f008 fca4 	bl	c0de9af0 <os_sched_exit>

c0de11a8 <io_seproxyhal_init>:
{
c0de11a8:	b510      	push	{r4, lr}
c0de11aa:	b08a      	sub	sp, #40	@ 0x28
    io_os_legacy_apdu_type = APDU_TYPE_NONE;
c0de11ac:	f240 20ac 	movw	r0, #684	@ 0x2ac
c0de11b0:	f2c0 0000 	movt	r0, #0
c0de11b4:	2100      	movs	r1, #0
c0de11b6:	f809 1000 	strb.w	r1, [r9, r0]
c0de11ba:	2015      	movs	r0, #21
c0de11bc:	f2c0 0002 	movt	r0, #2
    init_io.usb.class_mask |= USBD_LEDGER_CLASS_HID_U2F;
c0de11c0:	9007      	str	r0, [sp, #28]
c0de11c2:	2401      	movs	r4, #1
c0de11c4:	a801      	add	r0, sp, #4
    init_io.usb.vid        = 0;
c0de11c6:	e9cd 1101 	strd	r1, r1, [sp, #4]
c0de11ca:	e9cd 1103 	strd	r1, r1, [sp, #12]
c0de11ce:	e9cd 1105 	strd	r1, r1, [sp, #20]
    init_io.usb.hid_u2f_settings.minor_device_version_number = 1;
c0de11d2:	f8ad 4020 	strh.w	r4, [sp, #32]
    init_io.usb.hid_u2f_settings.capabilities_flag = 0;
c0de11d6:	f88d 1022 	strb.w	r1, [sp, #34]	@ 0x22
    init_io.ble.profile_mask = BLE_LEDGER_PROFILE_APDU;
c0de11da:	f8ad 4024 	strh.w	r4, [sp, #36]	@ 0x24
    os_io_init(&init_io);
c0de11de:	f008 fc92 	bl	c0de9b06 <os_io_init>
    need_to_start_io = 1;
c0de11e2:	f240 209e 	movw	r0, #670	@ 0x29e
c0de11e6:	f2c0 0000 	movt	r0, #0
c0de11ea:	f809 4000 	strb.w	r4, [r9, r0]
}
c0de11ee:	b00a      	add	sp, #40	@ 0x28
c0de11f0:	bd10      	pop	{r4, pc}

c0de11f2 <layoutAddCallbackObj>:
// configuring it
layoutObj_t *layoutAddCallbackObj(nbgl_layoutInternal_t *layout,
                                  nbgl_obj_t            *obj,
                                  uint8_t                token,
                                  tune_index_e           tuneId)
{
c0de11f2:	b510      	push	{r4, lr}
    layoutObj_t *layoutObj = NULL;

    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de11f4:	f890 c0ad 	ldrb.w	ip, [r0, #173]	@ 0xad
c0de11f8:	f890 e0ae 	ldrb.w	lr, [r0, #174]	@ 0xae
c0de11fc:	ea4c 2e0e 	orr.w	lr, ip, lr, lsl #8
c0de1200:	f3ce 2c05 	ubfx	ip, lr, #8, #6
c0de1204:	f1bc 0f0e 	cmp.w	ip, #14
c0de1208:	bf84      	itt	hi
c0de120a:	2000      	movhi	r0, #0
    }
    else {
        LOG_FATAL(LAYOUT_LOGGER, "layoutAddCallbackObj: no more callback obj\n");
    }

    return layoutObj;
c0de120c:	bd10      	pophi	{r4, pc}
c0de120e:	ea4f 241e 	mov.w	r4, lr, lsr #8
        layoutObj = &layout->callbackObjPool[layout->nbUsedCallbackObjs];
c0de1212:	eb00 0ccc 	add.w	ip, r0, ip, lsl #3
        layoutObj->obj    = obj;
c0de1216:	f84c 1f20 	str.w	r1, [ip, #32]!
        layout->nbUsedCallbackObjs++;
c0de121a:	1c61      	adds	r1, r4, #1
c0de121c:	f001 013f 	and.w	r1, r1, #63	@ 0x3f
c0de1220:	f40e 4440 	and.w	r4, lr, #49152	@ 0xc000
c0de1224:	ea44 2101 	orr.w	r1, r4, r1, lsl #8
c0de1228:	0a09      	lsrs	r1, r1, #8
c0de122a:	f880 10ae 	strb.w	r1, [r0, #174]	@ 0xae
c0de122e:	f880 e0ad 	strb.w	lr, [r0, #173]	@ 0xad
    return layoutObj;
c0de1232:	4660      	mov	r0, ip
        layoutObj->token  = token;
c0de1234:	f88c 2004 	strb.w	r2, [ip, #4]
        layoutObj->tuneId = tuneId;
c0de1238:	f88c 3006 	strb.w	r3, [ip, #6]
    return layoutObj;
c0de123c:	bd10      	pop	{r4, pc}
	...

c0de1240 <nbgl_layoutGet>:
 *
 * @param description description of layout
 * @return a pointer to the corresponding layout
 */
nbgl_layout_t *nbgl_layoutGet(const nbgl_layoutDescription_t *description)
{
c0de1240:	e92d 45f0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, lr}
c0de1244:	b085      	sub	sp, #20
c0de1246:	4605      	mov	r5, r0
    nbgl_layoutInternal_t *layout = NULL;

    if (description->modal) {
c0de1248:	7800      	ldrb	r0, [r0, #0]
c0de124a:	f240 26b0 	movw	r6, #688	@ 0x2b0
c0de124e:	f2c0 0600 	movt	r6, #0
c0de1252:	b320      	cbz	r0, c0de129e <nbgl_layoutGet+0x5e>
c0de1254:	f64f 6098 	movw	r0, #65176	@ 0xfe98
c0de1258:	2400      	movs	r4, #0
c0de125a:	f6cf 70ff 	movt	r0, #65535	@ 0xffff
c0de125e:	bf00      	nop
        int i;
        // find an empty layout in the array of layouts (0 is reserved for background)
        for (i = 1; i < NB_MAX_LAYOUTS; i++) {
            if (!gLayout[i].isUsed) {
c0de1260:	eb09 0106 	add.w	r1, r9, r6
c0de1264:	4401      	add	r1, r0
c0de1266:	f891 22ca 	ldrb.w	r2, [r1, #714]	@ 0x2ca
c0de126a:	0212      	lsls	r2, r2, #8
c0de126c:	0452      	lsls	r2, r2, #17
c0de126e:	bf58      	it	pl
c0de1270:	f501 7407 	addpl.w	r4, r1, #540	@ 0x21c
        for (i = 1; i < NB_MAX_LAYOUTS; i++) {
c0de1274:	30b4      	adds	r0, #180	@ 0xb4
c0de1276:	d1f3      	bne.n	c0de1260 <nbgl_layoutGet+0x20>
        layout = &gLayout[0];
        if (topLayout == NULL) {
            topLayout = layout;
        }
    }
    if (layout == NULL) {
c0de1278:	b1fc      	cbz	r4, c0de12ba <nbgl_layoutGet+0x7a>
        LOG_WARN(LAYOUT_LOGGER, "nbgl_layoutGet(): impossible to get a layout!\n");
        return NULL;
    }

    // reset globals
    nbgl_layoutInternal_t *backgroundTop = gLayout[0].top;
c0de127a:	f859 7006 	ldr.w	r7, [r9, r6]
    memset(layout, 0, sizeof(nbgl_layoutInternal_t));
c0de127e:	4620      	mov	r0, r4
c0de1280:	21b4      	movs	r1, #180	@ 0xb4
c0de1282:	f008 fd9b 	bl	c0de9dbc <__aeabi_memclr>
    // link layout to other ones
    if (description->modal) {
c0de1286:	7828      	ldrb	r0, [r5, #0]
c0de1288:	b1c8      	cbz	r0, c0de12be <nbgl_layoutGet+0x7e>
        if (topLayout != NULL) {
c0de128a:	f240 40cc 	movw	r0, #1228	@ 0x4cc
c0de128e:	f2c0 0000 	movt	r0, #0
c0de1292:	f859 1000 	ldr.w	r1, [r9, r0]
c0de1296:	b1a9      	cbz	r1, c0de12c4 <nbgl_layoutGet+0x84>
            // if topLayout already existing, push this new one on top of it
            topLayout->top = layout;
c0de1298:	600c      	str	r4, [r1, #0]
            layout->bottom = topLayout;
c0de129a:	6061      	str	r1, [r4, #4]
c0de129c:	e017      	b.n	c0de12ce <nbgl_layoutGet+0x8e>
        if (topLayout == NULL) {
c0de129e:	f240 40cc 	movw	r0, #1228	@ 0x4cc
c0de12a2:	f2c0 0000 	movt	r0, #0
c0de12a6:	f859 1000 	ldr.w	r1, [r9, r0]
            topLayout = layout;
c0de12aa:	eb09 0406 	add.w	r4, r9, r6
        if (topLayout == NULL) {
c0de12ae:	2900      	cmp	r1, #0
            topLayout = layout;
c0de12b0:	bf08      	it	eq
c0de12b2:	f849 4000 	streq.w	r4, [r9, r0]
    if (layout == NULL) {
c0de12b6:	2c00      	cmp	r4, #0
c0de12b8:	d1df      	bne.n	c0de127a <nbgl_layoutGet+0x3a>
c0de12ba:	2400      	movs	r4, #0
c0de12bc:	e0b1      	b.n	c0de1422 <nbgl_layoutGet+0x1e2>
        }
        topLayout = layout;
    }
    else {
        // restore potentially valid background top layer
        gLayout[0].top = backgroundTop;
c0de12be:	f849 7006 	str.w	r7, [r9, r6]
c0de12c2:	e006      	b.n	c0de12d2 <nbgl_layoutGet+0x92>
            layout->bottom = &gLayout[0];
c0de12c4:	eb09 0106 	add.w	r1, r9, r6
c0de12c8:	6061      	str	r1, [r4, #4]
            gLayout[0].top = layout;
c0de12ca:	f849 4006 	str.w	r4, [r9, r6]
        topLayout = layout;
c0de12ce:	f849 4000 	str.w	r4, [r9, r0]
    }

    nbTouchableControls = 0;
c0de12d2:	f240 41d0 	movw	r1, #1232	@ 0x4d0

    layout->callback       = (nbgl_layoutTouchCallback_t) PIC(description->onActionCallback);
c0de12d6:	68e8      	ldr	r0, [r5, #12]
    nbTouchableControls = 0;
c0de12d8:	f2c0 0100 	movt	r1, #0
c0de12dc:	2200      	movs	r2, #0
c0de12de:	f809 2001 	strb.w	r2, [r9, r1]
    layout->callback       = (nbgl_layoutTouchCallback_t) PIC(description->onActionCallback);
c0de12e2:	f008 fb67 	bl	c0de99b4 <pic>
    layout->modal          = description->modal;
c0de12e6:	4621      	mov	r1, r4
c0de12e8:	f811 2fad 	ldrb.w	r2, [r1, #173]!
    layout->callback       = (nbgl_layoutTouchCallback_t) PIC(description->onActionCallback);
c0de12ec:	f841 0c91 	str.w	r0, [r1, #-145]
    layout->modal          = description->modal;
c0de12f0:	7848      	ldrb	r0, [r1, #1]
c0de12f2:	782b      	ldrb	r3, [r5, #0]
c0de12f4:	ea42 2200 	orr.w	r2, r2, r0, lsl #8
c0de12f8:	f022 0201 	bic.w	r2, r2, #1
c0de12fc:	431a      	orrs	r2, r3
c0de12fe:	700a      	strb	r2, [r1, #0]
    layout->withLeftBorder = description->withLeftBorder;
c0de1300:	786b      	ldrb	r3, [r5, #1]
c0de1302:	f002 02fd 	and.w	r2, r2, #253	@ 0xfd
c0de1306:	ea42 0243 	orr.w	r2, r2, r3, lsl #1
c0de130a:	7048      	strb	r0, [r1, #1]
c0de130c:	700a      	strb	r2, [r1, #0]
    if (description->modal) {
c0de130e:	782a      	ldrb	r2, [r5, #0]
                                        NB_MAX_SCREEN_CHILDREN,
                                        &description->ticker,
                                        (nbgl_touchCallback_t) touchCallback);
    }
    else {
        nbgl_screenSet(&layout->children,
c0de1310:	f240 1307 	movw	r3, #263	@ 0x107
c0de1314:	f2c0 0300 	movt	r3, #0
c0de1318:	f1a1 00a5 	sub.w	r0, r1, #165	@ 0xa5
    if (description->modal) {
c0de131c:	2a00      	cmp	r2, #0
c0de131e:	f105 0210 	add.w	r2, r5, #16
        nbgl_screenSet(&layout->children,
c0de1322:	447b      	add	r3, pc
c0de1324:	f04f 0106 	mov.w	r1, #6
    if (description->modal) {
c0de1328:	d00a      	beq.n	c0de1340 <nbgl_layoutGet+0x100>
        layout->layer = nbgl_screenPush(&layout->children,
c0de132a:	f007 fc03 	bl	c0de8b34 <nbgl_screenPush>
c0de132e:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de1332:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de1336:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de133a:	f360 01c7 	bfi	r1, r0, #3, #5
c0de133e:	e009      	b.n	c0de1354 <nbgl_layoutGet+0x114>
        nbgl_screenSet(&layout->children,
c0de1340:	f007 fbf3 	bl	c0de8b2a <nbgl_screenSet>
                       NB_MAX_SCREEN_CHILDREN,
                       &description->ticker,
                       (nbgl_touchCallback_t) touchCallback);
        layout->layer = 0;
c0de1344:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1348:	f894 10ae 	ldrb.w	r1, [r4, #174]	@ 0xae
c0de134c:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de1350:	f020 01f8 	bic.w	r1, r0, #248	@ 0xf8
c0de1354:	4627      	mov	r7, r4
c0de1356:	f807 1fad 	strb.w	r1, [r7, #173]!
c0de135a:	0a08      	lsrs	r0, r1, #8
c0de135c:	7078      	strb	r0, [r7, #1]
    }
    layout->container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layout->layer);
c0de135e:	b2c8      	uxtb	r0, r1
c0de1360:	08c1      	lsrs	r1, r0, #3
c0de1362:	2001      	movs	r0, #1
c0de1364:	f04f 0a01 	mov.w	sl, #1
c0de1368:	f007 fbfd 	bl	c0de8b66 <nbgl_objPoolGet>
c0de136c:	21e0      	movs	r1, #224	@ 0xe0
c0de136e:	f847 0c0d 	str.w	r0, [r7, #-13]
    layout->container->obj.area.width  = SCREEN_WIDTH;
c0de1372:	7101      	strb	r1, [r0, #4]
c0de1374:	2102      	movs	r1, #2
    layout->container->obj.area.height = SCREEN_HEIGHT;
c0de1376:	71c1      	strb	r1, [r0, #7]
c0de1378:	2158      	movs	r1, #88	@ 0x58
c0de137a:	f04f 0800 	mov.w	r8, #0
    layout->container->obj.area.width  = SCREEN_WIDTH;
c0de137e:	f880 a005 	strb.w	sl, [r0, #5]
    layout->container->obj.area.height = SCREEN_HEIGHT;
c0de1382:	7181      	strb	r1, [r0, #6]
    layout->container->layout          = VERTICAL;
c0de1384:	f880 8020 	strb.w	r8, [r0, #32]
    layout->container->children = nbgl_containerPoolGet(NB_MAX_CONTAINER_CHILDREN, layout->layer);
c0de1388:	7838      	ldrb	r0, [r7, #0]
c0de138a:	08c1      	lsrs	r1, r0, #3
c0de138c:	2014      	movs	r0, #20
c0de138e:	f007 fbef 	bl	c0de8b70 <nbgl_containerPoolGet>
c0de1392:	f857 2c0d 	ldr.w	r2, [r7, #-13]
c0de1396:	0a03      	lsrs	r3, r0, #8
    // by default, if no header, main container is aligned on top-left
    layout->container->obj.alignment = TOP_LEFT;
    // main container is always the second object, leaving space for header
    layout->children[MAIN_CONTAINER_INDEX] = (nbgl_obj_t *) layout->container;
c0de1398:	f857 1ca5 	ldr.w	r1, [r7, #-165]
    layout->container->children = nbgl_containerPoolGet(NB_MAX_CONTAINER_CHILDREN, layout->layer);
c0de139c:	7753      	strb	r3, [r2, #29]
c0de139e:	4613      	mov	r3, r2
c0de13a0:	f803 0f1c 	strb.w	r0, [r3, #28]!
c0de13a4:	0e06      	lsrs	r6, r0, #24
c0de13a6:	0c00      	lsrs	r0, r0, #16
c0de13a8:	70de      	strb	r6, [r3, #3]
c0de13aa:	7098      	strb	r0, [r3, #2]
    layout->container->obj.alignment = TOP_LEFT;
c0de13ac:	f882 a00b 	strb.w	sl, [r2, #11]
    layout->children[MAIN_CONTAINER_INDEX] = (nbgl_obj_t *) layout->container;
c0de13b0:	604a      	str	r2, [r1, #4]
    layout->isUsed                         = true;
c0de13b2:	7878      	ldrb	r0, [r7, #1]
c0de13b4:	f040 0040 	orr.w	r0, r0, #64	@ 0x40
c0de13b8:	7078      	strb	r0, [r7, #1]

    // if a tap text is defined, make the container tapable and display this text in gray
    if (description->tapActionText != NULL) {
c0de13ba:	6868      	ldr	r0, [r5, #4]
c0de13bc:	b388      	cbz	r0, c0de1422 <nbgl_layoutGet+0x1e2>
        layoutObj_t *obj;
        const char  *tapActionText = PIC(description->tapActionText);
c0de13be:	f008 faf9 	bl	c0de99b4 <pic>

        obj = &layout->callbackObjPool[layout->nbUsedCallbackObjs];
c0de13c2:	4621      	mov	r1, r4
c0de13c4:	f811 2fad 	ldrb.w	r2, [r1, #173]!
c0de13c8:	f44f 4740 	mov.w	r7, #49152	@ 0xc000
c0de13cc:	784b      	ldrb	r3, [r1, #1]
        layout->nbUsedCallbackObjs++;
c0de13ce:	700a      	strb	r2, [r1, #0]
c0de13d0:	1c5e      	adds	r6, r3, #1
        obj = &layout->callbackObjPool[layout->nbUsedCallbackObjs];
c0de13d2:	f003 0c3f 	and.w	ip, r3, #63	@ 0x3f
        layout->nbUsedCallbackObjs++;
c0de13d6:	f006 063f 	and.w	r6, r6, #63	@ 0x3f
c0de13da:	ea07 2303 	and.w	r3, r7, r3, lsl #8
c0de13de:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de13e2:	0a1b      	lsrs	r3, r3, #8
        obj->obj                         = (nbgl_obj_t *) layout->container;
c0de13e4:	f8d4 70a0 	ldr.w	r7, [r4, #160]	@ 0xa0
        layout->nbUsedCallbackObjs++;
c0de13e8:	704b      	strb	r3, [r1, #1]
        obj->obj                         = (nbgl_obj_t *) layout->container;
c0de13ea:	eb04 03cc 	add.w	r3, r4, ip, lsl #3
c0de13ee:	621f      	str	r7, [r3, #32]
        obj->token                       = description->tapActionToken;
c0de13f0:	7a29      	ldrb	r1, [r5, #8]
        obj->tuneId                      = description->tapTuneId;
c0de13f2:	7a6a      	ldrb	r2, [r5, #9]
        obj->token                       = description->tapActionToken;
c0de13f4:	f883 1024 	strb.w	r1, [r3, #36]	@ 0x24
        obj->tuneId                      = description->tapTuneId;
c0de13f8:	f883 2026 	strb.w	r2, [r3, #38]	@ 0x26
c0de13fc:	2304      	movs	r3, #4
        layout->container->obj.touchMask = (1 << TOUCHED);
c0de13fe:	f887 a018 	strb.w	sl, [r7, #24]
c0de1402:	f887 8019 	strb.w	r8, [r7, #25]
        layout->container->obj.touchId   = WHOLE_SCREEN_ID;
c0de1406:	76bb      	strb	r3, [r7, #26]

        if (strlen(tapActionText) > 0) {
c0de1408:	7807      	ldrb	r7, [r0, #0]
c0de140a:	b157      	cbz	r7, c0de1422 <nbgl_layoutGet+0x1e2>
            nbgl_layoutUpFooter_t footerDesc;
            footerDesc.type        = UP_FOOTER_TEXT;
            footerDesc.text.text   = tapActionText;
c0de140c:	9001      	str	r0, [sp, #4]
            footerDesc.text.token  = description->tapActionToken;
c0de140e:	f88d 1008 	strb.w	r1, [sp, #8]
c0de1412:	4669      	mov	r1, sp
            footerDesc.text.tuneId = description->tapTuneId;
            nbgl_layoutAddUpFooter((nbgl_layout_t *) layout, &footerDesc);
c0de1414:	4620      	mov	r0, r4
            footerDesc.type        = UP_FOOTER_TEXT;
c0de1416:	f88d 3000 	strb.w	r3, [sp]
            footerDesc.text.tuneId = description->tapTuneId;
c0de141a:	f88d 2009 	strb.w	r2, [sp, #9]
            nbgl_layoutAddUpFooter((nbgl_layout_t *) layout, &footerDesc);
c0de141e:	f000 fa3d 	bl	c0de189c <nbgl_layoutAddUpFooter>
        }
    }
    return (nbgl_layout_t *) layout;
}
c0de1422:	4620      	mov	r0, r4
c0de1424:	b005      	add	sp, #20
c0de1426:	e8bd 85f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, pc}
	...

c0de142c <touchCallback>:
{
c0de142c:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
    if (obj == NULL) {
c0de1430:	2800      	cmp	r0, #0
c0de1432:	f000 8231 	beq.w	c0de1898 <touchCallback+0x46c>
c0de1436:	4604      	mov	r4, r0
    if ((topLayout) && (topLayout->isUsed)) {
c0de1438:	f240 40cc 	movw	r0, #1228	@ 0x4cc
c0de143c:	f2c0 0000 	movt	r0, #0
c0de1440:	f859 0000 	ldr.w	r0, [r9, r0]
c0de1444:	468a      	mov	sl, r1
c0de1446:	b308      	cbz	r0, c0de148c <touchCallback+0x60>
c0de1448:	f890 10ad 	ldrb.w	r1, [r0, #173]	@ 0xad
c0de144c:	f890 20ae 	ldrb.w	r2, [r0, #174]	@ 0xae
c0de1450:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de1454:	044a      	lsls	r2, r1, #17
c0de1456:	d519      	bpl.n	c0de148c <touchCallback+0x60>
c0de1458:	f3c1 2205 	ubfx	r2, r1, #8, #6
        for (j = 0; j < topLayout->nbUsedCallbackObjs; j++) {
c0de145c:	2a00      	cmp	r2, #0
c0de145e:	4613      	mov	r3, r2
c0de1460:	bf18      	it	ne
c0de1462:	2301      	movne	r3, #1
c0de1464:	b192      	cbz	r2, c0de148c <touchCallback+0x60>
            if (obj == topLayout->callbackObjPool[j].obj) {
c0de1466:	6a01      	ldr	r1, [r0, #32]
c0de1468:	42a1      	cmp	r1, r4
c0de146a:	d064      	beq.n	c0de1536 <touchCallback+0x10a>
        for (j = 0; j < topLayout->nbUsedCallbackObjs; j++) {
c0de146c:	1e53      	subs	r3, r2, #1
c0de146e:	f100 0728 	add.w	r7, r0, #40	@ 0x28
c0de1472:	2100      	movs	r1, #0
c0de1474:	428b      	cmp	r3, r1
c0de1476:	d009      	beq.n	c0de148c <touchCallback+0x60>
            if (obj == topLayout->callbackObjPool[j].obj) {
c0de1478:	f857 6031 	ldr.w	r6, [r7, r1, lsl #3]
c0de147c:	3101      	adds	r1, #1
c0de147e:	42a6      	cmp	r6, r4
c0de1480:	d1f8      	bne.n	c0de1474 <touchCallback+0x48>
c0de1482:	2300      	movs	r3, #0
c0de1484:	4291      	cmp	r1, r2
c0de1486:	bf38      	it	cc
c0de1488:	2301      	movcc	r3, #1
c0de148a:	e055      	b.n	c0de1538 <touchCallback+0x10c>
c0de148c:	2700      	movs	r7, #0
c0de148e:	2100      	movs	r1, #0
    if (getLayoutAndLayoutObj(obj, &layout, &layoutObj) == false) {
c0de1490:	bba1      	cbnz	r1, c0de14fc <touchCallback+0xd0>
    if ((topLayout) && (topLayout->isUsed)) {
c0de1492:	b368      	cbz	r0, c0de14f0 <touchCallback+0xc4>
c0de1494:	f890 10ad 	ldrb.w	r1, [r0, #173]	@ 0xad
c0de1498:	f890 20ae 	ldrb.w	r2, [r0, #174]	@ 0xae
c0de149c:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de14a0:	044a      	lsls	r2, r1, #17
c0de14a2:	d525      	bpl.n	c0de14f0 <touchCallback+0xc4>
c0de14a4:	f3c1 2105 	ubfx	r1, r1, #8, #6
        for (j = 0; j < topLayout->nbUsedCallbackObjs; j++) {
c0de14a8:	2900      	cmp	r1, #0
c0de14aa:	460a      	mov	r2, r1
c0de14ac:	bf18      	it	ne
c0de14ae:	2201      	movne	r2, #1
c0de14b0:	d01e      	beq.n	c0de14f0 <touchCallback+0xc4>
c0de14b2:	4623      	mov	r3, r4
c0de14b4:	f813 7f0c 	ldrb.w	r7, [r3, #12]!
c0de14b8:	785e      	ldrb	r6, [r3, #1]
c0de14ba:	789d      	ldrb	r5, [r3, #2]
c0de14bc:	78db      	ldrb	r3, [r3, #3]
c0de14be:	ea47 2706 	orr.w	r7, r7, r6, lsl #8
c0de14c2:	ea45 2303 	orr.w	r3, r5, r3, lsl #8
            if (obj == topLayout->callbackObjPool[j].obj) {
c0de14c6:	6a06      	ldr	r6, [r0, #32]
c0de14c8:	ea47 4703 	orr.w	r7, r7, r3, lsl #16
c0de14cc:	42be      	cmp	r6, r7
c0de14ce:	d03f      	beq.n	c0de1550 <touchCallback+0x124>
        for (j = 0; j < topLayout->nbUsedCallbackObjs; j++) {
c0de14d0:	1e4a      	subs	r2, r1, #1
c0de14d2:	f100 0628 	add.w	r6, r0, #40	@ 0x28
c0de14d6:	2300      	movs	r3, #0
c0de14d8:	429a      	cmp	r2, r3
c0de14da:	d009      	beq.n	c0de14f0 <touchCallback+0xc4>
            if (obj == topLayout->callbackObjPool[j].obj) {
c0de14dc:	f856 5033 	ldr.w	r5, [r6, r3, lsl #3]
c0de14e0:	3301      	adds	r3, #1
c0de14e2:	42bd      	cmp	r5, r7
c0de14e4:	d1f8      	bne.n	c0de14d8 <touchCallback+0xac>
c0de14e6:	2200      	movs	r2, #0
c0de14e8:	428b      	cmp	r3, r1
c0de14ea:	bf38      	it	cc
c0de14ec:	2201      	movcc	r2, #1
c0de14ee:	e030      	b.n	c0de1552 <touchCallback+0x126>
c0de14f0:	2000      	movs	r0, #0
c0de14f2:	2100      	movs	r1, #0
        if (getLayoutAndLayoutObj(obj->parent, &layout, &layoutObj) == false) {
c0de14f4:	2900      	cmp	r1, #0
c0de14f6:	4607      	mov	r7, r0
c0de14f8:	f000 81ce 	beq.w	c0de1898 <touchCallback+0x46c>
    if (((eventType == SWIPED_UP) || (eventType == SWIPED_DOWN) || (eventType == SWIPED_LEFT)
c0de14fc:	f1aa 0006 	sub.w	r0, sl, #6
c0de1500:	b2c0      	uxtb	r0, r0
c0de1502:	2803      	cmp	r0, #3
c0de1504:	d849      	bhi.n	c0de159a <touchCallback+0x16e>
        && (obj->type == CONTAINER)) {
c0de1506:	7aa0      	ldrb	r0, [r4, #10]
    if (((eventType == SWIPED_UP) || (eventType == SWIPED_DOWN) || (eventType == SWIPED_LEFT)
c0de1508:	2801      	cmp	r0, #1
c0de150a:	d146      	bne.n	c0de159a <touchCallback+0x16e>
        if (layout->swipeUsage == SWIPE_USAGE_CUSTOM) {
c0de150c:	f897 10b0 	ldrb.w	r1, [r7, #176]	@ 0xb0
c0de1510:	4650      	mov	r0, sl
c0de1512:	2901      	cmp	r1, #1
c0de1514:	d03f      	beq.n	c0de1596 <touchCallback+0x16a>
c0de1516:	2900      	cmp	r1, #0
c0de1518:	d13f      	bne.n	c0de159a <touchCallback+0x16e>
                 && ((nbgl_obj_t *) layout->container == obj)) {
c0de151a:	f8d7 00a0 	ldr.w	r0, [r7, #160]	@ 0xa0
        else if ((layout->swipeUsage == SWIPE_USAGE_NAVIGATION)
c0de151e:	42a0      	cmp	r0, r4
c0de1520:	d13b      	bne.n	c0de159a <touchCallback+0x16e>
            if (layout->footerType == FOOTER_NAV) {
c0de1522:	f897 00ab 	ldrb.w	r0, [r7, #171]	@ 0xab
c0de1526:	2803      	cmp	r0, #3
c0de1528:	d01b      	beq.n	c0de1562 <touchCallback+0x136>
c0de152a:	2804      	cmp	r0, #4
c0de152c:	f040 81b4 	bne.w	c0de1898 <touchCallback+0x46c>
                navContainer = (nbgl_container_t *) layout->footerContainer;
c0de1530:	f107 0010 	add.w	r0, r7, #16
c0de1534:	e022      	b.n	c0de157c <touchCallback+0x150>
c0de1536:	2100      	movs	r1, #0
                *layoutObj = &(topLayout->callbackObjPool[j]);
c0de1538:	eb00 01c1 	add.w	r1, r0, r1, lsl #3
c0de153c:	f101 0820 	add.w	r8, r1, #32
c0de1540:	b123      	cbz	r3, c0de154c <touchCallback+0x120>
c0de1542:	2101      	movs	r1, #1
c0de1544:	4607      	mov	r7, r0
    if (getLayoutAndLayoutObj(obj, &layout, &layoutObj) == false) {
c0de1546:	2900      	cmp	r1, #0
c0de1548:	d0a3      	beq.n	c0de1492 <touchCallback+0x66>
c0de154a:	e7d7      	b.n	c0de14fc <touchCallback+0xd0>
c0de154c:	4607      	mov	r7, r0
c0de154e:	e79e      	b.n	c0de148e <touchCallback+0x62>
c0de1550:	2300      	movs	r3, #0
                *layoutObj = &(topLayout->callbackObjPool[j]);
c0de1552:	eb00 01c3 	add.w	r1, r0, r3, lsl #3
c0de1556:	2a00      	cmp	r2, #0
c0de1558:	f101 0820 	add.w	r8, r1, #32
c0de155c:	d0c9      	beq.n	c0de14f2 <touchCallback+0xc6>
c0de155e:	2101      	movs	r1, #1
c0de1560:	e7c8      	b.n	c0de14f4 <touchCallback+0xc8>
                navContainer = (nbgl_container_t *) layout->footerContainer->children[1];
c0de1562:	6938      	ldr	r0, [r7, #16]
c0de1564:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
c0de1568:	7842      	ldrb	r2, [r0, #1]
c0de156a:	7883      	ldrb	r3, [r0, #2]
c0de156c:	78c0      	ldrb	r0, [r0, #3]
c0de156e:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de1572:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de1576:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de157a:	3004      	adds	r0, #4
c0de157c:	6800      	ldr	r0, [r0, #0]
                    (nbgl_obj_t *) navContainer, eventType, layout->nbPages, &layout->activePage)
c0de157e:	f897 20a8 	ldrb.w	r2, [r7, #168]	@ 0xa8
c0de1582:	f107 06a9 	add.w	r6, r7, #169	@ 0xa9
            if (layoutNavigationCallback(
c0de1586:	4651      	mov	r1, sl
c0de1588:	4633      	mov	r3, r6
c0de158a:	f003 fffa 	bl	c0de5582 <layoutNavigationCallback>
c0de158e:	2800      	cmp	r0, #0
c0de1590:	f000 8182 	beq.w	c0de1898 <touchCallback+0x46c>
            layoutObj->index = layout->activePage;
c0de1594:	7830      	ldrb	r0, [r6, #0]
c0de1596:	f888 0005 	strb.w	r0, [r8, #5]
    if (((obj->parent == (nbgl_obj_t *) layout->footerContainer)
c0de159a:	4620      	mov	r0, r4
c0de159c:	f810 1f0c 	ldrb.w	r1, [r0, #12]!
c0de15a0:	7842      	ldrb	r2, [r0, #1]
c0de15a2:	7883      	ldrb	r3, [r0, #2]
c0de15a4:	78c0      	ldrb	r0, [r0, #3]
c0de15a6:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de15aa:	ea43 2200 	orr.w	r2, r3, r0, lsl #8
c0de15ae:	6938      	ldr	r0, [r7, #16]
c0de15b0:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
         && (layout->footerType == FOOTER_NAV))
c0de15b4:	4281      	cmp	r1, r0
c0de15b6:	d103      	bne.n	c0de15c0 <touchCallback+0x194>
c0de15b8:	f897 20ab 	ldrb.w	r2, [r7, #171]	@ 0xab
        || ((obj->parent->type == CONTAINER)
c0de15bc:	2a04      	cmp	r2, #4
c0de15be:	d013      	beq.n	c0de15e8 <touchCallback+0x1bc>
c0de15c0:	7a8a      	ldrb	r2, [r1, #10]
            && (obj->parent->parent == (nbgl_obj_t *) layout->footerContainer)
c0de15c2:	2a01      	cmp	r2, #1
c0de15c4:	d11f      	bne.n	c0de1606 <touchCallback+0x1da>
c0de15c6:	f811 2f0c 	ldrb.w	r2, [r1, #12]!
c0de15ca:	784b      	ldrb	r3, [r1, #1]
c0de15cc:	788e      	ldrb	r6, [r1, #2]
c0de15ce:	78c9      	ldrb	r1, [r1, #3]
c0de15d0:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de15d4:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de15d8:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
            && (layout->footerType == FOOTER_TEXT_AND_NAV))) {
c0de15dc:	4281      	cmp	r1, r0
c0de15de:	d112      	bne.n	c0de1606 <touchCallback+0x1da>
c0de15e0:	f897 00ab 	ldrb.w	r0, [r7, #171]	@ 0xab
    if (((obj->parent == (nbgl_obj_t *) layout->footerContainer)
c0de15e4:	2803      	cmp	r0, #3
c0de15e6:	d10e      	bne.n	c0de1606 <touchCallback+0x1da>
        if (layoutNavigationCallback(obj, eventType, layout->nbPages, &layout->activePage)
c0de15e8:	f897 20a8 	ldrb.w	r2, [r7, #168]	@ 0xa8
c0de15ec:	f107 06a9 	add.w	r6, r7, #169	@ 0xa9
c0de15f0:	4620      	mov	r0, r4
c0de15f2:	4651      	mov	r1, sl
c0de15f4:	4633      	mov	r3, r6
c0de15f6:	f003 ffc4 	bl	c0de5582 <layoutNavigationCallback>
c0de15fa:	2800      	cmp	r0, #0
c0de15fc:	f000 814c 	beq.w	c0de1898 <touchCallback+0x46c>
        layoutObj->index = layout->activePage;
c0de1600:	7830      	ldrb	r0, [r6, #0]
c0de1602:	f888 0005 	strb.w	r0, [r8, #5]
    if ((obj->type == CONTAINER) && (((nbgl_container_t *) obj)->nbChildren >= 2)
c0de1606:	7aa0      	ldrb	r0, [r4, #10]
c0de1608:	2801      	cmp	r0, #1
c0de160a:	f040 808b 	bne.w	c0de1724 <touchCallback+0x2f8>
c0de160e:	f894 1021 	ldrb.w	r1, [r4, #33]	@ 0x21
        && (((nbgl_container_t *) obj)->children[1] != NULL)
c0de1612:	2902      	cmp	r1, #2
c0de1614:	d31d      	bcc.n	c0de1652 <touchCallback+0x226>
c0de1616:	4621      	mov	r1, r4
c0de1618:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
c0de161c:	784b      	ldrb	r3, [r1, #1]
c0de161e:	788e      	ldrb	r6, [r1, #2]
c0de1620:	78c9      	ldrb	r1, [r1, #3]
c0de1622:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de1626:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de162a:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de162e:	684e      	ldr	r6, [r1, #4]
        && (((nbgl_container_t *) obj)->children[1]->type == SWITCH)) {
c0de1630:	b17e      	cbz	r6, c0de1652 <touchCallback+0x226>
c0de1632:	7ab1      	ldrb	r1, [r6, #10]
    if ((obj->type == CONTAINER) && (((nbgl_container_t *) obj)->nbChildren >= 2)
c0de1634:	2906      	cmp	r1, #6
c0de1636:	d10c      	bne.n	c0de1652 <touchCallback+0x226>
        lSwitch->state         = (lSwitch->state == ON_STATE) ? OFF_STATE : ON_STATE;
c0de1638:	7fb0      	ldrb	r0, [r6, #30]
c0de163a:	3801      	subs	r0, #1
c0de163c:	bf18      	it	ne
c0de163e:	2001      	movne	r0, #1
c0de1640:	77b0      	strb	r0, [r6, #30]
        nbgl_objDraw((nbgl_obj_t *) lSwitch);
c0de1642:	4630      	mov	r0, r6
c0de1644:	f007 fa67 	bl	c0de8b16 <nbgl_objDraw>
        layoutObj->index = lSwitch->state;
c0de1648:	7fb0      	ldrb	r0, [r6, #30]
c0de164a:	2401      	movs	r4, #1
c0de164c:	f888 0005 	strb.w	r0, [r8, #5]
c0de1650:	e069      	b.n	c0de1726 <touchCallback+0x2fa>
    else if ((obj->type == CONTAINER) && (((nbgl_container_t *) obj)->nbChildren == 2)
c0de1652:	2801      	cmp	r0, #1
c0de1654:	d166      	bne.n	c0de1724 <touchCallback+0x2f8>
c0de1656:	f894 1021 	ldrb.w	r1, [r4, #33]	@ 0x21
             && (((nbgl_container_t *) obj)->children[1] != NULL)
c0de165a:	2902      	cmp	r1, #2
c0de165c:	d122      	bne.n	c0de16a4 <touchCallback+0x278>
c0de165e:	4621      	mov	r1, r4
c0de1660:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
c0de1664:	784b      	ldrb	r3, [r1, #1]
c0de1666:	788e      	ldrb	r6, [r1, #2]
c0de1668:	78c9      	ldrb	r1, [r1, #3]
c0de166a:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de166e:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de1672:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de1676:	6849      	ldr	r1, [r1, #4]
             && (((nbgl_container_t *) obj)->children[1]->type == RADIO_BUTTON)) {
c0de1678:	b1a1      	cbz	r1, c0de16a4 <touchCallback+0x278>
c0de167a:	7a89      	ldrb	r1, [r1, #10]
    else if ((obj->type == CONTAINER) && (((nbgl_container_t *) obj)->nbChildren == 2)
c0de167c:	2909      	cmp	r1, #9
c0de167e:	d111      	bne.n	c0de16a4 <touchCallback+0x278>
    if (eventType != TOUCHED) {
c0de1680:	f1ba 0f00 	cmp.w	sl, #0
c0de1684:	f040 8108 	bne.w	c0de1898 <touchCallback+0x46c>
    while (i < layout->nbUsedCallbackObjs) {
c0de1688:	f897 00ae 	ldrb.w	r0, [r7, #174]	@ 0xae
c0de168c:	f44f 517c 	mov.w	r1, #16128	@ 0x3f00
c0de1690:	f04f 0aff 	mov.w	sl, #255	@ 0xff
c0de1694:	ea11 2f00 	tst.w	r1, r0, lsl #8
c0de1698:	f000 80b1 	beq.w	c0de17fe <touchCallback+0x3d2>
c0de169c:	f04f 0b00 	mov.w	fp, #0
c0de16a0:	2500      	movs	r5, #0
c0de16a2:	e07d      	b.n	c0de17a0 <touchCallback+0x374>
    else if ((obj->type == CONTAINER) && (((nbgl_container_t *) obj)->nbChildren == 4)
c0de16a4:	2801      	cmp	r0, #1
c0de16a6:	d13d      	bne.n	c0de1724 <touchCallback+0x2f8>
c0de16a8:	f894 0021 	ldrb.w	r0, [r4, #33]	@ 0x21
             && (((nbgl_container_t *) obj)->children[3] != NULL)
c0de16ac:	2804      	cmp	r0, #4
c0de16ae:	d139      	bne.n	c0de1724 <touchCallback+0x2f8>
c0de16b0:	4620      	mov	r0, r4
c0de16b2:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
c0de16b6:	7842      	ldrb	r2, [r0, #1]
c0de16b8:	7883      	ldrb	r3, [r0, #2]
c0de16ba:	78c0      	ldrb	r0, [r0, #3]
c0de16bc:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de16c0:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de16c4:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de16c8:	68c6      	ldr	r6, [r0, #12]
             && (((nbgl_container_t *) obj)->children[3]->type == PROGRESS_BAR)) {
c0de16ca:	b35e      	cbz	r6, c0de1724 <touchCallback+0x2f8>
c0de16cc:	7ab0      	ldrb	r0, [r6, #10]
    else if ((obj->type == CONTAINER) && (((nbgl_container_t *) obj)->nbChildren == 4)
c0de16ce:	2808      	cmp	r0, #8
c0de16d0:	d128      	bne.n	c0de1724 <touchCallback+0x2f8>
    if (eventType == TOUCHING) {
c0de16d2:	f1ba 0f09 	cmp.w	sl, #9
c0de16d6:	f200 80df 	bhi.w	c0de1898 <touchCallback+0x46c>
c0de16da:	2001      	movs	r0, #1
c0de16dc:	fa00 f00a 	lsl.w	r0, r0, sl
c0de16e0:	f410 7f4a 	tst.w	r0, #808	@ 0x328
c0de16e4:	f000 80a5 	beq.w	c0de1832 <touchCallback+0x406>
        nbgl_wait_pipeline();
c0de16e8:	f008 f991 	bl	c0de9a0e <nbgl_wait_pipeline>
        progressBar->partialRedraw = true;
c0de16ec:	7ff0      	ldrb	r0, [r6, #31]
c0de16ee:	f040 0001 	orr.w	r0, r0, #1
c0de16f2:	77f0      	strb	r0, [r6, #31]
c0de16f4:	2000      	movs	r0, #0
        progressBar->state         = 0;
c0de16f6:	77b0      	strb	r0, [r6, #30]
        nbgl_objDraw((nbgl_obj_t *) progressBar);
c0de16f8:	4630      	mov	r0, r6
c0de16fa:	f007 fa0c 	bl	c0de8b16 <nbgl_objDraw>
        nbgl_line_t *line = (nbgl_line_t *) container->children[2];
c0de16fe:	f814 0f1c 	ldrb.w	r0, [r4, #28]!
c0de1702:	7861      	ldrb	r1, [r4, #1]
c0de1704:	78a2      	ldrb	r2, [r4, #2]
c0de1706:	78e3      	ldrb	r3, [r4, #3]
c0de1708:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de170c:	ea42 2103 	orr.w	r1, r2, r3, lsl #8
c0de1710:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de1714:	6880      	ldr	r0, [r0, #8]
        nbgl_objDraw((nbgl_obj_t *) line);
c0de1716:	f007 f9fe 	bl	c0de8b16 <nbgl_objDraw>
        nbgl_refreshSpecialWithPostRefresh(BLACK_AND_WHITE_REFRESH, POST_REFRESH_FORCE_POWER_OFF);
c0de171a:	2003      	movs	r0, #3
c0de171c:	2100      	movs	r1, #0
c0de171e:	f007 f9f0 	bl	c0de8b02 <nbgl_refreshSpecialWithPostRefresh>
c0de1722:	e0b9      	b.n	c0de1898 <touchCallback+0x46c>
c0de1724:	2400      	movs	r4, #0
    if ((layout->callback != NULL) && (layoutObj->token != NBGL_INVALID_TOKEN)) {
c0de1726:	69f8      	ldr	r0, [r7, #28]
c0de1728:	2800      	cmp	r0, #0
c0de172a:	f000 80b5 	beq.w	c0de1898 <touchCallback+0x46c>
c0de172e:	f898 0004 	ldrb.w	r0, [r8, #4]
c0de1732:	28ff      	cmp	r0, #255	@ 0xff
c0de1734:	f000 80b0 	beq.w	c0de1898 <touchCallback+0x46c>
        if (layoutObj->tuneId < NBGL_NO_TUNE) {
c0de1738:	f898 0006 	ldrb.w	r0, [r8, #6]
c0de173c:	280b      	cmp	r0, #11
            os_io_seph_cmd_piezo_play_tune(layoutObj->tuneId);
c0de173e:	bf98      	it	ls
c0de1740:	f7ff faf2 	blls	c0de0d28 <os_io_seph_cmd_piezo_play_tune>
c0de1744:	b114      	cbz	r4, c0de174c <touchCallback+0x320>
            nbgl_refreshSpecial(FULL_COLOR_PARTIAL_REFRESH);
c0de1746:	2001      	movs	r0, #1
c0de1748:	f007 f9d6 	bl	c0de8af8 <nbgl_refreshSpecial>
        layout->callback(layoutObj->token, layoutObj->index);
c0de174c:	69fa      	ldr	r2, [r7, #28]
c0de174e:	f898 0004 	ldrb.w	r0, [r8, #4]
c0de1752:	f898 1005 	ldrb.w	r1, [r8, #5]
c0de1756:	4790      	blx	r2
}
c0de1758:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
                      ->children[1];
c0de175c:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
c0de1760:	7842      	ldrb	r2, [r0, #1]
c0de1762:	7883      	ldrb	r3, [r0, #2]
c0de1764:	78c0      	ldrb	r0, [r0, #3]
c0de1766:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de176a:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de176e:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
                = (nbgl_text_area_t *) ((nbgl_container_t *) layout->callbackObjPool[i].obj)
c0de1772:	e9d0 1000 	ldrd	r1, r0, [r0]
            textArea->textColor = BLACK;
c0de1776:	2200      	movs	r2, #0
c0de1778:	770a      	strb	r2, [r1, #28]
            textArea->fontId    = SMALL_BOLD_FONT;
c0de177a:	220c      	movs	r2, #12
c0de177c:	77ca      	strb	r2, [r1, #31]
            radio->state = ON_STATE;
c0de177e:	2101      	movs	r1, #1
c0de1780:	7781      	strb	r1, [r0, #30]
            nbgl_objDraw((nbgl_obj_t *) obj);
c0de1782:	4620      	mov	r0, r4
c0de1784:	f007 f9c7 	bl	c0de8b16 <nbgl_objDraw>
c0de1788:	46a8      	mov	r8, r5
c0de178a:	46da      	mov	sl, fp
    while (i < layout->nbUsedCallbackObjs) {
c0de178c:	f897 00ae 	ldrb.w	r0, [r7, #174]	@ 0xae
        i++;
c0de1790:	f10b 0b01 	add.w	fp, fp, #1
    while (i < layout->nbUsedCallbackObjs) {
c0de1794:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de1798:	fa5f f18b 	uxtb.w	r1, fp
c0de179c:	4288      	cmp	r0, r1
c0de179e:	d92e      	bls.n	c0de17fe <touchCallback+0x3d2>
c0de17a0:	fa5f f08b 	uxtb.w	r0, fp
        if ((obj == (nbgl_obj_t *) layout->callbackObjPool[i].obj)
c0de17a4:	eb07 00c0 	add.w	r0, r7, r0, lsl #3
c0de17a8:	6a00      	ldr	r0, [r0, #32]
            && (layout->callbackObjPool[i].obj->type == CONTAINER)) {
c0de17aa:	42a0      	cmp	r0, r4
c0de17ac:	d102      	bne.n	c0de17b4 <touchCallback+0x388>
c0de17ae:	7a81      	ldrb	r1, [r0, #10]
        if ((obj == (nbgl_obj_t *) layout->callbackObjPool[i].obj)
c0de17b0:	2901      	cmp	r1, #1
c0de17b2:	d0d3      	beq.n	c0de175c <touchCallback+0x330>
        else if ((layout->callbackObjPool[i].obj->type == CONTAINER)
c0de17b4:	7a81      	ldrb	r1, [r0, #10]
                 && (((nbgl_container_t *) layout->callbackObjPool[i].obj)->nbChildren == 2)
c0de17b6:	2901      	cmp	r1, #1
c0de17b8:	d1e8      	bne.n	c0de178c <touchCallback+0x360>
c0de17ba:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
                 && (((nbgl_container_t *) layout->callbackObjPool[i].obj)->children[1]->type
c0de17be:	2902      	cmp	r1, #2
c0de17c0:	d1e4      	bne.n	c0de178c <touchCallback+0x360>
c0de17c2:	4601      	mov	r1, r0
c0de17c4:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
c0de17c8:	784b      	ldrb	r3, [r1, #1]
c0de17ca:	788e      	ldrb	r6, [r1, #2]
c0de17cc:	78c9      	ldrb	r1, [r1, #3]
c0de17ce:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de17d2:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de17d6:	ea42 4201 	orr.w	r2, r2, r1, lsl #16
c0de17da:	6851      	ldr	r1, [r2, #4]
c0de17dc:	7a8b      	ldrb	r3, [r1, #10]
        else if ((layout->callbackObjPool[i].obj->type == CONTAINER)
c0de17de:	2b09      	cmp	r3, #9
c0de17e0:	d1d4      	bne.n	c0de178c <touchCallback+0x360>
            if (radio->state == ON_STATE) {
c0de17e2:	7f8b      	ldrb	r3, [r1, #30]
            radioIndex++;
c0de17e4:	3501      	adds	r5, #1
            if (radio->state == ON_STATE) {
c0de17e6:	2b01      	cmp	r3, #1
c0de17e8:	d1d0      	bne.n	c0de178c <touchCallback+0x360>
c0de17ea:	6812      	ldr	r2, [r2, #0]
                radio->state = OFF_STATE;
c0de17ec:	2300      	movs	r3, #0
c0de17ee:	778b      	strb	r3, [r1, #30]
                textArea->textColor = LIGHT_TEXT_COLOR;
c0de17f0:	2101      	movs	r1, #1
c0de17f2:	7711      	strb	r1, [r2, #28]
                textArea->fontId    = SMALL_REGULAR_FONT;
c0de17f4:	210b      	movs	r1, #11
c0de17f6:	77d1      	strb	r1, [r2, #31]
                nbgl_objDraw((nbgl_obj_t *) layout->callbackObjPool[i].obj);
c0de17f8:	f007 f98d 	bl	c0de8b16 <nbgl_objDraw>
c0de17fc:	e7c6      	b.n	c0de178c <touchCallback+0x360>
    if (foundRadio != 0xFF) {
c0de17fe:	fa5f f08a 	uxtb.w	r0, sl
c0de1802:	28ff      	cmp	r0, #255	@ 0xff
c0de1804:	d048      	beq.n	c0de1898 <touchCallback+0x46c>
        if (layout->callback != NULL) {
c0de1806:	69f9      	ldr	r1, [r7, #28]
c0de1808:	2900      	cmp	r1, #0
c0de180a:	d045      	beq.n	c0de1898 <touchCallback+0x46c>
            if (layout->callbackObjPool[foundRadio].tuneId < NBGL_NO_TUNE) {
c0de180c:	eb07 04c0 	add.w	r4, r7, r0, lsl #3
c0de1810:	f894 0026 	ldrb.w	r0, [r4, #38]	@ 0x26
c0de1814:	280b      	cmp	r0, #11
                os_io_seph_cmd_piezo_play_tune(layout->callbackObjPool[foundRadio].tuneId);
c0de1816:	bf98      	it	ls
c0de1818:	f7ff fa86 	blls	c0de0d28 <os_io_seph_cmd_piezo_play_tune>
            nbgl_refreshSpecial(FULL_COLOR_PARTIAL_REFRESH);
c0de181c:	2001      	movs	r0, #1
c0de181e:	f007 f96b 	bl	c0de8af8 <nbgl_refreshSpecial>
            layout->callback(layout->callbackObjPool[foundRadio].token, foundRadioIndex);
c0de1822:	69fa      	ldr	r2, [r7, #28]
c0de1824:	f894 0024 	ldrb.w	r0, [r4, #36]	@ 0x24
c0de1828:	fa5f f188 	uxtb.w	r1, r8
c0de182c:	4790      	blx	r2
}
c0de182e:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de1832:	f1ba 0f02 	cmp.w	sl, #2
c0de1836:	d12f      	bne.n	c0de1898 <touchCallback+0x46c>
        uint32_t touchDuration = nbgl_touchGetTouchDuration(obj);
c0de1838:	4620      	mov	r0, r4
c0de183a:	f007 f9cb 	bl	c0de8bd4 <nbgl_touchGetTouchDuration>
c0de183e:	f248 511f 	movw	r1, #34079	@ 0x851f
c0de1842:	f2c5 11eb 	movt	r1, #20971	@ 0x51eb
        = (touch_duration / HOLD_TO_APPROVE_STEP_DURATION_MS) + HOLD_TO_APPROVE_FIRST_STEP;
c0de1846:	fba0 0101 	umull	r0, r1, r0, r1
c0de184a:	0948      	lsrs	r0, r1, #5
    return (current_step_nb * HOLD_TO_APPROVE_STEP_PERCENT);
c0de184c:	00c0      	lsls	r0, r0, #3
c0de184e:	eba0 1051 	sub.w	r0, r0, r1, lsr #5
c0de1852:	b2c1      	uxtb	r1, r0
        bool trigger_callback = (new_state >= 100) && (progressBar->state < 100);
c0de1854:	2964      	cmp	r1, #100	@ 0x64
c0de1856:	f04f 0400 	mov.w	r4, #0
c0de185a:	d305      	bcc.n	c0de1868 <touchCallback+0x43c>
c0de185c:	7fb0      	ldrb	r0, [r6, #30]
c0de185e:	2864      	cmp	r0, #100	@ 0x64
c0de1860:	f04f 0064 	mov.w	r0, #100	@ 0x64
c0de1864:	bf38      	it	cc
c0de1866:	2401      	movcc	r4, #1
        if (new_state != progressBar->state) {
c0de1868:	7fb1      	ldrb	r1, [r6, #30]
c0de186a:	b2c2      	uxtb	r2, r0
c0de186c:	428a      	cmp	r2, r1
c0de186e:	d00b      	beq.n	c0de1888 <touchCallback+0x45c>
            progressBar->partialRedraw = true;
c0de1870:	7ff1      	ldrb	r1, [r6, #31]
            progressBar->state         = new_state;
c0de1872:	77b0      	strb	r0, [r6, #30]
            progressBar->partialRedraw = true;
c0de1874:	f041 0101 	orr.w	r1, r1, #1
            nbgl_objDraw((nbgl_obj_t *) progressBar);
c0de1878:	4630      	mov	r0, r6
            progressBar->partialRedraw = true;
c0de187a:	77f1      	strb	r1, [r6, #31]
            nbgl_objDraw((nbgl_obj_t *) progressBar);
c0de187c:	f007 f94b 	bl	c0de8b16 <nbgl_objDraw>
            nbgl_refreshSpecialWithPostRefresh(BLACK_AND_WHITE_FAST_REFRESH,
c0de1880:	2004      	movs	r0, #4
c0de1882:	2102      	movs	r1, #2
c0de1884:	f007 f93d 	bl	c0de8b02 <nbgl_refreshSpecialWithPostRefresh>
        if (trigger_callback) {
c0de1888:	2c00      	cmp	r4, #0
}
c0de188a:	bf08      	it	eq
c0de188c:	e8bd 8df0 	ldmiaeq.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            if (layout->callback != NULL) {
c0de1890:	69fa      	ldr	r2, [r7, #28]
c0de1892:	2a00      	cmp	r2, #0
c0de1894:	f47f af5b 	bne.w	c0de174e <touchCallback+0x322>
}
c0de1898:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de189c <nbgl_layoutAddUpFooter>:
 * @param layout the current layout
 * @param upFooterDesc description of the up-footer
 * @return height of the control if OK
 */
int nbgl_layoutAddUpFooter(nbgl_layout_t *layout, const nbgl_layoutUpFooter_t *upFooterDesc)
{
c0de189c:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
    nbgl_text_area_t      *textArea;
    nbgl_line_t           *line;
    nbgl_button_t         *button;

    LOG_DEBUG(LAYOUT_LOGGER, "nbgl_layoutAddUpFooter():\n");
    if (layout == NULL) {
c0de18a0:	2800      	cmp	r0, #0
c0de18a2:	f000 8426 	beq.w	c0de20f2 <nbgl_layoutAddUpFooter+0x856>
c0de18a6:	460d      	mov	r5, r1
        return -1;
    }
    if ((upFooterDesc == NULL) || (upFooterDesc->type >= NB_UP_FOOTER_TYPES)) {
c0de18a8:	b119      	cbz	r1, c0de18b2 <nbgl_layoutAddUpFooter+0x16>
c0de18aa:	4604      	mov	r4, r0
c0de18ac:	7828      	ldrb	r0, [r5, #0]
c0de18ae:	2804      	cmp	r0, #4
c0de18b0:	d903      	bls.n	c0de18ba <nbgl_layoutAddUpFooter+0x1e>
c0de18b2:	f06f 0001 	mvn.w	r0, #1
    layoutInt->children[UP_FOOTER_INDEX] = (nbgl_obj_t *) layoutInt->upFooterContainer;

    layoutInt->upFooterType = upFooterDesc->type;

    return layoutInt->upFooterContainer->obj.area.height;
}
c0de18b6:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de18ba:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de18be:	2601      	movs	r6, #1
c0de18c0:	08c1      	lsrs	r1, r0, #3
c0de18c2:	2001      	movs	r0, #1
c0de18c4:	f007 f94f 	bl	c0de8b66 <nbgl_objPoolGet>
c0de18c8:	21e0      	movs	r1, #224	@ 0xe0
c0de18ca:	6160      	str	r0, [r4, #20]
    layoutInt->upFooterContainer->obj.area.width = SCREEN_WIDTH;
c0de18cc:	7101      	strb	r1, [r0, #4]
c0de18ce:	2100      	movs	r1, #0
c0de18d0:	7146      	strb	r6, [r0, #5]
    layoutInt->upFooterContainer->layout         = VERTICAL;
c0de18d2:	f880 1020 	strb.w	r1, [r0, #32]
        = (nbgl_obj_t **) nbgl_containerPoolGet(4, layoutInt->layer);
c0de18d6:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de18da:	08c1      	lsrs	r1, r0, #3
c0de18dc:	2004      	movs	r0, #4
c0de18de:	f007 f947 	bl	c0de8b70 <nbgl_containerPoolGet>
    layoutInt->upFooterContainer->children
c0de18e2:	6961      	ldr	r1, [r4, #20]
        = (nbgl_obj_t **) nbgl_containerPoolGet(4, layoutInt->layer);
c0de18e4:	0a03      	lsrs	r3, r0, #8
    layoutInt->upFooterContainer->obj.alignTo   = (nbgl_obj_t *) layoutInt->container;
c0de18e6:	f8d4 20a0 	ldr.w	r2, [r4, #160]	@ 0xa0
        = (nbgl_obj_t **) nbgl_containerPoolGet(4, layoutInt->layer);
c0de18ea:	774b      	strb	r3, [r1, #29]
c0de18ec:	460b      	mov	r3, r1
c0de18ee:	f803 0f1c 	strb.w	r0, [r3, #28]!
c0de18f2:	0e07      	lsrs	r7, r0, #24
c0de18f4:	0c00      	lsrs	r0, r0, #16
c0de18f6:	7098      	strb	r0, [r3, #2]
    layoutInt->upFooterContainer->obj.alignTo   = (nbgl_obj_t *) layoutInt->container;
c0de18f8:	4608      	mov	r0, r1
        = (nbgl_obj_t **) nbgl_containerPoolGet(4, layoutInt->layer);
c0de18fa:	70df      	strb	r7, [r3, #3]
    layoutInt->upFooterContainer->obj.alignTo   = (nbgl_obj_t *) layoutInt->container;
c0de18fc:	f800 2f10 	strb.w	r2, [r0, #16]!
c0de1900:	0e13      	lsrs	r3, r2, #24
c0de1902:	70c3      	strb	r3, [r0, #3]
c0de1904:	0c13      	lsrs	r3, r2, #16
c0de1906:	7083      	strb	r3, [r0, #2]
c0de1908:	0a10      	lsrs	r0, r2, #8
c0de190a:	7448      	strb	r0, [r1, #17]
    switch (upFooterDesc->type) {
c0de190c:	782a      	ldrb	r2, [r5, #0]
c0de190e:	2008      	movs	r0, #8
    layoutInt->upFooterContainer->obj.alignment = BOTTOM_MIDDLE;
c0de1910:	72c8      	strb	r0, [r1, #11]
    switch (upFooterDesc->type) {
c0de1912:	2a01      	cmp	r2, #1
c0de1914:	f06f 0001 	mvn.w	r0, #1
c0de1918:	f340 8080 	ble.w	c0de1a1c <nbgl_layoutAddUpFooter+0x180>
c0de191c:	2a02      	cmp	r2, #2
c0de191e:	f000 8111 	beq.w	c0de1b44 <nbgl_layoutAddUpFooter+0x2a8>
c0de1922:	2a03      	cmp	r2, #3
c0de1924:	f000 81ba 	beq.w	c0de1c9c <nbgl_layoutAddUpFooter+0x400>
c0de1928:	2a04      	cmp	r2, #4
}
c0de192a:	bf18      	it	ne
c0de192c:	e8bd 8df0 	ldmiane.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de1930:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1934:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de1938:	ea40 2002 	orr.w	r0, r0, r2, lsl #8
c0de193c:	f3c0 2205 	ubfx	r2, r0, #8, #6
c0de1940:	2a0e      	cmp	r2, #14
c0de1942:	bf84      	itt	hi
c0de1944:	f04f 30ff 	movhi.w	r0, #4294967295	@ 0xffffffff
}
c0de1948:	e8bd 8df0 	ldmiahi.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de194c:	0a03      	lsrs	r3, r0, #8
        layout->nbUsedCallbackObjs++;
c0de194e:	3301      	adds	r3, #1
c0de1950:	f003 033f 	and.w	r3, r3, #63	@ 0x3f
c0de1954:	f400 4740 	and.w	r7, r0, #49152	@ 0xc000
                                       upFooterDesc->text.token,
c0de1958:	f895 e008 	ldrb.w	lr, [r5, #8]
                                       upFooterDesc->text.tuneId);
c0de195c:	f895 c009 	ldrb.w	ip, [r5, #9]
                                       (nbgl_obj_t *) layoutInt->upFooterContainer,
c0de1960:	6966      	ldr	r6, [r4, #20]
        layout->nbUsedCallbackObjs++;
c0de1962:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de1966:	0a1b      	lsrs	r3, r3, #8
c0de1968:	f884 00ad 	strb.w	r0, [r4, #173]	@ 0xad
        layoutObj->obj    = obj;
c0de196c:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de1970:	2260      	movs	r2, #96	@ 0x60
        layout->nbUsedCallbackObjs++;
c0de1972:	f884 30ae 	strb.w	r3, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de1976:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de1978:	f880 e024 	strb.w	lr, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de197c:	f880 c026 	strb.w	ip, [r0, #38]	@ 0x26
c0de1980:	2701      	movs	r7, #1
c0de1982:	2000      	movs	r0, #0
            layoutInt->upFooterContainer->obj.area.height = SMALL_FOOTER_HEIGHT;
c0de1984:	718a      	strb	r2, [r1, #6]
c0de1986:	2204      	movs	r2, #4
            layoutInt->upFooterContainer->nbChildren      = 1;
c0de1988:	f881 7021 	strb.w	r7, [r1, #33]	@ 0x21
            layoutInt->upFooterContainer->obj.area.height = SMALL_FOOTER_HEIGHT;
c0de198c:	71c8      	strb	r0, [r1, #7]
            layoutInt->upFooterContainer->obj.touchId     = WHOLE_SCREEN_ID;
c0de198e:	768a      	strb	r2, [r1, #26]
            layoutInt->upFooterContainer->obj.touchMask   = (1 << TOUCHED);
c0de1990:	7648      	strb	r0, [r1, #25]
c0de1992:	760f      	strb	r7, [r1, #24]
            if (strlen(PIC(upFooterDesc->text.text))) {
c0de1994:	6868      	ldr	r0, [r5, #4]
c0de1996:	f008 f80d 	bl	c0de99b4 <pic>
c0de199a:	7800      	ldrb	r0, [r0, #0]
c0de199c:	2800      	cmp	r0, #0
c0de199e:	f000 838c 	beq.w	c0de20ba <nbgl_layoutAddUpFooter+0x81e>
                textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de19a2:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de19a6:	08c1      	lsrs	r1, r0, #3
c0de19a8:	2004      	movs	r0, #4
c0de19aa:	f007 f8dc 	bl	c0de8b66 <nbgl_objPoolGet>
                textArea->textColor       = LIGHT_TEXT_COLOR;
c0de19ae:	7707      	strb	r7, [r0, #28]
                textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de19b0:	4606      	mov	r6, r0
                textArea->text            = PIC(upFooterDesc->text.text);
c0de19b2:	6868      	ldr	r0, [r5, #4]
c0de19b4:	f007 fffe 	bl	c0de99b4 <pic>
c0de19b8:	4601      	mov	r1, r0
c0de19ba:	4630      	mov	r0, r6
c0de19bc:	f800 1f23 	strb.w	r1, [r0, #35]!
c0de19c0:	0e0a      	lsrs	r2, r1, #24
c0de19c2:	70c2      	strb	r2, [r0, #3]
c0de19c4:	0c0a      	lsrs	r2, r1, #16
c0de19c6:	7082      	strb	r2, [r0, #2]
c0de19c8:	0a08      	lsrs	r0, r1, #8
c0de19ca:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
c0de19ce:	200b      	movs	r0, #11
                textArea->fontId          = SMALL_REGULAR_FONT;
c0de19d0:	77f0      	strb	r0, [r6, #31]
                textArea->wrapping        = true;
c0de19d2:	f896 0021 	ldrb.w	r0, [r6, #33]	@ 0x21
c0de19d6:	f04f 0805 	mov.w	r8, #5
c0de19da:	f040 0001 	orr.w	r0, r0, #1
c0de19de:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
c0de19e2:	20a0      	movs	r0, #160	@ 0xa0
                textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de19e4:	7130      	strb	r0, [r6, #4]
                textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de19e6:	200b      	movs	r0, #11
c0de19e8:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de19ec:	2301      	movs	r3, #1
                textArea->textAlignment   = CENTER;
c0de19ee:	f886 801d 	strb.w	r8, [r6, #29]
                textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de19f2:	7177      	strb	r7, [r6, #5]
                textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de19f4:	f007 f8d0 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de19f8:	71b0      	strb	r0, [r6, #6]
                layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) textArea;
c0de19fa:	6961      	ldr	r1, [r4, #20]
                textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de19fc:	0a00      	lsrs	r0, r0, #8
c0de19fe:	71f0      	strb	r0, [r6, #7]
                layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) textArea;
c0de1a00:	f811 0f1c 	ldrb.w	r0, [r1, #28]!
                textArea->obj.alignment                   = CENTER;
c0de1a04:	f886 800b 	strb.w	r8, [r6, #11]
                layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) textArea;
c0de1a08:	784a      	ldrb	r2, [r1, #1]
c0de1a0a:	788b      	ldrb	r3, [r1, #2]
c0de1a0c:	78c9      	ldrb	r1, [r1, #3]
c0de1a0e:	ea40 2002 	orr.w	r0, r0, r2, lsl #8
c0de1a12:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de1a16:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de1a1a:	e091      	b.n	c0de1b40 <nbgl_layoutAddUpFooter+0x2a4>
    switch (upFooterDesc->type) {
c0de1a1c:	2a00      	cmp	r2, #0
c0de1a1e:	f000 824c 	beq.w	c0de1eba <nbgl_layoutAddUpFooter+0x61e>
c0de1a22:	2a01      	cmp	r2, #1
c0de1a24:	f040 8363 	bne.w	c0de20ee <nbgl_layoutAddUpFooter+0x852>
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de1a28:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1a2c:	f04f 0a05 	mov.w	sl, #5
c0de1a30:	08c1      	lsrs	r1, r0, #3
c0de1a32:	2005      	movs	r0, #5
c0de1a34:	f007 f897 	bl	c0de8b66 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de1a38:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de1a3c:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de1a40:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de1a44:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de1a48:	2a0e      	cmp	r2, #14
c0de1a4a:	bf84      	itt	hi
c0de1a4c:	f04f 30ff 	movhi.w	r0, #4294967295	@ 0xffffffff
}
c0de1a50:	e8bd 8df0 	ldmiahi.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de1a54:	4606      	mov	r6, r0
c0de1a56:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de1a58:	3001      	adds	r0, #1
c0de1a5a:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de1a5e:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de1a62:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
                                       upFooterDesc->button.token,
c0de1a66:	f895 c00c 	ldrb.w	ip, [r5, #12]
                                       upFooterDesc->button.tuneId);
c0de1a6a:	7c2f      	ldrb	r7, [r5, #16]
        layout->nbUsedCallbackObjs++;
c0de1a6c:	0a00      	lsrs	r0, r0, #8
c0de1a6e:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de1a72:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de1a76:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de1a78:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de1a7c:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
            layoutInt->upFooterContainer->nbChildren      = 1;
c0de1a80:	6960      	ldr	r0, [r4, #20]
        layout->nbUsedCallbackObjs++;
c0de1a82:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
c0de1a86:	f04f 0801 	mov.w	r8, #1
c0de1a8a:	2700      	movs	r7, #0
c0de1a8c:	2188      	movs	r1, #136	@ 0x88
            layoutInt->upFooterContainer->nbChildren      = 1;
c0de1a8e:	f880 8021 	strb.w	r8, [r0, #33]	@ 0x21
            layoutInt->upFooterContainer->obj.area.height = UP_FOOTER_BUTTON_HEIGHT;
c0de1a92:	71c7      	strb	r7, [r0, #7]
c0de1a94:	7181      	strb	r1, [r0, #6]
            button->obj.alignment                         = CENTER;
c0de1a96:	f886 a00b 	strb.w	sl, [r6, #11]
            if (upFooterDesc->button.style == BLACK_BACKGROUND) {
c0de1a9a:	7b68      	ldrb	r0, [r5, #13]
c0de1a9c:	2100      	movs	r1, #0
c0de1a9e:	2800      	cmp	r0, #0
c0de1aa0:	bf18      	it	ne
c0de1aa2:	2003      	movne	r0, #3
c0de1aa4:	bf08      	it	eq
c0de1aa6:	2103      	moveq	r1, #3
c0de1aa8:	f886 0028 	strb.w	r0, [r6, #40]	@ 0x28
c0de1aac:	f886 102a 	strb.w	r1, [r6, #42]	@ 0x2a
            if (upFooterDesc->button.style == NO_BORDER) {
c0de1ab0:	7b68      	ldrb	r0, [r5, #13]
c0de1ab2:	4601      	mov	r1, r0
c0de1ab4:	2800      	cmp	r0, #0
c0de1ab6:	bf18      	it	ne
c0de1ab8:	2101      	movne	r1, #1
c0de1aba:	0049      	lsls	r1, r1, #1
c0de1abc:	2802      	cmp	r0, #2
c0de1abe:	bf08      	it	eq
c0de1ac0:	2103      	moveq	r1, #3
c0de1ac2:	f886 1029 	strb.w	r1, [r6, #41]	@ 0x29
            button->text            = PIC(upFooterDesc->button.text);
c0de1ac6:	6868      	ldr	r0, [r5, #4]
c0de1ac8:	f007 ff74 	bl	c0de99b4 <pic>
c0de1acc:	4631      	mov	r1, r6
c0de1ace:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de1ad2:	0e02      	lsrs	r2, r0, #24
c0de1ad4:	70ca      	strb	r2, [r1, #3]
c0de1ad6:	0c02      	lsrs	r2, r0, #16
c0de1ad8:	0a00      	lsrs	r0, r0, #8
c0de1ada:	7770      	strb	r0, [r6, #29]
c0de1adc:	200c      	movs	r0, #12
c0de1ade:	708a      	strb	r2, [r1, #2]
            button->fontId          = SMALL_BOLD_FONT;
c0de1ae0:	f886 002c 	strb.w	r0, [r6, #44]	@ 0x2c
            button->icon            = PIC(upFooterDesc->button.icon);
c0de1ae4:	68a8      	ldr	r0, [r5, #8]
c0de1ae6:	f007 ff65 	bl	c0de99b4 <pic>
c0de1aea:	4631      	mov	r1, r6
c0de1aec:	f801 0f24 	strb.w	r0, [r1, #36]!
c0de1af0:	0e02      	lsrs	r2, r0, #24
c0de1af2:	70ca      	strb	r2, [r1, #3]
c0de1af4:	0c02      	lsrs	r2, r0, #16
c0de1af6:	0a00      	lsrs	r0, r0, #8
c0de1af8:	f886 0025 	strb.w	r0, [r6, #37]	@ 0x25
c0de1afc:	20a0      	movs	r0, #160	@ 0xa0
            button->obj.area.width  = AVAILABLE_WIDTH;
c0de1afe:	7130      	strb	r0, [r6, #4]
c0de1b00:	2058      	movs	r0, #88	@ 0x58
            button->obj.area.height = BUTTON_DIAMETER;
c0de1b02:	71b0      	strb	r0, [r6, #6]
c0de1b04:	2004      	movs	r0, #4
            button->radius          = BUTTON_RADIUS;
c0de1b06:	f886 002b 	strb.w	r0, [r6, #43]	@ 0x2b
            button->obj.alignTo                       = NULL;
c0de1b0a:	4630      	mov	r0, r6
c0de1b0c:	f800 7f10 	strb.w	r7, [r0, #16]!
            button->icon            = PIC(upFooterDesc->button.icon);
c0de1b10:	708a      	strb	r2, [r1, #2]
            button->obj.alignTo                       = NULL;
c0de1b12:	7477      	strb	r7, [r6, #17]
c0de1b14:	7087      	strb	r7, [r0, #2]
            button->obj.touchMask                     = (1 << TOUCHED);
c0de1b16:	f886 8018 	strb.w	r8, [r6, #24]
            button->obj.alignTo                       = NULL;
c0de1b1a:	70c7      	strb	r7, [r0, #3]
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de1b1c:	6960      	ldr	r0, [r4, #20]
c0de1b1e:	2107      	movs	r1, #7
c0de1b20:	f810 2f1c 	ldrb.w	r2, [r0, #28]!
            button->obj.touchId                       = SINGLE_BUTTON_ID;
c0de1b24:	76b1      	strb	r1, [r6, #26]
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de1b26:	7841      	ldrb	r1, [r0, #1]
c0de1b28:	7883      	ldrb	r3, [r0, #2]
c0de1b2a:	78c0      	ldrb	r0, [r0, #3]
c0de1b2c:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de1b30:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
            button->obj.area.width  = AVAILABLE_WIDTH;
c0de1b34:	f886 8005 	strb.w	r8, [r6, #5]
            button->obj.area.height = BUTTON_DIAMETER;
c0de1b38:	71f7      	strb	r7, [r6, #7]
            button->obj.touchMask                     = (1 << TOUCHED);
c0de1b3a:	7677      	strb	r7, [r6, #25]
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de1b3c:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de1b40:	6006      	str	r6, [r0, #0]
c0de1b42:	e2ba      	b.n	c0de20ba <nbgl_layoutAddUpFooter+0x81e>
            if ((upFooterDesc->horizontalButtons.leftIcon == NULL)
c0de1b44:	6868      	ldr	r0, [r5, #4]
                || (upFooterDesc->horizontalButtons.rightText == NULL)) {
c0de1b46:	2800      	cmp	r0, #0
c0de1b48:	f000 82d3 	beq.w	c0de20f2 <nbgl_layoutAddUpFooter+0x856>
c0de1b4c:	68a8      	ldr	r0, [r5, #8]
            if ((upFooterDesc->horizontalButtons.leftIcon == NULL)
c0de1b4e:	2800      	cmp	r0, #0
c0de1b50:	f000 82cf 	beq.w	c0de20f2 <nbgl_layoutAddUpFooter+0x856>
c0de1b54:	2702      	movs	r7, #2
c0de1b56:	f04f 0b00 	mov.w	fp, #0
c0de1b5a:	2088      	movs	r0, #136	@ 0x88
            layoutInt->upFooterContainer->nbChildren      = 2;
c0de1b5c:	f881 7021 	strb.w	r7, [r1, #33]	@ 0x21
            layoutInt->upFooterContainer->obj.area.height = UP_FOOTER_BUTTON_HEIGHT;
c0de1b60:	f881 b007 	strb.w	fp, [r1, #7]
c0de1b64:	7188      	strb	r0, [r1, #6]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de1b66:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1b6a:	08c1      	lsrs	r1, r0, #3
c0de1b6c:	2005      	movs	r0, #5
c0de1b6e:	f006 fffa 	bl	c0de8b66 <nbgl_objPoolGet>
                                       upFooterDesc->horizontalButtons.leftToken,
c0de1b72:	7b2a      	ldrb	r2, [r5, #12]
                                       upFooterDesc->horizontalButtons.tuneId);
c0de1b74:	7bab      	ldrb	r3, [r5, #14]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de1b76:	4606      	mov	r6, r0
            obj    = layoutAddCallbackObj(layoutInt,
c0de1b78:	4620      	mov	r0, r4
c0de1b7a:	4631      	mov	r1, r6
c0de1b7c:	f7ff fb39 	bl	c0de11f2 <layoutAddCallbackObj>
            if (obj == NULL) {
c0de1b80:	2800      	cmp	r0, #0
c0de1b82:	f000 82b6 	beq.w	c0de20f2 <nbgl_layoutAddUpFooter+0x856>
c0de1b86:	2101      	movs	r1, #1
            obj->index                   = 1;
c0de1b88:	7141      	strb	r1, [r0, #5]
c0de1b8a:	2020      	movs	r0, #32
c0de1b8c:	f04f 0a04 	mov.w	sl, #4
            button->obj.alignmentMarginX = BORDER_MARGIN;
c0de1b90:	7530      	strb	r0, [r6, #20]
c0de1b92:	2003      	movs	r0, #3
c0de1b94:	f04f 0858 	mov.w	r8, #88	@ 0x58
            button->obj.alignment        = MID_LEFT;
c0de1b98:	f886 a00b 	strb.w	sl, [r6, #11]
            button->obj.alignmentMarginX = BORDER_MARGIN;
c0de1b9c:	f886 b015 	strb.w	fp, [r6, #21]
            button->borderColor          = LIGHT_GRAY;
c0de1ba0:	f886 7029 	strb.w	r7, [r6, #41]	@ 0x29
            button->innerColor           = WHITE;
c0de1ba4:	f886 0028 	strb.w	r0, [r6, #40]	@ 0x28
            button->foregroundColor      = BLACK;
c0de1ba8:	f886 b02a 	strb.w	fp, [r6, #42]	@ 0x2a
            button->obj.area.width       = BUTTON_WIDTH;
c0de1bac:	f886 b005 	strb.w	fp, [r6, #5]
c0de1bb0:	f886 8004 	strb.w	r8, [r6, #4]
            button->obj.area.height      = BUTTON_DIAMETER;
c0de1bb4:	f886 b007 	strb.w	fp, [r6, #7]
c0de1bb8:	f886 8006 	strb.w	r8, [r6, #6]
            button->radius               = BUTTON_RADIUS;
c0de1bbc:	f886 a02b 	strb.w	sl, [r6, #43]	@ 0x2b
            button->icon                 = PIC(upFooterDesc->horizontalButtons.leftIcon);
c0de1bc0:	6868      	ldr	r0, [r5, #4]
c0de1bc2:	f007 fef7 	bl	c0de99b4 <pic>
c0de1bc6:	4631      	mov	r1, r6
c0de1bc8:	f801 0f24 	strb.w	r0, [r1, #36]!
c0de1bcc:	0e02      	lsrs	r2, r0, #24
c0de1bce:	70ca      	strb	r2, [r1, #3]
c0de1bd0:	0c02      	lsrs	r2, r0, #16
c0de1bd2:	0a00      	lsrs	r0, r0, #8
            button->obj.touchMask        = (1 << TOUCHED);
c0de1bd4:	f886 b019 	strb.w	fp, [r6, #25]
c0de1bd8:	f04f 0b01 	mov.w	fp, #1
            button->icon                 = PIC(upFooterDesc->horizontalButtons.leftIcon);
c0de1bdc:	708a      	strb	r2, [r1, #2]
c0de1bde:	f886 0025 	strb.w	r0, [r6, #37]	@ 0x25
c0de1be2:	200c      	movs	r0, #12
            button->obj.touchMask        = (1 << TOUCHED);
c0de1be4:	f886 b018 	strb.w	fp, [r6, #24]
            button->fontId               = SMALL_BOLD_FONT;
c0de1be8:	f886 002c 	strb.w	r0, [r6, #44]	@ 0x2c
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de1bec:	6960      	ldr	r0, [r4, #20]
c0de1bee:	210a      	movs	r1, #10
c0de1bf0:	f810 2f1c 	ldrb.w	r2, [r0, #28]!
            button->obj.touchId          = CHOICE_2_ID;
c0de1bf4:	76b1      	strb	r1, [r6, #26]
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de1bf6:	7841      	ldrb	r1, [r0, #1]
c0de1bf8:	7883      	ldrb	r3, [r0, #2]
c0de1bfa:	78c0      	ldrb	r0, [r0, #3]
c0de1bfc:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de1c00:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de1c04:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de1c08:	6006      	str	r6, [r0, #0]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de1c0a:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1c0e:	08c1      	lsrs	r1, r0, #3
c0de1c10:	2005      	movs	r0, #5
c0de1c12:	f006 ffa8 	bl	c0de8b66 <nbgl_objPoolGet>
                                       upFooterDesc->horizontalButtons.rightToken,
c0de1c16:	7b6a      	ldrb	r2, [r5, #13]
                                       upFooterDesc->horizontalButtons.tuneId);
c0de1c18:	7bab      	ldrb	r3, [r5, #14]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de1c1a:	4606      	mov	r6, r0
            obj    = layoutAddCallbackObj(layoutInt,
c0de1c1c:	4620      	mov	r0, r4
c0de1c1e:	4631      	mov	r1, r6
c0de1c20:	f7ff fae7 	bl	c0de11f2 <layoutAddCallbackObj>
            if (obj == NULL) {
c0de1c24:	2800      	cmp	r0, #0
c0de1c26:	f000 8264 	beq.w	c0de20f2 <nbgl_layoutAddUpFooter+0x856>
c0de1c2a:	2700      	movs	r7, #0
            obj->index                   = 0;
c0de1c2c:	7147      	strb	r7, [r0, #5]
c0de1c2e:	2006      	movs	r0, #6
            button->obj.alignment        = MID_RIGHT;
c0de1c30:	72f0      	strb	r0, [r6, #11]
            button->obj.alignmentMarginX = BORDER_MARGIN;
c0de1c32:	2020      	movs	r0, #32
c0de1c34:	2103      	movs	r1, #3
c0de1c36:	7530      	strb	r0, [r6, #20]
c0de1c38:	2038      	movs	r0, #56	@ 0x38
c0de1c3a:	7577      	strb	r7, [r6, #21]
            button->innerColor           = BLACK;
c0de1c3c:	f886 7028 	strb.w	r7, [r6, #40]	@ 0x28
            button->borderColor          = BLACK;
c0de1c40:	f886 7029 	strb.w	r7, [r6, #41]	@ 0x29
            button->foregroundColor      = WHITE;
c0de1c44:	f886 102a 	strb.w	r1, [r6, #42]	@ 0x2a
            button->obj.area.width  = AVAILABLE_WIDTH - BUTTON_WIDTH - LEFT_CONTENT_ICON_TEXT_X;
c0de1c48:	f886 b005 	strb.w	fp, [r6, #5]
c0de1c4c:	7130      	strb	r0, [r6, #4]
            button->obj.area.height = BUTTON_DIAMETER;
c0de1c4e:	71f7      	strb	r7, [r6, #7]
c0de1c50:	f886 8006 	strb.w	r8, [r6, #6]
            button->radius          = BUTTON_RADIUS;
c0de1c54:	f886 a02b 	strb.w	sl, [r6, #43]	@ 0x2b
            button->text            = PIC(upFooterDesc->horizontalButtons.rightText);
c0de1c58:	68a8      	ldr	r0, [r5, #8]
c0de1c5a:	f007 feab 	bl	c0de99b4 <pic>
c0de1c5e:	4631      	mov	r1, r6
c0de1c60:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de1c64:	0e02      	lsrs	r2, r0, #24
c0de1c66:	70ca      	strb	r2, [r1, #3]
c0de1c68:	0c02      	lsrs	r2, r0, #16
c0de1c6a:	0a00      	lsrs	r0, r0, #8
c0de1c6c:	708a      	strb	r2, [r1, #2]
c0de1c6e:	7770      	strb	r0, [r6, #29]
            button->fontId          = SMALL_BOLD_FONT;
c0de1c70:	200c      	movs	r0, #12
            button->obj.touchMask   = (1 << TOUCHED);
c0de1c72:	f886 b018 	strb.w	fp, [r6, #24]
            button->fontId          = SMALL_BOLD_FONT;
c0de1c76:	f886 002c 	strb.w	r0, [r6, #44]	@ 0x2c
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) button;
c0de1c7a:	6960      	ldr	r0, [r4, #20]
c0de1c7c:	2109      	movs	r1, #9
c0de1c7e:	f810 2f1c 	ldrb.w	r2, [r0, #28]!
            button->obj.touchId     = CHOICE_1_ID;
c0de1c82:	76b1      	strb	r1, [r6, #26]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) button;
c0de1c84:	7841      	ldrb	r1, [r0, #1]
c0de1c86:	7883      	ldrb	r3, [r0, #2]
c0de1c88:	78c0      	ldrb	r0, [r0, #3]
c0de1c8a:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de1c8e:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de1c92:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
            button->obj.touchMask   = (1 << TOUCHED);
c0de1c96:	7677      	strb	r7, [r6, #25]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) button;
c0de1c98:	6046      	str	r6, [r0, #4]
c0de1c9a:	e20e      	b.n	c0de20ba <nbgl_layoutAddUpFooter+0x81e>
            if (upFooterDesc->tipBox.text == NULL) {
c0de1c9c:	6868      	ldr	r0, [r5, #4]
c0de1c9e:	2800      	cmp	r0, #0
c0de1ca0:	f000 8227 	beq.w	c0de20f2 <nbgl_layoutAddUpFooter+0x856>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de1ca4:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1ca8:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de1cac:	ea40 2002 	orr.w	r0, r0, r2, lsl #8
c0de1cb0:	f3c0 2205 	ubfx	r2, r0, #8, #6
c0de1cb4:	2a0e      	cmp	r2, #14
c0de1cb6:	f200 821c 	bhi.w	c0de20f2 <nbgl_layoutAddUpFooter+0x856>
c0de1cba:	0a03      	lsrs	r3, r0, #8
        layout->nbUsedCallbackObjs++;
c0de1cbc:	3301      	adds	r3, #1
c0de1cbe:	f003 033f 	and.w	r3, r3, #63	@ 0x3f
c0de1cc2:	f400 4740 	and.w	r7, r0, #49152	@ 0xc000
                                       upFooterDesc->tipBox.token,
c0de1cc6:	f895 e00c 	ldrb.w	lr, [r5, #12]
                                       upFooterDesc->tipBox.tuneId);
c0de1cca:	f895 c00d 	ldrb.w	ip, [r5, #13]
                                       (nbgl_obj_t *) layoutInt->upFooterContainer,
c0de1cce:	6966      	ldr	r6, [r4, #20]
        layout->nbUsedCallbackObjs++;
c0de1cd0:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de1cd4:	0a1b      	lsrs	r3, r3, #8
c0de1cd6:	f884 00ad 	strb.w	r0, [r4, #173]	@ 0xad
        layoutObj->obj    = obj;
c0de1cda:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
        layout->nbUsedCallbackObjs++;
c0de1cde:	f884 30ae 	strb.w	r3, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de1ce2:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de1ce4:	f880 e024 	strb.w	lr, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de1ce8:	f880 c026 	strb.w	ip, [r0, #38]	@ 0x26
c0de1cec:	2003      	movs	r0, #3
            layoutInt->upFooterContainer->nbChildren    = 3;
c0de1cee:	f881 0021 	strb.w	r0, [r1, #33]	@ 0x21
c0de1cf2:	2013      	movs	r0, #19
c0de1cf4:	f04f 0800 	mov.w	r8, #0
c0de1cf8:	f04f 0a01 	mov.w	sl, #1
            layoutInt->upFooterContainer->obj.touchId   = TIP_BOX_ID;
c0de1cfc:	7688      	strb	r0, [r1, #26]
            layoutInt->upFooterContainer->obj.touchMask = (1 << TOUCHED);
c0de1cfe:	f881 8019 	strb.w	r8, [r1, #25]
c0de1d02:	f881 a018 	strb.w	sl, [r1, #24]
            textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de1d06:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1d0a:	2704      	movs	r7, #4
c0de1d0c:	08c1      	lsrs	r1, r0, #3
c0de1d0e:	2004      	movs	r0, #4
c0de1d10:	f006 ff29 	bl	c0de8b66 <nbgl_objPoolGet>
            textArea->textColor = BLACK;
c0de1d14:	f880 801c 	strb.w	r8, [r0, #28]
            textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de1d18:	4606      	mov	r6, r0
            textArea->text      = PIC(upFooterDesc->tipBox.text);
c0de1d1a:	6868      	ldr	r0, [r5, #4]
c0de1d1c:	f007 fe4a 	bl	c0de99b4 <pic>
c0de1d20:	4631      	mov	r1, r6
c0de1d22:	f801 0f23 	strb.w	r0, [r1, #35]!
c0de1d26:	0e02      	lsrs	r2, r0, #24
c0de1d28:	70ca      	strb	r2, [r1, #3]
c0de1d2a:	0c02      	lsrs	r2, r0, #16
c0de1d2c:	708a      	strb	r2, [r1, #2]
c0de1d2e:	0a00      	lsrs	r0, r0, #8
            textArea->wrapping       = true;
c0de1d30:	f896 1021 	ldrb.w	r1, [r6, #33]	@ 0x21
            textArea->text      = PIC(upFooterDesc->tipBox.text);
c0de1d34:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
c0de1d38:	200b      	movs	r0, #11
            textArea->fontId         = SMALL_REGULAR_FONT;
c0de1d3a:	77f0      	strb	r0, [r6, #31]
            textArea->wrapping       = true;
c0de1d3c:	f041 0001 	orr.w	r0, r1, #1
c0de1d40:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
c0de1d44:	20a0      	movs	r0, #160	@ 0xa0
            textArea->textAlignment  = MID_LEFT;
c0de1d46:	7777      	strb	r7, [r6, #29]
            textArea->obj.area.width = AVAILABLE_WIDTH;
c0de1d48:	f886 a005 	strb.w	sl, [r6, #5]
c0de1d4c:	7130      	strb	r0, [r6, #4]
            if (upFooterDesc->tipBox.icon != NULL) {
c0de1d4e:	68a8      	ldr	r0, [r5, #8]
c0de1d50:	b180      	cbz	r0, c0de1d74 <nbgl_layoutAddUpFooter+0x4d8>
                    -= ((nbgl_icon_details_t *) PIC(upFooterDesc->tipBox.icon))->width
c0de1d52:	f007 fe2f 	bl	c0de99b4 <pic>
c0de1d56:	4632      	mov	r2, r6
c0de1d58:	f812 3f04 	ldrb.w	r3, [r2, #4]!
c0de1d5c:	7801      	ldrb	r1, [r0, #0]
c0de1d5e:	7840      	ldrb	r0, [r0, #1]
c0de1d60:	7857      	ldrb	r7, [r2, #1]
c0de1d62:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de1d66:	ea43 2107 	orr.w	r1, r3, r7, lsl #8
c0de1d6a:	1a08      	subs	r0, r1, r0
c0de1d6c:	3820      	subs	r0, #32
c0de1d6e:	7010      	strb	r0, [r2, #0]
c0de1d70:	0a00      	lsrs	r0, r0, #8
c0de1d72:	7050      	strb	r0, [r2, #1]
                textArea->fontId, textArea->text, textArea->obj.area.width, textArea->wrapping);
c0de1d74:	4630      	mov	r0, r6
c0de1d76:	f810 1f23 	ldrb.w	r1, [r0, #35]!
c0de1d7a:	f896 2024 	ldrb.w	r2, [r6, #36]	@ 0x24
c0de1d7e:	7883      	ldrb	r3, [r0, #2]
c0de1d80:	78c0      	ldrb	r0, [r0, #3]
c0de1d82:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de1d86:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de1d8a:	7932      	ldrb	r2, [r6, #4]
c0de1d8c:	7973      	ldrb	r3, [r6, #5]
c0de1d8e:	f896 7021 	ldrb.w	r7, [r6, #33]	@ 0x21
c0de1d92:	ea41 4100 	orr.w	r1, r1, r0, lsl #16
c0de1d96:	7ff0      	ldrb	r0, [r6, #31]
c0de1d98:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de1d9c:	f007 0301 	and.w	r3, r7, #1
            textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de1da0:	f006 fefa 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de1da4:	f04f 0b20 	mov.w	fp, #32
c0de1da8:	71b0      	strb	r0, [r6, #6]
            textArea->obj.alignmentMarginX                = BORDER_MARGIN;
c0de1daa:	f886 b014 	strb.w	fp, [r6, #20]
            layoutInt->upFooterContainer->children[0]     = (nbgl_obj_t *) textArea;
c0de1dae:	6962      	ldr	r2, [r4, #20]
            textArea->obj.alignment                       = MID_LEFT;
c0de1db0:	2304      	movs	r3, #4
            layoutInt->upFooterContainer->children[0]     = (nbgl_obj_t *) textArea;
c0de1db2:	f812 cf1c 	ldrb.w	ip, [r2, #28]!
            textArea->obj.alignment                       = MID_LEFT;
c0de1db6:	72f3      	strb	r3, [r6, #11]
            layoutInt->upFooterContainer->children[0]     = (nbgl_obj_t *) textArea;
c0de1db8:	7857      	ldrb	r7, [r2, #1]
c0de1dba:	7893      	ldrb	r3, [r2, #2]
c0de1dbc:	78d2      	ldrb	r2, [r2, #3]
c0de1dbe:	ea4c 2707 	orr.w	r7, ip, r7, lsl #8
c0de1dc2:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de1dc6:	ea47 4202 	orr.w	r2, r7, r2, lsl #16
c0de1dca:	6016      	str	r6, [r2, #0]
            layoutInt->upFooterContainer->obj.area.height = textArea->obj.area.height;
c0de1dcc:	6962      	ldr	r2, [r4, #20]
            textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de1dce:	0a01      	lsrs	r1, r0, #8
c0de1dd0:	71f1      	strb	r1, [r6, #7]
            textArea->obj.alignmentMarginX                = BORDER_MARGIN;
c0de1dd2:	f886 8015 	strb.w	r8, [r6, #21]
            layoutInt->upFooterContainer->obj.area.height = textArea->obj.area.height;
c0de1dd6:	71d1      	strb	r1, [r2, #7]
c0de1dd8:	7190      	strb	r0, [r2, #6]
            line                                      = createHorizontalLine(layoutInt->layer);
c0de1dda:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1dde:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de1de0:	2003      	movs	r0, #3
c0de1de2:	f006 fec0 	bl	c0de8b66 <nbgl_objPoolGet>
c0de1de6:	22e0      	movs	r2, #224	@ 0xe0
    line->obj.area.width  = SCREEN_WIDTH;
c0de1de8:	7102      	strb	r2, [r0, #4]
    line->obj.area.height = 1;
c0de1dea:	f880 a006 	strb.w	sl, [r0, #6]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) line;
c0de1dee:	6962      	ldr	r2, [r4, #20]
c0de1df0:	2102      	movs	r1, #2
c0de1df2:	f812 3f1c 	ldrb.w	r3, [r2, #28]!
    line->lineColor       = LIGHT_GRAY;
c0de1df6:	7741      	strb	r1, [r0, #29]
            line->obj.alignment                       = TOP_MIDDLE;
c0de1df8:	72c1      	strb	r1, [r0, #11]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) line;
c0de1dfa:	7851      	ldrb	r1, [r2, #1]
c0de1dfc:	7897      	ldrb	r7, [r2, #2]
c0de1dfe:	78d2      	ldrb	r2, [r2, #3]
c0de1e00:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de1e04:	ea47 2202 	orr.w	r2, r7, r2, lsl #8
c0de1e08:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
    line->obj.area.width  = SCREEN_WIDTH;
c0de1e0c:	f880 a005 	strb.w	sl, [r0, #5]
    line->obj.area.height = 1;
c0de1e10:	f880 8007 	strb.w	r8, [r0, #7]
    line->direction       = HORIZONTAL;
c0de1e14:	f880 a01c 	strb.w	sl, [r0, #28]
    line->thickness       = 1;
c0de1e18:	f880 a01e 	strb.w	sl, [r0, #30]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) line;
c0de1e1c:	6048      	str	r0, [r1, #4]
            if (upFooterDesc->tipBox.icon != NULL) {
c0de1e1e:	68a8      	ldr	r0, [r5, #8]
c0de1e20:	2800      	cmp	r0, #0
c0de1e22:	d03f      	beq.n	c0de1ea4 <nbgl_layoutAddUpFooter+0x608>
                nbgl_image_t *image = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de1e24:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1e28:	08c1      	lsrs	r1, r0, #3
c0de1e2a:	2002      	movs	r0, #2
c0de1e2c:	f006 fe9b 	bl	c0de8b66 <nbgl_objPoolGet>
c0de1e30:	4606      	mov	r6, r0
c0de1e32:	2000      	movs	r0, #0
c0de1e34:	2106      	movs	r1, #6
                image->obj.alignmentMarginX               = BORDER_MARGIN;
c0de1e36:	7570      	strb	r0, [r6, #21]
c0de1e38:	f886 b014 	strb.w	fp, [r6, #20]
                image->obj.alignment                      = MID_RIGHT;
c0de1e3c:	72f1      	strb	r1, [r6, #11]
                image->foregroundColor                    = BLACK;
c0de1e3e:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
                image->buffer                             = PIC(upFooterDesc->tipBox.icon);
c0de1e42:	68a8      	ldr	r0, [r5, #8]
c0de1e44:	f007 fdb6 	bl	c0de99b4 <pic>
c0de1e48:	4631      	mov	r1, r6
c0de1e4a:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de1e4e:	0c02      	lsrs	r2, r0, #16
c0de1e50:	708a      	strb	r2, [r1, #2]
c0de1e52:	0a02      	lsrs	r2, r0, #8
c0de1e54:	7772      	strb	r2, [r6, #29]
                layoutInt->upFooterContainer->children[2] = (nbgl_obj_t *) image;
c0de1e56:	6962      	ldr	r2, [r4, #20]
                image->buffer                             = PIC(upFooterDesc->tipBox.icon);
c0de1e58:	0e00      	lsrs	r0, r0, #24
                layoutInt->upFooterContainer->children[2] = (nbgl_obj_t *) image;
c0de1e5a:	f812 3f1c 	ldrb.w	r3, [r2, #28]!
                image->buffer                             = PIC(upFooterDesc->tipBox.icon);
c0de1e5e:	70c8      	strb	r0, [r1, #3]
                layoutInt->upFooterContainer->children[2] = (nbgl_obj_t *) image;
c0de1e60:	7850      	ldrb	r0, [r2, #1]
c0de1e62:	7897      	ldrb	r7, [r2, #2]
c0de1e64:	78d2      	ldrb	r2, [r2, #3]
c0de1e66:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de1e6a:	ea47 2202 	orr.w	r2, r7, r2, lsl #8
c0de1e6e:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de1e72:	6086      	str	r6, [r0, #8]
                if (layoutInt->upFooterContainer->obj.area.height < image->buffer->height) {
c0de1e74:	7f73      	ldrb	r3, [r6, #29]
c0de1e76:	780f      	ldrb	r7, [r1, #0]
c0de1e78:	788e      	ldrb	r6, [r1, #2]
c0de1e7a:	78c9      	ldrb	r1, [r1, #3]
c0de1e7c:	6960      	ldr	r0, [r4, #20]
c0de1e7e:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de1e82:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de1e86:	ea43 4101 	orr.w	r1, r3, r1, lsl #16
c0de1e8a:	7982      	ldrb	r2, [r0, #6]
c0de1e8c:	79c7      	ldrb	r7, [r0, #7]
c0de1e8e:	788b      	ldrb	r3, [r1, #2]
c0de1e90:	78c9      	ldrb	r1, [r1, #3]
c0de1e92:	ea42 2207 	orr.w	r2, r2, r7, lsl #8
c0de1e96:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de1e9a:	428a      	cmp	r2, r1
                    layoutInt->upFooterContainer->obj.area.height = image->buffer->height;
c0de1e9c:	bf3e      	ittt	cc
c0de1e9e:	7181      	strbcc	r1, [r0, #6]
c0de1ea0:	0a09      	lsrcc	r1, r1, #8
c0de1ea2:	71c1      	strbcc	r1, [r0, #7]
            layoutInt->upFooterContainer->obj.area.height += 2 * TIP_BOX_MARGIN_Y;
c0de1ea4:	6960      	ldr	r0, [r4, #20]
c0de1ea6:	f810 1f06 	ldrb.w	r1, [r0, #6]!
c0de1eaa:	7842      	ldrb	r2, [r0, #1]
c0de1eac:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de1eb0:	3130      	adds	r1, #48	@ 0x30
c0de1eb2:	7001      	strb	r1, [r0, #0]
c0de1eb4:	0a09      	lsrs	r1, r1, #8
c0de1eb6:	7041      	strb	r1, [r0, #1]
c0de1eb8:	e0ff      	b.n	c0de20ba <nbgl_layoutAddUpFooter+0x81e>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de1eba:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1ebe:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de1ec2:	ea40 2002 	orr.w	r0, r0, r2, lsl #8
c0de1ec6:	f3c0 2205 	ubfx	r2, r0, #8, #6
c0de1eca:	2a0e      	cmp	r2, #14
c0de1ecc:	f200 8111 	bhi.w	c0de20f2 <nbgl_layoutAddUpFooter+0x856>
c0de1ed0:	0a03      	lsrs	r3, r0, #8
        layout->nbUsedCallbackObjs++;
c0de1ed2:	3301      	adds	r3, #1
c0de1ed4:	f003 033f 	and.w	r3, r3, #63	@ 0x3f
c0de1ed8:	f400 4740 	and.w	r7, r0, #49152	@ 0xc000
                                       upFooterDesc->longPress.token,
c0de1edc:	f895 e008 	ldrb.w	lr, [r5, #8]
                                       upFooterDesc->longPress.tuneId);
c0de1ee0:	f895 c009 	ldrb.w	ip, [r5, #9]
                                       (nbgl_obj_t *) layoutInt->upFooterContainer,
c0de1ee4:	6966      	ldr	r6, [r4, #20]
        layout->nbUsedCallbackObjs++;
c0de1ee6:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de1eea:	0a1b      	lsrs	r3, r3, #8
c0de1eec:	f884 00ad 	strb.w	r0, [r4, #173]	@ 0xad
        layoutObj->obj    = obj;
c0de1ef0:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
        layout->nbUsedCallbackObjs++;
c0de1ef4:	f884 30ae 	strb.w	r3, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de1ef8:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de1efa:	f880 e024 	strb.w	lr, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de1efe:	f880 c026 	strb.w	ip, [r0, #38]	@ 0x26
c0de1f02:	2098      	movs	r0, #152	@ 0x98
            layoutInt->upFooterContainer->obj.area.height = LONG_PRESS_BUTTON_HEIGHT;
c0de1f04:	7188      	strb	r0, [r1, #6]
c0de1f06:	2012      	movs	r0, #18
c0de1f08:	f04f 0804 	mov.w	r8, #4
c0de1f0c:	f04f 0b00 	mov.w	fp, #0
            layoutInt->upFooterContainer->obj.touchId     = LONG_PRESS_BUTTON_ID;
c0de1f10:	7688      	strb	r0, [r1, #26]
c0de1f12:	2703      	movs	r7, #3
c0de1f14:	202c      	movs	r0, #44	@ 0x2c
            layoutInt->upFooterContainer->nbChildren      = 4;
c0de1f16:	f881 8021 	strb.w	r8, [r1, #33]	@ 0x21
            layoutInt->upFooterContainer->obj.area.height = LONG_PRESS_BUTTON_HEIGHT;
c0de1f1a:	f881 b007 	strb.w	fp, [r1, #7]
                = ((1 << TOUCHING) | (1 << TOUCH_RELEASED) | (1 << OUT_OF_TOUCH)
c0de1f1e:	764f      	strb	r7, [r1, #25]
c0de1f20:	7608      	strb	r0, [r1, #24]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de1f22:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1f26:	08c1      	lsrs	r1, r0, #3
c0de1f28:	2005      	movs	r0, #5
c0de1f2a:	f006 fe1c 	bl	c0de8b66 <nbgl_objPoolGet>
c0de1f2e:	f04f 0a20 	mov.w	sl, #32
c0de1f32:	4606      	mov	r6, r0
            button->obj.alignmentMarginX              = BORDER_MARGIN;
c0de1f34:	f880 b015 	strb.w	fp, [r0, #21]
c0de1f38:	f880 a014 	strb.w	sl, [r0, #20]
c0de1f3c:	2006      	movs	r0, #6
            button->obj.alignment                     = MID_RIGHT;
c0de1f3e:	72f0      	strb	r0, [r6, #11]
            button->foregroundColor                   = WHITE;
c0de1f40:	f886 702a 	strb.w	r7, [r6, #42]	@ 0x2a
c0de1f44:	2058      	movs	r0, #88	@ 0x58
            button->obj.area.width                    = BUTTON_DIAMETER;
c0de1f46:	4637      	mov	r7, r6
c0de1f48:	f807 0f04 	strb.w	r0, [r7, #4]!
            button->innerColor                        = BLACK;
c0de1f4c:	f886 b028 	strb.w	fp, [r6, #40]	@ 0x28
            button->borderColor                       = BLACK;
c0de1f50:	f886 b029 	strb.w	fp, [r6, #41]	@ 0x29
            button->obj.area.width                    = BUTTON_DIAMETER;
c0de1f54:	f887 b001 	strb.w	fp, [r7, #1]
            button->obj.area.height                   = BUTTON_DIAMETER;
c0de1f58:	f886 b007 	strb.w	fp, [r6, #7]
c0de1f5c:	71b0      	strb	r0, [r6, #6]
            button->radius                            = BUTTON_RADIUS;
c0de1f5e:	f886 802b 	strb.w	r8, [r6, #43]	@ 0x2b
            button->icon                              = PIC(&VALIDATE_ICON);
c0de1f62:	f248 50be 	movw	r0, #34238	@ 0x85be
c0de1f66:	f2c0 0000 	movt	r0, #0
c0de1f6a:	4478      	add	r0, pc
c0de1f6c:	f007 fd22 	bl	c0de99b4 <pic>
c0de1f70:	4631      	mov	r1, r6
c0de1f72:	f801 0f24 	strb.w	r0, [r1, #36]!
c0de1f76:	0c02      	lsrs	r2, r0, #16
c0de1f78:	708a      	strb	r2, [r1, #2]
c0de1f7a:	0a02      	lsrs	r2, r0, #8
c0de1f7c:	f886 2025 	strb.w	r2, [r6, #37]	@ 0x25
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de1f80:	6962      	ldr	r2, [r4, #20]
            button->icon                              = PIC(&VALIDATE_ICON);
c0de1f82:	0e00      	lsrs	r0, r0, #24
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de1f84:	f812 3f1c 	ldrb.w	r3, [r2, #28]!
            button->icon                              = PIC(&VALIDATE_ICON);
c0de1f88:	70c8      	strb	r0, [r1, #3]
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de1f8a:	7850      	ldrb	r0, [r2, #1]
c0de1f8c:	7891      	ldrb	r1, [r2, #2]
c0de1f8e:	78d2      	ldrb	r2, [r2, #3]
c0de1f90:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de1f94:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de1f98:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de1f9c:	6006      	str	r6, [r0, #0]
            textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de1f9e:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1fa2:	08c1      	lsrs	r1, r0, #3
c0de1fa4:	2004      	movs	r0, #4
c0de1fa6:	f006 fdde 	bl	c0de8b66 <nbgl_objPoolGet>
            textArea->textColor = BLACK;
c0de1faa:	f880 b01c 	strb.w	fp, [r0, #28]
            textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de1fae:	4606      	mov	r6, r0
            textArea->text      = PIC(upFooterDesc->longPress.text);
c0de1fb0:	6868      	ldr	r0, [r5, #4]
c0de1fb2:	f007 fcff 	bl	c0de99b4 <pic>
c0de1fb6:	4601      	mov	r1, r0
c0de1fb8:	4630      	mov	r0, r6
c0de1fba:	f800 1f23 	strb.w	r1, [r0, #35]!
c0de1fbe:	0e0a      	lsrs	r2, r1, #24
c0de1fc0:	70c2      	strb	r2, [r0, #3]
c0de1fc2:	0c0a      	lsrs	r2, r1, #16
c0de1fc4:	7082      	strb	r2, [r0, #2]
c0de1fc6:	0a08      	lsrs	r0, r1, #8
c0de1fc8:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
            textArea->wrapping        = true;
c0de1fcc:	f896 0021 	ldrb.w	r0, [r6, #33]	@ 0x21
c0de1fd0:	220d      	movs	r2, #13
c0de1fd2:	f040 0001 	orr.w	r0, r0, #1
c0de1fd6:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
            textArea->obj.area.width  = SCREEN_WIDTH - 3 * BORDER_MARGIN - button->obj.area.width;
c0de1fda:	7838      	ldrb	r0, [r7, #0]
c0de1fdc:	787b      	ldrb	r3, [r7, #1]
            textArea->fontId          = LARGE_MEDIUM_FONT;
c0de1fde:	77f2      	strb	r2, [r6, #31]
            textArea->obj.area.width  = SCREEN_WIDTH - 3 * BORDER_MARGIN - button->obj.area.width;
c0de1fe0:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de1fe4:	f5c0 70c0 	rsb	r0, r0, #384	@ 0x180
c0de1fe8:	0a02      	lsrs	r2, r0, #8
c0de1fea:	7130      	strb	r0, [r6, #4]
c0de1fec:	7172      	strb	r2, [r6, #5]
            textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de1fee:	b282      	uxth	r2, r0
c0de1ff0:	200d      	movs	r0, #13
c0de1ff2:	2301      	movs	r3, #1
            textArea->textAlignment   = MID_LEFT;
c0de1ff4:	f886 801d 	strb.w	r8, [r6, #29]
c0de1ff8:	2701      	movs	r7, #1
            textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de1ffa:	f006 fdcd 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de1ffe:	71b0      	strb	r0, [r6, #6]
c0de2000:	0a00      	lsrs	r0, r0, #8
            textArea->obj.alignmentMarginX            = BORDER_MARGIN;
c0de2002:	f886 a014 	strb.w	sl, [r6, #20]
            textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de2006:	71f0      	strb	r0, [r6, #7]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) textArea;
c0de2008:	6960      	ldr	r0, [r4, #20]
            textArea->style                           = NO_STYLE;
c0de200a:	f886 b01e 	strb.w	fp, [r6, #30]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) textArea;
c0de200e:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
            textArea->obj.alignment                   = MID_LEFT;
c0de2012:	f886 800b 	strb.w	r8, [r6, #11]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) textArea;
c0de2016:	7842      	ldrb	r2, [r0, #1]
c0de2018:	7883      	ldrb	r3, [r0, #2]
c0de201a:	78c0      	ldrb	r0, [r0, #3]
c0de201c:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de2020:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de2024:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
            textArea->obj.alignmentMarginX            = BORDER_MARGIN;
c0de2028:	f886 b015 	strb.w	fp, [r6, #21]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) textArea;
c0de202c:	6046      	str	r6, [r0, #4]
            line                                      = createHorizontalLine(layoutInt->layer);
c0de202e:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2032:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de2034:	2003      	movs	r0, #3
c0de2036:	f006 fd96 	bl	c0de8b66 <nbgl_objPoolGet>
c0de203a:	f04f 08e0 	mov.w	r8, #224	@ 0xe0
    line->obj.area.width  = SCREEN_WIDTH;
c0de203e:	f880 8004 	strb.w	r8, [r0, #4]
    line->obj.area.height = 1;
c0de2042:	7187      	strb	r7, [r0, #6]
            layoutInt->upFooterContainer->children[2] = (nbgl_obj_t *) line;
c0de2044:	6961      	ldr	r1, [r4, #20]
c0de2046:	f04f 0a02 	mov.w	sl, #2
c0de204a:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
    line->lineColor       = LIGHT_GRAY;
c0de204e:	f880 a01d 	strb.w	sl, [r0, #29]
            layoutInt->upFooterContainer->children[2] = (nbgl_obj_t *) line;
c0de2052:	784b      	ldrb	r3, [r1, #1]
c0de2054:	788e      	ldrb	r6, [r1, #2]
c0de2056:	78c9      	ldrb	r1, [r1, #3]
c0de2058:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de205c:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de2060:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
    line->obj.area.width  = SCREEN_WIDTH;
c0de2064:	7147      	strb	r7, [r0, #5]
    line->obj.area.height = 1;
c0de2066:	f880 b007 	strb.w	fp, [r0, #7]
    line->direction       = HORIZONTAL;
c0de206a:	7707      	strb	r7, [r0, #28]
    line->thickness       = 1;
c0de206c:	7787      	strb	r7, [r0, #30]
            line->obj.alignment                       = TOP_MIDDLE;
c0de206e:	f880 a00b 	strb.w	sl, [r0, #11]
            layoutInt->upFooterContainer->children[2] = (nbgl_obj_t *) line;
c0de2072:	6088      	str	r0, [r1, #8]
            progressBar = (nbgl_progress_bar_t *) nbgl_objPoolGet(PROGRESS_BAR, layoutInt->layer);
c0de2074:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2078:	2608      	movs	r6, #8
c0de207a:	08c1      	lsrs	r1, r0, #3
c0de207c:	2008      	movs	r0, #8
c0de207e:	f006 fd72 	bl	c0de8b66 <nbgl_objPoolGet>
            progressBar->resetIfOverriden             = true;
c0de2082:	7fc1      	ldrb	r1, [r0, #31]
            progressBar->obj.area.width               = SCREEN_WIDTH;
c0de2084:	f880 8004 	strb.w	r8, [r0, #4]
            progressBar->partialRedraw                = true;
c0de2088:	f041 0105 	orr.w	r1, r1, #5
            progressBar->obj.area.height              = LONG_PRESS_PROGRESS_HEIGHT;
c0de208c:	7186      	strb	r6, [r0, #6]
            progressBar->obj.alignmentMarginY         = LONG_PRESS_PROGRESS_ALIGN;
c0de208e:	7587      	strb	r7, [r0, #22]
            progressBar->partialRedraw                = true;
c0de2090:	77c1      	strb	r1, [r0, #31]
            layoutInt->upFooterContainer->children[3] = (nbgl_obj_t *) progressBar;
c0de2092:	6961      	ldr	r1, [r4, #20]
            progressBar->obj.area.width               = SCREEN_WIDTH;
c0de2094:	7147      	strb	r7, [r0, #5]
            layoutInt->upFooterContainer->children[3] = (nbgl_obj_t *) progressBar;
c0de2096:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
            progressBar->obj.area.height              = LONG_PRESS_PROGRESS_HEIGHT;
c0de209a:	f880 b007 	strb.w	fp, [r0, #7]
            layoutInt->upFooterContainer->children[3] = (nbgl_obj_t *) progressBar;
c0de209e:	784b      	ldrb	r3, [r1, #1]
c0de20a0:	788f      	ldrb	r7, [r1, #2]
c0de20a2:	78c9      	ldrb	r1, [r1, #3]
c0de20a4:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de20a8:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de20ac:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
            progressBar->obj.alignment                = TOP_MIDDLE;
c0de20b0:	f880 a00b 	strb.w	sl, [r0, #11]
            progressBar->obj.alignmentMarginY         = LONG_PRESS_PROGRESS_ALIGN;
c0de20b4:	f880 b017 	strb.w	fp, [r0, #23]
            layoutInt->upFooterContainer->children[3] = (nbgl_obj_t *) progressBar;
c0de20b8:	60c8      	str	r0, [r1, #12]
    layoutInt->container->obj.area.height -= layoutInt->upFooterContainer->obj.area.height;
c0de20ba:	6960      	ldr	r0, [r4, #20]
c0de20bc:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
c0de20c0:	7982      	ldrb	r2, [r0, #6]
c0de20c2:	79c3      	ldrb	r3, [r0, #7]
c0de20c4:	f811 7f06 	ldrb.w	r7, [r1, #6]!
c0de20c8:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de20cc:	784b      	ldrb	r3, [r1, #1]
    layoutInt->children[UP_FOOTER_INDEX] = (nbgl_obj_t *) layoutInt->upFooterContainer;
c0de20ce:	68a6      	ldr	r6, [r4, #8]
    layoutInt->container->obj.area.height -= layoutInt->upFooterContainer->obj.area.height;
c0de20d0:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de20d4:	1a9a      	subs	r2, r3, r2
c0de20d6:	700a      	strb	r2, [r1, #0]
    layoutInt->children[UP_FOOTER_INDEX] = (nbgl_obj_t *) layoutInt->upFooterContainer;
c0de20d8:	6130      	str	r0, [r6, #16]
    layoutInt->container->obj.area.height -= layoutInt->upFooterContainer->obj.area.height;
c0de20da:	0a12      	lsrs	r2, r2, #8
    return layoutInt->upFooterContainer->obj.area.height;
c0de20dc:	6960      	ldr	r0, [r4, #20]
    layoutInt->container->obj.area.height -= layoutInt->upFooterContainer->obj.area.height;
c0de20de:	704a      	strb	r2, [r1, #1]
    return layoutInt->upFooterContainer->obj.area.height;
c0de20e0:	7982      	ldrb	r2, [r0, #6]
c0de20e2:	79c0      	ldrb	r0, [r0, #7]
    layoutInt->upFooterType = upFooterDesc->type;
c0de20e4:	7829      	ldrb	r1, [r5, #0]
    return layoutInt->upFooterContainer->obj.area.height;
c0de20e6:	ea42 2000 	orr.w	r0, r2, r0, lsl #8
    layoutInt->upFooterType = upFooterDesc->type;
c0de20ea:	f884 10ac 	strb.w	r1, [r4, #172]	@ 0xac
}
c0de20ee:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de20f2:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de20f6:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de20fa <nbgl_layoutAddSwipe>:
{
c0de20fa:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
    if (layout == NULL) {
c0de20fe:	2800      	cmp	r0, #0
c0de2100:	d05f      	beq.n	c0de21c2 <nbgl_layoutAddSwipe+0xc8>
c0de2102:	461d      	mov	r5, r3
c0de2104:	4617      	mov	r7, r2
c0de2106:	4604      	mov	r4, r0
c0de2108:	460e      	mov	r6, r1
    if (text) {
c0de210a:	b362      	cbz	r2, c0de2166 <nbgl_layoutAddSwipe+0x6c>
        layoutInt->tapText                  = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, 0);
c0de210c:	2004      	movs	r0, #4
c0de210e:	2100      	movs	r1, #0
c0de2110:	f04f 0800 	mov.w	r8, #0
c0de2114:	f006 fd27 	bl	c0de8b66 <nbgl_objPoolGet>
c0de2118:	61a0      	str	r0, [r4, #24]
        layoutInt->tapText->text            = PIC(text);
c0de211a:	4638      	mov	r0, r7
c0de211c:	f007 fc4a 	bl	c0de99b4 <pic>
c0de2120:	69a1      	ldr	r1, [r4, #24]
c0de2122:	0e02      	lsrs	r2, r0, #24
c0de2124:	f801 0f23 	strb.w	r0, [r1, #35]!
c0de2128:	70ca      	strb	r2, [r1, #3]
c0de212a:	0c02      	lsrs	r2, r0, #16
c0de212c:	0a00      	lsrs	r0, r0, #8
c0de212e:	7048      	strb	r0, [r1, #1]
c0de2130:	2001      	movs	r0, #1
        layoutInt->tapText->textColor       = LIGHT_TEXT_COLOR;
c0de2132:	f801 0c07 	strb.w	r0, [r1, #-7]
        layoutInt->tapText->obj.area.width  = AVAILABLE_WIDTH;
c0de2136:	f801 0c1e 	strb.w	r0, [r1, #-30]
c0de213a:	20a0      	movs	r0, #160	@ 0xa0
        layoutInt->tapText->text            = PIC(text);
c0de213c:	708a      	strb	r2, [r1, #2]
c0de213e:	220b      	movs	r2, #11
        layoutInt->tapText->obj.area.width  = AVAILABLE_WIDTH;
c0de2140:	f801 0c1f 	strb.w	r0, [r1, #-31]
        layoutInt->tapText->obj.area.height = nbgl_getFontLineHeight(layoutInt->tapText->fontId);
c0de2144:	200b      	movs	r0, #11
        layoutInt->tapText->fontId          = SMALL_REGULAR_FONT;
c0de2146:	f801 2c04 	strb.w	r2, [r1, #-4]
        layoutInt->tapText->obj.area.height = nbgl_getFontLineHeight(layoutInt->tapText->fontId);
c0de214a:	f006 fd20 	bl	c0de8b8e <nbgl_getFontLineHeight>
c0de214e:	69a1      	ldr	r1, [r4, #24]
c0de2150:	7188      	strb	r0, [r1, #6]
c0de2152:	2005      	movs	r0, #5
        layoutInt->tapText->textAlignment   = CENTER;
c0de2154:	7748      	strb	r0, [r1, #29]
c0de2156:	201e      	movs	r0, #30
        layoutInt->tapText->obj.alignmentMarginY = TAP_TO_CONTINUE_MARGIN;
c0de2158:	7588      	strb	r0, [r1, #22]
c0de215a:	2008      	movs	r0, #8
        layoutInt->tapText->obj.area.height = nbgl_getFontLineHeight(layoutInt->tapText->fontId);
c0de215c:	f881 8007 	strb.w	r8, [r1, #7]
        layoutInt->tapText->obj.alignmentMarginY = TAP_TO_CONTINUE_MARGIN;
c0de2160:	f881 8017 	strb.w	r8, [r1, #23]
        layoutInt->tapText->obj.alignment        = BOTTOM_MIDDLE;
c0de2164:	72c8      	strb	r0, [r1, #11]
    if ((swipesMask & SWIPE_MASK) == 0) {
c0de2166:	f416 7f70 	tst.w	r6, #960	@ 0x3c0
c0de216a:	d02a      	beq.n	c0de21c2 <nbgl_layoutAddSwipe+0xc8>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de216c:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2170:	f894 10ae 	ldrb.w	r1, [r4, #174]	@ 0xae
c0de2174:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de2178:	f3c0 2105 	ubfx	r1, r0, #8, #6
c0de217c:	290e      	cmp	r1, #14
c0de217e:	d820      	bhi.n	c0de21c2 <nbgl_layoutAddSwipe+0xc8>
c0de2180:	0a03      	lsrs	r3, r0, #8
        layout->nbUsedCallbackObjs++;
c0de2182:	3301      	adds	r3, #1
c0de2184:	f003 033f 	and.w	r3, r3, #63	@ 0x3f
c0de2188:	f400 4240 	and.w	r2, r0, #49152	@ 0xc000
c0de218c:	f8dd c018 	ldr.w	ip, [sp, #24]
    obj = layoutAddCallbackObj(layoutInt, (nbgl_obj_t *) layoutInt->container, token, tuneId);
c0de2190:	f8d4 70a0 	ldr.w	r7, [r4, #160]	@ 0xa0
        layout->nbUsedCallbackObjs++;
c0de2194:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de2198:	0a12      	lsrs	r2, r2, #8
c0de219a:	f884 00ad 	strb.w	r0, [r4, #173]	@ 0xad
        layoutObj->obj    = obj;
c0de219e:	eb04 00c1 	add.w	r0, r4, r1, lsl #3
        layout->nbUsedCallbackObjs++;
c0de21a2:	f884 20ae 	strb.w	r2, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de21a6:	6207      	str	r7, [r0, #32]
        layoutObj->token  = token;
c0de21a8:	f880 5024 	strb.w	r5, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de21ac:	f880 c026 	strb.w	ip, [r0, #38]	@ 0x26
    layoutInt->container->obj.touchMask = swipesMask;
c0de21b0:	0a30      	lsrs	r0, r6, #8
c0de21b2:	7678      	strb	r0, [r7, #25]
c0de21b4:	2001      	movs	r0, #1
c0de21b6:	763e      	strb	r6, [r7, #24]
    layoutInt->swipeUsage               = usage;
c0de21b8:	f884 00b0 	strb.w	r0, [r4, #176]	@ 0xb0
c0de21bc:	2000      	movs	r0, #0
}
c0de21be:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
c0de21c2:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de21c6:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}

c0de21ca <nbgl_layoutAddTopRightButton>:
{
c0de21ca:	e92d 45f0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, lr}
c0de21ce:	b081      	sub	sp, #4
    if (layout == NULL) {
c0de21d0:	2800      	cmp	r0, #0
c0de21d2:	d056      	beq.n	c0de2282 <nbgl_layoutAddTopRightButton+0xb8>
c0de21d4:	4604      	mov	r4, r0
    button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de21d6:	f890 00ad 	ldrb.w	r0, [r0, #173]	@ 0xad
c0de21da:	4688      	mov	r8, r1
c0de21dc:	08c1      	lsrs	r1, r0, #3
c0de21de:	2005      	movs	r0, #5
c0de21e0:	461f      	mov	r7, r3
c0de21e2:	4615      	mov	r5, r2
c0de21e4:	f04f 0a05 	mov.w	sl, #5
c0de21e8:	f006 fcbd 	bl	c0de8b66 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de21ec:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de21f0:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de21f4:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de21f8:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de21fc:	2a0e      	cmp	r2, #14
c0de21fe:	d840      	bhi.n	c0de2282 <nbgl_layoutAddTopRightButton+0xb8>
c0de2200:	4606      	mov	r6, r0
c0de2202:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de2204:	3001      	adds	r0, #1
c0de2206:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de220a:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de220e:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de2212:	0a00      	lsrs	r0, r0, #8
c0de2214:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de2218:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de221c:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de221e:	f880 5024 	strb.w	r5, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de2222:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
c0de2226:	2058      	movs	r0, #88	@ 0x58
        layout->nbUsedCallbackObjs++;
c0de2228:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
    button->obj.area.width       = BUTTON_WIDTH;
c0de222c:	7130      	strb	r0, [r6, #4]
    button->obj.area.height      = BUTTON_DIAMETER;
c0de222e:	71b0      	strb	r0, [r6, #6]
c0de2230:	2004      	movs	r0, #4
    button->radius               = BUTTON_RADIUS;
c0de2232:	f886 002b 	strb.w	r0, [r6, #43]	@ 0x2b
c0de2236:	2020      	movs	r0, #32
    button->obj.alignmentMarginX = BORDER_MARGIN;
c0de2238:	7530      	strb	r0, [r6, #20]
    button->obj.alignmentMarginY = BORDER_MARGIN;
c0de223a:	75b0      	strb	r0, [r6, #22]
c0de223c:	2002      	movs	r0, #2
    button->borderColor          = LIGHT_GRAY;
c0de223e:	f886 0029 	strb.w	r0, [r6, #41]	@ 0x29
c0de2242:	2001      	movs	r0, #1
c0de2244:	2700      	movs	r7, #0
c0de2246:	2503      	movs	r5, #3
    button->obj.touchMask        = (1 << TOUCHED);
c0de2248:	7630      	strb	r0, [r6, #24]
    button->icon                 = PIC(icon);
c0de224a:	4640      	mov	r0, r8
    button->obj.area.width       = BUTTON_WIDTH;
c0de224c:	7177      	strb	r7, [r6, #5]
    button->obj.area.height      = BUTTON_DIAMETER;
c0de224e:	71f7      	strb	r7, [r6, #7]
    button->obj.alignmentMarginX = BORDER_MARGIN;
c0de2250:	7577      	strb	r7, [r6, #21]
    button->obj.alignmentMarginY = BORDER_MARGIN;
c0de2252:	75f7      	strb	r7, [r6, #23]
    button->foregroundColor      = BLACK;
c0de2254:	f886 702a 	strb.w	r7, [r6, #42]	@ 0x2a
    button->innerColor           = WHITE;
c0de2258:	f886 5028 	strb.w	r5, [r6, #40]	@ 0x28
    button->obj.touchMask        = (1 << TOUCHED);
c0de225c:	7677      	strb	r7, [r6, #25]
    button->obj.touchId          = TOP_RIGHT_BUTTON_ID;
c0de225e:	f886 a01a 	strb.w	sl, [r6, #26]
    button->icon                 = PIC(icon);
c0de2262:	f007 fba7 	bl	c0de99b4 <pic>
c0de2266:	4631      	mov	r1, r6
c0de2268:	f801 0f24 	strb.w	r0, [r1, #36]!
c0de226c:	0e02      	lsrs	r2, r0, #24
c0de226e:	70ca      	strb	r2, [r1, #3]
c0de2270:	0c02      	lsrs	r2, r0, #16
c0de2272:	0a00      	lsrs	r0, r0, #8
c0de2274:	708a      	strb	r2, [r1, #2]
c0de2276:	f886 0025 	strb.w	r0, [r6, #37]	@ 0x25
    layoutInt->children[TOP_RIGHT_BUTTON_INDEX] = (nbgl_obj_t *) button;
c0de227a:	68a0      	ldr	r0, [r4, #8]
    button->obj.alignment        = TOP_RIGHT;
c0de227c:	72f5      	strb	r5, [r6, #11]
    layoutInt->children[TOP_RIGHT_BUTTON_INDEX] = (nbgl_obj_t *) button;
c0de227e:	6086      	str	r6, [r0, #8]
c0de2280:	e001      	b.n	c0de2286 <nbgl_layoutAddTopRightButton+0xbc>
c0de2282:	f04f 37ff 	mov.w	r7, #4294967295	@ 0xffffffff
}
c0de2286:	4638      	mov	r0, r7
c0de2288:	b001      	add	sp, #4
c0de228a:	e8bd 85f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, pc}

c0de228e <nbgl_layoutAddExtendedFooter>:
{
c0de228e:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de2292:	b082      	sub	sp, #8
    if (layout == NULL) {
c0de2294:	2800      	cmp	r0, #0
c0de2296:	f000 8487 	beq.w	c0de2ba8 <nbgl_layoutAddExtendedFooter+0x91a>
c0de229a:	468a      	mov	sl, r1
    if ((footerDesc == NULL) || (footerDesc->type >= NB_FOOTER_TYPES)) {
c0de229c:	b121      	cbz	r1, c0de22a8 <nbgl_layoutAddExtendedFooter+0x1a>
c0de229e:	4604      	mov	r4, r0
c0de22a0:	f89a 0000 	ldrb.w	r0, [sl]
c0de22a4:	2806      	cmp	r0, #6
c0de22a6:	d903      	bls.n	c0de22b0 <nbgl_layoutAddExtendedFooter+0x22>
c0de22a8:	f06f 0701 	mvn.w	r7, #1
c0de22ac:	f000 bc7e 	b.w	c0de2bac <nbgl_layoutAddExtendedFooter+0x91e>
    layoutInt->footerContainer = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de22b0:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de22b4:	2601      	movs	r6, #1
c0de22b6:	08c1      	lsrs	r1, r0, #3
c0de22b8:	2001      	movs	r0, #1
c0de22ba:	f006 fc54 	bl	c0de8b66 <nbgl_objPoolGet>
c0de22be:	21e0      	movs	r1, #224	@ 0xe0
c0de22c0:	6120      	str	r0, [r4, #16]
    layoutInt->footerContainer->obj.area.width = SCREEN_WIDTH;
c0de22c2:	7101      	strb	r1, [r0, #4]
c0de22c4:	2100      	movs	r1, #0
c0de22c6:	7146      	strb	r6, [r0, #5]
    layoutInt->footerContainer->layout         = VERTICAL;
c0de22c8:	f880 1020 	strb.w	r1, [r0, #32]
        = (nbgl_obj_t **) nbgl_containerPoolGet(5, layoutInt->layer);
c0de22cc:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de22d0:	08c1      	lsrs	r1, r0, #3
c0de22d2:	2005      	movs	r0, #5
c0de22d4:	f006 fc4c 	bl	c0de8b70 <nbgl_containerPoolGet>
c0de22d8:	4601      	mov	r1, r0
    layoutInt->footerContainer->children
c0de22da:	6920      	ldr	r0, [r4, #16]
        = (nbgl_obj_t **) nbgl_containerPoolGet(5, layoutInt->layer);
c0de22dc:	0a0a      	lsrs	r2, r1, #8
c0de22de:	7742      	strb	r2, [r0, #29]
c0de22e0:	4602      	mov	r2, r0
c0de22e2:	f802 1f1c 	strb.w	r1, [r2, #28]!
c0de22e6:	0e0b      	lsrs	r3, r1, #24
c0de22e8:	0c09      	lsrs	r1, r1, #16
c0de22ea:	7091      	strb	r1, [r2, #2]
    switch (footerDesc->type) {
c0de22ec:	f89a 1000 	ldrb.w	r1, [sl]
        = (nbgl_obj_t **) nbgl_containerPoolGet(5, layoutInt->layer);
c0de22f0:	70d3      	strb	r3, [r2, #3]
c0de22f2:	2208      	movs	r2, #8
    switch (footerDesc->type) {
c0de22f4:	2902      	cmp	r1, #2
c0de22f6:	f06f 0701 	mvn.w	r7, #1
    layoutInt->footerContainer->obj.alignment = BOTTOM_MIDDLE;
c0de22fa:	72c2      	strb	r2, [r0, #11]
    switch (footerDesc->type) {
c0de22fc:	dd46      	ble.n	c0de238c <nbgl_layoutAddExtendedFooter+0xfe>
c0de22fe:	2904      	cmp	r1, #4
c0de2300:	f300 812f 	bgt.w	c0de2562 <nbgl_layoutAddExtendedFooter+0x2d4>
c0de2304:	2903      	cmp	r1, #3
c0de2306:	f000 8223 	beq.w	c0de2750 <nbgl_layoutAddExtendedFooter+0x4c2>
c0de230a:	2904      	cmp	r1, #4
c0de230c:	f040 844e 	bne.w	c0de2bac <nbgl_layoutAddExtendedFooter+0x91e>
c0de2310:	2100      	movs	r1, #0
            layoutInt->footerContainer->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de2312:	71c1      	strb	r1, [r0, #7]
c0de2314:	2160      	movs	r1, #96	@ 0x60
c0de2316:	7181      	strb	r1, [r0, #6]
                layoutInt->footerContainer, &footerDesc->navigation, layoutInt->layer);
c0de2318:	f894 20ad 	ldrb.w	r2, [r4, #173]	@ 0xad
c0de231c:	f10a 0104 	add.w	r1, sl, #4
c0de2320:	08d2      	lsrs	r2, r2, #3
            layoutNavigationPopulate(
c0de2322:	f003 fa09 	bl	c0de5738 <layoutNavigationPopulate>
            layoutInt->footerContainer->nbChildren = 4;
c0de2326:	6920      	ldr	r0, [r4, #16]
c0de2328:	2104      	movs	r1, #4
c0de232a:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de232e:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de2332:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de2336:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de233a:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de233e:	2a0e      	cmp	r2, #14
c0de2340:	f200 8432 	bhi.w	c0de2ba8 <nbgl_layoutAddExtendedFooter+0x91a>
c0de2344:	0a0b      	lsrs	r3, r1, #8
        layout->nbUsedCallbackObjs++;
c0de2346:	3301      	adds	r3, #1
c0de2348:	f003 033f 	and.w	r3, r3, #63	@ 0x3f
c0de234c:	f401 4640 	and.w	r6, r1, #49152	@ 0xc000
                                       footerDesc->navigation.token,
c0de2350:	f89a 7004 	ldrb.w	r7, [sl, #4]
                                       footerDesc->navigation.tuneId);
c0de2354:	f89a c00c 	ldrb.w	ip, [sl, #12]
        layout->nbUsedCallbackObjs++;
c0de2358:	ea46 2303 	orr.w	r3, r6, r3, lsl #8
c0de235c:	0a1b      	lsrs	r3, r3, #8
c0de235e:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
        layoutObj->obj    = obj;
c0de2362:	eb04 01c2 	add.w	r1, r4, r2, lsl #3
        layout->nbUsedCallbackObjs++;
c0de2366:	f884 30ae 	strb.w	r3, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de236a:	6208      	str	r0, [r1, #32]
        layoutObj->token  = token;
c0de236c:	f881 7024 	strb.w	r7, [r1, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de2370:	f881 c026 	strb.w	ip, [r1, #38]	@ 0x26
            layoutInt->activePage = footerDesc->navigation.activePage;
c0de2374:	f89a 0006 	ldrb.w	r0, [sl, #6]
c0de2378:	f04f 0800 	mov.w	r8, #0
c0de237c:	f884 00a9 	strb.w	r0, [r4, #169]	@ 0xa9
            layoutInt->nbPages    = footerDesc->navigation.nbPages;
c0de2380:	f89a 0005 	ldrb.w	r0, [sl, #5]
c0de2384:	f884 00a8 	strb.w	r0, [r4, #168]	@ 0xa8
c0de2388:	f000 bc4d 	b.w	c0de2c26 <nbgl_layoutAddExtendedFooter+0x998>
    switch (footerDesc->type) {
c0de238c:	2900      	cmp	r1, #0
c0de238e:	f000 82eb 	beq.w	c0de2968 <nbgl_layoutAddExtendedFooter+0x6da>
c0de2392:	2901      	cmp	r1, #1
c0de2394:	f000 82f0 	beq.w	c0de2978 <nbgl_layoutAddExtendedFooter+0x6ea>
c0de2398:	2902      	cmp	r1, #2
c0de239a:	f040 8407 	bne.w	c0de2bac <nbgl_layoutAddExtendedFooter+0x91e>
            textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de239e:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de23a2:	08c1      	lsrs	r1, r0, #3
c0de23a4:	2004      	movs	r0, #4
c0de23a6:	f006 fbde 	bl	c0de8b66 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de23aa:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de23ae:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de23b2:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de23b6:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de23ba:	2a0e      	cmp	r2, #14
c0de23bc:	f200 83f4 	bhi.w	c0de2ba8 <nbgl_layoutAddExtendedFooter+0x91a>
c0de23c0:	4606      	mov	r6, r0
c0de23c2:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de23c4:	3001      	adds	r0, #1
c0de23c6:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de23ca:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de23ce:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
                                       footerDesc->doubleText.leftToken,
c0de23d2:	f89a c00c 	ldrb.w	ip, [sl, #12]
                                       footerDesc->doubleText.tuneId);
c0de23d6:	f89a 700e 	ldrb.w	r7, [sl, #14]
        layout->nbUsedCallbackObjs++;
c0de23da:	0a00      	lsrs	r0, r0, #8
c0de23dc:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de23e0:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de23e4:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de23e6:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de23ea:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
c0de23ee:	2007      	movs	r0, #7
        layout->nbUsedCallbackObjs++;
c0de23f0:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
            textArea->obj.alignment   = BOTTOM_LEFT;
c0de23f4:	72f0      	strb	r0, [r6, #11]
c0de23f6:	2500      	movs	r5, #0
c0de23f8:	f04f 08d0 	mov.w	r8, #208	@ 0xd0
c0de23fc:	2060      	movs	r0, #96	@ 0x60
            textArea->textColor       = BLACK;
c0de23fe:	7735      	strb	r5, [r6, #28]
            textArea->obj.area.width  = AVAILABLE_WIDTH / 2;
c0de2400:	7175      	strb	r5, [r6, #5]
c0de2402:	f886 8004 	strb.w	r8, [r6, #4]
            textArea->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de2406:	71f5      	strb	r5, [r6, #7]
c0de2408:	71b0      	strb	r0, [r6, #6]
            textArea->text            = PIC(footerDesc->doubleText.leftText);
c0de240a:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de240e:	f007 fad1 	bl	c0de99b4 <pic>
c0de2412:	4631      	mov	r1, r6
c0de2414:	f801 0f23 	strb.w	r0, [r1, #35]!
c0de2418:	0e02      	lsrs	r2, r0, #24
c0de241a:	70ca      	strb	r2, [r1, #3]
c0de241c:	0c02      	lsrs	r2, r0, #16
c0de241e:	0a00      	lsrs	r0, r0, #8
c0de2420:	f04f 0b01 	mov.w	fp, #1
c0de2424:	708a      	strb	r2, [r1, #2]
c0de2426:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
c0de242a:	200c      	movs	r0, #12
            textArea->obj.touchMask   = (1 << TOUCHED);
c0de242c:	f886 b018 	strb.w	fp, [r6, #24]
            textArea->fontId          = SMALL_BOLD_FONT;
c0de2430:	77f0      	strb	r0, [r6, #31]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2432:	6920      	ldr	r0, [r4, #16]
c0de2434:	2205      	movs	r2, #5
c0de2436:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
            textArea->textAlignment   = CENTER;
c0de243a:	7772      	strb	r2, [r6, #29]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de243c:	7842      	ldrb	r2, [r0, #1]
c0de243e:	7883      	ldrb	r3, [r0, #2]
c0de2440:	78c7      	ldrb	r7, [r0, #3]
c0de2442:	7940      	ldrb	r0, [r0, #5]
c0de2444:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de2448:	ea43 2207 	orr.w	r2, r3, r7, lsl #8
c0de244c:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
                = (nbgl_obj_t *) textArea;
c0de2450:	f841 6020 	str.w	r6, [r1, r0, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de2454:	6920      	ldr	r0, [r4, #16]
            textArea->obj.touchMask   = (1 << TOUCHED);
c0de2456:	7675      	strb	r5, [r6, #25]
            layoutInt->footerContainer->nbChildren++;
c0de2458:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
            textArea->obj.touchId     = BOTTOM_BUTTON_ID;
c0de245c:	f886 b01a 	strb.w	fp, [r6, #26]
            layoutInt->footerContainer->nbChildren++;
c0de2460:	3101      	adds	r1, #1
c0de2462:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
            textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de2466:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de246a:	08c1      	lsrs	r1, r0, #3
c0de246c:	2004      	movs	r0, #4
c0de246e:	f006 fb7a 	bl	c0de8b66 <nbgl_objPoolGet>
                                       footerDesc->doubleText.rightToken,
c0de2472:	f89a 200d 	ldrb.w	r2, [sl, #13]
                                       footerDesc->doubleText.tuneId);
c0de2476:	f89a 300e 	ldrb.w	r3, [sl, #14]
            textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de247a:	4606      	mov	r6, r0
            obj      = layoutAddCallbackObj(layoutInt,
c0de247c:	4620      	mov	r0, r4
c0de247e:	4631      	mov	r1, r6
c0de2480:	f7fe feb7 	bl	c0de11f2 <layoutAddCallbackObj>
            if (obj == NULL) {
c0de2484:	2800      	cmp	r0, #0
c0de2486:	f04f 37ff 	mov.w	r7, #4294967295	@ 0xffffffff
c0de248a:	f000 838f 	beq.w	c0de2bac <nbgl_layoutAddExtendedFooter+0x91e>
c0de248e:	2009      	movs	r0, #9
            textArea->obj.alignment   = BOTTOM_RIGHT;
c0de2490:	72f0      	strb	r0, [r6, #11]
            textArea->obj.area.width  = AVAILABLE_WIDTH / 2;
c0de2492:	f886 8004 	strb.w	r8, [r6, #4]
            textArea->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de2496:	46b0      	mov	r8, r6
c0de2498:	2060      	movs	r0, #96	@ 0x60
c0de249a:	f808 0f06 	strb.w	r0, [r8, #6]!
            textArea->textColor       = BLACK;
c0de249e:	7735      	strb	r5, [r6, #28]
            textArea->obj.area.width  = AVAILABLE_WIDTH / 2;
c0de24a0:	7175      	strb	r5, [r6, #5]
            textArea->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de24a2:	f888 5001 	strb.w	r5, [r8, #1]
            textArea->text            = PIC(footerDesc->doubleText.rightText);
c0de24a6:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de24aa:	f007 fa83 	bl	c0de99b4 <pic>
c0de24ae:	4631      	mov	r1, r6
c0de24b0:	f801 0f23 	strb.w	r0, [r1, #35]!
c0de24b4:	0e02      	lsrs	r2, r0, #24
c0de24b6:	70ca      	strb	r2, [r1, #3]
c0de24b8:	0c02      	lsrs	r2, r0, #16
c0de24ba:	0a00      	lsrs	r0, r0, #8
c0de24bc:	708a      	strb	r2, [r1, #2]
c0de24be:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
            textArea->fontId          = SMALL_BOLD_FONT;
c0de24c2:	200c      	movs	r0, #12
            textArea->obj.touchMask   = (1 << TOUCHED);
c0de24c4:	f886 b018 	strb.w	fp, [r6, #24]
            textArea->fontId          = SMALL_BOLD_FONT;
c0de24c8:	77f0      	strb	r0, [r6, #31]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de24ca:	6920      	ldr	r0, [r4, #16]
            textArea->textAlignment   = CENTER;
c0de24cc:	2105      	movs	r1, #5
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de24ce:	f810 cf1c 	ldrb.w	ip, [r0, #28]!
            textArea->textAlignment   = CENTER;
c0de24d2:	7771      	strb	r1, [r6, #29]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de24d4:	7842      	ldrb	r2, [r0, #1]
c0de24d6:	7883      	ldrb	r3, [r0, #2]
c0de24d8:	78c1      	ldrb	r1, [r0, #3]
c0de24da:	7940      	ldrb	r0, [r0, #5]
c0de24dc:	ea4c 2202 	orr.w	r2, ip, r2, lsl #8
c0de24e0:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de24e4:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
                = (nbgl_obj_t *) textArea;
c0de24e8:	f841 6020 	str.w	r6, [r1, r0, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de24ec:	6920      	ldr	r0, [r4, #16]
c0de24ee:	2103      	movs	r1, #3
c0de24f0:	f890 2021 	ldrb.w	r2, [r0, #33]	@ 0x21
            textArea->obj.touchId     = RIGHT_BUTTON_ID;
c0de24f4:	76b1      	strb	r1, [r6, #26]
            layoutInt->footerContainer->nbChildren++;
c0de24f6:	1c51      	adds	r1, r2, #1
c0de24f8:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
            layoutInt->footerContainer->obj.area.height = textArea->obj.area.height;
c0de24fc:	f898 1001 	ldrb.w	r1, [r8, #1]
c0de2500:	f898 2000 	ldrb.w	r2, [r8]
            textArea->obj.touchMask   = (1 << TOUCHED);
c0de2504:	7675      	strb	r5, [r6, #25]
            layoutInt->footerContainer->obj.area.height = textArea->obj.area.height;
c0de2506:	71c1      	strb	r1, [r0, #7]
c0de2508:	7182      	strb	r2, [r0, #6]
            separationLine            = (nbgl_line_t *) nbgl_objPoolGet(LINE, layoutInt->layer);
c0de250a:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de250e:	08c1      	lsrs	r1, r0, #3
c0de2510:	2003      	movs	r0, #3
c0de2512:	f006 fb28 	bl	c0de8b66 <nbgl_objPoolGet>
c0de2516:	4680      	mov	r8, r0
c0de2518:	2002      	movs	r0, #2
            separationLine->obj.area.width       = 1;
c0de251a:	f888 b004 	strb.w	fp, [r8, #4]
            separationLine->lineColor = LIGHT_GRAY;
c0de251e:	f888 001d 	strb.w	r0, [r8, #29]
            separationLine->obj.area.height      = layoutInt->footerContainer->obj.area.height;
c0de2522:	6920      	ldr	r0, [r4, #16]
            separationLine->obj.area.width       = 1;
c0de2524:	f888 5005 	strb.w	r5, [r8, #5]
            separationLine->obj.area.height      = layoutInt->footerContainer->obj.area.height;
c0de2528:	79c1      	ldrb	r1, [r0, #7]
c0de252a:	7980      	ldrb	r0, [r0, #6]
c0de252c:	f888 1007 	strb.w	r1, [r8, #7]
c0de2530:	f888 0006 	strb.w	r0, [r8, #6]
            separationLine->obj.alignment        = MID_LEFT;
c0de2534:	2004      	movs	r0, #4
c0de2536:	f888 000b 	strb.w	r0, [r8, #11]
            separationLine->obj.alignTo          = (nbgl_obj_t *) textArea;
c0de253a:	0a30      	lsrs	r0, r6, #8
c0de253c:	f888 0011 	strb.w	r0, [r8, #17]
c0de2540:	4640      	mov	r0, r8
c0de2542:	f800 6f10 	strb.w	r6, [r0, #16]!
c0de2546:	0e31      	lsrs	r1, r6, #24
c0de2548:	70c1      	strb	r1, [r0, #3]
c0de254a:	0c31      	lsrs	r1, r6, #16
c0de254c:	7081      	strb	r1, [r0, #2]
c0de254e:	20ff      	movs	r0, #255	@ 0xff
            separationLine->direction            = VERTICAL;
c0de2550:	f888 501c 	strb.w	r5, [r8, #28]
            separationLine->thickness            = 1;
c0de2554:	f888 b01e 	strb.w	fp, [r8, #30]
            separationLine->obj.alignmentMarginX = -1;
c0de2558:	f888 0015 	strb.w	r0, [r8, #21]
c0de255c:	f888 7014 	strb.w	r7, [r8, #20]
c0de2560:	e361      	b.n	c0de2c26 <nbgl_layoutAddExtendedFooter+0x998>
    switch (footerDesc->type) {
c0de2562:	2905      	cmp	r1, #5
c0de2564:	f000 8278 	beq.w	c0de2a58 <nbgl_layoutAddExtendedFooter+0x7ca>
c0de2568:	2906      	cmp	r1, #6
c0de256a:	f040 831f 	bne.w	c0de2bac <nbgl_layoutAddExtendedFooter+0x91e>
            if ((footerDesc->choiceButtons.bottomText == NULL)
c0de256e:	f8da 0008 	ldr.w	r0, [sl, #8]
                || (footerDesc->choiceButtons.topText == NULL)) {
c0de2572:	2800      	cmp	r0, #0
c0de2574:	f000 8318 	beq.w	c0de2ba8 <nbgl_layoutAddExtendedFooter+0x91a>
c0de2578:	f8da 0004 	ldr.w	r0, [sl, #4]
            if ((footerDesc->choiceButtons.bottomText == NULL)
c0de257c:	2800      	cmp	r0, #0
c0de257e:	f000 8313 	beq.w	c0de2ba8 <nbgl_layoutAddExtendedFooter+0x91a>
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de2582:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2586:	08c1      	lsrs	r1, r0, #3
c0de2588:	2005      	movs	r0, #5
c0de258a:	f006 faec 	bl	c0de8b66 <nbgl_objPoolGet>
                                       footerDesc->choiceButtons.token,
c0de258e:	f89a 2010 	ldrb.w	r2, [sl, #16]
                                       footerDesc->choiceButtons.tuneId);
c0de2592:	f89a 3012 	ldrb.w	r3, [sl, #18]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de2596:	4606      	mov	r6, r0
            obj    = layoutAddCallbackObj(layoutInt,
c0de2598:	4620      	mov	r0, r4
c0de259a:	4631      	mov	r1, r6
c0de259c:	f7fe fe29 	bl	c0de11f2 <layoutAddCallbackObj>
            if (obj == NULL) {
c0de25a0:	2800      	cmp	r0, #0
c0de25a2:	f000 8301 	beq.w	c0de2ba8 <nbgl_layoutAddExtendedFooter+0x91a>
c0de25a6:	f04f 0801 	mov.w	r8, #1
            obj->index = 1;
c0de25aa:	f880 8005 	strb.w	r8, [r0, #5]
c0de25ae:	2008      	movs	r0, #8
            button->obj.alignment = BOTTOM_MIDDLE;
c0de25b0:	72f0      	strb	r0, [r6, #11]
c0de25b2:	2003      	movs	r0, #3
            button->innerColor    = WHITE;
c0de25b4:	f886 0028 	strb.w	r0, [r6, #40]	@ 0x28
            if (footerDesc->choiceButtons.style == BOTH_ROUNDED_STYLE) {
c0de25b8:	f89a 1011 	ldrb.w	r1, [sl, #17]
c0de25bc:	2204      	movs	r2, #4
c0de25be:	2903      	cmp	r1, #3
c0de25c0:	f04f 0104 	mov.w	r1, #4
c0de25c4:	bf04      	itt	eq
c0de25c6:	2118      	moveq	r1, #24
c0de25c8:	2002      	moveq	r0, #2
c0de25ca:	f886 0029 	strb.w	r0, [r6, #41]	@ 0x29
c0de25ce:	2058      	movs	r0, #88	@ 0x58
c0de25d0:	2700      	movs	r7, #0
c0de25d2:	71b0      	strb	r0, [r6, #6]
c0de25d4:	20a0      	movs	r0, #160	@ 0xa0
c0de25d6:	75f7      	strb	r7, [r6, #23]
c0de25d8:	75b1      	strb	r1, [r6, #22]
c0de25da:	71f7      	strb	r7, [r6, #7]
            button->foregroundColor = BLACK;
c0de25dc:	f886 702a 	strb.w	r7, [r6, #42]	@ 0x2a
            button->obj.area.width  = AVAILABLE_WIDTH;
c0de25e0:	f886 8005 	strb.w	r8, [r6, #5]
c0de25e4:	7130      	strb	r0, [r6, #4]
            button->radius          = BUTTON_RADIUS;
c0de25e6:	f886 202b 	strb.w	r2, [r6, #43]	@ 0x2b
            button->text            = PIC(footerDesc->choiceButtons.bottomText);
c0de25ea:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de25ee:	f007 f9e1 	bl	c0de99b4 <pic>
c0de25f2:	4631      	mov	r1, r6
c0de25f4:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de25f8:	0e02      	lsrs	r2, r0, #24
c0de25fa:	70ca      	strb	r2, [r1, #3]
c0de25fc:	0c02      	lsrs	r2, r0, #16
c0de25fe:	0a00      	lsrs	r0, r0, #8
c0de2600:	708a      	strb	r2, [r1, #2]
c0de2602:	7770      	strb	r0, [r6, #29]
            button->obj.touchMask   = (1 << TOUCHED);
c0de2604:	f886 8018 	strb.w	r8, [r6, #24]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2608:	6921      	ldr	r1, [r4, #16]
c0de260a:	200c      	movs	r0, #12
            button->fontId          = SMALL_BOLD_FONT;
c0de260c:	f886 002c 	strb.w	r0, [r6, #44]	@ 0x2c
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2610:	f811 0f1c 	ldrb.w	r0, [r1, #28]!
            button->obj.touchMask   = (1 << TOUCHED);
c0de2614:	7677      	strb	r7, [r6, #25]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2616:	784a      	ldrb	r2, [r1, #1]
c0de2618:	788b      	ldrb	r3, [r1, #2]
c0de261a:	78cf      	ldrb	r7, [r1, #3]
c0de261c:	7949      	ldrb	r1, [r1, #5]
c0de261e:	ea40 2002 	orr.w	r0, r0, r2, lsl #8
c0de2622:	ea43 2207 	orr.w	r2, r3, r7, lsl #8
c0de2626:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
                = (nbgl_obj_t *) button;
c0de262a:	f840 6021 	str.w	r6, [r0, r1, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de262e:	6920      	ldr	r0, [r4, #16]
c0de2630:	210a      	movs	r1, #10
c0de2632:	f890 2021 	ldrb.w	r2, [r0, #33]	@ 0x21
            button->obj.touchId     = CHOICE_2_ID;
c0de2636:	76b1      	strb	r1, [r6, #26]
            layoutInt->footerContainer->nbChildren++;
c0de2638:	1c51      	adds	r1, r2, #1
c0de263a:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
            if ((footerDesc->choiceButtons.style != ROUNDED_AND_FOOTER_STYLE)
c0de263e:	f89a 0011 	ldrb.w	r0, [sl, #17]
                && (footerDesc->choiceButtons.style != BOTH_ROUNDED_STYLE)) {
c0de2642:	b3b0      	cbz	r0, c0de26b2 <nbgl_layoutAddExtendedFooter+0x424>
c0de2644:	2803      	cmp	r0, #3
c0de2646:	d034      	beq.n	c0de26b2 <nbgl_layoutAddExtendedFooter+0x424>
                line                = createHorizontalLine(layoutInt->layer);
c0de2648:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de264c:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de264e:	2003      	movs	r0, #3
c0de2650:	f006 fa89 	bl	c0de8b66 <nbgl_objPoolGet>
c0de2654:	22e0      	movs	r2, #224	@ 0xe0
    line->obj.area.width  = SCREEN_WIDTH;
c0de2656:	7102      	strb	r2, [r0, #4]
c0de2658:	2200      	movs	r2, #0
    line->obj.area.height = 1;
c0de265a:	71c2      	strb	r2, [r0, #7]
                line->obj.alignTo   = (nbgl_obj_t *) button;
c0de265c:	0a32      	lsrs	r2, r6, #8
c0de265e:	7442      	strb	r2, [r0, #17]
c0de2660:	4602      	mov	r2, r0
c0de2662:	f04f 0c01 	mov.w	ip, #1
c0de2666:	f802 6f10 	strb.w	r6, [r2, #16]!
c0de266a:	0c33      	lsrs	r3, r6, #16
    line->obj.area.height = 1;
c0de266c:	f880 c006 	strb.w	ip, [r0, #6]
                line->obj.alignTo   = (nbgl_obj_t *) button;
c0de2670:	7093      	strb	r3, [r2, #2]
                layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2672:	6923      	ldr	r3, [r4, #16]
                line->obj.alignTo   = (nbgl_obj_t *) button;
c0de2674:	0e37      	lsrs	r7, r6, #24
                layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2676:	f813 6f1c 	ldrb.w	r6, [r3, #28]!
                line->obj.alignTo   = (nbgl_obj_t *) button;
c0de267a:	70d7      	strb	r7, [r2, #3]
                layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de267c:	785a      	ldrb	r2, [r3, #1]
c0de267e:	789f      	ldrb	r7, [r3, #2]
c0de2680:	78d9      	ldrb	r1, [r3, #3]
c0de2682:	ea46 2202 	orr.w	r2, r6, r2, lsl #8
c0de2686:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de268a:	795b      	ldrb	r3, [r3, #5]
c0de268c:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
                    = (nbgl_obj_t *) line;
c0de2690:	f841 0023 	str.w	r0, [r1, r3, lsl #2]
                layoutInt->footerContainer->nbChildren++;
c0de2694:	6921      	ldr	r1, [r4, #16]
c0de2696:	2702      	movs	r7, #2
c0de2698:	f891 2021 	ldrb.w	r2, [r1, #33]	@ 0x21
    line->lineColor       = LIGHT_GRAY;
c0de269c:	7747      	strb	r7, [r0, #29]
    line->obj.area.width  = SCREEN_WIDTH;
c0de269e:	f880 c005 	strb.w	ip, [r0, #5]
    line->direction       = HORIZONTAL;
c0de26a2:	f880 c01c 	strb.w	ip, [r0, #28]
    line->thickness       = 1;
c0de26a6:	f880 c01e 	strb.w	ip, [r0, #30]
                line->obj.alignment = TOP_MIDDLE;
c0de26aa:	72c7      	strb	r7, [r0, #11]
                layoutInt->footerContainer->nbChildren++;
c0de26ac:	1c50      	adds	r0, r2, #1
c0de26ae:	f881 0021 	strb.w	r0, [r1, #33]	@ 0x21
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de26b2:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de26b6:	08c1      	lsrs	r1, r0, #3
c0de26b8:	2005      	movs	r0, #5
c0de26ba:	f006 fa54 	bl	c0de8b66 <nbgl_objPoolGet>
                                       footerDesc->choiceButtons.token,
c0de26be:	f89a 2010 	ldrb.w	r2, [sl, #16]
                                       footerDesc->choiceButtons.tuneId);
c0de26c2:	f89a 3012 	ldrb.w	r3, [sl, #18]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de26c6:	4606      	mov	r6, r0
            obj    = layoutAddCallbackObj(layoutInt,
c0de26c8:	4620      	mov	r0, r4
c0de26ca:	4631      	mov	r1, r6
c0de26cc:	f7fe fd91 	bl	c0de11f2 <layoutAddCallbackObj>
            if (obj == NULL) {
c0de26d0:	2800      	cmp	r0, #0
c0de26d2:	f000 8269 	beq.w	c0de2ba8 <nbgl_layoutAddExtendedFooter+0x91a>
c0de26d6:	2700      	movs	r7, #0
            obj->index            = 0;
c0de26d8:	7147      	strb	r7, [r0, #5]
c0de26da:	2002      	movs	r0, #2
            button->obj.alignment = TOP_MIDDLE;
c0de26dc:	72f0      	strb	r0, [r6, #11]
c0de26de:	2018      	movs	r0, #24
c0de26e0:	75f7      	strb	r7, [r6, #23]
c0de26e2:	75b0      	strb	r0, [r6, #22]
            if (footerDesc->choiceButtons.style == SOFT_ACTION_AND_FOOTER_STYLE) {
c0de26e4:	f89a 0011 	ldrb.w	r0, [sl, #17]
c0de26e8:	2200      	movs	r2, #0
c0de26ea:	1e81      	subs	r1, r0, #2
c0de26ec:	bf08      	it	eq
c0de26ee:	2203      	moveq	r2, #3
c0de26f0:	3802      	subs	r0, #2
c0de26f2:	bf18      	it	ne
c0de26f4:	2003      	movne	r0, #3
c0de26f6:	fab1 f181 	clz	r1, r1
c0de26fa:	f886 002a 	strb.w	r0, [r6, #42]	@ 0x2a
c0de26fe:	20a0      	movs	r0, #160	@ 0xa0
c0de2700:	0949      	lsrs	r1, r1, #5
            button->obj.area.width  = AVAILABLE_WIDTH;
c0de2702:	7130      	strb	r0, [r6, #4]
c0de2704:	2058      	movs	r0, #88	@ 0x58
            if (footerDesc->choiceButtons.style == SOFT_ACTION_AND_FOOTER_STYLE) {
c0de2706:	0049      	lsls	r1, r1, #1
c0de2708:	f04f 0801 	mov.w	r8, #1
            button->obj.area.height = BUTTON_DIAMETER;
c0de270c:	71b0      	strb	r0, [r6, #6]
c0de270e:	2004      	movs	r0, #4
c0de2710:	f886 2028 	strb.w	r2, [r6, #40]	@ 0x28
c0de2714:	f886 1029 	strb.w	r1, [r6, #41]	@ 0x29
            button->obj.area.width  = AVAILABLE_WIDTH;
c0de2718:	f886 8005 	strb.w	r8, [r6, #5]
            button->obj.area.height = BUTTON_DIAMETER;
c0de271c:	71f7      	strb	r7, [r6, #7]
            button->radius          = BUTTON_RADIUS;
c0de271e:	f886 002b 	strb.w	r0, [r6, #43]	@ 0x2b
            button->text            = PIC(footerDesc->choiceButtons.topText);
c0de2722:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de2726:	f007 f945 	bl	c0de99b4 <pic>
c0de272a:	4631      	mov	r1, r6
c0de272c:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de2730:	0e02      	lsrs	r2, r0, #24
c0de2732:	70ca      	strb	r2, [r1, #3]
c0de2734:	0c02      	lsrs	r2, r0, #16
c0de2736:	0a00      	lsrs	r0, r0, #8
c0de2738:	708a      	strb	r2, [r1, #2]
c0de273a:	7048      	strb	r0, [r1, #1]
            button->icon            = (footerDesc->choiceButtons.style != ROUNDED_AND_FOOTER_STYLE)
c0de273c:	f89a 0011 	ldrb.w	r0, [sl, #17]
c0de2740:	2800      	cmp	r0, #0
c0de2742:	f000 8237 	beq.w	c0de2bb4 <nbgl_layoutAddExtendedFooter+0x926>
                                          ? PIC(footerDesc->choiceButtons.topIcon)
c0de2746:	f8da 000c 	ldr.w	r0, [sl, #12]
c0de274a:	f007 f933 	bl	c0de99b4 <pic>
c0de274e:	e232      	b.n	c0de2bb6 <nbgl_layoutAddExtendedFooter+0x928>
c0de2750:	f04f 0800 	mov.w	r8, #0
c0de2754:	f04f 0b60 	mov.w	fp, #96	@ 0x60
            layoutInt->footerContainer->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de2758:	f880 8007 	strb.w	r8, [r0, #7]
c0de275c:	f880 b006 	strb.w	fp, [r0, #6]
            textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de2760:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2764:	08c1      	lsrs	r1, r0, #3
c0de2766:	2004      	movs	r0, #4
c0de2768:	f006 f9fd 	bl	c0de8b66 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de276c:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de2770:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de2774:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de2778:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de277c:	2a0e      	cmp	r2, #14
c0de277e:	f200 8213 	bhi.w	c0de2ba8 <nbgl_layoutAddExtendedFooter+0x91a>
c0de2782:	4607      	mov	r7, r0
c0de2784:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de2786:	3001      	adds	r0, #1
c0de2788:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de278c:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de2790:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
                                       footerDesc->textAndNav.token,
c0de2794:	f89a c014 	ldrb.w	ip, [sl, #20]
                                       footerDesc->textAndNav.tuneId);
c0de2798:	f89a 6015 	ldrb.w	r6, [sl, #21]
        layout->nbUsedCallbackObjs++;
c0de279c:	0a00      	lsrs	r0, r0, #8
c0de279e:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de27a2:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de27a6:	6207      	str	r7, [r0, #32]
        layoutObj->token  = token;
c0de27a8:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de27ac:	f880 6026 	strb.w	r6, [r0, #38]	@ 0x26
c0de27b0:	2007      	movs	r0, #7
        layout->nbUsedCallbackObjs++;
c0de27b2:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
            textArea->obj.alignment   = BOTTOM_LEFT;
c0de27b6:	72f8      	strb	r0, [r7, #11]
c0de27b8:	20c0      	movs	r0, #192	@ 0xc0
            textArea->obj.area.width  = FOOTER_TEXT_AND_NAV_WIDTH;
c0de27ba:	463d      	mov	r5, r7
c0de27bc:	f805 0f04 	strb.w	r0, [r5, #4]!
            textArea->textColor       = BLACK;
c0de27c0:	f887 801c 	strb.w	r8, [r7, #28]
            textArea->obj.area.width  = FOOTER_TEXT_AND_NAV_WIDTH;
c0de27c4:	f885 8001 	strb.w	r8, [r5, #1]
            textArea->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de27c8:	f887 8007 	strb.w	r8, [r7, #7]
c0de27cc:	f887 b006 	strb.w	fp, [r7, #6]
            textArea->text            = PIC(footerDesc->textAndNav.text);
c0de27d0:	f8da 0010 	ldr.w	r0, [sl, #16]
c0de27d4:	f10a 0104 	add.w	r1, sl, #4
c0de27d8:	9101      	str	r1, [sp, #4]
c0de27da:	f007 f8eb 	bl	c0de99b4 <pic>
c0de27de:	4639      	mov	r1, r7
c0de27e0:	f801 0f23 	strb.w	r0, [r1, #35]!
c0de27e4:	0e02      	lsrs	r2, r0, #24
c0de27e6:	70ca      	strb	r2, [r1, #3]
c0de27e8:	0c02      	lsrs	r2, r0, #16
c0de27ea:	0a00      	lsrs	r0, r0, #8
c0de27ec:	f887 0024 	strb.w	r0, [r7, #36]	@ 0x24
c0de27f0:	200c      	movs	r0, #12
            textArea->fontId          = SMALL_BOLD_FONT;
c0de27f2:	77f8      	strb	r0, [r7, #31]
c0de27f4:	2001      	movs	r0, #1
            textArea->text            = PIC(footerDesc->textAndNav.text);
c0de27f6:	708a      	strb	r2, [r1, #2]
            textArea->obj.touchMask   = (1 << TOUCHED);
c0de27f8:	7638      	strb	r0, [r7, #24]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de27fa:	6920      	ldr	r0, [r4, #16]
c0de27fc:	2105      	movs	r1, #5
c0de27fe:	f810 2f1c 	ldrb.w	r2, [r0, #28]!
            textArea->textAlignment   = CENTER;
c0de2802:	7779      	strb	r1, [r7, #29]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2804:	7841      	ldrb	r1, [r0, #1]
c0de2806:	7883      	ldrb	r3, [r0, #2]
c0de2808:	78c6      	ldrb	r6, [r0, #3]
c0de280a:	7940      	ldrb	r0, [r0, #5]
c0de280c:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de2810:	ea43 2206 	orr.w	r2, r3, r6, lsl #8
c0de2814:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
                = (nbgl_obj_t *) textArea;
c0de2818:	f841 7020 	str.w	r7, [r1, r0, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de281c:	6920      	ldr	r0, [r4, #16]
c0de281e:	f04f 0c01 	mov.w	ip, #1
c0de2822:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
            textArea->obj.touchMask   = (1 << TOUCHED);
c0de2826:	f887 8019 	strb.w	r8, [r7, #25]
            layoutInt->footerContainer->nbChildren++;
c0de282a:	3101      	adds	r1, #1
            textArea->obj.touchId     = BOTTOM_BUTTON_ID;
c0de282c:	f887 c01a 	strb.w	ip, [r7, #26]
            layoutInt->footerContainer->nbChildren++;
c0de2830:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
                = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de2834:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2838:	2601      	movs	r6, #1
c0de283a:	08c1      	lsrs	r1, r0, #3
c0de283c:	2001      	movs	r0, #1
c0de283e:	f006 f992 	bl	c0de8b66 <nbgl_objPoolGet>
c0de2842:	4683      	mov	fp, r0
c0de2844:	20a0      	movs	r0, #160	@ 0xa0
            navContainer->obj.area.width = AVAILABLE_WIDTH;
c0de2846:	465f      	mov	r7, fp
c0de2848:	f807 0f04 	strb.w	r0, [r7, #4]!
            navContainer->nbChildren     = 4;
c0de284c:	2004      	movs	r0, #4
            navContainer->obj.area.width = AVAILABLE_WIDTH;
c0de284e:	707e      	strb	r6, [r7, #1]
            navContainer->layout         = VERTICAL;
c0de2850:	f88b 8020 	strb.w	r8, [fp, #32]
            navContainer->nbChildren     = 4;
c0de2854:	f88b 0021 	strb.w	r0, [fp, #33]	@ 0x21
                = (nbgl_obj_t **) nbgl_containerPoolGet(navContainer->nbChildren, layoutInt->layer);
c0de2858:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de285c:	08c1      	lsrs	r1, r0, #3
c0de285e:	2004      	movs	r0, #4
c0de2860:	f006 f986 	bl	c0de8b70 <nbgl_containerPoolGet>
c0de2864:	4659      	mov	r1, fp
c0de2866:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de286a:	0e02      	lsrs	r2, r0, #24
c0de286c:	70ca      	strb	r2, [r1, #3]
c0de286e:	0c02      	lsrs	r2, r0, #16
c0de2870:	0a00      	lsrs	r0, r0, #8
c0de2872:	708a      	strb	r2, [r1, #2]
c0de2874:	f88b 001d 	strb.w	r0, [fp, #29]
            navContainer->obj.area.width  = SCREEN_WIDTH - textArea->obj.area.width;
c0de2878:	7829      	ldrb	r1, [r5, #0]
c0de287a:	786a      	ldrb	r2, [r5, #1]
c0de287c:	2009      	movs	r0, #9
            navContainer->obj.alignment   = BOTTOM_RIGHT;
c0de287e:	f88b 000b 	strb.w	r0, [fp, #11]
            navContainer->obj.area.width  = SCREEN_WIDTH - textArea->obj.area.width;
c0de2882:	ea41 2002 	orr.w	r0, r1, r2, lsl #8
c0de2886:	f5c0 70f0 	rsb	r0, r0, #480	@ 0x1e0
c0de288a:	7038      	strb	r0, [r7, #0]
c0de288c:	0a00      	lsrs	r0, r0, #8
c0de288e:	7078      	strb	r0, [r7, #1]
            navContainer->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de2890:	2060      	movs	r0, #96	@ 0x60
c0de2892:	f88b 8007 	strb.w	r8, [fp, #7]
c0de2896:	f88b 0006 	strb.w	r0, [fp, #6]
            layoutNavigationPopulate(navContainer, &footerDesc->navigation, layoutInt->layer);
c0de289a:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de289e:	9901      	ldr	r1, [sp, #4]
c0de28a0:	08c2      	lsrs	r2, r0, #3
c0de28a2:	4658      	mov	r0, fp
c0de28a4:	f002 ff48 	bl	c0de5738 <layoutNavigationPopulate>
                                       footerDesc->textAndNav.navigation.token,
c0de28a8:	f89a 2004 	ldrb.w	r2, [sl, #4]
                                       footerDesc->textAndNav.navigation.tuneId);
c0de28ac:	f89a 300c 	ldrb.w	r3, [sl, #12]
            obj = layoutAddCallbackObj(layoutInt,
c0de28b0:	4620      	mov	r0, r4
c0de28b2:	4659      	mov	r1, fp
c0de28b4:	f7fe fc9d 	bl	c0de11f2 <layoutAddCallbackObj>
c0de28b8:	4606      	mov	r6, r0
            if (obj == NULL) {
c0de28ba:	2800      	cmp	r0, #0
c0de28bc:	d050      	beq.n	c0de2960 <nbgl_layoutAddExtendedFooter+0x6d2>
            separationLine            = (nbgl_line_t *) nbgl_objPoolGet(LINE, layoutInt->layer);
c0de28be:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de28c2:	08c1      	lsrs	r1, r0, #3
c0de28c4:	2003      	movs	r0, #3
c0de28c6:	f006 f94e 	bl	c0de8b66 <nbgl_objPoolGet>
c0de28ca:	4680      	mov	r8, r0
c0de28cc:	2501      	movs	r5, #1
c0de28ce:	2002      	movs	r0, #2
            separationLine->obj.area.width       = 1;
c0de28d0:	f888 5004 	strb.w	r5, [r8, #4]
            separationLine->lineColor = LIGHT_GRAY;
c0de28d4:	f888 001d 	strb.w	r0, [r8, #29]
            separationLine->obj.area.height      = layoutInt->footerContainer->obj.area.height;
c0de28d8:	6920      	ldr	r0, [r4, #16]
c0de28da:	2200      	movs	r2, #0
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de28dc:	f810 cf1c 	ldrb.w	ip, [r0, #28]!
            separationLine->obj.area.width       = 1;
c0de28e0:	f888 2005 	strb.w	r2, [r8, #5]
            separationLine->direction            = VERTICAL;
c0de28e4:	f888 201c 	strb.w	r2, [r8, #28]
c0de28e8:	2204      	movs	r2, #4
            separationLine->obj.area.height      = layoutInt->footerContainer->obj.area.height;
c0de28ea:	f810 3c16 	ldrb.w	r3, [r0, #-22]
            separationLine->obj.alignment        = MID_LEFT;
c0de28ee:	f888 200b 	strb.w	r2, [r8, #11]
            separationLine->obj.alignTo          = (nbgl_obj_t *) navContainer;
c0de28f2:	ea4f 221b 	mov.w	r2, fp, lsr #8
            separationLine->obj.area.height      = layoutInt->footerContainer->obj.area.height;
c0de28f6:	f810 7c15 	ldrb.w	r7, [r0, #-21]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de28fa:	f890 e001 	ldrb.w	lr, [r0, #1]
c0de28fe:	7881      	ldrb	r1, [r0, #2]
            separationLine->obj.alignTo          = (nbgl_obj_t *) navContainer;
c0de2900:	f888 2011 	strb.w	r2, [r8, #17]
c0de2904:	4642      	mov	r2, r8
            separationLine->obj.area.height      = layoutInt->footerContainer->obj.area.height;
c0de2906:	f888 3006 	strb.w	r3, [r8, #6]
            separationLine->obj.alignTo          = (nbgl_obj_t *) navContainer;
c0de290a:	f802 bf10 	strb.w	fp, [r2, #16]!
c0de290e:	ea4f 631b 	mov.w	r3, fp, lsr #24
c0de2912:	70d3      	strb	r3, [r2, #3]
c0de2914:	ea4f 431b 	mov.w	r3, fp, lsr #16
c0de2918:	7093      	strb	r3, [r2, #2]
c0de291a:	22ff      	movs	r2, #255	@ 0xff
            separationLine->obj.alignmentMarginX = -1;
c0de291c:	f888 2015 	strb.w	r2, [r8, #21]
c0de2920:	f04f 32ff 	mov.w	r2, #4294967295	@ 0xffffffff
            separationLine->obj.area.height      = layoutInt->footerContainer->obj.area.height;
c0de2924:	f888 7007 	strb.w	r7, [r8, #7]
            separationLine->thickness            = 1;
c0de2928:	f888 501e 	strb.w	r5, [r8, #30]
            separationLine->obj.alignmentMarginX = -1;
c0de292c:	f888 2014 	strb.w	r2, [r8, #20]
            layoutInt->activePage = footerDesc->textAndNav.navigation.activePage;
c0de2930:	f89a 2006 	ldrb.w	r2, [sl, #6]
c0de2934:	f884 20a9 	strb.w	r2, [r4, #169]	@ 0xa9
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2938:	78c2      	ldrb	r2, [r0, #3]
c0de293a:	7940      	ldrb	r0, [r0, #5]
c0de293c:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de2940:	ea4c 220e 	orr.w	r2, ip, lr, lsl #8
c0de2944:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
            layoutInt->nbPages    = footerDesc->textAndNav.navigation.nbPages;
c0de2948:	f89a 3005 	ldrb.w	r3, [sl, #5]
                = (nbgl_obj_t *) navContainer;
c0de294c:	f841 b020 	str.w	fp, [r1, r0, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de2950:	6920      	ldr	r0, [r4, #16]
            layoutInt->nbPages    = footerDesc->textAndNav.navigation.nbPages;
c0de2952:	f884 30a8 	strb.w	r3, [r4, #168]	@ 0xa8
            layoutInt->footerContainer->nbChildren++;
c0de2956:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
c0de295a:	3101      	adds	r1, #1
c0de295c:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
c0de2960:	2e00      	cmp	r6, #0
c0de2962:	f040 8160 	bne.w	c0de2c26 <nbgl_layoutAddExtendedFooter+0x998>
c0de2966:	e11f      	b.n	c0de2ba8 <nbgl_layoutAddExtendedFooter+0x91a>
            layoutInt->footerContainer->obj.area.height = footerDesc->emptySpace.height;
c0de2968:	f8ba 1004 	ldrh.w	r1, [sl, #4]
c0de296c:	f04f 0800 	mov.w	r8, #0
c0de2970:	7181      	strb	r1, [r0, #6]
c0de2972:	0a09      	lsrs	r1, r1, #8
c0de2974:	71c1      	strb	r1, [r0, #7]
c0de2976:	e156      	b.n	c0de2c26 <nbgl_layoutAddExtendedFooter+0x998>
            textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de2978:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de297c:	08c1      	lsrs	r1, r0, #3
c0de297e:	2004      	movs	r0, #4
c0de2980:	f006 f8f1 	bl	c0de8b66 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de2984:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de2988:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de298c:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de2990:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de2994:	2a0e      	cmp	r2, #14
c0de2996:	f200 8107 	bhi.w	c0de2ba8 <nbgl_layoutAddExtendedFooter+0x91a>
c0de299a:	4606      	mov	r6, r0
c0de299c:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de299e:	3001      	adds	r0, #1
c0de29a0:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de29a4:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de29a8:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
                                       footerDesc->simpleText.token,
c0de29ac:	f89a c009 	ldrb.w	ip, [sl, #9]
                                       footerDesc->simpleText.tuneId);
c0de29b0:	f89a 700a 	ldrb.w	r7, [sl, #10]
        layout->nbUsedCallbackObjs++;
c0de29b4:	0a00      	lsrs	r0, r0, #8
c0de29b6:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de29ba:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de29be:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de29c0:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de29c4:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
c0de29c8:	2008      	movs	r0, #8
        layout->nbUsedCallbackObjs++;
c0de29ca:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
            textArea->obj.alignment  = BOTTOM_MIDDLE;
c0de29ce:	72f0      	strb	r0, [r6, #11]
            textArea->textColor      = (footerDesc->simpleText.mutedOut) ? LIGHT_TEXT_COLOR : BLACK;
c0de29d0:	f89a 0008 	ldrb.w	r0, [sl, #8]
                = (footerDesc->simpleText.mutedOut) ? SMALL_FOOTER_HEIGHT : SIMPLE_FOOTER_HEIGHT;
c0de29d4:	4637      	mov	r7, r6
            textArea->textColor      = (footerDesc->simpleText.mutedOut) ? LIGHT_TEXT_COLOR : BLACK;
c0de29d6:	7730      	strb	r0, [r6, #28]
c0de29d8:	20a0      	movs	r0, #160	@ 0xa0
            textArea->obj.area.width = AVAILABLE_WIDTH;
c0de29da:	7130      	strb	r0, [r6, #4]
c0de29dc:	2060      	movs	r0, #96	@ 0x60
c0de29de:	2501      	movs	r5, #1
                = (footerDesc->simpleText.mutedOut) ? SMALL_FOOTER_HEIGHT : SIMPLE_FOOTER_HEIGHT;
c0de29e0:	f807 0f06 	strb.w	r0, [r7, #6]!
c0de29e4:	f04f 0800 	mov.w	r8, #0
            textArea->obj.area.width = AVAILABLE_WIDTH;
c0de29e8:	7175      	strb	r5, [r6, #5]
                = (footerDesc->simpleText.mutedOut) ? SMALL_FOOTER_HEIGHT : SIMPLE_FOOTER_HEIGHT;
c0de29ea:	f887 8001 	strb.w	r8, [r7, #1]
            textArea->text = PIC(footerDesc->simpleText.text);
c0de29ee:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de29f2:	f006 ffdf 	bl	c0de99b4 <pic>
c0de29f6:	4631      	mov	r1, r6
c0de29f8:	f801 0f23 	strb.w	r0, [r1, #35]!
c0de29fc:	0e02      	lsrs	r2, r0, #24
c0de29fe:	70ca      	strb	r2, [r1, #3]
c0de2a00:	0c02      	lsrs	r2, r0, #16
c0de2a02:	0a00      	lsrs	r0, r0, #8
c0de2a04:	708a      	strb	r2, [r1, #2]
c0de2a06:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
                = (footerDesc->simpleText.mutedOut) ? SMALL_REGULAR_FONT : SMALL_BOLD_FONT;
c0de2a0a:	f89a 0008 	ldrb.w	r0, [sl, #8]
c0de2a0e:	210b      	movs	r1, #11
c0de2a10:	2800      	cmp	r0, #0
c0de2a12:	bf08      	it	eq
c0de2a14:	210c      	moveq	r1, #12
            textArea->obj.touchMask = (1 << TOUCHED);
c0de2a16:	7635      	strb	r5, [r6, #24]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2a18:	6920      	ldr	r0, [r4, #16]
                = (footerDesc->simpleText.mutedOut) ? SMALL_REGULAR_FONT : SMALL_BOLD_FONT;
c0de2a1a:	77f1      	strb	r1, [r6, #31]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2a1c:	f810 2f1c 	ldrb.w	r2, [r0, #28]!
c0de2a20:	2105      	movs	r1, #5
            textArea->textAlignment = CENTER;
c0de2a22:	7771      	strb	r1, [r6, #29]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2a24:	7841      	ldrb	r1, [r0, #1]
c0de2a26:	7883      	ldrb	r3, [r0, #2]
c0de2a28:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de2a2c:	78c2      	ldrb	r2, [r0, #3]
c0de2a2e:	7940      	ldrb	r0, [r0, #5]
c0de2a30:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de2a34:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
                = (nbgl_obj_t *) textArea;
c0de2a38:	f841 6020 	str.w	r6, [r1, r0, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de2a3c:	6920      	ldr	r0, [r4, #16]
            layoutInt->footerContainer->obj.area.height = textArea->obj.area.height;
c0de2a3e:	783a      	ldrb	r2, [r7, #0]
            layoutInt->footerContainer->nbChildren++;
c0de2a40:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
            textArea->obj.touchMask = (1 << TOUCHED);
c0de2a44:	f886 8019 	strb.w	r8, [r6, #25]
            layoutInt->footerContainer->nbChildren++;
c0de2a48:	3101      	adds	r1, #1
c0de2a4a:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
            layoutInt->footerContainer->obj.area.height = textArea->obj.area.height;
c0de2a4e:	7879      	ldrb	r1, [r7, #1]
            textArea->obj.touchId   = BOTTOM_BUTTON_ID;
c0de2a50:	76b5      	strb	r5, [r6, #26]
            layoutInt->footerContainer->obj.area.height = textArea->obj.area.height;
c0de2a52:	71c1      	strb	r1, [r0, #7]
c0de2a54:	7182      	strb	r2, [r0, #6]
c0de2a56:	e0e6      	b.n	c0de2c26 <nbgl_layoutAddExtendedFooter+0x998>
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de2a58:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2a5c:	08c1      	lsrs	r1, r0, #3
c0de2a5e:	2005      	movs	r0, #5
c0de2a60:	f006 f881 	bl	c0de8b66 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de2a64:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de2a68:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de2a6c:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de2a70:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de2a74:	2a0e      	cmp	r2, #14
c0de2a76:	f200 8097 	bhi.w	c0de2ba8 <nbgl_layoutAddExtendedFooter+0x91a>
c0de2a7a:	4607      	mov	r7, r0
c0de2a7c:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de2a7e:	3001      	adds	r0, #1
c0de2a80:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de2a84:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de2a88:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
                                       footerDesc->button.token,
c0de2a8c:	f89a c00c 	ldrb.w	ip, [sl, #12]
                                       footerDesc->button.tuneId);
c0de2a90:	f89a 6010 	ldrb.w	r6, [sl, #16]
        layout->nbUsedCallbackObjs++;
c0de2a94:	0a00      	lsrs	r0, r0, #8
c0de2a96:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de2a9a:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de2a9e:	6207      	str	r7, [r0, #32]
        layoutObj->token  = token;
c0de2aa0:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de2aa4:	f880 6026 	strb.w	r6, [r0, #38]	@ 0x26
c0de2aa8:	2008      	movs	r0, #8
        layout->nbUsedCallbackObjs++;
c0de2aaa:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
            button->obj.alignment        = BOTTOM_MIDDLE;
c0de2aae:	72f8      	strb	r0, [r7, #11]
c0de2ab0:	f04f 0800 	mov.w	r8, #0
c0de2ab4:	2018      	movs	r0, #24
            button->obj.alignmentMarginY = SINGLE_BUTTON_MARGIN;
c0de2ab6:	f887 8017 	strb.w	r8, [r7, #23]
c0de2aba:	75b8      	strb	r0, [r7, #22]
            if (footerDesc->button.style == BLACK_BACKGROUND) {
c0de2abc:	f89a 000d 	ldrb.w	r0, [sl, #13]
c0de2ac0:	2100      	movs	r1, #0
c0de2ac2:	2800      	cmp	r0, #0
c0de2ac4:	bf18      	it	ne
c0de2ac6:	2003      	movne	r0, #3
c0de2ac8:	bf08      	it	eq
c0de2aca:	2103      	moveq	r1, #3
c0de2acc:	f887 0028 	strb.w	r0, [r7, #40]	@ 0x28
c0de2ad0:	f887 102a 	strb.w	r1, [r7, #42]	@ 0x2a
            if (footerDesc->button.style == NO_BORDER) {
c0de2ad4:	f89a 000d 	ldrb.w	r0, [sl, #13]
c0de2ad8:	4601      	mov	r1, r0
c0de2ada:	2800      	cmp	r0, #0
c0de2adc:	bf18      	it	ne
c0de2ade:	2101      	movne	r1, #1
c0de2ae0:	0049      	lsls	r1, r1, #1
c0de2ae2:	2802      	cmp	r0, #2
c0de2ae4:	bf08      	it	eq
c0de2ae6:	2103      	moveq	r1, #3
c0de2ae8:	f887 1029 	strb.w	r1, [r7, #41]	@ 0x29
            button->text                                = PIC(footerDesc->button.text);
c0de2aec:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de2af0:	f006 ff60 	bl	c0de99b4 <pic>
c0de2af4:	463e      	mov	r6, r7
c0de2af6:	f806 0f1c 	strb.w	r0, [r6, #28]!
c0de2afa:	0e01      	lsrs	r1, r0, #24
c0de2afc:	70f1      	strb	r1, [r6, #3]
c0de2afe:	0c01      	lsrs	r1, r0, #16
c0de2b00:	0a00      	lsrs	r0, r0, #8
c0de2b02:	7778      	strb	r0, [r7, #29]
c0de2b04:	200c      	movs	r0, #12
c0de2b06:	70b1      	strb	r1, [r6, #2]
            button->fontId                              = SMALL_BOLD_FONT;
c0de2b08:	f887 002c 	strb.w	r0, [r7, #44]	@ 0x2c
            button->icon                                = PIC(footerDesc->button.icon);
c0de2b0c:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de2b10:	f006 ff50 	bl	c0de99b4 <pic>
c0de2b14:	4639      	mov	r1, r7
c0de2b16:	f801 0f24 	strb.w	r0, [r1, #36]!
c0de2b1a:	0e02      	lsrs	r2, r0, #24
c0de2b1c:	70ca      	strb	r2, [r1, #3]
c0de2b1e:	0c02      	lsrs	r2, r0, #16
c0de2b20:	0a00      	lsrs	r0, r0, #8
c0de2b22:	f887 0025 	strb.w	r0, [r7, #37]	@ 0x25
c0de2b26:	2058      	movs	r0, #88	@ 0x58
c0de2b28:	708a      	strb	r2, [r1, #2]
            button->obj.area.height                     = BUTTON_DIAMETER;
c0de2b2a:	71b8      	strb	r0, [r7, #6]
            layoutInt->footerContainer->obj.area.height = FOOTER_BUTTON_HEIGHT;
c0de2b2c:	6920      	ldr	r0, [r4, #16]
c0de2b2e:	2104      	movs	r1, #4
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2b30:	f810 cf1c 	ldrb.w	ip, [r0, #28]!
c0de2b34:	2288      	movs	r2, #136	@ 0x88
            button->radius                              = BUTTON_RADIUS;
c0de2b36:	f887 102b 	strb.w	r1, [r7, #43]	@ 0x2b
            button->obj.area.height                     = BUTTON_DIAMETER;
c0de2b3a:	f887 8007 	strb.w	r8, [r7, #7]
            layoutInt->footerContainer->obj.area.height = FOOTER_BUTTON_HEIGHT;
c0de2b3e:	f800 8c15 	strb.w	r8, [r0, #-21]
c0de2b42:	f800 2c16 	strb.w	r2, [r0, #-22]
            if (footerDesc->button.text == NULL) {
c0de2b46:	f8da 2004 	ldr.w	r2, [sl, #4]
c0de2b4a:	f44f 73d0 	mov.w	r3, #416	@ 0x1a0
c0de2b4e:	2a00      	cmp	r2, #0
c0de2b50:	bf08      	it	eq
c0de2b52:	2358      	moveq	r3, #88	@ 0x58
c0de2b54:	0a1a      	lsrs	r2, r3, #8
c0de2b56:	717a      	strb	r2, [r7, #5]
c0de2b58:	2201      	movs	r2, #1
c0de2b5a:	713b      	strb	r3, [r7, #4]
            button->obj.touchMask = (1 << TOUCHED);
c0de2b5c:	763a      	strb	r2, [r7, #24]
            button->obj.touchId   = button->text ? SINGLE_BUTTON_ID : BOTTOM_BUTTON_ID;
c0de2b5e:	7832      	ldrb	r2, [r6, #0]
c0de2b60:	78b3      	ldrb	r3, [r6, #2]
c0de2b62:	7f79      	ldrb	r1, [r7, #29]
c0de2b64:	78f6      	ldrb	r6, [r6, #3]
c0de2b66:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de2b6a:	ea43 2206 	orr.w	r2, r3, r6, lsl #8
c0de2b6e:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de2b72:	2900      	cmp	r1, #0
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2b74:	7841      	ldrb	r1, [r0, #1]
c0de2b76:	7883      	ldrb	r3, [r0, #2]
c0de2b78:	78c6      	ldrb	r6, [r0, #3]
c0de2b7a:	ea4c 2101 	orr.w	r1, ip, r1, lsl #8
c0de2b7e:	7940      	ldrb	r0, [r0, #5]
c0de2b80:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de2b84:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
                = (nbgl_obj_t *) button;
c0de2b88:	f841 7020 	str.w	r7, [r1, r0, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de2b8c:	6920      	ldr	r0, [r4, #16]
c0de2b8e:	f04f 0207 	mov.w	r2, #7
            button->obj.touchMask = (1 << TOUCHED);
c0de2b92:	f887 8019 	strb.w	r8, [r7, #25]
            button->obj.touchId   = button->text ? SINGLE_BUTTON_ID : BOTTOM_BUTTON_ID;
c0de2b96:	bf08      	it	eq
c0de2b98:	2201      	moveq	r2, #1
            layoutInt->footerContainer->nbChildren++;
c0de2b9a:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
            button->obj.touchId   = button->text ? SINGLE_BUTTON_ID : BOTTOM_BUTTON_ID;
c0de2b9e:	76ba      	strb	r2, [r7, #26]
            layoutInt->footerContainer->nbChildren++;
c0de2ba0:	3101      	adds	r1, #1
c0de2ba2:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
c0de2ba6:	e03e      	b.n	c0de2c26 <nbgl_layoutAddExtendedFooter+0x998>
c0de2ba8:	f04f 37ff 	mov.w	r7, #4294967295	@ 0xffffffff
}
c0de2bac:	4638      	mov	r0, r7
c0de2bae:	b002      	add	sp, #8
c0de2bb0:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de2bb4:	2000      	movs	r0, #0
            button->icon            = (footerDesc->choiceButtons.style != ROUNDED_AND_FOOTER_STYLE)
c0de2bb6:	4631      	mov	r1, r6
c0de2bb8:	f801 0f24 	strb.w	r0, [r1, #36]!
c0de2bbc:	0e02      	lsrs	r2, r0, #24
c0de2bbe:	70ca      	strb	r2, [r1, #3]
c0de2bc0:	0c02      	lsrs	r2, r0, #16
c0de2bc2:	0a00      	lsrs	r0, r0, #8
c0de2bc4:	708a      	strb	r2, [r1, #2]
c0de2bc6:	f886 0025 	strb.w	r0, [r6, #37]	@ 0x25
            button->obj.touchMask   = (1 << TOUCHED);
c0de2bca:	f886 8018 	strb.w	r8, [r6, #24]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2bce:	6921      	ldr	r1, [r4, #16]
c0de2bd0:	200c      	movs	r0, #12
            button->fontId          = SMALL_BOLD_FONT;
c0de2bd2:	f886 002c 	strb.w	r0, [r6, #44]	@ 0x2c
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2bd6:	f811 0f1c 	ldrb.w	r0, [r1, #28]!
            button->obj.touchMask   = (1 << TOUCHED);
c0de2bda:	7677      	strb	r7, [r6, #25]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2bdc:	784a      	ldrb	r2, [r1, #1]
c0de2bde:	788b      	ldrb	r3, [r1, #2]
c0de2be0:	78cf      	ldrb	r7, [r1, #3]
c0de2be2:	7949      	ldrb	r1, [r1, #5]
c0de2be4:	ea40 2002 	orr.w	r0, r0, r2, lsl #8
c0de2be8:	ea43 2207 	orr.w	r2, r3, r7, lsl #8
c0de2bec:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
                = (nbgl_obj_t *) button;
c0de2bf0:	f840 6021 	str.w	r6, [r0, r1, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de2bf4:	6920      	ldr	r0, [r4, #16]
c0de2bf6:	2109      	movs	r1, #9
c0de2bf8:	f890 2021 	ldrb.w	r2, [r0, #33]	@ 0x21
            button->obj.touchId     = CHOICE_1_ID;
c0de2bfc:	76b1      	strb	r1, [r6, #26]
            layoutInt->footerContainer->nbChildren++;
c0de2bfe:	1c51      	adds	r1, r2, #1
c0de2c00:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
            if (footerDesc->choiceButtons.style == ROUNDED_AND_FOOTER_STYLE) {
c0de2c04:	f89a 1011 	ldrb.w	r1, [sl, #17]
c0de2c08:	2903      	cmp	r1, #3
c0de2c0a:	d006      	beq.n	c0de2c1a <nbgl_layoutAddExtendedFooter+0x98c>
c0de2c0c:	b929      	cbnz	r1, c0de2c1a <nbgl_layoutAddExtendedFooter+0x98c>
c0de2c0e:	f04f 0800 	mov.w	r8, #0
                layoutInt->footerContainer->obj.area.height = ROUNDED_AND_FOOTER_FOOTER_HEIGHT;
c0de2c12:	f880 8007 	strb.w	r8, [r0, #7]
c0de2c16:	21d0      	movs	r1, #208	@ 0xd0
c0de2c18:	e004      	b.n	c0de2c24 <nbgl_layoutAddExtendedFooter+0x996>
c0de2c1a:	f04f 0800 	mov.w	r8, #0
c0de2c1e:	21e8      	movs	r1, #232	@ 0xe8
c0de2c20:	f880 8007 	strb.w	r8, [r0, #7]
c0de2c24:	7181      	strb	r1, [r0, #6]
    if ((footerDesc->type == FOOTER_NAV) || (footerDesc->type == FOOTER_TEXT_AND_NAV)) {
c0de2c26:	f89a 0000 	ldrb.w	r0, [sl]
c0de2c2a:	3803      	subs	r0, #3
c0de2c2c:	2801      	cmp	r0, #1
c0de2c2e:	d829      	bhi.n	c0de2c84 <nbgl_layoutAddExtendedFooter+0x9f6>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de2c30:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2c34:	f894 10ae 	ldrb.w	r1, [r4, #174]	@ 0xae
c0de2c38:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de2c3c:	f3c0 2105 	ubfx	r1, r0, #8, #6
c0de2c40:	290e      	cmp	r1, #14
c0de2c42:	d81f      	bhi.n	c0de2c84 <nbgl_layoutAddExtendedFooter+0x9f6>
c0de2c44:	0a02      	lsrs	r2, r0, #8
        layout->nbUsedCallbackObjs++;
c0de2c46:	3201      	adds	r2, #1
c0de2c48:	f002 023f 	and.w	r2, r2, #63	@ 0x3f
c0de2c4c:	f400 4340 	and.w	r3, r0, #49152	@ 0xc000
c0de2c50:	f89a c004 	ldrb.w	ip, [sl, #4]
c0de2c54:	f89a 700c 	ldrb.w	r7, [sl, #12]
    obj = layoutAddCallbackObj(layoutInt, (nbgl_obj_t *) layoutInt->container, token, tuneId);
c0de2c58:	f8d4 60a0 	ldr.w	r6, [r4, #160]	@ 0xa0
        layout->nbUsedCallbackObjs++;
c0de2c5c:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de2c60:	0a12      	lsrs	r2, r2, #8
c0de2c62:	f884 00ad 	strb.w	r0, [r4, #173]	@ 0xad
        layoutObj->obj    = obj;
c0de2c66:	eb04 00c1 	add.w	r0, r4, r1, lsl #3
        layout->nbUsedCallbackObjs++;
c0de2c6a:	f884 20ae 	strb.w	r2, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de2c6e:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de2c70:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de2c74:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
c0de2c78:	2003      	movs	r0, #3
    layoutInt->container->obj.touchMask = swipesMask;
c0de2c7a:	7670      	strb	r0, [r6, #25]
c0de2c7c:	2000      	movs	r0, #0
c0de2c7e:	7630      	strb	r0, [r6, #24]
    layoutInt->swipeUsage               = usage;
c0de2c80:	f884 00b0 	strb.w	r0, [r4, #176]	@ 0xb0
    if (footerDesc->separationLine) {
c0de2c84:	f89a 0001 	ldrb.w	r0, [sl, #1]
c0de2c88:	b330      	cbz	r0, c0de2cd8 <nbgl_layoutAddExtendedFooter+0xa4a>
        line                = createHorizontalLine(layoutInt->layer);
c0de2c8a:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2c8e:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de2c90:	2003      	movs	r0, #3
c0de2c92:	f005 ff68 	bl	c0de8b66 <nbgl_objPoolGet>
c0de2c96:	2101      	movs	r1, #1
c0de2c98:	22e0      	movs	r2, #224	@ 0xe0
    line->obj.area.width  = SCREEN_WIDTH;
c0de2c9a:	7102      	strb	r2, [r0, #4]
    line->obj.area.height = 1;
c0de2c9c:	7181      	strb	r1, [r0, #6]
        layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2c9e:	6922      	ldr	r2, [r4, #16]
c0de2ca0:	2300      	movs	r3, #0
c0de2ca2:	f812 7f1c 	ldrb.w	r7, [r2, #28]!
    line->obj.area.height = 1;
c0de2ca6:	71c3      	strb	r3, [r0, #7]
        layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2ca8:	7853      	ldrb	r3, [r2, #1]
c0de2caa:	7896      	ldrb	r6, [r2, #2]
c0de2cac:	78d5      	ldrb	r5, [r2, #3]
c0de2cae:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de2cb2:	ea46 2705 	orr.w	r7, r6, r5, lsl #8
c0de2cb6:	7952      	ldrb	r2, [r2, #5]
c0de2cb8:	ea43 4307 	orr.w	r3, r3, r7, lsl #16
            = (nbgl_obj_t *) line;
c0de2cbc:	f843 0022 	str.w	r0, [r3, r2, lsl #2]
        layoutInt->footerContainer->nbChildren++;
c0de2cc0:	6922      	ldr	r2, [r4, #16]
    line->obj.area.width  = SCREEN_WIDTH;
c0de2cc2:	7141      	strb	r1, [r0, #5]
    line->direction       = HORIZONTAL;
c0de2cc4:	7701      	strb	r1, [r0, #28]
    line->thickness       = 1;
c0de2cc6:	7781      	strb	r1, [r0, #30]
        layoutInt->footerContainer->nbChildren++;
c0de2cc8:	f892 1021 	ldrb.w	r1, [r2, #33]	@ 0x21
c0de2ccc:	2602      	movs	r6, #2
    line->lineColor       = LIGHT_GRAY;
c0de2cce:	7746      	strb	r6, [r0, #29]
        line->obj.alignment = TOP_MIDDLE;
c0de2cd0:	72c6      	strb	r6, [r0, #11]
        layoutInt->footerContainer->nbChildren++;
c0de2cd2:	1c48      	adds	r0, r1, #1
c0de2cd4:	f882 0021 	strb.w	r0, [r2, #33]	@ 0x21
    if (separationLine != NULL) {
c0de2cd8:	f1b8 0f00 	cmp.w	r8, #0
c0de2cdc:	d014      	beq.n	c0de2d08 <nbgl_layoutAddExtendedFooter+0xa7a>
        layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2cde:	6920      	ldr	r0, [r4, #16]
c0de2ce0:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
c0de2ce4:	7842      	ldrb	r2, [r0, #1]
c0de2ce6:	7883      	ldrb	r3, [r0, #2]
c0de2ce8:	78c7      	ldrb	r7, [r0, #3]
c0de2cea:	7940      	ldrb	r0, [r0, #5]
c0de2cec:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de2cf0:	ea43 2207 	orr.w	r2, r3, r7, lsl #8
c0de2cf4:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
            = (nbgl_obj_t *) separationLine;
c0de2cf8:	f841 8020 	str.w	r8, [r1, r0, lsl #2]
        layoutInt->footerContainer->nbChildren++;
c0de2cfc:	6920      	ldr	r0, [r4, #16]
c0de2cfe:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
c0de2d02:	3101      	adds	r1, #1
c0de2d04:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
    layoutInt->children[FOOTER_INDEX] = (nbgl_obj_t *) layoutInt->footerContainer;
c0de2d08:	68a0      	ldr	r0, [r4, #8]
c0de2d0a:	6921      	ldr	r1, [r4, #16]
c0de2d0c:	60c1      	str	r1, [r0, #12]
    layoutInt->container->obj.area.height -= layoutInt->footerContainer->obj.area.height;
c0de2d0e:	6920      	ldr	r0, [r4, #16]
c0de2d10:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
c0de2d14:	f810 2f06 	ldrb.w	r2, [r0, #6]!
c0de2d18:	f811 3f06 	ldrb.w	r3, [r1, #6]!
c0de2d1c:	7847      	ldrb	r7, [r0, #1]
c0de2d1e:	784e      	ldrb	r6, [r1, #1]
c0de2d20:	ea42 2207 	orr.w	r2, r2, r7, lsl #8
c0de2d24:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de2d28:	1a9a      	subs	r2, r3, r2
c0de2d2a:	700a      	strb	r2, [r1, #0]
c0de2d2c:	0a12      	lsrs	r2, r2, #8
c0de2d2e:	704a      	strb	r2, [r1, #1]
    return layoutInt->footerContainer->obj.area.height;
c0de2d30:	7802      	ldrb	r2, [r0, #0]
c0de2d32:	7840      	ldrb	r0, [r0, #1]
    layoutInt->footerType = footerDesc->type;
c0de2d34:	f89a 1000 	ldrb.w	r1, [sl]
    return layoutInt->footerContainer->obj.area.height;
c0de2d38:	ea42 2700 	orr.w	r7, r2, r0, lsl #8
    layoutInt->footerType = footerDesc->type;
c0de2d3c:	f884 10ab 	strb.w	r1, [r4, #171]	@ 0xab
c0de2d40:	e734      	b.n	c0de2bac <nbgl_layoutAddExtendedFooter+0x91e>

c0de2d42 <nbgl_layoutAddBottomButton>:
{
c0de2d42:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de2d44:	b087      	sub	sp, #28
c0de2d46:	4605      	mov	r5, r0
c0de2d48:	2005      	movs	r0, #5
c0de2d4a:	9e0c      	ldr	r6, [sp, #48]	@ 0x30
    footerDesc.type                  = FOOTER_SIMPLE_BUTTON;
c0de2d4c:	f88d 0004 	strb.w	r0, [sp, #4]
c0de2d50:	2700      	movs	r7, #0
    footerDesc.button.icon           = PIC(icon);
c0de2d52:	4608      	mov	r0, r1
c0de2d54:	4614      	mov	r4, r2
    footerDesc.separationLine        = separationLine;
c0de2d56:	f88d 3005 	strb.w	r3, [sp, #5]
    footerDesc.button.fittingContent = false;
c0de2d5a:	f88d 7012 	strb.w	r7, [sp, #18]
    footerDesc.button.icon           = PIC(icon);
c0de2d5e:	f006 fe29 	bl	c0de99b4 <pic>
    footerDesc.button.text           = NULL;
c0de2d62:	e9cd 7002 	strd	r7, r0, [sp, #8]
c0de2d66:	2001      	movs	r0, #1
    footerDesc.button.style          = WHITE_BACKGROUND;
c0de2d68:	f88d 0011 	strb.w	r0, [sp, #17]
c0de2d6c:	a901      	add	r1, sp, #4
    return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de2d6e:	4628      	mov	r0, r5
    footerDesc.button.token          = token;
c0de2d70:	f88d 4010 	strb.w	r4, [sp, #16]
    footerDesc.button.tuneId         = tuneId;
c0de2d74:	f88d 6014 	strb.w	r6, [sp, #20]
    return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de2d78:	f7ff fa89 	bl	c0de228e <nbgl_layoutAddExtendedFooter>
c0de2d7c:	b007      	add	sp, #28
c0de2d7e:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de2d80 <nbgl_layoutAddTouchableBar>:
{
c0de2d80:	b510      	push	{r4, lr}
c0de2d82:	b088      	sub	sp, #32
c0de2d84:	2200      	movs	r2, #0
    listItem_t             itemDesc = {0};
c0de2d86:	e9cd 2206 	strd	r2, r2, [sp, #24]
c0de2d8a:	e9cd 2204 	strd	r2, r2, [sp, #16]
c0de2d8e:	e9cd 2202 	strd	r2, r2, [sp, #8]
c0de2d92:	9201      	str	r2, [sp, #4]
    if (layout == NULL) {
c0de2d94:	b310      	cbz	r0, c0de2ddc <nbgl_layoutAddTouchableBar+0x5c>
    itemDesc.iconLeft  = barLayout->iconLeft;
c0de2d96:	e891 5008 	ldmia.w	r1, {r3, ip, lr}
    itemDesc.subText   = barLayout->subText;
c0de2d9a:	68cc      	ldr	r4, [r1, #12]
    itemDesc.iconLeft  = barLayout->iconLeft;
c0de2d9c:	9302      	str	r3, [sp, #8]
    itemDesc.token     = barLayout->token;
c0de2d9e:	7c4b      	ldrb	r3, [r1, #17]
    itemDesc.iconRight = barLayout->iconRight;
c0de2da0:	f8cd e00c 	str.w	lr, [sp, #12]
    itemDesc.token     = barLayout->token;
c0de2da4:	f88d 3018 	strb.w	r3, [sp, #24]
    itemDesc.tuneId    = barLayout->tuneId;
c0de2da8:	7d0b      	ldrb	r3, [r1, #20]
    itemDesc.text      = barLayout->text;
c0de2daa:	f8cd c010 	str.w	ip, [sp, #16]
    itemDesc.tuneId    = barLayout->tuneId;
c0de2dae:	f88d 301c 	strb.w	r3, [sp, #28]
    itemDesc.state     = (barLayout->inactive) ? OFF_STATE : ON_STATE;
c0de2db2:	7c8b      	ldrb	r3, [r1, #18]
    itemDesc.large     = barLayout->large;
c0de2db4:	7c09      	ldrb	r1, [r1, #16]
    itemDesc.state     = (barLayout->inactive) ? OFF_STATE : ON_STATE;
c0de2db6:	f083 0301 	eor.w	r3, r3, #1
    itemDesc.large     = barLayout->large;
c0de2dba:	f88d 101a 	strb.w	r1, [sp, #26]
c0de2dbe:	a901      	add	r1, sp, #4
    itemDesc.state     = (barLayout->inactive) ? OFF_STATE : ON_STATE;
c0de2dc0:	f88d 3019 	strb.w	r3, [sp, #25]
    itemDesc.subText   = barLayout->subText;
c0de2dc4:	9405      	str	r4, [sp, #20]
    itemDesc.type      = TOUCHABLE_BAR_ITEM;
c0de2dc6:	f88d 2004 	strb.w	r2, [sp, #4]
    container          = addListItem(layoutInt, &itemDesc);
c0de2dca:	f000 f80b 	bl	c0de2de4 <addListItem>
    if (container == NULL) {
c0de2dce:	b128      	cbz	r0, c0de2ddc <nbgl_layoutAddTouchableBar+0x5c>
    return container->obj.area.height;
c0de2dd0:	7981      	ldrb	r1, [r0, #6]
c0de2dd2:	79c0      	ldrb	r0, [r0, #7]
c0de2dd4:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
}
c0de2dd8:	b008      	add	sp, #32
c0de2dda:	bd10      	pop	{r4, pc}
c0de2ddc:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de2de0:	b008      	add	sp, #32
c0de2de2:	bd10      	pop	{r4, pc}

c0de2de4 <addListItem>:
{
c0de2de4:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de2de8:	468a      	mov	sl, r1
    color_t color = ((itemDesc->type == TOUCHABLE_BAR_ITEM) && (itemDesc->state == OFF_STATE))
c0de2dea:	7809      	ldrb	r1, [r1, #0]
c0de2dec:	4683      	mov	fp, r0
c0de2dee:	b109      	cbz	r1, c0de2df4 <addListItem+0x10>
c0de2df0:	2600      	movs	r6, #0
c0de2df2:	e004      	b.n	c0de2dfe <addListItem+0x1a>
c0de2df4:	f89a 0015 	ldrb.w	r0, [sl, #21]
c0de2df8:	fab0 f080 	clz	r0, r0
c0de2dfc:	0946      	lsrs	r6, r0, #5
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de2dfe:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
    color_t color = ((itemDesc->type == TOUCHABLE_BAR_ITEM) && (itemDesc->state == OFF_STATE))
c0de2e02:	2e00      	cmp	r6, #0
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de2e04:	ea4f 01d0 	mov.w	r1, r0, lsr #3
c0de2e08:	f04f 0001 	mov.w	r0, #1
    color_t color = ((itemDesc->type == TOUCHABLE_BAR_ITEM) && (itemDesc->state == OFF_STATE))
c0de2e0c:	bf18      	it	ne
c0de2e0e:	2602      	movne	r6, #2
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de2e10:	f005 fea9 	bl	c0de8b66 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de2e14:	f89b 10ad 	ldrb.w	r1, [fp, #173]	@ 0xad
c0de2e18:	f89b 20ae 	ldrb.w	r2, [fp, #174]	@ 0xae
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de2e1c:	4680      	mov	r8, r0
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de2e1e:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de2e22:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de2e26:	2a0e      	cmp	r2, #14
c0de2e28:	d817      	bhi.n	c0de2e5a <addListItem+0x76>
c0de2e2a:	0a0b      	lsrs	r3, r1, #8
        layoutObj = &layout->callbackObjPool[layout->nbUsedCallbackObjs];
c0de2e2c:	eb0b 00c2 	add.w	r0, fp, r2, lsl #3
        layout->nbUsedCallbackObjs++;
c0de2e30:	1c5a      	adds	r2, r3, #1
c0de2e32:	f002 023f 	and.w	r2, r2, #63	@ 0x3f
c0de2e36:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
        layoutInt, (nbgl_obj_t *) container, itemDesc->token, itemDesc->tuneId);
c0de2e3a:	f89a 7014 	ldrb.w	r7, [sl, #20]
c0de2e3e:	f89a 5018 	ldrb.w	r5, [sl, #24]
        layout->nbUsedCallbackObjs++;
c0de2e42:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
        layoutObj->obj    = obj;
c0de2e46:	f840 8f20 	str.w	r8, [r0, #32]!
        layout->nbUsedCallbackObjs++;
c0de2e4a:	0a12      	lsrs	r2, r2, #8
c0de2e4c:	f88b 20ae 	strb.w	r2, [fp, #174]	@ 0xae
c0de2e50:	f88b 10ad 	strb.w	r1, [fp, #173]	@ 0xad
        layoutObj->token  = token;
c0de2e54:	7107      	strb	r7, [r0, #4]
        layoutObj->tuneId = tuneId;
c0de2e56:	7185      	strb	r5, [r0, #6]
c0de2e58:	e000      	b.n	c0de2e5c <addListItem+0x78>
c0de2e5a:	2000      	movs	r0, #0
    if (obj == NULL) {
c0de2e5c:	2800      	cmp	r0, #0
c0de2e5e:	f04f 0500 	mov.w	r5, #0
c0de2e62:	f000 8097 	beq.w	c0de2f94 <addListItem+0x1b0>
    obj->index = itemDesc->index;
c0de2e66:	f89a 1017 	ldrb.w	r1, [sl, #23]
c0de2e6a:	7141      	strb	r1, [r0, #5]
    container->children   = nbgl_containerPoolGet(4, layoutInt->layer);
c0de2e6c:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
c0de2e70:	08c1      	lsrs	r1, r0, #3
c0de2e72:	2004      	movs	r0, #4
c0de2e74:	f005 fe7c 	bl	c0de8b70 <nbgl_containerPoolGet>
c0de2e78:	4641      	mov	r1, r8
c0de2e7a:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de2e7e:	0e02      	lsrs	r2, r0, #24
    container->obj.alignTo          = NULL;
c0de2e80:	f801 5d0c 	strb.w	r5, [r1, #-12]!
    container->children   = nbgl_containerPoolGet(4, layoutInt->layer);
c0de2e84:	73ca      	strb	r2, [r1, #15]
c0de2e86:	0c02      	lsrs	r2, r0, #16
c0de2e88:	738a      	strb	r2, [r1, #14]
c0de2e8a:	0a00      	lsrs	r0, r0, #8
c0de2e8c:	22a0      	movs	r2, #160	@ 0xa0
c0de2e8e:	7348      	strb	r0, [r1, #13]
    container->obj.area.width = AVAILABLE_WIDTH;
c0de2e90:	f801 2c0c 	strb.w	r2, [r1, #-12]
          + 2 * (itemDesc->large ? LIST_ITEM_PRE_HEADING_LARGE : LIST_ITEM_PRE_HEADING);
c0de2e94:	f89a 3016 	ldrb.w	r3, [sl, #22]
    if (((itemDesc->type == TOUCHABLE_BAR_ITEM) && (itemDesc->state == ON_STATE))
c0de2e98:	f89a 2000 	ldrb.w	r2, [sl]
c0de2e9c:	2001      	movs	r0, #1
c0de2e9e:	2764      	movs	r7, #100	@ 0x64
        = LIST_ITEM_MIN_TEXT_HEIGHT
c0de2ea0:	2b00      	cmp	r3, #0
    container->nbChildren = 0;
c0de2ea2:	744d      	strb	r5, [r1, #17]
    container->obj.area.width = AVAILABLE_WIDTH;
c0de2ea4:	f801 0c0b 	strb.w	r0, [r1, #-11]
        = LIST_ITEM_MIN_TEXT_HEIGHT
c0de2ea8:	bf08      	it	eq
c0de2eaa:	275c      	moveq	r7, #92	@ 0x5c
c0de2eac:	2320      	movs	r3, #32
    if (((itemDesc->type == TOUCHABLE_BAR_ITEM) && (itemDesc->state == ON_STATE))
c0de2eae:	2a01      	cmp	r2, #1
        = LIST_ITEM_MIN_TEXT_HEIGHT
c0de2eb0:	f801 5c09 	strb.w	r5, [r1, #-9]
c0de2eb4:	f801 7c0a 	strb.w	r7, [r1, #-10]
    container->layout               = HORIZONTAL;
c0de2eb8:	7408      	strb	r0, [r1, #16]
    container->obj.alignmentMarginX = BORDER_MARGIN;
c0de2eba:	714d      	strb	r5, [r1, #5]
c0de2ebc:	710b      	strb	r3, [r1, #4]
    container->obj.alignment        = NO_ALIGNMENT;
c0de2ebe:	f801 5c05 	strb.w	r5, [r1, #-5]
    container->obj.alignTo          = NULL;
c0de2ec2:	70cd      	strb	r5, [r1, #3]
c0de2ec4:	708d      	strb	r5, [r1, #2]
c0de2ec6:	704d      	strb	r5, [r1, #1]
    if (((itemDesc->type == TOUCHABLE_BAR_ITEM) && (itemDesc->state == ON_STATE))
c0de2ec8:	d006      	beq.n	c0de2ed8 <addListItem+0xf4>
c0de2eca:	b9ba      	cbnz	r2, c0de2efc <addListItem+0x118>
c0de2ecc:	f89a 1015 	ldrb.w	r1, [sl, #21]
        || (itemDesc->type == SWITCH_ITEM)) {
c0de2ed0:	2901      	cmp	r1, #1
c0de2ed2:	bf18      	it	ne
c0de2ed4:	2a01      	cmpne	r2, #1
c0de2ed6:	d111      	bne.n	c0de2efc <addListItem+0x118>
c0de2ed8:	2100      	movs	r1, #0
        container->obj.touchMask = (1 << TOUCHED);
c0de2eda:	f888 1019 	strb.w	r1, [r8, #25]
        container->obj.touchId   = CONTROLS_ID + nbTouchableControls;
c0de2ede:	f240 41d0 	movw	r1, #1232	@ 0x4d0
c0de2ee2:	f2c0 0100 	movt	r1, #0
c0de2ee6:	f819 2001 	ldrb.w	r2, [r9, r1]
        container->obj.touchMask = (1 << TOUCHED);
c0de2eea:	f888 0018 	strb.w	r0, [r8, #24]
        container->obj.touchId   = CONTROLS_ID + nbTouchableControls;
c0de2eee:	f102 0014 	add.w	r0, r2, #20
c0de2ef2:	f888 001a 	strb.w	r0, [r8, #26]
        nbTouchableControls++;
c0de2ef6:	1c50      	adds	r0, r2, #1
c0de2ef8:	f809 0001 	strb.w	r0, [r9, r1]
    if (itemDesc->text != NULL) {
c0de2efc:	f8da 000c 	ldr.w	r0, [sl, #12]
c0de2f00:	2500      	movs	r5, #0
c0de2f02:	2800      	cmp	r0, #0
c0de2f04:	d049      	beq.n	c0de2f9a <addListItem+0x1b6>
        textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de2f06:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
c0de2f0a:	08c1      	lsrs	r1, r0, #3
c0de2f0c:	2004      	movs	r0, #4
c0de2f0e:	f005 fe2a 	bl	c0de8b66 <nbgl_objPoolGet>
c0de2f12:	4607      	mov	r7, r0
        textArea->text      = PIC(itemDesc->text);
c0de2f14:	f8da 000c 	ldr.w	r0, [sl, #12]
        textArea->textColor = color;
c0de2f18:	773e      	strb	r6, [r7, #28]
        textArea->text      = PIC(itemDesc->text);
c0de2f1a:	f006 fd4b 	bl	c0de99b4 <pic>
c0de2f1e:	4639      	mov	r1, r7
c0de2f20:	f801 0f23 	strb.w	r0, [r1, #35]!
c0de2f24:	0e02      	lsrs	r2, r0, #24
c0de2f26:	70ca      	strb	r2, [r1, #3]
c0de2f28:	0c02      	lsrs	r2, r0, #16
c0de2f2a:	0a00      	lsrs	r0, r0, #8
c0de2f2c:	f887 0024 	strb.w	r0, [r7, #36]	@ 0x24
        textArea->onDrawCallback = NULL;
c0de2f30:	4638      	mov	r0, r7
c0de2f32:	f800 5f29 	strb.w	r5, [r0, #41]!
c0de2f36:	70c5      	strb	r5, [r0, #3]
c0de2f38:	7085      	strb	r5, [r0, #2]
        textArea->wrapping       = true;
c0de2f3a:	f897 0021 	ldrb.w	r0, [r7, #33]	@ 0x21
        textArea->text      = PIC(itemDesc->text);
c0de2f3e:	708a      	strb	r2, [r1, #2]
        textArea->wrapping       = true;
c0de2f40:	f040 0001 	orr.w	r0, r0, #1
        textArea->onDrawCallback = NULL;
c0de2f44:	f887 502a 	strb.w	r5, [r7, #42]	@ 0x2a
        textArea->wrapping       = true;
c0de2f48:	f887 0021 	strb.w	r0, [r7, #33]	@ 0x21
        textArea->obj.area.width = container->obj.area.width;
c0de2f4c:	f898 0004 	ldrb.w	r0, [r8, #4]
c0de2f50:	f898 2005 	ldrb.w	r2, [r8, #5]
c0de2f54:	7138      	strb	r0, [r7, #4]
        if (itemDesc->iconLeft != NULL) {
c0de2f56:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de2f5a:	210c      	movs	r1, #12
        textArea->fontId         = fontId;
c0de2f5c:	77f9      	strb	r1, [r7, #31]
        textArea->obj.area.width = container->obj.area.width;
c0de2f5e:	717a      	strb	r2, [r7, #5]
        if (itemDesc->iconLeft != NULL) {
c0de2f60:	b190      	cbz	r0, c0de2f88 <addListItem+0x1a4>
                -= ((nbgl_icon_details_t *) PIC(itemDesc->iconLeft))->width + BAR_INTERVALE;
c0de2f62:	f006 fd27 	bl	c0de99b4 <pic>
c0de2f66:	463a      	mov	r2, r7
c0de2f68:	f812 3f04 	ldrb.w	r3, [r2, #4]!
c0de2f6c:	7801      	ldrb	r1, [r0, #0]
c0de2f6e:	7840      	ldrb	r0, [r0, #1]
c0de2f70:	7855      	ldrb	r5, [r2, #1]
c0de2f72:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de2f76:	ea43 2105 	orr.w	r1, r3, r5, lsl #8
c0de2f7a:	f64f 73f0 	movw	r3, #65520	@ 0xfff0
c0de2f7e:	1a18      	subs	r0, r3, r0
c0de2f80:	4408      	add	r0, r1
c0de2f82:	7010      	strb	r0, [r2, #0]
c0de2f84:	0a00      	lsrs	r0, r0, #8
c0de2f86:	7050      	strb	r0, [r2, #1]
        if (itemDesc->iconRight != NULL) {
c0de2f88:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de2f8c:	b138      	cbz	r0, c0de2f9e <addListItem+0x1ba>
                -= ((nbgl_icon_details_t *) PIC(itemDesc->iconRight))->width + BAR_INTERVALE;
c0de2f8e:	f006 fd11 	bl	c0de99b4 <pic>
c0de2f92:	e00d      	b.n	c0de2fb0 <addListItem+0x1cc>
c0de2f94:	2000      	movs	r0, #0
}
c0de2f96:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de2f9a:	2700      	movs	r7, #0
c0de2f9c:	e07a      	b.n	c0de3094 <addListItem+0x2b0>
        else if (itemDesc->type == SWITCH_ITEM) {
c0de2f9e:	f89a 0000 	ldrb.w	r0, [sl]
c0de2fa2:	2801      	cmp	r0, #1
c0de2fa4:	d115      	bne.n	c0de2fd2 <addListItem+0x1ee>
c0de2fa6:	f247 00f9 	movw	r0, #28921	@ 0x70f9
c0de2faa:	f2c0 0000 	movt	r0, #0
c0de2fae:	4478      	add	r0, pc
c0de2fb0:	463a      	mov	r2, r7
c0de2fb2:	f812 3f04 	ldrb.w	r3, [r2, #4]!
c0de2fb6:	7801      	ldrb	r1, [r0, #0]
c0de2fb8:	7840      	ldrb	r0, [r0, #1]
c0de2fba:	7855      	ldrb	r5, [r2, #1]
c0de2fbc:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de2fc0:	ea43 2105 	orr.w	r1, r3, r5, lsl #8
c0de2fc4:	f64f 73f0 	movw	r3, #65520	@ 0xfff0
c0de2fc8:	1a18      	subs	r0, r3, r0
c0de2fca:	4408      	add	r0, r1
c0de2fcc:	7010      	strb	r0, [r2, #0]
c0de2fce:	0a00      	lsrs	r0, r0, #8
c0de2fd0:	7050      	strb	r0, [r2, #1]
        textArea->obj.area.height = MAX(
c0de2fd2:	463a      	mov	r2, r7
c0de2fd4:	f812 0f23 	ldrb.w	r0, [r2, #35]!
c0de2fd8:	78d1      	ldrb	r1, [r2, #3]
c0de2fda:	7893      	ldrb	r3, [r2, #2]
c0de2fdc:	7855      	ldrb	r5, [r2, #1]
c0de2fde:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de2fe2:	ea40 2005 	orr.w	r0, r0, r5, lsl #8
c0de2fe6:	f812 3c1f 	ldrb.w	r3, [r2, #-31]
c0de2fea:	f812 5c1e 	ldrb.w	r5, [r2, #-30]
c0de2fee:	f812 4c02 	ldrb.w	r4, [r2, #-2]
c0de2ff2:	ea40 4101 	orr.w	r1, r0, r1, lsl #16
c0de2ff6:	f812 0c04 	ldrb.w	r0, [r2, #-4]
c0de2ffa:	ea43 2205 	orr.w	r2, r3, r5, lsl #8
c0de2ffe:	f004 0301 	and.w	r3, r4, #1
c0de3002:	f005 fdc9 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de3006:	2828      	cmp	r0, #40	@ 0x28
c0de3008:	d201      	bcs.n	c0de300e <addListItem+0x22a>
c0de300a:	2028      	movs	r0, #40	@ 0x28
c0de300c:	e019      	b.n	c0de3042 <addListItem+0x25e>
c0de300e:	463a      	mov	r2, r7
c0de3010:	f812 0f23 	ldrb.w	r0, [r2, #35]!
c0de3014:	78d1      	ldrb	r1, [r2, #3]
c0de3016:	7893      	ldrb	r3, [r2, #2]
c0de3018:	7855      	ldrb	r5, [r2, #1]
c0de301a:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de301e:	ea40 2005 	orr.w	r0, r0, r5, lsl #8
c0de3022:	f812 3c1f 	ldrb.w	r3, [r2, #-31]
c0de3026:	f812 5c1e 	ldrb.w	r5, [r2, #-30]
c0de302a:	f812 4c02 	ldrb.w	r4, [r2, #-2]
c0de302e:	ea40 4101 	orr.w	r1, r0, r1, lsl #16
c0de3032:	f812 0c04 	ldrb.w	r0, [r2, #-4]
c0de3036:	ea43 2205 	orr.w	r2, r3, r5, lsl #8
c0de303a:	f004 0301 	and.w	r3, r4, #1
c0de303e:	f005 fdab 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de3042:	0a01      	lsrs	r1, r0, #8
c0de3044:	71f9      	strb	r1, [r7, #7]
c0de3046:	2100      	movs	r1, #0
c0de3048:	71b8      	strb	r0, [r7, #6]
        textArea->style         = NO_STYLE;
c0de304a:	77b9      	strb	r1, [r7, #30]
c0de304c:	2101      	movs	r1, #1
        textArea->obj.alignment = TOP_LEFT;
c0de304e:	72f9      	strb	r1, [r7, #11]
            = itemDesc->large ? LIST_ITEM_PRE_HEADING_LARGE : LIST_ITEM_PRE_HEADING;
c0de3050:	f89a 1016 	ldrb.w	r1, [sl, #22]
c0de3054:	221e      	movs	r2, #30
c0de3056:	2900      	cmp	r1, #0
c0de3058:	bf08      	it	eq
c0de305a:	221a      	moveq	r2, #26
        if (textArea->obj.area.height > LIST_ITEM_MIN_TEXT_HEIGHT) {
c0de305c:	3828      	subs	r0, #40	@ 0x28
c0de305e:	eb00 70d0 	add.w	r0, r0, r0, lsr #31
c0de3062:	bf88      	it	hi
c0de3064:	eba2 0250 	subhi.w	r2, r2, r0, lsr #1
c0de3068:	75ba      	strb	r2, [r7, #22]
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de306a:	4641      	mov	r1, r8
c0de306c:	0a10      	lsrs	r0, r2, #8
c0de306e:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
c0de3072:	75f8      	strb	r0, [r7, #23]
c0de3074:	2004      	movs	r0, #4
        textArea->textAlignment                    = MID_LEFT;
c0de3076:	7778      	strb	r0, [r7, #29]
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3078:	7848      	ldrb	r0, [r1, #1]
c0de307a:	788b      	ldrb	r3, [r1, #2]
c0de307c:	78cd      	ldrb	r5, [r1, #3]
c0de307e:	794c      	ldrb	r4, [r1, #5]
c0de3080:	ea42 2000 	orr.w	r0, r2, r0, lsl #8
c0de3084:	ea43 2205 	orr.w	r2, r3, r5, lsl #8
c0de3088:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de308c:	f840 7024 	str.w	r7, [r0, r4, lsl #2]
        container->nbChildren++;
c0de3090:	1c60      	adds	r0, r4, #1
c0de3092:	7148      	strb	r0, [r1, #5]
    if (itemDesc->iconLeft != NULL) {
c0de3094:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de3098:	2800      	cmp	r0, #0
c0de309a:	d04b      	beq.n	c0de3134 <addListItem+0x350>
        nbgl_image_t *imageLeft    = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de309c:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
c0de30a0:	08c1      	lsrs	r1, r0, #3
c0de30a2:	2002      	movs	r0, #2
c0de30a4:	f005 fd5f 	bl	c0de8b66 <nbgl_objPoolGet>
c0de30a8:	4605      	mov	r5, r0
        imageLeft->buffer          = PIC(itemDesc->iconLeft);
c0de30aa:	f8da 0004 	ldr.w	r0, [sl, #4]
        imageLeft->foregroundColor = color;
c0de30ae:	f885 6024 	strb.w	r6, [r5, #36]	@ 0x24
        imageLeft->buffer          = PIC(itemDesc->iconLeft);
c0de30b2:	f006 fc7f 	bl	c0de99b4 <pic>
c0de30b6:	4629      	mov	r1, r5
c0de30b8:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de30bc:	0e02      	lsrs	r2, r0, #24
c0de30be:	70ca      	strb	r2, [r1, #3]
c0de30c0:	0c02      	lsrs	r2, r0, #16
c0de30c2:	0a00      	lsrs	r0, r0, #8
c0de30c4:	7768      	strb	r0, [r5, #29]
c0de30c6:	2004      	movs	r0, #4
        imageLeft->obj.alignment                   = MID_LEFT;
c0de30c8:	72e8      	strb	r0, [r5, #11]
        imageLeft->obj.alignTo                     = (nbgl_obj_t *) textArea;
c0de30ca:	0a38      	lsrs	r0, r7, #8
c0de30cc:	7468      	strb	r0, [r5, #17]
c0de30ce:	4628      	mov	r0, r5
        imageLeft->buffer          = PIC(itemDesc->iconLeft);
c0de30d0:	708a      	strb	r2, [r1, #2]
        imageLeft->obj.alignTo                     = (nbgl_obj_t *) textArea;
c0de30d2:	f800 7f10 	strb.w	r7, [r0, #16]!
c0de30d6:	0e39      	lsrs	r1, r7, #24
c0de30d8:	70c1      	strb	r1, [r0, #3]
c0de30da:	0c39      	lsrs	r1, r7, #16
c0de30dc:	7081      	strb	r1, [r0, #2]
c0de30de:	2110      	movs	r1, #16
        imageLeft->obj.alignmentMarginX            = BAR_INTERVALE;
c0de30e0:	7529      	strb	r1, [r5, #20]
        container->children[container->nbChildren] = (nbgl_obj_t *) imageLeft;
c0de30e2:	4641      	mov	r1, r8
c0de30e4:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
c0de30e8:	2000      	movs	r0, #0
        imageLeft->obj.alignmentMarginX            = BAR_INTERVALE;
c0de30ea:	7568      	strb	r0, [r5, #21]
        container->children[container->nbChildren] = (nbgl_obj_t *) imageLeft;
c0de30ec:	7848      	ldrb	r0, [r1, #1]
c0de30ee:	788b      	ldrb	r3, [r1, #2]
c0de30f0:	78cc      	ldrb	r4, [r1, #3]
c0de30f2:	46b4      	mov	ip, r6
c0de30f4:	794e      	ldrb	r6, [r1, #5]
c0de30f6:	ea42 2000 	orr.w	r0, r2, r0, lsl #8
c0de30fa:	ea43 2204 	orr.w	r2, r3, r4, lsl #8
c0de30fe:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de3102:	f840 5026 	str.w	r5, [r0, r6, lsl #2]
        container->nbChildren++;
c0de3106:	1c70      	adds	r0, r6, #1
c0de3108:	4666      	mov	r6, ip
c0de310a:	7148      	strb	r0, [r1, #5]
        if (textArea != NULL) {
c0de310c:	b197      	cbz	r7, c0de3134 <addListItem+0x350>
            textArea->obj.alignmentMarginX = imageLeft->buffer->width + BAR_INTERVALE;
c0de310e:	f815 0f1c 	ldrb.w	r0, [r5, #28]!
c0de3112:	7869      	ldrb	r1, [r5, #1]
c0de3114:	78aa      	ldrb	r2, [r5, #2]
c0de3116:	78eb      	ldrb	r3, [r5, #3]
c0de3118:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de311c:	ea42 2103 	orr.w	r1, r2, r3, lsl #8
c0de3120:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de3124:	7801      	ldrb	r1, [r0, #0]
c0de3126:	7840      	ldrb	r0, [r0, #1]
c0de3128:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de312c:	3010      	adds	r0, #16
c0de312e:	7538      	strb	r0, [r7, #20]
c0de3130:	0a00      	lsrs	r0, r0, #8
c0de3132:	7578      	strb	r0, [r7, #21]
    if (itemDesc->iconRight != NULL) {
c0de3134:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de3138:	b1b8      	cbz	r0, c0de316a <addListItem+0x386>
        nbgl_image_t *imageRight    = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de313a:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
c0de313e:	08c1      	lsrs	r1, r0, #3
c0de3140:	2002      	movs	r0, #2
c0de3142:	f005 fd10 	bl	c0de8b66 <nbgl_objPoolGet>
c0de3146:	4605      	mov	r5, r0
        imageRight->buffer          = PIC(itemDesc->iconRight);
c0de3148:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de314c:	4634      	mov	r4, r6
        imageRight->foregroundColor = color;
c0de314e:	f885 6024 	strb.w	r6, [r5, #36]	@ 0x24
        imageRight->buffer          = PIC(itemDesc->iconRight);
c0de3152:	f006 fc2f 	bl	c0de99b4 <pic>
c0de3156:	4629      	mov	r1, r5
c0de3158:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de315c:	0e02      	lsrs	r2, r0, #24
c0de315e:	70ca      	strb	r2, [r1, #3]
c0de3160:	0c02      	lsrs	r2, r0, #16
c0de3162:	0a00      	lsrs	r0, r0, #8
c0de3164:	708a      	strb	r2, [r1, #2]
c0de3166:	7768      	strb	r0, [r5, #29]
c0de3168:	e012      	b.n	c0de3190 <addListItem+0x3ac>
    else if (itemDesc->type == SWITCH_ITEM) {
c0de316a:	f89a 0000 	ldrb.w	r0, [sl]
c0de316e:	2801      	cmp	r0, #1
c0de3170:	d12f      	bne.n	c0de31d2 <addListItem+0x3ee>
        nbgl_switch_t *switchObj = (nbgl_switch_t *) nbgl_objPoolGet(SWITCH, layoutInt->layer);
c0de3172:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
c0de3176:	4634      	mov	r4, r6
c0de3178:	08c1      	lsrs	r1, r0, #3
c0de317a:	2006      	movs	r0, #6
c0de317c:	f005 fcf3 	bl	c0de8b66 <nbgl_objPoolGet>
c0de3180:	4605      	mov	r5, r0
c0de3182:	2000      	movs	r0, #0
        switchObj->state         = itemDesc->state;
c0de3184:	f89a 1015 	ldrb.w	r1, [sl, #21]
        switchObj->onColor       = BLACK;
c0de3188:	7728      	strb	r0, [r5, #28]
c0de318a:	2002      	movs	r0, #2
        switchObj->offColor      = LIGHT_GRAY;
c0de318c:	7768      	strb	r0, [r5, #29]
        switchObj->state         = itemDesc->state;
c0de318e:	77a9      	strb	r1, [r5, #30]
c0de3190:	2110      	movs	r1, #16
c0de3192:	7529      	strb	r1, [r5, #20]
c0de3194:	4629      	mov	r1, r5
c0de3196:	f801 7f10 	strb.w	r7, [r1, #16]!
c0de319a:	0e3a      	lsrs	r2, r7, #24
c0de319c:	70ca      	strb	r2, [r1, #3]
c0de319e:	0c3a      	lsrs	r2, r7, #16
c0de31a0:	2006      	movs	r0, #6
c0de31a2:	708a      	strb	r2, [r1, #2]
c0de31a4:	0a39      	lsrs	r1, r7, #8
c0de31a6:	72e8      	strb	r0, [r5, #11]
c0de31a8:	7469      	strb	r1, [r5, #17]
c0de31aa:	4641      	mov	r1, r8
c0de31ac:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
c0de31b0:	2000      	movs	r0, #0
c0de31b2:	7568      	strb	r0, [r5, #21]
c0de31b4:	7848      	ldrb	r0, [r1, #1]
c0de31b6:	788b      	ldrb	r3, [r1, #2]
c0de31b8:	78ce      	ldrb	r6, [r1, #3]
c0de31ba:	ea42 2000 	orr.w	r0, r2, r0, lsl #8
c0de31be:	ea43 2206 	orr.w	r2, r3, r6, lsl #8
c0de31c2:	794b      	ldrb	r3, [r1, #5]
c0de31c4:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de31c8:	f840 5023 	str.w	r5, [r0, r3, lsl #2]
c0de31cc:	1c58      	adds	r0, r3, #1
c0de31ce:	4626      	mov	r6, r4
c0de31d0:	7148      	strb	r0, [r1, #5]
    if (itemDesc->subText != NULL) {
c0de31d2:	f8da 0010 	ldr.w	r0, [sl, #16]
c0de31d6:	2800      	cmp	r0, #0
c0de31d8:	f000 808b 	beq.w	c0de32f2 <addListItem+0x50e>
            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de31dc:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
c0de31e0:	2404      	movs	r4, #4
c0de31e2:	08c1      	lsrs	r1, r0, #3
c0de31e4:	2004      	movs	r0, #4
c0de31e6:	f005 fcbe 	bl	c0de8b66 <nbgl_objPoolGet>
c0de31ea:	4605      	mov	r5, r0
        subTextArea->text          = PIC(itemDesc->subText);
c0de31ec:	f8da 0010 	ldr.w	r0, [sl, #16]
        subTextArea->textColor     = color;
c0de31f0:	772e      	strb	r6, [r5, #28]
        subTextArea->text          = PIC(itemDesc->subText);
c0de31f2:	f006 fbdf 	bl	c0de99b4 <pic>
c0de31f6:	4629      	mov	r1, r5
c0de31f8:	f801 0f23 	strb.w	r0, [r1, #35]!
c0de31fc:	0e02      	lsrs	r2, r0, #24
c0de31fe:	70ca      	strb	r2, [r1, #3]
c0de3200:	0c02      	lsrs	r2, r0, #16
c0de3202:	708a      	strb	r2, [r1, #2]
c0de3204:	0a00      	lsrs	r0, r0, #8
        subTextArea->wrapping      = true;
c0de3206:	f895 1021 	ldrb.w	r1, [r5, #33]	@ 0x21
        subTextArea->text          = PIC(itemDesc->subText);
c0de320a:	f885 0024 	strb.w	r0, [r5, #36]	@ 0x24
c0de320e:	200b      	movs	r0, #11
        subTextArea->fontId        = SMALL_REGULAR_FONT;
c0de3210:	77e8      	strb	r0, [r5, #31]
        subTextArea->wrapping      = true;
c0de3212:	f041 0001 	orr.w	r0, r1, #1
c0de3216:	f885 0021 	strb.w	r0, [r5, #33]	@ 0x21
        if (itemDesc->text != NULL) {
c0de321a:	f8da 100c 	ldr.w	r1, [sl, #12]
c0de321e:	2000      	movs	r0, #0
        subTextArea->textAlignment = MID_LEFT;
c0de3220:	776c      	strb	r4, [r5, #29]
        subTextArea->style         = NO_STYLE;
c0de3222:	77a8      	strb	r0, [r5, #30]
        if (itemDesc->text != NULL) {
c0de3224:	b179      	cbz	r1, c0de3246 <addListItem+0x462>
            subTextArea->obj.alignTo          = (nbgl_obj_t *) textArea;
c0de3226:	4629      	mov	r1, r5
c0de3228:	f801 7f10 	strb.w	r7, [r1, #16]!
c0de322c:	2207      	movs	r2, #7
            subTextArea->obj.alignment        = BOTTOM_LEFT;
c0de322e:	f801 2c05 	strb.w	r2, [r1, #-5]
            subTextArea->obj.alignTo          = (nbgl_obj_t *) textArea;
c0de3232:	0e3a      	lsrs	r2, r7, #24
c0de3234:	70ca      	strb	r2, [r1, #3]
c0de3236:	0c3a      	lsrs	r2, r7, #16
c0de3238:	708a      	strb	r2, [r1, #2]
c0de323a:	0a3a      	lsrs	r2, r7, #8
            subTextArea->obj.alignmentMarginY = LIST_ITEM_HEADING_SUB_TEXT;
c0de323c:	71c8      	strb	r0, [r1, #7]
c0de323e:	200c      	movs	r0, #12
            subTextArea->obj.alignTo          = (nbgl_obj_t *) textArea;
c0de3240:	704a      	strb	r2, [r1, #1]
            subTextArea->obj.alignmentMarginY = LIST_ITEM_HEADING_SUB_TEXT;
c0de3242:	7188      	strb	r0, [r1, #6]
c0de3244:	e008      	b.n	c0de3258 <addListItem+0x474>
c0de3246:	2101      	movs	r1, #1
            subTextArea->obj.alignment        = TOP_LEFT;
c0de3248:	72e9      	strb	r1, [r5, #11]
c0de324a:	211c      	movs	r1, #28
            subTextArea->obj.alignmentMarginY = SUB_HEADER_MARGIN;
c0de324c:	75e8      	strb	r0, [r5, #23]
c0de324e:	75a9      	strb	r1, [r5, #22]
            container->obj.area.height        = SUB_HEADER_MARGIN;
c0de3250:	f888 0007 	strb.w	r0, [r8, #7]
c0de3254:	f888 1006 	strb.w	r1, [r8, #6]
        if (itemDesc->iconLeft != NULL) {
c0de3258:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de325c:	b158      	cbz	r0, c0de3276 <addListItem+0x492>
                = -(((nbgl_icon_details_t *) PIC(itemDesc->iconLeft))->width + BAR_INTERVALE);
c0de325e:	f006 fba9 	bl	c0de99b4 <pic>
c0de3262:	7801      	ldrb	r1, [r0, #0]
c0de3264:	7840      	ldrb	r0, [r0, #1]
c0de3266:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de326a:	f64f 71f0 	movw	r1, #65520	@ 0xfff0
c0de326e:	1a08      	subs	r0, r1, r0
c0de3270:	7528      	strb	r0, [r5, #20]
c0de3272:	0a00      	lsrs	r0, r0, #8
c0de3274:	7568      	strb	r0, [r5, #21]
        subTextArea->obj.area.width                = container->obj.area.width;
c0de3276:	f898 0004 	ldrb.w	r0, [r8, #4]
c0de327a:	f898 1005 	ldrb.w	r1, [r8, #5]
                                                                 subTextArea->text,
c0de327e:	462b      	mov	r3, r5
        subTextArea->obj.area.width                = container->obj.area.width;
c0de3280:	ea40 2201 	orr.w	r2, r0, r1, lsl #8
c0de3284:	7169      	strb	r1, [r5, #5]
                                                                 subTextArea->text,
c0de3286:	f895 1024 	ldrb.w	r1, [r5, #36]	@ 0x24
c0de328a:	f813 7f23 	ldrb.w	r7, [r3, #35]!
                                                                 subTextArea->wrapping);
c0de328e:	f895 6021 	ldrb.w	r6, [r5, #33]	@ 0x21
                                                                 subTextArea->text,
c0de3292:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de3296:	789f      	ldrb	r7, [r3, #2]
c0de3298:	78db      	ldrb	r3, [r3, #3]
        subTextArea->obj.area.width                = container->obj.area.width;
c0de329a:	7128      	strb	r0, [r5, #4]
        subTextArea->obj.area.height               = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de329c:	7fe8      	ldrb	r0, [r5, #31]
                                                                 subTextArea->text,
c0de329e:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de32a2:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
                                                                 subTextArea->wrapping);
c0de32a6:	f006 0301 	and.w	r3, r6, #1
        subTextArea->obj.area.height               = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de32aa:	f005 fc75 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de32ae:	71a8      	strb	r0, [r5, #6]
        container->children[container->nbChildren] = (nbgl_obj_t *) subTextArea;
c0de32b0:	4641      	mov	r1, r8
c0de32b2:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
        subTextArea->obj.area.height               = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de32b6:	0a03      	lsrs	r3, r0, #8
            += subTextArea->obj.area.height + subTextArea->obj.alignmentMarginY;
c0de32b8:	f811 cd16 	ldrb.w	ip, [r1, #-22]!
        subTextArea->obj.area.height               = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de32bc:	71eb      	strb	r3, [r5, #7]
        container->children[container->nbChildren] = (nbgl_obj_t *) subTextArea;
c0de32be:	7dce      	ldrb	r6, [r1, #23]
c0de32c0:	7e0c      	ldrb	r4, [r1, #24]
c0de32c2:	7e4f      	ldrb	r7, [r1, #25]
c0de32c4:	ea42 2206 	orr.w	r2, r2, r6, lsl #8
c0de32c8:	ea44 2707 	orr.w	r7, r4, r7, lsl #8
c0de32cc:	7ece      	ldrb	r6, [r1, #27]
c0de32ce:	ea42 4207 	orr.w	r2, r2, r7, lsl #16
c0de32d2:	f842 5026 	str.w	r5, [r2, r6, lsl #2]
        container->nbChildren++;
c0de32d6:	1c72      	adds	r2, r6, #1
            += subTextArea->obj.area.height + subTextArea->obj.alignmentMarginY;
c0de32d8:	7daf      	ldrb	r7, [r5, #22]
c0de32da:	7dee      	ldrb	r6, [r5, #23]
c0de32dc:	784b      	ldrb	r3, [r1, #1]
        container->nbChildren++;
c0de32de:	76ca      	strb	r2, [r1, #27]
            += subTextArea->obj.area.height + subTextArea->obj.alignmentMarginY;
c0de32e0:	ea47 2206 	orr.w	r2, r7, r6, lsl #8
c0de32e4:	4410      	add	r0, r2
c0de32e6:	ea4c 2203 	orr.w	r2, ip, r3, lsl #8
c0de32ea:	4410      	add	r0, r2
c0de32ec:	7008      	strb	r0, [r1, #0]
c0de32ee:	0a00      	lsrs	r0, r0, #8
c0de32f0:	7048      	strb	r0, [r1, #1]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de32f2:	f8db 00a0 	ldr.w	r0, [fp, #160]	@ 0xa0
    layout->container->children[layout->container->nbChildren] = obj;
c0de32f6:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
c0de32fa:	7842      	ldrb	r2, [r0, #1]
c0de32fc:	7883      	ldrb	r3, [r0, #2]
c0de32fe:	78c7      	ldrb	r7, [r0, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de3300:	7940      	ldrb	r0, [r0, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3302:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de3306:	ea43 2207 	orr.w	r2, r3, r7, lsl #8
c0de330a:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de330e:	f841 8020 	str.w	r8, [r1, r0, lsl #2]
    layout->container->nbChildren++;
c0de3312:	f8db 00a0 	ldr.w	r0, [fp, #160]	@ 0xa0
c0de3316:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
c0de331a:	3101      	adds	r1, #1
c0de331c:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
}
c0de3320:	4640      	mov	r0, r8
c0de3322:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de3326 <nbgl_layoutAddSwitch>:
{
c0de3326:	b580      	push	{r7, lr}
c0de3328:	b088      	sub	sp, #32
c0de332a:	2200      	movs	r2, #0
    listItem_t             itemDesc = {0};
c0de332c:	e9cd 2206 	strd	r2, r2, [sp, #24]
c0de3330:	e9cd 2204 	strd	r2, r2, [sp, #16]
c0de3334:	e9cd 2202 	strd	r2, r2, [sp, #8]
c0de3338:	9201      	str	r2, [sp, #4]
    if (layout == NULL) {
c0de333a:	b1f8      	cbz	r0, c0de337c <nbgl_layoutAddSwitch+0x56>
    if (switchLayout->text == NULL) {
c0de333c:	f8d1 c000 	ldr.w	ip, [r1]
    itemDesc.token   = switchLayout->token;
c0de3340:	7a4b      	ldrb	r3, [r1, #9]
    itemDesc.text    = switchLayout->text;
c0de3342:	f8cd c010 	str.w	ip, [sp, #16]
    itemDesc.token   = switchLayout->token;
c0de3346:	f88d 3018 	strb.w	r3, [sp, #24]
    itemDesc.tuneId  = switchLayout->tuneId;
c0de334a:	7a8b      	ldrb	r3, [r1, #10]
    itemDesc.subText = switchLayout->subText;
c0de334c:	f8d1 c004 	ldr.w	ip, [r1, #4]
    itemDesc.state   = switchLayout->initState;
c0de3350:	7a09      	ldrb	r1, [r1, #8]
    itemDesc.tuneId  = switchLayout->tuneId;
c0de3352:	f88d 301c 	strb.w	r3, [sp, #28]
    itemDesc.state   = switchLayout->initState;
c0de3356:	f88d 1019 	strb.w	r1, [sp, #25]
c0de335a:	2101      	movs	r1, #1
    itemDesc.type    = SWITCH_ITEM;
c0de335c:	f88d 1004 	strb.w	r1, [sp, #4]
c0de3360:	a901      	add	r1, sp, #4
    itemDesc.subText = switchLayout->subText;
c0de3362:	f8cd c014 	str.w	ip, [sp, #20]
    itemDesc.large   = false;
c0de3366:	f88d 201a 	strb.w	r2, [sp, #26]
    container        = addListItem(layoutInt, &itemDesc);
c0de336a:	f7ff fd3b 	bl	c0de2de4 <addListItem>
    if (container == NULL) {
c0de336e:	b128      	cbz	r0, c0de337c <nbgl_layoutAddSwitch+0x56>
    return container->obj.area.height;
c0de3370:	7981      	ldrb	r1, [r0, #6]
c0de3372:	79c0      	ldrb	r0, [r0, #7]
c0de3374:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
}
c0de3378:	b008      	add	sp, #32
c0de337a:	bd80      	pop	{r7, pc}
c0de337c:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de3380:	b008      	add	sp, #32
c0de3382:	bd80      	pop	{r7, pc}

c0de3384 <nbgl_layoutAddText>:
{
c0de3384:	b580      	push	{r7, lr}
c0de3386:	b088      	sub	sp, #32
c0de3388:	2300      	movs	r3, #0
    listItem_t             itemDesc = {0};
c0de338a:	e9cd 3306 	strd	r3, r3, [sp, #24]
c0de338e:	e9cd 3304 	strd	r3, r3, [sp, #16]
c0de3392:	e9cd 3302 	strd	r3, r3, [sp, #8]
c0de3396:	9301      	str	r3, [sp, #4]
    if (layout == NULL) {
c0de3398:	b1a0      	cbz	r0, c0de33c4 <nbgl_layoutAddText+0x40>
    itemDesc.text    = text;
c0de339a:	e9cd 1204 	strd	r1, r2, [sp, #16]
c0de339e:	21ff      	movs	r1, #255	@ 0xff
    itemDesc.token   = NBGL_INVALID_TOKEN;
c0de33a0:	f88d 1018 	strb.w	r1, [sp, #24]
c0de33a4:	210c      	movs	r1, #12
    itemDesc.tuneId  = NBGL_NO_TUNE;
c0de33a6:	f88d 101c 	strb.w	r1, [sp, #28]
c0de33aa:	2102      	movs	r1, #2
    itemDesc.type    = TEXT_ITEM;
c0de33ac:	f88d 1004 	strb.w	r1, [sp, #4]
c0de33b0:	a901      	add	r1, sp, #4
    container        = addListItem(layoutInt, &itemDesc);
c0de33b2:	f7ff fd17 	bl	c0de2de4 <addListItem>
    if (container == NULL) {
c0de33b6:	b128      	cbz	r0, c0de33c4 <nbgl_layoutAddText+0x40>
    return container->obj.area.height;
c0de33b8:	7981      	ldrb	r1, [r0, #6]
c0de33ba:	79c0      	ldrb	r0, [r0, #7]
c0de33bc:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
}
c0de33c0:	b008      	add	sp, #32
c0de33c2:	bd80      	pop	{r7, pc}
c0de33c4:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de33c8:	b008      	add	sp, #32
c0de33ca:	bd80      	pop	{r7, pc}

c0de33cc <nbgl_layoutAddTextWithAlias>:
{
c0de33cc:	b580      	push	{r7, lr}
c0de33ce:	b088      	sub	sp, #32
c0de33d0:	f04f 0c00 	mov.w	ip, #0
    listItem_t             itemDesc = {0};
c0de33d4:	e9cd cc06 	strd	ip, ip, [sp, #24]
c0de33d8:	e9cd cc04 	strd	ip, ip, [sp, #16]
c0de33dc:	e9cd cc02 	strd	ip, ip, [sp, #8]
c0de33e0:	f8cd c004 	str.w	ip, [sp, #4]
    if (layout == NULL) {
c0de33e4:	b1f8      	cbz	r0, c0de3426 <nbgl_layoutAddTextWithAlias+0x5a>
    itemDesc.text      = text;
c0de33e6:	e9cd 1204 	strd	r1, r2, [sp, #16]
    itemDesc.iconRight = &MINI_PUSH_ICON;
c0de33ea:	f247 4169 	movw	r1, #29801	@ 0x7469
c0de33ee:	f2c0 0100 	movt	r1, #0
c0de33f2:	4479      	add	r1, pc
c0de33f4:	9103      	str	r1, [sp, #12]
c0de33f6:	210c      	movs	r1, #12
c0de33f8:	f8dd e028 	ldr.w	lr, [sp, #40]	@ 0x28
    itemDesc.tuneId    = NBGL_NO_TUNE;
c0de33fc:	f88d 101c 	strb.w	r1, [sp, #28]
c0de3400:	2101      	movs	r1, #1
    itemDesc.state     = ON_STATE;
c0de3402:	f88d 1019 	strb.w	r1, [sp, #25]
c0de3406:	a901      	add	r1, sp, #4
    itemDesc.token     = token;
c0de3408:	f88d 3018 	strb.w	r3, [sp, #24]
    itemDesc.type      = TOUCHABLE_BAR_ITEM;
c0de340c:	f88d c004 	strb.w	ip, [sp, #4]
    itemDesc.index     = index;
c0de3410:	f88d e01b 	strb.w	lr, [sp, #27]
    container          = addListItem(layoutInt, &itemDesc);
c0de3414:	f7ff fce6 	bl	c0de2de4 <addListItem>
    if (container == NULL) {
c0de3418:	b128      	cbz	r0, c0de3426 <nbgl_layoutAddTextWithAlias+0x5a>
    return container->obj.area.height;
c0de341a:	7981      	ldrb	r1, [r0, #6]
c0de341c:	79c0      	ldrb	r0, [r0, #7]
c0de341e:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
}
c0de3422:	b008      	add	sp, #32
c0de3424:	bd80      	pop	{r7, pc}
c0de3426:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de342a:	b008      	add	sp, #32
c0de342c:	bd80      	pop	{r7, pc}
	...

c0de3430 <nbgl_layoutAddTextContent>:
    if (layout == NULL) {
c0de3430:	2800      	cmp	r0, #0
c0de3432:	bf04      	itt	eq
c0de3434:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
}
c0de3438:	4770      	bxeq	lr
c0de343a:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de343e:	4604      	mov	r4, r0
    if (content->title != NULL) {
c0de3440:	6808      	ldr	r0, [r1, #0]
c0de3442:	4688      	mov	r8, r1
c0de3444:	2800      	cmp	r0, #0
c0de3446:	d04d      	beq.n	c0de34e4 <nbgl_layoutAddTextContent+0xb4>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3448:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de344c:	2704      	movs	r7, #4
c0de344e:	08c1      	lsrs	r1, r0, #3
c0de3450:	2004      	movs	r0, #4
c0de3452:	f005 fb88 	bl	c0de8b66 <nbgl_objPoolGet>
c0de3456:	4606      	mov	r6, r0
        textArea->text          = PIC(content->title);
c0de3458:	f8d8 0000 	ldr.w	r0, [r8]
c0de345c:	2500      	movs	r5, #0
        textArea->textColor     = BLACK;
c0de345e:	7735      	strb	r5, [r6, #28]
        textArea->text          = PIC(content->title);
c0de3460:	f006 faa8 	bl	c0de99b4 <pic>
c0de3464:	4601      	mov	r1, r0
c0de3466:	4630      	mov	r0, r6
c0de3468:	f800 1f23 	strb.w	r1, [r0, #35]!
c0de346c:	0e0a      	lsrs	r2, r1, #24
c0de346e:	70c2      	strb	r2, [r0, #3]
c0de3470:	0c0a      	lsrs	r2, r1, #16
c0de3472:	7082      	strb	r2, [r0, #2]
c0de3474:	0a08      	lsrs	r0, r1, #8
c0de3476:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
c0de347a:	200d      	movs	r0, #13
        textArea->fontId        = LARGE_MEDIUM_FONT;
c0de347c:	77f0      	strb	r0, [r6, #31]
        textArea->wrapping      = true;
c0de347e:	f896 0021 	ldrb.w	r0, [r6, #33]	@ 0x21
        textArea->obj.area.height      = nbgl_getTextHeightInWidth(
c0de3482:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
        textArea->wrapping      = true;
c0de3486:	f040 0001 	orr.w	r0, r0, #1
c0de348a:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
c0de348e:	2020      	movs	r0, #32
        textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de3490:	7530      	strb	r0, [r6, #20]
c0de3492:	2010      	movs	r0, #16
        textArea->obj.alignmentMarginY = PRE_TITLE_MARGIN;
c0de3494:	75b0      	strb	r0, [r6, #22]
c0de3496:	2001      	movs	r0, #1
        textArea->obj.area.width       = AVAILABLE_WIDTH;
c0de3498:	7170      	strb	r0, [r6, #5]
c0de349a:	20a0      	movs	r0, #160	@ 0xa0
c0de349c:	7130      	strb	r0, [r6, #4]
        textArea->obj.area.height      = nbgl_getTextHeightInWidth(
c0de349e:	200d      	movs	r0, #13
c0de34a0:	2301      	movs	r3, #1
        textArea->textAlignment = MID_LEFT;
c0de34a2:	7777      	strb	r7, [r6, #29]
        textArea->style         = NO_STYLE;
c0de34a4:	77b5      	strb	r5, [r6, #30]
        textArea->obj.alignment = NO_ALIGNMENT;
c0de34a6:	72f5      	strb	r5, [r6, #11]
        textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de34a8:	7575      	strb	r5, [r6, #21]
        textArea->obj.alignmentMarginY = PRE_TITLE_MARGIN;
c0de34aa:	75f5      	strb	r5, [r6, #23]
        textArea->obj.area.height      = nbgl_getTextHeightInWidth(
c0de34ac:	f005 fb74 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de34b0:	71b0      	strb	r0, [r6, #6]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de34b2:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
        textArea->obj.area.height      = nbgl_getTextHeightInWidth(
c0de34b6:	0a00      	lsrs	r0, r0, #8
    layout->container->children[layout->container->nbChildren] = obj;
c0de34b8:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
        textArea->obj.area.height      = nbgl_getTextHeightInWidth(
c0de34bc:	71f0      	strb	r0, [r6, #7]
    layout->container->children[layout->container->nbChildren] = obj;
c0de34be:	784b      	ldrb	r3, [r1, #1]
c0de34c0:	788f      	ldrb	r7, [r1, #2]
c0de34c2:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de34c6:	78cb      	ldrb	r3, [r1, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de34c8:	7949      	ldrb	r1, [r1, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de34ca:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de34ce:	ea42 4203 	orr.w	r2, r2, r3, lsl #16
c0de34d2:	f842 6021 	str.w	r6, [r2, r1, lsl #2]
    layout->container->nbChildren++;
c0de34d6:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
c0de34da:	f891 2021 	ldrb.w	r2, [r1, #33]	@ 0x21
c0de34de:	1c50      	adds	r0, r2, #1
c0de34e0:	f881 0021 	strb.w	r0, [r1, #33]	@ 0x21
    for (i = 0; i < content->nbDescriptions; i++) {
c0de34e4:	f898 0014 	ldrb.w	r0, [r8, #20]
c0de34e8:	2800      	cmp	r0, #0
c0de34ea:	d059      	beq.n	c0de35a0 <nbgl_layoutAddTextContent+0x170>
c0de34ec:	f108 0b08 	add.w	fp, r8, #8
c0de34f0:	2500      	movs	r5, #0
c0de34f2:	f04f 0a00 	mov.w	sl, #0
c0de34f6:	bf00      	nop
        textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de34f8:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de34fc:	08c1      	lsrs	r1, r0, #3
c0de34fe:	2004      	movs	r0, #4
c0de3500:	f005 fb31 	bl	c0de8b66 <nbgl_objPoolGet>
c0de3504:	4606      	mov	r6, r0
        textArea->text      = PIC(content->descriptions[i]);
c0de3506:	f85b 002a 	ldr.w	r0, [fp, sl, lsl #2]
        textArea->textColor = BLACK;
c0de350a:	7735      	strb	r5, [r6, #28]
        textArea->text      = PIC(content->descriptions[i]);
c0de350c:	f006 fa52 	bl	c0de99b4 <pic>
c0de3510:	4601      	mov	r1, r0
c0de3512:	4630      	mov	r0, r6
c0de3514:	f800 1f23 	strb.w	r1, [r0, #35]!
c0de3518:	0e0a      	lsrs	r2, r1, #24
c0de351a:	70c2      	strb	r2, [r0, #3]
c0de351c:	0c0a      	lsrs	r2, r1, #16
c0de351e:	7082      	strb	r2, [r0, #2]
c0de3520:	0a08      	lsrs	r0, r1, #8
c0de3522:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
        textArea->fontId    = SMALL_REGULAR_FONT;
c0de3526:	200b      	movs	r0, #11
c0de3528:	77f0      	strb	r0, [r6, #31]
        textArea->wrapping  = true;
c0de352a:	f896 0021 	ldrb.w	r0, [r6, #33]	@ 0x21
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de352e:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
        textArea->wrapping  = true;
c0de3532:	f040 0001 	orr.w	r0, r0, #1
c0de3536:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de353a:	2001      	movs	r0, #1
c0de353c:	7170      	strb	r0, [r6, #5]
c0de353e:	20a0      	movs	r0, #160	@ 0xa0
c0de3540:	7130      	strb	r0, [r6, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3542:	200b      	movs	r0, #11
c0de3544:	2301      	movs	r3, #1
        textArea->style     = NO_STYLE;
c0de3546:	77b5      	strb	r5, [r6, #30]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3548:	f005 fb26 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de354c:	71b0      	strb	r0, [r6, #6]
c0de354e:	0a00      	lsrs	r0, r0, #8
c0de3550:	71f0      	strb	r0, [r6, #7]
        textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de3552:	2020      	movs	r0, #32
c0de3554:	7530      	strb	r0, [r6, #20]
            = (i == 0) ? PRE_DESCRIPTION_MARGIN : INTER_DESCRIPTIONS_MARGIN;
c0de3556:	2018      	movs	r0, #24
c0de3558:	75b0      	strb	r0, [r6, #22]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de355a:	f8d4 00a0 	ldr.w	r0, [r4, #160]	@ 0xa0
        textArea->textAlignment        = MID_LEFT;
c0de355e:	2104      	movs	r1, #4
c0de3560:	7771      	strb	r1, [r6, #29]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3562:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
    for (i = 0; i < content->nbDescriptions; i++) {
c0de3566:	f10a 0a01 	add.w	sl, sl, #1
    layout->container->children[layout->container->nbChildren] = obj;
c0de356a:	7842      	ldrb	r2, [r0, #1]
c0de356c:	7883      	ldrb	r3, [r0, #2]
c0de356e:	78c7      	ldrb	r7, [r0, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de3570:	7940      	ldrb	r0, [r0, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3572:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de3576:	ea43 2207 	orr.w	r2, r3, r7, lsl #8
c0de357a:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de357e:	f841 6020 	str.w	r6, [r1, r0, lsl #2]
    layout->container->nbChildren++;
c0de3582:	f8d4 00a0 	ldr.w	r0, [r4, #160]	@ 0xa0
    for (i = 0; i < content->nbDescriptions; i++) {
c0de3586:	f898 2014 	ldrb.w	r2, [r8, #20]
    layout->container->nbChildren++;
c0de358a:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
    for (i = 0; i < content->nbDescriptions; i++) {
c0de358e:	4592      	cmp	sl, r2
    layout->container->nbChildren++;
c0de3590:	f101 0101 	add.w	r1, r1, #1
        textArea->obj.alignment        = NO_ALIGNMENT;
c0de3594:	72f5      	strb	r5, [r6, #11]
        textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de3596:	7575      	strb	r5, [r6, #21]
            = (i == 0) ? PRE_DESCRIPTION_MARGIN : INTER_DESCRIPTIONS_MARGIN;
c0de3598:	75f5      	strb	r5, [r6, #23]
    layout->container->nbChildren++;
c0de359a:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
    for (i = 0; i < content->nbDescriptions; i++) {
c0de359e:	d3ab      	bcc.n	c0de34f8 <nbgl_layoutAddTextContent+0xc8>
    if (content->info != NULL) {
c0de35a0:	f8d8 0004 	ldr.w	r0, [r8, #4]
c0de35a4:	2800      	cmp	r0, #0
c0de35a6:	d050      	beq.n	c0de364a <nbgl_layoutAddTextContent+0x21a>
        textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de35a8:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de35ac:	f04f 0a04 	mov.w	sl, #4
c0de35b0:	08c1      	lsrs	r1, r0, #3
c0de35b2:	2004      	movs	r0, #4
c0de35b4:	f005 fad7 	bl	c0de8b66 <nbgl_objPoolGet>
c0de35b8:	4606      	mov	r6, r0
        textArea->text      = PIC(content->info);
c0de35ba:	f8d8 0004 	ldr.w	r0, [r8, #4]
c0de35be:	2501      	movs	r5, #1
        textArea->textColor = LIGHT_TEXT_COLOR;
c0de35c0:	7735      	strb	r5, [r6, #28]
        textArea->text      = PIC(content->info);
c0de35c2:	f006 f9f7 	bl	c0de99b4 <pic>
c0de35c6:	4601      	mov	r1, r0
c0de35c8:	4630      	mov	r0, r6
c0de35ca:	f800 1f23 	strb.w	r1, [r0, #35]!
c0de35ce:	0e0a      	lsrs	r2, r1, #24
c0de35d0:	70c2      	strb	r2, [r0, #3]
c0de35d2:	0c0a      	lsrs	r2, r1, #16
c0de35d4:	7082      	strb	r2, [r0, #2]
c0de35d6:	0a08      	lsrs	r0, r1, #8
c0de35d8:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
c0de35dc:	200b      	movs	r0, #11
        textArea->fontId    = SMALL_REGULAR_FONT;
c0de35de:	77f0      	strb	r0, [r6, #31]
        textArea->wrapping  = true;
c0de35e0:	f896 0021 	ldrb.w	r0, [r6, #33]	@ 0x21
c0de35e4:	2700      	movs	r7, #0
c0de35e6:	f040 0001 	orr.w	r0, r0, #1
c0de35ea:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
c0de35ee:	20a0      	movs	r0, #160	@ 0xa0
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de35f0:	7130      	strb	r0, [r6, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de35f2:	200b      	movs	r0, #11
c0de35f4:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de35f8:	2301      	movs	r3, #1
        textArea->style     = NO_STYLE;
c0de35fa:	77b7      	strb	r7, [r6, #30]
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de35fc:	7175      	strb	r5, [r6, #5]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de35fe:	f005 facb 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de3602:	71b0      	strb	r0, [r6, #6]
c0de3604:	0a00      	lsrs	r0, r0, #8
c0de3606:	71f0      	strb	r0, [r6, #7]
c0de3608:	2020      	movs	r0, #32
        textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de360a:	7530      	strb	r0, [r6, #20]
c0de360c:	2028      	movs	r0, #40	@ 0x28
        textArea->obj.alignmentMarginY = 40;
c0de360e:	75b0      	strb	r0, [r6, #22]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de3610:	f8d4 00a0 	ldr.w	r0, [r4, #160]	@ 0xa0
c0de3614:	2107      	movs	r1, #7
    layout->container->children[layout->container->nbChildren] = obj;
c0de3616:	f810 2f1c 	ldrb.w	r2, [r0, #28]!
        textArea->obj.alignment        = BOTTOM_LEFT;
c0de361a:	72f1      	strb	r1, [r6, #11]
    layout->container->children[layout->container->nbChildren] = obj;
c0de361c:	7841      	ldrb	r1, [r0, #1]
c0de361e:	7883      	ldrb	r3, [r0, #2]
c0de3620:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de3624:	78c2      	ldrb	r2, [r0, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de3626:	7940      	ldrb	r0, [r0, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3628:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de362c:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de3630:	f841 6020 	str.w	r6, [r1, r0, lsl #2]
    layout->container->nbChildren++;
c0de3634:	f8d4 00a0 	ldr.w	r0, [r4, #160]	@ 0xa0
        textArea->textAlignment        = MID_LEFT;
c0de3638:	f886 a01d 	strb.w	sl, [r6, #29]
    layout->container->nbChildren++;
c0de363c:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
        textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de3640:	7577      	strb	r7, [r6, #21]
    layout->container->nbChildren++;
c0de3642:	3101      	adds	r1, #1
        textArea->obj.alignmentMarginY = 40;
c0de3644:	75f7      	strb	r7, [r6, #23]
    layout->container->nbChildren++;
c0de3646:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
    return layoutInt->container->obj.area.height;
c0de364a:	f8d4 00a0 	ldr.w	r0, [r4, #160]	@ 0xa0
c0de364e:	7981      	ldrb	r1, [r0, #6]
c0de3650:	79c0      	ldrb	r0, [r0, #7]
c0de3652:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de3656:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
	...

c0de365c <nbgl_layoutAddRadioChoice>:
{
c0de365c:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de3660:	b082      	sub	sp, #8
    if (layout == NULL) {
c0de3662:	2800      	cmp	r0, #0
c0de3664:	f000 813c 	beq.w	c0de38e0 <nbgl_layoutAddRadioChoice+0x284>
c0de3668:	4680      	mov	r8, r0
    for (i = 0; i < choices->nbChoices; i++) {
c0de366a:	7948      	ldrb	r0, [r1, #5]
c0de366c:	460d      	mov	r5, r1
c0de366e:	2800      	cmp	r0, #0
c0de3670:	f04f 0000 	mov.w	r0, #0
c0de3674:	f000 813a 	beq.w	c0de38ec <nbgl_layoutAddRadioChoice+0x290>
c0de3678:	f04f 0a01 	mov.w	sl, #1
c0de367c:	f04f 0b02 	mov.w	fp, #2
c0de3680:	2000      	movs	r0, #0
c0de3682:	e9cd 5000 	strd	r5, r0, [sp]
c0de3686:	e098      	b.n	c0de37ba <nbgl_layoutAddRadioChoice+0x15e>
        textArea->obj.area.width = container->obj.area.width - RADIO_WIDTH;
c0de3688:	7938      	ldrb	r0, [r7, #4]
c0de368a:	7979      	ldrb	r1, [r7, #5]
        container->children[0]   = (nbgl_obj_t *) textArea;
c0de368c:	7f7a      	ldrb	r2, [r7, #29]
        textArea->obj.area.width = container->obj.area.width - RADIO_WIDTH;
c0de368e:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de3692:	3828      	subs	r0, #40	@ 0x28
c0de3694:	7130      	strb	r0, [r6, #4]
c0de3696:	0a00      	lsrs	r0, r0, #8
c0de3698:	7170      	strb	r0, [r6, #5]
c0de369a:	2000      	movs	r0, #0
        textArea->style          = NO_STYLE;
c0de369c:	77b0      	strb	r0, [r6, #30]
        textArea->obj.alignTo    = (nbgl_obj_t *) container;
c0de369e:	4630      	mov	r0, r6
c0de36a0:	f800 7f10 	strb.w	r7, [r0, #16]!
c0de36a4:	2304      	movs	r3, #4
c0de36a6:	f880 b002 	strb.w	fp, [r0, #2]
c0de36aa:	7475      	strb	r5, [r6, #17]
        container->children[0]   = (nbgl_obj_t *) textArea;
c0de36ac:	4639      	mov	r1, r7
        textArea->textAlignment  = MID_LEFT;
c0de36ae:	7773      	strb	r3, [r6, #29]
        textArea->obj.alignment  = MID_LEFT;
c0de36b0:	72f3      	strb	r3, [r6, #11]
        container->children[0]   = (nbgl_obj_t *) textArea;
c0de36b2:	f811 3f1c 	ldrb.w	r3, [r1, #28]!
        textArea->obj.alignTo    = (nbgl_obj_t *) container;
c0de36b6:	f880 a003 	strb.w	sl, [r0, #3]
        container->children[0]   = (nbgl_obj_t *) textArea;
c0de36ba:	7888      	ldrb	r0, [r1, #2]
c0de36bc:	78c9      	ldrb	r1, [r1, #3]
c0de36be:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de36c2:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de36c6:	ea42 4000 	orr.w	r0, r2, r0, lsl #16
c0de36ca:	f240 42d0 	movw	r2, #1232	@ 0x4d0
c0de36ce:	6006      	str	r6, [r0, #0]
        container->obj.touchMask = (1 << TOUCHED);
c0de36d0:	2000      	movs	r0, #0
c0de36d2:	f2c0 0200 	movt	r2, #0
c0de36d6:	7678      	strb	r0, [r7, #25]
        container->obj.touchId   = CONTROLS_ID + nbTouchableControls;
c0de36d8:	f819 0002 	ldrb.w	r0, [r9, r2]
        container->obj.touchMask = (1 << TOUCHED);
c0de36dc:	f887 e018 	strb.w	lr, [r7, #24]
        container->obj.touchId   = CONTROLS_ID + nbTouchableControls;
c0de36e0:	f100 0114 	add.w	r1, r0, #20
c0de36e4:	76b9      	strb	r1, [r7, #26]
        if (i == choices->initChoice) {
c0de36e6:	f89c 1006 	ldrb.w	r1, [ip, #6]
c0de36ea:	9d01      	ldr	r5, [sp, #4]
        nbTouchableControls++;
c0de36ec:	3001      	adds	r0, #1
c0de36ee:	f809 0002 	strb.w	r0, [r9, r2]
        if (i == choices->initChoice) {
c0de36f2:	1a68      	subs	r0, r5, r1
c0de36f4:	bf18      	it	ne
c0de36f6:	2001      	movne	r0, #1
c0de36f8:	1a69      	subs	r1, r5, r1
c0de36fa:	fab1 f181 	clz	r1, r1
c0de36fe:	ea4f 1151 	mov.w	r1, r1, lsr #5
c0de3702:	7730      	strb	r0, [r6, #28]
c0de3704:	f04f 000b 	mov.w	r0, #11
c0de3708:	f04f 0b00 	mov.w	fp, #0
c0de370c:	77a1      	strb	r1, [r4, #30]
c0de370e:	bf08      	it	eq
c0de3710:	200c      	moveq	r0, #12
c0de3712:	77f0      	strb	r0, [r6, #31]
c0de3714:	46e2      	mov	sl, ip
c0de3716:	2401      	movs	r4, #1
        textArea->obj.area.height = nbgl_getFontHeight(textArea->fontId);
c0de3718:	f005 fa34 	bl	c0de8b84 <nbgl_getFontHeight>
c0de371c:	f886 b007 	strb.w	fp, [r6, #7]
c0de3720:	71b0      	strb	r0, [r6, #6]
        line                       = createHorizontalLine(layoutInt->layer);
c0de3722:	f898 00ad 	ldrb.w	r0, [r8, #173]	@ 0xad
c0de3726:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de3728:	2003      	movs	r0, #3
c0de372a:	f005 fa1c 	bl	c0de8b66 <nbgl_objPoolGet>
    line->obj.area.width  = SCREEN_WIDTH;
c0de372e:	21e0      	movs	r1, #224	@ 0xe0
c0de3730:	f04f 0cff 	mov.w	ip, #255	@ 0xff
c0de3734:	7101      	strb	r1, [r0, #4]
    line->obj.area.height = 1;
c0de3736:	7184      	strb	r4, [r0, #6]
        line->obj.alignmentMarginY = -1;
c0de3738:	f880 c016 	strb.w	ip, [r0, #22]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de373c:	f8d8 10a0 	ldr.w	r1, [r8, #160]	@ 0xa0
    line->lineColor       = LIGHT_GRAY;
c0de3740:	2202      	movs	r2, #2
c0de3742:	7742      	strb	r2, [r0, #29]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3744:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
    line->obj.area.width  = SCREEN_WIDTH;
c0de3748:	7144      	strb	r4, [r0, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de374a:	784b      	ldrb	r3, [r1, #1]
c0de374c:	788e      	ldrb	r6, [r1, #2]
c0de374e:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de3752:	78cb      	ldrb	r3, [r1, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de3754:	7949      	ldrb	r1, [r1, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3756:	ea46 2303 	orr.w	r3, r6, r3, lsl #8
c0de375a:	ea42 4203 	orr.w	r2, r2, r3, lsl #16
c0de375e:	f842 7021 	str.w	r7, [r2, r1, lsl #2]
    layout->container->nbChildren++;
c0de3762:	f8d8 10a0 	ldr.w	r1, [r8, #160]	@ 0xa0
    line->direction       = HORIZONTAL;
c0de3766:	7704      	strb	r4, [r0, #28]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3768:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
    line->thickness       = 1;
c0de376c:	7784      	strb	r4, [r0, #30]
    layout->container->nbChildren++;
c0de376e:	794b      	ldrb	r3, [r1, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3770:	784f      	ldrb	r7, [r1, #1]
c0de3772:	788e      	ldrb	r6, [r1, #2]
c0de3774:	78cc      	ldrb	r4, [r1, #3]
    layout->container->nbChildren++;
c0de3776:	3301      	adds	r3, #1
    layout->container->children[layout->container->nbChildren] = obj;
c0de3778:	ea42 2207 	orr.w	r2, r2, r7, lsl #8
c0de377c:	ea46 2604 	orr.w	r6, r6, r4, lsl #8
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de3780:	b2df      	uxtb	r7, r3
    layout->container->children[layout->container->nbChildren] = obj;
c0de3782:	ea42 4206 	orr.w	r2, r2, r6, lsl #16
c0de3786:	f842 0027 	str.w	r0, [r2, r7, lsl #2]
    layout->container->nbChildren++;
c0de378a:	f8d8 20a0 	ldr.w	r2, [r8, #160]	@ 0xa0
c0de378e:	714b      	strb	r3, [r1, #5]
c0de3790:	f892 1021 	ldrb.w	r1, [r2, #33]	@ 0x21
    line->obj.area.height = 1;
c0de3794:	f880 b007 	strb.w	fp, [r0, #7]
        line->obj.alignmentMarginY = -1;
c0de3798:	f880 c017 	strb.w	ip, [r0, #23]
    layout->container->nbChildren++;
c0de379c:	1c48      	adds	r0, r1, #1
    for (i = 0; i < choices->nbChoices; i++) {
c0de379e:	f89a 1005 	ldrb.w	r1, [sl, #5]
c0de37a2:	3501      	adds	r5, #1
c0de37a4:	9501      	str	r5, [sp, #4]
c0de37a6:	428d      	cmp	r5, r1
c0de37a8:	4655      	mov	r5, sl
c0de37aa:	f04f 0a01 	mov.w	sl, #1
c0de37ae:	f04f 0b02 	mov.w	fp, #2
    layout->container->nbChildren++;
c0de37b2:	f882 0021 	strb.w	r0, [r2, #33]	@ 0x21
    for (i = 0; i < choices->nbChoices; i++) {
c0de37b6:	f080 8098 	bcs.w	c0de38ea <nbgl_layoutAddRadioChoice+0x28e>
        container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de37ba:	f898 00ad 	ldrb.w	r0, [r8, #173]	@ 0xad
c0de37be:	08c1      	lsrs	r1, r0, #3
c0de37c0:	2001      	movs	r0, #1
c0de37c2:	f005 f9d0 	bl	c0de8b66 <nbgl_objPoolGet>
        textArea  = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de37c6:	f898 10ad 	ldrb.w	r1, [r8, #173]	@ 0xad
        container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de37ca:	4607      	mov	r7, r0
        textArea  = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de37cc:	08c9      	lsrs	r1, r1, #3
c0de37ce:	2004      	movs	r0, #4
c0de37d0:	f005 f9c9 	bl	c0de8b66 <nbgl_objPoolGet>
        button    = (nbgl_radio_t *) nbgl_objPoolGet(RADIO_BUTTON, layoutInt->layer);
c0de37d4:	f898 10ad 	ldrb.w	r1, [r8, #173]	@ 0xad
        textArea  = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de37d8:	4606      	mov	r6, r0
        button    = (nbgl_radio_t *) nbgl_objPoolGet(RADIO_BUTTON, layoutInt->layer);
c0de37da:	08c9      	lsrs	r1, r1, #3
c0de37dc:	2009      	movs	r0, #9
c0de37de:	f005 f9c2 	bl	c0de8b66 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de37e2:	f898 10ad 	ldrb.w	r1, [r8, #173]	@ 0xad
c0de37e6:	f898 20ae 	ldrb.w	r2, [r8, #174]	@ 0xae
        button    = (nbgl_radio_t *) nbgl_objPoolGet(RADIO_BUTTON, layoutInt->layer);
c0de37ea:	4604      	mov	r4, r0
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de37ec:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de37f0:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de37f4:	2a0e      	cmp	r2, #14
c0de37f6:	d81b      	bhi.n	c0de3830 <nbgl_layoutAddRadioChoice+0x1d4>
c0de37f8:	0a0b      	lsrs	r3, r1, #8
        layoutObj = &layout->callbackObjPool[layout->nbUsedCallbackObjs];
c0de37fa:	eb08 00c2 	add.w	r0, r8, r2, lsl #3
        layout->nbUsedCallbackObjs++;
c0de37fe:	1c5a      	adds	r2, r3, #1
c0de3800:	f002 023f 	and.w	r2, r2, #63	@ 0x3f
c0de3804:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
            layoutInt, (nbgl_obj_t *) container, choices->token, choices->tuneId);
c0de3808:	f895 c007 	ldrb.w	ip, [r5, #7]
c0de380c:	f895 e008 	ldrb.w	lr, [r5, #8]
        layout->nbUsedCallbackObjs++;
c0de3810:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
        layoutObj->obj    = obj;
c0de3814:	f840 7f20 	str.w	r7, [r0, #32]!
        layout->nbUsedCallbackObjs++;
c0de3818:	0a12      	lsrs	r2, r2, #8
c0de381a:	f888 20ae 	strb.w	r2, [r8, #174]	@ 0xae
c0de381e:	f888 10ad 	strb.w	r1, [r8, #173]	@ 0xad
        layoutObj->token  = token;
c0de3822:	f880 c004 	strb.w	ip, [r0, #4]
        layoutObj->tuneId = tuneId;
c0de3826:	f880 e006 	strb.w	lr, [r0, #6]
c0de382a:	b920      	cbnz	r0, c0de3836 <nbgl_layoutAddRadioChoice+0x1da>
c0de382c:	e058      	b.n	c0de38e0 <nbgl_layoutAddRadioChoice+0x284>
c0de382e:	bf00      	nop
c0de3830:	2000      	movs	r0, #0
        if (obj == NULL) {
c0de3832:	2800      	cmp	r0, #0
c0de3834:	d054      	beq.n	c0de38e0 <nbgl_layoutAddRadioChoice+0x284>
        container->nbChildren      = 2;
c0de3836:	f887 b021 	strb.w	fp, [r7, #33]	@ 0x21
        container->children        = nbgl_containerPoolGet(container->nbChildren, layoutInt->layer);
c0de383a:	f898 00ad 	ldrb.w	r0, [r8, #173]	@ 0xad
c0de383e:	08c1      	lsrs	r1, r0, #3
c0de3840:	2002      	movs	r0, #2
c0de3842:	f005 f995 	bl	c0de8b70 <nbgl_containerPoolGet>
c0de3846:	4639      	mov	r1, r7
c0de3848:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de384c:	0e02      	lsrs	r2, r0, #24
c0de384e:	70ca      	strb	r2, [r1, #3]
c0de3850:	0c02      	lsrs	r2, r0, #16
c0de3852:	708a      	strb	r2, [r1, #2]
c0de3854:	0a01      	lsrs	r1, r0, #8
c0de3856:	7779      	strb	r1, [r7, #29]
        container->obj.area.width  = AVAILABLE_WIDTH;
c0de3858:	21a0      	movs	r1, #160	@ 0xa0
c0de385a:	7139      	strb	r1, [r7, #4]
        container->obj.area.height = RADIO_CHOICE_HEIGHT;
c0de385c:	215c      	movs	r1, #92	@ 0x5c
c0de385e:	71b9      	strb	r1, [r7, #6]
        container->obj.alignmentMarginX = BORDER_MARGIN;
c0de3860:	2120      	movs	r1, #32
c0de3862:	2200      	movs	r2, #0
c0de3864:	7539      	strb	r1, [r7, #20]
        container->obj.alignTo          = (nbgl_obj_t *) NULL;
c0de3866:	4639      	mov	r1, r7
c0de3868:	f801 2f10 	strb.w	r2, [r1, #16]!
c0de386c:	70ca      	strb	r2, [r1, #3]
c0de386e:	708a      	strb	r2, [r1, #2]
        button->obj.alignTo    = (nbgl_obj_t *) container;
c0de3870:	4621      	mov	r1, r4
        container->obj.area.width  = AVAILABLE_WIDTH;
c0de3872:	f887 a005 	strb.w	sl, [r7, #5]
        container->obj.area.height = RADIO_CHOICE_HEIGHT;
c0de3876:	71fa      	strb	r2, [r7, #7]
        container->obj.alignment   = NO_ALIGNMENT;
c0de3878:	72fa      	strb	r2, [r7, #11]
        container->obj.alignmentMarginX = BORDER_MARGIN;
c0de387a:	757a      	strb	r2, [r7, #21]
        container->obj.alignTo          = (nbgl_obj_t *) NULL;
c0de387c:	747a      	strb	r2, [r7, #17]
c0de387e:	46ac      	mov	ip, r5
        button->obj.alignTo    = (nbgl_obj_t *) container;
c0de3880:	0a3d      	lsrs	r5, r7, #8
c0de3882:	f801 7f10 	strb.w	r7, [r1, #16]!
c0de3886:	ea4f 4b17 	mov.w	fp, r7, lsr #16
c0de388a:	7465      	strb	r5, [r4, #17]
c0de388c:	ea4f 6a17 	mov.w	sl, r7, lsr #24
c0de3890:	f881 b002 	strb.w	fp, [r1, #2]
c0de3894:	f881 a003 	strb.w	sl, [r1, #3]
        if (choices->localized == true) {
c0de3898:	f89c 1004 	ldrb.w	r1, [ip, #4]
c0de389c:	f04f 0e01 	mov.w	lr, #1
c0de38a0:	2302      	movs	r3, #2
        container->children[1] = (nbgl_obj_t *) button;
c0de38a2:	6044      	str	r4, [r0, #4]
        if (choices->localized == true) {
c0de38a4:	2900      	cmp	r1, #0
        button->obj.alignment  = MID_RIGHT;
c0de38a6:	f04f 0006 	mov.w	r0, #6
        button->activeColor    = BLACK;
c0de38aa:	7722      	strb	r2, [r4, #28]
        button->borderColor    = LIGHT_GRAY;
c0de38ac:	7763      	strb	r3, [r4, #29]
        button->obj.alignment  = MID_RIGHT;
c0de38ae:	72e0      	strb	r0, [r4, #11]
        button->state          = OFF_STATE;
c0de38b0:	77a2      	strb	r2, [r4, #30]
        if (choices->localized == true) {
c0de38b2:	f47f aee9 	bne.w	c0de3688 <nbgl_layoutAddRadioChoice+0x2c>
            textArea->text = PIC(choices->names[i]);
c0de38b6:	f8dc 0000 	ldr.w	r0, [ip]
c0de38ba:	9901      	ldr	r1, [sp, #4]
c0de38bc:	f850 0021 	ldr.w	r0, [r0, r1, lsl #2]
c0de38c0:	f006 f878 	bl	c0de99b4 <pic>
c0de38c4:	4631      	mov	r1, r6
c0de38c6:	f8dd c000 	ldr.w	ip, [sp]
c0de38ca:	f801 0f23 	strb.w	r0, [r1, #35]!
c0de38ce:	0e02      	lsrs	r2, r0, #24
c0de38d0:	f04f 0e01 	mov.w	lr, #1
c0de38d4:	70ca      	strb	r2, [r1, #3]
c0de38d6:	0c02      	lsrs	r2, r0, #16
c0de38d8:	0a00      	lsrs	r0, r0, #8
c0de38da:	708a      	strb	r2, [r1, #2]
c0de38dc:	7048      	strb	r0, [r1, #1]
c0de38de:	e6d3      	b.n	c0de3688 <nbgl_layoutAddRadioChoice+0x2c>
c0de38e0:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
}
c0de38e4:	b002      	add	sp, #8
c0de38e6:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de38ea:	2000      	movs	r0, #0
c0de38ec:	b002      	add	sp, #8
c0de38ee:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de38f2 <nbgl_layoutAddCenteredInfo>:
{
c0de38f2:	b570      	push	{r4, r5, r6, lr}
c0de38f4:	b08a      	sub	sp, #40	@ 0x28
c0de38f6:	ae01      	add	r6, sp, #4
c0de38f8:	460c      	mov	r4, r1
c0de38fa:	4605      	mov	r5, r0
    nbgl_contentCenter_t   centeredInfo = {0};
c0de38fc:	4630      	mov	r0, r6
c0de38fe:	2124      	movs	r1, #36	@ 0x24
c0de3900:	f006 fa5c 	bl	c0de9dbc <__aeabi_memclr>
    if (layout == NULL) {
c0de3904:	b36d      	cbz	r5, c0de3962 <nbgl_layoutAddCenteredInfo+0x70>
    centeredInfo.icon        = info->icon;
c0de3906:	68e1      	ldr	r1, [r4, #12]
    if (info->text1 != NULL) {
c0de3908:	6820      	ldr	r0, [r4, #0]
    centeredInfo.icon        = info->icon;
c0de390a:	9102      	str	r1, [sp, #8]
c0de390c:	2100      	movs	r1, #0
    centeredInfo.illustrType = ICON_ILLUSTRATION;
c0de390e:	f88d 1004 	strb.w	r1, [sp, #4]
    if (info->text1 != NULL) {
c0de3912:	b128      	cbz	r0, c0de3920 <nbgl_layoutAddCenteredInfo+0x2e>
        if (info->style != NORMAL_INFO) {
c0de3914:	7c61      	ldrb	r1, [r4, #17]
c0de3916:	2210      	movs	r2, #16
c0de3918:	2903      	cmp	r1, #3
c0de391a:	bf08      	it	eq
c0de391c:	2214      	moveq	r2, #20
c0de391e:	50b0      	str	r0, [r6, r2]
    if (info->text2 != NULL) {
c0de3920:	6860      	ldr	r0, [r4, #4]
c0de3922:	b128      	cbz	r0, c0de3930 <nbgl_layoutAddCenteredInfo+0x3e>
        if (info->style != LARGE_CASE_BOLD_INFO) {
c0de3924:	7c61      	ldrb	r1, [r4, #17]
c0de3926:	2218      	movs	r2, #24
c0de3928:	2901      	cmp	r1, #1
c0de392a:	bf08      	it	eq
c0de392c:	2214      	moveq	r2, #20
c0de392e:	50b0      	str	r0, [r6, r2]
    if (info->text3 != NULL) {
c0de3930:	68a0      	ldr	r0, [r4, #8]
c0de3932:	b128      	cbz	r0, c0de3940 <nbgl_layoutAddCenteredInfo+0x4e>
        if (info->style == LARGE_CASE_GRAY_INFO) {
c0de3934:	7c61      	ldrb	r1, [r4, #17]
c0de3936:	2218      	movs	r2, #24
c0de3938:	2902      	cmp	r1, #2
c0de393a:	bf08      	it	eq
c0de393c:	221c      	moveq	r2, #28
c0de393e:	50b0      	str	r0, [r6, r2]
c0de3940:	a901      	add	r1, sp, #4
    container = addContentCenter(layoutInt, &centeredInfo);
c0de3942:	4628      	mov	r0, r5
c0de3944:	f000 f81b 	bl	c0de397e <addContentCenter>
    if (info->onTop) {
c0de3948:	7c21      	ldrb	r1, [r4, #16]
c0de394a:	b171      	cbz	r1, c0de396a <nbgl_layoutAddCenteredInfo+0x78>
c0de394c:	2100      	movs	r1, #0
c0de394e:	2220      	movs	r2, #32
        container->obj.alignmentMarginX = BORDER_MARGIN;
c0de3950:	7541      	strb	r1, [r0, #21]
c0de3952:	7502      	strb	r2, [r0, #20]
        container->obj.alignmentMarginY = BORDER_MARGIN + info->offsetY;
c0de3954:	8a62      	ldrh	r2, [r4, #18]
        container->obj.alignment        = NO_ALIGNMENT;
c0de3956:	72c1      	strb	r1, [r0, #11]
        container->obj.alignmentMarginY = BORDER_MARGIN + info->offsetY;
c0de3958:	3220      	adds	r2, #32
c0de395a:	7582      	strb	r2, [r0, #22]
c0de395c:	0a12      	lsrs	r2, r2, #8
c0de395e:	75c2      	strb	r2, [r0, #23]
c0de3960:	e007      	b.n	c0de3972 <nbgl_layoutAddCenteredInfo+0x80>
c0de3962:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
}
c0de3966:	b00a      	add	sp, #40	@ 0x28
c0de3968:	bd70      	pop	{r4, r5, r6, pc}
        container->obj.alignmentMarginY = info->offsetY;
c0de396a:	8a61      	ldrh	r1, [r4, #18]
c0de396c:	7581      	strb	r1, [r0, #22]
c0de396e:	0a09      	lsrs	r1, r1, #8
c0de3970:	75c1      	strb	r1, [r0, #23]
    return container->obj.area.height;
c0de3972:	7981      	ldrb	r1, [r0, #6]
c0de3974:	79c0      	ldrb	r0, [r0, #7]
c0de3976:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
}
c0de397a:	b00a      	add	sp, #40	@ 0x28
c0de397c:	bd70      	pop	{r4, r5, r6, pc}

c0de397e <addContentCenter>:
{
c0de397e:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de3982:	b084      	sub	sp, #16
c0de3984:	4682      	mov	sl, r0
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de3986:	f890 00ad 	ldrb.w	r0, [r0, #173]	@ 0xad
c0de398a:	4688      	mov	r8, r1
c0de398c:	08c1      	lsrs	r1, r0, #3
c0de398e:	2001      	movs	r0, #1
c0de3990:	f005 f8e9 	bl	c0de8b66 <nbgl_objPoolGet>
c0de3994:	2700      	movs	r7, #0
    container->nbChildren = 0;
c0de3996:	f880 7021 	strb.w	r7, [r0, #33]	@ 0x21
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de399a:	4683      	mov	fp, r0
    container->children = nbgl_containerPoolGet(6, layoutInt->layer);
c0de399c:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de39a0:	08c1      	lsrs	r1, r0, #3
c0de39a2:	2006      	movs	r0, #6
c0de39a4:	f005 f8e4 	bl	c0de8b70 <nbgl_containerPoolGet>
c0de39a8:	4659      	mov	r1, fp
c0de39aa:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de39ae:	0c02      	lsrs	r2, r0, #16
c0de39b0:	708a      	strb	r2, [r1, #2]
c0de39b2:	0a02      	lsrs	r2, r0, #8
c0de39b4:	f88b 201d 	strb.w	r2, [fp, #29]
    if (info->icon != NULL) {
c0de39b8:	f8d8 2004 	ldr.w	r2, [r8, #4]
    container->children = nbgl_containerPoolGet(6, layoutInt->layer);
c0de39bc:	0e00      	lsrs	r0, r0, #24
    if (info->icon != NULL) {
c0de39be:	2a00      	cmp	r2, #0
    container->children = nbgl_containerPoolGet(6, layoutInt->layer);
c0de39c0:	70c8      	strb	r0, [r1, #3]
    if (info->icon != NULL) {
c0de39c2:	f000 80a8 	beq.w	c0de3b16 <addContentCenter+0x198>
        image                       = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de39c6:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de39ca:	2402      	movs	r4, #2
c0de39cc:	08c1      	lsrs	r1, r0, #3
c0de39ce:	2002      	movs	r0, #2
c0de39d0:	f005 f8c9 	bl	c0de8b66 <nbgl_objPoolGet>
        image->foregroundColor      = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de39d4:	f99a 10ae 	ldrsb.w	r1, [sl, #174]	@ 0xae
c0de39d8:	f89a 20ad 	ldrb.w	r2, [sl, #173]	@ 0xad
        image                       = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de39dc:	4607      	mov	r7, r0
        image->foregroundColor      = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de39de:	ea42 2001 	orr.w	r0, r2, r1, lsl #8
c0de39e2:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
c0de39e6:	f04f 0003 	mov.w	r0, #3
c0de39ea:	bfc8      	it	gt
c0de39ec:	2000      	movgt	r0, #0
c0de39ee:	f887 0024 	strb.w	r0, [r7, #36]	@ 0x24
        image->buffer               = PIC(info->icon);
c0de39f2:	f8d8 0004 	ldr.w	r0, [r8, #4]
c0de39f6:	2503      	movs	r5, #3
c0de39f8:	f005 ffdc 	bl	c0de99b4 <pic>
c0de39fc:	4639      	mov	r1, r7
c0de39fe:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de3a02:	0e02      	lsrs	r2, r0, #24
c0de3a04:	70ca      	strb	r2, [r1, #3]
c0de3a06:	0c02      	lsrs	r2, r0, #16
c0de3a08:	708a      	strb	r2, [r1, #2]
c0de3a0a:	0a01      	lsrs	r1, r0, #8
c0de3a0c:	7779      	strb	r1, [r7, #29]
        image->obj.alignmentMarginY = info->iconHug;
c0de3a0e:	f8b8 1020 	ldrh.w	r1, [r8, #32]
        image->obj.alignment        = TOP_MIDDLE;
c0de3a12:	72fc      	strb	r4, [r7, #11]
        image->obj.alignmentMarginY = info->iconHug;
c0de3a14:	75b9      	strb	r1, [r7, #22]
c0de3a16:	0a0a      	lsrs	r2, r1, #8
        fullHeight += image->buffer->height + info->iconHug;
c0de3a18:	7883      	ldrb	r3, [r0, #2]
c0de3a1a:	78c0      	ldrb	r0, [r0, #3]
        image->obj.alignmentMarginY = info->iconHug;
c0de3a1c:	75fa      	strb	r2, [r7, #23]
        container->children[container->nbChildren] = (nbgl_obj_t *) image;
c0de3a1e:	465a      	mov	r2, fp
        fullHeight += image->buffer->height + info->iconHug;
c0de3a20:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
        container->children[container->nbChildren] = (nbgl_obj_t *) image;
c0de3a24:	f812 3f1c 	ldrb.w	r3, [r2, #28]!
        fullHeight += image->buffer->height + info->iconHug;
c0de3a28:	eb00 0c01 	add.w	ip, r0, r1
        container->children[container->nbChildren] = (nbgl_obj_t *) image;
c0de3a2c:	7850      	ldrb	r0, [r2, #1]
c0de3a2e:	7891      	ldrb	r1, [r2, #2]
c0de3a30:	78d6      	ldrb	r6, [r2, #3]
c0de3a32:	7954      	ldrb	r4, [r2, #5]
c0de3a34:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de3a38:	ea41 2106 	orr.w	r1, r1, r6, lsl #8
c0de3a3c:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de3a40:	f840 7024 	str.w	r7, [r0, r4, lsl #2]
        if (info->illustrType == ANIM_ILLUSTRATION) {
c0de3a44:	f898 0000 	ldrb.w	r0, [r8]
        container->nbChildren++;
c0de3a48:	1c61      	adds	r1, r4, #1
        if (info->illustrType == ANIM_ILLUSTRATION) {
c0de3a4a:	2801      	cmp	r0, #1
        container->nbChildren++;
c0de3a4c:	7151      	strb	r1, [r2, #5]
        if (info->illustrType == ANIM_ILLUSTRATION) {
c0de3a4e:	d164      	bne.n	c0de3b1a <addContentCenter+0x19c>
            anim                       = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de3a50:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de3a54:	f8cd c000 	str.w	ip, [sp]
c0de3a58:	08c1      	lsrs	r1, r0, #3
c0de3a5a:	2002      	movs	r0, #2
c0de3a5c:	f005 f883 	bl	c0de8b66 <nbgl_objPoolGet>
            anim->foregroundColor      = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3a60:	f99a 10ae 	ldrsb.w	r1, [sl, #174]	@ 0xae
c0de3a64:	f89a 20ad 	ldrb.w	r2, [sl, #173]	@ 0xad
            anim                       = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de3a68:	4606      	mov	r6, r0
            anim->foregroundColor      = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3a6a:	ea42 2001 	orr.w	r0, r2, r1, lsl #8
            anim->buffer               = PIC(info->animation->icons[0]);
c0de3a6e:	f8d8 1008 	ldr.w	r1, [r8, #8]
            anim->foregroundColor      = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3a72:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
c0de3a76:	bfc8      	it	gt
c0de3a78:	2500      	movgt	r5, #0
            anim->buffer               = PIC(info->animation->icons[0]);
c0de3a7a:	6808      	ldr	r0, [r1, #0]
            anim->foregroundColor      = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3a7c:	f886 5024 	strb.w	r5, [r6, #36]	@ 0x24
            anim->buffer               = PIC(info->animation->icons[0]);
c0de3a80:	6800      	ldr	r0, [r0, #0]
c0de3a82:	f005 ff97 	bl	c0de99b4 <pic>
c0de3a86:	4631      	mov	r1, r6
c0de3a88:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de3a8c:	0e02      	lsrs	r2, r0, #24
c0de3a8e:	70ca      	strb	r2, [r1, #3]
c0de3a90:	0c02      	lsrs	r2, r0, #16
c0de3a92:	0a00      	lsrs	r0, r0, #8
c0de3a94:	708a      	strb	r2, [r1, #2]
c0de3a96:	7770      	strb	r0, [r6, #29]
            anim->obj.alignmentMarginY = info->iconHug + info->animOffsetY;
c0de3a98:	f8b8 0020 	ldrh.w	r0, [r8, #32]
c0de3a9c:	f8b8 100e 	ldrh.w	r1, [r8, #14]
            anim->obj.alignment        = TOP_MIDDLE;
c0de3aa0:	2202      	movs	r2, #2
            anim->obj.alignmentMarginY = info->iconHug + info->animOffsetY;
c0de3aa2:	4408      	add	r0, r1
c0de3aa4:	75b0      	strb	r0, [r6, #22]
            anim->obj.alignmentMarginX = info->animOffsetX;
c0de3aa6:	f8b8 100c 	ldrh.w	r1, [r8, #12]
            anim->obj.alignmentMarginY = info->iconHug + info->animOffsetY;
c0de3aaa:	0a00      	lsrs	r0, r0, #8
c0de3aac:	75f0      	strb	r0, [r6, #23]
            anim->obj.alignmentMarginX = info->animOffsetX;
c0de3aae:	7531      	strb	r1, [r6, #20]
c0de3ab0:	0a08      	lsrs	r0, r1, #8
            container->children[container->nbChildren] = (nbgl_obj_t *) anim;
c0de3ab2:	4659      	mov	r1, fp
c0de3ab4:	f811 cf1c 	ldrb.w	ip, [r1, #28]!
            anim->obj.alignmentMarginX = info->animOffsetX;
c0de3ab8:	7570      	strb	r0, [r6, #21]
            container->children[container->nbChildren] = (nbgl_obj_t *) anim;
c0de3aba:	7848      	ldrb	r0, [r1, #1]
c0de3abc:	788b      	ldrb	r3, [r1, #2]
c0de3abe:	78cc      	ldrb	r4, [r1, #3]
            anim->obj.alignment        = TOP_MIDDLE;
c0de3ac0:	72f2      	strb	r2, [r6, #11]
            container->children[container->nbChildren] = (nbgl_obj_t *) anim;
c0de3ac2:	794a      	ldrb	r2, [r1, #5]
c0de3ac4:	ea4c 2000 	orr.w	r0, ip, r0, lsl #8
c0de3ac8:	ea43 2304 	orr.w	r3, r3, r4, lsl #8
c0de3acc:	ea40 4003 	orr.w	r0, r0, r3, lsl #16
c0de3ad0:	f840 6022 	str.w	r6, [r0, r2, lsl #2]
            container->nbChildren++;
c0de3ad4:	1c50      	adds	r0, r2, #1
c0de3ad6:	7148      	strb	r0, [r1, #5]
            layoutInt->animation     = info->animation;
c0de3ad8:	f8d8 0008 	ldr.w	r0, [r8, #8]
            layoutInt->incrementAnim = true;
c0de3adc:	f89a 10ad 	ldrb.w	r1, [sl, #173]	@ 0xad
            layoutInt->animation     = info->animation;
c0de3ae0:	f8ca 00a4 	str.w	r0, [sl, #164]	@ 0xa4
            layoutInt->incrementAnim = true;
c0de3ae4:	f041 0004 	orr.w	r0, r1, #4
c0de3ae8:	f88a 00ad 	strb.w	r0, [sl, #173]	@ 0xad
            tickerCfg.tickerIntervale = info->animation->delayMs;  // ms
c0de3aec:	f8d8 0008 	ldr.w	r0, [r8, #8]
c0de3af0:	2200      	movs	r2, #0
c0de3af2:	88c0      	ldrh	r0, [r0, #6]
            layoutInt->iconIdxInAnim = 0;
c0de3af4:	f88a 20af 	strb.w	r2, [sl, #175]	@ 0xaf
            tickerCfg.tickerValue     = info->animation->delayMs;  // ms
c0de3af8:	e9cd 0002 	strd	r0, r0, [sp, #8]
            tickerCfg.tickerCallback  = &animTickerCallback;
c0de3afc:	f641 106d 	movw	r0, #6509	@ 0x196d
c0de3b00:	f2c0 0000 	movt	r0, #0
c0de3b04:	4478      	add	r0, pc
c0de3b06:	9001      	str	r0, [sp, #4]
            nbgl_screenUpdateTicker(layoutInt->layer, &tickerCfg);
c0de3b08:	08c8      	lsrs	r0, r1, #3
c0de3b0a:	a901      	add	r1, sp, #4
c0de3b0c:	f005 f821 	bl	c0de8b52 <nbgl_screenUpdateTicker>
c0de3b10:	f8dd c000 	ldr.w	ip, [sp]
c0de3b14:	e001      	b.n	c0de3b1a <addContentCenter+0x19c>
c0de3b16:	f04f 0c00 	mov.w	ip, #0
    if (info->title != NULL) {
c0de3b1a:	f8d8 0010 	ldr.w	r0, [r8, #16]
c0de3b1e:	2800      	cmp	r0, #0
c0de3b20:	d069      	beq.n	c0de3bf6 <addContentCenter+0x278>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3b22:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de3b26:	4664      	mov	r4, ip
c0de3b28:	08c1      	lsrs	r1, r0, #3
c0de3b2a:	2004      	movs	r0, #4
c0de3b2c:	f005 f81b 	bl	c0de8b66 <nbgl_objPoolGet>
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3b30:	f99a 10ae 	ldrsb.w	r1, [sl, #174]	@ 0xae
c0de3b34:	f89a 20ad 	ldrb.w	r2, [sl, #173]	@ 0xad
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3b38:	4606      	mov	r6, r0
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3b3a:	ea42 2001 	orr.w	r0, r2, r1, lsl #8
c0de3b3e:	2103      	movs	r1, #3
c0de3b40:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
c0de3b44:	bfc8      	it	gt
c0de3b46:	2100      	movgt	r1, #0
        textArea->text          = PIC(info->title);
c0de3b48:	f8d8 0010 	ldr.w	r0, [r8, #16]
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3b4c:	7731      	strb	r1, [r6, #28]
        textArea->text          = PIC(info->title);
c0de3b4e:	f005 ff31 	bl	c0de99b4 <pic>
c0de3b52:	4601      	mov	r1, r0
c0de3b54:	4630      	mov	r0, r6
c0de3b56:	f800 1f23 	strb.w	r1, [r0, #35]!
c0de3b5a:	0e0a      	lsrs	r2, r1, #24
c0de3b5c:	70c2      	strb	r2, [r0, #3]
c0de3b5e:	0c0a      	lsrs	r2, r1, #16
c0de3b60:	7082      	strb	r2, [r0, #2]
c0de3b62:	0a08      	lsrs	r0, r1, #8
c0de3b64:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
c0de3b68:	2005      	movs	r0, #5
        textArea->wrapping      = true;
c0de3b6a:	f896 2021 	ldrb.w	r2, [r6, #33]	@ 0x21
        textArea->textAlignment = CENTER;
c0de3b6e:	7770      	strb	r0, [r6, #29]
c0de3b70:	200d      	movs	r0, #13
        textArea->fontId        = LARGE_MEDIUM_FONT;
c0de3b72:	77f0      	strb	r0, [r6, #31]
        textArea->wrapping      = true;
c0de3b74:	f042 0001 	orr.w	r0, r2, #1
c0de3b78:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
c0de3b7c:	2001      	movs	r0, #1
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de3b7e:	7170      	strb	r0, [r6, #5]
c0de3b80:	20a0      	movs	r0, #160	@ 0xa0
c0de3b82:	7130      	strb	r0, [r6, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3b84:	200d      	movs	r0, #13
c0de3b86:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de3b8a:	2301      	movs	r3, #1
c0de3b8c:	f005 f804 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de3b90:	71b0      	strb	r0, [r6, #6]
        if (container->nbChildren > 0) {
c0de3b92:	f89b 1021 	ldrb.w	r1, [fp, #33]	@ 0x21
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3b96:	0a02      	lsrs	r2, r0, #8
c0de3b98:	71f2      	strb	r2, [r6, #7]
        if (container->nbChildren > 0) {
c0de3b9a:	b199      	cbz	r1, c0de3bc4 <addContentCenter+0x246>
            textArea->obj.alignTo          = (nbgl_obj_t *) image;
c0de3b9c:	4632      	mov	r2, r6
c0de3b9e:	f802 7f10 	strb.w	r7, [r2, #16]!
c0de3ba2:	2308      	movs	r3, #8
            textArea->obj.alignment        = BOTTOM_MIDDLE;
c0de3ba4:	f802 3c05 	strb.w	r3, [r2, #-5]
            textArea->obj.alignTo          = (nbgl_obj_t *) image;
c0de3ba8:	0c3b      	lsrs	r3, r7, #16
c0de3baa:	7093      	strb	r3, [r2, #2]
c0de3bac:	0e3b      	lsrs	r3, r7, #24
c0de3bae:	0a3f      	lsrs	r7, r7, #8
c0de3bb0:	7057      	strb	r7, [r2, #1]
            textArea->obj.alignmentMarginY = ICON_TITLE_MARGIN + info->iconHug;
c0de3bb2:	f8b8 7020 	ldrh.w	r7, [r8, #32]
            textArea->obj.alignTo          = (nbgl_obj_t *) image;
c0de3bb6:	70d3      	strb	r3, [r2, #3]
            textArea->obj.alignmentMarginY = ICON_TITLE_MARGIN + info->iconHug;
c0de3bb8:	f107 0318 	add.w	r3, r7, #24
c0de3bbc:	7193      	strb	r3, [r2, #6]
c0de3bbe:	0a1b      	lsrs	r3, r3, #8
c0de3bc0:	71d3      	strb	r3, [r2, #7]
c0de3bc2:	e001      	b.n	c0de3bc8 <addContentCenter+0x24a>
c0de3bc4:	2202      	movs	r2, #2
            textArea->obj.alignment = TOP_MIDDLE;
c0de3bc6:	72f2      	strb	r2, [r6, #11]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de3bc8:	7db2      	ldrb	r2, [r6, #22]
c0de3bca:	7df3      	ldrb	r3, [r6, #23]
c0de3bcc:	4420      	add	r0, r4
c0de3bce:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3bd2:	465b      	mov	r3, fp
c0de3bd4:	f813 7f1c 	ldrb.w	r7, [r3, #28]!
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de3bd8:	eb00 0c02 	add.w	ip, r0, r2
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3bdc:	7858      	ldrb	r0, [r3, #1]
c0de3bde:	789a      	ldrb	r2, [r3, #2]
c0de3be0:	78dc      	ldrb	r4, [r3, #3]
c0de3be2:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de3be6:	ea42 2204 	orr.w	r2, r2, r4, lsl #8
c0de3bea:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de3bee:	f840 6021 	str.w	r6, [r0, r1, lsl #2]
        container->nbChildren++;
c0de3bf2:	1c48      	adds	r0, r1, #1
c0de3bf4:	7158      	strb	r0, [r3, #5]
    if (info->smallTitle != NULL) {
c0de3bf6:	f8d8 0014 	ldr.w	r0, [r8, #20]
c0de3bfa:	2800      	cmp	r0, #0
c0de3bfc:	f000 8089 	beq.w	c0de3d12 <addContentCenter+0x394>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3c00:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de3c04:	f8cd c000 	str.w	ip, [sp]
c0de3c08:	08c1      	lsrs	r1, r0, #3
c0de3c0a:	2004      	movs	r0, #4
c0de3c0c:	f004 ffab 	bl	c0de8b66 <nbgl_objPoolGet>
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3c10:	f99a 10ae 	ldrsb.w	r1, [sl, #174]	@ 0xae
c0de3c14:	f89a 20ad 	ldrb.w	r2, [sl, #173]	@ 0xad
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3c18:	4605      	mov	r5, r0
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3c1a:	ea42 2001 	orr.w	r0, r2, r1, lsl #8
c0de3c1e:	2103      	movs	r1, #3
c0de3c20:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
c0de3c24:	bfc8      	it	gt
c0de3c26:	2100      	movgt	r1, #0
        textArea->text          = PIC(info->smallTitle);
c0de3c28:	f8d8 0014 	ldr.w	r0, [r8, #20]
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3c2c:	7729      	strb	r1, [r5, #28]
        textArea->text          = PIC(info->smallTitle);
c0de3c2e:	f005 fec1 	bl	c0de99b4 <pic>
c0de3c32:	4601      	mov	r1, r0
c0de3c34:	4628      	mov	r0, r5
c0de3c36:	f800 1f23 	strb.w	r1, [r0, #35]!
c0de3c3a:	0e0a      	lsrs	r2, r1, #24
c0de3c3c:	70c2      	strb	r2, [r0, #3]
c0de3c3e:	0c0a      	lsrs	r2, r1, #16
c0de3c40:	7082      	strb	r2, [r0, #2]
c0de3c42:	0a08      	lsrs	r0, r1, #8
c0de3c44:	f885 0024 	strb.w	r0, [r5, #36]	@ 0x24
c0de3c48:	2005      	movs	r0, #5
        textArea->wrapping      = true;
c0de3c4a:	f895 2021 	ldrb.w	r2, [r5, #33]	@ 0x21
        textArea->textAlignment = CENTER;
c0de3c4e:	7768      	strb	r0, [r5, #29]
c0de3c50:	200c      	movs	r0, #12
        textArea->fontId        = SMALL_BOLD_FONT;
c0de3c52:	77e8      	strb	r0, [r5, #31]
        textArea->wrapping      = true;
c0de3c54:	f042 0001 	orr.w	r0, r2, #1
c0de3c58:	f885 0021 	strb.w	r0, [r5, #33]	@ 0x21
c0de3c5c:	2001      	movs	r0, #1
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de3c5e:	7168      	strb	r0, [r5, #5]
c0de3c60:	20a0      	movs	r0, #160	@ 0xa0
c0de3c62:	7128      	strb	r0, [r5, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3c64:	200c      	movs	r0, #12
c0de3c66:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de3c6a:	2301      	movs	r3, #1
c0de3c6c:	f004 ff94 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de3c70:	71a8      	strb	r0, [r5, #6]
        if (container->nbChildren > 0) {
c0de3c72:	f89b 1021 	ldrb.w	r1, [fp, #33]	@ 0x21
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3c76:	0a02      	lsrs	r2, r0, #8
c0de3c78:	71ea      	strb	r2, [r5, #7]
        if (container->nbChildren > 0) {
c0de3c7a:	b361      	cbz	r1, c0de3cd6 <addContentCenter+0x358>
            textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de3c7c:	465a      	mov	r2, fp
c0de3c7e:	f812 3f1c 	ldrb.w	r3, [r2, #28]!
c0de3c82:	462f      	mov	r7, r5
c0de3c84:	7856      	ldrb	r6, [r2, #1]
c0de3c86:	7894      	ldrb	r4, [r2, #2]
c0de3c88:	78d2      	ldrb	r2, [r2, #3]
c0de3c8a:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de3c8e:	ea44 2202 	orr.w	r2, r4, r2, lsl #8
c0de3c92:	ea43 4202 	orr.w	r2, r3, r2, lsl #16
c0de3c96:	eb02 0281 	add.w	r2, r2, r1, lsl #2
c0de3c9a:	f852 3c04 	ldr.w	r3, [r2, #-4]
c0de3c9e:	f807 3f10 	strb.w	r3, [r7, #16]!
c0de3ca2:	0e1e      	lsrs	r6, r3, #24
c0de3ca4:	70fe      	strb	r6, [r7, #3]
c0de3ca6:	0c1e      	lsrs	r6, r3, #16
c0de3ca8:	0a1b      	lsrs	r3, r3, #8
c0de3caa:	707b      	strb	r3, [r7, #1]
c0de3cac:	2318      	movs	r3, #24
c0de3cae:	70be      	strb	r6, [r7, #2]
            textArea->obj.alignmentMarginY = VERTICAL_BORDER_MARGIN;
c0de3cb0:	71bb      	strb	r3, [r7, #6]
            if (container->children[container->nbChildren - 1]->type == IMAGE) {
c0de3cb2:	f852 2c04 	ldr.w	r2, [r2, #-4]
c0de3cb6:	2608      	movs	r6, #8
c0de3cb8:	7a93      	ldrb	r3, [r2, #10]
c0de3cba:	2200      	movs	r2, #0
            textArea->obj.alignment = BOTTOM_MIDDLE;
c0de3cbc:	f807 6c05 	strb.w	r6, [r7, #-5]
            textArea->obj.alignmentMarginY = VERTICAL_BORDER_MARGIN;
c0de3cc0:	71fa      	strb	r2, [r7, #7]
c0de3cc2:	9f00      	ldr	r7, [sp, #0]
            if (container->children[container->nbChildren - 1]->type == IMAGE) {
c0de3cc4:	2b02      	cmp	r3, #2
c0de3cc6:	d10a      	bne.n	c0de3cde <addContentCenter+0x360>
                textArea->obj.alignmentMarginY = VERTICAL_BORDER_MARGIN + info->iconHug;
c0de3cc8:	f8b8 2020 	ldrh.w	r2, [r8, #32]
c0de3ccc:	3218      	adds	r2, #24
c0de3cce:	75aa      	strb	r2, [r5, #22]
c0de3cd0:	0a12      	lsrs	r2, r2, #8
c0de3cd2:	75ea      	strb	r2, [r5, #23]
c0de3cd4:	e006      	b.n	c0de3ce4 <addContentCenter+0x366>
c0de3cd6:	9f00      	ldr	r7, [sp, #0]
c0de3cd8:	2202      	movs	r2, #2
            textArea->obj.alignment = TOP_MIDDLE;
c0de3cda:	72ea      	strb	r2, [r5, #11]
c0de3cdc:	e002      	b.n	c0de3ce4 <addContentCenter+0x366>
                textArea->obj.alignmentMarginY = TITLE_DESC_MARGIN;
c0de3cde:	75ea      	strb	r2, [r5, #23]
c0de3ce0:	2210      	movs	r2, #16
c0de3ce2:	75aa      	strb	r2, [r5, #22]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de3ce4:	7daa      	ldrb	r2, [r5, #22]
c0de3ce6:	7deb      	ldrb	r3, [r5, #23]
c0de3ce8:	4438      	add	r0, r7
c0de3cea:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3cee:	465b      	mov	r3, fp
c0de3cf0:	f813 7f1c 	ldrb.w	r7, [r3, #28]!
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de3cf4:	eb00 0c02 	add.w	ip, r0, r2
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3cf8:	7858      	ldrb	r0, [r3, #1]
c0de3cfa:	789a      	ldrb	r2, [r3, #2]
c0de3cfc:	78de      	ldrb	r6, [r3, #3]
c0de3cfe:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de3d02:	ea42 2206 	orr.w	r2, r2, r6, lsl #8
c0de3d06:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de3d0a:	f840 5021 	str.w	r5, [r0, r1, lsl #2]
        container->nbChildren++;
c0de3d0e:	1c48      	adds	r0, r1, #1
c0de3d10:	7158      	strb	r0, [r3, #5]
    if (info->description != NULL) {
c0de3d12:	f8d8 0018 	ldr.w	r0, [r8, #24]
c0de3d16:	2800      	cmp	r0, #0
c0de3d18:	f000 8083 	beq.w	c0de3e22 <addContentCenter+0x4a4>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3d1c:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de3d20:	4664      	mov	r4, ip
c0de3d22:	08c1      	lsrs	r1, r0, #3
c0de3d24:	2004      	movs	r0, #4
c0de3d26:	f004 ff1e 	bl	c0de8b66 <nbgl_objPoolGet>
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3d2a:	f99a 10ae 	ldrsb.w	r1, [sl, #174]	@ 0xae
c0de3d2e:	f89a 20ad 	ldrb.w	r2, [sl, #173]	@ 0xad
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3d32:	4607      	mov	r7, r0
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3d34:	ea42 2001 	orr.w	r0, r2, r1, lsl #8
c0de3d38:	2103      	movs	r1, #3
c0de3d3a:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
c0de3d3e:	bfc8      	it	gt
c0de3d40:	2100      	movgt	r1, #0
        textArea->text          = PIC(info->description);
c0de3d42:	f8d8 0018 	ldr.w	r0, [r8, #24]
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3d46:	7739      	strb	r1, [r7, #28]
        textArea->text          = PIC(info->description);
c0de3d48:	f005 fe34 	bl	c0de99b4 <pic>
c0de3d4c:	4601      	mov	r1, r0
c0de3d4e:	4638      	mov	r0, r7
c0de3d50:	f800 1f23 	strb.w	r1, [r0, #35]!
c0de3d54:	0e0a      	lsrs	r2, r1, #24
c0de3d56:	70c2      	strb	r2, [r0, #3]
c0de3d58:	0c0a      	lsrs	r2, r1, #16
c0de3d5a:	7082      	strb	r2, [r0, #2]
c0de3d5c:	0a08      	lsrs	r0, r1, #8
c0de3d5e:	f887 0024 	strb.w	r0, [r7, #36]	@ 0x24
c0de3d62:	2005      	movs	r0, #5
        textArea->wrapping      = true;
c0de3d64:	f897 2021 	ldrb.w	r2, [r7, #33]	@ 0x21
        textArea->textAlignment = CENTER;
c0de3d68:	7778      	strb	r0, [r7, #29]
c0de3d6a:	200b      	movs	r0, #11
        textArea->fontId        = SMALL_REGULAR_FONT;
c0de3d6c:	77f8      	strb	r0, [r7, #31]
        textArea->wrapping      = true;
c0de3d6e:	f042 0001 	orr.w	r0, r2, #1
c0de3d72:	f887 0021 	strb.w	r0, [r7, #33]	@ 0x21
c0de3d76:	2001      	movs	r0, #1
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de3d78:	7178      	strb	r0, [r7, #5]
c0de3d7a:	20a0      	movs	r0, #160	@ 0xa0
c0de3d7c:	7138      	strb	r0, [r7, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3d7e:	200b      	movs	r0, #11
c0de3d80:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de3d84:	2301      	movs	r3, #1
c0de3d86:	f004 ff07 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de3d8a:	71b8      	strb	r0, [r7, #6]
        if (container->nbChildren > 0) {
c0de3d8c:	f89b 1021 	ldrb.w	r1, [fp, #33]	@ 0x21
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3d90:	0a02      	lsrs	r2, r0, #8
c0de3d92:	71fa      	strb	r2, [r7, #7]
        if (container->nbChildren > 0) {
c0de3d94:	b329      	cbz	r1, c0de3de2 <addContentCenter+0x464>
            textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de3d96:	465a      	mov	r2, fp
c0de3d98:	f812 3f1c 	ldrb.w	r3, [r2, #28]!
c0de3d9c:	7856      	ldrb	r6, [r2, #1]
c0de3d9e:	7895      	ldrb	r5, [r2, #2]
c0de3da0:	78d2      	ldrb	r2, [r2, #3]
c0de3da2:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de3da6:	ea45 2202 	orr.w	r2, r5, r2, lsl #8
c0de3daa:	ea43 4202 	orr.w	r2, r3, r2, lsl #16
c0de3dae:	eb02 0281 	add.w	r2, r2, r1, lsl #2
c0de3db2:	f852 3c04 	ldr.w	r3, [r2, #-4]
c0de3db6:	463e      	mov	r6, r7
c0de3db8:	f806 3f10 	strb.w	r3, [r6, #16]!
c0de3dbc:	0e1d      	lsrs	r5, r3, #24
c0de3dbe:	70f5      	strb	r5, [r6, #3]
c0de3dc0:	0c1d      	lsrs	r5, r3, #16
c0de3dc2:	0a1b      	lsrs	r3, r3, #8
c0de3dc4:	70b5      	strb	r5, [r6, #2]
c0de3dc6:	7073      	strb	r3, [r6, #1]
            if (container->children[container->nbChildren - 1]->type == TEXT_AREA) {
c0de3dc8:	f852 2c04 	ldr.w	r2, [r2, #-4]
c0de3dcc:	2308      	movs	r3, #8
c0de3dce:	7a92      	ldrb	r2, [r2, #10]
            textArea->obj.alignment = BOTTOM_MIDDLE;
c0de3dd0:	f806 3c05 	strb.w	r3, [r6, #-5]
            if (container->children[container->nbChildren - 1]->type == TEXT_AREA) {
c0de3dd4:	2a04      	cmp	r2, #4
c0de3dd6:	d107      	bne.n	c0de3de8 <addContentCenter+0x46a>
c0de3dd8:	2200      	movs	r2, #0
                textArea->obj.alignmentMarginY = TITLE_DESC_MARGIN;
c0de3dda:	75fa      	strb	r2, [r7, #23]
c0de3ddc:	2210      	movs	r2, #16
c0de3dde:	75ba      	strb	r2, [r7, #22]
c0de3de0:	e008      	b.n	c0de3df4 <addContentCenter+0x476>
c0de3de2:	2202      	movs	r2, #2
            textArea->obj.alignment = TOP_MIDDLE;
c0de3de4:	72fa      	strb	r2, [r7, #11]
c0de3de6:	e005      	b.n	c0de3df4 <addContentCenter+0x476>
                textArea->obj.alignmentMarginY = ICON_TITLE_MARGIN + info->iconHug;
c0de3de8:	f8b8 2020 	ldrh.w	r2, [r8, #32]
c0de3dec:	3218      	adds	r2, #24
c0de3dee:	75ba      	strb	r2, [r7, #22]
c0de3df0:	0a12      	lsrs	r2, r2, #8
c0de3df2:	75fa      	strb	r2, [r7, #23]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de3df4:	7dba      	ldrb	r2, [r7, #22]
c0de3df6:	7dfb      	ldrb	r3, [r7, #23]
c0de3df8:	4420      	add	r0, r4
c0de3dfa:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3dfe:	465b      	mov	r3, fp
c0de3e00:	f813 6f1c 	ldrb.w	r6, [r3, #28]!
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de3e04:	eb00 0c02 	add.w	ip, r0, r2
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3e08:	7858      	ldrb	r0, [r3, #1]
c0de3e0a:	789a      	ldrb	r2, [r3, #2]
c0de3e0c:	78dd      	ldrb	r5, [r3, #3]
c0de3e0e:	ea46 2000 	orr.w	r0, r6, r0, lsl #8
c0de3e12:	ea42 2205 	orr.w	r2, r2, r5, lsl #8
c0de3e16:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de3e1a:	f840 7021 	str.w	r7, [r0, r1, lsl #2]
        container->nbChildren++;
c0de3e1e:	1c48      	adds	r0, r1, #1
c0de3e20:	7158      	strb	r0, [r3, #5]
    if (info->subText != NULL) {
c0de3e22:	f8d8 001c 	ldr.w	r0, [r8, #28]
c0de3e26:	2800      	cmp	r0, #0
c0de3e28:	d07b      	beq.n	c0de3f22 <addContentCenter+0x5a4>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3e2a:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de3e2e:	f8cd c000 	str.w	ip, [sp]
c0de3e32:	08c1      	lsrs	r1, r0, #3
c0de3e34:	2004      	movs	r0, #4
c0de3e36:	f004 fe96 	bl	c0de8b66 <nbgl_objPoolGet>
c0de3e3a:	4604      	mov	r4, r0
        textArea->text          = PIC(info->subText);
c0de3e3c:	f8d8 001c 	ldr.w	r0, [r8, #28]
c0de3e40:	2501      	movs	r5, #1
        textArea->textColor     = LIGHT_TEXT_COLOR;
c0de3e42:	7725      	strb	r5, [r4, #28]
        textArea->text          = PIC(info->subText);
c0de3e44:	f005 fdb6 	bl	c0de99b4 <pic>
c0de3e48:	4601      	mov	r1, r0
c0de3e4a:	4620      	mov	r0, r4
c0de3e4c:	f800 1f23 	strb.w	r1, [r0, #35]!
c0de3e50:	0e0a      	lsrs	r2, r1, #24
c0de3e52:	70c2      	strb	r2, [r0, #3]
c0de3e54:	0c0a      	lsrs	r2, r1, #16
c0de3e56:	7082      	strb	r2, [r0, #2]
c0de3e58:	0a08      	lsrs	r0, r1, #8
c0de3e5a:	f884 0024 	strb.w	r0, [r4, #36]	@ 0x24
c0de3e5e:	2005      	movs	r0, #5
        textArea->wrapping      = true;
c0de3e60:	f894 2021 	ldrb.w	r2, [r4, #33]	@ 0x21
        textArea->textAlignment = CENTER;
c0de3e64:	7760      	strb	r0, [r4, #29]
c0de3e66:	200b      	movs	r0, #11
        textArea->fontId        = SMALL_REGULAR_FONT;
c0de3e68:	77e0      	strb	r0, [r4, #31]
        textArea->wrapping      = true;
c0de3e6a:	f042 0001 	orr.w	r0, r2, #1
c0de3e6e:	f884 0021 	strb.w	r0, [r4, #33]	@ 0x21
c0de3e72:	20a0      	movs	r0, #160	@ 0xa0
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de3e74:	7120      	strb	r0, [r4, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3e76:	200b      	movs	r0, #11
c0de3e78:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de3e7c:	2301      	movs	r3, #1
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de3e7e:	7165      	strb	r5, [r4, #5]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3e80:	f004 fe8a 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
        textArea->obj.area.height += 2 * 8;
c0de3e84:	f100 0110 	add.w	r1, r0, #16
c0de3e88:	71a1      	strb	r1, [r4, #6]
        if (container->nbChildren > 0) {
c0de3e8a:	f89b 0021 	ldrb.w	r0, [fp, #33]	@ 0x21
        textArea->obj.area.height += 2 * 8;
c0de3e8e:	0a0a      	lsrs	r2, r1, #8
c0de3e90:	71e2      	strb	r2, [r4, #7]
        if (container->nbChildren > 0) {
c0de3e92:	b360      	cbz	r0, c0de3eee <addContentCenter+0x570>
            textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de3e94:	465a      	mov	r2, fp
c0de3e96:	f812 3f1c 	ldrb.w	r3, [r2, #28]!
c0de3e9a:	4627      	mov	r7, r4
c0de3e9c:	7856      	ldrb	r6, [r2, #1]
c0de3e9e:	7895      	ldrb	r5, [r2, #2]
c0de3ea0:	78d2      	ldrb	r2, [r2, #3]
c0de3ea2:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de3ea6:	ea45 2202 	orr.w	r2, r5, r2, lsl #8
c0de3eaa:	ea43 4202 	orr.w	r2, r3, r2, lsl #16
c0de3eae:	eb02 0280 	add.w	r2, r2, r0, lsl #2
c0de3eb2:	f852 3c04 	ldr.w	r3, [r2, #-4]
c0de3eb6:	f807 3f10 	strb.w	r3, [r7, #16]!
c0de3eba:	0e1e      	lsrs	r6, r3, #24
c0de3ebc:	70fe      	strb	r6, [r7, #3]
c0de3ebe:	0c1e      	lsrs	r6, r3, #16
c0de3ec0:	0a1b      	lsrs	r3, r3, #8
c0de3ec2:	707b      	strb	r3, [r7, #1]
c0de3ec4:	2310      	movs	r3, #16
c0de3ec6:	70be      	strb	r6, [r7, #2]
            textArea->obj.alignmentMarginY = 16;
c0de3ec8:	71bb      	strb	r3, [r7, #6]
            if (container->children[container->nbChildren - 1]->type == IMAGE) {
c0de3eca:	f852 2c04 	ldr.w	r2, [r2, #-4]
c0de3ece:	2608      	movs	r6, #8
c0de3ed0:	7a92      	ldrb	r2, [r2, #10]
c0de3ed2:	2300      	movs	r3, #0
            textArea->obj.alignment = BOTTOM_MIDDLE;
c0de3ed4:	f807 6c05 	strb.w	r6, [r7, #-5]
            textArea->obj.alignmentMarginY = 16;
c0de3ed8:	71fb      	strb	r3, [r7, #7]
c0de3eda:	9f00      	ldr	r7, [sp, #0]
            if (container->children[container->nbChildren - 1]->type == IMAGE) {
c0de3edc:	2a02      	cmp	r2, #2
c0de3ede:	d109      	bne.n	c0de3ef4 <addContentCenter+0x576>
                textArea->obj.alignmentMarginY += info->iconHug;
c0de3ee0:	f8b8 2020 	ldrh.w	r2, [r8, #32]
c0de3ee4:	3210      	adds	r2, #16
c0de3ee6:	75a2      	strb	r2, [r4, #22]
c0de3ee8:	0a12      	lsrs	r2, r2, #8
c0de3eea:	75e2      	strb	r2, [r4, #23]
c0de3eec:	e002      	b.n	c0de3ef4 <addContentCenter+0x576>
c0de3eee:	9f00      	ldr	r7, [sp, #0]
c0de3ef0:	2202      	movs	r2, #2
            textArea->obj.alignment = TOP_MIDDLE;
c0de3ef2:	72e2      	strb	r2, [r4, #11]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de3ef4:	7da2      	ldrb	r2, [r4, #22]
c0de3ef6:	7de3      	ldrb	r3, [r4, #23]
c0de3ef8:	4439      	add	r1, r7
c0de3efa:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3efe:	465b      	mov	r3, fp
c0de3f00:	f813 7f1c 	ldrb.w	r7, [r3, #28]!
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de3f04:	eb01 0c02 	add.w	ip, r1, r2
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3f08:	7859      	ldrb	r1, [r3, #1]
c0de3f0a:	789a      	ldrb	r2, [r3, #2]
c0de3f0c:	78de      	ldrb	r6, [r3, #3]
c0de3f0e:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de3f12:	ea42 2206 	orr.w	r2, r2, r6, lsl #8
c0de3f16:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de3f1a:	f841 4020 	str.w	r4, [r1, r0, lsl #2]
        container->nbChildren++;
c0de3f1e:	3001      	adds	r0, #1
c0de3f20:	7158      	strb	r0, [r3, #5]
c0de3f22:	2000      	movs	r0, #0
    container->layout          = VERTICAL;
c0de3f24:	f88b 0020 	strb.w	r0, [fp, #32]
c0de3f28:	2005      	movs	r0, #5
    container->obj.alignment   = CENTER;
c0de3f2a:	f88b 000b 	strb.w	r0, [fp, #11]
c0de3f2e:	20a0      	movs	r0, #160	@ 0xa0
    container->obj.area.width  = AVAILABLE_WIDTH;
c0de3f30:	f88b 0004 	strb.w	r0, [fp, #4]
    container->obj.area.height = fullHeight;
c0de3f34:	f88b c006 	strb.w	ip, [fp, #6]
    if (info->padding) {
c0de3f38:	f898 1022 	ldrb.w	r1, [r8, #34]	@ 0x22
c0de3f3c:	2001      	movs	r0, #1
    container->obj.area.width  = AVAILABLE_WIDTH;
c0de3f3e:	f88b 0005 	strb.w	r0, [fp, #5]
    container->obj.area.height = fullHeight;
c0de3f42:	ea4f 201c 	mov.w	r0, ip, lsr #8
c0de3f46:	f88b 0007 	strb.w	r0, [fp, #7]
    if (info->padding) {
c0de3f4a:	b131      	cbz	r1, c0de3f5a <addContentCenter+0x5dc>
        container->obj.area.height += 40;
c0de3f4c:	f10c 0028 	add.w	r0, ip, #40	@ 0x28
c0de3f50:	f88b 0006 	strb.w	r0, [fp, #6]
c0de3f54:	0a00      	lsrs	r0, r0, #8
c0de3f56:	f88b 0007 	strb.w	r0, [fp, #7]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de3f5a:	f8da 00a0 	ldr.w	r0, [sl, #160]	@ 0xa0
    layout->container->children[layout->container->nbChildren] = obj;
c0de3f5e:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
c0de3f62:	7842      	ldrb	r2, [r0, #1]
c0de3f64:	7883      	ldrb	r3, [r0, #2]
c0de3f66:	78c7      	ldrb	r7, [r0, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de3f68:	7940      	ldrb	r0, [r0, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3f6a:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de3f6e:	ea43 2207 	orr.w	r2, r3, r7, lsl #8
c0de3f72:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de3f76:	f841 b020 	str.w	fp, [r1, r0, lsl #2]
    layout->container->nbChildren++;
c0de3f7a:	f8da 10a0 	ldr.w	r1, [sl, #160]	@ 0xa0
c0de3f7e:	f891 0021 	ldrb.w	r0, [r1, #33]	@ 0x21
c0de3f82:	1c42      	adds	r2, r0, #1
    return container;
c0de3f84:	4658      	mov	r0, fp
    layout->container->nbChildren++;
c0de3f86:	f881 2021 	strb.w	r2, [r1, #33]	@ 0x21
    return container;
c0de3f8a:	b004      	add	sp, #16
c0de3f8c:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de3f90 <nbgl_layoutAddContentCenter>:
    if (layout == NULL) {
c0de3f90:	2800      	cmp	r0, #0
c0de3f92:	bf04      	itt	eq
c0de3f94:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
}
c0de3f98:	4770      	bxeq	lr
c0de3f9a:	b580      	push	{r7, lr}
    container = addContentCenter(layoutInt, info);
c0de3f9c:	f7ff fcef 	bl	c0de397e <addContentCenter>
    return container->obj.area.height;
c0de3fa0:	7981      	ldrb	r1, [r0, #6]
c0de3fa2:	79c0      	ldrb	r0, [r0, #7]
c0de3fa4:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de3fa8:	bd80      	pop	{r7, pc}

c0de3faa <nbgl_layoutAddQRCode>:
    if (layout == NULL) {
c0de3faa:	2800      	cmp	r0, #0
c0de3fac:	bf04      	itt	eq
c0de3fae:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
}
c0de3fb2:	4770      	bxeq	lr
c0de3fb4:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de3fb8:	b082      	sub	sp, #8
c0de3fba:	4680      	mov	r8, r0
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de3fbc:	f890 00ad 	ldrb.w	r0, [r0, #173]	@ 0xad
c0de3fc0:	468a      	mov	sl, r1
c0de3fc2:	08c1      	lsrs	r1, r0, #3
c0de3fc4:	2001      	movs	r0, #1
c0de3fc6:	f004 fdce 	bl	c0de8b66 <nbgl_objPoolGet>
    container->children   = nbgl_containerPoolGet(3, layoutInt->layer);
c0de3fca:	f898 10ad 	ldrb.w	r1, [r8, #173]	@ 0xad
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de3fce:	4605      	mov	r5, r0
    container->children   = nbgl_containerPoolGet(3, layoutInt->layer);
c0de3fd0:	08c9      	lsrs	r1, r1, #3
c0de3fd2:	2003      	movs	r0, #3
c0de3fd4:	f004 fdcc 	bl	c0de8b70 <nbgl_containerPoolGet>
c0de3fd8:	462c      	mov	r4, r5
c0de3fda:	f804 0f1c 	strb.w	r0, [r4, #28]!
c0de3fde:	0e01      	lsrs	r1, r0, #24
c0de3fe0:	70e1      	strb	r1, [r4, #3]
c0de3fe2:	0c01      	lsrs	r1, r0, #16
c0de3fe4:	0a00      	lsrs	r0, r0, #8
c0de3fe6:	2600      	movs	r6, #0
c0de3fe8:	70a1      	strb	r1, [r4, #2]
c0de3fea:	7768      	strb	r0, [r5, #29]
    container->nbChildren = 0;
c0de3fec:	f885 6021 	strb.w	r6, [r5, #33]	@ 0x21
    qrcode = (nbgl_qrcode_t *) nbgl_objPoolGet(QR_CODE, layoutInt->layer);
c0de3ff0:	f898 00ad 	ldrb.w	r0, [r8, #173]	@ 0xad
c0de3ff4:	08c1      	lsrs	r1, r0, #3
c0de3ff6:	200a      	movs	r0, #10
c0de3ff8:	f004 fdb5 	bl	c0de8b66 <nbgl_objPoolGet>
    if (strlen(PIC(info->url)) > 62) {
c0de3ffc:	f8da 1000 	ldr.w	r1, [sl]
    qrcode = (nbgl_qrcode_t *) nbgl_objPoolGet(QR_CODE, layoutInt->layer);
c0de4000:	4683      	mov	fp, r0
    if (strlen(PIC(info->url)) > 62) {
c0de4002:	4608      	mov	r0, r1
c0de4004:	f005 fcd6 	bl	c0de99b4 <pic>
c0de4008:	f005 ff3a 	bl	c0de9e80 <strlen>
c0de400c:	283e      	cmp	r0, #62	@ 0x3e
c0de400e:	f04f 0000 	mov.w	r0, #0
c0de4012:	bf88      	it	hi
c0de4014:	2001      	movhi	r0, #1
c0de4016:	f88b 0021 	strb.w	r0, [fp, #33]	@ 0x21
c0de401a:	f44f 7084 	mov.w	r0, #264	@ 0x108
    qrcode->obj.area.height = qrcode->obj.area.width;
c0de401e:	465f      	mov	r7, fp
    qrcode->foregroundColor = BLACK;
c0de4020:	f88b 6020 	strb.w	r6, [fp, #32]
        = (qrcode->version == QRCODE_V4) ? (QR_V4_NB_PIX_SIZE * 8) : (QR_V10_NB_PIX_SIZE * 4);
c0de4024:	bf88      	it	hi
c0de4026:	20e4      	movhi	r0, #228	@ 0xe4
c0de4028:	f88b 0004 	strb.w	r0, [fp, #4]
    qrcode->obj.area.height = qrcode->obj.area.width;
c0de402c:	f807 0f06 	strb.w	r0, [r7, #6]!
        = (qrcode->version == QRCODE_V4) ? (QR_V4_NB_PIX_SIZE * 8) : (QR_V10_NB_PIX_SIZE * 4);
c0de4030:	0a01      	lsrs	r1, r0, #8
    qrcode->text            = PIC(info->url);
c0de4032:	f8da 0000 	ldr.w	r0, [sl]
        = (qrcode->version == QRCODE_V4) ? (QR_V4_NB_PIX_SIZE * 8) : (QR_V10_NB_PIX_SIZE * 4);
c0de4036:	f88b 1005 	strb.w	r1, [fp, #5]
    qrcode->obj.area.height = qrcode->obj.area.width;
c0de403a:	7079      	strb	r1, [r7, #1]
    qrcode->text            = PIC(info->url);
c0de403c:	f005 fcba 	bl	c0de99b4 <pic>
c0de4040:	4659      	mov	r1, fp
c0de4042:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de4046:	0e02      	lsrs	r2, r0, #24
c0de4048:	70ca      	strb	r2, [r1, #3]
c0de404a:	0c02      	lsrs	r2, r0, #16
c0de404c:	708a      	strb	r2, [r1, #2]
c0de404e:	0a00      	lsrs	r0, r0, #8
    fullHeight += qrcode->obj.area.height;
c0de4050:	7839      	ldrb	r1, [r7, #0]
c0de4052:	787a      	ldrb	r2, [r7, #1]
    qrcode->text            = PIC(info->url);
c0de4054:	f88b 001d 	strb.w	r0, [fp, #29]
c0de4058:	2002      	movs	r0, #2
    qrcode->obj.area.bpp    = NBGL_BPP_1;
c0de405a:	f88b 6009 	strb.w	r6, [fp, #9]
    qrcode->obj.alignment   = TOP_MIDDLE;
c0de405e:	f88b 000b 	strb.w	r0, [fp, #11]
    fullHeight += qrcode->obj.area.height;
c0de4062:	ea41 2602 	orr.w	r6, r1, r2, lsl #8
    container->children[container->nbChildren] = (nbgl_obj_t *) qrcode;
c0de4066:	7820      	ldrb	r0, [r4, #0]
c0de4068:	78a1      	ldrb	r1, [r4, #2]
c0de406a:	78e2      	ldrb	r2, [r4, #3]
c0de406c:	7f6b      	ldrb	r3, [r5, #29]
c0de406e:	f895 7021 	ldrb.w	r7, [r5, #33]	@ 0x21
c0de4072:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de4076:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de407a:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de407e:	f840 b027 	str.w	fp, [r0, r7, lsl #2]
    if (info->text1 != NULL) {
c0de4082:	f8da 0004 	ldr.w	r0, [sl, #4]
    container->nbChildren++;
c0de4086:	1c79      	adds	r1, r7, #1
    if (info->text1 != NULL) {
c0de4088:	2800      	cmp	r0, #0
    container->nbChildren++;
c0de408a:	f885 1021 	strb.w	r1, [r5, #33]	@ 0x21
    if (info->text1 != NULL) {
c0de408e:	d05b      	beq.n	c0de4148 <nbgl_layoutAddQRCode+0x19e>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de4090:	f898 00ad 	ldrb.w	r0, [r8, #173]	@ 0xad
c0de4094:	9601      	str	r6, [sp, #4]
c0de4096:	08c1      	lsrs	r1, r0, #3
c0de4098:	2004      	movs	r0, #4
c0de409a:	f004 fd64 	bl	c0de8b66 <nbgl_objPoolGet>
c0de409e:	4604      	mov	r4, r0
        textArea->text          = PIC(info->text1);
c0de40a0:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de40a4:	2100      	movs	r1, #0
        textArea->textColor     = BLACK;
c0de40a6:	7721      	strb	r1, [r4, #28]
        textArea->text          = PIC(info->text1);
c0de40a8:	f005 fc84 	bl	c0de99b4 <pic>
c0de40ac:	4601      	mov	r1, r0
c0de40ae:	4620      	mov	r0, r4
c0de40b0:	f800 1f23 	strb.w	r1, [r0, #35]!
c0de40b4:	0e0a      	lsrs	r2, r1, #24
c0de40b6:	70c2      	strb	r2, [r0, #3]
c0de40b8:	0c0a      	lsrs	r2, r1, #16
c0de40ba:	7082      	strb	r2, [r0, #2]
c0de40bc:	0a08      	lsrs	r0, r1, #8
c0de40be:	f884 0024 	strb.w	r0, [r4, #36]	@ 0x24
c0de40c2:	2005      	movs	r0, #5
        textArea->fontId   = (info->largeText1 == true) ? LARGE_MEDIUM_FONT : SMALL_REGULAR_FONT;
c0de40c4:	f89a 200f 	ldrb.w	r2, [sl, #15]
        textArea->textAlignment = CENTER;
c0de40c8:	7760      	strb	r0, [r4, #29]
c0de40ca:	200d      	movs	r0, #13
        textArea->fontId   = (info->largeText1 == true) ? LARGE_MEDIUM_FONT : SMALL_REGULAR_FONT;
c0de40cc:	2a00      	cmp	r2, #0
c0de40ce:	bf08      	it	eq
c0de40d0:	200b      	moveq	r0, #11
        textArea->wrapping = true;
c0de40d2:	f894 2021 	ldrb.w	r2, [r4, #33]	@ 0x21
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de40d6:	2301      	movs	r3, #1
        textArea->wrapping = true;
c0de40d8:	f042 0201 	orr.w	r2, r2, #1
c0de40dc:	f884 2021 	strb.w	r2, [r4, #33]	@ 0x21
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de40e0:	2201      	movs	r2, #1
c0de40e2:	7162      	strb	r2, [r4, #5]
c0de40e4:	22a0      	movs	r2, #160	@ 0xa0
c0de40e6:	7122      	strb	r2, [r4, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de40e8:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
        textArea->fontId   = (info->largeText1 == true) ? LARGE_MEDIUM_FONT : SMALL_REGULAR_FONT;
c0de40ec:	77e0      	strb	r0, [r4, #31]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de40ee:	f004 fd53 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de40f2:	0a01      	lsrs	r1, r0, #8
c0de40f4:	71a0      	strb	r0, [r4, #6]
c0de40f6:	71e1      	strb	r1, [r4, #7]
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de40f8:	4629      	mov	r1, r5
c0de40fa:	f811 cf1c 	ldrb.w	ip, [r1, #28]!
c0de40fe:	2208      	movs	r2, #8
        textArea->obj.alignment = BOTTOM_MIDDLE;
c0de4100:	72e2      	strb	r2, [r4, #11]
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de4102:	784a      	ldrb	r2, [r1, #1]
c0de4104:	788f      	ldrb	r7, [r1, #2]
c0de4106:	78ce      	ldrb	r6, [r1, #3]
c0de4108:	794b      	ldrb	r3, [r1, #5]
c0de410a:	ea4c 2202 	orr.w	r2, ip, r2, lsl #8
c0de410e:	ea47 2706 	orr.w	r7, r7, r6, lsl #8
c0de4112:	ea42 4c07 	orr.w	ip, r2, r7, lsl #16
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de4116:	eb0c 0783 	add.w	r7, ip, r3, lsl #2
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de411a:	f857 7c04 	ldr.w	r7, [r7, #-4]
c0de411e:	4626      	mov	r6, r4
c0de4120:	f806 7f10 	strb.w	r7, [r6, #16]!
c0de4124:	0e3a      	lsrs	r2, r7, #24
c0de4126:	70f2      	strb	r2, [r6, #3]
c0de4128:	0c3a      	lsrs	r2, r7, #16
c0de412a:	70b2      	strb	r2, [r6, #2]
c0de412c:	0a3a      	lsrs	r2, r7, #8
c0de412e:	7462      	strb	r2, [r4, #17]
        textArea->obj.alignmentMarginY = QR_PRE_TEXT_MARGIN;
c0de4130:	2200      	movs	r2, #0
c0de4132:	75e2      	strb	r2, [r4, #23]
c0de4134:	2218      	movs	r2, #24
c0de4136:	75a2      	strb	r2, [r4, #22]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de4138:	9a01      	ldr	r2, [sp, #4]
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de413a:	f84c 4023 	str.w	r4, [ip, r3, lsl #2]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de413e:	4410      	add	r0, r2
c0de4140:	f100 0618 	add.w	r6, r0, #24
        container->nbChildren++;
c0de4144:	1c58      	adds	r0, r3, #1
c0de4146:	7148      	strb	r0, [r1, #5]
    if (info->text2 != NULL) {
c0de4148:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de414c:	2800      	cmp	r0, #0
c0de414e:	d05d      	beq.n	c0de420c <nbgl_layoutAddQRCode+0x262>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de4150:	f898 00ad 	ldrb.w	r0, [r8, #173]	@ 0xad
c0de4154:	9601      	str	r6, [sp, #4]
c0de4156:	08c1      	lsrs	r1, r0, #3
c0de4158:	2004      	movs	r0, #4
c0de415a:	f004 fd04 	bl	c0de8b66 <nbgl_objPoolGet>
c0de415e:	4604      	mov	r4, r0
        textArea->text          = PIC(info->text2);
c0de4160:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de4164:	2601      	movs	r6, #1
        textArea->textColor     = LIGHT_TEXT_COLOR;
c0de4166:	7726      	strb	r6, [r4, #28]
        textArea->text          = PIC(info->text2);
c0de4168:	f005 fc24 	bl	c0de99b4 <pic>
c0de416c:	4601      	mov	r1, r0
c0de416e:	4620      	mov	r0, r4
c0de4170:	f800 1f23 	strb.w	r1, [r0, #35]!
c0de4174:	0e0a      	lsrs	r2, r1, #24
c0de4176:	70c2      	strb	r2, [r0, #3]
c0de4178:	0c0a      	lsrs	r2, r1, #16
c0de417a:	7082      	strb	r2, [r0, #2]
c0de417c:	0a08      	lsrs	r0, r1, #8
c0de417e:	f884 0024 	strb.w	r0, [r4, #36]	@ 0x24
c0de4182:	2005      	movs	r0, #5
        textArea->wrapping      = true;
c0de4184:	f894 2021 	ldrb.w	r2, [r4, #33]	@ 0x21
        textArea->textAlignment = CENTER;
c0de4188:	7760      	strb	r0, [r4, #29]
c0de418a:	200b      	movs	r0, #11
        textArea->fontId        = SMALL_REGULAR_FONT;
c0de418c:	77e0      	strb	r0, [r4, #31]
        textArea->wrapping      = true;
c0de418e:	f042 0001 	orr.w	r0, r2, #1
c0de4192:	f884 0021 	strb.w	r0, [r4, #33]	@ 0x21
c0de4196:	20a0      	movs	r0, #160	@ 0xa0
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de4198:	7120      	strb	r0, [r4, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de419a:	200b      	movs	r0, #11
c0de419c:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de41a0:	2301      	movs	r3, #1
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de41a2:	7166      	strb	r6, [r4, #5]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de41a4:	f004 fcf8 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de41a8:	0a01      	lsrs	r1, r0, #8
c0de41aa:	71a0      	strb	r0, [r4, #6]
c0de41ac:	71e1      	strb	r1, [r4, #7]
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de41ae:	4629      	mov	r1, r5
c0de41b0:	f811 cf1c 	ldrb.w	ip, [r1, #28]!
c0de41b4:	2208      	movs	r2, #8
c0de41b6:	784f      	ldrb	r7, [r1, #1]
c0de41b8:	788e      	ldrb	r6, [r1, #2]
c0de41ba:	78cb      	ldrb	r3, [r1, #3]
        textArea->obj.alignment = BOTTOM_MIDDLE;
c0de41bc:	72e2      	strb	r2, [r4, #11]
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de41be:	794a      	ldrb	r2, [r1, #5]
c0de41c0:	ea4c 2707 	orr.w	r7, ip, r7, lsl #8
c0de41c4:	ea46 2303 	orr.w	r3, r6, r3, lsl #8
c0de41c8:	ea47 4c03 	orr.w	ip, r7, r3, lsl #16
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de41cc:	eb0c 0782 	add.w	r7, ip, r2, lsl #2
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de41d0:	f857 7c04 	ldr.w	r7, [r7, #-4]
c0de41d4:	4626      	mov	r6, r4
c0de41d6:	f806 7f10 	strb.w	r7, [r6, #16]!
c0de41da:	0e3b      	lsrs	r3, r7, #24
c0de41dc:	70f3      	strb	r3, [r6, #3]
c0de41de:	0c3b      	lsrs	r3, r7, #16
c0de41e0:	70b3      	strb	r3, [r6, #2]
c0de41e2:	0a3b      	lsrs	r3, r7, #8
c0de41e4:	7463      	strb	r3, [r4, #17]
        if (info->text1 != NULL) {
c0de41e6:	f8da 3004 	ldr.w	r3, [sl, #4]
c0de41ea:	271c      	movs	r7, #28
c0de41ec:	2b00      	cmp	r3, #0
c0de41ee:	f04f 0300 	mov.w	r3, #0
c0de41f2:	bf08      	it	eq
c0de41f4:	2720      	moveq	r7, #32
c0de41f6:	75e3      	strb	r3, [r4, #23]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY + 8;
c0de41f8:	9b01      	ldr	r3, [sp, #4]
c0de41fa:	75a7      	strb	r7, [r4, #22]
c0de41fc:	4418      	add	r0, r3
c0de41fe:	4438      	add	r0, r7
c0de4200:	f100 0608 	add.w	r6, r0, #8
        container->nbChildren++;
c0de4204:	1c50      	adds	r0, r2, #1
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de4206:	f84c 4022 	str.w	r4, [ip, r2, lsl #2]
        container->nbChildren++;
c0de420a:	7148      	strb	r0, [r1, #5]
    if ((fullHeight >= (layoutInt->container->obj.area.height - 16))
c0de420c:	f8d8 00a0 	ldr.w	r0, [r8, #160]	@ 0xa0
c0de4210:	b2b3      	uxth	r3, r6
c0de4212:	7981      	ldrb	r1, [r0, #6]
c0de4214:	79c2      	ldrb	r2, [r0, #7]
c0de4216:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de421a:	3910      	subs	r1, #16
        && (qrcode->version == QRCODE_V4)) {
c0de421c:	4299      	cmp	r1, r3
c0de421e:	dc10      	bgt.n	c0de4242 <nbgl_layoutAddQRCode+0x298>
c0de4220:	f89b 1021 	ldrb.w	r1, [fp, #33]	@ 0x21
    if ((fullHeight >= (layoutInt->container->obj.area.height - 16))
c0de4224:	b969      	cbnz	r1, c0de4242 <nbgl_layoutAddQRCode+0x298>
c0de4226:	2102      	movs	r1, #2
        qrcode->version = QRCODE_V4_SMALL;
c0de4228:	f88b 1021 	strb.w	r1, [fp, #33]	@ 0x21
c0de422c:	2100      	movs	r1, #0
c0de422e:	2284      	movs	r2, #132	@ 0x84
        fullHeight -= QR_V4_NB_PIX_SIZE * 4;
c0de4230:	3e84      	subs	r6, #132	@ 0x84
        qrcode->obj.area.width  = QR_V4_NB_PIX_SIZE * 4;
c0de4232:	f88b 1005 	strb.w	r1, [fp, #5]
c0de4236:	f88b 2004 	strb.w	r2, [fp, #4]
        qrcode->obj.area.height = qrcode->obj.area.width;
c0de423a:	f88b 1007 	strb.w	r1, [fp, #7]
c0de423e:	f88b 2006 	strb.w	r2, [fp, #6]
    container->obj.area.height = fullHeight;
c0de4242:	71ae      	strb	r6, [r5, #6]
    if (info->centered) {
c0de4244:	f89a 200e 	ldrb.w	r2, [sl, #14]
    container->obj.area.height = fullHeight;
c0de4248:	0a31      	lsrs	r1, r6, #8
c0de424a:	71e9      	strb	r1, [r5, #7]
c0de424c:	f04f 0100 	mov.w	r1, #0
    container->layout          = VERTICAL;
c0de4250:	f885 1020 	strb.w	r1, [r5, #32]
    if (info->centered) {
c0de4254:	b112      	cbz	r2, c0de425c <nbgl_layoutAddQRCode+0x2b2>
c0de4256:	2005      	movs	r0, #5
        container->obj.alignment = CENTER;
c0de4258:	72e8      	strb	r0, [r5, #11]
c0de425a:	e01b      	b.n	c0de4294 <nbgl_layoutAddQRCode+0x2ea>
            = layoutInt->container->children[layoutInt->container->nbChildren - 1];
c0de425c:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
c0de4260:	7842      	ldrb	r2, [r0, #1]
c0de4262:	7883      	ldrb	r3, [r0, #2]
c0de4264:	78c7      	ldrb	r7, [r0, #3]
c0de4266:	7940      	ldrb	r0, [r0, #5]
c0de4268:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de426c:	ea43 2207 	orr.w	r2, r3, r7, lsl #8
c0de4270:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de4274:	eb01 0080 	add.w	r0, r1, r0, lsl #2
c0de4278:	f850 0c04 	ldr.w	r0, [r0, #-4]
c0de427c:	4629      	mov	r1, r5
c0de427e:	f801 0f10 	strb.w	r0, [r1, #16]!
c0de4282:	2208      	movs	r2, #8
        container->obj.alignment = BOTTOM_MIDDLE;
c0de4284:	f801 2c05 	strb.w	r2, [r1, #-5]
            = layoutInt->container->children[layoutInt->container->nbChildren - 1];
c0de4288:	0e02      	lsrs	r2, r0, #24
c0de428a:	70ca      	strb	r2, [r1, #3]
c0de428c:	0c02      	lsrs	r2, r0, #16
c0de428e:	0a00      	lsrs	r0, r0, #8
c0de4290:	708a      	strb	r2, [r1, #2]
c0de4292:	7048      	strb	r0, [r1, #1]
    container->obj.alignmentMarginY = info->offsetY;
c0de4294:	f8ba 000c 	ldrh.w	r0, [sl, #12]
c0de4298:	21a0      	movs	r1, #160	@ 0xa0
c0de429a:	75a8      	strb	r0, [r5, #22]
    container->obj.area.width = AVAILABLE_WIDTH;
c0de429c:	7129      	strb	r1, [r5, #4]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de429e:	f8d8 10a0 	ldr.w	r1, [r8, #160]	@ 0xa0
    container->obj.alignmentMarginY = info->offsetY;
c0de42a2:	0a00      	lsrs	r0, r0, #8
    layout->container->children[layout->container->nbChildren] = obj;
c0de42a4:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
    container->obj.alignmentMarginY = info->offsetY;
c0de42a8:	75e8      	strb	r0, [r5, #23]
    layout->container->children[layout->container->nbChildren] = obj;
c0de42aa:	7848      	ldrb	r0, [r1, #1]
c0de42ac:	788b      	ldrb	r3, [r1, #2]
c0de42ae:	78cf      	ldrb	r7, [r1, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de42b0:	7949      	ldrb	r1, [r1, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de42b2:	ea42 2000 	orr.w	r0, r2, r0, lsl #8
c0de42b6:	ea43 2207 	orr.w	r2, r3, r7, lsl #8
c0de42ba:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de42be:	f840 5021 	str.w	r5, [r0, r1, lsl #2]
    layout->container->nbChildren++;
c0de42c2:	f8d8 00a0 	ldr.w	r0, [r8, #160]	@ 0xa0
c0de42c6:	2101      	movs	r1, #1
c0de42c8:	f890 2021 	ldrb.w	r2, [r0, #33]	@ 0x21
    container->obj.area.width = AVAILABLE_WIDTH;
c0de42cc:	7169      	strb	r1, [r5, #5]
    layout->container->nbChildren++;
c0de42ce:	1c51      	adds	r1, r2, #1
c0de42d0:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
    return fullHeight;
c0de42d4:	b2b0      	uxth	r0, r6
c0de42d6:	b002      	add	sp, #8
c0de42d8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de42dc <nbgl_layoutAddChoiceButtons>:
{
c0de42dc:	b580      	push	{r7, lr}
c0de42de:	b086      	sub	sp, #24
c0de42e0:	2206      	movs	r2, #6
    footerDesc.type                     = FOOTER_CHOICE_BUTTONS;
c0de42e2:	f8ad 2000 	strh.w	r2, [sp]
    footerDesc.choiceButtons.topText    = info->topText;
c0de42e6:	e9d1 c200 	ldrd	ip, r2, [r1]
    footerDesc.choiceButtons.topIcon    = info->topIcon;
c0de42ea:	688b      	ldr	r3, [r1, #8]
    footerDesc.choiceButtons.bottomText = info->bottomText;
c0de42ec:	9202      	str	r2, [sp, #8]
    footerDesc.choiceButtons.token      = info->token;
c0de42ee:	898a      	ldrh	r2, [r1, #12]
    footerDesc.choiceButtons.tuneId     = info->tuneId;
c0de42f0:	7b89      	ldrb	r1, [r1, #14]
    footerDesc.choiceButtons.token      = info->token;
c0de42f2:	f8ad 2010 	strh.w	r2, [sp, #16]
    footerDesc.choiceButtons.tuneId     = info->tuneId;
c0de42f6:	f88d 1012 	strb.w	r1, [sp, #18]
c0de42fa:	4669      	mov	r1, sp
    footerDesc.choiceButtons.topText    = info->topText;
c0de42fc:	f8cd c004 	str.w	ip, [sp, #4]
    footerDesc.choiceButtons.topIcon    = info->topIcon;
c0de4300:	9303      	str	r3, [sp, #12]
    return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de4302:	f7fd ffc4 	bl	c0de228e <nbgl_layoutAddExtendedFooter>
c0de4306:	b006      	add	sp, #24
c0de4308:	bd80      	pop	{r7, pc}

c0de430a <nbgl_layoutAddHorizontalButtons>:
{
c0de430a:	b580      	push	{r7, lr}
c0de430c:	b086      	sub	sp, #24
c0de430e:	2202      	movs	r2, #2
    nbgl_layoutUpFooter_t upFooterDesc = {.type = UP_FOOTER_HORIZONTAL_BUTTONS,
c0de4310:	f88d 2004 	strb.w	r2, [sp, #4]
                                          .horizontalButtons.leftIcon   = info->leftIcon,
c0de4314:	e9d1 2300 	ldrd	r2, r3, [r1]
c0de4318:	e9cd 2302 	strd	r2, r3, [sp, #8]
                                          .horizontalButtons.leftToken  = info->leftToken,
c0de431c:	890a      	ldrh	r2, [r1, #8]
                                          .horizontalButtons.tuneId     = info->tuneId};
c0de431e:	7a89      	ldrb	r1, [r1, #10]
                                          .horizontalButtons.leftIcon   = info->leftIcon,
c0de4320:	f8ad 2010 	strh.w	r2, [sp, #16]
c0de4324:	f88d 1012 	strb.w	r1, [sp, #18]
c0de4328:	a901      	add	r1, sp, #4
    return nbgl_layoutAddUpFooter(layout, &upFooterDesc);
c0de432a:	f7fd fab7 	bl	c0de189c <nbgl_layoutAddUpFooter>
c0de432e:	b006      	add	sp, #24
c0de4330:	bd80      	pop	{r7, pc}
	...

c0de4334 <nbgl_layoutAddTagValueList>:
{
c0de4334:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de4338:	b088      	sub	sp, #32
    if (layout == NULL) {
c0de433a:	2800      	cmp	r0, #0
c0de433c:	f000 8266 	beq.w	c0de480c <nbgl_layoutAddTagValueList+0x4d8>
c0de4340:	4605      	mov	r5, r0
    for (i = 0; i < list->nbPairs; i++) {
c0de4342:	7a08      	ldrb	r0, [r1, #8]
c0de4344:	468b      	mov	fp, r1
c0de4346:	2800      	cmp	r0, #0
c0de4348:	f04f 0000 	mov.w	r0, #0
c0de434c:	f000 8264 	beq.w	c0de4818 <nbgl_layoutAddTagValueList+0x4e4>
c0de4350:	f04f 0a00 	mov.w	sl, #0
c0de4354:	2400      	movs	r4, #0
c0de4356:	9502      	str	r5, [sp, #8]
c0de4358:	f8cd b01c 	str.w	fp, [sp, #28]
c0de435c:	e029      	b.n	c0de43b2 <nbgl_layoutAddTagValueList+0x7e>
c0de435e:	bf00      	nop
c0de4360:	2000      	movs	r0, #0
c0de4362:	f888 0016 	strb.w	r0, [r8, #22]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de4366:	f8d5 00a0 	ldr.w	r0, [r5, #160]	@ 0xa0
c0de436a:	f8dd b01c 	ldr.w	fp, [sp, #28]
    layout->container->children[layout->container->nbChildren] = obj;
c0de436e:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
    for (i = 0; i < list->nbPairs; i++) {
c0de4372:	3401      	adds	r4, #1
    layout->container->children[layout->container->nbChildren] = obj;
c0de4374:	7843      	ldrb	r3, [r0, #1]
c0de4376:	7887      	ldrb	r7, [r0, #2]
c0de4378:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de437c:	78c3      	ldrb	r3, [r0, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de437e:	7940      	ldrb	r0, [r0, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de4380:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de4384:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
c0de4388:	f841 8020 	str.w	r8, [r1, r0, lsl #2]
    layout->container->nbChildren++;
c0de438c:	f8d5 00a0 	ldr.w	r0, [r5, #160]	@ 0xa0
c0de4390:	2200      	movs	r2, #0
c0de4392:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
    for (i = 0; i < list->nbPairs; i++) {
c0de4396:	f10a 0a10 	add.w	sl, sl, #16
    layout->container->nbChildren++;
c0de439a:	3101      	adds	r1, #1
c0de439c:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
    for (i = 0; i < list->nbPairs; i++) {
c0de43a0:	f89b 0008 	ldrb.w	r0, [fp, #8]
c0de43a4:	f888 2017 	strb.w	r2, [r8, #23]
c0de43a8:	4284      	cmp	r4, r0
        container->obj.alignment = NO_ALIGNMENT;
c0de43aa:	f888 200b 	strb.w	r2, [r8, #11]
    for (i = 0; i < list->nbPairs; i++) {
c0de43ae:	f080 8232 	bcs.w	c0de4816 <nbgl_layoutAddTagValueList+0x4e2>
        if (list->pairs != NULL) {
c0de43b2:	f8db 0000 	ldr.w	r0, [fp]
c0de43b6:	9405      	str	r4, [sp, #20]
c0de43b8:	b110      	cbz	r0, c0de43c0 <nbgl_layoutAddTagValueList+0x8c>
        }
c0de43ba:	eb00 040a 	add.w	r4, r0, sl
c0de43be:	e007      	b.n	c0de43d0 <nbgl_layoutAddTagValueList+0x9c>
            pair = list->callback(list->startIndex + i);
c0de43c0:	f89b 0009 	ldrb.w	r0, [fp, #9]
c0de43c4:	f8db 1004 	ldr.w	r1, [fp, #4]
c0de43c8:	4420      	add	r0, r4
c0de43ca:	b2c0      	uxtb	r0, r0
c0de43cc:	4788      	blx	r1
c0de43ce:	4604      	mov	r4, r0
        container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de43d0:	f895 00ad 	ldrb.w	r0, [r5, #173]	@ 0xad
c0de43d4:	08c1      	lsrs	r1, r0, #3
c0de43d6:	2001      	movs	r0, #1
c0de43d8:	f004 fbc5 	bl	c0de8b66 <nbgl_objPoolGet>
        if (pair->valueIcon != NULL) {
c0de43dc:	68a1      	ldr	r1, [r4, #8]
        container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de43de:	4680      	mov	r8, r0
c0de43e0:	9406      	str	r4, [sp, #24]
        if (pair->valueIcon != NULL) {
c0de43e2:	f8cd a00c 	str.w	sl, [sp, #12]
c0de43e6:	b129      	cbz	r1, c0de43f4 <nbgl_layoutAddTagValueList+0xc0>
            if ((pair->aliasValue) && (pair->extension->aliasSubName)) {
c0de43e8:	7b20      	ldrb	r0, [r4, #12]
c0de43ea:	0740      	lsls	r0, r0, #29
c0de43ec:	d404      	bmi.n	c0de43f8 <nbgl_layoutAddTagValueList+0xc4>
c0de43ee:	2003      	movs	r0, #3
c0de43f0:	e009      	b.n	c0de4406 <nbgl_layoutAddTagValueList+0xd2>
c0de43f2:	bf00      	nop
c0de43f4:	2002      	movs	r0, #2
c0de43f6:	e006      	b.n	c0de4406 <nbgl_layoutAddTagValueList+0xd2>
c0de43f8:	68a0      	ldr	r0, [r4, #8]
c0de43fa:	6840      	ldr	r0, [r0, #4]
c0de43fc:	2800      	cmp	r0, #0
c0de43fe:	f04f 0004 	mov.w	r0, #4
c0de4402:	bf08      	it	eq
c0de4404:	2003      	moveq	r0, #3
        container->children = nbgl_containerPoolGet(nbChildren, layoutInt->layer);
c0de4406:	f895 10ad 	ldrb.w	r1, [r5, #173]	@ 0xad
c0de440a:	08c9      	lsrs	r1, r1, #3
c0de440c:	f004 fbb0 	bl	c0de8b70 <nbgl_containerPoolGet>
c0de4410:	4647      	mov	r7, r8
c0de4412:	f807 0f1c 	strb.w	r0, [r7, #28]!
c0de4416:	0e01      	lsrs	r1, r0, #24
c0de4418:	70f9      	strb	r1, [r7, #3]
c0de441a:	0c01      	lsrs	r1, r0, #16
c0de441c:	0a00      	lsrs	r0, r0, #8
c0de441e:	70b9      	strb	r1, [r7, #2]
c0de4420:	7078      	strb	r0, [r7, #1]
        itemTextArea  = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de4422:	f895 00ad 	ldrb.w	r0, [r5, #173]	@ 0xad
c0de4426:	08c1      	lsrs	r1, r0, #3
c0de4428:	2004      	movs	r0, #4
c0de442a:	f004 fb9c 	bl	c0de8b66 <nbgl_objPoolGet>
        valueTextArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de442e:	f895 10ad 	ldrb.w	r1, [r5, #173]	@ 0xad
        itemTextArea  = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de4432:	4605      	mov	r5, r0
        valueTextArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de4434:	08c9      	lsrs	r1, r1, #3
c0de4436:	2004      	movs	r0, #4
c0de4438:	f004 fb95 	bl	c0de8b66 <nbgl_objPoolGet>
c0de443c:	f8dd a018 	ldr.w	sl, [sp, #24]
c0de4440:	4606      	mov	r6, r0
        itemTextArea->text            = PIC(pair->item);
c0de4442:	f8da 0000 	ldr.w	r0, [sl]
c0de4446:	2401      	movs	r4, #1
        itemTextArea->textColor       = LIGHT_TEXT_COLOR;
c0de4448:	772c      	strb	r4, [r5, #28]
        itemTextArea->text            = PIC(pair->item);
c0de444a:	f005 fab3 	bl	c0de99b4 <pic>
c0de444e:	4601      	mov	r1, r0
c0de4450:	4628      	mov	r0, r5
c0de4452:	f800 1f23 	strb.w	r1, [r0, #35]!
c0de4456:	0e0a      	lsrs	r2, r1, #24
c0de4458:	70c2      	strb	r2, [r0, #3]
c0de445a:	0c0a      	lsrs	r2, r1, #16
c0de445c:	7082      	strb	r2, [r0, #2]
c0de445e:	0a08      	lsrs	r0, r1, #8
c0de4460:	f885 0024 	strb.w	r0, [r5, #36]	@ 0x24
c0de4464:	2004      	movs	r0, #4
        itemTextArea->textAlignment   = MID_LEFT;
c0de4466:	7768      	strb	r0, [r5, #29]
        itemTextArea->wrapping        = true;
c0de4468:	f895 0021 	ldrb.w	r0, [r5, #33]	@ 0x21
        itemTextArea->fontId          = SMALL_REGULAR_FONT;
c0de446c:	220b      	movs	r2, #11
        itemTextArea->wrapping        = true;
c0de446e:	f040 0001 	orr.w	r0, r0, #1
c0de4472:	f885 0021 	strb.w	r0, [r5, #33]	@ 0x21
        itemTextArea->obj.area.width  = AVAILABLE_WIDTH;
c0de4476:	20a0      	movs	r0, #160	@ 0xa0
        itemTextArea->fontId          = SMALL_REGULAR_FONT;
c0de4478:	77ea      	strb	r2, [r5, #31]
        itemTextArea->obj.area.width  = AVAILABLE_WIDTH;
c0de447a:	7128      	strb	r0, [r5, #4]
        itemTextArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de447c:	200b      	movs	r0, #11
c0de447e:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de4482:	2301      	movs	r3, #1
        itemTextArea->obj.area.width  = AVAILABLE_WIDTH;
c0de4484:	716c      	strb	r4, [r5, #5]
        itemTextArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de4486:	f004 fb87 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de448a:	71a8      	strb	r0, [r5, #6]
c0de448c:	9004      	str	r0, [sp, #16]
c0de448e:	0a00      	lsrs	r0, r0, #8
c0de4490:	71e8      	strb	r0, [r5, #7]
        container->children[container->nbChildren] = (nbgl_obj_t *) itemTextArea;
c0de4492:	7838      	ldrb	r0, [r7, #0]
c0de4494:	78b9      	ldrb	r1, [r7, #2]
c0de4496:	78fa      	ldrb	r2, [r7, #3]
c0de4498:	787b      	ldrb	r3, [r7, #1]
c0de449a:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de449e:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de44a2:	797a      	ldrb	r2, [r7, #5]
c0de44a4:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de44a8:	f840 5022 	str.w	r5, [r0, r2, lsl #2]
        container->nbChildren++;
c0de44ac:	1c50      	adds	r0, r2, #1
c0de44ae:	7178      	strb	r0, [r7, #5]
        valueTextArea->text          = PIC(pair->value);
c0de44b0:	f8da 0004 	ldr.w	r0, [sl, #4]
        valueTextArea->textColor     = BLACK;
c0de44b4:	2100      	movs	r1, #0
c0de44b6:	4654      	mov	r4, sl
c0de44b8:	7731      	strb	r1, [r6, #28]
        valueTextArea->text          = PIC(pair->value);
c0de44ba:	f005 fa7b 	bl	c0de99b4 <pic>
c0de44be:	4631      	mov	r1, r6
c0de44c0:	f801 0f23 	strb.w	r0, [r1, #35]!
c0de44c4:	0e02      	lsrs	r2, r0, #24
c0de44c6:	70ca      	strb	r2, [r1, #3]
c0de44c8:	0c02      	lsrs	r2, r0, #16
c0de44ca:	0a00      	lsrs	r0, r0, #8
c0de44cc:	708a      	strb	r2, [r1, #2]
c0de44ce:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
        if (list->smallCaseForValue) {
c0de44d2:	f89b 000d 	ldrb.w	r0, [fp, #13]
        valueTextArea->textAlignment = MID_LEFT;
c0de44d6:	2104      	movs	r1, #4
c0de44d8:	2800      	cmp	r0, #0
c0de44da:	f04f 000c 	mov.w	r0, #12
c0de44de:	7771      	strb	r1, [r6, #29]
c0de44e0:	bf08      	it	eq
c0de44e2:	200d      	moveq	r0, #13
c0de44e4:	77f0      	strb	r0, [r6, #31]
        if ((pair->aliasValue == 0) && (pair->valueIcon == NULL)) {
c0de44e6:	f89a 000c 	ldrb.w	r0, [sl, #12]
c0de44ea:	f246 3a65 	movw	sl, #25445	@ 0x6365
c0de44ee:	f2c0 0a00 	movt	sl, #0
c0de44f2:	f010 0004 	ands.w	r0, r0, #4
c0de44f6:	44fa      	add	sl, pc
c0de44f8:	d10e      	bne.n	c0de4518 <nbgl_layoutAddTagValueList+0x1e4>
c0de44fa:	68a1      	ldr	r1, [r4, #8]
c0de44fc:	2900      	cmp	r1, #0
c0de44fe:	f000 8180 	beq.w	c0de4802 <nbgl_layoutAddTagValueList+0x4ce>
c0de4502:	f246 3a51 	movw	sl, #25425	@ 0x6351
c0de4506:	f2c0 0a00 	movt	sl, #0
c0de450a:	44fa      	add	sl, pc
            if (pair->aliasValue) {
c0de450c:	b920      	cbnz	r0, c0de4518 <nbgl_layoutAddTagValueList+0x1e4>
                valueIcon = PIC(pair->valueIcon);
c0de450e:	68a0      	ldr	r0, [r4, #8]
c0de4510:	f005 fa50 	bl	c0de99b4 <pic>
c0de4514:	4682      	mov	sl, r0
c0de4516:	bf00      	nop
                = AVAILABLE_WIDTH - valueIcon->width - VALUE_ICON_INTERVALE;
c0de4518:	f89a 0000 	ldrb.w	r0, [sl]
c0de451c:	f89a 1001 	ldrb.w	r1, [sl, #1]
c0de4520:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de4524:	f5c0 72ca 	rsb	r2, r0, #404	@ 0x194
                                                      valueTextArea->text,
c0de4528:	4631      	mov	r1, r6
c0de452a:	f811 3f23 	ldrb.w	r3, [r1, #35]!
c0de452e:	0a10      	lsrs	r0, r2, #8
c0de4530:	f801 0c1e 	strb.w	r0, [r1, #-30]
c0de4534:	f801 2c1f 	strb.w	r2, [r1, #-31]
        uint16_t nbLines = nbgl_getTextNbLinesInWidth(valueTextArea->fontId,
c0de4538:	f811 0c04 	ldrb.w	r0, [r1, #-4]
                                                      valueTextArea->text,
c0de453c:	784f      	ldrb	r7, [r1, #1]
c0de453e:	788c      	ldrb	r4, [r1, #2]
c0de4540:	78c9      	ldrb	r1, [r1, #3]
c0de4542:	ea43 2707 	orr.w	r7, r3, r7, lsl #8
c0de4546:	ea44 2101 	orr.w	r1, r4, r1, lsl #8
                                                      list->wrapping);
c0de454a:	f89b 300e 	ldrb.w	r3, [fp, #14]
                                                      valueTextArea->text,
c0de454e:	ea47 4101 	orr.w	r1, r7, r1, lsl #16
        uint16_t nbLines = nbgl_getTextNbLinesInWidth(valueTextArea->fontId,
c0de4552:	b292      	uxth	r2, r2
c0de4554:	f004 fb25 	bl	c0de8ba2 <nbgl_getTextNbLinesInWidth>
        if ((list->nbMaxLinesForValue > 0) && (nbLines > list->nbMaxLinesForValue)) {
c0de4558:	f89b 100b 	ldrb.w	r1, [fp, #11]
        uint16_t nbLines = nbgl_getTextNbLinesInWidth(valueTextArea->fontId,
c0de455c:	4683      	mov	fp, r0
        if ((list->nbMaxLinesForValue > 0) && (nbLines > list->nbMaxLinesForValue)) {
c0de455e:	b179      	cbz	r1, c0de4580 <nbgl_layoutAddTagValueList+0x24c>
c0de4560:	9c07      	ldr	r4, [sp, #28]
c0de4562:	458b      	cmp	fp, r1
c0de4564:	d90d      	bls.n	c0de4582 <nbgl_layoutAddTagValueList+0x24e>
            valueTextArea->hideEndOfLastLine = list->hideEndOfLastLine;
c0de4566:	f896 0021 	ldrb.w	r0, [r6, #33]	@ 0x21
c0de456a:	7aa2      	ldrb	r2, [r4, #10]
c0de456c:	f000 00fd 	and.w	r0, r0, #253	@ 0xfd
c0de4570:	ea40 0042 	orr.w	r0, r0, r2, lsl #1
c0de4574:	468b      	mov	fp, r1
            valueTextArea->nbMaxLines        = list->nbMaxLinesForValue;
c0de4576:	f886 1022 	strb.w	r1, [r6, #34]	@ 0x22
            valueTextArea->hideEndOfLastLine = list->hideEndOfLastLine;
c0de457a:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
c0de457e:	e000      	b.n	c0de4582 <nbgl_layoutAddTagValueList+0x24e>
c0de4580:	9c07      	ldr	r4, [sp, #28]
        const nbgl_font_t *font                    = nbgl_getFont(valueTextArea->fontId);
c0de4582:	7ff0      	ldrb	r0, [r6, #31]
c0de4584:	f004 faf9 	bl	c0de8b7a <nbgl_getFont>
        valueTextArea->obj.alignmentMarginY        = TAG_VALUE_INTERVALE;
c0de4588:	2204      	movs	r2, #4
        valueTextArea->obj.area.height             = nbLines * font->line_height;
c0de458a:	79c0      	ldrb	r0, [r0, #7]
        valueTextArea->obj.alignmentMarginY        = TAG_VALUE_INTERVALE;
c0de458c:	75b2      	strb	r2, [r6, #22]
        valueTextArea->obj.alignTo                 = (nbgl_obj_t *) itemTextArea;
c0de458e:	0a2a      	lsrs	r2, r5, #8
c0de4590:	7472      	strb	r2, [r6, #17]
c0de4592:	4632      	mov	r2, r6
        valueTextArea->obj.area.height             = nbLines * font->line_height;
c0de4594:	fb0b f100 	mul.w	r1, fp, r0
        valueTextArea->obj.alignTo                 = (nbgl_obj_t *) itemTextArea;
c0de4598:	f802 5f10 	strb.w	r5, [r2, #16]!
c0de459c:	0c2f      	lsrs	r7, r5, #16
        valueTextArea->obj.area.height             = nbLines * font->line_height;
c0de459e:	71b1      	strb	r1, [r6, #6]
        valueTextArea->obj.alignTo                 = (nbgl_obj_t *) itemTextArea;
c0de45a0:	7097      	strb	r7, [r2, #2]
        valueTextArea->wrapping                    = list->wrapping;
c0de45a2:	f896 7021 	ldrb.w	r7, [r6, #33]	@ 0x21
        valueTextArea->obj.alignTo                 = (nbgl_obj_t *) itemTextArea;
c0de45a6:	0e2b      	lsrs	r3, r5, #24
        valueTextArea->wrapping                    = list->wrapping;
c0de45a8:	7ba5      	ldrb	r5, [r4, #14]
c0de45aa:	f007 07fe 	and.w	r7, r7, #254	@ 0xfe
c0de45ae:	432f      	orrs	r7, r5
c0de45b0:	f886 7021 	strb.w	r7, [r6, #33]	@ 0x21
        container->children[container->nbChildren] = (nbgl_obj_t *) valueTextArea;
c0de45b4:	4647      	mov	r7, r8
c0de45b6:	f817 5f1c 	ldrb.w	r5, [r7, #28]!
        valueTextArea->obj.alignTo                 = (nbgl_obj_t *) itemTextArea;
c0de45ba:	70d3      	strb	r3, [r2, #3]
        container->children[container->nbChildren] = (nbgl_obj_t *) valueTextArea;
c0de45bc:	787a      	ldrb	r2, [r7, #1]
c0de45be:	78bb      	ldrb	r3, [r7, #2]
c0de45c0:	78fc      	ldrb	r4, [r7, #3]
c0de45c2:	ea45 2202 	orr.w	r2, r5, r2, lsl #8
c0de45c6:	ea43 2304 	orr.w	r3, r3, r4, lsl #8
c0de45ca:	797d      	ldrb	r5, [r7, #5]
c0de45cc:	ea42 4203 	orr.w	r2, r2, r3, lsl #16
c0de45d0:	f842 6025 	str.w	r6, [r2, r5, lsl #2]
        container->nbChildren++;
c0de45d4:	1c6a      	adds	r2, r5, #1
c0de45d6:	717a      	strb	r2, [r7, #5]
        fullHeight += valueTextArea->obj.area.height + valueTextArea->obj.alignmentMarginY;
c0de45d8:	9a04      	ldr	r2, [sp, #16]
        valueTextArea->obj.area.height             = nbLines * font->line_height;
c0de45da:	0a09      	lsrs	r1, r1, #8
        fullHeight += valueTextArea->obj.area.height + valueTextArea->obj.alignmentMarginY;
c0de45dc:	fb0b 2000 	mla	r0, fp, r0, r2
        valueTextArea->obj.area.height             = nbLines * font->line_height;
c0de45e0:	71f1      	strb	r1, [r6, #7]
        valueTextArea->obj.alignment               = BOTTOM_LEFT;
c0de45e2:	2107      	movs	r1, #7
c0de45e4:	2500      	movs	r5, #0
        if (valueIcon != NULL) {
c0de45e6:	f1ba 0f00 	cmp.w	sl, #0
        fullHeight += valueTextArea->obj.area.height + valueTextArea->obj.alignmentMarginY;
c0de45ea:	f100 0b04 	add.w	fp, r0, #4
        valueTextArea->obj.alignment               = BOTTOM_LEFT;
c0de45ee:	72f1      	strb	r1, [r6, #11]
        valueTextArea->obj.alignmentMarginY        = TAG_VALUE_INTERVALE;
c0de45f0:	75f5      	strb	r5, [r6, #23]
        if (valueIcon != NULL) {
c0de45f2:	d06d      	beq.n	c0de46d0 <nbgl_layoutAddTagValueList+0x39c>
c0de45f4:	9c02      	ldr	r4, [sp, #8]
            nbgl_image_t *image = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de45f6:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de45fa:	08c1      	lsrs	r1, r0, #3
c0de45fc:	2002      	movs	r0, #2
c0de45fe:	f004 fab2 	bl	c0de8b66 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de4602:	f894 10ae 	ldrb.w	r1, [r4, #174]	@ 0xae
                layoutInt, (nbgl_obj_t *) container, list->token, TUNE_TAP_CASUAL);
c0de4606:	9a07      	ldr	r2, [sp, #28]
        layout->nbUsedCallbackObjs++;
c0de4608:	1c4f      	adds	r7, r1, #1
                layoutInt, (nbgl_obj_t *) container, list->token, TUNE_TAP_CASUAL);
c0de460a:	f892 c00c 	ldrb.w	ip, [r2, #12]
        layout->nbUsedCallbackObjs++;
c0de460e:	f44f 4240 	mov.w	r2, #49152	@ 0xc000
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de4612:	f001 033f 	and.w	r3, r1, #63	@ 0x3f
        layout->nbUsedCallbackObjs++;
c0de4616:	f007 073f 	and.w	r7, r7, #63	@ 0x3f
c0de461a:	ea02 2101 	and.w	r1, r2, r1, lsl #8
c0de461e:	ea41 2107 	orr.w	r1, r1, r7, lsl #8
c0de4622:	0a09      	lsrs	r1, r1, #8
c0de4624:	f884 10ae 	strb.w	r1, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de4628:	eb04 01c3 	add.w	r1, r4, r3, lsl #3
c0de462c:	9c05      	ldr	r4, [sp, #20]
        layoutObj->tuneId = tuneId;
c0de462e:	2209      	movs	r2, #9
        layoutObj->obj    = obj;
c0de4630:	f8c1 8020 	str.w	r8, [r1, #32]
        layoutObj->token  = token;
c0de4634:	f881 c024 	strb.w	ip, [r1, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de4638:	f881 2026 	strb.w	r2, [r1, #38]	@ 0x26
            obj->index                  = i;
c0de463c:	f881 4025 	strb.w	r4, [r1, #37]	@ 0x25
            image->buffer               = valueIcon;
c0de4640:	ea4f 211a 	mov.w	r1, sl, lsr #8
c0de4644:	7741      	strb	r1, [r0, #29]
c0de4646:	4601      	mov	r1, r0
c0de4648:	f801 af1c 	strb.w	sl, [r1, #28]!
c0de464c:	ea4f 621a 	mov.w	r2, sl, lsr #24
c0de4650:	70ca      	strb	r2, [r1, #3]
c0de4652:	ea4f 421a 	mov.w	r2, sl, lsr #16
c0de4656:	708a      	strb	r2, [r1, #2]
            image->obj.alignTo          = (nbgl_obj_t *) valueTextArea;
c0de4658:	4601      	mov	r1, r0
c0de465a:	f04f 0c0c 	mov.w	ip, #12
c0de465e:	ea4f 2a16 	mov.w	sl, r6, lsr #8
c0de4662:	f801 6f10 	strb.w	r6, [r1, #16]!
c0de4666:	ea4f 6e16 	mov.w	lr, r6, lsr #24
c0de466a:	0c32      	lsrs	r2, r6, #16
            image->obj.alignmentMarginX = VALUE_ICON_INTERVALE;
c0de466c:	f880 c014 	strb.w	ip, [r0, #20]
            image->obj.alignTo          = (nbgl_obj_t *) valueTextArea;
c0de4670:	f880 a011 	strb.w	sl, [r0, #17]
c0de4674:	f881 e003 	strb.w	lr, [r1, #3]
c0de4678:	708a      	strb	r2, [r1, #2]
            container->children[container->nbChildren] = (nbgl_obj_t *) image;
c0de467a:	4641      	mov	r1, r8
c0de467c:	9204      	str	r2, [sp, #16]
c0de467e:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
c0de4682:	f898 301d 	ldrb.w	r3, [r8, #29]
c0de4686:	788f      	ldrb	r7, [r1, #2]
c0de4688:	78c9      	ldrb	r1, [r1, #3]
c0de468a:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de468e:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de4692:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de4696:	f898 2021 	ldrb.w	r2, [r8, #33]	@ 0x21
            container->obj.touchMask = (1 << TOUCHED);
c0de469a:	2301      	movs	r3, #1
            image->foregroundColor      = BLACK;
c0de469c:	f880 5024 	strb.w	r5, [r0, #36]	@ 0x24
            image->obj.alignment        = RIGHT_TOP;
c0de46a0:	f880 c00b 	strb.w	ip, [r0, #11]
            image->obj.alignmentMarginX = VALUE_ICON_INTERVALE;
c0de46a4:	7545      	strb	r5, [r0, #21]
            container->obj.touchMask = (1 << TOUCHED);
c0de46a6:	f888 3018 	strb.w	r3, [r8, #24]
            container->children[container->nbChildren] = (nbgl_obj_t *) image;
c0de46aa:	f841 0022 	str.w	r0, [r1, r2, lsl #2]
            container->obj.touchId   = VALUE_BUTTON_1_ID + i;
c0de46ae:	f104 000f 	add.w	r0, r4, #15
c0de46b2:	f888 001a 	strb.w	r0, [r8, #26]
            container->nbChildren++;
c0de46b6:	1c50      	adds	r0, r2, #1
c0de46b8:	9f06      	ldr	r7, [sp, #24]
            container->obj.touchMask = (1 << TOUCHED);
c0de46ba:	f888 5019 	strb.w	r5, [r8, #25]
            container->nbChildren++;
c0de46be:	f888 0021 	strb.w	r0, [r8, #33]	@ 0x21
            if ((pair->aliasValue) && (pair->extension->aliasSubName)) {
c0de46c2:	7b38      	ldrb	r0, [r7, #12]
c0de46c4:	0740      	lsls	r0, r0, #29
c0de46c6:	d407      	bmi.n	c0de46d8 <nbgl_layoutAddTagValueList+0x3a4>
c0de46c8:	f8dd a00c 	ldr.w	sl, [sp, #12]
c0de46cc:	e062      	b.n	c0de4794 <nbgl_layoutAddTagValueList+0x460>
c0de46ce:	bf00      	nop
c0de46d0:	f8dd a00c 	ldr.w	sl, [sp, #12]
c0de46d4:	9c05      	ldr	r4, [sp, #20]
c0de46d6:	e05d      	b.n	c0de4794 <nbgl_layoutAddTagValueList+0x460>
c0de46d8:	68b8      	ldr	r0, [r7, #8]
c0de46da:	f8cd a004 	str.w	sl, [sp, #4]
c0de46de:	6840      	ldr	r0, [r0, #4]
c0de46e0:	f8dd a00c 	ldr.w	sl, [sp, #12]
c0de46e4:	2800      	cmp	r0, #0
c0de46e6:	d055      	beq.n	c0de4794 <nbgl_layoutAddTagValueList+0x460>
                    = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de46e8:	9802      	ldr	r0, [sp, #8]
c0de46ea:	4674      	mov	r4, lr
c0de46ec:	f890 00ad 	ldrb.w	r0, [r0, #173]	@ 0xad
c0de46f0:	08c1      	lsrs	r1, r0, #3
c0de46f2:	2004      	movs	r0, #4
c0de46f4:	f004 fa37 	bl	c0de8b66 <nbgl_objPoolGet>
c0de46f8:	4605      	mov	r5, r0
                textArea->textColor            = BLACK;
c0de46fa:	2000      	movs	r0, #0
c0de46fc:	7728      	strb	r0, [r5, #28]
                textArea->text                 = PIC(pair->extension->aliasSubName);
c0de46fe:	68b8      	ldr	r0, [r7, #8]
c0de4700:	6840      	ldr	r0, [r0, #4]
c0de4702:	f005 f957 	bl	c0de99b4 <pic>
c0de4706:	4629      	mov	r1, r5
c0de4708:	f801 0f23 	strb.w	r0, [r1, #35]!
c0de470c:	0e02      	lsrs	r2, r0, #24
c0de470e:	70ca      	strb	r2, [r1, #3]
c0de4710:	0c02      	lsrs	r2, r0, #16
c0de4712:	0a00      	lsrs	r0, r0, #8
c0de4714:	f885 0024 	strb.w	r0, [r5, #36]	@ 0x24
                textArea->nbMaxLines           = 1;
c0de4718:	2001      	movs	r0, #1
c0de471a:	f885 0022 	strb.w	r0, [r5, #34]	@ 0x22
                textArea->fontId               = SMALL_REGULAR_FONT;
c0de471e:	200b      	movs	r0, #11
c0de4720:	2704      	movs	r7, #4
c0de4722:	77e8      	strb	r0, [r5, #31]
                textArea->obj.area.height      = nbgl_getFontLineHeight(textArea->fontId);
c0de4724:	200b      	movs	r0, #11
                textArea->text                 = PIC(pair->extension->aliasSubName);
c0de4726:	708a      	strb	r2, [r1, #2]
                textArea->textAlignment        = MID_LEFT;
c0de4728:	776f      	strb	r7, [r5, #29]
                textArea->obj.area.height      = nbgl_getFontLineHeight(textArea->fontId);
c0de472a:	f004 fa30 	bl	c0de8b8e <nbgl_getFontLineHeight>
c0de472e:	2100      	movs	r1, #0
c0de4730:	71a8      	strb	r0, [r5, #6]
c0de4732:	71e9      	strb	r1, [r5, #7]
                textArea->obj.area.width       = valueTextArea->obj.area.width;
c0de4734:	7971      	ldrb	r1, [r6, #5]
c0de4736:	7932      	ldrb	r2, [r6, #4]
c0de4738:	7169      	strb	r1, [r5, #5]
                textArea->obj.alignment        = BOTTOM_LEFT;
c0de473a:	2107      	movs	r1, #7
c0de473c:	72e9      	strb	r1, [r5, #11]
                textArea->obj.alignmentMarginY = TAG_VALUE_INTERVALE;
c0de473e:	2100      	movs	r1, #0
c0de4740:	75e9      	strb	r1, [r5, #23]
                textArea->obj.alignTo          = (nbgl_obj_t *) valueTextArea;
c0de4742:	9901      	ldr	r1, [sp, #4]
                textArea->obj.area.width       = valueTextArea->obj.area.width;
c0de4744:	712a      	strb	r2, [r5, #4]
                textArea->obj.alignTo          = (nbgl_obj_t *) valueTextArea;
c0de4746:	7469      	strb	r1, [r5, #17]
c0de4748:	4629      	mov	r1, r5
c0de474a:	9a04      	ldr	r2, [sp, #16]
c0de474c:	f801 6f10 	strb.w	r6, [r1, #16]!
                textArea->wrapping             = list->wrapping;
c0de4750:	9b07      	ldr	r3, [sp, #28]
                textArea->obj.alignmentMarginY = TAG_VALUE_INTERVALE;
c0de4752:	75af      	strb	r7, [r5, #22]
                textArea->obj.alignTo          = (nbgl_obj_t *) valueTextArea;
c0de4754:	708a      	strb	r2, [r1, #2]
                textArea->wrapping             = list->wrapping;
c0de4756:	f895 2021 	ldrb.w	r2, [r5, #33]	@ 0x21
c0de475a:	7b9b      	ldrb	r3, [r3, #14]
c0de475c:	f002 02fe 	and.w	r2, r2, #254	@ 0xfe
c0de4760:	431a      	orrs	r2, r3
c0de4762:	f885 2021 	strb.w	r2, [r5, #33]	@ 0x21
                container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de4766:	4642      	mov	r2, r8
c0de4768:	f812 cf1c 	ldrb.w	ip, [r2, #28]!
                textArea->obj.alignTo          = (nbgl_obj_t *) valueTextArea;
c0de476c:	70cc      	strb	r4, [r1, #3]
                container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de476e:	7851      	ldrb	r1, [r2, #1]
c0de4770:	7897      	ldrb	r7, [r2, #2]
c0de4772:	78d6      	ldrb	r6, [r2, #3]
c0de4774:	7953      	ldrb	r3, [r2, #5]
c0de4776:	ea4c 2101 	orr.w	r1, ip, r1, lsl #8
c0de477a:	ea47 2706 	orr.w	r7, r7, r6, lsl #8
c0de477e:	9c05      	ldr	r4, [sp, #20]
c0de4780:	ea41 4107 	orr.w	r1, r1, r7, lsl #16
                fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de4784:	4458      	add	r0, fp
                container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de4786:	f841 5023 	str.w	r5, [r1, r3, lsl #2]
c0de478a:	2500      	movs	r5, #0
                container->nbChildren++;
c0de478c:	1c59      	adds	r1, r3, #1
                fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de478e:	f100 0b04 	add.w	fp, r0, #4
                container->nbChildren++;
c0de4792:	7151      	strb	r1, [r2, #5]
        container->obj.area.width       = AVAILABLE_WIDTH;
c0de4794:	2001      	movs	r0, #1
c0de4796:	f888 0005 	strb.w	r0, [r8, #5]
c0de479a:	20a0      	movs	r0, #160	@ 0xa0
c0de479c:	f888 0004 	strb.w	r0, [r8, #4]
        container->obj.area.height      = fullHeight;
c0de47a0:	ea4f 201b 	mov.w	r0, fp, lsr #8
c0de47a4:	f888 0007 	strb.w	r0, [r8, #7]
        if (i > 0) {
c0de47a8:	f1ba 0f00 	cmp.w	sl, #0
        container->obj.alignmentMarginX = BORDER_MARGIN;
c0de47ac:	f04f 0020 	mov.w	r0, #32
        container->obj.area.height      = fullHeight;
c0de47b0:	f888 b006 	strb.w	fp, [r8, #6]
        container->layout               = VERTICAL;
c0de47b4:	f888 5020 	strb.w	r5, [r8, #32]
        container->obj.alignmentMarginX = BORDER_MARGIN;
c0de47b8:	f888 5015 	strb.w	r5, [r8, #21]
c0de47bc:	f888 0014 	strb.w	r0, [r8, #20]
        if (i > 0) {
c0de47c0:	d002      	beq.n	c0de47c8 <nbgl_layoutAddTagValueList+0x494>
c0de47c2:	9d02      	ldr	r5, [sp, #8]
c0de47c4:	2018      	movs	r0, #24
c0de47c6:	e5cc      	b.n	c0de4362 <nbgl_layoutAddTagValueList+0x2e>
c0de47c8:	9d02      	ldr	r5, [sp, #8]
            if (layoutInt->headerContainer && (layoutInt->headerContainer->nbChildren > 0)
c0de47ca:	68e8      	ldr	r0, [r5, #12]
c0de47cc:	2800      	cmp	r0, #0
c0de47ce:	f43f adc7 	beq.w	c0de4360 <nbgl_layoutAddTagValueList+0x2c>
c0de47d2:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
                && (layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren - 1]
c0de47d6:	2900      	cmp	r1, #0
c0de47d8:	f43f adc2 	beq.w	c0de4360 <nbgl_layoutAddTagValueList+0x2c>
c0de47dc:	f810 2f1c 	ldrb.w	r2, [r0, #28]!
c0de47e0:	7843      	ldrb	r3, [r0, #1]
c0de47e2:	7887      	ldrb	r7, [r0, #2]
c0de47e4:	78c0      	ldrb	r0, [r0, #3]
c0de47e6:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de47ea:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de47ee:	ea42 4000 	orr.w	r0, r2, r0, lsl #16
c0de47f2:	eb00 0081 	add.w	r0, r0, r1, lsl #2
c0de47f6:	f850 0c04 	ldr.w	r0, [r0, #-4]
                        ->type
c0de47fa:	7a80      	ldrb	r0, [r0, #10]
            if (layoutInt->headerContainer && (layoutInt->headerContainer->nbChildren > 0)
c0de47fc:	2803      	cmp	r0, #3
c0de47fe:	d0e1      	beq.n	c0de47c4 <nbgl_layoutAddTagValueList+0x490>
c0de4800:	e5ae      	b.n	c0de4360 <nbgl_layoutAddTagValueList+0x2c>
c0de4802:	f04f 0a00 	mov.w	sl, #0
c0de4806:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de480a:	e68d      	b.n	c0de4528 <nbgl_layoutAddTagValueList+0x1f4>
c0de480c:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
}
c0de4810:	b008      	add	sp, #32
c0de4812:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de4816:	2000      	movs	r0, #0
c0de4818:	b008      	add	sp, #32
c0de481a:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de481e <nbgl_layoutAddSeparationLine>:
{
c0de481e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de4820:	b081      	sub	sp, #4
c0de4822:	4604      	mov	r4, r0
    line                       = createHorizontalLine(layoutInt->layer);
c0de4824:	f890 00ad 	ldrb.w	r0, [r0, #173]	@ 0xad
c0de4828:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de482a:	2003      	movs	r0, #3
c0de482c:	f004 f99b 	bl	c0de8b66 <nbgl_objPoolGet>
c0de4830:	2701      	movs	r7, #1
c0de4832:	22e0      	movs	r2, #224	@ 0xe0
c0de4834:	f04f 0eff 	mov.w	lr, #255	@ 0xff
    line->obj.area.width  = SCREEN_WIDTH;
c0de4838:	7102      	strb	r2, [r0, #4]
    line->obj.area.height = 1;
c0de483a:	7187      	strb	r7, [r0, #6]
    line->obj.alignmentMarginY = -1;
c0de483c:	f880 e016 	strb.w	lr, [r0, #22]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de4840:	f8d4 30a0 	ldr.w	r3, [r4, #160]	@ 0xa0
c0de4844:	2102      	movs	r1, #2
    layout->container->children[layout->container->nbChildren] = obj;
c0de4846:	f813 2f1c 	ldrb.w	r2, [r3, #28]!
    line->lineColor       = LIGHT_GRAY;
c0de484a:	7741      	strb	r1, [r0, #29]
    layout->container->children[layout->container->nbChildren] = obj;
c0de484c:	7859      	ldrb	r1, [r3, #1]
c0de484e:	789d      	ldrb	r5, [r3, #2]
c0de4850:	78de      	ldrb	r6, [r3, #3]
c0de4852:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de4856:	ea45 2206 	orr.w	r2, r5, r6, lsl #8
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de485a:	795b      	ldrb	r3, [r3, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de485c:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de4860:	f841 0023 	str.w	r0, [r1, r3, lsl #2]
    layout->container->nbChildren++;
c0de4864:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
c0de4868:	f04f 0c00 	mov.w	ip, #0
c0de486c:	f891 2021 	ldrb.w	r2, [r1, #33]	@ 0x21
    line->obj.area.height = 1;
c0de4870:	f880 c007 	strb.w	ip, [r0, #7]
    layout->container->nbChildren++;
c0de4874:	3201      	adds	r2, #1
    line->obj.area.width  = SCREEN_WIDTH;
c0de4876:	7147      	strb	r7, [r0, #5]
    line->direction       = HORIZONTAL;
c0de4878:	7707      	strb	r7, [r0, #28]
    line->thickness       = 1;
c0de487a:	7787      	strb	r7, [r0, #30]
    line->obj.alignmentMarginY = -1;
c0de487c:	f880 e017 	strb.w	lr, [r0, #23]
    return 0;
c0de4880:	2000      	movs	r0, #0
    layout->container->nbChildren++;
c0de4882:	f881 2021 	strb.w	r2, [r1, #33]	@ 0x21
    return 0;
c0de4886:	b001      	add	sp, #4
c0de4888:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de488a <nbgl_layoutAddButton>:
{
c0de488a:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
c0de488e:	b086      	sub	sp, #24
    if (layout == NULL) {
c0de4890:	2800      	cmp	r0, #0
c0de4892:	f000 8094 	beq.w	c0de49be <nbgl_layoutAddButton+0x134>
c0de4896:	4604      	mov	r4, r0
    if ((buttonInfo->onBottom) && (!buttonInfo->fittingContent)) {
c0de4898:	7ac8      	ldrb	r0, [r1, #11]
c0de489a:	460d      	mov	r5, r1
c0de489c:	b118      	cbz	r0, c0de48a6 <nbgl_layoutAddButton+0x1c>
c0de489e:	7aa8      	ldrb	r0, [r5, #10]
c0de48a0:	2800      	cmp	r0, #0
c0de48a2:	f000 8091 	beq.w	c0de49c8 <nbgl_layoutAddButton+0x13e>
    button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de48a6:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de48aa:	08c1      	lsrs	r1, r0, #3
c0de48ac:	2005      	movs	r0, #5
c0de48ae:	f004 f95a 	bl	c0de8b66 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de48b2:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de48b6:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de48ba:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de48be:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de48c2:	2a0e      	cmp	r2, #14
c0de48c4:	d87b      	bhi.n	c0de49be <nbgl_layoutAddButton+0x134>
c0de48c6:	4606      	mov	r6, r0
c0de48c8:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de48ca:	3001      	adds	r0, #1
c0de48cc:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de48d0:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de48d4:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
        layoutInt, (nbgl_obj_t *) button, buttonInfo->token, buttonInfo->tuneId);
c0de48d8:	f895 c008 	ldrb.w	ip, [r5, #8]
c0de48dc:	7b2f      	ldrb	r7, [r5, #12]
        layout->nbUsedCallbackObjs++;
c0de48de:	0a00      	lsrs	r0, r0, #8
c0de48e0:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de48e4:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de48e8:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de48ea:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de48ee:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
c0de48f2:	f04f 0800 	mov.w	r8, #0
c0de48f6:	2020      	movs	r0, #32
c0de48f8:	270c      	movs	r7, #12
        layout->nbUsedCallbackObjs++;
c0de48fa:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
    button->obj.alignmentMarginX = BORDER_MARGIN;
c0de48fe:	f886 8015 	strb.w	r8, [r6, #21]
c0de4902:	7530      	strb	r0, [r6, #20]
    button->obj.alignmentMarginY = 12;
c0de4904:	f886 8017 	strb.w	r8, [r6, #23]
c0de4908:	75b7      	strb	r7, [r6, #22]
    button->obj.alignment        = NO_ALIGNMENT;
c0de490a:	f886 800b 	strb.w	r8, [r6, #11]
    if (buttonInfo->style == BLACK_BACKGROUND) {
c0de490e:	7a68      	ldrb	r0, [r5, #9]
c0de4910:	2300      	movs	r3, #0
c0de4912:	4601      	mov	r1, r0
c0de4914:	4602      	mov	r2, r0
c0de4916:	2800      	cmp	r0, #0
c0de4918:	bf1c      	itt	ne
c0de491a:	2101      	movne	r1, #1
c0de491c:	2203      	movne	r2, #3
    if (buttonInfo->style == NO_BORDER) {
c0de491e:	ea4f 0141 	mov.w	r1, r1, lsl #1
c0de4922:	bf08      	it	eq
c0de4924:	2303      	moveq	r3, #3
c0de4926:	f886 2028 	strb.w	r2, [r6, #40]	@ 0x28
c0de492a:	f886 302a 	strb.w	r3, [r6, #42]	@ 0x2a
c0de492e:	2802      	cmp	r0, #2
c0de4930:	bf08      	it	eq
c0de4932:	2103      	moveq	r1, #3
c0de4934:	f886 1029 	strb.w	r1, [r6, #41]	@ 0x29
    button->text   = PIC(buttonInfo->text);
c0de4938:	6828      	ldr	r0, [r5, #0]
c0de493a:	f005 f83b 	bl	c0de99b4 <pic>
c0de493e:	4631      	mov	r1, r6
c0de4940:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de4944:	0e02      	lsrs	r2, r0, #24
c0de4946:	70ca      	strb	r2, [r1, #3]
c0de4948:	0c02      	lsrs	r2, r0, #16
c0de494a:	0a00      	lsrs	r0, r0, #8
c0de494c:	708a      	strb	r2, [r1, #2]
c0de494e:	7770      	strb	r0, [r6, #29]
    button->fontId = SMALL_BOLD_FONT;
c0de4950:	f886 702c 	strb.w	r7, [r6, #44]	@ 0x2c
    button->icon   = PIC(buttonInfo->icon);
c0de4954:	6868      	ldr	r0, [r5, #4]
c0de4956:	f005 f82d 	bl	c0de99b4 <pic>
c0de495a:	4631      	mov	r1, r6
c0de495c:	f801 0f24 	strb.w	r0, [r1, #36]!
c0de4960:	0e02      	lsrs	r2, r0, #24
c0de4962:	70ca      	strb	r2, [r1, #3]
c0de4964:	0c02      	lsrs	r2, r0, #16
c0de4966:	0a00      	lsrs	r0, r0, #8
c0de4968:	708a      	strb	r2, [r1, #2]
c0de496a:	7048      	strb	r0, [r1, #1]
    if (buttonInfo->fittingContent == true) {
c0de496c:	7aa8      	ldrb	r0, [r5, #10]
c0de496e:	2800      	cmp	r0, #0
c0de4970:	d041      	beq.n	c0de49f6 <nbgl_layoutAddButton+0x16c>
        button->obj.area.width = nbgl_getTextWidth(button->fontId, button->text)
c0de4972:	4631      	mov	r1, r6
c0de4974:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
c0de4978:	7f70      	ldrb	r0, [r6, #29]
c0de497a:	788b      	ldrb	r3, [r1, #2]
c0de497c:	78c9      	ldrb	r1, [r1, #3]
c0de497e:	ea42 2200 	orr.w	r2, r2, r0, lsl #8
c0de4982:	f896 002c 	ldrb.w	r0, [r6, #44]	@ 0x2c
c0de4986:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de498a:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de498e:	f004 f90d 	bl	c0de8bac <nbgl_getTextWidth>
                                 + ((button->icon) ? (button->icon->width + 12) : 0);
c0de4992:	4631      	mov	r1, r6
c0de4994:	f811 2f24 	ldrb.w	r2, [r1, #36]!
                                 + SMALL_BUTTON_HEIGHT
c0de4998:	3040      	adds	r0, #64	@ 0x40
                                 + ((button->icon) ? (button->icon->width + 12) : 0);
c0de499a:	784b      	ldrb	r3, [r1, #1]
c0de499c:	788f      	ldrb	r7, [r1, #2]
c0de499e:	78c9      	ldrb	r1, [r1, #3]
c0de49a0:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de49a4:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de49a8:	ea42 4201 	orr.w	r2, r2, r1, lsl #16
c0de49ac:	f04f 0100 	mov.w	r1, #0
c0de49b0:	b36a      	cbz	r2, c0de4a0e <nbgl_layoutAddButton+0x184>
c0de49b2:	7813      	ldrb	r3, [r2, #0]
c0de49b4:	7852      	ldrb	r2, [r2, #1]
c0de49b6:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de49ba:	320c      	adds	r2, #12
c0de49bc:	e028      	b.n	c0de4a10 <nbgl_layoutAddButton+0x186>
c0de49be:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
}
c0de49c2:	b006      	add	sp, #24
c0de49c4:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
        if (layoutInt->footerContainer == NULL) {
c0de49c8:	6920      	ldr	r0, [r4, #16]
c0de49ca:	2800      	cmp	r0, #0
c0de49cc:	d067      	beq.n	c0de4a9e <nbgl_layoutAddButton+0x214>
c0de49ce:	2001      	movs	r0, #1
            upFooterDesc.type          = UP_FOOTER_BUTTON;
c0de49d0:	f88d 0000 	strb.w	r0, [sp]
            upFooterDesc.button.token  = buttonInfo->token;
c0de49d4:	8928      	ldrh	r0, [r5, #8]
            upFooterDesc.button.text   = buttonInfo->text;
c0de49d6:	6829      	ldr	r1, [r5, #0]
            upFooterDesc.button.token  = buttonInfo->token;
c0de49d8:	f8ad 000c 	strh.w	r0, [sp, #12]
            upFooterDesc.button.icon   = buttonInfo->icon;
c0de49dc:	6868      	ldr	r0, [r5, #4]
            upFooterDesc.button.tuneId = buttonInfo->tuneId;
c0de49de:	7b2a      	ldrb	r2, [r5, #12]
            upFooterDesc.button.text   = buttonInfo->text;
c0de49e0:	9101      	str	r1, [sp, #4]
            upFooterDesc.button.icon   = buttonInfo->icon;
c0de49e2:	9002      	str	r0, [sp, #8]
c0de49e4:	4669      	mov	r1, sp
            return nbgl_layoutAddUpFooter(layout, &upFooterDesc);
c0de49e6:	4620      	mov	r0, r4
            upFooterDesc.button.tuneId = buttonInfo->tuneId;
c0de49e8:	f88d 2010 	strb.w	r2, [sp, #16]
            return nbgl_layoutAddUpFooter(layout, &upFooterDesc);
c0de49ec:	f7fc ff56 	bl	c0de189c <nbgl_layoutAddUpFooter>
}
c0de49f0:	b006      	add	sp, #24
c0de49f2:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
c0de49f6:	2001      	movs	r0, #1
        button->obj.area.width  = AVAILABLE_WIDTH;
c0de49f8:	7170      	strb	r0, [r6, #5]
c0de49fa:	20a0      	movs	r0, #160	@ 0xa0
c0de49fc:	7130      	strb	r0, [r6, #4]
c0de49fe:	2058      	movs	r0, #88	@ 0x58
        button->obj.area.height = BUTTON_DIAMETER;
c0de4a00:	71b0      	strb	r0, [r6, #6]
c0de4a02:	2004      	movs	r0, #4
c0de4a04:	f886 8007 	strb.w	r8, [r6, #7]
        button->radius          = BUTTON_RADIUS;
c0de4a08:	f886 002b 	strb.w	r0, [r6, #43]	@ 0x2b
c0de4a0c:	e01d      	b.n	c0de4a4a <nbgl_layoutAddButton+0x1c0>
c0de4a0e:	2200      	movs	r2, #0
                                 + ((button->icon) ? (button->icon->width + 12) : 0);
c0de4a10:	4410      	add	r0, r2
        button->obj.area.height = SMALL_BUTTON_HEIGHT;
c0de4a12:	71f1      	strb	r1, [r6, #7]
c0de4a14:	2140      	movs	r1, #64	@ 0x40
        button->obj.area.width = nbgl_getTextWidth(button->fontId, button->text)
c0de4a16:	0a02      	lsrs	r2, r0, #8
        button->obj.area.height = SMALL_BUTTON_HEIGHT;
c0de4a18:	71b1      	strb	r1, [r6, #6]
c0de4a1a:	2102      	movs	r1, #2
        button->obj.area.width = nbgl_getTextWidth(button->fontId, button->text)
c0de4a1c:	7130      	strb	r0, [r6, #4]
c0de4a1e:	7172      	strb	r2, [r6, #5]
        button->radius          = SMALL_BUTTON_RADIUS_INDEX;
c0de4a20:	f886 102b 	strb.w	r1, [r6, #43]	@ 0x2b
        if (buttonInfo->onBottom != true) {
c0de4a24:	7ae9      	ldrb	r1, [r5, #11]
c0de4a26:	2901      	cmp	r1, #1
c0de4a28:	d00f      	beq.n	c0de4a4a <nbgl_layoutAddButton+0x1c0>
            button->obj.alignmentMarginX += (AVAILABLE_WIDTH - button->obj.area.width) / 2;
c0de4a2a:	4631      	mov	r1, r6
c0de4a2c:	f811 2f14 	ldrb.w	r2, [r1, #20]!
c0de4a30:	b280      	uxth	r0, r0
c0de4a32:	784b      	ldrb	r3, [r1, #1]
c0de4a34:	f5c0 70d0 	rsb	r0, r0, #416	@ 0x1a0
c0de4a38:	eb00 70d0 	add.w	r0, r0, r0, lsr #31
c0de4a3c:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de4a40:	eb02 0050 	add.w	r0, r2, r0, lsr #1
c0de4a44:	7008      	strb	r0, [r1, #0]
c0de4a46:	0a00      	lsrs	r0, r0, #8
c0de4a48:	7048      	strb	r0, [r1, #1]
c0de4a4a:	2000      	movs	r0, #0
    button->obj.alignTo   = NULL;
c0de4a4c:	4631      	mov	r1, r6
c0de4a4e:	f801 0f10 	strb.w	r0, [r1, #16]!
c0de4a52:	70c8      	strb	r0, [r1, #3]
c0de4a54:	7088      	strb	r0, [r1, #2]
c0de4a56:	2101      	movs	r1, #1
c0de4a58:	7470      	strb	r0, [r6, #17]
    button->obj.touchMask = (1 << TOUCHED);
c0de4a5a:	7670      	strb	r0, [r6, #25]
c0de4a5c:	7631      	strb	r1, [r6, #24]
    button->obj.touchId   = (buttonInfo->fittingContent) ? EXTRA_BUTTON_ID : SINGLE_BUTTON_ID;
c0de4a5e:	7aa9      	ldrb	r1, [r5, #10]
c0de4a60:	2208      	movs	r2, #8
c0de4a62:	2900      	cmp	r1, #0
c0de4a64:	bf08      	it	eq
c0de4a66:	2207      	moveq	r2, #7
c0de4a68:	76b2      	strb	r2, [r6, #26]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de4a6a:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
    layout->container->children[layout->container->nbChildren] = obj;
c0de4a6e:	f811 2f1c 	ldrb.w	r2, [r1, #28]!
c0de4a72:	784b      	ldrb	r3, [r1, #1]
c0de4a74:	788f      	ldrb	r7, [r1, #2]
c0de4a76:	78cd      	ldrb	r5, [r1, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de4a78:	7949      	ldrb	r1, [r1, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de4a7a:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de4a7e:	ea47 2305 	orr.w	r3, r7, r5, lsl #8
c0de4a82:	ea42 4203 	orr.w	r2, r2, r3, lsl #16
c0de4a86:	f842 6021 	str.w	r6, [r2, r1, lsl #2]
    layout->container->nbChildren++;
c0de4a8a:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
c0de4a8e:	f891 2021 	ldrb.w	r2, [r1, #33]	@ 0x21
c0de4a92:	3201      	adds	r2, #1
c0de4a94:	f881 2021 	strb.w	r2, [r1, #33]	@ 0x21
}
c0de4a98:	b006      	add	sp, #24
c0de4a9a:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
c0de4a9e:	2005      	movs	r0, #5
            footerDesc.type           = FOOTER_SIMPLE_BUTTON;
c0de4aa0:	f8ad 0000 	strh.w	r0, [sp]
            footerDesc.button.token   = buttonInfo->token;
c0de4aa4:	8928      	ldrh	r0, [r5, #8]
            footerDesc.button.text    = buttonInfo->text;
c0de4aa6:	6829      	ldr	r1, [r5, #0]
            footerDesc.button.token   = buttonInfo->token;
c0de4aa8:	f8ad 000c 	strh.w	r0, [sp, #12]
            footerDesc.button.icon    = buttonInfo->icon;
c0de4aac:	6868      	ldr	r0, [r5, #4]
            footerDesc.button.tuneId  = buttonInfo->tuneId;
c0de4aae:	7b2a      	ldrb	r2, [r5, #12]
            footerDesc.button.text    = buttonInfo->text;
c0de4ab0:	9101      	str	r1, [sp, #4]
            footerDesc.button.icon    = buttonInfo->icon;
c0de4ab2:	9002      	str	r0, [sp, #8]
c0de4ab4:	4669      	mov	r1, sp
            return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de4ab6:	4620      	mov	r0, r4
            footerDesc.button.tuneId  = buttonInfo->tuneId;
c0de4ab8:	f88d 2010 	strb.w	r2, [sp, #16]
            return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de4abc:	f7fd fbe7 	bl	c0de228e <nbgl_layoutAddExtendedFooter>
}
c0de4ac0:	b006      	add	sp, #24
c0de4ac2:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}

c0de4ac6 <nbgl_layoutAddLongPressButton>:
{
c0de4ac6:	b580      	push	{r7, lr}
c0de4ac8:	b086      	sub	sp, #24
c0de4aca:	f04f 0c00 	mov.w	ip, #0
    if (layout == NULL) {
c0de4ace:	2800      	cmp	r0, #0
    nbgl_layoutUpFooter_t upFooterDesc = {.type             = UP_FOOTER_LONG_PRESS,
c0de4ad0:	f88d c004 	strb.w	ip, [sp, #4]
                                          .longPress.text   = text,
c0de4ad4:	9102      	str	r1, [sp, #8]
c0de4ad6:	f88d 200c 	strb.w	r2, [sp, #12]
c0de4ada:	f88d 300d 	strb.w	r3, [sp, #13]
c0de4ade:	bf0e      	itee	eq
c0de4ae0:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
c0de4ae4:	f10d 0104 	addne.w	r1, sp, #4
    return nbgl_layoutAddUpFooter(layout, &upFooterDesc);
c0de4ae8:	f7fc fed8 	blne	c0de189c <nbgl_layoutAddUpFooter>
}
c0de4aec:	b006      	add	sp, #24
c0de4aee:	bd80      	pop	{r7, pc}

c0de4af0 <nbgl_layoutAddFooter>:
{
c0de4af0:	b580      	push	{r7, lr}
c0de4af2:	b086      	sub	sp, #24
    footerDesc.simpleText.text     = text;
c0de4af4:	9101      	str	r1, [sp, #4]
c0de4af6:	2100      	movs	r1, #0
c0de4af8:	f240 1c01 	movw	ip, #257	@ 0x101
    footerDesc.simpleText.mutedOut = false;
c0de4afc:	f88d 1008 	strb.w	r1, [sp, #8]
c0de4b00:	4669      	mov	r1, sp
    footerDesc.type                = FOOTER_SIMPLE_TEXT;
c0de4b02:	f8ad c000 	strh.w	ip, [sp]
    footerDesc.simpleText.token    = token;
c0de4b06:	f88d 2009 	strb.w	r2, [sp, #9]
    footerDesc.simpleText.tuneId   = tuneId;
c0de4b0a:	f88d 300a 	strb.w	r3, [sp, #10]
    return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de4b0e:	f7fd fbbe 	bl	c0de228e <nbgl_layoutAddExtendedFooter>
c0de4b12:	b006      	add	sp, #24
c0de4b14:	bd80      	pop	{r7, pc}

c0de4b16 <nbgl_layoutAddSplitFooter>:
{
c0de4b16:	b510      	push	{r4, lr}
c0de4b18:	b086      	sub	sp, #24
c0de4b1a:	e9dd ec08 	ldrd	lr, ip, [sp, #32]
c0de4b1e:	f44f 7481 	mov.w	r4, #258	@ 0x102
    footerDesc.doubleText.leftText   = leftText;
c0de4b22:	9101      	str	r1, [sp, #4]
c0de4b24:	4669      	mov	r1, sp
    footerDesc.type                  = FOOTER_DOUBLE_TEXT;
c0de4b26:	f8ad 4000 	strh.w	r4, [sp]
    footerDesc.doubleText.leftToken  = leftToken;
c0de4b2a:	f88d 200c 	strb.w	r2, [sp, #12]
    footerDesc.doubleText.rightText  = rightText;
c0de4b2e:	9302      	str	r3, [sp, #8]
    footerDesc.doubleText.rightToken = rightToken;
c0de4b30:	f88d e00d 	strb.w	lr, [sp, #13]
    footerDesc.doubleText.tuneId     = tuneId;
c0de4b34:	f88d c00e 	strb.w	ip, [sp, #14]
    return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de4b38:	f7fd fba9 	bl	c0de228e <nbgl_layoutAddExtendedFooter>
c0de4b3c:	b006      	add	sp, #24
c0de4b3e:	bd10      	pop	{r4, pc}

c0de4b40 <nbgl_layoutAddHeader>:
{
c0de4b40:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
    if (layout == NULL) {
c0de4b44:	2800      	cmp	r0, #0
c0de4b46:	f000 8308 	beq.w	c0de515a <nbgl_layoutAddHeader+0x61a>
c0de4b4a:	468b      	mov	fp, r1
    if ((headerDesc == NULL) || (headerDesc->type >= NB_HEADER_TYPES)) {
c0de4b4c:	b121      	cbz	r1, c0de4b58 <nbgl_layoutAddHeader+0x18>
c0de4b4e:	4604      	mov	r4, r0
c0de4b50:	f89b 0000 	ldrb.w	r0, [fp]
c0de4b54:	2806      	cmp	r0, #6
c0de4b56:	d903      	bls.n	c0de4b60 <nbgl_layoutAddHeader+0x20>
c0de4b58:	f06f 0001 	mvn.w	r0, #1
}
c0de4b5c:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
    layoutInt->headerContainer = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de4b60:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de4b64:	2601      	movs	r6, #1
c0de4b66:	08c1      	lsrs	r1, r0, #3
c0de4b68:	2001      	movs	r0, #1
c0de4b6a:	f003 fffc 	bl	c0de8b66 <nbgl_objPoolGet>
c0de4b6e:	21e0      	movs	r1, #224	@ 0xe0
c0de4b70:	60e0      	str	r0, [r4, #12]
    layoutInt->headerContainer->obj.area.width = SCREEN_WIDTH;
c0de4b72:	7101      	strb	r1, [r0, #4]
c0de4b74:	2100      	movs	r1, #0
c0de4b76:	7146      	strb	r6, [r0, #5]
    layoutInt->headerContainer->layout         = VERTICAL;
c0de4b78:	f880 1020 	strb.w	r1, [r0, #32]
        = (nbgl_obj_t **) nbgl_containerPoolGet(5, layoutInt->layer);
c0de4b7c:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de4b80:	08c1      	lsrs	r1, r0, #3
c0de4b82:	2005      	movs	r0, #5
c0de4b84:	f003 fff4 	bl	c0de8b70 <nbgl_containerPoolGet>
    layoutInt->headerContainer->children
c0de4b88:	68e1      	ldr	r1, [r4, #12]
        = (nbgl_obj_t **) nbgl_containerPoolGet(5, layoutInt->layer);
c0de4b8a:	0a02      	lsrs	r2, r0, #8
c0de4b8c:	774a      	strb	r2, [r1, #29]
c0de4b8e:	460a      	mov	r2, r1
c0de4b90:	f802 0f1c 	strb.w	r0, [r2, #28]!
c0de4b94:	0e03      	lsrs	r3, r0, #24
c0de4b96:	0c00      	lsrs	r0, r0, #16
c0de4b98:	7090      	strb	r0, [r2, #2]
c0de4b9a:	70d3      	strb	r3, [r2, #3]
    switch (headerDesc->type) {
c0de4b9c:	f89b 2000 	ldrb.w	r2, [fp]
c0de4ba0:	2002      	movs	r0, #2
    layoutInt->headerContainer->obj.alignment = TOP_MIDDLE;
c0de4ba2:	72c8      	strb	r0, [r1, #11]
    switch (headerDesc->type) {
c0de4ba4:	2a03      	cmp	r2, #3
c0de4ba6:	f06f 0001 	mvn.w	r0, #1
c0de4baa:	dc0a      	bgt.n	c0de4bc2 <nbgl_layoutAddHeader+0x82>
c0de4bac:	1e53      	subs	r3, r2, #1
c0de4bae:	2b02      	cmp	r3, #2
c0de4bb0:	d37c      	bcc.n	c0de4cac <nbgl_layoutAddHeader+0x16c>
c0de4bb2:	2a00      	cmp	r2, #0
c0de4bb4:	f000 80ba 	beq.w	c0de4d2c <nbgl_layoutAddHeader+0x1ec>
c0de4bb8:	2a03      	cmp	r2, #3
}
c0de4bba:	bf18      	it	ne
c0de4bbc:	e8bd 8df0 	ldmiane.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de4bc0:	e395      	b.n	c0de52ee <nbgl_layoutAddHeader+0x7ae>
    switch (headerDesc->type) {
c0de4bc2:	2a04      	cmp	r2, #4
c0de4bc4:	f000 80b8 	beq.w	c0de4d38 <nbgl_layoutAddHeader+0x1f8>
c0de4bc8:	2a05      	cmp	r2, #5
c0de4bca:	d06f      	beq.n	c0de4cac <nbgl_layoutAddHeader+0x16c>
c0de4bcc:	2a06      	cmp	r2, #6
c0de4bce:	f040 83e0 	bne.w	c0de5392 <nbgl_layoutAddHeader+0x852>
            textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de4bd2:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de4bd6:	08c1      	lsrs	r1, r0, #3
c0de4bd8:	2004      	movs	r0, #4
c0de4bda:	f003 ffc4 	bl	c0de8b66 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de4bde:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de4be2:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de4be6:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de4bea:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de4bee:	2a0e      	cmp	r2, #14
c0de4bf0:	bf84      	itt	hi
c0de4bf2:	f04f 30ff 	movhi.w	r0, #4294967295	@ 0xffffffff
}
c0de4bf6:	e8bd 8df0 	ldmiahi.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de4bfa:	4606      	mov	r6, r0
c0de4bfc:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de4bfe:	3001      	adds	r0, #1
c0de4c00:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de4c04:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de4c08:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
                                       headerDesc->rightText.token,
c0de4c0c:	f89b c008 	ldrb.w	ip, [fp, #8]
                                       headerDesc->rightText.tuneId);
c0de4c10:	f89b 7009 	ldrb.w	r7, [fp, #9]
        layout->nbUsedCallbackObjs++;
c0de4c14:	0a00      	lsrs	r0, r0, #8
c0de4c16:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de4c1a:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de4c1e:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de4c20:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de4c24:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
c0de4c28:	2020      	movs	r0, #32
        layout->nbUsedCallbackObjs++;
c0de4c2a:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
            textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de4c2e:	7530      	strb	r0, [r6, #20]
c0de4c30:	20a0      	movs	r0, #160	@ 0xa0
            textArea->obj.area.width       = AVAILABLE_WIDTH;
c0de4c32:	7130      	strb	r0, [r6, #4]
c0de4c34:	2060      	movs	r0, #96	@ 0x60
            textArea->obj.area.height      = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de4c36:	4637      	mov	r7, r6
c0de4c38:	f04f 0806 	mov.w	r8, #6
c0de4c3c:	f04f 0a00 	mov.w	sl, #0
c0de4c40:	2501      	movs	r5, #1
c0de4c42:	f807 0f06 	strb.w	r0, [r7, #6]!
            textArea->obj.alignment        = MID_RIGHT;
c0de4c46:	f886 800b 	strb.w	r8, [r6, #11]
            textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de4c4a:	f886 a015 	strb.w	sl, [r6, #21]
            textArea->textColor            = BLACK;
c0de4c4e:	f886 a01c 	strb.w	sl, [r6, #28]
            textArea->obj.area.width       = AVAILABLE_WIDTH;
c0de4c52:	7175      	strb	r5, [r6, #5]
            textArea->obj.area.height      = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de4c54:	f887 a001 	strb.w	sl, [r7, #1]
            textArea->text                 = PIC(headerDesc->rightText.text);
c0de4c58:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de4c5c:	f004 feaa 	bl	c0de99b4 <pic>
c0de4c60:	4631      	mov	r1, r6
c0de4c62:	f801 0f23 	strb.w	r0, [r1, #35]!
c0de4c66:	0e02      	lsrs	r2, r0, #24
c0de4c68:	70ca      	strb	r2, [r1, #3]
c0de4c6a:	0c02      	lsrs	r2, r0, #16
c0de4c6c:	0a00      	lsrs	r0, r0, #8
c0de4c6e:	708a      	strb	r2, [r1, #2]
c0de4c70:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
c0de4c74:	200c      	movs	r0, #12
            textArea->obj.touchMask        = (1 << TOUCHED);
c0de4c76:	7635      	strb	r5, [r6, #24]
            textArea->fontId               = SMALL_BOLD_FONT;
c0de4c78:	77f0      	strb	r0, [r6, #31]
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4c7a:	68e0      	ldr	r0, [r4, #12]
            textArea->textAlignment        = MID_RIGHT;
c0de4c7c:	f886 801d 	strb.w	r8, [r6, #29]
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4c80:	f810 cf1c 	ldrb.w	ip, [r0, #28]!
            textArea->obj.touchMask        = (1 << TOUCHED);
c0de4c84:	f886 a019 	strb.w	sl, [r6, #25]
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4c88:	7842      	ldrb	r2, [r0, #1]
c0de4c8a:	7883      	ldrb	r3, [r0, #2]
c0de4c8c:	78c1      	ldrb	r1, [r0, #3]
c0de4c8e:	7940      	ldrb	r0, [r0, #5]
c0de4c90:	ea4c 2202 	orr.w	r2, ip, r2, lsl #8
c0de4c94:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de4c98:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
                = (nbgl_obj_t *) textArea;
c0de4c9c:	f841 6020 	str.w	r6, [r1, r0, lsl #2]
            layoutInt->headerContainer->nbChildren++;
c0de4ca0:	68e0      	ldr	r0, [r4, #12]
c0de4ca2:	2105      	movs	r1, #5
c0de4ca4:	f890 2021 	ldrb.w	r2, [r0, #33]	@ 0x21
            textArea->obj.touchId          = TOP_RIGHT_BUTTON_ID;
c0de4ca8:	76b1      	strb	r1, [r6, #26]
c0de4caa:	e081      	b.n	c0de4db0 <nbgl_layoutAddHeader+0x270>
c0de4cac:	f8db 0008 	ldr.w	r0, [fp, #8]
c0de4cb0:	f004 fe80 	bl	c0de99b4 <pic>
c0de4cb4:	4680      	mov	r8, r0
            uint8_t        backToken    = (headerDesc->type == HEADER_EXTENDED_BACK)
c0de4cb6:	f89b 0000 	ldrb.w	r0, [fp]
c0de4cba:	210c      	movs	r1, #12
c0de4cbc:	2805      	cmp	r0, #5
c0de4cbe:	bf08      	it	eq
c0de4cc0:	2111      	moveq	r1, #17
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de4cc2:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de4cc6:	f81b 6001 	ldrb.w	r6, [fp, r1]
c0de4cca:	08c1      	lsrs	r1, r0, #3
c0de4ccc:	2005      	movs	r0, #5
c0de4cce:	f003 ff4a 	bl	c0de8b66 <nbgl_objPoolGet>
c0de4cd2:	4682      	mov	sl, r0
            if (backToken != NBGL_INVALID_TOKEN) {
c0de4cd4:	2eff      	cmp	r6, #255	@ 0xff
c0de4cd6:	f04f 0c03 	mov.w	ip, #3
c0de4cda:	d025      	beq.n	c0de4d28 <nbgl_layoutAddHeader+0x1e8>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de4cdc:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de4ce0:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de4ce4:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de4ce8:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de4cec:	2a0e      	cmp	r2, #14
c0de4cee:	d867      	bhi.n	c0de4dc0 <nbgl_layoutAddHeader+0x280>
c0de4cf0:	0a0b      	lsrs	r3, r1, #8
                                           (headerDesc->type == HEADER_EXTENDED_BACK)
c0de4cf2:	f89b 7000 	ldrb.w	r7, [fp]
c0de4cf6:	200d      	movs	r0, #13
        layout->nbUsedCallbackObjs++;
c0de4cf8:	3301      	adds	r3, #1
                                           (headerDesc->type == HEADER_EXTENDED_BACK)
c0de4cfa:	2f05      	cmp	r7, #5
c0de4cfc:	bf08      	it	eq
c0de4cfe:	2013      	moveq	r0, #19
        layout->nbUsedCallbackObjs++;
c0de4d00:	f003 033f 	and.w	r3, r3, #63	@ 0x3f
c0de4d04:	f401 4740 	and.w	r7, r1, #49152	@ 0xc000
c0de4d08:	f81b 0000 	ldrb.w	r0, [fp, r0]
        layoutObj = &layout->callbackObjPool[layout->nbUsedCallbackObjs];
c0de4d0c:	eb04 02c2 	add.w	r2, r4, r2, lsl #3
        layout->nbUsedCallbackObjs++;
c0de4d10:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
        layoutObj->obj    = obj;
c0de4d14:	f842 af20 	str.w	sl, [r2, #32]!
        layout->nbUsedCallbackObjs++;
c0de4d18:	0a1b      	lsrs	r3, r3, #8
c0de4d1a:	f884 30ae 	strb.w	r3, [r4, #174]	@ 0xae
c0de4d1e:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
        layoutObj->token  = token;
c0de4d22:	7116      	strb	r6, [r2, #4]
        layoutObj->tuneId = tuneId;
c0de4d24:	7190      	strb	r0, [r2, #6]
c0de4d26:	e04c      	b.n	c0de4dc2 <nbgl_layoutAddHeader+0x282>
c0de4d28:	2103      	movs	r1, #3
c0de4d2a:	e04e      	b.n	c0de4dca <nbgl_layoutAddHeader+0x28a>
            layoutInt->headerContainer->obj.area.height = headerDesc->emptySpace.height;
c0de4d2c:	f8bb 0004 	ldrh.w	r0, [fp, #4]
c0de4d30:	7188      	strb	r0, [r1, #6]
c0de4d32:	0a00      	lsrs	r0, r0, #8
c0de4d34:	71c8      	strb	r0, [r1, #7]
c0de4d36:	e2da      	b.n	c0de52ee <nbgl_layoutAddHeader+0x7ae>
            textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de4d38:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de4d3c:	08c1      	lsrs	r1, r0, #3
c0de4d3e:	2004      	movs	r0, #4
c0de4d40:	f003 ff11 	bl	c0de8b66 <nbgl_objPoolGet>
c0de4d44:	4606      	mov	r6, r0
c0de4d46:	2101      	movs	r1, #1
            textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de4d48:	7171      	strb	r1, [r6, #5]
c0de4d4a:	21a0      	movs	r1, #160	@ 0xa0
c0de4d4c:	7131      	strb	r1, [r6, #4]
c0de4d4e:	2160      	movs	r1, #96	@ 0x60
            textArea->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de4d50:	4637      	mov	r7, r6
c0de4d52:	2000      	movs	r0, #0
c0de4d54:	f807 1f06 	strb.w	r1, [r7, #6]!
            textArea->textColor = BLACK;
c0de4d58:	7730      	strb	r0, [r6, #28]
            textArea->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de4d5a:	7078      	strb	r0, [r7, #1]
            textArea->text            = PIC(headerDesc->title.text);
c0de4d5c:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de4d60:	f004 fe28 	bl	c0de99b4 <pic>
c0de4d64:	4631      	mov	r1, r6
c0de4d66:	f801 0f23 	strb.w	r0, [r1, #35]!
c0de4d6a:	0e02      	lsrs	r2, r0, #24
c0de4d6c:	70ca      	strb	r2, [r1, #3]
c0de4d6e:	0c02      	lsrs	r2, r0, #16
c0de4d70:	708a      	strb	r2, [r1, #2]
            textArea->wrapping        = true;
c0de4d72:	f896 1021 	ldrb.w	r1, [r6, #33]	@ 0x21
            textArea->text            = PIC(headerDesc->title.text);
c0de4d76:	0a00      	lsrs	r0, r0, #8
c0de4d78:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
            textArea->wrapping        = true;
c0de4d7c:	f041 0001 	orr.w	r0, r1, #1
c0de4d80:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4d84:	68e0      	ldr	r0, [r4, #12]
c0de4d86:	210c      	movs	r1, #12
c0de4d88:	f810 cf1c 	ldrb.w	ip, [r0, #28]!
            textArea->fontId          = SMALL_BOLD_FONT;
c0de4d8c:	77f1      	strb	r1, [r6, #31]
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4d8e:	7841      	ldrb	r1, [r0, #1]
c0de4d90:	7883      	ldrb	r3, [r0, #2]
c0de4d92:	78c2      	ldrb	r2, [r0, #3]
c0de4d94:	7940      	ldrb	r0, [r0, #5]
c0de4d96:	ea4c 2101 	orr.w	r1, ip, r1, lsl #8
c0de4d9a:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de4d9e:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
                = (nbgl_obj_t *) textArea;
c0de4da2:	f841 6020 	str.w	r6, [r1, r0, lsl #2]
            layoutInt->headerContainer->nbChildren++;
c0de4da6:	68e0      	ldr	r0, [r4, #12]
c0de4da8:	2105      	movs	r1, #5
c0de4daa:	f890 2021 	ldrb.w	r2, [r0, #33]	@ 0x21
            textArea->textAlignment   = CENTER;
c0de4dae:	7771      	strb	r1, [r6, #29]
c0de4db0:	1c51      	adds	r1, r2, #1
c0de4db2:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
c0de4db6:	7879      	ldrb	r1, [r7, #1]
c0de4db8:	783a      	ldrb	r2, [r7, #0]
c0de4dba:	71c1      	strb	r1, [r0, #7]
c0de4dbc:	7182      	strb	r2, [r0, #6]
c0de4dbe:	e296      	b.n	c0de52ee <nbgl_layoutAddHeader+0x7ae>
c0de4dc0:	2200      	movs	r2, #0
                if (obj == NULL) {
c0de4dc2:	2a00      	cmp	r2, #0
c0de4dc4:	f000 81c9 	beq.w	c0de515a <nbgl_layoutAddHeader+0x61a>
c0de4dc8:	2100      	movs	r1, #0
            if (backToken != NBGL_INVALID_TOKEN) {
c0de4dca:	3eff      	subs	r6, #255	@ 0xff
c0de4dcc:	f04f 0004 	mov.w	r0, #4
c0de4dd0:	bf18      	it	ne
c0de4dd2:	2601      	movne	r6, #1
            button->obj.alignment   = MID_LEFT;
c0de4dd4:	f88a 000b 	strb.w	r0, [sl, #11]
c0de4dd8:	2068      	movs	r0, #104	@ 0x68
            button->obj.area.width  = BACK_KEY_WIDTH;
c0de4dda:	f88a 0004 	strb.w	r0, [sl, #4]
c0de4dde:	2060      	movs	r0, #96	@ 0x60
c0de4de0:	2700      	movs	r7, #0
            button->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de4de2:	f88a 0006 	strb.w	r0, [sl, #6]
            button->text            = NULL;
c0de4de6:	4650      	mov	r0, sl
c0de4de8:	f800 7f1c 	strb.w	r7, [r0, #28]!
            button->innerColor      = WHITE;
c0de4dec:	f88a c028 	strb.w	ip, [sl, #40]	@ 0x28
            button->foregroundColor = (backToken != NBGL_INVALID_TOKEN) ? BLACK : WHITE;
c0de4df0:	f88a 102a 	strb.w	r1, [sl, #42]	@ 0x2a
            button->borderColor     = WHITE;
c0de4df4:	f88a c029 	strb.w	ip, [sl, #41]	@ 0x29
            button->obj.area.width  = BACK_KEY_WIDTH;
c0de4df8:	f88a 7005 	strb.w	r7, [sl, #5]
            button->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de4dfc:	f88a 7007 	strb.w	r7, [sl, #7]
            button->text            = NULL;
c0de4e00:	f88a 701d 	strb.w	r7, [sl, #29]
c0de4e04:	70c7      	strb	r7, [r0, #3]
c0de4e06:	7087      	strb	r7, [r0, #2]
            button->icon            = PIC(&LEFT_ARROW_ICON);
c0de4e08:	f245 60b2 	movw	r0, #22194	@ 0x56b2
c0de4e0c:	f2c0 0000 	movt	r0, #0
c0de4e10:	4478      	add	r0, pc
c0de4e12:	f004 fdcf 	bl	c0de99b4 <pic>
c0de4e16:	4651      	mov	r1, sl
c0de4e18:	f801 0f24 	strb.w	r0, [r1, #36]!
c0de4e1c:	0e02      	lsrs	r2, r0, #24
c0de4e1e:	0c03      	lsrs	r3, r0, #16
c0de4e20:	0a00      	lsrs	r0, r0, #8
c0de4e22:	708b      	strb	r3, [r1, #2]
c0de4e24:	f88a 0025 	strb.w	r0, [sl, #37]	@ 0x25
            button->obj.touchMask   = (backToken != NBGL_INVALID_TOKEN) ? (1 << TOUCHED) : 0;
c0de4e28:	f88a 6018 	strb.w	r6, [sl, #24]
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4e2c:	68e0      	ldr	r0, [r4, #12]
            button->icon            = PIC(&LEFT_ARROW_ICON);
c0de4e2e:	70ca      	strb	r2, [r1, #3]
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4e30:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
            if (text != NULL) {
c0de4e34:	f1b8 0f00 	cmp.w	r8, #0
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4e38:	7842      	ldrb	r2, [r0, #1]
c0de4e3a:	7883      	ldrb	r3, [r0, #2]
c0de4e3c:	78c6      	ldrb	r6, [r0, #3]
c0de4e3e:	7940      	ldrb	r0, [r0, #5]
c0de4e40:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de4e44:	ea43 2206 	orr.w	r2, r3, r6, lsl #8
c0de4e48:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
                = (nbgl_obj_t *) button;
c0de4e4c:	f841 a020 	str.w	sl, [r1, r0, lsl #2]
            layoutInt->headerContainer->nbChildren++;
c0de4e50:	68e0      	ldr	r0, [r4, #12]
c0de4e52:	f04f 0106 	mov.w	r1, #6
c0de4e56:	f890 2021 	ldrb.w	r2, [r0, #33]	@ 0x21
            button->obj.touchId     = BACK_BUTTON_ID;
c0de4e5a:	f88a 101a 	strb.w	r1, [sl, #26]
            layoutInt->headerContainer->nbChildren++;
c0de4e5e:	f102 0101 	add.w	r1, r2, #1
            button->obj.touchMask   = (backToken != NBGL_INVALID_TOKEN) ? (1 << TOUCHED) : 0;
c0de4e62:	f88a 7019 	strb.w	r7, [sl, #25]
            layoutInt->headerContainer->nbChildren++;
c0de4e66:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
            if (text != NULL) {
c0de4e6a:	f000 8108 	beq.w	c0de507e <nbgl_layoutAddHeader+0x53e>
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de4e6e:	f89b 0000 	ldrb.w	r0, [fp]
c0de4e72:	2500      	movs	r5, #0
c0de4e74:	2802      	cmp	r0, #2
c0de4e76:	d12e      	bne.n	c0de4ed6 <nbgl_layoutAddHeader+0x396>
                    image         = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de4e78:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de4e7c:	08c1      	lsrs	r1, r0, #3
c0de4e7e:	2002      	movs	r0, #2
c0de4e80:	f003 fe71 	bl	c0de8b66 <nbgl_objPoolGet>
                    image->buffer = PIC(headerDesc->backAndText.icon);
c0de4e84:	f8db 1004 	ldr.w	r1, [fp, #4]
                    image         = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de4e88:	4606      	mov	r6, r0
                    image->buffer = PIC(headerDesc->backAndText.icon);
c0de4e8a:	4608      	mov	r0, r1
c0de4e8c:	f004 fd92 	bl	c0de99b4 <pic>
c0de4e90:	4631      	mov	r1, r6
c0de4e92:	f801 0f1c 	strb.w	r0, [r1, #28]!
c0de4e96:	0e02      	lsrs	r2, r0, #24
c0de4e98:	0c03      	lsrs	r3, r0, #16
c0de4e9a:	0a00      	lsrs	r0, r0, #8
c0de4e9c:	708b      	strb	r3, [r1, #2]
c0de4e9e:	7770      	strb	r0, [r6, #29]
                    layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4ea0:	68e0      	ldr	r0, [r4, #12]
                    image->buffer = PIC(headerDesc->backAndText.icon);
c0de4ea2:	70ca      	strb	r2, [r1, #3]
                    layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4ea4:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
                    image->foregroundColor = BLACK;
c0de4ea8:	f886 5024 	strb.w	r5, [r6, #36]	@ 0x24
                    layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4eac:	7842      	ldrb	r2, [r0, #1]
c0de4eae:	7883      	ldrb	r3, [r0, #2]
c0de4eb0:	78c7      	ldrb	r7, [r0, #3]
c0de4eb2:	7940      	ldrb	r0, [r0, #5]
c0de4eb4:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de4eb8:	ea43 2207 	orr.w	r2, r3, r7, lsl #8
c0de4ebc:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
                        = (nbgl_obj_t *) image;
c0de4ec0:	f841 6020 	str.w	r6, [r1, r0, lsl #2]
                    layoutInt->headerContainer->nbChildren++;
c0de4ec4:	68e0      	ldr	r0, [r4, #12]
c0de4ec6:	2105      	movs	r1, #5
c0de4ec8:	f890 2021 	ldrb.w	r2, [r0, #33]	@ 0x21
                    image->obj.alignment   = CENTER;
c0de4ecc:	72f1      	strb	r1, [r6, #11]
                    layoutInt->headerContainer->nbChildren++;
c0de4ece:	1c51      	adds	r1, r2, #1
c0de4ed0:	4635      	mov	r5, r6
c0de4ed2:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
                textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de4ed6:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de4eda:	08c1      	lsrs	r1, r0, #3
c0de4edc:	2004      	movs	r0, #4
c0de4ede:	f003 fe42 	bl	c0de8b66 <nbgl_objPoolGet>
                if ((headerDesc->type == HEADER_EXTENDED_BACK)
c0de4ee2:	f89b 1000 	ldrb.w	r1, [fp]
                textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de4ee6:	4607      	mov	r7, r0
                    && (headerDesc->extendedBack.textToken != NBGL_INVALID_TOKEN)) {
c0de4ee8:	2905      	cmp	r1, #5
c0de4eea:	d110      	bne.n	c0de4f0e <nbgl_layoutAddHeader+0x3ce>
c0de4eec:	f89b 2010 	ldrb.w	r2, [fp, #16]
                if ((headerDesc->type == HEADER_EXTENDED_BACK)
c0de4ef0:	2aff      	cmp	r2, #255	@ 0xff
c0de4ef2:	d00c      	beq.n	c0de4f0e <nbgl_layoutAddHeader+0x3ce>
                                               headerDesc->extendedBack.tuneId);
c0de4ef4:	f89b 3013 	ldrb.w	r3, [fp, #19]
                    obj = layoutAddCallbackObj(layoutInt,
c0de4ef8:	4620      	mov	r0, r4
c0de4efa:	4639      	mov	r1, r7
c0de4efc:	f7fc f979 	bl	c0de11f2 <layoutAddCallbackObj>
                    if (obj == NULL) {
c0de4f00:	2800      	cmp	r0, #0
c0de4f02:	f000 812a 	beq.w	c0de515a <nbgl_layoutAddHeader+0x61a>
c0de4f06:	2000      	movs	r0, #0
                    textArea->obj.touchMask = (1 << TOUCHED);
c0de4f08:	7678      	strb	r0, [r7, #25]
c0de4f0a:	2001      	movs	r0, #1
c0de4f0c:	7638      	strb	r0, [r7, #24]
                    = layoutInt->headerContainer->obj.area.width - 2 * BACK_KEY_WIDTH;
c0de4f0e:	68e0      	ldr	r0, [r4, #12]
c0de4f10:	f04f 0c05 	mov.w	ip, #5
c0de4f14:	7901      	ldrb	r1, [r0, #4]
c0de4f16:	7942      	ldrb	r2, [r0, #5]
c0de4f18:	f04f 0e00 	mov.w	lr, #0
c0de4f1c:	ea41 2202 	orr.w	r2, r1, r2, lsl #8
c0de4f20:	f1a2 03d0 	sub.w	r3, r2, #208	@ 0xd0
c0de4f24:	713b      	strb	r3, [r7, #4]
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de4f26:	f89b 1000 	ldrb.w	r1, [fp]
                    = layoutInt->headerContainer->obj.area.width - 2 * BACK_KEY_WIDTH;
c0de4f2a:	0a1b      	lsrs	r3, r3, #8
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de4f2c:	2902      	cmp	r1, #2
                textArea->obj.alignment = CENTER;
c0de4f2e:	f887 c00b 	strb.w	ip, [r7, #11]
                textArea->textColor     = BLACK;
c0de4f32:	f887 e01c 	strb.w	lr, [r7, #28]
                    = layoutInt->headerContainer->obj.area.width - 2 * BACK_KEY_WIDTH;
c0de4f36:	717b      	strb	r3, [r7, #5]
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de4f38:	d114      	bne.n	c0de4f64 <nbgl_layoutAddHeader+0x424>
                    textArea->obj.area.width -= 16 + image->buffer->width;
c0de4f3a:	462b      	mov	r3, r5
c0de4f3c:	f813 6f1c 	ldrb.w	r6, [r3, #28]!
c0de4f40:	7858      	ldrb	r0, [r3, #1]
c0de4f42:	7899      	ldrb	r1, [r3, #2]
c0de4f44:	78db      	ldrb	r3, [r3, #3]
c0de4f46:	ea46 2000 	orr.w	r0, r6, r0, lsl #8
c0de4f4a:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de4f4e:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de4f52:	7801      	ldrb	r1, [r0, #0]
c0de4f54:	7840      	ldrb	r0, [r0, #1]
c0de4f56:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de4f5a:	1a10      	subs	r0, r2, r0
c0de4f5c:	38e0      	subs	r0, #224	@ 0xe0
c0de4f5e:	7138      	strb	r0, [r7, #4]
c0de4f60:	0a00      	lsrs	r0, r0, #8
c0de4f62:	7178      	strb	r0, [r7, #5]
                textArea->text            = text;
c0de4f64:	4638      	mov	r0, r7
c0de4f66:	f800 8f23 	strb.w	r8, [r0, #35]!
c0de4f6a:	2160      	movs	r1, #96	@ 0x60
                textArea->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de4f6c:	f800 1c1d 	strb.w	r1, [r0, #-29]
                textArea->text            = text;
c0de4f70:	ea4f 6118 	mov.w	r1, r8, lsr #24
                textArea->wrapping        = true;
c0de4f74:	f810 2c02 	ldrb.w	r2, [r0, #-2]
                textArea->text            = text;
c0de4f78:	70c1      	strb	r1, [r0, #3]
c0de4f7a:	ea4f 4118 	mov.w	r1, r8, lsr #16
c0de4f7e:	7081      	strb	r1, [r0, #2]
c0de4f80:	ea4f 2118 	mov.w	r1, r8, lsr #8
                textArea->wrapping        = true;
c0de4f84:	f042 0201 	orr.w	r2, r2, #1
                textArea->text            = text;
c0de4f88:	7041      	strb	r1, [r0, #1]
c0de4f8a:	210c      	movs	r1, #12
                textArea->wrapping        = true;
c0de4f8c:	f800 2c02 	strb.w	r2, [r0, #-2]
                textArea->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de4f90:	f800 ec1c 	strb.w	lr, [r0, #-28]
                textArea->fontId          = SMALL_BOLD_FONT;
c0de4f94:	f800 1c04 	strb.w	r1, [r0, #-4]
                textArea->textAlignment   = CENTER;
c0de4f98:	f800 cc06 	strb.w	ip, [r0, #-6]
                                               textArea->obj.area.width,
c0de4f9c:	f810 1c1f 	ldrb.w	r1, [r0, #-31]
c0de4fa0:	f810 3c1e 	ldrb.w	r3, [r0, #-30]
                uint8_t nbMaxLines        = (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) ? 1 : 2;
c0de4fa4:	f89b 0000 	ldrb.w	r0, [fp]
c0de4fa8:	2602      	movs	r6, #2
c0de4faa:	2802      	cmp	r0, #2
                                               textArea->obj.area.width,
c0de4fac:	ea41 2203 	orr.w	r2, r1, r3, lsl #8
                if (nbgl_getTextNbLinesInWidth(textArea->fontId,
c0de4fb0:	f04f 000c 	mov.w	r0, #12
c0de4fb4:	4641      	mov	r1, r8
c0de4fb6:	f04f 0301 	mov.w	r3, #1
                uint8_t nbMaxLines        = (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) ? 1 : 2;
c0de4fba:	bf08      	it	eq
c0de4fbc:	2601      	moveq	r6, #1
                if (nbgl_getTextNbLinesInWidth(textArea->fontId,
c0de4fbe:	f003 fdf0 	bl	c0de8ba2 <nbgl_getTextNbLinesInWidth>
c0de4fc2:	4286      	cmp	r6, r0
c0de4fc4:	d206      	bcs.n	c0de4fd4 <nbgl_layoutAddHeader+0x494>
                        = nbMaxLines * nbgl_getFontLineHeight(textArea->fontId);
c0de4fc6:	7ff8      	ldrb	r0, [r7, #31]
c0de4fc8:	f003 fde1 	bl	c0de8b8e <nbgl_getFontLineHeight>
c0de4fcc:	4370      	muls	r0, r6
c0de4fce:	71b8      	strb	r0, [r7, #6]
c0de4fd0:	0a00      	lsrs	r0, r0, #8
c0de4fd2:	71f8      	strb	r0, [r7, #7]
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de4fd4:	f89b 0000 	ldrb.w	r0, [fp]
c0de4fd8:	2802      	cmp	r0, #2
c0de4fda:	d114      	bne.n	c0de5006 <nbgl_layoutAddHeader+0x4c6>
                    textArea->obj.area.width = nbgl_getTextWidth(textArea->fontId, textArea->text);
c0de4fdc:	463e      	mov	r6, r7
c0de4fde:	f816 cf23 	ldrb.w	ip, [r6, #35]!
c0de4fe2:	7872      	ldrb	r2, [r6, #1]
c0de4fe4:	78b3      	ldrb	r3, [r6, #2]
c0de4fe6:	78f1      	ldrb	r1, [r6, #3]
c0de4fe8:	f816 0c04 	ldrb.w	r0, [r6, #-4]
c0de4fec:	ea4c 2202 	orr.w	r2, ip, r2, lsl #8
c0de4ff0:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de4ff4:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de4ff8:	f003 fdd8 	bl	c0de8bac <nbgl_getTextWidth>
c0de4ffc:	f806 0c1f 	strb.w	r0, [r6, #-31]
c0de5000:	0a00      	lsrs	r0, r0, #8
c0de5002:	f806 0c1e 	strb.w	r0, [r6, #-30]
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de5006:	68e0      	ldr	r0, [r4, #12]
c0de5008:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
c0de500c:	7842      	ldrb	r2, [r0, #1]
c0de500e:	7883      	ldrb	r3, [r0, #2]
c0de5010:	78c6      	ldrb	r6, [r0, #3]
c0de5012:	7940      	ldrb	r0, [r0, #5]
c0de5014:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de5018:	ea43 2206 	orr.w	r2, r3, r6, lsl #8
c0de501c:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
                    = (nbgl_obj_t *) textArea;
c0de5020:	f841 7020 	str.w	r7, [r1, r0, lsl #2]
                layoutInt->headerContainer->nbChildren++;
c0de5024:	68e0      	ldr	r0, [r4, #12]
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de5026:	f89b 2000 	ldrb.w	r2, [fp]
                layoutInt->headerContainer->nbChildren++;
c0de502a:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de502e:	2a02      	cmp	r2, #2
                layoutInt->headerContainer->nbChildren++;
c0de5030:	f101 0101 	add.w	r1, r1, #1
c0de5034:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de5038:	d121      	bne.n	c0de507e <nbgl_layoutAddHeader+0x53e>
                    textArea->obj.alignmentMarginX = 8 + image->buffer->width / 2;
c0de503a:	f815 0f1c 	ldrb.w	r0, [r5, #28]!
c0de503e:	7869      	ldrb	r1, [r5, #1]
c0de5040:	78aa      	ldrb	r2, [r5, #2]
c0de5042:	78eb      	ldrb	r3, [r5, #3]
c0de5044:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de5048:	ea42 2103 	orr.w	r1, r2, r3, lsl #8
c0de504c:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de5050:	7801      	ldrb	r1, [r0, #0]
c0de5052:	7840      	ldrb	r0, [r0, #1]
                    image->obj.alignmentMarginX    = -8 - textArea->obj.area.width / 2;
c0de5054:	797a      	ldrb	r2, [r7, #5]
                    textArea->obj.alignmentMarginX = 8 + image->buffer->width / 2;
c0de5056:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de505a:	2108      	movs	r1, #8
c0de505c:	eb01 0050 	add.w	r0, r1, r0, lsr #1
                    image->obj.alignmentMarginX    = -8 - textArea->obj.area.width / 2;
c0de5060:	7939      	ldrb	r1, [r7, #4]
                    textArea->obj.alignmentMarginX = 8 + image->buffer->width / 2;
c0de5062:	7538      	strb	r0, [r7, #20]
c0de5064:	0a00      	lsrs	r0, r0, #8
c0de5066:	7578      	strb	r0, [r7, #21]
                    image->obj.alignmentMarginX    = -8 - textArea->obj.area.width / 2;
c0de5068:	ea41 2002 	orr.w	r0, r1, r2, lsl #8
c0de506c:	f06f 0107 	mvn.w	r1, #7
c0de5070:	eba1 0050 	sub.w	r0, r1, r0, lsr #1
c0de5074:	f805 0c08 	strb.w	r0, [r5, #-8]
c0de5078:	0a00      	lsrs	r0, r0, #8
c0de507a:	f805 0c07 	strb.w	r0, [r5, #-7]
            if ((headerDesc->type == HEADER_EXTENDED_BACK)
c0de507e:	f89b 0000 	ldrb.w	r0, [fp]
c0de5082:	2500      	movs	r5, #0
                && (headerDesc->extendedBack.actionIcon)) {
c0de5084:	2805      	cmp	r0, #5
c0de5086:	f04f 0800 	mov.w	r8, #0
c0de508a:	d16c      	bne.n	c0de5166 <nbgl_layoutAddHeader+0x626>
c0de508c:	f8db 0004 	ldr.w	r0, [fp, #4]
            if ((headerDesc->type == HEADER_EXTENDED_BACK)
c0de5090:	2800      	cmp	r0, #0
c0de5092:	d066      	beq.n	c0de5162 <nbgl_layoutAddHeader+0x622>
                actionButton = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de5094:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de5098:	08c1      	lsrs	r1, r0, #3
c0de509a:	2005      	movs	r0, #5
c0de509c:	f003 fd63 	bl	c0de8b66 <nbgl_objPoolGet>
                if (headerDesc->extendedBack.actionToken != NBGL_INVALID_TOKEN) {
c0de50a0:	f89b 2012 	ldrb.w	r2, [fp, #18]
                actionButton = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de50a4:	4680      	mov	r8, r0
                if (headerDesc->extendedBack.actionToken != NBGL_INVALID_TOKEN) {
c0de50a6:	2aff      	cmp	r2, #255	@ 0xff
c0de50a8:	d00d      	beq.n	c0de50c6 <nbgl_layoutAddHeader+0x586>
                                               headerDesc->extendedBack.tuneId);
c0de50aa:	f89b 3013 	ldrb.w	r3, [fp, #19]
                    obj = layoutAddCallbackObj(layoutInt,
c0de50ae:	4620      	mov	r0, r4
c0de50b0:	4641      	mov	r1, r8
c0de50b2:	f7fc f89e 	bl	c0de11f2 <layoutAddCallbackObj>
                    if (obj == NULL) {
c0de50b6:	2800      	cmp	r0, #0
c0de50b8:	d04f      	beq.n	c0de515a <nbgl_layoutAddHeader+0x61a>
c0de50ba:	2000      	movs	r0, #0
                    actionButton->obj.touchMask = (1 << TOUCHED);
c0de50bc:	f888 0019 	strb.w	r0, [r8, #25]
c0de50c0:	2001      	movs	r0, #1
c0de50c2:	f888 0018 	strb.w	r0, [r8, #24]
c0de50c6:	2006      	movs	r0, #6
                actionButton->obj.alignment = MID_RIGHT;
c0de50c8:	f888 000b 	strb.w	r0, [r8, #11]
c0de50cc:	2003      	movs	r0, #3
                actionButton->innerColor    = WHITE;
c0de50ce:	f888 0028 	strb.w	r0, [r8, #40]	@ 0x28
                    = (headerDesc->extendedBack.actionToken != NBGL_INVALID_TOKEN) ? BLACK
c0de50d2:	f89b 1012 	ldrb.w	r1, [fp, #18]
                actionButton->borderColor     = WHITE;
c0de50d6:	f888 0029 	strb.w	r0, [r8, #41]	@ 0x29
                    = (headerDesc->extendedBack.actionToken != NBGL_INVALID_TOKEN) ? BLACK
c0de50da:	39ff      	subs	r1, #255	@ 0xff
c0de50dc:	fab1 f181 	clz	r1, r1
c0de50e0:	0949      	lsrs	r1, r1, #5
c0de50e2:	0049      	lsls	r1, r1, #1
c0de50e4:	f88a 102a 	strb.w	r1, [sl, #42]	@ 0x2a
c0de50e8:	2168      	movs	r1, #104	@ 0x68
                actionButton->obj.area.width  = BACK_KEY_WIDTH;
c0de50ea:	f888 1004 	strb.w	r1, [r8, #4]
c0de50ee:	2160      	movs	r1, #96	@ 0x60
c0de50f0:	2000      	movs	r0, #0
                actionButton->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de50f2:	f888 1006 	strb.w	r1, [r8, #6]
                actionButton->text            = NULL;
c0de50f6:	4641      	mov	r1, r8
c0de50f8:	f801 0f1c 	strb.w	r0, [r1, #28]!
                actionButton->obj.area.width  = BACK_KEY_WIDTH;
c0de50fc:	f888 0005 	strb.w	r0, [r8, #5]
                actionButton->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de5100:	f888 0007 	strb.w	r0, [r8, #7]
                actionButton->text            = NULL;
c0de5104:	f888 001d 	strb.w	r0, [r8, #29]
c0de5108:	70c8      	strb	r0, [r1, #3]
c0de510a:	7088      	strb	r0, [r1, #2]
                actionButton->icon            = PIC(headerDesc->extendedBack.actionIcon);
c0de510c:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de5110:	f004 fc50 	bl	c0de99b4 <pic>
c0de5114:	4641      	mov	r1, r8
c0de5116:	f801 0f24 	strb.w	r0, [r1, #36]!
c0de511a:	0c02      	lsrs	r2, r0, #16
c0de511c:	708a      	strb	r2, [r1, #2]
c0de511e:	0a02      	lsrs	r2, r0, #8
c0de5120:	f888 2025 	strb.w	r2, [r8, #37]	@ 0x25
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de5124:	68e2      	ldr	r2, [r4, #12]
                actionButton->icon            = PIC(headerDesc->extendedBack.actionIcon);
c0de5126:	0e00      	lsrs	r0, r0, #24
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de5128:	f812 3f1c 	ldrb.w	r3, [r2, #28]!
                actionButton->icon            = PIC(headerDesc->extendedBack.actionIcon);
c0de512c:	70c8      	strb	r0, [r1, #3]
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de512e:	7850      	ldrb	r0, [r2, #1]
c0de5130:	7891      	ldrb	r1, [r2, #2]
c0de5132:	78d6      	ldrb	r6, [r2, #3]
c0de5134:	7952      	ldrb	r2, [r2, #5]
c0de5136:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de513a:	ea41 2106 	orr.w	r1, r1, r6, lsl #8
c0de513e:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
                    = (nbgl_obj_t *) actionButton;
c0de5142:	f840 8022 	str.w	r8, [r0, r2, lsl #2]
                layoutInt->headerContainer->nbChildren++;
c0de5146:	68e0      	ldr	r0, [r4, #12]
c0de5148:	2108      	movs	r1, #8
c0de514a:	f890 2021 	ldrb.w	r2, [r0, #33]	@ 0x21
                actionButton->obj.touchId     = EXTRA_BUTTON_ID;
c0de514e:	f888 101a 	strb.w	r1, [r8, #26]
                layoutInt->headerContainer->nbChildren++;
c0de5152:	1c51      	adds	r1, r2, #1
c0de5154:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
c0de5158:	e005      	b.n	c0de5166 <nbgl_layoutAddHeader+0x626>
c0de515a:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
}
c0de515e:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de5162:	f04f 0800 	mov.w	r8, #0
            layoutInt->headerContainer->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de5166:	68e0      	ldr	r0, [r4, #12]
c0de5168:	2160      	movs	r1, #96	@ 0x60
c0de516a:	7181      	strb	r1, [r0, #6]
            if ((headerDesc->type == HEADER_EXTENDED_BACK)
c0de516c:	f89b 1000 	ldrb.w	r1, [fp]
            layoutInt->headerContainer->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de5170:	71c5      	strb	r5, [r0, #7]
                && (headerDesc->extendedBack.subText != NULL)) {
c0de5172:	2905      	cmp	r1, #5
c0de5174:	f040 80bb 	bne.w	c0de52ee <nbgl_layoutAddHeader+0x7ae>
c0de5178:	f8db 000c 	ldr.w	r0, [fp, #12]
            if ((headerDesc->type == HEADER_EXTENDED_BACK)
c0de517c:	2800      	cmp	r0, #0
c0de517e:	f000 80b6 	beq.w	c0de52ee <nbgl_layoutAddHeader+0x7ae>
                line                       = createHorizontalLine(layoutInt->layer);
c0de5182:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de5186:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de5188:	2003      	movs	r0, #3
c0de518a:	f003 fcec 	bl	c0de8b66 <nbgl_objPoolGet>
c0de518e:	22e0      	movs	r2, #224	@ 0xe0
c0de5190:	2501      	movs	r5, #1
    line->obj.area.width  = SCREEN_WIDTH;
c0de5192:	7102      	strb	r2, [r0, #4]
c0de5194:	2260      	movs	r2, #96	@ 0x60
    line->obj.area.height = 1;
c0de5196:	7185      	strb	r5, [r0, #6]
                line->obj.alignmentMarginY = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de5198:	7582      	strb	r2, [r0, #22]
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de519a:	68e2      	ldr	r2, [r4, #12]
c0de519c:	2100      	movs	r1, #0
c0de519e:	f812 3f1c 	ldrb.w	r3, [r2, #28]!
    line->obj.area.height = 1;
c0de51a2:	71c1      	strb	r1, [r0, #7]
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de51a4:	7856      	ldrb	r6, [r2, #1]
c0de51a6:	7891      	ldrb	r1, [r2, #2]
c0de51a8:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de51ac:	78d6      	ldrb	r6, [r2, #3]
c0de51ae:	7952      	ldrb	r2, [r2, #5]
c0de51b0:	ea41 2106 	orr.w	r1, r1, r6, lsl #8
c0de51b4:	ea43 4101 	orr.w	r1, r3, r1, lsl #16
                    = (nbgl_obj_t *) line;
c0de51b8:	f841 0022 	str.w	r0, [r1, r2, lsl #2]
                layoutInt->headerContainer->nbChildren++;
c0de51bc:	68e1      	ldr	r1, [r4, #12]
c0de51be:	f04f 0c02 	mov.w	ip, #2
c0de51c2:	f891 2021 	ldrb.w	r2, [r1, #33]	@ 0x21
c0de51c6:	f04f 0e00 	mov.w	lr, #0
    line->lineColor       = LIGHT_GRAY;
c0de51ca:	f880 c01d 	strb.w	ip, [r0, #29]
    line->obj.area.width  = SCREEN_WIDTH;
c0de51ce:	7145      	strb	r5, [r0, #5]
    line->direction       = HORIZONTAL;
c0de51d0:	7705      	strb	r5, [r0, #28]
    line->thickness       = 1;
c0de51d2:	7785      	strb	r5, [r0, #30]
                line->obj.alignment        = TOP_MIDDLE;
c0de51d4:	f880 c00b 	strb.w	ip, [r0, #11]
                line->obj.alignmentMarginY = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de51d8:	f880 e017 	strb.w	lr, [r0, #23]
                layoutInt->headerContainer->nbChildren++;
c0de51dc:	1c50      	adds	r0, r2, #1
c0de51de:	f881 0021 	strb.w	r0, [r1, #33]	@ 0x21
                subTextArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de51e2:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de51e6:	08c1      	lsrs	r1, r0, #3
c0de51e8:	2004      	movs	r0, #4
c0de51ea:	f003 fcbc 	bl	c0de8b66 <nbgl_objPoolGet>
c0de51ee:	4606      	mov	r6, r0
                subTextArea->textColor            = BLACK;
c0de51f0:	2000      	movs	r0, #0
c0de51f2:	7730      	strb	r0, [r6, #28]
                subTextArea->text                 = PIC(headerDesc->extendedBack.subText);
c0de51f4:	f8db 000c 	ldr.w	r0, [fp, #12]
c0de51f8:	f004 fbdc 	bl	c0de99b4 <pic>
c0de51fc:	4601      	mov	r1, r0
c0de51fe:	4630      	mov	r0, r6
c0de5200:	f800 1f23 	strb.w	r1, [r0, #35]!
c0de5204:	0e0a      	lsrs	r2, r1, #24
c0de5206:	70c2      	strb	r2, [r0, #3]
c0de5208:	0c0a      	lsrs	r2, r1, #16
c0de520a:	7082      	strb	r2, [r0, #2]
c0de520c:	0a08      	lsrs	r0, r1, #8
c0de520e:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
                subTextArea->textAlignment        = MID_LEFT;
c0de5212:	2004      	movs	r0, #4
                subTextArea->wrapping             = true;
c0de5214:	f896 2021 	ldrb.w	r2, [r6, #33]	@ 0x21
                subTextArea->textAlignment        = MID_LEFT;
c0de5218:	7770      	strb	r0, [r6, #29]
c0de521a:	200b      	movs	r0, #11
                subTextArea->fontId               = SMALL_REGULAR_FONT;
c0de521c:	77f0      	strb	r0, [r6, #31]
                subTextArea->wrapping             = true;
c0de521e:	f042 0001 	orr.w	r0, r2, #1
c0de5222:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
c0de5226:	2008      	movs	r0, #8
                subTextArea->obj.alignment        = BOTTOM_MIDDLE;
c0de5228:	72f0      	strb	r0, [r6, #11]
                subTextArea->obj.alignmentMarginY = SUB_HEADER_MARGIN;
c0de522a:	2000      	movs	r0, #0
c0de522c:	75f0      	strb	r0, [r6, #23]
c0de522e:	201c      	movs	r0, #28
c0de5230:	75b0      	strb	r0, [r6, #22]
c0de5232:	20a0      	movs	r0, #160	@ 0xa0
                subTextArea->obj.area.width       = AVAILABLE_WIDTH;
c0de5234:	7130      	strb	r0, [r6, #4]
                    = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de5236:	200b      	movs	r0, #11
c0de5238:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de523c:	2301      	movs	r3, #1
                subTextArea->obj.area.width       = AVAILABLE_WIDTH;
c0de523e:	7175      	strb	r5, [r6, #5]
                    = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de5240:	f003 fcaa 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de5244:	71b0      	strb	r0, [r6, #6]
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de5246:	68e1      	ldr	r1, [r4, #12]
                if (button != NULL) {
c0de5248:	f1ba 0f00 	cmp.w	sl, #0
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de524c:	f811 cf1c 	ldrb.w	ip, [r1, #28]!
c0de5250:	784b      	ldrb	r3, [r1, #1]
c0de5252:	f891 e002 	ldrb.w	lr, [r1, #2]
c0de5256:	78ca      	ldrb	r2, [r1, #3]
c0de5258:	7949      	ldrb	r1, [r1, #5]
c0de525a:	ea4c 2303 	orr.w	r3, ip, r3, lsl #8
c0de525e:	ea4e 2202 	orr.w	r2, lr, r2, lsl #8
c0de5262:	ea43 4202 	orr.w	r2, r3, r2, lsl #16
                    = (nbgl_obj_t *) subTextArea;
c0de5266:	f842 6021 	str.w	r6, [r2, r1, lsl #2]
                layoutInt->headerContainer->nbChildren++;
c0de526a:	68e1      	ldr	r1, [r4, #12]
                    = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de526c:	ea4f 2210 	mov.w	r2, r0, lsr #8
                    += subTextArea->obj.area.height + 2 * SUB_HEADER_MARGIN;
c0de5270:	f811 3f06 	ldrb.w	r3, [r1, #6]!
                    = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de5274:	71f2      	strb	r2, [r6, #7]
                layoutInt->headerContainer->nbChildren++;
c0de5276:	7eca      	ldrb	r2, [r1, #27]
                    += subTextArea->obj.area.height + 2 * SUB_HEADER_MARGIN;
c0de5278:	784e      	ldrb	r6, [r1, #1]
                layoutInt->headerContainer->nbChildren++;
c0de527a:	f102 0201 	add.w	r2, r2, #1
c0de527e:	76ca      	strb	r2, [r1, #27]
                    += subTextArea->obj.area.height + 2 * SUB_HEADER_MARGIN;
c0de5280:	ea43 2206 	orr.w	r2, r3, r6, lsl #8
c0de5284:	4402      	add	r2, r0
c0de5286:	f102 0238 	add.w	r2, r2, #56	@ 0x38
c0de528a:	700a      	strb	r2, [r1, #0]
c0de528c:	ea4f 2212 	mov.w	r2, r2, lsr #8
c0de5290:	704a      	strb	r2, [r1, #1]
                if (button != NULL) {
c0de5292:	d00e      	beq.n	c0de52b2 <nbgl_layoutAddHeader+0x772>
                        -= (subTextArea->obj.area.height + 2 * SUB_HEADER_MARGIN) / 2;
c0de5294:	f81a 1f16 	ldrb.w	r1, [sl, #22]!
c0de5298:	f100 0338 	add.w	r3, r0, #56	@ 0x38
c0de529c:	f89a 2001 	ldrb.w	r2, [sl, #1]
c0de52a0:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de52a4:	eba1 0153 	sub.w	r1, r1, r3, lsr #1
c0de52a8:	f88a 1000 	strb.w	r1, [sl]
c0de52ac:	0a09      	lsrs	r1, r1, #8
c0de52ae:	f88a 1001 	strb.w	r1, [sl, #1]
                if (textArea != NULL) {
c0de52b2:	b15f      	cbz	r7, c0de52cc <nbgl_layoutAddHeader+0x78c>
                        -= (subTextArea->obj.area.height + 2 * SUB_HEADER_MARGIN) / 2;
c0de52b4:	f817 1f16 	ldrb.w	r1, [r7, #22]!
c0de52b8:	f100 0338 	add.w	r3, r0, #56	@ 0x38
c0de52bc:	787a      	ldrb	r2, [r7, #1]
c0de52be:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de52c2:	eba1 0153 	sub.w	r1, r1, r3, lsr #1
c0de52c6:	7039      	strb	r1, [r7, #0]
c0de52c8:	0a09      	lsrs	r1, r1, #8
c0de52ca:	7079      	strb	r1, [r7, #1]
                if (actionButton != NULL) {
c0de52cc:	f1b8 0f00 	cmp.w	r8, #0
c0de52d0:	d00d      	beq.n	c0de52ee <nbgl_layoutAddHeader+0x7ae>
                        -= (subTextArea->obj.area.height + 2 * SUB_HEADER_MARGIN) / 2;
c0de52d2:	f818 1f16 	ldrb.w	r1, [r8, #22]!
c0de52d6:	3038      	adds	r0, #56	@ 0x38
c0de52d8:	f898 2001 	ldrb.w	r2, [r8, #1]
c0de52dc:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de52e0:	eba1 0050 	sub.w	r0, r1, r0, lsr #1
c0de52e4:	f888 0000 	strb.w	r0, [r8]
c0de52e8:	0a00      	lsrs	r0, r0, #8
c0de52ea:	f888 0001 	strb.w	r0, [r8, #1]
    if (headerDesc->separationLine) {
c0de52ee:	f89b 0001 	ldrb.w	r0, [fp, #1]
c0de52f2:	b338      	cbz	r0, c0de5344 <nbgl_layoutAddHeader+0x804>
        line                = createHorizontalLine(layoutInt->layer);
c0de52f4:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de52f8:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de52fa:	2003      	movs	r0, #3
c0de52fc:	f003 fc33 	bl	c0de8b66 <nbgl_objPoolGet>
c0de5300:	2102      	movs	r1, #2
    line->lineColor       = LIGHT_GRAY;
c0de5302:	7741      	strb	r1, [r0, #29]
c0de5304:	2101      	movs	r1, #1
c0de5306:	22e0      	movs	r2, #224	@ 0xe0
    line->obj.area.width  = SCREEN_WIDTH;
c0de5308:	7102      	strb	r2, [r0, #4]
c0de530a:	2200      	movs	r2, #0
    line->obj.area.height = 1;
c0de530c:	7181      	strb	r1, [r0, #6]
c0de530e:	71c2      	strb	r2, [r0, #7]
        layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de5310:	68e2      	ldr	r2, [r4, #12]
    line->obj.area.width  = SCREEN_WIDTH;
c0de5312:	7141      	strb	r1, [r0, #5]
        layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de5314:	f812 3f1c 	ldrb.w	r3, [r2, #28]!
    line->direction       = HORIZONTAL;
c0de5318:	7701      	strb	r1, [r0, #28]
    line->thickness       = 1;
c0de531a:	7781      	strb	r1, [r0, #30]
        layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de531c:	7851      	ldrb	r1, [r2, #1]
c0de531e:	7897      	ldrb	r7, [r2, #2]
c0de5320:	78d6      	ldrb	r6, [r2, #3]
c0de5322:	7952      	ldrb	r2, [r2, #5]
c0de5324:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de5328:	ea47 2306 	orr.w	r3, r7, r6, lsl #8
c0de532c:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
            = (nbgl_obj_t *) line;
c0de5330:	f841 0022 	str.w	r0, [r1, r2, lsl #2]
        layoutInt->headerContainer->nbChildren++;
c0de5334:	68e1      	ldr	r1, [r4, #12]
c0de5336:	2208      	movs	r2, #8
c0de5338:	f891 3021 	ldrb.w	r3, [r1, #33]	@ 0x21
        line->obj.alignment = BOTTOM_MIDDLE;
c0de533c:	72c2      	strb	r2, [r0, #11]
        layoutInt->headerContainer->nbChildren++;
c0de533e:	1c58      	adds	r0, r3, #1
c0de5340:	f881 0021 	strb.w	r0, [r1, #33]	@ 0x21
    layoutInt->children[HEADER_INDEX] = (nbgl_obj_t *) layoutInt->headerContainer;
c0de5344:	e9d4 0102 	ldrd	r0, r1, [r4, #8]
c0de5348:	6001      	str	r1, [r0, #0]
    layoutInt->container->obj.area.height -= layoutInt->headerContainer->obj.area.height;
c0de534a:	68e0      	ldr	r0, [r4, #12]
c0de534c:	f8d4 30a0 	ldr.w	r3, [r4, #160]	@ 0xa0
c0de5350:	4601      	mov	r1, r0
c0de5352:	f811 2f06 	ldrb.w	r2, [r1, #6]!
c0de5356:	784f      	ldrb	r7, [r1, #1]
    layoutInt->container->obj.alignTo   = (nbgl_obj_t *) layoutInt->headerContainer;
c0de5358:	f803 0f10 	strb.w	r0, [r3, #16]!
    layoutInt->container->obj.area.height -= layoutInt->headerContainer->obj.area.height;
c0de535c:	f813 6d0a 	ldrb.w	r6, [r3, #-10]!
c0de5360:	ea42 2207 	orr.w	r2, r2, r7, lsl #8
c0de5364:	785d      	ldrb	r5, [r3, #1]
c0de5366:	ea46 2705 	orr.w	r7, r6, r5, lsl #8
c0de536a:	1aba      	subs	r2, r7, r2
c0de536c:	701a      	strb	r2, [r3, #0]
c0de536e:	0a12      	lsrs	r2, r2, #8
c0de5370:	705a      	strb	r2, [r3, #1]
    layoutInt->container->obj.alignTo   = (nbgl_obj_t *) layoutInt->headerContainer;
c0de5372:	0e02      	lsrs	r2, r0, #24
c0de5374:	735a      	strb	r2, [r3, #13]
c0de5376:	0c02      	lsrs	r2, r0, #16
c0de5378:	0a00      	lsrs	r0, r0, #8
c0de537a:	731a      	strb	r2, [r3, #12]
c0de537c:	72d8      	strb	r0, [r3, #11]
c0de537e:	2007      	movs	r0, #7
    layoutInt->container->obj.alignment = BOTTOM_LEFT;
c0de5380:	7158      	strb	r0, [r3, #5]
    layoutInt->headerType = headerDesc->type;
c0de5382:	f89b 0000 	ldrb.w	r0, [fp]
    return layoutInt->headerContainer->obj.area.height;
c0de5386:	780a      	ldrb	r2, [r1, #0]
c0de5388:	7849      	ldrb	r1, [r1, #1]
    layoutInt->headerType = headerDesc->type;
c0de538a:	f884 00aa 	strb.w	r0, [r4, #170]	@ 0xaa
    return layoutInt->headerContainer->obj.area.height;
c0de538e:	ea42 2001 	orr.w	r0, r2, r1, lsl #8
}
c0de5392:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de5396 <nbgl_layoutAddProgressIndicator>:
                                    uint8_t        activePage,
                                    uint8_t        nbPages,
                                    bool           withBack,
                                    uint8_t        backToken,
                                    tune_index_e   tuneId)
{
c0de5396:	b510      	push	{r4, lr}
c0de5398:	b086      	sub	sp, #24
c0de539a:	e9dd ec08 	ldrd	lr, ip, [sp, #32]
c0de539e:	2403      	movs	r4, #3
    nbgl_layoutHeader_t headerDesc = {.type                        = HEADER_BACK_AND_PROGRESS,
                                      .separationLine              = false,
                                      .progressAndBack.activePage  = activePage,
c0de53a0:	f88d 100c 	strb.w	r1, [sp, #12]
c0de53a4:	21ff      	movs	r1, #255	@ 0xff
    nbgl_layoutHeader_t headerDesc = {.type                        = HEADER_BACK_AND_PROGRESS,
c0de53a6:	f8ad 4004 	strh.w	r4, [sp, #4]
c0de53aa:	2400      	movs	r4, #0
                                      .progressAndBack.activePage  = activePage,
c0de53ac:	f88d 1010 	strb.w	r1, [sp, #16]
c0de53b0:	a901      	add	r1, sp, #4
c0de53b2:	9402      	str	r4, [sp, #8]
c0de53b4:	f88d 200d 	strb.w	r2, [sp, #13]
c0de53b8:	f88d 300e 	strb.w	r3, [sp, #14]
c0de53bc:	f88d e00f 	strb.w	lr, [sp, #15]
c0de53c0:	f88d c011 	strb.w	ip, [sp, #17]
                                      .progressAndBack.withBack    = withBack,
                                      .progressAndBack.actionIcon  = NULL,
                                      .progressAndBack.actionToken = NBGL_INVALID_TOKEN};
    LOG_DEBUG(LAYOUT_LOGGER, "nbgl_layoutAddProgressIndicator():\n");

    return nbgl_layoutAddHeader(layout, &headerDesc);
c0de53c4:	f7ff fbbc 	bl	c0de4b40 <nbgl_layoutAddHeader>
c0de53c8:	b006      	add	sp, #24
c0de53ca:	bd10      	pop	{r4, pc}

c0de53cc <nbgl_layoutDraw>:
 */
int nbgl_layoutDraw(nbgl_layout_t *layoutParam)
{
    nbgl_layoutInternal_t *layout = (nbgl_layoutInternal_t *) layoutParam;

    if (layout == NULL) {
c0de53cc:	2800      	cmp	r0, #0
c0de53ce:	bf04      	itt	eq
c0de53d0:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
    }
#endif  // TARGET_STAX
    nbgl_screenRedraw();

    return 0;
}
c0de53d4:	4770      	bxeq	lr
c0de53d6:	b510      	push	{r4, lr}
    if (layout->tapText) {
c0de53d8:	6981      	ldr	r1, [r0, #24]
c0de53da:	b1b9      	cbz	r1, c0de540c <nbgl_layoutDraw+0x40>
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de53dc:	f8d0 20a0 	ldr.w	r2, [r0, #160]	@ 0xa0
    layout->container->children[layout->container->nbChildren] = obj;
c0de53e0:	f812 cf1c 	ldrb.w	ip, [r2, #28]!
c0de53e4:	7853      	ldrb	r3, [r2, #1]
c0de53e6:	f892 e002 	ldrb.w	lr, [r2, #2]
c0de53ea:	78d4      	ldrb	r4, [r2, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de53ec:	7952      	ldrb	r2, [r2, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de53ee:	ea4c 2303 	orr.w	r3, ip, r3, lsl #8
c0de53f2:	ea4e 2404 	orr.w	r4, lr, r4, lsl #8
c0de53f6:	ea43 4304 	orr.w	r3, r3, r4, lsl #16
c0de53fa:	f843 1022 	str.w	r1, [r3, r2, lsl #2]
    layout->container->nbChildren++;
c0de53fe:	f8d0 00a0 	ldr.w	r0, [r0, #160]	@ 0xa0
c0de5402:	f890 1021 	ldrb.w	r1, [r0, #33]	@ 0x21
c0de5406:	3101      	adds	r1, #1
c0de5408:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
    nbgl_screenRedraw();
c0de540c:	f003 fb97 	bl	c0de8b3e <nbgl_screenRedraw>
c0de5410:	2000      	movs	r0, #0
c0de5412:	bd10      	pop	{r4, pc}

c0de5414 <nbgl_layoutRelease>:
 *
 * @param layoutParam layout to release
 * @return >= 0 if OK
 */
int nbgl_layoutRelease(nbgl_layout_t *layoutParam)
{
c0de5414:	b510      	push	{r4, lr}
    nbgl_layoutInternal_t *layout = (nbgl_layoutInternal_t *) layoutParam;
    LOG_DEBUG(PAGE_LOGGER, "nbgl_layoutRelease(): \n");
    if ((layout == NULL) || (!layout->isUsed)) {
c0de5416:	b140      	cbz	r0, c0de542a <nbgl_layoutRelease+0x16>
c0de5418:	4604      	mov	r4, r0
c0de541a:	f890 00ad 	ldrb.w	r0, [r0, #173]	@ 0xad
c0de541e:	f894 10ae 	ldrb.w	r1, [r4, #174]	@ 0xae
c0de5422:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de5426:	0441      	lsls	r1, r0, #17
c0de5428:	d402      	bmi.n	c0de5430 <nbgl_layoutRelease+0x1c>
c0de542a:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
            layout->top->bottom = layout->bottom;
        }
    }
    layout->isUsed = false;
    return 0;
}
c0de542e:	bd10      	pop	{r4, pc}
    if (layout->modal) {
c0de5430:	07c1      	lsls	r1, r0, #31
c0de5432:	d016      	beq.n	c0de5462 <nbgl_layoutRelease+0x4e>
        nbgl_screenPop(layout->layer);
c0de5434:	b2c0      	uxtb	r0, r0
c0de5436:	08c0      	lsrs	r0, r0, #3
c0de5438:	f003 fb86 	bl	c0de8b48 <nbgl_screenPop>
        if (layout == topLayout) {
c0de543c:	f240 40cc 	movw	r0, #1228	@ 0x4cc
c0de5440:	f2c0 0000 	movt	r0, #0
c0de5444:	f859 1000 	ldr.w	r1, [r9, r0]
c0de5448:	42a1      	cmp	r1, r4
c0de544a:	d005      	beq.n	c0de5458 <nbgl_layoutRelease+0x44>
            layout->bottom->top = layout->top;
c0de544c:	e9d4 0100 	ldrd	r0, r1, [r4]
c0de5450:	6008      	str	r0, [r1, #0]
            layout->top->bottom = layout->bottom;
c0de5452:	6820      	ldr	r0, [r4, #0]
c0de5454:	6041      	str	r1, [r0, #4]
c0de5456:	e004      	b.n	c0de5462 <nbgl_layoutRelease+0x4e>
            topLayout      = layout->bottom;
c0de5458:	6861      	ldr	r1, [r4, #4]
c0de545a:	f849 1000 	str.w	r1, [r9, r0]
c0de545e:	2000      	movs	r0, #0
            topLayout->top = NULL;
c0de5460:	6008      	str	r0, [r1, #0]
    layout->isUsed = false;
c0de5462:	f814 0fad 	ldrb.w	r0, [r4, #173]!
c0de5466:	7861      	ldrb	r1, [r4, #1]
c0de5468:	7020      	strb	r0, [r4, #0]
c0de546a:	f001 01bf 	and.w	r1, r1, #191	@ 0xbf
c0de546e:	2000      	movs	r0, #0
c0de5470:	7061      	strb	r1, [r4, #1]
}
c0de5472:	bd10      	pop	{r4, pc}

c0de5474 <animTickerCallback>:
{
c0de5474:	b570      	push	{r4, r5, r6, lr}
    nbgl_layoutInternal_t *layout = topLayout;
c0de5476:	f240 40cc 	movw	r0, #1228	@ 0x4cc
c0de547a:	f2c0 0000 	movt	r0, #0
c0de547e:	f859 6000 	ldr.w	r6, [r9, r0]
    if (!layout || !layout->isUsed || (layout->animation == NULL)) {
c0de5482:	2e00      	cmp	r6, #0
c0de5484:	d04b      	beq.n	c0de551e <animTickerCallback+0xaa>
c0de5486:	f896 00ae 	ldrb.w	r0, [r6, #174]	@ 0xae
c0de548a:	0200      	lsls	r0, r0, #8
c0de548c:	0440      	lsls	r0, r0, #17
c0de548e:	d546      	bpl.n	c0de551e <animTickerCallback+0xaa>
c0de5490:	f8d6 00a4 	ldr.w	r0, [r6, #164]	@ 0xa4
c0de5494:	2800      	cmp	r0, #0
c0de5496:	d042      	beq.n	c0de551e <animTickerCallback+0xaa>
c0de5498:	f8d6 00a0 	ldr.w	r0, [r6, #160]	@ 0xa0
c0de549c:	f890 2021 	ldrb.w	r2, [r0, #33]	@ 0x21
    while (i < layout->container->nbChildren) {
c0de54a0:	2a00      	cmp	r2, #0
}
c0de54a2:	bf08      	it	eq
c0de54a4:	bd70      	popeq	{r4, r5, r6, pc}
c0de54a6:	f810 cf1c 	ldrb.w	ip, [r0, #28]!
c0de54aa:	7843      	ldrb	r3, [r0, #1]
c0de54ac:	f890 e002 	ldrb.w	lr, [r0, #2]
c0de54b0:	78c0      	ldrb	r0, [r0, #3]
c0de54b2:	ea4c 2303 	orr.w	r3, ip, r3, lsl #8
c0de54b6:	ea4e 2000 	orr.w	r0, lr, r0, lsl #8
c0de54ba:	ea43 4300 	orr.w	r3, r3, r0, lsl #16
c0de54be:	e003      	b.n	c0de54c8 <animTickerCallback+0x54>
    while (i < layout->container->nbChildren) {
c0de54c0:	3a01      	subs	r2, #1
c0de54c2:	f103 0304 	add.w	r3, r3, #4
c0de54c6:	d02a      	beq.n	c0de551e <animTickerCallback+0xaa>
        if (layout->container->children[i]->type == CONTAINER) {
c0de54c8:	6818      	ldr	r0, [r3, #0]
c0de54ca:	7a81      	ldrb	r1, [r0, #10]
c0de54cc:	2901      	cmp	r1, #1
c0de54ce:	d1f7      	bne.n	c0de54c0 <animTickerCallback+0x4c>
            if (container->children[1]->type == IMAGE) {
c0de54d0:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
c0de54d4:	7844      	ldrb	r4, [r0, #1]
c0de54d6:	7885      	ldrb	r5, [r0, #2]
c0de54d8:	78c0      	ldrb	r0, [r0, #3]
c0de54da:	ea41 2104 	orr.w	r1, r1, r4, lsl #8
c0de54de:	ea45 2000 	orr.w	r0, r5, r0, lsl #8
c0de54e2:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de54e6:	6840      	ldr	r0, [r0, #4]
c0de54e8:	7a81      	ldrb	r1, [r0, #10]
c0de54ea:	2902      	cmp	r1, #2
c0de54ec:	d1e8      	bne.n	c0de54c0 <animTickerCallback+0x4c>
                if (layout->animation->parsing == LOOP_PARSING) {
c0de54ee:	f8d6 30a4 	ldr.w	r3, [r6, #164]	@ 0xa4
c0de54f2:	7959      	ldrb	r1, [r3, #5]
c0de54f4:	b1a1      	cbz	r1, c0de5520 <animTickerCallback+0xac>
                    if ((layout->incrementAnim)
c0de54f6:	f896 10ad 	ldrb.w	r1, [r6, #173]	@ 0xad
c0de54fa:	f896 20ae 	ldrb.w	r2, [r6, #174]	@ 0xae
c0de54fe:	ea41 2202 	orr.w	r2, r1, r2, lsl #8
                        && (layout->iconIdxInAnim >= layout->animation->nbIcons - 1)) {
c0de5502:	0751      	lsls	r1, r2, #29
c0de5504:	d505      	bpl.n	c0de5512 <animTickerCallback+0x9e>
c0de5506:	7919      	ldrb	r1, [r3, #4]
c0de5508:	f896 30af 	ldrb.w	r3, [r6, #175]	@ 0xaf
c0de550c:	3901      	subs	r1, #1
                    if ((layout->incrementAnim)
c0de550e:	4299      	cmp	r1, r3
c0de5510:	dd0e      	ble.n	c0de5530 <animTickerCallback+0xbc>
                    else if (layout->iconIdxInAnim == 0) {
c0de5512:	f896 10af 	ldrb.w	r1, [r6, #175]	@ 0xaf
c0de5516:	b991      	cbnz	r1, c0de553e <animTickerCallback+0xca>
                        layout->incrementAnim = true;
c0de5518:	f042 0204 	orr.w	r2, r2, #4
c0de551c:	e00a      	b.n	c0de5534 <animTickerCallback+0xc0>
}
c0de551e:	bd70      	pop	{r4, r5, r6, pc}
                    if (layout->iconIdxInAnim == (layout->animation->nbIcons - 1)) {
c0de5520:	7919      	ldrb	r1, [r3, #4]
c0de5522:	f896 20af 	ldrb.w	r2, [r6, #175]	@ 0xaf
c0de5526:	3901      	subs	r1, #1
c0de5528:	4291      	cmp	r1, r2
c0de552a:	d110      	bne.n	c0de554e <animTickerCallback+0xda>
c0de552c:	2100      	movs	r1, #0
c0de552e:	e00f      	b.n	c0de5550 <animTickerCallback+0xdc>
                        layout->incrementAnim = false;
c0de5530:	f022 0204 	bic.w	r2, r2, #4
c0de5534:	0a11      	lsrs	r1, r2, #8
c0de5536:	f886 20ad 	strb.w	r2, [r6, #173]	@ 0xad
c0de553a:	f886 10ae 	strb.w	r1, [r6, #174]	@ 0xae
                    if (layout->incrementAnim) {
c0de553e:	f896 10ad 	ldrb.w	r1, [r6, #173]	@ 0xad
c0de5542:	f896 20af 	ldrb.w	r2, [r6, #175]	@ 0xaf
c0de5546:	0749      	lsls	r1, r1, #29
c0de5548:	d401      	bmi.n	c0de554e <animTickerCallback+0xda>
                        layout->iconIdxInAnim--;
c0de554a:	1e51      	subs	r1, r2, #1
c0de554c:	e000      	b.n	c0de5550 <animTickerCallback+0xdc>
c0de554e:	1c51      	adds	r1, r2, #1
c0de5550:	f886 10af 	strb.w	r1, [r6, #175]	@ 0xaf
                image->buffer = layout->animation->icons[layout->iconIdxInAnim];
c0de5554:	f8d6 10a4 	ldr.w	r1, [r6, #164]	@ 0xa4
c0de5558:	f896 20af 	ldrb.w	r2, [r6, #175]	@ 0xaf
c0de555c:	6809      	ldr	r1, [r1, #0]
c0de555e:	f851 1022 	ldr.w	r1, [r1, r2, lsl #2]
c0de5562:	4602      	mov	r2, r0
c0de5564:	f802 1f1c 	strb.w	r1, [r2, #28]!
c0de5568:	0e0b      	lsrs	r3, r1, #24
c0de556a:	70d3      	strb	r3, [r2, #3]
c0de556c:	0c0b      	lsrs	r3, r1, #16
c0de556e:	0a09      	lsrs	r1, r1, #8
c0de5570:	7093      	strb	r3, [r2, #2]
c0de5572:	7741      	strb	r1, [r0, #29]
                nbgl_objDraw((nbgl_obj_t *) image);
c0de5574:	f003 facf 	bl	c0de8b16 <nbgl_objDraw>
                nbgl_refreshSpecialWithPostRefresh(BLACK_AND_WHITE_FAST_REFRESH,
c0de5578:	2004      	movs	r0, #4
c0de557a:	2101      	movs	r1, #1
c0de557c:	f003 fac1 	bl	c0de8b02 <nbgl_refreshSpecialWithPostRefresh>
}
c0de5580:	bd70      	pop	{r4, r5, r6, pc}

c0de5582 <layoutNavigationCallback>:
 */
bool layoutNavigationCallback(nbgl_obj_t      *obj,
                              nbgl_touchType_t eventType,
                              uint8_t          nbPages,
                              uint8_t         *activePage)
{
c0de5582:	b5b0      	push	{r4, r5, r7, lr}
    // if direct touch of buttons within the navigation bar, the given obj is
    // the touched object
    if (eventType == TOUCHED) {
c0de5584:	2908      	cmp	r1, #8
c0de5586:	d054      	beq.n	c0de5632 <layoutNavigationCallback+0xb0>
c0de5588:	2900      	cmp	r1, #0
c0de558a:	d174      	bne.n	c0de5676 <layoutNavigationCallback+0xf4>
        nbgl_container_t *navContainer = (nbgl_container_t *) obj->parent;
c0de558c:	4601      	mov	r1, r0
c0de558e:	f811 cf0c 	ldrb.w	ip, [r1, #12]!
c0de5592:	f890 e00d 	ldrb.w	lr, [r0, #13]
c0de5596:	788d      	ldrb	r5, [r1, #2]
c0de5598:	78c9      	ldrb	r1, [r1, #3]
c0de559a:	ea4c 240e 	orr.w	r4, ip, lr, lsl #8
c0de559e:	ea45 2101 	orr.w	r1, r5, r1, lsl #8
c0de55a2:	ea44 4c01 	orr.w	ip, r4, r1, lsl #16

        if (obj == navContainer->children[EXIT_BUTTON_INDEX]) {
c0de55a6:	4661      	mov	r1, ip
c0de55a8:	f811 ef1c 	ldrb.w	lr, [r1, #28]!
c0de55ac:	f89c 401d 	ldrb.w	r4, [ip, #29]
c0de55b0:	788d      	ldrb	r5, [r1, #2]
c0de55b2:	78c9      	ldrb	r1, [r1, #3]
c0de55b4:	ea4e 2404 	orr.w	r4, lr, r4, lsl #8
c0de55b8:	ea45 2101 	orr.w	r1, r5, r1, lsl #8
c0de55bc:	ea44 4e01 	orr.w	lr, r4, r1, lsl #16
c0de55c0:	f8de 1000 	ldr.w	r1, [lr]
c0de55c4:	4281      	cmp	r1, r0
c0de55c6:	d07e      	beq.n	c0de56c6 <layoutNavigationCallback+0x144>
            // fake page when Quit button is touched
            *activePage = EXIT_PAGE;
            return true;
        }
        else if (obj == navContainer->children[PREVIOUS_PAGE_INDEX]) {
c0de55c8:	f8de 1004 	ldr.w	r1, [lr, #4]
c0de55cc:	4281      	cmp	r1, r0
c0de55ce:	f000 8083 	beq.w	c0de56d8 <layoutNavigationCallback+0x156>
                *activePage = *activePage - 1;
                configButtons(navContainer, nbPages, *activePage);
                return true;
            }
        }
        else if (obj == navContainer->children[NEXT_PAGE_INDEX]) {
c0de55d2:	2a02      	cmp	r2, #2
c0de55d4:	f04f 0100 	mov.w	r1, #0
c0de55d8:	d37c      	bcc.n	c0de56d4 <layoutNavigationCallback+0x152>
c0de55da:	f8de 5008 	ldr.w	r5, [lr, #8]
c0de55de:	4285      	cmp	r5, r0
c0de55e0:	d178      	bne.n	c0de56d4 <layoutNavigationCallback+0x152>
            if ((nbPages >= 2) && (*activePage < (nbPages - 1))) {
c0de55e2:	7819      	ldrb	r1, [r3, #0]
c0de55e4:	1e50      	subs	r0, r2, #1
c0de55e6:	4288      	cmp	r0, r1
c0de55e8:	f340 80a0 	ble.w	c0de572c <layoutNavigationCallback+0x1aa>
                *activePage = *activePage + 1;
c0de55ec:	3101      	adds	r1, #1
c0de55ee:	7019      	strb	r1, [r3, #0]
    nbgl_button_t *buttonPrevious = (nbgl_button_t *) navContainer->children[PREVIOUS_PAGE_INDEX];
c0de55f0:	f81c 2f1c 	ldrb.w	r2, [ip, #28]!
c0de55f4:	f89c 3001 	ldrb.w	r3, [ip, #1]
c0de55f8:	f89c 5002 	ldrb.w	r5, [ip, #2]
c0de55fc:	f89c 4003 	ldrb.w	r4, [ip, #3]
c0de5600:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de5604:	ea45 2304 	orr.w	r3, r5, r4, lsl #8
c0de5608:	ea42 4203 	orr.w	r2, r2, r3, lsl #16
c0de560c:	e9d2 3201 	ldrd	r3, r2, [r2, #4]
    if (buttonPrevious) {
c0de5610:	b133      	cbz	r3, c0de5620 <layoutNavigationCallback+0x9e>
        buttonPrevious->foregroundColor = (navActivePage == 0) ? INACTIVE_COLOR : BLACK;
c0de5612:	b2cd      	uxtb	r5, r1
c0de5614:	fab5 f585 	clz	r5, r5
c0de5618:	096d      	lsrs	r5, r5, #5
c0de561a:	006d      	lsls	r5, r5, #1
c0de561c:	f883 502a 	strb.w	r5, [r3, #42]	@ 0x2a
        buttonNext->foregroundColor = (navActivePage == (navNbPages - 1)) ? INACTIVE_COLOR : BLACK;
c0de5620:	b2c9      	uxtb	r1, r1
c0de5622:	1a40      	subs	r0, r0, r1
c0de5624:	fab0 f080 	clz	r0, r0
c0de5628:	0940      	lsrs	r0, r0, #5
c0de562a:	0040      	lsls	r0, r0, #1
c0de562c:	f882 002a 	strb.w	r0, [r2, #42]	@ 0x2a
c0de5630:	e04f      	b.n	c0de56d2 <layoutNavigationCallback+0x150>
            }
        }
    }
    // otherwise the given object is the navigation container itself
    else if (eventType == SWIPED_RIGHT) {
        if (*activePage > 0) {
c0de5632:	7819      	ldrb	r1, [r3, #0]
c0de5634:	2900      	cmp	r1, #0
c0de5636:	d079      	beq.n	c0de572c <layoutNavigationCallback+0x1aa>
            *activePage = *activePage - 1;
c0de5638:	3901      	subs	r1, #1
c0de563a:	7019      	strb	r1, [r3, #0]
    nbgl_button_t *buttonPrevious = (nbgl_button_t *) navContainer->children[PREVIOUS_PAGE_INDEX];
c0de563c:	f810 3f1c 	ldrb.w	r3, [r0, #28]!
c0de5640:	7845      	ldrb	r5, [r0, #1]
c0de5642:	7884      	ldrb	r4, [r0, #2]
c0de5644:	78c0      	ldrb	r0, [r0, #3]
c0de5646:	ea43 2305 	orr.w	r3, r3, r5, lsl #8
c0de564a:	ea44 2000 	orr.w	r0, r4, r0, lsl #8
c0de564e:	ea43 4000 	orr.w	r0, r3, r0, lsl #16
c0de5652:	e9d0 3001 	ldrd	r3, r0, [r0, #4]
    if (buttonPrevious) {
c0de5656:	b133      	cbz	r3, c0de5666 <layoutNavigationCallback+0xe4>
        buttonPrevious->foregroundColor = (navActivePage == 0) ? INACTIVE_COLOR : BLACK;
c0de5658:	b2cd      	uxtb	r5, r1
c0de565a:	fab5 f585 	clz	r5, r5
c0de565e:	096d      	lsrs	r5, r5, #5
c0de5660:	006d      	lsls	r5, r5, #1
c0de5662:	f883 502a 	strb.w	r5, [r3, #42]	@ 0x2a
    if (navNbPages > 1) {
c0de5666:	2a02      	cmp	r2, #2
c0de5668:	d330      	bcc.n	c0de56cc <layoutNavigationCallback+0x14a>
c0de566a:	f06f 03ff 	mvn.w	r3, #255	@ 0xff
        buttonNext->foregroundColor = (navActivePage == (navNbPages - 1)) ? INACTIVE_COLOR : BLACK;
c0de566e:	ea63 0101 	orn	r1, r3, r1
c0de5672:	4411      	add	r1, r2
c0de5674:	e022      	b.n	c0de56bc <layoutNavigationCallback+0x13a>
            configButtons((nbgl_container_t *) obj, nbPages, *activePage);
            return true;
        }
    }
    else if (eventType == SWIPED_LEFT) {
c0de5676:	2909      	cmp	r1, #9
c0de5678:	f04f 0100 	mov.w	r1, #0
c0de567c:	d12a      	bne.n	c0de56d4 <layoutNavigationCallback+0x152>
c0de567e:	2a02      	cmp	r2, #2
c0de5680:	d328      	bcc.n	c0de56d4 <layoutNavigationCallback+0x152>
        if ((nbPages >= 2) && (*activePage < (nbPages - 1))) {
c0de5682:	7819      	ldrb	r1, [r3, #0]
c0de5684:	3a01      	subs	r2, #1
c0de5686:	428a      	cmp	r2, r1
c0de5688:	dd50      	ble.n	c0de572c <layoutNavigationCallback+0x1aa>
            *activePage = *activePage + 1;
c0de568a:	3101      	adds	r1, #1
c0de568c:	7019      	strb	r1, [r3, #0]
    nbgl_button_t *buttonPrevious = (nbgl_button_t *) navContainer->children[PREVIOUS_PAGE_INDEX];
c0de568e:	f810 3f1c 	ldrb.w	r3, [r0, #28]!
c0de5692:	7845      	ldrb	r5, [r0, #1]
c0de5694:	7884      	ldrb	r4, [r0, #2]
c0de5696:	78c0      	ldrb	r0, [r0, #3]
c0de5698:	ea43 2305 	orr.w	r3, r3, r5, lsl #8
c0de569c:	ea44 2000 	orr.w	r0, r4, r0, lsl #8
c0de56a0:	ea43 4000 	orr.w	r0, r3, r0, lsl #16
c0de56a4:	e9d0 3001 	ldrd	r3, r0, [r0, #4]
    if (buttonPrevious) {
c0de56a8:	b133      	cbz	r3, c0de56b8 <layoutNavigationCallback+0x136>
        buttonPrevious->foregroundColor = (navActivePage == 0) ? INACTIVE_COLOR : BLACK;
c0de56aa:	b2cd      	uxtb	r5, r1
c0de56ac:	fab5 f585 	clz	r5, r5
c0de56b0:	096d      	lsrs	r5, r5, #5
c0de56b2:	006d      	lsls	r5, r5, #1
c0de56b4:	f883 502a 	strb.w	r5, [r3, #42]	@ 0x2a
        buttonNext->foregroundColor = (navActivePage == (navNbPages - 1)) ? INACTIVE_COLOR : BLACK;
c0de56b8:	b2c9      	uxtb	r1, r1
c0de56ba:	1a51      	subs	r1, r2, r1
c0de56bc:	fab1 f181 	clz	r1, r1
c0de56c0:	0949      	lsrs	r1, r1, #5
c0de56c2:	0049      	lsls	r1, r1, #1
c0de56c4:	e003      	b.n	c0de56ce <layoutNavigationCallback+0x14c>
c0de56c6:	20ff      	movs	r0, #255	@ 0xff
            *activePage = EXIT_PAGE;
c0de56c8:	7018      	strb	r0, [r3, #0]
c0de56ca:	e002      	b.n	c0de56d2 <layoutNavigationCallback+0x150>
c0de56cc:	2102      	movs	r1, #2
c0de56ce:	f880 102a 	strb.w	r1, [r0, #42]	@ 0x2a
c0de56d2:	2101      	movs	r1, #1
            configButtons((nbgl_container_t *) obj, nbPages, *activePage);
            return true;
        }
    }
    return false;
}
c0de56d4:	4608      	mov	r0, r1
c0de56d6:	bdb0      	pop	{r4, r5, r7, pc}
            if (*activePage > 0) {
c0de56d8:	7818      	ldrb	r0, [r3, #0]
c0de56da:	b338      	cbz	r0, c0de572c <layoutNavigationCallback+0x1aa>
                *activePage = *activePage - 1;
c0de56dc:	3801      	subs	r0, #1
c0de56de:	7018      	strb	r0, [r3, #0]
    nbgl_button_t *buttonPrevious = (nbgl_button_t *) navContainer->children[PREVIOUS_PAGE_INDEX];
c0de56e0:	f81c 1f1c 	ldrb.w	r1, [ip, #28]!
c0de56e4:	f89c 3001 	ldrb.w	r3, [ip, #1]
c0de56e8:	f89c 5002 	ldrb.w	r5, [ip, #2]
c0de56ec:	f89c 4003 	ldrb.w	r4, [ip, #3]
c0de56f0:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de56f4:	ea45 2304 	orr.w	r3, r5, r4, lsl #8
c0de56f8:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
c0de56fc:	e9d1 3101 	ldrd	r3, r1, [r1, #4]
    if (buttonPrevious) {
c0de5700:	b133      	cbz	r3, c0de5710 <layoutNavigationCallback+0x18e>
        buttonPrevious->foregroundColor = (navActivePage == 0) ? INACTIVE_COLOR : BLACK;
c0de5702:	b2c5      	uxtb	r5, r0
c0de5704:	fab5 f585 	clz	r5, r5
c0de5708:	096d      	lsrs	r5, r5, #5
c0de570a:	006d      	lsls	r5, r5, #1
c0de570c:	f883 502a 	strb.w	r5, [r3, #42]	@ 0x2a
    if (navNbPages > 1) {
c0de5710:	2a02      	cmp	r2, #2
c0de5712:	d30d      	bcc.n	c0de5730 <layoutNavigationCallback+0x1ae>
c0de5714:	f06f 03ff 	mvn.w	r3, #255	@ 0xff
        buttonNext->foregroundColor = (navActivePage == (navNbPages - 1)) ? INACTIVE_COLOR : BLACK;
c0de5718:	ea63 0000 	orn	r0, r3, r0
c0de571c:	4410      	add	r0, r2
c0de571e:	fab0 f080 	clz	r0, r0
c0de5722:	0940      	lsrs	r0, r0, #5
c0de5724:	0040      	lsls	r0, r0, #1
c0de5726:	f881 002a 	strb.w	r0, [r1, #42]	@ 0x2a
c0de572a:	e7d2      	b.n	c0de56d2 <layoutNavigationCallback+0x150>
c0de572c:	2000      	movs	r0, #0
}
c0de572e:	bdb0      	pop	{r4, r5, r7, pc}
c0de5730:	2002      	movs	r0, #2
c0de5732:	f881 002a 	strb.w	r0, [r1, #42]	@ 0x2a
c0de5736:	e7cc      	b.n	c0de56d2 <layoutNavigationCallback+0x150>

c0de5738 <layoutNavigationPopulate>:
 *
 */
void layoutNavigationPopulate(nbgl_container_t                 *navContainer,
                              const nbgl_layoutNavigationBar_t *navConfig,
                              uint8_t                           layer)
{
c0de5738:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de573c:	b082      	sub	sp, #8
c0de573e:	460c      	mov	r4, r1
    nbgl_button_t *button;

    if (navConfig->withExitKey) {
c0de5740:	78c9      	ldrb	r1, [r1, #3]
c0de5742:	4690      	mov	r8, r2
c0de5744:	2900      	cmp	r1, #0
c0de5746:	4605      	mov	r5, r0
c0de5748:	d03e      	beq.n	c0de57c8 <layoutNavigationPopulate+0x90>
        button                  = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layer);
c0de574a:	2005      	movs	r0, #5
c0de574c:	4641      	mov	r1, r8
c0de574e:	2705      	movs	r7, #5
c0de5750:	f003 fa09 	bl	c0de8b66 <nbgl_objPoolGet>
c0de5754:	2103      	movs	r1, #3
c0de5756:	2258      	movs	r2, #88	@ 0x58
        button->innerColor      = WHITE;
c0de5758:	f880 1028 	strb.w	r1, [r0, #40]	@ 0x28
        button->borderColor     = BORDER_COLOR;
c0de575c:	f880 1029 	strb.w	r1, [r0, #41]	@ 0x29
c0de5760:	2100      	movs	r1, #0
        button->obj.area.width  = BUTTON_DIAMETER;
c0de5762:	7102      	strb	r2, [r0, #4]
        button->obj.area.height = BUTTON_DIAMETER;
c0de5764:	7182      	strb	r2, [r0, #6]
c0de5766:	2204      	movs	r2, #4
        button->obj.area.width  = BUTTON_DIAMETER;
c0de5768:	7141      	strb	r1, [r0, #5]
        button->obj.area.height = BUTTON_DIAMETER;
c0de576a:	71c1      	strb	r1, [r0, #7]
        button->radius          = BUTTON_RADIUS;
c0de576c:	f880 202b 	strb.w	r2, [r0, #43]	@ 0x2b
        button->icon            = &CLOSE_ICON;
c0de5770:	f644 72c0 	movw	r2, #20416	@ 0x4fc0
c0de5774:	f2c0 0200 	movt	r2, #0
c0de5778:	447a      	add	r2, pc
c0de577a:	0a13      	lsrs	r3, r2, #8
c0de577c:	f880 3025 	strb.w	r3, [r0, #37]	@ 0x25
c0de5780:	4603      	mov	r3, r0
c0de5782:	f803 2f24 	strb.w	r2, [r3, #36]!
c0de5786:	0e16      	lsrs	r6, r2, #24
c0de5788:	0c12      	lsrs	r2, r2, #16
c0de578a:	709a      	strb	r2, [r3, #2]
#ifdef TARGET_FLEX
        button->obj.alignmentMarginX = (navConfig->nbPages > 1) ? 8 : 0;
c0de578c:	7862      	ldrb	r2, [r4, #1]
        button->icon            = &CLOSE_ICON;
c0de578e:	70de      	strb	r6, [r3, #3]
        button->obj.alignmentMarginX = (navConfig->nbPages > 1) ? 8 : 0;
c0de5790:	2a01      	cmp	r2, #1
c0de5792:	f04f 0200 	mov.w	r2, #0
#endif  // TARGET_STAX

        button->obj.alignment                     = (navConfig->nbPages > 1) ? MID_LEFT : CENTER;
c0de5796:	bf88      	it	hi
c0de5798:	2704      	movhi	r7, #4
        button->obj.alignmentMarginX = (navConfig->nbPages > 1) ? 8 : 0;
c0de579a:	bf88      	it	hi
c0de579c:	2201      	movhi	r2, #1
c0de579e:	00d2      	lsls	r2, r2, #3
c0de57a0:	7541      	strb	r1, [r0, #21]
        button->obj.touchMask                     = (1 << TOUCHED);
c0de57a2:	7641      	strb	r1, [r0, #25]
c0de57a4:	2101      	movs	r1, #1
        button->obj.alignmentMarginX = (navConfig->nbPages > 1) ? 8 : 0;
c0de57a6:	7502      	strb	r2, [r0, #20]
        button->obj.touchMask                     = (1 << TOUCHED);
c0de57a8:	7601      	strb	r1, [r0, #24]
        button->obj.touchId                       = BOTTOM_BUTTON_ID;
        navContainer->children[EXIT_BUTTON_INDEX] = (nbgl_obj_t *) button;
c0de57aa:	462a      	mov	r2, r5
c0de57ac:	f812 3f1c 	ldrb.w	r3, [r2, #28]!
        button->obj.alignment                     = (navConfig->nbPages > 1) ? MID_LEFT : CENTER;
c0de57b0:	72c7      	strb	r7, [r0, #11]
        button->obj.touchId                       = BOTTOM_BUTTON_ID;
c0de57b2:	7681      	strb	r1, [r0, #26]
        navContainer->children[EXIT_BUTTON_INDEX] = (nbgl_obj_t *) button;
c0de57b4:	7851      	ldrb	r1, [r2, #1]
c0de57b6:	7897      	ldrb	r7, [r2, #2]
c0de57b8:	78d2      	ldrb	r2, [r2, #3]
c0de57ba:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de57be:	ea47 2202 	orr.w	r2, r7, r2, lsl #8
c0de57c2:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de57c6:	6008      	str	r0, [r1, #0]
    }
    // create previous page button (back)
    if (navConfig->withBackKey) {
c0de57c8:	7920      	ldrb	r0, [r4, #4]
c0de57ca:	b3b8      	cbz	r0, c0de583c <layoutNavigationPopulate+0x104>
        button                  = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layer);
c0de57cc:	2005      	movs	r0, #5
c0de57ce:	4641      	mov	r1, r8
c0de57d0:	f003 f9c9 	bl	c0de8b66 <nbgl_objPoolGet>
c0de57d4:	2103      	movs	r1, #3
c0de57d6:	2360      	movs	r3, #96	@ 0x60
        button->innerColor      = WHITE;
c0de57d8:	f880 1028 	strb.w	r1, [r0, #40]	@ 0x28
        button->borderColor     = BORDER_COLOR;
c0de57dc:	f880 1029 	strb.w	r1, [r0, #41]	@ 0x29
c0de57e0:	2100      	movs	r1, #0
c0de57e2:	2268      	movs	r2, #104	@ 0x68
        button->obj.area.width  = NAV_BUTTON_WIDTH;
        button->obj.area.height = NAV_BUTTON_HEIGHT;
c0de57e4:	7183      	strb	r3, [r0, #6]
c0de57e6:	2304      	movs	r3, #4
        button->obj.area.width  = NAV_BUTTON_WIDTH;
c0de57e8:	7141      	strb	r1, [r0, #5]
c0de57ea:	7102      	strb	r2, [r0, #4]
        button->obj.area.height = NAV_BUTTON_HEIGHT;
c0de57ec:	71c1      	strb	r1, [r0, #7]
        button->radius          = BUTTON_RADIUS;
c0de57ee:	f880 302b 	strb.w	r3, [r0, #43]	@ 0x2b
        button->icon            = &CHEVRON_BACK_ICON;
c0de57f2:	f644 6324 	movw	r3, #20004	@ 0x4e24
c0de57f6:	f2c0 0300 	movt	r3, #0
c0de57fa:	447b      	add	r3, pc
c0de57fc:	0a1f      	lsrs	r7, r3, #8
c0de57fe:	f880 7025 	strb.w	r7, [r0, #37]	@ 0x25
c0de5802:	4607      	mov	r7, r0
c0de5804:	f807 3f24 	strb.w	r3, [r7, #36]!
c0de5808:	0e1e      	lsrs	r6, r3, #24
c0de580a:	0c1b      	lsrs	r3, r3, #16
        // align on the right of the container, leaving space for "Next" button
        button->obj.alignment                       = MID_RIGHT;
        button->obj.alignmentMarginX                = NAV_BUTTON_WIDTH;
c0de580c:	7541      	strb	r1, [r0, #21]
        button->obj.touchMask                       = (1 << TOUCHED);
c0de580e:	7641      	strb	r1, [r0, #25]
c0de5810:	2101      	movs	r1, #1
        button->icon            = &CHEVRON_BACK_ICON;
c0de5812:	70bb      	strb	r3, [r7, #2]
c0de5814:	2306      	movs	r3, #6
        button->obj.alignmentMarginX                = NAV_BUTTON_WIDTH;
c0de5816:	7502      	strb	r2, [r0, #20]
        button->obj.touchMask                       = (1 << TOUCHED);
c0de5818:	7601      	strb	r1, [r0, #24]
        button->obj.touchId                         = LEFT_BUTTON_ID;
        navContainer->children[PREVIOUS_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de581a:	462a      	mov	r2, r5
        button->obj.alignment                       = MID_RIGHT;
c0de581c:	72c3      	strb	r3, [r0, #11]
        navContainer->children[PREVIOUS_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de581e:	f812 3f1c 	ldrb.w	r3, [r2, #28]!
c0de5822:	2102      	movs	r1, #2
        button->icon            = &CHEVRON_BACK_ICON;
c0de5824:	70fe      	strb	r6, [r7, #3]
        button->obj.touchId                         = LEFT_BUTTON_ID;
c0de5826:	7681      	strb	r1, [r0, #26]
        navContainer->children[PREVIOUS_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de5828:	7851      	ldrb	r1, [r2, #1]
c0de582a:	7897      	ldrb	r7, [r2, #2]
c0de582c:	78d2      	ldrb	r2, [r2, #3]
c0de582e:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de5832:	ea47 2202 	orr.w	r2, r7, r2, lsl #8
c0de5836:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de583a:	6048      	str	r0, [r1, #4]
    }

    // create next page button
    button                                  = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layer);
c0de583c:	2005      	movs	r0, #5
c0de583e:	4641      	mov	r1, r8
c0de5840:	f003 f991 	bl	c0de8b66 <nbgl_objPoolGet>
c0de5844:	2368      	movs	r3, #104	@ 0x68
    button->innerColor                      = WHITE;
    button->borderColor                     = BORDER_COLOR;
    button->foregroundColor                 = BLACK;
    button->obj.area.width                  = NAV_BUTTON_WIDTH;
c0de5846:	7103      	strb	r3, [r0, #4]
c0de5848:	2360      	movs	r3, #96	@ 0x60
c0de584a:	2103      	movs	r1, #3
c0de584c:	2200      	movs	r2, #0
    button->obj.area.height                 = NAV_BUTTON_HEIGHT;
c0de584e:	7183      	strb	r3, [r0, #6]
c0de5850:	2304      	movs	r3, #4
    button->innerColor                      = WHITE;
c0de5852:	f880 1028 	strb.w	r1, [r0, #40]	@ 0x28
    button->borderColor                     = BORDER_COLOR;
c0de5856:	f880 1029 	strb.w	r1, [r0, #41]	@ 0x29
    button->foregroundColor                 = BLACK;
c0de585a:	f880 202a 	strb.w	r2, [r0, #42]	@ 0x2a
    button->obj.area.width                  = NAV_BUTTON_WIDTH;
c0de585e:	7142      	strb	r2, [r0, #5]
    button->obj.area.height                 = NAV_BUTTON_HEIGHT;
c0de5860:	71c2      	strb	r2, [r0, #7]
    button->radius                          = BUTTON_RADIUS;
c0de5862:	f880 302b 	strb.w	r3, [r0, #43]	@ 0x2b
    button->icon                            = &CHEVRON_NEXT_ICON;
c0de5866:	f644 6733 	movw	r7, #20019	@ 0x4e33
c0de586a:	f2c0 0700 	movt	r7, #0
c0de586e:	447f      	add	r7, pc
c0de5870:	0a3b      	lsrs	r3, r7, #8
c0de5872:	f880 3025 	strb.w	r3, [r0, #37]	@ 0x25
c0de5876:	4603      	mov	r3, r0
c0de5878:	f803 7f24 	strb.w	r7, [r3, #36]!
c0de587c:	0e3e      	lsrs	r6, r7, #24
c0de587e:	70de      	strb	r6, [r3, #3]
c0de5880:	0c3e      	lsrs	r6, r7, #16
    button->obj.alignment                   = MID_RIGHT;
    button->obj.touchMask                   = (1 << TOUCHED);
c0de5882:	7642      	strb	r2, [r0, #25]
c0de5884:	2201      	movs	r2, #1
    button->icon                            = &CHEVRON_NEXT_ICON;
c0de5886:	709e      	strb	r6, [r3, #2]
c0de5888:	2306      	movs	r3, #6
    button->obj.touchMask                   = (1 << TOUCHED);
c0de588a:	7602      	strb	r2, [r0, #24]
    button->obj.touchId                     = RIGHT_BUTTON_ID;
    navContainer->children[NEXT_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de588c:	462a      	mov	r2, r5
    button->obj.alignment                   = MID_RIGHT;
c0de588e:	72c3      	strb	r3, [r0, #11]
    navContainer->children[NEXT_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de5890:	f812 3f1c 	ldrb.w	r3, [r2, #28]!
    button->obj.touchId                     = RIGHT_BUTTON_ID;
c0de5894:	7681      	strb	r1, [r0, #26]
    navContainer->children[NEXT_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de5896:	7851      	ldrb	r1, [r2, #1]
c0de5898:	7896      	ldrb	r6, [r2, #2]
c0de589a:	78d2      	ldrb	r2, [r2, #3]
c0de589c:	ea43 2101 	orr.w	r1, r3, r1, lsl #8

    // potentially create page indicator (with a text area, and "page of nb_page")
    if (navConfig->withPageIndicator) {
c0de58a0:	79a3      	ldrb	r3, [r4, #6]
    navContainer->children[NEXT_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de58a2:	ea46 2202 	orr.w	r2, r6, r2, lsl #8
c0de58a6:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
    if (navConfig->withPageIndicator) {
c0de58aa:	2b00      	cmp	r3, #0
    navContainer->children[NEXT_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de58ac:	6088      	str	r0, [r1, #8]
    if (navConfig->withPageIndicator) {
c0de58ae:	d06c      	beq.n	c0de598a <layoutNavigationPopulate+0x252>
        if (navConfig->visibleIndicator) {
c0de58b0:	79e0      	ldrb	r0, [r4, #7]
c0de58b2:	2800      	cmp	r0, #0
c0de58b4:	d051      	beq.n	c0de595a <layoutNavigationPopulate+0x222>
            nbgl_text_area_t *textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layer);
c0de58b6:	2004      	movs	r0, #4
c0de58b8:	4641      	mov	r1, r8
c0de58ba:	f003 f954 	bl	c0de8b66 <nbgl_objPoolGet>
            uint16_t          marginX  = (NAV_BUTTON_WIDTH - CHEVRON_NEXT_ICON.width) / 2;
c0de58be:	7839      	ldrb	r1, [r7, #0]
c0de58c0:	787a      	ldrb	r2, [r7, #1]
            nbgl_text_area_t *textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layer);
c0de58c2:	4606      	mov	r6, r0
            uint16_t          marginX  = (NAV_BUTTON_WIDTH - CHEVRON_NEXT_ICON.width) / 2;
c0de58c4:	ea41 2802 	orr.w	r8, r1, r2, lsl #8
c0de58c8:	f1c8 0068 	rsb	r0, r8, #104	@ 0x68
c0de58cc:	eb00 7ad0 	add.w	sl, r0, r0, lsr #31

            SPRINTF(navText, "%d of %d", navConfig->activePage + 1, navConfig->nbPages);
c0de58d0:	78a0      	ldrb	r0, [r4, #2]
c0de58d2:	7861      	ldrb	r1, [r4, #1]
c0de58d4:	1c43      	adds	r3, r0, #1
c0de58d6:	f240 40d1 	movw	r0, #1233	@ 0x4d1
c0de58da:	9100      	str	r1, [sp, #0]
c0de58dc:	f2c0 0000 	movt	r0, #0
c0de58e0:	f245 72ab 	movw	r2, #22443	@ 0x57ab
c0de58e4:	eb09 0700 	add.w	r7, r9, r0
c0de58e8:	f2c0 0200 	movt	r2, #0
c0de58ec:	447a      	add	r2, pc
c0de58ee:	4638      	mov	r0, r7
c0de58f0:	210b      	movs	r1, #11
c0de58f2:	f04f 0b0b 	mov.w	fp, #11
c0de58f6:	f003 ffe3 	bl	c0de98c0 <snprintf>
            textArea->text                               = navText;
            textArea->fontId                             = SMALL_REGULAR_FONT;
            textArea->obj.area.height                    = NAV_BUTTON_HEIGHT;
            textArea->textAlignment                      = CENTER;
            textArea->obj.alignment                      = CENTER;
            navContainer->children[PAGE_INDICATOR_INDEX] = (nbgl_obj_t *) textArea;
c0de58fa:	4629      	mov	r1, r5
c0de58fc:	f811 cf1c 	ldrb.w	ip, [r1, #28]!
c0de5900:	2201      	movs	r2, #1
            textArea->textColor = LIGHT_TEXT_COLOR;
c0de5902:	7732      	strb	r2, [r6, #28]
                = navContainer->obj.area.width - (2 * (marginX + CHEVRON_NEXT_ICON.width));
c0de5904:	f811 2c18 	ldrb.w	r2, [r1, #-24]
c0de5908:	f811 3c17 	ldrb.w	r3, [r1, #-23]
            navContainer->children[PAGE_INDICATOR_INDEX] = (nbgl_obj_t *) textArea;
c0de590c:	f891 e001 	ldrb.w	lr, [r1, #1]
                = navContainer->obj.area.width - (2 * (marginX + CHEVRON_NEXT_ICON.width));
c0de5910:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de5914:	eb08 035a 	add.w	r3, r8, sl, lsr #1
c0de5918:	eba2 0243 	sub.w	r2, r2, r3, lsl #1
            navContainer->children[PAGE_INDICATOR_INDEX] = (nbgl_obj_t *) textArea;
c0de591c:	7888      	ldrb	r0, [r1, #2]
                = navContainer->obj.area.width - (2 * (marginX + CHEVRON_NEXT_ICON.width));
c0de591e:	7132      	strb	r2, [r6, #4]
c0de5920:	0a12      	lsrs	r2, r2, #8
c0de5922:	7172      	strb	r2, [r6, #5]
            textArea->text                               = navText;
c0de5924:	0a3a      	lsrs	r2, r7, #8
c0de5926:	f886 2024 	strb.w	r2, [r6, #36]	@ 0x24
c0de592a:	4632      	mov	r2, r6
c0de592c:	f802 7f23 	strb.w	r7, [r2, #35]!
c0de5930:	0e3b      	lsrs	r3, r7, #24
c0de5932:	70d3      	strb	r3, [r2, #3]
c0de5934:	0c3b      	lsrs	r3, r7, #16
c0de5936:	7093      	strb	r3, [r2, #2]
c0de5938:	2200      	movs	r2, #0
            textArea->obj.area.height                    = NAV_BUTTON_HEIGHT;
c0de593a:	71f2      	strb	r2, [r6, #7]
c0de593c:	2260      	movs	r2, #96	@ 0x60
c0de593e:	71b2      	strb	r2, [r6, #6]
            navContainer->children[PAGE_INDICATOR_INDEX] = (nbgl_obj_t *) textArea;
c0de5940:	78c9      	ldrb	r1, [r1, #3]
c0de5942:	2205      	movs	r2, #5
c0de5944:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de5948:	ea4c 210e 	orr.w	r1, ip, lr, lsl #8
c0de594c:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
            textArea->fontId                             = SMALL_REGULAR_FONT;
c0de5950:	f886 b01f 	strb.w	fp, [r6, #31]
            textArea->textAlignment                      = CENTER;
c0de5954:	7772      	strb	r2, [r6, #29]
            textArea->obj.alignment                      = CENTER;
c0de5956:	72f2      	strb	r2, [r6, #11]
            navContainer->children[PAGE_INDICATOR_INDEX] = (nbgl_obj_t *) textArea;
c0de5958:	60c6      	str	r6, [r0, #12]
        }
        if (navConfig->withBackKey) {
c0de595a:	7920      	ldrb	r0, [r4, #4]
c0de595c:	b1a8      	cbz	r0, c0de598a <layoutNavigationPopulate+0x252>
            navContainer->children[PREVIOUS_PAGE_INDEX]->alignmentMarginX += PAGE_NUMBER_WIDTH;
c0de595e:	4628      	mov	r0, r5
c0de5960:	f810 1f1c 	ldrb.w	r1, [r0, #28]!
c0de5964:	7842      	ldrb	r2, [r0, #1]
c0de5966:	7883      	ldrb	r3, [r0, #2]
c0de5968:	78c0      	ldrb	r0, [r0, #3]
c0de596a:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de596e:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de5972:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de5976:	6840      	ldr	r0, [r0, #4]
c0de5978:	f810 1f14 	ldrb.w	r1, [r0, #20]!
c0de597c:	7842      	ldrb	r2, [r0, #1]
c0de597e:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de5982:	314f      	adds	r1, #79	@ 0x4f
c0de5984:	7001      	strb	r1, [r0, #0]
c0de5986:	0a09      	lsrs	r1, r1, #8
c0de5988:	7041      	strb	r1, [r0, #1]
    nbgl_button_t *buttonPrevious = (nbgl_button_t *) navContainer->children[PREVIOUS_PAGE_INDEX];
c0de598a:	f815 1f1c 	ldrb.w	r1, [r5, #28]!
        }
    }

    // configure enabling/disabling of button
    configButtons(navContainer, navConfig->nbPages, navConfig->activePage);
c0de598e:	7860      	ldrb	r0, [r4, #1]
    nbgl_button_t *buttonPrevious = (nbgl_button_t *) navContainer->children[PREVIOUS_PAGE_INDEX];
c0de5990:	786b      	ldrb	r3, [r5, #1]
c0de5992:	78af      	ldrb	r7, [r5, #2]
c0de5994:	78ee      	ldrb	r6, [r5, #3]
c0de5996:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de599a:	ea47 2306 	orr.w	r3, r7, r6, lsl #8
c0de599e:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
c0de59a2:	e9d1 3101 	ldrd	r3, r1, [r1, #4]
    configButtons(navContainer, navConfig->nbPages, navConfig->activePage);
c0de59a6:	78a2      	ldrb	r2, [r4, #2]
    if (buttonPrevious) {
c0de59a8:	b12b      	cbz	r3, c0de59b6 <layoutNavigationPopulate+0x27e>
        buttonPrevious->foregroundColor = (navActivePage == 0) ? INACTIVE_COLOR : BLACK;
c0de59aa:	fab2 f782 	clz	r7, r2
c0de59ae:	097f      	lsrs	r7, r7, #5
c0de59b0:	007f      	lsls	r7, r7, #1
c0de59b2:	f883 702a 	strb.w	r7, [r3, #42]	@ 0x2a
    if (navNbPages > 1) {
c0de59b6:	43d2      	mvns	r2, r2
c0de59b8:	4402      	add	r2, r0
c0de59ba:	fab2 f282 	clz	r2, r2
c0de59be:	0952      	lsrs	r2, r2, #5
c0de59c0:	0052      	lsls	r2, r2, #1
c0de59c2:	2802      	cmp	r0, #2
c0de59c4:	bf38      	it	cc
c0de59c6:	2202      	movcc	r2, #2
c0de59c8:	f881 202a 	strb.w	r2, [r1, #42]	@ 0x2a

    return;
}
c0de59cc:	b002      	add	sp, #8
c0de59ce:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de59d2 <nbgl_pageDrawInfo>:
 * @return the page context (or NULL if error)
 */
nbgl_page_t *nbgl_pageDrawInfo(nbgl_layoutTouchCallback_t              onActionCallback,
                               const nbgl_screenTickerConfiguration_t *ticker,
                               const nbgl_pageInfoDescription_t       *info)
{
c0de59d2:	b570      	push	{r4, r5, r6, lr}
c0de59d4:	b08e      	sub	sp, #56	@ 0x38
c0de59d6:	4614      	mov	r4, r2

    layoutDescription.modal          = false;
    layoutDescription.withLeftBorder = true;

    layoutDescription.onActionCallback = onActionCallback;
    if (!info->isSwipeable) {
c0de59d8:	f894 3024 	ldrb.w	r3, [r4, #36]	@ 0x24
c0de59dc:	2200      	movs	r2, #0
    layoutDescription.modal          = false;
c0de59de:	9208      	str	r2, [sp, #32]
c0de59e0:	e9cd 2206 	strd	r2, r2, [sp, #24]
c0de59e4:	9204      	str	r2, [sp, #16]
c0de59e6:	e9cd 2202 	strd	r2, r2, [sp, #8]
c0de59ea:	2201      	movs	r2, #1
    layoutDescription.withLeftBorder = true;
c0de59ec:	f88d 2009 	strb.w	r2, [sp, #9]
    layoutDescription.onActionCallback = onActionCallback;
c0de59f0:	9005      	str	r0, [sp, #20]
    if (!info->isSwipeable) {
c0de59f2:	b32b      	cbz	r3, c0de5a40 <nbgl_pageDrawInfo+0x6e>
        layoutDescription.tapActionText  = info->tapActionText;
        layoutDescription.tapActionToken = info->tapActionToken;
        layoutDescription.tapTuneId      = info->tuneId;
    }

    if (ticker != NULL) {
c0de59f4:	b381      	cbz	r1, c0de5a58 <nbgl_pageDrawInfo+0x86>
        layoutDescription.ticker.tickerCallback  = ticker->tickerCallback;
c0de59f6:	7808      	ldrb	r0, [r1, #0]
c0de59f8:	788a      	ldrb	r2, [r1, #2]
c0de59fa:	78cb      	ldrb	r3, [r1, #3]
c0de59fc:	784d      	ldrb	r5, [r1, #1]
c0de59fe:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de5a02:	ea40 2005 	orr.w	r0, r0, r5, lsl #8
c0de5a06:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de5a0a:	9006      	str	r0, [sp, #24]
        layoutDescription.ticker.tickerIntervale = ticker->tickerIntervale;
c0de5a0c:	4608      	mov	r0, r1
c0de5a0e:	f810 2f08 	ldrb.w	r2, [r0, #8]!
c0de5a12:	7a4b      	ldrb	r3, [r1, #9]
c0de5a14:	7885      	ldrb	r5, [r0, #2]
c0de5a16:	78c0      	ldrb	r0, [r0, #3]
c0de5a18:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de5a1c:	ea45 2000 	orr.w	r0, r5, r0, lsl #8
c0de5a20:	ea42 4000 	orr.w	r0, r2, r0, lsl #16
        layoutDescription.ticker.tickerValue     = ticker->tickerValue;
c0de5a24:	794a      	ldrb	r2, [r1, #5]
c0de5a26:	f811 3f04 	ldrb.w	r3, [r1, #4]!
        layoutDescription.ticker.tickerIntervale = ticker->tickerIntervale;
c0de5a2a:	9008      	str	r0, [sp, #32]
        layoutDescription.ticker.tickerValue     = ticker->tickerValue;
c0de5a2c:	7888      	ldrb	r0, [r1, #2]
c0de5a2e:	78c9      	ldrb	r1, [r1, #3]
c0de5a30:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de5a34:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de5a38:	ea42 4000 	orr.w	r0, r2, r0, lsl #16
c0de5a3c:	9007      	str	r0, [sp, #28]
c0de5a3e:	e00d      	b.n	c0de5a5c <nbgl_pageDrawInfo+0x8a>
        layoutDescription.tapActionText  = info->tapActionText;
c0de5a40:	6a20      	ldr	r0, [r4, #32]
        layoutDescription.tapTuneId      = info->tuneId;
c0de5a42:	f894 2031 	ldrb.w	r2, [r4, #49]	@ 0x31
        layoutDescription.tapActionText  = info->tapActionText;
c0de5a46:	9003      	str	r0, [sp, #12]
        layoutDescription.tapActionToken = info->tapActionToken;
c0de5a48:	f894 0025 	ldrb.w	r0, [r4, #37]	@ 0x25
        layoutDescription.tapTuneId      = info->tuneId;
c0de5a4c:	f88d 2011 	strb.w	r2, [sp, #17]
        layoutDescription.tapActionToken = info->tapActionToken;
c0de5a50:	f88d 0010 	strb.w	r0, [sp, #16]
    if (ticker != NULL) {
c0de5a54:	2900      	cmp	r1, #0
c0de5a56:	d1ce      	bne.n	c0de59f6 <nbgl_pageDrawInfo+0x24>
c0de5a58:	2000      	movs	r0, #0
    }
    else {
        layoutDescription.ticker.tickerCallback = NULL;
c0de5a5a:	9006      	str	r0, [sp, #24]
c0de5a5c:	a802      	add	r0, sp, #8
    }
    layout = nbgl_layoutGet(&layoutDescription);
c0de5a5e:	f7fb fbef 	bl	c0de1240 <nbgl_layoutGet>
    if (info->isSwipeable) {
c0de5a62:	f894 1024 	ldrb.w	r1, [r4, #36]	@ 0x24
    layout = nbgl_layoutGet(&layoutDescription);
c0de5a66:	4606      	mov	r6, r0
    if (info->isSwipeable) {
c0de5a68:	b151      	cbz	r1, c0de5a80 <nbgl_pageDrawInfo+0xae>
        nbgl_layoutAddSwipe(layout,
                            ((1 << SWIPED_LEFT) | (1 << SWIPED_RIGHT)),
                            info->tapActionText,
c0de5a6a:	6a22      	ldr	r2, [r4, #32]
                            info->tapActionToken,
c0de5a6c:	f894 3025 	ldrb.w	r3, [r4, #37]	@ 0x25
                            info->tuneId);
c0de5a70:	f894 5031 	ldrb.w	r5, [r4, #49]	@ 0x31
        nbgl_layoutAddSwipe(layout,
c0de5a74:	4630      	mov	r0, r6
c0de5a76:	f44f 7140 	mov.w	r1, #768	@ 0x300
c0de5a7a:	9500      	str	r5, [sp, #0]
c0de5a7c:	f7fc fb3d 	bl	c0de20fa <nbgl_layoutAddSwipe>
    }
    // add an empty header if a top-right button is used or if the tap text is not empty
    if ((info->topRightStyle != NO_BUTTON_STYLE)
c0de5a80:	7d20      	ldrb	r0, [r4, #20]
        || (info->tapActionText && strlen(PIC(info->tapActionText)))) {
c0de5a82:	2800      	cmp	r0, #0
c0de5a84:	d04c      	beq.n	c0de5b20 <nbgl_pageDrawInfo+0x14e>
c0de5a86:	2000      	movs	r0, #0
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de5a88:	900d      	str	r0, [sp, #52]	@ 0x34
c0de5a8a:	e9cd 000b 	strd	r0, r0, [sp, #44]	@ 0x2c
c0de5a8e:	e9cd 0009 	strd	r0, r0, [sp, #36]	@ 0x24
c0de5a92:	2028      	movs	r0, #40	@ 0x28
c0de5a94:	f8ad 0028 	strh.w	r0, [sp, #40]	@ 0x28
c0de5a98:	a909      	add	r1, sp, #36	@ 0x24
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de5a9a:	4630      	mov	r0, r6
c0de5a9c:	f7ff f850 	bl	c0de4b40 <nbgl_layoutAddHeader>
        addEmptyHeader(layout, SMALL_CENTERING_HEADER);
    }
    nbgl_layoutAddCenteredInfo(layout, &info->centeredInfo);
c0de5aa0:	4630      	mov	r0, r6
c0de5aa2:	4621      	mov	r1, r4
c0de5aa4:	f7fd ff25 	bl	c0de38f2 <nbgl_layoutAddCenteredInfo>

    // if action button but not QUIT_APP_TEXT bottom button, use a small black button
    if ((info->actionButtonText != NULL) && (info->bottomButtonStyle != QUIT_APP_TEXT)) {
c0de5aa8:	6aa0      	ldr	r0, [r4, #40]	@ 0x28
c0de5aaa:	b1b8      	cbz	r0, c0de5adc <nbgl_pageDrawInfo+0x10a>
c0de5aac:	7d61      	ldrb	r1, [r4, #21]
c0de5aae:	2904      	cmp	r1, #4
c0de5ab0:	d014      	beq.n	c0de5adc <nbgl_pageDrawInfo+0x10a>
        nbgl_layoutButton_t buttonInfo = {.fittingContent = true,
                                          .icon           = info->actionButtonIcon,
c0de5ab2:	6ae1      	ldr	r1, [r4, #44]	@ 0x2c
        nbgl_layoutButton_t buttonInfo = {.fittingContent = true,
c0de5ab4:	e9cd 0109 	strd	r0, r1, [sp, #36]	@ 0x24
                                          .onBottom       = false,
                                          .style          = info->actionButtonStyle,
c0de5ab8:	f894 1030 	ldrb.w	r1, [r4, #48]	@ 0x30
                                          .text           = info->actionButtonText,
                                          .token          = info->bottomButtonsToken,
c0de5abc:	7de0      	ldrb	r0, [r4, #23]
        nbgl_layoutButton_t buttonInfo = {.fittingContent = true,
c0de5abe:	f88d 102d 	strb.w	r1, [sp, #45]	@ 0x2d
                                          .tuneId         = info->tuneId};
c0de5ac2:	f894 1031 	ldrb.w	r1, [r4, #49]	@ 0x31
        nbgl_layoutButton_t buttonInfo = {.fittingContent = true,
c0de5ac6:	f88d 002c 	strb.w	r0, [sp, #44]	@ 0x2c
c0de5aca:	2001      	movs	r0, #1
c0de5acc:	f8ad 002e 	strh.w	r0, [sp, #46]	@ 0x2e
c0de5ad0:	f88d 1030 	strb.w	r1, [sp, #48]	@ 0x30
c0de5ad4:	a909      	add	r1, sp, #36	@ 0x24
        nbgl_layoutAddButton(layout, &buttonInfo);
c0de5ad6:	4630      	mov	r0, r6
c0de5ad8:	f7fe fed7 	bl	c0de488a <nbgl_layoutAddButton>
    }

    if (info->footerText != NULL) {
c0de5adc:	69a0      	ldr	r0, [r4, #24]
c0de5ade:	b140      	cbz	r0, c0de5af2 <nbgl_pageDrawInfo+0x120>
        nbgl_layoutAddFooter(layout, PIC(info->footerText), info->footerToken, info->tuneId);
c0de5ae0:	f003 ff68 	bl	c0de99b4 <pic>
c0de5ae4:	7f22      	ldrb	r2, [r4, #28]
c0de5ae6:	f894 3031 	ldrb.w	r3, [r4, #49]	@ 0x31
c0de5aea:	4601      	mov	r1, r0
c0de5aec:	4630      	mov	r0, r6
c0de5aee:	f7fe ffff 	bl	c0de4af0 <nbgl_layoutAddFooter>
    }
    if (info->topRightStyle != NO_BUTTON_STYLE) {
c0de5af2:	7d21      	ldrb	r1, [r4, #20]
c0de5af4:	2000      	movs	r0, #0
c0de5af6:	2901      	cmp	r1, #1
c0de5af8:	dc08      	bgt.n	c0de5b0c <nbgl_pageDrawInfo+0x13a>
c0de5afa:	b341      	cbz	r1, c0de5b4e <nbgl_pageDrawInfo+0x17c>
c0de5afc:	2901      	cmp	r1, #1
c0de5afe:	d173      	bne.n	c0de5be8 <nbgl_pageDrawInfo+0x216>
c0de5b00:	f245 00b6 	movw	r0, #20662	@ 0x50b6
c0de5b04:	f2c0 0000 	movt	r0, #0
c0de5b08:	4478      	add	r0, pc
c0de5b0a:	e017      	b.n	c0de5b3c <nbgl_pageDrawInfo+0x16a>
c0de5b0c:	2902      	cmp	r1, #2
c0de5b0e:	d010      	beq.n	c0de5b32 <nbgl_pageDrawInfo+0x160>
c0de5b10:	2903      	cmp	r1, #3
c0de5b12:	d169      	bne.n	c0de5be8 <nbgl_pageDrawInfo+0x216>
c0de5b14:	f644 405f 	movw	r0, #19551	@ 0x4c5f
c0de5b18:	f2c0 0000 	movt	r0, #0
c0de5b1c:	4478      	add	r0, pc
c0de5b1e:	e00d      	b.n	c0de5b3c <nbgl_pageDrawInfo+0x16a>
        || (info->tapActionText && strlen(PIC(info->tapActionText)))) {
c0de5b20:	6a20      	ldr	r0, [r4, #32]
c0de5b22:	2800      	cmp	r0, #0
c0de5b24:	d0bc      	beq.n	c0de5aa0 <nbgl_pageDrawInfo+0xce>
c0de5b26:	f003 ff45 	bl	c0de99b4 <pic>
c0de5b2a:	7800      	ldrb	r0, [r0, #0]
    if ((info->topRightStyle != NO_BUTTON_STYLE)
c0de5b2c:	2800      	cmp	r0, #0
c0de5b2e:	d1aa      	bne.n	c0de5a86 <nbgl_pageDrawInfo+0xb4>
c0de5b30:	e7b6      	b.n	c0de5aa0 <nbgl_pageDrawInfo+0xce>
c0de5b32:	f644 30fe 	movw	r0, #19454	@ 0x4bfe
c0de5b36:	f2c0 0000 	movt	r0, #0
c0de5b3a:	4478      	add	r0, pc
            icon = &CLOSE_ICON;
        }
        else {
            return NULL;
        }
        nbgl_layoutAddTopRightButton(layout, PIC(icon), info->topRightToken, info->tuneId);
c0de5b3c:	f003 ff3a 	bl	c0de99b4 <pic>
c0de5b40:	7da2      	ldrb	r2, [r4, #22]
c0de5b42:	f894 3031 	ldrb.w	r3, [r4, #49]	@ 0x31
c0de5b46:	4601      	mov	r1, r0
c0de5b48:	4630      	mov	r0, r6
c0de5b4a:	f7fc fb3e 	bl	c0de21ca <nbgl_layoutAddTopRightButton>
    }
    if (info->bottomButtonStyle == QUIT_APP_TEXT) {
c0de5b4e:	7d61      	ldrb	r1, [r4, #21]
c0de5b50:	2000      	movs	r0, #0
c0de5b52:	2901      	cmp	r1, #1
c0de5b54:	dd25      	ble.n	c0de5ba2 <nbgl_pageDrawInfo+0x1d0>
c0de5b56:	2902      	cmp	r1, #2
c0de5b58:	d02c      	beq.n	c0de5bb4 <nbgl_pageDrawInfo+0x1e2>
c0de5b5a:	2903      	cmp	r1, #3
c0de5b5c:	d030      	beq.n	c0de5bc0 <nbgl_pageDrawInfo+0x1ee>
c0de5b5e:	2904      	cmp	r1, #4
c0de5b60:	d142      	bne.n	c0de5be8 <nbgl_pageDrawInfo+0x216>
        // if action button and QUIT_APP_TEXT bottom button, use a pair of choice buttons
        if ((info->actionButtonText != NULL)) {
c0de5b62:	6aa0      	ldr	r0, [r4, #40]	@ 0x28
c0de5b64:	2800      	cmp	r0, #0
c0de5b66:	d041      	beq.n	c0de5bec <nbgl_pageDrawInfo+0x21a>
            nbgl_layoutChoiceButtons_t buttonsInfo = {.topText    = info->actionButtonText,
c0de5b68:	9009      	str	r0, [sp, #36]	@ 0x24
c0de5b6a:	f245 7077 	movw	r0, #22391	@ 0x5777
c0de5b6e:	f2c0 0000 	movt	r0, #0
                                                      .bottomText = "Quit app",
                                                      .token      = info->bottomButtonsToken,
                                                      .tuneId     = info->tuneId,
                                                      .topIcon    = info->actionButtonIcon};
c0de5b72:	6ae1      	ldr	r1, [r4, #44]	@ 0x2c
            nbgl_layoutChoiceButtons_t buttonsInfo = {.topText    = info->actionButtonText,
c0de5b74:	4478      	add	r0, pc
c0de5b76:	e9cd 010a 	strd	r0, r1, [sp, #40]	@ 0x28
                                                      .token      = info->bottomButtonsToken,
c0de5b7a:	7de0      	ldrb	r0, [r4, #23]
                                                      .tuneId     = info->tuneId,
c0de5b7c:	f894 1031 	ldrb.w	r1, [r4, #49]	@ 0x31
            nbgl_layoutChoiceButtons_t buttonsInfo = {.topText    = info->actionButtonText,
c0de5b80:	f88d 0030 	strb.w	r0, [sp, #48]	@ 0x30
            buttonsInfo.style                      = (info->actionButtonStyle == BLACK_BACKGROUND)
c0de5b84:	f894 0030 	ldrb.w	r0, [r4, #48]	@ 0x30
            nbgl_layoutChoiceButtons_t buttonsInfo = {.topText    = info->actionButtonText,
c0de5b88:	f88d 1032 	strb.w	r1, [sp, #50]	@ 0x32
c0de5b8c:	2102      	movs	r1, #2
            buttonsInfo.style                      = (info->actionButtonStyle == BLACK_BACKGROUND)
c0de5b8e:	2800      	cmp	r0, #0
c0de5b90:	bf08      	it	eq
c0de5b92:	2101      	moveq	r1, #1
c0de5b94:	f88d 1031 	strb.w	r1, [sp, #49]	@ 0x31
c0de5b98:	a909      	add	r1, sp, #36	@ 0x24
                                                         ? STRONG_ACTION_AND_FOOTER_STYLE
                                                         : SOFT_ACTION_AND_FOOTER_STYLE;
            nbgl_layoutAddChoiceButtons(layout, &buttonsInfo);
c0de5b9a:	4630      	mov	r0, r6
c0de5b9c:	f7fe fb9e 	bl	c0de42dc <nbgl_layoutAddChoiceButtons>
c0de5ba0:	e01e      	b.n	c0de5be0 <nbgl_pageDrawInfo+0x20e>
    if (info->bottomButtonStyle == QUIT_APP_TEXT) {
c0de5ba2:	b1e9      	cbz	r1, c0de5be0 <nbgl_pageDrawInfo+0x20e>
c0de5ba4:	2901      	cmp	r1, #1
c0de5ba6:	d11f      	bne.n	c0de5be8 <nbgl_pageDrawInfo+0x216>
c0de5ba8:	f245 000e 	movw	r0, #20494	@ 0x500e
c0de5bac:	f2c0 0000 	movt	r0, #0
c0de5bb0:	4478      	add	r0, pc
c0de5bb2:	e00a      	b.n	c0de5bca <nbgl_pageDrawInfo+0x1f8>
c0de5bb4:	f644 307c 	movw	r0, #19324	@ 0x4b7c
c0de5bb8:	f2c0 0000 	movt	r0, #0
c0de5bbc:	4478      	add	r0, pc
c0de5bbe:	e004      	b.n	c0de5bca <nbgl_pageDrawInfo+0x1f8>
c0de5bc0:	f644 30b3 	movw	r0, #19379	@ 0x4bb3
c0de5bc4:	f2c0 0000 	movt	r0, #0
c0de5bc8:	4478      	add	r0, pc
        }
        else {
            return NULL;
        }
        nbgl_layoutAddBottomButton(
            layout, PIC(icon), info->bottomButtonsToken, false, info->tuneId);
c0de5bca:	f003 fef3 	bl	c0de99b4 <pic>
c0de5bce:	7de2      	ldrb	r2, [r4, #23]
c0de5bd0:	f894 5031 	ldrb.w	r5, [r4, #49]	@ 0x31
c0de5bd4:	4601      	mov	r1, r0
        nbgl_layoutAddBottomButton(
c0de5bd6:	4630      	mov	r0, r6
c0de5bd8:	2300      	movs	r3, #0
c0de5bda:	9500      	str	r5, [sp, #0]
c0de5bdc:	f7fd f8b1 	bl	c0de2d42 <nbgl_layoutAddBottomButton>
    }
    nbgl_layoutDraw(layout);
c0de5be0:	4630      	mov	r0, r6
c0de5be2:	f7ff fbf3 	bl	c0de53cc <nbgl_layoutDraw>
c0de5be6:	4630      	mov	r0, r6

    return (nbgl_page_t *) layout;
}
c0de5be8:	b00e      	add	sp, #56	@ 0x38
c0de5bea:	bd70      	pop	{r4, r5, r6, pc}
            nbgl_layoutAddFooter(layout, "Quit app", info->bottomButtonsToken, info->tuneId);
c0de5bec:	7de2      	ldrb	r2, [r4, #23]
c0de5bee:	f894 3031 	ldrb.w	r3, [r4, #49]	@ 0x31
c0de5bf2:	f245 61f1 	movw	r1, #22257	@ 0x56f1
c0de5bf6:	f2c0 0100 	movt	r1, #0
c0de5bfa:	4479      	add	r1, pc
c0de5bfc:	4630      	mov	r0, r6
c0de5bfe:	f7fe ff77 	bl	c0de4af0 <nbgl_layoutAddFooter>
c0de5c02:	e7ed      	b.n	c0de5be0 <nbgl_pageDrawInfo+0x20e>

c0de5c04 <nbgl_pageDrawConfirmation>:
 * @param info structure describing the centered info and other controls of this page
 * @return the page context (or NULL if error)
 */
nbgl_page_t *nbgl_pageDrawConfirmation(nbgl_layoutTouchCallback_t                onActionCallback,
                                       const nbgl_pageConfirmationDescription_t *info)
{
c0de5c04:	b570      	push	{r4, r5, r6, lr}
c0de5c06:	b090      	sub	sp, #64	@ 0x40
c0de5c08:	460c      	mov	r4, r1
    nbgl_layoutDescription_t   layoutDescription;
    nbgl_layout_t             *layout;
    nbgl_layoutChoiceButtons_t buttonsInfo
        = {.bottomText = (info->cancelText != NULL) ? PIC(info->cancelText) : "Cancel",
           .token      = info->confirmationToken,
           .topText    = PIC(info->confirmationText),
c0de5c0a:	6949      	ldr	r1, [r1, #20]
c0de5c0c:	4605      	mov	r5, r0
c0de5c0e:	4608      	mov	r0, r1
c0de5c10:	f003 fed0 	bl	c0de99b4 <pic>
        = {.bottomText = (info->cancelText != NULL) ? PIC(info->cancelText) : "Cancel",
c0de5c14:	69a1      	ldr	r1, [r4, #24]
c0de5c16:	9000      	str	r0, [sp, #0]
c0de5c18:	b119      	cbz	r1, c0de5c22 <nbgl_pageDrawConfirmation+0x1e>
c0de5c1a:	4608      	mov	r0, r1
c0de5c1c:	f003 feca 	bl	c0de99b4 <pic>
c0de5c20:	e004      	b.n	c0de5c2c <nbgl_pageDrawConfirmation+0x28>
c0de5c22:	f245 402c 	movw	r0, #21548	@ 0x542c
c0de5c26:	f2c0 0000 	movt	r0, #0
c0de5c2a:	4478      	add	r0, pc
c0de5c2c:	9001      	str	r0, [sp, #4]
           .token      = info->confirmationToken,
c0de5c2e:	7f20      	ldrb	r0, [r4, #28]
           .style      = ROUNDED_AND_FOOTER_STYLE,
           .tuneId     = info->tuneId};
c0de5c30:	7fa1      	ldrb	r1, [r4, #30]

    layoutDescription.modal          = info->modal;
c0de5c32:	7fe2      	ldrb	r2, [r4, #31]
        = {.bottomText = (info->cancelText != NULL) ? PIC(info->cancelText) : "Cancel",
c0de5c34:	f88d 000c 	strb.w	r0, [sp, #12]
c0de5c38:	2001      	movs	r0, #1
c0de5c3a:	2600      	movs	r6, #0
    layoutDescription.withLeftBorder = true;
c0de5c3c:	f88d 0011 	strb.w	r0, [sp, #17]
c0de5c40:	a804      	add	r0, sp, #16
        = {.bottomText = (info->cancelText != NULL) ? PIC(info->cancelText) : "Cancel",
c0de5c42:	9602      	str	r6, [sp, #8]
c0de5c44:	f88d 600d 	strb.w	r6, [sp, #13]
c0de5c48:	f88d 100e 	strb.w	r1, [sp, #14]
    layoutDescription.modal          = info->modal;
c0de5c4c:	f88d 2010 	strb.w	r2, [sp, #16]

    layoutDescription.onActionCallback = onActionCallback;
    layoutDescription.tapActionText    = NULL;
c0de5c50:	9605      	str	r6, [sp, #20]
    layoutDescription.onActionCallback = onActionCallback;
c0de5c52:	e9cd 5607 	strd	r5, r6, [sp, #28]

    layoutDescription.ticker.tickerCallback = NULL;
    layout                                  = nbgl_layoutGet(&layoutDescription);
c0de5c56:	f7fb faf3 	bl	c0de1240 <nbgl_layoutGet>
c0de5c5a:	4605      	mov	r5, r0
c0de5c5c:	2040      	movs	r0, #64	@ 0x40
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de5c5e:	960f      	str	r6, [sp, #60]	@ 0x3c
c0de5c60:	e9cd 660d 	strd	r6, r6, [sp, #52]	@ 0x34
c0de5c64:	e9cd 660b 	strd	r6, r6, [sp, #44]	@ 0x2c
c0de5c68:	f8ad 0030 	strh.w	r0, [sp, #48]	@ 0x30
c0de5c6c:	a90b      	add	r1, sp, #44	@ 0x2c
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de5c6e:	4628      	mov	r0, r5
c0de5c70:	f7fe ff66 	bl	c0de4b40 <nbgl_layoutAddHeader>
c0de5c74:	4669      	mov	r1, sp

    addEmptyHeader(layout, MEDIUM_CENTERING_HEADER);
    nbgl_layoutAddChoiceButtons(layout, &buttonsInfo);
c0de5c76:	4628      	mov	r0, r5
c0de5c78:	f7fe fb30 	bl	c0de42dc <nbgl_layoutAddChoiceButtons>

    nbgl_layoutAddCenteredInfo(layout, &info->centeredInfo);
c0de5c7c:	4628      	mov	r0, r5
c0de5c7e:	4621      	mov	r1, r4
c0de5c80:	f7fd fe37 	bl	c0de38f2 <nbgl_layoutAddCenteredInfo>

    nbgl_layoutDraw(layout);
c0de5c84:	4628      	mov	r0, r5
c0de5c86:	f7ff fba1 	bl	c0de53cc <nbgl_layoutDraw>

    return (nbgl_page_t *) layout;
c0de5c8a:	4628      	mov	r0, r5
c0de5c8c:	b010      	add	sp, #64	@ 0x40
c0de5c8e:	bd70      	pop	{r4, r5, r6, pc}

c0de5c90 <nbgl_pageDrawGenericContentExt>:
 */
nbgl_page_t *nbgl_pageDrawGenericContentExt(nbgl_layoutTouchCallback_t       onActionCallback,
                                            const nbgl_pageNavigationInfo_t *nav,
                                            nbgl_pageContent_t              *content,
                                            bool                             modal)
{
c0de5c90:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de5c94:	b096      	sub	sp, #88	@ 0x58
c0de5c96:	460e      	mov	r6, r1
c0de5c98:	4615      	mov	r5, r2
c0de5c9a:	2101      	movs	r1, #1
    uint16_t                 availableHeight = SCREEN_HEIGHT;
    bool                     headerAdded     = false;

    layoutDescription.modal                 = modal;
    layoutDescription.withLeftBorder        = true;
    layoutDescription.onActionCallback      = onActionCallback;
c0de5c9c:	9005      	str	r0, [sp, #20]
c0de5c9e:	2000      	movs	r0, #0
    layoutDescription.modal                 = modal;
c0de5ca0:	f88d 3008 	strb.w	r3, [sp, #8]
    layoutDescription.withLeftBorder        = true;
c0de5ca4:	f88d 1009 	strb.w	r1, [sp, #9]
    layoutDescription.ticker.tickerCallback = NULL;
c0de5ca8:	9006      	str	r0, [sp, #24]

    if ((nav != NULL) && (nav->navType == NAV_WITH_TAP)) {
c0de5caa:	b10e      	cbz	r6, c0de5cb0 <nbgl_pageDrawGenericContentExt+0x20>
c0de5cac:	78f1      	ldrb	r1, [r6, #3]
c0de5cae:	b109      	cbz	r1, c0de5cb4 <nbgl_pageDrawGenericContentExt+0x24>
        layoutDescription.tapActionText  = nav->navWithTap.nextPageText;
        layoutDescription.tapActionToken = nav->navWithTap.nextPageToken;
        layoutDescription.tapTuneId      = nav->tuneId;
    }
    else {
        layoutDescription.tapActionText = NULL;
c0de5cb0:	9003      	str	r0, [sp, #12]
c0de5cb2:	e007      	b.n	c0de5cc4 <nbgl_pageDrawGenericContentExt+0x34>
        layoutDescription.tapActionText  = nav->navWithTap.nextPageText;
c0de5cb4:	6970      	ldr	r0, [r6, #20]
        layoutDescription.tapTuneId      = nav->tuneId;
c0de5cb6:	7971      	ldrb	r1, [r6, #5]
        layoutDescription.tapActionText  = nav->navWithTap.nextPageText;
c0de5cb8:	9003      	str	r0, [sp, #12]
        layoutDescription.tapActionToken = nav->navWithTap.nextPageToken;
c0de5cba:	7cb0      	ldrb	r0, [r6, #18]
        layoutDescription.tapTuneId      = nav->tuneId;
c0de5cbc:	f88d 1011 	strb.w	r1, [sp, #17]
        layoutDescription.tapActionToken = nav->navWithTap.nextPageToken;
c0de5cc0:	f88d 0010 	strb.w	r0, [sp, #16]
c0de5cc4:	a802      	add	r0, sp, #8
    }

    layout = nbgl_layoutGet(&layoutDescription);
c0de5cc6:	f7fb fabb 	bl	c0de1240 <nbgl_layoutGet>
c0de5cca:	4682      	mov	sl, r0
    if (nav != NULL) {
c0de5ccc:	b17e      	cbz	r6, c0de5cee <nbgl_pageDrawGenericContentExt+0x5e>
        if (nav->navType == NAV_WITH_TAP) {
c0de5cce:	78f0      	ldrb	r0, [r6, #3]
c0de5cd0:	2801      	cmp	r0, #1
c0de5cd2:	d011      	beq.n	c0de5cf8 <nbgl_pageDrawGenericContentExt+0x68>
c0de5cd4:	b958      	cbnz	r0, c0de5cee <nbgl_pageDrawGenericContentExt+0x5e>
            if (nav->skipText == NULL) {
c0de5cd6:	68b3      	ldr	r3, [r6, #8]
c0de5cd8:	69b1      	ldr	r1, [r6, #24]
c0de5cda:	78b2      	ldrb	r2, [r6, #2]
c0de5cdc:	b323      	cbz	r3, c0de5d28 <nbgl_pageDrawGenericContentExt+0x98>
            else {
                availableHeight -= nbgl_layoutAddSplitFooter(layout,
                                                             nav->navWithTap.quitText,
                                                             nav->quitToken,
                                                             nav->skipText,
                                                             nav->skipToken,
c0de5cde:	7b30      	ldrb	r0, [r6, #12]
                                                             nav->tuneId);
c0de5ce0:	7977      	ldrb	r7, [r6, #5]
                availableHeight -= nbgl_layoutAddSplitFooter(layout,
c0de5ce2:	9000      	str	r0, [sp, #0]
c0de5ce4:	4650      	mov	r0, sl
c0de5ce6:	9701      	str	r7, [sp, #4]
c0de5ce8:	f7fe ff15 	bl	c0de4b16 <nbgl_layoutAddSplitFooter>
c0de5cec:	e020      	b.n	c0de5d30 <nbgl_pageDrawGenericContentExt+0xa0>
c0de5cee:	f04f 0800 	mov.w	r8, #0
c0de5cf2:	f44f 7716 	mov.w	r7, #600	@ 0x258
c0de5cf6:	e088      	b.n	c0de5e0a <nbgl_pageDrawGenericContentExt+0x17a>
        }
        else if (nav->navType == NAV_WITH_BUTTONS) {
            nbgl_layoutFooter_t footerDesc;
            bool                drawFooter = true;

            if (nav->skipText != NULL) {
c0de5cf8:	68b0      	ldr	r0, [r6, #8]
c0de5cfa:	2800      	cmp	r0, #0
c0de5cfc:	4680      	mov	r8, r0
c0de5cfe:	bf18      	it	ne
c0de5d00:	f04f 0801 	movne.w	r8, #1
c0de5d04:	d027      	beq.n	c0de5d56 <nbgl_pageDrawGenericContentExt+0xc6>
c0de5d06:	2106      	movs	r1, #6
                nbgl_layoutHeader_t headerDesc = {.type             = HEADER_RIGHT_TEXT,
c0de5d08:	f8ad 1034 	strh.w	r1, [sp, #52]	@ 0x34
                                                  .separationLine   = false,
                                                  .rightText.text   = nav->skipText,
c0de5d0c:	900e      	str	r0, [sp, #56]	@ 0x38
                                                  .rightText.token  = nav->skipToken,
c0de5d0e:	7b30      	ldrb	r0, [r6, #12]
                                                  .rightText.tuneId = nav->tuneId};
c0de5d10:	7971      	ldrb	r1, [r6, #5]
                                                  .rightText.text   = nav->skipText,
c0de5d12:	f88d 003c 	strb.w	r0, [sp, #60]	@ 0x3c
c0de5d16:	f88d 103d 	strb.w	r1, [sp, #61]	@ 0x3d
c0de5d1a:	a90d      	add	r1, sp, #52	@ 0x34
                availableHeight -= nbgl_layoutAddHeader(layout, &headerDesc);
c0de5d1c:	4650      	mov	r0, sl
c0de5d1e:	f7fe ff0f 	bl	c0de4b40 <nbgl_layoutAddHeader>
c0de5d22:	f5c0 7716 	rsb	r7, r0, #600	@ 0x258
c0de5d26:	e018      	b.n	c0de5d5a <nbgl_pageDrawGenericContentExt+0xca>
                    layout, nav->navWithTap.quitText, nav->quitToken, nav->tuneId);
c0de5d28:	7973      	ldrb	r3, [r6, #5]
                availableHeight -= nbgl_layoutAddFooter(
c0de5d2a:	4650      	mov	r0, sl
c0de5d2c:	f7fe fee0 	bl	c0de4af0 <nbgl_layoutAddFooter>
            if (nav->progressIndicator) {
c0de5d30:	7931      	ldrb	r1, [r6, #4]
c0de5d32:	f5c0 7716 	rsb	r7, r0, #600	@ 0x258
c0de5d36:	2900      	cmp	r1, #0
c0de5d38:	d048      	beq.n	c0de5dcc <nbgl_pageDrawGenericContentExt+0x13c>
                                                                   nav->navWithTap.backToken,
c0de5d3a:	7c70      	ldrb	r0, [r6, #17]
                                                                   nav->activePage,
c0de5d3c:	7831      	ldrb	r1, [r6, #0]
                                                                   nav->nbPages,
c0de5d3e:	7872      	ldrb	r2, [r6, #1]
                                                                   nav->tuneId);
c0de5d40:	7974      	ldrb	r4, [r6, #5]
                                                                   nav->navWithTap.backButton,
c0de5d42:	7c33      	ldrb	r3, [r6, #16]
                availableHeight -= nbgl_layoutAddProgressIndicator(layout,
c0de5d44:	9000      	str	r0, [sp, #0]
c0de5d46:	4650      	mov	r0, sl
c0de5d48:	9401      	str	r4, [sp, #4]
c0de5d4a:	f7ff fb24 	bl	c0de5396 <nbgl_layoutAddProgressIndicator>
c0de5d4e:	1a3f      	subs	r7, r7, r0
c0de5d50:	f04f 0801 	mov.w	r8, #1
c0de5d54:	e059      	b.n	c0de5e0a <nbgl_pageDrawGenericContentExt+0x17a>
c0de5d56:	f44f 7716 	mov.w	r7, #600	@ 0x258
                headerAdded = true;
            }
            footerDesc.separationLine = true;
            if (nav->nbPages > 1) {
c0de5d5a:	7870      	ldrb	r0, [r6, #1]
c0de5d5c:	2101      	movs	r1, #1
c0de5d5e:	2802      	cmp	r0, #2
            footerDesc.separationLine = true;
c0de5d60:	f88d 1035 	strb.w	r1, [sp, #53]	@ 0x35
            if (nav->nbPages > 1) {
c0de5d64:	d322      	bcc.n	c0de5dac <nbgl_pageDrawGenericContentExt+0x11c>
                if (nav->navWithButtons.quitText == NULL) {
c0de5d66:	6971      	ldr	r1, [r6, #20]
c0de5d68:	b399      	cbz	r1, c0de5dd2 <nbgl_pageDrawGenericContentExt+0x142>
                    footerDesc.navigation.token             = nav->navWithButtons.navToken;
                    footerDesc.navigation.tuneId            = nav->tuneId;
                }
                else {
                    footerDesc.type                              = FOOTER_TEXT_AND_NAV;
                    footerDesc.textAndNav.text                   = nav->navWithButtons.quitText;
c0de5d6a:	9111      	str	r1, [sp, #68]	@ 0x44
                    footerDesc.textAndNav.tuneId                 = nav->tuneId;
                    footerDesc.textAndNav.token                  = nav->quitToken;
                    footerDesc.textAndNav.navigation.activePage  = nav->activePage;
c0de5d6c:	7831      	ldrb	r1, [r6, #0]
                    footerDesc.textAndNav.navigation.nbPages     = nav->nbPages;
c0de5d6e:	f88d 0039 	strb.w	r0, [sp, #57]	@ 0x39
c0de5d72:	2000      	movs	r0, #0
c0de5d74:	2203      	movs	r2, #3
                    footerDesc.textAndNav.navigation.withExitKey = false;
c0de5d76:	f88d 003b 	strb.w	r0, [sp, #59]	@ 0x3b
                    footerDesc.textAndNav.navigation.withBackKey = nav->navWithButtons.backButton;
                    footerDesc.textAndNav.navigation.visibleIndicator
                        = nav->navWithButtons.visiblePageIndicator;
c0de5d7a:	7cb0      	ldrb	r0, [r6, #18]
                    footerDesc.type                              = FOOTER_TEXT_AND_NAV;
c0de5d7c:	f88d 2034 	strb.w	r2, [sp, #52]	@ 0x34
                    footerDesc.textAndNav.token                  = nav->quitToken;
c0de5d80:	78b2      	ldrb	r2, [r6, #2]
                    footerDesc.textAndNav.tuneId                 = nav->tuneId;
c0de5d82:	7973      	ldrb	r3, [r6, #5]
                    footerDesc.textAndNav.navigation.withBackKey = nav->navWithButtons.backButton;
c0de5d84:	7c74      	ldrb	r4, [r6, #17]
                    footerDesc.textAndNav.navigation.activePage  = nav->activePage;
c0de5d86:	f88d 103a 	strb.w	r1, [sp, #58]	@ 0x3a
                    footerDesc.textAndNav.navigation.withPageIndicator = true;
                    footerDesc.textAndNav.navigation.token  = nav->navWithButtons.navToken;
c0de5d8a:	7cf1      	ldrb	r1, [r6, #19]
                        = nav->navWithButtons.visiblePageIndicator;
c0de5d8c:	f88d 003f 	strb.w	r0, [sp, #63]	@ 0x3f
c0de5d90:	2001      	movs	r0, #1
                    footerDesc.textAndNav.tuneId                 = nav->tuneId;
c0de5d92:	f88d 3049 	strb.w	r3, [sp, #73]	@ 0x49
                    footerDesc.textAndNav.token                  = nav->quitToken;
c0de5d96:	f88d 2048 	strb.w	r2, [sp, #72]	@ 0x48
                    footerDesc.textAndNav.navigation.withBackKey = nav->navWithButtons.backButton;
c0de5d9a:	f88d 403c 	strb.w	r4, [sp, #60]	@ 0x3c
                    footerDesc.textAndNav.navigation.withPageIndicator = true;
c0de5d9e:	f88d 003e 	strb.w	r0, [sp, #62]	@ 0x3e
                    footerDesc.textAndNav.navigation.token  = nav->navWithButtons.navToken;
c0de5da2:	f88d 1038 	strb.w	r1, [sp, #56]	@ 0x38
                    footerDesc.textAndNav.navigation.tuneId = nav->tuneId;
c0de5da6:	f88d 3040 	strb.w	r3, [sp, #64]	@ 0x40
c0de5daa:	e029      	b.n	c0de5e00 <nbgl_pageDrawGenericContentExt+0x170>
                }
            }
            else if (nav->navWithButtons.quitText != NULL) {
c0de5dac:	6970      	ldr	r0, [r6, #20]
c0de5dae:	b360      	cbz	r0, c0de5e0a <nbgl_pageDrawGenericContentExt+0x17a>
c0de5db0:	2101      	movs	r1, #1
                // simple footer
                footerDesc.type                = FOOTER_SIMPLE_TEXT;
                footerDesc.simpleText.text     = nav->navWithButtons.quitText;
c0de5db2:	900e      	str	r0, [sp, #56]	@ 0x38
c0de5db4:	2000      	movs	r0, #0
                footerDesc.type                = FOOTER_SIMPLE_TEXT;
c0de5db6:	f88d 1034 	strb.w	r1, [sp, #52]	@ 0x34
                footerDesc.simpleText.mutedOut = false;
c0de5dba:	f88d 003c 	strb.w	r0, [sp, #60]	@ 0x3c
                footerDesc.simpleText.token    = nav->quitToken;
c0de5dbe:	78b0      	ldrb	r0, [r6, #2]
                footerDesc.simpleText.tuneId   = nav->tuneId;
c0de5dc0:	7971      	ldrb	r1, [r6, #5]
                footerDesc.simpleText.token    = nav->quitToken;
c0de5dc2:	f88d 003d 	strb.w	r0, [sp, #61]	@ 0x3d
                footerDesc.simpleText.tuneId   = nav->tuneId;
c0de5dc6:	f88d 103e 	strb.w	r1, [sp, #62]	@ 0x3e
c0de5dca:	e019      	b.n	c0de5e00 <nbgl_pageDrawGenericContentExt+0x170>
c0de5dcc:	f04f 0800 	mov.w	r8, #0
c0de5dd0:	e01b      	b.n	c0de5e0a <nbgl_pageDrawGenericContentExt+0x17a>
c0de5dd2:	2104      	movs	r1, #4
                    footerDesc.type                         = FOOTER_NAV;
c0de5dd4:	f88d 1034 	strb.w	r1, [sp, #52]	@ 0x34
                    footerDesc.navigation.activePage        = nav->activePage;
c0de5dd8:	7831      	ldrb	r1, [r6, #0]
                    footerDesc.navigation.tuneId            = nav->tuneId;
c0de5dda:	7972      	ldrb	r2, [r6, #5]
                    footerDesc.navigation.withExitKey       = nav->navWithButtons.quitButton;
c0de5ddc:	7c33      	ldrb	r3, [r6, #16]
                    footerDesc.navigation.withBackKey       = nav->navWithButtons.backButton;
c0de5dde:	7c74      	ldrb	r4, [r6, #17]
                    footerDesc.navigation.activePage        = nav->activePage;
c0de5de0:	f88d 103a 	strb.w	r1, [sp, #58]	@ 0x3a
                    footerDesc.navigation.token             = nav->navWithButtons.navToken;
c0de5de4:	7cf1      	ldrb	r1, [r6, #19]
                    footerDesc.navigation.nbPages           = nav->nbPages;
c0de5de6:	f88d 0039 	strb.w	r0, [sp, #57]	@ 0x39
c0de5dea:	2000      	movs	r0, #0
                    footerDesc.navigation.withExitKey       = nav->navWithButtons.quitButton;
c0de5dec:	f88d 303b 	strb.w	r3, [sp, #59]	@ 0x3b
                    footerDesc.navigation.withBackKey       = nav->navWithButtons.backButton;
c0de5df0:	f88d 403c 	strb.w	r4, [sp, #60]	@ 0x3c
                    footerDesc.navigation.withPageIndicator = false;
c0de5df4:	f88d 003e 	strb.w	r0, [sp, #62]	@ 0x3e
                    footerDesc.navigation.token             = nav->navWithButtons.navToken;
c0de5df8:	f88d 1038 	strb.w	r1, [sp, #56]	@ 0x38
                    footerDesc.navigation.tuneId            = nav->tuneId;
c0de5dfc:	f88d 2040 	strb.w	r2, [sp, #64]	@ 0x40
c0de5e00:	a90d      	add	r1, sp, #52	@ 0x34
            }
            else {
                drawFooter = false;
            }
            if (drawFooter) {
                availableHeight -= nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de5e02:	4650      	mov	r0, sl
c0de5e04:	f7fc fa43 	bl	c0de228e <nbgl_layoutAddExtendedFooter>
c0de5e08:	1a3f      	subs	r7, r7, r0
    if (content->title != NULL) {
c0de5e0a:	6828      	ldr	r0, [r5, #0]
c0de5e0c:	b190      	cbz	r0, c0de5e34 <nbgl_pageDrawGenericContentExt+0x1a4>
c0de5e0e:	f240 1101 	movw	r1, #257	@ 0x101
        nbgl_layoutHeader_t headerDesc = {.type               = HEADER_BACK_AND_TEXT,
c0de5e12:	f8ad 1034 	strh.w	r1, [sp, #52]	@ 0x34
c0de5e16:	2100      	movs	r1, #0
                                          .backAndText.token  = content->titleToken,
c0de5e18:	e9cd 100e 	strd	r1, r0, [sp, #56]	@ 0x38
c0de5e1c:	7968      	ldrb	r0, [r5, #5]
                                          .backAndText.tuneId = content->tuneId,
c0de5e1e:	79a9      	ldrb	r1, [r5, #6]
                                          .backAndText.token  = content->titleToken,
c0de5e20:	f88d 0040 	strb.w	r0, [sp, #64]	@ 0x40
c0de5e24:	f88d 1041 	strb.w	r1, [sp, #65]	@ 0x41
c0de5e28:	a90d      	add	r1, sp, #52	@ 0x34
        nbgl_layoutAddHeader(layout, &headerDesc);
c0de5e2a:	4650      	mov	r0, sl
c0de5e2c:	f7fe fe88 	bl	c0de4b40 <nbgl_layoutAddHeader>
c0de5e30:	f04f 0801 	mov.w	r8, #1
    if (content->topRightIcon != NULL) {
c0de5e34:	68a9      	ldr	r1, [r5, #8]
c0de5e36:	b121      	cbz	r1, c0de5e42 <nbgl_pageDrawGenericContentExt+0x1b2>
            layout, content->topRightIcon, content->topRightToken, content->tuneId);
c0de5e38:	79ab      	ldrb	r3, [r5, #6]
c0de5e3a:	79ea      	ldrb	r2, [r5, #7]
        nbgl_layoutAddTopRightButton(
c0de5e3c:	4650      	mov	r0, sl
c0de5e3e:	f7fc f9c4 	bl	c0de21ca <nbgl_layoutAddTopRightButton>
    switch (content->type) {
c0de5e42:	7b28      	ldrb	r0, [r5, #12]
c0de5e44:	2804      	cmp	r0, #4
c0de5e46:	dd25      	ble.n	c0de5e94 <nbgl_pageDrawGenericContentExt+0x204>
c0de5e48:	2807      	cmp	r0, #7
c0de5e4a:	dc44      	bgt.n	c0de5ed6 <nbgl_pageDrawGenericContentExt+0x246>
c0de5e4c:	2805      	cmp	r0, #5
c0de5e4e:	f000 80a9 	beq.w	c0de5fa4 <nbgl_pageDrawGenericContentExt+0x314>
c0de5e52:	2806      	cmp	r0, #6
c0de5e54:	f000 80ca 	beq.w	c0de5fec <nbgl_pageDrawGenericContentExt+0x35c>
c0de5e58:	2807      	cmp	r0, #7
c0de5e5a:	f040 8195 	bne.w	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
            for (i = 0; i < content->switchesList.nbSwitches; i++) {
c0de5e5e:	7d28      	ldrb	r0, [r5, #20]
c0de5e60:	2800      	cmp	r0, #0
c0de5e62:	f000 8191 	beq.w	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
c0de5e66:	2400      	movs	r4, #0
c0de5e68:	2600      	movs	r6, #0
c0de5e6a:	e006      	b.n	c0de5e7a <nbgl_pageDrawGenericContentExt+0x1ea>
c0de5e6c:	7d28      	ldrb	r0, [r5, #20]
c0de5e6e:	3601      	adds	r6, #1
c0de5e70:	4286      	cmp	r6, r0
c0de5e72:	f104 040c 	add.w	r4, r4, #12
c0de5e76:	f080 8187 	bcs.w	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
                availableHeight -= nbgl_layoutAddSwitch(layout, &content->switchesList.switches[i]);
c0de5e7a:	6928      	ldr	r0, [r5, #16]
c0de5e7c:	1901      	adds	r1, r0, r4
c0de5e7e:	4650      	mov	r0, sl
c0de5e80:	f7fd fa51 	bl	c0de3326 <nbgl_layoutAddSwitch>
c0de5e84:	1a3f      	subs	r7, r7, r0
c0de5e86:	b2b8      	uxth	r0, r7
                if (availableHeight > 10) {
c0de5e88:	280b      	cmp	r0, #11
c0de5e8a:	d3ef      	bcc.n	c0de5e6c <nbgl_pageDrawGenericContentExt+0x1dc>
                    nbgl_layoutAddSeparationLine(layout);
c0de5e8c:	4650      	mov	r0, sl
c0de5e8e:	f7fe fcc6 	bl	c0de481e <nbgl_layoutAddSeparationLine>
c0de5e92:	e7eb      	b.n	c0de5e6c <nbgl_pageDrawGenericContentExt+0x1dc>
    switch (content->type) {
c0de5e94:	2801      	cmp	r0, #1
c0de5e96:	dd58      	ble.n	c0de5f4a <nbgl_pageDrawGenericContentExt+0x2ba>
c0de5e98:	2802      	cmp	r0, #2
c0de5e9a:	f000 80eb 	beq.w	c0de6074 <nbgl_pageDrawGenericContentExt+0x3e4>
c0de5e9e:	2803      	cmp	r0, #3
c0de5ea0:	f000 80ff 	beq.w	c0de60a2 <nbgl_pageDrawGenericContentExt+0x412>
c0de5ea4:	2804      	cmp	r0, #4
c0de5ea6:	f040 816f 	bne.w	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
            if (!headerAdded) {
c0de5eaa:	f1b8 0f00 	cmp.w	r8, #0
c0de5eae:	d10c      	bne.n	c0de5eca <nbgl_pageDrawGenericContentExt+0x23a>
c0de5eb0:	2000      	movs	r0, #0
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de5eb2:	9011      	str	r0, [sp, #68]	@ 0x44
c0de5eb4:	e9cd 000f 	strd	r0, r0, [sp, #60]	@ 0x3c
c0de5eb8:	e9cd 000d 	strd	r0, r0, [sp, #52]	@ 0x34
c0de5ebc:	2028      	movs	r0, #40	@ 0x28
c0de5ebe:	f8ad 0038 	strh.w	r0, [sp, #56]	@ 0x38
c0de5ec2:	a90d      	add	r1, sp, #52	@ 0x34
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de5ec4:	4650      	mov	r0, sl
c0de5ec6:	f7fe fe3b 	bl	c0de4b40 <nbgl_layoutAddHeader>
            nbgl_layoutAddTagValueList(layout, &content->tagValueList);
c0de5eca:	f105 0110 	add.w	r1, r5, #16
c0de5ece:	4650      	mov	r0, sl
c0de5ed0:	f7fe fa30 	bl	c0de4334 <nbgl_layoutAddTagValueList>
c0de5ed4:	e158      	b.n	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
    switch (content->type) {
c0de5ed6:	2808      	cmp	r0, #8
c0de5ed8:	f000 8107 	beq.w	c0de60ea <nbgl_pageDrawGenericContentExt+0x45a>
c0de5edc:	2809      	cmp	r0, #9
c0de5ede:	f000 8138 	beq.w	c0de6152 <nbgl_pageDrawGenericContentExt+0x4c2>
c0de5ee2:	280a      	cmp	r0, #10
c0de5ee4:	f040 8150 	bne.w	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
            for (i = 0; i < content->barsList.nbBars; i++) {
c0de5ee8:	7e28      	ldrb	r0, [r5, #24]
c0de5eea:	2800      	cmp	r0, #0
c0de5eec:	f000 814c 	beq.w	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
c0de5ef0:	f244 689c 	movw	r8, #18076	@ 0x469c
c0de5ef4:	f2c0 0800 	movt	r8, #0
c0de5ef8:	2400      	movs	r4, #0
c0de5efa:	44f8      	add	r8, pc
c0de5efc:	f10d 0b34 	add.w	fp, sp, #52	@ 0x34
c0de5f00:	2600      	movs	r6, #0
c0de5f02:	e004      	b.n	c0de5f0e <nbgl_pageDrawGenericContentExt+0x27e>
c0de5f04:	7e28      	ldrb	r0, [r5, #24]
c0de5f06:	3601      	adds	r6, #1
c0de5f08:	4286      	cmp	r6, r0
c0de5f0a:	f080 813d 	bcs.w	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
                bar.text      = content->barsList.barTexts[i];
c0de5f0e:	6928      	ldr	r0, [r5, #16]
                bar.token     = content->barsList.tokens[i];
c0de5f10:	6969      	ldr	r1, [r5, #20]
                bar.text      = content->barsList.barTexts[i];
c0de5f12:	f850 0026 	ldr.w	r0, [r0, r6, lsl #2]
                bar.iconRight = &PUSH_ICON;
c0de5f16:	e9cd 840f 	strd	r8, r4, [sp, #60]	@ 0x3c
                bar.iconLeft  = NULL;
c0de5f1a:	e9cd 400d 	strd	r4, r0, [sp, #52]	@ 0x34
                bar.token     = content->barsList.tokens[i];
c0de5f1e:	5d88      	ldrb	r0, [r1, r6]
                bar.tuneId    = content->barsList.tuneId;
c0de5f20:	7e69      	ldrb	r1, [r5, #25]
                bar.token     = content->barsList.tokens[i];
c0de5f22:	f88d 0045 	strb.w	r0, [sp, #69]	@ 0x45
                bar.tuneId    = content->barsList.tuneId;
c0de5f26:	f88d 1048 	strb.w	r1, [sp, #72]	@ 0x48
                availableHeight -= nbgl_layoutAddTouchableBar(layout, &bar);
c0de5f2a:	4650      	mov	r0, sl
c0de5f2c:	4659      	mov	r1, fp
                bar.large     = false;
c0de5f2e:	f88d 4044 	strb.w	r4, [sp, #68]	@ 0x44
                bar.inactive  = false;
c0de5f32:	f88d 4046 	strb.w	r4, [sp, #70]	@ 0x46
                availableHeight -= nbgl_layoutAddTouchableBar(layout, &bar);
c0de5f36:	f7fc ff23 	bl	c0de2d80 <nbgl_layoutAddTouchableBar>
c0de5f3a:	1a3f      	subs	r7, r7, r0
c0de5f3c:	b2b8      	uxth	r0, r7
                if (availableHeight > 10) {
c0de5f3e:	280b      	cmp	r0, #11
c0de5f40:	d3e0      	bcc.n	c0de5f04 <nbgl_pageDrawGenericContentExt+0x274>
                    nbgl_layoutAddSeparationLine(layout);
c0de5f42:	4650      	mov	r0, sl
c0de5f44:	f7fe fc6b 	bl	c0de481e <nbgl_layoutAddSeparationLine>
c0de5f48:	e7dc      	b.n	c0de5f04 <nbgl_pageDrawGenericContentExt+0x274>
    switch (content->type) {
c0de5f4a:	2800      	cmp	r0, #0
c0de5f4c:	f000 8107 	beq.w	c0de615e <nbgl_pageDrawGenericContentExt+0x4ce>
c0de5f50:	2801      	cmp	r0, #1
c0de5f52:	f040 8119 	bne.w	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
            if (!headerAdded) {
c0de5f56:	f1b8 0f00 	cmp.w	r8, #0
c0de5f5a:	d10c      	bne.n	c0de5f76 <nbgl_pageDrawGenericContentExt+0x2e6>
c0de5f5c:	2000      	movs	r0, #0
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de5f5e:	9011      	str	r0, [sp, #68]	@ 0x44
c0de5f60:	e9cd 000f 	strd	r0, r0, [sp, #60]	@ 0x3c
c0de5f64:	e9cd 000d 	strd	r0, r0, [sp, #52]	@ 0x34
c0de5f68:	2028      	movs	r0, #40	@ 0x28
c0de5f6a:	f8ad 0038 	strh.w	r0, [sp, #56]	@ 0x38
c0de5f6e:	a90d      	add	r1, sp, #52	@ 0x34
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de5f70:	4650      	mov	r0, sl
c0de5f72:	f7fe fde5 	bl	c0de4b40 <nbgl_layoutAddHeader>
            nbgl_layoutAddContentCenter(layout, &content->extendedCenter.contentCenter);
c0de5f76:	f105 0110 	add.w	r1, r5, #16
c0de5f7a:	4650      	mov	r0, sl
c0de5f7c:	f7fe f808 	bl	c0de3f90 <nbgl_layoutAddContentCenter>
            if (content->extendedCenter.tipBox.text != NULL) {
c0de5f80:	6b68      	ldr	r0, [r5, #52]	@ 0x34
c0de5f82:	2800      	cmp	r0, #0
c0de5f84:	f000 8100 	beq.w	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
c0de5f88:	2103      	movs	r1, #3
                    = {.type          = UP_FOOTER_TIP_BOX,
c0de5f8a:	f88d 1034 	strb.w	r1, [sp, #52]	@ 0x34
                       .tipBox.text   = content->extendedCenter.tipBox.text,
c0de5f8e:	900e      	str	r0, [sp, #56]	@ 0x38
                       .tipBox.icon   = content->extendedCenter.tipBox.icon,
c0de5f90:	6ba8      	ldr	r0, [r5, #56]	@ 0x38
                       .tipBox.token  = content->extendedCenter.tipBox.token,
c0de5f92:	8fa9      	ldrh	r1, [r5, #60]	@ 0x3c
                       .tipBox.text   = content->extendedCenter.tipBox.text,
c0de5f94:	900f      	str	r0, [sp, #60]	@ 0x3c
c0de5f96:	f8ad 1040 	strh.w	r1, [sp, #64]	@ 0x40
c0de5f9a:	a90d      	add	r1, sp, #52	@ 0x34
                nbgl_layoutAddUpFooter(layout, &upFooterDesc);
c0de5f9c:	4650      	mov	r0, sl
c0de5f9e:	f7fb fc7d 	bl	c0de189c <nbgl_layoutAddUpFooter>
c0de5fa2:	e0f1      	b.n	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
            if (!headerAdded) {
c0de5fa4:	f1b8 0f00 	cmp.w	r8, #0
c0de5fa8:	d10c      	bne.n	c0de5fc4 <nbgl_pageDrawGenericContentExt+0x334>
c0de5faa:	2000      	movs	r0, #0
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de5fac:	9011      	str	r0, [sp, #68]	@ 0x44
c0de5fae:	e9cd 000f 	strd	r0, r0, [sp, #60]	@ 0x3c
c0de5fb2:	e9cd 000d 	strd	r0, r0, [sp, #52]	@ 0x34
c0de5fb6:	2028      	movs	r0, #40	@ 0x28
c0de5fb8:	f8ad 0038 	strh.w	r0, [sp, #56]	@ 0x38
c0de5fbc:	a90d      	add	r1, sp, #52	@ 0x34
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de5fbe:	4650      	mov	r0, sl
c0de5fc0:	f7fe fdbe 	bl	c0de4b40 <nbgl_layoutAddHeader>
            content->tagValueDetails.tagValueList.nbMaxLinesForValue -= 3;
c0de5fc4:	7ee8      	ldrb	r0, [r5, #27]
c0de5fc6:	f105 0110 	add.w	r1, r5, #16
c0de5fca:	3803      	subs	r0, #3
c0de5fcc:	76e8      	strb	r0, [r5, #27]
            nbgl_layoutAddTagValueList(layout, &content->tagValueDetails.tagValueList);
c0de5fce:	4650      	mov	r0, sl
c0de5fd0:	f7fe f9b0 	bl	c0de4334 <nbgl_layoutAddTagValueList>
c0de5fd4:	2001      	movs	r0, #1
            buttonInfo.fittingContent = true;
c0de5fd6:	f8ad 003e 	strh.w	r0, [sp, #62]	@ 0x3e
            buttonInfo.icon           = content->tagValueDetails.detailsButtonIcon;
c0de5fda:	e9d5 1209 	ldrd	r1, r2, [r5, #36]	@ 0x24
            buttonInfo.style          = WHITE_BACKGROUND;
c0de5fde:	f88d 003d 	strb.w	r0, [sp, #61]	@ 0x3d
            buttonInfo.token          = content->tagValueDetails.detailsButtonToken;
c0de5fe2:	f895 002c 	ldrb.w	r0, [r5, #44]	@ 0x2c
            buttonInfo.icon           = content->tagValueDetails.detailsButtonIcon;
c0de5fe6:	910e      	str	r1, [sp, #56]	@ 0x38
            buttonInfo.text           = content->tagValueDetails.detailsButtonText;
c0de5fe8:	920d      	str	r2, [sp, #52]	@ 0x34
c0de5fea:	e03b      	b.n	c0de6064 <nbgl_pageDrawGenericContentExt+0x3d4>
            if (!headerAdded) {
c0de5fec:	f1b8 0f00 	cmp.w	r8, #0
c0de5ff0:	d10c      	bne.n	c0de600c <nbgl_pageDrawGenericContentExt+0x37c>
c0de5ff2:	2000      	movs	r0, #0
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de5ff4:	9011      	str	r0, [sp, #68]	@ 0x44
c0de5ff6:	e9cd 000f 	strd	r0, r0, [sp, #60]	@ 0x3c
c0de5ffa:	e9cd 000d 	strd	r0, r0, [sp, #52]	@ 0x34
c0de5ffe:	2028      	movs	r0, #40	@ 0x28
c0de6000:	f8ad 0038 	strh.w	r0, [sp, #56]	@ 0x38
c0de6004:	a90d      	add	r1, sp, #52	@ 0x34
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de6006:	4650      	mov	r0, sl
c0de6008:	f7fe fd9a 	bl	c0de4b40 <nbgl_layoutAddHeader>
            nbgl_layoutAddTagValueList(layout, &content->tagValueConfirm.tagValueList);
c0de600c:	f105 0110 	add.w	r1, r5, #16
c0de6010:	4650      	mov	r0, sl
c0de6012:	f7fe f98f 	bl	c0de4334 <nbgl_layoutAddTagValueList>
            if (content->tagValueConfirm.detailsButtonText != NULL) {
c0de6016:	6aa8      	ldr	r0, [r5, #40]	@ 0x28
c0de6018:	2800      	cmp	r0, #0
c0de601a:	f000 80bc 	beq.w	c0de6196 <nbgl_pageDrawGenericContentExt+0x506>
c0de601e:	2101      	movs	r1, #1
                buttonInfo.fittingContent = true;
c0de6020:	f8ad 103e 	strh.w	r1, [sp, #62]	@ 0x3e
                buttonInfo.style          = WHITE_BACKGROUND;
c0de6024:	f88d 103d 	strb.w	r1, [sp, #61]	@ 0x3d
                buttonInfo.text           = content->tagValueConfirm.detailsButtonText;
c0de6028:	900d      	str	r0, [sp, #52]	@ 0x34
                buttonInfo.token          = content->tagValueConfirm.detailsButtonToken;
c0de602a:	f895 002c 	ldrb.w	r0, [r5, #44]	@ 0x2c
                buttonInfo.tuneId         = content->tagValueConfirm.tuneId;
c0de602e:	f895 102d 	ldrb.w	r1, [r5, #45]	@ 0x2d
                buttonInfo.icon           = content->tagValueConfirm.detailsButtonIcon;
c0de6032:	6a6a      	ldr	r2, [r5, #36]	@ 0x24
                buttonInfo.token          = content->tagValueConfirm.detailsButtonToken;
c0de6034:	f88d 003c 	strb.w	r0, [sp, #60]	@ 0x3c
                buttonInfo.tuneId         = content->tagValueConfirm.tuneId;
c0de6038:	f88d 1040 	strb.w	r1, [sp, #64]	@ 0x40
c0de603c:	a90d      	add	r1, sp, #52	@ 0x34
                nbgl_layoutAddButton(layout, &buttonInfo);
c0de603e:	4650      	mov	r0, sl
                buttonInfo.icon           = content->tagValueConfirm.detailsButtonIcon;
c0de6040:	920e      	str	r2, [sp, #56]	@ 0x38
                nbgl_layoutAddButton(layout, &buttonInfo);
c0de6042:	f7fe fc22 	bl	c0de488a <nbgl_layoutAddButton>
            if (content->tagValueConfirm.confirmationText != NULL) {
c0de6046:	6b28      	ldr	r0, [r5, #48]	@ 0x30
c0de6048:	2800      	cmp	r0, #0
c0de604a:	f000 809d 	beq.w	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
c0de604e:	f44f 7180 	mov.w	r1, #256	@ 0x100
                buttonInfo.fittingContent = false;
c0de6052:	f8ad 103e 	strh.w	r1, [sp, #62]	@ 0x3e
c0de6056:	2100      	movs	r1, #0
                buttonInfo.text           = content->tagValueConfirm.confirmationText;
c0de6058:	900d      	str	r0, [sp, #52]	@ 0x34
                buttonInfo.token          = content->tagValueConfirm.confirmationToken;
c0de605a:	f895 0038 	ldrb.w	r0, [r5, #56]	@ 0x38
                buttonInfo.icon           = NULL;
c0de605e:	910e      	str	r1, [sp, #56]	@ 0x38
                buttonInfo.style          = BLACK_BACKGROUND;
c0de6060:	f88d 103d 	strb.w	r1, [sp, #61]	@ 0x3d
c0de6064:	f895 102d 	ldrb.w	r1, [r5, #45]	@ 0x2d
c0de6068:	f88d 003c 	strb.w	r0, [sp, #60]	@ 0x3c
c0de606c:	f88d 1040 	strb.w	r1, [sp, #64]	@ 0x40
c0de6070:	a90d      	add	r1, sp, #52	@ 0x34
c0de6072:	e036      	b.n	c0de60e2 <nbgl_pageDrawGenericContentExt+0x452>
c0de6074:	ae0d      	add	r6, sp, #52	@ 0x34
            nbgl_contentCenter_t centeredInfo = {0};
c0de6076:	4630      	mov	r0, r6
c0de6078:	2124      	movs	r1, #36	@ 0x24
c0de607a:	f003 fe9f 	bl	c0de9dbc <__aeabi_memclr>
            centeredInfo.title                = content->infoLongPress.text;
c0de607e:	e9d5 1004 	ldrd	r1, r0, [r5, #16]
            centeredInfo.icon                 = content->infoLongPress.icon;
c0de6082:	900e      	str	r0, [sp, #56]	@ 0x38
c0de6084:	2000      	movs	r0, #0
            centeredInfo.title                = content->infoLongPress.text;
c0de6086:	9111      	str	r1, [sp, #68]	@ 0x44
            centeredInfo.illustrType          = ICON_ILLUSTRATION;
c0de6088:	f88d 0034 	strb.w	r0, [sp, #52]	@ 0x34
            nbgl_layoutAddContentCenter(layout, &centeredInfo);
c0de608c:	4650      	mov	r0, sl
c0de608e:	4631      	mov	r1, r6
c0de6090:	f7fd ff7e 	bl	c0de3f90 <nbgl_layoutAddContentCenter>
                                          content->infoLongPress.longPressText,
c0de6094:	69a9      	ldr	r1, [r5, #24]
                                          content->infoLongPress.longPressToken,
c0de6096:	7f2a      	ldrb	r2, [r5, #28]
                                          content->infoLongPress.tuneId);
c0de6098:	7f6b      	ldrb	r3, [r5, #29]
            nbgl_layoutAddLongPressButton(layout,
c0de609a:	4650      	mov	r0, sl
c0de609c:	f7fe fd13 	bl	c0de4ac6 <nbgl_layoutAddLongPressButton>
c0de60a0:	e072      	b.n	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
c0de60a2:	ae0d      	add	r6, sp, #52	@ 0x34
            nbgl_contentCenter_t centeredInfo = {0};
c0de60a4:	4630      	mov	r0, r6
c0de60a6:	2124      	movs	r1, #36	@ 0x24
c0de60a8:	f003 fe88 	bl	c0de9dbc <__aeabi_memclr>
            centeredInfo.title       = content->infoButton.text;
c0de60ac:	e9d5 1004 	ldrd	r1, r0, [r5, #16]
c0de60b0:	2400      	movs	r4, #0
            centeredInfo.icon        = content->infoButton.icon;
c0de60b2:	900e      	str	r0, [sp, #56]	@ 0x38
            centeredInfo.title       = content->infoButton.text;
c0de60b4:	9111      	str	r1, [sp, #68]	@ 0x44
            nbgl_layoutAddContentCenter(layout, &centeredInfo);
c0de60b6:	4650      	mov	r0, sl
c0de60b8:	4631      	mov	r1, r6
            centeredInfo.illustrType = ICON_ILLUSTRATION;
c0de60ba:	f88d 4034 	strb.w	r4, [sp, #52]	@ 0x34
            nbgl_layoutAddContentCenter(layout, &centeredInfo);
c0de60be:	f7fd ff67 	bl	c0de3f90 <nbgl_layoutAddContentCenter>
c0de60c2:	f44f 7080 	mov.w	r0, #256	@ 0x100
            buttonInfo.fittingContent = false;
c0de60c6:	f8ad 002e 	strh.w	r0, [sp, #46]	@ 0x2e
            buttonInfo.text           = content->infoButton.buttonText;
c0de60ca:	69a8      	ldr	r0, [r5, #24]
            buttonInfo.tuneId         = content->infoButton.tuneId;
c0de60cc:	7f69      	ldrb	r1, [r5, #29]
            buttonInfo.text           = content->infoButton.buttonText;
c0de60ce:	9009      	str	r0, [sp, #36]	@ 0x24
            buttonInfo.token          = content->infoButton.buttonToken;
c0de60d0:	7f28      	ldrb	r0, [r5, #28]
            buttonInfo.icon           = NULL;
c0de60d2:	940a      	str	r4, [sp, #40]	@ 0x28
            buttonInfo.style          = BLACK_BACKGROUND;
c0de60d4:	f88d 402d 	strb.w	r4, [sp, #45]	@ 0x2d
            buttonInfo.token          = content->infoButton.buttonToken;
c0de60d8:	f88d 002c 	strb.w	r0, [sp, #44]	@ 0x2c
            buttonInfo.tuneId         = content->infoButton.tuneId;
c0de60dc:	f88d 1030 	strb.w	r1, [sp, #48]	@ 0x30
c0de60e0:	a909      	add	r1, sp, #36	@ 0x24
c0de60e2:	4650      	mov	r0, sl
c0de60e4:	f7fe fbd1 	bl	c0de488a <nbgl_layoutAddButton>
c0de60e8:	e04e      	b.n	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
            for (i = 0; i < content->infosList.nbInfos; i++) {
c0de60ea:	7f28      	ldrb	r0, [r5, #28]
c0de60ec:	2800      	cmp	r0, #0
c0de60ee:	d04b      	beq.n	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
c0de60f0:	2600      	movs	r6, #0
c0de60f2:	2400      	movs	r4, #0
c0de60f4:	e006      	b.n	c0de6104 <nbgl_pageDrawGenericContentExt+0x474>
c0de60f6:	bf00      	nop
c0de60f8:	7f28      	ldrb	r0, [r5, #28]
c0de60fa:	3401      	adds	r4, #1
c0de60fc:	4284      	cmp	r4, r0
c0de60fe:	f106 061c 	add.w	r6, r6, #28
c0de6102:	d241      	bcs.n	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
                if ((content->infosList.withExtensions == true)
c0de6104:	7fa8      	ldrb	r0, [r5, #30]
c0de6106:	b198      	cbz	r0, c0de6130 <nbgl_pageDrawGenericContentExt+0x4a0>
                    && (content->infosList.infoExtensions != NULL)
c0de6108:	69a8      	ldr	r0, [r5, #24]
c0de610a:	b188      	cbz	r0, c0de6130 <nbgl_pageDrawGenericContentExt+0x4a0>
                    && (content->infosList.infoExtensions[i].fullValue != NULL)) {
c0de610c:	5980      	ldr	r0, [r0, r6]
c0de610e:	b178      	cbz	r0, c0de6130 <nbgl_pageDrawGenericContentExt+0x4a0>
                                                       content->infosList.infoTypes[i],
c0de6110:	e9d5 0204 	ldrd	r0, r2, [r5, #16]
                                                       content->infosList.token,
c0de6114:	7f6b      	ldrb	r3, [r5, #29]
                                                       content->infosList.infoTypes[i],
c0de6116:	f850 1024 	ldr.w	r1, [r0, r4, lsl #2]
                                                       content->infosList.infoContents[i],
c0de611a:	f852 2024 	ldr.w	r2, [r2, r4, lsl #2]
                        -= nbgl_layoutAddTextWithAlias(layout,
c0de611e:	fa5f fc84 	uxtb.w	ip, r4
c0de6122:	4650      	mov	r0, sl
c0de6124:	f8cd c000 	str.w	ip, [sp]
c0de6128:	f7fd f950 	bl	c0de33cc <nbgl_layoutAddTextWithAlias>
c0de612c:	e009      	b.n	c0de6142 <nbgl_pageDrawGenericContentExt+0x4b2>
c0de612e:	bf00      	nop
                                                          content->infosList.infoTypes[i],
c0de6130:	e9d5 0204 	ldrd	r0, r2, [r5, #16]
c0de6134:	f850 1024 	ldr.w	r1, [r0, r4, lsl #2]
                                                          content->infosList.infoContents[i]);
c0de6138:	f852 2024 	ldr.w	r2, [r2, r4, lsl #2]
                    availableHeight -= nbgl_layoutAddText(layout,
c0de613c:	4650      	mov	r0, sl
c0de613e:	f7fd f921 	bl	c0de3384 <nbgl_layoutAddText>
c0de6142:	1a3f      	subs	r7, r7, r0
c0de6144:	b2b8      	uxth	r0, r7
                if (availableHeight > 10) {
c0de6146:	280b      	cmp	r0, #11
c0de6148:	d3d6      	bcc.n	c0de60f8 <nbgl_pageDrawGenericContentExt+0x468>
                    nbgl_layoutAddSeparationLine(layout);
c0de614a:	4650      	mov	r0, sl
c0de614c:	f7fe fb67 	bl	c0de481e <nbgl_layoutAddSeparationLine>
c0de6150:	e7d2      	b.n	c0de60f8 <nbgl_pageDrawGenericContentExt+0x468>
            nbgl_layoutAddRadioChoice(layout, &content->choicesList);
c0de6152:	f105 0110 	add.w	r1, r5, #16
c0de6156:	4650      	mov	r0, sl
c0de6158:	f7fd fa80 	bl	c0de365c <nbgl_layoutAddRadioChoice>
c0de615c:	e014      	b.n	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>
            if (!headerAdded) {
c0de615e:	f1b8 0f00 	cmp.w	r8, #0
c0de6162:	d10c      	bne.n	c0de617e <nbgl_pageDrawGenericContentExt+0x4ee>
c0de6164:	2000      	movs	r0, #0
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de6166:	9011      	str	r0, [sp, #68]	@ 0x44
c0de6168:	e9cd 000f 	strd	r0, r0, [sp, #60]	@ 0x3c
c0de616c:	e9cd 000d 	strd	r0, r0, [sp, #52]	@ 0x34
c0de6170:	2028      	movs	r0, #40	@ 0x28
c0de6172:	f8ad 0038 	strh.w	r0, [sp, #56]	@ 0x38
c0de6176:	a90d      	add	r1, sp, #52	@ 0x34
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de6178:	4650      	mov	r0, sl
c0de617a:	f7fe fce1 	bl	c0de4b40 <nbgl_layoutAddHeader>
            nbgl_layoutAddCenteredInfo(layout, &content->centeredInfo);
c0de617e:	f105 0110 	add.w	r1, r5, #16
c0de6182:	4650      	mov	r0, sl
c0de6184:	f7fd fbb5 	bl	c0de38f2 <nbgl_layoutAddCenteredInfo>
            }
#endif  // TARGET_STAX
        }
    }
    addContent(content, layout, availableHeight, headerAdded);
    nbgl_layoutDraw(layout);
c0de6188:	4650      	mov	r0, sl
c0de618a:	f7ff f91f 	bl	c0de53cc <nbgl_layoutDraw>

    return (nbgl_page_t *) layout;
c0de618e:	4650      	mov	r0, sl
c0de6190:	b016      	add	sp, #88	@ 0x58
c0de6192:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            else if ((content->tagValueConfirm.detailsButtonIcon != NULL)
c0de6196:	6a68      	ldr	r0, [r5, #36]	@ 0x24
                     && (content->tagValueConfirm.confirmationText != NULL)) {
c0de6198:	2800      	cmp	r0, #0
c0de619a:	f43f af54 	beq.w	c0de6046 <nbgl_pageDrawGenericContentExt+0x3b6>
c0de619e:	6b29      	ldr	r1, [r5, #48]	@ 0x30
            else if ((content->tagValueConfirm.detailsButtonIcon != NULL)
c0de61a0:	2900      	cmp	r1, #0
c0de61a2:	f43f af50 	beq.w	c0de6046 <nbgl_pageDrawGenericContentExt+0x3b6>
                    = {.leftIcon   = content->tagValueConfirm.detailsButtonIcon,
c0de61a6:	e9cd 010d 	strd	r0, r1, [sp, #52]	@ 0x34
                       .leftToken  = content->tagValueConfirm.detailsButtonToken,
c0de61aa:	f895 002c 	ldrb.w	r0, [r5, #44]	@ 0x2c
                       .tuneId     = content->tagValueConfirm.tuneId};
c0de61ae:	f895 102d 	ldrb.w	r1, [r5, #45]	@ 0x2d
                       .rightToken = content->tagValueConfirm.confirmationToken,
c0de61b2:	f895 2038 	ldrb.w	r2, [r5, #56]	@ 0x38
                    = {.leftIcon   = content->tagValueConfirm.detailsButtonIcon,
c0de61b6:	f88d 003c 	strb.w	r0, [sp, #60]	@ 0x3c
c0de61ba:	f88d 103e 	strb.w	r1, [sp, #62]	@ 0x3e
c0de61be:	a90d      	add	r1, sp, #52	@ 0x34
                nbgl_layoutAddHorizontalButtons(layout, &choice);
c0de61c0:	4650      	mov	r0, sl
                    = {.leftIcon   = content->tagValueConfirm.detailsButtonIcon,
c0de61c2:	f88d 203d 	strb.w	r2, [sp, #61]	@ 0x3d
                nbgl_layoutAddHorizontalButtons(layout, &choice);
c0de61c6:	f7fe f8a0 	bl	c0de430a <nbgl_layoutAddHorizontalButtons>
c0de61ca:	e7dd      	b.n	c0de6188 <nbgl_pageDrawGenericContentExt+0x4f8>

c0de61cc <nbgl_pageDrawGenericContent>:
 * @return the page context (or NULL if error)
 */
nbgl_page_t *nbgl_pageDrawGenericContent(nbgl_layoutTouchCallback_t       onActionCallback,
                                         const nbgl_pageNavigationInfo_t *nav,
                                         nbgl_pageContent_t              *content)
{
c0de61cc:	b580      	push	{r7, lr}
    return nbgl_pageDrawGenericContentExt(onActionCallback, nav, content, false);
c0de61ce:	2300      	movs	r3, #0
c0de61d0:	f7ff fd5e 	bl	c0de5c90 <nbgl_pageDrawGenericContentExt>
c0de61d4:	bd80      	pop	{r7, pc}

c0de61d6 <nbgl_pageRelease>:
 *
 * @param page page to release
 * @return >= 0 if OK
 */
int nbgl_pageRelease(nbgl_page_t *page)
{
c0de61d6:	b580      	push	{r7, lr}
    int ret;

    LOG_DEBUG(PAGE_LOGGER, "nbgl_pageRelease(): \n");
    ret = nbgl_layoutRelease((nbgl_layout_t *) page);
c0de61d8:	f7ff f91c 	bl	c0de5414 <nbgl_layoutRelease>

    return ret;
c0de61dc:	bd80      	pop	{r7, pc}
	...

c0de61e0 <getNbTagValuesInPage>:
                                    uint8_t                           startIndex,
                                    bool                              isSkippable,
                                    bool                              hasConfirmationButton,
                                    bool                              hasDetailsButton,
                                    bool                             *requireSpecificDisplay)
{
c0de61e0:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de61e4:	b084      	sub	sp, #16
c0de61e6:	468b      	mov	fp, r1
c0de61e8:	990e      	ldr	r1, [sp, #56]	@ 0x38
c0de61ea:	4615      	mov	r5, r2
c0de61ec:	4604      	mov	r4, r0
c0de61ee:	f44f 70e8 	mov.w	r0, #464	@ 0x1d0
c0de61f2:	f04f 0800 	mov.w	r8, #0
c0de61f6:	2600      	movs	r6, #0
    uint16_t currentHeight   = PRE_TAG_VALUE_MARGIN;  // upper margin
    uint16_t maxUsableHeight = TAG_VALUE_AREA_HEIGHT;

    // if the review is skippable, it means that there is less height for tag/value pairs
    // the small centering header becomes a touchable header
    if (isSkippable) {
c0de61f8:	2b00      	cmp	r3, #0
c0de61fa:	bf18      	it	ne
c0de61fc:	f44f 70cc 	movne.w	r0, #408	@ 0x198
c0de6200:	9003      	str	r0, [sp, #12]
        maxUsableHeight -= TOUCHABLE_HEADER_BAR_HEIGHT - SMALL_CENTERING_HEADER;
    }

    *requireSpecificDisplay = false;
c0de6202:	f881 8000 	strb.w	r8, [r1]
c0de6206:	e9cd 2401 	strd	r2, r4, [sp, #4]
c0de620a:	e009      	b.n	c0de6220 <getNbTagValuesInPage+0x40>
            // This pair must be at the top of a page
            break;
        }

        if (pair->centeredInfo) {
            if (nbPairsInPage > 0) {
c0de620c:	f1ba 0f00 	cmp.w	sl, #0
c0de6210:	d002      	beq.n	c0de6218 <getNbTagValuesInPage+0x38>
c0de6212:	2000      	movs	r0, #0
c0de6214:	b920      	cbnz	r0, c0de6220 <getNbTagValuesInPage+0x40>
c0de6216:	e068      	b.n	c0de62ea <getNbTagValuesInPage+0x10a>
                break;
            }
            else {
                // This pair is the only one of the page and has a specific display behavior
                nbPairsInPage           = 1;
                *requireSpecificDisplay = true;
c0de6218:	980e      	ldr	r0, [sp, #56]	@ 0x38
c0de621a:	2601      	movs	r6, #1
c0de621c:	7006      	strb	r6, [r0, #0]
c0de621e:	e7f8      	b.n	c0de6212 <getNbTagValuesInPage+0x32>
    while (nbPairsInPage < nbPairs) {
c0de6220:	b2f0      	uxtb	r0, r6
c0de6222:	42a0      	cmp	r0, r4
c0de6224:	d261      	bcs.n	c0de62ea <getNbTagValuesInPage+0x10a>
        if (tagValueList->pairs != NULL) {
c0de6226:	f8db 1000 	ldr.w	r1, [fp]
        if (nbPairsInPage > 0) {
c0de622a:	ea5f 6a06 	movs.w	sl, r6, lsl #24
c0de622e:	bf18      	it	ne
c0de6230:	f108 0818 	addne.w	r8, r8, #24
        if (tagValueList->pairs != NULL) {
c0de6234:	b121      	cbz	r1, c0de6240 <getNbTagValuesInPage+0x60>
            pair = PIC(&tagValueList->pairs[startIndex + nbPairsInPage]);
c0de6236:	4428      	add	r0, r5
c0de6238:	eb01 1000 	add.w	r0, r1, r0, lsl #4
c0de623c:	e005      	b.n	c0de624a <getNbTagValuesInPage+0x6a>
c0de623e:	bf00      	nop
            pair = PIC(tagValueList->callback(startIndex + nbPairsInPage));
c0de6240:	f8db 1004 	ldr.w	r1, [fp, #4]
c0de6244:	1970      	adds	r0, r6, r5
c0de6246:	b2c0      	uxtb	r0, r0
c0de6248:	4788      	blx	r1
c0de624a:	f003 fbb3 	bl	c0de99b4 <pic>
c0de624e:	4607      	mov	r7, r0
        if (pair->forcePageStart && nbPairsInPage > 0) {
c0de6250:	7b00      	ldrb	r0, [r0, #12]
c0de6252:	07c1      	lsls	r1, r0, #31
c0de6254:	bf18      	it	ne
c0de6256:	f1ba 0f00 	cmpne.w	sl, #0
c0de625a:	d1da      	bne.n	c0de6212 <getNbTagValuesInPage+0x32>
        if (pair->centeredInfo) {
c0de625c:	0780      	lsls	r0, r0, #30
c0de625e:	d4d5      	bmi.n	c0de620c <getNbTagValuesInPage+0x2c>
            }
        }

        // tag height
        currentHeight += nbgl_getTextHeightInWidth(
            SMALL_REGULAR_FONT, pair->item, AVAILABLE_WIDTH, tagValueList->wrapping);
c0de6260:	6839      	ldr	r1, [r7, #0]
c0de6262:	f89b 300e 	ldrb.w	r3, [fp, #14]
        currentHeight += nbgl_getTextHeightInWidth(
c0de6266:	200b      	movs	r0, #11
c0de6268:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de626c:	f002 fc94 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de6270:	4604      	mov	r4, r0
        // space between tag and value
        currentHeight += TAG_VALUE_INTERVALE;
        // set value font
        if (tagValueList->smallCaseForValue) {
c0de6272:	f89b 000d 	ldrb.w	r0, [fp, #13]
        else {
            value_font = LARGE_MEDIUM_FONT;
        }
        // value height
        currentHeight += nbgl_getTextHeightInWidth(
            value_font, pair->value, AVAILABLE_WIDTH, tagValueList->wrapping);
c0de6276:	f89b 300e 	ldrb.w	r3, [fp, #14]
c0de627a:	250b      	movs	r5, #11
c0de627c:	6879      	ldr	r1, [r7, #4]
c0de627e:	2800      	cmp	r0, #0
c0de6280:	bf08      	it	eq
c0de6282:	250d      	moveq	r5, #13
        currentHeight += nbgl_getTextHeightInWidth(
c0de6284:	4628      	mov	r0, r5
c0de6286:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de628a:	f002 fc85 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
        currentHeight += nbgl_getTextHeightInWidth(
c0de628e:	eb08 0104 	add.w	r1, r8, r4

        // potential subAlias text
        if ((pair->aliasValue) && (pair->extension->aliasSubName)) {
c0de6292:	7b3a      	ldrb	r2, [r7, #12]
        currentHeight += TAG_VALUE_INTERVALE;
c0de6294:	4408      	add	r0, r1
        if ((pair->aliasValue) && (pair->extension->aliasSubName)) {
c0de6296:	0751      	lsls	r1, r2, #29
        currentHeight += nbgl_getTextHeightInWidth(
c0de6298:	f100 0804 	add.w	r8, r0, #4
        if ((pair->aliasValue) && (pair->extension->aliasSubName)) {
c0de629c:	d508      	bpl.n	c0de62b0 <getNbTagValuesInPage+0xd0>
c0de629e:	68b8      	ldr	r0, [r7, #8]
c0de62a0:	6840      	ldr	r0, [r0, #4]
c0de62a2:	b128      	cbz	r0, c0de62b0 <getNbTagValuesInPage+0xd0>
            currentHeight += TAG_VALUE_INTERVALE + nbgl_getFontLineHeight(SMALL_REGULAR_FONT);
c0de62a4:	200b      	movs	r0, #11
c0de62a6:	f002 fc72 	bl	c0de8b8e <nbgl_getFontLineHeight>
c0de62aa:	4440      	add	r0, r8
c0de62ac:	f100 0804 	add.w	r8, r0, #4
        }
        // nb lines for value
        nbLines = nbgl_getTextNbLinesInWidth(
            value_font, pair->value, AVAILABLE_WIDTH, tagValueList->wrapping);
c0de62b0:	6879      	ldr	r1, [r7, #4]
c0de62b2:	f89b 300e 	ldrb.w	r3, [fp, #14]
        nbLines = nbgl_getTextNbLinesInWidth(
c0de62b6:	4628      	mov	r0, r5
c0de62b8:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de62bc:	f002 fc71 	bl	c0de8ba2 <nbgl_getTextNbLinesInWidth>
        if ((currentHeight >= maxUsableHeight) || (nbLines > NB_MAX_LINES_IN_REVIEW)) {
c0de62c0:	9a03      	ldr	r2, [sp, #12]
c0de62c2:	fa1f f188 	uxth.w	r1, r8
c0de62c6:	428a      	cmp	r2, r1
c0de62c8:	d904      	bls.n	c0de62d4 <getNbTagValuesInPage+0xf4>
c0de62ca:	280a      	cmp	r0, #10
c0de62cc:	d202      	bcs.n	c0de62d4 <getNbTagValuesInPage+0xf4>
                nbPairsInPage           = 1;
                *requireSpecificDisplay = true;
            }
            break;
        }
        nbPairsInPage++;
c0de62ce:	3601      	adds	r6, #1
c0de62d0:	2001      	movs	r0, #1
c0de62d2:	e006      	b.n	c0de62e2 <getNbTagValuesInPage+0x102>
            if (nbPairsInPage == 0) {
c0de62d4:	f1ba 0f00 	cmp.w	sl, #0
c0de62d8:	d102      	bne.n	c0de62e0 <getNbTagValuesInPage+0x100>
                *requireSpecificDisplay = true;
c0de62da:	980e      	ldr	r0, [sp, #56]	@ 0x38
c0de62dc:	2601      	movs	r6, #1
c0de62de:	7006      	strb	r6, [r0, #0]
c0de62e0:	2000      	movs	r0, #0
c0de62e2:	e9dd 5401 	ldrd	r5, r4, [sp, #4]
c0de62e6:	2800      	cmp	r0, #0
c0de62e8:	d19a      	bne.n	c0de6220 <getNbTagValuesInPage+0x40>
    }
    // if this is a TAG_VALUE_CONFIRM and we have reached the last pairs,
    // let's check if it still fits with a CONFIRMATION button, and if not,
    // remove the last pair
    if (hasConfirmationButton && (nbPairsInPage == nbPairs)) {
c0de62ea:	980c      	ldr	r0, [sp, #48]	@ 0x30
c0de62ec:	b150      	cbz	r0, c0de6304 <getNbTagValuesInPage+0x124>
c0de62ee:	b2f0      	uxtb	r0, r6
c0de62f0:	42a0      	cmp	r0, r4
c0de62f2:	d107      	bne.n	c0de6304 <getNbTagValuesInPage+0x124>
        maxUsableHeight -= UP_FOOTER_BUTTON_HEIGHT;
c0de62f4:	9803      	ldr	r0, [sp, #12]
        if (currentHeight > maxUsableHeight) {
c0de62f6:	fa1f f188 	uxth.w	r1, r8
        maxUsableHeight -= UP_FOOTER_BUTTON_HEIGHT;
c0de62fa:	f500 70bc 	add.w	r0, r0, #376	@ 0x178
        if (currentHeight > maxUsableHeight) {
c0de62fe:	f400 70ac 	and.w	r0, r0, #344	@ 0x158
c0de6302:	e008      	b.n	c0de6316 <getNbTagValuesInPage+0x136>
            nbPairsInPage--;
        }
    }
    // do the same with just a details button
    else if (hasDetailsButton) {
c0de6304:	980d      	ldr	r0, [sp, #52]	@ 0x34
c0de6306:	b148      	cbz	r0, c0de631c <getNbTagValuesInPage+0x13c>
        maxUsableHeight -= (SMALL_BUTTON_RADIUS * 2);
c0de6308:	9803      	ldr	r0, [sp, #12]
        if (currentHeight > maxUsableHeight) {
c0de630a:	fa1f f188 	uxth.w	r1, r8
        maxUsableHeight -= (SMALL_BUTTON_RADIUS * 2);
c0de630e:	f500 70e0 	add.w	r0, r0, #448	@ 0x1c0
        if (currentHeight > maxUsableHeight) {
c0de6312:	f400 70ec 	and.w	r0, r0, #472	@ 0x1d8
c0de6316:	4288      	cmp	r0, r1
c0de6318:	bf38      	it	cc
c0de631a:	3e01      	subcc	r6, #1
            nbPairsInPage--;
        }
    }
    return nbPairsInPage;
c0de631c:	b2f0      	uxtb	r0, r6
c0de631e:	b004      	add	sp, #16
c0de6320:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de6324 <nbgl_useCaseGetNbSwitchesInPage>:
 */
uint8_t nbgl_useCaseGetNbSwitchesInPage(uint8_t                           nbSwitches,
                                        const nbgl_contentSwitchesList_t *switchesList,
                                        uint8_t                           startIndex,
                                        bool                              withNav)
{
c0de6324:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
    uint8_t               nbSwitchesInPage = 0;
    uint16_t              currentHeight    = 0;
    uint16_t              previousHeight   = 0;
    uint16_t              navHeight        = withNav ? SIMPLE_FOOTER_HEIGHT : 0;
    nbgl_contentSwitch_t *switchArray      = (nbgl_contentSwitch_t *) PIC(switchesList->switches);
c0de6328:	6809      	ldr	r1, [r1, #0]
c0de632a:	4682      	mov	sl, r0
c0de632c:	4608      	mov	r0, r1
c0de632e:	4698      	mov	r8, r3
c0de6330:	4616      	mov	r6, r2
c0de6332:	f003 fb3f 	bl	c0de99b4 <pic>

    while (nbSwitchesInPage < nbSwitches) {
c0de6336:	eb06 0146 	add.w	r1, r6, r6, lsl #1
c0de633a:	eb00 0081 	add.w	r0, r0, r1, lsl #2
c0de633e:	f44f 7bfc 	mov.w	fp, #504	@ 0x1f8
c0de6342:	1d05      	adds	r5, r0, #4
c0de6344:	2600      	movs	r6, #0
c0de6346:	2400      	movs	r4, #0
c0de6348:	2700      	movs	r7, #0
c0de634a:	f1b8 0f00 	cmp.w	r8, #0
c0de634e:	bf18      	it	ne
c0de6350:	f44f 7bcc 	movne.w	fp, #408	@ 0x198
c0de6354:	e009      	b.n	c0de636a <nbgl_useCaseGetNbSwitchesInPage+0x46>
c0de6356:	bf00      	nop
            // sub-text height
            currentHeight += nbgl_getTextHeightInWidth(
                SMALL_REGULAR_FONT, curSwitch->subText, AVAILABLE_WIDTH, true);
        }
        // if height is over the limit
        if (currentHeight >= (INFOS_AREA_HEIGHT - navHeight)) {
c0de6358:	b2b8      	uxth	r0, r7
c0de635a:	4583      	cmp	fp, r0
c0de635c:	bf88      	it	hi
c0de635e:	463c      	movhi	r4, r7
c0de6360:	3601      	adds	r6, #1
c0de6362:	4583      	cmp	fp, r0
c0de6364:	f105 050c 	add.w	r5, r5, #12
c0de6368:	d926      	bls.n	c0de63b8 <nbgl_useCaseGetNbSwitchesInPage+0x94>
    while (nbSwitchesInPage < nbSwitches) {
c0de636a:	45b2      	cmp	sl, r6
c0de636c:	d027      	beq.n	c0de63be <nbgl_useCaseGetNbSwitchesInPage+0x9a>
        uint16_t textHeight = MAX(
c0de636e:	f855 1c04 	ldr.w	r1, [r5, #-4]
c0de6372:	200c      	movs	r0, #12
c0de6374:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de6378:	2301      	movs	r3, #1
c0de637a:	f002 fc0d 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de637e:	2828      	cmp	r0, #40	@ 0x28
c0de6380:	d202      	bcs.n	c0de6388 <nbgl_useCaseGetNbSwitchesInPage+0x64>
c0de6382:	2028      	movs	r0, #40	@ 0x28
c0de6384:	e008      	b.n	c0de6398 <nbgl_useCaseGetNbSwitchesInPage+0x74>
c0de6386:	bf00      	nop
c0de6388:	f855 1c04 	ldr.w	r1, [r5, #-4]
c0de638c:	200c      	movs	r0, #12
c0de638e:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de6392:	2301      	movs	r3, #1
c0de6394:	f002 fc00 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
        if (curSwitch->subText) {
c0de6398:	6829      	ldr	r1, [r5, #0]
        currentHeight += textHeight + 2 * LIST_ITEM_PRE_HEADING;
c0de639a:	4438      	add	r0, r7
        if (curSwitch->subText) {
c0de639c:	2900      	cmp	r1, #0
        currentHeight += textHeight + 2 * LIST_ITEM_PRE_HEADING;
c0de639e:	f100 0734 	add.w	r7, r0, #52	@ 0x34
        if (curSwitch->subText) {
c0de63a2:	d0d9      	beq.n	c0de6358 <nbgl_useCaseGetNbSwitchesInPage+0x34>
            currentHeight += nbgl_getTextHeightInWidth(
c0de63a4:	200b      	movs	r0, #11
c0de63a6:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de63aa:	2301      	movs	r3, #1
c0de63ac:	f002 fbf4 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
            currentHeight += LIST_ITEM_HEADING_SUB_TEXT;
c0de63b0:	4438      	add	r0, r7
            currentHeight += nbgl_getTextHeightInWidth(
c0de63b2:	f100 070c 	add.w	r7, r0, #12
c0de63b6:	e7cf      	b.n	c0de6358 <nbgl_useCaseGetNbSwitchesInPage+0x34>
        if (currentHeight >= (INFOS_AREA_HEIGHT - navHeight)) {
c0de63b8:	bf98      	it	ls
c0de63ba:	3e01      	subls	r6, #1
c0de63bc:	46b2      	mov	sl, r6
c0de63be:	b2a0      	uxth	r0, r4
c0de63c0:	08c0      	lsrs	r0, r0, #3
c0de63c2:	2100      	movs	r1, #0
c0de63c4:	2832      	cmp	r0, #50	@ 0x32
c0de63c6:	bf88      	it	hi
c0de63c8:	2101      	movhi	r1, #1
        previousHeight = currentHeight;
        nbSwitchesInPage++;
    }
    // if there was no nav, now there will be, so it can be necessary to remove the last
    // item
    if (!withNav && (previousHeight >= (INFOS_AREA_HEIGHT - SIMPLE_FOOTER_HEIGHT))) {
c0de63ca:	ea21 0008 	bic.w	r0, r1, r8
c0de63ce:	ebaa 0000 	sub.w	r0, sl, r0
        nbSwitchesInPage--;
    }
    return nbSwitchesInPage;
c0de63d2:	b2c0      	uxtb	r0, r0
c0de63d4:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de63d8 <useCaseHomeExt>:
{
c0de63d8:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de63dc:	b090      	sub	sp, #64	@ 0x40
c0de63de:	460f      	mov	r7, r1
c0de63e0:	9c18      	ldr	r4, [sp, #96]	@ 0x60
c0de63e2:	4683      	mov	fp, r0
c0de63e4:	a803      	add	r0, sp, #12
    nbgl_pageInfoDescription_t info = {.centeredInfo.icon    = appIcon,
c0de63e6:	2134      	movs	r1, #52	@ 0x34
c0de63e8:	461e      	mov	r6, r3
c0de63ea:	4615      	mov	r5, r2
c0de63ec:	f003 fce6 	bl	c0de9dbc <__aeabi_memclr>
c0de63f0:	2000      	movs	r0, #0
c0de63f2:	2103      	movs	r1, #3
c0de63f4:	f8cd b00c 	str.w	fp, [sp, #12]
c0de63f8:	9706      	str	r7, [sp, #24]
c0de63fa:	f88d 001d 	strb.w	r0, [sp, #29]
                                       .topRightStyle = withSettings ? SETTINGS_ICON : INFO_ICON,
c0de63fe:	2e00      	cmp	r6, #0
c0de6400:	bf18      	it	ne
c0de6402:	2101      	movne	r1, #1
    nbgl_pageInfoDescription_t info = {.centeredInfo.icon    = appIcon,
c0de6404:	f88d 1020 	strb.w	r1, [sp, #32]
c0de6408:	2104      	movs	r1, #4
c0de640a:	f88d 1021 	strb.w	r1, [sp, #33]	@ 0x21
c0de640e:	2106      	movs	r1, #6
c0de6410:	f88d 1022 	strb.w	r1, [sp, #34]	@ 0x22
c0de6414:	2109      	movs	r1, #9
c0de6416:	f88d 103d 	strb.w	r1, [sp, #61]	@ 0x3d
    onNav           = NULL;
c0de641a:	f240 41e0 	movw	r1, #1248	@ 0x4e0
c0de641e:	f2c0 0100 	movt	r1, #0
c0de6422:	f849 0001 	str.w	r0, [r9, r1]
    onControls      = NULL;
c0de6426:	f240 41e4 	movw	r1, #1252	@ 0x4e4
c0de642a:	f2c0 0100 	movt	r1, #0
c0de642e:	f849 0001 	str.w	r0, [r9, r1]
    onContentAction = NULL;
c0de6432:	f240 713c 	movw	r1, #1852	@ 0x73c
c0de6436:	f2c0 0100 	movt	r1, #0
    onQuit          = NULL;
c0de643a:	f240 4adc 	movw	sl, #1244	@ 0x4dc
    onContinue      = NULL;
c0de643e:	f240 6764 	movw	r7, #1636	@ 0x664
    onAction        = NULL;
c0de6442:	f240 6660 	movw	r6, #1632	@ 0x660
    onContentAction = NULL;
c0de6446:	f849 0001 	str.w	r0, [r9, r1]
    onChoice        = NULL;
c0de644a:	f240 6154 	movw	r1, #1620	@ 0x654
    onQuit          = NULL;
c0de644e:	f2c0 0a00 	movt	sl, #0
    onContinue      = NULL;
c0de6452:	f2c0 0700 	movt	r7, #0
    onAction        = NULL;
c0de6456:	f2c0 0600 	movt	r6, #0
    onChoice        = NULL;
c0de645a:	f2c0 0100 	movt	r1, #0
    onQuit          = NULL;
c0de645e:	f849 000a 	str.w	r0, [r9, sl]
    onContinue      = NULL;
c0de6462:	f849 0007 	str.w	r0, [r9, r7]
    onAction        = NULL;
c0de6466:	f849 0006 	str.w	r0, [r9, r6]
    onChoice        = NULL;
c0de646a:	f849 0001 	str.w	r0, [r9, r1]
    memset(&genericContext, 0, sizeof(genericContext));
c0de646e:	f240 40f0 	movw	r0, #1264	@ 0x4f0
c0de6472:	f2c0 0000 	movt	r0, #0
c0de6476:	4448      	add	r0, r9
c0de6478:	2190      	movs	r1, #144	@ 0x90
c0de647a:	f003 fc9f 	bl	c0de9dbc <__aeabi_memclr>
    if ((homeAction->text != NULL) || (homeAction->icon != NULL)) {
c0de647e:	6820      	ldr	r0, [r4, #0]
c0de6480:	b918      	cbnz	r0, c0de648a <useCaseHomeExt+0xb2>
c0de6482:	6861      	ldr	r1, [r4, #4]
c0de6484:	2900      	cmp	r1, #0
c0de6486:	f000 8085 	beq.w	c0de6594 <useCaseHomeExt+0x1bc>
c0de648a:	2108      	movs	r1, #8
        info.bottomButtonsToken = ACTION_BUTTON_TOKEN;
c0de648c:	f88d 1023 	strb.w	r1, [sp, #35]	@ 0x23
        info.actionButtonIcon   = homeAction->icon;
c0de6490:	e9d4 2101 	ldrd	r2, r1, [r4, #4]
        info.actionButtonText   = homeAction->text;
c0de6494:	900d      	str	r0, [sp, #52]	@ 0x34
            = (homeAction->style == STRONG_HOME_ACTION) ? BLACK_BACKGROUND : WHITE_BACKGROUND;
c0de6496:	7b20      	ldrb	r0, [r4, #12]
        onAction                = homeAction->callback;
c0de6498:	f849 1006 	str.w	r1, [r9, r6]
        info.actionButtonIcon   = homeAction->icon;
c0de649c:	920e      	str	r2, [sp, #56]	@ 0x38
            = (homeAction->style == STRONG_HOME_ACTION) ? BLACK_BACKGROUND : WHITE_BACKGROUND;
c0de649e:	2800      	cmp	r0, #0
c0de64a0:	bf18      	it	ne
c0de64a2:	2001      	movne	r0, #1
c0de64a4:	f88d 003c 	strb.w	r0, [sp, #60]	@ 0x3c
c0de64a8:	e9dd 8419 	ldrd	r8, r4, [sp, #100]	@ 0x64
    if (tagline == NULL) {
c0de64ac:	2d00      	cmp	r5, #0
c0de64ae:	d157      	bne.n	c0de6560 <useCaseHomeExt+0x188>
        if (strlen(appName) > MAX_APP_NAME_FOR_SDK_TAGLINE) {
c0de64b0:	4658      	mov	r0, fp
c0de64b2:	f003 fce5 	bl	c0de9e80 <strlen>
c0de64b6:	f240 66bc 	movw	r6, #1724	@ 0x6bc
c0de64ba:	2814      	cmp	r0, #20
c0de64bc:	f2c0 0600 	movt	r6, #0
c0de64c0:	d313      	bcc.n	c0de64ea <useCaseHomeExt+0x112>
            snprintf(tmpString,
c0de64c2:	f644 61f2 	movw	r1, #20210	@ 0x4ef2
c0de64c6:	f2c0 0100 	movt	r1, #0
c0de64ca:	4479      	add	r1, pc
c0de64cc:	46a4      	mov	ip, r4
c0de64ce:	c93c      	ldmia	r1!, {r2, r3, r4, r5}
c0de64d0:	eb09 0006 	add.w	r0, r9, r6
c0de64d4:	c03c      	stmia	r0!, {r2, r3, r4, r5}
c0de64d6:	c93c      	ldmia	r1!, {r2, r3, r4, r5}
c0de64d8:	46b6      	mov	lr, r6
c0de64da:	c03c      	stmia	r0!, {r2, r3, r4, r5}
c0de64dc:	c97c      	ldmia	r1!, {r2, r3, r4, r5, r6}
c0de64de:	8809      	ldrh	r1, [r1, #0]
c0de64e0:	c07c      	stmia	r0!, {r2, r3, r4, r5, r6}
c0de64e2:	4676      	mov	r6, lr
c0de64e4:	4664      	mov	r4, ip
c0de64e6:	8001      	strh	r1, [r0, #0]
c0de64e8:	e016      	b.n	c0de6518 <useCaseHomeExt+0x140>
            snprintf(tmpString,
c0de64ea:	f644 40ed 	movw	r0, #19693	@ 0x4ced
c0de64ee:	f2c0 0000 	movt	r0, #0
c0de64f2:	4478      	add	r0, pc
c0de64f4:	9001      	str	r0, [sp, #4]
c0de64f6:	f644 02d9 	movw	r2, #18649	@ 0x48d9
c0de64fa:	f2c0 0200 	movt	r2, #0
c0de64fe:	f644 6308 	movw	r3, #19976	@ 0x4e08
c0de6502:	f2c0 0300 	movt	r3, #0
c0de6506:	eb09 0006 	add.w	r0, r9, r6
c0de650a:	447a      	add	r2, pc
c0de650c:	447b      	add	r3, pc
c0de650e:	214a      	movs	r1, #74	@ 0x4a
c0de6510:	f8cd b000 	str.w	fp, [sp]
c0de6514:	f003 f9d4 	bl	c0de98c0 <snprintf>
        if (nbgl_getTextNbLinesInWidth(SMALL_REGULAR_FONT, tmpString, AVAILABLE_WIDTH, false) > 3) {
c0de6518:	eb09 0506 	add.w	r5, r9, r6
c0de651c:	200b      	movs	r0, #11
c0de651e:	4629      	mov	r1, r5
c0de6520:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de6524:	2300      	movs	r3, #0
c0de6526:	f002 fb3c 	bl	c0de8ba2 <nbgl_getTextNbLinesInWidth>
c0de652a:	2804      	cmp	r0, #4
c0de652c:	d318      	bcc.n	c0de6560 <useCaseHomeExt+0x188>
c0de652e:	4630      	mov	r0, r6
            snprintf(tmpString,
c0de6530:	f644 468f 	movw	r6, #19599	@ 0x4c8f
c0de6534:	f2c0 0600 	movt	r6, #0
c0de6538:	f8cd b000 	str.w	fp, [sp]
c0de653c:	f644 1231 	movw	r2, #18737	@ 0x4931
c0de6540:	f2c0 0200 	movt	r2, #0
c0de6544:	f644 53c0 	movw	r3, #19904	@ 0x4dc0
c0de6548:	eb09 0500 	add.w	r5, r9, r0
c0de654c:	f2c0 0300 	movt	r3, #0
c0de6550:	447e      	add	r6, pc
c0de6552:	447a      	add	r2, pc
c0de6554:	447b      	add	r3, pc
c0de6556:	4628      	mov	r0, r5
c0de6558:	214a      	movs	r1, #74	@ 0x4a
c0de655a:	9601      	str	r6, [sp, #4]
c0de655c:	f003 f9b0 	bl	c0de98c0 <snprintf>
c0de6560:	9504      	str	r5, [sp, #16]
    onContinue = topRightCallback;
c0de6562:	f849 8007 	str.w	r8, [r9, r7]
    onQuit     = quitCallback;
c0de6566:	f849 400a 	str.w	r4, [r9, sl]
    pageContext = nbgl_pageDrawInfo(&pageCallback, NULL, &info);
c0de656a:	f640 3035 	movw	r0, #2869	@ 0xb35
c0de656e:	f2c0 0000 	movt	r0, #0
c0de6572:	4478      	add	r0, pc
c0de6574:	aa03      	add	r2, sp, #12
c0de6576:	2100      	movs	r1, #0
c0de6578:	f7ff fa2b 	bl	c0de59d2 <nbgl_pageDrawInfo>
c0de657c:	f240 6150 	movw	r1, #1616	@ 0x650
c0de6580:	f2c0 0100 	movt	r1, #0
c0de6584:	f849 0001 	str.w	r0, [r9, r1]
    nbgl_refreshSpecial(FULL_COLOR_CLEAN_REFRESH);
c0de6588:	2002      	movs	r0, #2
c0de658a:	f002 fab5 	bl	c0de8af8 <nbgl_refreshSpecial>
}
c0de658e:	b010      	add	sp, #64	@ 0x40
c0de6590:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de6594:	2002      	movs	r0, #2
        info.bottomButtonsToken = QUIT_TOKEN;
c0de6596:	f88d 0023 	strb.w	r0, [sp, #35]	@ 0x23
c0de659a:	2000      	movs	r0, #0
        onAction                = NULL;
c0de659c:	f849 0006 	str.w	r0, [r9, r6]
        info.actionButtonText   = NULL;
c0de65a0:	e9cd 000d 	strd	r0, r0, [sp, #52]	@ 0x34
c0de65a4:	e780      	b.n	c0de64a8 <useCaseHomeExt+0xd0>

c0de65a6 <displaySettingsPage>:
{
c0de65a6:	b5b0      	push	{r4, r5, r7, lr}
c0de65a8:	b090      	sub	sp, #64	@ 0x40
c0de65aa:	460c      	mov	r4, r1
c0de65ac:	4605      	mov	r5, r0
c0de65ae:	4668      	mov	r0, sp
    nbgl_pageContent_t content = {0};
c0de65b0:	2140      	movs	r1, #64	@ 0x40
c0de65b2:	f003 fc03 	bl	c0de9dbc <__aeabi_memclr>
    if ((onNav == NULL) || (onNav(page, &content) == false)) {
c0de65b6:	f240 40e0 	movw	r0, #1248	@ 0x4e0
c0de65ba:	f2c0 0000 	movt	r0, #0
c0de65be:	f859 2000 	ldr.w	r2, [r9, r0]
c0de65c2:	b36a      	cbz	r2, c0de6620 <displaySettingsPage+0x7a>
c0de65c4:	4669      	mov	r1, sp
c0de65c6:	4628      	mov	r0, r5
c0de65c8:	4790      	blx	r2
c0de65ca:	b348      	cbz	r0, c0de6620 <displaySettingsPage+0x7a>
    content.title            = pageTitle;
c0de65cc:	f240 40e8 	movw	r0, #1256	@ 0x4e8
c0de65d0:	f2c0 0000 	movt	r0, #0
c0de65d4:	f859 0000 	ldr.w	r0, [r9, r0]
c0de65d8:	466a      	mov	r2, sp
c0de65da:	9000      	str	r0, [sp, #0]
c0de65dc:	f240 2001 	movw	r0, #513	@ 0x201
    content.isTouchableTitle = true;
c0de65e0:	f8ad 0004 	strh.w	r0, [sp, #4]
c0de65e4:	2009      	movs	r0, #9
    content.tuneId           = TUNE_TAP_CASUAL;
c0de65e6:	f88d 0006 	strb.w	r0, [sp, #6]
    navInfo.activePage = page;
c0de65ea:	f240 6068 	movw	r0, #1640	@ 0x668
c0de65ee:	f2c0 0000 	movt	r0, #0
c0de65f2:	f809 5000 	strb.w	r5, [r9, r0]
c0de65f6:	eb09 0100 	add.w	r1, r9, r0
    pageContext        = nbgl_pageDrawGenericContent(&pageCallback, &navInfo, &content);
c0de65fa:	f640 20a5 	movw	r0, #2725	@ 0xaa5
c0de65fe:	f2c0 0000 	movt	r0, #0
c0de6602:	4478      	add	r0, pc
c0de6604:	f7ff fde2 	bl	c0de61cc <nbgl_pageDrawGenericContent>
c0de6608:	f240 6150 	movw	r1, #1616	@ 0x650
c0de660c:	f2c0 0100 	movt	r1, #0
c0de6610:	f849 0001 	str.w	r0, [r9, r1]
c0de6614:	2001      	movs	r0, #1
c0de6616:	2c00      	cmp	r4, #0
c0de6618:	bf18      	it	ne
c0de661a:	2002      	movne	r0, #2
c0de661c:	f002 fa6c 	bl	c0de8af8 <nbgl_refreshSpecial>
}
c0de6620:	b010      	add	sp, #64	@ 0x40
c0de6622:	bdb0      	pop	{r4, r5, r7, pc}

c0de6624 <nbgl_useCaseGenericSettings>:
void nbgl_useCaseGenericSettings(const char                   *appName,
                                 uint8_t                       initPage,
                                 const nbgl_genericContents_t *settingContents,
                                 const nbgl_contentInfoList_t *infosList,
                                 nbgl_callback_t               quitCallback)
{
c0de6624:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de6628:	b090      	sub	sp, #64	@ 0x40
c0de662a:	9101      	str	r1, [sp, #4]
    onContinue      = NULL;
c0de662c:	f240 6164 	movw	r1, #1636	@ 0x664
c0de6630:	4607      	mov	r7, r0
c0de6632:	2000      	movs	r0, #0
c0de6634:	f2c0 0100 	movt	r1, #0
c0de6638:	f849 0001 	str.w	r0, [r9, r1]
    onAction        = NULL;
c0de663c:	f240 6160 	movw	r1, #1632	@ 0x660
c0de6640:	f2c0 0100 	movt	r1, #0
c0de6644:	f849 0001 	str.w	r0, [r9, r1]
    onNav           = NULL;
c0de6648:	f240 41e0 	movw	r1, #1248	@ 0x4e0
c0de664c:	f2c0 0100 	movt	r1, #0
c0de6650:	f849 0001 	str.w	r0, [r9, r1]
    onControls      = NULL;
c0de6654:	f240 41e4 	movw	r1, #1252	@ 0x4e4
c0de6658:	f2c0 0100 	movt	r1, #0
c0de665c:	f849 0001 	str.w	r0, [r9, r1]
    onContentAction = NULL;
c0de6660:	f240 713c 	movw	r1, #1852	@ 0x73c
c0de6664:	f2c0 0100 	movt	r1, #0
    onQuit          = NULL;
c0de6668:	f240 45dc 	movw	r5, #1244	@ 0x4dc
    onContentAction = NULL;
c0de666c:	f849 0001 	str.w	r0, [r9, r1]
    onChoice        = NULL;
c0de6670:	f240 6154 	movw	r1, #1620	@ 0x654
    memset(&genericContext, 0, sizeof(genericContext));
c0de6674:	f240 48f0 	movw	r8, #1264	@ 0x4f0
    onQuit          = NULL;
c0de6678:	f2c0 0500 	movt	r5, #0
    onChoice        = NULL;
c0de667c:	f2c0 0100 	movt	r1, #0
    memset(&genericContext, 0, sizeof(genericContext));
c0de6680:	f2c0 0800 	movt	r8, #0
c0de6684:	f8dd a060 	ldr.w	sl, [sp, #96]	@ 0x60
    onQuit          = NULL;
c0de6688:	f849 0005 	str.w	r0, [r9, r5]
    onChoice        = NULL;
c0de668c:	f849 0001 	str.w	r0, [r9, r1]
    memset(&genericContext, 0, sizeof(genericContext));
c0de6690:	eb09 0008 	add.w	r0, r9, r8
c0de6694:	2190      	movs	r1, #144	@ 0x90
c0de6696:	469b      	mov	fp, r3
c0de6698:	4616      	mov	r6, r2
c0de669a:	f003 fb8f 	bl	c0de9dbc <__aeabi_memclr>
    reset_callbacks_and_context();

    // memorize context
    onQuit    = quitCallback;
    pageTitle = appName;
c0de669e:	f240 40e8 	movw	r0, #1256	@ 0x4e8
c0de66a2:	f2c0 0000 	movt	r0, #0
c0de66a6:	f849 7000 	str.w	r7, [r9, r0]
    navType   = GENERIC_NAV;
c0de66aa:	f240 40ec 	movw	r0, #1260	@ 0x4ec
c0de66ae:	f2c0 0000 	movt	r0, #0
c0de66b2:	2102      	movs	r1, #2
    onQuit    = quitCallback;
c0de66b4:	f849 a005 	str.w	sl, [r9, r5]
    navType   = GENERIC_NAV;
c0de66b8:	f809 1000 	strb.w	r1, [r9, r0]

    if (settingContents != NULL) {
c0de66bc:	b12e      	cbz	r6, c0de66ca <nbgl_useCaseGenericSettings+0xa6>
        memcpy(&genericContext.genericContents, settingContents, sizeof(nbgl_genericContents_t));
c0de66be:	eb09 0008 	add.w	r0, r9, r8
c0de66c2:	e896 000e 	ldmia.w	r6, {r1, r2, r3}
c0de66c6:	3004      	adds	r0, #4
c0de66c8:	c00e      	stmia	r0!, {r1, r2, r3}
c0de66ca:	f240 5280 	movw	r2, #1408	@ 0x580
    }
    if (infosList != NULL) {
c0de66ce:	f1bb 0f00 	cmp.w	fp, #0
c0de66d2:	f2c0 0200 	movt	r2, #0
c0de66d6:	d015      	beq.n	c0de6704 <nbgl_useCaseGenericSettings+0xe0>
        genericContext.hasFinishingContent = true;
c0de66d8:	eb09 0008 	add.w	r0, r9, r8
c0de66dc:	2101      	movs	r1, #1
        memset(&FINISHING_CONTENT, 0, sizeof(nbgl_content_t));
c0de66de:	eb09 0502 	add.w	r5, r9, r2
        genericContext.hasFinishingContent = true;
c0de66e2:	7501      	strb	r1, [r0, #20]
        memset(&FINISHING_CONTENT, 0, sizeof(nbgl_content_t));
c0de66e4:	f105 0038 	add.w	r0, r5, #56	@ 0x38
c0de66e8:	2138      	movs	r1, #56	@ 0x38
c0de66ea:	f003 fb67 	bl	c0de9dbc <__aeabi_memclr>
c0de66ee:	2008      	movs	r0, #8
        FINISHING_CONTENT.type = INFOS_LIST;
c0de66f0:	f885 0038 	strb.w	r0, [r5, #56]	@ 0x38
        memcpy(&FINISHING_CONTENT.content, infosList, sizeof(nbgl_content_u));
c0de66f4:	4659      	mov	r1, fp
c0de66f6:	f105 003c 	add.w	r0, r5, #60	@ 0x3c
c0de66fa:	c9fc      	ldmia	r1!, {r2, r3, r4, r5, r6, r7}
c0de66fc:	c0fc      	stmia	r0!, {r2, r3, r4, r5, r6, r7}
c0de66fe:	e891 00fc 	ldmia.w	r1, {r2, r3, r4, r5, r6, r7}
c0de6702:	c0fc      	stmia	r0!, {r2, r3, r4, r5, r6, r7}
    for (int i = 0; i < genericContents->nbContents; i++) {
c0de6704:	eb09 0008 	add.w	r0, r9, r8
c0de6708:	7b01      	ldrb	r1, [r0, #12]
c0de670a:	2900      	cmp	r1, #0
c0de670c:	d06e      	beq.n	c0de67ec <nbgl_useCaseGenericSettings+0x1c8>
c0de670e:	2500      	movs	r5, #0
c0de6710:	ae02      	add	r6, sp, #8
c0de6712:	f04f 0a00 	mov.w	sl, #0
c0de6716:	2700      	movs	r7, #0
        p_content = getContentAtIdx(genericContents, i, &content);
c0de6718:	fa4f f08a 	sxtb.w	r0, sl
    if (contentIdx < 0 || contentIdx >= genericContents->nbContents) {
c0de671c:	2800      	cmp	r0, #0
c0de671e:	f04f 0000 	mov.w	r0, #0
c0de6722:	d412      	bmi.n	c0de674a <nbgl_useCaseGenericSettings+0x126>
c0de6724:	162a      	asrs	r2, r5, #24
c0de6726:	428a      	cmp	r2, r1
c0de6728:	da0f      	bge.n	c0de674a <nbgl_useCaseGenericSettings+0x126>
    if (genericContents->callbackCallNeeded) {
c0de672a:	eb09 0008 	add.w	r0, r9, r8
c0de672e:	7900      	ldrb	r0, [r0, #4]
c0de6730:	b310      	cbz	r0, c0de6778 <nbgl_useCaseGenericSettings+0x154>
        memset(content, 0, sizeof(nbgl_content_t));
c0de6732:	4630      	mov	r0, r6
c0de6734:	2138      	movs	r1, #56	@ 0x38
c0de6736:	f003 fb41 	bl	c0de9dbc <__aeabi_memclr>
        genericContents->contentGetterCallback(contentIdx, content);
c0de673a:	eb09 0008 	add.w	r0, r9, r8
c0de673e:	6882      	ldr	r2, [r0, #8]
c0de6740:	fa5f f08a 	uxtb.w	r0, sl
c0de6744:	4631      	mov	r1, r6
c0de6746:	4790      	blx	r2
c0de6748:	4630      	mov	r0, r6
        if (p_content == NULL) {
c0de674a:	b300      	cbz	r0, c0de678e <nbgl_useCaseGenericSettings+0x16a>
                                        (i == (genericContents->nbContents - 1)),
c0de674c:	eb09 0408 	add.w	r4, r9, r8
c0de6750:	7b21      	ldrb	r1, [r4, #12]
        nbPages += getNbPagesForContent(p_content,
c0de6752:	2300      	movs	r3, #0
                                        (i == (genericContents->nbContents - 1)),
c0de6754:	ebaa 0101 	sub.w	r1, sl, r1
c0de6758:	3101      	adds	r1, #1
c0de675a:	fab1 f181 	clz	r1, r1
c0de675e:	094a      	lsrs	r2, r1, #5
        nbPages += getNbPagesForContent(p_content,
c0de6760:	b2f9      	uxtb	r1, r7
c0de6762:	f000 f849 	bl	c0de67f8 <getNbPagesForContent>
    for (int i = 0; i < genericContents->nbContents; i++) {
c0de6766:	7b21      	ldrb	r1, [r4, #12]
c0de6768:	f10a 0a01 	add.w	sl, sl, #1
        nbPages += getNbPagesForContent(p_content,
c0de676c:	4407      	add	r7, r0
    for (int i = 0; i < genericContents->nbContents; i++) {
c0de676e:	458a      	cmp	sl, r1
c0de6770:	f105 7580 	add.w	r5, r5, #16777216	@ 0x1000000
c0de6774:	d3d0      	bcc.n	c0de6718 <nbgl_useCaseGenericSettings+0xf4>
c0de6776:	e00b      	b.n	c0de6790 <nbgl_useCaseGenericSettings+0x16c>
        return PIC(&genericContents->contentsList[contentIdx]);
c0de6778:	eb09 0008 	add.w	r0, r9, r8
c0de677c:	6880      	ldr	r0, [r0, #8]
c0de677e:	ebc2 01c2 	rsb	r1, r2, r2, lsl #3
c0de6782:	eb00 00c1 	add.w	r0, r0, r1, lsl #3
c0de6786:	f003 f915 	bl	c0de99b4 <pic>
        if (p_content == NULL) {
c0de678a:	2800      	cmp	r0, #0
c0de678c:	d1de      	bne.n	c0de674c <nbgl_useCaseGenericSettings+0x128>
c0de678e:	2700      	movs	r7, #0
    }

    // fill navigation structure
    uint8_t nbPages = getNbPagesForGenericContents(&genericContext.genericContents, 0, false);
    if (infosList != NULL) {
c0de6790:	f1bb 0f00 	cmp.w	fp, #0
c0de6794:	d00b      	beq.n	c0de67ae <nbgl_useCaseGenericSettings+0x18a>
        nbPages += getNbPagesForContent(&FINISHING_CONTENT, nbPages, true, false);
c0de6796:	f240 5080 	movw	r0, #1408	@ 0x580
c0de679a:	f2c0 0000 	movt	r0, #0
c0de679e:	4448      	add	r0, r9
c0de67a0:	3038      	adds	r0, #56	@ 0x38
c0de67a2:	b2f9      	uxtb	r1, r7
c0de67a4:	2201      	movs	r2, #1
c0de67a6:	2300      	movs	r3, #0
c0de67a8:	f000 f826 	bl	c0de67f8 <getNbPagesForContent>
c0de67ac:	4407      	add	r7, r0
    memset(&navInfo, 0, sizeof(navInfo));
c0de67ae:	f240 6268 	movw	r2, #1640	@ 0x668
c0de67b2:	f2c0 0200 	movt	r2, #0
c0de67b6:	2100      	movs	r1, #0
c0de67b8:	eb09 0302 	add.w	r3, r9, r2
c0de67bc:	f849 1002 	str.w	r1, [r9, r2]
c0de67c0:	e9c3 1101 	strd	r1, r1, [r3, #4]
c0de67c4:	e9c3 1103 	strd	r1, r1, [r3, #12]
c0de67c8:	e9c3 1105 	strd	r1, r1, [r3, #20]
c0de67cc:	f44f 6110 	mov.w	r1, #2304	@ 0x900
c0de67d0:	9801      	ldr	r0, [sp, #4]
    navInfo.progressIndicator = false;
c0de67d2:	8099      	strh	r1, [r3, #4]
c0de67d4:	2101      	movs	r1, #1
    navInfo.navType           = NAV_WITH_BUTTONS;
c0de67d6:	70d9      	strb	r1, [r3, #3]
c0de67d8:	2203      	movs	r2, #3
        navInfo.navWithButtons.backButton = true;
c0de67da:	7459      	strb	r1, [r3, #17]
    }

    prepareNavInfo(false, nbPages, NULL);

    displayGenericContextPage(initPage, true);
c0de67dc:	2101      	movs	r1, #1
    navInfo.nbPages           = nbPages;
c0de67de:	705f      	strb	r7, [r3, #1]
        navInfo.navWithButtons.navToken   = NAV_TOKEN;
c0de67e0:	74da      	strb	r2, [r3, #19]
    displayGenericContextPage(initPage, true);
c0de67e2:	f000 f951 	bl	c0de6a88 <displayGenericContextPage>
}
c0de67e6:	b010      	add	sp, #64	@ 0x40
c0de67e8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de67ec:	2700      	movs	r7, #0
    if (infosList != NULL) {
c0de67ee:	f1bb 0f00 	cmp.w	fp, #0
c0de67f2:	d1d0      	bne.n	c0de6796 <nbgl_useCaseGenericSettings+0x172>
c0de67f4:	e7db      	b.n	c0de67ae <nbgl_useCaseGenericSettings+0x18a>
	...

c0de67f8 <getNbPagesForContent>:
{
c0de67f8:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de67fc:	b08e      	sub	sp, #56	@ 0x38
c0de67fe:	4684      	mov	ip, r0
    switch (content->type) {
c0de6800:	7800      	ldrb	r0, [r0, #0]
c0de6802:	4698      	mov	r8, r3
c0de6804:	2807      	cmp	r0, #7
c0de6806:	f04f 0a01 	mov.w	sl, #1
c0de680a:	9206      	str	r2, [sp, #24]
c0de680c:	910a      	str	r1, [sp, #40]	@ 0x28
c0de680e:	dc08      	bgt.n	c0de6822 <getNbPagesForContent+0x2a>
c0de6810:	2804      	cmp	r0, #4
c0de6812:	d00f      	beq.n	c0de6834 <getNbPagesForContent+0x3c>
c0de6814:	2806      	cmp	r0, #6
c0de6816:	d00d      	beq.n	c0de6834 <getNbPagesForContent+0x3c>
c0de6818:	2807      	cmp	r0, #7
            return content->content.switchesList.nbSwitches;
c0de681a:	bf08      	it	eq
c0de681c:	f89c a008 	ldrbeq.w	sl, [ip, #8]
c0de6820:	e010      	b.n	c0de6844 <getNbPagesForContent+0x4c>
    switch (content->type) {
c0de6822:	2808      	cmp	r0, #8
c0de6824:	d009      	beq.n	c0de683a <getNbPagesForContent+0x42>
c0de6826:	2809      	cmp	r0, #9
c0de6828:	d00a      	beq.n	c0de6840 <getNbPagesForContent+0x48>
c0de682a:	280a      	cmp	r0, #10
c0de682c:	bf08      	it	eq
c0de682e:	f89c a00c 	ldrbeq.w	sl, [ip, #12]
c0de6832:	e007      	b.n	c0de6844 <getNbPagesForContent+0x4c>
c0de6834:	f89c a00c 	ldrb.w	sl, [ip, #12]
c0de6838:	e004      	b.n	c0de6844 <getNbPagesForContent+0x4c>
            return content->content.infosList.nbInfos;
c0de683a:	f89c a010 	ldrb.w	sl, [ip, #16]
c0de683e:	e001      	b.n	c0de6844 <getNbPagesForContent+0x4c>
            return content->content.choicesList.nbChoices;
c0de6840:	f89c a009 	ldrb.w	sl, [ip, #9]
    while (nbElements > 0) {
c0de6844:	f1ba 0f00 	cmp.w	sl, #0
c0de6848:	f04f 0e00 	mov.w	lr, #0
c0de684c:	f000 8117 	beq.w	c0de6a7e <getNbPagesForContent+0x286>
c0de6850:	980a      	ldr	r0, [sp, #40]	@ 0x28
c0de6852:	f04f 0b00 	mov.w	fp, #0
c0de6856:	2800      	cmp	r0, #0
c0de6858:	bf18      	it	ne
c0de685a:	2001      	movne	r0, #1
c0de685c:	9906      	ldr	r1, [sp, #24]
c0de685e:	2700      	movs	r7, #0
c0de6860:	f081 0101 	eor.w	r1, r1, #1
c0de6864:	4308      	orrs	r0, r1
c0de6866:	9009      	str	r0, [sp, #36]	@ 0x24
c0de6868:	f10c 0004 	add.w	r0, ip, #4
c0de686c:	9104      	str	r1, [sp, #16]
c0de686e:	9007      	str	r0, [sp, #28]
c0de6870:	f8cd c020 	str.w	ip, [sp, #32]
c0de6874:	f8cd 8014 	str.w	r8, [sp, #20]
c0de6878:	e02d      	b.n	c0de68d6 <getNbPagesForContent+0xde>
            nbElementsInPage = MIN(nbMaxElementsPerContentType[content->type], nbElements);
c0de687a:	f644 31ee 	movw	r1, #19438	@ 0x4bee
c0de687e:	f2c0 0100 	movt	r1, #0
c0de6882:	4479      	add	r1, pc
c0de6884:	5c0d      	ldrb	r5, [r1, r0]
c0de6886:	fa5f f08a 	uxtb.w	r0, sl
c0de688a:	4285      	cmp	r5, r0
c0de688c:	bf28      	it	cs
c0de688e:	4655      	movcs	r5, sl
        genericContextSetPageInfo(pageIdxStart + nbPages, nbElementsInPage, flag);
c0de6890:	980a      	ldr	r0, [sp, #40]	@ 0x28
c0de6892:	f89d 1037 	ldrb.w	r1, [sp, #55]	@ 0x37
c0de6896:	4438      	add	r0, r7
    uint8_t pageData = SET_PAGE_NB_ELEMENTS(nbElements) + SET_PAGE_FLAG(flag);
c0de6898:	f005 0207 	and.w	r2, r5, #7
    genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de689c:	f240 7340 	movw	r3, #1856	@ 0x740
    uint8_t pageData = SET_PAGE_NB_ELEMENTS(nbElements) + SET_PAGE_FLAG(flag);
c0de68a0:	ea42 01c1 	orr.w	r1, r2, r1, lsl #3
        &= ~(0x0F << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS));
c0de68a4:	b2c0      	uxtb	r0, r0
c0de68a6:	2204      	movs	r2, #4
    genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de68a8:	f2c0 0300 	movt	r3, #0
        &= ~(0x0F << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS));
c0de68ac:	ea02 0280 	and.w	r2, r2, r0, lsl #2
    genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de68b0:	0840      	lsrs	r0, r0, #1
c0de68b2:	444b      	add	r3, r9
        &= ~(0x0F << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS));
c0de68b4:	5c1e      	ldrb	r6, [r3, r0]
c0de68b6:	240f      	movs	r4, #15
c0de68b8:	4094      	lsls	r4, r2
        |= pageData << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de68ba:	b2c9      	uxtb	r1, r1
        &= ~(0x0F << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS));
c0de68bc:	43a6      	bics	r6, r4
        |= pageData << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de68be:	4091      	lsls	r1, r2
c0de68c0:	4331      	orrs	r1, r6
        nbElements -= nbElementsInPage;
c0de68c2:	ebaa 0a05 	sub.w	sl, sl, r5
        elemIdx += nbElementsInPage;
c0de68c6:	44ab      	add	fp, r5
        |= pageData << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de68c8:	5419      	strb	r1, [r3, r0]
    while (nbElements > 0) {
c0de68ca:	ea5f 600a 	movs.w	r0, sl, lsl #24
        nbPages++;
c0de68ce:	f107 0701 	add.w	r7, r7, #1
    while (nbElements > 0) {
c0de68d2:	f000 80d5 	beq.w	c0de6a80 <getNbPagesForContent+0x288>
c0de68d6:	fa5f f58b 	uxtb.w	r5, fp
c0de68da:	4629      	mov	r1, r5
        flag = 0;
c0de68dc:	f88d e037 	strb.w	lr, [sp, #55]	@ 0x37
c0de68e0:	2d00      	cmp	r5, #0
        if (content->type == TAG_VALUE_LIST) {
c0de68e2:	f89c 0000 	ldrb.w	r0, [ip]
c0de68e6:	bf18      	it	ne
c0de68e8:	2101      	movne	r1, #1
        bool hasNav = !isLast || (pageIdxStart > 0) || (elemIdx > 0);
c0de68ea:	9a09      	ldr	r2, [sp, #36]	@ 0x24
        if (content->type == TAG_VALUE_LIST) {
c0de68ec:	2807      	cmp	r0, #7
        bool hasNav = !isLast || (pageIdxStart > 0) || (elemIdx > 0);
c0de68ee:	ea42 0401 	orr.w	r4, r2, r1
        if (content->type == TAG_VALUE_LIST) {
c0de68f2:	dc0d      	bgt.n	c0de6910 <getNbPagesForContent+0x118>
c0de68f4:	2804      	cmp	r0, #4
c0de68f6:	d02b      	beq.n	c0de6950 <getNbPagesForContent+0x158>
c0de68f8:	2806      	cmp	r0, #6
c0de68fa:	d06d      	beq.n	c0de69d8 <getNbPagesForContent+0x1e0>
c0de68fc:	2807      	cmp	r0, #7
c0de68fe:	d1bc      	bne.n	c0de687a <getNbPagesForContent+0x82>
            nbElementsInPage = nbgl_useCaseGetNbSwitchesInPage(
c0de6900:	9907      	ldr	r1, [sp, #28]
c0de6902:	fa5f f08a 	uxtb.w	r0, sl
c0de6906:	462a      	mov	r2, r5
c0de6908:	4623      	mov	r3, r4
c0de690a:	f7ff fd0b 	bl	c0de6324 <nbgl_useCaseGetNbSwitchesInPage>
c0de690e:	e071      	b.n	c0de69f4 <getNbPagesForContent+0x1fc>
        if (content->type == TAG_VALUE_LIST) {
c0de6910:	2808      	cmp	r0, #8
c0de6912:	d020      	beq.n	c0de6956 <getNbPagesForContent+0x15e>
c0de6914:	2809      	cmp	r0, #9
c0de6916:	d073      	beq.n	c0de6a00 <getNbPagesForContent+0x208>
c0de6918:	280a      	cmp	r0, #10
c0de691a:	d1ae      	bne.n	c0de687a <getNbPagesForContent+0x82>
c0de691c:	2c00      	cmp	r4, #0
c0de691e:	f44f 71fc 	mov.w	r1, #504	@ 0x1f8
    while (nbBarsInPage < nbBars) {
c0de6922:	fa5f f28a 	uxtb.w	r2, sl
c0de6926:	bf18      	it	ne
c0de6928:	f44f 71cc 	movne.w	r1, #408	@ 0x198
c0de692c:	2a02      	cmp	r2, #2
c0de692e:	f0c0 8081 	bcc.w	c0de6a34 <getNbPagesForContent+0x23c>
c0de6932:	235c      	movs	r3, #92	@ 0x5c
c0de6934:	2001      	movs	r0, #1
c0de6936:	255c      	movs	r5, #92	@ 0x5c
        currentHeight += LIST_ITEM_MIN_TEXT_HEIGHT + 2 * LIST_ITEM_PRE_HEADING;
c0de6938:	b29b      	uxth	r3, r3
c0de693a:	335c      	adds	r3, #92	@ 0x5c
        if (currentHeight >= (INFOS_AREA_HEIGHT - navHeight)) {
c0de693c:	b29e      	uxth	r6, r3
c0de693e:	428e      	cmp	r6, r1
c0de6940:	d27a      	bcs.n	c0de6a38 <getNbPagesForContent+0x240>
        nbBarsInPage++;
c0de6942:	3001      	adds	r0, #1
c0de6944:	b2c5      	uxtb	r5, r0
    while (nbBarsInPage < nbBars) {
c0de6946:	4295      	cmp	r5, r2
c0de6948:	4635      	mov	r5, r6
c0de694a:	d3f5      	bcc.n	c0de6938 <getNbPagesForContent+0x140>
c0de694c:	4635      	mov	r5, r6
c0de694e:	e072      	b.n	c0de6a36 <getNbPagesForContent+0x23e>
            nbElementsInPage = getNbTagValuesInPage(nbElements,
c0de6950:	e9cd ee00 	strd	lr, lr, [sp]
c0de6954:	e044      	b.n	c0de69e0 <getNbPagesForContent+0x1e8>
    const char *const *infoContents = PIC(infosList->infoContents);
c0de6956:	f8dc 0008 	ldr.w	r0, [ip, #8]
c0de695a:	f003 f82b 	bl	c0de99b4 <pic>
c0de695e:	4680      	mov	r8, r0
                                                   PIC(infoContents[startIndex + nbInfosInPage]),
c0de6960:	f850 0025 	ldr.w	r0, [r0, r5, lsl #2]
c0de6964:	f44f 76fc 	mov.w	r6, #504	@ 0x1f8
c0de6968:	2c00      	cmp	r4, #0
c0de696a:	bf18      	it	ne
c0de696c:	f44f 76cc 	movne.w	r6, #408	@ 0x198
c0de6970:	f003 f820 	bl	c0de99b4 <pic>
c0de6974:	4601      	mov	r1, r0
        currentHeight += nbgl_getTextHeightInWidth(SMALL_REGULAR_FONT,
c0de6976:	200b      	movs	r0, #11
c0de6978:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de697c:	2301      	movs	r3, #1
c0de697e:	f002 f90b 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de6982:	f100 0168 	add.w	r1, r0, #104	@ 0x68
        if (currentHeight >= (INFOS_AREA_HEIGHT - navHeight)) {
c0de6986:	b288      	uxth	r0, r1
c0de6988:	42b0      	cmp	r0, r6
c0de698a:	d25e      	bcs.n	c0de6a4a <getNbPagesForContent+0x252>
c0de698c:	fa5f f28a 	uxtb.w	r2, sl
    while (nbInfosInPage < nbInfos) {
c0de6990:	920c      	str	r2, [sp, #48]	@ 0x30
c0de6992:	eb08 0285 	add.w	r2, r8, r5, lsl #2
c0de6996:	2501      	movs	r5, #1
c0de6998:	9403      	str	r4, [sp, #12]
c0de699a:	920b      	str	r2, [sp, #44]	@ 0x2c
c0de699c:	9a0c      	ldr	r2, [sp, #48]	@ 0x30
c0de699e:	42aa      	cmp	r2, r5
c0de69a0:	d066      	beq.n	c0de6a70 <getNbPagesForContent+0x278>
c0de69a2:	4680      	mov	r8, r0
                                                   PIC(infoContents[startIndex + nbInfosInPage]),
c0de69a4:	980b      	ldr	r0, [sp, #44]	@ 0x2c
            += LIST_ITEM_MIN_TEXT_HEIGHT + 2 * LIST_ITEM_PRE_HEADING + LIST_ITEM_HEADING_SUB_TEXT;
c0de69a6:	f101 0468 	add.w	r4, r1, #104	@ 0x68
                                                   PIC(infoContents[startIndex + nbInfosInPage]),
c0de69aa:	f850 0025 	ldr.w	r0, [r0, r5, lsl #2]
c0de69ae:	f003 f801 	bl	c0de99b4 <pic>
c0de69b2:	4601      	mov	r1, r0
        currentHeight += nbgl_getTextHeightInWidth(SMALL_REGULAR_FONT,
c0de69b4:	200b      	movs	r0, #11
c0de69b6:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de69ba:	2301      	movs	r3, #1
c0de69bc:	f002 f8ec 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
c0de69c0:	b2a1      	uxth	r1, r4
c0de69c2:	4401      	add	r1, r0
        if (currentHeight >= (INFOS_AREA_HEIGHT - navHeight)) {
c0de69c4:	b288      	uxth	r0, r1
c0de69c6:	42b0      	cmp	r0, r6
c0de69c8:	f105 0501 	add.w	r5, r5, #1
c0de69cc:	d3e6      	bcc.n	c0de699c <getNbPagesForContent+0x1a4>
c0de69ce:	f8dd c020 	ldr.w	ip, [sp, #32]
c0de69d2:	9c03      	ldr	r4, [sp, #12]
            if (!withNav && (previousHeight >= (INFOS_AREA_HEIGHT - SIMPLE_FOOTER_HEIGHT))) {
c0de69d4:	1e68      	subs	r0, r5, #1
c0de69d6:	e03d      	b.n	c0de6a54 <getNbPagesForContent+0x25c>
            nbElementsInPage = getNbTagValuesInPage(nbElements,
c0de69d8:	9806      	ldr	r0, [sp, #24]
c0de69da:	9000      	str	r0, [sp, #0]
c0de69dc:	9804      	ldr	r0, [sp, #16]
c0de69de:	9001      	str	r0, [sp, #4]
c0de69e0:	9907      	ldr	r1, [sp, #28]
c0de69e2:	fa5f f08a 	uxtb.w	r0, sl
c0de69e6:	462a      	mov	r2, r5
c0de69e8:	4643      	mov	r3, r8
c0de69ea:	f10d 0637 	add.w	r6, sp, #55	@ 0x37
c0de69ee:	9602      	str	r6, [sp, #8]
c0de69f0:	f7ff fbf6 	bl	c0de61e0 <getNbTagValuesInPage>
c0de69f4:	f8dd c020 	ldr.w	ip, [sp, #32]
c0de69f8:	f04f 0e00 	mov.w	lr, #0
c0de69fc:	4605      	mov	r5, r0
c0de69fe:	e747      	b.n	c0de6890 <getNbPagesForContent+0x98>
c0de6a00:	f44f 71fc 	mov.w	r1, #504	@ 0x1f8
c0de6a04:	2000      	movs	r0, #0
c0de6a06:	235c      	movs	r3, #92	@ 0x5c
c0de6a08:	225c      	movs	r2, #92	@ 0x5c
c0de6a0a:	2c00      	cmp	r4, #0
c0de6a0c:	bf18      	it	ne
c0de6a0e:	f44f 71cc 	movne.w	r1, #408	@ 0x198
c0de6a12:	bf00      	nop
        nbChoicesInPage++;
c0de6a14:	3001      	adds	r0, #1
c0de6a16:	b2c6      	uxtb	r6, r0
    while (nbChoicesInPage < nbChoices) {
c0de6a18:	fa5f f58a 	uxtb.w	r5, sl
c0de6a1c:	42ae      	cmp	r6, r5
c0de6a1e:	d207      	bcs.n	c0de6a30 <getNbPagesForContent+0x238>
        currentHeight += LIST_ITEM_MIN_TEXT_HEIGHT + 2 * LIST_ITEM_PRE_HEADING;
c0de6a20:	b292      	uxth	r2, r2
c0de6a22:	325c      	adds	r2, #92	@ 0x5c
c0de6a24:	461e      	mov	r6, r3
        if (currentHeight >= (INFOS_AREA_HEIGHT - navHeight)) {
c0de6a26:	b293      	uxth	r3, r2
c0de6a28:	428b      	cmp	r3, r1
c0de6a2a:	d3f3      	bcc.n	c0de6a14 <getNbPagesForContent+0x21c>
c0de6a2c:	08f1      	lsrs	r1, r6, #3
c0de6a2e:	e004      	b.n	c0de6a3a <getNbPagesForContent+0x242>
c0de6a30:	4655      	mov	r5, sl
c0de6a32:	e72d      	b.n	c0de6890 <getNbPagesForContent+0x98>
c0de6a34:	255c      	movs	r5, #92	@ 0x5c
c0de6a36:	4650      	mov	r0, sl
c0de6a38:	08e9      	lsrs	r1, r5, #3
c0de6a3a:	2932      	cmp	r1, #50	@ 0x32
c0de6a3c:	f04f 0100 	mov.w	r1, #0
c0de6a40:	bf88      	it	hi
c0de6a42:	2101      	movhi	r1, #1
c0de6a44:	43a1      	bics	r1, r4
c0de6a46:	1a45      	subs	r5, r0, r1
c0de6a48:	e722      	b.n	c0de6890 <getNbPagesForContent+0x98>
c0de6a4a:	f8dd c020 	ldr.w	ip, [sp, #32]
c0de6a4e:	2000      	movs	r0, #0
c0de6a50:	f04f 0800 	mov.w	r8, #0
c0de6a54:	f04f 0e00 	mov.w	lr, #0
c0de6a58:	ea4f 01d8 	mov.w	r1, r8, lsr #3
c0de6a5c:	2932      	cmp	r1, #50	@ 0x32
c0de6a5e:	f04f 0100 	mov.w	r1, #0
c0de6a62:	bf88      	it	hi
c0de6a64:	2101      	movhi	r1, #1
            if (!withNav && (previousHeight >= (INFOS_AREA_HEIGHT - SIMPLE_FOOTER_HEIGHT))) {
c0de6a66:	43a1      	bics	r1, r4
c0de6a68:	f8dd 8014 	ldr.w	r8, [sp, #20]
c0de6a6c:	1a45      	subs	r5, r0, r1
c0de6a6e:	e70f      	b.n	c0de6890 <getNbPagesForContent+0x98>
c0de6a70:	f8dd 8014 	ldr.w	r8, [sp, #20]
c0de6a74:	f8dd c020 	ldr.w	ip, [sp, #32]
c0de6a78:	f04f 0e00 	mov.w	lr, #0
c0de6a7c:	e708      	b.n	c0de6890 <getNbPagesForContent+0x98>
c0de6a7e:	2700      	movs	r7, #0
    return nbPages;
c0de6a80:	b2f8      	uxtb	r0, r7
c0de6a82:	b00e      	add	sp, #56	@ 0x38
c0de6a84:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de6a88 <displayGenericContextPage>:
{
c0de6a88:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de6a8c:	b0a0      	sub	sp, #128	@ 0x80
    if (navType == STREAMING_NAV) {
c0de6a8e:	f240 46ec 	movw	r6, #1260	@ 0x4ec
c0de6a92:	f2c0 0600 	movt	r6, #0
c0de6a96:	f819 2006 	ldrb.w	r2, [r9, r6]
c0de6a9a:	460d      	mov	r5, r1
c0de6a9c:	2a03      	cmp	r2, #3
c0de6a9e:	4682      	mov	sl, r0
c0de6aa0:	d112      	bne.n	c0de6ac8 <displayGenericContextPage+0x40>
        else if (pageIdx >= bundleNavContext.reviewStreaming.stepPageNb) {
c0de6aa2:	f240 6028 	movw	r0, #1576	@ 0x628
c0de6aa6:	f2c0 0000 	movt	r0, #0
        if (pageIdx == LAST_PAGE_FOR_REVIEW) {
c0de6aaa:	f1ba 0fff 	cmp.w	sl, #255	@ 0xff
c0de6aae:	d042      	beq.n	c0de6b36 <displayGenericContextPage+0xae>
        else if (pageIdx >= bundleNavContext.reviewStreaming.stepPageNb) {
c0de6ab0:	eb09 0100 	add.w	r1, r9, r0
c0de6ab4:	7c09      	ldrb	r1, [r1, #16]
c0de6ab6:	4551      	cmp	r1, sl
c0de6ab8:	d811      	bhi.n	c0de6ade <displayGenericContextPage+0x56>
        bundleNavContext.reviewStreaming.choiceCallback(true);
c0de6aba:	4448      	add	r0, r9
c0de6abc:	6841      	ldr	r1, [r0, #4]
c0de6abe:	2001      	movs	r0, #1
c0de6ac0:	4788      	blx	r1
}
c0de6ac2:	b020      	add	sp, #128	@ 0x80
c0de6ac4:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        if (pageIdx == LAST_PAGE_FOR_REVIEW) {
c0de6ac8:	f1ba 0fff 	cmp.w	sl, #255	@ 0xff
c0de6acc:	d107      	bne.n	c0de6ade <displayGenericContextPage+0x56>
            pageIdx = navInfo.nbPages - 1;
c0de6ace:	f240 6068 	movw	r0, #1640	@ 0x668
c0de6ad2:	f2c0 0000 	movt	r0, #0
c0de6ad6:	4448      	add	r0, r9
c0de6ad8:	7840      	ldrb	r0, [r0, #1]
c0de6ada:	f1a0 0a01 	sub.w	sl, r0, #1
    if (navInfo.activePage == pageIdx) {
c0de6ade:	f240 6468 	movw	r4, #1640	@ 0x668
c0de6ae2:	f2c0 0400 	movt	r4, #0
c0de6ae6:	f819 8004 	ldrb.w	r8, [r9, r4]
c0de6aea:	fa5f f78a 	uxtb.w	r7, sl
c0de6aee:	4547      	cmp	r7, r8
c0de6af0:	d02d      	beq.n	c0de6b4e <displayGenericContextPage+0xc6>
    else if (navInfo.activePage < pageIdx) {
c0de6af2:	d928      	bls.n	c0de6b46 <displayGenericContextPage+0xbe>
c0de6af4:	9500      	str	r5, [sp, #0]
c0de6af6:	ac12      	add	r4, sp, #72	@ 0x48
c0de6af8:	f10d 0647 	add.w	r6, sp, #71	@ 0x47
c0de6afc:	f10d 0546 	add.w	r5, sp, #70	@ 0x46
c0de6b00:	f108 0801 	add.w	r8, r8, #1
            p_content = genericContextComputeNextPageParams(i, &content, &nbElementsInPage, &flag);
c0de6b04:	fa5f f088 	uxtb.w	r0, r8
c0de6b08:	4621      	mov	r1, r4
c0de6b0a:	4632      	mov	r2, r6
c0de6b0c:	462b      	mov	r3, r5
c0de6b0e:	f000 fe9f 	bl	c0de7850 <genericContextComputeNextPageParams>
        for (int i = navInfo.activePage + 1; i <= pageIdx; i++) {
c0de6b12:	4547      	cmp	r7, r8
c0de6b14:	d1f4      	bne.n	c0de6b00 <displayGenericContextPage+0x78>
c0de6b16:	9d00      	ldr	r5, [sp, #0]
c0de6b18:	f240 6468 	movw	r4, #1640	@ 0x668
c0de6b1c:	f240 46ec 	movw	r6, #1260	@ 0x4ec
c0de6b20:	4683      	mov	fp, r0
c0de6b22:	f2c0 0400 	movt	r4, #0
c0de6b26:	f2c0 0600 	movt	r6, #0
    if (p_content == NULL) {
c0de6b2a:	f1bb 0f00 	cmp.w	fp, #0
c0de6b2e:	d11a      	bne.n	c0de6b66 <displayGenericContextPage+0xde>
}
c0de6b30:	b020      	add	sp, #128	@ 0x80
c0de6b32:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            if (bundleNavContext.reviewStreaming.skipCallback != NULL) {
c0de6b36:	4448      	add	r0, r9
c0de6b38:	6880      	ldr	r0, [r0, #8]
c0de6b3a:	2800      	cmp	r0, #0
c0de6b3c:	d0f8      	beq.n	c0de6b30 <displayGenericContextPage+0xa8>
                bundleNavContext.reviewStreaming.skipCallback();
c0de6b3e:	4780      	blx	r0
}
c0de6b40:	b020      	add	sp, #128	@ 0x80
c0de6b42:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        if (pageIdx - navInfo.activePage > 1) {
c0de6b46:	eba7 0008 	sub.w	r0, r7, r8
c0de6b4a:	2801      	cmp	r0, #1
c0de6b4c:	dcf0      	bgt.n	c0de6b30 <displayGenericContextPage+0xa8>
c0de6b4e:	a912      	add	r1, sp, #72	@ 0x48
c0de6b50:	f10d 0247 	add.w	r2, sp, #71	@ 0x47
c0de6b54:	f10d 0346 	add.w	r3, sp, #70	@ 0x46
c0de6b58:	4638      	mov	r0, r7
c0de6b5a:	f000 fe79 	bl	c0de7850 <genericContextComputeNextPageParams>
c0de6b5e:	4683      	mov	fp, r0
    if (p_content == NULL) {
c0de6b60:	f1bb 0f00 	cmp.w	fp, #0
c0de6b64:	d0e4      	beq.n	c0de6b30 <displayGenericContextPage+0xa8>
    if ((navType != STREAMING_NAV)
c0de6b66:	f819 0006 	ldrb.w	r0, [r9, r6]
c0de6b6a:	f240 6828 	movw	r8, #1576	@ 0x628
        && (bundleNavContext.review.operationType & SKIPPABLE_OPERATION)) {
c0de6b6e:	2803      	cmp	r0, #3
c0de6b70:	f2c0 0800 	movt	r8, #0
c0de6b74:	d01d      	beq.n	c0de6bb2 <displayGenericContextPage+0x12a>
    if ((navType != STREAMING_NAV)
c0de6b76:	f819 0008 	ldrb.w	r0, [r9, r8]
c0de6b7a:	06c0      	lsls	r0, r0, #27
c0de6b7c:	d519      	bpl.n	c0de6bb2 <displayGenericContextPage+0x12a>
        if ((pageIdx > 0) && (pageIdx < (navInfo.nbPages - 1))) {
c0de6b7e:	ea5f 600a 	movs.w	r0, sl, lsl #24
c0de6b82:	d012      	beq.n	c0de6baa <displayGenericContextPage+0x122>
c0de6b84:	eb09 0004 	add.w	r0, r9, r4
c0de6b88:	7840      	ldrb	r0, [r0, #1]
c0de6b8a:	3801      	subs	r0, #1
c0de6b8c:	42b8      	cmp	r0, r7
c0de6b8e:	dd0c      	ble.n	c0de6baa <displayGenericContextPage+0x122>
            navInfo.progressIndicator = false;
c0de6b90:	eb09 0004 	add.w	r0, r9, r4
c0de6b94:	2100      	movs	r1, #0
c0de6b96:	7101      	strb	r1, [r0, #4]
            navInfo.skipText          = "Skip";
c0de6b98:	f244 712d 	movw	r1, #18221	@ 0x472d
c0de6b9c:	f2c0 0100 	movt	r1, #0
c0de6ba0:	4479      	add	r1, pc
c0de6ba2:	6081      	str	r1, [r0, #8]
c0de6ba4:	2105      	movs	r1, #5
            navInfo.skipToken         = SKIP_TOKEN;
c0de6ba6:	7301      	strb	r1, [r0, #12]
c0de6ba8:	e003      	b.n	c0de6bb2 <displayGenericContextPage+0x12a>
            navInfo.skipText = NULL;
c0de6baa:	eb09 0004 	add.w	r0, r9, r4
c0de6bae:	2100      	movs	r1, #0
c0de6bb0:	6081      	str	r1, [r0, #8]
c0de6bb2:	af01      	add	r7, sp, #4
    nbgl_pageContent_t pageContent = {0};
c0de6bb4:	4638      	mov	r0, r7
c0de6bb6:	2140      	movs	r1, #64	@ 0x40
c0de6bb8:	f003 f900 	bl	c0de9dbc <__aeabi_memclr>
    pageContent->title            = pageTitle;
c0de6bbc:	f240 41e8 	movw	r1, #1256	@ 0x4e8
c0de6bc0:	f2c0 0100 	movt	r1, #0
c0de6bc4:	f859 1001 	ldr.w	r1, [r9, r1]
    uint8_t nextElementIdx = genericContext.currentElementIdx;
c0de6bc8:	f240 4af0 	movw	sl, #1264	@ 0x4f0
    pageContent->title            = pageTitle;
c0de6bcc:	9101      	str	r1, [sp, #4]
c0de6bce:	f44f 7100 	mov.w	r1, #512	@ 0x200
    pageContent->isTouchableTitle = false;
c0de6bd2:	f8ad 1008 	strh.w	r1, [sp, #8]
c0de6bd6:	2109      	movs	r1, #9
    uint8_t nextElementIdx = genericContext.currentElementIdx;
c0de6bd8:	f2c0 0a00 	movt	sl, #0
    pageContent->tuneId           = TUNE_TAP_CASUAL;
c0de6bdc:	f88d 100a 	strb.w	r1, [sp, #10]
    uint8_t nextElementIdx = genericContext.currentElementIdx;
c0de6be0:	eb09 020a 	add.w	r2, r9, sl
    pageContent->type = p_content->type;
c0de6be4:	f89b 1000 	ldrb.w	r1, [fp]
    if (!genericContextPreparePageContent(p_content, nbElementsInPage, flag, &pageContent)) {
c0de6be8:	f89d 4047 	ldrb.w	r4, [sp, #71]	@ 0x47
c0de6bec:	f89d 0046 	ldrb.w	r0, [sp, #70]	@ 0x46
    uint8_t nextElementIdx = genericContext.currentElementIdx;
c0de6bf0:	7c96      	ldrb	r6, [r2, #18]
    switch (pageContent->type) {
c0de6bf2:	2905      	cmp	r1, #5
    pageContent->type = p_content->type;
c0de6bf4:	f88d 1010 	strb.w	r1, [sp, #16]
    switch (pageContent->type) {
c0de6bf8:	dc1b      	bgt.n	c0de6c32 <displayGenericContextPage+0x1aa>
c0de6bfa:	2901      	cmp	r1, #1
c0de6bfc:	dd36      	ble.n	c0de6c6c <displayGenericContextPage+0x1e4>
c0de6bfe:	2902      	cmp	r1, #2
c0de6c00:	d056      	beq.n	c0de6cb0 <displayGenericContextPage+0x228>
c0de6c02:	2903      	cmp	r1, #3
c0de6c04:	d054      	beq.n	c0de6cb0 <displayGenericContextPage+0x228>
c0de6c06:	2904      	cmp	r1, #4
c0de6c08:	d192      	bne.n	c0de6b30 <displayGenericContextPage+0xa8>
            genericContext.currentPairs    = p_content->content.tagValueList.pairs;
c0de6c0a:	f8db 1004 	ldr.w	r1, [fp, #4]
c0de6c0e:	eb09 020a 	add.w	r2, r9, sl
c0de6c12:	6251      	str	r1, [r2, #36]	@ 0x24
            genericContext.currentCallback = p_content->content.tagValueList.callback;
c0de6c14:	f8db 1008 	ldr.w	r1, [fp, #8]
            nbgl_contentTagValueList_t *p_tagValueList = &pageContent->tagValueList;
c0de6c18:	3710      	adds	r7, #16
            if (flag) {
c0de6c1a:	2800      	cmp	r0, #0
            genericContext.currentCallback = p_content->content.tagValueList.callback;
c0de6c1c:	6291      	str	r1, [r2, #40]	@ 0x28
c0de6c1e:	f000 8107 	beq.w	c0de6e30 <displayGenericContextPage+0x3a8>
                if (p_content->content.tagValueList.pairs != NULL) {
c0de6c22:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de6c26:	2800      	cmp	r0, #0
c0de6c28:	f000 80c9 	beq.w	c0de6dbe <displayGenericContextPage+0x336>
                    pair = PIC(&p_content->content.tagValueList.pairs[nextElementIdx]);
c0de6c2c:	eb00 1006 	add.w	r0, r0, r6, lsl #4
c0de6c30:	e0c9      	b.n	c0de6dc6 <displayGenericContextPage+0x33e>
    switch (pageContent->type) {
c0de6c32:	2907      	cmp	r1, #7
c0de6c34:	dd2b      	ble.n	c0de6c8e <displayGenericContextPage+0x206>
c0de6c36:	2908      	cmp	r1, #8
c0de6c38:	d047      	beq.n	c0de6cca <displayGenericContextPage+0x242>
c0de6c3a:	2909      	cmp	r1, #9
c0de6c3c:	d056      	beq.n	c0de6cec <displayGenericContextPage+0x264>
c0de6c3e:	290a      	cmp	r1, #10
c0de6c40:	f47f af76 	bne.w	c0de6b30 <displayGenericContextPage+0xa8>
            pageContent->barsList.nbBars = nbElementsInPage;
c0de6c44:	f88d 401c 	strb.w	r4, [sp, #28]
                = PIC(&p_content->content.barsList.barTexts[nextElementIdx]);
c0de6c48:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de6c4c:	eb00 0086 	add.w	r0, r0, r6, lsl #2
c0de6c50:	f002 feb0 	bl	c0de99b4 <pic>
c0de6c54:	9005      	str	r0, [sp, #20]
            pageContent->barsList.tokens = PIC(&p_content->content.barsList.tokens[nextElementIdx]);
c0de6c56:	f8db 0008 	ldr.w	r0, [fp, #8]
c0de6c5a:	4430      	add	r0, r6
c0de6c5c:	f002 feaa 	bl	c0de99b4 <pic>
c0de6c60:	9006      	str	r0, [sp, #24]
            pageContent->barsList.tuneId = p_content->content.barsList.tuneId;
c0de6c62:	f89b 000d 	ldrb.w	r0, [fp, #13]
c0de6c66:	f88d 001d 	strb.w	r0, [sp, #29]
c0de6c6a:	e123      	b.n	c0de6eb4 <displayGenericContextPage+0x42c>
    switch (pageContent->type) {
c0de6c6c:	2900      	cmp	r1, #0
c0de6c6e:	d056      	beq.n	c0de6d1e <displayGenericContextPage+0x296>
c0de6c70:	2901      	cmp	r1, #1
c0de6c72:	f47f af5d 	bne.w	c0de6b30 <displayGenericContextPage+0xa8>
            memcpy(&pageContent->extendedCenter,
c0de6c76:	f10b 0104 	add.w	r1, fp, #4
c0de6c7a:	f107 0010 	add.w	r0, r7, #16
c0de6c7e:	46ac      	mov	ip, r5
c0de6c80:	c9fc      	ldmia	r1!, {r2, r3, r4, r5, r6, r7}
c0de6c82:	c0fc      	stmia	r0!, {r2, r3, r4, r5, r6, r7}
c0de6c84:	e891 00fc 	ldmia.w	r1, {r2, r3, r4, r5, r6, r7}
c0de6c88:	c0fc      	stmia	r0!, {r2, r3, r4, r5, r6, r7}
c0de6c8a:	4665      	mov	r5, ip
c0de6c8c:	e112      	b.n	c0de6eb4 <displayGenericContextPage+0x42c>
    switch (pageContent->type) {
c0de6c8e:	2906      	cmp	r1, #6
c0de6c90:	d04f      	beq.n	c0de6d32 <displayGenericContextPage+0x2aa>
c0de6c92:	2907      	cmp	r1, #7
c0de6c94:	f47f af4c 	bne.w	c0de6b30 <displayGenericContextPage+0xa8>
            pageContent->switchesList.nbSwitches = nbElementsInPage;
c0de6c98:	f88d 4018 	strb.w	r4, [sp, #24]
                = PIC(&p_content->content.switchesList.switches[nextElementIdx]);
c0de6c9c:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de6ca0:	eb06 0146 	add.w	r1, r6, r6, lsl #1
c0de6ca4:	eb00 0081 	add.w	r0, r0, r1, lsl #2
c0de6ca8:	f002 fe84 	bl	c0de99b4 <pic>
c0de6cac:	9005      	str	r0, [sp, #20]
c0de6cae:	e101      	b.n	c0de6eb4 <displayGenericContextPage+0x42c>
c0de6cb0:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de6cb4:	f8db 1008 	ldr.w	r1, [fp, #8]
c0de6cb8:	f8db 2010 	ldr.w	r2, [fp, #16]
c0de6cbc:	f8db 300c 	ldr.w	r3, [fp, #12]
c0de6cc0:	9208      	str	r2, [sp, #32]
c0de6cc2:	9307      	str	r3, [sp, #28]
c0de6cc4:	9106      	str	r1, [sp, #24]
c0de6cc6:	9005      	str	r0, [sp, #20]
c0de6cc8:	e0f4      	b.n	c0de6eb4 <displayGenericContextPage+0x42c>
            pageContent->infosList.nbInfos = nbElementsInPage;
c0de6cca:	f88d 4020 	strb.w	r4, [sp, #32]
                = PIC(&p_content->content.infosList.infoTypes[nextElementIdx]);
c0de6cce:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de6cd2:	eb00 0086 	add.w	r0, r0, r6, lsl #2
c0de6cd6:	f002 fe6d 	bl	c0de99b4 <pic>
c0de6cda:	9005      	str	r0, [sp, #20]
                = PIC(&p_content->content.infosList.infoContents[nextElementIdx]);
c0de6cdc:	f8db 0008 	ldr.w	r0, [fp, #8]
c0de6ce0:	eb00 0086 	add.w	r0, r0, r6, lsl #2
c0de6ce4:	f002 fe66 	bl	c0de99b4 <pic>
c0de6ce8:	9006      	str	r0, [sp, #24]
c0de6cea:	e0e3      	b.n	c0de6eb4 <displayGenericContextPage+0x42c>
            memcpy(&pageContent->choicesList,
c0de6cec:	f10b 0204 	add.w	r2, fp, #4
c0de6cf0:	ca07      	ldmia	r2, {r0, r1, r2}
c0de6cf2:	ab05      	add	r3, sp, #20
c0de6cf4:	c307      	stmia	r3!, {r0, r1, r2}
            pageContent->choicesList.nbChoices = nbElementsInPage;
c0de6cf6:	f88d 4019 	strb.w	r4, [sp, #25]
                = PIC(&p_content->content.choicesList.names[nextElementIdx]);
c0de6cfa:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de6cfe:	eb00 0086 	add.w	r0, r0, r6, lsl #2
c0de6d02:	f002 fe57 	bl	c0de99b4 <pic>
c0de6d06:	9005      	str	r0, [sp, #20]
            if ((p_content->content.choicesList.initChoice >= nextElementIdx)
c0de6d08:	f89b 000a 	ldrb.w	r0, [fp, #10]
                && (p_content->content.choicesList.initChoice
c0de6d0c:	42b0      	cmp	r0, r6
c0de6d0e:	d329      	bcc.n	c0de6d64 <displayGenericContextPage+0x2dc>
c0de6d10:	1931      	adds	r1, r6, r4
c0de6d12:	4281      	cmp	r1, r0
c0de6d14:	d926      	bls.n	c0de6d64 <displayGenericContextPage+0x2dc>
                    = p_content->content.choicesList.initChoice - nextElementIdx;
c0de6d16:	1b80      	subs	r0, r0, r6
c0de6d18:	f88d 001a 	strb.w	r0, [sp, #26]
c0de6d1c:	e0ca      	b.n	c0de6eb4 <displayGenericContextPage+0x42c>
            memcpy(&pageContent->centeredInfo,
c0de6d1e:	f10b 0104 	add.w	r1, fp, #4
c0de6d22:	f107 0010 	add.w	r0, r7, #16
c0de6d26:	462c      	mov	r4, r5
c0de6d28:	e891 00ec 	ldmia.w	r1, {r2, r3, r5, r6, r7}
c0de6d2c:	c0ec      	stmia	r0!, {r2, r3, r5, r6, r7}
c0de6d2e:	4625      	mov	r5, r4
c0de6d30:	e0c0      	b.n	c0de6eb4 <displayGenericContextPage+0x42c>
                == p_content->content.tagValueConfirm.tagValueList.nbPairs) {
c0de6d32:	f89b 000c 	ldrb.w	r0, [fp, #12]
            if ((nextElementIdx + nbElementsInPage)
c0de6d36:	1931      	adds	r1, r6, r4
c0de6d38:	4281      	cmp	r1, r0
                == p_content->content.tagValueConfirm.tagValueList.nbPairs) {
c0de6d3a:	f10b 0c04 	add.w	ip, fp, #4
            if ((nextElementIdx + nbElementsInPage)
c0de6d3e:	d114      	bne.n	c0de6d6a <displayGenericContextPage+0x2e2>
                memcpy(&pageContent->tagValueConfirm,
c0de6d40:	46e6      	mov	lr, ip
c0de6d42:	9500      	str	r5, [sp, #0]
c0de6d44:	f107 0a10 	add.w	sl, r7, #16
c0de6d48:	e8be 00ab 	ldmia.w	lr!, {r0, r1, r3, r5, r7}
c0de6d4c:	4652      	mov	r2, sl
c0de6d4e:	c2ab      	stmia	r2!, {r0, r1, r3, r5, r7}
c0de6d50:	e89e 01ab 	ldmia.w	lr, {r0, r1, r3, r5, r7, r8}
c0de6d54:	e882 01ab 	stmia.w	r2, {r0, r1, r3, r5, r7, r8}
c0de6d58:	f240 6828 	movw	r8, #1576	@ 0x628
c0de6d5c:	9d00      	ldr	r5, [sp, #0]
c0de6d5e:	f2c0 0800 	movt	r8, #0
c0de6d62:	e007      	b.n	c0de6d74 <displayGenericContextPage+0x2ec>
                pageContent->choicesList.initChoice = nbElementsInPage;
c0de6d64:	f88d 401a 	strb.w	r4, [sp, #26]
c0de6d68:	e0a4      	b.n	c0de6eb4 <displayGenericContextPage+0x42c>
c0de6d6a:	2004      	movs	r0, #4
                p_tagValueList    = &pageContent->tagValueList;
c0de6d6c:	f107 0a10 	add.w	sl, r7, #16
                pageContent->type = TAG_VALUE_LIST;
c0de6d70:	f88d 0010 	strb.w	r0, [sp, #16]
            p_tagValueList->nbPairs = nbElementsInPage;
c0de6d74:	f88d 401c 	strb.w	r4, [sp, #28]
                = PIC(&p_content->content.tagValueConfirm.tagValueList.pairs[nextElementIdx]);
c0de6d78:	f8dc 0000 	ldr.w	r0, [ip]
c0de6d7c:	eb00 1006 	add.w	r0, r0, r6, lsl #4
c0de6d80:	f002 fe18 	bl	c0de99b4 <pic>
c0de6d84:	f8ca 0000 	str.w	r0, [sl]
            for (uint8_t i = 0; i < nbElementsInPage; i++) {
c0de6d88:	b16c      	cbz	r4, c0de6da6 <displayGenericContextPage+0x31e>
c0de6d8a:	f8da 0000 	ldr.w	r0, [sl]
c0de6d8e:	300c      	adds	r0, #12
                if (p_tagValueList->pairs[i].aliasValue) {
c0de6d90:	7801      	ldrb	r1, [r0, #0]
c0de6d92:	0749      	lsls	r1, r1, #29
c0de6d94:	d404      	bmi.n	c0de6da0 <displayGenericContextPage+0x318>
            for (uint8_t i = 0; i < nbElementsInPage; i++) {
c0de6d96:	3c01      	subs	r4, #1
c0de6d98:	f100 0010 	add.w	r0, r0, #16
c0de6d9c:	d1f8      	bne.n	c0de6d90 <displayGenericContextPage+0x308>
c0de6d9e:	e002      	b.n	c0de6da6 <displayGenericContextPage+0x31e>
c0de6da0:	200d      	movs	r0, #13
                    p_tagValueList->token = VALUE_ALIAS_TOKEN;
c0de6da2:	f88d 0020 	strb.w	r0, [sp, #32]
            genericContext.currentPairs    = p_tagValueList->pairs;
c0de6da6:	f8da 0000 	ldr.w	r0, [sl]
c0de6daa:	f240 4af0 	movw	sl, #1264	@ 0x4f0
c0de6dae:	f2c0 0a00 	movt	sl, #0
            genericContext.currentCallback = p_tagValueList->callback;
c0de6db2:	9a06      	ldr	r2, [sp, #24]
            genericContext.currentPairs    = p_tagValueList->pairs;
c0de6db4:	eb09 010a 	add.w	r1, r9, sl
c0de6db8:	e9c1 0209 	strd	r0, r2, [r1, #36]	@ 0x24
c0de6dbc:	e07a      	b.n	c0de6eb4 <displayGenericContextPage+0x42c>
                    pair = PIC(p_content->content.tagValueList.callback(nextElementIdx));
c0de6dbe:	f8db 1008 	ldr.w	r1, [fp, #8]
c0de6dc2:	4630      	mov	r0, r6
c0de6dc4:	4788      	blx	r1
c0de6dc6:	f002 fdf5 	bl	c0de99b4 <pic>
                if (pair->centeredInfo) {
c0de6dca:	7b01      	ldrb	r1, [r0, #12]
c0de6dcc:	0789      	lsls	r1, r1, #30
c0de6dce:	d418      	bmi.n	c0de6e02 <displayGenericContextPage+0x37a>
c0de6dd0:	2105      	movs	r1, #5
                    pageContent->type                               = TAG_VALUE_DETAILS;
c0de6dd2:	f88d 1010 	strb.w	r1, [sp, #16]
                    pageContent->tagValueDetails.detailsButtonText  = "More";
c0de6dd6:	f244 11f8 	movw	r1, #16888	@ 0x41f8
c0de6dda:	f2c0 0100 	movt	r1, #0
c0de6dde:	4479      	add	r1, pc
c0de6de0:	910b      	str	r1, [sp, #44]	@ 0x2c
c0de6de2:	2100      	movs	r1, #0
                    pageContent->tagValueDetails.detailsButtonIcon  = NULL;
c0de6de4:	910a      	str	r1, [sp, #40]	@ 0x28
c0de6de6:	210a      	movs	r1, #10
                    pageContent->tagValueDetails.detailsButtonToken = DETAILS_BUTTON_TOKEN;
c0de6de8:	f88d 1030 	strb.w	r1, [sp, #48]	@ 0x30
                    genericContext.detailsItem     = pair->item;
c0de6dec:	e9d0 2000 	ldrd	r2, r0, [r0]
c0de6df0:	eb09 010a 	add.w	r1, r9, sl
c0de6df4:	e9c1 2006 	strd	r2, r0, [r1, #24]
                    genericContext.detailsWrapping = p_content->content.tagValueList.wrapping;
c0de6df8:	f89b 0012 	ldrb.w	r0, [fp, #18]
c0de6dfc:	f881 0020 	strb.w	r0, [r1, #32]
c0de6e00:	e016      	b.n	c0de6e30 <displayGenericContextPage+0x3a8>
c0de6e02:	2101      	movs	r1, #1
                    pageContent->type = EXTENDED_CENTER;
c0de6e04:	f88d 1010 	strb.w	r1, [sp, #16]
                                           pair->valueIcon,
c0de6e08:	6882      	ldr	r2, [r0, #8]
                                           pair->item,
c0de6e0a:	e9d0 1000 	ldrd	r1, r0, [r0]
    contentCenter->icon        = icon;
c0de6e0e:	9206      	str	r2, [sp, #24]
    contentCenter->title       = reviewTitle;
c0de6e10:	9109      	str	r1, [sp, #36]	@ 0x24
    contentCenter->description = reviewSubTitle;
c0de6e12:	900b      	str	r0, [sp, #44]	@ 0x2c
    contentCenter->subText     = "Swipe to review";
c0de6e14:	f244 40e8 	movw	r0, #17640	@ 0x44e8
c0de6e18:	f2c0 0000 	movt	r0, #0
c0de6e1c:	4478      	add	r0, pc
c0de6e1e:	2700      	movs	r7, #0
c0de6e20:	900c      	str	r0, [sp, #48]	@ 0x30
    contentCenter->smallTitle  = NULL;
c0de6e22:	970a      	str	r7, [sp, #40]	@ 0x28
    contentCenter->iconHug     = 0;
c0de6e24:	f8ad 7034 	strh.w	r7, [sp, #52]	@ 0x34
    contentCenter->padding     = false;
c0de6e28:	f88d 7036 	strb.w	r7, [sp, #54]	@ 0x36
    contentCenter->illustrType = ICON_ILLUSTRATION;
c0de6e2c:	f88d 7014 	strb.w	r7, [sp, #20]
            if (p_tagValueList != NULL) {
c0de6e30:	2f00      	cmp	r7, #0
c0de6e32:	d03f      	beq.n	c0de6eb4 <displayGenericContextPage+0x42c>
                p_tagValueList->nbPairs = nbElementsInPage;
c0de6e34:	723c      	strb	r4, [r7, #8]
                p_tagValueList->token   = p_content->content.tagValueList.token;
c0de6e36:	f89b 0010 	ldrb.w	r0, [fp, #16]
c0de6e3a:	46c2      	mov	sl, r8
c0de6e3c:	7338      	strb	r0, [r7, #12]
                if (p_content->content.tagValueList.pairs != NULL) {
c0de6e3e:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de6e42:	46a8      	mov	r8, r5
c0de6e44:	b178      	cbz	r0, c0de6e66 <displayGenericContextPage+0x3de>
                        = PIC(&p_content->content.tagValueList.pairs[nextElementIdx]);
c0de6e46:	eb00 1006 	add.w	r0, r0, r6, lsl #4
c0de6e4a:	f002 fdb3 	bl	c0de99b4 <pic>
c0de6e4e:	6038      	str	r0, [r7, #0]
                    for (uint8_t i = 0; i < nbElementsInPage; i++) {
c0de6e50:	b314      	cbz	r4, c0de6e98 <displayGenericContextPage+0x410>
c0de6e52:	6838      	ldr	r0, [r7, #0]
c0de6e54:	300c      	adds	r0, #12
                        if (p_tagValueList->pairs[i].aliasValue) {
c0de6e56:	7801      	ldrb	r1, [r0, #0]
c0de6e58:	0749      	lsls	r1, r1, #29
c0de6e5a:	d41b      	bmi.n	c0de6e94 <displayGenericContextPage+0x40c>
                    for (uint8_t i = 0; i < nbElementsInPage; i++) {
c0de6e5c:	3c01      	subs	r4, #1
c0de6e5e:	f100 0010 	add.w	r0, r0, #16
c0de6e62:	d1f8      	bne.n	c0de6e56 <displayGenericContextPage+0x3ce>
c0de6e64:	e018      	b.n	c0de6e98 <displayGenericContextPage+0x410>
c0de6e66:	2000      	movs	r0, #0
                    p_tagValueList->pairs      = NULL;
c0de6e68:	6038      	str	r0, [r7, #0]
                    p_tagValueList->callback   = p_content->content.tagValueList.callback;
c0de6e6a:	f8db 0008 	ldr.w	r0, [fp, #8]
c0de6e6e:	6078      	str	r0, [r7, #4]
                    p_tagValueList->startIndex = nextElementIdx;
c0de6e70:	727e      	strb	r6, [r7, #9]
                    for (uint8_t i = 0; i < nbElementsInPage; i++) {
c0de6e72:	b18c      	cbz	r4, c0de6e98 <displayGenericContextPage+0x410>
c0de6e74:	2500      	movs	r5, #0
                            = PIC(p_content->content.tagValueList.callback(nextElementIdx + i));
c0de6e76:	f8db 1008 	ldr.w	r1, [fp, #8]
c0de6e7a:	19a8      	adds	r0, r5, r6
c0de6e7c:	b2c0      	uxtb	r0, r0
c0de6e7e:	4788      	blx	r1
c0de6e80:	f002 fd98 	bl	c0de99b4 <pic>
                        if (pair->aliasValue) {
c0de6e84:	7b00      	ldrb	r0, [r0, #12]
c0de6e86:	0740      	lsls	r0, r0, #29
c0de6e88:	d404      	bmi.n	c0de6e94 <displayGenericContextPage+0x40c>
c0de6e8a:	3501      	adds	r5, #1
                    for (uint8_t i = 0; i < nbElementsInPage; i++) {
c0de6e8c:	b2e8      	uxtb	r0, r5
c0de6e8e:	42a0      	cmp	r0, r4
c0de6e90:	d3f1      	bcc.n	c0de6e76 <displayGenericContextPage+0x3ee>
c0de6e92:	e001      	b.n	c0de6e98 <displayGenericContextPage+0x410>
c0de6e94:	200d      	movs	r0, #13
c0de6e96:	7338      	strb	r0, [r7, #12]
c0de6e98:	2000      	movs	r0, #0
                p_tagValueList->smallCaseForValue  = false;
c0de6e9a:	7378      	strb	r0, [r7, #13]
c0de6e9c:	f640 1001 	movw	r0, #2305	@ 0x901
                p_tagValueList->hideEndOfLastLine  = true;
c0de6ea0:	8178      	strh	r0, [r7, #10]
                p_tagValueList->wrapping           = p_content->content.tagValueList.wrapping;
c0de6ea2:	f89b 0012 	ldrb.w	r0, [fp, #18]
c0de6ea6:	4645      	mov	r5, r8
c0de6ea8:	46d0      	mov	r8, sl
c0de6eaa:	f240 4af0 	movw	sl, #1264	@ 0x4f0
c0de6eae:	73b8      	strb	r0, [r7, #14]
c0de6eb0:	f2c0 0a00 	movt	sl, #0
        = (navType == STREAMING_NAV)
c0de6eb4:	f240 40ec 	movw	r0, #1260	@ 0x4ec
c0de6eb8:	f2c0 0000 	movt	r0, #0
c0de6ebc:	f819 2000 	ldrb.w	r2, [r9, r0]
        = ((p_content->type == CENTERED_INFO) || (p_content->type == EXTENDED_CENTER))
c0de6ec0:	f89b 1000 	ldrb.w	r1, [fp]
        = (navType == STREAMING_NAV)
c0de6ec4:	f002 02fe 	and.w	r2, r2, #254	@ 0xfe
c0de6ec8:	f859 0008 	ldr.w	r0, [r9, r8]
c0de6ecc:	2a02      	cmp	r2, #2
c0de6ece:	f240 6268 	movw	r2, #1640	@ 0x668
c0de6ed2:	bf18      	it	ne
c0de6ed4:	2000      	movne	r0, #0
        && (operationType & (BLIND_OPERATION | RISKY_OPERATION | NO_THREAT_OPERATION))) {
c0de6ed6:	2902      	cmp	r1, #2
c0de6ed8:	f2c0 0200 	movt	r2, #0
c0de6edc:	d81d      	bhi.n	c0de6f1a <displayGenericContextPage+0x492>
c0de6ede:	f010 01e0 	ands.w	r1, r0, #224	@ 0xe0
c0de6ee2:	d01a      	beq.n	c0de6f1a <displayGenericContextPage+0x492>
            && !(reviewWithWarnCtx.warning->predefinedSet & (1 << BLIND_SIGNING_WARN))) {
c0de6ee4:	0601      	lsls	r1, r0, #24
c0de6ee6:	d50b      	bpl.n	c0de6f00 <displayGenericContextPage+0x478>
c0de6ee8:	eb09 010a 	add.w	r1, r9, sl
c0de6eec:	6f89      	ldr	r1, [r1, #120]	@ 0x78
        if ((operationType & NO_THREAT_OPERATION)
c0de6eee:	7809      	ldrb	r1, [r1, #0]
c0de6ef0:	06c9      	lsls	r1, r1, #27
c0de6ef2:	d405      	bmi.n	c0de6f00 <displayGenericContextPage+0x478>
c0de6ef4:	f643 311d 	movw	r1, #15133	@ 0x3b1d
c0de6ef8:	f2c0 0100 	movt	r1, #0
c0de6efc:	4479      	add	r1, pc
c0de6efe:	e004      	b.n	c0de6f0a <displayGenericContextPage+0x482>
c0de6f00:	f643 51af 	movw	r1, #15791	@ 0x3daf
c0de6f04:	f2c0 0100 	movt	r1, #0
c0de6f08:	4479      	add	r1, pc
            = (operationType & BLIND_OPERATION) ? BLIND_WARNING_TOKEN : WARNING_BUTTON_TOKEN;
c0de6f0a:	0680      	lsls	r0, r0, #26
c0de6f0c:	f04f 0010 	mov.w	r0, #16
c0de6f10:	9103      	str	r1, [sp, #12]
c0de6f12:	bf58      	it	pl
c0de6f14:	2011      	movpl	r0, #17
c0de6f16:	f88d 000b 	strb.w	r0, [sp, #11]
    pageContext = nbgl_pageDrawGenericContent(&pageCallback, &navInfo, &pageContent);
c0de6f1a:	f240 1081 	movw	r0, #385	@ 0x181
c0de6f1e:	f2c0 0000 	movt	r0, #0
c0de6f22:	eb09 0102 	add.w	r1, r9, r2
c0de6f26:	4478      	add	r0, pc
c0de6f28:	aa01      	add	r2, sp, #4
c0de6f2a:	f7ff f94f 	bl	c0de61cc <nbgl_pageDrawGenericContent>
c0de6f2e:	f240 6150 	movw	r1, #1616	@ 0x650
c0de6f32:	f2c0 0100 	movt	r1, #0
c0de6f36:	f849 0001 	str.w	r0, [r9, r1]
c0de6f3a:	2001      	movs	r0, #1
c0de6f3c:	2d00      	cmp	r5, #0
c0de6f3e:	bf18      	it	ne
c0de6f40:	2002      	movne	r0, #2
c0de6f42:	f001 fdd9 	bl	c0de8af8 <nbgl_refreshSpecial>
}
c0de6f46:	b020      	add	sp, #128	@ 0x80
c0de6f48:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de6f4c <nbgl_useCaseHomeAndSettings>:
        initSettingPage,  // if not INIT_HOME_PAGE, start directly the corresponding setting page
    const nbgl_genericContents_t *settingContents,
    const nbgl_contentInfoList_t *infosList,
    const nbgl_homeAction_t      *action,  // Set to NULL if no additional action
    nbgl_callback_t               quitCallback)
{
c0de6f4c:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de6f50:	b084      	sub	sp, #16
c0de6f52:	4604      	mov	r4, r0
    onQuit          = NULL;
c0de6f54:	f240 40dc 	movw	r0, #1244	@ 0x4dc
c0de6f58:	f2c0 0000 	movt	r0, #0
c0de6f5c:	f04f 0a00 	mov.w	sl, #0
c0de6f60:	f849 a000 	str.w	sl, [r9, r0]
    onContinue      = NULL;
c0de6f64:	f240 6064 	movw	r0, #1636	@ 0x664
c0de6f68:	f2c0 0000 	movt	r0, #0
c0de6f6c:	f849 a000 	str.w	sl, [r9, r0]
    onAction        = NULL;
c0de6f70:	f240 6060 	movw	r0, #1632	@ 0x660
c0de6f74:	f2c0 0000 	movt	r0, #0
c0de6f78:	f849 a000 	str.w	sl, [r9, r0]
    onNav           = NULL;
c0de6f7c:	f240 40e0 	movw	r0, #1248	@ 0x4e0
c0de6f80:	f2c0 0000 	movt	r0, #0
c0de6f84:	f849 a000 	str.w	sl, [r9, r0]
    onControls      = NULL;
c0de6f88:	f240 40e4 	movw	r0, #1252	@ 0x4e4
c0de6f8c:	f2c0 0000 	movt	r0, #0
c0de6f90:	f849 a000 	str.w	sl, [r9, r0]
    onContentAction = NULL;
c0de6f94:	f240 703c 	movw	r0, #1852	@ 0x73c
c0de6f98:	f2c0 0000 	movt	r0, #0
c0de6f9c:	f849 a000 	str.w	sl, [r9, r0]
    onChoice        = NULL;
c0de6fa0:	f240 6054 	movw	r0, #1620	@ 0x654
c0de6fa4:	f2c0 0000 	movt	r0, #0
c0de6fa8:	f849 a000 	str.w	sl, [r9, r0]
    memset(&genericContext, 0, sizeof(genericContext));
c0de6fac:	f240 40f0 	movw	r0, #1264	@ 0x4f0
c0de6fb0:	f2c0 0000 	movt	r0, #0
c0de6fb4:	460f      	mov	r7, r1
c0de6fb6:	e9dd b50e 	ldrd	fp, r5, [sp, #56]	@ 0x38
c0de6fba:	f8dd 8030 	ldr.w	r8, [sp, #48]	@ 0x30
c0de6fbe:	4448      	add	r0, r9
c0de6fc0:	2190      	movs	r1, #144	@ 0x90
c0de6fc2:	9303      	str	r3, [sp, #12]
c0de6fc4:	4616      	mov	r6, r2
c0de6fc6:	f002 fef9 	bl	c0de9dbc <__aeabi_memclr>
    nbgl_homeAndSettingsContext_t *context = &bundleNavContext.homeAndSettings;

    reset_callbacks_and_context();

    context->appName         = appName;
c0de6fca:	f240 6e28 	movw	lr, #1576	@ 0x628
c0de6fce:	f2c0 0e00 	movt	lr, #0
c0de6fd2:	eb09 030e 	add.w	r3, r9, lr
c0de6fd6:	4639      	mov	r1, r7
    context->appIcon         = appIcon;
c0de6fd8:	e9c3 7601 	strd	r7, r6, [r3, #4]
    context->tagline         = tagline;
    context->settingContents = settingContents;
    context->infosList       = infosList;
c0de6fdc:	9f0d      	ldr	r7, [sp, #52]	@ 0x34
c0de6fde:	4620      	mov	r0, r4
c0de6fe0:	4632      	mov	r2, r6
    if (action != NULL) {
c0de6fe2:	f1bb 0f00 	cmp.w	fp, #0
    context->appName         = appName;
c0de6fe6:	f849 400e 	str.w	r4, [r9, lr]
    context->settingContents = settingContents;
c0de6fea:	f8c3 800c 	str.w	r8, [r3, #12]
    context->infosList       = infosList;
c0de6fee:	611f      	str	r7, [r3, #16]
    if (action != NULL) {
c0de6ff0:	d00c      	beq.n	c0de700c <nbgl_useCaseHomeAndSettings+0xc0>
c0de6ff2:	46ac      	mov	ip, r5
        memcpy(&context->homeAction, action, sizeof(nbgl_homeAction_t));
c0de6ff4:	e9db 5300 	ldrd	r5, r3, [fp]
c0de6ff8:	e9db 7602 	ldrd	r7, r6, [fp, #8]
c0de6ffc:	eb09 040e 	add.w	r4, r9, lr
c0de7000:	6165      	str	r5, [r4, #20]
c0de7002:	4665      	mov	r5, ip
c0de7004:	e9c4 3706 	strd	r3, r7, [r4, #24]
c0de7008:	6226      	str	r6, [r4, #32]
c0de700a:	e005      	b.n	c0de7018 <nbgl_useCaseHomeAndSettings+0xcc>
    }
    else {
        memset(&context->homeAction, 0, sizeof(nbgl_homeAction_t));
c0de700c:	eb09 030e 	add.w	r3, r9, lr
c0de7010:	e9c3 aa05 	strd	sl, sl, [r3, #20]
c0de7014:	e9c3 aa07 	strd	sl, sl, [r3, #28]
c0de7018:	9e03      	ldr	r6, [sp, #12]
    }
    context->quitCallback = quitCallback;
c0de701a:	eb09 030e 	add.w	r3, r9, lr

    if (initSettingPage != INIT_HOME_PAGE) {
c0de701e:	2eff      	cmp	r6, #255	@ 0xff
    context->quitCallback = quitCallback;
c0de7020:	625d      	str	r5, [r3, #36]	@ 0x24
    if (initSettingPage != INIT_HOME_PAGE) {
c0de7022:	d00d      	beq.n	c0de7040 <nbgl_useCaseHomeAndSettings+0xf4>
    nbgl_useCaseGenericSettings(context->appName,
c0de7024:	f240 073b 	movw	r7, #59	@ 0x3b
c0de7028:	f2c0 0700 	movt	r7, #0
c0de702c:	9b0d      	ldr	r3, [sp, #52]	@ 0x34
c0de702e:	447f      	add	r7, pc
c0de7030:	4631      	mov	r1, r6
c0de7032:	4642      	mov	r2, r8
c0de7034:	9700      	str	r7, [sp, #0]
c0de7036:	f7ff faf5 	bl	c0de6624 <nbgl_useCaseGenericSettings>
        bundleNavStartSettingsAtPage(initSettingPage);
    }
    else {
        bundleNavStartHome();
    }
}
c0de703a:	b004      	add	sp, #16
c0de703c:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
                   context->settingContents != NULL ? true : false,
c0de7040:	f1b8 0f00 	cmp.w	r8, #0
c0de7044:	bf18      	it	ne
c0de7046:	f04f 0801 	movne.w	r8, #1
    useCaseHomeExt(context->appName,
c0de704a:	f640 13b9 	movw	r3, #2489	@ 0x9b9
c0de704e:	f2c0 0300 	movt	r3, #0
c0de7052:	eb09 070e 	add.w	r7, r9, lr
c0de7056:	447b      	add	r3, pc
c0de7058:	3714      	adds	r7, #20
c0de705a:	e9cd 7300 	strd	r7, r3, [sp]
c0de705e:	4643      	mov	r3, r8
c0de7060:	9502      	str	r5, [sp, #8]
c0de7062:	f7ff f9b9 	bl	c0de63d8 <useCaseHomeExt>
}
c0de7066:	b004      	add	sp, #16
c0de7068:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de706c <bundleNavStartHome>:
{
c0de706c:	b5b0      	push	{r4, r5, r7, lr}
c0de706e:	b084      	sub	sp, #16
    useCaseHomeExt(context->appName,
c0de7070:	f240 6128 	movw	r1, #1576	@ 0x628
c0de7074:	f2c0 0100 	movt	r1, #0
c0de7078:	eb09 0c01 	add.w	ip, r9, r1
                   context->appIcon,
c0de707c:	f10c 0304 	add.w	r3, ip, #4
    useCaseHomeExt(context->appName,
c0de7080:	f859 0001 	ldr.w	r0, [r9, r1]
                   context->appIcon,
c0de7084:	cb0e      	ldmia	r3, {r1, r2, r3}
                   context->quitCallback);
c0de7086:	f8dc e024 	ldr.w	lr, [ip, #36]	@ 0x24
                   context->settingContents != NULL ? true : false,
c0de708a:	2b00      	cmp	r3, #0
c0de708c:	bf18      	it	ne
c0de708e:	2301      	movne	r3, #1
    useCaseHomeExt(context->appName,
c0de7090:	f640 1573 	movw	r5, #2419	@ 0x973
c0de7094:	f2c0 0500 	movt	r5, #0
c0de7098:	f10c 0414 	add.w	r4, ip, #20
c0de709c:	447d      	add	r5, pc
c0de709e:	e88d 4030 	stmia.w	sp, {r4, r5, lr}
c0de70a2:	f7ff f999 	bl	c0de63d8 <useCaseHomeExt>
}
c0de70a6:	b004      	add	sp, #16
c0de70a8:	bdb0      	pop	{r4, r5, r7, pc}

c0de70aa <pageCallback>:
{
c0de70aa:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de70ae:	b09e      	sub	sp, #120	@ 0x78
c0de70b0:	4605      	mov	r5, r0
    if (token == QUIT_TOKEN) {
c0de70b2:	2808      	cmp	r0, #8
c0de70b4:	460c      	mov	r4, r1
c0de70b6:	dc1f      	bgt.n	c0de70f8 <pageCallback+0x4e>
c0de70b8:	2d04      	cmp	r5, #4
c0de70ba:	f300 8086 	bgt.w	c0de71ca <pageCallback+0x120>
c0de70be:	2d01      	cmp	r5, #1
c0de70c0:	f300 80a3 	bgt.w	c0de720a <pageCallback+0x160>
c0de70c4:	2d00      	cmp	r5, #0
c0de70c6:	f000 8101 	beq.w	c0de72cc <pageCallback+0x222>
c0de70ca:	2d01      	cmp	r5, #1
c0de70cc:	f040 81d2 	bne.w	c0de7474 <pageCallback+0x3ca>
        if (onNav != NULL) {
c0de70d0:	f240 40e0 	movw	r0, #1248	@ 0x4e0
c0de70d4:	f240 6168 	movw	r1, #1640	@ 0x668
c0de70d8:	f2c0 0000 	movt	r0, #0
c0de70dc:	f2c0 0100 	movt	r1, #0
c0de70e0:	f859 0000 	ldr.w	r0, [r9, r0]
c0de70e4:	f819 1001 	ldrb.w	r1, [r9, r1]
c0de70e8:	2800      	cmp	r0, #0
c0de70ea:	f101 0001 	add.w	r0, r1, #1
c0de70ee:	f000 81df 	beq.w	c0de74b0 <pageCallback+0x406>
            displayReviewPage(navInfo.activePage + 1, false);
c0de70f2:	b2c0      	uxtb	r0, r0
c0de70f4:	2100      	movs	r1, #0
c0de70f6:	e0fc      	b.n	c0de72f2 <pageCallback+0x248>
    if (token == QUIT_TOKEN) {
c0de70f8:	2d0c      	cmp	r5, #12
c0de70fa:	dc73      	bgt.n	c0de71e4 <pageCallback+0x13a>
c0de70fc:	2d0a      	cmp	r5, #10
c0de70fe:	f300 8098 	bgt.w	c0de7232 <pageCallback+0x188>
c0de7102:	2d09      	cmp	r5, #9
c0de7104:	f000 80fa 	beq.w	c0de72fc <pageCallback+0x252>
c0de7108:	2d0a      	cmp	r5, #10
c0de710a:	f040 81b3 	bne.w	c0de7474 <pageCallback+0x3ca>
        displayDetails(genericContext.detailsItem,
c0de710e:	f240 40f0 	movw	r0, #1264	@ 0x4f0
c0de7112:	f2c0 0000 	movt	r0, #0
c0de7116:	4448      	add	r0, r9
c0de7118:	e9d0 b506 	ldrd	fp, r5, [r0, #24]
                       genericContext.detailsWrapping);
c0de711c:	f890 4020 	ldrb.w	r4, [r0, #32]
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de7120:	f640 0a40 	movw	sl, #2112	@ 0x840
c0de7124:	f2c0 0a00 	movt	sl, #0
c0de7128:	2600      	movs	r6, #0
c0de712a:	eb09 070a 	add.w	r7, r9, sl
        = nbgl_getTextNbLinesInWidth(SMALL_REGULAR_FONT, value, AVAILABLE_WIDTH, wrapping);
c0de712e:	200b      	movs	r0, #11
c0de7130:	4629      	mov	r1, r5
c0de7132:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de7136:	4623      	mov	r3, r4
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de7138:	f849 600a 	str.w	r6, [r9, sl]
c0de713c:	e9c7 6601 	strd	r6, r6, [r7, #4]
c0de7140:	60fe      	str	r6, [r7, #12]
c0de7142:	f04f 080b 	mov.w	r8, #11
        = nbgl_getTextNbLinesInWidth(SMALL_REGULAR_FONT, value, AVAILABLE_WIDTH, wrapping);
c0de7146:	f001 fd2c 	bl	c0de8ba2 <nbgl_getTextNbLinesInWidth>
c0de714a:	f648 31a3 	movw	r1, #35747	@ 0x8ba3
    detailsContext.nbPages     = (nbLines + NB_MAX_LINES_IN_DETAILS - 1) / NB_MAX_LINES_IN_DETAILS;
c0de714e:	f100 020a 	add.w	r2, r0, #10
c0de7152:	f6cb 212e 	movt	r1, #47662	@ 0xba2e
c0de7156:	fba2 2301 	umull	r2, r3, r2, r1
c0de715a:	08da      	lsrs	r2, r3, #3
    if (detailsContext.nbPages > 1) {
c0de715c:	f3c3 03c7 	ubfx	r3, r3, #3, #8
c0de7160:	2b02      	cmp	r3, #2
    detailsContext.tag         = tag;
c0de7162:	e9c7 b501 	strd	fp, r5, [r7, #4]
    detailsContext.nbPages     = (nbLines + NB_MAX_LINES_IN_DETAILS - 1) / NB_MAX_LINES_IN_DETAILS;
c0de7166:	f809 200a 	strb.w	r2, [r9, sl]
    detailsContext.currentPage = 0;
c0de716a:	707e      	strb	r6, [r7, #1]
    detailsContext.wrapping    = wrapping;
c0de716c:	70fc      	strb	r4, [r7, #3]
c0de716e:	d325      	bcc.n	c0de71bc <pageCallback+0x112>
        uint16_t nbLostChars = (detailsContext.nbPages - 1) * 3;
c0de7170:	3b01      	subs	r3, #1
c0de7172:	eb03 0743 	add.w	r7, r3, r3, lsl #1
        uint16_t nbLostLines = (nbLostChars + ((AVAILABLE_WIDTH) / 16) - 1)
c0de7176:	b2bf      	uxth	r7, r7
c0de7178:	f64e 464f 	movw	r6, #60495	@ 0xec4f
c0de717c:	3719      	adds	r7, #25
c0de717e:	f6c4 66c4 	movt	r6, #20164	@ 0x4ec4
c0de7182:	f649 042b 	movw	r4, #38955	@ 0x982b
                               / ((AVAILABLE_WIDTH) / 16);  // 16 for average char width
c0de7186:	fba7 6506 	umull	r6, r5, r7, r6
c0de718a:	f2ce 5425 	movt	r4, #58661	@ 0xe525
c0de718e:	08ee      	lsrs	r6, r5, #3
        detailsContext.nbPages += nbLostLines / NB_MAX_LINES_IN_DETAILS;
c0de7190:	fba7 7404 	umull	r7, r4, r7, r4
        if ((nbLinesInLastPage + (nbLostLines % NB_MAX_LINES_IN_DETAILS))
c0de7194:	fba6 1701 	umull	r1, r7, r6, r1
c0de7198:	f06f 010a 	mvn.w	r1, #10
            = nbLines - ((detailsContext.nbPages - 1) * NB_MAX_LINES_IN_DETAILS);
c0de719c:	fb03 0001 	mla	r0, r3, r1, r0
        detailsContext.nbPages += nbLostLines / NB_MAX_LINES_IN_DETAILS;
c0de71a0:	eb02 2114 	add.w	r1, r2, r4, lsr #8
        if ((nbLinesInLastPage + (nbLostLines % NB_MAX_LINES_IN_DETAILS))
c0de71a4:	08fa      	lsrs	r2, r7, #3
c0de71a6:	fb02 f208 	mul.w	r2, r2, r8
c0de71aa:	b2c0      	uxtb	r0, r0
c0de71ac:	ebc2 02d5 	rsb	r2, r2, r5, lsr #3
c0de71b0:	4410      	add	r0, r2
c0de71b2:	280b      	cmp	r0, #11
c0de71b4:	bf88      	it	hi
c0de71b6:	3101      	addhi	r1, #1
c0de71b8:	f809 100a 	strb.w	r1, [r9, sl]
    displayDetailsPage(0, true);
c0de71bc:	2000      	movs	r0, #0
c0de71be:	2101      	movs	r1, #1
c0de71c0:	f001 f82c 	bl	c0de821c <displayDetailsPage>
}
c0de71c4:	b01e      	add	sp, #120	@ 0x78
c0de71c6:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
    if (token == QUIT_TOKEN) {
c0de71ca:	2d06      	cmp	r5, #6
c0de71cc:	dc42      	bgt.n	c0de7254 <pageCallback+0x1aa>
c0de71ce:	2d05      	cmp	r5, #5
c0de71d0:	f000 80a1 	beq.w	c0de7316 <pageCallback+0x26c>
c0de71d4:	2d06      	cmp	r5, #6
c0de71d6:	f040 814d 	bne.w	c0de7474 <pageCallback+0x3ca>
        if (onContinue != NULL) {
c0de71da:	f240 6064 	movw	r0, #1636	@ 0x664
c0de71de:	f2c0 0000 	movt	r0, #0
c0de71e2:	e04c      	b.n	c0de727e <pageCallback+0x1d4>
    if (token == QUIT_TOKEN) {
c0de71e4:	2d10      	cmp	r5, #16
c0de71e6:	dc53      	bgt.n	c0de7290 <pageCallback+0x1e6>
c0de71e8:	2d0d      	cmp	r5, #13
c0de71ea:	f000 80b5 	beq.w	c0de7358 <pageCallback+0x2ae>
c0de71ee:	2d10      	cmp	r5, #16
c0de71f0:	f040 8140 	bne.w	c0de7474 <pageCallback+0x3ca>
        reviewWithWarnCtx.isIntro = false;
c0de71f4:	f240 40f0 	movw	r0, #1264	@ 0x4f0
c0de71f8:	f2c0 0000 	movt	r0, #0
c0de71fc:	4448      	add	r0, r9
c0de71fe:	2100      	movs	r1, #0
c0de7200:	f880 1089 	strb.w	r1, [r0, #137]	@ 0x89
        reviewWithWarnCtx.warning = NULL;
c0de7204:	6781      	str	r1, [r0, #120]	@ 0x78
        displaySecurityReport(1 << BLIND_SIGNING_WARN);
c0de7206:	2010      	movs	r0, #16
c0de7208:	e12f      	b.n	c0de746a <pageCallback+0x3c0>
    if (token == QUIT_TOKEN) {
c0de720a:	2d02      	cmp	r5, #2
c0de720c:	d033      	beq.n	c0de7276 <pageCallback+0x1cc>
c0de720e:	2d03      	cmp	r5, #3
c0de7210:	f040 8130 	bne.w	c0de7474 <pageCallback+0x3ca>
        if (index == EXIT_PAGE) {
c0de7214:	2cff      	cmp	r4, #255	@ 0xff
c0de7216:	d02e      	beq.n	c0de7276 <pageCallback+0x1cc>
            if (navType == GENERIC_NAV || navType == STREAMING_NAV) {
c0de7218:	f240 40ec 	movw	r0, #1260	@ 0x4ec
c0de721c:	f2c0 0000 	movt	r0, #0
c0de7220:	f819 0000 	ldrb.w	r0, [r9, r0]
c0de7224:	f000 01fe 	and.w	r1, r0, #254	@ 0xfe
c0de7228:	2902      	cmp	r1, #2
c0de722a:	f040 81a3 	bne.w	c0de7574 <pageCallback+0x4ca>
                displayGenericContextPage(index, false);
c0de722e:	4620      	mov	r0, r4
c0de7230:	e13f      	b.n	c0de74b2 <pageCallback+0x408>
    if (token == QUIT_TOKEN) {
c0de7232:	2d0b      	cmp	r5, #11
c0de7234:	f000 80a0 	beq.w	c0de7378 <pageCallback+0x2ce>
c0de7238:	2d0c      	cmp	r5, #12
c0de723a:	f040 811b 	bne.w	c0de7474 <pageCallback+0x3ca>
        if (onChoice != NULL) {
c0de723e:	f240 6054 	movw	r0, #1620	@ 0x654
c0de7242:	f2c0 0000 	movt	r0, #0
c0de7246:	f859 1000 	ldr.w	r1, [r9, r0]
c0de724a:	2900      	cmp	r1, #0
c0de724c:	f000 817a 	beq.w	c0de7544 <pageCallback+0x49a>
            onChoice(false);
c0de7250:	2000      	movs	r0, #0
c0de7252:	e09b      	b.n	c0de738c <pageCallback+0x2e2>
    if (token == QUIT_TOKEN) {
c0de7254:	2d07      	cmp	r5, #7
c0de7256:	f000 809d 	beq.w	c0de7394 <pageCallback+0x2ea>
c0de725a:	2d08      	cmp	r5, #8
c0de725c:	f040 810a 	bne.w	c0de7474 <pageCallback+0x3ca>
c0de7260:	b934      	cbnz	r4, c0de7270 <pageCallback+0x1c6>
c0de7262:	f240 6060 	movw	r0, #1632	@ 0x660
c0de7266:	f2c0 0000 	movt	r0, #0
c0de726a:	f859 0000 	ldr.w	r0, [r9, r0]
c0de726e:	b958      	cbnz	r0, c0de7288 <pageCallback+0x1de>
        else if ((index == 1) && (onQuit != NULL)) {
c0de7270:	2c01      	cmp	r4, #1
c0de7272:	f040 8167 	bne.w	c0de7544 <pageCallback+0x49a>
c0de7276:	f240 40dc 	movw	r0, #1244	@ 0x4dc
c0de727a:	f2c0 0000 	movt	r0, #0
c0de727e:	f859 0000 	ldr.w	r0, [r9, r0]
c0de7282:	2800      	cmp	r0, #0
c0de7284:	f000 815e 	beq.w	c0de7544 <pageCallback+0x49a>
c0de7288:	4780      	blx	r0
}
c0de728a:	b01e      	add	sp, #120	@ 0x78
c0de728c:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
    if (token == QUIT_TOKEN) {
c0de7290:	2d11      	cmp	r5, #17
c0de7292:	f000 80dd 	beq.w	c0de7450 <pageCallback+0x3a6>
c0de7296:	2d13      	cmp	r5, #19
c0de7298:	f040 80ec 	bne.w	c0de7474 <pageCallback+0x3ca>
        if (genericContext.validWarningCtx && (reviewWithWarnCtx.warning->predefinedSet != 0)) {
c0de729c:	f240 40f0 	movw	r0, #1264	@ 0x4f0
c0de72a0:	f2c0 0000 	movt	r0, #0
c0de72a4:	eb09 0100 	add.w	r1, r9, r0
c0de72a8:	f891 1021 	ldrb.w	r1, [r1, #33]	@ 0x21
c0de72ac:	2900      	cmp	r1, #0
c0de72ae:	f000 8106 	beq.w	c0de74be <pageCallback+0x414>
c0de72b2:	eb09 0100 	add.w	r1, r9, r0
c0de72b6:	6f89      	ldr	r1, [r1, #120]	@ 0x78
c0de72b8:	680a      	ldr	r2, [r1, #0]
c0de72ba:	2a00      	cmp	r2, #0
c0de72bc:	f000 80ff 	beq.w	c0de74be <pageCallback+0x414>
            reviewWithWarnCtx.securityReportLevel = 1;
c0de72c0:	4448      	add	r0, r9
c0de72c2:	2201      	movs	r2, #1
c0de72c4:	f880 2088 	strb.w	r2, [r0, #136]	@ 0x88
            displaySecurityReport(reviewWithWarnCtx.warning->predefinedSet);
c0de72c8:	6808      	ldr	r0, [r1, #0]
c0de72ca:	e0ce      	b.n	c0de746a <pageCallback+0x3c0>
        if (onNav != NULL) {
c0de72cc:	f240 40e0 	movw	r0, #1248	@ 0x4e0
c0de72d0:	f240 6168 	movw	r1, #1640	@ 0x668
c0de72d4:	f2c0 0000 	movt	r0, #0
c0de72d8:	f2c0 0100 	movt	r1, #0
c0de72dc:	f859 0000 	ldr.w	r0, [r9, r0]
c0de72e0:	f819 1001 	ldrb.w	r1, [r9, r1]
c0de72e4:	2800      	cmp	r0, #0
c0de72e6:	f1a1 0001 	sub.w	r0, r1, #1
c0de72ea:	f000 80e1 	beq.w	c0de74b0 <pageCallback+0x406>
            displayReviewPage(navInfo.activePage - 1, true);
c0de72ee:	b2c0      	uxtb	r0, r0
c0de72f0:	2101      	movs	r1, #1
c0de72f2:	f000 fa44 	bl	c0de777e <displayReviewPage>
}
c0de72f6:	b01e      	add	sp, #120	@ 0x78
c0de72f8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        if (onChoice != NULL) {
c0de72fc:	f240 6054 	movw	r0, #1620	@ 0x654
c0de7300:	f2c0 0000 	movt	r0, #0
c0de7304:	f859 1000 	ldr.w	r1, [r9, r0]
c0de7308:	2900      	cmp	r1, #0
c0de730a:	f000 811b 	beq.w	c0de7544 <pageCallback+0x49a>
            onChoice((index == 0) ? true : false);
c0de730e:	fab4 f084 	clz	r0, r4
c0de7312:	0940      	lsrs	r0, r0, #5
c0de7314:	e03a      	b.n	c0de738c <pageCallback+0x2e2>
    nbgl_pageConfirmationDescription_t info = {
c0de7316:	f244 1072 	movw	r0, #16754	@ 0x4172
c0de731a:	f2c0 0000 	movt	r0, #0
c0de731e:	4478      	add	r0, pc
c0de7320:	c8cc      	ldmia	r0!, {r2, r3, r6, r7}
c0de7322:	a907      	add	r1, sp, #28
c0de7324:	c1cc      	stmia	r1!, {r2, r3, r6, r7}
c0de7326:	e890 00cc 	ldmia.w	r0, {r2, r3, r6, r7}
    if (modalPageContext != NULL) {
c0de732a:	f240 645c 	movw	r4, #1628	@ 0x65c
    nbgl_pageConfirmationDescription_t info = {
c0de732e:	c1cc      	stmia	r1!, {r2, r3, r6, r7}
    if (modalPageContext != NULL) {
c0de7330:	f2c0 0400 	movt	r4, #0
c0de7334:	f859 0004 	ldr.w	r0, [r9, r4]
c0de7338:	2800      	cmp	r0, #0
        nbgl_pageRelease(modalPageContext);
c0de733a:	bf18      	it	ne
c0de733c:	f7fe ff4b 	blne	c0de61d6 <nbgl_pageRelease>
    modalPageContext = nbgl_pageDrawConfirmation(&pageModalCallback, &info);
c0de7340:	f240 3031 	movw	r0, #817	@ 0x331
c0de7344:	f2c0 0000 	movt	r0, #0
c0de7348:	4478      	add	r0, pc
c0de734a:	a907      	add	r1, sp, #28
c0de734c:	f7fe fc5a 	bl	c0de5c04 <nbgl_pageDrawConfirmation>
c0de7350:	f849 0004 	str.w	r0, [r9, r4]
    nbgl_refreshSpecial(FULL_COLOR_PARTIAL_REFRESH);
c0de7354:	2001      	movs	r0, #1
c0de7356:	e0f3      	b.n	c0de7540 <pageCallback+0x496>
        if (genericContext.currentPairs != NULL) {
c0de7358:	f240 40f0 	movw	r0, #1264	@ 0x4f0
c0de735c:	f2c0 0000 	movt	r0, #0
c0de7360:	eb09 0100 	add.w	r1, r9, r0
c0de7364:	6a49      	ldr	r1, [r1, #36]	@ 0x24
            pair = genericContext.currentCallback(genericContext.currentElementIdx + index);
c0de7366:	4448      	add	r0, r9
        if (genericContext.currentPairs != NULL) {
c0de7368:	2900      	cmp	r1, #0
c0de736a:	f000 80ee 	beq.w	c0de754a <pageCallback+0x4a0>
            pair = &genericContext.currentPairs[genericContext.currentElementIdx + index];
c0de736e:	7c80      	ldrb	r0, [r0, #18]
c0de7370:	4420      	add	r0, r4
c0de7372:	eb01 1000 	add.w	r0, r1, r0, lsl #4
c0de7376:	e0ed      	b.n	c0de7554 <pageCallback+0x4aa>
        if (onChoice != NULL) {
c0de7378:	f240 6054 	movw	r0, #1620	@ 0x654
c0de737c:	f2c0 0000 	movt	r0, #0
c0de7380:	f859 1000 	ldr.w	r1, [r9, r0]
c0de7384:	2900      	cmp	r1, #0
c0de7386:	f000 80dd 	beq.w	c0de7544 <pageCallback+0x49a>
            onChoice(true);
c0de738a:	2001      	movs	r0, #1
c0de738c:	4788      	blx	r1
}
c0de738e:	b01e      	add	sp, #120	@ 0x78
c0de7390:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
    nbgl_layoutDescription_t layoutDescription = {.modal            = true,
c0de7394:	f244 1114 	movw	r1, #16660	@ 0x4114
c0de7398:	f2c0 0100 	movt	r1, #0
c0de739c:	4479      	add	r1, pc
c0de739e:	a807      	add	r0, sp, #28
c0de73a0:	c9c8      	ldmia	r1!, {r3, r6, r7}
c0de73a2:	4602      	mov	r2, r0
c0de73a4:	c2c8      	stmia	r2!, {r3, r6, r7}
c0de73a6:	e891 00e8 	ldmia.w	r1, {r3, r5, r6, r7}
c0de73aa:	f10d 085c 	add.w	r8, sp, #92	@ 0x5c
c0de73ae:	c2e8      	stmia	r2!, {r3, r5, r6, r7}
    nbgl_layoutHeader_t      headerDesc        = {
c0de73b0:	f244 01c4 	movw	r1, #16580	@ 0x40c4
c0de73b4:	f2c0 0100 	movt	r1, #0
c0de73b8:	4479      	add	r1, pc
c0de73ba:	e891 00f8 	ldmia.w	r1, {r3, r4, r5, r6, r7}
c0de73be:	4642      	mov	r2, r8
c0de73c0:	c2f8      	stmia	r2!, {r3, r4, r5, r6, r7}
    nbgl_layoutQRCode_t qrCode = {.url      = addressConfirmationContext.tagValuePairs[0].value,
c0de73c2:	f240 6584 	movw	r5, #1668	@ 0x684
c0de73c6:	f2c0 0500 	movt	r5, #0
c0de73ca:	eb09 0605 	add.w	r6, r9, r5
c0de73ce:	6871      	ldr	r1, [r6, #4]
c0de73d0:	9103      	str	r1, [sp, #12]
c0de73d2:	2100      	movs	r1, #0
c0de73d4:	e9cd 1104 	strd	r1, r1, [sp, #16]
c0de73d8:	f44f 3180 	mov.w	r1, #65536	@ 0x10000
c0de73dc:	9106      	str	r1, [sp, #24]
    addressConfirmationContext.modalLayout = nbgl_layoutGet(&layoutDescription);
c0de73de:	f7f9 ff2f 	bl	c0de1240 <nbgl_layoutGet>
    nbgl_layoutAddHeader(addressConfirmationContext.modalLayout, &headerDesc);
c0de73e2:	4641      	mov	r1, r8
    addressConfirmationContext.modalLayout = nbgl_layoutGet(&layoutDescription);
c0de73e4:	6330      	str	r0, [r6, #48]	@ 0x30
    nbgl_layoutAddHeader(addressConfirmationContext.modalLayout, &headerDesc);
c0de73e6:	f7fd fbab 	bl	c0de4b40 <nbgl_layoutAddHeader>
                                                  addressConfirmationContext.tagValuePairs[0].value,
c0de73ea:	6871      	ldr	r1, [r6, #4]
    uint16_t nbLines = nbgl_getTextNbLinesInWidth(SMALL_REGULAR_FONT,
c0de73ec:	200b      	movs	r0, #11
c0de73ee:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de73f2:	2300      	movs	r3, #0
c0de73f4:	f001 fbd5 	bl	c0de8ba2 <nbgl_getTextNbLinesInWidth>
c0de73f8:	6871      	ldr	r1, [r6, #4]
    if (nbLines <= QRCODE_NB_MAX_LINES) {
c0de73fa:	2804      	cmp	r0, #4
c0de73fc:	d30f      	bcc.n	c0de741e <pageCallback+0x374>
        nbgl_textReduceOnNbLines(SMALL_REGULAR_FONT,
c0de73fe:	f240 72c0 	movw	r2, #1984	@ 0x7c0
c0de7402:	2080      	movs	r0, #128	@ 0x80
c0de7404:	f2c0 0200 	movt	r2, #0
c0de7408:	eb09 0402 	add.w	r4, r9, r2
c0de740c:	9001      	str	r0, [sp, #4]
c0de740e:	200b      	movs	r0, #11
c0de7410:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de7414:	2303      	movs	r3, #3
c0de7416:	9400      	str	r4, [sp, #0]
c0de7418:	f001 fbd2 	bl	c0de8bc0 <nbgl_textReduceOnNbLines>
c0de741c:	4621      	mov	r1, r4
    nbgl_layoutAddQRCode(addressConfirmationContext.modalLayout, &qrCode);
c0de741e:	eb09 0405 	add.w	r4, r9, r5
c0de7422:	6b20      	ldr	r0, [r4, #48]	@ 0x30
c0de7424:	9105      	str	r1, [sp, #20]
c0de7426:	a903      	add	r1, sp, #12
c0de7428:	f7fc fdbf 	bl	c0de3faa <nbgl_layoutAddQRCode>
        addressConfirmationContext.modalLayout, "Close", DISMISS_QR_TOKEN, TUNE_TAP_CASUAL);
c0de742c:	6b20      	ldr	r0, [r4, #48]	@ 0x30
    nbgl_layoutAddFooter(
c0de742e:	f643 219c 	movw	r1, #15004	@ 0x3a9c
c0de7432:	f2c0 0100 	movt	r1, #0
c0de7436:	4479      	add	r1, pc
c0de7438:	2216      	movs	r2, #22
c0de743a:	2309      	movs	r3, #9
c0de743c:	f7fd fb58 	bl	c0de4af0 <nbgl_layoutAddFooter>
    nbgl_layoutDraw(addressConfirmationContext.modalLayout);
c0de7440:	6b20      	ldr	r0, [r4, #48]	@ 0x30
c0de7442:	f7fd ffc3 	bl	c0de53cc <nbgl_layoutDraw>
    nbgl_refresh();
c0de7446:	f001 fb52 	bl	c0de8aee <nbgl_refresh>
}
c0de744a:	b01e      	add	sp, #120	@ 0x78
c0de744c:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        reviewWithWarnCtx.securityReportLevel = 1;
c0de7450:	f240 44f0 	movw	r4, #1264	@ 0x4f0
c0de7454:	f2c0 0400 	movt	r4, #0
c0de7458:	eb09 0004 	add.w	r0, r9, r4
c0de745c:	2201      	movs	r2, #1
        if (reviewWithWarnCtx.warning->predefinedSet) {
c0de745e:	6f81      	ldr	r1, [r0, #120]	@ 0x78
        reviewWithWarnCtx.securityReportLevel = 1;
c0de7460:	f880 2088 	strb.w	r2, [r0, #136]	@ 0x88
        if (reviewWithWarnCtx.warning->predefinedSet) {
c0de7464:	6808      	ldr	r0, [r1, #0]
c0de7466:	2800      	cmp	r0, #0
c0de7468:	d07d      	beq.n	c0de7566 <pageCallback+0x4bc>
c0de746a:	f000 fc49 	bl	c0de7d00 <displaySecurityReport>
}
c0de746e:	b01e      	add	sp, #120	@ 0x78
c0de7470:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        if (onContentAction != NULL) {
c0de7474:	f240 703c 	movw	r0, #1852	@ 0x73c
c0de7478:	f2c0 0000 	movt	r0, #0
c0de747c:	f859 3000 	ldr.w	r3, [r9, r0]
c0de7480:	b143      	cbz	r3, c0de7494 <pageCallback+0x3ea>
            onContentAction(token, index, navInfo.activePage);
c0de7482:	f240 6068 	movw	r0, #1640	@ 0x668
c0de7486:	f2c0 0000 	movt	r0, #0
c0de748a:	f819 2000 	ldrb.w	r2, [r9, r0]
c0de748e:	4628      	mov	r0, r5
c0de7490:	4621      	mov	r1, r4
c0de7492:	4798      	blx	r3
        if (onControls != NULL) {
c0de7494:	f240 40e4 	movw	r0, #1252	@ 0x4e4
c0de7498:	f2c0 0000 	movt	r0, #0
c0de749c:	f859 2000 	ldr.w	r2, [r9, r0]
c0de74a0:	2a00      	cmp	r2, #0
c0de74a2:	d04f      	beq.n	c0de7544 <pageCallback+0x49a>
            onControls(token, index);
c0de74a4:	4628      	mov	r0, r5
c0de74a6:	4621      	mov	r1, r4
c0de74a8:	4790      	blx	r2
}
c0de74aa:	b01e      	add	sp, #120	@ 0x78
c0de74ac:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de74b0:	b2c0      	uxtb	r0, r0
c0de74b2:	2100      	movs	r1, #0
c0de74b4:	f7ff fae8 	bl	c0de6a88 <displayGenericContextPage>
c0de74b8:	b01e      	add	sp, #120	@ 0x78
c0de74ba:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            displayInfosListModal(activeTipBox.modalTitle, &activeTipBox.infos, false);
c0de74be:	eb09 0100 	add.w	r1, r9, r0
c0de74c2:	6c48      	ldr	r0, [r1, #68]	@ 0x44
    nbgl_pageNavigationInfo_t info = {.activePage                = 0,
c0de74c4:	f244 025c 	movw	r2, #16476	@ 0x405c
c0de74c8:	f2c0 0200 	movt	r2, #0
c0de74cc:	447a      	add	r2, pc
c0de74ce:	cae0      	ldmia	r2!, {r5, r6, r7}
c0de74d0:	ab17      	add	r3, sp, #92	@ 0x5c
c0de74d2:	c3e0      	stmia	r3!, {r5, r6, r7}
c0de74d4:	e892 00f0 	ldmia.w	r2, {r4, r5, r6, r7}
c0de74d8:	c3f0      	stmia	r3!, {r4, r5, r6, r7}
        = {.type                     = INFOS_LIST,
c0de74da:	9007      	str	r0, [sp, #28]
c0de74dc:	f241 4000 	movw	r0, #5120	@ 0x1400
c0de74e0:	f2c0 0009 	movt	r0, #9
c0de74e4:	9008      	str	r0, [sp, #32]
c0de74e6:	2000      	movs	r0, #0
c0de74e8:	9009      	str	r0, [sp, #36]	@ 0x24
c0de74ea:	2008      	movs	r0, #8
           .infosList.infoTypes      = infos->infoTypes,
c0de74ec:	f101 034c 	add.w	r3, r1, #76	@ 0x4c
        = {.type                     = INFOS_LIST,
c0de74f0:	f88d 0028 	strb.w	r0, [sp, #40]	@ 0x28
           .infosList.infoTypes      = infos->infoTypes,
c0de74f4:	cb0d      	ldmia	r3, {r0, r2, r3}
    if (modalPageContext != NULL) {
c0de74f6:	f240 645c 	movw	r4, #1628	@ 0x65c
           .infosList.nbInfos        = infos->nbInfos,
c0de74fa:	e9cd 020b 	strd	r0, r2, [sp, #44]	@ 0x2c
c0de74fe:	f891 0058 	ldrb.w	r0, [r1, #88]	@ 0x58
    if (modalPageContext != NULL) {
c0de7502:	f2c0 0400 	movt	r4, #0
           .infosList.nbInfos        = infos->nbInfos,
c0de7506:	f88d 0038 	strb.w	r0, [sp, #56]	@ 0x38
c0de750a:	200f      	movs	r0, #15
c0de750c:	f88d 0039 	strb.w	r0, [sp, #57]	@ 0x39
    if (modalPageContext != NULL) {
c0de7510:	f859 0004 	ldr.w	r0, [r9, r4]
           .infosList.withExtensions = infos->withExtensions,
c0de7514:	f891 105a 	ldrb.w	r1, [r1, #90]	@ 0x5a
    if (modalPageContext != NULL) {
c0de7518:	2800      	cmp	r0, #0
           .infosList.nbInfos        = infos->nbInfos,
c0de751a:	930d      	str	r3, [sp, #52]	@ 0x34
c0de751c:	f88d 103a 	strb.w	r1, [sp, #58]	@ 0x3a
        nbgl_pageRelease(modalPageContext);
c0de7520:	bf18      	it	ne
c0de7522:	f7fe fe58 	blne	c0de61d6 <nbgl_pageRelease>
    modalPageContext = nbgl_pageDrawGenericContentExt(&pageModalCallback, &info, &content, true);
c0de7526:	f240 104b 	movw	r0, #331	@ 0x14b
c0de752a:	f2c0 0000 	movt	r0, #0
c0de752e:	4478      	add	r0, pc
c0de7530:	a917      	add	r1, sp, #92	@ 0x5c
c0de7532:	aa07      	add	r2, sp, #28
c0de7534:	2301      	movs	r3, #1
c0de7536:	f7fe fbab 	bl	c0de5c90 <nbgl_pageDrawGenericContentExt>
c0de753a:	f849 0004 	str.w	r0, [r9, r4]
    nbgl_refreshSpecial(FULL_COLOR_CLEAN_REFRESH);
c0de753e:	2002      	movs	r0, #2
c0de7540:	f001 fada 	bl	c0de8af8 <nbgl_refreshSpecial>
}
c0de7544:	b01e      	add	sp, #120	@ 0x78
c0de7546:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            pair = genericContext.currentCallback(genericContext.currentElementIdx + index);
c0de754a:	7c81      	ldrb	r1, [r0, #18]
c0de754c:	6a82      	ldr	r2, [r0, #40]	@ 0x28
c0de754e:	1908      	adds	r0, r1, r4
c0de7550:	b2c0      	uxtb	r0, r0
c0de7552:	4790      	blx	r2
        displayFullValuePage(pair->item, pair->value, pair->extension);
c0de7554:	e9d0 3100 	ldrd	r3, r1, [r0]
c0de7558:	6882      	ldr	r2, [r0, #8]
c0de755a:	4618      	mov	r0, r3
c0de755c:	f000 fa70 	bl	c0de7a40 <displayFullValuePage>
}
c0de7560:	b01e      	add	sp, #120	@ 0x78
c0de7562:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            if (reviewWithWarnCtx.isIntro) {
c0de7566:	eb09 0004 	add.w	r0, r9, r4
c0de756a:	f890 0089 	ldrb.w	r0, [r0, #137]	@ 0x89
c0de756e:	b148      	cbz	r0, c0de7584 <pageCallback+0x4da>
                displayCustomizedSecurityReport(reviewWithWarnCtx.warning->introDetails);
c0de7570:	6948      	ldr	r0, [r1, #20]
c0de7572:	e008      	b.n	c0de7586 <pageCallback+0x4dc>
            else if (navType == REVIEW_NAV) {
c0de7574:	b188      	cbz	r0, c0de759a <pageCallback+0x4f0>
                displaySettingsPage(index, false);
c0de7576:	4620      	mov	r0, r4
c0de7578:	2100      	movs	r1, #0
c0de757a:	f7ff f814 	bl	c0de65a6 <displaySettingsPage>
}
c0de757e:	b01e      	add	sp, #120	@ 0x78
c0de7580:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
                displayCustomizedSecurityReport(reviewWithWarnCtx.warning->reviewDetails);
c0de7584:	6988      	ldr	r0, [r1, #24]
c0de7586:	2117      	movs	r1, #23
c0de7588:	f000 fdbe 	bl	c0de8108 <displayModalDetails>
c0de758c:	eb09 0104 	add.w	r1, r9, r4
c0de7590:	f8c1 0084 	str.w	r0, [r1, #132]	@ 0x84
}
c0de7594:	b01e      	add	sp, #120	@ 0x78
c0de7596:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
                displayReviewPage(index, false);
c0de759a:	4620      	mov	r0, r4
c0de759c:	e5aa      	b.n	c0de70f4 <pageCallback+0x4a>

c0de759e <nbgl_useCaseChoice>:
                        const char                *message,
                        const char                *subMessage,
                        const char                *confirmText,
                        const char                *cancelText,
                        nbgl_choiceCallback_t      callback)
{
c0de759e:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de75a2:	b088      	sub	sp, #32
c0de75a4:	4683      	mov	fp, r0
c0de75a6:	2000      	movs	r0, #0
    nbgl_pageConfirmationDescription_t info = {0};
    // check params
    if ((confirmText == NULL) || (cancelText == NULL)) {
c0de75a8:	2b00      	cmp	r3, #0
    nbgl_pageConfirmationDescription_t info = {0};
c0de75aa:	9007      	str	r0, [sp, #28]
c0de75ac:	e9cd 0005 	strd	r0, r0, [sp, #20]
c0de75b0:	e9cd 0003 	strd	r0, r0, [sp, #12]
c0de75b4:	e9cd 0001 	strd	r0, r0, [sp, #4]
c0de75b8:	9000      	str	r0, [sp, #0]
    if ((confirmText == NULL) || (cancelText == NULL)) {
c0de75ba:	d05c      	beq.n	c0de7676 <nbgl_useCaseChoice+0xd8>
c0de75bc:	f8dd a040 	ldr.w	sl, [sp, #64]	@ 0x40
c0de75c0:	f1ba 0f00 	cmp.w	sl, #0
c0de75c4:	d057      	beq.n	c0de7676 <nbgl_useCaseChoice+0xd8>
    onQuit          = NULL;
c0de75c6:	f240 40dc 	movw	r0, #1244	@ 0x4dc
c0de75ca:	f2c0 0000 	movt	r0, #0
c0de75ce:	2500      	movs	r5, #0
c0de75d0:	f849 5000 	str.w	r5, [r9, r0]
    onContinue      = NULL;
c0de75d4:	f240 6064 	movw	r0, #1636	@ 0x664
c0de75d8:	f2c0 0000 	movt	r0, #0
c0de75dc:	f849 5000 	str.w	r5, [r9, r0]
    onAction        = NULL;
c0de75e0:	f240 6060 	movw	r0, #1632	@ 0x660
c0de75e4:	f2c0 0000 	movt	r0, #0
c0de75e8:	f849 5000 	str.w	r5, [r9, r0]
    onNav           = NULL;
c0de75ec:	f240 40e0 	movw	r0, #1248	@ 0x4e0
c0de75f0:	f2c0 0000 	movt	r0, #0
c0de75f4:	f849 5000 	str.w	r5, [r9, r0]
    onControls      = NULL;
c0de75f8:	f240 40e4 	movw	r0, #1252	@ 0x4e4
c0de75fc:	f2c0 0000 	movt	r0, #0
c0de7600:	f849 5000 	str.w	r5, [r9, r0]
    onContentAction = NULL;
c0de7604:	f240 703c 	movw	r0, #1852	@ 0x73c
c0de7608:	f2c0 0000 	movt	r0, #0
c0de760c:	f849 5000 	str.w	r5, [r9, r0]
    memset(&genericContext, 0, sizeof(genericContext));
c0de7610:	f240 40f0 	movw	r0, #1264	@ 0x4f0
    onChoice        = NULL;
c0de7614:	f240 6854 	movw	r8, #1620	@ 0x654
    memset(&genericContext, 0, sizeof(genericContext));
c0de7618:	f2c0 0000 	movt	r0, #0
c0de761c:	460f      	mov	r7, r1
    onChoice        = NULL;
c0de761e:	f2c0 0800 	movt	r8, #0
    memset(&genericContext, 0, sizeof(genericContext));
c0de7622:	4448      	add	r0, r9
c0de7624:	2190      	movs	r1, #144	@ 0x90
c0de7626:	461c      	mov	r4, r3
c0de7628:	4616      	mov	r6, r2
    onChoice        = NULL;
c0de762a:	f849 5008 	str.w	r5, [r9, r8]
    memset(&genericContext, 0, sizeof(genericContext));
c0de762e:	f002 fbc5 	bl	c0de9dbc <__aeabi_memclr>
c0de7632:	2009      	movs	r0, #9
    info.centeredInfo.text1 = message;
    info.centeredInfo.text2 = subMessage;
    info.centeredInfo.style = LARGE_CASE_INFO;
    info.centeredInfo.icon  = icon;
    info.confirmationText   = confirmText;
    info.confirmationToken  = CHOICE_TOKEN;
c0de7634:	f88d 001c 	strb.w	r0, [sp, #28]
    info.tuneId             = TUNE_TAP_CASUAL;
c0de7638:	f88d 001e 	strb.w	r0, [sp, #30]

    onChoice    = callback;
c0de763c:	9811      	ldr	r0, [sp, #68]	@ 0x44
    info.cancelText         = cancelText;
c0de763e:	f8cd a018 	str.w	sl, [sp, #24]
    info.centeredInfo.text1 = message;
c0de7642:	e9cd 7600 	strd	r7, r6, [sp]
    info.centeredInfo.style = LARGE_CASE_INFO;
c0de7646:	f88d 5011 	strb.w	r5, [sp, #17]
    info.centeredInfo.icon  = icon;
c0de764a:	f8cd b00c 	str.w	fp, [sp, #12]
    info.confirmationText   = confirmText;
c0de764e:	9405      	str	r4, [sp, #20]
    onChoice    = callback;
c0de7650:	f849 0008 	str.w	r0, [r9, r8]
    pageContext = nbgl_pageDrawConfirmation(&pageCallback, &info);
c0de7654:	f64f 204b 	movw	r0, #64075	@ 0xfa4b
c0de7658:	f6cf 70ff 	movt	r0, #65535	@ 0xffff
c0de765c:	4478      	add	r0, pc
c0de765e:	4669      	mov	r1, sp
c0de7660:	f7fe fad0 	bl	c0de5c04 <nbgl_pageDrawConfirmation>
c0de7664:	f240 6150 	movw	r1, #1616	@ 0x650
c0de7668:	f2c0 0100 	movt	r1, #0
c0de766c:	f849 0001 	str.w	r0, [r9, r1]
    nbgl_refreshSpecial(FULL_COLOR_PARTIAL_REFRESH);
c0de7670:	2001      	movs	r0, #1
c0de7672:	f001 fa41 	bl	c0de8af8 <nbgl_refreshSpecial>
}
c0de7676:	b008      	add	sp, #32
c0de7678:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de767c <pageModalCallback>:
{
c0de767c:	b570      	push	{r4, r5, r6, lr}
    if (token == INFOS_TIP_BOX_TOKEN) {
c0de767e:	280e      	cmp	r0, #14
c0de7680:	460c      	mov	r4, r1
c0de7682:	d00b      	beq.n	c0de769c <pageModalCallback+0x20>
c0de7684:	4605      	mov	r5, r0
c0de7686:	280f      	cmp	r0, #15
c0de7688:	d11b      	bne.n	c0de76c2 <pageModalCallback+0x46>
        displayFullValuePage(activeTipBox.infos.infoTypes[index],
c0de768a:	f240 40f0 	movw	r0, #1264	@ 0x4f0
c0de768e:	f2c0 0000 	movt	r0, #0
c0de7692:	4448      	add	r0, r9
c0de7694:	f100 034c 	add.w	r3, r0, #76	@ 0x4c
c0de7698:	cb0e      	ldmia	r3, {r1, r2, r3}
c0de769a:	e007      	b.n	c0de76ac <pageModalCallback+0x30>
        displayFullValuePage(genericContext.currentInfos->infoTypes[index],
c0de769c:	f240 40f0 	movw	r0, #1264	@ 0x4f0
c0de76a0:	f2c0 0000 	movt	r0, #0
c0de76a4:	4448      	add	r0, r9
c0de76a6:	6b40      	ldr	r0, [r0, #52]	@ 0x34
c0de76a8:	e890 000e 	ldmia.w	r0, {r1, r2, r3}
c0de76ac:	f851 0024 	ldr.w	r0, [r1, r4, lsl #2]
c0de76b0:	f852 1024 	ldr.w	r1, [r2, r4, lsl #2]
c0de76b4:	ebc4 02c4 	rsb	r2, r4, r4, lsl #3
c0de76b8:	eb03 0282 	add.w	r2, r3, r2, lsl #2
c0de76bc:	f000 f9c0 	bl	c0de7a40 <displayFullValuePage>
}
c0de76c0:	bd70      	pop	{r4, r5, r6, pc}
    nbgl_pageRelease(modalPageContext);
c0de76c2:	f240 665c 	movw	r6, #1628	@ 0x65c
c0de76c6:	f2c0 0600 	movt	r6, #0
c0de76ca:	f859 0006 	ldr.w	r0, [r9, r6]
c0de76ce:	f7fe fd82 	bl	c0de61d6 <nbgl_pageRelease>
c0de76d2:	2000      	movs	r0, #0
    if (token == NAV_TOKEN) {
c0de76d4:	2d04      	cmp	r5, #4
    modalPageContext = NULL;
c0de76d6:	f849 0006 	str.w	r0, [r9, r6]
    if (token == NAV_TOKEN) {
c0de76da:	dc14      	bgt.n	c0de7706 <pageModalCallback+0x8a>
c0de76dc:	2d02      	cmp	r5, #2
c0de76de:	d032      	beq.n	c0de7746 <pageModalCallback+0xca>
c0de76e0:	2d03      	cmp	r5, #3
c0de76e2:	d008      	beq.n	c0de76f6 <pageModalCallback+0x7a>
c0de76e4:	2d04      	cmp	r5, #4
c0de76e6:	d140      	bne.n	c0de776a <pageModalCallback+0xee>
        if (index == EXIT_PAGE) {
c0de76e8:	2cff      	cmp	r4, #255	@ 0xff
c0de76ea:	d02c      	beq.n	c0de7746 <pageModalCallback+0xca>
            displayTagValueListModalPage(index, false);
c0de76ec:	4620      	mov	r0, r4
c0de76ee:	2100      	movs	r1, #0
c0de76f0:	f000 fe88 	bl	c0de8404 <displayTagValueListModalPage>
}
c0de76f4:	bd70      	pop	{r4, r5, r6, pc}
        if (index == EXIT_PAGE) {
c0de76f6:	2cff      	cmp	r4, #255	@ 0xff
c0de76f8:	d038      	beq.n	c0de776c <pageModalCallback+0xf0>
            displayDetailsPage(index, false);
c0de76fa:	4620      	mov	r0, r4
c0de76fc:	2100      	movs	r1, #0
c0de76fe:	f000 fd8d 	bl	c0de821c <displayDetailsPage>
    if (token == MODAL_NAV_TOKEN) {
c0de7702:	2d04      	cmp	r5, #4
c0de7704:	dd38      	ble.n	c0de7778 <pageModalCallback+0xfc>
c0de7706:	2d05      	cmp	r5, #5
c0de7708:	d016      	beq.n	c0de7738 <pageModalCallback+0xbc>
c0de770a:	2d09      	cmp	r5, #9
c0de770c:	d01a      	beq.n	c0de7744 <pageModalCallback+0xc8>
c0de770e:	2d14      	cmp	r5, #20
c0de7710:	d12b      	bne.n	c0de776a <pageModalCallback+0xee>
        if (reviewWithWarnCtx.securityReportLevel == 2) {
c0de7712:	f240 40f0 	movw	r0, #1264	@ 0x4f0
c0de7716:	f2c0 0000 	movt	r0, #0
c0de771a:	eb09 0100 	add.w	r1, r9, r0
c0de771e:	f891 1088 	ldrb.w	r1, [r1, #136]	@ 0x88
c0de7722:	2902      	cmp	r1, #2
c0de7724:	d10f      	bne.n	c0de7746 <pageModalCallback+0xca>
            reviewWithWarnCtx.securityReportLevel = 1;
c0de7726:	4448      	add	r0, r9
c0de7728:	2101      	movs	r1, #1
            displaySecurityReport(reviewWithWarnCtx.warning->predefinedSet);
c0de772a:	6f82      	ldr	r2, [r0, #120]	@ 0x78
            reviewWithWarnCtx.securityReportLevel = 1;
c0de772c:	f880 1088 	strb.w	r1, [r0, #136]	@ 0x88
            displaySecurityReport(reviewWithWarnCtx.warning->predefinedSet);
c0de7730:	6810      	ldr	r0, [r2, #0]
c0de7732:	f000 fae5 	bl	c0de7d00 <displaySecurityReport>
}
c0de7736:	bd70      	pop	{r4, r5, r6, pc}
        if (index == 0) {
c0de7738:	b92c      	cbnz	r4, c0de7746 <pageModalCallback+0xca>
            displayGenericContextPage(LAST_PAGE_FOR_REVIEW, true);
c0de773a:	20ff      	movs	r0, #255	@ 0xff
c0de773c:	2101      	movs	r1, #1
c0de773e:	f7ff f9a3 	bl	c0de6a88 <displayGenericContextPage>
}
c0de7742:	bd70      	pop	{r4, r5, r6, pc}
        if (index == 0) {
c0de7744:	b124      	cbz	r4, c0de7750 <pageModalCallback+0xd4>
c0de7746:	f001 f9fa 	bl	c0de8b3e <nbgl_screenRedraw>
c0de774a:	f001 f9d0 	bl	c0de8aee <nbgl_refresh>
}
c0de774e:	bd70      	pop	{r4, r5, r6, pc}
            if (onModalConfirm != NULL) {
c0de7750:	f240 6458 	movw	r4, #1624	@ 0x658
c0de7754:	f2c0 0400 	movt	r4, #0
c0de7758:	f859 0004 	ldr.w	r0, [r9, r4]
c0de775c:	2800      	cmp	r0, #0
}
c0de775e:	bf08      	it	eq
c0de7760:	bd70      	popeq	{r4, r5, r6, pc}
                onModalConfirm();
c0de7762:	4780      	blx	r0
c0de7764:	2000      	movs	r0, #0
                onModalConfirm = NULL;
c0de7766:	f849 0004 	str.w	r0, [r9, r4]
}
c0de776a:	bd70      	pop	{r4, r5, r6, pc}
            nbgl_screenRedraw();
c0de776c:	f001 f9e7 	bl	c0de8b3e <nbgl_screenRedraw>
            nbgl_refresh();
c0de7770:	f001 f9bd 	bl	c0de8aee <nbgl_refresh>
    if (token == MODAL_NAV_TOKEN) {
c0de7774:	2d04      	cmp	r5, #4
c0de7776:	dcc6      	bgt.n	c0de7706 <pageModalCallback+0x8a>
c0de7778:	2d02      	cmp	r5, #2
c0de777a:	d1b3      	bne.n	c0de76e4 <pageModalCallback+0x68>
c0de777c:	e7e3      	b.n	c0de7746 <pageModalCallback+0xca>

c0de777e <displayReviewPage>:
{
c0de777e:	b570      	push	{r4, r5, r6, lr}
c0de7780:	b090      	sub	sp, #64	@ 0x40
c0de7782:	460c      	mov	r4, r1
c0de7784:	4605      	mov	r5, r0
c0de7786:	4668      	mov	r0, sp
    nbgl_pageContent_t content = {0};
c0de7788:	2140      	movs	r1, #64	@ 0x40
c0de778a:	f002 fb17 	bl	c0de9dbc <__aeabi_memclr>
    if ((navInfo.nbPages != 0) && (page >= (navInfo.nbPages))) {
c0de778e:	f240 6668 	movw	r6, #1640	@ 0x668
c0de7792:	f2c0 0600 	movt	r6, #0
c0de7796:	eb09 0006 	add.w	r0, r9, r6
c0de779a:	7840      	ldrb	r0, [r0, #1]
c0de779c:	3801      	subs	r0, #1
c0de779e:	b2c0      	uxtb	r0, r0
c0de77a0:	42a8      	cmp	r0, r5
c0de77a2:	d353      	bcc.n	c0de784c <displayReviewPage+0xce>
    if ((onNav == NULL) || (onNav(navInfo.activePage, &content) == false)) {
c0de77a4:	f240 40e0 	movw	r0, #1248	@ 0x4e0
c0de77a8:	f2c0 0000 	movt	r0, #0
c0de77ac:	f859 2000 	ldr.w	r2, [r9, r0]
    navInfo.activePage = page;
c0de77b0:	f809 5006 	strb.w	r5, [r9, r6]
    if ((onNav == NULL) || (onNav(navInfo.activePage, &content) == false)) {
c0de77b4:	2a00      	cmp	r2, #0
c0de77b6:	d049      	beq.n	c0de784c <displayReviewPage+0xce>
c0de77b8:	4669      	mov	r1, sp
c0de77ba:	4628      	mov	r0, r5
c0de77bc:	4790      	blx	r2
c0de77be:	2800      	cmp	r0, #0
c0de77c0:	d044      	beq.n	c0de784c <displayReviewPage+0xce>
c0de77c2:	2000      	movs	r0, #0
    content.title            = NULL;
c0de77c4:	9000      	str	r0, [sp, #0]
    content.isTouchableTitle = false;
c0de77c6:	f88d 0004 	strb.w	r0, [sp, #4]
    if (content.type == INFO_LONG_PRESS) {  // last page
c0de77ca:	f89d 000c 	ldrb.w	r0, [sp, #12]
c0de77ce:	2109      	movs	r1, #9
c0de77d0:	2804      	cmp	r0, #4
    content.tuneId           = TUNE_TAP_CASUAL;
c0de77d2:	f88d 1006 	strb.w	r1, [sp, #6]
    if (content.type == INFO_LONG_PRESS) {  // last page
c0de77d6:	dc07      	bgt.n	c0de77e8 <displayReviewPage+0x6a>
c0de77d8:	2802      	cmp	r0, #2
c0de77da:	d010      	beq.n	c0de77fe <displayReviewPage+0x80>
c0de77dc:	2804      	cmp	r0, #4
c0de77de:	bf04      	itt	eq
c0de77e0:	2000      	moveq	r0, #0
        content.tagValueList.smallCaseForValue = false;
c0de77e2:	f88d 001d 	strbeq.w	r0, [sp, #29]
c0de77e6:	e01b      	b.n	c0de7820 <displayReviewPage+0xa2>
    if (content.type == INFO_LONG_PRESS) {  // last page
c0de77e8:	2805      	cmp	r0, #5
c0de77ea:	d012      	beq.n	c0de7812 <displayReviewPage+0x94>
c0de77ec:	2806      	cmp	r0, #6
c0de77ee:	d117      	bne.n	c0de7820 <displayReviewPage+0xa2>
c0de77f0:	2000      	movs	r0, #0
        content.tagValueConfirm.tagValueList.smallCaseForValue = false;
c0de77f2:	f88d 001d 	strb.w	r0, [sp, #29]
c0de77f6:	200b      	movs	r0, #11
        content.tagValueConfirm.confirmationToken = CONFIRM_TOKEN;
c0de77f8:	f88d 0038 	strb.w	r0, [sp, #56]	@ 0x38
c0de77fc:	e010      	b.n	c0de7820 <displayReviewPage+0xa2>
        navInfo.nbPages                      = navInfo.activePage + 1;
c0de77fe:	f819 0006 	ldrb.w	r0, [r9, r6]
c0de7802:	eb09 0106 	add.w	r1, r9, r6
c0de7806:	3001      	adds	r0, #1
c0de7808:	7048      	strb	r0, [r1, #1]
c0de780a:	200b      	movs	r0, #11
        content.infoLongPress.longPressToken = CONFIRM_TOKEN;
c0de780c:	f88d 001c 	strb.w	r0, [sp, #28]
c0de7810:	e006      	b.n	c0de7820 <displayReviewPage+0xa2>
c0de7812:	2000      	movs	r0, #0
        content.tagValueDetails.tagValueList.smallCaseForValue = false;
c0de7814:	f88d 001d 	strb.w	r0, [sp, #29]
c0de7818:	f640 1001 	movw	r0, #2305	@ 0x901
        content.tagValueDetails.tagValueList.hideEndOfLastLine  = true;
c0de781c:	f8ad 001a 	strh.w	r0, [sp, #26]
    pageContext = nbgl_pageDrawGenericContent(&pageCallback, &navInfo, &content);
c0de7820:	f64f 007b 	movw	r0, #63611	@ 0xf87b
c0de7824:	f6cf 70ff 	movt	r0, #65535	@ 0xffff
c0de7828:	eb09 0106 	add.w	r1, r9, r6
c0de782c:	4478      	add	r0, pc
c0de782e:	466a      	mov	r2, sp
c0de7830:	f7fe fccc 	bl	c0de61cc <nbgl_pageDrawGenericContent>
c0de7834:	f240 6150 	movw	r1, #1616	@ 0x650
c0de7838:	f2c0 0100 	movt	r1, #0
c0de783c:	f849 0001 	str.w	r0, [r9, r1]
c0de7840:	2001      	movs	r0, #1
c0de7842:	2c00      	cmp	r4, #0
c0de7844:	bf18      	it	ne
c0de7846:	2002      	movne	r0, #2
c0de7848:	f001 f956 	bl	c0de8af8 <nbgl_refreshSpecial>
}
c0de784c:	b010      	add	sp, #64	@ 0x40
c0de784e:	bd70      	pop	{r4, r5, r6, pc}

c0de7850 <genericContextComputeNextPageParams>:
{
c0de7850:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
    int8_t  nextContentIdx = genericContext.currentContentIdx;
c0de7854:	f240 4af0 	movw	sl, #1264	@ 0x4f0
c0de7858:	f2c0 0a00 	movt	sl, #0
    uint8_t pageData = genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de785c:	f240 7740 	movw	r7, #1856	@ 0x740
c0de7860:	4604      	mov	r4, r0
    int8_t  nextContentIdx = genericContext.currentContentIdx;
c0de7862:	eb09 000a 	add.w	r0, r9, sl
    uint8_t pageData = genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de7866:	f2c0 0700 	movt	r7, #0
c0de786a:	4688      	mov	r8, r1
    int8_t  nextContentIdx = genericContext.currentContentIdx;
c0de786c:	f890 b010 	ldrb.w	fp, [r0, #16]
    int16_t nextElementIdx = genericContext.currentElementIdx;
c0de7870:	7c86      	ldrb	r6, [r0, #18]
    uint8_t pageData = genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de7872:	0860      	lsrs	r0, r4, #1
c0de7874:	eb09 0107 	add.w	r1, r9, r7
c0de7878:	5c08      	ldrb	r0, [r1, r0]
c0de787a:	2104      	movs	r1, #4
                       >> ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de787c:	ea01 0184 	and.w	r1, r1, r4, lsl #2
c0de7880:	fa20 f101 	lsr.w	r1, r0, r1
        *nbElements = GET_PAGE_NB_ELEMENTS(pageData);
c0de7884:	f001 0007 	and.w	r0, r1, #7
    if (pageIdx > navInfo.activePage) {
c0de7888:	f240 6c68 	movw	ip, #1640	@ 0x668
    if (flag != NULL) {
c0de788c:	2b00      	cmp	r3, #0
        *flag = GET_PAGE_FLAG(pageData);
c0de788e:	bf1c      	itt	ne
c0de7890:	f3c1 01c0 	ubfxne	r1, r1, #3, #1
c0de7894:	7019      	strbne	r1, [r3, #0]
    *p_nbElementsInNextPage = nbElementsInNextPage;
c0de7896:	7010      	strb	r0, [r2, #0]
    if (pageIdx > navInfo.activePage) {
c0de7898:	f2c0 0c00 	movt	ip, #0
c0de789c:	f819 100c 	ldrb.w	r1, [r9, ip]
c0de78a0:	42a1      	cmp	r1, r4
c0de78a2:	d219      	bcs.n	c0de78d8 <genericContextComputeNextPageParams+0x88>
    uint8_t pageData = genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de78a4:	084a      	lsrs	r2, r1, #1
c0de78a6:	eb09 0307 	add.w	r3, r9, r7
c0de78aa:	5c9a      	ldrb	r2, [r3, r2]
c0de78ac:	2304      	movs	r3, #4
                       >> ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de78ae:	ea03 0381 	and.w	r3, r3, r1, lsl #2
c0de78b2:	40da      	lsrs	r2, r3
        if ((nextElementIdx >= genericContext.currentContentElementNb)
c0de78b4:	eb09 030a 	add.w	r3, r9, sl
c0de78b8:	7c5b      	ldrb	r3, [r3, #17]
        *nbElements = GET_PAGE_NB_ELEMENTS(pageData);
c0de78ba:	f002 0207 	and.w	r2, r2, #7
        nextElementIdx += nbElementsInCurrentPage;
c0de78be:	4416      	add	r6, r2
        if ((nextElementIdx >= genericContext.currentContentElementNb)
c0de78c0:	2b00      	cmp	r3, #0
c0de78c2:	461a      	mov	r2, r3
c0de78c4:	bf18      	it	ne
c0de78c6:	2201      	movne	r2, #1
c0de78c8:	2700      	movs	r7, #0
c0de78ca:	429e      	cmp	r6, r3
c0de78cc:	bf28      	it	cs
c0de78ce:	2701      	movcs	r7, #1
            && (genericContext.currentContentElementNb > 0)) {
c0de78d0:	403a      	ands	r2, r7
c0de78d2:	4493      	add	fp, r2
c0de78d4:	bf18      	it	ne
c0de78d6:	2600      	movne	r6, #0
    if (pageIdx < navInfo.activePage) {
c0de78d8:	42a1      	cmp	r1, r4
c0de78da:	d906      	bls.n	c0de78ea <genericContextComputeNextPageParams+0x9a>
        nextElementIdx -= nbElementsInNextPage;
c0de78dc:	1a36      	subs	r6, r6, r0
        if (nextElementIdx < 0) {
c0de78de:	f1b6 3fff 	cmp.w	r6, #4294967295	@ 0xffffffff
            nextContentIdx -= 1;
c0de78e2:	bfdc      	itt	le
c0de78e4:	f1ab 0b01 	suble.w	fp, fp, #1
            nextElementIdx = -nbElementsInNextPage;
c0de78e8:	4246      	negle	r6, r0
    if ((nextContentIdx == -1) && (genericContext.hasStartingContent)) {
c0de78ea:	fa5f f78b 	uxtb.w	r7, fp
c0de78ee:	f240 5180 	movw	r1, #1408	@ 0x580
c0de78f2:	2fff      	cmp	r7, #255	@ 0xff
c0de78f4:	f2c0 0100 	movt	r1, #0
c0de78f8:	d106      	bne.n	c0de7908 <genericContextComputeNextPageParams+0xb8>
c0de78fa:	eb09 000a 	add.w	r0, r9, sl
c0de78fe:	7cc0      	ldrb	r0, [r0, #19]
c0de7900:	b110      	cbz	r0, c0de7908 <genericContextComputeNextPageParams+0xb8>
c0de7902:	eb09 0501 	add.w	r5, r9, r1
c0de7906:	e027      	b.n	c0de7958 <genericContextComputeNextPageParams+0x108>
    else if ((nextContentIdx == genericContext.genericContents.nbContents)
c0de7908:	eb09 030a 	add.w	r3, r9, sl
c0de790c:	7b1a      	ldrb	r2, [r3, #12]
c0de790e:	fa4f f08b 	sxtb.w	r0, fp
             && (genericContext.hasFinishingContent)) {
c0de7912:	4290      	cmp	r0, r2
c0de7914:	d106      	bne.n	c0de7924 <genericContextComputeNextPageParams+0xd4>
c0de7916:	7d1b      	ldrb	r3, [r3, #20]
c0de7918:	b123      	cbz	r3, c0de7924 <genericContextComputeNextPageParams+0xd4>
c0de791a:	eb09 0001 	add.w	r0, r9, r1
c0de791e:	f100 0538 	add.w	r5, r0, #56	@ 0x38
c0de7922:	e019      	b.n	c0de7958 <genericContextComputeNextPageParams+0x108>
    if (contentIdx < 0 || contentIdx >= genericContents->nbContents) {
c0de7924:	2800      	cmp	r0, #0
c0de7926:	f04f 0500 	mov.w	r5, #0
c0de792a:	d413      	bmi.n	c0de7954 <genericContextComputeNextPageParams+0x104>
c0de792c:	4290      	cmp	r0, r2
c0de792e:	da11      	bge.n	c0de7954 <genericContextComputeNextPageParams+0x104>
    if (genericContents->callbackCallNeeded) {
c0de7930:	eb09 010a 	add.w	r1, r9, sl
c0de7934:	7909      	ldrb	r1, [r1, #4]
c0de7936:	2900      	cmp	r1, #0
c0de7938:	d05a      	beq.n	c0de79f0 <genericContextComputeNextPageParams+0x1a0>
        memset(content, 0, sizeof(nbgl_content_t));
c0de793a:	4640      	mov	r0, r8
c0de793c:	2138      	movs	r1, #56	@ 0x38
c0de793e:	4665      	mov	r5, ip
c0de7940:	f002 fa3c 	bl	c0de9dbc <__aeabi_memclr>
        genericContents->contentGetterCallback(contentIdx, content);
c0de7944:	eb09 000a 	add.w	r0, r9, sl
c0de7948:	6882      	ldr	r2, [r0, #8]
c0de794a:	4638      	mov	r0, r7
c0de794c:	4641      	mov	r1, r8
c0de794e:	4790      	blx	r2
c0de7950:	46ac      	mov	ip, r5
c0de7952:	4645      	mov	r5, r8
        if (p_content == NULL) {
c0de7954:	2d00      	cmp	r5, #0
c0de7956:	d059      	beq.n	c0de7a0c <genericContextComputeNextPageParams+0x1bc>
    if ((nextContentIdx != genericContext.currentContentIdx)
c0de7958:	eb09 000a 	add.w	r0, r9, sl
c0de795c:	7c01      	ldrb	r1, [r0, #16]
        || (genericContext.currentContentElementNb == 0)) {
c0de795e:	428f      	cmp	r7, r1
c0de7960:	d104      	bne.n	c0de796c <genericContextComputeNextPageParams+0x11c>
c0de7962:	7c40      	ldrb	r0, [r0, #17]
c0de7964:	b110      	cbz	r0, c0de796c <genericContextComputeNextPageParams+0x11c>
    if ((nextElementIdx < 0) || (nextElementIdx >= genericContext.currentContentElementNb)) {
c0de7966:	2e00      	cmp	r6, #0
c0de7968:	d535      	bpl.n	c0de79d6 <genericContextComputeNextPageParams+0x186>
c0de796a:	e04f      	b.n	c0de7a0c <genericContextComputeNextPageParams+0x1bc>
    switch (content->type) {
c0de796c:	7828      	ldrb	r0, [r5, #0]
        genericContext.currentContentIdx       = nextContentIdx;
c0de796e:	eb09 010a 	add.w	r1, r9, sl
c0de7972:	f881 b010 	strb.w	fp, [r1, #16]
    switch (content->type) {
c0de7976:	2807      	cmp	r0, #7
c0de7978:	f04f 0101 	mov.w	r1, #1
c0de797c:	4667      	mov	r7, ip
c0de797e:	dc07      	bgt.n	c0de7990 <genericContextComputeNextPageParams+0x140>
c0de7980:	2804      	cmp	r0, #4
c0de7982:	d00d      	beq.n	c0de79a0 <genericContextComputeNextPageParams+0x150>
c0de7984:	2806      	cmp	r0, #6
c0de7986:	d00b      	beq.n	c0de79a0 <genericContextComputeNextPageParams+0x150>
c0de7988:	2807      	cmp	r0, #7
            return content->content.switchesList.nbSwitches;
c0de798a:	bf08      	it	eq
c0de798c:	7a29      	ldrbeq	r1, [r5, #8]
c0de798e:	e00c      	b.n	c0de79aa <genericContextComputeNextPageParams+0x15a>
    switch (content->type) {
c0de7990:	2808      	cmp	r0, #8
c0de7992:	d007      	beq.n	c0de79a4 <genericContextComputeNextPageParams+0x154>
c0de7994:	2809      	cmp	r0, #9
c0de7996:	d007      	beq.n	c0de79a8 <genericContextComputeNextPageParams+0x158>
c0de7998:	280a      	cmp	r0, #10
c0de799a:	bf08      	it	eq
c0de799c:	7b29      	ldrbeq	r1, [r5, #12]
c0de799e:	e004      	b.n	c0de79aa <genericContextComputeNextPageParams+0x15a>
c0de79a0:	7b29      	ldrb	r1, [r5, #12]
c0de79a2:	e002      	b.n	c0de79aa <genericContextComputeNextPageParams+0x15a>
            return content->content.infosList.nbInfos;
c0de79a4:	7c29      	ldrb	r1, [r5, #16]
c0de79a6:	e000      	b.n	c0de79aa <genericContextComputeNextPageParams+0x15a>
            return content->content.choicesList.nbChoices;
c0de79a8:	7a69      	ldrb	r1, [r5, #9]
        onContentAction                        = PIC(p_content->contentActionCallback);
c0de79aa:	6b68      	ldr	r0, [r5, #52]	@ 0x34
        genericContext.currentContentElementNb = getContentNbElement(p_content);
c0de79ac:	eb09 020a 	add.w	r2, r9, sl
c0de79b0:	7451      	strb	r1, [r2, #17]
        onContentAction                        = PIC(p_content->contentActionCallback);
c0de79b2:	f001 ffff 	bl	c0de99b4 <pic>
c0de79b6:	f240 713c 	movw	r1, #1852	@ 0x73c
c0de79ba:	f2c0 0100 	movt	r1, #0
        if (nextElementIdx < 0) {
c0de79be:	f1b6 3fff 	cmp.w	r6, #4294967295	@ 0xffffffff
        onContentAction                        = PIC(p_content->contentActionCallback);
c0de79c2:	f849 0001 	str.w	r0, [r9, r1]
        if (nextElementIdx < 0) {
c0de79c6:	dc03      	bgt.n	c0de79d0 <genericContextComputeNextPageParams+0x180>
            nextElementIdx = genericContext.currentContentElementNb + nextElementIdx;
c0de79c8:	eb09 000a 	add.w	r0, r9, sl
c0de79cc:	7c40      	ldrb	r0, [r0, #17]
c0de79ce:	4406      	add	r6, r0
c0de79d0:	46bc      	mov	ip, r7
    if ((nextElementIdx < 0) || (nextElementIdx >= genericContext.currentContentElementNb)) {
c0de79d2:	2e00      	cmp	r6, #0
c0de79d4:	d41a      	bmi.n	c0de7a0c <genericContextComputeNextPageParams+0x1bc>
c0de79d6:	eb09 000a 	add.w	r0, r9, sl
c0de79da:	7c40      	ldrb	r0, [r0, #17]
c0de79dc:	4286      	cmp	r6, r0
c0de79de:	da15      	bge.n	c0de7a0c <genericContextComputeNextPageParams+0x1bc>
    genericContext.currentElementIdx = nextElementIdx;
c0de79e0:	eb09 000a 	add.w	r0, r9, sl
c0de79e4:	7486      	strb	r6, [r0, #18]
}
c0de79e6:	4628      	mov	r0, r5
    navInfo.activePage               = pageIdx;
c0de79e8:	f809 400c 	strb.w	r4, [r9, ip]
}
c0de79ec:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        return PIC(&genericContents->contentsList[contentIdx]);
c0de79f0:	eb09 010a 	add.w	r1, r9, sl
c0de79f4:	6889      	ldr	r1, [r1, #8]
c0de79f6:	ebc0 00c0 	rsb	r0, r0, r0, lsl #3
c0de79fa:	eb01 00c0 	add.w	r0, r1, r0, lsl #3
c0de79fe:	4665      	mov	r5, ip
c0de7a00:	f001 ffd8 	bl	c0de99b4 <pic>
c0de7a04:	46ac      	mov	ip, r5
c0de7a06:	4605      	mov	r5, r0
        if (p_content == NULL) {
c0de7a08:	2d00      	cmp	r5, #0
c0de7a0a:	d1a5      	bne.n	c0de7958 <genericContextComputeNextPageParams+0x108>
c0de7a0c:	2000      	movs	r0, #0
}
c0de7a0e:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de7a12 <bundleNavStartSettings>:
{
c0de7a12:	b580      	push	{r7, lr}
c0de7a14:	b082      	sub	sp, #8
    nbgl_useCaseGenericSettings(context->appName,
c0de7a16:	f240 6128 	movw	r1, #1576	@ 0x628
c0de7a1a:	f2c0 0100 	movt	r1, #0
c0de7a1e:	f859 0001 	ldr.w	r0, [r9, r1]
c0de7a22:	4449      	add	r1, r9
                                context->settingContents,
c0de7a24:	e9d1 2303 	ldrd	r2, r3, [r1, #12]
    nbgl_useCaseGenericSettings(context->appName,
c0de7a28:	f24f 6c39 	movw	ip, #63033	@ 0xf639
c0de7a2c:	f6cf 7cff 	movt	ip, #65535	@ 0xffff
c0de7a30:	44fc      	add	ip, pc
c0de7a32:	2100      	movs	r1, #0
c0de7a34:	f8cd c000 	str.w	ip, [sp]
c0de7a38:	f7fe fdf4 	bl	c0de6624 <nbgl_useCaseGenericSettings>
}
c0de7a3c:	b002      	add	sp, #8
c0de7a3e:	bd80      	pop	{r7, pc}

c0de7a40 <displayFullValuePage>:
{
c0de7a40:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de7a44:	b09e      	sub	sp, #120	@ 0x78
c0de7a46:	4614      	mov	r4, r2
        = (extension->backText != NULL) ? PIC(extension->backText) : PIC(backText);
c0de7a48:	6912      	ldr	r2, [r2, #16]
c0de7a4a:	4688      	mov	r8, r1
c0de7a4c:	2a00      	cmp	r2, #0
c0de7a4e:	bf18      	it	ne
c0de7a50:	4610      	movne	r0, r2
c0de7a52:	f001 ffaf 	bl	c0de99b4 <pic>
    if (extension->aliasType == INFO_LIST_ALIAS) {
c0de7a56:	7e21      	ldrb	r1, [r4, #24]
c0de7a58:	2905      	cmp	r1, #5
c0de7a5a:	d04b      	beq.n	c0de7af4 <displayFullValuePage+0xb4>
c0de7a5c:	2904      	cmp	r1, #4
c0de7a5e:	f040 80ca 	bne.w	c0de7bf6 <displayFullValuePage+0x1b6>
        genericContext.currentInfos = extension->infolist;
c0de7a62:	f240 42f0 	movw	r2, #1264	@ 0x4f0
c0de7a66:	6961      	ldr	r1, [r4, #20]
c0de7a68:	f2c0 0200 	movt	r2, #0
c0de7a6c:	444a      	add	r2, r9
c0de7a6e:	6351      	str	r1, [r2, #52]	@ 0x34
        displayInfosListModal(modalTitle, extension->infolist, true);
c0de7a70:	6961      	ldr	r1, [r4, #20]
    nbgl_pageNavigationInfo_t info = {.activePage                = 0,
c0de7a72:	f643 22ae 	movw	r2, #15022	@ 0x3aae
c0de7a76:	f2c0 0200 	movt	r2, #0
c0de7a7a:	447a      	add	r2, pc
c0de7a7c:	cae0      	ldmia	r2!, {r5, r6, r7}
c0de7a7e:	ab17      	add	r3, sp, #92	@ 0x5c
c0de7a80:	c3e0      	stmia	r3!, {r5, r6, r7}
c0de7a82:	e892 00f0 	ldmia.w	r2, {r4, r5, r6, r7}
           .infosList.nbInfos        = infos->nbInfos,
c0de7a86:	f10d 0c2c 	add.w	ip, sp, #44	@ 0x2c
    nbgl_pageNavigationInfo_t info = {.activePage                = 0,
c0de7a8a:	c3f0      	stmia	r3!, {r4, r5, r6, r7}
        = {.type                     = INFOS_LIST,
c0de7a8c:	9007      	str	r0, [sp, #28]
c0de7a8e:	f241 4000 	movw	r0, #5120	@ 0x1400
c0de7a92:	f2c0 0009 	movt	r0, #9
c0de7a96:	9008      	str	r0, [sp, #32]
c0de7a98:	2000      	movs	r0, #0
c0de7a9a:	9009      	str	r0, [sp, #36]	@ 0x24
c0de7a9c:	2008      	movs	r0, #8
c0de7a9e:	f88d 0028 	strb.w	r0, [sp, #40]	@ 0x28
           .infosList.infoTypes      = infos->infoTypes,
c0de7aa2:	e891 000d 	ldmia.w	r1, {r0, r2, r3}
    if (modalPageContext != NULL) {
c0de7aa6:	f240 645c 	movw	r4, #1628	@ 0x65c
           .infosList.nbInfos        = infos->nbInfos,
c0de7aaa:	e88c 000d 	stmia.w	ip, {r0, r2, r3}
c0de7aae:	7b08      	ldrb	r0, [r1, #12]
    if (modalPageContext != NULL) {
c0de7ab0:	f2c0 0400 	movt	r4, #0
           .infosList.nbInfos        = infos->nbInfos,
c0de7ab4:	f88d 0038 	strb.w	r0, [sp, #56]	@ 0x38
c0de7ab8:	200e      	movs	r0, #14
c0de7aba:	f88d 0039 	strb.w	r0, [sp, #57]	@ 0x39
    if (modalPageContext != NULL) {
c0de7abe:	f859 0004 	ldr.w	r0, [r9, r4]
           .infosList.withExtensions = infos->withExtensions,
c0de7ac2:	7b89      	ldrb	r1, [r1, #14]
    if (modalPageContext != NULL) {
c0de7ac4:	2800      	cmp	r0, #0
           .infosList.nbInfos        = infos->nbInfos,
c0de7ac6:	f88d 103a 	strb.w	r1, [sp, #58]	@ 0x3a
        nbgl_pageRelease(modalPageContext);
c0de7aca:	bf18      	it	ne
c0de7acc:	f7fe fb83 	blne	c0de61d6 <nbgl_pageRelease>
    modalPageContext = nbgl_pageDrawGenericContentExt(&pageModalCallback, &info, &content, true);
c0de7ad0:	f64f 30a1 	movw	r0, #64417	@ 0xfba1
c0de7ad4:	f6cf 70ff 	movt	r0, #65535	@ 0xffff
c0de7ad8:	4478      	add	r0, pc
c0de7ada:	a917      	add	r1, sp, #92	@ 0x5c
c0de7adc:	aa07      	add	r2, sp, #28
c0de7ade:	2301      	movs	r3, #1
c0de7ae0:	f7fe f8d6 	bl	c0de5c90 <nbgl_pageDrawGenericContentExt>
c0de7ae4:	f849 0004 	str.w	r0, [r9, r4]
    nbgl_refreshSpecial(FULL_COLOR_CLEAN_REFRESH);
c0de7ae8:	2002      	movs	r0, #2
c0de7aea:	f001 f805 	bl	c0de8af8 <nbgl_refreshSpecial>
}
c0de7aee:	b01e      	add	sp, #120	@ 0x78
c0de7af0:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        genericContext.currentTagValues = extension->tagValuelist;
c0de7af4:	f240 41f0 	movw	r1, #1264	@ 0x4f0
c0de7af8:	6960      	ldr	r0, [r4, #20]
c0de7afa:	f2c0 0100 	movt	r1, #0
c0de7afe:	4449      	add	r1, r9
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de7b00:	f640 0240 	movw	r2, #2112	@ 0x840
        genericContext.currentTagValues = extension->tagValuelist;
c0de7b04:	6388      	str	r0, [r1, #56]	@ 0x38
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de7b06:	f2c0 0200 	movt	r2, #0
        displayTagValueListModal(extension->tagValuelist);
c0de7b0a:	6965      	ldr	r5, [r4, #20]
c0de7b0c:	2300      	movs	r3, #0
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de7b0e:	eb09 0102 	add.w	r1, r9, r2
c0de7b12:	e9c1 3302 	strd	r3, r3, [r1, #8]
    nbElements = tagValues->nbPairs;
c0de7b16:	7a28      	ldrb	r0, [r5, #8]
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de7b18:	604b      	str	r3, [r1, #4]
    while (nbElements > 0) {
c0de7b1a:	2800      	cmp	r0, #0
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de7b1c:	f849 3002 	str.w	r3, [r9, r2]
    while (nbElements > 0) {
c0de7b20:	f000 80a3 	beq.w	c0de7c6a <displayFullValuePage+0x22a>
c0de7b24:	2600      	movs	r6, #0
c0de7b26:	e028      	b.n	c0de7b7a <displayFullValuePage+0x13a>
c0de7b28:	9801      	ldr	r0, [sp, #4]
c0de7b2a:	4632      	mov	r2, r6
c0de7b2c:	4680      	mov	r8, r0
c0de7b2e:	f640 0e40 	movw	lr, #2112	@ 0x840
c0de7b32:	f2c0 0e00 	movt	lr, #0
        modalContextSetPageInfo(detailsContext.nbPages, nbElementsInPage);
c0de7b36:	f819 100e 	ldrb.w	r1, [r9, lr]
    modalContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de7b3a:	f640 0760 	movw	r7, #2144	@ 0x860
c0de7b3e:	4616      	mov	r6, r2
c0de7b40:	f2c0 0700 	movt	r7, #0
        elemIdx += nbElementsInPage;
c0de7b44:	eb08 0602 	add.w	r6, r8, r2
        &= ~(0x0F << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS));
c0de7b48:	2204      	movs	r2, #4
    modalContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de7b4a:	084b      	lsrs	r3, r1, #1
c0de7b4c:	444f      	add	r7, r9
        &= ~(0x0F << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS));
c0de7b4e:	ea02 0281 	and.w	r2, r2, r1, lsl #2
c0de7b52:	f817 c003 	ldrb.w	ip, [r7, r3]
c0de7b56:	240f      	movs	r4, #15
c0de7b58:	4094      	lsls	r4, r2
c0de7b5a:	ea2c 0c04 	bic.w	ip, ip, r4
        |= pageData << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de7b5e:	f008 0407 	and.w	r4, r8, #7
c0de7b62:	fa04 f202 	lsl.w	r2, r4, r2
c0de7b66:	ea42 020c 	orr.w	r2, r2, ip
        nbElements -= nbElementsInPage;
c0de7b6a:	eba0 0008 	sub.w	r0, r0, r8
        |= pageData << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de7b6e:	54fa      	strb	r2, [r7, r3]
        detailsContext.nbPages++;
c0de7b70:	1c4a      	adds	r2, r1, #1
    while (nbElements > 0) {
c0de7b72:	0601      	lsls	r1, r0, #24
        detailsContext.nbPages++;
c0de7b74:	f809 200e 	strb.w	r2, [r9, lr]
    while (nbElements > 0) {
c0de7b78:	d077      	beq.n	c0de7c6a <displayFullValuePage+0x22a>
c0de7b7a:	b2f1      	uxtb	r1, r6
    while (nbPairsInPage < nbPairs) {
c0de7b7c:	fa5f fb80 	uxtb.w	fp, r0
c0de7b80:	ea4f 1801 	mov.w	r8, r1, lsl #4
c0de7b84:	f04f 0a00 	mov.w	sl, #0
c0de7b88:	2700      	movs	r7, #0
c0de7b8a:	9001      	str	r0, [sp, #4]
c0de7b8c:	e01e      	b.n	c0de7bcc <displayFullValuePage+0x18c>
c0de7b8e:	bf00      	nop
            pair = PIC(&tagValueList->pairs[startIndex + nbPairsInPage]);
c0de7b90:	4440      	add	r0, r8
c0de7b92:	f001 ff0f 	bl	c0de99b4 <pic>
            SMALL_REGULAR_FONT, pair->item, AVAILABLE_WIDTH, tagValueList->wrapping);
c0de7b96:	6801      	ldr	r1, [r0, #0]
c0de7b98:	7bab      	ldrb	r3, [r5, #14]
c0de7b9a:	4604      	mov	r4, r0
        currentHeight += nbgl_getTextHeightInWidth(
c0de7b9c:	200b      	movs	r0, #11
c0de7b9e:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de7ba2:	f000 fff9 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
            SMALL_REGULAR_FONT, pair->value, AVAILABLE_WIDTH, tagValueList->wrapping);
c0de7ba6:	6861      	ldr	r1, [r4, #4]
c0de7ba8:	7bab      	ldrb	r3, [r5, #14]
        currentHeight += nbgl_getTextHeightInWidth(
c0de7baa:	4604      	mov	r4, r0
        currentHeight += nbgl_getTextHeightInWidth(
c0de7bac:	200b      	movs	r0, #11
c0de7bae:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de7bb2:	f000 fff1 	bl	c0de8b98 <nbgl_getTextHeightInWidth>
        currentHeight += nbgl_getTextHeightInWidth(
c0de7bb6:	1939      	adds	r1, r7, r4
        currentHeight += 4;
c0de7bb8:	4408      	add	r0, r1
        currentHeight += nbgl_getTextHeightInWidth(
c0de7bba:	1d07      	adds	r7, r0, #4
c0de7bbc:	b2b8      	uxth	r0, r7
        if (currentHeight >= maxUsableHeight) {
c0de7bbe:	f10a 0a01 	add.w	sl, sl, #1
c0de7bc2:	f5b0 7fe8 	cmp.w	r0, #464	@ 0x1d0
c0de7bc6:	f108 0810 	add.w	r8, r8, #16
c0de7bca:	d20f      	bcs.n	c0de7bec <displayFullValuePage+0x1ac>
    while (nbPairsInPage < nbPairs) {
c0de7bcc:	45d3      	cmp	fp, sl
c0de7bce:	d0ab      	beq.n	c0de7b28 <displayFullValuePage+0xe8>
        if (tagValueList->pairs != NULL) {
c0de7bd0:	6828      	ldr	r0, [r5, #0]
        if (nbPairsInPage > 0) {
c0de7bd2:	f1ba 0f00 	cmp.w	sl, #0
c0de7bd6:	bf18      	it	ne
c0de7bd8:	3718      	addne	r7, #24
        if (tagValueList->pairs != NULL) {
c0de7bda:	2800      	cmp	r0, #0
c0de7bdc:	d1d8      	bne.n	c0de7b90 <displayFullValuePage+0x150>
            pair = PIC(tagValueList->callback(startIndex + nbPairsInPage));
c0de7bde:	6869      	ldr	r1, [r5, #4]
c0de7be0:	eb06 000a 	add.w	r0, r6, sl
c0de7be4:	b2c0      	uxtb	r0, r0
c0de7be6:	4788      	blx	r1
c0de7be8:	e7d3      	b.n	c0de7b92 <displayFullValuePage+0x152>
c0de7bea:	bf00      	nop
c0de7bec:	9801      	ldr	r0, [sp, #4]
c0de7bee:	4632      	mov	r2, r6
        if (currentHeight >= maxUsableHeight) {
c0de7bf0:	f1aa 0801 	sub.w	r8, sl, #1
c0de7bf4:	e79b      	b.n	c0de7b2e <displayFullValuePage+0xee>
        nbgl_layoutDescription_t layoutDescription = {.modal            = true,
c0de7bf6:	f643 02b2 	movw	r2, #14514	@ 0x38b2
c0de7bfa:	f2c0 0200 	movt	r2, #0
c0de7bfe:	447a      	add	r2, pc
c0de7c00:	f10d 0c1c 	add.w	ip, sp, #28
c0de7c04:	cae0      	ldmia	r2!, {r5, r6, r7}
c0de7c06:	4663      	mov	r3, ip
c0de7c08:	c3e0      	stmia	r3!, {r5, r6, r7}
c0de7c0a:	e892 00e2 	ldmia.w	r2, {r1, r5, r6, r7}
c0de7c0e:	c3e2      	stmia	r3!, {r1, r5, r6, r7}
c0de7c10:	2700      	movs	r7, #0
                                                      .backAndText.token  = 0,
c0de7c12:	e9cd 7003 	strd	r7, r0, [sp, #12]
c0de7c16:	f44f 6010 	mov.w	r0, #2304	@ 0x900
c0de7c1a:	2101      	movs	r1, #1
c0de7c1c:	f8ad 0014 	strh.w	r0, [sp, #20]
        genericContext.modalLayout                 = nbgl_layoutGet(&layoutDescription);
c0de7c20:	4660      	mov	r0, ip
        nbgl_layoutHeader_t      headerDesc        = {.type               = HEADER_BACK_AND_TEXT,
c0de7c22:	f8ad 1008 	strh.w	r1, [sp, #8]
        genericContext.modalLayout                 = nbgl_layoutGet(&layoutDescription);
c0de7c26:	f7f9 fb0b 	bl	c0de1240 <nbgl_layoutGet>
c0de7c2a:	f240 46f0 	movw	r6, #1264	@ 0x4f0
c0de7c2e:	f2c0 0600 	movt	r6, #0
c0de7c32:	eb09 0106 	add.w	r1, r9, r6
c0de7c36:	62c8      	str	r0, [r1, #44]	@ 0x2c
c0de7c38:	a902      	add	r1, sp, #8
        nbgl_layoutAddHeader(genericContext.modalLayout, &headerDesc);
c0de7c3a:	f7fc ff81 	bl	c0de4b40 <nbgl_layoutAddHeader>
        if (extension->aliasType == QR_CODE_ALIAS) {
c0de7c3e:	7e20      	ldrb	r0, [r4, #24]
c0de7c40:	2803      	cmp	r0, #3
c0de7c42:	d119      	bne.n	c0de7c78 <displayFullValuePage+0x238>
                = {.url      = extension->fullValue,
c0de7c44:	6820      	ldr	r0, [r4, #0]
                   .text2    = extension->explanation,
c0de7c46:	e9d4 1202 	ldrd	r1, r2, [r4, #8]
                = {.url      = extension->fullValue,
c0de7c4a:	9017      	str	r0, [sp, #92]	@ 0x5c
                   .text1    = (extension->title != NULL) ? extension->title : extension->fullValue,
c0de7c4c:	2a00      	cmp	r2, #0
c0de7c4e:	bf08      	it	eq
c0de7c50:	4602      	moveq	r2, r0
            nbgl_layoutAddQRCode(genericContext.modalLayout, &qrCode);
c0de7c52:	eb09 0006 	add.w	r0, r9, r6
                = {.url      = extension->fullValue,
c0de7c56:	e9cd 2118 	strd	r2, r1, [sp, #96]	@ 0x60
c0de7c5a:	f44f 3180 	mov.w	r1, #65536	@ 0x10000
            nbgl_layoutAddQRCode(genericContext.modalLayout, &qrCode);
c0de7c5e:	6ac0      	ldr	r0, [r0, #44]	@ 0x2c
                = {.url      = extension->fullValue,
c0de7c60:	911a      	str	r1, [sp, #104]	@ 0x68
c0de7c62:	a917      	add	r1, sp, #92	@ 0x5c
            nbgl_layoutAddQRCode(genericContext.modalLayout, &qrCode);
c0de7c64:	f7fc f9a1 	bl	c0de3faa <nbgl_layoutAddQRCode>
c0de7c68:	e040      	b.n	c0de7cec <displayFullValuePage+0x2ac>
    displayTagValueListModalPage(0, true);
c0de7c6a:	2000      	movs	r0, #0
c0de7c6c:	2101      	movs	r1, #1
c0de7c6e:	f000 fbc9 	bl	c0de8404 <displayTagValueListModalPage>
}
c0de7c72:	b01e      	add	sp, #120	@ 0x78
c0de7c74:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            if (extension->aliasType == ENS_ALIAS) {
c0de7c78:	2802      	cmp	r0, #2
            nbgl_layoutTextContent_t content = {0};
c0de7c7a:	971c      	str	r7, [sp, #112]	@ 0x70
c0de7c7c:	e9cd 771a 	strd	r7, r7, [sp, #104]	@ 0x68
c0de7c80:	e9cd 7718 	strd	r7, r7, [sp, #96]	@ 0x60
            content.title                    = aliasText;
c0de7c84:	f8cd 805c 	str.w	r8, [sp, #92]	@ 0x5c
            if (extension->aliasType == ENS_ALIAS) {
c0de7c88:	d007      	beq.n	c0de7c9a <displayFullValuePage+0x25a>
c0de7c8a:	2801      	cmp	r0, #1
c0de7c8c:	d111      	bne.n	c0de7cb2 <displayFullValuePage+0x272>
                content.info = "ENS names are resolved by Ledger backend.";
c0de7c8e:	f243 11b3 	movw	r1, #12723	@ 0x31b3
c0de7c92:	f2c0 0100 	movt	r1, #0
c0de7c96:	4479      	add	r1, pc
c0de7c98:	e00c      	b.n	c0de7cb4 <displayFullValuePage+0x274>
                if (extension->aliasSubName != NULL) {
c0de7c9a:	6861      	ldr	r1, [r4, #4]
c0de7c9c:	b159      	cbz	r1, c0de7cb6 <displayFullValuePage+0x276>
                    content.descriptions[content.nbDescriptions] = extension->aliasSubName;
c0de7c9e:	f89d 2070 	ldrb.w	r2, [sp, #112]	@ 0x70
c0de7ca2:	ab17      	add	r3, sp, #92	@ 0x5c
c0de7ca4:	eb03 0382 	add.w	r3, r3, r2, lsl #2
c0de7ca8:	6099      	str	r1, [r3, #8]
                    content.nbDescriptions++;
c0de7caa:	1c51      	adds	r1, r2, #1
c0de7cac:	f88d 1070 	strb.w	r1, [sp, #112]	@ 0x70
c0de7cb0:	e001      	b.n	c0de7cb6 <displayFullValuePage+0x276>
                content.info = extension->explanation;
c0de7cb2:	68a1      	ldr	r1, [r4, #8]
c0de7cb4:	9118      	str	r1, [sp, #96]	@ 0x60
            content.descriptions[content.nbDescriptions] = extension->fullValue;
c0de7cb6:	f89d 1070 	ldrb.w	r1, [sp, #112]	@ 0x70
c0de7cba:	6823      	ldr	r3, [r4, #0]
c0de7cbc:	aa17      	add	r2, sp, #92	@ 0x5c
c0de7cbe:	eb02 0781 	add.w	r7, r2, r1, lsl #2
c0de7cc2:	60bb      	str	r3, [r7, #8]
            content.nbDescriptions++;
c0de7cc4:	1c4b      	adds	r3, r1, #1
            if ((extension->aliasType == ADDRESS_BOOK_ALIAS) && (extension->explanation != NULL)) {
c0de7cc6:	2802      	cmp	r0, #2
            content.nbDescriptions++;
c0de7cc8:	f88d 3070 	strb.w	r3, [sp, #112]	@ 0x70
            if ((extension->aliasType == ADDRESS_BOOK_ALIAS) && (extension->explanation != NULL)) {
c0de7ccc:	d108      	bne.n	c0de7ce0 <displayFullValuePage+0x2a0>
c0de7cce:	68a0      	ldr	r0, [r4, #8]
c0de7cd0:	b130      	cbz	r0, c0de7ce0 <displayFullValuePage+0x2a0>
                content.descriptions[content.nbDescriptions] = extension->explanation;
c0de7cd2:	b2db      	uxtb	r3, r3
c0de7cd4:	eb02 0283 	add.w	r2, r2, r3, lsl #2
c0de7cd8:	6090      	str	r0, [r2, #8]
                content.nbDescriptions++;
c0de7cda:	1c88      	adds	r0, r1, #2
c0de7cdc:	f88d 0070 	strb.w	r0, [sp, #112]	@ 0x70
            nbgl_layoutAddTextContent(genericContext.modalLayout, &content);
c0de7ce0:	eb09 0006 	add.w	r0, r9, r6
c0de7ce4:	6ac0      	ldr	r0, [r0, #44]	@ 0x2c
c0de7ce6:	a917      	add	r1, sp, #92	@ 0x5c
c0de7ce8:	f7fb fba2 	bl	c0de3430 <nbgl_layoutAddTextContent>
        nbgl_layoutDraw(genericContext.modalLayout);
c0de7cec:	eb09 0006 	add.w	r0, r9, r6
c0de7cf0:	6ac0      	ldr	r0, [r0, #44]	@ 0x2c
c0de7cf2:	f7fd fb6b 	bl	c0de53cc <nbgl_layoutDraw>
        nbgl_refresh();
c0de7cf6:	f000 fefa 	bl	c0de8aee <nbgl_refresh>
}
c0de7cfa:	b01e      	add	sp, #120	@ 0x78
c0de7cfc:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de7d00 <displaySecurityReport>:
{
c0de7d00:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de7d04:	b09c      	sub	sp, #112	@ 0x70
    nbgl_layoutDescription_t layoutDescription = {.modal            = true,
c0de7d06:	f243 72a2 	movw	r2, #14242	@ 0x37a2
c0de7d0a:	f2c0 0200 	movt	r2, #0
c0de7d0e:	447a      	add	r2, pc
c0de7d10:	a915      	add	r1, sp, #84	@ 0x54
c0de7d12:	cae0      	ldmia	r2!, {r5, r6, r7}
c0de7d14:	460b      	mov	r3, r1
c0de7d16:	c3e0      	stmia	r3!, {r5, r6, r7}
c0de7d18:	4680      	mov	r8, r0
c0de7d1a:	e892 00d1 	ldmia.w	r2, {r0, r4, r6, r7}
c0de7d1e:	aa10      	add	r2, sp, #64	@ 0x40
c0de7d20:	c3d1      	stmia	r3!, {r0, r4, r6, r7}
    nbgl_layoutHeader_t      headerDesc        = {.type               = HEADER_BACK_AND_TEXT,
c0de7d22:	f243 70a2 	movw	r0, #14242	@ 0x37a2
c0de7d26:	f2c0 0000 	movt	r0, #0
c0de7d2a:	4478      	add	r0, pc
c0de7d2c:	e890 00f8 	ldmia.w	r0, {r3, r4, r5, r6, r7}
c0de7d30:	2000      	movs	r0, #0
c0de7d32:	c2f8      	stmia	r2!, {r3, r4, r5, r6, r7}
    nbgl_layoutFooter_t      footerDesc
c0de7d34:	e9cd 000e 	strd	r0, r0, [sp, #56]	@ 0x38
c0de7d38:	e9cd 000c 	strd	r0, r0, [sp, #48]	@ 0x30
c0de7d3c:	e9cd 000a 	strd	r0, r0, [sp, #40]	@ 0x28
    reviewWithWarnCtx.modalLayout = nbgl_layoutGet(&layoutDescription);
c0de7d40:	4608      	mov	r0, r1
c0de7d42:	f7f9 fa7d 	bl	c0de1240 <nbgl_layoutGet>
c0de7d46:	f240 47f0 	movw	r7, #1264	@ 0x4f0
c0de7d4a:	f2c0 0700 	movt	r7, #0
c0de7d4e:	eb09 0107 	add.w	r1, r9, r7
    if ((reviewWithWarnCtx.securityReportLevel == 1) && (!reviewWithWarnCtx.isIntro)) {
c0de7d52:	f891 2088 	ldrb.w	r2, [r1, #136]	@ 0x88
    reviewWithWarnCtx.modalLayout = nbgl_layoutGet(&layoutDescription);
c0de7d56:	4604      	mov	r4, r0
    if ((reviewWithWarnCtx.securityReportLevel == 1) && (!reviewWithWarnCtx.isIntro)) {
c0de7d58:	2a01      	cmp	r2, #1
    reviewWithWarnCtx.modalLayout = nbgl_layoutGet(&layoutDescription);
c0de7d5a:	f8c1 0084 	str.w	r0, [r1, #132]	@ 0x84
    if ((reviewWithWarnCtx.securityReportLevel == 1) && (!reviewWithWarnCtx.isIntro)) {
c0de7d5e:	d15f      	bne.n	c0de7e20 <displaySecurityReport+0x120>
c0de7d60:	f891 0089 	ldrb.w	r0, [r1, #137]	@ 0x89
c0de7d64:	2800      	cmp	r0, #0
c0de7d66:	d15b      	bne.n	c0de7e20 <displaySecurityReport+0x120>
c0de7d68:	f243 766e 	movw	r6, #14190	@ 0x376e
c0de7d6c:	f2c0 0600 	movt	r6, #0
c0de7d70:	2500      	movs	r5, #0
c0de7d72:	447e      	add	r6, pc
c0de7d74:	ac01      	add	r4, sp, #4
c0de7d76:	f04f 0a00 	mov.w	sl, #0
c0de7d7a:	f04f 0b00 	mov.w	fp, #0
c0de7d7e:	e017      	b.n	c0de7db0 <displaySecurityReport+0xb0>
                    bar.token = NBGL_INVALID_TOKEN;
c0de7d80:	20ff      	movs	r0, #255	@ 0xff
c0de7d82:	f88d 0015 	strb.w	r0, [sp, #21]
                bar.iconLeft = securityReportItems[i].icon;
c0de7d86:	f856 100a 	ldr.w	r1, [r6, sl]
                nbgl_layoutAddTouchableBar(reviewWithWarnCtx.modalLayout, &bar);
c0de7d8a:	eb09 0807 	add.w	r8, r9, r7
c0de7d8e:	f8d8 0084 	ldr.w	r0, [r8, #132]	@ 0x84
                bar.iconLeft = securityReportItems[i].icon;
c0de7d92:	9101      	str	r1, [sp, #4]
                nbgl_layoutAddTouchableBar(reviewWithWarnCtx.modalLayout, &bar);
c0de7d94:	4621      	mov	r1, r4
c0de7d96:	f7fa fff3 	bl	c0de2d80 <nbgl_layoutAddTouchableBar>
                nbgl_layoutAddSeparationLine(reviewWithWarnCtx.modalLayout);
c0de7d9a:	f8d8 0084 	ldr.w	r0, [r8, #132]	@ 0x84
c0de7d9e:	f7fc fd3e 	bl	c0de481e <nbgl_layoutAddSeparationLine>
        for (i = 0; i < NB_WARNING_TYPES; i++) {
c0de7da2:	f10a 0a0c 	add.w	sl, sl, #12
c0de7da6:	f1ba 0f48 	cmp.w	sl, #72	@ 0x48
c0de7daa:	f10b 0b01 	add.w	fp, fp, #1
c0de7dae:	d07b      	beq.n	c0de7ea8 <displaySecurityReport+0x1a8>
                && (reviewWithWarnCtx.warning->predefinedSet & (1 << i))) {
c0de7db0:	f1ba 0f3c 	cmp.w	sl, #60	@ 0x3c
c0de7db4:	d0f5      	beq.n	c0de7da2 <displaySecurityReport+0xa2>
c0de7db6:	eb09 0007 	add.w	r0, r9, r7
c0de7dba:	6f80      	ldr	r0, [r0, #120]	@ 0x78
c0de7dbc:	6801      	ldr	r1, [r0, #0]
            if ((i != GATED_SIGNING_WARN)
c0de7dbe:	fa21 f10b 	lsr.w	r1, r1, fp
c0de7dc2:	07c9      	lsls	r1, r1, #31
c0de7dc4:	d0ed      	beq.n	c0de7da2 <displaySecurityReport+0xa2>
                if ((i == BLIND_SIGNING_WARN) || (i == W3C_NO_THREAT_WARN) || (i == W3C_ISSUE_WARN)
c0de7dc6:	fa5f f18b 	uxtb.w	r1, fp
c0de7dca:	2904      	cmp	r1, #4
                nbgl_layoutBar_t bar = {0};
c0de7dcc:	9506      	str	r5, [sp, #24]
c0de7dce:	e9cd 5504 	strd	r5, r5, [sp, #16]
c0de7dd2:	e9cd 5502 	strd	r5, r5, [sp, #8]
c0de7dd6:	9501      	str	r5, [sp, #4]
                if ((i == BLIND_SIGNING_WARN) || (i == W3C_NO_THREAT_WARN) || (i == W3C_ISSUE_WARN)
c0de7dd8:	d81e      	bhi.n	c0de7e18 <displaySecurityReport+0x118>
c0de7dda:	2201      	movs	r2, #1
c0de7ddc:	fa02 f101 	lsl.w	r1, r2, r1
c0de7de0:	f011 0f19 	tst.w	r1, #25
c0de7de4:	d018      	beq.n	c0de7e18 <displaySecurityReport+0x118>
                    bar.subText = securityReportItems[i].subText;
c0de7de6:	eb06 000a 	add.w	r0, r6, sl
c0de7dea:	6880      	ldr	r0, [r0, #8]
c0de7dec:	9004      	str	r0, [sp, #16]
                bar.text = securityReportItems[i].text;
c0de7dee:	eb06 000a 	add.w	r0, r6, sl
c0de7df2:	6840      	ldr	r0, [r0, #4]
                if (i != W3C_NO_THREAT_WARN) {
c0de7df4:	f1ba 0f24 	cmp.w	sl, #36	@ 0x24
                bar.text = securityReportItems[i].text;
c0de7df8:	9002      	str	r0, [sp, #8]
                if (i != W3C_NO_THREAT_WARN) {
c0de7dfa:	d0c1      	beq.n	c0de7d80 <displaySecurityReport+0x80>
                    bar.iconRight = &PUSH_ICON;
c0de7dfc:	f242 7092 	movw	r0, #10130	@ 0x2792
c0de7e00:	f2c0 0000 	movt	r0, #0
c0de7e04:	4478      	add	r0, pc
c0de7e06:	9003      	str	r0, [sp, #12]
                    bar.token     = FIRST_WARN_BAR_TOKEN + i;
c0de7e08:	f10b 001c 	add.w	r0, fp, #28
c0de7e0c:	f88d 0015 	strb.w	r0, [sp, #21]
                    bar.tuneId    = TUNE_TAP_CASUAL;
c0de7e10:	2009      	movs	r0, #9
c0de7e12:	f88d 0018 	strb.w	r0, [sp, #24]
c0de7e16:	e7b6      	b.n	c0de7d86 <displaySecurityReport+0x86>
                    || (reviewWithWarnCtx.warning->providerMessage == NULL)) {
c0de7e18:	6900      	ldr	r0, [r0, #16]
                if ((i == BLIND_SIGNING_WARN) || (i == W3C_NO_THREAT_WARN) || (i == W3C_ISSUE_WARN)
c0de7e1a:	2800      	cmp	r0, #0
c0de7e1c:	d1e6      	bne.n	c0de7dec <displaySecurityReport+0xec>
c0de7e1e:	e7e2      	b.n	c0de7de6 <displaySecurityReport+0xe6>
    if (reviewWithWarnCtx.warning && reviewWithWarnCtx.warning->reportProvider) {
c0de7e20:	eb09 0007 	add.w	r0, r9, r7
c0de7e24:	6f80      	ldr	r0, [r0, #120]	@ 0x78
c0de7e26:	2800      	cmp	r0, #0
c0de7e28:	d04c      	beq.n	c0de7ec4 <displaySecurityReport+0x1c4>
c0de7e2a:	68c6      	ldr	r6, [r0, #12]
c0de7e2c:	2e00      	cmp	r6, #0
c0de7e2e:	d049      	beq.n	c0de7ec4 <displaySecurityReport+0x1c4>
    if ((set & (1 << W3C_THREAT_DETECTED_WARN)) || (set & (1 << W3C_RISK_DETECTED_WARN))) {
c0de7e30:	f018 0f06 	tst.w	r8, #6
c0de7e34:	d04e      	beq.n	c0de7ed4 <displaySecurityReport+0x1d4>
        nbgl_layoutQRCode_t qrCode = {.url      = destStr,
c0de7e36:	f240 61bc 	movw	r1, #1724	@ 0x6bc
c0de7e3a:	f2c0 0100 	movt	r1, #0
c0de7e3e:	4449      	add	r1, r9
                                      .text1    = reviewWithWarnCtx.warning->reportUrl,
c0de7e40:	6883      	ldr	r3, [r0, #8]
        nbgl_layoutQRCode_t qrCode = {.url      = destStr,
c0de7e42:	f101 0440 	add.w	r4, r1, #64	@ 0x40
c0de7e46:	e9cd 4301 	strd	r4, r3, [sp, #4]
c0de7e4a:	f243 0086 	movw	r0, #12422	@ 0x3086
c0de7e4e:	f2c0 0000 	movt	r0, #0
c0de7e52:	4478      	add	r0, pc
c0de7e54:	9003      	str	r0, [sp, #12]
c0de7e56:	f44f 3080 	mov.w	r0, #65536	@ 0x10000
c0de7e5a:	9004      	str	r0, [sp, #16]
        snprintf(destStr,
c0de7e5c:	f642 7288 	movw	r2, #12168	@ 0x2f88
c0de7e60:	f2c0 0200 	movt	r2, #0
c0de7e64:	447a      	add	r2, pc
c0de7e66:	4620      	mov	r0, r4
c0de7e68:	2140      	movs	r1, #64	@ 0x40
c0de7e6a:	f001 fd29 	bl	c0de98c0 <snprintf>
        urlLen = strlen(destStr) + 1;
c0de7e6e:	4620      	mov	r0, r4
c0de7e70:	f002 f806 	bl	c0de9e80 <strlen>
c0de7e74:	4605      	mov	r5, r0
        nbgl_layoutAddQRCode(reviewWithWarnCtx.modalLayout, &qrCode);
c0de7e76:	eb09 0007 	add.w	r0, r9, r7
c0de7e7a:	f8d0 0084 	ldr.w	r0, [r0, #132]	@ 0x84
c0de7e7e:	a901      	add	r1, sp, #4
        urlLen = strlen(destStr) + 1;
c0de7e80:	442c      	add	r4, r5
        nbgl_layoutAddQRCode(reviewWithWarnCtx.modalLayout, &qrCode);
c0de7e82:	f7fc f892 	bl	c0de3faa <nbgl_layoutAddQRCode>
c0de7e86:	2018      	movs	r0, #24
        footerDesc.emptySpace.height = 24;
c0de7e88:	f8ad 002c 	strh.w	r0, [sp, #44]	@ 0x2c
        snprintf(destStr + urlLen, W3C_DESCRIPTION_MAX_LEN / 2 - urlLen, "%s report", provider);
c0de7e8c:	f243 020d 	movw	r2, #12301	@ 0x300d
c0de7e90:	3401      	adds	r4, #1
c0de7e92:	f2c0 0200 	movt	r2, #0
c0de7e96:	f1c5 013f 	rsb	r1, r5, #63	@ 0x3f
c0de7e9a:	447a      	add	r2, pc
c0de7e9c:	4620      	mov	r0, r4
c0de7e9e:	4633      	mov	r3, r6
c0de7ea0:	f001 fd0e 	bl	c0de98c0 <snprintf>
        headerDesc.backAndText.text = destStr + urlLen;
c0de7ea4:	9412      	str	r4, [sp, #72]	@ 0x48
c0de7ea6:	e053      	b.n	c0de7f50 <displaySecurityReport+0x250>
        headerDesc.backAndText.text = "Security report";
c0de7ea8:	f642 71bf 	movw	r1, #12223	@ 0x2fbf
c0de7eac:	f2c0 0100 	movt	r1, #0
        nbgl_layoutAddHeader(reviewWithWarnCtx.modalLayout, &headerDesc);
c0de7eb0:	eb09 0007 	add.w	r0, r9, r7
        headerDesc.backAndText.text = "Security report";
c0de7eb4:	4479      	add	r1, pc
        nbgl_layoutAddHeader(reviewWithWarnCtx.modalLayout, &headerDesc);
c0de7eb6:	f8d0 0084 	ldr.w	r0, [r0, #132]	@ 0x84
        headerDesc.backAndText.text = "Security report";
c0de7eba:	9112      	str	r1, [sp, #72]	@ 0x48
c0de7ebc:	a910      	add	r1, sp, #64	@ 0x40
        nbgl_layoutAddHeader(reviewWithWarnCtx.modalLayout, &headerDesc);
c0de7ebe:	f7fc fe3f 	bl	c0de4b40 <nbgl_layoutAddHeader>
c0de7ec2:	e056      	b.n	c0de7f72 <displaySecurityReport+0x272>
c0de7ec4:	f243 262f 	movw	r6, #12847	@ 0x322f
c0de7ec8:	f2c0 0600 	movt	r6, #0
c0de7ecc:	447e      	add	r6, pc
    if ((set & (1 << W3C_THREAT_DETECTED_WARN)) || (set & (1 << W3C_RISK_DETECTED_WARN))) {
c0de7ece:	f018 0f06 	tst.w	r8, #6
c0de7ed2:	d1b0      	bne.n	c0de7e36 <displaySecurityReport+0x136>
    else if (set & (1 << BLIND_SIGNING_WARN)) {
c0de7ed4:	ea5f 60c8 	movs.w	r0, r8, lsl #27
c0de7ed8:	d419      	bmi.n	c0de7f0e <displaySecurityReport+0x20e>
    else if (set & (1 << W3C_ISSUE_WARN)) {
c0de7eda:	ea5f 70c8 	movs.w	r0, r8, lsl #31
c0de7ede:	d037      	beq.n	c0de7f50 <displaySecurityReport+0x250>
c0de7ee0:	ad01      	add	r5, sp, #4
        nbgl_contentCenter_t info = {0};
c0de7ee2:	4628      	mov	r0, r5
c0de7ee4:	2124      	movs	r1, #36	@ 0x24
c0de7ee6:	f001 ff69 	bl	c0de9dbc <__aeabi_memclr>
        info.icon                 = &LARGE_WARNING_ICON;
c0de7eea:	f242 5032 	movw	r0, #9522	@ 0x2532
c0de7eee:	f2c0 0000 	movt	r0, #0
c0de7ef2:	4478      	add	r0, pc
c0de7ef4:	9002      	str	r0, [sp, #8]
        info.title                = "Transaction Check unavailable";
c0de7ef6:	f642 50df 	movw	r0, #11743	@ 0x2ddf
c0de7efa:	f2c0 0000 	movt	r0, #0
c0de7efe:	4478      	add	r0, pc
c0de7f00:	9005      	str	r0, [sp, #20]
            = "If you're not using the Ledger Wallet app, Transaction Check might not work. If "
c0de7f02:	f642 601f 	movw	r0, #11807	@ 0x2e1f
c0de7f06:	f2c0 0000 	movt	r0, #0
c0de7f0a:	4478      	add	r0, pc
c0de7f0c:	e015      	b.n	c0de7f3a <displaySecurityReport+0x23a>
c0de7f0e:	ad01      	add	r5, sp, #4
        nbgl_contentCenter_t info = {0};
c0de7f10:	4628      	mov	r0, r5
c0de7f12:	2124      	movs	r1, #36	@ 0x24
c0de7f14:	f001 ff52 	bl	c0de9dbc <__aeabi_memclr>
        info.icon                 = &LARGE_WARNING_ICON;
c0de7f18:	f242 5004 	movw	r0, #9476	@ 0x2504
c0de7f1c:	f2c0 0000 	movt	r0, #0
c0de7f20:	4478      	add	r0, pc
c0de7f22:	9002      	str	r0, [sp, #8]
        info.title                = "This transaction cannot be Clear Signed";
c0de7f24:	f243 00af 	movw	r0, #12463	@ 0x30af
c0de7f28:	f2c0 0000 	movt	r0, #0
c0de7f2c:	4478      	add	r0, pc
c0de7f2e:	9005      	str	r0, [sp, #20]
            = "This transaction or message cannot be decoded fully. If you choose to sign, you "
c0de7f30:	f642 70b9 	movw	r0, #12217	@ 0x2fb9
c0de7f34:	f2c0 0000 	movt	r0, #0
c0de7f38:	4478      	add	r0, pc
c0de7f3a:	9007      	str	r0, [sp, #28]
c0de7f3c:	4620      	mov	r0, r4
c0de7f3e:	4629      	mov	r1, r5
c0de7f40:	f7fc f826 	bl	c0de3f90 <nbgl_layoutAddContentCenter>
c0de7f44:	2028      	movs	r0, #40	@ 0x28
c0de7f46:	f8ad 002c 	strh.w	r0, [sp, #44]	@ 0x2c
c0de7f4a:	2000      	movs	r0, #0
c0de7f4c:	f88d 0041 	strb.w	r0, [sp, #65]	@ 0x41
    nbgl_layoutAddHeader(reviewWithWarnCtx.modalLayout, &headerDesc);
c0de7f50:	eb09 0007 	add.w	r0, r9, r7
c0de7f54:	f8d0 0084 	ldr.w	r0, [r0, #132]	@ 0x84
c0de7f58:	a910      	add	r1, sp, #64	@ 0x40
c0de7f5a:	f7fc fdf1 	bl	c0de4b40 <nbgl_layoutAddHeader>
    if (footerDesc.emptySpace.height > 0) {
c0de7f5e:	f8bd 002c 	ldrh.w	r0, [sp, #44]	@ 0x2c
c0de7f62:	b130      	cbz	r0, c0de7f72 <displaySecurityReport+0x272>
        nbgl_layoutAddExtendedFooter(reviewWithWarnCtx.modalLayout, &footerDesc);
c0de7f64:	eb09 0007 	add.w	r0, r9, r7
c0de7f68:	f8d0 0084 	ldr.w	r0, [r0, #132]	@ 0x84
c0de7f6c:	a90a      	add	r1, sp, #40	@ 0x28
c0de7f6e:	f7fa f98e 	bl	c0de228e <nbgl_layoutAddExtendedFooter>
c0de7f72:	eb09 0007 	add.w	r0, r9, r7
c0de7f76:	f8d0 0084 	ldr.w	r0, [r0, #132]	@ 0x84
c0de7f7a:	f7fd fa27 	bl	c0de53cc <nbgl_layoutDraw>
c0de7f7e:	f000 fdb6 	bl	c0de8aee <nbgl_refresh>
}
c0de7f82:	b01c      	add	sp, #112	@ 0x70
c0de7f84:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de7f88 <modalLayoutTouchCallback>:
{
c0de7f88:	b570      	push	{r4, r5, r6, lr}
    if (token == DISMISS_QR_TOKEN) {
c0de7f8a:	2818      	cmp	r0, #24
c0de7f8c:	d00f      	beq.n	c0de7fae <modalLayoutTouchCallback+0x26>
c0de7f8e:	2817      	cmp	r0, #23
c0de7f90:	d01f      	beq.n	c0de7fd2 <modalLayoutTouchCallback+0x4a>
c0de7f92:	2816      	cmp	r0, #22
c0de7f94:	d131      	bne.n	c0de7ffa <modalLayoutTouchCallback+0x72>
        nbgl_layoutRelease(addressConfirmationContext.modalLayout);
c0de7f96:	f240 6084 	movw	r0, #1668	@ 0x684
c0de7f9a:	f2c0 0000 	movt	r0, #0
c0de7f9e:	eb09 0400 	add.w	r4, r9, r0
c0de7fa2:	6b20      	ldr	r0, [r4, #48]	@ 0x30
c0de7fa4:	f7fd fa36 	bl	c0de5414 <nbgl_layoutRelease>
c0de7fa8:	2000      	movs	r0, #0
        addressConfirmationContext.modalLayout = NULL;
c0de7faa:	6320      	str	r0, [r4, #48]	@ 0x30
c0de7fac:	e067      	b.n	c0de807e <modalLayoutTouchCallback+0xf6>
        nbgl_layoutRelease(choiceWithDetailsCtx.modalLayout);
c0de7fae:	f240 44f0 	movw	r4, #1264	@ 0x4f0
c0de7fb2:	f2c0 0400 	movt	r4, #0
c0de7fb6:	eb09 0504 	add.w	r5, r9, r4
c0de7fba:	6e68      	ldr	r0, [r5, #100]	@ 0x64
c0de7fbc:	f7fd fa2a 	bl	c0de5414 <nbgl_layoutRelease>
        if (choiceWithDetailsCtx.level <= 1) {
c0de7fc0:	f895 0068 	ldrb.w	r0, [r5, #104]	@ 0x68
c0de7fc4:	2801      	cmp	r0, #1
c0de7fc6:	d83a      	bhi.n	c0de803e <modalLayoutTouchCallback+0xb6>
            choiceWithDetailsCtx.modalLayout = NULL;
c0de7fc8:	eb09 0004 	add.w	r0, r9, r4
c0de7fcc:	2100      	movs	r1, #0
c0de7fce:	6641      	str	r1, [r0, #100]	@ 0x64
c0de7fd0:	e055      	b.n	c0de807e <modalLayoutTouchCallback+0xf6>
        nbgl_layoutRelease(reviewWithWarnCtx.modalLayout);
c0de7fd2:	f240 44f0 	movw	r4, #1264	@ 0x4f0
c0de7fd6:	f2c0 0400 	movt	r4, #0
c0de7fda:	eb09 0504 	add.w	r5, r9, r4
c0de7fde:	f8d5 0084 	ldr.w	r0, [r5, #132]	@ 0x84
c0de7fe2:	f7fd fa17 	bl	c0de5414 <nbgl_layoutRelease>
        if (reviewWithWarnCtx.securityReportLevel <= 1) {
c0de7fe6:	f895 0088 	ldrb.w	r0, [r5, #136]	@ 0x88
c0de7fea:	2801      	cmp	r0, #1
c0de7fec:	d831      	bhi.n	c0de8052 <modalLayoutTouchCallback+0xca>
            reviewWithWarnCtx.modalLayout = NULL;
c0de7fee:	eb09 0004 	add.w	r0, r9, r4
c0de7ff2:	2100      	movs	r1, #0
c0de7ff4:	f8c0 1084 	str.w	r1, [r0, #132]	@ 0x84
c0de7ff8:	e041      	b.n	c0de807e <modalLayoutTouchCallback+0xf6>
    else if ((token >= FIRST_WARN_BAR_TOKEN) && (token <= LAST_WARN_BAR_TOKEN)) {
c0de7ffa:	f1a0 041c 	sub.w	r4, r0, #28
c0de7ffe:	2c05      	cmp	r4, #5
c0de8000:	d832      	bhi.n	c0de8068 <modalLayoutTouchCallback+0xe0>
        if (sharedContext.usage == SHARE_CTX_REVIEW_WITH_WARNING) {
c0de8002:	f240 45f0 	movw	r5, #1264	@ 0x4f0
c0de8006:	f2c0 0500 	movt	r5, #0
c0de800a:	eb09 0005 	add.w	r0, r9, r5
c0de800e:	f890 008c 	ldrb.w	r0, [r0, #140]	@ 0x8c
c0de8012:	2802      	cmp	r0, #2
c0de8014:	d046      	beq.n	c0de80a4 <modalLayoutTouchCallback+0x11c>
c0de8016:	2801      	cmp	r0, #1
c0de8018:	d135      	bne.n	c0de8086 <modalLayoutTouchCallback+0xfe>
            nbgl_layoutRelease(reviewWithWarnCtx.modalLayout);
c0de801a:	eb09 0605 	add.w	r6, r9, r5
c0de801e:	f8d6 0084 	ldr.w	r0, [r6, #132]	@ 0x84
c0de8022:	f7fd f9f7 	bl	c0de5414 <nbgl_layoutRelease>
c0de8026:	2102      	movs	r1, #2
            if (reviewWithWarnCtx.warning->predefinedSet) {
c0de8028:	6fb0      	ldr	r0, [r6, #120]	@ 0x78
            reviewWithWarnCtx.securityReportLevel = 2;
c0de802a:	f886 1088 	strb.w	r1, [r6, #136]	@ 0x88
            if (reviewWithWarnCtx.warning->predefinedSet) {
c0de802e:	6801      	ldr	r1, [r0, #0]
c0de8030:	2900      	cmp	r1, #0
c0de8032:	d051      	beq.n	c0de80d8 <modalLayoutTouchCallback+0x150>
c0de8034:	2001      	movs	r0, #1
                displaySecurityReport(1 << (token - FIRST_WARN_BAR_TOKEN));
c0de8036:	40a0      	lsls	r0, r4
c0de8038:	f7ff fe62 	bl	c0de7d00 <displaySecurityReport>
}
c0de803c:	bd70      	pop	{r4, r5, r6, pc}
            choiceWithDetailsCtx.level = 1;
c0de803e:	444c      	add	r4, r9
c0de8040:	2101      	movs	r1, #1
                = displayModalDetails(choiceWithDetailsCtx.details, DISMISS_DETAILS_TOKEN);
c0de8042:	6de0      	ldr	r0, [r4, #92]	@ 0x5c
            choiceWithDetailsCtx.level = 1;
c0de8044:	f884 1068 	strb.w	r1, [r4, #104]	@ 0x68
                = displayModalDetails(choiceWithDetailsCtx.details, DISMISS_DETAILS_TOKEN);
c0de8048:	2118      	movs	r1, #24
c0de804a:	f000 f85d 	bl	c0de8108 <displayModalDetails>
c0de804e:	6660      	str	r0, [r4, #100]	@ 0x64
c0de8050:	e017      	b.n	c0de8082 <modalLayoutTouchCallback+0xfa>
            reviewWithWarnCtx.securityReportLevel = 1;
c0de8052:	eb09 0004 	add.w	r0, r9, r4
c0de8056:	2201      	movs	r2, #1
            if (reviewWithWarnCtx.warning->predefinedSet) {
c0de8058:	6f81      	ldr	r1, [r0, #120]	@ 0x78
            reviewWithWarnCtx.securityReportLevel = 1;
c0de805a:	f880 2088 	strb.w	r2, [r0, #136]	@ 0x88
            if (reviewWithWarnCtx.warning->predefinedSet) {
c0de805e:	6808      	ldr	r0, [r1, #0]
c0de8060:	b190      	cbz	r0, c0de8088 <modalLayoutTouchCallback+0x100>
                displaySecurityReport(reviewWithWarnCtx.warning->predefinedSet);
c0de8062:	f7ff fe4d 	bl	c0de7d00 <displaySecurityReport>
}
c0de8066:	bd70      	pop	{r4, r5, r6, pc}
        nbgl_layoutRelease(genericContext.modalLayout);
c0de8068:	f240 40f0 	movw	r0, #1264	@ 0x4f0
c0de806c:	f2c0 0000 	movt	r0, #0
c0de8070:	eb09 0400 	add.w	r4, r9, r0
c0de8074:	6ae0      	ldr	r0, [r4, #44]	@ 0x2c
c0de8076:	f7fd f9cd 	bl	c0de5414 <nbgl_layoutRelease>
c0de807a:	2000      	movs	r0, #0
        genericContext.modalLayout = NULL;
c0de807c:	62e0      	str	r0, [r4, #44]	@ 0x2c
c0de807e:	f000 fd5e 	bl	c0de8b3e <nbgl_screenRedraw>
    nbgl_refresh();
c0de8082:	f000 fd34 	bl	c0de8aee <nbgl_refresh>
}
c0de8086:	bd70      	pop	{r4, r5, r6, pc}
                    = (reviewWithWarnCtx.isIntro) ? reviewWithWarnCtx.warning->introDetails
c0de8088:	444c      	add	r4, r9
c0de808a:	f894 0089 	ldrb.w	r0, [r4, #137]	@ 0x89
c0de808e:	2214      	movs	r2, #20
c0de8090:	2800      	cmp	r0, #0
c0de8092:	bf08      	it	eq
c0de8094:	2218      	moveq	r2, #24
c0de8096:	5888      	ldr	r0, [r1, r2]
    reviewWithWarnCtx.modalLayout = displayModalDetails(details, DISMISS_WARNING_TOKEN);
c0de8098:	2117      	movs	r1, #23
c0de809a:	f000 f835 	bl	c0de8108 <displayModalDetails>
c0de809e:	f8c4 0084 	str.w	r0, [r4, #132]	@ 0x84
}
c0de80a2:	bd70      	pop	{r4, r5, r6, pc}
                = &choiceWithDetailsCtx.details->barList.details[token - FIRST_WARN_BAR_TOKEN];
c0de80a4:	eb09 0005 	add.w	r0, r9, r5
c0de80a8:	6dc0      	ldr	r0, [r0, #92]	@ 0x5c
c0de80aa:	212c      	movs	r1, #44	@ 0x2c
c0de80ac:	6980      	ldr	r0, [r0, #24]
c0de80ae:	fb04 f201 	mul.w	r2, r4, r1
            if (details->title != NO_TYPE_WARNING) {
c0de80b2:	5882      	ldr	r2, [r0, r2]
c0de80b4:	2a00      	cmp	r2, #0
}
c0de80b6:	bf08      	it	eq
c0de80b8:	bd70      	popeq	{r4, r5, r6, pc}
                nbgl_layoutRelease(choiceWithDetailsCtx.modalLayout);
c0de80ba:	444d      	add	r5, r9
c0de80bc:	fb04 0401 	mla	r4, r4, r1, r0
c0de80c0:	6e68      	ldr	r0, [r5, #100]	@ 0x64
c0de80c2:	f7fd f9a7 	bl	c0de5414 <nbgl_layoutRelease>
c0de80c6:	2002      	movs	r0, #2
                choiceWithDetailsCtx.level = 2;
c0de80c8:	f885 0068 	strb.w	r0, [r5, #104]	@ 0x68
                    = displayModalDetails(details, DISMISS_DETAILS_TOKEN);
c0de80cc:	4620      	mov	r0, r4
c0de80ce:	2118      	movs	r1, #24
c0de80d0:	f000 f81a 	bl	c0de8108 <displayModalDetails>
c0de80d4:	6668      	str	r0, [r5, #100]	@ 0x64
}
c0de80d6:	bd70      	pop	{r4, r5, r6, pc}
                    = (reviewWithWarnCtx.isIntro) ? reviewWithWarnCtx.warning->introDetails
c0de80d8:	eb09 0105 	add.w	r1, r9, r5
c0de80dc:	f891 1089 	ldrb.w	r1, [r1, #137]	@ 0x89
c0de80e0:	2214      	movs	r2, #20
c0de80e2:	2900      	cmp	r1, #0
c0de80e4:	bf08      	it	eq
c0de80e6:	2218      	moveq	r2, #24
c0de80e8:	5880      	ldr	r0, [r0, r2]
                if (details->type == BAR_LIST_WARNING) {
c0de80ea:	7901      	ldrb	r1, [r0, #4]
c0de80ec:	2903      	cmp	r1, #3
c0de80ee:	d1ca      	bne.n	c0de8086 <modalLayoutTouchCallback+0xfe>
                        &details->barList.details[token - FIRST_WARN_BAR_TOKEN]);
c0de80f0:	6980      	ldr	r0, [r0, #24]
c0de80f2:	212c      	movs	r1, #44	@ 0x2c
c0de80f4:	fb04 0001 	mla	r0, r4, r1, r0
    reviewWithWarnCtx.modalLayout = displayModalDetails(details, DISMISS_WARNING_TOKEN);
c0de80f8:	2117      	movs	r1, #23
c0de80fa:	f000 f805 	bl	c0de8108 <displayModalDetails>
c0de80fe:	eb09 0105 	add.w	r1, r9, r5
c0de8102:	f8c1 0084 	str.w	r0, [r1, #132]	@ 0x84
}
c0de8106:	bd70      	pop	{r4, r5, r6, pc}

c0de8108 <displayModalDetails>:
{
c0de8108:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de810c:	b092      	sub	sp, #72	@ 0x48
    nbgl_layoutDescription_t layoutDescription = {.modal            = true,
c0de810e:	f243 339a 	movw	r3, #13210	@ 0x339a
c0de8112:	f2c0 0300 	movt	r3, #0
c0de8116:	447b      	add	r3, pc
c0de8118:	f10d 0c2c 	add.w	ip, sp, #44	@ 0x2c
c0de811c:	cb70      	ldmia	r3!, {r4, r5, r6}
c0de811e:	4662      	mov	r2, ip
c0de8120:	c270      	stmia	r2!, {r4, r5, r6}
c0de8122:	4604      	mov	r4, r0
c0de8124:	e893 00e1 	ldmia.w	r3, {r0, r5, r6, r7}
c0de8128:	c2e1      	stmia	r2!, {r0, r5, r6, r7}
c0de812a:	2600      	movs	r6, #0
c0de812c:	f240 1001 	movw	r0, #257	@ 0x101
    nbgl_layoutHeader_t      headerDesc        = {.type               = HEADER_BACK_AND_TEXT,
c0de8130:	e9cd 6606 	strd	r6, r6, [sp, #24]
c0de8134:	f8ad 0018 	strh.w	r0, [sp, #24]
c0de8138:	2009      	movs	r0, #9
c0de813a:	960a      	str	r6, [sp, #40]	@ 0x28
c0de813c:	e9cd 6608 	strd	r6, r6, [sp, #32]
                                                  .backAndText.icon   = NULL,
c0de8140:	f88d 0025 	strb.w	r0, [sp, #37]	@ 0x25
    layout                      = nbgl_layoutGet(&layoutDescription);
c0de8144:	4660      	mov	r0, ip
                                                  .backAndText.icon   = NULL,
c0de8146:	f88d 1024 	strb.w	r1, [sp, #36]	@ 0x24
    layout                      = nbgl_layoutGet(&layoutDescription);
c0de814a:	f7f9 f879 	bl	c0de1240 <nbgl_layoutGet>
    headerDesc.backAndText.text = details->title;
c0de814e:	6821      	ldr	r1, [r4, #0]
    layout                      = nbgl_layoutGet(&layoutDescription);
c0de8150:	4605      	mov	r5, r0
    headerDesc.backAndText.text = details->title;
c0de8152:	9108      	str	r1, [sp, #32]
c0de8154:	a906      	add	r1, sp, #24
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de8156:	f7fc fcf3 	bl	c0de4b40 <nbgl_layoutAddHeader>
    if (details->type == BAR_LIST_WARNING) {
c0de815a:	7920      	ldrb	r0, [r4, #4]
c0de815c:	2801      	cmp	r0, #1
c0de815e:	d044      	beq.n	c0de81ea <displayModalDetails+0xe2>
c0de8160:	2802      	cmp	r0, #2
c0de8162:	d04a      	beq.n	c0de81fa <displayModalDetails+0xf2>
c0de8164:	2803      	cmp	r0, #3
c0de8166:	d14f      	bne.n	c0de8208 <displayModalDetails+0x100>
        for (i = 0; i < details->barList.nbBars; i++) {
c0de8168:	7a20      	ldrb	r0, [r4, #8]
c0de816a:	2800      	cmp	r0, #0
c0de816c:	d04c      	beq.n	c0de8208 <displayModalDetails+0x100>
c0de816e:	2700      	movs	r7, #0
c0de8170:	2604      	movs	r6, #4
c0de8172:	f04f 0a09 	mov.w	sl, #9
c0de8176:	46e8      	mov	r8, sp
c0de8178:	f04f 0b00 	mov.w	fp, #0
c0de817c:	e020      	b.n	c0de81c0 <displayModalDetails+0xb8>
c0de817e:	bf00      	nop
                bar.iconRight = NULL;
c0de8180:	9702      	str	r7, [sp, #8]
            if (details->barList.icons != NULL) {
c0de8182:	6960      	ldr	r0, [r4, #20]
            nbgl_layoutAddTouchableBar(layout, &bar);
c0de8184:	4641      	mov	r1, r8
            if (details->barList.icons != NULL) {
c0de8186:	2800      	cmp	r0, #0
                bar.iconLeft = NULL;
c0de8188:	bf0e      	itee	eq
c0de818a:	9700      	streq	r7, [sp, #0]
                bar.iconLeft = details->barList.icons[i];
c0de818c:	f850 002b 	ldrne.w	r0, [r0, fp, lsl #2]
c0de8190:	9000      	strne	r0, [sp, #0]
            bar.token    = FIRST_WARN_BAR_TOKEN + i;
c0de8192:	f10b 001c 	add.w	r0, fp, #28
c0de8196:	f88d 0011 	strb.w	r0, [sp, #17]
            nbgl_layoutAddTouchableBar(layout, &bar);
c0de819a:	4628      	mov	r0, r5
            bar.tuneId   = TUNE_TAP_CASUAL;
c0de819c:	f88d a014 	strb.w	sl, [sp, #20]
            bar.large    = false;
c0de81a0:	f88d 7010 	strb.w	r7, [sp, #16]
            bar.inactive = false;
c0de81a4:	f88d 7012 	strb.w	r7, [sp, #18]
            nbgl_layoutAddTouchableBar(layout, &bar);
c0de81a8:	f7fa fdea 	bl	c0de2d80 <nbgl_layoutAddTouchableBar>
            nbgl_layoutAddSeparationLine(layout);
c0de81ac:	4628      	mov	r0, r5
c0de81ae:	f7fc fb36 	bl	c0de481e <nbgl_layoutAddSeparationLine>
        for (i = 0; i < details->barList.nbBars; i++) {
c0de81b2:	7a20      	ldrb	r0, [r4, #8]
c0de81b4:	f10b 0b01 	add.w	fp, fp, #1
c0de81b8:	4583      	cmp	fp, r0
c0de81ba:	f106 062c 	add.w	r6, r6, #44	@ 0x2c
c0de81be:	d223      	bcs.n	c0de8208 <displayModalDetails+0x100>
            bar.text    = details->barList.texts[i];
c0de81c0:	e9d4 0103 	ldrd	r0, r1, [r4, #12]
c0de81c4:	f850 202b 	ldr.w	r2, [r0, fp, lsl #2]
            if ((details->barList.details)
c0de81c8:	69a0      	ldr	r0, [r4, #24]
            bar.text    = details->barList.texts[i];
c0de81ca:	9201      	str	r2, [sp, #4]
            bar.subText = details->barList.subTexts[i];
c0de81cc:	f851 102b 	ldr.w	r1, [r1, fp, lsl #2]
                && (details->barList.details[i].type != NO_TYPE_WARNING)) {
c0de81d0:	2800      	cmp	r0, #0
            bar.subText = details->barList.subTexts[i];
c0de81d2:	9103      	str	r1, [sp, #12]
                && (details->barList.details[i].type != NO_TYPE_WARNING)) {
c0de81d4:	d0d4      	beq.n	c0de8180 <displayModalDetails+0x78>
c0de81d6:	5d80      	ldrb	r0, [r0, r6]
            if ((details->barList.details)
c0de81d8:	2800      	cmp	r0, #0
c0de81da:	d0d1      	beq.n	c0de8180 <displayModalDetails+0x78>
                bar.iconRight = &PUSH_ICON;
c0de81dc:	f242 30b2 	movw	r0, #9138	@ 0x23b2
c0de81e0:	f2c0 0000 	movt	r0, #0
c0de81e4:	4478      	add	r0, pc
c0de81e6:	9002      	str	r0, [sp, #8]
c0de81e8:	e7cb      	b.n	c0de8182 <displayModalDetails+0x7a>
        nbgl_layoutAddContentCenter(layout, &details->centeredInfo);
c0de81ea:	f104 0108 	add.w	r1, r4, #8
c0de81ee:	4628      	mov	r0, r5
c0de81f0:	f7fb fece 	bl	c0de3f90 <nbgl_layoutAddContentCenter>
        headerDesc.separationLine = false;
c0de81f4:	f88d 6019 	strb.w	r6, [sp, #25]
c0de81f8:	e006      	b.n	c0de8208 <displayModalDetails+0x100>
        nbgl_layoutAddQRCode(layout, &details->qrCode);
c0de81fa:	f104 0108 	add.w	r1, r4, #8
c0de81fe:	4628      	mov	r0, r5
c0de8200:	f7fb fed3 	bl	c0de3faa <nbgl_layoutAddQRCode>
        headerDesc.backAndText.text = details->title;
c0de8204:	6820      	ldr	r0, [r4, #0]
c0de8206:	9008      	str	r0, [sp, #32]
    nbgl_layoutDraw(layout);
c0de8208:	4628      	mov	r0, r5
c0de820a:	f7fd f8df 	bl	c0de53cc <nbgl_layoutDraw>
    nbgl_refresh();
c0de820e:	f000 fc6e 	bl	c0de8aee <nbgl_refresh>
    return layout;
c0de8212:	4628      	mov	r0, r5
c0de8214:	b012      	add	sp, #72	@ 0x48
c0de8216:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
	...

c0de821c <displayDetailsPage>:
{
c0de821c:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de8220:	b09a      	sub	sp, #104	@ 0x68
                                            .nbPages                   = detailsContext.nbPages,
c0de8222:	f640 0a40 	movw	sl, #2112	@ 0x840
c0de8226:	f2c0 0a00 	movt	sl, #0
c0de822a:	4604      	mov	r4, r0
    nbgl_pageNavigationInfo_t    info    = {.activePage                = detailsPage,
c0de822c:	f88d 0048 	strb.w	r0, [sp, #72]	@ 0x48
                                            .nbPages                   = detailsContext.nbPages,
c0de8230:	f819 000a 	ldrb.w	r0, [r9, sl]
c0de8234:	4688      	mov	r8, r1
    nbgl_pageNavigationInfo_t    info    = {.activePage                = detailsPage,
c0de8236:	f88d 0049 	strb.w	r0, [sp, #73]	@ 0x49
c0de823a:	f44f 7081 	mov.w	r0, #258	@ 0x102
c0de823e:	f8ad 004a 	strh.w	r0, [sp, #74]	@ 0x4a
c0de8242:	f44f 6010 	mov.w	r0, #2304	@ 0x900
c0de8246:	f240 1101 	movw	r1, #257	@ 0x101
c0de824a:	f8ad 004c 	strh.w	r0, [sp, #76]	@ 0x4c
c0de824e:	2000      	movs	r0, #0
c0de8250:	f2c0 3100 	movt	r1, #768	@ 0x300
c0de8254:	9014      	str	r0, [sp, #80]	@ 0x50
c0de8256:	f88d 0054 	strb.w	r0, [sp, #84]	@ 0x54
                                            .navWithButtons.navToken   = NAV_TOKEN,
c0de825a:	e9cd 1016 	strd	r1, r0, [sp, #88]	@ 0x58
c0de825e:	a802      	add	r0, sp, #8
    nbgl_pageContent_t           content = {.type                           = TAG_VALUE_LIST,
c0de8260:	2140      	movs	r1, #64	@ 0x40
                                            .nbPages                   = detailsContext.nbPages,
c0de8262:	eb09 050a 	add.w	r5, r9, sl
    nbgl_pageContent_t           content = {.type                           = TAG_VALUE_LIST,
c0de8266:	f001 fda9 	bl	c0de9dbc <__aeabi_memclr>
                                            .tagValueList.nbPairs           = 1,
c0de826a:	f640 0b50 	movw	fp, #2128	@ 0x850
c0de826e:	2004      	movs	r0, #4
c0de8270:	f2c0 0b00 	movt	fp, #0
    nbgl_pageContent_t           content = {.type                           = TAG_VALUE_LIST,
c0de8274:	f88d 0014 	strb.w	r0, [sp, #20]
                                            .tagValueList.nbPairs           = 1,
c0de8278:	eb09 000b 	add.w	r0, r9, fp
c0de827c:	9006      	str	r0, [sp, #24]
c0de827e:	2001      	movs	r0, #1
c0de8280:	f88d 0020 	strb.w	r0, [sp, #32]
c0de8284:	f88d 0025 	strb.w	r0, [sp, #37]	@ 0x25
    if (modalPageContext != NULL) {
c0de8288:	f240 605c 	movw	r0, #1628	@ 0x65c
c0de828c:	f2c0 0000 	movt	r0, #0
c0de8290:	f859 0000 	ldr.w	r0, [r9, r0]
                                            .tagValueList.wrapping = detailsContext.wrapping};
c0de8294:	78e9      	ldrb	r1, [r5, #3]
    if (modalPageContext != NULL) {
c0de8296:	2800      	cmp	r0, #0
                                            .tagValueList.nbPairs           = 1,
c0de8298:	f88d 1026 	strb.w	r1, [sp, #38]	@ 0x26
        nbgl_pageRelease(modalPageContext);
c0de829c:	bf18      	it	ne
c0de829e:	f7fd ff9a 	blne	c0de61d6 <nbgl_pageRelease>
    currentPair.item = detailsContext.tag;
c0de82a2:	eb09 000a 	add.w	r0, r9, sl
    if (detailsPage <= detailsContext.currentPage) {
c0de82a6:	7841      	ldrb	r1, [r0, #1]
    currentPair.item = detailsContext.tag;
c0de82a8:	6840      	ldr	r0, [r0, #4]
    if (detailsPage <= detailsContext.currentPage) {
c0de82aa:	42a1      	cmp	r1, r4
    currentPair.item = detailsContext.tag;
c0de82ac:	f849 000b 	str.w	r0, [r9, fp]
        currentPair.value = detailsContext.nextPageStart;
c0de82b0:	eb09 000a 	add.w	r0, r9, sl
    if (detailsPage <= detailsContext.currentPage) {
c0de82b4:	d206      	bcs.n	c0de82c4 <displayDetailsPage+0xa8>
        currentPair.value = detailsContext.nextPageStart;
c0de82b6:	68c6      	ldr	r6, [r0, #12]
c0de82b8:	2501      	movs	r5, #1
c0de82ba:	f1b8 0f00 	cmp.w	r8, #0
c0de82be:	bf18      	it	ne
c0de82c0:	2502      	movne	r5, #2
c0de82c2:	e031      	b.n	c0de8328 <displayDetailsPage+0x10c>
    const char *currentChar = detailsContext.value;
c0de82c4:	6886      	ldr	r6, [r0, #8]
    while (page < detailsPage) {
c0de82c6:	b374      	cbz	r4, c0de8326 <displayDetailsPage+0x10a>
c0de82c8:	2500      	movs	r5, #0
c0de82ca:	f10d 0866 	add.w	r8, sp, #102	@ 0x66
c0de82ce:	e008      	b.n	c0de82e2 <displayDetailsPage+0xc6>
                len++;
c0de82d0:	3001      	adds	r0, #1
c0de82d2:	f8ad 0066 	strh.w	r0, [sp, #102]	@ 0x66
            currentChar = currentChar + len;
c0de82d6:	f8bd 0066 	ldrh.w	r0, [sp, #102]	@ 0x66
c0de82da:	4406      	add	r6, r0
        page++;
c0de82dc:	3501      	adds	r5, #1
    while (page < detailsPage) {
c0de82de:	42a5      	cmp	r5, r4
c0de82e0:	d221      	bcs.n	c0de8326 <displayDetailsPage+0x10a>
            = nbgl_getTextNbLinesInWidth(SMALL_BOLD_FONT, currentChar, AVAILABLE_WIDTH, false);
c0de82e2:	200c      	movs	r0, #12
c0de82e4:	4631      	mov	r1, r6
c0de82e6:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de82ea:	2300      	movs	r3, #0
c0de82ec:	f000 fc59 	bl	c0de8ba2 <nbgl_getTextNbLinesInWidth>
        if (nbLines > NB_MAX_LINES_IN_DETAILS) {
c0de82f0:	280c      	cmp	r0, #12
c0de82f2:	d3f3      	bcc.n	c0de82dc <displayDetailsPage+0xc0>
                                        detailsContext.wrapping);
c0de82f4:	eb09 000a 	add.w	r0, r9, sl
c0de82f8:	78c7      	ldrb	r7, [r0, #3]
            nbgl_getTextMaxLenInNbLines(SMALL_BOLD_FONT,
c0de82fa:	200c      	movs	r0, #12
c0de82fc:	4631      	mov	r1, r6
c0de82fe:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de8302:	230b      	movs	r3, #11
c0de8304:	f8cd 8000 	str.w	r8, [sp]
c0de8308:	9701      	str	r7, [sp, #4]
c0de830a:	f000 fc54 	bl	c0de8bb6 <nbgl_getTextMaxLenInNbLines>
            if (currentChar[len] == '\n') {
c0de830e:	f8bd 0066 	ldrh.w	r0, [sp, #102]	@ 0x66
c0de8312:	5c31      	ldrb	r1, [r6, r0]
c0de8314:	290a      	cmp	r1, #10
c0de8316:	d0db      	beq.n	c0de82d0 <displayDetailsPage+0xb4>
            else if (detailsContext.wrapping == false) {
c0de8318:	eb09 010a 	add.w	r1, r9, sl
c0de831c:	78c9      	ldrb	r1, [r1, #3]
c0de831e:	2900      	cmp	r1, #0
c0de8320:	d1d9      	bne.n	c0de82d6 <displayDetailsPage+0xba>
                len -= 3;
c0de8322:	3803      	subs	r0, #3
c0de8324:	e7d5      	b.n	c0de82d2 <displayDetailsPage+0xb6>
c0de8326:	2502      	movs	r5, #2
c0de8328:	eb09 000b 	add.w	r0, r9, fp
c0de832c:	6046      	str	r6, [r0, #4]
    detailsContext.currentPage = detailsPage;
c0de832e:	eb09 000a 	add.w	r0, r9, sl
        SMALL_BOLD_FONT, currentPair.value, AVAILABLE_WIDTH, detailsContext.wrapping);
c0de8332:	78c3      	ldrb	r3, [r0, #3]
    detailsContext.currentPage = detailsPage;
c0de8334:	7044      	strb	r4, [r0, #1]
    uint16_t nbLines           = nbgl_getTextNbLinesInWidth(
c0de8336:	200c      	movs	r0, #12
c0de8338:	4631      	mov	r1, r6
c0de833a:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de833e:	f000 fc30 	bl	c0de8ba2 <nbgl_getTextNbLinesInWidth>
    if (nbLines > NB_MAX_LINES_IN_DETAILS) {
c0de8342:	280c      	cmp	r0, #12
c0de8344:	d320      	bcc.n	c0de8388 <displayDetailsPage+0x16c>
                                    currentPair.value,
c0de8346:	eb09 040b 	add.w	r4, r9, fp
                                    detailsContext.wrapping);
c0de834a:	eb09 000a 	add.w	r0, r9, sl
                                    currentPair.value,
c0de834e:	6861      	ldr	r1, [r4, #4]
                                    detailsContext.wrapping);
c0de8350:	78c7      	ldrb	r7, [r0, #3]
c0de8352:	f10d 0066 	add.w	r0, sp, #102	@ 0x66
        nbgl_getTextMaxLenInNbLines(SMALL_BOLD_FONT,
c0de8356:	9000      	str	r0, [sp, #0]
c0de8358:	200c      	movs	r0, #12
c0de835a:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de835e:	230b      	movs	r3, #11
c0de8360:	9701      	str	r7, [sp, #4]
c0de8362:	f000 fc28 	bl	c0de8bb6 <nbgl_getTextMaxLenInNbLines>
c0de8366:	2200      	movs	r2, #0
        if (currentPair.value[len] == '\n') {
c0de8368:	6860      	ldr	r0, [r4, #4]
c0de836a:	f8bd 1066 	ldrh.w	r1, [sp, #102]	@ 0x66
        content.tagValueDetails.tagValueList.hideEndOfLastLine = false;
c0de836e:	f88d 2022 	strb.w	r2, [sp, #34]	@ 0x22
        if (currentPair.value[len] == '\n') {
c0de8372:	5c42      	ldrb	r2, [r0, r1]
c0de8374:	2a0a      	cmp	r2, #10
c0de8376:	d112      	bne.n	c0de839e <displayDetailsPage+0x182>
            len++;
c0de8378:	3101      	adds	r1, #1
c0de837a:	f240 645c 	movw	r4, #1628	@ 0x65c
c0de837e:	f8ad 1066 	strh.w	r1, [sp, #102]	@ 0x66
c0de8382:	f2c0 0400 	movt	r4, #0
c0de8386:	e018      	b.n	c0de83ba <displayDetailsPage+0x19e>
c0de8388:	f240 645c 	movw	r4, #1628	@ 0x65c
        detailsContext.nextPageStart            = NULL;
c0de838c:	eb09 000a 	add.w	r0, r9, sl
c0de8390:	2100      	movs	r1, #0
c0de8392:	f2c0 0400 	movt	r4, #0
c0de8396:	60c1      	str	r1, [r0, #12]
        content.tagValueList.nbMaxLinesForValue = 0;
c0de8398:	f88d 1023 	strb.w	r1, [sp, #35]	@ 0x23
c0de839c:	e016      	b.n	c0de83cc <displayDetailsPage+0x1b0>
        else if (!detailsContext.wrapping) {
c0de839e:	eb09 020a 	add.w	r2, r9, sl
c0de83a2:	78d2      	ldrb	r2, [r2, #3]
c0de83a4:	f240 645c 	movw	r4, #1628	@ 0x65c
c0de83a8:	f2c0 0400 	movt	r4, #0
c0de83ac:	b92a      	cbnz	r2, c0de83ba <displayDetailsPage+0x19e>
c0de83ae:	2201      	movs	r2, #1
            len -= 3;
c0de83b0:	3903      	subs	r1, #3
            content.tagValueDetails.tagValueList.hideEndOfLastLine = true;
c0de83b2:	f88d 2022 	strb.w	r2, [sp, #34]	@ 0x22
            len -= 3;
c0de83b6:	f8ad 1066 	strh.w	r1, [sp, #102]	@ 0x66
        detailsContext.nextPageStart = currentPair.value + len;
c0de83ba:	f8bd 1066 	ldrh.w	r1, [sp, #102]	@ 0x66
c0de83be:	4408      	add	r0, r1
c0de83c0:	eb09 010a 	add.w	r1, r9, sl
c0de83c4:	60c8      	str	r0, [r1, #12]
c0de83c6:	200b      	movs	r0, #11
        content.tagValueList.nbMaxLinesForValue = NB_MAX_LINES_IN_DETAILS;
c0de83c8:	f88d 0023 	strb.w	r0, [sp, #35]	@ 0x23
    if (info.nbPages == 1) {
c0de83cc:	f89d 0049 	ldrb.w	r0, [sp, #73]	@ 0x49
c0de83d0:	2801      	cmp	r0, #1
c0de83d2:	d105      	bne.n	c0de83e0 <displayDetailsPage+0x1c4>
        info.navWithButtons.quitText = "Close";
c0de83d4:	f642 20f6 	movw	r0, #10998	@ 0x2af6
c0de83d8:	f2c0 0000 	movt	r0, #0
c0de83dc:	4478      	add	r0, pc
c0de83de:	9017      	str	r0, [sp, #92]	@ 0x5c
    modalPageContext = nbgl_pageDrawGenericContentExt(&pageModalCallback, &info, &content, true);
c0de83e0:	f24f 2091 	movw	r0, #62097	@ 0xf291
c0de83e4:	f6cf 70ff 	movt	r0, #65535	@ 0xffff
c0de83e8:	4478      	add	r0, pc
c0de83ea:	a912      	add	r1, sp, #72	@ 0x48
c0de83ec:	aa02      	add	r2, sp, #8
c0de83ee:	2301      	movs	r3, #1
c0de83f0:	f7fd fc4e 	bl	c0de5c90 <nbgl_pageDrawGenericContentExt>
c0de83f4:	f849 0004 	str.w	r0, [r9, r4]
c0de83f8:	4628      	mov	r0, r5
c0de83fa:	f000 fb7d 	bl	c0de8af8 <nbgl_refreshSpecial>
}
c0de83fe:	b01a      	add	sp, #104	@ 0x68
c0de8400:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de8404 <displayTagValueListModalPage>:
{
c0de8404:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
c0de8408:	b098      	sub	sp, #96	@ 0x60
c0de840a:	4605      	mov	r5, r0
    nbgl_pageNavigationInfo_t info    = {.activePage                = pageIdx,
c0de840c:	f88d 0044 	strb.w	r0, [sp, #68]	@ 0x44
                                         .nbPages                   = detailsContext.nbPages,
c0de8410:	f640 0740 	movw	r7, #2112	@ 0x840
c0de8414:	f44f 7081 	mov.w	r0, #258	@ 0x102
c0de8418:	4688      	mov	r8, r1
c0de841a:	f2c0 0700 	movt	r7, #0
    nbgl_pageNavigationInfo_t info    = {.activePage                = pageIdx,
c0de841e:	f8ad 0046 	strh.w	r0, [sp, #70]	@ 0x46
c0de8422:	f44f 6010 	mov.w	r0, #2304	@ 0x900
c0de8426:	f240 1101 	movw	r1, #257	@ 0x101
                                         .nbPages                   = detailsContext.nbPages,
c0de842a:	f819 6007 	ldrb.w	r6, [r9, r7]
    nbgl_pageNavigationInfo_t info    = {.activePage                = pageIdx,
c0de842e:	f8ad 0048 	strh.w	r0, [sp, #72]	@ 0x48
c0de8432:	2000      	movs	r0, #0
c0de8434:	f2c0 4100 	movt	r1, #1024	@ 0x400
c0de8438:	9013      	str	r0, [sp, #76]	@ 0x4c
c0de843a:	f88d 0050 	strb.w	r0, [sp, #80]	@ 0x50
                                         .navWithButtons.navToken   = MODAL_NAV_TOKEN,
c0de843e:	e9cd 1015 	strd	r1, r0, [sp, #84]	@ 0x54
c0de8442:	a801      	add	r0, sp, #4
    nbgl_pageContent_t        content = {.type                           = TAG_VALUE_LIST,
c0de8444:	2140      	movs	r1, #64	@ 0x40
                                         .nbPages                   = detailsContext.nbPages,
c0de8446:	eb09 0407 	add.w	r4, r9, r7
    nbgl_pageNavigationInfo_t info    = {.activePage                = pageIdx,
c0de844a:	f88d 6045 	strb.w	r6, [sp, #69]	@ 0x45
    nbgl_pageContent_t        content = {.type                           = TAG_VALUE_LIST,
c0de844e:	f001 fcb5 	bl	c0de9dbc <__aeabi_memclr>
c0de8452:	2101      	movs	r1, #1
                                         .tagValueList.smallCaseForValue = true,
c0de8454:	f88d 1021 	strb.w	r1, [sp, #33]	@ 0x21
    if (detailsContext.currentPage <= pageIdx) {
c0de8458:	7861      	ldrb	r1, [r4, #1]
                                         .tagValueList.wrapping          = detailsContext.wrapping};
c0de845a:	78e2      	ldrb	r2, [r4, #3]
c0de845c:	2004      	movs	r0, #4
    if (detailsContext.currentPage <= pageIdx) {
c0de845e:	42a9      	cmp	r1, r5
    nbgl_pageContent_t        content = {.type                           = TAG_VALUE_LIST,
c0de8460:	f88d 0010 	strb.w	r0, [sp, #16]
                                         .tagValueList.smallCaseForValue = true,
c0de8464:	f88d 2022 	strb.w	r2, [sp, #34]	@ 0x22
    if (detailsContext.currentPage <= pageIdx) {
c0de8468:	d91d      	bls.n	c0de84a6 <displayTagValueListModalPage+0xa2>
        modalContextGetPageInfo(pageIdx + 1, &nbElementsInPage);
c0de846a:	1c69      	adds	r1, r5, #1
    uint8_t pageData = modalContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de846c:	f640 0360 	movw	r3, #2144	@ 0x860
c0de8470:	b2ca      	uxtb	r2, r1
c0de8472:	f2c0 0300 	movt	r3, #0
c0de8476:	0852      	lsrs	r2, r2, #1
c0de8478:	444b      	add	r3, r9
c0de847a:	5c9a      	ldrb	r2, [r3, r2]
                       >> ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de847c:	ea00 0181 	and.w	r1, r0, r1, lsl #2
c0de8480:	fa22 f101 	lsr.w	r1, r2, r1
        detailsContext.currentPairIdx -= nbElementsInPage;
c0de8484:	eb09 0207 	add.w	r2, r9, r7
c0de8488:	7894      	ldrb	r4, [r2, #2]
        *nbElements = GET_PAGE_NB_ELEMENTS(pageData);
c0de848a:	f001 0107 	and.w	r1, r1, #7
        detailsContext.currentPairIdx -= nbElementsInPage;
c0de848e:	1a61      	subs	r1, r4, r1
    uint8_t pageData = modalContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de8490:	086c      	lsrs	r4, r5, #1
c0de8492:	5d1b      	ldrb	r3, [r3, r4]
                       >> ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de8494:	ea00 0085 	and.w	r0, r0, r5, lsl #2
c0de8498:	fa23 f000 	lsr.w	r0, r3, r0
        *nbElements = GET_PAGE_NB_ELEMENTS(pageData);
c0de849c:	f000 0007 	and.w	r0, r0, #7
        detailsContext.currentPairIdx -= nbElementsInPage;
c0de84a0:	1a09      	subs	r1, r1, r0
c0de84a2:	7091      	strb	r1, [r2, #2]
c0de84a4:	e00c      	b.n	c0de84c0 <displayTagValueListModalPage+0xbc>
    uint8_t pageData = modalContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de84a6:	f640 0260 	movw	r2, #2144	@ 0x860
c0de84aa:	f2c0 0200 	movt	r2, #0
c0de84ae:	0869      	lsrs	r1, r5, #1
c0de84b0:	444a      	add	r2, r9
c0de84b2:	5c51      	ldrb	r1, [r2, r1]
                       >> ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de84b4:	ea00 0085 	and.w	r0, r0, r5, lsl #2
c0de84b8:	fa21 f000 	lsr.w	r0, r1, r0
        *nbElements = GET_PAGE_NB_ELEMENTS(pageData);
c0de84bc:	f000 0007 	and.w	r0, r0, #7
        = &genericContext.currentTagValues->pairs[detailsContext.currentPairIdx];
c0de84c0:	f240 42f0 	movw	r2, #1264	@ 0x4f0
c0de84c4:	f2c0 0200 	movt	r2, #0
c0de84c8:	444a      	add	r2, r9
    detailsContext.currentPage = pageIdx;
c0de84ca:	eb09 0107 	add.w	r1, r9, r7
        = &genericContext.currentTagValues->pairs[detailsContext.currentPairIdx];
c0de84ce:	6b92      	ldr	r2, [r2, #56]	@ 0x38
    detailsContext.currentPage = pageIdx;
c0de84d0:	704d      	strb	r5, [r1, #1]
        = &genericContext.currentTagValues->pairs[detailsContext.currentPairIdx];
c0de84d2:	6812      	ldr	r2, [r2, #0]
c0de84d4:	788b      	ldrb	r3, [r1, #2]
    content.tagValueList.nbPairs = nbElementsInPage;
c0de84d6:	f88d 001c 	strb.w	r0, [sp, #28]
        = &genericContext.currentTagValues->pairs[detailsContext.currentPairIdx];
c0de84da:	eb02 1203 	add.w	r2, r2, r3, lsl #4
    detailsContext.currentPairIdx += nbElementsInPage;
c0de84de:	4418      	add	r0, r3
    if (info.nbPages == 1) {
c0de84e0:	2e01      	cmp	r6, #1
        = &genericContext.currentTagValues->pairs[detailsContext.currentPairIdx];
c0de84e2:	9205      	str	r2, [sp, #20]
    detailsContext.currentPairIdx += nbElementsInPage;
c0de84e4:	7088      	strb	r0, [r1, #2]
    if (info.nbPages == 1) {
c0de84e6:	d105      	bne.n	c0de84f4 <displayTagValueListModalPage+0xf0>
        info.navWithButtons.quitText = "Close";
c0de84e8:	f642 10e2 	movw	r0, #10722	@ 0x29e2
c0de84ec:	f2c0 0000 	movt	r0, #0
c0de84f0:	4478      	add	r0, pc
c0de84f2:	9016      	str	r0, [sp, #88]	@ 0x58
    if (modalPageContext != NULL) {
c0de84f4:	f240 665c 	movw	r6, #1628	@ 0x65c
c0de84f8:	f2c0 0600 	movt	r6, #0
c0de84fc:	f859 0006 	ldr.w	r0, [r9, r6]
c0de8500:	2800      	cmp	r0, #0
        nbgl_pageRelease(modalPageContext);
c0de8502:	bf18      	it	ne
c0de8504:	f7fd fe67 	blne	c0de61d6 <nbgl_pageRelease>
    modalPageContext = nbgl_pageDrawGenericContentExt(&pageModalCallback, &info, &content, true);
c0de8508:	f24f 1069 	movw	r0, #61801	@ 0xf169
c0de850c:	f6cf 70ff 	movt	r0, #65535	@ 0xffff
c0de8510:	4478      	add	r0, pc
c0de8512:	a911      	add	r1, sp, #68	@ 0x44
c0de8514:	aa01      	add	r2, sp, #4
c0de8516:	2301      	movs	r3, #1
c0de8518:	2501      	movs	r5, #1
c0de851a:	f7fd fbb9 	bl	c0de5c90 <nbgl_pageDrawGenericContentExt>
c0de851e:	f849 0006 	str.w	r0, [r9, r6]
c0de8522:	f1b8 0f00 	cmp.w	r8, #0
c0de8526:	bf18      	it	ne
c0de8528:	2502      	movne	r5, #2
c0de852a:	4628      	mov	r0, r5
c0de852c:	f000 fae4 	bl	c0de8af8 <nbgl_refreshSpecial>
}
c0de8530:	b018      	add	sp, #96	@ 0x60
c0de8532:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}

c0de8536 <buffer_copy>:

    return true;
}

bool buffer_copy(const buffer_t *buffer, uint8_t *out, size_t out_len)
{
c0de8536:	b5b0      	push	{r4, r5, r7, lr}
    if (buffer->size - buffer->offset > out_len) {
c0de8538:	e9d0 5301 	ldrd	r5, r3, [r0, #4]
c0de853c:	4614      	mov	r4, r2
c0de853e:	1aed      	subs	r5, r5, r3
c0de8540:	4295      	cmp	r5, r2
c0de8542:	d806      	bhi.n	c0de8552 <buffer_copy+0x1c>
        return false;
    }

    memmove(out, buffer->ptr + buffer->offset, buffer->size - buffer->offset);
c0de8544:	6800      	ldr	r0, [r0, #0]
c0de8546:	18c2      	adds	r2, r0, r3
c0de8548:	4608      	mov	r0, r1
c0de854a:	4611      	mov	r1, r2
c0de854c:	462a      	mov	r2, r5
c0de854e:	f001 fc2d 	bl	c0de9dac <__aeabi_memmove>
c0de8552:	2000      	movs	r0, #0
    if (buffer->size - buffer->offset > out_len) {
c0de8554:	42a5      	cmp	r5, r4
c0de8556:	bf98      	it	ls
c0de8558:	2001      	movls	r0, #1

    return true;
}
c0de855a:	bdb0      	pop	{r4, r5, r7, pc}

c0de855c <app_ticker_event_callback>:
    io_seph_ux_display_bagl_element(element);
}
#endif  // HAVE_BAGL

// This function can be used to declare a callback to SEPROXYHAL_TAG_TICKER_EVENT in the application
WEAK void app_ticker_event_callback(void) {}
c0de855c:	4770      	bx	lr

c0de855e <io_event>:

WEAK unsigned char io_event(unsigned char channel)
{
c0de855e:	b580      	push	{r7, lr}
    UNUSED(channel);
    switch (G_io_seproxyhal_spi_buffer[0]) {
c0de8560:	f640 0070 	movw	r0, #2160	@ 0x870
c0de8564:	f2c0 0000 	movt	r0, #0
c0de8568:	f819 1000 	ldrb.w	r1, [r9, r0]
c0de856c:	2905      	cmp	r1, #5
c0de856e:	d010      	beq.n	c0de8592 <io_event+0x34>
c0de8570:	290e      	cmp	r1, #14
c0de8572:	d006      	beq.n	c0de8582 <io_event+0x24>
c0de8574:	290c      	cmp	r1, #12
c0de8576:	d10a      	bne.n	c0de858e <io_event+0x30>
        case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT:
            UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
            break;
#ifdef HAVE_SE_TOUCH
        case SEPROXYHAL_TAG_FINGER_EVENT:
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0de8578:	4448      	add	r0, r9
c0de857a:	f000 f904 	bl	c0de8786 <ux_process_finger_event>
        default:
            UX_DEFAULT_EVENT();
            break;
    }

    return 1;
c0de857e:	2001      	movs	r0, #1
c0de8580:	bd80      	pop	{r7, pc}
            app_ticker_event_callback();
c0de8582:	f7ff ffeb 	bl	c0de855c <app_ticker_event_callback>
            UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, {});
c0de8586:	f000 f950 	bl	c0de882a <ux_process_ticker_event>
    return 1;
c0de858a:	2001      	movs	r0, #1
c0de858c:	bd80      	pop	{r7, pc}
            UX_DEFAULT_EVENT();
c0de858e:	f000 f9aa 	bl	c0de88e6 <ux_process_default_event>
    return 1;
c0de8592:	2001      	movs	r0, #1
c0de8594:	bd80      	pop	{r7, pc}

c0de8596 <io_init>:
}

WEAK void io_init()
{
    need_to_start_io = 1;
c0de8596:	f640 1080 	movw	r0, #2432	@ 0x980
c0de859a:	f2c0 0000 	movt	r0, #0
c0de859e:	2101      	movs	r1, #1
c0de85a0:	f809 1000 	strb.w	r1, [r9, r0]
}
c0de85a4:	4770      	bx	lr
	...

c0de85a8 <io_recv_command>:

WEAK int io_recv_command()
{
c0de85a8:	b510      	push	{r4, lr}
    int status = 0;

    if (need_to_start_io) {
c0de85aa:	f640 1480 	movw	r4, #2432	@ 0x980
c0de85ae:	f2c0 0400 	movt	r4, #0
c0de85b2:	f819 0004 	ldrb.w	r0, [r9, r4]
c0de85b6:	2801      	cmp	r0, #1
c0de85b8:	d104      	bne.n	c0de85c4 <io_recv_command+0x1c>
#ifndef USE_OS_IO_STACK
        io_seproxyhal_io_heartbeat();
        io_seproxyhal_io_heartbeat();
        io_seproxyhal_io_heartbeat();
#endif  // USE_OS_IO_STACK
        os_io_start();
c0de85ba:	f001 faaf 	bl	c0de9b1c <os_io_start>
c0de85be:	2000      	movs	r0, #0
        need_to_start_io = 0;
c0de85c0:	f809 0004 	strb.w	r0, [r9, r4]
#ifdef FUZZING
    for (uint8_t retries = 5; retries && status <= 0; retries--) {
#else
    while (status <= 0) {
#endif
        status = io_legacy_apdu_rx(1);
c0de85c4:	2001      	movs	r0, #1
c0de85c6:	f7f8 fca6 	bl	c0de0f16 <io_legacy_apdu_rx>
    while (status <= 0) {
c0de85ca:	2801      	cmp	r0, #1
c0de85cc:	dbfa      	blt.n	c0de85c4 <io_recv_command+0x1c>
    }

    return status;
c0de85ce:	bd10      	pop	{r4, pc}

c0de85d0 <io_send_response_buffers>:
}

WEAK int io_send_response_buffers(const buffer_t *rdatalist, size_t count, uint16_t sw)
{
c0de85d0:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de85d4:	b082      	sub	sp, #8
c0de85d6:	4690      	mov	r8, r2
    int    status = 0;
    size_t length = 0;

    if (rdatalist && count > 0) {
c0de85d8:	2800      	cmp	r0, #0
c0de85da:	d058      	beq.n	c0de868e <io_send_response_buffers+0xbe>
c0de85dc:	460e      	mov	r6, r1
c0de85de:	2900      	cmp	r1, #0
c0de85e0:	d055      	beq.n	c0de868e <io_send_response_buffers+0xbe>
c0de85e2:	4607      	mov	r7, r0
c0de85e4:	f8cd 8004 	str.w	r8, [sp, #4]
c0de85e8:	f04f 0a00 	mov.w	sl, #0
c0de85ec:	f04f 0801 	mov.w	r8, #1
c0de85f0:	2500      	movs	r5, #0
c0de85f2:	bf00      	nop
        for (size_t i = 0; i < count; i++) {
            const buffer_t *rdata = &rdatalist[i];

            if (!buffer_copy(rdata, G_io_tx_buffer + length, sizeof(G_io_tx_buffer) - length - 2)) {
c0de85f4:	f240 007c 	movw	r0, #124	@ 0x7c
c0de85f8:	f2c0 0000 	movt	r0, #0
c0de85fc:	4448      	add	r0, r9
c0de85fe:	1941      	adds	r1, r0, r5
c0de8600:	f240 100f 	movw	r0, #271	@ 0x10f
c0de8604:	1b42      	subs	r2, r0, r5
c0de8606:	4638      	mov	r0, r7
c0de8608:	f7ff ff95 	bl	c0de8536 <buffer_copy>
c0de860c:	4604      	mov	r4, r0
c0de860e:	b1a8      	cbz	r0, c0de863c <io_send_response_buffers+0x6c>
                return io_send_sw(SWO_INSUFFICIENT_MEMORY);
            }
            length += rdata->size - rdata->offset;
c0de8610:	e9d7 3001 	ldrd	r3, r0, [r7, #4]
            if (count > 1) {
c0de8614:	2e02      	cmp	r6, #2
            length += rdata->size - rdata->offset;
c0de8616:	eba3 0000 	sub.w	r0, r3, r0
c0de861a:	4405      	add	r5, r0
            if (count > 1) {
c0de861c:	d315      	bcc.n	c0de864a <io_send_response_buffers+0x7a>
                PRINTF("<= FRAG (%u/%u) RData=%.*H\n", i + 1, count, rdata->size, rdata->ptr);
c0de861e:	f8d7 c000 	ldr.w	ip, [r7]
c0de8622:	f642 1071 	movw	r0, #10609	@ 0x2971
c0de8626:	f2c0 0000 	movt	r0, #0
c0de862a:	f10a 0101 	add.w	r1, sl, #1
c0de862e:	4478      	add	r0, pc
c0de8630:	4632      	mov	r2, r6
c0de8632:	f8cd c000 	str.w	ip, [sp]
c0de8636:	f000 faf9 	bl	c0de8c2c <mcu_usb_printf>
c0de863a:	e006      	b.n	c0de864a <io_send_response_buffers+0x7a>
    return io_send_response_buffers(NULL, 0, sw);
c0de863c:	2000      	movs	r0, #0
c0de863e:	2100      	movs	r1, #0
c0de8640:	f646 2284 	movw	r2, #27268	@ 0x6a84
c0de8644:	f7ff ffc4 	bl	c0de85d0 <io_send_response_buffers>
c0de8648:	4683      	mov	fp, r0
c0de864a:	b15c      	cbz	r4, c0de8664 <io_send_response_buffers+0x94>
c0de864c:	f10a 0a01 	add.w	sl, sl, #1
        for (size_t i = 0; i < count; i++) {
c0de8650:	45b2      	cmp	sl, r6
c0de8652:	f04f 0800 	mov.w	r8, #0
c0de8656:	bf38      	it	cc
c0de8658:	f04f 0801 	movcc.w	r8, #1
c0de865c:	4556      	cmp	r6, sl
c0de865e:	f107 070c 	add.w	r7, r7, #12
c0de8662:	d1c7      	bne.n	c0de85f4 <io_send_response_buffers+0x24>
c0de8664:	ea5f 70c8 	movs.w	r0, r8, lsl #31
c0de8668:	d12c      	bne.n	c0de86c4 <io_send_response_buffers+0xf4>
            }
        }
        PRINTF("<= SW=%04X | RData=%.*H\n", sw, length, G_io_tx_buffer);
c0de866a:	f240 007c 	movw	r0, #124	@ 0x7c
c0de866e:	f2c0 0000 	movt	r0, #0
c0de8672:	eb09 0300 	add.w	r3, r9, r0
c0de8676:	f642 002f 	movw	r0, #10287	@ 0x282f
c0de867a:	f2c0 0000 	movt	r0, #0
c0de867e:	f8dd 8004 	ldr.w	r8, [sp, #4]
c0de8682:	4478      	add	r0, pc
c0de8684:	4641      	mov	r1, r8
c0de8686:	462a      	mov	r2, r5
c0de8688:	f000 fad0 	bl	c0de8c2c <mcu_usb_printf>
c0de868c:	e008      	b.n	c0de86a0 <io_send_response_buffers+0xd0>
    }
    else {
        PRINTF("<= SW=%04X | RData=\n", sw);
c0de868e:	f642 30de 	movw	r0, #11230	@ 0x2bde
c0de8692:	f2c0 0000 	movt	r0, #0
c0de8696:	4478      	add	r0, pc
c0de8698:	4641      	mov	r1, r8
c0de869a:	f000 fac7 	bl	c0de8c2c <mcu_usb_printf>
c0de869e:	2500      	movs	r5, #0
    }

    write_u16_be(G_io_tx_buffer, length, sw);
c0de86a0:	f240 007c 	movw	r0, #124	@ 0x7c
c0de86a4:	f2c0 0000 	movt	r0, #0
c0de86a8:	eb09 0400 	add.w	r4, r9, r0
c0de86ac:	4620      	mov	r0, r4
c0de86ae:	4629      	mov	r1, r5
c0de86b0:	4642      	mov	r2, r8
c0de86b2:	f000 f861 	bl	c0de8778 <write_u16_be>
            os_sched_exit(-1);
        }
    }
#endif  // HAVE_SWAP

    status = io_legacy_apdu_tx(G_io_tx_buffer, length);
c0de86b6:	1ca8      	adds	r0, r5, #2
c0de86b8:	b281      	uxth	r1, r0
c0de86ba:	4620      	mov	r0, r4
c0de86bc:	f7f8 fc0d 	bl	c0de0eda <io_legacy_apdu_tx>

    if (status < 0) {
c0de86c0:	ea40 7be0 	orr.w	fp, r0, r0, asr #31
        status = -1;
    }

    return status;
}
c0de86c4:	4658      	mov	r0, fp
c0de86c6:	b002      	add	sp, #8
c0de86c8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de86cc <app_exit>:
    os_sched_exit(-1);
c0de86cc:	20ff      	movs	r0, #255	@ 0xff
c0de86ce:	f001 fa0f 	bl	c0de9af0 <os_sched_exit>

c0de86d2 <common_app_init>:
{
c0de86d2:	b580      	push	{r7, lr}
    UX_INIT();
c0de86d4:	f000 fa1a 	bl	c0de8b0c <nbgl_objInit>
    io_seproxyhal_init();
c0de86d8:	f7f8 fd66 	bl	c0de11a8 <io_seproxyhal_init>
}
c0de86dc:	bd80      	pop	{r7, pc}

c0de86de <standalone_app_main>:
{
c0de86de:	b510      	push	{r4, lr}
c0de86e0:	b08c      	sub	sp, #48	@ 0x30
    PRINTF("standalone_app_main\n");
c0de86e2:	f642 20c0 	movw	r0, #10944	@ 0x2ac0
c0de86e6:	f2c0 0000 	movt	r0, #0
c0de86ea:	4478      	add	r0, pc
c0de86ec:	f000 fa9e 	bl	c0de8c2c <mcu_usb_printf>
c0de86f0:	466c      	mov	r4, sp
        TRY
c0de86f2:	4620      	mov	r0, r4
c0de86f4:	f001 fbb6 	bl	c0de9e64 <setjmp>
c0de86f8:	0401      	lsls	r1, r0, #16
c0de86fa:	f8ad 002c 	strh.w	r0, [sp, #44]	@ 0x2c
c0de86fe:	d113      	bne.n	c0de8728 <standalone_app_main+0x4a>
c0de8700:	4620      	mov	r0, r4
c0de8702:	f001 fa45 	bl	c0de9b90 <try_context_set>
c0de8706:	900a      	str	r0, [sp, #40]	@ 0x28
            common_app_init();
c0de8708:	f7ff ffe3 	bl	c0de86d2 <common_app_init>
            app_main();
c0de870c:	f7f7 fcfa 	bl	c0de0104 <app_main>
        FINALLY {}
c0de8710:	f001 fa34 	bl	c0de9b7c <try_context_get>
c0de8714:	42a0      	cmp	r0, r4
c0de8716:	d102      	bne.n	c0de871e <standalone_app_main+0x40>
c0de8718:	980a      	ldr	r0, [sp, #40]	@ 0x28
c0de871a:	f001 fa39 	bl	c0de9b90 <try_context_set>
    END_TRY;
c0de871e:	f8bd 002c 	ldrh.w	r0, [sp, #44]	@ 0x2c
c0de8722:	b958      	cbnz	r0, c0de873c <standalone_app_main+0x5e>
    app_exit();
c0de8724:	f7ff ffd2 	bl	c0de86cc <app_exit>
        CATCH_OTHER(e)
c0de8728:	980a      	ldr	r0, [sp, #40]	@ 0x28
c0de872a:	2100      	movs	r1, #0
c0de872c:	f8ad 102c 	strh.w	r1, [sp, #44]	@ 0x2c
c0de8730:	f001 fa2e 	bl	c0de9b90 <try_context_set>
            os_io_stop();
c0de8734:	f001 f9fe 	bl	c0de9b34 <os_io_stop>
            assert_display_exit();
c0de8738:	f000 f9b6 	bl	c0de8aa8 <assert_display_exit>
    END_TRY;
c0de873c:	f000 fa5d 	bl	c0de8bfa <os_longjmp>

c0de8740 <apdu_parser>:
#include "offsets.h"

bool apdu_parser(command_t *cmd, uint8_t *buf, size_t buf_len)
{
    // Check minimum length, CLA / INS / P1 and P2 are mandatory
    if (buf_len < OFFSET_LC) {
c0de8740:	2a04      	cmp	r2, #4
c0de8742:	d317      	bcc.n	c0de8774 <apdu_parser+0x34>
        return false;
    }

    if (buf_len == OFFSET_LC) {
c0de8744:	d102      	bne.n	c0de874c <apdu_parser+0xc>
c0de8746:	2200      	movs	r2, #0
        // Lc field not specified, implies lc = 0
        cmd->lc = 0;
c0de8748:	7102      	strb	r2, [r0, #4]
c0de874a:	e004      	b.n	c0de8756 <apdu_parser+0x16>
    }
    else {
        // Lc field specified, check value against received length
        cmd->lc = buf[OFFSET_LC];
c0de874c:	790b      	ldrb	r3, [r1, #4]
        if (buf_len - OFFSET_CDATA != cmd->lc) {
c0de874e:	3a05      	subs	r2, #5
c0de8750:	429a      	cmp	r2, r3
        cmd->lc = buf[OFFSET_LC];
c0de8752:	7103      	strb	r3, [r0, #4]
        if (buf_len - OFFSET_CDATA != cmd->lc) {
c0de8754:	d10e      	bne.n	c0de8774 <apdu_parser+0x34>
            return false;
        }
    }

    cmd->cla  = buf[OFFSET_CLA];
c0de8756:	780a      	ldrb	r2, [r1, #0]
    cmd->ins  = buf[OFFSET_INS];
    cmd->p1   = buf[OFFSET_P1];
    cmd->p2   = buf[OFFSET_P2];
    cmd->data = (cmd->lc > 0) ? buf + OFFSET_CDATA : NULL;
c0de8758:	7903      	ldrb	r3, [r0, #4]
    cmd->cla  = buf[OFFSET_CLA];
c0de875a:	7002      	strb	r2, [r0, #0]
    cmd->ins  = buf[OFFSET_INS];
c0de875c:	784a      	ldrb	r2, [r1, #1]
    cmd->data = (cmd->lc > 0) ? buf + OFFSET_CDATA : NULL;
c0de875e:	2b00      	cmp	r3, #0
    cmd->ins  = buf[OFFSET_INS];
c0de8760:	7042      	strb	r2, [r0, #1]
    cmd->p1   = buf[OFFSET_P1];
c0de8762:	788a      	ldrb	r2, [r1, #2]
c0de8764:	7082      	strb	r2, [r0, #2]
    cmd->p2   = buf[OFFSET_P2];
c0de8766:	78ca      	ldrb	r2, [r1, #3]
c0de8768:	70c2      	strb	r2, [r0, #3]
    cmd->data = (cmd->lc > 0) ? buf + OFFSET_CDATA : NULL;
c0de876a:	bf18      	it	ne
c0de876c:	1d4b      	addne	r3, r1, #5
c0de876e:	6083      	str	r3, [r0, #8]
c0de8770:	2001      	movs	r0, #1

    return true;
}
c0de8772:	4770      	bx	lr
c0de8774:	2000      	movs	r0, #0
c0de8776:	4770      	bx	lr

c0de8778 <write_u16_be>:
#include <stdint.h>  // uint*_t
#include <stddef.h>  // size_t

void write_u16_be(uint8_t *ptr, size_t offset, uint16_t value)
{
    ptr[offset + 0] = (uint8_t) (value >> 8);
c0de8778:	0a13      	lsrs	r3, r2, #8
c0de877a:	eb00 0c01 	add.w	ip, r0, r1
c0de877e:	5443      	strb	r3, [r0, r1]
    ptr[offset + 1] = (uint8_t) (value >> 0);
c0de8780:	f88c 2001 	strb.w	r2, [ip, #1]
}
c0de8784:	4770      	bx	lr

c0de8786 <ux_process_finger_event>:
 * event caught by BOLOS UX page).
 *
 * @param seph_packet received SEPH packet
 */
void ux_process_finger_event(const uint8_t seph_packet[])
{
c0de8786:	b5b0      	push	{r4, r5, r7, lr}
c0de8788:	4604      	mov	r4, r0
    G_ux_params.ux_id = BOLOS_UX_EVENT;
c0de878a:	f640 1084 	movw	r0, #2436	@ 0x984
c0de878e:	f2c0 0000 	movt	r0, #0
c0de8792:	2101      	movs	r1, #1
c0de8794:	f809 1000 	strb.w	r1, [r9, r0]
c0de8798:	eb09 0500 	add.w	r5, r9, r0
c0de879c:	2000      	movs	r0, #0
    G_ux_params.len   = 0;
c0de879e:	6068      	str	r0, [r5, #4]
    os_ux(&G_ux_params);
c0de87a0:	4628      	mov	r0, r5
c0de87a2:	f001 f976 	bl	c0de9a92 <os_ux>
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de87a6:	2004      	movs	r0, #4
c0de87a8:	f001 fa00 	bl	c0de9bac <os_sched_last_status>
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de87ac:	2869      	cmp	r0, #105	@ 0x69
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de87ae:	6068      	str	r0, [r5, #4]
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de87b0:	d108      	bne.n	c0de87c4 <ux_process_finger_event+0x3e>
        nbgl_objAllowDrawing(true);
c0de87b2:	2001      	movs	r0, #1
c0de87b4:	f000 f9b4 	bl	c0de8b20 <nbgl_objAllowDrawing>
        nbgl_screenRedraw();
c0de87b8:	f000 f9c1 	bl	c0de8b3e <nbgl_screenRedraw>
        nbgl_refresh();
c0de87bc:	f000 f997 	bl	c0de8aee <nbgl_refresh>
c0de87c0:	2500      	movs	r5, #0
c0de87c2:	e008      	b.n	c0de87d6 <ux_process_finger_event+0x50>
             || ((G_ux_params.len != BOLOS_UX_IGNORE) && (G_ux_params.len != BOLOS_UX_CONTINUE))) {
c0de87c4:	f1b0 0197 	subs.w	r1, r0, #151	@ 0x97
c0de87c8:	bf18      	it	ne
c0de87ca:	2101      	movne	r1, #1
c0de87cc:	2800      	cmp	r0, #0
c0de87ce:	bf18      	it	ne
c0de87d0:	2001      	movne	r0, #1
c0de87d2:	ea01 0500 	and.w	r5, r1, r0
    bool displayEnabled = ux_forward_event(true);
    // enable/disable drawing according to UX decision
    nbgl_objAllowDrawing(displayEnabled);
c0de87d6:	4628      	mov	r0, r5
c0de87d8:	f000 f9a2 	bl	c0de8b20 <nbgl_objAllowDrawing>

    // if the event is not fully consumed by UX, use it for NBGL
    if (displayEnabled) {
c0de87dc:	2d00      	cmp	r5, #0
        pos.swipe = seph_packet[10];
#endif  // HAVE_HW_TOUCH_SWIPE
        nbgl_touchHandler(false, &pos, nbTicks * 100);
        nbgl_refresh();
    }
}
c0de87de:	bf08      	it	eq
c0de87e0:	bdb0      	popeq	{r4, r5, r7, pc}
        pos.state = (seph_packet[3] == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) ? PRESSED : RELEASED;
c0de87e2:	78e0      	ldrb	r0, [r4, #3]
        pos.x     = (seph_packet[4] << 8) + seph_packet[5];
c0de87e4:	7922      	ldrb	r2, [r4, #4]
        pos.state = (seph_packet[3] == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) ? PRESSED : RELEASED;
c0de87e6:	3801      	subs	r0, #1
        pos.x     = (seph_packet[4] << 8) + seph_packet[5];
c0de87e8:	7963      	ldrb	r3, [r4, #5]
        pos.state = (seph_packet[3] == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) ? PRESSED : RELEASED;
c0de87ea:	fab0 f080 	clz	r0, r0
c0de87ee:	f640 11a6 	movw	r1, #2470	@ 0x9a6
c0de87f2:	0940      	lsrs	r0, r0, #5
c0de87f4:	f2c0 0100 	movt	r1, #0
        pos.y     = (seph_packet[6] << 8) + seph_packet[7];
c0de87f8:	79a5      	ldrb	r5, [r4, #6]
        pos.state = (seph_packet[3] == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) ? PRESSED : RELEASED;
c0de87fa:	f809 0001 	strb.w	r0, [r9, r1]
        pos.x     = (seph_packet[4] << 8) + seph_packet[5];
c0de87fe:	ea43 2002 	orr.w	r0, r3, r2, lsl #8
        pos.y     = (seph_packet[6] << 8) + seph_packet[7];
c0de8802:	79e2      	ldrb	r2, [r4, #7]
        pos.state = (seph_packet[3] == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) ? PRESSED : RELEASED;
c0de8804:	4449      	add	r1, r9
        pos.x     = (seph_packet[4] << 8) + seph_packet[5];
c0de8806:	8048      	strh	r0, [r1, #2]
        pos.y     = (seph_packet[6] << 8) + seph_packet[7];
c0de8808:	ea42 2005 	orr.w	r0, r2, r5, lsl #8
c0de880c:	8088      	strh	r0, [r1, #4]
        nbgl_touchHandler(false, &pos, nbTicks * 100);
c0de880e:	f640 10ac 	movw	r0, #2476	@ 0x9ac
c0de8812:	f2c0 0000 	movt	r0, #0
c0de8816:	f859 0000 	ldr.w	r0, [r9, r0]
c0de881a:	2264      	movs	r2, #100	@ 0x64
c0de881c:	4342      	muls	r2, r0
c0de881e:	2000      	movs	r0, #0
c0de8820:	f000 f9d3 	bl	c0de8bca <nbgl_touchHandler>
        nbgl_refresh();
c0de8824:	f000 f963 	bl	c0de8aee <nbgl_refresh>
}
c0de8828:	bdb0      	pop	{r4, r5, r7, pc}

c0de882a <ux_process_ticker_event>:
 * @brief Process the ticker_event to the os ux handler. Ticker event callback is always called
 * whatever the return code of the ux app.
 * @note Ticker event interval is assumed to be 100 ms.
 */
void ux_process_ticker_event(void)
{
c0de882a:	b570      	push	{r4, r5, r6, lr}
c0de882c:	b082      	sub	sp, #8
    nbTicks++;
c0de882e:	f640 15ac 	movw	r5, #2476	@ 0x9ac
c0de8832:	f2c0 0500 	movt	r5, #0
c0de8836:	f859 0005 	ldr.w	r0, [r9, r5]
c0de883a:	2101      	movs	r1, #1
c0de883c:	3001      	adds	r0, #1
c0de883e:	f849 0005 	str.w	r0, [r9, r5]
    G_ux_params.ux_id = BOLOS_UX_EVENT;
c0de8842:	f640 1084 	movw	r0, #2436	@ 0x984
c0de8846:	f2c0 0000 	movt	r0, #0
c0de884a:	f809 1000 	strb.w	r1, [r9, r0]
c0de884e:	eb09 0400 	add.w	r4, r9, r0
c0de8852:	2000      	movs	r0, #0
    G_ux_params.len   = 0;
c0de8854:	6060      	str	r0, [r4, #4]
    os_ux(&G_ux_params);
c0de8856:	4620      	mov	r0, r4
c0de8858:	f001 f91b 	bl	c0de9a92 <os_ux>
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de885c:	2004      	movs	r0, #4
c0de885e:	f001 f9a5 	bl	c0de9bac <os_sched_last_status>
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de8862:	2869      	cmp	r0, #105	@ 0x69
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de8864:	6060      	str	r0, [r4, #4]
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de8866:	d108      	bne.n	c0de887a <ux_process_ticker_event+0x50>
        nbgl_objAllowDrawing(true);
c0de8868:	2001      	movs	r0, #1
c0de886a:	f000 f959 	bl	c0de8b20 <nbgl_objAllowDrawing>
        nbgl_screenRedraw();
c0de886e:	f000 f966 	bl	c0de8b3e <nbgl_screenRedraw>
        nbgl_refresh();
c0de8872:	f000 f93c 	bl	c0de8aee <nbgl_refresh>
c0de8876:	2400      	movs	r4, #0
c0de8878:	e008      	b.n	c0de888c <ux_process_ticker_event+0x62>
             || ((G_ux_params.len != BOLOS_UX_IGNORE) && (G_ux_params.len != BOLOS_UX_CONTINUE))) {
c0de887a:	f1b0 0197 	subs.w	r1, r0, #151	@ 0x97
c0de887e:	bf18      	it	ne
c0de8880:	2101      	movne	r1, #1
c0de8882:	2800      	cmp	r0, #0
c0de8884:	bf18      	it	ne
c0de8886:	2001      	movne	r0, #1
c0de8888:	ea01 0400 	and.w	r4, r1, r0
    // forward to UX
    bool displayEnabled = ux_forward_event(true);

    // enable/disable drawing according to UX decision
    nbgl_objAllowDrawing(displayEnabled);
c0de888c:	4620      	mov	r0, r4
c0de888e:	f000 f947 	bl	c0de8b20 <nbgl_objAllowDrawing>

    // do not do any action on screens if display is disabled, because
    // UX has the hand
    if (!displayEnabled) {
c0de8892:	b334      	cbz	r4, c0de88e2 <ux_process_ticker_event+0xb8>
        return;
    }

    // update ticker in NBGL
    nbgl_screenHandler(100);
c0de8894:	2064      	movs	r0, #100	@ 0x64
c0de8896:	2464      	movs	r4, #100	@ 0x64
c0de8898:	f000 f960 	bl	c0de8b5c <nbgl_screenHandler>

#ifdef HAVE_SE_TOUCH
    // handle touch only if detected as pressed in last touch message
    if (pos.state == PRESSED) {
c0de889c:	f640 16a6 	movw	r6, #2470	@ 0x9a6
c0de88a0:	f2c0 0600 	movt	r6, #0
c0de88a4:	f819 0006 	ldrb.w	r0, [r9, r6]
c0de88a8:	2801      	cmp	r0, #1
c0de88aa:	d118      	bne.n	c0de88de <ux_process_ticker_event+0xb4>
c0de88ac:	4668      	mov	r0, sp
        io_touch_info_t touch_info;
        touch_get_last_info(&touch_info);
c0de88ae:	f001 f98b 	bl	c0de9bc8 <touch_get_last_info>
        pos.state = (touch_info.state == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) ? PRESSED : RELEASED;
c0de88b2:	f89d 0004 	ldrb.w	r0, [sp, #4]
c0de88b6:	eb09 0106 	add.w	r1, r9, r6
c0de88ba:	3801      	subs	r0, #1
c0de88bc:	fab0 f080 	clz	r0, r0
c0de88c0:	0940      	lsrs	r0, r0, #5
c0de88c2:	f809 0006 	strb.w	r0, [r9, r6]
        pos.x     = touch_info.x;
c0de88c6:	f8bd 0000 	ldrh.w	r0, [sp]
        pos.y     = touch_info.y;
        // Send current touch position to nbgl
        nbgl_touchHandler(false, &pos, nbTicks * 100);
c0de88ca:	f859 2005 	ldr.w	r2, [r9, r5]
        pos.x     = touch_info.x;
c0de88ce:	8048      	strh	r0, [r1, #2]
        pos.y     = touch_info.y;
c0de88d0:	f8bd 0002 	ldrh.w	r0, [sp, #2]
        nbgl_touchHandler(false, &pos, nbTicks * 100);
c0de88d4:	4362      	muls	r2, r4
        pos.y     = touch_info.y;
c0de88d6:	8088      	strh	r0, [r1, #4]
        nbgl_touchHandler(false, &pos, nbTicks * 100);
c0de88d8:	2000      	movs	r0, #0
c0de88da:	f000 f976 	bl	c0de8bca <nbgl_touchHandler>
    }
#endif  // HAVE_SE_TOUCH
    nbgl_refresh();
c0de88de:	f000 f906 	bl	c0de8aee <nbgl_refresh>
}
c0de88e2:	b002      	add	sp, #8
c0de88e4:	bd70      	pop	{r4, r5, r6, pc}

c0de88e6 <ux_process_default_event>:

/**
 * Forwards the event to UX
 */
void ux_process_default_event(void)
{
c0de88e6:	b510      	push	{r4, lr}
    G_ux_params.ux_id = BOLOS_UX_EVENT;
c0de88e8:	f640 1084 	movw	r0, #2436	@ 0x984
c0de88ec:	f2c0 0000 	movt	r0, #0
c0de88f0:	2101      	movs	r1, #1
c0de88f2:	f809 1000 	strb.w	r1, [r9, r0]
c0de88f6:	eb09 0400 	add.w	r4, r9, r0
c0de88fa:	2000      	movs	r0, #0
    G_ux_params.len   = 0;
c0de88fc:	6060      	str	r0, [r4, #4]
    os_ux(&G_ux_params);
c0de88fe:	4620      	mov	r0, r4
c0de8900:	f001 f8c7 	bl	c0de9a92 <os_ux>
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de8904:	2004      	movs	r0, #4
c0de8906:	f001 f951 	bl	c0de9bac <os_sched_last_status>
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de890a:	2869      	cmp	r0, #105	@ 0x69
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de890c:	6060      	str	r0, [r4, #4]
    // forward to UX
    ux_forward_event(false);
}
c0de890e:	bf18      	it	ne
c0de8910:	bd10      	popne	{r4, pc}
        nbgl_objAllowDrawing(true);
c0de8912:	2001      	movs	r0, #1
c0de8914:	f000 f904 	bl	c0de8b20 <nbgl_objAllowDrawing>
        nbgl_screenRedraw();
c0de8918:	f000 f911 	bl	c0de8b3e <nbgl_screenRedraw>
        nbgl_refresh();
c0de891c:	f000 f8e7 	bl	c0de8aee <nbgl_refresh>
}
c0de8920:	bd10      	pop	{r4, pc}

c0de8922 <cx_aes_gcm_check_tag>:
c0de8922:	b403      	push	{r0, r1}
c0de8924:	f04f 0002 	mov.w	r0, #2
c0de8928:	f000 b82c 	b.w	c0de8984 <cx_trampoline_helper>

c0de892c <cx_aes_gcm_finish>:
c0de892c:	b403      	push	{r0, r1}
c0de892e:	f04f 0005 	mov.w	r0, #5
c0de8932:	f000 b827 	b.w	c0de8984 <cx_trampoline_helper>

c0de8936 <cx_aes_gcm_init>:
c0de8936:	b403      	push	{r0, r1}
c0de8938:	f04f 0006 	mov.w	r0, #6
c0de893c:	f000 b822 	b.w	c0de8984 <cx_trampoline_helper>

c0de8940 <cx_aes_gcm_set_key>:
c0de8940:	b403      	push	{r0, r1}
c0de8942:	f04f 0007 	mov.w	r0, #7
c0de8946:	f000 b81d 	b.w	c0de8984 <cx_trampoline_helper>

c0de894a <cx_aes_gcm_start>:
c0de894a:	b403      	push	{r0, r1}
c0de894c:	f04f 0008 	mov.w	r0, #8
c0de8950:	f000 b818 	b.w	c0de8984 <cx_trampoline_helper>

c0de8954 <cx_aes_gcm_update_aad>:
c0de8954:	b403      	push	{r0, r1}
c0de8956:	f04f 0009 	mov.w	r0, #9
c0de895a:	f000 b813 	b.w	c0de8984 <cx_trampoline_helper>

c0de895e <cx_aes_gcm_update>:
c0de895e:	b403      	push	{r0, r1}
c0de8960:	f04f 000a 	mov.w	r0, #10
c0de8964:	f000 b80e 	b.w	c0de8984 <cx_trampoline_helper>

c0de8968 <cx_hmac_sha256>:
c0de8968:	b403      	push	{r0, r1}
c0de896a:	f04f 0050 	mov.w	r0, #80	@ 0x50
c0de896e:	f000 b809 	b.w	c0de8984 <cx_trampoline_helper>

c0de8972 <cx_rng_no_throw>:
c0de8972:	b403      	push	{r0, r1}
c0de8974:	f04f 006a 	mov.w	r0, #106	@ 0x6a
c0de8978:	f000 b804 	b.w	c0de8984 <cx_trampoline_helper>

c0de897c <cx_aes_siv_reset>:
c0de897c:	b403      	push	{r0, r1}
c0de897e:	f04f 0090 	mov.w	r0, #144	@ 0x90
c0de8982:	e7ff      	b.n	c0de8984 <cx_trampoline_helper>

c0de8984 <cx_trampoline_helper>:
c0de8984:	4900      	ldr	r1, [pc, #0]	@ (c0de8988 <cx_trampoline_helper+0x4>)
c0de8986:	4708      	bx	r1
c0de8988:	00808001 	.word	0x00808001

c0de898c <assert_display_lr_and_pc>:
 * Define behavior when LEDGER_ASSERT_CONFIG_LR_AND_PC_INFO *
 ***********************************************************/
#ifdef LEDGER_ASSERT_CONFIG_LR_AND_PC_INFO
#ifdef HAVE_LEDGER_ASSERT_DISPLAY
void assert_display_lr_and_pc(int lr, int pc)
{
c0de898c:	b570      	push	{r4, r5, r6, lr}
c0de898e:	b08a      	sub	sp, #40	@ 0x28
c0de8990:	460c      	mov	r4, r1
    char buff[LR_AND_PC_SIZE];

    lr = compute_address_location(lr);
c0de8992:	f000 f940 	bl	c0de8c16 <compute_address_location>
c0de8996:	4605      	mov	r5, r0
    pc = compute_address_location(pc);
c0de8998:	4620      	mov	r0, r4
c0de899a:	f000 f93c 	bl	c0de8c16 <compute_address_location>
    snprintf(buff, LR_AND_PC_SIZE, "LR=0x%08X\n PC=0x%08X\n", lr, pc);
c0de899e:	f642 02f0 	movw	r2, #10480	@ 0x28f0
c0de89a2:	f2c0 0200 	movt	r2, #0
c0de89a6:	f10d 060a 	add.w	r6, sp, #10
    pc = compute_address_location(pc);
c0de89aa:	4604      	mov	r4, r0
    snprintf(buff, LR_AND_PC_SIZE, "LR=0x%08X\n PC=0x%08X\n", lr, pc);
c0de89ac:	447a      	add	r2, pc
c0de89ae:	4630      	mov	r0, r6
c0de89b0:	211e      	movs	r1, #30
c0de89b2:	462b      	mov	r3, r5
c0de89b4:	9400      	str	r4, [sp, #0]
c0de89b6:	f000 ff83 	bl	c0de98c0 <snprintf>
    strncat(assert_buffer, buff, LR_AND_PC_SIZE);
c0de89ba:	f640 10b0 	movw	r0, #2480	@ 0x9b0
c0de89be:	f2c0 0000 	movt	r0, #0
c0de89c2:	4448      	add	r0, r9
c0de89c4:	4631      	mov	r1, r6
c0de89c6:	221e      	movs	r2, #30
c0de89c8:	f001 fa62 	bl	c0de9e90 <strncat>
}
c0de89cc:	b00a      	add	sp, #40	@ 0x28
c0de89ce:	bd70      	pop	{r4, r5, r6, pc}

c0de89d0 <assert_print_lr_and_pc>:
#endif

#ifdef HAVE_PRINTF
void assert_print_lr_and_pc(int lr, int pc)
{
c0de89d0:	b5b0      	push	{r4, r5, r7, lr}
c0de89d2:	460c      	mov	r4, r1
    lr = compute_address_location(lr);
c0de89d4:	f000 f91f 	bl	c0de8c16 <compute_address_location>
c0de89d8:	4605      	mov	r5, r0
    pc = compute_address_location(pc);
c0de89da:	4620      	mov	r0, r4
c0de89dc:	f000 f91b 	bl	c0de8c16 <compute_address_location>
c0de89e0:	4604      	mov	r4, r0
    PRINTF("=> LR: 0x%08X \n", lr);
c0de89e2:	f642 100a 	movw	r0, #10506	@ 0x290a
c0de89e6:	f2c0 0000 	movt	r0, #0
c0de89ea:	4478      	add	r0, pc
c0de89ec:	4629      	mov	r1, r5
c0de89ee:	f000 f91d 	bl	c0de8c2c <mcu_usb_printf>
    PRINTF("=> PC: 0x%08X \n", pc);
c0de89f2:	f242 6009 	movw	r0, #9737	@ 0x2609
c0de89f6:	f2c0 0000 	movt	r0, #0
c0de89fa:	4478      	add	r0, pc
c0de89fc:	4621      	mov	r1, r4
c0de89fe:	f000 f915 	bl	c0de8c2c <mcu_usb_printf>
}
c0de8a02:	bdb0      	pop	{r4, r5, r7, pc}

c0de8a04 <assert_display_file_info>:
 * Define behavior when LEDGER_ASSERT_CONFIG_FILE_INFO *
 ******************************************************/
#ifdef LEDGER_ASSERT_CONFIG_FILE_INFO
#ifdef HAVE_LEDGER_ASSERT_DISPLAY
void assert_display_file_info(const char *file, unsigned int line)
{
c0de8a04:	b510      	push	{r4, lr}
c0de8a06:	b08e      	sub	sp, #56	@ 0x38
    char buff[FILE_SIZE];

    snprintf(buff, FILE_SIZE, "%s::%d\n", file, line);
c0de8a08:	f242 62c2 	movw	r2, #9922	@ 0x26c2
c0de8a0c:	f2c0 0200 	movt	r2, #0
c0de8a10:	f10d 0406 	add.w	r4, sp, #6
c0de8a14:	468c      	mov	ip, r1
c0de8a16:	4603      	mov	r3, r0
c0de8a18:	447a      	add	r2, pc
c0de8a1a:	4620      	mov	r0, r4
c0de8a1c:	2132      	movs	r1, #50	@ 0x32
c0de8a1e:	f8cd c000 	str.w	ip, [sp]
c0de8a22:	f000 ff4d 	bl	c0de98c0 <snprintf>
    strncat(assert_buffer, buff, FILE_SIZE);
c0de8a26:	f640 10b0 	movw	r0, #2480	@ 0x9b0
c0de8a2a:	f2c0 0000 	movt	r0, #0
c0de8a2e:	4448      	add	r0, r9
c0de8a30:	4621      	mov	r1, r4
c0de8a32:	2232      	movs	r2, #50	@ 0x32
c0de8a34:	f001 fa2c 	bl	c0de9e90 <strncat>
}
c0de8a38:	b00e      	add	sp, #56	@ 0x38
c0de8a3a:	bd10      	pop	{r4, pc}

c0de8a3c <assert_print_file_info>:
#endif

#ifdef HAVE_PRINTF
void assert_print_file_info(const char *file, int line)
{
c0de8a3c:	b580      	push	{r7, lr}
c0de8a3e:	460a      	mov	r2, r1
c0de8a40:	4601      	mov	r1, r0
    PRINTF("%s::%d \n", file, line);
c0de8a42:	f642 007a 	movw	r0, #10362	@ 0x287a
c0de8a46:	f2c0 0000 	movt	r0, #0
c0de8a4a:	4478      	add	r0, pc
c0de8a4c:	f000 f8ee 	bl	c0de8c2c <mcu_usb_printf>
}
c0de8a50:	bd80      	pop	{r7, pc}

c0de8a52 <throw_display_lr>:
/*************************************
 * Specific mechanism to debug THROW *
 ************************************/
#ifdef HAVE_DEBUG_THROWS
void throw_display_lr(int e, int lr)
{
c0de8a52:	b5b0      	push	{r4, r5, r7, lr}
c0de8a54:	b082      	sub	sp, #8
c0de8a56:	4605      	mov	r5, r0
    lr = compute_address_location(lr);
c0de8a58:	4608      	mov	r0, r1
c0de8a5a:	f000 f8dc 	bl	c0de8c16 <compute_address_location>
c0de8a5e:	4604      	mov	r4, r0
    snprintf(assert_buffer, ASSERT_BUFFER_LEN, "e=0x%04X\n LR=0x%08X\n", e, lr);
c0de8a60:	f640 10b0 	movw	r0, #2480	@ 0x9b0
c0de8a64:	f242 7223 	movw	r2, #10019	@ 0x2723
c0de8a68:	f2c0 0000 	movt	r0, #0
c0de8a6c:	f2c0 0200 	movt	r2, #0
c0de8a70:	4448      	add	r0, r9
c0de8a72:	447a      	add	r2, pc
c0de8a74:	2182      	movs	r1, #130	@ 0x82
c0de8a76:	462b      	mov	r3, r5
c0de8a78:	9400      	str	r4, [sp, #0]
c0de8a7a:	f000 ff21 	bl	c0de98c0 <snprintf>
}
c0de8a7e:	b002      	add	sp, #8
c0de8a80:	bdb0      	pop	{r4, r5, r7, pc}

c0de8a82 <throw_print_lr>:

#ifdef HAVE_PRINTF
void throw_print_lr(int e, int lr)
{
c0de8a82:	b510      	push	{r4, lr}
c0de8a84:	4604      	mov	r4, r0
    lr = compute_address_location(lr);
c0de8a86:	4608      	mov	r0, r1
c0de8a88:	f000 f8c5 	bl	c0de8c16 <compute_address_location>
c0de8a8c:	4602      	mov	r2, r0
    PRINTF("exception[0x%04X]: LR=0x%08X\n", e, lr);
c0de8a8e:	f242 7029 	movw	r0, #10025	@ 0x2729
c0de8a92:	f2c0 0000 	movt	r0, #0
c0de8a96:	4478      	add	r0, pc
c0de8a98:	4621      	mov	r1, r4
c0de8a9a:	f000 f8c7 	bl	c0de8c2c <mcu_usb_printf>
}
c0de8a9e:	bd10      	pop	{r4, pc}

c0de8aa0 <assert_exit>:
 * Common app exit *
 ******************/
void __attribute__((noreturn)) assert_exit(bool confirm)
{
    UNUSED(confirm);
    os_sched_exit(-1);
c0de8aa0:	20ff      	movs	r0, #255	@ 0xff
c0de8aa2:	f001 f825 	bl	c0de9af0 <os_sched_exit>
	...

c0de8aa8 <assert_display_exit>:
           });
UX_FLOW(ux_error_flow, &ux_error);
#endif

void __attribute__((noreturn)) assert_display_exit(void)
{
c0de8aa8:	b082      	sub	sp, #8
#define ICON_APP_WARNING C_Important_Circle_64px
#elif defined(TARGET_APEX)
#define ICON_APP_WARNING C_Important_Circle_48px
#endif

    nbgl_useCaseChoice(
c0de8aaa:	f64f 7cc3 	movw	ip, #65475	@ 0xffc3
c0de8aae:	f6cf 7cff 	movt	ip, #65535	@ 0xffff
c0de8ab2:	f242 331a 	movw	r3, #8986	@ 0x231a
c0de8ab6:	f2c0 0300 	movt	r3, #0
c0de8aba:	f640 10b0 	movw	r0, #2480	@ 0x9b0
c0de8abe:	447b      	add	r3, pc
c0de8ac0:	f2c0 0000 	movt	r0, #0
c0de8ac4:	9300      	str	r3, [sp, #0]
c0de8ac6:	eb09 0200 	add.w	r2, r9, r0
c0de8aca:	f241 70d7 	movw	r0, #6103	@ 0x17d7
c0de8ace:	f2c0 0000 	movt	r0, #0
c0de8ad2:	f242 2139 	movw	r1, #8761	@ 0x2239
c0de8ad6:	f2c0 0100 	movt	r1, #0
c0de8ada:	44fc      	add	ip, pc
c0de8adc:	4478      	add	r0, pc
c0de8ade:	4479      	add	r1, pc
c0de8ae0:	f8cd c004 	str.w	ip, [sp, #4]
c0de8ae4:	f7fe fd5b 	bl	c0de759e <nbgl_useCaseChoice>
        &ICON_APP_WARNING, "App error", assert_buffer, "Exit app", "Exit app", assert_exit);
#endif

    // Block until the user approve and the app is quit
    while (1) {
        io_seproxyhal_io_heartbeat();
c0de8ae8:	f7f8 f9a1 	bl	c0de0e2e <io_seproxyhal_io_heartbeat>
    while (1) {
c0de8aec:	e7fc      	b.n	c0de8ae8 <assert_display_exit+0x40>

c0de8aee <nbgl_refresh>:
c0de8aee:	b403      	push	{r0, r1}
c0de8af0:	f04f 0091 	mov.w	r0, #145	@ 0x91
c0de8af4:	f000 b878 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8af8 <nbgl_refreshSpecial>:
c0de8af8:	b403      	push	{r0, r1}
c0de8afa:	f04f 0092 	mov.w	r0, #146	@ 0x92
c0de8afe:	f000 b873 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b02 <nbgl_refreshSpecialWithPostRefresh>:
c0de8b02:	b403      	push	{r0, r1}
c0de8b04:	f04f 0093 	mov.w	r0, #147	@ 0x93
c0de8b08:	f000 b86e 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b0c <nbgl_objInit>:
c0de8b0c:	b403      	push	{r0, r1}
c0de8b0e:	f04f 0096 	mov.w	r0, #150	@ 0x96
c0de8b12:	f000 b869 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b16 <nbgl_objDraw>:
c0de8b16:	b403      	push	{r0, r1}
c0de8b18:	f04f 0097 	mov.w	r0, #151	@ 0x97
c0de8b1c:	f000 b864 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b20 <nbgl_objAllowDrawing>:
c0de8b20:	b403      	push	{r0, r1}
c0de8b22:	f04f 0098 	mov.w	r0, #152	@ 0x98
c0de8b26:	f000 b85f 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b2a <nbgl_screenSet>:
c0de8b2a:	b403      	push	{r0, r1}
c0de8b2c:	f04f 009b 	mov.w	r0, #155	@ 0x9b
c0de8b30:	f000 b85a 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b34 <nbgl_screenPush>:
c0de8b34:	b403      	push	{r0, r1}
c0de8b36:	f04f 009c 	mov.w	r0, #156	@ 0x9c
c0de8b3a:	f000 b855 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b3e <nbgl_screenRedraw>:
c0de8b3e:	b403      	push	{r0, r1}
c0de8b40:	f04f 009d 	mov.w	r0, #157	@ 0x9d
c0de8b44:	f000 b850 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b48 <nbgl_screenPop>:
c0de8b48:	b403      	push	{r0, r1}
c0de8b4a:	f04f 009e 	mov.w	r0, #158	@ 0x9e
c0de8b4e:	f000 b84b 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b52 <nbgl_screenUpdateTicker>:
c0de8b52:	b403      	push	{r0, r1}
c0de8b54:	f04f 00a4 	mov.w	r0, #164	@ 0xa4
c0de8b58:	f000 b846 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b5c <nbgl_screenHandler>:
c0de8b5c:	b403      	push	{r0, r1}
c0de8b5e:	f04f 00a7 	mov.w	r0, #167	@ 0xa7
c0de8b62:	f000 b841 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b66 <nbgl_objPoolGet>:
c0de8b66:	b403      	push	{r0, r1}
c0de8b68:	f04f 00a8 	mov.w	r0, #168	@ 0xa8
c0de8b6c:	f000 b83c 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b70 <nbgl_containerPoolGet>:
c0de8b70:	b403      	push	{r0, r1}
c0de8b72:	f04f 00aa 	mov.w	r0, #170	@ 0xaa
c0de8b76:	f000 b837 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b7a <nbgl_getFont>:
c0de8b7a:	b403      	push	{r0, r1}
c0de8b7c:	f04f 00ac 	mov.w	r0, #172	@ 0xac
c0de8b80:	f000 b832 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b84 <nbgl_getFontHeight>:
c0de8b84:	b403      	push	{r0, r1}
c0de8b86:	f04f 00ad 	mov.w	r0, #173	@ 0xad
c0de8b8a:	f000 b82d 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b8e <nbgl_getFontLineHeight>:
c0de8b8e:	b403      	push	{r0, r1}
c0de8b90:	f04f 00ae 	mov.w	r0, #174	@ 0xae
c0de8b94:	f000 b828 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8b98 <nbgl_getTextHeightInWidth>:
c0de8b98:	b403      	push	{r0, r1}
c0de8b9a:	f04f 00b2 	mov.w	r0, #178	@ 0xb2
c0de8b9e:	f000 b823 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8ba2 <nbgl_getTextNbLinesInWidth>:
c0de8ba2:	b403      	push	{r0, r1}
c0de8ba4:	f04f 00b4 	mov.w	r0, #180	@ 0xb4
c0de8ba8:	f000 b81e 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8bac <nbgl_getTextWidth>:
c0de8bac:	b403      	push	{r0, r1}
c0de8bae:	f04f 00b6 	mov.w	r0, #182	@ 0xb6
c0de8bb2:	f000 b819 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8bb6 <nbgl_getTextMaxLenInNbLines>:
c0de8bb6:	b403      	push	{r0, r1}
c0de8bb8:	f04f 00b7 	mov.w	r0, #183	@ 0xb7
c0de8bbc:	f000 b814 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8bc0 <nbgl_textReduceOnNbLines>:
c0de8bc0:	b403      	push	{r0, r1}
c0de8bc2:	f04f 00b8 	mov.w	r0, #184	@ 0xb8
c0de8bc6:	f000 b80f 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8bca <nbgl_touchHandler>:
c0de8bca:	b403      	push	{r0, r1}
c0de8bcc:	f04f 00bb 	mov.w	r0, #187	@ 0xbb
c0de8bd0:	f000 b80a 	b.w	c0de8be8 <nbgl_trampoline_helper>

c0de8bd4 <nbgl_touchGetTouchDuration>:
c0de8bd4:	b403      	push	{r0, r1}
c0de8bd6:	f04f 00bc 	mov.w	r0, #188	@ 0xbc
c0de8bda:	f000 b805 	b.w	c0de8be8 <nbgl_trampoline_helper>
	...

c0de8be0 <pic_init>:
c0de8be0:	b403      	push	{r0, r1}
c0de8be2:	f04f 00c4 	mov.w	r0, #196	@ 0xc4
c0de8be6:	e7ff      	b.n	c0de8be8 <nbgl_trampoline_helper>

c0de8be8 <nbgl_trampoline_helper>:
c0de8be8:	4900      	ldr	r1, [pc, #0]	@ (c0de8bec <nbgl_trampoline_helper+0x4>)
c0de8bea:	4708      	bx	r1
c0de8bec:	00808001 	.word	0x00808001

c0de8bf0 <os_boot>:
#include <string.h>
#include <ctype.h>

#ifndef BOLOS_OS_UPGRADER_APP
void os_boot(void)
{
c0de8bf0:	b580      	push	{r7, lr}
    // // TODO patch entry point when romming (f)
    // // set the default try context to nothing
#ifndef HAVE_BOLOS
    try_context_set(NULL);
c0de8bf2:	2000      	movs	r0, #0
c0de8bf4:	f000 ffcc 	bl	c0de9b90 <try_context_set>
#endif  // HAVE_BOLOS
}
c0de8bf8:	bd80      	pop	{r7, pc}

c0de8bfa <os_longjmp>:

void os_longjmp(unsigned int exception)
{
#ifdef HAVE_DEBUG_THROWS
    // Send to the app the info of exception and LR for debug purpose
    DEBUG_THROW(exception);
c0de8bfa:	4675      	mov	r5, lr
c0de8bfc:	4629      	mov	r1, r5
c0de8bfe:	4604      	mov	r4, r0
c0de8c00:	f7ff ff27 	bl	c0de8a52 <throw_display_lr>
c0de8c04:	4620      	mov	r0, r4
c0de8c06:	4629      	mov	r1, r5
c0de8c08:	f7ff ff3b 	bl	c0de8a82 <throw_print_lr>
    lr_val = compute_address_location(lr_val);

    PRINTF("exception[0x%04X]: LR=0x%08X\n", exception, lr_val);
#endif

    longjmp(try_context_get()->jmp_buf, exception);
c0de8c0c:	f000 ffb6 	bl	c0de9b7c <try_context_get>
c0de8c10:	4621      	mov	r1, r4
c0de8c12:	f001 f92d 	bl	c0de9e70 <longjmp>

c0de8c16 <compute_address_location>:
    return address - (unsigned int) main + MAIN_LINKER_SCRIPT_LOCATION;
c0de8c16:	f247 31df 	movw	r1, #29663	@ 0x73df
c0de8c1a:	f6cf 71ff 	movt	r1, #65535	@ 0xffff
c0de8c1e:	4479      	add	r1, pc
c0de8c20:	1a40      	subs	r0, r0, r1
c0de8c22:	f100 4040 	add.w	r0, r0, #3221225472	@ 0xc0000000
c0de8c26:	f500 005e 	add.w	r0, r0, #14548992	@ 0xde0000
c0de8c2a:	4770      	bx	lr

c0de8c2c <mcu_usb_printf>:
#ifndef BUILD_SCREENSHOTS
#ifdef HAVE_PRINTF
void screen_printf(const char *format, ...) __attribute__((weak, alias("mcu_usb_printf")));

void mcu_usb_printf(const char *format, ...)
{
c0de8c2c:	b083      	sub	sp, #12
c0de8c2e:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de8c32:	b091      	sub	sp, #68	@ 0x44
    va_list vaArgP;

    if (format == NULL) {
c0de8c34:	2800      	cmp	r0, #0
c0de8c36:	e9cd 1219 	strd	r1, r2, [sp, #100]	@ 0x64
c0de8c3a:	931b      	str	r3, [sp, #108]	@ 0x6c
c0de8c3c:	f000 82f7 	beq.w	c0de922e <mcu_usb_printf+0x602>
c0de8c40:	4604      	mov	r4, r0
    while (*format) {
c0de8c42:	7800      	ldrb	r0, [r0, #0]
c0de8c44:	f10d 0b64 	add.w	fp, sp, #100	@ 0x64
c0de8c48:	2800      	cmp	r0, #0
        return;
    }

    va_start(vaArgP, format);
c0de8c4a:	f8cd b01c 	str.w	fp, [sp, #28]
    while (*format) {
c0de8c4e:	f000 82ee 	beq.w	c0de922e <mcu_usb_printf+0x602>
c0de8c52:	f242 1687 	movw	r6, #8583	@ 0x2187
c0de8c56:	f2c0 0600 	movt	r6, #0
c0de8c5a:	447e      	add	r6, pc
c0de8c5c:	e00a      	b.n	c0de8c74 <mcu_usb_printf+0x48>
c0de8c5e:	bf00      	nop
c0de8c60:	f242 1679 	movw	r6, #8569	@ 0x2179
c0de8c64:	f2c0 0600 	movt	r6, #0
c0de8c68:	447e      	add	r6, pc
c0de8c6a:	4654      	mov	r4, sl
c0de8c6c:	7820      	ldrb	r0, [r4, #0]
c0de8c6e:	2800      	cmp	r0, #0
c0de8c70:	f000 82dd 	beq.w	c0de922e <mcu_usb_printf+0x602>
c0de8c74:	2700      	movs	r7, #0
c0de8c76:	bf00      	nop
        for (ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0'); ulIdx++) {
c0de8c78:	5de0      	ldrb	r0, [r4, r7]
c0de8c7a:	b118      	cbz	r0, c0de8c84 <mcu_usb_printf+0x58>
c0de8c7c:	2825      	cmp	r0, #37	@ 0x25
c0de8c7e:	d001      	beq.n	c0de8c84 <mcu_usb_printf+0x58>
c0de8c80:	3701      	adds	r7, #1
c0de8c82:	e7f9      	b.n	c0de8c78 <mcu_usb_printf+0x4c>
        if (ulIdx > 0) {
c0de8c84:	b11f      	cbz	r7, c0de8c8e <mcu_usb_printf+0x62>
    os_io_seph_cmd_printf(data, len);
c0de8c86:	b2b9      	uxth	r1, r7
c0de8c88:	4620      	mov	r0, r4
c0de8c8a:	f7f8 f82d 	bl	c0de0ce8 <os_io_seph_cmd_printf>
c0de8c8e:	443c      	add	r4, r7
        if (*format == '%') {
c0de8c90:	7820      	ldrb	r0, [r4, #0]
c0de8c92:	2825      	cmp	r0, #37	@ 0x25
c0de8c94:	d1ea      	bne.n	c0de8c6c <mcu_usb_printf+0x40>
            ulNeg      = 0;
c0de8c96:	3401      	adds	r4, #1
c0de8c98:	f04f 0e00 	mov.w	lr, #0
c0de8c9c:	f04f 0c20 	mov.w	ip, #32
c0de8ca0:	f04f 0800 	mov.w	r8, #0
c0de8ca4:	2100      	movs	r1, #0
c0de8ca6:	e002      	b.n	c0de8cae <mcu_usb_printf+0x82>
c0de8ca8:	f04f 0100 	mov.w	r1, #0
            switch (*format++) {
c0de8cac:	d117      	bne.n	c0de8cde <mcu_usb_printf+0xb2>
c0de8cae:	f814 2b01 	ldrb.w	r2, [r4], #1
c0de8cb2:	2a2d      	cmp	r2, #45	@ 0x2d
c0de8cb4:	ddf8      	ble.n	c0de8ca8 <mcu_usb_printf+0x7c>
c0de8cb6:	2a47      	cmp	r2, #71	@ 0x47
c0de8cb8:	dc32      	bgt.n	c0de8d20 <mcu_usb_printf+0xf4>
c0de8cba:	f1a2 0030 	sub.w	r0, r2, #48	@ 0x30
c0de8cbe:	280a      	cmp	r0, #10
c0de8cc0:	d21a      	bcs.n	c0de8cf8 <mcu_usb_printf+0xcc>
                    if ((format[-1] == '0') && (ulCount == 0)) {
c0de8cc2:	f082 0030 	eor.w	r0, r2, #48	@ 0x30
c0de8cc6:	ea50 000e 	orrs.w	r0, r0, lr
                    ulCount *= 10;
c0de8cca:	eb0e 008e 	add.w	r0, lr, lr, lsl #2
                    ulCount += format[-1] - '0';
c0de8cce:	eb02 0040 	add.w	r0, r2, r0, lsl #1
                    if ((format[-1] == '0') && (ulCount == 0)) {
c0de8cd2:	bf08      	it	eq
c0de8cd4:	f04f 0c30 	moveq.w	ip, #48	@ 0x30
                    ulCount += format[-1] - '0';
c0de8cd8:	f1a0 0e30 	sub.w	lr, r0, #48	@ 0x30
c0de8cdc:	e7e7      	b.n	c0de8cae <mcu_usb_printf+0x82>
            switch (*format++) {
c0de8cde:	2a25      	cmp	r2, #37	@ 0x25
c0de8ce0:	d04c      	beq.n	c0de8d7c <mcu_usb_printf+0x150>
c0de8ce2:	2a2a      	cmp	r2, #42	@ 0x2a
c0de8ce4:	f040 82a3 	bne.w	c0de922e <mcu_usb_printf+0x602>
                    if (*format == 's') {
c0de8ce8:	7820      	ldrb	r0, [r4, #0]
c0de8cea:	2873      	cmp	r0, #115	@ 0x73
c0de8cec:	f040 829f 	bne.w	c0de922e <mcu_usb_printf+0x602>
c0de8cf0:	f85b 8b04 	ldr.w	r8, [fp], #4
c0de8cf4:	2102      	movs	r1, #2
c0de8cf6:	e7da      	b.n	c0de8cae <mcu_usb_printf+0x82>
            switch (*format++) {
c0de8cf8:	2a2e      	cmp	r2, #46	@ 0x2e
c0de8cfa:	f040 8298 	bne.w	c0de922e <mcu_usb_printf+0x602>
                    if (format[0] == '*'
c0de8cfe:	7820      	ldrb	r0, [r4, #0]
                        && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de8d00:	282a      	cmp	r0, #42	@ 0x2a
c0de8d02:	f040 8294 	bne.w	c0de922e <mcu_usb_printf+0x602>
c0de8d06:	f814 0f01 	ldrb.w	r0, [r4, #1]!
c0de8d0a:	2101      	movs	r1, #1
c0de8d0c:	2848      	cmp	r0, #72	@ 0x48
c0de8d0e:	d004      	beq.n	c0de8d1a <mcu_usb_printf+0xee>
c0de8d10:	2868      	cmp	r0, #104	@ 0x68
c0de8d12:	d002      	beq.n	c0de8d1a <mcu_usb_printf+0xee>
c0de8d14:	2873      	cmp	r0, #115	@ 0x73
c0de8d16:	f040 828a 	bne.w	c0de922e <mcu_usb_printf+0x602>
c0de8d1a:	f85b 8b04 	ldr.w	r8, [fp], #4
c0de8d1e:	e7c6      	b.n	c0de8cae <mcu_usb_printf+0x82>
            switch (*format++) {
c0de8d20:	2a6b      	cmp	r2, #107	@ 0x6b
c0de8d22:	dc0b      	bgt.n	c0de8d3c <mcu_usb_printf+0x110>
c0de8d24:	2a62      	cmp	r2, #98	@ 0x62
c0de8d26:	dd12      	ble.n	c0de8d4e <mcu_usb_printf+0x122>
c0de8d28:	2a63      	cmp	r2, #99	@ 0x63
c0de8d2a:	d02d      	beq.n	c0de8d88 <mcu_usb_printf+0x15c>
c0de8d2c:	2a64      	cmp	r2, #100	@ 0x64
c0de8d2e:	d033      	beq.n	c0de8d98 <mcu_usb_printf+0x16c>
c0de8d30:	2a68      	cmp	r2, #104	@ 0x68
c0de8d32:	f040 827c 	bne.w	c0de922e <mcu_usb_printf+0x602>
c0de8d36:	2001      	movs	r0, #1
c0de8d38:	e03c      	b.n	c0de8db4 <mcu_usb_printf+0x188>
c0de8d3a:	bf00      	nop
c0de8d3c:	2a72      	cmp	r2, #114	@ 0x72
c0de8d3e:	dd0e      	ble.n	c0de8d5e <mcu_usb_printf+0x132>
c0de8d40:	2a73      	cmp	r2, #115	@ 0x73
c0de8d42:	d036      	beq.n	c0de8db2 <mcu_usb_printf+0x186>
c0de8d44:	2a75      	cmp	r2, #117	@ 0x75
c0de8d46:	d03b      	beq.n	c0de8dc0 <mcu_usb_printf+0x194>
c0de8d48:	2a78      	cmp	r2, #120	@ 0x78
c0de8d4a:	d00e      	beq.n	c0de8d6a <mcu_usb_printf+0x13e>
c0de8d4c:	e26f      	b.n	c0de922e <mcu_usb_printf+0x602>
c0de8d4e:	2a48      	cmp	r2, #72	@ 0x48
c0de8d50:	f000 80e6 	beq.w	c0de8f20 <mcu_usb_printf+0x2f4>
c0de8d54:	2a58      	cmp	r2, #88	@ 0x58
c0de8d56:	f040 826a 	bne.w	c0de922e <mcu_usb_printf+0x602>
c0de8d5a:	2001      	movs	r0, #1
c0de8d5c:	e006      	b.n	c0de8d6c <mcu_usb_printf+0x140>
c0de8d5e:	2a6c      	cmp	r2, #108	@ 0x6c
c0de8d60:	f000 8101 	beq.w	c0de8f66 <mcu_usb_printf+0x33a>
c0de8d64:	2a70      	cmp	r2, #112	@ 0x70
c0de8d66:	f040 8262 	bne.w	c0de922e <mcu_usb_printf+0x602>
c0de8d6a:	2000      	movs	r0, #0
c0de8d6c:	9005      	str	r0, [sp, #20]
c0de8d6e:	f8db 0000 	ldr.w	r0, [fp]
c0de8d72:	2610      	movs	r6, #16
c0de8d74:	9010      	str	r0, [sp, #64]	@ 0x40
c0de8d76:	f04f 0800 	mov.w	r8, #0
c0de8d7a:	e029      	b.n	c0de8dd0 <mcu_usb_printf+0x1a4>
    os_io_seph_cmd_printf(data, len);
c0de8d7c:	f242 6033 	movw	r0, #9779	@ 0x2633
c0de8d80:	f2c0 0000 	movt	r0, #0
c0de8d84:	4478      	add	r0, pc
c0de8d86:	e003      	b.n	c0de8d90 <mcu_usb_printf+0x164>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de8d88:	f85b 0b04 	ldr.w	r0, [fp], #4
c0de8d8c:	9010      	str	r0, [sp, #64]	@ 0x40
    os_io_seph_cmd_printf(data, len);
c0de8d8e:	a810      	add	r0, sp, #64	@ 0x40
c0de8d90:	2101      	movs	r1, #1
c0de8d92:	f7f7 ffa9 	bl	c0de0ce8 <os_io_seph_cmd_printf>
c0de8d96:	e769      	b.n	c0de8c6c <mcu_usb_printf+0x40>
                    ulValue = va_arg(vaArgP, unsigned int);
c0de8d98:	f8db 0000 	ldr.w	r0, [fp]
                    if ((long) ulValue < 0) {
c0de8d9c:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
                    ulValue = va_arg(vaArgP, unsigned int);
c0de8da0:	9010      	str	r0, [sp, #64]	@ 0x40
                    if ((long) ulValue < 0) {
c0de8da2:	dc10      	bgt.n	c0de8dc6 <mcu_usb_printf+0x19a>
                        ulValue = -(long) ((int) ulValue);
c0de8da4:	4240      	negs	r0, r0
c0de8da6:	9010      	str	r0, [sp, #64]	@ 0x40
c0de8da8:	2000      	movs	r0, #0
c0de8daa:	260a      	movs	r6, #10
c0de8dac:	f04f 0801 	mov.w	r8, #1
c0de8db0:	e00d      	b.n	c0de8dce <mcu_usb_printf+0x1a2>
c0de8db2:	2000      	movs	r0, #0
c0de8db4:	f242 7a88 	movw	sl, #10120	@ 0x2788
c0de8db8:	f2c0 0a00 	movt	sl, #0
c0de8dbc:	44fa      	add	sl, pc
c0de8dbe:	e0b5      	b.n	c0de8f2c <mcu_usb_printf+0x300>
                    ulValue = va_arg(vaArgP, unsigned int);
c0de8dc0:	f8db 0000 	ldr.w	r0, [fp]
c0de8dc4:	9010      	str	r0, [sp, #64]	@ 0x40
c0de8dc6:	2000      	movs	r0, #0
c0de8dc8:	260a      	movs	r6, #10
c0de8dca:	f04f 0800 	mov.w	r8, #0
c0de8dce:	9005      	str	r0, [sp, #20]
c0de8dd0:	9910      	ldr	r1, [sp, #64]	@ 0x40
                         (((ulIdx * ulBase) <= ulValue) && (((ulIdx * ulBase) / ulBase) == ulIdx));
c0de8dd2:	f8cd b010 	str.w	fp, [sp, #16]
c0de8dd6:	428e      	cmp	r6, r1
c0de8dd8:	d902      	bls.n	c0de8de0 <mcu_usb_printf+0x1b4>
c0de8dda:	2501      	movs	r5, #1
c0de8ddc:	2701      	movs	r7, #1
c0de8dde:	e00e      	b.n	c0de8dfe <mcu_usb_printf+0x1d2>
c0de8de0:	2202      	movs	r2, #2
c0de8de2:	4633      	mov	r3, r6
c0de8de4:	461d      	mov	r5, r3
c0de8de6:	fba6 3003 	umull	r3, r0, r6, r3
c0de8dea:	2800      	cmp	r0, #0
c0de8dec:	bf18      	it	ne
c0de8dee:	2001      	movne	r0, #1
c0de8df0:	428b      	cmp	r3, r1
c0de8df2:	4617      	mov	r7, r2
c0de8df4:	d803      	bhi.n	c0de8dfe <mcu_usb_printf+0x1d2>
                    for (ulIdx = 1;
c0de8df6:	2800      	cmp	r0, #0
c0de8df8:	f107 0201 	add.w	r2, r7, #1
c0de8dfc:	d0f2      	beq.n	c0de8de4 <mcu_usb_printf+0x1b8>
    if (*ulNeg) {
c0de8dfe:	eb07 0108 	add.w	r1, r7, r8
    if (ulWidth > ulActualLen) {
c0de8e02:	ebbe 0b01 	subs.w	fp, lr, r1
c0de8e06:	fa5f fa8c 	uxtb.w	sl, ip
    if (*ulNeg) {
c0de8e0a:	f088 0001 	eor.w	r0, r8, #1
c0de8e0e:	f8cd 8018 	str.w	r8, [sp, #24]
c0de8e12:	f04f 0800 	mov.w	r8, #0
    if (ulWidth > ulActualLen) {
c0de8e16:	bf38      	it	cc
c0de8e18:	46c3      	movcc	fp, r8
c0de8e1a:	f1ba 0230 	subs.w	r2, sl, #48	@ 0x30
c0de8e1e:	bf18      	it	ne
c0de8e20:	2201      	movne	r2, #1
    if (*ulNeg && (cFill == '0')) {
c0de8e22:	4310      	orrs	r0, r2
c0de8e24:	d106      	bne.n	c0de8e34 <mcu_usb_printf+0x208>
        pcBuf[(*ulPos)++] = '-';
c0de8e26:	202d      	movs	r0, #45	@ 0x2d
c0de8e28:	f88d 0020 	strb.w	r0, [sp, #32]
c0de8e2c:	2000      	movs	r0, #0
c0de8e2e:	f04f 0801 	mov.w	r8, #1
c0de8e32:	9006      	str	r0, [sp, #24]
    while (ulPaddingNeeded > 0) {
c0de8e34:	4571      	cmp	r1, lr
c0de8e36:	d31a      	bcc.n	c0de8e6e <mcu_usb_printf+0x242>
    if (*ulNeg) {
c0de8e38:	9806      	ldr	r0, [sp, #24]
c0de8e3a:	46a2      	mov	sl, r4
c0de8e3c:	b3a0      	cbz	r0, c0de8ea8 <mcu_usb_printf+0x27c>
c0de8e3e:	f8dd b010 	ldr.w	fp, [sp, #16]
        if (*ulPos >= PCBUF_SIZE) {
c0de8e42:	f1b8 0f20 	cmp.w	r8, #32
c0de8e46:	ac08      	add	r4, sp, #32
c0de8e48:	d306      	bcc.n	c0de8e58 <mcu_usb_printf+0x22c>
    os_io_seph_cmd_printf(data, len);
c0de8e4a:	fa1f f188 	uxth.w	r1, r8
c0de8e4e:	4620      	mov	r0, r4
c0de8e50:	f7f7 ff4a 	bl	c0de0ce8 <os_io_seph_cmd_printf>
c0de8e54:	f04f 0800 	mov.w	r8, #0
        pcBuf[(*ulPos)++] = '-';
c0de8e58:	202d      	movs	r0, #45	@ 0x2d
c0de8e5a:	f804 0008 	strb.w	r0, [r4, r8]
c0de8e5e:	f108 0801 	add.w	r8, r8, #1
                    for (; ulIdx; ulIdx /= ulBase) {
c0de8e62:	bb2d      	cbnz	r5, c0de8eb0 <mcu_usb_printf+0x284>
c0de8e64:	e050      	b.n	c0de8f08 <mcu_usb_printf+0x2dc>
c0de8e66:	bf00      	nop
    while (ulPaddingNeeded > 0) {
c0de8e68:	f1bb 0f00 	cmp.w	fp, #0
c0de8e6c:	d0e4      	beq.n	c0de8e38 <mcu_usb_printf+0x20c>
        unsigned long bufferSpace = PCBUF_SIZE - *ulPos;
c0de8e6e:	f1c8 0720 	rsb	r7, r8, #32
        if (chunkSize > bufferSpace) {
c0de8e72:	45bb      	cmp	fp, r7
c0de8e74:	bf98      	it	ls
c0de8e76:	465f      	movls	r7, fp
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de8e78:	b137      	cbz	r7, c0de8e88 <mcu_usb_printf+0x25c>
c0de8e7a:	a808      	add	r0, sp, #32
c0de8e7c:	4440      	add	r0, r8
            pcBuf[(*ulPos)++] = cFill;
c0de8e7e:	4639      	mov	r1, r7
c0de8e80:	4652      	mov	r2, sl
c0de8e82:	f000 ff95 	bl	c0de9db0 <__aeabi_memset>
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de8e86:	44b8      	add	r8, r7
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de8e88:	f1b8 0f20 	cmp.w	r8, #32
        ulPaddingNeeded -= chunkSize;
c0de8e8c:	ebab 0b07 	sub.w	fp, fp, r7
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de8e90:	d3ea      	bcc.n	c0de8e68 <mcu_usb_printf+0x23c>
c0de8e92:	f1bb 0f00 	cmp.w	fp, #0
c0de8e96:	d0e7      	beq.n	c0de8e68 <mcu_usb_printf+0x23c>
    os_io_seph_cmd_printf(data, len);
c0de8e98:	fa1f f188 	uxth.w	r1, r8
c0de8e9c:	a808      	add	r0, sp, #32
c0de8e9e:	f7f7 ff23 	bl	c0de0ce8 <os_io_seph_cmd_printf>
c0de8ea2:	f04f 0800 	mov.w	r8, #0
c0de8ea6:	e7df      	b.n	c0de8e68 <mcu_usb_printf+0x23c>
c0de8ea8:	f8dd b010 	ldr.w	fp, [sp, #16]
c0de8eac:	ac08      	add	r4, sp, #32
                    for (; ulIdx; ulIdx /= ulBase) {
c0de8eae:	b35d      	cbz	r5, c0de8f08 <mcu_usb_printf+0x2dc>
c0de8eb0:	9805      	ldr	r0, [sp, #20]
c0de8eb2:	f242 6794 	movw	r7, #9876	@ 0x2694
c0de8eb6:	2800      	cmp	r0, #0
c0de8eb8:	f2c0 0700 	movt	r7, #0
c0de8ebc:	f242 607e 	movw	r0, #9854	@ 0x267e
c0de8ec0:	447f      	add	r7, pc
c0de8ec2:	f2c0 0000 	movt	r0, #0
c0de8ec6:	4478      	add	r0, pc
c0de8ec8:	bf08      	it	eq
c0de8eca:	4607      	moveq	r7, r0
c0de8ecc:	e010      	b.n	c0de8ef0 <mcu_usb_printf+0x2c4>
c0de8ece:	bf00      	nop
c0de8ed0:	9810      	ldr	r0, [sp, #64]	@ 0x40
c0de8ed2:	42ae      	cmp	r6, r5
c0de8ed4:	fbb0 f0f5 	udiv	r0, r0, r5
c0de8ed8:	fbb5 f5f6 	udiv	r5, r5, r6
c0de8edc:	fbb0 f1f6 	udiv	r1, r0, r6
c0de8ee0:	fb01 0016 	mls	r0, r1, r6, r0
c0de8ee4:	5c38      	ldrb	r0, [r7, r0]
c0de8ee6:	f804 0008 	strb.w	r0, [r4, r8]
c0de8eea:	f108 0801 	add.w	r8, r8, #1
c0de8eee:	d80b      	bhi.n	c0de8f08 <mcu_usb_printf+0x2dc>
                        if (ulPos >= PCBUF_SIZE) {
c0de8ef0:	f1b8 0f20 	cmp.w	r8, #32
c0de8ef4:	d3ec      	bcc.n	c0de8ed0 <mcu_usb_printf+0x2a4>
    os_io_seph_cmd_printf(data, len);
c0de8ef6:	fa1f f188 	uxth.w	r1, r8
c0de8efa:	4620      	mov	r0, r4
c0de8efc:	f7f7 fef4 	bl	c0de0ce8 <os_io_seph_cmd_printf>
c0de8f00:	f04f 0800 	mov.w	r8, #0
c0de8f04:	e7e4      	b.n	c0de8ed0 <mcu_usb_printf+0x2a4>
c0de8f06:	bf00      	nop
                    if (ulPos > 0) {
c0de8f08:	f1b8 0f00 	cmp.w	r8, #0
c0de8f0c:	f10b 0b04 	add.w	fp, fp, #4
c0de8f10:	f43f aea6 	beq.w	c0de8c60 <mcu_usb_printf+0x34>
    os_io_seph_cmd_printf(data, len);
c0de8f14:	fa1f f188 	uxth.w	r1, r8
c0de8f18:	4620      	mov	r0, r4
c0de8f1a:	f7f7 fee5 	bl	c0de0ce8 <os_io_seph_cmd_printf>
c0de8f1e:	e69f      	b.n	c0de8c60 <mcu_usb_printf+0x34>
c0de8f20:	f242 6a2a 	movw	sl, #9770	@ 0x262a
c0de8f24:	f2c0 0a00 	movt	sl, #0
c0de8f28:	2001      	movs	r0, #1
c0de8f2a:	44fa      	add	sl, pc
                    pcStr = va_arg(vaArgP, char *);
c0de8f2c:	f85b 5b04 	ldr.w	r5, [fp], #4
                    switch (cStrlenSet) {
c0de8f30:	b2c9      	uxtb	r1, r1
c0de8f32:	2900      	cmp	r1, #0
c0de8f34:	d04d      	beq.n	c0de8fd2 <mcu_usb_printf+0x3a6>
c0de8f36:	2901      	cmp	r1, #1
c0de8f38:	d074      	beq.n	c0de9024 <mcu_usb_printf+0x3f8>
c0de8f3a:	2902      	cmp	r1, #2
c0de8f3c:	d14f      	bne.n	c0de8fde <mcu_usb_printf+0x3b2>
                            if (pcStr[0] == '\0') {
c0de8f3e:	7828      	ldrb	r0, [r5, #0]
c0de8f40:	2800      	cmp	r0, #0
c0de8f42:	f040 8174 	bne.w	c0de922e <mcu_usb_printf+0x602>
                                for (ulCount = 0; ulCount < ulStrlen; ulCount++) {
c0de8f46:	f1b8 0f00 	cmp.w	r8, #0
c0de8f4a:	f000 809f 	beq.w	c0de908c <mcu_usb_printf+0x460>
c0de8f4e:	4645      	mov	r5, r8
    os_io_seph_cmd_printf(data, len);
c0de8f50:	4630      	mov	r0, r6
c0de8f52:	2101      	movs	r1, #1
c0de8f54:	f7f7 fec8 	bl	c0de0ce8 <os_io_seph_cmd_printf>
                                for (ulCount = 0; ulCount < ulStrlen; ulCount++) {
c0de8f58:	3d01      	subs	r5, #1
c0de8f5a:	d1f9      	bne.n	c0de8f50 <mcu_usb_printf+0x324>
c0de8f5c:	4642      	mov	r2, r8
                    if (ulCount > ulIdx) {
c0de8f5e:	42ba      	cmp	r2, r7
c0de8f60:	f67f ae84 	bls.w	c0de8c6c <mcu_usb_printf+0x40>
c0de8f64:	e07c      	b.n	c0de9060 <mcu_usb_printf+0x434>
                    if (*format == 'l'
c0de8f66:	7820      	ldrb	r0, [r4, #0]
                        && (*(format + 1) == 'u' || *(format + 1) == 'd' || *(format + 1) == 'x'
c0de8f68:	286c      	cmp	r0, #108	@ 0x6c
c0de8f6a:	f040 8160 	bne.w	c0de922e <mcu_usb_printf+0x602>
c0de8f6e:	4623      	mov	r3, r4
c0de8f70:	f813 1f01 	ldrb.w	r1, [r3, #1]!
c0de8f74:	f1a1 0064 	sub.w	r0, r1, #100	@ 0x64
c0de8f78:	2814      	cmp	r0, #20
c0de8f7a:	d807      	bhi.n	c0de8f8c <mcu_usb_printf+0x360>
c0de8f7c:	2201      	movs	r2, #1
c0de8f7e:	fa02 f000 	lsl.w	r0, r2, r0
c0de8f82:	2201      	movs	r2, #1
c0de8f84:	f2c0 0212 	movt	r2, #18
c0de8f88:	4210      	tst	r0, r2
c0de8f8a:	d102      	bne.n	c0de8f92 <mcu_usb_printf+0x366>
c0de8f8c:	2958      	cmp	r1, #88	@ 0x58
c0de8f8e:	f040 814e 	bne.w	c0de922e <mcu_usb_printf+0x602>
                        int64_t  slValue64 = va_arg(vaArgP, int64_t);
c0de8f92:	f10b 0007 	add.w	r0, fp, #7
c0de8f96:	f020 0007 	bic.w	r0, r0, #7
c0de8f9a:	6842      	ldr	r2, [r0, #4]
c0de8f9c:	f850 5b08 	ldr.w	r5, [r0], #8
                        if (*format == 'd') {
c0de8fa0:	2974      	cmp	r1, #116	@ 0x74
c0de8fa2:	9004      	str	r0, [sp, #16]
c0de8fa4:	dc65      	bgt.n	c0de9072 <mcu_usb_printf+0x446>
c0de8fa6:	2958      	cmp	r1, #88	@ 0x58
c0de8fa8:	d075      	beq.n	c0de9096 <mcu_usb_printf+0x46a>
c0de8faa:	2964      	cmp	r1, #100	@ 0x64
c0de8fac:	f040 8086 	bne.w	c0de90bc <mcu_usb_printf+0x490>
                            if (slValue64 < 0) {
c0de8fb0:	eb15 70e2 	adds.w	r0, r5, r2, asr #31
c0de8fb4:	ea80 75e2 	eor.w	r5, r0, r2, asr #31
c0de8fb8:	eb42 70e2 	adc.w	r0, r2, r2, asr #31
c0de8fbc:	0fd1      	lsrs	r1, r2, #31
c0de8fbe:	ea80 72e2 	eor.w	r2, r0, r2, asr #31
c0de8fc2:	f242 5076 	movw	r0, #9590	@ 0x2576
c0de8fc6:	f2c0 0000 	movt	r0, #0
c0de8fca:	1ca3      	adds	r3, r4, #2
c0de8fcc:	240a      	movs	r4, #10
c0de8fce:	4478      	add	r0, pc
c0de8fd0:	e072      	b.n	c0de90b8 <mcu_usb_printf+0x48c>
c0de8fd2:	2100      	movs	r1, #0
                            for (ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++) {
c0de8fd4:	5c6a      	ldrb	r2, [r5, r1]
c0de8fd6:	3101      	adds	r1, #1
c0de8fd8:	2a00      	cmp	r2, #0
c0de8fda:	d1fb      	bne.n	c0de8fd4 <mcu_usb_printf+0x3a8>
                    switch (ulBase) {
c0de8fdc:	1e4f      	subs	r7, r1, #1
c0de8fde:	b320      	cbz	r0, c0de902a <mcu_usb_printf+0x3fe>
c0de8fe0:	46a0      	mov	r8, r4
                            for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de8fe2:	2f00      	cmp	r7, #0
c0de8fe4:	d04c      	beq.n	c0de9080 <mcu_usb_printf+0x454>
c0de8fe6:	2400      	movs	r4, #0
c0de8fe8:	2600      	movs	r6, #0
c0de8fea:	e002      	b.n	c0de8ff2 <mcu_usb_printf+0x3c6>
c0de8fec:	3601      	adds	r6, #1
c0de8fee:	42b7      	cmp	r7, r6
c0de8ff0:	d025      	beq.n	c0de903e <mcu_usb_printf+0x412>
                                nibble1 = (pcStr[ulCount] >> 4) & 0xF;
c0de8ff2:	5da9      	ldrb	r1, [r5, r6]
c0de8ff4:	a808      	add	r0, sp, #32
c0de8ff6:	090a      	lsrs	r2, r1, #4
                                nibble2 = pcStr[ulCount] & 0xF;
c0de8ff8:	f001 010f 	and.w	r1, r1, #15
c0de8ffc:	f81a 2002 	ldrb.w	r2, [sl, r2]
c0de9000:	f81a 1001 	ldrb.w	r1, [sl, r1]
c0de9004:	1903      	adds	r3, r0, r4
c0de9006:	5502      	strb	r2, [r0, r4]
c0de9008:	7059      	strb	r1, [r3, #1]
c0de900a:	1ca1      	adds	r1, r4, #2
                                if (idx + 1 >= sizeof(pcBuf)) {
c0de900c:	f1a4 001d 	sub.w	r0, r4, #29
c0de9010:	f110 0f21 	cmn.w	r0, #33	@ 0x21
c0de9014:	460c      	mov	r4, r1
c0de9016:	d8e9      	bhi.n	c0de8fec <mcu_usb_printf+0x3c0>
    os_io_seph_cmd_printf(data, len);
c0de9018:	b289      	uxth	r1, r1
c0de901a:	a808      	add	r0, sp, #32
c0de901c:	f7f7 fe64 	bl	c0de0ce8 <os_io_seph_cmd_printf>
c0de9020:	2400      	movs	r4, #0
c0de9022:	e7e3      	b.n	c0de8fec <mcu_usb_printf+0x3c0>
c0de9024:	4647      	mov	r7, r8
                    switch (ulBase) {
c0de9026:	2800      	cmp	r0, #0
c0de9028:	d1da      	bne.n	c0de8fe0 <mcu_usb_printf+0x3b4>
    os_io_seph_cmd_printf(data, len);
c0de902a:	b2b9      	uxth	r1, r7
c0de902c:	4628      	mov	r0, r5
c0de902e:	4675      	mov	r5, lr
c0de9030:	f7f7 fe5a 	bl	c0de0ce8 <os_io_seph_cmd_printf>
c0de9034:	462a      	mov	r2, r5
                    if (ulCount > ulIdx) {
c0de9036:	42ba      	cmp	r2, r7
c0de9038:	f67f ae18 	bls.w	c0de8c6c <mcu_usb_printf+0x40>
c0de903c:	e010      	b.n	c0de9060 <mcu_usb_printf+0x434>
c0de903e:	f641 5697 	movw	r6, #7575	@ 0x1d97
c0de9042:	f2c0 0600 	movt	r6, #0
c0de9046:	463a      	mov	r2, r7
c0de9048:	a808      	add	r0, sp, #32
c0de904a:	447e      	add	r6, pc
                            if (idx != 0) {
c0de904c:	b124      	cbz	r4, c0de9058 <mcu_usb_printf+0x42c>
    os_io_seph_cmd_printf(data, len);
c0de904e:	b2a1      	uxth	r1, r4
c0de9050:	4614      	mov	r4, r2
c0de9052:	f7f7 fe49 	bl	c0de0ce8 <os_io_seph_cmd_printf>
c0de9056:	4622      	mov	r2, r4
c0de9058:	4644      	mov	r4, r8
                    if (ulCount > ulIdx) {
c0de905a:	42ba      	cmp	r2, r7
c0de905c:	f67f ae06 	bls.w	c0de8c6c <mcu_usb_printf+0x40>
                        while (ulCount--) {
c0de9060:	1abd      	subs	r5, r7, r2
c0de9062:	bf00      	nop
    os_io_seph_cmd_printf(data, len);
c0de9064:	4630      	mov	r0, r6
c0de9066:	2101      	movs	r1, #1
c0de9068:	f7f7 fe3e 	bl	c0de0ce8 <os_io_seph_cmd_printf>
                        while (ulCount--) {
c0de906c:	3501      	adds	r5, #1
c0de906e:	d3f9      	bcc.n	c0de9064 <mcu_usb_printf+0x438>
c0de9070:	e5fc      	b.n	c0de8c6c <mcu_usb_printf+0x40>
                        if (*format == 'd') {
c0de9072:	2975      	cmp	r1, #117	@ 0x75
c0de9074:	d018      	beq.n	c0de90a8 <mcu_usb_printf+0x47c>
c0de9076:	2978      	cmp	r1, #120	@ 0x78
c0de9078:	d120      	bne.n	c0de90bc <mcu_usb_printf+0x490>
                        }
c0de907a:	1ca3      	adds	r3, r4, #2
c0de907c:	2410      	movs	r4, #16
c0de907e:	e015      	b.n	c0de90ac <mcu_usb_printf+0x480>
c0de9080:	2200      	movs	r2, #0
c0de9082:	2400      	movs	r4, #0
c0de9084:	a808      	add	r0, sp, #32
                            if (idx != 0) {
c0de9086:	2c00      	cmp	r4, #0
c0de9088:	d1e1      	bne.n	c0de904e <mcu_usb_printf+0x422>
c0de908a:	e7e5      	b.n	c0de9058 <mcu_usb_printf+0x42c>
c0de908c:	2200      	movs	r2, #0
                    if (ulCount > ulIdx) {
c0de908e:	42ba      	cmp	r2, r7
c0de9090:	f67f adec 	bls.w	c0de8c6c <mcu_usb_printf+0x40>
c0de9094:	e7e4      	b.n	c0de9060 <mcu_usb_printf+0x434>
c0de9096:	f242 40b0 	movw	r0, #9392	@ 0x24b0
c0de909a:	f2c0 0000 	movt	r0, #0
                        }
c0de909e:	1ca3      	adds	r3, r4, #2
c0de90a0:	2410      	movs	r4, #16
c0de90a2:	2100      	movs	r1, #0
c0de90a4:	4478      	add	r0, pc
c0de90a6:	e007      	b.n	c0de90b8 <mcu_usb_printf+0x48c>
                        }
c0de90a8:	1ca3      	adds	r3, r4, #2
c0de90aa:	240a      	movs	r4, #10
c0de90ac:	f242 408e 	movw	r0, #9358	@ 0x248e
c0de90b0:	f2c0 0000 	movt	r0, #0
c0de90b4:	2100      	movs	r1, #0
c0de90b6:	4478      	add	r0, pc
c0de90b8:	9005      	str	r0, [sp, #20]
c0de90ba:	e009      	b.n	c0de90d0 <mcu_usb_printf+0x4a4>
c0de90bc:	f242 4080 	movw	r0, #9344	@ 0x2480
c0de90c0:	f2c0 0000 	movt	r0, #0
c0de90c4:	4478      	add	r0, pc
c0de90c6:	2100      	movs	r1, #0
c0de90c8:	240a      	movs	r4, #10
c0de90ca:	9005      	str	r0, [sp, #20]
c0de90cc:	2500      	movs	r5, #0
c0de90ce:	2200      	movs	r2, #0
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de90d0:	1b28      	subs	r0, r5, r4
c0de90d2:	9506      	str	r5, [sp, #24]
c0de90d4:	4693      	mov	fp, r2
c0de90d6:	f172 0000 	sbcs.w	r0, r2, #0
c0de90da:	f04f 0500 	mov.w	r5, #0
c0de90de:	e9cd 3101 	strd	r3, r1, [sp, #4]
                                           && (((ulIdx64 * ulBase) / ulBase) == ulIdx64));
c0de90e2:	d205      	bcs.n	c0de90f0 <mcu_usb_printf+0x4c4>
c0de90e4:	2201      	movs	r2, #1
c0de90e6:	f04f 0801 	mov.w	r8, #1
c0de90ea:	f04f 0a00 	mov.w	sl, #0
c0de90ee:	e01b      	b.n	c0de9128 <mcu_usb_printf+0x4fc>
c0de90f0:	2100      	movs	r1, #0
c0de90f2:	2702      	movs	r7, #2
c0de90f4:	4623      	mov	r3, r4
c0de90f6:	bf00      	nop
c0de90f8:	468a      	mov	sl, r1
c0de90fa:	4698      	mov	r8, r3
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de90fc:	fba4 3003 	umull	r3, r0, r4, r3
c0de9100:	fba1 1604 	umull	r1, r6, r1, r4
c0de9104:	1809      	adds	r1, r1, r0
c0de9106:	f04f 0000 	mov.w	r0, #0
c0de910a:	f140 0000 	adc.w	r0, r0, #0
c0de910e:	2e00      	cmp	r6, #0
c0de9110:	bf18      	it	ne
c0de9112:	2601      	movne	r6, #1
c0de9114:	9a06      	ldr	r2, [sp, #24]
c0de9116:	1ad2      	subs	r2, r2, r3
c0de9118:	eb7b 0201 	sbcs.w	r2, fp, r1
c0de911c:	463a      	mov	r2, r7
                                           && (((ulIdx64 * ulBase) / ulBase) == ulIdx64));
c0de911e:	d303      	bcc.n	c0de9128 <mcu_usb_printf+0x4fc>
c0de9120:	4330      	orrs	r0, r6
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de9122:	f102 0701 	add.w	r7, r2, #1
c0de9126:	d0e7      	beq.n	c0de90f8 <mcu_usb_printf+0x4cc>
c0de9128:	9802      	ldr	r0, [sp, #8]
    if (*ulNeg) {
c0de912a:	1811      	adds	r1, r2, r0
    if (ulWidth > ulActualLen) {
c0de912c:	ebbe 0601 	subs.w	r6, lr, r1
c0de9130:	fa5f f28c 	uxtb.w	r2, ip
c0de9134:	bf38      	it	cc
c0de9136:	462e      	movcc	r6, r5
    if (*ulNeg && (cFill == '0')) {
c0de9138:	2a30      	cmp	r2, #48	@ 0x30
c0de913a:	9203      	str	r2, [sp, #12]
c0de913c:	d155      	bne.n	c0de91ea <mcu_usb_printf+0x5be>
c0de913e:	465f      	mov	r7, fp
c0de9140:	b128      	cbz	r0, c0de914e <mcu_usb_printf+0x522>
        pcBuf[(*ulPos)++] = '-';
c0de9142:	202d      	movs	r0, #45	@ 0x2d
c0de9144:	f88d 0020 	strb.w	r0, [sp, #32]
c0de9148:	2000      	movs	r0, #0
c0de914a:	2501      	movs	r5, #1
c0de914c:	9002      	str	r0, [sp, #8]
    while (ulPaddingNeeded > 0) {
c0de914e:	4571      	cmp	r1, lr
c0de9150:	d353      	bcc.n	c0de91fa <mcu_usb_printf+0x5ce>
    if (*ulNeg) {
c0de9152:	9802      	ldr	r0, [sp, #8]
c0de9154:	b150      	cbz	r0, c0de916c <mcu_usb_printf+0x540>
c0de9156:	f8dd b010 	ldr.w	fp, [sp, #16]
        if (*ulPos >= PCBUF_SIZE) {
c0de915a:	2d20      	cmp	r5, #32
c0de915c:	d30c      	bcc.n	c0de9178 <mcu_usb_printf+0x54c>
c0de915e:	ae08      	add	r6, sp, #32
    os_io_seph_cmd_printf(data, len);
c0de9160:	b2a9      	uxth	r1, r5
c0de9162:	4630      	mov	r0, r6
c0de9164:	f7f7 fdc0 	bl	c0de0ce8 <os_io_seph_cmd_printf>
c0de9168:	2500      	movs	r5, #0
c0de916a:	e006      	b.n	c0de917a <mcu_usb_printf+0x54e>
c0de916c:	f8dd b010 	ldr.w	fp, [sp, #16]
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de9170:	ea58 000a 	orrs.w	r0, r8, sl
c0de9174:	d135      	bne.n	c0de91e2 <mcu_usb_printf+0x5b6>
c0de9176:	e006      	b.n	c0de9186 <mcu_usb_printf+0x55a>
c0de9178:	ae08      	add	r6, sp, #32
        pcBuf[(*ulPos)++] = '-';
c0de917a:	202d      	movs	r0, #45	@ 0x2d
c0de917c:	5570      	strb	r0, [r6, r5]
c0de917e:	3501      	adds	r5, #1
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de9180:	ea58 000a 	orrs.w	r0, r8, sl
c0de9184:	d12d      	bne.n	c0de91e2 <mcu_usb_printf+0x5b6>
                        if (ulPos > 0) {
c0de9186:	b11d      	cbz	r5, c0de9190 <mcu_usb_printf+0x564>
    os_io_seph_cmd_printf(data, len);
c0de9188:	b2a9      	uxth	r1, r5
c0de918a:	a808      	add	r0, sp, #32
c0de918c:	f7f7 fdac 	bl	c0de0ce8 <os_io_seph_cmd_printf>
c0de9190:	9c01      	ldr	r4, [sp, #4]
c0de9192:	f641 4647 	movw	r6, #7239	@ 0x1c47
c0de9196:	f2c0 0600 	movt	r6, #0
c0de919a:	447e      	add	r6, pc
c0de919c:	e566      	b.n	c0de8c6c <mcu_usb_printf+0x40>
c0de919e:	bf00      	nop
c0de91a0:	ae08      	add	r6, sp, #32
c0de91a2:	b2a9      	uxth	r1, r5
c0de91a4:	4630      	mov	r0, r6
c0de91a6:	f7f7 fd9f 	bl	c0de0ce8 <os_io_seph_cmd_printf>
c0de91aa:	2500      	movs	r5, #0
c0de91ac:	9806      	ldr	r0, [sp, #24]
c0de91ae:	4639      	mov	r1, r7
c0de91b0:	4642      	mov	r2, r8
c0de91b2:	4653      	mov	r3, sl
c0de91b4:	f000 fe06 	bl	c0de9dc4 <__aeabi_uldivmod>
c0de91b8:	4622      	mov	r2, r4
c0de91ba:	2300      	movs	r3, #0
c0de91bc:	f000 fe02 	bl	c0de9dc4 <__aeabi_uldivmod>
c0de91c0:	9805      	ldr	r0, [sp, #20]
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de91c2:	4651      	mov	r1, sl
c0de91c4:	5c80      	ldrb	r0, [r0, r2]
c0de91c6:	4622      	mov	r2, r4
c0de91c8:	5570      	strb	r0, [r6, r5]
c0de91ca:	4640      	mov	r0, r8
c0de91cc:	2300      	movs	r3, #0
c0de91ce:	3501      	adds	r5, #1
c0de91d0:	f000 fdf8 	bl	c0de9dc4 <__aeabi_uldivmod>
c0de91d4:	ebb8 0204 	subs.w	r2, r8, r4
c0de91d8:	f17a 0200 	sbcs.w	r2, sl, #0
c0de91dc:	4680      	mov	r8, r0
c0de91de:	468a      	mov	sl, r1
c0de91e0:	d3d1      	bcc.n	c0de9186 <mcu_usb_printf+0x55a>
                            if (ulPos >= PCBUF_SIZE) {
c0de91e2:	2d20      	cmp	r5, #32
c0de91e4:	d2dc      	bcs.n	c0de91a0 <mcu_usb_printf+0x574>
c0de91e6:	ae08      	add	r6, sp, #32
c0de91e8:	e7e0      	b.n	c0de91ac <mcu_usb_printf+0x580>
c0de91ea:	465f      	mov	r7, fp
    while (ulPaddingNeeded > 0) {
c0de91ec:	4571      	cmp	r1, lr
c0de91ee:	d304      	bcc.n	c0de91fa <mcu_usb_printf+0x5ce>
c0de91f0:	e7af      	b.n	c0de9152 <mcu_usb_printf+0x526>
c0de91f2:	bf00      	nop
c0de91f4:	465f      	mov	r7, fp
c0de91f6:	2e00      	cmp	r6, #0
c0de91f8:	d0ab      	beq.n	c0de9152 <mcu_usb_printf+0x526>
        unsigned long bufferSpace = PCBUF_SIZE - *ulPos;
c0de91fa:	f1c5 0720 	rsb	r7, r5, #32
        if (chunkSize > bufferSpace) {
c0de91fe:	42be      	cmp	r6, r7
c0de9200:	bf98      	it	ls
c0de9202:	4637      	movls	r7, r6
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de9204:	b137      	cbz	r7, c0de9214 <mcu_usb_printf+0x5e8>
c0de9206:	a808      	add	r0, sp, #32
            pcBuf[(*ulPos)++] = cFill;
c0de9208:	9a03      	ldr	r2, [sp, #12]
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de920a:	4428      	add	r0, r5
            pcBuf[(*ulPos)++] = cFill;
c0de920c:	4639      	mov	r1, r7
c0de920e:	f000 fdcf 	bl	c0de9db0 <__aeabi_memset>
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de9212:	443d      	add	r5, r7
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de9214:	2d20      	cmp	r5, #32
        ulPaddingNeeded -= chunkSize;
c0de9216:	eba6 0607 	sub.w	r6, r6, r7
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de921a:	d3eb      	bcc.n	c0de91f4 <mcu_usb_printf+0x5c8>
c0de921c:	2e00      	cmp	r6, #0
c0de921e:	465f      	mov	r7, fp
c0de9220:	d0e9      	beq.n	c0de91f6 <mcu_usb_printf+0x5ca>
    os_io_seph_cmd_printf(data, len);
c0de9222:	b2a9      	uxth	r1, r5
c0de9224:	a808      	add	r0, sp, #32
c0de9226:	f7f7 fd5f 	bl	c0de0ce8 <os_io_seph_cmd_printf>
c0de922a:	2500      	movs	r5, #0
c0de922c:	e7e3      	b.n	c0de91f6 <mcu_usb_printf+0x5ca>
    (void) vformat_internal(printf_output, NULL, format, vaArgP);
    va_end(vaArgP);
}
c0de922e:	b011      	add	sp, #68	@ 0x44
c0de9230:	e8bd 4df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de9234:	b003      	add	sp, #12
c0de9236:	4770      	bx	lr

c0de9238 <vformat_internal>:
{
c0de9238:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de923c:	b092      	sub	sp, #72	@ 0x48
c0de923e:	4688      	mov	r8, r1
    while (*format) {
c0de9240:	7811      	ldrb	r1, [r2, #0]
c0de9242:	2900      	cmp	r1, #0
c0de9244:	f000 8333 	beq.w	c0de98ae <vformat_internal+0x676>
c0de9248:	461f      	mov	r7, r3
c0de924a:	4692      	mov	sl, r2
c0de924c:	4606      	mov	r6, r0
c0de924e:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de9252:	e9cd 8007 	strd	r8, r0, [sp, #28]
c0de9256:	e00e      	b.n	c0de9276 <vformat_internal+0x3e>
                    output("%", 1, output_ctx);
c0de9258:	f242 1057 	movw	r0, #8535	@ 0x2157
c0de925c:	f2c0 0000 	movt	r0, #0
c0de9260:	4478      	add	r0, pc
c0de9262:	2101      	movs	r1, #1
c0de9264:	4642      	mov	r2, r8
c0de9266:	47b0      	blx	r6
c0de9268:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
    while (*format) {
c0de926c:	f89a 0000 	ldrb.w	r0, [sl]
c0de9270:	2800      	cmp	r0, #0
c0de9272:	f000 831c 	beq.w	c0de98ae <vformat_internal+0x676>
c0de9276:	f04f 0b00 	mov.w	fp, #0
c0de927a:	bf00      	nop
        for (ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0'); ulIdx++) {
c0de927c:	f81a 000b 	ldrb.w	r0, [sl, fp]
c0de9280:	b120      	cbz	r0, c0de928c <vformat_internal+0x54>
c0de9282:	2825      	cmp	r0, #37	@ 0x25
c0de9284:	d002      	beq.n	c0de928c <vformat_internal+0x54>
c0de9286:	f10b 0b01 	add.w	fp, fp, #1
c0de928a:	e7f7      	b.n	c0de927c <vformat_internal+0x44>
        if (ulIdx > 0) {
c0de928c:	f1bb 0f00 	cmp.w	fp, #0
c0de9290:	d005      	beq.n	c0de929e <vformat_internal+0x66>
            output(format, ulIdx, output_ctx);
c0de9292:	4650      	mov	r0, sl
c0de9294:	4659      	mov	r1, fp
c0de9296:	4642      	mov	r2, r8
c0de9298:	47b0      	blx	r6
c0de929a:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de929e:	44da      	add	sl, fp
        if (*format == '%') {
c0de92a0:	f89a 0000 	ldrb.w	r0, [sl]
c0de92a4:	2825      	cmp	r0, #37	@ 0x25
c0de92a6:	d1e1      	bne.n	c0de926c <vformat_internal+0x34>
            ulNeg      = 0;
c0de92a8:	f10a 0a01 	add.w	sl, sl, #1
c0de92ac:	2300      	movs	r3, #0
c0de92ae:	f04f 0c20 	mov.w	ip, #32
c0de92b2:	2500      	movs	r5, #0
c0de92b4:	2100      	movs	r1, #0
c0de92b6:	e002      	b.n	c0de92be <vformat_internal+0x86>
c0de92b8:	f04f 0100 	mov.w	r1, #0
            switch (*format++) {
c0de92bc:	d116      	bne.n	c0de92ec <vformat_internal+0xb4>
c0de92be:	f81a 2b01 	ldrb.w	r2, [sl], #1
c0de92c2:	2a2d      	cmp	r2, #45	@ 0x2d
c0de92c4:	ddf8      	ble.n	c0de92b8 <vformat_internal+0x80>
c0de92c6:	2a47      	cmp	r2, #71	@ 0x47
c0de92c8:	dc34      	bgt.n	c0de9334 <vformat_internal+0xfc>
c0de92ca:	f1a2 0030 	sub.w	r0, r2, #48	@ 0x30
c0de92ce:	280a      	cmp	r0, #10
c0de92d0:	d21a      	bcs.n	c0de9308 <vformat_internal+0xd0>
                    if ((format[-1] == '0') && (ulCount == 0)) {
c0de92d2:	f082 0030 	eor.w	r0, r2, #48	@ 0x30
c0de92d6:	4318      	orrs	r0, r3
                    ulCount *= 10;
c0de92d8:	eb03 0083 	add.w	r0, r3, r3, lsl #2
                    ulCount += format[-1] - '0';
c0de92dc:	eb02 0040 	add.w	r0, r2, r0, lsl #1
                    if ((format[-1] == '0') && (ulCount == 0)) {
c0de92e0:	bf08      	it	eq
c0de92e2:	f04f 0c30 	moveq.w	ip, #48	@ 0x30
                    ulCount += format[-1] - '0';
c0de92e6:	f1a0 0330 	sub.w	r3, r0, #48	@ 0x30
c0de92ea:	e7e8      	b.n	c0de92be <vformat_internal+0x86>
            switch (*format++) {
c0de92ec:	2a25      	cmp	r2, #37	@ 0x25
c0de92ee:	d0b3      	beq.n	c0de9258 <vformat_internal+0x20>
c0de92f0:	2a2a      	cmp	r2, #42	@ 0x2a
c0de92f2:	f040 82e0 	bne.w	c0de98b6 <vformat_internal+0x67e>
                    if (*format == 's') {
c0de92f6:	f89a 0000 	ldrb.w	r0, [sl]
c0de92fa:	2873      	cmp	r0, #115	@ 0x73
c0de92fc:	f040 82db 	bne.w	c0de98b6 <vformat_internal+0x67e>
c0de9300:	f857 5b04 	ldr.w	r5, [r7], #4
c0de9304:	2102      	movs	r1, #2
c0de9306:	e7da      	b.n	c0de92be <vformat_internal+0x86>
            switch (*format++) {
c0de9308:	2a2e      	cmp	r2, #46	@ 0x2e
c0de930a:	f040 82d4 	bne.w	c0de98b6 <vformat_internal+0x67e>
                    if (format[0] == '*'
c0de930e:	f89a 0000 	ldrb.w	r0, [sl]
                        && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de9312:	282a      	cmp	r0, #42	@ 0x2a
c0de9314:	f040 82cf 	bne.w	c0de98b6 <vformat_internal+0x67e>
c0de9318:	f81a 0f01 	ldrb.w	r0, [sl, #1]!
c0de931c:	2101      	movs	r1, #1
c0de931e:	2848      	cmp	r0, #72	@ 0x48
c0de9320:	d004      	beq.n	c0de932c <vformat_internal+0xf4>
c0de9322:	2868      	cmp	r0, #104	@ 0x68
c0de9324:	d002      	beq.n	c0de932c <vformat_internal+0xf4>
c0de9326:	2873      	cmp	r0, #115	@ 0x73
c0de9328:	f040 82c5 	bne.w	c0de98b6 <vformat_internal+0x67e>
c0de932c:	f857 5b04 	ldr.w	r5, [r7], #4
c0de9330:	e7c5      	b.n	c0de92be <vformat_internal+0x86>
c0de9332:	bf00      	nop
            switch (*format++) {
c0de9334:	2a6b      	cmp	r2, #107	@ 0x6b
c0de9336:	dc11      	bgt.n	c0de935c <vformat_internal+0x124>
c0de9338:	2a62      	cmp	r2, #98	@ 0x62
c0de933a:	dd18      	ble.n	c0de936e <vformat_internal+0x136>
c0de933c:	2a63      	cmp	r2, #99	@ 0x63
c0de933e:	d02a      	beq.n	c0de9396 <vformat_internal+0x15e>
c0de9340:	2a64      	cmp	r2, #100	@ 0x64
c0de9342:	d02d      	beq.n	c0de93a0 <vformat_internal+0x168>
c0de9344:	2a68      	cmp	r2, #104	@ 0x68
c0de9346:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de934a:	f040 82b4 	bne.w	c0de98b6 <vformat_internal+0x67e>
c0de934e:	f242 16ec 	movw	r6, #8684	@ 0x21ec
c0de9352:	f2c0 0600 	movt	r6, #0
c0de9356:	2001      	movs	r0, #1
c0de9358:	447e      	add	r6, pc
c0de935a:	e042      	b.n	c0de93e2 <vformat_internal+0x1aa>
c0de935c:	2a72      	cmp	r2, #114	@ 0x72
c0de935e:	dd0d      	ble.n	c0de937c <vformat_internal+0x144>
c0de9360:	2a73      	cmp	r2, #115	@ 0x73
c0de9362:	d029      	beq.n	c0de93b8 <vformat_internal+0x180>
c0de9364:	2a75      	cmp	r2, #117	@ 0x75
c0de9366:	d02e      	beq.n	c0de93c6 <vformat_internal+0x18e>
c0de9368:	2a78      	cmp	r2, #120	@ 0x78
c0de936a:	d00c      	beq.n	c0de9386 <vformat_internal+0x14e>
c0de936c:	e2a3      	b.n	c0de98b6 <vformat_internal+0x67e>
c0de936e:	2a48      	cmp	r2, #72	@ 0x48
c0de9370:	d031      	beq.n	c0de93d6 <vformat_internal+0x19e>
c0de9372:	2a58      	cmp	r2, #88	@ 0x58
c0de9374:	f040 829f 	bne.w	c0de98b6 <vformat_internal+0x67e>
c0de9378:	2001      	movs	r0, #1
c0de937a:	e005      	b.n	c0de9388 <vformat_internal+0x150>
c0de937c:	2a6c      	cmp	r2, #108	@ 0x6c
c0de937e:	d059      	beq.n	c0de9434 <vformat_internal+0x1fc>
c0de9380:	2a70      	cmp	r2, #112	@ 0x70
c0de9382:	f040 8298 	bne.w	c0de98b6 <vformat_internal+0x67e>
c0de9386:	2000      	movs	r0, #0
c0de9388:	e9cd 7004 	strd	r7, r0, [sp, #16]
c0de938c:	6838      	ldr	r0, [r7, #0]
c0de938e:	2710      	movs	r7, #16
c0de9390:	9011      	str	r0, [sp, #68]	@ 0x44
c0de9392:	2500      	movs	r5, #0
c0de9394:	e0f4      	b.n	c0de9580 <vformat_internal+0x348>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de9396:	f857 0b04 	ldr.w	r0, [r7], #4
c0de939a:	9011      	str	r0, [sp, #68]	@ 0x44
                    output((char *) &ulValue, 1, output_ctx);
c0de939c:	a811      	add	r0, sp, #68	@ 0x44
c0de939e:	e760      	b.n	c0de9262 <vformat_internal+0x2a>
                    ulValue = va_arg(vaArgP, unsigned int);
c0de93a0:	6838      	ldr	r0, [r7, #0]
c0de93a2:	9704      	str	r7, [sp, #16]
                    if ((long) ulValue < 0) {
c0de93a4:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
                    ulValue = va_arg(vaArgP, unsigned int);
c0de93a8:	9011      	str	r0, [sp, #68]	@ 0x44
                    if ((long) ulValue < 0) {
c0de93aa:	f340 80e0 	ble.w	c0de956e <vformat_internal+0x336>
c0de93ae:	2000      	movs	r0, #0
c0de93b0:	270a      	movs	r7, #10
c0de93b2:	2500      	movs	r5, #0
c0de93b4:	9005      	str	r0, [sp, #20]
c0de93b6:	e0e0      	b.n	c0de957a <vformat_internal+0x342>
c0de93b8:	f242 1682 	movw	r6, #8578	@ 0x2182
c0de93bc:	f2c0 0600 	movt	r6, #0
c0de93c0:	2000      	movs	r0, #0
c0de93c2:	447e      	add	r6, pc
c0de93c4:	e00d      	b.n	c0de93e2 <vformat_internal+0x1aa>
                    ulValue = va_arg(vaArgP, unsigned int);
c0de93c6:	6838      	ldr	r0, [r7, #0]
c0de93c8:	9704      	str	r7, [sp, #16]
c0de93ca:	9011      	str	r0, [sp, #68]	@ 0x44
c0de93cc:	270a      	movs	r7, #10
c0de93ce:	2500      	movs	r5, #0
c0de93d0:	2000      	movs	r0, #0
                    goto convert;
c0de93d2:	9005      	str	r0, [sp, #20]
c0de93d4:	e0d4      	b.n	c0de9580 <vformat_internal+0x348>
c0de93d6:	f242 1674 	movw	r6, #8564	@ 0x2174
c0de93da:	f2c0 0600 	movt	r6, #0
c0de93de:	2001      	movs	r0, #1
c0de93e0:	447e      	add	r6, pc
                    pcStr = va_arg(vaArgP, char *);
c0de93e2:	f857 4b04 	ldr.w	r4, [r7], #4
                    switch (cStrlenSet) {
c0de93e6:	b2c9      	uxtb	r1, r1
c0de93e8:	2900      	cmp	r1, #0
c0de93ea:	d05e      	beq.n	c0de94aa <vformat_internal+0x272>
c0de93ec:	2901      	cmp	r1, #1
c0de93ee:	d064      	beq.n	c0de94ba <vformat_internal+0x282>
c0de93f0:	2902      	cmp	r1, #2
c0de93f2:	d163      	bne.n	c0de94bc <vformat_internal+0x284>
                            if (pcStr[0] == '\0') {
c0de93f4:	7820      	ldrb	r0, [r4, #0]
c0de93f6:	2800      	cmp	r0, #0
c0de93f8:	f040 825d 	bne.w	c0de98b6 <vformat_internal+0x67e>
                                for (ulCount = 0; ulCount < ulStrlen; ulCount++) {
c0de93fc:	2d00      	cmp	r5, #0
c0de93fe:	f000 8168 	beq.w	c0de96d2 <vformat_internal+0x49a>
c0de9402:	9704      	str	r7, [sp, #16]
c0de9404:	9f08      	ldr	r7, [sp, #32]
c0de9406:	f641 16d1 	movw	r6, #6609	@ 0x19d1
c0de940a:	f2c0 0600 	movt	r6, #0
c0de940e:	462c      	mov	r4, r5
c0de9410:	447e      	add	r6, pc
c0de9412:	bf00      	nop
                                    output(" ", 1, output_ctx);
c0de9414:	4630      	mov	r0, r6
c0de9416:	2101      	movs	r1, #1
c0de9418:	4642      	mov	r2, r8
c0de941a:	47b8      	blx	r7
                                for (ulCount = 0; ulCount < ulStrlen; ulCount++) {
c0de941c:	3c01      	subs	r4, #1
c0de941e:	d1f9      	bne.n	c0de9414 <vformat_internal+0x1dc>
c0de9420:	462b      	mov	r3, r5
c0de9422:	4635      	mov	r5, r6
c0de9424:	463e      	mov	r6, r7
c0de9426:	9f04      	ldr	r7, [sp, #16]
c0de9428:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
                    if (ulCount > ulIdx) {
c0de942c:	455b      	cmp	r3, fp
c0de942e:	f67f af1d 	bls.w	c0de926c <vformat_internal+0x34>
c0de9432:	e093      	b.n	c0de955c <vformat_internal+0x324>
                    if (*format == 'l'
c0de9434:	f89a 0000 	ldrb.w	r0, [sl]
                        && (*(format + 1) == 'u' || *(format + 1) == 'd' || *(format + 1) == 'x'
c0de9438:	286c      	cmp	r0, #108	@ 0x6c
c0de943a:	f040 823c 	bne.w	c0de98b6 <vformat_internal+0x67e>
c0de943e:	4656      	mov	r6, sl
c0de9440:	f816 1f01 	ldrb.w	r1, [r6, #1]!
c0de9444:	f1a1 0064 	sub.w	r0, r1, #100	@ 0x64
c0de9448:	2814      	cmp	r0, #20
c0de944a:	d807      	bhi.n	c0de945c <vformat_internal+0x224>
c0de944c:	2201      	movs	r2, #1
c0de944e:	fa02 f000 	lsl.w	r0, r2, r0
c0de9452:	2201      	movs	r2, #1
c0de9454:	f2c0 0212 	movt	r2, #18
c0de9458:	4210      	tst	r0, r2
c0de945a:	d102      	bne.n	c0de9462 <vformat_internal+0x22a>
c0de945c:	2958      	cmp	r1, #88	@ 0x58
c0de945e:	f040 822a 	bne.w	c0de98b6 <vformat_internal+0x67e>
                        int64_t  slValue64 = va_arg(vaArgP, int64_t);
c0de9462:	1df8      	adds	r0, r7, #7
c0de9464:	f020 0007 	bic.w	r0, r0, #7
c0de9468:	4602      	mov	r2, r0
c0de946a:	6847      	ldr	r7, [r0, #4]
c0de946c:	f852 5b08 	ldr.w	r5, [r2], #8
                        if (*format == 'd') {
c0de9470:	2974      	cmp	r1, #116	@ 0x74
c0de9472:	dc59      	bgt.n	c0de9528 <vformat_internal+0x2f0>
c0de9474:	2958      	cmp	r1, #88	@ 0x58
c0de9476:	f000 8137 	beq.w	c0de96e8 <vformat_internal+0x4b0>
c0de947a:	2964      	cmp	r1, #100	@ 0x64
c0de947c:	f040 814f 	bne.w	c0de971e <vformat_internal+0x4e6>
                            if (slValue64 < 0) {
c0de9480:	f10a 0002 	add.w	r0, sl, #2
c0de9484:	9001      	str	r0, [sp, #4]
c0de9486:	0ff8      	lsrs	r0, r7, #31
c0de9488:	9002      	str	r0, [sp, #8]
c0de948a:	eb15 70e7 	adds.w	r0, r5, r7, asr #31
c0de948e:	ea80 75e7 	eor.w	r5, r0, r7, asr #31
c0de9492:	eb47 70e7 	adc.w	r0, r7, r7, asr #31
c0de9496:	ea80 77e7 	eor.w	r7, r0, r7, asr #31
c0de949a:	f242 009e 	movw	r0, #8350	@ 0x209e
c0de949e:	f2c0 0000 	movt	r0, #0
c0de94a2:	f04f 080a 	mov.w	r8, #10
c0de94a6:	4478      	add	r0, pc
c0de94a8:	e137      	b.n	c0de971a <vformat_internal+0x4e2>
c0de94aa:	2100      	movs	r1, #0
                            for (ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++) {
c0de94ac:	5c62      	ldrb	r2, [r4, r1]
c0de94ae:	3101      	adds	r1, #1
c0de94b0:	2a00      	cmp	r2, #0
c0de94b2:	d1fb      	bne.n	c0de94ac <vformat_internal+0x274>
                    switch (ulBase) {
c0de94b4:	f1a1 0b01 	sub.w	fp, r1, #1
c0de94b8:	e000      	b.n	c0de94bc <vformat_internal+0x284>
c0de94ba:	46ab      	mov	fp, r5
c0de94bc:	f641 151d 	movw	r5, #6429	@ 0x191d
c0de94c0:	f2c0 0500 	movt	r5, #0
c0de94c4:	447d      	add	r5, pc
c0de94c6:	b310      	cbz	r0, c0de950e <vformat_internal+0x2d6>
                            for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de94c8:	f1bb 0f00 	cmp.w	fp, #0
c0de94cc:	d038      	beq.n	c0de9540 <vformat_internal+0x308>
c0de94ce:	2100      	movs	r1, #0
c0de94d0:	2500      	movs	r5, #0
c0de94d2:	e002      	b.n	c0de94da <vformat_internal+0x2a2>
c0de94d4:	3501      	adds	r5, #1
c0de94d6:	45ab      	cmp	fp, r5
c0de94d8:	d01d      	beq.n	c0de9516 <vformat_internal+0x2de>
                                nibble1 = (pcStr[ulCount] >> 4) & 0xF;
c0de94da:	5d60      	ldrb	r0, [r4, r5]
c0de94dc:	eb0e 0301 	add.w	r3, lr, r1
c0de94e0:	0902      	lsrs	r2, r0, #4
                                nibble2 = pcStr[ulCount] & 0xF;
c0de94e2:	f000 000f 	and.w	r0, r0, #15
c0de94e6:	5c30      	ldrb	r0, [r6, r0]
c0de94e8:	5cb2      	ldrb	r2, [r6, r2]
c0de94ea:	7058      	strb	r0, [r3, #1]
                                if (idx + 1 >= sizeof(pcBuf)) {
c0de94ec:	f1a1 001d 	sub.w	r0, r1, #29
c0de94f0:	f80e 2001 	strb.w	r2, [lr, r1]
c0de94f4:	f110 0f21 	cmn.w	r0, #33	@ 0x21
c0de94f8:	f101 0102 	add.w	r1, r1, #2
c0de94fc:	d8ea      	bhi.n	c0de94d4 <vformat_internal+0x29c>
                                    output(pcBuf, idx, output_ctx);
c0de94fe:	9b08      	ldr	r3, [sp, #32]
c0de9500:	4670      	mov	r0, lr
c0de9502:	4642      	mov	r2, r8
c0de9504:	4798      	blx	r3
c0de9506:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de950a:	2100      	movs	r1, #0
c0de950c:	e7e2      	b.n	c0de94d4 <vformat_internal+0x29c>
c0de950e:	9e08      	ldr	r6, [sp, #32]
                            output(pcStr, ulIdx, output_ctx);
c0de9510:	4620      	mov	r0, r4
c0de9512:	4659      	mov	r1, fp
c0de9514:	e019      	b.n	c0de954a <vformat_internal+0x312>
c0de9516:	9e08      	ldr	r6, [sp, #32]
c0de9518:	f641 05bf 	movw	r5, #6335	@ 0x18bf
c0de951c:	f2c0 0500 	movt	r5, #0
c0de9520:	465b      	mov	r3, fp
c0de9522:	447d      	add	r5, pc
                            if (idx != 0) {
c0de9524:	b981      	cbnz	r1, c0de9548 <vformat_internal+0x310>
c0de9526:	e016      	b.n	c0de9556 <vformat_internal+0x31e>
                        if (*format == 'd') {
c0de9528:	2975      	cmp	r1, #117	@ 0x75
c0de952a:	f000 80ea 	beq.w	c0de9702 <vformat_internal+0x4ca>
c0de952e:	2978      	cmp	r1, #120	@ 0x78
c0de9530:	f040 80f5 	bne.w	c0de971e <vformat_internal+0x4e6>
                        }
c0de9534:	f10a 0002 	add.w	r0, sl, #2
c0de9538:	9001      	str	r0, [sp, #4]
c0de953a:	f04f 0810 	mov.w	r8, #16
c0de953e:	e0e5      	b.n	c0de970c <vformat_internal+0x4d4>
c0de9540:	9e08      	ldr	r6, [sp, #32]
c0de9542:	2300      	movs	r3, #0
c0de9544:	2100      	movs	r1, #0
                            if (idx != 0) {
c0de9546:	b131      	cbz	r1, c0de9556 <vformat_internal+0x31e>
                                output(pcBuf, idx, output_ctx);
c0de9548:	4670      	mov	r0, lr
c0de954a:	4642      	mov	r2, r8
c0de954c:	461c      	mov	r4, r3
c0de954e:	47b0      	blx	r6
c0de9550:	4623      	mov	r3, r4
c0de9552:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
                    if (ulCount > ulIdx) {
c0de9556:	455b      	cmp	r3, fp
c0de9558:	f67f ae88 	bls.w	c0de926c <vformat_internal+0x34>
                        while (ulCount--) {
c0de955c:	ebab 0403 	sub.w	r4, fp, r3
                            output(" ", 1, output_ctx);
c0de9560:	4628      	mov	r0, r5
c0de9562:	2101      	movs	r1, #1
c0de9564:	4642      	mov	r2, r8
c0de9566:	47b0      	blx	r6
                        while (ulCount--) {
c0de9568:	3401      	adds	r4, #1
c0de956a:	d3f9      	bcc.n	c0de9560 <vformat_internal+0x328>
c0de956c:	e67c      	b.n	c0de9268 <vformat_internal+0x30>
                        ulValue = -(long) ((int) ulValue);
c0de956e:	4240      	negs	r0, r0
c0de9570:	9011      	str	r0, [sp, #68]	@ 0x44
c0de9572:	2000      	movs	r0, #0
c0de9574:	9005      	str	r0, [sp, #20]
c0de9576:	270a      	movs	r7, #10
c0de9578:	2501      	movs	r5, #1
c0de957a:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de957e:	bf00      	nop
c0de9580:	9911      	ldr	r1, [sp, #68]	@ 0x44
c0de9582:	461c      	mov	r4, r3
                         (((ulIdx * ulBase) <= ulValue) && (((ulIdx * ulBase) / ulBase) == ulIdx));
c0de9584:	428f      	cmp	r7, r1
c0de9586:	d903      	bls.n	c0de9590 <vformat_internal+0x358>
c0de9588:	f04f 0b01 	mov.w	fp, #1
c0de958c:	2001      	movs	r0, #1
c0de958e:	e00e      	b.n	c0de95ae <vformat_internal+0x376>
c0de9590:	2302      	movs	r3, #2
c0de9592:	463a      	mov	r2, r7
c0de9594:	4693      	mov	fp, r2
c0de9596:	fba7 2602 	umull	r2, r6, r7, r2
c0de959a:	2e00      	cmp	r6, #0
c0de959c:	bf18      	it	ne
c0de959e:	2601      	movne	r6, #1
c0de95a0:	428a      	cmp	r2, r1
c0de95a2:	4618      	mov	r0, r3
c0de95a4:	d803      	bhi.n	c0de95ae <vformat_internal+0x376>
                    for (ulIdx = 1;
c0de95a6:	2e00      	cmp	r6, #0
c0de95a8:	f100 0301 	add.w	r3, r0, #1
c0de95ac:	d0f2      	beq.n	c0de9594 <vformat_internal+0x35c>
    if (*ulNeg) {
c0de95ae:	4428      	add	r0, r5
c0de95b0:	f085 0101 	eor.w	r1, r5, #1
c0de95b4:	9506      	str	r5, [sp, #24]
    if (ulWidth > ulActualLen) {
c0de95b6:	ebb4 0800 	subs.w	r8, r4, r0
c0de95ba:	fa5f f58c 	uxtb.w	r5, ip
c0de95be:	4623      	mov	r3, r4
c0de95c0:	f04f 0400 	mov.w	r4, #0
c0de95c4:	bf38      	it	cc
c0de95c6:	46a0      	movcc	r8, r4
c0de95c8:	f1b5 0230 	subs.w	r2, r5, #48	@ 0x30
c0de95cc:	bf18      	it	ne
c0de95ce:	2201      	movne	r2, #1
    if (*ulNeg && (cFill == '0')) {
c0de95d0:	4311      	orrs	r1, r2
c0de95d2:	d105      	bne.n	c0de95e0 <vformat_internal+0x3a8>
        pcBuf[(*ulPos)++] = '-';
c0de95d4:	212d      	movs	r1, #45	@ 0x2d
c0de95d6:	f88d 1024 	strb.w	r1, [sp, #36]	@ 0x24
c0de95da:	2100      	movs	r1, #0
c0de95dc:	2401      	movs	r4, #1
c0de95de:	9106      	str	r1, [sp, #24]
c0de95e0:	9e08      	ldr	r6, [sp, #32]
    while (ulPaddingNeeded > 0) {
c0de95e2:	4298      	cmp	r0, r3
c0de95e4:	d314      	bcc.n	c0de9610 <vformat_internal+0x3d8>
    if (*ulNeg) {
c0de95e6:	9806      	ldr	r0, [sp, #24]
c0de95e8:	b388      	cbz	r0, c0de964e <vformat_internal+0x416>
        if (*ulPos >= PCBUF_SIZE) {
c0de95ea:	2c20      	cmp	r4, #32
c0de95ec:	d335      	bcc.n	c0de965a <vformat_internal+0x422>
c0de95ee:	f8dd 801c 	ldr.w	r8, [sp, #28]
            output(pcBuf, *ulPos, output_ctx);
c0de95f2:	4670      	mov	r0, lr
c0de95f4:	4621      	mov	r1, r4
c0de95f6:	4642      	mov	r2, r8
c0de95f8:	47b0      	blx	r6
c0de95fa:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de95fe:	2400      	movs	r4, #0
c0de9600:	e02d      	b.n	c0de965e <vformat_internal+0x426>
c0de9602:	bf00      	nop
c0de9604:	9e08      	ldr	r6, [sp, #32]
c0de9606:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
    while (ulPaddingNeeded > 0) {
c0de960a:	f1b8 0f00 	cmp.w	r8, #0
c0de960e:	d0ea      	beq.n	c0de95e6 <vformat_internal+0x3ae>
        unsigned long bufferSpace = PCBUF_SIZE - *ulPos;
c0de9610:	f1c4 0620 	rsb	r6, r4, #32
        if (chunkSize > bufferSpace) {
c0de9614:	45b0      	cmp	r8, r6
c0de9616:	bf98      	it	ls
c0de9618:	4646      	movls	r6, r8
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de961a:	b136      	cbz	r6, c0de962a <vformat_internal+0x3f2>
c0de961c:	eb0e 0004 	add.w	r0, lr, r4
            pcBuf[(*ulPos)++] = cFill;
c0de9620:	4631      	mov	r1, r6
c0de9622:	462a      	mov	r2, r5
c0de9624:	f000 fbc4 	bl	c0de9db0 <__aeabi_memset>
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de9628:	4434      	add	r4, r6
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de962a:	2c20      	cmp	r4, #32
        ulPaddingNeeded -= chunkSize;
c0de962c:	eba8 0806 	sub.w	r8, r8, r6
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de9630:	d3e8      	bcc.n	c0de9604 <vformat_internal+0x3cc>
c0de9632:	9e08      	ldr	r6, [sp, #32]
c0de9634:	f1b8 0f00 	cmp.w	r8, #0
c0de9638:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de963c:	d0e5      	beq.n	c0de960a <vformat_internal+0x3d2>
            output(pcBuf, *ulPos, output_ctx);
c0de963e:	9a07      	ldr	r2, [sp, #28]
c0de9640:	4670      	mov	r0, lr
c0de9642:	4621      	mov	r1, r4
c0de9644:	47b0      	blx	r6
c0de9646:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de964a:	2400      	movs	r4, #0
c0de964c:	e7dd      	b.n	c0de960a <vformat_internal+0x3d2>
c0de964e:	f8dd 801c 	ldr.w	r8, [sp, #28]
                    for (; ulIdx; ulIdx /= ulBase) {
c0de9652:	f1bb 0f00 	cmp.w	fp, #0
c0de9656:	d109      	bne.n	c0de966c <vformat_internal+0x434>
c0de9658:	e032      	b.n	c0de96c0 <vformat_internal+0x488>
c0de965a:	f8dd 801c 	ldr.w	r8, [sp, #28]
        pcBuf[(*ulPos)++] = '-';
c0de965e:	202d      	movs	r0, #45	@ 0x2d
c0de9660:	f80e 0004 	strb.w	r0, [lr, r4]
c0de9664:	3401      	adds	r4, #1
                    for (; ulIdx; ulIdx /= ulBase) {
c0de9666:	f1bb 0f00 	cmp.w	fp, #0
c0de966a:	d029      	beq.n	c0de96c0 <vformat_internal+0x488>
c0de966c:	9805      	ldr	r0, [sp, #20]
c0de966e:	f641 65d8 	movw	r5, #7896	@ 0x1ed8
c0de9672:	2800      	cmp	r0, #0
c0de9674:	f2c0 0500 	movt	r5, #0
c0de9678:	f641 60c2 	movw	r0, #7874	@ 0x1ec2
c0de967c:	447d      	add	r5, pc
c0de967e:	f2c0 0000 	movt	r0, #0
c0de9682:	4478      	add	r0, pc
c0de9684:	bf08      	it	eq
c0de9686:	4605      	moveq	r5, r0
c0de9688:	e010      	b.n	c0de96ac <vformat_internal+0x474>
c0de968a:	bf00      	nop
c0de968c:	9811      	ldr	r0, [sp, #68]	@ 0x44
c0de968e:	455f      	cmp	r7, fp
c0de9690:	fbb0 f0fb 	udiv	r0, r0, fp
c0de9694:	fbbb fbf7 	udiv	fp, fp, r7
c0de9698:	fbb0 f1f7 	udiv	r1, r0, r7
c0de969c:	fb01 0017 	mls	r0, r1, r7, r0
c0de96a0:	5c28      	ldrb	r0, [r5, r0]
c0de96a2:	f80e 0004 	strb.w	r0, [lr, r4]
c0de96a6:	f104 0401 	add.w	r4, r4, #1
c0de96aa:	d809      	bhi.n	c0de96c0 <vformat_internal+0x488>
                        if (ulPos >= PCBUF_SIZE) {
c0de96ac:	2c20      	cmp	r4, #32
c0de96ae:	d3ed      	bcc.n	c0de968c <vformat_internal+0x454>
                            output(pcBuf, ulPos, output_ctx);
c0de96b0:	4670      	mov	r0, lr
c0de96b2:	4621      	mov	r1, r4
c0de96b4:	4642      	mov	r2, r8
c0de96b6:	47b0      	blx	r6
c0de96b8:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de96bc:	2400      	movs	r4, #0
c0de96be:	e7e5      	b.n	c0de968c <vformat_internal+0x454>
c0de96c0:	9f04      	ldr	r7, [sp, #16]
                    if (ulPos > 0) {
c0de96c2:	2c00      	cmp	r4, #0
c0de96c4:	f107 0704 	add.w	r7, r7, #4
c0de96c8:	f43f add0 	beq.w	c0de926c <vformat_internal+0x34>
                        output(pcBuf, ulPos, output_ctx);
c0de96cc:	4670      	mov	r0, lr
c0de96ce:	4621      	mov	r1, r4
c0de96d0:	e5c8      	b.n	c0de9264 <vformat_internal+0x2c>
c0de96d2:	9e08      	ldr	r6, [sp, #32]
c0de96d4:	f241 7503 	movw	r5, #5891	@ 0x1703
c0de96d8:	f2c0 0500 	movt	r5, #0
c0de96dc:	2300      	movs	r3, #0
c0de96de:	447d      	add	r5, pc
                    if (ulCount > ulIdx) {
c0de96e0:	455b      	cmp	r3, fp
c0de96e2:	f67f adc3 	bls.w	c0de926c <vformat_internal+0x34>
c0de96e6:	e739      	b.n	c0de955c <vformat_internal+0x324>
                        }
c0de96e8:	f10a 0002 	add.w	r0, sl, #2
c0de96ec:	9001      	str	r0, [sp, #4]
c0de96ee:	2000      	movs	r0, #0
c0de96f0:	9002      	str	r0, [sp, #8]
c0de96f2:	f641 6056 	movw	r0, #7766	@ 0x1e56
c0de96f6:	f2c0 0000 	movt	r0, #0
c0de96fa:	f04f 0810 	mov.w	r8, #16
c0de96fe:	4478      	add	r0, pc
c0de9700:	e00b      	b.n	c0de971a <vformat_internal+0x4e2>
                        }
c0de9702:	f10a 0002 	add.w	r0, sl, #2
c0de9706:	f04f 080a 	mov.w	r8, #10
c0de970a:	9001      	str	r0, [sp, #4]
c0de970c:	2000      	movs	r0, #0
c0de970e:	9002      	str	r0, [sp, #8]
c0de9710:	f641 602c 	movw	r0, #7724	@ 0x1e2c
c0de9714:	f2c0 0000 	movt	r0, #0
c0de9718:	4478      	add	r0, pc
c0de971a:	9005      	str	r0, [sp, #20]
c0de971c:	e00c      	b.n	c0de9738 <vformat_internal+0x500>
c0de971e:	2000      	movs	r0, #0
c0de9720:	9601      	str	r6, [sp, #4]
c0de9722:	9002      	str	r0, [sp, #8]
c0de9724:	f641 6018 	movw	r0, #7704	@ 0x1e18
c0de9728:	f2c0 0000 	movt	r0, #0
c0de972c:	4478      	add	r0, pc
c0de972e:	f04f 080a 	mov.w	r8, #10
c0de9732:	9005      	str	r0, [sp, #20]
c0de9734:	2500      	movs	r5, #0
c0de9736:	2700      	movs	r7, #0
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de9738:	ebb5 0008 	subs.w	r0, r5, r8
c0de973c:	f04f 0a00 	mov.w	sl, #0
c0de9740:	469b      	mov	fp, r3
c0de9742:	f177 0000 	sbcs.w	r0, r7, #0
c0de9746:	f04f 0400 	mov.w	r4, #0
c0de974a:	9204      	str	r2, [sp, #16]
c0de974c:	9506      	str	r5, [sp, #24]
c0de974e:	9703      	str	r7, [sp, #12]
                                           && (((ulIdx64 * ulBase) / ulBase) == ulIdx64));
c0de9750:	d203      	bcs.n	c0de975a <vformat_internal+0x522>
c0de9752:	2201      	movs	r2, #1
c0de9754:	2501      	movs	r5, #1
c0de9756:	2700      	movs	r7, #0
c0de9758:	e01a      	b.n	c0de9790 <vformat_internal+0x558>
c0de975a:	2100      	movs	r1, #0
c0de975c:	f04f 0e02 	mov.w	lr, #2
c0de9760:	4643      	mov	r3, r8
c0de9762:	bf00      	nop
c0de9764:	460f      	mov	r7, r1
c0de9766:	461d      	mov	r5, r3
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de9768:	fba8 3003 	umull	r3, r0, r8, r3
c0de976c:	fba1 1608 	umull	r1, r6, r1, r8
c0de9770:	1809      	adds	r1, r1, r0
c0de9772:	f14a 0000 	adc.w	r0, sl, #0
c0de9776:	2e00      	cmp	r6, #0
c0de9778:	bf18      	it	ne
c0de977a:	2601      	movne	r6, #1
c0de977c:	9a06      	ldr	r2, [sp, #24]
c0de977e:	1ad2      	subs	r2, r2, r3
c0de9780:	9a03      	ldr	r2, [sp, #12]
c0de9782:	418a      	sbcs	r2, r1
c0de9784:	4672      	mov	r2, lr
                                           && (((ulIdx64 * ulBase) / ulBase) == ulIdx64));
c0de9786:	d303      	bcc.n	c0de9790 <vformat_internal+0x558>
c0de9788:	4330      	orrs	r0, r6
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de978a:	f102 0e01 	add.w	lr, r2, #1
c0de978e:	d0e9      	beq.n	c0de9764 <vformat_internal+0x52c>
c0de9790:	9802      	ldr	r0, [sp, #8]
    if (*ulNeg) {
c0de9792:	1811      	adds	r1, r2, r0
    if (ulWidth > ulActualLen) {
c0de9794:	ebbb 0a01 	subs.w	sl, fp, r1
c0de9798:	fa5f f28c 	uxtb.w	r2, ip
c0de979c:	bf38      	it	cc
c0de979e:	46a2      	movcc	sl, r4
c0de97a0:	4616      	mov	r6, r2
    if (*ulNeg && (cFill == '0')) {
c0de97a2:	2a30      	cmp	r2, #48	@ 0x30
c0de97a4:	d15d      	bne.n	c0de9862 <vformat_internal+0x62a>
c0de97a6:	2800      	cmp	r0, #0
c0de97a8:	a809      	add	r0, sp, #36	@ 0x24
c0de97aa:	d005      	beq.n	c0de97b8 <vformat_internal+0x580>
        pcBuf[(*ulPos)++] = '-';
c0de97ac:	222d      	movs	r2, #45	@ 0x2d
c0de97ae:	f88d 2024 	strb.w	r2, [sp, #36]	@ 0x24
c0de97b2:	2200      	movs	r2, #0
c0de97b4:	2401      	movs	r4, #1
c0de97b6:	9202      	str	r2, [sp, #8]
    while (ulPaddingNeeded > 0) {
c0de97b8:	4559      	cmp	r1, fp
c0de97ba:	d35b      	bcc.n	c0de9874 <vformat_internal+0x63c>
    if (*ulNeg) {
c0de97bc:	9902      	ldr	r1, [sp, #8]
c0de97be:	b169      	cbz	r1, c0de97dc <vformat_internal+0x5a4>
c0de97c0:	f8dd a00c 	ldr.w	sl, [sp, #12]
        if (*ulPos >= PCBUF_SIZE) {
c0de97c4:	2c20      	cmp	r4, #32
c0de97c6:	d305      	bcc.n	c0de97d4 <vformat_internal+0x59c>
            output(pcBuf, *ulPos, output_ctx);
c0de97c8:	e9dd 2307 	ldrd	r2, r3, [sp, #28]
c0de97cc:	4621      	mov	r1, r4
c0de97ce:	4798      	blx	r3
c0de97d0:	a809      	add	r0, sp, #36	@ 0x24
c0de97d2:	2400      	movs	r4, #0
        pcBuf[(*ulPos)++] = '-';
c0de97d4:	212d      	movs	r1, #45	@ 0x2d
c0de97d6:	5501      	strb	r1, [r0, r4]
c0de97d8:	3401      	adds	r4, #1
c0de97da:	e001      	b.n	c0de97e0 <vformat_internal+0x5a8>
c0de97dc:	f8dd a00c 	ldr.w	sl, [sp, #12]
c0de97e0:	f8dd b020 	ldr.w	fp, [sp, #32]
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de97e4:	ea55 0007 	orrs.w	r0, r5, r7
c0de97e8:	d129      	bne.n	c0de983e <vformat_internal+0x606>
                        if (ulPos > 0) {
c0de97ea:	b38c      	cbz	r4, c0de9850 <vformat_internal+0x618>
c0de97ec:	f8dd 801c 	ldr.w	r8, [sp, #28]
c0de97f0:	ad09      	add	r5, sp, #36	@ 0x24
                            output(pcBuf, ulPos, output_ctx);
c0de97f2:	4628      	mov	r0, r5
c0de97f4:	4621      	mov	r1, r4
c0de97f6:	4642      	mov	r2, r8
c0de97f8:	465e      	mov	r6, fp
c0de97fa:	47d8      	blx	fp
c0de97fc:	f8dd a004 	ldr.w	sl, [sp, #4]
c0de9800:	9f04      	ldr	r7, [sp, #16]
c0de9802:	46ae      	mov	lr, r5
c0de9804:	e532      	b.n	c0de926c <vformat_internal+0x34>
c0de9806:	bf00      	nop
c0de9808:	9806      	ldr	r0, [sp, #24]
c0de980a:	4651      	mov	r1, sl
c0de980c:	462a      	mov	r2, r5
c0de980e:	463b      	mov	r3, r7
c0de9810:	f000 fad8 	bl	c0de9dc4 <__aeabi_uldivmod>
c0de9814:	4642      	mov	r2, r8
c0de9816:	2300      	movs	r3, #0
c0de9818:	f000 fad4 	bl	c0de9dc4 <__aeabi_uldivmod>
c0de981c:	9805      	ldr	r0, [sp, #20]
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de981e:	4639      	mov	r1, r7
c0de9820:	5c80      	ldrb	r0, [r0, r2]
c0de9822:	4642      	mov	r2, r8
c0de9824:	5530      	strb	r0, [r6, r4]
c0de9826:	4628      	mov	r0, r5
c0de9828:	2300      	movs	r3, #0
c0de982a:	3401      	adds	r4, #1
c0de982c:	f000 faca 	bl	c0de9dc4 <__aeabi_uldivmod>
c0de9830:	ebb5 0208 	subs.w	r2, r5, r8
c0de9834:	f177 0200 	sbcs.w	r2, r7, #0
c0de9838:	4605      	mov	r5, r0
c0de983a:	460f      	mov	r7, r1
c0de983c:	d3d5      	bcc.n	c0de97ea <vformat_internal+0x5b2>
c0de983e:	ae09      	add	r6, sp, #36	@ 0x24
                            if (ulPos >= PCBUF_SIZE) {
c0de9840:	2c20      	cmp	r4, #32
c0de9842:	d3e1      	bcc.n	c0de9808 <vformat_internal+0x5d0>
                                output(pcBuf, ulPos, output_ctx);
c0de9844:	9a07      	ldr	r2, [sp, #28]
c0de9846:	4630      	mov	r0, r6
c0de9848:	4621      	mov	r1, r4
c0de984a:	47d8      	blx	fp
c0de984c:	2400      	movs	r4, #0
c0de984e:	e7db      	b.n	c0de9808 <vformat_internal+0x5d0>
c0de9850:	f8dd a004 	ldr.w	sl, [sp, #4]
c0de9854:	f8dd 801c 	ldr.w	r8, [sp, #28]
c0de9858:	9f04      	ldr	r7, [sp, #16]
c0de985a:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de985e:	465e      	mov	r6, fp
c0de9860:	e504      	b.n	c0de926c <vformat_internal+0x34>
c0de9862:	a809      	add	r0, sp, #36	@ 0x24
    while (ulPaddingNeeded > 0) {
c0de9864:	4559      	cmp	r1, fp
c0de9866:	d305      	bcc.n	c0de9874 <vformat_internal+0x63c>
c0de9868:	e7a8      	b.n	c0de97bc <vformat_internal+0x584>
c0de986a:	bf00      	nop
c0de986c:	a809      	add	r0, sp, #36	@ 0x24
c0de986e:	f1ba 0f00 	cmp.w	sl, #0
c0de9872:	d0a3      	beq.n	c0de97bc <vformat_internal+0x584>
        unsigned long bufferSpace = PCBUF_SIZE - *ulPos;
c0de9874:	f1c4 0b20 	rsb	fp, r4, #32
        if (chunkSize > bufferSpace) {
c0de9878:	45da      	cmp	sl, fp
c0de987a:	bf98      	it	ls
c0de987c:	46d3      	movls	fp, sl
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de987e:	f1bb 0f00 	cmp.w	fp, #0
c0de9882:	d005      	beq.n	c0de9890 <vformat_internal+0x658>
c0de9884:	4420      	add	r0, r4
            pcBuf[(*ulPos)++] = cFill;
c0de9886:	4659      	mov	r1, fp
c0de9888:	4632      	mov	r2, r6
c0de988a:	f000 fa91 	bl	c0de9db0 <__aeabi_memset>
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de988e:	445c      	add	r4, fp
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de9890:	2c20      	cmp	r4, #32
        ulPaddingNeeded -= chunkSize;
c0de9892:	ebaa 0a0b 	sub.w	sl, sl, fp
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de9896:	d3e9      	bcc.n	c0de986c <vformat_internal+0x634>
c0de9898:	f1ba 0f00 	cmp.w	sl, #0
c0de989c:	a809      	add	r0, sp, #36	@ 0x24
c0de989e:	d0e6      	beq.n	c0de986e <vformat_internal+0x636>
            output(pcBuf, *ulPos, output_ctx);
c0de98a0:	e9dd 2307 	ldrd	r2, r3, [sp, #28]
c0de98a4:	4621      	mov	r1, r4
c0de98a6:	4798      	blx	r3
c0de98a8:	a809      	add	r0, sp, #36	@ 0x24
c0de98aa:	2400      	movs	r4, #0
c0de98ac:	e7df      	b.n	c0de986e <vformat_internal+0x636>
c0de98ae:	2000      	movs	r0, #0
}
c0de98b0:	b012      	add	sp, #72	@ 0x48
c0de98b2:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de98b6:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de98ba:	b012      	add	sp, #72	@ 0x48
c0de98bc:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de98c0 <snprintf>:
#endif  // HAVE_PRINTF
#endif  // BUILD_SCREENSHOTS

#ifdef HAVE_SPRINTF
int snprintf(char *str, size_t str_size, const char *format, ...)
{
c0de98c0:	b081      	sub	sp, #4
c0de98c2:	b570      	push	{r4, r5, r6, lr}
c0de98c4:	b085      	sub	sp, #20
c0de98c6:	4605      	mov	r5, r0
    va_list       vaArgP;
    sprintf_ctx_t ctx;
    int           result;

    if (str == NULL || str_size < 1) {
c0de98c8:	2800      	cmp	r0, #0
c0de98ca:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de98ce:	9309      	str	r3, [sp, #36]	@ 0x24
c0de98d0:	d01d      	beq.n	c0de990e <snprintf+0x4e>
c0de98d2:	460e      	mov	r6, r1
c0de98d4:	b1d9      	cbz	r1, c0de990e <snprintf+0x4e>
        return -1;  // Error: invalid arguments
    }

    memset(str, 0, str_size);
c0de98d6:	4628      	mov	r0, r5
c0de98d8:	4631      	mov	r1, r6
c0de98da:	4614      	mov	r4, r2
c0de98dc:	f000 fa6e 	bl	c0de9dbc <__aeabi_memclr>
    // Reserve space for null terminator
    str_size--;
c0de98e0:	1e70      	subs	r0, r6, #1

    ctx.str      = str;
c0de98e2:	e9cd 5001 	strd	r5, r0, [sp, #4]
c0de98e6:	2000      	movs	r0, #0
c0de98e8:	ab09      	add	r3, sp, #36	@ 0x24
    ctx.str_size = str_size;
    ctx.written  = 0;  // Initialize counter
c0de98ea:	9003      	str	r0, [sp, #12]

    va_start(vaArgP, format);
c0de98ec:	9304      	str	r3, [sp, #16]
    result = vformat_internal(sprintf_output, &ctx, format, vaArgP);
c0de98ee:	f240 001f 	movw	r0, #31
c0de98f2:	f2c0 0000 	movt	r0, #0
c0de98f6:	4478      	add	r0, pc
c0de98f8:	a901      	add	r1, sp, #4
c0de98fa:	4622      	mov	r2, r4
c0de98fc:	f7ff fc9c 	bl	c0de9238 <vformat_internal>
c0de9900:	4601      	mov	r1, r0
c0de9902:	9803      	ldr	r0, [sp, #12]
    va_end(vaArgP);

    // If format error, return -1
    if (result < 0) {
c0de9904:	f1b1 3fff 	cmp.w	r1, #4294967295	@ 0xffffffff
c0de9908:	bfd8      	it	le
c0de990a:	f04f 30ff 	movle.w	r0, #4294967295	@ 0xffffffff
        return -1;
    }
    return ctx.written;  // Return number of characters written
}
c0de990e:	b005      	add	sp, #20
c0de9910:	e8bd 4070 	ldmia.w	sp!, {r4, r5, r6, lr}
c0de9914:	b001      	add	sp, #4
c0de9916:	4770      	bx	lr

c0de9918 <sprintf_output>:
{
c0de9918:	b5b0      	push	{r4, r5, r7, lr}
c0de991a:	4614      	mov	r4, r2
c0de991c:	4684      	mov	ip, r0
    ctx->written += len;
c0de991e:	6892      	ldr	r2, [r2, #8]
    if (ctx->str_size == 0) {
c0de9920:	6860      	ldr	r0, [r4, #4]
    ctx->written += len;
c0de9922:	440a      	add	r2, r1
    if (ctx->str_size == 0) {
c0de9924:	2800      	cmp	r0, #0
    ctx->written += len;
c0de9926:	60a2      	str	r2, [r4, #8]
}
c0de9928:	bf08      	it	eq
c0de992a:	bdb0      	popeq	{r4, r5, r7, pc}
    if (len > ctx->str_size) {
c0de992c:	4288      	cmp	r0, r1
c0de992e:	bf38      	it	cc
c0de9930:	4601      	movcc	r1, r0
    if (!data || len < 1) {
c0de9932:	f1bc 0f00 	cmp.w	ip, #0
c0de9936:	f04f 0300 	mov.w	r3, #0
c0de993a:	bf18      	it	ne
c0de993c:	2900      	cmpne	r1, #0
c0de993e:	d10e      	bne.n	c0de995e <sprintf_output+0x46>
    len -= nb_truncated_bytes;
c0de9940:	1acd      	subs	r5, r1, r3
    ctx->str_size -= nb_truncated_bytes;
c0de9942:	1ac1      	subs	r1, r0, r3
    memmove(ctx->str, data, len);
c0de9944:	6820      	ldr	r0, [r4, #0]
    ctx->str_size -= nb_truncated_bytes;
c0de9946:	6061      	str	r1, [r4, #4]
    memmove(ctx->str, data, len);
c0de9948:	4661      	mov	r1, ip
c0de994a:	462a      	mov	r2, r5
c0de994c:	f000 fa2e 	bl	c0de9dac <__aeabi_memmove>
    ctx->str += len;
c0de9950:	e9d4 0100 	ldrd	r0, r1, [r4]
c0de9954:	4428      	add	r0, r5
    ctx->str_size -= len;
c0de9956:	1b49      	subs	r1, r1, r5
    ctx->str += len;
c0de9958:	e9c4 0100 	strd	r0, r1, [r4]
}
c0de995c:	bdb0      	pop	{r4, r5, r7, pc}
    size_t  index = len - 1;
c0de995e:	1e4b      	subs	r3, r1, #1
    uint8_t c     = data[index];
c0de9960:	f91c 2003 	ldrsb.w	r2, [ip, r3]
    if (!(c & 0x80)) {
c0de9964:	f1b2 3fff 	cmp.w	r2, #4294967295	@ 0xffffffff
c0de9968:	dd01      	ble.n	c0de996e <sprintf_output+0x56>
c0de996a:	2300      	movs	r3, #0
c0de996c:	e7e8      	b.n	c0de9940 <sprintf_output+0x28>
c0de996e:	b2d5      	uxtb	r5, r2
    while (index >= 1 && c < 0xC0) {
c0de9970:	b17b      	cbz	r3, c0de9992 <sprintf_output+0x7a>
c0de9972:	2dbf      	cmp	r5, #191	@ 0xbf
c0de9974:	d80d      	bhi.n	c0de9992 <sprintf_output+0x7a>
c0de9976:	1e8b      	subs	r3, r1, #2
c0de9978:	b26a      	sxtb	r2, r5
        if (!(c & 0x80)) {  // This is not expected...
c0de997a:	f1b2 3fff 	cmp.w	r2, #4294967295	@ 0xffffffff
c0de997e:	dcf4      	bgt.n	c0de996a <sprintf_output+0x52>
        c = data[index];
c0de9980:	f81c 5003 	ldrb.w	r5, [ip, r3]
    while (index >= 1 && c < 0xC0) {
c0de9984:	1e5a      	subs	r2, r3, #1
c0de9986:	429a      	cmp	r2, r3
c0de9988:	d202      	bcs.n	c0de9990 <sprintf_output+0x78>
c0de998a:	2dc0      	cmp	r5, #192	@ 0xc0
c0de998c:	4613      	mov	r3, r2
c0de998e:	d3f3      	bcc.n	c0de9978 <sprintf_output+0x60>
    if (c >= 0xF0) {
c0de9990:	1c53      	adds	r3, r2, #1
c0de9992:	2def      	cmp	r5, #239	@ 0xef
c0de9994:	d901      	bls.n	c0de999a <sprintf_output+0x82>
c0de9996:	2504      	movs	r5, #4
c0de9998:	e006      	b.n	c0de99a8 <sprintf_output+0x90>
    else if (c >= 0xE0) {
c0de999a:	2ddf      	cmp	r5, #223	@ 0xdf
c0de999c:	d901      	bls.n	c0de99a2 <sprintf_output+0x8a>
c0de999e:	2503      	movs	r5, #3
c0de99a0:	e002      	b.n	c0de99a8 <sprintf_output+0x90>
    else if (c >= 0xC0) {
c0de99a2:	2dc0      	cmp	r5, #192	@ 0xc0
c0de99a4:	d3e1      	bcc.n	c0de996a <sprintf_output+0x52>
c0de99a6:	2502      	movs	r5, #2
    size_t nb_multibytes = len - index;
c0de99a8:	1acb      	subs	r3, r1, r3
c0de99aa:	429d      	cmp	r5, r3
c0de99ac:	bf98      	it	ls
c0de99ae:	2300      	movls	r3, #0
c0de99b0:	e7c6      	b.n	c0de9940 <sprintf_output+0x28>
	...

c0de99b4 <pic>:
void *pic(void *link_address)
{
    void *n, *en;

    // check if in the LINKED TEXT zone
    __asm volatile("ldr %0, =_nvram" : "=r"(n));
c0de99b4:	490a      	ldr	r1, [pc, #40]	@ (c0de99e0 <pic+0x2c>)
    __asm volatile("ldr %0, =_envram" : "=r"(en));
    if (link_address >= n && link_address <= en) {
c0de99b6:	4281      	cmp	r1, r0
    __asm volatile("ldr %0, =_envram" : "=r"(en));
c0de99b8:	490a      	ldr	r1, [pc, #40]	@ (c0de99e4 <pic+0x30>)
    if (link_address >= n && link_address <= en) {
c0de99ba:	d806      	bhi.n	c0de99ca <pic+0x16>
c0de99bc:	4281      	cmp	r1, r0
c0de99be:	d304      	bcc.n	c0de99ca <pic+0x16>
c0de99c0:	b580      	push	{r7, lr}
        link_address = pic_internal(link_address);
c0de99c2:	f000 f815 	bl	c0de99f0 <pic_internal>
c0de99c6:	e8bd 4080 	ldmia.w	sp!, {r7, lr}
    }

#ifndef BOLOS_OS_UPGRADER_APP
    // check if in the LINKED RAM zone
    __asm volatile("ldr %0, =_bss" : "=r"(n));
c0de99ca:	4907      	ldr	r1, [pc, #28]	@ (c0de99e8 <pic+0x34>)
    __asm volatile("ldr %0, =_estack" : "=r"(en));
    if (link_address >= n && link_address <= en) {
c0de99cc:	4288      	cmp	r0, r1
    __asm volatile("ldr %0, =_estack" : "=r"(en));
c0de99ce:	4a07      	ldr	r2, [pc, #28]	@ (c0de99ec <pic+0x38>)
    if (link_address >= n && link_address <= en) {
c0de99d0:	d305      	bcc.n	c0de99de <pic+0x2a>
c0de99d2:	4290      	cmp	r0, r2
        // deref into the RAM therefore add the RAM offset from R9
        link_address = (char *) link_address - (char *) n + (char *) en;
    }
#endif  // BOLOS_OS_UPGRADER_APP

    return link_address;
c0de99d4:	bf88      	it	hi
c0de99d6:	4770      	bxhi	lr
        link_address = (char *) link_address - (char *) n + (char *) en;
c0de99d8:	1a40      	subs	r0, r0, r1
        __asm volatile("mov %0, r9" : "=r"(en));
c0de99da:	464a      	mov	r2, r9
        link_address = (char *) link_address - (char *) n + (char *) en;
c0de99dc:	4410      	add	r0, r2
    return link_address;
c0de99de:	4770      	bx	lr
c0de99e0:	c0de0000 	.word	0xc0de0000
c0de99e4:	c0deb70b 	.word	0xc0deb70b
c0de99e8:	da7a0000 	.word	0xda7a0000
c0de99ec:	da7a9000 	.word	0xda7a9000

c0de99f0 <pic_internal>:
    __asm volatile("mov r2, pc\n");
c0de99f0:	467a      	mov	r2, pc
    __asm volatile("ldr r1, =pic_internal\n");
c0de99f2:	4902      	ldr	r1, [pc, #8]	@ (c0de99fc <pic_internal+0xc>)
    __asm volatile("adds r1, r1, #3\n");
c0de99f4:	1cc9      	adds	r1, r1, #3
    __asm volatile("subs r1, r1, r2\n");
c0de99f6:	1a89      	subs	r1, r1, r2
    __asm volatile("subs r0, r0, r1\n");
c0de99f8:	1a40      	subs	r0, r0, r1
    __asm volatile("bx lr\n");
c0de99fa:	4770      	bx	lr
c0de99fc:	c0de99f1 	.word	0xc0de99f1

c0de9a00 <SVC_Call>:
c0de9a00:	df01      	svc	1
c0de9a02:	2900      	cmp	r1, #0
c0de9a04:	d100      	bne.n	c0de9a08 <exception>
c0de9a06:	4770      	bx	lr

c0de9a08 <exception>:
c0de9a08:	4608      	mov	r0, r1
c0de9a0a:	f7ff f8f6 	bl	c0de8bfa <os_longjmp>

c0de9a0e <nbgl_wait_pipeline>:
    SVC_Call(SYSCALL_nbgl_screen_reinit_ID, parameters);
}

#ifdef HAVE_SE_EINK_DISPLAY
void nbgl_wait_pipeline(void)
{
c0de9a0e:	b580      	push	{r7, lr}
c0de9a10:	b082      	sub	sp, #8
c0de9a12:	2000      	movs	r0, #0
    unsigned int parameters[1];
    parameters[0] = 0;
c0de9a14:	9001      	str	r0, [sp, #4]
c0de9a16:	2011      	movs	r0, #17
c0de9a18:	f2c0 00fa 	movt	r0, #250	@ 0xfa
c0de9a1c:	a901      	add	r1, sp, #4
    SVC_Call(SYSCALL_nbgl_wait_pipeline_ID, parameters);
c0de9a1e:	f7ff ffef 	bl	c0de9a00 <SVC_Call>
}
c0de9a22:	b002      	add	sp, #8
c0de9a24:	bd80      	pop	{r7, pc}

c0de9a26 <os_perso_derive_node_bip32>:
void os_perso_derive_node_bip32(cx_curve_t          curve,
                                const unsigned int *path,
                                unsigned int        pathLength,
                                unsigned char      *privateKey,
                                unsigned char      *chain)
{
c0de9a26:	b580      	push	{r7, lr}
c0de9a28:	b086      	sub	sp, #24
    unsigned int parameters[5];
    parameters[0] = (unsigned int) curve;
c0de9a2a:	f10d 0e04 	add.w	lr, sp, #4
c0de9a2e:	f8dd c020 	ldr.w	ip, [sp, #32]
c0de9a32:	e88e 100f 	stmia.w	lr, {r0, r1, r2, r3, ip}
c0de9a36:	2053      	movs	r0, #83	@ 0x53
c0de9a38:	f2c0 5000 	movt	r0, #1280	@ 0x500
c0de9a3c:	a901      	add	r1, sp, #4
    parameters[1] = (unsigned int) path;
    parameters[2] = (unsigned int) pathLength;
    parameters[3] = (unsigned int) privateKey;
    parameters[4] = (unsigned int) chain;
    SVC_Call(SYSCALL_os_perso_derive_node_bip32_ID, parameters);
c0de9a3e:	f7ff ffdf 	bl	c0de9a00 <SVC_Call>
    return;
}
c0de9a42:	b006      	add	sp, #24
c0de9a44:	bd80      	pop	{r7, pc}

c0de9a46 <os_pki_load_certificate>:
                                    uint8_t                  *certificate,
                                    size_t                    certificate_len,
                                    uint8_t                  *trusted_name,
                                    size_t                   *trusted_name_len,
                                    cx_ecfp_384_public_key_t *public_key)
{
c0de9a46:	b580      	push	{r7, lr}
c0de9a48:	b086      	sub	sp, #24
c0de9a4a:	e9dd ec08 	ldrd	lr, ip, [sp, #32]
    unsigned int parameters[6];
    parameters[0] = (unsigned int) expected_key_usage;
c0de9a4e:	e88d 400f 	stmia.w	sp, {r0, r1, r2, r3, lr}
c0de9a52:	20aa      	movs	r0, #170	@ 0xaa
c0de9a54:	f2c0 6000 	movt	r0, #1536	@ 0x600
c0de9a58:	4669      	mov	r1, sp
    parameters[1] = (unsigned int) certificate;
    parameters[2] = (unsigned int) certificate_len;
    parameters[3] = (unsigned int) trusted_name;
    parameters[4] = (unsigned int) trusted_name_len;
    parameters[5] = (unsigned int) public_key;
c0de9a5a:	f8cd c014 	str.w	ip, [sp, #20]
    return (bolos_err_t) SVC_Call(SYSCALL_os_pki_load_certificate_ID, parameters);
c0de9a5e:	f7ff ffcf 	bl	c0de9a00 <SVC_Call>
c0de9a62:	b006      	add	sp, #24
c0de9a64:	bd80      	pop	{r7, pc}

c0de9a66 <os_perso_is_pin_set>:
    parameters[2]          = (uintptr_t) metadata_length;
    return (bolos_err_t) SVC_Call(SYSCALL_ENDORSEMENT_GET_METADATA_ID, parameters);
}

bolos_bool_t os_perso_is_pin_set(void)
{
c0de9a66:	b580      	push	{r7, lr}
c0de9a68:	b082      	sub	sp, #8
c0de9a6a:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de9a6c:	9001      	str	r0, [sp, #4]
c0de9a6e:	4669      	mov	r1, sp
    return (bolos_bool_t) SVC_Call(SYSCALL_os_perso_is_pin_set_ID, parameters);
c0de9a70:	209e      	movs	r0, #158	@ 0x9e
c0de9a72:	f7ff ffc5 	bl	c0de9a00 <SVC_Call>
c0de9a76:	b2c0      	uxtb	r0, r0
c0de9a78:	b002      	add	sp, #8
c0de9a7a:	bd80      	pop	{r7, pc}

c0de9a7c <os_global_pin_is_validated>:
}

bolos_bool_t os_global_pin_is_validated(void)
{
c0de9a7c:	b580      	push	{r7, lr}
c0de9a7e:	b082      	sub	sp, #8
c0de9a80:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de9a82:	9001      	str	r0, [sp, #4]
c0de9a84:	4669      	mov	r1, sp
    return (bolos_bool_t) SVC_Call(SYSCALL_os_global_pin_is_validated_ID, parameters);
c0de9a86:	20a0      	movs	r0, #160	@ 0xa0
c0de9a88:	f7ff ffba 	bl	c0de9a00 <SVC_Call>
c0de9a8c:	b2c0      	uxtb	r0, r0
c0de9a8e:	b002      	add	sp, #8
c0de9a90:	bd80      	pop	{r7, pc}

c0de9a92 <os_ux>:
    parameters[1] = 0;
    return (unsigned int) SVC_Call(SYSCALL_os_global_pin_retries_ID, parameters);
}

unsigned int os_ux(bolos_ux_params_t *params)
{
c0de9a92:	b580      	push	{r7, lr}
c0de9a94:	b082      	sub	sp, #8
    unsigned int parameters[2];
    parameters[0] = (unsigned int) params;
c0de9a96:	9000      	str	r0, [sp, #0]
c0de9a98:	2000      	movs	r0, #0
    parameters[1] = 0;
c0de9a9a:	9001      	str	r0, [sp, #4]
c0de9a9c:	2064      	movs	r0, #100	@ 0x64
c0de9a9e:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de9aa2:	4669      	mov	r1, sp
    return (unsigned int) SVC_Call(SYSCALL_os_ux_ID, parameters);
c0de9aa4:	f7ff ffac 	bl	c0de9a00 <SVC_Call>
c0de9aa8:	b002      	add	sp, #8
c0de9aaa:	bd80      	pop	{r7, pc}

c0de9aac <os_flags>:
    // remove the warning caused by -Winvalid-noreturn
    __builtin_unreachable();
}

unsigned int os_flags(void)
{
c0de9aac:	b580      	push	{r7, lr}
c0de9aae:	b082      	sub	sp, #8
c0de9ab0:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de9ab2:	9001      	str	r0, [sp, #4]
c0de9ab4:	4669      	mov	r1, sp
    return (unsigned int) SVC_Call(SYSCALL_os_flags_ID, parameters);
c0de9ab6:	206a      	movs	r0, #106	@ 0x6a
c0de9ab8:	f7ff ffa2 	bl	c0de9a00 <SVC_Call>
c0de9abc:	b002      	add	sp, #8
c0de9abe:	bd80      	pop	{r7, pc}

c0de9ac0 <os_setting_get>:
    parameters[2] = (unsigned int) maxlength;
    return (unsigned int) SVC_Call(SYSCALL_os_factory_setting_get_ID, parameters);
}

unsigned int os_setting_get(unsigned int setting_id, unsigned char *value, unsigned int maxlen)
{
c0de9ac0:	b580      	push	{r7, lr}
c0de9ac2:	b084      	sub	sp, #16
    unsigned int parameters[3];
    parameters[0] = (unsigned int) setting_id;
c0de9ac4:	ab01      	add	r3, sp, #4
c0de9ac6:	c307      	stmia	r3!, {r0, r1, r2}
c0de9ac8:	2070      	movs	r0, #112	@ 0x70
c0de9aca:	f2c0 3000 	movt	r0, #768	@ 0x300
c0de9ace:	a901      	add	r1, sp, #4
    parameters[1] = (unsigned int) value;
    parameters[2] = (unsigned int) maxlen;
    return (unsigned int) SVC_Call(SYSCALL_os_setting_get_ID, parameters);
c0de9ad0:	f7ff ff96 	bl	c0de9a00 <SVC_Call>
c0de9ad4:	b004      	add	sp, #16
c0de9ad6:	bd80      	pop	{r7, pc}

c0de9ad8 <os_registry_get_current_app_tag>:
}

unsigned int os_registry_get_current_app_tag(unsigned int   tag,
                                             unsigned char *buffer,
                                             unsigned int   maxlen)
{
c0de9ad8:	b580      	push	{r7, lr}
c0de9ada:	b084      	sub	sp, #16
    unsigned int parameters[3];
    parameters[0] = (unsigned int) tag;
c0de9adc:	ab01      	add	r3, sp, #4
c0de9ade:	c307      	stmia	r3!, {r0, r1, r2}
c0de9ae0:	2074      	movs	r0, #116	@ 0x74
c0de9ae2:	f2c0 3000 	movt	r0, #768	@ 0x300
c0de9ae6:	a901      	add	r1, sp, #4
    parameters[1] = (unsigned int) buffer;
    parameters[2] = (unsigned int) maxlen;
    return (unsigned int) SVC_Call(SYSCALL_os_registry_get_current_app_tag_ID, parameters);
c0de9ae8:	f7ff ff8a 	bl	c0de9a00 <SVC_Call>
c0de9aec:	b004      	add	sp, #16
c0de9aee:	bd80      	pop	{r7, pc}

c0de9af0 <os_sched_exit>:
}

void __attribute__((noreturn)) os_sched_exit(bolos_task_status_t exit_code)
{
c0de9af0:	b082      	sub	sp, #8
    unsigned int parameters[2];
    parameters[0] = (unsigned int) exit_code;
c0de9af2:	9000      	str	r0, [sp, #0]
c0de9af4:	2000      	movs	r0, #0
    parameters[1] = 0;
c0de9af6:	9001      	str	r0, [sp, #4]
c0de9af8:	209a      	movs	r0, #154	@ 0x9a
c0de9afa:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de9afe:	4669      	mov	r1, sp
    SVC_Call(SYSCALL_os_sched_exit_ID, parameters);
c0de9b00:	f7ff ff7e 	bl	c0de9a00 <SVC_Call>

    // The os_sched_exit syscall should never return.
    // Just in case, crash the device thanks to an undefined instruction.
    // To avoid the __builtin_unreachable undefined behaviour
    asm volatile("udf #255");
c0de9b04:	deff      	udf	#255	@ 0xff

c0de9b06 <os_io_init>:
    parameters[4] = (unsigned int) flags;
    return (int) SVC_Call(SYSCALL_os_io_seph_se_rx_event_ID, parameters);
}

__attribute((weak)) int os_io_init(os_io_init_t *init)
{
c0de9b06:	b580      	push	{r7, lr}
c0de9b08:	b082      	sub	sp, #8
    unsigned int parameters[1];
    parameters[0] = (unsigned int) init;
c0de9b0a:	9001      	str	r0, [sp, #4]
c0de9b0c:	2084      	movs	r0, #132	@ 0x84
c0de9b0e:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de9b12:	a901      	add	r1, sp, #4
    return (int) SVC_Call(SYSCALL_os_io_init_ID, parameters);
c0de9b14:	f7ff ff74 	bl	c0de9a00 <SVC_Call>
c0de9b18:	b002      	add	sp, #8
c0de9b1a:	bd80      	pop	{r7, pc}

c0de9b1c <os_io_start>:
}

__attribute((weak)) int os_io_start(void)
{
c0de9b1c:	b580      	push	{r7, lr}
c0de9b1e:	b082      	sub	sp, #8
c0de9b20:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de9b22:	9001      	str	r0, [sp, #4]
c0de9b24:	2085      	movs	r0, #133	@ 0x85
c0de9b26:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de9b2a:	4669      	mov	r1, sp
    return (int) SVC_Call(SYSCALL_os_io_start_ID, parameters);
c0de9b2c:	f7ff ff68 	bl	c0de9a00 <SVC_Call>
c0de9b30:	b002      	add	sp, #8
c0de9b32:	bd80      	pop	{r7, pc}

c0de9b34 <os_io_stop>:
}

__attribute((weak)) int os_io_stop(void)
{
c0de9b34:	b580      	push	{r7, lr}
c0de9b36:	b082      	sub	sp, #8
c0de9b38:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de9b3a:	9001      	str	r0, [sp, #4]
c0de9b3c:	2086      	movs	r0, #134	@ 0x86
c0de9b3e:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de9b42:	4669      	mov	r1, sp
    return (int) SVC_Call(SYSCALL_os_io_stop_ID, parameters);
c0de9b44:	f7ff ff5c 	bl	c0de9a00 <SVC_Call>
c0de9b48:	b002      	add	sp, #8
c0de9b4a:	bd80      	pop	{r7, pc}

c0de9b4c <os_io_tx_cmd>:

__attribute((weak)) int os_io_tx_cmd(unsigned char        type,
                                     const unsigned char *buffer,
                                     unsigned short       length,
                                     unsigned int        *timeout_ms)
{
c0de9b4c:	b580      	push	{r7, lr}
c0de9b4e:	b084      	sub	sp, #16
    unsigned int parameters[4];
    parameters[0] = (unsigned int) type;
c0de9b50:	e88d 000f 	stmia.w	sp, {r0, r1, r2, r3}
c0de9b54:	2088      	movs	r0, #136	@ 0x88
c0de9b56:	f2c0 4000 	movt	r0, #1024	@ 0x400
c0de9b5a:	4669      	mov	r1, sp
    parameters[1] = (unsigned int) buffer;
    parameters[2] = (unsigned int) length;
    parameters[3] = (unsigned int) timeout_ms;
    return (int) SVC_Call(SYSCALL_os_io_tx_cmd_ID, parameters);
c0de9b5c:	f7ff ff50 	bl	c0de9a00 <SVC_Call>
c0de9b60:	b004      	add	sp, #16
c0de9b62:	bd80      	pop	{r7, pc}

c0de9b64 <os_io_rx_evt>:

__attribute((weak)) int os_io_rx_evt(unsigned char *buffer,
                                     unsigned short buffer_max_length,
                                     unsigned int  *timeout_ms,
                                     bool           check_se_event)
{
c0de9b64:	b580      	push	{r7, lr}
c0de9b66:	b084      	sub	sp, #16
    unsigned int parameters[4];
    parameters[0] = (unsigned int) buffer;
c0de9b68:	e88d 000f 	stmia.w	sp, {r0, r1, r2, r3}
c0de9b6c:	2089      	movs	r0, #137	@ 0x89
c0de9b6e:	f2c0 3000 	movt	r0, #768	@ 0x300
c0de9b72:	4669      	mov	r1, sp
    parameters[1] = (unsigned int) buffer_max_length;
    parameters[2] = (unsigned int) timeout_ms;
    parameters[3] = (unsigned int) check_se_event;
    return (int) SVC_Call(SYSCALL_os_io_rx_evt_ID, parameters);
c0de9b74:	f7ff ff44 	bl	c0de9a00 <SVC_Call>
c0de9b78:	b004      	add	sp, #16
c0de9b7a:	bd80      	pop	{r7, pc}

c0de9b7c <try_context_get>:
    parameters[1] = 0;
    return (unsigned int) SVC_Call(SYSCALL_nvm_erase_page_ID, parameters);
}

try_context_t *try_context_get(void)
{
c0de9b7c:	b580      	push	{r7, lr}
c0de9b7e:	b082      	sub	sp, #8
c0de9b80:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de9b82:	9001      	str	r0, [sp, #4]
c0de9b84:	4669      	mov	r1, sp
    return (try_context_t *) SVC_Call(SYSCALL_try_context_get_ID, parameters);
c0de9b86:	2087      	movs	r0, #135	@ 0x87
c0de9b88:	f7ff ff3a 	bl	c0de9a00 <SVC_Call>
c0de9b8c:	b002      	add	sp, #8
c0de9b8e:	bd80      	pop	{r7, pc}

c0de9b90 <try_context_set>:
}

try_context_t *try_context_set(try_context_t *context)
{
c0de9b90:	b580      	push	{r7, lr}
c0de9b92:	b082      	sub	sp, #8
    unsigned int parameters[2];
    parameters[0] = (unsigned int) context;
c0de9b94:	9000      	str	r0, [sp, #0]
c0de9b96:	2000      	movs	r0, #0
    parameters[1] = 0;
c0de9b98:	9001      	str	r0, [sp, #4]
c0de9b9a:	f240 100b 	movw	r0, #267	@ 0x10b
c0de9b9e:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de9ba2:	4669      	mov	r1, sp
    return (try_context_t *) SVC_Call(SYSCALL_try_context_set_ID, parameters);
c0de9ba4:	f7ff ff2c 	bl	c0de9a00 <SVC_Call>
c0de9ba8:	b002      	add	sp, #8
c0de9baa:	bd80      	pop	{r7, pc}

c0de9bac <os_sched_last_status>:
}

bolos_task_status_t os_sched_last_status(unsigned int task_idx)
{
c0de9bac:	b580      	push	{r7, lr}
c0de9bae:	b082      	sub	sp, #8
    unsigned int parameters[2];
    parameters[0] = (unsigned int) task_idx;
c0de9bb0:	9000      	str	r0, [sp, #0]
c0de9bb2:	2000      	movs	r0, #0
    parameters[1] = 0;
c0de9bb4:	9001      	str	r0, [sp, #4]
c0de9bb6:	209c      	movs	r0, #156	@ 0x9c
c0de9bb8:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de9bbc:	4669      	mov	r1, sp
    return (bolos_task_status_t) SVC_Call(SYSCALL_os_sched_last_status_ID, parameters);
c0de9bbe:	f7ff ff1f 	bl	c0de9a00 <SVC_Call>
c0de9bc2:	b2c0      	uxtb	r0, r0
c0de9bc4:	b002      	add	sp, #8
c0de9bc6:	bd80      	pop	{r7, pc}

c0de9bc8 <touch_get_last_info>:
}
#endif  // HAVE_SE_BUTTON

#ifdef HAVE_SE_TOUCH
void touch_get_last_info(io_touch_info_t *info)
{
c0de9bc8:	b580      	push	{r7, lr}
c0de9bca:	b082      	sub	sp, #8
    unsigned int parameters[1] = {(unsigned int) info};
c0de9bcc:	9001      	str	r0, [sp, #4]
c0de9bce:	200b      	movs	r0, #11
c0de9bd0:	f2c0 10fa 	movt	r0, #506	@ 0x1fa
c0de9bd4:	a901      	add	r1, sp, #4
    SVC_Call(SYSCALL_touch_get_last_info_ID, parameters);
c0de9bd6:	f7ff ff13 	bl	c0de9a00 <SVC_Call>
}
c0de9bda:	b002      	add	sp, #8
c0de9bdc:	bd80      	pop	{r7, pc}
	...

c0de9be0 <__udivmoddi4>:
c0de9be0:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de9be4:	f8dd c020 	ldr.w	ip, [sp, #32]
c0de9be8:	4604      	mov	r4, r0
c0de9bea:	b179      	cbz	r1, c0de9c0c <__udivmoddi4+0x2c>
c0de9bec:	b1ba      	cbz	r2, c0de9c1e <__udivmoddi4+0x3e>
c0de9bee:	b35b      	cbz	r3, c0de9c48 <__udivmoddi4+0x68>
c0de9bf0:	fab1 f581 	clz	r5, r1
c0de9bf4:	fab3 f683 	clz	r6, r3
c0de9bf8:	1b75      	subs	r5, r6, r5
c0de9bfa:	2d20      	cmp	r5, #32
c0de9bfc:	d34a      	bcc.n	c0de9c94 <__udivmoddi4+0xb4>
c0de9bfe:	f1bc 0f00 	cmp.w	ip, #0
c0de9c02:	bf18      	it	ne
c0de9c04:	e9cc 4100 	strdne	r4, r1, [ip]
c0de9c08:	2400      	movs	r4, #0
c0de9c0a:	e066      	b.n	c0de9cda <__udivmoddi4+0xfa>
c0de9c0c:	b3cb      	cbz	r3, c0de9c82 <__udivmoddi4+0xa2>
c0de9c0e:	2100      	movs	r1, #0
c0de9c10:	f1bc 0f00 	cmp.w	ip, #0
c0de9c14:	bf18      	it	ne
c0de9c16:	e9cc 4100 	strdne	r4, r1, [ip]
c0de9c1a:	2400      	movs	r4, #0
c0de9c1c:	e0a6      	b.n	c0de9d6c <__udivmoddi4+0x18c>
c0de9c1e:	2b00      	cmp	r3, #0
c0de9c20:	d03e      	beq.n	c0de9ca0 <__udivmoddi4+0xc0>
c0de9c22:	2800      	cmp	r0, #0
c0de9c24:	d04f      	beq.n	c0de9cc6 <__udivmoddi4+0xe6>
c0de9c26:	1e5d      	subs	r5, r3, #1
c0de9c28:	422b      	tst	r3, r5
c0de9c2a:	d158      	bne.n	c0de9cde <__udivmoddi4+0xfe>
c0de9c2c:	f1bc 0f00 	cmp.w	ip, #0
c0de9c30:	bf1c      	itt	ne
c0de9c32:	ea05 0001 	andne.w	r0, r5, r1
c0de9c36:	e9cc 4000 	strdne	r4, r0, [ip]
c0de9c3a:	fa93 f0a3 	rbit	r0, r3
c0de9c3e:	fab0 f080 	clz	r0, r0
c0de9c42:	fa21 f400 	lsr.w	r4, r1, r0
c0de9c46:	e048      	b.n	c0de9cda <__udivmoddi4+0xfa>
c0de9c48:	1e55      	subs	r5, r2, #1
c0de9c4a:	422a      	tst	r2, r5
c0de9c4c:	d129      	bne.n	c0de9ca2 <__udivmoddi4+0xc2>
c0de9c4e:	f1bc 0f00 	cmp.w	ip, #0
c0de9c52:	bf1e      	ittt	ne
c0de9c54:	2300      	movne	r3, #0
c0de9c56:	4005      	andne	r5, r0
c0de9c58:	e9cc 5300 	strdne	r5, r3, [ip]
c0de9c5c:	2a01      	cmp	r2, #1
c0de9c5e:	f000 8085 	beq.w	c0de9d6c <__udivmoddi4+0x18c>
c0de9c62:	fa92 f2a2 	rbit	r2, r2
c0de9c66:	004c      	lsls	r4, r1, #1
c0de9c68:	fab2 f282 	clz	r2, r2
c0de9c6c:	f002 031f 	and.w	r3, r2, #31
c0de9c70:	40d1      	lsrs	r1, r2
c0de9c72:	40d8      	lsrs	r0, r3
c0de9c74:	231f      	movs	r3, #31
c0de9c76:	4393      	bics	r3, r2
c0de9c78:	fa04 f303 	lsl.w	r3, r4, r3
c0de9c7c:	ea43 0400 	orr.w	r4, r3, r0
c0de9c80:	e074      	b.n	c0de9d6c <__udivmoddi4+0x18c>
c0de9c82:	fbb0 f4f2 	udiv	r4, r0, r2
c0de9c86:	f1bc 0f00 	cmp.w	ip, #0
c0de9c8a:	d026      	beq.n	c0de9cda <__udivmoddi4+0xfa>
c0de9c8c:	fb04 0012 	mls	r0, r4, r2, r0
c0de9c90:	2100      	movs	r1, #0
c0de9c92:	e020      	b.n	c0de9cd6 <__udivmoddi4+0xf6>
c0de9c94:	f105 0e01 	add.w	lr, r5, #1
c0de9c98:	f1be 0f20 	cmp.w	lr, #32
c0de9c9c:	d00b      	beq.n	c0de9cb6 <__udivmoddi4+0xd6>
c0de9c9e:	e028      	b.n	c0de9cf2 <__udivmoddi4+0x112>
c0de9ca0:	e064      	b.n	c0de9d6c <__udivmoddi4+0x18c>
c0de9ca2:	fab1 f481 	clz	r4, r1
c0de9ca6:	fab2 f582 	clz	r5, r2
c0de9caa:	1b2c      	subs	r4, r5, r4
c0de9cac:	f104 0e21 	add.w	lr, r4, #33	@ 0x21
c0de9cb0:	f1be 0f20 	cmp.w	lr, #32
c0de9cb4:	d15d      	bne.n	c0de9d72 <__udivmoddi4+0x192>
c0de9cb6:	f04f 0e20 	mov.w	lr, #32
c0de9cba:	f04f 0a00 	mov.w	sl, #0
c0de9cbe:	f04f 0b00 	mov.w	fp, #0
c0de9cc2:	460e      	mov	r6, r1
c0de9cc4:	e021      	b.n	c0de9d0a <__udivmoddi4+0x12a>
c0de9cc6:	fbb1 f4f3 	udiv	r4, r1, r3
c0de9cca:	f1bc 0f00 	cmp.w	ip, #0
c0de9cce:	d004      	beq.n	c0de9cda <__udivmoddi4+0xfa>
c0de9cd0:	2000      	movs	r0, #0
c0de9cd2:	fb04 1113 	mls	r1, r4, r3, r1
c0de9cd6:	e9cc 0100 	strd	r0, r1, [ip]
c0de9cda:	2100      	movs	r1, #0
c0de9cdc:	e046      	b.n	c0de9d6c <__udivmoddi4+0x18c>
c0de9cde:	fab1 f581 	clz	r5, r1
c0de9ce2:	fab3 f683 	clz	r6, r3
c0de9ce6:	1b75      	subs	r5, r6, r5
c0de9ce8:	2d1f      	cmp	r5, #31
c0de9cea:	f4bf af88 	bcs.w	c0de9bfe <__udivmoddi4+0x1e>
c0de9cee:	f105 0e01 	add.w	lr, r5, #1
c0de9cf2:	fa20 f40e 	lsr.w	r4, r0, lr
c0de9cf6:	f1c5 051f 	rsb	r5, r5, #31
c0de9cfa:	fa01 f605 	lsl.w	r6, r1, r5
c0de9cfe:	fa21 fb0e 	lsr.w	fp, r1, lr
c0de9d02:	40a8      	lsls	r0, r5
c0de9d04:	f04f 0a00 	mov.w	sl, #0
c0de9d08:	4326      	orrs	r6, r4
c0de9d0a:	f04f 0800 	mov.w	r8, #0
c0de9d0e:	f1be 0f00 	cmp.w	lr, #0
c0de9d12:	d01c      	beq.n	c0de9d4e <__udivmoddi4+0x16e>
c0de9d14:	ea4f 014b 	mov.w	r1, fp, lsl #1
c0de9d18:	f1ae 0e01 	sub.w	lr, lr, #1
c0de9d1c:	ea41 71d6 	orr.w	r1, r1, r6, lsr #31
c0de9d20:	0076      	lsls	r6, r6, #1
c0de9d22:	ea46 75d0 	orr.w	r5, r6, r0, lsr #31
c0de9d26:	1aae      	subs	r6, r5, r2
c0de9d28:	eb61 0b03 	sbc.w	fp, r1, r3
c0de9d2c:	43cf      	mvns	r7, r1
c0de9d2e:	43ec      	mvns	r4, r5
c0de9d30:	18a4      	adds	r4, r4, r2
c0de9d32:	eb57 0403 	adcs.w	r4, r7, r3
c0de9d36:	bf5c      	itt	pl
c0de9d38:	468b      	movpl	fp, r1
c0de9d3a:	462e      	movpl	r6, r5
c0de9d3c:	0040      	lsls	r0, r0, #1
c0de9d3e:	0fe1      	lsrs	r1, r4, #31
c0de9d40:	ea48 044a 	orr.w	r4, r8, sl, lsl #1
c0de9d44:	ea40 70da 	orr.w	r0, r0, sl, lsr #31
c0de9d48:	46a2      	mov	sl, r4
c0de9d4a:	4688      	mov	r8, r1
c0de9d4c:	e7df      	b.n	c0de9d0e <__udivmoddi4+0x12e>
c0de9d4e:	ea4f 71da 	mov.w	r1, sl, lsr #31
c0de9d52:	f1bc 0f00 	cmp.w	ip, #0
c0de9d56:	bf18      	it	ne
c0de9d58:	e9cc 6b00 	strdne	r6, fp, [ip]
c0de9d5c:	ea41 0140 	orr.w	r1, r1, r0, lsl #1
c0de9d60:	ea4f 004a 	mov.w	r0, sl, lsl #1
c0de9d64:	f020 0001 	bic.w	r0, r0, #1
c0de9d68:	ea40 0408 	orr.w	r4, r0, r8
c0de9d6c:	4620      	mov	r0, r4
c0de9d6e:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de9d72:	f1be 0f1f 	cmp.w	lr, #31
c0de9d76:	d804      	bhi.n	c0de9d82 <__udivmoddi4+0x1a2>
c0de9d78:	fa20 f40e 	lsr.w	r4, r0, lr
c0de9d7c:	f1ce 0520 	rsb	r5, lr, #32
c0de9d80:	e7bb      	b.n	c0de9cfa <__udivmoddi4+0x11a>
c0de9d82:	f1ce 0740 	rsb	r7, lr, #64	@ 0x40
c0de9d86:	f1ae 0420 	sub.w	r4, lr, #32
c0de9d8a:	f04f 0b00 	mov.w	fp, #0
c0de9d8e:	fa20 f504 	lsr.w	r5, r0, r4
c0de9d92:	fa01 f607 	lsl.w	r6, r1, r7
c0de9d96:	fa00 fa07 	lsl.w	sl, r0, r7
c0de9d9a:	ea46 0805 	orr.w	r8, r6, r5
c0de9d9e:	fa21 f604 	lsr.w	r6, r1, r4
c0de9da2:	4640      	mov	r0, r8
c0de9da4:	e7b1      	b.n	c0de9d0a <__udivmoddi4+0x12a>
	...

c0de9da8 <__aeabi_memcpy>:
c0de9da8:	f000 b82c 	b.w	c0de9e04 <memcpy>

c0de9dac <__aeabi_memmove>:
c0de9dac:	f000 b838 	b.w	c0de9e20 <memmove>

c0de9db0 <__aeabi_memset>:
c0de9db0:	460b      	mov	r3, r1
c0de9db2:	4611      	mov	r1, r2
c0de9db4:	461a      	mov	r2, r3
c0de9db6:	f000 b84d 	b.w	c0de9e54 <memset>
c0de9dba:	bf00      	nop

c0de9dbc <__aeabi_memclr>:
c0de9dbc:	460a      	mov	r2, r1
c0de9dbe:	2100      	movs	r1, #0
c0de9dc0:	f000 b848 	b.w	c0de9e54 <memset>

c0de9dc4 <__aeabi_uldivmod>:
c0de9dc4:	b540      	push	{r6, lr}
c0de9dc6:	b084      	sub	sp, #16
c0de9dc8:	ae02      	add	r6, sp, #8
c0de9dca:	9600      	str	r6, [sp, #0]
c0de9dcc:	f7ff ff08 	bl	c0de9be0 <__udivmoddi4>
c0de9dd0:	9a02      	ldr	r2, [sp, #8]
c0de9dd2:	9b03      	ldr	r3, [sp, #12]
c0de9dd4:	b004      	add	sp, #16
c0de9dd6:	bd40      	pop	{r6, pc}

c0de9dd8 <explicit_bzero>:
c0de9dd8:	f000 b800 	b.w	c0de9ddc <bzero>

c0de9ddc <bzero>:
c0de9ddc:	460a      	mov	r2, r1
c0de9dde:	2100      	movs	r1, #0
c0de9de0:	f000 b838 	b.w	c0de9e54 <memset>

c0de9de4 <memcmp>:
c0de9de4:	b510      	push	{r4, lr}
c0de9de6:	3901      	subs	r1, #1
c0de9de8:	4402      	add	r2, r0
c0de9dea:	4290      	cmp	r0, r2
c0de9dec:	d101      	bne.n	c0de9df2 <memcmp+0xe>
c0de9dee:	2000      	movs	r0, #0
c0de9df0:	e005      	b.n	c0de9dfe <memcmp+0x1a>
c0de9df2:	7803      	ldrb	r3, [r0, #0]
c0de9df4:	f811 4f01 	ldrb.w	r4, [r1, #1]!
c0de9df8:	42a3      	cmp	r3, r4
c0de9dfa:	d001      	beq.n	c0de9e00 <memcmp+0x1c>
c0de9dfc:	1b18      	subs	r0, r3, r4
c0de9dfe:	bd10      	pop	{r4, pc}
c0de9e00:	3001      	adds	r0, #1
c0de9e02:	e7f2      	b.n	c0de9dea <memcmp+0x6>

c0de9e04 <memcpy>:
c0de9e04:	440a      	add	r2, r1
c0de9e06:	4291      	cmp	r1, r2
c0de9e08:	f100 33ff 	add.w	r3, r0, #4294967295	@ 0xffffffff
c0de9e0c:	d100      	bne.n	c0de9e10 <memcpy+0xc>
c0de9e0e:	4770      	bx	lr
c0de9e10:	b510      	push	{r4, lr}
c0de9e12:	f811 4b01 	ldrb.w	r4, [r1], #1
c0de9e16:	4291      	cmp	r1, r2
c0de9e18:	f803 4f01 	strb.w	r4, [r3, #1]!
c0de9e1c:	d1f9      	bne.n	c0de9e12 <memcpy+0xe>
c0de9e1e:	bd10      	pop	{r4, pc}

c0de9e20 <memmove>:
c0de9e20:	4288      	cmp	r0, r1
c0de9e22:	b510      	push	{r4, lr}
c0de9e24:	eb01 0402 	add.w	r4, r1, r2
c0de9e28:	d902      	bls.n	c0de9e30 <memmove+0x10>
c0de9e2a:	4284      	cmp	r4, r0
c0de9e2c:	4623      	mov	r3, r4
c0de9e2e:	d807      	bhi.n	c0de9e40 <memmove+0x20>
c0de9e30:	1e43      	subs	r3, r0, #1
c0de9e32:	42a1      	cmp	r1, r4
c0de9e34:	d008      	beq.n	c0de9e48 <memmove+0x28>
c0de9e36:	f811 2b01 	ldrb.w	r2, [r1], #1
c0de9e3a:	f803 2f01 	strb.w	r2, [r3, #1]!
c0de9e3e:	e7f8      	b.n	c0de9e32 <memmove+0x12>
c0de9e40:	4601      	mov	r1, r0
c0de9e42:	4402      	add	r2, r0
c0de9e44:	428a      	cmp	r2, r1
c0de9e46:	d100      	bne.n	c0de9e4a <memmove+0x2a>
c0de9e48:	bd10      	pop	{r4, pc}
c0de9e4a:	f813 4d01 	ldrb.w	r4, [r3, #-1]!
c0de9e4e:	f802 4d01 	strb.w	r4, [r2, #-1]!
c0de9e52:	e7f7      	b.n	c0de9e44 <memmove+0x24>

c0de9e54 <memset>:
c0de9e54:	4603      	mov	r3, r0
c0de9e56:	4402      	add	r2, r0
c0de9e58:	4293      	cmp	r3, r2
c0de9e5a:	d100      	bne.n	c0de9e5e <memset+0xa>
c0de9e5c:	4770      	bx	lr
c0de9e5e:	f803 1b01 	strb.w	r1, [r3], #1
c0de9e62:	e7f9      	b.n	c0de9e58 <memset+0x4>

c0de9e64 <setjmp>:
c0de9e64:	46ec      	mov	ip, sp
c0de9e66:	e8a0 5ff0 	stmia.w	r0!, {r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
c0de9e6a:	f04f 0000 	mov.w	r0, #0
c0de9e6e:	4770      	bx	lr

c0de9e70 <longjmp>:
c0de9e70:	e8b0 5ff0 	ldmia.w	r0!, {r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
c0de9e74:	46e5      	mov	sp, ip
c0de9e76:	0008      	movs	r0, r1
c0de9e78:	bf08      	it	eq
c0de9e7a:	2001      	moveq	r0, #1
c0de9e7c:	4770      	bx	lr
c0de9e7e:	bf00      	nop

c0de9e80 <strlen>:
c0de9e80:	4603      	mov	r3, r0
c0de9e82:	f813 2b01 	ldrb.w	r2, [r3], #1
c0de9e86:	2a00      	cmp	r2, #0
c0de9e88:	d1fb      	bne.n	c0de9e82 <strlen+0x2>
c0de9e8a:	1a18      	subs	r0, r3, r0
c0de9e8c:	3801      	subs	r0, #1
c0de9e8e:	4770      	bx	lr

c0de9e90 <strncat>:
c0de9e90:	b530      	push	{r4, r5, lr}
c0de9e92:	4604      	mov	r4, r0
c0de9e94:	7825      	ldrb	r5, [r4, #0]
c0de9e96:	4623      	mov	r3, r4
c0de9e98:	3401      	adds	r4, #1
c0de9e9a:	2d00      	cmp	r5, #0
c0de9e9c:	d1fa      	bne.n	c0de9e94 <strncat+0x4>
c0de9e9e:	1e54      	subs	r4, r2, #1
c0de9ea0:	b912      	cbnz	r2, c0de9ea8 <strncat+0x18>
c0de9ea2:	bd30      	pop	{r4, r5, pc}
c0de9ea4:	b13c      	cbz	r4, c0de9eb6 <strncat+0x26>
c0de9ea6:	3c01      	subs	r4, #1
c0de9ea8:	f811 2b01 	ldrb.w	r2, [r1], #1
c0de9eac:	f803 2b01 	strb.w	r2, [r3], #1
c0de9eb0:	2a00      	cmp	r2, #0
c0de9eb2:	d1f7      	bne.n	c0de9ea4 <strncat+0x14>
c0de9eb4:	e7f5      	b.n	c0de9ea2 <strncat+0x12>
c0de9eb6:	701c      	strb	r4, [r3, #0]
c0de9eb8:	e7f3      	b.n	c0de9ea2 <strncat+0x12>

c0de9eba <C_app_boilerplate_64px_bitmap>:
c0de9eba:	0040 0040 b301 0000 00b1 8b1f 0008 0000     @.@.............
c0de9eca:	0000 0302 d175 0dbb 2103 060c 9f60 8522     ....u....!..`.".
c0de9eda:	1192 856e 706c 1da3 79a3 a414 6914 2929     ..n.lp...y...i))
c0de9eea:	1c2c ff83 0444 dce5 127c 1b0f a21b b8ab     ,...D...|.......
c0de9efa:	f0c3 2d31 cc32 c0b0 f93a 8530 b368 d0bd     ..1-2...:.0.h...
c0de9f0a:	a288 0d9d 744a f0f2 c3a6 6bb4 b2ea bf6a     ....Jt.....k..j.
c0de9f1a:	2fa7 436d 2afd c2b0 b932 fd9b 8609 b3a7     ./mC.*..2.......
c0de9f2a:	74b0 d747 ab2a d51b 8dd3 8165 eb15 7382     .tG.*.....e....s
c0de9f3a:	dcbd a301 f3df 848d 460d bcdd 9658 c9f7     .........F..X...
c0de9f4a:	4f8f 91f4 ef4f a38f 9bf7 7f36 e5b0 69e6     .O..O.....6....i
c0de9f5a:	0d3e 12f3 afcc f32e cb2d f9dc 7fe2 7f96     >.......-.......
c0de9f6a:	1ffc e56f a9d1 0021 0002                     ..o...!....

c0de9f75 <C_app_boilerplate_64px>:
c0de9f75:	0040 0040 0100 9eba c0de                    @.@.......

c0de9f7f <C_switch_60_40_bitmap>:
c0de9f7f:	0000 00ff 0000 ff07 00e0 1f00 f8ff 0000     ................
c0de9f8f:	ff3f 00fc ff00 ffff 0100 ffff 80ff ff03     ?...............
c0de9f9f:	ffff 03c0 ffff c0ff ff07 ffff 0fe0 ffff     ................
c0de9faf:	f0ff ff0f ffff 1ff0 ffff f8ff ff1f ffff     ................
c0de9fbf:	1ff8 ffff f8ff ff3f ffff 3ffc ffff fcff     ......?....?....
c0de9fcf:	ff3f ffff 3ffc ffff fcff ff3f ffff 3ffc     ?....?....?....?
c0de9fdf:	ffff fcff ff3f ffff 3ffc ffff fcff ff3f     ....?....?....?.
c0de9fef:	ffff 3ffc ffff fcff ff3f ffff 3ffc ffff     ...?....?....?..
c0de9fff:	fcff ff3f ffff 3ffc 00ff fcff f83f 1f00     ..?....?....?...
c0dea00f:	3ffc 00f0 fc0f c03f 0300 3ffc 0080 fc01     .?....?....?....
c0dea01f:	003f 0000 3ffc 0000 fc00 003e 0000 3c7c     ?....?....>...|<
c0dea02f:	0000 3c00 003c 0000 3c3c 0000 3c00 0038     ...<<...<<...<8.
c0dea03f:	0000 381c 0000 1c00 0038 0000 381c 0000     ...8....8....8..
c0dea04f:	1c00 0038 0000 381c 0000 1c00 0038 0000     ..8....8....8...
c0dea05f:	381c 0000 1c00 001c 0000 1c38 0000 3800     .8........8....8
c0dea06f:	001c 0000 0e38 0000 7000 000f 0000 07f0     ....8....p......
c0dea07f:	0000 e000 8003 0100 03c0 00c0 c003 f001     ................
c0dea08f:	0f00 0080 00f8 001f 3f00 fc00 0000 ff1f     .........?......
c0dea09f:	00f8 0700 e0ff 0000 ff00 0000               ............

c0dea0ab <C_switch_60_40>:
c0dea0ab:	003c 0028 0000 9f7f c0de                    <.(.......

c0dea0b5 <C_Important_Circle_64px_bitmap>:
c0dea0b5:	0040 0040 fa21 0001 01f8 8b1f 0008 0000     @.@.!...........
c0dea0c5:	0000 0302 55b5 4ecd 40c2 1e10 fea1 cfe3     .....U.N.@......
c0dea0d5:	0f51 892a d45e 8904 602f 49e3 1313 7a3c     Q.*.^.../`.I..<z
c0dea0e5:	cae4 37cd 1350 a33d 70c6 f8d5 1802 005f     ...7P.=..p...._.
c0dea0f5:	9e0f 5f05 1fc0 1ace 4910 c054 b38e b6ed     ..._.....IT.....
c0dea105:	db74 d059 e704 76d0 dbf6 7cee 76fd 2dfa     t.Y....v...|.v.-
c0dea115:	ef62 99a2 055b d858 6a29 43e0 b190 6159     b...[.X.)j.C..Ya
c0dea125:	96d0 5e09 c518 308e a440 8010 052d 1806     ...^...0@...-...
c0dea135:	9408 b138 cadf 203c e4be e2e2 4979 3f81     ..8...< ....yI.?
c0dea145:	d0c4 7c94 3ac7 d915 1f9e d24f 56c0 bd3b     ...|.:....O..V;.
c0dea155:	34a4 abea a650 d97c 5f3f 484c c9b4 c551     .4..P.|.?_LH..Q.
c0dea165:	9541 9a6e 78d8 3bd9 3ecd f957 d17e 9ad0     A.n..x.;.>W.~...
c0dea175:	ec9b cc02 f504 6fb8 d92f e800 0c7b dfe2     .......o/...{...
c0dea185:	de93 c49a 2c6e 77ac 6009 79d6 874a 4baa     ....n,.w.`.yJ..K
c0dea195:	8606 abb3 26a4 9db7 cac4 a6de ff9a 7d53     .....&........S}
c0dea1a5:	e341 7129 01bf b3c8 02dd 1310 d377 84a7     A.)q........w...
c0dea1b5:	a612 c04d 1802 71e1 d85a b9e1 e3c2 006f     ..M....qZ.....o.
c0dea1c5:	c459 fb3a 2275 6d3e 5582 0a80 538f 09e5     Y.:.u">m.U...S..
c0dea1d5:	2551 eba2 38f7 228c f3ee 38ea 0ec2 6e23     Q%...8."...8..#n
c0dea1e5:	0b8b c71f 55e2 51d3 8b81 4412 9145 3b71     .....U.Q...DE.q;
c0dea1f5:	f769 20b6 159e 4f43 9a82 924d abc7 a042     i.. ..CO..M...B.
c0dea205:	c6ff f1bb 724b e7cd a06e 4521 e9d2 2fd3     ....Kr..n.!E.../
c0dea215:	d245 3be9 7884 69d5 627f f7dd 2eb7 b2c9     E..;.x.i.b......
c0dea225:	407f eeca 3992 af1e 9d39 ba05 bc0d 2a70     .@...9..9.....p*
c0dea235:	f29b 623f 19e8 8db2 1c0b 90dc d70b 0d35     ..?b..........5.
c0dea245:	965e ade3 b9a0 ea78 75c8 dd4d 2dff 7d85     ^.....x..uM..-.}
c0dea255:	f9d6 c243 c99b 4bfb 77fe d4fe dfd5 8948     ..C....K.w....H.
c0dea265:	61a0 92d3 8a91 afe2 618a 2b5f 8afe 5256     .a.......a_+..VR
c0dea275:	709d fc2b e439 8bef bfae 841f ddfc 6c36     .p+.9.........6l
c0dea285:	1f3a 10ee 9d5f 61f3 431a ed86 230f 53d8     :..._..a.C...#.S
c0dea295:	b8cd 1702 7aff 51be 3389 de17 f4d0 eb73     .....z.Q.3....s.
c0dea2a5:	1d68 3e60 e853 91e1 3f8d c10e e439 0800     h.`>S....?..9...
	...

c0dea2b7 <C_Important_Circle_64px>:
c0dea2b7:	0040 0040 0102 a0b5 c0de                    @.@.......

c0dea2c1 <C_Warning_64px_bitmap>:
c0dea2c1:	0040 0040 5f21 0001 015d 8b1f 0008 0000     @.@.!_..].......
c0dea2d1:	0000 0302 d585 4e31 40c3 0510 8dd0 0885     ......1N.@......
c0dea2e1:	454a 9149 25c2 52b2 08e4 4039 19c4 8272     JEI..%.R..9@..r.
c0dea2f1:	815c 0384 b880 c441 7205 0a04 e7d2 6908     \.....A..r.....i
c0dea301:	a202 a50b a113 ec1d 5d99 f6b3 1fee fb6f     .........]....o.
c0dea311:	96c6 febc 4333 4f84 27b9 5ced ebf2 c293     ....3C.O.'.\....
c0dea321:	53bf 2663 cf0a 318c 9d23 5bb1 e866 5176     .Sc&...1#..[f.vQ
c0dea331:	60e1 7d06 3f5d b8fc ce41 24bc cce4 4273     .`.}]?..A..$..sB
c0dea341:	eafe f818 e79b efb4 966a 4b7b 7339 c841     ........j.{K9sA.
c0dea351:	ef99 f908 e431 bfd8 1c5a 7979 f15b 9090     ....1...Z.yy[...
c0dea361:	8733 6891 f33b 1855 96a9 239f f96e 8f25     3..h;.U....#n.%.
c0dea371:	7438 4b8e c9d6 bfeb 6f0b 3809 e0f3 8085     8t.K.....o.8....
c0dea381:	34db 977b c5b0 5dec 46c2 5dc8 90d8 9baf     .4{....].F.]....
c0dea391:	94b8 9fc6 fa1b 4631 36dc 7d8c ba4e 3d17     ......1F.6.}N..=
c0dea3a1:	bdae e25f c4bc 9f6e eff4 eb93 164b f784     .._...n.....K...
c0dea3b1:	2a9b fe68 5d4f 3d90 7743 5b05 7de8 70f9     .*h.O].=Cw.[.}.p
c0dea3c1:	ebf1 4416 ccf9 a1de 00bb a01f 39d3 b4ef     ...D.........9..
c0dea3d1:	b74f bebf fef5 ed72 141b fba4 787b 2e82     O.....r.....{x..
c0dea3e1:	f705 e9d8 1833 c93f f4f9 cfa1 9727 0297     ....3.?.....'...
c0dea3f1:	14bb b04c c14b 7603 89f2 6e43 fa57 f77c     ..L.K..v..CnW.|.
c0dea401:	db89 fbe8 4cc5 fd95 50b4 93f7 605f 6523     .....L...P.._`#e
c0dea411:	e63f 73ba c6a0 fb3d f499 5e05 cbcd e43f     ?..s..=....^..?.
c0dea421:	7b2a 0024 0008                               *{$....

c0dea428 <C_Warning_64px>:
c0dea428:	0040 0040 0102 a2c1 c0de                    @.@.......

c0dea432 <C_Back_40px_bitmap>:
c0dea432:	0028 0028 8c21 0000 008a 8b1f 0008 0000     (.(.!...........
c0dea442:	0000 0302 d3ed 09cd 20c0 800c d0d1 0e53     ......... ....S.
c0dea452:	a21d 39a3 364a 9570 d26e c46d c143 c7e6     ...9J6p.n.m.C...
c0dea462:	a8d6 73d0 f50f e110 81e3 b010 9794 f843     ...s..........C.
c0dea472:	efb7 c3b6 53b7 4667 28df dcca b621 6196     .....SgF.(..!..a
c0dea482:	2b95 b601 0646 d04a 5b5b fa86 4192 376d     .+..F.J.[[...Am7
c0dea492:	50ab c3da 942a 98d6 6e41 198e e6e4 4299     .P..*...An.....B
c0dea4a2:	8ec2 2429 99ec 6dc0 6181 0933 c4f8 5561     ..)$...m.a3...aU
c0dea4b2:	6001 605a 199a 7c43 01fb 02e5 04e6 e43a     .`Z`..C|......:.
c0dea4c2:	0320 0000                                    ...

c0dea4c6 <C_Back_40px>:
c0dea4c6:	0028 0028 0102 a432 c0de                    (.(...2...

c0dea4d0 <C_Check_40px_bitmap>:
c0dea4d0:	0028 0028 5401 0000 0052 8b1f 0008 0000     (.(..T..R.......
c0dea4e0:	0000 0302 6063 05c0 4078 1c84 9088 1307     ....c`..x@......
c0dea4f0:	400d ff82 9000 7f60 2400 3f98 0900 1fc6     .@....`..$.?....
c0dea500:	9920 203f 0ea2 d844 57e3 2608 602a b02c      .? ..D..W.&*`,.
c0dea510:	5818 ac16 ac0e ac03 1ed7 5e6e 5c0d 0183     .X........n^.\..
c0dea520:	0103 0000 8363 77dc 00c8 0000               ....c..w....

c0dea52c <C_Check_40px>:
c0dea52c:	0028 0028 0100 a4d0 c0de                    (.(.......

c0dea536 <C_Chevron_40px_bitmap>:
c0dea536:	0028 0028 5c22 0000 ffff ffff ffff ffff     (.(."\..........
c0dea546:	1cda 03e4 0310 03e2 0330 03e0 0350 03de     ........0...P...
c0dea556:	1820 0320 03dc 0820 08c1 0320 03da 0820      . ... ... ... .
c0dea566:	08c3 0320 03d8 0820 08c5 0320 03d6 0820     .. ... ... ... .
c0dea576:	08c7 0320 05d4 0820 08c9 0520 9ed3 8020     .. ... ... ... .
c0dea586:	98cb e002 0ed4 cd09 0e09 ffff ffff ffff     ................
c0dea596:	ffff e2ff                                   ....

c0dea59a <C_Chevron_40px>:
c0dea59a:	0028 0028 0102 a536 c0de                    (.(...6...

c0dea5a4 <C_Chevron_Back_40px_bitmap>:
c0dea5a4:	0028 0028 7621 0000 0074 8b1f 0008 0000     (.(.!v..t.......
c0dea5b4:	0000 0302 d2ed 0dc1 3080 0508 8e50 383d     .........0..P.=8
c0dea5c4:	a3a4 41b0 7157 6e93 3863 d498 1042 eb7e     ...AWq.nc8..B.~.
c0dea5d4:	4606 340e bfe5 0b84 ffbd aa35 e7e1 2eb2     .F.4......5.....
c0dea5e4:	6705 b55c 541f 2473 e9b4 1273 7640 27b0     .g\..Ts$..s.@v.'
c0dea5f4:	2794 c807 0711 4c94 3203 73ac b828 21cd     .'.....L.2.s(..!
c0dea604:	8732 7313 3338 0b83 b833 8532 532b 62f8     2..s83..3.2.+S.b
c0dea614:	9603 1dcf 0dc6 8ef2 7343 0320 0000          ........Cs ...

c0dea622 <C_Chevron_Back_40px>:
c0dea622:	0028 0028 0102 a5a4 c0de                    (.(.......

c0dea62c <C_Chevron_Next_40px_bitmap>:
c0dea62c:	0028 0028 7121 0000 006f 8b1f 0008 0000     (.(.!q..o.......
c0dea63c:	0000 0302 ceed 0dbb 3080 450c 5751 0a51     .........0.EQWQ.
c0dea64c:	cc86 ac06 0d90 0918 42a6 1448 c48f 8e44     .........BH...D.
c0dea65c:	1b3f 6e20 74f9 1964 58f8 8735 22e9 02da     ?. n.td..X5.."..
c0dea66c:	ca23 a581 61e2 f5a5 b074 c031 c6c1 0b00     #....a..t.1.....
c0dea67c:	3999 ccc8 c1c2 1c0c 434c 0a61 9b0a 3150     .9......LCa...P1
c0dea68c:	c781 1d64 ec2e fe92 bcbe 7707 ddbd ebf8     ..d........w....
c0dea69c:	383d be09 209b 0003                          =8... ...

c0dea6a5 <C_Chevron_Next_40px>:
c0dea6a5:	0028 0028 0102 a62c c0de                    (.(...,...

c0dea6af <C_Close_40px_bitmap>:
c0dea6af:	0028 0028 8521 0000 0083 8b1f 0008 0000     (.(.!...........
c0dea6bf:	0000 0302 fffb c07f bfc0 08f9 cff6 10f7     ................
c0dea6cf:	11fa 4207 41ac 420f 604f 87e8 fd09 e060     ...B.A.BO`....`.
c0dea6df:	3184 0ae0 e01b 70d2 9216 9c2c 5089 6706     .1.....p..,..P.g
c0dea6ef:	2923 7383 9590 7941 ca28 5ca0 6554 3e60     #).s..Ay(..\Te`>
c0dea6ff:	329a 42b0 6574 8520 cae8 0a40 9431 1561     .2.Bte ...@.1.a.
c0dea70f:	a2c3 9b17 581d 82dc cdcd fc58 2d86 b00c     .....X....X..-..
c0dea71f:	1584 30b6 12c5 d8f6 08e2 5c5b 8b62 6c73     ...0......[\b.sl
c0dea72f:	6369 0040 b400 b40b 2014 0003                ic@...... ...

c0dea73c <C_Close_40px>:
c0dea73c:	0028 0028 0102 a6af c0de                    (.(.......

c0dea746 <C_Info_40px_bitmap>:
c0dea746:	0028 0028 3121 0000 002f 8b1f 0008 0000     (.(.!1../.......
c0dea756:	0000 0302 fffb 147f 0bd0 f030 67ff 0180     ..........0..g..
c0dea766:	2a7e 7189 5a60 80d3 ec45 cf57 f068 0593     ~*.q`Z..E.W.h...
c0dea776:	d900 c99e 2019 0003                          ..... ...

c0dea77f <C_Info_40px>:
c0dea77f:	0028 0028 0102 a746 c0de                    (.(...F...

c0dea789 <C_Mini_Push_40px_bitmap>:
c0dea789:	0028 0028 ce21 0000 00cc 8b1f 0008 0000     (.(.!...........
c0dea799:	0000 0302 936d 0dcd 30c2 460c 2123 4ea4     ....m....0.F#!.N
c0dea7a9:	ba83 2b01 5230 6037 4604 0762 b006 5c0f     ...+0R7`.Fb....\
c0dea7b9:	4240 4936 2f9c f6bf c9a5 b3d3 3913 aaae     @B6I./.......9..
c0dea7c9:	1085 0eb1 4911 1e0a 7710 829f 6ab0 5a90     .....I...w...j.Z
c0dea7d9:	9606 3ac2 08a7 a7f5 a2d1 4761 b5e3 d168     ...:......aG..h.
c0dea7e9:	2f6c 053a a92f f019 a4cc fb95 6b3d cac1     l/:./.......=k..
c0dea7f9:	53f6 6563 0ef5 8ae1 c043 10f6 3220 db41     .Sce....C... 2A.
c0dea809:	880e d044 1fee 8588 4d45 6215 5161 8553     ..D.....EM.baQS.
c0dea819:	2c68 556b 7634 5a4b cf12 e599 bcbb ab36     h,kU4vKZ......6.
c0dea829:	5c7e fdda 61e4 cbec d6c6 b81e ebcc db95     ~\...a..........
c0dea839:	af53 def7 791b e96f f9be 9628 eac9 b147     S....yo...(...G.
c0dea849:	3926 e6b3 a4ce bb37 8cee ff4f 1fc2 8764     &9....7...O...d.
c0dea859:	9d98 0320 0000                              .. ...

c0dea85f <C_Mini_Push_40px>:
c0dea85f:	0028 0028 0102 a789 c0de                    (.(.......

c0dea869 <C_Privacy_40px_bitmap>:
c0dea869:	0028 0028 ac21 0001 01aa 8b1f 0008 0000     (.(.!...........
c0dea879:	0000 0302 927d 4bbf 50c3 c710 e9af 8b4f     ....}..K.P....O.
c0dea889:	1768 0741 b335 fe88 6609 1d28 2c44 1fe2     h.A.5....f(.D,..
c0dea899:	2ea0 cdd2 2e0a 6082 a45c b4b8 0ff8 4418     .......`\......D
c0dea8a9:	1c50 b3b4 dd28 60a5 8777 38a2 10e9 b56b     P...(..`w..8..k.
c0dea8b9:	dac6 bce6 97bb 2da6 378a 25e4 f79f f7de     .......-.7.%....
c0dea8c9:	77be c439 a3bf ba75 ca9e f75c 26a1 8448     .w9...u...\..&H.
c0dea8d9:	7a2e 23d8 b178 1f40 5e4e 6ad8 7320 7b7e     .z.#x.@.N^.j s~{
c0dea8e9:	4cb6 1a70 8cd1 7231 2e21 cf5b 8c06 03a3     .Lp...1r!.[.....
c0dea8f9:	1ac2 a730 dc34 2ab5 4166 beee c941 6e97     ..0.4..*fA..A..n
c0dea909:	63a8 6968 74dd d859 d595 fb88 81c8 5288     .chi.tY........R
c0dea919:	2181 90c9 a1bb 74a4 16cc 69c7 9e7a 9390     .!.....t...iz...
c0dea929:	4e29 1eda d913 c423 f127 53ac 07d2 22a8     )N....#.'..S..."
c0dea939:	e1d6 5d0e 461d 4b72 49c0 30eb f88b 880a     ...].FrK.I.0....
c0dea949:	10ef 6125 8d93 09ba a8da c904 5c0e 328a     ..%a.........\.2
c0dea959:	283b 1004 218b 5d44 cd39 2bd2 c9dd 15a3     ;(...!D]9..+....
c0dea969:	36c1 084c 01ab 6919 24c1 e237 561b 7d84     .6L....i.$7..V.}
c0dea979:	8488 c031 51cc 7b85 216b 9bf4 c259 fe9a     ..1..Q.{k!..Y...
c0dea989:	92dd 9faa b872 cb24 3521 a8b4 62fe b698     ....r.$.!5...b..
c0dea999:	c2a2 4d4c 6cbc 4560 f7eb 916c 5521 cc5b     ..LM.l`E..l.!U[.
c0dea9a9:	86e6 8752 3d5c adc2 7bf7 d9a0 a6dc be99     ..R.\=...{......
c0dea9b9:	2d5e 26b2 a8cb 1e9e 9a13 8b17 3a52 f30c     ^-.&........R:..
c0dea9c9:	3ef3 a327 ca61 ae09 8fcf 084f 5aca f908     .>'.a.....O..Z..
c0dea9d9:	35c8 ffbc a35f 5ec4 41ec f3b8 d353 3a1e     .5.._..^.A..S..:
c0dea9e9:	f604 9120 5418 b993 8329 5e85 db99 f2e5     .. ..T..)..^....
c0dea9f9:	56d5 6002 57d4 75ae b266 f08b 114b a76d     .V.`.W.uf...K.m.
c0deaa09:	a077 f65f c993 81d4 ff8d 0fc5 af18 4ccb     w._............L
c0deaa19:	0320 0000                                    ...

c0deaa1d <C_Privacy_40px>:
c0deaa1d:	0028 0028 0102 a869 c0de                    (.(...i...

c0deaa27 <C_Settings_40px_bitmap>:
c0deaa27:	0028 0028 9321 0001 0191 8b1f 0008 0000     (.(.!...........
c0deaa37:	0000 0302 5275 52b1 40c2 7d10 88c9 9841     ....uR.R.@.}..A.
c0deaa47:	8c91 8e56 10ce 5e87 3e46 ec40 93b0 4e8e     ..V....^F>@....N
c0deaa57:	03fd 4053 850d 1695 9d62 4a42 b03b 8a93     ..S@....b.BJ;...
c0deaa67:	0bf1 04fc 1c1c 40eb a202 3920 2f77 1738     .......@.. 9w/8.
c0deaa77:	d818 6f62 e5ef eef2 bbed 6215 8c7d ad4d     ..bo.......b}.M.
c0deaa87:	8cba 81d5 25ad 8028 6b61 45dd 87ac 8fac     .....%(.ak.E....
c0deaa97:	daac 764f 4e0b 7751 3303 aed6 761c ac42     ..Ov.NQw.3...vB.
c0deaaa7:	8a01 1084 f9ad 314a 12e5 74f7 2cb5 8c9a     ......J1...t.,..
c0deaab7:	300d 976b 5c73 4ae5 8b8e 5734 5c1e 3dc5     .0k.s\.J..4W.\.=
c0deaac7:	9e43 1197 0a3a e29b 765c 4780 fd85 1aa0     C...:...\v.G....
c0deaad7:	9e59 5cee 6075 4b8a 57ca 26c0 c381 6890     Y..\u`.K.W.&...h
c0deaae7:	fac4 2c7b 48e3 1f08 7c17 4593 0557 0a16     ..{,.H...|.EW...
c0deaaf7:	d037 8459 a74e 601f f108 0385 9e21 2d71     7.Y.N..`....!.q-
c0deab07:	8d44 19ec 2343 7786 f9a6 8a45 b79a 1d50     D...C#.w..E...P.
c0deab17:	84e0 5a08 cc1b 9a7c 0e90 fba5 ef06 716a     ...Z..|.......jq
c0deab27:	76ce 5398 2c73 25fa 6035 a205 fe11 a49b     .v.Ss,.%5`......
c0deab37:	81f4 18f4 b93a c7d3 8b1b a6df 5264 755b     ....:.......dR[u
c0deab47:	59c4 becb af10 c5ac 9ec6 b960 87d4 b385     .Y........`.....
c0deab57:	cb32 a1f5 4bf3 b27d ff65 79bd f9b2 b2d0     2....K}.e..y....
c0deab67:	3d80 6650 5e86 2f05 11b7 5733 3a79 f45c     .=Pf.^./..3Wy:\.
c0deab77:	f25e e8f9 6746 1b24 65be aed0 b864 14ca     ^...Fg$..e..d...
c0deab87:	6e9c 96f8 f913 44d4 2df3 8e8b 8d9a 9aa4     .n.....D.-......
c0deab97:	c911 53bb 8a72 1b9a b158 f976 a9b8 3db8     ...Sr...X.v....=
c0deaba7:	3de4 50e9 6624 61a6 6747 dd64 aeec f19c     .=.P$f.aGgd.....
c0deabb7:	fc68 4701 f51a 207f 0003                     h..G... ...

c0deabc2 <C_Settings_40px>:
c0deabc2:	0028 0028 0102 aa27 c0de                    (.(...'...

c0deabcc <C_Warning_40px_bitmap>:
c0deabcc:	0028 0028 e721 0000 00e5 8b1f 0008 0000     (.(.!...........
c0deabdc:	0000 0302 d36d 0db1 40c2 850c 47e1 2284     ....m....@...G."
c0deabec:	283a d511 88d5 1182 0032 8662 904c 0815     :(......2.b.L...
c0deabfc:	3013 2c03 0ec0 9e88 1025 526d 8450 9d10     .0.,....%.mRP...
c0deac0c:	73b9 8842 b87d aafc 675f 911f 4b1c 34c1     .sB.}..._g...K.4
c0deac1c:	0b26 c128 5b44 c08a c0f6 d95a d811 d2e6     &.(.D[....Z.....
c0deac2c:	c0ae a486 81dd 4905 80ab 4939 66ab 4988     .......I..9I.f.I
c0deac3c:	635a be30 7349 11ad c0d3 8c52 240e b5cd     Zc0.Is....R..$..
c0deac4c:	d476 6f9b 6925 2adc 6dad d615 0eb5 c5ed     v..o%i.*.m......
c0deac5c:	25ad 4cfc b04b b93d b035 db42 20db 942e     .%.LK.=.5.B.. ..
c0deac6c:	43d1 773e e2db a970 2e8d 4ac0 9d1b 4c80     .C>w..p....J...L
c0deac7c:	e51b ec3f a6cd ce88 c8ca 5f26 bc1c 6d7d     ..?.......&_..}m
c0deac8c:	5db8 a8ee 76e6 cbb5 5dae bcee 576d c1b7     .]...v...]..mW..
c0deac9c:	caed 5db8 6f9b da37 9fec f49b 81ed ccb9     ...].o7.........
c0deacac:	785d fef8 7c2f 1300 b8d8 2006 0003           ]x../|..... ...

c0deacbb <C_Warning_40px>:
c0deacbb:	0028 0028 0102 abcc c0de 3e3d 6120 6470     (.(.......=> apd
c0deaccb:	5f75 6964 7073 7461 6863 7265 6620 6961     u_dispatcher fai
c0deacdb:	756c 6572 000a 7254 6e61 6173 7463 6f69     lure..Transactio
c0deaceb:	206e 6843 6365 206b 6e75 7661 6961 616c     n Check unavaila
c0deacfb:	6c62 0065 3e3d 6920 5f6f 6572 7663 635f     ble.=> io_recv_c
c0dead0b:	6d6f 616d 646e 6620 6961 756c 6572 000a     ommand failure..
c0dead1b:	7041 2070 7265 6f72 0072 6553 7263 7465     App error.Secret
c0dead2b:	0073 6649 7920 756f 7227 2065 6f6e 2074     s.If you're not 
c0dead3b:	7375 6e69 2067 6874 2065 654c 6764 7265     using the Ledger
c0dead4b:	5720 6c61 656c 2074 7061 2c70 5420 6172      Wallet app, Tra
c0dead5b:	736e 6361 6974 6e6f 4320 6568 6b63 6d20     nsaction Check m
c0dead6b:	6769 7468 6e20 746f 7720 726f 2e6b 4920     ight not work. I
c0dead7b:	2066 6f79 2075 7261 2065 7375 6e69 2067     f you are using 
c0dead8b:	654c 6764 7265 5720 6c61 656c 2c74 7220     Ledger Wallet, r
c0dead9b:	6a65 6365 2074 6874 2065 7274 6e61 6173     eject the transa
c0deadab:	7463 6f69 206e 6e61 2064 7274 2079 6761     ction and try ag
c0deadbb:	6961 2e6e 0a0a 6547 2074 6568 706c 6120     ain...Get help a
c0deadcb:	2074 656c 6764 7265 632e 6d6f 652f 3131     t ledger.com/e11
c0deaddb:	4500 6978 2074 7061 0070 0020 7325 2520     .Exit app. .%s %
c0deadeb:	0a73 7325 6800 7474 7370 2f3a 252f 0073     s.%s.https://%s.
c0deadfb:	445b 4645 5541 544c 415f 4450 5d55 3d20     [DEFAULT_APDU] =
c0deae0b:	203e 4c43 3d41 3025 7832 202c 4e49 3d53     > CLA=%02x, INS=
c0deae1b:	3025 7832 2820 7325 2c29 5020 3d31 3025     %02x (%s), P1=%0
c0deae2b:	7832 202c 3250 253d 3230 2c78 4c20 3d43     2x, P2=%02x, LC=
c0deae3b:	3025 7832 202c 4443 5441 3d41 2e25 682a     %02x, CDATA=%.*h
c0deae4b:	000a 4e45 2053 616e 656d 2073 7261 2065     ..ENS names are 
c0deae5b:	6572 6f73 766c 6465 6220 2079 654c 6764     resolved by Ledg
c0deae6b:	7265 6220 6361 656b 646e 002e 6553 7563     er backend..Secu
c0deae7b:	6972 7974 7220 7065 726f 0074 7325 250a     rity report.%s.%
c0deae8b:	2073 7325 4c00 414f 5f44 4543 5452 4649     s %s.LOAD_CERTIF
c0deae9b:	4349 5441 0045 6559 2c73 7320 696b 0070     ICATE.Yes, skip.
c0deaeab:	7325 7220 7065 726f 0074 3d3c 5320 3d57     %s report.<= SW=
c0deaebb:	3025 5834 7c20 5220 6144 6174 253d 2a2e     %04X | RData=%.*
c0deaecb:	0a48 5500 4b4e 4f4e 4e57 4300 6f6c 6573     H..UNKNOWN.Close
c0deaedb:	5300 6163 206e 6f74 7620 6569 2077 7566     .Scan to view fu
c0deaeeb:	6c6c 7220 7065 726f 0074 6854 7369 7420     ll report.This t
c0deaefb:	6172 736e 6361 6974 6e6f 6f20 2072 656d     ransaction or me
c0deaf0b:	7373 6761 2065 6163 6e6e 746f 6220 2065     ssage cannot be 
c0deaf1b:	6564 6f63 6564 2064 7566 6c6c 2e79 4920     decoded fully. I
c0deaf2b:	2066 6f79 2075 6863 6f6f 6573 7420 206f     f you choose to 
c0deaf3b:	6973 6e67 202c 6f79 2075 6f63 6c75 2064     sign, you could 
c0deaf4b:	6562 6120 7475 6f68 6972 697a 676e 6d20     be authorizing m
c0deaf5b:	6c61 6369 6f69 7375 6120 7463 6f69 736e     alicious actions
c0deaf6b:	7420 6168 2074 6163 206e 7264 6961 206e      that can drain 
c0deaf7b:	6f79 7275 7720 6c61 656c 2e74 0a0a 654c     your wallet...Le
c0deaf8b:	7261 206e 6f6d 6572 203a 656c 6764 7265     arn more: ledger
c0deaf9b:	632e 6d6f 652f 0038 3d3c 4620 4152 2047     .com/e8.<= FRAG 
c0deafab:	2528 2f75 7525 2029 4452 7461 3d61 2e25     (%u/%u) RData=%.
c0deafbb:	482a 000a 5453 4341 5f4b 4f43 534e 4d55     *H..STACK_CONSUM
c0deafcb:	5450 4f49 004e 5041 5f50 5845 5449 4d00     PTION.APP_EXIT.M
c0deafdb:	726f 0065 6854 7369 7420 6172 736e 6361     ore.This transac
c0deafeb:	6974 6e6f 6320 6e61 6f6e 2074 6562 4320     tion cannot be C
c0deaffb:	656c 7261 5320 6769 656e 0064 3e3d 5020     lear Signed.=> P
c0deb00b:	3a43 3020 2578 3830 2058 000a 3e3d 4320     C: 0x%08X ..=> C
c0deb01b:	414c 253d 3230 2058 207c 4e49 3d53 3025     LA=%02X | INS=%0
c0deb02b:	5832 7c20 5020 3d31 3025 5832 7c20 5020     2X | P1=%02X | P
c0deb03b:	3d32 3025 5832 7c20 4c20 3d63 3025 5832     2=%02X | Lc=%02X
c0deb04b:	7c20 4320 6144 6174 253d 2a2e 0a48 4300      | CData=%.*H..C
c0deb05b:	6e61 6563 006c 6854 7369 7420 6172 736e     ancel.This trans
c0deb06b:	6361 6974 6e6f 7720 7361 7320 6163 6e6e     action was scann
c0deb07b:	6465 6120 2073 616d 696c 6963 756f 2073     ed as malicious 
c0deb08b:	7962 5720 6265 2033 6843 6365 736b 002e     by Web3 Checks..
c0deb09b:	6425 6f20 2066 6425 5300 696b 2070 6572     %d of %d.Skip re
c0deb0ab:	6976 7765 003f 454c 4744 5245 415f 5353     view?.LEDGER_ASS
c0deb0bb:	5245 2054 4146 4c49 4445 000a 6c42 6e69     ERT FAILED..Blin
c0deb0cb:	2064 6973 6e67 6e69 2067 6572 7571 7269     d signing requir
c0deb0db:	6465 2500 3a73 253a 0a64 3d00 203e 212f     ed.%s::%d..=> /!
c0deb0eb:	205c 4142 2044 454c 474e 4854 203a 2e25     \ BAD LENGTH: %.
c0deb0fb:	482a 000a 755b 6b6e 6f6e 6e77 005d 6952     *H..[unknown].Ri
c0deb10b:	6b73 6420 7465 6365 6574 0064 4547 5f54     sk detected.GET_
c0deb11b:	4553 4445 435f 4f4f 494b 0045 7243 7469     SEED_COOKIE.Crit
c0deb12b:	6369 6c61 7420 7268 6165 0074 6854 7369     ical threat.This
c0deb13b:	7420 6172 736e 6361 6974 6e6f 7327 6420      transaction's d
c0deb14b:	7465 6961 736c 6120 6572 6e20 746f 6620     etails are not f
c0deb15b:	6c75 796c 7620 7265 6669 6169 6c62 2e65     ully verifiable.
c0deb16b:	4920 2066 6f79 2075 6973 6e67 202c 6f79      If you sign, yo
c0deb17b:	2075 6f63 6c75 2064 6f6c 6573 6120 6c6c     u could lose all
c0deb18b:	7920 756f 2072 7361 6573 7374 002e 3d65      your assets..e=
c0deb19b:	7830 3025 5834 200a 524c 303d 2578 3830     0x%04X. LR=0x%08
c0deb1ab:	0a58 7300 6174 646e 6c61 6e6f 5f65 7061     X..standalone_ap
c0deb1bb:	5f70 616d 6e69 000a 7865 6563 7470 6f69     p_main..exceptio
c0deb1cb:	5b6e 7830 3025 5834 3a5d 4c20 3d52 7830     n[0x%04X]: LR=0x
c0deb1db:	3025 5838 000a 000a 656e 7774 726f 2e6b     %08X....network.
c0deb1eb:	4900 2066 6f79 2775 6572 7320 7275 2065     .If you're sure 
c0deb1fb:	6f79 2075 6f64 276e 2074 656e 6465 7420     you don't need t
c0deb20b:	206f 6572 6976 7765 6120 6c6c 6620 6569     o review all fie
c0deb21b:	646c 2c73 7920 756f 6320 6e61 7320 696b     lds, you can ski
c0deb22b:	2070 7473 6172 6769 7468 7420 206f 6973     p straight to si
c0deb23b:	6e67 6e69 2e67 5400 6968 2073 7274 6e61     gning..This tran
c0deb24b:	6173 7463 6f69 206e 6177 2073 6373 6e61     saction was scan
c0deb25b:	656e 2064 7361 7220 7369 796b 6220 2079     ned as risky by 
c0deb26b:	6557 3362 4320 6568 6b63 2e73 3c00 203d     Web3 Checks..<= 
c0deb27b:	5753 253d 3430 2058 207c 4452 7461 3d61     SW=%04X | RData=
c0deb28b:	000a 6f4e 7420 7268 6165 2074 6564 6574     ..No threat dete
c0deb29b:	7463 6465 4c00 3d52 7830 3025 5838 200a     cted.LR=0x%08X. 
c0deb2ab:	4350 303d 2578 3830 0a58 4700 206f 6162     PC=0x%08X..Go ba
c0deb2bb:	6b63 7420 206f 6572 6976 7765 2500 3a73     ck to review.%s:
c0deb2cb:	253a 2064 000a 6b53 7069 4700 5445 565f     :%d ..Skip.GET_V
c0deb2db:	5245 4953 4e4f 4100 4444 4552 5353 425f     ERSION.ADDRESS_B
c0deb2eb:	4f4f 004b 7551 7469 6120 7070 3d00 203e     OOK.Quit app.=> 
c0deb2fb:	524c 203a 7830 3025 5838 0a20 5300 6977     LR: 0x%08X ..Swi
c0deb30b:	6570 7420 206f 6572 6976 7765 5400 6968     pe to review.Thi
c0deb31b:	2073 7061 2070 6e65 6261 656c 2073 6973     s app enables si
c0deb32b:	6e67 6e69 0a67 7274 6e61 6173 7463 6f69     gning.transactio
c0deb33b:	736e 6f20 206e 6874 0065 7254 6e61 6173     ns on the.Transa
c0deb34b:	7463 6f69 206e 6843 6365 206b 6964 6e64     ction Check didn
c0deb35b:	7427 6620 6e69 2064 6e61 2079 6874 6572     't find any thre
c0deb36b:	7461 202c 7562 2074 6c61 6177 7379 7220     at, but always r
c0deb37b:	7665 6569 2077 7274 6e61 6173 7463 6f69     eview transactio
c0deb38b:	206e 6564 6174 6c69 2073 6163 6572 7566     n details carefu
c0deb39b:	6c6c 2e79 2f00 7061 2f70 7273 2f63 7061     lly../app/src/ap
c0deb3ab:	7564 642f 7369 6170 6374 6568 2e72 0063     du/dispatcher.c.
c0deb3bb:	0025 0000 5400 6968 2073 7061 2070 6e65     %....This app en
c0deb3cb:	6261 656c 2073 6973 6e67 6e69 0a67 7274     ables signing.tr
c0deb3db:	6e61 6173 7463 6f69 736e 6f20 206e 7469     ansactions on it
c0deb3eb:	2073 656e 7774 726f 2e6b 0000 4e00 4c55     s network....NUL
c0deb3fb:	204c 6d63 0064                              L cmd.

c0deb401 <MAGIC>:
c0deb401:	444c 5f47 4e45 5243 0000                     LDG_ENCR...

c0deb40c <DERIVATION_PATH>:
c0deb40c:	002c 8000 e2c1 8000 0000 8000 0000 0000     ,...............
c0deb41c:	0000 0000                                   ....

c0deb420 <HKDF_SALT>:
c0deb420:	656c 6764 7265 652d 636e 7972 7470 7620     ledger-encrypt v
c0deb430:	0031 0000                                   1...

c0deb434 <HKDF_INFO>:
c0deb434:	656c 6764 7265 652d 636e 7972 7470 7620     ledger-encrypt v
c0deb444:	2031 6966 656c 6120 7365 322d 3635 672d     1 file aes-256-g
c0deb454:	6d63 0000                                   cm..

c0deb458 <settingContents>:
	...

c0deb464 <infoList>:
	...

c0deb474 <nbMaxElementsPerContentType>:
c0deb474:	0101 0101 0101 0301 0503 0005               ............

c0deb480 <.L__const.displayAddressQRCode.headerDesc>:
c0deb480:	0000 0000 0028 0000 0000 0000 0000 0000     ....(...........
c0deb490:	0000 0000                                   ....

c0deb494 <.L__const.displaySkipWarning.info>:
c0deb494:	b0a4 c0de b1ec c0de 0000 0000 a2b7 c0de     ................
c0deb4a4:	0000 0000 aea1 c0de b2b6 c0de 0005 0109     ................

c0deb4b4 <.L__const.displaySecurityReport.layoutDescription>:
c0deb4b4:	0101 0000 0000 0000 0000 0000 7f89 c0de     ................
	...

c0deb4d0 <.L__const.displaySecurityReport.headerDesc>:
c0deb4d0:	0101 0000 0000 0000 0000 0000 0917 0000     ................
c0deb4e0:	0000 0000                                   ....

c0deb4e4 <securityReportItems>:
c0deb4e4:	acbb c0de ace1 c0de 0000 0000 acbb c0de     ................
c0deb4f4:	b109 c0de b242 c0de acbb c0de b127 c0de     ....B.......'...
c0deb504:	b061 c0de 0000 0000 b28d c0de b345 c0de     a...........E...
c0deb514:	acbb c0de b0c7 c0de b137 c0de 0000 0000     ........7.......
	...

c0deb52c <.L__const.displayInfosListModal.info>:
c0deb52c:	0100 0114 0900 0000 0000 0000 0000 0000     ................
c0deb53c:	0100 0300 0000 0000 0000 0000               ............

c0deb548 <g_pcHex>:
c0deb548:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef

c0deb558 <g_pcHex_cap>:
c0deb558:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF

c0deb568 <_etext>:
	...

c0deb600 <install_parameters>:
c0deb600:	0701 6553 7263 7465 0273 3205 332e 312e     ..Secrets..2.3.1
c0deb610:	8103 28ec 2800 2100 00e4 e200 1f00 088b     ...(.(.!........
c0deb620:	0000 0000 0200 9d03 bd92 830d 1030 cf85     ............0...
c0deb630:	8172 26e4 0066 1594 3288 3300 0621 2cc8     r..&f....2.3!..,
c0deb640:	3a51 861a 40a1 934a 2c31 3a59 625d ed88     Q:...@J.1,Y:]b..
c0deb650:	4db3 7241 3205 c78f f77d a263 025f a55f     .MAr.2..}.c._._.
c0deb660:	9a66 b352 c772 d307 a68e 7fca 3c01 4ec5     f.R.r........<.N
c0deb670:	07c1 76dd eb1a d45b 0a56 ba0e f98a 51c0     ...v..[.V......Q
c0deb680:	5696 86e8 ca6b 35de 0880 1bd5 d6f7 3e7e     .V..k..5......~>
c0deb690:	4540 07dc 3dda 5e3a 16cb 8e22 f7a0 285a     @E...=:^.."...Z(
c0deb6a0:	697d e4bd 5c5b df71 0aa8 2053 c970 6c13     }i..[\q...S p..l
c0deb6b0:	202f 474f 4738 1ced 194a 8403 1b8d 0c87     / OG8G..J.......
c0deb6c0:	f492 28a1 37ed 30a1 9c1f 9f12 5e7c 3e74     ...(.7.0....|^t>
c0deb6d0:	452b a8f8 7441 a67c 932e 23e9 08c5 9db1     +E..At|....#....
c0deb6e0:	1af1 1a96 4977 dc73 dca5 07b9 d8ea 921d     ....wIs.........
c0deb6f0:	eec7 d224 f13f 2906 9724 203f 0003 0400     ..$.?..)$.? ....
c0deb700:	040a 8002 0000 802c e200                     ......,....
