#include "csd_zynq_peripherals.h"
#include "uart_init.s"
#include "uart_print.s"

// Variable for timer

#define TIMER_INITIAL	0x2000000
#define PRESCALAR 0x9

// C functions

.extern csd_main
.extern hextoascii

.align 8

csd_entry:
	b csd_reset
	b csd_undefined
	b csd_software_interrupt
	b csd_prefetch
	b csd_data
	b csd_not_used
	b csd_irq
	b csd_fiq

.global main
main:

	uart_init // Init UART

	// Disable interrupt: Turn on I bit in CPSR
    cpsID i

	cps #0x12	   	       /* IRQ mode */
	ldr	r13,=irq_stack_top /* stack pointer setup for IRQ mode */

	cps #0x13		       /* supervisor mode */
	ldr	r13,=svc_stack_top /* stack pointer setup for SVC mode */

    cps #0x11		       /* FIQ mode */
	ldr	r13,=fiq_stack_top /* stack pointer setup for FIQ mode */

	cps #0x1F	           /* SYS mode */

	// Set VBAR (Vector Base Address Register) to the base of my interrupt vector table
    ldr     r0, =csd_entry
    mcr     p15, 0, r0, c12, c0, 0
    dsb
    isb

	// Enable interrupt: Turn off I bit in CPSR
    cpsIE i

// ---------------------------
// Generic Interrupt Controller (GIC) setup - Begin
//

	// CPU Interface ID Register
	ldr r0, =GICC_IIDR
	ldr r3, [r0]

	// CPU Controller Type Register
	ldr r0, =GICD_TYPER
	ldr r3, [r0]

	// CPU Binary Pointer Register
	ldr r0, =GICC_BPR
	ldr r3, [r0]

	// Distributor Control Register
	ldr r0, =GICD_CTLR
	ldr r1, [r0]
	mov r2, #1       // Enable
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	 // Interrupt Set-Enable Register 0
	ldr r0, =GICD_ISENABLER0
	ldr r1, [r0]
	mov r2, #1 << 29   // Enable #29 (Private Timer)
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	// Interrupt Priority Register #7
	ldr r0, =GICD_PRIOR7
	ldr r1, [r0]
	mov r2, #1 << 8    // 2nd Highest: 1 for ID# 29 (Private Timer)
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

	// CPU Interface Control Register
	ldr r0, =GICC_CTLR
	ldr r1, [r0]
	mov r2, #1        // Enable
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

 	// CPU Interface Interrupt Priority Mask Register
	ldr r0, =GICC_PMR
	ldr r1, [r0]
	mov r2, #0xFF     // Lowest
	orr r1, r1, r2
	str r1, [r0]
	ldr r3, [r0]

//
// Generic Interrupt Controller (GIC) setup - End
// ---------------------------


// ---------------------------
// Private Timer setup - Begin
//

 	// Private Timer Load Register
	ldr r0, =PRIVATE_LOAD
 	ldr r1, =TIMER_INITIAL
 	str r1, [r0]

 	// Private Timer Control Register
  	ldr r0, =PRIVATE_CONTROL
  	ldr r1, =PRESCALAR << 8
 	orr r1, r1, #7     // IRQ Enable, Auto-Reload, Timer Enable
 	str r1, [r0]

//
// Private Timer setup - End
// ----------------------------

 	// Check out the counter value to make sure the counter is decrementing
  	ldr r0, =PRIVATE_COUNTER
  	ldr r1, [r0]
  	ldr r2, [r0]
    ldr r3, [r0]
  	ldr r4, [r0]
  	ldr r5, [r0]
  	ldr r6, [r0]
  	ldr r7, [r0]
  	ldr r8, [r0]

  	ldr r0, =PRIVATE_COUNTER
	ldr r1, =PRIVATE_STATUS
 	ldr r2, =GICD_ISPENDR0

forever:
   ldr r5, [r0]
   ldr r6, [r1]
   ldr r7, [r2]
   b forever


// ----------------------------
// Interrupt Service Routines (ISRs) - Begin
//

csd_software_interrupt:

/* We don't use
	ldr r0, =csd_LED_ADDR
	ldr r1, =led_initial
	str r1, [r0]
	bl csd_main
	b  csd_software_interrupt
*/


csd_reset:
csd_undefined:
csd_prefetch:
csd_data:
csd_not_used:
csd_irq:

	stmfd sp!, {r0-r12, lr}

 	// Interrupt Ack
  	ldr r0, =GICC_IAR
	ldr r3, [r0]
	//////
	// We need to change this LED logic

 	// Toggle LEDs
	ldr r0, =csd_LED_ADDR
	ldr r1, =led_initial
	ldr r2, [r1]
	eor r2, r2, #0xFF
	str r2, [r0]
	str r2, [r1]

	// into
	// this Digital Clock logic
	ldr r0, =time
	ldr r1, [r0]
	ldr r2, [r0]
	add r1, r1, #1
	str r1, [r0]
	stmfd sp!, {r0-r12}
	bl csd_main

	mov r7, r0

	print:
	// hour
	lsr r1, r7, #16
	and r1, r1, #0x000000FF
	stmfd sp!, {r0-r12}
	bl hextoascii
	uart_print
	// :
	ldr r0, =0x203a2000
	uart_print
	ldmfd sp!, {r0-r12}
	// minute
	lsr r1, r7, #8
	and r1, r1, #0x000000FF
	stmfd sp!, {r0-r12}
	bl hextoascii
	uart_print
	// :
	ldr r0, =0x203a2000
	uart_print
	ldmfd sp!, {r0-r12}
	// second
	mov r1, r7
	and r1, r1, #0x000000FF
	stmfd sp!, {r0-r12}
	bl hextoascii
	uart_print
	// CR
	ldr r0, =0x0d000000
	uart_print
	ldmfd sp!, {r0-r12}
	//////

	ldmfd sp!, {r0-r12}

 	// Clear Interrupt Status bit
  	ldr r0, =PRIVATE_STATUS
  	mov r1, #1
	str r1, [r0]

 	// End-of-Interrupt
  	ldr r0, =GICC_EOIR
	str r3, [r0]

	ldmfd sp!, {r0-r12, lr}
    subs pc, lr, #4

csd_fiq:
	b .

//
// Interrupt Service Routines (ISRs) - End
// ----------------------------

.data
.align 4

time:          .word 0x00000000

irq_stack:     .space 1024
irq_stack_top:
fiq_stack:     .space 1024
fiq_stack_top:
svc_stack:     .space 1024
svc_stack_top:

led_initial: .word 0xFF
