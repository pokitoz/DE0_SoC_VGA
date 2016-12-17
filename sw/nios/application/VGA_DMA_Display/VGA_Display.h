/*
 * VGA_Display.h
 *
 *  Created on: Dec 16, 2016
 *      Author: pokitoz
 */

#ifndef VGA_DISPLAY_H_
#define VGA_DISPLAY_H_

#include "stdint-gcc.h"

#define VGA_DISPLAY_COLOR_REG 0
void VGA_Display_changeScreenColor(uint32_t BASE, uint32_t color);
void VGA_Display_set_irq(void (*irq_handler_vsync)(void*),
		void (*irq_handler_hsync)(void*));
#endif /* VGA_DISPLAY_H_ */
