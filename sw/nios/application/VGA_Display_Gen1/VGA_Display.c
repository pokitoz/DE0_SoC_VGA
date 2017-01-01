/*
 * VGA_Display.c
 *
 *  Created on: Dec 16, 2016
 *      Author: pokitoz
 */

#include "VGA_Display.h"
#include "io.h"
#include "alt_types.h"
#include "system.h"
#include "sys/alt_irq.h"

void VGA_Display_changeVerticalPorch(alt_u32 BASE, alt_u16 front_porch, alt_u16 back_porch) {
	alt_u32 concatenated = front_porch | (back_porch << 16);
	IOWR_32DIRECT(BASE, VGA_DISPLAY_PORCH_V_REG, concatenated);

}

void VGA_Display_changeHorizontalPorch(alt_u32 BASE, alt_u16 front_porch, alt_u16 back_porch) {
	alt_u32 concatenated = front_porch | (back_porch << 16);
	IOWR_32DIRECT(BASE, VGA_DISPLAY_PORCH_H_REG, concatenated);
}

void VGA_Display_changeScreenColor(alt_u32 BASE, alt_u32 color) {
	IOWR_32DIRECT(BASE, VGA_DISPLAY_COLOR_REG, color);
}

void VGA_Display_set_irq(void (*irq_handler)(void*, alt_u32)) {

	if (irq_handler != NULL) {
		// Register the ISR for sync
		alt_ic_isr_register(VGA_MODULE_0_IRQ_INTERRUPT_CONTROLLER_ID,
				VGA_MODULE_0_IRQ, (void*) &irq_handler, 0, 0);

		// Enable the interrupts
		alt_ic_irq_enable(VGA_MODULE_0_IRQ_INTERRUPT_CONTROLLER_ID,
				VGA_MODULE_0_IRQ);
	}

}
