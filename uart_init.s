#include "uart_regs.h"

.macro uart_init

# 1.Reset controller
	ldr		r0, =slcr_UART_RST_CTRL
	ldr		r1, [r0, #0]			@ read slcr.UART_RST_CTRL
	orr		r1, r1, #0x0000000A		@ set both slcr.UART_RST_CTRL[UART1_REF_RST, UART1_CPU1X_RST] (bit[3][1])
	str		r1, [r0, #0]			@ update

# 2.Configure I/O signal routing

# 3.Configure UART_Ref_Clk
	ldr		r0, =slcr_UART_CLK_CTRL
	ldr		r1, =0x00001402			@ write 0x00001402 to slcr.UART_CLK_CTRL @ mov	r1, #0x00001402	(*** ERROR ***)
	str		r1, [r0, #0]			@ update

# 4.Configure controller functions
	ldr		r0, =UART1_BASE

# 	4-1. Configure UART character frame
	mov		r1, #0x00000020
	str		r1, [r0, #UART_MODE_REG0_OFFSET]

# 	4-2. Configure the Baud Rate
	# a-b. Disable Rx Path and Tx Path
	ldr		r1, [r0, #UART_CONTROL_REG0_OFFSET]	@ read uart.Control_reg0
	bic		r1, r1, #0x0000003C					@ clear TXDIS, TXEN, RXDIS, RXEN (bit[5][4][3][2])
	orr		r1, r1, #0x00000028					@ TXDIS = 1 TXEN = 0 RXDIS = 1 RXEN = 0 (bit[5][4][3][2])
	str		r1, [r0, #UART_CONTROL_REG0_OFFSET]	@ update
	# c-d. Write the calculated CD value and BDIV
	mov		r1, #0x0000003E								@ CD = 62 (Baud rate 115200)
	str		r1, [r0, #UART_BAUD_RATE_GEN_REG0_OFFSET]	@ update uart.Baud_rate_gen_reg0
	mov		r1, #0x00000006								@ BDIV = 6 (Baud rate 115200)
	str		r1, [r0, #UART_BAUD_RATE_DIV_REG0_OFFSET]	@ update uart.Baud_rate_divider_reg0 @ strb	r1, [r0, #UART_BAUD_RATE_DIV_REG0_OFFSET]
	# e. Reset Tx and Px Path
	ldr		r1, [r0, #UART_CONTROL_REG0_OFFSET]	@ read uart.Control_reg0
	orr		r1, r1, #0x00000003					@ set TXRST, RXRST (bit[1][0]:self-clearing) - this resets Tx and Rx paths
	str		r1, [r0, #UART_CONTROL_REG0_OFFSET]	@ update
	# f-g. Enable Rx Path and Tx Path
	ldr		r1, [r0, #UART_CONTROL_REG0_OFFSET]	@ read uart.Control_reg0
	bic		r1, r1, #0x0000003C					@ clear TXDIS, TXEN, RXDIS, RXEN (bit[5][4][3][2])
	orr		r1, r1, #0x00000014					@ TXDIS = 0 TXEN = 1 RXDIS = 0 RXEN = 1 (bit[5][4][3][2])
	str		r1, [r0, #UART_CONTROL_REG0_OFFSET]	@ update

# 	4-5. Enable the Controller
	ldr		r1, =0x00000117						@ write 0x00000117 to uart.Control_reg0
	str		r1, [r0, #UART_CONTROL_REG0_OFFSET]	@ update


.endm
