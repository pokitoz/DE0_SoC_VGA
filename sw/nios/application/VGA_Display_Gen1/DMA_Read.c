/*
 * DMA_Read.c
 *
 *  Created on: Jan 1, 2017
 *      Author: pokitoz
 */

#include "DMA_Read.h"
#include "io.h"
#include "alt_types.h"
#include "sys/alt_stdio.h"


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

void DMA_Read_status(alt_u32 base){
	alt_u32 value = IORD_32DIRECT(base, DMA_READ_CURRENT_CONFIG_REG);
	alt_printf("Value config: 0x%x\n", value);
	if(value & DMA_READ_BIT_IDLE){
		alt_printf("DMA_IDLE\n");
	}
	if(value & DMA_READ_BIT_BUFFER){
		alt_printf("DMA_IDLE\n");
	}
	if(value & DMA_READ_BIT_START){
		alt_printf("DMA_READ_BIT_START\n");
	}
	if(value & DMA_READ_BIT_CONTINUE){
		alt_printf("DMA_READ_BIT_CONTINUE\n");
	}
	if(value & DMA_READ_BIT_AUTO_FLIP){
		alt_printf("DMA_READ_BIT_AUTO_FLIP\n");
	}
	if(value & DMA_READ_BIT_CONSTANT){
		alt_printf("DMA_READ_BIT_CONSTANT\n");
	}
	if(value & DMA_READ_BIT_DMA_CONSTANT){
		alt_printf("DMA_READ_BIT_DMA_CONSTANT\n");
	}
	if(value & DMA_READ_BIT_STATE){
		alt_printf("DMA_READ_BIT_STATE: %x\n", (value & DMA_READ_BIT_STATE) >> 7 );
	}

	alt_u32 buff1 = IORD_32DIRECT(base, DMA_READ_BUFFER_1_ADDR_REG);
	alt_u32 buff2 = IORD_32DIRECT(base, DMA_READ_BUFFER_2_ADDR_REG);
	alt_u32 size = IORD_32DIRECT(base, DMA_READ_TRANSFER_LENGTH_REG);
	alt_printf("DMA_READ_BUFFER_1_ADDR_REG: %x\n", buff1 );
	alt_printf("DMA_READ_BUFFER_2_ADDR_REG: %x\n", buff2 );
	alt_printf("DMA_READ_TRANSFER_LENGTH_REG: %x\n", size );
	alt_printf("DMA_READ_COUNTER_READ: %x\n\n", (value & DMA_READ_COUNTER_READ) >> 16 );


}
