# DE0_SoC_VGA

DE0 Nano SoC: 5csema4u23c6

System contains
        Nios II/e processor Gen 2
        HPS
        128kB on-chip memory
        JTAG UART
        Address Span Expender
                Used to access the HPS memory
                20 bit span: 4MBytes of available memory
                https://documentation.altera.com/#/link/mwh1409960181641/mwh1409959261007
        DMA
        Custom module for VGA

The goal of this project is to use a VGA connector to display a 640x480 image on a monitor

