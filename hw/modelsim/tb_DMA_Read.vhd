library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_DMA_Read is
end tb_DMA_Read;

architecture RTL of tb_DMA_Read is

        constant DATA_SIZE      : integer := 32;
        constant ADDR_SIZE      : integer := 3;

        constant CLK_PERIOD      : time := 50 ns;
        constant CLK_HIGH_PERIOD : time := 25 ns;
        constant CLK_LOW_PERIOD  : time := 25 ns;

        signal clk   : std_logic := '0';
        signal reset_n  : std_logic := '0';

        signal sim_finished : boolean := false;

        constant REG_BUFFER_1_ADDR      : std_logic_vector(ADDR_SIZE-1 downto 0) := "000";        
        constant REG_BUFFER_2_ADDR      : std_logic_vector(ADDR_SIZE-1 downto 0) := "001";        
        constant REG_TRANSFER_SIZE      : std_logic_vector(ADDR_SIZE-1 downto 0) := "010";        
        constant REG_BUFFER_SELECT      : std_logic_vector(ADDR_SIZE-1 downto 0) := "011";        
        constant REG_CONFIGURATION      : std_logic_vector(ADDR_SIZE-1 downto 0) := "100";        
        constant REG_BUFFER_COLOR       : std_logic_vector(ADDR_SIZE-1 downto 0) := "101";        

        constant BUFFER_1_ADDR          : std_logic_vector(DATA_SIZE-1 downto 0) := X"01234560";
        constant BUFFER_2_ADDR          : std_logic_vector(DATA_SIZE-1 downto 0) := X"01234560";
        constant TRANSFER_SIZE          : std_logic_vector(DATA_SIZE-1 downto 0) := X"00000100";

        

        -- converts a std_logic_vector into a hex string.
        function hstr(slv : std_logic_vector) return string is
                variable hexlen  : integer;
                variable longslv : std_logic_vector(67 downto 0) := (others => '0');
                variable hex     : string(1 to 16);
                variable fourbit : std_logic_vector(3 downto 0);
        begin
                hexlen := (slv'left + 1) / 4;
                if (slv'left + 1) mod 4 /= 0 then
                        hexlen := hexlen + 1;
                end if;
                longslv(slv'left downto 0) := slv;
                for i in (hexlen - 1) downto 0 loop
                        fourbit := longslv(((i * 4) + 3) downto (i * 4));
                        case fourbit is
                                when "0000" => hex(hexlen - I) := '0';
                                when "0001" => hex(hexlen - I) := '1';
                                when "0010" => hex(hexlen - I) := '2';
                                when "0011" => hex(hexlen - I) := '3';
                                when "0100" => hex(hexlen - I) := '4';
                                when "0101" => hex(hexlen - I) := '5';
                                when "0110" => hex(hexlen - I) := '6';
                                when "0111" => hex(hexlen - I) := '7';
                                when "1000" => hex(hexlen - I) := '8';
                                when "1001" => hex(hexlen - I) := '9';
                                when "1010" => hex(hexlen - I) := 'A';
                                when "1011" => hex(hexlen - I) := 'B';
                                when "1100" => hex(hexlen - I) := 'C';
                                when "1101" => hex(hexlen - I) := 'D';
                                when "1110" => hex(hexlen - I) := 'E';
                                when "1111" => hex(hexlen - I) := 'F';
                                when "ZZZZ" => hex(hexlen - I) := 'z';
                                when "UUUU" => hex(hexlen - I) := 'u';
                                when "XXXX" => hex(hexlen - I) := 'x';
                                when others => hex(hexlen - I) := '?';
                        end case;
                end loop;
                return hex(1 to hexlen);
        end hstr;

        procedure write_avalon( constant addr            : in  std_logic_vector(ADDR_SIZE-1 downto 0);
                                constant value           : in  std_logic_vector(DATA_SIZE-1 downto 0);
                                signal addr_controller   : out std_logic_vector(ADDR_SIZE-1 downto 0);
                                signal read_controller   : out std_logic;
                                signal write_controller  : out std_logic;
                                signal wrdata_controller : out std_logic_vector(DATA_SIZE-1 downto 0)) is
        begin
                addr_controller   <= addr;
                read_controller   <= '0';
                write_controller  <= '1';
                wrdata_controller <= value;

                wait until rising_edge(clk);
                wait for 1 * CLK_PERIOD;

                write_controller <= '0';

        end procedure write_avalon;

  
        procedure read_avalon(  constant addr           : in  std_logic_vector(ADDR_SIZE-1 downto 0);
                                signal addr_controller  : out std_logic_vector(ADDR_SIZE-1 downto 0);
                                signal read_controller  : out std_logic;
                                signal write_controller : out std_logic) is
        begin
                addr_controller  <= addr;
                read_controller  <= '1';
                write_controller <= '0';

                wait until rising_edge(clk);
                wait for 1 * CLK_PERIOD;

        end procedure read_avalon;

        
        signal asts_ready       : std_logic;
        signal asts_valid       : std_logic;
        signal asts_data        : std_logic_vector(31 downto 0);

        signal am_addr          : std_logic_vector(31 downto 0);
        signal am_byteenable    : std_logic_vector(3 downto 0);
        signal am_read          : std_logic;
        signal am_readdata      : std_logic_vector(31 downto 0);
        signal am_waitrequest   : std_logic;

        signal wrdata_dma       : std_logic_vector(31 downto 0);
        signal write_dma        : std_logic;
	signal addr_dma         : std_logic_vector(2 downto 0);        
	signal read_dma         : std_logic;
        signal rddata_dma       : std_logic_vector(31 downto 0);
	

        component DMA_Read is
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
                am_waitrequest     : in  std_logic;

                system_clk         : in  std_logic;
                rst_n              : in  std_logic

        );
        end component DMA_Read;


begin

        DMA_R1: DMA_Read port map(

                -- FIFO signals source
                asts_ready           => asts_ready,
                asts_data            => asts_data,
                asts_valid           => asts_valid,

                -- Avalon Slave signals
                as_wrdata          => wrdata_dma,
                as_write           => write_dma,
                as_addr            => addr_dma,
                as_read            => read_dma,
                as_rddata          => rddata_dma,

                -- Avalon 32-bit Master Interface (Read DMA)
                am_addr            => am_addr,
                am_byteenable      => am_byteenable,
                am_read            => am_read,
                am_readdata        => am_readdata,
                am_waitrequest     => am_waitrequest,

                system_clk         => clk,
                rst_n              => reset_n

        );

        clk_generation: process
        begin
                if not sim_finished then
                        clk <= '1';
                        wait for CLK_HIGH_PERIOD;
                        clk <= '0';
                        wait for CLK_LOW_PERIOD;
                else
                        wait;
                end if;
        end process;

        sim: process
        begin

                -- ---------------------------------------------------------------------
                -- reset_n  system --------------------------------------------------------
                -- ---------------------------------------------------------------------
                report "reset_n ";
                reset_n  <= '0';
                wait until rising_edge(clk);
                wait for 0.1 * CLK_PERIOD;
                reset_n  <= '1';
                wait until rising_edge(clk);
                report "reset_n  is done";

                -- ---------------------------------------------------------------------
                -- Write        --------------------------------------------------------
                -- ---------------------------------------------------------------------
                report "Writing into registers";
                report "Init Reg" & hstr(REG_BUFFER_1_ADDR) & "to " & hstr(BUFFER_1_ADDR);
                write_avalon(REG_BUFFER_1_ADDR, BUFFER_1_ADDR, addr_dma, read_dma, write_dma, wrdata_dma);
                report "Init Reg" & hstr(REG_BUFFER_2_ADDR) & "to " & hstr(BUFFER_2_ADDR);
                write_avalon(REG_BUFFER_2_ADDR, BUFFER_1_ADDR, addr_dma, read_dma, write_dma, wrdata_dma);
                report "Init Reg" & hstr(REG_TRANSFER_SIZE) & "to " & hstr(TRANSFER_SIZE);
                write_avalon(REG_TRANSFER_SIZE, TRANSFER_SIZE, addr_dma, read_dma, write_dma, wrdata_dma);
                wait until rising_edge(clk);

                -- ---------------------------------------------------------------------
                -- Read         --------------------------------------------------------
                -- ---------------------------------------------------------------------
                report "Reading into registers";
                read_avalon(REG_BUFFER_1_ADDR, addr_dma, read_dma, write_dma);
                assert (rddata_dma = BUFFER_1_ADDR) report "BUFFER_1_ADDR is not correct" severity error;

                sim_finished <= true;
                wait;
        end process;

end architecture RTL;
