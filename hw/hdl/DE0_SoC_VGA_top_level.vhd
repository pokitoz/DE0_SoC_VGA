library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DE0_SoC_VGA_top_level is
    port(

        -- CLOCK
        FPGA_CLK1_50                    : in    std_logic;

        -- KEY
        KEY_N                           : in    std_logic_vector(1 downto 0);

        -- LED
        LED                             : out   std_logic_vector(7 downto 0);

        -- SW
        SW                              : in    std_logic_vector(3 downto 0);

        -- GPIO_0
        VGA_VIDEO_R                     : out   std_logic_vector(7 downto 0);
        VGA_VIDEO_G                     : out   std_logic_vector(7 downto 0);
        VGA_VIDEO_B                     : out   std_logic_vector(7 downto 0);
        VGA_VIDEO_HSYNC                 : out   std_logic;
        VGA_VIDEO_VSYNC                 : out   std_logic;
        VGA_VIDEO_CLK                   : out   std_logic;
        VGA_SCL                         : out   std_logic;
        VGA_SDA                         : inout std_logic;
        VGA_BOARD_ID                    : inout std_logic;

        -- HPS
        HPS_CONV_USB_N                  : inout std_logic;
        HPS_DDR3_ADDR                   : out   std_logic_vector(14 downto 0);
        HPS_DDR3_BA                     : out   std_logic_vector(2 downto 0);
        HPS_DDR3_CAS_N                  : out   std_logic;
        HPS_DDR3_CK_N                   : out   std_logic;
        HPS_DDR3_CK_P                   : out   std_logic;
        HPS_DDR3_CKE                    : out   std_logic;
        HPS_DDR3_CS_N                   : out   std_logic;
        HPS_DDR3_DM                     : out   std_logic_vector(3 downto 0);
        HPS_DDR3_DQ                     : inout std_logic_vector(31 downto 0);
        HPS_DDR3_DQS_N                  : inout std_logic_vector(3 downto 0);
        HPS_DDR3_DQS_P                  : inout std_logic_vector(3 downto 0);
        HPS_DDR3_ODT                    : out   std_logic;
        HPS_DDR3_RAS_N                  : out   std_logic;
        HPS_DDR3_RESET_N                : out   std_logic;
        HPS_DDR3_RZQ                    : in    std_logic;
        HPS_DDR3_WE_N                   : out   std_logic;
        HPS_ENET_GTX_CLK                : out   std_logic;
        HPS_ENET_INT_N                  : inout std_logic;
        HPS_ENET_MDC                    : out   std_logic;
        HPS_ENET_MDIO                   : inout std_logic;
        HPS_ENET_RX_CLK                 : in    std_logic;
        HPS_ENET_RX_DATA                : in    std_logic_vector(3 downto 0);
        HPS_ENET_RX_DV                  : in    std_logic;
        HPS_ENET_TX_DATA                : out   std_logic_vector(3 downto 0);
        HPS_ENET_TX_EN                  : out   std_logic;
        HPS_GSENSOR_INT                 : inout std_logic;
        HPS_I2C0_SCLK                   : inout std_logic;
        HPS_I2C0_SDAT                   : inout std_logic;
        HPS_I2C1_SCLK                   : inout std_logic;
        HPS_I2C1_SDAT                   : inout std_logic;
        HPS_KEY_N                       : inout std_logic;
        HPS_LED                         : inout std_logic;
        HPS_LTC_GPIO                    : inout std_logic;
        HPS_SD_CLK                      : out   std_logic;
        HPS_SD_CMD                      : inout std_logic;
        HPS_SD_DATA                     : inout std_logic_vector(3 downto 0);
        HPS_SPIM_CLK                    : out   std_logic;
        HPS_SPIM_MISO                   : in    std_logic;
        HPS_SPIM_MOSI                   : out   std_logic;
        HPS_SPIM_SS                     : inout std_logic;
        HPS_UART_RX                     : in    std_logic;
        HPS_UART_TX                     : out   std_logic;
        HPS_USB_CLKOUT                  : in    std_logic;
        HPS_USB_DATA                    : inout std_logic_vector(7 downto 0);
        HPS_USB_DIR                     : in    std_logic;
        HPS_USB_NXT                     : in    std_logic;
        HPS_USB_STP                     : out   std_logic

    );
