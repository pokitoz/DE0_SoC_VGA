#include "sys/alt_stdio.h"
#include "altera_msgdma.h"
#include "system.h"
#include <unistd.h>
#include <sys/alt_cache.h>
#include "msgDMA.h"
#include "io.h"
#include "VGA_Display.h"
#include "alt_types.h"
#include "sys/alt_irq.h"
#include "DMA_Read.h"

#define VGA_DISPLAY_ADDRESS_DST_IMAGE (void*)(HPS_0_BRIDGES_BASE)

volatile alt_u32 vsync = 0;
volatile alt_u32 next_desc = 0;

alt_msgdma_standard_descriptor msgdma_desc;
alt_msgdma_dev msgdma_dev;
alt_u32 descriptor_number;

void irq_vsync(void* context, alt_u32 id) {

	// 640 x 24 byte per line: 15360
	// FIFO is 2048 + 8192 bytes
	// A descriptor is N kB
	// Total is 640 x 480 x 24 = 7372800 bytes
	// Need 7372800 / N  descriptors..
	// Send one descriptor at a time
	// Generate on the fly

	//alt_msgdma_construct_standard_mm_to_st_descriptor(&msgdma_dev,
	//		&msgdma_desc, VGA_DISPLAY_ADDRESS_DST_IMAGE, 640, 0);

	//	next_desc++;
	vsync += 1;
	//IOWR_32DIRECT(DMA_READ_0_BASE, DMA_READ_CONSTANT_REG, vsync);

	//	if (next_desc == descriptor_number) {
	//		next_desc = 0;
	//	}

	//alt_msgdma_standard_descriptor_async_transfer(&msgdma_dev, &msgdma_desc);

	// Clean the IRQ
	IOWR_32DIRECT(VGA_MODULE_0_BASE, VGA_DISPLAY_CLEAN_IRQ_REG, 0x1);

}

int main(void) {

	alt_putstr("Hello from VGA_DMA project!\n");

	VGA_Display_changeScreenColor(VGA_MODULE_0_BASE, 0x00FF00FF);

	IOWR_32DIRECT(VGA_MODULE_0_BASE, VGA_DISPLAY_CONFIGURATION, 0x1);

	ALTERA_MSGDMA_CSR_DESCRIPTOR_SLAVE_INSTANCE(MSGDMA_0, MSGDMA_0_CSR,
			MSGDMA_0_DESCRIPTOR_SLAVE, msgdma);

	msgdma_dev = msgdma;
	alt_msgdma_init(&msgdma_dev, MSGDMA_0_CSR_IRQ_INTERRUPT_CONTROLLER_ID,
	MSGDMA_0_CSR_IRQ);

	alt_ic_isr_register(VGA_MODULE_0_IRQ_INTERRUPT_CONTROLLER_ID,
	VGA_MODULE_0_IRQ, (void*) irq_vsync, 0, 0);

	// Enable the interrupts
	alt_ic_irq_enable(VGA_MODULE_0_IRQ_INTERRUPT_CONTROLLER_ID,
	VGA_MODULE_0_IRQ);

	int ki = 0;
//	for(ki = 0; ki < 640*480*3; ki++){
//		IOWR(HPS_0_BRIDGES_BASE, 4*ki, 0x00);
//	}
	DMA_Read_status(DMA_READ_0_BASE);

	alt_u32 test[64];
	for (ki = 0; ki < 32; ki++) {
		test[ki] = (0x1 << ki);
	}

	for (ki = 32; ki < 64; ki++) {
		test[ki] = 0;
	}

	// (640pixel*4byte)/4 get # of words to be transfered per line
	DMA_Read_configureDMA(DMA_READ_0_BASE, (alt_u32) HPS_0_BRIDGES_BASE, (alt_u32) HPS_0_BRIDGES_BASE, 640);

	IOWR_32DIRECT(DMA_READ_0_BASE, DMA_READ_CONSTANT_REG, 0xFF);

	//DMA_Read_setFlags(DMA_READ_0_BASE, 0b01000100);
	DMA_Read_setFlags(DMA_READ_0_BASE, DMA_READ_BIT_START | DMA_READ_BIT_CONTINUE);
	DMA_Read_status(DMA_READ_0_BASE);

	volatile int kk = 0;
	//msgdma_transfer(&msgdma_dev, msgdma_desc, descriptor_number);
	while (1) {
		alt_printf("Next: 0x%x,\n", vsync);
		//usleep(100000);
		for (kk = 0; kk < 10000000; kk++) {
		}

		DMA_Read_status(DMA_READ_0_BASE);

	}

	return 0;
}
