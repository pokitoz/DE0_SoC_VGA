library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_module is
        port(

                -- 25 MHz pixel clock in
                pixel_clk_25MHz : in  std_logic;
                rst_n           : in  std_logic;
                
                vga_irq         : out std_logic;

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

begin

        p_pixel_value: process(pixel_clk_25MHz, rst_n) is
        begin
                if rst_n = '0' then
                        vga_r <= X"00";
                        vga_g <= X"00";
                        vga_b <= X"00";
                elsif rising_edge(pixel_clk_25MHz) then
                        if (enable = '1') then
                                vga_r <= "00010000";
                                vga_g <= "00011110";
                                vga_b <= "00010000";
                        else
                                vga_r <= X"00";
                                vga_g <= X"00";
                                vga_b <= X"00";
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
                        vga_irq   <= '0';
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
                        vga_irq  <= '1';
                else
                        vga_irq  <= '0';
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
