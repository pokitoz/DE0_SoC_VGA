# TCL File Generated by Component Editor 15.1
# Mon Jan 02 14:42:38 CET 2017
# DO NOT MODIFY


# 
# DMA_Read "DMA_Read" v1.0
# fdepraz 2017.01.02.14:42:38
# Transfer bytes to a stream
# 

# 
# request TCL package from ACDS 15.1
# 
package require -exact qsys 15.1


# 
# module DMA_Read
# 
set_module_property DESCRIPTION "Transfer bytes to a stream"
set_module_property NAME DMA_Read
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Memory_transfer
set_module_property AUTHOR fdepraz
set_module_property DISPLAY_NAME DMA_Read
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL DMA_Read
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file DMA_Read.vhd VHDL PATH ../hdl/DMA_Read.vhd TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point as
# 
add_interface as avalon end
set_interface_property as addressUnits WORDS
set_interface_property as associatedClock clock_sink
set_interface_property as associatedReset reset_sink
set_interface_property as bitsPerSymbol 8
set_interface_property as burstOnBurstBoundariesOnly false
set_interface_property as burstcountUnits WORDS
set_interface_property as explicitAddressSpan 0
set_interface_property as holdTime 0
set_interface_property as linewrapBursts false
set_interface_property as maximumPendingReadTransactions 0
set_interface_property as maximumPendingWriteTransactions 0
set_interface_property as readLatency 0
set_interface_property as readWaitTime 1
set_interface_property as setupTime 0
set_interface_property as timingUnits Cycles
set_interface_property as writeWaitTime 0
set_interface_property as ENABLED true
set_interface_property as EXPORT_OF ""
set_interface_property as PORT_NAME_MAP ""
set_interface_property as CMSIS_SVD_VARIABLES ""
set_interface_property as SVD_ADDRESS_GROUP ""

add_interface_port as as_write write Input 1
add_interface_port as as_read read Input 1
add_interface_port as as_rddata readdata Output 32
add_interface_port as as_addr address Input 3
add_interface_port as as_wrdata writedata Input 32
set_interface_assignment as embeddedsw.configuration.isFlash 0
set_interface_assignment as embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment as embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment as embeddedsw.configuration.isPrintableDevice 0


# 
# connection point reset_sink
# 
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink rst_n reset_n Input 1


# 
# connection point clock_sink
# 
add_interface clock_sink clock end
set_interface_property clock_sink clockRate 0
set_interface_property clock_sink ENABLED true
set_interface_property clock_sink EXPORT_OF ""
set_interface_property clock_sink PORT_NAME_MAP ""
set_interface_property clock_sink CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink SVD_ADDRESS_GROUP ""

add_interface_port clock_sink system_clk clk Input 1


# 
# connection point avalon_streaming_source
# 
add_interface avalon_streaming_source avalon_streaming start
set_interface_property avalon_streaming_source associatedClock clock_sink
set_interface_property avalon_streaming_source associatedReset reset_sink
set_interface_property avalon_streaming_source dataBitsPerSymbol 8
set_interface_property avalon_streaming_source errorDescriptor ""
set_interface_property avalon_streaming_source firstSymbolInHighOrderBits true
set_interface_property avalon_streaming_source maxChannel 0
set_interface_property avalon_streaming_source readyLatency 0
set_interface_property avalon_streaming_source ENABLED true
set_interface_property avalon_streaming_source EXPORT_OF ""
set_interface_property avalon_streaming_source PORT_NAME_MAP ""
set_interface_property avalon_streaming_source CMSIS_SVD_VARIABLES ""
set_interface_property avalon_streaming_source SVD_ADDRESS_GROUP ""

add_interface_port avalon_streaming_source asts_valid valid Output 1
add_interface_port avalon_streaming_source asts_ready ready Input 1
add_interface_port avalon_streaming_source asts_data data Output 32


# 
# connection point avalon_master
# 
add_interface avalon_master avalon start
set_interface_property avalon_master addressUnits SYMBOLS
set_interface_property avalon_master associatedClock clock_sink
set_interface_property avalon_master associatedReset reset_sink
set_interface_property avalon_master bitsPerSymbol 8
set_interface_property avalon_master burstOnBurstBoundariesOnly false
set_interface_property avalon_master burstcountUnits WORDS
set_interface_property avalon_master doStreamReads false
set_interface_property avalon_master doStreamWrites false
set_interface_property avalon_master holdTime 0
set_interface_property avalon_master linewrapBursts false
set_interface_property avalon_master maximumPendingReadTransactions 0
set_interface_property avalon_master maximumPendingWriteTransactions 0
set_interface_property avalon_master readLatency 0
set_interface_property avalon_master readWaitTime 1
set_interface_property avalon_master setupTime 0
set_interface_property avalon_master timingUnits Cycles
set_interface_property avalon_master writeWaitTime 0
set_interface_property avalon_master ENABLED true
set_interface_property avalon_master EXPORT_OF ""
set_interface_property avalon_master PORT_NAME_MAP ""
set_interface_property avalon_master CMSIS_SVD_VARIABLES ""
set_interface_property avalon_master SVD_ADDRESS_GROUP ""

add_interface_port avalon_master am_addr address Output 32
add_interface_port avalon_master am_byteenable byteenable Output 4
add_interface_port avalon_master am_read read Output 1
add_interface_port avalon_master am_readdata readdata Input 32
add_interface_port avalon_master am_waitrequest waitrequest Input 1

