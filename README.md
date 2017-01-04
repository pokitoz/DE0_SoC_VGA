# DE0_SoC_VGA

DE0 Nano SoC: 5csema4u23c6

The system contains
* Nios II/e processor
* HPS
* 64kB on-chip memory
* JTAG UART
* Address Span Expender
 * Used to access the HPS memory
 * 20 bit span: 4MBytes of available memory
 * https://documentation.altera.com/#/link/mwh1409960181641/mwh1409959261007
 * Set burst bits to 8: max burst count is 2^8 
 * Set sub windows offset to the address reserved
* mSGDMA
* Double clock FIFO streaming to streaming
 * 8196 bytes
 * 32 bit stream source and sink
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


Generate the QSYS (open Qsys, open system.qsys, refresh usinf F5)

Run the TCL script _system/synthesis/submodules/hps\_sdram\_p0\_pin\_assignments.tcl_ for the SDRAM assignement
Run the _TCL script pin\_assignment\_DE0\_Nano\_SoC\_VGA_extension.tcl_ to get the pin assignment

The FPGA cannot access the HPS memory if the HPS did not configure it. So a SD card must be flashed and plugged in to the board.


Simulation ModelSim
-------------------
* Test benches have been written for the modules
* They are quite generic and can be used for a template
* The waves/signals layout can be imported by running the script _wave.do_ once the simulation is launched
 * _do wave.do_


Fixes:
------
* If the IRQ numbers are set to '-1' in the system.h file, it means that the _set\_interface\_property\ <irq source> associatedAddressablePoint_ is not set.
This can be fixed in the GUI when you edit the _tcl_ component. 
 * Select the Interrupt Sender
 * In "Parameter", "Associated addressable interface" field should be set. (i.e. not NONE)
Note; Only one IRQ can be done per components. Otherwise you get the following error during the BSP generation in ECLIPSE NIOS II

SEVERE: Can only have at most one IRQ associated with the following slaves of module <NAME>
SEVERE: Can only have at most one IRQ associated with the following slaves of module <NAME>
SEVERE: nios2-bsp-generate-files failed.


Interesting links:
http://www-ug.eecg.toronto.edu/msl/nios_interrupts.html
http://www-ug.eecg.toronto.edu/msl/manuals/n2sw_nii52006.pdf

