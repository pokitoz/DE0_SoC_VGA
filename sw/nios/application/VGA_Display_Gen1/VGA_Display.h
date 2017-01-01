/*
 * VGA_Display.h
 *
 *  Created on: Dec 16, 2016
 *      Author: pokitoz
 */

#ifndef VGA_DISPLAY_H_
#define VGA_DISPLAY_H_

#include "alt_types.h"

#define VGA_DISPLAY_COLOR_REG          (0 * 4)
#define VGA_DISPLAY_CONFIGURATION      (1 * 4)
#define VGA_DISPLAY_PORCH_V_REG        (2 * 4)
#define VGA_DISPLAY_PORCH_H_REG        (3 * 4)
#define VGA_DISPLAY_AREA_PULSE_V_REG   (4 * 4)
#define VGA_DISPLAY_AREA_PULSE_H_REG   (5 * 4)
#define VGA_DISPLAY_WHOLE_H_V_REG      (6 * 4)
#define VGA_DISPLAY_CLEAN_IRQ_REG 	   (7 * 4)

#define VGA_DISPLAY_WHOLE_FRAME_640x480_DEFAULT    525
#define VGA_DISPLAY_VISIBLE_AREA_V_640x480_DEFAULT 480
#define VGA_DISPLAY_FRONT_PORCH_V_640x480_DEFAULT  10
#define VGA_DISPLAY_SYNC_PULSE_V_640x480_DEFAULT   2
#define VGA_DISPLAY_BACK_PORCH_V_640x480_DEFAULT   33

#define VGA_DISPLAY_WHOLE_LINE_640x480_DEFAULT     800
#define VGA_DISPLAY_VISIBLE_AREA_H_640x480_DEFAULT 640
#define VGA_DISPLAY_FRONT_PORCH_H_640x480_DEFAULT  16
#define VGA_DISPLAY_SYNC_PULSE_H_640x480_DEFAULT   96
#define VGA_DISPLAY_BACK_PORCH_H_640x480_DEFAULT   48


void VGA_Display_changeScreenColor(alt_u32 BASE, alt_u32 color);
void VGA_Display_set_irq(void (*irq_handler)(void*, alt_u32));
void VGA_Display_changeVerticalPorch(alt_u32 BASE, alt_u16 front_porch, alt_u16 back_porch);
void VGA_Display_changeHorizontalPorch(alt_u32 BASE, alt_u16 front_porch, alt_u16 back_porch);

#endif /* VGA_DISPLAY_H_ */
