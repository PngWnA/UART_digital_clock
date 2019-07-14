/*
 * csd_zynq_peripherals.h
 *
 *  Created on: 2014. 8. 23.
 *      Author: Soojung
 */

#ifndef CSD_ZYNQ_PERIPHERALS_H_
#define CSD_ZYNQ_PERIPHERALS_H_

#define csd_LED_ADDR	   0x41200000

#define	SLCR			   0xF8000000
#define	SLCR_LOCK		SLCR + 0x4
#define	SLCR_UNLOCK		SLCR + 0x8
#define	SLCR_LOCKSTA	SLCR + 0xC
#define	TZ_DDR_RAM		SLCR + 0x430


#define GICD_BASE	      0xF8F01000         // Distributor Base Address
#define GICD_CTLR	      GICD_BASE + 0x0    // Distributor Control Register
#define GICD_TYPER	 	GICD_BASE + 0x4    // Interrupt Controller Type Register
#define GICD_IGROUP0	   GICD_BASE + 0x80   // Interrupt Group Register
#define GICD_ISENABLER0	GICD_BASE + 0x100  // Interrupt Set-Enable Register 0
#define GICD_ISPENDR0	GICD_BASE + 0x200  // Interrupt Set-Pending Register 0
#define GICD_ICACTIVE0	GICD_BASE + 0x380  // Interrupt Clear-Active 0
#define GICD_ICACTIVE1	GICD_BASE + 0x384  // Interrupt Clear-Active 1
#define GICD_ICACTIVE2	GICD_BASE + 0x388  // Interrupt Clear-Active 2
#define GICD_ICACTIVE3	GICD_BASE + 0x38c  // Interrupt Clear-Active 3
#define GICD_ICACTIVE4	GICD_BASE + 0x390  // Interrupt Clear-Active 4
#define GICD_ICACTIVE5	GICD_BASE + 0x394  // Interrupt Clear-Active 5
#define GICD_ICACTIVE6	GICD_BASE + 0x398  // Interrupt Clear-Active 6
#define GICD_ICACTIVE7	GICD_BASE + 0x39c  // Interrupt Clear-Active 7
#define GICD_PRIOR0		GICD_BASE + 0x400  // Interrupt Priority Register 0
#define GICD_PRIOR7		GICD_PRIOR0 + 4*7  // Interrupt Priority Register 7
#define GICD_SGIR	  	   GICD_BASE + 0xF00  // Software Generated Interrupt Register
#define GICD_SPENDSGIR0	GICD_BASE + 0xF20  // SGI Set-Pending Register 0
#define GICD_ICPIDR1	   GICD_BASE + 0xFE4  // Peripheral ID1 (ICPIDR1)
#define GICD_ICPIDR2	   GICD_BASE + 0xFE8  // Peripheral ID2 (ICPIDR2)

#define GICC_CTLR   	 0xF8F00100        // CPU Interface Control Register
#define GICC_PMR	    GICC_CTLR + 0x4   // CPU Interface Priority Mask Register
#define GICC_BPR	    GICC_CTLR + 0x8   // CPU Binary Pointer Register
#define GICC_IAR	    GICC_CTLR + 0xC   // CPU Interface Ack Register
#define GICC_EOIR	    GICC_CTLR + 0x10  // CPU Interface End of Interrupt Register
#define GICC_IIDR	    GICC_CTLR + 0xFC  // CPU Interface Identification Register


#define PRIVATE_TIMER  	 0xF8F00600            // Private Timer Base Address
#define PRIVATE_LOAD     PRIVATE_TIMER + 0x0   // Private Timer Load Register
#define PRIVATE_COUNTER	 PRIVATE_TIMER + 0x4   // Private Timer Counter Register
#define PRIVATE_CONTROL	 PRIVATE_TIMER + 0x8   // Private Timer Control Register
#define PRIVATE_STATUS	 PRIVATE_TIMER + 0xC   // Private Timer Interrupt Status Register

#endif /* CSD_ZYNQ_PERIPHERALS_H_ */
