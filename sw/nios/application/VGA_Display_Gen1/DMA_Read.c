/*
 * DMA_Read.c
 *
 *  Created on: Jan 1, 2017
 *      Author: pokitoz
 */

#include "DMA_Read.h"
#include "io.h"
#include "alt_types.h"

void DMA_Read_configureDMA(alt_u32 base, alt_u32 buffer1_addr,
							alt_u32 buffer2_addr,
							alt_u32 transfer_size){

	IOWR_32DIRECT(base, DMA_READ_BUFFER_1_ADDR_REG, buffer1_addr);
	IOWR_32DIRECT(base, DMA_READ_BUFFER_2_ADDR_REG, buffer2_addr);
	IOWR_32DIRECT(base, DMA_READ_TRANSFER_LENGTH_REG, transfer_size);
}


void DMA_Read_setFlags(alt_u32 base, alt_u32 flags) {
	IOWR_32DIRECT(base, DMA_READ_CONFIGURATION_REG, flags);
}
