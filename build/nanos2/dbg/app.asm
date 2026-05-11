
build/nanos2/bin/app.elf:     file format elf32-littlearm


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
c0de0006:	f003 f921 	bl	c0de324c <os_boot>

    if (arg0 == 0) {
c0de000a:	2c00      	cmp	r4, #0
        // Called from dashboard as standalone App
        standalone_app_main();
c0de000c:	bf08      	it	eq
c0de000e:	f002 ff1a 	bleq	c0de2e46 <standalone_app_main>
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
c0de0060:	f002 fe6a 	bl	c0de2d38 <io_send_response_buffers>
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
c0de0074:	f244 6008 	movw	r0, #17928	@ 0x4608
c0de0078:	f2c0 0000 	movt	r0, #0
c0de007c:	4478      	add	r0, pc
c0de007e:	f003 f903 	bl	c0de3288 <mcu_usb_printf>
c0de0082:	f244 7622 	movw	r6, #18210	@ 0x4722
c0de0086:	f2c0 0600 	movt	r6, #0
c0de008a:	447e      	add	r6, pc
c0de008c:	4630      	mov	r0, r6
c0de008e:	f003 f8fb 	bl	c0de3288 <mcu_usb_printf>
c0de0092:	f244 607f 	movw	r0, #18047	@ 0x467f
c0de0096:	f2c0 0000 	movt	r0, #0
c0de009a:	4478      	add	r0, pc
c0de009c:	f003 f8f4 	bl	c0de3288 <mcu_usb_printf>
c0de00a0:	f240 40bc 	movw	r0, #1212	@ 0x4bc
c0de00a4:	f2c0 0000 	movt	r0, #0
c0de00a8:	eb09 0700 	add.w	r7, r9, r0
c0de00ac:	4638      	mov	r0, r7
c0de00ae:	4631      	mov	r1, r6
c0de00b0:	2209      	movs	r2, #9
c0de00b2:	f004 f93f 	bl	c0de4334 <__aeabi_memcpy>
c0de00b6:	4638      	mov	r0, r7
c0de00b8:	f004 f998 	bl	c0de43ec <strlen>
c0de00bc:	220a      	movs	r2, #10
c0de00be:	1839      	adds	r1, r7, r0
c0de00c0:	543a      	strb	r2, [r7, r0]
c0de00c2:	2000      	movs	r0, #0
c0de00c4:	7048      	strb	r0, [r1, #1]
c0de00c6:	f244 66b5 	movw	r6, #18101	@ 0x46b5
c0de00ca:	f2c0 0600 	movt	r6, #0
c0de00ce:	447e      	add	r6, pc
c0de00d0:	4630      	mov	r0, r6
c0de00d2:	2120      	movs	r1, #32
c0de00d4:	f002 fffa 	bl	c0de30cc <assert_print_file_info>
c0de00d8:	4630      	mov	r0, r6
c0de00da:	2120      	movs	r1, #32
c0de00dc:	f002 ffda 	bl	c0de3094 <assert_display_file_info>
c0de00e0:	4620      	mov	r0, r4
c0de00e2:	4629      	mov	r1, r5
c0de00e4:	f002 ffbc 	bl	c0de3060 <assert_print_lr_and_pc>
c0de00e8:	4620      	mov	r0, r4
c0de00ea:	4629      	mov	r1, r5
c0de00ec:	f002 ff96 	bl	c0de301c <assert_display_lr_and_pc>
c0de00f0:	f003 f822 	bl	c0de3138 <assert_display_exit>

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
c0de00fa:	f002 fe00 	bl	c0de2cfe <io_init>
    ui_menu_main();
c0de00fe:	f000 f88c 	bl	c0de021a <ui_menu_main>

    for (;;) {
        // Receive command bytes in G_io_apdu_buffer
        if ((input_len = io_recv_command()) < 0) {
c0de0102:	f002 fe05 	bl	c0de2d10 <io_recv_command>
c0de0106:	2800      	cmp	r0, #0
c0de0108:	d44d      	bmi.n	c0de01a6 <app_main+0xb2>
c0de010a:	f244 5a13 	movw	sl, #17683	@ 0x4513
c0de010e:	f2c0 0a00 	movt	sl, #0
c0de0112:	f244 4893 	movw	r8, #17555	@ 0x4493
c0de0116:	f2c0 0800 	movt	r8, #0
c0de011a:	f244 5b70 	movw	fp, #17776	@ 0x4570
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
c0de0140:	f003 f8a2 	bl	c0de3288 <mcu_usb_printf>
c0de0144:	2000      	movs	r0, #0
c0de0146:	2100      	movs	r1, #0
c0de0148:	f646 2287 	movw	r2, #27271	@ 0x6a87
c0de014c:	f002 fdf4 	bl	c0de2d38 <io_send_response_buffers>
        if ((input_len = io_recv_command()) < 0) {
c0de0150:	f002 fdde 	bl	c0de2d10 <io_recv_command>
c0de0154:	4604      	mov	r4, r0
c0de0156:	2800      	cmp	r0, #0
c0de0158:	d42a      	bmi.n	c0de01b0 <app_main+0xbc>
        if (!apdu_parser(&cmd, G_io_apdu_buffer, input_len)) {
c0de015a:	eb09 0106 	add.w	r1, r9, r6
c0de015e:	4628      	mov	r0, r5
c0de0160:	4622      	mov	r2, r4
c0de0162:	f002 fea1 	bl	c0de2ea8 <apdu_parser>
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
c0de018a:	f003 f87d 	bl	c0de3288 <mcu_usb_printf>

        // Dispatch structured APDU command to handler
        if (apdu_dispatcher(&cmd) < 0) {
c0de018e:	4628      	mov	r0, r5
c0de0190:	f7ff ff41 	bl	c0de0016 <apdu_dispatcher>
c0de0194:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
c0de0198:	dcda      	bgt.n	c0de0150 <app_main+0x5c>
c0de019a:	f244 38fa 	movw	r8, #17402	@ 0x43fa
c0de019e:	f2c0 0800 	movt	r8, #0
c0de01a2:	44f8      	add	r8, pc
c0de01a4:	e004      	b.n	c0de01b0 <app_main+0xbc>
c0de01a6:	f244 4815 	movw	r8, #17429	@ 0x4415
c0de01aa:	f2c0 0800 	movt	r8, #0
c0de01ae:	44f8      	add	r8, pc
c0de01b0:	4640      	mov	r0, r8
c0de01b2:	f003 f869 	bl	c0de3288 <mcu_usb_printf>
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
c0de01c0:	f244 50d6 	movw	r0, #17878	@ 0x45d6
c0de01c4:	f2c0 0000 	movt	r0, #0
c0de01c8:	4478      	add	r0, pc
c0de01ca:	f003 feed 	bl	c0de3fa8 <pic>
        &(const buffer_t){.ptr = (uint8_t *) ptr, .size = size, .offset = 0}, 1, sw);
c0de01ce:	9001      	str	r0, [sp, #4]
c0de01d0:	200b      	movs	r0, #11
c0de01d2:	9002      	str	r0, [sp, #8]
c0de01d4:	2000      	movs	r0, #0
c0de01d6:	9003      	str	r0, [sp, #12]
c0de01d8:	a801      	add	r0, sp, #4
    return io_send_response_buffers(
c0de01da:	2101      	movs	r1, #1
c0de01dc:	f44f 4210 	mov.w	r2, #36864	@ 0x9000
c0de01e0:	f002 fdaa 	bl	c0de2d38 <io_send_response_buffers>
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
c0de0212:	f002 fd91 	bl	c0de2d38 <io_send_response_buffers>
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
c0de0226:	f244 518c 	movw	r1, #17804	@ 0x458c
c0de022a:	f2c0 0100 	movt	r1, #0
c0de022e:	f244 527e 	movw	r2, #17790	@ 0x457e
c0de0232:	f2c0 0200 	movt	r2, #0
c0de0236:	2000      	movs	r0, #0
c0de0238:	4479      	add	r1, pc
c0de023a:	447a      	add	r2, pc
c0de023c:	e9cd 2100 	strd	r2, r1, [sp]
c0de0240:	9002      	str	r0, [sp, #8]
c0de0242:	f244 504a 	movw	r0, #17738	@ 0x454a
c0de0246:	f2c0 0000 	movt	r0, #0
c0de024a:	f244 313c 	movw	r1, #17212	@ 0x433c
c0de024e:	f2c0 0100 	movt	r1, #0
c0de0252:	44fc      	add	ip, pc
c0de0254:	4478      	add	r0, pc
c0de0256:	4479      	add	r1, pc
c0de0258:	2200      	movs	r2, #0
c0de025a:	23ff      	movs	r3, #255	@ 0xff
c0de025c:	f8cd c00c 	str.w	ip, [sp, #12]
c0de0260:	f001 fd17 	bl	c0de1c92 <nbgl_useCaseHomeAndSettings>
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
c0de026a:	f003 ff13 	bl	c0de4094 <os_sched_exit>

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
c0de02e4:	f003 fe8d 	bl	c0de4002 <os_pki_load_certificate>
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
c0de02f8:	f004 f834 	bl	c0de4364 <explicit_bzero>
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
c0de0334:	f003 fea2 	bl	c0de407c <os_registry_get_current_app_tag>
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
c0de034e:	f003 fe95 	bl	c0de407c <os_registry_get_current_app_tag>
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
c0de0364:	f003 fe80 	bl	c0de4068 <os_flags>
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
c0de03a8:	f003 fea2 	bl	c0de40f0 <os_io_tx_cmd>
        os_io_tx_cmd(OS_IO_PACKET_TYPE_SEPH, (const uint8_t *) str, charcount, NULL);
c0de03ac:	2001      	movs	r0, #1
c0de03ae:	4629      	mov	r1, r5
c0de03b0:	4622      	mov	r2, r4
c0de03b2:	2300      	movs	r3, #0
c0de03b4:	f003 fe9c 	bl	c0de40f0 <os_io_tx_cmd>
c0de03b8:	b002      	add	sp, #8
c0de03ba:	e8bd 40b0 	ldmia.w	sp!, {r4, r5, r7, lr}
}
c0de03be:	4770      	bx	lr

c0de03c0 <io_process_itc_ux_event>:
    G_ux_os.button_mask              = 0;
    G_ux_os.button_same_mask_counter = 0;
}

int io_process_itc_ux_event(uint8_t *buffer_in, size_t buffer_in_length)
{
c0de03c0:	b580      	push	{r7, lr}
    int status = buffer_in_length;

    switch (buffer_in[3]) {
c0de03c2:	78c0      	ldrb	r0, [r0, #3]
c0de03c4:	2820      	cmp	r0, #32
c0de03c6:	4608      	mov	r0, r1

        default:
            break;
    }

    return status;
c0de03c8:	bf18      	it	ne
c0de03ca:	bd80      	popne	{r7, pc}
            nbgl_objAllowDrawing(true);
c0de03cc:	2001      	movs	r0, #1
c0de03ce:	f002 fee0 	bl	c0de3192 <nbgl_objAllowDrawing>
            nbgl_screenRedraw();
c0de03d2:	f002 feed 	bl	c0de31b0 <nbgl_screenRedraw>
            nbgl_refresh();
c0de03d6:	f002 fed2 	bl	c0de317e <nbgl_refresh>
c0de03da:	2000      	movs	r0, #0
    return status;
c0de03dc:	bd80      	pop	{r7, pc}

c0de03de <io_seproxyhal_io_heartbeat>:
{
    os_io_stop();
}

void io_seproxyhal_io_heartbeat(void)
{
c0de03de:	b570      	push	{r4, r5, r6, lr}
c0de03e0:	b082      	sub	sp, #8
    uint16_t      err = SWO_COMMAND_NOT_ACCEPTED;
    unsigned char err_buffer[2];
    int           status = os_io_rx_evt(G_io_rx_buffer, sizeof(G_io_rx_buffer), NULL, true);
c0de03e2:	f240 1511 	movw	r5, #273	@ 0x111
c0de03e6:	f2c0 0500 	movt	r5, #0
c0de03ea:	eb09 0005 	add.w	r0, r9, r5
c0de03ee:	f240 1111 	movw	r1, #273	@ 0x111
c0de03f2:	2200      	movs	r2, #0
c0de03f4:	2301      	movs	r3, #1
c0de03f6:	2601      	movs	r6, #1
c0de03f8:	f003 fe86 	bl	c0de4108 <os_io_rx_evt>
c0de03fc:	4604      	mov	r4, r0

    if (os_perso_is_pin_set() == BOLOS_TRUE && os_global_pin_is_validated() != BOLOS_TRUE) {
c0de03fe:	f003 fe10 	bl	c0de4022 <os_perso_is_pin_set>
c0de0402:	28aa      	cmp	r0, #170	@ 0xaa
c0de0404:	d10a      	bne.n	c0de041c <io_seproxyhal_io_heartbeat+0x3e>
c0de0406:	f003 fe17 	bl	c0de4038 <os_global_pin_is_validated>
c0de040a:	2615      	movs	r6, #21
c0de040c:	28aa      	cmp	r0, #170	@ 0xaa
c0de040e:	f04f 0055 	mov.w	r0, #85	@ 0x55
c0de0412:	bf08      	it	eq
c0de0414:	2601      	moveq	r6, #1
c0de0416:	bf08      	it	eq
c0de0418:	2069      	moveq	r0, #105	@ 0x69
c0de041a:	e000      	b.n	c0de041e <io_seproxyhal_io_heartbeat+0x40>
c0de041c:	2069      	movs	r0, #105	@ 0x69
    }

    err_buffer[0] = err >> 8;
    err_buffer[1] = err;

    if (status > 0) {
c0de041e:	2c01      	cmp	r4, #1
    err_buffer[0] = err >> 8;
c0de0420:	f88d 0006 	strb.w	r0, [sp, #6]
    err_buffer[1] = err;
c0de0424:	f88d 6007 	strb.w	r6, [sp, #7]
    if (status > 0) {
c0de0428:	db15      	blt.n	c0de0456 <io_seproxyhal_io_heartbeat+0x78>
        switch (G_io_rx_buffer[0]) {
c0de042a:	f819 0005 	ldrb.w	r0, [r9, r5]
c0de042e:	282f      	cmp	r0, #47	@ 0x2f
c0de0430:	dc13      	bgt.n	c0de045a <io_seproxyhal_io_heartbeat+0x7c>
c0de0432:	f1a0 0110 	sub.w	r1, r0, #16
c0de0436:	2913      	cmp	r1, #19
c0de0438:	d814      	bhi.n	c0de0464 <io_seproxyhal_io_heartbeat+0x86>
c0de043a:	2201      	movs	r2, #1
c0de043c:	fa02 f101 	lsl.w	r1, r2, r1
c0de0440:	2201      	movs	r2, #1
c0de0442:	f2c0 020f 	movt	r2, #15
c0de0446:	4211      	tst	r1, r2
c0de0448:	d00c      	beq.n	c0de0464 <io_seproxyhal_io_heartbeat+0x86>
c0de044a:	f10d 0106 	add.w	r1, sp, #6
            case OS_IO_PACKET_TYPE_USB_CCID_APDU:
            case OS_IO_PACKET_TYPE_USB_WEBUSB_APDU:
            case OS_IO_PACKET_TYPE_USB_U2F_HID_APDU:
            case OS_IO_PACKET_TYPE_BLE_APDU:
            case OS_IO_PACKET_TYPE_NFC_APDU:
                os_io_tx_cmd(G_io_rx_buffer[0], err_buffer, sizeof(err_buffer), 0);
c0de044e:	2202      	movs	r2, #2
c0de0450:	2300      	movs	r3, #0
c0de0452:	f003 fe4d 	bl	c0de40f0 <os_io_tx_cmd>

            default:
                break;
        }
    }
}
c0de0456:	b002      	add	sp, #8
c0de0458:	bd70      	pop	{r4, r5, r6, pc}
        switch (G_io_rx_buffer[0]) {
c0de045a:	2830      	cmp	r0, #48	@ 0x30
c0de045c:	d0f5      	beq.n	c0de044a <io_seproxyhal_io_heartbeat+0x6c>
c0de045e:	2840      	cmp	r0, #64	@ 0x40
c0de0460:	d0f3      	beq.n	c0de044a <io_seproxyhal_io_heartbeat+0x6c>
c0de0462:	e7f8      	b.n	c0de0456 <io_seproxyhal_io_heartbeat+0x78>
c0de0464:	3801      	subs	r0, #1
c0de0466:	2802      	cmp	r0, #2
c0de0468:	d2f5      	bcs.n	c0de0456 <io_seproxyhal_io_heartbeat+0x78>
                memcpy(G_io_seproxyhal_spi_buffer, &G_io_rx_buffer[1], status - 1);
c0de046a:	f240 3094 	movw	r0, #916	@ 0x394
c0de046e:	f2c0 0000 	movt	r0, #0
c0de0472:	eb09 0105 	add.w	r1, r9, r5
c0de0476:	1e62      	subs	r2, r4, #1
c0de0478:	4448      	add	r0, r9
c0de047a:	3101      	adds	r1, #1
c0de047c:	f003 ff5a 	bl	c0de4334 <__aeabi_memcpy>
                io_event(CHANNEL_APDU);
c0de0480:	2000      	movs	r0, #0
c0de0482:	f002 fc22 	bl	c0de2cca <io_event>
}
c0de0486:	b002      	add	sp, #8
c0de0488:	bd70      	pop	{r4, r5, r6, pc}

c0de048a <io_legacy_apdu_tx>:

    return status;
}

int io_legacy_apdu_tx(const unsigned char *buffer, unsigned short length)
{
c0de048a:	b5b0      	push	{r4, r5, r7, lr}
    int status = os_io_tx_cmd(io_os_legacy_apdu_type, buffer, length, 0);
c0de048c:	f240 242c 	movw	r4, #556	@ 0x22c
c0de0490:	f2c0 0400 	movt	r4, #0
c0de0494:	460a      	mov	r2, r1
c0de0496:	f819 1004 	ldrb.w	r1, [r9, r4]
c0de049a:	4603      	mov	r3, r0
c0de049c:	4608      	mov	r0, r1
c0de049e:	4619      	mov	r1, r3
c0de04a0:	2300      	movs	r3, #0
c0de04a2:	2500      	movs	r5, #0
c0de04a4:	f003 fe24 	bl	c0de40f0 <os_io_tx_cmd>

    G_io_app.apdu_media    = IO_APDU_MEDIA_NONE;
c0de04a8:	f240 2124 	movw	r1, #548	@ 0x224
c0de04ac:	f2c0 0100 	movt	r1, #0
c0de04b0:	4449      	add	r1, r9
c0de04b2:	718d      	strb	r5, [r1, #6]
    io_os_legacy_apdu_type = APDU_TYPE_NONE;
#ifdef HAVE_IO_U2F
    G_io_u2f.media = U2F_MEDIA_NONE;
c0de04b4:	f240 41b4 	movw	r1, #1204	@ 0x4b4
c0de04b8:	f2c0 0100 	movt	r1, #0
    io_os_legacy_apdu_type = APDU_TYPE_NONE;
c0de04bc:	f809 5004 	strb.w	r5, [r9, r4]
    G_io_u2f.media = U2F_MEDIA_NONE;
c0de04c0:	f809 5001 	strb.w	r5, [r9, r1]
#endif  // HAVE_IO_U2F

    return status;
c0de04c4:	bdb0      	pop	{r4, r5, r7, pc}

c0de04c6 <io_legacy_apdu_rx>:
{
c0de04c6:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
c0de04ca:	b084      	sub	sp, #16
    status = os_io_rx_evt(G_io_rx_buffer, sizeof(G_io_rx_buffer), NULL, true);
c0de04cc:	f240 1711 	movw	r7, #273	@ 0x111
c0de04d0:	4606      	mov	r6, r0
c0de04d2:	2000      	movs	r0, #0
c0de04d4:	f2c0 0700 	movt	r7, #0
    os_io_apdu_post_action_t post_action = OS_IO_APDU_POST_ACTION_NONE;
c0de04d8:	f88d 000f 	strb.w	r0, [sp, #15]
    status = os_io_rx_evt(G_io_rx_buffer, sizeof(G_io_rx_buffer), NULL, true);
c0de04dc:	eb09 0007 	add.w	r0, r9, r7
c0de04e0:	f240 1111 	movw	r1, #273	@ 0x111
c0de04e4:	2200      	movs	r2, #0
c0de04e6:	2301      	movs	r3, #1
c0de04e8:	f003 fe0e 	bl	c0de4108 <os_io_rx_evt>
c0de04ec:	4604      	mov	r4, r0
    if (status > 0) {
c0de04ee:	2801      	cmp	r0, #1
c0de04f0:	f2c0 8106 	blt.w	c0de0700 <io_legacy_apdu_rx+0x23a>
        switch (G_io_rx_buffer[0]) {
c0de04f4:	f819 0007 	ldrb.w	r0, [r9, r7]
c0de04f8:	2500      	movs	r5, #0
c0de04fa:	282f      	cmp	r0, #47	@ 0x2f
c0de04fc:	dc5d      	bgt.n	c0de05ba <io_legacy_apdu_rx+0xf4>
c0de04fe:	f1a0 0110 	sub.w	r1, r0, #16
c0de0502:	2916      	cmp	r1, #22
c0de0504:	d86c      	bhi.n	c0de05e0 <io_legacy_apdu_rx+0x11a>
c0de0506:	2201      	movs	r2, #1
c0de0508:	fa02 f101 	lsl.w	r1, r2, r1
c0de050c:	2201      	movs	r2, #1
c0de050e:	f2c0 027f 	movt	r2, #127	@ 0x7f
c0de0512:	4211      	tst	r1, r2
c0de0514:	d064      	beq.n	c0de05e0 <io_legacy_apdu_rx+0x11a>
                io_os_legacy_apdu_type = G_io_rx_buffer[0];
c0de0516:	f240 252c 	movw	r5, #556	@ 0x22c
c0de051a:	f2c0 0500 	movt	r5, #0
c0de051e:	f809 0005 	strb.w	r0, [r9, r5]
                if (os_perso_is_pin_set() == BOLOS_TRUE
c0de0522:	f003 fd7e 	bl	c0de4022 <os_perso_is_pin_set>
                    && os_global_pin_is_validated() != BOLOS_TRUE) {
c0de0526:	28aa      	cmp	r0, #170	@ 0xaa
c0de0528:	d103      	bne.n	c0de0532 <io_legacy_apdu_rx+0x6c>
c0de052a:	f003 fd85 	bl	c0de4038 <os_global_pin_is_validated>
                if (os_perso_is_pin_set() == BOLOS_TRUE
c0de052e:	28aa      	cmp	r0, #170	@ 0xaa
c0de0530:	d170      	bne.n	c0de0614 <io_legacy_apdu_rx+0x14e>
                else if (G_io_rx_buffer[APDU_OFF_CLA + 1] == DEFAULT_APDU_CLA) {
c0de0532:	eb09 0007 	add.w	r0, r9, r7
c0de0536:	7840      	ldrb	r0, [r0, #1]
c0de0538:	28b0      	cmp	r0, #176	@ 0xb0
c0de053a:	d132      	bne.n	c0de05a2 <io_legacy_apdu_rx+0xdc>
c0de053c:	f240 1011 	movw	r0, #273	@ 0x111
                                                                status - 1,
c0de0540:	1e61      	subs	r1, r4, #1
                    bolos_err_t err               = os_io_handle_default_apdu(&G_io_rx_buffer[1],
c0de0542:	f240 0400 	movw	r4, #0
                    size_t      buffer_out_length = sizeof(G_io_rx_buffer);
c0de0546:	9002      	str	r0, [sp, #8]
                    bolos_err_t err               = os_io_handle_default_apdu(&G_io_rx_buffer[1],
c0de0548:	f2c0 0400 	movt	r4, #0
c0de054c:	eb09 0007 	add.w	r0, r9, r7
c0de0550:	f10d 060f 	add.w	r6, sp, #15
c0de0554:	eb09 0204 	add.w	r2, r9, r4
c0de0558:	3001      	adds	r0, #1
c0de055a:	ab02      	add	r3, sp, #8
c0de055c:	9600      	str	r6, [sp, #0]
c0de055e:	f7ff fe86 	bl	c0de026e <os_io_handle_default_apdu>
                    if (err != SWO_SUCCESS) {
c0de0562:	f5b0 4f10 	cmp.w	r0, #36864	@ 0x9000
c0de0566:	bf1c      	itt	ne
c0de0568:	2100      	movne	r1, #0
                        buffer_out_length = 0;
c0de056a:	9102      	strne	r1, [sp, #8]
                    G_io_tx_buffer[buffer_out_length++] = err >> 8;
c0de056c:	9b02      	ldr	r3, [sp, #8]
c0de056e:	0a02      	lsrs	r2, r0, #8
c0de0570:	eb09 0104 	add.w	r1, r9, r4
c0de0574:	18cf      	adds	r7, r1, r3
c0de0576:	54ca      	strb	r2, [r1, r3]
                    G_io_tx_buffer[buffer_out_length++] = err;
c0de0578:	1c9a      	adds	r2, r3, #2
                        io_os_legacy_apdu_type, G_io_tx_buffer, buffer_out_length, 0);
c0de057a:	f819 3005 	ldrb.w	r3, [r9, r5]
                    G_io_tx_buffer[buffer_out_length++] = err;
c0de057e:	9202      	str	r2, [sp, #8]
c0de0580:	7078      	strb	r0, [r7, #1]
                    status                              = os_io_tx_cmd(
c0de0582:	b292      	uxth	r2, r2
c0de0584:	4618      	mov	r0, r3
c0de0586:	2300      	movs	r3, #0
c0de0588:	2400      	movs	r4, #0
c0de058a:	f003 fdb1 	bl	c0de40f0 <os_io_tx_cmd>
                    if (post_action == OS_IO_APDU_POST_ACTION_EXIT) {
c0de058e:	f89d 100f 	ldrb.w	r1, [sp, #15]
                    io_os_legacy_apdu_type = APDU_TYPE_NONE;
c0de0592:	f809 4005 	strb.w	r4, [r9, r5]
                    if (post_action == OS_IO_APDU_POST_ACTION_EXIT) {
c0de0596:	2901      	cmp	r1, #1
c0de0598:	f000 80d2 	beq.w	c0de0740 <io_legacy_apdu_rx+0x27a>
                    if (status > 0) {
c0de059c:	ea00 75e0 	and.w	r5, r0, r0, asr #31
c0de05a0:	e0af      	b.n	c0de0702 <io_legacy_apdu_rx+0x23c>
                    G_io_app.apdu_media = get_media_from_apdu_type(io_os_legacy_apdu_type);
c0de05a2:	f819 6005 	ldrb.w	r6, [r9, r5]
    if (apdu_type == APDU_TYPE_RAW) {
c0de05a6:	2e21      	cmp	r6, #33	@ 0x21
c0de05a8:	dd47      	ble.n	c0de063a <io_legacy_apdu_rx+0x174>
c0de05aa:	2e2f      	cmp	r6, #47	@ 0x2f
c0de05ac:	dc4d      	bgt.n	c0de064a <io_legacy_apdu_rx+0x184>
c0de05ae:	2e22      	cmp	r6, #34	@ 0x22
c0de05b0:	d058      	beq.n	c0de0664 <io_legacy_apdu_rx+0x19e>
c0de05b2:	2e23      	cmp	r6, #35	@ 0x23
c0de05b4:	d15c      	bne.n	c0de0670 <io_legacy_apdu_rx+0x1aa>
c0de05b6:	2007      	movs	r0, #7
c0de05b8:	e05d      	b.n	c0de0676 <io_legacy_apdu_rx+0x1b0>
        switch (G_io_rx_buffer[0]) {
c0de05ba:	2830      	cmp	r0, #48	@ 0x30
c0de05bc:	d0ab      	beq.n	c0de0516 <io_legacy_apdu_rx+0x50>
c0de05be:	2840      	cmp	r0, #64	@ 0x40
c0de05c0:	d0a9      	beq.n	c0de0516 <io_legacy_apdu_rx+0x50>
c0de05c2:	2842      	cmp	r0, #66	@ 0x42
c0de05c4:	f040 809d 	bne.w	c0de0702 <io_legacy_apdu_rx+0x23c>
                memmove(G_io_apdu_buffer, &G_io_rx_buffer[1], status);
c0de05c8:	f240 0000 	movw	r0, #0
c0de05cc:	f2c0 0000 	movt	r0, #0
c0de05d0:	eb09 0107 	add.w	r1, r9, r7
c0de05d4:	4448      	add	r0, r9
c0de05d6:	3101      	adds	r1, #1
c0de05d8:	4622      	mov	r2, r4
c0de05da:	f003 feab 	bl	c0de4334 <__aeabi_memcpy>
c0de05de:	e08f      	b.n	c0de0700 <io_legacy_apdu_rx+0x23a>
        switch (G_io_rx_buffer[0]) {
c0de05e0:	3801      	subs	r0, #1
c0de05e2:	2802      	cmp	r0, #2
c0de05e4:	f080 808d 	bcs.w	c0de0702 <io_legacy_apdu_rx+0x23c>
                memcpy(G_io_seproxyhal_spi_buffer, &G_io_rx_buffer[1], status - 1);
c0de05e8:	f240 3594 	movw	r5, #916	@ 0x394
c0de05ec:	3c01      	subs	r4, #1
c0de05ee:	f2c0 0500 	movt	r5, #0
c0de05f2:	444f      	add	r7, r9
c0de05f4:	eb09 0005 	add.w	r0, r9, r5
c0de05f8:	1c79      	adds	r1, r7, #1
c0de05fa:	4622      	mov	r2, r4
c0de05fc:	f003 fe9a 	bl	c0de4334 <__aeabi_memcpy>
                if (G_io_rx_buffer[1] == SEPROXYHAL_TAG_ITC_EVENT) {
c0de0600:	7878      	ldrb	r0, [r7, #1]
c0de0602:	281a      	cmp	r0, #26
c0de0604:	d127      	bne.n	c0de0656 <io_legacy_apdu_rx+0x190>
                    status = io_process_itc_ux_event(G_io_seproxyhal_spi_buffer, status - 1);
c0de0606:	eb09 0005 	add.w	r0, r9, r5
c0de060a:	4621      	mov	r1, r4
c0de060c:	f7ff fed8 	bl	c0de03c0 <io_process_itc_ux_event>
c0de0610:	4605      	mov	r5, r0
c0de0612:	e076      	b.n	c0de0702 <io_legacy_apdu_rx+0x23c>
                    G_io_tx_buffer[0] = err >> 8;
c0de0614:	f240 0000 	movw	r0, #0
c0de0618:	f2c0 0000 	movt	r0, #0
c0de061c:	2155      	movs	r1, #85	@ 0x55
c0de061e:	f809 1000 	strb.w	r1, [r9, r0]
c0de0622:	eb09 0100 	add.w	r1, r9, r0
c0de0626:	2215      	movs	r2, #21
                    status            = os_io_tx_cmd(io_os_legacy_apdu_type, G_io_tx_buffer, 2, 0);
c0de0628:	f819 0005 	ldrb.w	r0, [r9, r5]
                    G_io_tx_buffer[1] = err;
c0de062c:	704a      	strb	r2, [r1, #1]
                    status            = os_io_tx_cmd(io_os_legacy_apdu_type, G_io_tx_buffer, 2, 0);
c0de062e:	2202      	movs	r2, #2
c0de0630:	2300      	movs	r3, #0
c0de0632:	f003 fd5d 	bl	c0de40f0 <os_io_tx_cmd>
c0de0636:	4605      	mov	r5, r0
c0de0638:	e063      	b.n	c0de0702 <io_legacy_apdu_rx+0x23c>
    if (apdu_type == APDU_TYPE_RAW) {
c0de063a:	2e10      	cmp	r6, #16
c0de063c:	d014      	beq.n	c0de0668 <io_legacy_apdu_rx+0x1a2>
c0de063e:	2e20      	cmp	r6, #32
c0de0640:	d018      	beq.n	c0de0674 <io_legacy_apdu_rx+0x1ae>
c0de0642:	2e21      	cmp	r6, #33	@ 0x21
c0de0644:	d114      	bne.n	c0de0670 <io_legacy_apdu_rx+0x1aa>
c0de0646:	2005      	movs	r0, #5
c0de0648:	e015      	b.n	c0de0676 <io_legacy_apdu_rx+0x1b0>
c0de064a:	2e30      	cmp	r6, #48	@ 0x30
c0de064c:	d00e      	beq.n	c0de066c <io_legacy_apdu_rx+0x1a6>
c0de064e:	2e40      	cmp	r6, #64	@ 0x40
c0de0650:	d10e      	bne.n	c0de0670 <io_legacy_apdu_rx+0x1aa>
c0de0652:	2003      	movs	r0, #3
c0de0654:	e00f      	b.n	c0de0676 <io_legacy_apdu_rx+0x1b0>
                    if (!handle_ux_events) {
c0de0656:	2e00      	cmp	r6, #0
c0de0658:	d062      	beq.n	c0de0720 <io_legacy_apdu_rx+0x25a>
c0de065a:	2000      	movs	r0, #0
c0de065c:	2500      	movs	r5, #0
c0de065e:	f002 fb34 	bl	c0de2cca <io_event>
c0de0662:	e04e      	b.n	c0de0702 <io_legacy_apdu_rx+0x23c>
c0de0664:	2004      	movs	r0, #4
c0de0666:	e006      	b.n	c0de0676 <io_legacy_apdu_rx+0x1b0>
c0de0668:	2006      	movs	r0, #6
c0de066a:	e004      	b.n	c0de0676 <io_legacy_apdu_rx+0x1b0>
c0de066c:	2002      	movs	r0, #2
c0de066e:	e002      	b.n	c0de0676 <io_legacy_apdu_rx+0x1b0>
c0de0670:	2000      	movs	r0, #0
c0de0672:	e000      	b.n	c0de0676 <io_legacy_apdu_rx+0x1b0>
c0de0674:	2001      	movs	r0, #1
                    G_io_app.apdu_media = get_media_from_apdu_type(io_os_legacy_apdu_type);
c0de0676:	f240 2824 	movw	r8, #548	@ 0x224
c0de067a:	f2c0 0800 	movt	r8, #0
c0de067e:	eb09 0108 	add.w	r1, r9, r8
c0de0682:	7188      	strb	r0, [r1, #6]
                    memmove(G_io_apdu_buffer, &G_io_rx_buffer[1], status);
c0de0684:	f240 0000 	movw	r0, #0
                    status -= 1;
c0de0688:	1e65      	subs	r5, r4, #1
                    memmove(G_io_apdu_buffer, &G_io_rx_buffer[1], status);
c0de068a:	f2c0 0000 	movt	r0, #0
c0de068e:	eb09 0107 	add.w	r1, r9, r7
c0de0692:	4448      	add	r0, r9
c0de0694:	3101      	adds	r1, #1
c0de0696:	462a      	mov	r2, r5
c0de0698:	f003 fe4c 	bl	c0de4334 <__aeabi_memcpy>
                    if (io_os_legacy_apdu_type == APDU_TYPE_USB_HID) {
c0de069c:	2e23      	cmp	r6, #35	@ 0x23
c0de069e:	dd0b      	ble.n	c0de06b8 <io_legacy_apdu_rx+0x1f2>
c0de06a0:	2e24      	cmp	r6, #36	@ 0x24
c0de06a2:	d018      	beq.n	c0de06d6 <io_legacy_apdu_rx+0x210>
c0de06a4:	2e25      	cmp	r6, #37	@ 0x25
c0de06a6:	d021      	beq.n	c0de06ec <io_legacy_apdu_rx+0x226>
c0de06a8:	2e40      	cmp	r6, #64	@ 0x40
c0de06aa:	d12a      	bne.n	c0de0702 <io_legacy_apdu_rx+0x23c>
                        G_io_u2f.media      = U2F_MEDIA_NFC;
c0de06ac:	f240 40b4 	movw	r0, #1204	@ 0x4b4
c0de06b0:	f2c0 0000 	movt	r0, #0
c0de06b4:	2102      	movs	r1, #2
c0de06b6:	e008      	b.n	c0de06ca <io_legacy_apdu_rx+0x204>
                    if (io_os_legacy_apdu_type == APDU_TYPE_USB_HID) {
c0de06b8:	2e20      	cmp	r6, #32
c0de06ba:	d026      	beq.n	c0de070a <io_legacy_apdu_rx+0x244>
c0de06bc:	2e23      	cmp	r6, #35	@ 0x23
c0de06be:	d120      	bne.n	c0de0702 <io_legacy_apdu_rx+0x23c>
                        G_io_u2f.media      = U2F_MEDIA_USB;
c0de06c0:	f240 40b4 	movw	r0, #1204	@ 0x4b4
c0de06c4:	f2c0 0000 	movt	r0, #0
c0de06c8:	2101      	movs	r1, #1
c0de06ca:	f809 1000 	strb.w	r1, [r9, r0]
c0de06ce:	200a      	movs	r0, #10
c0de06d0:	f809 0008 	strb.w	r0, [r9, r8]
c0de06d4:	e015      	b.n	c0de0702 <io_legacy_apdu_rx+0x23c>
                        G_io_u2f.media      = U2F_MEDIA_USB;
c0de06d6:	f240 40b4 	movw	r0, #1204	@ 0x4b4
c0de06da:	f2c0 0000 	movt	r0, #0
c0de06de:	2101      	movs	r1, #1
c0de06e0:	f809 1000 	strb.w	r1, [r9, r0]
c0de06e4:	200b      	movs	r0, #11
                        G_io_app.apdu_state = APDU_U2F_CBOR;
c0de06e6:	f809 0008 	strb.w	r0, [r9, r8]
c0de06ea:	e00a      	b.n	c0de0702 <io_legacy_apdu_rx+0x23c>
                        G_io_u2f.media      = U2F_MEDIA_USB;
c0de06ec:	f240 40b4 	movw	r0, #1204	@ 0x4b4
c0de06f0:	f2c0 0000 	movt	r0, #0
c0de06f4:	2101      	movs	r1, #1
c0de06f6:	f809 1000 	strb.w	r1, [r9, r0]
c0de06fa:	200c      	movs	r0, #12
                        G_io_app.apdu_state = APDU_U2F_CANCEL;
c0de06fc:	f809 0008 	strb.w	r0, [r9, r8]
c0de0700:	4625      	mov	r5, r4
    return status;
c0de0702:	4628      	mov	r0, r5
c0de0704:	b004      	add	sp, #16
c0de0706:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
                        G_io_u2f.media      = U2F_MEDIA_USB;
c0de070a:	f240 40b4 	movw	r0, #1204	@ 0x4b4
c0de070e:	f2c0 0000 	movt	r0, #0
c0de0712:	2101      	movs	r1, #1
c0de0714:	f809 1000 	strb.w	r1, [r9, r0]
c0de0718:	2008      	movs	r0, #8
                        G_io_app.apdu_state = APDU_USB_HID;
c0de071a:	f809 0008 	strb.w	r0, [r9, r8]
c0de071e:	e7f0      	b.n	c0de0702 <io_legacy_apdu_rx+0x23c>
                        if ((G_io_seproxyhal_spi_buffer[0] != SEPROXYHAL_TAG_FINGER_EVENT)
c0de0720:	f819 0005 	ldrb.w	r0, [r9, r5]
                            && (G_io_seproxyhal_spi_buffer[0] != SEPROXYHAL_TAG_BUTTON_PUSH_EVENT)
c0de0724:	2815      	cmp	r0, #21
c0de0726:	d898      	bhi.n	c0de065a <io_legacy_apdu_rx+0x194>
c0de0728:	2101      	movs	r1, #1
c0de072a:	fa01 f000 	lsl.w	r0, r1, r0
c0de072e:	f245 0120 	movw	r1, #20512	@ 0x5020
c0de0732:	f2c0 0120 	movt	r1, #32
c0de0736:	4208      	tst	r0, r1
c0de0738:	f43f af8f 	beq.w	c0de065a <io_legacy_apdu_rx+0x194>
c0de073c:	2500      	movs	r5, #0
c0de073e:	e7e0      	b.n	c0de0702 <io_legacy_apdu_rx+0x23c>
                        os_sched_exit(-1);
c0de0740:	20ff      	movs	r0, #255	@ 0xff
c0de0742:	f003 fca7 	bl	c0de4094 <os_sched_exit>

c0de0746 <io_seproxyhal_init>:
{
c0de0746:	b510      	push	{r4, lr}
c0de0748:	b08a      	sub	sp, #40	@ 0x28
    io_os_legacy_apdu_type = APDU_TYPE_NONE;
c0de074a:	f240 202c 	movw	r0, #556	@ 0x22c
c0de074e:	f2c0 0000 	movt	r0, #0
c0de0752:	2100      	movs	r1, #0
c0de0754:	f809 1000 	strb.w	r1, [r9, r0]
c0de0758:	2015      	movs	r0, #21
c0de075a:	f2c0 0002 	movt	r0, #2
    init_io.usb.class_mask |= USBD_LEDGER_CLASS_HID_U2F;
c0de075e:	9007      	str	r0, [sp, #28]
c0de0760:	2401      	movs	r4, #1
c0de0762:	a801      	add	r0, sp, #4
    init_io.usb.vid        = 0;
c0de0764:	e9cd 1101 	strd	r1, r1, [sp, #4]
c0de0768:	e9cd 1103 	strd	r1, r1, [sp, #12]
c0de076c:	e9cd 1105 	strd	r1, r1, [sp, #20]
    init_io.usb.hid_u2f_settings.minor_device_version_number = 1;
c0de0770:	f8ad 4020 	strh.w	r4, [sp, #32]
    init_io.usb.hid_u2f_settings.capabilities_flag = 0;
c0de0774:	f88d 1022 	strb.w	r1, [sp, #34]	@ 0x22
    init_io.ble.profile_mask = 0;
c0de0778:	f8ad 1024 	strh.w	r1, [sp, #36]	@ 0x24
    os_io_init(&init_io);
c0de077c:	f003 fc95 	bl	c0de40aa <os_io_init>
    need_to_start_io = 1;
c0de0780:	f240 2022 	movw	r0, #546	@ 0x222
c0de0784:	f2c0 0000 	movt	r0, #0
c0de0788:	f809 4000 	strb.w	r4, [r9, r0]
}
c0de078c:	b00a      	add	sp, #40	@ 0x28
c0de078e:	bd10      	pop	{r4, pc}

c0de0790 <nbgl_layoutGet>:
 *
 * @param description description of layout
 * @return a pointer to the corresponding layout
 */
nbgl_layout_t *nbgl_layoutGet(const nbgl_layoutDescription_t *description)
{
c0de0790:	b570      	push	{r4, r5, r6, lr}
c0de0792:	4604      	mov	r4, r0
    nbgl_layoutInternal_t *layout = NULL;

    // find an empty layout in the proper "layer"
    if (description->modal) {
c0de0794:	7800      	ldrb	r0, [r0, #0]
c0de0796:	b1a0      	cbz	r0, c0de07c2 <nbgl_layoutGet+0x32>
        if (gLayout[1].nbChildren == 0) {
c0de0798:	f240 2130 	movw	r1, #560	@ 0x230
c0de079c:	f2c0 0100 	movt	r1, #0
c0de07a0:	eb09 0201 	add.w	r2, r9, r1
c0de07a4:	7b90      	ldrb	r0, [r2, #14]
c0de07a6:	2800      	cmp	r0, #0
c0de07a8:	f04f 0000 	mov.w	r0, #0
c0de07ac:	d012      	beq.n	c0de07d4 <nbgl_layoutGet+0x44>
            layout = &gLayout[1];
        }
        else if (gLayout[2].nbChildren == 0) {
c0de07ae:	4449      	add	r1, r9
c0de07b0:	7e8a      	ldrb	r2, [r1, #26]
c0de07b2:	2a00      	cmp	r2, #0
c0de07b4:	bf14      	ite	ne
c0de07b6:	2201      	movne	r2, #1
c0de07b8:	f101 0018 	addeq.w	r0, r1, #24
c0de07bc:	4606      	mov	r6, r0
c0de07be:	4610      	mov	r0, r2
c0de07c0:	e00a      	b.n	c0de07d8 <nbgl_layoutGet+0x48>
            layout = &gLayout[2];
        }
    }
    else {
        // automatically "release" a potentially opened non-modal layout
        gLayout[0].nbChildren = 0;
c0de07c2:	f240 2030 	movw	r0, #560	@ 0x230
c0de07c6:	f2c0 0000 	movt	r0, #0
c0de07ca:	eb09 0600 	add.w	r6, r9, r0
c0de07ce:	2000      	movs	r0, #0
c0de07d0:	70b0      	strb	r0, [r6, #2]
c0de07d2:	e001      	b.n	c0de07d8 <nbgl_layoutGet+0x48>
c0de07d4:	f102 060c 	add.w	r6, r2, #12
        layout                = &gLayout[0];
    }
    if (layout == NULL) {
c0de07d8:	2800      	cmp	r0, #0
c0de07da:	f04f 0000 	mov.w	r0, #0
                       (nbgl_buttonCallback_t) buttonCallback);
        layout->layer = 0;
    }

    return (nbgl_layout_t *) layout;
}
c0de07de:	bf18      	it	ne
c0de07e0:	bd70      	popne	{r4, r5, r6, pc}
    memset(layout, 0, sizeof(nbgl_layoutInternal_t));
c0de07e2:	4635      	mov	r5, r6
c0de07e4:	60b0      	str	r0, [r6, #8]
c0de07e6:	6030      	str	r0, [r6, #0]
c0de07e8:	f845 0f04 	str.w	r0, [r5, #4]!
    layout->callback = (nbgl_layoutButtonCallback_t) PIC(description->onActionCallback);
c0de07ec:	6860      	ldr	r0, [r4, #4]
c0de07ee:	f003 fbdb 	bl	c0de3fa8 <pic>
    layout->modal    = description->modal;
c0de07f2:	7821      	ldrb	r1, [r4, #0]
    layout->callback = (nbgl_layoutButtonCallback_t) PIC(description->onActionCallback);
c0de07f4:	60b0      	str	r0, [r6, #8]
    layout->modal    = description->modal;
c0de07f6:	7031      	strb	r1, [r6, #0]
        nbgl_screenSet(&layout->children,
c0de07f8:	f240 031b 	movw	r3, #27
c0de07fc:	f2c0 0300 	movt	r3, #0
    if (description->modal) {
c0de0800:	2900      	cmp	r1, #0
c0de0802:	f104 0208 	add.w	r2, r4, #8
        nbgl_screenSet(&layout->children,
c0de0806:	447b      	add	r3, pc
c0de0808:	4628      	mov	r0, r5
c0de080a:	f04f 0107 	mov.w	r1, #7
    if (description->modal) {
c0de080e:	d002      	beq.n	c0de0816 <nbgl_layoutGet+0x86>
        layout->layer = nbgl_screenPush(&layout->children,
c0de0810:	f002 fcc9 	bl	c0de31a6 <nbgl_screenPush>
c0de0814:	e002      	b.n	c0de081c <nbgl_layoutGet+0x8c>
        nbgl_screenSet(&layout->children,
c0de0816:	f002 fcc1 	bl	c0de319c <nbgl_screenSet>
c0de081a:	2000      	movs	r0, #0
c0de081c:	7070      	strb	r0, [r6, #1]
c0de081e:	4630      	mov	r0, r6
}
c0de0820:	bd70      	pop	{r4, r5, r6, pc}
	...

c0de0824 <buttonCallback>:
{
c0de0824:	b580      	push	{r7, lr}
c0de0826:	f890 203e 	ldrb.w	r2, [r0, #62]	@ 0x3e
c0de082a:	f240 2c30 	movw	ip, #560	@ 0x230
c0de082e:	2000      	movs	r0, #0
c0de0830:	f2c0 0c00 	movt	ip, #0
c0de0834:	e004      	b.n	c0de0840 <buttonCallback+0x1c>
c0de0836:	bf00      	nop
    while (i > 0) {
c0de0838:	380c      	subs	r0, #12
c0de083a:	f110 0324 	adds.w	r3, r0, #36	@ 0x24
c0de083e:	d010      	beq.n	c0de0862 <buttonCallback+0x3e>
        if ((screen->index == gLayout[i].layer) && (gLayout[i].nbChildren > 0)) {
c0de0840:	eb09 030c 	add.w	r3, r9, ip
c0de0844:	4403      	add	r3, r0
c0de0846:	7e5b      	ldrb	r3, [r3, #25]
c0de0848:	429a      	cmp	r2, r3
c0de084a:	d1f5      	bne.n	c0de0838 <buttonCallback+0x14>
c0de084c:	eb09 030c 	add.w	r3, r9, ip
c0de0850:	4403      	add	r3, r0
c0de0852:	7e9b      	ldrb	r3, [r3, #26]
c0de0854:	2b00      	cmp	r3, #0
c0de0856:	d0ef      	beq.n	c0de0838 <buttonCallback+0x14>
    if (layout == NULL) {
c0de0858:	eb09 020c 	add.w	r2, r9, ip
c0de085c:	4410      	add	r0, r2
c0de085e:	3018      	adds	r0, #24
c0de0860:	e000      	b.n	c0de0864 <buttonCallback+0x40>
c0de0862:	2000      	movs	r0, #0
c0de0864:	2800      	cmp	r0, #0
}
c0de0866:	bf08      	it	eq
c0de0868:	bd80      	popeq	{r7, pc}
    if (layout->callback != NULL) {
c0de086a:	6882      	ldr	r2, [r0, #8]
c0de086c:	2a00      	cmp	r2, #0
        layout->callback((nbgl_layout_t *) layout, buttonEvent);
c0de086e:	bf18      	it	ne
c0de0870:	4790      	blxne	r2
}
c0de0872:	bd80      	pop	{r7, pc}

c0de0874 <nbgl_layoutAddNavigation>:
 * @param layout the current layout
 * @param info structure giving the description of the navigation
 * @return >= 0 if OK
 */
int nbgl_layoutAddNavigation(nbgl_layout_t *layout, nbgl_layoutNavigation_t *info)
{
c0de0874:	b570      	push	{r4, r5, r6, lr}
    nbgl_layoutInternal_t *layoutInt = (nbgl_layoutInternal_t *) layout;

    LOG_DEBUG(LAYOUT_LOGGER, "nbgl_layoutAddNavigation():\n");
    if (layout == NULL) {
c0de0876:	2800      	cmp	r0, #0
c0de0878:	d059      	beq.n	c0de092e <nbgl_layoutAddNavigation+0xba>
c0de087a:	4604      	mov	r4, r0
        return -1;
    }

    nbgl_image_t *image;
    if (info->indication & LEFT_ARROW) {
c0de087c:	7848      	ldrb	r0, [r1, #1]
c0de087e:	460d      	mov	r5, r1
c0de0880:	07c0      	lsls	r0, r0, #31
c0de0882:	d027      	beq.n	c0de08d4 <nbgl_layoutAddNavigation+0x60>
        image                  = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de0884:	7861      	ldrb	r1, [r4, #1]
c0de0886:	2002      	movs	r0, #2
c0de0888:	f002 fca1 	bl	c0de31ce <nbgl_objPoolGet>
c0de088c:	2103      	movs	r1, #3
        image->foregroundColor = WHITE;
c0de088e:	77c1      	strb	r1, [r0, #31]
        image->buffer          = (info->direction == HORIZONTAL_NAV) ? &C_icon_left : &C_icon_up;
c0de0890:	7829      	ldrb	r1, [r5, #0]
c0de0892:	f643 426d 	movw	r2, #15469	@ 0x3c6d
c0de0896:	f2c0 0200 	movt	r2, #0
c0de089a:	f643 4387 	movw	r3, #15495	@ 0x3c87
c0de089e:	f2c0 0300 	movt	r3, #0
c0de08a2:	447a      	add	r2, pc
c0de08a4:	447b      	add	r3, pc
c0de08a6:	2900      	cmp	r1, #0
c0de08a8:	4601      	mov	r1, r0
c0de08aa:	bf08      	it	eq
c0de08ac:	4613      	moveq	r3, r2
c0de08ae:	f801 3f21 	strb.w	r3, [r1, #33]!
c0de08b2:	0e1a      	lsrs	r2, r3, #24
c0de08b4:	70ca      	strb	r2, [r1, #3]
c0de08b6:	0c1a      	lsrs	r2, r3, #16
c0de08b8:	708a      	strb	r2, [r1, #2]
c0de08ba:	0a19      	lsrs	r1, r3, #8
c0de08bc:	f880 1022 	strb.w	r1, [r0, #34]	@ 0x22
c0de08c0:	2100      	movs	r1, #0
    if (layout->nbChildren == NB_MAX_SCREEN_CHILDREN) {
c0de08c2:	78a2      	ldrb	r2, [r4, #2]
    layout->children[layout->nbChildren] = obj;
c0de08c4:	6863      	ldr	r3, [r4, #4]
        image->obj.area.bpp    = NBGL_BPP_1;
c0de08c6:	7241      	strb	r1, [r0, #9]
c0de08c8:	2104      	movs	r1, #4
        image->obj.alignment   = MID_LEFT;
c0de08ca:	7581      	strb	r1, [r0, #22]
    layout->children[layout->nbChildren] = obj;
c0de08cc:	f843 0022 	str.w	r0, [r3, r2, lsl #2]
    layout->nbChildren++;
c0de08d0:	1c50      	adds	r0, r2, #1
c0de08d2:	70a0      	strb	r0, [r4, #2]
        layoutAddObject(layoutInt, (nbgl_obj_t *) image);
    }
    if (info->indication & RIGHT_ARROW) {
c0de08d4:	7868      	ldrb	r0, [r5, #1]
c0de08d6:	2600      	movs	r6, #0
c0de08d8:	0780      	lsls	r0, r0, #30
c0de08da:	d526      	bpl.n	c0de092a <nbgl_layoutAddNavigation+0xb6>
        image                  = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de08dc:	7861      	ldrb	r1, [r4, #1]
c0de08de:	2002      	movs	r0, #2
c0de08e0:	f002 fc75 	bl	c0de31ce <nbgl_objPoolGet>
c0de08e4:	2103      	movs	r1, #3
        image->foregroundColor = WHITE;
c0de08e6:	77c1      	strb	r1, [r0, #31]
        image->buffer          = (info->direction == HORIZONTAL_NAV) ? &C_icon_right : &C_icon_down;
c0de08e8:	7829      	ldrb	r1, [r5, #0]
c0de08ea:	f643 4223 	movw	r2, #15395	@ 0x3c23
c0de08ee:	f2c0 0200 	movt	r2, #0
c0de08f2:	f643 4305 	movw	r3, #15365	@ 0x3c05
c0de08f6:	f2c0 0300 	movt	r3, #0
c0de08fa:	447a      	add	r2, pc
c0de08fc:	447b      	add	r3, pc
c0de08fe:	2900      	cmp	r1, #0
c0de0900:	4601      	mov	r1, r0
c0de0902:	bf08      	it	eq
c0de0904:	4613      	moveq	r3, r2
c0de0906:	f801 3f21 	strb.w	r3, [r1, #33]!
c0de090a:	0e1a      	lsrs	r2, r3, #24
c0de090c:	70ca      	strb	r2, [r1, #3]
c0de090e:	0c1a      	lsrs	r2, r3, #16
c0de0910:	708a      	strb	r2, [r1, #2]
c0de0912:	0a19      	lsrs	r1, r3, #8
c0de0914:	f880 1022 	strb.w	r1, [r0, #34]	@ 0x22
    if (layout->nbChildren == NB_MAX_SCREEN_CHILDREN) {
c0de0918:	78a2      	ldrb	r2, [r4, #2]
    layout->children[layout->nbChildren] = obj;
c0de091a:	6863      	ldr	r3, [r4, #4]
c0de091c:	2106      	movs	r1, #6
        image->obj.area.bpp    = NBGL_BPP_1;
c0de091e:	7246      	strb	r6, [r0, #9]
        image->obj.alignment   = MID_RIGHT;
c0de0920:	7581      	strb	r1, [r0, #22]
    layout->children[layout->nbChildren] = obj;
c0de0922:	f843 0022 	str.w	r0, [r3, r2, lsl #2]
    layout->nbChildren++;
c0de0926:	1c50      	adds	r0, r2, #1
c0de0928:	70a0      	strb	r0, [r4, #2]
        layoutAddObject(layoutInt, (nbgl_obj_t *) image);
    }
    return 0;
}
c0de092a:	4630      	mov	r0, r6
c0de092c:	bd70      	pop	{r4, r5, r6, pc}
c0de092e:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de0932:	bd70      	pop	{r4, r5, r6, pc}

c0de0934 <nbgl_layoutAddText>:
 */
int nbgl_layoutAddText(nbgl_layout_t                  *layout,
                       const char                     *text,
                       const char                     *subText,
                       nbgl_contentCenteredInfoStyle_t style)
{
c0de0934:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de0938:	b088      	sub	sp, #32
    nbgl_container_t      *container;
    nbgl_text_area_t      *textArea;
    uint16_t               fullHeight = 0;

    LOG_DEBUG(LAYOUT_LOGGER, "nbgl_layoutAddText():\n");
    if (layout == NULL) {
c0de093a:	2800      	cmp	r0, #0
c0de093c:	9005      	str	r0, [sp, #20]
c0de093e:	f000 8121 	beq.w	c0de0b84 <nbgl_layoutAddText+0x250>
c0de0942:	f8dd b014 	ldr.w	fp, [sp, #20]
c0de0946:	460e      	mov	r6, r1
        return -1;
    }
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de0948:	f89b 1001 	ldrb.w	r1, [fp, #1]
c0de094c:	2001      	movs	r0, #1
c0de094e:	4617      	mov	r7, r2
c0de0950:	461c      	mov	r4, r3
c0de0952:	f002 fc3c 	bl	c0de31ce <nbgl_objPoolGet>
c0de0956:	4605      	mov	r5, r0

    // get container children
    container->nbChildren = 1;
    if (subText != NULL) {
c0de0958:	2003      	movs	r0, #3
c0de095a:	2f00      	cmp	r7, #0
c0de095c:	bf08      	it	eq
c0de095e:	2001      	moveq	r0, #1
        container->nbChildren += 2;  // possibly 2 buttons
    }

    container->children       = nbgl_containerPoolGet(container->nbChildren, layoutInt->layer);
c0de0960:	f89b 1001 	ldrb.w	r1, [fp, #1]
c0de0964:	f885 0020 	strb.w	r0, [r5, #32]
c0de0968:	f002 fc36 	bl	c0de31d8 <nbgl_containerPoolGet>
c0de096c:	4629      	mov	r1, r5
c0de096e:	f801 0f22 	strb.w	r0, [r1, #34]!
c0de0972:	0e02      	lsrs	r2, r0, #24
c0de0974:	70ca      	strb	r2, [r1, #3]
c0de0976:	0c02      	lsrs	r2, r0, #16
c0de0978:	0a00      	lsrs	r0, r0, #8
c0de097a:	f04f 0a72 	mov.w	sl, #114	@ 0x72
c0de097e:	708a      	strb	r2, [r1, #2]
c0de0980:	f885 0023 	strb.w	r0, [r5, #35]	@ 0x23
    container->obj.area.width = AVAILABLE_WIDTH;
c0de0984:	f885 a004 	strb.w	sl, [r5, #4]

    textArea                 = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de0988:	f89b 1001 	ldrb.w	r1, [fp, #1]
c0de098c:	f04f 0800 	mov.w	r8, #0
c0de0990:	2004      	movs	r0, #4
c0de0992:	9704      	str	r7, [sp, #16]
    container->obj.area.width = AVAILABLE_WIDTH;
c0de0994:	f885 8005 	strb.w	r8, [r5, #5]
c0de0998:	f04f 0b04 	mov.w	fp, #4
    textArea                 = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de099c:	f002 fc17 	bl	c0de31ce <nbgl_objPoolGet>
c0de09a0:	4607      	mov	r7, r0
    textArea->textColor      = WHITE;
c0de09a2:	2003      	movs	r0, #3
c0de09a4:	77f8      	strb	r0, [r7, #31]
    textArea->text           = PIC(text);
c0de09a6:	4630      	mov	r0, r6
c0de09a8:	f003 fafe 	bl	c0de3fa8 <pic>
c0de09ac:	4601      	mov	r1, r0
c0de09ae:	4638      	mov	r0, r7
c0de09b0:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de09b4:	0e0a      	lsrs	r2, r1, #24
c0de09b6:	70c2      	strb	r2, [r0, #3]
c0de09b8:	0c0a      	lsrs	r2, r1, #16
c0de09ba:	7082      	strb	r2, [r0, #2]
c0de09bc:	0a08      	lsrs	r0, r1, #8
c0de09be:	f887 0027 	strb.w	r0, [r7, #39]	@ 0x27
c0de09c2:	2005      	movs	r0, #5
    textArea->textAlignment  = CENTER;
c0de09c4:	f887 0020 	strb.w	r0, [r7, #32]
c0de09c8:	2008      	movs	r0, #8
    textArea->fontId         = (style == REGULAR_INFO) ? BAGL_FONT_OPEN_SANS_REGULAR_11px_1bpp
                                                       : BAGL_FONT_OPEN_SANS_EXTRABOLD_11px_1bpp;
    textArea->obj.area.width = AVAILABLE_WIDTH;

    uint16_t nbLines
        = nbgl_getTextNbLinesInWidth(textArea->fontId, textArea->text, AVAILABLE_WIDTH, true);
c0de09ca:	2272      	movs	r2, #114	@ 0x72
c0de09cc:	2301      	movs	r3, #1
c0de09ce:	9403      	str	r4, [sp, #12]
    textArea->fontId         = (style == REGULAR_INFO) ? BAGL_FONT_OPEN_SANS_REGULAR_11px_1bpp
c0de09d0:	2c00      	cmp	r4, #0
c0de09d2:	bf08      	it	eq
c0de09d4:	200a      	moveq	r0, #10
c0de09d6:	f887 0022 	strb.w	r0, [r7, #34]	@ 0x22
    textArea->obj.area.width = AVAILABLE_WIDTH;
c0de09da:	f887 8005 	strb.w	r8, [r7, #5]
c0de09de:	f887 a004 	strb.w	sl, [r7, #4]
        = nbgl_getTextNbLinesInWidth(textArea->fontId, textArea->text, AVAILABLE_WIDTH, true);
c0de09e2:	f002 fc0d 	bl	c0de3200 <nbgl_getTextNbLinesInWidth>
c0de09e6:	4606      	mov	r6, r0
    // if more than available lines on screen
    if (nbLines > NB_MAX_LINES) {
c0de09e8:	2805      	cmp	r0, #5
c0de09ea:	d31e      	bcc.n	c0de0a2a <nbgl_layoutAddText+0xf6>
        uint16_t len;

        nbLines              = NB_MAX_LINES;
        textArea->nbMaxLines = NB_MAX_LINES;
        nbgl_getTextMaxLenInNbLines(
            textArea->fontId, textArea->text, AVAILABLE_WIDTH, nbLines, &len, true);
c0de09ec:	463e      	mov	r6, r7
c0de09ee:	f816 1f26 	ldrb.w	r1, [r6, #38]!
c0de09f2:	7872      	ldrb	r2, [r6, #1]
c0de09f4:	78b3      	ldrb	r3, [r6, #2]
c0de09f6:	78f4      	ldrb	r4, [r6, #3]
c0de09f8:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de09fc:	ea43 2204 	orr.w	r2, r3, r4, lsl #8
c0de0a00:	f816 0c04 	ldrb.w	r0, [r6, #-4]
c0de0a04:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de0a08:	f10d 021e 	add.w	r2, sp, #30
        textArea->nbMaxLines = NB_MAX_LINES;
c0de0a0c:	f806 bc01 	strb.w	fp, [r6, #-1]
        nbgl_getTextMaxLenInNbLines(
c0de0a10:	9200      	str	r2, [sp, #0]
c0de0a12:	2272      	movs	r2, #114	@ 0x72
c0de0a14:	2304      	movs	r3, #4
c0de0a16:	2401      	movs	r4, #1
c0de0a18:	9401      	str	r4, [sp, #4]
c0de0a1a:	f002 fc00 	bl	c0de321e <nbgl_getTextMaxLenInNbLines>
        textArea->len = len;
c0de0a1e:	f8bd 001e 	ldrh.w	r0, [sp, #30]
c0de0a22:	7130      	strb	r0, [r6, #4]
c0de0a24:	0a00      	lsrs	r0, r0, #8
c0de0a26:	7170      	strb	r0, [r6, #5]
c0de0a28:	2604      	movs	r6, #4
    }
    const nbgl_font_t *font   = nbgl_getFont(textArea->fontId);
c0de0a2a:	f897 0022 	ldrb.w	r0, [r7, #34]	@ 0x22
c0de0a2e:	f002 fbd8 	bl	c0de31e2 <nbgl_getFont>
c0de0a32:	4682      	mov	sl, r0
    textArea->obj.area.height = nbLines * font->line_height;
c0de0a34:	79c0      	ldrb	r0, [r0, #7]
    textArea->wrapping        = true;
c0de0a36:	f897 1024 	ldrb.w	r1, [r7, #36]	@ 0x24
    textArea->obj.area.height = nbLines * font->line_height;
c0de0a3a:	fb06 f800 	mul.w	r8, r6, r0
c0de0a3e:	ea4f 2018 	mov.w	r0, r8, lsr #8
c0de0a42:	71f8      	strb	r0, [r7, #7]
    textArea->wrapping        = true;
c0de0a44:	f041 0001 	orr.w	r0, r1, #1
    textArea->obj.area.height = nbLines * font->line_height;
c0de0a48:	f887 8006 	strb.w	r8, [r7, #6]
    textArea->wrapping        = true;
c0de0a4c:	f887 0024 	strb.w	r0, [r7, #36]	@ 0x24
    textArea->obj.alignment   = TOP_MIDDLE;
    fullHeight += textArea->obj.area.height;
    container->children[0] = (nbgl_obj_t *) textArea;
c0de0a50:	4629      	mov	r1, r5
c0de0a52:	f811 2f22 	ldrb.w	r2, [r1, #34]!
c0de0a56:	2002      	movs	r0, #2
    textArea->obj.alignment   = TOP_MIDDLE;
c0de0a58:	75b8      	strb	r0, [r7, #22]
    container->children[0] = (nbgl_obj_t *) textArea;
c0de0a5a:	7848      	ldrb	r0, [r1, #1]
c0de0a5c:	788b      	ldrb	r3, [r1, #2]
c0de0a5e:	78c9      	ldrb	r1, [r1, #3]
c0de0a60:	9c04      	ldr	r4, [sp, #16]
c0de0a62:	ea42 2000 	orr.w	r0, r2, r0, lsl #8
c0de0a66:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de0a6a:	ea40 4001 	orr.w	r0, r0, r1, lsl #16

    if (subText != NULL) {
c0de0a6e:	2c00      	cmp	r4, #0
    container->children[0] = (nbgl_obj_t *) textArea;
c0de0a70:	6007      	str	r7, [r0, #0]
    if (subText != NULL) {
c0de0a72:	f000 81a1 	beq.w	c0de0db8 <nbgl_layoutAddText+0x484>
c0de0a76:	9805      	ldr	r0, [sp, #20]
c0de0a78:	7841      	ldrb	r1, [r0, #1]
        if (style != BUTTON_INFO) {
c0de0a7a:	9803      	ldr	r0, [sp, #12]
c0de0a7c:	2802      	cmp	r0, #2
c0de0a7e:	f040 8086 	bne.w	c0de0b8e <nbgl_layoutAddText+0x25a>
            textArea->obj.alignmentMarginY = 2;
            fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
            container->children[1] = (nbgl_obj_t *) textArea;
        }
        else {
            nbgl_button_t *button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de0a82:	2005      	movs	r0, #5
c0de0a84:	f04f 0a05 	mov.w	sl, #5
c0de0a88:	f002 fba1 	bl	c0de31ce <nbgl_objPoolGet>
c0de0a8c:	2600      	movs	r6, #0
c0de0a8e:	4607      	mov	r7, r0
            uint16_t       textWidth;
            uint16_t       len   = 0;
            uint16_t       width = 0;

            button->foregroundColor = BLACK;
c0de0a90:	f880 6021 	strb.w	r6, [r0, #33]	@ 0x21
c0de0a94:	2003      	movs	r0, #3
            button->innerColor      = WHITE;
c0de0a96:	77f8      	strb	r0, [r7, #31]
            button->borderColor     = WHITE;
c0de0a98:	f887 0020 	strb.w	r0, [r7, #32]
c0de0a9c:	2001      	movs	r0, #1
            button->radius          = RADIUS_3_PIXELS;
c0de0a9e:	f887 0022 	strb.w	r0, [r7, #34]	@ 0x22
            button->text            = (const char *) PIC(subText);
c0de0aa2:	4620      	mov	r0, r4
            uint16_t       len   = 0;
c0de0aa4:	f8ad 601a 	strh.w	r6, [sp, #26]
            uint16_t       width = 0;
c0de0aa8:	f8ad 6018 	strh.w	r6, [sp, #24]
            button->text            = (const char *) PIC(subText);
c0de0aac:	f003 fa7c 	bl	c0de3fa8 <pic>
c0de0ab0:	4601      	mov	r1, r0
c0de0ab2:	4638      	mov	r0, r7
c0de0ab4:	f800 1f25 	strb.w	r1, [r0, #37]!
c0de0ab8:	0e0a      	lsrs	r2, r1, #24
c0de0aba:	70c2      	strb	r2, [r0, #3]
c0de0abc:	0c0a      	lsrs	r2, r1, #16
c0de0abe:	7082      	strb	r2, [r0, #2]
c0de0ac0:	0a08      	lsrs	r0, r1, #8
c0de0ac2:	f887 0026 	strb.w	r0, [r7, #38]	@ 0x26
c0de0ac6:	2008      	movs	r0, #8
            button->fontId          = BAGL_FONT_OPEN_SANS_EXTRABOLD_11px_1bpp;
c0de0ac8:	f887 0023 	strb.w	r0, [r7, #35]	@ 0x23
c0de0acc:	200e      	movs	r0, #14
            button->obj.area.height = 14;
c0de0ace:	71b8      	strb	r0, [r7, #6]
            button->obj.alignment   = CENTER;

            textWidth = nbgl_getTextWidth(button->fontId, button->text);
c0de0ad0:	2008      	movs	r0, #8
            button->obj.area.height = 14;
c0de0ad2:	71fe      	strb	r6, [r7, #7]
            button->obj.alignment   = CENTER;
c0de0ad4:	f887 a016 	strb.w	sl, [r7, #22]
            textWidth = nbgl_getTextWidth(button->fontId, button->text);
c0de0ad8:	f002 fb9c 	bl	c0de3214 <nbgl_getTextWidth>
            if ((textWidth + BUTTON_MARGIN_Y) >= AVAILABLE_WIDTH) {
c0de0adc:	2866      	cmp	r0, #102	@ 0x66
c0de0ade:	f0c0 80c4 	bcc.w	c0de0c6a <nbgl_layoutAddText+0x336>
                static char tmpString[NB_MAX_CHAR_IN_LINE];
                nbgl_getTextMaxLenAndWidth(button->fontId,
                                           button->text,
c0de0ae2:	46bb      	mov	fp, r7
c0de0ae4:	f81b 1f25 	ldrb.w	r1, [fp, #37]!
c0de0ae8:	2401      	movs	r4, #1
c0de0aea:	f89b 2001 	ldrb.w	r2, [fp, #1]
c0de0aee:	f89b 3002 	ldrb.w	r3, [fp, #2]
c0de0af2:	f89b 6003 	ldrb.w	r6, [fp, #3]
c0de0af6:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de0afa:	ea43 2206 	orr.w	r2, r3, r6, lsl #8
                nbgl_getTextMaxLenAndWidth(button->fontId,
c0de0afe:	f81b 0c02 	ldrb.w	r0, [fp, #-2]
                                           button->text,
c0de0b02:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de0b06:	aa06      	add	r2, sp, #24
                nbgl_getTextMaxLenAndWidth(button->fontId,
c0de0b08:	9200      	str	r2, [sp, #0]
c0de0b0a:	f10d 031a 	add.w	r3, sp, #26
c0de0b0e:	2266      	movs	r2, #102	@ 0x66
c0de0b10:	9401      	str	r4, [sp, #4]
c0de0b12:	f002 fb70 	bl	c0de31f6 <nbgl_getTextMaxLenAndWidth>
                                           AVAILABLE_WIDTH - BUTTON_MARGIN_Y,
                                           &len,
                                           &width,
                                           true);
                button->obj.area.width = width + BUTTON_MARGIN_Y;
c0de0b16:	f8bd 0018 	ldrh.w	r0, [sp, #24]
                // copy the first 'len' chars in the tmp string buffer (max is
                // NB_MAX_CHAR_IN_LINE-1)
                memcpy(tmpString, button->text, MIN(len, (NB_MAX_CHAR_IN_LINE - 1)));
c0de0b1a:	f89b 1002 	ldrb.w	r1, [fp, #2]
                button->obj.area.width = width + BUTTON_MARGIN_Y;
c0de0b1e:	300c      	adds	r0, #12
c0de0b20:	f80b 0c21 	strb.w	r0, [fp, #-33]
c0de0b24:	0a00      	lsrs	r0, r0, #8
c0de0b26:	f80b 0c20 	strb.w	r0, [fp, #-32]
                memcpy(tmpString, button->text, MIN(len, (NB_MAX_CHAR_IN_LINE - 1)));
c0de0b2a:	f89b 0000 	ldrb.w	r0, [fp]
c0de0b2e:	f89b 2003 	ldrb.w	r2, [fp, #3]
c0de0b32:	f89b 3001 	ldrb.w	r3, [fp, #1]
c0de0b36:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de0b3a:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de0b3e:	ea40 4101 	orr.w	r1, r0, r1, lsl #16
c0de0b42:	f240 2054 	movw	r0, #596	@ 0x254
c0de0b46:	f8bd 601a 	ldrh.w	r6, [sp, #26]
c0de0b4a:	f2c0 0000 	movt	r0, #0
c0de0b4e:	eb09 0a00 	add.w	sl, r9, r0
c0de0b52:	2e13      	cmp	r6, #19
c0de0b54:	bf28      	it	cs
c0de0b56:	2613      	movcs	r6, #19
c0de0b58:	4650      	mov	r0, sl
c0de0b5a:	4632      	mov	r2, r6
c0de0b5c:	f003 fbea 	bl	c0de4334 <__aeabi_memcpy>
                // NULL termination
                tmpString[MIN(len, (NB_MAX_CHAR_IN_LINE - 1))] = '\0';
c0de0b60:	2000      	movs	r0, #0
c0de0b62:	f80a 0006 	strb.w	r0, [sl, r6]
                button->text                                   = PIC(tmpString);
c0de0b66:	4650      	mov	r0, sl
c0de0b68:	f003 fa1e 	bl	c0de3fa8 <pic>
c0de0b6c:	0e01      	lsrs	r1, r0, #24
c0de0b6e:	f88b 0000 	strb.w	r0, [fp]
c0de0b72:	f88b 1003 	strb.w	r1, [fp, #3]
c0de0b76:	0c01      	lsrs	r1, r0, #16
c0de0b78:	0a00      	lsrs	r0, r0, #8
c0de0b7a:	f88b 1002 	strb.w	r1, [fp, #2]
c0de0b7e:	f88b 0001 	strb.w	r0, [fp, #1]
c0de0b82:	e077      	b.n	c0de0c74 <nbgl_layoutAddText+0x340>
c0de0b84:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
    container->obj.alignment   = CENTER;
    // set this new obj as child of main container
    layoutAddObject(layoutInt, (nbgl_obj_t *) container);

    return 0;
}
c0de0b88:	b008      	add	sp, #32
c0de0b8a:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
            textArea            = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de0b8e:	2004      	movs	r0, #4
c0de0b90:	f002 fb1d 	bl	c0de31ce <nbgl_objPoolGet>
c0de0b94:	f04f 0b03 	mov.w	fp, #3
c0de0b98:	4607      	mov	r7, r0
            textArea->textColor = WHITE;
c0de0b9a:	f880 b01f 	strb.w	fp, [r0, #31]
            textArea->text      = PIC(subText);
c0de0b9e:	4620      	mov	r0, r4
c0de0ba0:	f003 fa02 	bl	c0de3fa8 <pic>
c0de0ba4:	4601      	mov	r1, r0
c0de0ba6:	4638      	mov	r0, r7
c0de0ba8:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de0bac:	0e0a      	lsrs	r2, r1, #24
c0de0bae:	70c2      	strb	r2, [r0, #3]
c0de0bb0:	0c0a      	lsrs	r2, r1, #16
c0de0bb2:	7082      	strb	r2, [r0, #2]
            textArea->wrapping  = true;
c0de0bb4:	f897 2024 	ldrb.w	r2, [r7, #36]	@ 0x24
            textArea->text      = PIC(subText);
c0de0bb8:	0a08      	lsrs	r0, r1, #8
c0de0bba:	f887 0027 	strb.w	r0, [r7, #39]	@ 0x27
            textArea->wrapping  = true;
c0de0bbe:	f042 0001 	orr.w	r0, r2, #1
c0de0bc2:	f887 0024 	strb.w	r0, [r7, #36]	@ 0x24
c0de0bc6:	200a      	movs	r0, #10
            textArea->fontId    = BAGL_FONT_OPEN_SANS_REGULAR_11px_1bpp;
c0de0bc8:	f887 0022 	strb.w	r0, [r7, #34]	@ 0x22
c0de0bcc:	2072      	movs	r0, #114	@ 0x72
c0de0bce:	2600      	movs	r6, #0
            textArea->obj.area.width = AVAILABLE_WIDTH;
c0de0bd0:	7138      	strb	r0, [r7, #4]
            nbLines                  = nbgl_getTextNbLinesInWidth(
c0de0bd2:	200a      	movs	r0, #10
c0de0bd4:	2272      	movs	r2, #114	@ 0x72
c0de0bd6:	2301      	movs	r3, #1
            textArea->obj.area.width = AVAILABLE_WIDTH;
c0de0bd8:	717e      	strb	r6, [r7, #5]
            nbLines                  = nbgl_getTextNbLinesInWidth(
c0de0bda:	f002 fb11 	bl	c0de3200 <nbgl_getTextNbLinesInWidth>
            if (nbLines > (NB_MAX_LINES - 1)) {
c0de0bde:	2804      	cmp	r0, #4
c0de0be0:	d31f      	bcc.n	c0de0c22 <nbgl_layoutAddText+0x2ee>
                    textArea->fontId, textArea->text, AVAILABLE_WIDTH, nbLines, &len, true);
c0de0be2:	463c      	mov	r4, r7
c0de0be4:	f814 cf26 	ldrb.w	ip, [r4, #38]!
c0de0be8:	f04f 0e01 	mov.w	lr, #1
c0de0bec:	7862      	ldrb	r2, [r4, #1]
c0de0bee:	78a3      	ldrb	r3, [r4, #2]
c0de0bf0:	78e1      	ldrb	r1, [r4, #3]
c0de0bf2:	ea4c 2202 	orr.w	r2, ip, r2, lsl #8
c0de0bf6:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de0bfa:	f814 0c04 	ldrb.w	r0, [r4, #-4]
c0de0bfe:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de0c02:	aa07      	add	r2, sp, #28
                textArea->nbMaxLines = nbLines;
c0de0c04:	f804 bc01 	strb.w	fp, [r4, #-1]
                nbgl_getTextMaxLenInNbLines(
c0de0c08:	9200      	str	r2, [sp, #0]
c0de0c0a:	2272      	movs	r2, #114	@ 0x72
c0de0c0c:	2303      	movs	r3, #3
c0de0c0e:	f8cd e004 	str.w	lr, [sp, #4]
c0de0c12:	f002 fb04 	bl	c0de321e <nbgl_getTextMaxLenInNbLines>
                textArea->len = len;
c0de0c16:	f8bd 001c 	ldrh.w	r0, [sp, #28]
c0de0c1a:	7120      	strb	r0, [r4, #4]
c0de0c1c:	0a00      	lsrs	r0, r0, #8
c0de0c1e:	7160      	strb	r0, [r4, #5]
c0de0c20:	2003      	movs	r0, #3
c0de0c22:	f89a 1007 	ldrb.w	r1, [sl, #7]
            if (style == REGULAR_INFO) {
c0de0c26:	9a03      	ldr	r2, [sp, #12]
c0de0c28:	2a00      	cmp	r2, #0
c0de0c2a:	bf08      	it	eq
c0de0c2c:	4683      	moveq	fp, r0
c0de0c2e:	fb0b f001 	mul.w	r0, fp, r1
c0de0c32:	71b8      	strb	r0, [r7, #6]
c0de0c34:	0a00      	lsrs	r0, r0, #8
c0de0c36:	71f8      	strb	r0, [r7, #7]
c0de0c38:	2005      	movs	r0, #5
            textArea->textAlignment        = CENTER;
c0de0c3a:	f887 0020 	strb.w	r0, [r7, #32]
c0de0c3e:	2002      	movs	r0, #2
            textArea->obj.alignmentMarginY = 2;
c0de0c40:	7678      	strb	r0, [r7, #25]
            fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de0c42:	fb0b 8001 	mla	r0, fp, r1, r8
            container->children[1] = (nbgl_obj_t *) textArea;
c0de0c46:	4629      	mov	r1, r5
c0de0c48:	f811 2f22 	ldrb.w	r2, [r1, #34]!
            fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de0c4c:	f100 0802 	add.w	r8, r0, #2
            container->children[1] = (nbgl_obj_t *) textArea;
c0de0c50:	7848      	ldrb	r0, [r1, #1]
c0de0c52:	788b      	ldrb	r3, [r1, #2]
c0de0c54:	78c9      	ldrb	r1, [r1, #3]
c0de0c56:	ea42 2000 	orr.w	r0, r2, r0, lsl #8
c0de0c5a:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de0c5e:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
            textArea->obj.alignment        = NO_ALIGNMENT;
c0de0c62:	75be      	strb	r6, [r7, #22]
            textArea->obj.alignmentMarginY = 2;
c0de0c64:	76be      	strb	r6, [r7, #26]
            container->children[1] = (nbgl_obj_t *) textArea;
c0de0c66:	6047      	str	r7, [r0, #4]
c0de0c68:	e0a6      	b.n	c0de0db8 <nbgl_layoutAddText+0x484>
            if ((textWidth + BUTTON_MARGIN_Y) >= AVAILABLE_WIDTH) {
c0de0c6a:	300c      	adds	r0, #12
                button->obj.area.width       = textWidth + BUTTON_MARGIN_Y;
c0de0c6c:	7138      	strb	r0, [r7, #4]
c0de0c6e:	0a00      	lsrs	r0, r0, #8
c0de0c70:	2408      	movs	r4, #8
c0de0c72:	7178      	strb	r0, [r7, #5]
c0de0c74:	767c      	strb	r4, [r7, #25]
            container->children[1] = (nbgl_obj_t *) button;
c0de0c76:	4628      	mov	r0, r5
c0de0c78:	f810 1f22 	ldrb.w	r1, [r0, #34]!
c0de0c7c:	2600      	movs	r6, #0
c0de0c7e:	7842      	ldrb	r2, [r0, #1]
c0de0c80:	7883      	ldrb	r3, [r0, #2]
c0de0c82:	78c0      	ldrb	r0, [r0, #3]
c0de0c84:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
            if (width > 0) {
c0de0c88:	f8bd 2018 	ldrh.w	r2, [sp, #24]
            container->children[1] = (nbgl_obj_t *) button;
c0de0c8c:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de0c90:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
            if (width > 0) {
c0de0c94:	2a00      	cmp	r2, #0
c0de0c96:	76be      	strb	r6, [r7, #26]
            container->children[1] = (nbgl_obj_t *) button;
c0de0c98:	6047      	str	r7, [r0, #4]
            if (width > 0) {
c0de0c9a:	f000 808b 	beq.w	c0de0db4 <nbgl_layoutAddText+0x480>
                button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, layoutInt->layer);
c0de0c9e:	9805      	ldr	r0, [sp, #20]
c0de0ca0:	f04f 0b05 	mov.w	fp, #5
c0de0ca4:	7841      	ldrb	r1, [r0, #1]
c0de0ca6:	2005      	movs	r0, #5
c0de0ca8:	f002 fa91 	bl	c0de31ce <nbgl_objPoolGet>
c0de0cac:	4607      	mov	r7, r0
                button->foregroundColor      = BLACK;
c0de0cae:	f880 6021 	strb.w	r6, [r0, #33]	@ 0x21
c0de0cb2:	2003      	movs	r0, #3
                button->innerColor           = WHITE;
c0de0cb4:	77f8      	strb	r0, [r7, #31]
                button->borderColor          = WHITE;
c0de0cb6:	f887 0020 	strb.w	r0, [r7, #32]
                button->text                 = (const char *) PIC(subText) + len;
c0de0cba:	9804      	ldr	r0, [sp, #16]
c0de0cbc:	f04f 0a01 	mov.w	sl, #1
                button->radius               = RADIUS_3_PIXELS;
c0de0cc0:	f887 a022 	strb.w	sl, [r7, #34]	@ 0x22
                button->text                 = (const char *) PIC(subText) + len;
c0de0cc4:	f003 f970 	bl	c0de3fa8 <pic>
c0de0cc8:	f8bd 101a 	ldrh.w	r1, [sp, #26]
                button->obj.area.height      = 14;
c0de0ccc:	71fe      	strb	r6, [r7, #7]
                button->text                 = (const char *) PIC(subText) + len;
c0de0cce:	4401      	add	r1, r0
c0de0cd0:	4638      	mov	r0, r7
c0de0cd2:	f800 1f25 	strb.w	r1, [r0, #37]!
c0de0cd6:	0e0a      	lsrs	r2, r1, #24
c0de0cd8:	70c2      	strb	r2, [r0, #3]
c0de0cda:	0c0a      	lsrs	r2, r1, #16
c0de0cdc:	7082      	strb	r2, [r0, #2]
c0de0cde:	0a08      	lsrs	r0, r1, #8
c0de0ce0:	f887 0026 	strb.w	r0, [r7, #38]	@ 0x26
c0de0ce4:	2008      	movs	r0, #8
                button->fontId               = BAGL_FONT_OPEN_SANS_EXTRABOLD_11px_1bpp;
c0de0ce6:	f887 0023 	strb.w	r0, [r7, #35]	@ 0x23
c0de0cea:	200e      	movs	r0, #14
                button->obj.area.height      = 14;
c0de0cec:	71b8      	strb	r0, [r7, #6]
c0de0cee:	200f      	movs	r0, #15
                button->obj.alignmentMarginY = 8 + 7;
c0de0cf0:	7678      	strb	r0, [r7, #25]
                textWidth                    = nbgl_getTextWidth(button->fontId, button->text);
c0de0cf2:	2008      	movs	r0, #8
                button->obj.alignment        = CENTER;
c0de0cf4:	f887 b016 	strb.w	fp, [r7, #22]
                button->obj.alignmentMarginY = 8 + 7;
c0de0cf8:	76be      	strb	r6, [r7, #26]
                textWidth                    = nbgl_getTextWidth(button->fontId, button->text);
c0de0cfa:	f002 fa8b 	bl	c0de3214 <nbgl_getTextWidth>
                if ((textWidth + BUTTON_MARGIN_Y) >= AVAILABLE_WIDTH) {
c0de0cfe:	2866      	cmp	r0, #102	@ 0x66
c0de0d00:	d347      	bcc.n	c0de0d92 <nbgl_layoutAddText+0x45e>
                                               button->text,
c0de0d02:	463e      	mov	r6, r7
c0de0d04:	f816 1f25 	ldrb.w	r1, [r6, #37]!
c0de0d08:	7872      	ldrb	r2, [r6, #1]
c0de0d0a:	78b3      	ldrb	r3, [r6, #2]
c0de0d0c:	78f4      	ldrb	r4, [r6, #3]
c0de0d0e:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de0d12:	ea43 2204 	orr.w	r2, r3, r4, lsl #8
                    nbgl_getTextMaxLenAndWidth(button->fontId,
c0de0d16:	f816 0c02 	ldrb.w	r0, [r6, #-2]
                                               button->text,
c0de0d1a:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de0d1e:	aa06      	add	r2, sp, #24
                    nbgl_getTextMaxLenAndWidth(button->fontId,
c0de0d20:	9200      	str	r2, [sp, #0]
c0de0d22:	f10d 031a 	add.w	r3, sp, #26
c0de0d26:	2266      	movs	r2, #102	@ 0x66
c0de0d28:	f8cd a004 	str.w	sl, [sp, #4]
c0de0d2c:	f002 fa63 	bl	c0de31f6 <nbgl_getTextMaxLenAndWidth>
                    button->obj.area.width = width + BUTTON_MARGIN_Y;
c0de0d30:	f8bd 0018 	ldrh.w	r0, [sp, #24]
                    memcpy(tmpString2, button->text, MIN(len, (NB_MAX_CHAR_IN_LINE - 1)));
c0de0d34:	78b1      	ldrb	r1, [r6, #2]
                    button->obj.area.width = width + BUTTON_MARGIN_Y;
c0de0d36:	300c      	adds	r0, #12
c0de0d38:	f806 0c21 	strb.w	r0, [r6, #-33]
c0de0d3c:	0a00      	lsrs	r0, r0, #8
c0de0d3e:	f806 0c20 	strb.w	r0, [r6, #-32]
                    memcpy(tmpString2, button->text, MIN(len, (NB_MAX_CHAR_IN_LINE - 1)));
c0de0d42:	7830      	ldrb	r0, [r6, #0]
c0de0d44:	78f2      	ldrb	r2, [r6, #3]
c0de0d46:	7873      	ldrb	r3, [r6, #1]
c0de0d48:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de0d4c:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de0d50:	ea40 4101 	orr.w	r1, r0, r1, lsl #16
c0de0d54:	f240 2068 	movw	r0, #616	@ 0x268
c0de0d58:	f8bd b01a 	ldrh.w	fp, [sp, #26]
c0de0d5c:	f2c0 0000 	movt	r0, #0
c0de0d60:	eb09 0a00 	add.w	sl, r9, r0
c0de0d64:	f1bb 0f13 	cmp.w	fp, #19
c0de0d68:	bf28      	it	cs
c0de0d6a:	f04f 0b13 	movcs.w	fp, #19
c0de0d6e:	4650      	mov	r0, sl
c0de0d70:	465a      	mov	r2, fp
c0de0d72:	f003 fadf 	bl	c0de4334 <__aeabi_memcpy>
c0de0d76:	2000      	movs	r0, #0
                    tmpString2[MIN(len, (NB_MAX_CHAR_IN_LINE - 1))] = '\0';
c0de0d78:	f80a 000b 	strb.w	r0, [sl, fp]
                    button->text                                    = PIC(tmpString2);
c0de0d7c:	4650      	mov	r0, sl
c0de0d7e:	f003 f913 	bl	c0de3fa8 <pic>
c0de0d82:	0e01      	lsrs	r1, r0, #24
c0de0d84:	7030      	strb	r0, [r6, #0]
c0de0d86:	70f1      	strb	r1, [r6, #3]
c0de0d88:	0c01      	lsrs	r1, r0, #16
c0de0d8a:	0a00      	lsrs	r0, r0, #8
c0de0d8c:	70b1      	strb	r1, [r6, #2]
c0de0d8e:	7070      	strb	r0, [r6, #1]
c0de0d90:	e003      	b.n	c0de0d9a <nbgl_layoutAddText+0x466>
                if ((textWidth + BUTTON_MARGIN_Y) >= AVAILABLE_WIDTH) {
c0de0d92:	300c      	adds	r0, #12
                    button->obj.area.width = textWidth + BUTTON_MARGIN_Y;
c0de0d94:	7138      	strb	r0, [r7, #4]
c0de0d96:	0a00      	lsrs	r0, r0, #8
c0de0d98:	7178      	strb	r0, [r7, #5]
                container->children[2] = (nbgl_obj_t *) button;
c0de0d9a:	4628      	mov	r0, r5
c0de0d9c:	f810 1f22 	ldrb.w	r1, [r0, #34]!
c0de0da0:	7842      	ldrb	r2, [r0, #1]
c0de0da2:	7883      	ldrb	r3, [r0, #2]
c0de0da4:	78c0      	ldrb	r0, [r0, #3]
c0de0da6:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de0daa:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de0dae:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de0db2:	6087      	str	r7, [r0, #8]
            fullHeight += 44;
c0de0db4:	f108 082c 	add.w	r8, r8, #44	@ 0x2c
c0de0db8:	9b05      	ldr	r3, [sp, #20]
    container->obj.area.height = fullHeight;
c0de0dba:	f885 8006 	strb.w	r8, [r5, #6]
c0de0dbe:	2105      	movs	r1, #5
    container->obj.alignment   = CENTER;
c0de0dc0:	75a9      	strb	r1, [r5, #22]
    if (layout->nbChildren == NB_MAX_SCREEN_CHILDREN) {
c0de0dc2:	7899      	ldrb	r1, [r3, #2]
    layout->children[layout->nbChildren] = obj;
c0de0dc4:	685a      	ldr	r2, [r3, #4]
    container->obj.area.height = fullHeight;
c0de0dc6:	ea4f 2018 	mov.w	r0, r8, lsr #8
c0de0dca:	71e8      	strb	r0, [r5, #7]
c0de0dcc:	2000      	movs	r0, #0
    layout->children[layout->nbChildren] = obj;
c0de0dce:	f842 5021 	str.w	r5, [r2, r1, lsl #2]
    layout->nbChildren++;
c0de0dd2:	3101      	adds	r1, #1
    container->layout          = VERTICAL;
c0de0dd4:	77e8      	strb	r0, [r5, #31]
    layout->nbChildren++;
c0de0dd6:	7099      	strb	r1, [r3, #2]
}
c0de0dd8:	b008      	add	sp, #32
c0de0dda:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
	...

c0de0de0 <nbgl_layoutAddMenuList>:
 * @param layout the current layout
 * @param list structure giving the list of choices and the current selected one
 * @return >= 0 if OK
 */
int nbgl_layoutAddMenuList(nbgl_layout_t *layout, nbgl_layoutMenuList_t *list)
{
c0de0de0:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
    nbgl_layoutInternal_t *layoutInt = (nbgl_layoutInternal_t *) layout;
    uint8_t                i;

    LOG_DEBUG(LAYOUT_LOGGER, "nbgl_layoutAddMenuList():\n");
    if (layout == NULL) {
c0de0de4:	2800      	cmp	r0, #0
c0de0de6:	d05a      	beq.n	c0de0e9e <nbgl_layoutAddMenuList+0xbe>
c0de0de8:	4605      	mov	r5, r0
        return -1;
    }
    for (i = 0; i < list->nbChoices; i++) {
c0de0dea:	7908      	ldrb	r0, [r1, #4]
c0de0dec:	460e      	mov	r6, r1
c0de0dee:	2800      	cmp	r0, #0
c0de0df0:	f04f 0400 	mov.w	r4, #0
c0de0df4:	d058      	beq.n	c0de0ea8 <nbgl_layoutAddMenuList+0xc8>
c0de0df6:	f04f 0805 	mov.w	r8, #5
c0de0dfa:	f04f 0a03 	mov.w	sl, #3
c0de0dfe:	f04f 0b00 	mov.w	fp, #0
c0de0e02:	e004      	b.n	c0de0e0e <nbgl_layoutAddMenuList+0x2e>
c0de0e04:	7930      	ldrb	r0, [r6, #4]
c0de0e06:	f10b 0b01 	add.w	fp, fp, #1
c0de0e0a:	4583      	cmp	fp, r0
c0de0e0c:	d24b      	bcs.n	c0de0ea6 <nbgl_layoutAddMenuList+0xc6>
        nbgl_text_area_t *textArea;

        // check whether this object is visible or not
        // only the two objects above or below the selected one are visible
        if (((list->selectedChoice > 2) && (i < (list->selectedChoice - 2)))
c0de0e0e:	7970      	ldrb	r0, [r6, #5]
c0de0e10:	2100      	movs	r1, #0
c0de0e12:	2802      	cmp	r0, #2
c0de0e14:	f1a0 0202 	sub.w	r2, r0, #2
c0de0e18:	bf88      	it	hi
c0de0e1a:	2101      	movhi	r1, #1
c0de0e1c:	455a      	cmp	r2, fp
c0de0e1e:	f04f 0200 	mov.w	r2, #0
c0de0e22:	bfc8      	it	gt
c0de0e24:	2201      	movgt	r2, #1
c0de0e26:	4211      	tst	r1, r2
c0de0e28:	d1ec      	bne.n	c0de0e04 <nbgl_layoutAddMenuList+0x24>
c0de0e2a:	3002      	adds	r0, #2
c0de0e2c:	4558      	cmp	r0, fp
c0de0e2e:	d3e9      	bcc.n	c0de0e04 <nbgl_layoutAddMenuList+0x24>
            || (i > (list->selectedChoice + 2))) {
            continue;
        }

        textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de0e30:	7869      	ldrb	r1, [r5, #1]
c0de0e32:	2004      	movs	r0, #4
c0de0e34:	f002 f9cb 	bl	c0de31ce <nbgl_objPoolGet>

        // init text area for this choice
        textArea->text                 = list->callback(i);
c0de0e38:	6831      	ldr	r1, [r6, #0]
        textArea = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de0e3a:	4607      	mov	r7, r0
        textArea->text                 = list->callback(i);
c0de0e3c:	fa5f f08b 	uxtb.w	r0, fp
c0de0e40:	4788      	blx	r1
c0de0e42:	4639      	mov	r1, r7
c0de0e44:	f801 0f26 	strb.w	r0, [r1, #38]!
c0de0e48:	0e02      	lsrs	r2, r0, #24
c0de0e4a:	70ca      	strb	r2, [r1, #3]
c0de0e4c:	0c02      	lsrs	r2, r0, #16
c0de0e4e:	0a00      	lsrs	r0, r0, #8
c0de0e50:	f887 0027 	strb.w	r0, [r7, #39]	@ 0x27
        textArea->textAlignment        = CENTER;
        textArea->obj.area.width       = AVAILABLE_WIDTH;
c0de0e54:	2072      	movs	r0, #114	@ 0x72
c0de0e56:	7138      	strb	r0, [r7, #4]
        textArea->obj.area.height      = 12;
c0de0e58:	200c      	movs	r0, #12
        textArea->text                 = list->callback(i);
c0de0e5a:	708a      	strb	r2, [r1, #2]
        textArea->obj.area.height      = 12;
c0de0e5c:	71b8      	strb	r0, [r7, #6]
        textArea->style                = NO_STYLE;
        textArea->obj.alignment        = CENTER;
        textArea->obj.alignmentMarginY = ((i - list->selectedChoice) * 16);
c0de0e5e:	7970      	ldrb	r0, [r6, #5]
        textArea->textAlignment        = CENTER;
c0de0e60:	f887 8020 	strb.w	r8, [r7, #32]
        textArea->obj.alignmentMarginY = ((i - list->selectedChoice) * 16);
c0de0e64:	ebbb 0000 	subs.w	r0, fp, r0
c0de0e68:	ea4f 1100 	mov.w	r1, r0, lsl #4
c0de0e6c:	ea4f 1010 	mov.w	r0, r0, lsr #4
c0de0e70:	76b8      	strb	r0, [r7, #26]
c0de0e72:	f04f 000a 	mov.w	r0, #10
        textArea->obj.area.width       = AVAILABLE_WIDTH;
c0de0e76:	717c      	strb	r4, [r7, #5]
        textArea->obj.area.height      = 12;
c0de0e78:	71fc      	strb	r4, [r7, #7]
        textArea->style                = NO_STYLE;
c0de0e7a:	f887 4021 	strb.w	r4, [r7, #33]	@ 0x21
        textArea->obj.alignment        = CENTER;
c0de0e7e:	f887 8016 	strb.w	r8, [r7, #22]
        textArea->obj.alignmentMarginY = ((i - list->selectedChoice) * 16);
c0de0e82:	7679      	strb	r1, [r7, #25]
        textArea->textColor            = WHITE;
c0de0e84:	f887 a01f 	strb.w	sl, [r7, #31]
c0de0e88:	bf08      	it	eq
c0de0e8a:	2008      	moveq	r0, #8
    if (layout->nbChildren == NB_MAX_SCREEN_CHILDREN) {
c0de0e8c:	78a9      	ldrb	r1, [r5, #2]
    layout->children[layout->nbChildren] = obj;
c0de0e8e:	686a      	ldr	r2, [r5, #4]
c0de0e90:	f887 0022 	strb.w	r0, [r7, #34]	@ 0x22
    layout->nbChildren++;
c0de0e94:	1c48      	adds	r0, r1, #1
    layout->children[layout->nbChildren] = obj;
c0de0e96:	f842 7021 	str.w	r7, [r2, r1, lsl #2]
    layout->nbChildren++;
c0de0e9a:	70a8      	strb	r0, [r5, #2]
c0de0e9c:	e7b2      	b.n	c0de0e04 <nbgl_layoutAddMenuList+0x24>
c0de0e9e:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
        // set this new obj as child of main container
        layoutAddObject(layoutInt, (nbgl_obj_t *) textArea);
    }

    return 0;
}
c0de0ea2:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de0ea6:	2400      	movs	r4, #0
c0de0ea8:	4620      	mov	r0, r4
c0de0eaa:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de0eae <nbgl_layoutAddCenteredInfo>:
    nbgl_text_area_t      *textArea   = NULL;
    nbgl_image_t          *image      = NULL;
    uint16_t               fullHeight = 0;

    LOG_DEBUG(LAYOUT_LOGGER, "nbgl_layoutAddCenteredInfo():\n");
    if (layout == NULL) {
c0de0eae:	2800      	cmp	r0, #0
c0de0eb0:	bf04      	itt	eq
c0de0eb2:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff

    // set this new container as child of main container
    layoutAddObject(layoutInt, (nbgl_obj_t *) container);

    return 0;
}
c0de0eb6:	4770      	bxeq	lr
c0de0eb8:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de0ebc:	b086      	sub	sp, #24
c0de0ebe:	468a      	mov	sl, r1
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de0ec0:	7841      	ldrb	r1, [r0, #1]
c0de0ec2:	4606      	mov	r6, r0
c0de0ec4:	2001      	movs	r0, #1
c0de0ec6:	f002 f982 	bl	c0de31ce <nbgl_objPoolGet>
    container->children   = nbgl_containerPoolGet(3, layoutInt->layer);
c0de0eca:	7871      	ldrb	r1, [r6, #1]
    container = (nbgl_container_t *) nbgl_objPoolGet(CONTAINER, layoutInt->layer);
c0de0ecc:	4680      	mov	r8, r0
    container->children   = nbgl_containerPoolGet(3, layoutInt->layer);
c0de0ece:	2003      	movs	r0, #3
c0de0ed0:	2703      	movs	r7, #3
c0de0ed2:	f002 f981 	bl	c0de31d8 <nbgl_containerPoolGet>
c0de0ed6:	4641      	mov	r1, r8
c0de0ed8:	f801 0f22 	strb.w	r0, [r1, #34]!
c0de0edc:	0e02      	lsrs	r2, r0, #24
c0de0ede:	70ca      	strb	r2, [r1, #3]
c0de0ee0:	0c02      	lsrs	r2, r0, #16
c0de0ee2:	0a00      	lsrs	r0, r0, #8
c0de0ee4:	708a      	strb	r2, [r1, #2]
c0de0ee6:	f888 0023 	strb.w	r0, [r8, #35]	@ 0x23
    if (info->icon != NULL) {
c0de0eea:	f8da 0008 	ldr.w	r0, [sl, #8]
c0de0eee:	f04f 0b00 	mov.w	fp, #0
    container->nbChildren = 0;
c0de0ef2:	f888 b020 	strb.w	fp, [r8, #32]
    if (info->icon != NULL) {
c0de0ef6:	b3b8      	cbz	r0, c0de0f68 <nbgl_layoutAddCenteredInfo+0xba>
        image                  = (nbgl_image_t *) nbgl_objPoolGet(IMAGE, layoutInt->layer);
c0de0ef8:	7871      	ldrb	r1, [r6, #1]
c0de0efa:	2002      	movs	r0, #2
c0de0efc:	2402      	movs	r4, #2
c0de0efe:	f002 f966 	bl	c0de31ce <nbgl_objPoolGet>
c0de0f02:	4605      	mov	r5, r0
        image->buffer          = PIC(info->icon);
c0de0f04:	f8da 0008 	ldr.w	r0, [sl, #8]
        image->foregroundColor = WHITE;
c0de0f08:	77ef      	strb	r7, [r5, #31]
        image->buffer          = PIC(info->icon);
c0de0f0a:	f003 f84d 	bl	c0de3fa8 <pic>
c0de0f0e:	4629      	mov	r1, r5
c0de0f10:	f801 0f21 	strb.w	r0, [r1, #33]!
c0de0f14:	0e02      	lsrs	r2, r0, #24
c0de0f16:	70ca      	strb	r2, [r1, #3]
c0de0f18:	0c02      	lsrs	r2, r0, #16
c0de0f1a:	708a      	strb	r2, [r1, #2]
c0de0f1c:	0a01      	lsrs	r1, r0, #8
c0de0f1e:	f885 1022 	strb.w	r1, [r5, #34]	@ 0x22
        image->obj.alignTo     = NULL;
c0de0f22:	4629      	mov	r1, r5
c0de0f24:	f801 bf12 	strb.w	fp, [r1, #18]!
c0de0f28:	f885 b013 	strb.w	fp, [r5, #19]
c0de0f2c:	f881 b002 	strb.w	fp, [r1, #2]
        container->children[container->nbChildren] = (nbgl_obj_t *) image;
c0de0f30:	4642      	mov	r2, r8
        image->obj.alignTo     = NULL;
c0de0f32:	f881 b003 	strb.w	fp, [r1, #3]
        fullHeight += image->buffer->height;
c0de0f36:	7881      	ldrb	r1, [r0, #2]
c0de0f38:	78c0      	ldrb	r0, [r0, #3]
        container->children[container->nbChildren] = (nbgl_obj_t *) image;
c0de0f3a:	f812 3f22 	ldrb.w	r3, [r2, #34]!
        image->obj.area.bpp    = NBGL_BPP_1;
c0de0f3e:	f885 b009 	strb.w	fp, [r5, #9]
        image->obj.alignment   = TOP_MIDDLE;
c0de0f42:	75ac      	strb	r4, [r5, #22]
        fullHeight += image->buffer->height;
c0de0f44:	ea41 2b00 	orr.w	fp, r1, r0, lsl #8
        container->children[container->nbChildren] = (nbgl_obj_t *) image;
c0de0f48:	7851      	ldrb	r1, [r2, #1]
c0de0f4a:	7897      	ldrb	r7, [r2, #2]
c0de0f4c:	78d4      	ldrb	r4, [r2, #3]
c0de0f4e:	f812 0c02 	ldrb.w	r0, [r2, #-2]
c0de0f52:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de0f56:	ea47 2304 	orr.w	r3, r7, r4, lsl #8
c0de0f5a:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
c0de0f5e:	f841 5020 	str.w	r5, [r1, r0, lsl #2]
        container->nbChildren++;
c0de0f62:	3001      	adds	r0, #1
c0de0f64:	f802 0c02 	strb.w	r0, [r2, #-2]
    if (info->text1 != NULL) {
c0de0f68:	f8da 0000 	ldr.w	r0, [sl]
c0de0f6c:	2800      	cmp	r0, #0
c0de0f6e:	f000 80bd 	beq.w	c0de10ec <nbgl_layoutAddCenteredInfo+0x23e>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de0f72:	7871      	ldrb	r1, [r6, #1]
c0de0f74:	2004      	movs	r0, #4
c0de0f76:	f8cd b010 	str.w	fp, [sp, #16]
c0de0f7a:	f002 f928 	bl	c0de31ce <nbgl_objPoolGet>
c0de0f7e:	4607      	mov	r7, r0
        textArea->text          = PIC(info->text1);
c0de0f80:	f8da 0000 	ldr.w	r0, [sl]
c0de0f84:	2103      	movs	r1, #3
        textArea->textColor     = WHITE;
c0de0f86:	77f9      	strb	r1, [r7, #31]
        textArea->text          = PIC(info->text1);
c0de0f88:	f003 f80e 	bl	c0de3fa8 <pic>
c0de0f8c:	4601      	mov	r1, r0
c0de0f8e:	4638      	mov	r0, r7
c0de0f90:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de0f94:	0e0a      	lsrs	r2, r1, #24
c0de0f96:	70c2      	strb	r2, [r0, #3]
c0de0f98:	0c0a      	lsrs	r2, r1, #16
c0de0f9a:	7082      	strb	r2, [r0, #2]
c0de0f9c:	0a08      	lsrs	r0, r1, #8
c0de0f9e:	f887 0027 	strb.w	r0, [r7, #39]	@ 0x27
        textArea->fontId = (info->style == REGULAR_INFO) ? BAGL_FONT_OPEN_SANS_REGULAR_11px_1bpp
c0de0fa2:	f89a 200d 	ldrb.w	r2, [sl, #13]
c0de0fa6:	2005      	movs	r0, #5
        textArea->textAlignment = CENTER;
c0de0fa8:	f887 0020 	strb.w	r0, [r7, #32]
c0de0fac:	2008      	movs	r0, #8
        textArea->fontId = (info->style == REGULAR_INFO) ? BAGL_FONT_OPEN_SANS_REGULAR_11px_1bpp
c0de0fae:	2a00      	cmp	r2, #0
c0de0fb0:	f04f 0272 	mov.w	r2, #114	@ 0x72
c0de0fb4:	bf08      	it	eq
c0de0fb6:	200a      	moveq	r0, #10
        textArea->obj.area.width = AVAILABLE_WIDTH;
c0de0fb8:	713a      	strb	r2, [r7, #4]
        textArea->wrapping       = true;
c0de0fba:	f897 2024 	ldrb.w	r2, [r7, #36]	@ 0x24
c0de0fbe:	f04f 0b00 	mov.w	fp, #0
c0de0fc2:	f042 0201 	orr.w	r2, r2, #1
c0de0fc6:	f887 2024 	strb.w	r2, [r7, #36]	@ 0x24
            = nbgl_getTextNbLinesInWidth(textArea->fontId, textArea->text, AVAILABLE_WIDTH, true);
c0de0fca:	2272      	movs	r2, #114	@ 0x72
c0de0fcc:	2301      	movs	r3, #1
        textArea->fontId = (info->style == REGULAR_INFO) ? BAGL_FONT_OPEN_SANS_REGULAR_11px_1bpp
c0de0fce:	f887 0022 	strb.w	r0, [r7, #34]	@ 0x22
        textArea->obj.area.width = AVAILABLE_WIDTH;
c0de0fd2:	f887 b005 	strb.w	fp, [r7, #5]
            = nbgl_getTextNbLinesInWidth(textArea->fontId, textArea->text, AVAILABLE_WIDTH, true);
c0de0fd6:	f002 f913 	bl	c0de3200 <nbgl_getTextNbLinesInWidth>
c0de0fda:	4605      	mov	r5, r0
        if (nbLines > NB_MAX_LINES) {
c0de0fdc:	2805      	cmp	r0, #5
c0de0fde:	d321      	bcc.n	c0de1024 <nbgl_layoutAddCenteredInfo+0x176>
                textArea->fontId, textArea->text, AVAILABLE_WIDTH, nbLines, &len, true);
c0de0fe0:	463d      	mov	r5, r7
c0de0fe2:	f815 1f26 	ldrb.w	r1, [r5, #38]!
            textArea->nbMaxLines = NB_MAX_LINES;
c0de0fe6:	2004      	movs	r0, #4
                textArea->fontId, textArea->text, AVAILABLE_WIDTH, nbLines, &len, true);
c0de0fe8:	786a      	ldrb	r2, [r5, #1]
c0de0fea:	78ab      	ldrb	r3, [r5, #2]
c0de0fec:	78ec      	ldrb	r4, [r5, #3]
c0de0fee:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de0ff2:	ea43 2204 	orr.w	r2, r3, r4, lsl #8
            textArea->nbMaxLines = NB_MAX_LINES;
c0de0ff6:	f805 0c01 	strb.w	r0, [r5, #-1]
                textArea->fontId, textArea->text, AVAILABLE_WIDTH, nbLines, &len, true);
c0de0ffa:	f815 0c04 	ldrb.w	r0, [r5, #-4]
c0de0ffe:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de1002:	f10d 0216 	add.w	r2, sp, #22
            nbgl_getTextMaxLenInNbLines(
c0de1006:	9200      	str	r2, [sp, #0]
c0de1008:	2272      	movs	r2, #114	@ 0x72
c0de100a:	2304      	movs	r3, #4
c0de100c:	2401      	movs	r4, #1
c0de100e:	f04f 0b00 	mov.w	fp, #0
c0de1012:	9401      	str	r4, [sp, #4]
c0de1014:	f002 f903 	bl	c0de321e <nbgl_getTextMaxLenInNbLines>
            textArea->len = len;
c0de1018:	f8bd 0016 	ldrh.w	r0, [sp, #22]
c0de101c:	7128      	strb	r0, [r5, #4]
c0de101e:	0a00      	lsrs	r0, r0, #8
c0de1020:	7168      	strb	r0, [r5, #5]
c0de1022:	2504      	movs	r5, #4
        const nbgl_font_t *font   = nbgl_getFont(textArea->fontId);
c0de1024:	f897 0022 	ldrb.w	r0, [r7, #34]	@ 0x22
c0de1028:	f002 f8db 	bl	c0de31e2 <nbgl_getFont>
        textArea->obj.area.height = nbLines * font->line_height;
c0de102c:	79c0      	ldrb	r0, [r0, #7]
        textArea->style           = NO_STYLE;
c0de102e:	f887 b021 	strb.w	fp, [r7, #33]	@ 0x21
        textArea->obj.area.height = nbLines * font->line_height;
c0de1032:	4368      	muls	r0, r5
c0de1034:	71b8      	strb	r0, [r7, #6]
        if (info->icon != NULL) {
c0de1036:	f8da 2008 	ldr.w	r2, [sl, #8]
        textArea->obj.area.height = nbLines * font->line_height;
c0de103a:	0a01      	lsrs	r1, r0, #8
c0de103c:	71f9      	strb	r1, [r7, #7]
        if (info->icon != NULL) {
c0de103e:	b35a      	cbz	r2, c0de1098 <nbgl_layoutAddCenteredInfo+0x1ea>
            textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de1040:	4641      	mov	r1, r8
c0de1042:	f811 2f22 	ldrb.w	r2, [r1, #34]!
            textArea->obj.alignmentMarginY = (nbLines < 3) ? 4 : 0;
c0de1046:	2d03      	cmp	r5, #3
            textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de1048:	f811 cc02 	ldrb.w	ip, [r1, #-2]
c0de104c:	784c      	ldrb	r4, [r1, #1]
c0de104e:	788b      	ldrb	r3, [r1, #2]
c0de1050:	78c9      	ldrb	r1, [r1, #3]
c0de1052:	ea42 2204 	orr.w	r2, r2, r4, lsl #8
c0de1056:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de105a:	ea42 4101 	orr.w	r1, r2, r1, lsl #16
c0de105e:	eb01 018c 	add.w	r1, r1, ip, lsl #2
c0de1062:	f851 1c04 	ldr.w	r1, [r1, #-4]
c0de1066:	463a      	mov	r2, r7
c0de1068:	f802 1f12 	strb.w	r1, [r2, #18]!
c0de106c:	f04f 0308 	mov.w	r3, #8
            textArea->obj.alignment = BOTTOM_MIDDLE;  // under icon
c0de1070:	7113      	strb	r3, [r2, #4]
            textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de1072:	ea4f 6311 	mov.w	r3, r1, lsr #24
c0de1076:	70d3      	strb	r3, [r2, #3]
c0de1078:	ea4f 4311 	mov.w	r3, r1, lsr #16
c0de107c:	7093      	strb	r3, [r2, #2]
c0de107e:	ea4f 2111 	mov.w	r1, r1, lsr #8
            textArea->obj.alignmentMarginY = (nbLines < 3) ? 4 : 0;
c0de1082:	f04f 0300 	mov.w	r3, #0
            textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de1086:	7051      	strb	r1, [r2, #1]
            textArea->obj.alignmentMarginY = (nbLines < 3) ? 4 : 0;
c0de1088:	bf38      	it	cc
c0de108a:	2301      	movcc	r3, #1
c0de108c:	2100      	movs	r1, #0
c0de108e:	009b      	lsls	r3, r3, #2
c0de1090:	9d04      	ldr	r5, [sp, #16]
c0de1092:	7211      	strb	r1, [r2, #8]
c0de1094:	71d3      	strb	r3, [r2, #7]
c0de1096:	e00f      	b.n	c0de10b8 <nbgl_layoutAddCenteredInfo+0x20a>
        else if (info->text2 == NULL) {
c0de1098:	f8da 1004 	ldr.w	r1, [sl, #4]
c0de109c:	9d04      	ldr	r5, [sp, #16]
c0de109e:	2900      	cmp	r1, #0
c0de10a0:	f04f 0100 	mov.w	r1, #0
            textArea->obj.alignTo   = NULL;
c0de10a4:	463a      	mov	r2, r7
c0de10a6:	f802 1f12 	strb.w	r1, [r2, #18]!
c0de10aa:	bf14      	ite	ne
c0de10ac:	2302      	movne	r3, #2
c0de10ae:	2305      	moveq	r3, #5
c0de10b0:	7113      	strb	r3, [r2, #4]
c0de10b2:	70d1      	strb	r1, [r2, #3]
c0de10b4:	7091      	strb	r1, [r2, #2]
c0de10b6:	7051      	strb	r1, [r2, #1]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de10b8:	7e79      	ldrb	r1, [r7, #25]
c0de10ba:	7eba      	ldrb	r2, [r7, #26]
c0de10bc:	4428      	add	r0, r5
c0de10be:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de10c2:	4642      	mov	r2, r8
c0de10c4:	f812 3f22 	ldrb.w	r3, [r2, #34]!
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de10c8:	eb00 0b01 	add.w	fp, r0, r1
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de10cc:	7851      	ldrb	r1, [r2, #1]
c0de10ce:	7895      	ldrb	r5, [r2, #2]
c0de10d0:	78d4      	ldrb	r4, [r2, #3]
c0de10d2:	f812 0c02 	ldrb.w	r0, [r2, #-2]
c0de10d6:	ea43 2101 	orr.w	r1, r3, r1, lsl #8
c0de10da:	ea45 2304 	orr.w	r3, r5, r4, lsl #8
c0de10de:	ea41 4103 	orr.w	r1, r1, r3, lsl #16
c0de10e2:	f841 7020 	str.w	r7, [r1, r0, lsl #2]
        container->nbChildren++;
c0de10e6:	3001      	adds	r0, #1
c0de10e8:	f802 0c02 	strb.w	r0, [r2, #-2]
    if (info->text2 != NULL) {
c0de10ec:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de10f0:	2800      	cmp	r0, #0
c0de10f2:	f000 808b 	beq.w	c0de120c <nbgl_layoutAddCenteredInfo+0x35e>
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de10f6:	7871      	ldrb	r1, [r6, #1]
c0de10f8:	2004      	movs	r0, #4
c0de10fa:	9604      	str	r6, [sp, #16]
c0de10fc:	f002 f867 	bl	c0de31ce <nbgl_objPoolGet>
c0de1100:	4605      	mov	r5, r0
        textArea->text          = PIC(info->text2);
c0de1102:	f8da 0004 	ldr.w	r0, [sl, #4]
c0de1106:	2403      	movs	r4, #3
c0de1108:	f8cd a00c 	str.w	sl, [sp, #12]
        textArea->textColor     = WHITE;
c0de110c:	77ec      	strb	r4, [r5, #31]
        textArea->text          = PIC(info->text2);
c0de110e:	f002 ff4b 	bl	c0de3fa8 <pic>
c0de1112:	4601      	mov	r1, r0
c0de1114:	4628      	mov	r0, r5
c0de1116:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de111a:	0e0a      	lsrs	r2, r1, #24
c0de111c:	70c2      	strb	r2, [r0, #3]
c0de111e:	0c0a      	lsrs	r2, r1, #16
c0de1120:	7082      	strb	r2, [r0, #2]
c0de1122:	0a08      	lsrs	r0, r1, #8
c0de1124:	f885 0027 	strb.w	r0, [r5, #39]	@ 0x27
c0de1128:	2005      	movs	r0, #5
        textArea->textAlignment = CENTER;
c0de112a:	f885 0020 	strb.w	r0, [r5, #32]
c0de112e:	200a      	movs	r0, #10
        textArea->fontId        = BAGL_FONT_OPEN_SANS_REGULAR_11px_1bpp;
c0de1130:	f885 0022 	strb.w	r0, [r5, #34]	@ 0x22
c0de1134:	2072      	movs	r0, #114	@ 0x72
        textArea->obj.area.width = AVAILABLE_WIDTH;
c0de1136:	7128      	strb	r0, [r5, #4]
        textArea->wrapping       = true;
c0de1138:	f895 0024 	ldrb.w	r0, [r5, #36]	@ 0x24
c0de113c:	2700      	movs	r7, #0
c0de113e:	f040 0001 	orr.w	r0, r0, #1
c0de1142:	f885 0024 	strb.w	r0, [r5, #36]	@ 0x24
            = nbgl_getTextNbLinesInWidth(textArea->fontId, textArea->text, AVAILABLE_WIDTH, true);
c0de1146:	200a      	movs	r0, #10
c0de1148:	2272      	movs	r2, #114	@ 0x72
c0de114a:	2301      	movs	r3, #1
        textArea->obj.area.width = AVAILABLE_WIDTH;
c0de114c:	716f      	strb	r7, [r5, #5]
            = nbgl_getTextNbLinesInWidth(textArea->fontId, textArea->text, AVAILABLE_WIDTH, true);
c0de114e:	f002 f857 	bl	c0de3200 <nbgl_getTextNbLinesInWidth>
c0de1152:	4682      	mov	sl, r0
        if (nbLines > (NB_MAX_LINES - 1)) {
c0de1154:	2804      	cmp	r0, #4
c0de1156:	d320      	bcc.n	c0de119a <nbgl_layoutAddCenteredInfo+0x2ec>
                textArea->fontId, textArea->text, AVAILABLE_WIDTH, nbLines, &len, true);
c0de1158:	462e      	mov	r6, r5
c0de115a:	f816 1f26 	ldrb.w	r1, [r6, #38]!
c0de115e:	f04f 0c01 	mov.w	ip, #1
            textArea->nbMaxLines = nbLines;
c0de1162:	f806 4c01 	strb.w	r4, [r6, #-1]
                textArea->fontId, textArea->text, AVAILABLE_WIDTH, nbLines, &len, true);
c0de1166:	7872      	ldrb	r2, [r6, #1]
c0de1168:	78b3      	ldrb	r3, [r6, #2]
c0de116a:	78f4      	ldrb	r4, [r6, #3]
c0de116c:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de1170:	ea43 2204 	orr.w	r2, r3, r4, lsl #8
c0de1174:	f816 0c04 	ldrb.w	r0, [r6, #-4]
c0de1178:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de117c:	aa05      	add	r2, sp, #20
            nbgl_getTextMaxLenInNbLines(
c0de117e:	9200      	str	r2, [sp, #0]
c0de1180:	2272      	movs	r2, #114	@ 0x72
c0de1182:	2303      	movs	r3, #3
c0de1184:	f8cd c004 	str.w	ip, [sp, #4]
c0de1188:	f002 f849 	bl	c0de321e <nbgl_getTextMaxLenInNbLines>
            textArea->len = len;
c0de118c:	f8bd 0014 	ldrh.w	r0, [sp, #20]
c0de1190:	f04f 0a03 	mov.w	sl, #3
c0de1194:	7130      	strb	r0, [r6, #4]
c0de1196:	0a00      	lsrs	r0, r0, #8
c0de1198:	7170      	strb	r0, [r6, #5]
        const nbgl_font_t *font   = nbgl_getFont(textArea->fontId);
c0de119a:	f895 0022 	ldrb.w	r0, [r5, #34]	@ 0x22
c0de119e:	f002 f820 	bl	c0de31e2 <nbgl_getFont>
        textArea->obj.area.height = nbLines * font->line_height;
c0de11a2:	f890 c007 	ldrb.w	ip, [r0, #7]
c0de11a6:	2208      	movs	r2, #8
c0de11a8:	fb0a f10c 	mul.w	r1, sl, ip
c0de11ac:	71a9      	strb	r1, [r5, #6]
c0de11ae:	0a09      	lsrs	r1, r1, #8
c0de11b0:	71e9      	strb	r1, [r5, #7]
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de11b2:	4641      	mov	r1, r8
c0de11b4:	f811 3f22 	ldrb.w	r3, [r1, #34]!
        textArea->obj.alignment = BOTTOM_MIDDLE;
c0de11b8:	75aa      	strb	r2, [r5, #22]
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de11ba:	784c      	ldrb	r4, [r1, #1]
c0de11bc:	7888      	ldrb	r0, [r1, #2]
c0de11be:	78ce      	ldrb	r6, [r1, #3]
c0de11c0:	f811 2c02 	ldrb.w	r2, [r1, #-2]
c0de11c4:	ea43 2304 	orr.w	r3, r3, r4, lsl #8
c0de11c8:	ea40 2006 	orr.w	r0, r0, r6, lsl #8
c0de11cc:	ea43 4000 	orr.w	r0, r3, r0, lsl #16
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de11d0:	eb00 0382 	add.w	r3, r0, r2, lsl #2
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de11d4:	f853 3c04 	ldr.w	r3, [r3, #-4]
        textArea->style         = NO_STYLE;
c0de11d8:	f885 7021 	strb.w	r7, [r5, #33]	@ 0x21
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de11dc:	462f      	mov	r7, r5
c0de11de:	f807 3f12 	strb.w	r3, [r7, #18]!
c0de11e2:	0e1e      	lsrs	r6, r3, #24
c0de11e4:	70fe      	strb	r6, [r7, #3]
c0de11e6:	0c1e      	lsrs	r6, r3, #16
c0de11e8:	70be      	strb	r6, [r7, #2]
c0de11ea:	0a1b      	lsrs	r3, r3, #8
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de11ec:	fb0a b70c 	mla	r7, sl, ip, fp
        textArea->obj.alignTo   = (nbgl_obj_t *) container->children[container->nbChildren - 1];
c0de11f0:	74eb      	strb	r3, [r5, #19]
c0de11f2:	2302      	movs	r3, #2
c0de11f4:	e9dd a603 	ldrd	sl, r6, [sp, #12]
c0de11f8:	2400      	movs	r4, #0
        textArea->obj.alignmentMarginY = 2;
c0de11fa:	766b      	strb	r3, [r5, #25]
        fullHeight += textArea->obj.area.height + textArea->obj.alignmentMarginY;
c0de11fc:	f107 0b02 	add.w	fp, r7, #2
        container->children[container->nbChildren] = (nbgl_obj_t *) textArea;
c0de1200:	f840 5022 	str.w	r5, [r0, r2, lsl #2]
        container->nbChildren++;
c0de1204:	1c50      	adds	r0, r2, #1
        textArea->obj.alignmentMarginY = 2;
c0de1206:	76ac      	strb	r4, [r5, #26]
        container->nbChildren++;
c0de1208:	f801 0c02 	strb.w	r0, [r1, #-2]
    container->obj.area.height      = fullHeight;
c0de120c:	ea4f 201b 	mov.w	r0, fp, lsr #8
c0de1210:	f888 0007 	strb.w	r0, [r8, #7]
c0de1214:	2000      	movs	r0, #0
c0de1216:	f888 b006 	strb.w	fp, [r8, #6]
    container->obj.alignmentMarginY = 0;
c0de121a:	f888 0019 	strb.w	r0, [r8, #25]
    if (info->onTop) {
c0de121e:	f89a 100c 	ldrb.w	r1, [sl, #12]
c0de1222:	2202      	movs	r2, #2
c0de1224:	2900      	cmp	r1, #0
c0de1226:	f04f 0172 	mov.w	r1, #114	@ 0x72
    container->layout               = VERTICAL;
c0de122a:	f888 001f 	strb.w	r0, [r8, #31]
    container->obj.alignmentMarginY = 0;
c0de122e:	f888 001a 	strb.w	r0, [r8, #26]
c0de1232:	bf08      	it	eq
c0de1234:	2205      	moveq	r2, #5
    container->obj.area.width = AVAILABLE_WIDTH;
c0de1236:	f888 1004 	strb.w	r1, [r8, #4]
c0de123a:	f888 2016 	strb.w	r2, [r8, #22]
    if (layout->nbChildren == NB_MAX_SCREEN_CHILDREN) {
c0de123e:	78b1      	ldrb	r1, [r6, #2]
    layout->children[layout->nbChildren] = obj;
c0de1240:	6872      	ldr	r2, [r6, #4]
    container->obj.area.width = AVAILABLE_WIDTH;
c0de1242:	f888 0005 	strb.w	r0, [r8, #5]
    layout->children[layout->nbChildren] = obj;
c0de1246:	f842 8021 	str.w	r8, [r2, r1, lsl #2]
    layout->nbChildren++;
c0de124a:	3101      	adds	r1, #1
c0de124c:	70b1      	strb	r1, [r6, #2]
c0de124e:	b006      	add	sp, #24
c0de1250:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de1254 <nbgl_layoutAddSwitch>:
 * @param layout the current layout
 * @param switchLayout structure giving the description of switch
 * @return >= 0 if OK
 */
int nbgl_layoutAddSwitch(nbgl_layout_t *layout, const nbgl_layoutSwitch_t *switchLayout)
{
c0de1254:	e92d 45f0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, lr}
c0de1258:	b081      	sub	sp, #4
    nbgl_layoutInternal_t *layoutInt = (nbgl_layoutInternal_t *) layout;
    nbgl_button_t         *button;
    nbgl_text_area_t      *textArea;

    LOG_DEBUG(LAYOUT_LOGGER, "nbgl_layoutAddSwitch():\n");
    if (layout == NULL) {
c0de125a:	2800      	cmp	r0, #0
c0de125c:	f000 8086 	beq.w	c0de136c <nbgl_layoutAddSwitch+0x118>
c0de1260:	460d      	mov	r5, r1
        return -1;
    }
    // add switch name as title
    textArea                 = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de1262:	7841      	ldrb	r1, [r0, #1]
c0de1264:	4604      	mov	r4, r0
c0de1266:	2004      	movs	r0, #4
c0de1268:	f001 ffb1 	bl	c0de31ce <nbgl_objPoolGet>
c0de126c:	4606      	mov	r6, r0
    textArea->textColor      = WHITE;
    textArea->text           = PIC(switchLayout->text);
c0de126e:	6828      	ldr	r0, [r5, #0]
c0de1270:	f04f 0803 	mov.w	r8, #3
    textArea->textColor      = WHITE;
c0de1274:	f886 801f 	strb.w	r8, [r6, #31]
    textArea->text           = PIC(switchLayout->text);
c0de1278:	f002 fe96 	bl	c0de3fa8 <pic>
c0de127c:	4601      	mov	r1, r0
c0de127e:	4630      	mov	r0, r6
c0de1280:	f800 1f26 	strb.w	r1, [r0, #38]!
c0de1284:	0e0a      	lsrs	r2, r1, #24
c0de1286:	70c2      	strb	r2, [r0, #3]
c0de1288:	0c0a      	lsrs	r2, r1, #16
c0de128a:	7082      	strb	r2, [r0, #2]
c0de128c:	0a08      	lsrs	r0, r1, #8
c0de128e:	f886 0027 	strb.w	r0, [r6, #39]	@ 0x27
c0de1292:	2005      	movs	r0, #5
    textArea->textAlignment  = CENTER;
c0de1294:	f886 0020 	strb.w	r0, [r6, #32]
c0de1298:	2008      	movs	r0, #8
    textArea->fontId         = BAGL_FONT_OPEN_SANS_EXTRABOLD_11px_1bpp;
c0de129a:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
c0de129e:	2072      	movs	r0, #114	@ 0x72
    textArea->obj.area.width = AVAILABLE_WIDTH;
c0de12a0:	7130      	strb	r0, [r6, #4]
    textArea->wrapping       = true;
c0de12a2:	f896 0024 	ldrb.w	r0, [r6, #36]	@ 0x24
c0de12a6:	2700      	movs	r7, #0
c0de12a8:	f040 0001 	orr.w	r0, r0, #1
c0de12ac:	f886 0024 	strb.w	r0, [r6, #36]	@ 0x24
    uint16_t nbLines
        = nbgl_getTextNbLinesInWidth(textArea->fontId, textArea->text, AVAILABLE_WIDTH, true);
c0de12b0:	2008      	movs	r0, #8
c0de12b2:	2272      	movs	r2, #114	@ 0x72
c0de12b4:	2301      	movs	r3, #1
    textArea->obj.area.width = AVAILABLE_WIDTH;
c0de12b6:	7177      	strb	r7, [r6, #5]
        = nbgl_getTextNbLinesInWidth(textArea->fontId, textArea->text, AVAILABLE_WIDTH, true);
c0de12b8:	f001 ffa2 	bl	c0de3200 <nbgl_getTextNbLinesInWidth>
    // if more than 1 line on screen
    if (nbLines > 1) {
c0de12bc:	2801      	cmp	r0, #1
c0de12be:	d855      	bhi.n	c0de136c <nbgl_layoutAddSwitch+0x118>
        // TODO: warning for screenshots
        return -1;
    }
    textArea->obj.area.height      = nbgl_getFontLineHeight(textArea->fontId);
c0de12c0:	f896 0022 	ldrb.w	r0, [r6, #34]	@ 0x22
c0de12c4:	f001 ff92 	bl	c0de31ec <nbgl_getFontLineHeight>
c0de12c8:	71b0      	strb	r0, [r6, #6]
c0de12ca:	2002      	movs	r0, #2
    textArea->obj.alignment        = TOP_MIDDLE;
    textArea->obj.alignmentMarginY = 3;
c0de12cc:	f886 8019 	strb.w	r8, [r6, #25]
    textArea->obj.alignment        = TOP_MIDDLE;
c0de12d0:	75b0      	strb	r0, [r6, #22]
    if (layout->nbChildren == NB_MAX_SCREEN_CHILDREN) {
c0de12d2:	78a0      	ldrb	r0, [r4, #2]
    layout->children[layout->nbChildren] = obj;
c0de12d4:	6861      	ldr	r1, [r4, #4]
    textArea->obj.area.height      = nbgl_getFontLineHeight(textArea->fontId);
c0de12d6:	71f7      	strb	r7, [r6, #7]
    layout->children[layout->nbChildren] = obj;
c0de12d8:	f841 6020 	str.w	r6, [r1, r0, lsl #2]
    layoutAddObject(layoutInt, (nbgl_obj_t *) textArea);

    if (switchLayout->subText != NULL) {
c0de12dc:	6869      	ldr	r1, [r5, #4]
    layout->nbChildren++;
c0de12de:	3001      	adds	r0, #1
    if (switchLayout->subText != NULL) {
c0de12e0:	2900      	cmp	r1, #0
    textArea->obj.alignmentMarginY = 3;
c0de12e2:	76b7      	strb	r7, [r6, #26]
    layout->nbChildren++;
c0de12e4:	70a0      	strb	r0, [r4, #2]
    if (switchLayout->subText != NULL) {
c0de12e6:	d04f      	beq.n	c0de1388 <nbgl_layoutAddSwitch+0x134>
        // add switch description
        textArea                = (nbgl_text_area_t *) nbgl_objPoolGet(TEXT_AREA, layoutInt->layer);
c0de12e8:	7861      	ldrb	r1, [r4, #1]
c0de12ea:	2004      	movs	r0, #4
c0de12ec:	f001 ff6f 	bl	c0de31ce <nbgl_objPoolGet>
c0de12f0:	4606      	mov	r6, r0
        textArea->textColor     = WHITE;
        textArea->text          = PIC(switchLayout->subText);
c0de12f2:	6868      	ldr	r0, [r5, #4]
c0de12f4:	2103      	movs	r1, #3
        textArea->textColor     = WHITE;
c0de12f6:	77f1      	strb	r1, [r6, #31]
        textArea->text          = PIC(switchLayout->subText);
c0de12f8:	f002 fe56 	bl	c0de3fa8 <pic>
c0de12fc:	4637      	mov	r7, r6
c0de12fe:	f807 0f26 	strb.w	r0, [r7, #38]!
c0de1302:	0e01      	lsrs	r1, r0, #24
c0de1304:	70f9      	strb	r1, [r7, #3]
c0de1306:	0c01      	lsrs	r1, r0, #16
c0de1308:	0a00      	lsrs	r0, r0, #8
c0de130a:	f886 0027 	strb.w	r0, [r6, #39]	@ 0x27
c0de130e:	200a      	movs	r0, #10
        textArea->textAlignment = CENTER;
        textArea->fontId        = BAGL_FONT_OPEN_SANS_REGULAR_11px_1bpp;
c0de1310:	f886 0022 	strb.w	r0, [r6, #34]	@ 0x22
c0de1314:	2072      	movs	r0, #114	@ 0x72
c0de1316:	f04f 0a05 	mov.w	sl, #5
c0de131a:	f04f 0800 	mov.w	r8, #0
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de131e:	7130      	strb	r0, [r6, #4]
        textArea->obj.area.height = 2 * nbgl_getFontLineHeight(textArea->fontId);
c0de1320:	200a      	movs	r0, #10
        textArea->text          = PIC(switchLayout->subText);
c0de1322:	70b9      	strb	r1, [r7, #2]
        textArea->textAlignment = CENTER;
c0de1324:	f886 a020 	strb.w	sl, [r6, #32]
        textArea->obj.area.width  = AVAILABLE_WIDTH;
c0de1328:	f886 8005 	strb.w	r8, [r6, #5]
        textArea->obj.area.height = 2 * nbgl_getFontLineHeight(textArea->fontId);
c0de132c:	f001 ff5e 	bl	c0de31ec <nbgl_getFontLineHeight>
c0de1330:	0041      	lsls	r1, r0, #1
c0de1332:	71b1      	strb	r1, [r6, #6]
        textArea->wrapping        = true;
c0de1334:	f896 1024 	ldrb.w	r1, [r6, #36]	@ 0x24
        nbLines
            = nbgl_getTextNbLinesInWidth(textArea->fontId, textArea->text, AVAILABLE_WIDTH, true);
c0de1338:	f896 2027 	ldrb.w	r2, [r6, #39]	@ 0x27
        textArea->wrapping        = true;
c0de133c:	f041 0101 	orr.w	r1, r1, #1
c0de1340:	f886 1024 	strb.w	r1, [r6, #36]	@ 0x24
            = nbgl_getTextNbLinesInWidth(textArea->fontId, textArea->text, AVAILABLE_WIDTH, true);
c0de1344:	7839      	ldrb	r1, [r7, #0]
c0de1346:	78bb      	ldrb	r3, [r7, #2]
c0de1348:	78ff      	ldrb	r7, [r7, #3]
        textArea->obj.area.height = 2 * nbgl_getFontLineHeight(textArea->fontId);
c0de134a:	09c0      	lsrs	r0, r0, #7
c0de134c:	71f0      	strb	r0, [r6, #7]
            = nbgl_getTextNbLinesInWidth(textArea->fontId, textArea->text, AVAILABLE_WIDTH, true);
c0de134e:	f896 0022 	ldrb.w	r0, [r6, #34]	@ 0x22
c0de1352:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de1356:	ea43 2207 	orr.w	r2, r3, r7, lsl #8
c0de135a:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de135e:	2272      	movs	r2, #114	@ 0x72
c0de1360:	2301      	movs	r3, #1
c0de1362:	2701      	movs	r7, #1
c0de1364:	f001 ff4c 	bl	c0de3200 <nbgl_getTextNbLinesInWidth>
        // if more than 2 lines on screen
        if (nbLines > 2) {
c0de1368:	2802      	cmp	r0, #2
c0de136a:	d902      	bls.n	c0de1372 <nbgl_layoutAddSwitch+0x11e>
c0de136c:	f04f 36ff 	mov.w	r6, #4294967295	@ 0xffffffff
c0de1370:	e068      	b.n	c0de1444 <nbgl_layoutAddSwitch+0x1f0>
            // TODO: warning for screenshots
            return -1;
        }
        textArea->obj.alignment        = CENTER;
        textArea->obj.alignmentMarginY = 1;  // not exactly centered
c0de1372:	7677      	strb	r7, [r6, #25]
    if (layout->nbChildren == NB_MAX_SCREEN_CHILDREN) {
c0de1374:	78a0      	ldrb	r0, [r4, #2]
    layout->children[layout->nbChildren] = obj;
c0de1376:	6861      	ldr	r1, [r4, #4]
        textArea->obj.alignment        = CENTER;
c0de1378:	f886 a016 	strb.w	sl, [r6, #22]
    layout->children[layout->nbChildren] = obj;
c0de137c:	f841 6020 	str.w	r6, [r1, r0, lsl #2]
    layout->nbChildren++;
c0de1380:	3001      	adds	r0, #1
        textArea->obj.alignmentMarginY = 1;  // not exactly centered
c0de1382:	f886 801a 	strb.w	r8, [r6, #26]
    layout->nbChildren++;
c0de1386:	70a0      	strb	r0, [r4, #2]
        layoutAddObject(layoutInt, (nbgl_obj_t *) textArea);
    }

    button = (nbgl_button_t *) nbgl_objPoolGet(BUTTON, ((nbgl_layoutInternal_t *) layout)->layer);
c0de1388:	7861      	ldrb	r1, [r4, #1]
c0de138a:	2005      	movs	r0, #5
c0de138c:	f001 ff1f 	bl	c0de31ce <nbgl_objPoolGet>
c0de1390:	2600      	movs	r6, #0
c0de1392:	f04f 0803 	mov.w	r8, #3
c0de1396:	4607      	mov	r7, r0
    button->foregroundColor = BLACK;
c0de1398:	f880 6021 	strb.w	r6, [r0, #33]	@ 0x21
    button->innerColor      = WHITE;
c0de139c:	f880 801f 	strb.w	r8, [r0, #31]
    button->borderColor     = WHITE;
c0de13a0:	f880 8020 	strb.w	r8, [r0, #32]
c0de13a4:	2001      	movs	r0, #1
    button->radius          = RADIUS_3_PIXELS;
c0de13a6:	f887 0022 	strb.w	r0, [r7, #34]	@ 0x22
    button->text            = (switchLayout->initState == ON_STATE) ? "Enabled" : "Disabled";
c0de13aa:	7a28      	ldrb	r0, [r5, #8]
c0de13ac:	f243 2238 	movw	r2, #12856	@ 0x3238
c0de13b0:	f2c0 0200 	movt	r2, #0
c0de13b4:	f243 21fd 	movw	r1, #13053	@ 0x32fd
c0de13b8:	f2c0 0100 	movt	r1, #0
c0de13bc:	447a      	add	r2, pc
c0de13be:	4479      	add	r1, pc
c0de13c0:	2801      	cmp	r0, #1
c0de13c2:	bf08      	it	eq
c0de13c4:	4611      	moveq	r1, r2
c0de13c6:	463a      	mov	r2, r7
c0de13c8:	f802 1f25 	strb.w	r1, [r2, #37]!
c0de13cc:	0e0b      	lsrs	r3, r1, #24
c0de13ce:	70d3      	strb	r3, [r2, #3]
c0de13d0:	0c0b      	lsrs	r3, r1, #16
c0de13d2:	7093      	strb	r3, [r2, #2]
c0de13d4:	0a0a      	lsrs	r2, r1, #8
c0de13d6:	f04f 0a08 	mov.w	sl, #8
c0de13da:	f887 2026 	strb.w	r2, [r7, #38]	@ 0x26
    button->fontId          = BAGL_FONT_OPEN_SANS_EXTRABOLD_11px_1bpp;
c0de13de:	f887 a023 	strb.w	sl, [r7, #35]	@ 0x23
    button->icon = (switchLayout->initState == ON_STATE) ? &C_Switch_On_8px : &C_Switch_Off_8px;
c0de13e2:	f243 029c 	movw	r2, #12444	@ 0x309c
c0de13e6:	f2c0 0200 	movt	r2, #0
c0de13ea:	f243 057c 	movw	r5, #12412	@ 0x307c
c0de13ee:	447a      	add	r2, pc
c0de13f0:	f2c0 0500 	movt	r5, #0
c0de13f4:	2801      	cmp	r0, #1
c0de13f6:	4638      	mov	r0, r7
c0de13f8:	447d      	add	r5, pc
c0de13fa:	bf18      	it	ne
c0de13fc:	462a      	movne	r2, r5
c0de13fe:	f800 2f2e 	strb.w	r2, [r0, #46]!
c0de1402:	0e13      	lsrs	r3, r2, #24
c0de1404:	70c3      	strb	r3, [r0, #3]
c0de1406:	0c13      	lsrs	r3, r2, #16
c0de1408:	7083      	strb	r3, [r0, #2]
c0de140a:	0a10      	lsrs	r0, r2, #8
c0de140c:	f887 002f 	strb.w	r0, [r7, #47]	@ 0x2f
    // 2 pixels between icon & text, and 4 pixels on each side
    button->obj.area.width
        = nbgl_getTextWidth(button->fontId, button->text) + 2 + C_Switch_Off_8px.width + 8;
c0de1410:	2008      	movs	r0, #8
c0de1412:	f001 feff 	bl	c0de3214 <nbgl_getTextWidth>
c0de1416:	7829      	ldrb	r1, [r5, #0]
c0de1418:	786a      	ldrb	r2, [r5, #1]
    button->obj.area.height      = 12;
    button->obj.alignment        = BOTTOM_MIDDLE;
    button->obj.alignmentMarginY = 3;
c0de141a:	f887 8019 	strb.w	r8, [r7, #25]
        = nbgl_getTextWidth(button->fontId, button->text) + 2 + C_Switch_Off_8px.width + 8;
c0de141e:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de1422:	4408      	add	r0, r1
c0de1424:	300a      	adds	r0, #10
c0de1426:	7138      	strb	r0, [r7, #4]
c0de1428:	0a00      	lsrs	r0, r0, #8
c0de142a:	7178      	strb	r0, [r7, #5]
c0de142c:	200c      	movs	r0, #12
    button->obj.area.height      = 12;
c0de142e:	71b8      	strb	r0, [r7, #6]
    if (layout->nbChildren == NB_MAX_SCREEN_CHILDREN) {
c0de1430:	78a0      	ldrb	r0, [r4, #2]
    layout->children[layout->nbChildren] = obj;
c0de1432:	6861      	ldr	r1, [r4, #4]
    button->obj.area.height      = 12;
c0de1434:	71fe      	strb	r6, [r7, #7]
    layout->children[layout->nbChildren] = obj;
c0de1436:	f841 7020 	str.w	r7, [r1, r0, lsl #2]
    layout->nbChildren++;
c0de143a:	3001      	adds	r0, #1
    button->obj.alignment        = BOTTOM_MIDDLE;
c0de143c:	f887 a016 	strb.w	sl, [r7, #22]
    button->obj.alignmentMarginY = 3;
c0de1440:	76be      	strb	r6, [r7, #26]
    layout->nbChildren++;
c0de1442:	70a0      	strb	r0, [r4, #2]
    layoutAddObject(layoutInt, (nbgl_obj_t *) button);

    return 0;
}
c0de1444:	4630      	mov	r0, r6
c0de1446:	b001      	add	sp, #4
c0de1448:	e8bd 85f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, pc}

c0de144c <nbgl_layoutDraw>:
 */
int nbgl_layoutDraw(nbgl_layout_t *layoutParam)
{
    nbgl_layoutInternal_t *layout = (nbgl_layoutInternal_t *) layoutParam;

    if (layout == NULL) {
c0de144c:	2800      	cmp	r0, #0
c0de144e:	bf04      	itt	eq
c0de1450:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
    }
    LOG_DEBUG(LAYOUT_LOGGER, "nbgl_layoutDraw(): layout->nbChildren = %d\n", layout->nbChildren);
    nbgl_screenRedraw();

    return 0;
}
c0de1454:	4770      	bxeq	lr
c0de1456:	b580      	push	{r7, lr}
    nbgl_screenRedraw();
c0de1458:	f001 feaa 	bl	c0de31b0 <nbgl_screenRedraw>
c0de145c:	2000      	movs	r0, #0
c0de145e:	bd80      	pop	{r7, pc}

c0de1460 <nbgl_layoutRelease>:
 */
int nbgl_layoutRelease(nbgl_layout_t *layoutParam)
{
    nbgl_layoutInternal_t *layout = (nbgl_layoutInternal_t *) layoutParam;
    LOG_DEBUG(PAGE_LOGGER, "nbgl_layoutRelease(): \n");
    if (layout == NULL) {
c0de1460:	2800      	cmp	r0, #0
c0de1462:	bf04      	itt	eq
c0de1464:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
    if (layout->modal) {
        nbgl_screenPop(layout->layer);
    }
    layout->nbChildren = 0;
    return 0;
}
c0de1468:	4770      	bxeq	lr
c0de146a:	b510      	push	{r4, lr}
c0de146c:	4604      	mov	r4, r0
    if (layout->modal) {
c0de146e:	7800      	ldrb	r0, [r0, #0]
c0de1470:	b110      	cbz	r0, c0de1478 <nbgl_layoutRelease+0x18>
        nbgl_screenPop(layout->layer);
c0de1472:	7860      	ldrb	r0, [r4, #1]
c0de1474:	f001 fea1 	bl	c0de31ba <nbgl_screenPop>
c0de1478:	2000      	movs	r0, #0
    layout->nbChildren = 0;
c0de147a:	70a0      	strb	r0, [r4, #2]
c0de147c:	bd10      	pop	{r4, pc}
	...

c0de1480 <nbgl_stepDrawText>:
                              nbgl_screenTickerConfiguration_t *ticker,
                              const char                       *text,
                              const char                       *subText,
                              nbgl_contentCenteredInfoStyle_t   style,
                              bool                              modal)
{
c0de1480:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de1484:	f8dd b028 	ldr.w	fp, [sp, #40]	@ 0x28
c0de1488:	4605      	mov	r5, r0
c0de148a:	f240 207c 	movw	r0, #636	@ 0x27c
c0de148e:	469a      	mov	sl, r3
c0de1490:	4617      	mov	r7, r2
c0de1492:	460c      	mov	r4, r1
    if (!modal) {
c0de1494:	f1bb 0f00 	cmp.w	fp, #0
c0de1498:	f2c0 0000 	movt	r0, #0
c0de149c:	d00d      	beq.n	c0de14ba <nbgl_stepDrawText+0x3a>
c0de149e:	2100      	movs	r1, #0
            if (contexts[i].layout == NULL) {
c0de14a0:	eb09 0200 	add.w	r2, r9, r0
c0de14a4:	440a      	add	r2, r1
c0de14a6:	f8d2 2088 	ldr.w	r2, [r2, #136]	@ 0x88
c0de14aa:	2a00      	cmp	r2, #0
c0de14ac:	d05c      	beq.n	c0de1568 <nbgl_stepDrawText+0xe8>
        while (i < NB_MAX_LAYERS) {
c0de14ae:	3148      	adds	r1, #72	@ 0x48
c0de14b0:	2990      	cmp	r1, #144	@ 0x90
c0de14b2:	d1f5      	bne.n	c0de14a0 <nbgl_stepDrawText+0x20>
c0de14b4:	2600      	movs	r6, #0
    if (ctx == NULL) {
c0de14b6:	b926      	cbnz	r6, c0de14c2 <nbgl_stepDrawText+0x42>
c0de14b8:	e05c      	b.n	c0de1574 <nbgl_stepDrawText+0xf4>
c0de14ba:	eb09 0600 	add.w	r6, r9, r0
c0de14be:	2e00      	cmp	r6, #0
c0de14c0:	d058      	beq.n	c0de1574 <nbgl_stepDrawText+0xf4>
c0de14c2:	f8dd 8020 	ldr.w	r8, [sp, #32]
        ctx->type  = type;
c0de14c6:	4630      	mov	r0, r6
c0de14c8:	2148      	movs	r1, #72	@ 0x48
c0de14ca:	f002 ff3d 	bl	c0de4348 <__aeabi_memclr>
        ctx->modal = modal;
c0de14ce:	f886 b045 	strb.w	fp, [r6, #69]	@ 0x45
    StepContext_t *ctx = getFreeContext(TEXT_STEP, modal);
    if (!ctx) {
        return NULL;
    }
    // initialize context (already set to 0 by getFreeContext())
    ctx->textContext.onActionCallback = onActionCallback;
c0de14d2:	6174      	str	r4, [r6, #20]
    if (ticker) {
c0de14d4:	b31f      	cbz	r7, c0de151e <nbgl_stepDrawText+0x9e>
        ctx->ticker.tickerCallback  = ticker->tickerCallback;
c0de14d6:	7838      	ldrb	r0, [r7, #0]
c0de14d8:	78b9      	ldrb	r1, [r7, #2]
c0de14da:	78fa      	ldrb	r2, [r7, #3]
c0de14dc:	787b      	ldrb	r3, [r7, #1]
c0de14de:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de14e2:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de14e6:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de14ea:	6370      	str	r0, [r6, #52]	@ 0x34
        ctx->ticker.tickerIntervale = ticker->tickerIntervale;
c0de14ec:	4638      	mov	r0, r7
c0de14ee:	f810 1f08 	ldrb.w	r1, [r0, #8]!
c0de14f2:	7a7a      	ldrb	r2, [r7, #9]
c0de14f4:	7883      	ldrb	r3, [r0, #2]
c0de14f6:	78c0      	ldrb	r0, [r0, #3]
c0de14f8:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de14fc:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de1500:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
        ctx->ticker.tickerValue     = ticker->tickerValue;
c0de1504:	7979      	ldrb	r1, [r7, #5]
c0de1506:	f817 2f04 	ldrb.w	r2, [r7, #4]!
        ctx->ticker.tickerIntervale = ticker->tickerIntervale;
c0de150a:	63f0      	str	r0, [r6, #60]	@ 0x3c
        ctx->ticker.tickerValue     = ticker->tickerValue;
c0de150c:	78b8      	ldrb	r0, [r7, #2]
c0de150e:	78fb      	ldrb	r3, [r7, #3]
c0de1510:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de1514:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de1518:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de151c:	63b0      	str	r0, [r6, #56]	@ 0x38
                           last_nb_lines,
                           last_nb_pages,
                           last_bold_state);
#endif  // BUILD_SCREENSHOTS
        // NB_MAX_LINES-1 because first line is for main text
        ctx->textContext.nbPages = nbgl_getTextNbPagesInWidth(
c0de151e:	200a      	movs	r0, #10
c0de1520:	2372      	movs	r3, #114	@ 0x72
    if (subText == NULL) {
c0de1522:	f1b8 0f00 	cmp.w	r8, #0
        ctx->textContext.nbPages = nbgl_getTextNbPagesInWidth(
c0de1526:	bf19      	ittee	ne
c0de1528:	4641      	movne	r1, r8
c0de152a:	2203      	movne	r2, #3
        ctx->textContext.nbPages = nbgl_getTextNbPagesInWidth(
c0de152c:	4651      	moveq	r1, sl
c0de152e:	2204      	moveq	r2, #4
c0de1530:	f001 fe6b 	bl	c0de320a <nbgl_getTextNbPagesInWidth>
c0de1534:	9a09      	ldr	r2, [sp, #36]	@ 0x24
    LOG_DEBUG(STEP_LOGGER,
              "nbgl_stepDrawText: ctx = %p, nbPages = %d, pos = 0x%X\n",
              ctx,
              ctx->textContext.nbPages,
              pos);
    if (pos & BACKWARD_DIRECTION) {
c0de1536:	0729      	lsls	r1, r5, #28
c0de1538:	7030      	strb	r0, [r6, #0]
c0de153a:	d502      	bpl.n	c0de1542 <nbgl_stepDrawText+0xc2>
        // start with last page
        ctx->textContext.currentPage = ctx->textContext.nbPages - 1;
c0de153c:	7830      	ldrb	r0, [r6, #0]
c0de153e:	3801      	subs	r0, #1
c0de1540:	7070      	strb	r0, [r6, #1]
    }
    ctx->textContext.txtStart    = text;
    ctx->textContext.subTxtStart = subText;
    // keep only direction part of position
    ctx->textContext.pos               = pos & STEP_POSITION_MASK;
c0de1542:	f005 0003 	and.w	r0, r5, #3
c0de1546:	7430      	strb	r0, [r6, #16]
    ctx->textContext.actionOnAnyButton = (pos & ACTION_ON_ANY_BUTTON) != 0;
c0de1548:	f3c5 1080 	ubfx	r0, r5, #6, #1
    ctx->textContext.style             = style;
    displayTextPage(ctx, ctx->textContext.currentPage);
c0de154c:	7871      	ldrb	r1, [r6, #1]
    ctx->textContext.actionOnAnyButton = (pos & ACTION_ON_ANY_BUTTON) != 0;
c0de154e:	7470      	strb	r0, [r6, #17]
    displayTextPage(ctx, ctx->textContext.currentPage);
c0de1550:	4630      	mov	r0, r6
    ctx->textContext.txtStart    = text;
c0de1552:	f8c6 a004 	str.w	sl, [r6, #4]
    ctx->textContext.subTxtStart = subText;
c0de1556:	f8c6 800c 	str.w	r8, [r6, #12]
    ctx->textContext.style             = style;
c0de155a:	f886 2030 	strb.w	r2, [r6, #48]	@ 0x30
    displayTextPage(ctx, ctx->textContext.currentPage);
c0de155e:	f000 f80d 	bl	c0de157c <displayTextPage>

    return (nbgl_step_t) ctx;
}
c0de1562:	4630      	mov	r0, r6
c0de1564:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
                break;
c0de1568:	4448      	add	r0, r9
c0de156a:	4408      	add	r0, r1
c0de156c:	f100 0648 	add.w	r6, r0, #72	@ 0x48
    if (ctx == NULL) {
c0de1570:	2e00      	cmp	r6, #0
c0de1572:	d1a6      	bne.n	c0de14c2 <nbgl_stepDrawText+0x42>
c0de1574:	2000      	movs	r0, #0
}
c0de1576:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
	...

c0de157c <displayTextPage>:
{
c0de157c:	e92d 45f0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, lr}
c0de1580:	b091      	sub	sp, #68	@ 0x44
c0de1582:	4604      	mov	r4, r0
    if (textPage <= ctx->textContext.currentPage) {
c0de1584:	7840      	ldrb	r0, [r0, #1]
c0de1586:	460e      	mov	r6, r1
c0de1588:	4288      	cmp	r0, r1
c0de158a:	d21e      	bcs.n	c0de15ca <displayTextPage+0x4e>
        txt = ctx->textContext.nextPageStart;
c0de158c:	68a5      	ldr	r5, [r4, #8]
    if (ctx->textContext.currentPage < (ctx->textContext.nbPages - 1)) {
c0de158e:	7820      	ldrb	r0, [r4, #0]
    ctx->textContext.currentPage = textPage;
c0de1590:	7066      	strb	r6, [r4, #1]
    if (ctx->textContext.currentPage < (ctx->textContext.nbPages - 1)) {
c0de1592:	3801      	subs	r0, #1
c0de1594:	42b0      	cmp	r0, r6
c0de1596:	dd3a      	ble.n	c0de160e <displayTextPage+0x92>
            = (ctx->textContext.subTxtStart == NULL) ? NB_MAX_LINES : (NB_MAX_LINES - 1);
c0de1598:	68e0      	ldr	r0, [r4, #12]
c0de159a:	a908      	add	r1, sp, #32
c0de159c:	2701      	movs	r7, #1
        nbgl_getTextMaxLenInNbLines(
c0de159e:	9100      	str	r1, [sp, #0]
c0de15a0:	2303      	movs	r3, #3
c0de15a2:	2800      	cmp	r0, #0
c0de15a4:	f04f 000a 	mov.w	r0, #10
c0de15a8:	4629      	mov	r1, r5
c0de15aa:	f04f 0272 	mov.w	r2, #114	@ 0x72
c0de15ae:	bf08      	it	eq
c0de15b0:	2304      	moveq	r3, #4
c0de15b2:	9701      	str	r7, [sp, #4]
c0de15b4:	f001 fe33 	bl	c0de321e <nbgl_getTextMaxLenInNbLines>
        ctx->textContext.nextPageStart = txt + len;
c0de15b8:	f8bd 1020 	ldrh.w	r1, [sp, #32]
c0de15bc:	1868      	adds	r0, r5, r1
c0de15be:	60a0      	str	r0, [r4, #8]
        if (*ctx->textContext.nextPageStart == '\n') {
c0de15c0:	5c69      	ldrb	r1, [r5, r1]
c0de15c2:	290a      	cmp	r1, #10
c0de15c4:	d125      	bne.n	c0de1612 <displayTextPage+0x96>
            ctx->textContext.nextPageStart++;
c0de15c6:	3001      	adds	r0, #1
c0de15c8:	e022      	b.n	c0de1610 <displayTextPage+0x94>
        if (ctx->textContext.subTxtStart == NULL) {
c0de15ca:	68e5      	ldr	r5, [r4, #12]
c0de15cc:	2d00      	cmp	r5, #0
c0de15ce:	f000 808f 	beq.w	c0de16f0 <displayTextPage+0x174>
    while (page < textPage) {
c0de15d2:	2e00      	cmp	r6, #0
c0de15d4:	d0db      	beq.n	c0de158e <displayTextPage+0x12>
c0de15d6:	2700      	movs	r7, #0
c0de15d8:	f04f 0801 	mov.w	r8, #1
c0de15dc:	f10d 0a20 	add.w	sl, sp, #32
c0de15e0:	e003      	b.n	c0de15ea <displayTextPage+0x6e>
c0de15e2:	bf00      	nop
        page++;
c0de15e4:	3701      	adds	r7, #1
    while (page < textPage) {
c0de15e6:	42be      	cmp	r6, r7
c0de15e8:	d0d1      	beq.n	c0de158e <displayTextPage+0x12>
        if (page < (ctx->textContext.nbPages - 1)) {
c0de15ea:	7820      	ldrb	r0, [r4, #0]
c0de15ec:	3801      	subs	r0, #1
c0de15ee:	42b8      	cmp	r0, r7
c0de15f0:	ddf8      	ble.n	c0de15e4 <displayTextPage+0x68>
            nbgl_getTextMaxLenInNbLines(BAGL_FONT_OPEN_SANS_REGULAR_11px_1bpp,
c0de15f2:	200a      	movs	r0, #10
c0de15f4:	4629      	mov	r1, r5
c0de15f6:	2272      	movs	r2, #114	@ 0x72
c0de15f8:	2303      	movs	r3, #3
c0de15fa:	f8cd a000 	str.w	sl, [sp]
c0de15fe:	f8cd 8004 	str.w	r8, [sp, #4]
c0de1602:	f001 fe0c 	bl	c0de321e <nbgl_getTextMaxLenInNbLines>
            currentChar = currentChar + len;
c0de1606:	f8bd 0020 	ldrh.w	r0, [sp, #32]
c0de160a:	4405      	add	r5, r0
c0de160c:	e7ea      	b.n	c0de15e4 <displayTextPage+0x68>
c0de160e:	2000      	movs	r0, #0
c0de1610:	60a0      	str	r0, [r4, #8]
    layoutDescription.modal                  = ctx->modal;
c0de1612:	f894 0045 	ldrb.w	r0, [r4, #69]	@ 0x45
c0de1616:	2700      	movs	r7, #0
    nbgl_layoutNavigation_t  navInfo = {
c0de1618:	f8ad 700a 	strh.w	r7, [sp, #10]
    layoutDescription.modal                  = ctx->modal;
c0de161c:	f88d 000c 	strb.w	r0, [sp, #12]
    layoutDescription.onActionCallback       = actionCallback;
c0de1620:	f240 20c9 	movw	r0, #713	@ 0x2c9
c0de1624:	f2c0 0000 	movt	r0, #0
c0de1628:	4478      	add	r0, pc
    layoutDescription.ticker.tickerCallback  = ctx->ticker.tickerCallback;
c0de162a:	f104 0234 	add.w	r2, r4, #52	@ 0x34
    layoutDescription.onActionCallback       = actionCallback;
c0de162e:	9004      	str	r0, [sp, #16]
    layoutDescription.ticker.tickerCallback  = ctx->ticker.tickerCallback;
c0de1630:	ca07      	ldmia	r2, {r0, r1, r2}
c0de1632:	ab05      	add	r3, sp, #20
c0de1634:	c307      	stmia	r3!, {r0, r1, r2}
c0de1636:	a803      	add	r0, sp, #12
    ctx->layout                              = nbgl_layoutGet(&layoutDescription);
c0de1638:	f7ff f8aa 	bl	c0de0790 <nbgl_layoutGet>
        ctx->textContext.pos, ctx->textContext.nbPages, ctx->textContext.currentPage);
c0de163c:	7826      	ldrb	r6, [r4, #0]
c0de163e:	7861      	ldrb	r1, [r4, #1]
c0de1640:	7c22      	ldrb	r2, [r4, #16]
    if (nbPages > 1) {
c0de1642:	2e02      	cmp	r6, #2
    ctx->layout                              = nbgl_layoutGet(&layoutDescription);
c0de1644:	6420      	str	r0, [r4, #64]	@ 0x40
    if (nbPages > 1) {
c0de1646:	d307      	bcc.n	c0de1658 <displayTextPage+0xdc>
        if (currentPage > 0) {
c0de1648:	460f      	mov	r7, r1
c0de164a:	2900      	cmp	r1, #0
c0de164c:	bf18      	it	ne
c0de164e:	2701      	movne	r7, #1
        if (currentPage < (nbPages - 1)) {
c0de1650:	1e73      	subs	r3, r6, #1
c0de1652:	428b      	cmp	r3, r1
c0de1654:	bfc8      	it	gt
c0de1656:	3702      	addgt	r7, #2
    if (pos == FIRST_STEP) {
c0de1658:	2a03      	cmp	r2, #3
c0de165a:	d006      	beq.n	c0de166a <displayTextPage+0xee>
c0de165c:	2a02      	cmp	r2, #2
c0de165e:	d006      	beq.n	c0de166e <displayTextPage+0xf2>
c0de1660:	2a01      	cmp	r2, #1
        indication |= RIGHT_ARROW;
c0de1662:	bf08      	it	eq
c0de1664:	f047 0702 	orreq.w	r7, r7, #2
c0de1668:	e003      	b.n	c0de1672 <displayTextPage+0xf6>
c0de166a:	2703      	movs	r7, #3
c0de166c:	e001      	b.n	c0de1672 <displayTextPage+0xf6>
        indication |= LEFT_ARROW;
c0de166e:	f047 0701 	orr.w	r7, r7, #1
    if (ctx->textContext.subTxtStart == NULL) {
c0de1672:	68e2      	ldr	r2, [r4, #12]
    navInfo.indication = getNavigationInfo(
c0de1674:	f88d 700b 	strb.w	r7, [sp, #11]
    if (ctx->textContext.subTxtStart == NULL) {
c0de1678:	b182      	cbz	r2, c0de169c <displayTextPage+0x120>
        if (ctx->textContext.nbPages == 1) {
c0de167a:	2e01      	cmp	r6, #1
c0de167c:	d113      	bne.n	c0de16a6 <displayTextPage+0x12a>
                                           ctx->textContext.txtStart,
c0de167e:	6861      	ldr	r1, [r4, #4]
            if (nbgl_getTextNbLinesInWidth(BAGL_FONT_OPEN_SANS_EXTRABOLD_11px_1bpp,
c0de1680:	2008      	movs	r0, #8
c0de1682:	2272      	movs	r2, #114	@ 0x72
c0de1684:	2300      	movs	r3, #0
c0de1686:	2600      	movs	r6, #0
c0de1688:	f001 fdba 	bl	c0de3200 <nbgl_getTextNbLinesInWidth>
c0de168c:	2802      	cmp	r0, #2
c0de168e:	d34f      	bcc.n	c0de1730 <displayTextPage+0x1b4>
                                         ctx->textContext.txtStart,
c0de1690:	6861      	ldr	r1, [r4, #4]
                                         ctx->textContext.tmpString,
c0de1692:	f104 0018 	add.w	r0, r4, #24
c0de1696:	2718      	movs	r7, #24
                nbgl_textReduceOnNbLines(BAGL_FONT_OPEN_SANS_EXTRABOLD_11px_1bpp,
c0de1698:	9000      	str	r0, [sp, #0]
c0de169a:	e022      	b.n	c0de16e2 <displayTextPage+0x166>
        nbgl_layoutAddText(ctx->layout, txt, NULL, ctx->textContext.style);
c0de169c:	f894 3030 	ldrb.w	r3, [r4, #48]	@ 0x30
c0de16a0:	4629      	mov	r1, r5
c0de16a2:	2200      	movs	r2, #0
c0de16a4:	e05e      	b.n	c0de1764 <displayTextPage+0x1e8>
            SPRINTF(intermediateString,
c0de16a6:	1c48      	adds	r0, r1, #1
c0de16a8:	6863      	ldr	r3, [r4, #4]
c0de16aa:	9000      	str	r0, [sp, #0]
c0de16ac:	f642 7202 	movw	r2, #12034	@ 0x2f02
c0de16b0:	f2c0 0200 	movt	r2, #0
c0de16b4:	af08      	add	r7, sp, #32
c0de16b6:	447a      	add	r2, pc
c0de16b8:	4638      	mov	r0, r7
c0de16ba:	2124      	movs	r1, #36	@ 0x24
c0de16bc:	9601      	str	r6, [sp, #4]
c0de16be:	f002 fc2d 	bl	c0de3f1c <snprintf>
            if (nbgl_getTextNbLinesInWidth(BAGL_FONT_OPEN_SANS_EXTRABOLD_11px_1bpp,
c0de16c2:	2008      	movs	r0, #8
c0de16c4:	4639      	mov	r1, r7
c0de16c6:	2272      	movs	r2, #114	@ 0x72
c0de16c8:	2300      	movs	r3, #0
c0de16ca:	f04f 0800 	mov.w	r8, #0
c0de16ce:	f001 fd97 	bl	c0de3200 <nbgl_getTextNbLinesInWidth>
c0de16d2:	2802      	cmp	r0, #2
c0de16d4:	f104 0c18 	add.w	ip, r4, #24
c0de16d8:	d333      	bcc.n	c0de1742 <displayTextPage+0x1c6>
c0de16da:	2718      	movs	r7, #24
c0de16dc:	a908      	add	r1, sp, #32
                nbgl_textReduceOnNbLines(BAGL_FONT_OPEN_SANS_EXTRABOLD_11px_1bpp,
c0de16de:	f8cd c000 	str.w	ip, [sp]
c0de16e2:	2008      	movs	r0, #8
c0de16e4:	2272      	movs	r2, #114	@ 0x72
c0de16e6:	2301      	movs	r3, #1
c0de16e8:	9701      	str	r7, [sp, #4]
c0de16ea:	f001 fd9d 	bl	c0de3228 <nbgl_textReduceOnNbLines>
c0de16ee:	e033      	b.n	c0de1758 <displayTextPage+0x1dc>
    const char *currentChar = ctx->textContext.txtStart;
c0de16f0:	6865      	ldr	r5, [r4, #4]
    while (page < textPage) {
c0de16f2:	2e00      	cmp	r6, #0
c0de16f4:	f43f af4b 	beq.w	c0de158e <displayTextPage+0x12>
c0de16f8:	2700      	movs	r7, #0
c0de16fa:	f04f 0801 	mov.w	r8, #1
c0de16fe:	f10d 0a20 	add.w	sl, sp, #32
c0de1702:	e003      	b.n	c0de170c <displayTextPage+0x190>
        page++;
c0de1704:	3701      	adds	r7, #1
    while (page < textPage) {
c0de1706:	42be      	cmp	r6, r7
c0de1708:	f43f af41 	beq.w	c0de158e <displayTextPage+0x12>
        if (page < (ctx->textContext.nbPages - 1)) {
c0de170c:	7820      	ldrb	r0, [r4, #0]
c0de170e:	3801      	subs	r0, #1
c0de1710:	42b8      	cmp	r0, r7
c0de1712:	ddf7      	ble.n	c0de1704 <displayTextPage+0x188>
            nbgl_getTextMaxLenInNbLines(BAGL_FONT_OPEN_SANS_REGULAR_11px_1bpp,
c0de1714:	200a      	movs	r0, #10
c0de1716:	4629      	mov	r1, r5
c0de1718:	2272      	movs	r2, #114	@ 0x72
c0de171a:	2304      	movs	r3, #4
c0de171c:	f8cd a000 	str.w	sl, [sp]
c0de1720:	f8cd 8004 	str.w	r8, [sp, #4]
c0de1724:	f001 fd7b 	bl	c0de321e <nbgl_getTextMaxLenInNbLines>
            currentChar = currentChar + len;
c0de1728:	f8bd 0020 	ldrh.w	r0, [sp, #32]
c0de172c:	4405      	add	r5, r0
c0de172e:	e7e9      	b.n	c0de1704 <displayTextPage+0x188>
                    ctx->textContext.tmpString, ctx->textContext.txtStart, TMP_STRING_MAX_LEN - 1);
c0de1730:	6861      	ldr	r1, [r4, #4]
                memcpy(
c0de1732:	f104 0018 	add.w	r0, r4, #24
c0de1736:	2217      	movs	r2, #23
c0de1738:	f002 fdfc 	bl	c0de4334 <__aeabi_memcpy>
                ctx->textContext.tmpString[TMP_STRING_MAX_LEN - 1] = 0;
c0de173c:	f884 602f 	strb.w	r6, [r4, #47]	@ 0x2f
c0de1740:	e00a      	b.n	c0de1758 <displayTextPage+0x1dc>
                memcpy(ctx->textContext.tmpString, intermediateString, TMP_STRING_MAX_LEN - 1);
c0de1742:	cf4f      	ldmia	r7!, {r0, r1, r2, r3, r6}
c0de1744:	e8ac 004f 	stmia.w	ip!, {r0, r1, r2, r3, r6}
c0de1748:	8838      	ldrh	r0, [r7, #0]
c0de174a:	78b9      	ldrb	r1, [r7, #2]
c0de174c:	f8ac 0000 	strh.w	r0, [ip]
c0de1750:	f88c 1002 	strb.w	r1, [ip, #2]
                ctx->textContext.tmpString[TMP_STRING_MAX_LEN - 1] = 0;
c0de1754:	f884 802f 	strb.w	r8, [r4, #47]	@ 0x2f
        nbgl_layoutAddText(ctx->layout, ctx->textContext.tmpString, txt, ctx->textContext.style);
c0de1758:	6c20      	ldr	r0, [r4, #64]	@ 0x40
c0de175a:	f894 3030 	ldrb.w	r3, [r4, #48]	@ 0x30
c0de175e:	f104 0118 	add.w	r1, r4, #24
c0de1762:	462a      	mov	r2, r5
c0de1764:	f7ff f8e6 	bl	c0de0934 <nbgl_layoutAddText>
    if (navInfo.indication != NO_ARROWS) {
c0de1768:	f89d 000b 	ldrb.w	r0, [sp, #11]
c0de176c:	b120      	cbz	r0, c0de1778 <displayTextPage+0x1fc>
        nbgl_layoutAddNavigation(ctx->layout, &navInfo);
c0de176e:	6c20      	ldr	r0, [r4, #64]	@ 0x40
c0de1770:	f10d 010a 	add.w	r1, sp, #10
c0de1774:	f7ff f87e 	bl	c0de0874 <nbgl_layoutAddNavigation>
    nbgl_layoutDraw(ctx->layout);
c0de1778:	6c20      	ldr	r0, [r4, #64]	@ 0x40
c0de177a:	f7ff fe67 	bl	c0de144c <nbgl_layoutDraw>
    nbgl_refresh();
c0de177e:	f001 fcfe 	bl	c0de317e <nbgl_refresh>
}
c0de1782:	b011      	add	sp, #68	@ 0x44
c0de1784:	e8bd 85f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, pc}

c0de1788 <nbgl_stepDrawCenteredInfo>:
nbgl_step_t nbgl_stepDrawCenteredInfo(nbgl_stepPosition_t               pos,
                                      nbgl_stepButtonCallback_t         onActionCallback,
                                      nbgl_screenTickerConfiguration_t *ticker,
                                      nbgl_layoutCenteredInfo_t        *info,
                                      bool                              modal)
{
c0de1788:	e92d 45f0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, lr}
c0de178c:	b087      	sub	sp, #28
c0de178e:	9e0e      	ldr	r6, [sp, #56]	@ 0x38
c0de1790:	4682      	mov	sl, r0
c0de1792:	2000      	movs	r0, #0
c0de1794:	460c      	mov	r4, r1
    nbgl_layoutDescription_t layoutDescription
c0de1796:	9002      	str	r0, [sp, #8]
c0de1798:	9006      	str	r0, [sp, #24]
c0de179a:	e9cd 0004 	strd	r0, r0, [sp, #16]
        = {.modal = modal, .onActionCallback = (nbgl_layoutButtonCallback_t) actionCallback};
c0de179e:	f88d 6008 	strb.w	r6, [sp, #8]
c0de17a2:	f240 113b 	movw	r1, #315	@ 0x13b
c0de17a6:	f2c0 0100 	movt	r1, #0
    nbgl_layoutNavigation_t navInfo = {
c0de17aa:	f8ad 0006 	strh.w	r0, [sp, #6]
c0de17ae:	f240 207c 	movw	r0, #636	@ 0x27c
c0de17b2:	4698      	mov	r8, r3
c0de17b4:	4617      	mov	r7, r2
        = {.modal = modal, .onActionCallback = (nbgl_layoutButtonCallback_t) actionCallback};
c0de17b6:	4479      	add	r1, pc
c0de17b8:	f2c0 0000 	movt	r0, #0
c0de17bc:	9103      	str	r1, [sp, #12]
    if (!modal) {
c0de17be:	b176      	cbz	r6, c0de17de <nbgl_stepDrawCenteredInfo+0x56>
c0de17c0:	2100      	movs	r1, #0
c0de17c2:	bf00      	nop
            if (contexts[i].layout == NULL) {
c0de17c4:	eb09 0200 	add.w	r2, r9, r0
c0de17c8:	440a      	add	r2, r1
c0de17ca:	f8d2 2088 	ldr.w	r2, [r2, #136]	@ 0x88
c0de17ce:	2a00      	cmp	r2, #0
c0de17d0:	d06a      	beq.n	c0de18a8 <nbgl_stepDrawCenteredInfo+0x120>
        while (i < NB_MAX_LAYERS) {
c0de17d2:	3148      	adds	r1, #72	@ 0x48
c0de17d4:	2990      	cmp	r1, #144	@ 0x90
c0de17d6:	d1f5      	bne.n	c0de17c4 <nbgl_stepDrawCenteredInfo+0x3c>
c0de17d8:	2500      	movs	r5, #0
    if (ctx == NULL) {
c0de17da:	b925      	cbnz	r5, c0de17e6 <nbgl_stepDrawCenteredInfo+0x5e>
c0de17dc:	e06a      	b.n	c0de18b4 <nbgl_stepDrawCenteredInfo+0x12c>
c0de17de:	eb09 0500 	add.w	r5, r9, r0
c0de17e2:	2d00      	cmp	r5, #0
c0de17e4:	d066      	beq.n	c0de18b4 <nbgl_stepDrawCenteredInfo+0x12c>
        memset(ctx, 0, sizeof(StepContext_t));
c0de17e6:	4628      	mov	r0, r5
c0de17e8:	2148      	movs	r1, #72	@ 0x48
c0de17ea:	f002 fdad 	bl	c0de4348 <__aeabi_memclr>
c0de17ee:	f04f 0c01 	mov.w	ip, #1
        return NULL;
    }

    // initialize context (already set to 0 by getFreeContext())
    ctx->textContext.onActionCallback = onActionCallback;
    if (ticker) {
c0de17f2:	2f00      	cmp	r7, #0
        ctx->type  = type;
c0de17f4:	f885 c044 	strb.w	ip, [r5, #68]	@ 0x44
        ctx->modal = modal;
c0de17f8:	f885 6045 	strb.w	r6, [r5, #69]	@ 0x45
    ctx->textContext.onActionCallback = onActionCallback;
c0de17fc:	616c      	str	r4, [r5, #20]
    if (ticker) {
c0de17fe:	d045      	beq.n	c0de188c <nbgl_stepDrawCenteredInfo+0x104>
        ctx->ticker.tickerCallback               = ticker->tickerCallback;
c0de1800:	7839      	ldrb	r1, [r7, #0]
c0de1802:	78ba      	ldrb	r2, [r7, #2]
c0de1804:	78fb      	ldrb	r3, [r7, #3]
c0de1806:	787e      	ldrb	r6, [r7, #1]
c0de1808:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de180c:	ea41 2106 	orr.w	r1, r1, r6, lsl #8
c0de1810:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de1814:	6369      	str	r1, [r5, #52]	@ 0x34
        ctx->ticker.tickerIntervale              = ticker->tickerIntervale;
c0de1816:	4639      	mov	r1, r7
c0de1818:	f811 2f08 	ldrb.w	r2, [r1, #8]!
c0de181c:	7a7b      	ldrb	r3, [r7, #9]
c0de181e:	788e      	ldrb	r6, [r1, #2]
c0de1820:	78cc      	ldrb	r4, [r1, #3]
c0de1822:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de1826:	ea46 2304 	orr.w	r3, r6, r4, lsl #8
c0de182a:	ea42 4203 	orr.w	r2, r2, r3, lsl #16
c0de182e:	63ea      	str	r2, [r5, #60]	@ 0x3c
        ctx->ticker.tickerValue                  = ticker->tickerValue;
c0de1830:	463a      	mov	r2, r7
c0de1832:	f812 3f04 	ldrb.w	r3, [r2, #4]!
c0de1836:	797e      	ldrb	r6, [r7, #5]
c0de1838:	7894      	ldrb	r4, [r2, #2]
c0de183a:	78d0      	ldrb	r0, [r2, #3]
c0de183c:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de1840:	ea44 2000 	orr.w	r0, r4, r0, lsl #8
c0de1844:	ea43 4000 	orr.w	r0, r3, r0, lsl #16
c0de1848:	63a8      	str	r0, [r5, #56]	@ 0x38
        layoutDescription.ticker.tickerCallback  = ticker->tickerCallback;
c0de184a:	7838      	ldrb	r0, [r7, #0]
c0de184c:	78bb      	ldrb	r3, [r7, #2]
c0de184e:	78fe      	ldrb	r6, [r7, #3]
c0de1850:	787c      	ldrb	r4, [r7, #1]
c0de1852:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de1856:	ea40 2004 	orr.w	r0, r0, r4, lsl #8
c0de185a:	ea40 4003 	orr.w	r0, r0, r3, lsl #16
c0de185e:	9004      	str	r0, [sp, #16]
        layoutDescription.ticker.tickerIntervale = ticker->tickerIntervale;
c0de1860:	7a78      	ldrb	r0, [r7, #9]
c0de1862:	780b      	ldrb	r3, [r1, #0]
c0de1864:	788e      	ldrb	r6, [r1, #2]
c0de1866:	78c9      	ldrb	r1, [r1, #3]
c0de1868:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de186c:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de1870:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de1874:	9006      	str	r0, [sp, #24]
        layoutDescription.ticker.tickerValue     = ticker->tickerValue;
c0de1876:	7978      	ldrb	r0, [r7, #5]
c0de1878:	7811      	ldrb	r1, [r2, #0]
c0de187a:	7893      	ldrb	r3, [r2, #2]
c0de187c:	78d2      	ldrb	r2, [r2, #3]
c0de187e:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de1882:	ea43 2102 	orr.w	r1, r3, r2, lsl #8
c0de1886:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de188a:	9005      	str	r0, [sp, #20]
    if (pos == FIRST_STEP) {
c0de188c:	f00a 0003 	and.w	r0, sl, #3
c0de1890:	2803      	cmp	r0, #3
    }

    ctx->textContext.nbPages = 1;
c0de1892:	f885 c000 	strb.w	ip, [r5]
    // keep only direction part of position
    ctx->textContext.pos = pos & (RIGHT_ARROW | LEFT_ARROW);
c0de1896:	7428      	strb	r0, [r5, #16]
    if (pos == FIRST_STEP) {
c0de1898:	d00e      	beq.n	c0de18b8 <nbgl_stepDrawCenteredInfo+0x130>
c0de189a:	2802      	cmp	r0, #2
c0de189c:	d00e      	beq.n	c0de18bc <nbgl_stepDrawCenteredInfo+0x134>
c0de189e:	2801      	cmp	r0, #1
c0de18a0:	bf0c      	ite	eq
c0de18a2:	2002      	moveq	r0, #2
c0de18a4:	2000      	movne	r0, #0
c0de18a6:	e00a      	b.n	c0de18be <nbgl_stepDrawCenteredInfo+0x136>
                break;
c0de18a8:	4448      	add	r0, r9
c0de18aa:	4408      	add	r0, r1
c0de18ac:	f100 0548 	add.w	r5, r0, #72	@ 0x48
    if (ctx == NULL) {
c0de18b0:	2d00      	cmp	r5, #0
c0de18b2:	d198      	bne.n	c0de17e6 <nbgl_stepDrawCenteredInfo+0x5e>
c0de18b4:	2500      	movs	r5, #0
c0de18b6:	e018      	b.n	c0de18ea <nbgl_stepDrawCenteredInfo+0x162>
c0de18b8:	2003      	movs	r0, #3
c0de18ba:	e000      	b.n	c0de18be <nbgl_stepDrawCenteredInfo+0x136>
c0de18bc:	2001      	movs	r0, #1
    navInfo.indication   = getNavigationInfo(
c0de18be:	f88d 0007 	strb.w	r0, [sp, #7]
c0de18c2:	a802      	add	r0, sp, #8
        ctx->textContext.pos, ctx->textContext.nbPages, ctx->textContext.currentPage);

    ctx->layout = nbgl_layoutGet(&layoutDescription);
c0de18c4:	f7fe ff64 	bl	c0de0790 <nbgl_layoutGet>
    nbgl_layoutAddCenteredInfo(ctx->layout, info);
c0de18c8:	4641      	mov	r1, r8
    ctx->layout = nbgl_layoutGet(&layoutDescription);
c0de18ca:	6428      	str	r0, [r5, #64]	@ 0x40
    nbgl_layoutAddCenteredInfo(ctx->layout, info);
c0de18cc:	f7ff faef 	bl	c0de0eae <nbgl_layoutAddCenteredInfo>
    if (navInfo.indication != NO_ARROWS) {
c0de18d0:	f89d 0007 	ldrb.w	r0, [sp, #7]
c0de18d4:	b120      	cbz	r0, c0de18e0 <nbgl_stepDrawCenteredInfo+0x158>
        nbgl_layoutAddNavigation(ctx->layout, &navInfo);
c0de18d6:	6c28      	ldr	r0, [r5, #64]	@ 0x40
c0de18d8:	f10d 0106 	add.w	r1, sp, #6
c0de18dc:	f7fe ffca 	bl	c0de0874 <nbgl_layoutAddNavigation>
    }
    nbgl_layoutDraw(ctx->layout);
c0de18e0:	6c28      	ldr	r0, [r5, #64]	@ 0x40
c0de18e2:	f7ff fdb3 	bl	c0de144c <nbgl_layoutDraw>
    nbgl_refresh();
c0de18e6:	f001 fc4a 	bl	c0de317e <nbgl_refresh>

    LOG_DEBUG(STEP_LOGGER, "nbgl_stepDrawCenteredInfo(): step = %p\n", ctx);
    return (nbgl_step_t) ctx;
}
c0de18ea:	4628      	mov	r0, r5
c0de18ec:	b007      	add	sp, #28
c0de18ee:	e8bd 85f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, pc}
	...

c0de18f4 <actionCallback>:
{
c0de18f4:	b580      	push	{r7, lr}
c0de18f6:	f240 2c7c 	movw	ip, #636	@ 0x27c
c0de18fa:	2200      	movs	r2, #0
c0de18fc:	f2c0 0c00 	movt	ip, #0
        if (contexts[i].layout == layout) {
c0de1900:	eb09 030c 	add.w	r3, r9, ip
c0de1904:	4413      	add	r3, r2
c0de1906:	6c1b      	ldr	r3, [r3, #64]	@ 0x40
c0de1908:	4283      	cmp	r3, r0
c0de190a:	d005      	beq.n	c0de1918 <actionCallback+0x24>
    while (i < NB_MAX_LAYERS) {
c0de190c:	3248      	adds	r2, #72	@ 0x48
c0de190e:	2ad8      	cmp	r2, #216	@ 0xd8
c0de1910:	d1f6      	bne.n	c0de1900 <actionCallback+0xc>
c0de1912:	2000      	movs	r0, #0
    if (!ctx) {
c0de1914:	b928      	cbnz	r0, c0de1922 <actionCallback+0x2e>
}
c0de1916:	bd80      	pop	{r7, pc}
            break;
c0de1918:	eb09 000c 	add.w	r0, r9, ip
c0de191c:	4410      	add	r0, r2
    if (!ctx) {
c0de191e:	2800      	cmp	r0, #0
c0de1920:	d0f9      	beq.n	c0de1916 <actionCallback+0x22>
    if (event == BUTTON_LEFT_PRESSED) {
c0de1922:	2904      	cmp	r1, #4
c0de1924:	d01f      	beq.n	c0de1966 <actionCallback+0x72>
c0de1926:	2901      	cmp	r1, #1
c0de1928:	d005      	beq.n	c0de1936 <actionCallback+0x42>
c0de192a:	2900      	cmp	r1, #0
c0de192c:	d1f3      	bne.n	c0de1916 <actionCallback+0x22>
        if (ctx->textContext.currentPage > 0) {
c0de192e:	7842      	ldrb	r2, [r0, #1]
c0de1930:	b18a      	cbz	r2, c0de1956 <actionCallback+0x62>
            displayTextPage(ctx, ctx->textContext.currentPage - 1);
c0de1932:	1e51      	subs	r1, r2, #1
c0de1934:	e005      	b.n	c0de1942 <actionCallback+0x4e>
        if (ctx->textContext.currentPage < (ctx->textContext.nbPages - 1)) {
c0de1936:	7803      	ldrb	r3, [r0, #0]
c0de1938:	7842      	ldrb	r2, [r0, #1]
c0de193a:	3b01      	subs	r3, #1
c0de193c:	4293      	cmp	r3, r2
c0de193e:	dd04      	ble.n	c0de194a <actionCallback+0x56>
            displayTextPage(ctx, ctx->textContext.currentPage + 1);
c0de1940:	1c51      	adds	r1, r2, #1
c0de1942:	b2c9      	uxtb	r1, r1
c0de1944:	f7ff fe1a 	bl	c0de157c <displayTextPage>
}
c0de1948:	bd80      	pop	{r7, pc}
        else if ((ctx->textContext.pos == FIRST_STEP)
c0de194a:	7c02      	ldrb	r2, [r0, #16]
                 || (ctx->textContext.pos == NEITHER_FIRST_NOR_LAST_STEP)
c0de194c:	f042 0202 	orr.w	r2, r2, #2
c0de1950:	2a03      	cmp	r2, #3
c0de1952:	d008      	beq.n	c0de1966 <actionCallback+0x72>
c0de1954:	e004      	b.n	c0de1960 <actionCallback+0x6c>
        else if ((ctx->textContext.pos == LAST_STEP)
c0de1956:	7c02      	ldrb	r2, [r0, #16]
                 || (ctx->textContext.pos == NEITHER_FIRST_NOR_LAST_STEP)
c0de1958:	f002 02fe 	and.w	r2, r2, #254	@ 0xfe
c0de195c:	2a02      	cmp	r2, #2
c0de195e:	d002      	beq.n	c0de1966 <actionCallback+0x72>
c0de1960:	7c42      	ldrb	r2, [r0, #17]
c0de1962:	2a00      	cmp	r2, #0
c0de1964:	d0d7      	beq.n	c0de1916 <actionCallback+0x22>
c0de1966:	6942      	ldr	r2, [r0, #20]
c0de1968:	2a00      	cmp	r2, #0
}
c0de196a:	bf08      	it	eq
c0de196c:	bd80      	popeq	{r7, pc}
c0de196e:	4790      	blx	r2
c0de1970:	bd80      	pop	{r7, pc}
	...

c0de1974 <nbgl_stepDrawMenuList>:
 */
nbgl_step_t nbgl_stepDrawMenuList(nbgl_stepMenuListCallback_t       onActionCallback,
                                  nbgl_screenTickerConfiguration_t *ticker,
                                  nbgl_layoutMenuList_t            *list,
                                  bool                              modal)
{
c0de1974:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
c0de1978:	4680      	mov	r8, r0
c0de197a:	f240 207c 	movw	r0, #636	@ 0x27c
c0de197e:	461d      	mov	r5, r3
c0de1980:	4614      	mov	r4, r2
c0de1982:	460e      	mov	r6, r1
c0de1984:	f2c0 0000 	movt	r0, #0
    if (!modal) {
c0de1988:	b16b      	cbz	r3, c0de19a6 <nbgl_stepDrawMenuList+0x32>
c0de198a:	2100      	movs	r1, #0
            if (contexts[i].layout == NULL) {
c0de198c:	eb09 0200 	add.w	r2, r9, r0
c0de1990:	440a      	add	r2, r1
c0de1992:	f8d2 2088 	ldr.w	r2, [r2, #136]	@ 0x88
c0de1996:	2a00      	cmp	r2, #0
c0de1998:	d044      	beq.n	c0de1a24 <nbgl_stepDrawMenuList+0xb0>
        while (i < NB_MAX_LAYERS) {
c0de199a:	3148      	adds	r1, #72	@ 0x48
c0de199c:	2990      	cmp	r1, #144	@ 0x90
c0de199e:	d1f5      	bne.n	c0de198c <nbgl_stepDrawMenuList+0x18>
c0de19a0:	2700      	movs	r7, #0
    if (ctx == NULL) {
c0de19a2:	b927      	cbnz	r7, c0de19ae <nbgl_stepDrawMenuList+0x3a>
c0de19a4:	e044      	b.n	c0de1a30 <nbgl_stepDrawMenuList+0xbc>
c0de19a6:	eb09 0700 	add.w	r7, r9, r0
c0de19aa:	2f00      	cmp	r7, #0
c0de19ac:	d040      	beq.n	c0de1a30 <nbgl_stepDrawMenuList+0xbc>
        memset(ctx, 0, sizeof(StepContext_t));
c0de19ae:	4638      	mov	r0, r7
c0de19b0:	2148      	movs	r1, #72	@ 0x48
c0de19b2:	f002 fcc9 	bl	c0de4348 <__aeabi_memclr>
c0de19b6:	2002      	movs	r0, #2
        ctx->type  = type;
c0de19b8:	f887 0044 	strb.w	r0, [r7, #68]	@ 0x44
        ctx->modal = modal;
c0de19bc:	f887 5045 	strb.w	r5, [r7, #69]	@ 0x45
    if (!ctx) {
        return NULL;
    }

    // initialize context (already set to 0 by getFreeContext())
    if (ticker) {
c0de19c0:	b31e      	cbz	r6, c0de1a0a <nbgl_stepDrawMenuList+0x96>
        ctx->ticker.tickerCallback  = ticker->tickerCallback;
c0de19c2:	7830      	ldrb	r0, [r6, #0]
c0de19c4:	78b1      	ldrb	r1, [r6, #2]
c0de19c6:	78f2      	ldrb	r2, [r6, #3]
c0de19c8:	7873      	ldrb	r3, [r6, #1]
c0de19ca:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de19ce:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de19d2:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de19d6:	6378      	str	r0, [r7, #52]	@ 0x34
        ctx->ticker.tickerIntervale = ticker->tickerIntervale;
c0de19d8:	4630      	mov	r0, r6
c0de19da:	f810 1f08 	ldrb.w	r1, [r0, #8]!
c0de19de:	7a72      	ldrb	r2, [r6, #9]
c0de19e0:	7883      	ldrb	r3, [r0, #2]
c0de19e2:	78c0      	ldrb	r0, [r0, #3]
c0de19e4:	ea41 2102 	orr.w	r1, r1, r2, lsl #8
c0de19e8:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de19ec:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
        ctx->ticker.tickerValue     = ticker->tickerValue;
c0de19f0:	7971      	ldrb	r1, [r6, #5]
c0de19f2:	f816 2f04 	ldrb.w	r2, [r6, #4]!
        ctx->ticker.tickerIntervale = ticker->tickerIntervale;
c0de19f6:	63f8      	str	r0, [r7, #60]	@ 0x3c
        ctx->ticker.tickerValue     = ticker->tickerValue;
c0de19f8:	78b0      	ldrb	r0, [r6, #2]
c0de19fa:	78f3      	ldrb	r3, [r6, #3]
c0de19fc:	ea42 2101 	orr.w	r1, r2, r1, lsl #8
c0de1a00:	ea40 2003 	orr.w	r0, r0, r3, lsl #8
c0de1a04:	ea41 4000 	orr.w	r0, r1, r0, lsl #16
c0de1a08:	63b8      	str	r0, [r7, #56]	@ 0x38
    }

    ctx->menuListContext.list.nbChoices      = list->nbChoices;
c0de1a0a:	7920      	ldrb	r0, [r4, #4]
c0de1a0c:	7238      	strb	r0, [r7, #8]
    ctx->menuListContext.list.selectedChoice = list->selectedChoice;
c0de1a0e:	7960      	ldrb	r0, [r4, #5]
c0de1a10:	7278      	strb	r0, [r7, #9]
    ctx->menuListContext.list.callback       = list->callback;
c0de1a12:	6820      	ldr	r0, [r4, #0]
    ctx->menuListContext.selectedCallback    = onActionCallback;
c0de1a14:	e9c7 8000 	strd	r8, r0, [r7]

    displayMenuList(ctx);
c0de1a18:	4638      	mov	r0, r7
c0de1a1a:	f000 f80c 	bl	c0de1a36 <displayMenuList>

    LOG_DEBUG(STEP_LOGGER, "nbgl_stepDrawMenuList(): step = %p\n", ctx);

    return (nbgl_step_t) ctx;
}
c0de1a1e:	4638      	mov	r0, r7
c0de1a20:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
                break;
c0de1a24:	4448      	add	r0, r9
c0de1a26:	4408      	add	r0, r1
c0de1a28:	f100 0748 	add.w	r7, r0, #72	@ 0x48
    if (ctx == NULL) {
c0de1a2c:	2f00      	cmp	r7, #0
c0de1a2e:	d1be      	bne.n	c0de19ae <nbgl_stepDrawMenuList+0x3a>
c0de1a30:	2000      	movs	r0, #0
}
c0de1a32:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}

c0de1a36 <displayMenuList>:
{
c0de1a36:	b5b0      	push	{r4, r5, r7, lr}
c0de1a38:	b086      	sub	sp, #24
c0de1a3a:	4604      	mov	r4, r0
        = {.modal = ctx->modal, .onActionCallback = menuListActionCallback};
c0de1a3c:	f894 1045 	ldrb.w	r1, [r4, #69]	@ 0x45
c0de1a40:	2000      	movs	r0, #0
    nbgl_layoutDescription_t layoutDescription
c0de1a42:	9001      	str	r0, [sp, #4]
        = {.modal = ctx->modal, .onActionCallback = menuListActionCallback};
c0de1a44:	f88d 1004 	strb.w	r1, [sp, #4]
c0de1a48:	f240 10dd 	movw	r0, #477	@ 0x1dd
c0de1a4c:	f2c0 0000 	movt	r0, #0
c0de1a50:	4478      	add	r0, pc
    layoutDescription.ticker.tickerCallback  = ctx->ticker.tickerCallback;
c0de1a52:	f104 0234 	add.w	r2, r4, #52	@ 0x34
        = {.modal = ctx->modal, .onActionCallback = menuListActionCallback};
c0de1a56:	9002      	str	r0, [sp, #8]
    layoutDescription.ticker.tickerCallback  = ctx->ticker.tickerCallback;
c0de1a58:	ca07      	ldmia	r2, {r0, r1, r2}
c0de1a5a:	ab03      	add	r3, sp, #12
c0de1a5c:	c307      	stmia	r3!, {r0, r1, r2}
c0de1a5e:	a801      	add	r0, sp, #4
    nbgl_layoutMenuList_t *list = &ctx->menuListContext.list;
c0de1a60:	1d25      	adds	r5, r4, #4
    ctx->layout = nbgl_layoutGet(&layoutDescription);
c0de1a62:	f7fe fe95 	bl	c0de0790 <nbgl_layoutGet>
    nbgl_layoutAddMenuList(ctx->layout, list);
c0de1a66:	4629      	mov	r1, r5
    ctx->layout = nbgl_layoutGet(&layoutDescription);
c0de1a68:	6420      	str	r0, [r4, #64]	@ 0x40
    nbgl_layoutAddMenuList(ctx->layout, list);
c0de1a6a:	f7ff f9b9 	bl	c0de0de0 <nbgl_layoutAddMenuList>
    if (list->nbChoices > 1) {
c0de1a6e:	7a20      	ldrb	r0, [r4, #8]
c0de1a70:	2802      	cmp	r0, #2
c0de1a72:	d314      	bcc.n	c0de1a9e <displayMenuList+0x68>
        if (list->selectedChoice > 0) {
c0de1a74:	796a      	ldrb	r2, [r5, #5]
c0de1a76:	2101      	movs	r1, #1
        nbgl_layoutNavigation_t navInfo = {.direction = VERTICAL_NAV};
c0de1a78:	f8ad 1002 	strh.w	r1, [sp, #2]
        if (list->selectedChoice > 0) {
c0de1a7c:	2a00      	cmp	r2, #0
c0de1a7e:	4611      	mov	r1, r2
        if (list->selectedChoice < (list->nbChoices - 1)) {
c0de1a80:	f1a0 0001 	sub.w	r0, r0, #1
        if (list->selectedChoice > 0) {
c0de1a84:	bf18      	it	ne
c0de1a86:	2101      	movne	r1, #1
        if (list->selectedChoice < (list->nbChoices - 1)) {
c0de1a88:	4290      	cmp	r0, r2
c0de1a8a:	bfc8      	it	gt
c0de1a8c:	3102      	addgt	r1, #2
c0de1a8e:	f88d 1003 	strb.w	r1, [sp, #3]
        if (navInfo.indication != NO_ARROWS) {
c0de1a92:	b121      	cbz	r1, c0de1a9e <displayMenuList+0x68>
            nbgl_layoutAddNavigation(ctx->layout, &navInfo);
c0de1a94:	6c20      	ldr	r0, [r4, #64]	@ 0x40
c0de1a96:	f10d 0102 	add.w	r1, sp, #2
c0de1a9a:	f7fe feeb 	bl	c0de0874 <nbgl_layoutAddNavigation>
    nbgl_layoutDraw(ctx->layout);
c0de1a9e:	6c20      	ldr	r0, [r4, #64]	@ 0x40
c0de1aa0:	f7ff fcd4 	bl	c0de144c <nbgl_layoutDraw>
    nbgl_refresh();
c0de1aa4:	f001 fb6b 	bl	c0de317e <nbgl_refresh>
}
c0de1aa8:	b006      	add	sp, #24
c0de1aaa:	bdb0      	pop	{r4, r5, r7, pc}

c0de1aac <nbgl_stepDrawSwitch>:
nbgl_step_t nbgl_stepDrawSwitch(nbgl_stepPosition_t               pos,
                                nbgl_stepButtonCallback_t         onActionCallback,
                                nbgl_screenTickerConfiguration_t *ticker,
                                nbgl_layoutSwitch_t              *switchInfo,
                                bool                              modal)
{
c0de1aac:	e92d 45f0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, lr}
c0de1ab0:	b087      	sub	sp, #28
c0de1ab2:	9e0e      	ldr	r6, [sp, #56]	@ 0x38
c0de1ab4:	4682      	mov	sl, r0
c0de1ab6:	2000      	movs	r0, #0
c0de1ab8:	460c      	mov	r4, r1
    nbgl_layoutDescription_t layoutDescription
c0de1aba:	9002      	str	r0, [sp, #8]
c0de1abc:	9006      	str	r0, [sp, #24]
c0de1abe:	e9cd 0004 	strd	r0, r0, [sp, #16]
        = {.modal = modal, .onActionCallback = (nbgl_layoutButtonCallback_t) actionCallback};
c0de1ac2:	f88d 6008 	strb.w	r6, [sp, #8]
c0de1ac6:	f64f 6117 	movw	r1, #65047	@ 0xfe17
c0de1aca:	f6cf 71ff 	movt	r1, #65535	@ 0xffff
    nbgl_layoutNavigation_t navInfo = {
c0de1ace:	f8ad 0006 	strh.w	r0, [sp, #6]
c0de1ad2:	f240 207c 	movw	r0, #636	@ 0x27c
c0de1ad6:	4698      	mov	r8, r3
c0de1ad8:	4617      	mov	r7, r2
        = {.modal = modal, .onActionCallback = (nbgl_layoutButtonCallback_t) actionCallback};
c0de1ada:	4479      	add	r1, pc
c0de1adc:	f2c0 0000 	movt	r0, #0
c0de1ae0:	9103      	str	r1, [sp, #12]
    if (!modal) {
c0de1ae2:	b176      	cbz	r6, c0de1b02 <nbgl_stepDrawSwitch+0x56>
c0de1ae4:	2100      	movs	r1, #0
c0de1ae6:	bf00      	nop
            if (contexts[i].layout == NULL) {
c0de1ae8:	eb09 0200 	add.w	r2, r9, r0
c0de1aec:	440a      	add	r2, r1
c0de1aee:	f8d2 2088 	ldr.w	r2, [r2, #136]	@ 0x88
c0de1af2:	2a00      	cmp	r2, #0
c0de1af4:	d06a      	beq.n	c0de1bcc <nbgl_stepDrawSwitch+0x120>
        while (i < NB_MAX_LAYERS) {
c0de1af6:	3148      	adds	r1, #72	@ 0x48
c0de1af8:	2990      	cmp	r1, #144	@ 0x90
c0de1afa:	d1f5      	bne.n	c0de1ae8 <nbgl_stepDrawSwitch+0x3c>
c0de1afc:	2500      	movs	r5, #0
    if (ctx == NULL) {
c0de1afe:	b925      	cbnz	r5, c0de1b0a <nbgl_stepDrawSwitch+0x5e>
c0de1b00:	e06a      	b.n	c0de1bd8 <nbgl_stepDrawSwitch+0x12c>
c0de1b02:	eb09 0500 	add.w	r5, r9, r0
c0de1b06:	2d00      	cmp	r5, #0
c0de1b08:	d066      	beq.n	c0de1bd8 <nbgl_stepDrawSwitch+0x12c>
        memset(ctx, 0, sizeof(StepContext_t));
c0de1b0a:	4628      	mov	r0, r5
c0de1b0c:	2148      	movs	r1, #72	@ 0x48
c0de1b0e:	f002 fc1b 	bl	c0de4348 <__aeabi_memclr>
c0de1b12:	f04f 0c01 	mov.w	ip, #1
        return NULL;
    }

    // initialize context (already set to 0 by getFreeContext())
    ctx->textContext.onActionCallback = onActionCallback;
    if (ticker) {
c0de1b16:	2f00      	cmp	r7, #0
        ctx->type  = type;
c0de1b18:	f885 c044 	strb.w	ip, [r5, #68]	@ 0x44
        ctx->modal = modal;
c0de1b1c:	f885 6045 	strb.w	r6, [r5, #69]	@ 0x45
    ctx->textContext.onActionCallback = onActionCallback;
c0de1b20:	616c      	str	r4, [r5, #20]
    if (ticker) {
c0de1b22:	d045      	beq.n	c0de1bb0 <nbgl_stepDrawSwitch+0x104>
        ctx->ticker.tickerCallback               = ticker->tickerCallback;
c0de1b24:	7839      	ldrb	r1, [r7, #0]
c0de1b26:	78ba      	ldrb	r2, [r7, #2]
c0de1b28:	78fb      	ldrb	r3, [r7, #3]
c0de1b2a:	787e      	ldrb	r6, [r7, #1]
c0de1b2c:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de1b30:	ea41 2106 	orr.w	r1, r1, r6, lsl #8
c0de1b34:	ea41 4102 	orr.w	r1, r1, r2, lsl #16
c0de1b38:	6369      	str	r1, [r5, #52]	@ 0x34
        ctx->ticker.tickerIntervale              = ticker->tickerIntervale;
c0de1b3a:	4639      	mov	r1, r7
c0de1b3c:	f811 2f08 	ldrb.w	r2, [r1, #8]!
c0de1b40:	7a7b      	ldrb	r3, [r7, #9]
c0de1b42:	788e      	ldrb	r6, [r1, #2]
c0de1b44:	78cc      	ldrb	r4, [r1, #3]
c0de1b46:	ea42 2203 	orr.w	r2, r2, r3, lsl #8
c0de1b4a:	ea46 2304 	orr.w	r3, r6, r4, lsl #8
c0de1b4e:	ea42 4203 	orr.w	r2, r2, r3, lsl #16
c0de1b52:	63ea      	str	r2, [r5, #60]	@ 0x3c
        ctx->ticker.tickerValue                  = ticker->tickerValue;
c0de1b54:	463a      	mov	r2, r7
c0de1b56:	f812 3f04 	ldrb.w	r3, [r2, #4]!
c0de1b5a:	797e      	ldrb	r6, [r7, #5]
c0de1b5c:	7894      	ldrb	r4, [r2, #2]
c0de1b5e:	78d0      	ldrb	r0, [r2, #3]
c0de1b60:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de1b64:	ea44 2000 	orr.w	r0, r4, r0, lsl #8
c0de1b68:	ea43 4000 	orr.w	r0, r3, r0, lsl #16
c0de1b6c:	63a8      	str	r0, [r5, #56]	@ 0x38
        layoutDescription.ticker.tickerCallback  = ticker->tickerCallback;
c0de1b6e:	7838      	ldrb	r0, [r7, #0]
c0de1b70:	78bb      	ldrb	r3, [r7, #2]
c0de1b72:	78fe      	ldrb	r6, [r7, #3]
c0de1b74:	787c      	ldrb	r4, [r7, #1]
c0de1b76:	ea43 2306 	orr.w	r3, r3, r6, lsl #8
c0de1b7a:	ea40 2004 	orr.w	r0, r0, r4, lsl #8
c0de1b7e:	ea40 4003 	orr.w	r0, r0, r3, lsl #16
c0de1b82:	9004      	str	r0, [sp, #16]
        layoutDescription.ticker.tickerIntervale = ticker->tickerIntervale;
c0de1b84:	7a78      	ldrb	r0, [r7, #9]
c0de1b86:	780b      	ldrb	r3, [r1, #0]
c0de1b88:	788e      	ldrb	r6, [r1, #2]
c0de1b8a:	78c9      	ldrb	r1, [r1, #3]
c0de1b8c:	ea43 2000 	orr.w	r0, r3, r0, lsl #8
c0de1b90:	ea46 2101 	orr.w	r1, r6, r1, lsl #8
c0de1b94:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de1b98:	9006      	str	r0, [sp, #24]
        layoutDescription.ticker.tickerValue     = ticker->tickerValue;
c0de1b9a:	7978      	ldrb	r0, [r7, #5]
c0de1b9c:	7811      	ldrb	r1, [r2, #0]
c0de1b9e:	7893      	ldrb	r3, [r2, #2]
c0de1ba0:	78d2      	ldrb	r2, [r2, #3]
c0de1ba2:	ea41 2000 	orr.w	r0, r1, r0, lsl #8
c0de1ba6:	ea43 2102 	orr.w	r1, r3, r2, lsl #8
c0de1baa:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
c0de1bae:	9005      	str	r0, [sp, #20]
    if (pos == FIRST_STEP) {
c0de1bb0:	f00a 0003 	and.w	r0, sl, #3
c0de1bb4:	2803      	cmp	r0, #3
    }

    ctx->textContext.nbPages = 1;
c0de1bb6:	f885 c000 	strb.w	ip, [r5]
    // keep only direction part of position
    ctx->textContext.pos = pos & (RIGHT_ARROW | LEFT_ARROW);
c0de1bba:	7428      	strb	r0, [r5, #16]
    if (pos == FIRST_STEP) {
c0de1bbc:	d00e      	beq.n	c0de1bdc <nbgl_stepDrawSwitch+0x130>
c0de1bbe:	2802      	cmp	r0, #2
c0de1bc0:	d00e      	beq.n	c0de1be0 <nbgl_stepDrawSwitch+0x134>
c0de1bc2:	2801      	cmp	r0, #1
c0de1bc4:	bf0c      	ite	eq
c0de1bc6:	2002      	moveq	r0, #2
c0de1bc8:	2000      	movne	r0, #0
c0de1bca:	e00a      	b.n	c0de1be2 <nbgl_stepDrawSwitch+0x136>
                break;
c0de1bcc:	4448      	add	r0, r9
c0de1bce:	4408      	add	r0, r1
c0de1bd0:	f100 0548 	add.w	r5, r0, #72	@ 0x48
    if (ctx == NULL) {
c0de1bd4:	2d00      	cmp	r5, #0
c0de1bd6:	d198      	bne.n	c0de1b0a <nbgl_stepDrawSwitch+0x5e>
c0de1bd8:	2500      	movs	r5, #0
c0de1bda:	e018      	b.n	c0de1c0e <nbgl_stepDrawSwitch+0x162>
c0de1bdc:	2003      	movs	r0, #3
c0de1bde:	e000      	b.n	c0de1be2 <nbgl_stepDrawSwitch+0x136>
c0de1be0:	2001      	movs	r0, #1
    navInfo.indication   = getNavigationInfo(
c0de1be2:	f88d 0007 	strb.w	r0, [sp, #7]
c0de1be6:	a802      	add	r0, sp, #8
        ctx->textContext.pos, ctx->textContext.nbPages, ctx->textContext.currentPage);

    ctx->layout = nbgl_layoutGet(&layoutDescription);
c0de1be8:	f7fe fdd2 	bl	c0de0790 <nbgl_layoutGet>
    nbgl_layoutAddSwitch(ctx->layout, switchInfo);
c0de1bec:	4641      	mov	r1, r8
    ctx->layout = nbgl_layoutGet(&layoutDescription);
c0de1bee:	6428      	str	r0, [r5, #64]	@ 0x40
    nbgl_layoutAddSwitch(ctx->layout, switchInfo);
c0de1bf0:	f7ff fb30 	bl	c0de1254 <nbgl_layoutAddSwitch>
    if (navInfo.indication != NO_ARROWS) {
c0de1bf4:	f89d 0007 	ldrb.w	r0, [sp, #7]
c0de1bf8:	b120      	cbz	r0, c0de1c04 <nbgl_stepDrawSwitch+0x158>
        nbgl_layoutAddNavigation(ctx->layout, &navInfo);
c0de1bfa:	6c28      	ldr	r0, [r5, #64]	@ 0x40
c0de1bfc:	f10d 0106 	add.w	r1, sp, #6
c0de1c00:	f7fe fe38 	bl	c0de0874 <nbgl_layoutAddNavigation>
    }
    nbgl_layoutDraw(ctx->layout);
c0de1c04:	6c28      	ldr	r0, [r5, #64]	@ 0x40
c0de1c06:	f7ff fc21 	bl	c0de144c <nbgl_layoutDraw>
    nbgl_refresh();
c0de1c0a:	f001 fab8 	bl	c0de317e <nbgl_refresh>

    LOG_DEBUG(STEP_LOGGER, "nbgl_stepDrawSwitch(): ctx = %p\n", ctx);
    return (nbgl_step_t) ctx;
}
c0de1c0e:	4628      	mov	r0, r5
c0de1c10:	b007      	add	sp, #28
c0de1c12:	e8bd 85f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, pc}

c0de1c16 <nbgl_stepRelease>:
{
    StepContext_t *ctx = (StepContext_t *) step;
    int            ret;

    LOG_DEBUG(STEP_LOGGER, "nbgl_stepRelease(): ctx = %p\n", ctx);
    if (!ctx) {
c0de1c16:	2800      	cmp	r0, #0
c0de1c18:	bf04      	itt	eq
c0de1c1a:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
    ret = nbgl_layoutRelease((nbgl_layout_t *) ctx->layout);

    ctx->layout = NULL;

    return ret;
}
c0de1c1e:	4770      	bxeq	lr
c0de1c20:	b510      	push	{r4, lr}
c0de1c22:	4604      	mov	r4, r0
    ret = nbgl_layoutRelease((nbgl_layout_t *) ctx->layout);
c0de1c24:	6c00      	ldr	r0, [r0, #64]	@ 0x40
c0de1c26:	f7ff fc1b 	bl	c0de1460 <nbgl_layoutRelease>
c0de1c2a:	2100      	movs	r1, #0
    ctx->layout = NULL;
c0de1c2c:	6421      	str	r1, [r4, #64]	@ 0x40
c0de1c2e:	bd10      	pop	{r4, pc}

c0de1c30 <menuListActionCallback>:
{
c0de1c30:	b580      	push	{r7, lr}
c0de1c32:	f240 2c7c 	movw	ip, #636	@ 0x27c
c0de1c36:	2200      	movs	r2, #0
c0de1c38:	f2c0 0c00 	movt	ip, #0
        if (contexts[i].layout == layout) {
c0de1c3c:	eb09 030c 	add.w	r3, r9, ip
c0de1c40:	4413      	add	r3, r2
c0de1c42:	6c1b      	ldr	r3, [r3, #64]	@ 0x40
c0de1c44:	4283      	cmp	r3, r0
c0de1c46:	d005      	beq.n	c0de1c54 <menuListActionCallback+0x24>
    while (i < NB_MAX_LAYERS) {
c0de1c48:	3248      	adds	r2, #72	@ 0x48
c0de1c4a:	2ad8      	cmp	r2, #216	@ 0xd8
c0de1c4c:	d1f6      	bne.n	c0de1c3c <menuListActionCallback+0xc>
c0de1c4e:	2000      	movs	r0, #0
    if (!ctx) {
c0de1c50:	b928      	cbnz	r0, c0de1c5e <menuListActionCallback+0x2e>
}
c0de1c52:	bd80      	pop	{r7, pc}
            break;
c0de1c54:	eb09 000c 	add.w	r0, r9, ip
c0de1c58:	4410      	add	r0, r2
    if (!ctx) {
c0de1c5a:	2800      	cmp	r0, #0
c0de1c5c:	d0f9      	beq.n	c0de1c52 <menuListActionCallback+0x22>
    if (event == BUTTON_LEFT_PRESSED) {
c0de1c5e:	2904      	cmp	r1, #4
c0de1c60:	d008      	beq.n	c0de1c74 <menuListActionCallback+0x44>
c0de1c62:	2901      	cmp	r1, #1
c0de1c64:	d00a      	beq.n	c0de1c7c <menuListActionCallback+0x4c>
c0de1c66:	2900      	cmp	r1, #0
c0de1c68:	d1f3      	bne.n	c0de1c52 <menuListActionCallback+0x22>
        if (ctx->menuListContext.list.selectedChoice > 0) {
c0de1c6a:	7a41      	ldrb	r1, [r0, #9]
c0de1c6c:	2900      	cmp	r1, #0
c0de1c6e:	d0f0      	beq.n	c0de1c52 <menuListActionCallback+0x22>
            ctx->menuListContext.list.selectedChoice--;
c0de1c70:	3901      	subs	r1, #1
c0de1c72:	e00a      	b.n	c0de1c8a <menuListActionCallback+0x5a>
        ctx->menuListContext.selectedCallback(ctx->menuListContext.list.selectedChoice);
c0de1c74:	6801      	ldr	r1, [r0, #0]
c0de1c76:	7a40      	ldrb	r0, [r0, #9]
c0de1c78:	4788      	blx	r1
}
c0de1c7a:	bd80      	pop	{r7, pc}
        if (ctx->menuListContext.list.selectedChoice < (ctx->menuListContext.list.nbChoices - 1)) {
c0de1c7c:	7a02      	ldrb	r2, [r0, #8]
c0de1c7e:	7a41      	ldrb	r1, [r0, #9]
c0de1c80:	3a01      	subs	r2, #1
c0de1c82:	428a      	cmp	r2, r1
}
c0de1c84:	bfd8      	it	le
c0de1c86:	bd80      	pople	{r7, pc}
            ctx->menuListContext.list.selectedChoice++;
c0de1c88:	3101      	adds	r1, #1
c0de1c8a:	7241      	strb	r1, [r0, #9]
c0de1c8c:	f7ff fed3 	bl	c0de1a36 <displayMenuList>
}
c0de1c90:	bd80      	pop	{r7, pc}

c0de1c92 <nbgl_useCaseHomeAndSettings>:
                                 const uint8_t                 initSettingPage,
                                 const nbgl_genericContents_t *settingContents,
                                 const nbgl_contentInfoList_t *infosList,
                                 const nbgl_homeAction_t      *action,
                                 nbgl_callback_t               quitCallback)
{
c0de1c92:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de1c96:	4605      	mov	r5, r0
    memset(&context, 0, sizeof(UseCaseContext_t));
c0de1c98:	f240 3054 	movw	r0, #852	@ 0x354
c0de1c9c:	f2c0 0000 	movt	r0, #0
c0de1ca0:	eb09 0400 	add.w	r4, r9, r0
c0de1ca4:	460f      	mov	r7, r1
c0de1ca6:	e9dd 8a08 	ldrd	r8, sl, [sp, #32]
c0de1caa:	4620      	mov	r0, r4
c0de1cac:	2140      	movs	r1, #64	@ 0x40
c0de1cae:	469b      	mov	fp, r3
c0de1cb0:	4616      	mov	r6, r2
c0de1cb2:	f002 fb49 	bl	c0de4348 <__aeabi_memclr>
    context.home.appName         = appName;
    context.home.appIcon         = appIcon;
    context.home.tagline         = tagline;
    context.home.settingContents = PIC(settingContents);
c0de1cb6:	4640      	mov	r0, r8
    context.home.appName         = appName;
c0de1cb8:	e9c4 5704 	strd	r5, r7, [r4, #16]
    context.home.tagline         = tagline;
c0de1cbc:	61a6      	str	r6, [r4, #24]
    context.home.settingContents = PIC(settingContents);
c0de1cbe:	f002 f973 	bl	c0de3fa8 <pic>
c0de1cc2:	61e0      	str	r0, [r4, #28]
    context.home.infosList       = PIC(infosList);
c0de1cc4:	4650      	mov	r0, sl
c0de1cc6:	f002 f96f 	bl	c0de3fa8 <pic>
c0de1cca:	9e0a      	ldr	r6, [sp, #40]	@ 0x28
    context.home.homeAction      = action;
    context.home.quitCallback    = quitCallback;

    if ((initSettingPage != INIT_HOME_PAGE) && (settingContents != NULL)) {
c0de1ccc:	f1bb 0fff 	cmp.w	fp, #255	@ 0xff
    context.home.infosList       = PIC(infosList);
c0de1cd0:	e9c4 0608 	strd	r0, r6, [r4, #32]
    context.home.quitCallback    = quitCallback;
c0de1cd4:	980b      	ldr	r0, [sp, #44]	@ 0x2c
c0de1cd6:	62a0      	str	r0, [r4, #40]	@ 0x28
    if ((initSettingPage != INIT_HOME_PAGE) && (settingContents != NULL)) {
c0de1cd8:	bf18      	it	ne
c0de1cda:	f1b8 0f00 	cmpne.w	r8, #0
c0de1cde:	d10e      	bne.n	c0de1cfe <nbgl_useCaseHomeAndSettings+0x6c>
c0de1ce0:	f240 3754 	movw	r7, #852	@ 0x354
c0de1ce4:	f2c0 0700 	movt	r7, #0
    switch (context.type) {
c0de1ce8:	f819 0007 	ldrb.w	r0, [r9, r7]
c0de1cec:	280e      	cmp	r0, #14
c0de1cee:	d00b      	beq.n	c0de1d08 <nbgl_useCaseHomeAndSettings+0x76>
c0de1cf0:	280f      	cmp	r0, #15
c0de1cf2:	d114      	bne.n	c0de1d1e <nbgl_useCaseHomeAndSettings+0x8c>
c0de1cf4:	2002      	movs	r0, #2
            if (context.home.homeAction) {
c0de1cf6:	2e00      	cmp	r6, #0
c0de1cf8:	bf08      	it	eq
c0de1cfa:	2001      	moveq	r0, #1
c0de1cfc:	e010      	b.n	c0de1d20 <nbgl_useCaseHomeAndSettings+0x8e>
        startUseCaseSettingsAtPage(initSettingPage);
c0de1cfe:	4658      	mov	r0, fp
c0de1d00:	f000 f82e 	bl	c0de1d60 <startUseCaseSettingsAtPage>
    }
    else {
        startUseCaseHome();
    }
}
c0de1d04:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de1d08:	eb09 0107 	add.w	r1, r9, r7
            if (context.home.settingContents) {
c0de1d0c:	69ca      	ldr	r2, [r1, #28]
c0de1d0e:	2002      	movs	r0, #2
            if (context.home.homeAction) {
c0de1d10:	2e00      	cmp	r6, #0
c0de1d12:	bf08      	it	eq
c0de1d14:	2001      	moveq	r0, #1
c0de1d16:	7248      	strb	r0, [r1, #9]
            if (context.home.settingContents) {
c0de1d18:	b12a      	cbz	r2, c0de1d26 <nbgl_useCaseHomeAndSettings+0x94>
                context.currentPage++;
c0de1d1a:	3001      	adds	r0, #1
c0de1d1c:	e000      	b.n	c0de1d20 <nbgl_useCaseHomeAndSettings+0x8e>
c0de1d1e:	2000      	movs	r0, #0
c0de1d20:	eb09 0107 	add.w	r1, r9, r7
c0de1d24:	7248      	strb	r0, [r1, #9]
    context.type    = HOME_USE_CASE;
c0de1d26:	eb09 0107 	add.w	r1, r9, r7
    if (context.home.settingContents) {
c0de1d2a:	e9d1 2307 	ldrd	r2, r3, [r1, #28]
c0de1d2e:	200d      	movs	r0, #13
    context.type    = HOME_USE_CASE;
c0de1d30:	f809 0007 	strb.w	r0, [r9, r7]
c0de1d34:	2003      	movs	r0, #3
    if (context.home.settingContents) {
c0de1d36:	2a00      	cmp	r2, #0
c0de1d38:	bf08      	it	eq
c0de1d3a:	2002      	moveq	r0, #2
    if (context.home.infosList) {
c0de1d3c:	2b00      	cmp	r3, #0
c0de1d3e:	7208      	strb	r0, [r1, #8]
        context.nbPages++;
c0de1d40:	bf1e      	ittt	ne
c0de1d42:	3001      	addne	r0, #1
c0de1d44:	eb09 0107 	addne.w	r1, r9, r7
c0de1d48:	7208      	strbne	r0, [r1, #8]
    if (context.home.homeAction) {
c0de1d4a:	b126      	cbz	r6, c0de1d56 <nbgl_useCaseHomeAndSettings+0xc4>
        context.nbPages++;
c0de1d4c:	eb09 0007 	add.w	r0, r9, r7
c0de1d50:	7a01      	ldrb	r1, [r0, #8]
c0de1d52:	3101      	adds	r1, #1
c0de1d54:	7201      	strb	r1, [r0, #8]
    displayHomePage(FORWARD_DIRECTION);
c0de1d56:	2000      	movs	r0, #0
c0de1d58:	f000 fde1 	bl	c0de291e <displayHomePage>
}
c0de1d5c:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de1d60 <startUseCaseSettingsAtPage>:
{
c0de1d60:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de1d62:	b08f      	sub	sp, #60	@ 0x3c
c0de1d64:	4604      	mov	r4, r0
c0de1d66:	a801      	add	r0, sp, #4
    nbgl_content_t        content   = {0};
c0de1d68:	2138      	movs	r1, #56	@ 0x38
c0de1d6a:	f002 faed 	bl	c0de4348 <__aeabi_memclr>
    if (context.type != GENERIC_SETTINGS) {
c0de1d6e:	f240 3654 	movw	r6, #852	@ 0x354
c0de1d72:	f2c0 0600 	movt	r6, #0
c0de1d76:	f819 0006 	ldrb.w	r0, [r9, r6]
    context.nbPages = 1;  // For back screen
c0de1d7a:	eb09 0106 	add.w	r1, r9, r6
    if (context.type != GENERIC_SETTINGS) {
c0de1d7e:	2810      	cmp	r0, #16
c0de1d80:	bf1c      	itt	ne
c0de1d82:	200f      	movne	r0, #15
        context.type = SETTINGS_USE_CASE;
c0de1d84:	f809 0006 	strbne.w	r0, [r9, r6]
c0de1d88:	2201      	movs	r2, #1
    for (uint i = 0; i < context.home.settingContents->nbContents; i++) {
c0de1d8a:	69c8      	ldr	r0, [r1, #28]
    context.nbPages = 1;  // For back screen
c0de1d8c:	720a      	strb	r2, [r1, #8]
    for (uint i = 0; i < context.home.settingContents->nbContents; i++) {
c0de1d8e:	7a01      	ldrb	r1, [r0, #8]
c0de1d90:	b3b9      	cbz	r1, c0de1e02 <startUseCaseSettingsAtPage+0xa2>
c0de1d92:	2700      	movs	r7, #0
c0de1d94:	ad01      	add	r5, sp, #4
c0de1d96:	e00e      	b.n	c0de1db6 <startUseCaseSettingsAtPage+0x56>
    switch (content->type) {
c0de1d98:	2909      	cmp	r1, #9
c0de1d9a:	d02c      	beq.n	c0de1df6 <startUseCaseSettingsAtPage+0x96>
c0de1d9c:	290a      	cmp	r1, #10
c0de1d9e:	d12e      	bne.n	c0de1dfe <startUseCaseSettingsAtPage+0x9e>
c0de1da0:	7b00      	ldrb	r0, [r0, #12]
        context.nbPages += getContentNbElement(p_content);
c0de1da2:	eb09 0106 	add.w	r1, r9, r6
c0de1da6:	7a0a      	ldrb	r2, [r1, #8]
    for (uint i = 0; i < context.home.settingContents->nbContents; i++) {
c0de1da8:	3701      	adds	r7, #1
        context.nbPages += getContentNbElement(p_content);
c0de1daa:	4402      	add	r2, r0
    for (uint i = 0; i < context.home.settingContents->nbContents; i++) {
c0de1dac:	69c8      	ldr	r0, [r1, #28]
        context.nbPages += getContentNbElement(p_content);
c0de1dae:	720a      	strb	r2, [r1, #8]
    for (uint i = 0; i < context.home.settingContents->nbContents; i++) {
c0de1db0:	7a01      	ldrb	r1, [r0, #8]
c0de1db2:	428f      	cmp	r7, r1
c0de1db4:	d225      	bcs.n	c0de1e02 <startUseCaseSettingsAtPage+0xa2>
        p_content = getContentAtIdx(context.home.settingContents, i, &content);
c0de1db6:	b2f9      	uxtb	r1, r7
c0de1db8:	462a      	mov	r2, r5
c0de1dba:	f000 f9e2 	bl	c0de2182 <getContentAtIdx>
    switch (content->type) {
c0de1dbe:	7801      	ldrb	r1, [r0, #0]
c0de1dc0:	2906      	cmp	r1, #6
c0de1dc2:	dc09      	bgt.n	c0de1dd8 <startUseCaseSettingsAtPage+0x78>
c0de1dc4:	2903      	cmp	r1, #3
c0de1dc6:	dc0f      	bgt.n	c0de1de8 <startUseCaseSettingsAtPage+0x88>
c0de1dc8:	2900      	cmp	r1, #0
c0de1dca:	f04f 0001 	mov.w	r0, #1
c0de1dce:	d0e8      	beq.n	c0de1da2 <startUseCaseSettingsAtPage+0x42>
c0de1dd0:	2903      	cmp	r1, #3
c0de1dd2:	bf18      	it	ne
c0de1dd4:	2000      	movne	r0, #0
c0de1dd6:	e7e4      	b.n	c0de1da2 <startUseCaseSettingsAtPage+0x42>
c0de1dd8:	2908      	cmp	r1, #8
c0de1dda:	dcdd      	bgt.n	c0de1d98 <startUseCaseSettingsAtPage+0x38>
c0de1ddc:	2907      	cmp	r1, #7
c0de1dde:	d00c      	beq.n	c0de1dfa <startUseCaseSettingsAtPage+0x9a>
c0de1de0:	2908      	cmp	r1, #8
c0de1de2:	d10c      	bne.n	c0de1dfe <startUseCaseSettingsAtPage+0x9e>
            return content->content.infosList.nbInfos;
c0de1de4:	7c00      	ldrb	r0, [r0, #16]
c0de1de6:	e7dc      	b.n	c0de1da2 <startUseCaseSettingsAtPage+0x42>
    switch (content->type) {
c0de1de8:	2904      	cmp	r1, #4
c0de1dea:	d0d9      	beq.n	c0de1da0 <startUseCaseSettingsAtPage+0x40>
c0de1dec:	2906      	cmp	r1, #6
c0de1dee:	d106      	bne.n	c0de1dfe <startUseCaseSettingsAtPage+0x9e>
            return content->content.tagValueConfirm.tagValueList.nbPairs + 1;
c0de1df0:	7b00      	ldrb	r0, [r0, #12]
c0de1df2:	3001      	adds	r0, #1
c0de1df4:	e7d5      	b.n	c0de1da2 <startUseCaseSettingsAtPage+0x42>
            return content->content.choicesList.nbChoices;
c0de1df6:	7a40      	ldrb	r0, [r0, #9]
c0de1df8:	e7d3      	b.n	c0de1da2 <startUseCaseSettingsAtPage+0x42>
            return content->content.switchesList.nbSwitches;
c0de1dfa:	7a00      	ldrb	r0, [r0, #8]
c0de1dfc:	e7d1      	b.n	c0de1da2 <startUseCaseSettingsAtPage+0x42>
c0de1dfe:	2000      	movs	r0, #0
c0de1e00:	e7cf      	b.n	c0de1da2 <startUseCaseSettingsAtPage+0x42>
    context.currentPage = initSettingPage;
c0de1e02:	eb09 0006 	add.w	r0, r9, r6
c0de1e06:	7244      	strb	r4, [r0, #9]
    displaySettingsPage(FORWARD_DIRECTION, false);
c0de1e08:	2000      	movs	r0, #0
c0de1e0a:	2100      	movs	r1, #0
c0de1e0c:	f000 fc57 	bl	c0de26be <displaySettingsPage>
}
c0de1e10:	b00f      	add	sp, #60	@ 0x3c
c0de1e12:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de1e14 <startUseCaseHome>:
{
c0de1e14:	b580      	push	{r7, lr}
    switch (context.type) {
c0de1e16:	f240 3e54 	movw	lr, #852	@ 0x354
c0de1e1a:	f2c0 0e00 	movt	lr, #0
c0de1e1e:	f819 100e 	ldrb.w	r1, [r9, lr]
c0de1e22:	290e      	cmp	r1, #14
c0de1e24:	d00b      	beq.n	c0de1e3e <startUseCaseHome+0x2a>
c0de1e26:	290f      	cmp	r1, #15
c0de1e28:	d118      	bne.n	c0de1e5c <startUseCaseHome+0x48>
            context.currentPage = 1;
c0de1e2a:	eb09 010e 	add.w	r1, r9, lr
c0de1e2e:	2201      	movs	r2, #1
c0de1e30:	724a      	strb	r2, [r1, #9]
            if (context.home.homeAction) {
c0de1e32:	6a4a      	ldr	r2, [r1, #36]	@ 0x24
c0de1e34:	2102      	movs	r1, #2
c0de1e36:	2a00      	cmp	r2, #0
c0de1e38:	bf08      	it	eq
c0de1e3a:	2101      	moveq	r1, #1
c0de1e3c:	e00f      	b.n	c0de1e5e <startUseCaseHome+0x4a>
            context.currentPage = 1;
c0de1e3e:	eb09 020e 	add.w	r2, r9, lr
            if (context.home.homeAction) {
c0de1e42:	6a53      	ldr	r3, [r2, #36]	@ 0x24
            if (context.home.settingContents) {
c0de1e44:	f8d2 c01c 	ldr.w	ip, [r2, #28]
c0de1e48:	2102      	movs	r1, #2
            if (context.home.homeAction) {
c0de1e4a:	2b00      	cmp	r3, #0
c0de1e4c:	bf08      	it	eq
c0de1e4e:	2101      	moveq	r1, #1
            if (context.home.settingContents) {
c0de1e50:	f1bc 0f00 	cmp.w	ip, #0
c0de1e54:	7251      	strb	r1, [r2, #9]
c0de1e56:	d005      	beq.n	c0de1e64 <startUseCaseHome+0x50>
                context.currentPage++;
c0de1e58:	3101      	adds	r1, #1
c0de1e5a:	e000      	b.n	c0de1e5e <startUseCaseHome+0x4a>
c0de1e5c:	2100      	movs	r1, #0
c0de1e5e:	eb09 020e 	add.w	r2, r9, lr
c0de1e62:	7251      	strb	r1, [r2, #9]
    context.type    = HOME_USE_CASE;
c0de1e64:	eb09 020e 	add.w	r2, r9, lr
c0de1e68:	210d      	movs	r1, #13
    if (context.home.settingContents) {
c0de1e6a:	e9d2 3007 	ldrd	r3, r0, [r2, #28]
    context.type    = HOME_USE_CASE;
c0de1e6e:	f809 100e 	strb.w	r1, [r9, lr]
c0de1e72:	2103      	movs	r1, #3
    if (context.home.settingContents) {
c0de1e74:	2b00      	cmp	r3, #0
c0de1e76:	bf08      	it	eq
c0de1e78:	2102      	moveq	r1, #2
    if (context.home.infosList) {
c0de1e7a:	2800      	cmp	r0, #0
c0de1e7c:	7211      	strb	r1, [r2, #8]
        context.nbPages++;
c0de1e7e:	bf1e      	ittt	ne
c0de1e80:	1c48      	addne	r0, r1, #1
c0de1e82:	eb09 010e 	addne.w	r1, r9, lr
c0de1e86:	7208      	strbne	r0, [r1, #8]
    if (context.home.homeAction) {
c0de1e88:	eb09 000e 	add.w	r0, r9, lr
c0de1e8c:	6a40      	ldr	r0, [r0, #36]	@ 0x24
c0de1e8e:	b120      	cbz	r0, c0de1e9a <startUseCaseHome+0x86>
        context.nbPages++;
c0de1e90:	eb09 000e 	add.w	r0, r9, lr
c0de1e94:	7a01      	ldrb	r1, [r0, #8]
c0de1e96:	3101      	adds	r1, #1
c0de1e98:	7201      	strb	r1, [r0, #8]
    displayHomePage(FORWARD_DIRECTION);
c0de1e9a:	2000      	movs	r0, #0
c0de1e9c:	f000 fd3f 	bl	c0de291e <displayHomePage>
}
c0de1ea0:	bd80      	pop	{r7, pc}

c0de1ea2 <drawStep>:
{
c0de1ea2:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de1ea6:	b09a      	sub	sp, #104	@ 0x68
c0de1ea8:	468a      	mov	sl, r1
c0de1eaa:	4606      	mov	r6, r0
c0de1eac:	a80c      	add	r0, sp, #48	@ 0x30
    nbgl_content_t                    content        = {0};
c0de1eae:	2138      	movs	r1, #56	@ 0x38
c0de1eb0:	4698      	mov	r8, r3
c0de1eb2:	4617      	mov	r7, r2
c0de1eb4:	f002 fa48 	bl	c0de4348 <__aeabi_memclr>
c0de1eb8:	2400      	movs	r4, #0
    nbgl_layoutMenuList_t             list           = {0};
c0de1eba:	e9cd 440a 	strd	r4, r4, [sp, #40]	@ 0x28
    nbgl_screenTickerConfiguration_t  ticker         = {.tickerCallback  = PIC(statusTickerCallback),
c0de1ebe:	f640 407b 	movw	r0, #3195	@ 0xc7b
c0de1ec2:	f2c0 0000 	movt	r0, #0
c0de1ec6:	4478      	add	r0, pc
c0de1ec8:	f002 f86e 	bl	c0de3fa8 <pic>
    pos |= GET_POS_OF_STEP(context.currentPage, context.nbPages);
c0de1ecc:	f240 3b54 	movw	fp, #852	@ 0x354
    nbgl_screenTickerConfiguration_t  ticker         = {.tickerCallback  = PIC(statusTickerCallback),
c0de1ed0:	9007      	str	r0, [sp, #28]
c0de1ed2:	f640 30b8 	movw	r0, #3000	@ 0xbb8
    pos |= GET_POS_OF_STEP(context.currentPage, context.nbPages);
c0de1ed6:	f2c0 0b00 	movt	fp, #0
    nbgl_screenTickerConfiguration_t  ticker         = {.tickerCallback  = PIC(statusTickerCallback),
c0de1eda:	9008      	str	r0, [sp, #32]
    pos |= GET_POS_OF_STEP(context.currentPage, context.nbPages);
c0de1edc:	eb09 000b 	add.w	r0, r9, fp
c0de1ee0:	7a01      	ldrb	r1, [r0, #8]
c0de1ee2:	2000      	movs	r0, #0
c0de1ee4:	2902      	cmp	r1, #2
    nbgl_screenTickerConfiguration_t  ticker         = {.tickerCallback  = PIC(statusTickerCallback),
c0de1ee6:	9409      	str	r4, [sp, #36]	@ 0x24
    pos |= GET_POS_OF_STEP(context.currentPage, context.nbPages);
c0de1ee8:	d30a      	bcc.n	c0de1f00 <drawStep+0x5e>
c0de1eea:	eb09 000b 	add.w	r0, r9, fp
c0de1eee:	7a42      	ldrb	r2, [r0, #9]
c0de1ef0:	b12a      	cbz	r2, c0de1efe <drawStep+0x5c>
c0de1ef2:	3901      	subs	r1, #1
c0de1ef4:	2003      	movs	r0, #3
c0de1ef6:	4291      	cmp	r1, r2
c0de1ef8:	bf08      	it	eq
c0de1efa:	2002      	moveq	r0, #2
c0de1efc:	e000      	b.n	c0de1f00 <drawStep+0x5e>
c0de1efe:	2001      	movs	r0, #1
c0de1f00:	ea40 0106 	orr.w	r1, r0, r6
    if ((context.type == STREAMING_CONTINUE_REVIEW_USE_CASE)
c0de1f04:	eb09 000b 	add.w	r0, r9, fp
c0de1f08:	f890 3030 	ldrb.w	r3, [r0, #48]	@ 0x30
c0de1f0c:	6ac5      	ldr	r5, [r0, #44]	@ 0x2c
        && (context.review.skipCallback != NULL) && (context.review.nbDataSets > 1)) {
c0de1f0e:	460e      	mov	r6, r1
    if ((context.type == STREAMING_CONTINUE_REVIEW_USE_CASE)
c0de1f10:	f819 200b 	ldrb.w	r2, [r9, fp]
        && (context.review.skipCallback != NULL) && (context.review.nbDataSets > 1)) {
c0de1f14:	2b01      	cmp	r3, #1
c0de1f16:	bf88      	it	hi
c0de1f18:	f046 0602 	orrhi.w	r6, r6, #2
c0de1f1c:	2d00      	cmp	r5, #0
c0de1f1e:	bf08      	it	eq
c0de1f20:	460e      	moveq	r6, r1
c0de1f22:	2a06      	cmp	r2, #6
c0de1f24:	bf18      	it	ne
c0de1f26:	460e      	movne	r6, r1
    if ((context.type == STATUS_USE_CASE) || (context.type == SPINNER_USE_CASE)) {
c0de1f28:	f002 01f7 	and.w	r1, r2, #247	@ 0xf7
c0de1f2c:	2901      	cmp	r1, #1
c0de1f2e:	ab07      	add	r3, sp, #28
c0de1f30:	bf08      	it	eq
c0de1f32:	461c      	moveq	r4, r3
    if ((context.type == CONFIRM_USE_CASE) && (context.confirm.currentStep != NULL)) {
c0de1f34:	2a0a      	cmp	r2, #10
c0de1f36:	d103      	bne.n	c0de1f40 <drawStep+0x9e>
c0de1f38:	6a40      	ldr	r0, [r0, #36]	@ 0x24
c0de1f3a:	b108      	cbz	r0, c0de1f40 <drawStep+0x9e>
        nbgl_stepRelease(context.confirm.currentStep);
c0de1f3c:	f7ff fe6b 	bl	c0de1c16 <nbgl_stepRelease>
c0de1f40:	9d23      	ldr	r5, [sp, #140]	@ 0x8c
    if (txt == NULL) {
c0de1f42:	b1bf      	cbz	r7, c0de1f74 <drawStep+0xd2>
c0de1f44:	9922      	ldr	r1, [sp, #136]	@ 0x88
    else if ((icon == NULL) && (forcedType != FORCE_CENTERED_INFO)) {
c0de1f46:	f1ba 0f00 	cmp.w	sl, #0
c0de1f4a:	d12e      	bne.n	c0de1faa <drawStep+0x108>
c0de1f4c:	9824      	ldr	r0, [sp, #144]	@ 0x90
c0de1f4e:	2802      	cmp	r0, #2
c0de1f50:	d02b      	beq.n	c0de1faa <drawStep+0x108>
c0de1f52:	2201      	movs	r2, #1
        if (subTxt != NULL) {
c0de1f54:	2801      	cmp	r0, #1
c0de1f56:	bf08      	it	eq
c0de1f58:	2202      	moveq	r2, #2
c0de1f5a:	f1b8 0f00 	cmp.w	r8, #0
c0de1f5e:	bf08      	it	eq
c0de1f60:	4642      	moveq	r2, r8
        newStep = nbgl_stepDrawText(pos, onActionCallback, p_ticker, txt, subTxt, style, modal);
c0de1f62:	e9cd 8200 	strd	r8, r2, [sp]
c0de1f66:	4630      	mov	r0, r6
c0de1f68:	4622      	mov	r2, r4
c0de1f6a:	463b      	mov	r3, r7
c0de1f6c:	9502      	str	r5, [sp, #8]
c0de1f6e:	f7ff fa87 	bl	c0de1480 <nbgl_stepDrawText>
c0de1f72:	e04d      	b.n	c0de2010 <drawStep+0x16e>
        p_content = getContentElemAtIdx(context.currentPage, &elemIdx, &content);
c0de1f74:	eb09 000b 	add.w	r0, r9, fp
c0de1f78:	7a40      	ldrb	r0, [r0, #9]
c0de1f7a:	a903      	add	r1, sp, #12
c0de1f7c:	aa0c      	add	r2, sp, #48	@ 0x30
c0de1f7e:	f000 fadd 	bl	c0de253c <getContentElemAtIdx>
        if (p_content) {
c0de1f82:	b350      	cbz	r0, c0de1fda <drawStep+0x138>
            switch (p_content->type) {
c0de1f84:	7801      	ldrb	r1, [r0, #0]
c0de1f86:	462e      	mov	r6, r5
c0de1f88:	290a      	cmp	r1, #10
c0de1f8a:	f04f 0500 	mov.w	r5, #0
c0de1f8e:	d026      	beq.n	c0de1fde <drawStep+0x13c>
c0de1f90:	2909      	cmp	r1, #9
c0de1f92:	d13e      	bne.n	c0de2012 <drawStep+0x170>
                        = ((nbgl_contentRadioChoice_t *) PIC(&p_content->content.choicesList));
c0de1f94:	3004      	adds	r0, #4
c0de1f96:	f002 f807 	bl	c0de3fa8 <pic>
                    list.nbChoices      = contentChoices->nbChoices + 1;  // For Back button
c0de1f9a:	7941      	ldrb	r1, [r0, #5]
                    list.selectedChoice = contentChoices->initChoice;
c0de1f9c:	7980      	ldrb	r0, [r0, #6]
                    list.nbChoices      = contentChoices->nbChoices + 1;  // For Back button
c0de1f9e:	3101      	adds	r1, #1
c0de1fa0:	f88d 102c 	strb.w	r1, [sp, #44]	@ 0x2c
                    list.selectedChoice = contentChoices->initChoice;
c0de1fa4:	f88d 002d 	strb.w	r0, [sp, #45]	@ 0x2d
c0de1fa8:	e022      	b.n	c0de1ff0 <drawStep+0x14e>
        info.text1 = txt;
c0de1faa:	a803      	add	r0, sp, #12
c0de1fac:	e880 0580 	stmia.w	r0, {r7, r8, sl}
c0de1fb0:	2000      	movs	r0, #0
        info.onTop = false;
c0de1fb2:	f88d 0018 	strb.w	r0, [sp, #24]
c0de1fb6:	eb09 000b 	add.w	r0, r9, fp
c0de1fba:	68c2      	ldr	r2, [r0, #12]
c0de1fbc:	7ac0      	ldrb	r0, [r0, #11]
        if ((subTxt != NULL) || (context.stepCallback != NULL) || context.forceAction) {
c0de1fbe:	ea42 0208 	orr.w	r2, r2, r8
c0de1fc2:	4310      	orrs	r0, r2
c0de1fc4:	bf18      	it	ne
c0de1fc6:	2001      	movne	r0, #1
c0de1fc8:	f88d 0019 	strb.w	r0, [sp, #25]
c0de1fcc:	ab03      	add	r3, sp, #12
        newStep = nbgl_stepDrawCenteredInfo(pos, onActionCallback, p_ticker, &info, modal);
c0de1fce:	4630      	mov	r0, r6
c0de1fd0:	4622      	mov	r2, r4
c0de1fd2:	9500      	str	r5, [sp, #0]
c0de1fd4:	f7ff fbd8 	bl	c0de1788 <nbgl_stepDrawCenteredInfo>
c0de1fd8:	e01a      	b.n	c0de2010 <drawStep+0x16e>
c0de1fda:	2500      	movs	r5, #0
c0de1fdc:	e019      	b.n	c0de2012 <drawStep+0x170>
                    contentBars    = ((nbgl_contentBarsList_t *) PIC(&p_content->content.barsList));
c0de1fde:	3004      	adds	r0, #4
c0de1fe0:	f001 ffe2 	bl	c0de3fa8 <pic>
                    list.nbChoices = contentBars->nbBars + 1;  // For Back button
c0de1fe4:	7a00      	ldrb	r0, [r0, #8]
                    list.selectedChoice = 0;
c0de1fe6:	f88d 502d 	strb.w	r5, [sp, #45]	@ 0x2d
                    list.nbChoices = contentBars->nbBars + 1;  // For Back button
c0de1fea:	3001      	adds	r0, #1
c0de1fec:	f88d 002c 	strb.w	r0, [sp, #44]	@ 0x2c
c0de1ff0:	f640 305f 	movw	r0, #2911	@ 0xb5f
c0de1ff4:	f2c0 0000 	movt	r0, #0
c0de1ff8:	4478      	add	r0, pc
c0de1ffa:	900a      	str	r0, [sp, #40]	@ 0x28
c0de1ffc:	f640 30c9 	movw	r0, #3017	@ 0xbc9
c0de2000:	f2c0 0000 	movt	r0, #0
c0de2004:	4478      	add	r0, pc
c0de2006:	aa0a      	add	r2, sp, #40	@ 0x28
c0de2008:	4621      	mov	r1, r4
c0de200a:	4633      	mov	r3, r6
c0de200c:	f7ff fcb2 	bl	c0de1974 <nbgl_stepDrawMenuList>
c0de2010:	4605      	mov	r5, r0
    if (context.type == CONFIRM_USE_CASE) {
c0de2012:	f819 000b 	ldrb.w	r0, [r9, fp]
c0de2016:	280a      	cmp	r0, #10
        context.confirm.currentStep = newStep;
c0de2018:	bf04      	itt	eq
c0de201a:	eb09 000b 	addeq.w	r0, r9, fp
c0de201e:	6245      	streq	r5, [r0, #36]	@ 0x24
}
c0de2020:	b01a      	add	sp, #104	@ 0x68
c0de2022:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de2026 <nbgl_useCaseChoice>:
                        const char                *message,
                        const char                *subMessage,
                        const char                *confirmText,
                        const char                *cancelText,
                        nbgl_choiceCallback_t      callback)
{
c0de2026:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
                                   const char                *confirmText,
                                   const char                *cancelText,
                                   nbgl_genericDetails_t     *details,
                                   nbgl_choiceCallback_t      callback)
{
    memset(&context, 0, sizeof(UseCaseContext_t));
c0de202a:	f240 3a54 	movw	sl, #852	@ 0x354
c0de202e:	f2c0 0a00 	movt	sl, #0
c0de2032:	eb09 050a 	add.w	r5, r9, sl
c0de2036:	460c      	mov	r4, r1
c0de2038:	4606      	mov	r6, r0
c0de203a:	f8dd b020 	ldr.w	fp, [sp, #32]
c0de203e:	4628      	mov	r0, r5
c0de2040:	2140      	movs	r1, #64	@ 0x40
c0de2042:	4698      	mov	r8, r3
c0de2044:	4617      	mov	r7, r2
c0de2046:	f002 f97f 	bl	c0de4348 <__aeabi_memclr>
    context.type               = CHOICE_USE_CASE;
    context.choice.icon        = icon;
    context.choice.message     = message;
    context.choice.subMessage  = subMessage;
c0de204a:	f105 0118 	add.w	r1, r5, #24
c0de204e:	2008      	movs	r0, #8
c0de2050:	e881 0980 	stmia.w	r1, {r7, r8, fp}
    context.choice.confirmText = confirmText;
    context.choice.cancelText  = cancelText;
    context.choice.onChoice    = callback;
c0de2054:	9909      	ldr	r1, [sp, #36]	@ 0x24
    context.type               = CHOICE_USE_CASE;
c0de2056:	f809 000a 	strb.w	r0, [r9, sl]
c0de205a:	2000      	movs	r0, #0
    context.choice.onChoice    = callback;
c0de205c:	e9c5 1009 	strd	r1, r0, [r5, #36]	@ 0x24
    context.choice.details     = details;
    context.currentPage        = 0;
    context.nbPages            = 2;  // 2 pages for confirm/cancel
    if (message != NULL) {
c0de2060:	2103      	movs	r1, #3
    context.choice.icon        = icon;
c0de2062:	e9c5 6404 	strd	r6, r4, [r5, #16]
    context.currentPage        = 0;
c0de2066:	7268      	strb	r0, [r5, #9]
c0de2068:	2003      	movs	r0, #3
    if (message != NULL) {
c0de206a:	2f00      	cmp	r7, #0
c0de206c:	bf18      	it	ne
c0de206e:	2104      	movne	r1, #4
c0de2070:	2e00      	cmp	r6, #0
c0de2072:	bf08      	it	eq
c0de2074:	4601      	moveq	r1, r0
        if (details->type == BAR_LIST_WARNING) {
            context.nbPages += details->barList.nbBars;
        }
    }

    displayChoicePage(FORWARD_DIRECTION);
c0de2076:	2000      	movs	r0, #0
    if (message != NULL) {
c0de2078:	2c00      	cmp	r4, #0
c0de207a:	bf08      	it	eq
c0de207c:	2102      	moveq	r1, #2
c0de207e:	7229      	strb	r1, [r5, #8]
    displayChoicePage(FORWARD_DIRECTION);
c0de2080:	f000 f802 	bl	c0de2088 <displayChoicePage>
};
c0de2084:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de2088 <displayChoicePage>:
{
c0de2088:	b5b0      	push	{r4, r5, r7, lr}
c0de208a:	b084      	sub	sp, #16
    if (context.choice.message != NULL) {
c0de208c:	f240 3c54 	movw	ip, #852	@ 0x354
c0de2090:	f2c0 0c00 	movt	ip, #0
c0de2094:	eb09 010c 	add.w	r1, r9, ip
c0de2098:	694a      	ldr	r2, [r1, #20]
c0de209a:	f04f 0e00 	mov.w	lr, #0
c0de209e:	b18a      	cbz	r2, c0de20c4 <displayChoicePage+0x3c>
        if ((context.choice.icon == NULL) || (context.choice.subMessage == NULL)) {
c0de20a0:	eb09 010c 	add.w	r1, r9, ip
c0de20a4:	690b      	ldr	r3, [r1, #16]
c0de20a6:	6989      	ldr	r1, [r1, #24]
c0de20a8:	fab3 f383 	clz	r3, r3
c0de20ac:	fab1 f181 	clz	r1, r1
c0de20b0:	095b      	lsrs	r3, r3, #5
c0de20b2:	0949      	lsrs	r1, r1, #5
c0de20b4:	4319      	orrs	r1, r3
c0de20b6:	f081 0101 	eor.w	r1, r1, #1
c0de20ba:	f04f 0302 	mov.w	r3, #2
c0de20be:	bf18      	it	ne
c0de20c0:	2301      	movne	r3, #1
c0de20c2:	e001      	b.n	c0de20c8 <displayChoicePage+0x40>
c0de20c4:	2100      	movs	r1, #0
c0de20c6:	2300      	movs	r3, #0
    context.stepCallback = NULL;
c0de20c8:	eb09 050c 	add.w	r5, r9, ip
    if (context.currentPage < acceptPage) {
c0de20cc:	7a6c      	ldrb	r4, [r5, #9]
    context.stepCallback = NULL;
c0de20ce:	f8c5 e00c 	str.w	lr, [r5, #12]
    if (context.currentPage < acceptPage) {
c0de20d2:	42a3      	cmp	r3, r4
c0de20d4:	d908      	bls.n	c0de20e8 <displayChoicePage+0x60>
c0de20d6:	eb09 030c 	add.w	r3, r9, ip
        if (context.currentPage == 0) {  // title page
c0de20da:	b34c      	cbz	r4, c0de2130 <displayChoicePage+0xa8>
c0de20dc:	699b      	ldr	r3, [r3, #24]
        else if ((acceptPage == 2) && (context.currentPage == 1)) {  // sub-title page
c0de20de:	2900      	cmp	r1, #0
c0de20e0:	bf04      	itt	eq
c0de20e2:	460a      	moveq	r2, r1
c0de20e4:	460b      	moveq	r3, r1
c0de20e6:	e03c      	b.n	c0de2162 <displayChoicePage+0xda>
    else if (context.currentPage == acceptPage) {  // confirm page
c0de20e8:	d10f      	bne.n	c0de210a <displayChoicePage+0x82>
        text                 = context.choice.confirmText;
c0de20ea:	eb09 010c 	add.w	r1, r9, ip
c0de20ee:	69ca      	ldr	r2, [r1, #28]
        context.stepCallback = onChoiceAccept;
c0de20f0:	f640 3357 	movw	r3, #2903	@ 0xb57
c0de20f4:	f2c0 0300 	movt	r3, #0
c0de20f8:	447b      	add	r3, pc
c0de20fa:	60cb      	str	r3, [r1, #12]
c0de20fc:	f242 4148 	movw	r1, #9288	@ 0x2448
c0de2100:	f2c0 0100 	movt	r1, #0
c0de2104:	4479      	add	r1, pc
c0de2106:	2300      	movs	r3, #0
c0de2108:	e02c      	b.n	c0de2164 <displayChoicePage+0xdc>
    else if (context.currentPage == (acceptPage + 1)) {  // cancel page
c0de210a:	1c59      	adds	r1, r3, #1
c0de210c:	42a1      	cmp	r1, r4
c0de210e:	d115      	bne.n	c0de213c <displayChoicePage+0xb4>
        text                 = context.choice.cancelText;
c0de2110:	eb09 010c 	add.w	r1, r9, ip
c0de2114:	6a0a      	ldr	r2, [r1, #32]
        context.stepCallback = onChoiceReject;
c0de2116:	f640 334b 	movw	r3, #2891	@ 0xb4b
c0de211a:	f2c0 0300 	movt	r3, #0
c0de211e:	447b      	add	r3, pc
c0de2120:	60cb      	str	r3, [r1, #12]
c0de2122:	f242 31c9 	movw	r1, #9161	@ 0x23c9
c0de2126:	f2c0 0100 	movt	r1, #0
c0de212a:	4479      	add	r1, pc
c0de212c:	2300      	movs	r3, #0
c0de212e:	e019      	b.n	c0de2164 <displayChoicePage+0xdc>
            if (context.choice.icon != NULL) {
c0de2130:	6919      	ldr	r1, [r3, #16]
c0de2132:	699b      	ldr	r3, [r3, #24]
c0de2134:	2900      	cmp	r1, #0
c0de2136:	bf18      	it	ne
c0de2138:	2300      	movne	r3, #0
c0de213a:	e013      	b.n	c0de2164 <displayChoicePage+0xdc>
    else if (context.choice.details != NULL) {
c0de213c:	eb09 010c 	add.w	r1, r9, ip
c0de2140:	6a89      	ldr	r1, [r1, #40]	@ 0x28
c0de2142:	b161      	cbz	r1, c0de215e <displayChoicePage+0xd6>
        if (context.choice.details->type == BAR_LIST_WARNING) {
c0de2144:	790a      	ldrb	r2, [r1, #4]
c0de2146:	2a03      	cmp	r2, #3
c0de2148:	d109      	bne.n	c0de215e <displayChoicePage+0xd6>
            text = context.choice.details->barList.texts[context.currentPage - (acceptPage + 2)];
c0de214a:	1ae2      	subs	r2, r4, r3
c0de214c:	f06f 0307 	mvn.w	r3, #7
c0de2150:	eb03 0382 	add.w	r3, r3, r2, lsl #2
c0de2154:	e9d1 2103 	ldrd	r2, r1, [r1, #12]
c0de2158:	58d2      	ldr	r2, [r2, r3]
                = context.choice.details->barList.subTexts[context.currentPage - (acceptPage + 2)];
c0de215a:	58cb      	ldr	r3, [r1, r3]
c0de215c:	e001      	b.n	c0de2162 <displayChoicePage+0xda>
c0de215e:	2200      	movs	r2, #0
c0de2160:	2300      	movs	r3, #0
c0de2162:	2100      	movs	r1, #0
    drawStep(pos, icon, text, subText, genericChoiceCallback, false, NO_FORCED_TYPE);
c0de2164:	f640 3415 	movw	r4, #2837	@ 0xb15
c0de2168:	f2c0 0400 	movt	r4, #0
c0de216c:	2500      	movs	r5, #0
c0de216e:	447c      	add	r4, pc
c0de2170:	e9cd 4500 	strd	r4, r5, [sp]
c0de2174:	9502      	str	r5, [sp, #8]
c0de2176:	f7ff fe94 	bl	c0de1ea2 <drawStep>
    nbgl_refresh();
c0de217a:	f001 f800 	bl	c0de317e <nbgl_refresh>
}
c0de217e:	b004      	add	sp, #16
c0de2180:	bdb0      	pop	{r4, r5, r7, pc}

c0de2182 <getContentAtIdx>:
{
c0de2182:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de2184:	b08d      	sub	sp, #52	@ 0x34
c0de2186:	460d      	mov	r5, r1
c0de2188:	4606      	mov	r6, r0
c0de218a:	a801      	add	r0, sp, #4
    nbgl_pageContent_t pageContent = {0};
c0de218c:	2130      	movs	r1, #48	@ 0x30
c0de218e:	4617      	mov	r7, r2
c0de2190:	f002 f8da 	bl	c0de4348 <__aeabi_memclr>
    if (contentIdx >= genericContents->nbContents) {
c0de2194:	7a30      	ldrb	r0, [r6, #8]
c0de2196:	42a8      	cmp	r0, r5
c0de2198:	d91e      	bls.n	c0de21d8 <getContentAtIdx+0x56>
    if (genericContents->callbackCallNeeded) {
c0de219a:	7830      	ldrb	r0, [r6, #0]
c0de219c:	b1f8      	cbz	r0, c0de21de <getContentAtIdx+0x5c>
        if (content == NULL) {
c0de219e:	b1df      	cbz	r7, c0de21d8 <getContentAtIdx+0x56>
        memset(content, 0, sizeof(nbgl_content_t));
c0de21a0:	4638      	mov	r0, r7
c0de21a2:	2138      	movs	r1, #56	@ 0x38
c0de21a4:	f002 f8d0 	bl	c0de4348 <__aeabi_memclr>
        if (context.content.navCallback) {
c0de21a8:	f240 3054 	movw	r0, #852	@ 0x354
c0de21ac:	f2c0 0000 	movt	r0, #0
c0de21b0:	4448      	add	r0, r9
c0de21b2:	6a82      	ldr	r2, [r0, #40]	@ 0x28
c0de21b4:	b1e2      	cbz	r2, c0de21f0 <getContentAtIdx+0x6e>
c0de21b6:	ae01      	add	r6, sp, #4
            if (context.content.navCallback(contentIdx, &pageContent) == true) {
c0de21b8:	4628      	mov	r0, r5
c0de21ba:	4631      	mov	r1, r6
c0de21bc:	4790      	blx	r2
c0de21be:	b158      	cbz	r0, c0de21d8 <getContentAtIdx+0x56>
                content->type = pageContent.type;
c0de21c0:	f89d 1004 	ldrb.w	r1, [sp, #4]
c0de21c4:	2000      	movs	r0, #0
                switch (content->type) {
c0de21c6:	2906      	cmp	r1, #6
                content->type = pageContent.type;
c0de21c8:	7039      	strb	r1, [r7, #0]
                switch (content->type) {
c0de21ca:	dc16      	bgt.n	c0de21fa <getContentAtIdx+0x78>
c0de21cc:	2903      	cmp	r1, #3
c0de21ce:	dc23      	bgt.n	c0de2218 <getContentAtIdx+0x96>
c0de21d0:	b1c9      	cbz	r1, c0de2206 <getContentAtIdx+0x84>
c0de21d2:	2903      	cmp	r1, #3
c0de21d4:	d017      	beq.n	c0de2206 <getContentAtIdx+0x84>
c0de21d6:	e009      	b.n	c0de21ec <getContentAtIdx+0x6a>
c0de21d8:	2000      	movs	r0, #0
}
c0de21da:	b00d      	add	sp, #52	@ 0x34
c0de21dc:	bdf0      	pop	{r4, r5, r6, r7, pc}
        return PIC(&genericContents->contentsList[contentIdx]);
c0de21de:	6870      	ldr	r0, [r6, #4]
c0de21e0:	ebc5 01c5 	rsb	r1, r5, r5, lsl #3
c0de21e4:	eb00 00c1 	add.w	r0, r0, r1, lsl #3
c0de21e8:	f001 fede 	bl	c0de3fa8 <pic>
}
c0de21ec:	b00d      	add	sp, #52	@ 0x34
c0de21ee:	bdf0      	pop	{r4, r5, r6, r7, pc}
            genericContents->contentGetterCallback(contentIdx, content);
c0de21f0:	6872      	ldr	r2, [r6, #4]
c0de21f2:	4628      	mov	r0, r5
c0de21f4:	4639      	mov	r1, r7
c0de21f6:	4790      	blx	r2
c0de21f8:	e032      	b.n	c0de2260 <getContentAtIdx+0xde>
                switch (content->type) {
c0de21fa:	2908      	cmp	r1, #8
c0de21fc:	dc1a      	bgt.n	c0de2234 <getContentAtIdx+0xb2>
c0de21fe:	2907      	cmp	r1, #7
c0de2200:	d023      	beq.n	c0de224a <getContentAtIdx+0xc8>
c0de2202:	2908      	cmp	r1, #8
c0de2204:	d1f2      	bne.n	c0de21ec <getContentAtIdx+0x6a>
c0de2206:	9802      	ldr	r0, [sp, #8]
c0de2208:	9903      	ldr	r1, [sp, #12]
c0de220a:	9a04      	ldr	r2, [sp, #16]
c0de220c:	9b05      	ldr	r3, [sp, #20]
c0de220e:	6078      	str	r0, [r7, #4]
c0de2210:	60b9      	str	r1, [r7, #8]
c0de2212:	60fa      	str	r2, [r7, #12]
c0de2214:	613b      	str	r3, [r7, #16]
c0de2216:	e023      	b.n	c0de2260 <getContentAtIdx+0xde>
c0de2218:	2904      	cmp	r1, #4
c0de221a:	d01b      	beq.n	c0de2254 <getContentAtIdx+0xd2>
c0de221c:	2906      	cmp	r1, #6
c0de221e:	d1e5      	bne.n	c0de21ec <getContentAtIdx+0x6a>
                        content->content.tagValueConfirm = pageContent.tagValueConfirm;
c0de2220:	f106 0c04 	add.w	ip, r6, #4
c0de2224:	e8bc 006d 	ldmia.w	ip!, {r0, r2, r3, r5, r6}
c0de2228:	1d39      	adds	r1, r7, #4
c0de222a:	c16d      	stmia	r1!, {r0, r2, r3, r5, r6}
c0de222c:	e89c 007d 	ldmia.w	ip, {r0, r2, r3, r4, r5, r6}
c0de2230:	c17d      	stmia	r1!, {r0, r2, r3, r4, r5, r6}
c0de2232:	e015      	b.n	c0de2260 <getContentAtIdx+0xde>
                switch (content->type) {
c0de2234:	2909      	cmp	r1, #9
c0de2236:	d001      	beq.n	c0de223c <getContentAtIdx+0xba>
c0de2238:	290a      	cmp	r1, #10
c0de223a:	d1d7      	bne.n	c0de21ec <getContentAtIdx+0x6a>
c0de223c:	9802      	ldr	r0, [sp, #8]
c0de223e:	9903      	ldr	r1, [sp, #12]
c0de2240:	9a04      	ldr	r2, [sp, #16]
c0de2242:	6078      	str	r0, [r7, #4]
c0de2244:	60b9      	str	r1, [r7, #8]
c0de2246:	60fa      	str	r2, [r7, #12]
c0de2248:	e00a      	b.n	c0de2260 <getContentAtIdx+0xde>
                        content->content.switchesList = pageContent.switchesList;
c0de224a:	e9dd 0102 	ldrd	r0, r1, [sp, #8]
c0de224e:	e9c7 0101 	strd	r0, r1, [r7, #4]
c0de2252:	e005      	b.n	c0de2260 <getContentAtIdx+0xde>
                        content->content.tagValueList = pageContent.tagValueList;
c0de2254:	f106 0c04 	add.w	ip, r6, #4
c0de2258:	e89c 006d 	ldmia.w	ip, {r0, r2, r3, r5, r6}
c0de225c:	1d39      	adds	r1, r7, #4
c0de225e:	c16d      	stmia	r1!, {r0, r2, r3, r5, r6}
c0de2260:	4638      	mov	r0, r7
}
c0de2262:	b00d      	add	sp, #52	@ 0x34
c0de2264:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de2266 <displayContent>:
{
c0de2266:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de2268:	b08d      	sub	sp, #52	@ 0x34
    context.stepCallback = NULL;
c0de226a:	f240 3554 	movw	r5, #852	@ 0x354
c0de226e:	f2c0 0500 	movt	r5, #0
c0de2272:	4607      	mov	r7, r0
c0de2274:	eb09 0005 	add.w	r0, r9, r5
    if (context.currentPage < (context.nbPages - 1)) {
c0de2278:	7a02      	ldrb	r2, [r0, #8]
c0de227a:	7a43      	ldrb	r3, [r0, #9]
c0de227c:	3a01      	subs	r2, #1
c0de227e:	429a      	cmp	r2, r3
c0de2280:	f04f 0200 	mov.w	r2, #0
    PageContent_t contentPage = {0};
c0de2284:	e9cd 2208 	strd	r2, r2, [sp, #32]
c0de2288:	e9cd 2206 	strd	r2, r2, [sp, #24]
c0de228c:	e9cd 2204 	strd	r2, r2, [sp, #16]
    context.stepCallback = NULL;
c0de2290:	60c2      	str	r2, [r0, #12]
    if (context.currentPage < (context.nbPages - 1)) {
c0de2292:	dd0d      	ble.n	c0de22b0 <displayContent+0x4a>
c0de2294:	aa04      	add	r2, sp, #16
        getContentPage(toogle_state, &contentPage);
c0de2296:	4608      	mov	r0, r1
c0de2298:	4611      	mov	r1, r2
c0de229a:	f000 f86f 	bl	c0de237c <getContentPage>
        if (contentPage.isCenteredInfo) {
c0de229e:	f89d 0025 	ldrb.w	r0, [sp, #37]	@ 0x25
        context.forceAction = contentPage.isAction;
c0de22a2:	f89d 1026 	ldrb.w	r1, [sp, #38]	@ 0x26
c0de22a6:	eb09 0205 	add.w	r2, r9, r5
        if (contentPage.isCenteredInfo) {
c0de22aa:	0040      	lsls	r0, r0, #1
        context.forceAction = contentPage.isAction;
c0de22ac:	72d1      	strb	r1, [r2, #11]
c0de22ae:	e01e      	b.n	c0de22ee <displayContent+0x88>
        if (context.content.rejectText) {
c0de22b0:	eb09 0005 	add.w	r0, r9, r5
c0de22b4:	f242 415d 	movw	r1, #9309	@ 0x245d
c0de22b8:	f2c0 0100 	movt	r1, #0
c0de22bc:	6a02      	ldr	r2, [r0, #32]
c0de22be:	4479      	add	r1, pc
        context.stepCallback = context.content.quitCallback;
c0de22c0:	6ac3      	ldr	r3, [r0, #44]	@ 0x2c
c0de22c2:	2a00      	cmp	r2, #0
c0de22c4:	bf18      	it	ne
c0de22c6:	4611      	movne	r1, r2
c0de22c8:	9105      	str	r1, [sp, #20]
        if (context.type == GENERIC_REVIEW_USE_CASE) {
c0de22ca:	f819 1005 	ldrb.w	r1, [r9, r5]
c0de22ce:	f242 2213 	movw	r2, #8723	@ 0x2213
c0de22d2:	f2c0 0200 	movt	r2, #0
c0de22d6:	f242 16cf 	movw	r6, #8655	@ 0x21cf
c0de22da:	f2c0 0600 	movt	r6, #0
c0de22de:	447e      	add	r6, pc
c0de22e0:	447a      	add	r2, pc
c0de22e2:	2903      	cmp	r1, #3
c0de22e4:	bf08      	it	eq
c0de22e6:	4616      	moveq	r6, r2
        context.stepCallback = context.content.quitCallback;
c0de22e8:	60c3      	str	r3, [r0, #12]
c0de22ea:	2000      	movs	r0, #0
c0de22ec:	9607      	str	r6, [sp, #28]
    if (contentPage.isSwitch) {
c0de22ee:	f89d 1010 	ldrb.w	r1, [sp, #16]
c0de22f2:	b1b1      	cbz	r1, c0de2322 <displayContent+0xbc>
    pos |= GET_POS_OF_STEP(context.currentPage, context.nbPages);
c0de22f4:	eb09 0005 	add.w	r0, r9, r5
c0de22f8:	7a04      	ldrb	r4, [r0, #8]
            pos, contentPage.text, contentPage.subText, contentPage.state, contentCallback, false);
c0de22fa:	e9dd 1205 	ldrd	r1, r2, [sp, #20]
c0de22fe:	f89d 3024 	ldrb.w	r3, [sp, #36]	@ 0x24
c0de2302:	f04f 0c00 	mov.w	ip, #0
    pos |= GET_POS_OF_STEP(context.currentPage, context.nbPages);
c0de2306:	2c02      	cmp	r4, #2
c0de2308:	f04f 0000 	mov.w	r0, #0
c0de230c:	d31b      	bcc.n	c0de2346 <displayContent+0xe0>
c0de230e:	eb09 0005 	add.w	r0, r9, r5
c0de2312:	7a46      	ldrb	r6, [r0, #9]
c0de2314:	b1b6      	cbz	r6, c0de2344 <displayContent+0xde>
c0de2316:	3c01      	subs	r4, #1
c0de2318:	2003      	movs	r0, #3
c0de231a:	42b4      	cmp	r4, r6
c0de231c:	bf08      	it	eq
c0de231e:	2002      	moveq	r0, #2
c0de2320:	e011      	b.n	c0de2346 <displayContent+0xe0>
                 contentPage.text,
c0de2322:	e9dd 2305 	ldrd	r2, r3, [sp, #20]
                 contentPage.icon,
c0de2326:	9907      	ldr	r1, [sp, #28]
        drawStep(pos,
c0de2328:	f240 14e7 	movw	r4, #487	@ 0x1e7
c0de232c:	f2c0 0400 	movt	r4, #0
c0de2330:	b2c6      	uxtb	r6, r0
c0de2332:	2000      	movs	r0, #0
c0de2334:	447c      	add	r4, pc
c0de2336:	e9cd 4000 	strd	r4, r0, [sp]
c0de233a:	4638      	mov	r0, r7
c0de233c:	9602      	str	r6, [sp, #8]
c0de233e:	f7ff fdb0 	bl	c0de1ea2 <drawStep>
c0de2342:	e013      	b.n	c0de236c <displayContent+0x106>
c0de2344:	2001      	movs	r0, #1
            pos, contentPage.text, contentPage.subText, contentPage.state, contentCallback, false);
c0de2346:	2b00      	cmp	r3, #0
c0de2348:	bf18      	it	ne
c0de234a:	2301      	movne	r3, #1
    switchInfo.initState = state;
c0de234c:	f88d 3030 	strb.w	r3, [sp, #48]	@ 0x30
    switchInfo.text      = title;
c0de2350:	e9cd 120a 	strd	r1, r2, [sp, #40]	@ 0x28
    nbgl_stepDrawSwitch(pos, onActionCallback, NULL, &switchInfo, modal);
c0de2354:	f240 11bd 	movw	r1, #445	@ 0x1bd
c0de2358:	f2c0 0100 	movt	r1, #0
    pos |= GET_POS_OF_STEP(context.currentPage, context.nbPages);
c0de235c:	4338      	orrs	r0, r7
    nbgl_stepDrawSwitch(pos, onActionCallback, NULL, &switchInfo, modal);
c0de235e:	4479      	add	r1, pc
c0de2360:	ab0a      	add	r3, sp, #40	@ 0x28
c0de2362:	2200      	movs	r2, #0
c0de2364:	f8cd c000 	str.w	ip, [sp]
c0de2368:	f7ff fba0 	bl	c0de1aac <nbgl_stepDrawSwitch>
    context.forceAction = false;
c0de236c:	eb09 0005 	add.w	r0, r9, r5
c0de2370:	2100      	movs	r1, #0
c0de2372:	72c1      	strb	r1, [r0, #11]
    nbgl_refresh();
c0de2374:	f000 ff03 	bl	c0de317e <nbgl_refresh>
}
c0de2378:	b00d      	add	sp, #52	@ 0x34
c0de237a:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de237c <getContentPage>:
{
c0de237c:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de237e:	b08f      	sub	sp, #60	@ 0x3c
c0de2380:	4606      	mov	r6, r0
c0de2382:	2000      	movs	r0, #0
c0de2384:	466d      	mov	r5, sp
c0de2386:	460c      	mov	r4, r1
    uint8_t               elemIdx       = 0;
c0de2388:	f88d 003b 	strb.w	r0, [sp, #59]	@ 0x3b
    nbgl_content_t        content       = {0};
c0de238c:	4628      	mov	r0, r5
c0de238e:	2138      	movs	r1, #56	@ 0x38
c0de2390:	f001 ffda 	bl	c0de4348 <__aeabi_memclr>
    p_content = getContentElemAtIdx(context.currentPage, &elemIdx, &content);
c0de2394:	f240 3754 	movw	r7, #852	@ 0x354
c0de2398:	f2c0 0700 	movt	r7, #0
c0de239c:	eb09 0007 	add.w	r0, r9, r7
c0de23a0:	7a40      	ldrb	r0, [r0, #9]
c0de23a2:	f10d 013b 	add.w	r1, sp, #59	@ 0x3b
c0de23a6:	462a      	mov	r2, r5
c0de23a8:	f000 f8c8 	bl	c0de253c <getContentElemAtIdx>
    if (p_content == NULL) {
c0de23ac:	2800      	cmp	r0, #0
c0de23ae:	f000 80a2 	beq.w	c0de24f6 <getContentPage+0x17a>
c0de23b2:	4605      	mov	r5, r0
    switch (p_content->type) {
c0de23b4:	7800      	ldrb	r0, [r0, #0]
c0de23b6:	2806      	cmp	r0, #6
c0de23b8:	dc10      	bgt.n	c0de23dc <getContentPage+0x60>
c0de23ba:	2803      	cmp	r0, #3
c0de23bc:	dc23      	bgt.n	c0de2406 <getContentPage+0x8a>
c0de23be:	2800      	cmp	r0, #0
c0de23c0:	d050      	beq.n	c0de2464 <getContentPage+0xe8>
c0de23c2:	2803      	cmp	r0, #3
c0de23c4:	f040 8097 	bne.w	c0de24f6 <getContentPage+0x17a>
            contentPage->icon    = PIC(p_content->content.infoButton.icon);
c0de23c8:	68a8      	ldr	r0, [r5, #8]
c0de23ca:	f001 fded 	bl	c0de3fa8 <pic>
c0de23ce:	60e0      	str	r0, [r4, #12]
            contentPage->text    = PIC(p_content->content.infoButton.text);
c0de23d0:	6868      	ldr	r0, [r5, #4]
c0de23d2:	f001 fde9 	bl	c0de3fa8 <pic>
c0de23d6:	6060      	str	r0, [r4, #4]
            contentPage->subText = PIC(p_content->content.infoButton.buttonText);
c0de23d8:	68e8      	ldr	r0, [r5, #12]
c0de23da:	e048      	b.n	c0de246e <getContentPage+0xf2>
    switch (p_content->type) {
c0de23dc:	2808      	cmp	r0, #8
c0de23de:	dc21      	bgt.n	c0de2424 <getContentPage+0xa8>
c0de23e0:	2807      	cmp	r0, #7
c0de23e2:	d047      	beq.n	c0de2474 <getContentPage+0xf8>
c0de23e4:	2808      	cmp	r0, #8
c0de23e6:	f040 8086 	bne.w	c0de24f6 <getContentPage+0x17a>
                = ((const char *const *) PIC(p_content->content.infosList.infoTypes))[elemIdx];
c0de23ea:	6868      	ldr	r0, [r5, #4]
c0de23ec:	f001 fddc 	bl	c0de3fa8 <pic>
c0de23f0:	f89d 603b 	ldrb.w	r6, [sp, #59]	@ 0x3b
c0de23f4:	f850 0026 	ldr.w	r0, [r0, r6, lsl #2]
c0de23f8:	6060      	str	r0, [r4, #4]
                = ((const char *const *) PIC(p_content->content.infosList.infoContents))[elemIdx];
c0de23fa:	68a8      	ldr	r0, [r5, #8]
c0de23fc:	f001 fdd4 	bl	c0de3fa8 <pic>
c0de2400:	f850 0026 	ldr.w	r0, [r0, r6, lsl #2]
c0de2404:	e055      	b.n	c0de24b2 <getContentPage+0x136>
    switch (p_content->type) {
c0de2406:	2804      	cmp	r0, #4
c0de2408:	d056      	beq.n	c0de24b8 <getContentPage+0x13c>
c0de240a:	2806      	cmp	r0, #6
c0de240c:	d173      	bne.n	c0de24f6 <getContentPage+0x17a>
            if (elemIdx < p_content->content.tagValueConfirm.tagValueList.nbPairs) {
c0de240e:	f89d 003b 	ldrb.w	r0, [sp, #59]	@ 0x3b
c0de2412:	7b29      	ldrb	r1, [r5, #12]
c0de2414:	4288      	cmp	r0, r1
c0de2416:	d270      	bcs.n	c0de24fa <getContentPage+0x17e>
    if (tagValueList->pairs != NULL) {
c0de2418:	6869      	ldr	r1, [r5, #4]
c0de241a:	2900      	cmp	r1, #0
c0de241c:	d151      	bne.n	c0de24c2 <getContentPage+0x146>
c0de241e:	68a9      	ldr	r1, [r5, #8]
c0de2420:	4788      	blx	r1
c0de2422:	e050      	b.n	c0de24c6 <getContentPage+0x14a>
    switch (p_content->type) {
c0de2424:	2809      	cmp	r0, #9
c0de2426:	d001      	beq.n	c0de242c <getContentPage+0xb0>
c0de2428:	280a      	cmp	r0, #10
c0de242a:	d164      	bne.n	c0de24f6 <getContentPage+0x17a>
c0de242c:	1d28      	adds	r0, r5, #4
c0de242e:	f001 fdbb 	bl	c0de3fa8 <pic>
c0de2432:	6800      	ldr	r0, [r0, #0]
c0de2434:	f001 fdb8 	bl	c0de3fa8 <pic>
c0de2438:	f819 2007 	ldrb.w	r2, [r9, r7]
c0de243c:	eb09 0107 	add.w	r1, r9, r7
c0de2440:	6909      	ldr	r1, [r1, #16]
c0de2442:	2a11      	cmp	r2, #17
c0de2444:	4605      	mov	r5, r0
c0de2446:	d100      	bne.n	c0de244a <getContentPage+0xce>
c0de2448:	b919      	cbnz	r1, c0de2452 <getContentPage+0xd6>
c0de244a:	2a10      	cmp	r2, #16
c0de244c:	d14c      	bne.n	c0de24e8 <getContentPage+0x16c>
c0de244e:	2900      	cmp	r1, #0
c0de2450:	d04a      	beq.n	c0de24e8 <getContentPage+0x16c>
c0de2452:	4608      	mov	r0, r1
c0de2454:	f001 fda8 	bl	c0de3fa8 <pic>
c0de2458:	f89d 103b 	ldrb.w	r1, [sp, #59]	@ 0x3b
c0de245c:	6060      	str	r0, [r4, #4]
c0de245e:	f855 0021 	ldr.w	r0, [r5, r1, lsl #2]
c0de2462:	e004      	b.n	c0de246e <getContentPage+0xf2>
            contentPage->text    = PIC(p_content->content.centeredInfo.text1);
c0de2464:	6868      	ldr	r0, [r5, #4]
c0de2466:	f001 fd9f 	bl	c0de3fa8 <pic>
c0de246a:	6060      	str	r0, [r4, #4]
            contentPage->subText = PIC(p_content->content.centeredInfo.text2);
c0de246c:	68a8      	ldr	r0, [r5, #8]
c0de246e:	f001 fd9b 	bl	c0de3fa8 <pic>
c0de2472:	e01e      	b.n	c0de24b2 <getContentPage+0x136>
c0de2474:	2001      	movs	r0, #1
            contentPage->isSwitch = true;
c0de2476:	7020      	strb	r0, [r4, #0]
                (nbgl_contentSwitch_t *) PIC(p_content->content.switchesList.switches))[elemIdx];
c0de2478:	6868      	ldr	r0, [r5, #4]
c0de247a:	f001 fd95 	bl	c0de3fa8 <pic>
c0de247e:	f89d 103b 	ldrb.w	r1, [sp, #59]	@ 0x3b
            contentPage->text  = contentSwitch->text;
c0de2482:	eb01 0141 	add.w	r1, r1, r1, lsl #1
c0de2486:	f850 2021 	ldr.w	r2, [r0, r1, lsl #2]
c0de248a:	eb00 0081 	add.w	r0, r0, r1, lsl #2
c0de248e:	6062      	str	r2, [r4, #4]
            contentPage->state = contentSwitch->initState;
c0de2490:	7a01      	ldrb	r1, [r0, #8]
            if (toogle_state) {
c0de2492:	1e4a      	subs	r2, r1, #1
c0de2494:	bf18      	it	ne
c0de2496:	2201      	movne	r2, #1
c0de2498:	2e00      	cmp	r6, #0
c0de249a:	bf08      	it	eq
c0de249c:	460a      	moveq	r2, r1
c0de249e:	7522      	strb	r2, [r4, #20]
            context.stepCallback = onSwitchAction;
c0de24a0:	f240 1261 	movw	r2, #353	@ 0x161
c0de24a4:	f2c0 0200 	movt	r2, #0
c0de24a8:	eb09 0107 	add.w	r1, r9, r7
c0de24ac:	447a      	add	r2, pc
c0de24ae:	60ca      	str	r2, [r1, #12]
            contentPage->subText = contentSwitch->subText;
c0de24b0:	6840      	ldr	r0, [r0, #4]
c0de24b2:	60a0      	str	r0, [r4, #8]
}
c0de24b4:	b00f      	add	sp, #60	@ 0x3c
c0de24b6:	bdf0      	pop	{r4, r5, r6, r7, pc}
    if (tagValueList->pairs != NULL) {
c0de24b8:	6869      	ldr	r1, [r5, #4]
                        elemIdx,
c0de24ba:	f89d 003b 	ldrb.w	r0, [sp, #59]	@ 0x3b
    if (tagValueList->pairs != NULL) {
c0de24be:	2900      	cmp	r1, #0
c0de24c0:	d0ad      	beq.n	c0de241e <getContentPage+0xa2>
c0de24c2:	eb01 1000 	add.w	r0, r1, r0, lsl #4
c0de24c6:	f001 fd6f 	bl	c0de3fa8 <pic>
c0de24ca:	6801      	ldr	r1, [r0, #0]
c0de24cc:	6061      	str	r1, [r4, #4]
c0de24ce:	6841      	ldr	r1, [r0, #4]
c0de24d0:	60a1      	str	r1, [r4, #8]
c0de24d2:	7b01      	ldrb	r1, [r0, #12]
c0de24d4:	074a      	lsls	r2, r1, #29
c0de24d6:	d403      	bmi.n	c0de24e0 <getContentPage+0x164>
c0de24d8:	0789      	lsls	r1, r1, #30
c0de24da:	d41a      	bmi.n	c0de2512 <getContentPage+0x196>
c0de24dc:	2000      	movs	r0, #0
c0de24de:	e000      	b.n	c0de24e2 <getContentPage+0x166>
c0de24e0:	6880      	ldr	r0, [r0, #8]
c0de24e2:	6120      	str	r0, [r4, #16]
}
c0de24e4:	b00f      	add	sp, #60	@ 0x3c
c0de24e6:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de24e8:	f89d 003b 	ldrb.w	r0, [sp, #59]	@ 0x3b
c0de24ec:	f855 0020 	ldr.w	r0, [r5, r0, lsl #2]
c0de24f0:	f001 fd5a 	bl	c0de3fa8 <pic>
c0de24f4:	6060      	str	r0, [r4, #4]
c0de24f6:	b00f      	add	sp, #60	@ 0x3c
c0de24f8:	bdf0      	pop	{r4, r5, r6, r7, pc}
                contentPage->text     = p_content->content.tagValueConfirm.confirmationText;
c0de24fa:	6a68      	ldr	r0, [r5, #36]	@ 0x24
c0de24fc:	6060      	str	r0, [r4, #4]
                contentPage->icon     = &C_icon_validate_14;
c0de24fe:	f242 0046 	movw	r0, #8262	@ 0x2046
c0de2502:	f2c0 0000 	movt	r0, #0
c0de2506:	4478      	add	r0, pc
c0de2508:	60e0      	str	r0, [r4, #12]
c0de250a:	2001      	movs	r0, #1
                contentPage->isAction = true;
c0de250c:	75a0      	strb	r0, [r4, #22]
}
c0de250e:	b00f      	add	sp, #60	@ 0x3c
c0de2510:	bdf0      	pop	{r4, r5, r6, r7, pc}
c0de2512:	2101      	movs	r1, #1
c0de2514:	7561      	strb	r1, [r4, #21]
c0de2516:	6880      	ldr	r0, [r0, #8]
c0de2518:	60e0      	str	r0, [r4, #12]
c0de251a:	b00f      	add	sp, #60	@ 0x3c
c0de251c:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de251e <contentCallback>:
{
c0de251e:	b580      	push	{r7, lr}
c0de2520:	b082      	sub	sp, #8
c0de2522:	4608      	mov	r0, r1
c0de2524:	f10d 0107 	add.w	r1, sp, #7
    if (!buttonGenericCallback(event, &pos)) {
c0de2528:	f000 f951 	bl	c0de27ce <buttonGenericCallback>
c0de252c:	b120      	cbz	r0, c0de2538 <contentCallback+0x1a>
    displayContent(pos, false);
c0de252e:	f89d 0007 	ldrb.w	r0, [sp, #7]
c0de2532:	2100      	movs	r1, #0
c0de2534:	f7ff fe97 	bl	c0de2266 <displayContent>
}
c0de2538:	b002      	add	sp, #8
c0de253a:	bd80      	pop	{r7, pc}

c0de253c <getContentElemAtIdx>:
{
c0de253c:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
    switch (context.type) {
c0de2540:	f240 3a54 	movw	sl, #852	@ 0x354
c0de2544:	f2c0 0a00 	movt	sl, #0
c0de2548:	eb09 070a 	add.w	r7, r9, sl
c0de254c:	4688      	mov	r8, r1
c0de254e:	f817 1b14 	ldrb.w	r1, [r7], #20
c0de2552:	4606      	mov	r6, r0
c0de2554:	2911      	cmp	r1, #17
c0de2556:	f04f 0000 	mov.w	r0, #0
c0de255a:	d854      	bhi.n	c0de2606 <getContentElemAtIdx+0xca>
c0de255c:	4693      	mov	fp, r2
c0de255e:	2201      	movs	r2, #1
c0de2560:	fa02 f101 	lsl.w	r1, r2, r1
c0de2564:	f411 3fd0 	tst.w	r1, #106496	@ 0x1a000
c0de2568:	d003      	beq.n	c0de2572 <getContentElemAtIdx+0x36>
            genericContents = context.home.settingContents;
c0de256a:	eb09 000a 	add.w	r0, r9, sl
c0de256e:	69c7      	ldr	r7, [r0, #28]
c0de2570:	e004      	b.n	c0de257c <getContentElemAtIdx+0x40>
c0de2572:	2208      	movs	r2, #8
c0de2574:	f2c0 0202 	movt	r2, #2
c0de2578:	4211      	tst	r1, r2
c0de257a:	d044      	beq.n	c0de2606 <getContentElemAtIdx+0xca>
    for (uint i = 0; i < genericContents->nbContents; i++) {
c0de257c:	7a38      	ldrb	r0, [r7, #8]
c0de257e:	2800      	cmp	r0, #0
c0de2580:	d043      	beq.n	c0de260a <getContentElemAtIdx+0xce>
c0de2582:	2400      	movs	r4, #0
c0de2584:	2500      	movs	r5, #0
c0de2586:	e006      	b.n	c0de2596 <getContentElemAtIdx+0x5a>
c0de2588:	7a3a      	ldrb	r2, [r7, #8]
c0de258a:	3401      	adds	r4, #1
c0de258c:	4294      	cmp	r4, r2
c0de258e:	460d      	mov	r5, r1
}
c0de2590:	bf28      	it	cs
c0de2592:	e8bd 8df0 	ldmiacs.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
        p_content   = getContentAtIdx(genericContents, i, content);
c0de2596:	b2e1      	uxtb	r1, r4
c0de2598:	4638      	mov	r0, r7
c0de259a:	465a      	mov	r2, fp
c0de259c:	f7ff fdf1 	bl	c0de2182 <getContentAtIdx>
    switch (content->type) {
c0de25a0:	7802      	ldrb	r2, [r0, #0]
c0de25a2:	2a06      	cmp	r2, #6
c0de25a4:	dc08      	bgt.n	c0de25b8 <getContentElemAtIdx+0x7c>
c0de25a6:	2a03      	cmp	r2, #3
c0de25a8:	dc0e      	bgt.n	c0de25c8 <getContentElemAtIdx+0x8c>
c0de25aa:	f04f 0101 	mov.w	r1, #1
c0de25ae:	b1fa      	cbz	r2, c0de25f0 <getContentElemAtIdx+0xb4>
c0de25b0:	2a03      	cmp	r2, #3
c0de25b2:	bf18      	it	ne
c0de25b4:	2100      	movne	r1, #0
c0de25b6:	e01b      	b.n	c0de25f0 <getContentElemAtIdx+0xb4>
c0de25b8:	2a08      	cmp	r2, #8
c0de25ba:	dc0d      	bgt.n	c0de25d8 <getContentElemAtIdx+0x9c>
c0de25bc:	2a07      	cmp	r2, #7
c0de25be:	d011      	beq.n	c0de25e4 <getContentElemAtIdx+0xa8>
c0de25c0:	2a08      	cmp	r2, #8
c0de25c2:	d113      	bne.n	c0de25ec <getContentElemAtIdx+0xb0>
            return content->content.infosList.nbInfos;
c0de25c4:	7c01      	ldrb	r1, [r0, #16]
c0de25c6:	e013      	b.n	c0de25f0 <getContentElemAtIdx+0xb4>
    switch (content->type) {
c0de25c8:	2a04      	cmp	r2, #4
c0de25ca:	d009      	beq.n	c0de25e0 <getContentElemAtIdx+0xa4>
c0de25cc:	2a06      	cmp	r2, #6
c0de25ce:	d10d      	bne.n	c0de25ec <getContentElemAtIdx+0xb0>
            return content->content.tagValueConfirm.tagValueList.nbPairs + 1;
c0de25d0:	7b01      	ldrb	r1, [r0, #12]
c0de25d2:	3101      	adds	r1, #1
c0de25d4:	e00c      	b.n	c0de25f0 <getContentElemAtIdx+0xb4>
c0de25d6:	bf00      	nop
    switch (content->type) {
c0de25d8:	2a09      	cmp	r2, #9
c0de25da:	d005      	beq.n	c0de25e8 <getContentElemAtIdx+0xac>
c0de25dc:	2a0a      	cmp	r2, #10
c0de25de:	d105      	bne.n	c0de25ec <getContentElemAtIdx+0xb0>
c0de25e0:	7b01      	ldrb	r1, [r0, #12]
c0de25e2:	e005      	b.n	c0de25f0 <getContentElemAtIdx+0xb4>
            return content->content.switchesList.nbSwitches;
c0de25e4:	7a01      	ldrb	r1, [r0, #8]
c0de25e6:	e003      	b.n	c0de25f0 <getContentElemAtIdx+0xb4>
            return content->content.choicesList.nbChoices;
c0de25e8:	7a41      	ldrb	r1, [r0, #9]
c0de25ea:	e001      	b.n	c0de25f0 <getContentElemAtIdx+0xb4>
c0de25ec:	2100      	movs	r1, #0
c0de25ee:	bf00      	nop
        if (nbPages + elemNbPages > elemIdx) {
c0de25f0:	b2ea      	uxtb	r2, r5
c0de25f2:	b2c9      	uxtb	r1, r1
c0de25f4:	4411      	add	r1, r2
c0de25f6:	42b1      	cmp	r1, r6
c0de25f8:	d9c6      	bls.n	c0de2588 <getContentElemAtIdx+0x4c>
            *elemContentIdx = context.currentPage - nbPages;
c0de25fa:	eb09 010a 	add.w	r1, r9, sl
c0de25fe:	7a49      	ldrb	r1, [r1, #9]
c0de2600:	1b49      	subs	r1, r1, r5
c0de2602:	f888 1000 	strb.w	r1, [r8]
}
c0de2606:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de260a:	2000      	movs	r0, #0
c0de260c:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de2610 <onSwitchAction>:
{
c0de2610:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de2612:	b08f      	sub	sp, #60	@ 0x3c
c0de2614:	ac01      	add	r4, sp, #4
    nbgl_content_t              content       = {0};
c0de2616:	4620      	mov	r0, r4
c0de2618:	2138      	movs	r1, #56	@ 0x38
c0de261a:	f001 fe95 	bl	c0de4348 <__aeabi_memclr>
    p_content = getContentElemAtIdx(context.currentPage, &elemIdx, &content);
c0de261e:	f240 3654 	movw	r6, #852	@ 0x354
c0de2622:	f2c0 0600 	movt	r6, #0
c0de2626:	eb09 0006 	add.w	r0, r9, r6
c0de262a:	7a40      	ldrb	r0, [r0, #9]
c0de262c:	f10d 0103 	add.w	r1, sp, #3
c0de2630:	4622      	mov	r2, r4
c0de2632:	f7ff ff83 	bl	c0de253c <getContentElemAtIdx>
    if ((p_content == NULL) || (p_content->type != SWITCHES_LIST)) {
c0de2636:	2800      	cmp	r0, #0
c0de2638:	d03f      	beq.n	c0de26ba <onSwitchAction+0xaa>
c0de263a:	4604      	mov	r4, r0
c0de263c:	7800      	ldrb	r0, [r0, #0]
c0de263e:	2807      	cmp	r0, #7
c0de2640:	d13b      	bne.n	c0de26ba <onSwitchAction+0xaa>
        = &((const nbgl_contentSwitch_t *) PIC(p_content->content.switchesList.switches))[elemIdx];
c0de2642:	6860      	ldr	r0, [r4, #4]
c0de2644:	f001 fcb0 	bl	c0de3fa8 <pic>
    switch (context.type) {
c0de2648:	f819 1006 	ldrb.w	r1, [r9, r6]
        = &((const nbgl_contentSwitch_t *) PIC(p_content->content.switchesList.switches))[elemIdx];
c0de264c:	f89d 7003 	ldrb.w	r7, [sp, #3]
    switch (context.type) {
c0de2650:	2911      	cmp	r1, #17
        = &((const nbgl_contentSwitch_t *) PIC(p_content->content.switchesList.switches))[elemIdx];
c0de2652:	4605      	mov	r5, r0
    switch (context.type) {
c0de2654:	d812      	bhi.n	c0de267c <onSwitchAction+0x6c>
c0de2656:	2001      	movs	r0, #1
c0de2658:	4088      	lsls	r0, r1
c0de265a:	f410 3fd0 	tst.w	r0, #106496	@ 0x1a000
c0de265e:	d004      	beq.n	c0de266a <onSwitchAction+0x5a>
            displaySettingsPage(FORWARD_DIRECTION, true);
c0de2660:	2000      	movs	r0, #0
c0de2662:	2101      	movs	r1, #1
c0de2664:	f000 f82b 	bl	c0de26be <displaySettingsPage>
c0de2668:	e008      	b.n	c0de267c <onSwitchAction+0x6c>
c0de266a:	2108      	movs	r1, #8
c0de266c:	f2c0 0102 	movt	r1, #2
c0de2670:	4208      	tst	r0, r1
c0de2672:	d003      	beq.n	c0de267c <onSwitchAction+0x6c>
            displayContent(FORWARD_DIRECTION, true);
c0de2674:	2000      	movs	r0, #0
c0de2676:	2101      	movs	r1, #1
c0de2678:	f7ff fdf5 	bl	c0de2266 <displayContent>
    if (p_content->contentActionCallback != NULL) {
c0de267c:	6b60      	ldr	r0, [r4, #52]	@ 0x34
c0de267e:	b188      	cbz	r0, c0de26a4 <onSwitchAction+0x94>
        nbgl_contentActionCallback_t actionCallback = PIC(p_content->contentActionCallback);
c0de2680:	f001 fc92 	bl	c0de3fa8 <pic>
c0de2684:	4603      	mov	r3, r0
        actionCallback(contentSwitch->token,
c0de2686:	eb07 0047 	add.w	r0, r7, r7, lsl #1
c0de268a:	eb05 0080 	add.w	r0, r5, r0, lsl #2
                       (contentSwitch->initState == ON_STATE) ? OFF_STATE : ON_STATE,
c0de268e:	7a01      	ldrb	r1, [r0, #8]
                       context.currentPage);
c0de2690:	eb09 0206 	add.w	r2, r9, r6
        actionCallback(contentSwitch->token,
c0de2694:	7a40      	ldrb	r0, [r0, #9]
                       context.currentPage);
c0de2696:	7a52      	ldrb	r2, [r2, #9]
                       (contentSwitch->initState == ON_STATE) ? OFF_STATE : ON_STATE,
c0de2698:	3901      	subs	r1, #1
c0de269a:	bf18      	it	ne
c0de269c:	2101      	movne	r1, #1
        actionCallback(contentSwitch->token,
c0de269e:	4798      	blx	r3
}
c0de26a0:	b00f      	add	sp, #60	@ 0x3c
c0de26a2:	bdf0      	pop	{r4, r5, r6, r7, pc}
    else if (context.content.controlsCallback != NULL) {
c0de26a4:	eb09 0006 	add.w	r0, r9, r6
c0de26a8:	6a42      	ldr	r2, [r0, #36]	@ 0x24
c0de26aa:	b132      	cbz	r2, c0de26ba <onSwitchAction+0xaa>
        context.content.controlsCallback(contentSwitch->token, 0);
c0de26ac:	eb07 0047 	add.w	r0, r7, r7, lsl #1
c0de26b0:	eb05 0080 	add.w	r0, r5, r0, lsl #2
c0de26b4:	7a40      	ldrb	r0, [r0, #9]
c0de26b6:	2100      	movs	r1, #0
c0de26b8:	4790      	blx	r2
}
c0de26ba:	b00f      	add	sp, #60	@ 0x3c
c0de26bc:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de26be <displaySettingsPage>:
{
c0de26be:	b570      	push	{r4, r5, r6, lr}
c0de26c0:	b08c      	sub	sp, #48	@ 0x30
    context.stepCallback = NULL;
c0de26c2:	f240 3554 	movw	r5, #852	@ 0x354
c0de26c6:	f2c0 0500 	movt	r5, #0
c0de26ca:	4606      	mov	r6, r0
c0de26cc:	eb09 0005 	add.w	r0, r9, r5
    if (context.currentPage < (context.nbPages - 1)) {
c0de26d0:	7a02      	ldrb	r2, [r0, #8]
c0de26d2:	7a43      	ldrb	r3, [r0, #9]
c0de26d4:	3a01      	subs	r2, #1
c0de26d6:	429a      	cmp	r2, r3
c0de26d8:	f04f 0200 	mov.w	r2, #0
    PageContent_t contentPage = {0};
c0de26dc:	e9cd 2207 	strd	r2, r2, [sp, #28]
c0de26e0:	e9cd 2205 	strd	r2, r2, [sp, #20]
c0de26e4:	e9cd 2203 	strd	r2, r2, [sp, #12]
    context.stepCallback = NULL;
c0de26e8:	60c2      	str	r2, [r0, #12]
    if (context.currentPage < (context.nbPages - 1)) {
c0de26ea:	dd05      	ble.n	c0de26f8 <displaySettingsPage+0x3a>
c0de26ec:	aa03      	add	r2, sp, #12
        getContentPage(toogle_state, &contentPage);
c0de26ee:	4608      	mov	r0, r1
c0de26f0:	4611      	mov	r1, r2
c0de26f2:	f7ff fe43 	bl	c0de237c <getContentPage>
c0de26f6:	e019      	b.n	c0de272c <displaySettingsPage+0x6e>
        contentPage.icon = &C_icon_back_x;
c0de26f8:	f641 50ad 	movw	r0, #7597	@ 0x1dad
c0de26fc:	f2c0 0000 	movt	r0, #0
c0de2700:	4478      	add	r0, pc
c0de2702:	9006      	str	r0, [sp, #24]
        if (context.type == GENERIC_SETTINGS) {
c0de2704:	f819 0005 	ldrb.w	r0, [r9, r5]
        contentPage.text = "Back";
c0de2708:	f242 010b 	movw	r1, #8203	@ 0x200b
c0de270c:	f2c0 0100 	movt	r1, #0
c0de2710:	4479      	add	r1, pc
        if (context.type == GENERIC_SETTINGS) {
c0de2712:	2810      	cmp	r0, #16
            context.stepCallback = startUseCaseHome;
c0de2714:	eb09 0005 	add.w	r0, r9, r5
        contentPage.text = "Back";
c0de2718:	9104      	str	r1, [sp, #16]
        if (context.type == GENERIC_SETTINGS) {
c0de271a:	d101      	bne.n	c0de2720 <displaySettingsPage+0x62>
            context.stepCallback = context.home.quitCallback;
c0de271c:	6a81      	ldr	r1, [r0, #40]	@ 0x28
c0de271e:	e004      	b.n	c0de272a <displaySettingsPage+0x6c>
            context.stepCallback = startUseCaseHome;
c0de2720:	f24f 61e9 	movw	r1, #63209	@ 0xf6e9
c0de2724:	f6cf 71ff 	movt	r1, #65535	@ 0xffff
c0de2728:	4479      	add	r1, pc
c0de272a:	60c1      	str	r1, [r0, #12]
    if (contentPage.isSwitch) {
c0de272c:	f89d 000c 	ldrb.w	r0, [sp, #12]
c0de2730:	b1b0      	cbz	r0, c0de2760 <displaySettingsPage+0xa2>
    pos |= GET_POS_OF_STEP(context.currentPage, context.nbPages);
c0de2732:	eb09 0005 	add.w	r0, r9, r5
c0de2736:	7a04      	ldrb	r4, [r0, #8]
            pos, contentPage.text, contentPage.subText, contentPage.state, settingsCallback, false);
c0de2738:	e9dd 1204 	ldrd	r1, r2, [sp, #16]
c0de273c:	f89d 3020 	ldrb.w	r3, [sp, #32]
c0de2740:	f04f 0c00 	mov.w	ip, #0
    pos |= GET_POS_OF_STEP(context.currentPage, context.nbPages);
c0de2744:	2c02      	cmp	r4, #2
c0de2746:	f04f 0000 	mov.w	r0, #0
c0de274a:	d31a      	bcc.n	c0de2782 <displaySettingsPage+0xc4>
c0de274c:	eb09 0005 	add.w	r0, r9, r5
c0de2750:	7a45      	ldrb	r5, [r0, #9]
c0de2752:	b1ad      	cbz	r5, c0de2780 <displaySettingsPage+0xc2>
c0de2754:	3c01      	subs	r4, #1
c0de2756:	2003      	movs	r0, #3
c0de2758:	42ac      	cmp	r4, r5
c0de275a:	bf08      	it	eq
c0de275c:	2002      	moveq	r0, #2
c0de275e:	e010      	b.n	c0de2782 <displaySettingsPage+0xc4>
                 contentPage.text,
c0de2760:	e9dd 2304 	ldrd	r2, r3, [sp, #16]
                 contentPage.icon,
c0de2764:	9906      	ldr	r1, [sp, #24]
        drawStep(pos,
c0de2766:	f240 003d 	movw	r0, #61	@ 0x3d
c0de276a:	f2c0 0000 	movt	r0, #0
c0de276e:	2500      	movs	r5, #0
c0de2770:	4478      	add	r0, pc
c0de2772:	e9cd 0500 	strd	r0, r5, [sp]
c0de2776:	4630      	mov	r0, r6
c0de2778:	9502      	str	r5, [sp, #8]
c0de277a:	f7ff fb92 	bl	c0de1ea2 <drawStep>
c0de277e:	e013      	b.n	c0de27a8 <displaySettingsPage+0xea>
c0de2780:	2001      	movs	r0, #1
            pos, contentPage.text, contentPage.subText, contentPage.state, settingsCallback, false);
c0de2782:	2b00      	cmp	r3, #0
c0de2784:	bf18      	it	ne
c0de2786:	2301      	movne	r3, #1
    switchInfo.initState = state;
c0de2788:	f88d 302c 	strb.w	r3, [sp, #44]	@ 0x2c
    switchInfo.text      = title;
c0de278c:	e9cd 1209 	strd	r1, r2, [sp, #36]	@ 0x24
    nbgl_stepDrawSwitch(pos, onActionCallback, NULL, &switchInfo, modal);
c0de2790:	f240 0113 	movw	r1, #19
c0de2794:	f2c0 0100 	movt	r1, #0
    pos |= GET_POS_OF_STEP(context.currentPage, context.nbPages);
c0de2798:	4330      	orrs	r0, r6
    nbgl_stepDrawSwitch(pos, onActionCallback, NULL, &switchInfo, modal);
c0de279a:	4479      	add	r1, pc
c0de279c:	ab09      	add	r3, sp, #36	@ 0x24
c0de279e:	2200      	movs	r2, #0
c0de27a0:	f8cd c000 	str.w	ip, [sp]
c0de27a4:	f7ff f982 	bl	c0de1aac <nbgl_stepDrawSwitch>
    nbgl_refresh();
c0de27a8:	f000 fce9 	bl	c0de317e <nbgl_refresh>
}
c0de27ac:	b00c      	add	sp, #48	@ 0x30
c0de27ae:	bd70      	pop	{r4, r5, r6, pc}

c0de27b0 <settingsCallback>:
{
c0de27b0:	b580      	push	{r7, lr}
c0de27b2:	b082      	sub	sp, #8
c0de27b4:	4608      	mov	r0, r1
c0de27b6:	f10d 0107 	add.w	r1, sp, #7
    if (!buttonGenericCallback(event, &pos)) {
c0de27ba:	f000 f808 	bl	c0de27ce <buttonGenericCallback>
c0de27be:	b120      	cbz	r0, c0de27ca <settingsCallback+0x1a>
    displaySettingsPage(pos, false);
c0de27c0:	f89d 0007 	ldrb.w	r0, [sp, #7]
c0de27c4:	2100      	movs	r1, #0
c0de27c6:	f7ff ff7a 	bl	c0de26be <displaySettingsPage>
}
c0de27ca:	b002      	add	sp, #8
c0de27cc:	bd80      	pop	{r7, pc}

c0de27ce <buttonGenericCallback>:
{
c0de27ce:	b5b0      	push	{r4, r5, r7, lr}
c0de27d0:	b090      	sub	sp, #64	@ 0x40
c0de27d2:	460c      	mov	r4, r1
c0de27d4:	4605      	mov	r5, r0
c0de27d6:	a801      	add	r0, sp, #4
    nbgl_content_t        content   = {0};
c0de27d8:	2138      	movs	r1, #56	@ 0x38
c0de27da:	f001 fdb5 	bl	c0de4348 <__aeabi_memclr>
    if (event == BUTTON_LEFT_PRESSED) {
c0de27de:	2d04      	cmp	r5, #4
c0de27e0:	d00f      	beq.n	c0de2802 <buttonGenericCallback+0x34>
c0de27e2:	2d01      	cmp	r5, #1
c0de27e4:	d017      	beq.n	c0de2816 <buttonGenericCallback+0x48>
c0de27e6:	2d00      	cmp	r5, #0
c0de27e8:	f040 8096 	bne.w	c0de2918 <buttonGenericCallback+0x14a>
        if (context.currentPage > 0) {
c0de27ec:	f240 3154 	movw	r1, #852	@ 0x354
c0de27f0:	f2c0 0100 	movt	r1, #0
c0de27f4:	eb09 0001 	add.w	r0, r9, r1
c0de27f8:	7a40      	ldrb	r0, [r0, #9]
c0de27fa:	b310      	cbz	r0, c0de2842 <buttonGenericCallback+0x74>
            context.currentPage--;
c0de27fc:	1e41      	subs	r1, r0, #1
c0de27fe:	2008      	movs	r0, #8
c0de2800:	e015      	b.n	c0de282e <buttonGenericCallback+0x60>
            if (context.stepCallback != NULL) {
c0de2802:	f240 3454 	movw	r4, #852	@ 0x354
c0de2806:	f2c0 0400 	movt	r4, #0
c0de280a:	eb09 0004 	add.w	r0, r9, r4
c0de280e:	68c0      	ldr	r0, [r0, #12]
c0de2810:	b338      	cbz	r0, c0de2862 <buttonGenericCallback+0x94>
                context.stepCallback();
c0de2812:	4780      	blx	r0
c0de2814:	e080      	b.n	c0de2918 <buttonGenericCallback+0x14a>
        if (context.currentPage < (int) (context.nbPages - 1)) {
c0de2816:	f240 3054 	movw	r0, #852	@ 0x354
c0de281a:	f2c0 0000 	movt	r0, #0
c0de281e:	4448      	add	r0, r9
c0de2820:	7a01      	ldrb	r1, [r0, #8]
c0de2822:	7a40      	ldrb	r0, [r0, #9]
c0de2824:	3901      	subs	r1, #1
c0de2826:	4281      	cmp	r1, r0
c0de2828:	dd76      	ble.n	c0de2918 <buttonGenericCallback+0x14a>
            context.currentPage++;
c0de282a:	1c41      	adds	r1, r0, #1
c0de282c:	2000      	movs	r0, #0
c0de282e:	f240 3254 	movw	r2, #852	@ 0x354
c0de2832:	f2c0 0200 	movt	r2, #0
c0de2836:	444a      	add	r2, r9
c0de2838:	7251      	strb	r1, [r2, #9]
c0de283a:	7020      	strb	r0, [r4, #0]
c0de283c:	2001      	movs	r0, #1
}
c0de283e:	b010      	add	sp, #64	@ 0x40
c0de2840:	bdb0      	pop	{r4, r5, r7, pc}
        else if ((context.type != STREAMING_CONTINUE_REVIEW_USE_CASE)
c0de2842:	f819 0001 	ldrb.w	r0, [r9, r1]
                 || (context.review.skipCallback == NULL) || (context.review.nbDataSets == 1)) {
c0de2846:	2806      	cmp	r0, #6
c0de2848:	f04f 0000 	mov.w	r0, #0
c0de284c:	d1f7      	bne.n	c0de283e <buttonGenericCallback+0x70>
c0de284e:	4449      	add	r1, r9
c0de2850:	6aca      	ldr	r2, [r1, #44]	@ 0x2c
c0de2852:	2a00      	cmp	r2, #0
c0de2854:	d0f3      	beq.n	c0de283e <buttonGenericCallback+0x70>
c0de2856:	f891 1030 	ldrb.w	r1, [r1, #48]	@ 0x30
c0de285a:	2901      	cmp	r1, #1
c0de285c:	d0ef      	beq.n	c0de283e <buttonGenericCallback+0x70>
c0de285e:	2008      	movs	r0, #8
c0de2860:	e7eb      	b.n	c0de283a <buttonGenericCallback+0x6c>
            else if ((context.type == CONTENT_USE_CASE) || (context.type == SETTINGS_USE_CASE)
c0de2862:	f819 1004 	ldrb.w	r1, [r9, r4]
c0de2866:	2000      	movs	r0, #0
c0de2868:	2911      	cmp	r1, #17
c0de286a:	d8e8      	bhi.n	c0de283e <buttonGenericCallback+0x70>
c0de286c:	2201      	movs	r2, #1
c0de286e:	fa02 f101 	lsl.w	r1, r2, r1
c0de2872:	f248 0208 	movw	r2, #32776	@ 0x8008
c0de2876:	f2c0 0203 	movt	r2, #3
c0de287a:	4211      	tst	r1, r2
c0de287c:	d0df      	beq.n	c0de283e <buttonGenericCallback+0x70>
                p_content = getContentElemAtIdx(context.currentPage, &elemIdx, &content);
c0de287e:	eb09 0004 	add.w	r0, r9, r4
c0de2882:	7a40      	ldrb	r0, [r0, #9]
c0de2884:	f10d 013f 	add.w	r1, sp, #63	@ 0x3f
c0de2888:	aa01      	add	r2, sp, #4
c0de288a:	f7ff fe57 	bl	c0de253c <getContentElemAtIdx>
                if (p_content != NULL) {
c0de288e:	2800      	cmp	r0, #0
c0de2890:	d042      	beq.n	c0de2918 <buttonGenericCallback+0x14a>
                    switch (p_content->type) {
c0de2892:	7801      	ldrb	r1, [r0, #0]
c0de2894:	4602      	mov	r2, r0
c0de2896:	2905      	cmp	r1, #5
c0de2898:	f04f 0000 	mov.w	r0, #0
c0de289c:	dd0a      	ble.n	c0de28b4 <buttonGenericCallback+0xe6>
c0de289e:	2908      	cmp	r1, #8
c0de28a0:	dc11      	bgt.n	c0de28c6 <buttonGenericCallback+0xf8>
c0de28a2:	2906      	cmp	r1, #6
c0de28a4:	d01b      	beq.n	c0de28de <buttonGenericCallback+0x110>
c0de28a6:	2907      	cmp	r1, #7
c0de28a8:	f04f 0100 	mov.w	r1, #0
c0de28ac:	d126      	bne.n	c0de28fc <buttonGenericCallback+0x12e>
                            token = p_content->content.switchesList.switches->token;
c0de28ae:	6850      	ldr	r0, [r2, #4]
c0de28b0:	7a40      	ldrb	r0, [r0, #9]
c0de28b2:	e01d      	b.n	c0de28f0 <buttonGenericCallback+0x122>
                    switch (p_content->type) {
c0de28b4:	2900      	cmp	r1, #0
c0de28b6:	d0c2      	beq.n	c0de283e <buttonGenericCallback+0x70>
c0de28b8:	2903      	cmp	r1, #3
c0de28ba:	d018      	beq.n	c0de28ee <buttonGenericCallback+0x120>
c0de28bc:	2904      	cmp	r1, #4
c0de28be:	f04f 0100 	mov.w	r1, #0
c0de28c2:	d0bc      	beq.n	c0de283e <buttonGenericCallback+0x70>
c0de28c4:	e01a      	b.n	c0de28fc <buttonGenericCallback+0x12e>
c0de28c6:	2909      	cmp	r1, #9
c0de28c8:	d014      	beq.n	c0de28f4 <buttonGenericCallback+0x126>
c0de28ca:	290a      	cmp	r1, #10
c0de28cc:	f04f 0100 	mov.w	r1, #0
c0de28d0:	d114      	bne.n	c0de28fc <buttonGenericCallback+0x12e>
                            token = p_content->content.barsList.tokens[context.currentPage];
c0de28d2:	eb09 0104 	add.w	r1, r9, r4
c0de28d6:	6890      	ldr	r0, [r2, #8]
c0de28d8:	7a49      	ldrb	r1, [r1, #9]
c0de28da:	5c40      	ldrb	r0, [r0, r1]
c0de28dc:	e008      	b.n	c0de28f0 <buttonGenericCallback+0x122>
                            if (elemIdx < p_content->content.tagValueConfirm.tagValueList.nbPairs) {
c0de28de:	f89d 003f 	ldrb.w	r0, [sp, #63]	@ 0x3f
c0de28e2:	7b11      	ldrb	r1, [r2, #12]
c0de28e4:	4288      	cmp	r0, r1
c0de28e6:	d317      	bcc.n	c0de2918 <buttonGenericCallback+0x14a>
                            token = p_content->content.tagValueConfirm.confirmationToken;
c0de28e8:	f892 002c 	ldrb.w	r0, [r2, #44]	@ 0x2c
c0de28ec:	e000      	b.n	c0de28f0 <buttonGenericCallback+0x122>
                            token = p_content->content.infoButton.buttonToken;
c0de28ee:	7c10      	ldrb	r0, [r2, #16]
c0de28f0:	2100      	movs	r1, #0
c0de28f2:	e003      	b.n	c0de28fc <buttonGenericCallback+0x12e>
                            index = context.currentPage;
c0de28f4:	eb09 0104 	add.w	r1, r9, r4
                            token = p_content->content.choicesList.token;
c0de28f8:	7ad0      	ldrb	r0, [r2, #11]
                            index = context.currentPage;
c0de28fa:	7a49      	ldrb	r1, [r1, #9]
                    if ((p_content) && (p_content->contentActionCallback != NULL)) {
c0de28fc:	6b53      	ldr	r3, [r2, #52]	@ 0x34
c0de28fe:	b12b      	cbz	r3, c0de290c <buttonGenericCallback+0x13e>
                        p_content->contentActionCallback(token, 0, context.currentPage);
c0de2900:	eb09 0104 	add.w	r1, r9, r4
c0de2904:	7a4a      	ldrb	r2, [r1, #9]
c0de2906:	2100      	movs	r1, #0
c0de2908:	4798      	blx	r3
c0de290a:	e005      	b.n	c0de2918 <buttonGenericCallback+0x14a>
                    else if (context.content.controlsCallback != NULL) {
c0de290c:	eb09 0204 	add.w	r2, r9, r4
c0de2910:	6a52      	ldr	r2, [r2, #36]	@ 0x24
c0de2912:	2a00      	cmp	r2, #0
                        context.content.controlsCallback(token, index);
c0de2914:	bf18      	it	ne
c0de2916:	4790      	blxne	r2
c0de2918:	2000      	movs	r0, #0
}
c0de291a:	b010      	add	sp, #64	@ 0x40
c0de291c:	bdb0      	pop	{r4, r5, r7, pc}

c0de291e <displayHomePage>:
{
c0de291e:	b5f0      	push	{r4, r5, r6, r7, lr}
c0de2920:	b083      	sub	sp, #12
    context.stepCallback = NULL;
c0de2922:	f240 3654 	movw	r6, #852	@ 0x354
c0de2926:	f2c0 0600 	movt	r6, #0
c0de292a:	eb09 0506 	add.w	r5, r9, r6
    if (context.home.homeAction) {
c0de292e:	6a69      	ldr	r1, [r5, #36]	@ 0x24
    if (context.home.settingContents) {
c0de2930:	e9d5 2307 	ldrd	r2, r3, [r5, #28]
c0de2934:	4607      	mov	r7, r0
c0de2936:	2002      	movs	r0, #2
    if (context.home.homeAction) {
c0de2938:	2900      	cmp	r1, #0
c0de293a:	bf08      	it	eq
c0de293c:	2001      	moveq	r0, #1
    if (context.home.settingContents) {
c0de293e:	2a00      	cmp	r2, #0
c0de2940:	bf18      	it	ne
c0de2942:	2201      	movne	r2, #1
c0de2944:	4402      	add	r2, r0
c0de2946:	bf08      	it	eq
c0de2948:	f04f 30ff 	moveq.w	r0, #4294967295	@ 0xffffffff
    if (context.home.infosList) {
c0de294c:	2b00      	cmp	r3, #0
    if (context.currentPage == homeIndex) {
c0de294e:	7a6b      	ldrb	r3, [r5, #9]
c0de2950:	f04f 0400 	mov.w	r4, #0
    if (context.home.infosList) {
c0de2954:	bf08      	it	eq
c0de2956:	f04f 32ff 	moveq.w	r2, #4294967295	@ 0xffffffff
    context.stepCallback = NULL;
c0de295a:	60ec      	str	r4, [r5, #12]
    if (context.currentPage == homeIndex) {
c0de295c:	b18b      	cbz	r3, c0de2982 <displayHomePage+0x64>
c0de295e:	2501      	movs	r5, #1
    if (context.home.homeAction) {
c0de2960:	2900      	cmp	r1, #0
c0de2962:	bf08      	it	eq
c0de2964:	25ff      	moveq	r5, #255	@ 0xff
    else if (context.currentPage == actionIndex) {
c0de2966:	429d      	cmp	r5, r3
c0de2968:	d112      	bne.n	c0de2990 <displayHomePage+0x72>
        text                 = PIC(context.home.homeAction->text);
c0de296a:	e9d1 0500 	ldrd	r0, r5, [r1]
c0de296e:	f001 fb1b 	bl	c0de3fa8 <pic>
        context.stepCallback = context.home.homeAction->callback;
c0de2972:	eb09 0106 	add.w	r1, r9, r6
c0de2976:	6a4a      	ldr	r2, [r1, #36]	@ 0x24
c0de2978:	6893      	ldr	r3, [r2, #8]
        text                 = PIC(context.home.homeAction->text);
c0de297a:	4602      	mov	r2, r0
        context.stepCallback = context.home.homeAction->callback;
c0de297c:	60cb      	str	r3, [r1, #12]
c0de297e:	2300      	movs	r3, #0
c0de2980:	e04c      	b.n	c0de2a1c <displayHomePage+0xfe>
        icon = context.home.appIcon;
c0de2982:	eb09 0006 	add.w	r0, r9, r6
c0de2986:	e9d0 5205 	ldrd	r5, r2, [r0, #20]
        if (context.home.tagline != NULL) {
c0de298a:	b37a      	cbz	r2, c0de29ec <displayHomePage+0xce>
c0de298c:	2300      	movs	r3, #0
c0de298e:	e045      	b.n	c0de2a1c <displayHomePage+0xfe>
    else if (context.currentPage == settingsIndex) {
c0de2990:	b2c0      	uxtb	r0, r0
c0de2992:	4283      	cmp	r3, r0
c0de2994:	d113      	bne.n	c0de29be <displayHomePage+0xa0>
        context.stepCallback = startUseCaseSettings;
c0de2996:	f240 0199 	movw	r1, #153	@ 0x99
c0de299a:	f2c0 0100 	movt	r1, #0
c0de299e:	eb09 0006 	add.w	r0, r9, r6
c0de29a2:	4479      	add	r1, pc
c0de29a4:	60c1      	str	r1, [r0, #12]
c0de29a6:	f641 351a 	movw	r5, #6938	@ 0x1b1a
c0de29aa:	f2c0 0500 	movt	r5, #0
c0de29ae:	f641 520a 	movw	r2, #7434	@ 0x1d0a
c0de29b2:	f2c0 0200 	movt	r2, #0
c0de29b6:	447d      	add	r5, pc
c0de29b8:	2300      	movs	r3, #0
c0de29ba:	447a      	add	r2, pc
c0de29bc:	e02e      	b.n	c0de2a1c <displayHomePage+0xfe>
    else if (context.currentPage == infoIndex) {
c0de29be:	b2d0      	uxtb	r0, r2
c0de29c0:	4283      	cmp	r3, r0
c0de29c2:	d11c      	bne.n	c0de29fe <displayHomePage+0xe0>
        context.stepCallback = startUseCaseInfo;
c0de29c4:	f240 0175 	movw	r1, #117	@ 0x75
c0de29c8:	f2c0 0100 	movt	r1, #0
c0de29cc:	eb09 0006 	add.w	r0, r9, r6
c0de29d0:	4479      	add	r1, pc
c0de29d2:	60c1      	str	r1, [r0, #12]
c0de29d4:	f641 2557 	movw	r5, #6743	@ 0x1a57
c0de29d8:	f2c0 0500 	movt	r5, #0
c0de29dc:	f641 5263 	movw	r2, #7523	@ 0x1d63
c0de29e0:	f2c0 0200 	movt	r2, #0
c0de29e4:	447d      	add	r5, pc
c0de29e6:	2300      	movs	r3, #0
c0de29e8:	447a      	add	r2, pc
c0de29ea:	e017      	b.n	c0de2a1c <displayHomePage+0xfe>
            text    = context.home.appName;
c0de29ec:	eb09 0006 	add.w	r0, r9, r6
c0de29f0:	6902      	ldr	r2, [r0, #16]
c0de29f2:	f641 5363 	movw	r3, #7523	@ 0x1d63
c0de29f6:	f2c0 0300 	movt	r3, #0
c0de29fa:	447b      	add	r3, pc
c0de29fc:	e00e      	b.n	c0de2a1c <displayHomePage+0xfe>
        context.stepCallback = context.home.quitCallback;
c0de29fe:	eb09 0006 	add.w	r0, r9, r6
c0de2a02:	6a81      	ldr	r1, [r0, #40]	@ 0x28
c0de2a04:	2300      	movs	r3, #0
c0de2a06:	60c1      	str	r1, [r0, #12]
c0de2a08:	f641 2546 	movw	r5, #6726	@ 0x1a46
c0de2a0c:	f2c0 0500 	movt	r5, #0
c0de2a10:	f641 5250 	movw	r2, #7504	@ 0x1d50
c0de2a14:	f2c0 0200 	movt	r2, #0
c0de2a18:	447d      	add	r5, pc
c0de2a1a:	447a      	add	r2, pc
    drawStep(pos, icon, text, subText, homeCallback, false, NO_FORCED_TYPE);
c0de2a1c:	f240 0047 	movw	r0, #71	@ 0x47
c0de2a20:	f2c0 0000 	movt	r0, #0
c0de2a24:	2600      	movs	r6, #0
c0de2a26:	4478      	add	r0, pc
c0de2a28:	e9cd 0600 	strd	r0, r6, [sp]
c0de2a2c:	4638      	mov	r0, r7
c0de2a2e:	4629      	mov	r1, r5
c0de2a30:	9602      	str	r6, [sp, #8]
c0de2a32:	f7ff fa36 	bl	c0de1ea2 <drawStep>
    nbgl_refresh();
c0de2a36:	f000 fba2 	bl	c0de317e <nbgl_refresh>
}
c0de2a3a:	b003      	add	sp, #12
c0de2a3c:	bdf0      	pop	{r4, r5, r6, r7, pc}

c0de2a3e <startUseCaseSettings>:
{
c0de2a3e:	b580      	push	{r7, lr}
    startUseCaseSettingsAtPage(0);
c0de2a40:	2000      	movs	r0, #0
c0de2a42:	f7ff f98d 	bl	c0de1d60 <startUseCaseSettingsAtPage>
}
c0de2a46:	bd80      	pop	{r7, pc}

c0de2a48 <startUseCaseInfo>:
{
c0de2a48:	b580      	push	{r7, lr}
    context.type        = INFO_USE_CASE;
c0de2a4a:	f240 3054 	movw	r0, #852	@ 0x354
c0de2a4e:	f2c0 0000 	movt	r0, #0
c0de2a52:	eb09 0100 	add.w	r1, r9, r0
    context.nbPages     = context.home.infosList->nbInfos + 1;  // For back screen
c0de2a56:	6a0a      	ldr	r2, [r1, #32]
c0de2a58:	230e      	movs	r3, #14
c0de2a5a:	7b12      	ldrb	r2, [r2, #12]
    context.type        = INFO_USE_CASE;
c0de2a5c:	f809 3000 	strb.w	r3, [r9, r0]
    context.nbPages     = context.home.infosList->nbInfos + 1;  // For back screen
c0de2a60:	1c50      	adds	r0, r2, #1
c0de2a62:	7208      	strb	r0, [r1, #8]
c0de2a64:	2000      	movs	r0, #0
    context.currentPage = 0;
c0de2a66:	7248      	strb	r0, [r1, #9]
    displayInfoPage(FORWARD_DIRECTION);
c0de2a68:	2000      	movs	r0, #0
c0de2a6a:	f000 f80f 	bl	c0de2a8c <displayInfoPage>
}
c0de2a6e:	bd80      	pop	{r7, pc}

c0de2a70 <homeCallback>:
{
c0de2a70:	b580      	push	{r7, lr}
c0de2a72:	b082      	sub	sp, #8
c0de2a74:	4608      	mov	r0, r1
c0de2a76:	f10d 0107 	add.w	r1, sp, #7
    if (!buttonGenericCallback(event, &pos)) {
c0de2a7a:	f7ff fea8 	bl	c0de27ce <buttonGenericCallback>
c0de2a7e:	b118      	cbz	r0, c0de2a88 <homeCallback+0x18>
    displayHomePage(pos);
c0de2a80:	f89d 0007 	ldrb.w	r0, [sp, #7]
c0de2a84:	f7ff ff4b 	bl	c0de291e <displayHomePage>
}
c0de2a88:	b002      	add	sp, #8
c0de2a8a:	bd80      	pop	{r7, pc}

c0de2a8c <displayInfoPage>:
{
c0de2a8c:	b570      	push	{r4, r5, r6, lr}
c0de2a8e:	b084      	sub	sp, #16
c0de2a90:	4604      	mov	r4, r0
    context.stepCallback = NULL;
c0de2a92:	f240 3054 	movw	r0, #852	@ 0x354
c0de2a96:	f2c0 0000 	movt	r0, #0
c0de2a9a:	eb09 0100 	add.w	r1, r9, r0
    if (context.currentPage < (context.nbPages - 1)) {
c0de2a9e:	7a0a      	ldrb	r2, [r1, #8]
c0de2aa0:	7a4b      	ldrb	r3, [r1, #9]
c0de2aa2:	3a01      	subs	r2, #1
c0de2aa4:	429a      	cmp	r2, r3
c0de2aa6:	f04f 0200 	mov.w	r2, #0
    context.stepCallback = NULL;
c0de2aaa:	60ca      	str	r2, [r1, #12]
    if (context.currentPage < (context.nbPages - 1)) {
c0de2aac:	dd18      	ble.n	c0de2ae0 <displayInfoPage+0x54>
        text = PIC(
c0de2aae:	eb09 0600 	add.w	r6, r9, r0
c0de2ab2:	6a30      	ldr	r0, [r6, #32]
c0de2ab4:	6800      	ldr	r0, [r0, #0]
c0de2ab6:	f001 fa77 	bl	c0de3fa8 <pic>
c0de2aba:	7a71      	ldrb	r1, [r6, #9]
c0de2abc:	f850 0021 	ldr.w	r0, [r0, r1, lsl #2]
c0de2ac0:	f001 fa72 	bl	c0de3fa8 <pic>
        subText = PIC(
c0de2ac4:	6a31      	ldr	r1, [r6, #32]
        text = PIC(
c0de2ac6:	4605      	mov	r5, r0
        subText = PIC(
c0de2ac8:	6849      	ldr	r1, [r1, #4]
c0de2aca:	4608      	mov	r0, r1
c0de2acc:	f001 fa6c 	bl	c0de3fa8 <pic>
c0de2ad0:	7a71      	ldrb	r1, [r6, #9]
c0de2ad2:	f850 0021 	ldr.w	r0, [r0, r1, lsl #2]
c0de2ad6:	f001 fa67 	bl	c0de3fa8 <pic>
c0de2ada:	4603      	mov	r3, r0
c0de2adc:	2100      	movs	r1, #0
c0de2ade:	e011      	b.n	c0de2b04 <displayInfoPage+0x78>
        context.stepCallback = startUseCaseHome;
c0de2ae0:	f24f 3127 	movw	r1, #62247	@ 0xf327
c0de2ae4:	f6cf 71ff 	movt	r1, #65535	@ 0xffff
c0de2ae8:	4448      	add	r0, r9
c0de2aea:	4479      	add	r1, pc
c0de2aec:	60c1      	str	r1, [r0, #12]
c0de2aee:	f641 11af 	movw	r1, #6575	@ 0x19af
c0de2af2:	f2c0 0100 	movt	r1, #0
c0de2af6:	f641 4519 	movw	r5, #7193	@ 0x1c19
c0de2afa:	f2c0 0500 	movt	r5, #0
c0de2afe:	4479      	add	r1, pc
c0de2b00:	2300      	movs	r3, #0
c0de2b02:	447d      	add	r5, pc
    drawStep(pos, icon, text, subText, infoCallback, false, FORCE_CENTERED_INFO);
c0de2b04:	f240 0217 	movw	r2, #23
c0de2b08:	f2c0 0200 	movt	r2, #0
c0de2b0c:	2000      	movs	r0, #0
c0de2b0e:	447a      	add	r2, pc
c0de2b10:	2602      	movs	r6, #2
c0de2b12:	e9cd 2000 	strd	r2, r0, [sp]
c0de2b16:	4620      	mov	r0, r4
c0de2b18:	462a      	mov	r2, r5
c0de2b1a:	9602      	str	r6, [sp, #8]
c0de2b1c:	f7ff f9c1 	bl	c0de1ea2 <drawStep>
    nbgl_refresh();
c0de2b20:	f000 fb2d 	bl	c0de317e <nbgl_refresh>
}
c0de2b24:	b004      	add	sp, #16
c0de2b26:	bd70      	pop	{r4, r5, r6, pc}

c0de2b28 <infoCallback>:
{
c0de2b28:	b580      	push	{r7, lr}
c0de2b2a:	b082      	sub	sp, #8
c0de2b2c:	4608      	mov	r0, r1
c0de2b2e:	f10d 0107 	add.w	r1, sp, #7
    if (!buttonGenericCallback(event, &pos)) {
c0de2b32:	f7ff fe4c 	bl	c0de27ce <buttonGenericCallback>
c0de2b36:	b118      	cbz	r0, c0de2b40 <infoCallback+0x18>
    displayInfoPage(pos);
c0de2b38:	f89d 0007 	ldrb.w	r0, [sp, #7]
c0de2b3c:	f7ff ffa6 	bl	c0de2a8c <displayInfoPage>
}
c0de2b40:	b002      	add	sp, #8
c0de2b42:	bd80      	pop	{r7, pc}

c0de2b44 <statusTickerCallback>:
{
c0de2b44:	b580      	push	{r7, lr}
    if (context.stepCallback != NULL) {
c0de2b46:	f240 3054 	movw	r0, #852	@ 0x354
c0de2b4a:	f2c0 0000 	movt	r0, #0
c0de2b4e:	4448      	add	r0, r9
c0de2b50:	68c0      	ldr	r0, [r0, #12]
c0de2b52:	2800      	cmp	r0, #0
        context.stepCallback();
c0de2b54:	bf18      	it	ne
c0de2b56:	4780      	blxne	r0
}
c0de2b58:	bd80      	pop	{r7, pc}

c0de2b5a <getChoiceName>:
{
c0de2b5a:	b5b0      	push	{r4, r5, r7, lr}
c0de2b5c:	b090      	sub	sp, #64	@ 0x40
c0de2b5e:	ad01      	add	r5, sp, #4
c0de2b60:	4604      	mov	r4, r0
    nbgl_content_t             content        = {0};
c0de2b62:	4628      	mov	r0, r5
c0de2b64:	2138      	movs	r1, #56	@ 0x38
c0de2b66:	f001 fbef 	bl	c0de4348 <__aeabi_memclr>
    p_content = getContentElemAtIdx(context.currentPage, &elemIdx, &content);
c0de2b6a:	f240 3054 	movw	r0, #852	@ 0x354
c0de2b6e:	f2c0 0000 	movt	r0, #0
c0de2b72:	4448      	add	r0, r9
c0de2b74:	7a40      	ldrb	r0, [r0, #9]
c0de2b76:	f10d 013f 	add.w	r1, sp, #63	@ 0x3f
c0de2b7a:	462a      	mov	r2, r5
c0de2b7c:	f7ff fcde 	bl	c0de253c <getContentElemAtIdx>
    if (p_content == NULL) {
c0de2b80:	b158      	cbz	r0, c0de2b9a <getChoiceName+0x40>
    switch (p_content->type) {
c0de2b82:	7801      	ldrb	r1, [r0, #0]
c0de2b84:	290a      	cmp	r1, #10
c0de2b86:	d00b      	beq.n	c0de2ba0 <getChoiceName+0x46>
c0de2b88:	2909      	cmp	r1, #9
c0de2b8a:	d106      	bne.n	c0de2b9a <getChoiceName+0x40>
            contentChoices = (nbgl_contentRadioChoice_t *) PIC(&p_content->content.choicesList);
c0de2b8c:	3004      	adds	r0, #4
c0de2b8e:	f001 fa0b 	bl	c0de3fa8 <pic>
c0de2b92:	4605      	mov	r5, r0
            names          = (char **) PIC(contentChoices->names);
c0de2b94:	f855 0b05 	ldr.w	r0, [r5], #5
c0de2b98:	e008      	b.n	c0de2bac <getChoiceName+0x52>
c0de2b9a:	2000      	movs	r0, #0
}
c0de2b9c:	b010      	add	sp, #64	@ 0x40
c0de2b9e:	bdb0      	pop	{r4, r5, r7, pc}
            contentBars = ((nbgl_contentBarsList_t *) PIC(&p_content->content.barsList));
c0de2ba0:	3004      	adds	r0, #4
c0de2ba2:	f001 fa01 	bl	c0de3fa8 <pic>
c0de2ba6:	4605      	mov	r5, r0
            names       = (char **) PIC(contentBars->barTexts);
c0de2ba8:	f855 0b08 	ldr.w	r0, [r5], #8
c0de2bac:	f001 f9fc 	bl	c0de3fa8 <pic>
c0de2bb0:	7829      	ldrb	r1, [r5, #0]
    if (choiceIndex >= nbValues) {
c0de2bb2:	42a1      	cmp	r1, r4
c0de2bb4:	d905      	bls.n	c0de2bc2 <getChoiceName+0x68>
    return (const char *) PIC(names[choiceIndex]);
c0de2bb6:	f850 0024 	ldr.w	r0, [r0, r4, lsl #2]
c0de2bba:	f001 f9f5 	bl	c0de3fa8 <pic>
}
c0de2bbe:	b010      	add	sp, #64	@ 0x40
c0de2bc0:	bdb0      	pop	{r4, r5, r7, pc}
c0de2bc2:	f641 3051 	movw	r0, #6993	@ 0x1b51
c0de2bc6:	f2c0 0000 	movt	r0, #0
c0de2bca:	4478      	add	r0, pc
c0de2bcc:	b010      	add	sp, #64	@ 0x40
c0de2bce:	bdb0      	pop	{r4, r5, r7, pc}

c0de2bd0 <onChoiceSelected>:
{
c0de2bd0:	b570      	push	{r4, r5, r6, lr}
c0de2bd2:	b090      	sub	sp, #64	@ 0x40
c0de2bd4:	ad01      	add	r5, sp, #4
c0de2bd6:	4604      	mov	r4, r0
    nbgl_content_t             content        = {0};
c0de2bd8:	4628      	mov	r0, r5
c0de2bda:	2138      	movs	r1, #56	@ 0x38
c0de2bdc:	f001 fbb4 	bl	c0de4348 <__aeabi_memclr>
    p_content = getContentElemAtIdx(context.currentPage, &elemIdx, &content);
c0de2be0:	f240 3654 	movw	r6, #852	@ 0x354
c0de2be4:	f2c0 0600 	movt	r6, #0
c0de2be8:	eb09 0006 	add.w	r0, r9, r6
c0de2bec:	7a40      	ldrb	r0, [r0, #9]
c0de2bee:	f10d 013f 	add.w	r1, sp, #63	@ 0x3f
c0de2bf2:	462a      	mov	r2, r5
c0de2bf4:	f7ff fca2 	bl	c0de253c <getContentElemAtIdx>
    if (p_content == NULL) {
c0de2bf8:	b348      	cbz	r0, c0de2c4e <onChoiceSelected+0x7e>
    switch (p_content->type) {
c0de2bfa:	7801      	ldrb	r1, [r0, #0]
c0de2bfc:	290a      	cmp	r1, #10
c0de2bfe:	d009      	beq.n	c0de2c14 <onChoiceSelected+0x44>
c0de2c00:	2909      	cmp	r1, #9
c0de2c02:	d113      	bne.n	c0de2c2c <onChoiceSelected+0x5c>
            contentChoices = (nbgl_contentRadioChoice_t *) PIC(&p_content->content.choicesList);
c0de2c04:	3004      	adds	r0, #4
c0de2c06:	f001 f9cf 	bl	c0de3fa8 <pic>
            if (choiceIndex < contentChoices->nbChoices) {
c0de2c0a:	7941      	ldrb	r1, [r0, #5]
c0de2c0c:	42a1      	cmp	r1, r4
c0de2c0e:	d90d      	bls.n	c0de2c2c <onChoiceSelected+0x5c>
                token = contentChoices->token;
c0de2c10:	3007      	adds	r0, #7
c0de2c12:	e007      	b.n	c0de2c24 <onChoiceSelected+0x54>
            contentBars = ((nbgl_contentBarsList_t *) PIC(&p_content->content.barsList));
c0de2c14:	3004      	adds	r0, #4
c0de2c16:	f001 f9c7 	bl	c0de3fa8 <pic>
            if (choiceIndex < contentBars->nbBars) {
c0de2c1a:	7a01      	ldrb	r1, [r0, #8]
c0de2c1c:	42a1      	cmp	r1, r4
c0de2c1e:	d905      	bls.n	c0de2c2c <onChoiceSelected+0x5c>
                token = contentBars->tokens[choiceIndex];
c0de2c20:	6840      	ldr	r0, [r0, #4]
c0de2c22:	4420      	add	r0, r4
c0de2c24:	7800      	ldrb	r0, [r0, #0]
    if ((token != 255) && (context.content.controlsCallback != NULL)) {
c0de2c26:	28ff      	cmp	r0, #255	@ 0xff
c0de2c28:	d103      	bne.n	c0de2c32 <onChoiceSelected+0x62>
c0de2c2a:	e00a      	b.n	c0de2c42 <onChoiceSelected+0x72>
c0de2c2c:	20ff      	movs	r0, #255	@ 0xff
c0de2c2e:	28ff      	cmp	r0, #255	@ 0xff
c0de2c30:	d007      	beq.n	c0de2c42 <onChoiceSelected+0x72>
c0de2c32:	eb09 0106 	add.w	r1, r9, r6
c0de2c36:	6a4a      	ldr	r2, [r1, #36]	@ 0x24
c0de2c38:	b11a      	cbz	r2, c0de2c42 <onChoiceSelected+0x72>
        context.content.controlsCallback(token, 0);
c0de2c3a:	2100      	movs	r1, #0
c0de2c3c:	4790      	blx	r2
}
c0de2c3e:	b010      	add	sp, #64	@ 0x40
c0de2c40:	bd70      	pop	{r4, r5, r6, pc}
    else if (context.content.quitCallback != NULL) {
c0de2c42:	eb09 0006 	add.w	r0, r9, r6
c0de2c46:	6ac0      	ldr	r0, [r0, #44]	@ 0x2c
c0de2c48:	2800      	cmp	r0, #0
        context.content.quitCallback();
c0de2c4a:	bf18      	it	ne
c0de2c4c:	4780      	blxne	r0
}
c0de2c4e:	b010      	add	sp, #64	@ 0x40
c0de2c50:	bd70      	pop	{r4, r5, r6, pc}

c0de2c52 <onChoiceAccept>:
{
c0de2c52:	b580      	push	{r7, lr}
    if (context.choice.onChoice) {
c0de2c54:	f240 3054 	movw	r0, #852	@ 0x354
c0de2c58:	f2c0 0000 	movt	r0, #0
c0de2c5c:	4448      	add	r0, r9
c0de2c5e:	6a41      	ldr	r1, [r0, #36]	@ 0x24
c0de2c60:	2900      	cmp	r1, #0
}
c0de2c62:	bf08      	it	eq
c0de2c64:	bd80      	popeq	{r7, pc}
        context.choice.onChoice(true);
c0de2c66:	2001      	movs	r0, #1
c0de2c68:	4788      	blx	r1
}
c0de2c6a:	bd80      	pop	{r7, pc}

c0de2c6c <onChoiceReject>:
{
c0de2c6c:	b580      	push	{r7, lr}
    if (context.choice.onChoice) {
c0de2c6e:	f240 3054 	movw	r0, #852	@ 0x354
c0de2c72:	f2c0 0000 	movt	r0, #0
c0de2c76:	4448      	add	r0, r9
c0de2c78:	6a41      	ldr	r1, [r0, #36]	@ 0x24
c0de2c7a:	2900      	cmp	r1, #0
}
c0de2c7c:	bf08      	it	eq
c0de2c7e:	bd80      	popeq	{r7, pc}
        context.choice.onChoice(false);
c0de2c80:	2000      	movs	r0, #0
c0de2c82:	4788      	blx	r1
}
c0de2c84:	bd80      	pop	{r7, pc}

c0de2c86 <genericChoiceCallback>:
{
c0de2c86:	b580      	push	{r7, lr}
c0de2c88:	b082      	sub	sp, #8
c0de2c8a:	4608      	mov	r0, r1
c0de2c8c:	f10d 0107 	add.w	r1, sp, #7
    if (!buttonGenericCallback(event, &pos)) {
c0de2c90:	f7ff fd9d 	bl	c0de27ce <buttonGenericCallback>
c0de2c94:	b118      	cbz	r0, c0de2c9e <genericChoiceCallback+0x18>
    displayChoicePage(pos);
c0de2c96:	f89d 0007 	ldrb.w	r0, [sp, #7]
c0de2c9a:	f7ff f9f5 	bl	c0de2088 <displayChoicePage>
}
c0de2c9e:	b002      	add	sp, #8
c0de2ca0:	bd80      	pop	{r7, pc}

c0de2ca2 <buffer_copy>:

    return true;
}

bool buffer_copy(const buffer_t *buffer, uint8_t *out, size_t out_len)
{
c0de2ca2:	b5b0      	push	{r4, r5, r7, lr}
    if (buffer->size - buffer->offset > out_len) {
c0de2ca4:	e9d0 5301 	ldrd	r5, r3, [r0, #4]
c0de2ca8:	4614      	mov	r4, r2
c0de2caa:	1aed      	subs	r5, r5, r3
c0de2cac:	4295      	cmp	r5, r2
c0de2cae:	d806      	bhi.n	c0de2cbe <buffer_copy+0x1c>
        return false;
    }

    memmove(out, buffer->ptr + buffer->offset, buffer->size - buffer->offset);
c0de2cb0:	6800      	ldr	r0, [r0, #0]
c0de2cb2:	18c2      	adds	r2, r0, r3
c0de2cb4:	4608      	mov	r0, r1
c0de2cb6:	4611      	mov	r1, r2
c0de2cb8:	462a      	mov	r2, r5
c0de2cba:	f001 fb3d 	bl	c0de4338 <__aeabi_memmove>
c0de2cbe:	2000      	movs	r0, #0
    if (buffer->size - buffer->offset > out_len) {
c0de2cc0:	42a5      	cmp	r5, r4
c0de2cc2:	bf98      	it	ls
c0de2cc4:	2001      	movls	r0, #1

    return true;
}
c0de2cc6:	bdb0      	pop	{r4, r5, r7, pc}

c0de2cc8 <app_ticker_event_callback>:
    io_seph_ux_display_bagl_element(element);
}
#endif  // HAVE_BAGL

// This function can be used to declare a callback to SEPROXYHAL_TAG_TICKER_EVENT in the application
WEAK void app_ticker_event_callback(void) {}
c0de2cc8:	4770      	bx	lr

c0de2cca <io_event>:

WEAK unsigned char io_event(unsigned char channel)
{
c0de2cca:	b580      	push	{r7, lr}
    UNUSED(channel);
    switch (G_io_seproxyhal_spi_buffer[0]) {
c0de2ccc:	f240 3094 	movw	r0, #916	@ 0x394
c0de2cd0:	f2c0 0000 	movt	r0, #0
c0de2cd4:	f819 1000 	ldrb.w	r1, [r9, r0]
c0de2cd8:	290e      	cmp	r1, #14
c0de2cda:	d006      	beq.n	c0de2cea <io_event+0x20>
c0de2cdc:	2905      	cmp	r1, #5
c0de2cde:	d10a      	bne.n	c0de2cf6 <io_event+0x2c>
        case SEPROXYHAL_TAG_BUTTON_PUSH_EVENT:
            UX_BUTTON_PUSH_EVENT(G_io_seproxyhal_spi_buffer);
c0de2ce0:	4448      	add	r0, r9
c0de2ce2:	f000 f904 	bl	c0de2eee <ux_process_button_event>
        default:
            UX_DEFAULT_EVENT();
            break;
    }

    return 1;
c0de2ce6:	2001      	movs	r0, #1
c0de2ce8:	bd80      	pop	{r7, pc}
            app_ticker_event_callback();
c0de2cea:	f7ff ffed 	bl	c0de2cc8 <app_ticker_event_callback>
            UX_TICKER_EVENT(G_io_seproxyhal_spi_buffer, {});
c0de2cee:	f000 f93b 	bl	c0de2f68 <ux_process_ticker_event>
    return 1;
c0de2cf2:	2001      	movs	r0, #1
c0de2cf4:	bd80      	pop	{r7, pc}
            UX_DEFAULT_EVENT();
c0de2cf6:	f000 f973 	bl	c0de2fe0 <ux_process_default_event>
    return 1;
c0de2cfa:	2001      	movs	r0, #1
c0de2cfc:	bd80      	pop	{r7, pc}

c0de2cfe <io_init>:
}

WEAK void io_init()
{
    need_to_start_io = 1;
c0de2cfe:	f240 40a4 	movw	r0, #1188	@ 0x4a4
c0de2d02:	f2c0 0000 	movt	r0, #0
c0de2d06:	2101      	movs	r1, #1
c0de2d08:	f809 1000 	strb.w	r1, [r9, r0]
}
c0de2d0c:	4770      	bx	lr
	...

c0de2d10 <io_recv_command>:

WEAK int io_recv_command()
{
c0de2d10:	b510      	push	{r4, lr}
    int status = 0;

    if (need_to_start_io) {
c0de2d12:	f240 44a4 	movw	r4, #1188	@ 0x4a4
c0de2d16:	f2c0 0400 	movt	r4, #0
c0de2d1a:	f819 0004 	ldrb.w	r0, [r9, r4]
c0de2d1e:	2801      	cmp	r0, #1
c0de2d20:	d104      	bne.n	c0de2d2c <io_recv_command+0x1c>
#ifndef USE_OS_IO_STACK
        io_seproxyhal_io_heartbeat();
        io_seproxyhal_io_heartbeat();
        io_seproxyhal_io_heartbeat();
#endif  // USE_OS_IO_STACK
        os_io_start();
c0de2d22:	f001 f9cd 	bl	c0de40c0 <os_io_start>
c0de2d26:	2000      	movs	r0, #0
        need_to_start_io = 0;
c0de2d28:	f809 0004 	strb.w	r0, [r9, r4]
#ifdef FUZZING
    for (uint8_t retries = 5; retries && status <= 0; retries--) {
#else
    while (status <= 0) {
#endif
        status = io_legacy_apdu_rx(1);
c0de2d2c:	2001      	movs	r0, #1
c0de2d2e:	f7fd fbca 	bl	c0de04c6 <io_legacy_apdu_rx>
    while (status <= 0) {
c0de2d32:	2801      	cmp	r0, #1
c0de2d34:	dbfa      	blt.n	c0de2d2c <io_recv_command+0x1c>
    }

    return status;
c0de2d36:	bd10      	pop	{r4, pc}

c0de2d38 <io_send_response_buffers>:
}

WEAK int io_send_response_buffers(const buffer_t *rdatalist, size_t count, uint16_t sw)
{
c0de2d38:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de2d3c:	b082      	sub	sp, #8
c0de2d3e:	4690      	mov	r8, r2
    int    status = 0;
    size_t length = 0;

    if (rdatalist && count > 0) {
c0de2d40:	2800      	cmp	r0, #0
c0de2d42:	d058      	beq.n	c0de2df6 <io_send_response_buffers+0xbe>
c0de2d44:	460e      	mov	r6, r1
c0de2d46:	2900      	cmp	r1, #0
c0de2d48:	d055      	beq.n	c0de2df6 <io_send_response_buffers+0xbe>
c0de2d4a:	4607      	mov	r7, r0
c0de2d4c:	f8cd 8004 	str.w	r8, [sp, #4]
c0de2d50:	f04f 0a00 	mov.w	sl, #0
c0de2d54:	f04f 0801 	mov.w	r8, #1
c0de2d58:	2500      	movs	r5, #0
c0de2d5a:	bf00      	nop
        for (size_t i = 0; i < count; i++) {
            const buffer_t *rdata = &rdatalist[i];

            if (!buffer_copy(rdata, G_io_tx_buffer + length, sizeof(G_io_tx_buffer) - length - 2)) {
c0de2d5c:	f240 0000 	movw	r0, #0
c0de2d60:	f2c0 0000 	movt	r0, #0
c0de2d64:	4448      	add	r0, r9
c0de2d66:	1941      	adds	r1, r0, r5
c0de2d68:	f240 100f 	movw	r0, #271	@ 0x10f
c0de2d6c:	1b42      	subs	r2, r0, r5
c0de2d6e:	4638      	mov	r0, r7
c0de2d70:	f7ff ff97 	bl	c0de2ca2 <buffer_copy>
c0de2d74:	4604      	mov	r4, r0
c0de2d76:	b1a8      	cbz	r0, c0de2da4 <io_send_response_buffers+0x6c>
                return io_send_sw(SWO_INSUFFICIENT_MEMORY);
            }
            length += rdata->size - rdata->offset;
c0de2d78:	e9d7 3001 	ldrd	r3, r0, [r7, #4]
            if (count > 1) {
c0de2d7c:	2e02      	cmp	r6, #2
            length += rdata->size - rdata->offset;
c0de2d7e:	eba3 0000 	sub.w	r0, r3, r0
c0de2d82:	4405      	add	r5, r0
            if (count > 1) {
c0de2d84:	d315      	bcc.n	c0de2db2 <io_send_response_buffers+0x7a>
                PRINTF("<= FRAG (%u/%u) RData=%.*H\n", i + 1, count, rdata->size, rdata->ptr);
c0de2d86:	f8d7 c000 	ldr.w	ip, [r7]
c0de2d8a:	f641 007f 	movw	r0, #6271	@ 0x187f
c0de2d8e:	f2c0 0000 	movt	r0, #0
c0de2d92:	f10a 0101 	add.w	r1, sl, #1
c0de2d96:	4478      	add	r0, pc
c0de2d98:	4632      	mov	r2, r6
c0de2d9a:	f8cd c000 	str.w	ip, [sp]
c0de2d9e:	f000 fa73 	bl	c0de3288 <mcu_usb_printf>
c0de2da2:	e006      	b.n	c0de2db2 <io_send_response_buffers+0x7a>
    return io_send_response_buffers(NULL, 0, sw);
c0de2da4:	2000      	movs	r0, #0
c0de2da6:	2100      	movs	r1, #0
c0de2da8:	f646 2284 	movw	r2, #27268	@ 0x6a84
c0de2dac:	f7ff ffc4 	bl	c0de2d38 <io_send_response_buffers>
c0de2db0:	4683      	mov	fp, r0
c0de2db2:	b15c      	cbz	r4, c0de2dcc <io_send_response_buffers+0x94>
c0de2db4:	f10a 0a01 	add.w	sl, sl, #1
        for (size_t i = 0; i < count; i++) {
c0de2db8:	45b2      	cmp	sl, r6
c0de2dba:	f04f 0800 	mov.w	r8, #0
c0de2dbe:	bf38      	it	cc
c0de2dc0:	f04f 0801 	movcc.w	r8, #1
c0de2dc4:	4556      	cmp	r6, sl
c0de2dc6:	f107 070c 	add.w	r7, r7, #12
c0de2dca:	d1c7      	bne.n	c0de2d5c <io_send_response_buffers+0x24>
c0de2dcc:	ea5f 70c8 	movs.w	r0, r8, lsl #31
c0de2dd0:	d12c      	bne.n	c0de2e2c <io_send_response_buffers+0xf4>
            }
        }
        PRINTF("<= SW=%04X | RData=%.*H\n", sw, length, G_io_tx_buffer);
c0de2dd2:	f240 0000 	movw	r0, #0
c0de2dd6:	f2c0 0000 	movt	r0, #0
c0de2dda:	eb09 0300 	add.w	r3, r9, r0
c0de2dde:	f641 0012 	movw	r0, #6162	@ 0x1812
c0de2de2:	f2c0 0000 	movt	r0, #0
c0de2de6:	f8dd 8004 	ldr.w	r8, [sp, #4]
c0de2dea:	4478      	add	r0, pc
c0de2dec:	4641      	mov	r1, r8
c0de2dee:	462a      	mov	r2, r5
c0de2df0:	f000 fa4a 	bl	c0de3288 <mcu_usb_printf>
c0de2df4:	e008      	b.n	c0de2e08 <io_send_response_buffers+0xd0>
    }
    else {
        PRINTF("<= SW=%04X | RData=\n", sw);
c0de2df6:	f641 1022 	movw	r0, #6434	@ 0x1922
c0de2dfa:	f2c0 0000 	movt	r0, #0
c0de2dfe:	4478      	add	r0, pc
c0de2e00:	4641      	mov	r1, r8
c0de2e02:	f000 fa41 	bl	c0de3288 <mcu_usb_printf>
c0de2e06:	2500      	movs	r5, #0
    }

    write_u16_be(G_io_tx_buffer, length, sw);
c0de2e08:	f240 0000 	movw	r0, #0
c0de2e0c:	f2c0 0000 	movt	r0, #0
c0de2e10:	eb09 0400 	add.w	r4, r9, r0
c0de2e14:	4620      	mov	r0, r4
c0de2e16:	4629      	mov	r1, r5
c0de2e18:	4642      	mov	r2, r8
c0de2e1a:	f000 f861 	bl	c0de2ee0 <write_u16_be>
            os_sched_exit(-1);
        }
    }
#endif  // HAVE_SWAP

    status = io_legacy_apdu_tx(G_io_tx_buffer, length);
c0de2e1e:	1ca8      	adds	r0, r5, #2
c0de2e20:	b281      	uxth	r1, r0
c0de2e22:	4620      	mov	r0, r4
c0de2e24:	f7fd fb31 	bl	c0de048a <io_legacy_apdu_tx>

    if (status < 0) {
c0de2e28:	ea40 7be0 	orr.w	fp, r0, r0, asr #31
        status = -1;
    }

    return status;
}
c0de2e2c:	4658      	mov	r0, fp
c0de2e2e:	b002      	add	sp, #8
c0de2e30:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de2e34 <app_exit>:
    os_sched_exit(-1);
c0de2e34:	20ff      	movs	r0, #255	@ 0xff
c0de2e36:	f001 f92d 	bl	c0de4094 <os_sched_exit>

c0de2e3a <common_app_init>:
{
c0de2e3a:	b580      	push	{r7, lr}
    UX_INIT();
c0de2e3c:	f000 f9a4 	bl	c0de3188 <nbgl_objInit>
    io_seproxyhal_init();
c0de2e40:	f7fd fc81 	bl	c0de0746 <io_seproxyhal_init>
}
c0de2e44:	bd80      	pop	{r7, pc}

c0de2e46 <standalone_app_main>:
{
c0de2e46:	b510      	push	{r4, lr}
c0de2e48:	b08c      	sub	sp, #48	@ 0x30
    PRINTF("standalone_app_main\n");
c0de2e4a:	f641 0094 	movw	r0, #6292	@ 0x1894
c0de2e4e:	f2c0 0000 	movt	r0, #0
c0de2e52:	4478      	add	r0, pc
c0de2e54:	f000 fa18 	bl	c0de3288 <mcu_usb_printf>
c0de2e58:	466c      	mov	r4, sp
        TRY
c0de2e5a:	4620      	mov	r0, r4
c0de2e5c:	f001 fab8 	bl	c0de43d0 <setjmp>
c0de2e60:	0401      	lsls	r1, r0, #16
c0de2e62:	f8ad 002c 	strh.w	r0, [sp, #44]	@ 0x2c
c0de2e66:	d113      	bne.n	c0de2e90 <standalone_app_main+0x4a>
c0de2e68:	4620      	mov	r0, r4
c0de2e6a:	f001 f963 	bl	c0de4134 <try_context_set>
c0de2e6e:	900a      	str	r0, [sp, #40]	@ 0x28
            common_app_init();
c0de2e70:	f7ff ffe3 	bl	c0de2e3a <common_app_init>
            app_main();
c0de2e74:	f7fd f93e 	bl	c0de00f4 <app_main>
        FINALLY {}
c0de2e78:	f001 f952 	bl	c0de4120 <try_context_get>
c0de2e7c:	42a0      	cmp	r0, r4
c0de2e7e:	d102      	bne.n	c0de2e86 <standalone_app_main+0x40>
c0de2e80:	980a      	ldr	r0, [sp, #40]	@ 0x28
c0de2e82:	f001 f957 	bl	c0de4134 <try_context_set>
    END_TRY;
c0de2e86:	f8bd 002c 	ldrh.w	r0, [sp, #44]	@ 0x2c
c0de2e8a:	b958      	cbnz	r0, c0de2ea4 <standalone_app_main+0x5e>
    app_exit();
c0de2e8c:	f7ff ffd2 	bl	c0de2e34 <app_exit>
        CATCH_OTHER(e)
c0de2e90:	980a      	ldr	r0, [sp, #40]	@ 0x28
c0de2e92:	2100      	movs	r1, #0
c0de2e94:	f8ad 102c 	strh.w	r1, [sp, #44]	@ 0x2c
c0de2e98:	f001 f94c 	bl	c0de4134 <try_context_set>
            os_io_stop();
c0de2e9c:	f001 f91c 	bl	c0de40d8 <os_io_stop>
            assert_display_exit();
c0de2ea0:	f000 f94a 	bl	c0de3138 <assert_display_exit>
    END_TRY;
c0de2ea4:	f000 f9d7 	bl	c0de3256 <os_longjmp>

c0de2ea8 <apdu_parser>:
#include "offsets.h"

bool apdu_parser(command_t *cmd, uint8_t *buf, size_t buf_len)
{
    // Check minimum length, CLA / INS / P1 and P2 are mandatory
    if (buf_len < OFFSET_LC) {
c0de2ea8:	2a04      	cmp	r2, #4
c0de2eaa:	d317      	bcc.n	c0de2edc <apdu_parser+0x34>
        return false;
    }

    if (buf_len == OFFSET_LC) {
c0de2eac:	d102      	bne.n	c0de2eb4 <apdu_parser+0xc>
c0de2eae:	2200      	movs	r2, #0
        // Lc field not specified, implies lc = 0
        cmd->lc = 0;
c0de2eb0:	7102      	strb	r2, [r0, #4]
c0de2eb2:	e004      	b.n	c0de2ebe <apdu_parser+0x16>
    }
    else {
        // Lc field specified, check value against received length
        cmd->lc = buf[OFFSET_LC];
c0de2eb4:	790b      	ldrb	r3, [r1, #4]
        if (buf_len - OFFSET_CDATA != cmd->lc) {
c0de2eb6:	3a05      	subs	r2, #5
c0de2eb8:	429a      	cmp	r2, r3
        cmd->lc = buf[OFFSET_LC];
c0de2eba:	7103      	strb	r3, [r0, #4]
        if (buf_len - OFFSET_CDATA != cmd->lc) {
c0de2ebc:	d10e      	bne.n	c0de2edc <apdu_parser+0x34>
            return false;
        }
    }

    cmd->cla  = buf[OFFSET_CLA];
c0de2ebe:	780a      	ldrb	r2, [r1, #0]
    cmd->ins  = buf[OFFSET_INS];
    cmd->p1   = buf[OFFSET_P1];
    cmd->p2   = buf[OFFSET_P2];
    cmd->data = (cmd->lc > 0) ? buf + OFFSET_CDATA : NULL;
c0de2ec0:	7903      	ldrb	r3, [r0, #4]
    cmd->cla  = buf[OFFSET_CLA];
c0de2ec2:	7002      	strb	r2, [r0, #0]
    cmd->ins  = buf[OFFSET_INS];
c0de2ec4:	784a      	ldrb	r2, [r1, #1]
    cmd->data = (cmd->lc > 0) ? buf + OFFSET_CDATA : NULL;
c0de2ec6:	2b00      	cmp	r3, #0
    cmd->ins  = buf[OFFSET_INS];
c0de2ec8:	7042      	strb	r2, [r0, #1]
    cmd->p1   = buf[OFFSET_P1];
c0de2eca:	788a      	ldrb	r2, [r1, #2]
c0de2ecc:	7082      	strb	r2, [r0, #2]
    cmd->p2   = buf[OFFSET_P2];
c0de2ece:	78ca      	ldrb	r2, [r1, #3]
c0de2ed0:	70c2      	strb	r2, [r0, #3]
    cmd->data = (cmd->lc > 0) ? buf + OFFSET_CDATA : NULL;
c0de2ed2:	bf18      	it	ne
c0de2ed4:	1d4b      	addne	r3, r1, #5
c0de2ed6:	6083      	str	r3, [r0, #8]
c0de2ed8:	2001      	movs	r0, #1

    return true;
}
c0de2eda:	4770      	bx	lr
c0de2edc:	2000      	movs	r0, #0
c0de2ede:	4770      	bx	lr

c0de2ee0 <write_u16_be>:
#include <stdint.h>  // uint*_t
#include <stddef.h>  // size_t

void write_u16_be(uint8_t *ptr, size_t offset, uint16_t value)
{
    ptr[offset + 0] = (uint8_t) (value >> 8);
c0de2ee0:	0a13      	lsrs	r3, r2, #8
c0de2ee2:	eb00 0c01 	add.w	ip, r0, r1
c0de2ee6:	5443      	strb	r3, [r0, r1]
    ptr[offset + 1] = (uint8_t) (value >> 0);
c0de2ee8:	f88c 2001 	strb.w	r2, [ip, #1]
}
c0de2eec:	4770      	bx	lr

c0de2eee <ux_process_button_event>:
 * it (button event caught by BOLOS UX page).
 *
 * @param seph_packet received SEPH packet
 */
void ux_process_button_event(const uint8_t seph_packet[])
{
c0de2eee:	b5b0      	push	{r4, r5, r7, lr}
c0de2ef0:	4604      	mov	r4, r0
    G_ux_params.ux_id = BOLOS_UX_EVENT;
c0de2ef2:	f240 40a8 	movw	r0, #1192	@ 0x4a8
c0de2ef6:	f2c0 0000 	movt	r0, #0
c0de2efa:	2101      	movs	r1, #1
c0de2efc:	f809 1000 	strb.w	r1, [r9, r0]
c0de2f00:	eb09 0500 	add.w	r5, r9, r0
c0de2f04:	2000      	movs	r0, #0
    G_ux_params.len   = 0;
c0de2f06:	6068      	str	r0, [r5, #4]
    os_ux(&G_ux_params);
c0de2f08:	4628      	mov	r0, r5
c0de2f0a:	f001 f8a0 	bl	c0de404e <os_ux>
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de2f0e:	2004      	movs	r0, #4
c0de2f10:	f001 f91e 	bl	c0de4150 <os_sched_last_status>
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de2f14:	2869      	cmp	r0, #105	@ 0x69
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de2f16:	6068      	str	r0, [r5, #4]
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de2f18:	d108      	bne.n	c0de2f2c <ux_process_button_event+0x3e>
        nbgl_objAllowDrawing(true);
c0de2f1a:	2001      	movs	r0, #1
c0de2f1c:	f000 f939 	bl	c0de3192 <nbgl_objAllowDrawing>
        nbgl_screenRedraw();
c0de2f20:	f000 f946 	bl	c0de31b0 <nbgl_screenRedraw>
        nbgl_refresh();
c0de2f24:	f000 f92b 	bl	c0de317e <nbgl_refresh>
c0de2f28:	2500      	movs	r5, #0
c0de2f2a:	e008      	b.n	c0de2f3e <ux_process_button_event+0x50>
             || ((G_ux_params.len != BOLOS_UX_IGNORE) && (G_ux_params.len != BOLOS_UX_CONTINUE))) {
c0de2f2c:	f1b0 0197 	subs.w	r1, r0, #151	@ 0x97
c0de2f30:	bf18      	it	ne
c0de2f32:	2101      	movne	r1, #1
c0de2f34:	2800      	cmp	r0, #0
c0de2f36:	bf18      	it	ne
c0de2f38:	2001      	movne	r0, #1
c0de2f3a:	ea01 0500 	and.w	r5, r1, r0
    bool displayEnabled = ux_forward_event(true);
    // enable/disable drawing according to UX decision
    nbgl_objAllowDrawing(displayEnabled);
c0de2f3e:	4628      	mov	r0, r5
c0de2f40:	f000 f927 	bl	c0de3192 <nbgl_objAllowDrawing>

    // if the event is not fully consumed by UX, use it for NBGL
    if (displayEnabled) {
c0de2f44:	2d00      	cmp	r5, #0
        uint8_t buttons_state = seph_packet[3] >> 1;
        nbgl_buttonsHandler(buttons_state, nbTicks * 100);
        nbgl_refresh();
    }
}
c0de2f46:	bf08      	it	eq
c0de2f48:	bdb0      	popeq	{r4, r5, r7, pc}
        nbgl_buttonsHandler(buttons_state, nbTicks * 100);
c0de2f4a:	f240 41b8 	movw	r1, #1208	@ 0x4b8
c0de2f4e:	f2c0 0100 	movt	r1, #0
        uint8_t buttons_state = seph_packet[3] >> 1;
c0de2f52:	78e0      	ldrb	r0, [r4, #3]
        nbgl_buttonsHandler(buttons_state, nbTicks * 100);
c0de2f54:	f859 1001 	ldr.w	r1, [r9, r1]
c0de2f58:	2264      	movs	r2, #100	@ 0x64
        uint8_t buttons_state = seph_packet[3] >> 1;
c0de2f5a:	0840      	lsrs	r0, r0, #1
        nbgl_buttonsHandler(buttons_state, nbTicks * 100);
c0de2f5c:	4351      	muls	r1, r2
c0de2f5e:	f000 f968 	bl	c0de3232 <nbgl_buttonsHandler>
        nbgl_refresh();
c0de2f62:	f000 f90c 	bl	c0de317e <nbgl_refresh>
}
c0de2f66:	bdb0      	pop	{r4, r5, r7, pc}

c0de2f68 <ux_process_ticker_event>:
 * @brief Process the ticker_event to the os ux handler. Ticker event callback is always called
 * whatever the return code of the ux app.
 * @note Ticker event interval is assumed to be 100 ms.
 */
void ux_process_ticker_event(void)
{
c0de2f68:	b510      	push	{r4, lr}
    nbTicks++;
c0de2f6a:	f240 40b8 	movw	r0, #1208	@ 0x4b8
c0de2f6e:	f2c0 0000 	movt	r0, #0
c0de2f72:	f859 1000 	ldr.w	r1, [r9, r0]
c0de2f76:	3101      	adds	r1, #1
c0de2f78:	f849 1000 	str.w	r1, [r9, r0]
    G_ux_params.ux_id = BOLOS_UX_EVENT;
c0de2f7c:	f240 40a8 	movw	r0, #1192	@ 0x4a8
c0de2f80:	f2c0 0000 	movt	r0, #0
c0de2f84:	2101      	movs	r1, #1
c0de2f86:	f809 1000 	strb.w	r1, [r9, r0]
c0de2f8a:	eb09 0400 	add.w	r4, r9, r0
c0de2f8e:	2000      	movs	r0, #0
    G_ux_params.len   = 0;
c0de2f90:	6060      	str	r0, [r4, #4]
    os_ux(&G_ux_params);
c0de2f92:	4620      	mov	r0, r4
c0de2f94:	f001 f85b 	bl	c0de404e <os_ux>
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de2f98:	2004      	movs	r0, #4
c0de2f9a:	f001 f8d9 	bl	c0de4150 <os_sched_last_status>
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de2f9e:	2869      	cmp	r0, #105	@ 0x69
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de2fa0:	6060      	str	r0, [r4, #4]
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de2fa2:	d108      	bne.n	c0de2fb6 <ux_process_ticker_event+0x4e>
        nbgl_objAllowDrawing(true);
c0de2fa4:	2001      	movs	r0, #1
c0de2fa6:	f000 f8f4 	bl	c0de3192 <nbgl_objAllowDrawing>
        nbgl_screenRedraw();
c0de2faa:	f000 f901 	bl	c0de31b0 <nbgl_screenRedraw>
        nbgl_refresh();
c0de2fae:	f000 f8e6 	bl	c0de317e <nbgl_refresh>
c0de2fb2:	2400      	movs	r4, #0
c0de2fb4:	e008      	b.n	c0de2fc8 <ux_process_ticker_event+0x60>
             || ((G_ux_params.len != BOLOS_UX_IGNORE) && (G_ux_params.len != BOLOS_UX_CONTINUE))) {
c0de2fb6:	f1b0 0197 	subs.w	r1, r0, #151	@ 0x97
c0de2fba:	bf18      	it	ne
c0de2fbc:	2101      	movne	r1, #1
c0de2fbe:	2800      	cmp	r0, #0
c0de2fc0:	bf18      	it	ne
c0de2fc2:	2001      	movne	r0, #1
c0de2fc4:	ea01 0400 	and.w	r4, r1, r0
    // forward to UX
    bool displayEnabled = ux_forward_event(true);

    // enable/disable drawing according to UX decision
    nbgl_objAllowDrawing(displayEnabled);
c0de2fc8:	4620      	mov	r0, r4
c0de2fca:	f000 f8e2 	bl	c0de3192 <nbgl_objAllowDrawing>

    // do not do any action on screens if display is disabled, because
    // UX has the hand
    if (!displayEnabled) {
c0de2fce:	2c00      	cmp	r4, #0
        // Send current touch position to nbgl
        nbgl_touchHandler(false, &pos, nbTicks * 100);
    }
#endif  // HAVE_SE_TOUCH
    nbgl_refresh();
}
c0de2fd0:	bf08      	it	eq
c0de2fd2:	bd10      	popeq	{r4, pc}
    nbgl_screenHandler(100);
c0de2fd4:	2064      	movs	r0, #100	@ 0x64
c0de2fd6:	f000 f8f5 	bl	c0de31c4 <nbgl_screenHandler>
    nbgl_refresh();
c0de2fda:	f000 f8d0 	bl	c0de317e <nbgl_refresh>
}
c0de2fde:	bd10      	pop	{r4, pc}

c0de2fe0 <ux_process_default_event>:

/**
 * Forwards the event to UX
 */
void ux_process_default_event(void)
{
c0de2fe0:	b510      	push	{r4, lr}
    G_ux_params.ux_id = BOLOS_UX_EVENT;
c0de2fe2:	f240 40a8 	movw	r0, #1192	@ 0x4a8
c0de2fe6:	f2c0 0000 	movt	r0, #0
c0de2fea:	2101      	movs	r1, #1
c0de2fec:	f809 1000 	strb.w	r1, [r9, r0]
c0de2ff0:	eb09 0400 	add.w	r4, r9, r0
c0de2ff4:	2000      	movs	r0, #0
    G_ux_params.len   = 0;
c0de2ff6:	6060      	str	r0, [r4, #4]
    os_ux(&G_ux_params);
c0de2ff8:	4620      	mov	r0, r4
c0de2ffa:	f001 f828 	bl	c0de404e <os_ux>
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de2ffe:	2004      	movs	r0, #4
c0de3000:	f001 f8a6 	bl	c0de4150 <os_sched_last_status>
    if (G_ux_params.len == BOLOS_UX_REDRAW) {
c0de3004:	2869      	cmp	r0, #105	@ 0x69
    G_ux_params.len = os_sched_last_status(TASK_BOLOS_UX);
c0de3006:	6060      	str	r0, [r4, #4]
    // forward to UX
    ux_forward_event(false);
}
c0de3008:	bf18      	it	ne
c0de300a:	bd10      	popne	{r4, pc}
        nbgl_objAllowDrawing(true);
c0de300c:	2001      	movs	r0, #1
c0de300e:	f000 f8c0 	bl	c0de3192 <nbgl_objAllowDrawing>
        nbgl_screenRedraw();
c0de3012:	f000 f8cd 	bl	c0de31b0 <nbgl_screenRedraw>
        nbgl_refresh();
c0de3016:	f000 f8b2 	bl	c0de317e <nbgl_refresh>
}
c0de301a:	bd10      	pop	{r4, pc}

c0de301c <assert_display_lr_and_pc>:
 * Define behavior when LEDGER_ASSERT_CONFIG_LR_AND_PC_INFO *
 ***********************************************************/
#ifdef LEDGER_ASSERT_CONFIG_LR_AND_PC_INFO
#ifdef HAVE_LEDGER_ASSERT_DISPLAY
void assert_display_lr_and_pc(int lr, int pc)
{
c0de301c:	b570      	push	{r4, r5, r6, lr}
c0de301e:	b08a      	sub	sp, #40	@ 0x28
c0de3020:	460c      	mov	r4, r1
    char buff[LR_AND_PC_SIZE];

    lr = compute_address_location(lr);
c0de3022:	f000 f926 	bl	c0de3272 <compute_address_location>
c0de3026:	4605      	mov	r5, r0
    pc = compute_address_location(pc);
c0de3028:	4620      	mov	r0, r4
c0de302a:	f000 f922 	bl	c0de3272 <compute_address_location>
    snprintf(buff, LR_AND_PC_SIZE, "LR=0x%08X\n PC=0x%08X\n", lr, pc);
c0de302e:	f241 62f9 	movw	r2, #5881	@ 0x16f9
c0de3032:	f2c0 0200 	movt	r2, #0
c0de3036:	f10d 060a 	add.w	r6, sp, #10
    pc = compute_address_location(pc);
c0de303a:	4604      	mov	r4, r0
    snprintf(buff, LR_AND_PC_SIZE, "LR=0x%08X\n PC=0x%08X\n", lr, pc);
c0de303c:	447a      	add	r2, pc
c0de303e:	4630      	mov	r0, r6
c0de3040:	211e      	movs	r1, #30
c0de3042:	462b      	mov	r3, r5
c0de3044:	9400      	str	r4, [sp, #0]
c0de3046:	f000 ff69 	bl	c0de3f1c <snprintf>
    strncat(assert_buffer, buff, LR_AND_PC_SIZE);
c0de304a:	f240 40bc 	movw	r0, #1212	@ 0x4bc
c0de304e:	f2c0 0000 	movt	r0, #0
c0de3052:	4448      	add	r0, r9
c0de3054:	4631      	mov	r1, r6
c0de3056:	221e      	movs	r2, #30
c0de3058:	f001 f9d0 	bl	c0de43fc <strncat>
}
c0de305c:	b00a      	add	sp, #40	@ 0x28
c0de305e:	bd70      	pop	{r4, r5, r6, pc}

c0de3060 <assert_print_lr_and_pc>:
#endif

#ifdef HAVE_PRINTF
void assert_print_lr_and_pc(int lr, int pc)
{
c0de3060:	b5b0      	push	{r4, r5, r7, lr}
c0de3062:	460c      	mov	r4, r1
    lr = compute_address_location(lr);
c0de3064:	f000 f905 	bl	c0de3272 <compute_address_location>
c0de3068:	4605      	mov	r5, r0
    pc = compute_address_location(pc);
c0de306a:	4620      	mov	r0, r4
c0de306c:	f000 f901 	bl	c0de3272 <compute_address_location>
c0de3070:	4604      	mov	r4, r0
    PRINTF("=> LR: 0x%08X \n", lr);
c0de3072:	f241 60f9 	movw	r0, #5881	@ 0x16f9
c0de3076:	f2c0 0000 	movt	r0, #0
c0de307a:	4478      	add	r0, pc
c0de307c:	4629      	mov	r1, r5
c0de307e:	f000 f903 	bl	c0de3288 <mcu_usb_printf>
    PRINTF("=> PC: 0x%08X \n", pc);
c0de3082:	f241 50a7 	movw	r0, #5543	@ 0x15a7
c0de3086:	f2c0 0000 	movt	r0, #0
c0de308a:	4478      	add	r0, pc
c0de308c:	4621      	mov	r1, r4
c0de308e:	f000 f8fb 	bl	c0de3288 <mcu_usb_printf>
}
c0de3092:	bdb0      	pop	{r4, r5, r7, pc}

c0de3094 <assert_display_file_info>:
 * Define behavior when LEDGER_ASSERT_CONFIG_FILE_INFO *
 ******************************************************/
#ifdef LEDGER_ASSERT_CONFIG_FILE_INFO
#ifdef HAVE_LEDGER_ASSERT_DISPLAY
void assert_display_file_info(const char *file, unsigned int line)
{
c0de3094:	b510      	push	{r4, lr}
c0de3096:	b08e      	sub	sp, #56	@ 0x38
    char buff[FILE_SIZE];

    snprintf(buff, FILE_SIZE, "%s::%d\n", file, line);
c0de3098:	f241 52f2 	movw	r2, #5618	@ 0x15f2
c0de309c:	f2c0 0200 	movt	r2, #0
c0de30a0:	f10d 0406 	add.w	r4, sp, #6
c0de30a4:	468c      	mov	ip, r1
c0de30a6:	4603      	mov	r3, r0
c0de30a8:	447a      	add	r2, pc
c0de30aa:	4620      	mov	r0, r4
c0de30ac:	2132      	movs	r1, #50	@ 0x32
c0de30ae:	f8cd c000 	str.w	ip, [sp]
c0de30b2:	f000 ff33 	bl	c0de3f1c <snprintf>
    strncat(assert_buffer, buff, FILE_SIZE);
c0de30b6:	f240 40bc 	movw	r0, #1212	@ 0x4bc
c0de30ba:	f2c0 0000 	movt	r0, #0
c0de30be:	4448      	add	r0, r9
c0de30c0:	4621      	mov	r1, r4
c0de30c2:	2232      	movs	r2, #50	@ 0x32
c0de30c4:	f001 f99a 	bl	c0de43fc <strncat>
}
c0de30c8:	b00e      	add	sp, #56	@ 0x38
c0de30ca:	bd10      	pop	{r4, pc}

c0de30cc <assert_print_file_info>:
#endif

#ifdef HAVE_PRINTF
void assert_print_file_info(const char *file, int line)
{
c0de30cc:	b580      	push	{r7, lr}
c0de30ce:	460a      	mov	r2, r1
c0de30d0:	4601      	mov	r1, r0
    PRINTF("%s::%d \n", file, line);
c0de30d2:	f241 607a 	movw	r0, #5754	@ 0x167a
c0de30d6:	f2c0 0000 	movt	r0, #0
c0de30da:	4478      	add	r0, pc
c0de30dc:	f000 f8d4 	bl	c0de3288 <mcu_usb_printf>
}
c0de30e0:	bd80      	pop	{r7, pc}

c0de30e2 <throw_display_lr>:
/*************************************
 * Specific mechanism to debug THROW *
 ************************************/
#ifdef HAVE_DEBUG_THROWS
void throw_display_lr(int e, int lr)
{
c0de30e2:	b5b0      	push	{r4, r5, r7, lr}
c0de30e4:	b082      	sub	sp, #8
c0de30e6:	4605      	mov	r5, r0
    lr = compute_address_location(lr);
c0de30e8:	4608      	mov	r0, r1
c0de30ea:	f000 f8c2 	bl	c0de3272 <compute_address_location>
c0de30ee:	4604      	mov	r4, r0
    snprintf(assert_buffer, ASSERT_BUFFER_LEN, "e=0x%04X\n LR=0x%08X\n", e, lr);
c0de30f0:	f240 40bc 	movw	r0, #1212	@ 0x4bc
c0de30f4:	f241 52cf 	movw	r2, #5583	@ 0x15cf
c0de30f8:	f2c0 0000 	movt	r0, #0
c0de30fc:	f2c0 0200 	movt	r2, #0
c0de3100:	4448      	add	r0, r9
c0de3102:	447a      	add	r2, pc
c0de3104:	2182      	movs	r1, #130	@ 0x82
c0de3106:	462b      	mov	r3, r5
c0de3108:	9400      	str	r4, [sp, #0]
c0de310a:	f000 ff07 	bl	c0de3f1c <snprintf>
}
c0de310e:	b002      	add	sp, #8
c0de3110:	bdb0      	pop	{r4, r5, r7, pc}

c0de3112 <throw_print_lr>:

#ifdef HAVE_PRINTF
void throw_print_lr(int e, int lr)
{
c0de3112:	b510      	push	{r4, lr}
c0de3114:	4604      	mov	r4, r0
    lr = compute_address_location(lr);
c0de3116:	4608      	mov	r0, r1
c0de3118:	f000 f8ab 	bl	c0de3272 <compute_address_location>
c0de311c:	4602      	mov	r2, r0
    PRINTF("exception[0x%04X]: LR=0x%08X\n", e, lr);
c0de311e:	f241 50d5 	movw	r0, #5589	@ 0x15d5
c0de3122:	f2c0 0000 	movt	r0, #0
c0de3126:	4478      	add	r0, pc
c0de3128:	4621      	mov	r1, r4
c0de312a:	f000 f8ad 	bl	c0de3288 <mcu_usb_printf>
}
c0de312e:	bd10      	pop	{r4, pc}

c0de3130 <assert_exit>:
 * Common app exit *
 ******************/
void __attribute__((noreturn)) assert_exit(bool confirm)
{
    UNUSED(confirm);
    os_sched_exit(-1);
c0de3130:	20ff      	movs	r0, #255	@ 0xff
c0de3132:	f000 ffaf 	bl	c0de4094 <os_sched_exit>
	...

c0de3138 <assert_display_exit>:
           });
UX_FLOW(ux_error_flow, &ux_error);
#endif

void __attribute__((noreturn)) assert_display_exit(void)
{
c0de3138:	b082      	sub	sp, #8
#define ICON_APP_WARNING C_Important_Circle_64px
#elif defined(TARGET_APEX)
#define ICON_APP_WARNING C_Important_Circle_48px
#endif

    nbgl_useCaseChoice(
c0de313a:	f64f 7cc3 	movw	ip, #65475	@ 0xffc3
c0de313e:	f6cf 7cff 	movt	ip, #65535	@ 0xffff
c0de3142:	f241 439b 	movw	r3, #5275	@ 0x149b
c0de3146:	f2c0 0300 	movt	r3, #0
c0de314a:	f240 40bc 	movw	r0, #1212	@ 0x4bc
c0de314e:	447b      	add	r3, pc
c0de3150:	f2c0 0000 	movt	r0, #0
c0de3154:	9300      	str	r3, [sp, #0]
c0de3156:	eb09 0200 	add.w	r2, r9, r0
c0de315a:	f241 4003 	movw	r0, #5123	@ 0x1403
c0de315e:	f2c0 0000 	movt	r0, #0
c0de3162:	f241 4171 	movw	r1, #5233	@ 0x1471
c0de3166:	f2c0 0100 	movt	r1, #0
c0de316a:	44fc      	add	ip, pc
c0de316c:	4478      	add	r0, pc
c0de316e:	4479      	add	r1, pc
c0de3170:	f8cd c004 	str.w	ip, [sp, #4]
c0de3174:	f7fe ff57 	bl	c0de2026 <nbgl_useCaseChoice>
        &ICON_APP_WARNING, "App error", assert_buffer, "Exit app", "Exit app", assert_exit);
#endif

    // Block until the user approve and the app is quit
    while (1) {
        io_seproxyhal_io_heartbeat();
c0de3178:	f7fd f931 	bl	c0de03de <io_seproxyhal_io_heartbeat>
    while (1) {
c0de317c:	e7fc      	b.n	c0de3178 <assert_display_exit+0x40>

c0de317e <nbgl_refresh>:
c0de317e:	b403      	push	{r0, r1}
c0de3180:	f04f 0091 	mov.w	r0, #145	@ 0x91
c0de3184:	f000 b85e 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de3188 <nbgl_objInit>:
c0de3188:	b403      	push	{r0, r1}
c0de318a:	f04f 0096 	mov.w	r0, #150	@ 0x96
c0de318e:	f000 b859 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de3192 <nbgl_objAllowDrawing>:
c0de3192:	b403      	push	{r0, r1}
c0de3194:	f04f 0098 	mov.w	r0, #152	@ 0x98
c0de3198:	f000 b854 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de319c <nbgl_screenSet>:
c0de319c:	b403      	push	{r0, r1}
c0de319e:	f04f 009b 	mov.w	r0, #155	@ 0x9b
c0de31a2:	f000 b84f 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de31a6 <nbgl_screenPush>:
c0de31a6:	b403      	push	{r0, r1}
c0de31a8:	f04f 009c 	mov.w	r0, #156	@ 0x9c
c0de31ac:	f000 b84a 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de31b0 <nbgl_screenRedraw>:
c0de31b0:	b403      	push	{r0, r1}
c0de31b2:	f04f 009d 	mov.w	r0, #157	@ 0x9d
c0de31b6:	f000 b845 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de31ba <nbgl_screenPop>:
c0de31ba:	b403      	push	{r0, r1}
c0de31bc:	f04f 009e 	mov.w	r0, #158	@ 0x9e
c0de31c0:	f000 b840 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de31c4 <nbgl_screenHandler>:
c0de31c4:	b403      	push	{r0, r1}
c0de31c6:	f04f 00a7 	mov.w	r0, #167	@ 0xa7
c0de31ca:	f000 b83b 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de31ce <nbgl_objPoolGet>:
c0de31ce:	b403      	push	{r0, r1}
c0de31d0:	f04f 00a8 	mov.w	r0, #168	@ 0xa8
c0de31d4:	f000 b836 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de31d8 <nbgl_containerPoolGet>:
c0de31d8:	b403      	push	{r0, r1}
c0de31da:	f04f 00aa 	mov.w	r0, #170	@ 0xaa
c0de31de:	f000 b831 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de31e2 <nbgl_getFont>:
c0de31e2:	b403      	push	{r0, r1}
c0de31e4:	f04f 00ac 	mov.w	r0, #172	@ 0xac
c0de31e8:	f000 b82c 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de31ec <nbgl_getFontLineHeight>:
c0de31ec:	b403      	push	{r0, r1}
c0de31ee:	f04f 00ae 	mov.w	r0, #174	@ 0xae
c0de31f2:	f000 b827 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de31f6 <nbgl_getTextMaxLenAndWidth>:
c0de31f6:	b403      	push	{r0, r1}
c0de31f8:	f04f 00b3 	mov.w	r0, #179	@ 0xb3
c0de31fc:	f000 b822 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de3200 <nbgl_getTextNbLinesInWidth>:
c0de3200:	b403      	push	{r0, r1}
c0de3202:	f04f 00b4 	mov.w	r0, #180	@ 0xb4
c0de3206:	f000 b81d 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de320a <nbgl_getTextNbPagesInWidth>:
c0de320a:	b403      	push	{r0, r1}
c0de320c:	f04f 00b5 	mov.w	r0, #181	@ 0xb5
c0de3210:	f000 b818 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de3214 <nbgl_getTextWidth>:
c0de3214:	b403      	push	{r0, r1}
c0de3216:	f04f 00b6 	mov.w	r0, #182	@ 0xb6
c0de321a:	f000 b813 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de321e <nbgl_getTextMaxLenInNbLines>:
c0de321e:	b403      	push	{r0, r1}
c0de3220:	f04f 00b7 	mov.w	r0, #183	@ 0xb7
c0de3224:	f000 b80e 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de3228 <nbgl_textReduceOnNbLines>:
c0de3228:	b403      	push	{r0, r1}
c0de322a:	f04f 00b8 	mov.w	r0, #184	@ 0xb8
c0de322e:	f000 b809 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de3232 <nbgl_buttonsHandler>:
c0de3232:	b403      	push	{r0, r1}
c0de3234:	f04f 00be 	mov.w	r0, #190	@ 0xbe
c0de3238:	f000 b804 	b.w	c0de3244 <nbgl_trampoline_helper>

c0de323c <pic_init>:
c0de323c:	b403      	push	{r0, r1}
c0de323e:	f04f 00c4 	mov.w	r0, #196	@ 0xc4
c0de3242:	e7ff      	b.n	c0de3244 <nbgl_trampoline_helper>

c0de3244 <nbgl_trampoline_helper>:
c0de3244:	4900      	ldr	r1, [pc, #0]	@ (c0de3248 <nbgl_trampoline_helper+0x4>)
c0de3246:	4708      	bx	r1
c0de3248:	00808001 	.word	0x00808001

c0de324c <os_boot>:
#include "os_io_seph_cmd.h"
#include <string.h>

#ifndef BOLOS_OS_UPGRADER_APP
void os_boot(void)
{
c0de324c:	b580      	push	{r7, lr}
    // // TODO patch entry point when romming (f)
    // // set the default try context to nothing
#ifndef HAVE_BOLOS
    try_context_set(NULL);
c0de324e:	2000      	movs	r0, #0
c0de3250:	f000 ff70 	bl	c0de4134 <try_context_set>
#endif  // HAVE_BOLOS
}
c0de3254:	bd80      	pop	{r7, pc}

c0de3256 <os_longjmp>:

void os_longjmp(unsigned int exception)
{
#ifdef HAVE_DEBUG_THROWS
    // Send to the app the info of exception and LR for debug purpose
    DEBUG_THROW(exception);
c0de3256:	4675      	mov	r5, lr
c0de3258:	4629      	mov	r1, r5
c0de325a:	4604      	mov	r4, r0
c0de325c:	f7ff ff41 	bl	c0de30e2 <throw_display_lr>
c0de3260:	4620      	mov	r0, r4
c0de3262:	4629      	mov	r1, r5
c0de3264:	f7ff ff55 	bl	c0de3112 <throw_print_lr>
    lr_val = compute_address_location(lr_val);

    PRINTF("exception[0x%04X]: LR=0x%08X\n", exception, lr_val);
#endif

    longjmp(try_context_get()->jmp_buf, exception);
c0de3268:	f000 ff5a 	bl	c0de4120 <try_context_get>
c0de326c:	4621      	mov	r1, r4
c0de326e:	f001 f8b5 	bl	c0de43dc <longjmp>

c0de3272 <compute_address_location>:
    return address - (unsigned int) main + MAIN_LINKER_SCRIPT_LOCATION;
c0de3272:	f64c 5183 	movw	r1, #52611	@ 0xcd83
c0de3276:	f6cf 71ff 	movt	r1, #65535	@ 0xffff
c0de327a:	4479      	add	r1, pc
c0de327c:	1a40      	subs	r0, r0, r1
c0de327e:	f100 4040 	add.w	r0, r0, #3221225472	@ 0xc0000000
c0de3282:	f500 005e 	add.w	r0, r0, #14548992	@ 0xde0000
c0de3286:	4770      	bx	lr

c0de3288 <mcu_usb_printf>:

#ifdef HAVE_PRINTF
void screen_printf(const char *format, ...) __attribute__((weak, alias("mcu_usb_printf")));

void mcu_usb_printf(const char *format, ...)
{
c0de3288:	b083      	sub	sp, #12
c0de328a:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de328e:	b091      	sub	sp, #68	@ 0x44
    va_list vaArgP;

    if (format == NULL) {
c0de3290:	2800      	cmp	r0, #0
c0de3292:	e9cd 1219 	strd	r1, r2, [sp, #100]	@ 0x64
c0de3296:	931b      	str	r3, [sp, #108]	@ 0x6c
c0de3298:	f000 82f7 	beq.w	c0de388a <mcu_usb_printf+0x602>
c0de329c:	4604      	mov	r4, r0
    while (*format) {
c0de329e:	7800      	ldrb	r0, [r0, #0]
c0de32a0:	f10d 0b64 	add.w	fp, sp, #100	@ 0x64
c0de32a4:	2800      	cmp	r0, #0
        return;
    }

    va_start(vaArgP, format);
c0de32a6:	f8cd b01c 	str.w	fp, [sp, #28]
    while (*format) {
c0de32aa:	f000 82ee 	beq.w	c0de388a <mcu_usb_printf+0x602>
c0de32ae:	f241 363c 	movw	r6, #4924	@ 0x133c
c0de32b2:	f2c0 0600 	movt	r6, #0
c0de32b6:	447e      	add	r6, pc
c0de32b8:	e00a      	b.n	c0de32d0 <mcu_usb_printf+0x48>
c0de32ba:	bf00      	nop
c0de32bc:	f241 362e 	movw	r6, #4910	@ 0x132e
c0de32c0:	f2c0 0600 	movt	r6, #0
c0de32c4:	447e      	add	r6, pc
c0de32c6:	4654      	mov	r4, sl
c0de32c8:	7820      	ldrb	r0, [r4, #0]
c0de32ca:	2800      	cmp	r0, #0
c0de32cc:	f000 82dd 	beq.w	c0de388a <mcu_usb_printf+0x602>
c0de32d0:	2700      	movs	r7, #0
c0de32d2:	bf00      	nop
        for (ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0'); ulIdx++) {
c0de32d4:	5de0      	ldrb	r0, [r4, r7]
c0de32d6:	b118      	cbz	r0, c0de32e0 <mcu_usb_printf+0x58>
c0de32d8:	2825      	cmp	r0, #37	@ 0x25
c0de32da:	d001      	beq.n	c0de32e0 <mcu_usb_printf+0x58>
c0de32dc:	3701      	adds	r7, #1
c0de32de:	e7f9      	b.n	c0de32d4 <mcu_usb_printf+0x4c>
        if (ulIdx > 0) {
c0de32e0:	b11f      	cbz	r7, c0de32ea <mcu_usb_printf+0x62>
    os_io_seph_cmd_printf(data, len);
c0de32e2:	b2b9      	uxth	r1, r7
c0de32e4:	4620      	mov	r0, r4
c0de32e6:	f7fd f84b 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de32ea:	443c      	add	r4, r7
        if (*format == '%') {
c0de32ec:	7820      	ldrb	r0, [r4, #0]
c0de32ee:	2825      	cmp	r0, #37	@ 0x25
c0de32f0:	d1ea      	bne.n	c0de32c8 <mcu_usb_printf+0x40>
            ulNeg      = 0;
c0de32f2:	3401      	adds	r4, #1
c0de32f4:	f04f 0e00 	mov.w	lr, #0
c0de32f8:	f04f 0c20 	mov.w	ip, #32
c0de32fc:	f04f 0800 	mov.w	r8, #0
c0de3300:	2100      	movs	r1, #0
c0de3302:	e002      	b.n	c0de330a <mcu_usb_printf+0x82>
c0de3304:	f04f 0100 	mov.w	r1, #0
            switch (*format++) {
c0de3308:	d117      	bne.n	c0de333a <mcu_usb_printf+0xb2>
c0de330a:	f814 2b01 	ldrb.w	r2, [r4], #1
c0de330e:	2a2d      	cmp	r2, #45	@ 0x2d
c0de3310:	ddf8      	ble.n	c0de3304 <mcu_usb_printf+0x7c>
c0de3312:	2a47      	cmp	r2, #71	@ 0x47
c0de3314:	dc32      	bgt.n	c0de337c <mcu_usb_printf+0xf4>
c0de3316:	f1a2 0030 	sub.w	r0, r2, #48	@ 0x30
c0de331a:	280a      	cmp	r0, #10
c0de331c:	d21a      	bcs.n	c0de3354 <mcu_usb_printf+0xcc>
                    if ((format[-1] == '0') && (ulCount == 0)) {
c0de331e:	f082 0030 	eor.w	r0, r2, #48	@ 0x30
c0de3322:	ea50 000e 	orrs.w	r0, r0, lr
                    ulCount *= 10;
c0de3326:	eb0e 008e 	add.w	r0, lr, lr, lsl #2
                    ulCount += format[-1] - '0';
c0de332a:	eb02 0040 	add.w	r0, r2, r0, lsl #1
                    if ((format[-1] == '0') && (ulCount == 0)) {
c0de332e:	bf08      	it	eq
c0de3330:	f04f 0c30 	moveq.w	ip, #48	@ 0x30
                    ulCount += format[-1] - '0';
c0de3334:	f1a0 0e30 	sub.w	lr, r0, #48	@ 0x30
c0de3338:	e7e7      	b.n	c0de330a <mcu_usb_printf+0x82>
            switch (*format++) {
c0de333a:	2a25      	cmp	r2, #37	@ 0x25
c0de333c:	d04c      	beq.n	c0de33d8 <mcu_usb_printf+0x150>
c0de333e:	2a2a      	cmp	r2, #42	@ 0x2a
c0de3340:	f040 82a3 	bne.w	c0de388a <mcu_usb_printf+0x602>
                    if (*format == 's') {
c0de3344:	7820      	ldrb	r0, [r4, #0]
c0de3346:	2873      	cmp	r0, #115	@ 0x73
c0de3348:	f040 829f 	bne.w	c0de388a <mcu_usb_printf+0x602>
c0de334c:	f85b 8b04 	ldr.w	r8, [fp], #4
c0de3350:	2102      	movs	r1, #2
c0de3352:	e7da      	b.n	c0de330a <mcu_usb_printf+0x82>
            switch (*format++) {
c0de3354:	2a2e      	cmp	r2, #46	@ 0x2e
c0de3356:	f040 8298 	bne.w	c0de388a <mcu_usb_printf+0x602>
                    if (format[0] == '*'
c0de335a:	7820      	ldrb	r0, [r4, #0]
                        && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de335c:	282a      	cmp	r0, #42	@ 0x2a
c0de335e:	f040 8294 	bne.w	c0de388a <mcu_usb_printf+0x602>
c0de3362:	f814 0f01 	ldrb.w	r0, [r4, #1]!
c0de3366:	2101      	movs	r1, #1
c0de3368:	2848      	cmp	r0, #72	@ 0x48
c0de336a:	d004      	beq.n	c0de3376 <mcu_usb_printf+0xee>
c0de336c:	2868      	cmp	r0, #104	@ 0x68
c0de336e:	d002      	beq.n	c0de3376 <mcu_usb_printf+0xee>
c0de3370:	2873      	cmp	r0, #115	@ 0x73
c0de3372:	f040 828a 	bne.w	c0de388a <mcu_usb_printf+0x602>
c0de3376:	f85b 8b04 	ldr.w	r8, [fp], #4
c0de337a:	e7c6      	b.n	c0de330a <mcu_usb_printf+0x82>
            switch (*format++) {
c0de337c:	2a6b      	cmp	r2, #107	@ 0x6b
c0de337e:	dc0b      	bgt.n	c0de3398 <mcu_usb_printf+0x110>
c0de3380:	2a62      	cmp	r2, #98	@ 0x62
c0de3382:	dd12      	ble.n	c0de33aa <mcu_usb_printf+0x122>
c0de3384:	2a63      	cmp	r2, #99	@ 0x63
c0de3386:	d02d      	beq.n	c0de33e4 <mcu_usb_printf+0x15c>
c0de3388:	2a64      	cmp	r2, #100	@ 0x64
c0de338a:	d033      	beq.n	c0de33f4 <mcu_usb_printf+0x16c>
c0de338c:	2a68      	cmp	r2, #104	@ 0x68
c0de338e:	f040 827c 	bne.w	c0de388a <mcu_usb_printf+0x602>
c0de3392:	2001      	movs	r0, #1
c0de3394:	e03c      	b.n	c0de3410 <mcu_usb_printf+0x188>
c0de3396:	bf00      	nop
c0de3398:	2a72      	cmp	r2, #114	@ 0x72
c0de339a:	dd0e      	ble.n	c0de33ba <mcu_usb_printf+0x132>
c0de339c:	2a73      	cmp	r2, #115	@ 0x73
c0de339e:	d036      	beq.n	c0de340e <mcu_usb_printf+0x186>
c0de33a0:	2a75      	cmp	r2, #117	@ 0x75
c0de33a2:	d03b      	beq.n	c0de341c <mcu_usb_printf+0x194>
c0de33a4:	2a78      	cmp	r2, #120	@ 0x78
c0de33a6:	d00e      	beq.n	c0de33c6 <mcu_usb_printf+0x13e>
c0de33a8:	e26f      	b.n	c0de388a <mcu_usb_printf+0x602>
c0de33aa:	2a48      	cmp	r2, #72	@ 0x48
c0de33ac:	f000 80e6 	beq.w	c0de357c <mcu_usb_printf+0x2f4>
c0de33b0:	2a58      	cmp	r2, #88	@ 0x58
c0de33b2:	f040 826a 	bne.w	c0de388a <mcu_usb_printf+0x602>
c0de33b6:	2001      	movs	r0, #1
c0de33b8:	e006      	b.n	c0de33c8 <mcu_usb_printf+0x140>
c0de33ba:	2a6c      	cmp	r2, #108	@ 0x6c
c0de33bc:	f000 8101 	beq.w	c0de35c2 <mcu_usb_printf+0x33a>
c0de33c0:	2a70      	cmp	r2, #112	@ 0x70
c0de33c2:	f040 8262 	bne.w	c0de388a <mcu_usb_printf+0x602>
c0de33c6:	2000      	movs	r0, #0
c0de33c8:	9005      	str	r0, [sp, #20]
c0de33ca:	f8db 0000 	ldr.w	r0, [fp]
c0de33ce:	2610      	movs	r6, #16
c0de33d0:	9010      	str	r0, [sp, #64]	@ 0x40
c0de33d2:	f04f 0800 	mov.w	r8, #0
c0de33d6:	e029      	b.n	c0de342c <mcu_usb_printf+0x1a4>
    os_io_seph_cmd_printf(data, len);
c0de33d8:	f241 30ca 	movw	r0, #5066	@ 0x13ca
c0de33dc:	f2c0 0000 	movt	r0, #0
c0de33e0:	4478      	add	r0, pc
c0de33e2:	e003      	b.n	c0de33ec <mcu_usb_printf+0x164>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de33e4:	f85b 0b04 	ldr.w	r0, [fp], #4
c0de33e8:	9010      	str	r0, [sp, #64]	@ 0x40
    os_io_seph_cmd_printf(data, len);
c0de33ea:	a810      	add	r0, sp, #64	@ 0x40
c0de33ec:	2101      	movs	r1, #1
c0de33ee:	f7fc ffc7 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de33f2:	e769      	b.n	c0de32c8 <mcu_usb_printf+0x40>
                    ulValue = va_arg(vaArgP, unsigned int);
c0de33f4:	f8db 0000 	ldr.w	r0, [fp]
                    if ((long) ulValue < 0) {
c0de33f8:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
                    ulValue = va_arg(vaArgP, unsigned int);
c0de33fc:	9010      	str	r0, [sp, #64]	@ 0x40
                    if ((long) ulValue < 0) {
c0de33fe:	dc10      	bgt.n	c0de3422 <mcu_usb_printf+0x19a>
                        ulValue = -(long) ((int) ulValue);
c0de3400:	4240      	negs	r0, r0
c0de3402:	9010      	str	r0, [sp, #64]	@ 0x40
c0de3404:	2000      	movs	r0, #0
c0de3406:	260a      	movs	r6, #10
c0de3408:	f04f 0801 	mov.w	r8, #1
c0de340c:	e00d      	b.n	c0de342a <mcu_usb_printf+0x1a2>
c0de340e:	2000      	movs	r0, #0
c0de3410:	f241 3abc 	movw	sl, #5052	@ 0x13bc
c0de3414:	f2c0 0a00 	movt	sl, #0
c0de3418:	44fa      	add	sl, pc
c0de341a:	e0b5      	b.n	c0de3588 <mcu_usb_printf+0x300>
                    ulValue = va_arg(vaArgP, unsigned int);
c0de341c:	f8db 0000 	ldr.w	r0, [fp]
c0de3420:	9010      	str	r0, [sp, #64]	@ 0x40
c0de3422:	2000      	movs	r0, #0
c0de3424:	260a      	movs	r6, #10
c0de3426:	f04f 0800 	mov.w	r8, #0
c0de342a:	9005      	str	r0, [sp, #20]
c0de342c:	9910      	ldr	r1, [sp, #64]	@ 0x40
                         (((ulIdx * ulBase) <= ulValue) && (((ulIdx * ulBase) / ulBase) == ulIdx));
c0de342e:	f8cd b010 	str.w	fp, [sp, #16]
c0de3432:	428e      	cmp	r6, r1
c0de3434:	d902      	bls.n	c0de343c <mcu_usb_printf+0x1b4>
c0de3436:	2501      	movs	r5, #1
c0de3438:	2701      	movs	r7, #1
c0de343a:	e00e      	b.n	c0de345a <mcu_usb_printf+0x1d2>
c0de343c:	2202      	movs	r2, #2
c0de343e:	4633      	mov	r3, r6
c0de3440:	461d      	mov	r5, r3
c0de3442:	fba6 3003 	umull	r3, r0, r6, r3
c0de3446:	2800      	cmp	r0, #0
c0de3448:	bf18      	it	ne
c0de344a:	2001      	movne	r0, #1
c0de344c:	428b      	cmp	r3, r1
c0de344e:	4617      	mov	r7, r2
c0de3450:	d803      	bhi.n	c0de345a <mcu_usb_printf+0x1d2>
                    for (ulIdx = 1;
c0de3452:	2800      	cmp	r0, #0
c0de3454:	f107 0201 	add.w	r2, r7, #1
c0de3458:	d0f2      	beq.n	c0de3440 <mcu_usb_printf+0x1b8>
    if (*ulNeg) {
c0de345a:	eb07 0108 	add.w	r1, r7, r8
    if (ulWidth > ulActualLen) {
c0de345e:	ebbe 0b01 	subs.w	fp, lr, r1
c0de3462:	fa5f fa8c 	uxtb.w	sl, ip
    if (*ulNeg) {
c0de3466:	f088 0001 	eor.w	r0, r8, #1
c0de346a:	f8cd 8018 	str.w	r8, [sp, #24]
c0de346e:	f04f 0800 	mov.w	r8, #0
    if (ulWidth > ulActualLen) {
c0de3472:	bf38      	it	cc
c0de3474:	46c3      	movcc	fp, r8
c0de3476:	f1ba 0230 	subs.w	r2, sl, #48	@ 0x30
c0de347a:	bf18      	it	ne
c0de347c:	2201      	movne	r2, #1
    if (*ulNeg && (cFill == '0')) {
c0de347e:	4310      	orrs	r0, r2
c0de3480:	d106      	bne.n	c0de3490 <mcu_usb_printf+0x208>
        pcBuf[(*ulPos)++] = '-';
c0de3482:	202d      	movs	r0, #45	@ 0x2d
c0de3484:	f88d 0020 	strb.w	r0, [sp, #32]
c0de3488:	2000      	movs	r0, #0
c0de348a:	f04f 0801 	mov.w	r8, #1
c0de348e:	9006      	str	r0, [sp, #24]
    while (ulPaddingNeeded > 0) {
c0de3490:	4571      	cmp	r1, lr
c0de3492:	d31a      	bcc.n	c0de34ca <mcu_usb_printf+0x242>
    if (*ulNeg) {
c0de3494:	9806      	ldr	r0, [sp, #24]
c0de3496:	46a2      	mov	sl, r4
c0de3498:	b3a0      	cbz	r0, c0de3504 <mcu_usb_printf+0x27c>
c0de349a:	f8dd b010 	ldr.w	fp, [sp, #16]
        if (*ulPos >= PCBUF_SIZE) {
c0de349e:	f1b8 0f20 	cmp.w	r8, #32
c0de34a2:	ac08      	add	r4, sp, #32
c0de34a4:	d306      	bcc.n	c0de34b4 <mcu_usb_printf+0x22c>
    os_io_seph_cmd_printf(data, len);
c0de34a6:	fa1f f188 	uxth.w	r1, r8
c0de34aa:	4620      	mov	r0, r4
c0de34ac:	f7fc ff68 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de34b0:	f04f 0800 	mov.w	r8, #0
        pcBuf[(*ulPos)++] = '-';
c0de34b4:	202d      	movs	r0, #45	@ 0x2d
c0de34b6:	f804 0008 	strb.w	r0, [r4, r8]
c0de34ba:	f108 0801 	add.w	r8, r8, #1
                    for (; ulIdx; ulIdx /= ulBase) {
c0de34be:	bb2d      	cbnz	r5, c0de350c <mcu_usb_printf+0x284>
c0de34c0:	e050      	b.n	c0de3564 <mcu_usb_printf+0x2dc>
c0de34c2:	bf00      	nop
    while (ulPaddingNeeded > 0) {
c0de34c4:	f1bb 0f00 	cmp.w	fp, #0
c0de34c8:	d0e4      	beq.n	c0de3494 <mcu_usb_printf+0x20c>
        unsigned long bufferSpace = PCBUF_SIZE - *ulPos;
c0de34ca:	f1c8 0720 	rsb	r7, r8, #32
        if (chunkSize > bufferSpace) {
c0de34ce:	45bb      	cmp	fp, r7
c0de34d0:	bf98      	it	ls
c0de34d2:	465f      	movls	r7, fp
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de34d4:	b137      	cbz	r7, c0de34e4 <mcu_usb_printf+0x25c>
c0de34d6:	a808      	add	r0, sp, #32
c0de34d8:	4440      	add	r0, r8
            pcBuf[(*ulPos)++] = cFill;
c0de34da:	4639      	mov	r1, r7
c0de34dc:	4652      	mov	r2, sl
c0de34de:	f000 ff2d 	bl	c0de433c <__aeabi_memset>
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de34e2:	44b8      	add	r8, r7
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de34e4:	f1b8 0f20 	cmp.w	r8, #32
        ulPaddingNeeded -= chunkSize;
c0de34e8:	ebab 0b07 	sub.w	fp, fp, r7
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de34ec:	d3ea      	bcc.n	c0de34c4 <mcu_usb_printf+0x23c>
c0de34ee:	f1bb 0f00 	cmp.w	fp, #0
c0de34f2:	d0e7      	beq.n	c0de34c4 <mcu_usb_printf+0x23c>
    os_io_seph_cmd_printf(data, len);
c0de34f4:	fa1f f188 	uxth.w	r1, r8
c0de34f8:	a808      	add	r0, sp, #32
c0de34fa:	f7fc ff41 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de34fe:	f04f 0800 	mov.w	r8, #0
c0de3502:	e7df      	b.n	c0de34c4 <mcu_usb_printf+0x23c>
c0de3504:	f8dd b010 	ldr.w	fp, [sp, #16]
c0de3508:	ac08      	add	r4, sp, #32
                    for (; ulIdx; ulIdx /= ulBase) {
c0de350a:	b35d      	cbz	r5, c0de3564 <mcu_usb_printf+0x2dc>
c0de350c:	9805      	ldr	r0, [sp, #20]
c0de350e:	f241 27c8 	movw	r7, #4808	@ 0x12c8
c0de3512:	2800      	cmp	r0, #0
c0de3514:	f2c0 0700 	movt	r7, #0
c0de3518:	f241 20b2 	movw	r0, #4786	@ 0x12b2
c0de351c:	447f      	add	r7, pc
c0de351e:	f2c0 0000 	movt	r0, #0
c0de3522:	4478      	add	r0, pc
c0de3524:	bf08      	it	eq
c0de3526:	4607      	moveq	r7, r0
c0de3528:	e010      	b.n	c0de354c <mcu_usb_printf+0x2c4>
c0de352a:	bf00      	nop
c0de352c:	9810      	ldr	r0, [sp, #64]	@ 0x40
c0de352e:	42ae      	cmp	r6, r5
c0de3530:	fbb0 f0f5 	udiv	r0, r0, r5
c0de3534:	fbb5 f5f6 	udiv	r5, r5, r6
c0de3538:	fbb0 f1f6 	udiv	r1, r0, r6
c0de353c:	fb01 0016 	mls	r0, r1, r6, r0
c0de3540:	5c38      	ldrb	r0, [r7, r0]
c0de3542:	f804 0008 	strb.w	r0, [r4, r8]
c0de3546:	f108 0801 	add.w	r8, r8, #1
c0de354a:	d80b      	bhi.n	c0de3564 <mcu_usb_printf+0x2dc>
                        if (ulPos >= PCBUF_SIZE) {
c0de354c:	f1b8 0f20 	cmp.w	r8, #32
c0de3550:	d3ec      	bcc.n	c0de352c <mcu_usb_printf+0x2a4>
    os_io_seph_cmd_printf(data, len);
c0de3552:	fa1f f188 	uxth.w	r1, r8
c0de3556:	4620      	mov	r0, r4
c0de3558:	f7fc ff12 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de355c:	f04f 0800 	mov.w	r8, #0
c0de3560:	e7e4      	b.n	c0de352c <mcu_usb_printf+0x2a4>
c0de3562:	bf00      	nop
                    if (ulPos > 0) {
c0de3564:	f1b8 0f00 	cmp.w	r8, #0
c0de3568:	f10b 0b04 	add.w	fp, fp, #4
c0de356c:	f43f aea6 	beq.w	c0de32bc <mcu_usb_printf+0x34>
    os_io_seph_cmd_printf(data, len);
c0de3570:	fa1f f188 	uxth.w	r1, r8
c0de3574:	4620      	mov	r0, r4
c0de3576:	f7fc ff03 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de357a:	e69f      	b.n	c0de32bc <mcu_usb_printf+0x34>
c0de357c:	f241 2a5e 	movw	sl, #4702	@ 0x125e
c0de3580:	f2c0 0a00 	movt	sl, #0
c0de3584:	2001      	movs	r0, #1
c0de3586:	44fa      	add	sl, pc
                    pcStr = va_arg(vaArgP, char *);
c0de3588:	f85b 5b04 	ldr.w	r5, [fp], #4
                    switch (cStrlenSet) {
c0de358c:	b2c9      	uxtb	r1, r1
c0de358e:	2900      	cmp	r1, #0
c0de3590:	d04d      	beq.n	c0de362e <mcu_usb_printf+0x3a6>
c0de3592:	2901      	cmp	r1, #1
c0de3594:	d074      	beq.n	c0de3680 <mcu_usb_printf+0x3f8>
c0de3596:	2902      	cmp	r1, #2
c0de3598:	d14f      	bne.n	c0de363a <mcu_usb_printf+0x3b2>
                            if (pcStr[0] == '\0') {
c0de359a:	7828      	ldrb	r0, [r5, #0]
c0de359c:	2800      	cmp	r0, #0
c0de359e:	f040 8174 	bne.w	c0de388a <mcu_usb_printf+0x602>
                                for (ulCount = 0; ulCount < ulStrlen; ulCount++) {
c0de35a2:	f1b8 0f00 	cmp.w	r8, #0
c0de35a6:	f000 809f 	beq.w	c0de36e8 <mcu_usb_printf+0x460>
c0de35aa:	4645      	mov	r5, r8
    os_io_seph_cmd_printf(data, len);
c0de35ac:	4630      	mov	r0, r6
c0de35ae:	2101      	movs	r1, #1
c0de35b0:	f7fc fee6 	bl	c0de0380 <os_io_seph_cmd_printf>
                                for (ulCount = 0; ulCount < ulStrlen; ulCount++) {
c0de35b4:	3d01      	subs	r5, #1
c0de35b6:	d1f9      	bne.n	c0de35ac <mcu_usb_printf+0x324>
c0de35b8:	4642      	mov	r2, r8
                    if (ulCount > ulIdx) {
c0de35ba:	42ba      	cmp	r2, r7
c0de35bc:	f67f ae84 	bls.w	c0de32c8 <mcu_usb_printf+0x40>
c0de35c0:	e07c      	b.n	c0de36bc <mcu_usb_printf+0x434>
                    if (*format == 'l'
c0de35c2:	7820      	ldrb	r0, [r4, #0]
                        && (*(format + 1) == 'u' || *(format + 1) == 'd' || *(format + 1) == 'x'
c0de35c4:	286c      	cmp	r0, #108	@ 0x6c
c0de35c6:	f040 8160 	bne.w	c0de388a <mcu_usb_printf+0x602>
c0de35ca:	4623      	mov	r3, r4
c0de35cc:	f813 1f01 	ldrb.w	r1, [r3, #1]!
c0de35d0:	f1a1 0064 	sub.w	r0, r1, #100	@ 0x64
c0de35d4:	2814      	cmp	r0, #20
c0de35d6:	d807      	bhi.n	c0de35e8 <mcu_usb_printf+0x360>
c0de35d8:	2201      	movs	r2, #1
c0de35da:	fa02 f000 	lsl.w	r0, r2, r0
c0de35de:	2201      	movs	r2, #1
c0de35e0:	f2c0 0212 	movt	r2, #18
c0de35e4:	4210      	tst	r0, r2
c0de35e6:	d102      	bne.n	c0de35ee <mcu_usb_printf+0x366>
c0de35e8:	2958      	cmp	r1, #88	@ 0x58
c0de35ea:	f040 814e 	bne.w	c0de388a <mcu_usb_printf+0x602>
                        int64_t  slValue64 = va_arg(vaArgP, int64_t);
c0de35ee:	f10b 0007 	add.w	r0, fp, #7
c0de35f2:	f020 0007 	bic.w	r0, r0, #7
c0de35f6:	6842      	ldr	r2, [r0, #4]
c0de35f8:	f850 5b08 	ldr.w	r5, [r0], #8
                        if (*format == 'd') {
c0de35fc:	2974      	cmp	r1, #116	@ 0x74
c0de35fe:	9004      	str	r0, [sp, #16]
c0de3600:	dc65      	bgt.n	c0de36ce <mcu_usb_printf+0x446>
c0de3602:	2958      	cmp	r1, #88	@ 0x58
c0de3604:	d075      	beq.n	c0de36f2 <mcu_usb_printf+0x46a>
c0de3606:	2964      	cmp	r1, #100	@ 0x64
c0de3608:	f040 8086 	bne.w	c0de3718 <mcu_usb_printf+0x490>
                            if (slValue64 < 0) {
c0de360c:	eb15 70e2 	adds.w	r0, r5, r2, asr #31
c0de3610:	ea80 75e2 	eor.w	r5, r0, r2, asr #31
c0de3614:	eb42 70e2 	adc.w	r0, r2, r2, asr #31
c0de3618:	0fd1      	lsrs	r1, r2, #31
c0de361a:	ea80 72e2 	eor.w	r2, r0, r2, asr #31
c0de361e:	f241 10aa 	movw	r0, #4522	@ 0x11aa
c0de3622:	f2c0 0000 	movt	r0, #0
c0de3626:	1ca3      	adds	r3, r4, #2
c0de3628:	240a      	movs	r4, #10
c0de362a:	4478      	add	r0, pc
c0de362c:	e072      	b.n	c0de3714 <mcu_usb_printf+0x48c>
c0de362e:	2100      	movs	r1, #0
                            for (ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++) {
c0de3630:	5c6a      	ldrb	r2, [r5, r1]
c0de3632:	3101      	adds	r1, #1
c0de3634:	2a00      	cmp	r2, #0
c0de3636:	d1fb      	bne.n	c0de3630 <mcu_usb_printf+0x3a8>
                    switch (ulBase) {
c0de3638:	1e4f      	subs	r7, r1, #1
c0de363a:	b320      	cbz	r0, c0de3686 <mcu_usb_printf+0x3fe>
c0de363c:	46a0      	mov	r8, r4
                            for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de363e:	2f00      	cmp	r7, #0
c0de3640:	d04c      	beq.n	c0de36dc <mcu_usb_printf+0x454>
c0de3642:	2400      	movs	r4, #0
c0de3644:	2600      	movs	r6, #0
c0de3646:	e002      	b.n	c0de364e <mcu_usb_printf+0x3c6>
c0de3648:	3601      	adds	r6, #1
c0de364a:	42b7      	cmp	r7, r6
c0de364c:	d025      	beq.n	c0de369a <mcu_usb_printf+0x412>
                                nibble1 = (pcStr[ulCount] >> 4) & 0xF;
c0de364e:	5da9      	ldrb	r1, [r5, r6]
c0de3650:	a808      	add	r0, sp, #32
c0de3652:	090a      	lsrs	r2, r1, #4
                                nibble2 = pcStr[ulCount] & 0xF;
c0de3654:	f001 010f 	and.w	r1, r1, #15
c0de3658:	f81a 2002 	ldrb.w	r2, [sl, r2]
c0de365c:	f81a 1001 	ldrb.w	r1, [sl, r1]
c0de3660:	1903      	adds	r3, r0, r4
c0de3662:	5502      	strb	r2, [r0, r4]
c0de3664:	7059      	strb	r1, [r3, #1]
c0de3666:	1ca1      	adds	r1, r4, #2
                                if (idx + 1 >= sizeof(pcBuf)) {
c0de3668:	f1a4 001d 	sub.w	r0, r4, #29
c0de366c:	f110 0f21 	cmn.w	r0, #33	@ 0x21
c0de3670:	460c      	mov	r4, r1
c0de3672:	d8e9      	bhi.n	c0de3648 <mcu_usb_printf+0x3c0>
    os_io_seph_cmd_printf(data, len);
c0de3674:	b289      	uxth	r1, r1
c0de3676:	a808      	add	r0, sp, #32
c0de3678:	f7fc fe82 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de367c:	2400      	movs	r4, #0
c0de367e:	e7e3      	b.n	c0de3648 <mcu_usb_printf+0x3c0>
c0de3680:	4647      	mov	r7, r8
                    switch (ulBase) {
c0de3682:	2800      	cmp	r0, #0
c0de3684:	d1da      	bne.n	c0de363c <mcu_usb_printf+0x3b4>
    os_io_seph_cmd_printf(data, len);
c0de3686:	b2b9      	uxth	r1, r7
c0de3688:	4628      	mov	r0, r5
c0de368a:	4675      	mov	r5, lr
c0de368c:	f7fc fe78 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de3690:	462a      	mov	r2, r5
                    if (ulCount > ulIdx) {
c0de3692:	42ba      	cmp	r2, r7
c0de3694:	f67f ae18 	bls.w	c0de32c8 <mcu_usb_printf+0x40>
c0de3698:	e010      	b.n	c0de36bc <mcu_usb_printf+0x434>
c0de369a:	f640 764c 	movw	r6, #3916	@ 0xf4c
c0de369e:	f2c0 0600 	movt	r6, #0
c0de36a2:	463a      	mov	r2, r7
c0de36a4:	a808      	add	r0, sp, #32
c0de36a6:	447e      	add	r6, pc
                            if (idx != 0) {
c0de36a8:	b124      	cbz	r4, c0de36b4 <mcu_usb_printf+0x42c>
    os_io_seph_cmd_printf(data, len);
c0de36aa:	b2a1      	uxth	r1, r4
c0de36ac:	4614      	mov	r4, r2
c0de36ae:	f7fc fe67 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de36b2:	4622      	mov	r2, r4
c0de36b4:	4644      	mov	r4, r8
                    if (ulCount > ulIdx) {
c0de36b6:	42ba      	cmp	r2, r7
c0de36b8:	f67f ae06 	bls.w	c0de32c8 <mcu_usb_printf+0x40>
                        while (ulCount--) {
c0de36bc:	1abd      	subs	r5, r7, r2
c0de36be:	bf00      	nop
    os_io_seph_cmd_printf(data, len);
c0de36c0:	4630      	mov	r0, r6
c0de36c2:	2101      	movs	r1, #1
c0de36c4:	f7fc fe5c 	bl	c0de0380 <os_io_seph_cmd_printf>
                        while (ulCount--) {
c0de36c8:	3501      	adds	r5, #1
c0de36ca:	d3f9      	bcc.n	c0de36c0 <mcu_usb_printf+0x438>
c0de36cc:	e5fc      	b.n	c0de32c8 <mcu_usb_printf+0x40>
                        if (*format == 'd') {
c0de36ce:	2975      	cmp	r1, #117	@ 0x75
c0de36d0:	d018      	beq.n	c0de3704 <mcu_usb_printf+0x47c>
c0de36d2:	2978      	cmp	r1, #120	@ 0x78
c0de36d4:	d120      	bne.n	c0de3718 <mcu_usb_printf+0x490>
                        }
c0de36d6:	1ca3      	adds	r3, r4, #2
c0de36d8:	2410      	movs	r4, #16
c0de36da:	e015      	b.n	c0de3708 <mcu_usb_printf+0x480>
c0de36dc:	2200      	movs	r2, #0
c0de36de:	2400      	movs	r4, #0
c0de36e0:	a808      	add	r0, sp, #32
                            if (idx != 0) {
c0de36e2:	2c00      	cmp	r4, #0
c0de36e4:	d1e1      	bne.n	c0de36aa <mcu_usb_printf+0x422>
c0de36e6:	e7e5      	b.n	c0de36b4 <mcu_usb_printf+0x42c>
c0de36e8:	2200      	movs	r2, #0
                    if (ulCount > ulIdx) {
c0de36ea:	42ba      	cmp	r2, r7
c0de36ec:	f67f adec 	bls.w	c0de32c8 <mcu_usb_printf+0x40>
c0de36f0:	e7e4      	b.n	c0de36bc <mcu_usb_printf+0x434>
c0de36f2:	f241 00e4 	movw	r0, #4324	@ 0x10e4
c0de36f6:	f2c0 0000 	movt	r0, #0
                        }
c0de36fa:	1ca3      	adds	r3, r4, #2
c0de36fc:	2410      	movs	r4, #16
c0de36fe:	2100      	movs	r1, #0
c0de3700:	4478      	add	r0, pc
c0de3702:	e007      	b.n	c0de3714 <mcu_usb_printf+0x48c>
                        }
c0de3704:	1ca3      	adds	r3, r4, #2
c0de3706:	240a      	movs	r4, #10
c0de3708:	f241 00c2 	movw	r0, #4290	@ 0x10c2
c0de370c:	f2c0 0000 	movt	r0, #0
c0de3710:	2100      	movs	r1, #0
c0de3712:	4478      	add	r0, pc
c0de3714:	9005      	str	r0, [sp, #20]
c0de3716:	e009      	b.n	c0de372c <mcu_usb_printf+0x4a4>
c0de3718:	f241 00b4 	movw	r0, #4276	@ 0x10b4
c0de371c:	f2c0 0000 	movt	r0, #0
c0de3720:	4478      	add	r0, pc
c0de3722:	2100      	movs	r1, #0
c0de3724:	240a      	movs	r4, #10
c0de3726:	9005      	str	r0, [sp, #20]
c0de3728:	2500      	movs	r5, #0
c0de372a:	2200      	movs	r2, #0
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de372c:	1b28      	subs	r0, r5, r4
c0de372e:	9506      	str	r5, [sp, #24]
c0de3730:	4693      	mov	fp, r2
c0de3732:	f172 0000 	sbcs.w	r0, r2, #0
c0de3736:	f04f 0500 	mov.w	r5, #0
c0de373a:	e9cd 3101 	strd	r3, r1, [sp, #4]
                                           && (((ulIdx64 * ulBase) / ulBase) == ulIdx64));
c0de373e:	d205      	bcs.n	c0de374c <mcu_usb_printf+0x4c4>
c0de3740:	2201      	movs	r2, #1
c0de3742:	f04f 0801 	mov.w	r8, #1
c0de3746:	f04f 0a00 	mov.w	sl, #0
c0de374a:	e01b      	b.n	c0de3784 <mcu_usb_printf+0x4fc>
c0de374c:	2100      	movs	r1, #0
c0de374e:	2702      	movs	r7, #2
c0de3750:	4623      	mov	r3, r4
c0de3752:	bf00      	nop
c0de3754:	468a      	mov	sl, r1
c0de3756:	4698      	mov	r8, r3
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de3758:	fba4 3003 	umull	r3, r0, r4, r3
c0de375c:	fba1 1604 	umull	r1, r6, r1, r4
c0de3760:	1809      	adds	r1, r1, r0
c0de3762:	f04f 0000 	mov.w	r0, #0
c0de3766:	f140 0000 	adc.w	r0, r0, #0
c0de376a:	2e00      	cmp	r6, #0
c0de376c:	bf18      	it	ne
c0de376e:	2601      	movne	r6, #1
c0de3770:	9a06      	ldr	r2, [sp, #24]
c0de3772:	1ad2      	subs	r2, r2, r3
c0de3774:	eb7b 0201 	sbcs.w	r2, fp, r1
c0de3778:	463a      	mov	r2, r7
                                           && (((ulIdx64 * ulBase) / ulBase) == ulIdx64));
c0de377a:	d303      	bcc.n	c0de3784 <mcu_usb_printf+0x4fc>
c0de377c:	4330      	orrs	r0, r6
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de377e:	f102 0701 	add.w	r7, r2, #1
c0de3782:	d0e7      	beq.n	c0de3754 <mcu_usb_printf+0x4cc>
c0de3784:	9802      	ldr	r0, [sp, #8]
    if (*ulNeg) {
c0de3786:	1811      	adds	r1, r2, r0
    if (ulWidth > ulActualLen) {
c0de3788:	ebbe 0601 	subs.w	r6, lr, r1
c0de378c:	fa5f f28c 	uxtb.w	r2, ip
c0de3790:	bf38      	it	cc
c0de3792:	462e      	movcc	r6, r5
    if (*ulNeg && (cFill == '0')) {
c0de3794:	2a30      	cmp	r2, #48	@ 0x30
c0de3796:	9203      	str	r2, [sp, #12]
c0de3798:	d155      	bne.n	c0de3846 <mcu_usb_printf+0x5be>
c0de379a:	465f      	mov	r7, fp
c0de379c:	b128      	cbz	r0, c0de37aa <mcu_usb_printf+0x522>
        pcBuf[(*ulPos)++] = '-';
c0de379e:	202d      	movs	r0, #45	@ 0x2d
c0de37a0:	f88d 0020 	strb.w	r0, [sp, #32]
c0de37a4:	2000      	movs	r0, #0
c0de37a6:	2501      	movs	r5, #1
c0de37a8:	9002      	str	r0, [sp, #8]
    while (ulPaddingNeeded > 0) {
c0de37aa:	4571      	cmp	r1, lr
c0de37ac:	d353      	bcc.n	c0de3856 <mcu_usb_printf+0x5ce>
    if (*ulNeg) {
c0de37ae:	9802      	ldr	r0, [sp, #8]
c0de37b0:	b150      	cbz	r0, c0de37c8 <mcu_usb_printf+0x540>
c0de37b2:	f8dd b010 	ldr.w	fp, [sp, #16]
        if (*ulPos >= PCBUF_SIZE) {
c0de37b6:	2d20      	cmp	r5, #32
c0de37b8:	d30c      	bcc.n	c0de37d4 <mcu_usb_printf+0x54c>
c0de37ba:	ae08      	add	r6, sp, #32
    os_io_seph_cmd_printf(data, len);
c0de37bc:	b2a9      	uxth	r1, r5
c0de37be:	4630      	mov	r0, r6
c0de37c0:	f7fc fdde 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de37c4:	2500      	movs	r5, #0
c0de37c6:	e006      	b.n	c0de37d6 <mcu_usb_printf+0x54e>
c0de37c8:	f8dd b010 	ldr.w	fp, [sp, #16]
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de37cc:	ea58 000a 	orrs.w	r0, r8, sl
c0de37d0:	d135      	bne.n	c0de383e <mcu_usb_printf+0x5b6>
c0de37d2:	e006      	b.n	c0de37e2 <mcu_usb_printf+0x55a>
c0de37d4:	ae08      	add	r6, sp, #32
        pcBuf[(*ulPos)++] = '-';
c0de37d6:	202d      	movs	r0, #45	@ 0x2d
c0de37d8:	5570      	strb	r0, [r6, r5]
c0de37da:	3501      	adds	r5, #1
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de37dc:	ea58 000a 	orrs.w	r0, r8, sl
c0de37e0:	d12d      	bne.n	c0de383e <mcu_usb_printf+0x5b6>
                        if (ulPos > 0) {
c0de37e2:	b11d      	cbz	r5, c0de37ec <mcu_usb_printf+0x564>
    os_io_seph_cmd_printf(data, len);
c0de37e4:	b2a9      	uxth	r1, r5
c0de37e6:	a808      	add	r0, sp, #32
c0de37e8:	f7fc fdca 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de37ec:	9c01      	ldr	r4, [sp, #4]
c0de37ee:	f640 56fc 	movw	r6, #3580	@ 0xdfc
c0de37f2:	f2c0 0600 	movt	r6, #0
c0de37f6:	447e      	add	r6, pc
c0de37f8:	e566      	b.n	c0de32c8 <mcu_usb_printf+0x40>
c0de37fa:	bf00      	nop
c0de37fc:	ae08      	add	r6, sp, #32
c0de37fe:	b2a9      	uxth	r1, r5
c0de3800:	4630      	mov	r0, r6
c0de3802:	f7fc fdbd 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de3806:	2500      	movs	r5, #0
c0de3808:	9806      	ldr	r0, [sp, #24]
c0de380a:	4639      	mov	r1, r7
c0de380c:	4642      	mov	r2, r8
c0de380e:	4653      	mov	r3, sl
c0de3810:	f000 fd9e 	bl	c0de4350 <__aeabi_uldivmod>
c0de3814:	4622      	mov	r2, r4
c0de3816:	2300      	movs	r3, #0
c0de3818:	f000 fd9a 	bl	c0de4350 <__aeabi_uldivmod>
c0de381c:	9805      	ldr	r0, [sp, #20]
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de381e:	4651      	mov	r1, sl
c0de3820:	5c80      	ldrb	r0, [r0, r2]
c0de3822:	4622      	mov	r2, r4
c0de3824:	5570      	strb	r0, [r6, r5]
c0de3826:	4640      	mov	r0, r8
c0de3828:	2300      	movs	r3, #0
c0de382a:	3501      	adds	r5, #1
c0de382c:	f000 fd90 	bl	c0de4350 <__aeabi_uldivmod>
c0de3830:	ebb8 0204 	subs.w	r2, r8, r4
c0de3834:	f17a 0200 	sbcs.w	r2, sl, #0
c0de3838:	4680      	mov	r8, r0
c0de383a:	468a      	mov	sl, r1
c0de383c:	d3d1      	bcc.n	c0de37e2 <mcu_usb_printf+0x55a>
                            if (ulPos >= PCBUF_SIZE) {
c0de383e:	2d20      	cmp	r5, #32
c0de3840:	d2dc      	bcs.n	c0de37fc <mcu_usb_printf+0x574>
c0de3842:	ae08      	add	r6, sp, #32
c0de3844:	e7e0      	b.n	c0de3808 <mcu_usb_printf+0x580>
c0de3846:	465f      	mov	r7, fp
    while (ulPaddingNeeded > 0) {
c0de3848:	4571      	cmp	r1, lr
c0de384a:	d304      	bcc.n	c0de3856 <mcu_usb_printf+0x5ce>
c0de384c:	e7af      	b.n	c0de37ae <mcu_usb_printf+0x526>
c0de384e:	bf00      	nop
c0de3850:	465f      	mov	r7, fp
c0de3852:	2e00      	cmp	r6, #0
c0de3854:	d0ab      	beq.n	c0de37ae <mcu_usb_printf+0x526>
        unsigned long bufferSpace = PCBUF_SIZE - *ulPos;
c0de3856:	f1c5 0720 	rsb	r7, r5, #32
        if (chunkSize > bufferSpace) {
c0de385a:	42be      	cmp	r6, r7
c0de385c:	bf98      	it	ls
c0de385e:	4637      	movls	r7, r6
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de3860:	b137      	cbz	r7, c0de3870 <mcu_usb_printf+0x5e8>
c0de3862:	a808      	add	r0, sp, #32
            pcBuf[(*ulPos)++] = cFill;
c0de3864:	9a03      	ldr	r2, [sp, #12]
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de3866:	4428      	add	r0, r5
            pcBuf[(*ulPos)++] = cFill;
c0de3868:	4639      	mov	r1, r7
c0de386a:	f000 fd67 	bl	c0de433c <__aeabi_memset>
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de386e:	443d      	add	r5, r7
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de3870:	2d20      	cmp	r5, #32
        ulPaddingNeeded -= chunkSize;
c0de3872:	eba6 0607 	sub.w	r6, r6, r7
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de3876:	d3eb      	bcc.n	c0de3850 <mcu_usb_printf+0x5c8>
c0de3878:	2e00      	cmp	r6, #0
c0de387a:	465f      	mov	r7, fp
c0de387c:	d0e9      	beq.n	c0de3852 <mcu_usb_printf+0x5ca>
    os_io_seph_cmd_printf(data, len);
c0de387e:	b2a9      	uxth	r1, r5
c0de3880:	a808      	add	r0, sp, #32
c0de3882:	f7fc fd7d 	bl	c0de0380 <os_io_seph_cmd_printf>
c0de3886:	2500      	movs	r5, #0
c0de3888:	e7e3      	b.n	c0de3852 <mcu_usb_printf+0x5ca>
    (void) vformat_internal(printf_output, NULL, format, vaArgP);
    va_end(vaArgP);
}
c0de388a:	b011      	add	sp, #68	@ 0x44
c0de388c:	e8bd 4df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de3890:	b003      	add	sp, #12
c0de3892:	4770      	bx	lr

c0de3894 <vformat_internal>:
{
c0de3894:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de3898:	b092      	sub	sp, #72	@ 0x48
c0de389a:	4688      	mov	r8, r1
    while (*format) {
c0de389c:	7811      	ldrb	r1, [r2, #0]
c0de389e:	2900      	cmp	r1, #0
c0de38a0:	f000 8333 	beq.w	c0de3f0a <vformat_internal+0x676>
c0de38a4:	461f      	mov	r7, r3
c0de38a6:	4692      	mov	sl, r2
c0de38a8:	4606      	mov	r6, r0
c0de38aa:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de38ae:	e9cd 8007 	strd	r8, r0, [sp, #28]
c0de38b2:	e00e      	b.n	c0de38d2 <vformat_internal+0x3e>
                    output("%", 1, output_ctx);
c0de38b4:	f640 60ee 	movw	r0, #3822	@ 0xeee
c0de38b8:	f2c0 0000 	movt	r0, #0
c0de38bc:	4478      	add	r0, pc
c0de38be:	2101      	movs	r1, #1
c0de38c0:	4642      	mov	r2, r8
c0de38c2:	47b0      	blx	r6
c0de38c4:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
    while (*format) {
c0de38c8:	f89a 0000 	ldrb.w	r0, [sl]
c0de38cc:	2800      	cmp	r0, #0
c0de38ce:	f000 831c 	beq.w	c0de3f0a <vformat_internal+0x676>
c0de38d2:	f04f 0b00 	mov.w	fp, #0
c0de38d6:	bf00      	nop
        for (ulIdx = 0; (format[ulIdx] != '%') && (format[ulIdx] != '\0'); ulIdx++) {
c0de38d8:	f81a 000b 	ldrb.w	r0, [sl, fp]
c0de38dc:	b120      	cbz	r0, c0de38e8 <vformat_internal+0x54>
c0de38de:	2825      	cmp	r0, #37	@ 0x25
c0de38e0:	d002      	beq.n	c0de38e8 <vformat_internal+0x54>
c0de38e2:	f10b 0b01 	add.w	fp, fp, #1
c0de38e6:	e7f7      	b.n	c0de38d8 <vformat_internal+0x44>
        if (ulIdx > 0) {
c0de38e8:	f1bb 0f00 	cmp.w	fp, #0
c0de38ec:	d005      	beq.n	c0de38fa <vformat_internal+0x66>
            output(format, ulIdx, output_ctx);
c0de38ee:	4650      	mov	r0, sl
c0de38f0:	4659      	mov	r1, fp
c0de38f2:	4642      	mov	r2, r8
c0de38f4:	47b0      	blx	r6
c0de38f6:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de38fa:	44da      	add	sl, fp
        if (*format == '%') {
c0de38fc:	f89a 0000 	ldrb.w	r0, [sl]
c0de3900:	2825      	cmp	r0, #37	@ 0x25
c0de3902:	d1e1      	bne.n	c0de38c8 <vformat_internal+0x34>
            ulNeg      = 0;
c0de3904:	f10a 0a01 	add.w	sl, sl, #1
c0de3908:	2300      	movs	r3, #0
c0de390a:	f04f 0c20 	mov.w	ip, #32
c0de390e:	2500      	movs	r5, #0
c0de3910:	2100      	movs	r1, #0
c0de3912:	e002      	b.n	c0de391a <vformat_internal+0x86>
c0de3914:	f04f 0100 	mov.w	r1, #0
            switch (*format++) {
c0de3918:	d116      	bne.n	c0de3948 <vformat_internal+0xb4>
c0de391a:	f81a 2b01 	ldrb.w	r2, [sl], #1
c0de391e:	2a2d      	cmp	r2, #45	@ 0x2d
c0de3920:	ddf8      	ble.n	c0de3914 <vformat_internal+0x80>
c0de3922:	2a47      	cmp	r2, #71	@ 0x47
c0de3924:	dc34      	bgt.n	c0de3990 <vformat_internal+0xfc>
c0de3926:	f1a2 0030 	sub.w	r0, r2, #48	@ 0x30
c0de392a:	280a      	cmp	r0, #10
c0de392c:	d21a      	bcs.n	c0de3964 <vformat_internal+0xd0>
                    if ((format[-1] == '0') && (ulCount == 0)) {
c0de392e:	f082 0030 	eor.w	r0, r2, #48	@ 0x30
c0de3932:	4318      	orrs	r0, r3
                    ulCount *= 10;
c0de3934:	eb03 0083 	add.w	r0, r3, r3, lsl #2
                    ulCount += format[-1] - '0';
c0de3938:	eb02 0040 	add.w	r0, r2, r0, lsl #1
                    if ((format[-1] == '0') && (ulCount == 0)) {
c0de393c:	bf08      	it	eq
c0de393e:	f04f 0c30 	moveq.w	ip, #48	@ 0x30
                    ulCount += format[-1] - '0';
c0de3942:	f1a0 0330 	sub.w	r3, r0, #48	@ 0x30
c0de3946:	e7e8      	b.n	c0de391a <vformat_internal+0x86>
            switch (*format++) {
c0de3948:	2a25      	cmp	r2, #37	@ 0x25
c0de394a:	d0b3      	beq.n	c0de38b4 <vformat_internal+0x20>
c0de394c:	2a2a      	cmp	r2, #42	@ 0x2a
c0de394e:	f040 82e0 	bne.w	c0de3f12 <vformat_internal+0x67e>
                    if (*format == 's') {
c0de3952:	f89a 0000 	ldrb.w	r0, [sl]
c0de3956:	2873      	cmp	r0, #115	@ 0x73
c0de3958:	f040 82db 	bne.w	c0de3f12 <vformat_internal+0x67e>
c0de395c:	f857 5b04 	ldr.w	r5, [r7], #4
c0de3960:	2102      	movs	r1, #2
c0de3962:	e7da      	b.n	c0de391a <vformat_internal+0x86>
            switch (*format++) {
c0de3964:	2a2e      	cmp	r2, #46	@ 0x2e
c0de3966:	f040 82d4 	bne.w	c0de3f12 <vformat_internal+0x67e>
                    if (format[0] == '*'
c0de396a:	f89a 0000 	ldrb.w	r0, [sl]
                        && (format[1] == 's' || format[1] == 'H' || format[1] == 'h')) {
c0de396e:	282a      	cmp	r0, #42	@ 0x2a
c0de3970:	f040 82cf 	bne.w	c0de3f12 <vformat_internal+0x67e>
c0de3974:	f81a 0f01 	ldrb.w	r0, [sl, #1]!
c0de3978:	2101      	movs	r1, #1
c0de397a:	2848      	cmp	r0, #72	@ 0x48
c0de397c:	d004      	beq.n	c0de3988 <vformat_internal+0xf4>
c0de397e:	2868      	cmp	r0, #104	@ 0x68
c0de3980:	d002      	beq.n	c0de3988 <vformat_internal+0xf4>
c0de3982:	2873      	cmp	r0, #115	@ 0x73
c0de3984:	f040 82c5 	bne.w	c0de3f12 <vformat_internal+0x67e>
c0de3988:	f857 5b04 	ldr.w	r5, [r7], #4
c0de398c:	e7c5      	b.n	c0de391a <vformat_internal+0x86>
c0de398e:	bf00      	nop
            switch (*format++) {
c0de3990:	2a6b      	cmp	r2, #107	@ 0x6b
c0de3992:	dc11      	bgt.n	c0de39b8 <vformat_internal+0x124>
c0de3994:	2a62      	cmp	r2, #98	@ 0x62
c0de3996:	dd18      	ble.n	c0de39ca <vformat_internal+0x136>
c0de3998:	2a63      	cmp	r2, #99	@ 0x63
c0de399a:	d02a      	beq.n	c0de39f2 <vformat_internal+0x15e>
c0de399c:	2a64      	cmp	r2, #100	@ 0x64
c0de399e:	d02d      	beq.n	c0de39fc <vformat_internal+0x168>
c0de39a0:	2a68      	cmp	r2, #104	@ 0x68
c0de39a2:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de39a6:	f040 82b4 	bne.w	c0de3f12 <vformat_internal+0x67e>
c0de39aa:	f640 6620 	movw	r6, #3616	@ 0xe20
c0de39ae:	f2c0 0600 	movt	r6, #0
c0de39b2:	2001      	movs	r0, #1
c0de39b4:	447e      	add	r6, pc
c0de39b6:	e042      	b.n	c0de3a3e <vformat_internal+0x1aa>
c0de39b8:	2a72      	cmp	r2, #114	@ 0x72
c0de39ba:	dd0d      	ble.n	c0de39d8 <vformat_internal+0x144>
c0de39bc:	2a73      	cmp	r2, #115	@ 0x73
c0de39be:	d029      	beq.n	c0de3a14 <vformat_internal+0x180>
c0de39c0:	2a75      	cmp	r2, #117	@ 0x75
c0de39c2:	d02e      	beq.n	c0de3a22 <vformat_internal+0x18e>
c0de39c4:	2a78      	cmp	r2, #120	@ 0x78
c0de39c6:	d00c      	beq.n	c0de39e2 <vformat_internal+0x14e>
c0de39c8:	e2a3      	b.n	c0de3f12 <vformat_internal+0x67e>
c0de39ca:	2a48      	cmp	r2, #72	@ 0x48
c0de39cc:	d031      	beq.n	c0de3a32 <vformat_internal+0x19e>
c0de39ce:	2a58      	cmp	r2, #88	@ 0x58
c0de39d0:	f040 829f 	bne.w	c0de3f12 <vformat_internal+0x67e>
c0de39d4:	2001      	movs	r0, #1
c0de39d6:	e005      	b.n	c0de39e4 <vformat_internal+0x150>
c0de39d8:	2a6c      	cmp	r2, #108	@ 0x6c
c0de39da:	d059      	beq.n	c0de3a90 <vformat_internal+0x1fc>
c0de39dc:	2a70      	cmp	r2, #112	@ 0x70
c0de39de:	f040 8298 	bne.w	c0de3f12 <vformat_internal+0x67e>
c0de39e2:	2000      	movs	r0, #0
c0de39e4:	e9cd 7004 	strd	r7, r0, [sp, #16]
c0de39e8:	6838      	ldr	r0, [r7, #0]
c0de39ea:	2710      	movs	r7, #16
c0de39ec:	9011      	str	r0, [sp, #68]	@ 0x44
c0de39ee:	2500      	movs	r5, #0
c0de39f0:	e0f4      	b.n	c0de3bdc <vformat_internal+0x348>
                    ulValue = va_arg(vaArgP, unsigned long);
c0de39f2:	f857 0b04 	ldr.w	r0, [r7], #4
c0de39f6:	9011      	str	r0, [sp, #68]	@ 0x44
                    output((char *) &ulValue, 1, output_ctx);
c0de39f8:	a811      	add	r0, sp, #68	@ 0x44
c0de39fa:	e760      	b.n	c0de38be <vformat_internal+0x2a>
                    ulValue = va_arg(vaArgP, unsigned int);
c0de39fc:	6838      	ldr	r0, [r7, #0]
c0de39fe:	9704      	str	r7, [sp, #16]
                    if ((long) ulValue < 0) {
c0de3a00:	f1b0 3fff 	cmp.w	r0, #4294967295	@ 0xffffffff
                    ulValue = va_arg(vaArgP, unsigned int);
c0de3a04:	9011      	str	r0, [sp, #68]	@ 0x44
                    if ((long) ulValue < 0) {
c0de3a06:	f340 80e0 	ble.w	c0de3bca <vformat_internal+0x336>
c0de3a0a:	2000      	movs	r0, #0
c0de3a0c:	270a      	movs	r7, #10
c0de3a0e:	2500      	movs	r5, #0
c0de3a10:	9005      	str	r0, [sp, #20]
c0de3a12:	e0e0      	b.n	c0de3bd6 <vformat_internal+0x342>
c0de3a14:	f640 56b6 	movw	r6, #3510	@ 0xdb6
c0de3a18:	f2c0 0600 	movt	r6, #0
c0de3a1c:	2000      	movs	r0, #0
c0de3a1e:	447e      	add	r6, pc
c0de3a20:	e00d      	b.n	c0de3a3e <vformat_internal+0x1aa>
                    ulValue = va_arg(vaArgP, unsigned int);
c0de3a22:	6838      	ldr	r0, [r7, #0]
c0de3a24:	9704      	str	r7, [sp, #16]
c0de3a26:	9011      	str	r0, [sp, #68]	@ 0x44
c0de3a28:	270a      	movs	r7, #10
c0de3a2a:	2500      	movs	r5, #0
c0de3a2c:	2000      	movs	r0, #0
                    goto convert;
c0de3a2e:	9005      	str	r0, [sp, #20]
c0de3a30:	e0d4      	b.n	c0de3bdc <vformat_internal+0x348>
c0de3a32:	f640 56a8 	movw	r6, #3496	@ 0xda8
c0de3a36:	f2c0 0600 	movt	r6, #0
c0de3a3a:	2001      	movs	r0, #1
c0de3a3c:	447e      	add	r6, pc
                    pcStr = va_arg(vaArgP, char *);
c0de3a3e:	f857 4b04 	ldr.w	r4, [r7], #4
                    switch (cStrlenSet) {
c0de3a42:	b2c9      	uxtb	r1, r1
c0de3a44:	2900      	cmp	r1, #0
c0de3a46:	d05e      	beq.n	c0de3b06 <vformat_internal+0x272>
c0de3a48:	2901      	cmp	r1, #1
c0de3a4a:	d064      	beq.n	c0de3b16 <vformat_internal+0x282>
c0de3a4c:	2902      	cmp	r1, #2
c0de3a4e:	d163      	bne.n	c0de3b18 <vformat_internal+0x284>
                            if (pcStr[0] == '\0') {
c0de3a50:	7820      	ldrb	r0, [r4, #0]
c0de3a52:	2800      	cmp	r0, #0
c0de3a54:	f040 825d 	bne.w	c0de3f12 <vformat_internal+0x67e>
                                for (ulCount = 0; ulCount < ulStrlen; ulCount++) {
c0de3a58:	2d00      	cmp	r5, #0
c0de3a5a:	f000 8168 	beq.w	c0de3d2e <vformat_internal+0x49a>
c0de3a5e:	9704      	str	r7, [sp, #16]
c0de3a60:	9f08      	ldr	r7, [sp, #32]
c0de3a62:	f640 3686 	movw	r6, #2950	@ 0xb86
c0de3a66:	f2c0 0600 	movt	r6, #0
c0de3a6a:	462c      	mov	r4, r5
c0de3a6c:	447e      	add	r6, pc
c0de3a6e:	bf00      	nop
                                    output(" ", 1, output_ctx);
c0de3a70:	4630      	mov	r0, r6
c0de3a72:	2101      	movs	r1, #1
c0de3a74:	4642      	mov	r2, r8
c0de3a76:	47b8      	blx	r7
                                for (ulCount = 0; ulCount < ulStrlen; ulCount++) {
c0de3a78:	3c01      	subs	r4, #1
c0de3a7a:	d1f9      	bne.n	c0de3a70 <vformat_internal+0x1dc>
c0de3a7c:	462b      	mov	r3, r5
c0de3a7e:	4635      	mov	r5, r6
c0de3a80:	463e      	mov	r6, r7
c0de3a82:	9f04      	ldr	r7, [sp, #16]
c0de3a84:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
                    if (ulCount > ulIdx) {
c0de3a88:	455b      	cmp	r3, fp
c0de3a8a:	f67f af1d 	bls.w	c0de38c8 <vformat_internal+0x34>
c0de3a8e:	e093      	b.n	c0de3bb8 <vformat_internal+0x324>
                    if (*format == 'l'
c0de3a90:	f89a 0000 	ldrb.w	r0, [sl]
                        && (*(format + 1) == 'u' || *(format + 1) == 'd' || *(format + 1) == 'x'
c0de3a94:	286c      	cmp	r0, #108	@ 0x6c
c0de3a96:	f040 823c 	bne.w	c0de3f12 <vformat_internal+0x67e>
c0de3a9a:	4656      	mov	r6, sl
c0de3a9c:	f816 1f01 	ldrb.w	r1, [r6, #1]!
c0de3aa0:	f1a1 0064 	sub.w	r0, r1, #100	@ 0x64
c0de3aa4:	2814      	cmp	r0, #20
c0de3aa6:	d807      	bhi.n	c0de3ab8 <vformat_internal+0x224>
c0de3aa8:	2201      	movs	r2, #1
c0de3aaa:	fa02 f000 	lsl.w	r0, r2, r0
c0de3aae:	2201      	movs	r2, #1
c0de3ab0:	f2c0 0212 	movt	r2, #18
c0de3ab4:	4210      	tst	r0, r2
c0de3ab6:	d102      	bne.n	c0de3abe <vformat_internal+0x22a>
c0de3ab8:	2958      	cmp	r1, #88	@ 0x58
c0de3aba:	f040 822a 	bne.w	c0de3f12 <vformat_internal+0x67e>
                        int64_t  slValue64 = va_arg(vaArgP, int64_t);
c0de3abe:	1df8      	adds	r0, r7, #7
c0de3ac0:	f020 0007 	bic.w	r0, r0, #7
c0de3ac4:	4602      	mov	r2, r0
c0de3ac6:	6847      	ldr	r7, [r0, #4]
c0de3ac8:	f852 5b08 	ldr.w	r5, [r2], #8
                        if (*format == 'd') {
c0de3acc:	2974      	cmp	r1, #116	@ 0x74
c0de3ace:	dc59      	bgt.n	c0de3b84 <vformat_internal+0x2f0>
c0de3ad0:	2958      	cmp	r1, #88	@ 0x58
c0de3ad2:	f000 8137 	beq.w	c0de3d44 <vformat_internal+0x4b0>
c0de3ad6:	2964      	cmp	r1, #100	@ 0x64
c0de3ad8:	f040 814f 	bne.w	c0de3d7a <vformat_internal+0x4e6>
                            if (slValue64 < 0) {
c0de3adc:	f10a 0002 	add.w	r0, sl, #2
c0de3ae0:	9001      	str	r0, [sp, #4]
c0de3ae2:	0ff8      	lsrs	r0, r7, #31
c0de3ae4:	9002      	str	r0, [sp, #8]
c0de3ae6:	eb15 70e7 	adds.w	r0, r5, r7, asr #31
c0de3aea:	ea80 75e7 	eor.w	r5, r0, r7, asr #31
c0de3aee:	eb47 70e7 	adc.w	r0, r7, r7, asr #31
c0de3af2:	ea80 77e7 	eor.w	r7, r0, r7, asr #31
c0de3af6:	f640 40d2 	movw	r0, #3282	@ 0xcd2
c0de3afa:	f2c0 0000 	movt	r0, #0
c0de3afe:	f04f 080a 	mov.w	r8, #10
c0de3b02:	4478      	add	r0, pc
c0de3b04:	e137      	b.n	c0de3d76 <vformat_internal+0x4e2>
c0de3b06:	2100      	movs	r1, #0
                            for (ulIdx = 0; pcStr[ulIdx] != '\0'; ulIdx++) {
c0de3b08:	5c62      	ldrb	r2, [r4, r1]
c0de3b0a:	3101      	adds	r1, #1
c0de3b0c:	2a00      	cmp	r2, #0
c0de3b0e:	d1fb      	bne.n	c0de3b08 <vformat_internal+0x274>
                    switch (ulBase) {
c0de3b10:	f1a1 0b01 	sub.w	fp, r1, #1
c0de3b14:	e000      	b.n	c0de3b18 <vformat_internal+0x284>
c0de3b16:	46ab      	mov	fp, r5
c0de3b18:	f640 25d2 	movw	r5, #2770	@ 0xad2
c0de3b1c:	f2c0 0500 	movt	r5, #0
c0de3b20:	447d      	add	r5, pc
c0de3b22:	b310      	cbz	r0, c0de3b6a <vformat_internal+0x2d6>
                            for (ulCount = 0; ulCount < ulIdx; ulCount++) {
c0de3b24:	f1bb 0f00 	cmp.w	fp, #0
c0de3b28:	d038      	beq.n	c0de3b9c <vformat_internal+0x308>
c0de3b2a:	2100      	movs	r1, #0
c0de3b2c:	2500      	movs	r5, #0
c0de3b2e:	e002      	b.n	c0de3b36 <vformat_internal+0x2a2>
c0de3b30:	3501      	adds	r5, #1
c0de3b32:	45ab      	cmp	fp, r5
c0de3b34:	d01d      	beq.n	c0de3b72 <vformat_internal+0x2de>
                                nibble1 = (pcStr[ulCount] >> 4) & 0xF;
c0de3b36:	5d60      	ldrb	r0, [r4, r5]
c0de3b38:	eb0e 0301 	add.w	r3, lr, r1
c0de3b3c:	0902      	lsrs	r2, r0, #4
                                nibble2 = pcStr[ulCount] & 0xF;
c0de3b3e:	f000 000f 	and.w	r0, r0, #15
c0de3b42:	5c30      	ldrb	r0, [r6, r0]
c0de3b44:	5cb2      	ldrb	r2, [r6, r2]
c0de3b46:	7058      	strb	r0, [r3, #1]
                                if (idx + 1 >= sizeof(pcBuf)) {
c0de3b48:	f1a1 001d 	sub.w	r0, r1, #29
c0de3b4c:	f80e 2001 	strb.w	r2, [lr, r1]
c0de3b50:	f110 0f21 	cmn.w	r0, #33	@ 0x21
c0de3b54:	f101 0102 	add.w	r1, r1, #2
c0de3b58:	d8ea      	bhi.n	c0de3b30 <vformat_internal+0x29c>
                                    output(pcBuf, idx, output_ctx);
c0de3b5a:	9b08      	ldr	r3, [sp, #32]
c0de3b5c:	4670      	mov	r0, lr
c0de3b5e:	4642      	mov	r2, r8
c0de3b60:	4798      	blx	r3
c0de3b62:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de3b66:	2100      	movs	r1, #0
c0de3b68:	e7e2      	b.n	c0de3b30 <vformat_internal+0x29c>
c0de3b6a:	9e08      	ldr	r6, [sp, #32]
                            output(pcStr, ulIdx, output_ctx);
c0de3b6c:	4620      	mov	r0, r4
c0de3b6e:	4659      	mov	r1, fp
c0de3b70:	e019      	b.n	c0de3ba6 <vformat_internal+0x312>
c0de3b72:	9e08      	ldr	r6, [sp, #32]
c0de3b74:	f640 2574 	movw	r5, #2676	@ 0xa74
c0de3b78:	f2c0 0500 	movt	r5, #0
c0de3b7c:	465b      	mov	r3, fp
c0de3b7e:	447d      	add	r5, pc
                            if (idx != 0) {
c0de3b80:	b981      	cbnz	r1, c0de3ba4 <vformat_internal+0x310>
c0de3b82:	e016      	b.n	c0de3bb2 <vformat_internal+0x31e>
                        if (*format == 'd') {
c0de3b84:	2975      	cmp	r1, #117	@ 0x75
c0de3b86:	f000 80ea 	beq.w	c0de3d5e <vformat_internal+0x4ca>
c0de3b8a:	2978      	cmp	r1, #120	@ 0x78
c0de3b8c:	f040 80f5 	bne.w	c0de3d7a <vformat_internal+0x4e6>
                        }
c0de3b90:	f10a 0002 	add.w	r0, sl, #2
c0de3b94:	9001      	str	r0, [sp, #4]
c0de3b96:	f04f 0810 	mov.w	r8, #16
c0de3b9a:	e0e5      	b.n	c0de3d68 <vformat_internal+0x4d4>
c0de3b9c:	9e08      	ldr	r6, [sp, #32]
c0de3b9e:	2300      	movs	r3, #0
c0de3ba0:	2100      	movs	r1, #0
                            if (idx != 0) {
c0de3ba2:	b131      	cbz	r1, c0de3bb2 <vformat_internal+0x31e>
                                output(pcBuf, idx, output_ctx);
c0de3ba4:	4670      	mov	r0, lr
c0de3ba6:	4642      	mov	r2, r8
c0de3ba8:	461c      	mov	r4, r3
c0de3baa:	47b0      	blx	r6
c0de3bac:	4623      	mov	r3, r4
c0de3bae:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
                    if (ulCount > ulIdx) {
c0de3bb2:	455b      	cmp	r3, fp
c0de3bb4:	f67f ae88 	bls.w	c0de38c8 <vformat_internal+0x34>
                        while (ulCount--) {
c0de3bb8:	ebab 0403 	sub.w	r4, fp, r3
                            output(" ", 1, output_ctx);
c0de3bbc:	4628      	mov	r0, r5
c0de3bbe:	2101      	movs	r1, #1
c0de3bc0:	4642      	mov	r2, r8
c0de3bc2:	47b0      	blx	r6
                        while (ulCount--) {
c0de3bc4:	3401      	adds	r4, #1
c0de3bc6:	d3f9      	bcc.n	c0de3bbc <vformat_internal+0x328>
c0de3bc8:	e67c      	b.n	c0de38c4 <vformat_internal+0x30>
                        ulValue = -(long) ((int) ulValue);
c0de3bca:	4240      	negs	r0, r0
c0de3bcc:	9011      	str	r0, [sp, #68]	@ 0x44
c0de3bce:	2000      	movs	r0, #0
c0de3bd0:	9005      	str	r0, [sp, #20]
c0de3bd2:	270a      	movs	r7, #10
c0de3bd4:	2501      	movs	r5, #1
c0de3bd6:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de3bda:	bf00      	nop
c0de3bdc:	9911      	ldr	r1, [sp, #68]	@ 0x44
c0de3bde:	461c      	mov	r4, r3
                         (((ulIdx * ulBase) <= ulValue) && (((ulIdx * ulBase) / ulBase) == ulIdx));
c0de3be0:	428f      	cmp	r7, r1
c0de3be2:	d903      	bls.n	c0de3bec <vformat_internal+0x358>
c0de3be4:	f04f 0b01 	mov.w	fp, #1
c0de3be8:	2001      	movs	r0, #1
c0de3bea:	e00e      	b.n	c0de3c0a <vformat_internal+0x376>
c0de3bec:	2302      	movs	r3, #2
c0de3bee:	463a      	mov	r2, r7
c0de3bf0:	4693      	mov	fp, r2
c0de3bf2:	fba7 2602 	umull	r2, r6, r7, r2
c0de3bf6:	2e00      	cmp	r6, #0
c0de3bf8:	bf18      	it	ne
c0de3bfa:	2601      	movne	r6, #1
c0de3bfc:	428a      	cmp	r2, r1
c0de3bfe:	4618      	mov	r0, r3
c0de3c00:	d803      	bhi.n	c0de3c0a <vformat_internal+0x376>
                    for (ulIdx = 1;
c0de3c02:	2e00      	cmp	r6, #0
c0de3c04:	f100 0301 	add.w	r3, r0, #1
c0de3c08:	d0f2      	beq.n	c0de3bf0 <vformat_internal+0x35c>
    if (*ulNeg) {
c0de3c0a:	4428      	add	r0, r5
c0de3c0c:	f085 0101 	eor.w	r1, r5, #1
c0de3c10:	9506      	str	r5, [sp, #24]
    if (ulWidth > ulActualLen) {
c0de3c12:	ebb4 0800 	subs.w	r8, r4, r0
c0de3c16:	fa5f f58c 	uxtb.w	r5, ip
c0de3c1a:	4623      	mov	r3, r4
c0de3c1c:	f04f 0400 	mov.w	r4, #0
c0de3c20:	bf38      	it	cc
c0de3c22:	46a0      	movcc	r8, r4
c0de3c24:	f1b5 0230 	subs.w	r2, r5, #48	@ 0x30
c0de3c28:	bf18      	it	ne
c0de3c2a:	2201      	movne	r2, #1
    if (*ulNeg && (cFill == '0')) {
c0de3c2c:	4311      	orrs	r1, r2
c0de3c2e:	d105      	bne.n	c0de3c3c <vformat_internal+0x3a8>
        pcBuf[(*ulPos)++] = '-';
c0de3c30:	212d      	movs	r1, #45	@ 0x2d
c0de3c32:	f88d 1024 	strb.w	r1, [sp, #36]	@ 0x24
c0de3c36:	2100      	movs	r1, #0
c0de3c38:	2401      	movs	r4, #1
c0de3c3a:	9106      	str	r1, [sp, #24]
c0de3c3c:	9e08      	ldr	r6, [sp, #32]
    while (ulPaddingNeeded > 0) {
c0de3c3e:	4298      	cmp	r0, r3
c0de3c40:	d314      	bcc.n	c0de3c6c <vformat_internal+0x3d8>
    if (*ulNeg) {
c0de3c42:	9806      	ldr	r0, [sp, #24]
c0de3c44:	b388      	cbz	r0, c0de3caa <vformat_internal+0x416>
        if (*ulPos >= PCBUF_SIZE) {
c0de3c46:	2c20      	cmp	r4, #32
c0de3c48:	d335      	bcc.n	c0de3cb6 <vformat_internal+0x422>
c0de3c4a:	f8dd 801c 	ldr.w	r8, [sp, #28]
            output(pcBuf, *ulPos, output_ctx);
c0de3c4e:	4670      	mov	r0, lr
c0de3c50:	4621      	mov	r1, r4
c0de3c52:	4642      	mov	r2, r8
c0de3c54:	47b0      	blx	r6
c0de3c56:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de3c5a:	2400      	movs	r4, #0
c0de3c5c:	e02d      	b.n	c0de3cba <vformat_internal+0x426>
c0de3c5e:	bf00      	nop
c0de3c60:	9e08      	ldr	r6, [sp, #32]
c0de3c62:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
    while (ulPaddingNeeded > 0) {
c0de3c66:	f1b8 0f00 	cmp.w	r8, #0
c0de3c6a:	d0ea      	beq.n	c0de3c42 <vformat_internal+0x3ae>
        unsigned long bufferSpace = PCBUF_SIZE - *ulPos;
c0de3c6c:	f1c4 0620 	rsb	r6, r4, #32
        if (chunkSize > bufferSpace) {
c0de3c70:	45b0      	cmp	r8, r6
c0de3c72:	bf98      	it	ls
c0de3c74:	4646      	movls	r6, r8
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de3c76:	b136      	cbz	r6, c0de3c86 <vformat_internal+0x3f2>
c0de3c78:	eb0e 0004 	add.w	r0, lr, r4
            pcBuf[(*ulPos)++] = cFill;
c0de3c7c:	4631      	mov	r1, r6
c0de3c7e:	462a      	mov	r2, r5
c0de3c80:	f000 fb5c 	bl	c0de433c <__aeabi_memset>
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de3c84:	4434      	add	r4, r6
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de3c86:	2c20      	cmp	r4, #32
        ulPaddingNeeded -= chunkSize;
c0de3c88:	eba8 0806 	sub.w	r8, r8, r6
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de3c8c:	d3e8      	bcc.n	c0de3c60 <vformat_internal+0x3cc>
c0de3c8e:	9e08      	ldr	r6, [sp, #32]
c0de3c90:	f1b8 0f00 	cmp.w	r8, #0
c0de3c94:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de3c98:	d0e5      	beq.n	c0de3c66 <vformat_internal+0x3d2>
            output(pcBuf, *ulPos, output_ctx);
c0de3c9a:	9a07      	ldr	r2, [sp, #28]
c0de3c9c:	4670      	mov	r0, lr
c0de3c9e:	4621      	mov	r1, r4
c0de3ca0:	47b0      	blx	r6
c0de3ca2:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de3ca6:	2400      	movs	r4, #0
c0de3ca8:	e7dd      	b.n	c0de3c66 <vformat_internal+0x3d2>
c0de3caa:	f8dd 801c 	ldr.w	r8, [sp, #28]
                    for (; ulIdx; ulIdx /= ulBase) {
c0de3cae:	f1bb 0f00 	cmp.w	fp, #0
c0de3cb2:	d109      	bne.n	c0de3cc8 <vformat_internal+0x434>
c0de3cb4:	e032      	b.n	c0de3d1c <vformat_internal+0x488>
c0de3cb6:	f8dd 801c 	ldr.w	r8, [sp, #28]
        pcBuf[(*ulPos)++] = '-';
c0de3cba:	202d      	movs	r0, #45	@ 0x2d
c0de3cbc:	f80e 0004 	strb.w	r0, [lr, r4]
c0de3cc0:	3401      	adds	r4, #1
                    for (; ulIdx; ulIdx /= ulBase) {
c0de3cc2:	f1bb 0f00 	cmp.w	fp, #0
c0de3cc6:	d029      	beq.n	c0de3d1c <vformat_internal+0x488>
c0de3cc8:	9805      	ldr	r0, [sp, #20]
c0de3cca:	f640 350c 	movw	r5, #2828	@ 0xb0c
c0de3cce:	2800      	cmp	r0, #0
c0de3cd0:	f2c0 0500 	movt	r5, #0
c0de3cd4:	f640 20f6 	movw	r0, #2806	@ 0xaf6
c0de3cd8:	447d      	add	r5, pc
c0de3cda:	f2c0 0000 	movt	r0, #0
c0de3cde:	4478      	add	r0, pc
c0de3ce0:	bf08      	it	eq
c0de3ce2:	4605      	moveq	r5, r0
c0de3ce4:	e010      	b.n	c0de3d08 <vformat_internal+0x474>
c0de3ce6:	bf00      	nop
c0de3ce8:	9811      	ldr	r0, [sp, #68]	@ 0x44
c0de3cea:	455f      	cmp	r7, fp
c0de3cec:	fbb0 f0fb 	udiv	r0, r0, fp
c0de3cf0:	fbbb fbf7 	udiv	fp, fp, r7
c0de3cf4:	fbb0 f1f7 	udiv	r1, r0, r7
c0de3cf8:	fb01 0017 	mls	r0, r1, r7, r0
c0de3cfc:	5c28      	ldrb	r0, [r5, r0]
c0de3cfe:	f80e 0004 	strb.w	r0, [lr, r4]
c0de3d02:	f104 0401 	add.w	r4, r4, #1
c0de3d06:	d809      	bhi.n	c0de3d1c <vformat_internal+0x488>
                        if (ulPos >= PCBUF_SIZE) {
c0de3d08:	2c20      	cmp	r4, #32
c0de3d0a:	d3ed      	bcc.n	c0de3ce8 <vformat_internal+0x454>
                            output(pcBuf, ulPos, output_ctx);
c0de3d0c:	4670      	mov	r0, lr
c0de3d0e:	4621      	mov	r1, r4
c0de3d10:	4642      	mov	r2, r8
c0de3d12:	47b0      	blx	r6
c0de3d14:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de3d18:	2400      	movs	r4, #0
c0de3d1a:	e7e5      	b.n	c0de3ce8 <vformat_internal+0x454>
c0de3d1c:	9f04      	ldr	r7, [sp, #16]
                    if (ulPos > 0) {
c0de3d1e:	2c00      	cmp	r4, #0
c0de3d20:	f107 0704 	add.w	r7, r7, #4
c0de3d24:	f43f add0 	beq.w	c0de38c8 <vformat_internal+0x34>
                        output(pcBuf, ulPos, output_ctx);
c0de3d28:	4670      	mov	r0, lr
c0de3d2a:	4621      	mov	r1, r4
c0de3d2c:	e5c8      	b.n	c0de38c0 <vformat_internal+0x2c>
c0de3d2e:	9e08      	ldr	r6, [sp, #32]
c0de3d30:	f640 05b8 	movw	r5, #2232	@ 0x8b8
c0de3d34:	f2c0 0500 	movt	r5, #0
c0de3d38:	2300      	movs	r3, #0
c0de3d3a:	447d      	add	r5, pc
                    if (ulCount > ulIdx) {
c0de3d3c:	455b      	cmp	r3, fp
c0de3d3e:	f67f adc3 	bls.w	c0de38c8 <vformat_internal+0x34>
c0de3d42:	e739      	b.n	c0de3bb8 <vformat_internal+0x324>
                        }
c0de3d44:	f10a 0002 	add.w	r0, sl, #2
c0de3d48:	9001      	str	r0, [sp, #4]
c0de3d4a:	2000      	movs	r0, #0
c0de3d4c:	9002      	str	r0, [sp, #8]
c0de3d4e:	f640 208a 	movw	r0, #2698	@ 0xa8a
c0de3d52:	f2c0 0000 	movt	r0, #0
c0de3d56:	f04f 0810 	mov.w	r8, #16
c0de3d5a:	4478      	add	r0, pc
c0de3d5c:	e00b      	b.n	c0de3d76 <vformat_internal+0x4e2>
                        }
c0de3d5e:	f10a 0002 	add.w	r0, sl, #2
c0de3d62:	f04f 080a 	mov.w	r8, #10
c0de3d66:	9001      	str	r0, [sp, #4]
c0de3d68:	2000      	movs	r0, #0
c0de3d6a:	9002      	str	r0, [sp, #8]
c0de3d6c:	f640 2060 	movw	r0, #2656	@ 0xa60
c0de3d70:	f2c0 0000 	movt	r0, #0
c0de3d74:	4478      	add	r0, pc
c0de3d76:	9005      	str	r0, [sp, #20]
c0de3d78:	e00c      	b.n	c0de3d94 <vformat_internal+0x500>
c0de3d7a:	2000      	movs	r0, #0
c0de3d7c:	9601      	str	r6, [sp, #4]
c0de3d7e:	9002      	str	r0, [sp, #8]
c0de3d80:	f640 204c 	movw	r0, #2636	@ 0xa4c
c0de3d84:	f2c0 0000 	movt	r0, #0
c0de3d88:	4478      	add	r0, pc
c0de3d8a:	f04f 080a 	mov.w	r8, #10
c0de3d8e:	9005      	str	r0, [sp, #20]
c0de3d90:	2500      	movs	r5, #0
c0de3d92:	2700      	movs	r7, #0
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de3d94:	ebb5 0008 	subs.w	r0, r5, r8
c0de3d98:	f04f 0a00 	mov.w	sl, #0
c0de3d9c:	469b      	mov	fp, r3
c0de3d9e:	f177 0000 	sbcs.w	r0, r7, #0
c0de3da2:	f04f 0400 	mov.w	r4, #0
c0de3da6:	9204      	str	r2, [sp, #16]
c0de3da8:	9506      	str	r5, [sp, #24]
c0de3daa:	9703      	str	r7, [sp, #12]
                                           && (((ulIdx64 * ulBase) / ulBase) == ulIdx64));
c0de3dac:	d203      	bcs.n	c0de3db6 <vformat_internal+0x522>
c0de3dae:	2201      	movs	r2, #1
c0de3db0:	2501      	movs	r5, #1
c0de3db2:	2700      	movs	r7, #0
c0de3db4:	e01a      	b.n	c0de3dec <vformat_internal+0x558>
c0de3db6:	2100      	movs	r1, #0
c0de3db8:	f04f 0e02 	mov.w	lr, #2
c0de3dbc:	4643      	mov	r3, r8
c0de3dbe:	bf00      	nop
c0de3dc0:	460f      	mov	r7, r1
c0de3dc2:	461d      	mov	r5, r3
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de3dc4:	fba8 3003 	umull	r3, r0, r8, r3
c0de3dc8:	fba1 1608 	umull	r1, r6, r1, r8
c0de3dcc:	1809      	adds	r1, r1, r0
c0de3dce:	f14a 0000 	adc.w	r0, sl, #0
c0de3dd2:	2e00      	cmp	r6, #0
c0de3dd4:	bf18      	it	ne
c0de3dd6:	2601      	movne	r6, #1
c0de3dd8:	9a06      	ldr	r2, [sp, #24]
c0de3dda:	1ad2      	subs	r2, r2, r3
c0de3ddc:	9a03      	ldr	r2, [sp, #12]
c0de3dde:	418a      	sbcs	r2, r1
c0de3de0:	4672      	mov	r2, lr
                                           && (((ulIdx64 * ulBase) / ulBase) == ulIdx64));
c0de3de2:	d303      	bcc.n	c0de3dec <vformat_internal+0x558>
c0de3de4:	4330      	orrs	r0, r6
                        for (ulIdx64 = 1; (((ulIdx64 * ulBase) <= ulValue64)
c0de3de6:	f102 0e01 	add.w	lr, r2, #1
c0de3dea:	d0e9      	beq.n	c0de3dc0 <vformat_internal+0x52c>
c0de3dec:	9802      	ldr	r0, [sp, #8]
    if (*ulNeg) {
c0de3dee:	1811      	adds	r1, r2, r0
    if (ulWidth > ulActualLen) {
c0de3df0:	ebbb 0a01 	subs.w	sl, fp, r1
c0de3df4:	fa5f f28c 	uxtb.w	r2, ip
c0de3df8:	bf38      	it	cc
c0de3dfa:	46a2      	movcc	sl, r4
c0de3dfc:	4616      	mov	r6, r2
    if (*ulNeg && (cFill == '0')) {
c0de3dfe:	2a30      	cmp	r2, #48	@ 0x30
c0de3e00:	d15d      	bne.n	c0de3ebe <vformat_internal+0x62a>
c0de3e02:	2800      	cmp	r0, #0
c0de3e04:	a809      	add	r0, sp, #36	@ 0x24
c0de3e06:	d005      	beq.n	c0de3e14 <vformat_internal+0x580>
        pcBuf[(*ulPos)++] = '-';
c0de3e08:	222d      	movs	r2, #45	@ 0x2d
c0de3e0a:	f88d 2024 	strb.w	r2, [sp, #36]	@ 0x24
c0de3e0e:	2200      	movs	r2, #0
c0de3e10:	2401      	movs	r4, #1
c0de3e12:	9202      	str	r2, [sp, #8]
    while (ulPaddingNeeded > 0) {
c0de3e14:	4559      	cmp	r1, fp
c0de3e16:	d35b      	bcc.n	c0de3ed0 <vformat_internal+0x63c>
    if (*ulNeg) {
c0de3e18:	9902      	ldr	r1, [sp, #8]
c0de3e1a:	b169      	cbz	r1, c0de3e38 <vformat_internal+0x5a4>
c0de3e1c:	f8dd a00c 	ldr.w	sl, [sp, #12]
        if (*ulPos >= PCBUF_SIZE) {
c0de3e20:	2c20      	cmp	r4, #32
c0de3e22:	d305      	bcc.n	c0de3e30 <vformat_internal+0x59c>
            output(pcBuf, *ulPos, output_ctx);
c0de3e24:	e9dd 2307 	ldrd	r2, r3, [sp, #28]
c0de3e28:	4621      	mov	r1, r4
c0de3e2a:	4798      	blx	r3
c0de3e2c:	a809      	add	r0, sp, #36	@ 0x24
c0de3e2e:	2400      	movs	r4, #0
        pcBuf[(*ulPos)++] = '-';
c0de3e30:	212d      	movs	r1, #45	@ 0x2d
c0de3e32:	5501      	strb	r1, [r0, r4]
c0de3e34:	3401      	adds	r4, #1
c0de3e36:	e001      	b.n	c0de3e3c <vformat_internal+0x5a8>
c0de3e38:	f8dd a00c 	ldr.w	sl, [sp, #12]
c0de3e3c:	f8dd b020 	ldr.w	fp, [sp, #32]
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de3e40:	ea55 0007 	orrs.w	r0, r5, r7
c0de3e44:	d129      	bne.n	c0de3e9a <vformat_internal+0x606>
                        if (ulPos > 0) {
c0de3e46:	b38c      	cbz	r4, c0de3eac <vformat_internal+0x618>
c0de3e48:	f8dd 801c 	ldr.w	r8, [sp, #28]
c0de3e4c:	ad09      	add	r5, sp, #36	@ 0x24
                            output(pcBuf, ulPos, output_ctx);
c0de3e4e:	4628      	mov	r0, r5
c0de3e50:	4621      	mov	r1, r4
c0de3e52:	4642      	mov	r2, r8
c0de3e54:	465e      	mov	r6, fp
c0de3e56:	47d8      	blx	fp
c0de3e58:	f8dd a004 	ldr.w	sl, [sp, #4]
c0de3e5c:	9f04      	ldr	r7, [sp, #16]
c0de3e5e:	46ae      	mov	lr, r5
c0de3e60:	e532      	b.n	c0de38c8 <vformat_internal+0x34>
c0de3e62:	bf00      	nop
c0de3e64:	9806      	ldr	r0, [sp, #24]
c0de3e66:	4651      	mov	r1, sl
c0de3e68:	462a      	mov	r2, r5
c0de3e6a:	463b      	mov	r3, r7
c0de3e6c:	f000 fa70 	bl	c0de4350 <__aeabi_uldivmod>
c0de3e70:	4642      	mov	r2, r8
c0de3e72:	2300      	movs	r3, #0
c0de3e74:	f000 fa6c 	bl	c0de4350 <__aeabi_uldivmod>
c0de3e78:	9805      	ldr	r0, [sp, #20]
                        for (; ulIdx64; ulIdx64 /= ulBase) {
c0de3e7a:	4639      	mov	r1, r7
c0de3e7c:	5c80      	ldrb	r0, [r0, r2]
c0de3e7e:	4642      	mov	r2, r8
c0de3e80:	5530      	strb	r0, [r6, r4]
c0de3e82:	4628      	mov	r0, r5
c0de3e84:	2300      	movs	r3, #0
c0de3e86:	3401      	adds	r4, #1
c0de3e88:	f000 fa62 	bl	c0de4350 <__aeabi_uldivmod>
c0de3e8c:	ebb5 0208 	subs.w	r2, r5, r8
c0de3e90:	f177 0200 	sbcs.w	r2, r7, #0
c0de3e94:	4605      	mov	r5, r0
c0de3e96:	460f      	mov	r7, r1
c0de3e98:	d3d5      	bcc.n	c0de3e46 <vformat_internal+0x5b2>
c0de3e9a:	ae09      	add	r6, sp, #36	@ 0x24
                            if (ulPos >= PCBUF_SIZE) {
c0de3e9c:	2c20      	cmp	r4, #32
c0de3e9e:	d3e1      	bcc.n	c0de3e64 <vformat_internal+0x5d0>
                                output(pcBuf, ulPos, output_ctx);
c0de3ea0:	9a07      	ldr	r2, [sp, #28]
c0de3ea2:	4630      	mov	r0, r6
c0de3ea4:	4621      	mov	r1, r4
c0de3ea6:	47d8      	blx	fp
c0de3ea8:	2400      	movs	r4, #0
c0de3eaa:	e7db      	b.n	c0de3e64 <vformat_internal+0x5d0>
c0de3eac:	f8dd a004 	ldr.w	sl, [sp, #4]
c0de3eb0:	f8dd 801c 	ldr.w	r8, [sp, #28]
c0de3eb4:	9f04      	ldr	r7, [sp, #16]
c0de3eb6:	f10d 0e24 	add.w	lr, sp, #36	@ 0x24
c0de3eba:	465e      	mov	r6, fp
c0de3ebc:	e504      	b.n	c0de38c8 <vformat_internal+0x34>
c0de3ebe:	a809      	add	r0, sp, #36	@ 0x24
    while (ulPaddingNeeded > 0) {
c0de3ec0:	4559      	cmp	r1, fp
c0de3ec2:	d305      	bcc.n	c0de3ed0 <vformat_internal+0x63c>
c0de3ec4:	e7a8      	b.n	c0de3e18 <vformat_internal+0x584>
c0de3ec6:	bf00      	nop
c0de3ec8:	a809      	add	r0, sp, #36	@ 0x24
c0de3eca:	f1ba 0f00 	cmp.w	sl, #0
c0de3ece:	d0a3      	beq.n	c0de3e18 <vformat_internal+0x584>
        unsigned long bufferSpace = PCBUF_SIZE - *ulPos;
c0de3ed0:	f1c4 0b20 	rsb	fp, r4, #32
        if (chunkSize > bufferSpace) {
c0de3ed4:	45da      	cmp	sl, fp
c0de3ed6:	bf98      	it	ls
c0de3ed8:	46d3      	movls	fp, sl
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de3eda:	f1bb 0f00 	cmp.w	fp, #0
c0de3ede:	d005      	beq.n	c0de3eec <vformat_internal+0x658>
c0de3ee0:	4420      	add	r0, r4
            pcBuf[(*ulPos)++] = cFill;
c0de3ee2:	4659      	mov	r1, fp
c0de3ee4:	4632      	mov	r2, r6
c0de3ee6:	f000 fa29 	bl	c0de433c <__aeabi_memset>
        for (unsigned long i = 0; i < chunkSize; i++) {
c0de3eea:	445c      	add	r4, fp
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de3eec:	2c20      	cmp	r4, #32
        ulPaddingNeeded -= chunkSize;
c0de3eee:	ebaa 0a0b 	sub.w	sl, sl, fp
        if (*ulPos >= PCBUF_SIZE && ulPaddingNeeded > 0) {
c0de3ef2:	d3e9      	bcc.n	c0de3ec8 <vformat_internal+0x634>
c0de3ef4:	f1ba 0f00 	cmp.w	sl, #0
c0de3ef8:	a809      	add	r0, sp, #36	@ 0x24
c0de3efa:	d0e6      	beq.n	c0de3eca <vformat_internal+0x636>
            output(pcBuf, *ulPos, output_ctx);
c0de3efc:	e9dd 2307 	ldrd	r2, r3, [sp, #28]
c0de3f00:	4621      	mov	r1, r4
c0de3f02:	4798      	blx	r3
c0de3f04:	a809      	add	r0, sp, #36	@ 0x24
c0de3f06:	2400      	movs	r4, #0
c0de3f08:	e7df      	b.n	c0de3eca <vformat_internal+0x636>
c0de3f0a:	2000      	movs	r0, #0
}
c0de3f0c:	b012      	add	sp, #72	@ 0x48
c0de3f0e:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de3f12:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de3f16:	b012      	add	sp, #72	@ 0x48
c0de3f18:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}

c0de3f1c <snprintf>:

#endif  // HAVE_PRINTF

#ifdef HAVE_SPRINTF
int snprintf(char *str, size_t str_size, const char *format, ...)
{
c0de3f1c:	b081      	sub	sp, #4
c0de3f1e:	b570      	push	{r4, r5, r6, lr}
c0de3f20:	b085      	sub	sp, #20
c0de3f22:	4605      	mov	r5, r0
    va_list       vaArgP;
    sprintf_ctx_t ctx;
    int           result;

    if (str == NULL || str_size < 1) {
c0de3f24:	2800      	cmp	r0, #0
c0de3f26:	f04f 30ff 	mov.w	r0, #4294967295	@ 0xffffffff
c0de3f2a:	9309      	str	r3, [sp, #36]	@ 0x24
c0de3f2c:	d01d      	beq.n	c0de3f6a <snprintf+0x4e>
c0de3f2e:	460e      	mov	r6, r1
c0de3f30:	b1d9      	cbz	r1, c0de3f6a <snprintf+0x4e>
        return -1;  // Error: invalid arguments
    }

    memset(str, 0, str_size);
c0de3f32:	4628      	mov	r0, r5
c0de3f34:	4631      	mov	r1, r6
c0de3f36:	4614      	mov	r4, r2
c0de3f38:	f000 fa06 	bl	c0de4348 <__aeabi_memclr>
    // Reserve space for null terminator
    str_size--;
c0de3f3c:	1e70      	subs	r0, r6, #1

    ctx.str      = str;
c0de3f3e:	e9cd 5001 	strd	r5, r0, [sp, #4]
c0de3f42:	2000      	movs	r0, #0
c0de3f44:	ab09      	add	r3, sp, #36	@ 0x24
    ctx.str_size = str_size;
    ctx.written  = 0;  // Initialize counter
c0de3f46:	9003      	str	r0, [sp, #12]

    va_start(vaArgP, format);
c0de3f48:	9304      	str	r3, [sp, #16]
    result = vformat_internal(sprintf_output, &ctx, format, vaArgP);
c0de3f4a:	f240 001f 	movw	r0, #31
c0de3f4e:	f2c0 0000 	movt	r0, #0
c0de3f52:	4478      	add	r0, pc
c0de3f54:	a901      	add	r1, sp, #4
c0de3f56:	4622      	mov	r2, r4
c0de3f58:	f7ff fc9c 	bl	c0de3894 <vformat_internal>
c0de3f5c:	4601      	mov	r1, r0
c0de3f5e:	9803      	ldr	r0, [sp, #12]
    va_end(vaArgP);

    // If format error, return -1
    if (result < 0) {
c0de3f60:	f1b1 3fff 	cmp.w	r1, #4294967295	@ 0xffffffff
c0de3f64:	bfd8      	it	le
c0de3f66:	f04f 30ff 	movle.w	r0, #4294967295	@ 0xffffffff
        return -1;
    }
    return ctx.written;  // Return number of characters written
}
c0de3f6a:	b005      	add	sp, #20
c0de3f6c:	e8bd 4070 	ldmia.w	sp!, {r4, r5, r6, lr}
c0de3f70:	b001      	add	sp, #4
c0de3f72:	4770      	bx	lr

c0de3f74 <sprintf_output>:
{
c0de3f74:	b5b0      	push	{r4, r5, r7, lr}
c0de3f76:	4614      	mov	r4, r2
c0de3f78:	4602      	mov	r2, r0
    if (ctx->str_size == 0) {
c0de3f7a:	e9d4 5001 	ldrd	r5, r0, [r4, #4]
    ctx->written += len;
c0de3f7e:	4408      	add	r0, r1
    if (ctx->str_size == 0) {
c0de3f80:	2d00      	cmp	r5, #0
    ctx->written += len;
c0de3f82:	60a0      	str	r0, [r4, #8]
}
c0de3f84:	bf08      	it	eq
c0de3f86:	bdb0      	popeq	{r4, r5, r7, pc}
    memmove(ctx->str, data, len);
c0de3f88:	6820      	ldr	r0, [r4, #0]
    len = MIN(len, ctx->str_size);
c0de3f8a:	428d      	cmp	r5, r1
c0de3f8c:	bf88      	it	hi
c0de3f8e:	460d      	movhi	r5, r1
    memmove(ctx->str, data, len);
c0de3f90:	4611      	mov	r1, r2
c0de3f92:	462a      	mov	r2, r5
c0de3f94:	f000 f9d0 	bl	c0de4338 <__aeabi_memmove>
    ctx->str += len;
c0de3f98:	e9d4 0100 	ldrd	r0, r1, [r4]
c0de3f9c:	4428      	add	r0, r5
    ctx->str_size -= len;
c0de3f9e:	1b49      	subs	r1, r1, r5
    ctx->str += len;
c0de3fa0:	e9c4 0100 	strd	r0, r1, [r4]
}
c0de3fa4:	bdb0      	pop	{r4, r5, r7, pc}
	...

c0de3fa8 <pic>:
void *pic(void *link_address)
{
    void *n, *en;

    // check if in the LINKED TEXT zone
    __asm volatile("ldr %0, =_nvram" : "=r"(n));
c0de3fa8:	490a      	ldr	r1, [pc, #40]	@ (c0de3fd4 <pic+0x2c>)
    __asm volatile("ldr %0, =_envram" : "=r"(en));
    if (link_address >= n && link_address <= en) {
c0de3faa:	4281      	cmp	r1, r0
    __asm volatile("ldr %0, =_envram" : "=r"(en));
c0de3fac:	490a      	ldr	r1, [pc, #40]	@ (c0de3fd8 <pic+0x30>)
    if (link_address >= n && link_address <= en) {
c0de3fae:	d806      	bhi.n	c0de3fbe <pic+0x16>
c0de3fb0:	4281      	cmp	r1, r0
c0de3fb2:	d304      	bcc.n	c0de3fbe <pic+0x16>
c0de3fb4:	b580      	push	{r7, lr}
        link_address = pic_internal(link_address);
c0de3fb6:	f000 f815 	bl	c0de3fe4 <pic_internal>
c0de3fba:	e8bd 4080 	ldmia.w	sp!, {r7, lr}
    }

#ifndef BOLOS_OS_UPGRADER_APP
    // check if in the LINKED RAM zone
    __asm volatile("ldr %0, =_bss" : "=r"(n));
c0de3fbe:	4907      	ldr	r1, [pc, #28]	@ (c0de3fdc <pic+0x34>)
    __asm volatile("ldr %0, =_estack" : "=r"(en));
    if (link_address >= n && link_address <= en) {
c0de3fc0:	4288      	cmp	r0, r1
    __asm volatile("ldr %0, =_estack" : "=r"(en));
c0de3fc2:	4a07      	ldr	r2, [pc, #28]	@ (c0de3fe0 <pic+0x38>)
    if (link_address >= n && link_address <= en) {
c0de3fc4:	d305      	bcc.n	c0de3fd2 <pic+0x2a>
c0de3fc6:	4290      	cmp	r0, r2
        // deref into the RAM therefore add the RAM offset from R9
        link_address = (char *) link_address - (char *) n + (char *) en;
    }
#endif  // BOLOS_OS_UPGRADER_APP

    return link_address;
c0de3fc8:	bf88      	it	hi
c0de3fca:	4770      	bxhi	lr
        link_address = (char *) link_address - (char *) n + (char *) en;
c0de3fcc:	1a40      	subs	r0, r0, r1
        __asm volatile("mov %0, r9" : "=r"(en));
c0de3fce:	464a      	mov	r2, r9
        link_address = (char *) link_address - (char *) n + (char *) en;
c0de3fd0:	4410      	add	r0, r2
    return link_address;
c0de3fd2:	4770      	bx	lr
c0de3fd4:	c0de0000 	.word	0xc0de0000
c0de3fd8:	c0de4843 	.word	0xc0de4843
c0de3fdc:	da7a0000 	.word	0xda7a0000
c0de3fe0:	da7aa000 	.word	0xda7aa000

c0de3fe4 <pic_internal>:
    __asm volatile("mov r2, pc\n");
c0de3fe4:	467a      	mov	r2, pc
    __asm volatile("ldr r1, =pic_internal\n");
c0de3fe6:	4902      	ldr	r1, [pc, #8]	@ (c0de3ff0 <pic_internal+0xc>)
    __asm volatile("adds r1, r1, #3\n");
c0de3fe8:	1cc9      	adds	r1, r1, #3
    __asm volatile("subs r1, r1, r2\n");
c0de3fea:	1a89      	subs	r1, r1, r2
    __asm volatile("subs r0, r0, r1\n");
c0de3fec:	1a40      	subs	r0, r0, r1
    __asm volatile("bx lr\n");
c0de3fee:	4770      	bx	lr
c0de3ff0:	c0de3fe5 	.word	0xc0de3fe5

c0de3ff4 <SVC_Call>:
c0de3ff4:	df01      	svc	1
c0de3ff6:	2900      	cmp	r1, #0
c0de3ff8:	d100      	bne.n	c0de3ffc <exception>
c0de3ffa:	4770      	bx	lr

c0de3ffc <exception>:
c0de3ffc:	4608      	mov	r0, r1
c0de3ffe:	f7ff f92a 	bl	c0de3256 <os_longjmp>

c0de4002 <os_pki_load_certificate>:
                                    uint8_t                  *certificate,
                                    size_t                    certificate_len,
                                    uint8_t                  *trusted_name,
                                    size_t                   *trusted_name_len,
                                    cx_ecfp_384_public_key_t *public_key)
{
c0de4002:	b580      	push	{r7, lr}
c0de4004:	b086      	sub	sp, #24
c0de4006:	e9dd ec08 	ldrd	lr, ip, [sp, #32]
    unsigned int parameters[6];
    parameters[0] = (unsigned int) expected_key_usage;
c0de400a:	e88d 400f 	stmia.w	sp, {r0, r1, r2, r3, lr}
c0de400e:	20aa      	movs	r0, #170	@ 0xaa
c0de4010:	f2c0 6000 	movt	r0, #1536	@ 0x600
c0de4014:	4669      	mov	r1, sp
    parameters[1] = (unsigned int) certificate;
    parameters[2] = (unsigned int) certificate_len;
    parameters[3] = (unsigned int) trusted_name;
    parameters[4] = (unsigned int) trusted_name_len;
    parameters[5] = (unsigned int) public_key;
c0de4016:	f8cd c014 	str.w	ip, [sp, #20]
    return (bolos_err_t) SVC_Call(SYSCALL_os_pki_load_certificate_ID, parameters);
c0de401a:	f7ff ffeb 	bl	c0de3ff4 <SVC_Call>
c0de401e:	b006      	add	sp, #24
c0de4020:	bd80      	pop	{r7, pc}

c0de4022 <os_perso_is_pin_set>:
    SVC_Call(SYSCALL_os_perso_set_current_identity_pin_ID, parameters);
    return;
}

bolos_bool_t os_perso_is_pin_set(void)
{
c0de4022:	b580      	push	{r7, lr}
c0de4024:	b082      	sub	sp, #8
c0de4026:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de4028:	9001      	str	r0, [sp, #4]
c0de402a:	4669      	mov	r1, sp
    return (bolos_bool_t) SVC_Call(SYSCALL_os_perso_is_pin_set_ID, parameters);
c0de402c:	209e      	movs	r0, #158	@ 0x9e
c0de402e:	f7ff ffe1 	bl	c0de3ff4 <SVC_Call>
c0de4032:	b2c0      	uxtb	r0, r0
c0de4034:	b002      	add	sp, #8
c0de4036:	bd80      	pop	{r7, pc}

c0de4038 <os_global_pin_is_validated>:
}

bolos_bool_t os_global_pin_is_validated(void)
{
c0de4038:	b580      	push	{r7, lr}
c0de403a:	b082      	sub	sp, #8
c0de403c:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de403e:	9001      	str	r0, [sp, #4]
c0de4040:	4669      	mov	r1, sp
    return (bolos_bool_t) SVC_Call(SYSCALL_os_global_pin_is_validated_ID, parameters);
c0de4042:	20a0      	movs	r0, #160	@ 0xa0
c0de4044:	f7ff ffd6 	bl	c0de3ff4 <SVC_Call>
c0de4048:	b2c0      	uxtb	r0, r0
c0de404a:	b002      	add	sp, #8
c0de404c:	bd80      	pop	{r7, pc}

c0de404e <os_ux>:
    SVC_Call(SYSCALL_os_registry_get_ID, parameters);
    return;
}

unsigned int os_ux(bolos_ux_params_t *params)
{
c0de404e:	b580      	push	{r7, lr}
c0de4050:	b082      	sub	sp, #8
    unsigned int parameters[2];
    parameters[0] = (unsigned int) params;
c0de4052:	9000      	str	r0, [sp, #0]
c0de4054:	2000      	movs	r0, #0
    parameters[1] = 0;
c0de4056:	9001      	str	r0, [sp, #4]
c0de4058:	2064      	movs	r0, #100	@ 0x64
c0de405a:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de405e:	4669      	mov	r1, sp
    return (unsigned int) SVC_Call(SYSCALL_os_ux_ID, parameters);
c0de4060:	f7ff ffc8 	bl	c0de3ff4 <SVC_Call>
c0de4064:	b002      	add	sp, #8
c0de4066:	bd80      	pop	{r7, pc}

c0de4068 <os_flags>:
    // remove the warning caused by -Winvalid-noreturn
    __builtin_unreachable();
}

unsigned int os_flags(void)
{
c0de4068:	b580      	push	{r7, lr}
c0de406a:	b082      	sub	sp, #8
c0de406c:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de406e:	9001      	str	r0, [sp, #4]
c0de4070:	4669      	mov	r1, sp
    return (unsigned int) SVC_Call(SYSCALL_os_flags_ID, parameters);
c0de4072:	206a      	movs	r0, #106	@ 0x6a
c0de4074:	f7ff ffbe 	bl	c0de3ff4 <SVC_Call>
c0de4078:	b002      	add	sp, #8
c0de407a:	bd80      	pop	{r7, pc}

c0de407c <os_registry_get_current_app_tag>:
}

unsigned int os_registry_get_current_app_tag(unsigned int   tag,
                                             unsigned char *buffer,
                                             unsigned int   maxlen)
{
c0de407c:	b580      	push	{r7, lr}
c0de407e:	b084      	sub	sp, #16
    unsigned int parameters[3];
    parameters[0] = (unsigned int) tag;
c0de4080:	ab01      	add	r3, sp, #4
c0de4082:	c307      	stmia	r3!, {r0, r1, r2}
c0de4084:	2074      	movs	r0, #116	@ 0x74
c0de4086:	f2c0 3000 	movt	r0, #768	@ 0x300
c0de408a:	a901      	add	r1, sp, #4
    parameters[1] = (unsigned int) buffer;
    parameters[2] = (unsigned int) maxlen;
    return (unsigned int) SVC_Call(SYSCALL_os_registry_get_current_app_tag_ID, parameters);
c0de408c:	f7ff ffb2 	bl	c0de3ff4 <SVC_Call>
c0de4090:	b004      	add	sp, #16
c0de4092:	bd80      	pop	{r7, pc}

c0de4094 <os_sched_exit>:
    SVC_Call(SYSCALL_os_sched_exec_ID, parameters);
    return;
}

void __attribute__((noreturn)) os_sched_exit(bolos_task_status_t exit_code)
{
c0de4094:	b082      	sub	sp, #8
    unsigned int parameters[2];
    parameters[0] = (unsigned int) exit_code;
c0de4096:	9000      	str	r0, [sp, #0]
c0de4098:	2000      	movs	r0, #0
    parameters[1] = 0;
c0de409a:	9001      	str	r0, [sp, #4]
c0de409c:	209a      	movs	r0, #154	@ 0x9a
c0de409e:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de40a2:	4669      	mov	r1, sp
    SVC_Call(SYSCALL_os_sched_exit_ID, parameters);
c0de40a4:	f7ff ffa6 	bl	c0de3ff4 <SVC_Call>

    // The os_sched_exit syscall should never return.
    // Just in case, crash the device thanks to an undefined instruction.
    // To avoid the __builtin_unreachable undefined behaviour
    asm volatile("udf #255");
c0de40a8:	deff      	udf	#255	@ 0xff

c0de40aa <os_io_init>:
    parameters[4] = (unsigned int) flags;
    return (int) SVC_Call(SYSCALL_os_io_seph_se_rx_event_ID, parameters);
}

__attribute((weak)) int os_io_init(os_io_init_t *init)
{
c0de40aa:	b580      	push	{r7, lr}
c0de40ac:	b082      	sub	sp, #8
    unsigned int parameters[1];
    parameters[0] = (unsigned int) init;
c0de40ae:	9001      	str	r0, [sp, #4]
c0de40b0:	2084      	movs	r0, #132	@ 0x84
c0de40b2:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de40b6:	a901      	add	r1, sp, #4
    return (int) SVC_Call(SYSCALL_os_io_init_ID, parameters);
c0de40b8:	f7ff ff9c 	bl	c0de3ff4 <SVC_Call>
c0de40bc:	b002      	add	sp, #8
c0de40be:	bd80      	pop	{r7, pc}

c0de40c0 <os_io_start>:
}

__attribute((weak)) int os_io_start(void)
{
c0de40c0:	b580      	push	{r7, lr}
c0de40c2:	b082      	sub	sp, #8
c0de40c4:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de40c6:	9001      	str	r0, [sp, #4]
c0de40c8:	2085      	movs	r0, #133	@ 0x85
c0de40ca:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de40ce:	4669      	mov	r1, sp
    return (int) SVC_Call(SYSCALL_os_io_start_ID, parameters);
c0de40d0:	f7ff ff90 	bl	c0de3ff4 <SVC_Call>
c0de40d4:	b002      	add	sp, #8
c0de40d6:	bd80      	pop	{r7, pc}

c0de40d8 <os_io_stop>:
}

__attribute((weak)) int os_io_stop(void)
{
c0de40d8:	b580      	push	{r7, lr}
c0de40da:	b082      	sub	sp, #8
c0de40dc:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de40de:	9001      	str	r0, [sp, #4]
c0de40e0:	2086      	movs	r0, #134	@ 0x86
c0de40e2:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de40e6:	4669      	mov	r1, sp
    return (int) SVC_Call(SYSCALL_os_io_stop_ID, parameters);
c0de40e8:	f7ff ff84 	bl	c0de3ff4 <SVC_Call>
c0de40ec:	b002      	add	sp, #8
c0de40ee:	bd80      	pop	{r7, pc}

c0de40f0 <os_io_tx_cmd>:

__attribute((weak)) int os_io_tx_cmd(unsigned char        type,
                                     const unsigned char *buffer,
                                     unsigned short       length,
                                     unsigned int        *timeout_ms)
{
c0de40f0:	b580      	push	{r7, lr}
c0de40f2:	b084      	sub	sp, #16
    unsigned int parameters[4];
    parameters[0] = (unsigned int) type;
c0de40f4:	e88d 000f 	stmia.w	sp, {r0, r1, r2, r3}
c0de40f8:	2088      	movs	r0, #136	@ 0x88
c0de40fa:	f2c0 4000 	movt	r0, #1024	@ 0x400
c0de40fe:	4669      	mov	r1, sp
    parameters[1] = (unsigned int) buffer;
    parameters[2] = (unsigned int) length;
    parameters[3] = (unsigned int) timeout_ms;
    return (int) SVC_Call(SYSCALL_os_io_tx_cmd_ID, parameters);
c0de4100:	f7ff ff78 	bl	c0de3ff4 <SVC_Call>
c0de4104:	b004      	add	sp, #16
c0de4106:	bd80      	pop	{r7, pc}

c0de4108 <os_io_rx_evt>:

__attribute((weak)) int os_io_rx_evt(unsigned char *buffer,
                                     unsigned short buffer_max_length,
                                     unsigned int  *timeout_ms,
                                     bool           check_se_event)
{
c0de4108:	b580      	push	{r7, lr}
c0de410a:	b084      	sub	sp, #16
    unsigned int parameters[4];
    parameters[0] = (unsigned int) buffer;
c0de410c:	e88d 000f 	stmia.w	sp, {r0, r1, r2, r3}
c0de4110:	2089      	movs	r0, #137	@ 0x89
c0de4112:	f2c0 3000 	movt	r0, #768	@ 0x300
c0de4116:	4669      	mov	r1, sp
    parameters[1] = (unsigned int) buffer_max_length;
    parameters[2] = (unsigned int) timeout_ms;
    parameters[3] = (unsigned int) check_se_event;
    return (int) SVC_Call(SYSCALL_os_io_rx_evt_ID, parameters);
c0de4118:	f7ff ff6c 	bl	c0de3ff4 <SVC_Call>
c0de411c:	b004      	add	sp, #16
c0de411e:	bd80      	pop	{r7, pc}

c0de4120 <try_context_get>:
    parameters[1] = 0;
    return (unsigned int) SVC_Call(SYSCALL_nvm_erase_page_ID, parameters);
}

try_context_t *try_context_get(void)
{
c0de4120:	b580      	push	{r7, lr}
c0de4122:	b082      	sub	sp, #8
c0de4124:	2000      	movs	r0, #0
    unsigned int parameters[2];
    parameters[1] = 0;
c0de4126:	9001      	str	r0, [sp, #4]
c0de4128:	4669      	mov	r1, sp
    return (try_context_t *) SVC_Call(SYSCALL_try_context_get_ID, parameters);
c0de412a:	2087      	movs	r0, #135	@ 0x87
c0de412c:	f7ff ff62 	bl	c0de3ff4 <SVC_Call>
c0de4130:	b002      	add	sp, #8
c0de4132:	bd80      	pop	{r7, pc}

c0de4134 <try_context_set>:
}

try_context_t *try_context_set(try_context_t *context)
{
c0de4134:	b580      	push	{r7, lr}
c0de4136:	b082      	sub	sp, #8
    unsigned int parameters[2];
    parameters[0] = (unsigned int) context;
c0de4138:	9000      	str	r0, [sp, #0]
c0de413a:	2000      	movs	r0, #0
    parameters[1] = 0;
c0de413c:	9001      	str	r0, [sp, #4]
c0de413e:	f240 100b 	movw	r0, #267	@ 0x10b
c0de4142:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de4146:	4669      	mov	r1, sp
    return (try_context_t *) SVC_Call(SYSCALL_try_context_set_ID, parameters);
c0de4148:	f7ff ff54 	bl	c0de3ff4 <SVC_Call>
c0de414c:	b002      	add	sp, #8
c0de414e:	bd80      	pop	{r7, pc}

c0de4150 <os_sched_last_status>:
}

bolos_task_status_t os_sched_last_status(unsigned int task_idx)
{
c0de4150:	b580      	push	{r7, lr}
c0de4152:	b082      	sub	sp, #8
    unsigned int parameters[2];
    parameters[0] = (unsigned int) task_idx;
c0de4154:	9000      	str	r0, [sp, #0]
c0de4156:	2000      	movs	r0, #0
    parameters[1] = 0;
c0de4158:	9001      	str	r0, [sp, #4]
c0de415a:	209c      	movs	r0, #156	@ 0x9c
c0de415c:	f2c0 1000 	movt	r0, #256	@ 0x100
c0de4160:	4669      	mov	r1, sp
    return (bolos_task_status_t) SVC_Call(SYSCALL_os_sched_last_status_ID, parameters);
c0de4162:	f7ff ff47 	bl	c0de3ff4 <SVC_Call>
c0de4166:	b2c0      	uxtb	r0, r0
c0de4168:	b002      	add	sp, #8
c0de416a:	bd80      	pop	{r7, pc}

c0de416c <__udivmoddi4>:
c0de416c:	e92d 4df0 	stmdb	sp!, {r4, r5, r6, r7, r8, sl, fp, lr}
c0de4170:	f8dd c020 	ldr.w	ip, [sp, #32]
c0de4174:	4604      	mov	r4, r0
c0de4176:	b179      	cbz	r1, c0de4198 <__udivmoddi4+0x2c>
c0de4178:	b1ba      	cbz	r2, c0de41aa <__udivmoddi4+0x3e>
c0de417a:	b35b      	cbz	r3, c0de41d4 <__udivmoddi4+0x68>
c0de417c:	fab1 f581 	clz	r5, r1
c0de4180:	fab3 f683 	clz	r6, r3
c0de4184:	1b75      	subs	r5, r6, r5
c0de4186:	2d20      	cmp	r5, #32
c0de4188:	d34a      	bcc.n	c0de4220 <__udivmoddi4+0xb4>
c0de418a:	f1bc 0f00 	cmp.w	ip, #0
c0de418e:	bf18      	it	ne
c0de4190:	e9cc 4100 	strdne	r4, r1, [ip]
c0de4194:	2400      	movs	r4, #0
c0de4196:	e066      	b.n	c0de4266 <__udivmoddi4+0xfa>
c0de4198:	b3cb      	cbz	r3, c0de420e <__udivmoddi4+0xa2>
c0de419a:	2100      	movs	r1, #0
c0de419c:	f1bc 0f00 	cmp.w	ip, #0
c0de41a0:	bf18      	it	ne
c0de41a2:	e9cc 4100 	strdne	r4, r1, [ip]
c0de41a6:	2400      	movs	r4, #0
c0de41a8:	e0a6      	b.n	c0de42f8 <__udivmoddi4+0x18c>
c0de41aa:	2b00      	cmp	r3, #0
c0de41ac:	d03e      	beq.n	c0de422c <__udivmoddi4+0xc0>
c0de41ae:	2800      	cmp	r0, #0
c0de41b0:	d04f      	beq.n	c0de4252 <__udivmoddi4+0xe6>
c0de41b2:	1e5d      	subs	r5, r3, #1
c0de41b4:	422b      	tst	r3, r5
c0de41b6:	d158      	bne.n	c0de426a <__udivmoddi4+0xfe>
c0de41b8:	f1bc 0f00 	cmp.w	ip, #0
c0de41bc:	bf1c      	itt	ne
c0de41be:	ea05 0001 	andne.w	r0, r5, r1
c0de41c2:	e9cc 4000 	strdne	r4, r0, [ip]
c0de41c6:	fa93 f0a3 	rbit	r0, r3
c0de41ca:	fab0 f080 	clz	r0, r0
c0de41ce:	fa21 f400 	lsr.w	r4, r1, r0
c0de41d2:	e048      	b.n	c0de4266 <__udivmoddi4+0xfa>
c0de41d4:	1e55      	subs	r5, r2, #1
c0de41d6:	422a      	tst	r2, r5
c0de41d8:	d129      	bne.n	c0de422e <__udivmoddi4+0xc2>
c0de41da:	f1bc 0f00 	cmp.w	ip, #0
c0de41de:	bf1e      	ittt	ne
c0de41e0:	2300      	movne	r3, #0
c0de41e2:	4005      	andne	r5, r0
c0de41e4:	e9cc 5300 	strdne	r5, r3, [ip]
c0de41e8:	2a01      	cmp	r2, #1
c0de41ea:	f000 8085 	beq.w	c0de42f8 <__udivmoddi4+0x18c>
c0de41ee:	fa92 f2a2 	rbit	r2, r2
c0de41f2:	004c      	lsls	r4, r1, #1
c0de41f4:	fab2 f282 	clz	r2, r2
c0de41f8:	f002 031f 	and.w	r3, r2, #31
c0de41fc:	40d1      	lsrs	r1, r2
c0de41fe:	40d8      	lsrs	r0, r3
c0de4200:	231f      	movs	r3, #31
c0de4202:	4393      	bics	r3, r2
c0de4204:	fa04 f303 	lsl.w	r3, r4, r3
c0de4208:	ea43 0400 	orr.w	r4, r3, r0
c0de420c:	e074      	b.n	c0de42f8 <__udivmoddi4+0x18c>
c0de420e:	fbb0 f4f2 	udiv	r4, r0, r2
c0de4212:	f1bc 0f00 	cmp.w	ip, #0
c0de4216:	d026      	beq.n	c0de4266 <__udivmoddi4+0xfa>
c0de4218:	fb04 0012 	mls	r0, r4, r2, r0
c0de421c:	2100      	movs	r1, #0
c0de421e:	e020      	b.n	c0de4262 <__udivmoddi4+0xf6>
c0de4220:	f105 0e01 	add.w	lr, r5, #1
c0de4224:	f1be 0f20 	cmp.w	lr, #32
c0de4228:	d00b      	beq.n	c0de4242 <__udivmoddi4+0xd6>
c0de422a:	e028      	b.n	c0de427e <__udivmoddi4+0x112>
c0de422c:	e064      	b.n	c0de42f8 <__udivmoddi4+0x18c>
c0de422e:	fab1 f481 	clz	r4, r1
c0de4232:	fab2 f582 	clz	r5, r2
c0de4236:	1b2c      	subs	r4, r5, r4
c0de4238:	f104 0e21 	add.w	lr, r4, #33	@ 0x21
c0de423c:	f1be 0f20 	cmp.w	lr, #32
c0de4240:	d15d      	bne.n	c0de42fe <__udivmoddi4+0x192>
c0de4242:	f04f 0e20 	mov.w	lr, #32
c0de4246:	f04f 0a00 	mov.w	sl, #0
c0de424a:	f04f 0b00 	mov.w	fp, #0
c0de424e:	460e      	mov	r6, r1
c0de4250:	e021      	b.n	c0de4296 <__udivmoddi4+0x12a>
c0de4252:	fbb1 f4f3 	udiv	r4, r1, r3
c0de4256:	f1bc 0f00 	cmp.w	ip, #0
c0de425a:	d004      	beq.n	c0de4266 <__udivmoddi4+0xfa>
c0de425c:	2000      	movs	r0, #0
c0de425e:	fb04 1113 	mls	r1, r4, r3, r1
c0de4262:	e9cc 0100 	strd	r0, r1, [ip]
c0de4266:	2100      	movs	r1, #0
c0de4268:	e046      	b.n	c0de42f8 <__udivmoddi4+0x18c>
c0de426a:	fab1 f581 	clz	r5, r1
c0de426e:	fab3 f683 	clz	r6, r3
c0de4272:	1b75      	subs	r5, r6, r5
c0de4274:	2d1f      	cmp	r5, #31
c0de4276:	f4bf af88 	bcs.w	c0de418a <__udivmoddi4+0x1e>
c0de427a:	f105 0e01 	add.w	lr, r5, #1
c0de427e:	fa20 f40e 	lsr.w	r4, r0, lr
c0de4282:	f1c5 051f 	rsb	r5, r5, #31
c0de4286:	fa01 f605 	lsl.w	r6, r1, r5
c0de428a:	fa21 fb0e 	lsr.w	fp, r1, lr
c0de428e:	40a8      	lsls	r0, r5
c0de4290:	f04f 0a00 	mov.w	sl, #0
c0de4294:	4326      	orrs	r6, r4
c0de4296:	f04f 0800 	mov.w	r8, #0
c0de429a:	f1be 0f00 	cmp.w	lr, #0
c0de429e:	d01c      	beq.n	c0de42da <__udivmoddi4+0x16e>
c0de42a0:	ea4f 014b 	mov.w	r1, fp, lsl #1
c0de42a4:	f1ae 0e01 	sub.w	lr, lr, #1
c0de42a8:	ea41 71d6 	orr.w	r1, r1, r6, lsr #31
c0de42ac:	0076      	lsls	r6, r6, #1
c0de42ae:	ea46 75d0 	orr.w	r5, r6, r0, lsr #31
c0de42b2:	1aae      	subs	r6, r5, r2
c0de42b4:	eb61 0b03 	sbc.w	fp, r1, r3
c0de42b8:	43cf      	mvns	r7, r1
c0de42ba:	43ec      	mvns	r4, r5
c0de42bc:	18a4      	adds	r4, r4, r2
c0de42be:	eb57 0403 	adcs.w	r4, r7, r3
c0de42c2:	bf5c      	itt	pl
c0de42c4:	468b      	movpl	fp, r1
c0de42c6:	462e      	movpl	r6, r5
c0de42c8:	0040      	lsls	r0, r0, #1
c0de42ca:	0fe1      	lsrs	r1, r4, #31
c0de42cc:	ea48 044a 	orr.w	r4, r8, sl, lsl #1
c0de42d0:	ea40 70da 	orr.w	r0, r0, sl, lsr #31
c0de42d4:	46a2      	mov	sl, r4
c0de42d6:	4688      	mov	r8, r1
c0de42d8:	e7df      	b.n	c0de429a <__udivmoddi4+0x12e>
c0de42da:	ea4f 71da 	mov.w	r1, sl, lsr #31
c0de42de:	f1bc 0f00 	cmp.w	ip, #0
c0de42e2:	bf18      	it	ne
c0de42e4:	e9cc 6b00 	strdne	r6, fp, [ip]
c0de42e8:	ea41 0140 	orr.w	r1, r1, r0, lsl #1
c0de42ec:	ea4f 004a 	mov.w	r0, sl, lsl #1
c0de42f0:	f020 0001 	bic.w	r0, r0, #1
c0de42f4:	ea40 0408 	orr.w	r4, r0, r8
c0de42f8:	4620      	mov	r0, r4
c0de42fa:	e8bd 8df0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, sl, fp, pc}
c0de42fe:	f1be 0f1f 	cmp.w	lr, #31
c0de4302:	d804      	bhi.n	c0de430e <__udivmoddi4+0x1a2>
c0de4304:	fa20 f40e 	lsr.w	r4, r0, lr
c0de4308:	f1ce 0520 	rsb	r5, lr, #32
c0de430c:	e7bb      	b.n	c0de4286 <__udivmoddi4+0x11a>
c0de430e:	f1ce 0740 	rsb	r7, lr, #64	@ 0x40
c0de4312:	f1ae 0420 	sub.w	r4, lr, #32
c0de4316:	f04f 0b00 	mov.w	fp, #0
c0de431a:	fa20 f504 	lsr.w	r5, r0, r4
c0de431e:	fa01 f607 	lsl.w	r6, r1, r7
c0de4322:	fa00 fa07 	lsl.w	sl, r0, r7
c0de4326:	ea46 0805 	orr.w	r8, r6, r5
c0de432a:	fa21 f604 	lsr.w	r6, r1, r4
c0de432e:	4640      	mov	r0, r8
c0de4330:	e7b1      	b.n	c0de4296 <__udivmoddi4+0x12a>
	...

c0de4334 <__aeabi_memcpy>:
c0de4334:	f000 b81c 	b.w	c0de4370 <memcpy>

c0de4338 <__aeabi_memmove>:
c0de4338:	f000 b828 	b.w	c0de438c <memmove>

c0de433c <__aeabi_memset>:
c0de433c:	460b      	mov	r3, r1
c0de433e:	4611      	mov	r1, r2
c0de4340:	461a      	mov	r2, r3
c0de4342:	f000 b83d 	b.w	c0de43c0 <memset>
c0de4346:	bf00      	nop

c0de4348 <__aeabi_memclr>:
c0de4348:	460a      	mov	r2, r1
c0de434a:	2100      	movs	r1, #0
c0de434c:	f000 b838 	b.w	c0de43c0 <memset>

c0de4350 <__aeabi_uldivmod>:
c0de4350:	b540      	push	{r6, lr}
c0de4352:	b084      	sub	sp, #16
c0de4354:	ae02      	add	r6, sp, #8
c0de4356:	9600      	str	r6, [sp, #0]
c0de4358:	f7ff ff08 	bl	c0de416c <__udivmoddi4>
c0de435c:	9a02      	ldr	r2, [sp, #8]
c0de435e:	9b03      	ldr	r3, [sp, #12]
c0de4360:	b004      	add	sp, #16
c0de4362:	bd40      	pop	{r6, pc}

c0de4364 <explicit_bzero>:
c0de4364:	f000 b800 	b.w	c0de4368 <bzero>

c0de4368 <bzero>:
c0de4368:	460a      	mov	r2, r1
c0de436a:	2100      	movs	r1, #0
c0de436c:	f000 b828 	b.w	c0de43c0 <memset>

c0de4370 <memcpy>:
c0de4370:	440a      	add	r2, r1
c0de4372:	4291      	cmp	r1, r2
c0de4374:	f100 33ff 	add.w	r3, r0, #4294967295	@ 0xffffffff
c0de4378:	d100      	bne.n	c0de437c <memcpy+0xc>
c0de437a:	4770      	bx	lr
c0de437c:	b510      	push	{r4, lr}
c0de437e:	f811 4b01 	ldrb.w	r4, [r1], #1
c0de4382:	4291      	cmp	r1, r2
c0de4384:	f803 4f01 	strb.w	r4, [r3, #1]!
c0de4388:	d1f9      	bne.n	c0de437e <memcpy+0xe>
c0de438a:	bd10      	pop	{r4, pc}

c0de438c <memmove>:
c0de438c:	4288      	cmp	r0, r1
c0de438e:	b510      	push	{r4, lr}
c0de4390:	eb01 0402 	add.w	r4, r1, r2
c0de4394:	d902      	bls.n	c0de439c <memmove+0x10>
c0de4396:	4284      	cmp	r4, r0
c0de4398:	4623      	mov	r3, r4
c0de439a:	d807      	bhi.n	c0de43ac <memmove+0x20>
c0de439c:	1e43      	subs	r3, r0, #1
c0de439e:	42a1      	cmp	r1, r4
c0de43a0:	d008      	beq.n	c0de43b4 <memmove+0x28>
c0de43a2:	f811 2b01 	ldrb.w	r2, [r1], #1
c0de43a6:	f803 2f01 	strb.w	r2, [r3, #1]!
c0de43aa:	e7f8      	b.n	c0de439e <memmove+0x12>
c0de43ac:	4601      	mov	r1, r0
c0de43ae:	4402      	add	r2, r0
c0de43b0:	428a      	cmp	r2, r1
c0de43b2:	d100      	bne.n	c0de43b6 <memmove+0x2a>
c0de43b4:	bd10      	pop	{r4, pc}
c0de43b6:	f813 4d01 	ldrb.w	r4, [r3, #-1]!
c0de43ba:	f802 4d01 	strb.w	r4, [r2, #-1]!
c0de43be:	e7f7      	b.n	c0de43b0 <memmove+0x24>

c0de43c0 <memset>:
c0de43c0:	4603      	mov	r3, r0
c0de43c2:	4402      	add	r2, r0
c0de43c4:	4293      	cmp	r3, r2
c0de43c6:	d100      	bne.n	c0de43ca <memset+0xa>
c0de43c8:	4770      	bx	lr
c0de43ca:	f803 1b01 	strb.w	r1, [r3], #1
c0de43ce:	e7f9      	b.n	c0de43c4 <memset+0x4>

c0de43d0 <setjmp>:
c0de43d0:	46ec      	mov	ip, sp
c0de43d2:	e8a0 5ff0 	stmia.w	r0!, {r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
c0de43d6:	f04f 0000 	mov.w	r0, #0
c0de43da:	4770      	bx	lr

c0de43dc <longjmp>:
c0de43dc:	e8b0 5ff0 	ldmia.w	r0!, {r4, r5, r6, r7, r8, r9, sl, fp, ip, lr}
c0de43e0:	46e5      	mov	sp, ip
c0de43e2:	0008      	movs	r0, r1
c0de43e4:	bf08      	it	eq
c0de43e6:	2001      	moveq	r0, #1
c0de43e8:	4770      	bx	lr
c0de43ea:	bf00      	nop

c0de43ec <strlen>:
c0de43ec:	4603      	mov	r3, r0
c0de43ee:	f813 2b01 	ldrb.w	r2, [r3], #1
c0de43f2:	2a00      	cmp	r2, #0
c0de43f4:	d1fb      	bne.n	c0de43ee <strlen+0x2>
c0de43f6:	1a18      	subs	r0, r3, r0
c0de43f8:	3801      	subs	r0, #1
c0de43fa:	4770      	bx	lr

c0de43fc <strncat>:
c0de43fc:	b530      	push	{r4, r5, lr}
c0de43fe:	4604      	mov	r4, r0
c0de4400:	7825      	ldrb	r5, [r4, #0]
c0de4402:	4623      	mov	r3, r4
c0de4404:	3401      	adds	r4, #1
c0de4406:	2d00      	cmp	r5, #0
c0de4408:	d1fa      	bne.n	c0de4400 <strncat+0x4>
c0de440a:	1e54      	subs	r4, r2, #1
c0de440c:	b912      	cbnz	r2, c0de4414 <strncat+0x18>
c0de440e:	bd30      	pop	{r4, r5, pc}
c0de4410:	b13c      	cbz	r4, c0de4422 <strncat+0x26>
c0de4412:	3c01      	subs	r4, #1
c0de4414:	f811 2b01 	ldrb.w	r2, [r1], #1
c0de4418:	f803 2b01 	strb.w	r2, [r3], #1
c0de441c:	2a00      	cmp	r2, #0
c0de441e:	d1f7      	bne.n	c0de4410 <strncat+0x14>
c0de4420:	e7f5      	b.n	c0de440e <strncat+0x12>
c0de4422:	701c      	strb	r4, [r3, #0]
c0de4424:	e7f3      	b.n	c0de440e <strncat+0x12>

c0de4426 <C_Information_circle_14px_bitmap>:
c0de4426:	8007 837f 1fff 7ffe fffb 81fc 07f2 fdfb     ................
c0de4436:	e7ff 8fff 1ffc 1ee0                          .........

c0de443f <C_Information_circle_14px>:
c0de443f:	000e 000e 0000 4426 c0de                    ......&D..

c0de4449 <C_Quit_14px_bitmap>:
c0de4449:	0003 001e 00fc 03c0 cc01 33e7 c698 1963     ...........3..c.
c0de4459:	6680 9801 7f06 fff9                          .f.......

c0de4462 <C_Quit_14px>:
c0de4462:	000e 000e 0000 4449 c0de                    ......ID..

c0de446c <C_Switch_Off_8px_bitmap>:
c0de446c:	423c 8181 8181 bd99 99bd 3c42               <B........B<

c0de4478 <C_Switch_Off_8px>:
c0de4478:	000c 0008 0000 446c c0de                    ......lD..

c0de4482 <C_Switch_On_8px_bitmap>:
c0de4482:	7e3c c3e7 e7c3 ffff ffff 3c7e               <~........~<

c0de448e <C_Switch_On_8px>:
c0de448e:	000c 0008 0000 4482 c0de                    .......D..

c0de4498 <C_icon_back_x_bitmap>:
c0de4498:	0000 0000 0030 03c0 0c00 3303 dc0e e01f     ....0......3....
c0de44a8:	003f 0078 00c0 0000                          ?.x......

c0de44b1 <C_icon_back_x>:
c0de44b1:	000e 000e 0000 4498 c0de                    .......D..

c0de44bb <C_icon_coggle_bitmap>:
c0de44bb:	0000 0000 0230 1fd0 3fe0 cf03 3c0f c00f     ....0....?...<..
c0de44cb:	807f 00b4 00c0 0000                          .........

c0de44d4 <C_icon_coggle>:
c0de44d4:	000e 000e 0000 44bb c0de                    .......D..

c0de44de <C_icon_crossmark_bitmap>:
c0de44de:	0100 6780 8e03 1c1c 3fe0 7800 e001 c00f     ...g.....?.x....
c0de44ee:	8373 1c87 600e 0018                          s....`...

c0de44f7 <C_icon_crossmark>:
c0de44f7:	000e 000e 0000 44de c0de                    .......D..

c0de4501 <C_icon_down_bitmap>:
c0de4501:	2184 8024                                   .!$.

c0de4505 <C_icon_down>:
c0de4505:	0007 0004 0000 4501 c0de                    .......E..

c0de450f <C_icon_left_bitmap>:
c0de450f:	8882 80a0                                   ....

c0de4513 <C_icon_left>:
c0de4513:	0004 0007 0000 450f c0de                    .......E..

c0de451d <C_icon_right_bitmap>:
c0de451d:	5110 1014                                   .Q..

c0de4521 <C_icon_right>:
c0de4521:	0004 0007 0000 451d c0de                    .......E..

c0de452b <C_icon_up_bitmap>:
c0de452b:	4812 1042                                   .HB.

c0de452f <C_icon_up>:
c0de452f:	0007 0004 0000 452b c0de                    ......+E..

c0de4539 <C_icon_validate_14_bitmap>:
c0de4539:	000e 000e 0f02 0000 c332 c3c3 c3c3 c3c3     ........2.......
c0de4549:	a3b3 a3a3 f0b2                               ......P

c0de4550 <C_icon_validate_14>:
c0de4550:	000e 000e 0100 4539 c0de                    ......9E..

c0de455a <C_icon_warning_bitmap>:
c0de455a:	0000 6000 8007 077e 7ff8 04e7 129c f81f     ...`..~.........
c0de456a:	e01f 801f 001e 0018                          .........

c0de4573 <C_icon_warning>:
c0de4573:	000e 000e 0000 455a c0de                    ......ZE..

c0de457d <C_home_boilerplate_14px_bitmap>:
c0de457d:	e11b e7ef 3e9e f821 800f 0378 0fe0 1fe0     .....>!...x.....
c0de458d:	3fe0 5e88 7b78 6ff8                          .?.^x{.o.

c0de4596 <C_home_boilerplate_14px>:
c0de4596:	000e 000e 0000 457d c0de 3e3d 6120 6470     ......}E..=> apd
c0de45a6:	5f75 6964 7073 7461 6863 7265 6620 6961     u_dispatcher fai
c0de45b6:	756c 6572 000a 7325 2820 6425 252f 2964     lure..%s (%d/%d)
c0de45c6:	3d00 203e 6f69 725f 6365 5f76 6f63 6d6d     .=> io_recv_comm
c0de45d6:	6e61 2064 6166 6c69 7275 0a65 4100 7070     and failure..App
c0de45e6:	6520 7272 726f 4500 6978 2074 7061 0070      error.Exit app.
c0de45f6:	0020 6e45 6261 656c 0064 3d3c 5320 3d57      .Enabled.<= SW=
c0de4606:	3025 5834 7c20 5220 6144 6174 253d 2a2e     %04X | RData=%.*
c0de4616:	0a48 3c00 203d 5246 4741 2820 7525 252f     H..<= FRAG (%u/%
c0de4626:	2975 5220 6144 6174 253d 2a2e 0a48 3d00     u) RData=%.*H..=
c0de4636:	203e 4350 203a 7830 3025 5838 0a20 3d00     > PC: 0x%08X ..=
c0de4646:	203e 4c43 3d41 3025 5832 7c20 4920 534e     > CLA=%02X | INS
c0de4656:	253d 3230 2058 207c 3150 253d 3230 2058     =%02X | P1=%02X 
c0de4666:	207c 3250 253d 3230 2058 207c 634c 253d     | P2=%02X | Lc=%
c0de4676:	3230 2058 207c 4443 7461 3d61 2e25 482a     02X | CData=%.*H
c0de4686:	000a 454c 4744 5245 415f 5353 5245 2054     ..LEDGER_ASSERT 
c0de4696:	4146 4c49 4445 000a 7325 3a3a 6425 000a     FAILED..%s::%d..
c0de46a6:	3e3d 2f20 5c21 4220 4441 4c20 4e45 5447     => /!\ BAD LENGT
c0de46b6:	3a48 2520 2a2e 0a48 4400 7369 6261 656c     H: %.*H..Disable
c0de46c6:	0064 7041 2070 6573 7474 6e69 7367 6500     d.App settings.e
c0de46d6:	303d 2578 3430 0a58 4c20 3d52 7830 3025     =0x%04X. LR=0x%0
c0de46e6:	5838 000a 7473 6e61 6164 6f6c 656e 615f     8X..standalone_a
c0de46f6:	7070 6d5f 6961 0a6e 6500 6378 7065 6974     pp_main..excepti
c0de4706:	6e6f 305b 2578 3430 5d58 203a 524c 303d     on[0x%04X]: LR=0
c0de4716:	2578 3830 0a58 0a00 4200 6361 006b 3d3c     x%08X....Back.<=
c0de4726:	5320 3d57 3025 5834 7c20 5220 6144 6174      SW=%04X | RData
c0de4736:	0a3d 4c00 3d52 7830 3025 5838 200a 4350     =..LR=0x%08X. PC
c0de4746:	303d 2578 3830 0a58 4100 7070 6920 666e     =0x%08X..App inf
c0de4756:	006f 7325 3a3a 6425 0a20 6100 7070 6920     o.%s::%d ..app i
c0de4766:	2073 6572 6461 0079 7551 7469 6120 7070     s ready.Quit app
c0de4776:	3d00 203e 524c 203a 7830 3025 5838 0a20     .=> LR: 0x%08X .
c0de4786:	2f00 7061 2f70 7273 2f63 7061 7564 642f     ./app/src/apdu/d
c0de4796:	7369 6170 6374 6568 2e72 0063 6f42 6c69     ispatcher.c.Boil
c0de47a6:	7265 6c70 7461 0065 0025 554e 4c4c 6320     erplate.%.NULL c
c0de47b6:	646d 0000 0000                              md....

c0de47bc <settingContents>:
	...

c0de47c8 <infoList>:
	...

c0de47d8 <g_pcHex>:
c0de47d8:	3130 3332 3534 3736 3938 6261 6463 6665     0123456789abcdef

c0de47e8 <g_pcHex_cap>:
c0de47e8:	3130 3332 3534 3736 3938 4241 4443 4645     0123456789ABCDEF

c0de47f8 <_etext>:
	...

c0de4800 <install_parameters>:
c0de4800:	0b01 6f42 6c69 7265 6c70 7461 0265 3205     ..Boilerplate..2
c0de4810:	332e 312e 2103 000e 000e 1900 0000 0004     .3.1.!..........
c0de4820:	0010 8161 07de 7ff0 fc87 f01f e01f c01f     ..a.............
c0de4830:	8177 0486 1000 0400 010a 8002 0000 802c     w.............,.
c0de4840:	0000                                         ...
