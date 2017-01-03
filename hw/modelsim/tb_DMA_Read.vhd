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
        signal reset : std_logic := '0';

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

        signal addr_dma   : std_logic_vector(2 downto 0);
        signal read_dma   : std_logic;
        signal write_dma  : std_logic;
        signal rddata_dma : std_logic_vector(31 downto 0);
        signal wrdata_dma : std_logic_vector(31 downto 0);

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

    
begin

        clk_generation : process
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

        sim : process
        begin

                -- ---------------------------------------------------------------------
                -- reset system --------------------------------------------------------
                -- ---------------------------------------------------------------------
                report "RESET";
                reset <= '1';
                wait until rising_edge(clk);
                wait for 0.1 * CLK_PERIOD;
                reset <= '0';
                wait until rising_edge(clk);
                report "RESET is done";

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
                assert read_dma = BUFFER_1_ADDR report "BUFFER_1_ADDR is not correct" severity error;

                sim_finished <= true;
                wait;
        end process;

end architecture RTL;
