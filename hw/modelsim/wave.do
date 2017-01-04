onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_dma_read/clk
add wave -noupdate /tb_dma_read/reset_n
add wave -noupdate /tb_dma_read/sim_finished
add wave -noupdate -color Tan -itemcolor Tan /tb_dma_read/asts_ready
add wave -noupdate -color Tan -itemcolor Tan /tb_dma_read/asts_valid
add wave -noupdate -color Tan -itemcolor Tan -radix hexadecimal /tb_dma_read/asts_data
add wave -noupdate -color Cyan -itemcolor Cyan -radix hexadecimal /tb_dma_read/am_addr
add wave -noupdate -color Cyan -itemcolor Cyan /tb_dma_read/am_byteenable
add wave -noupdate -color Cyan -itemcolor Cyan /tb_dma_read/am_read
add wave -noupdate -color Cyan -itemcolor Cyan -radix hexadecimal /tb_dma_read/am_readdata
add wave -noupdate -color Cyan -itemcolor Cyan /tb_dma_read/am_waitrequest
add wave -noupdate -radix hexadecimal /tb_dma_read/wrdata_dma
add wave -noupdate /tb_dma_read/write_dma
add wave -noupdate /tb_dma_read/addr_dma
add wave -noupdate /tb_dma_read/read_dma
add wave -noupdate -radix hexadecimal /tb_dma_read/rddata_dma
add wave -noupdate -color Yellow -itemcolor Gold -radix hexadecimal /tb_dma_read/DMA_R1/default_color
add wave -noupdate -color Yellow -itemcolor Gold -radix hexadecimal /tb_dma_read/DMA_R1/buffer1_base_address
add wave -noupdate -color Yellow -itemcolor Gold -radix hexadecimal /tb_dma_read/DMA_R1/buffer2_base_address
add wave -noupdate -color Yellow -itemcolor Gold /tb_dma_read/DMA_R1/buffer_selection
add wave -noupdate -color Yellow -itemcolor Gold -radix hexadecimal /tb_dma_read/DMA_R1/transfer_length
add wave -noupdate -color Yellow -itemcolor Gold /tb_dma_read/DMA_R1/dma_start
add wave -noupdate -color Yellow -itemcolor Gold /tb_dma_read/DMA_R1/dma_continue
add wave -noupdate -color Yellow -itemcolor Gold /tb_dma_read/DMA_R1/dma_auto_flip
add wave -noupdate -color Yellow -itemcolor Gold /tb_dma_read/DMA_R1/dma_use_constant
add wave -noupdate -color Yellow -itemcolor Gold /tb_dma_read/DMA_R1/dma_use_counter
add wave -noupdate -color Yellow -itemcolor Gold /tb_dma_read/DMA_R1/state_reg
add wave -noupdate -color Yellow -itemcolor Gold /tb_dma_read/DMA_R1/state_next
add wave -noupdate -color Yellow -itemcolor Gold /tb_dma_read/DMA_R1/counter_reg
add wave -noupdate -color Yellow -itemcolor Gold /tb_dma_read/DMA_R1/counter_next
add wave -noupdate -color Yellow -itemcolor Gold -radix hexadecimal /tb_dma_read/DMA_R1/am_data_reg
add wave -noupdate -color Yellow -itemcolor Gold -radix hexadecimal /tb_dma_read/DMA_R1/am_data_next
add wave -noupdate -color Yellow -itemcolor Gold /tb_dma_read/DMA_R1/dma_idle_reg
add wave -noupdate -color Yellow -itemcolor Gold /tb_dma_read/DMA_R1/dma_idle_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {640577 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {4096 ns}
