#include "sys/alt_stdio.h"
#include "altera_msgdma.h"
#include "system.h"
#include <unistd.h>
#include <sys/alt_cache.h>
#include "msgDMA.h"
#include "io.h"
#include "VGA_Display.h"
#include "alt_types.h"

#define VGA_DISPLAY_ADDRESS_DST_IMAGE (void*)(HPS_0_BRIDGES_BASE + 16384)

volatile alt_u32 vsync = 0;
volatile alt_u32 next_desc = 0;

alt_msgdma_standard_descriptor msgdma_desc[30];
alt_msgdma_dev msgdma_dev;
alt_u32 descriptor_number;

void irq_vsync(void* context, alt_u32 id){

	//alt_msgdma_standard_descriptor_async_transfer(&msgdma_dev, &msgdma_desc[next_desc]);

	// 640 x 24 byte per line: 15360
	// FIFO is 2048 + 8192 bytes
	// A descriptor is 16kB
	// Total is 640 x 480 x 24 = 7372800 bytes
	// Need 450 descriptors..
	// Max 32
	// So descriptor is 256kB
	// Gives around 28 descriptors;
	//
	next_desc++;
	vsync++;
	if (next_desc == descriptor_number) {
		next_desc = 0;
	}

	IOWR_32DIRECT(VGA_MODULE_0_BASE, VGA_DISPLAY_CONFIGURATION, 0x3);

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

	descriptor_number = msgdma_create_mm_to_st_descriptor_list(&msgdma,
			msgdma_desc, VGA_DISPLAY_ADDRESS_DST_IMAGE, 480);

	if (msgdma_desc == NULL) {
		alt_putstr("msgdma_desc is null");
		return 0;
	}

	VGA_Display_set_irq(irq_vsync);

	//msgdma_transfer(&msgdma_dev, msgdma_desc, descriptor_number);
	while (1) {
		alt_printf("Next: 0x%x,\n", next_desc);
		usleep(100);
	}

	return 0;
}
