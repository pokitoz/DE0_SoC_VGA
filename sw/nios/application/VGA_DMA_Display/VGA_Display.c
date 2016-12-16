/*
 * VGA_Display.c
 *
 *  Created on: Dec 16, 2016
 *      Author: pokitoz
 */

#include "VGA_Display.h"
#include "io.h"
#include "stdint-gcc.h"

void VGA_Display_changeScreenColor(uint32_t BASE, uint32_t color) {

	IOWR_32DIRECT(BASE, VGA_DISPLAY_COLOR_REG, color);

}

