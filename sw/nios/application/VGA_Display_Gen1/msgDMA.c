/*
 * msgDMA.c
 *
 *  Created on: Dec 16, 2016
 *      Author: pokitoz
 */

#include "msgDMA.h"
#include <alt_types.h>
#include "sys/alt_stdio.h"
#include <errno.h>
#include <stddef.h>

void msgdma_transfer(alt_msgdma_dev* msgdma,
		alt_msgdma_standard_descriptor* msgdma_desc, alt_u32 descriptor_number) {

	unsigned int i = 0;
	unsigned int error_dma = 0;

	while (i < descriptor_number) {

		unsigned int result;

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

	//alt_printf("Transfer successful\n");
}

alt_u32 msgdma_create_mm_to_mm_descriptor_list(alt_msgdma_dev* msgdma,
		alt_msgdma_standard_descriptor* msgdma_desc, void* address_source,
		void* address_dest, alt_u32 length) {

	// Get the maximal size of a descriptor
	alt_u32 max_descriptor_size = msgdma->max_byte;
	// Find the number of descriptor needed
	alt_u32 descriptor_number = 1 + ((length - 1) / max_descriptor_size);

	if (msgdma_desc == NULL) {
		alt_printf("msgdma_create_descriptor_list: msgdma_desc == NULL");
		return 0;
	}

	alt_printf("max_descriptor_size=0x%x, descriptor_number=0x%x\n",
			max_descriptor_size, descriptor_number);

	alt_u8* _address_src_descriptor = (alt_u8 *) address_source;
	alt_u8* _address_dst_descriptor = (alt_u8 *) address_dest;

	alt_u32 i = 0;
	for (i = 0; i < descriptor_number - 1; i++) {
		alt_printf("i=%d, src=0x%x, dst=0x%x\n", i, _address_src_descriptor,
				_address_dst_descriptor);

		alt_msgdma_construct_standard_mm_to_mm_descriptor(msgdma,
				msgdma_desc + i, (alt_u32 *) _address_src_descriptor,
				(alt_u32 *) _address_dst_descriptor, max_descriptor_size, 0);
		_address_dst_descriptor += max_descriptor_size;
		_address_src_descriptor += max_descriptor_size;

	}

	alt_printf("i=%d, src=0x%x, dst=0x%x\n", i, _address_src_descriptor,
			_address_dst_descriptor);
	// Adjust the last descriptor
	alt_msgdma_construct_standard_mm_to_mm_descriptor(msgdma, msgdma_desc + i,
			(alt_u32 *) _address_src_descriptor,
			(alt_u32 *) _address_dst_descriptor,
			length - max_descriptor_size * i, 0);

	return descriptor_number;
}



alt_u32 msgdma_create_mm_to_st_descriptor_list(alt_msgdma_dev* msgdma,
		alt_msgdma_standard_descriptor* msgdma_desc, void* address_source,
		alt_u32 length) {

	// Get the maximal size of a descriptor
	alt_u32 max_descriptor_size = msgdma->max_byte;
	// Find the number of descriptor needed
	alt_u32 descriptor_number = 1 + ((length - 1) / max_descriptor_size);

	if (msgdma_desc == NULL) {
		alt_printf("msgdma_create_descriptor_list: msgdma_desc == NULL");
		return 0;
	}

	alt_printf("max_descriptor_size=0x%x, descriptor_number=0x%x\n",
			max_descriptor_size, descriptor_number);

	alt_u8* _address_src_descriptor = (alt_u8 *) address_source;

	alt_u32 i = 0;
	for (i = 0; i < descriptor_number - 1; i++) {
		alt_printf("i=%d, src=0x%x\n", i, _address_src_descriptor);

		alt_msgdma_construct_standard_mm_to_st_descriptor(msgdma,
				msgdma_desc + i, (alt_u32 *) _address_src_descriptor, max_descriptor_size, 0);
		_address_src_descriptor += max_descriptor_size;

	}

	alt_printf("i=%d, src=0x%x, dst=0x%x\n", i, _address_src_descriptor);
	// Adjust the last descriptor
	alt_msgdma_construct_standard_mm_to_st_descriptor(msgdma, msgdma_desc + i,
			(alt_u32 *) _address_src_descriptor,
			length - max_descriptor_size * i, 0);

	return descriptor_number;
}

