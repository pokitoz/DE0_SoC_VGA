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
                vga_irq         : out std_logic;

                -- Avalon Stream Source Signals
                ss_data         : in std_logic_vector(23 downto 0);
                ss_ready        : out std_logic;
                ss_valid        : in std_logic;

                -- Avalon Slave signals
                as_wrdata       : in std_logic_vector(31 downto 0);
                as_write        : in std_logic;
                as_addr         : in std_logic_vector(2 downto 0);
                as_read         : in std_logic;
                as_rddata       : out std_logic_vector(31 downto 0);

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

-------------------------------------------------
-- Constants
-------------------------------------------------
constant WHOLE_FRAME_DEFAULT    : integer := 525;
constant VISIBLE_AREA_V_DEFAULT : integer := 480;
constant FRONT_PORCH_V_DEFAULT  : integer := 10;
constant SYNC_PULSE_V_DEFAULT   : integer := 2;
constant BACK_PORCH_V_DEFAULT   : integer := 33;

constant WHOLE_LINE_DEFAULT     : integer := 800;
constant VISIBLE_AREA_H_DEFAULT : integer := 640;
constant FRONT_PORCH_H_DEFAULT  : integer := 16;
constant SYNC_PULSE_H_DEFAULT   : integer := 96;
constant BACK_PORCH_H_DEFAULT   : integer := 48;

constant MIN_PIXEL_VALUE   : std_logic_vector(7 downto 0) := X"00";
constant MAX_PIXEL_VALUE   : std_logic_vector(7 downto 0) := X"FF";

-------------------------------------------------
-- Signals
-------------------------------------------------
signal WHOLE_FRAME    : integer := 525;
signal VISIBLE_AREA_V : integer := 480;
signal FRONT_PORCH_V  : integer := 10;
signal SYNC_PULSE_V   : integer := 2;
signal BACK_PORCH_V   : integer := 33;

signal WHOLE_LINE     : integer := 800;
signal VISIBLE_AREA_H : integer := 640;
signal FRONT_PORCH_H  : integer := 16;
signal SYNC_PULSE_H   : integer := 96;
signal BACK_PORCH_H   : integer := 48;

-- Current position of (h)orizontal cursor
signal h_pos : integer;
-- Current position of (v)ertical cursor
signal v_pos : integer;

-- Set when it is time to display pixels
signal en_display   : std_logic;
-- Set when h_pos is in the visible area
signal is_h_visible : std_logic;
-- Set when v_pos is in the visible area
signal is_v_visible : std_logic;

-- Store the value Red, Green, Blue of the pixels
signal vga_red_reg   : std_logic_vector(7 downto 0);
signal vga_green_reg : std_logic_vector(7 downto 0);
signal vga_blue_reg  : std_logic_vector(7 downto 0);

-- Set the incoming pixel source 
signal source_fifo   : std_logic;

-- IRQ when end of line and end of frame
signal vga_h_irq     : std_logic;
signal vga_v_irq     : std_logic;
-- Disable IRQ for this module
signal disable_irq   : std_logic;

