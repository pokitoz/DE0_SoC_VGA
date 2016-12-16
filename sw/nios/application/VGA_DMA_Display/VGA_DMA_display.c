#include "sys/alt_stdio.h"
#include <stdint-gcc.h>
#include "system.h"
#include <unistd.h>
#include <sys/alt_cache.h>
#include "msgDMA.h"
#include "io.h"

#define VGA_DISPLAY_ADDRESS_DST_IMAGE (void*)(HPS_0_BRIDGES_BASE + 0x1000)


int main(void) {

	int i = 0;

	alt_putstr("Hello from VGA_DMA project!\n");
	ALTERA_MSGDMA_CSR_DESCRIPTOR_SLAVE_INSTANCE(MSGDMA_0, MSGDMA_0_CSR,
			MSGDMA_0_DESCRIPTOR_SLAVE, msgdma);

	const uint32_t c = 64;
	uint8_t src[c];

	//uint8_t dest[c];

	for (i = 0; i < c; ++i) {
		src[i] = 10;
		IOWR_8DIRECT(VGA_DISPLAY_ADDRESS_DST_IMAGE, i, 0);
	}

	alt_dcache_flush_all();

	alt_msgdma_init(&msgdma, MSGDMA_0_CSR_IRQ_INTERRUPT_CONTROLLER_ID,
	MSGDMA_0_CSR_IRQ);

	alt_msgdma_standard_descriptor msgdma_desc[10];
	uint32_t descriptor_number = msgdma_create_descriptor_list(&msgdma,
			msgdma_desc, src, VGA_DISPLAY_ADDRESS_DST_IMAGE, c);

	if (msgdma_desc == NULL) {
		alt_putstr("msgdma_desc is null");
		return 0;
	}

	msgdma_transfer(&msgdma, msgdma_desc, descriptor_number);

	for (i = 0; i < c; ++i) {
		uint32_t d = IORD_8DIRECT(VGA_DISPLAY_ADDRESS_DST_IMAGE, i);
		if (d == src[i]) {
			alt_printf("Ok\n");
		} else {
			alt_printf("No %x %x\n", d, src[i]);
		}
	}



	return 0;
}
