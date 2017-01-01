/*
 * DMA_Read.h
 *
 *  Created on: Dec 16, 2016
 *      Author: pokitoz
 */

#ifndef DMA_READ_H_
#define DMA_READ_H_

#include "alt_types.h"

#define DMA_READ_BUFFER_1_ADDR_REG      (0 * 4)
#define DMA_READ_BUFFER_2_ADDR_REG      (1 * 4)
#define DMA_READ_TRANSFER_LENGTH_REG	(2 * 4)
#define DMA_READ_BUFFER_SELECTION_REG	(3 * 4)
#define DMA_READ_CONFIGURATION_REG		(4 * 4)

#define DMA_READ_BIT_IDLE			(1<<0)
#define DMA_READ_BIT_BUFFER			(1<<1)
#define DMA_READ_BIT_START 		    (1<<2)
#define DMA_READ_BIT_CONTINUE    	(1<<3)
#define DMA_READ_BIT_AUTO_FLIP	    (1<<4)
#define DMA_READ_BIT_CONSTANT	    (1<<5)
#define DMA_READ_BIT_DMA_CONSTANT	(1<<6)

void DMA_Read_configureDMA(alt_u32 base, alt_u32 buffer1_addr,
		alt_u32 buffer2_addr, alt_u32 transfer_size);

void DMA_Read_setFlags(alt_u32 base, alt_u32 flags);

#endif /* DMA_READ_H_ */
