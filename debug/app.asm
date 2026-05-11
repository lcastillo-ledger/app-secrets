
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
c0de0006:	f008 f8cb 	bl	c0de81a0 <os_boot>

    if (arg0 == 0) {
c0de000a:	2c00      	cmp	r4, #0
        // Called from dashboard as standalone App
        standalone_app_main();
c0de000c:	bf08      	it	eq
c0de000e:	f007 fe74 	bleq	c0de7cfa <standalone_app_main>
            app_exit();
        }
    }
#endif  // HAVE_SWAP

    return 0;
c0de0012:	2000      	movs	r0, #0
c0de0014:	bd10      	pop	{r4, pc}

c0de0016 <apdu_dispatcher>:
#include "sw.h"

#include "get_version.h"
#include "get_app_name.h"

int apdu_dispatcher(const command_t *cmd) {
c0de0016:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0018:	b081      	sub	sp, #4
    LEDGER_ASSERT(cmd != NULL, "NULL cmd");
c0de001a:	b348      	cbz	r0, c0de0070 <apdu_dispatcher+0x5a>

    if (cmd->cla != CLA) {
c0de001c:	7801      	ldrb	r1, [r0, #0]
c0de001e:	29e0      	cmp	r1, #224	@ 0xe0
c0de0020:	d10c      	bne.n	c0de003c <apdu_dispatcher+0x26>
        return io_send_sw(SWO_INVALID_CLA);
    }

    switch (cmd->ins) {
c0de0022:	7841      	ldrb	r1, [r0, #1]
c0de0024:	2904      	cmp	r1, #4
c0de0026:	d00e      	beq.n	c0de0046 <apdu_dispatcher+0x30>
c0de0028:	2903      	cmp	r1, #3
c0de002a:	d115      	bne.n	c0de0058 <apdu_dispatcher+0x42>
        case GET_VERSION:
            if (cmd->p1 != 0 || cmd->p2 != 0) {
c0de002c:	7881      	ldrb	r1, [r0, #2]
c0de002e:	b971      	cbnz	r1, c0de004e <apdu_dispatcher+0x38>
c0de0030:	78c0      	ldrb	r0, [r0, #3]
c0de0032:	b960      	cbnz	r0, c0de004e <apdu_dispatcher+0x38>
                return io_send_sw(SWO_INCORRECT_P1_P2);
            }
            return handler_get_version();
c0de0034:	f000 f8d8 	bl	c0de01e8 <handler_get_version>
            return handler_get_app_name();

        default:
            return io_send_sw(SWO_INVALID_INS);
    }
}
c0de0038:	b001      	add	sp, #4
c0de003a:	bdf0      	pop	{r4, r5, r6, r7, pc}
 * @return zero or positive integer if success, -1 otherwise.
 *
 */
static inline int io_send_sw(uint16_t sw)
{
    return io_send_response_buffers(NULL, 0, sw);
c0de003c:	2000      	movs	r0, #0
c0de003e:	2100      	movs	r1, #0
c0de0040:	f44f 42dc 	mov.w	r2, #28160	@ 0x6e00
c0de0044:	e00c      	b.n	c0de0060 <apdu_dispatcher+0x4a>
            if (cmd->p1 != 0 || cmd->p2 != 0) {
c0de0046:	7881      	ldrb	r1, [r0, #2]
c0de0048:	b909      	cbnz	r1, c0de004e <apdu_dispatcher+0x38>
c0de004a:	78c0      	ldrb	r0, [r0, #3]
c0de004c:	b160      	cbz	r0, c0de0068 <apdu_dispatcher+0x52>
c0de004e:	2000      	movs	r0, #0
c0de0050:	2100      	movs	r1, #0
c0de0052:	f646 2286 	movw	r2, #27270	@ 0x6a86
c0de0056:	e003      	b.n	c0de0060 <apdu_dispatcher+0x4a>
c0de0058:	2000      	movs	r0, #0
c0de005a:	2100      	movs	r1, #0
c0de005c:	f44f 42da 	mov.w	r2, #27904	@ 0x6d00
c0de0060:	f007 fdc4 	bl	c0de7bec <io_send_response_buffers>
}
c0de0064:	b001      	add	sp, #4
c0de0066:	bdf0      	pop	{r4, r5, r6, r7, pc}
            return handler_get_app_name();
c0de0068:	f000 f8a8 	bl	c0de01bc <handler_get_app_name>
}
c0de006c:	b001      	add	sp, #4
c0de006e:	bdf0      	pop	{r4, r5, r6, r7, pc}
    LEDGER_ASSERT(cmd != NULL, "NULL cmd");
c0de0070:	4674      	mov	r4, lr
c0de0072:	467d      	mov	r5, pc
c0de0074:	f24a 40b3 	movw	r0, #42163	@ 0xa4b3
c0de0078:	f2c0 0000 	movt	r0, #0
c0de007c:	4478      	add	r0, pc
c0de007e:	f008 f8ad 	bl	c0de81dc <mcu_usb_printf>
c0de0082:	f64a 0602 	movw	r6, #43010	@ 0xa802
c0de0086:	f2c0 0600 	movt	r6, #0
c0de008a:	447e      	add	r6, pc
c0de008c:	4630      	mov	r0, r6
c0de008e:	f008 f8a5 	bl	c0de81dc <mcu_usb_printf>
c0de0092:	f24a 50f7 	movw	r0, #42487	@ 0xa5f7
c0de0096:	f2c0 0000 	movt	r0, #0
c0de009a:	4478      	add	r0, pc
c0de009c:	f008 f89e 	bl	c0de81dc <mcu_usb_printf>
c0de00a0:	f640 1034 	movw	r0, #2356	@ 0x934
c0de00a4:	f2c0 0000 	movt	r0, #0
c0de00a8:	eb09 0700 	add.w	r7, r9, r0
c0de00ac:	4638      	mov	r0, r7
c0de00ae:	4631      	mov	r1, r6
c0de00b0:	2209      	movs	r2, #9
c0de00b2:	f009 f90d 	bl	c0de92d0 <__aeabi_memcpy>
c0de00b6:	4638      	mov	r0, r7
c0de00b8:	f009 f966 	bl	c0de9388 <strlen>
c0de00bc:	220a      	movs	r2, #10
c0de00be:	1839      	adds	r1, r7, r0
c0de00c0:	543a      	strb	r2, [r7, r0]
c0de00c2:	2000      	movs	r0, #0
c0de00c4:	7048      	strb	r0, [r1, #1]
c0de00c6:	f24a 7669 	movw	r6, #42857	@ 0xa769
c0de00ca:	f2c0 0600 	movt	r6, #0
c0de00ce:	447e      	add	r6, pc
c0de00d0:	4630      	mov	r0, r6
c0de00d2:	2120      	movs	r1, #32
c0de00d4:	f007 ff8b 	bl	c0de7fee <assert_print_file_info>
c0de00d8:	4630      	mov	r0, r6
c0de00da:	2120      	movs	r1, #32
c0de00dc:	f007 ff6b 	bl	c0de7fb6 <assert_display_file_info>
c0de00e0:	4620      	mov	r0, r4
c0de00e2:	4629      	mov	r1, r5
c0de00e4:	f007 ff4d 	bl	c0de7f82 <assert_print_lr_and_pc>
c0de00e8:	4620      	mov	r0, r4
c0de00ea:	4629      	mov	r1, r5
c0de00ec:	f007 ff27 	bl	c0de7f3e <assert_display_lr_and_pc>
c0de00f0:	f007 ffb2 	bl	c0de8058 <assert_display_exit>

c0de00f4 <app_main>:
#include "menu.h"

/**
 * Handle APDU command received and send back APDU response using handlers.
 */
void app_main() {
c0de00f4:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de00f8:	b088      	sub	sp, #32
    // Length of APDU command received in G_io_apdu_buffer
    int input_len = 0;
    // Structured APDU command
    command_t cmd;

    io_init();
c0de00fa:	f007 fd5a 	bl	c0de7bb2 <io_init>
    ui_menu_main();
c0de00fe:	f000 f88c 	bl	c0de021a <ui_menu_main>

    for (;;) {
        // Receive command bytes in G_io_apdu_buffer
        if ((input_len = io_recv_command()) < 0) {
c0de0102:	f007 fd5f 	bl	c0de7bc4 <io_recv_command>
c0de0106:	2800      	cmp	r0, #0
c0de0108:	d44d      	bmi.n	c0de01a6 <app_main+0xb2>
c0de010a:	f24a 3a67 	movw	sl, #41831	@ 0xa367
c0de010e:	f2c0 0a00 	movt	sl, #0
c0de0112:	f24a 08d3 	movw	r8, #41171	@ 0xa0d3
c0de0116:	f2c0 0800 	movt	r8, #0
c0de011a:	f24a 4b32 	movw	fp, #42034	@ 0xa432
c0de011e:	f240 0600 	movw	r6, #0
c0de0122:	f2c0 0b00 	movt	fp, #0
c0de0126:	4604      	mov	r4, r0
c0de0128:	f2c0 0600 	movt	r6, #0
c0de012c:	ad05      	add	r5, sp, #20
c0de012e:	44fa      	add	sl, pc
c0de0130:	44f8      	add	r8, pc
c0de0132:	44fb      	add	fp, pc
c0de0134:	e011      	b.n	c0de015a <app_main+0x66>
c0de0136:	bf00      	nop
            return;
        }

        // Parse APDU command from G_io_apdu_buffer
        if (!apdu_parser(&cmd, G_io_apdu_buffer, input_len)) {
            PRINTF("=> /!\\ BAD LENGTH: %.*H\n", input_len, G_io_apdu_buffer);
c0de0138:	eb09 0206 	add.w	r2, r9, r6
c0de013c:	4658      	mov	r0, fp
c0de013e:	4621      	mov	r1, r4
c0de0140:	f008 f84c 	bl	c0de81dc <mcu_usb_printf>
c0de0144:	2000      	movs	r0, #0
c0de0146:	2100      	movs	r1, #0
c0de0148:	f646 2287 	movw	r2, #27271	@ 0x6a87
c0de014c:	f007 fd4e 	bl	c0de7bec <io_send_response_buffers>
        if ((input_len = io_recv_command()) < 0) {
c0de0150:	f007 fd38 	bl	c0de7bc4 <io_recv_command>
c0de0154:	4604      	mov	r4, r0
c0de0156:	2800      	cmp	r0, #0
c0de0158:	d42a      	bmi.n	c0de01b0 <app_main+0xbc>
        if (!apdu_parser(&cmd, G_io_apdu_buffer, input_len)) {
c0de015a:	eb09 0106 	add.w	r1, r9, r6
c0de015e:	4628      	mov	r0, r5
c0de0160:	4622      	mov	r2, r4
c0de0162:	f007 fdfb 	bl	c0de7d5c <apdu_parser>
c0de0166:	2800      	cmp	r0, #0
c0de0168:	d0e6      	beq.n	c0de0138 <app_main+0x44>

        PRINTF("=> CLA=%02X | INS=%02X | P1=%02X | P2=%02X | Lc=%02X | CData=%.*H\n",
               cmd.cla,
               cmd.ins,
               cmd.p1,
               cmd.p2,
c0de016a:	f89d 0017 	ldrb.w	r0, [sp, #23]
               cmd.lc,
c0de016e:	f89d 4018 	ldrb.w	r4, [sp, #24]
               cmd.cla,
c0de0172:	f89d 1014 	ldrb.w	r1, [sp, #20]
               cmd.ins,
c0de0176:	f89d 2015 	ldrb.w	r2, [sp, #21]
               cmd.p1,
c0de017a:	f89d 3016 	ldrb.w	r3, [sp, #22]
               cmd.lc,
               cmd.data);
c0de017e:	9f07      	ldr	r7, [sp, #28]
        PRINTF("=> CLA=%02X | INS=%02X | P1=%02X | P2=%02X | Lc=%02X | CData=%.*H\n",
c0de0180:	e9cd 0400 	strd	r0, r4, [sp]
c0de0184:	4650      	mov	r0, sl
c0de0186:	9402      	str	r4, [sp, #8]
c0de0188:	9703      	str	r7, [sp, #12]
c0de018a:	f008 f827 	bl	c0de81dc <mcu_usb_printf>

        // Dispatch structured APDU command to handler
        if (apdu_dispatcher(&cmd) < 0) {
c0de018e:	4628      	mov	r0, r5
c0de0190:	f7ff ff41 	bl	c0de0016 <apdu_dispatcher>
c0de0194:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
c0de0198:	dcda      	bgt.n	c0de0150 <app_main+0x5c>
c0de019a:	f24a 0827 	movw	r8, #40999	@ 0xa027
c0de019e:	f2c0 0800 	movt	r8, #0
c0de01a2:	44f8      	add	r8, pc
c0de01a4:	e004      	b.n	c0de01b0 <app_main+0xbc>
c0de01a6:	f24a 0855 	movw	r8, #41045	@ 0xa055
c0de01aa:	f2c0 0800 	movt	r8, #0
c0de01ae:	44f8      	add	r8, pc
c0de01b0:	4640      	mov	r0, r8
c0de01b2:	f008 f813 	bl	c0de81dc <mcu_usb_printf>
            PRINTF("=> apdu_dispatcher failure\n");
            return;
        }
    }
}
c0de01b6:	b008      	add	sp, #32
c0de01b8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de01bc <handler_get_app_name>:
#include "get_app_name.h"
#include "constants.h"
#include "sw.h"
#include "types.h"

int handler_get_app_name() {
c0de01bc:	b580      	push	{r7, lr}
c0de01be:	b084      	sub	sp, #16
    _Static_assert(APPNAME_LEN < MAX_APPNAME_LEN, "APPNAME must be at most 64 characters!");

    return io_send_response_pointer(PIC(APPNAME), APPNAME_LEN, SWO_SUCCESS);
c0de01c0:	f24a 0061 	movw	r0, #41057	@ 0xa061
c0de01c4:	f2c0 0000 	movt	r0, #0
c0de01c8:	4478      	add	r0, pc
c0de01ca:	f008 fe97 	bl	c0de8efc <pic>
        &(const buffer_t){.ptr = (uint8_t *) ptr, .size = size, .offset = 0}, 1, sw);
c0de01ce:	9001      	str	r0, [sp, #4]
c0de01d0:	2007      	movs	r0, #7
c0de01d2:	9002      	str	r0, [sp, #8]
c0de01d4:	2000      	movs	r0, #0
c0de01d6:	9003      	str	r0, [sp, #12]
c0de01d8:	a801      	add	r0, sp, #4
    return io_send_response_buffers(
c0de01da:	2101      	movs	r1, #1
c0de01dc:	f44f 4210 	mov.w	r2, #36864	@ 0x9000
c0de01e0:	f007 fd04 	bl	c0de7bec <io_send_response_buffers>
c0de01e4:	b004      	add	sp, #16
c0de01e6:	bd80      	pop	{r7, pc}

c0de01e8 <handler_get_version>:
#include "get_version.h"
#include "constants.h"
#include "sw.h"
#include "types.h"

int handler_get_version() {
c0de01e8:	b580      	push	{r7, lr}
c0de01ea:	b084      	sub	sp, #16
c0de01ec:	2002      	movs	r0, #2
c0de01ee:	2101      	movs	r1, #1
                   "MINOR version must be between 0 and 255!");
    _Static_assert(PATCH_VERSION >= 0 && PATCH_VERSION <= UINT8_MAX,
                   "PATCH version must be between 0 and 255!");

    return io_send_response_pointer(
        (const uint8_t *) &(uint8_t[APPVERSION_LEN]){(uint8_t) MAJOR_VERSION,
c0de01f0:	f88d 0001 	strb.w	r0, [sp, #1]
c0de01f4:	2003      	movs	r0, #3
c0de01f6:	f88d 1003 	strb.w	r1, [sp, #3]
c0de01fa:	f10d 0101 	add.w	r1, sp, #1
c0de01fe:	f88d 0002 	strb.w	r0, [sp, #2]
        &(const buffer_t){.ptr = (uint8_t *) ptr, .size = size, .offset = 0}, 1, sw);
c0de0202:	e9cd 1001 	strd	r1, r0, [sp, #4]
c0de0206:	2000      	movs	r0, #0
c0de0208:	9003      	str	r0, [sp, #12]
c0de020a:	a801      	add	r0, sp, #4
    return io_send_response_buffers(
c0de020c:	2101      	movs	r1, #1
c0de020e:	f44f 4210 	mov.w	r2, #36864	@ 0x9000
c0de0212:	f007 fceb 	bl	c0de7bec <io_send_response_buffers>
    return io_send_response_pointer(
c0de0216:	b004      	add	sp, #16
c0de0218:	bd80      	pop	{r7, pc}

c0de021a <ui_menu_main>:

static const nbgl_contentInfoList_t infoList = {.nbInfos = 0,
                                                 .infoTypes = NULL,
                                                 .infoContents = NULL};

void ui_menu_main(void) {
c0de021a:	b580      	push	{r7, lr}
c0de021c:	b084      	sub	sp, #16
    nbgl_useCaseHomeAndSettings(APPNAME,
c0de021e:	f240 0c13 	movw	ip, #19
c0de0222:	f2c0 0c00 	movt	ip, #0
c0de0226:	f24a 616c 	movw	r1, #42604	@ 0xa66c
c0de022a:	f2c0 0100 	movt	r1, #0
c0de022e:	f24a 625e 	movw	r2, #42590	@ 0xa65e
c0de0232:	f2c0 0200 	movt	r2, #0
c0de0236:	2000      	movs	r0, #0
c0de0238:	4479      	add	r1, pc
c0de023a:	447a      	add	r2, pc
c0de023c:	e9cd 2100 	strd	r2, r1, [sp]
c0de0240:	9002      	str	r0, [sp, #8]
c0de0242:	f649 70d5 	movw	r0, #40917	@ 0x9fd5
c0de0246:	f2c0 0000 	movt	r0, #0
c0de024a:	f249 2123 	movw	r1, #37411	@ 0x9223
c0de024e:	f2c0 0100 	movt	r1, #0
c0de0252:	44fc      	add	ip, pc
c0de0254:	4478      	add	r0, pc
c0de0256:	4479      	add	r1, pc
c0de0258:	2200      	movs	r2, #0
c0de025a:	23ff      	movs	r3, #255	@ 0xff
c0de025c:	f8cd c00c 	str.w	ip, [sp, #12]
c0de0260:	f006 f9a8 	bl	c0de65b4 <nbgl_useCaseHomeAndSettings>
                                INIT_HOME_PAGE,
                                &settingContents,
                                &infoList,
                                NULL,
                                app_quit);
}
c0de0264:	b004      	add	sp, #16
c0de0266:	bd80      	pop	{r7, pc}

c0de0268 <app_quit>:
    os_sched_exit(-1);
c0de0268:	20ff      	movs	r0, #255	@ 0xff
c0de026a:	f008 fed5 	bl	c0de9018 <os_sched_exit>

c0de026e <os_io_handle_default_apdu>:
bolos_err_t os_io_handle_default_apdu(uint8_t                  *buffer_in,
                                      size_t                    buffer_in_length,
                                      uint8_t                  *buffer_out,
                                      size_t                   *buffer_out_length,
                                      os_io_apdu_post_action_t *post_action)
{
c0de026e:	b5b0      	push	{r4, r5, r7, lr}
c0de0270:	b09e      	sub	sp, #120	@ 0x78
c0de0272:	9d22      	ldr	r5, [sp, #136]	@ 0x88
    bolos_err_t err = SWO_CONDITIONS_NOT_SATISFIED;

    if (!buffer_in || !buffer_in_length || !buffer_out || !buffer_out_length) {
c0de0274:	2800      	cmp	r0, #0
c0de0276:	bf18      	it	ne
c0de0278:	2900      	cmpne	r1, #0
c0de027a:	d103      	bne.n	c0de0284 <os_io_handle_default_apdu+0x16>
        return *post_action;
c0de027c:	782c      	ldrb	r4, [r5, #0]
        }
    }

end:
    return err;
}
c0de027e:	4620      	mov	r0, r4
c0de0280:	b01e      	add	sp, #120	@ 0x78
c0de0282:	bdb0      	pop	{r4, r5, r7, pc}
    if (!buffer_in || !buffer_in_length || !buffer_out || !buffer_out_length) {
c0de0284:	2a00      	cmp	r2, #0
c0de0286:	d0f9      	beq.n	c0de027c <os_io_handle_default_apdu+0xe>
c0de0288:	2b00      	cmp	r3, #0
c0de028a:	d0f7      	beq.n	c0de027c <os_io_handle_default_apdu+0xe>
    if (post_action) {
c0de028c:	2d00      	cmp	r5, #0
c0de028e:	bf1c      	itt	ne
c0de0290:	2100      	movne	r1, #0
        *post_action = OS_IO_APDU_POST_ACTION_NONE;
c0de0292:	7029      	strbne	r1, [r5, #0]
    if (DEFAULT_APDU_CLA == buffer_in[APDU_OFF_CLA]) {
c0de0294:	7801      	ldrb	r1, [r0, #0]
c0de0296:	29b0      	cmp	r1, #176	@ 0xb0
c0de0298:	d110      	bne.n	c0de02bc <os_io_handle_default_apdu+0x4e>
        switch (buffer_in[APDU_OFF_INS]) {
c0de029a:	7841      	ldrb	r1, [r0, #1]
c0de029c:	29a7      	cmp	r1, #167	@ 0xa7
c0de029e:	d010      	beq.n	c0de02c2 <os_io_handle_default_apdu+0x54>
c0de02a0:	2906      	cmp	r1, #6
c0de02a2:	d015      	beq.n	c0de02d0 <os_io_handle_default_apdu+0x62>
c0de02a4:	2901      	cmp	r1, #1
c0de02a6:	d110      	bne.n	c0de02ca <os_io_handle_default_apdu+0x5c>
                if (!buffer_in[APDU_OFF_P1] && !buffer_in[APDU_OFF_P2]) {
c0de02a8:	7881      	ldrb	r1, [r0, #2]
c0de02aa:	b971      	cbnz	r1, c0de02ca <os_io_handle_default_apdu+0x5c>
c0de02ac:	78c0      	ldrb	r0, [r0, #3]
c0de02ae:	b960      	cbnz	r0, c0de02ca <os_io_handle_default_apdu+0x5c>
                    err = get_version(buffer_out, buffer_out_length);
c0de02b0:	4610      	mov	r0, r2
c0de02b2:	4619      	mov	r1, r3
c0de02b4:	f000 f82c 	bl	c0de0310 <get_version>
c0de02b8:	4604      	mov	r4, r0
c0de02ba:	e7e0      	b.n	c0de027e <os_io_handle_default_apdu+0x10>
c0de02bc:	f646 1485 	movw	r4, #27013	@ 0x6985
c0de02c0:	e7dd      	b.n	c0de027e <os_io_handle_default_apdu+0x10>
                if (!buffer_in[APDU_OFF_P1] && !buffer_in[APDU_OFF_P2]) {
c0de02c2:	7881      	ldrb	r1, [r0, #2]
c0de02c4:	b909      	cbnz	r1, c0de02ca <os_io_handle_default_apdu+0x5c>
c0de02c6:	78c0      	ldrb	r0, [r0, #3]
c0de02c8:	b1c8      	cbz	r0, c0de02fe <os_io_handle_default_apdu+0x90>
c0de02ca:	f44f 44dc 	mov.w	r4, #28160	@ 0x6e00
c0de02ce:	e7d6      	b.n	c0de027e <os_io_handle_default_apdu+0x10>
c0de02d0:	2400      	movs	r4, #0
                *buffer_out_length = 0;
c0de02d2:	601c      	str	r4, [r3, #0]
                    &buffer_in[APDU_OFF_LC + 1], buffer_in[APDU_OFF_LC], buffer_in[APDU_OFF_P1]);
c0de02d4:	7883      	ldrb	r3, [r0, #2]
c0de02d6:	7902      	ldrb	r2, [r0, #4]
c0de02d8:	1d41      	adds	r1, r0, #5
c0de02da:	ad03      	add	r5, sp, #12
    err = os_pki_load_certificate(key_usage, buffer, buffer_len, NULL, NULL, &public_key);
c0de02dc:	4618      	mov	r0, r3
c0de02de:	2300      	movs	r3, #0
c0de02e0:	9400      	str	r4, [sp, #0]
c0de02e2:	9501      	str	r5, [sp, #4]
c0de02e4:	f008 fe43 	bl	c0de8f6e <os_pki_load_certificate>
c0de02e8:	4604      	mov	r4, r0
    if (err == 0) {
c0de02ea:	2800      	cmp	r0, #0
    explicit_bzero(&public_key, sizeof(cx_ecfp_384_public_key_t));
c0de02ec:	4628      	mov	r0, r5
c0de02ee:	f04f 016c 	mov.w	r1, #108	@ 0x6c
    if (err == 0) {
c0de02f2:	bf08      	it	eq
c0de02f4:	f44f 4410 	moveq.w	r4, #36864	@ 0x9000
    explicit_bzero(&public_key, sizeof(cx_ecfp_384_public_key_t));
c0de02f8:	f009 f802 	bl	c0de9300 <explicit_bzero>
c0de02fc:	e7bf      	b.n	c0de027e <os_io_handle_default_apdu+0x10>
c0de02fe:	2000      	movs	r0, #0
                    if (post_action) {
c0de0300:	2d00      	cmp	r5, #0
                    *buffer_out_length = 0;
c0de0302:	6018      	str	r0, [r3, #0]
c0de0304:	bf1c      	itt	ne
c0de0306:	2001      	movne	r0, #1
                        *post_action = OS_IO_APDU_POST_ACTION_EXIT;
c0de0308:	7028      	strbne	r0, [r5, #0]
c0de030a:	f44f 4410 	mov.w	r4, #36864	@ 0x9000
c0de030e:	e7b6      	b.n	c0de027e <os_io_handle_default_apdu+0x10>

c0de0310 <get_version>:
{
c0de0310:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de0312:	b081      	sub	sp, #4
c0de0314:	4604      	mov	r4, r0
    size_t      max_buffer_out_length = *buffer_out_length;
c0de0316:	6808      	ldr	r0, [r1, #0]
c0de0318:	460d      	mov	r5, r1
c0de031a:	2100      	movs	r1, #0
    if (max_buffer_out_length >= 3) {
c0de031c:	2803      	cmp	r0, #3
    *buffer_out_length = 0;
c0de031e:	6029      	str	r1, [r5, #0]
    if (max_buffer_out_length >= 3) {
c0de0320:	d32a      	bcc.n	c0de0378 <get_version+0x68>
c0de0322:	2601      	movs	r6, #1
        buffer_out[(*buffer_out_length)++] = 1;  // format ID
c0de0324:	602e      	str	r6, [r5, #0]
c0de0326:	7026      	strb	r6, [r4, #0]
                                              &buffer_out[(*buffer_out_length) + 1],
c0de0328:	682a      	ldr	r2, [r5, #0]
                                              max_buffer_out_length - *buffer_out_length - 3);
c0de032a:	1ec7      	subs	r7, r0, #3
                                              &buffer_out[(*buffer_out_length) + 1],
c0de032c:	1911      	adds	r1, r2, r4
c0de032e:	3101      	adds	r1, #1
                                              max_buffer_out_length - *buffer_out_length - 3);
c0de0330:	1aba      	subs	r2, r7, r2
            = os_registry_get_current_app_tag(BOLOS_TAG_APPNAME,
c0de0332:	2001      	movs	r0, #1
c0de0334:	f008 fe64 	bl	c0de9000 <os_registry_get_current_app_tag>
        buffer_out[(*buffer_out_length)++] = str_length;
c0de0338:	6829      	ldr	r1, [r5, #0]
c0de033a:	1c4a      	adds	r2, r1, #1
c0de033c:	602a      	str	r2, [r5, #0]
c0de033e:	5460      	strb	r0, [r4, r1]
        *buffer_out_length += str_length;
c0de0340:	6829      	ldr	r1, [r5, #0]
c0de0342:	4408      	add	r0, r1
                                              &buffer_out[(*buffer_out_length) + 1],
c0de0344:	1901      	adds	r1, r0, r4
        *buffer_out_length += str_length;
c0de0346:	6028      	str	r0, [r5, #0]
                                              &buffer_out[(*buffer_out_length) + 1],
c0de0348:	3101      	adds	r1, #1
                                              max_buffer_out_length - *buffer_out_length - 3);
c0de034a:	1a3a      	subs	r2, r7, r0
            = os_registry_get_current_app_tag(BOLOS_TAG_APPVERSION,
c0de034c:	2002      	movs	r0, #2
c0de034e:	f008 fe57 	bl	c0de9000 <os_registry_get_current_app_tag>
        buffer_out[(*buffer_out_length)++] = str_length;
c0de0352:	6829      	ldr	r1, [r5, #0]
c0de0354:	1c4a      	adds	r2, r1, #1
c0de0356:	602a      	str	r2, [r5, #0]
c0de0358:	5460      	strb	r0, [r4, r1]
        *buffer_out_length += str_length;
c0de035a:	6829      	ldr	r1, [r5, #0]
c0de035c:	4408      	add	r0, r1
        buffer_out[(*buffer_out_length)++] = 1;
c0de035e:	1c41      	adds	r1, r0, #1
c0de0360:	6029      	str	r1, [r5, #0]
c0de0362:	5426      	strb	r6, [r4, r0]
        buffer_out[(*buffer_out_length)++] = os_flags();
c0de0364:	f008 fe36 	bl	c0de8fd4 <os_flags>
c0de0368:	6829      	ldr	r1, [r5, #0]
c0de036a:	1c4a      	adds	r2, r1, #1
c0de036c:	602a      	str	r2, [r5, #0]
c0de036e:	5460      	strb	r0, [r4, r1]
c0de0370:	f44f 4010 	mov.w	r0, #36864	@ 0x9000
    return err;
c0de0374:	b001      	add	sp, #4
c0de0376:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de0378:	f646 1085 	movw	r0, #27013	@ 0x6985
c0de037c:	b001      	add	sp, #4
c0de037e:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de0380 <os_io_seph_cmd_printf>:
    }
}
#else   // ! HAVE_PRINTF_CDC
void os_io_seph_cmd_printf(const char *str, uint16_t charcount)
{
    if (charcount) {
c0de0380:	2900      	cmp	r1, #0
        hdr[1] = charcount >> 8;
        hdr[2] = charcount;
        os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, hdr, 3, NULL);
        os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, (const uint8_t *) str, charcount, NULL);
    }
}
c0de0382:	bf08      	it	eq
c0de0384:	4770      	bxeq	lr
c0de0386:	b5b0      	push	{r4, r5, r7, lr}
c0de0388:	b082      	sub	sp, #8
c0de038a:	4605      	mov	r5, r0
c0de038c:	205f      	movs	r0, #95	@ 0x5f
        hdr[0] = SEPROXYHAL_TAG_PRINTF;
c0de038e:	f88d 0005 	strb.w	r0, [sp, #5]
        hdr[1] = charcount >> 8;
c0de0392:	0a08      	lsrs	r0, r1, #8
c0de0394:	460c      	mov	r4, r1
c0de0396:	f88d 0006 	strb.w	r0, [sp, #6]
        hdr[2] = charcount;
c0de039a:	f88d 1007 	strb.w	r1, [sp, #7]
c0de039e:	f10d 0105 	add.w	r1, sp, #5
        os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, hdr, 3, NULL);
c0de03a2:	2001      	movs	r0, #1
c0de03a4:	2203      	movs	r2, #3
c0de03a6:	2300      	movs	r3, #0
c0de03a8:	f008 fe64 	bl	c0de9074 <os_io_tx_cmd>
        os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, (const uint8_t *) str, charcount, NULL);
c0de03ac:	2001      	movs	r0, #1
c0de03ae:	4629      	mov	r1, r5
c0de03b0:	4622      	mov	r2, r4
c0de03b2:	2300      	movs	r3, #0
c0de03b4:	f008 fe5e 	bl	c0de9074 <os_io_tx_cmd>
c0de03b8:	b002      	add	sp, #8
c0de03ba:	e8bd 40b0 	ldmia.w	sp!, {r4, r5, r7, lr}
}
c0de03be:	4770      	bx	lr

c0de03c0 <os_io_seph_cmd_piezo_play_tune>:
    return os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, buffer, 4, NULL);
}
#endif  // HAVE_SE_TOUCH

int os_io_seph_cmd_piezo_play_tune(tune_index_e tune_index)
{
c0de03c0:	b5b0      	push	{r4, r5, r7, lr}
c0de03c2:	b082      	sub	sp, #8
    int status = 0;
#ifdef HAVE_PIEZO_SOUND
    uint8_t buffer[4];
    if (tune_index >= NB_TUNES) {
c0de03c4:	280b      	cmp	r0, #11
c0de03c6:	d902      	bls.n	c0de03ce <os_io_seph_cmd_piezo_play_tune+0xe>
c0de03c8:	f06f 0515 	mvn.w	r5, #21
c0de03cc:	e023      	b.n	c0de0416 <os_io_seph_cmd_piezo_play_tune+0x56>
c0de03ce:	4604      	mov	r4, r0
        status = -22;  // EINVAL
        goto end;
    }

    uint32_t sound_setting = os_setting_get(OS_SETTING_PIEZO_SOUND, NULL, 0);
c0de03d0:	2009      	movs	r0, #9
c0de03d2:	2100      	movs	r1, #0
c0de03d4:	2200      	movs	r2, #0
c0de03d6:	2500      	movs	r5, #0
c0de03d8:	f008 fe06 	bl	c0de8fe8 <os_setting_get>

    if ((!IS_NOTIF_ENABLED(sound_setting)) && (tune_index < TUNE_TAP_CASUAL)) {
c0de03dc:	2c08      	cmp	r4, #8
c0de03de:	d802      	bhi.n	c0de03e6 <os_io_seph_cmd_piezo_play_tune+0x26>
c0de03e0:	f010 0102 	ands.w	r1, r0, #2
c0de03e4:	d117      	bne.n	c0de0416 <os_io_seph_cmd_piezo_play_tune+0x56>
        goto end;
    }
    if ((!IS_TAP_ENABLED(sound_setting)) && (tune_index >= TUNE_TAP_CASUAL)) {
c0de03e6:	2c09      	cmp	r4, #9
c0de03e8:	f04f 0500 	mov.w	r5, #0
c0de03ec:	d302      	bcc.n	c0de03f4 <os_io_seph_cmd_piezo_play_tune+0x34>
c0de03ee:	f010 0001 	ands.w	r0, r0, #1
c0de03f2:	d110      	bne.n	c0de0416 <os_io_seph_cmd_piezo_play_tune+0x56>
c0de03f4:	2056      	movs	r0, #86	@ 0x56
        goto end;
    }

    buffer[0] = SEPROXYHAL_TAG_PLAY_TUNE;
c0de03f6:	f88d 0004 	strb.w	r0, [sp, #4]
c0de03fa:	2001      	movs	r0, #1
    buffer[1] = 0;
    buffer[2] = 1;
c0de03fc:	f88d 0006 	strb.w	r0, [sp, #6]
c0de0400:	a901      	add	r1, sp, #4
    buffer[3] = (uint8_t) tune_index;
    status    = os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, buffer, 4, NULL);
c0de0402:	2001      	movs	r0, #1
c0de0404:	2204      	movs	r2, #4
c0de0406:	2300      	movs	r3, #0
    buffer[1] = 0;
c0de0408:	f88d 5005 	strb.w	r5, [sp, #5]
    buffer[3] = (uint8_t) tune_index;
c0de040c:	f88d 4007 	strb.w	r4, [sp, #7]
    status    = os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, buffer, 4, NULL);
c0de0410:	f008 fe30 	bl	c0de9074 <os_io_tx_cmd>
c0de0414:	4605      	mov	r5, r0
end:
#else
    UNUSED(tune_index);
#endif  // HAVE_PIEZO_SOUND

    return status;
c0de0416:	4628      	mov	r0, r5
c0de0418:	b002      	add	sp, #8
c0de041a:	bdb0      	pop	{r4, r5, r7, pc}

c0de041c <io_process_itc_ux_event>:
    G_ux_os.button_mask              = 0;
    G_ux_os.button_same_mask_counter = 0;
}

int io_process_itc_ux_event(uint8_t *buffer_in, size_t buffer_in_length)
{
c0de041c:	b510      	push	{r4, lr}
    int status = buffer_in_length;

    switch (buffer_in[3]) {
c0de041e:	78c2      	ldrb	r2, [r0, #3]
c0de0420:	2a20      	cmp	r2, #32
c0de0422:	d035      	beq.n	c0de0490 <io_process_itc_ux_event+0x74>
c0de0424:	2a23      	cmp	r2, #35	@ 0x23
c0de0426:	d03b      	beq.n	c0de04a0 <io_process_itc_ux_event+0x84>
c0de0428:	2a22      	cmp	r2, #34	@ 0x22
        default:
            break;
    }

    return status;
}
c0de042a:	bf1c      	itt	ne
c0de042c:	4608      	movne	r0, r1
c0de042e:	bd10      	popne	{r4, pc}
            G_ux_params.ux_id = BOLOS_UX_ASYNCHMODAL_PAIRING_REQUEST;
c0de0430:	f640 1c08 	movw	ip, #2312	@ 0x908
c0de0434:	f2c0 0c00 	movt	ip, #0
c0de0438:	eb09 020c 	add.w	r2, r9, ip
c0de043c:	2318      	movs	r3, #24
c0de043e:	2400      	movs	r4, #0
            G_ux_params.len   = sizeof(G_ux_params.u.pairing_request);
c0de0440:	e9c2 3401 	strd	r3, r4, [r2, #4]
            memset(&G_ux_params.u.pairing_request, 0, sizeof(G_ux_params.u.pairing_request));
c0de0444:	e9c2 4403 	strd	r4, r4, [r2, #12]
c0de0448:	e9c2 4405 	strd	r4, r4, [r2, #20]
c0de044c:	61d4      	str	r4, [r2, #28]
            G_ux_params.u.pairing_request.type = buffer_in[4];
c0de044e:	7903      	ldrb	r3, [r0, #4]
c0de0450:	2406      	movs	r4, #6
c0de0452:	7213      	strb	r3, [r2, #8]
#define U2(hi, lo) ((((hi) &0xFFu) << 8) | ((lo) &0xFFu))
#define U4(hi3, hi2, lo1, lo0) \
    ((((hi3) &0xFFu) << 24) | (((hi2) &0xFFu) << 16) | (((lo1) &0xFFu) << 8) | ((lo0) &0xFFu))
static inline uint16_t U2BE(const uint8_t *buf, size_t off)
{
    return (buf[off] << 8) | buf[off + 1];
c0de0454:	7842      	ldrb	r2, [r0, #1]
c0de0456:	7883      	ldrb	r3, [r0, #2]
            G_ux_params.ux_id = BOLOS_UX_ASYNCHMODAL_PAIRING_REQUEST;
c0de0458:	f809 400c 	strb.w	r4, [r9, ip]
c0de045c:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
                || (pairing_info_len > sizeof(G_ux_params.u.pairing_request.pairing_info))
c0de0460:	f1a2 0313 	sub.w	r3, r2, #19
c0de0464:	b29b      	uxth	r3, r3
c0de0466:	f64f 74f0 	movw	r4, #65520	@ 0xfff0
c0de046a:	42a3      	cmp	r3, r4
c0de046c:	f06f 0315 	mvn.w	r3, #21
c0de0470:	d327      	bcc.n	c0de04c2 <io_process_itc_ux_event+0xa6>
c0de0472:	3a02      	subs	r2, #2
c0de0474:	b292      	uxth	r2, r2
c0de0476:	3905      	subs	r1, #5
c0de0478:	4291      	cmp	r1, r2
c0de047a:	d322      	bcc.n	c0de04c2 <io_process_itc_ux_event+0xa6>
            G_ux_params.u.pairing_request.pairing_info_len = pairing_info_len;
c0de047c:	eb09 040c 	add.w	r4, r9, ip
                   &buffer_in[5],
c0de0480:	1d41      	adds	r1, r0, #5
            memcpy(G_ux_params.u.pairing_request.pairing_info,
c0de0482:	f104 0010 	add.w	r0, r4, #16
            G_ux_params.u.pairing_request.pairing_info_len = pairing_info_len;
c0de0486:	60e2      	str	r2, [r4, #12]
            memcpy(G_ux_params.u.pairing_request.pairing_info,
c0de0488:	f008 ff22 	bl	c0de92d0 <__aeabi_memcpy>
            os_ux(&G_ux_params);
c0de048c:	4620      	mov	r0, r4
c0de048e:	e015      	b.n	c0de04bc <io_process_itc_ux_event+0xa0>
            nbgl_objAllowDrawing(true);
c0de0490:	2001      	movs	r0, #1
c0de0492:	f007 fe1d 	bl	c0de80d0 <nbgl_objAllowDrawing>
            nbgl_screenRedraw();
c0de0496:	f007 fe2a 	bl	c0de80ee <nbgl_screenRedraw>
            nbgl_refresh();
c0de049a:	f007 fe00 	bl	c0de809e <nbgl_refresh>
c0de049e:	e00f      	b.n	c0de04c0 <io_process_itc_ux_event+0xa4>
            G_ux_params.ux_id                       = BOLOS_UX_ASYNCHMODAL_PAIRING_STATUS;
c0de04a0:	f640 1208 	movw	r2, #2312	@ 0x908
c0de04a4:	f2c0 0200 	movt	r2, #0
c0de04a8:	eb09 0102 	add.w	r1, r9, r2
c0de04ac:	2301      	movs	r3, #1
            G_ux_params.len                         = sizeof(G_ux_params.u.pairing_status);
c0de04ae:	604b      	str	r3, [r1, #4]
            G_ux_params.u.pairing_status.pairing_ok = buffer_in[4];
c0de04b0:	7900      	ldrb	r0, [r0, #4]
c0de04b2:	2307      	movs	r3, #7
c0de04b4:	7208      	strb	r0, [r1, #8]
            os_ux(&G_ux_params);
c0de04b6:	4608      	mov	r0, r1
            G_ux_params.ux_id                       = BOLOS_UX_ASYNCHMODAL_PAIRING_STATUS;
c0de04b8:	f809 3002 	strb.w	r3, [r9, r2]
c0de04bc:	f008 fd7d 	bl	c0de8fba <os_ux>
c0de04c0:	2300      	movs	r3, #0
}
c0de04c2:	4618      	mov	r0, r3
c0de04c4:	bd10      	pop	{r4, pc}

c0de04c6 <io_seproxyhal_io_heartbeat>:
{
    os_io_stop();
}

void io_seproxyhal_io_heartbeat(void)
{
c0de04c6:	b570      	push	{r4, r5, r6, lr}
c0de04c8:	b082      	sub	sp, #8
    uint16_t      err = SWO_COMMAND_NOT_ACCEPTED;
    unsigned char err_buffer[2];
    int           status = os_io_rx_evt(G_io_rx_buffer, sizeof(G_io_rx_buffer), NULL, true);
c0de04ca:	f240 1511 	movw	r5, #273	@ 0x111
c0de04ce:	f2c0 0500 	movt	r5, #0
c0de04d2:	eb09 0005 	add.w	r0, r9, r5
c0de04d6:	f240 1111 	movw	r1, #273	@ 0x111
c0de04da:	2200      	movs	r2, #0
c0de04dc:	2301      	movs	r3, #1
c0de04de:	2601      	movs	r6, #1
c0de04e0:	f008 fdd4 	bl	c0de908c <os_io_rx_evt>
c0de04e4:	4604      	mov	r4, r0

    if (os_perso_is_pin_set() == BOLOS_TRUE && os_global_pin_is_validated() != BOLOS_TRUE) {
c0de04e6:	f008 fd52 	bl	c0de8f8e <os_perso_is_pin_set>
c0de04ea:	28aa      	cmp	r0, #170	@ 0xaa
c0de04ec:	d10a      	bne.n	c0de0504 <io_seproxyhal_io_heartbeat+0x3e>
c0de04ee:	f008 fd59 	bl	c0de8fa4 <os_global_pin_is_validated>
c0de04f2:	2615      	movs	r6, #21
c0de04f4:	28aa      	cmp	r0, #170	@ 0xaa
c0de04f6:	f04f 0055 	mov.w	r0, #85	@ 0x55
c0de04fa:	bf08      	it	eq
c0de04fc:	2601      	moveq	r6, #1
c0de04fe:	bf08      	it	eq
c0de0500:	2069      	moveq	r0, #105	@ 0x69
c0de0502:	e000      	b.n	c0de0506 <io_seproxyhal_io_heartbeat+0x40>
c0de0504:	2069      	movs	r0, #105	@ 0x69
    }

    err_buffer[0] = err >> 8;
    err_buffer[1] = err;

    if (status > 0) {
c0de0506:	2c01      	cmp	r4, #1
    err_buffer[0] = err >> 8;
c0de0508:	f88d 0006 	strb.w	r0, [sp, #6]
    err_buffer[1] = err;
c0de050c:	f88d 6007 	strb.w	r6, [sp, #7]
    if (status > 0) {
c0de0510:	db15      	blt.n	c0de053e <io_seproxyhal_io_heartbeat+0x78>
        switch (G_io_rx_buffer[0]) {
c0de0512:	f819 0005 	ldrb.w	r0, [r9, r5]
c0de0516:	282f      	cmp	r0, #47	@ 0x2f
c0de0518:	dc13      	bgt.n	c0de0542 <io_seproxyhal_io_heartbeat+0x7c>
c0de051a:	f1a0 0110 	sub.w	r1, r0, #16
c0de051e:	2913      	cmp	r1, #19
c0de0520:	d814      	bhi.n	c0de054c <io_seproxyhal_io_heartbeat+0x86>
c0de0522:	2201      	movs	r2, #1
c0de0524:	fa02 f101 	lsl.w	r1, r2, r1
c0de0528:	2201      	movs	r2, #1
c0de052a:	f2c0 020f 	movt	r2, #15
c0de052e:	4211      	tst	r1, r2
c0de0530:	d00c      	beq.n	c0de054c <io_seproxyhal_io_heartbeat+0x86>
c0de0532:	f10d 0106 	add.w	r1, sp, #6
            case OS_IO_PACKET_TYPE_USB_CCID_APDU:
            case OS_IO_PACKET_TYPE_USB_WEBUSB_APDU:
            case OS_IO_PACKET_TYPE_USB_U2F_HID_APDU:
            case OS_IO_PACKET_TYPE_BLE_APDU:
            case OS_IO_PACKET_TYPE_NFC_APDU:
                os_io_tx_cmd(G_io_rx_buffer[0], err_buffer, sizeof(err_buffer), 0);
c0de0536:	2202      	movs	r2, #2
c0de0538:	2300      	movs	r3, #0
c0de053a:	f008 fd9b 	bl	c0de9074 <os_io_tx_cmd>

            default:
                break;
        }
    }
}
c0de053e:	b002      	add	sp, #8
c0de0540:	bd70      	pop	{r4, r5, r6, pc}
        switch (G_io_rx_buffer[0]) {
c0de0542:	2830      	cmp	r0, #48	@ 0x30
c0de0544:	d0f5      	beq.n	c0de0532 <io_seproxyhal_io_heartbeat+0x6c>
c0de0546:	2840      	cmp	r0, #64	@ 0x40
c0de0548:	d0f3      	beq.n	c0de0532 <io_seproxyhal_io_heartbeat+0x6c>
c0de054a:	e7f8      	b.n	c0de053e <io_seproxyhal_io_heartbeat+0x78>
c0de054c:	3801      	subs	r0, #1
c0de054e:	2802      	cmp	r0, #2
c0de0550:	d2f5      	bcs.n	c0de053e <io_seproxyhal_io_heartbeat+0x78>
                memcpy(G_io_seproxyhal_spi_buffer, &G_io_rx_buffer[1], status - 1);
c0de0552:	f240 70f4 	movw	r0, #2036	@ 0x7f4
c0de0556:	f2c0 0000 	movt	r0, #0
c0de055a:	eb09 0105 	add.w	r1, r9, r5
c0de055e:	1e62      	subs	r2, r4, #1
c0de0560:	4448      	add	r0, r9
c0de0562:	3101      	adds	r1, #1
c0de0564:	f008 feb4 	bl	c0de92d0 <__aeabi_memcpy>
                io_event(CHANNEL_APDU);
c0de0568:	2000      	movs	r0, #0
c0de056a:	f007 fb06 	bl	c0de7b7a <io_event>
}
c0de056e:	b002      	add	sp, #8
c0de0570:	bd70      	pop	{r4, r5, r6, pc}

c0de0572 <io_legacy_apdu_tx>:

    return status;
}

int io_legacy_apdu_tx(const unsigned char *buffer, unsigned short length)
{
c0de0572:	b5b0      	push	{r4, r5, r7, lr}
    int status = os_io_tx_cmd(io_os_legacy_apdu_type, buffer, length, 0);
c0de0574:	f240 2430 	movw	r4, #560	@ 0x230
c0de0578:	f2c0 0400 	movt	r4, #0
c0de057c:	460a      	mov	r2, r1
c0de057e:	f819 1004 	ldrb.w	r1, [r9, r4]
c0de0582:	4603      	mov	r3, r0
c0de0584:	4608      	mov	r0, r1
c0de0586:	4619      	mov	r1, r3
c0de0588:	2300      	movs	r3, #0
c0de058a:	2500      	movs	r5, #0
c0de058c:	f008 fd72 	bl	c0de9074 <os_io_tx_cmd>

    G_io_app.apdu_media    = IO_APDU_MEDIA_NONE;
c0de0590:	f240 2124 	movw	r1, #548	@ 0x224
c0de0594:	f2c0 0100 	movt	r1, #0
c0de0598:	4449      	add	r1, r9
c0de059a:	718d      	strb	r5, [r1, #6]
    io_os_legacy_apdu_type = APDU_TYPE_NONE;
#ifdef HAVE_IO_U2F
    G_io_u2f.media = U2F_MEDIA_NONE;
c0de059c:	f640 1128 	movw	r1, #2344	@ 0x928
c0de05a0:	f2c0 0100 	movt	r1, #0
    io_os_legacy_apdu_type = APDU_TYPE_NONE;
c0de05a4:	f809 5004 	strb.w	r5, [r9, r4]
    G_io_u2f.media = U2F_MEDIA_NONE;
c0de05a8:	f809 5001 	strb.w	r5, [r9, r1]
#endif  // HAVE_IO_U2F

    return status;
c0de05ac:	bdb0      	pop	{r4, r5, r7, pc}

c0de05ae <io_legacy_apdu_rx>:
{
c0de05ae:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
c0de05b2:	b084      	sub	sp, #16
    status = os_io_rx_evt(G_io_rx_buffer, sizeof(G_io_rx_buffer), NULL, true);
c0de05b4:	f240 1711 	movw	r7, #273	@ 0x111
c0de05b8:	4606      	mov	r6, r0
c0de05ba:	2000      	movs	r0, #0
c0de05bc:	f2c0 0700 	movt	r7, #0
    os_io_apdu_post_action_t post_action = OS_IO_APDU_POST_ACTION_NONE;
c0de05c0:	f88d 000f 	strb.w	r0, [sp, #15]
    status = os_io_rx_evt(G_io_rx_buffer, sizeof(G_io_rx_buffer), NULL, true);
c0de05c4:	eb09 0007 	add.w	r0, r9, r7
c0de05c8:	f240 1111 	movw	r1, #273	@ 0x111
c0de05cc:	2200      	movs	r2, #0
c0de05ce:	2301      	movs	r3, #1
c0de05d0:	f008 fd5c 	bl	c0de908c <os_io_rx_evt>
c0de05d4:	4604      	mov	r4, r0
    if (status > 0) {
c0de05d6:	2801      	cmp	r0, #1
c0de05d8:	f2c0 8106 	blt.w	c0de07e8 <io_legacy_apdu_rx+0x23a>
        switch (G_io_rx_buffer[0]) {
c0de05dc:	f819 0007 	ldrb.w	r0, [r9, r7]
c0de05e0:	2500      	movs	r5, #0
c0de05e2:	282f      	cmp	r0, #47	@ 0x2f
c0de05e4:	dc5d      	bgt.n	c0de06a2 <io_legacy_apdu_rx+0xf4>
c0de05e6:	f1a0 0110 	sub.w	r1, r0, #16
c0de05ea:	2916      	cmp	r1, #22
c0de05ec:	d86c      	bhi.n	c0de06c8 <io_legacy_apdu_rx+0x11a>
c0de05ee:	2201      	movs	r2, #1
c0de05f0:	fa02 f101 	lsl.w	r1, r2, r1
c0de05f4:	2201      	movs	r2, #1
c0de05f6:	f2c0 027f 	movt	r2, #127	@ 0x7f
c0de05fa:	4211      	tst	r1, r2
c0de05fc:	d064      	beq.n	c0de06c8 <io_legacy_apdu_rx+0x11a>
                io_os_legacy_apdu_type = G_io_rx_buffer[0];
c0de05fe:	f240 2530 	movw	r5, #560	@ 0x230
c0de0602:	f2c0 0500 	movt	r5, #0
c0de0606:	f809 0005 	strb.w	r0, [r9, r5]
                if (os_perso_is_pin_set() == BOLOS_TRUE
c0de060a:	f008 fcc0 	bl	c0de8f8e <os_perso_is_pin_set>
                    && os_global_pin_is_validated() != BOLOS_TRUE) {
c0de060e:	28aa      	cmp	r0, #170	@ 0xaa
c0de0610:	d103      	bne.n	c0de061a <io_legacy_apdu_rx+0x6c>
c0de0612:	f008 fcc7 	bl	c0de8fa4 <os_global_pin_is_validated>
                if (os_perso_is_pin_set() == BOLOS_TRUE
c0de0616:	28aa      	cmp	r0, #170	@ 0xaa
c0de0618:	d170      	bne.n	c0de06fc <io_legacy_apdu_rx+0x14e>
                else if (G_io_rx_buffer[APDU_OFF_CLA + 1] == DEFAULT_APDU_CLA) {
c0de061a:	eb09 0007 	add.w	r0, r9, r7
c0de061e:	7840      	ldrb	r0, [r0, #1]
c0de0620:	28b0      	cmp	r0, #176	@ 0xb0
c0de0622:	d132      	bne.n	c0de068a <io_legacy_apdu_rx+0xdc>
c0de0624:	f240 1011 	movw	r0, #273	@ 0x111
                                                                status - 1,
c0de0628:	1e61      	subs	r1, r4, #1
                    bolos_err_t err               = os_io_handle_default_apdu(&G_io_rx_buffer[1],
c0de062a:	f240 0400 	movw	r4, #0
                    size_t      buffer_out_length = sizeof(G_io_rx_buffer);
c0de062e:	9002      	str	r0, [sp, #8]
                    bolos_err_t err               = os_io_handle_default_apdu(&G_io_rx_buffer[1],
c0de0630:	f2c0 0400 	movt	r4, #0
c0de0634:	eb09 0007 	add.w	r0, r9, r7
c0de0638:	f10d 060f 	add.w	r6, sp, #15
c0de063c:	eb09 0204 	add.w	r2, r9, r4
c0de0640:	3001      	adds	r0, #1
c0de0642:	ab02      	add	r3, sp, #8
c0de0644:	9600      	str	r6, [sp, #0]
c0de0646:	f7ff fe12 	bl	c0de026e <os_io_handle_default_apdu>
                    if (err != SWO_SUCCESS) {
c0de064a:	f5b0 4f10 	cmp.w	r0, #36864	@ 0x9000
c0de064e:	bf1c      	itt	ne
c0de0650:	2100      	movne	r1, #0
                        buffer_out_length = 0;
c0de0652:	9102      	strne	r1, [sp, #8]
                    G_io_tx_buffer[buffer_out_length++] = err >> 8;
c0de0654:	9b02      	ldr	r3, [sp, #8]
c0de0656:	0a02      	lsrs	r2, r0, #8
c0de0658:	eb09 0104 	add.w	r1, r9, r4
c0de065c:	18cf      	adds	r7, r1, r3
c0de065e:	54ca      	strb	r2, [r1, r3]
                    G_io_tx_buffer[buffer_out_length++] = err;
c0de0660:	1c9a      	adds	r2, r3, #2
                        io_os_legacy_apdu_type, G_io_tx_buffer, buffer_out_length, 0);
c0de0662:	f819 3005 	ldrb.w	r3, [r9, r5]
                    G_io_tx_buffer[buffer_out_length++] = err;
c0de0666:	9202      	str	r2, [sp, #8]
c0de0668:	7078      	strb	r0, [r7, #1]
                    status                              = os_io_tx_cmd(
c0de066a:	b292      	uxth	r2, r2
c0de066c:	4618      	mov	r0, r3
c0de066e:	2300      	movs	r3, #0
c0de0670:	2400      	movs	r4, #0
c0de0672:	f008 fcff 	bl	c0de9074 <os_io_tx_cmd>
                    if (post_action == OS_IO_APDU_POST_ACTION_EXIT) {
c0de0676:	f89d 100f 	ldrb.w	r1, [sp, #15]
                    io_os_legacy_apdu_type = APDU_TYPE_NONE;
c0de067a:	f809 4005 	strb.w	r4, [r9, r5]
                    if (post_action == OS_IO_APDU_POST_ACTION_EXIT) {
c0de067e:	2901      	cmp	r1, #1
c0de0680:	f000 80d2 	beq.w	c0de0828 <io_legacy_apdu_rx+0x27a>
                    if (status > 0) {
c0de0684:	ea00 75e0 	and.w	r5, r0, r0, asr #31
c0de0688:	e0af      	b.n	c0de07ea <io_legacy_apdu_rx+0x23c>
                    G_io_app.apdu_media = get_media_from_apdu_type(io_os_legacy_apdu_type);
c0de068a:	f819 6005 	ldrb.w	r6, [r9, r5]
    if (apdu_type == APDU_TYPE_RAW) {
c0de068e:	2e21      	cmp	r6, #33	@ 0x21
c0de0690:	dd47      	ble.n	c0de0722 <io_legacy_apdu_rx+0x174>
c0de0692:	2e2f      	cmp	r6, #47	@ 0x2f
c0de0694:	dc4d      	bgt.n	c0de0732 <io_legacy_apdu_rx+0x184>
c0de0696:	2e22      	cmp	r6, #34	@ 0x22
c0de0698:	d058      	beq.n	c0de074c <io_legacy_apdu_rx+0x19e>
c0de069a:	2e23      	cmp	r6, #35	@ 0x23
c0de069c:	d15c      	bne.n	c0de0758 <io_legacy_apdu_rx+0x1aa>
c0de069e:	2007      	movs	r0, #7
c0de06a0:	e05d      	b.n	c0de075e <io_legacy_apdu_rx+0x1b0>
        switch (G_io_rx_buffer[0]) {
c0de06a2:	2830      	cmp	r0, #48	@ 0x30
c0de06a4:	d0ab      	beq.n	c0de05fe <io_legacy_apdu_rx+0x50>
c0de06a6:	2840      	cmp	r0, #64	@ 0x40
c0de06a8:	d0a9      	beq.n	c0de05fe <io_legacy_apdu_rx+0x50>
c0de06aa:	2842      	cmp	r0, #66	@ 0x42
c0de06ac:	f040 809d 	bne.w	c0de07ea <io_legacy_apdu_rx+0x23c>
                memmove(G_io_apdu_buffer, &G_io_rx_buffer[1], status);
c0de06b0:	f240 0000 	movw	r0, #0
c0de06b4:	f2c0 0000 	movt	r0, #0
c0de06b8:	eb09 0107 	add.w	r1, r9, r7
c0de06bc:	4448      	add	r0, r9
c0de06be:	3101      	adds	r1, #1
c0de06c0:	4622      	mov	r2, r4
c0de06c2:	f008 fe05 	bl	c0de92d0 <__aeabi_memcpy>
c0de06c6:	e08f      	b.n	c0de07e8 <io_legacy_apdu_rx+0x23a>
        switch (G_io_rx_buffer[0]) {
c0de06c8:	3801      	subs	r0, #1
c0de06ca:	2802      	cmp	r0, #2
c0de06cc:	f080 808d 	bcs.w	c0de07ea <io_legacy_apdu_rx+0x23c>
                memcpy(G_io_seproxyhal_spi_buffer, &G_io_rx_buffer[1], status - 1);
c0de06d0:	f240 75f4 	movw	r5, #2036	@ 0x7f4
c0de06d4:	3c01      	subs	r4, #1
c0de06d6:	f2c0 0500 	movt	r5, #0
c0de06da:	444f      	add	r7, r9
c0de06dc:	eb09 0005 	add.w	r0, r9, r5
c0de06e0:	1c79      	adds	r1, r7, #1
c0de06e2:	4622      	mov	r2, r4
c0de06e4:	f008 fdf4 	bl	c0de92d0 <__aeabi_memcpy>
                if (G_io_rx_buffer[1] == SEPROXYHAL_TAG_ITC_EVENT) {
c0de06e8:	7878      	ldrb	r0, [r7, #1]
c0de06ea:	281a      	cmp	r0, #26
c0de06ec:	d127      	bne.n	c0de073e <io_legacy_apdu_rx+0x190>
                    status = io_process_itc_ux_event(G_io_seproxyhal_spi_buffer, status - 1);
c0de06ee:	eb09 0005 	add.w	r0, r9, r5
c0de06f2:	4621      	mov	r1, r4
c0de06f4:	f7ff fe92 	bl	c0de041c <io_process_itc_ux_event>
c0de06f8:	4605      	mov	r5, r0
c0de06fa:	e076      	b.n	c0de07ea <io_legacy_apdu_rx+0x23c>
                    G_io_tx_buffer[0] = err >> 8;
c0de06fc:	f240 0000 	movw	r0, #0
c0de0700:	f2c0 0000 	movt	r0, #0
c0de0704:	2155      	movs	r1, #85	@ 0x55
c0de0706:	f809 1000 	strb.w	r1, [r9, r0]
c0de070a:	eb09 0100 	add.w	r1, r9, r0
c0de070e:	2215      	movs	r2, #21
                    status            = os_io_tx_cmd(io_os_legacy_apdu_type, G_io_tx_buffer, 2, 0);
c0de0710:	f819 0005 	ldrb.w	r0, [r9, r5]
                    G_io_tx_buffer[1] = err;
c0de0714:	704a      	strb	r2, [r1, #1]
                    status            = os_io_tx_cmd(io_os_legacy_apdu_type, G_io_tx_buffer, 2, 0);
c0de0716:	2202      	movs	r2, #2
c0de0718:	2300      	movs	r3, #0
c0de071a:	f008 fcab 	bl	c0de9074 <os_io_tx_cmd>
c0de071e:	4605      	mov	r5, r0
c0de0720:	e063      	b.n	c0de07ea <io_legacy_apdu_rx+0x23c>
    if (apdu_type == APDU_TYPE_RAW) {
c0de0722:	2e10      	cmp	r6, #16
c0de0724:	d014      	beq.n	c0de0750 <io_legacy_apdu_rx+0x1a2>
c0de0726:	2e20      	cmp	r6, #32
c0de0728:	d018      	beq.n	c0de075c <io_legacy_apdu_rx+0x1ae>
c0de072a:	2e21      	cmp	r6, #33	@ 0x21
c0de072c:	d114      	bne.n	c0de0758 <io_legacy_apdu_rx+0x1aa>
c0de072e:	2005      	movs	r0, #5
c0de0730:	e015      	b.n	c0de075e <io_legacy_apdu_rx+0x1b0>
c0de0732:	2e30      	cmp	r6, #48	@ 0x30
c0de0734:	d00e      	beq.n	c0de0754 <io_legacy_apdu_rx+0x1a6>
c0de0736:	2e40      	cmp	r6, #64	@ 0x40
c0de0738:	d10e      	bne.n	c0de0758 <io_legacy_apdu_rx+0x1aa>
c0de073a:	2003      	movs	r0, #3
c0de073c:	e00f      	b.n	c0de075e <io_legacy_apdu_rx+0x1b0>
                    if (!handle_ux_events) {
c0de073e:	2e00      	cmp	r6, #0
c0de0740:	d062      	beq.n	c0de0808 <io_legacy_apdu_rx+0x25a>
c0de0742:	2000      	movs	r0, #0
c0de0744:	2500      	movs	r5, #0
c0de0746:	f007 fa18 	bl	c0de7b7a <io_event>
c0de074a:	e04e      	b.n	c0de07ea <io_legacy_apdu_rx+0x23c>
c0de074c:	2004      	movs	r0, #4
c0de074e:	e006      	b.n	c0de075e <io_legacy_apdu_rx+0x1b0>
c0de0750:	2006      	movs	r0, #6
c0de0752:	e004      	b.n	c0de075e <io_legacy_apdu_rx+0x1b0>
c0de0754:	2002      	movs	r0, #2
c0de0756:	e002      	b.n	c0de075e <io_legacy_apdu_rx+0x1b0>
c0de0758:	2000      	movs	r0, #0
c0de075a:	e000      	b.n	c0de075e <io_legacy_apdu_rx+0x1b0>
c0de075c:	2001      	movs	r0, #1
                    G_io_app.apdu_media = get_media_from_apdu_type(io_os_legacy_apdu_type);
c0de075e:	f240 2824 	movw	r8, #548	@ 0x224
c0de0762:	f2c0 0800 	movt	r8, #0
c0de0766:	eb09 0108 	add.w	r1, r9, r8
c0de076a:	7188      	strb	r0, [r1, #6]
                    memmove(G_io_apdu_buffer, &G_io_rx_buffer[1], status);
c0de076c:	f240 0000 	movw	r0, #0
                    status -= 1;
c0de0770:	1e65      	subs	r5, r4, #1
                    memmove(G_io_apdu_buffer, &G_io_rx_buffer[1], status);
c0de0772:	f2c0 0000 	movt	r0, #0
c0de0776:	eb09 0107 	add.w	r1, r9, r7
c0de077a:	4448      	add	r0, r9
c0de077c:	3101      	adds	r1, #1
c0de077e:	462a      	mov	r2, r5
c0de0780:	f008 fda6 	bl	c0de92d0 <__aeabi_memcpy>
                    if (io_os_legacy_apdu_type == APDU_TYPE_USB_HID) {
c0de0784:	2e23      	cmp	r6, #35	@ 0x23
c0de0786:	dd0b      	ble.n	c0de07a0 <io_legacy_apdu_rx+0x1f2>
c0de0788:	2e24      	cmp	r6, #36	@ 0x24
c0de078a:	d018      	beq.n	c0de07be <io_legacy_apdu_rx+0x210>
c0de078c:	2e25      	cmp	r6, #37	@ 0x25
c0de078e:	d021      	beq.n	c0de07d4 <io_legacy_apdu_rx+0x226>
c0de0790:	2e40      	cmp	r6, #64	@ 0x40
c0de0792:	d12a      	bne.n	c0de07ea <io_legacy_apdu_rx+0x23c>
                        G_io_u2f.media      = U2F_MEDIA_NFC;
c0de0794:	f640 1028 	movw	r0, #2344	@ 0x928
c0de0798:	f2c0 0000 	movt	r0, #0
c0de079c:	2102      	movs	r1, #2
c0de079e:	e008      	b.n	c0de07b2 <io_legacy_apdu_rx+0x204>
                    if (io_os_legacy_apdu_type == APDU_TYPE_USB_HID) {
c0de07a0:	2e20      	cmp	r6, #32
c0de07a2:	d026      	beq.n	c0de07f2 <io_legacy_apdu_rx+0x244>
c0de07a4:	2e23      	cmp	r6, #35	@ 0x23
c0de07a6:	d120      	bne.n	c0de07ea <io_legacy_apdu_rx+0x23c>
                        G_io_u2f.media      = U2F_MEDIA_USB;
c0de07a8:	f640 1028 	movw	r0, #2344	@ 0x928
c0de07ac:	f2c0 0000 	movt	r0, #0
c0de07b0:	2101      	movs	r1, #1
c0de07b2:	f809 1000 	strb.w	r1, [r9, r0]
c0de07b6:	200a      	movs	r0, #10
c0de07b8:	f809 0008 	strb.w	r0, [r9, r8]
c0de07bc:	e015      	b.n	c0de07ea <io_legacy_apdu_rx+0x23c>
                        G_io_u2f.media      = U2F_MEDIA_USB;
c0de07be:	f640 1028 	movw	r0, #2344	@ 0x928
c0de07c2:	f2c0 0000 	movt	r0, #0
c0de07c6:	2101      	movs	r1, #1
c0de07c8:	f809 1000 	strb.w	r1, [r9, r0]
c0de07cc:	200b      	movs	r0, #11
                        G_io_app.apdu_state = APDU_U2F_CBOR;
c0de07ce:	f809 0008 	strb.w	r0, [r9, r8]
c0de07d2:	e00a      	b.n	c0de07ea <io_legacy_apdu_rx+0x23c>
                        G_io_u2f.media      = U2F_MEDIA_USB;
c0de07d4:	f640 1028 	movw	r0, #2344	@ 0x928
c0de07d8:	f2c0 0000 	movt	r0, #0
c0de07dc:	2101      	movs	r1, #1
c0de07de:	f809 1000 	strb.w	r1, [r9, r0]
c0de07e2:	200c      	movs	r0, #12
                        G_io_app.apdu_state = APDU_U2F_CANCEL;
c0de07e4:	f809 0008 	strb.w	r0, [r9, r8]
c0de07e8:	4625      	mov	r5, r4
    return status;
c0de07ea:	4628      	mov	r0, r5
c0de07ec:	b004      	add	sp, #16
c0de07ee:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
                        G_io_u2f.media      = U2F_MEDIA_USB;
c0de07f2:	f640 1028 	movw	r0, #2344	@ 0x928
c0de07f6:	f2c0 0000 	movt	r0, #0
c0de07fa:	2101      	movs	r1, #1
c0de07fc:	f809 1000 	strb.w	r1, [r9, r0]
c0de0800:	2008      	movs	r0, #8
                        G_io_app.apdu_state = APDU_USB_HID;
c0de0802:	f809 0008 	strb.w	r0, [r9, r8]
c0de0806:	e7f0      	b.n	c0de07ea <io_legacy_apdu_rx+0x23c>
                        if ((G_io_seproxyhal_spi_buffer[0] != SEPROXYHAL_TAG_FINGER_EVENT)
c0de0808:	f819 0005 	ldrb.w	r0, [r9, r5]
                            && (G_io_seproxyhal_spi_buffer[0] != SEPROXYHAL_TAG_BUTTON_PUSH_EVENT)
c0de080c:	2815      	cmp	r0, #21
c0de080e:	d898      	bhi.n	c0de0742 <io_legacy_apdu_rx+0x194>
c0de0810:	2101      	movs	r1, #1
c0de0812:	fa01 f000 	lsl.w	r0, r1, r0
c0de0816:	f245 0120 	movw	r1, #20512	@ 0x5020
c0de081a:	f2c0 0120 	movt	r1, #32
c0de081e:	4208      	tst	r0, r1
c0de0820:	f43f af8f 	beq.w	c0de0742 <io_legacy_apdu_rx+0x194>
c0de0824:	2500      	movs	r5, #0
c0de0826:	e7e0      	b.n	c0de07ea <io_legacy_apdu_rx+0x23c>
                        os_sched_exit(-1);
c0de0828:	20ff      	movs	r0, #255	@ 0xff
c0de082a:	f008 fbf5 	bl	c0de9018 <os_sched_exit>

c0de082e <io_seproxyhal_init>:
{
c0de082e:	b510      	push	{r4, lr}
c0de0830:	b08a      	sub	sp, #40	@ 0x28
    io_os_legacy_apdu_type = APDU_TYPE_NONE;
c0de0832:	f240 2030 	movw	r0, #560	@ 0x230
c0de0836:	f2c0 0000 	movt	r0, #0
c0de083a:	2100      	movs	r1, #0
c0de083c:	f809 1000 	strb.w	r1, [r9, r0]
c0de0840:	2015      	movs	r0, #21
c0de0842:	f2c0 0002 	movt	r0, #2
    init_io.usb.class_mask |= USBD_LEDGER_CLASS_HID_U2F;
c0de0846:	9007      	str	r0, [sp, #28]
c0de0848:	2401      	movs	r4, #1
c0de084a:	a801      	add	r0, sp, #4
    init_io.usb.vid        = 0;
c0de084c:	e9cd 1101 	strd	r1, r1, [sp, #4]
c0de0850:	e9cd 1103 	strd	r1, r1, [sp, #12]
c0de0854:	e9cd 1105 	strd	r1, r1, [sp, #20]
    init_io.usb.hid_u2f_settings.minor_device_version_number = 1;
c0de0858:	f8ad 4020 	strh.w	r4, [sp, #32]
    init_io.usb.hid_u2f_settings.capabilities_flag = 0;
c0de085c:	f88d 1022 	strb.w	r1, [sp, #34]	@ 0x22
    init_io.ble.profile_mask = BLE_LEDGER_PROFILE_APDU;
c0de0860:	f8ad 4024 	strh.w	r4, [sp, #36]	@ 0x24
    os_io_init(&init_io);
c0de0864:	f008 fbe3 	bl	c0de902e <os_io_init>
    need_to_start_io = 1;
c0de0868:	f240 2022 	movw	r0, #546	@ 0x222
c0de086c:	f2c0 0000 	movt	r0, #0
c0de0870:	f809 4000 	strb.w	r4, [r9, r0]
}
c0de0874:	b00a      	add	sp, #40	@ 0x28
c0de0876:	bd10      	pop	{r4, pc}

c0de0878 <layoutAddCallbackObj>:
// configuring it
layoutObj_t *layoutAddCallbackObj(nbgl_layoutInternal_t *layout,
                                  nbgl_obj_t            *obj,
                                  uint8_t                token,
                                  tune_index_e           tuneId)
{
c0de0878:	b510      	push	{r4, lr}
    layoutObj_t *layoutObj = NULL;

    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de087a:	f890 c0ad 	ldrb.w	ip, [r0, #173]	@ 0xad
c0de087e:	f890 e0ae 	ldrb.w	lr, [r0, #174]	@ 0xae
c0de0882:	ea4c 2e0e 	orr.w	lr, ip, lr, lsl #8
c0de0886:	f3ce 2c05 	ubfx	ip, lr, #8, #6
c0de088a:	f1bc 0f0e 	cmp.w	ip, #14
c0de088e:	bf84      	itt	hi
c0de0890:	2000      	movhi	r0, #0
    }
    else {
        LOG_FATAL(LAYOUT_LOGGER, "layoutAddCallbackObj: no more callback obj\n");
    }

    return layoutObj;
c0de0892:	bd10      	pophi	{r4, pc}
c0de0894:	ea4f 241e 	mov.w	r4, lr, lsr #8
        layoutObj = &layout->callbackObjPool[layout->nbUsedCallbackObjs];
c0de0898:	eb00 0ccc 	add.w	ip, r0, ip, lsl #3
        layoutObj->obj    = obj;
c0de089c:	f84c 1f20 	str.w	r1, [ip, #32]!
        layout->nbUsedCallbackObjs++;
c0de08a0:	1c61      	adds	r1, r4, #1
c0de08a2:	f001 013f 	and.w	r1, r1, #63	@ 0x3f
c0de08a6:	f40e 4440 	and.w	r4, lr, #49152	@ 0xc000
c0de08aa:	ea44 2101 	orr.w	r1, r4, r1, lsl #8
c0de08ae:	0a09      	lsrs	r1, r1, #8
c0de08b0:	f880 10ae 	strb.w	r1, [r0, #174]	@ 0xae
c0de08b4:	f880 e0ad 	strb.w	lr, [r0, #173]	@ 0xad
    return layoutObj;
c0de08b8:	4660      	mov	r0, ip
        layoutObj->token  = token;
c0de08ba:	f88c 2004 	strb.w	r2, [ip, #4]
        layoutObj->tuneId = tuneId;
c0de08be:	f88c 3006 	strb.w	r3, [ip, #6]
    return layoutObj;
c0de08c2:	bd10      	pop	{r4, pc}

c0de08c4 <nbgl_layoutGet>:
 *
 * @param description description of layout
 * @return a pointer to the corresponding layout
 */
nbgl_layout_t *nbgl_layoutGet(const nbgl_layoutDescription_t *description)
{
c0de08c4:	e92d 45f0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, lr}
c0de08c8:	b085      	sub	sp, #20
c0de08ca:	4605      	mov	r5, r0
    nbgl_layoutInternal_t *layout = NULL;

    if (description->modal) {
c0de08cc:	7800      	ldrb	r0, [r0, #0]
c0de08ce:	f240 2634 	movw	r6, #564	@ 0x234
c0de08d2:	f2c0 0600 	movt	r6, #0
c0de08d6:	b320      	cbz	r0, c0de0922 <nbgl_layoutGet+0x5e>
c0de08d8:	f64f 6098 	movw	r0, #65176	@ 0xfe98
c0de08dc:	2400      	movs	r4, #0
c0de08de:	f6cf 70ff 	movt	r0, #65535	@ 0xffff
c0de08e2:	bf00      	nop
        int i;
        // find an empty layout in the array of layouts (0 is reserved for background)
        for (i = 1; i < NB_MAX_LAYOUTS; i++) {
            if (!gLayout[i].isUsed) {
c0de08e4:	eb09 0106 	add.w	r1, r9, r6
c0de08e8:	4401      	add	r1, r0
c0de08ea:	f891 22ca 	ldrb.w	r2, [r1, #714]	@ 0x2ca
c0de08ee:	0212      	lsls	r2, r2, #8
c0de08f0:	0452      	lsls	r2, r2, #17
c0de08f2:	bf58      	it	pl
c0de08f4:	f501 7407 	addpl.w	r4, r1, #540	@ 0x21c
        for (i = 1; i < NB_MAX_LAYOUTS; i++) {
c0de08f8:	30b4      	adds	r0, #180	@ 0xb4
c0de08fa:	d1f3      	bne.n	c0de08e4 <nbgl_layoutGet+0x20>
        layout = &gLayout[0];
        if (topLayout == NULL) {
            topLayout = layout;
        }
    }
    if (layout == NULL) {
c0de08fc:	b1fc      	cbz	r4, c0de093e <nbgl_layoutGet+0x7a>
        LOG_WARN(LAYOUT_LOGGER, "nbgl_layoutGet(): impossible to get a layout!\n");
        return NULL;
    }

    // reset globals
    nbgl_layoutInternal_t *backgroundTop = gLayout[0].top;
c0de08fe:	f859 7006 	ldr.w	r7, [r9, r6]
    memset(layout, 0, sizeof(nbgl_layoutInternal_t));
c0de0902:	4620      	mov	r0, r4
c0de0904:	21b4      	movs	r1, #180	@ 0xb4
c0de0906:	f008 fced 	bl	c0de92e4 <__aeabi_memclr>
    // link layout to other ones
    if (description->modal) {
c0de090a:	7828      	ldrb	r0, [r5, #0]
c0de090c:	b1c8      	cbz	r0, c0de0942 <nbgl_layoutGet+0x7e>
        if (topLayout != NULL) {
c0de090e:	f240 4050 	movw	r0, #1104	@ 0x450
c0de0912:	f2c0 0000 	movt	r0, #0
c0de0916:	f859 1000 	ldr.w	r1, [r9, r0]
c0de091a:	b1a9      	cbz	r1, c0de0948 <nbgl_layoutGet+0x84>
            // if topLayout already existing, push this new one on top of it
            topLayout->top = layout;
c0de091c:	600c      	str	r4, [r1, #0]
            layout->bottom = topLayout;
c0de091e:	6061      	str	r1, [r4, #4]
c0de0920:	e017      	b.n	c0de0952 <nbgl_layoutGet+0x8e>
        if (topLayout == NULL) {
c0de0922:	f240 4050 	movw	r0, #1104	@ 0x450
c0de0926:	f2c0 0000 	movt	r0, #0
c0de092a:	f859 1000 	ldr.w	r1, [r9, r0]
            topLayout = layout;
c0de092e:	eb09 0406 	add.w	r4, r9, r6
        if (topLayout == NULL) {
c0de0932:	2900      	cmp	r1, #0
            topLayout = layout;
c0de0934:	bf08      	it	eq
c0de0936:	f849 4000 	streq.w	r4, [r9, r0]
    if (layout == NULL) {
c0de093a:	2c00      	cmp	r4, #0
c0de093c:	d1df      	bne.n	c0de08fe <nbgl_layoutGet+0x3a>
c0de093e:	2400      	movs	r4, #0
c0de0940:	e0b2      	b.n	c0de0aa8 <nbgl_layoutGet+0x1e4>
        }
        topLayout = layout;
    }
    else {
        // restore potentially valid background top layer
        gLayout[0].top = backgroundTop;
c0de0942:	f849 7006 	str.w	r7, [r9, r6]
c0de0946:	e006      	b.n	c0de0956 <nbgl_layoutGet+0x92>
            layout->bottom = &gLayout[0];
c0de0948:	eb09 0106 	add.w	r1, r9, r6
c0de094c:	6061      	str	r1, [r4, #4]
            gLayout[0].top = layout;
c0de094e:	f849 4006 	str.w	r4, [r9, r6]
        topLayout = layout;
c0de0952:	f849 4000 	str.w	r4, [r9, r0]
    }

    nbTouchableControls = 0;
c0de0956:	f240 4154 	movw	r1, #1108	@ 0x454

    layout->callback       = (nbgl_layoutTouchCallback_t) PIC(description->onActionCallback);
c0de095a:	68e8      	ldr	r0, [r5, #12]
    nbTouchableControls = 0;
c0de095c:	f2c0 0100 	movt	r1, #0
c0de0960:	2200      	movs	r2, #0
c0de0962:	f809 2001 	strb.w	r2, [r9, r1]
    layout->callback       = (nbgl_layoutTouchCallback_t) PIC(description->onActionCallback);
c0de0966:	f008 fac9 	bl	c0de8efc <pic>
    layout->modal          = description->modal;
c0de096a:	4621      	mov	r1, r4
c0de096c:	f811 2fad 	ldrb.w	r2, [r1, #173]!
    layout->callback       = (nbgl_layoutTouchCallback_t) PIC(description->onActionCallback);
c0de0970:	f841 0c91 	str.w	r0, [r1, #-145]
    layout->modal          = description->modal;
c0de0974:	7848      	ldrb	r0, [r1, #1]
c0de0976:	782b      	ldrb	r3, [r5, #0]
c0de0978:	ea42 2200 	orr.w	r2, r2, r0, lsl #8
c0de097c:	f022 0201 	bic.w	r2, r2, #1
c0de0980:	431a      	orrs	r2, r3
c0de0982:	700a      	strb	r2, [r1, #0]
    layout->withLeftBorder = description->withLeftBorder;
c0de0984:	786b      	ldrb	r3, [r5, #1]
c0de0986:	f002 02fd 	and.w	r2, r2, #253	@ 0xfd
c0de098a:	ea42 0243 	orr.w	r2, r2, r3, lsl #1
c0de098e:	7048      	strb	r0, [r1, #1]
c0de0990:	700a      	strb	r2, [r1, #0]
    if (description->modal) {
c0de0992:	782a      	ldrb	r2, [r5, #0]
                                        NB_MAX_SCREEN_CHILDREN,
                                        &description->ticker,
                                        (nbgl_touchCallback_t) touchCallback);
    }
    else {
        nbgl_screenSet(&layout->children,
c0de0994:	f240 1307 	movw	r3, #263	@ 0x107
c0de0998:	f2c0 0300 	movt	r3, #0
c0de099c:	f1a1 00a5 	sub.w	r0, r1, #165	@ 0xa5
    if (description->modal) {
c0de09a0:	2a00      	cmp	r2, #0
c0de09a2:	f105 0210 	add.w	r2, r5, #16
        nbgl_screenSet(&layout->children,
c0de09a6:	447b      	add	r3, pc
c0de09a8:	f04f 0106 	mov.w	r1, #6
    if (description->modal) {
c0de09ac:	d00a      	beq.n	c0de09c4 <nbgl_layoutGet+0x100>
        layout->layer = nbgl_screenPush(&layout->children,
c0de09ae:	f007 fb99 	bl	c0de80e4 <nbgl_screenPush>
c0de09b2:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de09b6:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de09ba:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de09be:	f360 01c7 	bfi	r1, r0, #3, #5
c0de09c2:	e009      	b.n	c0de09d8 <nbgl_layoutGet+0x114>
        nbgl_screenSet(&layout->children,
c0de09c4:	f007 fb89 	bl	c0de80da <nbgl_screenSet>
                       NB_MAX_SCREEN_CHILDREN,
                       &description->ticker,
                       (nbgl_touchCallback_t) touchCallback);
        layout->layer = 0;
c0de09c8:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de09cc:	f894 10ae 	ldrb.w	r1, [r4, #174]	@ 0xae
c0de09d0:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de09d4:	f020 01f8 	bic.w	r1, r0, #248	@ 0xf8
c0de09d8:	4627      	mov	r7, r4
c0de09da:	f807 1fad 	strb.w	r1, [r7, #173]!
c0de09de:	0a08      	lsrs	r0, r1, #8
c0de09e0:	7078      	strb	r0, [r7, #1]
    }
    layout->container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layout->layer);
c0de09e2:	b2c8      	uxtb	r0, r1
c0de09e4:	08c1      	lsrs	r1, r0, #3
c0de09e6:	2001      	movs	r0, #1
c0de09e8:	f04f 0a01 	mov.w	sl, #1
c0de09ec:	f007 fb93 	bl	c0de8116 <nbgl_objPoolGet>
c0de09f0:	21e0      	movs	r1, #224	@ 0xe0
c0de09f2:	f847 0c0d 	str.w	r0, [r7, #-13]
    layout->container->obj.area.width  = SCREEN_WIDTH;
c0de09f6:	7101      	strb	r1, [r0, #4]
c0de09f8:	2102      	movs	r1, #2
    layout->container->obj.area.height = SCREEN_HEIGHT;
c0de09fa:	71c1      	strb	r1, [r0, #7]
c0de09fc:	2158      	movs	r1, #88	@ 0x58
c0de09fe:	f04f 0800 	mov.w	r8, #0
    layout->container->obj.area.width  = SCREEN_WIDTH;
c0de0a02:	f880 a005 	strb.w	sl, [r0, #5]
    layout->container->obj.area.height = SCREEN_HEIGHT;
c0de0a06:	7181      	strb	r1, [r0, #6]
    layout->container->layout          = VERTICAL;
c0de0a08:	f880 801f 	strb.w	r8, [r0, #31]
    layout->container->children = nbgl_containerPoolGet(NB_MAX_CONTAINER_CHILDREN, layout->layer);
c0de0a0c:	7838      	ldrb	r0, [r7, #0]
c0de0a0e:	08c1      	lsrs	r1, r0, #3
c0de0a10:	2014      	movs	r0, #20
c0de0a12:	f007 fb85 	bl	c0de8120 <nbgl_containerPoolGet>
c0de0a16:	f857 2c0d 	ldr.w	r2, [r7, #-13]
c0de0a1a:	0a03      	lsrs	r3, r0, #8
    // by default, if no header, main container is aligned on top-left
    layout->container->obj.alignment = TOP_LEFT;
    // main container is always the second object, leaving space for header
    layout->children[MAIN_CONTAINER_INDEX] = (nbgl_obj_t *) layout->container;
c0de0a1c:	f857 1ca5 	ldr.w	r1, [r7, #-165]
    layout->container->children = nbgl_containerPoolGet(NB_MAX_CONTAINER_CHILDREN, layout->layer);
c0de0a20:	f882 3023 	strb.w	r3, [r2, #35]	@ 0x23
c0de0a24:	4613      	mov	r3, r2
c0de0a26:	f803 0f22 	strb.w	r0, [r3, #34]!
c0de0a2a:	0e06      	lsrs	r6, r0, #24
c0de0a2c:	0c00      	lsrs	r0, r0, #16
c0de0a2e:	70de      	strb	r6, [r3, #3]
c0de0a30:	7098      	strb	r0, [r3, #2]
    layout->container->obj.alignment = TOP_LEFT;
c0de0a32:	f882 a016 	strb.w	sl, [r2, #22]
    layout->children[MAIN_CONTAINER_INDEX] = (nbgl_obj_t *) layout->container;
c0de0a36:	604a      	str	r2, [r1, #4]
    layout->isUsed                         = true;
c0de0a38:	7878      	ldrb	r0, [r7, #1]
c0de0a3a:	f040 0040 	orr.w	r0, r0, #64	@ 0x40
c0de0a3e:	7078      	strb	r0, [r7, #1]

    // if a tap text is defined, make the container tapable and display this text in gray
    if (description->tapActionText != NULL) {
c0de0a40:	6868      	ldr	r0, [r5, #4]
c0de0a42:	b388      	cbz	r0, c0de0aa8 <nbgl_layoutGet+0x1e4>
        layoutObj_t *obj;
        const char  *tapActionText = PIC(description->tapActionText);
c0de0a44:	f008 fa5a 	bl	c0de8efc <pic>

        obj = &layout->callbackObjPool[layout->nbUsedCallbackObjs];
c0de0a48:	4621      	mov	r1, r4
c0de0a4a:	f811 2fad 	ldrb.w	r2, [r1, #173]!
c0de0a4e:	f44f 4740 	mov.w	r7, #49152	@ 0xc000
c0de0a52:	784b      	ldrb	r3, [r1, #1]
        layout->nbUsedCallbackObjs++;
c0de0a54:	700a      	strb	r2, [r1, #0]
c0de0a56:	1c5e      	adds	r6, r3, #1
        obj = &layout->callbackObjPool[layout->nbUsedCallbackObjs];
c0de0a58:	f003 0c3f 	and.w	ip, r3, #63	@ 0x3f
        layout->nbUsedCallbackObjs++;
c0de0a5c:	f006 063f 	and.w	r6, r6, #63	@ 0x3f
c0de0a60:	ea07 2303 	and.w	r3, r7, r3, lsl #8
c0de0a64:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de0a68:	0a1b      	lsrs	r3, r3, #8
        obj->obj                         = (nbgl_obj_t *) layout->container;
c0de0a6a:	f8d4 70a0 	ldr.w	r7, [r4, #160]	@ 0xa0
        layout->nbUsedCallbackObjs++;
c0de0a6e:	704b      	strb	r3, [r1, #1]
        obj->obj                         = (nbgl_obj_t *) layout->container;
c0de0a70:	eb04 03cc 	add.w	r3, r4, ip, lsl #3
c0de0a74:	621f      	str	r7, [r3, #32]
        obj->token                       = description->tapActionToken;
c0de0a76:	7a29      	ldrb	r1, [r5, #8]
        obj->tuneId                      = description->tapTuneId;
c0de0a78:	7a6a      	ldrb	r2, [r5, #9]
        obj->token                       = description->tapActionToken;
c0de0a7a:	f883 1024 	strb.w	r1, [r3, #36]	@ 0x24
        obj->tuneId                      = description->tapTuneId;
c0de0a7e:	f883 2026 	strb.w	r2, [r3, #38]	@ 0x26
c0de0a82:	2304      	movs	r3, #4
        layout->container->obj.touchMask = (1 << TOUCHED);
c0de0a84:	f887 a01c 	strb.w	sl, [r7, #28]
c0de0a88:	f887 801d 	strb.w	r8, [r7, #29]
        layout->container->obj.touchId   = WHOLE_SCREEN_ID;
c0de0a8c:	77bb      	strb	r3, [r7, #30]

        if (strlen(tapActionText) > 0) {
c0de0a8e:	7807      	ldrb	r7, [r0, #0]
c0de0a90:	b157      	cbz	r7, c0de0aa8 <nbgl_layoutGet+0x1e4>
            nbgl_layoutUpFooter_t footerDesc;
            footerDesc.type        = UP_FOOTER_TEXT;
            footerDesc.text.text   = tapActionText;
c0de0a92:	9001      	str	r0, [sp, #4]
            footerDesc.text.token  = description->tapActionToken;
c0de0a94:	f88d 1008 	strb.w	r1, [sp, #8]
c0de0a98:	4669      	mov	r1, sp
            footerDesc.text.tuneId = description->tapTuneId;
            nbgl_layoutAddUpFooter((nbgl_layout_t *) layout, &footerDesc);
c0de0a9a:	4620      	mov	r0, r4
            footerDesc.type        = UP_FOOTER_TEXT;
c0de0a9c:	f88d 3000 	strb.w	r3, [sp]
            footerDesc.text.tuneId = description->tapTuneId;
c0de0aa0:	f88d 2009 	strb.w	r2, [sp, #9]
            nbgl_layoutAddUpFooter((nbgl_layout_t *) layout, &footerDesc);
c0de0aa4:	f000 fa4c 	bl	c0de0f40 <nbgl_layoutAddUpFooter>
        }
    }
    return (nbgl_layout_t *) layout;
}
c0de0aa8:	4620      	mov	r0, r4
c0de0aaa:	b005      	add	sp, #20
c0de0aac:	e8bd 85f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, pc}

c0de0ab0 <touchCallback>:
{
c0de0ab0:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
    if (obj == NULL) {
c0de0ab4:	2800      	cmp	r0, #0
c0de0ab6:	f000 8241 	beq.w	c0de0f3c <touchCallback+0x48c>
c0de0aba:	4604      	mov	r4, r0
    if ((topLayout) && (topLayout->isUsed)) {
c0de0abc:	f240 4050 	movw	r0, #1104	@ 0x450
c0de0ac0:	f2c0 0000 	movt	r0, #0
c0de0ac4:	f859 0000 	ldr.w	r0, [r9, r0]
c0de0ac8:	468a      	mov	sl, r1
c0de0aca:	b308      	cbz	r0, c0de0b10 <touchCallback+0x60>
c0de0acc:	f890 10ad 	ldrb.w	r1, [r0, #173]	@ 0xad
c0de0ad0:	f890 20ae 	ldrb.w	r2, [r0, #174]	@ 0xae
c0de0ad4:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de0ad8:	044a      	lsls	r2, r1, #17
c0de0ada:	d519      	bpl.n	c0de0b10 <touchCallback+0x60>
c0de0adc:	f3c1 2205 	ubfx	r2, r1, #8, #6
        for (j = 0; j < topLayout->nbUsedCallbackObjs; j++) {
c0de0ae0:	2a00      	cmp	r2, #0
c0de0ae2:	4613      	mov	r3, r2
c0de0ae4:	bf18      	it	ne
c0de0ae6:	2301      	movne	r3, #1
c0de0ae8:	b192      	cbz	r2, c0de0b10 <touchCallback+0x60>
            if (obj == topLayout->callbackObjPool[j].obj) {
c0de0aea:	6a01      	ldr	r1, [r0, #32]
c0de0aec:	42a1      	cmp	r1, r4
c0de0aee:	d064      	beq.n	c0de0bba <touchCallback+0x10a>
        for (j = 0; j < topLayout->nbUsedCallbackObjs; j++) {
c0de0af0:	1e53      	subs	r3, r2, #1
c0de0af2:	f100 0728 	add.w	r7, r0, #40	@ 0x28
c0de0af6:	2100      	movs	r1, #0
c0de0af8:	428b      	cmp	r3, r1
c0de0afa:	d009      	beq.n	c0de0b10 <touchCallback+0x60>
            if (obj == topLayout->callbackObjPool[j].obj) {
c0de0afc:	f857 6031 	ldr.w	r6, [r7, r1, lsl #3]
c0de0b00:	3101      	adds	r1, #1
c0de0b02:	42a6      	cmp	r6, r4
c0de0b04:	d1f8      	bne.n	c0de0af8 <touchCallback+0x48>
c0de0b06:	2300      	movs	r3, #0
c0de0b08:	4291      	cmp	r1, r2
c0de0b0a:	bf38      	it	cc
c0de0b0c:	2301      	movcc	r3, #1
c0de0b0e:	e055      	b.n	c0de0bbc <touchCallback+0x10c>
c0de0b10:	2700      	movs	r7, #0
c0de0b12:	2100      	movs	r1, #0
    if (getLayoutAndLayoutObj(obj, &layout, &layoutObj) == false) {
c0de0b14:	bba1      	cbnz	r1, c0de0b80 <touchCallback+0xd0>
    if ((topLayout) && (topLayout->isUsed)) {
c0de0b16:	b368      	cbz	r0, c0de0b74 <touchCallback+0xc4>
c0de0b18:	f890 10ad 	ldrb.w	r1, [r0, #173]	@ 0xad
c0de0b1c:	f890 20ae 	ldrb.w	r2, [r0, #174]	@ 0xae
c0de0b20:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de0b24:	044a      	lsls	r2, r1, #17
c0de0b26:	d525      	bpl.n	c0de0b74 <touchCallback+0xc4>
c0de0b28:	f3c1 2105 	ubfx	r1, r1, #8, #6
        for (j = 0; j < topLayout->nbUsedCallbackObjs; j++) {
c0de0b2c:	2900      	cmp	r1, #0
c0de0b2e:	460a      	mov	r2, r1
c0de0b30:	bf18      	it	ne
c0de0b32:	2201      	movne	r2, #1
c0de0b34:	d01e      	beq.n	c0de0b74 <touchCallback+0xc4>
c0de0b36:	4623      	mov	r3, r4
c0de0b38:	f813 7f0e 	ldrb.w	r7, [r3, #14]!
c0de0b3c:	785e      	ldrb	r6, [r3, #1]
c0de0b3e:	789d      	ldrb	r5, [r3, #2]
c0de0b40:	78db      	ldrb	r3, [r3, #3]
c0de0b42:	ea47 2706 	orr.w	r7, r7, r6, lsl #8
c0de0b46:	ea45 2303 	orr.w	r3, r5, r3, lsl #8
            if (obj == topLayout->callbackObjPool[j].obj) {
c0de0b4a:	6a06      	ldr	r6, [r0, #32]
c0de0b4c:	ea47 4703 	orr.w	r7, r7, r3, lsl #16
c0de0b50:	42be      	cmp	r6, r7
c0de0b52:	d03f      	beq.n	c0de0bd4 <touchCallback+0x124>
        for (j = 0; j < topLayout->nbUsedCallbackObjs; j++) {
c0de0b54:	1e4a      	subs	r2, r1, #1
c0de0b56:	f100 0628 	add.w	r6, r0, #40	@ 0x28
c0de0b5a:	2300      	movs	r3, #0
c0de0b5c:	429a      	cmp	r2, r3
c0de0b5e:	d009      	beq.n	c0de0b74 <touchCallback+0xc4>
            if (obj == topLayout->callbackObjPool[j].obj) {
c0de0b60:	f856 5033 	ldr.w	r5, [r6, r3, lsl #3]
c0de0b64:	3301      	adds	r3, #1
c0de0b66:	42bd      	cmp	r5, r7
c0de0b68:	d1f8      	bne.n	c0de0b5c <touchCallback+0xac>
c0de0b6a:	2200      	movs	r2, #0
c0de0b6c:	428b      	cmp	r3, r1
c0de0b6e:	bf38      	it	cc
c0de0b70:	2201      	movcc	r2, #1
c0de0b72:	e030      	b.n	c0de0bd6 <touchCallback+0x126>
c0de0b74:	2000      	movs	r0, #0
c0de0b76:	2100      	movs	r1, #0
        if (getLayoutAndLayoutObj(obj->parent, &layout, &layoutObj) == false) {
c0de0b78:	2900      	cmp	r1, #0
c0de0b7a:	4607      	mov	r7, r0
c0de0b7c:	f000 81de 	beq.w	c0de0f3c <touchCallback+0x48c>
    if (((eventType == SWIPED_UP) || (eventType == SWIPED_DOWN) || (eventType == SWIPED_LEFT)
c0de0b80:	f1aa 0007 	sub.w	r0, sl, #7
c0de0b84:	b2c0      	uxtb	r0, r0
c0de0b86:	2803      	cmp	r0, #3
c0de0b88:	d849      	bhi.n	c0de0c1e <touchCallback+0x16e>
        && (obj->type == CONTAINER)) {
c0de0b8a:	7ee0      	ldrb	r0, [r4, #27]
    if (((eventType == SWIPED_UP) || (eventType == SWIPED_DOWN) || (eventType == SWIPED_LEFT)
c0de0b8c:	2801      	cmp	r0, #1
c0de0b8e:	d146      	bne.n	c0de0c1e <touchCallback+0x16e>
        if (layout->swipeUsage == SWIPE_USAGE_CUSTOM) {
c0de0b90:	f897 10b0 	ldrb.w	r1, [r7, #176]	@ 0xb0
c0de0b94:	4650      	mov	r0, sl
c0de0b96:	2901      	cmp	r1, #1
c0de0b98:	d03f      	beq.n	c0de0c1a <touchCallback+0x16a>
c0de0b9a:	2900      	cmp	r1, #0
c0de0b9c:	d13f      	bne.n	c0de0c1e <touchCallback+0x16e>
                 && ((nbgl_obj_t *) layout->container == obj)) {
c0de0b9e:	f8d7 00a0 	ldr.w	r0, [r7, #160]	@ 0xa0
        else if ((layout->swipeUsage == SWIPE_USAGE_NAVIGATION)
c0de0ba2:	42a0      	cmp	r0, r4
c0de0ba4:	d13b      	bne.n	c0de0c1e <touchCallback+0x16e>
            if (layout->footerType == FOOTER_NAV) {
c0de0ba6:	f897 00ab 	ldrb.w	r0, [r7, #171]	@ 0xab
c0de0baa:	2803      	cmp	r0, #3
c0de0bac:	d01b      	beq.n	c0de0be6 <touchCallback+0x136>
c0de0bae:	2804      	cmp	r0, #4
c0de0bb0:	f040 81c4 	bne.w	c0de0f3c <touchCallback+0x48c>
                navContainer = (nbgl_container_t *) layout->footerContainer;
c0de0bb4:	f107 0010 	add.w	r0, r7, #16
c0de0bb8:	e022      	b.n	c0de0c00 <touchCallback+0x150>
c0de0bba:	2100      	movs	r1, #0
                *layoutObj = &(topLayout->callbackObjPool[j]);
c0de0bbc:	eb00 01c1 	add.w	r1, r0, r1, lsl #3
c0de0bc0:	f101 0820 	add.w	r8, r1, #32
c0de0bc4:	b123      	cbz	r3, c0de0bd0 <touchCallback+0x120>
c0de0bc6:	2101      	movs	r1, #1
c0de0bc8:	4607      	mov	r7, r0
    if (getLayoutAndLayoutObj(obj, &layout, &layoutObj) == false) {
c0de0bca:	2900      	cmp	r1, #0
c0de0bcc:	d0a3      	beq.n	c0de0b16 <touchCallback+0x66>
c0de0bce:	e7d7      	b.n	c0de0b80 <touchCallback+0xd0>
c0de0bd0:	4607      	mov	r7, r0
c0de0bd2:	e79e      	b.n	c0de0b12 <touchCallback+0x62>
c0de0bd4:	2300      	movs	r3, #0
                *layoutObj = &(topLayout->callbackObjPool[j]);
c0de0bd6:	eb00 01c3 	add.w	r1, r0, r3, lsl #3
c0de0bda:	2a00      	cmp	r2, #0
c0de0bdc:	f101 0820 	add.w	r8, r1, #32
c0de0be0:	d0c9      	beq.n	c0de0b76 <touchCallback+0xc6>
c0de0be2:	2101      	movs	r1, #1
c0de0be4:	e7c8      	b.n	c0de0b78 <touchCallback+0xc8>
                navContainer = (nbgl_container_t *) layout->footerContainer->children[1];
c0de0be6:	6938      	ldr	r0, [r7, #16]
c0de0be8:	f810 1f22 	ldrb.w	r1, [r0, #34]!
c0de0bec:	7842      	ldrb	r2, [r0, #1]
c0de0bee:	7883      	ldrb	r3, [r0, #2]
c0de0bf0:	78c0      	ldrb	r0, [r0, #3]
c0de0bf2:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de0bf6:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de0bfa:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de0bfe:	3004      	adds	r0, #4
c0de0c00:	6800      	ldr	r0, [r0, #0]
                    (nbgl_obj_t *) navContainer, eventType, layout->nbPages, &layout->activePage)
c0de0c02:	f897 20a8 	ldrb.w	r2, [r7, #168]	@ 0xa8
c0de0c06:	f107 06a9 	add.w	r6, r7, #169	@ 0xa9
            if (layoutNavigationCallback(
c0de0c0a:	4651      	mov	r1, sl
c0de0c0c:	4633      	mov	r3, r6
c0de0c0e:	f003 fffb 	bl	c0de4c08 <layoutNavigationCallback>
c0de0c12:	2800      	cmp	r0, #0
c0de0c14:	f000 8192 	beq.w	c0de0f3c <touchCallback+0x48c>
            layoutObj->index = layout->activePage;
c0de0c18:	7830      	ldrb	r0, [r6, #0]
c0de0c1a:	f888 0005 	strb.w	r0, [r8, #5]
    if (((obj->parent == (nbgl_obj_t *) layout->footerContainer)
c0de0c1e:	4620      	mov	r0, r4
c0de0c20:	f810 1f0e 	ldrb.w	r1, [r0, #14]!
c0de0c24:	7842      	ldrb	r2, [r0, #1]
c0de0c26:	7883      	ldrb	r3, [r0, #2]
c0de0c28:	78c0      	ldrb	r0, [r0, #3]
c0de0c2a:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de0c2e:	ea43 2200 	orr.w	r2, r3, r0, lsl #8
c0de0c32:	6938      	ldr	r0, [r7, #16]
c0de0c34:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
         && (layout->footerType == FOOTER_NAV))
c0de0c38:	4281      	cmp	r1, r0
c0de0c3a:	d103      	bne.n	c0de0c44 <touchCallback+0x194>
c0de0c3c:	f897 20ab 	ldrb.w	r2, [r7, #171]	@ 0xab
        || ((obj->parent->type == CONTAINER)
c0de0c40:	2a04      	cmp	r2, #4
c0de0c42:	d013      	beq.n	c0de0c6c <touchCallback+0x1bc>
c0de0c44:	7eca      	ldrb	r2, [r1, #27]
            && (obj->parent->parent == (nbgl_obj_t *) layout->footerContainer)
c0de0c46:	2a01      	cmp	r2, #1
c0de0c48:	d11f      	bne.n	c0de0c8a <touchCallback+0x1da>
c0de0c4a:	f811 2f0e 	ldrb.w	r2, [r1, #14]!
c0de0c4e:	784b      	ldrb	r3, [r1, #1]
c0de0c50:	788e      	ldrb	r6, [r1, #2]
c0de0c52:	78c9      	ldrb	r1, [r1, #3]
c0de0c54:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de0c58:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de0c5c:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
            && (layout->footerType == FOOTER_TEXT_AND_NAV))) {
c0de0c60:	4281      	cmp	r1, r0
c0de0c62:	d112      	bne.n	c0de0c8a <touchCallback+0x1da>
c0de0c64:	f897 00ab 	ldrb.w	r0, [r7, #171]	@ 0xab
    if (((obj->parent == (nbgl_obj_t *) layout->footerContainer)
c0de0c68:	2803      	cmp	r0, #3
c0de0c6a:	d10e      	bne.n	c0de0c8a <touchCallback+0x1da>
        if (layoutNavigationCallback(obj, eventType, layout->nbPages, &layout->activePage)
c0de0c6c:	f897 20a8 	ldrb.w	r2, [r7, #168]	@ 0xa8
c0de0c70:	f107 06a9 	add.w	r6, r7, #169	@ 0xa9
c0de0c74:	4620      	mov	r0, r4
c0de0c76:	4651      	mov	r1, sl
c0de0c78:	4633      	mov	r3, r6
c0de0c7a:	f003 ffc5 	bl	c0de4c08 <layoutNavigationCallback>
c0de0c7e:	2800      	cmp	r0, #0
c0de0c80:	f000 815c 	beq.w	c0de0f3c <touchCallback+0x48c>
        layoutObj->index = layout->activePage;
c0de0c84:	7830      	ldrb	r0, [r6, #0]
c0de0c86:	f888 0005 	strb.w	r0, [r8, #5]
    if ((obj->type == CONTAINER) && (((nbgl_container_t *) obj)->nbChildren >= 2)
c0de0c8a:	7ee0      	ldrb	r0, [r4, #27]
c0de0c8c:	2801      	cmp	r0, #1
c0de0c8e:	f040 8091 	bne.w	c0de0db4 <touchCallback+0x304>
c0de0c92:	f894 1020 	ldrb.w	r1, [r4, #32]
        && (((nbgl_container_t *) obj)->children[1] != NULL)
c0de0c96:	2902      	cmp	r1, #2
c0de0c98:	d320      	bcc.n	c0de0cdc <touchCallback+0x22c>
c0de0c9a:	4621      	mov	r1, r4
c0de0c9c:	f811 2f22 	ldrb.w	r2, [r1, #34]!
c0de0ca0:	784b      	ldrb	r3, [r1, #1]
c0de0ca2:	788e      	ldrb	r6, [r1, #2]
c0de0ca4:	78c9      	ldrb	r1, [r1, #3]
c0de0ca6:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de0caa:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de0cae:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de0cb2:	684e      	ldr	r6, [r1, #4]
        && (((nbgl_container_t *) obj)->children[1]->type == SWITCH)) {
c0de0cb4:	b196      	cbz	r6, c0de0cdc <touchCallback+0x22c>
c0de0cb6:	7ef1      	ldrb	r1, [r6, #27]
    if ((obj->type == CONTAINER) && (((nbgl_container_t *) obj)->nbChildren >= 2)
c0de0cb8:	2906      	cmp	r1, #6
c0de0cba:	d10f      	bne.n	c0de0cdc <touchCallback+0x22c>
        lSwitch->state         = (lSwitch->state == ON_STATE) ? OFF_STATE : ON_STATE;
c0de0cbc:	f896 0021 	ldrb.w	r0, [r6, #33]	@ 0x21
c0de0cc0:	3801      	subs	r0, #1
c0de0cc2:	bf18      	it	ne
c0de0cc4:	2001      	movne	r0, #1
c0de0cc6:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
        nbgl_objDraw((nbgl_obj_t *) lSwitch);
c0de0cca:	4630      	mov	r0, r6
c0de0ccc:	f007 f9fb 	bl	c0de80c6 <nbgl_objDraw>
        layoutObj->index = lSwitch->state;
c0de0cd0:	f896 0021 	ldrb.w	r0, [r6, #33]	@ 0x21
c0de0cd4:	2401      	movs	r4, #1
c0de0cd6:	f888 0005 	strb.w	r0, [r8, #5]
c0de0cda:	e06c      	b.n	c0de0db6 <touchCallback+0x306>
    else if ((obj->type == CONTAINER) && (((nbgl_container_t *) obj)->nbChildren == 2)
c0de0cdc:	2801      	cmp	r0, #1
c0de0cde:	d169      	bne.n	c0de0db4 <touchCallback+0x304>
c0de0ce0:	f894 1020 	ldrb.w	r1, [r4, #32]
             && (((nbgl_container_t *) obj)->children[1] != NULL)
c0de0ce4:	2902      	cmp	r1, #2
c0de0ce6:	d122      	bne.n	c0de0d2e <touchCallback+0x27e>
c0de0ce8:	4621      	mov	r1, r4
c0de0cea:	f811 2f22 	ldrb.w	r2, [r1, #34]!
c0de0cee:	784b      	ldrb	r3, [r1, #1]
c0de0cf0:	788e      	ldrb	r6, [r1, #2]
c0de0cf2:	78c9      	ldrb	r1, [r1, #3]
c0de0cf4:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de0cf8:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de0cfc:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de0d00:	6849      	ldr	r1, [r1, #4]
             && (((nbgl_container_t *) obj)->children[1]->type == RADIO_BUTTON)) {
c0de0d02:	b1a1      	cbz	r1, c0de0d2e <touchCallback+0x27e>
c0de0d04:	7ec9      	ldrb	r1, [r1, #27]
    else if ((obj->type == CONTAINER) && (((nbgl_container_t *) obj)->nbChildren == 2)
c0de0d06:	2909      	cmp	r1, #9
c0de0d08:	d111      	bne.n	c0de0d2e <touchCallback+0x27e>
    if (eventType != TOUCHED) {
c0de0d0a:	f1ba 0f00 	cmp.w	sl, #0
c0de0d0e:	f040 8115 	bne.w	c0de0f3c <touchCallback+0x48c>
    while (i < layout->nbUsedCallbackObjs) {
c0de0d12:	f897 00ae 	ldrb.w	r0, [r7, #174]	@ 0xae
c0de0d16:	f44f 517c 	mov.w	r1, #16128	@ 0x3f00
c0de0d1a:	f04f 0aff 	mov.w	sl, #255	@ 0xff
c0de0d1e:	ea11 2f00 	tst.w	r1, r0, lsl #8
c0de0d22:	f000 80b9 	beq.w	c0de0e98 <touchCallback+0x3e8>
c0de0d26:	f04f 0b00 	mov.w	fp, #0
c0de0d2a:	2500      	movs	r5, #0
c0de0d2c:	e082      	b.n	c0de0e34 <touchCallback+0x384>
    else if ((obj->type == CONTAINER) && (((nbgl_container_t *) obj)->nbChildren == 4)
c0de0d2e:	2801      	cmp	r0, #1
c0de0d30:	d140      	bne.n	c0de0db4 <touchCallback+0x304>
c0de0d32:	f894 0020 	ldrb.w	r0, [r4, #32]
             && (((nbgl_container_t *) obj)->children[3] != NULL)
c0de0d36:	2804      	cmp	r0, #4
c0de0d38:	d13c      	bne.n	c0de0db4 <touchCallback+0x304>
c0de0d3a:	4620      	mov	r0, r4
c0de0d3c:	f810 1f22 	ldrb.w	r1, [r0, #34]!
c0de0d40:	7842      	ldrb	r2, [r0, #1]
c0de0d42:	7883      	ldrb	r3, [r0, #2]
c0de0d44:	78c0      	ldrb	r0, [r0, #3]
c0de0d46:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de0d4a:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de0d4e:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de0d52:	68c6      	ldr	r6, [r0, #12]
             && (((nbgl_container_t *) obj)->children[3]->type == PROGRESS_BAR)) {
c0de0d54:	b376      	cbz	r6, c0de0db4 <touchCallback+0x304>
c0de0d56:	7ef0      	ldrb	r0, [r6, #27]
    else if ((obj->type == CONTAINER) && (((nbgl_container_t *) obj)->nbChildren == 4)
c0de0d58:	2808      	cmp	r0, #8
c0de0d5a:	d12b      	bne.n	c0de0db4 <touchCallback+0x304>
    if (eventType == TOUCHING) {
c0de0d5c:	f1ba 0f0a 	cmp.w	sl, #10
c0de0d60:	f200 80ec 	bhi.w	c0de0f3c <touchCallback+0x48c>
c0de0d64:	2001      	movs	r0, #1
c0de0d66:	fa00 f00a 	lsl.w	r0, r0, sl
c0de0d6a:	f410 6fc5 	tst.w	r0, #1576	@ 0x628
c0de0d6e:	f000 80ad 	beq.w	c0de0ecc <touchCallback+0x41c>
        nbgl_wait_pipeline();
c0de0d72:	f008 f8f0 	bl	c0de8f56 <nbgl_wait_pipeline>
        progressBar->partialRedraw = true;
c0de0d76:	f896 0022 	ldrb.w	r0, [r6, #34]	@ 0x22
c0de0d7a:	f040 0001 	orr.w	r0, r0, #1
c0de0d7e:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
c0de0d82:	2000      	movs	r0, #0
        progressBar->state         = 0;
c0de0d84:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
        nbgl_objDraw((nbgl_obj_t *) progressBar);
c0de0d88:	4630      	mov	r0, r6
c0de0d8a:	f007 f99c 	bl	c0de80c6 <nbgl_objDraw>
        nbgl_line_t *line = (nbgl_line_t *) container->children[2];
c0de0d8e:	f814 0f22 	ldrb.w	r0, [r4, #34]!
c0de0d92:	7861      	ldrb	r1, [r4, #1]
c0de0d94:	78a2      	ldrb	r2, [r4, #2]
c0de0d96:	78e3      	ldrb	r3, [r4, #3]
c0de0d98:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de0d9c:	ea42 2103 	orr.w	r1, r2, r3, lsl #8
c0de0da0:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de0da4:	6880      	ldr	r0, [r0, #8]
        nbgl_objDraw((nbgl_obj_t *) line);
c0de0da6:	f007 f98e 	bl	c0de80c6 <nbgl_objDraw>
        nbgl_refreshSpecialWithPostRefresh(BLACK_AND_WHITE_REFRESH, POST_REFRESH_FORCE_POWER_OFF);
c0de0daa:	2003      	movs	r0, #3
c0de0dac:	2100      	movs	r1, #0
c0de0dae:	f007 f980 	bl	c0de80b2 <nbgl_refreshSpecialWithPostRefresh>
c0de0db2:	e0c3      	b.n	c0de0f3c <touchCallback+0x48c>
c0de0db4:	2400      	movs	r4, #0
    if ((layout->callback != NULL) && (layoutObj->token != NBGL_INVALID_TOKEN)) {
c0de0db6:	69f8      	ldr	r0, [r7, #28]
c0de0db8:	2800      	cmp	r0, #0
c0de0dba:	f000 80bf 	beq.w	c0de0f3c <touchCallback+0x48c>
c0de0dbe:	f898 0004 	ldrb.w	r0, [r8, #4]
c0de0dc2:	28ff      	cmp	r0, #255	@ 0xff
c0de0dc4:	f000 80ba 	beq.w	c0de0f3c <touchCallback+0x48c>
        if (layoutObj->tuneId < NBGL_NO_TUNE) {
c0de0dc8:	f898 0006 	ldrb.w	r0, [r8, #6]
c0de0dcc:	280b      	cmp	r0, #11
            os_io_seph_cmd_piezo_play_tune(layoutObj->tuneId);
c0de0dce:	bf98      	it	ls
c0de0dd0:	f7ff faf6 	blls	c0de03c0 <os_io_seph_cmd_piezo_play_tune>
c0de0dd4:	b114      	cbz	r4, c0de0ddc <touchCallback+0x32c>
            nbgl_refreshSpecial(FULL_COLOR_PARTIAL_REFRESH);
c0de0dd6:	2001      	movs	r0, #1
c0de0dd8:	f007 f966 	bl	c0de80a8 <nbgl_refreshSpecial>
        layout->callback(layoutObj->token, layoutObj->index);
c0de0ddc:	69fa      	ldr	r2, [r7, #28]
c0de0dde:	f898 0004 	ldrb.w	r0, [r8, #4]
c0de0de2:	f898 1005 	ldrb.w	r1, [r8, #5]
c0de0de6:	4790      	blx	r2
}
c0de0de8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
                      ->children[1];
c0de0dec:	f810 1f22 	ldrb.w	r1, [r0, #34]!
c0de0df0:	7842      	ldrb	r2, [r0, #1]
c0de0df2:	7883      	ldrb	r3, [r0, #2]
c0de0df4:	78c0      	ldrb	r0, [r0, #3]
c0de0df6:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de0dfa:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de0dfe:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
                = (nbgl_text_area_t *) ((nbgl_container_t *) layout->callbackObjPool[i].obj)
c0de0e02:	e9d0 1000 	ldrd	r1, r0, [r0]
            textArea->textColor = BLACK;
c0de0e06:	2200      	movs	r2, #0
c0de0e08:	77ca      	strb	r2, [r1, #31]
            textArea->fontId    = SMALL_BOLD_FONT;
c0de0e0a:	220c      	movs	r2, #12
c0de0e0c:	f881 2022 	strb.w	r2, [r1, #34]	@ 0x22
            radio->state = ON_STATE;
c0de0e10:	2101      	movs	r1, #1
c0de0e12:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
            nbgl_objDraw((nbgl_obj_t *) obj);
c0de0e16:	4620      	mov	r0, r4
c0de0e18:	f007 f955 	bl	c0de80c6 <nbgl_objDraw>
c0de0e1c:	46a8      	mov	r8, r5
c0de0e1e:	46da      	mov	sl, fp
    while (i < layout->nbUsedCallbackObjs) {
c0de0e20:	f897 00ae 	ldrb.w	r0, [r7, #174]	@ 0xae
        i++;
c0de0e24:	f10b 0b01 	add.w	fp, fp, #1
    while (i < layout->nbUsedCallbackObjs) {
c0de0e28:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de0e2c:	fa5f f18b 	uxtb.w	r1, fp
c0de0e30:	4288      	cmp	r0, r1
c0de0e32:	d931      	bls.n	c0de0e98 <touchCallback+0x3e8>
c0de0e34:	fa5f f08b 	uxtb.w	r0, fp
        if ((obj == (nbgl_obj_t *) layout->callbackObjPool[i].obj)
c0de0e38:	eb07 00c0 	add.w	r0, r7, r0, lsl #3
c0de0e3c:	6a00      	ldr	r0, [r0, #32]
            && (layout->callbackObjPool[i].obj->type == CONTAINER)) {
c0de0e3e:	42a0      	cmp	r0, r4
c0de0e40:	d102      	bne.n	c0de0e48 <touchCallback+0x398>
c0de0e42:	7ec1      	ldrb	r1, [r0, #27]
        if ((obj == (nbgl_obj_t *) layout->callbackObjPool[i].obj)
c0de0e44:	2901      	cmp	r1, #1
c0de0e46:	d0d1      	beq.n	c0de0dec <touchCallback+0x33c>
        else if ((layout->callbackObjPool[i].obj->type == CONTAINER)
c0de0e48:	7ec1      	ldrb	r1, [r0, #27]
                 && (((nbgl_container_t *) layout->callbackObjPool[i].obj)->nbChildren == 2)
c0de0e4a:	2901      	cmp	r1, #1
c0de0e4c:	d1e8      	bne.n	c0de0e20 <touchCallback+0x370>
c0de0e4e:	f890 1020 	ldrb.w	r1, [r0, #32]
                 && (((nbgl_container_t *) layout->callbackObjPool[i].obj)->children[1]->type
c0de0e52:	2902      	cmp	r1, #2
c0de0e54:	d1e4      	bne.n	c0de0e20 <touchCallback+0x370>
c0de0e56:	4601      	mov	r1, r0
c0de0e58:	f811 2f22 	ldrb.w	r2, [r1, #34]!
c0de0e5c:	784b      	ldrb	r3, [r1, #1]
c0de0e5e:	788e      	ldrb	r6, [r1, #2]
c0de0e60:	78c9      	ldrb	r1, [r1, #3]
c0de0e62:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de0e66:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de0e6a:	ea42 4201 	orr.w	r2, r2, r1, lsl #16
c0de0e6e:	6851      	ldr	r1, [r2, #4]
c0de0e70:	7ecb      	ldrb	r3, [r1, #27]
        else if ((layout->callbackObjPool[i].obj->type == CONTAINER)
c0de0e72:	2b09      	cmp	r3, #9
c0de0e74:	d1d4      	bne.n	c0de0e20 <touchCallback+0x370>
            if (radio->state == ON_STATE) {
c0de0e76:	f891 3021 	ldrb.w	r3, [r1, #33]	@ 0x21
            radioIndex++;
c0de0e7a:	3501      	adds	r5, #1
            if (radio->state == ON_STATE) {
c0de0e7c:	2b01      	cmp	r3, #1
c0de0e7e:	d1cf      	bne.n	c0de0e20 <touchCallback+0x370>
c0de0e80:	6812      	ldr	r2, [r2, #0]
                radio->state = OFF_STATE;
c0de0e82:	2300      	movs	r3, #0
c0de0e84:	f881 3021 	strb.w	r3, [r1, #33]	@ 0x21
                textArea->textColor = LIGHT_TEXT_COLOR;
c0de0e88:	2101      	movs	r1, #1
c0de0e8a:	77d1      	strb	r1, [r2, #31]
                textArea->fontId    = SMALL_REGULAR_FONT;
c0de0e8c:	210b      	movs	r1, #11
c0de0e8e:	f882 1022 	strb.w	r1, [r2, #34]	@ 0x22
                nbgl_objDraw((nbgl_obj_t *) layout->callbackObjPool[i].obj);
c0de0e92:	f007 f918 	bl	c0de80c6 <nbgl_objDraw>
c0de0e96:	e7c3      	b.n	c0de0e20 <touchCallback+0x370>
    if (foundRadio != 0xFF) {
c0de0e98:	fa5f f08a 	uxtb.w	r0, sl
c0de0e9c:	28ff      	cmp	r0, #255	@ 0xff
c0de0e9e:	d04d      	beq.n	c0de0f3c <touchCallback+0x48c>
        if (layout->callback != NULL) {
c0de0ea0:	69f9      	ldr	r1, [r7, #28]
c0de0ea2:	2900      	cmp	r1, #0
c0de0ea4:	d04a      	beq.n	c0de0f3c <touchCallback+0x48c>
            if (layout->callbackObjPool[foundRadio].tuneId < NBGL_NO_TUNE) {
c0de0ea6:	eb07 04c0 	add.w	r4, r7, r0, lsl #3
c0de0eaa:	f894 0026 	ldrb.w	r0, [r4, #38]	@ 0x26
c0de0eae:	280b      	cmp	r0, #11
                os_io_seph_cmd_piezo_play_tune(layout->callbackObjPool[foundRadio].tuneId);
c0de0eb0:	bf98      	it	ls
c0de0eb2:	f7ff fa85 	blls	c0de03c0 <os_io_seph_cmd_piezo_play_tune>
            nbgl_refreshSpecial(FULL_COLOR_PARTIAL_REFRESH);
c0de0eb6:	2001      	movs	r0, #1
c0de0eb8:	f007 f8f6 	bl	c0de80a8 <nbgl_refreshSpecial>
            layout->callback(layout->callbackObjPool[foundRadio].token, foundRadioIndex);
c0de0ebc:	69fa      	ldr	r2, [r7, #28]
c0de0ebe:	f894 0024 	ldrb.w	r0, [r4, #36]	@ 0x24
c0de0ec2:	fa5f f188 	uxtb.w	r1, r8
c0de0ec6:	4790      	blx	r2
}
c0de0ec8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de0ecc:	f1ba 0f02 	cmp.w	sl, #2
c0de0ed0:	d134      	bne.n	c0de0f3c <touchCallback+0x48c>
        uint32_t touchDuration = nbgl_touchGetTouchDuration(obj);
c0de0ed2:	4620      	mov	r0, r4
c0de0ed4:	f007 f956 	bl	c0de8184 <nbgl_touchGetTouchDuration>
c0de0ed8:	f248 511f 	movw	r1, #34079	@ 0x851f
c0de0edc:	f2c5 11eb 	movt	r1, #20971	@ 0x51eb
        = (touch_duration / HOLD_TO_APPROVE_STEP_DURATION_MS) + HOLD_TO_APPROVE_FIRST_STEP;
c0de0ee0:	fba0 0101 	umull	r0, r1, r0, r1
c0de0ee4:	0948      	lsrs	r0, r1, #5
    return (current_step_nb * HOLD_TO_APPROVE_STEP_PERCENT);
c0de0ee6:	00c0      	lsls	r0, r0, #3
c0de0ee8:	eba0 1051 	sub.w	r0, r0, r1, lsr #5
c0de0eec:	b2c1      	uxtb	r1, r0
        bool trigger_callback = (new_state >= 100) && (progressBar->state < 100);
c0de0eee:	2964      	cmp	r1, #100	@ 0x64
c0de0ef0:	f04f 0400 	mov.w	r4, #0
c0de0ef4:	d306      	bcc.n	c0de0f04 <touchCallback+0x454>
c0de0ef6:	f896 0021 	ldrb.w	r0, [r6, #33]	@ 0x21
c0de0efa:	2864      	cmp	r0, #100	@ 0x64
c0de0efc:	f04f 0064 	mov.w	r0, #100	@ 0x64
c0de0f00:	bf38      	it	cc
c0de0f02:	2401      	movcc	r4, #1
        if (new_state != progressBar->state) {
c0de0f04:	f896 1021 	ldrb.w	r1, [r6, #33]	@ 0x21
c0de0f08:	b2c2      	uxtb	r2, r0
c0de0f0a:	428a      	cmp	r2, r1
c0de0f0c:	d00e      	beq.n	c0de0f2c <touchCallback+0x47c>
            progressBar->partialRedraw = true;
c0de0f0e:	f896 1022 	ldrb.w	r1, [r6, #34]	@ 0x22
            progressBar->state         = new_state;
c0de0f12:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
            progressBar->partialRedraw = true;
c0de0f16:	f041 0101 	orr.w	r1, r1, #1
            nbgl_objDraw((nbgl_obj_t *) progressBar);
c0de0f1a:	4630      	mov	r0, r6
            progressBar->partialRedraw = true;
c0de0f1c:	f886 1022 	strb.w	r1, [r6, #34]	@ 0x22
            nbgl_objDraw((nbgl_obj_t *) progressBar);
c0de0f20:	f007 f8d1 	bl	c0de80c6 <nbgl_objDraw>
            nbgl_refreshSpecialWithPostRefresh(BLACK_AND_WHITE_FAST_REFRESH,
c0de0f24:	2004      	movs	r0, #4
c0de0f26:	2102      	movs	r1, #2
c0de0f28:	f007 f8c3 	bl	c0de80b2 <nbgl_refreshSpecialWithPostRefresh>
        if (trigger_callback) {
c0de0f2c:	2c00      	cmp	r4, #0
}
c0de0f2e:	bf08      	it	eq
c0de0f30:	e8bd 8df0 	ldmiaeq.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            if (layout->callback != NULL) {
c0de0f34:	69fa      	ldr	r2, [r7, #28]
c0de0f36:	2a00      	cmp	r2, #0
c0de0f38:	f47f af51 	bne.w	c0de0dde <touchCallback+0x32e>
}
c0de0f3c:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de0f40 <nbgl_layoutAddUpFooter>:
 * @param layout the current layout
 * @param upFooterDesc description of the up-footer
 * @return height of the control if OK
 */
int nbgl_layoutAddUpFooter(nbgl_layout_t *layout, const nbgl_layoutUpFooter_t *upFooterDesc)
{
c0de0f40:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
    nbgl_text_area_t      *textArea;
    nbgl_line_t           *line;
    nbgl_button_t         *button;

    LOG_DEBUG(LAYOUT_LOGGER, "nbgl_layoutAddUpFooter():\n");
    if (layout == NULL) {
c0de0f44:	2800      	cmp	r0, #0
c0de0f46:	f000 842f 	beq.w	c0de17a8 <nbgl_layoutAddUpFooter+0x868>
c0de0f4a:	460d      	mov	r5, r1
        return -1;
    }
    if ((upFooterDesc == NULL) || (upFooterDesc->type >= NB_UP_FOOTER_TYPES)) {
c0de0f4c:	b119      	cbz	r1, c0de0f56 <nbgl_layoutAddUpFooter+0x16>
c0de0f4e:	4604      	mov	r4, r0
c0de0f50:	7828      	ldrb	r0, [r5, #0]
c0de0f52:	2804      	cmp	r0, #4
c0de0f54:	d903      	bls.n	c0de0f5e <nbgl_layoutAddUpFooter+0x1e>
c0de0f56:	f06f 0001 	mvn.w	r0, #1
    layoutInt->children[UP_FOOTER_INDEX] = (nbgl_obj_t *) layoutInt->upFooterContainer;

    layoutInt->upFooterType = upFooterDesc->type;

    return layoutInt->upFooterContainer->obj.area.height;
}
c0de0f5a:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de0f5e:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de0f62:	2601      	movs	r6, #1
c0de0f64:	08c1      	lsrs	r1, r0, #3
c0de0f66:	2001      	movs	r0, #1
c0de0f68:	f007 f8d5 	bl	c0de8116 <nbgl_objPoolGet>
c0de0f6c:	21e0      	movs	r1, #224	@ 0xe0
c0de0f6e:	6160      	str	r0, [r4, #20]
    layoutInt->upFooterContainer->obj.area.width = SCREEN_WIDTH;
c0de0f70:	7101      	strb	r1, [r0, #4]
c0de0f72:	2100      	movs	r1, #0
c0de0f74:	7146      	strb	r6, [r0, #5]
    layoutInt->upFooterContainer->layout         = VERTICAL;
c0de0f76:	77c1      	strb	r1, [r0, #31]
        = (nbgl_obj_t **) nbgl_containerPoolGet(4, layoutInt->layer);
c0de0f78:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de0f7c:	08c1      	lsrs	r1, r0, #3
c0de0f7e:	2004      	movs	r0, #4
c0de0f80:	f007 f8ce 	bl	c0de8120 <nbgl_containerPoolGet>
    layoutInt->upFooterContainer->children
c0de0f84:	6961      	ldr	r1, [r4, #20]
        = (nbgl_obj_t **) nbgl_containerPoolGet(4, layoutInt->layer);
c0de0f86:	0a03      	lsrs	r3, r0, #8
    layoutInt->upFooterContainer->obj.alignTo   = (nbgl_obj_t *) layoutInt->container;
c0de0f88:	f8d4 20a0 	ldr.w	r2, [r4, #160]	@ 0xa0
        = (nbgl_obj_t **) nbgl_containerPoolGet(4, layoutInt->layer);
c0de0f8c:	f881 3023 	strb.w	r3, [r1, #35]	@ 0x23
c0de0f90:	460b      	mov	r3, r1
c0de0f92:	f803 0f22 	strb.w	r0, [r3, #34]!
c0de0f96:	0e07      	lsrs	r7, r0, #24
c0de0f98:	0c00      	lsrs	r0, r0, #16
c0de0f9a:	7098      	strb	r0, [r3, #2]
    layoutInt->upFooterContainer->obj.alignTo   = (nbgl_obj_t *) layoutInt->container;
c0de0f9c:	4608      	mov	r0, r1
        = (nbgl_obj_t **) nbgl_containerPoolGet(4, layoutInt->layer);
c0de0f9e:	70df      	strb	r7, [r3, #3]
    layoutInt->upFooterContainer->obj.alignTo   = (nbgl_obj_t *) layoutInt->container;
c0de0fa0:	f800 2f12 	strb.w	r2, [r0, #18]!
c0de0fa4:	0e13      	lsrs	r3, r2, #24
c0de0fa6:	70c3      	strb	r3, [r0, #3]
c0de0fa8:	0c13      	lsrs	r3, r2, #16
c0de0faa:	7083      	strb	r3, [r0, #2]
c0de0fac:	0a10      	lsrs	r0, r2, #8
c0de0fae:	74c8      	strb	r0, [r1, #19]
    switch (upFooterDesc->type) {
c0de0fb0:	782a      	ldrb	r2, [r5, #0]
c0de0fb2:	2008      	movs	r0, #8
    layoutInt->upFooterContainer->obj.alignment = BOTTOM_MIDDLE;
c0de0fb4:	7588      	strb	r0, [r1, #22]
    switch (upFooterDesc->type) {
c0de0fb6:	2a01      	cmp	r2, #1
c0de0fb8:	f06f 0001 	mvn.w	r0, #1
c0de0fbc:	f340 8081 	ble.w	c0de10c2 <nbgl_layoutAddUpFooter+0x182>
c0de0fc0:	2a02      	cmp	r2, #2
c0de0fc2:	f000 8112 	beq.w	c0de11ea <nbgl_layoutAddUpFooter+0x2aa>
c0de0fc6:	2a03      	cmp	r2, #3
c0de0fc8:	f000 81ba 	beq.w	c0de1340 <nbgl_layoutAddUpFooter+0x400>
c0de0fcc:	2a04      	cmp	r2, #4
}
c0de0fce:	bf18      	it	ne
c0de0fd0:	e8bd 8df0 	ldmiane.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de0fd4:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de0fd8:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de0fdc:	ea40 2002 	orr.w	r0, r0, r2, lsl #8
c0de0fe0:	f3c0 2205 	ubfx	r2, r0, #8, #6
c0de0fe4:	2a0e      	cmp	r2, #14
c0de0fe6:	bf84      	itt	hi
c0de0fe8:	f04f 30ff 	movhi.w	r0, #4294967295	@ 0xffffffff
}
c0de0fec:	e8bd 8df0 	ldmiahi.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de0ff0:	0a03      	lsrs	r3, r0, #8
        layout->nbUsedCallbackObjs++;
c0de0ff2:	3301      	adds	r3, #1
c0de0ff4:	f003 033f 	and.w	r3, r3, #63	@ 0x3f
c0de0ff8:	f400 4740 	and.w	r7, r0, #49152	@ 0xc000
                                       upFooterDesc->text.token,
c0de0ffc:	f895 e008 	ldrb.w	lr, [r5, #8]
                                       upFooterDesc->text.tuneId);
c0de1000:	f895 c009 	ldrb.w	ip, [r5, #9]
                                       (nbgl_obj_t *) layoutInt->upFooterContainer,
c0de1004:	6966      	ldr	r6, [r4, #20]
        layout->nbUsedCallbackObjs++;
c0de1006:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de100a:	0a1b      	lsrs	r3, r3, #8
c0de100c:	f884 00ad 	strb.w	r0, [r4, #173]	@ 0xad
        layoutObj->obj    = obj;
c0de1010:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de1014:	2260      	movs	r2, #96	@ 0x60
        layout->nbUsedCallbackObjs++;
c0de1016:	f884 30ae 	strb.w	r3, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de101a:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de101c:	f880 e024 	strb.w	lr, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de1020:	f880 c026 	strb.w	ip, [r0, #38]	@ 0x26
c0de1024:	2701      	movs	r7, #1
c0de1026:	2000      	movs	r0, #0
            layoutInt->upFooterContainer->obj.area.height = SMALL_FOOTER_HEIGHT;
c0de1028:	718a      	strb	r2, [r1, #6]
c0de102a:	2204      	movs	r2, #4
            layoutInt->upFooterContainer->nbChildren      = 1;
c0de102c:	f881 7020 	strb.w	r7, [r1, #32]
            layoutInt->upFooterContainer->obj.area.height = SMALL_FOOTER_HEIGHT;
c0de1030:	71c8      	strb	r0, [r1, #7]
            layoutInt->upFooterContainer->obj.touchId     = WHOLE_SCREEN_ID;
c0de1032:	778a      	strb	r2, [r1, #30]
            layoutInt->upFooterContainer->obj.touchMask   = (1 << TOUCHED);
c0de1034:	7748      	strb	r0, [r1, #29]
c0de1036:	770f      	strb	r7, [r1, #28]
            if (strlen(PIC(upFooterDesc->text.text))) {
c0de1038:	6868      	ldr	r0, [r5, #4]
c0de103a:	f007 ff5f 	bl	c0de8efc <pic>
c0de103e:	7800      	ldrb	r0, [r0, #0]
c0de1040:	2800      	cmp	r0, #0
c0de1042:	f000 8395 	beq.w	c0de1770 <nbgl_layoutAddUpFooter+0x830>
                textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de1046:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de104a:	08c1      	lsrs	r1, r0, #3
c0de104c:	2004      	movs	r0, #4
c0de104e:	f007 f862 	bl	c0de8116 <nbgl_objPoolGet>
                textArea->textColor       = LIGHT_TEXT_COLOR;
c0de1052:	77c7      	strb	r7, [r0, #31]
                textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de1054:	4606      	mov	r6, r0
                textArea->text            = PIC(upFooterDesc->text.text);
c0de1056:	6868      	ldr	r0, [r5, #4]
c0de1058:	f007 ff50 	bl	c0de8efc <pic>
c0de105c:	4601      	mov	r1, r0
c0de105e:	4630      	mov	r0, r6
c0de1060:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de1064:	0e0a      	lsrs	r2, r1, #24
c0de1066:	70c2      	strb	r2, [r0, #3]
c0de1068:	0c0a      	lsrs	r2, r1, #16
c0de106a:	7082      	strb	r2, [r0, #2]
c0de106c:	0a08      	lsrs	r0, r1, #8
c0de106e:	f886 0027 	strb.w	r0, [r6, #39]	@ 0x27
c0de1072:	200b      	movs	r0, #11
                textArea->fontId          = SMALL_REGULAR_FONT;
c0de1074:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
                textArea->wrapping        = true;
c0de1078:	f896 0024 	ldrb.w	r0, [r6, #36]	@ 0x24
c0de107c:	f04f 0805 	mov.w	r8, #5
c0de1080:	f040 0001 	orr.w	r0, r0, #1
c0de1084:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
c0de1088:	20a0      	movs	r0, #160	@ 0xa0
                textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de108a:	7130      	strb	r0, [r6, #4]
                textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de108c:	200b      	movs	r0, #11
c0de108e:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de1092:	2301      	movs	r3, #1
                textArea->textAlignment   = CENTER;
c0de1094:	f886 8020 	strb.w	r8, [r6, #32]
                textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de1098:	7177      	strb	r7, [r6, #5]
                textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de109a:	f007 f855 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de109e:	71b0      	strb	r0, [r6, #6]
                layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) textArea;
c0de10a0:	6961      	ldr	r1, [r4, #20]
                textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de10a2:	0a00      	lsrs	r0, r0, #8
c0de10a4:	71f0      	strb	r0, [r6, #7]
                layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) textArea;
c0de10a6:	f811 0f22 	ldrb.w	r0, [r1, #34]!
                textArea->obj.alignment                   = CENTER;
c0de10aa:	f886 8016 	strb.w	r8, [r6, #22]
                layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) textArea;
c0de10ae:	784a      	ldrb	r2, [r1, #1]
c0de10b0:	788b      	ldrb	r3, [r1, #2]
c0de10b2:	78c9      	ldrb	r1, [r1, #3]
c0de10b4:	ea40 2002 	orr.w	r0, r0, r2, lsl #8
c0de10b8:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de10bc:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de10c0:	e091      	b.n	c0de11e6 <nbgl_layoutAddUpFooter+0x2a6>
    switch (upFooterDesc->type) {
c0de10c2:	2a00      	cmp	r2, #0
c0de10c4:	f000 8250 	beq.w	c0de1568 <nbgl_layoutAddUpFooter+0x628>
c0de10c8:	2a01      	cmp	r2, #1
c0de10ca:	f040 836b 	bne.w	c0de17a4 <nbgl_layoutAddUpFooter+0x864>
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de10ce:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de10d2:	f04f 0a05 	mov.w	sl, #5
c0de10d6:	08c1      	lsrs	r1, r0, #3
c0de10d8:	2005      	movs	r0, #5
c0de10da:	f007 f81c 	bl	c0de8116 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de10de:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de10e2:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de10e6:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de10ea:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de10ee:	2a0e      	cmp	r2, #14
c0de10f0:	bf84      	itt	hi
c0de10f2:	f04f 30ff 	movhi.w	r0, #4294967295	@ 0xffffffff
}
c0de10f6:	e8bd 8df0 	ldmiahi.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de10fa:	4606      	mov	r6, r0
c0de10fc:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de10fe:	3001      	adds	r0, #1
c0de1100:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de1104:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de1108:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
                                       upFooterDesc->button.token,
c0de110c:	f895 c00c 	ldrb.w	ip, [r5, #12]
                                       upFooterDesc->button.tuneId);
c0de1110:	7c2f      	ldrb	r7, [r5, #16]
        layout->nbUsedCallbackObjs++;
c0de1112:	0a00      	lsrs	r0, r0, #8
c0de1114:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de1118:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de111c:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de111e:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de1122:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
            layoutInt->upFooterContainer->nbChildren      = 1;
c0de1126:	6960      	ldr	r0, [r4, #20]
        layout->nbUsedCallbackObjs++;
c0de1128:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
c0de112c:	f04f 0801 	mov.w	r8, #1
c0de1130:	2700      	movs	r7, #0
c0de1132:	2188      	movs	r1, #136	@ 0x88
            layoutInt->upFooterContainer->nbChildren      = 1;
c0de1134:	f880 8020 	strb.w	r8, [r0, #32]
            layoutInt->upFooterContainer->obj.area.height = UP_FOOTER_BUTTON_HEIGHT;
c0de1138:	71c7      	strb	r7, [r0, #7]
c0de113a:	7181      	strb	r1, [r0, #6]
            button->obj.alignment                         = CENTER;
c0de113c:	f886 a016 	strb.w	sl, [r6, #22]
            if (upFooterDesc->button.style == BLACK_BACKGROUND) {
c0de1140:	7b68      	ldrb	r0, [r5, #13]
c0de1142:	2100      	movs	r1, #0
c0de1144:	2800      	cmp	r0, #0
c0de1146:	bf18      	it	ne
c0de1148:	2003      	movne	r0, #3
c0de114a:	bf08      	it	eq
c0de114c:	2103      	moveq	r1, #3
c0de114e:	77f0      	strb	r0, [r6, #31]
c0de1150:	f886 1021 	strb.w	r1, [r6, #33]	@ 0x21
            if (upFooterDesc->button.style == NO_BORDER) {
c0de1154:	7b68      	ldrb	r0, [r5, #13]
c0de1156:	4601      	mov	r1, r0
c0de1158:	2800      	cmp	r0, #0
c0de115a:	bf18      	it	ne
c0de115c:	2101      	movne	r1, #1
c0de115e:	0049      	lsls	r1, r1, #1
c0de1160:	2802      	cmp	r0, #2
c0de1162:	bf08      	it	eq
c0de1164:	2103      	moveq	r1, #3
c0de1166:	f886 1020 	strb.w	r1, [r6, #32]
            button->text            = PIC(upFooterDesc->button.text);
c0de116a:	6868      	ldr	r0, [r5, #4]
c0de116c:	f007 fec6 	bl	c0de8efc <pic>
c0de1170:	4631      	mov	r1, r6
c0de1172:	f801 0f25 	strb.w	r0, [r1, #37]!
c0de1176:	0e02      	lsrs	r2, r0, #24
c0de1178:	70ca      	strb	r2, [r1, #3]
c0de117a:	0c02      	lsrs	r2, r0, #16
c0de117c:	0a00      	lsrs	r0, r0, #8
c0de117e:	f886 0026 	strb.w	r0, [r6, #38]	@ 0x26
c0de1182:	200c      	movs	r0, #12
c0de1184:	708a      	strb	r2, [r1, #2]
            button->fontId          = SMALL_BOLD_FONT;
c0de1186:	f886 0023 	strb.w	r0, [r6, #35]	@ 0x23
            button->icon            = PIC(upFooterDesc->button.icon);
c0de118a:	68a8      	ldr	r0, [r5, #8]
c0de118c:	f007 feb6 	bl	c0de8efc <pic>
c0de1190:	4631      	mov	r1, r6
c0de1192:	f801 0f2e 	strb.w	r0, [r1, #46]!
c0de1196:	0e02      	lsrs	r2, r0, #24
c0de1198:	70ca      	strb	r2, [r1, #3]
c0de119a:	0c02      	lsrs	r2, r0, #16
c0de119c:	0a00      	lsrs	r0, r0, #8
c0de119e:	f886 002f 	strb.w	r0, [r6, #47]	@ 0x2f
c0de11a2:	20a0      	movs	r0, #160	@ 0xa0
            button->obj.area.width  = AVAILABLE_WIDTH;
c0de11a4:	7130      	strb	r0, [r6, #4]
c0de11a6:	2058      	movs	r0, #88	@ 0x58
            button->obj.area.height = BUTTON_DIAMETER;
c0de11a8:	71b0      	strb	r0, [r6, #6]
c0de11aa:	2004      	movs	r0, #4
            button->radius          = BUTTON_RADIUS;
c0de11ac:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
            button->obj.alignTo                       = NULL;
c0de11b0:	4630      	mov	r0, r6
c0de11b2:	f800 7f12 	strb.w	r7, [r0, #18]!
            button->icon            = PIC(upFooterDesc->button.icon);
c0de11b6:	708a      	strb	r2, [r1, #2]
            button->obj.alignTo                       = NULL;
c0de11b8:	74f7      	strb	r7, [r6, #19]
c0de11ba:	7087      	strb	r7, [r0, #2]
            button->obj.touchMask                     = (1 << TOUCHED);
c0de11bc:	f886 801c 	strb.w	r8, [r6, #28]
            button->obj.alignTo                       = NULL;
c0de11c0:	70c7      	strb	r7, [r0, #3]
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de11c2:	6960      	ldr	r0, [r4, #20]
c0de11c4:	2107      	movs	r1, #7
c0de11c6:	f810 2f22 	ldrb.w	r2, [r0, #34]!
            button->obj.touchId                       = SINGLE_BUTTON_ID;
c0de11ca:	77b1      	strb	r1, [r6, #30]
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de11cc:	7841      	ldrb	r1, [r0, #1]
c0de11ce:	7883      	ldrb	r3, [r0, #2]
c0de11d0:	78c0      	ldrb	r0, [r0, #3]
c0de11d2:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de11d6:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
            button->obj.area.width  = AVAILABLE_WIDTH;
c0de11da:	f886 8005 	strb.w	r8, [r6, #5]
            button->obj.area.height = BUTTON_DIAMETER;
c0de11de:	71f7      	strb	r7, [r6, #7]
            button->obj.touchMask                     = (1 << TOUCHED);
c0de11e0:	7777      	strb	r7, [r6, #29]
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de11e2:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de11e6:	6006      	str	r6, [r0, #0]
c0de11e8:	e2c2      	b.n	c0de1770 <nbgl_layoutAddUpFooter+0x830>
            if ((upFooterDesc->horizontalButtons.leftIcon == NULL)
c0de11ea:	6868      	ldr	r0, [r5, #4]
                || (upFooterDesc->horizontalButtons.rightText == NULL)) {
c0de11ec:	2800      	cmp	r0, #0
c0de11ee:	f000 82db 	beq.w	c0de17a8 <nbgl_layoutAddUpFooter+0x868>
c0de11f2:	68a8      	ldr	r0, [r5, #8]
            if ((upFooterDesc->horizontalButtons.leftIcon == NULL)
c0de11f4:	2800      	cmp	r0, #0
c0de11f6:	f000 82d7 	beq.w	c0de17a8 <nbgl_layoutAddUpFooter+0x868>
c0de11fa:	2702      	movs	r7, #2
c0de11fc:	f04f 0b00 	mov.w	fp, #0
c0de1200:	2088      	movs	r0, #136	@ 0x88
            layoutInt->upFooterContainer->nbChildren      = 2;
c0de1202:	f881 7020 	strb.w	r7, [r1, #32]
            layoutInt->upFooterContainer->obj.area.height = UP_FOOTER_BUTTON_HEIGHT;
c0de1206:	f881 b007 	strb.w	fp, [r1, #7]
c0de120a:	7188      	strb	r0, [r1, #6]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de120c:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1210:	08c1      	lsrs	r1, r0, #3
c0de1212:	2005      	movs	r0, #5
c0de1214:	f006 ff7f 	bl	c0de8116 <nbgl_objPoolGet>
                                       upFooterDesc->horizontalButtons.leftToken,
c0de1218:	7b2a      	ldrb	r2, [r5, #12]
                                       upFooterDesc->horizontalButtons.tuneId);
c0de121a:	7bab      	ldrb	r3, [r5, #14]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de121c:	4606      	mov	r6, r0
            obj    = layoutAddCallbackObj(layoutInt,
c0de121e:	4620      	mov	r0, r4
c0de1220:	4631      	mov	r1, r6
c0de1222:	f7ff fb29 	bl	c0de0878 <layoutAddCallbackObj>
            if (obj == NULL) {
c0de1226:	2800      	cmp	r0, #0
c0de1228:	f000 82be 	beq.w	c0de17a8 <nbgl_layoutAddUpFooter+0x868>
c0de122c:	2101      	movs	r1, #1
            obj->index                   = 1;
c0de122e:	7141      	strb	r1, [r0, #5]
c0de1230:	2020      	movs	r0, #32
c0de1232:	f04f 0a04 	mov.w	sl, #4
            button->obj.alignmentMarginX = BORDER_MARGIN;
c0de1236:	75f0      	strb	r0, [r6, #23]
c0de1238:	2003      	movs	r0, #3
c0de123a:	f04f 0858 	mov.w	r8, #88	@ 0x58
            button->obj.alignment        = MID_LEFT;
c0de123e:	f886 a016 	strb.w	sl, [r6, #22]
            button->obj.alignmentMarginX = BORDER_MARGIN;
c0de1242:	f886 b018 	strb.w	fp, [r6, #24]
            button->borderColor          = LIGHT_GRAY;
c0de1246:	f886 7020 	strb.w	r7, [r6, #32]
            button->innerColor           = WHITE;
c0de124a:	77f0      	strb	r0, [r6, #31]
            button->foregroundColor      = BLACK;
c0de124c:	f886 b021 	strb.w	fp, [r6, #33]	@ 0x21
            button->obj.area.width       = BUTTON_WIDTH;
c0de1250:	f886 b005 	strb.w	fp, [r6, #5]
c0de1254:	f886 8004 	strb.w	r8, [r6, #4]
            button->obj.area.height      = BUTTON_DIAMETER;
c0de1258:	f886 b007 	strb.w	fp, [r6, #7]
c0de125c:	f886 8006 	strb.w	r8, [r6, #6]
            button->radius               = BUTTON_RADIUS;
c0de1260:	f886 a022 	strb.w	sl, [r6, #34]	@ 0x22
            button->icon                 = PIC(upFooterDesc->horizontalButtons.leftIcon);
c0de1264:	6868      	ldr	r0, [r5, #4]
c0de1266:	f007 fe49 	bl	c0de8efc <pic>
c0de126a:	4631      	mov	r1, r6
c0de126c:	f801 0f2e 	strb.w	r0, [r1, #46]!
c0de1270:	0e02      	lsrs	r2, r0, #24
c0de1272:	70ca      	strb	r2, [r1, #3]
c0de1274:	0c02      	lsrs	r2, r0, #16
c0de1276:	0a00      	lsrs	r0, r0, #8
            button->obj.touchMask        = (1 << TOUCHED);
c0de1278:	f886 b01d 	strb.w	fp, [r6, #29]
c0de127c:	f04f 0b01 	mov.w	fp, #1
            button->icon                 = PIC(upFooterDesc->horizontalButtons.leftIcon);
c0de1280:	708a      	strb	r2, [r1, #2]
c0de1282:	f886 002f 	strb.w	r0, [r6, #47]	@ 0x2f
c0de1286:	200c      	movs	r0, #12
            button->obj.touchMask        = (1 << TOUCHED);
c0de1288:	f886 b01c 	strb.w	fp, [r6, #28]
            button->fontId               = SMALL_BOLD_FONT;
c0de128c:	f886 0023 	strb.w	r0, [r6, #35]	@ 0x23
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de1290:	6960      	ldr	r0, [r4, #20]
c0de1292:	210a      	movs	r1, #10
c0de1294:	f810 2f22 	ldrb.w	r2, [r0, #34]!
            button->obj.touchId          = CHOICE_2_ID;
c0de1298:	77b1      	strb	r1, [r6, #30]
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de129a:	7841      	ldrb	r1, [r0, #1]
c0de129c:	7883      	ldrb	r3, [r0, #2]
c0de129e:	78c0      	ldrb	r0, [r0, #3]
c0de12a0:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de12a4:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de12a8:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de12ac:	6006      	str	r6, [r0, #0]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de12ae:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de12b2:	08c1      	lsrs	r1, r0, #3
c0de12b4:	2005      	movs	r0, #5
c0de12b6:	f006 ff2e 	bl	c0de8116 <nbgl_objPoolGet>
                                       upFooterDesc->horizontalButtons.rightToken,
c0de12ba:	7b6a      	ldrb	r2, [r5, #13]
                                       upFooterDesc->horizontalButtons.tuneId);
c0de12bc:	7bab      	ldrb	r3, [r5, #14]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de12be:	4606      	mov	r6, r0
            obj    = layoutAddCallbackObj(layoutInt,
c0de12c0:	4620      	mov	r0, r4
c0de12c2:	4631      	mov	r1, r6
c0de12c4:	f7ff fad8 	bl	c0de0878 <layoutAddCallbackObj>
            if (obj == NULL) {
c0de12c8:	2800      	cmp	r0, #0
c0de12ca:	f000 826d 	beq.w	c0de17a8 <nbgl_layoutAddUpFooter+0x868>
c0de12ce:	2700      	movs	r7, #0
            obj->index                   = 0;
c0de12d0:	7147      	strb	r7, [r0, #5]
c0de12d2:	2006      	movs	r0, #6
            button->obj.alignment        = MID_RIGHT;
c0de12d4:	75b0      	strb	r0, [r6, #22]
            button->obj.alignmentMarginX = BORDER_MARGIN;
c0de12d6:	2020      	movs	r0, #32
c0de12d8:	2103      	movs	r1, #3
c0de12da:	75f0      	strb	r0, [r6, #23]
c0de12dc:	2038      	movs	r0, #56	@ 0x38
c0de12de:	7637      	strb	r7, [r6, #24]
            button->innerColor           = BLACK;
c0de12e0:	77f7      	strb	r7, [r6, #31]
            button->borderColor          = BLACK;
c0de12e2:	f886 7020 	strb.w	r7, [r6, #32]
            button->foregroundColor      = WHITE;
c0de12e6:	f886 1021 	strb.w	r1, [r6, #33]	@ 0x21
            button->obj.area.width  = AVAILABLE_WIDTH - BUTTON_WIDTH - LEFT_CONTENT_ICON_TEXT_X;
c0de12ea:	f886 b005 	strb.w	fp, [r6, #5]
c0de12ee:	7130      	strb	r0, [r6, #4]
            button->obj.area.height = BUTTON_DIAMETER;
c0de12f0:	71f7      	strb	r7, [r6, #7]
c0de12f2:	f886 8006 	strb.w	r8, [r6, #6]
            button->radius          = BUTTON_RADIUS;
c0de12f6:	f886 a022 	strb.w	sl, [r6, #34]	@ 0x22
            button->text            = PIC(upFooterDesc->horizontalButtons.rightText);
c0de12fa:	68a8      	ldr	r0, [r5, #8]
c0de12fc:	f007 fdfe 	bl	c0de8efc <pic>
c0de1300:	4631      	mov	r1, r6
c0de1302:	f801 0f25 	strb.w	r0, [r1, #37]!
c0de1306:	0e02      	lsrs	r2, r0, #24
c0de1308:	70ca      	strb	r2, [r1, #3]
c0de130a:	0c02      	lsrs	r2, r0, #16
c0de130c:	0a00      	lsrs	r0, r0, #8
c0de130e:	708a      	strb	r2, [r1, #2]
c0de1310:	f886 0026 	strb.w	r0, [r6, #38]	@ 0x26
            button->fontId          = SMALL_BOLD_FONT;
c0de1314:	200c      	movs	r0, #12
            button->obj.touchMask   = (1 << TOUCHED);
c0de1316:	f886 b01c 	strb.w	fp, [r6, #28]
            button->fontId          = SMALL_BOLD_FONT;
c0de131a:	f886 0023 	strb.w	r0, [r6, #35]	@ 0x23
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) button;
c0de131e:	6960      	ldr	r0, [r4, #20]
c0de1320:	2109      	movs	r1, #9
c0de1322:	f810 2f22 	ldrb.w	r2, [r0, #34]!
            button->obj.touchId     = CHOICE_1_ID;
c0de1326:	77b1      	strb	r1, [r6, #30]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) button;
c0de1328:	7841      	ldrb	r1, [r0, #1]
c0de132a:	7883      	ldrb	r3, [r0, #2]
c0de132c:	78c0      	ldrb	r0, [r0, #3]
c0de132e:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de1332:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de1336:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
            button->obj.touchMask   = (1 << TOUCHED);
c0de133a:	7777      	strb	r7, [r6, #29]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) button;
c0de133c:	6046      	str	r6, [r0, #4]
c0de133e:	e217      	b.n	c0de1770 <nbgl_layoutAddUpFooter+0x830>
            if (upFooterDesc->tipBox.text == NULL) {
c0de1340:	6868      	ldr	r0, [r5, #4]
c0de1342:	2800      	cmp	r0, #0
c0de1344:	f000 8230 	beq.w	c0de17a8 <nbgl_layoutAddUpFooter+0x868>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de1348:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de134c:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de1350:	ea40 2002 	orr.w	r0, r0, r2, lsl #8
c0de1354:	f3c0 2205 	ubfx	r2, r0, #8, #6
c0de1358:	2a0e      	cmp	r2, #14
c0de135a:	f200 8225 	bhi.w	c0de17a8 <nbgl_layoutAddUpFooter+0x868>
c0de135e:	0a03      	lsrs	r3, r0, #8
        layout->nbUsedCallbackObjs++;
c0de1360:	3301      	adds	r3, #1
c0de1362:	f003 033f 	and.w	r3, r3, #63	@ 0x3f
c0de1366:	f400 4740 	and.w	r7, r0, #49152	@ 0xc000
                                       upFooterDesc->tipBox.token,
c0de136a:	f895 e00c 	ldrb.w	lr, [r5, #12]
                                       upFooterDesc->tipBox.tuneId);
c0de136e:	f895 c00d 	ldrb.w	ip, [r5, #13]
                                       (nbgl_obj_t *) layoutInt->upFooterContainer,
c0de1372:	6966      	ldr	r6, [r4, #20]
        layout->nbUsedCallbackObjs++;
c0de1374:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de1378:	0a1b      	lsrs	r3, r3, #8
c0de137a:	f884 00ad 	strb.w	r0, [r4, #173]	@ 0xad
        layoutObj->obj    = obj;
c0de137e:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
        layout->nbUsedCallbackObjs++;
c0de1382:	f884 30ae 	strb.w	r3, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de1386:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de1388:	f880 e024 	strb.w	lr, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de138c:	f880 c026 	strb.w	ip, [r0, #38]	@ 0x26
c0de1390:	2003      	movs	r0, #3
            layoutInt->upFooterContainer->nbChildren    = 3;
c0de1392:	f881 0020 	strb.w	r0, [r1, #32]
c0de1396:	2013      	movs	r0, #19
c0de1398:	f04f 0800 	mov.w	r8, #0
c0de139c:	f04f 0a01 	mov.w	sl, #1
            layoutInt->upFooterContainer->obj.touchId   = TIP_BOX_ID;
c0de13a0:	7788      	strb	r0, [r1, #30]
            layoutInt->upFooterContainer->obj.touchMask = (1 << TOUCHED);
c0de13a2:	f881 801d 	strb.w	r8, [r1, #29]
c0de13a6:	f881 a01c 	strb.w	sl, [r1, #28]
            textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de13aa:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de13ae:	2704      	movs	r7, #4
c0de13b0:	08c1      	lsrs	r1, r0, #3
c0de13b2:	2004      	movs	r0, #4
c0de13b4:	f006 feaf 	bl	c0de8116 <nbgl_objPoolGet>
            textArea->textColor = BLACK;
c0de13b8:	f880 801f 	strb.w	r8, [r0, #31]
            textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de13bc:	4606      	mov	r6, r0
            textArea->text      = PIC(upFooterDesc->tipBox.text);
c0de13be:	6868      	ldr	r0, [r5, #4]
c0de13c0:	f007 fd9c 	bl	c0de8efc <pic>
c0de13c4:	4631      	mov	r1, r6
c0de13c6:	f801 0f26 	strb.w	r0, [r1, #38]!
c0de13ca:	0e02      	lsrs	r2, r0, #24
c0de13cc:	70ca      	strb	r2, [r1, #3]
c0de13ce:	0c02      	lsrs	r2, r0, #16
c0de13d0:	708a      	strb	r2, [r1, #2]
c0de13d2:	0a00      	lsrs	r0, r0, #8
            textArea->wrapping       = true;
c0de13d4:	f896 1024 	ldrb.w	r1, [r6, #36]	@ 0x24
            textArea->text      = PIC(upFooterDesc->tipBox.text);
c0de13d8:	f886 0027 	strb.w	r0, [r6, #39]	@ 0x27
c0de13dc:	200b      	movs	r0, #11
            textArea->fontId         = SMALL_REGULAR_FONT;
c0de13de:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
            textArea->wrapping       = true;
c0de13e2:	f041 0001 	orr.w	r0, r1, #1
c0de13e6:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
c0de13ea:	20a0      	movs	r0, #160	@ 0xa0
            textArea->textAlignment  = MID_LEFT;
c0de13ec:	f886 7020 	strb.w	r7, [r6, #32]
            textArea->obj.area.width = AVAILABLE_WIDTH;
c0de13f0:	f886 a005 	strb.w	sl, [r6, #5]
c0de13f4:	7130      	strb	r0, [r6, #4]
            if (upFooterDesc->tipBox.icon != NULL) {
c0de13f6:	68a8      	ldr	r0, [r5, #8]
c0de13f8:	b180      	cbz	r0, c0de141c <nbgl_layoutAddUpFooter+0x4dc>
                    -= ((nbgl_icon_details_t *) PIC(upFooterDesc->tipBox.icon))->width
c0de13fa:	f007 fd7f 	bl	c0de8efc <pic>
c0de13fe:	4632      	mov	r2, r6
c0de1400:	f812 3f04 	ldrb.w	r3, [r2, #4]!
c0de1404:	7801      	ldrb	r1, [r0, #0]
c0de1406:	7840      	ldrb	r0, [r0, #1]
c0de1408:	7857      	ldrb	r7, [r2, #1]
c0de140a:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de140e:	ea43 2107 	orr.w	r1, r3, r7, lsl #8
c0de1412:	1a08      	subs	r0, r1, r0
c0de1414:	3820      	subs	r0, #32
c0de1416:	7010      	strb	r0, [r2, #0]
c0de1418:	0a00      	lsrs	r0, r0, #8
c0de141a:	7050      	strb	r0, [r2, #1]
                textArea->fontId, textArea->text, textArea->obj.area.width, textArea->wrapping);
c0de141c:	4630      	mov	r0, r6
c0de141e:	f810 1f26 	ldrb.w	r1, [r0, #38]!
c0de1422:	f896 2027 	ldrb.w	r2, [r6, #39]	@ 0x27
c0de1426:	7883      	ldrb	r3, [r0, #2]
c0de1428:	78c0      	ldrb	r0, [r0, #3]
c0de142a:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de142e:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de1432:	7932      	ldrb	r2, [r6, #4]
c0de1434:	7973      	ldrb	r3, [r6, #5]
c0de1436:	f896 7024 	ldrb.w	r7, [r6, #36]	@ 0x24
c0de143a:	ea41 4100 	orr.w	r1, r1, r0, lsl #16
c0de143e:	f896 0022 	ldrb.w	r0, [r6, #34]	@ 0x22
c0de1442:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de1446:	f007 0301 	and.w	r3, r7, #1
            textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de144a:	f006 fe7d 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de144e:	f04f 0b20 	mov.w	fp, #32
c0de1452:	71b0      	strb	r0, [r6, #6]
            textArea->obj.alignmentMarginX                = BORDER_MARGIN;
c0de1454:	f886 b017 	strb.w	fp, [r6, #23]
            layoutInt->upFooterContainer->children[0]     = (nbgl_obj_t *) textArea;
c0de1458:	6962      	ldr	r2, [r4, #20]
            textArea->obj.alignment                       = MID_LEFT;
c0de145a:	2304      	movs	r3, #4
            layoutInt->upFooterContainer->children[0]     = (nbgl_obj_t *) textArea;
c0de145c:	f812 cf22 	ldrb.w	ip, [r2, #34]!
            textArea->obj.alignment                       = MID_LEFT;
c0de1460:	75b3      	strb	r3, [r6, #22]
            layoutInt->upFooterContainer->children[0]     = (nbgl_obj_t *) textArea;
c0de1462:	7857      	ldrb	r7, [r2, #1]
c0de1464:	7893      	ldrb	r3, [r2, #2]
c0de1466:	78d2      	ldrb	r2, [r2, #3]
c0de1468:	ea4c 2707 	orr.w	r7, ip, r7, lsl #8
c0de146c:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de1470:	ea47 4202 	orr.w	r2, r7, r2, lsl #16
c0de1474:	6016      	str	r6, [r2, #0]
            layoutInt->upFooterContainer->obj.area.height = textArea->obj.area.height;
c0de1476:	6962      	ldr	r2, [r4, #20]
            textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de1478:	0a01      	lsrs	r1, r0, #8
c0de147a:	71f1      	strb	r1, [r6, #7]
            textArea->obj.alignmentMarginX                = BORDER_MARGIN;
c0de147c:	f886 8018 	strb.w	r8, [r6, #24]
            layoutInt->upFooterContainer->obj.area.height = textArea->obj.area.height;
c0de1480:	71d1      	strb	r1, [r2, #7]
c0de1482:	7190      	strb	r0, [r2, #6]
            line                                      = createHorizontalLine(layoutInt->layer);
c0de1484:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1488:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de148a:	2003      	movs	r0, #3
c0de148c:	f006 fe43 	bl	c0de8116 <nbgl_objPoolGet>
c0de1490:	22e0      	movs	r2, #224	@ 0xe0
    line->obj.area.width  = SCREEN_WIDTH;
c0de1492:	7102      	strb	r2, [r0, #4]
    line->obj.area.height = 1;
c0de1494:	f880 a006 	strb.w	sl, [r0, #6]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) line;
c0de1498:	6962      	ldr	r2, [r4, #20]
c0de149a:	2102      	movs	r1, #2
c0de149c:	f812 3f22 	ldrb.w	r3, [r2, #34]!
    line->lineColor       = LIGHT_GRAY;
c0de14a0:	f880 1020 	strb.w	r1, [r0, #32]
            line->obj.alignment                       = TOP_MIDDLE;
c0de14a4:	7581      	strb	r1, [r0, #22]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) line;
c0de14a6:	7851      	ldrb	r1, [r2, #1]
c0de14a8:	7897      	ldrb	r7, [r2, #2]
c0de14aa:	78d2      	ldrb	r2, [r2, #3]
c0de14ac:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de14b0:	ea47 2202 	orr.w	r2, r7, r2, lsl #8
c0de14b4:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
    line->obj.area.width  = SCREEN_WIDTH;
c0de14b8:	f880 a005 	strb.w	sl, [r0, #5]
    line->obj.area.height = 1;
c0de14bc:	f880 8007 	strb.w	r8, [r0, #7]
    line->direction       = HORIZONTAL;
c0de14c0:	f880 a01f 	strb.w	sl, [r0, #31]
    line->thickness       = 1;
c0de14c4:	f880 a021 	strb.w	sl, [r0, #33]	@ 0x21
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) line;
c0de14c8:	6048      	str	r0, [r1, #4]
            if (upFooterDesc->tipBox.icon != NULL) {
c0de14ca:	68a8      	ldr	r0, [r5, #8]
c0de14cc:	2800      	cmp	r0, #0
c0de14ce:	d040      	beq.n	c0de1552 <nbgl_layoutAddUpFooter+0x612>
                nbgl_image_t *image = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de14d0:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de14d4:	08c1      	lsrs	r1, r0, #3
c0de14d6:	2002      	movs	r0, #2
c0de14d8:	f006 fe1d 	bl	c0de8116 <nbgl_objPoolGet>
c0de14dc:	4606      	mov	r6, r0
c0de14de:	2000      	movs	r0, #0
c0de14e0:	2106      	movs	r1, #6
                image->obj.alignmentMarginX               = BORDER_MARGIN;
c0de14e2:	7630      	strb	r0, [r6, #24]
c0de14e4:	f886 b017 	strb.w	fp, [r6, #23]
                image->obj.alignment                      = MID_RIGHT;
c0de14e8:	75b1      	strb	r1, [r6, #22]
                image->foregroundColor                    = BLACK;
c0de14ea:	77f0      	strb	r0, [r6, #31]
                image->buffer                             = PIC(upFooterDesc->tipBox.icon);
c0de14ec:	68a8      	ldr	r0, [r5, #8]
c0de14ee:	f007 fd05 	bl	c0de8efc <pic>
c0de14f2:	4631      	mov	r1, r6
c0de14f4:	f801 0f21 	strb.w	r0, [r1, #33]!
c0de14f8:	0c02      	lsrs	r2, r0, #16
c0de14fa:	708a      	strb	r2, [r1, #2]
c0de14fc:	0a02      	lsrs	r2, r0, #8
c0de14fe:	f886 2022 	strb.w	r2, [r6, #34]	@ 0x22
                layoutInt->upFooterContainer->children[2] = (nbgl_obj_t *) image;
c0de1502:	6962      	ldr	r2, [r4, #20]
                image->buffer                             = PIC(upFooterDesc->tipBox.icon);
c0de1504:	0e00      	lsrs	r0, r0, #24
                layoutInt->upFooterContainer->children[2] = (nbgl_obj_t *) image;
c0de1506:	f812 3f22 	ldrb.w	r3, [r2, #34]!
                image->buffer                             = PIC(upFooterDesc->tipBox.icon);
c0de150a:	70c8      	strb	r0, [r1, #3]
                layoutInt->upFooterContainer->children[2] = (nbgl_obj_t *) image;
c0de150c:	7850      	ldrb	r0, [r2, #1]
c0de150e:	7897      	ldrb	r7, [r2, #2]
c0de1510:	78d2      	ldrb	r2, [r2, #3]
c0de1512:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de1516:	ea47 2202 	orr.w	r2, r7, r2, lsl #8
c0de151a:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de151e:	6086      	str	r6, [r0, #8]
                if (layoutInt->upFooterContainer->obj.area.height < image->buffer->height) {
c0de1520:	f896 3022 	ldrb.w	r3, [r6, #34]	@ 0x22
c0de1524:	780f      	ldrb	r7, [r1, #0]
c0de1526:	788e      	ldrb	r6, [r1, #2]
c0de1528:	78c9      	ldrb	r1, [r1, #3]
c0de152a:	6960      	ldr	r0, [r4, #20]
c0de152c:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de1530:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de1534:	ea43 4101 	orr.w	r1, r3, r1, lsl #16
c0de1538:	7982      	ldrb	r2, [r0, #6]
c0de153a:	79c7      	ldrb	r7, [r0, #7]
c0de153c:	788b      	ldrb	r3, [r1, #2]
c0de153e:	78c9      	ldrb	r1, [r1, #3]
c0de1540:	ea42 2207 	orr.w	r2, r2, r7, lsl #8
c0de1544:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de1548:	428a      	cmp	r2, r1
                    layoutInt->upFooterContainer->obj.area.height = image->buffer->height;
c0de154a:	bf3e      	ittt	cc
c0de154c:	7181      	strbcc	r1, [r0, #6]
c0de154e:	0a09      	lsrcc	r1, r1, #8
c0de1550:	71c1      	strbcc	r1, [r0, #7]
            layoutInt->upFooterContainer->obj.area.height += 2 * TIP_BOX_MARGIN_Y;
c0de1552:	6960      	ldr	r0, [r4, #20]
c0de1554:	f810 1f06 	ldrb.w	r1, [r0, #6]!
c0de1558:	7842      	ldrb	r2, [r0, #1]
c0de155a:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de155e:	3130      	adds	r1, #48	@ 0x30
c0de1560:	7001      	strb	r1, [r0, #0]
c0de1562:	0a09      	lsrs	r1, r1, #8
c0de1564:	7041      	strb	r1, [r0, #1]
c0de1566:	e103      	b.n	c0de1770 <nbgl_layoutAddUpFooter+0x830>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de1568:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de156c:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de1570:	ea40 2002 	orr.w	r0, r0, r2, lsl #8
c0de1574:	f3c0 2205 	ubfx	r2, r0, #8, #6
c0de1578:	2a0e      	cmp	r2, #14
c0de157a:	f200 8115 	bhi.w	c0de17a8 <nbgl_layoutAddUpFooter+0x868>
c0de157e:	0a03      	lsrs	r3, r0, #8
        layout->nbUsedCallbackObjs++;
c0de1580:	3301      	adds	r3, #1
c0de1582:	f003 033f 	and.w	r3, r3, #63	@ 0x3f
c0de1586:	f400 4740 	and.w	r7, r0, #49152	@ 0xc000
                                       upFooterDesc->longPress.token,
c0de158a:	f895 e008 	ldrb.w	lr, [r5, #8]
                                       upFooterDesc->longPress.tuneId);
c0de158e:	f895 c009 	ldrb.w	ip, [r5, #9]
                                       (nbgl_obj_t *) layoutInt->upFooterContainer,
c0de1592:	6966      	ldr	r6, [r4, #20]
        layout->nbUsedCallbackObjs++;
c0de1594:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de1598:	0a1b      	lsrs	r3, r3, #8
c0de159a:	f884 00ad 	strb.w	r0, [r4, #173]	@ 0xad
        layoutObj->obj    = obj;
c0de159e:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
        layout->nbUsedCallbackObjs++;
c0de15a2:	f884 30ae 	strb.w	r3, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de15a6:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de15a8:	f880 e024 	strb.w	lr, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de15ac:	f880 c026 	strb.w	ip, [r0, #38]	@ 0x26
c0de15b0:	2098      	movs	r0, #152	@ 0x98
            layoutInt->upFooterContainer->obj.area.height = LONG_PRESS_BUTTON_HEIGHT;
c0de15b2:	7188      	strb	r0, [r1, #6]
c0de15b4:	2012      	movs	r0, #18
c0de15b6:	f04f 0804 	mov.w	r8, #4
c0de15ba:	f04f 0b00 	mov.w	fp, #0
            layoutInt->upFooterContainer->obj.touchId     = LONG_PRESS_BUTTON_ID;
c0de15be:	7788      	strb	r0, [r1, #30]
c0de15c0:	2706      	movs	r7, #6
c0de15c2:	202c      	movs	r0, #44	@ 0x2c
            layoutInt->upFooterContainer->nbChildren      = 4;
c0de15c4:	f881 8020 	strb.w	r8, [r1, #32]
            layoutInt->upFooterContainer->obj.area.height = LONG_PRESS_BUTTON_HEIGHT;
c0de15c8:	f881 b007 	strb.w	fp, [r1, #7]
                = ((1 << TOUCHING) | (1 << TOUCH_RELEASED) | (1 << OUT_OF_TOUCH)
c0de15cc:	774f      	strb	r7, [r1, #29]
c0de15ce:	7708      	strb	r0, [r1, #28]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de15d0:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de15d4:	08c1      	lsrs	r1, r0, #3
c0de15d6:	2005      	movs	r0, #5
c0de15d8:	f006 fd9d 	bl	c0de8116 <nbgl_objPoolGet>
c0de15dc:	f04f 0a20 	mov.w	sl, #32
c0de15e0:	4606      	mov	r6, r0
            button->obj.alignmentMarginX              = BORDER_MARGIN;
c0de15e2:	f880 b018 	strb.w	fp, [r0, #24]
c0de15e6:	f880 a017 	strb.w	sl, [r0, #23]
            button->obj.alignment                     = MID_RIGHT;
c0de15ea:	7587      	strb	r7, [r0, #22]
            button->innerColor                        = BLACK;
c0de15ec:	f880 b01f 	strb.w	fp, [r0, #31]
c0de15f0:	2003      	movs	r0, #3
            button->foregroundColor                   = WHITE;
c0de15f2:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
c0de15f6:	2058      	movs	r0, #88	@ 0x58
            button->obj.area.width                    = BUTTON_DIAMETER;
c0de15f8:	4637      	mov	r7, r6
c0de15fa:	f807 0f04 	strb.w	r0, [r7, #4]!
            button->borderColor                       = BLACK;
c0de15fe:	f886 b020 	strb.w	fp, [r6, #32]
            button->obj.area.width                    = BUTTON_DIAMETER;
c0de1602:	f887 b001 	strb.w	fp, [r7, #1]
            button->obj.area.height                   = BUTTON_DIAMETER;
c0de1606:	f886 b007 	strb.w	fp, [r6, #7]
c0de160a:	71b0      	strb	r0, [r6, #6]
            button->radius                            = BUTTON_RADIUS;
c0de160c:	f886 8022 	strb.w	r8, [r6, #34]	@ 0x22
            button->icon                              = PIC(&VALIDATE_ICON);
c0de1610:	f248 4018 	movw	r0, #33816	@ 0x8418
c0de1614:	f2c0 0000 	movt	r0, #0
c0de1618:	4478      	add	r0, pc
c0de161a:	f007 fc6f 	bl	c0de8efc <pic>
c0de161e:	4631      	mov	r1, r6
c0de1620:	f801 0f2e 	strb.w	r0, [r1, #46]!
c0de1624:	0c02      	lsrs	r2, r0, #16
c0de1626:	708a      	strb	r2, [r1, #2]
c0de1628:	0a02      	lsrs	r2, r0, #8
c0de162a:	f886 202f 	strb.w	r2, [r6, #47]	@ 0x2f
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de162e:	6962      	ldr	r2, [r4, #20]
            button->icon                              = PIC(&VALIDATE_ICON);
c0de1630:	0e00      	lsrs	r0, r0, #24
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de1632:	f812 3f22 	ldrb.w	r3, [r2, #34]!
            button->icon                              = PIC(&VALIDATE_ICON);
c0de1636:	70c8      	strb	r0, [r1, #3]
            layoutInt->upFooterContainer->children[0] = (nbgl_obj_t *) button;
c0de1638:	7850      	ldrb	r0, [r2, #1]
c0de163a:	7891      	ldrb	r1, [r2, #2]
c0de163c:	78d2      	ldrb	r2, [r2, #3]
c0de163e:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de1642:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de1646:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de164a:	6006      	str	r6, [r0, #0]
            textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de164c:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1650:	08c1      	lsrs	r1, r0, #3
c0de1652:	2004      	movs	r0, #4
c0de1654:	f006 fd5f 	bl	c0de8116 <nbgl_objPoolGet>
            textArea->textColor = BLACK;
c0de1658:	f880 b01f 	strb.w	fp, [r0, #31]
            textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de165c:	4606      	mov	r6, r0
            textArea->text      = PIC(upFooterDesc->longPress.text);
c0de165e:	6868      	ldr	r0, [r5, #4]
c0de1660:	f007 fc4c 	bl	c0de8efc <pic>
c0de1664:	4601      	mov	r1, r0
c0de1666:	4630      	mov	r0, r6
c0de1668:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de166c:	0e0a      	lsrs	r2, r1, #24
c0de166e:	70c2      	strb	r2, [r0, #3]
c0de1670:	0c0a      	lsrs	r2, r1, #16
c0de1672:	7082      	strb	r2, [r0, #2]
c0de1674:	0a08      	lsrs	r0, r1, #8
c0de1676:	f886 0027 	strb.w	r0, [r6, #39]	@ 0x27
            textArea->wrapping        = true;
c0de167a:	f896 0024 	ldrb.w	r0, [r6, #36]	@ 0x24
c0de167e:	220d      	movs	r2, #13
c0de1680:	f040 0001 	orr.w	r0, r0, #1
c0de1684:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
            textArea->obj.area.width  = SCREEN_WIDTH - 3 * BORDER_MARGIN - button->obj.area.width;
c0de1688:	7838      	ldrb	r0, [r7, #0]
c0de168a:	787b      	ldrb	r3, [r7, #1]
            textArea->fontId          = LARGE_MEDIUM_FONT;
c0de168c:	f886 2022 	strb.w	r2, [r6, #34]	@ 0x22
            textArea->obj.area.width  = SCREEN_WIDTH - 3 * BORDER_MARGIN - button->obj.area.width;
c0de1690:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de1694:	f5c0 70c0 	rsb	r0, r0, #384	@ 0x180
c0de1698:	0a02      	lsrs	r2, r0, #8
c0de169a:	7130      	strb	r0, [r6, #4]
c0de169c:	7172      	strb	r2, [r6, #5]
            textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de169e:	b282      	uxth	r2, r0
c0de16a0:	200d      	movs	r0, #13
c0de16a2:	2301      	movs	r3, #1
            textArea->textAlignment   = MID_LEFT;
c0de16a4:	f886 8020 	strb.w	r8, [r6, #32]
c0de16a8:	2701      	movs	r7, #1
            textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de16aa:	f006 fd4d 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de16ae:	71b0      	strb	r0, [r6, #6]
c0de16b0:	0a00      	lsrs	r0, r0, #8
            textArea->obj.alignmentMarginX            = BORDER_MARGIN;
c0de16b2:	f886 a017 	strb.w	sl, [r6, #23]
            textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de16b6:	71f0      	strb	r0, [r6, #7]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) textArea;
c0de16b8:	6960      	ldr	r0, [r4, #20]
            textArea->style                           = NO_STYLE;
c0de16ba:	f886 b021 	strb.w	fp, [r6, #33]	@ 0x21
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) textArea;
c0de16be:	f810 1f22 	ldrb.w	r1, [r0, #34]!
            textArea->obj.alignment                   = MID_LEFT;
c0de16c2:	f886 8016 	strb.w	r8, [r6, #22]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) textArea;
c0de16c6:	7842      	ldrb	r2, [r0, #1]
c0de16c8:	7883      	ldrb	r3, [r0, #2]
c0de16ca:	78c0      	ldrb	r0, [r0, #3]
c0de16cc:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de16d0:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de16d4:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
            textArea->obj.alignmentMarginX            = BORDER_MARGIN;
c0de16d8:	f886 b018 	strb.w	fp, [r6, #24]
            layoutInt->upFooterContainer->children[1] = (nbgl_obj_t *) textArea;
c0de16dc:	6046      	str	r6, [r0, #4]
            line                                      = createHorizontalLine(layoutInt->layer);
c0de16de:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de16e2:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de16e4:	2003      	movs	r0, #3
c0de16e6:	f006 fd16 	bl	c0de8116 <nbgl_objPoolGet>
c0de16ea:	f04f 08e0 	mov.w	r8, #224	@ 0xe0
    line->obj.area.width  = SCREEN_WIDTH;
c0de16ee:	f880 8004 	strb.w	r8, [r0, #4]
    line->obj.area.height = 1;
c0de16f2:	7187      	strb	r7, [r0, #6]
            layoutInt->upFooterContainer->children[2] = (nbgl_obj_t *) line;
c0de16f4:	6961      	ldr	r1, [r4, #20]
c0de16f6:	f04f 0a02 	mov.w	sl, #2
c0de16fa:	f811 2f22 	ldrb.w	r2, [r1, #34]!
    line->lineColor       = LIGHT_GRAY;
c0de16fe:	f880 a020 	strb.w	sl, [r0, #32]
            layoutInt->upFooterContainer->children[2] = (nbgl_obj_t *) line;
c0de1702:	784b      	ldrb	r3, [r1, #1]
c0de1704:	788e      	ldrb	r6, [r1, #2]
c0de1706:	78c9      	ldrb	r1, [r1, #3]
c0de1708:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de170c:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de1710:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
    line->obj.area.width  = SCREEN_WIDTH;
c0de1714:	7147      	strb	r7, [r0, #5]
    line->obj.area.height = 1;
c0de1716:	f880 b007 	strb.w	fp, [r0, #7]
    line->direction       = HORIZONTAL;
c0de171a:	77c7      	strb	r7, [r0, #31]
    line->thickness       = 1;
c0de171c:	f880 7021 	strb.w	r7, [r0, #33]	@ 0x21
            line->obj.alignment                       = TOP_MIDDLE;
c0de1720:	f880 a016 	strb.w	sl, [r0, #22]
            layoutInt->upFooterContainer->children[2] = (nbgl_obj_t *) line;
c0de1724:	6088      	str	r0, [r1, #8]
            progressBar = (nbgl_progress_bar_t *) nbgl_objPoolGet(PROGRESS_BAR, layoutInt->layer);
c0de1726:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de172a:	2608      	movs	r6, #8
c0de172c:	08c1      	lsrs	r1, r0, #3
c0de172e:	2008      	movs	r0, #8
c0de1730:	f006 fcf1 	bl	c0de8116 <nbgl_objPoolGet>
            progressBar->resetIfOverriden             = true;
c0de1734:	f890 1022 	ldrb.w	r1, [r0, #34]	@ 0x22
            progressBar->obj.area.width               = SCREEN_WIDTH;
c0de1738:	f880 8004 	strb.w	r8, [r0, #4]
            progressBar->partialRedraw                = true;
c0de173c:	f041 0105 	orr.w	r1, r1, #5
            progressBar->obj.area.height              = LONG_PRESS_PROGRESS_HEIGHT;
c0de1740:	7186      	strb	r6, [r0, #6]
            progressBar->obj.alignmentMarginY         = LONG_PRESS_PROGRESS_ALIGN;
c0de1742:	7647      	strb	r7, [r0, #25]
            progressBar->partialRedraw                = true;
c0de1744:	f880 1022 	strb.w	r1, [r0, #34]	@ 0x22
            layoutInt->upFooterContainer->children[3] = (nbgl_obj_t *) progressBar;
c0de1748:	6961      	ldr	r1, [r4, #20]
            progressBar->obj.area.width               = SCREEN_WIDTH;
c0de174a:	7147      	strb	r7, [r0, #5]
            layoutInt->upFooterContainer->children[3] = (nbgl_obj_t *) progressBar;
c0de174c:	f811 2f22 	ldrb.w	r2, [r1, #34]!
            progressBar->obj.area.height              = LONG_PRESS_PROGRESS_HEIGHT;
c0de1750:	f880 b007 	strb.w	fp, [r0, #7]
            layoutInt->upFooterContainer->children[3] = (nbgl_obj_t *) progressBar;
c0de1754:	784b      	ldrb	r3, [r1, #1]
c0de1756:	788f      	ldrb	r7, [r1, #2]
c0de1758:	78c9      	ldrb	r1, [r1, #3]
c0de175a:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de175e:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de1762:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
            progressBar->obj.alignment                = TOP_MIDDLE;
c0de1766:	f880 a016 	strb.w	sl, [r0, #22]
            progressBar->obj.alignmentMarginY         = LONG_PRESS_PROGRESS_ALIGN;
c0de176a:	f880 b01a 	strb.w	fp, [r0, #26]
            layoutInt->upFooterContainer->children[3] = (nbgl_obj_t *) progressBar;
c0de176e:	60c8      	str	r0, [r1, #12]
    layoutInt->container->obj.area.height -= layoutInt->upFooterContainer->obj.area.height;
c0de1770:	6960      	ldr	r0, [r4, #20]
c0de1772:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
c0de1776:	7982      	ldrb	r2, [r0, #6]
c0de1778:	79c3      	ldrb	r3, [r0, #7]
c0de177a:	f811 7f06 	ldrb.w	r7, [r1, #6]!
c0de177e:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de1782:	784b      	ldrb	r3, [r1, #1]
    layoutInt->children[UP_FOOTER_INDEX] = (nbgl_obj_t *) layoutInt->upFooterContainer;
c0de1784:	68a6      	ldr	r6, [r4, #8]
    layoutInt->container->obj.area.height -= layoutInt->upFooterContainer->obj.area.height;
c0de1786:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de178a:	1a9a      	subs	r2, r3, r2
c0de178c:	700a      	strb	r2, [r1, #0]
    layoutInt->children[UP_FOOTER_INDEX] = (nbgl_obj_t *) layoutInt->upFooterContainer;
c0de178e:	6130      	str	r0, [r6, #16]
    layoutInt->container->obj.area.height -= layoutInt->upFooterContainer->obj.area.height;
c0de1790:	0a12      	lsrs	r2, r2, #8
    return layoutInt->upFooterContainer->obj.area.height;
c0de1792:	6960      	ldr	r0, [r4, #20]
    layoutInt->container->obj.area.height -= layoutInt->upFooterContainer->obj.area.height;
c0de1794:	704a      	strb	r2, [r1, #1]
    return layoutInt->upFooterContainer->obj.area.height;
c0de1796:	7982      	ldrb	r2, [r0, #6]
c0de1798:	79c0      	ldrb	r0, [r0, #7]
    layoutInt->upFooterType = upFooterDesc->type;
c0de179a:	7829      	ldrb	r1, [r5, #0]
    return layoutInt->upFooterContainer->obj.area.height;
c0de179c:	ea42 2000 	orr.w	r0, r2, r0, lsl #8
    layoutInt->upFooterType = upFooterDesc->type;
c0de17a0:	f884 10ac 	strb.w	r1, [r4, #172]	@ 0xac
}
c0de17a4:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de17a8:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de17ac:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de17b0 <nbgl_layoutAddSwipe>:
{
c0de17b0:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
    if (layout == NULL) {
c0de17b4:	2800      	cmp	r0, #0
c0de17b6:	d060      	beq.n	c0de187a <nbgl_layoutAddSwipe+0xca>
c0de17b8:	461d      	mov	r5, r3
c0de17ba:	4617      	mov	r7, r2
c0de17bc:	4604      	mov	r4, r0
c0de17be:	460e      	mov	r6, r1
    if (text) {
c0de17c0:	b36a      	cbz	r2, c0de181e <nbgl_layoutAddSwipe+0x6e>
        layoutInt->tapText                  = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, 0);
c0de17c2:	2004      	movs	r0, #4
c0de17c4:	2100      	movs	r1, #0
c0de17c6:	f04f 0800 	mov.w	r8, #0
c0de17ca:	f006 fca4 	bl	c0de8116 <nbgl_objPoolGet>
c0de17ce:	61a0      	str	r0, [r4, #24]
        layoutInt->tapText->text            = PIC(text);
c0de17d0:	4638      	mov	r0, r7
c0de17d2:	f007 fb93 	bl	c0de8efc <pic>
c0de17d6:	69a1      	ldr	r1, [r4, #24]
c0de17d8:	0e02      	lsrs	r2, r0, #24
c0de17da:	f801 0f26 	strb.w	r0, [r1, #38]!
c0de17de:	70ca      	strb	r2, [r1, #3]
c0de17e0:	0c02      	lsrs	r2, r0, #16
c0de17e2:	0a00      	lsrs	r0, r0, #8
c0de17e4:	7048      	strb	r0, [r1, #1]
c0de17e6:	2001      	movs	r0, #1
        layoutInt->tapText->textColor       = LIGHT_TEXT_COLOR;
c0de17e8:	f801 0c07 	strb.w	r0, [r1, #-7]
        layoutInt->tapText->obj.area.width  = AVAILABLE_WIDTH;
c0de17ec:	f801 0c21 	strb.w	r0, [r1, #-33]
c0de17f0:	20a0      	movs	r0, #160	@ 0xa0
        layoutInt->tapText->text            = PIC(text);
c0de17f2:	708a      	strb	r2, [r1, #2]
c0de17f4:	220b      	movs	r2, #11
        layoutInt->tapText->obj.area.width  = AVAILABLE_WIDTH;
c0de17f6:	f801 0c22 	strb.w	r0, [r1, #-34]
        layoutInt->tapText->obj.area.height = nbgl_getFontLineHeight(layoutInt->tapText->fontId);
c0de17fa:	200b      	movs	r0, #11
        layoutInt->tapText->fontId          = SMALL_REGULAR_FONT;
c0de17fc:	f801 2c04 	strb.w	r2, [r1, #-4]
        layoutInt->tapText->obj.area.height = nbgl_getFontLineHeight(layoutInt->tapText->fontId);
c0de1800:	f006 fc9d 	bl	c0de813e <nbgl_getFontLineHeight>
c0de1804:	69a1      	ldr	r1, [r4, #24]
c0de1806:	7188      	strb	r0, [r1, #6]
c0de1808:	2005      	movs	r0, #5
        layoutInt->tapText->textAlignment   = CENTER;
c0de180a:	f881 0020 	strb.w	r0, [r1, #32]
c0de180e:	201e      	movs	r0, #30
        layoutInt->tapText->obj.alignmentMarginY = TAP_TO_CONTINUE_MARGIN;
c0de1810:	7648      	strb	r0, [r1, #25]
c0de1812:	2008      	movs	r0, #8
        layoutInt->tapText->obj.area.height = nbgl_getFontLineHeight(layoutInt->tapText->fontId);
c0de1814:	f881 8007 	strb.w	r8, [r1, #7]
        layoutInt->tapText->obj.alignmentMarginY = TAP_TO_CONTINUE_MARGIN;
c0de1818:	f881 801a 	strb.w	r8, [r1, #26]
        layoutInt->tapText->obj.alignment        = BOTTOM_MIDDLE;
c0de181c:	7588      	strb	r0, [r1, #22]
    if ((swipesMask & SWIPE_MASK) == 0) {
c0de181e:	f416 6ff0 	tst.w	r6, #1920	@ 0x780
c0de1822:	d02a      	beq.n	c0de187a <nbgl_layoutAddSwipe+0xca>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de1824:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1828:	f894 10ae 	ldrb.w	r1, [r4, #174]	@ 0xae
c0de182c:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de1830:	f3c0 2105 	ubfx	r1, r0, #8, #6
c0de1834:	290e      	cmp	r1, #14
c0de1836:	d820      	bhi.n	c0de187a <nbgl_layoutAddSwipe+0xca>
c0de1838:	0a03      	lsrs	r3, r0, #8
        layout->nbUsedCallbackObjs++;
c0de183a:	3301      	adds	r3, #1
c0de183c:	f003 033f 	and.w	r3, r3, #63	@ 0x3f
c0de1840:	f400 4240 	and.w	r2, r0, #49152	@ 0xc000
c0de1844:	f8dd c018 	ldr.w	ip, [sp, #24]
    obj = layoutAddCallbackObj(layoutInt, (nbgl_obj_t *) layoutInt->container, token, tuneId);
c0de1848:	f8d4 70a0 	ldr.w	r7, [r4, #160]	@ 0xa0
        layout->nbUsedCallbackObjs++;
c0de184c:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de1850:	0a12      	lsrs	r2, r2, #8
c0de1852:	f884 00ad 	strb.w	r0, [r4, #173]	@ 0xad
        layoutObj->obj    = obj;
c0de1856:	eb04 00c1 	add.w	r0, r4, r1, lsl #3
        layout->nbUsedCallbackObjs++;
c0de185a:	f884 20ae 	strb.w	r2, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de185e:	6207      	str	r7, [r0, #32]
        layoutObj->token  = token;
c0de1860:	f880 5024 	strb.w	r5, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de1864:	f880 c026 	strb.w	ip, [r0, #38]	@ 0x26
    layoutInt->container->obj.touchMask = swipesMask;
c0de1868:	0a30      	lsrs	r0, r6, #8
c0de186a:	7778      	strb	r0, [r7, #29]
c0de186c:	2001      	movs	r0, #1
c0de186e:	773e      	strb	r6, [r7, #28]
    layoutInt->swipeUsage               = usage;
c0de1870:	f884 00b0 	strb.w	r0, [r4, #176]	@ 0xb0
c0de1874:	2000      	movs	r0, #0
}
c0de1876:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
c0de187a:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de187e:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}

c0de1882 <nbgl_layoutAddTopRightButton>:
{
c0de1882:	e92d 45f0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, lr}
c0de1886:	b081      	sub	sp, #4
    if (layout == NULL) {
c0de1888:	2800      	cmp	r0, #0
c0de188a:	d055      	beq.n	c0de1938 <nbgl_layoutAddTopRightButton+0xb6>
c0de188c:	4604      	mov	r4, r0
    button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de188e:	f890 00ad 	ldrb.w	r0, [r0, #173]	@ 0xad
c0de1892:	4688      	mov	r8, r1
c0de1894:	08c1      	lsrs	r1, r0, #3
c0de1896:	2005      	movs	r0, #5
c0de1898:	461f      	mov	r7, r3
c0de189a:	4615      	mov	r5, r2
c0de189c:	f04f 0a05 	mov.w	sl, #5
c0de18a0:	f006 fc39 	bl	c0de8116 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de18a4:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de18a8:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de18ac:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de18b0:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de18b4:	2a0e      	cmp	r2, #14
c0de18b6:	d83f      	bhi.n	c0de1938 <nbgl_layoutAddTopRightButton+0xb6>
c0de18b8:	4606      	mov	r6, r0
c0de18ba:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de18bc:	3001      	adds	r0, #1
c0de18be:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de18c2:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de18c6:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de18ca:	0a00      	lsrs	r0, r0, #8
c0de18cc:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de18d0:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de18d4:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de18d6:	f880 5024 	strb.w	r5, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de18da:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
c0de18de:	2058      	movs	r0, #88	@ 0x58
        layout->nbUsedCallbackObjs++;
c0de18e0:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
    button->obj.area.width       = BUTTON_WIDTH;
c0de18e4:	7130      	strb	r0, [r6, #4]
    button->obj.area.height      = BUTTON_DIAMETER;
c0de18e6:	71b0      	strb	r0, [r6, #6]
c0de18e8:	2004      	movs	r0, #4
    button->radius               = BUTTON_RADIUS;
c0de18ea:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
c0de18ee:	2020      	movs	r0, #32
    button->obj.alignmentMarginX = BORDER_MARGIN;
c0de18f0:	75f0      	strb	r0, [r6, #23]
    button->obj.alignmentMarginY = BORDER_MARGIN;
c0de18f2:	7670      	strb	r0, [r6, #25]
c0de18f4:	2002      	movs	r0, #2
    button->borderColor          = LIGHT_GRAY;
c0de18f6:	f886 0020 	strb.w	r0, [r6, #32]
c0de18fa:	2001      	movs	r0, #1
c0de18fc:	2700      	movs	r7, #0
c0de18fe:	2503      	movs	r5, #3
    button->obj.touchMask        = (1 << TOUCHED);
c0de1900:	7730      	strb	r0, [r6, #28]
    button->icon                 = PIC(icon);
c0de1902:	4640      	mov	r0, r8
    button->obj.area.width       = BUTTON_WIDTH;
c0de1904:	7177      	strb	r7, [r6, #5]
    button->obj.area.height      = BUTTON_DIAMETER;
c0de1906:	71f7      	strb	r7, [r6, #7]
    button->obj.alignmentMarginX = BORDER_MARGIN;
c0de1908:	7637      	strb	r7, [r6, #24]
    button->obj.alignmentMarginY = BORDER_MARGIN;
c0de190a:	76b7      	strb	r7, [r6, #26]
    button->foregroundColor      = BLACK;
c0de190c:	f886 7021 	strb.w	r7, [r6, #33]	@ 0x21
    button->innerColor           = WHITE;
c0de1910:	77f5      	strb	r5, [r6, #31]
    button->obj.touchMask        = (1 << TOUCHED);
c0de1912:	7777      	strb	r7, [r6, #29]
    button->obj.touchId          = TOP_RIGHT_BUTTON_ID;
c0de1914:	f886 a01e 	strb.w	sl, [r6, #30]
    button->icon                 = PIC(icon);
c0de1918:	f007 faf0 	bl	c0de8efc <pic>
c0de191c:	4631      	mov	r1, r6
c0de191e:	f801 0f2e 	strb.w	r0, [r1, #46]!
c0de1922:	0e02      	lsrs	r2, r0, #24
c0de1924:	70ca      	strb	r2, [r1, #3]
c0de1926:	0c02      	lsrs	r2, r0, #16
c0de1928:	0a00      	lsrs	r0, r0, #8
c0de192a:	708a      	strb	r2, [r1, #2]
c0de192c:	f886 002f 	strb.w	r0, [r6, #47]	@ 0x2f
    layoutInt->children[TOP_RIGHT_BUTTON_INDEX] = (nbgl_obj_t *) button;
c0de1930:	68a0      	ldr	r0, [r4, #8]
    button->obj.alignment        = TOP_RIGHT;
c0de1932:	75b5      	strb	r5, [r6, #22]
    layoutInt->children[TOP_RIGHT_BUTTON_INDEX] = (nbgl_obj_t *) button;
c0de1934:	6086      	str	r6, [r0, #8]
c0de1936:	e001      	b.n	c0de193c <nbgl_layoutAddTopRightButton+0xba>
c0de1938:	f04f 37ff 	mov.w	r7, #4294967295	@ 0xffffffff
}
c0de193c:	4638      	mov	r0, r7
c0de193e:	b001      	add	sp, #4
c0de1940:	e8bd 85f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, pc}

c0de1944 <nbgl_layoutAddExtendedFooter>:
{
c0de1944:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de1948:	b082      	sub	sp, #8
    if (layout == NULL) {
c0de194a:	2800      	cmp	r0, #0
c0de194c:	f000 8497 	beq.w	c0de227e <nbgl_layoutAddExtendedFooter+0x93a>
c0de1950:	468a      	mov	sl, r1
    if ((footerDesc == NULL) || (footerDesc->type >= NB_FOOTER_TYPES)) {
c0de1952:	b121      	cbz	r1, c0de195e <nbgl_layoutAddExtendedFooter+0x1a>
c0de1954:	4604      	mov	r4, r0
c0de1956:	f89a 0000 	ldrb.w	r0, [sl]
c0de195a:	2806      	cmp	r0, #6
c0de195c:	d903      	bls.n	c0de1966 <nbgl_layoutAddExtendedFooter+0x22>
c0de195e:	f06f 0701 	mvn.w	r7, #1
c0de1962:	f000 bc8e 	b.w	c0de2282 <nbgl_layoutAddExtendedFooter+0x93e>
    layoutInt->footerContainer = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de1966:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de196a:	2601      	movs	r6, #1
c0de196c:	08c1      	lsrs	r1, r0, #3
c0de196e:	2001      	movs	r0, #1
c0de1970:	f006 fbd1 	bl	c0de8116 <nbgl_objPoolGet>
c0de1974:	21e0      	movs	r1, #224	@ 0xe0
c0de1976:	6120      	str	r0, [r4, #16]
    layoutInt->footerContainer->obj.area.width = SCREEN_WIDTH;
c0de1978:	7101      	strb	r1, [r0, #4]
c0de197a:	2100      	movs	r1, #0
c0de197c:	7146      	strb	r6, [r0, #5]
    layoutInt->footerContainer->layout         = VERTICAL;
c0de197e:	77c1      	strb	r1, [r0, #31]
        = (nbgl_obj_t **) nbgl_containerPoolGet(5, layoutInt->layer);
c0de1980:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1984:	08c1      	lsrs	r1, r0, #3
c0de1986:	2005      	movs	r0, #5
c0de1988:	f006 fbca 	bl	c0de8120 <nbgl_containerPoolGet>
c0de198c:	4601      	mov	r1, r0
    layoutInt->footerContainer->children
c0de198e:	6920      	ldr	r0, [r4, #16]
        = (nbgl_obj_t **) nbgl_containerPoolGet(5, layoutInt->layer);
c0de1990:	0a0a      	lsrs	r2, r1, #8
c0de1992:	f880 2023 	strb.w	r2, [r0, #35]	@ 0x23
c0de1996:	4602      	mov	r2, r0
c0de1998:	f802 1f22 	strb.w	r1, [r2, #34]!
c0de199c:	0e0b      	lsrs	r3, r1, #24
c0de199e:	0c09      	lsrs	r1, r1, #16
c0de19a0:	7091      	strb	r1, [r2, #2]
    switch (footerDesc->type) {
c0de19a2:	f89a 1000 	ldrb.w	r1, [sl]
        = (nbgl_obj_t **) nbgl_containerPoolGet(5, layoutInt->layer);
c0de19a6:	70d3      	strb	r3, [r2, #3]
c0de19a8:	2208      	movs	r2, #8
    switch (footerDesc->type) {
c0de19aa:	2902      	cmp	r1, #2
c0de19ac:	f06f 0701 	mvn.w	r7, #1
    layoutInt->footerContainer->obj.alignment = BOTTOM_MIDDLE;
c0de19b0:	7582      	strb	r2, [r0, #22]
    switch (footerDesc->type) {
c0de19b2:	dd46      	ble.n	c0de1a42 <nbgl_layoutAddExtendedFooter+0xfe>
c0de19b4:	2904      	cmp	r1, #4
c0de19b6:	f300 8135 	bgt.w	c0de1c24 <nbgl_layoutAddExtendedFooter+0x2e0>
c0de19ba:	2903      	cmp	r1, #3
c0de19bc:	f000 822b 	beq.w	c0de1e16 <nbgl_layoutAddExtendedFooter+0x4d2>
c0de19c0:	2904      	cmp	r1, #4
c0de19c2:	f040 845e 	bne.w	c0de2282 <nbgl_layoutAddExtendedFooter+0x93e>
c0de19c6:	2100      	movs	r1, #0
            layoutInt->footerContainer->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de19c8:	71c1      	strb	r1, [r0, #7]
c0de19ca:	2160      	movs	r1, #96	@ 0x60
c0de19cc:	7181      	strb	r1, [r0, #6]
                layoutInt->footerContainer, &footerDesc->navigation, layoutInt->layer);
c0de19ce:	f894 20ad 	ldrb.w	r2, [r4, #173]	@ 0xad
c0de19d2:	f10a 0104 	add.w	r1, sl, #4
c0de19d6:	08d2      	lsrs	r2, r2, #3
            layoutNavigationPopulate(
c0de19d8:	f003 f9f1 	bl	c0de4dbe <layoutNavigationPopulate>
            layoutInt->footerContainer->nbChildren = 4;
c0de19dc:	6920      	ldr	r0, [r4, #16]
c0de19de:	2104      	movs	r1, #4
c0de19e0:	f880 1020 	strb.w	r1, [r0, #32]
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de19e4:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de19e8:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de19ec:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de19f0:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de19f4:	2a0e      	cmp	r2, #14
c0de19f6:	f200 8442 	bhi.w	c0de227e <nbgl_layoutAddExtendedFooter+0x93a>
c0de19fa:	0a0b      	lsrs	r3, r1, #8
        layout->nbUsedCallbackObjs++;
c0de19fc:	3301      	adds	r3, #1
c0de19fe:	f003 033f 	and.w	r3, r3, #63	@ 0x3f
c0de1a02:	f401 4640 	and.w	r6, r1, #49152	@ 0xc000
                                       footerDesc->navigation.token,
c0de1a06:	f89a 7004 	ldrb.w	r7, [sl, #4]
                                       footerDesc->navigation.tuneId);
c0de1a0a:	f89a c00c 	ldrb.w	ip, [sl, #12]
        layout->nbUsedCallbackObjs++;
c0de1a0e:	ea46 2303 	orr.w	r3, r6, r3, lsl #8
c0de1a12:	0a1b      	lsrs	r3, r3, #8
c0de1a14:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
        layoutObj->obj    = obj;
c0de1a18:	eb04 01c2 	add.w	r1, r4, r2, lsl #3
        layout->nbUsedCallbackObjs++;
c0de1a1c:	f884 30ae 	strb.w	r3, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de1a20:	6208      	str	r0, [r1, #32]
        layoutObj->token  = token;
c0de1a22:	f881 7024 	strb.w	r7, [r1, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de1a26:	f881 c026 	strb.w	ip, [r1, #38]	@ 0x26
            layoutInt->activePage = footerDesc->navigation.activePage;
c0de1a2a:	f89a 0006 	ldrb.w	r0, [sl, #6]
c0de1a2e:	f04f 0800 	mov.w	r8, #0
c0de1a32:	f884 00a9 	strb.w	r0, [r4, #169]	@ 0xa9
            layoutInt->nbPages    = footerDesc->navigation.nbPages;
c0de1a36:	f89a 0005 	ldrb.w	r0, [sl, #5]
c0de1a3a:	f884 00a8 	strb.w	r0, [r4, #168]	@ 0xa8
c0de1a3e:	f000 bc5e 	b.w	c0de22fe <nbgl_layoutAddExtendedFooter+0x9ba>
    switch (footerDesc->type) {
c0de1a42:	2900      	cmp	r1, #0
c0de1a44:	f000 82f6 	beq.w	c0de2034 <nbgl_layoutAddExtendedFooter+0x6f0>
c0de1a48:	2901      	cmp	r1, #1
c0de1a4a:	f000 82fb 	beq.w	c0de2044 <nbgl_layoutAddExtendedFooter+0x700>
c0de1a4e:	2902      	cmp	r1, #2
c0de1a50:	f040 8417 	bne.w	c0de2282 <nbgl_layoutAddExtendedFooter+0x93e>
            textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de1a54:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1a58:	08c1      	lsrs	r1, r0, #3
c0de1a5a:	2004      	movs	r0, #4
c0de1a5c:	f006 fb5b 	bl	c0de8116 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de1a60:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de1a64:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de1a68:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de1a6c:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de1a70:	2a0e      	cmp	r2, #14
c0de1a72:	f200 8404 	bhi.w	c0de227e <nbgl_layoutAddExtendedFooter+0x93a>
c0de1a76:	4606      	mov	r6, r0
c0de1a78:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de1a7a:	3001      	adds	r0, #1
c0de1a7c:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de1a80:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de1a84:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
                                       footerDesc->doubleText.leftToken,
c0de1a88:	f89a c00c 	ldrb.w	ip, [sl, #12]
                                       footerDesc->doubleText.tuneId);
c0de1a8c:	f89a 700e 	ldrb.w	r7, [sl, #14]
        layout->nbUsedCallbackObjs++;
c0de1a90:	0a00      	lsrs	r0, r0, #8
c0de1a92:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de1a96:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de1a9a:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de1a9c:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de1aa0:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
c0de1aa4:	2007      	movs	r0, #7
        layout->nbUsedCallbackObjs++;
c0de1aa6:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
            textArea->obj.alignment   = BOTTOM_LEFT;
c0de1aaa:	75b0      	strb	r0, [r6, #22]
c0de1aac:	2500      	movs	r5, #0
c0de1aae:	f04f 08d0 	mov.w	r8, #208	@ 0xd0
c0de1ab2:	2060      	movs	r0, #96	@ 0x60
            textArea->textColor       = BLACK;
c0de1ab4:	77f5      	strb	r5, [r6, #31]
            textArea->obj.area.width  = AVAILABLE_WIDTH / 2;
c0de1ab6:	7175      	strb	r5, [r6, #5]
c0de1ab8:	f886 8004 	strb.w	r8, [r6, #4]
            textArea->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de1abc:	71f5      	strb	r5, [r6, #7]
c0de1abe:	71b0      	strb	r0, [r6, #6]
            textArea->text            = PIC(footerDesc->doubleText.leftText);
c0de1ac0:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de1ac4:	f007 fa1a 	bl	c0de8efc <pic>
c0de1ac8:	4631      	mov	r1, r6
c0de1aca:	f801 0f26 	strb.w	r0, [r1, #38]!
c0de1ace:	0e02      	lsrs	r2, r0, #24
c0de1ad0:	70ca      	strb	r2, [r1, #3]
c0de1ad2:	0c02      	lsrs	r2, r0, #16
c0de1ad4:	0a00      	lsrs	r0, r0, #8
c0de1ad6:	f04f 0b01 	mov.w	fp, #1
c0de1ada:	708a      	strb	r2, [r1, #2]
c0de1adc:	f886 0027 	strb.w	r0, [r6, #39]	@ 0x27
c0de1ae0:	200c      	movs	r0, #12
            textArea->obj.touchMask   = (1 << TOUCHED);
c0de1ae2:	f886 b01c 	strb.w	fp, [r6, #28]
            textArea->fontId          = SMALL_BOLD_FONT;
c0de1ae6:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1aea:	6920      	ldr	r0, [r4, #16]
c0de1aec:	2205      	movs	r2, #5
c0de1aee:	f810 1f22 	ldrb.w	r1, [r0, #34]!
            textArea->textAlignment   = CENTER;
c0de1af2:	f886 2020 	strb.w	r2, [r6, #32]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1af6:	f810 2c02 	ldrb.w	r2, [r0, #-2]
c0de1afa:	7843      	ldrb	r3, [r0, #1]
c0de1afc:	7887      	ldrb	r7, [r0, #2]
c0de1afe:	78c0      	ldrb	r0, [r0, #3]
c0de1b00:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de1b04:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de1b08:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
                = (nbgl_obj_t *) textArea;
c0de1b0c:	f840 6022 	str.w	r6, [r0, r2, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de1b10:	6920      	ldr	r0, [r4, #16]
            textArea->obj.touchMask   = (1 << TOUCHED);
c0de1b12:	7775      	strb	r5, [r6, #29]
            layoutInt->footerContainer->nbChildren++;
c0de1b14:	f890 1020 	ldrb.w	r1, [r0, #32]
            textArea->obj.touchId     = BOTTOM_BUTTON_ID;
c0de1b18:	f886 b01e 	strb.w	fp, [r6, #30]
            layoutInt->footerContainer->nbChildren++;
c0de1b1c:	3101      	adds	r1, #1
c0de1b1e:	f880 1020 	strb.w	r1, [r0, #32]
            textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de1b22:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1b26:	08c1      	lsrs	r1, r0, #3
c0de1b28:	2004      	movs	r0, #4
c0de1b2a:	f006 faf4 	bl	c0de8116 <nbgl_objPoolGet>
                                       footerDesc->doubleText.rightToken,
c0de1b2e:	f89a 200d 	ldrb.w	r2, [sl, #13]
                                       footerDesc->doubleText.tuneId);
c0de1b32:	f89a 300e 	ldrb.w	r3, [sl, #14]
            textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de1b36:	4606      	mov	r6, r0
            obj      = layoutAddCallbackObj(layoutInt,
c0de1b38:	4620      	mov	r0, r4
c0de1b3a:	4631      	mov	r1, r6
c0de1b3c:	f7fe fe9c 	bl	c0de0878 <layoutAddCallbackObj>
            if (obj == NULL) {
c0de1b40:	2800      	cmp	r0, #0
c0de1b42:	f04f 37ff 	mov.w	r7, #4294967295	@ 0xffffffff
c0de1b46:	f000 839c 	beq.w	c0de2282 <nbgl_layoutAddExtendedFooter+0x93e>
c0de1b4a:	2009      	movs	r0, #9
            textArea->obj.alignment   = BOTTOM_RIGHT;
c0de1b4c:	75b0      	strb	r0, [r6, #22]
            textArea->obj.area.width  = AVAILABLE_WIDTH / 2;
c0de1b4e:	f886 8004 	strb.w	r8, [r6, #4]
            textArea->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de1b52:	46b0      	mov	r8, r6
c0de1b54:	2060      	movs	r0, #96	@ 0x60
c0de1b56:	f808 0f06 	strb.w	r0, [r8, #6]!
            textArea->textColor       = BLACK;
c0de1b5a:	77f5      	strb	r5, [r6, #31]
            textArea->obj.area.width  = AVAILABLE_WIDTH / 2;
c0de1b5c:	7175      	strb	r5, [r6, #5]
            textArea->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de1b5e:	f888 5001 	strb.w	r5, [r8, #1]
            textArea->text            = PIC(footerDesc->doubleText.rightText);
c0de1b62:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de1b66:	f007 f9c9 	bl	c0de8efc <pic>
c0de1b6a:	4631      	mov	r1, r6
c0de1b6c:	f801 0f26 	strb.w	r0, [r1, #38]!
c0de1b70:	0e02      	lsrs	r2, r0, #24
c0de1b72:	70ca      	strb	r2, [r1, #3]
c0de1b74:	0c02      	lsrs	r2, r0, #16
c0de1b76:	0a00      	lsrs	r0, r0, #8
c0de1b78:	708a      	strb	r2, [r1, #2]
c0de1b7a:	f886 0027 	strb.w	r0, [r6, #39]	@ 0x27
            textArea->fontId          = SMALL_BOLD_FONT;
c0de1b7e:	200c      	movs	r0, #12
            textArea->obj.touchMask   = (1 << TOUCHED);
c0de1b80:	f886 b01c 	strb.w	fp, [r6, #28]
            textArea->fontId          = SMALL_BOLD_FONT;
c0de1b84:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1b88:	6920      	ldr	r0, [r4, #16]
            textArea->textAlignment   = CENTER;
c0de1b8a:	2105      	movs	r1, #5
c0de1b8c:	f886 1020 	strb.w	r1, [r6, #32]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1b90:	f810 1f22 	ldrb.w	r1, [r0, #34]!
            textArea->obj.touchMask   = (1 << TOUCHED);
c0de1b94:	7775      	strb	r5, [r6, #29]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1b96:	f810 cc02 	ldrb.w	ip, [r0, #-2]
c0de1b9a:	7843      	ldrb	r3, [r0, #1]
c0de1b9c:	7882      	ldrb	r2, [r0, #2]
c0de1b9e:	78c0      	ldrb	r0, [r0, #3]
c0de1ba0:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de1ba4:	ea42 2000 	orr.w	r0, r2, r0, lsl #8
c0de1ba8:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
                = (nbgl_obj_t *) textArea;
c0de1bac:	f840 602c 	str.w	r6, [r0, ip, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de1bb0:	6920      	ldr	r0, [r4, #16]
c0de1bb2:	2103      	movs	r1, #3
c0de1bb4:	f890 2020 	ldrb.w	r2, [r0, #32]
            textArea->obj.touchId     = RIGHT_BUTTON_ID;
c0de1bb8:	77b1      	strb	r1, [r6, #30]
            layoutInt->footerContainer->nbChildren++;
c0de1bba:	1c51      	adds	r1, r2, #1
c0de1bbc:	f880 1020 	strb.w	r1, [r0, #32]
            layoutInt->footerContainer->obj.area.height = textArea->obj.area.height;
c0de1bc0:	f898 1001 	ldrb.w	r1, [r8, #1]
c0de1bc4:	f898 2000 	ldrb.w	r2, [r8]
c0de1bc8:	71c1      	strb	r1, [r0, #7]
c0de1bca:	7182      	strb	r2, [r0, #6]
            separationLine            = (nbgl_line_t *) nbgl_objPoolGet(LINE, layoutInt->layer);
c0de1bcc:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1bd0:	08c1      	lsrs	r1, r0, #3
c0de1bd2:	2003      	movs	r0, #3
c0de1bd4:	f006 fa9f 	bl	c0de8116 <nbgl_objPoolGet>
c0de1bd8:	4680      	mov	r8, r0
c0de1bda:	2002      	movs	r0, #2
            separationLine->obj.area.width       = 1;
c0de1bdc:	f888 b004 	strb.w	fp, [r8, #4]
            separationLine->lineColor = LIGHT_GRAY;
c0de1be0:	f888 0020 	strb.w	r0, [r8, #32]
            separationLine->obj.area.height      = layoutInt->footerContainer->obj.area.height;
c0de1be4:	6920      	ldr	r0, [r4, #16]
            separationLine->obj.area.width       = 1;
c0de1be6:	f888 5005 	strb.w	r5, [r8, #5]
            separationLine->obj.area.height      = layoutInt->footerContainer->obj.area.height;
c0de1bea:	79c1      	ldrb	r1, [r0, #7]
c0de1bec:	7980      	ldrb	r0, [r0, #6]
c0de1bee:	f888 1007 	strb.w	r1, [r8, #7]
c0de1bf2:	f888 0006 	strb.w	r0, [r8, #6]
            separationLine->obj.alignment        = MID_LEFT;
c0de1bf6:	2004      	movs	r0, #4
c0de1bf8:	f888 0016 	strb.w	r0, [r8, #22]
            separationLine->obj.alignTo          = (nbgl_obj_t *) textArea;
c0de1bfc:	0a30      	lsrs	r0, r6, #8
c0de1bfe:	f888 0013 	strb.w	r0, [r8, #19]
c0de1c02:	4640      	mov	r0, r8
c0de1c04:	f800 6f12 	strb.w	r6, [r0, #18]!
c0de1c08:	0e31      	lsrs	r1, r6, #24
c0de1c0a:	70c1      	strb	r1, [r0, #3]
c0de1c0c:	0c31      	lsrs	r1, r6, #16
c0de1c0e:	7081      	strb	r1, [r0, #2]
c0de1c10:	20ff      	movs	r0, #255	@ 0xff
            separationLine->direction            = VERTICAL;
c0de1c12:	f888 501f 	strb.w	r5, [r8, #31]
            separationLine->thickness            = 1;
c0de1c16:	f888 b021 	strb.w	fp, [r8, #33]	@ 0x21
            separationLine->obj.alignmentMarginX = -1;
c0de1c1a:	f888 0018 	strb.w	r0, [r8, #24]
c0de1c1e:	f888 7017 	strb.w	r7, [r8, #23]
c0de1c22:	e36c      	b.n	c0de22fe <nbgl_layoutAddExtendedFooter+0x9ba>
    switch (footerDesc->type) {
c0de1c24:	2905      	cmp	r1, #5
c0de1c26:	f000 8280 	beq.w	c0de212a <nbgl_layoutAddExtendedFooter+0x7e6>
c0de1c2a:	2906      	cmp	r1, #6
c0de1c2c:	f040 8329 	bne.w	c0de2282 <nbgl_layoutAddExtendedFooter+0x93e>
            if ((footerDesc->choiceButtons.bottomText == NULL)
c0de1c30:	f8da 0008 	ldr.w	r0, [sl, #8]
                || (footerDesc->choiceButtons.topText == NULL)) {
c0de1c34:	2800      	cmp	r0, #0
c0de1c36:	f000 8322 	beq.w	c0de227e <nbgl_layoutAddExtendedFooter+0x93a>
c0de1c3a:	f8da 0004 	ldr.w	r0, [sl, #4]
            if ((footerDesc->choiceButtons.bottomText == NULL)
c0de1c3e:	2800      	cmp	r0, #0
c0de1c40:	f000 831d 	beq.w	c0de227e <nbgl_layoutAddExtendedFooter+0x93a>
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de1c44:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1c48:	08c1      	lsrs	r1, r0, #3
c0de1c4a:	2005      	movs	r0, #5
c0de1c4c:	f006 fa63 	bl	c0de8116 <nbgl_objPoolGet>
                                       footerDesc->choiceButtons.token,
c0de1c50:	f89a 2010 	ldrb.w	r2, [sl, #16]
                                       footerDesc->choiceButtons.tuneId);
c0de1c54:	f89a 3012 	ldrb.w	r3, [sl, #18]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de1c58:	4606      	mov	r6, r0
            obj    = layoutAddCallbackObj(layoutInt,
c0de1c5a:	4620      	mov	r0, r4
c0de1c5c:	4631      	mov	r1, r6
c0de1c5e:	f7fe fe0b 	bl	c0de0878 <layoutAddCallbackObj>
            if (obj == NULL) {
c0de1c62:	2800      	cmp	r0, #0
c0de1c64:	f000 830b 	beq.w	c0de227e <nbgl_layoutAddExtendedFooter+0x93a>
c0de1c68:	f04f 0801 	mov.w	r8, #1
            obj->index = 1;
c0de1c6c:	f880 8005 	strb.w	r8, [r0, #5]
c0de1c70:	2008      	movs	r0, #8
            button->obj.alignment = BOTTOM_MIDDLE;
c0de1c72:	75b0      	strb	r0, [r6, #22]
c0de1c74:	2003      	movs	r0, #3
            button->innerColor    = WHITE;
c0de1c76:	77f0      	strb	r0, [r6, #31]
            if (footerDesc->choiceButtons.style == BOTH_ROUNDED_STYLE) {
c0de1c78:	f89a 1011 	ldrb.w	r1, [sl, #17]
c0de1c7c:	2204      	movs	r2, #4
c0de1c7e:	2903      	cmp	r1, #3
c0de1c80:	f04f 0104 	mov.w	r1, #4
c0de1c84:	bf04      	itt	eq
c0de1c86:	2118      	moveq	r1, #24
c0de1c88:	2002      	moveq	r0, #2
c0de1c8a:	f886 0020 	strb.w	r0, [r6, #32]
c0de1c8e:	2058      	movs	r0, #88	@ 0x58
c0de1c90:	2700      	movs	r7, #0
c0de1c92:	71b0      	strb	r0, [r6, #6]
c0de1c94:	20a0      	movs	r0, #160	@ 0xa0
c0de1c96:	76b7      	strb	r7, [r6, #26]
c0de1c98:	7671      	strb	r1, [r6, #25]
c0de1c9a:	71f7      	strb	r7, [r6, #7]
            button->foregroundColor = BLACK;
c0de1c9c:	f886 7021 	strb.w	r7, [r6, #33]	@ 0x21
            button->obj.area.width  = AVAILABLE_WIDTH;
c0de1ca0:	f886 8005 	strb.w	r8, [r6, #5]
c0de1ca4:	7130      	strb	r0, [r6, #4]
            button->radius          = BUTTON_RADIUS;
c0de1ca6:	f886 2022 	strb.w	r2, [r6, #34]	@ 0x22
            button->text            = PIC(footerDesc->choiceButtons.bottomText);
c0de1caa:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de1cae:	f007 f925 	bl	c0de8efc <pic>
c0de1cb2:	4631      	mov	r1, r6
c0de1cb4:	f801 0f25 	strb.w	r0, [r1, #37]!
c0de1cb8:	0e02      	lsrs	r2, r0, #24
c0de1cba:	70ca      	strb	r2, [r1, #3]
c0de1cbc:	0c02      	lsrs	r2, r0, #16
c0de1cbe:	0a00      	lsrs	r0, r0, #8
c0de1cc0:	708a      	strb	r2, [r1, #2]
c0de1cc2:	f886 0026 	strb.w	r0, [r6, #38]	@ 0x26
            button->obj.touchMask   = (1 << TOUCHED);
c0de1cc6:	f886 801c 	strb.w	r8, [r6, #28]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1cca:	6921      	ldr	r1, [r4, #16]
c0de1ccc:	200c      	movs	r0, #12
            button->fontId          = SMALL_BOLD_FONT;
c0de1cce:	f886 0023 	strb.w	r0, [r6, #35]	@ 0x23
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1cd2:	f811 0f22 	ldrb.w	r0, [r1, #34]!
            button->obj.touchMask   = (1 << TOUCHED);
c0de1cd6:	7777      	strb	r7, [r6, #29]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1cd8:	f811 2c02 	ldrb.w	r2, [r1, #-2]
c0de1cdc:	784b      	ldrb	r3, [r1, #1]
c0de1cde:	788f      	ldrb	r7, [r1, #2]
c0de1ce0:	78c9      	ldrb	r1, [r1, #3]
c0de1ce2:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de1ce6:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de1cea:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
                = (nbgl_obj_t *) button;
c0de1cee:	f840 6022 	str.w	r6, [r0, r2, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de1cf2:	6920      	ldr	r0, [r4, #16]
c0de1cf4:	210a      	movs	r1, #10
c0de1cf6:	f890 2020 	ldrb.w	r2, [r0, #32]
            button->obj.touchId     = CHOICE_2_ID;
c0de1cfa:	77b1      	strb	r1, [r6, #30]
            layoutInt->footerContainer->nbChildren++;
c0de1cfc:	1c51      	adds	r1, r2, #1
c0de1cfe:	f880 1020 	strb.w	r1, [r0, #32]
            if ((footerDesc->choiceButtons.style != ROUNDED_AND_FOOTER_STYLE)
c0de1d02:	f89a 0011 	ldrb.w	r0, [sl, #17]
                && (footerDesc->choiceButtons.style != BOTH_ROUNDED_STYLE)) {
c0de1d06:	b3c0      	cbz	r0, c0de1d7a <nbgl_layoutAddExtendedFooter+0x436>
c0de1d08:	2803      	cmp	r0, #3
c0de1d0a:	d036      	beq.n	c0de1d7a <nbgl_layoutAddExtendedFooter+0x436>
                line                = createHorizontalLine(layoutInt->layer);
c0de1d0c:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1d10:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de1d12:	2003      	movs	r0, #3
c0de1d14:	f006 f9ff 	bl	c0de8116 <nbgl_objPoolGet>
c0de1d18:	22e0      	movs	r2, #224	@ 0xe0
    line->obj.area.width  = SCREEN_WIDTH;
c0de1d1a:	7102      	strb	r2, [r0, #4]
c0de1d1c:	2200      	movs	r2, #0
    line->obj.area.height = 1;
c0de1d1e:	71c2      	strb	r2, [r0, #7]
                line->obj.alignTo   = (nbgl_obj_t *) button;
c0de1d20:	0a32      	lsrs	r2, r6, #8
c0de1d22:	74c2      	strb	r2, [r0, #19]
c0de1d24:	4602      	mov	r2, r0
c0de1d26:	f04f 0c01 	mov.w	ip, #1
c0de1d2a:	f802 6f12 	strb.w	r6, [r2, #18]!
c0de1d2e:	0c33      	lsrs	r3, r6, #16
    line->obj.area.height = 1;
c0de1d30:	f880 c006 	strb.w	ip, [r0, #6]
                line->obj.alignTo   = (nbgl_obj_t *) button;
c0de1d34:	7093      	strb	r3, [r2, #2]
                layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1d36:	6923      	ldr	r3, [r4, #16]
                line->obj.alignTo   = (nbgl_obj_t *) button;
c0de1d38:	0e37      	lsrs	r7, r6, #24
                layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1d3a:	f813 6f22 	ldrb.w	r6, [r3, #34]!
                line->obj.alignTo   = (nbgl_obj_t *) button;
c0de1d3e:	70d7      	strb	r7, [r2, #3]
                layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1d40:	785a      	ldrb	r2, [r3, #1]
c0de1d42:	789f      	ldrb	r7, [r3, #2]
c0de1d44:	78d9      	ldrb	r1, [r3, #3]
c0de1d46:	ea46 2202 	orr.w	r2, r6, r2, lsl #8
c0de1d4a:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de1d4e:	f813 3c02 	ldrb.w	r3, [r3, #-2]
c0de1d52:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
                    = (nbgl_obj_t *) line;
c0de1d56:	f841 0023 	str.w	r0, [r1, r3, lsl #2]
                layoutInt->footerContainer->nbChildren++;
c0de1d5a:	6921      	ldr	r1, [r4, #16]
c0de1d5c:	2702      	movs	r7, #2
c0de1d5e:	f891 2020 	ldrb.w	r2, [r1, #32]
    line->lineColor       = LIGHT_GRAY;
c0de1d62:	f880 7020 	strb.w	r7, [r0, #32]
    line->obj.area.width  = SCREEN_WIDTH;
c0de1d66:	f880 c005 	strb.w	ip, [r0, #5]
    line->direction       = HORIZONTAL;
c0de1d6a:	f880 c01f 	strb.w	ip, [r0, #31]
    line->thickness       = 1;
c0de1d6e:	f880 c021 	strb.w	ip, [r0, #33]	@ 0x21
                line->obj.alignment = TOP_MIDDLE;
c0de1d72:	7587      	strb	r7, [r0, #22]
                layoutInt->footerContainer->nbChildren++;
c0de1d74:	1c50      	adds	r0, r2, #1
c0de1d76:	f881 0020 	strb.w	r0, [r1, #32]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de1d7a:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1d7e:	08c1      	lsrs	r1, r0, #3
c0de1d80:	2005      	movs	r0, #5
c0de1d82:	f006 f9c8 	bl	c0de8116 <nbgl_objPoolGet>
                                       footerDesc->choiceButtons.token,
c0de1d86:	f89a 2010 	ldrb.w	r2, [sl, #16]
                                       footerDesc->choiceButtons.tuneId);
c0de1d8a:	f89a 3012 	ldrb.w	r3, [sl, #18]
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de1d8e:	4606      	mov	r6, r0
            obj    = layoutAddCallbackObj(layoutInt,
c0de1d90:	4620      	mov	r0, r4
c0de1d92:	4631      	mov	r1, r6
c0de1d94:	f7fe fd70 	bl	c0de0878 <layoutAddCallbackObj>
            if (obj == NULL) {
c0de1d98:	2800      	cmp	r0, #0
c0de1d9a:	f000 8270 	beq.w	c0de227e <nbgl_layoutAddExtendedFooter+0x93a>
c0de1d9e:	2700      	movs	r7, #0
            obj->index            = 0;
c0de1da0:	7147      	strb	r7, [r0, #5]
c0de1da2:	2002      	movs	r0, #2
            button->obj.alignment = TOP_MIDDLE;
c0de1da4:	75b0      	strb	r0, [r6, #22]
c0de1da6:	2018      	movs	r0, #24
c0de1da8:	76b7      	strb	r7, [r6, #26]
c0de1daa:	7670      	strb	r0, [r6, #25]
            if (footerDesc->choiceButtons.style == SOFT_ACTION_AND_FOOTER_STYLE) {
c0de1dac:	f89a 0011 	ldrb.w	r0, [sl, #17]
c0de1db0:	2200      	movs	r2, #0
c0de1db2:	1e81      	subs	r1, r0, #2
c0de1db4:	bf08      	it	eq
c0de1db6:	2203      	moveq	r2, #3
c0de1db8:	3802      	subs	r0, #2
c0de1dba:	bf18      	it	ne
c0de1dbc:	2003      	movne	r0, #3
c0de1dbe:	fab1 f181 	clz	r1, r1
c0de1dc2:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
c0de1dc6:	20a0      	movs	r0, #160	@ 0xa0
c0de1dc8:	0949      	lsrs	r1, r1, #5
            button->obj.area.width  = AVAILABLE_WIDTH;
c0de1dca:	7130      	strb	r0, [r6, #4]
c0de1dcc:	2058      	movs	r0, #88	@ 0x58
            if (footerDesc->choiceButtons.style == SOFT_ACTION_AND_FOOTER_STYLE) {
c0de1dce:	0049      	lsls	r1, r1, #1
c0de1dd0:	f04f 0801 	mov.w	r8, #1
            button->obj.area.height = BUTTON_DIAMETER;
c0de1dd4:	71b0      	strb	r0, [r6, #6]
c0de1dd6:	2004      	movs	r0, #4
c0de1dd8:	77f2      	strb	r2, [r6, #31]
c0de1dda:	f886 1020 	strb.w	r1, [r6, #32]
            button->obj.area.width  = AVAILABLE_WIDTH;
c0de1dde:	f886 8005 	strb.w	r8, [r6, #5]
            button->obj.area.height = BUTTON_DIAMETER;
c0de1de2:	71f7      	strb	r7, [r6, #7]
            button->radius          = BUTTON_RADIUS;
c0de1de4:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
            button->text            = PIC(footerDesc->choiceButtons.topText);
c0de1de8:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de1dec:	f007 f886 	bl	c0de8efc <pic>
c0de1df0:	4631      	mov	r1, r6
c0de1df2:	f801 0f25 	strb.w	r0, [r1, #37]!
c0de1df6:	0e02      	lsrs	r2, r0, #24
c0de1df8:	70ca      	strb	r2, [r1, #3]
c0de1dfa:	0c02      	lsrs	r2, r0, #16
c0de1dfc:	0a00      	lsrs	r0, r0, #8
c0de1dfe:	708a      	strb	r2, [r1, #2]
c0de1e00:	7048      	strb	r0, [r1, #1]
            button->icon            = (footerDesc->choiceButtons.style != ROUNDED_AND_FOOTER_STYLE)
c0de1e02:	f89a 0011 	ldrb.w	r0, [sl, #17]
c0de1e06:	2800      	cmp	r0, #0
c0de1e08:	f000 823f 	beq.w	c0de228a <nbgl_layoutAddExtendedFooter+0x946>
                                          ? PIC(footerDesc->choiceButtons.topIcon)
c0de1e0c:	f8da 000c 	ldr.w	r0, [sl, #12]
c0de1e10:	f007 f874 	bl	c0de8efc <pic>
c0de1e14:	e23a      	b.n	c0de228c <nbgl_layoutAddExtendedFooter+0x948>
c0de1e16:	f04f 0800 	mov.w	r8, #0
c0de1e1a:	f04f 0b60 	mov.w	fp, #96	@ 0x60
            layoutInt->footerContainer->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de1e1e:	f880 8007 	strb.w	r8, [r0, #7]
c0de1e22:	f880 b006 	strb.w	fp, [r0, #6]
            textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de1e26:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1e2a:	08c1      	lsrs	r1, r0, #3
c0de1e2c:	2004      	movs	r0, #4
c0de1e2e:	f006 f972 	bl	c0de8116 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de1e32:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de1e36:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de1e3a:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de1e3e:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de1e42:	2a0e      	cmp	r2, #14
c0de1e44:	f200 821b 	bhi.w	c0de227e <nbgl_layoutAddExtendedFooter+0x93a>
c0de1e48:	4607      	mov	r7, r0
c0de1e4a:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de1e4c:	3001      	adds	r0, #1
c0de1e4e:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de1e52:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de1e56:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
                                       footerDesc->textAndNav.token,
c0de1e5a:	f89a c014 	ldrb.w	ip, [sl, #20]
                                       footerDesc->textAndNav.tuneId);
c0de1e5e:	f89a 6015 	ldrb.w	r6, [sl, #21]
        layout->nbUsedCallbackObjs++;
c0de1e62:	0a00      	lsrs	r0, r0, #8
c0de1e64:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de1e68:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de1e6c:	6207      	str	r7, [r0, #32]
        layoutObj->token  = token;
c0de1e6e:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de1e72:	f880 6026 	strb.w	r6, [r0, #38]	@ 0x26
c0de1e76:	2007      	movs	r0, #7
        layout->nbUsedCallbackObjs++;
c0de1e78:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
            textArea->obj.alignment   = BOTTOM_LEFT;
c0de1e7c:	75b8      	strb	r0, [r7, #22]
c0de1e7e:	20c0      	movs	r0, #192	@ 0xc0
            textArea->obj.area.width  = FOOTER_TEXT_AND_NAV_WIDTH;
c0de1e80:	463d      	mov	r5, r7
c0de1e82:	f805 0f04 	strb.w	r0, [r5, #4]!
            textArea->textColor       = BLACK;
c0de1e86:	f887 801f 	strb.w	r8, [r7, #31]
            textArea->obj.area.width  = FOOTER_TEXT_AND_NAV_WIDTH;
c0de1e8a:	f885 8001 	strb.w	r8, [r5, #1]
            textArea->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de1e8e:	f887 8007 	strb.w	r8, [r7, #7]
c0de1e92:	f887 b006 	strb.w	fp, [r7, #6]
            textArea->text            = PIC(footerDesc->textAndNav.text);
c0de1e96:	f8da 0010 	ldr.w	r0, [sl, #16]
c0de1e9a:	f10a 0104 	add.w	r1, sl, #4
c0de1e9e:	9101      	str	r1, [sp, #4]
c0de1ea0:	f007 f82c 	bl	c0de8efc <pic>
c0de1ea4:	4639      	mov	r1, r7
c0de1ea6:	f801 0f26 	strb.w	r0, [r1, #38]!
c0de1eaa:	0e02      	lsrs	r2, r0, #24
c0de1eac:	70ca      	strb	r2, [r1, #3]
c0de1eae:	0c02      	lsrs	r2, r0, #16
c0de1eb0:	0a00      	lsrs	r0, r0, #8
c0de1eb2:	f887 0027 	strb.w	r0, [r7, #39]	@ 0x27
c0de1eb6:	200c      	movs	r0, #12
            textArea->fontId          = SMALL_BOLD_FONT;
c0de1eb8:	f887 0022 	strb.w	r0, [r7, #34]	@ 0x22
c0de1ebc:	2001      	movs	r0, #1
            textArea->text            = PIC(footerDesc->textAndNav.text);
c0de1ebe:	708a      	strb	r2, [r1, #2]
            textArea->obj.touchMask   = (1 << TOUCHED);
c0de1ec0:	7738      	strb	r0, [r7, #28]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1ec2:	6920      	ldr	r0, [r4, #16]
c0de1ec4:	2105      	movs	r1, #5
c0de1ec6:	f810 2f22 	ldrb.w	r2, [r0, #34]!
            textArea->textAlignment   = CENTER;
c0de1eca:	f887 1020 	strb.w	r1, [r7, #32]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1ece:	f810 1c02 	ldrb.w	r1, [r0, #-2]
c0de1ed2:	7843      	ldrb	r3, [r0, #1]
c0de1ed4:	7886      	ldrb	r6, [r0, #2]
c0de1ed6:	78c0      	ldrb	r0, [r0, #3]
c0de1ed8:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de1edc:	ea46 2000 	orr.w	r0, r6, r0, lsl #8
c0de1ee0:	ea42 4000 	orr.w	r0, r2, r0, lsl #16
                = (nbgl_obj_t *) textArea;
c0de1ee4:	f840 7021 	str.w	r7, [r0, r1, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de1ee8:	6920      	ldr	r0, [r4, #16]
c0de1eea:	f04f 0c01 	mov.w	ip, #1
c0de1eee:	f890 1020 	ldrb.w	r1, [r0, #32]
            textArea->obj.touchMask   = (1 << TOUCHED);
c0de1ef2:	f887 801d 	strb.w	r8, [r7, #29]
            layoutInt->footerContainer->nbChildren++;
c0de1ef6:	3101      	adds	r1, #1
            textArea->obj.touchId     = BOTTOM_BUTTON_ID;
c0de1ef8:	f887 c01e 	strb.w	ip, [r7, #30]
            layoutInt->footerContainer->nbChildren++;
c0de1efc:	f880 1020 	strb.w	r1, [r0, #32]
                = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de1f00:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1f04:	2601      	movs	r6, #1
c0de1f06:	08c1      	lsrs	r1, r0, #3
c0de1f08:	2001      	movs	r0, #1
c0de1f0a:	f006 f904 	bl	c0de8116 <nbgl_objPoolGet>
c0de1f0e:	4683      	mov	fp, r0
c0de1f10:	20a0      	movs	r0, #160	@ 0xa0
            navContainer->obj.area.width = AVAILABLE_WIDTH;
c0de1f12:	465f      	mov	r7, fp
c0de1f14:	f807 0f04 	strb.w	r0, [r7, #4]!
            navContainer->nbChildren     = 4;
c0de1f18:	2004      	movs	r0, #4
            navContainer->obj.area.width = AVAILABLE_WIDTH;
c0de1f1a:	707e      	strb	r6, [r7, #1]
            navContainer->layout         = VERTICAL;
c0de1f1c:	f88b 801f 	strb.w	r8, [fp, #31]
            navContainer->nbChildren     = 4;
c0de1f20:	f88b 0020 	strb.w	r0, [fp, #32]
                = (nbgl_obj_t **) nbgl_containerPoolGet(navContainer->nbChildren, layoutInt->layer);
c0de1f24:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1f28:	08c1      	lsrs	r1, r0, #3
c0de1f2a:	2004      	movs	r0, #4
c0de1f2c:	f006 f8f8 	bl	c0de8120 <nbgl_containerPoolGet>
c0de1f30:	4659      	mov	r1, fp
c0de1f32:	f801 0f22 	strb.w	r0, [r1, #34]!
c0de1f36:	0e02      	lsrs	r2, r0, #24
c0de1f38:	70ca      	strb	r2, [r1, #3]
c0de1f3a:	0c02      	lsrs	r2, r0, #16
c0de1f3c:	0a00      	lsrs	r0, r0, #8
c0de1f3e:	708a      	strb	r2, [r1, #2]
c0de1f40:	f88b 0023 	strb.w	r0, [fp, #35]	@ 0x23
            navContainer->obj.area.width  = SCREEN_WIDTH - textArea->obj.area.width;
c0de1f44:	7829      	ldrb	r1, [r5, #0]
c0de1f46:	786a      	ldrb	r2, [r5, #1]
c0de1f48:	2009      	movs	r0, #9
            navContainer->obj.alignment   = BOTTOM_RIGHT;
c0de1f4a:	f88b 0016 	strb.w	r0, [fp, #22]
            navContainer->obj.area.width  = SCREEN_WIDTH - textArea->obj.area.width;
c0de1f4e:	ea41 2002 	orr.w	r0, r1, r2, lsl #8
c0de1f52:	f5c0 70f0 	rsb	r0, r0, #480	@ 0x1e0
c0de1f56:	7038      	strb	r0, [r7, #0]
c0de1f58:	0a00      	lsrs	r0, r0, #8
c0de1f5a:	7078      	strb	r0, [r7, #1]
            navContainer->obj.area.height = SIMPLE_FOOTER_HEIGHT;
c0de1f5c:	2060      	movs	r0, #96	@ 0x60
c0de1f5e:	f88b 8007 	strb.w	r8, [fp, #7]
c0de1f62:	f88b 0006 	strb.w	r0, [fp, #6]
            layoutNavigationPopulate(navContainer, &footerDesc->navigation, layoutInt->layer);
c0de1f66:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1f6a:	9901      	ldr	r1, [sp, #4]
c0de1f6c:	08c2      	lsrs	r2, r0, #3
c0de1f6e:	4658      	mov	r0, fp
c0de1f70:	f002 ff25 	bl	c0de4dbe <layoutNavigationPopulate>
                                       footerDesc->textAndNav.navigation.token,
c0de1f74:	f89a 2004 	ldrb.w	r2, [sl, #4]
                                       footerDesc->textAndNav.navigation.tuneId);
c0de1f78:	f89a 300c 	ldrb.w	r3, [sl, #12]
            obj = layoutAddCallbackObj(layoutInt,
c0de1f7c:	4620      	mov	r0, r4
c0de1f7e:	4659      	mov	r1, fp
c0de1f80:	f7fe fc7a 	bl	c0de0878 <layoutAddCallbackObj>
c0de1f84:	4606      	mov	r6, r0
            if (obj == NULL) {
c0de1f86:	2800      	cmp	r0, #0
c0de1f88:	d050      	beq.n	c0de202c <nbgl_layoutAddExtendedFooter+0x6e8>
            separationLine            = (nbgl_line_t *) nbgl_objPoolGet(LINE, layoutInt->layer);
c0de1f8a:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de1f8e:	08c1      	lsrs	r1, r0, #3
c0de1f90:	2003      	movs	r0, #3
c0de1f92:	f006 f8c0 	bl	c0de8116 <nbgl_objPoolGet>
c0de1f96:	4680      	mov	r8, r0
c0de1f98:	2501      	movs	r5, #1
            separationLine->obj.area.width       = 1;
c0de1f9a:	f888 5004 	strb.w	r5, [r8, #4]
            separationLine->obj.area.height      = layoutInt->footerContainer->obj.area.height;
c0de1f9e:	6921      	ldr	r1, [r4, #16]
c0de1fa0:	2002      	movs	r0, #2
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1fa2:	f811 cf22 	ldrb.w	ip, [r1, #34]!
            separationLine->lineColor = LIGHT_GRAY;
c0de1fa6:	f888 0020 	strb.w	r0, [r8, #32]
            separationLine->obj.area.height      = layoutInt->footerContainer->obj.area.height;
c0de1faa:	f811 0c1b 	ldrb.w	r0, [r1, #-27]
c0de1fae:	2300      	movs	r3, #0
c0de1fb0:	f888 0007 	strb.w	r0, [r8, #7]
c0de1fb4:	2004      	movs	r0, #4
            separationLine->obj.alignment        = MID_LEFT;
c0de1fb6:	f888 0016 	strb.w	r0, [r8, #22]
            separationLine->obj.alignTo          = (nbgl_obj_t *) navContainer;
c0de1fba:	ea4f 201b 	mov.w	r0, fp, lsr #8
            separationLine->obj.area.height      = layoutInt->footerContainer->obj.area.height;
c0de1fbe:	f811 7c1c 	ldrb.w	r7, [r1, #-28]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de1fc2:	f811 ec02 	ldrb.w	lr, [r1, #-2]
c0de1fc6:	784a      	ldrb	r2, [r1, #1]
            separationLine->obj.alignTo          = (nbgl_obj_t *) navContainer;
c0de1fc8:	f888 0013 	strb.w	r0, [r8, #19]
c0de1fcc:	4640      	mov	r0, r8
            separationLine->obj.area.width       = 1;
c0de1fce:	f888 3005 	strb.w	r3, [r8, #5]
            separationLine->direction            = VERTICAL;
c0de1fd2:	f888 301f 	strb.w	r3, [r8, #31]
            separationLine->obj.alignTo          = (nbgl_obj_t *) navContainer;
c0de1fd6:	f800 bf12 	strb.w	fp, [r0, #18]!
c0de1fda:	ea4f 631b 	mov.w	r3, fp, lsr #24
c0de1fde:	70c3      	strb	r3, [r0, #3]
c0de1fe0:	ea4f 431b 	mov.w	r3, fp, lsr #16
c0de1fe4:	7083      	strb	r3, [r0, #2]
c0de1fe6:	20ff      	movs	r0, #255	@ 0xff
            separationLine->obj.alignmentMarginX = -1;
c0de1fe8:	f888 0018 	strb.w	r0, [r8, #24]
c0de1fec:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
            separationLine->obj.area.height      = layoutInt->footerContainer->obj.area.height;
c0de1ff0:	f888 7006 	strb.w	r7, [r8, #6]
            separationLine->thickness            = 1;
c0de1ff4:	f888 5021 	strb.w	r5, [r8, #33]	@ 0x21
            separationLine->obj.alignmentMarginX = -1;
c0de1ff8:	f888 0017 	strb.w	r0, [r8, #23]
            layoutInt->activePage = footerDesc->textAndNav.navigation.activePage;
c0de1ffc:	f89a 0006 	ldrb.w	r0, [sl, #6]
c0de2000:	f884 00a9 	strb.w	r0, [r4, #169]	@ 0xa9
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2004:	78c8      	ldrb	r0, [r1, #3]
c0de2006:	7889      	ldrb	r1, [r1, #2]
            layoutInt->nbPages    = footerDesc->textAndNav.navigation.nbPages;
c0de2008:	f89a 3005 	ldrb.w	r3, [sl, #5]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de200c:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de2010:	ea4c 2102 	orr.w	r1, ip, r2, lsl #8
c0de2014:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
                = (nbgl_obj_t *) navContainer;
c0de2018:	f840 b02e 	str.w	fp, [r0, lr, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de201c:	6920      	ldr	r0, [r4, #16]
            layoutInt->nbPages    = footerDesc->textAndNav.navigation.nbPages;
c0de201e:	f884 30a8 	strb.w	r3, [r4, #168]	@ 0xa8
            layoutInt->footerContainer->nbChildren++;
c0de2022:	f890 1020 	ldrb.w	r1, [r0, #32]
c0de2026:	3101      	adds	r1, #1
c0de2028:	f880 1020 	strb.w	r1, [r0, #32]
c0de202c:	2e00      	cmp	r6, #0
c0de202e:	f040 8166 	bne.w	c0de22fe <nbgl_layoutAddExtendedFooter+0x9ba>
c0de2032:	e124      	b.n	c0de227e <nbgl_layoutAddExtendedFooter+0x93a>
            layoutInt->footerContainer->obj.area.height = footerDesc->emptySpace.height;
c0de2034:	f8ba 1004 	ldrh.w	r1, [sl, #4]
c0de2038:	f04f 0800 	mov.w	r8, #0
c0de203c:	7181      	strb	r1, [r0, #6]
c0de203e:	0a09      	lsrs	r1, r1, #8
c0de2040:	71c1      	strb	r1, [r0, #7]
c0de2042:	e15c      	b.n	c0de22fe <nbgl_layoutAddExtendedFooter+0x9ba>
            textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de2044:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2048:	08c1      	lsrs	r1, r0, #3
c0de204a:	2004      	movs	r0, #4
c0de204c:	f006 f863 	bl	c0de8116 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de2050:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de2054:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de2058:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de205c:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de2060:	2a0e      	cmp	r2, #14
c0de2062:	f200 810c 	bhi.w	c0de227e <nbgl_layoutAddExtendedFooter+0x93a>
c0de2066:	4606      	mov	r6, r0
c0de2068:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de206a:	3001      	adds	r0, #1
c0de206c:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de2070:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de2074:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
                                       footerDesc->simpleText.token,
c0de2078:	f89a c009 	ldrb.w	ip, [sl, #9]
                                       footerDesc->simpleText.tuneId);
c0de207c:	f89a 700a 	ldrb.w	r7, [sl, #10]
        layout->nbUsedCallbackObjs++;
c0de2080:	0a00      	lsrs	r0, r0, #8
c0de2082:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de2086:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de208a:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de208c:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de2090:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
c0de2094:	2008      	movs	r0, #8
        layout->nbUsedCallbackObjs++;
c0de2096:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
            textArea->obj.alignment  = BOTTOM_MIDDLE;
c0de209a:	75b0      	strb	r0, [r6, #22]
            textArea->textColor      = (footerDesc->simpleText.mutedOut) ? LIGHT_TEXT_COLOR : BLACK;
c0de209c:	f89a 0008 	ldrb.w	r0, [sl, #8]
                = (footerDesc->simpleText.mutedOut) ? SMALL_FOOTER_HEIGHT : SIMPLE_FOOTER_HEIGHT;
c0de20a0:	4637      	mov	r7, r6
            textArea->textColor      = (footerDesc->simpleText.mutedOut) ? LIGHT_TEXT_COLOR : BLACK;
c0de20a2:	77f0      	strb	r0, [r6, #31]
c0de20a4:	20a0      	movs	r0, #160	@ 0xa0
            textArea->obj.area.width = AVAILABLE_WIDTH;
c0de20a6:	7130      	strb	r0, [r6, #4]
c0de20a8:	2060      	movs	r0, #96	@ 0x60
c0de20aa:	2501      	movs	r5, #1
                = (footerDesc->simpleText.mutedOut) ? SMALL_FOOTER_HEIGHT : SIMPLE_FOOTER_HEIGHT;
c0de20ac:	f807 0f06 	strb.w	r0, [r7, #6]!
c0de20b0:	f04f 0800 	mov.w	r8, #0
            textArea->obj.area.width = AVAILABLE_WIDTH;
c0de20b4:	7175      	strb	r5, [r6, #5]
                = (footerDesc->simpleText.mutedOut) ? SMALL_FOOTER_HEIGHT : SIMPLE_FOOTER_HEIGHT;
c0de20b6:	f887 8001 	strb.w	r8, [r7, #1]
            textArea->text = PIC(footerDesc->simpleText.text);
c0de20ba:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de20be:	f006 ff1d 	bl	c0de8efc <pic>
c0de20c2:	4631      	mov	r1, r6
c0de20c4:	f801 0f26 	strb.w	r0, [r1, #38]!
c0de20c8:	0e02      	lsrs	r2, r0, #24
c0de20ca:	70ca      	strb	r2, [r1, #3]
c0de20cc:	0c02      	lsrs	r2, r0, #16
c0de20ce:	0a00      	lsrs	r0, r0, #8
c0de20d0:	708a      	strb	r2, [r1, #2]
c0de20d2:	f886 0027 	strb.w	r0, [r6, #39]	@ 0x27
                = (footerDesc->simpleText.mutedOut) ? SMALL_REGULAR_FONT : SMALL_BOLD_FONT;
c0de20d6:	f89a 0008 	ldrb.w	r0, [sl, #8]
c0de20da:	210b      	movs	r1, #11
c0de20dc:	2800      	cmp	r0, #0
c0de20de:	bf08      	it	eq
c0de20e0:	210c      	moveq	r1, #12
            textArea->obj.touchMask = (1 << TOUCHED);
c0de20e2:	7735      	strb	r5, [r6, #28]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de20e4:	6920      	ldr	r0, [r4, #16]
                = (footerDesc->simpleText.mutedOut) ? SMALL_REGULAR_FONT : SMALL_BOLD_FONT;
c0de20e6:	f886 1022 	strb.w	r1, [r6, #34]	@ 0x22
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de20ea:	f810 2f22 	ldrb.w	r2, [r0, #34]!
c0de20ee:	2105      	movs	r1, #5
            textArea->textAlignment = CENTER;
c0de20f0:	f886 1020 	strb.w	r1, [r6, #32]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de20f4:	7841      	ldrb	r1, [r0, #1]
c0de20f6:	7883      	ldrb	r3, [r0, #2]
c0de20f8:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de20fc:	78c2      	ldrb	r2, [r0, #3]
c0de20fe:	f810 0c02 	ldrb.w	r0, [r0, #-2]
c0de2102:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de2106:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
                = (nbgl_obj_t *) textArea;
c0de210a:	f841 6020 	str.w	r6, [r1, r0, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de210e:	6920      	ldr	r0, [r4, #16]
            layoutInt->footerContainer->obj.area.height = textArea->obj.area.height;
c0de2110:	783a      	ldrb	r2, [r7, #0]
            layoutInt->footerContainer->nbChildren++;
c0de2112:	f890 1020 	ldrb.w	r1, [r0, #32]
            textArea->obj.touchMask = (1 << TOUCHED);
c0de2116:	f886 801d 	strb.w	r8, [r6, #29]
            layoutInt->footerContainer->nbChildren++;
c0de211a:	3101      	adds	r1, #1
c0de211c:	f880 1020 	strb.w	r1, [r0, #32]
            layoutInt->footerContainer->obj.area.height = textArea->obj.area.height;
c0de2120:	7879      	ldrb	r1, [r7, #1]
            textArea->obj.touchId   = BOTTOM_BUTTON_ID;
c0de2122:	77b5      	strb	r5, [r6, #30]
            layoutInt->footerContainer->obj.area.height = textArea->obj.area.height;
c0de2124:	71c1      	strb	r1, [r0, #7]
c0de2126:	7182      	strb	r2, [r0, #6]
c0de2128:	e0e9      	b.n	c0de22fe <nbgl_layoutAddExtendedFooter+0x9ba>
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de212a:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de212e:	08c1      	lsrs	r1, r0, #3
c0de2130:	2005      	movs	r0, #5
c0de2132:	f005 fff0 	bl	c0de8116 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de2136:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de213a:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de213e:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de2142:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de2146:	2a0e      	cmp	r2, #14
c0de2148:	f200 8099 	bhi.w	c0de227e <nbgl_layoutAddExtendedFooter+0x93a>
c0de214c:	4607      	mov	r7, r0
c0de214e:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de2150:	3001      	adds	r0, #1
c0de2152:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de2156:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de215a:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
                                       footerDesc->button.token,
c0de215e:	f89a c00c 	ldrb.w	ip, [sl, #12]
                                       footerDesc->button.tuneId);
c0de2162:	f89a 6010 	ldrb.w	r6, [sl, #16]
        layout->nbUsedCallbackObjs++;
c0de2166:	0a00      	lsrs	r0, r0, #8
c0de2168:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de216c:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de2170:	6207      	str	r7, [r0, #32]
        layoutObj->token  = token;
c0de2172:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de2176:	f880 6026 	strb.w	r6, [r0, #38]	@ 0x26
c0de217a:	2008      	movs	r0, #8
        layout->nbUsedCallbackObjs++;
c0de217c:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
            button->obj.alignment        = BOTTOM_MIDDLE;
c0de2180:	75b8      	strb	r0, [r7, #22]
c0de2182:	f04f 0800 	mov.w	r8, #0
c0de2186:	2018      	movs	r0, #24
            button->obj.alignmentMarginY = SINGLE_BUTTON_MARGIN;
c0de2188:	f887 801a 	strb.w	r8, [r7, #26]
c0de218c:	7678      	strb	r0, [r7, #25]
            if (footerDesc->button.style == BLACK_BACKGROUND) {
c0de218e:	f89a 000d 	ldrb.w	r0, [sl, #13]
c0de2192:	2100      	movs	r1, #0
c0de2194:	2800      	cmp	r0, #0
c0de2196:	bf18      	it	ne
c0de2198:	2003      	movne	r0, #3
c0de219a:	bf08      	it	eq
c0de219c:	2103      	moveq	r1, #3
c0de219e:	77f8      	strb	r0, [r7, #31]
c0de21a0:	f887 1021 	strb.w	r1, [r7, #33]	@ 0x21
            if (footerDesc->button.style == NO_BORDER) {
c0de21a4:	f89a 000d 	ldrb.w	r0, [sl, #13]
c0de21a8:	4601      	mov	r1, r0
c0de21aa:	2800      	cmp	r0, #0
c0de21ac:	bf18      	it	ne
c0de21ae:	2101      	movne	r1, #1
c0de21b0:	0049      	lsls	r1, r1, #1
c0de21b2:	2802      	cmp	r0, #2
c0de21b4:	bf08      	it	eq
c0de21b6:	2103      	moveq	r1, #3
c0de21b8:	f887 1020 	strb.w	r1, [r7, #32]
            button->text                                = PIC(footerDesc->button.text);
c0de21bc:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de21c0:	f006 fe9c 	bl	c0de8efc <pic>
c0de21c4:	463e      	mov	r6, r7
c0de21c6:	f806 0f25 	strb.w	r0, [r6, #37]!
c0de21ca:	0e01      	lsrs	r1, r0, #24
c0de21cc:	70f1      	strb	r1, [r6, #3]
c0de21ce:	0c01      	lsrs	r1, r0, #16
c0de21d0:	0a00      	lsrs	r0, r0, #8
c0de21d2:	f887 0026 	strb.w	r0, [r7, #38]	@ 0x26
c0de21d6:	200c      	movs	r0, #12
c0de21d8:	70b1      	strb	r1, [r6, #2]
            button->fontId                              = SMALL_BOLD_FONT;
c0de21da:	f887 0023 	strb.w	r0, [r7, #35]	@ 0x23
            button->icon                                = PIC(footerDesc->button.icon);
c0de21de:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de21e2:	f006 fe8b 	bl	c0de8efc <pic>
c0de21e6:	4639      	mov	r1, r7
c0de21e8:	f801 0f2e 	strb.w	r0, [r1, #46]!
c0de21ec:	0e02      	lsrs	r2, r0, #24
c0de21ee:	70ca      	strb	r2, [r1, #3]
c0de21f0:	0c02      	lsrs	r2, r0, #16
c0de21f2:	0a00      	lsrs	r0, r0, #8
c0de21f4:	f887 002f 	strb.w	r0, [r7, #47]	@ 0x2f
c0de21f8:	2058      	movs	r0, #88	@ 0x58
c0de21fa:	708a      	strb	r2, [r1, #2]
            button->obj.area.height                     = BUTTON_DIAMETER;
c0de21fc:	71b8      	strb	r0, [r7, #6]
            layoutInt->footerContainer->obj.area.height = FOOTER_BUTTON_HEIGHT;
c0de21fe:	6920      	ldr	r0, [r4, #16]
c0de2200:	2104      	movs	r1, #4
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2202:	f810 cf22 	ldrb.w	ip, [r0, #34]!
c0de2206:	2288      	movs	r2, #136	@ 0x88
            button->radius                              = BUTTON_RADIUS;
c0de2208:	f887 1022 	strb.w	r1, [r7, #34]	@ 0x22
            button->obj.area.height                     = BUTTON_DIAMETER;
c0de220c:	f887 8007 	strb.w	r8, [r7, #7]
            layoutInt->footerContainer->obj.area.height = FOOTER_BUTTON_HEIGHT;
c0de2210:	f800 8c1b 	strb.w	r8, [r0, #-27]
c0de2214:	f800 2c1c 	strb.w	r2, [r0, #-28]
            if (footerDesc->button.text == NULL) {
c0de2218:	f8da 2004 	ldr.w	r2, [sl, #4]
c0de221c:	f44f 73d0 	mov.w	r3, #416	@ 0x1a0
c0de2220:	2a00      	cmp	r2, #0
c0de2222:	bf08      	it	eq
c0de2224:	2358      	moveq	r3, #88	@ 0x58
c0de2226:	0a1a      	lsrs	r2, r3, #8
c0de2228:	717a      	strb	r2, [r7, #5]
c0de222a:	2201      	movs	r2, #1
c0de222c:	713b      	strb	r3, [r7, #4]
            button->obj.touchMask = (1 << TOUCHED);
c0de222e:	773a      	strb	r2, [r7, #28]
            button->obj.touchId   = button->text ? SINGLE_BUTTON_ID : BOTTOM_BUTTON_ID;
c0de2230:	7832      	ldrb	r2, [r6, #0]
c0de2232:	78b3      	ldrb	r3, [r6, #2]
c0de2234:	f897 1026 	ldrb.w	r1, [r7, #38]	@ 0x26
c0de2238:	78f6      	ldrb	r6, [r6, #3]
c0de223a:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de223e:	ea43 2206 	orr.w	r2, r3, r6, lsl #8
c0de2242:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de2246:	2900      	cmp	r1, #0
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2248:	7841      	ldrb	r1, [r0, #1]
c0de224a:	7883      	ldrb	r3, [r0, #2]
c0de224c:	78c6      	ldrb	r6, [r0, #3]
c0de224e:	ea4c 2101 	orr.w	r1, ip, r1, lsl #8
c0de2252:	f810 0c02 	ldrb.w	r0, [r0, #-2]
c0de2256:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de225a:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
                = (nbgl_obj_t *) button;
c0de225e:	f841 7020 	str.w	r7, [r1, r0, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de2262:	6920      	ldr	r0, [r4, #16]
c0de2264:	f04f 0207 	mov.w	r2, #7
            button->obj.touchMask = (1 << TOUCHED);
c0de2268:	f887 801d 	strb.w	r8, [r7, #29]
            button->obj.touchId   = button->text ? SINGLE_BUTTON_ID : BOTTOM_BUTTON_ID;
c0de226c:	bf08      	it	eq
c0de226e:	2201      	moveq	r2, #1
            layoutInt->footerContainer->nbChildren++;
c0de2270:	f890 1020 	ldrb.w	r1, [r0, #32]
            button->obj.touchId   = button->text ? SINGLE_BUTTON_ID : BOTTOM_BUTTON_ID;
c0de2274:	77ba      	strb	r2, [r7, #30]
            layoutInt->footerContainer->nbChildren++;
c0de2276:	3101      	adds	r1, #1
c0de2278:	f880 1020 	strb.w	r1, [r0, #32]
c0de227c:	e03f      	b.n	c0de22fe <nbgl_layoutAddExtendedFooter+0x9ba>
c0de227e:	f04f 37ff 	mov.w	r7, #4294967295	@ 0xffffffff
}
c0de2282:	4638      	mov	r0, r7
c0de2284:	b002      	add	sp, #8
c0de2286:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de228a:	2000      	movs	r0, #0
            button->icon            = (footerDesc->choiceButtons.style != ROUNDED_AND_FOOTER_STYLE)
c0de228c:	4631      	mov	r1, r6
c0de228e:	f801 0f2e 	strb.w	r0, [r1, #46]!
c0de2292:	0e02      	lsrs	r2, r0, #24
c0de2294:	70ca      	strb	r2, [r1, #3]
c0de2296:	0c02      	lsrs	r2, r0, #16
c0de2298:	0a00      	lsrs	r0, r0, #8
c0de229a:	708a      	strb	r2, [r1, #2]
c0de229c:	f886 002f 	strb.w	r0, [r6, #47]	@ 0x2f
            button->obj.touchMask   = (1 << TOUCHED);
c0de22a0:	f886 801c 	strb.w	r8, [r6, #28]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de22a4:	6921      	ldr	r1, [r4, #16]
c0de22a6:	200c      	movs	r0, #12
            button->fontId          = SMALL_BOLD_FONT;
c0de22a8:	f886 0023 	strb.w	r0, [r6, #35]	@ 0x23
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de22ac:	f811 0f22 	ldrb.w	r0, [r1, #34]!
            button->obj.touchMask   = (1 << TOUCHED);
c0de22b0:	7777      	strb	r7, [r6, #29]
            layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de22b2:	f811 2c02 	ldrb.w	r2, [r1, #-2]
c0de22b6:	784b      	ldrb	r3, [r1, #1]
c0de22b8:	788f      	ldrb	r7, [r1, #2]
c0de22ba:	78c9      	ldrb	r1, [r1, #3]
c0de22bc:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de22c0:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de22c4:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
                = (nbgl_obj_t *) button;
c0de22c8:	f840 6022 	str.w	r6, [r0, r2, lsl #2]
            layoutInt->footerContainer->nbChildren++;
c0de22cc:	6920      	ldr	r0, [r4, #16]
c0de22ce:	2109      	movs	r1, #9
c0de22d0:	f890 2020 	ldrb.w	r2, [r0, #32]
            button->obj.touchId     = CHOICE_1_ID;
c0de22d4:	77b1      	strb	r1, [r6, #30]
            layoutInt->footerContainer->nbChildren++;
c0de22d6:	1c51      	adds	r1, r2, #1
c0de22d8:	f880 1020 	strb.w	r1, [r0, #32]
            if (footerDesc->choiceButtons.style == ROUNDED_AND_FOOTER_STYLE) {
c0de22dc:	f89a 1011 	ldrb.w	r1, [sl, #17]
c0de22e0:	2903      	cmp	r1, #3
c0de22e2:	d006      	beq.n	c0de22f2 <nbgl_layoutAddExtendedFooter+0x9ae>
c0de22e4:	b929      	cbnz	r1, c0de22f2 <nbgl_layoutAddExtendedFooter+0x9ae>
c0de22e6:	f04f 0800 	mov.w	r8, #0
                layoutInt->footerContainer->obj.area.height = ROUNDED_AND_FOOTER_FOOTER_HEIGHT;
c0de22ea:	f880 8007 	strb.w	r8, [r0, #7]
c0de22ee:	21d0      	movs	r1, #208	@ 0xd0
c0de22f0:	e004      	b.n	c0de22fc <nbgl_layoutAddExtendedFooter+0x9b8>
c0de22f2:	f04f 0800 	mov.w	r8, #0
c0de22f6:	21e8      	movs	r1, #232	@ 0xe8
c0de22f8:	f880 8007 	strb.w	r8, [r0, #7]
c0de22fc:	7181      	strb	r1, [r0, #6]
    if ((footerDesc->type == FOOTER_NAV) || (footerDesc->type == FOOTER_TEXT_AND_NAV)) {
c0de22fe:	f89a 0000 	ldrb.w	r0, [sl]
c0de2302:	3803      	subs	r0, #3
c0de2304:	2801      	cmp	r0, #1
c0de2306:	d829      	bhi.n	c0de235c <nbgl_layoutAddExtendedFooter+0xa18>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de2308:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de230c:	f894 10ae 	ldrb.w	r1, [r4, #174]	@ 0xae
c0de2310:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de2314:	f3c0 2105 	ubfx	r1, r0, #8, #6
c0de2318:	290e      	cmp	r1, #14
c0de231a:	d81f      	bhi.n	c0de235c <nbgl_layoutAddExtendedFooter+0xa18>
c0de231c:	0a02      	lsrs	r2, r0, #8
        layout->nbUsedCallbackObjs++;
c0de231e:	3201      	adds	r2, #1
c0de2320:	f002 023f 	and.w	r2, r2, #63	@ 0x3f
c0de2324:	f400 4340 	and.w	r3, r0, #49152	@ 0xc000
c0de2328:	f89a c004 	ldrb.w	ip, [sl, #4]
c0de232c:	f89a 700c 	ldrb.w	r7, [sl, #12]
    obj = layoutAddCallbackObj(layoutInt, (nbgl_obj_t *) layoutInt->container, token, tuneId);
c0de2330:	f8d4 60a0 	ldr.w	r6, [r4, #160]	@ 0xa0
        layout->nbUsedCallbackObjs++;
c0de2334:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de2338:	0a12      	lsrs	r2, r2, #8
c0de233a:	f884 00ad 	strb.w	r0, [r4, #173]	@ 0xad
        layoutObj->obj    = obj;
c0de233e:	eb04 00c1 	add.w	r0, r4, r1, lsl #3
        layout->nbUsedCallbackObjs++;
c0de2342:	f884 20ae 	strb.w	r2, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de2346:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de2348:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de234c:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
c0de2350:	2006      	movs	r0, #6
    layoutInt->container->obj.touchMask = swipesMask;
c0de2352:	7770      	strb	r0, [r6, #29]
c0de2354:	2000      	movs	r0, #0
c0de2356:	7730      	strb	r0, [r6, #28]
    layoutInt->swipeUsage               = usage;
c0de2358:	f884 00b0 	strb.w	r0, [r4, #176]	@ 0xb0
    if (footerDesc->separationLine) {
c0de235c:	f89a 0001 	ldrb.w	r0, [sl, #1]
c0de2360:	b348      	cbz	r0, c0de23b6 <nbgl_layoutAddExtendedFooter+0xa72>
        line                = createHorizontalLine(layoutInt->layer);
c0de2362:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2366:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de2368:	2003      	movs	r0, #3
c0de236a:	f005 fed4 	bl	c0de8116 <nbgl_objPoolGet>
c0de236e:	2101      	movs	r1, #1
c0de2370:	22e0      	movs	r2, #224	@ 0xe0
    line->obj.area.width  = SCREEN_WIDTH;
c0de2372:	7102      	strb	r2, [r0, #4]
    line->obj.area.height = 1;
c0de2374:	7181      	strb	r1, [r0, #6]
        layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2376:	6922      	ldr	r2, [r4, #16]
c0de2378:	2300      	movs	r3, #0
c0de237a:	f812 7f22 	ldrb.w	r7, [r2, #34]!
    line->obj.area.height = 1;
c0de237e:	71c3      	strb	r3, [r0, #7]
        layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de2380:	7853      	ldrb	r3, [r2, #1]
c0de2382:	7896      	ldrb	r6, [r2, #2]
c0de2384:	78d5      	ldrb	r5, [r2, #3]
c0de2386:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de238a:	ea46 2705 	orr.w	r7, r6, r5, lsl #8
c0de238e:	f812 2c02 	ldrb.w	r2, [r2, #-2]
c0de2392:	ea43 4307 	orr.w	r3, r3, r7, lsl #16
            = (nbgl_obj_t *) line;
c0de2396:	f843 0022 	str.w	r0, [r3, r2, lsl #2]
        layoutInt->footerContainer->nbChildren++;
c0de239a:	6922      	ldr	r2, [r4, #16]
    line->obj.area.width  = SCREEN_WIDTH;
c0de239c:	7141      	strb	r1, [r0, #5]
    line->direction       = HORIZONTAL;
c0de239e:	77c1      	strb	r1, [r0, #31]
    line->thickness       = 1;
c0de23a0:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
        layoutInt->footerContainer->nbChildren++;
c0de23a4:	f892 1020 	ldrb.w	r1, [r2, #32]
c0de23a8:	2602      	movs	r6, #2
    line->lineColor       = LIGHT_GRAY;
c0de23aa:	f880 6020 	strb.w	r6, [r0, #32]
        line->obj.alignment = TOP_MIDDLE;
c0de23ae:	7586      	strb	r6, [r0, #22]
        layoutInt->footerContainer->nbChildren++;
c0de23b0:	1c48      	adds	r0, r1, #1
c0de23b2:	f882 0020 	strb.w	r0, [r2, #32]
    if (separationLine != NULL) {
c0de23b6:	f1b8 0f00 	cmp.w	r8, #0
c0de23ba:	d015      	beq.n	c0de23e8 <nbgl_layoutAddExtendedFooter+0xaa4>
        layoutInt->footerContainer->children[layoutInt->footerContainer->nbChildren]
c0de23bc:	6920      	ldr	r0, [r4, #16]
c0de23be:	f810 1f22 	ldrb.w	r1, [r0, #34]!
c0de23c2:	f810 2c02 	ldrb.w	r2, [r0, #-2]
c0de23c6:	7843      	ldrb	r3, [r0, #1]
c0de23c8:	7887      	ldrb	r7, [r0, #2]
c0de23ca:	78c0      	ldrb	r0, [r0, #3]
c0de23cc:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de23d0:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de23d4:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
            = (nbgl_obj_t *) separationLine;
c0de23d8:	f840 8022 	str.w	r8, [r0, r2, lsl #2]
        layoutInt->footerContainer->nbChildren++;
c0de23dc:	6920      	ldr	r0, [r4, #16]
c0de23de:	f890 1020 	ldrb.w	r1, [r0, #32]
c0de23e2:	3101      	adds	r1, #1
c0de23e4:	f880 1020 	strb.w	r1, [r0, #32]
    layoutInt->children[FOOTER_INDEX] = (nbgl_obj_t *) layoutInt->footerContainer;
c0de23e8:	68a0      	ldr	r0, [r4, #8]
c0de23ea:	6921      	ldr	r1, [r4, #16]
c0de23ec:	60c1      	str	r1, [r0, #12]
    layoutInt->container->obj.area.height -= layoutInt->footerContainer->obj.area.height;
c0de23ee:	6920      	ldr	r0, [r4, #16]
c0de23f0:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
c0de23f4:	f810 2f06 	ldrb.w	r2, [r0, #6]!
c0de23f8:	f811 3f06 	ldrb.w	r3, [r1, #6]!
c0de23fc:	7847      	ldrb	r7, [r0, #1]
c0de23fe:	784e      	ldrb	r6, [r1, #1]
c0de2400:	ea42 2207 	orr.w	r2, r2, r7, lsl #8
c0de2404:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de2408:	1a9a      	subs	r2, r3, r2
c0de240a:	700a      	strb	r2, [r1, #0]
c0de240c:	0a12      	lsrs	r2, r2, #8
c0de240e:	704a      	strb	r2, [r1, #1]
    return layoutInt->footerContainer->obj.area.height;
c0de2410:	7802      	ldrb	r2, [r0, #0]
c0de2412:	7840      	ldrb	r0, [r0, #1]
    layoutInt->footerType = footerDesc->type;
c0de2414:	f89a 1000 	ldrb.w	r1, [sl]
    return layoutInt->footerContainer->obj.area.height;
c0de2418:	ea42 2700 	orr.w	r7, r2, r0, lsl #8
    layoutInt->footerType = footerDesc->type;
c0de241c:	f884 10ab 	strb.w	r1, [r4, #171]	@ 0xab
c0de2420:	e72f      	b.n	c0de2282 <nbgl_layoutAddExtendedFooter+0x93e>

c0de2422 <nbgl_layoutAddBottomButton>:
{
c0de2422:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de2424:	b087      	sub	sp, #28
c0de2426:	4605      	mov	r5, r0
c0de2428:	2005      	movs	r0, #5
c0de242a:	9e0c      	ldr	r6, [sp, #48]	@ 0x30
    footerDesc.type                  = FOOTER_SIMPLE_BUTTON;
c0de242c:	f88d 0004 	strb.w	r0, [sp, #4]
c0de2430:	2700      	movs	r7, #0
    footerDesc.button.icon           = PIC(icon);
c0de2432:	4608      	mov	r0, r1
c0de2434:	4614      	mov	r4, r2
    footerDesc.separationLine        = separationLine;
c0de2436:	f88d 3005 	strb.w	r3, [sp, #5]
    footerDesc.button.fittingContent = false;
c0de243a:	f88d 7012 	strb.w	r7, [sp, #18]
    footerDesc.button.icon           = PIC(icon);
c0de243e:	f006 fd5d 	bl	c0de8efc <pic>
    footerDesc.button.text           = NULL;
c0de2442:	e9cd 7002 	strd	r7, r0, [sp, #8]
c0de2446:	2001      	movs	r0, #1
    footerDesc.button.style          = WHITE_BACKGROUND;
c0de2448:	f88d 0011 	strb.w	r0, [sp, #17]
c0de244c:	a901      	add	r1, sp, #4
    return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de244e:	4628      	mov	r0, r5
    footerDesc.button.token          = token;
c0de2450:	f88d 4010 	strb.w	r4, [sp, #16]
    footerDesc.button.tuneId         = tuneId;
c0de2454:	f88d 6014 	strb.w	r6, [sp, #20]
    return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de2458:	f7ff fa74 	bl	c0de1944 <nbgl_layoutAddExtendedFooter>
c0de245c:	b007      	add	sp, #28
c0de245e:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de2460 <nbgl_layoutAddTouchableBar>:
{
c0de2460:	b510      	push	{r4, lr}
c0de2462:	b088      	sub	sp, #32
c0de2464:	2200      	movs	r2, #0
    listItem_t             itemDesc = {0};
c0de2466:	e9cd 2206 	strd	r2, r2, [sp, #24]
c0de246a:	e9cd 2204 	strd	r2, r2, [sp, #16]
c0de246e:	e9cd 2202 	strd	r2, r2, [sp, #8]
c0de2472:	9201      	str	r2, [sp, #4]
    if (layout == NULL) {
c0de2474:	b310      	cbz	r0, c0de24bc <nbgl_layoutAddTouchableBar+0x5c>
    itemDesc.iconLeft  = barLayout->iconLeft;
c0de2476:	e891 5008 	ldmia.w	r1, {r3, ip, lr}
    itemDesc.subText   = barLayout->subText;
c0de247a:	68cc      	ldr	r4, [r1, #12]
    itemDesc.iconLeft  = barLayout->iconLeft;
c0de247c:	9302      	str	r3, [sp, #8]
    itemDesc.token     = barLayout->token;
c0de247e:	7c4b      	ldrb	r3, [r1, #17]
    itemDesc.iconRight = barLayout->iconRight;
c0de2480:	f8cd e00c 	str.w	lr, [sp, #12]
    itemDesc.token     = barLayout->token;
c0de2484:	f88d 3018 	strb.w	r3, [sp, #24]
    itemDesc.tuneId    = barLayout->tuneId;
c0de2488:	7d0b      	ldrb	r3, [r1, #20]
    itemDesc.text      = barLayout->text;
c0de248a:	f8cd c010 	str.w	ip, [sp, #16]
    itemDesc.tuneId    = barLayout->tuneId;
c0de248e:	f88d 301c 	strb.w	r3, [sp, #28]
    itemDesc.state     = (barLayout->inactive) ? OFF_STATE : ON_STATE;
c0de2492:	7c8b      	ldrb	r3, [r1, #18]
    itemDesc.large     = barLayout->large;
c0de2494:	7c09      	ldrb	r1, [r1, #16]
    itemDesc.state     = (barLayout->inactive) ? OFF_STATE : ON_STATE;
c0de2496:	f083 0301 	eor.w	r3, r3, #1
    itemDesc.large     = barLayout->large;
c0de249a:	f88d 101a 	strb.w	r1, [sp, #26]
c0de249e:	a901      	add	r1, sp, #4
    itemDesc.state     = (barLayout->inactive) ? OFF_STATE : ON_STATE;
c0de24a0:	f88d 3019 	strb.w	r3, [sp, #25]
    itemDesc.subText   = barLayout->subText;
c0de24a4:	9405      	str	r4, [sp, #20]
    itemDesc.type      = TOUCHABLE_BAR_ITEM;
c0de24a6:	f88d 2004 	strb.w	r2, [sp, #4]
    container          = addListItem(layoutInt, &itemDesc);
c0de24aa:	f000 f80b 	bl	c0de24c4 <addListItem>
    if (container == NULL) {
c0de24ae:	b128      	cbz	r0, c0de24bc <nbgl_layoutAddTouchableBar+0x5c>
    return container->obj.area.height;
c0de24b0:	7981      	ldrb	r1, [r0, #6]
c0de24b2:	79c0      	ldrb	r0, [r0, #7]
c0de24b4:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
}
c0de24b8:	b008      	add	sp, #32
c0de24ba:	bd10      	pop	{r4, pc}
c0de24bc:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de24c0:	b008      	add	sp, #32
c0de24c2:	bd10      	pop	{r4, pc}

c0de24c4 <addListItem>:
{
c0de24c4:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de24c8:	468a      	mov	sl, r1
    color_t color = ((itemDesc->type == TOUCHABLE_BAR_ITEM) && (itemDesc->state == OFF_STATE))
c0de24ca:	7809      	ldrb	r1, [r1, #0]
c0de24cc:	4683      	mov	fp, r0
c0de24ce:	b109      	cbz	r1, c0de24d4 <addListItem+0x10>
c0de24d0:	2600      	movs	r6, #0
c0de24d2:	e004      	b.n	c0de24de <addListItem+0x1a>
c0de24d4:	f89a 0015 	ldrb.w	r0, [sl, #21]
c0de24d8:	fab0 f080 	clz	r0, r0
c0de24dc:	0946      	lsrs	r6, r0, #5
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de24de:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
    color_t color = ((itemDesc->type == TOUCHABLE_BAR_ITEM) && (itemDesc->state == OFF_STATE))
c0de24e2:	2e00      	cmp	r6, #0
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de24e4:	ea4f 01d0 	mov.w	r1, r0, lsr #3
c0de24e8:	f04f 0001 	mov.w	r0, #1
    color_t color = ((itemDesc->type == TOUCHABLE_BAR_ITEM) && (itemDesc->state == OFF_STATE))
c0de24ec:	bf18      	it	ne
c0de24ee:	2602      	movne	r6, #2
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de24f0:	f005 fe11 	bl	c0de8116 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de24f4:	f89b 10ad 	ldrb.w	r1, [fp, #173]	@ 0xad
c0de24f8:	f89b 20ae 	ldrb.w	r2, [fp, #174]	@ 0xae
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de24fc:	4680      	mov	r8, r0
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de24fe:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de2502:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de2506:	2a0e      	cmp	r2, #14
c0de2508:	d817      	bhi.n	c0de253a <addListItem+0x76>
c0de250a:	0a0b      	lsrs	r3, r1, #8
        layoutObj = &layout->callbackObjPool[layout->nbUsedCallbackObjs];
c0de250c:	eb0b 00c2 	add.w	r0, fp, r2, lsl #3
        layout->nbUsedCallbackObjs++;
c0de2510:	1c5a      	adds	r2, r3, #1
c0de2512:	f002 023f 	and.w	r2, r2, #63	@ 0x3f
c0de2516:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
        layoutInt, (nbgl_obj_t *) container, itemDesc->token, itemDesc->tuneId);
c0de251a:	f89a 7014 	ldrb.w	r7, [sl, #20]
c0de251e:	f89a 5018 	ldrb.w	r5, [sl, #24]
        layout->nbUsedCallbackObjs++;
c0de2522:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
        layoutObj->obj    = obj;
c0de2526:	f840 8f20 	str.w	r8, [r0, #32]!
        layout->nbUsedCallbackObjs++;
c0de252a:	0a12      	lsrs	r2, r2, #8
c0de252c:	f88b 20ae 	strb.w	r2, [fp, #174]	@ 0xae
c0de2530:	f88b 10ad 	strb.w	r1, [fp, #173]	@ 0xad
        layoutObj->token  = token;
c0de2534:	7107      	strb	r7, [r0, #4]
        layoutObj->tuneId = tuneId;
c0de2536:	7185      	strb	r5, [r0, #6]
c0de2538:	e000      	b.n	c0de253c <addListItem+0x78>
c0de253a:	2000      	movs	r0, #0
    if (obj == NULL) {
c0de253c:	2800      	cmp	r0, #0
c0de253e:	f04f 0500 	mov.w	r5, #0
c0de2542:	f000 8097 	beq.w	c0de2674 <addListItem+0x1b0>
    obj->index = itemDesc->index;
c0de2546:	f89a 1017 	ldrb.w	r1, [sl, #23]
c0de254a:	7141      	strb	r1, [r0, #5]
    container->children   = nbgl_containerPoolGet(4, layoutInt->layer);
c0de254c:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
c0de2550:	08c1      	lsrs	r1, r0, #3
c0de2552:	2004      	movs	r0, #4
c0de2554:	f005 fde4 	bl	c0de8120 <nbgl_containerPoolGet>
c0de2558:	4641      	mov	r1, r8
c0de255a:	f801 0f22 	strb.w	r0, [r1, #34]!
c0de255e:	0e02      	lsrs	r2, r0, #24
    container->obj.alignTo          = NULL;
c0de2560:	f801 5d10 	strb.w	r5, [r1, #-16]!
    container->children   = nbgl_containerPoolGet(4, layoutInt->layer);
c0de2564:	74ca      	strb	r2, [r1, #19]
c0de2566:	0c02      	lsrs	r2, r0, #16
c0de2568:	748a      	strb	r2, [r1, #18]
c0de256a:	0a00      	lsrs	r0, r0, #8
c0de256c:	22a0      	movs	r2, #160	@ 0xa0
c0de256e:	7448      	strb	r0, [r1, #17]
    container->obj.area.width = AVAILABLE_WIDTH;
c0de2570:	f801 2c0e 	strb.w	r2, [r1, #-14]
          + 2 * (itemDesc->large ? LIST_ITEM_PRE_HEADING_LARGE : LIST_ITEM_PRE_HEADING);
c0de2574:	f89a 3016 	ldrb.w	r3, [sl, #22]
    if (((itemDesc->type == TOUCHABLE_BAR_ITEM) && (itemDesc->state == ON_STATE))
c0de2578:	f89a 2000 	ldrb.w	r2, [sl]
c0de257c:	2001      	movs	r0, #1
c0de257e:	2764      	movs	r7, #100	@ 0x64
        = LIST_ITEM_MIN_TEXT_HEIGHT
c0de2580:	2b00      	cmp	r3, #0
    container->nbChildren = 0;
c0de2582:	738d      	strb	r5, [r1, #14]
    container->obj.area.width = AVAILABLE_WIDTH;
c0de2584:	f801 0c0d 	strb.w	r0, [r1, #-13]
        = LIST_ITEM_MIN_TEXT_HEIGHT
c0de2588:	bf08      	it	eq
c0de258a:	275c      	moveq	r7, #92	@ 0x5c
c0de258c:	2320      	movs	r3, #32
    if (((itemDesc->type == TOUCHABLE_BAR_ITEM) && (itemDesc->state == ON_STATE))
c0de258e:	2a01      	cmp	r2, #1
        = LIST_ITEM_MIN_TEXT_HEIGHT
c0de2590:	f801 5c0b 	strb.w	r5, [r1, #-11]
c0de2594:	f801 7c0c 	strb.w	r7, [r1, #-12]
    container->layout               = HORIZONTAL;
c0de2598:	7348      	strb	r0, [r1, #13]
    container->obj.alignmentMarginX = BORDER_MARGIN;
c0de259a:	718d      	strb	r5, [r1, #6]
c0de259c:	714b      	strb	r3, [r1, #5]
    container->obj.alignment        = NO_ALIGNMENT;
c0de259e:	710d      	strb	r5, [r1, #4]
    container->obj.alignTo          = NULL;
c0de25a0:	70cd      	strb	r5, [r1, #3]
c0de25a2:	708d      	strb	r5, [r1, #2]
c0de25a4:	704d      	strb	r5, [r1, #1]
    if (((itemDesc->type == TOUCHABLE_BAR_ITEM) && (itemDesc->state == ON_STATE))
c0de25a6:	d006      	beq.n	c0de25b6 <addListItem+0xf2>
c0de25a8:	b9ba      	cbnz	r2, c0de25da <addListItem+0x116>
c0de25aa:	f89a 1015 	ldrb.w	r1, [sl, #21]
        || (itemDesc->type == SWITCH_ITEM)) {
c0de25ae:	2901      	cmp	r1, #1
c0de25b0:	bf18      	it	ne
c0de25b2:	2a01      	cmpne	r2, #1
c0de25b4:	d111      	bne.n	c0de25da <addListItem+0x116>
c0de25b6:	2100      	movs	r1, #0
        container->obj.touchMask = (1 << TOUCHED);
c0de25b8:	f888 101d 	strb.w	r1, [r8, #29]
        container->obj.touchId   = CONTROLS_ID + nbTouchableControls;
c0de25bc:	f240 4154 	movw	r1, #1108	@ 0x454
c0de25c0:	f2c0 0100 	movt	r1, #0
c0de25c4:	f819 2001 	ldrb.w	r2, [r9, r1]
        container->obj.touchMask = (1 << TOUCHED);
c0de25c8:	f888 001c 	strb.w	r0, [r8, #28]
        container->obj.touchId   = CONTROLS_ID + nbTouchableControls;
c0de25cc:	f102 0014 	add.w	r0, r2, #20
c0de25d0:	f888 001e 	strb.w	r0, [r8, #30]
        nbTouchableControls++;
c0de25d4:	1c50      	adds	r0, r2, #1
c0de25d6:	f809 0001 	strb.w	r0, [r9, r1]
    if (itemDesc->text != NULL) {
c0de25da:	f8da 000c 	ldr.w	r0, [sl, #12]
c0de25de:	2500      	movs	r5, #0
c0de25e0:	2800      	cmp	r0, #0
c0de25e2:	d04a      	beq.n	c0de267a <addListItem+0x1b6>
        textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de25e4:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
c0de25e8:	08c1      	lsrs	r1, r0, #3
c0de25ea:	2004      	movs	r0, #4
c0de25ec:	f005 fd93 	bl	c0de8116 <nbgl_objPoolGet>
c0de25f0:	4607      	mov	r7, r0
        textArea->text      = PIC(itemDesc->text);
c0de25f2:	f8da 000c 	ldr.w	r0, [sl, #12]
        textArea->textColor = color;
c0de25f6:	77fe      	strb	r6, [r7, #31]
        textArea->text      = PIC(itemDesc->text);
c0de25f8:	f006 fc80 	bl	c0de8efc <pic>
c0de25fc:	4639      	mov	r1, r7
c0de25fe:	f801 0f26 	strb.w	r0, [r1, #38]!
c0de2602:	0e02      	lsrs	r2, r0, #24
c0de2604:	70ca      	strb	r2, [r1, #3]
c0de2606:	0c02      	lsrs	r2, r0, #16
c0de2608:	0a00      	lsrs	r0, r0, #8
c0de260a:	f887 0027 	strb.w	r0, [r7, #39]	@ 0x27
        textArea->onDrawCallback = NULL;
c0de260e:	4638      	mov	r0, r7
c0de2610:	f800 5f2c 	strb.w	r5, [r0, #44]!
c0de2614:	70c5      	strb	r5, [r0, #3]
c0de2616:	7085      	strb	r5, [r0, #2]
        textArea->wrapping       = true;
c0de2618:	f897 0024 	ldrb.w	r0, [r7, #36]	@ 0x24
        textArea->text      = PIC(itemDesc->text);
c0de261c:	708a      	strb	r2, [r1, #2]
        textArea->wrapping       = true;
c0de261e:	f040 0001 	orr.w	r0, r0, #1
        textArea->onDrawCallback = NULL;
c0de2622:	f887 502d 	strb.w	r5, [r7, #45]	@ 0x2d
        textArea->wrapping       = true;
c0de2626:	f887 0024 	strb.w	r0, [r7, #36]	@ 0x24
        textArea->obj.area.width = container->obj.area.width;
c0de262a:	f898 0004 	ldrb.w	r0, [r8, #4]
c0de262e:	f898 2005 	ldrb.w	r2, [r8, #5]
c0de2632:	7138      	strb	r0, [r7, #4]
        if (itemDesc->iconLeft != NULL) {
c0de2634:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de2638:	210c      	movs	r1, #12
        textArea->fontId         = fontId;
c0de263a:	f887 1022 	strb.w	r1, [r7, #34]	@ 0x22
        textArea->obj.area.width = container->obj.area.width;
c0de263e:	717a      	strb	r2, [r7, #5]
        if (itemDesc->iconLeft != NULL) {
c0de2640:	b190      	cbz	r0, c0de2668 <addListItem+0x1a4>
                -= ((nbgl_icon_details_t *) PIC(itemDesc->iconLeft))->width + BAR_INTERVALE;
c0de2642:	f006 fc5b 	bl	c0de8efc <pic>
c0de2646:	463a      	mov	r2, r7
c0de2648:	f812 3f04 	ldrb.w	r3, [r2, #4]!
c0de264c:	7801      	ldrb	r1, [r0, #0]
c0de264e:	7840      	ldrb	r0, [r0, #1]
c0de2650:	7855      	ldrb	r5, [r2, #1]
c0de2652:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de2656:	ea43 2105 	orr.w	r1, r3, r5, lsl #8
c0de265a:	f64f 73f0 	movw	r3, #65520	@ 0xfff0
c0de265e:	1a18      	subs	r0, r3, r0
c0de2660:	4408      	add	r0, r1
c0de2662:	7010      	strb	r0, [r2, #0]
c0de2664:	0a00      	lsrs	r0, r0, #8
c0de2666:	7050      	strb	r0, [r2, #1]
        if (itemDesc->iconRight != NULL) {
c0de2668:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de266c:	b138      	cbz	r0, c0de267e <addListItem+0x1ba>
                -= ((nbgl_icon_details_t *) PIC(itemDesc->iconRight))->width + BAR_INTERVALE;
c0de266e:	f006 fc45 	bl	c0de8efc <pic>
c0de2672:	e00d      	b.n	c0de2690 <addListItem+0x1cc>
c0de2674:	2000      	movs	r0, #0
}
c0de2676:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de267a:	2700      	movs	r7, #0
c0de267c:	e07e      	b.n	c0de277c <addListItem+0x2b8>
        else if (itemDesc->type == SWITCH_ITEM) {
c0de267e:	f89a 0000 	ldrb.w	r0, [sl]
c0de2682:	2801      	cmp	r0, #1
c0de2684:	d115      	bne.n	c0de26b2 <addListItem+0x1ee>
c0de2686:	f646 7021 	movw	r0, #28449	@ 0x6f21
c0de268a:	f2c0 0000 	movt	r0, #0
c0de268e:	4478      	add	r0, pc
c0de2690:	463a      	mov	r2, r7
c0de2692:	f812 3f04 	ldrb.w	r3, [r2, #4]!
c0de2696:	7801      	ldrb	r1, [r0, #0]
c0de2698:	7840      	ldrb	r0, [r0, #1]
c0de269a:	7855      	ldrb	r5, [r2, #1]
c0de269c:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de26a0:	ea43 2105 	orr.w	r1, r3, r5, lsl #8
c0de26a4:	f64f 73f0 	movw	r3, #65520	@ 0xfff0
c0de26a8:	1a18      	subs	r0, r3, r0
c0de26aa:	4408      	add	r0, r1
c0de26ac:	7010      	strb	r0, [r2, #0]
c0de26ae:	0a00      	lsrs	r0, r0, #8
c0de26b0:	7050      	strb	r0, [r2, #1]
        textArea->obj.area.height = MAX(
c0de26b2:	463a      	mov	r2, r7
c0de26b4:	f812 0f26 	ldrb.w	r0, [r2, #38]!
c0de26b8:	78d1      	ldrb	r1, [r2, #3]
c0de26ba:	7893      	ldrb	r3, [r2, #2]
c0de26bc:	7855      	ldrb	r5, [r2, #1]
c0de26be:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de26c2:	ea40 2005 	orr.w	r0, r0, r5, lsl #8
c0de26c6:	f812 3c22 	ldrb.w	r3, [r2, #-34]
c0de26ca:	f812 5c21 	ldrb.w	r5, [r2, #-33]
c0de26ce:	f812 4c02 	ldrb.w	r4, [r2, #-2]
c0de26d2:	ea40 4101 	orr.w	r1, r0, r1, lsl #16
c0de26d6:	f812 0c04 	ldrb.w	r0, [r2, #-4]
c0de26da:	ea43 2205 	orr.w	r2, r3, r5, lsl #8
c0de26de:	f004 0301 	and.w	r3, r4, #1
c0de26e2:	f005 fd31 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de26e6:	2828      	cmp	r0, #40	@ 0x28
c0de26e8:	d201      	bcs.n	c0de26ee <addListItem+0x22a>
c0de26ea:	2028      	movs	r0, #40	@ 0x28
c0de26ec:	e019      	b.n	c0de2722 <addListItem+0x25e>
c0de26ee:	463a      	mov	r2, r7
c0de26f0:	f812 0f26 	ldrb.w	r0, [r2, #38]!
c0de26f4:	78d1      	ldrb	r1, [r2, #3]
c0de26f6:	7893      	ldrb	r3, [r2, #2]
c0de26f8:	7855      	ldrb	r5, [r2, #1]
c0de26fa:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de26fe:	ea40 2005 	orr.w	r0, r0, r5, lsl #8
c0de2702:	f812 3c22 	ldrb.w	r3, [r2, #-34]
c0de2706:	f812 5c21 	ldrb.w	r5, [r2, #-33]
c0de270a:	f812 4c02 	ldrb.w	r4, [r2, #-2]
c0de270e:	ea40 4101 	orr.w	r1, r0, r1, lsl #16
c0de2712:	f812 0c04 	ldrb.w	r0, [r2, #-4]
c0de2716:	ea43 2205 	orr.w	r2, r3, r5, lsl #8
c0de271a:	f004 0301 	and.w	r3, r4, #1
c0de271e:	f005 fd13 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de2722:	0a01      	lsrs	r1, r0, #8
c0de2724:	71f9      	strb	r1, [r7, #7]
c0de2726:	2100      	movs	r1, #0
c0de2728:	71b8      	strb	r0, [r7, #6]
        textArea->style         = NO_STYLE;
c0de272a:	f887 1021 	strb.w	r1, [r7, #33]	@ 0x21
c0de272e:	2101      	movs	r1, #1
        textArea->obj.alignment = TOP_LEFT;
c0de2730:	75b9      	strb	r1, [r7, #22]
            = itemDesc->large ? LIST_ITEM_PRE_HEADING_LARGE : LIST_ITEM_PRE_HEADING;
c0de2732:	f89a 1016 	ldrb.w	r1, [sl, #22]
c0de2736:	221e      	movs	r2, #30
c0de2738:	2900      	cmp	r1, #0
c0de273a:	bf08      	it	eq
c0de273c:	221a      	moveq	r2, #26
        if (textArea->obj.area.height > LIST_ITEM_MIN_TEXT_HEIGHT) {
c0de273e:	3828      	subs	r0, #40	@ 0x28
c0de2740:	eb00 70d0 	add.w	r0, r0, r0, lsr #31
c0de2744:	bf88      	it	hi
c0de2746:	eba2 0250 	subhi.w	r2, r2, r0, lsr #1
c0de274a:	767a      	strb	r2, [r7, #25]
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de274c:	4641      	mov	r1, r8
c0de274e:	0a10      	lsrs	r0, r2, #8
c0de2750:	f811 2f22 	ldrb.w	r2, [r1, #34]!
c0de2754:	76b8      	strb	r0, [r7, #26]
c0de2756:	784b      	ldrb	r3, [r1, #1]
c0de2758:	788d      	ldrb	r5, [r1, #2]
c0de275a:	78cc      	ldrb	r4, [r1, #3]
c0de275c:	2004      	movs	r0, #4
        textArea->textAlignment                    = MID_LEFT;
c0de275e:	f887 0020 	strb.w	r0, [r7, #32]
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de2762:	f811 0c02 	ldrb.w	r0, [r1, #-2]
c0de2766:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de276a:	ea45 2304 	orr.w	r3, r5, r4, lsl #8
c0de276e:	ea42 4203 	orr.w	r2, r2, r3, lsl #16
c0de2772:	f842 7020 	str.w	r7, [r2, r0, lsl #2]
        container->nbChildren++;
c0de2776:	3001      	adds	r0, #1
c0de2778:	f801 0c02 	strb.w	r0, [r1, #-2]
    if (itemDesc->iconLeft != NULL) {
c0de277c:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de2780:	2800      	cmp	r0, #0
c0de2782:	d04e      	beq.n	c0de2822 <addListItem+0x35e>
        nbgl_image_t *imageLeft    = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de2784:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
c0de2788:	08c1      	lsrs	r1, r0, #3
c0de278a:	2002      	movs	r0, #2
c0de278c:	f005 fcc3 	bl	c0de8116 <nbgl_objPoolGet>
c0de2790:	4605      	mov	r5, r0
        imageLeft->buffer          = PIC(itemDesc->iconLeft);
c0de2792:	f8da 0004 	ldr.w	r0, [sl, #4]
        imageLeft->foregroundColor = color;
c0de2796:	77ee      	strb	r6, [r5, #31]
        imageLeft->buffer          = PIC(itemDesc->iconLeft);
c0de2798:	f006 fbb0 	bl	c0de8efc <pic>
c0de279c:	4629      	mov	r1, r5
c0de279e:	f801 0f21 	strb.w	r0, [r1, #33]!
c0de27a2:	0e02      	lsrs	r2, r0, #24
c0de27a4:	70ca      	strb	r2, [r1, #3]
c0de27a6:	0c02      	lsrs	r2, r0, #16
c0de27a8:	0a00      	lsrs	r0, r0, #8
c0de27aa:	f885 0022 	strb.w	r0, [r5, #34]	@ 0x22
c0de27ae:	2004      	movs	r0, #4
        imageLeft->obj.alignment                   = MID_LEFT;
c0de27b0:	75a8      	strb	r0, [r5, #22]
        imageLeft->obj.alignTo                     = (nbgl_obj_t *) textArea;
c0de27b2:	0a38      	lsrs	r0, r7, #8
c0de27b4:	74e8      	strb	r0, [r5, #19]
c0de27b6:	4628      	mov	r0, r5
        imageLeft->buffer          = PIC(itemDesc->iconLeft);
c0de27b8:	708a      	strb	r2, [r1, #2]
        imageLeft->obj.alignTo                     = (nbgl_obj_t *) textArea;
c0de27ba:	f800 7f12 	strb.w	r7, [r0, #18]!
c0de27be:	0e39      	lsrs	r1, r7, #24
c0de27c0:	70c1      	strb	r1, [r0, #3]
c0de27c2:	0c39      	lsrs	r1, r7, #16
c0de27c4:	7081      	strb	r1, [r0, #2]
c0de27c6:	2110      	movs	r1, #16
        imageLeft->obj.alignmentMarginX            = BAR_INTERVALE;
c0de27c8:	75e9      	strb	r1, [r5, #23]
        container->children[container->nbChildren] = (nbgl_obj_t *) imageLeft;
c0de27ca:	4641      	mov	r1, r8
c0de27cc:	f811 2f22 	ldrb.w	r2, [r1, #34]!
c0de27d0:	4634      	mov	r4, r6
c0de27d2:	784b      	ldrb	r3, [r1, #1]
c0de27d4:	f891 c002 	ldrb.w	ip, [r1, #2]
c0de27d8:	78ce      	ldrb	r6, [r1, #3]
c0de27da:	2000      	movs	r0, #0
        imageLeft->obj.alignmentMarginX            = BAR_INTERVALE;
c0de27dc:	7628      	strb	r0, [r5, #24]
        container->children[container->nbChildren] = (nbgl_obj_t *) imageLeft;
c0de27de:	f811 0c02 	ldrb.w	r0, [r1, #-2]
c0de27e2:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de27e6:	ea4c 2306 	orr.w	r3, ip, r6, lsl #8
c0de27ea:	ea42 4203 	orr.w	r2, r2, r3, lsl #16
c0de27ee:	4626      	mov	r6, r4
c0de27f0:	f842 5020 	str.w	r5, [r2, r0, lsl #2]
        container->nbChildren++;
c0de27f4:	3001      	adds	r0, #1
c0de27f6:	f801 0c02 	strb.w	r0, [r1, #-2]
        if (textArea != NULL) {
c0de27fa:	b197      	cbz	r7, c0de2822 <addListItem+0x35e>
            textArea->obj.alignmentMarginX = imageLeft->buffer->width + BAR_INTERVALE;
c0de27fc:	f815 0f21 	ldrb.w	r0, [r5, #33]!
c0de2800:	7869      	ldrb	r1, [r5, #1]
c0de2802:	78aa      	ldrb	r2, [r5, #2]
c0de2804:	78eb      	ldrb	r3, [r5, #3]
c0de2806:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de280a:	ea42 2103 	orr.w	r1, r2, r3, lsl #8
c0de280e:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de2812:	7801      	ldrb	r1, [r0, #0]
c0de2814:	7840      	ldrb	r0, [r0, #1]
c0de2816:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de281a:	3010      	adds	r0, #16
c0de281c:	75f8      	strb	r0, [r7, #23]
c0de281e:	0a00      	lsrs	r0, r0, #8
c0de2820:	7638      	strb	r0, [r7, #24]
    if (itemDesc->iconRight != NULL) {
c0de2822:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de2826:	b1b8      	cbz	r0, c0de2858 <addListItem+0x394>
        nbgl_image_t *imageRight    = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de2828:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
c0de282c:	08c1      	lsrs	r1, r0, #3
c0de282e:	2002      	movs	r0, #2
c0de2830:	f005 fc71 	bl	c0de8116 <nbgl_objPoolGet>
c0de2834:	4605      	mov	r5, r0
        imageRight->buffer          = PIC(itemDesc->iconRight);
c0de2836:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de283a:	4634      	mov	r4, r6
        imageRight->foregroundColor = color;
c0de283c:	77ee      	strb	r6, [r5, #31]
        imageRight->buffer          = PIC(itemDesc->iconRight);
c0de283e:	f006 fb5d 	bl	c0de8efc <pic>
c0de2842:	4629      	mov	r1, r5
c0de2844:	f801 0f21 	strb.w	r0, [r1, #33]!
c0de2848:	0e02      	lsrs	r2, r0, #24
c0de284a:	70ca      	strb	r2, [r1, #3]
c0de284c:	0c02      	lsrs	r2, r0, #16
c0de284e:	0a00      	lsrs	r0, r0, #8
c0de2850:	708a      	strb	r2, [r1, #2]
c0de2852:	f885 0022 	strb.w	r0, [r5, #34]	@ 0x22
c0de2856:	e014      	b.n	c0de2882 <addListItem+0x3be>
    else if (itemDesc->type == SWITCH_ITEM) {
c0de2858:	f89a 0000 	ldrb.w	r0, [sl]
c0de285c:	2801      	cmp	r0, #1
c0de285e:	d133      	bne.n	c0de28c8 <addListItem+0x404>
        nbgl_switch_t *switchObj = (nbgl_switch_t *) nbgl_objPoolGet(SWITCH, layoutInt->layer);
c0de2860:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
c0de2864:	4634      	mov	r4, r6
c0de2866:	08c1      	lsrs	r1, r0, #3
c0de2868:	2006      	movs	r0, #6
c0de286a:	f005 fc54 	bl	c0de8116 <nbgl_objPoolGet>
c0de286e:	4605      	mov	r5, r0
c0de2870:	2000      	movs	r0, #0
        switchObj->state         = itemDesc->state;
c0de2872:	f89a 1015 	ldrb.w	r1, [sl, #21]
        switchObj->onColor       = BLACK;
c0de2876:	77e8      	strb	r0, [r5, #31]
c0de2878:	2002      	movs	r0, #2
        switchObj->offColor      = LIGHT_GRAY;
c0de287a:	f885 0020 	strb.w	r0, [r5, #32]
        switchObj->state         = itemDesc->state;
c0de287e:	f885 1021 	strb.w	r1, [r5, #33]	@ 0x21
c0de2882:	2110      	movs	r1, #16
c0de2884:	75e9      	strb	r1, [r5, #23]
c0de2886:	4629      	mov	r1, r5
c0de2888:	f801 7f12 	strb.w	r7, [r1, #18]!
c0de288c:	0e3a      	lsrs	r2, r7, #24
c0de288e:	70ca      	strb	r2, [r1, #3]
c0de2890:	0c3a      	lsrs	r2, r7, #16
c0de2892:	2006      	movs	r0, #6
c0de2894:	708a      	strb	r2, [r1, #2]
c0de2896:	0a39      	lsrs	r1, r7, #8
c0de2898:	75a8      	strb	r0, [r5, #22]
c0de289a:	74e9      	strb	r1, [r5, #19]
c0de289c:	4641      	mov	r1, r8
c0de289e:	f811 2f22 	ldrb.w	r2, [r1, #34]!
c0de28a2:	2000      	movs	r0, #0
c0de28a4:	7628      	strb	r0, [r5, #24]
c0de28a6:	7848      	ldrb	r0, [r1, #1]
c0de28a8:	788b      	ldrb	r3, [r1, #2]
c0de28aa:	78ce      	ldrb	r6, [r1, #3]
c0de28ac:	ea42 2000 	orr.w	r0, r2, r0, lsl #8
c0de28b0:	ea43 2206 	orr.w	r2, r3, r6, lsl #8
c0de28b4:	f811 3c02 	ldrb.w	r3, [r1, #-2]
c0de28b8:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de28bc:	f840 5023 	str.w	r5, [r0, r3, lsl #2]
c0de28c0:	1c58      	adds	r0, r3, #1
c0de28c2:	4626      	mov	r6, r4
c0de28c4:	f801 0c02 	strb.w	r0, [r1, #-2]
    if (itemDesc->subText != NULL) {
c0de28c8:	f8da 0010 	ldr.w	r0, [sl, #16]
c0de28cc:	2800      	cmp	r0, #0
c0de28ce:	f000 808f 	beq.w	c0de29f0 <addListItem+0x52c>
            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de28d2:	f89b 00ad 	ldrb.w	r0, [fp, #173]	@ 0xad
c0de28d6:	2404      	movs	r4, #4
c0de28d8:	08c1      	lsrs	r1, r0, #3
c0de28da:	2004      	movs	r0, #4
c0de28dc:	f005 fc1b 	bl	c0de8116 <nbgl_objPoolGet>
c0de28e0:	4605      	mov	r5, r0
        subTextArea->text          = PIC(itemDesc->subText);
c0de28e2:	f8da 0010 	ldr.w	r0, [sl, #16]
        subTextArea->textColor     = color;
c0de28e6:	77ee      	strb	r6, [r5, #31]
        subTextArea->text          = PIC(itemDesc->subText);
c0de28e8:	f006 fb08 	bl	c0de8efc <pic>
c0de28ec:	4629      	mov	r1, r5
c0de28ee:	f801 0f26 	strb.w	r0, [r1, #38]!
c0de28f2:	0e02      	lsrs	r2, r0, #24
c0de28f4:	70ca      	strb	r2, [r1, #3]
c0de28f6:	0c02      	lsrs	r2, r0, #16
c0de28f8:	708a      	strb	r2, [r1, #2]
c0de28fa:	0a00      	lsrs	r0, r0, #8
        subTextArea->wrapping      = true;
c0de28fc:	f895 1024 	ldrb.w	r1, [r5, #36]	@ 0x24
        subTextArea->text          = PIC(itemDesc->subText);
c0de2900:	f885 0027 	strb.w	r0, [r5, #39]	@ 0x27
c0de2904:	200b      	movs	r0, #11
        subTextArea->fontId        = SMALL_REGULAR_FONT;
c0de2906:	f885 0022 	strb.w	r0, [r5, #34]	@ 0x22
        subTextArea->wrapping      = true;
c0de290a:	f041 0001 	orr.w	r0, r1, #1
c0de290e:	f885 0024 	strb.w	r0, [r5, #36]	@ 0x24
        if (itemDesc->text != NULL) {
c0de2912:	f8da 100c 	ldr.w	r1, [sl, #12]
c0de2916:	2000      	movs	r0, #0
        subTextArea->textAlignment = MID_LEFT;
c0de2918:	f885 4020 	strb.w	r4, [r5, #32]
        subTextArea->style         = NO_STYLE;
c0de291c:	f885 0021 	strb.w	r0, [r5, #33]	@ 0x21
        if (itemDesc->text != NULL) {
c0de2920:	b171      	cbz	r1, c0de2940 <addListItem+0x47c>
            subTextArea->obj.alignTo          = (nbgl_obj_t *) textArea;
c0de2922:	4629      	mov	r1, r5
c0de2924:	f801 7f12 	strb.w	r7, [r1, #18]!
c0de2928:	2207      	movs	r2, #7
            subTextArea->obj.alignment        = BOTTOM_LEFT;
c0de292a:	710a      	strb	r2, [r1, #4]
            subTextArea->obj.alignTo          = (nbgl_obj_t *) textArea;
c0de292c:	0e3a      	lsrs	r2, r7, #24
c0de292e:	70ca      	strb	r2, [r1, #3]
c0de2930:	0c3a      	lsrs	r2, r7, #16
c0de2932:	708a      	strb	r2, [r1, #2]
c0de2934:	0a3a      	lsrs	r2, r7, #8
            subTextArea->obj.alignmentMarginY = LIST_ITEM_HEADING_SUB_TEXT;
c0de2936:	7208      	strb	r0, [r1, #8]
c0de2938:	200c      	movs	r0, #12
            subTextArea->obj.alignTo          = (nbgl_obj_t *) textArea;
c0de293a:	704a      	strb	r2, [r1, #1]
            subTextArea->obj.alignmentMarginY = LIST_ITEM_HEADING_SUB_TEXT;
c0de293c:	71c8      	strb	r0, [r1, #7]
c0de293e:	e008      	b.n	c0de2952 <addListItem+0x48e>
c0de2940:	2101      	movs	r1, #1
            subTextArea->obj.alignment        = TOP_LEFT;
c0de2942:	75a9      	strb	r1, [r5, #22]
c0de2944:	211c      	movs	r1, #28
            subTextArea->obj.alignmentMarginY = SUB_HEADER_MARGIN;
c0de2946:	76a8      	strb	r0, [r5, #26]
c0de2948:	7669      	strb	r1, [r5, #25]
            container->obj.area.height        = SUB_HEADER_MARGIN;
c0de294a:	f888 0007 	strb.w	r0, [r8, #7]
c0de294e:	f888 1006 	strb.w	r1, [r8, #6]
        if (itemDesc->iconLeft != NULL) {
c0de2952:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de2956:	b158      	cbz	r0, c0de2970 <addListItem+0x4ac>
                = -(((nbgl_icon_details_t *) PIC(itemDesc->iconLeft))->width + BAR_INTERVALE);
c0de2958:	f006 fad0 	bl	c0de8efc <pic>
c0de295c:	7801      	ldrb	r1, [r0, #0]
c0de295e:	7840      	ldrb	r0, [r0, #1]
c0de2960:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de2964:	f64f 71f0 	movw	r1, #65520	@ 0xfff0
c0de2968:	1a08      	subs	r0, r1, r0
c0de296a:	75e8      	strb	r0, [r5, #23]
c0de296c:	0a00      	lsrs	r0, r0, #8
c0de296e:	7628      	strb	r0, [r5, #24]
        subTextArea->obj.area.width                = container->obj.area.width;
c0de2970:	f898 0004 	ldrb.w	r0, [r8, #4]
c0de2974:	f898 1005 	ldrb.w	r1, [r8, #5]
                                                                 subTextArea->text,
c0de2978:	462b      	mov	r3, r5
        subTextArea->obj.area.width                = container->obj.area.width;
c0de297a:	ea40 2201 	orr.w	r2, r0, r1, lsl #8
c0de297e:	7169      	strb	r1, [r5, #5]
                                                                 subTextArea->text,
c0de2980:	f895 1027 	ldrb.w	r1, [r5, #39]	@ 0x27
c0de2984:	f813 7f26 	ldrb.w	r7, [r3, #38]!
                                                                 subTextArea->wrapping);
c0de2988:	f895 6024 	ldrb.w	r6, [r5, #36]	@ 0x24
                                                                 subTextArea->text,
c0de298c:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de2990:	789f      	ldrb	r7, [r3, #2]
c0de2992:	78db      	ldrb	r3, [r3, #3]
        subTextArea->obj.area.width                = container->obj.area.width;
c0de2994:	7128      	strb	r0, [r5, #4]
        subTextArea->obj.area.height               = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de2996:	f895 0022 	ldrb.w	r0, [r5, #34]	@ 0x22
                                                                 subTextArea->text,
c0de299a:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de299e:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
                                                                 subTextArea->wrapping);
c0de29a2:	f006 0301 	and.w	r3, r6, #1
        subTextArea->obj.area.height               = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de29a6:	f005 fbcf 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de29aa:	71a8      	strb	r0, [r5, #6]
        container->children[container->nbChildren] = (nbgl_obj_t *) subTextArea;
c0de29ac:	4641      	mov	r1, r8
c0de29ae:	f811 2f22 	ldrb.w	r2, [r1, #34]!
        subTextArea->obj.area.height               = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de29b2:	0a03      	lsrs	r3, r0, #8
            += subTextArea->obj.area.height + subTextArea->obj.alignmentMarginY;
c0de29b4:	f811 cd1c 	ldrb.w	ip, [r1, #-28]!
        subTextArea->obj.area.height               = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de29b8:	71eb      	strb	r3, [r5, #7]
        container->children[container->nbChildren] = (nbgl_obj_t *) subTextArea;
c0de29ba:	7fcb      	ldrb	r3, [r1, #31]
c0de29bc:	7f8f      	ldrb	r7, [r1, #30]
c0de29be:	7f4e      	ldrb	r6, [r1, #29]
c0de29c0:	7e8c      	ldrb	r4, [r1, #26]
c0de29c2:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de29c6:	ea42 2206 	orr.w	r2, r2, r6, lsl #8
c0de29ca:	ea42 4203 	orr.w	r2, r2, r3, lsl #16
c0de29ce:	f842 5024 	str.w	r5, [r2, r4, lsl #2]
        container->nbChildren++;
c0de29d2:	1c62      	adds	r2, r4, #1
            += subTextArea->obj.area.height + subTextArea->obj.alignmentMarginY;
c0de29d4:	7e6b      	ldrb	r3, [r5, #25]
c0de29d6:	7eac      	ldrb	r4, [r5, #26]
c0de29d8:	f891 e001 	ldrb.w	lr, [r1, #1]
        container->nbChildren++;
c0de29dc:	768a      	strb	r2, [r1, #26]
            += subTextArea->obj.area.height + subTextArea->obj.alignmentMarginY;
c0de29de:	ea43 2204 	orr.w	r2, r3, r4, lsl #8
c0de29e2:	4410      	add	r0, r2
c0de29e4:	ea4c 220e 	orr.w	r2, ip, lr, lsl #8
c0de29e8:	4410      	add	r0, r2
c0de29ea:	7008      	strb	r0, [r1, #0]
c0de29ec:	0a00      	lsrs	r0, r0, #8
c0de29ee:	7048      	strb	r0, [r1, #1]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de29f0:	f8db 00a0 	ldr.w	r0, [fp, #160]	@ 0xa0
    layout->container->children[layout->container->nbChildren] = obj;
c0de29f4:	f810 1f22 	ldrb.w	r1, [r0, #34]!
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de29f8:	f810 2c02 	ldrb.w	r2, [r0, #-2]
    layout->container->children[layout->container->nbChildren] = obj;
c0de29fc:	7843      	ldrb	r3, [r0, #1]
c0de29fe:	7887      	ldrb	r7, [r0, #2]
c0de2a00:	78c0      	ldrb	r0, [r0, #3]
c0de2a02:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de2a06:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de2a0a:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de2a0e:	f840 8022 	str.w	r8, [r0, r2, lsl #2]
    layout->container->nbChildren++;
c0de2a12:	f8db 00a0 	ldr.w	r0, [fp, #160]	@ 0xa0
c0de2a16:	f890 1020 	ldrb.w	r1, [r0, #32]
c0de2a1a:	3101      	adds	r1, #1
c0de2a1c:	f880 1020 	strb.w	r1, [r0, #32]
}
c0de2a20:	4640      	mov	r0, r8
c0de2a22:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de2a26 <nbgl_layoutAddSwitch>:
{
c0de2a26:	b580      	push	{r7, lr}
c0de2a28:	b088      	sub	sp, #32
c0de2a2a:	2200      	movs	r2, #0
    listItem_t             itemDesc = {0};
c0de2a2c:	e9cd 2206 	strd	r2, r2, [sp, #24]
c0de2a30:	e9cd 2204 	strd	r2, r2, [sp, #16]
c0de2a34:	e9cd 2202 	strd	r2, r2, [sp, #8]
c0de2a38:	9201      	str	r2, [sp, #4]
    if (layout == NULL) {
c0de2a3a:	b1f8      	cbz	r0, c0de2a7c <nbgl_layoutAddSwitch+0x56>
    if (switchLayout->text == NULL) {
c0de2a3c:	f8d1 c000 	ldr.w	ip, [r1]
    itemDesc.token   = switchLayout->token;
c0de2a40:	7a4b      	ldrb	r3, [r1, #9]
    itemDesc.text    = switchLayout->text;
c0de2a42:	f8cd c010 	str.w	ip, [sp, #16]
    itemDesc.token   = switchLayout->token;
c0de2a46:	f88d 3018 	strb.w	r3, [sp, #24]
    itemDesc.tuneId  = switchLayout->tuneId;
c0de2a4a:	7a8b      	ldrb	r3, [r1, #10]
    itemDesc.subText = switchLayout->subText;
c0de2a4c:	f8d1 c004 	ldr.w	ip, [r1, #4]
    itemDesc.state   = switchLayout->initState;
c0de2a50:	7a09      	ldrb	r1, [r1, #8]
    itemDesc.tuneId  = switchLayout->tuneId;
c0de2a52:	f88d 301c 	strb.w	r3, [sp, #28]
    itemDesc.state   = switchLayout->initState;
c0de2a56:	f88d 1019 	strb.w	r1, [sp, #25]
c0de2a5a:	2101      	movs	r1, #1
    itemDesc.type    = SWITCH_ITEM;
c0de2a5c:	f88d 1004 	strb.w	r1, [sp, #4]
c0de2a60:	a901      	add	r1, sp, #4
    itemDesc.subText = switchLayout->subText;
c0de2a62:	f8cd c014 	str.w	ip, [sp, #20]
    itemDesc.large   = false;
c0de2a66:	f88d 201a 	strb.w	r2, [sp, #26]
    container        = addListItem(layoutInt, &itemDesc);
c0de2a6a:	f7ff fd2b 	bl	c0de24c4 <addListItem>
    if (container == NULL) {
c0de2a6e:	b128      	cbz	r0, c0de2a7c <nbgl_layoutAddSwitch+0x56>
    return container->obj.area.height;
c0de2a70:	7981      	ldrb	r1, [r0, #6]
c0de2a72:	79c0      	ldrb	r0, [r0, #7]
c0de2a74:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
}
c0de2a78:	b008      	add	sp, #32
c0de2a7a:	bd80      	pop	{r7, pc}
c0de2a7c:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de2a80:	b008      	add	sp, #32
c0de2a82:	bd80      	pop	{r7, pc}

c0de2a84 <nbgl_layoutAddText>:
{
c0de2a84:	b580      	push	{r7, lr}
c0de2a86:	b088      	sub	sp, #32
c0de2a88:	2300      	movs	r3, #0
    listItem_t             itemDesc = {0};
c0de2a8a:	e9cd 3306 	strd	r3, r3, [sp, #24]
c0de2a8e:	e9cd 3304 	strd	r3, r3, [sp, #16]
c0de2a92:	e9cd 3302 	strd	r3, r3, [sp, #8]
c0de2a96:	9301      	str	r3, [sp, #4]
    if (layout == NULL) {
c0de2a98:	b1a0      	cbz	r0, c0de2ac4 <nbgl_layoutAddText+0x40>
    itemDesc.text    = text;
c0de2a9a:	e9cd 1204 	strd	r1, r2, [sp, #16]
c0de2a9e:	21ff      	movs	r1, #255	@ 0xff
    itemDesc.token   = NBGL_INVALID_TOKEN;
c0de2aa0:	f88d 1018 	strb.w	r1, [sp, #24]
c0de2aa4:	210c      	movs	r1, #12
    itemDesc.tuneId  = NBGL_NO_TUNE;
c0de2aa6:	f88d 101c 	strb.w	r1, [sp, #28]
c0de2aaa:	2102      	movs	r1, #2
    itemDesc.type    = TEXT_ITEM;
c0de2aac:	f88d 1004 	strb.w	r1, [sp, #4]
c0de2ab0:	a901      	add	r1, sp, #4
    container        = addListItem(layoutInt, &itemDesc);
c0de2ab2:	f7ff fd07 	bl	c0de24c4 <addListItem>
    if (container == NULL) {
c0de2ab6:	b128      	cbz	r0, c0de2ac4 <nbgl_layoutAddText+0x40>
    return container->obj.area.height;
c0de2ab8:	7981      	ldrb	r1, [r0, #6]
c0de2aba:	79c0      	ldrb	r0, [r0, #7]
c0de2abc:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
}
c0de2ac0:	b008      	add	sp, #32
c0de2ac2:	bd80      	pop	{r7, pc}
c0de2ac4:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de2ac8:	b008      	add	sp, #32
c0de2aca:	bd80      	pop	{r7, pc}

c0de2acc <nbgl_layoutAddTextWithAlias>:
{
c0de2acc:	b580      	push	{r7, lr}
c0de2ace:	b088      	sub	sp, #32
c0de2ad0:	f04f 0c00 	mov.w	ip, #0
    listItem_t             itemDesc = {0};
c0de2ad4:	e9cd cc06 	strd	ip, ip, [sp, #24]
c0de2ad8:	e9cd cc04 	strd	ip, ip, [sp, #16]
c0de2adc:	e9cd cc02 	strd	ip, ip, [sp, #8]
c0de2ae0:	f8cd c004 	str.w	ip, [sp, #4]
    if (layout == NULL) {
c0de2ae4:	b1f8      	cbz	r0, c0de2b26 <nbgl_layoutAddTextWithAlias+0x5a>
    itemDesc.text      = text;
c0de2ae6:	e9cd 1204 	strd	r1, r2, [sp, #16]
    itemDesc.iconRight = &MINI_PUSH_ICON;
c0de2aea:	f247 2171 	movw	r1, #29297	@ 0x7271
c0de2aee:	f2c0 0100 	movt	r1, #0
c0de2af2:	4479      	add	r1, pc
c0de2af4:	9103      	str	r1, [sp, #12]
c0de2af6:	210c      	movs	r1, #12
c0de2af8:	f8dd e028 	ldr.w	lr, [sp, #40]	@ 0x28
    itemDesc.tuneId    = NBGL_NO_TUNE;
c0de2afc:	f88d 101c 	strb.w	r1, [sp, #28]
c0de2b00:	2101      	movs	r1, #1
    itemDesc.state     = ON_STATE;
c0de2b02:	f88d 1019 	strb.w	r1, [sp, #25]
c0de2b06:	a901      	add	r1, sp, #4
    itemDesc.token     = token;
c0de2b08:	f88d 3018 	strb.w	r3, [sp, #24]
    itemDesc.type      = TOUCHABLE_BAR_ITEM;
c0de2b0c:	f88d c004 	strb.w	ip, [sp, #4]
    itemDesc.index     = index;
c0de2b10:	f88d e01b 	strb.w	lr, [sp, #27]
    container          = addListItem(layoutInt, &itemDesc);
c0de2b14:	f7ff fcd6 	bl	c0de24c4 <addListItem>
    if (container == NULL) {
c0de2b18:	b128      	cbz	r0, c0de2b26 <nbgl_layoutAddTextWithAlias+0x5a>
    return container->obj.area.height;
c0de2b1a:	7981      	ldrb	r1, [r0, #6]
c0de2b1c:	79c0      	ldrb	r0, [r0, #7]
c0de2b1e:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
}
c0de2b22:	b008      	add	sp, #32
c0de2b24:	bd80      	pop	{r7, pc}
c0de2b26:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de2b2a:	b008      	add	sp, #32
c0de2b2c:	bd80      	pop	{r7, pc}

c0de2b2e <nbgl_layoutAddTextContent>:
    if (layout == NULL) {
c0de2b2e:	2800      	cmp	r0, #0
c0de2b30:	bf04      	itt	eq
c0de2b32:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
}
c0de2b36:	4770      	bxeq	lr
c0de2b38:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de2b3c:	4698      	mov	r8, r3
c0de2b3e:	4693      	mov	fp, r2
c0de2b40:	4604      	mov	r4, r0
c0de2b42:	460d      	mov	r5, r1
    if (title != NULL) {
c0de2b44:	2900      	cmp	r1, #0
c0de2b46:	d051      	beq.n	c0de2bec <nbgl_layoutAddTextContent+0xbe>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de2b48:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2b4c:	f04f 0a04 	mov.w	sl, #4
c0de2b50:	08c1      	lsrs	r1, r0, #3
c0de2b52:	2004      	movs	r0, #4
c0de2b54:	f005 fadf 	bl	c0de8116 <nbgl_objPoolGet>
c0de2b58:	2600      	movs	r6, #0
c0de2b5a:	4607      	mov	r7, r0
        textArea->textColor     = BLACK;
c0de2b5c:	77c6      	strb	r6, [r0, #31]
        textArea->text          = PIC(title);
c0de2b5e:	4628      	mov	r0, r5
c0de2b60:	f006 f9cc 	bl	c0de8efc <pic>
c0de2b64:	4601      	mov	r1, r0
c0de2b66:	4638      	mov	r0, r7
c0de2b68:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de2b6c:	0e0a      	lsrs	r2, r1, #24
c0de2b6e:	70c2      	strb	r2, [r0, #3]
c0de2b70:	0c0a      	lsrs	r2, r1, #16
c0de2b72:	7082      	strb	r2, [r0, #2]
c0de2b74:	0a08      	lsrs	r0, r1, #8
c0de2b76:	f887 0027 	strb.w	r0, [r7, #39]	@ 0x27
c0de2b7a:	200d      	movs	r0, #13
        textArea->fontId        = LARGE_MEDIUM_FONT;
c0de2b7c:	f887 0022 	strb.w	r0, [r7, #34]	@ 0x22
        textArea->wrapping      = true;
c0de2b80:	f897 0024 	ldrb.w	r0, [r7, #36]	@ 0x24
        textArea->obj.area.height      = nbgl_getTextHeightInWidth(
c0de2b84:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
        textArea->wrapping      = true;
c0de2b88:	f040 0001 	orr.w	r0, r0, #1
c0de2b8c:	f887 0024 	strb.w	r0, [r7, #36]	@ 0x24
c0de2b90:	2020      	movs	r0, #32
        textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de2b92:	75f8      	strb	r0, [r7, #23]
c0de2b94:	2010      	movs	r0, #16
        textArea->obj.alignmentMarginY = PRE_TITLE_MARGIN;
c0de2b96:	7678      	strb	r0, [r7, #25]
c0de2b98:	2001      	movs	r0, #1
        textArea->obj.area.width       = AVAILABLE_WIDTH;
c0de2b9a:	7178      	strb	r0, [r7, #5]
c0de2b9c:	20a0      	movs	r0, #160	@ 0xa0
c0de2b9e:	7138      	strb	r0, [r7, #4]
        textArea->obj.area.height      = nbgl_getTextHeightInWidth(
c0de2ba0:	200d      	movs	r0, #13
c0de2ba2:	2301      	movs	r3, #1
        textArea->textAlignment = MID_LEFT;
c0de2ba4:	f887 a020 	strb.w	sl, [r7, #32]
        textArea->style         = NO_STYLE;
c0de2ba8:	f887 6021 	strb.w	r6, [r7, #33]	@ 0x21
        textArea->obj.alignment = NO_ALIGNMENT;
c0de2bac:	75be      	strb	r6, [r7, #22]
        textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de2bae:	763e      	strb	r6, [r7, #24]
        textArea->obj.alignmentMarginY = PRE_TITLE_MARGIN;
c0de2bb0:	76be      	strb	r6, [r7, #26]
        textArea->obj.area.height      = nbgl_getTextHeightInWidth(
c0de2bb2:	f005 fac9 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de2bb6:	71b8      	strb	r0, [r7, #6]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de2bb8:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
        textArea->obj.area.height      = nbgl_getTextHeightInWidth(
c0de2bbc:	0a00      	lsrs	r0, r0, #8
    layout->container->children[layout->container->nbChildren] = obj;
c0de2bbe:	f811 2f22 	ldrb.w	r2, [r1, #34]!
        textArea->obj.area.height      = nbgl_getTextHeightInWidth(
c0de2bc2:	71f8      	strb	r0, [r7, #7]
    layout->container->children[layout->container->nbChildren] = obj;
c0de2bc4:	784b      	ldrb	r3, [r1, #1]
c0de2bc6:	788e      	ldrb	r6, [r1, #2]
c0de2bc8:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de2bcc:	78cb      	ldrb	r3, [r1, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de2bce:	f811 1c02 	ldrb.w	r1, [r1, #-2]
    layout->container->children[layout->container->nbChildren] = obj;
c0de2bd2:	ea46 2303 	orr.w	r3, r6, r3, lsl #8
c0de2bd6:	ea42 4203 	orr.w	r2, r2, r3, lsl #16
c0de2bda:	f842 7021 	str.w	r7, [r2, r1, lsl #2]
    layout->container->nbChildren++;
c0de2bde:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
c0de2be2:	f891 2020 	ldrb.w	r2, [r1, #32]
c0de2be6:	1c50      	adds	r0, r2, #1
c0de2be8:	f881 0020 	strb.w	r0, [r1, #32]
    if (description != NULL) {
c0de2bec:	f1bb 0f00 	cmp.w	fp, #0
c0de2bf0:	d051      	beq.n	c0de2c96 <nbgl_layoutAddTextContent+0x168>
        textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de2bf2:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2bf6:	f04f 0a04 	mov.w	sl, #4
c0de2bfa:	08c1      	lsrs	r1, r0, #3
c0de2bfc:	2004      	movs	r0, #4
c0de2bfe:	f005 fa8a 	bl	c0de8116 <nbgl_objPoolGet>
c0de2c02:	2500      	movs	r5, #0
c0de2c04:	4607      	mov	r7, r0
        textArea->textColor = BLACK;
c0de2c06:	77c5      	strb	r5, [r0, #31]
        textArea->text      = PIC(description);
c0de2c08:	4658      	mov	r0, fp
c0de2c0a:	f006 f977 	bl	c0de8efc <pic>
c0de2c0e:	4601      	mov	r1, r0
c0de2c10:	4638      	mov	r0, r7
c0de2c12:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de2c16:	0e0a      	lsrs	r2, r1, #24
c0de2c18:	70c2      	strb	r2, [r0, #3]
c0de2c1a:	0c0a      	lsrs	r2, r1, #16
c0de2c1c:	7082      	strb	r2, [r0, #2]
c0de2c1e:	0a08      	lsrs	r0, r1, #8
c0de2c20:	f887 0027 	strb.w	r0, [r7, #39]	@ 0x27
c0de2c24:	200b      	movs	r0, #11
        textArea->fontId    = SMALL_REGULAR_FONT;
c0de2c26:	f887 0022 	strb.w	r0, [r7, #34]	@ 0x22
        textArea->wrapping  = true;
c0de2c2a:	f897 0024 	ldrb.w	r0, [r7, #36]	@ 0x24
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de2c2e:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
        textArea->wrapping  = true;
c0de2c32:	f040 0001 	orr.w	r0, r0, #1
c0de2c36:	f887 0024 	strb.w	r0, [r7, #36]	@ 0x24
c0de2c3a:	2001      	movs	r0, #1
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de2c3c:	7178      	strb	r0, [r7, #5]
c0de2c3e:	20a0      	movs	r0, #160	@ 0xa0
c0de2c40:	7138      	strb	r0, [r7, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de2c42:	200b      	movs	r0, #11
c0de2c44:	2301      	movs	r3, #1
        textArea->style     = NO_STYLE;
c0de2c46:	f887 5021 	strb.w	r5, [r7, #33]	@ 0x21
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de2c4a:	f005 fa7d 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de2c4e:	71b8      	strb	r0, [r7, #6]
c0de2c50:	0a00      	lsrs	r0, r0, #8
c0de2c52:	71f8      	strb	r0, [r7, #7]
c0de2c54:	2020      	movs	r0, #32
        textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de2c56:	75f8      	strb	r0, [r7, #23]
c0de2c58:	2018      	movs	r0, #24
        textArea->obj.alignmentMarginY = PRE_DESCRIPTION_MARGIN;
c0de2c5a:	7678      	strb	r0, [r7, #25]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de2c5c:	f8d4 00a0 	ldr.w	r0, [r4, #160]	@ 0xa0
        textArea->textAlignment        = MID_LEFT;
c0de2c60:	f887 a020 	strb.w	sl, [r7, #32]
    layout->container->children[layout->container->nbChildren] = obj;
c0de2c64:	f810 1f22 	ldrb.w	r1, [r0, #34]!
        textArea->obj.alignment        = NO_ALIGNMENT;
c0de2c68:	75bd      	strb	r5, [r7, #22]
    layout->container->children[layout->container->nbChildren] = obj;
c0de2c6a:	7842      	ldrb	r2, [r0, #1]
c0de2c6c:	7883      	ldrb	r3, [r0, #2]
c0de2c6e:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de2c72:	78c2      	ldrb	r2, [r0, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de2c74:	f810 0c02 	ldrb.w	r0, [r0, #-2]
    layout->container->children[layout->container->nbChildren] = obj;
c0de2c78:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de2c7c:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de2c80:	f841 7020 	str.w	r7, [r1, r0, lsl #2]
    layout->container->nbChildren++;
c0de2c84:	f8d4 00a0 	ldr.w	r0, [r4, #160]	@ 0xa0
        textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de2c88:	763d      	strb	r5, [r7, #24]
    layout->container->nbChildren++;
c0de2c8a:	f890 1020 	ldrb.w	r1, [r0, #32]
        textArea->obj.alignmentMarginY = PRE_DESCRIPTION_MARGIN;
c0de2c8e:	76bd      	strb	r5, [r7, #26]
    layout->container->nbChildren++;
c0de2c90:	3101      	adds	r1, #1
c0de2c92:	f880 1020 	strb.w	r1, [r0, #32]
    if (info != NULL) {
c0de2c96:	f1b8 0f00 	cmp.w	r8, #0
c0de2c9a:	d052      	beq.n	c0de2d42 <nbgl_layoutAddTextContent+0x214>
        textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de2c9c:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de2ca0:	f04f 0a04 	mov.w	sl, #4
c0de2ca4:	08c1      	lsrs	r1, r0, #3
c0de2ca6:	2004      	movs	r0, #4
c0de2ca8:	f005 fa35 	bl	c0de8116 <nbgl_objPoolGet>
c0de2cac:	2701      	movs	r7, #1
c0de2cae:	4606      	mov	r6, r0
        textArea->textColor = LIGHT_TEXT_COLOR;
c0de2cb0:	77c7      	strb	r7, [r0, #31]
        textArea->text      = PIC(info);
c0de2cb2:	4640      	mov	r0, r8
c0de2cb4:	f006 f922 	bl	c0de8efc <pic>
c0de2cb8:	4601      	mov	r1, r0
c0de2cba:	4630      	mov	r0, r6
c0de2cbc:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de2cc0:	0e0a      	lsrs	r2, r1, #24
c0de2cc2:	70c2      	strb	r2, [r0, #3]
c0de2cc4:	0c0a      	lsrs	r2, r1, #16
c0de2cc6:	7082      	strb	r2, [r0, #2]
c0de2cc8:	0a08      	lsrs	r0, r1, #8
c0de2cca:	f886 0027 	strb.w	r0, [r6, #39]	@ 0x27
c0de2cce:	200b      	movs	r0, #11
        textArea->fontId    = SMALL_REGULAR_FONT;
c0de2cd0:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
        textArea->wrapping  = true;
c0de2cd4:	f896 0024 	ldrb.w	r0, [r6, #36]	@ 0x24
c0de2cd8:	2500      	movs	r5, #0
c0de2cda:	f040 0001 	orr.w	r0, r0, #1
c0de2cde:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
c0de2ce2:	20a0      	movs	r0, #160	@ 0xa0
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de2ce4:	7130      	strb	r0, [r6, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de2ce6:	200b      	movs	r0, #11
c0de2ce8:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de2cec:	2301      	movs	r3, #1
        textArea->style     = NO_STYLE;
c0de2cee:	f886 5021 	strb.w	r5, [r6, #33]	@ 0x21
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de2cf2:	7177      	strb	r7, [r6, #5]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de2cf4:	f005 fa28 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de2cf8:	71b0      	strb	r0, [r6, #6]
c0de2cfa:	0a00      	lsrs	r0, r0, #8
c0de2cfc:	71f0      	strb	r0, [r6, #7]
c0de2cfe:	2020      	movs	r0, #32
        textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de2d00:	75f0      	strb	r0, [r6, #23]
c0de2d02:	2028      	movs	r0, #40	@ 0x28
        textArea->obj.alignmentMarginY = 40;
c0de2d04:	7670      	strb	r0, [r6, #25]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de2d06:	f8d4 00a0 	ldr.w	r0, [r4, #160]	@ 0xa0
c0de2d0a:	2107      	movs	r1, #7
    layout->container->children[layout->container->nbChildren] = obj;
c0de2d0c:	f810 2f22 	ldrb.w	r2, [r0, #34]!
        textArea->obj.alignment        = BOTTOM_LEFT;
c0de2d10:	75b1      	strb	r1, [r6, #22]
    layout->container->children[layout->container->nbChildren] = obj;
c0de2d12:	7841      	ldrb	r1, [r0, #1]
c0de2d14:	7883      	ldrb	r3, [r0, #2]
c0de2d16:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de2d1a:	78c2      	ldrb	r2, [r0, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de2d1c:	f810 0c02 	ldrb.w	r0, [r0, #-2]
    layout->container->children[layout->container->nbChildren] = obj;
c0de2d20:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de2d24:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de2d28:	f841 6020 	str.w	r6, [r1, r0, lsl #2]
    layout->container->nbChildren++;
c0de2d2c:	f8d4 00a0 	ldr.w	r0, [r4, #160]	@ 0xa0
        textArea->textAlignment        = MID_LEFT;
c0de2d30:	f886 a020 	strb.w	sl, [r6, #32]
    layout->container->nbChildren++;
c0de2d34:	f890 1020 	ldrb.w	r1, [r0, #32]
        textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de2d38:	7635      	strb	r5, [r6, #24]
    layout->container->nbChildren++;
c0de2d3a:	3101      	adds	r1, #1
        textArea->obj.alignmentMarginY = 40;
c0de2d3c:	76b5      	strb	r5, [r6, #26]
    layout->container->nbChildren++;
c0de2d3e:	f880 1020 	strb.w	r1, [r0, #32]
    return layoutInt->container->obj.area.height;
c0de2d42:	f8d4 00a0 	ldr.w	r0, [r4, #160]	@ 0xa0
c0de2d46:	7981      	ldrb	r1, [r0, #6]
c0de2d48:	79c0      	ldrb	r0, [r0, #7]
c0de2d4a:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de2d4e:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
	...

c0de2d54 <nbgl_layoutAddRadioChoice>:
{
c0de2d54:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de2d58:	b082      	sub	sp, #8
    if (layout == NULL) {
c0de2d5a:	2800      	cmp	r0, #0
c0de2d5c:	f000 8149 	beq.w	c0de2ff2 <nbgl_layoutAddRadioChoice+0x29e>
c0de2d60:	4680      	mov	r8, r0
    for (i = 0; i < choices->nbChoices; i++) {
c0de2d62:	7948      	ldrb	r0, [r1, #5]
c0de2d64:	460d      	mov	r5, r1
c0de2d66:	2800      	cmp	r0, #0
c0de2d68:	f04f 0000 	mov.w	r0, #0
c0de2d6c:	f000 8147 	beq.w	c0de2ffe <nbgl_layoutAddRadioChoice+0x2aa>
c0de2d70:	f04f 0a01 	mov.w	sl, #1
c0de2d74:	f04f 0b02 	mov.w	fp, #2
c0de2d78:	2000      	movs	r0, #0
c0de2d7a:	e9cd 5000 	strd	r5, r0, [sp]
c0de2d7e:	e0a2      	b.n	c0de2ec6 <nbgl_layoutAddRadioChoice+0x172>
        textArea->obj.area.width = container->obj.area.width - RADIO_WIDTH;
c0de2d80:	7938      	ldrb	r0, [r7, #4]
c0de2d82:	7979      	ldrb	r1, [r7, #5]
        container->children[0]   = (nbgl_obj_t *) textArea;
c0de2d84:	f897 2023 	ldrb.w	r2, [r7, #35]	@ 0x23
        textArea->obj.area.width = container->obj.area.width - RADIO_WIDTH;
c0de2d88:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de2d8c:	3828      	subs	r0, #40	@ 0x28
c0de2d8e:	7130      	strb	r0, [r6, #4]
c0de2d90:	0a00      	lsrs	r0, r0, #8
c0de2d92:	7170      	strb	r0, [r6, #5]
c0de2d94:	2000      	movs	r0, #0
        textArea->style          = NO_STYLE;
c0de2d96:	f886 0021 	strb.w	r0, [r6, #33]	@ 0x21
        textArea->obj.alignTo    = (nbgl_obj_t *) container;
c0de2d9a:	4630      	mov	r0, r6
c0de2d9c:	f800 7f12 	strb.w	r7, [r0, #18]!
c0de2da0:	2304      	movs	r3, #4
c0de2da2:	f880 b002 	strb.w	fp, [r0, #2]
c0de2da6:	74f5      	strb	r5, [r6, #19]
        container->children[0]   = (nbgl_obj_t *) textArea;
c0de2da8:	4639      	mov	r1, r7
        textArea->textAlignment  = MID_LEFT;
c0de2daa:	f886 3020 	strb.w	r3, [r6, #32]
        textArea->obj.alignment  = MID_LEFT;
c0de2dae:	75b3      	strb	r3, [r6, #22]
        container->children[0]   = (nbgl_obj_t *) textArea;
c0de2db0:	f811 3f22 	ldrb.w	r3, [r1, #34]!
        textArea->obj.alignTo    = (nbgl_obj_t *) container;
c0de2db4:	f880 a003 	strb.w	sl, [r0, #3]
        container->children[0]   = (nbgl_obj_t *) textArea;
c0de2db8:	7888      	ldrb	r0, [r1, #2]
c0de2dba:	78c9      	ldrb	r1, [r1, #3]
c0de2dbc:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de2dc0:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de2dc4:	ea42 4000 	orr.w	r0, r2, r0, lsl #16
c0de2dc8:	f240 4254 	movw	r2, #1108	@ 0x454
c0de2dcc:	6006      	str	r6, [r0, #0]
        container->obj.touchMask = (1 << TOUCHED);
c0de2dce:	2000      	movs	r0, #0
c0de2dd0:	f2c0 0200 	movt	r2, #0
c0de2dd4:	7778      	strb	r0, [r7, #29]
        container->obj.touchId   = CONTROLS_ID + nbTouchableControls;
c0de2dd6:	f819 0002 	ldrb.w	r0, [r9, r2]
        container->obj.touchMask = (1 << TOUCHED);
c0de2dda:	f887 e01c 	strb.w	lr, [r7, #28]
        container->obj.touchId   = CONTROLS_ID + nbTouchableControls;
c0de2dde:	f100 0114 	add.w	r1, r0, #20
c0de2de2:	77b9      	strb	r1, [r7, #30]
        if (i == choices->initChoice) {
c0de2de4:	f89c 1006 	ldrb.w	r1, [ip, #6]
c0de2de8:	9d01      	ldr	r5, [sp, #4]
        nbTouchableControls++;
c0de2dea:	3001      	adds	r0, #1
c0de2dec:	f809 0002 	strb.w	r0, [r9, r2]
        if (i == choices->initChoice) {
c0de2df0:	1a68      	subs	r0, r5, r1
c0de2df2:	bf18      	it	ne
c0de2df4:	2001      	movne	r0, #1
c0de2df6:	1a69      	subs	r1, r5, r1
c0de2df8:	fab1 f181 	clz	r1, r1
c0de2dfc:	ea4f 1151 	mov.w	r1, r1, lsr #5
c0de2e00:	77f0      	strb	r0, [r6, #31]
c0de2e02:	f04f 000b 	mov.w	r0, #11
c0de2e06:	f04f 0b00 	mov.w	fp, #0
c0de2e0a:	f884 1021 	strb.w	r1, [r4, #33]	@ 0x21
c0de2e0e:	bf08      	it	eq
c0de2e10:	200c      	moveq	r0, #12
c0de2e12:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
c0de2e16:	46e2      	mov	sl, ip
c0de2e18:	2401      	movs	r4, #1
        textArea->obj.area.height = nbgl_getFontHeight(textArea->fontId);
c0de2e1a:	f005 f98b 	bl	c0de8134 <nbgl_getFontHeight>
c0de2e1e:	f886 b007 	strb.w	fp, [r6, #7]
c0de2e22:	71b0      	strb	r0, [r6, #6]
        line                       = createHorizontalLine(layoutInt->layer);
c0de2e24:	f898 00ad 	ldrb.w	r0, [r8, #173]	@ 0xad
c0de2e28:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de2e2a:	2003      	movs	r0, #3
c0de2e2c:	f005 f973 	bl	c0de8116 <nbgl_objPoolGet>
    line->obj.area.width  = SCREEN_WIDTH;
c0de2e30:	21e0      	movs	r1, #224	@ 0xe0
c0de2e32:	f04f 0cff 	mov.w	ip, #255	@ 0xff
c0de2e36:	7101      	strb	r1, [r0, #4]
    line->obj.area.height = 1;
c0de2e38:	7184      	strb	r4, [r0, #6]
        line->obj.alignmentMarginY = -1;
c0de2e3a:	f880 c019 	strb.w	ip, [r0, #25]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de2e3e:	f8d8 10a0 	ldr.w	r1, [r8, #160]	@ 0xa0
    line->lineColor       = LIGHT_GRAY;
c0de2e42:	2202      	movs	r2, #2
c0de2e44:	f880 2020 	strb.w	r2, [r0, #32]
    layout->container->children[layout->container->nbChildren] = obj;
c0de2e48:	f811 2f22 	ldrb.w	r2, [r1, #34]!
    line->obj.area.width  = SCREEN_WIDTH;
c0de2e4c:	7144      	strb	r4, [r0, #5]
    layout->container->children[layout->container->nbChildren] = obj;
c0de2e4e:	784b      	ldrb	r3, [r1, #1]
c0de2e50:	788e      	ldrb	r6, [r1, #2]
c0de2e52:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de2e56:	78cb      	ldrb	r3, [r1, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de2e58:	f811 1c02 	ldrb.w	r1, [r1, #-2]
    layout->container->children[layout->container->nbChildren] = obj;
c0de2e5c:	ea46 2303 	orr.w	r3, r6, r3, lsl #8
c0de2e60:	ea42 4203 	orr.w	r2, r2, r3, lsl #16
c0de2e64:	f842 7021 	str.w	r7, [r2, r1, lsl #2]
    layout->container->nbChildren++;
c0de2e68:	f8d8 10a0 	ldr.w	r1, [r8, #160]	@ 0xa0
    line->direction       = HORIZONTAL;
c0de2e6c:	77c4      	strb	r4, [r0, #31]
    layout->container->children[layout->container->nbChildren] = obj;
c0de2e6e:	f811 2f22 	ldrb.w	r2, [r1, #34]!
    line->thickness       = 1;
c0de2e72:	f880 4021 	strb.w	r4, [r0, #33]	@ 0x21
    layout->container->nbChildren++;
c0de2e76:	f811 3c02 	ldrb.w	r3, [r1, #-2]
    layout->container->children[layout->container->nbChildren] = obj;
c0de2e7a:	784f      	ldrb	r7, [r1, #1]
c0de2e7c:	788e      	ldrb	r6, [r1, #2]
c0de2e7e:	78cc      	ldrb	r4, [r1, #3]
    layout->container->nbChildren++;
c0de2e80:	3301      	adds	r3, #1
    layout->container->children[layout->container->nbChildren] = obj;
c0de2e82:	ea42 2207 	orr.w	r2, r2, r7, lsl #8
c0de2e86:	ea46 2604 	orr.w	r6, r6, r4, lsl #8
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de2e8a:	b2df      	uxtb	r7, r3
    layout->container->children[layout->container->nbChildren] = obj;
c0de2e8c:	ea42 4206 	orr.w	r2, r2, r6, lsl #16
c0de2e90:	f842 0027 	str.w	r0, [r2, r7, lsl #2]
    layout->container->nbChildren++;
c0de2e94:	f8d8 20a0 	ldr.w	r2, [r8, #160]	@ 0xa0
c0de2e98:	f801 3c02 	strb.w	r3, [r1, #-2]
c0de2e9c:	f892 1020 	ldrb.w	r1, [r2, #32]
    line->obj.area.height = 1;
c0de2ea0:	f880 b007 	strb.w	fp, [r0, #7]
        line->obj.alignmentMarginY = -1;
c0de2ea4:	f880 c01a 	strb.w	ip, [r0, #26]
    layout->container->nbChildren++;
c0de2ea8:	1c48      	adds	r0, r1, #1
    for (i = 0; i < choices->nbChoices; i++) {
c0de2eaa:	f89a 1005 	ldrb.w	r1, [sl, #5]
c0de2eae:	3501      	adds	r5, #1
c0de2eb0:	9501      	str	r5, [sp, #4]
c0de2eb2:	428d      	cmp	r5, r1
c0de2eb4:	4655      	mov	r5, sl
c0de2eb6:	f04f 0a01 	mov.w	sl, #1
c0de2eba:	f04f 0b02 	mov.w	fp, #2
    layout->container->nbChildren++;
c0de2ebe:	f882 0020 	strb.w	r0, [r2, #32]
    for (i = 0; i < choices->nbChoices; i++) {
c0de2ec2:	f080 809b 	bcs.w	c0de2ffc <nbgl_layoutAddRadioChoice+0x2a8>
        container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de2ec6:	f898 00ad 	ldrb.w	r0, [r8, #173]	@ 0xad
c0de2eca:	08c1      	lsrs	r1, r0, #3
c0de2ecc:	2001      	movs	r0, #1
c0de2ece:	f005 f922 	bl	c0de8116 <nbgl_objPoolGet>
        textArea  = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de2ed2:	f898 10ad 	ldrb.w	r1, [r8, #173]	@ 0xad
        container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de2ed6:	4607      	mov	r7, r0
        textArea  = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de2ed8:	08c9      	lsrs	r1, r1, #3
c0de2eda:	2004      	movs	r0, #4
c0de2edc:	f005 f91b 	bl	c0de8116 <nbgl_objPoolGet>
        button    = (nbgl_radio_t *) nbgl_objPoolGet(RADIO_BUTTON, layoutInt->layer);
c0de2ee0:	f898 10ad 	ldrb.w	r1, [r8, #173]	@ 0xad
        textArea  = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de2ee4:	4606      	mov	r6, r0
        button    = (nbgl_radio_t *) nbgl_objPoolGet(RADIO_BUTTON, layoutInt->layer);
c0de2ee6:	08c9      	lsrs	r1, r1, #3
c0de2ee8:	2009      	movs	r0, #9
c0de2eea:	f005 f914 	bl	c0de8116 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de2eee:	f898 10ad 	ldrb.w	r1, [r8, #173]	@ 0xad
c0de2ef2:	f898 20ae 	ldrb.w	r2, [r8, #174]	@ 0xae
        button    = (nbgl_radio_t *) nbgl_objPoolGet(RADIO_BUTTON, layoutInt->layer);
c0de2ef6:	4604      	mov	r4, r0
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de2ef8:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de2efc:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de2f00:	2a0e      	cmp	r2, #14
c0de2f02:	d81b      	bhi.n	c0de2f3c <nbgl_layoutAddRadioChoice+0x1e8>
c0de2f04:	0a0b      	lsrs	r3, r1, #8
        layoutObj = &layout->callbackObjPool[layout->nbUsedCallbackObjs];
c0de2f06:	eb08 00c2 	add.w	r0, r8, r2, lsl #3
        layout->nbUsedCallbackObjs++;
c0de2f0a:	1c5a      	adds	r2, r3, #1
c0de2f0c:	f002 023f 	and.w	r2, r2, #63	@ 0x3f
c0de2f10:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
            layoutInt, (nbgl_obj_t *) container, choices->token, choices->tuneId);
c0de2f14:	f895 c007 	ldrb.w	ip, [r5, #7]
c0de2f18:	f895 e008 	ldrb.w	lr, [r5, #8]
        layout->nbUsedCallbackObjs++;
c0de2f1c:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
        layoutObj->obj    = obj;
c0de2f20:	f840 7f20 	str.w	r7, [r0, #32]!
        layout->nbUsedCallbackObjs++;
c0de2f24:	0a12      	lsrs	r2, r2, #8
c0de2f26:	f888 20ae 	strb.w	r2, [r8, #174]	@ 0xae
c0de2f2a:	f888 10ad 	strb.w	r1, [r8, #173]	@ 0xad
        layoutObj->token  = token;
c0de2f2e:	f880 c004 	strb.w	ip, [r0, #4]
        layoutObj->tuneId = tuneId;
c0de2f32:	f880 e006 	strb.w	lr, [r0, #6]
c0de2f36:	b920      	cbnz	r0, c0de2f42 <nbgl_layoutAddRadioChoice+0x1ee>
c0de2f38:	e05b      	b.n	c0de2ff2 <nbgl_layoutAddRadioChoice+0x29e>
c0de2f3a:	bf00      	nop
c0de2f3c:	2000      	movs	r0, #0
        if (obj == NULL) {
c0de2f3e:	2800      	cmp	r0, #0
c0de2f40:	d057      	beq.n	c0de2ff2 <nbgl_layoutAddRadioChoice+0x29e>
        container->nbChildren      = 2;
c0de2f42:	f887 b020 	strb.w	fp, [r7, #32]
        container->children        = nbgl_containerPoolGet(container->nbChildren, layoutInt->layer);
c0de2f46:	f898 00ad 	ldrb.w	r0, [r8, #173]	@ 0xad
c0de2f4a:	08c1      	lsrs	r1, r0, #3
c0de2f4c:	2002      	movs	r0, #2
c0de2f4e:	f005 f8e7 	bl	c0de8120 <nbgl_containerPoolGet>
c0de2f52:	4639      	mov	r1, r7
c0de2f54:	f801 0f22 	strb.w	r0, [r1, #34]!
c0de2f58:	0e02      	lsrs	r2, r0, #24
c0de2f5a:	70ca      	strb	r2, [r1, #3]
c0de2f5c:	0c02      	lsrs	r2, r0, #16
c0de2f5e:	708a      	strb	r2, [r1, #2]
c0de2f60:	0a01      	lsrs	r1, r0, #8
c0de2f62:	f887 1023 	strb.w	r1, [r7, #35]	@ 0x23
        container->obj.area.width  = AVAILABLE_WIDTH;
c0de2f66:	21a0      	movs	r1, #160	@ 0xa0
c0de2f68:	7139      	strb	r1, [r7, #4]
        container->obj.area.height = RADIO_CHOICE_HEIGHT;
c0de2f6a:	215c      	movs	r1, #92	@ 0x5c
c0de2f6c:	71b9      	strb	r1, [r7, #6]
        container->obj.alignmentMarginX = BORDER_MARGIN;
c0de2f6e:	2120      	movs	r1, #32
c0de2f70:	2200      	movs	r2, #0
c0de2f72:	75f9      	strb	r1, [r7, #23]
        container->obj.alignTo          = (nbgl_obj_t *) NULL;
c0de2f74:	4639      	mov	r1, r7
c0de2f76:	f801 2f12 	strb.w	r2, [r1, #18]!
c0de2f7a:	70ca      	strb	r2, [r1, #3]
c0de2f7c:	708a      	strb	r2, [r1, #2]
        button->obj.alignTo    = (nbgl_obj_t *) container;
c0de2f7e:	4621      	mov	r1, r4
        container->obj.area.width  = AVAILABLE_WIDTH;
c0de2f80:	f887 a005 	strb.w	sl, [r7, #5]
        container->obj.area.height = RADIO_CHOICE_HEIGHT;
c0de2f84:	71fa      	strb	r2, [r7, #7]
        container->obj.alignment   = NO_ALIGNMENT;
c0de2f86:	75ba      	strb	r2, [r7, #22]
        container->obj.alignmentMarginX = BORDER_MARGIN;
c0de2f88:	763a      	strb	r2, [r7, #24]
        container->obj.alignTo          = (nbgl_obj_t *) NULL;
c0de2f8a:	74fa      	strb	r2, [r7, #19]
c0de2f8c:	46ac      	mov	ip, r5
        button->obj.alignTo    = (nbgl_obj_t *) container;
c0de2f8e:	0a3d      	lsrs	r5, r7, #8
c0de2f90:	f801 7f12 	strb.w	r7, [r1, #18]!
c0de2f94:	ea4f 4b17 	mov.w	fp, r7, lsr #16
c0de2f98:	74e5      	strb	r5, [r4, #19]
c0de2f9a:	ea4f 6a17 	mov.w	sl, r7, lsr #24
c0de2f9e:	f881 b002 	strb.w	fp, [r1, #2]
c0de2fa2:	f881 a003 	strb.w	sl, [r1, #3]
        if (choices->localized == true) {
c0de2fa6:	f89c 1004 	ldrb.w	r1, [ip, #4]
c0de2faa:	f04f 0e01 	mov.w	lr, #1
c0de2fae:	2302      	movs	r3, #2
        container->children[1] = (nbgl_obj_t *) button;
c0de2fb0:	6044      	str	r4, [r0, #4]
        if (choices->localized == true) {
c0de2fb2:	2900      	cmp	r1, #0
        button->obj.alignment  = MID_RIGHT;
c0de2fb4:	f04f 0006 	mov.w	r0, #6
        button->activeColor    = BLACK;
c0de2fb8:	77e2      	strb	r2, [r4, #31]
        button->borderColor    = LIGHT_GRAY;
c0de2fba:	f884 3020 	strb.w	r3, [r4, #32]
        button->obj.alignment  = MID_RIGHT;
c0de2fbe:	75a0      	strb	r0, [r4, #22]
        button->state          = OFF_STATE;
c0de2fc0:	f884 2021 	strb.w	r2, [r4, #33]	@ 0x21
        if (choices->localized == true) {
c0de2fc4:	f47f aedc 	bne.w	c0de2d80 <nbgl_layoutAddRadioChoice+0x2c>
            textArea->text = PIC(choices->names[i]);
c0de2fc8:	f8dc 0000 	ldr.w	r0, [ip]
c0de2fcc:	9901      	ldr	r1, [sp, #4]
c0de2fce:	f850 0021 	ldr.w	r0, [r0, r1, lsl #2]
c0de2fd2:	f005 ff93 	bl	c0de8efc <pic>
c0de2fd6:	4631      	mov	r1, r6
c0de2fd8:	f8dd c000 	ldr.w	ip, [sp]
c0de2fdc:	f801 0f26 	strb.w	r0, [r1, #38]!
c0de2fe0:	0e02      	lsrs	r2, r0, #24
c0de2fe2:	f04f 0e01 	mov.w	lr, #1
c0de2fe6:	70ca      	strb	r2, [r1, #3]
c0de2fe8:	0c02      	lsrs	r2, r0, #16
c0de2fea:	0a00      	lsrs	r0, r0, #8
c0de2fec:	708a      	strb	r2, [r1, #2]
c0de2fee:	7048      	strb	r0, [r1, #1]
c0de2ff0:	e6c6      	b.n	c0de2d80 <nbgl_layoutAddRadioChoice+0x2c>
c0de2ff2:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
}
c0de2ff6:	b002      	add	sp, #8
c0de2ff8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de2ffc:	2000      	movs	r0, #0
c0de2ffe:	b002      	add	sp, #8
c0de3000:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de3004 <nbgl_layoutAddCenteredInfo>:
{
c0de3004:	b570      	push	{r4, r5, r6, lr}
c0de3006:	b08a      	sub	sp, #40	@ 0x28
c0de3008:	ae01      	add	r6, sp, #4
c0de300a:	460c      	mov	r4, r1
c0de300c:	4605      	mov	r5, r0
    nbgl_contentCenter_t   centeredInfo = {0};
c0de300e:	4630      	mov	r0, r6
c0de3010:	2124      	movs	r1, #36	@ 0x24
c0de3012:	f006 f967 	bl	c0de92e4 <__aeabi_memclr>
    if (layout == NULL) {
c0de3016:	b36d      	cbz	r5, c0de3074 <nbgl_layoutAddCenteredInfo+0x70>
    centeredInfo.icon        = info->icon;
c0de3018:	68e1      	ldr	r1, [r4, #12]
    if (info->text1 != NULL) {
c0de301a:	6820      	ldr	r0, [r4, #0]
    centeredInfo.icon        = info->icon;
c0de301c:	9102      	str	r1, [sp, #8]
c0de301e:	2100      	movs	r1, #0
    centeredInfo.illustrType = ICON_ILLUSTRATION;
c0de3020:	f88d 1004 	strb.w	r1, [sp, #4]
    if (info->text1 != NULL) {
c0de3024:	b128      	cbz	r0, c0de3032 <nbgl_layoutAddCenteredInfo+0x2e>
        if (info->style != NORMAL_INFO) {
c0de3026:	7c61      	ldrb	r1, [r4, #17]
c0de3028:	2210      	movs	r2, #16
c0de302a:	2903      	cmp	r1, #3
c0de302c:	bf08      	it	eq
c0de302e:	2214      	moveq	r2, #20
c0de3030:	50b0      	str	r0, [r6, r2]
    if (info->text2 != NULL) {
c0de3032:	6860      	ldr	r0, [r4, #4]
c0de3034:	b128      	cbz	r0, c0de3042 <nbgl_layoutAddCenteredInfo+0x3e>
        if (info->style != LARGE_CASE_BOLD_INFO) {
c0de3036:	7c61      	ldrb	r1, [r4, #17]
c0de3038:	2218      	movs	r2, #24
c0de303a:	2901      	cmp	r1, #1
c0de303c:	bf08      	it	eq
c0de303e:	2214      	moveq	r2, #20
c0de3040:	50b0      	str	r0, [r6, r2]
    if (info->text3 != NULL) {
c0de3042:	68a0      	ldr	r0, [r4, #8]
c0de3044:	b128      	cbz	r0, c0de3052 <nbgl_layoutAddCenteredInfo+0x4e>
        if (info->style == LARGE_CASE_GRAY_INFO) {
c0de3046:	7c61      	ldrb	r1, [r4, #17]
c0de3048:	2218      	movs	r2, #24
c0de304a:	2902      	cmp	r1, #2
c0de304c:	bf08      	it	eq
c0de304e:	221c      	moveq	r2, #28
c0de3050:	50b0      	str	r0, [r6, r2]
c0de3052:	a901      	add	r1, sp, #4
    container = addContentCenter(layoutInt, &centeredInfo);
c0de3054:	4628      	mov	r0, r5
c0de3056:	f000 f81b 	bl	c0de3090 <addContentCenter>
    if (info->onTop) {
c0de305a:	7c21      	ldrb	r1, [r4, #16]
c0de305c:	b171      	cbz	r1, c0de307c <nbgl_layoutAddCenteredInfo+0x78>
c0de305e:	2100      	movs	r1, #0
c0de3060:	2220      	movs	r2, #32
        container->obj.alignmentMarginX = BORDER_MARGIN;
c0de3062:	7601      	strb	r1, [r0, #24]
c0de3064:	75c2      	strb	r2, [r0, #23]
        container->obj.alignmentMarginY = BORDER_MARGIN + info->offsetY;
c0de3066:	8a62      	ldrh	r2, [r4, #18]
        container->obj.alignment        = NO_ALIGNMENT;
c0de3068:	7581      	strb	r1, [r0, #22]
        container->obj.alignmentMarginY = BORDER_MARGIN + info->offsetY;
c0de306a:	3220      	adds	r2, #32
c0de306c:	7642      	strb	r2, [r0, #25]
c0de306e:	0a12      	lsrs	r2, r2, #8
c0de3070:	7682      	strb	r2, [r0, #26]
c0de3072:	e007      	b.n	c0de3084 <nbgl_layoutAddCenteredInfo+0x80>
c0de3074:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
}
c0de3078:	b00a      	add	sp, #40	@ 0x28
c0de307a:	bd70      	pop	{r4, r5, r6, pc}
        container->obj.alignmentMarginY = info->offsetY;
c0de307c:	8a61      	ldrh	r1, [r4, #18]
c0de307e:	7641      	strb	r1, [r0, #25]
c0de3080:	0a09      	lsrs	r1, r1, #8
c0de3082:	7681      	strb	r1, [r0, #26]
    return container->obj.area.height;
c0de3084:	7981      	ldrb	r1, [r0, #6]
c0de3086:	79c0      	ldrb	r0, [r0, #7]
c0de3088:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
}
c0de308c:	b00a      	add	sp, #40	@ 0x28
c0de308e:	bd70      	pop	{r4, r5, r6, pc}

c0de3090 <addContentCenter>:
{
c0de3090:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de3094:	b084      	sub	sp, #16
c0de3096:	4682      	mov	sl, r0
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de3098:	f890 00ad 	ldrb.w	r0, [r0, #173]	@ 0xad
c0de309c:	4688      	mov	r8, r1
c0de309e:	08c1      	lsrs	r1, r0, #3
c0de30a0:	2001      	movs	r0, #1
c0de30a2:	f005 f838 	bl	c0de8116 <nbgl_objPoolGet>
c0de30a6:	2700      	movs	r7, #0
    container->nbChildren = 0;
c0de30a8:	f880 7020 	strb.w	r7, [r0, #32]
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de30ac:	4683      	mov	fp, r0
    container->children = nbgl_containerPoolGet(6, layoutInt->layer);
c0de30ae:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de30b2:	08c1      	lsrs	r1, r0, #3
c0de30b4:	2006      	movs	r0, #6
c0de30b6:	f005 f833 	bl	c0de8120 <nbgl_containerPoolGet>
c0de30ba:	4659      	mov	r1, fp
c0de30bc:	f801 0f22 	strb.w	r0, [r1, #34]!
c0de30c0:	0c02      	lsrs	r2, r0, #16
c0de30c2:	708a      	strb	r2, [r1, #2]
c0de30c4:	0a02      	lsrs	r2, r0, #8
c0de30c6:	f88b 2023 	strb.w	r2, [fp, #35]	@ 0x23
    if (info->icon != NULL) {
c0de30ca:	f8d8 2004 	ldr.w	r2, [r8, #4]
    container->children = nbgl_containerPoolGet(6, layoutInt->layer);
c0de30ce:	0e00      	lsrs	r0, r0, #24
    if (info->icon != NULL) {
c0de30d0:	2a00      	cmp	r2, #0
    container->children = nbgl_containerPoolGet(6, layoutInt->layer);
c0de30d2:	70c8      	strb	r0, [r1, #3]
    if (info->icon != NULL) {
c0de30d4:	f000 80ac 	beq.w	c0de3230 <addContentCenter+0x1a0>
        image                       = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de30d8:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de30dc:	2402      	movs	r4, #2
c0de30de:	08c1      	lsrs	r1, r0, #3
c0de30e0:	2002      	movs	r0, #2
c0de30e2:	f005 f818 	bl	c0de8116 <nbgl_objPoolGet>
        image->foregroundColor      = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de30e6:	f99a 10ae 	ldrsb.w	r1, [sl, #174]	@ 0xae
c0de30ea:	f89a 20ad 	ldrb.w	r2, [sl, #173]	@ 0xad
        image                       = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de30ee:	4607      	mov	r7, r0
        image->foregroundColor      = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de30f0:	ea42 2001 	orr.w	r0, r2, r1, lsl #8
c0de30f4:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
c0de30f8:	f04f 0003 	mov.w	r0, #3
c0de30fc:	bfc8      	it	gt
c0de30fe:	2000      	movgt	r0, #0
c0de3100:	77f8      	strb	r0, [r7, #31]
        image->buffer               = PIC(info->icon);
c0de3102:	f8d8 0004 	ldr.w	r0, [r8, #4]
c0de3106:	2503      	movs	r5, #3
c0de3108:	f005 fef8 	bl	c0de8efc <pic>
c0de310c:	4639      	mov	r1, r7
c0de310e:	f801 0f21 	strb.w	r0, [r1, #33]!
c0de3112:	0e02      	lsrs	r2, r0, #24
c0de3114:	70ca      	strb	r2, [r1, #3]
c0de3116:	0c02      	lsrs	r2, r0, #16
c0de3118:	708a      	strb	r2, [r1, #2]
c0de311a:	0a01      	lsrs	r1, r0, #8
c0de311c:	f887 1022 	strb.w	r1, [r7, #34]	@ 0x22
        image->obj.alignmentMarginY = info->iconHug;
c0de3120:	f8b8 1020 	ldrh.w	r1, [r8, #32]
        image->obj.alignment        = TOP_MIDDLE;
c0de3124:	75bc      	strb	r4, [r7, #22]
        image->obj.alignmentMarginY = info->iconHug;
c0de3126:	7679      	strb	r1, [r7, #25]
c0de3128:	0a0a      	lsrs	r2, r1, #8
        fullHeight += image->buffer->height + info->iconHug;
c0de312a:	7883      	ldrb	r3, [r0, #2]
c0de312c:	78c0      	ldrb	r0, [r0, #3]
        image->obj.alignmentMarginY = info->iconHug;
c0de312e:	76ba      	strb	r2, [r7, #26]
        container->children[container->nbChildren] = (nbgl_obj_t *) image;
c0de3130:	465a      	mov	r2, fp
        fullHeight += image->buffer->height + info->iconHug;
c0de3132:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
        container->children[container->nbChildren] = (nbgl_obj_t *) image;
c0de3136:	f812 3f22 	ldrb.w	r3, [r2, #34]!
        fullHeight += image->buffer->height + info->iconHug;
c0de313a:	eb00 0c01 	add.w	ip, r0, r1
        container->children[container->nbChildren] = (nbgl_obj_t *) image;
c0de313e:	7851      	ldrb	r1, [r2, #1]
c0de3140:	7896      	ldrb	r6, [r2, #2]
c0de3142:	78d4      	ldrb	r4, [r2, #3]
c0de3144:	f812 0c02 	ldrb.w	r0, [r2, #-2]
c0de3148:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de314c:	ea46 2304 	orr.w	r3, r6, r4, lsl #8
c0de3150:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
c0de3154:	f841 7020 	str.w	r7, [r1, r0, lsl #2]
        if (info->illustrType == ANIM_ILLUSTRATION) {
c0de3158:	f898 1000 	ldrb.w	r1, [r8]
        container->nbChildren++;
c0de315c:	3001      	adds	r0, #1
        if (info->illustrType == ANIM_ILLUSTRATION) {
c0de315e:	2901      	cmp	r1, #1
        container->nbChildren++;
c0de3160:	f802 0c02 	strb.w	r0, [r2, #-2]
        if (info->illustrType == ANIM_ILLUSTRATION) {
c0de3164:	d166      	bne.n	c0de3234 <addContentCenter+0x1a4>
            anim                       = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de3166:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de316a:	f8cd c000 	str.w	ip, [sp]
c0de316e:	08c1      	lsrs	r1, r0, #3
c0de3170:	2002      	movs	r0, #2
c0de3172:	f004 ffd0 	bl	c0de8116 <nbgl_objPoolGet>
            anim->foregroundColor      = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3176:	f99a 10ae 	ldrsb.w	r1, [sl, #174]	@ 0xae
c0de317a:	f89a 20ad 	ldrb.w	r2, [sl, #173]	@ 0xad
            anim                       = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de317e:	4606      	mov	r6, r0
            anim->foregroundColor      = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3180:	ea42 2001 	orr.w	r0, r2, r1, lsl #8
            anim->buffer               = PIC(info->animation->icons[0]);
c0de3184:	f8d8 1008 	ldr.w	r1, [r8, #8]
            anim->foregroundColor      = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3188:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
c0de318c:	bfc8      	it	gt
c0de318e:	2500      	movgt	r5, #0
            anim->buffer               = PIC(info->animation->icons[0]);
c0de3190:	6808      	ldr	r0, [r1, #0]
            anim->foregroundColor      = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3192:	77f5      	strb	r5, [r6, #31]
            anim->buffer               = PIC(info->animation->icons[0]);
c0de3194:	6800      	ldr	r0, [r0, #0]
c0de3196:	f005 feb1 	bl	c0de8efc <pic>
c0de319a:	4631      	mov	r1, r6
c0de319c:	f801 0f21 	strb.w	r0, [r1, #33]!
c0de31a0:	0e02      	lsrs	r2, r0, #24
c0de31a2:	70ca      	strb	r2, [r1, #3]
c0de31a4:	0c02      	lsrs	r2, r0, #16
c0de31a6:	0a00      	lsrs	r0, r0, #8
c0de31a8:	708a      	strb	r2, [r1, #2]
c0de31aa:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
            anim->obj.alignmentMarginY = info->iconHug + info->animOffsetY;
c0de31ae:	f8b8 0020 	ldrh.w	r0, [r8, #32]
c0de31b2:	f8b8 100e 	ldrh.w	r1, [r8, #14]
            anim->obj.alignment        = TOP_MIDDLE;
c0de31b6:	2202      	movs	r2, #2
            anim->obj.alignmentMarginY = info->iconHug + info->animOffsetY;
c0de31b8:	4408      	add	r0, r1
c0de31ba:	7670      	strb	r0, [r6, #25]
            anim->obj.alignmentMarginX = info->animOffsetX;
c0de31bc:	f8b8 100c 	ldrh.w	r1, [r8, #12]
            anim->obj.alignmentMarginY = info->iconHug + info->animOffsetY;
c0de31c0:	0a00      	lsrs	r0, r0, #8
c0de31c2:	76b0      	strb	r0, [r6, #26]
            anim->obj.alignmentMarginX = info->animOffsetX;
c0de31c4:	75f1      	strb	r1, [r6, #23]
c0de31c6:	0a08      	lsrs	r0, r1, #8
            container->children[container->nbChildren] = (nbgl_obj_t *) anim;
c0de31c8:	4659      	mov	r1, fp
c0de31ca:	f811 cf22 	ldrb.w	ip, [r1, #34]!
            anim->obj.alignment        = TOP_MIDDLE;
c0de31ce:	75b2      	strb	r2, [r6, #22]
            container->children[container->nbChildren] = (nbgl_obj_t *) anim;
c0de31d0:	784b      	ldrb	r3, [r1, #1]
c0de31d2:	788c      	ldrb	r4, [r1, #2]
c0de31d4:	78ca      	ldrb	r2, [r1, #3]
            anim->obj.alignmentMarginX = info->animOffsetX;
c0de31d6:	7630      	strb	r0, [r6, #24]
            container->children[container->nbChildren] = (nbgl_obj_t *) anim;
c0de31d8:	f811 0c02 	ldrb.w	r0, [r1, #-2]
c0de31dc:	ea4c 2303 	orr.w	r3, ip, r3, lsl #8
c0de31e0:	ea44 2202 	orr.w	r2, r4, r2, lsl #8
c0de31e4:	ea43 4202 	orr.w	r2, r3, r2, lsl #16
c0de31e8:	f842 6020 	str.w	r6, [r2, r0, lsl #2]
            container->nbChildren++;
c0de31ec:	3001      	adds	r0, #1
c0de31ee:	f801 0c02 	strb.w	r0, [r1, #-2]
            layoutInt->animation     = info->animation;
c0de31f2:	f8d8 0008 	ldr.w	r0, [r8, #8]
            layoutInt->incrementAnim = true;
c0de31f6:	f89a 10ad 	ldrb.w	r1, [sl, #173]	@ 0xad
            layoutInt->animation     = info->animation;
c0de31fa:	f8ca 00a4 	str.w	r0, [sl, #164]	@ 0xa4
            layoutInt->incrementAnim = true;
c0de31fe:	f041 0004 	orr.w	r0, r1, #4
c0de3202:	f88a 00ad 	strb.w	r0, [sl, #173]	@ 0xad
            tickerCfg.tickerIntervale = info->animation->delayMs;  // ms
c0de3206:	f8d8 0008 	ldr.w	r0, [r8, #8]
c0de320a:	2200      	movs	r2, #0
c0de320c:	88c0      	ldrh	r0, [r0, #6]
            layoutInt->iconIdxInAnim = 0;
c0de320e:	f88a 20af 	strb.w	r2, [sl, #175]	@ 0xaf
            tickerCfg.tickerValue     = info->animation->delayMs;  // ms
c0de3212:	e9cd 0002 	strd	r0, r0, [sp, #8]
            tickerCfg.tickerCallback  = &animTickerCallback;
c0de3216:	f641 00d7 	movw	r0, #6359	@ 0x18d7
c0de321a:	f2c0 0000 	movt	r0, #0
c0de321e:	4478      	add	r0, pc
c0de3220:	9001      	str	r0, [sp, #4]
            nbgl_screenUpdateTicker(layoutInt->layer, &tickerCfg);
c0de3222:	08c8      	lsrs	r0, r1, #3
c0de3224:	a901      	add	r1, sp, #4
c0de3226:	f004 ff6c 	bl	c0de8102 <nbgl_screenUpdateTicker>
c0de322a:	f8dd c000 	ldr.w	ip, [sp]
c0de322e:	e001      	b.n	c0de3234 <addContentCenter+0x1a4>
c0de3230:	f04f 0c00 	mov.w	ip, #0
    if (info->title != NULL) {
c0de3234:	f8d8 0010 	ldr.w	r0, [r8, #16]
c0de3238:	2800      	cmp	r0, #0
c0de323a:	d06b      	beq.n	c0de3314 <addContentCenter+0x284>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de323c:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de3240:	4664      	mov	r4, ip
c0de3242:	08c1      	lsrs	r1, r0, #3
c0de3244:	2004      	movs	r0, #4
c0de3246:	f004 ff66 	bl	c0de8116 <nbgl_objPoolGet>
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de324a:	f99a 10ae 	ldrsb.w	r1, [sl, #174]	@ 0xae
c0de324e:	f89a 20ad 	ldrb.w	r2, [sl, #173]	@ 0xad
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3252:	4606      	mov	r6, r0
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3254:	ea42 2001 	orr.w	r0, r2, r1, lsl #8
c0de3258:	2103      	movs	r1, #3
c0de325a:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
c0de325e:	bfc8      	it	gt
c0de3260:	2100      	movgt	r1, #0
        textArea->text          = PIC(info->title);
c0de3262:	f8d8 0010 	ldr.w	r0, [r8, #16]
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3266:	77f1      	strb	r1, [r6, #31]
        textArea->text          = PIC(info->title);
c0de3268:	f005 fe48 	bl	c0de8efc <pic>
c0de326c:	4601      	mov	r1, r0
c0de326e:	4630      	mov	r0, r6
c0de3270:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de3274:	0e0a      	lsrs	r2, r1, #24
c0de3276:	70c2      	strb	r2, [r0, #3]
c0de3278:	0c0a      	lsrs	r2, r1, #16
c0de327a:	7082      	strb	r2, [r0, #2]
c0de327c:	0a08      	lsrs	r0, r1, #8
c0de327e:	f886 0027 	strb.w	r0, [r6, #39]	@ 0x27
c0de3282:	2005      	movs	r0, #5
        textArea->wrapping      = true;
c0de3284:	f896 2024 	ldrb.w	r2, [r6, #36]	@ 0x24
        textArea->textAlignment = CENTER;
c0de3288:	f886 0020 	strb.w	r0, [r6, #32]
c0de328c:	200d      	movs	r0, #13
        textArea->fontId        = LARGE_MEDIUM_FONT;
c0de328e:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
        textArea->wrapping      = true;
c0de3292:	f042 0001 	orr.w	r0, r2, #1
c0de3296:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
c0de329a:	2001      	movs	r0, #1
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de329c:	7170      	strb	r0, [r6, #5]
c0de329e:	20a0      	movs	r0, #160	@ 0xa0
c0de32a0:	7130      	strb	r0, [r6, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de32a2:	200d      	movs	r0, #13
c0de32a4:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de32a8:	2301      	movs	r3, #1
c0de32aa:	f004 ff4d 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de32ae:	71b0      	strb	r0, [r6, #6]
        if (container->nbChildren > 0) {
c0de32b0:	f89b 1020 	ldrb.w	r1, [fp, #32]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de32b4:	0a02      	lsrs	r2, r0, #8
c0de32b6:	71f2      	strb	r2, [r6, #7]
        if (container->nbChildren > 0) {
c0de32b8:	b191      	cbz	r1, c0de32e0 <addContentCenter+0x250>
            textArea->obj.alignTo          = (nbgl_obj_t *) image;
c0de32ba:	4632      	mov	r2, r6
c0de32bc:	f802 7f12 	strb.w	r7, [r2, #18]!
c0de32c0:	2308      	movs	r3, #8
            textArea->obj.alignment        = BOTTOM_MIDDLE;
c0de32c2:	7113      	strb	r3, [r2, #4]
            textArea->obj.alignTo          = (nbgl_obj_t *) image;
c0de32c4:	0c3b      	lsrs	r3, r7, #16
c0de32c6:	7093      	strb	r3, [r2, #2]
c0de32c8:	0e3b      	lsrs	r3, r7, #24
c0de32ca:	0a3f      	lsrs	r7, r7, #8
c0de32cc:	7057      	strb	r7, [r2, #1]
            textArea->obj.alignmentMarginY = ICON_TITLE_MARGIN + info->iconHug;
c0de32ce:	f8b8 7020 	ldrh.w	r7, [r8, #32]
            textArea->obj.alignTo          = (nbgl_obj_t *) image;
c0de32d2:	70d3      	strb	r3, [r2, #3]
            textArea->obj.alignmentMarginY = ICON_TITLE_MARGIN + info->iconHug;
c0de32d4:	f107 0318 	add.w	r3, r7, #24
c0de32d8:	71d3      	strb	r3, [r2, #7]
c0de32da:	0a1b      	lsrs	r3, r3, #8
c0de32dc:	7213      	strb	r3, [r2, #8]
c0de32de:	e001      	b.n	c0de32e4 <addContentCenter+0x254>
c0de32e0:	2202      	movs	r2, #2
            textArea->obj.alignment = TOP_MIDDLE;
c0de32e2:	75b2      	strb	r2, [r6, #22]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de32e4:	7e72      	ldrb	r2, [r6, #25]
c0de32e6:	7eb3      	ldrb	r3, [r6, #26]
c0de32e8:	4420      	add	r0, r4
c0de32ea:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de32ee:	465b      	mov	r3, fp
c0de32f0:	f813 7f22 	ldrb.w	r7, [r3, #34]!
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de32f4:	eb00 0c02 	add.w	ip, r0, r2
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de32f8:	7858      	ldrb	r0, [r3, #1]
c0de32fa:	789a      	ldrb	r2, [r3, #2]
c0de32fc:	78dc      	ldrb	r4, [r3, #3]
c0de32fe:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de3302:	ea42 2204 	orr.w	r2, r2, r4, lsl #8
c0de3306:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de330a:	f840 6021 	str.w	r6, [r0, r1, lsl #2]
        container->nbChildren++;
c0de330e:	1c48      	adds	r0, r1, #1
c0de3310:	f803 0c02 	strb.w	r0, [r3, #-2]
    if (info->smallTitle != NULL) {
c0de3314:	f8d8 0014 	ldr.w	r0, [r8, #20]
c0de3318:	2800      	cmp	r0, #0
c0de331a:	f000 808b 	beq.w	c0de3434 <addContentCenter+0x3a4>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de331e:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de3322:	f8cd c000 	str.w	ip, [sp]
c0de3326:	08c1      	lsrs	r1, r0, #3
c0de3328:	2004      	movs	r0, #4
c0de332a:	f004 fef4 	bl	c0de8116 <nbgl_objPoolGet>
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de332e:	f99a 10ae 	ldrsb.w	r1, [sl, #174]	@ 0xae
c0de3332:	f89a 20ad 	ldrb.w	r2, [sl, #173]	@ 0xad
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3336:	4605      	mov	r5, r0
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3338:	ea42 2001 	orr.w	r0, r2, r1, lsl #8
c0de333c:	2103      	movs	r1, #3
c0de333e:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
c0de3342:	bfc8      	it	gt
c0de3344:	2100      	movgt	r1, #0
        textArea->text          = PIC(info->smallTitle);
c0de3346:	f8d8 0014 	ldr.w	r0, [r8, #20]
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de334a:	77e9      	strb	r1, [r5, #31]
        textArea->text          = PIC(info->smallTitle);
c0de334c:	f005 fdd6 	bl	c0de8efc <pic>
c0de3350:	4601      	mov	r1, r0
c0de3352:	4628      	mov	r0, r5
c0de3354:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de3358:	0e0a      	lsrs	r2, r1, #24
c0de335a:	70c2      	strb	r2, [r0, #3]
c0de335c:	0c0a      	lsrs	r2, r1, #16
c0de335e:	7082      	strb	r2, [r0, #2]
c0de3360:	0a08      	lsrs	r0, r1, #8
c0de3362:	f885 0027 	strb.w	r0, [r5, #39]	@ 0x27
c0de3366:	2005      	movs	r0, #5
        textArea->wrapping      = true;
c0de3368:	f895 2024 	ldrb.w	r2, [r5, #36]	@ 0x24
        textArea->textAlignment = CENTER;
c0de336c:	f885 0020 	strb.w	r0, [r5, #32]
c0de3370:	200c      	movs	r0, #12
        textArea->fontId        = SMALL_BOLD_FONT;
c0de3372:	f885 0022 	strb.w	r0, [r5, #34]	@ 0x22
        textArea->wrapping      = true;
c0de3376:	f042 0001 	orr.w	r0, r2, #1
c0de337a:	f885 0024 	strb.w	r0, [r5, #36]	@ 0x24
c0de337e:	2001      	movs	r0, #1
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de3380:	7168      	strb	r0, [r5, #5]
c0de3382:	20a0      	movs	r0, #160	@ 0xa0
c0de3384:	7128      	strb	r0, [r5, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3386:	200c      	movs	r0, #12
c0de3388:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de338c:	2301      	movs	r3, #1
c0de338e:	f004 fedb 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de3392:	71a8      	strb	r0, [r5, #6]
        if (container->nbChildren > 0) {
c0de3394:	f89b 1020 	ldrb.w	r1, [fp, #32]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3398:	0a02      	lsrs	r2, r0, #8
c0de339a:	71ea      	strb	r2, [r5, #7]
        if (container->nbChildren > 0) {
c0de339c:	b359      	cbz	r1, c0de33f6 <addContentCenter+0x366>
            textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de339e:	465a      	mov	r2, fp
c0de33a0:	f812 3f22 	ldrb.w	r3, [r2, #34]!
c0de33a4:	462f      	mov	r7, r5
c0de33a6:	7856      	ldrb	r6, [r2, #1]
c0de33a8:	7894      	ldrb	r4, [r2, #2]
c0de33aa:	78d2      	ldrb	r2, [r2, #3]
c0de33ac:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de33b0:	ea44 2202 	orr.w	r2, r4, r2, lsl #8
c0de33b4:	ea43 4202 	orr.w	r2, r3, r2, lsl #16
c0de33b8:	eb02 0281 	add.w	r2, r2, r1, lsl #2
c0de33bc:	f852 3c04 	ldr.w	r3, [r2, #-4]
c0de33c0:	f807 3f12 	strb.w	r3, [r7, #18]!
c0de33c4:	0e1e      	lsrs	r6, r3, #24
c0de33c6:	70fe      	strb	r6, [r7, #3]
c0de33c8:	0c1e      	lsrs	r6, r3, #16
c0de33ca:	0a1b      	lsrs	r3, r3, #8
c0de33cc:	707b      	strb	r3, [r7, #1]
c0de33ce:	2318      	movs	r3, #24
c0de33d0:	70be      	strb	r6, [r7, #2]
            textArea->obj.alignmentMarginY = VERTICAL_BORDER_MARGIN;
c0de33d2:	71fb      	strb	r3, [r7, #7]
            if (container->children[container->nbChildren - 1]->type == IMAGE) {
c0de33d4:	f852 2c04 	ldr.w	r2, [r2, #-4]
c0de33d8:	2608      	movs	r6, #8
c0de33da:	7ed3      	ldrb	r3, [r2, #27]
c0de33dc:	2200      	movs	r2, #0
            textArea->obj.alignment = BOTTOM_MIDDLE;
c0de33de:	713e      	strb	r6, [r7, #4]
            textArea->obj.alignmentMarginY = VERTICAL_BORDER_MARGIN;
c0de33e0:	723a      	strb	r2, [r7, #8]
c0de33e2:	9f00      	ldr	r7, [sp, #0]
            if (container->children[container->nbChildren - 1]->type == IMAGE) {
c0de33e4:	2b02      	cmp	r3, #2
c0de33e6:	d10a      	bne.n	c0de33fe <addContentCenter+0x36e>
                textArea->obj.alignmentMarginY = VERTICAL_BORDER_MARGIN + info->iconHug;
c0de33e8:	f8b8 2020 	ldrh.w	r2, [r8, #32]
c0de33ec:	3218      	adds	r2, #24
c0de33ee:	766a      	strb	r2, [r5, #25]
c0de33f0:	0a12      	lsrs	r2, r2, #8
c0de33f2:	76aa      	strb	r2, [r5, #26]
c0de33f4:	e006      	b.n	c0de3404 <addContentCenter+0x374>
c0de33f6:	9f00      	ldr	r7, [sp, #0]
c0de33f8:	2202      	movs	r2, #2
            textArea->obj.alignment = TOP_MIDDLE;
c0de33fa:	75aa      	strb	r2, [r5, #22]
c0de33fc:	e002      	b.n	c0de3404 <addContentCenter+0x374>
                textArea->obj.alignmentMarginY = TITLE_DESC_MARGIN;
c0de33fe:	76aa      	strb	r2, [r5, #26]
c0de3400:	2210      	movs	r2, #16
c0de3402:	766a      	strb	r2, [r5, #25]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de3404:	7e6a      	ldrb	r2, [r5, #25]
c0de3406:	7eab      	ldrb	r3, [r5, #26]
c0de3408:	4438      	add	r0, r7
c0de340a:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de340e:	465b      	mov	r3, fp
c0de3410:	f813 7f22 	ldrb.w	r7, [r3, #34]!
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de3414:	eb00 0c02 	add.w	ip, r0, r2
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3418:	7858      	ldrb	r0, [r3, #1]
c0de341a:	789a      	ldrb	r2, [r3, #2]
c0de341c:	78de      	ldrb	r6, [r3, #3]
c0de341e:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de3422:	ea42 2206 	orr.w	r2, r2, r6, lsl #8
c0de3426:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de342a:	f840 5021 	str.w	r5, [r0, r1, lsl #2]
        container->nbChildren++;
c0de342e:	1c48      	adds	r0, r1, #1
c0de3430:	f803 0c02 	strb.w	r0, [r3, #-2]
    if (info->description != NULL) {
c0de3434:	f8d8 0018 	ldr.w	r0, [r8, #24]
c0de3438:	2800      	cmp	r0, #0
c0de343a:	f000 8085 	beq.w	c0de3548 <addContentCenter+0x4b8>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de343e:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de3442:	4664      	mov	r4, ip
c0de3444:	08c1      	lsrs	r1, r0, #3
c0de3446:	2004      	movs	r0, #4
c0de3448:	f004 fe65 	bl	c0de8116 <nbgl_objPoolGet>
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de344c:	f99a 10ae 	ldrsb.w	r1, [sl, #174]	@ 0xae
c0de3450:	f89a 20ad 	ldrb.w	r2, [sl, #173]	@ 0xad
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3454:	4607      	mov	r7, r0
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3456:	ea42 2001 	orr.w	r0, r2, r1, lsl #8
c0de345a:	2103      	movs	r1, #3
c0de345c:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
c0de3460:	bfc8      	it	gt
c0de3462:	2100      	movgt	r1, #0
        textArea->text          = PIC(info->description);
c0de3464:	f8d8 0018 	ldr.w	r0, [r8, #24]
        textArea->textColor     = (layoutInt->invertedColors) ? WHITE : BLACK;
c0de3468:	77f9      	strb	r1, [r7, #31]
        textArea->text          = PIC(info->description);
c0de346a:	f005 fd47 	bl	c0de8efc <pic>
c0de346e:	4601      	mov	r1, r0
c0de3470:	4638      	mov	r0, r7
c0de3472:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de3476:	0e0a      	lsrs	r2, r1, #24
c0de3478:	70c2      	strb	r2, [r0, #3]
c0de347a:	0c0a      	lsrs	r2, r1, #16
c0de347c:	7082      	strb	r2, [r0, #2]
c0de347e:	0a08      	lsrs	r0, r1, #8
c0de3480:	f887 0027 	strb.w	r0, [r7, #39]	@ 0x27
c0de3484:	2005      	movs	r0, #5
        textArea->wrapping      = true;
c0de3486:	f897 2024 	ldrb.w	r2, [r7, #36]	@ 0x24
        textArea->textAlignment = CENTER;
c0de348a:	f887 0020 	strb.w	r0, [r7, #32]
c0de348e:	200b      	movs	r0, #11
        textArea->fontId        = SMALL_REGULAR_FONT;
c0de3490:	f887 0022 	strb.w	r0, [r7, #34]	@ 0x22
        textArea->wrapping      = true;
c0de3494:	f042 0001 	orr.w	r0, r2, #1
c0de3498:	f887 0024 	strb.w	r0, [r7, #36]	@ 0x24
c0de349c:	2001      	movs	r0, #1
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de349e:	7178      	strb	r0, [r7, #5]
c0de34a0:	20a0      	movs	r0, #160	@ 0xa0
c0de34a2:	7138      	strb	r0, [r7, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de34a4:	200b      	movs	r0, #11
c0de34a6:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de34aa:	2301      	movs	r3, #1
c0de34ac:	f004 fe4c 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de34b0:	71b8      	strb	r0, [r7, #6]
        if (container->nbChildren > 0) {
c0de34b2:	f89b 1020 	ldrb.w	r1, [fp, #32]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de34b6:	0a02      	lsrs	r2, r0, #8
c0de34b8:	71fa      	strb	r2, [r7, #7]
        if (container->nbChildren > 0) {
c0de34ba:	b321      	cbz	r1, c0de3506 <addContentCenter+0x476>
            textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de34bc:	465a      	mov	r2, fp
c0de34be:	f812 3f22 	ldrb.w	r3, [r2, #34]!
c0de34c2:	7856      	ldrb	r6, [r2, #1]
c0de34c4:	7895      	ldrb	r5, [r2, #2]
c0de34c6:	78d2      	ldrb	r2, [r2, #3]
c0de34c8:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de34cc:	ea45 2202 	orr.w	r2, r5, r2, lsl #8
c0de34d0:	ea43 4202 	orr.w	r2, r3, r2, lsl #16
c0de34d4:	eb02 0281 	add.w	r2, r2, r1, lsl #2
c0de34d8:	f852 3c04 	ldr.w	r3, [r2, #-4]
c0de34dc:	463e      	mov	r6, r7
c0de34de:	f806 3f12 	strb.w	r3, [r6, #18]!
c0de34e2:	0e1d      	lsrs	r5, r3, #24
c0de34e4:	70f5      	strb	r5, [r6, #3]
c0de34e6:	0c1d      	lsrs	r5, r3, #16
c0de34e8:	0a1b      	lsrs	r3, r3, #8
c0de34ea:	70b5      	strb	r5, [r6, #2]
c0de34ec:	7073      	strb	r3, [r6, #1]
            if (container->children[container->nbChildren - 1]->type == TEXT_AREA) {
c0de34ee:	f852 2c04 	ldr.w	r2, [r2, #-4]
c0de34f2:	2308      	movs	r3, #8
c0de34f4:	7ed2      	ldrb	r2, [r2, #27]
            textArea->obj.alignment = BOTTOM_MIDDLE;
c0de34f6:	7133      	strb	r3, [r6, #4]
            if (container->children[container->nbChildren - 1]->type == TEXT_AREA) {
c0de34f8:	2a04      	cmp	r2, #4
c0de34fa:	d107      	bne.n	c0de350c <addContentCenter+0x47c>
c0de34fc:	2200      	movs	r2, #0
                textArea->obj.alignmentMarginY = TITLE_DESC_MARGIN;
c0de34fe:	76ba      	strb	r2, [r7, #26]
c0de3500:	2210      	movs	r2, #16
c0de3502:	767a      	strb	r2, [r7, #25]
c0de3504:	e008      	b.n	c0de3518 <addContentCenter+0x488>
c0de3506:	2202      	movs	r2, #2
            textArea->obj.alignment = TOP_MIDDLE;
c0de3508:	75ba      	strb	r2, [r7, #22]
c0de350a:	e005      	b.n	c0de3518 <addContentCenter+0x488>
                textArea->obj.alignmentMarginY = ICON_TITLE_MARGIN + info->iconHug;
c0de350c:	f8b8 2020 	ldrh.w	r2, [r8, #32]
c0de3510:	3218      	adds	r2, #24
c0de3512:	767a      	strb	r2, [r7, #25]
c0de3514:	0a12      	lsrs	r2, r2, #8
c0de3516:	76ba      	strb	r2, [r7, #26]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de3518:	7e7a      	ldrb	r2, [r7, #25]
c0de351a:	7ebb      	ldrb	r3, [r7, #26]
c0de351c:	4420      	add	r0, r4
c0de351e:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3522:	465b      	mov	r3, fp
c0de3524:	f813 6f22 	ldrb.w	r6, [r3, #34]!
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de3528:	eb00 0c02 	add.w	ip, r0, r2
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de352c:	7858      	ldrb	r0, [r3, #1]
c0de352e:	789a      	ldrb	r2, [r3, #2]
c0de3530:	78dd      	ldrb	r5, [r3, #3]
c0de3532:	ea46 2000 	orr.w	r0, r6, r0, lsl #8
c0de3536:	ea42 2205 	orr.w	r2, r2, r5, lsl #8
c0de353a:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de353e:	f840 7021 	str.w	r7, [r0, r1, lsl #2]
        container->nbChildren++;
c0de3542:	1c48      	adds	r0, r1, #1
c0de3544:	f803 0c02 	strb.w	r0, [r3, #-2]
    if (info->subText != NULL) {
c0de3548:	f8d8 001c 	ldr.w	r0, [r8, #28]
c0de354c:	2800      	cmp	r0, #0
c0de354e:	d07d      	beq.n	c0de364c <addContentCenter+0x5bc>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3550:	f89a 00ad 	ldrb.w	r0, [sl, #173]	@ 0xad
c0de3554:	f8cd c000 	str.w	ip, [sp]
c0de3558:	08c1      	lsrs	r1, r0, #3
c0de355a:	2004      	movs	r0, #4
c0de355c:	f004 fddb 	bl	c0de8116 <nbgl_objPoolGet>
c0de3560:	4604      	mov	r4, r0
        textArea->text          = PIC(info->subText);
c0de3562:	f8d8 001c 	ldr.w	r0, [r8, #28]
c0de3566:	2501      	movs	r5, #1
        textArea->textColor     = LIGHT_TEXT_COLOR;
c0de3568:	77e5      	strb	r5, [r4, #31]
        textArea->text          = PIC(info->subText);
c0de356a:	f005 fcc7 	bl	c0de8efc <pic>
c0de356e:	4601      	mov	r1, r0
c0de3570:	4620      	mov	r0, r4
c0de3572:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de3576:	0e0a      	lsrs	r2, r1, #24
c0de3578:	70c2      	strb	r2, [r0, #3]
c0de357a:	0c0a      	lsrs	r2, r1, #16
c0de357c:	7082      	strb	r2, [r0, #2]
c0de357e:	0a08      	lsrs	r0, r1, #8
c0de3580:	f884 0027 	strb.w	r0, [r4, #39]	@ 0x27
c0de3584:	2005      	movs	r0, #5
        textArea->wrapping      = true;
c0de3586:	f894 2024 	ldrb.w	r2, [r4, #36]	@ 0x24
        textArea->textAlignment = CENTER;
c0de358a:	f884 0020 	strb.w	r0, [r4, #32]
c0de358e:	200b      	movs	r0, #11
        textArea->fontId        = SMALL_REGULAR_FONT;
c0de3590:	f884 0022 	strb.w	r0, [r4, #34]	@ 0x22
        textArea->wrapping      = true;
c0de3594:	f042 0001 	orr.w	r0, r2, #1
c0de3598:	f884 0024 	strb.w	r0, [r4, #36]	@ 0x24
c0de359c:	20a0      	movs	r0, #160	@ 0xa0
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de359e:	7120      	strb	r0, [r4, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de35a0:	200b      	movs	r0, #11
c0de35a2:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de35a6:	2301      	movs	r3, #1
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de35a8:	7165      	strb	r5, [r4, #5]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de35aa:	f004 fdcd 	bl	c0de8148 <nbgl_getTextHeightInWidth>
        textArea->obj.area.height += 2 * 8;
c0de35ae:	f100 0110 	add.w	r1, r0, #16
c0de35b2:	71a1      	strb	r1, [r4, #6]
        if (container->nbChildren > 0) {
c0de35b4:	f89b 0020 	ldrb.w	r0, [fp, #32]
        textArea->obj.area.height += 2 * 8;
c0de35b8:	0a0a      	lsrs	r2, r1, #8
c0de35ba:	71e2      	strb	r2, [r4, #7]
        if (container->nbChildren > 0) {
c0de35bc:	b358      	cbz	r0, c0de3616 <addContentCenter+0x586>
            textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de35be:	465a      	mov	r2, fp
c0de35c0:	f812 3f22 	ldrb.w	r3, [r2, #34]!
c0de35c4:	4627      	mov	r7, r4
c0de35c6:	7856      	ldrb	r6, [r2, #1]
c0de35c8:	7895      	ldrb	r5, [r2, #2]
c0de35ca:	78d2      	ldrb	r2, [r2, #3]
c0de35cc:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de35d0:	ea45 2202 	orr.w	r2, r5, r2, lsl #8
c0de35d4:	ea43 4202 	orr.w	r2, r3, r2, lsl #16
c0de35d8:	eb02 0280 	add.w	r2, r2, r0, lsl #2
c0de35dc:	f852 3c04 	ldr.w	r3, [r2, #-4]
c0de35e0:	f807 3f12 	strb.w	r3, [r7, #18]!
c0de35e4:	0e1e      	lsrs	r6, r3, #24
c0de35e6:	70fe      	strb	r6, [r7, #3]
c0de35e8:	0c1e      	lsrs	r6, r3, #16
c0de35ea:	0a1b      	lsrs	r3, r3, #8
c0de35ec:	707b      	strb	r3, [r7, #1]
c0de35ee:	2310      	movs	r3, #16
c0de35f0:	70be      	strb	r6, [r7, #2]
            textArea->obj.alignmentMarginY = 16;
c0de35f2:	71fb      	strb	r3, [r7, #7]
            if (container->children[container->nbChildren - 1]->type == IMAGE) {
c0de35f4:	f852 2c04 	ldr.w	r2, [r2, #-4]
c0de35f8:	2608      	movs	r6, #8
c0de35fa:	7ed2      	ldrb	r2, [r2, #27]
c0de35fc:	2300      	movs	r3, #0
            textArea->obj.alignment = BOTTOM_MIDDLE;
c0de35fe:	713e      	strb	r6, [r7, #4]
            textArea->obj.alignmentMarginY = 16;
c0de3600:	723b      	strb	r3, [r7, #8]
c0de3602:	9f00      	ldr	r7, [sp, #0]
            if (container->children[container->nbChildren - 1]->type == IMAGE) {
c0de3604:	2a02      	cmp	r2, #2
c0de3606:	d109      	bne.n	c0de361c <addContentCenter+0x58c>
                textArea->obj.alignmentMarginY += info->iconHug;
c0de3608:	f8b8 2020 	ldrh.w	r2, [r8, #32]
c0de360c:	3210      	adds	r2, #16
c0de360e:	7662      	strb	r2, [r4, #25]
c0de3610:	0a12      	lsrs	r2, r2, #8
c0de3612:	76a2      	strb	r2, [r4, #26]
c0de3614:	e002      	b.n	c0de361c <addContentCenter+0x58c>
c0de3616:	9f00      	ldr	r7, [sp, #0]
c0de3618:	2202      	movs	r2, #2
            textArea->obj.alignment = TOP_MIDDLE;
c0de361a:	75a2      	strb	r2, [r4, #22]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de361c:	7e62      	ldrb	r2, [r4, #25]
c0de361e:	7ea3      	ldrb	r3, [r4, #26]
c0de3620:	4439      	add	r1, r7
c0de3622:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3626:	465b      	mov	r3, fp
c0de3628:	f813 7f22 	ldrb.w	r7, [r3, #34]!
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de362c:	eb01 0c02 	add.w	ip, r1, r2
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3630:	7859      	ldrb	r1, [r3, #1]
c0de3632:	789a      	ldrb	r2, [r3, #2]
c0de3634:	78de      	ldrb	r6, [r3, #3]
c0de3636:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de363a:	ea42 2206 	orr.w	r2, r2, r6, lsl #8
c0de363e:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de3642:	f841 4020 	str.w	r4, [r1, r0, lsl #2]
        container->nbChildren++;
c0de3646:	3001      	adds	r0, #1
c0de3648:	f803 0c02 	strb.w	r0, [r3, #-2]
c0de364c:	2000      	movs	r0, #0
    container->layout          = VERTICAL;
c0de364e:	f88b 001f 	strb.w	r0, [fp, #31]
c0de3652:	2005      	movs	r0, #5
    container->obj.alignment   = CENTER;
c0de3654:	f88b 0016 	strb.w	r0, [fp, #22]
c0de3658:	20a0      	movs	r0, #160	@ 0xa0
    container->obj.area.width  = AVAILABLE_WIDTH;
c0de365a:	f88b 0004 	strb.w	r0, [fp, #4]
    container->obj.area.height = fullHeight;
c0de365e:	f88b c006 	strb.w	ip, [fp, #6]
    if (info->padding) {
c0de3662:	f898 1022 	ldrb.w	r1, [r8, #34]	@ 0x22
c0de3666:	2001      	movs	r0, #1
    container->obj.area.width  = AVAILABLE_WIDTH;
c0de3668:	f88b 0005 	strb.w	r0, [fp, #5]
    container->obj.area.height = fullHeight;
c0de366c:	ea4f 201c 	mov.w	r0, ip, lsr #8
c0de3670:	f88b 0007 	strb.w	r0, [fp, #7]
    if (info->padding) {
c0de3674:	b131      	cbz	r1, c0de3684 <addContentCenter+0x5f4>
        container->obj.area.height += 40;
c0de3676:	f10c 0028 	add.w	r0, ip, #40	@ 0x28
c0de367a:	f88b 0006 	strb.w	r0, [fp, #6]
c0de367e:	0a00      	lsrs	r0, r0, #8
c0de3680:	f88b 0007 	strb.w	r0, [fp, #7]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de3684:	f8da 00a0 	ldr.w	r0, [sl, #160]	@ 0xa0
    layout->container->children[layout->container->nbChildren] = obj;
c0de3688:	f810 1f22 	ldrb.w	r1, [r0, #34]!
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de368c:	f810 2c02 	ldrb.w	r2, [r0, #-2]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3690:	7843      	ldrb	r3, [r0, #1]
c0de3692:	7887      	ldrb	r7, [r0, #2]
c0de3694:	78c0      	ldrb	r0, [r0, #3]
c0de3696:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de369a:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de369e:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de36a2:	f840 b022 	str.w	fp, [r0, r2, lsl #2]
    layout->container->nbChildren++;
c0de36a6:	f8da 10a0 	ldr.w	r1, [sl, #160]	@ 0xa0
c0de36aa:	f891 0020 	ldrb.w	r0, [r1, #32]
c0de36ae:	1c42      	adds	r2, r0, #1
    return container;
c0de36b0:	4658      	mov	r0, fp
    layout->container->nbChildren++;
c0de36b2:	f881 2020 	strb.w	r2, [r1, #32]
    return container;
c0de36b6:	b004      	add	sp, #16
c0de36b8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de36bc <nbgl_layoutAddContentCenter>:
    if (layout == NULL) {
c0de36bc:	2800      	cmp	r0, #0
c0de36be:	bf04      	itt	eq
c0de36c0:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
}
c0de36c4:	4770      	bxeq	lr
c0de36c6:	b580      	push	{r7, lr}
    container = addContentCenter(layoutInt, info);
c0de36c8:	f7ff fce2 	bl	c0de3090 <addContentCenter>
    return container->obj.area.height;
c0de36cc:	7981      	ldrb	r1, [r0, #6]
c0de36ce:	79c0      	ldrb	r0, [r0, #7]
c0de36d0:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de36d4:	bd80      	pop	{r7, pc}

c0de36d6 <nbgl_layoutAddQRCode>:
    if (layout == NULL) {
c0de36d6:	2800      	cmp	r0, #0
c0de36d8:	bf04      	itt	eq
c0de36da:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
}
c0de36de:	4770      	bxeq	lr
c0de36e0:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de36e4:	b082      	sub	sp, #8
c0de36e6:	4680      	mov	r8, r0
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de36e8:	f890 00ad 	ldrb.w	r0, [r0, #173]	@ 0xad
c0de36ec:	468a      	mov	sl, r1
c0de36ee:	08c1      	lsrs	r1, r0, #3
c0de36f0:	2001      	movs	r0, #1
c0de36f2:	f004 fd10 	bl	c0de8116 <nbgl_objPoolGet>
    container->children   = nbgl_containerPoolGet(3, layoutInt->layer);
c0de36f6:	f898 10ad 	ldrb.w	r1, [r8, #173]	@ 0xad
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de36fa:	4605      	mov	r5, r0
    container->children   = nbgl_containerPoolGet(3, layoutInt->layer);
c0de36fc:	08c9      	lsrs	r1, r1, #3
c0de36fe:	2003      	movs	r0, #3
c0de3700:	f004 fd0e 	bl	c0de8120 <nbgl_containerPoolGet>
c0de3704:	462c      	mov	r4, r5
c0de3706:	f804 0f22 	strb.w	r0, [r4, #34]!
c0de370a:	0e01      	lsrs	r1, r0, #24
c0de370c:	70e1      	strb	r1, [r4, #3]
c0de370e:	0c01      	lsrs	r1, r0, #16
c0de3710:	0a00      	lsrs	r0, r0, #8
c0de3712:	2600      	movs	r6, #0
c0de3714:	70a1      	strb	r1, [r4, #2]
c0de3716:	f885 0023 	strb.w	r0, [r5, #35]	@ 0x23
    container->nbChildren = 0;
c0de371a:	f885 6020 	strb.w	r6, [r5, #32]
    qrcode = (nbgl_qrcode_t *) nbgl_objPoolGet(QR_CODE, layoutInt->layer);
c0de371e:	f898 00ad 	ldrb.w	r0, [r8, #173]	@ 0xad
c0de3722:	08c1      	lsrs	r1, r0, #3
c0de3724:	200a      	movs	r0, #10
c0de3726:	f004 fcf6 	bl	c0de8116 <nbgl_objPoolGet>
    if (strlen(PIC(info->url)) > 62) {
c0de372a:	f8da 1000 	ldr.w	r1, [sl]
    qrcode = (nbgl_qrcode_t *) nbgl_objPoolGet(QR_CODE, layoutInt->layer);
c0de372e:	4683      	mov	fp, r0
    if (strlen(PIC(info->url)) > 62) {
c0de3730:	4608      	mov	r0, r1
c0de3732:	f005 fbe3 	bl	c0de8efc <pic>
c0de3736:	f005 fe27 	bl	c0de9388 <strlen>
c0de373a:	283e      	cmp	r0, #62	@ 0x3e
c0de373c:	f04f 0000 	mov.w	r0, #0
c0de3740:	bf88      	it	hi
c0de3742:	2001      	movhi	r0, #1
c0de3744:	f88b 0020 	strb.w	r0, [fp, #32]
c0de3748:	f44f 7084 	mov.w	r0, #264	@ 0x108
    qrcode->obj.area.height = qrcode->obj.area.width;
c0de374c:	465f      	mov	r7, fp
    qrcode->foregroundColor = BLACK;
c0de374e:	f88b 601f 	strb.w	r6, [fp, #31]
        = (qrcode->version == QRCODE_V4) ? (QR_V4_NB_PIX_SIZE * 8) : (QR_V10_NB_PIX_SIZE * 4);
c0de3752:	bf88      	it	hi
c0de3754:	20e4      	movhi	r0, #228	@ 0xe4
c0de3756:	f88b 0004 	strb.w	r0, [fp, #4]
    qrcode->obj.area.height = qrcode->obj.area.width;
c0de375a:	f807 0f06 	strb.w	r0, [r7, #6]!
        = (qrcode->version == QRCODE_V4) ? (QR_V4_NB_PIX_SIZE * 8) : (QR_V10_NB_PIX_SIZE * 4);
c0de375e:	0a01      	lsrs	r1, r0, #8
    qrcode->text            = PIC(info->url);
c0de3760:	f8da 0000 	ldr.w	r0, [sl]
        = (qrcode->version == QRCODE_V4) ? (QR_V4_NB_PIX_SIZE * 8) : (QR_V10_NB_PIX_SIZE * 4);
c0de3764:	f88b 1005 	strb.w	r1, [fp, #5]
    qrcode->obj.area.height = qrcode->obj.area.width;
c0de3768:	7079      	strb	r1, [r7, #1]
    qrcode->text            = PIC(info->url);
c0de376a:	f005 fbc7 	bl	c0de8efc <pic>
c0de376e:	4659      	mov	r1, fp
c0de3770:	f801 0f21 	strb.w	r0, [r1, #33]!
c0de3774:	0e02      	lsrs	r2, r0, #24
c0de3776:	70ca      	strb	r2, [r1, #3]
c0de3778:	0c02      	lsrs	r2, r0, #16
c0de377a:	708a      	strb	r2, [r1, #2]
c0de377c:	0a00      	lsrs	r0, r0, #8
    fullHeight += qrcode->obj.area.height;
c0de377e:	7839      	ldrb	r1, [r7, #0]
c0de3780:	787a      	ldrb	r2, [r7, #1]
    qrcode->text            = PIC(info->url);
c0de3782:	f88b 0022 	strb.w	r0, [fp, #34]	@ 0x22
c0de3786:	2002      	movs	r0, #2
    qrcode->obj.area.bpp    = NBGL_BPP_1;
c0de3788:	f88b 6009 	strb.w	r6, [fp, #9]
    qrcode->obj.alignment   = TOP_MIDDLE;
c0de378c:	f88b 0016 	strb.w	r0, [fp, #22]
    fullHeight += qrcode->obj.area.height;
c0de3790:	ea41 2602 	orr.w	r6, r1, r2, lsl #8
    container->children[container->nbChildren] = (nbgl_obj_t *) qrcode;
c0de3794:	7820      	ldrb	r0, [r4, #0]
c0de3796:	78a1      	ldrb	r1, [r4, #2]
c0de3798:	78e2      	ldrb	r2, [r4, #3]
c0de379a:	f895 3023 	ldrb.w	r3, [r5, #35]	@ 0x23
c0de379e:	f895 7020 	ldrb.w	r7, [r5, #32]
c0de37a2:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de37a6:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de37aa:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de37ae:	f840 b027 	str.w	fp, [r0, r7, lsl #2]
    if (info->text1 != NULL) {
c0de37b2:	f8da 0004 	ldr.w	r0, [sl, #4]
    container->nbChildren++;
c0de37b6:	1c79      	adds	r1, r7, #1
    if (info->text1 != NULL) {
c0de37b8:	2800      	cmp	r0, #0
    container->nbChildren++;
c0de37ba:	f885 1020 	strb.w	r1, [r5, #32]
    if (info->text1 != NULL) {
c0de37be:	d05f      	beq.n	c0de3880 <nbgl_layoutAddQRCode+0x1aa>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de37c0:	f898 00ad 	ldrb.w	r0, [r8, #173]	@ 0xad
c0de37c4:	9601      	str	r6, [sp, #4]
c0de37c6:	08c1      	lsrs	r1, r0, #3
c0de37c8:	2004      	movs	r0, #4
c0de37ca:	f004 fca4 	bl	c0de8116 <nbgl_objPoolGet>
c0de37ce:	4604      	mov	r4, r0
        textArea->text          = PIC(info->text1);
c0de37d0:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de37d4:	2100      	movs	r1, #0
        textArea->textColor     = BLACK;
c0de37d6:	77e1      	strb	r1, [r4, #31]
        textArea->text          = PIC(info->text1);
c0de37d8:	f005 fb90 	bl	c0de8efc <pic>
c0de37dc:	4601      	mov	r1, r0
c0de37de:	4620      	mov	r0, r4
c0de37e0:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de37e4:	0e0a      	lsrs	r2, r1, #24
c0de37e6:	70c2      	strb	r2, [r0, #3]
c0de37e8:	0c0a      	lsrs	r2, r1, #16
c0de37ea:	7082      	strb	r2, [r0, #2]
c0de37ec:	0a08      	lsrs	r0, r1, #8
c0de37ee:	f884 0027 	strb.w	r0, [r4, #39]	@ 0x27
c0de37f2:	2005      	movs	r0, #5
        textArea->fontId   = (info->largeText1 == true) ? LARGE_MEDIUM_FONT : SMALL_REGULAR_FONT;
c0de37f4:	f89a 200f 	ldrb.w	r2, [sl, #15]
        textArea->textAlignment = CENTER;
c0de37f8:	f884 0020 	strb.w	r0, [r4, #32]
c0de37fc:	200d      	movs	r0, #13
        textArea->fontId   = (info->largeText1 == true) ? LARGE_MEDIUM_FONT : SMALL_REGULAR_FONT;
c0de37fe:	2a00      	cmp	r2, #0
c0de3800:	bf08      	it	eq
c0de3802:	200b      	moveq	r0, #11
        textArea->wrapping = true;
c0de3804:	f894 2024 	ldrb.w	r2, [r4, #36]	@ 0x24
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3808:	2301      	movs	r3, #1
        textArea->wrapping = true;
c0de380a:	f042 0201 	orr.w	r2, r2, #1
c0de380e:	f884 2024 	strb.w	r2, [r4, #36]	@ 0x24
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de3812:	2201      	movs	r2, #1
c0de3814:	7162      	strb	r2, [r4, #5]
c0de3816:	22a0      	movs	r2, #160	@ 0xa0
c0de3818:	7122      	strb	r2, [r4, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de381a:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
        textArea->fontId   = (info->largeText1 == true) ? LARGE_MEDIUM_FONT : SMALL_REGULAR_FONT;
c0de381e:	f884 0022 	strb.w	r0, [r4, #34]	@ 0x22
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3822:	f004 fc91 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de3826:	0a01      	lsrs	r1, r0, #8
c0de3828:	71a0      	strb	r0, [r4, #6]
c0de382a:	71e1      	strb	r1, [r4, #7]
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de382c:	4629      	mov	r1, r5
c0de382e:	f811 cf22 	ldrb.w	ip, [r1, #34]!
c0de3832:	2208      	movs	r2, #8
c0de3834:	784f      	ldrb	r7, [r1, #1]
c0de3836:	788e      	ldrb	r6, [r1, #2]
c0de3838:	78cb      	ldrb	r3, [r1, #3]
        textArea->obj.alignment = BOTTOM_MIDDLE;
c0de383a:	75a2      	strb	r2, [r4, #22]
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de383c:	f811 2c02 	ldrb.w	r2, [r1, #-2]
c0de3840:	ea4c 2707 	orr.w	r7, ip, r7, lsl #8
c0de3844:	ea46 2303 	orr.w	r3, r6, r3, lsl #8
c0de3848:	ea47 4c03 	orr.w	ip, r7, r3, lsl #16
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de384c:	eb0c 0782 	add.w	r7, ip, r2, lsl #2
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de3850:	f857 7c04 	ldr.w	r7, [r7, #-4]
c0de3854:	4626      	mov	r6, r4
c0de3856:	f806 7f12 	strb.w	r7, [r6, #18]!
c0de385a:	0e3b      	lsrs	r3, r7, #24
c0de385c:	70f3      	strb	r3, [r6, #3]
c0de385e:	0c3b      	lsrs	r3, r7, #16
c0de3860:	70b3      	strb	r3, [r6, #2]
c0de3862:	0a3b      	lsrs	r3, r7, #8
c0de3864:	74e3      	strb	r3, [r4, #19]
        textArea->obj.alignmentMarginY = QR_PRE_TEXT_MARGIN;
c0de3866:	2300      	movs	r3, #0
c0de3868:	76a3      	strb	r3, [r4, #26]
c0de386a:	2318      	movs	r3, #24
c0de386c:	7663      	strb	r3, [r4, #25]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de386e:	9b01      	ldr	r3, [sp, #4]
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3870:	f84c 4022 	str.w	r4, [ip, r2, lsl #2]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de3874:	4418      	add	r0, r3
c0de3876:	f100 0618 	add.w	r6, r0, #24
        container->nbChildren++;
c0de387a:	1c50      	adds	r0, r2, #1
c0de387c:	f801 0c02 	strb.w	r0, [r1, #-2]
    if (info->text2 != NULL) {
c0de3880:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de3884:	2800      	cmp	r0, #0
c0de3886:	d061      	beq.n	c0de394c <nbgl_layoutAddQRCode+0x276>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3888:	f898 00ad 	ldrb.w	r0, [r8, #173]	@ 0xad
c0de388c:	9601      	str	r6, [sp, #4]
c0de388e:	08c1      	lsrs	r1, r0, #3
c0de3890:	2004      	movs	r0, #4
c0de3892:	f004 fc40 	bl	c0de8116 <nbgl_objPoolGet>
c0de3896:	4604      	mov	r4, r0
        textArea->text          = PIC(info->text2);
c0de3898:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de389c:	2601      	movs	r6, #1
        textArea->textColor     = LIGHT_TEXT_COLOR;
c0de389e:	77e6      	strb	r6, [r4, #31]
        textArea->text          = PIC(info->text2);
c0de38a0:	f005 fb2c 	bl	c0de8efc <pic>
c0de38a4:	4601      	mov	r1, r0
c0de38a6:	4620      	mov	r0, r4
c0de38a8:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de38ac:	0e0a      	lsrs	r2, r1, #24
c0de38ae:	70c2      	strb	r2, [r0, #3]
c0de38b0:	0c0a      	lsrs	r2, r1, #16
c0de38b2:	7082      	strb	r2, [r0, #2]
c0de38b4:	0a08      	lsrs	r0, r1, #8
c0de38b6:	f884 0027 	strb.w	r0, [r4, #39]	@ 0x27
c0de38ba:	2005      	movs	r0, #5
        textArea->wrapping      = true;
c0de38bc:	f894 2024 	ldrb.w	r2, [r4, #36]	@ 0x24
        textArea->textAlignment = CENTER;
c0de38c0:	f884 0020 	strb.w	r0, [r4, #32]
c0de38c4:	200b      	movs	r0, #11
        textArea->fontId        = SMALL_REGULAR_FONT;
c0de38c6:	f884 0022 	strb.w	r0, [r4, #34]	@ 0x22
        textArea->wrapping      = true;
c0de38ca:	f042 0001 	orr.w	r0, r2, #1
c0de38ce:	f884 0024 	strb.w	r0, [r4, #36]	@ 0x24
c0de38d2:	20a0      	movs	r0, #160	@ 0xa0
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de38d4:	7120      	strb	r0, [r4, #4]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de38d6:	200b      	movs	r0, #11
c0de38d8:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de38dc:	2301      	movs	r3, #1
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de38de:	7166      	strb	r6, [r4, #5]
        textArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de38e0:	f004 fc32 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de38e4:	0a01      	lsrs	r1, r0, #8
c0de38e6:	71a0      	strb	r0, [r4, #6]
c0de38e8:	71e1      	strb	r1, [r4, #7]
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de38ea:	4629      	mov	r1, r5
c0de38ec:	f811 cf22 	ldrb.w	ip, [r1, #34]!
c0de38f0:	2208      	movs	r2, #8
c0de38f2:	784f      	ldrb	r7, [r1, #1]
c0de38f4:	788e      	ldrb	r6, [r1, #2]
c0de38f6:	78cb      	ldrb	r3, [r1, #3]
        textArea->obj.alignment = BOTTOM_MIDDLE;
c0de38f8:	75a2      	strb	r2, [r4, #22]
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de38fa:	f811 2c02 	ldrb.w	r2, [r1, #-2]
c0de38fe:	ea4c 2707 	orr.w	r7, ip, r7, lsl #8
c0de3902:	ea46 2303 	orr.w	r3, r6, r3, lsl #8
c0de3906:	ea47 4c03 	orr.w	ip, r7, r3, lsl #16
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de390a:	eb0c 0782 	add.w	r7, ip, r2, lsl #2
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de390e:	f857 7c04 	ldr.w	r7, [r7, #-4]
c0de3912:	4626      	mov	r6, r4
c0de3914:	f806 7f12 	strb.w	r7, [r6, #18]!
c0de3918:	0e3b      	lsrs	r3, r7, #24
c0de391a:	70f3      	strb	r3, [r6, #3]
c0de391c:	0c3b      	lsrs	r3, r7, #16
c0de391e:	70b3      	strb	r3, [r6, #2]
c0de3920:	0a3b      	lsrs	r3, r7, #8
c0de3922:	74e3      	strb	r3, [r4, #19]
        if (info->text1 != NULL) {
c0de3924:	f8da 3004 	ldr.w	r3, [sl, #4]
c0de3928:	271c      	movs	r7, #28
c0de392a:	2b00      	cmp	r3, #0
c0de392c:	f04f 0300 	mov.w	r3, #0
c0de3930:	bf08      	it	eq
c0de3932:	2720      	moveq	r7, #32
c0de3934:	76a3      	strb	r3, [r4, #26]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY + 8;
c0de3936:	9b01      	ldr	r3, [sp, #4]
c0de3938:	7667      	strb	r7, [r4, #25]
c0de393a:	4418      	add	r0, r3
c0de393c:	4438      	add	r0, r7
c0de393e:	f100 0608 	add.w	r6, r0, #8
        container->nbChildren++;
c0de3942:	1c50      	adds	r0, r2, #1
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de3944:	f84c 4022 	str.w	r4, [ip, r2, lsl #2]
        container->nbChildren++;
c0de3948:	f801 0c02 	strb.w	r0, [r1, #-2]
    if ((fullHeight >= (layoutInt->container->obj.area.height - 16))
c0de394c:	f8d8 00a0 	ldr.w	r0, [r8, #160]	@ 0xa0
c0de3950:	b2b3      	uxth	r3, r6
c0de3952:	7981      	ldrb	r1, [r0, #6]
c0de3954:	79c2      	ldrb	r2, [r0, #7]
c0de3956:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de395a:	3910      	subs	r1, #16
        && (qrcode->version == QRCODE_V4)) {
c0de395c:	4299      	cmp	r1, r3
c0de395e:	dc10      	bgt.n	c0de3982 <nbgl_layoutAddQRCode+0x2ac>
c0de3960:	f89b 1020 	ldrb.w	r1, [fp, #32]
    if ((fullHeight >= (layoutInt->container->obj.area.height - 16))
c0de3964:	b969      	cbnz	r1, c0de3982 <nbgl_layoutAddQRCode+0x2ac>
c0de3966:	2102      	movs	r1, #2
        qrcode->version = QRCODE_V4_SMALL;
c0de3968:	f88b 1020 	strb.w	r1, [fp, #32]
c0de396c:	2100      	movs	r1, #0
c0de396e:	2284      	movs	r2, #132	@ 0x84
        fullHeight -= QR_V4_NB_PIX_SIZE * 4;
c0de3970:	3e84      	subs	r6, #132	@ 0x84
        qrcode->obj.area.width  = QR_V4_NB_PIX_SIZE * 4;
c0de3972:	f88b 1005 	strb.w	r1, [fp, #5]
c0de3976:	f88b 2004 	strb.w	r2, [fp, #4]
        qrcode->obj.area.height = qrcode->obj.area.width;
c0de397a:	f88b 1007 	strb.w	r1, [fp, #7]
c0de397e:	f88b 2006 	strb.w	r2, [fp, #6]
    container->obj.area.height = fullHeight;
c0de3982:	71ae      	strb	r6, [r5, #6]
    if (info->centered) {
c0de3984:	f89a 200e 	ldrb.w	r2, [sl, #14]
    container->obj.area.height = fullHeight;
c0de3988:	0a31      	lsrs	r1, r6, #8
c0de398a:	71e9      	strb	r1, [r5, #7]
c0de398c:	f04f 0100 	mov.w	r1, #0
    container->layout          = VERTICAL;
c0de3990:	77e9      	strb	r1, [r5, #31]
    if (info->centered) {
c0de3992:	b112      	cbz	r2, c0de399a <nbgl_layoutAddQRCode+0x2c4>
c0de3994:	2005      	movs	r0, #5
        container->obj.alignment = CENTER;
c0de3996:	75a8      	strb	r0, [r5, #22]
c0de3998:	e01b      	b.n	c0de39d2 <nbgl_layoutAddQRCode+0x2fc>
            = layoutInt->container->children[layoutInt->container->nbChildren - 1];
c0de399a:	f810 1f22 	ldrb.w	r1, [r0, #34]!
c0de399e:	f810 2c02 	ldrb.w	r2, [r0, #-2]
c0de39a2:	7843      	ldrb	r3, [r0, #1]
c0de39a4:	7887      	ldrb	r7, [r0, #2]
c0de39a6:	78c0      	ldrb	r0, [r0, #3]
c0de39a8:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de39ac:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de39b0:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de39b4:	eb00 0082 	add.w	r0, r0, r2, lsl #2
c0de39b8:	f850 0c04 	ldr.w	r0, [r0, #-4]
c0de39bc:	4629      	mov	r1, r5
c0de39be:	f801 0f12 	strb.w	r0, [r1, #18]!
c0de39c2:	2208      	movs	r2, #8
        container->obj.alignment = BOTTOM_MIDDLE;
c0de39c4:	710a      	strb	r2, [r1, #4]
            = layoutInt->container->children[layoutInt->container->nbChildren - 1];
c0de39c6:	0e02      	lsrs	r2, r0, #24
c0de39c8:	70ca      	strb	r2, [r1, #3]
c0de39ca:	0c02      	lsrs	r2, r0, #16
c0de39cc:	0a00      	lsrs	r0, r0, #8
c0de39ce:	708a      	strb	r2, [r1, #2]
c0de39d0:	7048      	strb	r0, [r1, #1]
    container->obj.alignmentMarginY = info->offsetY;
c0de39d2:	f8ba 000c 	ldrh.w	r0, [sl, #12]
c0de39d6:	21a0      	movs	r1, #160	@ 0xa0
c0de39d8:	7668      	strb	r0, [r5, #25]
    container->obj.area.width = AVAILABLE_WIDTH;
c0de39da:	7129      	strb	r1, [r5, #4]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de39dc:	f8d8 10a0 	ldr.w	r1, [r8, #160]	@ 0xa0
    container->obj.alignmentMarginY = info->offsetY;
c0de39e0:	0a00      	lsrs	r0, r0, #8
    layout->container->children[layout->container->nbChildren] = obj;
c0de39e2:	f811 2f22 	ldrb.w	r2, [r1, #34]!
    container->obj.alignmentMarginY = info->offsetY;
c0de39e6:	76a8      	strb	r0, [r5, #26]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de39e8:	f811 0c02 	ldrb.w	r0, [r1, #-2]
    layout->container->children[layout->container->nbChildren] = obj;
c0de39ec:	784b      	ldrb	r3, [r1, #1]
c0de39ee:	788f      	ldrb	r7, [r1, #2]
c0de39f0:	78c9      	ldrb	r1, [r1, #3]
c0de39f2:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de39f6:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de39fa:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de39fe:	f841 5020 	str.w	r5, [r1, r0, lsl #2]
    layout->container->nbChildren++;
c0de3a02:	f8d8 00a0 	ldr.w	r0, [r8, #160]	@ 0xa0
c0de3a06:	2101      	movs	r1, #1
c0de3a08:	f890 2020 	ldrb.w	r2, [r0, #32]
    container->obj.area.width = AVAILABLE_WIDTH;
c0de3a0c:	7169      	strb	r1, [r5, #5]
    layout->container->nbChildren++;
c0de3a0e:	1c51      	adds	r1, r2, #1
c0de3a10:	f880 1020 	strb.w	r1, [r0, #32]
    return fullHeight;
c0de3a14:	b2b0      	uxth	r0, r6
c0de3a16:	b002      	add	sp, #8
c0de3a18:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de3a1c <nbgl_layoutAddChoiceButtons>:
{
c0de3a1c:	b580      	push	{r7, lr}
c0de3a1e:	b086      	sub	sp, #24
c0de3a20:	2206      	movs	r2, #6
    footerDesc.type                     = FOOTER_CHOICE_BUTTONS;
c0de3a22:	f8ad 2000 	strh.w	r2, [sp]
    footerDesc.choiceButtons.topText    = info->topText;
c0de3a26:	e9d1 c200 	ldrd	ip, r2, [r1]
    footerDesc.choiceButtons.topIcon    = info->topIcon;
c0de3a2a:	688b      	ldr	r3, [r1, #8]
    footerDesc.choiceButtons.bottomText = info->bottomText;
c0de3a2c:	9202      	str	r2, [sp, #8]
    footerDesc.choiceButtons.token      = info->token;
c0de3a2e:	898a      	ldrh	r2, [r1, #12]
    footerDesc.choiceButtons.tuneId     = info->tuneId;
c0de3a30:	7b89      	ldrb	r1, [r1, #14]
    footerDesc.choiceButtons.token      = info->token;
c0de3a32:	f8ad 2010 	strh.w	r2, [sp, #16]
    footerDesc.choiceButtons.tuneId     = info->tuneId;
c0de3a36:	f88d 1012 	strb.w	r1, [sp, #18]
c0de3a3a:	4669      	mov	r1, sp
    footerDesc.choiceButtons.topText    = info->topText;
c0de3a3c:	f8cd c004 	str.w	ip, [sp, #4]
    footerDesc.choiceButtons.topIcon    = info->topIcon;
c0de3a40:	9303      	str	r3, [sp, #12]
    return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de3a42:	f7fd ff7f 	bl	c0de1944 <nbgl_layoutAddExtendedFooter>
c0de3a46:	b006      	add	sp, #24
c0de3a48:	bd80      	pop	{r7, pc}

c0de3a4a <nbgl_layoutAddHorizontalButtons>:
{
c0de3a4a:	b580      	push	{r7, lr}
c0de3a4c:	b086      	sub	sp, #24
c0de3a4e:	2202      	movs	r2, #2
    nbgl_layoutUpFooter_t upFooterDesc = {.type = UP_FOOTER_HORIZONTAL_BUTTONS,
c0de3a50:	f88d 2004 	strb.w	r2, [sp, #4]
                                          .horizontalButtons.leftIcon   = info->leftIcon,
c0de3a54:	e9d1 2300 	ldrd	r2, r3, [r1]
c0de3a58:	e9cd 2302 	strd	r2, r3, [sp, #8]
                                          .horizontalButtons.leftToken  = info->leftToken,
c0de3a5c:	890a      	ldrh	r2, [r1, #8]
                                          .horizontalButtons.tuneId     = info->tuneId};
c0de3a5e:	7a89      	ldrb	r1, [r1, #10]
                                          .horizontalButtons.leftIcon   = info->leftIcon,
c0de3a60:	f8ad 2010 	strh.w	r2, [sp, #16]
c0de3a64:	f88d 1012 	strb.w	r1, [sp, #18]
c0de3a68:	a901      	add	r1, sp, #4
    return nbgl_layoutAddUpFooter(layout, &upFooterDesc);
c0de3a6a:	f7fd fa69 	bl	c0de0f40 <nbgl_layoutAddUpFooter>
c0de3a6e:	b006      	add	sp, #24
c0de3a70:	bd80      	pop	{r7, pc}
	...

c0de3a74 <nbgl_layoutAddTagValueList>:
{
c0de3a74:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de3a78:	b086      	sub	sp, #24
    if (layout == NULL) {
c0de3a7a:	2800      	cmp	r0, #0
c0de3a7c:	9005      	str	r0, [sp, #20]
c0de3a7e:	f000 81f7 	beq.w	c0de3e70 <nbgl_layoutAddTagValueList+0x3fc>
    for (i = 0; i < list->nbPairs; i++) {
c0de3a82:	7a08      	ldrb	r0, [r1, #8]
c0de3a84:	460c      	mov	r4, r1
c0de3a86:	2800      	cmp	r0, #0
c0de3a88:	f04f 0000 	mov.w	r0, #0
c0de3a8c:	f000 81f6 	beq.w	c0de3e7c <nbgl_layoutAddTagValueList+0x408>
c0de3a90:	2500      	movs	r5, #0
c0de3a92:	2000      	movs	r0, #0
c0de3a94:	e9cd 0403 	strd	r0, r4, [sp, #12]
c0de3a98:	e02a      	b.n	c0de3af0 <nbgl_layoutAddTagValueList+0x7c>
c0de3a9a:	bf00      	nop
c0de3a9c:	2018      	movs	r0, #24
c0de3a9e:	9e05      	ldr	r6, [sp, #20]
c0de3aa0:	f88b 0019 	strb.w	r0, [fp, #25]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de3aa4:	f8d6 00a0 	ldr.w	r0, [r6, #160]	@ 0xa0
c0de3aa8:	9c04      	ldr	r4, [sp, #16]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3aaa:	f810 1f22 	ldrb.w	r1, [r0, #34]!
c0de3aae:	2200      	movs	r2, #0
c0de3ab0:	7843      	ldrb	r3, [r0, #1]
c0de3ab2:	7887      	ldrb	r7, [r0, #2]
c0de3ab4:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de3ab8:	78c3      	ldrb	r3, [r0, #3]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de3aba:	f810 0c02 	ldrb.w	r0, [r0, #-2]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3abe:	ea47 2303 	orr.w	r3, r7, r3, lsl #8
c0de3ac2:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
c0de3ac6:	f841 b020 	str.w	fp, [r1, r0, lsl #2]
    layout->container->nbChildren++;
c0de3aca:	f8d6 00a0 	ldr.w	r0, [r6, #160]	@ 0xa0
    for (i = 0; i < list->nbPairs; i++) {
c0de3ace:	3510      	adds	r5, #16
    layout->container->nbChildren++;
c0de3ad0:	f890 1020 	ldrb.w	r1, [r0, #32]
c0de3ad4:	f88b 201a 	strb.w	r2, [fp, #26]
c0de3ad8:	3101      	adds	r1, #1
c0de3ada:	f880 1020 	strb.w	r1, [r0, #32]
c0de3ade:	9903      	ldr	r1, [sp, #12]
    for (i = 0; i < list->nbPairs; i++) {
c0de3ae0:	7a20      	ldrb	r0, [r4, #8]
c0de3ae2:	3101      	adds	r1, #1
c0de3ae4:	4281      	cmp	r1, r0
        container->obj.alignment = NO_ALIGNMENT;
c0de3ae6:	f88b 2016 	strb.w	r2, [fp, #22]
c0de3aea:	9103      	str	r1, [sp, #12]
    for (i = 0; i < list->nbPairs; i++) {
c0de3aec:	f080 81c5 	bcs.w	c0de3e7a <nbgl_layoutAddTagValueList+0x406>
        if (list->pairs != NULL) {
c0de3af0:	6820      	ldr	r0, [r4, #0]
c0de3af2:	9502      	str	r5, [sp, #8]
c0de3af4:	b110      	cbz	r0, c0de3afc <nbgl_layoutAddTagValueList+0x88>
        }
c0de3af6:	eb00 0805 	add.w	r8, r0, r5
c0de3afa:	e006      	b.n	c0de3b0a <nbgl_layoutAddTagValueList+0x96>
            pair = list->callback(list->startIndex + i);
c0de3afc:	7a60      	ldrb	r0, [r4, #9]
c0de3afe:	9a03      	ldr	r2, [sp, #12]
c0de3b00:	6861      	ldr	r1, [r4, #4]
c0de3b02:	4410      	add	r0, r2
c0de3b04:	b2c0      	uxtb	r0, r0
c0de3b06:	4788      	blx	r1
c0de3b08:	4680      	mov	r8, r0
c0de3b0a:	9c05      	ldr	r4, [sp, #20]
        container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de3b0c:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de3b10:	08c1      	lsrs	r1, r0, #3
c0de3b12:	2001      	movs	r0, #1
c0de3b14:	f004 faff 	bl	c0de8116 <nbgl_objPoolGet>
c0de3b18:	4683      	mov	fp, r0
            = nbgl_containerPoolGet((pair->valueIcon != NULL) ? 3 : 2, layoutInt->layer);
c0de3b1a:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de3b1e:	f8d8 2008 	ldr.w	r2, [r8, #8]
c0de3b22:	08c1      	lsrs	r1, r0, #3
c0de3b24:	2003      	movs	r0, #3
c0de3b26:	2a00      	cmp	r2, #0
c0de3b28:	bf08      	it	eq
c0de3b2a:	2002      	moveq	r0, #2
c0de3b2c:	f004 faf8 	bl	c0de8120 <nbgl_containerPoolGet>
c0de3b30:	465d      	mov	r5, fp
c0de3b32:	f805 0f22 	strb.w	r0, [r5, #34]!
c0de3b36:	0e01      	lsrs	r1, r0, #24
c0de3b38:	70e9      	strb	r1, [r5, #3]
c0de3b3a:	0c01      	lsrs	r1, r0, #16
c0de3b3c:	0a00      	lsrs	r0, r0, #8
c0de3b3e:	70a9      	strb	r1, [r5, #2]
c0de3b40:	f88b 0023 	strb.w	r0, [fp, #35]	@ 0x23
        itemTextArea  = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3b44:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de3b48:	08c1      	lsrs	r1, r0, #3
c0de3b4a:	2004      	movs	r0, #4
c0de3b4c:	f004 fae3 	bl	c0de8116 <nbgl_objPoolGet>
        valueTextArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3b50:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
        itemTextArea  = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3b54:	4606      	mov	r6, r0
        valueTextArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de3b56:	08c9      	lsrs	r1, r1, #3
c0de3b58:	2004      	movs	r0, #4
c0de3b5a:	f004 fadc 	bl	c0de8116 <nbgl_objPoolGet>
c0de3b5e:	4604      	mov	r4, r0
        itemTextArea->text            = PIC(pair->item);
c0de3b60:	f8d8 0000 	ldr.w	r0, [r8]
c0de3b64:	2701      	movs	r7, #1
        itemTextArea->textColor       = LIGHT_TEXT_COLOR;
c0de3b66:	77f7      	strb	r7, [r6, #31]
        itemTextArea->text            = PIC(pair->item);
c0de3b68:	f005 f9c8 	bl	c0de8efc <pic>
c0de3b6c:	4601      	mov	r1, r0
c0de3b6e:	4630      	mov	r0, r6
c0de3b70:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de3b74:	0e0a      	lsrs	r2, r1, #24
c0de3b76:	70c2      	strb	r2, [r0, #3]
c0de3b78:	0c0a      	lsrs	r2, r1, #16
c0de3b7a:	7082      	strb	r2, [r0, #2]
c0de3b7c:	0a08      	lsrs	r0, r1, #8
c0de3b7e:	f886 0027 	strb.w	r0, [r6, #39]	@ 0x27
        itemTextArea->wrapping        = true;
c0de3b82:	f896 0024 	ldrb.w	r0, [r6, #36]	@ 0x24
        itemTextArea->fontId          = SMALL_REGULAR_FONT;
c0de3b86:	220b      	movs	r2, #11
        itemTextArea->wrapping        = true;
c0de3b88:	f040 0001 	orr.w	r0, r0, #1
c0de3b8c:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
        itemTextArea->obj.area.width  = AVAILABLE_WIDTH;
c0de3b90:	20a0      	movs	r0, #160	@ 0xa0
c0de3b92:	f04f 0a04 	mov.w	sl, #4
        itemTextArea->fontId          = SMALL_REGULAR_FONT;
c0de3b96:	f886 2022 	strb.w	r2, [r6, #34]	@ 0x22
        itemTextArea->obj.area.width  = AVAILABLE_WIDTH;
c0de3b9a:	7130      	strb	r0, [r6, #4]
        itemTextArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3b9c:	200b      	movs	r0, #11
c0de3b9e:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de3ba2:	2301      	movs	r3, #1
        itemTextArea->textAlignment   = MID_LEFT;
c0de3ba4:	f886 a020 	strb.w	sl, [r6, #32]
        itemTextArea->obj.area.width  = AVAILABLE_WIDTH;
c0de3ba8:	7177      	strb	r7, [r6, #5]
        itemTextArea->obj.area.height = nbgl_getTextHeightInWidth(
c0de3baa:	f004 facd 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de3bae:	71b0      	strb	r0, [r6, #6]
c0de3bb0:	9001      	str	r0, [sp, #4]
c0de3bb2:	0a00      	lsrs	r0, r0, #8
c0de3bb4:	71f0      	strb	r0, [r6, #7]
c0de3bb6:	2700      	movs	r7, #0
        itemTextArea->obj.alignTo                  = NULL;
c0de3bb8:	f106 0012 	add.w	r0, r6, #18
        itemTextArea->obj.alignment                = NO_ALIGNMENT;
c0de3bbc:	2109      	movs	r1, #9
        itemTextArea->style                        = NO_STYLE;
c0de3bbe:	f886 7021 	strb.w	r7, [r6, #33]	@ 0x21
        itemTextArea->obj.alignment                = NO_ALIGNMENT;
c0de3bc2:	f005 fb8f 	bl	c0de92e4 <__aeabi_memclr>
        container->children[container->nbChildren] = (nbgl_obj_t *) itemTextArea;
c0de3bc6:	7828      	ldrb	r0, [r5, #0]
c0de3bc8:	78a9      	ldrb	r1, [r5, #2]
c0de3bca:	78ea      	ldrb	r2, [r5, #3]
c0de3bcc:	f89b 3023 	ldrb.w	r3, [fp, #35]	@ 0x23
c0de3bd0:	f89b 5020 	ldrb.w	r5, [fp, #32]
c0de3bd4:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de3bd8:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de3bdc:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de3be0:	f840 6025 	str.w	r6, [r0, r5, lsl #2]
        container->nbChildren++;
c0de3be4:	1c68      	adds	r0, r5, #1
c0de3be6:	f88b 0020 	strb.w	r0, [fp, #32]
        valueTextArea->text          = PIC(pair->value);
c0de3bea:	f8d8 0004 	ldr.w	r0, [r8, #4]
        valueTextArea->textColor     = BLACK;
c0de3bee:	77e7      	strb	r7, [r4, #31]
        valueTextArea->text          = PIC(pair->value);
c0de3bf0:	f005 f984 	bl	c0de8efc <pic>
c0de3bf4:	4621      	mov	r1, r4
c0de3bf6:	f801 0f26 	strb.w	r0, [r1, #38]!
c0de3bfa:	0e02      	lsrs	r2, r0, #24
c0de3bfc:	70ca      	strb	r2, [r1, #3]
c0de3bfe:	0c02      	lsrs	r2, r0, #16
c0de3c00:	0a00      	lsrs	r0, r0, #8
c0de3c02:	f884 0027 	strb.w	r0, [r4, #39]	@ 0x27
        if (list->smallCaseForValue) {
c0de3c06:	9804      	ldr	r0, [sp, #16]
        valueTextArea->text          = PIC(pair->value);
c0de3c08:	708a      	strb	r2, [r1, #2]
        if (list->smallCaseForValue) {
c0de3c0a:	7b40      	ldrb	r0, [r0, #13]
        valueTextArea->textAlignment = MID_LEFT;
c0de3c0c:	f884 a020 	strb.w	sl, [r4, #32]
c0de3c10:	2800      	cmp	r0, #0
c0de3c12:	f04f 000c 	mov.w	r0, #12
c0de3c16:	bf08      	it	eq
c0de3c18:	200d      	moveq	r0, #13
c0de3c1a:	f884 0022 	strb.w	r0, [r4, #34]	@ 0x22
        if ((pair->aliasValue == 0) && (pair->valueIcon == NULL)) {
c0de3c1e:	f898 000c 	ldrb.w	r0, [r8, #12]
c0de3c22:	f246 1a35 	movw	sl, #24885	@ 0x6135
c0de3c26:	f2c0 0a00 	movt	sl, #0
c0de3c2a:	f010 0004 	ands.w	r0, r0, #4
c0de3c2e:	44fa      	add	sl, pc
c0de3c30:	d110      	bne.n	c0de3c54 <nbgl_layoutAddTagValueList+0x1e0>
c0de3c32:	f8d8 1008 	ldr.w	r1, [r8, #8]
c0de3c36:	2900      	cmp	r1, #0
c0de3c38:	f000 8115 	beq.w	c0de3e66 <nbgl_layoutAddTagValueList+0x3f2>
c0de3c3c:	f246 1a1f 	movw	sl, #24863	@ 0x611f
c0de3c40:	f2c0 0a00 	movt	sl, #0
c0de3c44:	44fa      	add	sl, pc
            if (pair->aliasValue) {
c0de3c46:	b928      	cbnz	r0, c0de3c54 <nbgl_layoutAddTagValueList+0x1e0>
                valueIcon = PIC(pair->valueIcon);
c0de3c48:	f8d8 0008 	ldr.w	r0, [r8, #8]
c0de3c4c:	f005 f956 	bl	c0de8efc <pic>
c0de3c50:	4682      	mov	sl, r0
c0de3c52:	bf00      	nop
c0de3c54:	4651      	mov	r1, sl
            valueTextArea->obj.area.width = AVAILABLE_WIDTH - valueIcon->width - 12;
c0de3c56:	f89a 0000 	ldrb.w	r0, [sl]
c0de3c5a:	f89a 1001 	ldrb.w	r1, [sl, #1]
c0de3c5e:	f8cd a000 	str.w	sl, [sp]
c0de3c62:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de3c66:	f5c0 72ca 	rsb	r2, r0, #404	@ 0x194
                                                      valueTextArea->text,
c0de3c6a:	4621      	mov	r1, r4
c0de3c6c:	f811 3f26 	ldrb.w	r3, [r1, #38]!
c0de3c70:	0a10      	lsrs	r0, r2, #8
c0de3c72:	f801 0c21 	strb.w	r0, [r1, #-33]
c0de3c76:	f801 2c22 	strb.w	r2, [r1, #-34]
        uint16_t nbLines = nbgl_getTextNbLinesInWidth(valueTextArea->fontId,
c0de3c7a:	f811 0c04 	ldrb.w	r0, [r1, #-4]
                                                      valueTextArea->text,
c0de3c7e:	784d      	ldrb	r5, [r1, #1]
c0de3c80:	788f      	ldrb	r7, [r1, #2]
c0de3c82:	78c9      	ldrb	r1, [r1, #3]
c0de3c84:	f8dd 8010 	ldr.w	r8, [sp, #16]
c0de3c88:	ea43 2505 	orr.w	r5, r3, r5, lsl #8
c0de3c8c:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
                                                      list->wrapping);
c0de3c90:	f898 300e 	ldrb.w	r3, [r8, #14]
                                                      valueTextArea->text,
c0de3c94:	ea45 4101 	orr.w	r1, r5, r1, lsl #16
        uint16_t nbLines = nbgl_getTextNbLinesInWidth(valueTextArea->fontId,
c0de3c98:	b292      	uxth	r2, r2
c0de3c9a:	f004 fa5a 	bl	c0de8152 <nbgl_getTextNbLinesInWidth>
        if ((list->nbMaxLinesForValue > 0) && (nbLines > list->nbMaxLinesForValue)) {
c0de3c9e:	f898 100b 	ldrb.w	r1, [r8, #11]
        uint16_t nbLines = nbgl_getTextNbLinesInWidth(valueTextArea->fontId,
c0de3ca2:	4682      	mov	sl, r0
        if ((list->nbMaxLinesForValue > 0) && (nbLines > list->nbMaxLinesForValue)) {
c0de3ca4:	2900      	cmp	r1, #0
c0de3ca6:	bf18      	it	ne
c0de3ca8:	458a      	cmpne	sl, r1
c0de3caa:	d90c      	bls.n	c0de3cc6 <nbgl_layoutAddTagValueList+0x252>
            valueTextArea->hideEndOfLastLine = list->hideEndOfLastLine;
c0de3cac:	f894 0024 	ldrb.w	r0, [r4, #36]	@ 0x24
c0de3cb0:	f898 200a 	ldrb.w	r2, [r8, #10]
c0de3cb4:	f000 00fd 	and.w	r0, r0, #253	@ 0xfd
c0de3cb8:	ea40 0042 	orr.w	r0, r0, r2, lsl #1
c0de3cbc:	468a      	mov	sl, r1
            valueTextArea->nbMaxLines        = list->nbMaxLinesForValue;
c0de3cbe:	f884 1025 	strb.w	r1, [r4, #37]	@ 0x25
            valueTextArea->hideEndOfLastLine = list->hideEndOfLastLine;
c0de3cc2:	f884 0024 	strb.w	r0, [r4, #36]	@ 0x24
        const nbgl_font_t *font                    = nbgl_getFont(valueTextArea->fontId);
c0de3cc6:	f894 0022 	ldrb.w	r0, [r4, #34]	@ 0x22
c0de3cca:	f004 fa2e 	bl	c0de812a <nbgl_getFont>
        valueTextArea->obj.alignmentMarginY        = 4;
c0de3cce:	2104      	movs	r1, #4
        valueTextArea->obj.area.height             = nbLines * font->line_height;
c0de3cd0:	79c5      	ldrb	r5, [r0, #7]
        valueTextArea->obj.alignmentMarginY        = 4;
c0de3cd2:	7661      	strb	r1, [r4, #25]
        valueTextArea->obj.alignTo                 = (nbgl_obj_t *) itemTextArea;
c0de3cd4:	0a31      	lsrs	r1, r6, #8
c0de3cd6:	74e1      	strb	r1, [r4, #19]
c0de3cd8:	4621      	mov	r1, r4
        valueTextArea->obj.area.height             = nbLines * font->line_height;
c0de3cda:	fb0a f005 	mul.w	r0, sl, r5
        valueTextArea->obj.alignTo                 = (nbgl_obj_t *) itemTextArea;
c0de3cde:	f801 6f12 	strb.w	r6, [r1, #18]!
c0de3ce2:	0c33      	lsrs	r3, r6, #16
        valueTextArea->obj.area.height             = nbLines * font->line_height;
c0de3ce4:	71a0      	strb	r0, [r4, #6]
        valueTextArea->obj.alignTo                 = (nbgl_obj_t *) itemTextArea;
c0de3ce6:	708b      	strb	r3, [r1, #2]
        valueTextArea->wrapping                    = list->wrapping;
c0de3ce8:	f894 3024 	ldrb.w	r3, [r4, #36]	@ 0x24
c0de3cec:	f898 700e 	ldrb.w	r7, [r8, #14]
c0de3cf0:	f003 03fe 	and.w	r3, r3, #254	@ 0xfe
c0de3cf4:	433b      	orrs	r3, r7
c0de3cf6:	f884 3024 	strb.w	r3, [r4, #36]	@ 0x24
        container->children[container->nbChildren] = (nbgl_obj_t *) valueTextArea;
c0de3cfa:	465b      	mov	r3, fp
c0de3cfc:	f813 7f22 	ldrb.w	r7, [r3, #34]!
        valueTextArea->obj.alignTo                 = (nbgl_obj_t *) itemTextArea;
c0de3d00:	0e32      	lsrs	r2, r6, #24
c0de3d02:	70ca      	strb	r2, [r1, #3]
        container->children[container->nbChildren] = (nbgl_obj_t *) valueTextArea;
c0de3d04:	7859      	ldrb	r1, [r3, #1]
c0de3d06:	789a      	ldrb	r2, [r3, #2]
c0de3d08:	78de      	ldrb	r6, [r3, #3]
c0de3d0a:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de3d0e:	ea42 2206 	orr.w	r2, r2, r6, lsl #8
c0de3d12:	f813 7c02 	ldrb.w	r7, [r3, #-2]
c0de3d16:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de3d1a:	9e00      	ldr	r6, [sp, #0]
c0de3d1c:	f841 4027 	str.w	r4, [r1, r7, lsl #2]
        container->nbChildren++;
c0de3d20:	1c79      	adds	r1, r7, #1
        valueTextArea->obj.area.height             = nbLines * font->line_height;
c0de3d22:	0a00      	lsrs	r0, r0, #8
        container->nbChildren++;
c0de3d24:	f803 1c02 	strb.w	r1, [r3, #-2]
        valueTextArea->obj.area.height             = nbLines * font->line_height;
c0de3d28:	71e0      	strb	r0, [r4, #7]
c0de3d2a:	2300      	movs	r3, #0
        valueTextArea->obj.alignment               = BOTTOM_LEFT;
c0de3d2c:	2007      	movs	r0, #7
        if (valueIcon != NULL) {
c0de3d2e:	2e00      	cmp	r6, #0
c0de3d30:	f04f 0701 	mov.w	r7, #1
        valueTextArea->style                       = NO_STYLE;
c0de3d34:	f884 3021 	strb.w	r3, [r4, #33]	@ 0x21
        valueTextArea->obj.alignment               = BOTTOM_LEFT;
c0de3d38:	75a0      	strb	r0, [r4, #22]
        valueTextArea->obj.alignmentMarginY        = 4;
c0de3d3a:	76a3      	strb	r3, [r4, #26]
        if (valueIcon != NULL) {
c0de3d3c:	d05e      	beq.n	c0de3dfc <nbgl_layoutAddTagValueList+0x388>
c0de3d3e:	9f05      	ldr	r7, [sp, #20]
            nbgl_image_t *image = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de3d40:	f897 00ad 	ldrb.w	r0, [r7, #173]	@ 0xad
c0de3d44:	08c1      	lsrs	r1, r0, #3
c0de3d46:	2002      	movs	r0, #2
c0de3d48:	f004 f9e5 	bl	c0de8116 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de3d4c:	f897 10ae 	ldrb.w	r1, [r7, #174]	@ 0xae
        layout->nbUsedCallbackObjs++;
c0de3d50:	f44f 4340 	mov.w	r3, #49152	@ 0xc000
c0de3d54:	1c4a      	adds	r2, r1, #1
c0de3d56:	f002 023f 	and.w	r2, r2, #63	@ 0x3f
c0de3d5a:	ea03 2301 	and.w	r3, r3, r1, lsl #8
c0de3d5e:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
                layoutInt, (nbgl_obj_t *) container, list->token, TUNE_TAP_CASUAL);
c0de3d62:	f898 300c 	ldrb.w	r3, [r8, #12]
        layout->nbUsedCallbackObjs++;
c0de3d66:	0a12      	lsrs	r2, r2, #8
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de3d68:	f001 013f 	and.w	r1, r1, #63	@ 0x3f
c0de3d6c:	f8dd 800c 	ldr.w	r8, [sp, #12]
        layout->nbUsedCallbackObjs++;
c0de3d70:	f887 20ae 	strb.w	r2, [r7, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de3d74:	eb07 01c1 	add.w	r1, r7, r1, lsl #3
        layoutObj->tuneId = tuneId;
c0de3d78:	2209      	movs	r2, #9
        layoutObj->obj    = obj;
c0de3d7a:	f8c1 b020 	str.w	fp, [r1, #32]
        layoutObj->token  = token;
c0de3d7e:	f881 3024 	strb.w	r3, [r1, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de3d82:	f881 2026 	strb.w	r2, [r1, #38]	@ 0x26
            obj->index                  = i;
c0de3d86:	f881 8025 	strb.w	r8, [r1, #37]	@ 0x25
            image->buffer               = valueIcon;
c0de3d8a:	0a31      	lsrs	r1, r6, #8
c0de3d8c:	f880 1022 	strb.w	r1, [r0, #34]	@ 0x22
c0de3d90:	4601      	mov	r1, r0
c0de3d92:	f801 6f21 	strb.w	r6, [r1, #33]!
c0de3d96:	0e32      	lsrs	r2, r6, #24
c0de3d98:	70ca      	strb	r2, [r1, #3]
c0de3d9a:	0c32      	lsrs	r2, r6, #16
c0de3d9c:	708a      	strb	r2, [r1, #2]
            image->obj.alignTo          = (nbgl_obj_t *) valueTextArea;
c0de3d9e:	0a21      	lsrs	r1, r4, #8
c0de3da0:	74c1      	strb	r1, [r0, #19]
c0de3da2:	4601      	mov	r1, r0
c0de3da4:	f801 4f12 	strb.w	r4, [r1, #18]!
c0de3da8:	0e22      	lsrs	r2, r4, #24
c0de3daa:	f04f 0c0c 	mov.w	ip, #12
c0de3dae:	70ca      	strb	r2, [r1, #3]
c0de3db0:	0c22      	lsrs	r2, r4, #16
            image->obj.alignmentMarginX = 12;
c0de3db2:	f880 c017 	strb.w	ip, [r0, #23]
            image->obj.alignTo          = (nbgl_obj_t *) valueTextArea;
c0de3db6:	708a      	strb	r2, [r1, #2]
            container->children[container->nbChildren] = (nbgl_obj_t *) image;
c0de3db8:	4659      	mov	r1, fp
c0de3dba:	f811 2f22 	ldrb.w	r2, [r1, #34]!
c0de3dbe:	f89b 3023 	ldrb.w	r3, [fp, #35]	@ 0x23
c0de3dc2:	788f      	ldrb	r7, [r1, #2]
c0de3dc4:	78c9      	ldrb	r1, [r1, #3]
c0de3dc6:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de3dca:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de3dce:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de3dd2:	f89b 2020 	ldrb.w	r2, [fp, #32]
c0de3dd6:	2300      	movs	r3, #0
c0de3dd8:	2701      	movs	r7, #1
            image->foregroundColor      = BLACK;
c0de3dda:	77c3      	strb	r3, [r0, #31]
            image->obj.alignment        = RIGHT_TOP;
c0de3ddc:	f880 c016 	strb.w	ip, [r0, #22]
            image->obj.alignmentMarginX = 12;
c0de3de0:	7603      	strb	r3, [r0, #24]
            container->obj.touchMask = (1 << TOUCHED);
c0de3de2:	f88b 701c 	strb.w	r7, [fp, #28]
            container->children[container->nbChildren] = (nbgl_obj_t *) image;
c0de3de6:	f841 0022 	str.w	r0, [r1, r2, lsl #2]
            container->obj.touchId   = VALUE_BUTTON_1_ID + i;
c0de3dea:	f108 000f 	add.w	r0, r8, #15
c0de3dee:	f88b 001e 	strb.w	r0, [fp, #30]
            container->nbChildren++;
c0de3df2:	1c50      	adds	r0, r2, #1
c0de3df4:	f88b 0020 	strb.w	r0, [fp, #32]
            container->obj.touchMask = (1 << TOUCHED);
c0de3df8:	f88b 301d 	strb.w	r3, [fp, #29]
c0de3dfc:	9801      	ldr	r0, [sp, #4]
        container->obj.area.width       = AVAILABLE_WIDTH;
c0de3dfe:	21a0      	movs	r1, #160	@ 0xa0
c0de3e00:	fb0a 0005 	mla	r0, sl, r5, r0
c0de3e04:	9d02      	ldr	r5, [sp, #8]
c0de3e06:	3004      	adds	r0, #4
        container->obj.area.height      = fullHeight;
c0de3e08:	f88b 0006 	strb.w	r0, [fp, #6]
c0de3e0c:	0a00      	lsrs	r0, r0, #8
c0de3e0e:	f88b 0007 	strb.w	r0, [fp, #7]
        if (i > 0) {
c0de3e12:	2d00      	cmp	r5, #0
        container->obj.alignmentMarginX = BORDER_MARGIN;
c0de3e14:	f04f 0020 	mov.w	r0, #32
        container->obj.area.width       = AVAILABLE_WIDTH;
c0de3e18:	f88b 7005 	strb.w	r7, [fp, #5]
c0de3e1c:	f88b 1004 	strb.w	r1, [fp, #4]
        container->layout               = VERTICAL;
c0de3e20:	f88b 301f 	strb.w	r3, [fp, #31]
        container->obj.alignmentMarginX = BORDER_MARGIN;
c0de3e24:	f88b 3018 	strb.w	r3, [fp, #24]
c0de3e28:	f88b 0017 	strb.w	r0, [fp, #23]
        if (i > 0) {
c0de3e2c:	f47f ae36 	bne.w	c0de3a9c <nbgl_layoutAddTagValueList+0x28>
            if (layoutInt->headerContainer && (layoutInt->headerContainer->nbChildren > 0)
c0de3e30:	9805      	ldr	r0, [sp, #20]
c0de3e32:	68c0      	ldr	r0, [r0, #12]
c0de3e34:	b1a8      	cbz	r0, c0de3e62 <nbgl_layoutAddTagValueList+0x3ee>
c0de3e36:	f890 1020 	ldrb.w	r1, [r0, #32]
                && (layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren - 1]
c0de3e3a:	b191      	cbz	r1, c0de3e62 <nbgl_layoutAddTagValueList+0x3ee>
c0de3e3c:	f810 2f22 	ldrb.w	r2, [r0, #34]!
c0de3e40:	7843      	ldrb	r3, [r0, #1]
c0de3e42:	7887      	ldrb	r7, [r0, #2]
c0de3e44:	78c0      	ldrb	r0, [r0, #3]
c0de3e46:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de3e4a:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de3e4e:	ea42 4000 	orr.w	r0, r2, r0, lsl #16
c0de3e52:	eb00 0081 	add.w	r0, r0, r1, lsl #2
c0de3e56:	f850 0c04 	ldr.w	r0, [r0, #-4]
                        ->type
c0de3e5a:	7ec0      	ldrb	r0, [r0, #27]
            if (layoutInt->headerContainer && (layoutInt->headerContainer->nbChildren > 0)
c0de3e5c:	2803      	cmp	r0, #3
c0de3e5e:	f43f ae1d 	beq.w	c0de3a9c <nbgl_layoutAddTagValueList+0x28>
c0de3e62:	2000      	movs	r0, #0
c0de3e64:	e61b      	b.n	c0de3a9e <nbgl_layoutAddTagValueList+0x2a>
c0de3e66:	2000      	movs	r0, #0
c0de3e68:	9000      	str	r0, [sp, #0]
c0de3e6a:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de3e6e:	e6fc      	b.n	c0de3c6a <nbgl_layoutAddTagValueList+0x1f6>
c0de3e70:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
}
c0de3e74:	b006      	add	sp, #24
c0de3e76:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de3e7a:	2000      	movs	r0, #0
c0de3e7c:	b006      	add	sp, #24
c0de3e7e:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de3e82 <nbgl_layoutAddSeparationLine>:
{
c0de3e82:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de3e84:	b081      	sub	sp, #4
c0de3e86:	4604      	mov	r4, r0
    line                       = createHorizontalLine(layoutInt->layer);
c0de3e88:	f890 00ad 	ldrb.w	r0, [r0, #173]	@ 0xad
c0de3e8c:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de3e8e:	2003      	movs	r0, #3
c0de3e90:	f004 f941 	bl	c0de8116 <nbgl_objPoolGet>
c0de3e94:	2701      	movs	r7, #1
c0de3e96:	22e0      	movs	r2, #224	@ 0xe0
c0de3e98:	f04f 0eff 	mov.w	lr, #255	@ 0xff
    line->obj.area.width  = SCREEN_WIDTH;
c0de3e9c:	7102      	strb	r2, [r0, #4]
    line->obj.area.height = 1;
c0de3e9e:	7187      	strb	r7, [r0, #6]
    line->obj.alignmentMarginY = -1;
c0de3ea0:	f880 e019 	strb.w	lr, [r0, #25]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de3ea4:	f8d4 30a0 	ldr.w	r3, [r4, #160]	@ 0xa0
c0de3ea8:	2102      	movs	r1, #2
    layout->container->children[layout->container->nbChildren] = obj;
c0de3eaa:	f813 2f22 	ldrb.w	r2, [r3, #34]!
    line->lineColor       = LIGHT_GRAY;
c0de3eae:	f880 1020 	strb.w	r1, [r0, #32]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3eb2:	7859      	ldrb	r1, [r3, #1]
c0de3eb4:	789d      	ldrb	r5, [r3, #2]
c0de3eb6:	78de      	ldrb	r6, [r3, #3]
c0de3eb8:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de3ebc:	ea45 2206 	orr.w	r2, r5, r6, lsl #8
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de3ec0:	f813 3c02 	ldrb.w	r3, [r3, #-2]
    layout->container->children[layout->container->nbChildren] = obj;
c0de3ec4:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de3ec8:	f841 0023 	str.w	r0, [r1, r3, lsl #2]
    layout->container->nbChildren++;
c0de3ecc:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
c0de3ed0:	f04f 0c00 	mov.w	ip, #0
c0de3ed4:	f891 2020 	ldrb.w	r2, [r1, #32]
    line->obj.area.height = 1;
c0de3ed8:	f880 c007 	strb.w	ip, [r0, #7]
    layout->container->nbChildren++;
c0de3edc:	3201      	adds	r2, #1
    line->obj.area.width  = SCREEN_WIDTH;
c0de3ede:	7147      	strb	r7, [r0, #5]
    line->direction       = HORIZONTAL;
c0de3ee0:	77c7      	strb	r7, [r0, #31]
    line->thickness       = 1;
c0de3ee2:	f880 7021 	strb.w	r7, [r0, #33]	@ 0x21
    line->obj.alignmentMarginY = -1;
c0de3ee6:	f880 e01a 	strb.w	lr, [r0, #26]
    return 0;
c0de3eea:	2000      	movs	r0, #0
    layout->container->nbChildren++;
c0de3eec:	f881 2020 	strb.w	r2, [r1, #32]
    return 0;
c0de3ef0:	b001      	add	sp, #4
c0de3ef2:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de3ef4 <nbgl_layoutAddButton>:
{
c0de3ef4:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
c0de3ef8:	b086      	sub	sp, #24
    if (layout == NULL) {
c0de3efa:	2800      	cmp	r0, #0
c0de3efc:	f000 8095 	beq.w	c0de402a <nbgl_layoutAddButton+0x136>
c0de3f00:	4604      	mov	r4, r0
    if ((buttonInfo->onBottom) && (!buttonInfo->fittingContent)) {
c0de3f02:	7ac8      	ldrb	r0, [r1, #11]
c0de3f04:	460d      	mov	r5, r1
c0de3f06:	b118      	cbz	r0, c0de3f10 <nbgl_layoutAddButton+0x1c>
c0de3f08:	7aa8      	ldrb	r0, [r5, #10]
c0de3f0a:	2800      	cmp	r0, #0
c0de3f0c:	f000 8092 	beq.w	c0de4034 <nbgl_layoutAddButton+0x140>
    button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de3f10:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de3f14:	08c1      	lsrs	r1, r0, #3
c0de3f16:	2005      	movs	r0, #5
c0de3f18:	f004 f8fd 	bl	c0de8116 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de3f1c:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de3f20:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de3f24:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de3f28:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de3f2c:	2a0e      	cmp	r2, #14
c0de3f2e:	d87c      	bhi.n	c0de402a <nbgl_layoutAddButton+0x136>
c0de3f30:	4606      	mov	r6, r0
c0de3f32:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de3f34:	3001      	adds	r0, #1
c0de3f36:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de3f3a:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de3f3e:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
        layoutInt, (nbgl_obj_t *) button, buttonInfo->token, buttonInfo->tuneId);
c0de3f42:	f895 c008 	ldrb.w	ip, [r5, #8]
c0de3f46:	7b2f      	ldrb	r7, [r5, #12]
        layout->nbUsedCallbackObjs++;
c0de3f48:	0a00      	lsrs	r0, r0, #8
c0de3f4a:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de3f4e:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de3f52:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de3f54:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de3f58:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
c0de3f5c:	f04f 0800 	mov.w	r8, #0
c0de3f60:	2020      	movs	r0, #32
c0de3f62:	270c      	movs	r7, #12
        layout->nbUsedCallbackObjs++;
c0de3f64:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
    button->obj.alignmentMarginX = BORDER_MARGIN;
c0de3f68:	f886 8018 	strb.w	r8, [r6, #24]
c0de3f6c:	75f0      	strb	r0, [r6, #23]
    button->obj.alignmentMarginY = 12;
c0de3f6e:	f886 801a 	strb.w	r8, [r6, #26]
c0de3f72:	7677      	strb	r7, [r6, #25]
    button->obj.alignment        = NO_ALIGNMENT;
c0de3f74:	f886 8016 	strb.w	r8, [r6, #22]
    if (buttonInfo->style == BLACK_BACKGROUND) {
c0de3f78:	7a68      	ldrb	r0, [r5, #9]
c0de3f7a:	2300      	movs	r3, #0
c0de3f7c:	4601      	mov	r1, r0
c0de3f7e:	4602      	mov	r2, r0
c0de3f80:	2800      	cmp	r0, #0
c0de3f82:	bf1c      	itt	ne
c0de3f84:	2101      	movne	r1, #1
c0de3f86:	2203      	movne	r2, #3
    if (buttonInfo->style == NO_BORDER) {
c0de3f88:	ea4f 0141 	mov.w	r1, r1, lsl #1
c0de3f8c:	bf08      	it	eq
c0de3f8e:	2303      	moveq	r3, #3
c0de3f90:	77f2      	strb	r2, [r6, #31]
c0de3f92:	f886 3021 	strb.w	r3, [r6, #33]	@ 0x21
c0de3f96:	2802      	cmp	r0, #2
c0de3f98:	bf08      	it	eq
c0de3f9a:	2103      	moveq	r1, #3
c0de3f9c:	f886 1020 	strb.w	r1, [r6, #32]
    button->text   = PIC(buttonInfo->text);
c0de3fa0:	6828      	ldr	r0, [r5, #0]
c0de3fa2:	f004 ffab 	bl	c0de8efc <pic>
c0de3fa6:	4631      	mov	r1, r6
c0de3fa8:	f801 0f25 	strb.w	r0, [r1, #37]!
c0de3fac:	0e02      	lsrs	r2, r0, #24
c0de3fae:	70ca      	strb	r2, [r1, #3]
c0de3fb0:	0c02      	lsrs	r2, r0, #16
c0de3fb2:	0a00      	lsrs	r0, r0, #8
c0de3fb4:	708a      	strb	r2, [r1, #2]
c0de3fb6:	f886 0026 	strb.w	r0, [r6, #38]	@ 0x26
    button->fontId = SMALL_BOLD_FONT;
c0de3fba:	f886 7023 	strb.w	r7, [r6, #35]	@ 0x23
    button->icon   = PIC(buttonInfo->icon);
c0de3fbe:	6868      	ldr	r0, [r5, #4]
c0de3fc0:	f004 ff9c 	bl	c0de8efc <pic>
c0de3fc4:	4631      	mov	r1, r6
c0de3fc6:	f801 0f2e 	strb.w	r0, [r1, #46]!
c0de3fca:	0e02      	lsrs	r2, r0, #24
c0de3fcc:	70ca      	strb	r2, [r1, #3]
c0de3fce:	0c02      	lsrs	r2, r0, #16
c0de3fd0:	0a00      	lsrs	r0, r0, #8
c0de3fd2:	708a      	strb	r2, [r1, #2]
c0de3fd4:	7048      	strb	r0, [r1, #1]
    if (buttonInfo->fittingContent == true) {
c0de3fd6:	7aa8      	ldrb	r0, [r5, #10]
c0de3fd8:	2800      	cmp	r0, #0
c0de3fda:	d042      	beq.n	c0de4062 <nbgl_layoutAddButton+0x16e>
        button->obj.area.width = nbgl_getTextWidth(button->fontId, button->text)
c0de3fdc:	4631      	mov	r1, r6
c0de3fde:	f811 2f25 	ldrb.w	r2, [r1, #37]!
c0de3fe2:	f896 0026 	ldrb.w	r0, [r6, #38]	@ 0x26
c0de3fe6:	788b      	ldrb	r3, [r1, #2]
c0de3fe8:	78c9      	ldrb	r1, [r1, #3]
c0de3fea:	ea42 2200 	orr.w	r2, r2, r0, lsl #8
c0de3fee:	f896 0023 	ldrb.w	r0, [r6, #35]	@ 0x23
c0de3ff2:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de3ff6:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de3ffa:	f004 f8af 	bl	c0de815c <nbgl_getTextWidth>
                                 + ((button->icon) ? (button->icon->width + 12) : 0);
c0de3ffe:	4631      	mov	r1, r6
c0de4000:	f811 2f2e 	ldrb.w	r2, [r1, #46]!
                                 + SMALL_BUTTON_HEIGHT
c0de4004:	3040      	adds	r0, #64	@ 0x40
                                 + ((button->icon) ? (button->icon->width + 12) : 0);
c0de4006:	784b      	ldrb	r3, [r1, #1]
c0de4008:	788f      	ldrb	r7, [r1, #2]
c0de400a:	78c9      	ldrb	r1, [r1, #3]
c0de400c:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de4010:	ea47 2101 	orr.w	r1, r7, r1, lsl #8
c0de4014:	ea42 4201 	orr.w	r2, r2, r1, lsl #16
c0de4018:	f04f 0100 	mov.w	r1, #0
c0de401c:	b36a      	cbz	r2, c0de407a <nbgl_layoutAddButton+0x186>
c0de401e:	7813      	ldrb	r3, [r2, #0]
c0de4020:	7852      	ldrb	r2, [r2, #1]
c0de4022:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de4026:	320c      	adds	r2, #12
c0de4028:	e028      	b.n	c0de407c <nbgl_layoutAddButton+0x188>
c0de402a:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
}
c0de402e:	b006      	add	sp, #24
c0de4030:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
        if (layoutInt->footerContainer == NULL) {
c0de4034:	6920      	ldr	r0, [r4, #16]
c0de4036:	2800      	cmp	r0, #0
c0de4038:	d068      	beq.n	c0de410c <nbgl_layoutAddButton+0x218>
c0de403a:	2001      	movs	r0, #1
            upFooterDesc.type          = UP_FOOTER_BUTTON;
c0de403c:	f88d 0000 	strb.w	r0, [sp]
            upFooterDesc.button.token  = buttonInfo->token;
c0de4040:	8928      	ldrh	r0, [r5, #8]
            upFooterDesc.button.text   = buttonInfo->text;
c0de4042:	6829      	ldr	r1, [r5, #0]
            upFooterDesc.button.token  = buttonInfo->token;
c0de4044:	f8ad 000c 	strh.w	r0, [sp, #12]
            upFooterDesc.button.icon   = buttonInfo->icon;
c0de4048:	6868      	ldr	r0, [r5, #4]
            upFooterDesc.button.tuneId = buttonInfo->tuneId;
c0de404a:	7b2a      	ldrb	r2, [r5, #12]
            upFooterDesc.button.text   = buttonInfo->text;
c0de404c:	9101      	str	r1, [sp, #4]
            upFooterDesc.button.icon   = buttonInfo->icon;
c0de404e:	9002      	str	r0, [sp, #8]
c0de4050:	4669      	mov	r1, sp
            return nbgl_layoutAddUpFooter(layout, &upFooterDesc);
c0de4052:	4620      	mov	r0, r4
            upFooterDesc.button.tuneId = buttonInfo->tuneId;
c0de4054:	f88d 2010 	strb.w	r2, [sp, #16]
            return nbgl_layoutAddUpFooter(layout, &upFooterDesc);
c0de4058:	f7fc ff72 	bl	c0de0f40 <nbgl_layoutAddUpFooter>
}
c0de405c:	b006      	add	sp, #24
c0de405e:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
c0de4062:	2001      	movs	r0, #1
        button->obj.area.width  = AVAILABLE_WIDTH;
c0de4064:	7170      	strb	r0, [r6, #5]
c0de4066:	20a0      	movs	r0, #160	@ 0xa0
c0de4068:	7130      	strb	r0, [r6, #4]
c0de406a:	2058      	movs	r0, #88	@ 0x58
        button->obj.area.height = BUTTON_DIAMETER;
c0de406c:	71b0      	strb	r0, [r6, #6]
c0de406e:	2004      	movs	r0, #4
c0de4070:	f886 8007 	strb.w	r8, [r6, #7]
        button->radius          = BUTTON_RADIUS;
c0de4074:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
c0de4078:	e01d      	b.n	c0de40b6 <nbgl_layoutAddButton+0x1c2>
c0de407a:	2200      	movs	r2, #0
                                 + ((button->icon) ? (button->icon->width + 12) : 0);
c0de407c:	4410      	add	r0, r2
        button->obj.area.height = SMALL_BUTTON_HEIGHT;
c0de407e:	71f1      	strb	r1, [r6, #7]
c0de4080:	2140      	movs	r1, #64	@ 0x40
        button->obj.area.width = nbgl_getTextWidth(button->fontId, button->text)
c0de4082:	0a02      	lsrs	r2, r0, #8
        button->obj.area.height = SMALL_BUTTON_HEIGHT;
c0de4084:	71b1      	strb	r1, [r6, #6]
c0de4086:	2102      	movs	r1, #2
        button->obj.area.width = nbgl_getTextWidth(button->fontId, button->text)
c0de4088:	7130      	strb	r0, [r6, #4]
c0de408a:	7172      	strb	r2, [r6, #5]
        button->radius          = SMALL_BUTTON_RADIUS_INDEX;
c0de408c:	f886 1022 	strb.w	r1, [r6, #34]	@ 0x22
        if (buttonInfo->onBottom != true) {
c0de4090:	7ae9      	ldrb	r1, [r5, #11]
c0de4092:	2901      	cmp	r1, #1
c0de4094:	d00f      	beq.n	c0de40b6 <nbgl_layoutAddButton+0x1c2>
            button->obj.alignmentMarginX += (AVAILABLE_WIDTH - button->obj.area.width) / 2;
c0de4096:	4631      	mov	r1, r6
c0de4098:	f811 2f17 	ldrb.w	r2, [r1, #23]!
c0de409c:	b280      	uxth	r0, r0
c0de409e:	784b      	ldrb	r3, [r1, #1]
c0de40a0:	f5c0 70d0 	rsb	r0, r0, #416	@ 0x1a0
c0de40a4:	eb00 70d0 	add.w	r0, r0, r0, lsr #31
c0de40a8:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de40ac:	eb02 0050 	add.w	r0, r2, r0, lsr #1
c0de40b0:	7008      	strb	r0, [r1, #0]
c0de40b2:	0a00      	lsrs	r0, r0, #8
c0de40b4:	7048      	strb	r0, [r1, #1]
c0de40b6:	2000      	movs	r0, #0
    button->obj.alignTo   = NULL;
c0de40b8:	4631      	mov	r1, r6
c0de40ba:	f801 0f12 	strb.w	r0, [r1, #18]!
c0de40be:	70c8      	strb	r0, [r1, #3]
c0de40c0:	7088      	strb	r0, [r1, #2]
c0de40c2:	2101      	movs	r1, #1
c0de40c4:	74f0      	strb	r0, [r6, #19]
    button->obj.touchMask = (1 << TOUCHED);
c0de40c6:	7770      	strb	r0, [r6, #29]
c0de40c8:	7731      	strb	r1, [r6, #28]
    button->obj.touchId   = (buttonInfo->fittingContent) ? EXTRA_BUTTON_ID : SINGLE_BUTTON_ID;
c0de40ca:	7aa9      	ldrb	r1, [r5, #10]
c0de40cc:	2208      	movs	r2, #8
c0de40ce:	2900      	cmp	r1, #0
c0de40d0:	bf08      	it	eq
c0de40d2:	2207      	moveq	r2, #7
c0de40d4:	77b2      	strb	r2, [r6, #30]
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de40d6:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
    layout->container->children[layout->container->nbChildren] = obj;
c0de40da:	f811 2f22 	ldrb.w	r2, [r1, #34]!
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de40de:	f811 3c02 	ldrb.w	r3, [r1, #-2]
    layout->container->children[layout->container->nbChildren] = obj;
c0de40e2:	784f      	ldrb	r7, [r1, #1]
c0de40e4:	788d      	ldrb	r5, [r1, #2]
c0de40e6:	78c9      	ldrb	r1, [r1, #3]
c0de40e8:	ea42 2207 	orr.w	r2, r2, r7, lsl #8
c0de40ec:	ea45 2101 	orr.w	r1, r5, r1, lsl #8
c0de40f0:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de40f4:	f841 6023 	str.w	r6, [r1, r3, lsl #2]
    layout->container->nbChildren++;
c0de40f8:	f8d4 10a0 	ldr.w	r1, [r4, #160]	@ 0xa0
c0de40fc:	f891 2020 	ldrb.w	r2, [r1, #32]
c0de4100:	3201      	adds	r2, #1
c0de4102:	f881 2020 	strb.w	r2, [r1, #32]
}
c0de4106:	b006      	add	sp, #24
c0de4108:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
c0de410c:	2005      	movs	r0, #5
            footerDesc.type           = FOOTER_SIMPLE_BUTTON;
c0de410e:	f8ad 0000 	strh.w	r0, [sp]
            footerDesc.button.token   = buttonInfo->token;
c0de4112:	8928      	ldrh	r0, [r5, #8]
            footerDesc.button.text    = buttonInfo->text;
c0de4114:	6829      	ldr	r1, [r5, #0]
            footerDesc.button.token   = buttonInfo->token;
c0de4116:	f8ad 000c 	strh.w	r0, [sp, #12]
            footerDesc.button.icon    = buttonInfo->icon;
c0de411a:	6868      	ldr	r0, [r5, #4]
            footerDesc.button.tuneId  = buttonInfo->tuneId;
c0de411c:	7b2a      	ldrb	r2, [r5, #12]
            footerDesc.button.text    = buttonInfo->text;
c0de411e:	9101      	str	r1, [sp, #4]
            footerDesc.button.icon    = buttonInfo->icon;
c0de4120:	9002      	str	r0, [sp, #8]
c0de4122:	4669      	mov	r1, sp
            return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de4124:	4620      	mov	r0, r4
            footerDesc.button.tuneId  = buttonInfo->tuneId;
c0de4126:	f88d 2010 	strb.w	r2, [sp, #16]
            return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de412a:	f7fd fc0b 	bl	c0de1944 <nbgl_layoutAddExtendedFooter>
}
c0de412e:	b006      	add	sp, #24
c0de4130:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}

c0de4134 <nbgl_layoutAddLongPressButton>:
{
c0de4134:	b580      	push	{r7, lr}
c0de4136:	b086      	sub	sp, #24
c0de4138:	f04f 0c00 	mov.w	ip, #0
    if (layout == NULL) {
c0de413c:	2800      	cmp	r0, #0
    nbgl_layoutUpFooter_t upFooterDesc = {.type             = UP_FOOTER_LONG_PRESS,
c0de413e:	f88d c004 	strb.w	ip, [sp, #4]
                                          .longPress.text   = text,
c0de4142:	9102      	str	r1, [sp, #8]
c0de4144:	f88d 200c 	strb.w	r2, [sp, #12]
c0de4148:	f88d 300d 	strb.w	r3, [sp, #13]
c0de414c:	bf0e      	itee	eq
c0de414e:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
c0de4152:	f10d 0104 	addne.w	r1, sp, #4
    return nbgl_layoutAddUpFooter(layout, &upFooterDesc);
c0de4156:	f7fc fef3 	blne	c0de0f40 <nbgl_layoutAddUpFooter>
}
c0de415a:	b006      	add	sp, #24
c0de415c:	bd80      	pop	{r7, pc}

c0de415e <nbgl_layoutAddFooter>:
{
c0de415e:	b580      	push	{r7, lr}
c0de4160:	b086      	sub	sp, #24
    footerDesc.simpleText.text     = text;
c0de4162:	9101      	str	r1, [sp, #4]
c0de4164:	2100      	movs	r1, #0
c0de4166:	f240 1c01 	movw	ip, #257	@ 0x101
    footerDesc.simpleText.mutedOut = false;
c0de416a:	f88d 1008 	strb.w	r1, [sp, #8]
c0de416e:	4669      	mov	r1, sp
    footerDesc.type                = FOOTER_SIMPLE_TEXT;
c0de4170:	f8ad c000 	strh.w	ip, [sp]
    footerDesc.simpleText.token    = token;
c0de4174:	f88d 2009 	strb.w	r2, [sp, #9]
    footerDesc.simpleText.tuneId   = tuneId;
c0de4178:	f88d 300a 	strb.w	r3, [sp, #10]
    return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de417c:	f7fd fbe2 	bl	c0de1944 <nbgl_layoutAddExtendedFooter>
c0de4180:	b006      	add	sp, #24
c0de4182:	bd80      	pop	{r7, pc}

c0de4184 <nbgl_layoutAddSplitFooter>:
{
c0de4184:	b510      	push	{r4, lr}
c0de4186:	b086      	sub	sp, #24
c0de4188:	e9dd ec08 	ldrd	lr, ip, [sp, #32]
c0de418c:	f44f 7481 	mov.w	r4, #258	@ 0x102
    footerDesc.doubleText.leftText   = leftText;
c0de4190:	9101      	str	r1, [sp, #4]
c0de4192:	4669      	mov	r1, sp
    footerDesc.type                  = FOOTER_DOUBLE_TEXT;
c0de4194:	f8ad 4000 	strh.w	r4, [sp]
    footerDesc.doubleText.leftToken  = leftToken;
c0de4198:	f88d 200c 	strb.w	r2, [sp, #12]
    footerDesc.doubleText.rightText  = rightText;
c0de419c:	9302      	str	r3, [sp, #8]
    footerDesc.doubleText.rightToken = rightToken;
c0de419e:	f88d e00d 	strb.w	lr, [sp, #13]
    footerDesc.doubleText.tuneId     = tuneId;
c0de41a2:	f88d c00e 	strb.w	ip, [sp, #14]
    return nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de41a6:	f7fd fbcd 	bl	c0de1944 <nbgl_layoutAddExtendedFooter>
c0de41aa:	b006      	add	sp, #24
c0de41ac:	bd10      	pop	{r4, pc}

c0de41ae <nbgl_layoutAddHeader>:
{
c0de41ae:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
    if (layout == NULL) {
c0de41b2:	2800      	cmp	r0, #0
c0de41b4:	f000 830b 	beq.w	c0de47ce <nbgl_layoutAddHeader+0x620>
c0de41b8:	468b      	mov	fp, r1
    if ((headerDesc == NULL) || (headerDesc->type >= NB_HEADER_TYPES)) {
c0de41ba:	b121      	cbz	r1, c0de41c6 <nbgl_layoutAddHeader+0x18>
c0de41bc:	4604      	mov	r4, r0
c0de41be:	f89b 0000 	ldrb.w	r0, [fp]
c0de41c2:	2806      	cmp	r0, #6
c0de41c4:	d903      	bls.n	c0de41ce <nbgl_layoutAddHeader+0x20>
c0de41c6:	f06f 0001 	mvn.w	r0, #1
}
c0de41ca:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
    layoutInt->headerContainer = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de41ce:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de41d2:	2601      	movs	r6, #1
c0de41d4:	08c1      	lsrs	r1, r0, #3
c0de41d6:	2001      	movs	r0, #1
c0de41d8:	f003 ff9d 	bl	c0de8116 <nbgl_objPoolGet>
c0de41dc:	21e0      	movs	r1, #224	@ 0xe0
c0de41de:	60e0      	str	r0, [r4, #12]
    layoutInt->headerContainer->obj.area.width = SCREEN_WIDTH;
c0de41e0:	7101      	strb	r1, [r0, #4]
c0de41e2:	2100      	movs	r1, #0
c0de41e4:	7146      	strb	r6, [r0, #5]
    layoutInt->headerContainer->layout         = VERTICAL;
c0de41e6:	77c1      	strb	r1, [r0, #31]
        = (nbgl_obj_t **) nbgl_containerPoolGet(5, layoutInt->layer);
c0de41e8:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de41ec:	08c1      	lsrs	r1, r0, #3
c0de41ee:	2005      	movs	r0, #5
c0de41f0:	f003 ff96 	bl	c0de8120 <nbgl_containerPoolGet>
    layoutInt->headerContainer->children
c0de41f4:	68e1      	ldr	r1, [r4, #12]
        = (nbgl_obj_t **) nbgl_containerPoolGet(5, layoutInt->layer);
c0de41f6:	0a02      	lsrs	r2, r0, #8
c0de41f8:	f881 2023 	strb.w	r2, [r1, #35]	@ 0x23
c0de41fc:	460a      	mov	r2, r1
c0de41fe:	f802 0f22 	strb.w	r0, [r2, #34]!
c0de4202:	0e03      	lsrs	r3, r0, #24
c0de4204:	0c00      	lsrs	r0, r0, #16
c0de4206:	7090      	strb	r0, [r2, #2]
c0de4208:	70d3      	strb	r3, [r2, #3]
    switch (headerDesc->type) {
c0de420a:	f89b 2000 	ldrb.w	r2, [fp]
c0de420e:	2002      	movs	r0, #2
    layoutInt->headerContainer->obj.alignment = TOP_MIDDLE;
c0de4210:	7588      	strb	r0, [r1, #22]
    switch (headerDesc->type) {
c0de4212:	2a03      	cmp	r2, #3
c0de4214:	f06f 0001 	mvn.w	r0, #1
c0de4218:	dc0a      	bgt.n	c0de4230 <nbgl_layoutAddHeader+0x82>
c0de421a:	1e53      	subs	r3, r2, #1
c0de421c:	2b02      	cmp	r3, #2
c0de421e:	d37e      	bcc.n	c0de431e <nbgl_layoutAddHeader+0x170>
c0de4220:	2a00      	cmp	r2, #0
c0de4222:	f000 80bf 	beq.w	c0de43a4 <nbgl_layoutAddHeader+0x1f6>
c0de4226:	2a03      	cmp	r2, #3
}
c0de4228:	bf18      	it	ne
c0de422a:	e8bd 8df0 	ldmiane.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de422e:	e39c      	b.n	c0de496a <nbgl_layoutAddHeader+0x7bc>
    switch (headerDesc->type) {
c0de4230:	2a04      	cmp	r2, #4
c0de4232:	f000 80bd 	beq.w	c0de43b0 <nbgl_layoutAddHeader+0x202>
c0de4236:	2a05      	cmp	r2, #5
c0de4238:	d071      	beq.n	c0de431e <nbgl_layoutAddHeader+0x170>
c0de423a:	2a06      	cmp	r2, #6
c0de423c:	f040 83ea 	bne.w	c0de4a14 <nbgl_layoutAddHeader+0x866>
            textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de4240:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de4244:	08c1      	lsrs	r1, r0, #3
c0de4246:	2004      	movs	r0, #4
c0de4248:	f003 ff65 	bl	c0de8116 <nbgl_objPoolGet>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de424c:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de4250:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de4254:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de4258:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de425c:	2a0e      	cmp	r2, #14
c0de425e:	bf84      	itt	hi
c0de4260:	f04f 30ff 	movhi.w	r0, #4294967295	@ 0xffffffff
}
c0de4264:	e8bd 8df0 	ldmiahi.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de4268:	4606      	mov	r6, r0
c0de426a:	0a08      	lsrs	r0, r1, #8
        layout->nbUsedCallbackObjs++;
c0de426c:	3001      	adds	r0, #1
c0de426e:	f000 003f 	and.w	r0, r0, #63	@ 0x3f
c0de4272:	f401 4340 	and.w	r3, r1, #49152	@ 0xc000
c0de4276:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
                                       headerDesc->rightText.token,
c0de427a:	f89b c008 	ldrb.w	ip, [fp, #8]
                                       headerDesc->rightText.tuneId);
c0de427e:	f89b 7009 	ldrb.w	r7, [fp, #9]
        layout->nbUsedCallbackObjs++;
c0de4282:	0a00      	lsrs	r0, r0, #8
c0de4284:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
        layoutObj->obj    = obj;
c0de4288:	eb04 00c2 	add.w	r0, r4, r2, lsl #3
c0de428c:	6206      	str	r6, [r0, #32]
        layoutObj->token  = token;
c0de428e:	f880 c024 	strb.w	ip, [r0, #36]	@ 0x24
        layoutObj->tuneId = tuneId;
c0de4292:	f880 7026 	strb.w	r7, [r0, #38]	@ 0x26
c0de4296:	2020      	movs	r0, #32
        layout->nbUsedCallbackObjs++;
c0de4298:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
            textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de429c:	75f0      	strb	r0, [r6, #23]
c0de429e:	20a0      	movs	r0, #160	@ 0xa0
            textArea->obj.area.width       = AVAILABLE_WIDTH;
c0de42a0:	7130      	strb	r0, [r6, #4]
c0de42a2:	2060      	movs	r0, #96	@ 0x60
            textArea->obj.area.height      = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de42a4:	4637      	mov	r7, r6
c0de42a6:	f04f 0806 	mov.w	r8, #6
c0de42aa:	f04f 0a00 	mov.w	sl, #0
c0de42ae:	2501      	movs	r5, #1
c0de42b0:	f807 0f06 	strb.w	r0, [r7, #6]!
            textArea->obj.alignment        = MID_RIGHT;
c0de42b4:	f886 8016 	strb.w	r8, [r6, #22]
            textArea->obj.alignmentMarginX = BORDER_MARGIN;
c0de42b8:	f886 a018 	strb.w	sl, [r6, #24]
            textArea->textColor            = BLACK;
c0de42bc:	f886 a01f 	strb.w	sl, [r6, #31]
            textArea->obj.area.width       = AVAILABLE_WIDTH;
c0de42c0:	7175      	strb	r5, [r6, #5]
            textArea->obj.area.height      = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de42c2:	f887 a001 	strb.w	sl, [r7, #1]
            textArea->text                 = PIC(headerDesc->rightText.text);
c0de42c6:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de42ca:	f004 fe17 	bl	c0de8efc <pic>
c0de42ce:	4631      	mov	r1, r6
c0de42d0:	f801 0f26 	strb.w	r0, [r1, #38]!
c0de42d4:	0e02      	lsrs	r2, r0, #24
c0de42d6:	70ca      	strb	r2, [r1, #3]
c0de42d8:	0c02      	lsrs	r2, r0, #16
c0de42da:	0a00      	lsrs	r0, r0, #8
c0de42dc:	708a      	strb	r2, [r1, #2]
c0de42de:	f886 0027 	strb.w	r0, [r6, #39]	@ 0x27
c0de42e2:	200c      	movs	r0, #12
            textArea->obj.touchMask        = (1 << TOUCHED);
c0de42e4:	7735      	strb	r5, [r6, #28]
            textArea->fontId               = SMALL_BOLD_FONT;
c0de42e6:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de42ea:	68e0      	ldr	r0, [r4, #12]
            textArea->textAlignment        = MID_RIGHT;
c0de42ec:	f886 8020 	strb.w	r8, [r6, #32]
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de42f0:	f810 1f22 	ldrb.w	r1, [r0, #34]!
            textArea->obj.touchMask        = (1 << TOUCHED);
c0de42f4:	f886 a01d 	strb.w	sl, [r6, #29]
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de42f8:	f810 cc02 	ldrb.w	ip, [r0, #-2]
c0de42fc:	7843      	ldrb	r3, [r0, #1]
c0de42fe:	7882      	ldrb	r2, [r0, #2]
c0de4300:	78c0      	ldrb	r0, [r0, #3]
c0de4302:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de4306:	ea42 2000 	orr.w	r0, r2, r0, lsl #8
c0de430a:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
                = (nbgl_obj_t *) textArea;
c0de430e:	f840 602c 	str.w	r6, [r0, ip, lsl #2]
            layoutInt->headerContainer->nbChildren++;
c0de4312:	68e0      	ldr	r0, [r4, #12]
c0de4314:	2105      	movs	r1, #5
c0de4316:	f890 2020 	ldrb.w	r2, [r0, #32]
            textArea->obj.touchId          = TOP_RIGHT_BUTTON_ID;
c0de431a:	77b1      	strb	r1, [r6, #30]
c0de431c:	e087      	b.n	c0de442e <nbgl_layoutAddHeader+0x280>
c0de431e:	f8db 0008 	ldr.w	r0, [fp, #8]
c0de4322:	f004 fdeb 	bl	c0de8efc <pic>
c0de4326:	4680      	mov	r8, r0
            uint8_t        backToken    = (headerDesc->type == HEADER_EXTENDED_BACK)
c0de4328:	f89b 0000 	ldrb.w	r0, [fp]
c0de432c:	210c      	movs	r1, #12
c0de432e:	2805      	cmp	r0, #5
c0de4330:	bf08      	it	eq
c0de4332:	2111      	moveq	r1, #17
            button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de4334:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de4338:	f81b 7001 	ldrb.w	r7, [fp, r1]
c0de433c:	08c1      	lsrs	r1, r0, #3
c0de433e:	2005      	movs	r0, #5
c0de4340:	f003 fee9 	bl	c0de8116 <nbgl_objPoolGet>
c0de4344:	4606      	mov	r6, r0
            if (backToken != NBGL_INVALID_TOKEN) {
c0de4346:	2fff      	cmp	r7, #255	@ 0xff
c0de4348:	f04f 0c03 	mov.w	ip, #3
c0de434c:	d028      	beq.n	c0de43a0 <nbgl_layoutAddHeader+0x1f2>
    if (layout->nbUsedCallbackObjs < (LAYOUT_OBJ_POOL_LEN - 1)) {
c0de434e:	f894 10ad 	ldrb.w	r1, [r4, #173]	@ 0xad
c0de4352:	f894 20ae 	ldrb.w	r2, [r4, #174]	@ 0xae
c0de4356:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de435a:	f3c1 2205 	ubfx	r2, r1, #8, #6
c0de435e:	2a0e      	cmp	r2, #14
c0de4360:	d86d      	bhi.n	c0de443e <nbgl_layoutAddHeader+0x290>
                                           (headerDesc->type == HEADER_EXTENDED_BACK)
c0de4362:	f89b 0000 	ldrb.w	r0, [fp]
c0de4366:	230d      	movs	r3, #13
c0de4368:	ea4f 2e11 	mov.w	lr, r1, lsr #8
c0de436c:	2805      	cmp	r0, #5
c0de436e:	bf08      	it	eq
c0de4370:	2313      	moveq	r3, #19
c0de4372:	f81b a003 	ldrb.w	sl, [fp, r3]
        layout->nbUsedCallbackObjs++;
c0de4376:	f10e 0301 	add.w	r3, lr, #1
c0de437a:	f003 033f 	and.w	r3, r3, #63	@ 0x3f
c0de437e:	f401 4040 	and.w	r0, r1, #49152	@ 0xc000
        layoutObj = &layout->callbackObjPool[layout->nbUsedCallbackObjs];
c0de4382:	eb04 02c2 	add.w	r2, r4, r2, lsl #3
        layout->nbUsedCallbackObjs++;
c0de4386:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
        layoutObj->obj    = obj;
c0de438a:	f842 6f20 	str.w	r6, [r2, #32]!
        layout->nbUsedCallbackObjs++;
c0de438e:	0a00      	lsrs	r0, r0, #8
c0de4390:	f884 00ae 	strb.w	r0, [r4, #174]	@ 0xae
c0de4394:	f884 10ad 	strb.w	r1, [r4, #173]	@ 0xad
        layoutObj->token  = token;
c0de4398:	7117      	strb	r7, [r2, #4]
        layoutObj->tuneId = tuneId;
c0de439a:	f882 a006 	strb.w	sl, [r2, #6]
c0de439e:	e04f      	b.n	c0de4440 <nbgl_layoutAddHeader+0x292>
c0de43a0:	2103      	movs	r1, #3
c0de43a2:	e051      	b.n	c0de4448 <nbgl_layoutAddHeader+0x29a>
            layoutInt->headerContainer->obj.area.height = headerDesc->emptySpace.height;
c0de43a4:	f8bb 0004 	ldrh.w	r0, [fp, #4]
c0de43a8:	7188      	strb	r0, [r1, #6]
c0de43aa:	0a00      	lsrs	r0, r0, #8
c0de43ac:	71c8      	strb	r0, [r1, #7]
c0de43ae:	e2dc      	b.n	c0de496a <nbgl_layoutAddHeader+0x7bc>
            textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de43b0:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de43b4:	08c1      	lsrs	r1, r0, #3
c0de43b6:	2004      	movs	r0, #4
c0de43b8:	f003 fead 	bl	c0de8116 <nbgl_objPoolGet>
c0de43bc:	4606      	mov	r6, r0
c0de43be:	2101      	movs	r1, #1
            textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de43c0:	7171      	strb	r1, [r6, #5]
c0de43c2:	21a0      	movs	r1, #160	@ 0xa0
c0de43c4:	7131      	strb	r1, [r6, #4]
c0de43c6:	2160      	movs	r1, #96	@ 0x60
            textArea->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de43c8:	4637      	mov	r7, r6
c0de43ca:	2000      	movs	r0, #0
c0de43cc:	f807 1f06 	strb.w	r1, [r7, #6]!
            textArea->textColor = BLACK;
c0de43d0:	77f0      	strb	r0, [r6, #31]
            textArea->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de43d2:	7078      	strb	r0, [r7, #1]
            textArea->text            = PIC(headerDesc->title.text);
c0de43d4:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de43d8:	f004 fd90 	bl	c0de8efc <pic>
c0de43dc:	4631      	mov	r1, r6
c0de43de:	f801 0f26 	strb.w	r0, [r1, #38]!
c0de43e2:	0e02      	lsrs	r2, r0, #24
c0de43e4:	70ca      	strb	r2, [r1, #3]
c0de43e6:	0c02      	lsrs	r2, r0, #16
c0de43e8:	708a      	strb	r2, [r1, #2]
            textArea->wrapping        = true;
c0de43ea:	f896 1024 	ldrb.w	r1, [r6, #36]	@ 0x24
            textArea->text            = PIC(headerDesc->title.text);
c0de43ee:	0a00      	lsrs	r0, r0, #8
c0de43f0:	f886 0027 	strb.w	r0, [r6, #39]	@ 0x27
            textArea->wrapping        = true;
c0de43f4:	f041 0001 	orr.w	r0, r1, #1
c0de43f8:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de43fc:	68e0      	ldr	r0, [r4, #12]
c0de43fe:	210c      	movs	r1, #12
c0de4400:	f810 2f22 	ldrb.w	r2, [r0, #34]!
            textArea->fontId          = SMALL_BOLD_FONT;
c0de4404:	f886 1022 	strb.w	r1, [r6, #34]	@ 0x22
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4408:	f810 cc02 	ldrb.w	ip, [r0, #-2]
c0de440c:	7843      	ldrb	r3, [r0, #1]
c0de440e:	7881      	ldrb	r1, [r0, #2]
c0de4410:	78c0      	ldrb	r0, [r0, #3]
c0de4412:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de4416:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de441a:	ea42 4000 	orr.w	r0, r2, r0, lsl #16
                = (nbgl_obj_t *) textArea;
c0de441e:	f840 602c 	str.w	r6, [r0, ip, lsl #2]
            layoutInt->headerContainer->nbChildren++;
c0de4422:	68e0      	ldr	r0, [r4, #12]
c0de4424:	2105      	movs	r1, #5
c0de4426:	f890 2020 	ldrb.w	r2, [r0, #32]
            textArea->textAlignment   = CENTER;
c0de442a:	f886 1020 	strb.w	r1, [r6, #32]
c0de442e:	1c51      	adds	r1, r2, #1
c0de4430:	f880 1020 	strb.w	r1, [r0, #32]
c0de4434:	7879      	ldrb	r1, [r7, #1]
c0de4436:	783a      	ldrb	r2, [r7, #0]
c0de4438:	71c1      	strb	r1, [r0, #7]
c0de443a:	7182      	strb	r2, [r0, #6]
c0de443c:	e295      	b.n	c0de496a <nbgl_layoutAddHeader+0x7bc>
c0de443e:	2200      	movs	r2, #0
                if (obj == NULL) {
c0de4440:	2a00      	cmp	r2, #0
c0de4442:	f000 81c4 	beq.w	c0de47ce <nbgl_layoutAddHeader+0x620>
c0de4446:	2100      	movs	r1, #0
            if (backToken != NBGL_INVALID_TOKEN) {
c0de4448:	3fff      	subs	r7, #255	@ 0xff
c0de444a:	f04f 0004 	mov.w	r0, #4
c0de444e:	bf18      	it	ne
c0de4450:	2701      	movne	r7, #1
            button->obj.alignment   = MID_LEFT;
c0de4452:	75b0      	strb	r0, [r6, #22]
c0de4454:	2068      	movs	r0, #104	@ 0x68
            button->obj.area.width  = BACK_KEY_WIDTH;
c0de4456:	7130      	strb	r0, [r6, #4]
c0de4458:	2060      	movs	r0, #96	@ 0x60
c0de445a:	f04f 0a00 	mov.w	sl, #0
            button->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de445e:	71b0      	strb	r0, [r6, #6]
            button->text            = NULL;
c0de4460:	4630      	mov	r0, r6
c0de4462:	f800 af25 	strb.w	sl, [r0, #37]!
            button->innerColor      = WHITE;
c0de4466:	f886 c01f 	strb.w	ip, [r6, #31]
            button->foregroundColor = (backToken != NBGL_INVALID_TOKEN) ? BLACK : WHITE;
c0de446a:	f886 1021 	strb.w	r1, [r6, #33]	@ 0x21
            button->borderColor     = WHITE;
c0de446e:	f886 c020 	strb.w	ip, [r6, #32]
            button->obj.area.width  = BACK_KEY_WIDTH;
c0de4472:	f886 a005 	strb.w	sl, [r6, #5]
            button->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de4476:	f886 a007 	strb.w	sl, [r6, #7]
            button->text            = NULL;
c0de447a:	f886 a026 	strb.w	sl, [r6, #38]	@ 0x26
c0de447e:	f880 a003 	strb.w	sl, [r0, #3]
c0de4482:	f880 a002 	strb.w	sl, [r0, #2]
            button->icon            = PIC(&LEFT_ARROW_ICON);
c0de4486:	f245 503c 	movw	r0, #21820	@ 0x553c
c0de448a:	f2c0 0000 	movt	r0, #0
c0de448e:	4478      	add	r0, pc
c0de4490:	f004 fd34 	bl	c0de8efc <pic>
c0de4494:	4631      	mov	r1, r6
c0de4496:	f801 0f2e 	strb.w	r0, [r1, #46]!
c0de449a:	0e02      	lsrs	r2, r0, #24
c0de449c:	0c03      	lsrs	r3, r0, #16
c0de449e:	0a00      	lsrs	r0, r0, #8
c0de44a0:	708b      	strb	r3, [r1, #2]
c0de44a2:	f886 002f 	strb.w	r0, [r6, #47]	@ 0x2f
            button->obj.touchMask   = (backToken != NBGL_INVALID_TOKEN) ? (1 << TOUCHED) : 0;
c0de44a6:	7737      	strb	r7, [r6, #28]
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de44a8:	68e0      	ldr	r0, [r4, #12]
            button->icon            = PIC(&LEFT_ARROW_ICON);
c0de44aa:	70ca      	strb	r2, [r1, #3]
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de44ac:	f810 1f22 	ldrb.w	r1, [r0, #34]!
            if (text != NULL) {
c0de44b0:	f1b8 0f00 	cmp.w	r8, #0
            layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de44b4:	f810 2c02 	ldrb.w	r2, [r0, #-2]
c0de44b8:	7843      	ldrb	r3, [r0, #1]
c0de44ba:	7887      	ldrb	r7, [r0, #2]
c0de44bc:	78c0      	ldrb	r0, [r0, #3]
c0de44be:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de44c2:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de44c6:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
                = (nbgl_obj_t *) button;
c0de44ca:	f840 6022 	str.w	r6, [r0, r2, lsl #2]
            layoutInt->headerContainer->nbChildren++;
c0de44ce:	68e0      	ldr	r0, [r4, #12]
c0de44d0:	f04f 0106 	mov.w	r1, #6
c0de44d4:	f890 2020 	ldrb.w	r2, [r0, #32]
            button->obj.touchId     = BACK_BUTTON_ID;
c0de44d8:	77b1      	strb	r1, [r6, #30]
            layoutInt->headerContainer->nbChildren++;
c0de44da:	f102 0101 	add.w	r1, r2, #1
            button->obj.touchMask   = (backToken != NBGL_INVALID_TOKEN) ? (1 << TOUCHED) : 0;
c0de44de:	f886 a01d 	strb.w	sl, [r6, #29]
            layoutInt->headerContainer->nbChildren++;
c0de44e2:	f880 1020 	strb.w	r1, [r0, #32]
            if (text != NULL) {
c0de44e6:	f000 8103 	beq.w	c0de46f0 <nbgl_layoutAddHeader+0x542>
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de44ea:	f89b 0000 	ldrb.w	r0, [fp]
c0de44ee:	2500      	movs	r5, #0
c0de44f0:	2802      	cmp	r0, #2
c0de44f2:	d12f      	bne.n	c0de4554 <nbgl_layoutAddHeader+0x3a6>
                    image         = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de44f4:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de44f8:	08c1      	lsrs	r1, r0, #3
c0de44fa:	2002      	movs	r0, #2
c0de44fc:	f003 fe0b 	bl	c0de8116 <nbgl_objPoolGet>
                    image->buffer = PIC(headerDesc->backAndText.icon);
c0de4500:	f8db 1004 	ldr.w	r1, [fp, #4]
                    image         = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de4504:	4607      	mov	r7, r0
                    image->buffer = PIC(headerDesc->backAndText.icon);
c0de4506:	4608      	mov	r0, r1
c0de4508:	f004 fcf8 	bl	c0de8efc <pic>
c0de450c:	4639      	mov	r1, r7
c0de450e:	f801 0f21 	strb.w	r0, [r1, #33]!
c0de4512:	0e02      	lsrs	r2, r0, #24
c0de4514:	0c03      	lsrs	r3, r0, #16
c0de4516:	0a00      	lsrs	r0, r0, #8
c0de4518:	708b      	strb	r3, [r1, #2]
c0de451a:	f887 0022 	strb.w	r0, [r7, #34]	@ 0x22
                    layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de451e:	68e0      	ldr	r0, [r4, #12]
                    image->buffer = PIC(headerDesc->backAndText.icon);
c0de4520:	70ca      	strb	r2, [r1, #3]
                    layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4522:	f810 1f22 	ldrb.w	r1, [r0, #34]!
                    image->foregroundColor = BLACK;
c0de4526:	77fd      	strb	r5, [r7, #31]
                    layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4528:	f810 cc02 	ldrb.w	ip, [r0, #-2]
c0de452c:	7843      	ldrb	r3, [r0, #1]
c0de452e:	7882      	ldrb	r2, [r0, #2]
c0de4530:	78c0      	ldrb	r0, [r0, #3]
c0de4532:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de4536:	ea42 2000 	orr.w	r0, r2, r0, lsl #8
c0de453a:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
                        = (nbgl_obj_t *) image;
c0de453e:	f840 702c 	str.w	r7, [r0, ip, lsl #2]
                    layoutInt->headerContainer->nbChildren++;
c0de4542:	68e0      	ldr	r0, [r4, #12]
c0de4544:	2105      	movs	r1, #5
c0de4546:	f890 2020 	ldrb.w	r2, [r0, #32]
                    image->obj.alignment   = CENTER;
c0de454a:	75b9      	strb	r1, [r7, #22]
                    layoutInt->headerContainer->nbChildren++;
c0de454c:	1c51      	adds	r1, r2, #1
c0de454e:	463d      	mov	r5, r7
c0de4550:	f880 1020 	strb.w	r1, [r0, #32]
                textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de4554:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de4558:	08c1      	lsrs	r1, r0, #3
c0de455a:	2004      	movs	r0, #4
c0de455c:	f003 fddb 	bl	c0de8116 <nbgl_objPoolGet>
                if ((headerDesc->type == HEADER_EXTENDED_BACK)
c0de4560:	f89b 1000 	ldrb.w	r1, [fp]
                textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de4564:	4682      	mov	sl, r0
                    && (headerDesc->extendedBack.textToken != NBGL_INVALID_TOKEN)) {
c0de4566:	2905      	cmp	r1, #5
c0de4568:	d112      	bne.n	c0de4590 <nbgl_layoutAddHeader+0x3e2>
c0de456a:	f89b 2010 	ldrb.w	r2, [fp, #16]
                if ((headerDesc->type == HEADER_EXTENDED_BACK)
c0de456e:	2aff      	cmp	r2, #255	@ 0xff
c0de4570:	d00e      	beq.n	c0de4590 <nbgl_layoutAddHeader+0x3e2>
                                               headerDesc->extendedBack.tuneId);
c0de4572:	f89b 3013 	ldrb.w	r3, [fp, #19]
                    obj = layoutAddCallbackObj(layoutInt,
c0de4576:	4620      	mov	r0, r4
c0de4578:	4651      	mov	r1, sl
c0de457a:	f7fc f97d 	bl	c0de0878 <layoutAddCallbackObj>
                    if (obj == NULL) {
c0de457e:	2800      	cmp	r0, #0
c0de4580:	f000 8125 	beq.w	c0de47ce <nbgl_layoutAddHeader+0x620>
c0de4584:	2000      	movs	r0, #0
                    textArea->obj.touchMask = (1 << TOUCHED);
c0de4586:	f88a 001d 	strb.w	r0, [sl, #29]
c0de458a:	2001      	movs	r0, #1
c0de458c:	f88a 001c 	strb.w	r0, [sl, #28]
                    = layoutInt->headerContainer->obj.area.width - 2 * BACK_KEY_WIDTH;
c0de4590:	68e0      	ldr	r0, [r4, #12]
c0de4592:	f04f 0c05 	mov.w	ip, #5
c0de4596:	7901      	ldrb	r1, [r0, #4]
c0de4598:	7942      	ldrb	r2, [r0, #5]
c0de459a:	f04f 0e00 	mov.w	lr, #0
c0de459e:	ea41 2202 	orr.w	r2, r1, r2, lsl #8
c0de45a2:	f1a2 03d0 	sub.w	r3, r2, #208	@ 0xd0
c0de45a6:	f88a 3004 	strb.w	r3, [sl, #4]
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de45aa:	f89b 1000 	ldrb.w	r1, [fp]
                    = layoutInt->headerContainer->obj.area.width - 2 * BACK_KEY_WIDTH;
c0de45ae:	0a1b      	lsrs	r3, r3, #8
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de45b0:	2902      	cmp	r1, #2
                textArea->obj.alignment = CENTER;
c0de45b2:	f88a c016 	strb.w	ip, [sl, #22]
                textArea->textColor     = BLACK;
c0de45b6:	f88a e01f 	strb.w	lr, [sl, #31]
                    = layoutInt->headerContainer->obj.area.width - 2 * BACK_KEY_WIDTH;
c0de45ba:	f88a 3005 	strb.w	r3, [sl, #5]
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de45be:	d116      	bne.n	c0de45ee <nbgl_layoutAddHeader+0x440>
                    textArea->obj.area.width -= 16 + image->buffer->width;
c0de45c0:	462b      	mov	r3, r5
c0de45c2:	f813 7f21 	ldrb.w	r7, [r3, #33]!
c0de45c6:	7858      	ldrb	r0, [r3, #1]
c0de45c8:	7899      	ldrb	r1, [r3, #2]
c0de45ca:	78db      	ldrb	r3, [r3, #3]
c0de45cc:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de45d0:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de45d4:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de45d8:	7801      	ldrb	r1, [r0, #0]
c0de45da:	7840      	ldrb	r0, [r0, #1]
c0de45dc:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de45e0:	1a10      	subs	r0, r2, r0
c0de45e2:	38e0      	subs	r0, #224	@ 0xe0
c0de45e4:	f88a 0004 	strb.w	r0, [sl, #4]
c0de45e8:	0a00      	lsrs	r0, r0, #8
c0de45ea:	f88a 0005 	strb.w	r0, [sl, #5]
                textArea->text            = text;
c0de45ee:	4650      	mov	r0, sl
c0de45f0:	f800 8f26 	strb.w	r8, [r0, #38]!
c0de45f4:	2160      	movs	r1, #96	@ 0x60
                textArea->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de45f6:	f800 1c20 	strb.w	r1, [r0, #-32]
                textArea->text            = text;
c0de45fa:	ea4f 6118 	mov.w	r1, r8, lsr #24
c0de45fe:	70c1      	strb	r1, [r0, #3]
c0de4600:	ea4f 4118 	mov.w	r1, r8, lsr #16
c0de4604:	7081      	strb	r1, [r0, #2]
c0de4606:	ea4f 2118 	mov.w	r1, r8, lsr #8
c0de460a:	7041      	strb	r1, [r0, #1]
c0de460c:	210c      	movs	r1, #12
                textArea->wrapping        = true;
c0de460e:	f810 2c02 	ldrb.w	r2, [r0, #-2]
                textArea->fontId          = SMALL_BOLD_FONT;
c0de4612:	f800 1c04 	strb.w	r1, [r0, #-4]
                                               textArea->obj.area.width,
c0de4616:	f810 1c22 	ldrb.w	r1, [r0, #-34]
c0de461a:	f810 3c21 	ldrb.w	r3, [r0, #-33]
                textArea->wrapping        = true;
c0de461e:	f042 0201 	orr.w	r2, r2, #1
                textArea->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de4622:	f800 ec1f 	strb.w	lr, [r0, #-31]
                textArea->textAlignment   = CENTER;
c0de4626:	f800 cc06 	strb.w	ip, [r0, #-6]
                textArea->wrapping        = true;
c0de462a:	f800 2c02 	strb.w	r2, [r0, #-2]
                                               textArea->obj.area.width,
c0de462e:	ea41 2203 	orr.w	r2, r1, r3, lsl #8
                if (nbgl_getTextNbLinesInWidth(textArea->fontId,
c0de4632:	200c      	movs	r0, #12
c0de4634:	4641      	mov	r1, r8
c0de4636:	2301      	movs	r3, #1
c0de4638:	f003 fd8b 	bl	c0de8152 <nbgl_getTextNbLinesInWidth>
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de463c:	f89b 0000 	ldrb.w	r0, [fp]
c0de4640:	2802      	cmp	r0, #2
c0de4642:	d114      	bne.n	c0de466e <nbgl_layoutAddHeader+0x4c0>
                    textArea->obj.area.width = nbgl_getTextWidth(textArea->fontId, textArea->text);
c0de4644:	4657      	mov	r7, sl
c0de4646:	f817 cf26 	ldrb.w	ip, [r7, #38]!
c0de464a:	787a      	ldrb	r2, [r7, #1]
c0de464c:	78bb      	ldrb	r3, [r7, #2]
c0de464e:	78f9      	ldrb	r1, [r7, #3]
c0de4650:	f817 0c04 	ldrb.w	r0, [r7, #-4]
c0de4654:	ea4c 2202 	orr.w	r2, ip, r2, lsl #8
c0de4658:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de465c:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de4660:	f003 fd7c 	bl	c0de815c <nbgl_getTextWidth>
c0de4664:	f807 0c22 	strb.w	r0, [r7, #-34]
c0de4668:	0a00      	lsrs	r0, r0, #8
c0de466a:	f807 0c21 	strb.w	r0, [r7, #-33]
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de466e:	68e0      	ldr	r0, [r4, #12]
c0de4670:	f810 1f22 	ldrb.w	r1, [r0, #34]!
c0de4674:	f810 2c02 	ldrb.w	r2, [r0, #-2]
c0de4678:	7843      	ldrb	r3, [r0, #1]
c0de467a:	7887      	ldrb	r7, [r0, #2]
c0de467c:	78c0      	ldrb	r0, [r0, #3]
c0de467e:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de4682:	ea47 2000 	orr.w	r0, r7, r0, lsl #8
c0de4686:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
                    = (nbgl_obj_t *) textArea;
c0de468a:	f840 a022 	str.w	sl, [r0, r2, lsl #2]
                layoutInt->headerContainer->nbChildren++;
c0de468e:	68e0      	ldr	r0, [r4, #12]
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de4690:	f89b 2000 	ldrb.w	r2, [fp]
                layoutInt->headerContainer->nbChildren++;
c0de4694:	f890 1020 	ldrb.w	r1, [r0, #32]
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de4698:	2a02      	cmp	r2, #2
                layoutInt->headerContainer->nbChildren++;
c0de469a:	f101 0101 	add.w	r1, r1, #1
c0de469e:	f880 1020 	strb.w	r1, [r0, #32]
                if (headerDesc->type == HEADER_BACK_ICON_AND_TEXT) {
c0de46a2:	d125      	bne.n	c0de46f0 <nbgl_layoutAddHeader+0x542>
                    textArea->obj.alignmentMarginX = 8 + image->buffer->width / 2;
c0de46a4:	f815 0f21 	ldrb.w	r0, [r5, #33]!
c0de46a8:	7869      	ldrb	r1, [r5, #1]
c0de46aa:	78aa      	ldrb	r2, [r5, #2]
c0de46ac:	78eb      	ldrb	r3, [r5, #3]
c0de46ae:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de46b2:	ea42 2103 	orr.w	r1, r2, r3, lsl #8
c0de46b6:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de46ba:	7801      	ldrb	r1, [r0, #0]
c0de46bc:	7840      	ldrb	r0, [r0, #1]
                    image->obj.alignmentMarginX    = -8 - textArea->obj.area.width / 2;
c0de46be:	f89a 2005 	ldrb.w	r2, [sl, #5]
                    textArea->obj.alignmentMarginX = 8 + image->buffer->width / 2;
c0de46c2:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de46c6:	2108      	movs	r1, #8
c0de46c8:	eb01 0050 	add.w	r0, r1, r0, lsr #1
                    image->obj.alignmentMarginX    = -8 - textArea->obj.area.width / 2;
c0de46cc:	f89a 1004 	ldrb.w	r1, [sl, #4]
                    textArea->obj.alignmentMarginX = 8 + image->buffer->width / 2;
c0de46d0:	f88a 0017 	strb.w	r0, [sl, #23]
c0de46d4:	0a00      	lsrs	r0, r0, #8
c0de46d6:	f88a 0018 	strb.w	r0, [sl, #24]
                    image->obj.alignmentMarginX    = -8 - textArea->obj.area.width / 2;
c0de46da:	ea41 2002 	orr.w	r0, r1, r2, lsl #8
c0de46de:	f06f 0107 	mvn.w	r1, #7
c0de46e2:	eba1 0050 	sub.w	r0, r1, r0, lsr #1
c0de46e6:	f805 0c0a 	strb.w	r0, [r5, #-10]
c0de46ea:	0a00      	lsrs	r0, r0, #8
c0de46ec:	f805 0c09 	strb.w	r0, [r5, #-9]
            if ((headerDesc->type == HEADER_EXTENDED_BACK)
c0de46f0:	f89b 0000 	ldrb.w	r0, [fp]
c0de46f4:	2500      	movs	r5, #0
                && (headerDesc->extendedBack.actionIcon)) {
c0de46f6:	2805      	cmp	r0, #5
c0de46f8:	f04f 0800 	mov.w	r8, #0
c0de46fc:	d16d      	bne.n	c0de47da <nbgl_layoutAddHeader+0x62c>
c0de46fe:	f8db 0004 	ldr.w	r0, [fp, #4]
            if ((headerDesc->type == HEADER_EXTENDED_BACK)
c0de4702:	2800      	cmp	r0, #0
c0de4704:	d067      	beq.n	c0de47d6 <nbgl_layoutAddHeader+0x628>
                actionButton = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de4706:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de470a:	08c1      	lsrs	r1, r0, #3
c0de470c:	2005      	movs	r0, #5
c0de470e:	f003 fd02 	bl	c0de8116 <nbgl_objPoolGet>
                if (headerDesc->extendedBack.actionToken != NBGL_INVALID_TOKEN) {
c0de4712:	f89b 2012 	ldrb.w	r2, [fp, #18]
                actionButton = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de4716:	4680      	mov	r8, r0
                if (headerDesc->extendedBack.actionToken != NBGL_INVALID_TOKEN) {
c0de4718:	2aff      	cmp	r2, #255	@ 0xff
c0de471a:	d00d      	beq.n	c0de4738 <nbgl_layoutAddHeader+0x58a>
                                               headerDesc->extendedBack.tuneId);
c0de471c:	f89b 3013 	ldrb.w	r3, [fp, #19]
                    obj = layoutAddCallbackObj(layoutInt,
c0de4720:	4620      	mov	r0, r4
c0de4722:	4641      	mov	r1, r8
c0de4724:	f7fc f8a8 	bl	c0de0878 <layoutAddCallbackObj>
                    if (obj == NULL) {
c0de4728:	2800      	cmp	r0, #0
c0de472a:	d050      	beq.n	c0de47ce <nbgl_layoutAddHeader+0x620>
c0de472c:	2000      	movs	r0, #0
                    actionButton->obj.touchMask = (1 << TOUCHED);
c0de472e:	f888 001d 	strb.w	r0, [r8, #29]
c0de4732:	2001      	movs	r0, #1
c0de4734:	f888 001c 	strb.w	r0, [r8, #28]
c0de4738:	2006      	movs	r0, #6
                actionButton->obj.alignment = MID_RIGHT;
c0de473a:	f888 0016 	strb.w	r0, [r8, #22]
c0de473e:	2003      	movs	r0, #3
                actionButton->innerColor    = WHITE;
c0de4740:	f888 001f 	strb.w	r0, [r8, #31]
                    = (headerDesc->extendedBack.actionToken != NBGL_INVALID_TOKEN) ? BLACK
c0de4744:	f89b 1012 	ldrb.w	r1, [fp, #18]
                actionButton->borderColor     = WHITE;
c0de4748:	f888 0020 	strb.w	r0, [r8, #32]
                    = (headerDesc->extendedBack.actionToken != NBGL_INVALID_TOKEN) ? BLACK
c0de474c:	39ff      	subs	r1, #255	@ 0xff
c0de474e:	fab1 f181 	clz	r1, r1
c0de4752:	0949      	lsrs	r1, r1, #5
c0de4754:	0049      	lsls	r1, r1, #1
c0de4756:	f886 1021 	strb.w	r1, [r6, #33]	@ 0x21
c0de475a:	2168      	movs	r1, #104	@ 0x68
                actionButton->obj.area.width  = BACK_KEY_WIDTH;
c0de475c:	f888 1004 	strb.w	r1, [r8, #4]
c0de4760:	2160      	movs	r1, #96	@ 0x60
c0de4762:	2000      	movs	r0, #0
                actionButton->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de4764:	f888 1006 	strb.w	r1, [r8, #6]
                actionButton->text            = NULL;
c0de4768:	4641      	mov	r1, r8
c0de476a:	f801 0f25 	strb.w	r0, [r1, #37]!
                actionButton->obj.area.width  = BACK_KEY_WIDTH;
c0de476e:	f888 0005 	strb.w	r0, [r8, #5]
                actionButton->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de4772:	f888 0007 	strb.w	r0, [r8, #7]
                actionButton->text            = NULL;
c0de4776:	f888 0026 	strb.w	r0, [r8, #38]	@ 0x26
c0de477a:	70c8      	strb	r0, [r1, #3]
c0de477c:	7088      	strb	r0, [r1, #2]
                actionButton->icon            = PIC(headerDesc->extendedBack.actionIcon);
c0de477e:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de4782:	f004 fbbb 	bl	c0de8efc <pic>
c0de4786:	4641      	mov	r1, r8
c0de4788:	f801 0f2e 	strb.w	r0, [r1, #46]!
c0de478c:	0c02      	lsrs	r2, r0, #16
c0de478e:	708a      	strb	r2, [r1, #2]
c0de4790:	0a02      	lsrs	r2, r0, #8
c0de4792:	f888 202f 	strb.w	r2, [r8, #47]	@ 0x2f
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4796:	68e2      	ldr	r2, [r4, #12]
                actionButton->icon            = PIC(headerDesc->extendedBack.actionIcon);
c0de4798:	0e00      	lsrs	r0, r0, #24
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de479a:	f812 3f22 	ldrb.w	r3, [r2, #34]!
                actionButton->icon            = PIC(headerDesc->extendedBack.actionIcon);
c0de479e:	70c8      	strb	r0, [r1, #3]
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de47a0:	f812 0c02 	ldrb.w	r0, [r2, #-2]
c0de47a4:	7851      	ldrb	r1, [r2, #1]
c0de47a6:	7897      	ldrb	r7, [r2, #2]
c0de47a8:	78d2      	ldrb	r2, [r2, #3]
c0de47aa:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de47ae:	ea47 2202 	orr.w	r2, r7, r2, lsl #8
c0de47b2:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
                    = (nbgl_obj_t *) actionButton;
c0de47b6:	f841 8020 	str.w	r8, [r1, r0, lsl #2]
                layoutInt->headerContainer->nbChildren++;
c0de47ba:	68e0      	ldr	r0, [r4, #12]
c0de47bc:	2108      	movs	r1, #8
c0de47be:	f890 2020 	ldrb.w	r2, [r0, #32]
                actionButton->obj.touchId     = EXTRA_BUTTON_ID;
c0de47c2:	f888 101e 	strb.w	r1, [r8, #30]
                layoutInt->headerContainer->nbChildren++;
c0de47c6:	1c51      	adds	r1, r2, #1
c0de47c8:	f880 1020 	strb.w	r1, [r0, #32]
c0de47cc:	e005      	b.n	c0de47da <nbgl_layoutAddHeader+0x62c>
c0de47ce:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
}
c0de47d2:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de47d6:	f04f 0800 	mov.w	r8, #0
            layoutInt->headerContainer->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de47da:	68e0      	ldr	r0, [r4, #12]
c0de47dc:	2160      	movs	r1, #96	@ 0x60
c0de47de:	7181      	strb	r1, [r0, #6]
            if ((headerDesc->type == HEADER_EXTENDED_BACK)
c0de47e0:	f89b 1000 	ldrb.w	r1, [fp]
            layoutInt->headerContainer->obj.area.height = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de47e4:	71c5      	strb	r5, [r0, #7]
                && (headerDesc->extendedBack.subText != NULL)) {
c0de47e6:	2905      	cmp	r1, #5
c0de47e8:	f040 80bf 	bne.w	c0de496a <nbgl_layoutAddHeader+0x7bc>
c0de47ec:	f8db 000c 	ldr.w	r0, [fp, #12]
            if ((headerDesc->type == HEADER_EXTENDED_BACK)
c0de47f0:	2800      	cmp	r0, #0
c0de47f2:	f000 80ba 	beq.w	c0de496a <nbgl_layoutAddHeader+0x7bc>
                line                       = createHorizontalLine(layoutInt->layer);
c0de47f6:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de47fa:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de47fc:	2003      	movs	r0, #3
c0de47fe:	f003 fc8a 	bl	c0de8116 <nbgl_objPoolGet>
c0de4802:	22e0      	movs	r2, #224	@ 0xe0
c0de4804:	2501      	movs	r5, #1
    line->obj.area.width  = SCREEN_WIDTH;
c0de4806:	7102      	strb	r2, [r0, #4]
c0de4808:	2260      	movs	r2, #96	@ 0x60
    line->obj.area.height = 1;
c0de480a:	7185      	strb	r5, [r0, #6]
                line->obj.alignmentMarginY = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de480c:	7642      	strb	r2, [r0, #25]
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de480e:	68e2      	ldr	r2, [r4, #12]
c0de4810:	2100      	movs	r1, #0
c0de4812:	f812 3f22 	ldrb.w	r3, [r2, #34]!
    line->obj.area.height = 1;
c0de4816:	71c1      	strb	r1, [r0, #7]
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4818:	7857      	ldrb	r7, [r2, #1]
c0de481a:	7891      	ldrb	r1, [r2, #2]
c0de481c:	ea43 2307 	orr.w	r3, r3, r7, lsl #8
c0de4820:	78d7      	ldrb	r7, [r2, #3]
c0de4822:	f812 2c02 	ldrb.w	r2, [r2, #-2]
c0de4826:	ea41 2107 	orr.w	r1, r1, r7, lsl #8
c0de482a:	ea43 4101 	orr.w	r1, r3, r1, lsl #16
                    = (nbgl_obj_t *) line;
c0de482e:	f841 0022 	str.w	r0, [r1, r2, lsl #2]
                layoutInt->headerContainer->nbChildren++;
c0de4832:	68e1      	ldr	r1, [r4, #12]
c0de4834:	f04f 0c02 	mov.w	ip, #2
c0de4838:	f891 2020 	ldrb.w	r2, [r1, #32]
c0de483c:	f04f 0e00 	mov.w	lr, #0
    line->lineColor       = LIGHT_GRAY;
c0de4840:	f880 c020 	strb.w	ip, [r0, #32]
    line->obj.area.width  = SCREEN_WIDTH;
c0de4844:	7145      	strb	r5, [r0, #5]
    line->direction       = HORIZONTAL;
c0de4846:	77c5      	strb	r5, [r0, #31]
    line->thickness       = 1;
c0de4848:	f880 5021 	strb.w	r5, [r0, #33]	@ 0x21
                line->obj.alignment        = TOP_MIDDLE;
c0de484c:	f880 c016 	strb.w	ip, [r0, #22]
                line->obj.alignmentMarginY = TOUCHABLE_HEADER_BAR_HEIGHT;
c0de4850:	f880 e01a 	strb.w	lr, [r0, #26]
                layoutInt->headerContainer->nbChildren++;
c0de4854:	1c50      	adds	r0, r2, #1
c0de4856:	f881 0020 	strb.w	r0, [r1, #32]
                subTextArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de485a:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de485e:	08c1      	lsrs	r1, r0, #3
c0de4860:	2004      	movs	r0, #4
c0de4862:	f003 fc58 	bl	c0de8116 <nbgl_objPoolGet>
c0de4866:	4607      	mov	r7, r0
                subTextArea->textColor            = BLACK;
c0de4868:	2000      	movs	r0, #0
c0de486a:	77f8      	strb	r0, [r7, #31]
                subTextArea->text                 = PIC(headerDesc->extendedBack.subText);
c0de486c:	f8db 000c 	ldr.w	r0, [fp, #12]
c0de4870:	f004 fb44 	bl	c0de8efc <pic>
c0de4874:	4601      	mov	r1, r0
c0de4876:	4638      	mov	r0, r7
c0de4878:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de487c:	0e0a      	lsrs	r2, r1, #24
c0de487e:	70c2      	strb	r2, [r0, #3]
c0de4880:	0c0a      	lsrs	r2, r1, #16
c0de4882:	7082      	strb	r2, [r0, #2]
c0de4884:	0a08      	lsrs	r0, r1, #8
c0de4886:	f887 0027 	strb.w	r0, [r7, #39]	@ 0x27
                subTextArea->textAlignment        = MID_LEFT;
c0de488a:	2004      	movs	r0, #4
                subTextArea->wrapping             = true;
c0de488c:	f897 2024 	ldrb.w	r2, [r7, #36]	@ 0x24
                subTextArea->textAlignment        = MID_LEFT;
c0de4890:	f887 0020 	strb.w	r0, [r7, #32]
c0de4894:	200b      	movs	r0, #11
                subTextArea->fontId               = SMALL_REGULAR_FONT;
c0de4896:	f887 0022 	strb.w	r0, [r7, #34]	@ 0x22
                subTextArea->wrapping             = true;
c0de489a:	f042 0001 	orr.w	r0, r2, #1
c0de489e:	f887 0024 	strb.w	r0, [r7, #36]	@ 0x24
c0de48a2:	2008      	movs	r0, #8
                subTextArea->obj.alignment        = BOTTOM_MIDDLE;
c0de48a4:	75b8      	strb	r0, [r7, #22]
                subTextArea->obj.alignmentMarginY = SUB_HEADER_MARGIN;
c0de48a6:	2000      	movs	r0, #0
c0de48a8:	76b8      	strb	r0, [r7, #26]
c0de48aa:	201c      	movs	r0, #28
c0de48ac:	7678      	strb	r0, [r7, #25]
c0de48ae:	20a0      	movs	r0, #160	@ 0xa0
                subTextArea->obj.area.width       = AVAILABLE_WIDTH;
c0de48b0:	7138      	strb	r0, [r7, #4]
                    = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de48b2:	200b      	movs	r0, #11
c0de48b4:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de48b8:	2301      	movs	r3, #1
                subTextArea->obj.area.width       = AVAILABLE_WIDTH;
c0de48ba:	717d      	strb	r5, [r7, #5]
                    = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de48bc:	f003 fc44 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de48c0:	71b8      	strb	r0, [r7, #6]
                layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de48c2:	68e1      	ldr	r1, [r4, #12]
c0de48c4:	f811 ef22 	ldrb.w	lr, [r1, #34]!
c0de48c8:	f811 cc02 	ldrb.w	ip, [r1, #-2]
c0de48cc:	784b      	ldrb	r3, [r1, #1]
c0de48ce:	788a      	ldrb	r2, [r1, #2]
c0de48d0:	78c9      	ldrb	r1, [r1, #3]
c0de48d2:	ea4e 2303 	orr.w	r3, lr, r3, lsl #8
c0de48d6:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de48da:	ea43 4101 	orr.w	r1, r3, r1, lsl #16
                    = (nbgl_obj_t *) subTextArea;
c0de48de:	f841 702c 	str.w	r7, [r1, ip, lsl #2]
                layoutInt->headerContainer->nbChildren++;
c0de48e2:	68e1      	ldr	r1, [r4, #12]
                    = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de48e4:	ea4f 2210 	mov.w	r2, r0, lsr #8
                    += subTextArea->obj.area.height + 2 * SUB_HEADER_MARGIN;
c0de48e8:	f811 3f06 	ldrb.w	r3, [r1, #6]!
                    = nbgl_getTextHeightInWidth(subTextArea->fontId,
c0de48ec:	71fa      	strb	r2, [r7, #7]
                layoutInt->headerContainer->nbChildren++;
c0de48ee:	7e8a      	ldrb	r2, [r1, #26]
                    += subTextArea->obj.area.height + 2 * SUB_HEADER_MARGIN;
c0de48f0:	784f      	ldrb	r7, [r1, #1]
                layoutInt->headerContainer->nbChildren++;
c0de48f2:	f102 0201 	add.w	r2, r2, #1
c0de48f6:	768a      	strb	r2, [r1, #26]
                    += subTextArea->obj.area.height + 2 * SUB_HEADER_MARGIN;
c0de48f8:	ea43 2207 	orr.w	r2, r3, r7, lsl #8
c0de48fc:	4402      	add	r2, r0
c0de48fe:	f102 0238 	add.w	r2, r2, #56	@ 0x38
c0de4902:	700a      	strb	r2, [r1, #0]
c0de4904:	ea4f 2212 	mov.w	r2, r2, lsr #8
c0de4908:	704a      	strb	r2, [r1, #1]
                if (button != NULL) {
c0de490a:	b15e      	cbz	r6, c0de4924 <nbgl_layoutAddHeader+0x776>
                        -= (subTextArea->obj.area.height + 2 * SUB_HEADER_MARGIN) / 2;
c0de490c:	f816 1f19 	ldrb.w	r1, [r6, #25]!
c0de4910:	f100 0338 	add.w	r3, r0, #56	@ 0x38
c0de4914:	7872      	ldrb	r2, [r6, #1]
c0de4916:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de491a:	eba1 0153 	sub.w	r1, r1, r3, lsr #1
c0de491e:	7031      	strb	r1, [r6, #0]
c0de4920:	0a09      	lsrs	r1, r1, #8
c0de4922:	7071      	strb	r1, [r6, #1]
                if (textArea != NULL) {
c0de4924:	f1ba 0f00 	cmp.w	sl, #0
c0de4928:	d00e      	beq.n	c0de4948 <nbgl_layoutAddHeader+0x79a>
                        -= (subTextArea->obj.area.height + 2 * SUB_HEADER_MARGIN) / 2;
c0de492a:	f81a 1f19 	ldrb.w	r1, [sl, #25]!
c0de492e:	f100 0338 	add.w	r3, r0, #56	@ 0x38
c0de4932:	f89a 2001 	ldrb.w	r2, [sl, #1]
c0de4936:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de493a:	eba1 0153 	sub.w	r1, r1, r3, lsr #1
c0de493e:	f88a 1000 	strb.w	r1, [sl]
c0de4942:	0a09      	lsrs	r1, r1, #8
c0de4944:	f88a 1001 	strb.w	r1, [sl, #1]
                if (actionButton != NULL) {
c0de4948:	f1b8 0f00 	cmp.w	r8, #0
c0de494c:	d00d      	beq.n	c0de496a <nbgl_layoutAddHeader+0x7bc>
                        -= (subTextArea->obj.area.height + 2 * SUB_HEADER_MARGIN) / 2;
c0de494e:	f818 1f19 	ldrb.w	r1, [r8, #25]!
c0de4952:	3038      	adds	r0, #56	@ 0x38
c0de4954:	f898 2001 	ldrb.w	r2, [r8, #1]
c0de4958:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de495c:	eba1 0050 	sub.w	r0, r1, r0, lsr #1
c0de4960:	f888 0000 	strb.w	r0, [r8]
c0de4964:	0a00      	lsrs	r0, r0, #8
c0de4966:	f888 0001 	strb.w	r0, [r8, #1]
    if (headerDesc->separationLine) {
c0de496a:	f89b 0001 	ldrb.w	r0, [fp, #1]
c0de496e:	b350      	cbz	r0, c0de49c6 <nbgl_layoutAddHeader+0x818>
        line                = createHorizontalLine(layoutInt->layer);
c0de4970:	f894 00ad 	ldrb.w	r0, [r4, #173]	@ 0xad
c0de4974:	08c1      	lsrs	r1, r0, #3
    line                  = (nbgl_line_t *) nbgl_objPoolGet(LINE, layer);
c0de4976:	2003      	movs	r0, #3
c0de4978:	f003 fbcd 	bl	c0de8116 <nbgl_objPoolGet>
c0de497c:	2102      	movs	r1, #2
    line->lineColor       = LIGHT_GRAY;
c0de497e:	f880 1020 	strb.w	r1, [r0, #32]
c0de4982:	2101      	movs	r1, #1
c0de4984:	22e0      	movs	r2, #224	@ 0xe0
    line->obj.area.width  = SCREEN_WIDTH;
c0de4986:	7102      	strb	r2, [r0, #4]
c0de4988:	2200      	movs	r2, #0
    line->obj.area.height = 1;
c0de498a:	7181      	strb	r1, [r0, #6]
c0de498c:	71c2      	strb	r2, [r0, #7]
        layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de498e:	68e2      	ldr	r2, [r4, #12]
    line->obj.area.width  = SCREEN_WIDTH;
c0de4990:	7141      	strb	r1, [r0, #5]
        layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de4992:	f812 3f22 	ldrb.w	r3, [r2, #34]!
    line->direction       = HORIZONTAL;
c0de4996:	77c1      	strb	r1, [r0, #31]
    line->thickness       = 1;
c0de4998:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
        layoutInt->headerContainer->children[layoutInt->headerContainer->nbChildren]
c0de499c:	f812 1c02 	ldrb.w	r1, [r2, #-2]
c0de49a0:	7857      	ldrb	r7, [r2, #1]
c0de49a2:	7896      	ldrb	r6, [r2, #2]
c0de49a4:	78d2      	ldrb	r2, [r2, #3]
c0de49a6:	ea43 2307 	orr.w	r3, r3, r7, lsl #8
c0de49aa:	ea46 2202 	orr.w	r2, r6, r2, lsl #8
c0de49ae:	ea43 4202 	orr.w	r2, r3, r2, lsl #16
            = (nbgl_obj_t *) line;
c0de49b2:	f842 0021 	str.w	r0, [r2, r1, lsl #2]
        layoutInt->headerContainer->nbChildren++;
c0de49b6:	68e1      	ldr	r1, [r4, #12]
c0de49b8:	2208      	movs	r2, #8
c0de49ba:	f891 3020 	ldrb.w	r3, [r1, #32]
        line->obj.alignment = BOTTOM_MIDDLE;
c0de49be:	7582      	strb	r2, [r0, #22]
        layoutInt->headerContainer->nbChildren++;
c0de49c0:	1c58      	adds	r0, r3, #1
c0de49c2:	f881 0020 	strb.w	r0, [r1, #32]
    layoutInt->children[HEADER_INDEX] = (nbgl_obj_t *) layoutInt->headerContainer;
c0de49c6:	e9d4 0102 	ldrd	r0, r1, [r4, #8]
c0de49ca:	6001      	str	r1, [r0, #0]
    layoutInt->container->obj.area.height -= layoutInt->headerContainer->obj.area.height;
c0de49cc:	68e0      	ldr	r0, [r4, #12]
c0de49ce:	f8d4 30a0 	ldr.w	r3, [r4, #160]	@ 0xa0
c0de49d2:	4601      	mov	r1, r0
c0de49d4:	f811 2f06 	ldrb.w	r2, [r1, #6]!
c0de49d8:	784f      	ldrb	r7, [r1, #1]
    layoutInt->container->obj.alignTo   = (nbgl_obj_t *) layoutInt->headerContainer;
c0de49da:	f803 0f12 	strb.w	r0, [r3, #18]!
    layoutInt->container->obj.area.height -= layoutInt->headerContainer->obj.area.height;
c0de49de:	f813 6d0c 	ldrb.w	r6, [r3, #-12]!
c0de49e2:	ea42 2207 	orr.w	r2, r2, r7, lsl #8
c0de49e6:	785d      	ldrb	r5, [r3, #1]
c0de49e8:	ea46 2705 	orr.w	r7, r6, r5, lsl #8
c0de49ec:	1aba      	subs	r2, r7, r2
c0de49ee:	701a      	strb	r2, [r3, #0]
c0de49f0:	0a12      	lsrs	r2, r2, #8
c0de49f2:	705a      	strb	r2, [r3, #1]
    layoutInt->container->obj.alignTo   = (nbgl_obj_t *) layoutInt->headerContainer;
c0de49f4:	0e02      	lsrs	r2, r0, #24
c0de49f6:	73da      	strb	r2, [r3, #15]
c0de49f8:	0c02      	lsrs	r2, r0, #16
c0de49fa:	0a00      	lsrs	r0, r0, #8
c0de49fc:	739a      	strb	r2, [r3, #14]
c0de49fe:	7358      	strb	r0, [r3, #13]
c0de4a00:	2007      	movs	r0, #7
    layoutInt->container->obj.alignment = BOTTOM_LEFT;
c0de4a02:	7418      	strb	r0, [r3, #16]
    layoutInt->headerType = headerDesc->type;
c0de4a04:	f89b 0000 	ldrb.w	r0, [fp]
    return layoutInt->headerContainer->obj.area.height;
c0de4a08:	780a      	ldrb	r2, [r1, #0]
c0de4a0a:	7849      	ldrb	r1, [r1, #1]
    layoutInt->headerType = headerDesc->type;
c0de4a0c:	f884 00aa 	strb.w	r0, [r4, #170]	@ 0xaa
    return layoutInt->headerContainer->obj.area.height;
c0de4a10:	ea42 2001 	orr.w	r0, r2, r1, lsl #8
}
c0de4a14:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de4a18 <nbgl_layoutAddProgressIndicator>:
                                    uint8_t        activePage,
                                    uint8_t        nbPages,
                                    bool           withBack,
                                    uint8_t        backToken,
                                    tune_index_e   tuneId)
{
c0de4a18:	b510      	push	{r4, lr}
c0de4a1a:	b086      	sub	sp, #24
c0de4a1c:	e9dd ec08 	ldrd	lr, ip, [sp, #32]
c0de4a20:	2403      	movs	r4, #3
    nbgl_layoutHeader_t headerDesc = {.type                        = HEADER_BACK_AND_PROGRESS,
                                      .separationLine              = false,
                                      .progressAndBack.activePage  = activePage,
c0de4a22:	f88d 100c 	strb.w	r1, [sp, #12]
c0de4a26:	21ff      	movs	r1, #255	@ 0xff
    nbgl_layoutHeader_t headerDesc = {.type                        = HEADER_BACK_AND_PROGRESS,
c0de4a28:	f8ad 4004 	strh.w	r4, [sp, #4]
c0de4a2c:	2400      	movs	r4, #0
                                      .progressAndBack.activePage  = activePage,
c0de4a2e:	f88d 1010 	strb.w	r1, [sp, #16]
c0de4a32:	a901      	add	r1, sp, #4
c0de4a34:	9402      	str	r4, [sp, #8]
c0de4a36:	f88d 200d 	strb.w	r2, [sp, #13]
c0de4a3a:	f88d 300e 	strb.w	r3, [sp, #14]
c0de4a3e:	f88d e00f 	strb.w	lr, [sp, #15]
c0de4a42:	f88d c011 	strb.w	ip, [sp, #17]
                                      .progressAndBack.withBack    = withBack,
                                      .progressAndBack.actionIcon  = NULL,
                                      .progressAndBack.actionToken = NBGL_INVALID_TOKEN};
    LOG_DEBUG(LAYOUT_LOGGER, "nbgl_layoutAddProgressIndicator():\n");

    return nbgl_layoutAddHeader(layout, &headerDesc);
c0de4a46:	f7ff fbb2 	bl	c0de41ae <nbgl_layoutAddHeader>
c0de4a4a:	b006      	add	sp, #24
c0de4a4c:	bd10      	pop	{r4, pc}

c0de4a4e <nbgl_layoutDraw>:
 */
int nbgl_layoutDraw(nbgl_layout_t *layoutParam)
{
    nbgl_layoutInternal_t *layout = (nbgl_layoutInternal_t *) layoutParam;

    if (layout == NULL) {
c0de4a4e:	2800      	cmp	r0, #0
c0de4a50:	bf04      	itt	eq
c0de4a52:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
    }
#endif  // TARGET_STAX
    nbgl_screenRedraw();

    return 0;
}
c0de4a56:	4770      	bxeq	lr
c0de4a58:	b510      	push	{r4, lr}
    if (layout->tapText) {
c0de4a5a:	6981      	ldr	r1, [r0, #24]
c0de4a5c:	b1b9      	cbz	r1, c0de4a8e <nbgl_layoutDraw+0x40>
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de4a5e:	f8d0 20a0 	ldr.w	r2, [r0, #160]	@ 0xa0
    layout->container->children[layout->container->nbChildren] = obj;
c0de4a62:	f812 ef22 	ldrb.w	lr, [r2, #34]!
    if (layout->container->nbChildren == NB_MAX_CONTAINER_CHILDREN) {
c0de4a66:	f812 cc02 	ldrb.w	ip, [r2, #-2]
    layout->container->children[layout->container->nbChildren] = obj;
c0de4a6a:	7853      	ldrb	r3, [r2, #1]
c0de4a6c:	7894      	ldrb	r4, [r2, #2]
c0de4a6e:	78d2      	ldrb	r2, [r2, #3]
c0de4a70:	ea4e 2303 	orr.w	r3, lr, r3, lsl #8
c0de4a74:	ea44 2202 	orr.w	r2, r4, r2, lsl #8
c0de4a78:	ea43 4202 	orr.w	r2, r3, r2, lsl #16
c0de4a7c:	f842 102c 	str.w	r1, [r2, ip, lsl #2]
    layout->container->nbChildren++;
c0de4a80:	f8d0 00a0 	ldr.w	r0, [r0, #160]	@ 0xa0
c0de4a84:	f890 1020 	ldrb.w	r1, [r0, #32]
c0de4a88:	3101      	adds	r1, #1
c0de4a8a:	f880 1020 	strb.w	r1, [r0, #32]
    nbgl_screenRedraw();
c0de4a8e:	f003 fb2e 	bl	c0de80ee <nbgl_screenRedraw>
c0de4a92:	2000      	movs	r0, #0
c0de4a94:	bd10      	pop	{r4, pc}

c0de4a96 <nbgl_layoutRelease>:
 *
 * @param layoutParam layout to release
 * @return >= 0 if OK
 */
int nbgl_layoutRelease(nbgl_layout_t *layoutParam)
{
c0de4a96:	b510      	push	{r4, lr}
    nbgl_layoutInternal_t *layout = (nbgl_layoutInternal_t *) layoutParam;
    LOG_DEBUG(PAGE_LOGGER, "nbgl_layoutRelease(): \n");
    if ((layout == NULL) || (!layout->isUsed)) {
c0de4a98:	b140      	cbz	r0, c0de4aac <nbgl_layoutRelease+0x16>
c0de4a9a:	4604      	mov	r4, r0
c0de4a9c:	f890 00ad 	ldrb.w	r0, [r0, #173]	@ 0xad
c0de4aa0:	f894 10ae 	ldrb.w	r1, [r4, #174]	@ 0xae
c0de4aa4:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de4aa8:	0441      	lsls	r1, r0, #17
c0de4aaa:	d402      	bmi.n	c0de4ab2 <nbgl_layoutRelease+0x1c>
c0de4aac:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
            layout->top->bottom = layout->bottom;
        }
    }
    layout->isUsed = false;
    return 0;
}
c0de4ab0:	bd10      	pop	{r4, pc}
    if (layout->modal) {
c0de4ab2:	07c1      	lsls	r1, r0, #31
c0de4ab4:	d016      	beq.n	c0de4ae4 <nbgl_layoutRelease+0x4e>
        nbgl_screenPop(layout->layer);
c0de4ab6:	b2c0      	uxtb	r0, r0
c0de4ab8:	08c0      	lsrs	r0, r0, #3
c0de4aba:	f003 fb1d 	bl	c0de80f8 <nbgl_screenPop>
        if (layout == topLayout) {
c0de4abe:	f240 4050 	movw	r0, #1104	@ 0x450
c0de4ac2:	f2c0 0000 	movt	r0, #0
c0de4ac6:	f859 1000 	ldr.w	r1, [r9, r0]
c0de4aca:	42a1      	cmp	r1, r4
c0de4acc:	d005      	beq.n	c0de4ada <nbgl_layoutRelease+0x44>
            layout->bottom->top = layout->top;
c0de4ace:	e9d4 0100 	ldrd	r0, r1, [r4]
c0de4ad2:	6008      	str	r0, [r1, #0]
            layout->top->bottom = layout->bottom;
c0de4ad4:	6820      	ldr	r0, [r4, #0]
c0de4ad6:	6041      	str	r1, [r0, #4]
c0de4ad8:	e004      	b.n	c0de4ae4 <nbgl_layoutRelease+0x4e>
            topLayout      = layout->bottom;
c0de4ada:	6861      	ldr	r1, [r4, #4]
c0de4adc:	f849 1000 	str.w	r1, [r9, r0]
c0de4ae0:	2000      	movs	r0, #0
            topLayout->top = NULL;
c0de4ae2:	6008      	str	r0, [r1, #0]
    layout->isUsed = false;
c0de4ae4:	f814 0fad 	ldrb.w	r0, [r4, #173]!
c0de4ae8:	7861      	ldrb	r1, [r4, #1]
c0de4aea:	7020      	strb	r0, [r4, #0]
c0de4aec:	f001 01bf 	and.w	r1, r1, #191	@ 0xbf
c0de4af0:	2000      	movs	r0, #0
c0de4af2:	7061      	strb	r1, [r4, #1]
}
c0de4af4:	bd10      	pop	{r4, pc}
	...

c0de4af8 <animTickerCallback>:
{
c0de4af8:	b570      	push	{r4, r5, r6, lr}
    nbgl_layoutInternal_t *layout = topLayout;
c0de4afa:	f240 4050 	movw	r0, #1104	@ 0x450
c0de4afe:	f2c0 0000 	movt	r0, #0
c0de4b02:	f859 6000 	ldr.w	r6, [r9, r0]
    if (!layout || !layout->isUsed || (layout->animation == NULL)) {
c0de4b06:	2e00      	cmp	r6, #0
c0de4b08:	d04b      	beq.n	c0de4ba2 <animTickerCallback+0xaa>
c0de4b0a:	f896 00ae 	ldrb.w	r0, [r6, #174]	@ 0xae
c0de4b0e:	0200      	lsls	r0, r0, #8
c0de4b10:	0440      	lsls	r0, r0, #17
c0de4b12:	d546      	bpl.n	c0de4ba2 <animTickerCallback+0xaa>
c0de4b14:	f8d6 00a4 	ldr.w	r0, [r6, #164]	@ 0xa4
c0de4b18:	2800      	cmp	r0, #0
c0de4b1a:	d042      	beq.n	c0de4ba2 <animTickerCallback+0xaa>
c0de4b1c:	f8d6 00a0 	ldr.w	r0, [r6, #160]	@ 0xa0
c0de4b20:	f890 2020 	ldrb.w	r2, [r0, #32]
    while (i < layout->container->nbChildren) {
c0de4b24:	2a00      	cmp	r2, #0
}
c0de4b26:	bf08      	it	eq
c0de4b28:	bd70      	popeq	{r4, r5, r6, pc}
c0de4b2a:	f810 cf22 	ldrb.w	ip, [r0, #34]!
c0de4b2e:	7843      	ldrb	r3, [r0, #1]
c0de4b30:	f890 e002 	ldrb.w	lr, [r0, #2]
c0de4b34:	78c0      	ldrb	r0, [r0, #3]
c0de4b36:	ea4c 2303 	orr.w	r3, ip, r3, lsl #8
c0de4b3a:	ea4e 2000 	orr.w	r0, lr, r0, lsl #8
c0de4b3e:	ea43 4300 	orr.w	r3, r3, r0, lsl #16
c0de4b42:	e003      	b.n	c0de4b4c <animTickerCallback+0x54>
    while (i < layout->container->nbChildren) {
c0de4b44:	3a01      	subs	r2, #1
c0de4b46:	f103 0304 	add.w	r3, r3, #4
c0de4b4a:	d02a      	beq.n	c0de4ba2 <animTickerCallback+0xaa>
        if (layout->container->children[i]->type == CONTAINER) {
c0de4b4c:	6818      	ldr	r0, [r3, #0]
c0de4b4e:	7ec1      	ldrb	r1, [r0, #27]
c0de4b50:	2901      	cmp	r1, #1
c0de4b52:	d1f7      	bne.n	c0de4b44 <animTickerCallback+0x4c>
            if (container->children[1]->type == IMAGE) {
c0de4b54:	f810 1f22 	ldrb.w	r1, [r0, #34]!
c0de4b58:	7844      	ldrb	r4, [r0, #1]
c0de4b5a:	7885      	ldrb	r5, [r0, #2]
c0de4b5c:	78c0      	ldrb	r0, [r0, #3]
c0de4b5e:	ea41 2104 	orr.w	r1, r1, r4, lsl #8
c0de4b62:	ea45 2000 	orr.w	r0, r5, r0, lsl #8
c0de4b66:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de4b6a:	6840      	ldr	r0, [r0, #4]
c0de4b6c:	7ec1      	ldrb	r1, [r0, #27]
c0de4b6e:	2902      	cmp	r1, #2
c0de4b70:	d1e8      	bne.n	c0de4b44 <animTickerCallback+0x4c>
                if (layout->animation->parsing == LOOP_PARSING) {
c0de4b72:	f8d6 30a4 	ldr.w	r3, [r6, #164]	@ 0xa4
c0de4b76:	7959      	ldrb	r1, [r3, #5]
c0de4b78:	b1a1      	cbz	r1, c0de4ba4 <animTickerCallback+0xac>
                    if ((layout->incrementAnim)
c0de4b7a:	f896 10ad 	ldrb.w	r1, [r6, #173]	@ 0xad
c0de4b7e:	f896 20ae 	ldrb.w	r2, [r6, #174]	@ 0xae
c0de4b82:	ea41 2202 	orr.w	r2, r1, r2, lsl #8
                        && (layout->iconIdxInAnim >= layout->animation->nbIcons - 1)) {
c0de4b86:	0751      	lsls	r1, r2, #29
c0de4b88:	d505      	bpl.n	c0de4b96 <animTickerCallback+0x9e>
c0de4b8a:	7919      	ldrb	r1, [r3, #4]
c0de4b8c:	f896 30af 	ldrb.w	r3, [r6, #175]	@ 0xaf
c0de4b90:	3901      	subs	r1, #1
                    if ((layout->incrementAnim)
c0de4b92:	4299      	cmp	r1, r3
c0de4b94:	dd0e      	ble.n	c0de4bb4 <animTickerCallback+0xbc>
                    else if (layout->iconIdxInAnim == 0) {
c0de4b96:	f896 10af 	ldrb.w	r1, [r6, #175]	@ 0xaf
c0de4b9a:	b991      	cbnz	r1, c0de4bc2 <animTickerCallback+0xca>
                        layout->incrementAnim = true;
c0de4b9c:	f042 0204 	orr.w	r2, r2, #4
c0de4ba0:	e00a      	b.n	c0de4bb8 <animTickerCallback+0xc0>
}
c0de4ba2:	bd70      	pop	{r4, r5, r6, pc}
                    if (layout->iconIdxInAnim == (layout->animation->nbIcons - 1)) {
c0de4ba4:	7919      	ldrb	r1, [r3, #4]
c0de4ba6:	f896 20af 	ldrb.w	r2, [r6, #175]	@ 0xaf
c0de4baa:	3901      	subs	r1, #1
c0de4bac:	4291      	cmp	r1, r2
c0de4bae:	d110      	bne.n	c0de4bd2 <animTickerCallback+0xda>
c0de4bb0:	2100      	movs	r1, #0
c0de4bb2:	e00f      	b.n	c0de4bd4 <animTickerCallback+0xdc>
                        layout->incrementAnim = false;
c0de4bb4:	f022 0204 	bic.w	r2, r2, #4
c0de4bb8:	0a11      	lsrs	r1, r2, #8
c0de4bba:	f886 20ad 	strb.w	r2, [r6, #173]	@ 0xad
c0de4bbe:	f886 10ae 	strb.w	r1, [r6, #174]	@ 0xae
                    if (layout->incrementAnim) {
c0de4bc2:	f896 10ad 	ldrb.w	r1, [r6, #173]	@ 0xad
c0de4bc6:	f896 20af 	ldrb.w	r2, [r6, #175]	@ 0xaf
c0de4bca:	0749      	lsls	r1, r1, #29
c0de4bcc:	d401      	bmi.n	c0de4bd2 <animTickerCallback+0xda>
                        layout->iconIdxInAnim--;
c0de4bce:	1e51      	subs	r1, r2, #1
c0de4bd0:	e000      	b.n	c0de4bd4 <animTickerCallback+0xdc>
c0de4bd2:	1c51      	adds	r1, r2, #1
c0de4bd4:	f886 10af 	strb.w	r1, [r6, #175]	@ 0xaf
                image->buffer = layout->animation->icons[layout->iconIdxInAnim];
c0de4bd8:	f8d6 10a4 	ldr.w	r1, [r6, #164]	@ 0xa4
c0de4bdc:	f896 20af 	ldrb.w	r2, [r6, #175]	@ 0xaf
c0de4be0:	6809      	ldr	r1, [r1, #0]
c0de4be2:	f851 1022 	ldr.w	r1, [r1, r2, lsl #2]
c0de4be6:	4602      	mov	r2, r0
c0de4be8:	f802 1f21 	strb.w	r1, [r2, #33]!
c0de4bec:	0e0b      	lsrs	r3, r1, #24
c0de4bee:	70d3      	strb	r3, [r2, #3]
c0de4bf0:	0c0b      	lsrs	r3, r1, #16
c0de4bf2:	0a09      	lsrs	r1, r1, #8
c0de4bf4:	7093      	strb	r3, [r2, #2]
c0de4bf6:	f880 1022 	strb.w	r1, [r0, #34]	@ 0x22
                nbgl_objDraw((nbgl_obj_t *) image);
c0de4bfa:	f003 fa64 	bl	c0de80c6 <nbgl_objDraw>
                nbgl_refreshSpecialWithPostRefresh(BLACK_AND_WHITE_FAST_REFRESH,
c0de4bfe:	2004      	movs	r0, #4
c0de4c00:	2101      	movs	r1, #1
c0de4c02:	f003 fa56 	bl	c0de80b2 <nbgl_refreshSpecialWithPostRefresh>
}
c0de4c06:	bd70      	pop	{r4, r5, r6, pc}

c0de4c08 <layoutNavigationCallback>:
 */
bool layoutNavigationCallback(nbgl_obj_t      *obj,
                              nbgl_touchType_t eventType,
                              uint8_t          nbPages,
                              uint8_t         *activePage)
{
c0de4c08:	b5b0      	push	{r4, r5, r7, lr}
    // if direct touch of buttons within the navigation bar, the given obj is
    // the touched object
    if (eventType == TOUCHED) {
c0de4c0a:	2909      	cmp	r1, #9
c0de4c0c:	d054      	beq.n	c0de4cb8 <layoutNavigationCallback+0xb0>
c0de4c0e:	2900      	cmp	r1, #0
c0de4c10:	d174      	bne.n	c0de4cfc <layoutNavigationCallback+0xf4>
        nbgl_container_t *navContainer = (nbgl_container_t *) obj->parent;
c0de4c12:	4601      	mov	r1, r0
c0de4c14:	f811 cf0e 	ldrb.w	ip, [r1, #14]!
c0de4c18:	f890 e00f 	ldrb.w	lr, [r0, #15]
c0de4c1c:	788d      	ldrb	r5, [r1, #2]
c0de4c1e:	78c9      	ldrb	r1, [r1, #3]
c0de4c20:	ea4c 240e 	orr.w	r4, ip, lr, lsl #8
c0de4c24:	ea45 2101 	orr.w	r1, r5, r1, lsl #8
c0de4c28:	ea44 4c01 	orr.w	ip, r4, r1, lsl #16

        if (obj == navContainer->children[EXIT_BUTTON_INDEX]) {
c0de4c2c:	4661      	mov	r1, ip
c0de4c2e:	f811 ef22 	ldrb.w	lr, [r1, #34]!
c0de4c32:	f89c 4023 	ldrb.w	r4, [ip, #35]	@ 0x23
c0de4c36:	788d      	ldrb	r5, [r1, #2]
c0de4c38:	78c9      	ldrb	r1, [r1, #3]
c0de4c3a:	ea4e 2404 	orr.w	r4, lr, r4, lsl #8
c0de4c3e:	ea45 2101 	orr.w	r1, r5, r1, lsl #8
c0de4c42:	ea44 4e01 	orr.w	lr, r4, r1, lsl #16
c0de4c46:	f8de 1000 	ldr.w	r1, [lr]
c0de4c4a:	4281      	cmp	r1, r0
c0de4c4c:	d07e      	beq.n	c0de4d4c <layoutNavigationCallback+0x144>
            // fake page when Quit button is touched
            *activePage = EXIT_PAGE;
            return true;
        }
        else if (obj == navContainer->children[PREVIOUS_PAGE_INDEX]) {
c0de4c4e:	f8de 1004 	ldr.w	r1, [lr, #4]
c0de4c52:	4281      	cmp	r1, r0
c0de4c54:	f000 8083 	beq.w	c0de4d5e <layoutNavigationCallback+0x156>
                *activePage = *activePage - 1;
                configButtons(navContainer, nbPages, *activePage);
                return true;
            }
        }
        else if (obj == navContainer->children[NEXT_PAGE_INDEX]) {
c0de4c58:	2a02      	cmp	r2, #2
c0de4c5a:	f04f 0100 	mov.w	r1, #0
c0de4c5e:	d37c      	bcc.n	c0de4d5a <layoutNavigationCallback+0x152>
c0de4c60:	f8de 5008 	ldr.w	r5, [lr, #8]
c0de4c64:	4285      	cmp	r5, r0
c0de4c66:	d178      	bne.n	c0de4d5a <layoutNavigationCallback+0x152>
            if ((nbPages >= 2) && (*activePage < (nbPages - 1))) {
c0de4c68:	7819      	ldrb	r1, [r3, #0]
c0de4c6a:	1e50      	subs	r0, r2, #1
c0de4c6c:	4288      	cmp	r0, r1
c0de4c6e:	f340 80a0 	ble.w	c0de4db2 <layoutNavigationCallback+0x1aa>
                *activePage = *activePage + 1;
c0de4c72:	3101      	adds	r1, #1
c0de4c74:	7019      	strb	r1, [r3, #0]
    nbgl_button_t *buttonPrevious = (nbgl_button_t *) navContainer->children[PREVIOUS_PAGE_INDEX];
c0de4c76:	f81c 2f22 	ldrb.w	r2, [ip, #34]!
c0de4c7a:	f89c 3001 	ldrb.w	r3, [ip, #1]
c0de4c7e:	f89c 5002 	ldrb.w	r5, [ip, #2]
c0de4c82:	f89c 4003 	ldrb.w	r4, [ip, #3]
c0de4c86:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de4c8a:	ea45 2304 	orr.w	r3, r5, r4, lsl #8
c0de4c8e:	ea42 4203 	orr.w	r2, r2, r3, lsl #16
c0de4c92:	e9d2 3201 	ldrd	r3, r2, [r2, #4]
    if (buttonPrevious) {
c0de4c96:	b133      	cbz	r3, c0de4ca6 <layoutNavigationCallback+0x9e>
        buttonPrevious->foregroundColor = (navActivePage == 0) ? INACTIVE_COLOR : BLACK;
c0de4c98:	b2cd      	uxtb	r5, r1
c0de4c9a:	fab5 f585 	clz	r5, r5
c0de4c9e:	096d      	lsrs	r5, r5, #5
c0de4ca0:	006d      	lsls	r5, r5, #1
c0de4ca2:	f883 5021 	strb.w	r5, [r3, #33]	@ 0x21
        buttonNext->foregroundColor = (navActivePage == (navNbPages - 1)) ? INACTIVE_COLOR : BLACK;
c0de4ca6:	b2c9      	uxtb	r1, r1
c0de4ca8:	1a40      	subs	r0, r0, r1
c0de4caa:	fab0 f080 	clz	r0, r0
c0de4cae:	0940      	lsrs	r0, r0, #5
c0de4cb0:	0040      	lsls	r0, r0, #1
c0de4cb2:	f882 0021 	strb.w	r0, [r2, #33]	@ 0x21
c0de4cb6:	e04f      	b.n	c0de4d58 <layoutNavigationCallback+0x150>
            }
        }
    }
    // otherwise the given object is the navigation container itself
    else if (eventType == SWIPED_RIGHT) {
        if (*activePage > 0) {
c0de4cb8:	7819      	ldrb	r1, [r3, #0]
c0de4cba:	2900      	cmp	r1, #0
c0de4cbc:	d079      	beq.n	c0de4db2 <layoutNavigationCallback+0x1aa>
            *activePage = *activePage - 1;
c0de4cbe:	3901      	subs	r1, #1
c0de4cc0:	7019      	strb	r1, [r3, #0]
    nbgl_button_t *buttonPrevious = (nbgl_button_t *) navContainer->children[PREVIOUS_PAGE_INDEX];
c0de4cc2:	f810 3f22 	ldrb.w	r3, [r0, #34]!
c0de4cc6:	7845      	ldrb	r5, [r0, #1]
c0de4cc8:	7884      	ldrb	r4, [r0, #2]
c0de4cca:	78c0      	ldrb	r0, [r0, #3]
c0de4ccc:	ea43 2305 	orr.w	r3, r3, r5, lsl #8
c0de4cd0:	ea44 2000 	orr.w	r0, r4, r0, lsl #8
c0de4cd4:	ea43 4000 	orr.w	r0, r3, r0, lsl #16
c0de4cd8:	e9d0 3001 	ldrd	r3, r0, [r0, #4]
    if (buttonPrevious) {
c0de4cdc:	b133      	cbz	r3, c0de4cec <layoutNavigationCallback+0xe4>
        buttonPrevious->foregroundColor = (navActivePage == 0) ? INACTIVE_COLOR : BLACK;
c0de4cde:	b2cd      	uxtb	r5, r1
c0de4ce0:	fab5 f585 	clz	r5, r5
c0de4ce4:	096d      	lsrs	r5, r5, #5
c0de4ce6:	006d      	lsls	r5, r5, #1
c0de4ce8:	f883 5021 	strb.w	r5, [r3, #33]	@ 0x21
    if (navNbPages > 1) {
c0de4cec:	2a02      	cmp	r2, #2
c0de4cee:	d330      	bcc.n	c0de4d52 <layoutNavigationCallback+0x14a>
c0de4cf0:	f06f 03ff 	mvn.w	r3, #255	@ 0xff
        buttonNext->foregroundColor = (navActivePage == (navNbPages - 1)) ? INACTIVE_COLOR : BLACK;
c0de4cf4:	ea63 0101 	orn	r1, r3, r1
c0de4cf8:	4411      	add	r1, r2
c0de4cfa:	e022      	b.n	c0de4d42 <layoutNavigationCallback+0x13a>
            configButtons((nbgl_container_t *) obj, nbPages, *activePage);
            return true;
        }
    }
    else if (eventType == SWIPED_LEFT) {
c0de4cfc:	290a      	cmp	r1, #10
c0de4cfe:	f04f 0100 	mov.w	r1, #0
c0de4d02:	d12a      	bne.n	c0de4d5a <layoutNavigationCallback+0x152>
c0de4d04:	2a02      	cmp	r2, #2
c0de4d06:	d328      	bcc.n	c0de4d5a <layoutNavigationCallback+0x152>
        if ((nbPages >= 2) && (*activePage < (nbPages - 1))) {
c0de4d08:	7819      	ldrb	r1, [r3, #0]
c0de4d0a:	3a01      	subs	r2, #1
c0de4d0c:	428a      	cmp	r2, r1
c0de4d0e:	dd50      	ble.n	c0de4db2 <layoutNavigationCallback+0x1aa>
            *activePage = *activePage + 1;
c0de4d10:	3101      	adds	r1, #1
c0de4d12:	7019      	strb	r1, [r3, #0]
    nbgl_button_t *buttonPrevious = (nbgl_button_t *) navContainer->children[PREVIOUS_PAGE_INDEX];
c0de4d14:	f810 3f22 	ldrb.w	r3, [r0, #34]!
c0de4d18:	7845      	ldrb	r5, [r0, #1]
c0de4d1a:	7884      	ldrb	r4, [r0, #2]
c0de4d1c:	78c0      	ldrb	r0, [r0, #3]
c0de4d1e:	ea43 2305 	orr.w	r3, r3, r5, lsl #8
c0de4d22:	ea44 2000 	orr.w	r0, r4, r0, lsl #8
c0de4d26:	ea43 4000 	orr.w	r0, r3, r0, lsl #16
c0de4d2a:	e9d0 3001 	ldrd	r3, r0, [r0, #4]
    if (buttonPrevious) {
c0de4d2e:	b133      	cbz	r3, c0de4d3e <layoutNavigationCallback+0x136>
        buttonPrevious->foregroundColor = (navActivePage == 0) ? INACTIVE_COLOR : BLACK;
c0de4d30:	b2cd      	uxtb	r5, r1
c0de4d32:	fab5 f585 	clz	r5, r5
c0de4d36:	096d      	lsrs	r5, r5, #5
c0de4d38:	006d      	lsls	r5, r5, #1
c0de4d3a:	f883 5021 	strb.w	r5, [r3, #33]	@ 0x21
        buttonNext->foregroundColor = (navActivePage == (navNbPages - 1)) ? INACTIVE_COLOR : BLACK;
c0de4d3e:	b2c9      	uxtb	r1, r1
c0de4d40:	1a51      	subs	r1, r2, r1
c0de4d42:	fab1 f181 	clz	r1, r1
c0de4d46:	0949      	lsrs	r1, r1, #5
c0de4d48:	0049      	lsls	r1, r1, #1
c0de4d4a:	e003      	b.n	c0de4d54 <layoutNavigationCallback+0x14c>
c0de4d4c:	20ff      	movs	r0, #255	@ 0xff
            *activePage = EXIT_PAGE;
c0de4d4e:	7018      	strb	r0, [r3, #0]
c0de4d50:	e002      	b.n	c0de4d58 <layoutNavigationCallback+0x150>
c0de4d52:	2102      	movs	r1, #2
c0de4d54:	f880 1021 	strb.w	r1, [r0, #33]	@ 0x21
c0de4d58:	2101      	movs	r1, #1
            configButtons((nbgl_container_t *) obj, nbPages, *activePage);
            return true;
        }
    }
    return false;
}
c0de4d5a:	4608      	mov	r0, r1
c0de4d5c:	bdb0      	pop	{r4, r5, r7, pc}
            if (*activePage > 0) {
c0de4d5e:	7818      	ldrb	r0, [r3, #0]
c0de4d60:	b338      	cbz	r0, c0de4db2 <layoutNavigationCallback+0x1aa>
                *activePage = *activePage - 1;
c0de4d62:	3801      	subs	r0, #1
c0de4d64:	7018      	strb	r0, [r3, #0]
    nbgl_button_t *buttonPrevious = (nbgl_button_t *) navContainer->children[PREVIOUS_PAGE_INDEX];
c0de4d66:	f81c 1f22 	ldrb.w	r1, [ip, #34]!
c0de4d6a:	f89c 3001 	ldrb.w	r3, [ip, #1]
c0de4d6e:	f89c 5002 	ldrb.w	r5, [ip, #2]
c0de4d72:	f89c 4003 	ldrb.w	r4, [ip, #3]
c0de4d76:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de4d7a:	ea45 2304 	orr.w	r3, r5, r4, lsl #8
c0de4d7e:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
c0de4d82:	e9d1 3101 	ldrd	r3, r1, [r1, #4]
    if (buttonPrevious) {
c0de4d86:	b133      	cbz	r3, c0de4d96 <layoutNavigationCallback+0x18e>
        buttonPrevious->foregroundColor = (navActivePage == 0) ? INACTIVE_COLOR : BLACK;
c0de4d88:	b2c5      	uxtb	r5, r0
c0de4d8a:	fab5 f585 	clz	r5, r5
c0de4d8e:	096d      	lsrs	r5, r5, #5
c0de4d90:	006d      	lsls	r5, r5, #1
c0de4d92:	f883 5021 	strb.w	r5, [r3, #33]	@ 0x21
    if (navNbPages > 1) {
c0de4d96:	2a02      	cmp	r2, #2
c0de4d98:	d30d      	bcc.n	c0de4db6 <layoutNavigationCallback+0x1ae>
c0de4d9a:	f06f 03ff 	mvn.w	r3, #255	@ 0xff
        buttonNext->foregroundColor = (navActivePage == (navNbPages - 1)) ? INACTIVE_COLOR : BLACK;
c0de4d9e:	ea63 0000 	orn	r0, r3, r0
c0de4da2:	4410      	add	r0, r2
c0de4da4:	fab0 f080 	clz	r0, r0
c0de4da8:	0940      	lsrs	r0, r0, #5
c0de4daa:	0040      	lsls	r0, r0, #1
c0de4dac:	f881 0021 	strb.w	r0, [r1, #33]	@ 0x21
c0de4db0:	e7d2      	b.n	c0de4d58 <layoutNavigationCallback+0x150>
c0de4db2:	2000      	movs	r0, #0
}
c0de4db4:	bdb0      	pop	{r4, r5, r7, pc}
c0de4db6:	2002      	movs	r0, #2
c0de4db8:	f881 0021 	strb.w	r0, [r1, #33]	@ 0x21
c0de4dbc:	e7cc      	b.n	c0de4d58 <layoutNavigationCallback+0x150>

c0de4dbe <layoutNavigationPopulate>:
 *
 */
void layoutNavigationPopulate(nbgl_container_t                 *navContainer,
                              const nbgl_layoutNavigationBar_t *navConfig,
                              uint8_t                           layer)
{
c0de4dbe:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de4dc2:	b082      	sub	sp, #8
c0de4dc4:	460c      	mov	r4, r1
    nbgl_button_t *button;

    if (navConfig->withExitKey) {
c0de4dc6:	78c9      	ldrb	r1, [r1, #3]
c0de4dc8:	4690      	mov	r8, r2
c0de4dca:	4605      	mov	r5, r0
c0de4dcc:	b3e9      	cbz	r1, c0de4e4a <layoutNavigationPopulate+0x8c>
        button                  = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layer);
c0de4dce:	2005      	movs	r0, #5
c0de4dd0:	4641      	mov	r1, r8
c0de4dd2:	2705      	movs	r7, #5
c0de4dd4:	f003 f99f 	bl	c0de8116 <nbgl_objPoolGet>
c0de4dd8:	2103      	movs	r1, #3
c0de4dda:	2258      	movs	r2, #88	@ 0x58
        button->innerColor      = WHITE;
c0de4ddc:	77c1      	strb	r1, [r0, #31]
        button->borderColor     = BORDER_COLOR;
c0de4dde:	f880 1020 	strb.w	r1, [r0, #32]
c0de4de2:	2100      	movs	r1, #0
        button->obj.area.width  = BUTTON_DIAMETER;
c0de4de4:	7102      	strb	r2, [r0, #4]
        button->obj.area.height = BUTTON_DIAMETER;
c0de4de6:	7182      	strb	r2, [r0, #6]
c0de4de8:	2204      	movs	r2, #4
        button->obj.area.width  = BUTTON_DIAMETER;
c0de4dea:	7141      	strb	r1, [r0, #5]
        button->obj.area.height = BUTTON_DIAMETER;
c0de4dec:	71c1      	strb	r1, [r0, #7]
        button->radius          = BUTTON_RADIUS;
c0de4dee:	f880 2022 	strb.w	r2, [r0, #34]	@ 0x22
        button->icon            = &CLOSE_ICON;
c0de4df2:	f644 6246 	movw	r2, #20038	@ 0x4e46
c0de4df6:	f2c0 0200 	movt	r2, #0
c0de4dfa:	447a      	add	r2, pc
c0de4dfc:	0a13      	lsrs	r3, r2, #8
c0de4dfe:	f880 302f 	strb.w	r3, [r0, #47]	@ 0x2f
c0de4e02:	4603      	mov	r3, r0
c0de4e04:	f803 2f2e 	strb.w	r2, [r3, #46]!
c0de4e08:	0e16      	lsrs	r6, r2, #24
c0de4e0a:	0c12      	lsrs	r2, r2, #16
c0de4e0c:	709a      	strb	r2, [r3, #2]
#ifdef TARGET_FLEX
        button->obj.alignmentMarginX = (navConfig->nbPages > 1) ? 8 : 0;
c0de4e0e:	7862      	ldrb	r2, [r4, #1]
        button->icon            = &CLOSE_ICON;
c0de4e10:	70de      	strb	r6, [r3, #3]
        button->obj.alignmentMarginX = (navConfig->nbPages > 1) ? 8 : 0;
c0de4e12:	2a01      	cmp	r2, #1
c0de4e14:	f04f 0200 	mov.w	r2, #0
#endif  // TARGET_STAX

        button->obj.alignment                     = (navConfig->nbPages > 1) ? MID_LEFT : CENTER;
c0de4e18:	bf88      	it	hi
c0de4e1a:	2704      	movhi	r7, #4
        button->obj.alignmentMarginX = (navConfig->nbPages > 1) ? 8 : 0;
c0de4e1c:	bf88      	it	hi
c0de4e1e:	2201      	movhi	r2, #1
c0de4e20:	00d2      	lsls	r2, r2, #3
c0de4e22:	7601      	strb	r1, [r0, #24]
        button->obj.touchMask                     = (1 << TOUCHED);
c0de4e24:	7741      	strb	r1, [r0, #29]
c0de4e26:	2101      	movs	r1, #1
        button->obj.alignmentMarginX = (navConfig->nbPages > 1) ? 8 : 0;
c0de4e28:	75c2      	strb	r2, [r0, #23]
        button->obj.touchMask                     = (1 << TOUCHED);
c0de4e2a:	7701      	strb	r1, [r0, #28]
        button->obj.touchId                       = BOTTOM_BUTTON_ID;
        navContainer->children[EXIT_BUTTON_INDEX] = (nbgl_obj_t *) button;
c0de4e2c:	462a      	mov	r2, r5
c0de4e2e:	f812 3f22 	ldrb.w	r3, [r2, #34]!
        button->obj.alignment                     = (navConfig->nbPages > 1) ? MID_LEFT : CENTER;
c0de4e32:	7587      	strb	r7, [r0, #22]
        button->obj.touchId                       = BOTTOM_BUTTON_ID;
c0de4e34:	7781      	strb	r1, [r0, #30]
        navContainer->children[EXIT_BUTTON_INDEX] = (nbgl_obj_t *) button;
c0de4e36:	7851      	ldrb	r1, [r2, #1]
c0de4e38:	7897      	ldrb	r7, [r2, #2]
c0de4e3a:	78d2      	ldrb	r2, [r2, #3]
c0de4e3c:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de4e40:	ea47 2202 	orr.w	r2, r7, r2, lsl #8
c0de4e44:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de4e48:	6008      	str	r0, [r1, #0]
    }
    // create previous page button (back)
    if (navConfig->withBackKey) {
c0de4e4a:	7920      	ldrb	r0, [r4, #4]
c0de4e4c:	b3b0      	cbz	r0, c0de4ebc <layoutNavigationPopulate+0xfe>
        button                  = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layer);
c0de4e4e:	2005      	movs	r0, #5
c0de4e50:	4641      	mov	r1, r8
c0de4e52:	f003 f960 	bl	c0de8116 <nbgl_objPoolGet>
c0de4e56:	2103      	movs	r1, #3
c0de4e58:	2360      	movs	r3, #96	@ 0x60
        button->innerColor      = WHITE;
c0de4e5a:	77c1      	strb	r1, [r0, #31]
        button->borderColor     = BORDER_COLOR;
c0de4e5c:	f880 1020 	strb.w	r1, [r0, #32]
c0de4e60:	2100      	movs	r1, #0
c0de4e62:	2268      	movs	r2, #104	@ 0x68
        button->obj.area.width  = NAV_BUTTON_WIDTH;
        button->obj.area.height = NAV_BUTTON_HEIGHT;
c0de4e64:	7183      	strb	r3, [r0, #6]
c0de4e66:	2304      	movs	r3, #4
        button->obj.area.width  = NAV_BUTTON_WIDTH;
c0de4e68:	7141      	strb	r1, [r0, #5]
c0de4e6a:	7102      	strb	r2, [r0, #4]
        button->obj.area.height = NAV_BUTTON_HEIGHT;
c0de4e6c:	71c1      	strb	r1, [r0, #7]
        button->radius          = BUTTON_RADIUS;
c0de4e6e:	f880 3022 	strb.w	r3, [r0, #34]	@ 0x22
        button->icon            = &CHEVRON_BACK_ICON;
c0de4e72:	f644 43ac 	movw	r3, #19628	@ 0x4cac
c0de4e76:	f2c0 0300 	movt	r3, #0
c0de4e7a:	447b      	add	r3, pc
c0de4e7c:	0a1f      	lsrs	r7, r3, #8
c0de4e7e:	f880 702f 	strb.w	r7, [r0, #47]	@ 0x2f
c0de4e82:	4607      	mov	r7, r0
c0de4e84:	f807 3f2e 	strb.w	r3, [r7, #46]!
c0de4e88:	0e1e      	lsrs	r6, r3, #24
c0de4e8a:	0c1b      	lsrs	r3, r3, #16
        // align on the right of the container, leaving space for "Next" button
        button->obj.alignment                       = MID_RIGHT;
        button->obj.alignmentMarginX                = NAV_BUTTON_WIDTH;
c0de4e8c:	7601      	strb	r1, [r0, #24]
        button->obj.touchMask                       = (1 << TOUCHED);
c0de4e8e:	7741      	strb	r1, [r0, #29]
c0de4e90:	2101      	movs	r1, #1
        button->icon            = &CHEVRON_BACK_ICON;
c0de4e92:	70bb      	strb	r3, [r7, #2]
c0de4e94:	2306      	movs	r3, #6
        button->obj.alignmentMarginX                = NAV_BUTTON_WIDTH;
c0de4e96:	75c2      	strb	r2, [r0, #23]
        button->obj.touchMask                       = (1 << TOUCHED);
c0de4e98:	7701      	strb	r1, [r0, #28]
        button->obj.touchId                         = LEFT_BUTTON_ID;
        navContainer->children[PREVIOUS_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de4e9a:	462a      	mov	r2, r5
        button->obj.alignment                       = MID_RIGHT;
c0de4e9c:	7583      	strb	r3, [r0, #22]
        navContainer->children[PREVIOUS_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de4e9e:	f812 3f22 	ldrb.w	r3, [r2, #34]!
c0de4ea2:	2102      	movs	r1, #2
        button->icon            = &CHEVRON_BACK_ICON;
c0de4ea4:	70fe      	strb	r6, [r7, #3]
        button->obj.touchId                         = LEFT_BUTTON_ID;
c0de4ea6:	7781      	strb	r1, [r0, #30]
        navContainer->children[PREVIOUS_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de4ea8:	7851      	ldrb	r1, [r2, #1]
c0de4eaa:	7897      	ldrb	r7, [r2, #2]
c0de4eac:	78d2      	ldrb	r2, [r2, #3]
c0de4eae:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de4eb2:	ea47 2202 	orr.w	r2, r7, r2, lsl #8
c0de4eb6:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de4eba:	6048      	str	r0, [r1, #4]
    }

    // create next page button
    button                                  = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layer);
c0de4ebc:	2005      	movs	r0, #5
c0de4ebe:	4641      	mov	r1, r8
c0de4ec0:	f003 f929 	bl	c0de8116 <nbgl_objPoolGet>
c0de4ec4:	2368      	movs	r3, #104	@ 0x68
    button->innerColor                      = WHITE;
    button->borderColor                     = BORDER_COLOR;
    button->foregroundColor                 = BLACK;
    button->obj.area.width                  = NAV_BUTTON_WIDTH;
c0de4ec6:	7103      	strb	r3, [r0, #4]
c0de4ec8:	2360      	movs	r3, #96	@ 0x60
c0de4eca:	2103      	movs	r1, #3
c0de4ecc:	2200      	movs	r2, #0
    button->obj.area.height                 = NAV_BUTTON_HEIGHT;
c0de4ece:	7183      	strb	r3, [r0, #6]
c0de4ed0:	2304      	movs	r3, #4
    button->innerColor                      = WHITE;
c0de4ed2:	77c1      	strb	r1, [r0, #31]
    button->borderColor                     = BORDER_COLOR;
c0de4ed4:	f880 1020 	strb.w	r1, [r0, #32]
    button->foregroundColor                 = BLACK;
c0de4ed8:	f880 2021 	strb.w	r2, [r0, #33]	@ 0x21
    button->obj.area.width                  = NAV_BUTTON_WIDTH;
c0de4edc:	7142      	strb	r2, [r0, #5]
    button->obj.area.height                 = NAV_BUTTON_HEIGHT;
c0de4ede:	71c2      	strb	r2, [r0, #7]
    button->radius                          = BUTTON_RADIUS;
c0de4ee0:	f880 3022 	strb.w	r3, [r0, #34]	@ 0x22
    button->icon                            = &CHEVRON_NEXT_ICON;
c0de4ee4:	f644 47bd 	movw	r7, #19645	@ 0x4cbd
c0de4ee8:	f2c0 0700 	movt	r7, #0
c0de4eec:	447f      	add	r7, pc
c0de4eee:	0a3b      	lsrs	r3, r7, #8
c0de4ef0:	f880 302f 	strb.w	r3, [r0, #47]	@ 0x2f
c0de4ef4:	4603      	mov	r3, r0
c0de4ef6:	f803 7f2e 	strb.w	r7, [r3, #46]!
c0de4efa:	0e3e      	lsrs	r6, r7, #24
c0de4efc:	70de      	strb	r6, [r3, #3]
c0de4efe:	0c3e      	lsrs	r6, r7, #16
    button->obj.alignment                   = MID_RIGHT;
    button->obj.touchMask                   = (1 << TOUCHED);
c0de4f00:	7742      	strb	r2, [r0, #29]
c0de4f02:	2201      	movs	r2, #1
    button->icon                            = &CHEVRON_NEXT_ICON;
c0de4f04:	709e      	strb	r6, [r3, #2]
c0de4f06:	2306      	movs	r3, #6
    button->obj.touchMask                   = (1 << TOUCHED);
c0de4f08:	7702      	strb	r2, [r0, #28]
    button->obj.touchId                     = RIGHT_BUTTON_ID;
    navContainer->children[NEXT_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de4f0a:	462a      	mov	r2, r5
    button->obj.alignment                   = MID_RIGHT;
c0de4f0c:	7583      	strb	r3, [r0, #22]
    navContainer->children[NEXT_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de4f0e:	f812 3f22 	ldrb.w	r3, [r2, #34]!
    button->obj.touchId                     = RIGHT_BUTTON_ID;
c0de4f12:	7781      	strb	r1, [r0, #30]
    navContainer->children[NEXT_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de4f14:	7851      	ldrb	r1, [r2, #1]
c0de4f16:	7896      	ldrb	r6, [r2, #2]
c0de4f18:	78d2      	ldrb	r2, [r2, #3]
c0de4f1a:	ea43 2101 	orr.w	r1, r3, r1, lsl #8

    // potentially create page indicator (with a text area, and "page of nb_page")
    if (navConfig->withPageIndicator) {
c0de4f1e:	79a3      	ldrb	r3, [r4, #6]
    navContainer->children[NEXT_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de4f20:	ea46 2202 	orr.w	r2, r6, r2, lsl #8
c0de4f24:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
    if (navConfig->withPageIndicator) {
c0de4f28:	2b00      	cmp	r3, #0
    navContainer->children[NEXT_PAGE_INDEX] = (nbgl_obj_t *) button;
c0de4f2a:	6088      	str	r0, [r1, #8]
    if (navConfig->withPageIndicator) {
c0de4f2c:	d06d      	beq.n	c0de500a <layoutNavigationPopulate+0x24c>
        if (navConfig->visibleIndicator) {
c0de4f2e:	79e0      	ldrb	r0, [r4, #7]
c0de4f30:	2800      	cmp	r0, #0
c0de4f32:	d052      	beq.n	c0de4fda <layoutNavigationPopulate+0x21c>
            nbgl_text_area_t *textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layer);
c0de4f34:	2004      	movs	r0, #4
c0de4f36:	4641      	mov	r1, r8
c0de4f38:	f003 f8ed 	bl	c0de8116 <nbgl_objPoolGet>
            uint16_t          marginX  = (NAV_BUTTON_WIDTH - CHEVRON_NEXT_ICON.width) / 2;
c0de4f3c:	7839      	ldrb	r1, [r7, #0]
c0de4f3e:	787a      	ldrb	r2, [r7, #1]
            nbgl_text_area_t *textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layer);
c0de4f40:	4606      	mov	r6, r0
            uint16_t          marginX  = (NAV_BUTTON_WIDTH - CHEVRON_NEXT_ICON.width) / 2;
c0de4f42:	ea41 2802 	orr.w	r8, r1, r2, lsl #8
c0de4f46:	f1c8 0068 	rsb	r0, r8, #104	@ 0x68
c0de4f4a:	eb00 7ad0 	add.w	sl, r0, r0, lsr #31

            SPRINTF(navText, "%d of %d", navConfig->activePage + 1, navConfig->nbPages);
c0de4f4e:	78a0      	ldrb	r0, [r4, #2]
c0de4f50:	7861      	ldrb	r1, [r4, #1]
c0de4f52:	1c43      	adds	r3, r0, #1
c0de4f54:	f240 4055 	movw	r0, #1109	@ 0x455
c0de4f58:	9100      	str	r1, [sp, #0]
c0de4f5a:	f2c0 0000 	movt	r0, #0
c0de4f5e:	f245 52af 	movw	r2, #21935	@ 0x55af
c0de4f62:	eb09 0700 	add.w	r7, r9, r0
c0de4f66:	f2c0 0200 	movt	r2, #0
c0de4f6a:	447a      	add	r2, pc
c0de4f6c:	4638      	mov	r0, r7
c0de4f6e:	210b      	movs	r1, #11
c0de4f70:	f04f 0b0b 	mov.w	fp, #11
c0de4f74:	f003 ff7c 	bl	c0de8e70 <snprintf>
            textArea->text                               = navText;
            textArea->fontId                             = SMALL_REGULAR_FONT;
            textArea->obj.area.height                    = NAV_BUTTON_HEIGHT;
            textArea->textAlignment                      = CENTER;
            textArea->obj.alignment                      = CENTER;
            navContainer->children[PAGE_INDICATOR_INDEX] = (nbgl_obj_t *) textArea;
c0de4f78:	4629      	mov	r1, r5
c0de4f7a:	f811 cf22 	ldrb.w	ip, [r1, #34]!
c0de4f7e:	2201      	movs	r2, #1
            textArea->textColor = LIGHT_TEXT_COLOR;
c0de4f80:	77f2      	strb	r2, [r6, #31]
                = navContainer->obj.area.width - (2 * (marginX + CHEVRON_NEXT_ICON.width));
c0de4f82:	f811 2c1e 	ldrb.w	r2, [r1, #-30]
c0de4f86:	f811 3c1d 	ldrb.w	r3, [r1, #-29]
            navContainer->children[PAGE_INDICATOR_INDEX] = (nbgl_obj_t *) textArea;
c0de4f8a:	f891 e001 	ldrb.w	lr, [r1, #1]
                = navContainer->obj.area.width - (2 * (marginX + CHEVRON_NEXT_ICON.width));
c0de4f8e:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de4f92:	eb08 035a 	add.w	r3, r8, sl, lsr #1
c0de4f96:	eba2 0243 	sub.w	r2, r2, r3, lsl #1
            navContainer->children[PAGE_INDICATOR_INDEX] = (nbgl_obj_t *) textArea;
c0de4f9a:	7888      	ldrb	r0, [r1, #2]
                = navContainer->obj.area.width - (2 * (marginX + CHEVRON_NEXT_ICON.width));
c0de4f9c:	7132      	strb	r2, [r6, #4]
c0de4f9e:	0a12      	lsrs	r2, r2, #8
c0de4fa0:	7172      	strb	r2, [r6, #5]
            textArea->text                               = navText;
c0de4fa2:	0a3a      	lsrs	r2, r7, #8
c0de4fa4:	f886 2027 	strb.w	r2, [r6, #39]	@ 0x27
c0de4fa8:	4632      	mov	r2, r6
c0de4faa:	f802 7f26 	strb.w	r7, [r2, #38]!
c0de4fae:	0e3b      	lsrs	r3, r7, #24
c0de4fb0:	70d3      	strb	r3, [r2, #3]
c0de4fb2:	0c3b      	lsrs	r3, r7, #16
c0de4fb4:	7093      	strb	r3, [r2, #2]
c0de4fb6:	2200      	movs	r2, #0
            textArea->obj.area.height                    = NAV_BUTTON_HEIGHT;
c0de4fb8:	71f2      	strb	r2, [r6, #7]
c0de4fba:	2260      	movs	r2, #96	@ 0x60
c0de4fbc:	71b2      	strb	r2, [r6, #6]
            navContainer->children[PAGE_INDICATOR_INDEX] = (nbgl_obj_t *) textArea;
c0de4fbe:	78c9      	ldrb	r1, [r1, #3]
c0de4fc0:	2205      	movs	r2, #5
c0de4fc2:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de4fc6:	ea4c 210e 	orr.w	r1, ip, lr, lsl #8
c0de4fca:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
            textArea->fontId                             = SMALL_REGULAR_FONT;
c0de4fce:	f886 b022 	strb.w	fp, [r6, #34]	@ 0x22
            textArea->textAlignment                      = CENTER;
c0de4fd2:	f886 2020 	strb.w	r2, [r6, #32]
            textArea->obj.alignment                      = CENTER;
c0de4fd6:	75b2      	strb	r2, [r6, #22]
            navContainer->children[PAGE_INDICATOR_INDEX] = (nbgl_obj_t *) textArea;
c0de4fd8:	60c6      	str	r6, [r0, #12]
        }
        if (navConfig->withBackKey) {
c0de4fda:	7920      	ldrb	r0, [r4, #4]
c0de4fdc:	b1a8      	cbz	r0, c0de500a <layoutNavigationPopulate+0x24c>
            navContainer->children[PREVIOUS_PAGE_INDEX]->alignmentMarginX += PAGE_NUMBER_WIDTH;
c0de4fde:	4628      	mov	r0, r5
c0de4fe0:	f810 1f22 	ldrb.w	r1, [r0, #34]!
c0de4fe4:	7842      	ldrb	r2, [r0, #1]
c0de4fe6:	7883      	ldrb	r3, [r0, #2]
c0de4fe8:	78c0      	ldrb	r0, [r0, #3]
c0de4fea:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de4fee:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de4ff2:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de4ff6:	6840      	ldr	r0, [r0, #4]
c0de4ff8:	f810 1f17 	ldrb.w	r1, [r0, #23]!
c0de4ffc:	7842      	ldrb	r2, [r0, #1]
c0de4ffe:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de5002:	314f      	adds	r1, #79	@ 0x4f
c0de5004:	7001      	strb	r1, [r0, #0]
c0de5006:	0a09      	lsrs	r1, r1, #8
c0de5008:	7041      	strb	r1, [r0, #1]
    nbgl_button_t *buttonPrevious = (nbgl_button_t *) navContainer->children[PREVIOUS_PAGE_INDEX];
c0de500a:	f815 1f22 	ldrb.w	r1, [r5, #34]!
        }
    }

    // configure enabling/disabling of button
    configButtons(navContainer, navConfig->nbPages, navConfig->activePage);
c0de500e:	7860      	ldrb	r0, [r4, #1]
    nbgl_button_t *buttonPrevious = (nbgl_button_t *) navContainer->children[PREVIOUS_PAGE_INDEX];
c0de5010:	786b      	ldrb	r3, [r5, #1]
c0de5012:	78af      	ldrb	r7, [r5, #2]
c0de5014:	78ee      	ldrb	r6, [r5, #3]
c0de5016:	ea41 2103 	orr.w	r1, r1, r3, lsl #8
c0de501a:	ea47 2306 	orr.w	r3, r7, r6, lsl #8
c0de501e:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
c0de5022:	e9d1 3101 	ldrd	r3, r1, [r1, #4]
    configButtons(navContainer, navConfig->nbPages, navConfig->activePage);
c0de5026:	78a2      	ldrb	r2, [r4, #2]
    if (buttonPrevious) {
c0de5028:	b12b      	cbz	r3, c0de5036 <layoutNavigationPopulate+0x278>
        buttonPrevious->foregroundColor = (navActivePage == 0) ? INACTIVE_COLOR : BLACK;
c0de502a:	fab2 f782 	clz	r7, r2
c0de502e:	097f      	lsrs	r7, r7, #5
c0de5030:	007f      	lsls	r7, r7, #1
c0de5032:	f883 7021 	strb.w	r7, [r3, #33]	@ 0x21
    if (navNbPages > 1) {
c0de5036:	43d2      	mvns	r2, r2
c0de5038:	4402      	add	r2, r0
c0de503a:	fab2 f282 	clz	r2, r2
c0de503e:	0952      	lsrs	r2, r2, #5
c0de5040:	0052      	lsls	r2, r2, #1
c0de5042:	2802      	cmp	r0, #2
c0de5044:	bf38      	it	cc
c0de5046:	2202      	movcc	r2, #2
c0de5048:	f881 2021 	strb.w	r2, [r1, #33]	@ 0x21

    return;
}
c0de504c:	b002      	add	sp, #8
c0de504e:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de5052 <nbgl_pageDrawInfo>:
 * @return the page context (or NULL if error)
 */
nbgl_page_t *nbgl_pageDrawInfo(nbgl_layoutTouchCallback_t              onActionCallback,
                               const nbgl_screenTickerConfiguration_t *ticker,
                               const nbgl_pageInfoDescription_t       *info)
{
c0de5052:	b570      	push	{r4, r5, r6, lr}
c0de5054:	b08e      	sub	sp, #56	@ 0x38
c0de5056:	4614      	mov	r4, r2

    layoutDescription.modal          = false;
    layoutDescription.withLeftBorder = true;

    layoutDescription.onActionCallback = onActionCallback;
    if (!info->isSwipeable) {
c0de5058:	f894 3024 	ldrb.w	r3, [r4, #36]	@ 0x24
c0de505c:	2200      	movs	r2, #0
    layoutDescription.modal          = false;
c0de505e:	9208      	str	r2, [sp, #32]
c0de5060:	e9cd 2206 	strd	r2, r2, [sp, #24]
c0de5064:	9204      	str	r2, [sp, #16]
c0de5066:	e9cd 2202 	strd	r2, r2, [sp, #8]
c0de506a:	2201      	movs	r2, #1
    layoutDescription.withLeftBorder = true;
c0de506c:	f88d 2009 	strb.w	r2, [sp, #9]
    layoutDescription.onActionCallback = onActionCallback;
c0de5070:	9005      	str	r0, [sp, #20]
    if (!info->isSwipeable) {
c0de5072:	b32b      	cbz	r3, c0de50c0 <nbgl_pageDrawInfo+0x6e>
        layoutDescription.tapActionText  = info->tapActionText;
        layoutDescription.tapActionToken = info->tapActionToken;
        layoutDescription.tapTuneId      = info->tuneId;
    }

    if (ticker != NULL) {
c0de5074:	b381      	cbz	r1, c0de50d8 <nbgl_pageDrawInfo+0x86>
        layoutDescription.ticker.tickerCallback  = ticker->tickerCallback;
c0de5076:	7808      	ldrb	r0, [r1, #0]
c0de5078:	788a      	ldrb	r2, [r1, #2]
c0de507a:	78cb      	ldrb	r3, [r1, #3]
c0de507c:	784d      	ldrb	r5, [r1, #1]
c0de507e:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de5082:	ea40 2005 	orr.w	r0, r0, r5, lsl #8
c0de5086:	ea40 4002 	orr.w	r0, r0, r2, lsl #16
c0de508a:	9006      	str	r0, [sp, #24]
        layoutDescription.ticker.tickerIntervale = ticker->tickerIntervale;
c0de508c:	4608      	mov	r0, r1
c0de508e:	f810 2f08 	ldrb.w	r2, [r0, #8]!
c0de5092:	7a4b      	ldrb	r3, [r1, #9]
c0de5094:	7885      	ldrb	r5, [r0, #2]
c0de5096:	78c0      	ldrb	r0, [r0, #3]
c0de5098:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de509c:	ea45 2000 	orr.w	r0, r5, r0, lsl #8
c0de50a0:	ea42 4000 	orr.w	r0, r2, r0, lsl #16
        layoutDescription.ticker.tickerValue     = ticker->tickerValue;
c0de50a4:	794a      	ldrb	r2, [r1, #5]
c0de50a6:	f811 3f04 	ldrb.w	r3, [r1, #4]!
        layoutDescription.ticker.tickerIntervale = ticker->tickerIntervale;
c0de50aa:	9008      	str	r0, [sp, #32]
        layoutDescription.ticker.tickerValue     = ticker->tickerValue;
c0de50ac:	7888      	ldrb	r0, [r1, #2]
c0de50ae:	78c9      	ldrb	r1, [r1, #3]
c0de50b0:	ea43 2202 	orr.w	r2, r3, r2, lsl #8
c0de50b4:	ea40 2001 	orr.w	r0, r0, r1, lsl #8
c0de50b8:	ea42 4000 	orr.w	r0, r2, r0, lsl #16
c0de50bc:	9007      	str	r0, [sp, #28]
c0de50be:	e00d      	b.n	c0de50dc <nbgl_pageDrawInfo+0x8a>
        layoutDescription.tapActionText  = info->tapActionText;
c0de50c0:	6a20      	ldr	r0, [r4, #32]
        layoutDescription.tapTuneId      = info->tuneId;
c0de50c2:	f894 2031 	ldrb.w	r2, [r4, #49]	@ 0x31
        layoutDescription.tapActionText  = info->tapActionText;
c0de50c6:	9003      	str	r0, [sp, #12]
        layoutDescription.tapActionToken = info->tapActionToken;
c0de50c8:	f894 0025 	ldrb.w	r0, [r4, #37]	@ 0x25
        layoutDescription.tapTuneId      = info->tuneId;
c0de50cc:	f88d 2011 	strb.w	r2, [sp, #17]
        layoutDescription.tapActionToken = info->tapActionToken;
c0de50d0:	f88d 0010 	strb.w	r0, [sp, #16]
    if (ticker != NULL) {
c0de50d4:	2900      	cmp	r1, #0
c0de50d6:	d1ce      	bne.n	c0de5076 <nbgl_pageDrawInfo+0x24>
c0de50d8:	2000      	movs	r0, #0
    }
    else {
        layoutDescription.ticker.tickerCallback = NULL;
c0de50da:	9006      	str	r0, [sp, #24]
c0de50dc:	a802      	add	r0, sp, #8
    }
    layout = nbgl_layoutGet(&layoutDescription);
c0de50de:	f7fb fbf1 	bl	c0de08c4 <nbgl_layoutGet>
    if (info->isSwipeable) {
c0de50e2:	f894 1024 	ldrb.w	r1, [r4, #36]	@ 0x24
    layout = nbgl_layoutGet(&layoutDescription);
c0de50e6:	4606      	mov	r6, r0
    if (info->isSwipeable) {
c0de50e8:	b151      	cbz	r1, c0de5100 <nbgl_pageDrawInfo+0xae>
        nbgl_layoutAddSwipe(layout,
                            ((1 << SWIPED_LEFT) | (1 << SWIPED_RIGHT)),
                            info->tapActionText,
c0de50ea:	6a22      	ldr	r2, [r4, #32]
                            info->tapActionToken,
c0de50ec:	f894 3025 	ldrb.w	r3, [r4, #37]	@ 0x25
                            info->tuneId);
c0de50f0:	f894 5031 	ldrb.w	r5, [r4, #49]	@ 0x31
        nbgl_layoutAddSwipe(layout,
c0de50f4:	4630      	mov	r0, r6
c0de50f6:	f44f 61c0 	mov.w	r1, #1536	@ 0x600
c0de50fa:	9500      	str	r5, [sp, #0]
c0de50fc:	f7fc fb58 	bl	c0de17b0 <nbgl_layoutAddSwipe>
    }
    // add an empty header if a top-right button is used or if the tap text is not empty
    if ((info->topRightStyle != NO_BUTTON_STYLE)
c0de5100:	7d20      	ldrb	r0, [r4, #20]
        || (info->tapActionText && strlen(PIC(info->tapActionText)))) {
c0de5102:	2800      	cmp	r0, #0
c0de5104:	d04c      	beq.n	c0de51a0 <nbgl_pageDrawInfo+0x14e>
c0de5106:	2000      	movs	r0, #0
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de5108:	900d      	str	r0, [sp, #52]	@ 0x34
c0de510a:	e9cd 000b 	strd	r0, r0, [sp, #44]	@ 0x2c
c0de510e:	e9cd 0009 	strd	r0, r0, [sp, #36]	@ 0x24
c0de5112:	2028      	movs	r0, #40	@ 0x28
c0de5114:	f8ad 0028 	strh.w	r0, [sp, #40]	@ 0x28
c0de5118:	a909      	add	r1, sp, #36	@ 0x24
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de511a:	4630      	mov	r0, r6
c0de511c:	f7ff f847 	bl	c0de41ae <nbgl_layoutAddHeader>
        addEmptyHeader(layout, SMALL_CENTERING_HEADER);
    }
    nbgl_layoutAddCenteredInfo(layout, &info->centeredInfo);
c0de5120:	4630      	mov	r0, r6
c0de5122:	4621      	mov	r1, r4
c0de5124:	f7fd ff6e 	bl	c0de3004 <nbgl_layoutAddCenteredInfo>

    // if action button but not QUIT_APP_TEXT bottom button, use a small black button
    if ((info->actionButtonText != NULL) && (info->bottomButtonStyle != QUIT_APP_TEXT)) {
c0de5128:	6aa0      	ldr	r0, [r4, #40]	@ 0x28
c0de512a:	b1b8      	cbz	r0, c0de515c <nbgl_pageDrawInfo+0x10a>
c0de512c:	7d61      	ldrb	r1, [r4, #21]
c0de512e:	2904      	cmp	r1, #4
c0de5130:	d014      	beq.n	c0de515c <nbgl_pageDrawInfo+0x10a>
        nbgl_layoutButton_t buttonInfo = {.fittingContent = true,
                                          .icon           = info->actionButtonIcon,
c0de5132:	6ae1      	ldr	r1, [r4, #44]	@ 0x2c
        nbgl_layoutButton_t buttonInfo = {.fittingContent = true,
c0de5134:	e9cd 0109 	strd	r0, r1, [sp, #36]	@ 0x24
                                          .onBottom       = false,
                                          .style          = info->actionButtonStyle,
c0de5138:	f894 1030 	ldrb.w	r1, [r4, #48]	@ 0x30
                                          .text           = info->actionButtonText,
                                          .token          = info->bottomButtonsToken,
c0de513c:	7de0      	ldrb	r0, [r4, #23]
        nbgl_layoutButton_t buttonInfo = {.fittingContent = true,
c0de513e:	f88d 102d 	strb.w	r1, [sp, #45]	@ 0x2d
                                          .tuneId         = info->tuneId};
c0de5142:	f894 1031 	ldrb.w	r1, [r4, #49]	@ 0x31
        nbgl_layoutButton_t buttonInfo = {.fittingContent = true,
c0de5146:	f88d 002c 	strb.w	r0, [sp, #44]	@ 0x2c
c0de514a:	2001      	movs	r0, #1
c0de514c:	f8ad 002e 	strh.w	r0, [sp, #46]	@ 0x2e
c0de5150:	f88d 1030 	strb.w	r1, [sp, #48]	@ 0x30
c0de5154:	a909      	add	r1, sp, #36	@ 0x24
        nbgl_layoutAddButton(layout, &buttonInfo);
c0de5156:	4630      	mov	r0, r6
c0de5158:	f7fe fecc 	bl	c0de3ef4 <nbgl_layoutAddButton>
    }

    if (info->footerText != NULL) {
c0de515c:	69a0      	ldr	r0, [r4, #24]
c0de515e:	b140      	cbz	r0, c0de5172 <nbgl_pageDrawInfo+0x120>
        nbgl_layoutAddFooter(layout, PIC(info->footerText), info->footerToken, info->tuneId);
c0de5160:	f003 fecc 	bl	c0de8efc <pic>
c0de5164:	7f22      	ldrb	r2, [r4, #28]
c0de5166:	f894 3031 	ldrb.w	r3, [r4, #49]	@ 0x31
c0de516a:	4601      	mov	r1, r0
c0de516c:	4630      	mov	r0, r6
c0de516e:	f7fe fff6 	bl	c0de415e <nbgl_layoutAddFooter>
    }
    if (info->topRightStyle != NO_BUTTON_STYLE) {
c0de5172:	7d21      	ldrb	r1, [r4, #20]
c0de5174:	2000      	movs	r0, #0
c0de5176:	2901      	cmp	r1, #1
c0de5178:	dc08      	bgt.n	c0de518c <nbgl_pageDrawInfo+0x13a>
c0de517a:	b341      	cbz	r1, c0de51ce <nbgl_pageDrawInfo+0x17c>
c0de517c:	2901      	cmp	r1, #1
c0de517e:	d173      	bne.n	c0de5268 <nbgl_pageDrawInfo+0x216>
c0de5180:	f644 703e 	movw	r0, #20286	@ 0x4f3e
c0de5184:	f2c0 0000 	movt	r0, #0
c0de5188:	4478      	add	r0, pc
c0de518a:	e017      	b.n	c0de51bc <nbgl_pageDrawInfo+0x16a>
c0de518c:	2902      	cmp	r1, #2
c0de518e:	d010      	beq.n	c0de51b2 <nbgl_pageDrawInfo+0x160>
c0de5190:	2903      	cmp	r1, #3
c0de5192:	d169      	bne.n	c0de5268 <nbgl_pageDrawInfo+0x216>
c0de5194:	f644 20e7 	movw	r0, #19175	@ 0x4ae7
c0de5198:	f2c0 0000 	movt	r0, #0
c0de519c:	4478      	add	r0, pc
c0de519e:	e00d      	b.n	c0de51bc <nbgl_pageDrawInfo+0x16a>
        || (info->tapActionText && strlen(PIC(info->tapActionText)))) {
c0de51a0:	6a20      	ldr	r0, [r4, #32]
c0de51a2:	2800      	cmp	r0, #0
c0de51a4:	d0bc      	beq.n	c0de5120 <nbgl_pageDrawInfo+0xce>
c0de51a6:	f003 fea9 	bl	c0de8efc <pic>
c0de51aa:	7800      	ldrb	r0, [r0, #0]
    if ((info->topRightStyle != NO_BUTTON_STYLE)
c0de51ac:	2800      	cmp	r0, #0
c0de51ae:	d1aa      	bne.n	c0de5106 <nbgl_pageDrawInfo+0xb4>
c0de51b0:	e7b6      	b.n	c0de5120 <nbgl_pageDrawInfo+0xce>
c0de51b2:	f644 2086 	movw	r0, #19078	@ 0x4a86
c0de51b6:	f2c0 0000 	movt	r0, #0
c0de51ba:	4478      	add	r0, pc
            icon = &CLOSE_ICON;
        }
        else {
            return NULL;
        }
        nbgl_layoutAddTopRightButton(layout, PIC(icon), info->topRightToken, info->tuneId);
c0de51bc:	f003 fe9e 	bl	c0de8efc <pic>
c0de51c0:	7da2      	ldrb	r2, [r4, #22]
c0de51c2:	f894 3031 	ldrb.w	r3, [r4, #49]	@ 0x31
c0de51c6:	4601      	mov	r1, r0
c0de51c8:	4630      	mov	r0, r6
c0de51ca:	f7fc fb5a 	bl	c0de1882 <nbgl_layoutAddTopRightButton>
    }
    if (info->bottomButtonStyle == QUIT_APP_TEXT) {
c0de51ce:	7d61      	ldrb	r1, [r4, #21]
c0de51d0:	2000      	movs	r0, #0
c0de51d2:	2901      	cmp	r1, #1
c0de51d4:	dd25      	ble.n	c0de5222 <nbgl_pageDrawInfo+0x1d0>
c0de51d6:	2902      	cmp	r1, #2
c0de51d8:	d02c      	beq.n	c0de5234 <nbgl_pageDrawInfo+0x1e2>
c0de51da:	2903      	cmp	r1, #3
c0de51dc:	d030      	beq.n	c0de5240 <nbgl_pageDrawInfo+0x1ee>
c0de51de:	2904      	cmp	r1, #4
c0de51e0:	d142      	bne.n	c0de5268 <nbgl_pageDrawInfo+0x216>
        // if action button and QUIT_APP_TEXT bottom button, use a pair of choice buttons
        if ((info->actionButtonText != NULL)) {
c0de51e2:	6aa0      	ldr	r0, [r4, #40]	@ 0x28
c0de51e4:	2800      	cmp	r0, #0
c0de51e6:	d041      	beq.n	c0de526c <nbgl_pageDrawInfo+0x21a>
            nbgl_layoutChoiceButtons_t buttonsInfo = {.topText    = info->actionButtonText,
c0de51e8:	9009      	str	r0, [sp, #36]	@ 0x24
c0de51ea:	f245 5092 	movw	r0, #21906	@ 0x5592
c0de51ee:	f2c0 0000 	movt	r0, #0
                                                      .bottomText = "Quit app",
                                                      .token      = info->bottomButtonsToken,
                                                      .tuneId     = info->tuneId,
                                                      .topIcon    = info->actionButtonIcon};
c0de51f2:	6ae1      	ldr	r1, [r4, #44]	@ 0x2c
            nbgl_layoutChoiceButtons_t buttonsInfo = {.topText    = info->actionButtonText,
c0de51f4:	4478      	add	r0, pc
c0de51f6:	e9cd 010a 	strd	r0, r1, [sp, #40]	@ 0x28
                                                      .token      = info->bottomButtonsToken,
c0de51fa:	7de0      	ldrb	r0, [r4, #23]
                                                      .tuneId     = info->tuneId,
c0de51fc:	f894 1031 	ldrb.w	r1, [r4, #49]	@ 0x31
            nbgl_layoutChoiceButtons_t buttonsInfo = {.topText    = info->actionButtonText,
c0de5200:	f88d 0030 	strb.w	r0, [sp, #48]	@ 0x30
            buttonsInfo.style                      = (info->actionButtonStyle == BLACK_BACKGROUND)
c0de5204:	f894 0030 	ldrb.w	r0, [r4, #48]	@ 0x30
            nbgl_layoutChoiceButtons_t buttonsInfo = {.topText    = info->actionButtonText,
c0de5208:	f88d 1032 	strb.w	r1, [sp, #50]	@ 0x32
c0de520c:	2102      	movs	r1, #2
            buttonsInfo.style                      = (info->actionButtonStyle == BLACK_BACKGROUND)
c0de520e:	2800      	cmp	r0, #0
c0de5210:	bf08      	it	eq
c0de5212:	2101      	moveq	r1, #1
c0de5214:	f88d 1031 	strb.w	r1, [sp, #49]	@ 0x31
c0de5218:	a909      	add	r1, sp, #36	@ 0x24
                                                         ? STRONG_ACTION_AND_FOOTER_STYLE
                                                         : SOFT_ACTION_AND_FOOTER_STYLE;
            nbgl_layoutAddChoiceButtons(layout, &buttonsInfo);
c0de521a:	4630      	mov	r0, r6
c0de521c:	f7fe fbfe 	bl	c0de3a1c <nbgl_layoutAddChoiceButtons>
c0de5220:	e01e      	b.n	c0de5260 <nbgl_pageDrawInfo+0x20e>
    if (info->bottomButtonStyle == QUIT_APP_TEXT) {
c0de5222:	b1e9      	cbz	r1, c0de5260 <nbgl_pageDrawInfo+0x20e>
c0de5224:	2901      	cmp	r1, #1
c0de5226:	d11f      	bne.n	c0de5268 <nbgl_pageDrawInfo+0x216>
c0de5228:	f644 6096 	movw	r0, #20118	@ 0x4e96
c0de522c:	f2c0 0000 	movt	r0, #0
c0de5230:	4478      	add	r0, pc
c0de5232:	e00a      	b.n	c0de524a <nbgl_pageDrawInfo+0x1f8>
c0de5234:	f644 2004 	movw	r0, #18948	@ 0x4a04
c0de5238:	f2c0 0000 	movt	r0, #0
c0de523c:	4478      	add	r0, pc
c0de523e:	e004      	b.n	c0de524a <nbgl_pageDrawInfo+0x1f8>
c0de5240:	f644 203b 	movw	r0, #19003	@ 0x4a3b
c0de5244:	f2c0 0000 	movt	r0, #0
c0de5248:	4478      	add	r0, pc
        }
        else {
            return NULL;
        }
        nbgl_layoutAddBottomButton(
            layout, PIC(icon), info->bottomButtonsToken, false, info->tuneId);
c0de524a:	f003 fe57 	bl	c0de8efc <pic>
c0de524e:	7de2      	ldrb	r2, [r4, #23]
c0de5250:	f894 5031 	ldrb.w	r5, [r4, #49]	@ 0x31
c0de5254:	4601      	mov	r1, r0
        nbgl_layoutAddBottomButton(
c0de5256:	4630      	mov	r0, r6
c0de5258:	2300      	movs	r3, #0
c0de525a:	9500      	str	r5, [sp, #0]
c0de525c:	f7fd f8e1 	bl	c0de2422 <nbgl_layoutAddBottomButton>
    }
    nbgl_layoutDraw(layout);
c0de5260:	4630      	mov	r0, r6
c0de5262:	f7ff fbf4 	bl	c0de4a4e <nbgl_layoutDraw>
c0de5266:	4630      	mov	r0, r6

    return (nbgl_page_t *) layout;
}
c0de5268:	b00e      	add	sp, #56	@ 0x38
c0de526a:	bd70      	pop	{r4, r5, r6, pc}
            nbgl_layoutAddFooter(layout, "Quit app", info->bottomButtonsToken, info->tuneId);
c0de526c:	7de2      	ldrb	r2, [r4, #23]
c0de526e:	f894 3031 	ldrb.w	r3, [r4, #49]	@ 0x31
c0de5272:	f245 510c 	movw	r1, #21772	@ 0x550c
c0de5276:	f2c0 0100 	movt	r1, #0
c0de527a:	4479      	add	r1, pc
c0de527c:	4630      	mov	r0, r6
c0de527e:	f7fe ff6e 	bl	c0de415e <nbgl_layoutAddFooter>
c0de5282:	e7ed      	b.n	c0de5260 <nbgl_pageDrawInfo+0x20e>

c0de5284 <nbgl_pageDrawConfirmation>:
 * @param info structure describing the centered info and other controls of this page
 * @return the page context (or NULL if error)
 */
nbgl_page_t *nbgl_pageDrawConfirmation(nbgl_layoutTouchCallback_t                onActionCallback,
                                       const nbgl_pageConfirmationDescription_t *info)
{
c0de5284:	b570      	push	{r4, r5, r6, lr}
c0de5286:	b090      	sub	sp, #64	@ 0x40
c0de5288:	460c      	mov	r4, r1
    nbgl_layoutDescription_t   layoutDescription;
    nbgl_layout_t             *layout;
    nbgl_layoutChoiceButtons_t buttonsInfo
        = {.bottomText = (info->cancelText != NULL) ? PIC(info->cancelText) : "Cancel",
           .token      = info->confirmationToken,
           .topText    = PIC(info->confirmationText),
c0de528a:	6949      	ldr	r1, [r1, #20]
c0de528c:	4605      	mov	r5, r0
c0de528e:	4608      	mov	r0, r1
c0de5290:	f003 fe34 	bl	c0de8efc <pic>
        = {.bottomText = (info->cancelText != NULL) ? PIC(info->cancelText) : "Cancel",
c0de5294:	69a1      	ldr	r1, [r4, #24]
c0de5296:	9000      	str	r0, [sp, #0]
c0de5298:	b119      	cbz	r1, c0de52a2 <nbgl_pageDrawConfirmation+0x1e>
c0de529a:	4608      	mov	r0, r1
c0de529c:	f003 fe2e 	bl	c0de8efc <pic>
c0de52a0:	e004      	b.n	c0de52ac <nbgl_pageDrawConfirmation+0x28>
c0de52a2:	f245 202e 	movw	r0, #21038	@ 0x522e
c0de52a6:	f2c0 0000 	movt	r0, #0
c0de52aa:	4478      	add	r0, pc
c0de52ac:	9001      	str	r0, [sp, #4]
           .token      = info->confirmationToken,
c0de52ae:	7f20      	ldrb	r0, [r4, #28]
           .style      = ROUNDED_AND_FOOTER_STYLE,
           .tuneId     = info->tuneId};
c0de52b0:	7fa1      	ldrb	r1, [r4, #30]

    layoutDescription.modal          = info->modal;
c0de52b2:	7fe2      	ldrb	r2, [r4, #31]
        = {.bottomText = (info->cancelText != NULL) ? PIC(info->cancelText) : "Cancel",
c0de52b4:	f88d 000c 	strb.w	r0, [sp, #12]
c0de52b8:	2001      	movs	r0, #1
c0de52ba:	2600      	movs	r6, #0
    layoutDescription.withLeftBorder = true;
c0de52bc:	f88d 0011 	strb.w	r0, [sp, #17]
c0de52c0:	a804      	add	r0, sp, #16
        = {.bottomText = (info->cancelText != NULL) ? PIC(info->cancelText) : "Cancel",
c0de52c2:	9602      	str	r6, [sp, #8]
c0de52c4:	f88d 600d 	strb.w	r6, [sp, #13]
c0de52c8:	f88d 100e 	strb.w	r1, [sp, #14]
    layoutDescription.modal          = info->modal;
c0de52cc:	f88d 2010 	strb.w	r2, [sp, #16]

    layoutDescription.onActionCallback = onActionCallback;
    layoutDescription.tapActionText    = NULL;
c0de52d0:	9605      	str	r6, [sp, #20]
    layoutDescription.onActionCallback = onActionCallback;
c0de52d2:	e9cd 5607 	strd	r5, r6, [sp, #28]

    layoutDescription.ticker.tickerCallback = NULL;
    layout                                  = nbgl_layoutGet(&layoutDescription);
c0de52d6:	f7fb faf5 	bl	c0de08c4 <nbgl_layoutGet>
c0de52da:	4605      	mov	r5, r0
c0de52dc:	2040      	movs	r0, #64	@ 0x40
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de52de:	960f      	str	r6, [sp, #60]	@ 0x3c
c0de52e0:	e9cd 660d 	strd	r6, r6, [sp, #52]	@ 0x34
c0de52e4:	e9cd 660b 	strd	r6, r6, [sp, #44]	@ 0x2c
c0de52e8:	f8ad 0030 	strh.w	r0, [sp, #48]	@ 0x30
c0de52ec:	a90b      	add	r1, sp, #44	@ 0x2c
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de52ee:	4628      	mov	r0, r5
c0de52f0:	f7fe ff5d 	bl	c0de41ae <nbgl_layoutAddHeader>
c0de52f4:	4669      	mov	r1, sp

    addEmptyHeader(layout, MEDIUM_CENTERING_HEADER);
    nbgl_layoutAddChoiceButtons(layout, &buttonsInfo);
c0de52f6:	4628      	mov	r0, r5
c0de52f8:	f7fe fb90 	bl	c0de3a1c <nbgl_layoutAddChoiceButtons>

    nbgl_layoutAddCenteredInfo(layout, &info->centeredInfo);
c0de52fc:	4628      	mov	r0, r5
c0de52fe:	4621      	mov	r1, r4
c0de5300:	f7fd fe80 	bl	c0de3004 <nbgl_layoutAddCenteredInfo>

    nbgl_layoutDraw(layout);
c0de5304:	4628      	mov	r0, r5
c0de5306:	f7ff fba2 	bl	c0de4a4e <nbgl_layoutDraw>

    return (nbgl_page_t *) layout;
c0de530a:	4628      	mov	r0, r5
c0de530c:	b010      	add	sp, #64	@ 0x40
c0de530e:	bd70      	pop	{r4, r5, r6, pc}

c0de5310 <nbgl_pageDrawGenericContentExt>:
 */
nbgl_page_t *nbgl_pageDrawGenericContentExt(nbgl_layoutTouchCallback_t       onActionCallback,
                                            const nbgl_pageNavigationInfo_t *nav,
                                            nbgl_pageContent_t              *content,
                                            bool                             modal)
{
c0de5310:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de5314:	b096      	sub	sp, #88	@ 0x58
c0de5316:	460e      	mov	r6, r1
c0de5318:	4615      	mov	r5, r2
c0de531a:	2101      	movs	r1, #1
    uint16_t                 availableHeight = SCREEN_HEIGHT;
    bool                     headerAdded     = false;

    layoutDescription.modal                 = modal;
    layoutDescription.withLeftBorder        = true;
    layoutDescription.onActionCallback      = onActionCallback;
c0de531c:	9005      	str	r0, [sp, #20]
c0de531e:	2000      	movs	r0, #0
    layoutDescription.modal                 = modal;
c0de5320:	f88d 3008 	strb.w	r3, [sp, #8]
    layoutDescription.withLeftBorder        = true;
c0de5324:	f88d 1009 	strb.w	r1, [sp, #9]
    layoutDescription.ticker.tickerCallback = NULL;
c0de5328:	9006      	str	r0, [sp, #24]

    if ((nav != NULL) && (nav->navType == NAV_WITH_TAP)) {
c0de532a:	b10e      	cbz	r6, c0de5330 <nbgl_pageDrawGenericContentExt+0x20>
c0de532c:	78f1      	ldrb	r1, [r6, #3]
c0de532e:	b109      	cbz	r1, c0de5334 <nbgl_pageDrawGenericContentExt+0x24>
        layoutDescription.tapActionText  = nav->navWithTap.nextPageText;
        layoutDescription.tapActionToken = nav->navWithTap.nextPageToken;
        layoutDescription.tapTuneId      = nav->tuneId;
    }
    else {
        layoutDescription.tapActionText = NULL;
c0de5330:	9003      	str	r0, [sp, #12]
c0de5332:	e007      	b.n	c0de5344 <nbgl_pageDrawGenericContentExt+0x34>
        layoutDescription.tapActionText  = nav->navWithTap.nextPageText;
c0de5334:	6970      	ldr	r0, [r6, #20]
        layoutDescription.tapTuneId      = nav->tuneId;
c0de5336:	7971      	ldrb	r1, [r6, #5]
        layoutDescription.tapActionText  = nav->navWithTap.nextPageText;
c0de5338:	9003      	str	r0, [sp, #12]
        layoutDescription.tapActionToken = nav->navWithTap.nextPageToken;
c0de533a:	7cb0      	ldrb	r0, [r6, #18]
        layoutDescription.tapTuneId      = nav->tuneId;
c0de533c:	f88d 1011 	strb.w	r1, [sp, #17]
        layoutDescription.tapActionToken = nav->navWithTap.nextPageToken;
c0de5340:	f88d 0010 	strb.w	r0, [sp, #16]
c0de5344:	a802      	add	r0, sp, #8
    }

    layout = nbgl_layoutGet(&layoutDescription);
c0de5346:	f7fb fabd 	bl	c0de08c4 <nbgl_layoutGet>
c0de534a:	4682      	mov	sl, r0
    if (nav != NULL) {
c0de534c:	b17e      	cbz	r6, c0de536e <nbgl_pageDrawGenericContentExt+0x5e>
        if (nav->navType == NAV_WITH_TAP) {
c0de534e:	78f0      	ldrb	r0, [r6, #3]
c0de5350:	2801      	cmp	r0, #1
c0de5352:	d011      	beq.n	c0de5378 <nbgl_pageDrawGenericContentExt+0x68>
c0de5354:	b958      	cbnz	r0, c0de536e <nbgl_pageDrawGenericContentExt+0x5e>
            if (nav->skipText == NULL) {
c0de5356:	68b3      	ldr	r3, [r6, #8]
c0de5358:	69b1      	ldr	r1, [r6, #24]
c0de535a:	78b2      	ldrb	r2, [r6, #2]
c0de535c:	b323      	cbz	r3, c0de53a8 <nbgl_pageDrawGenericContentExt+0x98>
            else {
                availableHeight -= nbgl_layoutAddSplitFooter(layout,
                                                             nav->navWithTap.quitText,
                                                             nav->quitToken,
                                                             nav->skipText,
                                                             nav->skipToken,
c0de535e:	7b30      	ldrb	r0, [r6, #12]
                                                             nav->tuneId);
c0de5360:	7977      	ldrb	r7, [r6, #5]
                availableHeight -= nbgl_layoutAddSplitFooter(layout,
c0de5362:	9000      	str	r0, [sp, #0]
c0de5364:	4650      	mov	r0, sl
c0de5366:	9701      	str	r7, [sp, #4]
c0de5368:	f7fe ff0c 	bl	c0de4184 <nbgl_layoutAddSplitFooter>
c0de536c:	e020      	b.n	c0de53b0 <nbgl_pageDrawGenericContentExt+0xa0>
c0de536e:	f04f 0800 	mov.w	r8, #0
c0de5372:	f44f 7716 	mov.w	r7, #600	@ 0x258
c0de5376:	e088      	b.n	c0de548a <nbgl_pageDrawGenericContentExt+0x17a>
        }
        else if (nav->navType == NAV_WITH_BUTTONS) {
            nbgl_layoutFooter_t footerDesc;
            bool                drawFooter = true;

            if (nav->skipText != NULL) {
c0de5378:	68b0      	ldr	r0, [r6, #8]
c0de537a:	2800      	cmp	r0, #0
c0de537c:	4680      	mov	r8, r0
c0de537e:	bf18      	it	ne
c0de5380:	f04f 0801 	movne.w	r8, #1
c0de5384:	d027      	beq.n	c0de53d6 <nbgl_pageDrawGenericContentExt+0xc6>
c0de5386:	2106      	movs	r1, #6
                nbgl_layoutHeader_t headerDesc = {.type             = HEADER_RIGHT_TEXT,
c0de5388:	f8ad 1034 	strh.w	r1, [sp, #52]	@ 0x34
                                                  .separationLine   = false,
                                                  .rightText.text   = nav->skipText,
c0de538c:	900e      	str	r0, [sp, #56]	@ 0x38
                                                  .rightText.token  = nav->skipToken,
c0de538e:	7b30      	ldrb	r0, [r6, #12]
                                                  .rightText.tuneId = nav->tuneId};
c0de5390:	7971      	ldrb	r1, [r6, #5]
                                                  .rightText.text   = nav->skipText,
c0de5392:	f88d 003c 	strb.w	r0, [sp, #60]	@ 0x3c
c0de5396:	f88d 103d 	strb.w	r1, [sp, #61]	@ 0x3d
c0de539a:	a90d      	add	r1, sp, #52	@ 0x34
                availableHeight -= nbgl_layoutAddHeader(layout, &headerDesc);
c0de539c:	4650      	mov	r0, sl
c0de539e:	f7fe ff06 	bl	c0de41ae <nbgl_layoutAddHeader>
c0de53a2:	f5c0 7716 	rsb	r7, r0, #600	@ 0x258
c0de53a6:	e018      	b.n	c0de53da <nbgl_pageDrawGenericContentExt+0xca>
                    layout, nav->navWithTap.quitText, nav->quitToken, nav->tuneId);
c0de53a8:	7973      	ldrb	r3, [r6, #5]
                availableHeight -= nbgl_layoutAddFooter(
c0de53aa:	4650      	mov	r0, sl
c0de53ac:	f7fe fed7 	bl	c0de415e <nbgl_layoutAddFooter>
            if (nav->progressIndicator) {
c0de53b0:	7931      	ldrb	r1, [r6, #4]
c0de53b2:	f5c0 7716 	rsb	r7, r0, #600	@ 0x258
c0de53b6:	2900      	cmp	r1, #0
c0de53b8:	d048      	beq.n	c0de544c <nbgl_pageDrawGenericContentExt+0x13c>
                                                                   nav->navWithTap.backToken,
c0de53ba:	7c70      	ldrb	r0, [r6, #17]
                                                                   nav->activePage,
c0de53bc:	7831      	ldrb	r1, [r6, #0]
                                                                   nav->nbPages,
c0de53be:	7872      	ldrb	r2, [r6, #1]
                                                                   nav->tuneId);
c0de53c0:	7974      	ldrb	r4, [r6, #5]
                                                                   nav->navWithTap.backButton,
c0de53c2:	7c33      	ldrb	r3, [r6, #16]
                availableHeight -= nbgl_layoutAddProgressIndicator(layout,
c0de53c4:	9000      	str	r0, [sp, #0]
c0de53c6:	4650      	mov	r0, sl
c0de53c8:	9401      	str	r4, [sp, #4]
c0de53ca:	f7ff fb25 	bl	c0de4a18 <nbgl_layoutAddProgressIndicator>
c0de53ce:	1a3f      	subs	r7, r7, r0
c0de53d0:	f04f 0801 	mov.w	r8, #1
c0de53d4:	e059      	b.n	c0de548a <nbgl_pageDrawGenericContentExt+0x17a>
c0de53d6:	f44f 7716 	mov.w	r7, #600	@ 0x258
                headerAdded = true;
            }
            footerDesc.separationLine = true;
            if (nav->nbPages > 1) {
c0de53da:	7870      	ldrb	r0, [r6, #1]
c0de53dc:	2101      	movs	r1, #1
c0de53de:	2802      	cmp	r0, #2
            footerDesc.separationLine = true;
c0de53e0:	f88d 1035 	strb.w	r1, [sp, #53]	@ 0x35
            if (nav->nbPages > 1) {
c0de53e4:	d322      	bcc.n	c0de542c <nbgl_pageDrawGenericContentExt+0x11c>
                if (nav->navWithButtons.quitText == NULL) {
c0de53e6:	6971      	ldr	r1, [r6, #20]
c0de53e8:	b399      	cbz	r1, c0de5452 <nbgl_pageDrawGenericContentExt+0x142>
                    footerDesc.navigation.token             = nav->navWithButtons.navToken;
                    footerDesc.navigation.tuneId            = nav->tuneId;
                }
                else {
                    footerDesc.type                              = FOOTER_TEXT_AND_NAV;
                    footerDesc.textAndNav.text                   = nav->navWithButtons.quitText;
c0de53ea:	9111      	str	r1, [sp, #68]	@ 0x44
                    footerDesc.textAndNav.tuneId                 = nav->tuneId;
                    footerDesc.textAndNav.token                  = nav->quitToken;
                    footerDesc.textAndNav.navigation.activePage  = nav->activePage;
c0de53ec:	7831      	ldrb	r1, [r6, #0]
                    footerDesc.textAndNav.navigation.nbPages     = nav->nbPages;
c0de53ee:	f88d 0039 	strb.w	r0, [sp, #57]	@ 0x39
c0de53f2:	2000      	movs	r0, #0
c0de53f4:	2203      	movs	r2, #3
                    footerDesc.textAndNav.navigation.withExitKey = false;
c0de53f6:	f88d 003b 	strb.w	r0, [sp, #59]	@ 0x3b
                    footerDesc.textAndNav.navigation.withBackKey = nav->navWithButtons.backButton;
                    footerDesc.textAndNav.navigation.visibleIndicator
                        = nav->navWithButtons.visiblePageIndicator;
c0de53fa:	7cb0      	ldrb	r0, [r6, #18]
                    footerDesc.type                              = FOOTER_TEXT_AND_NAV;
c0de53fc:	f88d 2034 	strb.w	r2, [sp, #52]	@ 0x34
                    footerDesc.textAndNav.token                  = nav->quitToken;
c0de5400:	78b2      	ldrb	r2, [r6, #2]
                    footerDesc.textAndNav.tuneId                 = nav->tuneId;
c0de5402:	7973      	ldrb	r3, [r6, #5]
                    footerDesc.textAndNav.navigation.withBackKey = nav->navWithButtons.backButton;
c0de5404:	7c74      	ldrb	r4, [r6, #17]
                    footerDesc.textAndNav.navigation.activePage  = nav->activePage;
c0de5406:	f88d 103a 	strb.w	r1, [sp, #58]	@ 0x3a
                    footerDesc.textAndNav.navigation.withPageIndicator = true;
                    footerDesc.textAndNav.navigation.token  = nav->navWithButtons.navToken;
c0de540a:	7cf1      	ldrb	r1, [r6, #19]
                        = nav->navWithButtons.visiblePageIndicator;
c0de540c:	f88d 003f 	strb.w	r0, [sp, #63]	@ 0x3f
c0de5410:	2001      	movs	r0, #1
                    footerDesc.textAndNav.tuneId                 = nav->tuneId;
c0de5412:	f88d 3049 	strb.w	r3, [sp, #73]	@ 0x49
                    footerDesc.textAndNav.token                  = nav->quitToken;
c0de5416:	f88d 2048 	strb.w	r2, [sp, #72]	@ 0x48
                    footerDesc.textAndNav.navigation.withBackKey = nav->navWithButtons.backButton;
c0de541a:	f88d 403c 	strb.w	r4, [sp, #60]	@ 0x3c
                    footerDesc.textAndNav.navigation.withPageIndicator = true;
c0de541e:	f88d 003e 	strb.w	r0, [sp, #62]	@ 0x3e
                    footerDesc.textAndNav.navigation.token  = nav->navWithButtons.navToken;
c0de5422:	f88d 1038 	strb.w	r1, [sp, #56]	@ 0x38
                    footerDesc.textAndNav.navigation.tuneId = nav->tuneId;
c0de5426:	f88d 3040 	strb.w	r3, [sp, #64]	@ 0x40
c0de542a:	e029      	b.n	c0de5480 <nbgl_pageDrawGenericContentExt+0x170>
                }
            }
            else if (nav->navWithButtons.quitText != NULL) {
c0de542c:	6970      	ldr	r0, [r6, #20]
c0de542e:	b360      	cbz	r0, c0de548a <nbgl_pageDrawGenericContentExt+0x17a>
c0de5430:	2101      	movs	r1, #1
                // simple footer
                footerDesc.type                = FOOTER_SIMPLE_TEXT;
                footerDesc.simpleText.text     = nav->navWithButtons.quitText;
c0de5432:	900e      	str	r0, [sp, #56]	@ 0x38
c0de5434:	2000      	movs	r0, #0
                footerDesc.type                = FOOTER_SIMPLE_TEXT;
c0de5436:	f88d 1034 	strb.w	r1, [sp, #52]	@ 0x34
                footerDesc.simpleText.mutedOut = false;
c0de543a:	f88d 003c 	strb.w	r0, [sp, #60]	@ 0x3c
                footerDesc.simpleText.token    = nav->quitToken;
c0de543e:	78b0      	ldrb	r0, [r6, #2]
                footerDesc.simpleText.tuneId   = nav->tuneId;
c0de5440:	7971      	ldrb	r1, [r6, #5]
                footerDesc.simpleText.token    = nav->quitToken;
c0de5442:	f88d 003d 	strb.w	r0, [sp, #61]	@ 0x3d
                footerDesc.simpleText.tuneId   = nav->tuneId;
c0de5446:	f88d 103e 	strb.w	r1, [sp, #62]	@ 0x3e
c0de544a:	e019      	b.n	c0de5480 <nbgl_pageDrawGenericContentExt+0x170>
c0de544c:	f04f 0800 	mov.w	r8, #0
c0de5450:	e01b      	b.n	c0de548a <nbgl_pageDrawGenericContentExt+0x17a>
c0de5452:	2104      	movs	r1, #4
                    footerDesc.type                         = FOOTER_NAV;
c0de5454:	f88d 1034 	strb.w	r1, [sp, #52]	@ 0x34
                    footerDesc.navigation.activePage        = nav->activePage;
c0de5458:	7831      	ldrb	r1, [r6, #0]
                    footerDesc.navigation.tuneId            = nav->tuneId;
c0de545a:	7972      	ldrb	r2, [r6, #5]
                    footerDesc.navigation.withExitKey       = nav->navWithButtons.quitButton;
c0de545c:	7c33      	ldrb	r3, [r6, #16]
                    footerDesc.navigation.withBackKey       = nav->navWithButtons.backButton;
c0de545e:	7c74      	ldrb	r4, [r6, #17]
                    footerDesc.navigation.activePage        = nav->activePage;
c0de5460:	f88d 103a 	strb.w	r1, [sp, #58]	@ 0x3a
                    footerDesc.navigation.token             = nav->navWithButtons.navToken;
c0de5464:	7cf1      	ldrb	r1, [r6, #19]
                    footerDesc.navigation.nbPages           = nav->nbPages;
c0de5466:	f88d 0039 	strb.w	r0, [sp, #57]	@ 0x39
c0de546a:	2000      	movs	r0, #0
                    footerDesc.navigation.withExitKey       = nav->navWithButtons.quitButton;
c0de546c:	f88d 303b 	strb.w	r3, [sp, #59]	@ 0x3b
                    footerDesc.navigation.withBackKey       = nav->navWithButtons.backButton;
c0de5470:	f88d 403c 	strb.w	r4, [sp, #60]	@ 0x3c
                    footerDesc.navigation.withPageIndicator = false;
c0de5474:	f88d 003e 	strb.w	r0, [sp, #62]	@ 0x3e
                    footerDesc.navigation.token             = nav->navWithButtons.navToken;
c0de5478:	f88d 1038 	strb.w	r1, [sp, #56]	@ 0x38
                    footerDesc.navigation.tuneId            = nav->tuneId;
c0de547c:	f88d 2040 	strb.w	r2, [sp, #64]	@ 0x40
c0de5480:	a90d      	add	r1, sp, #52	@ 0x34
            }
            else {
                drawFooter = false;
            }
            if (drawFooter) {
                availableHeight -= nbgl_layoutAddExtendedFooter(layout, &footerDesc);
c0de5482:	4650      	mov	r0, sl
c0de5484:	f7fc fa5e 	bl	c0de1944 <nbgl_layoutAddExtendedFooter>
c0de5488:	1a3f      	subs	r7, r7, r0
    if (content->title != NULL) {
c0de548a:	6828      	ldr	r0, [r5, #0]
c0de548c:	b190      	cbz	r0, c0de54b4 <nbgl_pageDrawGenericContentExt+0x1a4>
c0de548e:	f240 1101 	movw	r1, #257	@ 0x101
        nbgl_layoutHeader_t headerDesc = {.type               = HEADER_BACK_AND_TEXT,
c0de5492:	f8ad 1034 	strh.w	r1, [sp, #52]	@ 0x34
c0de5496:	2100      	movs	r1, #0
                                          .backAndText.token  = content->titleToken,
c0de5498:	e9cd 100e 	strd	r1, r0, [sp, #56]	@ 0x38
c0de549c:	7968      	ldrb	r0, [r5, #5]
                                          .backAndText.tuneId = content->tuneId,
c0de549e:	79a9      	ldrb	r1, [r5, #6]
                                          .backAndText.token  = content->titleToken,
c0de54a0:	f88d 0040 	strb.w	r0, [sp, #64]	@ 0x40
c0de54a4:	f88d 1041 	strb.w	r1, [sp, #65]	@ 0x41
c0de54a8:	a90d      	add	r1, sp, #52	@ 0x34
        nbgl_layoutAddHeader(layout, &headerDesc);
c0de54aa:	4650      	mov	r0, sl
c0de54ac:	f7fe fe7f 	bl	c0de41ae <nbgl_layoutAddHeader>
c0de54b0:	f04f 0801 	mov.w	r8, #1
    if (content->topRightIcon != NULL) {
c0de54b4:	68a9      	ldr	r1, [r5, #8]
c0de54b6:	b121      	cbz	r1, c0de54c2 <nbgl_pageDrawGenericContentExt+0x1b2>
            layout, content->topRightIcon, content->topRightToken, content->tuneId);
c0de54b8:	79ab      	ldrb	r3, [r5, #6]
c0de54ba:	79ea      	ldrb	r2, [r5, #7]
        nbgl_layoutAddTopRightButton(
c0de54bc:	4650      	mov	r0, sl
c0de54be:	f7fc f9e0 	bl	c0de1882 <nbgl_layoutAddTopRightButton>
    switch (content->type) {
c0de54c2:	7b28      	ldrb	r0, [r5, #12]
c0de54c4:	2804      	cmp	r0, #4
c0de54c6:	dd25      	ble.n	c0de5514 <nbgl_pageDrawGenericContentExt+0x204>
c0de54c8:	2807      	cmp	r0, #7
c0de54ca:	dc44      	bgt.n	c0de5556 <nbgl_pageDrawGenericContentExt+0x246>
c0de54cc:	2805      	cmp	r0, #5
c0de54ce:	f000 80a9 	beq.w	c0de5624 <nbgl_pageDrawGenericContentExt+0x314>
c0de54d2:	2806      	cmp	r0, #6
c0de54d4:	f000 80ca 	beq.w	c0de566c <nbgl_pageDrawGenericContentExt+0x35c>
c0de54d8:	2807      	cmp	r0, #7
c0de54da:	f040 8195 	bne.w	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
            for (i = 0; i < content->switchesList.nbSwitches; i++) {
c0de54de:	7d28      	ldrb	r0, [r5, #20]
c0de54e0:	2800      	cmp	r0, #0
c0de54e2:	f000 8191 	beq.w	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
c0de54e6:	2400      	movs	r4, #0
c0de54e8:	2600      	movs	r6, #0
c0de54ea:	e006      	b.n	c0de54fa <nbgl_pageDrawGenericContentExt+0x1ea>
c0de54ec:	7d28      	ldrb	r0, [r5, #20]
c0de54ee:	3601      	adds	r6, #1
c0de54f0:	4286      	cmp	r6, r0
c0de54f2:	f104 040c 	add.w	r4, r4, #12
c0de54f6:	f080 8187 	bcs.w	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
                availableHeight -= nbgl_layoutAddSwitch(layout, &content->switchesList.switches[i]);
c0de54fa:	6928      	ldr	r0, [r5, #16]
c0de54fc:	1901      	adds	r1, r0, r4
c0de54fe:	4650      	mov	r0, sl
c0de5500:	f7fd fa91 	bl	c0de2a26 <nbgl_layoutAddSwitch>
c0de5504:	1a3f      	subs	r7, r7, r0
c0de5506:	b2b8      	uxth	r0, r7
                if (availableHeight > 10) {
c0de5508:	280b      	cmp	r0, #11
c0de550a:	d3ef      	bcc.n	c0de54ec <nbgl_pageDrawGenericContentExt+0x1dc>
                    nbgl_layoutAddSeparationLine(layout);
c0de550c:	4650      	mov	r0, sl
c0de550e:	f7fe fcb8 	bl	c0de3e82 <nbgl_layoutAddSeparationLine>
c0de5512:	e7eb      	b.n	c0de54ec <nbgl_pageDrawGenericContentExt+0x1dc>
    switch (content->type) {
c0de5514:	2801      	cmp	r0, #1
c0de5516:	dd58      	ble.n	c0de55ca <nbgl_pageDrawGenericContentExt+0x2ba>
c0de5518:	2802      	cmp	r0, #2
c0de551a:	f000 80eb 	beq.w	c0de56f4 <nbgl_pageDrawGenericContentExt+0x3e4>
c0de551e:	2803      	cmp	r0, #3
c0de5520:	f000 80ff 	beq.w	c0de5722 <nbgl_pageDrawGenericContentExt+0x412>
c0de5524:	2804      	cmp	r0, #4
c0de5526:	f040 816f 	bne.w	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
            if (!headerAdded) {
c0de552a:	f1b8 0f00 	cmp.w	r8, #0
c0de552e:	d10c      	bne.n	c0de554a <nbgl_pageDrawGenericContentExt+0x23a>
c0de5530:	2000      	movs	r0, #0
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de5532:	9011      	str	r0, [sp, #68]	@ 0x44
c0de5534:	e9cd 000f 	strd	r0, r0, [sp, #60]	@ 0x3c
c0de5538:	e9cd 000d 	strd	r0, r0, [sp, #52]	@ 0x34
c0de553c:	2028      	movs	r0, #40	@ 0x28
c0de553e:	f8ad 0038 	strh.w	r0, [sp, #56]	@ 0x38
c0de5542:	a90d      	add	r1, sp, #52	@ 0x34
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de5544:	4650      	mov	r0, sl
c0de5546:	f7fe fe32 	bl	c0de41ae <nbgl_layoutAddHeader>
            nbgl_layoutAddTagValueList(layout, &content->tagValueList);
c0de554a:	f105 0110 	add.w	r1, r5, #16
c0de554e:	4650      	mov	r0, sl
c0de5550:	f7fe fa90 	bl	c0de3a74 <nbgl_layoutAddTagValueList>
c0de5554:	e158      	b.n	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
    switch (content->type) {
c0de5556:	2808      	cmp	r0, #8
c0de5558:	f000 8107 	beq.w	c0de576a <nbgl_pageDrawGenericContentExt+0x45a>
c0de555c:	2809      	cmp	r0, #9
c0de555e:	f000 8138 	beq.w	c0de57d2 <nbgl_pageDrawGenericContentExt+0x4c2>
c0de5562:	280a      	cmp	r0, #10
c0de5564:	f040 8150 	bne.w	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
            for (i = 0; i < content->barsList.nbBars; i++) {
c0de5568:	7e28      	ldrb	r0, [r5, #24]
c0de556a:	2800      	cmp	r0, #0
c0de556c:	f000 814c 	beq.w	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
c0de5570:	f244 5824 	movw	r8, #17700	@ 0x4524
c0de5574:	f2c0 0800 	movt	r8, #0
c0de5578:	2400      	movs	r4, #0
c0de557a:	44f8      	add	r8, pc
c0de557c:	f10d 0b34 	add.w	fp, sp, #52	@ 0x34
c0de5580:	2600      	movs	r6, #0
c0de5582:	e004      	b.n	c0de558e <nbgl_pageDrawGenericContentExt+0x27e>
c0de5584:	7e28      	ldrb	r0, [r5, #24]
c0de5586:	3601      	adds	r6, #1
c0de5588:	4286      	cmp	r6, r0
c0de558a:	f080 813d 	bcs.w	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
                bar.text      = content->barsList.barTexts[i];
c0de558e:	6928      	ldr	r0, [r5, #16]
                bar.token     = content->barsList.tokens[i];
c0de5590:	6969      	ldr	r1, [r5, #20]
                bar.text      = content->barsList.barTexts[i];
c0de5592:	f850 0026 	ldr.w	r0, [r0, r6, lsl #2]
                bar.iconRight = &PUSH_ICON;
c0de5596:	e9cd 840f 	strd	r8, r4, [sp, #60]	@ 0x3c
                bar.iconLeft  = NULL;
c0de559a:	e9cd 400d 	strd	r4, r0, [sp, #52]	@ 0x34
                bar.token     = content->barsList.tokens[i];
c0de559e:	5d88      	ldrb	r0, [r1, r6]
                bar.tuneId    = content->barsList.tuneId;
c0de55a0:	7e69      	ldrb	r1, [r5, #25]
                bar.token     = content->barsList.tokens[i];
c0de55a2:	f88d 0045 	strb.w	r0, [sp, #69]	@ 0x45
                bar.tuneId    = content->barsList.tuneId;
c0de55a6:	f88d 1048 	strb.w	r1, [sp, #72]	@ 0x48
                availableHeight -= nbgl_layoutAddTouchableBar(layout, &bar);
c0de55aa:	4650      	mov	r0, sl
c0de55ac:	4659      	mov	r1, fp
                bar.large     = false;
c0de55ae:	f88d 4044 	strb.w	r4, [sp, #68]	@ 0x44
                bar.inactive  = false;
c0de55b2:	f88d 4046 	strb.w	r4, [sp, #70]	@ 0x46
                availableHeight -= nbgl_layoutAddTouchableBar(layout, &bar);
c0de55b6:	f7fc ff53 	bl	c0de2460 <nbgl_layoutAddTouchableBar>
c0de55ba:	1a3f      	subs	r7, r7, r0
c0de55bc:	b2b8      	uxth	r0, r7
                if (availableHeight > 10) {
c0de55be:	280b      	cmp	r0, #11
c0de55c0:	d3e0      	bcc.n	c0de5584 <nbgl_pageDrawGenericContentExt+0x274>
                    nbgl_layoutAddSeparationLine(layout);
c0de55c2:	4650      	mov	r0, sl
c0de55c4:	f7fe fc5d 	bl	c0de3e82 <nbgl_layoutAddSeparationLine>
c0de55c8:	e7dc      	b.n	c0de5584 <nbgl_pageDrawGenericContentExt+0x274>
    switch (content->type) {
c0de55ca:	2800      	cmp	r0, #0
c0de55cc:	f000 8107 	beq.w	c0de57de <nbgl_pageDrawGenericContentExt+0x4ce>
c0de55d0:	2801      	cmp	r0, #1
c0de55d2:	f040 8119 	bne.w	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
            if (!headerAdded) {
c0de55d6:	f1b8 0f00 	cmp.w	r8, #0
c0de55da:	d10c      	bne.n	c0de55f6 <nbgl_pageDrawGenericContentExt+0x2e6>
c0de55dc:	2000      	movs	r0, #0
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de55de:	9011      	str	r0, [sp, #68]	@ 0x44
c0de55e0:	e9cd 000f 	strd	r0, r0, [sp, #60]	@ 0x3c
c0de55e4:	e9cd 000d 	strd	r0, r0, [sp, #52]	@ 0x34
c0de55e8:	2028      	movs	r0, #40	@ 0x28
c0de55ea:	f8ad 0038 	strh.w	r0, [sp, #56]	@ 0x38
c0de55ee:	a90d      	add	r1, sp, #52	@ 0x34
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de55f0:	4650      	mov	r0, sl
c0de55f2:	f7fe fddc 	bl	c0de41ae <nbgl_layoutAddHeader>
            nbgl_layoutAddContentCenter(layout, &content->extendedCenter.contentCenter);
c0de55f6:	f105 0110 	add.w	r1, r5, #16
c0de55fa:	4650      	mov	r0, sl
c0de55fc:	f7fe f85e 	bl	c0de36bc <nbgl_layoutAddContentCenter>
            if (content->extendedCenter.tipBox.text != NULL) {
c0de5600:	6b68      	ldr	r0, [r5, #52]	@ 0x34
c0de5602:	2800      	cmp	r0, #0
c0de5604:	f000 8100 	beq.w	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
c0de5608:	2103      	movs	r1, #3
                    = {.type          = UP_FOOTER_TIP_BOX,
c0de560a:	f88d 1034 	strb.w	r1, [sp, #52]	@ 0x34
                       .tipBox.text   = content->extendedCenter.tipBox.text,
c0de560e:	900e      	str	r0, [sp, #56]	@ 0x38
                       .tipBox.icon   = content->extendedCenter.tipBox.icon,
c0de5610:	6ba8      	ldr	r0, [r5, #56]	@ 0x38
                       .tipBox.token  = content->extendedCenter.tipBox.token,
c0de5612:	8fa9      	ldrh	r1, [r5, #60]	@ 0x3c
                       .tipBox.text   = content->extendedCenter.tipBox.text,
c0de5614:	900f      	str	r0, [sp, #60]	@ 0x3c
c0de5616:	f8ad 1040 	strh.w	r1, [sp, #64]	@ 0x40
c0de561a:	a90d      	add	r1, sp, #52	@ 0x34
                nbgl_layoutAddUpFooter(layout, &upFooterDesc);
c0de561c:	4650      	mov	r0, sl
c0de561e:	f7fb fc8f 	bl	c0de0f40 <nbgl_layoutAddUpFooter>
c0de5622:	e0f1      	b.n	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
            if (!headerAdded) {
c0de5624:	f1b8 0f00 	cmp.w	r8, #0
c0de5628:	d10c      	bne.n	c0de5644 <nbgl_pageDrawGenericContentExt+0x334>
c0de562a:	2000      	movs	r0, #0
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de562c:	9011      	str	r0, [sp, #68]	@ 0x44
c0de562e:	e9cd 000f 	strd	r0, r0, [sp, #60]	@ 0x3c
c0de5632:	e9cd 000d 	strd	r0, r0, [sp, #52]	@ 0x34
c0de5636:	2028      	movs	r0, #40	@ 0x28
c0de5638:	f8ad 0038 	strh.w	r0, [sp, #56]	@ 0x38
c0de563c:	a90d      	add	r1, sp, #52	@ 0x34
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de563e:	4650      	mov	r0, sl
c0de5640:	f7fe fdb5 	bl	c0de41ae <nbgl_layoutAddHeader>
            content->tagValueDetails.tagValueList.nbMaxLinesForValue -= 3;
c0de5644:	7ee8      	ldrb	r0, [r5, #27]
c0de5646:	f105 0110 	add.w	r1, r5, #16
c0de564a:	3803      	subs	r0, #3
c0de564c:	76e8      	strb	r0, [r5, #27]
            nbgl_layoutAddTagValueList(layout, &content->tagValueDetails.tagValueList);
c0de564e:	4650      	mov	r0, sl
c0de5650:	f7fe fa10 	bl	c0de3a74 <nbgl_layoutAddTagValueList>
c0de5654:	2001      	movs	r0, #1
            buttonInfo.fittingContent = true;
c0de5656:	f8ad 003e 	strh.w	r0, [sp, #62]	@ 0x3e
            buttonInfo.icon           = content->tagValueDetails.detailsButtonIcon;
c0de565a:	e9d5 1209 	ldrd	r1, r2, [r5, #36]	@ 0x24
            buttonInfo.style          = WHITE_BACKGROUND;
c0de565e:	f88d 003d 	strb.w	r0, [sp, #61]	@ 0x3d
            buttonInfo.token          = content->tagValueDetails.detailsButtonToken;
c0de5662:	f895 002c 	ldrb.w	r0, [r5, #44]	@ 0x2c
            buttonInfo.icon           = content->tagValueDetails.detailsButtonIcon;
c0de5666:	910e      	str	r1, [sp, #56]	@ 0x38
            buttonInfo.text           = content->tagValueDetails.detailsButtonText;
c0de5668:	920d      	str	r2, [sp, #52]	@ 0x34
c0de566a:	e03b      	b.n	c0de56e4 <nbgl_pageDrawGenericContentExt+0x3d4>
            if (!headerAdded) {
c0de566c:	f1b8 0f00 	cmp.w	r8, #0
c0de5670:	d10c      	bne.n	c0de568c <nbgl_pageDrawGenericContentExt+0x37c>
c0de5672:	2000      	movs	r0, #0
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de5674:	9011      	str	r0, [sp, #68]	@ 0x44
c0de5676:	e9cd 000f 	strd	r0, r0, [sp, #60]	@ 0x3c
c0de567a:	e9cd 000d 	strd	r0, r0, [sp, #52]	@ 0x34
c0de567e:	2028      	movs	r0, #40	@ 0x28
c0de5680:	f8ad 0038 	strh.w	r0, [sp, #56]	@ 0x38
c0de5684:	a90d      	add	r1, sp, #52	@ 0x34
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de5686:	4650      	mov	r0, sl
c0de5688:	f7fe fd91 	bl	c0de41ae <nbgl_layoutAddHeader>
            nbgl_layoutAddTagValueList(layout, &content->tagValueConfirm.tagValueList);
c0de568c:	f105 0110 	add.w	r1, r5, #16
c0de5690:	4650      	mov	r0, sl
c0de5692:	f7fe f9ef 	bl	c0de3a74 <nbgl_layoutAddTagValueList>
            if (content->tagValueConfirm.detailsButtonText != NULL) {
c0de5696:	6aa8      	ldr	r0, [r5, #40]	@ 0x28
c0de5698:	2800      	cmp	r0, #0
c0de569a:	f000 80bc 	beq.w	c0de5816 <nbgl_pageDrawGenericContentExt+0x506>
c0de569e:	2101      	movs	r1, #1
                buttonInfo.fittingContent = true;
c0de56a0:	f8ad 103e 	strh.w	r1, [sp, #62]	@ 0x3e
                buttonInfo.style          = WHITE_BACKGROUND;
c0de56a4:	f88d 103d 	strb.w	r1, [sp, #61]	@ 0x3d
                buttonInfo.text           = content->tagValueConfirm.detailsButtonText;
c0de56a8:	900d      	str	r0, [sp, #52]	@ 0x34
                buttonInfo.token          = content->tagValueConfirm.detailsButtonToken;
c0de56aa:	f895 002c 	ldrb.w	r0, [r5, #44]	@ 0x2c
                buttonInfo.tuneId         = content->tagValueConfirm.tuneId;
c0de56ae:	f895 102d 	ldrb.w	r1, [r5, #45]	@ 0x2d
                buttonInfo.icon           = content->tagValueConfirm.detailsButtonIcon;
c0de56b2:	6a6a      	ldr	r2, [r5, #36]	@ 0x24
                buttonInfo.token          = content->tagValueConfirm.detailsButtonToken;
c0de56b4:	f88d 003c 	strb.w	r0, [sp, #60]	@ 0x3c
                buttonInfo.tuneId         = content->tagValueConfirm.tuneId;
c0de56b8:	f88d 1040 	strb.w	r1, [sp, #64]	@ 0x40
c0de56bc:	a90d      	add	r1, sp, #52	@ 0x34
                nbgl_layoutAddButton(layout, &buttonInfo);
c0de56be:	4650      	mov	r0, sl
                buttonInfo.icon           = content->tagValueConfirm.detailsButtonIcon;
c0de56c0:	920e      	str	r2, [sp, #56]	@ 0x38
                nbgl_layoutAddButton(layout, &buttonInfo);
c0de56c2:	f7fe fc17 	bl	c0de3ef4 <nbgl_layoutAddButton>
            if (content->tagValueConfirm.confirmationText != NULL) {
c0de56c6:	6b28      	ldr	r0, [r5, #48]	@ 0x30
c0de56c8:	2800      	cmp	r0, #0
c0de56ca:	f000 809d 	beq.w	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
c0de56ce:	f44f 7180 	mov.w	r1, #256	@ 0x100
                buttonInfo.fittingContent = false;
c0de56d2:	f8ad 103e 	strh.w	r1, [sp, #62]	@ 0x3e
c0de56d6:	2100      	movs	r1, #0
                buttonInfo.text           = content->tagValueConfirm.confirmationText;
c0de56d8:	900d      	str	r0, [sp, #52]	@ 0x34
                buttonInfo.token          = content->tagValueConfirm.confirmationToken;
c0de56da:	f895 0038 	ldrb.w	r0, [r5, #56]	@ 0x38
                buttonInfo.icon           = NULL;
c0de56de:	910e      	str	r1, [sp, #56]	@ 0x38
                buttonInfo.style          = BLACK_BACKGROUND;
c0de56e0:	f88d 103d 	strb.w	r1, [sp, #61]	@ 0x3d
c0de56e4:	f895 102d 	ldrb.w	r1, [r5, #45]	@ 0x2d
c0de56e8:	f88d 003c 	strb.w	r0, [sp, #60]	@ 0x3c
c0de56ec:	f88d 1040 	strb.w	r1, [sp, #64]	@ 0x40
c0de56f0:	a90d      	add	r1, sp, #52	@ 0x34
c0de56f2:	e036      	b.n	c0de5762 <nbgl_pageDrawGenericContentExt+0x452>
c0de56f4:	ae0d      	add	r6, sp, #52	@ 0x34
            nbgl_contentCenter_t centeredInfo = {0};
c0de56f6:	4630      	mov	r0, r6
c0de56f8:	2124      	movs	r1, #36	@ 0x24
c0de56fa:	f003 fdf3 	bl	c0de92e4 <__aeabi_memclr>
            centeredInfo.title                = content->infoLongPress.text;
c0de56fe:	e9d5 1004 	ldrd	r1, r0, [r5, #16]
            centeredInfo.icon                 = content->infoLongPress.icon;
c0de5702:	900e      	str	r0, [sp, #56]	@ 0x38
c0de5704:	2000      	movs	r0, #0
            centeredInfo.title                = content->infoLongPress.text;
c0de5706:	9111      	str	r1, [sp, #68]	@ 0x44
            centeredInfo.illustrType          = ICON_ILLUSTRATION;
c0de5708:	f88d 0034 	strb.w	r0, [sp, #52]	@ 0x34
            nbgl_layoutAddContentCenter(layout, &centeredInfo);
c0de570c:	4650      	mov	r0, sl
c0de570e:	4631      	mov	r1, r6
c0de5710:	f7fd ffd4 	bl	c0de36bc <nbgl_layoutAddContentCenter>
                                          content->infoLongPress.longPressText,
c0de5714:	69a9      	ldr	r1, [r5, #24]
                                          content->infoLongPress.longPressToken,
c0de5716:	7f2a      	ldrb	r2, [r5, #28]
                                          content->infoLongPress.tuneId);
c0de5718:	7f6b      	ldrb	r3, [r5, #29]
            nbgl_layoutAddLongPressButton(layout,
c0de571a:	4650      	mov	r0, sl
c0de571c:	f7fe fd0a 	bl	c0de4134 <nbgl_layoutAddLongPressButton>
c0de5720:	e072      	b.n	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
c0de5722:	ae0d      	add	r6, sp, #52	@ 0x34
            nbgl_contentCenter_t centeredInfo = {0};
c0de5724:	4630      	mov	r0, r6
c0de5726:	2124      	movs	r1, #36	@ 0x24
c0de5728:	f003 fddc 	bl	c0de92e4 <__aeabi_memclr>
            centeredInfo.title       = content->infoButton.text;
c0de572c:	e9d5 1004 	ldrd	r1, r0, [r5, #16]
c0de5730:	2400      	movs	r4, #0
            centeredInfo.icon        = content->infoButton.icon;
c0de5732:	900e      	str	r0, [sp, #56]	@ 0x38
            centeredInfo.title       = content->infoButton.text;
c0de5734:	9111      	str	r1, [sp, #68]	@ 0x44
            nbgl_layoutAddContentCenter(layout, &centeredInfo);
c0de5736:	4650      	mov	r0, sl
c0de5738:	4631      	mov	r1, r6
            centeredInfo.illustrType = ICON_ILLUSTRATION;
c0de573a:	f88d 4034 	strb.w	r4, [sp, #52]	@ 0x34
            nbgl_layoutAddContentCenter(layout, &centeredInfo);
c0de573e:	f7fd ffbd 	bl	c0de36bc <nbgl_layoutAddContentCenter>
c0de5742:	f44f 7080 	mov.w	r0, #256	@ 0x100
            buttonInfo.fittingContent = false;
c0de5746:	f8ad 002e 	strh.w	r0, [sp, #46]	@ 0x2e
            buttonInfo.text           = content->infoButton.buttonText;
c0de574a:	69a8      	ldr	r0, [r5, #24]
            buttonInfo.tuneId         = content->infoButton.tuneId;
c0de574c:	7f69      	ldrb	r1, [r5, #29]
            buttonInfo.text           = content->infoButton.buttonText;
c0de574e:	9009      	str	r0, [sp, #36]	@ 0x24
            buttonInfo.token          = content->infoButton.buttonToken;
c0de5750:	7f28      	ldrb	r0, [r5, #28]
            buttonInfo.icon           = NULL;
c0de5752:	940a      	str	r4, [sp, #40]	@ 0x28
            buttonInfo.style          = BLACK_BACKGROUND;
c0de5754:	f88d 402d 	strb.w	r4, [sp, #45]	@ 0x2d
            buttonInfo.token          = content->infoButton.buttonToken;
c0de5758:	f88d 002c 	strb.w	r0, [sp, #44]	@ 0x2c
            buttonInfo.tuneId         = content->infoButton.tuneId;
c0de575c:	f88d 1030 	strb.w	r1, [sp, #48]	@ 0x30
c0de5760:	a909      	add	r1, sp, #36	@ 0x24
c0de5762:	4650      	mov	r0, sl
c0de5764:	f7fe fbc6 	bl	c0de3ef4 <nbgl_layoutAddButton>
c0de5768:	e04e      	b.n	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
            for (i = 0; i < content->infosList.nbInfos; i++) {
c0de576a:	7f28      	ldrb	r0, [r5, #28]
c0de576c:	2800      	cmp	r0, #0
c0de576e:	d04b      	beq.n	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
c0de5770:	2600      	movs	r6, #0
c0de5772:	2400      	movs	r4, #0
c0de5774:	e006      	b.n	c0de5784 <nbgl_pageDrawGenericContentExt+0x474>
c0de5776:	bf00      	nop
c0de5778:	7f28      	ldrb	r0, [r5, #28]
c0de577a:	3401      	adds	r4, #1
c0de577c:	4284      	cmp	r4, r0
c0de577e:	f106 0618 	add.w	r6, r6, #24
c0de5782:	d241      	bcs.n	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
                if ((content->infosList.withExtensions == true)
c0de5784:	7fa8      	ldrb	r0, [r5, #30]
c0de5786:	b198      	cbz	r0, c0de57b0 <nbgl_pageDrawGenericContentExt+0x4a0>
                    && (content->infosList.infoExtensions != NULL)
c0de5788:	69a8      	ldr	r0, [r5, #24]
c0de578a:	b188      	cbz	r0, c0de57b0 <nbgl_pageDrawGenericContentExt+0x4a0>
                    && (content->infosList.infoExtensions[i].fullValue != NULL)) {
c0de578c:	5980      	ldr	r0, [r0, r6]
c0de578e:	b178      	cbz	r0, c0de57b0 <nbgl_pageDrawGenericContentExt+0x4a0>
                                                       content->infosList.infoTypes[i],
c0de5790:	e9d5 0204 	ldrd	r0, r2, [r5, #16]
                                                       content->infosList.token,
c0de5794:	7f6b      	ldrb	r3, [r5, #29]
                                                       content->infosList.infoTypes[i],
c0de5796:	f850 1024 	ldr.w	r1, [r0, r4, lsl #2]
                                                       content->infosList.infoContents[i],
c0de579a:	f852 2024 	ldr.w	r2, [r2, r4, lsl #2]
                        -= nbgl_layoutAddTextWithAlias(layout,
c0de579e:	fa5f fc84 	uxtb.w	ip, r4
c0de57a2:	4650      	mov	r0, sl
c0de57a4:	f8cd c000 	str.w	ip, [sp]
c0de57a8:	f7fd f990 	bl	c0de2acc <nbgl_layoutAddTextWithAlias>
c0de57ac:	e009      	b.n	c0de57c2 <nbgl_pageDrawGenericContentExt+0x4b2>
c0de57ae:	bf00      	nop
                                                          content->infosList.infoTypes[i],
c0de57b0:	e9d5 0204 	ldrd	r0, r2, [r5, #16]
c0de57b4:	f850 1024 	ldr.w	r1, [r0, r4, lsl #2]
                                                          content->infosList.infoContents[i]);
c0de57b8:	f852 2024 	ldr.w	r2, [r2, r4, lsl #2]
                    availableHeight -= nbgl_layoutAddText(layout,
c0de57bc:	4650      	mov	r0, sl
c0de57be:	f7fd f961 	bl	c0de2a84 <nbgl_layoutAddText>
c0de57c2:	1a3f      	subs	r7, r7, r0
c0de57c4:	b2b8      	uxth	r0, r7
                if (availableHeight > 10) {
c0de57c6:	280b      	cmp	r0, #11
c0de57c8:	d3d6      	bcc.n	c0de5778 <nbgl_pageDrawGenericContentExt+0x468>
                    nbgl_layoutAddSeparationLine(layout);
c0de57ca:	4650      	mov	r0, sl
c0de57cc:	f7fe fb59 	bl	c0de3e82 <nbgl_layoutAddSeparationLine>
c0de57d0:	e7d2      	b.n	c0de5778 <nbgl_pageDrawGenericContentExt+0x468>
            nbgl_layoutAddRadioChoice(layout, &content->choicesList);
c0de57d2:	f105 0110 	add.w	r1, r5, #16
c0de57d6:	4650      	mov	r0, sl
c0de57d8:	f7fd fabc 	bl	c0de2d54 <nbgl_layoutAddRadioChoice>
c0de57dc:	e014      	b.n	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>
            if (!headerAdded) {
c0de57de:	f1b8 0f00 	cmp.w	r8, #0
c0de57e2:	d10c      	bne.n	c0de57fe <nbgl_pageDrawGenericContentExt+0x4ee>
c0de57e4:	2000      	movs	r0, #0
        = {.type = HEADER_EMPTY, .separationLine = false, .emptySpace.height = height};
c0de57e6:	9011      	str	r0, [sp, #68]	@ 0x44
c0de57e8:	e9cd 000f 	strd	r0, r0, [sp, #60]	@ 0x3c
c0de57ec:	e9cd 000d 	strd	r0, r0, [sp, #52]	@ 0x34
c0de57f0:	2028      	movs	r0, #40	@ 0x28
c0de57f2:	f8ad 0038 	strh.w	r0, [sp, #56]	@ 0x38
c0de57f6:	a90d      	add	r1, sp, #52	@ 0x34
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de57f8:	4650      	mov	r0, sl
c0de57fa:	f7fe fcd8 	bl	c0de41ae <nbgl_layoutAddHeader>
            nbgl_layoutAddCenteredInfo(layout, &content->centeredInfo);
c0de57fe:	f105 0110 	add.w	r1, r5, #16
c0de5802:	4650      	mov	r0, sl
c0de5804:	f7fd fbfe 	bl	c0de3004 <nbgl_layoutAddCenteredInfo>
            }
#endif  // TARGET_STAX
        }
    }
    addContent(content, layout, availableHeight, headerAdded);
    nbgl_layoutDraw(layout);
c0de5808:	4650      	mov	r0, sl
c0de580a:	f7ff f920 	bl	c0de4a4e <nbgl_layoutDraw>

    return (nbgl_page_t *) layout;
c0de580e:	4650      	mov	r0, sl
c0de5810:	b016      	add	sp, #88	@ 0x58
c0de5812:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            else if ((content->tagValueConfirm.detailsButtonIcon != NULL)
c0de5816:	6a68      	ldr	r0, [r5, #36]	@ 0x24
                     && (content->tagValueConfirm.confirmationText != NULL)) {
c0de5818:	2800      	cmp	r0, #0
c0de581a:	f43f af54 	beq.w	c0de56c6 <nbgl_pageDrawGenericContentExt+0x3b6>
c0de581e:	6b29      	ldr	r1, [r5, #48]	@ 0x30
            else if ((content->tagValueConfirm.detailsButtonIcon != NULL)
c0de5820:	2900      	cmp	r1, #0
c0de5822:	f43f af50 	beq.w	c0de56c6 <nbgl_pageDrawGenericContentExt+0x3b6>
                    = {.leftIcon   = content->tagValueConfirm.detailsButtonIcon,
c0de5826:	e9cd 010d 	strd	r0, r1, [sp, #52]	@ 0x34
                       .leftToken  = content->tagValueConfirm.detailsButtonToken,
c0de582a:	f895 002c 	ldrb.w	r0, [r5, #44]	@ 0x2c
                       .tuneId     = content->tagValueConfirm.tuneId};
c0de582e:	f895 102d 	ldrb.w	r1, [r5, #45]	@ 0x2d
                       .rightToken = content->tagValueConfirm.confirmationToken,
c0de5832:	f895 2038 	ldrb.w	r2, [r5, #56]	@ 0x38
                    = {.leftIcon   = content->tagValueConfirm.detailsButtonIcon,
c0de5836:	f88d 003c 	strb.w	r0, [sp, #60]	@ 0x3c
c0de583a:	f88d 103e 	strb.w	r1, [sp, #62]	@ 0x3e
c0de583e:	a90d      	add	r1, sp, #52	@ 0x34
                nbgl_layoutAddHorizontalButtons(layout, &choice);
c0de5840:	4650      	mov	r0, sl
                    = {.leftIcon   = content->tagValueConfirm.detailsButtonIcon,
c0de5842:	f88d 203d 	strb.w	r2, [sp, #61]	@ 0x3d
                nbgl_layoutAddHorizontalButtons(layout, &choice);
c0de5846:	f7fe f900 	bl	c0de3a4a <nbgl_layoutAddHorizontalButtons>
c0de584a:	e7dd      	b.n	c0de5808 <nbgl_pageDrawGenericContentExt+0x4f8>

c0de584c <nbgl_pageDrawGenericContent>:
 * @return the page context (or NULL if error)
 */
nbgl_page_t *nbgl_pageDrawGenericContent(nbgl_layoutTouchCallback_t       onActionCallback,
                                         const nbgl_pageNavigationInfo_t *nav,
                                         nbgl_pageContent_t              *content)
{
c0de584c:	b580      	push	{r7, lr}
    return nbgl_pageDrawGenericContentExt(onActionCallback, nav, content, false);
c0de584e:	2300      	movs	r3, #0
c0de5850:	f7ff fd5e 	bl	c0de5310 <nbgl_pageDrawGenericContentExt>
c0de5854:	bd80      	pop	{r7, pc}

c0de5856 <nbgl_pageRelease>:
 *
 * @param page page to release
 * @return >= 0 if OK
 */
int nbgl_pageRelease(nbgl_page_t *page)
{
c0de5856:	b580      	push	{r7, lr}
    int ret;

    LOG_DEBUG(PAGE_LOGGER, "nbgl_pageRelease(): \n");
    ret = nbgl_layoutRelease((nbgl_layout_t *) page);
c0de5858:	f7ff f91d 	bl	c0de4a96 <nbgl_layoutRelease>

    return ret;
c0de585c:	bd80      	pop	{r7, pc}
	...

c0de5860 <getNbTagValuesInPage>:
                                    uint8_t                           startIndex,
                                    bool                              isSkippable,
                                    bool                              hasConfirmationButton,
                                    bool                              hasDetailsButton,
                                    bool                             *requireSpecificDisplay)
{
c0de5860:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de5864:	b084      	sub	sp, #16
c0de5866:	468b      	mov	fp, r1
c0de5868:	990e      	ldr	r1, [sp, #56]	@ 0x38
c0de586a:	4615      	mov	r5, r2
c0de586c:	4604      	mov	r4, r0
c0de586e:	f44f 70e8 	mov.w	r0, #464	@ 0x1d0
c0de5872:	f04f 0800 	mov.w	r8, #0
c0de5876:	2600      	movs	r6, #0
    uint16_t currentHeight   = PRE_TAG_VALUE_MARGIN;  // upper margin
    uint16_t maxUsableHeight = TAG_VALUE_AREA_HEIGHT;

    // if the review is skippable, it means that there is less height for tag/value pairs
    // the small centering header becomes a touchable header
    if (isSkippable) {
c0de5878:	2b00      	cmp	r3, #0
c0de587a:	bf18      	it	ne
c0de587c:	f44f 70cc 	movne.w	r0, #408	@ 0x198
c0de5880:	9003      	str	r0, [sp, #12]
        maxUsableHeight -= TOUCHABLE_HEADER_BAR_HEIGHT - SMALL_CENTERING_HEADER;
    }

    *requireSpecificDisplay = false;
c0de5882:	f881 8000 	strb.w	r8, [r1]
c0de5886:	e9cd 2401 	strd	r2, r4, [sp, #4]
c0de588a:	e009      	b.n	c0de58a0 <getNbTagValuesInPage+0x40>
            // This pair must be at the top of a page
            break;
        }

        if (pair->centeredInfo) {
            if (nbPairsInPage > 0) {
c0de588c:	f1ba 0f00 	cmp.w	sl, #0
c0de5890:	d002      	beq.n	c0de5898 <getNbTagValuesInPage+0x38>
c0de5892:	2000      	movs	r0, #0
c0de5894:	b920      	cbnz	r0, c0de58a0 <getNbTagValuesInPage+0x40>
c0de5896:	e05c      	b.n	c0de5952 <getNbTagValuesInPage+0xf2>
                break;
            }
            else {
                // This pair is the only one of the page and has a specific display behavior
                nbPairsInPage           = 1;
                *requireSpecificDisplay = true;
c0de5898:	980e      	ldr	r0, [sp, #56]	@ 0x38
c0de589a:	2601      	movs	r6, #1
c0de589c:	7006      	strb	r6, [r0, #0]
c0de589e:	e7f8      	b.n	c0de5892 <getNbTagValuesInPage+0x32>
    while (nbPairsInPage < nbPairs) {
c0de58a0:	b2f0      	uxtb	r0, r6
c0de58a2:	42a0      	cmp	r0, r4
c0de58a4:	d255      	bcs.n	c0de5952 <getNbTagValuesInPage+0xf2>
        if (tagValueList->pairs != NULL) {
c0de58a6:	f8db 1000 	ldr.w	r1, [fp]
        if (nbPairsInPage > 0) {
c0de58aa:	ea5f 6a06 	movs.w	sl, r6, lsl #24
c0de58ae:	bf18      	it	ne
c0de58b0:	f108 0818 	addne.w	r8, r8, #24
        if (tagValueList->pairs != NULL) {
c0de58b4:	b121      	cbz	r1, c0de58c0 <getNbTagValuesInPage+0x60>
            pair = PIC(&tagValueList->pairs[startIndex + nbPairsInPage]);
c0de58b6:	4428      	add	r0, r5
c0de58b8:	eb01 1000 	add.w	r0, r1, r0, lsl #4
c0de58bc:	e005      	b.n	c0de58ca <getNbTagValuesInPage+0x6a>
c0de58be:	bf00      	nop
            pair = PIC(tagValueList->callback(startIndex + nbPairsInPage));
c0de58c0:	f8db 1004 	ldr.w	r1, [fp, #4]
c0de58c4:	1970      	adds	r0, r6, r5
c0de58c6:	b2c0      	uxtb	r0, r0
c0de58c8:	4788      	blx	r1
c0de58ca:	f003 fb17 	bl	c0de8efc <pic>
c0de58ce:	4607      	mov	r7, r0
        if (pair->forcePageStart && nbPairsInPage > 0) {
c0de58d0:	7b00      	ldrb	r0, [r0, #12]
c0de58d2:	07c1      	lsls	r1, r0, #31
c0de58d4:	bf18      	it	ne
c0de58d6:	f1ba 0f00 	cmpne.w	sl, #0
c0de58da:	d1da      	bne.n	c0de5892 <getNbTagValuesInPage+0x32>
        if (pair->centeredInfo) {
c0de58dc:	0780      	lsls	r0, r0, #30
c0de58de:	d4d5      	bmi.n	c0de588c <getNbTagValuesInPage+0x2c>
            }
        }

        // tag height
        currentHeight += nbgl_getTextHeightInWidth(
            SMALL_REGULAR_FONT, pair->item, AVAILABLE_WIDTH, tagValueList->wrapping);
c0de58e0:	6839      	ldr	r1, [r7, #0]
c0de58e2:	f89b 300e 	ldrb.w	r3, [fp, #14]
        currentHeight += nbgl_getTextHeightInWidth(
c0de58e6:	200b      	movs	r0, #11
c0de58e8:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de58ec:	f002 fc2c 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de58f0:	4605      	mov	r5, r0
        // space between tag and value
        currentHeight += 4;
        // set value font
        if (tagValueList->smallCaseForValue) {
c0de58f2:	f89b 000d 	ldrb.w	r0, [fp, #13]
        else {
            value_font = LARGE_MEDIUM_FONT;
        }
        // value height
        currentHeight += nbgl_getTextHeightInWidth(
            value_font, pair->value, AVAILABLE_WIDTH, tagValueList->wrapping);
c0de58f6:	6879      	ldr	r1, [r7, #4]
c0de58f8:	f89b 300e 	ldrb.w	r3, [fp, #14]
        currentHeight += nbgl_getTextHeightInWidth(
c0de58fc:	240b      	movs	r4, #11
c0de58fe:	2800      	cmp	r0, #0
c0de5900:	bf08      	it	eq
c0de5902:	240d      	moveq	r4, #13
c0de5904:	4620      	mov	r0, r4
c0de5906:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de590a:	f002 fc1d 	bl	c0de8148 <nbgl_getTextHeightInWidth>
        currentHeight += nbgl_getTextHeightInWidth(
c0de590e:	eb08 0105 	add.w	r1, r8, r5
        currentHeight += 4;
c0de5912:	4408      	add	r0, r1
        // nb lines for value
        nbLines = nbgl_getTextNbLinesInWidth(
            value_font, pair->value, AVAILABLE_WIDTH, tagValueList->wrapping);
c0de5914:	6879      	ldr	r1, [r7, #4]
c0de5916:	f89b 300e 	ldrb.w	r3, [fp, #14]
        currentHeight += nbgl_getTextHeightInWidth(
c0de591a:	f100 0804 	add.w	r8, r0, #4
        nbLines = nbgl_getTextNbLinesInWidth(
c0de591e:	4620      	mov	r0, r4
c0de5920:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de5924:	f002 fc15 	bl	c0de8152 <nbgl_getTextNbLinesInWidth>
        if ((currentHeight >= maxUsableHeight) || (nbLines > NB_MAX_LINES_IN_REVIEW)) {
c0de5928:	9a03      	ldr	r2, [sp, #12]
c0de592a:	fa1f f188 	uxth.w	r1, r8
c0de592e:	428a      	cmp	r2, r1
c0de5930:	d904      	bls.n	c0de593c <getNbTagValuesInPage+0xdc>
c0de5932:	280a      	cmp	r0, #10
c0de5934:	d202      	bcs.n	c0de593c <getNbTagValuesInPage+0xdc>
                nbPairsInPage           = 1;
                *requireSpecificDisplay = true;
            }
            break;
        }
        nbPairsInPage++;
c0de5936:	3601      	adds	r6, #1
c0de5938:	2001      	movs	r0, #1
c0de593a:	e006      	b.n	c0de594a <getNbTagValuesInPage+0xea>
            if (nbPairsInPage == 0) {
c0de593c:	f1ba 0f00 	cmp.w	sl, #0
c0de5940:	d102      	bne.n	c0de5948 <getNbTagValuesInPage+0xe8>
                *requireSpecificDisplay = true;
c0de5942:	980e      	ldr	r0, [sp, #56]	@ 0x38
c0de5944:	2601      	movs	r6, #1
c0de5946:	7006      	strb	r6, [r0, #0]
c0de5948:	2000      	movs	r0, #0
c0de594a:	e9dd 5401 	ldrd	r5, r4, [sp, #4]
c0de594e:	2800      	cmp	r0, #0
c0de5950:	d1a6      	bne.n	c0de58a0 <getNbTagValuesInPage+0x40>
    }
    // if this is a TAG_VALUE_CONFIRM and we have reached the last pairs,
    // let's check if it still fits with a CONFIRMATION button, and if not,
    // remove the last pair
    if (hasConfirmationButton && (nbPairsInPage == nbPairs)) {
c0de5952:	980c      	ldr	r0, [sp, #48]	@ 0x30
c0de5954:	b150      	cbz	r0, c0de596c <getNbTagValuesInPage+0x10c>
c0de5956:	b2f0      	uxtb	r0, r6
c0de5958:	42a0      	cmp	r0, r4
c0de595a:	d107      	bne.n	c0de596c <getNbTagValuesInPage+0x10c>
        maxUsableHeight -= UP_FOOTER_BUTTON_HEIGHT;
c0de595c:	9803      	ldr	r0, [sp, #12]
        if (currentHeight > maxUsableHeight) {
c0de595e:	fa1f f188 	uxth.w	r1, r8
        maxUsableHeight -= UP_FOOTER_BUTTON_HEIGHT;
c0de5962:	f500 70bc 	add.w	r0, r0, #376	@ 0x178
        if (currentHeight > maxUsableHeight) {
c0de5966:	f400 70ac 	and.w	r0, r0, #344	@ 0x158
c0de596a:	e008      	b.n	c0de597e <getNbTagValuesInPage+0x11e>
            nbPairsInPage--;
        }
    }
    // do the same with just a details button
    else if (hasDetailsButton) {
c0de596c:	980d      	ldr	r0, [sp, #52]	@ 0x34
c0de596e:	b148      	cbz	r0, c0de5984 <getNbTagValuesInPage+0x124>
        maxUsableHeight -= (SMALL_BUTTON_RADIUS * 2);
c0de5970:	9803      	ldr	r0, [sp, #12]
        if (currentHeight > maxUsableHeight) {
c0de5972:	fa1f f188 	uxth.w	r1, r8
        maxUsableHeight -= (SMALL_BUTTON_RADIUS * 2);
c0de5976:	f500 70e0 	add.w	r0, r0, #448	@ 0x1c0
        if (currentHeight > maxUsableHeight) {
c0de597a:	f400 70ec 	and.w	r0, r0, #472	@ 0x1d8
c0de597e:	4288      	cmp	r0, r1
c0de5980:	bf38      	it	cc
c0de5982:	3e01      	subcc	r6, #1
            nbPairsInPage--;
        }
    }
    return nbPairsInPage;
c0de5984:	b2f0      	uxtb	r0, r6
c0de5986:	b004      	add	sp, #16
c0de5988:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de598c <nbgl_useCaseGetNbSwitchesInPage>:
 */
uint8_t nbgl_useCaseGetNbSwitchesInPage(uint8_t                           nbSwitches,
                                        const nbgl_contentSwitchesList_t *switchesList,
                                        uint8_t                           startIndex,
                                        bool                              withNav)
{
c0de598c:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
    uint8_t               nbSwitchesInPage = 0;
    uint16_t              currentHeight    = 0;
    uint16_t              previousHeight   = 0;
    uint16_t              navHeight        = withNav ? SIMPLE_FOOTER_HEIGHT : 0;
    nbgl_contentSwitch_t *switchArray      = (nbgl_contentSwitch_t *) PIC(switchesList->switches);
c0de5990:	6809      	ldr	r1, [r1, #0]
c0de5992:	4682      	mov	sl, r0
c0de5994:	4608      	mov	r0, r1
c0de5996:	4698      	mov	r8, r3
c0de5998:	4616      	mov	r6, r2
c0de599a:	f003 faaf 	bl	c0de8efc <pic>

    while (nbSwitchesInPage < nbSwitches) {
c0de599e:	eb06 0146 	add.w	r1, r6, r6, lsl #1
c0de59a2:	eb00 0081 	add.w	r0, r0, r1, lsl #2
c0de59a6:	f44f 7bfc 	mov.w	fp, #504	@ 0x1f8
c0de59aa:	1d05      	adds	r5, r0, #4
c0de59ac:	2600      	movs	r6, #0
c0de59ae:	2400      	movs	r4, #0
c0de59b0:	2700      	movs	r7, #0
c0de59b2:	f1b8 0f00 	cmp.w	r8, #0
c0de59b6:	bf18      	it	ne
c0de59b8:	f44f 7bcc 	movne.w	fp, #408	@ 0x198
c0de59bc:	e009      	b.n	c0de59d2 <nbgl_useCaseGetNbSwitchesInPage+0x46>
c0de59be:	bf00      	nop
            // sub-text height
            currentHeight += nbgl_getTextHeightInWidth(
                SMALL_REGULAR_FONT, curSwitch->subText, AVAILABLE_WIDTH, true);
        }
        // if height is over the limit
        if (currentHeight >= (INFOS_AREA_HEIGHT - navHeight)) {
c0de59c0:	b2b8      	uxth	r0, r7
c0de59c2:	4583      	cmp	fp, r0
c0de59c4:	bf88      	it	hi
c0de59c6:	463c      	movhi	r4, r7
c0de59c8:	3601      	adds	r6, #1
c0de59ca:	4583      	cmp	fp, r0
c0de59cc:	f105 050c 	add.w	r5, r5, #12
c0de59d0:	d926      	bls.n	c0de5a20 <nbgl_useCaseGetNbSwitchesInPage+0x94>
    while (nbSwitchesInPage < nbSwitches) {
c0de59d2:	45b2      	cmp	sl, r6
c0de59d4:	d027      	beq.n	c0de5a26 <nbgl_useCaseGetNbSwitchesInPage+0x9a>
        uint16_t textHeight = MAX(
c0de59d6:	f855 1c04 	ldr.w	r1, [r5, #-4]
c0de59da:	200c      	movs	r0, #12
c0de59dc:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de59e0:	2301      	movs	r3, #1
c0de59e2:	f002 fbb1 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de59e6:	2828      	cmp	r0, #40	@ 0x28
c0de59e8:	d202      	bcs.n	c0de59f0 <nbgl_useCaseGetNbSwitchesInPage+0x64>
c0de59ea:	2028      	movs	r0, #40	@ 0x28
c0de59ec:	e008      	b.n	c0de5a00 <nbgl_useCaseGetNbSwitchesInPage+0x74>
c0de59ee:	bf00      	nop
c0de59f0:	f855 1c04 	ldr.w	r1, [r5, #-4]
c0de59f4:	200c      	movs	r0, #12
c0de59f6:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de59fa:	2301      	movs	r3, #1
c0de59fc:	f002 fba4 	bl	c0de8148 <nbgl_getTextHeightInWidth>
        if (curSwitch->subText) {
c0de5a00:	6829      	ldr	r1, [r5, #0]
        currentHeight += textHeight + 2 * LIST_ITEM_PRE_HEADING;
c0de5a02:	4438      	add	r0, r7
        if (curSwitch->subText) {
c0de5a04:	2900      	cmp	r1, #0
        currentHeight += textHeight + 2 * LIST_ITEM_PRE_HEADING;
c0de5a06:	f100 0734 	add.w	r7, r0, #52	@ 0x34
        if (curSwitch->subText) {
c0de5a0a:	d0d9      	beq.n	c0de59c0 <nbgl_useCaseGetNbSwitchesInPage+0x34>
            currentHeight += nbgl_getTextHeightInWidth(
c0de5a0c:	200b      	movs	r0, #11
c0de5a0e:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de5a12:	2301      	movs	r3, #1
c0de5a14:	f002 fb98 	bl	c0de8148 <nbgl_getTextHeightInWidth>
            currentHeight += LIST_ITEM_HEADING_SUB_TEXT;
c0de5a18:	4438      	add	r0, r7
            currentHeight += nbgl_getTextHeightInWidth(
c0de5a1a:	f100 070c 	add.w	r7, r0, #12
c0de5a1e:	e7cf      	b.n	c0de59c0 <nbgl_useCaseGetNbSwitchesInPage+0x34>
        if (currentHeight >= (INFOS_AREA_HEIGHT - navHeight)) {
c0de5a20:	bf98      	it	ls
c0de5a22:	3e01      	subls	r6, #1
c0de5a24:	46b2      	mov	sl, r6
c0de5a26:	b2a0      	uxth	r0, r4
c0de5a28:	08c0      	lsrs	r0, r0, #3
c0de5a2a:	2100      	movs	r1, #0
c0de5a2c:	2832      	cmp	r0, #50	@ 0x32
c0de5a2e:	bf88      	it	hi
c0de5a30:	2101      	movhi	r1, #1
        previousHeight = currentHeight;
        nbSwitchesInPage++;
    }
    // if there was no nav, now there will be, so it can be necessary to remove the last
    // item
    if (!withNav && (previousHeight >= (INFOS_AREA_HEIGHT - SIMPLE_FOOTER_HEIGHT))) {
c0de5a32:	ea21 0008 	bic.w	r0, r1, r8
c0de5a36:	ebaa 0000 	sub.w	r0, sl, r0
        nbSwitchesInPage--;
    }
    return nbSwitchesInPage;
c0de5a3a:	b2c0      	uxtb	r0, r0
c0de5a3c:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de5a40 <useCaseHomeExt>:
{
c0de5a40:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de5a44:	b090      	sub	sp, #64	@ 0x40
c0de5a46:	460f      	mov	r7, r1
c0de5a48:	9c18      	ldr	r4, [sp, #96]	@ 0x60
c0de5a4a:	4683      	mov	fp, r0
c0de5a4c:	a803      	add	r0, sp, #12
    nbgl_pageInfoDescription_t info = {.centeredInfo.icon    = appIcon,
c0de5a4e:	2134      	movs	r1, #52	@ 0x34
c0de5a50:	461e      	mov	r6, r3
c0de5a52:	4615      	mov	r5, r2
c0de5a54:	f003 fc46 	bl	c0de92e4 <__aeabi_memclr>
c0de5a58:	2000      	movs	r0, #0
c0de5a5a:	2103      	movs	r1, #3
c0de5a5c:	f8cd b00c 	str.w	fp, [sp, #12]
c0de5a60:	9706      	str	r7, [sp, #24]
c0de5a62:	f88d 001d 	strb.w	r0, [sp, #29]
                                       .topRightStyle = withSettings ? SETTINGS_ICON : INFO_ICON,
c0de5a66:	2e00      	cmp	r6, #0
c0de5a68:	bf18      	it	ne
c0de5a6a:	2101      	movne	r1, #1
    nbgl_pageInfoDescription_t info = {.centeredInfo.icon    = appIcon,
c0de5a6c:	f88d 1020 	strb.w	r1, [sp, #32]
c0de5a70:	2104      	movs	r1, #4
c0de5a72:	f88d 1021 	strb.w	r1, [sp, #33]	@ 0x21
c0de5a76:	2106      	movs	r1, #6
c0de5a78:	f88d 1022 	strb.w	r1, [sp, #34]	@ 0x22
c0de5a7c:	2109      	movs	r1, #9
c0de5a7e:	f88d 103d 	strb.w	r1, [sp, #61]	@ 0x3d
    onNav           = NULL;
c0de5a82:	f240 4164 	movw	r1, #1124	@ 0x464
c0de5a86:	f2c0 0100 	movt	r1, #0
c0de5a8a:	f849 0001 	str.w	r0, [r9, r1]
    onControls      = NULL;
c0de5a8e:	f240 4168 	movw	r1, #1128	@ 0x468
c0de5a92:	f2c0 0100 	movt	r1, #0
c0de5a96:	f849 0001 	str.w	r0, [r9, r1]
    onContentAction = NULL;
c0de5a9a:	f240 61c0 	movw	r1, #1728	@ 0x6c0
c0de5a9e:	f2c0 0100 	movt	r1, #0
    onQuit          = NULL;
c0de5aa2:	f240 4a60 	movw	sl, #1120	@ 0x460
    onContinue      = NULL;
c0de5aa6:	f240 57e8 	movw	r7, #1512	@ 0x5e8
    onAction        = NULL;
c0de5aaa:	f240 56e4 	movw	r6, #1508	@ 0x5e4
    onContentAction = NULL;
c0de5aae:	f849 0001 	str.w	r0, [r9, r1]
    onChoice        = NULL;
c0de5ab2:	f240 51d8 	movw	r1, #1496	@ 0x5d8
    onQuit          = NULL;
c0de5ab6:	f2c0 0a00 	movt	sl, #0
    onContinue      = NULL;
c0de5aba:	f2c0 0700 	movt	r7, #0
    onAction        = NULL;
c0de5abe:	f2c0 0600 	movt	r6, #0
    onChoice        = NULL;
c0de5ac2:	f2c0 0100 	movt	r1, #0
    onQuit          = NULL;
c0de5ac6:	f849 000a 	str.w	r0, [r9, sl]
    onContinue      = NULL;
c0de5aca:	f849 0007 	str.w	r0, [r9, r7]
    onAction        = NULL;
c0de5ace:	f849 0006 	str.w	r0, [r9, r6]
    onChoice        = NULL;
c0de5ad2:	f849 0001 	str.w	r0, [r9, r1]
    memset(&genericContext, 0, sizeof(genericContext));
c0de5ad6:	f240 4074 	movw	r0, #1140	@ 0x474
c0de5ada:	f2c0 0000 	movt	r0, #0
c0de5ade:	4448      	add	r0, r9
c0de5ae0:	2190      	movs	r1, #144	@ 0x90
c0de5ae2:	f003 fbff 	bl	c0de92e4 <__aeabi_memclr>
    if ((homeAction->text != NULL) || (homeAction->icon != NULL)) {
c0de5ae6:	6820      	ldr	r0, [r4, #0]
c0de5ae8:	b918      	cbnz	r0, c0de5af2 <useCaseHomeExt+0xb2>
c0de5aea:	6861      	ldr	r1, [r4, #4]
c0de5aec:	2900      	cmp	r1, #0
c0de5aee:	f000 8085 	beq.w	c0de5bfc <useCaseHomeExt+0x1bc>
c0de5af2:	2108      	movs	r1, #8
        info.bottomButtonsToken = ACTION_BUTTON_TOKEN;
c0de5af4:	f88d 1023 	strb.w	r1, [sp, #35]	@ 0x23
        info.actionButtonIcon   = homeAction->icon;
c0de5af8:	e9d4 2101 	ldrd	r2, r1, [r4, #4]
        info.actionButtonText   = homeAction->text;
c0de5afc:	900d      	str	r0, [sp, #52]	@ 0x34
            = (homeAction->style == STRONG_HOME_ACTION) ? BLACK_BACKGROUND : WHITE_BACKGROUND;
c0de5afe:	7b20      	ldrb	r0, [r4, #12]
        onAction                = homeAction->callback;
c0de5b00:	f849 1006 	str.w	r1, [r9, r6]
        info.actionButtonIcon   = homeAction->icon;
c0de5b04:	920e      	str	r2, [sp, #56]	@ 0x38
            = (homeAction->style == STRONG_HOME_ACTION) ? BLACK_BACKGROUND : WHITE_BACKGROUND;
c0de5b06:	2800      	cmp	r0, #0
c0de5b08:	bf18      	it	ne
c0de5b0a:	2001      	movne	r0, #1
c0de5b0c:	f88d 003c 	strb.w	r0, [sp, #60]	@ 0x3c
c0de5b10:	e9dd 8419 	ldrd	r8, r4, [sp, #100]	@ 0x64
    if (tagline == NULL) {
c0de5b14:	2d00      	cmp	r5, #0
c0de5b16:	d157      	bne.n	c0de5bc8 <useCaseHomeExt+0x188>
        if (strlen(appName) > MAX_APP_NAME_FOR_SDK_TAGLINE) {
c0de5b18:	4658      	mov	r0, fp
c0de5b1a:	f003 fc35 	bl	c0de9388 <strlen>
c0de5b1e:	f240 6640 	movw	r6, #1600	@ 0x640
c0de5b22:	2814      	cmp	r0, #20
c0de5b24:	f2c0 0600 	movt	r6, #0
c0de5b28:	d313      	bcc.n	c0de5b52 <useCaseHomeExt+0x112>
            snprintf(tmpString,
c0de5b2a:	f644 5122 	movw	r1, #19746	@ 0x4d22
c0de5b2e:	f2c0 0100 	movt	r1, #0
c0de5b32:	4479      	add	r1, pc
c0de5b34:	46a4      	mov	ip, r4
c0de5b36:	c93c      	ldmia	r1!, {r2, r3, r4, r5}
c0de5b38:	eb09 0006 	add.w	r0, r9, r6
c0de5b3c:	c03c      	stmia	r0!, {r2, r3, r4, r5}
c0de5b3e:	c93c      	ldmia	r1!, {r2, r3, r4, r5}
c0de5b40:	46b6      	mov	lr, r6
c0de5b42:	c03c      	stmia	r0!, {r2, r3, r4, r5}
c0de5b44:	c97c      	ldmia	r1!, {r2, r3, r4, r5, r6}
c0de5b46:	8809      	ldrh	r1, [r1, #0]
c0de5b48:	c07c      	stmia	r0!, {r2, r3, r4, r5, r6}
c0de5b4a:	4676      	mov	r6, lr
c0de5b4c:	4664      	mov	r4, ip
c0de5b4e:	8001      	strh	r1, [r0, #0]
c0de5b50:	e016      	b.n	c0de5b80 <useCaseHomeExt+0x140>
            snprintf(tmpString,
c0de5b52:	f644 3039 	movw	r0, #19257	@ 0x4b39
c0de5b56:	f2c0 0000 	movt	r0, #0
c0de5b5a:	4478      	add	r0, pc
c0de5b5c:	9001      	str	r0, [sp, #4]
c0de5b5e:	f244 7279 	movw	r2, #18297	@ 0x4779
c0de5b62:	f2c0 0200 	movt	r2, #0
c0de5b66:	f644 433b 	movw	r3, #19515	@ 0x4c3b
c0de5b6a:	f2c0 0300 	movt	r3, #0
c0de5b6e:	eb09 0006 	add.w	r0, r9, r6
c0de5b72:	447a      	add	r2, pc
c0de5b74:	447b      	add	r3, pc
c0de5b76:	214a      	movs	r1, #74	@ 0x4a
c0de5b78:	f8cd b000 	str.w	fp, [sp]
c0de5b7c:	f003 f978 	bl	c0de8e70 <snprintf>
        if (nbgl_getTextNbLinesInWidth(SMALL_REGULAR_FONT, tmpString, AVAILABLE_WIDTH, false) > 3) {
c0de5b80:	eb09 0506 	add.w	r5, r9, r6
c0de5b84:	200b      	movs	r0, #11
c0de5b86:	4629      	mov	r1, r5
c0de5b88:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de5b8c:	2300      	movs	r3, #0
c0de5b8e:	f002 fae0 	bl	c0de8152 <nbgl_getTextNbLinesInWidth>
c0de5b92:	2804      	cmp	r0, #4
c0de5b94:	d318      	bcc.n	c0de5bc8 <useCaseHomeExt+0x188>
c0de5b96:	4630      	mov	r0, r6
            snprintf(tmpString,
c0de5b98:	f644 26db 	movw	r6, #19163	@ 0x4adb
c0de5b9c:	f2c0 0600 	movt	r6, #0
c0de5ba0:	f8cd b000 	str.w	fp, [sp]
c0de5ba4:	f244 727f 	movw	r2, #18303	@ 0x477f
c0de5ba8:	f2c0 0200 	movt	r2, #0
c0de5bac:	f644 33f3 	movw	r3, #19443	@ 0x4bf3
c0de5bb0:	eb09 0500 	add.w	r5, r9, r0
c0de5bb4:	f2c0 0300 	movt	r3, #0
c0de5bb8:	447e      	add	r6, pc
c0de5bba:	447a      	add	r2, pc
c0de5bbc:	447b      	add	r3, pc
c0de5bbe:	4628      	mov	r0, r5
c0de5bc0:	214a      	movs	r1, #74	@ 0x4a
c0de5bc2:	9601      	str	r6, [sp, #4]
c0de5bc4:	f003 f954 	bl	c0de8e70 <snprintf>
c0de5bc8:	9504      	str	r5, [sp, #16]
    onContinue = topRightCallback;
c0de5bca:	f849 8007 	str.w	r8, [r9, r7]
    onQuit     = quitCallback;
c0de5bce:	f849 400a 	str.w	r4, [r9, sl]
    pageContext = nbgl_pageDrawInfo(&pageCallback, NULL, &info);
c0de5bd2:	f640 3035 	movw	r0, #2869	@ 0xb35
c0de5bd6:	f2c0 0000 	movt	r0, #0
c0de5bda:	4478      	add	r0, pc
c0de5bdc:	aa03      	add	r2, sp, #12
c0de5bde:	2100      	movs	r1, #0
c0de5be0:	f7ff fa37 	bl	c0de5052 <nbgl_pageDrawInfo>
c0de5be4:	f240 51d4 	movw	r1, #1492	@ 0x5d4
c0de5be8:	f2c0 0100 	movt	r1, #0
c0de5bec:	f849 0001 	str.w	r0, [r9, r1]
    nbgl_refreshSpecial(FULL_COLOR_CLEAN_REFRESH);
c0de5bf0:	2002      	movs	r0, #2
c0de5bf2:	f002 fa59 	bl	c0de80a8 <nbgl_refreshSpecial>
}
c0de5bf6:	b010      	add	sp, #64	@ 0x40
c0de5bf8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de5bfc:	2002      	movs	r0, #2
        info.bottomButtonsToken = QUIT_TOKEN;
c0de5bfe:	f88d 0023 	strb.w	r0, [sp, #35]	@ 0x23
c0de5c02:	2000      	movs	r0, #0
        onAction                = NULL;
c0de5c04:	f849 0006 	str.w	r0, [r9, r6]
        info.actionButtonText   = NULL;
c0de5c08:	e9cd 000d 	strd	r0, r0, [sp, #52]	@ 0x34
c0de5c0c:	e780      	b.n	c0de5b10 <useCaseHomeExt+0xd0>

c0de5c0e <displaySettingsPage>:
{
c0de5c0e:	b5b0      	push	{r4, r5, r7, lr}
c0de5c10:	b090      	sub	sp, #64	@ 0x40
c0de5c12:	460c      	mov	r4, r1
c0de5c14:	4605      	mov	r5, r0
c0de5c16:	4668      	mov	r0, sp
    nbgl_pageContent_t content = {0};
c0de5c18:	2140      	movs	r1, #64	@ 0x40
c0de5c1a:	f003 fb63 	bl	c0de92e4 <__aeabi_memclr>
    if ((onNav == NULL) || (onNav(page, &content) == false)) {
c0de5c1e:	f240 4064 	movw	r0, #1124	@ 0x464
c0de5c22:	f2c0 0000 	movt	r0, #0
c0de5c26:	f859 2000 	ldr.w	r2, [r9, r0]
c0de5c2a:	b36a      	cbz	r2, c0de5c88 <displaySettingsPage+0x7a>
c0de5c2c:	4669      	mov	r1, sp
c0de5c2e:	4628      	mov	r0, r5
c0de5c30:	4790      	blx	r2
c0de5c32:	b348      	cbz	r0, c0de5c88 <displaySettingsPage+0x7a>
    content.title            = pageTitle;
c0de5c34:	f240 406c 	movw	r0, #1132	@ 0x46c
c0de5c38:	f2c0 0000 	movt	r0, #0
c0de5c3c:	f859 0000 	ldr.w	r0, [r9, r0]
c0de5c40:	466a      	mov	r2, sp
c0de5c42:	9000      	str	r0, [sp, #0]
c0de5c44:	f240 2001 	movw	r0, #513	@ 0x201
    content.isTouchableTitle = true;
c0de5c48:	f8ad 0004 	strh.w	r0, [sp, #4]
c0de5c4c:	2009      	movs	r0, #9
    content.tuneId           = TUNE_TAP_CASUAL;
c0de5c4e:	f88d 0006 	strb.w	r0, [sp, #6]
    navInfo.activePage = page;
c0de5c52:	f240 50ec 	movw	r0, #1516	@ 0x5ec
c0de5c56:	f2c0 0000 	movt	r0, #0
c0de5c5a:	f809 5000 	strb.w	r5, [r9, r0]
c0de5c5e:	eb09 0100 	add.w	r1, r9, r0
    pageContext        = nbgl_pageDrawGenericContent(&pageCallback, &navInfo, &content);
c0de5c62:	f640 20a5 	movw	r0, #2725	@ 0xaa5
c0de5c66:	f2c0 0000 	movt	r0, #0
c0de5c6a:	4478      	add	r0, pc
c0de5c6c:	f7ff fdee 	bl	c0de584c <nbgl_pageDrawGenericContent>
c0de5c70:	f240 51d4 	movw	r1, #1492	@ 0x5d4
c0de5c74:	f2c0 0100 	movt	r1, #0
c0de5c78:	f849 0001 	str.w	r0, [r9, r1]
c0de5c7c:	2001      	movs	r0, #1
c0de5c7e:	2c00      	cmp	r4, #0
c0de5c80:	bf18      	it	ne
c0de5c82:	2002      	movne	r0, #2
c0de5c84:	f002 fa10 	bl	c0de80a8 <nbgl_refreshSpecial>
}
c0de5c88:	b010      	add	sp, #64	@ 0x40
c0de5c8a:	bdb0      	pop	{r4, r5, r7, pc}

c0de5c8c <nbgl_useCaseGenericSettings>:
void nbgl_useCaseGenericSettings(const char                   *appName,
                                 uint8_t                       initPage,
                                 const nbgl_genericContents_t *settingContents,
                                 const nbgl_contentInfoList_t *infosList,
                                 nbgl_callback_t               quitCallback)
{
c0de5c8c:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de5c90:	b090      	sub	sp, #64	@ 0x40
c0de5c92:	9101      	str	r1, [sp, #4]
    onContinue      = NULL;
c0de5c94:	f240 51e8 	movw	r1, #1512	@ 0x5e8
c0de5c98:	4607      	mov	r7, r0
c0de5c9a:	2000      	movs	r0, #0
c0de5c9c:	f2c0 0100 	movt	r1, #0
c0de5ca0:	f849 0001 	str.w	r0, [r9, r1]
    onAction        = NULL;
c0de5ca4:	f240 51e4 	movw	r1, #1508	@ 0x5e4
c0de5ca8:	f2c0 0100 	movt	r1, #0
c0de5cac:	f849 0001 	str.w	r0, [r9, r1]
    onNav           = NULL;
c0de5cb0:	f240 4164 	movw	r1, #1124	@ 0x464
c0de5cb4:	f2c0 0100 	movt	r1, #0
c0de5cb8:	f849 0001 	str.w	r0, [r9, r1]
    onControls      = NULL;
c0de5cbc:	f240 4168 	movw	r1, #1128	@ 0x468
c0de5cc0:	f2c0 0100 	movt	r1, #0
c0de5cc4:	f849 0001 	str.w	r0, [r9, r1]
    onContentAction = NULL;
c0de5cc8:	f240 61c0 	movw	r1, #1728	@ 0x6c0
c0de5ccc:	f2c0 0100 	movt	r1, #0
    onQuit          = NULL;
c0de5cd0:	f240 4560 	movw	r5, #1120	@ 0x460
    onContentAction = NULL;
c0de5cd4:	f849 0001 	str.w	r0, [r9, r1]
    onChoice        = NULL;
c0de5cd8:	f240 51d8 	movw	r1, #1496	@ 0x5d8
    memset(&genericContext, 0, sizeof(genericContext));
c0de5cdc:	f240 4874 	movw	r8, #1140	@ 0x474
    onQuit          = NULL;
c0de5ce0:	f2c0 0500 	movt	r5, #0
    onChoice        = NULL;
c0de5ce4:	f2c0 0100 	movt	r1, #0
    memset(&genericContext, 0, sizeof(genericContext));
c0de5ce8:	f2c0 0800 	movt	r8, #0
c0de5cec:	f8dd a060 	ldr.w	sl, [sp, #96]	@ 0x60
    onQuit          = NULL;
c0de5cf0:	f849 0005 	str.w	r0, [r9, r5]
    onChoice        = NULL;
c0de5cf4:	f849 0001 	str.w	r0, [r9, r1]
    memset(&genericContext, 0, sizeof(genericContext));
c0de5cf8:	eb09 0008 	add.w	r0, r9, r8
c0de5cfc:	2190      	movs	r1, #144	@ 0x90
c0de5cfe:	469b      	mov	fp, r3
c0de5d00:	4616      	mov	r6, r2
c0de5d02:	f003 faef 	bl	c0de92e4 <__aeabi_memclr>
    reset_callbacks_and_context();

    // memorize context
    onQuit    = quitCallback;
    pageTitle = appName;
c0de5d06:	f240 406c 	movw	r0, #1132	@ 0x46c
c0de5d0a:	f2c0 0000 	movt	r0, #0
c0de5d0e:	f849 7000 	str.w	r7, [r9, r0]
    navType   = GENERIC_NAV;
c0de5d12:	f240 4070 	movw	r0, #1136	@ 0x470
c0de5d16:	f2c0 0000 	movt	r0, #0
c0de5d1a:	2102      	movs	r1, #2
    onQuit    = quitCallback;
c0de5d1c:	f849 a005 	str.w	sl, [r9, r5]
    navType   = GENERIC_NAV;
c0de5d20:	f809 1000 	strb.w	r1, [r9, r0]

    if (settingContents != NULL) {
c0de5d24:	b12e      	cbz	r6, c0de5d32 <nbgl_useCaseGenericSettings+0xa6>
        memcpy(&genericContext.genericContents, settingContents, sizeof(nbgl_genericContents_t));
c0de5d26:	eb09 0008 	add.w	r0, r9, r8
c0de5d2a:	e896 000e 	ldmia.w	r6, {r1, r2, r3}
c0de5d2e:	3004      	adds	r0, #4
c0de5d30:	c00e      	stmia	r0!, {r1, r2, r3}
c0de5d32:	f240 5204 	movw	r2, #1284	@ 0x504
    }
    if (infosList != NULL) {
c0de5d36:	f1bb 0f00 	cmp.w	fp, #0
c0de5d3a:	f2c0 0200 	movt	r2, #0
c0de5d3e:	d015      	beq.n	c0de5d6c <nbgl_useCaseGenericSettings+0xe0>
        genericContext.hasFinishingContent = true;
c0de5d40:	eb09 0008 	add.w	r0, r9, r8
c0de5d44:	2101      	movs	r1, #1
        memset(&FINISHING_CONTENT, 0, sizeof(nbgl_content_t));
c0de5d46:	eb09 0502 	add.w	r5, r9, r2
        genericContext.hasFinishingContent = true;
c0de5d4a:	7501      	strb	r1, [r0, #20]
        memset(&FINISHING_CONTENT, 0, sizeof(nbgl_content_t));
c0de5d4c:	f105 0038 	add.w	r0, r5, #56	@ 0x38
c0de5d50:	2138      	movs	r1, #56	@ 0x38
c0de5d52:	f003 fac7 	bl	c0de92e4 <__aeabi_memclr>
c0de5d56:	2008      	movs	r0, #8
        FINISHING_CONTENT.type = INFOS_LIST;
c0de5d58:	f885 0038 	strb.w	r0, [r5, #56]	@ 0x38
        memcpy(&FINISHING_CONTENT.content, infosList, sizeof(nbgl_content_u));
c0de5d5c:	4659      	mov	r1, fp
c0de5d5e:	f105 003c 	add.w	r0, r5, #60	@ 0x3c
c0de5d62:	c9fc      	ldmia	r1!, {r2, r3, r4, r5, r6, r7}
c0de5d64:	c0fc      	stmia	r0!, {r2, r3, r4, r5, r6, r7}
c0de5d66:	e891 00fc 	ldmia.w	r1, {r2, r3, r4, r5, r6, r7}
c0de5d6a:	c0fc      	stmia	r0!, {r2, r3, r4, r5, r6, r7}
    for (int i = 0; i < genericContents->nbContents; i++) {
c0de5d6c:	eb09 0008 	add.w	r0, r9, r8
c0de5d70:	7b01      	ldrb	r1, [r0, #12]
c0de5d72:	2900      	cmp	r1, #0
c0de5d74:	d06e      	beq.n	c0de5e54 <nbgl_useCaseGenericSettings+0x1c8>
c0de5d76:	2500      	movs	r5, #0
c0de5d78:	ae02      	add	r6, sp, #8
c0de5d7a:	f04f 0a00 	mov.w	sl, #0
c0de5d7e:	2700      	movs	r7, #0
        p_content = getContentAtIdx(genericContents, i, &content);
c0de5d80:	fa4f f08a 	sxtb.w	r0, sl
    if (contentIdx < 0 || contentIdx >= genericContents->nbContents) {
c0de5d84:	2800      	cmp	r0, #0
c0de5d86:	f04f 0000 	mov.w	r0, #0
c0de5d8a:	d412      	bmi.n	c0de5db2 <nbgl_useCaseGenericSettings+0x126>
c0de5d8c:	162a      	asrs	r2, r5, #24
c0de5d8e:	428a      	cmp	r2, r1
c0de5d90:	da0f      	bge.n	c0de5db2 <nbgl_useCaseGenericSettings+0x126>
    if (genericContents->callbackCallNeeded) {
c0de5d92:	eb09 0008 	add.w	r0, r9, r8
c0de5d96:	7900      	ldrb	r0, [r0, #4]
c0de5d98:	b310      	cbz	r0, c0de5de0 <nbgl_useCaseGenericSettings+0x154>
        memset(content, 0, sizeof(nbgl_content_t));
c0de5d9a:	4630      	mov	r0, r6
c0de5d9c:	2138      	movs	r1, #56	@ 0x38
c0de5d9e:	f003 faa1 	bl	c0de92e4 <__aeabi_memclr>
        genericContents->contentGetterCallback(contentIdx, content);
c0de5da2:	eb09 0008 	add.w	r0, r9, r8
c0de5da6:	6882      	ldr	r2, [r0, #8]
c0de5da8:	fa5f f08a 	uxtb.w	r0, sl
c0de5dac:	4631      	mov	r1, r6
c0de5dae:	4790      	blx	r2
c0de5db0:	4630      	mov	r0, r6
        if (p_content == NULL) {
c0de5db2:	b300      	cbz	r0, c0de5df6 <nbgl_useCaseGenericSettings+0x16a>
                                        (i == (genericContents->nbContents - 1)),
c0de5db4:	eb09 0408 	add.w	r4, r9, r8
c0de5db8:	7b21      	ldrb	r1, [r4, #12]
        nbPages += getNbPagesForContent(p_content,
c0de5dba:	2300      	movs	r3, #0
                                        (i == (genericContents->nbContents - 1)),
c0de5dbc:	ebaa 0101 	sub.w	r1, sl, r1
c0de5dc0:	3101      	adds	r1, #1
c0de5dc2:	fab1 f181 	clz	r1, r1
c0de5dc6:	094a      	lsrs	r2, r1, #5
        nbPages += getNbPagesForContent(p_content,
c0de5dc8:	b2f9      	uxtb	r1, r7
c0de5dca:	f000 f849 	bl	c0de5e60 <getNbPagesForContent>
    for (int i = 0; i < genericContents->nbContents; i++) {
c0de5dce:	7b21      	ldrb	r1, [r4, #12]
c0de5dd0:	f10a 0a01 	add.w	sl, sl, #1
        nbPages += getNbPagesForContent(p_content,
c0de5dd4:	4407      	add	r7, r0
    for (int i = 0; i < genericContents->nbContents; i++) {
c0de5dd6:	458a      	cmp	sl, r1
c0de5dd8:	f105 7580 	add.w	r5, r5, #16777216	@ 0x1000000
c0de5ddc:	d3d0      	bcc.n	c0de5d80 <nbgl_useCaseGenericSettings+0xf4>
c0de5dde:	e00b      	b.n	c0de5df8 <nbgl_useCaseGenericSettings+0x16c>
        return PIC(&genericContents->contentsList[contentIdx]);
c0de5de0:	eb09 0008 	add.w	r0, r9, r8
c0de5de4:	6880      	ldr	r0, [r0, #8]
c0de5de6:	ebc2 01c2 	rsb	r1, r2, r2, lsl #3
c0de5dea:	eb00 00c1 	add.w	r0, r0, r1, lsl #3
c0de5dee:	f003 f885 	bl	c0de8efc <pic>
        if (p_content == NULL) {
c0de5df2:	2800      	cmp	r0, #0
c0de5df4:	d1de      	bne.n	c0de5db4 <nbgl_useCaseGenericSettings+0x128>
c0de5df6:	2700      	movs	r7, #0
    }

    // fill navigation structure
    uint8_t nbPages = getNbPagesForGenericContents(&genericContext.genericContents, 0, false);
    if (infosList != NULL) {
c0de5df8:	f1bb 0f00 	cmp.w	fp, #0
c0de5dfc:	d00b      	beq.n	c0de5e16 <nbgl_useCaseGenericSettings+0x18a>
        nbPages += getNbPagesForContent(&FINISHING_CONTENT, nbPages, true, false);
c0de5dfe:	f240 5004 	movw	r0, #1284	@ 0x504
c0de5e02:	f2c0 0000 	movt	r0, #0
c0de5e06:	4448      	add	r0, r9
c0de5e08:	3038      	adds	r0, #56	@ 0x38
c0de5e0a:	b2f9      	uxtb	r1, r7
c0de5e0c:	2201      	movs	r2, #1
c0de5e0e:	2300      	movs	r3, #0
c0de5e10:	f000 f826 	bl	c0de5e60 <getNbPagesForContent>
c0de5e14:	4407      	add	r7, r0
    memset(&navInfo, 0, sizeof(navInfo));
c0de5e16:	f240 52ec 	movw	r2, #1516	@ 0x5ec
c0de5e1a:	f2c0 0200 	movt	r2, #0
c0de5e1e:	2100      	movs	r1, #0
c0de5e20:	eb09 0302 	add.w	r3, r9, r2
c0de5e24:	f849 1002 	str.w	r1, [r9, r2]
c0de5e28:	e9c3 1101 	strd	r1, r1, [r3, #4]
c0de5e2c:	e9c3 1103 	strd	r1, r1, [r3, #12]
c0de5e30:	e9c3 1105 	strd	r1, r1, [r3, #20]
c0de5e34:	f44f 6110 	mov.w	r1, #2304	@ 0x900
c0de5e38:	9801      	ldr	r0, [sp, #4]
    navInfo.progressIndicator = false;
c0de5e3a:	8099      	strh	r1, [r3, #4]
c0de5e3c:	2101      	movs	r1, #1
    navInfo.navType           = NAV_WITH_BUTTONS;
c0de5e3e:	70d9      	strb	r1, [r3, #3]
c0de5e40:	2203      	movs	r2, #3
        navInfo.navWithButtons.backButton = true;
c0de5e42:	7459      	strb	r1, [r3, #17]
    }

    prepareNavInfo(false, nbPages, NULL);

    displayGenericContextPage(initPage, true);
c0de5e44:	2101      	movs	r1, #1
    navInfo.nbPages           = nbPages;
c0de5e46:	705f      	strb	r7, [r3, #1]
        navInfo.navWithButtons.navToken   = NAV_TOKEN;
c0de5e48:	74da      	strb	r2, [r3, #19]
    displayGenericContextPage(initPage, true);
c0de5e4a:	f000 f951 	bl	c0de60f0 <displayGenericContextPage>
}
c0de5e4e:	b010      	add	sp, #64	@ 0x40
c0de5e50:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de5e54:	2700      	movs	r7, #0
    if (infosList != NULL) {
c0de5e56:	f1bb 0f00 	cmp.w	fp, #0
c0de5e5a:	d1d0      	bne.n	c0de5dfe <nbgl_useCaseGenericSettings+0x172>
c0de5e5c:	e7db      	b.n	c0de5e16 <nbgl_useCaseGenericSettings+0x18a>
	...

c0de5e60 <getNbPagesForContent>:
{
c0de5e60:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de5e64:	b08e      	sub	sp, #56	@ 0x38
c0de5e66:	4684      	mov	ip, r0
    switch (content->type) {
c0de5e68:	7800      	ldrb	r0, [r0, #0]
c0de5e6a:	4698      	mov	r8, r3
c0de5e6c:	2807      	cmp	r0, #7
c0de5e6e:	f04f 0a01 	mov.w	sl, #1
c0de5e72:	9206      	str	r2, [sp, #24]
c0de5e74:	910a      	str	r1, [sp, #40]	@ 0x28
c0de5e76:	dc08      	bgt.n	c0de5e8a <getNbPagesForContent+0x2a>
c0de5e78:	2804      	cmp	r0, #4
c0de5e7a:	d00f      	beq.n	c0de5e9c <getNbPagesForContent+0x3c>
c0de5e7c:	2806      	cmp	r0, #6
c0de5e7e:	d00d      	beq.n	c0de5e9c <getNbPagesForContent+0x3c>
c0de5e80:	2807      	cmp	r0, #7
            return content->content.switchesList.nbSwitches;
c0de5e82:	bf08      	it	eq
c0de5e84:	f89c a008 	ldrbeq.w	sl, [ip, #8]
c0de5e88:	e010      	b.n	c0de5eac <getNbPagesForContent+0x4c>
    switch (content->type) {
c0de5e8a:	2808      	cmp	r0, #8
c0de5e8c:	d009      	beq.n	c0de5ea2 <getNbPagesForContent+0x42>
c0de5e8e:	2809      	cmp	r0, #9
c0de5e90:	d00a      	beq.n	c0de5ea8 <getNbPagesForContent+0x48>
c0de5e92:	280a      	cmp	r0, #10
c0de5e94:	bf08      	it	eq
c0de5e96:	f89c a00c 	ldrbeq.w	sl, [ip, #12]
c0de5e9a:	e007      	b.n	c0de5eac <getNbPagesForContent+0x4c>
c0de5e9c:	f89c a00c 	ldrb.w	sl, [ip, #12]
c0de5ea0:	e004      	b.n	c0de5eac <getNbPagesForContent+0x4c>
            return content->content.infosList.nbInfos;
c0de5ea2:	f89c a010 	ldrb.w	sl, [ip, #16]
c0de5ea6:	e001      	b.n	c0de5eac <getNbPagesForContent+0x4c>
            return content->content.choicesList.nbChoices;
c0de5ea8:	f89c a009 	ldrb.w	sl, [ip, #9]
    while (nbElements > 0) {
c0de5eac:	f1ba 0f00 	cmp.w	sl, #0
c0de5eb0:	f04f 0e00 	mov.w	lr, #0
c0de5eb4:	f000 8117 	beq.w	c0de60e6 <getNbPagesForContent+0x286>
c0de5eb8:	980a      	ldr	r0, [sp, #40]	@ 0x28
c0de5eba:	f04f 0b00 	mov.w	fp, #0
c0de5ebe:	2800      	cmp	r0, #0
c0de5ec0:	bf18      	it	ne
c0de5ec2:	2001      	movne	r0, #1
c0de5ec4:	9906      	ldr	r1, [sp, #24]
c0de5ec6:	2700      	movs	r7, #0
c0de5ec8:	f081 0101 	eor.w	r1, r1, #1
c0de5ecc:	4308      	orrs	r0, r1
c0de5ece:	9009      	str	r0, [sp, #36]	@ 0x24
c0de5ed0:	f10c 0004 	add.w	r0, ip, #4
c0de5ed4:	9104      	str	r1, [sp, #16]
c0de5ed6:	9007      	str	r0, [sp, #28]
c0de5ed8:	f8cd c020 	str.w	ip, [sp, #32]
c0de5edc:	f8cd 8014 	str.w	r8, [sp, #20]
c0de5ee0:	e02d      	b.n	c0de5f3e <getNbPagesForContent+0xde>
            nbElementsInPage = MIN(nbMaxElementsPerContentType[content->type], nbElements);
c0de5ee2:	f644 11ca 	movw	r1, #18890	@ 0x49ca
c0de5ee6:	f2c0 0100 	movt	r1, #0
c0de5eea:	4479      	add	r1, pc
c0de5eec:	5c0d      	ldrb	r5, [r1, r0]
c0de5eee:	fa5f f08a 	uxtb.w	r0, sl
c0de5ef2:	4285      	cmp	r5, r0
c0de5ef4:	bf28      	it	cs
c0de5ef6:	4655      	movcs	r5, sl
        genericContextSetPageInfo(pageIdxStart + nbPages, nbElementsInPage, flag);
c0de5ef8:	980a      	ldr	r0, [sp, #40]	@ 0x28
c0de5efa:	f89d 1037 	ldrb.w	r1, [sp, #55]	@ 0x37
c0de5efe:	4438      	add	r0, r7
    uint8_t pageData = SET_PAGE_NB_ELEMENTS(nbElements) + SET_PAGE_FLAG(flag);
c0de5f00:	f005 0207 	and.w	r2, r5, #7
    genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de5f04:	f240 63c4 	movw	r3, #1732	@ 0x6c4
    uint8_t pageData = SET_PAGE_NB_ELEMENTS(nbElements) + SET_PAGE_FLAG(flag);
c0de5f08:	ea42 01c1 	orr.w	r1, r2, r1, lsl #3
        &= ~(0x0F << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS));
c0de5f0c:	b2c0      	uxtb	r0, r0
c0de5f0e:	2204      	movs	r2, #4
    genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de5f10:	f2c0 0300 	movt	r3, #0
        &= ~(0x0F << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS));
c0de5f14:	ea02 0280 	and.w	r2, r2, r0, lsl #2
    genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de5f18:	0840      	lsrs	r0, r0, #1
c0de5f1a:	444b      	add	r3, r9
        &= ~(0x0F << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS));
c0de5f1c:	5c1e      	ldrb	r6, [r3, r0]
c0de5f1e:	240f      	movs	r4, #15
c0de5f20:	4094      	lsls	r4, r2
        |= pageData << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de5f22:	b2c9      	uxtb	r1, r1
        &= ~(0x0F << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS));
c0de5f24:	43a6      	bics	r6, r4
        |= pageData << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de5f26:	4091      	lsls	r1, r2
c0de5f28:	4331      	orrs	r1, r6
        nbElements -= nbElementsInPage;
c0de5f2a:	ebaa 0a05 	sub.w	sl, sl, r5
        elemIdx += nbElementsInPage;
c0de5f2e:	44ab      	add	fp, r5
        |= pageData << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de5f30:	5419      	strb	r1, [r3, r0]
    while (nbElements > 0) {
c0de5f32:	ea5f 600a 	movs.w	r0, sl, lsl #24
        nbPages++;
c0de5f36:	f107 0701 	add.w	r7, r7, #1
    while (nbElements > 0) {
c0de5f3a:	f000 80d5 	beq.w	c0de60e8 <getNbPagesForContent+0x288>
c0de5f3e:	fa5f f58b 	uxtb.w	r5, fp
c0de5f42:	4629      	mov	r1, r5
        flag = 0;
c0de5f44:	f88d e037 	strb.w	lr, [sp, #55]	@ 0x37
c0de5f48:	2d00      	cmp	r5, #0
        if (content->type == TAG_VALUE_LIST) {
c0de5f4a:	f89c 0000 	ldrb.w	r0, [ip]
c0de5f4e:	bf18      	it	ne
c0de5f50:	2101      	movne	r1, #1
        bool hasNav = !isLast || (pageIdxStart > 0) || (elemIdx > 0);
c0de5f52:	9a09      	ldr	r2, [sp, #36]	@ 0x24
        if (content->type == TAG_VALUE_LIST) {
c0de5f54:	2807      	cmp	r0, #7
        bool hasNav = !isLast || (pageIdxStart > 0) || (elemIdx > 0);
c0de5f56:	ea42 0401 	orr.w	r4, r2, r1
        if (content->type == TAG_VALUE_LIST) {
c0de5f5a:	dc0d      	bgt.n	c0de5f78 <getNbPagesForContent+0x118>
c0de5f5c:	2804      	cmp	r0, #4
c0de5f5e:	d02b      	beq.n	c0de5fb8 <getNbPagesForContent+0x158>
c0de5f60:	2806      	cmp	r0, #6
c0de5f62:	d06d      	beq.n	c0de6040 <getNbPagesForContent+0x1e0>
c0de5f64:	2807      	cmp	r0, #7
c0de5f66:	d1bc      	bne.n	c0de5ee2 <getNbPagesForContent+0x82>
            nbElementsInPage = nbgl_useCaseGetNbSwitchesInPage(
c0de5f68:	9907      	ldr	r1, [sp, #28]
c0de5f6a:	fa5f f08a 	uxtb.w	r0, sl
c0de5f6e:	462a      	mov	r2, r5
c0de5f70:	4623      	mov	r3, r4
c0de5f72:	f7ff fd0b 	bl	c0de598c <nbgl_useCaseGetNbSwitchesInPage>
c0de5f76:	e071      	b.n	c0de605c <getNbPagesForContent+0x1fc>
        if (content->type == TAG_VALUE_LIST) {
c0de5f78:	2808      	cmp	r0, #8
c0de5f7a:	d020      	beq.n	c0de5fbe <getNbPagesForContent+0x15e>
c0de5f7c:	2809      	cmp	r0, #9
c0de5f7e:	d073      	beq.n	c0de6068 <getNbPagesForContent+0x208>
c0de5f80:	280a      	cmp	r0, #10
c0de5f82:	d1ae      	bne.n	c0de5ee2 <getNbPagesForContent+0x82>
c0de5f84:	2c00      	cmp	r4, #0
c0de5f86:	f44f 71fc 	mov.w	r1, #504	@ 0x1f8
    while (nbBarsInPage < nbBars) {
c0de5f8a:	fa5f f28a 	uxtb.w	r2, sl
c0de5f8e:	bf18      	it	ne
c0de5f90:	f44f 71cc 	movne.w	r1, #408	@ 0x198
c0de5f94:	2a02      	cmp	r2, #2
c0de5f96:	f0c0 8081 	bcc.w	c0de609c <getNbPagesForContent+0x23c>
c0de5f9a:	235c      	movs	r3, #92	@ 0x5c
c0de5f9c:	2001      	movs	r0, #1
c0de5f9e:	255c      	movs	r5, #92	@ 0x5c
        currentHeight += LIST_ITEM_MIN_TEXT_HEIGHT + 2 * LIST_ITEM_PRE_HEADING;
c0de5fa0:	b29b      	uxth	r3, r3
c0de5fa2:	335c      	adds	r3, #92	@ 0x5c
        if (currentHeight >= (INFOS_AREA_HEIGHT - navHeight)) {
c0de5fa4:	b29e      	uxth	r6, r3
c0de5fa6:	428e      	cmp	r6, r1
c0de5fa8:	d27a      	bcs.n	c0de60a0 <getNbPagesForContent+0x240>
        nbBarsInPage++;
c0de5faa:	3001      	adds	r0, #1
c0de5fac:	b2c5      	uxtb	r5, r0
    while (nbBarsInPage < nbBars) {
c0de5fae:	4295      	cmp	r5, r2
c0de5fb0:	4635      	mov	r5, r6
c0de5fb2:	d3f5      	bcc.n	c0de5fa0 <getNbPagesForContent+0x140>
c0de5fb4:	4635      	mov	r5, r6
c0de5fb6:	e072      	b.n	c0de609e <getNbPagesForContent+0x23e>
            nbElementsInPage = getNbTagValuesInPage(nbElements,
c0de5fb8:	e9cd ee00 	strd	lr, lr, [sp]
c0de5fbc:	e044      	b.n	c0de6048 <getNbPagesForContent+0x1e8>
    const char *const *infoContents = PIC(infosList->infoContents);
c0de5fbe:	f8dc 0008 	ldr.w	r0, [ip, #8]
c0de5fc2:	f002 ff9b 	bl	c0de8efc <pic>
c0de5fc6:	4680      	mov	r8, r0
                                                   PIC(infoContents[startIndex + nbInfosInPage]),
c0de5fc8:	f850 0025 	ldr.w	r0, [r0, r5, lsl #2]
c0de5fcc:	f44f 76fc 	mov.w	r6, #504	@ 0x1f8
c0de5fd0:	2c00      	cmp	r4, #0
c0de5fd2:	bf18      	it	ne
c0de5fd4:	f44f 76cc 	movne.w	r6, #408	@ 0x198
c0de5fd8:	f002 ff90 	bl	c0de8efc <pic>
c0de5fdc:	4601      	mov	r1, r0
        currentHeight += nbgl_getTextHeightInWidth(SMALL_REGULAR_FONT,
c0de5fde:	200b      	movs	r0, #11
c0de5fe0:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de5fe4:	2301      	movs	r3, #1
c0de5fe6:	f002 f8af 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de5fea:	f100 0168 	add.w	r1, r0, #104	@ 0x68
        if (currentHeight >= (INFOS_AREA_HEIGHT - navHeight)) {
c0de5fee:	b288      	uxth	r0, r1
c0de5ff0:	42b0      	cmp	r0, r6
c0de5ff2:	d25e      	bcs.n	c0de60b2 <getNbPagesForContent+0x252>
c0de5ff4:	fa5f f28a 	uxtb.w	r2, sl
    while (nbInfosInPage < nbInfos) {
c0de5ff8:	920c      	str	r2, [sp, #48]	@ 0x30
c0de5ffa:	eb08 0285 	add.w	r2, r8, r5, lsl #2
c0de5ffe:	2501      	movs	r5, #1
c0de6000:	9403      	str	r4, [sp, #12]
c0de6002:	920b      	str	r2, [sp, #44]	@ 0x2c
c0de6004:	9a0c      	ldr	r2, [sp, #48]	@ 0x30
c0de6006:	42aa      	cmp	r2, r5
c0de6008:	d066      	beq.n	c0de60d8 <getNbPagesForContent+0x278>
c0de600a:	4680      	mov	r8, r0
                                                   PIC(infoContents[startIndex + nbInfosInPage]),
c0de600c:	980b      	ldr	r0, [sp, #44]	@ 0x2c
            += LIST_ITEM_MIN_TEXT_HEIGHT + 2 * LIST_ITEM_PRE_HEADING + LIST_ITEM_HEADING_SUB_TEXT;
c0de600e:	f101 0468 	add.w	r4, r1, #104	@ 0x68
                                                   PIC(infoContents[startIndex + nbInfosInPage]),
c0de6012:	f850 0025 	ldr.w	r0, [r0, r5, lsl #2]
c0de6016:	f002 ff71 	bl	c0de8efc <pic>
c0de601a:	4601      	mov	r1, r0
        currentHeight += nbgl_getTextHeightInWidth(SMALL_REGULAR_FONT,
c0de601c:	200b      	movs	r0, #11
c0de601e:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de6022:	2301      	movs	r3, #1
c0de6024:	f002 f890 	bl	c0de8148 <nbgl_getTextHeightInWidth>
c0de6028:	b2a1      	uxth	r1, r4
c0de602a:	4401      	add	r1, r0
        if (currentHeight >= (INFOS_AREA_HEIGHT - navHeight)) {
c0de602c:	b288      	uxth	r0, r1
c0de602e:	42b0      	cmp	r0, r6
c0de6030:	f105 0501 	add.w	r5, r5, #1
c0de6034:	d3e6      	bcc.n	c0de6004 <getNbPagesForContent+0x1a4>
c0de6036:	f8dd c020 	ldr.w	ip, [sp, #32]
c0de603a:	9c03      	ldr	r4, [sp, #12]
            if (!withNav && (previousHeight >= (INFOS_AREA_HEIGHT - SIMPLE_FOOTER_HEIGHT))) {
c0de603c:	1e68      	subs	r0, r5, #1
c0de603e:	e03d      	b.n	c0de60bc <getNbPagesForContent+0x25c>
            nbElementsInPage = getNbTagValuesInPage(nbElements,
c0de6040:	9806      	ldr	r0, [sp, #24]
c0de6042:	9000      	str	r0, [sp, #0]
c0de6044:	9804      	ldr	r0, [sp, #16]
c0de6046:	9001      	str	r0, [sp, #4]
c0de6048:	9907      	ldr	r1, [sp, #28]
c0de604a:	fa5f f08a 	uxtb.w	r0, sl
c0de604e:	462a      	mov	r2, r5
c0de6050:	4643      	mov	r3, r8
c0de6052:	f10d 0637 	add.w	r6, sp, #55	@ 0x37
c0de6056:	9602      	str	r6, [sp, #8]
c0de6058:	f7ff fc02 	bl	c0de5860 <getNbTagValuesInPage>
c0de605c:	f8dd c020 	ldr.w	ip, [sp, #32]
c0de6060:	f04f 0e00 	mov.w	lr, #0
c0de6064:	4605      	mov	r5, r0
c0de6066:	e747      	b.n	c0de5ef8 <getNbPagesForContent+0x98>
c0de6068:	f44f 71fc 	mov.w	r1, #504	@ 0x1f8
c0de606c:	2000      	movs	r0, #0
c0de606e:	235c      	movs	r3, #92	@ 0x5c
c0de6070:	225c      	movs	r2, #92	@ 0x5c
c0de6072:	2c00      	cmp	r4, #0
c0de6074:	bf18      	it	ne
c0de6076:	f44f 71cc 	movne.w	r1, #408	@ 0x198
c0de607a:	bf00      	nop
        nbChoicesInPage++;
c0de607c:	3001      	adds	r0, #1
c0de607e:	b2c6      	uxtb	r6, r0
    while (nbChoicesInPage < nbChoices) {
c0de6080:	fa5f f58a 	uxtb.w	r5, sl
c0de6084:	42ae      	cmp	r6, r5
c0de6086:	d207      	bcs.n	c0de6098 <getNbPagesForContent+0x238>
        currentHeight += LIST_ITEM_MIN_TEXT_HEIGHT + 2 * LIST_ITEM_PRE_HEADING;
c0de6088:	b292      	uxth	r2, r2
c0de608a:	325c      	adds	r2, #92	@ 0x5c
c0de608c:	461e      	mov	r6, r3
        if (currentHeight >= (INFOS_AREA_HEIGHT - navHeight)) {
c0de608e:	b293      	uxth	r3, r2
c0de6090:	428b      	cmp	r3, r1
c0de6092:	d3f3      	bcc.n	c0de607c <getNbPagesForContent+0x21c>
c0de6094:	08f1      	lsrs	r1, r6, #3
c0de6096:	e004      	b.n	c0de60a2 <getNbPagesForContent+0x242>
c0de6098:	4655      	mov	r5, sl
c0de609a:	e72d      	b.n	c0de5ef8 <getNbPagesForContent+0x98>
c0de609c:	255c      	movs	r5, #92	@ 0x5c
c0de609e:	4650      	mov	r0, sl
c0de60a0:	08e9      	lsrs	r1, r5, #3
c0de60a2:	2932      	cmp	r1, #50	@ 0x32
c0de60a4:	f04f 0100 	mov.w	r1, #0
c0de60a8:	bf88      	it	hi
c0de60aa:	2101      	movhi	r1, #1
c0de60ac:	43a1      	bics	r1, r4
c0de60ae:	1a45      	subs	r5, r0, r1
c0de60b0:	e722      	b.n	c0de5ef8 <getNbPagesForContent+0x98>
c0de60b2:	f8dd c020 	ldr.w	ip, [sp, #32]
c0de60b6:	2000      	movs	r0, #0
c0de60b8:	f04f 0800 	mov.w	r8, #0
c0de60bc:	f04f 0e00 	mov.w	lr, #0
c0de60c0:	ea4f 01d8 	mov.w	r1, r8, lsr #3
c0de60c4:	2932      	cmp	r1, #50	@ 0x32
c0de60c6:	f04f 0100 	mov.w	r1, #0
c0de60ca:	bf88      	it	hi
c0de60cc:	2101      	movhi	r1, #1
            if (!withNav && (previousHeight >= (INFOS_AREA_HEIGHT - SIMPLE_FOOTER_HEIGHT))) {
c0de60ce:	43a1      	bics	r1, r4
c0de60d0:	f8dd 8014 	ldr.w	r8, [sp, #20]
c0de60d4:	1a45      	subs	r5, r0, r1
c0de60d6:	e70f      	b.n	c0de5ef8 <getNbPagesForContent+0x98>
c0de60d8:	f8dd 8014 	ldr.w	r8, [sp, #20]
c0de60dc:	f8dd c020 	ldr.w	ip, [sp, #32]
c0de60e0:	f04f 0e00 	mov.w	lr, #0
c0de60e4:	e708      	b.n	c0de5ef8 <getNbPagesForContent+0x98>
c0de60e6:	2700      	movs	r7, #0
    return nbPages;
c0de60e8:	b2f8      	uxtb	r0, r7
c0de60ea:	b00e      	add	sp, #56	@ 0x38
c0de60ec:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de60f0 <displayGenericContextPage>:
{
c0de60f0:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de60f4:	b0a0      	sub	sp, #128	@ 0x80
    if (navType == STREAMING_NAV) {
c0de60f6:	f240 4670 	movw	r6, #1136	@ 0x470
c0de60fa:	f2c0 0600 	movt	r6, #0
c0de60fe:	f819 2006 	ldrb.w	r2, [r9, r6]
c0de6102:	460d      	mov	r5, r1
c0de6104:	2a03      	cmp	r2, #3
c0de6106:	4682      	mov	sl, r0
c0de6108:	d112      	bne.n	c0de6130 <displayGenericContextPage+0x40>
        else if (pageIdx >= bundleNavContext.reviewStreaming.stepPageNb) {
c0de610a:	f240 50ac 	movw	r0, #1452	@ 0x5ac
c0de610e:	f2c0 0000 	movt	r0, #0
        if (pageIdx == LAST_PAGE_FOR_REVIEW) {
c0de6112:	f1ba 0fff 	cmp.w	sl, #255	@ 0xff
c0de6116:	d042      	beq.n	c0de619e <displayGenericContextPage+0xae>
        else if (pageIdx >= bundleNavContext.reviewStreaming.stepPageNb) {
c0de6118:	eb09 0100 	add.w	r1, r9, r0
c0de611c:	7c09      	ldrb	r1, [r1, #16]
c0de611e:	4551      	cmp	r1, sl
c0de6120:	d811      	bhi.n	c0de6146 <displayGenericContextPage+0x56>
        bundleNavContext.reviewStreaming.choiceCallback(true);
c0de6122:	4448      	add	r0, r9
c0de6124:	6841      	ldr	r1, [r0, #4]
c0de6126:	2001      	movs	r0, #1
c0de6128:	4788      	blx	r1
}
c0de612a:	b020      	add	sp, #128	@ 0x80
c0de612c:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        if (pageIdx == LAST_PAGE_FOR_REVIEW) {
c0de6130:	f1ba 0fff 	cmp.w	sl, #255	@ 0xff
c0de6134:	d107      	bne.n	c0de6146 <displayGenericContextPage+0x56>
            pageIdx = navInfo.nbPages - 1;
c0de6136:	f240 50ec 	movw	r0, #1516	@ 0x5ec
c0de613a:	f2c0 0000 	movt	r0, #0
c0de613e:	4448      	add	r0, r9
c0de6140:	7840      	ldrb	r0, [r0, #1]
c0de6142:	f1a0 0a01 	sub.w	sl, r0, #1
    if (navInfo.activePage == pageIdx) {
c0de6146:	f240 54ec 	movw	r4, #1516	@ 0x5ec
c0de614a:	f2c0 0400 	movt	r4, #0
c0de614e:	f819 8004 	ldrb.w	r8, [r9, r4]
c0de6152:	fa5f f78a 	uxtb.w	r7, sl
c0de6156:	4547      	cmp	r7, r8
c0de6158:	d02d      	beq.n	c0de61b6 <displayGenericContextPage+0xc6>
    else if (navInfo.activePage < pageIdx) {
c0de615a:	d928      	bls.n	c0de61ae <displayGenericContextPage+0xbe>
c0de615c:	9500      	str	r5, [sp, #0]
c0de615e:	ac12      	add	r4, sp, #72	@ 0x48
c0de6160:	f10d 0647 	add.w	r6, sp, #71	@ 0x47
c0de6164:	f10d 0546 	add.w	r5, sp, #70	@ 0x46
c0de6168:	f108 0801 	add.w	r8, r8, #1
            p_content = genericContextComputeNextPageParams(i, &content, &nbElementsInPage, &flag);
c0de616c:	fa5f f088 	uxtb.w	r0, r8
c0de6170:	4621      	mov	r1, r4
c0de6172:	4632      	mov	r2, r6
c0de6174:	462b      	mov	r3, r5
c0de6176:	f000 fe9f 	bl	c0de6eb8 <genericContextComputeNextPageParams>
        for (int i = navInfo.activePage + 1; i <= pageIdx; i++) {
c0de617a:	4547      	cmp	r7, r8
c0de617c:	d1f4      	bne.n	c0de6168 <displayGenericContextPage+0x78>
c0de617e:	9d00      	ldr	r5, [sp, #0]
c0de6180:	f240 54ec 	movw	r4, #1516	@ 0x5ec
c0de6184:	f240 4670 	movw	r6, #1136	@ 0x470
c0de6188:	4683      	mov	fp, r0
c0de618a:	f2c0 0400 	movt	r4, #0
c0de618e:	f2c0 0600 	movt	r6, #0
    if (p_content == NULL) {
c0de6192:	f1bb 0f00 	cmp.w	fp, #0
c0de6196:	d11a      	bne.n	c0de61ce <displayGenericContextPage+0xde>
}
c0de6198:	b020      	add	sp, #128	@ 0x80
c0de619a:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            if (bundleNavContext.reviewStreaming.skipCallback != NULL) {
c0de619e:	4448      	add	r0, r9
c0de61a0:	6880      	ldr	r0, [r0, #8]
c0de61a2:	2800      	cmp	r0, #0
c0de61a4:	d0f8      	beq.n	c0de6198 <displayGenericContextPage+0xa8>
                bundleNavContext.reviewStreaming.skipCallback();
c0de61a6:	4780      	blx	r0
}
c0de61a8:	b020      	add	sp, #128	@ 0x80
c0de61aa:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        if (pageIdx - navInfo.activePage > 1) {
c0de61ae:	eba7 0008 	sub.w	r0, r7, r8
c0de61b2:	2801      	cmp	r0, #1
c0de61b4:	dcf0      	bgt.n	c0de6198 <displayGenericContextPage+0xa8>
c0de61b6:	a912      	add	r1, sp, #72	@ 0x48
c0de61b8:	f10d 0247 	add.w	r2, sp, #71	@ 0x47
c0de61bc:	f10d 0346 	add.w	r3, sp, #70	@ 0x46
c0de61c0:	4638      	mov	r0, r7
c0de61c2:	f000 fe79 	bl	c0de6eb8 <genericContextComputeNextPageParams>
c0de61c6:	4683      	mov	fp, r0
    if (p_content == NULL) {
c0de61c8:	f1bb 0f00 	cmp.w	fp, #0
c0de61cc:	d0e4      	beq.n	c0de6198 <displayGenericContextPage+0xa8>
    if ((navType != STREAMING_NAV)
c0de61ce:	f819 0006 	ldrb.w	r0, [r9, r6]
c0de61d2:	f240 58ac 	movw	r8, #1452	@ 0x5ac
        && (bundleNavContext.review.operationType & SKIPPABLE_OPERATION)) {
c0de61d6:	2803      	cmp	r0, #3
c0de61d8:	f2c0 0800 	movt	r8, #0
c0de61dc:	d01d      	beq.n	c0de621a <displayGenericContextPage+0x12a>
    if ((navType != STREAMING_NAV)
c0de61de:	f819 0008 	ldrb.w	r0, [r9, r8]
c0de61e2:	06c0      	lsls	r0, r0, #27
c0de61e4:	d519      	bpl.n	c0de621a <displayGenericContextPage+0x12a>
        if ((pageIdx > 0) && (pageIdx < (navInfo.nbPages - 1))) {
c0de61e6:	ea5f 600a 	movs.w	r0, sl, lsl #24
c0de61ea:	d012      	beq.n	c0de6212 <displayGenericContextPage+0x122>
c0de61ec:	eb09 0004 	add.w	r0, r9, r4
c0de61f0:	7840      	ldrb	r0, [r0, #1]
c0de61f2:	3801      	subs	r0, #1
c0de61f4:	42b8      	cmp	r0, r7
c0de61f6:	dd0c      	ble.n	c0de6212 <displayGenericContextPage+0x122>
            navInfo.progressIndicator = false;
c0de61f8:	eb09 0004 	add.w	r0, r9, r4
c0de61fc:	2100      	movs	r1, #0
c0de61fe:	7101      	strb	r1, [r0, #4]
            navInfo.skipText          = "Skip";
c0de6200:	f244 5179 	movw	r1, #17785	@ 0x4579
c0de6204:	f2c0 0100 	movt	r1, #0
c0de6208:	4479      	add	r1, pc
c0de620a:	6081      	str	r1, [r0, #8]
c0de620c:	2105      	movs	r1, #5
            navInfo.skipToken         = SKIP_TOKEN;
c0de620e:	7301      	strb	r1, [r0, #12]
c0de6210:	e003      	b.n	c0de621a <displayGenericContextPage+0x12a>
            navInfo.skipText = NULL;
c0de6212:	eb09 0004 	add.w	r0, r9, r4
c0de6216:	2100      	movs	r1, #0
c0de6218:	6081      	str	r1, [r0, #8]
c0de621a:	af01      	add	r7, sp, #4
    nbgl_pageContent_t pageContent = {0};
c0de621c:	4638      	mov	r0, r7
c0de621e:	2140      	movs	r1, #64	@ 0x40
c0de6220:	f003 f860 	bl	c0de92e4 <__aeabi_memclr>
    pageContent->title            = pageTitle;
c0de6224:	f240 416c 	movw	r1, #1132	@ 0x46c
c0de6228:	f2c0 0100 	movt	r1, #0
c0de622c:	f859 1001 	ldr.w	r1, [r9, r1]
    uint8_t nextElementIdx = genericContext.currentElementIdx;
c0de6230:	f240 4a74 	movw	sl, #1140	@ 0x474
    pageContent->title            = pageTitle;
c0de6234:	9101      	str	r1, [sp, #4]
c0de6236:	f44f 7100 	mov.w	r1, #512	@ 0x200
    pageContent->isTouchableTitle = false;
c0de623a:	f8ad 1008 	strh.w	r1, [sp, #8]
c0de623e:	2109      	movs	r1, #9
    uint8_t nextElementIdx = genericContext.currentElementIdx;
c0de6240:	f2c0 0a00 	movt	sl, #0
    pageContent->tuneId           = TUNE_TAP_CASUAL;
c0de6244:	f88d 100a 	strb.w	r1, [sp, #10]
    uint8_t nextElementIdx = genericContext.currentElementIdx;
c0de6248:	eb09 020a 	add.w	r2, r9, sl
    pageContent->type = p_content->type;
c0de624c:	f89b 1000 	ldrb.w	r1, [fp]
    if (!genericContextPreparePageContent(p_content, nbElementsInPage, flag, &pageContent)) {
c0de6250:	f89d 4047 	ldrb.w	r4, [sp, #71]	@ 0x47
c0de6254:	f89d 0046 	ldrb.w	r0, [sp, #70]	@ 0x46
    uint8_t nextElementIdx = genericContext.currentElementIdx;
c0de6258:	7c96      	ldrb	r6, [r2, #18]
    switch (pageContent->type) {
c0de625a:	2905      	cmp	r1, #5
    pageContent->type = p_content->type;
c0de625c:	f88d 1010 	strb.w	r1, [sp, #16]
    switch (pageContent->type) {
c0de6260:	dc1b      	bgt.n	c0de629a <displayGenericContextPage+0x1aa>
c0de6262:	2901      	cmp	r1, #1
c0de6264:	dd36      	ble.n	c0de62d4 <displayGenericContextPage+0x1e4>
c0de6266:	2902      	cmp	r1, #2
c0de6268:	d056      	beq.n	c0de6318 <displayGenericContextPage+0x228>
c0de626a:	2903      	cmp	r1, #3
c0de626c:	d054      	beq.n	c0de6318 <displayGenericContextPage+0x228>
c0de626e:	2904      	cmp	r1, #4
c0de6270:	d192      	bne.n	c0de6198 <displayGenericContextPage+0xa8>
            genericContext.currentPairs    = p_content->content.tagValueList.pairs;
c0de6272:	f8db 1004 	ldr.w	r1, [fp, #4]
c0de6276:	eb09 020a 	add.w	r2, r9, sl
c0de627a:	6251      	str	r1, [r2, #36]	@ 0x24
            genericContext.currentCallback = p_content->content.tagValueList.callback;
c0de627c:	f8db 1008 	ldr.w	r1, [fp, #8]
            nbgl_contentTagValueList_t *p_tagValueList = &pageContent->tagValueList;
c0de6280:	3710      	adds	r7, #16
            if (flag) {
c0de6282:	2800      	cmp	r0, #0
            genericContext.currentCallback = p_content->content.tagValueList.callback;
c0de6284:	6291      	str	r1, [r2, #40]	@ 0x28
c0de6286:	f000 8107 	beq.w	c0de6498 <displayGenericContextPage+0x3a8>
                if (p_content->content.tagValueList.pairs != NULL) {
c0de628a:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de628e:	2800      	cmp	r0, #0
c0de6290:	f000 80c9 	beq.w	c0de6426 <displayGenericContextPage+0x336>
                    pair = PIC(&p_content->content.tagValueList.pairs[nextElementIdx]);
c0de6294:	eb00 1006 	add.w	r0, r0, r6, lsl #4
c0de6298:	e0c9      	b.n	c0de642e <displayGenericContextPage+0x33e>
    switch (pageContent->type) {
c0de629a:	2907      	cmp	r1, #7
c0de629c:	dd2b      	ble.n	c0de62f6 <displayGenericContextPage+0x206>
c0de629e:	2908      	cmp	r1, #8
c0de62a0:	d047      	beq.n	c0de6332 <displayGenericContextPage+0x242>
c0de62a2:	2909      	cmp	r1, #9
c0de62a4:	d056      	beq.n	c0de6354 <displayGenericContextPage+0x264>
c0de62a6:	290a      	cmp	r1, #10
c0de62a8:	f47f af76 	bne.w	c0de6198 <displayGenericContextPage+0xa8>
            pageContent->barsList.nbBars = nbElementsInPage;
c0de62ac:	f88d 401c 	strb.w	r4, [sp, #28]
                = PIC(&p_content->content.barsList.barTexts[nextElementIdx]);
c0de62b0:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de62b4:	eb00 0086 	add.w	r0, r0, r6, lsl #2
c0de62b8:	f002 fe20 	bl	c0de8efc <pic>
c0de62bc:	9005      	str	r0, [sp, #20]
            pageContent->barsList.tokens = PIC(&p_content->content.barsList.tokens[nextElementIdx]);
c0de62be:	f8db 0008 	ldr.w	r0, [fp, #8]
c0de62c2:	4430      	add	r0, r6
c0de62c4:	f002 fe1a 	bl	c0de8efc <pic>
c0de62c8:	9006      	str	r0, [sp, #24]
            pageContent->barsList.tuneId = p_content->content.barsList.tuneId;
c0de62ca:	f89b 000d 	ldrb.w	r0, [fp, #13]
c0de62ce:	f88d 001d 	strb.w	r0, [sp, #29]
c0de62d2:	e123      	b.n	c0de651c <displayGenericContextPage+0x42c>
    switch (pageContent->type) {
c0de62d4:	2900      	cmp	r1, #0
c0de62d6:	d056      	beq.n	c0de6386 <displayGenericContextPage+0x296>
c0de62d8:	2901      	cmp	r1, #1
c0de62da:	f47f af5d 	bne.w	c0de6198 <displayGenericContextPage+0xa8>
            memcpy(&pageContent->extendedCenter,
c0de62de:	f10b 0104 	add.w	r1, fp, #4
c0de62e2:	f107 0010 	add.w	r0, r7, #16
c0de62e6:	46ac      	mov	ip, r5
c0de62e8:	c9fc      	ldmia	r1!, {r2, r3, r4, r5, r6, r7}
c0de62ea:	c0fc      	stmia	r0!, {r2, r3, r4, r5, r6, r7}
c0de62ec:	e891 00fc 	ldmia.w	r1, {r2, r3, r4, r5, r6, r7}
c0de62f0:	c0fc      	stmia	r0!, {r2, r3, r4, r5, r6, r7}
c0de62f2:	4665      	mov	r5, ip
c0de62f4:	e112      	b.n	c0de651c <displayGenericContextPage+0x42c>
    switch (pageContent->type) {
c0de62f6:	2906      	cmp	r1, #6
c0de62f8:	d04f      	beq.n	c0de639a <displayGenericContextPage+0x2aa>
c0de62fa:	2907      	cmp	r1, #7
c0de62fc:	f47f af4c 	bne.w	c0de6198 <displayGenericContextPage+0xa8>
            pageContent->switchesList.nbSwitches = nbElementsInPage;
c0de6300:	f88d 4018 	strb.w	r4, [sp, #24]
                = PIC(&p_content->content.switchesList.switches[nextElementIdx]);
c0de6304:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de6308:	eb06 0146 	add.w	r1, r6, r6, lsl #1
c0de630c:	eb00 0081 	add.w	r0, r0, r1, lsl #2
c0de6310:	f002 fdf4 	bl	c0de8efc <pic>
c0de6314:	9005      	str	r0, [sp, #20]
c0de6316:	e101      	b.n	c0de651c <displayGenericContextPage+0x42c>
c0de6318:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de631c:	f8db 1008 	ldr.w	r1, [fp, #8]
c0de6320:	f8db 2010 	ldr.w	r2, [fp, #16]
c0de6324:	f8db 300c 	ldr.w	r3, [fp, #12]
c0de6328:	9208      	str	r2, [sp, #32]
c0de632a:	9307      	str	r3, [sp, #28]
c0de632c:	9106      	str	r1, [sp, #24]
c0de632e:	9005      	str	r0, [sp, #20]
c0de6330:	e0f4      	b.n	c0de651c <displayGenericContextPage+0x42c>
            pageContent->infosList.nbInfos = nbElementsInPage;
c0de6332:	f88d 4020 	strb.w	r4, [sp, #32]
                = PIC(&p_content->content.infosList.infoTypes[nextElementIdx]);
c0de6336:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de633a:	eb00 0086 	add.w	r0, r0, r6, lsl #2
c0de633e:	f002 fddd 	bl	c0de8efc <pic>
c0de6342:	9005      	str	r0, [sp, #20]
                = PIC(&p_content->content.infosList.infoContents[nextElementIdx]);
c0de6344:	f8db 0008 	ldr.w	r0, [fp, #8]
c0de6348:	eb00 0086 	add.w	r0, r0, r6, lsl #2
c0de634c:	f002 fdd6 	bl	c0de8efc <pic>
c0de6350:	9006      	str	r0, [sp, #24]
c0de6352:	e0e3      	b.n	c0de651c <displayGenericContextPage+0x42c>
            memcpy(&pageContent->choicesList,
c0de6354:	f10b 0204 	add.w	r2, fp, #4
c0de6358:	ca07      	ldmia	r2, {r0, r1, r2}
c0de635a:	ab05      	add	r3, sp, #20
c0de635c:	c307      	stmia	r3!, {r0, r1, r2}
            pageContent->choicesList.nbChoices = nbElementsInPage;
c0de635e:	f88d 4019 	strb.w	r4, [sp, #25]
                = PIC(&p_content->content.choicesList.names[nextElementIdx]);
c0de6362:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de6366:	eb00 0086 	add.w	r0, r0, r6, lsl #2
c0de636a:	f002 fdc7 	bl	c0de8efc <pic>
c0de636e:	9005      	str	r0, [sp, #20]
            if ((p_content->content.choicesList.initChoice >= nextElementIdx)
c0de6370:	f89b 000a 	ldrb.w	r0, [fp, #10]
                && (p_content->content.choicesList.initChoice
c0de6374:	42b0      	cmp	r0, r6
c0de6376:	d329      	bcc.n	c0de63cc <displayGenericContextPage+0x2dc>
c0de6378:	1931      	adds	r1, r6, r4
c0de637a:	4281      	cmp	r1, r0
c0de637c:	d926      	bls.n	c0de63cc <displayGenericContextPage+0x2dc>
                    = p_content->content.choicesList.initChoice - nextElementIdx;
c0de637e:	1b80      	subs	r0, r0, r6
c0de6380:	f88d 001a 	strb.w	r0, [sp, #26]
c0de6384:	e0ca      	b.n	c0de651c <displayGenericContextPage+0x42c>
            memcpy(&pageContent->centeredInfo,
c0de6386:	f10b 0104 	add.w	r1, fp, #4
c0de638a:	f107 0010 	add.w	r0, r7, #16
c0de638e:	462c      	mov	r4, r5
c0de6390:	e891 00ec 	ldmia.w	r1, {r2, r3, r5, r6, r7}
c0de6394:	c0ec      	stmia	r0!, {r2, r3, r5, r6, r7}
c0de6396:	4625      	mov	r5, r4
c0de6398:	e0c0      	b.n	c0de651c <displayGenericContextPage+0x42c>
                == p_content->content.tagValueConfirm.tagValueList.nbPairs) {
c0de639a:	f89b 000c 	ldrb.w	r0, [fp, #12]
            if ((nextElementIdx + nbElementsInPage)
c0de639e:	1931      	adds	r1, r6, r4
c0de63a0:	4281      	cmp	r1, r0
                == p_content->content.tagValueConfirm.tagValueList.nbPairs) {
c0de63a2:	f10b 0c04 	add.w	ip, fp, #4
            if ((nextElementIdx + nbElementsInPage)
c0de63a6:	d114      	bne.n	c0de63d2 <displayGenericContextPage+0x2e2>
                memcpy(&pageContent->tagValueConfirm,
c0de63a8:	46e6      	mov	lr, ip
c0de63aa:	9500      	str	r5, [sp, #0]
c0de63ac:	f107 0a10 	add.w	sl, r7, #16
c0de63b0:	e8be 00ab 	ldmia.w	lr!, {r0, r1, r3, r5, r7}
c0de63b4:	4652      	mov	r2, sl
c0de63b6:	c2ab      	stmia	r2!, {r0, r1, r3, r5, r7}
c0de63b8:	e89e 01ab 	ldmia.w	lr, {r0, r1, r3, r5, r7, r8}
c0de63bc:	e882 01ab 	stmia.w	r2, {r0, r1, r3, r5, r7, r8}
c0de63c0:	f240 58ac 	movw	r8, #1452	@ 0x5ac
c0de63c4:	9d00      	ldr	r5, [sp, #0]
c0de63c6:	f2c0 0800 	movt	r8, #0
c0de63ca:	e007      	b.n	c0de63dc <displayGenericContextPage+0x2ec>
                pageContent->choicesList.initChoice = nbElementsInPage;
c0de63cc:	f88d 401a 	strb.w	r4, [sp, #26]
c0de63d0:	e0a4      	b.n	c0de651c <displayGenericContextPage+0x42c>
c0de63d2:	2004      	movs	r0, #4
                p_tagValueList    = &pageContent->tagValueList;
c0de63d4:	f107 0a10 	add.w	sl, r7, #16
                pageContent->type = TAG_VALUE_LIST;
c0de63d8:	f88d 0010 	strb.w	r0, [sp, #16]
            p_tagValueList->nbPairs = nbElementsInPage;
c0de63dc:	f88d 401c 	strb.w	r4, [sp, #28]
                = PIC(&p_content->content.tagValueConfirm.tagValueList.pairs[nextElementIdx]);
c0de63e0:	f8dc 0000 	ldr.w	r0, [ip]
c0de63e4:	eb00 1006 	add.w	r0, r0, r6, lsl #4
c0de63e8:	f002 fd88 	bl	c0de8efc <pic>
c0de63ec:	f8ca 0000 	str.w	r0, [sl]
            for (uint8_t i = 0; i < nbElementsInPage; i++) {
c0de63f0:	b16c      	cbz	r4, c0de640e <displayGenericContextPage+0x31e>
c0de63f2:	f8da 0000 	ldr.w	r0, [sl]
c0de63f6:	300c      	adds	r0, #12
                if (p_tagValueList->pairs[i].aliasValue) {
c0de63f8:	7801      	ldrb	r1, [r0, #0]
c0de63fa:	0749      	lsls	r1, r1, #29
c0de63fc:	d404      	bmi.n	c0de6408 <displayGenericContextPage+0x318>
            for (uint8_t i = 0; i < nbElementsInPage; i++) {
c0de63fe:	3c01      	subs	r4, #1
c0de6400:	f100 0010 	add.w	r0, r0, #16
c0de6404:	d1f8      	bne.n	c0de63f8 <displayGenericContextPage+0x308>
c0de6406:	e002      	b.n	c0de640e <displayGenericContextPage+0x31e>
c0de6408:	200d      	movs	r0, #13
                    p_tagValueList->token = VALUE_ALIAS_TOKEN;
c0de640a:	f88d 0020 	strb.w	r0, [sp, #32]
            genericContext.currentPairs    = p_tagValueList->pairs;
c0de640e:	f8da 0000 	ldr.w	r0, [sl]
c0de6412:	f240 4a74 	movw	sl, #1140	@ 0x474
c0de6416:	f2c0 0a00 	movt	sl, #0
            genericContext.currentCallback = p_tagValueList->callback;
c0de641a:	9a06      	ldr	r2, [sp, #24]
            genericContext.currentPairs    = p_tagValueList->pairs;
c0de641c:	eb09 010a 	add.w	r1, r9, sl
c0de6420:	e9c1 0209 	strd	r0, r2, [r1, #36]	@ 0x24
c0de6424:	e07a      	b.n	c0de651c <displayGenericContextPage+0x42c>
                    pair = PIC(p_content->content.tagValueList.callback(nextElementIdx));
c0de6426:	f8db 1008 	ldr.w	r1, [fp, #8]
c0de642a:	4630      	mov	r0, r6
c0de642c:	4788      	blx	r1
c0de642e:	f002 fd65 	bl	c0de8efc <pic>
                if (pair->centeredInfo) {
c0de6432:	7b01      	ldrb	r1, [r0, #12]
c0de6434:	0789      	lsls	r1, r1, #30
c0de6436:	d418      	bmi.n	c0de646a <displayGenericContextPage+0x37a>
c0de6438:	2105      	movs	r1, #5
                    pageContent->type                               = TAG_VALUE_DETAILS;
c0de643a:	f88d 1010 	strb.w	r1, [sp, #16]
                    pageContent->tagValueDetails.detailsButtonText  = "More";
c0de643e:	f244 0112 	movw	r1, #16402	@ 0x4012
c0de6442:	f2c0 0100 	movt	r1, #0
c0de6446:	4479      	add	r1, pc
c0de6448:	910b      	str	r1, [sp, #44]	@ 0x2c
c0de644a:	2100      	movs	r1, #0
                    pageContent->tagValueDetails.detailsButtonIcon  = NULL;
c0de644c:	910a      	str	r1, [sp, #40]	@ 0x28
c0de644e:	210a      	movs	r1, #10
                    pageContent->tagValueDetails.detailsButtonToken = DETAILS_BUTTON_TOKEN;
c0de6450:	f88d 1030 	strb.w	r1, [sp, #48]	@ 0x30
                    genericContext.detailsItem     = pair->item;
c0de6454:	e9d0 2000 	ldrd	r2, r0, [r0]
c0de6458:	eb09 010a 	add.w	r1, r9, sl
c0de645c:	e9c1 2006 	strd	r2, r0, [r1, #24]
                    genericContext.detailsWrapping = p_content->content.tagValueList.wrapping;
c0de6460:	f89b 0012 	ldrb.w	r0, [fp, #18]
c0de6464:	f881 0020 	strb.w	r0, [r1, #32]
c0de6468:	e016      	b.n	c0de6498 <displayGenericContextPage+0x3a8>
c0de646a:	2101      	movs	r1, #1
                    pageContent->type = EXTENDED_CENTER;
c0de646c:	f88d 1010 	strb.w	r1, [sp, #16]
                                           pair->valueIcon,
c0de6470:	6882      	ldr	r2, [r0, #8]
                                           pair->item,
c0de6472:	e9d0 1000 	ldrd	r1, r0, [r0]
    contentCenter->icon        = icon;
c0de6476:	9206      	str	r2, [sp, #24]
    contentCenter->title       = reviewTitle;
c0de6478:	9109      	str	r1, [sp, #36]	@ 0x24
    contentCenter->description = reviewSubTitle;
c0de647a:	900b      	str	r0, [sp, #44]	@ 0x2c
    contentCenter->subText     = "Swipe to review";
c0de647c:	f244 301b 	movw	r0, #17179	@ 0x431b
c0de6480:	f2c0 0000 	movt	r0, #0
c0de6484:	4478      	add	r0, pc
c0de6486:	2700      	movs	r7, #0
c0de6488:	900c      	str	r0, [sp, #48]	@ 0x30
    contentCenter->smallTitle  = NULL;
c0de648a:	970a      	str	r7, [sp, #40]	@ 0x28
    contentCenter->iconHug     = 0;
c0de648c:	f8ad 7034 	strh.w	r7, [sp, #52]	@ 0x34
    contentCenter->padding     = false;
c0de6490:	f88d 7036 	strb.w	r7, [sp, #54]	@ 0x36
    contentCenter->illustrType = ICON_ILLUSTRATION;
c0de6494:	f88d 7014 	strb.w	r7, [sp, #20]
            if (p_tagValueList != NULL) {
c0de6498:	2f00      	cmp	r7, #0
c0de649a:	d03f      	beq.n	c0de651c <displayGenericContextPage+0x42c>
                p_tagValueList->nbPairs = nbElementsInPage;
c0de649c:	723c      	strb	r4, [r7, #8]
                p_tagValueList->token   = p_content->content.tagValueList.token;
c0de649e:	f89b 0010 	ldrb.w	r0, [fp, #16]
c0de64a2:	46c2      	mov	sl, r8
c0de64a4:	7338      	strb	r0, [r7, #12]
                if (p_content->content.tagValueList.pairs != NULL) {
c0de64a6:	f8db 0004 	ldr.w	r0, [fp, #4]
c0de64aa:	46a8      	mov	r8, r5
c0de64ac:	b178      	cbz	r0, c0de64ce <displayGenericContextPage+0x3de>
                        = PIC(&p_content->content.tagValueList.pairs[nextElementIdx]);
c0de64ae:	eb00 1006 	add.w	r0, r0, r6, lsl #4
c0de64b2:	f002 fd23 	bl	c0de8efc <pic>
c0de64b6:	6038      	str	r0, [r7, #0]
                    for (uint8_t i = 0; i < nbElementsInPage; i++) {
c0de64b8:	b314      	cbz	r4, c0de6500 <displayGenericContextPage+0x410>
c0de64ba:	6838      	ldr	r0, [r7, #0]
c0de64bc:	300c      	adds	r0, #12
                        if (p_tagValueList->pairs[i].aliasValue) {
c0de64be:	7801      	ldrb	r1, [r0, #0]
c0de64c0:	0749      	lsls	r1, r1, #29
c0de64c2:	d41b      	bmi.n	c0de64fc <displayGenericContextPage+0x40c>
                    for (uint8_t i = 0; i < nbElementsInPage; i++) {
c0de64c4:	3c01      	subs	r4, #1
c0de64c6:	f100 0010 	add.w	r0, r0, #16
c0de64ca:	d1f8      	bne.n	c0de64be <displayGenericContextPage+0x3ce>
c0de64cc:	e018      	b.n	c0de6500 <displayGenericContextPage+0x410>
c0de64ce:	2000      	movs	r0, #0
                    p_tagValueList->pairs      = NULL;
c0de64d0:	6038      	str	r0, [r7, #0]
                    p_tagValueList->callback   = p_content->content.tagValueList.callback;
c0de64d2:	f8db 0008 	ldr.w	r0, [fp, #8]
c0de64d6:	6078      	str	r0, [r7, #4]
                    p_tagValueList->startIndex = nextElementIdx;
c0de64d8:	727e      	strb	r6, [r7, #9]
                    for (uint8_t i = 0; i < nbElementsInPage; i++) {
c0de64da:	b18c      	cbz	r4, c0de6500 <displayGenericContextPage+0x410>
c0de64dc:	2500      	movs	r5, #0
                            = PIC(p_content->content.tagValueList.callback(nextElementIdx + i));
c0de64de:	f8db 1008 	ldr.w	r1, [fp, #8]
c0de64e2:	19a8      	adds	r0, r5, r6
c0de64e4:	b2c0      	uxtb	r0, r0
c0de64e6:	4788      	blx	r1
c0de64e8:	f002 fd08 	bl	c0de8efc <pic>
                        if (pair->aliasValue) {
c0de64ec:	7b00      	ldrb	r0, [r0, #12]
c0de64ee:	0740      	lsls	r0, r0, #29
c0de64f0:	d404      	bmi.n	c0de64fc <displayGenericContextPage+0x40c>
c0de64f2:	3501      	adds	r5, #1
                    for (uint8_t i = 0; i < nbElementsInPage; i++) {
c0de64f4:	b2e8      	uxtb	r0, r5
c0de64f6:	42a0      	cmp	r0, r4
c0de64f8:	d3f1      	bcc.n	c0de64de <displayGenericContextPage+0x3ee>
c0de64fa:	e001      	b.n	c0de6500 <displayGenericContextPage+0x410>
c0de64fc:	200d      	movs	r0, #13
c0de64fe:	7338      	strb	r0, [r7, #12]
c0de6500:	2000      	movs	r0, #0
                p_tagValueList->smallCaseForValue  = false;
c0de6502:	7378      	strb	r0, [r7, #13]
c0de6504:	f640 1001 	movw	r0, #2305	@ 0x901
                p_tagValueList->hideEndOfLastLine  = true;
c0de6508:	8178      	strh	r0, [r7, #10]
                p_tagValueList->wrapping           = p_content->content.tagValueList.wrapping;
c0de650a:	f89b 0012 	ldrb.w	r0, [fp, #18]
c0de650e:	4645      	mov	r5, r8
c0de6510:	46d0      	mov	r8, sl
c0de6512:	f240 4a74 	movw	sl, #1140	@ 0x474
c0de6516:	73b8      	strb	r0, [r7, #14]
c0de6518:	f2c0 0a00 	movt	sl, #0
        = (navType == STREAMING_NAV)
c0de651c:	f240 4070 	movw	r0, #1136	@ 0x470
c0de6520:	f2c0 0000 	movt	r0, #0
c0de6524:	f819 2000 	ldrb.w	r2, [r9, r0]
        = ((p_content->type == CENTERED_INFO) || (p_content->type == EXTENDED_CENTER))
c0de6528:	f89b 1000 	ldrb.w	r1, [fp]
        = (navType == STREAMING_NAV)
c0de652c:	f002 02fe 	and.w	r2, r2, #254	@ 0xfe
c0de6530:	f859 0008 	ldr.w	r0, [r9, r8]
c0de6534:	2a02      	cmp	r2, #2
c0de6536:	f240 52ec 	movw	r2, #1516	@ 0x5ec
c0de653a:	bf18      	it	ne
c0de653c:	2000      	movne	r0, #0
        && (operationType & (BLIND_OPERATION | RISKY_OPERATION | NO_THREAT_OPERATION))) {
c0de653e:	2902      	cmp	r1, #2
c0de6540:	f2c0 0200 	movt	r2, #0
c0de6544:	d81d      	bhi.n	c0de6582 <displayGenericContextPage+0x492>
c0de6546:	f010 01e0 	ands.w	r1, r0, #224	@ 0xe0
c0de654a:	d01a      	beq.n	c0de6582 <displayGenericContextPage+0x492>
            && !(reviewWithWarnCtx.warning->predefinedSet & (1 << BLIND_SIGNING_WARN))) {
c0de654c:	0601      	lsls	r1, r0, #24
c0de654e:	d50b      	bpl.n	c0de6568 <displayGenericContextPage+0x478>
c0de6550:	eb09 010a 	add.w	r1, r9, sl
c0de6554:	6f89      	ldr	r1, [r1, #120]	@ 0x78
        if ((operationType & NO_THREAT_OPERATION)
c0de6556:	7809      	ldrb	r1, [r1, #0]
c0de6558:	06c9      	lsls	r1, r1, #27
c0de655a:	d405      	bmi.n	c0de6568 <displayGenericContextPage+0x478>
c0de655c:	f643 11bd 	movw	r1, #14781	@ 0x39bd
c0de6560:	f2c0 0100 	movt	r1, #0
c0de6564:	4479      	add	r1, pc
c0de6566:	e004      	b.n	c0de6572 <displayGenericContextPage+0x482>
c0de6568:	f643 414f 	movw	r1, #15439	@ 0x3c4f
c0de656c:	f2c0 0100 	movt	r1, #0
c0de6570:	4479      	add	r1, pc
            = (operationType & BLIND_OPERATION) ? BLIND_WARNING_TOKEN : WARNING_BUTTON_TOKEN;
c0de6572:	0680      	lsls	r0, r0, #26
c0de6574:	f04f 0010 	mov.w	r0, #16
c0de6578:	9103      	str	r1, [sp, #12]
c0de657a:	bf58      	it	pl
c0de657c:	2011      	movpl	r0, #17
c0de657e:	f88d 000b 	strb.w	r0, [sp, #11]
    pageContext = nbgl_pageDrawGenericContent(&pageCallback, &navInfo, &pageContent);
c0de6582:	f240 1081 	movw	r0, #385	@ 0x181
c0de6586:	f2c0 0000 	movt	r0, #0
c0de658a:	eb09 0102 	add.w	r1, r9, r2
c0de658e:	4478      	add	r0, pc
c0de6590:	aa01      	add	r2, sp, #4
c0de6592:	f7ff f95b 	bl	c0de584c <nbgl_pageDrawGenericContent>
c0de6596:	f240 51d4 	movw	r1, #1492	@ 0x5d4
c0de659a:	f2c0 0100 	movt	r1, #0
c0de659e:	f849 0001 	str.w	r0, [r9, r1]
c0de65a2:	2001      	movs	r0, #1
c0de65a4:	2d00      	cmp	r5, #0
c0de65a6:	bf18      	it	ne
c0de65a8:	2002      	movne	r0, #2
c0de65aa:	f001 fd7d 	bl	c0de80a8 <nbgl_refreshSpecial>
}
c0de65ae:	b020      	add	sp, #128	@ 0x80
c0de65b0:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de65b4 <nbgl_useCaseHomeAndSettings>:
        initSettingPage,  // if not INIT_HOME_PAGE, start directly the corresponding setting page
    const nbgl_genericContents_t *settingContents,
    const nbgl_contentInfoList_t *infosList,
    const nbgl_homeAction_t      *action,  // Set to NULL if no additional action
    nbgl_callback_t               quitCallback)
{
c0de65b4:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de65b8:	b084      	sub	sp, #16
c0de65ba:	4604      	mov	r4, r0
    onQuit          = NULL;
c0de65bc:	f240 4060 	movw	r0, #1120	@ 0x460
c0de65c0:	f2c0 0000 	movt	r0, #0
c0de65c4:	f04f 0a00 	mov.w	sl, #0
c0de65c8:	f849 a000 	str.w	sl, [r9, r0]
    onContinue      = NULL;
c0de65cc:	f240 50e8 	movw	r0, #1512	@ 0x5e8
c0de65d0:	f2c0 0000 	movt	r0, #0
c0de65d4:	f849 a000 	str.w	sl, [r9, r0]
    onAction        = NULL;
c0de65d8:	f240 50e4 	movw	r0, #1508	@ 0x5e4
c0de65dc:	f2c0 0000 	movt	r0, #0
c0de65e0:	f849 a000 	str.w	sl, [r9, r0]
    onNav           = NULL;
c0de65e4:	f240 4064 	movw	r0, #1124	@ 0x464
c0de65e8:	f2c0 0000 	movt	r0, #0
c0de65ec:	f849 a000 	str.w	sl, [r9, r0]
    onControls      = NULL;
c0de65f0:	f240 4068 	movw	r0, #1128	@ 0x468
c0de65f4:	f2c0 0000 	movt	r0, #0
c0de65f8:	f849 a000 	str.w	sl, [r9, r0]
    onContentAction = NULL;
c0de65fc:	f240 60c0 	movw	r0, #1728	@ 0x6c0
c0de6600:	f2c0 0000 	movt	r0, #0
c0de6604:	f849 a000 	str.w	sl, [r9, r0]
    onChoice        = NULL;
c0de6608:	f240 50d8 	movw	r0, #1496	@ 0x5d8
c0de660c:	f2c0 0000 	movt	r0, #0
c0de6610:	f849 a000 	str.w	sl, [r9, r0]
    memset(&genericContext, 0, sizeof(genericContext));
c0de6614:	f240 4074 	movw	r0, #1140	@ 0x474
c0de6618:	f2c0 0000 	movt	r0, #0
c0de661c:	460f      	mov	r7, r1
c0de661e:	e9dd b50e 	ldrd	fp, r5, [sp, #56]	@ 0x38
c0de6622:	f8dd 8030 	ldr.w	r8, [sp, #48]	@ 0x30
c0de6626:	4448      	add	r0, r9
c0de6628:	2190      	movs	r1, #144	@ 0x90
c0de662a:	9303      	str	r3, [sp, #12]
c0de662c:	4616      	mov	r6, r2
c0de662e:	f002 fe59 	bl	c0de92e4 <__aeabi_memclr>
    nbgl_homeAndSettingsContext_t *context = &bundleNavContext.homeAndSettings;

    reset_callbacks_and_context();

    context->appName         = appName;
c0de6632:	f240 5eac 	movw	lr, #1452	@ 0x5ac
c0de6636:	f2c0 0e00 	movt	lr, #0
c0de663a:	eb09 030e 	add.w	r3, r9, lr
c0de663e:	4639      	mov	r1, r7
    context->appIcon         = appIcon;
c0de6640:	e9c3 7601 	strd	r7, r6, [r3, #4]
    context->tagline         = tagline;
    context->settingContents = settingContents;
    context->infosList       = infosList;
c0de6644:	9f0d      	ldr	r7, [sp, #52]	@ 0x34
c0de6646:	4620      	mov	r0, r4
c0de6648:	4632      	mov	r2, r6
    if (action != NULL) {
c0de664a:	f1bb 0f00 	cmp.w	fp, #0
    context->appName         = appName;
c0de664e:	f849 400e 	str.w	r4, [r9, lr]
    context->settingContents = settingContents;
c0de6652:	f8c3 800c 	str.w	r8, [r3, #12]
    context->infosList       = infosList;
c0de6656:	611f      	str	r7, [r3, #16]
    if (action != NULL) {
c0de6658:	d00c      	beq.n	c0de6674 <nbgl_useCaseHomeAndSettings+0xc0>
c0de665a:	46ac      	mov	ip, r5
        memcpy(&context->homeAction, action, sizeof(nbgl_homeAction_t));
c0de665c:	e9db 5300 	ldrd	r5, r3, [fp]
c0de6660:	e9db 7602 	ldrd	r7, r6, [fp, #8]
c0de6664:	eb09 040e 	add.w	r4, r9, lr
c0de6668:	6165      	str	r5, [r4, #20]
c0de666a:	4665      	mov	r5, ip
c0de666c:	e9c4 3706 	strd	r3, r7, [r4, #24]
c0de6670:	6226      	str	r6, [r4, #32]
c0de6672:	e005      	b.n	c0de6680 <nbgl_useCaseHomeAndSettings+0xcc>
    }
    else {
        memset(&context->homeAction, 0, sizeof(nbgl_homeAction_t));
c0de6674:	eb09 030e 	add.w	r3, r9, lr
c0de6678:	e9c3 aa05 	strd	sl, sl, [r3, #20]
c0de667c:	e9c3 aa07 	strd	sl, sl, [r3, #28]
c0de6680:	9e03      	ldr	r6, [sp, #12]
    }
    context->quitCallback = quitCallback;
c0de6682:	eb09 030e 	add.w	r3, r9, lr

    if (initSettingPage != INIT_HOME_PAGE) {
c0de6686:	2eff      	cmp	r6, #255	@ 0xff
    context->quitCallback = quitCallback;
c0de6688:	625d      	str	r5, [r3, #36]	@ 0x24
    if (initSettingPage != INIT_HOME_PAGE) {
c0de668a:	d00d      	beq.n	c0de66a8 <nbgl_useCaseHomeAndSettings+0xf4>
    nbgl_useCaseGenericSettings(context->appName,
c0de668c:	f240 073b 	movw	r7, #59	@ 0x3b
c0de6690:	f2c0 0700 	movt	r7, #0
c0de6694:	9b0d      	ldr	r3, [sp, #52]	@ 0x34
c0de6696:	447f      	add	r7, pc
c0de6698:	4631      	mov	r1, r6
c0de669a:	4642      	mov	r2, r8
c0de669c:	9700      	str	r7, [sp, #0]
c0de669e:	f7ff faf5 	bl	c0de5c8c <nbgl_useCaseGenericSettings>
        bundleNavStartSettingsAtPage(initSettingPage);
    }
    else {
        bundleNavStartHome();
    }
}
c0de66a2:	b004      	add	sp, #16
c0de66a4:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
                   context->settingContents != NULL ? true : false,
c0de66a8:	f1b8 0f00 	cmp.w	r8, #0
c0de66ac:	bf18      	it	ne
c0de66ae:	f04f 0801 	movne.w	r8, #1
    useCaseHomeExt(context->appName,
c0de66b2:	f640 13b9 	movw	r3, #2489	@ 0x9b9
c0de66b6:	f2c0 0300 	movt	r3, #0
c0de66ba:	eb09 070e 	add.w	r7, r9, lr
c0de66be:	447b      	add	r3, pc
c0de66c0:	3714      	adds	r7, #20
c0de66c2:	e9cd 7300 	strd	r7, r3, [sp]
c0de66c6:	4643      	mov	r3, r8
c0de66c8:	9502      	str	r5, [sp, #8]
c0de66ca:	f7ff f9b9 	bl	c0de5a40 <useCaseHomeExt>
}
c0de66ce:	b004      	add	sp, #16
c0de66d0:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de66d4 <bundleNavStartHome>:
{
c0de66d4:	b5b0      	push	{r4, r5, r7, lr}
c0de66d6:	b084      	sub	sp, #16
    useCaseHomeExt(context->appName,
c0de66d8:	f240 51ac 	movw	r1, #1452	@ 0x5ac
c0de66dc:	f2c0 0100 	movt	r1, #0
c0de66e0:	eb09 0c01 	add.w	ip, r9, r1
                   context->appIcon,
c0de66e4:	f10c 0304 	add.w	r3, ip, #4
    useCaseHomeExt(context->appName,
c0de66e8:	f859 0001 	ldr.w	r0, [r9, r1]
                   context->appIcon,
c0de66ec:	cb0e      	ldmia	r3, {r1, r2, r3}
                   context->quitCallback);
c0de66ee:	f8dc e024 	ldr.w	lr, [ip, #36]	@ 0x24
                   context->settingContents != NULL ? true : false,
c0de66f2:	2b00      	cmp	r3, #0
c0de66f4:	bf18      	it	ne
c0de66f6:	2301      	movne	r3, #1
    useCaseHomeExt(context->appName,
c0de66f8:	f640 1573 	movw	r5, #2419	@ 0x973
c0de66fc:	f2c0 0500 	movt	r5, #0
c0de6700:	f10c 0414 	add.w	r4, ip, #20
c0de6704:	447d      	add	r5, pc
c0de6706:	e88d 4030 	stmia.w	sp, {r4, r5, lr}
c0de670a:	f7ff f999 	bl	c0de5a40 <useCaseHomeExt>
}
c0de670e:	b004      	add	sp, #16
c0de6710:	bdb0      	pop	{r4, r5, r7, pc}

c0de6712 <pageCallback>:
{
c0de6712:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de6716:	b09e      	sub	sp, #120	@ 0x78
c0de6718:	4605      	mov	r5, r0
    if (token == QUIT_TOKEN) {
c0de671a:	2808      	cmp	r0, #8
c0de671c:	460c      	mov	r4, r1
c0de671e:	dc1f      	bgt.n	c0de6760 <pageCallback+0x4e>
c0de6720:	2d04      	cmp	r5, #4
c0de6722:	f300 8086 	bgt.w	c0de6832 <pageCallback+0x120>
c0de6726:	2d01      	cmp	r5, #1
c0de6728:	f300 80a3 	bgt.w	c0de6872 <pageCallback+0x160>
c0de672c:	2d00      	cmp	r5, #0
c0de672e:	f000 8101 	beq.w	c0de6934 <pageCallback+0x222>
c0de6732:	2d01      	cmp	r5, #1
c0de6734:	f040 81d2 	bne.w	c0de6adc <pageCallback+0x3ca>
        if (onNav != NULL) {
c0de6738:	f240 4064 	movw	r0, #1124	@ 0x464
c0de673c:	f240 51ec 	movw	r1, #1516	@ 0x5ec
c0de6740:	f2c0 0000 	movt	r0, #0
c0de6744:	f2c0 0100 	movt	r1, #0
c0de6748:	f859 0000 	ldr.w	r0, [r9, r0]
c0de674c:	f819 1001 	ldrb.w	r1, [r9, r1]
c0de6750:	2800      	cmp	r0, #0
c0de6752:	f101 0001 	add.w	r0, r1, #1
c0de6756:	f000 81df 	beq.w	c0de6b18 <pageCallback+0x406>
            displayReviewPage(navInfo.activePage + 1, false);
c0de675a:	b2c0      	uxtb	r0, r0
c0de675c:	2100      	movs	r1, #0
c0de675e:	e0fc      	b.n	c0de695a <pageCallback+0x248>
    if (token == QUIT_TOKEN) {
c0de6760:	2d0c      	cmp	r5, #12
c0de6762:	dc73      	bgt.n	c0de684c <pageCallback+0x13a>
c0de6764:	2d0a      	cmp	r5, #10
c0de6766:	f300 8098 	bgt.w	c0de689a <pageCallback+0x188>
c0de676a:	2d09      	cmp	r5, #9
c0de676c:	f000 80fa 	beq.w	c0de6964 <pageCallback+0x252>
c0de6770:	2d0a      	cmp	r5, #10
c0de6772:	f040 81b3 	bne.w	c0de6adc <pageCallback+0x3ca>
        displayDetails(genericContext.detailsItem,
c0de6776:	f240 4074 	movw	r0, #1140	@ 0x474
c0de677a:	f2c0 0000 	movt	r0, #0
c0de677e:	4448      	add	r0, r9
c0de6780:	e9d0 b506 	ldrd	fp, r5, [r0, #24]
                       genericContext.detailsWrapping);
c0de6784:	f890 4020 	ldrb.w	r4, [r0, #32]
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de6788:	f240 7ac4 	movw	sl, #1988	@ 0x7c4
c0de678c:	f2c0 0a00 	movt	sl, #0
c0de6790:	2600      	movs	r6, #0
c0de6792:	eb09 070a 	add.w	r7, r9, sl
        = nbgl_getTextNbLinesInWidth(SMALL_REGULAR_FONT, value, AVAILABLE_WIDTH, wrapping);
c0de6796:	200b      	movs	r0, #11
c0de6798:	4629      	mov	r1, r5
c0de679a:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de679e:	4623      	mov	r3, r4
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de67a0:	f849 600a 	str.w	r6, [r9, sl]
c0de67a4:	e9c7 6601 	strd	r6, r6, [r7, #4]
c0de67a8:	60fe      	str	r6, [r7, #12]
c0de67aa:	f04f 080b 	mov.w	r8, #11
        = nbgl_getTextNbLinesInWidth(SMALL_REGULAR_FONT, value, AVAILABLE_WIDTH, wrapping);
c0de67ae:	f001 fcd0 	bl	c0de8152 <nbgl_getTextNbLinesInWidth>
c0de67b2:	f648 31a3 	movw	r1, #35747	@ 0x8ba3
    detailsContext.nbPages     = (nbLines + NB_MAX_LINES_IN_DETAILS - 1) / NB_MAX_LINES_IN_DETAILS;
c0de67b6:	f100 020a 	add.w	r2, r0, #10
c0de67ba:	f6cb 212e 	movt	r1, #47662	@ 0xba2e
c0de67be:	fba2 2301 	umull	r2, r3, r2, r1
c0de67c2:	08da      	lsrs	r2, r3, #3
    if (detailsContext.nbPages > 1) {
c0de67c4:	f3c3 03c7 	ubfx	r3, r3, #3, #8
c0de67c8:	2b02      	cmp	r3, #2
    detailsContext.tag         = tag;
c0de67ca:	e9c7 b501 	strd	fp, r5, [r7, #4]
    detailsContext.nbPages     = (nbLines + NB_MAX_LINES_IN_DETAILS - 1) / NB_MAX_LINES_IN_DETAILS;
c0de67ce:	f809 200a 	strb.w	r2, [r9, sl]
    detailsContext.currentPage = 0;
c0de67d2:	707e      	strb	r6, [r7, #1]
    detailsContext.wrapping    = wrapping;
c0de67d4:	70fc      	strb	r4, [r7, #3]
c0de67d6:	d325      	bcc.n	c0de6824 <pageCallback+0x112>
        uint16_t nbLostChars = (detailsContext.nbPages - 1) * 3;
c0de67d8:	3b01      	subs	r3, #1
c0de67da:	eb03 0743 	add.w	r7, r3, r3, lsl #1
        uint16_t nbLostLines = (nbLostChars + ((AVAILABLE_WIDTH) / 16) - 1)
c0de67de:	b2bf      	uxth	r7, r7
c0de67e0:	f64e 464f 	movw	r6, #60495	@ 0xec4f
c0de67e4:	3719      	adds	r7, #25
c0de67e6:	f6c4 66c4 	movt	r6, #20164	@ 0x4ec4
c0de67ea:	f649 042b 	movw	r4, #38955	@ 0x982b
                               / ((AVAILABLE_WIDTH) / 16);  // 16 for average char width
c0de67ee:	fba7 6506 	umull	r6, r5, r7, r6
c0de67f2:	f2ce 5425 	movt	r4, #58661	@ 0xe525
c0de67f6:	08ee      	lsrs	r6, r5, #3
        detailsContext.nbPages += nbLostLines / NB_MAX_LINES_IN_DETAILS;
c0de67f8:	fba7 7404 	umull	r7, r4, r7, r4
        if ((nbLinesInLastPage + (nbLostLines % NB_MAX_LINES_IN_DETAILS))
c0de67fc:	fba6 1701 	umull	r1, r7, r6, r1
c0de6800:	f06f 010a 	mvn.w	r1, #10
            = nbLines - ((detailsContext.nbPages - 1) * NB_MAX_LINES_IN_DETAILS);
c0de6804:	fb03 0001 	mla	r0, r3, r1, r0
        detailsContext.nbPages += nbLostLines / NB_MAX_LINES_IN_DETAILS;
c0de6808:	eb02 2114 	add.w	r1, r2, r4, lsr #8
        if ((nbLinesInLastPage + (nbLostLines % NB_MAX_LINES_IN_DETAILS))
c0de680c:	08fa      	lsrs	r2, r7, #3
c0de680e:	fb02 f208 	mul.w	r2, r2, r8
c0de6812:	b2c0      	uxtb	r0, r0
c0de6814:	ebc2 02d5 	rsb	r2, r2, r5, lsr #3
c0de6818:	4410      	add	r0, r2
c0de681a:	280b      	cmp	r0, #11
c0de681c:	bf88      	it	hi
c0de681e:	3101      	addhi	r1, #1
c0de6820:	f809 100a 	strb.w	r1, [r9, sl]
    displayDetailsPage(0, true);
c0de6824:	2000      	movs	r0, #0
c0de6826:	2101      	movs	r1, #1
c0de6828:	f001 f806 	bl	c0de7838 <displayDetailsPage>
}
c0de682c:	b01e      	add	sp, #120	@ 0x78
c0de682e:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
    if (token == QUIT_TOKEN) {
c0de6832:	2d06      	cmp	r5, #6
c0de6834:	dc42      	bgt.n	c0de68bc <pageCallback+0x1aa>
c0de6836:	2d05      	cmp	r5, #5
c0de6838:	f000 80a1 	beq.w	c0de697e <pageCallback+0x26c>
c0de683c:	2d06      	cmp	r5, #6
c0de683e:	f040 814d 	bne.w	c0de6adc <pageCallback+0x3ca>
        if (onContinue != NULL) {
c0de6842:	f240 50e8 	movw	r0, #1512	@ 0x5e8
c0de6846:	f2c0 0000 	movt	r0, #0
c0de684a:	e04c      	b.n	c0de68e6 <pageCallback+0x1d4>
    if (token == QUIT_TOKEN) {
c0de684c:	2d10      	cmp	r5, #16
c0de684e:	dc53      	bgt.n	c0de68f8 <pageCallback+0x1e6>
c0de6850:	2d0d      	cmp	r5, #13
c0de6852:	f000 80b5 	beq.w	c0de69c0 <pageCallback+0x2ae>
c0de6856:	2d10      	cmp	r5, #16
c0de6858:	f040 8140 	bne.w	c0de6adc <pageCallback+0x3ca>
        reviewWithWarnCtx.isIntro = false;
c0de685c:	f240 4074 	movw	r0, #1140	@ 0x474
c0de6860:	f2c0 0000 	movt	r0, #0
c0de6864:	4448      	add	r0, r9
c0de6866:	2100      	movs	r1, #0
c0de6868:	f880 1089 	strb.w	r1, [r0, #137]	@ 0x89
        reviewWithWarnCtx.warning = NULL;
c0de686c:	6781      	str	r1, [r0, #120]	@ 0x78
        displaySecurityReport(1 << BLIND_SIGNING_WARN);
c0de686e:	2010      	movs	r0, #16
c0de6870:	e12f      	b.n	c0de6ad2 <pageCallback+0x3c0>
    if (token == QUIT_TOKEN) {
c0de6872:	2d02      	cmp	r5, #2
c0de6874:	d033      	beq.n	c0de68de <pageCallback+0x1cc>
c0de6876:	2d03      	cmp	r5, #3
c0de6878:	f040 8130 	bne.w	c0de6adc <pageCallback+0x3ca>
        if (index == EXIT_PAGE) {
c0de687c:	2cff      	cmp	r4, #255	@ 0xff
c0de687e:	d02e      	beq.n	c0de68de <pageCallback+0x1cc>
            if (navType == GENERIC_NAV || navType == STREAMING_NAV) {
c0de6880:	f240 4070 	movw	r0, #1136	@ 0x470
c0de6884:	f2c0 0000 	movt	r0, #0
c0de6888:	f819 0000 	ldrb.w	r0, [r9, r0]
c0de688c:	f000 01fe 	and.w	r1, r0, #254	@ 0xfe
c0de6890:	2902      	cmp	r1, #2
c0de6892:	f040 81a3 	bne.w	c0de6bdc <pageCallback+0x4ca>
                displayGenericContextPage(index, false);
c0de6896:	4620      	mov	r0, r4
c0de6898:	e13f      	b.n	c0de6b1a <pageCallback+0x408>
    if (token == QUIT_TOKEN) {
c0de689a:	2d0b      	cmp	r5, #11
c0de689c:	f000 80a0 	beq.w	c0de69e0 <pageCallback+0x2ce>
c0de68a0:	2d0c      	cmp	r5, #12
c0de68a2:	f040 811b 	bne.w	c0de6adc <pageCallback+0x3ca>
        if (onChoice != NULL) {
c0de68a6:	f240 50d8 	movw	r0, #1496	@ 0x5d8
c0de68aa:	f2c0 0000 	movt	r0, #0
c0de68ae:	f859 1000 	ldr.w	r1, [r9, r0]
c0de68b2:	2900      	cmp	r1, #0
c0de68b4:	f000 817a 	beq.w	c0de6bac <pageCallback+0x49a>
            onChoice(false);
c0de68b8:	2000      	movs	r0, #0
c0de68ba:	e09b      	b.n	c0de69f4 <pageCallback+0x2e2>
    if (token == QUIT_TOKEN) {
c0de68bc:	2d07      	cmp	r5, #7
c0de68be:	f000 809d 	beq.w	c0de69fc <pageCallback+0x2ea>
c0de68c2:	2d08      	cmp	r5, #8
c0de68c4:	f040 810a 	bne.w	c0de6adc <pageCallback+0x3ca>
c0de68c8:	b934      	cbnz	r4, c0de68d8 <pageCallback+0x1c6>
c0de68ca:	f240 50e4 	movw	r0, #1508	@ 0x5e4
c0de68ce:	f2c0 0000 	movt	r0, #0
c0de68d2:	f859 0000 	ldr.w	r0, [r9, r0]
c0de68d6:	b958      	cbnz	r0, c0de68f0 <pageCallback+0x1de>
        else if ((index == 1) && (onQuit != NULL)) {
c0de68d8:	2c01      	cmp	r4, #1
c0de68da:	f040 8167 	bne.w	c0de6bac <pageCallback+0x49a>
c0de68de:	f240 4060 	movw	r0, #1120	@ 0x460
c0de68e2:	f2c0 0000 	movt	r0, #0
c0de68e6:	f859 0000 	ldr.w	r0, [r9, r0]
c0de68ea:	2800      	cmp	r0, #0
c0de68ec:	f000 815e 	beq.w	c0de6bac <pageCallback+0x49a>
c0de68f0:	4780      	blx	r0
}
c0de68f2:	b01e      	add	sp, #120	@ 0x78
c0de68f4:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
    if (token == QUIT_TOKEN) {
c0de68f8:	2d11      	cmp	r5, #17
c0de68fa:	f000 80dd 	beq.w	c0de6ab8 <pageCallback+0x3a6>
c0de68fe:	2d13      	cmp	r5, #19
c0de6900:	f040 80ec 	bne.w	c0de6adc <pageCallback+0x3ca>
        if (genericContext.validWarningCtx && (reviewWithWarnCtx.warning->predefinedSet != 0)) {
c0de6904:	f240 4074 	movw	r0, #1140	@ 0x474
c0de6908:	f2c0 0000 	movt	r0, #0
c0de690c:	eb09 0100 	add.w	r1, r9, r0
c0de6910:	f891 1021 	ldrb.w	r1, [r1, #33]	@ 0x21
c0de6914:	2900      	cmp	r1, #0
c0de6916:	f000 8106 	beq.w	c0de6b26 <pageCallback+0x414>
c0de691a:	eb09 0100 	add.w	r1, r9, r0
c0de691e:	6f89      	ldr	r1, [r1, #120]	@ 0x78
c0de6920:	680a      	ldr	r2, [r1, #0]
c0de6922:	2a00      	cmp	r2, #0
c0de6924:	f000 80ff 	beq.w	c0de6b26 <pageCallback+0x414>
            reviewWithWarnCtx.securityReportLevel = 1;
c0de6928:	4448      	add	r0, r9
c0de692a:	2201      	movs	r2, #1
c0de692c:	f880 2088 	strb.w	r2, [r0, #136]	@ 0x88
            displaySecurityReport(reviewWithWarnCtx.warning->predefinedSet);
c0de6930:	6808      	ldr	r0, [r1, #0]
c0de6932:	e0ce      	b.n	c0de6ad2 <pageCallback+0x3c0>
        if (onNav != NULL) {
c0de6934:	f240 4064 	movw	r0, #1124	@ 0x464
c0de6938:	f240 51ec 	movw	r1, #1516	@ 0x5ec
c0de693c:	f2c0 0000 	movt	r0, #0
c0de6940:	f2c0 0100 	movt	r1, #0
c0de6944:	f859 0000 	ldr.w	r0, [r9, r0]
c0de6948:	f819 1001 	ldrb.w	r1, [r9, r1]
c0de694c:	2800      	cmp	r0, #0
c0de694e:	f1a1 0001 	sub.w	r0, r1, #1
c0de6952:	f000 80e1 	beq.w	c0de6b18 <pageCallback+0x406>
            displayReviewPage(navInfo.activePage - 1, true);
c0de6956:	b2c0      	uxtb	r0, r0
c0de6958:	2101      	movs	r1, #1
c0de695a:	f000 fa44 	bl	c0de6de6 <displayReviewPage>
}
c0de695e:	b01e      	add	sp, #120	@ 0x78
c0de6960:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        if (onChoice != NULL) {
c0de6964:	f240 50d8 	movw	r0, #1496	@ 0x5d8
c0de6968:	f2c0 0000 	movt	r0, #0
c0de696c:	f859 1000 	ldr.w	r1, [r9, r0]
c0de6970:	2900      	cmp	r1, #0
c0de6972:	f000 811b 	beq.w	c0de6bac <pageCallback+0x49a>
            onChoice((index == 0) ? true : false);
c0de6976:	fab4 f084 	clz	r0, r4
c0de697a:	0940      	lsrs	r0, r0, #5
c0de697c:	e03a      	b.n	c0de69f4 <pageCallback+0x2e2>
    nbgl_pageConfirmationDescription_t info = {
c0de697e:	f643 704e 	movw	r0, #16206	@ 0x3f4e
c0de6982:	f2c0 0000 	movt	r0, #0
c0de6986:	4478      	add	r0, pc
c0de6988:	c8cc      	ldmia	r0!, {r2, r3, r6, r7}
c0de698a:	a907      	add	r1, sp, #28
c0de698c:	c1cc      	stmia	r1!, {r2, r3, r6, r7}
c0de698e:	e890 00cc 	ldmia.w	r0, {r2, r3, r6, r7}
    if (modalPageContext != NULL) {
c0de6992:	f240 54e0 	movw	r4, #1504	@ 0x5e0
    nbgl_pageConfirmationDescription_t info = {
c0de6996:	c1cc      	stmia	r1!, {r2, r3, r6, r7}
    if (modalPageContext != NULL) {
c0de6998:	f2c0 0400 	movt	r4, #0
c0de699c:	f859 0004 	ldr.w	r0, [r9, r4]
c0de69a0:	2800      	cmp	r0, #0
        nbgl_pageRelease(modalPageContext);
c0de69a2:	bf18      	it	ne
c0de69a4:	f7fe ff57 	blne	c0de5856 <nbgl_pageRelease>
    modalPageContext = nbgl_pageDrawConfirmation(&pageModalCallback, &info);
c0de69a8:	f240 3031 	movw	r0, #817	@ 0x331
c0de69ac:	f2c0 0000 	movt	r0, #0
c0de69b0:	4478      	add	r0, pc
c0de69b2:	a907      	add	r1, sp, #28
c0de69b4:	f7fe fc66 	bl	c0de5284 <nbgl_pageDrawConfirmation>
c0de69b8:	f849 0004 	str.w	r0, [r9, r4]
    nbgl_refreshSpecial(FULL_COLOR_PARTIAL_REFRESH);
c0de69bc:	2001      	movs	r0, #1
c0de69be:	e0f3      	b.n	c0de6ba8 <pageCallback+0x496>
        if (genericContext.currentPairs != NULL) {
c0de69c0:	f240 4074 	movw	r0, #1140	@ 0x474
c0de69c4:	f2c0 0000 	movt	r0, #0
c0de69c8:	eb09 0100 	add.w	r1, r9, r0
c0de69cc:	6a49      	ldr	r1, [r1, #36]	@ 0x24
            pair = genericContext.currentCallback(genericContext.currentElementIdx + index);
c0de69ce:	4448      	add	r0, r9
        if (genericContext.currentPairs != NULL) {
c0de69d0:	2900      	cmp	r1, #0
c0de69d2:	f000 80ee 	beq.w	c0de6bb2 <pageCallback+0x4a0>
            pair = &genericContext.currentPairs[genericContext.currentElementIdx + index];
c0de69d6:	7c80      	ldrb	r0, [r0, #18]
c0de69d8:	4420      	add	r0, r4
c0de69da:	eb01 1000 	add.w	r0, r1, r0, lsl #4
c0de69de:	e0ed      	b.n	c0de6bbc <pageCallback+0x4aa>
        if (onChoice != NULL) {
c0de69e0:	f240 50d8 	movw	r0, #1496	@ 0x5d8
c0de69e4:	f2c0 0000 	movt	r0, #0
c0de69e8:	f859 1000 	ldr.w	r1, [r9, r0]
c0de69ec:	2900      	cmp	r1, #0
c0de69ee:	f000 80dd 	beq.w	c0de6bac <pageCallback+0x49a>
            onChoice(true);
c0de69f2:	2001      	movs	r0, #1
c0de69f4:	4788      	blx	r1
}
c0de69f6:	b01e      	add	sp, #120	@ 0x78
c0de69f8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
    nbgl_layoutDescription_t layoutDescription = {.modal            = true,
c0de69fc:	f643 61f0 	movw	r1, #16112	@ 0x3ef0
c0de6a00:	f2c0 0100 	movt	r1, #0
c0de6a04:	4479      	add	r1, pc
c0de6a06:	a807      	add	r0, sp, #28
c0de6a08:	c9c8      	ldmia	r1!, {r3, r6, r7}
c0de6a0a:	4602      	mov	r2, r0
c0de6a0c:	c2c8      	stmia	r2!, {r3, r6, r7}
c0de6a0e:	e891 00e8 	ldmia.w	r1, {r3, r5, r6, r7}
c0de6a12:	f10d 085c 	add.w	r8, sp, #92	@ 0x5c
c0de6a16:	c2e8      	stmia	r2!, {r3, r5, r6, r7}
    nbgl_layoutHeader_t      headerDesc        = {
c0de6a18:	f643 61a0 	movw	r1, #16032	@ 0x3ea0
c0de6a1c:	f2c0 0100 	movt	r1, #0
c0de6a20:	4479      	add	r1, pc
c0de6a22:	e891 00f8 	ldmia.w	r1, {r3, r4, r5, r6, r7}
c0de6a26:	4642      	mov	r2, r8
c0de6a28:	c2f8      	stmia	r2!, {r3, r4, r5, r6, r7}
    nbgl_layoutQRCode_t qrCode = {.url      = addressConfirmationContext.tagValuePairs[0].value,
c0de6a2a:	f240 6508 	movw	r5, #1544	@ 0x608
c0de6a2e:	f2c0 0500 	movt	r5, #0
c0de6a32:	eb09 0605 	add.w	r6, r9, r5
c0de6a36:	6871      	ldr	r1, [r6, #4]
c0de6a38:	9103      	str	r1, [sp, #12]
c0de6a3a:	2100      	movs	r1, #0
c0de6a3c:	e9cd 1104 	strd	r1, r1, [sp, #16]
c0de6a40:	f44f 3180 	mov.w	r1, #65536	@ 0x10000
c0de6a44:	9106      	str	r1, [sp, #24]
    addressConfirmationContext.modalLayout = nbgl_layoutGet(&layoutDescription);
c0de6a46:	f7f9 ff3d 	bl	c0de08c4 <nbgl_layoutGet>
    nbgl_layoutAddHeader(addressConfirmationContext.modalLayout, &headerDesc);
c0de6a4a:	4641      	mov	r1, r8
    addressConfirmationContext.modalLayout = nbgl_layoutGet(&layoutDescription);
c0de6a4c:	6330      	str	r0, [r6, #48]	@ 0x30
    nbgl_layoutAddHeader(addressConfirmationContext.modalLayout, &headerDesc);
c0de6a4e:	f7fd fbae 	bl	c0de41ae <nbgl_layoutAddHeader>
                                                  addressConfirmationContext.tagValuePairs[0].value,
c0de6a52:	6871      	ldr	r1, [r6, #4]
    uint16_t nbLines = nbgl_getTextNbLinesInWidth(SMALL_REGULAR_FONT,
c0de6a54:	200b      	movs	r0, #11
c0de6a56:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de6a5a:	2300      	movs	r3, #0
c0de6a5c:	f001 fb79 	bl	c0de8152 <nbgl_getTextNbLinesInWidth>
c0de6a60:	6871      	ldr	r1, [r6, #4]
    if (nbLines <= QRCODE_NB_MAX_LINES) {
c0de6a62:	2804      	cmp	r0, #4
c0de6a64:	d30f      	bcc.n	c0de6a86 <pageCallback+0x374>
        nbgl_textReduceOnNbLines(SMALL_REGULAR_FONT,
c0de6a66:	f240 7244 	movw	r2, #1860	@ 0x744
c0de6a6a:	2080      	movs	r0, #128	@ 0x80
c0de6a6c:	f2c0 0200 	movt	r2, #0
c0de6a70:	eb09 0402 	add.w	r4, r9, r2
c0de6a74:	9001      	str	r0, [sp, #4]
c0de6a76:	200b      	movs	r0, #11
c0de6a78:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de6a7c:	2303      	movs	r3, #3
c0de6a7e:	9400      	str	r4, [sp, #0]
c0de6a80:	f001 fb76 	bl	c0de8170 <nbgl_textReduceOnNbLines>
c0de6a84:	4621      	mov	r1, r4
    nbgl_layoutAddQRCode(addressConfirmationContext.modalLayout, &qrCode);
c0de6a86:	eb09 0405 	add.w	r4, r9, r5
c0de6a8a:	6b20      	ldr	r0, [r4, #48]	@ 0x30
c0de6a8c:	9105      	str	r1, [sp, #20]
c0de6a8e:	a903      	add	r1, sp, #12
c0de6a90:	f7fc fe21 	bl	c0de36d6 <nbgl_layoutAddQRCode>
        addressConfirmationContext.modalLayout, "Close", DISMISS_QR_TOKEN, TUNE_TAP_CASUAL);
c0de6a94:	6b20      	ldr	r0, [r4, #48]	@ 0x30
    nbgl_layoutAddFooter(
c0de6a96:	f643 01d1 	movw	r1, #14545	@ 0x38d1
c0de6a9a:	f2c0 0100 	movt	r1, #0
c0de6a9e:	4479      	add	r1, pc
c0de6aa0:	2216      	movs	r2, #22
c0de6aa2:	2309      	movs	r3, #9
c0de6aa4:	f7fd fb5b 	bl	c0de415e <nbgl_layoutAddFooter>
    nbgl_layoutDraw(addressConfirmationContext.modalLayout);
c0de6aa8:	6b20      	ldr	r0, [r4, #48]	@ 0x30
c0de6aaa:	f7fd ffd0 	bl	c0de4a4e <nbgl_layoutDraw>
    nbgl_refresh();
c0de6aae:	f001 faf6 	bl	c0de809e <nbgl_refresh>
}
c0de6ab2:	b01e      	add	sp, #120	@ 0x78
c0de6ab4:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        reviewWithWarnCtx.securityReportLevel = 1;
c0de6ab8:	f240 4474 	movw	r4, #1140	@ 0x474
c0de6abc:	f2c0 0400 	movt	r4, #0
c0de6ac0:	eb09 0004 	add.w	r0, r9, r4
c0de6ac4:	2201      	movs	r2, #1
        if (reviewWithWarnCtx.warning->predefinedSet) {
c0de6ac6:	6f81      	ldr	r1, [r0, #120]	@ 0x78
        reviewWithWarnCtx.securityReportLevel = 1;
c0de6ac8:	f880 2088 	strb.w	r2, [r0, #136]	@ 0x88
        if (reviewWithWarnCtx.warning->predefinedSet) {
c0de6acc:	6808      	ldr	r0, [r1, #0]
c0de6ace:	2800      	cmp	r0, #0
c0de6ad0:	d07d      	beq.n	c0de6bce <pageCallback+0x4bc>
c0de6ad2:	f000 fc26 	bl	c0de7322 <displaySecurityReport>
}
c0de6ad6:	b01e      	add	sp, #120	@ 0x78
c0de6ad8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        if (onContentAction != NULL) {
c0de6adc:	f240 60c0 	movw	r0, #1728	@ 0x6c0
c0de6ae0:	f2c0 0000 	movt	r0, #0
c0de6ae4:	f859 3000 	ldr.w	r3, [r9, r0]
c0de6ae8:	b143      	cbz	r3, c0de6afc <pageCallback+0x3ea>
            onContentAction(token, index, navInfo.activePage);
c0de6aea:	f240 50ec 	movw	r0, #1516	@ 0x5ec
c0de6aee:	f2c0 0000 	movt	r0, #0
c0de6af2:	f819 2000 	ldrb.w	r2, [r9, r0]
c0de6af6:	4628      	mov	r0, r5
c0de6af8:	4621      	mov	r1, r4
c0de6afa:	4798      	blx	r3
        if (onControls != NULL) {
c0de6afc:	f240 4068 	movw	r0, #1128	@ 0x468
c0de6b00:	f2c0 0000 	movt	r0, #0
c0de6b04:	f859 2000 	ldr.w	r2, [r9, r0]
c0de6b08:	2a00      	cmp	r2, #0
c0de6b0a:	d04f      	beq.n	c0de6bac <pageCallback+0x49a>
            onControls(token, index);
c0de6b0c:	4628      	mov	r0, r5
c0de6b0e:	4621      	mov	r1, r4
c0de6b10:	4790      	blx	r2
}
c0de6b12:	b01e      	add	sp, #120	@ 0x78
c0de6b14:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de6b18:	b2c0      	uxtb	r0, r0
c0de6b1a:	2100      	movs	r1, #0
c0de6b1c:	f7ff fae8 	bl	c0de60f0 <displayGenericContextPage>
c0de6b20:	b01e      	add	sp, #120	@ 0x78
c0de6b22:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            displayInfosListModal(activeTipBox.modalTitle, &activeTipBox.infos, false);
c0de6b26:	eb09 0100 	add.w	r1, r9, r0
c0de6b2a:	6c48      	ldr	r0, [r1, #68]	@ 0x44
    nbgl_pageNavigationInfo_t info = {.activePage                = 0,
c0de6b2c:	f643 6238 	movw	r2, #15928	@ 0x3e38
c0de6b30:	f2c0 0200 	movt	r2, #0
c0de6b34:	447a      	add	r2, pc
c0de6b36:	cae0      	ldmia	r2!, {r5, r6, r7}
c0de6b38:	ab17      	add	r3, sp, #92	@ 0x5c
c0de6b3a:	c3e0      	stmia	r3!, {r5, r6, r7}
c0de6b3c:	e892 00f0 	ldmia.w	r2, {r4, r5, r6, r7}
c0de6b40:	c3f0      	stmia	r3!, {r4, r5, r6, r7}
        = {.type                     = INFOS_LIST,
c0de6b42:	9007      	str	r0, [sp, #28]
c0de6b44:	f241 4000 	movw	r0, #5120	@ 0x1400
c0de6b48:	f2c0 0009 	movt	r0, #9
c0de6b4c:	9008      	str	r0, [sp, #32]
c0de6b4e:	2000      	movs	r0, #0
c0de6b50:	9009      	str	r0, [sp, #36]	@ 0x24
c0de6b52:	2008      	movs	r0, #8
           .infosList.infoTypes      = infos->infoTypes,
c0de6b54:	f101 034c 	add.w	r3, r1, #76	@ 0x4c
        = {.type                     = INFOS_LIST,
c0de6b58:	f88d 0028 	strb.w	r0, [sp, #40]	@ 0x28
           .infosList.infoTypes      = infos->infoTypes,
c0de6b5c:	cb0d      	ldmia	r3, {r0, r2, r3}
    if (modalPageContext != NULL) {
c0de6b5e:	f240 54e0 	movw	r4, #1504	@ 0x5e0
           .infosList.nbInfos        = infos->nbInfos,
c0de6b62:	e9cd 020b 	strd	r0, r2, [sp, #44]	@ 0x2c
c0de6b66:	f891 0058 	ldrb.w	r0, [r1, #88]	@ 0x58
    if (modalPageContext != NULL) {
c0de6b6a:	f2c0 0400 	movt	r4, #0
           .infosList.nbInfos        = infos->nbInfos,
c0de6b6e:	f88d 0038 	strb.w	r0, [sp, #56]	@ 0x38
c0de6b72:	200f      	movs	r0, #15
c0de6b74:	f88d 0039 	strb.w	r0, [sp, #57]	@ 0x39
    if (modalPageContext != NULL) {
c0de6b78:	f859 0004 	ldr.w	r0, [r9, r4]
           .infosList.withExtensions = infos->withExtensions,
c0de6b7c:	f891 105a 	ldrb.w	r1, [r1, #90]	@ 0x5a
    if (modalPageContext != NULL) {
c0de6b80:	2800      	cmp	r0, #0
           .infosList.nbInfos        = infos->nbInfos,
c0de6b82:	930d      	str	r3, [sp, #52]	@ 0x34
c0de6b84:	f88d 103a 	strb.w	r1, [sp, #58]	@ 0x3a
        nbgl_pageRelease(modalPageContext);
c0de6b88:	bf18      	it	ne
c0de6b8a:	f7fe fe64 	blne	c0de5856 <nbgl_pageRelease>
    modalPageContext = nbgl_pageDrawGenericContentExt(&pageModalCallback, &info, &content, true);
c0de6b8e:	f240 104b 	movw	r0, #331	@ 0x14b
c0de6b92:	f2c0 0000 	movt	r0, #0
c0de6b96:	4478      	add	r0, pc
c0de6b98:	a917      	add	r1, sp, #92	@ 0x5c
c0de6b9a:	aa07      	add	r2, sp, #28
c0de6b9c:	2301      	movs	r3, #1
c0de6b9e:	f7fe fbb7 	bl	c0de5310 <nbgl_pageDrawGenericContentExt>
c0de6ba2:	f849 0004 	str.w	r0, [r9, r4]
    nbgl_refreshSpecial(FULL_COLOR_CLEAN_REFRESH);
c0de6ba6:	2002      	movs	r0, #2
c0de6ba8:	f001 fa7e 	bl	c0de80a8 <nbgl_refreshSpecial>
}
c0de6bac:	b01e      	add	sp, #120	@ 0x78
c0de6bae:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            pair = genericContext.currentCallback(genericContext.currentElementIdx + index);
c0de6bb2:	7c81      	ldrb	r1, [r0, #18]
c0de6bb4:	6a82      	ldr	r2, [r0, #40]	@ 0x28
c0de6bb6:	1908      	adds	r0, r1, r4
c0de6bb8:	b2c0      	uxtb	r0, r0
c0de6bba:	4790      	blx	r2
        displayFullValuePage(pair->item, pair->value, pair->extension);
c0de6bbc:	e9d0 3100 	ldrd	r3, r1, [r0]
c0de6bc0:	6882      	ldr	r2, [r0, #8]
c0de6bc2:	4618      	mov	r0, r3
c0de6bc4:	f000 fa70 	bl	c0de70a8 <displayFullValuePage>
}
c0de6bc8:	b01e      	add	sp, #120	@ 0x78
c0de6bca:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            if (reviewWithWarnCtx.isIntro) {
c0de6bce:	eb09 0004 	add.w	r0, r9, r4
c0de6bd2:	f890 0089 	ldrb.w	r0, [r0, #137]	@ 0x89
c0de6bd6:	b148      	cbz	r0, c0de6bec <pageCallback+0x4da>
                displayCustomizedSecurityReport(reviewWithWarnCtx.warning->introDetails);
c0de6bd8:	6948      	ldr	r0, [r1, #20]
c0de6bda:	e008      	b.n	c0de6bee <pageCallback+0x4dc>
            else if (navType == REVIEW_NAV) {
c0de6bdc:	b188      	cbz	r0, c0de6c02 <pageCallback+0x4f0>
                displaySettingsPage(index, false);
c0de6bde:	4620      	mov	r0, r4
c0de6be0:	2100      	movs	r1, #0
c0de6be2:	f7ff f814 	bl	c0de5c0e <displaySettingsPage>
}
c0de6be6:	b01e      	add	sp, #120	@ 0x78
c0de6be8:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
                displayCustomizedSecurityReport(reviewWithWarnCtx.warning->reviewDetails);
c0de6bec:	6988      	ldr	r0, [r1, #24]
c0de6bee:	2117      	movs	r1, #23
c0de6bf0:	f000 fd9c 	bl	c0de772c <displayModalDetails>
c0de6bf4:	eb09 0104 	add.w	r1, r9, r4
c0de6bf8:	f8c1 0084 	str.w	r0, [r1, #132]	@ 0x84
}
c0de6bfc:	b01e      	add	sp, #120	@ 0x78
c0de6bfe:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
                displayReviewPage(index, false);
c0de6c02:	4620      	mov	r0, r4
c0de6c04:	e5aa      	b.n	c0de675c <pageCallback+0x4a>

c0de6c06 <nbgl_useCaseChoice>:
                        const char                *message,
                        const char                *subMessage,
                        const char                *confirmText,
                        const char                *cancelText,
                        nbgl_choiceCallback_t      callback)
{
c0de6c06:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de6c0a:	b088      	sub	sp, #32
c0de6c0c:	4683      	mov	fp, r0
c0de6c0e:	2000      	movs	r0, #0
    nbgl_pageConfirmationDescription_t info = {0};
    // check params
    if ((confirmText == NULL) || (cancelText == NULL)) {
c0de6c10:	2b00      	cmp	r3, #0
    nbgl_pageConfirmationDescription_t info = {0};
c0de6c12:	9007      	str	r0, [sp, #28]
c0de6c14:	e9cd 0005 	strd	r0, r0, [sp, #20]
c0de6c18:	e9cd 0003 	strd	r0, r0, [sp, #12]
c0de6c1c:	e9cd 0001 	strd	r0, r0, [sp, #4]
c0de6c20:	9000      	str	r0, [sp, #0]
    if ((confirmText == NULL) || (cancelText == NULL)) {
c0de6c22:	d05c      	beq.n	c0de6cde <nbgl_useCaseChoice+0xd8>
c0de6c24:	f8dd a040 	ldr.w	sl, [sp, #64]	@ 0x40
c0de6c28:	f1ba 0f00 	cmp.w	sl, #0
c0de6c2c:	d057      	beq.n	c0de6cde <nbgl_useCaseChoice+0xd8>
    onQuit          = NULL;
c0de6c2e:	f240 4060 	movw	r0, #1120	@ 0x460
c0de6c32:	f2c0 0000 	movt	r0, #0
c0de6c36:	2500      	movs	r5, #0
c0de6c38:	f849 5000 	str.w	r5, [r9, r0]
    onContinue      = NULL;
c0de6c3c:	f240 50e8 	movw	r0, #1512	@ 0x5e8
c0de6c40:	f2c0 0000 	movt	r0, #0
c0de6c44:	f849 5000 	str.w	r5, [r9, r0]
    onAction        = NULL;
c0de6c48:	f240 50e4 	movw	r0, #1508	@ 0x5e4
c0de6c4c:	f2c0 0000 	movt	r0, #0
c0de6c50:	f849 5000 	str.w	r5, [r9, r0]
    onNav           = NULL;
c0de6c54:	f240 4064 	movw	r0, #1124	@ 0x464
c0de6c58:	f2c0 0000 	movt	r0, #0
c0de6c5c:	f849 5000 	str.w	r5, [r9, r0]
    onControls      = NULL;
c0de6c60:	f240 4068 	movw	r0, #1128	@ 0x468
c0de6c64:	f2c0 0000 	movt	r0, #0
c0de6c68:	f849 5000 	str.w	r5, [r9, r0]
    onContentAction = NULL;
c0de6c6c:	f240 60c0 	movw	r0, #1728	@ 0x6c0
c0de6c70:	f2c0 0000 	movt	r0, #0
c0de6c74:	f849 5000 	str.w	r5, [r9, r0]
    memset(&genericContext, 0, sizeof(genericContext));
c0de6c78:	f240 4074 	movw	r0, #1140	@ 0x474
    onChoice        = NULL;
c0de6c7c:	f240 58d8 	movw	r8, #1496	@ 0x5d8
    memset(&genericContext, 0, sizeof(genericContext));
c0de6c80:	f2c0 0000 	movt	r0, #0
c0de6c84:	460f      	mov	r7, r1
    onChoice        = NULL;
c0de6c86:	f2c0 0800 	movt	r8, #0
    memset(&genericContext, 0, sizeof(genericContext));
c0de6c8a:	4448      	add	r0, r9
c0de6c8c:	2190      	movs	r1, #144	@ 0x90
c0de6c8e:	461c      	mov	r4, r3
c0de6c90:	4616      	mov	r6, r2
    onChoice        = NULL;
c0de6c92:	f849 5008 	str.w	r5, [r9, r8]
    memset(&genericContext, 0, sizeof(genericContext));
c0de6c96:	f002 fb25 	bl	c0de92e4 <__aeabi_memclr>
c0de6c9a:	2009      	movs	r0, #9
    info.centeredInfo.text1 = message;
    info.centeredInfo.text2 = subMessage;
    info.centeredInfo.style = LARGE_CASE_INFO;
    info.centeredInfo.icon  = icon;
    info.confirmationText   = confirmText;
    info.confirmationToken  = CHOICE_TOKEN;
c0de6c9c:	f88d 001c 	strb.w	r0, [sp, #28]
    info.tuneId             = TUNE_TAP_CASUAL;
c0de6ca0:	f88d 001e 	strb.w	r0, [sp, #30]

    onChoice    = callback;
c0de6ca4:	9811      	ldr	r0, [sp, #68]	@ 0x44
    info.cancelText         = cancelText;
c0de6ca6:	f8cd a018 	str.w	sl, [sp, #24]
    info.centeredInfo.text1 = message;
c0de6caa:	e9cd 7600 	strd	r7, r6, [sp]
    info.centeredInfo.style = LARGE_CASE_INFO;
c0de6cae:	f88d 5011 	strb.w	r5, [sp, #17]
    info.centeredInfo.icon  = icon;
c0de6cb2:	f8cd b00c 	str.w	fp, [sp, #12]
    info.confirmationText   = confirmText;
c0de6cb6:	9405      	str	r4, [sp, #20]
    onChoice    = callback;
c0de6cb8:	f849 0008 	str.w	r0, [r9, r8]
    pageContext = nbgl_pageDrawConfirmation(&pageCallback, &info);
c0de6cbc:	f64f 204b 	movw	r0, #64075	@ 0xfa4b
c0de6cc0:	f6cf 70ff 	movt	r0, #65535	@ 0xffff
c0de6cc4:	4478      	add	r0, pc
c0de6cc6:	4669      	mov	r1, sp
c0de6cc8:	f7fe fadc 	bl	c0de5284 <nbgl_pageDrawConfirmation>
c0de6ccc:	f240 51d4 	movw	r1, #1492	@ 0x5d4
c0de6cd0:	f2c0 0100 	movt	r1, #0
c0de6cd4:	f849 0001 	str.w	r0, [r9, r1]
    nbgl_refreshSpecial(FULL_COLOR_PARTIAL_REFRESH);
c0de6cd8:	2001      	movs	r0, #1
c0de6cda:	f001 f9e5 	bl	c0de80a8 <nbgl_refreshSpecial>
}
c0de6cde:	b008      	add	sp, #32
c0de6ce0:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de6ce4 <pageModalCallback>:
{
c0de6ce4:	b570      	push	{r4, r5, r6, lr}
    if (token == INFOS_TIP_BOX_TOKEN) {
c0de6ce6:	280e      	cmp	r0, #14
c0de6ce8:	460c      	mov	r4, r1
c0de6cea:	d00b      	beq.n	c0de6d04 <pageModalCallback+0x20>
c0de6cec:	4605      	mov	r5, r0
c0de6cee:	280f      	cmp	r0, #15
c0de6cf0:	d11b      	bne.n	c0de6d2a <pageModalCallback+0x46>
        displayFullValuePage(activeTipBox.infos.infoTypes[index],
c0de6cf2:	f240 4074 	movw	r0, #1140	@ 0x474
c0de6cf6:	f2c0 0000 	movt	r0, #0
c0de6cfa:	4448      	add	r0, r9
c0de6cfc:	f100 034c 	add.w	r3, r0, #76	@ 0x4c
c0de6d00:	cb0e      	ldmia	r3, {r1, r2, r3}
c0de6d02:	e007      	b.n	c0de6d14 <pageModalCallback+0x30>
        displayFullValuePage(genericContext.currentInfos->infoTypes[index],
c0de6d04:	f240 4074 	movw	r0, #1140	@ 0x474
c0de6d08:	f2c0 0000 	movt	r0, #0
c0de6d0c:	4448      	add	r0, r9
c0de6d0e:	6b40      	ldr	r0, [r0, #52]	@ 0x34
c0de6d10:	e890 000e 	ldmia.w	r0, {r1, r2, r3}
c0de6d14:	f851 0024 	ldr.w	r0, [r1, r4, lsl #2]
c0de6d18:	f852 1024 	ldr.w	r1, [r2, r4, lsl #2]
c0de6d1c:	eb04 0244 	add.w	r2, r4, r4, lsl #1
c0de6d20:	eb03 02c2 	add.w	r2, r3, r2, lsl #3
c0de6d24:	f000 f9c0 	bl	c0de70a8 <displayFullValuePage>
}
c0de6d28:	bd70      	pop	{r4, r5, r6, pc}
    nbgl_pageRelease(modalPageContext);
c0de6d2a:	f240 56e0 	movw	r6, #1504	@ 0x5e0
c0de6d2e:	f2c0 0600 	movt	r6, #0
c0de6d32:	f859 0006 	ldr.w	r0, [r9, r6]
c0de6d36:	f7fe fd8e 	bl	c0de5856 <nbgl_pageRelease>
c0de6d3a:	2000      	movs	r0, #0
    if (token == NAV_TOKEN) {
c0de6d3c:	2d04      	cmp	r5, #4
    modalPageContext = NULL;
c0de6d3e:	f849 0006 	str.w	r0, [r9, r6]
    if (token == NAV_TOKEN) {
c0de6d42:	dc14      	bgt.n	c0de6d6e <pageModalCallback+0x8a>
c0de6d44:	2d02      	cmp	r5, #2
c0de6d46:	d032      	beq.n	c0de6dae <pageModalCallback+0xca>
c0de6d48:	2d03      	cmp	r5, #3
c0de6d4a:	d008      	beq.n	c0de6d5e <pageModalCallback+0x7a>
c0de6d4c:	2d04      	cmp	r5, #4
c0de6d4e:	d140      	bne.n	c0de6dd2 <pageModalCallback+0xee>
        if (index == EXIT_PAGE) {
c0de6d50:	2cff      	cmp	r4, #255	@ 0xff
c0de6d52:	d02c      	beq.n	c0de6dae <pageModalCallback+0xca>
            displayTagValueListModalPage(index, false);
c0de6d54:	4620      	mov	r0, r4
c0de6d56:	2100      	movs	r1, #0
c0de6d58:	f000 fe62 	bl	c0de7a20 <displayTagValueListModalPage>
}
c0de6d5c:	bd70      	pop	{r4, r5, r6, pc}
        if (index == EXIT_PAGE) {
c0de6d5e:	2cff      	cmp	r4, #255	@ 0xff
c0de6d60:	d038      	beq.n	c0de6dd4 <pageModalCallback+0xf0>
            displayDetailsPage(index, false);
c0de6d62:	4620      	mov	r0, r4
c0de6d64:	2100      	movs	r1, #0
c0de6d66:	f000 fd67 	bl	c0de7838 <displayDetailsPage>
    if (token == MODAL_NAV_TOKEN) {
c0de6d6a:	2d04      	cmp	r5, #4
c0de6d6c:	dd38      	ble.n	c0de6de0 <pageModalCallback+0xfc>
c0de6d6e:	2d05      	cmp	r5, #5
c0de6d70:	d016      	beq.n	c0de6da0 <pageModalCallback+0xbc>
c0de6d72:	2d09      	cmp	r5, #9
c0de6d74:	d01a      	beq.n	c0de6dac <pageModalCallback+0xc8>
c0de6d76:	2d14      	cmp	r5, #20
c0de6d78:	d12b      	bne.n	c0de6dd2 <pageModalCallback+0xee>
        if (reviewWithWarnCtx.securityReportLevel == 2) {
c0de6d7a:	f240 4074 	movw	r0, #1140	@ 0x474
c0de6d7e:	f2c0 0000 	movt	r0, #0
c0de6d82:	eb09 0100 	add.w	r1, r9, r0
c0de6d86:	f891 1088 	ldrb.w	r1, [r1, #136]	@ 0x88
c0de6d8a:	2902      	cmp	r1, #2
c0de6d8c:	d10f      	bne.n	c0de6dae <pageModalCallback+0xca>
            reviewWithWarnCtx.securityReportLevel = 1;
c0de6d8e:	4448      	add	r0, r9
c0de6d90:	2101      	movs	r1, #1
            displaySecurityReport(reviewWithWarnCtx.warning->predefinedSet);
c0de6d92:	6f82      	ldr	r2, [r0, #120]	@ 0x78
            reviewWithWarnCtx.securityReportLevel = 1;
c0de6d94:	f880 1088 	strb.w	r1, [r0, #136]	@ 0x88
            displaySecurityReport(reviewWithWarnCtx.warning->predefinedSet);
c0de6d98:	6810      	ldr	r0, [r2, #0]
c0de6d9a:	f000 fac2 	bl	c0de7322 <displaySecurityReport>
}
c0de6d9e:	bd70      	pop	{r4, r5, r6, pc}
        if (index == 0) {
c0de6da0:	b92c      	cbnz	r4, c0de6dae <pageModalCallback+0xca>
            displayGenericContextPage(LAST_PAGE_FOR_REVIEW, true);
c0de6da2:	20ff      	movs	r0, #255	@ 0xff
c0de6da4:	2101      	movs	r1, #1
c0de6da6:	f7ff f9a3 	bl	c0de60f0 <displayGenericContextPage>
}
c0de6daa:	bd70      	pop	{r4, r5, r6, pc}
        if (index == 0) {
c0de6dac:	b124      	cbz	r4, c0de6db8 <pageModalCallback+0xd4>
c0de6dae:	f001 f99e 	bl	c0de80ee <nbgl_screenRedraw>
c0de6db2:	f001 f974 	bl	c0de809e <nbgl_refresh>
}
c0de6db6:	bd70      	pop	{r4, r5, r6, pc}
            if (onModalConfirm != NULL) {
c0de6db8:	f240 54dc 	movw	r4, #1500	@ 0x5dc
c0de6dbc:	f2c0 0400 	movt	r4, #0
c0de6dc0:	f859 0004 	ldr.w	r0, [r9, r4]
c0de6dc4:	2800      	cmp	r0, #0
}
c0de6dc6:	bf08      	it	eq
c0de6dc8:	bd70      	popeq	{r4, r5, r6, pc}
                onModalConfirm();
c0de6dca:	4780      	blx	r0
c0de6dcc:	2000      	movs	r0, #0
                onModalConfirm = NULL;
c0de6dce:	f849 0004 	str.w	r0, [r9, r4]
}
c0de6dd2:	bd70      	pop	{r4, r5, r6, pc}
            nbgl_screenRedraw();
c0de6dd4:	f001 f98b 	bl	c0de80ee <nbgl_screenRedraw>
            nbgl_refresh();
c0de6dd8:	f001 f961 	bl	c0de809e <nbgl_refresh>
    if (token == MODAL_NAV_TOKEN) {
c0de6ddc:	2d04      	cmp	r5, #4
c0de6dde:	dcc6      	bgt.n	c0de6d6e <pageModalCallback+0x8a>
c0de6de0:	2d02      	cmp	r5, #2
c0de6de2:	d1b3      	bne.n	c0de6d4c <pageModalCallback+0x68>
c0de6de4:	e7e3      	b.n	c0de6dae <pageModalCallback+0xca>

c0de6de6 <displayReviewPage>:
{
c0de6de6:	b570      	push	{r4, r5, r6, lr}
c0de6de8:	b090      	sub	sp, #64	@ 0x40
c0de6dea:	460c      	mov	r4, r1
c0de6dec:	4605      	mov	r5, r0
c0de6dee:	4668      	mov	r0, sp
    nbgl_pageContent_t content = {0};
c0de6df0:	2140      	movs	r1, #64	@ 0x40
c0de6df2:	f002 fa77 	bl	c0de92e4 <__aeabi_memclr>
    if ((navInfo.nbPages != 0) && (page >= (navInfo.nbPages))) {
c0de6df6:	f240 56ec 	movw	r6, #1516	@ 0x5ec
c0de6dfa:	f2c0 0600 	movt	r6, #0
c0de6dfe:	eb09 0006 	add.w	r0, r9, r6
c0de6e02:	7840      	ldrb	r0, [r0, #1]
c0de6e04:	3801      	subs	r0, #1
c0de6e06:	b2c0      	uxtb	r0, r0
c0de6e08:	42a8      	cmp	r0, r5
c0de6e0a:	d353      	bcc.n	c0de6eb4 <displayReviewPage+0xce>
    if ((onNav == NULL) || (onNav(navInfo.activePage, &content) == false)) {
c0de6e0c:	f240 4064 	movw	r0, #1124	@ 0x464
c0de6e10:	f2c0 0000 	movt	r0, #0
c0de6e14:	f859 2000 	ldr.w	r2, [r9, r0]
    navInfo.activePage = page;
c0de6e18:	f809 5006 	strb.w	r5, [r9, r6]
    if ((onNav == NULL) || (onNav(navInfo.activePage, &content) == false)) {
c0de6e1c:	2a00      	cmp	r2, #0
c0de6e1e:	d049      	beq.n	c0de6eb4 <displayReviewPage+0xce>
c0de6e20:	4669      	mov	r1, sp
c0de6e22:	4628      	mov	r0, r5
c0de6e24:	4790      	blx	r2
c0de6e26:	2800      	cmp	r0, #0
c0de6e28:	d044      	beq.n	c0de6eb4 <displayReviewPage+0xce>
c0de6e2a:	2000      	movs	r0, #0
    content.title            = NULL;
c0de6e2c:	9000      	str	r0, [sp, #0]
    content.isTouchableTitle = false;
c0de6e2e:	f88d 0004 	strb.w	r0, [sp, #4]
    if (content.type == INFO_LONG_PRESS) {  // last page
c0de6e32:	f89d 000c 	ldrb.w	r0, [sp, #12]
c0de6e36:	2109      	movs	r1, #9
c0de6e38:	2804      	cmp	r0, #4
    content.tuneId           = TUNE_TAP_CASUAL;
c0de6e3a:	f88d 1006 	strb.w	r1, [sp, #6]
    if (content.type == INFO_LONG_PRESS) {  // last page
c0de6e3e:	dc07      	bgt.n	c0de6e50 <displayReviewPage+0x6a>
c0de6e40:	2802      	cmp	r0, #2
c0de6e42:	d010      	beq.n	c0de6e66 <displayReviewPage+0x80>
c0de6e44:	2804      	cmp	r0, #4
c0de6e46:	bf04      	itt	eq
c0de6e48:	2000      	moveq	r0, #0
        content.tagValueList.smallCaseForValue = false;
c0de6e4a:	f88d 001d 	strbeq.w	r0, [sp, #29]
c0de6e4e:	e01b      	b.n	c0de6e88 <displayReviewPage+0xa2>
    if (content.type == INFO_LONG_PRESS) {  // last page
c0de6e50:	2805      	cmp	r0, #5
c0de6e52:	d012      	beq.n	c0de6e7a <displayReviewPage+0x94>
c0de6e54:	2806      	cmp	r0, #6
c0de6e56:	d117      	bne.n	c0de6e88 <displayReviewPage+0xa2>
c0de6e58:	2000      	movs	r0, #0
        content.tagValueConfirm.tagValueList.smallCaseForValue = false;
c0de6e5a:	f88d 001d 	strb.w	r0, [sp, #29]
c0de6e5e:	200b      	movs	r0, #11
        content.tagValueConfirm.confirmationToken = CONFIRM_TOKEN;
c0de6e60:	f88d 0038 	strb.w	r0, [sp, #56]	@ 0x38
c0de6e64:	e010      	b.n	c0de6e88 <displayReviewPage+0xa2>
        navInfo.nbPages                      = navInfo.activePage + 1;
c0de6e66:	f819 0006 	ldrb.w	r0, [r9, r6]
c0de6e6a:	eb09 0106 	add.w	r1, r9, r6
c0de6e6e:	3001      	adds	r0, #1
c0de6e70:	7048      	strb	r0, [r1, #1]
c0de6e72:	200b      	movs	r0, #11
        content.infoLongPress.longPressToken = CONFIRM_TOKEN;
c0de6e74:	f88d 001c 	strb.w	r0, [sp, #28]
c0de6e78:	e006      	b.n	c0de6e88 <displayReviewPage+0xa2>
c0de6e7a:	2000      	movs	r0, #0
        content.tagValueDetails.tagValueList.smallCaseForValue = false;
c0de6e7c:	f88d 001d 	strb.w	r0, [sp, #29]
c0de6e80:	f640 1001 	movw	r0, #2305	@ 0x901
        content.tagValueDetails.tagValueList.hideEndOfLastLine  = true;
c0de6e84:	f8ad 001a 	strh.w	r0, [sp, #26]
    pageContext = nbgl_pageDrawGenericContent(&pageCallback, &navInfo, &content);
c0de6e88:	f64f 007b 	movw	r0, #63611	@ 0xf87b
c0de6e8c:	f6cf 70ff 	movt	r0, #65535	@ 0xffff
c0de6e90:	eb09 0106 	add.w	r1, r9, r6
c0de6e94:	4478      	add	r0, pc
c0de6e96:	466a      	mov	r2, sp
c0de6e98:	f7fe fcd8 	bl	c0de584c <nbgl_pageDrawGenericContent>
c0de6e9c:	f240 51d4 	movw	r1, #1492	@ 0x5d4
c0de6ea0:	f2c0 0100 	movt	r1, #0
c0de6ea4:	f849 0001 	str.w	r0, [r9, r1]
c0de6ea8:	2001      	movs	r0, #1
c0de6eaa:	2c00      	cmp	r4, #0
c0de6eac:	bf18      	it	ne
c0de6eae:	2002      	movne	r0, #2
c0de6eb0:	f001 f8fa 	bl	c0de80a8 <nbgl_refreshSpecial>
}
c0de6eb4:	b010      	add	sp, #64	@ 0x40
c0de6eb6:	bd70      	pop	{r4, r5, r6, pc}

c0de6eb8 <genericContextComputeNextPageParams>:
{
c0de6eb8:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
    int8_t  nextContentIdx = genericContext.currentContentIdx;
c0de6ebc:	f240 4a74 	movw	sl, #1140	@ 0x474
c0de6ec0:	f2c0 0a00 	movt	sl, #0
    uint8_t pageData = genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de6ec4:	f240 67c4 	movw	r7, #1732	@ 0x6c4
c0de6ec8:	4604      	mov	r4, r0
    int8_t  nextContentIdx = genericContext.currentContentIdx;
c0de6eca:	eb09 000a 	add.w	r0, r9, sl
    uint8_t pageData = genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de6ece:	f2c0 0700 	movt	r7, #0
c0de6ed2:	4688      	mov	r8, r1
    int8_t  nextContentIdx = genericContext.currentContentIdx;
c0de6ed4:	f890 b010 	ldrb.w	fp, [r0, #16]
    int16_t nextElementIdx = genericContext.currentElementIdx;
c0de6ed8:	7c86      	ldrb	r6, [r0, #18]
    uint8_t pageData = genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de6eda:	0860      	lsrs	r0, r4, #1
c0de6edc:	eb09 0107 	add.w	r1, r9, r7
c0de6ee0:	5c08      	ldrb	r0, [r1, r0]
c0de6ee2:	2104      	movs	r1, #4
                       >> ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de6ee4:	ea01 0184 	and.w	r1, r1, r4, lsl #2
c0de6ee8:	fa20 f101 	lsr.w	r1, r0, r1
        *nbElements = GET_PAGE_NB_ELEMENTS(pageData);
c0de6eec:	f001 0007 	and.w	r0, r1, #7
    if (pageIdx > navInfo.activePage) {
c0de6ef0:	f240 5cec 	movw	ip, #1516	@ 0x5ec
    if (flag != NULL) {
c0de6ef4:	2b00      	cmp	r3, #0
        *flag = GET_PAGE_FLAG(pageData);
c0de6ef6:	bf1c      	itt	ne
c0de6ef8:	f3c1 01c0 	ubfxne	r1, r1, #3, #1
c0de6efc:	7019      	strbne	r1, [r3, #0]
    *p_nbElementsInNextPage = nbElementsInNextPage;
c0de6efe:	7010      	strb	r0, [r2, #0]
    if (pageIdx > navInfo.activePage) {
c0de6f00:	f2c0 0c00 	movt	ip, #0
c0de6f04:	f819 100c 	ldrb.w	r1, [r9, ip]
c0de6f08:	42a1      	cmp	r1, r4
c0de6f0a:	d219      	bcs.n	c0de6f40 <genericContextComputeNextPageParams+0x88>
    uint8_t pageData = genericContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de6f0c:	084a      	lsrs	r2, r1, #1
c0de6f0e:	eb09 0307 	add.w	r3, r9, r7
c0de6f12:	5c9a      	ldrb	r2, [r3, r2]
c0de6f14:	2304      	movs	r3, #4
                       >> ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de6f16:	ea03 0381 	and.w	r3, r3, r1, lsl #2
c0de6f1a:	40da      	lsrs	r2, r3
        if ((nextElementIdx >= genericContext.currentContentElementNb)
c0de6f1c:	eb09 030a 	add.w	r3, r9, sl
c0de6f20:	7c5b      	ldrb	r3, [r3, #17]
        *nbElements = GET_PAGE_NB_ELEMENTS(pageData);
c0de6f22:	f002 0207 	and.w	r2, r2, #7
        nextElementIdx += nbElementsInCurrentPage;
c0de6f26:	4416      	add	r6, r2
        if ((nextElementIdx >= genericContext.currentContentElementNb)
c0de6f28:	2b00      	cmp	r3, #0
c0de6f2a:	461a      	mov	r2, r3
c0de6f2c:	bf18      	it	ne
c0de6f2e:	2201      	movne	r2, #1
c0de6f30:	2700      	movs	r7, #0
c0de6f32:	429e      	cmp	r6, r3
c0de6f34:	bf28      	it	cs
c0de6f36:	2701      	movcs	r7, #1
            && (genericContext.currentContentElementNb > 0)) {
c0de6f38:	403a      	ands	r2, r7
c0de6f3a:	4493      	add	fp, r2
c0de6f3c:	bf18      	it	ne
c0de6f3e:	2600      	movne	r6, #0
    if (pageIdx < navInfo.activePage) {
c0de6f40:	42a1      	cmp	r1, r4
c0de6f42:	d906      	bls.n	c0de6f52 <genericContextComputeNextPageParams+0x9a>
        nextElementIdx -= nbElementsInNextPage;
c0de6f44:	1a36      	subs	r6, r6, r0
        if (nextElementIdx < 0) {
c0de6f46:	f1b6 3fff 	cmp.w	r6, #4294967295	@ 0xffffffff
            nextContentIdx -= 1;
c0de6f4a:	bfdc      	itt	le
c0de6f4c:	f1ab 0b01 	suble.w	fp, fp, #1
            nextElementIdx = -nbElementsInNextPage;
c0de6f50:	4246      	negle	r6, r0
    if ((nextContentIdx == -1) && (genericContext.hasStartingContent)) {
c0de6f52:	fa5f f78b 	uxtb.w	r7, fp
c0de6f56:	f240 5104 	movw	r1, #1284	@ 0x504
c0de6f5a:	2fff      	cmp	r7, #255	@ 0xff
c0de6f5c:	f2c0 0100 	movt	r1, #0
c0de6f60:	d106      	bne.n	c0de6f70 <genericContextComputeNextPageParams+0xb8>
c0de6f62:	eb09 000a 	add.w	r0, r9, sl
c0de6f66:	7cc0      	ldrb	r0, [r0, #19]
c0de6f68:	b110      	cbz	r0, c0de6f70 <genericContextComputeNextPageParams+0xb8>
c0de6f6a:	eb09 0501 	add.w	r5, r9, r1
c0de6f6e:	e027      	b.n	c0de6fc0 <genericContextComputeNextPageParams+0x108>
    else if ((nextContentIdx == genericContext.genericContents.nbContents)
c0de6f70:	eb09 030a 	add.w	r3, r9, sl
c0de6f74:	7b1a      	ldrb	r2, [r3, #12]
c0de6f76:	fa4f f08b 	sxtb.w	r0, fp
             && (genericContext.hasFinishingContent)) {
c0de6f7a:	4290      	cmp	r0, r2
c0de6f7c:	d106      	bne.n	c0de6f8c <genericContextComputeNextPageParams+0xd4>
c0de6f7e:	7d1b      	ldrb	r3, [r3, #20]
c0de6f80:	b123      	cbz	r3, c0de6f8c <genericContextComputeNextPageParams+0xd4>
c0de6f82:	eb09 0001 	add.w	r0, r9, r1
c0de6f86:	f100 0538 	add.w	r5, r0, #56	@ 0x38
c0de6f8a:	e019      	b.n	c0de6fc0 <genericContextComputeNextPageParams+0x108>
    if (contentIdx < 0 || contentIdx >= genericContents->nbContents) {
c0de6f8c:	2800      	cmp	r0, #0
c0de6f8e:	f04f 0500 	mov.w	r5, #0
c0de6f92:	d413      	bmi.n	c0de6fbc <genericContextComputeNextPageParams+0x104>
c0de6f94:	4290      	cmp	r0, r2
c0de6f96:	da11      	bge.n	c0de6fbc <genericContextComputeNextPageParams+0x104>
    if (genericContents->callbackCallNeeded) {
c0de6f98:	eb09 010a 	add.w	r1, r9, sl
c0de6f9c:	7909      	ldrb	r1, [r1, #4]
c0de6f9e:	2900      	cmp	r1, #0
c0de6fa0:	d05a      	beq.n	c0de7058 <genericContextComputeNextPageParams+0x1a0>
        memset(content, 0, sizeof(nbgl_content_t));
c0de6fa2:	4640      	mov	r0, r8
c0de6fa4:	2138      	movs	r1, #56	@ 0x38
c0de6fa6:	4665      	mov	r5, ip
c0de6fa8:	f002 f99c 	bl	c0de92e4 <__aeabi_memclr>
        genericContents->contentGetterCallback(contentIdx, content);
c0de6fac:	eb09 000a 	add.w	r0, r9, sl
c0de6fb0:	6882      	ldr	r2, [r0, #8]
c0de6fb2:	4638      	mov	r0, r7
c0de6fb4:	4641      	mov	r1, r8
c0de6fb6:	4790      	blx	r2
c0de6fb8:	46ac      	mov	ip, r5
c0de6fba:	4645      	mov	r5, r8
        if (p_content == NULL) {
c0de6fbc:	2d00      	cmp	r5, #0
c0de6fbe:	d059      	beq.n	c0de7074 <genericContextComputeNextPageParams+0x1bc>
    if ((nextContentIdx != genericContext.currentContentIdx)
c0de6fc0:	eb09 000a 	add.w	r0, r9, sl
c0de6fc4:	7c01      	ldrb	r1, [r0, #16]
        || (genericContext.currentContentElementNb == 0)) {
c0de6fc6:	428f      	cmp	r7, r1
c0de6fc8:	d104      	bne.n	c0de6fd4 <genericContextComputeNextPageParams+0x11c>
c0de6fca:	7c40      	ldrb	r0, [r0, #17]
c0de6fcc:	b110      	cbz	r0, c0de6fd4 <genericContextComputeNextPageParams+0x11c>
    if ((nextElementIdx < 0) || (nextElementIdx >= genericContext.currentContentElementNb)) {
c0de6fce:	2e00      	cmp	r6, #0
c0de6fd0:	d535      	bpl.n	c0de703e <genericContextComputeNextPageParams+0x186>
c0de6fd2:	e04f      	b.n	c0de7074 <genericContextComputeNextPageParams+0x1bc>
    switch (content->type) {
c0de6fd4:	7828      	ldrb	r0, [r5, #0]
        genericContext.currentContentIdx       = nextContentIdx;
c0de6fd6:	eb09 010a 	add.w	r1, r9, sl
c0de6fda:	f881 b010 	strb.w	fp, [r1, #16]
    switch (content->type) {
c0de6fde:	2807      	cmp	r0, #7
c0de6fe0:	f04f 0101 	mov.w	r1, #1
c0de6fe4:	4667      	mov	r7, ip
c0de6fe6:	dc07      	bgt.n	c0de6ff8 <genericContextComputeNextPageParams+0x140>
c0de6fe8:	2804      	cmp	r0, #4
c0de6fea:	d00d      	beq.n	c0de7008 <genericContextComputeNextPageParams+0x150>
c0de6fec:	2806      	cmp	r0, #6
c0de6fee:	d00b      	beq.n	c0de7008 <genericContextComputeNextPageParams+0x150>
c0de6ff0:	2807      	cmp	r0, #7
            return content->content.switchesList.nbSwitches;
c0de6ff2:	bf08      	it	eq
c0de6ff4:	7a29      	ldrbeq	r1, [r5, #8]
c0de6ff6:	e00c      	b.n	c0de7012 <genericContextComputeNextPageParams+0x15a>
    switch (content->type) {
c0de6ff8:	2808      	cmp	r0, #8
c0de6ffa:	d007      	beq.n	c0de700c <genericContextComputeNextPageParams+0x154>
c0de6ffc:	2809      	cmp	r0, #9
c0de6ffe:	d007      	beq.n	c0de7010 <genericContextComputeNextPageParams+0x158>
c0de7000:	280a      	cmp	r0, #10
c0de7002:	bf08      	it	eq
c0de7004:	7b29      	ldrbeq	r1, [r5, #12]
c0de7006:	e004      	b.n	c0de7012 <genericContextComputeNextPageParams+0x15a>
c0de7008:	7b29      	ldrb	r1, [r5, #12]
c0de700a:	e002      	b.n	c0de7012 <genericContextComputeNextPageParams+0x15a>
            return content->content.infosList.nbInfos;
c0de700c:	7c29      	ldrb	r1, [r5, #16]
c0de700e:	e000      	b.n	c0de7012 <genericContextComputeNextPageParams+0x15a>
            return content->content.choicesList.nbChoices;
c0de7010:	7a69      	ldrb	r1, [r5, #9]
        onContentAction                        = PIC(p_content->contentActionCallback);
c0de7012:	6b68      	ldr	r0, [r5, #52]	@ 0x34
        genericContext.currentContentElementNb = getContentNbElement(p_content);
c0de7014:	eb09 020a 	add.w	r2, r9, sl
c0de7018:	7451      	strb	r1, [r2, #17]
        onContentAction                        = PIC(p_content->contentActionCallback);
c0de701a:	f001 ff6f 	bl	c0de8efc <pic>
c0de701e:	f240 61c0 	movw	r1, #1728	@ 0x6c0
c0de7022:	f2c0 0100 	movt	r1, #0
        if (nextElementIdx < 0) {
c0de7026:	f1b6 3fff 	cmp.w	r6, #4294967295	@ 0xffffffff
        onContentAction                        = PIC(p_content->contentActionCallback);
c0de702a:	f849 0001 	str.w	r0, [r9, r1]
        if (nextElementIdx < 0) {
c0de702e:	dc03      	bgt.n	c0de7038 <genericContextComputeNextPageParams+0x180>
            nextElementIdx = genericContext.currentContentElementNb + nextElementIdx;
c0de7030:	eb09 000a 	add.w	r0, r9, sl
c0de7034:	7c40      	ldrb	r0, [r0, #17]
c0de7036:	4406      	add	r6, r0
c0de7038:	46bc      	mov	ip, r7
    if ((nextElementIdx < 0) || (nextElementIdx >= genericContext.currentContentElementNb)) {
c0de703a:	2e00      	cmp	r6, #0
c0de703c:	d41a      	bmi.n	c0de7074 <genericContextComputeNextPageParams+0x1bc>
c0de703e:	eb09 000a 	add.w	r0, r9, sl
c0de7042:	7c40      	ldrb	r0, [r0, #17]
c0de7044:	4286      	cmp	r6, r0
c0de7046:	da15      	bge.n	c0de7074 <genericContextComputeNextPageParams+0x1bc>
    genericContext.currentElementIdx = nextElementIdx;
c0de7048:	eb09 000a 	add.w	r0, r9, sl
c0de704c:	7486      	strb	r6, [r0, #18]
}
c0de704e:	4628      	mov	r0, r5
    navInfo.activePage               = pageIdx;
c0de7050:	f809 400c 	strb.w	r4, [r9, ip]
}
c0de7054:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        return PIC(&genericContents->contentsList[contentIdx]);
c0de7058:	eb09 010a 	add.w	r1, r9, sl
c0de705c:	6889      	ldr	r1, [r1, #8]
c0de705e:	ebc0 00c0 	rsb	r0, r0, r0, lsl #3
c0de7062:	eb01 00c0 	add.w	r0, r1, r0, lsl #3
c0de7066:	4665      	mov	r5, ip
c0de7068:	f001 ff48 	bl	c0de8efc <pic>
c0de706c:	46ac      	mov	ip, r5
c0de706e:	4605      	mov	r5, r0
        if (p_content == NULL) {
c0de7070:	2d00      	cmp	r5, #0
c0de7072:	d1a5      	bne.n	c0de6fc0 <genericContextComputeNextPageParams+0x108>
c0de7074:	2000      	movs	r0, #0
}
c0de7076:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de707a <bundleNavStartSettings>:
{
c0de707a:	b580      	push	{r7, lr}
c0de707c:	b082      	sub	sp, #8
    nbgl_useCaseGenericSettings(context->appName,
c0de707e:	f240 51ac 	movw	r1, #1452	@ 0x5ac
c0de7082:	f2c0 0100 	movt	r1, #0
c0de7086:	f859 0001 	ldr.w	r0, [r9, r1]
c0de708a:	4449      	add	r1, r9
                                context->settingContents,
c0de708c:	e9d1 2303 	ldrd	r2, r3, [r1, #12]
    nbgl_useCaseGenericSettings(context->appName,
c0de7090:	f24f 6c39 	movw	ip, #63033	@ 0xf639
c0de7094:	f6cf 7cff 	movt	ip, #65535	@ 0xffff
c0de7098:	44fc      	add	ip, pc
c0de709a:	2100      	movs	r1, #0
c0de709c:	f8cd c000 	str.w	ip, [sp]
c0de70a0:	f7fe fdf4 	bl	c0de5c8c <nbgl_useCaseGenericSettings>
}
c0de70a4:	b002      	add	sp, #8
c0de70a6:	bd80      	pop	{r7, pc}

c0de70a8 <displayFullValuePage>:
{
c0de70a8:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de70ac:	b09c      	sub	sp, #112	@ 0x70
c0de70ae:	4614      	mov	r4, r2
        = (extension->backText != NULL) ? PIC(extension->backText) : PIC(backText);
c0de70b0:	68d2      	ldr	r2, [r2, #12]
c0de70b2:	4688      	mov	r8, r1
c0de70b4:	2a00      	cmp	r2, #0
c0de70b6:	bf18      	it	ne
c0de70b8:	4610      	movne	r0, r2
c0de70ba:	f001 ff1f 	bl	c0de8efc <pic>
    if (extension->aliasType == INFO_LIST_ALIAS) {
c0de70be:	7d21      	ldrb	r1, [r4, #20]
c0de70c0:	2905      	cmp	r1, #5
c0de70c2:	d04b      	beq.n	c0de715c <displayFullValuePage+0xb4>
c0de70c4:	2904      	cmp	r1, #4
c0de70c6:	f040 80ca 	bne.w	c0de725e <displayFullValuePage+0x1b6>
        genericContext.currentInfos = extension->infolist;
c0de70ca:	f240 4274 	movw	r2, #1140	@ 0x474
c0de70ce:	6921      	ldr	r1, [r4, #16]
c0de70d0:	f2c0 0200 	movt	r2, #0
c0de70d4:	444a      	add	r2, r9
c0de70d6:	6351      	str	r1, [r2, #52]	@ 0x34
        displayInfosListModal(modalTitle, extension->infolist, true);
c0de70d8:	6921      	ldr	r1, [r4, #16]
    nbgl_pageNavigationInfo_t info = {.activePage                = 0,
c0de70da:	f643 028a 	movw	r2, #14474	@ 0x388a
c0de70de:	f2c0 0200 	movt	r2, #0
c0de70e2:	447a      	add	r2, pc
c0de70e4:	cae0      	ldmia	r2!, {r5, r6, r7}
c0de70e6:	ab15      	add	r3, sp, #84	@ 0x54
c0de70e8:	c3e0      	stmia	r3!, {r5, r6, r7}
c0de70ea:	e892 00f0 	ldmia.w	r2, {r4, r5, r6, r7}
           .infosList.nbInfos        = infos->nbInfos,
c0de70ee:	f10d 0c24 	add.w	ip, sp, #36	@ 0x24
    nbgl_pageNavigationInfo_t info = {.activePage                = 0,
c0de70f2:	c3f0      	stmia	r3!, {r4, r5, r6, r7}
        = {.type                     = INFOS_LIST,
c0de70f4:	9005      	str	r0, [sp, #20]
c0de70f6:	f241 4000 	movw	r0, #5120	@ 0x1400
c0de70fa:	f2c0 0009 	movt	r0, #9
c0de70fe:	9006      	str	r0, [sp, #24]
c0de7100:	2000      	movs	r0, #0
c0de7102:	9007      	str	r0, [sp, #28]
c0de7104:	2008      	movs	r0, #8
c0de7106:	f88d 0020 	strb.w	r0, [sp, #32]
           .infosList.infoTypes      = infos->infoTypes,
c0de710a:	e891 000d 	ldmia.w	r1, {r0, r2, r3}
    if (modalPageContext != NULL) {
c0de710e:	f240 54e0 	movw	r4, #1504	@ 0x5e0
           .infosList.nbInfos        = infos->nbInfos,
c0de7112:	e88c 000d 	stmia.w	ip, {r0, r2, r3}
c0de7116:	7b08      	ldrb	r0, [r1, #12]
    if (modalPageContext != NULL) {
c0de7118:	f2c0 0400 	movt	r4, #0
           .infosList.nbInfos        = infos->nbInfos,
c0de711c:	f88d 0030 	strb.w	r0, [sp, #48]	@ 0x30
c0de7120:	200e      	movs	r0, #14
c0de7122:	f88d 0031 	strb.w	r0, [sp, #49]	@ 0x31
    if (modalPageContext != NULL) {
c0de7126:	f859 0004 	ldr.w	r0, [r9, r4]
           .infosList.withExtensions = infos->withExtensions,
c0de712a:	7b89      	ldrb	r1, [r1, #14]
    if (modalPageContext != NULL) {
c0de712c:	2800      	cmp	r0, #0
           .infosList.nbInfos        = infos->nbInfos,
c0de712e:	f88d 1032 	strb.w	r1, [sp, #50]	@ 0x32
        nbgl_pageRelease(modalPageContext);
c0de7132:	bf18      	it	ne
c0de7134:	f7fe fb8f 	blne	c0de5856 <nbgl_pageRelease>
    modalPageContext = nbgl_pageDrawGenericContentExt(&pageModalCallback, &info, &content, true);
c0de7138:	f64f 30a1 	movw	r0, #64417	@ 0xfba1
c0de713c:	f6cf 70ff 	movt	r0, #65535	@ 0xffff
c0de7140:	4478      	add	r0, pc
c0de7142:	a915      	add	r1, sp, #84	@ 0x54
c0de7144:	aa05      	add	r2, sp, #20
c0de7146:	2301      	movs	r3, #1
c0de7148:	f7fe f8e2 	bl	c0de5310 <nbgl_pageDrawGenericContentExt>
c0de714c:	f849 0004 	str.w	r0, [r9, r4]
    nbgl_refreshSpecial(FULL_COLOR_CLEAN_REFRESH);
c0de7150:	2002      	movs	r0, #2
c0de7152:	f000 ffa9 	bl	c0de80a8 <nbgl_refreshSpecial>
}
c0de7156:	b01c      	add	sp, #112	@ 0x70
c0de7158:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        genericContext.currentTagValues = extension->tagValuelist;
c0de715c:	f240 4174 	movw	r1, #1140	@ 0x474
c0de7160:	6920      	ldr	r0, [r4, #16]
c0de7162:	f2c0 0100 	movt	r1, #0
c0de7166:	4449      	add	r1, r9
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de7168:	f240 72c4 	movw	r2, #1988	@ 0x7c4
        genericContext.currentTagValues = extension->tagValuelist;
c0de716c:	6388      	str	r0, [r1, #56]	@ 0x38
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de716e:	f2c0 0200 	movt	r2, #0
        displayTagValueListModal(extension->tagValuelist);
c0de7172:	6925      	ldr	r5, [r4, #16]
c0de7174:	2300      	movs	r3, #0
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de7176:	eb09 0102 	add.w	r1, r9, r2
c0de717a:	e9c1 3302 	strd	r3, r3, [r1, #8]
    nbElements = tagValues->nbPairs;
c0de717e:	7a28      	ldrb	r0, [r5, #8]
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de7180:	604b      	str	r3, [r1, #4]
    while (nbElements > 0) {
c0de7182:	2800      	cmp	r0, #0
    memset(&detailsContext, 0, sizeof(detailsContext));
c0de7184:	f849 3002 	str.w	r3, [r9, r2]
    while (nbElements > 0) {
c0de7188:	f000 80a6 	beq.w	c0de72d8 <displayFullValuePage+0x230>
c0de718c:	2600      	movs	r6, #0
c0de718e:	e028      	b.n	c0de71e2 <displayFullValuePage+0x13a>
c0de7190:	9800      	ldr	r0, [sp, #0]
c0de7192:	4632      	mov	r2, r6
c0de7194:	4680      	mov	r8, r0
c0de7196:	f240 7ec4 	movw	lr, #1988	@ 0x7c4
c0de719a:	f2c0 0e00 	movt	lr, #0
        modalContextSetPageInfo(detailsContext.nbPages, nbElementsInPage);
c0de719e:	f819 100e 	ldrb.w	r1, [r9, lr]
    modalContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de71a2:	f240 77e4 	movw	r7, #2020	@ 0x7e4
c0de71a6:	4616      	mov	r6, r2
c0de71a8:	f2c0 0700 	movt	r7, #0
        elemIdx += nbElementsInPage;
c0de71ac:	eb08 0602 	add.w	r6, r8, r2
        &= ~(0x0F << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS));
c0de71b0:	2204      	movs	r2, #4
    modalContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de71b2:	084b      	lsrs	r3, r1, #1
c0de71b4:	444f      	add	r7, r9
        &= ~(0x0F << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS));
c0de71b6:	ea02 0281 	and.w	r2, r2, r1, lsl #2
c0de71ba:	f817 c003 	ldrb.w	ip, [r7, r3]
c0de71be:	240f      	movs	r4, #15
c0de71c0:	4094      	lsls	r4, r2
c0de71c2:	ea2c 0c04 	bic.w	ip, ip, r4
        |= pageData << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de71c6:	f008 0407 	and.w	r4, r8, #7
c0de71ca:	fa04 f202 	lsl.w	r2, r4, r2
c0de71ce:	ea42 020c 	orr.w	r2, r2, ip
        nbElements -= nbElementsInPage;
c0de71d2:	eba0 0008 	sub.w	r0, r0, r8
        |= pageData << ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de71d6:	54fa      	strb	r2, [r7, r3]
        detailsContext.nbPages++;
c0de71d8:	1c4a      	adds	r2, r1, #1
    while (nbElements > 0) {
c0de71da:	0601      	lsls	r1, r0, #24
        detailsContext.nbPages++;
c0de71dc:	f809 200e 	strb.w	r2, [r9, lr]
    while (nbElements > 0) {
c0de71e0:	d07a      	beq.n	c0de72d8 <displayFullValuePage+0x230>
c0de71e2:	b2f1      	uxtb	r1, r6
    while (nbPairsInPage < nbPairs) {
c0de71e4:	fa5f fb80 	uxtb.w	fp, r0
c0de71e8:	ea4f 1801 	mov.w	r8, r1, lsl #4
c0de71ec:	f04f 0a00 	mov.w	sl, #0
c0de71f0:	2700      	movs	r7, #0
c0de71f2:	9000      	str	r0, [sp, #0]
c0de71f4:	e022      	b.n	c0de723c <displayFullValuePage+0x194>
c0de71f6:	bf00      	nop
            pair = PIC(tagValueList->callback(startIndex + nbPairsInPage));
c0de71f8:	6869      	ldr	r1, [r5, #4]
c0de71fa:	eb06 000a 	add.w	r0, r6, sl
c0de71fe:	b2c0      	uxtb	r0, r0
c0de7200:	4788      	blx	r1
c0de7202:	f001 fe7b 	bl	c0de8efc <pic>
            SMALL_REGULAR_FONT, pair->item, AVAILABLE_WIDTH, tagValueList->wrapping);
c0de7206:	6801      	ldr	r1, [r0, #0]
c0de7208:	7bab      	ldrb	r3, [r5, #14]
c0de720a:	4604      	mov	r4, r0
        currentHeight += nbgl_getTextHeightInWidth(
c0de720c:	200b      	movs	r0, #11
c0de720e:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de7212:	f000 ff99 	bl	c0de8148 <nbgl_getTextHeightInWidth>
            SMALL_REGULAR_FONT, pair->value, AVAILABLE_WIDTH, tagValueList->wrapping);
c0de7216:	6861      	ldr	r1, [r4, #4]
c0de7218:	7bab      	ldrb	r3, [r5, #14]
        currentHeight += nbgl_getTextHeightInWidth(
c0de721a:	4604      	mov	r4, r0
        currentHeight += nbgl_getTextHeightInWidth(
c0de721c:	200b      	movs	r0, #11
c0de721e:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de7222:	f000 ff91 	bl	c0de8148 <nbgl_getTextHeightInWidth>
        currentHeight += nbgl_getTextHeightInWidth(
c0de7226:	1939      	adds	r1, r7, r4
        currentHeight += 4;
c0de7228:	4408      	add	r0, r1
        currentHeight += nbgl_getTextHeightInWidth(
c0de722a:	1d07      	adds	r7, r0, #4
c0de722c:	b2b8      	uxth	r0, r7
        if (currentHeight >= maxUsableHeight) {
c0de722e:	f10a 0a01 	add.w	sl, sl, #1
c0de7232:	f5b0 7fe8 	cmp.w	r0, #464	@ 0x1d0
c0de7236:	f108 0810 	add.w	r8, r8, #16
c0de723a:	d20b      	bcs.n	c0de7254 <displayFullValuePage+0x1ac>
    while (nbPairsInPage < nbPairs) {
c0de723c:	45d3      	cmp	fp, sl
c0de723e:	d0a7      	beq.n	c0de7190 <displayFullValuePage+0xe8>
        if (tagValueList->pairs != NULL) {
c0de7240:	6828      	ldr	r0, [r5, #0]
        if (nbPairsInPage > 0) {
c0de7242:	f1ba 0f00 	cmp.w	sl, #0
c0de7246:	bf18      	it	ne
c0de7248:	3718      	addne	r7, #24
        if (tagValueList->pairs != NULL) {
c0de724a:	2800      	cmp	r0, #0
c0de724c:	d0d4      	beq.n	c0de71f8 <displayFullValuePage+0x150>
            pair = PIC(&tagValueList->pairs[startIndex + nbPairsInPage]);
c0de724e:	4440      	add	r0, r8
c0de7250:	e7d7      	b.n	c0de7202 <displayFullValuePage+0x15a>
c0de7252:	bf00      	nop
c0de7254:	9800      	ldr	r0, [sp, #0]
c0de7256:	4632      	mov	r2, r6
        if (currentHeight >= maxUsableHeight) {
c0de7258:	f1aa 0801 	sub.w	r8, sl, #1
c0de725c:	e79b      	b.n	c0de7196 <displayFullValuePage+0xee>
        nbgl_layoutDescription_t layoutDescription = {.modal            = true,
c0de725e:	f243 628e 	movw	r2, #13966	@ 0x368e
c0de7262:	f2c0 0200 	movt	r2, #0
c0de7266:	447a      	add	r2, pc
c0de7268:	f10d 0c14 	add.w	ip, sp, #20
c0de726c:	cae0      	ldmia	r2!, {r5, r6, r7}
c0de726e:	4663      	mov	r3, ip
c0de7270:	c3e0      	stmia	r3!, {r5, r6, r7}
c0de7272:	e892 00e2 	ldmia.w	r2, {r1, r5, r6, r7}
c0de7276:	c3e2      	stmia	r3!, {r1, r5, r6, r7}
c0de7278:	2101      	movs	r1, #1
        nbgl_layoutHeader_t      headerDesc        = {.type               = HEADER_BACK_AND_TEXT,
c0de727a:	f8ad 1054 	strh.w	r1, [sp, #84]	@ 0x54
c0de727e:	2100      	movs	r1, #0
                                                      .backAndText.token  = 0,
c0de7280:	e9cd 1016 	strd	r1, r0, [sp, #88]	@ 0x58
c0de7284:	f44f 6010 	mov.w	r0, #2304	@ 0x900
c0de7288:	f8ad 0060 	strh.w	r0, [sp, #96]	@ 0x60
        genericContext.modalLayout                 = nbgl_layoutGet(&layoutDescription);
c0de728c:	4660      	mov	r0, ip
c0de728e:	f7f9 fb19 	bl	c0de08c4 <nbgl_layoutGet>
c0de7292:	f240 4674 	movw	r6, #1140	@ 0x474
c0de7296:	f2c0 0600 	movt	r6, #0
c0de729a:	eb09 0106 	add.w	r1, r9, r6
c0de729e:	62c8      	str	r0, [r1, #44]	@ 0x2c
c0de72a0:	a915      	add	r1, sp, #84	@ 0x54
        nbgl_layoutAddHeader(genericContext.modalLayout, &headerDesc);
c0de72a2:	f7fc ff84 	bl	c0de41ae <nbgl_layoutAddHeader>
        if (extension->aliasType == QR_CODE_ALIAS) {
c0de72a6:	7d20      	ldrb	r0, [r4, #20]
c0de72a8:	2801      	cmp	r0, #1
c0de72aa:	d01c      	beq.n	c0de72e6 <displayFullValuePage+0x23e>
c0de72ac:	2802      	cmp	r0, #2
c0de72ae:	d020      	beq.n	c0de72f2 <displayFullValuePage+0x24a>
c0de72b0:	2803      	cmp	r0, #3
c0de72b2:	d124      	bne.n	c0de72fe <displayFullValuePage+0x256>
                = {.url      = extension->fullValue,
c0de72b4:	e894 0007 	ldmia.w	r4, {r0, r1, r2}
                   .text1    = (extension->title != NULL) ? extension->title : extension->fullValue,
c0de72b8:	2a00      	cmp	r2, #0
                = {.url      = extension->fullValue,
c0de72ba:	9001      	str	r0, [sp, #4]
                   .text1    = (extension->title != NULL) ? extension->title : extension->fullValue,
c0de72bc:	bf08      	it	eq
c0de72be:	4602      	moveq	r2, r0
            nbgl_layoutAddQRCode(genericContext.modalLayout, &qrCode);
c0de72c0:	eb09 0006 	add.w	r0, r9, r6
                = {.url      = extension->fullValue,
c0de72c4:	e9cd 2102 	strd	r2, r1, [sp, #8]
c0de72c8:	f44f 3180 	mov.w	r1, #65536	@ 0x10000
            nbgl_layoutAddQRCode(genericContext.modalLayout, &qrCode);
c0de72cc:	6ac0      	ldr	r0, [r0, #44]	@ 0x2c
                = {.url      = extension->fullValue,
c0de72ce:	9104      	str	r1, [sp, #16]
c0de72d0:	a901      	add	r1, sp, #4
            nbgl_layoutAddQRCode(genericContext.modalLayout, &qrCode);
c0de72d2:	f7fc fa00 	bl	c0de36d6 <nbgl_layoutAddQRCode>
c0de72d6:	e01a      	b.n	c0de730e <displayFullValuePage+0x266>
    displayTagValueListModalPage(0, true);
c0de72d8:	2000      	movs	r0, #0
c0de72da:	2101      	movs	r1, #1
c0de72dc:	f000 fba0 	bl	c0de7a20 <displayTagValueListModalPage>
}
c0de72e0:	b01c      	add	sp, #112	@ 0x70
c0de72e2:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de72e6:	f243 0311 	movw	r3, #12305	@ 0x3011
c0de72ea:	f2c0 0300 	movt	r3, #0
c0de72ee:	447b      	add	r3, pc
c0de72f0:	e006      	b.n	c0de7300 <displayFullValuePage+0x258>
c0de72f2:	f243 3322 	movw	r3, #13090	@ 0x3322
c0de72f6:	f2c0 0300 	movt	r3, #0
c0de72fa:	447b      	add	r3, pc
c0de72fc:	e000      	b.n	c0de7300 <displayFullValuePage+0x258>
                info = extension->explanation;
c0de72fe:	6863      	ldr	r3, [r4, #4]
                genericContext.modalLayout, aliasText, extension->fullValue, info);
c0de7300:	eb09 0006 	add.w	r0, r9, r6
c0de7304:	6ac0      	ldr	r0, [r0, #44]	@ 0x2c
c0de7306:	6822      	ldr	r2, [r4, #0]
            nbgl_layoutAddTextContent(
c0de7308:	4641      	mov	r1, r8
c0de730a:	f7fb fc10 	bl	c0de2b2e <nbgl_layoutAddTextContent>
        nbgl_layoutDraw(genericContext.modalLayout);
c0de730e:	eb09 0006 	add.w	r0, r9, r6
c0de7312:	6ac0      	ldr	r0, [r0, #44]	@ 0x2c
c0de7314:	f7fd fb9b 	bl	c0de4a4e <nbgl_layoutDraw>
        nbgl_refresh();
c0de7318:	f000 fec1 	bl	c0de809e <nbgl_refresh>
}
c0de731c:	b01c      	add	sp, #112	@ 0x70
c0de731e:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de7322 <displaySecurityReport>:
{
c0de7322:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de7326:	b09c      	sub	sp, #112	@ 0x70
    nbgl_layoutDescription_t layoutDescription = {.modal            = true,
c0de7328:	f243 52c4 	movw	r2, #13764	@ 0x35c4
c0de732c:	f2c0 0200 	movt	r2, #0
c0de7330:	447a      	add	r2, pc
c0de7332:	a915      	add	r1, sp, #84	@ 0x54
c0de7334:	cae0      	ldmia	r2!, {r5, r6, r7}
c0de7336:	460b      	mov	r3, r1
c0de7338:	c3e0      	stmia	r3!, {r5, r6, r7}
c0de733a:	4680      	mov	r8, r0
c0de733c:	e892 00d1 	ldmia.w	r2, {r0, r4, r6, r7}
c0de7340:	aa10      	add	r2, sp, #64	@ 0x40
c0de7342:	c3d1      	stmia	r3!, {r0, r4, r6, r7}
    nbgl_layoutHeader_t      headerDesc        = {.type               = HEADER_BACK_AND_TEXT,
c0de7344:	f243 50c4 	movw	r0, #13764	@ 0x35c4
c0de7348:	f2c0 0000 	movt	r0, #0
c0de734c:	4478      	add	r0, pc
c0de734e:	e890 00f8 	ldmia.w	r0, {r3, r4, r5, r6, r7}
c0de7352:	2000      	movs	r0, #0
c0de7354:	c2f8      	stmia	r2!, {r3, r4, r5, r6, r7}
    nbgl_layoutFooter_t      footerDesc
c0de7356:	e9cd 000e 	strd	r0, r0, [sp, #56]	@ 0x38
c0de735a:	e9cd 000c 	strd	r0, r0, [sp, #48]	@ 0x30
c0de735e:	e9cd 000a 	strd	r0, r0, [sp, #40]	@ 0x28
    reviewWithWarnCtx.modalLayout = nbgl_layoutGet(&layoutDescription);
c0de7362:	4608      	mov	r0, r1
c0de7364:	f7f9 faae 	bl	c0de08c4 <nbgl_layoutGet>
c0de7368:	f240 4774 	movw	r7, #1140	@ 0x474
c0de736c:	f2c0 0700 	movt	r7, #0
c0de7370:	eb09 0107 	add.w	r1, r9, r7
    if ((reviewWithWarnCtx.securityReportLevel == 1) && (!reviewWithWarnCtx.isIntro)) {
c0de7374:	f891 2088 	ldrb.w	r2, [r1, #136]	@ 0x88
    reviewWithWarnCtx.modalLayout = nbgl_layoutGet(&layoutDescription);
c0de7378:	4604      	mov	r4, r0
    if ((reviewWithWarnCtx.securityReportLevel == 1) && (!reviewWithWarnCtx.isIntro)) {
c0de737a:	2a01      	cmp	r2, #1
    reviewWithWarnCtx.modalLayout = nbgl_layoutGet(&layoutDescription);
c0de737c:	f8c1 0084 	str.w	r0, [r1, #132]	@ 0x84
    if ((reviewWithWarnCtx.securityReportLevel == 1) && (!reviewWithWarnCtx.isIntro)) {
c0de7380:	d15f      	bne.n	c0de7442 <displaySecurityReport+0x120>
c0de7382:	f891 0089 	ldrb.w	r0, [r1, #137]	@ 0x89
c0de7386:	2800      	cmp	r0, #0
c0de7388:	d15b      	bne.n	c0de7442 <displaySecurityReport+0x120>
c0de738a:	f243 5690 	movw	r6, #13712	@ 0x3590
c0de738e:	f2c0 0600 	movt	r6, #0
c0de7392:	2500      	movs	r5, #0
c0de7394:	447e      	add	r6, pc
c0de7396:	ac01      	add	r4, sp, #4
c0de7398:	f04f 0a00 	mov.w	sl, #0
c0de739c:	f04f 0b00 	mov.w	fp, #0
c0de73a0:	e017      	b.n	c0de73d2 <displaySecurityReport+0xb0>
                    bar.token = NBGL_INVALID_TOKEN;
c0de73a2:	20ff      	movs	r0, #255	@ 0xff
c0de73a4:	f88d 0015 	strb.w	r0, [sp, #21]
                bar.iconLeft = securityReportItems[i].icon;
c0de73a8:	f856 100a 	ldr.w	r1, [r6, sl]
                nbgl_layoutAddTouchableBar(reviewWithWarnCtx.modalLayout, &bar);
c0de73ac:	eb09 0807 	add.w	r8, r9, r7
c0de73b0:	f8d8 0084 	ldr.w	r0, [r8, #132]	@ 0x84
                bar.iconLeft = securityReportItems[i].icon;
c0de73b4:	9101      	str	r1, [sp, #4]
                nbgl_layoutAddTouchableBar(reviewWithWarnCtx.modalLayout, &bar);
c0de73b6:	4621      	mov	r1, r4
c0de73b8:	f7fb f852 	bl	c0de2460 <nbgl_layoutAddTouchableBar>
                nbgl_layoutAddSeparationLine(reviewWithWarnCtx.modalLayout);
c0de73bc:	f8d8 0084 	ldr.w	r0, [r8, #132]	@ 0x84
c0de73c0:	f7fc fd5f 	bl	c0de3e82 <nbgl_layoutAddSeparationLine>
        for (i = 0; i < NB_WARNING_TYPES; i++) {
c0de73c4:	f10a 0a0c 	add.w	sl, sl, #12
c0de73c8:	f1ba 0f48 	cmp.w	sl, #72	@ 0x48
c0de73cc:	f10b 0b01 	add.w	fp, fp, #1
c0de73d0:	d07b      	beq.n	c0de74ca <displaySecurityReport+0x1a8>
                && (reviewWithWarnCtx.warning->predefinedSet & (1 << i))) {
c0de73d2:	f1ba 0f3c 	cmp.w	sl, #60	@ 0x3c
c0de73d6:	d0f5      	beq.n	c0de73c4 <displaySecurityReport+0xa2>
c0de73d8:	eb09 0007 	add.w	r0, r9, r7
c0de73dc:	6f80      	ldr	r0, [r0, #120]	@ 0x78
c0de73de:	6801      	ldr	r1, [r0, #0]
            if ((i != GATED_SIGNING_WARN)
c0de73e0:	fa21 f10b 	lsr.w	r1, r1, fp
c0de73e4:	07c9      	lsls	r1, r1, #31
c0de73e6:	d0ed      	beq.n	c0de73c4 <displaySecurityReport+0xa2>
                if ((i == BLIND_SIGNING_WARN) || (i == W3C_NO_THREAT_WARN) || (i == W3C_ISSUE_WARN)
c0de73e8:	fa5f f18b 	uxtb.w	r1, fp
c0de73ec:	2904      	cmp	r1, #4
                nbgl_layoutBar_t bar = {0};
c0de73ee:	9506      	str	r5, [sp, #24]
c0de73f0:	e9cd 5504 	strd	r5, r5, [sp, #16]
c0de73f4:	e9cd 5502 	strd	r5, r5, [sp, #8]
c0de73f8:	9501      	str	r5, [sp, #4]
                if ((i == BLIND_SIGNING_WARN) || (i == W3C_NO_THREAT_WARN) || (i == W3C_ISSUE_WARN)
c0de73fa:	d81e      	bhi.n	c0de743a <displaySecurityReport+0x118>
c0de73fc:	2201      	movs	r2, #1
c0de73fe:	fa02 f101 	lsl.w	r1, r2, r1
c0de7402:	f011 0f19 	tst.w	r1, #25
c0de7406:	d018      	beq.n	c0de743a <displaySecurityReport+0x118>
                    bar.subText = securityReportItems[i].subText;
c0de7408:	eb06 000a 	add.w	r0, r6, sl
c0de740c:	6880      	ldr	r0, [r0, #8]
c0de740e:	9004      	str	r0, [sp, #16]
                bar.text = securityReportItems[i].text;
c0de7410:	eb06 000a 	add.w	r0, r6, sl
c0de7414:	6840      	ldr	r0, [r0, #4]
                if (i != W3C_NO_THREAT_WARN) {
c0de7416:	f1ba 0f24 	cmp.w	sl, #36	@ 0x24
                bar.text = securityReportItems[i].text;
c0de741a:	9002      	str	r0, [sp, #8]
                if (i != W3C_NO_THREAT_WARN) {
c0de741c:	d0c1      	beq.n	c0de73a2 <displaySecurityReport+0x80>
                    bar.iconRight = &PUSH_ICON;
c0de741e:	f242 6078 	movw	r0, #9848	@ 0x2678
c0de7422:	f2c0 0000 	movt	r0, #0
c0de7426:	4478      	add	r0, pc
c0de7428:	9003      	str	r0, [sp, #12]
                    bar.token     = FIRST_WARN_BAR_TOKEN + i;
c0de742a:	f10b 001c 	add.w	r0, fp, #28
c0de742e:	f88d 0015 	strb.w	r0, [sp, #21]
                    bar.tuneId    = TUNE_TAP_CASUAL;
c0de7432:	2009      	movs	r0, #9
c0de7434:	f88d 0018 	strb.w	r0, [sp, #24]
c0de7438:	e7b6      	b.n	c0de73a8 <displaySecurityReport+0x86>
                    || (reviewWithWarnCtx.warning->providerMessage == NULL)) {
c0de743a:	6900      	ldr	r0, [r0, #16]
                if ((i == BLIND_SIGNING_WARN) || (i == W3C_NO_THREAT_WARN) || (i == W3C_ISSUE_WARN)
c0de743c:	2800      	cmp	r0, #0
c0de743e:	d1e6      	bne.n	c0de740e <displaySecurityReport+0xec>
c0de7440:	e7e2      	b.n	c0de7408 <displaySecurityReport+0xe6>
    if (reviewWithWarnCtx.warning && reviewWithWarnCtx.warning->reportProvider) {
c0de7442:	eb09 0007 	add.w	r0, r9, r7
c0de7446:	6f80      	ldr	r0, [r0, #120]	@ 0x78
c0de7448:	2800      	cmp	r0, #0
c0de744a:	d04c      	beq.n	c0de74e6 <displaySecurityReport+0x1c4>
c0de744c:	68c6      	ldr	r6, [r0, #12]
c0de744e:	2e00      	cmp	r6, #0
c0de7450:	d049      	beq.n	c0de74e6 <displaySecurityReport+0x1c4>
    if ((set & (1 << W3C_THREAT_DETECTED_WARN)) || (set & (1 << W3C_RISK_DETECTED_WARN))) {
c0de7452:	f018 0f06 	tst.w	r8, #6
c0de7456:	d04e      	beq.n	c0de74f6 <displaySecurityReport+0x1d4>
        nbgl_layoutQRCode_t qrCode = {.url      = destStr,
c0de7458:	f240 6140 	movw	r1, #1600	@ 0x640
c0de745c:	f2c0 0100 	movt	r1, #0
c0de7460:	4449      	add	r1, r9
                                      .text1    = reviewWithWarnCtx.warning->reportUrl,
c0de7462:	6883      	ldr	r3, [r0, #8]
        nbgl_layoutQRCode_t qrCode = {.url      = destStr,
c0de7464:	f101 0440 	add.w	r4, r1, #64	@ 0x40
c0de7468:	e9cd 4301 	strd	r4, r3, [sp, #4]
c0de746c:	f642 7001 	movw	r0, #12033	@ 0x2f01
c0de7470:	f2c0 0000 	movt	r0, #0
c0de7474:	4478      	add	r0, pc
c0de7476:	9003      	str	r0, [sp, #12]
c0de7478:	f44f 3080 	mov.w	r0, #65536	@ 0x10000
c0de747c:	9004      	str	r0, [sp, #16]
        snprintf(destStr,
c0de747e:	f642 626e 	movw	r2, #11886	@ 0x2e6e
c0de7482:	f2c0 0200 	movt	r2, #0
c0de7486:	447a      	add	r2, pc
c0de7488:	4620      	mov	r0, r4
c0de748a:	2140      	movs	r1, #64	@ 0x40
c0de748c:	f001 fcf0 	bl	c0de8e70 <snprintf>
        urlLen = strlen(destStr) + 1;
c0de7490:	4620      	mov	r0, r4
c0de7492:	f001 ff79 	bl	c0de9388 <strlen>
c0de7496:	4605      	mov	r5, r0
        nbgl_layoutAddQRCode(reviewWithWarnCtx.modalLayout, &qrCode);
c0de7498:	eb09 0007 	add.w	r0, r9, r7
c0de749c:	f8d0 0084 	ldr.w	r0, [r0, #132]	@ 0x84
c0de74a0:	a901      	add	r1, sp, #4
        urlLen = strlen(destStr) + 1;
c0de74a2:	442c      	add	r4, r5
        nbgl_layoutAddQRCode(reviewWithWarnCtx.modalLayout, &qrCode);
c0de74a4:	f7fc f917 	bl	c0de36d6 <nbgl_layoutAddQRCode>
c0de74a8:	2018      	movs	r0, #24
        footerDesc.emptySpace.height = 24;
c0de74aa:	f8ad 002c 	strh.w	r0, [sp, #44]	@ 0x2c
        snprintf(destStr + urlLen, W3C_DESCRIPTION_MAX_LEN / 2 - urlLen, "%s report", provider);
c0de74ae:	f642 6290 	movw	r2, #11920	@ 0x2e90
c0de74b2:	3401      	adds	r4, #1
c0de74b4:	f2c0 0200 	movt	r2, #0
c0de74b8:	f1c5 013f 	rsb	r1, r5, #63	@ 0x3f
c0de74bc:	447a      	add	r2, pc
c0de74be:	4620      	mov	r0, r4
c0de74c0:	4633      	mov	r3, r6
c0de74c2:	f001 fcd5 	bl	c0de8e70 <snprintf>
        headerDesc.backAndText.text = destStr + urlLen;
c0de74c6:	9412      	str	r4, [sp, #72]	@ 0x48
c0de74c8:	e053      	b.n	c0de7572 <displaySecurityReport+0x250>
        headerDesc.backAndText.text = "Security report";
c0de74ca:	f642 6153 	movw	r1, #11859	@ 0x2e53
c0de74ce:	f2c0 0100 	movt	r1, #0
        nbgl_layoutAddHeader(reviewWithWarnCtx.modalLayout, &headerDesc);
c0de74d2:	eb09 0007 	add.w	r0, r9, r7
        headerDesc.backAndText.text = "Security report";
c0de74d6:	4479      	add	r1, pc
        nbgl_layoutAddHeader(reviewWithWarnCtx.modalLayout, &headerDesc);
c0de74d8:	f8d0 0084 	ldr.w	r0, [r0, #132]	@ 0x84
        headerDesc.backAndText.text = "Security report";
c0de74dc:	9112      	str	r1, [sp, #72]	@ 0x48
c0de74de:	a910      	add	r1, sp, #64	@ 0x40
        nbgl_layoutAddHeader(reviewWithWarnCtx.modalLayout, &headerDesc);
c0de74e0:	f7fc fe65 	bl	c0de41ae <nbgl_layoutAddHeader>
c0de74e4:	e056      	b.n	c0de7594 <displaySecurityReport+0x272>
c0de74e6:	f243 068f 	movw	r6, #12431	@ 0x308f
c0de74ea:	f2c0 0600 	movt	r6, #0
c0de74ee:	447e      	add	r6, pc
    if ((set & (1 << W3C_THREAT_DETECTED_WARN)) || (set & (1 << W3C_RISK_DETECTED_WARN))) {
c0de74f0:	f018 0f06 	tst.w	r8, #6
c0de74f4:	d1b0      	bne.n	c0de7458 <displaySecurityReport+0x136>
    else if (set & (1 << BLIND_SIGNING_WARN)) {
c0de74f6:	ea5f 60c8 	movs.w	r0, r8, lsl #27
c0de74fa:	d419      	bmi.n	c0de7530 <displaySecurityReport+0x20e>
    else if (set & (1 << W3C_ISSUE_WARN)) {
c0de74fc:	ea5f 70c8 	movs.w	r0, r8, lsl #31
c0de7500:	d037      	beq.n	c0de7572 <displaySecurityReport+0x250>
c0de7502:	ad01      	add	r5, sp, #4
        nbgl_contentCenter_t info = {0};
c0de7504:	4628      	mov	r0, r5
c0de7506:	2124      	movs	r1, #36	@ 0x24
c0de7508:	f001 feec 	bl	c0de92e4 <__aeabi_memclr>
        info.icon                 = &LARGE_WARNING_ICON;
c0de750c:	f242 4018 	movw	r0, #9240	@ 0x2418
c0de7510:	f2c0 0000 	movt	r0, #0
c0de7514:	4478      	add	r0, pc
c0de7516:	9002      	str	r0, [sp, #8]
        info.title                = "Transaction Check unavailable";
c0de7518:	f642 40c5 	movw	r0, #11461	@ 0x2cc5
c0de751c:	f2c0 0000 	movt	r0, #0
c0de7520:	4478      	add	r0, pc
c0de7522:	9005      	str	r0, [sp, #20]
            = "If you're not using the Ledger Wallet app, Transaction Check might not work. If "
c0de7524:	f642 5005 	movw	r0, #11525	@ 0x2d05
c0de7528:	f2c0 0000 	movt	r0, #0
c0de752c:	4478      	add	r0, pc
c0de752e:	e015      	b.n	c0de755c <displaySecurityReport+0x23a>
c0de7530:	ad01      	add	r5, sp, #4
        nbgl_contentCenter_t info = {0};
c0de7532:	4628      	mov	r0, r5
c0de7534:	2124      	movs	r1, #36	@ 0x24
c0de7536:	f001 fed5 	bl	c0de92e4 <__aeabi_memclr>
        info.icon                 = &LARGE_WARNING_ICON;
c0de753a:	f242 30ea 	movw	r0, #9194	@ 0x23ea
c0de753e:	f2c0 0000 	movt	r0, #0
c0de7542:	4478      	add	r0, pc
c0de7544:	9002      	str	r0, [sp, #8]
        info.title                = "This transaction cannot be Clear Signed";
c0de7546:	f642 700f 	movw	r0, #12047	@ 0x2f0f
c0de754a:	f2c0 0000 	movt	r0, #0
c0de754e:	4478      	add	r0, pc
c0de7550:	9005      	str	r0, [sp, #20]
            = "This transaction or message cannot be decoded fully. If you choose to sign, you "
c0de7552:	f642 6034 	movw	r0, #11828	@ 0x2e34
c0de7556:	f2c0 0000 	movt	r0, #0
c0de755a:	4478      	add	r0, pc
c0de755c:	9007      	str	r0, [sp, #28]
c0de755e:	4620      	mov	r0, r4
c0de7560:	4629      	mov	r1, r5
c0de7562:	f7fc f8ab 	bl	c0de36bc <nbgl_layoutAddContentCenter>
c0de7566:	2028      	movs	r0, #40	@ 0x28
c0de7568:	f8ad 002c 	strh.w	r0, [sp, #44]	@ 0x2c
c0de756c:	2000      	movs	r0, #0
c0de756e:	f88d 0041 	strb.w	r0, [sp, #65]	@ 0x41
    nbgl_layoutAddHeader(reviewWithWarnCtx.modalLayout, &headerDesc);
c0de7572:	eb09 0007 	add.w	r0, r9, r7
c0de7576:	f8d0 0084 	ldr.w	r0, [r0, #132]	@ 0x84
c0de757a:	a910      	add	r1, sp, #64	@ 0x40
c0de757c:	f7fc fe17 	bl	c0de41ae <nbgl_layoutAddHeader>
    if (footerDesc.emptySpace.height > 0) {
c0de7580:	f8bd 002c 	ldrh.w	r0, [sp, #44]	@ 0x2c
c0de7584:	b130      	cbz	r0, c0de7594 <displaySecurityReport+0x272>
        nbgl_layoutAddExtendedFooter(reviewWithWarnCtx.modalLayout, &footerDesc);
c0de7586:	eb09 0007 	add.w	r0, r9, r7
c0de758a:	f8d0 0084 	ldr.w	r0, [r0, #132]	@ 0x84
c0de758e:	a90a      	add	r1, sp, #40	@ 0x28
c0de7590:	f7fa f9d8 	bl	c0de1944 <nbgl_layoutAddExtendedFooter>
c0de7594:	eb09 0007 	add.w	r0, r9, r7
c0de7598:	f8d0 0084 	ldr.w	r0, [r0, #132]	@ 0x84
c0de759c:	f7fd fa57 	bl	c0de4a4e <nbgl_layoutDraw>
c0de75a0:	f000 fd7d 	bl	c0de809e <nbgl_refresh>
}
c0de75a4:	b01c      	add	sp, #112	@ 0x70
c0de75a6:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de75aa <modalLayoutTouchCallback>:
{
c0de75aa:	b570      	push	{r4, r5, r6, lr}
    if (token == DISMISS_QR_TOKEN) {
c0de75ac:	2818      	cmp	r0, #24
c0de75ae:	d00f      	beq.n	c0de75d0 <modalLayoutTouchCallback+0x26>
c0de75b0:	2817      	cmp	r0, #23
c0de75b2:	d01f      	beq.n	c0de75f4 <modalLayoutTouchCallback+0x4a>
c0de75b4:	2816      	cmp	r0, #22
c0de75b6:	d131      	bne.n	c0de761c <modalLayoutTouchCallback+0x72>
        nbgl_layoutRelease(addressConfirmationContext.modalLayout);
c0de75b8:	f240 6008 	movw	r0, #1544	@ 0x608
c0de75bc:	f2c0 0000 	movt	r0, #0
c0de75c0:	eb09 0400 	add.w	r4, r9, r0
c0de75c4:	6b20      	ldr	r0, [r4, #48]	@ 0x30
c0de75c6:	f7fd fa66 	bl	c0de4a96 <nbgl_layoutRelease>
c0de75ca:	2000      	movs	r0, #0
        addressConfirmationContext.modalLayout = NULL;
c0de75cc:	6320      	str	r0, [r4, #48]	@ 0x30
c0de75ce:	e067      	b.n	c0de76a0 <modalLayoutTouchCallback+0xf6>
        nbgl_layoutRelease(choiceWithDetailsCtx.modalLayout);
c0de75d0:	f240 4474 	movw	r4, #1140	@ 0x474
c0de75d4:	f2c0 0400 	movt	r4, #0
c0de75d8:	eb09 0504 	add.w	r5, r9, r4
c0de75dc:	6e68      	ldr	r0, [r5, #100]	@ 0x64
c0de75de:	f7fd fa5a 	bl	c0de4a96 <nbgl_layoutRelease>
        if (choiceWithDetailsCtx.level <= 1) {
c0de75e2:	f895 0068 	ldrb.w	r0, [r5, #104]	@ 0x68
c0de75e6:	2801      	cmp	r0, #1
c0de75e8:	d83a      	bhi.n	c0de7660 <modalLayoutTouchCallback+0xb6>
            choiceWithDetailsCtx.modalLayout = NULL;
c0de75ea:	eb09 0004 	add.w	r0, r9, r4
c0de75ee:	2100      	movs	r1, #0
c0de75f0:	6641      	str	r1, [r0, #100]	@ 0x64
c0de75f2:	e055      	b.n	c0de76a0 <modalLayoutTouchCallback+0xf6>
        nbgl_layoutRelease(reviewWithWarnCtx.modalLayout);
c0de75f4:	f240 4474 	movw	r4, #1140	@ 0x474
c0de75f8:	f2c0 0400 	movt	r4, #0
c0de75fc:	eb09 0504 	add.w	r5, r9, r4
c0de7600:	f8d5 0084 	ldr.w	r0, [r5, #132]	@ 0x84
c0de7604:	f7fd fa47 	bl	c0de4a96 <nbgl_layoutRelease>
        if (reviewWithWarnCtx.securityReportLevel <= 1) {
c0de7608:	f895 0088 	ldrb.w	r0, [r5, #136]	@ 0x88
c0de760c:	2801      	cmp	r0, #1
c0de760e:	d831      	bhi.n	c0de7674 <modalLayoutTouchCallback+0xca>
            reviewWithWarnCtx.modalLayout = NULL;
c0de7610:	eb09 0004 	add.w	r0, r9, r4
c0de7614:	2100      	movs	r1, #0
c0de7616:	f8c0 1084 	str.w	r1, [r0, #132]	@ 0x84
c0de761a:	e041      	b.n	c0de76a0 <modalLayoutTouchCallback+0xf6>
    else if ((token >= FIRST_WARN_BAR_TOKEN) && (token <= LAST_WARN_BAR_TOKEN)) {
c0de761c:	f1a0 041c 	sub.w	r4, r0, #28
c0de7620:	2c05      	cmp	r4, #5
c0de7622:	d832      	bhi.n	c0de768a <modalLayoutTouchCallback+0xe0>
        if (sharedContext.usage == SHARE_CTX_REVIEW_WITH_WARNING) {
c0de7624:	f240 4574 	movw	r5, #1140	@ 0x474
c0de7628:	f2c0 0500 	movt	r5, #0
c0de762c:	eb09 0005 	add.w	r0, r9, r5
c0de7630:	f890 008c 	ldrb.w	r0, [r0, #140]	@ 0x8c
c0de7634:	2802      	cmp	r0, #2
c0de7636:	d046      	beq.n	c0de76c6 <modalLayoutTouchCallback+0x11c>
c0de7638:	2801      	cmp	r0, #1
c0de763a:	d135      	bne.n	c0de76a8 <modalLayoutTouchCallback+0xfe>
            nbgl_layoutRelease(reviewWithWarnCtx.modalLayout);
c0de763c:	eb09 0605 	add.w	r6, r9, r5
c0de7640:	f8d6 0084 	ldr.w	r0, [r6, #132]	@ 0x84
c0de7644:	f7fd fa27 	bl	c0de4a96 <nbgl_layoutRelease>
c0de7648:	2102      	movs	r1, #2
            if (reviewWithWarnCtx.warning->predefinedSet) {
c0de764a:	6fb0      	ldr	r0, [r6, #120]	@ 0x78
            reviewWithWarnCtx.securityReportLevel = 2;
c0de764c:	f886 1088 	strb.w	r1, [r6, #136]	@ 0x88
            if (reviewWithWarnCtx.warning->predefinedSet) {
c0de7650:	6801      	ldr	r1, [r0, #0]
c0de7652:	2900      	cmp	r1, #0
c0de7654:	d051      	beq.n	c0de76fa <modalLayoutTouchCallback+0x150>
c0de7656:	2001      	movs	r0, #1
                displaySecurityReport(1 << (token - FIRST_WARN_BAR_TOKEN));
c0de7658:	40a0      	lsls	r0, r4
c0de765a:	f7ff fe62 	bl	c0de7322 <displaySecurityReport>
}
c0de765e:	bd70      	pop	{r4, r5, r6, pc}
            choiceWithDetailsCtx.level = 1;
c0de7660:	444c      	add	r4, r9
c0de7662:	2101      	movs	r1, #1
                = displayModalDetails(choiceWithDetailsCtx.details, DISMISS_DETAILS_TOKEN);
c0de7664:	6de0      	ldr	r0, [r4, #92]	@ 0x5c
            choiceWithDetailsCtx.level = 1;
c0de7666:	f884 1068 	strb.w	r1, [r4, #104]	@ 0x68
                = displayModalDetails(choiceWithDetailsCtx.details, DISMISS_DETAILS_TOKEN);
c0de766a:	2118      	movs	r1, #24
c0de766c:	f000 f85e 	bl	c0de772c <displayModalDetails>
c0de7670:	6660      	str	r0, [r4, #100]	@ 0x64
c0de7672:	e017      	b.n	c0de76a4 <modalLayoutTouchCallback+0xfa>
            reviewWithWarnCtx.securityReportLevel = 1;
c0de7674:	eb09 0004 	add.w	r0, r9, r4
c0de7678:	2201      	movs	r2, #1
            if (reviewWithWarnCtx.warning->predefinedSet) {
c0de767a:	6f81      	ldr	r1, [r0, #120]	@ 0x78
            reviewWithWarnCtx.securityReportLevel = 1;
c0de767c:	f880 2088 	strb.w	r2, [r0, #136]	@ 0x88
            if (reviewWithWarnCtx.warning->predefinedSet) {
c0de7680:	6808      	ldr	r0, [r1, #0]
c0de7682:	b190      	cbz	r0, c0de76aa <modalLayoutTouchCallback+0x100>
                displaySecurityReport(reviewWithWarnCtx.warning->predefinedSet);
c0de7684:	f7ff fe4d 	bl	c0de7322 <displaySecurityReport>
}
c0de7688:	bd70      	pop	{r4, r5, r6, pc}
        nbgl_layoutRelease(genericContext.modalLayout);
c0de768a:	f240 4074 	movw	r0, #1140	@ 0x474
c0de768e:	f2c0 0000 	movt	r0, #0
c0de7692:	eb09 0400 	add.w	r4, r9, r0
c0de7696:	6ae0      	ldr	r0, [r4, #44]	@ 0x2c
c0de7698:	f7fd f9fd 	bl	c0de4a96 <nbgl_layoutRelease>
c0de769c:	2000      	movs	r0, #0
        genericContext.modalLayout = NULL;
c0de769e:	62e0      	str	r0, [r4, #44]	@ 0x2c
c0de76a0:	f000 fd25 	bl	c0de80ee <nbgl_screenRedraw>
    nbgl_refresh();
c0de76a4:	f000 fcfb 	bl	c0de809e <nbgl_refresh>
}
c0de76a8:	bd70      	pop	{r4, r5, r6, pc}
                    = (reviewWithWarnCtx.isIntro) ? reviewWithWarnCtx.warning->introDetails
c0de76aa:	444c      	add	r4, r9
c0de76ac:	f894 0089 	ldrb.w	r0, [r4, #137]	@ 0x89
c0de76b0:	2214      	movs	r2, #20
c0de76b2:	2800      	cmp	r0, #0
c0de76b4:	bf08      	it	eq
c0de76b6:	2218      	moveq	r2, #24
c0de76b8:	5888      	ldr	r0, [r1, r2]
    reviewWithWarnCtx.modalLayout = displayModalDetails(details, DISMISS_WARNING_TOKEN);
c0de76ba:	2117      	movs	r1, #23
c0de76bc:	f000 f836 	bl	c0de772c <displayModalDetails>
c0de76c0:	f8c4 0084 	str.w	r0, [r4, #132]	@ 0x84
}
c0de76c4:	bd70      	pop	{r4, r5, r6, pc}
                = &choiceWithDetailsCtx.details->barList.details[token - FIRST_WARN_BAR_TOKEN];
c0de76c6:	eb09 0005 	add.w	r0, r9, r5
c0de76ca:	6dc0      	ldr	r0, [r0, #92]	@ 0x5c
c0de76cc:	212c      	movs	r1, #44	@ 0x2c
c0de76ce:	6980      	ldr	r0, [r0, #24]
c0de76d0:	fb04 f201 	mul.w	r2, r4, r1
            if (details->title != NO_TYPE_WARNING) {
c0de76d4:	5882      	ldr	r2, [r0, r2]
c0de76d6:	2a00      	cmp	r2, #0
}
c0de76d8:	bf08      	it	eq
c0de76da:	bd70      	popeq	{r4, r5, r6, pc}
                nbgl_layoutRelease(choiceWithDetailsCtx.modalLayout);
c0de76dc:	444d      	add	r5, r9
c0de76de:	fb04 0401 	mla	r4, r4, r1, r0
c0de76e2:	6e68      	ldr	r0, [r5, #100]	@ 0x64
c0de76e4:	f7fd f9d7 	bl	c0de4a96 <nbgl_layoutRelease>
c0de76e8:	2002      	movs	r0, #2
                choiceWithDetailsCtx.level = 2;
c0de76ea:	f885 0068 	strb.w	r0, [r5, #104]	@ 0x68
                    = displayModalDetails(details, DISMISS_DETAILS_TOKEN);
c0de76ee:	4620      	mov	r0, r4
c0de76f0:	2118      	movs	r1, #24
c0de76f2:	f000 f81b 	bl	c0de772c <displayModalDetails>
c0de76f6:	6668      	str	r0, [r5, #100]	@ 0x64
}
c0de76f8:	bd70      	pop	{r4, r5, r6, pc}
                    = (reviewWithWarnCtx.isIntro) ? reviewWithWarnCtx.warning->introDetails
c0de76fa:	eb09 0105 	add.w	r1, r9, r5
c0de76fe:	f891 1089 	ldrb.w	r1, [r1, #137]	@ 0x89
c0de7702:	2214      	movs	r2, #20
c0de7704:	2900      	cmp	r1, #0
c0de7706:	bf08      	it	eq
c0de7708:	2218      	moveq	r2, #24
c0de770a:	5880      	ldr	r0, [r0, r2]
                if (details->type == BAR_LIST_WARNING) {
c0de770c:	7901      	ldrb	r1, [r0, #4]
c0de770e:	2903      	cmp	r1, #3
c0de7710:	d1ca      	bne.n	c0de76a8 <modalLayoutTouchCallback+0xfe>
                        &details->barList.details[token - FIRST_WARN_BAR_TOKEN]);
c0de7712:	6980      	ldr	r0, [r0, #24]
c0de7714:	212c      	movs	r1, #44	@ 0x2c
c0de7716:	fb04 0001 	mla	r0, r4, r1, r0
    reviewWithWarnCtx.modalLayout = displayModalDetails(details, DISMISS_WARNING_TOKEN);
c0de771a:	2117      	movs	r1, #23
c0de771c:	f000 f806 	bl	c0de772c <displayModalDetails>
c0de7720:	eb09 0105 	add.w	r1, r9, r5
c0de7724:	f8c1 0084 	str.w	r0, [r1, #132]	@ 0x84
}
c0de7728:	bd70      	pop	{r4, r5, r6, pc}
	...

c0de772c <displayModalDetails>:
{
c0de772c:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de7730:	b092      	sub	sp, #72	@ 0x48
    nbgl_layoutDescription_t layoutDescription = {.modal            = true,
c0de7732:	f243 13ba 	movw	r3, #12730	@ 0x31ba
c0de7736:	f2c0 0300 	movt	r3, #0
c0de773a:	447b      	add	r3, pc
c0de773c:	f10d 0c2c 	add.w	ip, sp, #44	@ 0x2c
c0de7740:	cb70      	ldmia	r3!, {r4, r5, r6}
c0de7742:	4662      	mov	r2, ip
c0de7744:	c270      	stmia	r2!, {r4, r5, r6}
c0de7746:	4604      	mov	r4, r0
c0de7748:	e893 00e1 	ldmia.w	r3, {r0, r5, r6, r7}
c0de774c:	c2e1      	stmia	r2!, {r0, r5, r6, r7}
c0de774e:	2600      	movs	r6, #0
c0de7750:	f240 1001 	movw	r0, #257	@ 0x101
    nbgl_layoutHeader_t      headerDesc        = {.type               = HEADER_BACK_AND_TEXT,
c0de7754:	e9cd 6606 	strd	r6, r6, [sp, #24]
c0de7758:	f8ad 0018 	strh.w	r0, [sp, #24]
c0de775c:	2009      	movs	r0, #9
c0de775e:	960a      	str	r6, [sp, #40]	@ 0x28
c0de7760:	e9cd 6608 	strd	r6, r6, [sp, #32]
                                                  .backAndText.icon   = NULL,
c0de7764:	f88d 0025 	strb.w	r0, [sp, #37]	@ 0x25
    layout                      = nbgl_layoutGet(&layoutDescription);
c0de7768:	4660      	mov	r0, ip
                                                  .backAndText.icon   = NULL,
c0de776a:	f88d 1024 	strb.w	r1, [sp, #36]	@ 0x24
    layout                      = nbgl_layoutGet(&layoutDescription);
c0de776e:	f7f9 f8a9 	bl	c0de08c4 <nbgl_layoutGet>
    headerDesc.backAndText.text = details->title;
c0de7772:	6821      	ldr	r1, [r4, #0]
    layout                      = nbgl_layoutGet(&layoutDescription);
c0de7774:	4605      	mov	r5, r0
    headerDesc.backAndText.text = details->title;
c0de7776:	9108      	str	r1, [sp, #32]
c0de7778:	a906      	add	r1, sp, #24
    nbgl_layoutAddHeader(layout, &headerDesc);
c0de777a:	f7fc fd18 	bl	c0de41ae <nbgl_layoutAddHeader>
    if (details->type == BAR_LIST_WARNING) {
c0de777e:	7920      	ldrb	r0, [r4, #4]
c0de7780:	2801      	cmp	r0, #1
c0de7782:	d041      	beq.n	c0de7808 <displayModalDetails+0xdc>
c0de7784:	2802      	cmp	r0, #2
c0de7786:	d047      	beq.n	c0de7818 <displayModalDetails+0xec>
c0de7788:	2803      	cmp	r0, #3
c0de778a:	d14c      	bne.n	c0de7826 <displayModalDetails+0xfa>
        for (i = 0; i < details->barList.nbBars; i++) {
c0de778c:	7a20      	ldrb	r0, [r4, #8]
c0de778e:	2800      	cmp	r0, #0
c0de7790:	d049      	beq.n	c0de7826 <displayModalDetails+0xfa>
c0de7792:	2700      	movs	r7, #0
c0de7794:	f06f 0627 	mvn.w	r6, #39	@ 0x27
c0de7798:	f04f 0b09 	mov.w	fp, #9
c0de779c:	46e8      	mov	r8, sp
c0de779e:	f04f 0a00 	mov.w	sl, #0
c0de77a2:	bf00      	nop
            bar.text    = details->barList.texts[i];
c0de77a4:	68e0      	ldr	r0, [r4, #12]
            bar.subText = details->barList.subTexts[i];
c0de77a6:	6921      	ldr	r1, [r4, #16]
            bar.text    = details->barList.texts[i];
c0de77a8:	f850 002a 	ldr.w	r0, [r0, sl, lsl #2]
c0de77ac:	9001      	str	r0, [sp, #4]
            bar.subText = details->barList.subTexts[i];
c0de77ae:	f851 002a 	ldr.w	r0, [r1, sl, lsl #2]
                = (details->barList.details[i].type != NO_TYPE_WARNING) ? &PUSH_ICON : NULL;
c0de77b2:	69a1      	ldr	r1, [r4, #24]
            bar.subText = details->barList.subTexts[i];
c0de77b4:	9003      	str	r0, [sp, #12]
                = (details->barList.details[i].type != NO_TYPE_WARNING) ? &PUSH_ICON : NULL;
c0de77b6:	1988      	adds	r0, r1, r6
c0de77b8:	f890 002c 	ldrb.w	r0, [r0, #44]	@ 0x2c
            bar.iconLeft = details->barList.icons[i];
c0de77bc:	6961      	ldr	r1, [r4, #20]
                = (details->barList.details[i].type != NO_TYPE_WARNING) ? &PUSH_ICON : NULL;
c0de77be:	f242 22d6 	movw	r2, #8918	@ 0x22d6
c0de77c2:	f2c0 0200 	movt	r2, #0
c0de77c6:	2800      	cmp	r0, #0
c0de77c8:	447a      	add	r2, pc
c0de77ca:	bf18      	it	ne
c0de77cc:	4610      	movne	r0, r2
c0de77ce:	9002      	str	r0, [sp, #8]
            bar.iconLeft = details->barList.icons[i];
c0de77d0:	f851 002a 	ldr.w	r0, [r1, sl, lsl #2]
            nbgl_layoutAddTouchableBar(layout, &bar);
c0de77d4:	4641      	mov	r1, r8
            bar.iconLeft = details->barList.icons[i];
c0de77d6:	9000      	str	r0, [sp, #0]
            bar.token    = FIRST_WARN_BAR_TOKEN + i;
c0de77d8:	f10a 001c 	add.w	r0, sl, #28
c0de77dc:	f88d 0011 	strb.w	r0, [sp, #17]
            nbgl_layoutAddTouchableBar(layout, &bar);
c0de77e0:	4628      	mov	r0, r5
            bar.tuneId   = TUNE_TAP_CASUAL;
c0de77e2:	f88d b014 	strb.w	fp, [sp, #20]
            bar.large    = false;
c0de77e6:	f88d 7010 	strb.w	r7, [sp, #16]
            bar.inactive = false;
c0de77ea:	f88d 7012 	strb.w	r7, [sp, #18]
            nbgl_layoutAddTouchableBar(layout, &bar);
c0de77ee:	f7fa fe37 	bl	c0de2460 <nbgl_layoutAddTouchableBar>
            nbgl_layoutAddSeparationLine(layout);
c0de77f2:	4628      	mov	r0, r5
c0de77f4:	f7fc fb45 	bl	c0de3e82 <nbgl_layoutAddSeparationLine>
        for (i = 0; i < details->barList.nbBars; i++) {
c0de77f8:	7a20      	ldrb	r0, [r4, #8]
c0de77fa:	f10a 0a01 	add.w	sl, sl, #1
c0de77fe:	4582      	cmp	sl, r0
c0de7800:	f106 062c 	add.w	r6, r6, #44	@ 0x2c
c0de7804:	d3ce      	bcc.n	c0de77a4 <displayModalDetails+0x78>
c0de7806:	e00e      	b.n	c0de7826 <displayModalDetails+0xfa>
        nbgl_layoutAddContentCenter(layout, &details->centeredInfo);
c0de7808:	f104 0108 	add.w	r1, r4, #8
c0de780c:	4628      	mov	r0, r5
c0de780e:	f7fb ff55 	bl	c0de36bc <nbgl_layoutAddContentCenter>
        headerDesc.separationLine = false;
c0de7812:	f88d 6019 	strb.w	r6, [sp, #25]
c0de7816:	e006      	b.n	c0de7826 <displayModalDetails+0xfa>
        nbgl_layoutAddQRCode(layout, &details->qrCode);
c0de7818:	f104 0108 	add.w	r1, r4, #8
c0de781c:	4628      	mov	r0, r5
c0de781e:	f7fb ff5a 	bl	c0de36d6 <nbgl_layoutAddQRCode>
        headerDesc.backAndText.text = details->title;
c0de7822:	6820      	ldr	r0, [r4, #0]
c0de7824:	9008      	str	r0, [sp, #32]
    nbgl_layoutDraw(layout);
c0de7826:	4628      	mov	r0, r5
c0de7828:	f7fd f911 	bl	c0de4a4e <nbgl_layoutDraw>
    nbgl_refresh();
c0de782c:	f000 fc37 	bl	c0de809e <nbgl_refresh>
    return layout;
c0de7830:	4628      	mov	r0, r5
c0de7832:	b012      	add	sp, #72	@ 0x48
c0de7834:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de7838 <displayDetailsPage>:
{
c0de7838:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de783c:	b09a      	sub	sp, #104	@ 0x68
                                            .nbPages                   = detailsContext.nbPages,
c0de783e:	f240 7ac4 	movw	sl, #1988	@ 0x7c4
c0de7842:	f2c0 0a00 	movt	sl, #0
c0de7846:	4604      	mov	r4, r0
    nbgl_pageNavigationInfo_t    info    = {.activePage                = detailsPage,
c0de7848:	f88d 0048 	strb.w	r0, [sp, #72]	@ 0x48
                                            .nbPages                   = detailsContext.nbPages,
c0de784c:	f819 000a 	ldrb.w	r0, [r9, sl]
c0de7850:	4688      	mov	r8, r1
    nbgl_pageNavigationInfo_t    info    = {.activePage                = detailsPage,
c0de7852:	f88d 0049 	strb.w	r0, [sp, #73]	@ 0x49
c0de7856:	f44f 7081 	mov.w	r0, #258	@ 0x102
c0de785a:	f8ad 004a 	strh.w	r0, [sp, #74]	@ 0x4a
c0de785e:	f44f 6010 	mov.w	r0, #2304	@ 0x900
c0de7862:	f240 1101 	movw	r1, #257	@ 0x101
c0de7866:	f8ad 004c 	strh.w	r0, [sp, #76]	@ 0x4c
c0de786a:	2000      	movs	r0, #0
c0de786c:	f2c0 3100 	movt	r1, #768	@ 0x300
c0de7870:	9014      	str	r0, [sp, #80]	@ 0x50
c0de7872:	f88d 0054 	strb.w	r0, [sp, #84]	@ 0x54
                                            .navWithButtons.navToken   = NAV_TOKEN,
c0de7876:	e9cd 1016 	strd	r1, r0, [sp, #88]	@ 0x58
c0de787a:	a802      	add	r0, sp, #8
    nbgl_pageContent_t           content = {.type                           = TAG_VALUE_LIST,
c0de787c:	2140      	movs	r1, #64	@ 0x40
                                            .nbPages                   = detailsContext.nbPages,
c0de787e:	eb09 050a 	add.w	r5, r9, sl
    nbgl_pageContent_t           content = {.type                           = TAG_VALUE_LIST,
c0de7882:	f001 fd2f 	bl	c0de92e4 <__aeabi_memclr>
                                            .tagValueList.nbPairs           = 1,
c0de7886:	f240 7bd4 	movw	fp, #2004	@ 0x7d4
c0de788a:	2004      	movs	r0, #4
c0de788c:	f2c0 0b00 	movt	fp, #0
    nbgl_pageContent_t           content = {.type                           = TAG_VALUE_LIST,
c0de7890:	f88d 0014 	strb.w	r0, [sp, #20]
                                            .tagValueList.nbPairs           = 1,
c0de7894:	eb09 000b 	add.w	r0, r9, fp
c0de7898:	9006      	str	r0, [sp, #24]
c0de789a:	2001      	movs	r0, #1
c0de789c:	f88d 0020 	strb.w	r0, [sp, #32]
c0de78a0:	f88d 0025 	strb.w	r0, [sp, #37]	@ 0x25
    if (modalPageContext != NULL) {
c0de78a4:	f240 50e0 	movw	r0, #1504	@ 0x5e0
c0de78a8:	f2c0 0000 	movt	r0, #0
c0de78ac:	f859 0000 	ldr.w	r0, [r9, r0]
                                            .tagValueList.wrapping = detailsContext.wrapping};
c0de78b0:	78e9      	ldrb	r1, [r5, #3]
    if (modalPageContext != NULL) {
c0de78b2:	2800      	cmp	r0, #0
                                            .tagValueList.nbPairs           = 1,
c0de78b4:	f88d 1026 	strb.w	r1, [sp, #38]	@ 0x26
        nbgl_pageRelease(modalPageContext);
c0de78b8:	bf18      	it	ne
c0de78ba:	f7fd ffcc 	blne	c0de5856 <nbgl_pageRelease>
    currentPair.item = detailsContext.tag;
c0de78be:	eb09 000a 	add.w	r0, r9, sl
    if (detailsPage <= detailsContext.currentPage) {
c0de78c2:	7841      	ldrb	r1, [r0, #1]
    currentPair.item = detailsContext.tag;
c0de78c4:	6840      	ldr	r0, [r0, #4]
    if (detailsPage <= detailsContext.currentPage) {
c0de78c6:	42a1      	cmp	r1, r4
    currentPair.item = detailsContext.tag;
c0de78c8:	f849 000b 	str.w	r0, [r9, fp]
        currentPair.value = detailsContext.nextPageStart;
c0de78cc:	eb09 000a 	add.w	r0, r9, sl
    if (detailsPage <= detailsContext.currentPage) {
c0de78d0:	d206      	bcs.n	c0de78e0 <displayDetailsPage+0xa8>
        currentPair.value = detailsContext.nextPageStart;
c0de78d2:	68c6      	ldr	r6, [r0, #12]
c0de78d4:	2501      	movs	r5, #1
c0de78d6:	f1b8 0f00 	cmp.w	r8, #0
c0de78da:	bf18      	it	ne
c0de78dc:	2502      	movne	r5, #2
c0de78de:	e031      	b.n	c0de7944 <displayDetailsPage+0x10c>
    const char *currentChar = detailsContext.value;
c0de78e0:	6886      	ldr	r6, [r0, #8]
    while (page < detailsPage) {
c0de78e2:	b374      	cbz	r4, c0de7942 <displayDetailsPage+0x10a>
c0de78e4:	2500      	movs	r5, #0
c0de78e6:	f10d 0866 	add.w	r8, sp, #102	@ 0x66
c0de78ea:	e008      	b.n	c0de78fe <displayDetailsPage+0xc6>
                len++;
c0de78ec:	3001      	adds	r0, #1
c0de78ee:	f8ad 0066 	strh.w	r0, [sp, #102]	@ 0x66
            currentChar = currentChar + len;
c0de78f2:	f8bd 0066 	ldrh.w	r0, [sp, #102]	@ 0x66
c0de78f6:	4406      	add	r6, r0
        page++;
c0de78f8:	3501      	adds	r5, #1
    while (page < detailsPage) {
c0de78fa:	42a5      	cmp	r5, r4
c0de78fc:	d221      	bcs.n	c0de7942 <displayDetailsPage+0x10a>
            = nbgl_getTextNbLinesInWidth(SMALL_BOLD_FONT, currentChar, AVAILABLE_WIDTH, false);
c0de78fe:	200c      	movs	r0, #12
c0de7900:	4631      	mov	r1, r6
c0de7902:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de7906:	2300      	movs	r3, #0
c0de7908:	f000 fc23 	bl	c0de8152 <nbgl_getTextNbLinesInWidth>
        if (nbLines > NB_MAX_LINES_IN_DETAILS) {
c0de790c:	280c      	cmp	r0, #12
c0de790e:	d3f3      	bcc.n	c0de78f8 <displayDetailsPage+0xc0>
                                        detailsContext.wrapping);
c0de7910:	eb09 000a 	add.w	r0, r9, sl
c0de7914:	78c7      	ldrb	r7, [r0, #3]
            nbgl_getTextMaxLenInNbLines(SMALL_BOLD_FONT,
c0de7916:	200c      	movs	r0, #12
c0de7918:	4631      	mov	r1, r6
c0de791a:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de791e:	230b      	movs	r3, #11
c0de7920:	f8cd 8000 	str.w	r8, [sp]
c0de7924:	9701      	str	r7, [sp, #4]
c0de7926:	f000 fc1e 	bl	c0de8166 <nbgl_getTextMaxLenInNbLines>
            if (currentChar[len] == '\n') {
c0de792a:	f8bd 0066 	ldrh.w	r0, [sp, #102]	@ 0x66
c0de792e:	5c31      	ldrb	r1, [r6, r0]
c0de7930:	290a      	cmp	r1, #10
c0de7932:	d0db      	beq.n	c0de78ec <displayDetailsPage+0xb4>
            else if (detailsContext.wrapping == false) {
c0de7934:	eb09 010a 	add.w	r1, r9, sl
c0de7938:	78c9      	ldrb	r1, [r1, #3]
c0de793a:	2900      	cmp	r1, #0
c0de793c:	d1d9      	bne.n	c0de78f2 <displayDetailsPage+0xba>
                len -= 3;
c0de793e:	3803      	subs	r0, #3
c0de7940:	e7d5      	b.n	c0de78ee <displayDetailsPage+0xb6>
c0de7942:	2502      	movs	r5, #2
c0de7944:	eb09 000b 	add.w	r0, r9, fp
c0de7948:	6046      	str	r6, [r0, #4]
    detailsContext.currentPage = detailsPage;
c0de794a:	eb09 000a 	add.w	r0, r9, sl
        SMALL_BOLD_FONT, currentPair.value, AVAILABLE_WIDTH, detailsContext.wrapping);
c0de794e:	78c3      	ldrb	r3, [r0, #3]
    detailsContext.currentPage = detailsPage;
c0de7950:	7044      	strb	r4, [r0, #1]
    uint16_t nbLines           = nbgl_getTextNbLinesInWidth(
c0de7952:	200c      	movs	r0, #12
c0de7954:	4631      	mov	r1, r6
c0de7956:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de795a:	f000 fbfa 	bl	c0de8152 <nbgl_getTextNbLinesInWidth>
    if (nbLines > NB_MAX_LINES_IN_DETAILS) {
c0de795e:	280c      	cmp	r0, #12
c0de7960:	d320      	bcc.n	c0de79a4 <displayDetailsPage+0x16c>
                                    currentPair.value,
c0de7962:	eb09 040b 	add.w	r4, r9, fp
                                    detailsContext.wrapping);
c0de7966:	eb09 000a 	add.w	r0, r9, sl
                                    currentPair.value,
c0de796a:	6861      	ldr	r1, [r4, #4]
                                    detailsContext.wrapping);
c0de796c:	78c7      	ldrb	r7, [r0, #3]
c0de796e:	f10d 0066 	add.w	r0, sp, #102	@ 0x66
        nbgl_getTextMaxLenInNbLines(SMALL_BOLD_FONT,
c0de7972:	9000      	str	r0, [sp, #0]
c0de7974:	200c      	movs	r0, #12
c0de7976:	f44f 72d0 	mov.w	r2, #416	@ 0x1a0
c0de797a:	230b      	movs	r3, #11
c0de797c:	9701      	str	r7, [sp, #4]
c0de797e:	f000 fbf2 	bl	c0de8166 <nbgl_getTextMaxLenInNbLines>
c0de7982:	2200      	movs	r2, #0
        if (currentPair.value[len] == '\n') {
c0de7984:	6860      	ldr	r0, [r4, #4]
c0de7986:	f8bd 1066 	ldrh.w	r1, [sp, #102]	@ 0x66
        content.tagValueDetails.tagValueList.hideEndOfLastLine = false;
c0de798a:	f88d 2022 	strb.w	r2, [sp, #34]	@ 0x22
        if (currentPair.value[len] == '\n') {
c0de798e:	5c42      	ldrb	r2, [r0, r1]
c0de7990:	2a0a      	cmp	r2, #10
c0de7992:	d112      	bne.n	c0de79ba <displayDetailsPage+0x182>
            len++;
c0de7994:	3101      	adds	r1, #1
c0de7996:	f240 54e0 	movw	r4, #1504	@ 0x5e0
c0de799a:	f8ad 1066 	strh.w	r1, [sp, #102]	@ 0x66
c0de799e:	f2c0 0400 	movt	r4, #0
c0de79a2:	e018      	b.n	c0de79d6 <displayDetailsPage+0x19e>
c0de79a4:	f240 54e0 	movw	r4, #1504	@ 0x5e0
        detailsContext.nextPageStart            = NULL;
c0de79a8:	eb09 000a 	add.w	r0, r9, sl
c0de79ac:	2100      	movs	r1, #0
c0de79ae:	f2c0 0400 	movt	r4, #0
c0de79b2:	60c1      	str	r1, [r0, #12]
        content.tagValueList.nbMaxLinesForValue = 0;
c0de79b4:	f88d 1023 	strb.w	r1, [sp, #35]	@ 0x23
c0de79b8:	e016      	b.n	c0de79e8 <displayDetailsPage+0x1b0>
        else if (!detailsContext.wrapping) {
c0de79ba:	eb09 020a 	add.w	r2, r9, sl
c0de79be:	78d2      	ldrb	r2, [r2, #3]
c0de79c0:	f240 54e0 	movw	r4, #1504	@ 0x5e0
c0de79c4:	f2c0 0400 	movt	r4, #0
c0de79c8:	b92a      	cbnz	r2, c0de79d6 <displayDetailsPage+0x19e>
c0de79ca:	2201      	movs	r2, #1
            len -= 3;
c0de79cc:	3903      	subs	r1, #3
            content.tagValueDetails.tagValueList.hideEndOfLastLine = true;
c0de79ce:	f88d 2022 	strb.w	r2, [sp, #34]	@ 0x22
            len -= 3;
c0de79d2:	f8ad 1066 	strh.w	r1, [sp, #102]	@ 0x66
        detailsContext.nextPageStart = currentPair.value + len;
c0de79d6:	f8bd 1066 	ldrh.w	r1, [sp, #102]	@ 0x66
c0de79da:	4408      	add	r0, r1
c0de79dc:	eb09 010a 	add.w	r1, r9, sl
c0de79e0:	60c8      	str	r0, [r1, #12]
c0de79e2:	200b      	movs	r0, #11
        content.tagValueList.nbMaxLinesForValue = NB_MAX_LINES_IN_DETAILS;
c0de79e4:	f88d 0023 	strb.w	r0, [sp, #35]	@ 0x23
    if (info.nbPages == 1) {
c0de79e8:	f89d 0049 	ldrb.w	r0, [sp, #73]	@ 0x49
c0de79ec:	2801      	cmp	r0, #1
c0de79ee:	d105      	bne.n	c0de79fc <displayDetailsPage+0x1c4>
        info.navWithButtons.quitText = "Close";
c0de79f0:	f642 1077 	movw	r0, #10615	@ 0x2977
c0de79f4:	f2c0 0000 	movt	r0, #0
c0de79f8:	4478      	add	r0, pc
c0de79fa:	9017      	str	r0, [sp, #92]	@ 0x5c
    modalPageContext = nbgl_pageDrawGenericContentExt(&pageModalCallback, &info, &content, true);
c0de79fc:	f24f 20dd 	movw	r0, #62173	@ 0xf2dd
c0de7a00:	f6cf 70ff 	movt	r0, #65535	@ 0xffff
c0de7a04:	4478      	add	r0, pc
c0de7a06:	a912      	add	r1, sp, #72	@ 0x48
c0de7a08:	aa02      	add	r2, sp, #8
c0de7a0a:	2301      	movs	r3, #1
c0de7a0c:	f7fd fc80 	bl	c0de5310 <nbgl_pageDrawGenericContentExt>
c0de7a10:	f849 0004 	str.w	r0, [r9, r4]
c0de7a14:	4628      	mov	r0, r5
c0de7a16:	f000 fb47 	bl	c0de80a8 <nbgl_refreshSpecial>
}
c0de7a1a:	b01a      	add	sp, #104	@ 0x68
c0de7a1c:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de7a20 <displayTagValueListModalPage>:
{
c0de7a20:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
c0de7a24:	b098      	sub	sp, #96	@ 0x60
c0de7a26:	4605      	mov	r5, r0
    nbgl_pageNavigationInfo_t info    = {.activePage                = pageIdx,
c0de7a28:	f88d 0044 	strb.w	r0, [sp, #68]	@ 0x44
                                         .nbPages                   = detailsContext.nbPages,
c0de7a2c:	f240 77c4 	movw	r7, #1988	@ 0x7c4
c0de7a30:	f44f 7081 	mov.w	r0, #258	@ 0x102
c0de7a34:	4688      	mov	r8, r1
c0de7a36:	f2c0 0700 	movt	r7, #0
    nbgl_pageNavigationInfo_t info    = {.activePage                = pageIdx,
c0de7a3a:	f8ad 0046 	strh.w	r0, [sp, #70]	@ 0x46
c0de7a3e:	f44f 6010 	mov.w	r0, #2304	@ 0x900
c0de7a42:	f240 1101 	movw	r1, #257	@ 0x101
                                         .nbPages                   = detailsContext.nbPages,
c0de7a46:	f819 6007 	ldrb.w	r6, [r9, r7]
    nbgl_pageNavigationInfo_t info    = {.activePage                = pageIdx,
c0de7a4a:	f8ad 0048 	strh.w	r0, [sp, #72]	@ 0x48
c0de7a4e:	2000      	movs	r0, #0
c0de7a50:	f2c0 4100 	movt	r1, #1024	@ 0x400
c0de7a54:	9013      	str	r0, [sp, #76]	@ 0x4c
c0de7a56:	f88d 0050 	strb.w	r0, [sp, #80]	@ 0x50
                                         .navWithButtons.navToken   = MODAL_NAV_TOKEN,
c0de7a5a:	e9cd 1015 	strd	r1, r0, [sp, #84]	@ 0x54
c0de7a5e:	a801      	add	r0, sp, #4
    nbgl_pageContent_t        content = {.type                           = TAG_VALUE_LIST,
c0de7a60:	2140      	movs	r1, #64	@ 0x40
                                         .nbPages                   = detailsContext.nbPages,
c0de7a62:	eb09 0407 	add.w	r4, r9, r7
    nbgl_pageNavigationInfo_t info    = {.activePage                = pageIdx,
c0de7a66:	f88d 6045 	strb.w	r6, [sp, #69]	@ 0x45
    nbgl_pageContent_t        content = {.type                           = TAG_VALUE_LIST,
c0de7a6a:	f001 fc3b 	bl	c0de92e4 <__aeabi_memclr>
c0de7a6e:	2101      	movs	r1, #1
                                         .tagValueList.smallCaseForValue = true,
c0de7a70:	f88d 1021 	strb.w	r1, [sp, #33]	@ 0x21
    if (detailsContext.currentPage <= pageIdx) {
c0de7a74:	7861      	ldrb	r1, [r4, #1]
                                         .tagValueList.wrapping          = detailsContext.wrapping};
c0de7a76:	78e2      	ldrb	r2, [r4, #3]
c0de7a78:	2004      	movs	r0, #4
    if (detailsContext.currentPage <= pageIdx) {
c0de7a7a:	42a9      	cmp	r1, r5
    nbgl_pageContent_t        content = {.type                           = TAG_VALUE_LIST,
c0de7a7c:	f88d 0010 	strb.w	r0, [sp, #16]
                                         .tagValueList.smallCaseForValue = true,
c0de7a80:	f88d 2022 	strb.w	r2, [sp, #34]	@ 0x22
    if (detailsContext.currentPage <= pageIdx) {
c0de7a84:	d91d      	bls.n	c0de7ac2 <displayTagValueListModalPage+0xa2>
        modalContextGetPageInfo(pageIdx + 1, &nbElementsInPage);
c0de7a86:	1c69      	adds	r1, r5, #1
    uint8_t pageData = modalContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de7a88:	f240 73e4 	movw	r3, #2020	@ 0x7e4
c0de7a8c:	b2ca      	uxtb	r2, r1
c0de7a8e:	f2c0 0300 	movt	r3, #0
c0de7a92:	0852      	lsrs	r2, r2, #1
c0de7a94:	444b      	add	r3, r9
c0de7a96:	5c9a      	ldrb	r2, [r3, r2]
                       >> ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de7a98:	ea00 0181 	and.w	r1, r0, r1, lsl #2
c0de7a9c:	fa22 f101 	lsr.w	r1, r2, r1
        detailsContext.currentPairIdx -= nbElementsInPage;
c0de7aa0:	eb09 0207 	add.w	r2, r9, r7
c0de7aa4:	7894      	ldrb	r4, [r2, #2]
        *nbElements = GET_PAGE_NB_ELEMENTS(pageData);
c0de7aa6:	f001 0107 	and.w	r1, r1, #7
        detailsContext.currentPairIdx -= nbElementsInPage;
c0de7aaa:	1a61      	subs	r1, r4, r1
    uint8_t pageData = modalContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de7aac:	086c      	lsrs	r4, r5, #1
c0de7aae:	5d1b      	ldrb	r3, [r3, r4]
                       >> ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de7ab0:	ea00 0085 	and.w	r0, r0, r5, lsl #2
c0de7ab4:	fa23 f000 	lsr.w	r0, r3, r0
        *nbElements = GET_PAGE_NB_ELEMENTS(pageData);
c0de7ab8:	f000 0007 	and.w	r0, r0, #7
        detailsContext.currentPairIdx -= nbElementsInPage;
c0de7abc:	1a09      	subs	r1, r1, r0
c0de7abe:	7091      	strb	r1, [r2, #2]
c0de7ac0:	e00c      	b.n	c0de7adc <displayTagValueListModalPage+0xbc>
    uint8_t pageData = modalContextPagesInfo[pageIdx / PAGES_PER_UINT8]
c0de7ac2:	f240 72e4 	movw	r2, #2020	@ 0x7e4
c0de7ac6:	f2c0 0200 	movt	r2, #0
c0de7aca:	0869      	lsrs	r1, r5, #1
c0de7acc:	444a      	add	r2, r9
c0de7ace:	5c51      	ldrb	r1, [r2, r1]
                       >> ((pageIdx % PAGES_PER_UINT8) * PAGE_DATA_BITS);
c0de7ad0:	ea00 0085 	and.w	r0, r0, r5, lsl #2
c0de7ad4:	fa21 f000 	lsr.w	r0, r1, r0
        *nbElements = GET_PAGE_NB_ELEMENTS(pageData);
c0de7ad8:	f000 0007 	and.w	r0, r0, #7
        = &genericContext.currentTagValues->pairs[detailsContext.currentPairIdx];
c0de7adc:	f240 4274 	movw	r2, #1140	@ 0x474
c0de7ae0:	f2c0 0200 	movt	r2, #0
c0de7ae4:	444a      	add	r2, r9
    detailsContext.currentPage = pageIdx;
c0de7ae6:	eb09 0107 	add.w	r1, r9, r7
        = &genericContext.currentTagValues->pairs[detailsContext.currentPairIdx];
c0de7aea:	6b92      	ldr	r2, [r2, #56]	@ 0x38
    detailsContext.currentPage = pageIdx;
c0de7aec:	704d      	strb	r5, [r1, #1]
        = &genericContext.currentTagValues->pairs[detailsContext.currentPairIdx];
c0de7aee:	6812      	ldr	r2, [r2, #0]
c0de7af0:	788b      	ldrb	r3, [r1, #2]
    content.tagValueList.nbPairs = nbElementsInPage;
c0de7af2:	f88d 001c 	strb.w	r0, [sp, #28]
        = &genericContext.currentTagValues->pairs[detailsContext.currentPairIdx];
c0de7af6:	eb02 1203 	add.w	r2, r2, r3, lsl #4
    detailsContext.currentPairIdx += nbElementsInPage;
c0de7afa:	4418      	add	r0, r3
    if (info.nbPages == 1) {
c0de7afc:	2e01      	cmp	r6, #1
        = &genericContext.currentTagValues->pairs[detailsContext.currentPairIdx];
c0de7afe:	9205      	str	r2, [sp, #20]
    detailsContext.currentPairIdx += nbElementsInPage;
c0de7b00:	7088      	strb	r0, [r1, #2]
    if (info.nbPages == 1) {
c0de7b02:	d105      	bne.n	c0de7b10 <displayTagValueListModalPage+0xf0>
        info.navWithButtons.quitText = "Close";
c0de7b04:	f642 0063 	movw	r0, #10339	@ 0x2863
c0de7b08:	f2c0 0000 	movt	r0, #0
c0de7b0c:	4478      	add	r0, pc
c0de7b0e:	9016      	str	r0, [sp, #88]	@ 0x58
    if (modalPageContext != NULL) {
c0de7b10:	f240 56e0 	movw	r6, #1504	@ 0x5e0
c0de7b14:	f2c0 0600 	movt	r6, #0
c0de7b18:	f859 0006 	ldr.w	r0, [r9, r6]
c0de7b1c:	2800      	cmp	r0, #0
        nbgl_pageRelease(modalPageContext);
c0de7b1e:	bf18      	it	ne
c0de7b20:	f7fd fe99 	blne	c0de5856 <nbgl_pageRelease>
    modalPageContext = nbgl_pageDrawGenericContentExt(&pageModalCallback, &info, &content, true);
c0de7b24:	f24f 10b5 	movw	r0, #61877	@ 0xf1b5
c0de7b28:	f6cf 70ff 	movt	r0, #65535	@ 0xffff
c0de7b2c:	4478      	add	r0, pc
c0de7b2e:	a911      	add	r1, sp, #68	@ 0x44
c0de7b30:	aa01      	add	r2, sp, #4
c0de7b32:	2301      	movs	r3, #1
c0de7b34:	2501      	movs	r5, #1
c0de7b36:	f7fd fbeb 	bl	c0de5310 <nbgl_pageDrawGenericContentExt>
c0de7b3a:	f849 0006 	str.w	r0, [r9, r6]
c0de7b3e:	f1b8 0f00 	cmp.w	r8, #0
c0de7b42:	bf18      	it	ne
c0de7b44:	2502      	movne	r5, #2
c0de7b46:	4628      	mov	r0, r5
c0de7b48:	f000 faae 	bl	c0de80a8 <nbgl_refreshSpecial>
}
c0de7b4c:	b018      	add	sp, #96	@ 0x60
c0de7b4e:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}

c0de7b52 <buffer_copy>:

    return true;
}

bool buffer_copy(const buffer_t *buffer, uint8_t *out, size_t out_len)
{
c0de7b52:	b5b0      	push	{r4, r5, r7, lr}
    if (buffer->size - buffer->offset > out_len) {
c0de7b54:	e9d0 5301 	ldrd	r5, r3, [r0, #4]
c0de7b58:	4614      	mov	r4, r2
c0de7b5a:	1aed      	subs	r5, r5, r3
c0de7b5c:	4295      	cmp	r5, r2
c0de7b5e:	d806      	bhi.n	c0de7b6e <buffer_copy+0x1c>
        return false;
    }

    memmove(out, buffer->ptr + buffer->offset, buffer->size - buffer->offset);
c0de7b60:	6800      	ldr	r0, [r0, #0]
c0de7b62:	18c2      	adds	r2, r0, r3
c0de7b64:	4608      	mov	r0, r1
c0de7b66:	4611      	mov	r1, r2
c0de7b68:	462a      	mov	r2, r5
c0de7b6a:	f001 fbb3 	bl	c0de92d4 <__aeabi_memmove>
c0de7b6e:	2000      	movs	r0, #0
    if (buffer->size - buffer->offset > out_len) {
c0de7b70:	42a5      	cmp	r5, r4
c0de7b72:	bf98      	it	ls
c0de7b74:	2001      	movls	r0, #1

    return true;
}
c0de7b76:	bdb0      	pop	{r4, r5, r7, pc}

c0de7b78 <app_ticker_event_callback>:
    io_seph_ux_display_bagl_element(element);
}
#endif  // HAVE_BAGL

// This function can be used to declare a callback to SEPROXYHAL_TAG_TICKER_EVENT in the application
WEAK void app_ticker_event_callback(void) {}
c0de7b78:	4770      	bx	lr

c0de7b7a <io_event>:

WEAK unsigned char io_event(unsigned char channel)
{
c0de7b7a:	b580      	push	{r7, lr}
    UNUSED(channel);
    switch (G_io_seproxyhal_spi_buffer[0]) {
c0de7b7c:	f240 70f4 	movw	r0, #2036	@ 0x7f4
c0de7b80:	f2c0 0000 	movt	r0, #0
c0de7b84:	f819 1000 	ldrb.w	r1, [r9, r0]
c0de7b88:	2905      	cmp	r1, #5
c0de7b8a:	d010      	beq.n	c0de7bae <io_event+0x34>
c0de7b8c:	290e      	cmp	r1, #14
c0de7b8e:	d006      	beq.n	c0de7b9e <io_event+0x24>
c0de7b90:	290c      	cmp	r1, #12
c0de7b92:	d10a      	bne.n	c0de7baa <io_event+0x30>
        case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT:
            UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
            break;
#ifdef HAVE_SE_TOUCH
        case SEPROXYHAL_TAG_FINGER_EVENT:
            UX_FINGER_EVENT(G_io_seproxyhal_spi_buffer);
c0de7b94:	4448      	add	r0, r9
c0de7b96:	f000 f904 	bl	c0de7da2 <ux_process_finger_event>
        default:
            UX_DEFAULT_EVENT();
            break;
    }

    return 1;
c0de7b9a:	2001      	movs	r0, #1
c0de7b9c:	bd80      	pop	{r7, pc}
            app_ticker_event_callback();
c0de7b9e:	f7ff ffeb 	bl	c0de7b78 <app_ticker_event_callback>
            UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, {});
c0de7ba2:	f000 f950 	bl	c0de7e46 <ux_process_ticker_event>
    return 1;
c0de7ba6:	2001      	movs	r0, #1
c0de7ba8:	bd80      	pop	{r7, pc}
            UX_DEFAULT_EVENT();
c0de7baa:	f000 f9aa 	bl	c0de7f02 <ux_process_default_event>
    return 1;
c0de7bae:	2001      	movs	r0, #1
c0de7bb0:	bd80      	pop	{r7, pc}

c0de7bb2 <io_init>:
}

WEAK void io_init()
{
    need_to_start_io = 1;
c0de7bb2:	f640 1004 	movw	r0, #2308	@ 0x904
c0de7bb6:	f2c0 0000 	movt	r0, #0
c0de7bba:	2101      	movs	r1, #1
c0de7bbc:	f809 1000 	strb.w	r1, [r9, r0]
}
c0de7bc0:	4770      	bx	lr
	...

c0de7bc4 <io_recv_command>:

WEAK int io_recv_command()
{
c0de7bc4:	b510      	push	{r4, lr}
    int status = 0;

    if (need_to_start_io) {
c0de7bc6:	f640 1404 	movw	r4, #2308	@ 0x904
c0de7bca:	f2c0 0400 	movt	r4, #0
c0de7bce:	f819 0004 	ldrb.w	r0, [r9, r4]
c0de7bd2:	2801      	cmp	r0, #1
c0de7bd4:	d104      	bne.n	c0de7be0 <io_recv_command+0x1c>
#ifndef USE_OS_IO_STACK
        io_seproxyhal_io_heartbeat();
        io_seproxyhal_io_heartbeat();
        io_seproxyhal_io_heartbeat();
#endif  // USE_OS_IO_STACK
        os_io_start();
c0de7bd6:	f001 fa35 	bl	c0de9044 <os_io_start>
c0de7bda:	2000      	movs	r0, #0
        need_to_start_io = 0;
c0de7bdc:	f809 0004 	strb.w	r0, [r9, r4]
#ifdef FUZZING
    for (uint8_t retries = 5; retries && status <= 0; retries--) {
#else
    while (status <= 0) {
#endif
        status = io_legacy_apdu_rx(1);
c0de7be0:	2001      	movs	r0, #1
c0de7be2:	f7f8 fce4 	bl	c0de05ae <io_legacy_apdu_rx>
    while (status <= 0) {
c0de7be6:	2801      	cmp	r0, #1
c0de7be8:	dbfa      	blt.n	c0de7be0 <io_recv_command+0x1c>
    }

    return status;
c0de7bea:	bd10      	pop	{r4, pc}

c0de7bec <io_send_response_buffers>:
}

WEAK int io_send_response_buffers(const buffer_t *rdatalist, size_t count, uint16_t sw)
{
c0de7bec:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de7bf0:	b082      	sub	sp, #8
c0de7bf2:	4690      	mov	r8, r2
    int    status = 0;
    size_t length = 0;

    if (rdatalist && count > 0) {
c0de7bf4:	2800      	cmp	r0, #0
c0de7bf6:	d058      	beq.n	c0de7caa <io_send_response_buffers+0xbe>
c0de7bf8:	460e      	mov	r6, r1
c0de7bfa:	2900      	cmp	r1, #0
c0de7bfc:	d055      	beq.n	c0de7caa <io_send_response_buffers+0xbe>
c0de7bfe:	4607      	mov	r7, r0
c0de7c00:	f8cd 8004 	str.w	r8, [sp, #4]
c0de7c04:	f04f 0a00 	mov.w	sl, #0
c0de7c08:	f04f 0801 	mov.w	r8, #1
c0de7c0c:	2500      	movs	r5, #0
c0de7c0e:	bf00      	nop
        for (size_t i = 0; i < count; i++) {
            const buffer_t *rdata = &rdatalist[i];

            if (!buffer_copy(rdata, G_io_tx_buffer + length, sizeof(G_io_tx_buffer) - length - 2)) {
c0de7c10:	f240 0000 	movw	r0, #0
c0de7c14:	f2c0 0000 	movt	r0, #0
c0de7c18:	4448      	add	r0, r9
c0de7c1a:	1941      	adds	r1, r0, r5
c0de7c1c:	f240 100f 	movw	r0, #271	@ 0x10f
c0de7c20:	1b42      	subs	r2, r0, r5
c0de7c22:	4638      	mov	r0, r7
c0de7c24:	f7ff ff95 	bl	c0de7b52 <buffer_copy>
c0de7c28:	4604      	mov	r4, r0
c0de7c2a:	b1a8      	cbz	r0, c0de7c58 <io_send_response_buffers+0x6c>
                return io_send_sw(SWO_INSUFFICIENT_MEMORY);
            }
            length += rdata->size - rdata->offset;
c0de7c2c:	e9d7 3001 	ldrd	r3, r0, [r7, #4]
            if (count > 1) {
c0de7c30:	2e02      	cmp	r6, #2
            length += rdata->size - rdata->offset;
c0de7c32:	eba3 0000 	sub.w	r0, r3, r0
c0de7c36:	4405      	add	r5, r0
            if (count > 1) {
c0de7c38:	d315      	bcc.n	c0de7c66 <io_send_response_buffers+0x7a>
                PRINTF("<= FRAG (%u/%u) RData=%.*H\n", i + 1, count, rdata->size, rdata->ptr);
c0de7c3a:	f8d7 c000 	ldr.w	ip, [r7]
c0de7c3e:	f242 70f2 	movw	r0, #10226	@ 0x27f2
c0de7c42:	f2c0 0000 	movt	r0, #0
c0de7c46:	f10a 0101 	add.w	r1, sl, #1
c0de7c4a:	4478      	add	r0, pc
c0de7c4c:	4632      	mov	r2, r6
c0de7c4e:	f8cd c000 	str.w	ip, [sp]
c0de7c52:	f000 fac3 	bl	c0de81dc <mcu_usb_printf>
c0de7c56:	e006      	b.n	c0de7c66 <io_send_response_buffers+0x7a>
    return io_send_response_buffers(NULL, 0, sw);
c0de7c58:	2000      	movs	r0, #0
c0de7c5a:	2100      	movs	r1, #0
c0de7c5c:	f646 2284 	movw	r2, #27268	@ 0x6a84
c0de7c60:	f7ff ffc4 	bl	c0de7bec <io_send_response_buffers>
c0de7c64:	4683      	mov	fp, r0
c0de7c66:	b15c      	cbz	r4, c0de7c80 <io_send_response_buffers+0x94>
c0de7c68:	f10a 0a01 	add.w	sl, sl, #1
        for (size_t i = 0; i < count; i++) {
c0de7c6c:	45b2      	cmp	sl, r6
c0de7c6e:	f04f 0800 	mov.w	r8, #0
c0de7c72:	bf38      	it	cc
c0de7c74:	f04f 0801 	movcc.w	r8, #1
c0de7c78:	4556      	cmp	r6, sl
c0de7c7a:	f107 070c 	add.w	r7, r7, #12
c0de7c7e:	d1c7      	bne.n	c0de7c10 <io_send_response_buffers+0x24>
c0de7c80:	ea5f 70c8 	movs.w	r0, r8, lsl #31
c0de7c84:	d12c      	bne.n	c0de7ce0 <io_send_response_buffers+0xf4>
            }
        }
        PRINTF("<= SW=%04X | RData=%.*H\n", sw, length, G_io_tx_buffer);
c0de7c86:	f240 0000 	movw	r0, #0
c0de7c8a:	f2c0 0000 	movt	r0, #0
c0de7c8e:	eb09 0300 	add.w	r3, r9, r0
c0de7c92:	f242 60b8 	movw	r0, #9912	@ 0x26b8
c0de7c96:	f2c0 0000 	movt	r0, #0
c0de7c9a:	f8dd 8004 	ldr.w	r8, [sp, #4]
c0de7c9e:	4478      	add	r0, pc
c0de7ca0:	4641      	mov	r1, r8
c0de7ca2:	462a      	mov	r2, r5
c0de7ca4:	f000 fa9a 	bl	c0de81dc <mcu_usb_printf>
c0de7ca8:	e008      	b.n	c0de7cbc <io_send_response_buffers+0xd0>
    }
    else {
        PRINTF("<= SW=%04X | RData=\n", sw);
c0de7caa:	f642 2076 	movw	r0, #10870	@ 0x2a76
c0de7cae:	f2c0 0000 	movt	r0, #0
c0de7cb2:	4478      	add	r0, pc
c0de7cb4:	4641      	mov	r1, r8
c0de7cb6:	f000 fa91 	bl	c0de81dc <mcu_usb_printf>
c0de7cba:	2500      	movs	r5, #0
    }

    write_u16_be(G_io_tx_buffer, length, sw);
c0de7cbc:	f240 0000 	movw	r0, #0
c0de7cc0:	f2c0 0000 	movt	r0, #0
c0de7cc4:	eb09 0400 	add.w	r4, r9, r0
c0de7cc8:	4620      	mov	r0, r4
c0de7cca:	4629      	mov	r1, r5
c0de7ccc:	4642      	mov	r2, r8
c0de7cce:	f000 f861 	bl	c0de7d94 <write_u16_be>
            os_sched_exit(-1);
        }
    }
#endif  // HAVE_SWAP

    status = io_legacy_apdu_tx(G_io_tx_buffer, length);
c0de7cd2:	1ca8      	adds	r0, r5, #2
c0de7cd4:	b281      	uxth	r1, r0
c0de7cd6:	4620      	mov	r0, r4
c0de7cd8:	f7f8 fc4b 	bl	c0de0572 <io_legacy_apdu_tx>

    if (status < 0) {
c0de7cdc:	ea40 7be0 	orr.w	fp, r0, r0, asr #31
        status = -1;
    }

    return status;
}
c0de7ce0:	4658      	mov	r0, fp
c0de7ce2:	b002      	add	sp, #8
c0de7ce4:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de7ce8 <app_exit>:
    os_sched_exit(-1);
c0de7ce8:	20ff      	movs	r0, #255	@ 0xff
c0de7cea:	f001 f995 	bl	c0de9018 <os_sched_exit>

c0de7cee <common_app_init>:
{
c0de7cee:	b580      	push	{r7, lr}
    UX_INIT();
c0de7cf0:	f000 f9e4 	bl	c0de80bc <nbgl_objInit>
    io_seproxyhal_init();
c0de7cf4:	f7f8 fd9b 	bl	c0de082e <io_seproxyhal_init>
}
c0de7cf8:	bd80      	pop	{r7, pc}

c0de7cfa <standalone_app_main>:
{
c0de7cfa:	b510      	push	{r4, lr}
c0de7cfc:	b08c      	sub	sp, #48	@ 0x30
    PRINTF("standalone_app_main\n");
c0de7cfe:	f642 1058 	movw	r0, #10584	@ 0x2958
c0de7d02:	f2c0 0000 	movt	r0, #0
c0de7d06:	4478      	add	r0, pc
c0de7d08:	f000 fa68 	bl	c0de81dc <mcu_usb_printf>
c0de7d0c:	466c      	mov	r4, sp
        TRY
c0de7d0e:	4620      	mov	r0, r4
c0de7d10:	f001 fb2c 	bl	c0de936c <setjmp>
c0de7d14:	0401      	lsls	r1, r0, #16
c0de7d16:	f8ad 002c 	strh.w	r0, [sp, #44]	@ 0x2c
c0de7d1a:	d113      	bne.n	c0de7d44 <standalone_app_main+0x4a>
c0de7d1c:	4620      	mov	r0, r4
c0de7d1e:	f001 f9cb 	bl	c0de90b8 <try_context_set>
c0de7d22:	900a      	str	r0, [sp, #40]	@ 0x28
            common_app_init();
c0de7d24:	f7ff ffe3 	bl	c0de7cee <common_app_init>
            app_main();
c0de7d28:	f7f8 f9e4 	bl	c0de00f4 <app_main>
        FINALLY {}
c0de7d2c:	f001 f9ba 	bl	c0de90a4 <try_context_get>
c0de7d30:	42a0      	cmp	r0, r4
c0de7d32:	d102      	bne.n	c0de7d3a <standalone_app_main+0x40>
c0de7d34:	980a      	ldr	r0, [sp, #40]	@ 0x28
c0de7d36:	f001 f9bf 	bl	c0de90b8 <try_context_set>
    END_TRY;
c0de7d3a:	f8bd 002c 	ldrh.w	r0, [sp, #44]	@ 0x2c
c0de7d3e:	b958      	cbnz	r0, c0de7d58 <standalone_app_main+0x5e>
    app_exit();
c0de7d40:	f7ff ffd2 	bl	c0de7ce8 <app_exit>
        CATCH_OTHER(e)
c0de7d44:	980a      	ldr	r0, [sp, #40]	@ 0x28
c0de7d46:	2100      	movs	r1, #0
c0de7d48:	f8ad 102c 	strh.w	r1, [sp, #44]	@ 0x2c
c0de7d4c:	f001 f9b4 	bl	c0de90b8 <try_context_set>
            os_io_stop();
c0de7d50:	f001 f984 	bl	c0de905c <os_io_stop>
            assert_display_exit();
c0de7d54:	f000 f980 	bl	c0de8058 <assert_display_exit>
    END_TRY;
c0de7d58:	f000 fa27 	bl	c0de81aa <os_longjmp>

c0de7d5c <apdu_parser>:
#include "offsets.h"

bool apdu_parser(command_t *cmd, uint8_t *buf, size_t buf_len)
{
    // Check minimum length, CLA / INS / P1 and P2 are mandatory
    if (buf_len < OFFSET_LC) {
c0de7d5c:	2a04      	cmp	r2, #4
c0de7d5e:	d317      	bcc.n	c0de7d90 <apdu_parser+0x34>
        return false;
    }

    if (buf_len == OFFSET_LC) {
c0de7d60:	d102      	bne.n	c0de7d68 <apdu_parser+0xc>
c0de7d62:	2200      	movs	r2, #0
        // Lc field not specified, implies lc = 0
        cmd->lc = 0;
c0de7d64:	7102      	strb	r2, [r0, #4]
c0de7d66:	e004      	b.n	c0de7d72 <apdu_parser+0x16>
    }
    else {
        // Lc field specified, check value against received length
        cmd->lc = buf[OFFSET_LC];
c0de7d68:	790b      	ldrb	r3, [r1, #4]
        if (buf_len - OFFSET_CDATA != cmd->lc) {
c0de7d6a:	3a05      	subs	r2, #5
c0de7d6c:	429a      	cmp	r2, r3
        cmd->lc = buf[OFFSET_LC];
c0de7d6e:	7103      	strb	r3, [r0, #4]
        if (buf_len - OFFSET_CDATA != cmd->lc) {
c0de7d70:	d10e      	bne.n	c0de7d90 <apdu_parser+0x34>
            return false;
        }
    }

    cmd->cla  = buf[OFFSET_CLA];
c0de7d72:	780a      	ldrb	r2, [r1, #0]
    cmd->ins  = buf[OFFSET_INS];
    cmd->p1   = buf[OFFSET_P1];
    cmd->p2   = buf[OFFSET_P2];
    cmd->data = (cmd->lc > 0) ? buf + OFFSET_CDATA : NULL;
c0de7d74:	7903      	ldrb	r3, [r0, #4]
    cmd->cla  = buf[OFFSET_CLA];
c0de7d76:	7002      	strb	r2, [r0, #0]
    cmd->ins  = buf[OFFSET_INS];
c0de7d78:	784a      	ldrb	r2, [r1, #1]
    cmd->data = (cmd->lc > 0) ? buf + OFFSET_CDATA : NULL;
c0de7d7a:	2b00      	cmp	r3, #0
    cmd->ins  = buf[OFFSET_INS];
c0de7d7c:	7042      	strb	r2, [r0, #1]
    cmd->p1   = buf[OFFSET_P1];
c0de7d7e:	788a      	ldrb	r2, [r1, #2]
c0de7d80:	7082      	strb	r2, [r0, #2]
    cmd->p2   = buf[OFFSET_P2];
c0de7d82:	78ca      	ldrb	r2, [r1, #3]
c0de7d84:	70c2      	strb	r2, [r0, #3]
    cmd->data = (cmd->lc > 0) ? buf + OFFSET_CDATA : NULL;
c0de7d86:	bf18      	it	ne
c0de7d88:	1d4b      	addne	r3, r1, #5
c0de7d8a:	6083      	str	r3, [r0, #8]
c0de7d8c:	2001      	movs	r0, #1

    return true;
}
c0de7d8e:	4770      	bx	lr
c0de7d90:	2000      	movs	r0, #0
c0de7d92:	4770      	bx	lr

c0de7d94 <write_u16_be>:
#include <stdint.h>  // uint*_t
#include <stddef.h>  // size_t

void write_u16_be(uint8_t *ptr, size_t offset, uint16_t value)
{
    ptr[offset + 0] = (uint8_t) (value >> 8);
c0de7d94:	0a13      	lsrs	r3, r2, #8
c0de7d96:	eb00 0c01 	add.w	ip, r0, r1
c0de7d9a:	5443      	strb	r3, [r0, r1]
    ptr[offset + 1] = (uint8_t) (value >> 0);
c0de7d9c:	f88c 2001 	strb.w	r2, [ip, #1]
}
c0de7da0:	4770      	bx	lr

c0de7da2 <ux_process_finger_event>:
 * event caught by BOLOS UX page).
 *
 * @param seph_packet received SEPH packet
 */
void ux_process_finger_event(const uint8_t seph_packet[])
{
c0de7da2:	b5b0      	push	{r4, r5, r7, lr}
c0de7da4:	4604      	mov	r4, r0
    G_ux_params.ux_id = BOLOS_UX_EVENT;
c0de7da6:	f640 1008 	movw	r0, #2312	@ 0x908
c0de7daa:	f2c0 0000 	movt	r0, #0
c0de7dae:	2101      	movs	r1, #1
c0de7db0:	f809 1000 	strb.w	r1, [r9, r0]
c0de7db4:	eb09 0500 	add.w	r5, r9, r0
c0de7db8:	2000      	movs	r0, #0
    G_ux_params.len   = 0;
c0de7dba:	6068      	str	r0, [r5, #4]
    os_ux(&G_ux_params);
c0de7dbc:	4628      	mov	r0, r5
c0de7dbe:	f001 f8fc 	bl	c0de8fba <os_ux>
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de7dc2:	2004      	movs	r0, #4
c0de7dc4:	f001 f986 	bl	c0de90d4 <os_sched_last_status>
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de7dc8:	2869      	cmp	r0, #105	@ 0x69
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de7dca:	6068      	str	r0, [r5, #4]
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de7dcc:	d108      	bne.n	c0de7de0 <ux_process_finger_event+0x3e>
        nbgl_objAllowDrawing(true);
c0de7dce:	2001      	movs	r0, #1
c0de7dd0:	f000 f97e 	bl	c0de80d0 <nbgl_objAllowDrawing>
        nbgl_screenRedraw();
c0de7dd4:	f000 f98b 	bl	c0de80ee <nbgl_screenRedraw>
        nbgl_refresh();
c0de7dd8:	f000 f961 	bl	c0de809e <nbgl_refresh>
c0de7ddc:	2500      	movs	r5, #0
c0de7dde:	e008      	b.n	c0de7df2 <ux_process_finger_event+0x50>
             || ((G_ux_params.len != BOLOS_UX_IGNORE) && (G_ux_params.len != BOLOS_UX_CONTINUE))) {
c0de7de0:	f1b0 0197 	subs.w	r1, r0, #151	@ 0x97
c0de7de4:	bf18      	it	ne
c0de7de6:	2101      	movne	r1, #1
c0de7de8:	2800      	cmp	r0, #0
c0de7dea:	bf18      	it	ne
c0de7dec:	2001      	movne	r0, #1
c0de7dee:	ea01 0500 	and.w	r5, r1, r0
    bool displayEnabled = ux_forward_event(true);
    // enable/disable drawing according to UX decision
    nbgl_objAllowDrawing(displayEnabled);
c0de7df2:	4628      	mov	r0, r5
c0de7df4:	f000 f96c 	bl	c0de80d0 <nbgl_objAllowDrawing>

    // if the event is not fully consumed by UX, use it for NBGL
    if (displayEnabled) {
c0de7df8:	2d00      	cmp	r5, #0
        pos.swipe = seph_packet[10];
#endif  // HAVE_HW_TOUCH_SWIPE
        nbgl_touchHandler(false, &pos, nbTicks * 100);
        nbgl_refresh();
    }
}
c0de7dfa:	bf08      	it	eq
c0de7dfc:	bdb0      	popeq	{r4, r5, r7, pc}
        pos.state = (seph_packet[3] == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) ? PRESSED : RELEASED;
c0de7dfe:	78e0      	ldrb	r0, [r4, #3]
        pos.x     = (seph_packet[4] << 8) + seph_packet[5];
c0de7e00:	7922      	ldrb	r2, [r4, #4]
        pos.state = (seph_packet[3] == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) ? PRESSED : RELEASED;
c0de7e02:	3801      	subs	r0, #1
        pos.x     = (seph_packet[4] << 8) + seph_packet[5];
c0de7e04:	7963      	ldrb	r3, [r4, #5]
        pos.state = (seph_packet[3] == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) ? PRESSED : RELEASED;
c0de7e06:	fab0 f080 	clz	r0, r0
c0de7e0a:	f640 112a 	movw	r1, #2346	@ 0x92a
c0de7e0e:	0940      	lsrs	r0, r0, #5
c0de7e10:	f2c0 0100 	movt	r1, #0
        pos.y     = (seph_packet[6] << 8) + seph_packet[7];
c0de7e14:	79a5      	ldrb	r5, [r4, #6]
        pos.state = (seph_packet[3] == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) ? PRESSED : RELEASED;
c0de7e16:	f809 0001 	strb.w	r0, [r9, r1]
        pos.x     = (seph_packet[4] << 8) + seph_packet[5];
c0de7e1a:	ea43 2002 	orr.w	r0, r3, r2, lsl #8
        pos.y     = (seph_packet[6] << 8) + seph_packet[7];
c0de7e1e:	79e2      	ldrb	r2, [r4, #7]
        pos.state = (seph_packet[3] == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) ? PRESSED : RELEASED;
c0de7e20:	4449      	add	r1, r9
        pos.x     = (seph_packet[4] << 8) + seph_packet[5];
c0de7e22:	8048      	strh	r0, [r1, #2]
        pos.y     = (seph_packet[6] << 8) + seph_packet[7];
c0de7e24:	ea42 2005 	orr.w	r0, r2, r5, lsl #8
c0de7e28:	8088      	strh	r0, [r1, #4]
        nbgl_touchHandler(false, &pos, nbTicks * 100);
c0de7e2a:	f640 1030 	movw	r0, #2352	@ 0x930
c0de7e2e:	f2c0 0000 	movt	r0, #0
c0de7e32:	f859 0000 	ldr.w	r0, [r9, r0]
c0de7e36:	2264      	movs	r2, #100	@ 0x64
c0de7e38:	4342      	muls	r2, r0
c0de7e3a:	2000      	movs	r0, #0
c0de7e3c:	f000 f99d 	bl	c0de817a <nbgl_touchHandler>
        nbgl_refresh();
c0de7e40:	f000 f92d 	bl	c0de809e <nbgl_refresh>
}
c0de7e44:	bdb0      	pop	{r4, r5, r7, pc}

c0de7e46 <ux_process_ticker_event>:
 * @brief Process the ticker_event to the os ux handler. Ticker event callback is always called
 * whatever the return code of the ux app.
 * @note Ticker event interval is assumed to be 100 ms.
 */
void ux_process_ticker_event(void)
{
c0de7e46:	b570      	push	{r4, r5, r6, lr}
c0de7e48:	b082      	sub	sp, #8
    nbTicks++;
c0de7e4a:	f640 1530 	movw	r5, #2352	@ 0x930
c0de7e4e:	f2c0 0500 	movt	r5, #0
c0de7e52:	f859 0005 	ldr.w	r0, [r9, r5]
c0de7e56:	2101      	movs	r1, #1
c0de7e58:	3001      	adds	r0, #1
c0de7e5a:	f849 0005 	str.w	r0, [r9, r5]
    G_ux_params.ux_id = BOLOS_UX_EVENT;
c0de7e5e:	f640 1008 	movw	r0, #2312	@ 0x908
c0de7e62:	f2c0 0000 	movt	r0, #0
c0de7e66:	f809 1000 	strb.w	r1, [r9, r0]
c0de7e6a:	eb09 0400 	add.w	r4, r9, r0
c0de7e6e:	2000      	movs	r0, #0
    G_ux_params.len   = 0;
c0de7e70:	6060      	str	r0, [r4, #4]
    os_ux(&G_ux_params);
c0de7e72:	4620      	mov	r0, r4
c0de7e74:	f001 f8a1 	bl	c0de8fba <os_ux>
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de7e78:	2004      	movs	r0, #4
c0de7e7a:	f001 f92b 	bl	c0de90d4 <os_sched_last_status>
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de7e7e:	2869      	cmp	r0, #105	@ 0x69
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de7e80:	6060      	str	r0, [r4, #4]
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de7e82:	d108      	bne.n	c0de7e96 <ux_process_ticker_event+0x50>
        nbgl_objAllowDrawing(true);
c0de7e84:	2001      	movs	r0, #1
c0de7e86:	f000 f923 	bl	c0de80d0 <nbgl_objAllowDrawing>
        nbgl_screenRedraw();
c0de7e8a:	f000 f930 	bl	c0de80ee <nbgl_screenRedraw>
        nbgl_refresh();
c0de7e8e:	f000 f906 	bl	c0de809e <nbgl_refresh>
c0de7e92:	2400      	movs	r4, #0
c0de7e94:	e008      	b.n	c0de7ea8 <ux_process_ticker_event+0x62>
             || ((G_ux_params.len != BOLOS_UX_IGNORE) && (G_ux_params.len != BOLOS_UX_CONTINUE))) {
c0de7e96:	f1b0 0197 	subs.w	r1, r0, #151	@ 0x97
c0de7e9a:	bf18      	it	ne
c0de7e9c:	2101      	movne	r1, #1
c0de7e9e:	2800      	cmp	r0, #0
c0de7ea0:	bf18      	it	ne
c0de7ea2:	2001      	movne	r0, #1
c0de7ea4:	ea01 0400 	and.w	r4, r1, r0
    // forward to UX
    bool displayEnabled = ux_forward_event(true);

    // enable/disable drawing according to UX decision
    nbgl_objAllowDrawing(displayEnabled);
c0de7ea8:	4620      	mov	r0, r4
c0de7eaa:	f000 f911 	bl	c0de80d0 <nbgl_objAllowDrawing>

    // do not do any action on screens if display is disabled, because
    // UX has the hand
    if (!displayEnabled) {
c0de7eae:	b334      	cbz	r4, c0de7efe <ux_process_ticker_event+0xb8>
        return;
    }

    // update ticker in NBGL
    nbgl_screenHandler(100);
c0de7eb0:	2064      	movs	r0, #100	@ 0x64
c0de7eb2:	2464      	movs	r4, #100	@ 0x64
c0de7eb4:	f000 f92a 	bl	c0de810c <nbgl_screenHandler>

#ifdef HAVE_SE_TOUCH
    // handle touch only if detected as pressed in last touch message
    if (pos.state == PRESSED) {
c0de7eb8:	f640 162a 	movw	r6, #2346	@ 0x92a
c0de7ebc:	f2c0 0600 	movt	r6, #0
c0de7ec0:	f819 0006 	ldrb.w	r0, [r9, r6]
c0de7ec4:	2801      	cmp	r0, #1
c0de7ec6:	d118      	bne.n	c0de7efa <ux_process_ticker_event+0xb4>
c0de7ec8:	4668      	mov	r0, sp
        io_touch_info_t touch_info;
        touch_get_last_info(&touch_info);
c0de7eca:	f001 f911 	bl	c0de90f0 <touch_get_last_info>
        pos.state = (touch_info.state == SEPROXYHAL_TAG_FINGER_EVENT_TOUCH) ? PRESSED : RELEASED;
c0de7ece:	f89d 0004 	ldrb.w	r0, [sp, #4]
c0de7ed2:	eb09 0106 	add.w	r1, r9, r6
c0de7ed6:	3801      	subs	r0, #1
c0de7ed8:	fab0 f080 	clz	r0, r0
c0de7edc:	0940      	lsrs	r0, r0, #5
c0de7ede:	f809 0006 	strb.w	r0, [r9, r6]
        pos.x     = touch_info.x;
c0de7ee2:	f8bd 0000 	ldrh.w	r0, [sp]
        pos.y     = touch_info.y;
        // Send current touch position to nbgl
        nbgl_touchHandler(false, &pos, nbTicks * 100);
c0de7ee6:	f859 2005 	ldr.w	r2, [r9, r5]
        pos.x     = touch_info.x;
c0de7eea:	8048      	strh	r0, [r1, #2]
        pos.y     = touch_info.y;
c0de7eec:	f8bd 0002 	ldrh.w	r0, [sp, #2]
        nbgl_touchHandler(false, &pos, nbTicks * 100);
c0de7ef0:	4362      	muls	r2, r4
        pos.y     = touch_info.y;
c0de7ef2:	8088      	strh	r0, [r1, #4]
        nbgl_touchHandler(false, &pos, nbTicks * 100);
c0de7ef4:	2000      	movs	r0, #0
c0de7ef6:	f000 f940 	bl	c0de817a <nbgl_touchHandler>
    }
#endif  // HAVE_SE_TOUCH
    nbgl_refresh();
c0de7efa:	f000 f8d0 	bl	c0de809e <nbgl_refresh>
}
c0de7efe:	b002      	add	sp, #8
c0de7f00:	bd70      	pop	{r4, r5, r6, pc}

c0de7f02 <ux_process_default_event>:

/**
 * Forwards the event to UX
 */
void ux_process_default_event(void)
{
c0de7f02:	b510      	push	{r4, lr}
    G_ux_params.ux_id = BOLOS_UX_EVENT;
c0de7f04:	f640 1008 	movw	r0, #2312	@ 0x908
c0de7f08:	f2c0 0000 	movt	r0, #0
c0de7f0c:	2101      	movs	r1, #1
c0de7f0e:	f809 1000 	strb.w	r1, [r9, r0]
c0de7f12:	eb09 0400 	add.w	r4, r9, r0
c0de7f16:	2000      	movs	r0, #0
    G_ux_params.len   = 0;
c0de7f18:	6060      	str	r0, [r4, #4]
    os_ux(&G_ux_params);
c0de7f1a:	4620      	mov	r0, r4
c0de7f1c:	f001 f84d 	bl	c0de8fba <os_ux>
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de7f20:	2004      	movs	r0, #4
c0de7f22:	f001 f8d7 	bl	c0de90d4 <os_sched_last_status>
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de7f26:	2869      	cmp	r0, #105	@ 0x69
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de7f28:	6060      	str	r0, [r4, #4]
    // forward to UX
    ux_forward_event(false);
}
c0de7f2a:	bf18      	it	ne
c0de7f2c:	bd10      	popne	{r4, pc}
        nbgl_objAllowDrawing(true);
c0de7f2e:	2001      	movs	r0, #1
c0de7f30:	f000 f8ce 	bl	c0de80d0 <nbgl_objAllowDrawing>
        nbgl_screenRedraw();
c0de7f34:	f000 f8db 	bl	c0de80ee <nbgl_screenRedraw>
        nbgl_refresh();
c0de7f38:	f000 f8b1 	bl	c0de809e <nbgl_refresh>
}
c0de7f3c:	bd10      	pop	{r4, pc}

c0de7f3e <assert_display_lr_and_pc>:
 * Define behavior when LEDGER_ASSERT_CONFIG_LR_AND_PC_INFO *
 ***********************************************************/
#ifdef LEDGER_ASSERT_CONFIG_LR_AND_PC_INFO
#ifdef HAVE_LEDGER_ASSERT_DISPLAY
void assert_display_lr_and_pc(int lr, int pc)
{
c0de7f3e:	b570      	push	{r4, r5, r6, lr}
c0de7f40:	b08a      	sub	sp, #40	@ 0x28
c0de7f42:	460c      	mov	r4, r1
    char buff[LR_AND_PC_SIZE];

    lr = compute_address_location(lr);
c0de7f44:	f000 f93f 	bl	c0de81c6 <compute_address_location>
c0de7f48:	4605      	mov	r5, r0
    pc = compute_address_location(pc);
c0de7f4a:	4620      	mov	r0, r4
c0de7f4c:	f000 f93b 	bl	c0de81c6 <compute_address_location>
    snprintf(buff, LR_AND_PC_SIZE, "LR=0x%08X\n PC=0x%08X\n", lr, pc);
c0de7f50:	f242 72f2 	movw	r2, #10226	@ 0x27f2
c0de7f54:	f2c0 0200 	movt	r2, #0
c0de7f58:	f10d 060a 	add.w	r6, sp, #10
    pc = compute_address_location(pc);
c0de7f5c:	4604      	mov	r4, r0
    snprintf(buff, LR_AND_PC_SIZE, "LR=0x%08X\n PC=0x%08X\n", lr, pc);
c0de7f5e:	447a      	add	r2, pc
c0de7f60:	4630      	mov	r0, r6
c0de7f62:	211e      	movs	r1, #30
c0de7f64:	462b      	mov	r3, r5
c0de7f66:	9400      	str	r4, [sp, #0]
c0de7f68:	f000 ff82 	bl	c0de8e70 <snprintf>
    strncat(assert_buffer, buff, LR_AND_PC_SIZE);
c0de7f6c:	f640 1034 	movw	r0, #2356	@ 0x934
c0de7f70:	f2c0 0000 	movt	r0, #0
c0de7f74:	4448      	add	r0, r9
c0de7f76:	4631      	mov	r1, r6
c0de7f78:	221e      	movs	r2, #30
c0de7f7a:	f001 fa0d 	bl	c0de9398 <strncat>
}
c0de7f7e:	b00a      	add	sp, #40	@ 0x28
c0de7f80:	bd70      	pop	{r4, r5, r6, pc}

c0de7f82 <assert_print_lr_and_pc>:
#endif

#ifdef HAVE_PRINTF
void assert_print_lr_and_pc(int lr, int pc)
{
c0de7f82:	b5b0      	push	{r4, r5, r7, lr}
c0de7f84:	460c      	mov	r4, r1
    lr = compute_address_location(lr);
c0de7f86:	f000 f91e 	bl	c0de81c6 <compute_address_location>
c0de7f8a:	4605      	mov	r5, r0
    pc = compute_address_location(pc);
c0de7f8c:	4620      	mov	r0, r4
c0de7f8e:	f000 f91a 	bl	c0de81c6 <compute_address_location>
c0de7f92:	4604      	mov	r4, r0
    PRINTF("=> LR: 0x%08X \n", lr);
c0de7f94:	f242 70f3 	movw	r0, #10227	@ 0x27f3
c0de7f98:	f2c0 0000 	movt	r0, #0
c0de7f9c:	4478      	add	r0, pc
c0de7f9e:	4629      	mov	r1, r5
c0de7fa0:	f000 f91c 	bl	c0de81dc <mcu_usb_printf>
    PRINTF("=> PC: 0x%08X \n", pc);
c0de7fa4:	f242 40d9 	movw	r0, #9433	@ 0x24d9
c0de7fa8:	f2c0 0000 	movt	r0, #0
c0de7fac:	4478      	add	r0, pc
c0de7fae:	4621      	mov	r1, r4
c0de7fb0:	f000 f914 	bl	c0de81dc <mcu_usb_printf>
}
c0de7fb4:	bdb0      	pop	{r4, r5, r7, pc}

c0de7fb6 <assert_display_file_info>:
 * Define behavior when LEDGER_ASSERT_CONFIG_FILE_INFO *
 ******************************************************/
#ifdef LEDGER_ASSERT_CONFIG_FILE_INFO
#ifdef HAVE_LEDGER_ASSERT_DISPLAY
void assert_display_file_info(const char *file, unsigned int line)
{
c0de7fb6:	b510      	push	{r4, lr}
c0de7fb8:	b08e      	sub	sp, #56	@ 0x38
    char buff[FILE_SIZE];

    snprintf(buff, FILE_SIZE, "%s::%d\n", file, line);
c0de7fba:	f242 5292 	movw	r2, #9618	@ 0x2592
c0de7fbe:	f2c0 0200 	movt	r2, #0
c0de7fc2:	f10d 0406 	add.w	r4, sp, #6
c0de7fc6:	468c      	mov	ip, r1
c0de7fc8:	4603      	mov	r3, r0
c0de7fca:	447a      	add	r2, pc
c0de7fcc:	4620      	mov	r0, r4
c0de7fce:	2132      	movs	r1, #50	@ 0x32
c0de7fd0:	f8cd c000 	str.w	ip, [sp]
c0de7fd4:	f000 ff4c 	bl	c0de8e70 <snprintf>
    strncat(assert_buffer, buff, FILE_SIZE);
c0de7fd8:	f640 1034 	movw	r0, #2356	@ 0x934
c0de7fdc:	f2c0 0000 	movt	r0, #0
c0de7fe0:	4448      	add	r0, r9
c0de7fe2:	4621      	mov	r1, r4
c0de7fe4:	2232      	movs	r2, #50	@ 0x32
c0de7fe6:	f001 f9d7 	bl	c0de9398 <strncat>
}
c0de7fea:	b00e      	add	sp, #56	@ 0x38
c0de7fec:	bd10      	pop	{r4, pc}

c0de7fee <assert_print_file_info>:
#endif

#ifdef HAVE_PRINTF
void assert_print_file_info(const char *file, int line)
{
c0de7fee:	b580      	push	{r7, lr}
c0de7ff0:	460a      	mov	r2, r1
c0de7ff2:	4601      	mov	r1, r0
    PRINTF("%s::%d \n", file, line);
c0de7ff4:	f242 707c 	movw	r0, #10108	@ 0x277c
c0de7ff8:	f2c0 0000 	movt	r0, #0
c0de7ffc:	4478      	add	r0, pc
c0de7ffe:	f000 f8ed 	bl	c0de81dc <mcu_usb_printf>
}
c0de8002:	bd80      	pop	{r7, pc}

c0de8004 <throw_display_lr>:
/*************************************
 * Specific mechanism to debug THROW *
 ************************************/
#ifdef HAVE_DEBUG_THROWS
void throw_display_lr(int e, int lr)
{
c0de8004:	b5b0      	push	{r4, r5, r7, lr}
c0de8006:	b082      	sub	sp, #8
c0de8008:	4605      	mov	r5, r0
    lr = compute_address_location(lr);
c0de800a:	4608      	mov	r0, r1
c0de800c:	f000 f8db 	bl	c0de81c6 <compute_address_location>
c0de8010:	4604      	mov	r4, r0
    snprintf(assert_buffer, ASSERT_BUFFER_LEN, "e=0x%04X\n LR=0x%08X\n", e, lr);
c0de8012:	f640 1034 	movw	r0, #2356	@ 0x934
c0de8016:	f242 52e3 	movw	r2, #9699	@ 0x25e3
c0de801a:	f2c0 0000 	movt	r0, #0
c0de801e:	f2c0 0200 	movt	r2, #0
c0de8022:	4448      	add	r0, r9
c0de8024:	447a      	add	r2, pc
c0de8026:	2182      	movs	r1, #130	@ 0x82
c0de8028:	462b      	mov	r3, r5
c0de802a:	9400      	str	r4, [sp, #0]
c0de802c:	f000 ff20 	bl	c0de8e70 <snprintf>
}
c0de8030:	b002      	add	sp, #8
c0de8032:	bdb0      	pop	{r4, r5, r7, pc}

c0de8034 <throw_print_lr>:

#ifdef HAVE_PRINTF
void throw_print_lr(int e, int lr)
{
c0de8034:	b510      	push	{r4, lr}
c0de8036:	4604      	mov	r4, r0
    lr = compute_address_location(lr);
c0de8038:	4608      	mov	r0, r1
c0de803a:	f000 f8c4 	bl	c0de81c6 <compute_address_location>
c0de803e:	4602      	mov	r2, r0
    PRINTF("exception[0x%04X]: LR=0x%08X\n", e, lr);
c0de8040:	f242 602b 	movw	r0, #9771	@ 0x262b
c0de8044:	f2c0 0000 	movt	r0, #0
c0de8048:	4478      	add	r0, pc
c0de804a:	4621      	mov	r1, r4
c0de804c:	f000 f8c6 	bl	c0de81dc <mcu_usb_printf>
}
c0de8050:	bd10      	pop	{r4, pc}

c0de8052 <assert_exit>:
 * Common app exit *
 ******************/
void __attribute__((noreturn)) assert_exit(bool confirm)
{
    UNUSED(confirm);
    os_sched_exit(-1);
c0de8052:	20ff      	movs	r0, #255	@ 0xff
c0de8054:	f000 ffe0 	bl	c0de9018 <os_sched_exit>

c0de8058 <assert_display_exit>:
           });
UX_FLOW(ux_error_flow, &ux_error);
#endif

void __attribute__((noreturn)) assert_display_exit(void)
{
c0de8058:	b082      	sub	sp, #8
#define ICON_APP_WARNING C_Important_Circle_64px
#elif defined(TARGET_APEX)
#define ICON_APP_WARNING C_Important_Circle_48px
#endif

    nbgl_useCaseChoice(
c0de805a:	f64f 7cc5 	movw	ip, #65477	@ 0xffc5
c0de805e:	f6cf 7cff 	movt	ip, #65535	@ 0xffff
c0de8062:	f242 2372 	movw	r3, #8818	@ 0x2272
c0de8066:	f2c0 0300 	movt	r3, #0
c0de806a:	f640 1034 	movw	r0, #2356	@ 0x934
c0de806e:	447b      	add	r3, pc
c0de8070:	f2c0 0000 	movt	r0, #0
c0de8074:	9300      	str	r3, [sp, #0]
c0de8076:	eb09 0200 	add.w	r2, r9, r0
c0de807a:	f241 702f 	movw	r0, #5935	@ 0x172f
c0de807e:	f2c0 0000 	movt	r0, #0
c0de8082:	f242 1191 	movw	r1, #8593	@ 0x2191
c0de8086:	f2c0 0100 	movt	r1, #0
c0de808a:	44fc      	add	ip, pc
c0de808c:	4478      	add	r0, pc
c0de808e:	4479      	add	r1, pc
c0de8090:	f8cd c004 	str.w	ip, [sp, #4]
c0de8094:	f7fe fdb7 	bl	c0de6c06 <nbgl_useCaseChoice>
        &ICON_APP_WARNING, "App error", assert_buffer, "Exit app", "Exit app", assert_exit);
#endif

    // Block until the user approve and the app is quit
    while (1) {
        io_seproxyhal_io_heartbeat();
c0de8098:	f7f8 fa15 	bl	c0de04c6 <io_seproxyhal_io_heartbeat>
    while (1) {
c0de809c:	e7fc      	b.n	c0de8098 <assert_display_exit+0x40>

c0de809e <nbgl_refresh>:
c0de809e:	b403      	push	{r0, r1}
c0de80a0:	f04f 0091 	mov.w	r0, #145	@ 0x91
c0de80a4:	f000 b878 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de80a8 <nbgl_refreshSpecial>:
c0de80a8:	b403      	push	{r0, r1}
c0de80aa:	f04f 0092 	mov.w	r0, #146	@ 0x92
c0de80ae:	f000 b873 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de80b2 <nbgl_refreshSpecialWithPostRefresh>:
c0de80b2:	b403      	push	{r0, r1}
c0de80b4:	f04f 0093 	mov.w	r0, #147	@ 0x93
c0de80b8:	f000 b86e 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de80bc <nbgl_objInit>:
c0de80bc:	b403      	push	{r0, r1}
c0de80be:	f04f 0096 	mov.w	r0, #150	@ 0x96
c0de80c2:	f000 b869 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de80c6 <nbgl_objDraw>:
c0de80c6:	b403      	push	{r0, r1}
c0de80c8:	f04f 0097 	mov.w	r0, #151	@ 0x97
c0de80cc:	f000 b864 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de80d0 <nbgl_objAllowDrawing>:
c0de80d0:	b403      	push	{r0, r1}
c0de80d2:	f04f 0098 	mov.w	r0, #152	@ 0x98
c0de80d6:	f000 b85f 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de80da <nbgl_screenSet>:
c0de80da:	b403      	push	{r0, r1}
c0de80dc:	f04f 009b 	mov.w	r0, #155	@ 0x9b
c0de80e0:	f000 b85a 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de80e4 <nbgl_screenPush>:
c0de80e4:	b403      	push	{r0, r1}
c0de80e6:	f04f 009c 	mov.w	r0, #156	@ 0x9c
c0de80ea:	f000 b855 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de80ee <nbgl_screenRedraw>:
c0de80ee:	b403      	push	{r0, r1}
c0de80f0:	f04f 009d 	mov.w	r0, #157	@ 0x9d
c0de80f4:	f000 b850 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de80f8 <nbgl_screenPop>:
c0de80f8:	b403      	push	{r0, r1}
c0de80fa:	f04f 009e 	mov.w	r0, #158	@ 0x9e
c0de80fe:	f000 b84b 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de8102 <nbgl_screenUpdateTicker>:
c0de8102:	b403      	push	{r0, r1}
c0de8104:	f04f 00a4 	mov.w	r0, #164	@ 0xa4
c0de8108:	f000 b846 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de810c <nbgl_screenHandler>:
c0de810c:	b403      	push	{r0, r1}
c0de810e:	f04f 00a7 	mov.w	r0, #167	@ 0xa7
c0de8112:	f000 b841 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de8116 <nbgl_objPoolGet>:
c0de8116:	b403      	push	{r0, r1}
c0de8118:	f04f 00a8 	mov.w	r0, #168	@ 0xa8
c0de811c:	f000 b83c 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de8120 <nbgl_containerPoolGet>:
c0de8120:	b403      	push	{r0, r1}
c0de8122:	f04f 00aa 	mov.w	r0, #170	@ 0xaa
c0de8126:	f000 b837 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de812a <nbgl_getFont>:
c0de812a:	b403      	push	{r0, r1}
c0de812c:	f04f 00ac 	mov.w	r0, #172	@ 0xac
c0de8130:	f000 b832 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de8134 <nbgl_getFontHeight>:
c0de8134:	b403      	push	{r0, r1}
c0de8136:	f04f 00ad 	mov.w	r0, #173	@ 0xad
c0de813a:	f000 b82d 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de813e <nbgl_getFontLineHeight>:
c0de813e:	b403      	push	{r0, r1}
c0de8140:	f04f 00ae 	mov.w	r0, #174	@ 0xae
c0de8144:	f000 b828 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de8148 <nbgl_getTextHeightInWidth>:
c0de8148:	b403      	push	{r0, r1}
c0de814a:	f04f 00b2 	mov.w	r0, #178	@ 0xb2
c0de814e:	f000 b823 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de8152 <nbgl_getTextNbLinesInWidth>:
c0de8152:	b403      	push	{r0, r1}
c0de8154:	f04f 00b4 	mov.w	r0, #180	@ 0xb4
c0de8158:	f000 b81e 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de815c <nbgl_getTextWidth>:
c0de815c:	b403      	push	{r0, r1}
c0de815e:	f04f 00b6 	mov.w	r0, #182	@ 0xb6
c0de8162:	f000 b819 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de8166 <nbgl_getTextMaxLenInNbLines>:
c0de8166:	b403      	push	{r0, r1}
c0de8168:	f04f 00b7 	mov.w	r0, #183	@ 0xb7
c0de816c:	f000 b814 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de8170 <nbgl_textReduceOnNbLines>:
c0de8170:	b403      	push	{r0, r1}
c0de8172:	f04f 00b8 	mov.w	r0, #184	@ 0xb8
c0de8176:	f000 b80f 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de817a <nbgl_touchHandler>:
c0de817a:	b403      	push	{r0, r1}
c0de817c:	f04f 00bb 	mov.w	r0, #187	@ 0xbb
c0de8180:	f000 b80a 	b.w	c0de8198 <nbgl_trampoline_helper>

c0de8184 <nbgl_touchGetTouchDuration>:
c0de8184:	b403      	push	{r0, r1}
c0de8186:	f04f 00bc 	mov.w	r0, #188	@ 0xbc
c0de818a:	f000 b805 	b.w	c0de8198 <nbgl_trampoline_helper>
	...

c0de8190 <pic_init>:
c0de8190:	b403      	push	{r0, r1}
c0de8192:	f04f 00c4 	mov.w	r0, #196	@ 0xc4
c0de8196:	e7ff      	b.n	c0de8198 <nbgl_trampoline_helper>

c0de8198 <nbgl_trampoline_helper>:
c0de8198:	4900      	ldr	r1, [pc, #0]	@ (c0de819c <nbgl_trampoline_helper+0x4>)
c0de819a:	4708      	bx	r1
c0de819c:	00808001 	.word	0x00808001

c0de81a0 <os_boot>:
#include "os_io_seph_cmd.h"
#include <string.h>

#ifndef BOLOS_OS_UPGRADER_APP
void os_boot(void)
{
c0de81a0:	b580      	push	{r7, lr}
    // // TODO patch entry point when romming (f)
    // // set the default try context to nothing
#ifndef HAVE_BOLOS
    try_context_set(NULL);
c0de81a2:	2000      	movs	r0, #0
c0de81a4:	f000 ff88 	bl	c0de90b8 <try_context_set>
#endif  // HAVE_BOLOS
}
c0de81a8:	bd80      	pop	{r7, pc}

c0de81aa <os_longjmp>:

void os_longjmp(unsigned int exception)
{
#ifdef HAVE_DEBUG_THROWS
    // Send to the app the info of exception and LR for debug purpose
    DEBUG_THROW(exception);
c0de81aa:	4675      	mov	r5, lr
c0de81ac:	4629      	mov	r1, r5
c0de81ae:	4604      	mov	r4, r0
c0de81b0:	f7ff ff28 	bl	c0de8004 <throw_display_lr>
c0de81b4:	4620      	mov	r0, r4
c0de81b6:	4629      	mov	r1, r5
c0de81b8:	f7ff ff3c 	bl	c0de8034 <throw_print_lr>
    lr_val = compute_address_location(lr_val);

    PRINTF("exception[0x%04X]: LR=0x%08X\n", exception, lr_val);
#endif

    longjmp(try_context_get()->jmp_buf, exception);
c0de81bc:	f000 ff72 	bl	c0de90a4 <try_context_get>
c0de81c0:	4621      	mov	r1, r4
c0de81c2:	f001 f8d9 	bl	c0de9378 <longjmp>

c0de81c6 <compute_address_location>:
    return address - (unsigned int) main + MAIN_LINKER_SCRIPT_LOCATION;
c0de81c6:	f647 612f 	movw	r1, #32303	@ 0x7e2f
c0de81ca:	f6cf 71ff 	movt	r1, #65535	@ 0xffff
c0de81ce:	4479      	add	r1, pc
c0de81d0:	1a40      	subs	r0, r0, r1
c0de81d2:	f100 4040 	add.w	r0, r0, #3221225472	@ 0xc0000000
c0de81d6:	f500 005e 	add.w	r0, r0, #14548992	@ 0xde0000
c0de81da:	4770      	bx	lr

c0de81dc <mcu_usb_printf>:

#ifdef HAVE_PRINTF
void screen_printf(const char *format, ...) __attribute__((weak, alias("mcu_usb_printf")));

void mcu_usb_printf(const char *format, ...)
{
c0de81dc:	b083      	sub	sp, #12
c0de81de:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de81e2:	b091      	sub	sp, #68	@ 0x44
    va_list vaArgP;

    if (format == NULL) {
c0de81e4:	2800      	cmp	r0, #0
c0de81e6:	e9cd 1219 	strd	r1, r2, [sp, #100]	@ 0x64
c0de81ea:	931b      	str	r3, [sp, #108]	@ 0x6c
c0de81ec:	f000 82f7 	beq.w	c0de87de <mcu_usb_printf+0x602>
c0de81f0:	4604      	mov	r4, r0
    while (*format) {
c0de81f2:	7800      	ldrb	r0, [r0, #0]
c0de81f4:	f10d 0b64 	add.w	fp, sp, #100	@ 0x64
c0de81f8:	2800      	cmp	r0, #0
        return;
    }

    va_start(vaArgP, format);
c0de81fa:	f8cd b01c 	str.w	fp, [sp, #28]
    while (*format) {
c0de81fe:	f000 82ee 	beq.w	c0de87de <mcu_usb_printf+0x602>
c0de8202:	f242 06df 	movw	r6, #8415	@ 0x20df
c0de8206:	f2c0 0600 	movt	r6, #0
c0de820a:	447e      	add	r6, pc
c0de820c:	e00a      	b.n	c0de8224 <mcu_usb_printf+0x48>
c0de820e:	bf00      	nop
c0de8210:	f242 06d1 	movw	r6, #8401	@ 0x20d1
c0de8214:	f2c0 0600 	movt	r6, #0
c0de8218:	447e      	add	r6, pc
c0de821a:	4654      	mov	r4, sl
c0de821c:	7820      	ldrb	r0, [r4, #0]
c0de821e:	2800      	cmp	r0, #0
c0de8220:	f000 82dd 	beq.w	c0de87de <mcu_usb_printf+0x602>
c0de8224:	2700      	movs	r7, #0
c0de8226:	bf00      	nop
        for (ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0'); ulIdx++) {
c0de8228:	5de0      	ldrb	r0, [r4, r7]
c0de822a:	b118      	cbz	r0, c0de8234 <mcu_usb_printf+0x58>
c0de822c:	2825      	cmp	r0, #37	@ 0x25
c0de822e:	d001      	beq.n	c0de8234 <mcu_usb_printf+0x58>
c0de8230:	3701      	adds	r7, #1
c0de8232:	e7f9      	b.n	c0de8228 <mcu_usb_printf+0x4c>
        if (ulIdx > 0) {
c0de8234:	b11f      	cbz	r7, c0de823e <mcu_usb_printf+0x62>
    os_io_seph_cmd_printf(data, len);
c0de8236:	b2b9      	uxth	r1, r7
c0de8238:	4620      	mov	r0, r4
c0de823a:	f7f8 f8a1 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de823e:	443c      	add	r4, r7
        if (*format == '%') {
c0de8240:	7820      	ldrb	r0, [r4, #0]
c0de8242:	2825      	cmp	r0, #37	@ 0x25
c0de8244:	d1ea      	bne.n	c0de821c <mcu_usb_printf+0x40>
            ulNeg      = 0;
c0de8246:	3401      	adds	r4, #1
c0de8248:	f04f 0e00 	mov.w	lr, #0
c0de824c:	f04f 0c20 	mov.w	ip, #32
c0de8250:	f04f 0800 	mov.w	r8, #0
c0de8254:	2100      	movs	r1, #0
c0de8256:	e002      	b.n	c0de825e <mcu_usb_printf+0x82>
c0de8258:	f04f 0100 	mov.w	r1, #0
            switch (*format++) {
c0de825c:	d117      	bne.n	c0de828e <mcu_usb_printf+0xb2>
c0de825e:	f814 2b01 	ldrb.w	r2, [r4], #1
c0de8262:	2a2d      	cmp	r2, #45	@ 0x2d
c0de8264:	ddf8      	ble.n	c0de8258 <mcu_usb_printf+0x7c>
c0de8266:	2a47      	cmp	r2, #71	@ 0x47
c0de8268:	dc32      	bgt.n	c0de82d0 <mcu_usb_printf+0xf4>
c0de826a:	f1a2 0030 	sub.w	r0, r2, #48	@ 0x30
c0de826e:	280a      	cmp	r0, #10
c0de8270:	d21a      	bcs.n	c0de82a8 <mcu_usb_printf+0xcc>
                    if ((format[-1] == '0') && (ulCount == 0)) {
c0de8272:	f082 0030 	eor.w	r0, r2, #48	@ 0x30
c0de8276:	ea50 000e 	orrs.w	r0, r0, lr
                    ulCount *= 10;
c0de827a:	eb0e 008e 	add.w	r0, lr, lr, lsl #2
                    ulCount += format[-1] - '0';
c0de827e:	eb02 0040 	add.w	r0, r2, r0, lsl #1
                    if ((format[-1] == '0') && (ulCount == 0)) {
c0de8282:	bf08      	it	eq
c0de8284:	f04f 0c30 	moveq.w	ip, #48	@ 0x30
                    ulCount += format[-1] - '0';
c0de8288:	f1a0 0e30 	sub.w	lr, r0, #48	@ 0x30
c0de828c:	e7e7      	b.n	c0de825e <mcu_usb_printf+0x82>
            switch (*format++) {
c0de828e:	2a25      	cmp	r2, #37	@ 0x25
c0de8290:	d04c      	beq.n	c0de832c <mcu_usb_printf+0x150>
c0de8292:	2a2a      	cmp	r2, #42	@ 0x2a
c0de8294:	f040 82a3 	bne.w	c0de87de <mcu_usb_printf+0x602>
                    if (*format == 's') {
c0de8298:	7820      	ldrb	r0, [r4, #0]
c0de829a:	2873      	cmp	r0, #115	@ 0x73
c0de829c:	f040 829f 	bne.w	c0de87de <mcu_usb_printf+0x602>
c0de82a0:	f85b 8b04 	ldr.w	r8, [fp], #4
c0de82a4:	2102      	movs	r1, #2
c0de82a6:	e7da      	b.n	c0de825e <mcu_usb_printf+0x82>
            switch (*format++) {
c0de82a8:	2a2e      	cmp	r2, #46	@ 0x2e
c0de82aa:	f040 8298 	bne.w	c0de87de <mcu_usb_printf+0x602>
                    if (format[0] == '*'
c0de82ae:	7820      	ldrb	r0, [r4, #0]
                        && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de82b0:	282a      	cmp	r0, #42	@ 0x2a
c0de82b2:	f040 8294 	bne.w	c0de87de <mcu_usb_printf+0x602>
c0de82b6:	f814 0f01 	ldrb.w	r0, [r4, #1]!
c0de82ba:	2101      	movs	r1, #1
c0de82bc:	2848      	cmp	r0, #72	@ 0x48
c0de82be:	d004      	beq.n	c0de82ca <mcu_usb_printf+0xee>
c0de82c0:	2868      	cmp	r0, #104	@ 0x68
c0de82c2:	d002      	beq.n	c0de82ca <mcu_usb_printf+0xee>
c0de82c4:	2873      	cmp	r0, #115	@ 0x73
c0de82c6:	f040 828a 	bne.w	c0de87de <mcu_usb_printf+0x602>
c0de82ca:	f85b 8b04 	ldr.w	r8, [fp], #4
c0de82ce:	e7c6      	b.n	c0de825e <mcu_usb_printf+0x82>
            switch (*format++) {
c0de82d0:	2a6b      	cmp	r2, #107	@ 0x6b
c0de82d2:	dc0b      	bgt.n	c0de82ec <mcu_usb_printf+0x110>
c0de82d4:	2a62      	cmp	r2, #98	@ 0x62
c0de82d6:	dd12      	ble.n	c0de82fe <mcu_usb_printf+0x122>
c0de82d8:	2a63      	cmp	r2, #99	@ 0x63
c0de82da:	d02d      	beq.n	c0de8338 <mcu_usb_printf+0x15c>
c0de82dc:	2a64      	cmp	r2, #100	@ 0x64
c0de82de:	d033      	beq.n	c0de8348 <mcu_usb_printf+0x16c>
c0de82e0:	2a68      	cmp	r2, #104	@ 0x68
c0de82e2:	f040 827c 	bne.w	c0de87de <mcu_usb_printf+0x602>
c0de82e6:	2001      	movs	r0, #1
c0de82e8:	e03c      	b.n	c0de8364 <mcu_usb_printf+0x188>
c0de82ea:	bf00      	nop
c0de82ec:	2a72      	cmp	r2, #114	@ 0x72
c0de82ee:	dd0e      	ble.n	c0de830e <mcu_usb_printf+0x132>
c0de82f0:	2a73      	cmp	r2, #115	@ 0x73
c0de82f2:	d036      	beq.n	c0de8362 <mcu_usb_printf+0x186>
c0de82f4:	2a75      	cmp	r2, #117	@ 0x75
c0de82f6:	d03b      	beq.n	c0de8370 <mcu_usb_printf+0x194>
c0de82f8:	2a78      	cmp	r2, #120	@ 0x78
c0de82fa:	d00e      	beq.n	c0de831a <mcu_usb_printf+0x13e>
c0de82fc:	e26f      	b.n	c0de87de <mcu_usb_printf+0x602>
c0de82fe:	2a48      	cmp	r2, #72	@ 0x48
c0de8300:	f000 80e6 	beq.w	c0de84d0 <mcu_usb_printf+0x2f4>
c0de8304:	2a58      	cmp	r2, #88	@ 0x58
c0de8306:	f040 826a 	bne.w	c0de87de <mcu_usb_printf+0x602>
c0de830a:	2001      	movs	r0, #1
c0de830c:	e006      	b.n	c0de831c <mcu_usb_printf+0x140>
c0de830e:	2a6c      	cmp	r2, #108	@ 0x6c
c0de8310:	f000 8101 	beq.w	c0de8516 <mcu_usb_printf+0x33a>
c0de8314:	2a70      	cmp	r2, #112	@ 0x70
c0de8316:	f040 8262 	bne.w	c0de87de <mcu_usb_printf+0x602>
c0de831a:	2000      	movs	r0, #0
c0de831c:	9005      	str	r0, [sp, #20]
c0de831e:	f8db 0000 	ldr.w	r0, [fp]
c0de8322:	2610      	movs	r6, #16
c0de8324:	9010      	str	r0, [sp, #64]	@ 0x40
c0de8326:	f04f 0800 	mov.w	r8, #0
c0de832a:	e029      	b.n	c0de8380 <mcu_usb_printf+0x1a4>
    os_io_seph_cmd_printf(data, len);
c0de832c:	f242 501e 	movw	r0, #9502	@ 0x251e
c0de8330:	f2c0 0000 	movt	r0, #0
c0de8334:	4478      	add	r0, pc
c0de8336:	e003      	b.n	c0de8340 <mcu_usb_printf+0x164>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de8338:	f85b 0b04 	ldr.w	r0, [fp], #4
c0de833c:	9010      	str	r0, [sp, #64]	@ 0x40
    os_io_seph_cmd_printf(data, len);
c0de833e:	a810      	add	r0, sp, #64	@ 0x40
c0de8340:	2101      	movs	r1, #1
c0de8342:	f7f8 f81d 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de8346:	e769      	b.n	c0de821c <mcu_usb_printf+0x40>
                    ulValue = va_arg(vaArgP, unsigned int);
c0de8348:	f8db 0000 	ldr.w	r0, [fp]
                    if ((long) ulValue < 0) {
c0de834c:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
                    ulValue = va_arg(vaArgP, unsigned int);
c0de8350:	9010      	str	r0, [sp, #64]	@ 0x40
                    if ((long) ulValue < 0) {
c0de8352:	dc10      	bgt.n	c0de8376 <mcu_usb_printf+0x19a>
                        ulValue = -(long) ((int) ulValue);
c0de8354:	4240      	negs	r0, r0
c0de8356:	9010      	str	r0, [sp, #64]	@ 0x40
c0de8358:	2000      	movs	r0, #0
c0de835a:	260a      	movs	r6, #10
c0de835c:	f04f 0801 	mov.w	r8, #1
c0de8360:	e00d      	b.n	c0de837e <mcu_usb_printf+0x1a2>
c0de8362:	2000      	movs	r0, #0
c0de8364:	f242 6a1c 	movw	sl, #9756	@ 0x261c
c0de8368:	f2c0 0a00 	movt	sl, #0
c0de836c:	44fa      	add	sl, pc
c0de836e:	e0b5      	b.n	c0de84dc <mcu_usb_printf+0x300>
                    ulValue = va_arg(vaArgP, unsigned int);
c0de8370:	f8db 0000 	ldr.w	r0, [fp]
c0de8374:	9010      	str	r0, [sp, #64]	@ 0x40
c0de8376:	2000      	movs	r0, #0
c0de8378:	260a      	movs	r6, #10
c0de837a:	f04f 0800 	mov.w	r8, #0
c0de837e:	9005      	str	r0, [sp, #20]
c0de8380:	9910      	ldr	r1, [sp, #64]	@ 0x40
                         (((ulIdx * ulBase) <= ulValue) && (((ulIdx * ulBase) / ulBase) == ulIdx));
c0de8382:	f8cd b010 	str.w	fp, [sp, #16]
c0de8386:	428e      	cmp	r6, r1
c0de8388:	d902      	bls.n	c0de8390 <mcu_usb_printf+0x1b4>
c0de838a:	2501      	movs	r5, #1
c0de838c:	2701      	movs	r7, #1
c0de838e:	e00e      	b.n	c0de83ae <mcu_usb_printf+0x1d2>
c0de8390:	2202      	movs	r2, #2
c0de8392:	4633      	mov	r3, r6
c0de8394:	461d      	mov	r5, r3
c0de8396:	fba6 3003 	umull	r3, r0, r6, r3
c0de839a:	2800      	cmp	r0, #0
c0de839c:	bf18      	it	ne
c0de839e:	2001      	movne	r0, #1
c0de83a0:	428b      	cmp	r3, r1
c0de83a2:	4617      	mov	r7, r2
c0de83a4:	d803      	bhi.n	c0de83ae <mcu_usb_printf+0x1d2>
                    for (ulIdx = 1;
c0de83a6:	2800      	cmp	r0, #0
c0de83a8:	f107 0201 	add.w	r2, r7, #1
c0de83ac:	d0f2      	beq.n	c0de8394 <mcu_usb_printf+0x1b8>
    if (*ulNeg) {
c0de83ae:	eb07 0108 	add.w	r1, r7, r8
    if (ulWidth > ulActualLen) {
c0de83b2:	ebbe 0b01 	subs.w	fp, lr, r1
c0de83b6:	fa5f fa8c 	uxtb.w	sl, ip
    if (*ulNeg) {
c0de83ba:	f088 0001 	eor.w	r0, r8, #1
c0de83be:	f8cd 8018 	str.w	r8, [sp, #24]
c0de83c2:	f04f 0800 	mov.w	r8, #0
    if (ulWidth > ulActualLen) {
c0de83c6:	bf38      	it	cc
c0de83c8:	46c3      	movcc	fp, r8
c0de83ca:	f1ba 0230 	subs.w	r2, sl, #48	@ 0x30
c0de83ce:	bf18      	it	ne
c0de83d0:	2201      	movne	r2, #1
    if (*ulNeg && (cFill == '0')) {
c0de83d2:	4310      	orrs	r0, r2
c0de83d4:	d106      	bne.n	c0de83e4 <mcu_usb_printf+0x208>
        pcBuf[(*ulPos)++] = '-';
c0de83d6:	202d      	movs	r0, #45	@ 0x2d
c0de83d8:	f88d 0020 	strb.w	r0, [sp, #32]
c0de83dc:	2000      	movs	r0, #0
c0de83de:	f04f 0801 	mov.w	r8, #1
c0de83e2:	9006      	str	r0, [sp, #24]
    while (ulPaddingNeeded > 0) {
c0de83e4:	4571      	cmp	r1, lr
c0de83e6:	d31a      	bcc.n	c0de841e <mcu_usb_printf+0x242>
    if (*ulNeg) {
c0de83e8:	9806      	ldr	r0, [sp, #24]
c0de83ea:	46a2      	mov	sl, r4
c0de83ec:	b3a0      	cbz	r0, c0de8458 <mcu_usb_printf+0x27c>
c0de83ee:	f8dd b010 	ldr.w	fp, [sp, #16]
        if (*ulPos >= PCBUF_SIZE) {
c0de83f2:	f1b8 0f20 	cmp.w	r8, #32
c0de83f6:	ac08      	add	r4, sp, #32
c0de83f8:	d306      	bcc.n	c0de8408 <mcu_usb_printf+0x22c>
    os_io_seph_cmd_printf(data, len);
c0de83fa:	fa1f f188 	uxth.w	r1, r8
c0de83fe:	4620      	mov	r0, r4
c0de8400:	f7f7 ffbe 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de8404:	f04f 0800 	mov.w	r8, #0
        pcBuf[(*ulPos)++] = '-';
c0de8408:	202d      	movs	r0, #45	@ 0x2d
c0de840a:	f804 0008 	strb.w	r0, [r4, r8]
c0de840e:	f108 0801 	add.w	r8, r8, #1
                    for (; ulIdx; ulIdx /= ulBase) {
c0de8412:	bb2d      	cbnz	r5, c0de8460 <mcu_usb_printf+0x284>
c0de8414:	e050      	b.n	c0de84b8 <mcu_usb_printf+0x2dc>
c0de8416:	bf00      	nop
    while (ulPaddingNeeded > 0) {
c0de8418:	f1bb 0f00 	cmp.w	fp, #0
c0de841c:	d0e4      	beq.n	c0de83e8 <mcu_usb_printf+0x20c>
        unsigned long bufferSpace = PCBUF_SIZE - *ulPos;
c0de841e:	f1c8 0720 	rsb	r7, r8, #32
        if (chunkSize > bufferSpace) {
c0de8422:	45bb      	cmp	fp, r7
c0de8424:	bf98      	it	ls
c0de8426:	465f      	movls	r7, fp
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de8428:	b137      	cbz	r7, c0de8438 <mcu_usb_printf+0x25c>
c0de842a:	a808      	add	r0, sp, #32
c0de842c:	4440      	add	r0, r8
            pcBuf[(*ulPos)++] = cFill;
c0de842e:	4639      	mov	r1, r7
c0de8430:	4652      	mov	r2, sl
c0de8432:	f000 ff51 	bl	c0de92d8 <__aeabi_memset>
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de8436:	44b8      	add	r8, r7
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de8438:	f1b8 0f20 	cmp.w	r8, #32
        ulPaddingNeeded -= chunkSize;
c0de843c:	ebab 0b07 	sub.w	fp, fp, r7
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de8440:	d3ea      	bcc.n	c0de8418 <mcu_usb_printf+0x23c>
c0de8442:	f1bb 0f00 	cmp.w	fp, #0
c0de8446:	d0e7      	beq.n	c0de8418 <mcu_usb_printf+0x23c>
    os_io_seph_cmd_printf(data, len);
c0de8448:	fa1f f188 	uxth.w	r1, r8
c0de844c:	a808      	add	r0, sp, #32
c0de844e:	f7f7 ff97 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de8452:	f04f 0800 	mov.w	r8, #0
c0de8456:	e7df      	b.n	c0de8418 <mcu_usb_printf+0x23c>
c0de8458:	f8dd b010 	ldr.w	fp, [sp, #16]
c0de845c:	ac08      	add	r4, sp, #32
                    for (; ulIdx; ulIdx /= ulBase) {
c0de845e:	b35d      	cbz	r5, c0de84b8 <mcu_usb_printf+0x2dc>
c0de8460:	9805      	ldr	r0, [sp, #20]
c0de8462:	f242 5728 	movw	r7, #9512	@ 0x2528
c0de8466:	2800      	cmp	r0, #0
c0de8468:	f2c0 0700 	movt	r7, #0
c0de846c:	f242 5012 	movw	r0, #9490	@ 0x2512
c0de8470:	447f      	add	r7, pc
c0de8472:	f2c0 0000 	movt	r0, #0
c0de8476:	4478      	add	r0, pc
c0de8478:	bf08      	it	eq
c0de847a:	4607      	moveq	r7, r0
c0de847c:	e010      	b.n	c0de84a0 <mcu_usb_printf+0x2c4>
c0de847e:	bf00      	nop
c0de8480:	9810      	ldr	r0, [sp, #64]	@ 0x40
c0de8482:	42ae      	cmp	r6, r5
c0de8484:	fbb0 f0f5 	udiv	r0, r0, r5
c0de8488:	fbb5 f5f6 	udiv	r5, r5, r6
c0de848c:	fbb0 f1f6 	udiv	r1, r0, r6
c0de8490:	fb01 0016 	mls	r0, r1, r6, r0
c0de8494:	5c38      	ldrb	r0, [r7, r0]
c0de8496:	f804 0008 	strb.w	r0, [r4, r8]
c0de849a:	f108 0801 	add.w	r8, r8, #1
c0de849e:	d80b      	bhi.n	c0de84b8 <mcu_usb_printf+0x2dc>
                        if (ulPos >= PCBUF_SIZE) {
c0de84a0:	f1b8 0f20 	cmp.w	r8, #32
c0de84a4:	d3ec      	bcc.n	c0de8480 <mcu_usb_printf+0x2a4>
    os_io_seph_cmd_printf(data, len);
c0de84a6:	fa1f f188 	uxth.w	r1, r8
c0de84aa:	4620      	mov	r0, r4
c0de84ac:	f7f7 ff68 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de84b0:	f04f 0800 	mov.w	r8, #0
c0de84b4:	e7e4      	b.n	c0de8480 <mcu_usb_printf+0x2a4>
c0de84b6:	bf00      	nop
                    if (ulPos > 0) {
c0de84b8:	f1b8 0f00 	cmp.w	r8, #0
c0de84bc:	f10b 0b04 	add.w	fp, fp, #4
c0de84c0:	f43f aea6 	beq.w	c0de8210 <mcu_usb_printf+0x34>
    os_io_seph_cmd_printf(data, len);
c0de84c4:	fa1f f188 	uxth.w	r1, r8
c0de84c8:	4620      	mov	r0, r4
c0de84ca:	f7f7 ff59 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de84ce:	e69f      	b.n	c0de8210 <mcu_usb_printf+0x34>
c0de84d0:	f242 4abe 	movw	sl, #9406	@ 0x24be
c0de84d4:	f2c0 0a00 	movt	sl, #0
c0de84d8:	2001      	movs	r0, #1
c0de84da:	44fa      	add	sl, pc
                    pcStr = va_arg(vaArgP, char *);
c0de84dc:	f85b 5b04 	ldr.w	r5, [fp], #4
                    switch (cStrlenSet) {
c0de84e0:	b2c9      	uxtb	r1, r1
c0de84e2:	2900      	cmp	r1, #0
c0de84e4:	d04d      	beq.n	c0de8582 <mcu_usb_printf+0x3a6>
c0de84e6:	2901      	cmp	r1, #1
c0de84e8:	d074      	beq.n	c0de85d4 <mcu_usb_printf+0x3f8>
c0de84ea:	2902      	cmp	r1, #2
c0de84ec:	d14f      	bne.n	c0de858e <mcu_usb_printf+0x3b2>
                            if (pcStr[0] == '\0') {
c0de84ee:	7828      	ldrb	r0, [r5, #0]
c0de84f0:	2800      	cmp	r0, #0
c0de84f2:	f040 8174 	bne.w	c0de87de <mcu_usb_printf+0x602>
                                for (ulCount = 0; ulCount < ulStrlen; ulCount++) {
c0de84f6:	f1b8 0f00 	cmp.w	r8, #0
c0de84fa:	f000 809f 	beq.w	c0de863c <mcu_usb_printf+0x460>
c0de84fe:	4645      	mov	r5, r8
    os_io_seph_cmd_printf(data, len);
c0de8500:	4630      	mov	r0, r6
c0de8502:	2101      	movs	r1, #1
c0de8504:	f7f7 ff3c 	bl	c0de0380 <os_io_seph_cmd_printf>
                                for (ulCount = 0; ulCount < ulStrlen; ulCount++) {
c0de8508:	3d01      	subs	r5, #1
c0de850a:	d1f9      	bne.n	c0de8500 <mcu_usb_printf+0x324>
c0de850c:	4642      	mov	r2, r8
                    if (ulCount > ulIdx) {
c0de850e:	42ba      	cmp	r2, r7
c0de8510:	f67f ae84 	bls.w	c0de821c <mcu_usb_printf+0x40>
c0de8514:	e07c      	b.n	c0de8610 <mcu_usb_printf+0x434>
                    if (*format == 'l'
c0de8516:	7820      	ldrb	r0, [r4, #0]
                        && (*(format + 1) == 'u' || *(format + 1) == 'd' || *(format + 1) == 'x'
c0de8518:	286c      	cmp	r0, #108	@ 0x6c
c0de851a:	f040 8160 	bne.w	c0de87de <mcu_usb_printf+0x602>
c0de851e:	4623      	mov	r3, r4
c0de8520:	f813 1f01 	ldrb.w	r1, [r3, #1]!
c0de8524:	f1a1 0064 	sub.w	r0, r1, #100	@ 0x64
c0de8528:	2814      	cmp	r0, #20
c0de852a:	d807      	bhi.n	c0de853c <mcu_usb_printf+0x360>
c0de852c:	2201      	movs	r2, #1
c0de852e:	fa02 f000 	lsl.w	r0, r2, r0
c0de8532:	2201      	movs	r2, #1
c0de8534:	f2c0 0212 	movt	r2, #18
c0de8538:	4210      	tst	r0, r2
c0de853a:	d102      	bne.n	c0de8542 <mcu_usb_printf+0x366>
c0de853c:	2958      	cmp	r1, #88	@ 0x58
c0de853e:	f040 814e 	bne.w	c0de87de <mcu_usb_printf+0x602>
                        int64_t  slValue64 = va_arg(vaArgP, int64_t);
c0de8542:	f10b 0007 	add.w	r0, fp, #7
c0de8546:	f020 0007 	bic.w	r0, r0, #7
c0de854a:	6842      	ldr	r2, [r0, #4]
c0de854c:	f850 5b08 	ldr.w	r5, [r0], #8
                        if (*format == 'd') {
c0de8550:	2974      	cmp	r1, #116	@ 0x74
c0de8552:	9004      	str	r0, [sp, #16]
c0de8554:	dc65      	bgt.n	c0de8622 <mcu_usb_printf+0x446>
c0de8556:	2958      	cmp	r1, #88	@ 0x58
c0de8558:	d075      	beq.n	c0de8646 <mcu_usb_printf+0x46a>
c0de855a:	2964      	cmp	r1, #100	@ 0x64
c0de855c:	f040 8086 	bne.w	c0de866c <mcu_usb_printf+0x490>
                            if (slValue64 < 0) {
c0de8560:	eb15 70e2 	adds.w	r0, r5, r2, asr #31
c0de8564:	ea80 75e2 	eor.w	r5, r0, r2, asr #31
c0de8568:	eb42 70e2 	adc.w	r0, r2, r2, asr #31
c0de856c:	0fd1      	lsrs	r1, r2, #31
c0de856e:	ea80 72e2 	eor.w	r2, r0, r2, asr #31
c0de8572:	f242 400a 	movw	r0, #9226	@ 0x240a
c0de8576:	f2c0 0000 	movt	r0, #0
c0de857a:	1ca3      	adds	r3, r4, #2
c0de857c:	240a      	movs	r4, #10
c0de857e:	4478      	add	r0, pc
c0de8580:	e072      	b.n	c0de8668 <mcu_usb_printf+0x48c>
c0de8582:	2100      	movs	r1, #0
                            for (ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++) {
c0de8584:	5c6a      	ldrb	r2, [r5, r1]
c0de8586:	3101      	adds	r1, #1
c0de8588:	2a00      	cmp	r2, #0
c0de858a:	d1fb      	bne.n	c0de8584 <mcu_usb_printf+0x3a8>
                    switch (ulBase) {
c0de858c:	1e4f      	subs	r7, r1, #1
c0de858e:	b320      	cbz	r0, c0de85da <mcu_usb_printf+0x3fe>
c0de8590:	46a0      	mov	r8, r4
                            for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de8592:	2f00      	cmp	r7, #0
c0de8594:	d04c      	beq.n	c0de8630 <mcu_usb_printf+0x454>
c0de8596:	2400      	movs	r4, #0
c0de8598:	2600      	movs	r6, #0
c0de859a:	e002      	b.n	c0de85a2 <mcu_usb_printf+0x3c6>
c0de859c:	3601      	adds	r6, #1
c0de859e:	42b7      	cmp	r7, r6
c0de85a0:	d025      	beq.n	c0de85ee <mcu_usb_printf+0x412>
                                nibble1 = (pcStr[ulCount] >> 4) & 0xF;
c0de85a2:	5da9      	ldrb	r1, [r5, r6]
c0de85a4:	a808      	add	r0, sp, #32
c0de85a6:	090a      	lsrs	r2, r1, #4
                                nibble2 = pcStr[ulCount] & 0xF;
c0de85a8:	f001 010f 	and.w	r1, r1, #15
c0de85ac:	f81a 2002 	ldrb.w	r2, [sl, r2]
c0de85b0:	f81a 1001 	ldrb.w	r1, [sl, r1]
c0de85b4:	1903      	adds	r3, r0, r4
c0de85b6:	5502      	strb	r2, [r0, r4]
c0de85b8:	7059      	strb	r1, [r3, #1]
c0de85ba:	1ca1      	adds	r1, r4, #2
                                if (idx + 1 >= sizeof(pcBuf)) {
c0de85bc:	f1a4 001d 	sub.w	r0, r4, #29
c0de85c0:	f110 0f21 	cmn.w	r0, #33	@ 0x21
c0de85c4:	460c      	mov	r4, r1
c0de85c6:	d8e9      	bhi.n	c0de859c <mcu_usb_printf+0x3c0>
    os_io_seph_cmd_printf(data, len);
c0de85c8:	b289      	uxth	r1, r1
c0de85ca:	a808      	add	r0, sp, #32
c0de85cc:	f7f7 fed8 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de85d0:	2400      	movs	r4, #0
c0de85d2:	e7e3      	b.n	c0de859c <mcu_usb_printf+0x3c0>
c0de85d4:	4647      	mov	r7, r8
                    switch (ulBase) {
c0de85d6:	2800      	cmp	r0, #0
c0de85d8:	d1da      	bne.n	c0de8590 <mcu_usb_printf+0x3b4>
    os_io_seph_cmd_printf(data, len);
c0de85da:	b2b9      	uxth	r1, r7
c0de85dc:	4628      	mov	r0, r5
c0de85de:	4675      	mov	r5, lr
c0de85e0:	f7f7 fece 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de85e4:	462a      	mov	r2, r5
                    if (ulCount > ulIdx) {
c0de85e6:	42ba      	cmp	r2, r7
c0de85e8:	f67f ae18 	bls.w	c0de821c <mcu_usb_printf+0x40>
c0de85ec:	e010      	b.n	c0de8610 <mcu_usb_printf+0x434>
c0de85ee:	f641 46ef 	movw	r6, #7407	@ 0x1cef
c0de85f2:	f2c0 0600 	movt	r6, #0
c0de85f6:	463a      	mov	r2, r7
c0de85f8:	a808      	add	r0, sp, #32
c0de85fa:	447e      	add	r6, pc
                            if (idx != 0) {
c0de85fc:	b124      	cbz	r4, c0de8608 <mcu_usb_printf+0x42c>
    os_io_seph_cmd_printf(data, len);
c0de85fe:	b2a1      	uxth	r1, r4
c0de8600:	4614      	mov	r4, r2
c0de8602:	f7f7 febd 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de8606:	4622      	mov	r2, r4
c0de8608:	4644      	mov	r4, r8
                    if (ulCount > ulIdx) {
c0de860a:	42ba      	cmp	r2, r7
c0de860c:	f67f ae06 	bls.w	c0de821c <mcu_usb_printf+0x40>
                        while (ulCount--) {
c0de8610:	1abd      	subs	r5, r7, r2
c0de8612:	bf00      	nop
    os_io_seph_cmd_printf(data, len);
c0de8614:	4630      	mov	r0, r6
c0de8616:	2101      	movs	r1, #1
c0de8618:	f7f7 feb2 	bl	c0de0380 <os_io_seph_cmd_printf>
                        while (ulCount--) {
c0de861c:	3501      	adds	r5, #1
c0de861e:	d3f9      	bcc.n	c0de8614 <mcu_usb_printf+0x438>
c0de8620:	e5fc      	b.n	c0de821c <mcu_usb_printf+0x40>
                        if (*format == 'd') {
c0de8622:	2975      	cmp	r1, #117	@ 0x75
c0de8624:	d018      	beq.n	c0de8658 <mcu_usb_printf+0x47c>
c0de8626:	2978      	cmp	r1, #120	@ 0x78
c0de8628:	d120      	bne.n	c0de866c <mcu_usb_printf+0x490>
                        }
c0de862a:	1ca3      	adds	r3, r4, #2
c0de862c:	2410      	movs	r4, #16
c0de862e:	e015      	b.n	c0de865c <mcu_usb_printf+0x480>
c0de8630:	2200      	movs	r2, #0
c0de8632:	2400      	movs	r4, #0
c0de8634:	a808      	add	r0, sp, #32
                            if (idx != 0) {
c0de8636:	2c00      	cmp	r4, #0
c0de8638:	d1e1      	bne.n	c0de85fe <mcu_usb_printf+0x422>
c0de863a:	e7e5      	b.n	c0de8608 <mcu_usb_printf+0x42c>
c0de863c:	2200      	movs	r2, #0
                    if (ulCount > ulIdx) {
c0de863e:	42ba      	cmp	r2, r7
c0de8640:	f67f adec 	bls.w	c0de821c <mcu_usb_printf+0x40>
c0de8644:	e7e4      	b.n	c0de8610 <mcu_usb_printf+0x434>
c0de8646:	f242 3044 	movw	r0, #9028	@ 0x2344
c0de864a:	f2c0 0000 	movt	r0, #0
                        }
c0de864e:	1ca3      	adds	r3, r4, #2
c0de8650:	2410      	movs	r4, #16
c0de8652:	2100      	movs	r1, #0
c0de8654:	4478      	add	r0, pc
c0de8656:	e007      	b.n	c0de8668 <mcu_usb_printf+0x48c>
                        }
c0de8658:	1ca3      	adds	r3, r4, #2
c0de865a:	240a      	movs	r4, #10
c0de865c:	f242 3022 	movw	r0, #8994	@ 0x2322
c0de8660:	f2c0 0000 	movt	r0, #0
c0de8664:	2100      	movs	r1, #0
c0de8666:	4478      	add	r0, pc
c0de8668:	9005      	str	r0, [sp, #20]
c0de866a:	e009      	b.n	c0de8680 <mcu_usb_printf+0x4a4>
c0de866c:	f242 3014 	movw	r0, #8980	@ 0x2314
c0de8670:	f2c0 0000 	movt	r0, #0
c0de8674:	4478      	add	r0, pc
c0de8676:	2100      	movs	r1, #0
c0de8678:	240a      	movs	r4, #10
c0de867a:	9005      	str	r0, [sp, #20]
c0de867c:	2500      	movs	r5, #0
c0de867e:	2200      	movs	r2, #0
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de8680:	1b28      	subs	r0, r5, r4
c0de8682:	9506      	str	r5, [sp, #24]
c0de8684:	4693      	mov	fp, r2
c0de8686:	f172 0000 	sbcs.w	r0, r2, #0
c0de868a:	f04f 0500 	mov.w	r5, #0
c0de868e:	e9cd 3101 	strd	r3, r1, [sp, #4]
                                           && (((ulIdx64 * ulBase) / ulBase) == ulIdx64));
c0de8692:	d205      	bcs.n	c0de86a0 <mcu_usb_printf+0x4c4>
c0de8694:	2201      	movs	r2, #1
c0de8696:	f04f 0801 	mov.w	r8, #1
c0de869a:	f04f 0a00 	mov.w	sl, #0
c0de869e:	e01b      	b.n	c0de86d8 <mcu_usb_printf+0x4fc>
c0de86a0:	2100      	movs	r1, #0
c0de86a2:	2702      	movs	r7, #2
c0de86a4:	4623      	mov	r3, r4
c0de86a6:	bf00      	nop
c0de86a8:	468a      	mov	sl, r1
c0de86aa:	4698      	mov	r8, r3
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de86ac:	fba4 3003 	umull	r3, r0, r4, r3
c0de86b0:	fba1 1604 	umull	r1, r6, r1, r4
c0de86b4:	1809      	adds	r1, r1, r0
c0de86b6:	f04f 0000 	mov.w	r0, #0
c0de86ba:	f140 0000 	adc.w	r0, r0, #0
c0de86be:	2e00      	cmp	r6, #0
c0de86c0:	bf18      	it	ne
c0de86c2:	2601      	movne	r6, #1
c0de86c4:	9a06      	ldr	r2, [sp, #24]
c0de86c6:	1ad2      	subs	r2, r2, r3
c0de86c8:	eb7b 0201 	sbcs.w	r2, fp, r1
c0de86cc:	463a      	mov	r2, r7
                                           && (((ulIdx64 * ulBase) / ulBase) == ulIdx64));
c0de86ce:	d303      	bcc.n	c0de86d8 <mcu_usb_printf+0x4fc>
c0de86d0:	4330      	orrs	r0, r6
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de86d2:	f102 0701 	add.w	r7, r2, #1
c0de86d6:	d0e7      	beq.n	c0de86a8 <mcu_usb_printf+0x4cc>
c0de86d8:	9802      	ldr	r0, [sp, #8]
    if (*ulNeg) {
c0de86da:	1811      	adds	r1, r2, r0
    if (ulWidth > ulActualLen) {
c0de86dc:	ebbe 0601 	subs.w	r6, lr, r1
c0de86e0:	fa5f f28c 	uxtb.w	r2, ip
c0de86e4:	bf38      	it	cc
c0de86e6:	462e      	movcc	r6, r5
    if (*ulNeg && (cFill == '0')) {
c0de86e8:	2a30      	cmp	r2, #48	@ 0x30
c0de86ea:	9203      	str	r2, [sp, #12]
c0de86ec:	d155      	bne.n	c0de879a <mcu_usb_printf+0x5be>
c0de86ee:	465f      	mov	r7, fp
c0de86f0:	b128      	cbz	r0, c0de86fe <mcu_usb_printf+0x522>
        pcBuf[(*ulPos)++] = '-';
c0de86f2:	202d      	movs	r0, #45	@ 0x2d
c0de86f4:	f88d 0020 	strb.w	r0, [sp, #32]
c0de86f8:	2000      	movs	r0, #0
c0de86fa:	2501      	movs	r5, #1
c0de86fc:	9002      	str	r0, [sp, #8]
    while (ulPaddingNeeded > 0) {
c0de86fe:	4571      	cmp	r1, lr
c0de8700:	d353      	bcc.n	c0de87aa <mcu_usb_printf+0x5ce>
    if (*ulNeg) {
c0de8702:	9802      	ldr	r0, [sp, #8]
c0de8704:	b150      	cbz	r0, c0de871c <mcu_usb_printf+0x540>
c0de8706:	f8dd b010 	ldr.w	fp, [sp, #16]
        if (*ulPos >= PCBUF_SIZE) {
c0de870a:	2d20      	cmp	r5, #32
c0de870c:	d30c      	bcc.n	c0de8728 <mcu_usb_printf+0x54c>
c0de870e:	ae08      	add	r6, sp, #32
    os_io_seph_cmd_printf(data, len);
c0de8710:	b2a9      	uxth	r1, r5
c0de8712:	4630      	mov	r0, r6
c0de8714:	f7f7 fe34 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de8718:	2500      	movs	r5, #0
c0de871a:	e006      	b.n	c0de872a <mcu_usb_printf+0x54e>
c0de871c:	f8dd b010 	ldr.w	fp, [sp, #16]
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de8720:	ea58 000a 	orrs.w	r0, r8, sl
c0de8724:	d135      	bne.n	c0de8792 <mcu_usb_printf+0x5b6>
c0de8726:	e006      	b.n	c0de8736 <mcu_usb_printf+0x55a>
c0de8728:	ae08      	add	r6, sp, #32
        pcBuf[(*ulPos)++] = '-';
c0de872a:	202d      	movs	r0, #45	@ 0x2d
c0de872c:	5570      	strb	r0, [r6, r5]
c0de872e:	3501      	adds	r5, #1
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de8730:	ea58 000a 	orrs.w	r0, r8, sl
c0de8734:	d12d      	bne.n	c0de8792 <mcu_usb_printf+0x5b6>
                        if (ulPos > 0) {
c0de8736:	b11d      	cbz	r5, c0de8740 <mcu_usb_printf+0x564>
    os_io_seph_cmd_printf(data, len);
c0de8738:	b2a9      	uxth	r1, r5
c0de873a:	a808      	add	r0, sp, #32
c0de873c:	f7f7 fe20 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de8740:	9c01      	ldr	r4, [sp, #4]
c0de8742:	f641 369f 	movw	r6, #7071	@ 0x1b9f
c0de8746:	f2c0 0600 	movt	r6, #0
c0de874a:	447e      	add	r6, pc
c0de874c:	e566      	b.n	c0de821c <mcu_usb_printf+0x40>
c0de874e:	bf00      	nop
c0de8750:	ae08      	add	r6, sp, #32
c0de8752:	b2a9      	uxth	r1, r5
c0de8754:	4630      	mov	r0, r6
c0de8756:	f7f7 fe13 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de875a:	2500      	movs	r5, #0
c0de875c:	9806      	ldr	r0, [sp, #24]
c0de875e:	4639      	mov	r1, r7
c0de8760:	4642      	mov	r2, r8
c0de8762:	4653      	mov	r3, sl
c0de8764:	f000 fdc2 	bl	c0de92ec <__aeabi_uldivmod>
c0de8768:	4622      	mov	r2, r4
c0de876a:	2300      	movs	r3, #0
c0de876c:	f000 fdbe 	bl	c0de92ec <__aeabi_uldivmod>
c0de8770:	9805      	ldr	r0, [sp, #20]
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de8772:	4651      	mov	r1, sl
c0de8774:	5c80      	ldrb	r0, [r0, r2]
c0de8776:	4622      	mov	r2, r4
c0de8778:	5570      	strb	r0, [r6, r5]
c0de877a:	4640      	mov	r0, r8
c0de877c:	2300      	movs	r3, #0
c0de877e:	3501      	adds	r5, #1
c0de8780:	f000 fdb4 	bl	c0de92ec <__aeabi_uldivmod>
c0de8784:	ebb8 0204 	subs.w	r2, r8, r4
c0de8788:	f17a 0200 	sbcs.w	r2, sl, #0
c0de878c:	4680      	mov	r8, r0
c0de878e:	468a      	mov	sl, r1
c0de8790:	d3d1      	bcc.n	c0de8736 <mcu_usb_printf+0x55a>
                            if (ulPos >= PCBUF_SIZE) {
c0de8792:	2d20      	cmp	r5, #32
c0de8794:	d2dc      	bcs.n	c0de8750 <mcu_usb_printf+0x574>
c0de8796:	ae08      	add	r6, sp, #32
c0de8798:	e7e0      	b.n	c0de875c <mcu_usb_printf+0x580>
c0de879a:	465f      	mov	r7, fp
    while (ulPaddingNeeded > 0) {
c0de879c:	4571      	cmp	r1, lr
c0de879e:	d304      	bcc.n	c0de87aa <mcu_usb_printf+0x5ce>
c0de87a0:	e7af      	b.n	c0de8702 <mcu_usb_printf+0x526>
c0de87a2:	bf00      	nop
c0de87a4:	465f      	mov	r7, fp
c0de87a6:	2e00      	cmp	r6, #0
c0de87a8:	d0ab      	beq.n	c0de8702 <mcu_usb_printf+0x526>
        unsigned long bufferSpace = PCBUF_SIZE - *ulPos;
c0de87aa:	f1c5 0720 	rsb	r7, r5, #32
        if (chunkSize > bufferSpace) {
c0de87ae:	42be      	cmp	r6, r7
c0de87b0:	bf98      	it	ls
c0de87b2:	4637      	movls	r7, r6
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de87b4:	b137      	cbz	r7, c0de87c4 <mcu_usb_printf+0x5e8>
c0de87b6:	a808      	add	r0, sp, #32
            pcBuf[(*ulPos)++] = cFill;
c0de87b8:	9a03      	ldr	r2, [sp, #12]
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de87ba:	4428      	add	r0, r5
            pcBuf[(*ulPos)++] = cFill;
c0de87bc:	4639      	mov	r1, r7
c0de87be:	f000 fd8b 	bl	c0de92d8 <__aeabi_memset>
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de87c2:	443d      	add	r5, r7
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de87c4:	2d20      	cmp	r5, #32
        ulPaddingNeeded -= chunkSize;
c0de87c6:	eba6 0607 	sub.w	r6, r6, r7
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de87ca:	d3eb      	bcc.n	c0de87a4 <mcu_usb_printf+0x5c8>
c0de87cc:	2e00      	cmp	r6, #0
c0de87ce:	465f      	mov	r7, fp
c0de87d0:	d0e9      	beq.n	c0de87a6 <mcu_usb_printf+0x5ca>
    os_io_seph_cmd_printf(data, len);
c0de87d2:	b2a9      	uxth	r1, r5
c0de87d4:	a808      	add	r0, sp, #32
c0de87d6:	f7f7 fdd3 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de87da:	2500      	movs	r5, #0
c0de87dc:	e7e3      	b.n	c0de87a6 <mcu_usb_printf+0x5ca>
    (void) vformat_internal(printf_output, NULL, format, vaArgP);
    va_end(vaArgP);
}
c0de87de:	b011      	add	sp, #68	@ 0x44
c0de87e0:	e8bd 4df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de87e4:	b003      	add	sp, #12
c0de87e6:	4770      	bx	lr

c0de87e8 <vformat_internal>:
{
c0de87e8:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de87ec:	b092      	sub	sp, #72	@ 0x48
c0de87ee:	4688      	mov	r8, r1
    while (*format) {
c0de87f0:	7811      	ldrb	r1, [r2, #0]
c0de87f2:	2900      	cmp	r1, #0
c0de87f4:	f000 8333 	beq.w	c0de8e5e <vformat_internal+0x676>
c0de87f8:	461f      	mov	r7, r3
c0de87fa:	4692      	mov	sl, r2
c0de87fc:	4606      	mov	r6, r0
c0de87fe:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de8802:	e9cd 8007 	strd	r8, r0, [sp, #28]
c0de8806:	e00e      	b.n	c0de8826 <vformat_internal+0x3e>
                    output("%", 1, output_ctx);
c0de8808:	f242 0042 	movw	r0, #8258	@ 0x2042
c0de880c:	f2c0 0000 	movt	r0, #0
c0de8810:	4478      	add	r0, pc
c0de8812:	2101      	movs	r1, #1
c0de8814:	4642      	mov	r2, r8
c0de8816:	47b0      	blx	r6
c0de8818:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
    while (*format) {
c0de881c:	f89a 0000 	ldrb.w	r0, [sl]
c0de8820:	2800      	cmp	r0, #0
c0de8822:	f000 831c 	beq.w	c0de8e5e <vformat_internal+0x676>
c0de8826:	f04f 0b00 	mov.w	fp, #0
c0de882a:	bf00      	nop
        for (ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0'); ulIdx++) {
c0de882c:	f81a 000b 	ldrb.w	r0, [sl, fp]
c0de8830:	b120      	cbz	r0, c0de883c <vformat_internal+0x54>
c0de8832:	2825      	cmp	r0, #37	@ 0x25
c0de8834:	d002      	beq.n	c0de883c <vformat_internal+0x54>
c0de8836:	f10b 0b01 	add.w	fp, fp, #1
c0de883a:	e7f7      	b.n	c0de882c <vformat_internal+0x44>
        if (ulIdx > 0) {
c0de883c:	f1bb 0f00 	cmp.w	fp, #0
c0de8840:	d005      	beq.n	c0de884e <vformat_internal+0x66>
            output(format, ulIdx, output_ctx);
c0de8842:	4650      	mov	r0, sl
c0de8844:	4659      	mov	r1, fp
c0de8846:	4642      	mov	r2, r8
c0de8848:	47b0      	blx	r6
c0de884a:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de884e:	44da      	add	sl, fp
        if (*format == '%') {
c0de8850:	f89a 0000 	ldrb.w	r0, [sl]
c0de8854:	2825      	cmp	r0, #37	@ 0x25
c0de8856:	d1e1      	bne.n	c0de881c <vformat_internal+0x34>
            ulNeg      = 0;
c0de8858:	f10a 0a01 	add.w	sl, sl, #1
c0de885c:	2300      	movs	r3, #0
c0de885e:	f04f 0c20 	mov.w	ip, #32
c0de8862:	2500      	movs	r5, #0
c0de8864:	2100      	movs	r1, #0
c0de8866:	e002      	b.n	c0de886e <vformat_internal+0x86>
c0de8868:	f04f 0100 	mov.w	r1, #0
            switch (*format++) {
c0de886c:	d116      	bne.n	c0de889c <vformat_internal+0xb4>
c0de886e:	f81a 2b01 	ldrb.w	r2, [sl], #1
c0de8872:	2a2d      	cmp	r2, #45	@ 0x2d
c0de8874:	ddf8      	ble.n	c0de8868 <vformat_internal+0x80>
c0de8876:	2a47      	cmp	r2, #71	@ 0x47
c0de8878:	dc34      	bgt.n	c0de88e4 <vformat_internal+0xfc>
c0de887a:	f1a2 0030 	sub.w	r0, r2, #48	@ 0x30
c0de887e:	280a      	cmp	r0, #10
c0de8880:	d21a      	bcs.n	c0de88b8 <vformat_internal+0xd0>
                    if ((format[-1] == '0') && (ulCount == 0)) {
c0de8882:	f082 0030 	eor.w	r0, r2, #48	@ 0x30
c0de8886:	4318      	orrs	r0, r3
                    ulCount *= 10;
c0de8888:	eb03 0083 	add.w	r0, r3, r3, lsl #2
                    ulCount += format[-1] - '0';
c0de888c:	eb02 0040 	add.w	r0, r2, r0, lsl #1
                    if ((format[-1] == '0') && (ulCount == 0)) {
c0de8890:	bf08      	it	eq
c0de8892:	f04f 0c30 	moveq.w	ip, #48	@ 0x30
                    ulCount += format[-1] - '0';
c0de8896:	f1a0 0330 	sub.w	r3, r0, #48	@ 0x30
c0de889a:	e7e8      	b.n	c0de886e <vformat_internal+0x86>
            switch (*format++) {
c0de889c:	2a25      	cmp	r2, #37	@ 0x25
c0de889e:	d0b3      	beq.n	c0de8808 <vformat_internal+0x20>
c0de88a0:	2a2a      	cmp	r2, #42	@ 0x2a
c0de88a2:	f040 82e0 	bne.w	c0de8e66 <vformat_internal+0x67e>
                    if (*format == 's') {
c0de88a6:	f89a 0000 	ldrb.w	r0, [sl]
c0de88aa:	2873      	cmp	r0, #115	@ 0x73
c0de88ac:	f040 82db 	bne.w	c0de8e66 <vformat_internal+0x67e>
c0de88b0:	f857 5b04 	ldr.w	r5, [r7], #4
c0de88b4:	2102      	movs	r1, #2
c0de88b6:	e7da      	b.n	c0de886e <vformat_internal+0x86>
            switch (*format++) {
c0de88b8:	2a2e      	cmp	r2, #46	@ 0x2e
c0de88ba:	f040 82d4 	bne.w	c0de8e66 <vformat_internal+0x67e>
                    if (format[0] == '*'
c0de88be:	f89a 0000 	ldrb.w	r0, [sl]
                        && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de88c2:	282a      	cmp	r0, #42	@ 0x2a
c0de88c4:	f040 82cf 	bne.w	c0de8e66 <vformat_internal+0x67e>
c0de88c8:	f81a 0f01 	ldrb.w	r0, [sl, #1]!
c0de88cc:	2101      	movs	r1, #1
c0de88ce:	2848      	cmp	r0, #72	@ 0x48
c0de88d0:	d004      	beq.n	c0de88dc <vformat_internal+0xf4>
c0de88d2:	2868      	cmp	r0, #104	@ 0x68
c0de88d4:	d002      	beq.n	c0de88dc <vformat_internal+0xf4>
c0de88d6:	2873      	cmp	r0, #115	@ 0x73
c0de88d8:	f040 82c5 	bne.w	c0de8e66 <vformat_internal+0x67e>
c0de88dc:	f857 5b04 	ldr.w	r5, [r7], #4
c0de88e0:	e7c5      	b.n	c0de886e <vformat_internal+0x86>
c0de88e2:	bf00      	nop
            switch (*format++) {
c0de88e4:	2a6b      	cmp	r2, #107	@ 0x6b
c0de88e6:	dc11      	bgt.n	c0de890c <vformat_internal+0x124>
c0de88e8:	2a62      	cmp	r2, #98	@ 0x62
c0de88ea:	dd18      	ble.n	c0de891e <vformat_internal+0x136>
c0de88ec:	2a63      	cmp	r2, #99	@ 0x63
c0de88ee:	d02a      	beq.n	c0de8946 <vformat_internal+0x15e>
c0de88f0:	2a64      	cmp	r2, #100	@ 0x64
c0de88f2:	d02d      	beq.n	c0de8950 <vformat_internal+0x168>
c0de88f4:	2a68      	cmp	r2, #104	@ 0x68
c0de88f6:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de88fa:	f040 82b4 	bne.w	c0de8e66 <vformat_internal+0x67e>
c0de88fe:	f242 0680 	movw	r6, #8320	@ 0x2080
c0de8902:	f2c0 0600 	movt	r6, #0
c0de8906:	2001      	movs	r0, #1
c0de8908:	447e      	add	r6, pc
c0de890a:	e042      	b.n	c0de8992 <vformat_internal+0x1aa>
c0de890c:	2a72      	cmp	r2, #114	@ 0x72
c0de890e:	dd0d      	ble.n	c0de892c <vformat_internal+0x144>
c0de8910:	2a73      	cmp	r2, #115	@ 0x73
c0de8912:	d029      	beq.n	c0de8968 <vformat_internal+0x180>
c0de8914:	2a75      	cmp	r2, #117	@ 0x75
c0de8916:	d02e      	beq.n	c0de8976 <vformat_internal+0x18e>
c0de8918:	2a78      	cmp	r2, #120	@ 0x78
c0de891a:	d00c      	beq.n	c0de8936 <vformat_internal+0x14e>
c0de891c:	e2a3      	b.n	c0de8e66 <vformat_internal+0x67e>
c0de891e:	2a48      	cmp	r2, #72	@ 0x48
c0de8920:	d031      	beq.n	c0de8986 <vformat_internal+0x19e>
c0de8922:	2a58      	cmp	r2, #88	@ 0x58
c0de8924:	f040 829f 	bne.w	c0de8e66 <vformat_internal+0x67e>
c0de8928:	2001      	movs	r0, #1
c0de892a:	e005      	b.n	c0de8938 <vformat_internal+0x150>
c0de892c:	2a6c      	cmp	r2, #108	@ 0x6c
c0de892e:	d059      	beq.n	c0de89e4 <vformat_internal+0x1fc>
c0de8930:	2a70      	cmp	r2, #112	@ 0x70
c0de8932:	f040 8298 	bne.w	c0de8e66 <vformat_internal+0x67e>
c0de8936:	2000      	movs	r0, #0
c0de8938:	e9cd 7004 	strd	r7, r0, [sp, #16]
c0de893c:	6838      	ldr	r0, [r7, #0]
c0de893e:	2710      	movs	r7, #16
c0de8940:	9011      	str	r0, [sp, #68]	@ 0x44
c0de8942:	2500      	movs	r5, #0
c0de8944:	e0f4      	b.n	c0de8b30 <vformat_internal+0x348>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de8946:	f857 0b04 	ldr.w	r0, [r7], #4
c0de894a:	9011      	str	r0, [sp, #68]	@ 0x44
                    output((char *) &ulValue, 1, output_ctx);
c0de894c:	a811      	add	r0, sp, #68	@ 0x44
c0de894e:	e760      	b.n	c0de8812 <vformat_internal+0x2a>
                    ulValue = va_arg(vaArgP, unsigned int);
c0de8950:	6838      	ldr	r0, [r7, #0]
c0de8952:	9704      	str	r7, [sp, #16]
                    if ((long) ulValue < 0) {
c0de8954:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
                    ulValue = va_arg(vaArgP, unsigned int);
c0de8958:	9011      	str	r0, [sp, #68]	@ 0x44
                    if ((long) ulValue < 0) {
c0de895a:	f340 80e0 	ble.w	c0de8b1e <vformat_internal+0x336>
c0de895e:	2000      	movs	r0, #0
c0de8960:	270a      	movs	r7, #10
c0de8962:	2500      	movs	r5, #0
c0de8964:	9005      	str	r0, [sp, #20]
c0de8966:	e0e0      	b.n	c0de8b2a <vformat_internal+0x342>
c0de8968:	f242 0616 	movw	r6, #8214	@ 0x2016
c0de896c:	f2c0 0600 	movt	r6, #0
c0de8970:	2000      	movs	r0, #0
c0de8972:	447e      	add	r6, pc
c0de8974:	e00d      	b.n	c0de8992 <vformat_internal+0x1aa>
                    ulValue = va_arg(vaArgP, unsigned int);
c0de8976:	6838      	ldr	r0, [r7, #0]
c0de8978:	9704      	str	r7, [sp, #16]
c0de897a:	9011      	str	r0, [sp, #68]	@ 0x44
c0de897c:	270a      	movs	r7, #10
c0de897e:	2500      	movs	r5, #0
c0de8980:	2000      	movs	r0, #0
                    goto convert;
c0de8982:	9005      	str	r0, [sp, #20]
c0de8984:	e0d4      	b.n	c0de8b30 <vformat_internal+0x348>
c0de8986:	f242 0608 	movw	r6, #8200	@ 0x2008
c0de898a:	f2c0 0600 	movt	r6, #0
c0de898e:	2001      	movs	r0, #1
c0de8990:	447e      	add	r6, pc
                    pcStr = va_arg(vaArgP, char *);
c0de8992:	f857 4b04 	ldr.w	r4, [r7], #4
                    switch (cStrlenSet) {
c0de8996:	b2c9      	uxtb	r1, r1
c0de8998:	2900      	cmp	r1, #0
c0de899a:	d05e      	beq.n	c0de8a5a <vformat_internal+0x272>
c0de899c:	2901      	cmp	r1, #1
c0de899e:	d064      	beq.n	c0de8a6a <vformat_internal+0x282>
c0de89a0:	2902      	cmp	r1, #2
c0de89a2:	d163      	bne.n	c0de8a6c <vformat_internal+0x284>
                            if (pcStr[0] == '\0') {
c0de89a4:	7820      	ldrb	r0, [r4, #0]
c0de89a6:	2800      	cmp	r0, #0
c0de89a8:	f040 825d 	bne.w	c0de8e66 <vformat_internal+0x67e>
                                for (ulCount = 0; ulCount < ulStrlen; ulCount++) {
c0de89ac:	2d00      	cmp	r5, #0
c0de89ae:	f000 8168 	beq.w	c0de8c82 <vformat_internal+0x49a>
c0de89b2:	9704      	str	r7, [sp, #16]
c0de89b4:	9f08      	ldr	r7, [sp, #32]
c0de89b6:	f641 1629 	movw	r6, #6441	@ 0x1929
c0de89ba:	f2c0 0600 	movt	r6, #0
c0de89be:	462c      	mov	r4, r5
c0de89c0:	447e      	add	r6, pc
c0de89c2:	bf00      	nop
                                    output(" ", 1, output_ctx);
c0de89c4:	4630      	mov	r0, r6
c0de89c6:	2101      	movs	r1, #1
c0de89c8:	4642      	mov	r2, r8
c0de89ca:	47b8      	blx	r7
                                for (ulCount = 0; ulCount < ulStrlen; ulCount++) {
c0de89cc:	3c01      	subs	r4, #1
c0de89ce:	d1f9      	bne.n	c0de89c4 <vformat_internal+0x1dc>
c0de89d0:	462b      	mov	r3, r5
c0de89d2:	4635      	mov	r5, r6
c0de89d4:	463e      	mov	r6, r7
c0de89d6:	9f04      	ldr	r7, [sp, #16]
c0de89d8:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
                    if (ulCount > ulIdx) {
c0de89dc:	455b      	cmp	r3, fp
c0de89de:	f67f af1d 	bls.w	c0de881c <vformat_internal+0x34>
c0de89e2:	e093      	b.n	c0de8b0c <vformat_internal+0x324>
                    if (*format == 'l'
c0de89e4:	f89a 0000 	ldrb.w	r0, [sl]
                        && (*(format + 1) == 'u' || *(format + 1) == 'd' || *(format + 1) == 'x'
c0de89e8:	286c      	cmp	r0, #108	@ 0x6c
c0de89ea:	f040 823c 	bne.w	c0de8e66 <vformat_internal+0x67e>
c0de89ee:	4656      	mov	r6, sl
c0de89f0:	f816 1f01 	ldrb.w	r1, [r6, #1]!
c0de89f4:	f1a1 0064 	sub.w	r0, r1, #100	@ 0x64
c0de89f8:	2814      	cmp	r0, #20
c0de89fa:	d807      	bhi.n	c0de8a0c <vformat_internal+0x224>
c0de89fc:	2201      	movs	r2, #1
c0de89fe:	fa02 f000 	lsl.w	r0, r2, r0
c0de8a02:	2201      	movs	r2, #1
c0de8a04:	f2c0 0212 	movt	r2, #18
c0de8a08:	4210      	tst	r0, r2
c0de8a0a:	d102      	bne.n	c0de8a12 <vformat_internal+0x22a>
c0de8a0c:	2958      	cmp	r1, #88	@ 0x58
c0de8a0e:	f040 822a 	bne.w	c0de8e66 <vformat_internal+0x67e>
                        int64_t  slValue64 = va_arg(vaArgP, int64_t);
c0de8a12:	1df8      	adds	r0, r7, #7
c0de8a14:	f020 0007 	bic.w	r0, r0, #7
c0de8a18:	4602      	mov	r2, r0
c0de8a1a:	6847      	ldr	r7, [r0, #4]
c0de8a1c:	f852 5b08 	ldr.w	r5, [r2], #8
                        if (*format == 'd') {
c0de8a20:	2974      	cmp	r1, #116	@ 0x74
c0de8a22:	dc59      	bgt.n	c0de8ad8 <vformat_internal+0x2f0>
c0de8a24:	2958      	cmp	r1, #88	@ 0x58
c0de8a26:	f000 8137 	beq.w	c0de8c98 <vformat_internal+0x4b0>
c0de8a2a:	2964      	cmp	r1, #100	@ 0x64
c0de8a2c:	f040 814f 	bne.w	c0de8cce <vformat_internal+0x4e6>
                            if (slValue64 < 0) {
c0de8a30:	f10a 0002 	add.w	r0, sl, #2
c0de8a34:	9001      	str	r0, [sp, #4]
c0de8a36:	0ff8      	lsrs	r0, r7, #31
c0de8a38:	9002      	str	r0, [sp, #8]
c0de8a3a:	eb15 70e7 	adds.w	r0, r5, r7, asr #31
c0de8a3e:	ea80 75e7 	eor.w	r5, r0, r7, asr #31
c0de8a42:	eb47 70e7 	adc.w	r0, r7, r7, asr #31
c0de8a46:	ea80 77e7 	eor.w	r7, r0, r7, asr #31
c0de8a4a:	f641 7032 	movw	r0, #7986	@ 0x1f32
c0de8a4e:	f2c0 0000 	movt	r0, #0
c0de8a52:	f04f 080a 	mov.w	r8, #10
c0de8a56:	4478      	add	r0, pc
c0de8a58:	e137      	b.n	c0de8cca <vformat_internal+0x4e2>
c0de8a5a:	2100      	movs	r1, #0
                            for (ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++) {
c0de8a5c:	5c62      	ldrb	r2, [r4, r1]
c0de8a5e:	3101      	adds	r1, #1
c0de8a60:	2a00      	cmp	r2, #0
c0de8a62:	d1fb      	bne.n	c0de8a5c <vformat_internal+0x274>
                    switch (ulBase) {
c0de8a64:	f1a1 0b01 	sub.w	fp, r1, #1
c0de8a68:	e000      	b.n	c0de8a6c <vformat_internal+0x284>
c0de8a6a:	46ab      	mov	fp, r5
c0de8a6c:	f641 0575 	movw	r5, #6261	@ 0x1875
c0de8a70:	f2c0 0500 	movt	r5, #0
c0de8a74:	447d      	add	r5, pc
c0de8a76:	b310      	cbz	r0, c0de8abe <vformat_internal+0x2d6>
                            for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de8a78:	f1bb 0f00 	cmp.w	fp, #0
c0de8a7c:	d038      	beq.n	c0de8af0 <vformat_internal+0x308>
c0de8a7e:	2100      	movs	r1, #0
c0de8a80:	2500      	movs	r5, #0
c0de8a82:	e002      	b.n	c0de8a8a <vformat_internal+0x2a2>
c0de8a84:	3501      	adds	r5, #1
c0de8a86:	45ab      	cmp	fp, r5
c0de8a88:	d01d      	beq.n	c0de8ac6 <vformat_internal+0x2de>
                                nibble1 = (pcStr[ulCount] >> 4) & 0xF;
c0de8a8a:	5d60      	ldrb	r0, [r4, r5]
c0de8a8c:	eb0e 0301 	add.w	r3, lr, r1
c0de8a90:	0902      	lsrs	r2, r0, #4
                                nibble2 = pcStr[ulCount] & 0xF;
c0de8a92:	f000 000f 	and.w	r0, r0, #15
c0de8a96:	5c30      	ldrb	r0, [r6, r0]
c0de8a98:	5cb2      	ldrb	r2, [r6, r2]
c0de8a9a:	7058      	strb	r0, [r3, #1]
                                if (idx + 1 >= sizeof(pcBuf)) {
c0de8a9c:	f1a1 001d 	sub.w	r0, r1, #29
c0de8aa0:	f80e 2001 	strb.w	r2, [lr, r1]
c0de8aa4:	f110 0f21 	cmn.w	r0, #33	@ 0x21
c0de8aa8:	f101 0102 	add.w	r1, r1, #2
c0de8aac:	d8ea      	bhi.n	c0de8a84 <vformat_internal+0x29c>
                                    output(pcBuf, idx, output_ctx);
c0de8aae:	9b08      	ldr	r3, [sp, #32]
c0de8ab0:	4670      	mov	r0, lr
c0de8ab2:	4642      	mov	r2, r8
c0de8ab4:	4798      	blx	r3
c0de8ab6:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de8aba:	2100      	movs	r1, #0
c0de8abc:	e7e2      	b.n	c0de8a84 <vformat_internal+0x29c>
c0de8abe:	9e08      	ldr	r6, [sp, #32]
                            output(pcStr, ulIdx, output_ctx);
c0de8ac0:	4620      	mov	r0, r4
c0de8ac2:	4659      	mov	r1, fp
c0de8ac4:	e019      	b.n	c0de8afa <vformat_internal+0x312>
c0de8ac6:	9e08      	ldr	r6, [sp, #32]
c0de8ac8:	f641 0517 	movw	r5, #6167	@ 0x1817
c0de8acc:	f2c0 0500 	movt	r5, #0
c0de8ad0:	465b      	mov	r3, fp
c0de8ad2:	447d      	add	r5, pc
                            if (idx != 0) {
c0de8ad4:	b981      	cbnz	r1, c0de8af8 <vformat_internal+0x310>
c0de8ad6:	e016      	b.n	c0de8b06 <vformat_internal+0x31e>
                        if (*format == 'd') {
c0de8ad8:	2975      	cmp	r1, #117	@ 0x75
c0de8ada:	f000 80ea 	beq.w	c0de8cb2 <vformat_internal+0x4ca>
c0de8ade:	2978      	cmp	r1, #120	@ 0x78
c0de8ae0:	f040 80f5 	bne.w	c0de8cce <vformat_internal+0x4e6>
                        }
c0de8ae4:	f10a 0002 	add.w	r0, sl, #2
c0de8ae8:	9001      	str	r0, [sp, #4]
c0de8aea:	f04f 0810 	mov.w	r8, #16
c0de8aee:	e0e5      	b.n	c0de8cbc <vformat_internal+0x4d4>
c0de8af0:	9e08      	ldr	r6, [sp, #32]
c0de8af2:	2300      	movs	r3, #0
c0de8af4:	2100      	movs	r1, #0
                            if (idx != 0) {
c0de8af6:	b131      	cbz	r1, c0de8b06 <vformat_internal+0x31e>
                                output(pcBuf, idx, output_ctx);
c0de8af8:	4670      	mov	r0, lr
c0de8afa:	4642      	mov	r2, r8
c0de8afc:	461c      	mov	r4, r3
c0de8afe:	47b0      	blx	r6
c0de8b00:	4623      	mov	r3, r4
c0de8b02:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
                    if (ulCount > ulIdx) {
c0de8b06:	455b      	cmp	r3, fp
c0de8b08:	f67f ae88 	bls.w	c0de881c <vformat_internal+0x34>
                        while (ulCount--) {
c0de8b0c:	ebab 0403 	sub.w	r4, fp, r3
                            output(" ", 1, output_ctx);
c0de8b10:	4628      	mov	r0, r5
c0de8b12:	2101      	movs	r1, #1
c0de8b14:	4642      	mov	r2, r8
c0de8b16:	47b0      	blx	r6
                        while (ulCount--) {
c0de8b18:	3401      	adds	r4, #1
c0de8b1a:	d3f9      	bcc.n	c0de8b10 <vformat_internal+0x328>
c0de8b1c:	e67c      	b.n	c0de8818 <vformat_internal+0x30>
                        ulValue = -(long) ((int) ulValue);
c0de8b1e:	4240      	negs	r0, r0
c0de8b20:	9011      	str	r0, [sp, #68]	@ 0x44
c0de8b22:	2000      	movs	r0, #0
c0de8b24:	9005      	str	r0, [sp, #20]
c0de8b26:	270a      	movs	r7, #10
c0de8b28:	2501      	movs	r5, #1
c0de8b2a:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de8b2e:	bf00      	nop
c0de8b30:	9911      	ldr	r1, [sp, #68]	@ 0x44
c0de8b32:	461c      	mov	r4, r3
                         (((ulIdx * ulBase) <= ulValue) && (((ulIdx * ulBase) / ulBase) == ulIdx));
c0de8b34:	428f      	cmp	r7, r1
c0de8b36:	d903      	bls.n	c0de8b40 <vformat_internal+0x358>
c0de8b38:	f04f 0b01 	mov.w	fp, #1
c0de8b3c:	2001      	movs	r0, #1
c0de8b3e:	e00e      	b.n	c0de8b5e <vformat_internal+0x376>
c0de8b40:	2302      	movs	r3, #2
c0de8b42:	463a      	mov	r2, r7
c0de8b44:	4693      	mov	fp, r2
c0de8b46:	fba7 2602 	umull	r2, r6, r7, r2
c0de8b4a:	2e00      	cmp	r6, #0
c0de8b4c:	bf18      	it	ne
c0de8b4e:	2601      	movne	r6, #1
c0de8b50:	428a      	cmp	r2, r1
c0de8b52:	4618      	mov	r0, r3
c0de8b54:	d803      	bhi.n	c0de8b5e <vformat_internal+0x376>
                    for (ulIdx = 1;
c0de8b56:	2e00      	cmp	r6, #0
c0de8b58:	f100 0301 	add.w	r3, r0, #1
c0de8b5c:	d0f2      	beq.n	c0de8b44 <vformat_internal+0x35c>
    if (*ulNeg) {
c0de8b5e:	4428      	add	r0, r5
c0de8b60:	f085 0101 	eor.w	r1, r5, #1
c0de8b64:	9506      	str	r5, [sp, #24]
    if (ulWidth > ulActualLen) {
c0de8b66:	ebb4 0800 	subs.w	r8, r4, r0
c0de8b6a:	fa5f f58c 	uxtb.w	r5, ip
c0de8b6e:	4623      	mov	r3, r4
c0de8b70:	f04f 0400 	mov.w	r4, #0
c0de8b74:	bf38      	it	cc
c0de8b76:	46a0      	movcc	r8, r4
c0de8b78:	f1b5 0230 	subs.w	r2, r5, #48	@ 0x30
c0de8b7c:	bf18      	it	ne
c0de8b7e:	2201      	movne	r2, #1
    if (*ulNeg && (cFill == '0')) {
c0de8b80:	4311      	orrs	r1, r2
c0de8b82:	d105      	bne.n	c0de8b90 <vformat_internal+0x3a8>
        pcBuf[(*ulPos)++] = '-';
c0de8b84:	212d      	movs	r1, #45	@ 0x2d
c0de8b86:	f88d 1024 	strb.w	r1, [sp, #36]	@ 0x24
c0de8b8a:	2100      	movs	r1, #0
c0de8b8c:	2401      	movs	r4, #1
c0de8b8e:	9106      	str	r1, [sp, #24]
c0de8b90:	9e08      	ldr	r6, [sp, #32]
    while (ulPaddingNeeded > 0) {
c0de8b92:	4298      	cmp	r0, r3
c0de8b94:	d314      	bcc.n	c0de8bc0 <vformat_internal+0x3d8>
    if (*ulNeg) {
c0de8b96:	9806      	ldr	r0, [sp, #24]
c0de8b98:	b388      	cbz	r0, c0de8bfe <vformat_internal+0x416>
        if (*ulPos >= PCBUF_SIZE) {
c0de8b9a:	2c20      	cmp	r4, #32
c0de8b9c:	d335      	bcc.n	c0de8c0a <vformat_internal+0x422>
c0de8b9e:	f8dd 801c 	ldr.w	r8, [sp, #28]
            output(pcBuf, *ulPos, output_ctx);
c0de8ba2:	4670      	mov	r0, lr
c0de8ba4:	4621      	mov	r1, r4
c0de8ba6:	4642      	mov	r2, r8
c0de8ba8:	47b0      	blx	r6
c0de8baa:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de8bae:	2400      	movs	r4, #0
c0de8bb0:	e02d      	b.n	c0de8c0e <vformat_internal+0x426>
c0de8bb2:	bf00      	nop
c0de8bb4:	9e08      	ldr	r6, [sp, #32]
c0de8bb6:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
    while (ulPaddingNeeded > 0) {
c0de8bba:	f1b8 0f00 	cmp.w	r8, #0
c0de8bbe:	d0ea      	beq.n	c0de8b96 <vformat_internal+0x3ae>
        unsigned long bufferSpace = PCBUF_SIZE - *ulPos;
c0de8bc0:	f1c4 0620 	rsb	r6, r4, #32
        if (chunkSize > bufferSpace) {
c0de8bc4:	45b0      	cmp	r8, r6
c0de8bc6:	bf98      	it	ls
c0de8bc8:	4646      	movls	r6, r8
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de8bca:	b136      	cbz	r6, c0de8bda <vformat_internal+0x3f2>
c0de8bcc:	eb0e 0004 	add.w	r0, lr, r4
            pcBuf[(*ulPos)++] = cFill;
c0de8bd0:	4631      	mov	r1, r6
c0de8bd2:	462a      	mov	r2, r5
c0de8bd4:	f000 fb80 	bl	c0de92d8 <__aeabi_memset>
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de8bd8:	4434      	add	r4, r6
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de8bda:	2c20      	cmp	r4, #32
        ulPaddingNeeded -= chunkSize;
c0de8bdc:	eba8 0806 	sub.w	r8, r8, r6
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de8be0:	d3e8      	bcc.n	c0de8bb4 <vformat_internal+0x3cc>
c0de8be2:	9e08      	ldr	r6, [sp, #32]
c0de8be4:	f1b8 0f00 	cmp.w	r8, #0
c0de8be8:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de8bec:	d0e5      	beq.n	c0de8bba <vformat_internal+0x3d2>
            output(pcBuf, *ulPos, output_ctx);
c0de8bee:	9a07      	ldr	r2, [sp, #28]
c0de8bf0:	4670      	mov	r0, lr
c0de8bf2:	4621      	mov	r1, r4
c0de8bf4:	47b0      	blx	r6
c0de8bf6:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de8bfa:	2400      	movs	r4, #0
c0de8bfc:	e7dd      	b.n	c0de8bba <vformat_internal+0x3d2>
c0de8bfe:	f8dd 801c 	ldr.w	r8, [sp, #28]
                    for (; ulIdx; ulIdx /= ulBase) {
c0de8c02:	f1bb 0f00 	cmp.w	fp, #0
c0de8c06:	d109      	bne.n	c0de8c1c <vformat_internal+0x434>
c0de8c08:	e032      	b.n	c0de8c70 <vformat_internal+0x488>
c0de8c0a:	f8dd 801c 	ldr.w	r8, [sp, #28]
        pcBuf[(*ulPos)++] = '-';
c0de8c0e:	202d      	movs	r0, #45	@ 0x2d
c0de8c10:	f80e 0004 	strb.w	r0, [lr, r4]
c0de8c14:	3401      	adds	r4, #1
                    for (; ulIdx; ulIdx /= ulBase) {
c0de8c16:	f1bb 0f00 	cmp.w	fp, #0
c0de8c1a:	d029      	beq.n	c0de8c70 <vformat_internal+0x488>
c0de8c1c:	9805      	ldr	r0, [sp, #20]
c0de8c1e:	f641 556c 	movw	r5, #7532	@ 0x1d6c
c0de8c22:	2800      	cmp	r0, #0
c0de8c24:	f2c0 0500 	movt	r5, #0
c0de8c28:	f641 5056 	movw	r0, #7510	@ 0x1d56
c0de8c2c:	447d      	add	r5, pc
c0de8c2e:	f2c0 0000 	movt	r0, #0
c0de8c32:	4478      	add	r0, pc
c0de8c34:	bf08      	it	eq
c0de8c36:	4605      	moveq	r5, r0
c0de8c38:	e010      	b.n	c0de8c5c <vformat_internal+0x474>
c0de8c3a:	bf00      	nop
c0de8c3c:	9811      	ldr	r0, [sp, #68]	@ 0x44
c0de8c3e:	455f      	cmp	r7, fp
c0de8c40:	fbb0 f0fb 	udiv	r0, r0, fp
c0de8c44:	fbbb fbf7 	udiv	fp, fp, r7
c0de8c48:	fbb0 f1f7 	udiv	r1, r0, r7
c0de8c4c:	fb01 0017 	mls	r0, r1, r7, r0
c0de8c50:	5c28      	ldrb	r0, [r5, r0]
c0de8c52:	f80e 0004 	strb.w	r0, [lr, r4]
c0de8c56:	f104 0401 	add.w	r4, r4, #1
c0de8c5a:	d809      	bhi.n	c0de8c70 <vformat_internal+0x488>
                        if (ulPos >= PCBUF_SIZE) {
c0de8c5c:	2c20      	cmp	r4, #32
c0de8c5e:	d3ed      	bcc.n	c0de8c3c <vformat_internal+0x454>
                            output(pcBuf, ulPos, output_ctx);
c0de8c60:	4670      	mov	r0, lr
c0de8c62:	4621      	mov	r1, r4
c0de8c64:	4642      	mov	r2, r8
c0de8c66:	47b0      	blx	r6
c0de8c68:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de8c6c:	2400      	movs	r4, #0
c0de8c6e:	e7e5      	b.n	c0de8c3c <vformat_internal+0x454>
c0de8c70:	9f04      	ldr	r7, [sp, #16]
                    if (ulPos > 0) {
c0de8c72:	2c00      	cmp	r4, #0
c0de8c74:	f107 0704 	add.w	r7, r7, #4
c0de8c78:	f43f add0 	beq.w	c0de881c <vformat_internal+0x34>
                        output(pcBuf, ulPos, output_ctx);
c0de8c7c:	4670      	mov	r0, lr
c0de8c7e:	4621      	mov	r1, r4
c0de8c80:	e5c8      	b.n	c0de8814 <vformat_internal+0x2c>
c0de8c82:	9e08      	ldr	r6, [sp, #32]
c0de8c84:	f241 655b 	movw	r5, #5723	@ 0x165b
c0de8c88:	f2c0 0500 	movt	r5, #0
c0de8c8c:	2300      	movs	r3, #0
c0de8c8e:	447d      	add	r5, pc
                    if (ulCount > ulIdx) {
c0de8c90:	455b      	cmp	r3, fp
c0de8c92:	f67f adc3 	bls.w	c0de881c <vformat_internal+0x34>
c0de8c96:	e739      	b.n	c0de8b0c <vformat_internal+0x324>
                        }
c0de8c98:	f10a 0002 	add.w	r0, sl, #2
c0de8c9c:	9001      	str	r0, [sp, #4]
c0de8c9e:	2000      	movs	r0, #0
c0de8ca0:	9002      	str	r0, [sp, #8]
c0de8ca2:	f641 40ea 	movw	r0, #7402	@ 0x1cea
c0de8ca6:	f2c0 0000 	movt	r0, #0
c0de8caa:	f04f 0810 	mov.w	r8, #16
c0de8cae:	4478      	add	r0, pc
c0de8cb0:	e00b      	b.n	c0de8cca <vformat_internal+0x4e2>
                        }
c0de8cb2:	f10a 0002 	add.w	r0, sl, #2
c0de8cb6:	f04f 080a 	mov.w	r8, #10
c0de8cba:	9001      	str	r0, [sp, #4]
c0de8cbc:	2000      	movs	r0, #0
c0de8cbe:	9002      	str	r0, [sp, #8]
c0de8cc0:	f641 40c0 	movw	r0, #7360	@ 0x1cc0
c0de8cc4:	f2c0 0000 	movt	r0, #0
c0de8cc8:	4478      	add	r0, pc
c0de8cca:	9005      	str	r0, [sp, #20]
c0de8ccc:	e00c      	b.n	c0de8ce8 <vformat_internal+0x500>
c0de8cce:	2000      	movs	r0, #0
c0de8cd0:	9601      	str	r6, [sp, #4]
c0de8cd2:	9002      	str	r0, [sp, #8]
c0de8cd4:	f641 40ac 	movw	r0, #7340	@ 0x1cac
c0de8cd8:	f2c0 0000 	movt	r0, #0
c0de8cdc:	4478      	add	r0, pc
c0de8cde:	f04f 080a 	mov.w	r8, #10
c0de8ce2:	9005      	str	r0, [sp, #20]
c0de8ce4:	2500      	movs	r5, #0
c0de8ce6:	2700      	movs	r7, #0
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de8ce8:	ebb5 0008 	subs.w	r0, r5, r8
c0de8cec:	f04f 0a00 	mov.w	sl, #0
c0de8cf0:	469b      	mov	fp, r3
c0de8cf2:	f177 0000 	sbcs.w	r0, r7, #0
c0de8cf6:	f04f 0400 	mov.w	r4, #0
c0de8cfa:	9204      	str	r2, [sp, #16]
c0de8cfc:	9506      	str	r5, [sp, #24]
c0de8cfe:	9703      	str	r7, [sp, #12]
                                           && (((ulIdx64 * ulBase) / ulBase) == ulIdx64));
c0de8d00:	d203      	bcs.n	c0de8d0a <vformat_internal+0x522>
c0de8d02:	2201      	movs	r2, #1
c0de8d04:	2501      	movs	r5, #1
c0de8d06:	2700      	movs	r7, #0
c0de8d08:	e01a      	b.n	c0de8d40 <vformat_internal+0x558>
c0de8d0a:	2100      	movs	r1, #0
c0de8d0c:	f04f 0e02 	mov.w	lr, #2
c0de8d10:	4643      	mov	r3, r8
c0de8d12:	bf00      	nop
c0de8d14:	460f      	mov	r7, r1
c0de8d16:	461d      	mov	r5, r3
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de8d18:	fba8 3003 	umull	r3, r0, r8, r3
c0de8d1c:	fba1 1608 	umull	r1, r6, r1, r8
c0de8d20:	1809      	adds	r1, r1, r0
c0de8d22:	f14a 0000 	adc.w	r0, sl, #0
c0de8d26:	2e00      	cmp	r6, #0
c0de8d28:	bf18      	it	ne
c0de8d2a:	2601      	movne	r6, #1
c0de8d2c:	9a06      	ldr	r2, [sp, #24]
c0de8d2e:	1ad2      	subs	r2, r2, r3
c0de8d30:	9a03      	ldr	r2, [sp, #12]
c0de8d32:	418a      	sbcs	r2, r1
c0de8d34:	4672      	mov	r2, lr
                                           && (((ulIdx64 * ulBase) / ulBase) == ulIdx64));
c0de8d36:	d303      	bcc.n	c0de8d40 <vformat_internal+0x558>
c0de8d38:	4330      	orrs	r0, r6
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de8d3a:	f102 0e01 	add.w	lr, r2, #1
c0de8d3e:	d0e9      	beq.n	c0de8d14 <vformat_internal+0x52c>
c0de8d40:	9802      	ldr	r0, [sp, #8]
    if (*ulNeg) {
c0de8d42:	1811      	adds	r1, r2, r0
    if (ulWidth > ulActualLen) {
c0de8d44:	ebbb 0a01 	subs.w	sl, fp, r1
c0de8d48:	fa5f f28c 	uxtb.w	r2, ip
c0de8d4c:	bf38      	it	cc
c0de8d4e:	46a2      	movcc	sl, r4
c0de8d50:	4616      	mov	r6, r2
    if (*ulNeg && (cFill == '0')) {
c0de8d52:	2a30      	cmp	r2, #48	@ 0x30
c0de8d54:	d15d      	bne.n	c0de8e12 <vformat_internal+0x62a>
c0de8d56:	2800      	cmp	r0, #0
c0de8d58:	a809      	add	r0, sp, #36	@ 0x24
c0de8d5a:	d005      	beq.n	c0de8d68 <vformat_internal+0x580>
        pcBuf[(*ulPos)++] = '-';
c0de8d5c:	222d      	movs	r2, #45	@ 0x2d
c0de8d5e:	f88d 2024 	strb.w	r2, [sp, #36]	@ 0x24
c0de8d62:	2200      	movs	r2, #0
c0de8d64:	2401      	movs	r4, #1
c0de8d66:	9202      	str	r2, [sp, #8]
    while (ulPaddingNeeded > 0) {
c0de8d68:	4559      	cmp	r1, fp
c0de8d6a:	d35b      	bcc.n	c0de8e24 <vformat_internal+0x63c>
    if (*ulNeg) {
c0de8d6c:	9902      	ldr	r1, [sp, #8]
c0de8d6e:	b169      	cbz	r1, c0de8d8c <vformat_internal+0x5a4>
c0de8d70:	f8dd a00c 	ldr.w	sl, [sp, #12]
        if (*ulPos >= PCBUF_SIZE) {
c0de8d74:	2c20      	cmp	r4, #32
c0de8d76:	d305      	bcc.n	c0de8d84 <vformat_internal+0x59c>
            output(pcBuf, *ulPos, output_ctx);
c0de8d78:	e9dd 2307 	ldrd	r2, r3, [sp, #28]
c0de8d7c:	4621      	mov	r1, r4
c0de8d7e:	4798      	blx	r3
c0de8d80:	a809      	add	r0, sp, #36	@ 0x24
c0de8d82:	2400      	movs	r4, #0
        pcBuf[(*ulPos)++] = '-';
c0de8d84:	212d      	movs	r1, #45	@ 0x2d
c0de8d86:	5501      	strb	r1, [r0, r4]
c0de8d88:	3401      	adds	r4, #1
c0de8d8a:	e001      	b.n	c0de8d90 <vformat_internal+0x5a8>
c0de8d8c:	f8dd a00c 	ldr.w	sl, [sp, #12]
c0de8d90:	f8dd b020 	ldr.w	fp, [sp, #32]
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de8d94:	ea55 0007 	orrs.w	r0, r5, r7
c0de8d98:	d129      	bne.n	c0de8dee <vformat_internal+0x606>
                        if (ulPos > 0) {
c0de8d9a:	b38c      	cbz	r4, c0de8e00 <vformat_internal+0x618>
c0de8d9c:	f8dd 801c 	ldr.w	r8, [sp, #28]
c0de8da0:	ad09      	add	r5, sp, #36	@ 0x24
                            output(pcBuf, ulPos, output_ctx);
c0de8da2:	4628      	mov	r0, r5
c0de8da4:	4621      	mov	r1, r4
c0de8da6:	4642      	mov	r2, r8
c0de8da8:	465e      	mov	r6, fp
c0de8daa:	47d8      	blx	fp
c0de8dac:	f8dd a004 	ldr.w	sl, [sp, #4]
c0de8db0:	9f04      	ldr	r7, [sp, #16]
c0de8db2:	46ae      	mov	lr, r5
c0de8db4:	e532      	b.n	c0de881c <vformat_internal+0x34>
c0de8db6:	bf00      	nop
c0de8db8:	9806      	ldr	r0, [sp, #24]
c0de8dba:	4651      	mov	r1, sl
c0de8dbc:	462a      	mov	r2, r5
c0de8dbe:	463b      	mov	r3, r7
c0de8dc0:	f000 fa94 	bl	c0de92ec <__aeabi_uldivmod>
c0de8dc4:	4642      	mov	r2, r8
c0de8dc6:	2300      	movs	r3, #0
c0de8dc8:	f000 fa90 	bl	c0de92ec <__aeabi_uldivmod>
c0de8dcc:	9805      	ldr	r0, [sp, #20]
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de8dce:	4639      	mov	r1, r7
c0de8dd0:	5c80      	ldrb	r0, [r0, r2]
c0de8dd2:	4642      	mov	r2, r8
c0de8dd4:	5530      	strb	r0, [r6, r4]
c0de8dd6:	4628      	mov	r0, r5
c0de8dd8:	2300      	movs	r3, #0
c0de8dda:	3401      	adds	r4, #1
c0de8ddc:	f000 fa86 	bl	c0de92ec <__aeabi_uldivmod>
c0de8de0:	ebb5 0208 	subs.w	r2, r5, r8
c0de8de4:	f177 0200 	sbcs.w	r2, r7, #0
c0de8de8:	4605      	mov	r5, r0
c0de8dea:	460f      	mov	r7, r1
c0de8dec:	d3d5      	bcc.n	c0de8d9a <vformat_internal+0x5b2>
c0de8dee:	ae09      	add	r6, sp, #36	@ 0x24
                            if (ulPos >= PCBUF_SIZE) {
c0de8df0:	2c20      	cmp	r4, #32
c0de8df2:	d3e1      	bcc.n	c0de8db8 <vformat_internal+0x5d0>
                                output(pcBuf, ulPos, output_ctx);
c0de8df4:	9a07      	ldr	r2, [sp, #28]
c0de8df6:	4630      	mov	r0, r6
c0de8df8:	4621      	mov	r1, r4
c0de8dfa:	47d8      	blx	fp
c0de8dfc:	2400      	movs	r4, #0
c0de8dfe:	e7db      	b.n	c0de8db8 <vformat_internal+0x5d0>
c0de8e00:	f8dd a004 	ldr.w	sl, [sp, #4]
c0de8e04:	f8dd 801c 	ldr.w	r8, [sp, #28]
c0de8e08:	9f04      	ldr	r7, [sp, #16]
c0de8e0a:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de8e0e:	465e      	mov	r6, fp
c0de8e10:	e504      	b.n	c0de881c <vformat_internal+0x34>
c0de8e12:	a809      	add	r0, sp, #36	@ 0x24
    while (ulPaddingNeeded > 0) {
c0de8e14:	4559      	cmp	r1, fp
c0de8e16:	d305      	bcc.n	c0de8e24 <vformat_internal+0x63c>
c0de8e18:	e7a8      	b.n	c0de8d6c <vformat_internal+0x584>
c0de8e1a:	bf00      	nop
c0de8e1c:	a809      	add	r0, sp, #36	@ 0x24
c0de8e1e:	f1ba 0f00 	cmp.w	sl, #0
c0de8e22:	d0a3      	beq.n	c0de8d6c <vformat_internal+0x584>
        unsigned long bufferSpace = PCBUF_SIZE - *ulPos;
c0de8e24:	f1c4 0b20 	rsb	fp, r4, #32
        if (chunkSize > bufferSpace) {
c0de8e28:	45da      	cmp	sl, fp
c0de8e2a:	bf98      	it	ls
c0de8e2c:	46d3      	movls	fp, sl
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de8e2e:	f1bb 0f00 	cmp.w	fp, #0
c0de8e32:	d005      	beq.n	c0de8e40 <vformat_internal+0x658>
c0de8e34:	4420      	add	r0, r4
            pcBuf[(*ulPos)++] = cFill;
c0de8e36:	4659      	mov	r1, fp
c0de8e38:	4632      	mov	r2, r6
c0de8e3a:	f000 fa4d 	bl	c0de92d8 <__aeabi_memset>
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de8e3e:	445c      	add	r4, fp
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de8e40:	2c20      	cmp	r4, #32
        ulPaddingNeeded -= chunkSize;
c0de8e42:	ebaa 0a0b 	sub.w	sl, sl, fp
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de8e46:	d3e9      	bcc.n	c0de8e1c <vformat_internal+0x634>
c0de8e48:	f1ba 0f00 	cmp.w	sl, #0
c0de8e4c:	a809      	add	r0, sp, #36	@ 0x24
c0de8e4e:	d0e6      	beq.n	c0de8e1e <vformat_internal+0x636>
            output(pcBuf, *ulPos, output_ctx);
c0de8e50:	e9dd 2307 	ldrd	r2, r3, [sp, #28]
c0de8e54:	4621      	mov	r1, r4
c0de8e56:	4798      	blx	r3
c0de8e58:	a809      	add	r0, sp, #36	@ 0x24
c0de8e5a:	2400      	movs	r4, #0
c0de8e5c:	e7df      	b.n	c0de8e1e <vformat_internal+0x636>
c0de8e5e:	2000      	movs	r0, #0
}
c0de8e60:	b012      	add	sp, #72	@ 0x48
c0de8e62:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de8e66:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de8e6a:	b012      	add	sp, #72	@ 0x48
c0de8e6c:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de8e70 <snprintf>:

#endif  // HAVE_PRINTF

#ifdef HAVE_SPRINTF
int snprintf(char *str, size_t str_size, const char *format, ...)
{
c0de8e70:	b081      	sub	sp, #4
c0de8e72:	b570      	push	{r4, r5, r6, lr}
c0de8e74:	b085      	sub	sp, #20
c0de8e76:	4605      	mov	r5, r0
    va_list       vaArgP;
    sprintf_ctx_t ctx;
    int           result;

    if (str == NULL || str_size < 1) {
c0de8e78:	2800      	cmp	r0, #0
c0de8e7a:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de8e7e:	9309      	str	r3, [sp, #36]	@ 0x24
c0de8e80:	d01d      	beq.n	c0de8ebe <snprintf+0x4e>
c0de8e82:	460e      	mov	r6, r1
c0de8e84:	b1d9      	cbz	r1, c0de8ebe <snprintf+0x4e>
        return -1;  // Error: invalid arguments
    }

    memset(str, 0, str_size);
c0de8e86:	4628      	mov	r0, r5
c0de8e88:	4631      	mov	r1, r6
c0de8e8a:	4614      	mov	r4, r2
c0de8e8c:	f000 fa2a 	bl	c0de92e4 <__aeabi_memclr>
    // Reserve space for null terminator
    str_size--;
c0de8e90:	1e70      	subs	r0, r6, #1

    ctx.str      = str;
c0de8e92:	e9cd 5001 	strd	r5, r0, [sp, #4]
c0de8e96:	2000      	movs	r0, #0
c0de8e98:	ab09      	add	r3, sp, #36	@ 0x24
    ctx.str_size = str_size;
    ctx.written  = 0;  // Initialize counter
c0de8e9a:	9003      	str	r0, [sp, #12]

    va_start(vaArgP, format);
c0de8e9c:	9304      	str	r3, [sp, #16]
    result = vformat_internal(sprintf_output, &ctx, format, vaArgP);
c0de8e9e:	f240 001f 	movw	r0, #31
c0de8ea2:	f2c0 0000 	movt	r0, #0
c0de8ea6:	4478      	add	r0, pc
c0de8ea8:	a901      	add	r1, sp, #4
c0de8eaa:	4622      	mov	r2, r4
c0de8eac:	f7ff fc9c 	bl	c0de87e8 <vformat_internal>
c0de8eb0:	4601      	mov	r1, r0
c0de8eb2:	9803      	ldr	r0, [sp, #12]
    va_end(vaArgP);

    // If format error, return -1
    if (result < 0) {
c0de8eb4:	f1b1 3fff 	cmp.w	r1, #4294967295	@ 0xffffffff
c0de8eb8:	bfd8      	it	le
c0de8eba:	f04f 30ff 	movle.w	r0, #4294967295	@ 0xffffffff
        return -1;
    }
    return ctx.written;  // Return number of characters written
}
c0de8ebe:	b005      	add	sp, #20
c0de8ec0:	e8bd 4070 	ldmia.w	sp!, {r4, r5, r6, lr}
c0de8ec4:	b001      	add	sp, #4
c0de8ec6:	4770      	bx	lr

c0de8ec8 <sprintf_output>:
{
c0de8ec8:	b5b0      	push	{r4, r5, r7, lr}
c0de8eca:	4614      	mov	r4, r2
c0de8ecc:	4602      	mov	r2, r0
    if (ctx->str_size == 0) {
c0de8ece:	e9d4 5001 	ldrd	r5, r0, [r4, #4]
    ctx->written += len;
c0de8ed2:	4408      	add	r0, r1
    if (ctx->str_size == 0) {
c0de8ed4:	2d00      	cmp	r5, #0
    ctx->written += len;
c0de8ed6:	60a0      	str	r0, [r4, #8]
}
c0de8ed8:	bf08      	it	eq
c0de8eda:	bdb0      	popeq	{r4, r5, r7, pc}
    memmove(ctx->str, data, len);
c0de8edc:	6820      	ldr	r0, [r4, #0]
    len = MIN(len, ctx->str_size);
c0de8ede:	428d      	cmp	r5, r1
c0de8ee0:	bf88      	it	hi
c0de8ee2:	460d      	movhi	r5, r1
    memmove(ctx->str, data, len);
c0de8ee4:	4611      	mov	r1, r2
c0de8ee6:	462a      	mov	r2, r5
c0de8ee8:	f000 f9f4 	bl	c0de92d4 <__aeabi_memmove>
    ctx->str += len;
c0de8eec:	e9d4 0100 	ldrd	r0, r1, [r4]
c0de8ef0:	4428      	add	r0, r5
    ctx->str_size -= len;
c0de8ef2:	1b49      	subs	r1, r1, r5
    ctx->str += len;
c0de8ef4:	e9c4 0100 	strd	r0, r1, [r4]
}
c0de8ef8:	bdb0      	pop	{r4, r5, r7, pc}
	...

c0de8efc <pic>:
void *pic(void *link_address)
{
    void *n, *en;

    // check if in the LINKED TEXT zone
    __asm volatile("ldr %0, =_nvram" : "=r"(n));
c0de8efc:	490a      	ldr	r1, [pc, #40]	@ (c0de8f28 <pic+0x2c>)
    __asm volatile("ldr %0, =_envram" : "=r"(en));
    if (link_address >= n && link_address <= en) {
c0de8efe:	4281      	cmp	r1, r0
    __asm volatile("ldr %0, =_envram" : "=r"(en));
c0de8f00:	490a      	ldr	r1, [pc, #40]	@ (c0de8f2c <pic+0x30>)
    if (link_address >= n && link_address <= en) {
c0de8f02:	d806      	bhi.n	c0de8f12 <pic+0x16>
c0de8f04:	4281      	cmp	r1, r0
c0de8f06:	d304      	bcc.n	c0de8f12 <pic+0x16>
c0de8f08:	b580      	push	{r7, lr}
        link_address = pic_internal(link_address);
c0de8f0a:	f000 f815 	bl	c0de8f38 <pic_internal>
c0de8f0e:	e8bd 4080 	ldmia.w	sp!, {r7, lr}
    }

#ifndef BOLOS_OS_UPGRADER_APP
    // check if in the LINKED RAM zone
    __asm volatile("ldr %0, =_bss" : "=r"(n));
c0de8f12:	4907      	ldr	r1, [pc, #28]	@ (c0de8f30 <pic+0x34>)
    __asm volatile("ldr %0, =_estack" : "=r"(en));
    if (link_address >= n && link_address <= en) {
c0de8f14:	4288      	cmp	r0, r1
    __asm volatile("ldr %0, =_estack" : "=r"(en));
c0de8f16:	4a07      	ldr	r2, [pc, #28]	@ (c0de8f34 <pic+0x38>)
    if (link_address >= n && link_address <= en) {
c0de8f18:	d305      	bcc.n	c0de8f26 <pic+0x2a>
c0de8f1a:	4290      	cmp	r0, r2
        // deref into the RAM therefore add the RAM offset from R9
        link_address = (char *) link_address - (char *) n + (char *) en;
    }
#endif  // BOLOS_OS_UPGRADER_APP

    return link_address;
c0de8f1c:	bf88      	it	hi
c0de8f1e:	4770      	bxhi	lr
        link_address = (char *) link_address - (char *) n + (char *) en;
c0de8f20:	1a40      	subs	r0, r0, r1
        __asm volatile("mov %0, r9" : "=r"(en));
c0de8f22:	464a      	mov	r2, r9
        link_address = (char *) link_address - (char *) n + (char *) en;
c0de8f24:	4410      	add	r0, r2
    return link_address;
c0de8f26:	4770      	bx	lr
c0de8f28:	c0de0000 	.word	0xc0de0000
c0de8f2c:	c0deab0b 	.word	0xc0deab0b
c0de8f30:	da7a0000 	.word	0xda7a0000
c0de8f34:	da7a9000 	.word	0xda7a9000

c0de8f38 <pic_internal>:
    __asm volatile("mov r2, pc\n");
c0de8f38:	467a      	mov	r2, pc
    __asm volatile("ldr r1, =pic_internal\n");
c0de8f3a:	4902      	ldr	r1, [pc, #8]	@ (c0de8f44 <pic_internal+0xc>)
    __asm volatile("adds r1, r1, #3\n");
c0de8f3c:	1cc9      	adds	r1, r1, #3
    __asm volatile("subs r1, r1, r2\n");
c0de8f3e:	1a89      	subs	r1, r1, r2
    __asm volatile("subs r0, r0, r1\n");
c0de8f40:	1a40      	subs	r0, r0, r1
    __asm volatile("bx lr\n");
c0de8f42:	4770      	bx	lr
c0de8f44:	c0de8f39 	.word	0xc0de8f39

c0de8f48 <SVC_Call>:
c0de8f48:	df01      	svc	1
c0de8f4a:	2900      	cmp	r1, #0
c0de8f4c:	d100      	bne.n	c0de8f50 <exception>
c0de8f4e:	4770      	bx	lr

c0de8f50 <exception>:
c0de8f50:	4608      	mov	r0, r1
c0de8f52:	f7ff f92a 	bl	c0de81aa <os_longjmp>

c0de8f56 <nbgl_wait_pipeline>:
    SVC_Call(SYSCALL_nbgl_screen_reinit_ID, parameters);
}

#ifdef HAVE_SE_EINK_DISPLAY
void nbgl_wait_pipeline(void)
{
c0de8f56:	b580      	push	{r7, lr}
c0de8f58:	b082      	sub	sp, #8
c0de8f5a:	2000      	movs	r0, #0
    unsigned int parameters[1];
    parameters[0] = 0;
c0de8f5c:	9001      	str	r0, [sp, #4]
c0de8f5e:	2011      	movs	r0, #17
c0de8f60:	f2c0 00fa 	movt	r0, #250	@ 0xfa
c0de8f64:	a901      	add	r1, sp, #4
    SVC_Call(SYSCALL_nbgl_wait_pipeline_ID, parameters);
c0de8f66:	f7ff ffef 	bl	c0de8f48 <SVC_Call>
}
c0de8f6a:	b002      	add	sp, #8
c0de8f6c:	bd80      	pop	{r7, pc}

c0de8f6e <os_pki_load_certificate>:
                                    uint8_t                  *certificate,
                                    size_t                    certificate_len,
                                    uint8_t                  *trusted_name,
                                    size_t                   *trusted_name_len,
                                    cx_ecfp_384_public_key_t *public_key)
{
c0de8f6e:	b580      	push	{r7, lr}
c0de8f70:	b086      	sub	sp, #24
c0de8f72:	e9dd ec08 	ldrd	lr, ip, [sp, #32]
    unsigned int parameters[6];
    parameters[0] = (unsigned int) expected_key_usage;
c0de8f76:	e88d 400f 	stmia.w	sp, {r0, r1, r2, r3, lr}
c0de8f7a:	20aa      	movs	r0, #170	@ 0xaa
c0de8f7c:	f2c0 6000 	movt	r0, #1536	@ 0x600
c0de8f80:	4669      	mov	r1, sp
    parameters[1] = (unsigned int) certificate;
    parameters[2] = (unsigned int) certificate_len;
    parameters[3] = (unsigned int) trusted_name;
    parameters[4] = (unsigned int) trusted_name_len;
    parameters[5] = (unsigned int) public_key;
c0de8f82:	f8cd c014 	str.w	ip, [sp, #20]
    return (bolos_err_t) SVC_Call(SYSCALL_os_pki_load_certificate_ID, parameters);
c0de8f86:	f7ff ffdf 	bl	c0de8f48 <SVC_Call>
c0de8f8a:	b006      	add	sp, #24
c0de8f8c:	bd80      	pop	{r7, pc}

c0de8f8e <os_perso_is_pin_set>:
    SVC_Call(SYSCALL_os_perso_set_current_identity_pin_ID, parameters);
    return;
}

bolos_bool_t os_perso_is_pin_set(void)
{
c0de8f8e:	b580      	push	{r7, lr}
c0de8f90:	b082      	sub	sp, #8
c0de8f92:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de8f94:	9001      	str	r0, [sp, #4]
c0de8f96:	4669      	mov	r1, sp
    return (bolos_bool_t) SVC_Call(SYSCALL_os_perso_is_pin_set_ID, parameters);
c0de8f98:	209e      	movs	r0, #158	@ 0x9e
c0de8f9a:	f7ff ffd5 	bl	c0de8f48 <SVC_Call>
c0de8f9e:	b2c0      	uxtb	r0, r0
c0de8fa0:	b002      	add	sp, #8
c0de8fa2:	bd80      	pop	{r7, pc}

c0de8fa4 <os_global_pin_is_validated>:
}

bolos_bool_t os_global_pin_is_validated(void)
{
c0de8fa4:	b580      	push	{r7, lr}
c0de8fa6:	b082      	sub	sp, #8
c0de8fa8:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de8faa:	9001      	str	r0, [sp, #4]
c0de8fac:	4669      	mov	r1, sp
    return (bolos_bool_t) SVC_Call(SYSCALL_os_global_pin_is_validated_ID, parameters);
c0de8fae:	20a0      	movs	r0, #160	@ 0xa0
c0de8fb0:	f7ff ffca 	bl	c0de8f48 <SVC_Call>
c0de8fb4:	b2c0      	uxtb	r0, r0
c0de8fb6:	b002      	add	sp, #8
c0de8fb8:	bd80      	pop	{r7, pc}

c0de8fba <os_ux>:
    SVC_Call(SYSCALL_os_registry_get_ID, parameters);
    return;
}

unsigned int os_ux(bolos_ux_params_t *params)
{
c0de8fba:	b580      	push	{r7, lr}
c0de8fbc:	b082      	sub	sp, #8
    unsigned int parameters[2];
    parameters[0] = (unsigned int) params;
c0de8fbe:	9000      	str	r0, [sp, #0]
c0de8fc0:	2000      	movs	r0, #0
    parameters[1] = 0;
c0de8fc2:	9001      	str	r0, [sp, #4]
c0de8fc4:	2064      	movs	r0, #100	@ 0x64
c0de8fc6:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de8fca:	4669      	mov	r1, sp
    return (unsigned int) SVC_Call(SYSCALL_os_ux_ID, parameters);
c0de8fcc:	f7ff ffbc 	bl	c0de8f48 <SVC_Call>
c0de8fd0:	b002      	add	sp, #8
c0de8fd2:	bd80      	pop	{r7, pc}

c0de8fd4 <os_flags>:
    // remove the warning caused by -Winvalid-noreturn
    __builtin_unreachable();
}

unsigned int os_flags(void)
{
c0de8fd4:	b580      	push	{r7, lr}
c0de8fd6:	b082      	sub	sp, #8
c0de8fd8:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de8fda:	9001      	str	r0, [sp, #4]
c0de8fdc:	4669      	mov	r1, sp
    return (unsigned int) SVC_Call(SYSCALL_os_flags_ID, parameters);
c0de8fde:	206a      	movs	r0, #106	@ 0x6a
c0de8fe0:	f7ff ffb2 	bl	c0de8f48 <SVC_Call>
c0de8fe4:	b002      	add	sp, #8
c0de8fe6:	bd80      	pop	{r7, pc}

c0de8fe8 <os_setting_get>:
    parameters[2] = (unsigned int) maxlength;
    return (unsigned int) SVC_Call(SYSCALL_os_factory_setting_get_ID, parameters);
}

unsigned int os_setting_get(unsigned int setting_id, unsigned char *value, unsigned int maxlen)
{
c0de8fe8:	b580      	push	{r7, lr}
c0de8fea:	b084      	sub	sp, #16
    unsigned int parameters[3];
    parameters[0] = (unsigned int) setting_id;
c0de8fec:	ab01      	add	r3, sp, #4
c0de8fee:	c307      	stmia	r3!, {r0, r1, r2}
c0de8ff0:	2070      	movs	r0, #112	@ 0x70
c0de8ff2:	f2c0 3000 	movt	r0, #768	@ 0x300
c0de8ff6:	a901      	add	r1, sp, #4
    parameters[1] = (unsigned int) value;
    parameters[2] = (unsigned int) maxlen;
    return (unsigned int) SVC_Call(SYSCALL_os_setting_get_ID, parameters);
c0de8ff8:	f7ff ffa6 	bl	c0de8f48 <SVC_Call>
c0de8ffc:	b004      	add	sp, #16
c0de8ffe:	bd80      	pop	{r7, pc}

c0de9000 <os_registry_get_current_app_tag>:
}

unsigned int os_registry_get_current_app_tag(unsigned int   tag,
                                             unsigned char *buffer,
                                             unsigned int   maxlen)
{
c0de9000:	b580      	push	{r7, lr}
c0de9002:	b084      	sub	sp, #16
    unsigned int parameters[3];
    parameters[0] = (unsigned int) tag;
c0de9004:	ab01      	add	r3, sp, #4
c0de9006:	c307      	stmia	r3!, {r0, r1, r2}
c0de9008:	2074      	movs	r0, #116	@ 0x74
c0de900a:	f2c0 3000 	movt	r0, #768	@ 0x300
c0de900e:	a901      	add	r1, sp, #4
    parameters[1] = (unsigned int) buffer;
    parameters[2] = (unsigned int) maxlen;
    return (unsigned int) SVC_Call(SYSCALL_os_registry_get_current_app_tag_ID, parameters);
c0de9010:	f7ff ff9a 	bl	c0de8f48 <SVC_Call>
c0de9014:	b004      	add	sp, #16
c0de9016:	bd80      	pop	{r7, pc}

c0de9018 <os_sched_exit>:
    SVC_Call(SYSCALL_os_sched_exec_ID, parameters);
    return;
}

void __attribute__((noreturn)) os_sched_exit(bolos_task_status_t exit_code)
{
c0de9018:	b082      	sub	sp, #8
    unsigned int parameters[2];
    parameters[0] = (unsigned int) exit_code;
c0de901a:	9000      	str	r0, [sp, #0]
c0de901c:	2000      	movs	r0, #0
    parameters[1] = 0;
c0de901e:	9001      	str	r0, [sp, #4]
c0de9020:	209a      	movs	r0, #154	@ 0x9a
c0de9022:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de9026:	4669      	mov	r1, sp
    SVC_Call(SYSCALL_os_sched_exit_ID, parameters);
c0de9028:	f7ff ff8e 	bl	c0de8f48 <SVC_Call>

    // The os_sched_exit syscall should never return.
    // Just in case, crash the device thanks to an undefined instruction.
    // To avoid the __builtin_unreachable undefined behaviour
    asm volatile("udf #255");
c0de902c:	deff      	udf	#255	@ 0xff

c0de902e <os_io_init>:
    parameters[4] = (unsigned int) flags;
    return (int) SVC_Call(SYSCALL_os_io_seph_se_rx_event_ID, parameters);
}

__attribute((weak)) int os_io_init(os_io_init_t *init)
{
c0de902e:	b580      	push	{r7, lr}
c0de9030:	b082      	sub	sp, #8
    unsigned int parameters[1];
    parameters[0] = (unsigned int) init;
c0de9032:	9001      	str	r0, [sp, #4]
c0de9034:	2084      	movs	r0, #132	@ 0x84
c0de9036:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de903a:	a901      	add	r1, sp, #4
    return (int) SVC_Call(SYSCALL_os_io_init_ID, parameters);
c0de903c:	f7ff ff84 	bl	c0de8f48 <SVC_Call>
c0de9040:	b002      	add	sp, #8
c0de9042:	bd80      	pop	{r7, pc}

c0de9044 <os_io_start>:
}

__attribute((weak)) int os_io_start(void)
{
c0de9044:	b580      	push	{r7, lr}
c0de9046:	b082      	sub	sp, #8
c0de9048:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de904a:	9001      	str	r0, [sp, #4]
c0de904c:	2085      	movs	r0, #133	@ 0x85
c0de904e:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de9052:	4669      	mov	r1, sp
    return (int) SVC_Call(SYSCALL_os_io_start_ID, parameters);
c0de9054:	f7ff ff78 	bl	c0de8f48 <SVC_Call>
c0de9058:	b002      	add	sp, #8
c0de905a:	bd80      	pop	{r7, pc}

c0de905c <os_io_stop>:
}

__attribute((weak)) int os_io_stop(void)
{
c0de905c:	b580      	push	{r7, lr}
c0de905e:	b082      	sub	sp, #8
c0de9060:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de9062:	9001      	str	r0, [sp, #4]
c0de9064:	2086      	movs	r0, #134	@ 0x86
c0de9066:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de906a:	4669      	mov	r1, sp
    return (int) SVC_Call(SYSCALL_os_io_stop_ID, parameters);
c0de906c:	f7ff ff6c 	bl	c0de8f48 <SVC_Call>
c0de9070:	b002      	add	sp, #8
c0de9072:	bd80      	pop	{r7, pc}

c0de9074 <os_io_tx_cmd>:

__attribute((weak)) int os_io_tx_cmd(unsigned char        type,
                                     const unsigned char *buffer,
                                     unsigned short       length,
                                     unsigned int        *timeout_ms)
{
c0de9074:	b580      	push	{r7, lr}
c0de9076:	b084      	sub	sp, #16
    unsigned int parameters[4];
    parameters[0] = (unsigned int) type;
c0de9078:	e88d 000f 	stmia.w	sp, {r0, r1, r2, r3}
c0de907c:	2088      	movs	r0, #136	@ 0x88
c0de907e:	f2c0 4000 	movt	r0, #1024	@ 0x400
c0de9082:	4669      	mov	r1, sp
    parameters[1] = (unsigned int) buffer;
    parameters[2] = (unsigned int) length;
    parameters[3] = (unsigned int) timeout_ms;
    return (int) SVC_Call(SYSCALL_os_io_tx_cmd_ID, parameters);
c0de9084:	f7ff ff60 	bl	c0de8f48 <SVC_Call>
c0de9088:	b004      	add	sp, #16
c0de908a:	bd80      	pop	{r7, pc}

c0de908c <os_io_rx_evt>:

__attribute((weak)) int os_io_rx_evt(unsigned char *buffer,
                                     unsigned short buffer_max_length,
                                     unsigned int  *timeout_ms,
                                     bool           check_se_event)
{
c0de908c:	b580      	push	{r7, lr}
c0de908e:	b084      	sub	sp, #16
    unsigned int parameters[4];
    parameters[0] = (unsigned int) buffer;
c0de9090:	e88d 000f 	stmia.w	sp, {r0, r1, r2, r3}
c0de9094:	2089      	movs	r0, #137	@ 0x89
c0de9096:	f2c0 3000 	movt	r0, #768	@ 0x300
c0de909a:	4669      	mov	r1, sp
    parameters[1] = (unsigned int) buffer_max_length;
    parameters[2] = (unsigned int) timeout_ms;
    parameters[3] = (unsigned int) check_se_event;
    return (int) SVC_Call(SYSCALL_os_io_rx_evt_ID, parameters);
c0de909c:	f7ff ff54 	bl	c0de8f48 <SVC_Call>
c0de90a0:	b004      	add	sp, #16
c0de90a2:	bd80      	pop	{r7, pc}

c0de90a4 <try_context_get>:
    parameters[1] = 0;
    return (unsigned int) SVC_Call(SYSCALL_nvm_erase_page_ID, parameters);
}

try_context_t *try_context_get(void)
{
c0de90a4:	b580      	push	{r7, lr}
c0de90a6:	b082      	sub	sp, #8
c0de90a8:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de90aa:	9001      	str	r0, [sp, #4]
c0de90ac:	4669      	mov	r1, sp
    return (try_context_t *) SVC_Call(SYSCALL_try_context_get_ID, parameters);
c0de90ae:	2087      	movs	r0, #135	@ 0x87
c0de90b0:	f7ff ff4a 	bl	c0de8f48 <SVC_Call>
c0de90b4:	b002      	add	sp, #8
c0de90b6:	bd80      	pop	{r7, pc}

c0de90b8 <try_context_set>:
}

try_context_t *try_context_set(try_context_t *context)
{
c0de90b8:	b580      	push	{r7, lr}
c0de90ba:	b082      	sub	sp, #8
    unsigned int parameters[2];
    parameters[0] = (unsigned int) context;
c0de90bc:	9000      	str	r0, [sp, #0]
c0de90be:	2000      	movs	r0, #0
    parameters[1] = 0;
c0de90c0:	9001      	str	r0, [sp, #4]
c0de90c2:	f240 100b 	movw	r0, #267	@ 0x10b
c0de90c6:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de90ca:	4669      	mov	r1, sp
    return (try_context_t *) SVC_Call(SYSCALL_try_context_set_ID, parameters);
c0de90cc:	f7ff ff3c 	bl	c0de8f48 <SVC_Call>
c0de90d0:	b002      	add	sp, #8
c0de90d2:	bd80      	pop	{r7, pc}

c0de90d4 <os_sched_last_status>:
}

bolos_task_status_t os_sched_last_status(unsigned int task_idx)
{
c0de90d4:	b580      	push	{r7, lr}
c0de90d6:	b082      	sub	sp, #8
    unsigned int parameters[2];
    parameters[0] = (unsigned int) task_idx;
c0de90d8:	9000      	str	r0, [sp, #0]
c0de90da:	2000      	movs	r0, #0
    parameters[1] = 0;
c0de90dc:	9001      	str	r0, [sp, #4]
c0de90de:	209c      	movs	r0, #156	@ 0x9c
c0de90e0:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de90e4:	4669      	mov	r1, sp
    return (bolos_task_status_t) SVC_Call(SYSCALL_os_sched_last_status_ID, parameters);
c0de90e6:	f7ff ff2f 	bl	c0de8f48 <SVC_Call>
c0de90ea:	b2c0      	uxtb	r0, r0
c0de90ec:	b002      	add	sp, #8
c0de90ee:	bd80      	pop	{r7, pc}

c0de90f0 <touch_get_last_info>:
}
#endif

#ifdef HAVE_SE_TOUCH
void touch_get_last_info(io_touch_info_t *info)
{
c0de90f0:	b580      	push	{r7, lr}
c0de90f2:	b082      	sub	sp, #8
    unsigned int parameters[1] = {(unsigned int) info};
c0de90f4:	9001      	str	r0, [sp, #4]
c0de90f6:	200b      	movs	r0, #11
c0de90f8:	f2c0 10fa 	movt	r0, #506	@ 0x1fa
c0de90fc:	a901      	add	r1, sp, #4
    SVC_Call(SYSCALL_touch_get_last_info_ID, parameters);
c0de90fe:	f7ff ff23 	bl	c0de8f48 <SVC_Call>
}
c0de9102:	b002      	add	sp, #8
c0de9104:	bd80      	pop	{r7, pc}
	...

c0de9108 <__udivmoddi4>:
c0de9108:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de910c:	f8dd c020 	ldr.w	ip, [sp, #32]
c0de9110:	4604      	mov	r4, r0
c0de9112:	b179      	cbz	r1, c0de9134 <__udivmoddi4+0x2c>
c0de9114:	b1ba      	cbz	r2, c0de9146 <__udivmoddi4+0x3e>
c0de9116:	b35b      	cbz	r3, c0de9170 <__udivmoddi4+0x68>
c0de9118:	fab1 f581 	clz	r5, r1
c0de911c:	fab3 f683 	clz	r6, r3
c0de9120:	1b75      	subs	r5, r6, r5
c0de9122:	2d20      	cmp	r5, #32
c0de9124:	d34a      	bcc.n	c0de91bc <__udivmoddi4+0xb4>
c0de9126:	f1bc 0f00 	cmp.w	ip, #0
c0de912a:	bf18      	it	ne
c0de912c:	e9cc 4100 	strdne	r4, r1, [ip]
c0de9130:	2400      	movs	r4, #0
c0de9132:	e066      	b.n	c0de9202 <__udivmoddi4+0xfa>
c0de9134:	b3cb      	cbz	r3, c0de91aa <__udivmoddi4+0xa2>
c0de9136:	2100      	movs	r1, #0
c0de9138:	f1bc 0f00 	cmp.w	ip, #0
c0de913c:	bf18      	it	ne
c0de913e:	e9cc 4100 	strdne	r4, r1, [ip]
c0de9142:	2400      	movs	r4, #0
c0de9144:	e0a6      	b.n	c0de9294 <__udivmoddi4+0x18c>
c0de9146:	2b00      	cmp	r3, #0
c0de9148:	d03e      	beq.n	c0de91c8 <__udivmoddi4+0xc0>
c0de914a:	2800      	cmp	r0, #0
c0de914c:	d04f      	beq.n	c0de91ee <__udivmoddi4+0xe6>
c0de914e:	1e5d      	subs	r5, r3, #1
c0de9150:	422b      	tst	r3, r5
c0de9152:	d158      	bne.n	c0de9206 <__udivmoddi4+0xfe>
c0de9154:	f1bc 0f00 	cmp.w	ip, #0
c0de9158:	bf1c      	itt	ne
c0de915a:	ea05 0001 	andne.w	r0, r5, r1
c0de915e:	e9cc 4000 	strdne	r4, r0, [ip]
c0de9162:	fa93 f0a3 	rbit	r0, r3
c0de9166:	fab0 f080 	clz	r0, r0
c0de916a:	fa21 f400 	lsr.w	r4, r1, r0
c0de916e:	e048      	b.n	c0de9202 <__udivmoddi4+0xfa>
c0de9170:	1e55      	subs	r5, r2, #1
c0de9172:	422a      	tst	r2, r5
c0de9174:	d129      	bne.n	c0de91ca <__udivmoddi4+0xc2>
c0de9176:	f1bc 0f00 	cmp.w	ip, #0
c0de917a:	bf1e      	ittt	ne
c0de917c:	2300      	movne	r3, #0
c0de917e:	4005      	andne	r5, r0
c0de9180:	e9cc 5300 	strdne	r5, r3, [ip]
c0de9184:	2a01      	cmp	r2, #1
c0de9186:	f000 8085 	beq.w	c0de9294 <__udivmoddi4+0x18c>
c0de918a:	fa92 f2a2 	rbit	r2, r2
c0de918e:	004c      	lsls	r4, r1, #1
c0de9190:	fab2 f282 	clz	r2, r2
c0de9194:	f002 031f 	and.w	r3, r2, #31
c0de9198:	40d1      	lsrs	r1, r2
c0de919a:	40d8      	lsrs	r0, r3
c0de919c:	231f      	movs	r3, #31
c0de919e:	4393      	bics	r3, r2
c0de91a0:	fa04 f303 	lsl.w	r3, r4, r3
c0de91a4:	ea43 0400 	orr.w	r4, r3, r0
c0de91a8:	e074      	b.n	c0de9294 <__udivmoddi4+0x18c>
c0de91aa:	fbb0 f4f2 	udiv	r4, r0, r2
c0de91ae:	f1bc 0f00 	cmp.w	ip, #0
c0de91b2:	d026      	beq.n	c0de9202 <__udivmoddi4+0xfa>
c0de91b4:	fb04 0012 	mls	r0, r4, r2, r0
c0de91b8:	2100      	movs	r1, #0
c0de91ba:	e020      	b.n	c0de91fe <__udivmoddi4+0xf6>
c0de91bc:	f105 0e01 	add.w	lr, r5, #1
c0de91c0:	f1be 0f20 	cmp.w	lr, #32
c0de91c4:	d00b      	beq.n	c0de91de <__udivmoddi4+0xd6>
c0de91c6:	e028      	b.n	c0de921a <__udivmoddi4+0x112>
c0de91c8:	e064      	b.n	c0de9294 <__udivmoddi4+0x18c>
c0de91ca:	fab1 f481 	clz	r4, r1
c0de91ce:	fab2 f582 	clz	r5, r2
c0de91d2:	1b2c      	subs	r4, r5, r4
c0de91d4:	f104 0e21 	add.w	lr, r4, #33	@ 0x21
c0de91d8:	f1be 0f20 	cmp.w	lr, #32
c0de91dc:	d15d      	bne.n	c0de929a <__udivmoddi4+0x192>
c0de91de:	f04f 0e20 	mov.w	lr, #32
c0de91e2:	f04f 0a00 	mov.w	sl, #0
c0de91e6:	f04f 0b00 	mov.w	fp, #0
c0de91ea:	460e      	mov	r6, r1
c0de91ec:	e021      	b.n	c0de9232 <__udivmoddi4+0x12a>
c0de91ee:	fbb1 f4f3 	udiv	r4, r1, r3
c0de91f2:	f1bc 0f00 	cmp.w	ip, #0
c0de91f6:	d004      	beq.n	c0de9202 <__udivmoddi4+0xfa>
c0de91f8:	2000      	movs	r0, #0
c0de91fa:	fb04 1113 	mls	r1, r4, r3, r1
c0de91fe:	e9cc 0100 	strd	r0, r1, [ip]
c0de9202:	2100      	movs	r1, #0
c0de9204:	e046      	b.n	c0de9294 <__udivmoddi4+0x18c>
c0de9206:	fab1 f581 	clz	r5, r1
c0de920a:	fab3 f683 	clz	r6, r3
c0de920e:	1b75      	subs	r5, r6, r5
c0de9210:	2d1f      	cmp	r5, #31
c0de9212:	f4bf af88 	bcs.w	c0de9126 <__udivmoddi4+0x1e>
c0de9216:	f105 0e01 	add.w	lr, r5, #1
c0de921a:	fa20 f40e 	lsr.w	r4, r0, lr
c0de921e:	f1c5 051f 	rsb	r5, r5, #31
c0de9222:	fa01 f605 	lsl.w	r6, r1, r5
c0de9226:	fa21 fb0e 	lsr.w	fp, r1, lr
c0de922a:	40a8      	lsls	r0, r5
c0de922c:	f04f 0a00 	mov.w	sl, #0
c0de9230:	4326      	orrs	r6, r4
c0de9232:	f04f 0800 	mov.w	r8, #0
c0de9236:	f1be 0f00 	cmp.w	lr, #0
c0de923a:	d01c      	beq.n	c0de9276 <__udivmoddi4+0x16e>
c0de923c:	ea4f 014b 	mov.w	r1, fp, lsl #1
c0de9240:	f1ae 0e01 	sub.w	lr, lr, #1
c0de9244:	ea41 71d6 	orr.w	r1, r1, r6, lsr #31
c0de9248:	0076      	lsls	r6, r6, #1
c0de924a:	ea46 75d0 	orr.w	r5, r6, r0, lsr #31
c0de924e:	1aae      	subs	r6, r5, r2
c0de9250:	eb61 0b03 	sbc.w	fp, r1, r3
c0de9254:	43cf      	mvns	r7, r1
c0de9256:	43ec      	mvns	r4, r5
c0de9258:	18a4      	adds	r4, r4, r2
c0de925a:	eb57 0403 	adcs.w	r4, r7, r3
c0de925e:	bf5c      	itt	pl
c0de9260:	468b      	movpl	fp, r1
c0de9262:	462e      	movpl	r6, r5
c0de9264:	0040      	lsls	r0, r0, #1
c0de9266:	0fe1      	lsrs	r1, r4, #31
c0de9268:	ea48 044a 	orr.w	r4, r8, sl, lsl #1
c0de926c:	ea40 70da 	orr.w	r0, r0, sl, lsr #31
c0de9270:	46a2      	mov	sl, r4
c0de9272:	4688      	mov	r8, r1
c0de9274:	e7df      	b.n	c0de9236 <__udivmoddi4+0x12e>
c0de9276:	ea4f 71da 	mov.w	r1, sl, lsr #31
c0de927a:	f1bc 0f00 	cmp.w	ip, #0
c0de927e:	bf18      	it	ne
c0de9280:	e9cc 6b00 	strdne	r6, fp, [ip]
c0de9284:	ea41 0140 	orr.w	r1, r1, r0, lsl #1
c0de9288:	ea4f 004a 	mov.w	r0, sl, lsl #1
c0de928c:	f020 0001 	bic.w	r0, r0, #1
c0de9290:	ea40 0408 	orr.w	r4, r0, r8
c0de9294:	4620      	mov	r0, r4
c0de9296:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de929a:	f1be 0f1f 	cmp.w	lr, #31
c0de929e:	d804      	bhi.n	c0de92aa <__udivmoddi4+0x1a2>
c0de92a0:	fa20 f40e 	lsr.w	r4, r0, lr
c0de92a4:	f1ce 0520 	rsb	r5, lr, #32
c0de92a8:	e7bb      	b.n	c0de9222 <__udivmoddi4+0x11a>
c0de92aa:	f1ce 0740 	rsb	r7, lr, #64	@ 0x40
c0de92ae:	f1ae 0420 	sub.w	r4, lr, #32
c0de92b2:	f04f 0b00 	mov.w	fp, #0
c0de92b6:	fa20 f504 	lsr.w	r5, r0, r4
c0de92ba:	fa01 f607 	lsl.w	r6, r1, r7
c0de92be:	fa00 fa07 	lsl.w	sl, r0, r7
c0de92c2:	ea46 0805 	orr.w	r8, r6, r5
c0de92c6:	fa21 f604 	lsr.w	r6, r1, r4
c0de92ca:	4640      	mov	r0, r8
c0de92cc:	e7b1      	b.n	c0de9232 <__udivmoddi4+0x12a>
	...

c0de92d0 <__aeabi_memcpy>:
c0de92d0:	f000 b81c 	b.w	c0de930c <memcpy>

c0de92d4 <__aeabi_memmove>:
c0de92d4:	f000 b828 	b.w	c0de9328 <memmove>

c0de92d8 <__aeabi_memset>:
c0de92d8:	460b      	mov	r3, r1
c0de92da:	4611      	mov	r1, r2
c0de92dc:	461a      	mov	r2, r3
c0de92de:	f000 b83d 	b.w	c0de935c <memset>
c0de92e2:	bf00      	nop

c0de92e4 <__aeabi_memclr>:
c0de92e4:	460a      	mov	r2, r1
c0de92e6:	2100      	movs	r1, #0
c0de92e8:	f000 b838 	b.w	c0de935c <memset>

c0de92ec <__aeabi_uldivmod>:
c0de92ec:	b540      	push	{r6, lr}
c0de92ee:	b084      	sub	sp, #16
c0de92f0:	ae02      	add	r6, sp, #8
c0de92f2:	9600      	str	r6, [sp, #0]
c0de92f4:	f7ff ff08 	bl	c0de9108 <__udivmoddi4>
c0de92f8:	9a02      	ldr	r2, [sp, #8]
c0de92fa:	9b03      	ldr	r3, [sp, #12]
c0de92fc:	b004      	add	sp, #16
c0de92fe:	bd40      	pop	{r6, pc}

c0de9300 <explicit_bzero>:
c0de9300:	f000 b800 	b.w	c0de9304 <bzero>

c0de9304 <bzero>:
c0de9304:	460a      	mov	r2, r1
c0de9306:	2100      	movs	r1, #0
c0de9308:	f000 b828 	b.w	c0de935c <memset>

c0de930c <memcpy>:
c0de930c:	440a      	add	r2, r1
c0de930e:	4291      	cmp	r1, r2
c0de9310:	f100 33ff 	add.w	r3, r0, #4294967295	@ 0xffffffff
c0de9314:	d100      	bne.n	c0de9318 <memcpy+0xc>
c0de9316:	4770      	bx	lr
c0de9318:	b510      	push	{r4, lr}
c0de931a:	f811 4b01 	ldrb.w	r4, [r1], #1
c0de931e:	4291      	cmp	r1, r2
c0de9320:	f803 4f01 	strb.w	r4, [r3, #1]!
c0de9324:	d1f9      	bne.n	c0de931a <memcpy+0xe>
c0de9326:	bd10      	pop	{r4, pc}

c0de9328 <memmove>:
c0de9328:	4288      	cmp	r0, r1
c0de932a:	b510      	push	{r4, lr}
c0de932c:	eb01 0402 	add.w	r4, r1, r2
c0de9330:	d902      	bls.n	c0de9338 <memmove+0x10>
c0de9332:	4284      	cmp	r4, r0
c0de9334:	4623      	mov	r3, r4
c0de9336:	d807      	bhi.n	c0de9348 <memmove+0x20>
c0de9338:	1e43      	subs	r3, r0, #1
c0de933a:	42a1      	cmp	r1, r4
c0de933c:	d008      	beq.n	c0de9350 <memmove+0x28>
c0de933e:	f811 2b01 	ldrb.w	r2, [r1], #1
c0de9342:	f803 2f01 	strb.w	r2, [r3, #1]!
c0de9346:	e7f8      	b.n	c0de933a <memmove+0x12>
c0de9348:	4601      	mov	r1, r0
c0de934a:	4402      	add	r2, r0
c0de934c:	428a      	cmp	r2, r1
c0de934e:	d100      	bne.n	c0de9352 <memmove+0x2a>
c0de9350:	bd10      	pop	{r4, pc}
c0de9352:	f813 4d01 	ldrb.w	r4, [r3, #-1]!
c0de9356:	f802 4d01 	strb.w	r4, [r2, #-1]!
c0de935a:	e7f7      	b.n	c0de934c <memmove+0x24>

c0de935c <memset>:
c0de935c:	4603      	mov	r3, r0
c0de935e:	4402      	add	r2, r0
c0de9360:	4293      	cmp	r3, r2
c0de9362:	d100      	bne.n	c0de9366 <memset+0xa>
c0de9364:	4770      	bx	lr
c0de9366:	f803 1b01 	strb.w	r1, [r3], #1
c0de936a:	e7f9      	b.n	c0de9360 <memset+0x4>

c0de936c <setjmp>:
c0de936c:	46ec      	mov	ip, sp
c0de936e:	e8a0 5ff0 	stmia.w	r0!, {r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
c0de9372:	f04f 0000 	mov.w	r0, #0
c0de9376:	4770      	bx	lr

c0de9378 <longjmp>:
c0de9378:	e8b0 5ff0 	ldmia.w	r0!, {r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
c0de937c:	46e5      	mov	sp, ip
c0de937e:	0008      	movs	r0, r1
c0de9380:	bf08      	it	eq
c0de9382:	2001      	moveq	r0, #1
c0de9384:	4770      	bx	lr
c0de9386:	bf00      	nop

c0de9388 <strlen>:
c0de9388:	4603      	mov	r3, r0
c0de938a:	f813 2b01 	ldrb.w	r2, [r3], #1
c0de938e:	2a00      	cmp	r2, #0
c0de9390:	d1fb      	bne.n	c0de938a <strlen+0x2>
c0de9392:	1a18      	subs	r0, r3, r0
c0de9394:	3801      	subs	r0, #1
c0de9396:	4770      	bx	lr

c0de9398 <strncat>:
c0de9398:	b530      	push	{r4, r5, lr}
c0de939a:	4604      	mov	r4, r0
c0de939c:	7825      	ldrb	r5, [r4, #0]
c0de939e:	4623      	mov	r3, r4
c0de93a0:	3401      	adds	r4, #1
c0de93a2:	2d00      	cmp	r5, #0
c0de93a4:	d1fa      	bne.n	c0de939c <strncat+0x4>
c0de93a6:	1e54      	subs	r4, r2, #1
c0de93a8:	b912      	cbnz	r2, c0de93b0 <strncat+0x18>
c0de93aa:	bd30      	pop	{r4, r5, pc}
c0de93ac:	b13c      	cbz	r4, c0de93be <strncat+0x26>
c0de93ae:	3c01      	subs	r4, #1
c0de93b0:	f811 2b01 	ldrb.w	r2, [r1], #1
c0de93b4:	f803 2b01 	strb.w	r2, [r3], #1
c0de93b8:	2a00      	cmp	r2, #0
c0de93ba:	d1f7      	bne.n	c0de93ac <strncat+0x14>
c0de93bc:	e7f5      	b.n	c0de93aa <strncat+0x12>
c0de93be:	701c      	strb	r4, [r3, #0]
c0de93c0:	e7f3      	b.n	c0de93aa <strncat+0x12>

c0de93c2 <C_app_boilerplate_64px_bitmap>:
c0de93c2:	0040 0040 b301 0000 00b1 8b1f 0008 0000     @.@.............
c0de93d2:	0000 0302 d175 0dbb 2103 060c 9f60 8522     ....u....!..`.".
c0de93e2:	1192 856e 706c 1da3 79a3 a414 6914 2929     ..n.lp...y...i))
c0de93f2:	1c2c ff83 0444 dce5 127c 1b0f a21b b8ab     ,...D...|.......
c0de9402:	f0c3 2d31 cc32 c0b0 f93a 8530 b368 d0bd     ..1-2...:.0.h...
c0de9412:	a288 0d9d 744a f0f2 c3a6 6bb4 b2ea bf6a     ....Jt.....k..j.
c0de9422:	2fa7 436d 2afd c2b0 b932 fd9b 8609 b3a7     ./mC.*..2.......
c0de9432:	74b0 d747 ab2a d51b 8dd3 8165 eb15 7382     .tG.*.....e....s
c0de9442:	dcbd a301 f3df 848d 460d bcdd 9658 c9f7     .........F..X...
c0de9452:	4f8f 91f4 ef4f a38f 9bf7 7f36 e5b0 69e6     .O..O.....6....i
c0de9462:	0d3e 12f3 afcc f32e cb2d f9dc 7fe2 7f96     >.......-.......
c0de9472:	1ffc e56f a9d1 0021 0002                     ..o...!....

c0de947d <C_app_boilerplate_64px>:
c0de947d:	0040 0040 0100 93c2 c0de                    @.@.......

c0de9487 <C_switch_60_40_bitmap>:
c0de9487:	0000 00ff 0000 ff07 00e0 1f00 f8ff 0000     ................
c0de9497:	ff3f 00fc ff00 ffff 0100 ffff 80ff ff03     ?...............
c0de94a7:	ffff 03c0 ffff c0ff ff07 ffff 0fe0 ffff     ................
c0de94b7:	f0ff ff0f ffff 1ff0 ffff f8ff ff1f ffff     ................
c0de94c7:	1ff8 ffff f8ff ff3f ffff 3ffc ffff fcff     ......?....?....
c0de94d7:	ff3f ffff 3ffc ffff fcff ff3f ffff 3ffc     ?....?....?....?
c0de94e7:	ffff fcff ff3f ffff 3ffc ffff fcff ff3f     ....?....?....?.
c0de94f7:	ffff 3ffc ffff fcff ff3f ffff 3ffc ffff     ...?....?....?..
c0de9507:	fcff ff3f ffff 3ffc 00ff fcff f83f 1f00     ..?....?....?...
c0de9517:	3ffc 00f0 fc0f c03f 0300 3ffc 0080 fc01     .?....?....?....
c0de9527:	003f 0000 3ffc 0000 fc00 003e 0000 3c7c     ?....?....>...|<
c0de9537:	0000 3c00 003c 0000 3c3c 0000 3c00 0038     ...<<...<<...<8.
c0de9547:	0000 381c 0000 1c00 0038 0000 381c 0000     ...8....8....8..
c0de9557:	1c00 0038 0000 381c 0000 1c00 0038 0000     ..8....8....8...
c0de9567:	381c 0000 1c00 001c 0000 1c38 0000 3800     .8........8....8
c0de9577:	001c 0000 0e38 0000 7000 000f 0000 07f0     ....8....p......
c0de9587:	0000 e000 8003 0100 03c0 00c0 c003 f001     ................
c0de9597:	0f00 0080 00f8 001f 3f00 fc00 0000 ff1f     .........?......
c0de95a7:	00f8 0700 e0ff 0000 ff00 0000               ............

c0de95b3 <C_switch_60_40>:
c0de95b3:	003c 0028 0000 9487 c0de                    <.(.......

c0de95bd <C_Important_Circle_64px_bitmap>:
c0de95bd:	0040 0040 fa21 0001 01f8 8b1f 0008 0000     @.@.!...........
c0de95cd:	0000 0302 55b5 4ecd 40c2 1e10 fea1 cfe3     .....U.N.@......
c0de95dd:	0f51 892a d45e 8904 602f 49e3 1313 7a3c     Q.*.^.../`.I..<z
c0de95ed:	cae4 37cd 1350 a33d 70c6 f8d5 1802 005f     ...7P.=..p...._.
c0de95fd:	9e0f 5f05 1fc0 1ace 4910 c054 b38e b6ed     ..._.....IT.....
c0de960d:	db74 d059 e704 76d0 dbf6 7cee 76fd 2dfa     t.Y....v...|.v.-
c0de961d:	ef62 99a2 055b d858 6a29 43e0 b190 6159     b...[.X.)j.C..Ya
c0de962d:	96d0 5e09 c518 308e a440 8010 052d 1806     ...^...0@...-...
c0de963d:	9408 b138 cadf 203c e4be e2e2 4979 3f81     ..8...< ....yI.?
c0de964d:	d0c4 7c94 3ac7 d915 1f9e d24f 56c0 bd3b     ...|.:....O..V;.
c0de965d:	34a4 abea a650 d97c 5f3f 484c c9b4 c551     .4..P.|.?_LH..Q.
c0de966d:	9541 9a6e 78d8 3bd9 3ecd f957 d17e 9ad0     A.n..x.;.>W.~...
c0de967d:	ec9b cc02 f504 6fb8 d92f e800 0c7b dfe2     .......o/...{...
c0de968d:	de93 c49a 2c6e 77ac 6009 79d6 874a 4baa     ....n,.w.`.yJ..K
c0de969d:	8606 abb3 26a4 9db7 cac4 a6de ff9a 7d53     .....&........S}
c0de96ad:	e341 7129 01bf b3c8 02dd 1310 d377 84a7     A.)q........w...
c0de96bd:	a612 c04d 1802 71e1 d85a b9e1 e3c2 006f     ..M....qZ.....o.
c0de96cd:	c459 fb3a 2275 6d3e 5582 0a80 538f 09e5     Y.:.u">m.U...S..
c0de96dd:	2551 eba2 38f7 228c f3ee 38ea 0ec2 6e23     Q%...8."...8..#n
c0de96ed:	0b8b c71f 55e2 51d3 8b81 4412 9145 3b71     .....U.Q...DE.q;
c0de96fd:	f769 20b6 159e 4f43 9a82 924d abc7 a042     i.. ..CO..M...B.
c0de970d:	c6ff f1bb 724b e7cd a06e 4521 e9d2 2fd3     ....Kr..n.!E.../
c0de971d:	d245 3be9 7884 69d5 627f f7dd 2eb7 b2c9     E..;.x.i.b......
c0de972d:	407f eeca 3992 af1e 9d39 ba05 bc0d 2a70     .@...9..9.....p*
c0de973d:	f29b 623f 19e8 8db2 1c0b 90dc d70b 0d35     ..?b..........5.
c0de974d:	965e ade3 b9a0 ea78 75c8 dd4d 2dff 7d85     ^.....x..uM..-.}
c0de975d:	f9d6 c243 c99b 4bfb 77fe d4fe dfd5 8948     ..C....K.w....H.
c0de976d:	61a0 92d3 8a91 afe2 618a 2b5f 8afe 5256     .a.......a_+..VR
c0de977d:	709d fc2b e439 8bef bfae 841f ddfc 6c36     .p+.9.........6l
c0de978d:	1f3a 10ee 9d5f 61f3 431a ed86 230f 53d8     :..._..a.C...#.S
c0de979d:	b8cd 1702 7aff 51be 3389 de17 f4d0 eb73     .....z.Q.3....s.
c0de97ad:	1d68 3e60 e853 91e1 3f8d c10e e439 0800     h.`>S....?..9...
	...

c0de97bf <C_Important_Circle_64px>:
c0de97bf:	0040 0040 0102 95bd c0de                    @.@.......

c0de97c9 <C_Warning_64px_bitmap>:
c0de97c9:	0040 0040 5f21 0001 015d 8b1f 0008 0000     @.@.!_..].......
c0de97d9:	0000 0302 d585 4e31 40c3 0510 8dd0 0885     ......1N.@......
c0de97e9:	454a 9149 25c2 52b2 08e4 4039 19c4 8272     JEI..%.R..9@..r.
c0de97f9:	815c 0384 b880 c441 7205 0a04 e7d2 6908     \.....A..r.....i
c0de9809:	a202 a50b a113 ec1d 5d99 f6b3 1fee fb6f     .........]....o.
c0de9819:	96c6 febc 4333 4f84 27b9 5ced ebf2 c293     ....3C.O.'.\....
c0de9829:	53bf 2663 cf0a 318c 9d23 5bb1 e866 5176     .Sc&...1#..[f.vQ
c0de9839:	60e1 7d06 3f5d b8fc ce41 24bc cce4 4273     .`.}]?..A..$..sB
c0de9849:	eafe f818 e79b efb4 966a 4b7b 7339 c841     ........j.{K9sA.
c0de9859:	ef99 f908 e431 bfd8 1c5a 7979 f15b 9090     ....1...Z.yy[...
c0de9869:	8733 6891 f33b 1855 96a9 239f f96e 8f25     3..h;.U....#n.%.
c0de9879:	7438 4b8e c9d6 bfeb 6f0b 3809 e0f3 8085     8t.K.....o.8....
c0de9889:	34db 977b c5b0 5dec 46c2 5dc8 90d8 9baf     .4{....].F.]....
c0de9899:	94b8 9fc6 fa1b 4631 36dc 7d8c ba4e 3d17     ......1F.6.}N..=
c0de98a9:	bdae e25f c4bc 9f6e eff4 eb93 164b f784     .._...n.....K...
c0de98b9:	2a9b fe68 5d4f 3d90 7743 5b05 7de8 70f9     .*h.O].=Cw.[.}.p
c0de98c9:	ebf1 4416 ccf9 a1de 00bb a01f 39d3 b4ef     ...D.........9..
c0de98d9:	b74f bebf fef5 ed72 141b fba4 787b 2e82     O.....r.....{x..
c0de98e9:	f705 e9d8 1833 c93f f4f9 cfa1 9727 0297     ....3.?.....'...
c0de98f9:	14bb b04c c14b 7603 89f2 6e43 fa57 f77c     ..L.K..v..CnW.|.
c0de9909:	db89 fbe8 4cc5 fd95 50b4 93f7 605f 6523     .....L...P.._`#e
c0de9919:	e63f 73ba c6a0 fb3d f499 5e05 cbcd e43f     ?..s..=....^..?.
c0de9929:	7b2a 0024 0008                               *{$....

c0de9930 <C_Warning_64px>:
c0de9930:	0040 0040 0102 97c9 c0de                    @.@.......

c0de993a <C_Back_40px_bitmap>:
c0de993a:	0028 0028 8c21 0000 008a 8b1f 0008 0000     (.(.!...........
c0de994a:	0000 0302 d3ed 09cd 20c0 800c d0d1 0e53     ......... ....S.
c0de995a:	a21d 39a3 364a 9570 d26e c46d c143 c7e6     ...9J6p.n.m.C...
c0de996a:	a8d6 73d0 f50f e110 81e3 b010 9794 f843     ...s..........C.
c0de997a:	efb7 c3b6 53b7 4667 28df dcca b621 6196     .....SgF.(..!..a
c0de998a:	2b95 b601 0646 d04a 5b5b fa86 4192 376d     .+..F.J.[[...Am7
c0de999a:	50ab c3da 942a 98d6 6e41 198e e6e4 4299     .P..*...An.....B
c0de99aa:	8ec2 2429 99ec 6dc0 6181 0933 c4f8 5561     ..)$...m.a3...aU
c0de99ba:	6001 605a 199a 7c43 01fb 02e5 04e6 e43a     .`Z`..C|......:.
c0de99ca:	0320 0000                                    ...

c0de99ce <C_Back_40px>:
c0de99ce:	0028 0028 0102 993a c0de                    (.(...:...

c0de99d8 <C_Check_40px_bitmap>:
c0de99d8:	0028 0028 5401 0000 0052 8b1f 0008 0000     (.(..T..R.......
c0de99e8:	0000 0302 6063 05c0 4078 1c84 9088 1307     ....c`..x@......
c0de99f8:	400d ff82 9000 7f60 2400 3f98 0900 1fc6     .@....`..$.?....
c0de9a08:	9920 203f 0ea2 d844 57e3 2608 602a b02c      .? ..D..W.&*`,.
c0de9a18:	5818 ac16 ac0e ac03 1ed7 5e6e 5c0d 0183     .X........n^.\..
c0de9a28:	0103 0000 8363 77dc 00c8 0000               ....c..w....

c0de9a34 <C_Check_40px>:
c0de9a34:	0028 0028 0100 99d8 c0de                    (.(.......

c0de9a3e <C_Chevron_40px_bitmap>:
c0de9a3e:	0028 0028 5c22 0000 ffff ffff ffff ffff     (.(."\..........
c0de9a4e:	1cda 03e4 0310 03e2 0330 03e0 0350 03de     ........0...P...
c0de9a5e:	1820 0320 03dc 0820 08c1 0320 03da 0820      . ... ... ... .
c0de9a6e:	08c3 0320 03d8 0820 08c5 0320 03d6 0820     .. ... ... ... .
c0de9a7e:	08c7 0320 05d4 0820 08c9 0520 9ed3 8020     .. ... ... ... .
c0de9a8e:	98cb e002 0ed4 cd09 0e09 ffff ffff ffff     ................
c0de9a9e:	ffff e2ff                                   ....

c0de9aa2 <C_Chevron_40px>:
c0de9aa2:	0028 0028 0102 9a3e c0de                    (.(...>...

c0de9aac <C_Chevron_Back_40px_bitmap>:
c0de9aac:	0028 0028 7621 0000 0074 8b1f 0008 0000     (.(.!v..t.......
c0de9abc:	0000 0302 d2ed 0dc1 3080 0508 8e50 383d     .........0..P.=8
c0de9acc:	a3a4 41b0 7157 6e93 3863 d498 1042 eb7e     ...AWq.nc8..B.~.
c0de9adc:	4606 340e bfe5 0b84 ffbd aa35 e7e1 2eb2     .F.4......5.....
c0de9aec:	6705 b55c 541f 2473 e9b4 1273 7640 27b0     .g\..Ts$..s.@v.'
c0de9afc:	2794 c807 0711 4c94 3203 73ac b828 21cd     .'.....L.2.s(..!
c0de9b0c:	8732 7313 3338 0b83 b833 8532 532b 62f8     2..s83..3.2.+S.b
c0de9b1c:	9603 1dcf 0dc6 8ef2 7343 0320 0000          ........Cs ...

c0de9b2a <C_Chevron_Back_40px>:
c0de9b2a:	0028 0028 0102 9aac c0de                    (.(.......

c0de9b34 <C_Chevron_Next_40px_bitmap>:
c0de9b34:	0028 0028 7121 0000 006f 8b1f 0008 0000     (.(.!q..o.......
c0de9b44:	0000 0302 ceed 0dbb 3080 450c 5751 0a51     .........0.EQWQ.
c0de9b54:	cc86 ac06 0d90 0918 42a6 1448 c48f 8e44     .........BH...D.
c0de9b64:	1b3f 6e20 74f9 1964 58f8 8735 22e9 02da     ?. n.td..X5.."..
c0de9b74:	ca23 a581 61e2 f5a5 b074 c031 c6c1 0b00     #....a..t.1.....
c0de9b84:	3999 ccc8 c1c2 1c0c 434c 0a61 9b0a 3150     .9......LCa...P1
c0de9b94:	c781 1d64 ec2e fe92 bcbe 7707 ddbd ebf8     ..d........w....
c0de9ba4:	383d be09 209b 0003                          =8... ...

c0de9bad <C_Chevron_Next_40px>:
c0de9bad:	0028 0028 0102 9b34 c0de                    (.(...4...

c0de9bb7 <C_Close_40px_bitmap>:
c0de9bb7:	0028 0028 8521 0000 0083 8b1f 0008 0000     (.(.!...........
c0de9bc7:	0000 0302 fffb c07f bfc0 08f9 cff6 10f7     ................
c0de9bd7:	11fa 4207 41ac 420f 604f 87e8 fd09 e060     ...B.A.BO`....`.
c0de9be7:	3184 0ae0 e01b 70d2 9216 9c2c 5089 6706     .1.....p..,..P.g
c0de9bf7:	2923 7383 9590 7941 ca28 5ca0 6554 3e60     #).s..Ay(..\Te`>
c0de9c07:	329a 42b0 6574 8520 cae8 0a40 9431 1561     .2.Bte ...@.1.a.
c0de9c17:	a2c3 9b17 581d 82dc cdcd fc58 2d86 b00c     .....X....X..-..
c0de9c27:	1584 30b6 12c5 d8f6 08e2 5c5b 8b62 6c73     ...0......[\b.sl
c0de9c37:	6369 0040 b400 b40b 2014 0003                ic@...... ...

c0de9c44 <C_Close_40px>:
c0de9c44:	0028 0028 0102 9bb7 c0de                    (.(.......

c0de9c4e <C_Info_40px_bitmap>:
c0de9c4e:	0028 0028 3121 0000 002f 8b1f 0008 0000     (.(.!1../.......
c0de9c5e:	0000 0302 fffb 147f 0bd0 f030 67ff 0180     ..........0..g..
c0de9c6e:	2a7e 7189 5a60 80d3 ec45 cf57 f068 0593     ~*.q`Z..E.W.h...
c0de9c7e:	d900 c99e 2019 0003                          ..... ...

c0de9c87 <C_Info_40px>:
c0de9c87:	0028 0028 0102 9c4e c0de                    (.(...N...

c0de9c91 <C_Mini_Push_40px_bitmap>:
c0de9c91:	0028 0028 ce21 0000 00cc 8b1f 0008 0000     (.(.!...........
c0de9ca1:	0000 0302 936d 0dcd 30c2 460c 2123 4ea4     ....m....0.F#!.N
c0de9cb1:	ba83 2b01 5230 6037 4604 0762 b006 5c0f     ...+0R7`.Fb....\
c0de9cc1:	4240 4936 2f9c f6bf c9a5 b3d3 3913 aaae     @B6I./.......9..
c0de9cd1:	1085 0eb1 4911 1e0a 7710 829f 6ab0 5a90     .....I...w...j.Z
c0de9ce1:	9606 3ac2 08a7 a7f5 a2d1 4761 b5e3 d168     ...:......aG..h.
c0de9cf1:	2f6c 053a a92f f019 a4cc fb95 6b3d cac1     l/:./.......=k..
c0de9d01:	53f6 6563 0ef5 8ae1 c043 10f6 3220 db41     .Sce....C... 2A.
c0de9d11:	880e d044 1fee 8588 4d45 6215 5161 8553     ..D.....EM.baQS.
c0de9d21:	2c68 556b 7634 5a4b cf12 e599 bcbb ab36     h,kU4vKZ......6.
c0de9d31:	5c7e fdda 61e4 cbec d6c6 b81e ebcc db95     ~\...a..........
c0de9d41:	af53 def7 791b e96f f9be 9628 eac9 b147     S....yo...(...G.
c0de9d51:	3926 e6b3 a4ce bb37 8cee ff4f 1fc2 8764     &9....7...O...d.
c0de9d61:	9d98 0320 0000                              .. ...

c0de9d67 <C_Mini_Push_40px>:
c0de9d67:	0028 0028 0102 9c91 c0de                    (.(.......

c0de9d71 <C_Privacy_40px_bitmap>:
c0de9d71:	0028 0028 ac21 0001 01aa 8b1f 0008 0000     (.(.!...........
c0de9d81:	0000 0302 927d 4bbf 50c3 c710 e9af 8b4f     ....}..K.P....O.
c0de9d91:	1768 0741 b335 fe88 6609 1d28 2c44 1fe2     h.A.5....f(.D,..
c0de9da1:	2ea0 cdd2 2e0a 6082 a45c b4b8 0ff8 4418     .......`\......D
c0de9db1:	1c50 b3b4 dd28 60a5 8777 38a2 10e9 b56b     P...(..`w..8..k.
c0de9dc1:	dac6 bce6 97bb 2da6 378a 25e4 f79f f7de     .......-.7.%....
c0de9dd1:	77be c439 a3bf ba75 ca9e f75c 26a1 8448     .w9...u...\..&H.
c0de9de1:	7a2e 23d8 b178 1f40 5e4e 6ad8 7320 7b7e     .z.#x.@.N^.j s~{
c0de9df1:	4cb6 1a70 8cd1 7231 2e21 cf5b 8c06 03a3     .Lp...1r!.[.....
c0de9e01:	1ac2 a730 dc34 2ab5 4166 beee c941 6e97     ..0.4..*fA..A..n
c0de9e11:	63a8 6968 74dd d859 d595 fb88 81c8 5288     .chi.tY........R
c0de9e21:	2181 90c9 a1bb 74a4 16cc 69c7 9e7a 9390     .!.....t...iz...
c0de9e31:	4e29 1eda d913 c423 f127 53ac 07d2 22a8     )N....#.'..S..."
c0de9e41:	e1d6 5d0e 461d 4b72 49c0 30eb f88b 880a     ...].FrK.I.0....
c0de9e51:	10ef 6125 8d93 09ba a8da c904 5c0e 328a     ..%a.........\.2
c0de9e61:	283b 1004 218b 5d44 cd39 2bd2 c9dd 15a3     ;(...!D]9..+....
c0de9e71:	36c1 084c 01ab 6919 24c1 e237 561b 7d84     .6L....i.$7..V.}
c0de9e81:	8488 c031 51cc 7b85 216b 9bf4 c259 fe9a     ..1..Q.{k!..Y...
c0de9e91:	92dd 9faa b872 cb24 3521 a8b4 62fe b698     ....r.$.!5...b..
c0de9ea1:	c2a2 4d4c 6cbc 4560 f7eb 916c 5521 cc5b     ..LM.l`E..l.!U[.
c0de9eb1:	86e6 8752 3d5c adc2 7bf7 d9a0 a6dc be99     ..R.\=...{......
c0de9ec1:	2d5e 26b2 a8cb 1e9e 9a13 8b17 3a52 f30c     ^-.&........R:..
c0de9ed1:	3ef3 a327 ca61 ae09 8fcf 084f 5aca f908     .>'.a.....O..Z..
c0de9ee1:	35c8 ffbc a35f 5ec4 41ec f3b8 d353 3a1e     .5.._..^.A..S..:
c0de9ef1:	f604 9120 5418 b993 8329 5e85 db99 f2e5     .. ..T..)..^....
c0de9f01:	56d5 6002 57d4 75ae b266 f08b 114b a76d     .V.`.W.uf...K.m.
c0de9f11:	a077 f65f c993 81d4 ff8d 0fc5 af18 4ccb     w._............L
c0de9f21:	0320 0000                                    ...

c0de9f25 <C_Privacy_40px>:
c0de9f25:	0028 0028 0102 9d71 c0de                    (.(...q...

c0de9f2f <C_Settings_40px_bitmap>:
c0de9f2f:	0028 0028 9321 0001 0191 8b1f 0008 0000     (.(.!...........
c0de9f3f:	0000 0302 5275 52b1 40c2 7d10 88c9 9841     ....uR.R.@.}..A.
c0de9f4f:	8c91 8e56 10ce 5e87 3e46 ec40 93b0 4e8e     ..V....^F>@....N
c0de9f5f:	03fd 4053 850d 1695 9d62 4a42 b03b 8a93     ..S@....b.BJ;...
c0de9f6f:	0bf1 04fc 1c1c 40eb a202 3920 2f77 1738     .......@.. 9w/8.
c0de9f7f:	d818 6f62 e5ef eef2 bbed 6215 8c7d ad4d     ..bo.......b}.M.
c0de9f8f:	8cba 81d5 25ad 8028 6b61 45dd 87ac 8fac     .....%(.ak.E....
c0de9f9f:	daac 764f 4e0b 7751 3303 aed6 761c ac42     ..Ov.NQw.3...vB.
c0de9faf:	8a01 1084 f9ad 314a 12e5 74f7 2cb5 8c9a     ......J1...t.,..
c0de9fbf:	300d 976b 5c73 4ae5 8b8e 5734 5c1e 3dc5     .0k.s\.J..4W.\.=
c0de9fcf:	9e43 1197 0a3a e29b 765c 4780 fd85 1aa0     C...:...\v.G....
c0de9fdf:	9e59 5cee 6075 4b8a 57ca 26c0 c381 6890     Y..\u`.K.W.&...h
c0de9fef:	fac4 2c7b 48e3 1f08 7c17 4593 0557 0a16     ..{,.H...|.EW...
c0de9fff:	d037 8459 a74e 601f f108 0385 9e21 2d71     7.Y.N..`....!.q-
c0dea00f:	8d44 19ec 2343 7786 f9a6 8a45 b79a 1d50     D...C#.w..E...P.
c0dea01f:	84e0 5a08 cc1b 9a7c 0e90 fba5 ef06 716a     ...Z..|.......jq
c0dea02f:	76ce 5398 2c73 25fa 6035 a205 fe11 a49b     .v.Ss,.%5`......
c0dea03f:	81f4 18f4 b93a c7d3 8b1b a6df 5264 755b     ....:.......dR[u
c0dea04f:	59c4 becb af10 c5ac 9ec6 b960 87d4 b385     .Y........`.....
c0dea05f:	cb32 a1f5 4bf3 b27d ff65 79bd f9b2 b2d0     2....K}.e..y....
c0dea06f:	3d80 6650 5e86 2f05 11b7 5733 3a79 f45c     .=Pf.^./..3Wy:\.
c0dea07f:	f25e e8f9 6746 1b24 65be aed0 b864 14ca     ^...Fg$..e..d...
c0dea08f:	6e9c 96f8 f913 44d4 2df3 8e8b 8d9a 9aa4     .n.....D.-......
c0dea09f:	c911 53bb 8a72 1b9a b158 f976 a9b8 3db8     ...Sr...X.v....=
c0dea0af:	3de4 50e9 6624 61a6 6747 dd64 aeec f19c     .=.P$f.aGgd.....
c0dea0bf:	fc68 4701 f51a 207f 0003                     h..G... ...

c0dea0ca <C_Settings_40px>:
c0dea0ca:	0028 0028 0102 9f2f c0de                    (.(.../...

c0dea0d4 <C_Warning_40px_bitmap>:
c0dea0d4:	0028 0028 e721 0000 00e5 8b1f 0008 0000     (.(.!...........
c0dea0e4:	0000 0302 d36d 0db1 40c2 850c 47e1 2284     ....m....@...G."
c0dea0f4:	283a d511 88d5 1182 0032 8662 904c 0815     :(......2.b.L...
c0dea104:	3013 2c03 0ec0 9e88 1025 526d 8450 9d10     .0.,....%.mRP...
c0dea114:	73b9 8842 b87d aafc 675f 911f 4b1c 34c1     .sB.}..._g...K.4
c0dea124:	0b26 c128 5b44 c08a c0f6 d95a d811 d2e6     &.(.D[....Z.....
c0dea134:	c0ae a486 81dd 4905 80ab 4939 66ab 4988     .......I..9I.f.I
c0dea144:	635a be30 7349 11ad c0d3 8c52 240e b5cd     Zc0.Is....R..$..
c0dea154:	d476 6f9b 6925 2adc 6dad d615 0eb5 c5ed     v..o%i.*.m......
c0dea164:	25ad 4cfc b04b b93d b035 db42 20db 942e     .%.LK.=.5.B.. ..
c0dea174:	43d1 773e e2db a970 2e8d 4ac0 9d1b 4c80     .C>w..p....J...L
c0dea184:	e51b ec3f a6cd ce88 c8ca 5f26 bc1c 6d7d     ..?.......&_..}m
c0dea194:	5db8 a8ee 76e6 cbb5 5dae bcee 576d c1b7     .]...v...]..mW..
c0dea1a4:	caed 5db8 6f9b da37 9fec f49b 81ed ccb9     ...].o7.........
c0dea1b4:	785d fef8 7c2f 1300 b8d8 2006 0003           ]x../|..... ...

c0dea1c3 <C_Warning_40px>:
c0dea1c3:	0028 0028 0102 a0d4 c0de 3e3d 6120 6470     (.(.......=> apd
c0dea1d3:	5f75 6964 7073 7461 6863 7265 6620 6961     u_dispatcher fai
c0dea1e3:	756c 6572 000a 7254 6e61 6173 7463 6f69     lure..Transactio
c0dea1f3:	206e 6843 6365 206b 6e75 7661 6961 616c     n Check unavaila
c0dea203:	6c62 0065 3e3d 6920 5f6f 6572 7663 635f     ble.=> io_recv_c
c0dea213:	6d6f 616d 646e 6620 6961 756c 6572 000a     ommand failure..
c0dea223:	7041 2070 7265 6f72 0072 6553 7263 7465     App error.Secret
c0dea233:	0073 6649 7920 756f 7227 2065 6f6e 2074     s.If you're not 
c0dea243:	7375 6e69 2067 6874 2065 654c 6764 7265     using the Ledger
c0dea253:	5720 6c61 656c 2074 7061 2c70 5420 6172      Wallet app, Tra
c0dea263:	736e 6361 6974 6e6f 4320 6568 6b63 6d20     nsaction Check m
c0dea273:	6769 7468 6e20 746f 7720 726f 2e6b 4920     ight not work. I
c0dea283:	2066 6f79 2075 7261 2065 7375 6e69 2067     f you are using 
c0dea293:	654c 6764 7265 5720 6c61 656c 2c74 7220     Ledger Wallet, r
c0dea2a3:	6a65 6365 2074 6874 2065 7274 6e61 6173     eject the transa
c0dea2b3:	7463 6f69 206e 6e61 2064 7274 2079 6761     ction and try ag
c0dea2c3:	6961 2e6e 0a0a 6547 2074 6568 706c 6120     ain...Get help a
c0dea2d3:	2074 656c 6764 7265 632e 6d6f 652f 3131     t ledger.com/e11
c0dea2e3:	4500 6978 2074 7061 0070 0020 7325 2520     .Exit app. .%s %
c0dea2f3:	0a73 7325 6800 7474 7370 2f3a 252f 0073     s.%s.https://%s.
c0dea303:	4e45 2053 616e 656d 2073 7261 2065 6572     ENS names are re
c0dea313:	6f73 766c 6465 6220 2079 654c 6764 7265     solved by Ledger
c0dea323:	6220 6361 656b 646e 002e 6553 7563 6972      backend..Securi
c0dea333:	7974 7220 7065 726f 0074 7325 250a 2073     ty report.%s.%s 
c0dea343:	7325 5900 7365 202c 6b73 7069 2500 2073     %s.Yes, skip.%s 
c0dea353:	6572 6f70 7472 3c00 203d 5753 253d 3430     report.<= SW=%04
c0dea363:	2058 207c 4452 7461 3d61 2e25 482a 000a     X | RData=%.*H..
c0dea373:	6c43 736f 0065 6353 6e61 7420 206f 6976     Close.Scan to vi
c0dea383:	7765 6620 6c75 206c 6572 6f70 7472 5400     ew full report.T
c0dea393:	6968 2073 7274 6e61 6173 7463 6f69 206e     his transaction 
c0dea3a3:	726f 6d20 7365 6173 6567 6320 6e61 6f6e     or message canno
c0dea3b3:	2074 6562 6420 6365 646f 6465 6620 6c75     t be decoded ful
c0dea3c3:	796c 202e 6649 7920 756f 6320 6f68 736f     ly. If you choos
c0dea3d3:	2065 6f74 7320 6769 2c6e 7920 756f 6320     e to sign, you c
c0dea3e3:	756f 646c 6220 2065 7561 6874 726f 7a69     ould be authoriz
c0dea3f3:	6e69 2067 616d 696c 6963 756f 2073 6361     ing malicious ac
c0dea403:	6974 6e6f 2073 6874 7461 6320 6e61 6420     tions that can d
c0dea413:	6172 6e69 7920 756f 2072 6177 6c6c 7465     rain your wallet
c0dea423:	0a2e 4c0a 6165 6e72 6d20 726f 3a65 6c20     ...Learn more: l
c0dea433:	6465 6567 2e72 6f63 2f6d 3865 3c00 203d     edger.com/e8.<= 
c0dea443:	5246 4741 2820 7525 252f 2975 5220 6144     FRAG (%u/%u) RDa
c0dea453:	6174 253d 2a2e 0a48 4d00 726f 0065 6854     ta=%.*H..More.Th
c0dea463:	7369 7420 6172 736e 6361 6974 6e6f 6320     is transaction c
c0dea473:	6e61 6f6e 2074 6562 4320 656c 7261 5320     annot be Clear S
c0dea483:	6769 656e 0064 3e3d 5020 3a43 3020 2578     igned.=> PC: 0x%
c0dea493:	3830 2058 000a 3e3d 4320 414c 253d 3230     08X ..=> CLA=%02
c0dea4a3:	2058 207c 4e49 3d53 3025 5832 7c20 5020     X | INS=%02X | P
c0dea4b3:	3d31 3025 5832 7c20 5020 3d32 3025 5832     1=%02X | P2=%02X
c0dea4c3:	7c20 4c20 3d63 3025 5832 7c20 4320 6144      | Lc=%02X | CDa
c0dea4d3:	6174 253d 2a2e 0a48 4300 6e61 6563 006c     ta=%.*H..Cancel.
c0dea4e3:	6854 7369 7420 6172 736e 6361 6974 6e6f     This transaction
c0dea4f3:	7720 7361 7320 6163 6e6e 6465 6120 2073      was scanned as 
c0dea503:	616d 696c 6963 756f 2073 7962 5720 6265     malicious by Web
c0dea513:	2033 6843 6365 736b 002e 6425 6f20 2066     3 Checks..%d of 
c0dea523:	6425 5300 696b 2070 6572 6976 7765 003f     %d.Skip review?.
c0dea533:	454c 4744 5245 415f 5353 5245 2054 4146     LEDGER_ASSERT FA
c0dea543:	4c49 4445 000a 6c42 6e69 2064 6973 6e67     ILED..Blind sign
c0dea553:	6e69 2067 6572 7571 7269 6465 2500 3a73     ing required.%s:
c0dea563:	253a 0a64 3d00 203e 212f 205c 4142 2044     :%d..=> /!\ BAD 
c0dea573:	454c 474e 4854 203a 2e25 482a 000a 755b     LENGTH: %.*H..[u
c0dea583:	6b6e 6f6e 6e77 005d 6952 6b73 6420 7465     nknown].Risk det
c0dea593:	6365 6574 0064 7243 7469 6369 6c61 7420     ected.Critical t
c0dea5a3:	7268 6165 0074 6854 7369 7420 6172 736e     hreat.This trans
c0dea5b3:	6361 6974 6e6f 7327 6420 7465 6961 736c     action's details
c0dea5c3:	6120 6572 6e20 746f 6620 6c75 796c 7620      are not fully v
c0dea5d3:	7265 6669 6169 6c62 2e65 4920 2066 6f79     erifiable. If yo
c0dea5e3:	2075 6973 6e67 202c 6f79 2075 6f63 6c75     u sign, you coul
c0dea5f3:	2064 6f6c 6573 6120 6c6c 7920 756f 2072     d lose all your 
c0dea603:	7361 6573 7374 002e 3d65 7830 3025 5834     assets..e=0x%04X
c0dea613:	200a 524c 303d 2578 3830 0a58 5400 6968     . LR=0x%08X..Thi
c0dea623:	2073 6361 6f63 6e75 2074 616c 6562 206c     s account label 
c0dea633:	6f63 656d 2073 7266 6d6f 7920 756f 2072     comes from your 
c0dea643:	6441 7264 7365 2073 6f42 6b6f 6920 206e     Address Book in 
c0dea653:	654c 6764 7265 5720 6c61 656c 2e74 7300     Ledger Wallet..s
c0dea663:	6174 646e 6c61 6e6f 5f65 7061 5f70 616d     tandalone_app_ma
c0dea673:	6e69 000a 7865 6563 7470 6f69 5b6e 7830     in..exception[0x
c0dea683:	3025 5834 3a5d 4c20 3d52 7830 3025 5838     %04X]: LR=0x%08X
c0dea693:	000a 000a 656e 7774 726f 2e6b 4900 2066     ....network..If 
c0dea6a3:	6f79 2775 6572 7320 7275 2065 6f79 2075     you're sure you 
c0dea6b3:	6f64 276e 2074 656e 6465 7420 206f 6572     don't need to re
c0dea6c3:	6976 7765 6120 6c6c 6620 6569 646c 2c73     view all fields,
c0dea6d3:	7920 756f 6320 6e61 7320 696b 2070 7473      you can skip st
c0dea6e3:	6172 6769 7468 7420 206f 6973 6e67 6e69     raight to signin
c0dea6f3:	2e67 5400 6968 2073 7274 6e61 6173 7463     g..This transact
c0dea703:	6f69 206e 6177 2073 6373 6e61 656e 2064     ion was scanned 
c0dea713:	7361 7220 7369 796b 6220 2079 6557 3362     as risky by Web3
c0dea723:	4320 6568 6b63 2e73 3c00 203d 5753 253d      Checks..<= SW=%
c0dea733:	3430 2058 207c 4452 7461 3d61 000a 6f4e     04X | RData=..No
c0dea743:	7420 7268 6165 2074 6564 6574 7463 6465      threat detected
c0dea753:	4c00 3d52 7830 3025 5838 200a 4350 303d     .LR=0x%08X. PC=0
c0dea763:	2578 3830 0a58 4700 206f 6162 6b63 7420     x%08X..Go back t
c0dea773:	206f 6572 6976 7765 2500 3a73 253a 2064     o review.%s::%d 
c0dea783:	000a 6b53 7069 5100 6975 2074 7061 0070     ..Skip.Quit app.
c0dea793:	3e3d 4c20 3a52 3020 2578 3830 2058 000a     => LR: 0x%08X ..
c0dea7a3:	7753 7069 2065 6f74 7220 7665 6569 0077     Swipe to review.
c0dea7b3:	6854 7369 6120 7070 6520 616e 6c62 7365     This app enables
c0dea7c3:	7320 6769 696e 676e 740a 6172 736e 6361      signing.transac
c0dea7d3:	6974 6e6f 2073 6e6f 7420 6568 5400 6172     tions on the.Tra
c0dea7e3:	736e 6361 6974 6e6f 4320 6568 6b63 6420     nsaction Check d
c0dea7f3:	6469 276e 2074 6966 646e 6120 796e 7420     idn't find any t
c0dea803:	7268 6165 2c74 6220 7475 6120 776c 7961     hreat, but alway
c0dea813:	2073 6572 6976 7765 7420 6172 736e 6361     s review transac
c0dea823:	6974 6e6f 6420 7465 6961 736c 6320 7261     tion details car
c0dea833:	6665 6c75 796c 002e 612f 7070 732f 6372     efully../app/src
c0dea843:	612f 6470 2f75 6964 7073 7461 6863 7265     /apdu/dispatcher
c0dea853:	632e 2500 5400 6968 2073 7061 2070 6e65     .c.%.This app en
c0dea863:	6261 656c 2073 6973 6e67 6e69 0a67 7274     ables signing.tr
c0dea873:	6e61 6173 7463 6f69 736e 6f20 206e 7469     ansactions on it
c0dea883:	2073 656e 7774 726f 2e6b 0000 4e00 4c55     s network....NUL
c0dea893:	204c 6d63 0064 0000                          L cmd....

c0dea89c <settingContents>:
	...

c0dea8a8 <infoList>:
	...

c0dea8b8 <nbMaxElementsPerContentType>:
c0dea8b8:	0101 0101 0101 0301 0503 0005               ............

c0dea8c4 <.L__const.displayAddressQRCode.headerDesc>:
c0dea8c4:	0000 0000 0028 0000 0000 0000 0000 0000     ....(...........
c0dea8d4:	0000 0000                                   ....

c0dea8d8 <.L__const.displaySkipWarning.info>:
c0dea8d8:	a526 c0de a6a0 c0de 0000 0000 97bf c0de     &...............
c0dea8e8:	0000 0000 a346 c0de a76a c0de 0005 0109     ....F...j.......

c0dea8f8 <.L__const.displaySecurityReport.layoutDescription>:
c0dea8f8:	0101 0000 0000 0000 0000 0000 75ab c0de     .............u..
	...

c0dea914 <.L__const.displaySecurityReport.headerDesc>:
c0dea914:	0101 0000 0000 0000 0000 0000 0917 0000     ................
c0dea924:	0000 0000                                   ....

c0dea928 <securityReportItems>:
c0dea928:	a1c3 c0de a1e9 c0de 0000 0000 a1c3 c0de     ................
c0dea938:	a58b c0de a6f6 c0de a1c3 c0de a599 c0de     ................
c0dea948:	a4e3 c0de 0000 0000 a741 c0de a7e0 c0de     ........A.......
c0dea958:	a1c3 c0de a549 c0de a5a9 c0de 0000 0000     ....I...........
	...

c0dea970 <.L__const.displayInfosListModal.info>:
c0dea970:	0100 0114 0900 0000 0000 0000 0000 0000     ................
c0dea980:	0100 0300 0000 0000 0000 0000               ............

c0dea98c <g_pcHex>:
c0dea98c:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef

c0dea99c <g_pcHex_cap>:
c0dea99c:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF

c0dea9ac <_etext>:
	...

c0deaa00 <install_parameters>:
c0deaa00:	0701 6553 7263 7465 0273 3205 332e 312e     ..Secrets..2.3.1
c0deaa10:	8103 28ec 2800 2100 00e4 e200 1f00 088b     ...(.(.!........
c0deaa20:	0000 0000 0200 9d03 bd92 830d 1030 cf85     ............0...
c0deaa30:	8172 26e4 0066 1594 3288 3300 0621 2cc8     r..&f....2.3!..,
c0deaa40:	3a51 861a 40a1 934a 2c31 3a59 625d ed88     Q:...@J.1,Y:]b..
c0deaa50:	4db3 7241 3205 c78f f77d a263 025f a55f     .MAr.2..}.c._._.
c0deaa60:	9a66 b352 c772 d307 a68e 7fca 3c01 4ec5     f.R.r........<.N
c0deaa70:	07c1 76dd eb1a d45b 0a56 ba0e f98a 51c0     ...v..[.V......Q
c0deaa80:	5696 86e8 ca6b 35de 0880 1bd5 d6f7 3e7e     .V..k..5......~>
c0deaa90:	4540 07dc 3dda 5e3a 16cb 8e22 f7a0 285a     @E...=:^.."...Z(
c0deaaa0:	697d e4bd 5c5b df71 0aa8 2053 c970 6c13     }i..[\q...S p..l
c0deaab0:	202f 474f 4738 1ced 194a 8403 1b8d 0c87     / OG8G..J.......
c0deaac0:	f492 28a1 37ed 30a1 9c1f 9f12 5e7c 3e74     ...(.7.0....|^t>
c0deaad0:	452b a8f8 7441 a67c 932e 23e9 08c5 9db1     +E..At|....#....
c0deaae0:	1af1 1a96 4977 dc73 dca5 07b9 d8ea 921d     ....wIs.........
c0deaaf0:	eec7 d224 f13f 2906 9724 203f 0003 0400     ..$.?..)$.? ....
c0deab00:	010a 8002 0000 802c 0000                     ......,....
