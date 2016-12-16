/*
 * msgDMA.h
 *
 *  Created on: Dec 16, 2016
 *      Author: pokitoz
 */

#ifndef MSGDMA_H_
#define MSGDMA_H_

#include "altera_msgdma.h"
#include <stdint-gcc.h>

void msgdma_transfer(alt_msgdma_dev* msgdma,
		alt_msgdma_standard_descriptor* msgdma_desc,
		uint32_t descriptor_number);

uint32_t msgdma_create_descriptor_list(alt_msgdma_dev* msgdma,
		alt_msgdma_standard_descriptor* msgdma_desc, void* address_source,
		void* address_dest, uint32_t length);
#endif /* MSGDMA_H_ */
