#include "sys/alt_stdio.h"
#include <stdint-gcc.h>
#include "system.h"
#include <unistd.h>
#include <sys/alt_cache.h>
#include "msgDMA.h"
#include "io.h"
#include "VGA_Display.h"

#define VGA_DISPLAY_ADDRESS_DST_IMAGE (void*)(HPS_0_BRIDGES_BASE + 0x1000)

uint32_t vsync = 0;

void irq_vsync(void* args){
	vsync++;
}


int main(void) {

	alt_putstr("Hello from VGA_DMA project!\n");


	VGA_Display_set_irq(irq_vsync);

	VGA_Display_changeScreenColor(VGA_MODULE_0_BASE, 0x00FF000F);

	/*
	ALTERA_MSGDMA_CSR_DESCRIPTOR_SLAVE_INSTANCE(MSGDMA_0, MSGDMA_0_CSR,
			MSGDMA_0_DESCRIPTOR_SLAVE, msgdma);

	alt_msgdma_init(&msgdma, MSGDMA_0_CSR_IRQ_INTERRUPT_CONTROLLER_ID,
	MSGDMA_0_CSR_IRQ);

	alt_msgdma_standard_descriptor msgdma_desc[10];
	uint32_t descriptor_number = msgdma_create_mm_to_mm_descriptor_list(&msgdma,
			msgdma_desc, src, VGA_DISPLAY_ADDRESS_DST_IMAGE, c);

	if (msgdma_desc == NULL) {
		alt_putstr("msgdma_desc is null");
		return 0;
	}



	msgdma_transfer(&msgdma, msgdma_desc, descriptor_number);

	*/

	while(1){
		alt_printf("h: 0x%x,\n", vsync);
		usleep(100000);

	}

	return 0;
}