end entity DE0_SoC_VGA_top_level;

architecture rtl of DE0_SoC_VGA_top_level is

        component system is
                port (
                        clk_clk                           : in    std_logic                     := 'X';             -- clk
			hps_0_ddr_mem_a                   : out   std_logic_vector(14 downto 0);                    -- mem_a
			hps_0_ddr_mem_ba                  : out   std_logic_vector(2 downto 0);                     -- mem_ba
			hps_0_ddr_mem_ck                  : out   std_logic;                                        -- mem_ck
			hps_0_ddr_mem_ck_n                : out   std_logic;                                        -- mem_ck_n
			hps_0_ddr_mem_cke                 : out   std_logic;                                        -- mem_cke
			hps_0_ddr_mem_cs_n                : out   std_logic;                                        -- mem_cs_n
			hps_0_ddr_mem_ras_n               : out   std_logic;                                        -- mem_ras_n
			hps_0_ddr_mem_cas_n               : out   std_logic;                                        -- mem_cas_n
			hps_0_ddr_mem_we_n                : out   std_logic;                                        -- mem_we_n
			hps_0_ddr_mem_reset_n             : out   std_logic;                                        -- mem_reset_n
			hps_0_ddr_mem_dq                  : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
			hps_0_ddr_mem_dqs                 : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
			hps_0_ddr_mem_dqs_n               : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
			hps_0_ddr_mem_odt                 : out   std_logic;                                        -- mem_odt
			hps_0_ddr_mem_dm                  : out   std_logic_vector(3 downto 0);                     -- mem_dm
			hps_0_ddr_oct_rzqin               : in    std_logic                     := 'X';             -- oct_rzqin
			hps_0_io_hps_io_emac1_inst_TX_CLK : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
			hps_0_io_hps_io_emac1_inst_TXD0   : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
			hps_0_io_hps_io_emac1_inst_TXD1   : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
			hps_0_io_hps_io_emac1_inst_TXD2   : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
			hps_0_io_hps_io_emac1_inst_TXD3   : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
			hps_0_io_hps_io_emac1_inst_RXD0   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
			hps_0_io_hps_io_emac1_inst_MDIO   : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
			hps_0_io_hps_io_emac1_inst_MDC    : out   std_logic;                                        -- hps_io_emac1_inst_MDC
			hps_0_io_hps_io_emac1_inst_RX_CTL : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
			hps_0_io_hps_io_emac1_inst_TX_CTL : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
			hps_0_io_hps_io_emac1_inst_RX_CLK : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
			hps_0_io_hps_io_emac1_inst_RXD1   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
			hps_0_io_hps_io_emac1_inst_RXD2   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
			hps_0_io_hps_io_emac1_inst_RXD3   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
			hps_0_io_hps_io_sdio_inst_CMD     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
			hps_0_io_hps_io_sdio_inst_D0      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
			hps_0_io_hps_io_sdio_inst_D1      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
			hps_0_io_hps_io_sdio_inst_CLK     : out   std_logic;                                        -- hps_io_sdio_inst_CLK
			hps_0_io_hps_io_sdio_inst_D2      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
			hps_0_io_hps_io_sdio_inst_D3      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
			hps_0_io_hps_io_usb1_inst_D0      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
			hps_0_io_hps_io_usb1_inst_D1      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
			hps_0_io_hps_io_usb1_inst_D2      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
			hps_0_io_hps_io_usb1_inst_D3      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
			hps_0_io_hps_io_usb1_inst_D4      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
			hps_0_io_hps_io_usb1_inst_D5      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
			hps_0_io_hps_io_usb1_inst_D6      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
			hps_0_io_hps_io_usb1_inst_D7      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
			hps_0_io_hps_io_usb1_inst_CLK     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
			hps_0_io_hps_io_usb1_inst_STP     : out   std_logic;                                        -- hps_io_usb1_inst_STP
			hps_0_io_hps_io_usb1_inst_DIR     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
			hps_0_io_hps_io_usb1_inst_NXT     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
			hps_0_io_hps_io_spim1_inst_CLK    : out   std_logic;                                        -- hps_io_spim1_inst_CLK
			hps_0_io_hps_io_spim1_inst_MOSI   : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
			hps_0_io_hps_io_spim1_inst_MISO   : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
			hps_0_io_hps_io_spim1_inst_SS0    : out   std_logic;                                        -- hps_io_spim1_inst_SS0
			hps_0_io_hps_io_uart0_inst_RX     : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
			hps_0_io_hps_io_uart0_inst_TX     : out   std_logic;                                        -- hps_io_uart0_inst_TX
			hps_0_io_hps_io_i2c0_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
			hps_0_io_hps_io_i2c0_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
			hps_0_io_hps_io_i2c1_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
			hps_0_io_hps_io_i2c1_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
			hps_0_io_hps_io_gpio_inst_GPIO09  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
			hps_0_io_hps_io_gpio_inst_GPIO35  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
			hps_0_io_hps_io_gpio_inst_GPIO40  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
			hps_0_io_hps_io_gpio_inst_GPIO53  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
			hps_0_io_hps_io_gpio_inst_GPIO54  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
			hps_0_io_hps_io_gpio_inst_GPIO61  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO61
			reset_reset_n                     : in    std_logic                     := 'X';             -- reset_n
			vga_module_0_vga_signal_b         : out   std_logic_vector(7 downto 0);                     -- b
			vga_module_0_vga_signal_clk       : out   std_logic;                                        -- clk
			vga_module_0_vga_signal_g         : out   std_logic_vector(7 downto 0);                     -- g
			vga_module_0_vga_signal_hsync     : out   std_logic;                                        -- hsync
			vga_module_0_vga_signal_r         : out   std_logic_vector(7 downto 0);                     -- r
			vga_module_0_vga_signal_vsync     : out   std_logic   
                );
    end component system;

