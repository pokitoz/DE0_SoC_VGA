library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_module is
        port(

                system_clk      : in  std_logic;                
                rst_n           : in  std_logic;

                -- 25 MHz pixel clock in
                pixel_clk_25MHz : in  std_logic;
                
                -- horizontal and vertical synchro
                vga_h_irq       : out std_logic;
                vga_v_irq       : out std_logic;

                -- Avalon Stream Source Signals
                ss_data         : in std_logic_vector(23 downto 0);
                ss_ready        : out std_logic;
                ss_valid        : in std_logic;

                -- Avalon Slave signals
                as_wrdata       : in std_logic_vector(31 downto 0);
                as_write        : in std_logic;
                as_addr         : in std_logic_vector(2 downto 0);
                
                -- Output to VGA board
                vga_r           : out std_logic_vector(7 downto 0);
                vga_g           : out std_logic_vector(7 downto 0);
                vga_b           : out std_logic_vector(7 downto 0);
                vga_clk         : out std_logic;
                vga_vsync       : out std_logic;
                vga_hsync       : out std_logic

        );
end entity vga_module;

architecture rtl of vga_module is

constant RESOLUTION_ROW : integer := 480;
constant RESOLUTION_COL : integer := 640;

signal h_pos : integer;
signal v_pos : integer;

signal enable : std_logic;
signal videoh : std_logic;
signal videov : std_logic;

signal vga_red_reg   : std_logic_vector(7 downto 0);
signal vga_green_reg : std_logic_vector(7 downto 0);
signal vga_blue_reg  : std_logic_vector(7 downto 0);

begin
        
        
        as_write_process: process(system_clk, rst_n) is
        begin
                if rst_n = '0' then
                        vga_red_reg   <= X"00";
                        vga_green_reg <= X"00";
                        vga_blue_reg  <= X"00";
                elsif rising_edge(system_clk) then
                        if(as_write = '1') then
                                case as_addr is
                                        when "000" => 
                                                vga_red_reg   <= as_wrdata(23 downto 16);
                                                vga_green_reg <= as_wrdata(15 downto 8);
                                                vga_blue_reg  <= as_wrdata(7 downto 0);
                                        when "001" => 
                                                null;
                                        when "010" => 
                                                null;
                                        when "011" => 
                                                null;
                                        when others =>
                                                null;
                                end case;
                        end if;
                end if;

        end process;

     

        p_pixel_value: process(pixel_clk_25MHz, rst_n) is
        begin
                if rst_n = '0' then
                        vga_r <= X"00";
                        vga_g <= X"00";
                        vga_b <= X"00";
                elsif rising_edge(pixel_clk_25MHz) then
                        if (enable = '1') then
                                vga_r <= ss_data(24 downto 16);
                                vga_g <= ss_data(15 downto 8);
                                vga_b <= ss_data(7 downto 0);
                        else
                                vga_r <= vga_red_reg;
                                vga_g <= vga_green_reg;
                                vga_b <= vga_blue_reg;
                        end if;
                end if;
        end process;



        read_new_data: process(pixel_clk_25MHz, rst_n) is
        begin
                if rst_n = '0' then
                        ss_ready <= '0';
                elsif rising_edge(pixel_clk_25MHz) then
	                  
                        ss_ready <= '0';
                        if(v_pos < 480) then
                                if(h_pos < 639 or h_pos = 799) then
                                        ss_ready <= '1';
                                end if;
                        end if;
			
                        if(v_pos = 524 and h_pos >= 798) then
                                ss_ready <= '1';
                        end if;
                end if;
        end process;

        p_v_h_video: process(h_pos, v_pos)
        begin
                videov <= '1';
                videoh <= '1';

                if (h_pos >= RESOLUTION_COL) then
                        videoh <= '0';
                end if;
                
                if (v_pos >= RESOLUTION_ROW) then
                        videov <= '0';
                end if;
        end process;

        process(pixel_clk_25MHz, rst_n)
        begin
                if (rst_n = '0') then
                        v_pos  <= 0;
                        h_pos  <= 0;
                        vga_hsync <= '0';
                        vga_vsync <= '0';
                        vga_v_irq   <= '0';     
                        vga_h_irq <= '0';
                elsif (rising_edge(pixel_clk_25MHz)) then
                        -- Each clock cycle increases h_pos.
                        -- if hpos is at the end of the line increase vpos
                        if (h_pos < 799) then
                                h_pos <= h_pos + 1;
                        else
                        -- Restart h_pos when end of line
                                h_pos <= 0;
                        if (v_pos < 524) then
                                v_pos <= v_pos + 1;
                        else
                                v_pos <= 0;
                        end if;
                end if;

                ------ Generate HSYNC
                if (659 <= h_pos and h_pos <= 755) then
                        vga_hsync <= '0';
                else
                        vga_hsync <= '1';
                end if;

                ------ Generate VSYNC
                if (493 <= v_pos and v_pos <= 494) then
                        vga_vsync <= '0';
                else
                        vga_vsync <= '1';
                end if;

                ------ VSYNC irq
                if (481 <= v_pos and v_pos <= 482) then
                        vga_v_irq  <= '1';
                else
                        vga_v_irq  <= '0';
                end if;

                end if;
        end process;

        process(videoh, videov, h_pos, v_pos)
        begin
                if ((videoh = '1' and videov = '1') or (h_pos=799 and  v_pos=524)) then
                        enable  <= '1';
                else
                        enable  <= '0';
                end if;
        end process;
        
        vga_clk <= pixel_clk_25MHz;

end rtl;
