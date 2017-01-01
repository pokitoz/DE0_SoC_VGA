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
		am_address         : out std_logic_vector(31 downto 0);
		am_byteenable      : out std_logic_vector(3 downto 0);
		am_read            : out std_logic;
		am_readdata        : in  std_logic_vector(31 downto 0);
                am_readdatavalid   : in  std_logic;
        	Am_burstcount      : out std_logic_vector(2 downto 0);		
                am_waitrequest     : in  std_logic;

		system_clk         : in  std_logic;
		rst_n              : in  std_logic

	);
end entity DMA_Read;

architecture rtl of DMA_Read is

begin


        as_read_process: process(system_clk, rst_n) is
        begin
                if rst_n = '0' then
                elsif rising_edge(system_clk) then
                        if(as_read = '1') then
                                case as_addr is
                                        when "000"  => null;
                                        when "001"  => null;
                                        when "010"  => null;
                                        when "011"  => null;
                                        when "100"  => null;
                                        when "101"  => null;
                                        when "110"  => null;
                                        when "111"  => null;
                                        when others => null;
                                end case;
                        end if;
                end if;

        end process;
       
       
        as_write_process: process(system_clk, rst_n) is
        begin
                if rst_n = '0' then
                elsif rising_edge(system_clk) then
                        if(as_write = '1') then
                                case as_addr is
                                        when "000"  => 
                                        when "001"  =>
                                        when "010"  =>
                                        when "011"  => 
                                        when "100"  =>
                                        when "101"  =>
                                        when "110"  =>
                                        when "111"  =>
                                        when others =>
                                                null;
                                end case;
                        end if;
                end if;

        end process;


end architecture rtl;