begin
       
       
        as_write_process: process(system_clk, rst_n) is
                variable visible_area_int : integer;
                variable front_porch_int  : integer;
                variable sync_pulse_int   : integer;
                variable back_porch_int   : integer;
        begin
                if rst_n = '0' then
                        vga_red_reg    <= MIN_PIXEL_VALUE;
                        vga_green_reg  <= MAX_PIXEL_VALUE;
                        vga_blue_reg   <= MIN_PIXEL_VALUE;

                        source_fifo    <= '0';
                        disable_irq    <= '0';

                        WHOLE_FRAME    <= WHOLE_FRAME_DEFAULT;
                        VISIBLE_AREA_V <= VISIBLE_AREA_V_DEFAULT;
                        FRONT_PORCH_V  <= FRONT_PORCH_V_DEFAULT;
                        SYNC_PULSE_V   <= SYNC_PULSE_V_DEFAULT;
                        BACK_PORCH_V   <= BACK_PORCH_V_DEFAULT;

                        WHOLE_LINE     <= WHOLE_LINE_DEFAULT;
                        VISIBLE_AREA_H <= VISIBLE_AREA_H_DEFAULT;
                        FRONT_PORCH_H  <= FRONT_PORCH_H_DEFAULT;
                        SYNC_PULSE_H   <= SYNC_PULSE_H_DEFAULT;
                        BACK_PORCH_H   <= BACK_PORCH_H_DEFAULT;
                        
                elsif rising_edge(system_clk) then
                        if(as_write = '1') then

                                visible_area_int := to_integer(unsigned(as_wrdata(15 downto  0)));

                                sync_pulse_int   := to_integer(unsigned(as_wrdata(15 downto  0)));

                                front_porch_int  := to_integer(unsigned(as_wrdata(15 downto  0)));
                                back_porch_int   := to_integer(unsigned(as_wrdata(31 downto 16)));

                                case as_addr is
                                        when "000" => 
                                                vga_red_reg    <= as_wrdata(23 downto 16);
                                                vga_green_reg  <= as_wrdata(15 downto  8);
                                                vga_blue_reg   <= as_wrdata( 7 downto  0);
                                        when "001" =>
                                                source_fifo    <= as_wrdata(0);
                                                disable_irq    <= as_wrdata(1);
                                        when "010" =>
                                                FRONT_PORCH_V  <= front_porch_int;
                                                BACK_PORCH_V   <= back_porch_int;
                                        when "011" => 
                                                FRONT_PORCH_H  <= front_porch_int;
                                                BACK_PORCH_H   <= back_porch_int;
                                        when "100" =>
                                                VISIBLE_AREA_V <= visible_area_int;
                                        when "101" =>
                                                VISIBLE_AREA_H <= visible_area_int;
                                        when "110" =>
                                                SYNC_PULSE_V   <= sync_pulse_int;
                                        when "111" =>
                                                SYNC_PULSE_H   <= sync_pulse_int;
                                        when others =>
                                                null;
                                end case;
                        end if;
                end if;

        end process;

     

        p_pixel_value: process(pixel_clk_25MHz, rst_n) is
        begin
                if rst_n = '0' then
                        vga_r <= MAX_PIXEL_VALUE;
                        vga_g <= MIN_PIXEL_VALUE;
                        vga_b <= MIN_PIXEL_VALUE;
                elsif rising_edge(pixel_clk_25MHz) then
                        if (en_display = '1') then
                                if(source_fifo = '1') then
                                        vga_r <= ss_data(23 downto 16);
                                        vga_g <= ss_data(15 downto 8);
                                        vga_b <= ss_data(7 downto 0);
                                else
                                        vga_r <= vga_red_reg;
                                        vga_g <= vga_green_reg;
                                        vga_b <= vga_blue_reg;
                                end if;
                        else
                                vga_r <= MAX_PIXEL_VALUE;
                                vga_g <= MIN_PIXEL_VALUE;
                                vga_b <= MIN_PIXEL_VALUE;
                        end if;
                end if;
        end process;



        read_new_data: process(pixel_clk_25MHz, rst_n) is
        begin
                if rst_n = '0' then
                        ss_ready <= '0';
                elsif rising_edge(pixel_clk_25MHz) then
	                  
                        ss_ready <= '1';
                        -- If v_pos is in the visible area
                        if(v_pos < VISIBLE_AREA_V) then
                                -- If h_pos is in the visible area
                                if(h_pos < VISIBLE_AREA_H) then
                                        -- Set that new pixels can come
                                        ss_ready <= '1';
                                -- If h_pos is ready to start a new line
                                elsif  (h_pos = WHOLE_LINE-1) then
                                        ss_ready <= '1';
                                end if;
                        end if;
                end if;
        end process;


        -- Indicate when v and h are in the visible area
        p_v_h_video: process(h_pos, v_pos)
        begin
                is_v_visible <= '1';
                is_h_visible <= '1';

                -- If h_pos is outside the visible area
                if (h_pos >= VISIBLE_AREA_H) then
                        is_h_visible <= '0';
                end if;

                -- If v_pos is outside the visible area
                if (v_pos >= VISIBLE_AREA_V) then
                        is_v_visible <= '0';
                end if;
        end process;


        -- Increase h_pos and v_pos
        process(pixel_clk_25MHz, rst_n)             
        begin
                if (rst_n = '0') then
                        v_pos       <=  0 ;
                        h_pos       <=  0 ;
                elsif (rising_edge(pixel_clk_25MHz)) then
                        -- Each clock cycle increases h_pos.
                        -- if h_pos is at the end of the line increase v_pos
                        -- Restart h_pos when end of line
                        if (h_pos < WHOLE_LINE-1) then
                                h_pos <= h_pos + 1;
                        else
                                h_pos <= 0;
                                -- Restart v_pos when end of frame
                                if (v_pos < WHOLE_FRAME-1) then
                                        v_pos <= v_pos + 1;
                                else
                                        v_pos <= 0;
                                end if;
                        end if;
                end if;

        end process;


        -- Generate H and V sync        
        process(h_pos, v_pos)
                variable h_sync_offset : integer := 0;
                variable v_sync_offset : integer := 0;                
        begin
                
                h_sync_offset := VISIBLE_AREA_H+FRONT_PORCH_H;

                ------ Generate HSYNC Sync pulse
                if (h_sync_offset <= h_pos and h_pos < h_sync_offset+SYNC_PULSE_H) then
                        vga_hsync <= '0';
                else
                        vga_hsync <= '1';
                end if;


                v_sync_offset := VISIBLE_AREA_V+FRONT_PORCH_V;

                ------ Generate VSYNC Sync pulse
                if (v_sync_offset <= v_pos and v_pos < v_sync_offset+SYNC_PULSE_V) then
                        vga_vsync <= '0';
                else
                        vga_vsync <= '1';
                end if;

        end process;

        -- Generate H and V irq        
        process(h_pos, v_pos, vga_v_irq, vga_h_irq, disable_irq)   
        begin
                vga_v_irq  <= '0';
                if (h_pos = VISIBLE_AREA_H) then
                        vga_h_irq  <= '1';
                else
                        vga_h_irq  <= '0';
                end if;

                vga_irq <= (vga_h_irq or vga_v_irq) and (not disable_irq);
        end process;


        process(is_h_visible, is_v_visible)
        begin
                if ((is_h_visible = '1' and is_v_visible = '1')) then --or (h_pos=799 and v_pos=524)) then
                        en_display  <= '1';
                else
                        en_display  <= '0';
                end if;
        end process;
        
        vga_clk <= pixel_clk_25MHz;

end rtl;
