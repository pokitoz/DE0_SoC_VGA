#include "sys/alt_stdio.h"
#include "altera_msgdma.h"
#include <stdlib.h>
#include <stdint-gcc.h>
#include "system.h"


#define VGA_DISPLAY_ADDRESS_SRC_IMAGE ((uint8_t*) HPS_0_BRIDGES_BASE + (uint8_t*) 0x1000)
#define VGA_DISPLAY_ADDRESS_DST_IMAGE ((uint8_t*) HPS_0_BRIDGES_BASE + (uint8_t*) 0x100000)

static alt_msgdma_standard_descriptor* create_descriptor_list(
															alt_msgdma_dev* msgdma,
															void* address_source,
															void* address_dest,
															uint32_t length)
{

	// Get the maximal size of a descriptor
	uint32_t max_descriptor_size = msgdma->max_byte;
	// Find the number of descriptor needed
	uint32_t descriptor_number = 1 + ((length - 1) / max_descriptor_size);

	alt_msgdma_standard_descriptor* msgdma_desc = NULL;
	msgdma_desc = (alt_msgdma_standard_descriptor*) malloc(
			descriptor_number * sizeof(alt_msgdma_standard_descriptor));
	if (msgdma_desc == NULL) {
		alt_printf("create_descriptor_list: msgdma_desc == NULL");
		return NULL;
	}

	uint8_t* _address_src_descriptor = (uint8_t *) address_source;
	uint8_t* _address_dst_descriptor = (uint8_t *) address_dest;

	uint32_t i = 0;
	for (i = 0; i < descriptor_number -1; i++) {

		alt_msgdma_construct_standard_mm_to_mm_descriptor(msgdma,
													&msgdma_desc[i],
													(uint32_t *) _address_src_descriptor,
													(uint32_t *) _address_dst_descriptor,
													max_descriptor_size,
													0 );
		_address_dst_descriptor += max_descriptor_size;
		_address_src_descriptor += max_descriptor_size;

	}

	// Adjust the last descriptor
	alt_msgdma_construct_standard_mm_to_mm_descriptor(msgdma,
													&msgdma_desc[i],
													(uint32_t *) _address_src_descriptor,
													(uint32_t *) _address_dst_descriptor,
													length - max_descriptor_size*i,
													0 );


	return msgdma_desc;
}

int main(void) {

	alt_putstr("Hello from VGA_DMA project!\n");
	ALTERA_MSGDMA_CSR_DESCRIPTOR_SLAVE_INSTANCE(MSGDMA_0, MSGDMA_0_CSR, MSGDMA_0_DESCRIPTOR_SLAVE, msgdma);

	alt_msgdma_standard_descriptor* msgdma_desc = NULL;
	msgdma_desc = create_descriptor_list(&msgdma,
							VGA_DISPLAY_ADDRESS_SRC_IMAGE,
							VGA_DISPLAY_ADDRESS_DST_IMAGE,
							1000
							);



	/* Event loop never exits. */
	while (1)
		;

	return 0;
}
