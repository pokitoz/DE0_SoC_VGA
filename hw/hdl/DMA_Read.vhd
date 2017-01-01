library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DMA_Read is
	port(

		-- FIFO signals source
		as_ready           : in  std_logic;
		as_data            : out std_logic_vector(31 downto 0);
		as_valid           : out std_logic;

                -- Avalon Slave signals
                as_wrdata          : in  std_logic_vector(31 downto 0);
                as_write           : in  std_logic;
                as_addr            : in  std_logic_vector(1 downto 0);
                as_read            : in  std_logic;
                as_rddata          : out std_logic_vector(31 downto 0);

		-- Avalon 32-bit Master Interface (Read DMA)
		am_addr            : out std_logic_vector(31 downto 0);
		am_byteenable      : out std_logic_vector(3 downto 0);
		am_read            : out std_logic;
		am_readdata        : in  std_logic_vector(31 downto 0);
                am_readdatavalid   : in  std_logic;
        	am_burstcount      : out std_logic_vector(2 downto 0);		
                am_waitrequest     : in  std_logic;

		system_clk         : in  std_logic;
		rst_n              : in  std_logic

	);
end entity DMA_Read;

architecture rtl of DMA_Read is
        signal buffer1_address : std_logic_vector(31 downto 0);
        signal buffer2_address : std_logic_vector(31 downto 0);
        signal buffer_selection: std_logic;

        signal transfer_length : std_logic_vector(31 downto 0);
        
        signal dma_idle        : std_logic;        

begin


        as_read_process: process(system_clk, rst_n) is
        begin
                if rst_n = '0' then
                        as_rddata <= (others => '0');
                elsif rising_edge(system_clk) then
                        as_rddata <= (others => '0');
                        if(as_read = '1') then
                                case as_addr is
                                        when "00"  => 
                                                as_rddata <= buffer1_address;
                                        when "01"  => 
                                                as_rddata <= buffer2_address;
                                        when "10"  => 
                                                as_rddata(15 downto 0) <= transfer_length;
                                        when "11"  => 
                                                as_rddata(1) <= buffer_selection;
                                                as_rddata(0) <= dma_idle;
                                        when others => null;
                                end case;
                        end if;
                end if;

        end process;
       
       
        as_write_process: process(system_clk, rst_n) is
        begin
                if rst_n = '0' then
                        buffer1_address <= (others => '0');
                        buffer2_address <= (others => '0');
                        buffer_selection <= '0';
                        transfer_length <= (others => '0');

                elsif rising_edge(system_clk) then
                        if(as_write = '1') then
                                case as_addr is
                                        when "00"  => 
                                                buffer1_address  <= as_wrdata;
                                        when "01"  =>
                                                buffer2_address  <= as_wrdata;             
                                        when "10"  => 
                                                transfer_length  <= as_wrdata(15 downto 0);
                                        when "11"  => 
                                                buffer_selection <= as_wrdata(0);
                                        when others => null;
                                end case;
                        end if;
                end if;
        end process;


end architecture rtl;

