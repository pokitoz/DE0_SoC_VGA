library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_module is
    port(

        -- 25 MHz pixel clock in
        pixel_clk_25MHz          : in  std_logic;
        rst_n              : in  std_logic;

        -- Output to VGA board
        vga_r                 : out std_logic_vector(7 downto 0);
        vga_g                 : out std_logic_vector(7 downto 0);
        vga_b                 : out std_logic_vector(7 downto 0);
        vga_clk               : out std_logic;
        vga_vsync             : out std_logic;
        vga_hsync             : out std_logic

    );
end entity vga_module;

architecture rtl of vga_module is
 

end rtl;
