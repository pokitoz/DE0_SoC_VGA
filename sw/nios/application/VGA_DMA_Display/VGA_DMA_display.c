#include "sys/alt_stdio.h"
#include "altera_msgdma.h"
#include <stdint-gcc.h>
#include "system.h"
#include <unistd.h>
#include <sys/alt_cache.h>

#define VGA_DISPLAY_ADDRESS_DST_IMAGE (void*)(HPS_0_BRIDGES_BASE + 0x1000)

static void msgdma_transfer(alt_msgdma_dev* msgdma,
		alt_msgdma_standard_descriptor* msgdma_desc, uint32_t descriptor_number) {

	unsigned int i = 0;
	unsigned int error_dma = 0;
	unsigned int result;

	while (i < descriptor_number) {

		result = alt_msgdma_standard_descriptor_async_transfer(msgdma,
				&msgdma_desc[i]);

		if ((result == -ENOSPC)) {
			error_dma++;
			alt_printf("msgdma_transfer descriptor buffer is full\n");
		} else if (result == -ETIME) {
			error_dma++;
			alt_printf("msgdma_transfer dma_mm_interface_read: timeout\n");
		} else if (result == -EPERM) {
			error_dma++;
			alt_printf(
					"msgdma_transfer dma_mm_interface_read: operation not permitted due to descriptor type conflict\n");
		} else {
			i++;
			alt_printf(
					"msgdma_transfer dma_mm_interface_read: sending msgdma descriptor mm_s=%d \n",
					i);
		}

		if (error_dma == 100) {
			alt_printf("Error DMA exceeded\n");
			return;
		}

	}

	alt_printf("Transfer successful\n");
}

static uint32_t msgdma_create_descriptor_list(alt_msgdma_dev* msgdma,
		alt_msgdma_standard_descriptor* msgdma_desc, void* address_source,
		void* address_dest, uint32_t length) {

	// Get the maximal size of a descriptor
	uint32_t max_descriptor_size = msgdma->max_byte;
	// Find the number of descriptor needed
	uint32_t descriptor_number = 1 + ((length - 1) / max_descriptor_size);

	if (msgdma_desc == NULL) {
		alt_printf("msgdma_create_descriptor_list: msgdma_desc == NULL");
		return 0;
	}

	alt_printf("max_descriptor_size=0x%x, descriptor_number=0x%x\n",
			max_descriptor_size, descriptor_number);

	uint8_t* _address_src_descriptor = (uint8_t *) address_source;
	uint8_t* _address_dst_descriptor = (uint8_t *) address_dest;

	uint32_t i = 0;
	for (i = 0; i < descriptor_number - 1; i++) {
		alt_printf("i=%d, src=0x%x, dst=0x%x\n", i, _address_src_descriptor,
				_address_dst_descriptor);

		alt_msgdma_construct_standard_mm_to_mm_descriptor(msgdma,
				msgdma_desc + i, (uint32_t *) _address_src_descriptor,
				(uint32_t *) _address_dst_descriptor, max_descriptor_size, 0);
		_address_dst_descriptor += max_descriptor_size;
		_address_src_descriptor += max_descriptor_size;

	}

	alt_printf("i=%d, src=0x%x, dst=0x%x\n", i, _address_src_descriptor,
			_address_dst_descriptor);
	// Adjust the last descriptor
	alt_msgdma_construct_standard_mm_to_mm_descriptor(msgdma, msgdma_desc + i,
			(uint32_t *) _address_src_descriptor,
			(uint32_t *) _address_dst_descriptor,
			length - max_descriptor_size * i, 0);

	return descriptor_number;
}

int main(void) {

	int i = 0;
//
//	for (i = 0; i < 24; ++i) {
//		IOWR_32DIRECT(VGA_MODULE_0_BASE, 0, 1 << i);
//		usleep(1000000);
//	}
//
//	for (i = 0; i < 24; ++i) {
//		IOWR_32DIRECT(VGA_MODULE_0_BASE, 0, 31 >> i);
//		usleep(1000000);
//	}
//
//	IOWR_32DIRECT(VGA_MODULE_0_BASE, 0, 0x00FF0000);

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
