.data

.macro uart_print

	bl uart_trans

.endm


#include "uart_regs.h"

uart_trans:

//////////////////////////////////////////////
//       아래에 오류 발생 시 clean project           //
//////////////////////////////////////////////

// r0 -> Base address
// r1 -> time
// r2 -> Channel Status
// r3 -> Word to send
// r4 -> 3
// r5 -> bitshift
// r6 -> r1
	mov     r1, r0
	ldr 	r0, =#0xE0001000


TRANSMIT_loop:

	// ---------  Check to see if the Tx FIFO is empty ------------------------------
	ldr 	r2, [r0, #0x2C]	@ get Channel Status Register
	and	r2, r2, #0x8		@ get Transmit Buffer Empty bit(bit[3:3])
	cmp	r2, #0x8				@ check if TxFIFO is empty and ready to receive new data
	bne	TRANSMIT_loop		@ if TxFIFO is NOT empty, keep checking until it is empty
	//------------------------------------------------------------------------------

	and     r3, r1, #0xFF000000
	lsr     r3, r3, #24
	lsl     r1, r1, #8
	streqb	r3, [r0, #0x30]	@ fill the TxFIFO with 0x48
	cmp      r3, #0x00
	bne		TRANSMIT_loop

	mov		pc, lr				@    return to the caller
