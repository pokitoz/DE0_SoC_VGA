library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DMA_Read is
	port(

		-- FIFO signals source
		asts_ready           : in  std_logic;
		asts_data            : out std_logic_vector(31 downto 0);
		asts_valid           : out std_logic;

                -- Avalon Slave signals
                as_wrdata          : in  std_logic_vector(31 downto 0);
                as_write           : in  std_logic;
                as_addr            : in  std_logic_vector(2 downto 0);
                as_read            : in  std_logic;
                as_rddata          : out std_logic_vector(31 downto 0);

		-- Avalon 32-bit Master Interface (Read DMA)
		am_addr            : out std_logic_vector(31 downto 0);
		am_byteenable      : out std_logic_vector(3 downto 0);
		am_read            : out std_logic;
		am_readdata        : in  std_logic_vector(31 downto 0);
                --am_readdatavalid   : in  std_logic;
        	--am_burstcount      : out std_logic_vector(2 downto 0);		
                am_waitrequest     : in  std_logic;

		system_clk         : in  std_logic;
		rst_n              : in  std_logic

	);
end entity DMA_Read;

architecture rtl of DMA_Read is
        constant default_color      : std_logic_vector(31 downto 0) := X"00ff0f00";    

        signal buffer1_base_address : unsigned(31 downto 0);
        signal buffer2_base_address : unsigned(31 downto 0);
        signal buffer_selection     : std_logic;

        signal transfer_length      : unsigned(31 downto 0);
        
        signal dma_idle             : std_logic;        
        signal dma_start            : std_logic;
        signal dma_continue         : std_logic;

        signal dma_auto_flip        : std_logic;
        signal dma_use_constant     : std_logic;

        type states is (IDLE, READ_REQUEST, READ_DATA);
	signal state_reg, state_next         : states;
	signal counter_reg, counter_next     : integer;
        signal am_data_reg, am_data_next     : std_logic_vector(31 downto 0);
begin 


        as_read_process: process(system_clk, rst_n) is
        begin
                if rst_n = '0' then
                        as_rddata <= (others => '0');
                elsif rising_edge(system_clk) then
                        as_rddata <= (others => '0');
                        if(as_read = '1') then
                                case as_addr is
                                        when "000"  => 
                                                as_rddata               <= std_logic_vector(buffer1_base_address);
                                        when "001"  => 
                                                as_rddata               <= std_logic_vector(buffer2_base_address);
                                        when "010"  => 
                                                as_rddata(15 downto 0)  <= std_logic_vector(transfer_length);
                                        when "011"  => 
                                                as_rddata(5)            <= dma_use_constant;
                                                as_rddata(4)            <= dma_continue;
                                                as_rddata(3)            <= dma_auto_flip;
                                                as_rddata(2)            <= dma_start;
                                                as_rddata(1)            <= buffer_selection;
                                                as_rddata(0)            <= dma_idle;
                                        when others => null;
                                end case;
                        end if;
                end if;

        end process;
       
       
        as_write_process: process(system_clk, rst_n) is
        begin
                if rst_n = '0' then
                        buffer1_base_address <= (others => '0');
                        buffer2_base_address <= (others => '0');
                        buffer_selection <= '0';
                        transfer_length <= (others => '0');
                        dma_start <= '0';
                        dma_auto_flip <= '0';
                        dma_continue <= '0';
                        dma_use_constant <= '0';
                elsif rising_edge(system_clk) then
                        if(as_write = '1') then
                                case as_addr is
                                        when "000"  => 
                                                buffer1_base_address    <= unsigned(as_wrdata);
                                        when "001"  =>
                                                buffer2_base_address    <= unsigned(as_wrdata);             
                                        when "010"  => 
                                                transfer_length         <= unsigned(as_wrdata(15 downto 0));
                                        when "011"  => 
                                                buffer_selection        <= as_wrdata(0);
                                        when "100"  =>
                                                dma_start               <= as_wrdata(0);
                                                dma_continue            <= as_wrdata(1);
                                                dma_auto_flip           <= as_wrdata(2);
                                                dma_use_constant        <= as_wrdata(3);
                                        when others => null;
                                end case;
                        end if;
                end if;
        end process;


        fsm_dma_process : process(state_reg, counter_reg, dma_start, asts_ready, 
                                        buffer1_base_address, buffer2_base_address, am_data_reg,
                                        am_readdata, am_waitrequest, transfer_length, dma_use_constant) is
                variable new_address : unsigned(31 downto 0);
        begin
		state_next   <= state_reg;
		counter_next <= counter_reg;
                am_data_next <= (others => '1');
		
                am_addr    <= (others => '0');
		am_read       <= '0';
		am_byteenable <= "1111";
              
                asts_valid   <= '0';
                asts_data    <= (others => '1');

		case state_reg is
			when IDLE =>
				if (dma_start = '1') then
					state_next <= READ_REQUEST;
				end if;

			when READ_REQUEST =>
				if (asts_ready = '1') then
                                        -- Increment the address
                                        if(buffer_selection = '0') then
                                                new_address    := buffer1_base_address + 4*counter_reg;
                                        else
                                                new_address    := buffer2_base_address + 4*counter_reg;
                                        end if;

					am_addr        <= std_logic_vector(new_address);
					am_read        <= '1';
                                        if (dma_use_constant = '0') then
					        am_data_next    <= am_readdata;
                                        else
                                                am_data_next    <= std_logic_vector(to_unsigned(counter_reg, am_data_next'length));
                                        end if;

					if (am_waitrequest = '0' or dma_use_constant = '1') then
						state_next <= READ_DATA;
					end if;
				end if;
			when READ_DATA =>
				asts_valid   <= '1';
				asts_data    <= am_data_reg;

				if (counter_reg < transfer_length) then
					state_next   <= READ_REQUEST;
					counter_next <= counter_reg + 1;
				else
                                        if(dma_continue = '0') then
					        state_next   <= IDLE;
                                        else
                                                state_next   <= READ_REQUEST;
                                        end if;
					counter_next <= 0;
				end if;
		end case;
	end process fsm_dma_process;

	fsm_register_process : process(system_clk, rst_n) is
	begin
		if rst_n = '0' then
			state_reg       <= IDLE;
			counter_reg     <= 0;
                        am_data_reg <= (others => '0');
		elsif rising_edge(system_clk) then
			state_reg     <= state_next;
			counter_reg   <= counter_next;
			am_data_reg   <= am_data_next;
		end if;
	end process fsm_register_process;



end architecture rtl;

