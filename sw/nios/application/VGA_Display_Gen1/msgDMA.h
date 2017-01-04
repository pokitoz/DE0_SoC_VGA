/*
 * msgDMA.h
 *
 *  Created on: Dec 16, 2016
 *      Author: pokitoz
 */

#ifndef MSGDMA_H_
#define MSGDMA_H_

#include "altera_msgdma.h"
#include <alt_types.h>

void msgdma_transfer(alt_msgdma_dev* msgdma,
		alt_msgdma_standard_descriptor* msgdma_desc,
		alt_u32 descriptor_number);

alt_u32 msgdma_create_mm_to_mm_descriptor_list(alt_msgdma_dev* msgdma,
		alt_msgdma_standard_descriptor* msgdma_desc, void* address_source,
		void* address_dest, alt_u32 length);

alt_u32 msgdma_create_mm_to_st_descriptor_list(alt_msgdma_dev* msgdma,
		alt_msgdma_standard_descriptor* msgdma_desc, void* address_source,
		alt_u32 length);
#endif /* MSGDMA_H_ */