begin

    u0 : component system
        port map(
			clk_clk                           => FPGA_CLK1_50,
			reset_reset_n                     => KEY_N(0),
			hps_0_ddr_mem_a                   => HPS_DDR3_ADDR,
			hps_0_ddr_mem_ba                  => HPS_DDR3_BA,
			hps_0_ddr_mem_ck                  => HPS_DDR3_CK_P,
			hps_0_ddr_mem_ck_n                => HPS_DDR3_CK_N,
			hps_0_ddr_mem_cke                 => HPS_DDR3_CKE,
			hps_0_ddr_mem_cs_n                => HPS_DDR3_CS_N,
			hps_0_ddr_mem_ras_n               => HPS_DDR3_RAS_N,
			hps_0_ddr_mem_cas_n               => HPS_DDR3_CAS_N,
			hps_0_ddr_mem_we_n                => HPS_DDR3_WE_N,
			hps_0_ddr_mem_reset_n             => HPS_DDR3_RESET_N,
			hps_0_ddr_mem_dq                  => HPS_DDR3_DQ,
			hps_0_ddr_mem_dqs                 => HPS_DDR3_DQS_P,
			hps_0_ddr_mem_dqs_n               => HPS_DDR3_DQS_N,
			hps_0_ddr_mem_odt                 => HPS_DDR3_ODT,
			hps_0_ddr_mem_dm                  => HPS_DDR3_DM,
			hps_0_ddr_oct_rzqin               => HPS_DDR3_RZQ,
			hps_0_io_hps_io_emac1_inst_TX_CLK => HPS_ENET_GTX_CLK,
			hps_0_io_hps_io_emac1_inst_TX_CTL => HPS_ENET_TX_EN,
			hps_0_io_hps_io_emac1_inst_TXD0   => HPS_ENET_TX_DATA(0),
			hps_0_io_hps_io_emac1_inst_TXD1   => HPS_ENET_TX_DATA(1),
			hps_0_io_hps_io_emac1_inst_TXD2   => HPS_ENET_TX_DATA(2),
			hps_0_io_hps_io_emac1_inst_TXD3   => HPS_ENET_TX_DATA(3),
			hps_0_io_hps_io_emac1_inst_RX_CLK => HPS_ENET_RX_CLK,
			hps_0_io_hps_io_emac1_inst_RX_CTL => HPS_ENET_RX_DV,
			hps_0_io_hps_io_emac1_inst_RXD0   => HPS_ENET_RX_DATA(0),
			hps_0_io_hps_io_emac1_inst_RXD1   => HPS_ENET_RX_DATA(1),
			hps_0_io_hps_io_emac1_inst_RXD2   => HPS_ENET_RX_DATA(2),
			hps_0_io_hps_io_emac1_inst_RXD3   => HPS_ENET_RX_DATA(3),
			hps_0_io_hps_io_emac1_inst_MDIO   => HPS_ENET_MDIO,
			hps_0_io_hps_io_emac1_inst_MDC    => HPS_ENET_MDC,
			hps_0_io_hps_io_sdio_inst_CLK     => HPS_SD_CLK,
			hps_0_io_hps_io_sdio_inst_CMD     => HPS_SD_CMD,
			hps_0_io_hps_io_sdio_inst_D0      => HPS_SD_DATA(0),
			hps_0_io_hps_io_sdio_inst_D1      => HPS_SD_DATA(1),
			hps_0_io_hps_io_sdio_inst_D2      => HPS_SD_DATA(2),
			hps_0_io_hps_io_sdio_inst_D3      => HPS_SD_DATA(3),
			hps_0_io_hps_io_usb1_inst_CLK     => HPS_USB_CLKOUT,
			hps_0_io_hps_io_usb1_inst_STP     => HPS_USB_STP,
			hps_0_io_hps_io_usb1_inst_DIR     => HPS_USB_DIR,
			hps_0_io_hps_io_usb1_inst_NXT     => HPS_USB_NXT,
			hps_0_io_hps_io_usb1_inst_D0      => HPS_USB_DATA(0),
			hps_0_io_hps_io_usb1_inst_D1      => HPS_USB_DATA(1),
			hps_0_io_hps_io_usb1_inst_D2      => HPS_USB_DATA(2),
			hps_0_io_hps_io_usb1_inst_D3      => HPS_USB_DATA(3),
			hps_0_io_hps_io_usb1_inst_D4      => HPS_USB_DATA(4),
			hps_0_io_hps_io_usb1_inst_D5      => HPS_USB_DATA(5),
			hps_0_io_hps_io_usb1_inst_D6      => HPS_USB_DATA(6),
			hps_0_io_hps_io_usb1_inst_D7      => HPS_USB_DATA(7),
			hps_0_io_hps_io_spim1_inst_CLK    => HPS_SPIM_CLK,
			hps_0_io_hps_io_spim1_inst_MOSI   => HPS_SPIM_MOSI,
			hps_0_io_hps_io_spim1_inst_MISO   => HPS_SPIM_MISO,
			hps_0_io_hps_io_spim1_inst_SS0    => HPS_SPIM_SS,
			hps_0_io_hps_io_uart0_inst_RX     => HPS_UART_RX,
			hps_0_io_hps_io_uart0_inst_TX     => HPS_UART_TX,
			hps_0_io_hps_io_i2c0_inst_SDA     => HPS_I2C0_SDAT,
			hps_0_io_hps_io_i2c0_inst_SCL     => HPS_I2C0_SCLK,
			hps_0_io_hps_io_i2c1_inst_SDA     => HPS_I2C1_SDAT,
			hps_0_io_hps_io_i2c1_inst_SCL     => HPS_I2C1_SCLK,
			hps_0_io_hps_io_gpio_inst_GPIO09  => HPS_CONV_USB_N,
			hps_0_io_hps_io_gpio_inst_GPIO35  => HPS_ENET_INT_N,
			hps_0_io_hps_io_gpio_inst_GPIO40  => HPS_LTC_GPIO,
			hps_0_io_hps_io_gpio_inst_GPIO53  => HPS_LED,
			hps_0_io_hps_io_gpio_inst_GPIO54  => HPS_KEY_N,
			hps_0_io_hps_io_gpio_inst_GPIO61  => HPS_GSENSOR_INT,
			vga_module_0_vga_signal_b         => VGA_VIDEO_B,

			vga_module_0_vga_signal_clk       => VGA_VIDEO_CLK,
			vga_module_0_vga_signal_g         => VGA_VIDEO_G,
			vga_module_0_vga_signal_hsync     => VGA_VIDEO_HSYNC,
			vga_module_0_vga_signal_r         => VGA_VIDEO_R,
			vga_module_0_vga_signal_vsync     => VGA_VIDEO_VSYNC
        );

		  
		  LED <= std_logic_vector(to_unsigned(5, LED'length));
		  
end;



