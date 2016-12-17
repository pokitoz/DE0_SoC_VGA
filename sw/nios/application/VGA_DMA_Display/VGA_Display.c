/*
 * VGA_Display.c
 *
 *  Created on: Dec 16, 2016
 *      Author: pokitoz
 */

#include "VGA_Display.h"
#include "io.h"
#include "stdint-gcc.h"
#include "system.h"
#include "sys/alt_irq.h"

void VGA_Display_changeScreenColor(uint32_t BASE, uint32_t color) {

	IOWR_32DIRECT(BASE, VGA_DISPLAY_COLOR_REG, color);
}

void VGA_Display_set_irq(void (*irq_handler_vsync)(void*),
		void (*irq_handler_hsync)(void*)) {

	if (irq_handler_vsync != NULL) {
		// Register the ISR for vsync
		alt_ic_isr_register(VGA_MODULE_0_IRQ_INTERRUPT_CONTROLLER_ID,
				VGA_MODULE_0_IRQ, irq_handler_vsync, 0, 0);

		// Enable the interrupts
		alt_ic_irq_enable(VGA_MODULE_0_IRQ_INTERRUPT_CONTROLLER_ID,
				VGA_MODULE_0_IRQ);
	}

	if (irq_handler_hsync != NULL) {
		// Register the ISR for hsync
		alt_ic_isr_register(VGA_MODULE_0_IRQ_INTERRUPT_CONTROLLER_ID,
				VGA_MODULE_0_IRQ + 1, irq_handler_hsync, 0, 0);

		alt_ic_irq_enable(VGA_MODULE_0_IRQ_INTERRUPT_CONTROLLER_ID,
					VGA_MODULE_0_IRQ + 1);
	}



}
