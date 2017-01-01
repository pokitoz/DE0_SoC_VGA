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

void VGA_Display_changeSyncVertical(alt_u32 BASE, alt_u16 visible_area, alt_u16 front_porch,
		alt_u16 sync_pulse, alt_u16 back_porch) {

	alt_u32 concatenated = front_porch | (sync_pulse << 8) | (back_porch << 16);
	IOWR_32DIRECT(BASE, VGA_DISPLAY_SYNC_V_REG, concatenated);
	IOWR_32DIRECT(BASE, VGA_DISPLAY_VISIBLE_AREA_V_REG, visible_area);

}

void VGA_Display_changeSyncHorizontal(alt_u32 BASE, alt_u16 visible_area,
		alt_u16 front_porch, alt_u16 sync_pulse, alt_u16 back_porch) {

	alt_u32 concatenated = front_porch | (sync_pulse << 8) | (back_porch << 16);
	IOWR_32DIRECT(BASE, VGA_DISPLAY_SYNC_H_REG, concatenated);
	IOWR_32DIRECT(BASE, VGA_DISPLAY_VISIBLE_AREA_H_REG, visible_area);

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
