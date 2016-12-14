# DE0_SoC_VGA

DE0 Nano SoC: 5csema4u23c6

The system contains
* Nios II/e processor Gen 2
* HPS
* 128kB on-chip memory
* JTAG UART
* Address Span Expender
 * Used to access the HPS memory
 * 20 bit span: 4MBytes of available memory
 * https://documentation.altera.com/#/link/mwh1409960181641/mwh1409959261007
* mSGDMA
* FIFO
* PLL (for clock generation depending on the resolution)
* Custom module for VGA
* I2C FPGA module

The goal of this project is to use a VGA connector to display an image on a monitor
Use the I2C of the VGA to get the supported resolution of the screen.
Supported resolution:
* 1024x768 @ 60 Hz (pixel clock 65 MHz)
* 800x600  @ 60 Hz (pixel clock 40 MHz)
* 640x480  @ 60 Hz (pixel clock 25 MHz)

The image is on the Nios-II processor and send through the DMA to the VGA controller.


Generate the QSYS
Run the TCL script _system/synthesis/submodules/hps\_sdram\_p0\_pin\_assignments.tcl_ for the SDRAM assignement
Run the _TCL script pin\_assignment\_DE0\_Nano\_SoC\_VGA_extension.tcl_ to get the pin assignment

The FPGA cannot access the HPS memory if the HPS did not configure it. So a SD card must be flashed and plugged in to the board.


