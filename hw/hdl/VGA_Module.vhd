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
signal whole_frame_reg    : integer := 525;
signal visible_area_v_reg : integer := 480;
signal front_porch_v_reg  : integer := 10;
signal sync_pulse_v_reg   : integer := 2;
signal back_porch_v_reg   : integer := 33;

signal whole_line_reg     : integer := 800;
signal visible_area_h_reg : integer := 640;
signal front_porch_h_reg  : integer := 16;
signal sync_pulse_h_reg   : integer := 96;
signal back_porch_h_reg   : integer := 48;

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

signal vga_irq_en    : std_logic;
signal vga_irq_reset : std_logic;

begin

        as_read_process: process(system_clk, rst_n) is

        begin
                if rst_n = '0' then
                        vga_irq_reset <= '0';
                elsif rising_edge(system_clk) then
                        if(as_read = '1') then
                                vga_irq_reset <= '0';
                                case as_addr is
                                        when "000"  => 
                                                vga_irq_reset <= '1';
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
                variable var_int_15_to_0  : integer;
                variable var_int_31_to_16 : integer;
        begin
                if rst_n = '0' then
                        vga_red_reg    <= MIN_PIXEL_VALUE;
                        vga_green_reg  <= MAX_PIXEL_VALUE;
                        vga_blue_reg   <= MIN_PIXEL_VALUE;

                        source_fifo    <= '0';
                        disable_irq    <= '0';

                        WHOLE_FRAME_reg    <= WHOLE_FRAME_DEFAULT;
                        visible_area_v_reg <= VISIBLE_AREA_V_DEFAULT;
                        front_porch_v_reg  <= FRONT_PORCH_V_DEFAULT;
                        sync_pulse_v_reg   <= SYNC_PULSE_V_DEFAULT;
                        back_porch_v_reg   <= BACK_PORCH_V_DEFAULT;

                        whole_line_reg     <= WHOLE_LINE_DEFAULT;
                        visible_area_h_reg <= VISIBLE_AREA_H_DEFAULT;
                        front_porch_h_reg  <= FRONT_PORCH_H_DEFAULT;
                        sync_pulse_h_reg   <= SYNC_PULSE_H_DEFAULT;
                        back_porch_h_reg   <= BACK_PORCH_H_DEFAULT;
                        
                elsif rising_edge(system_clk) then
                        if(as_write = '1') then

                                var_int_15_to_0  := to_integer(unsigned(as_wrdata(15 downto  0)));
                                var_int_31_to_16 := to_integer(unsigned(as_wrdata(31 downto 16)));
                               
                                case as_addr is
                                        when "000" => 
                                                vga_red_reg    <= as_wrdata(23 downto 16);
                                                vga_green_reg  <= as_wrdata(15 downto  8);
                                                vga_blue_reg   <= as_wrdata( 7 downto  0);
                                        when "001" =>
                                                source_fifo    <= as_wrdata(0);
                                                disable_irq    <= as_wrdata(1);
                                        when "010" =>
                                                front_porch_v_reg  <= var_int_15_to_0;
                                                back_porch_v_reg   <= var_int_31_to_16;
                                        when "011" => 
                                                front_porch_h_reg  <= var_int_15_to_0;
                                                back_porch_h_reg   <= var_int_31_to_16;
                                        when "100" =>
                                                visible_area_v_reg  <= var_int_15_to_0;
                                                sync_pulse_v_reg    <= var_int_31_to_16;
                                        when "101" =>
                                                visible_area_h_reg  <= var_int_15_to_0;
                                                sync_pulse_h_reg    <= var_int_31_to_16;
                                        when "110" =>
                                                WHOLE_FRAME_reg     <= var_int_15_to_0;
                                                whole_line_reg      <= var_int_31_to_16;
                                        when "111" =>
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
                        if(v_pos < visible_area_v_reg) then
                                -- If h_pos is in the visible area
                                if(h_pos < visible_area_h_reg) then
                                        -- Set that new pixels can come
                                        ss_ready <= '1';
                                -- If h_pos is ready to start a new line
                                elsif  (h_pos = whole_line_reg-1) then
                                        ss_ready <= '1';
                                end if;
                        end if;
                end if;
        end process;


        -- Indicate when v and h are in the visible area
        p_v_h_video: process(h_pos, v_pos) is
        begin
                is_v_visible <= '1';
                is_h_visible <= '1';

                -- If h_pos is outside the visible area
                if (h_pos >= visible_area_h_reg) then
                        is_h_visible <= '0';
                end if;

                -- If v_pos is outside the visible area
                if (v_pos >= visible_area_v_reg) then
                        is_v_visible <= '0';
                end if;
        end process;


        -- Increase h_pos and v_pos
        process(pixel_clk_25MHz, rst_n) is          
        begin
                if (rst_n = '0') then
                        v_pos       <=  0 ;
                        h_pos       <=  0 ;
                elsif (rising_edge(pixel_clk_25MHz)) then
                        -- Each clock cycle increases h_pos.
                        -- if h_pos is at the end of the line increase v_pos
                        -- Restart h_pos when end of line
                        if (h_pos < whole_line_reg-1) then
                                h_pos <= h_pos + 1;
                        else
                                h_pos <= 0;
                                -- Restart v_pos when end of frame
                                if (v_pos < WHOLE_FRAME_reg-1) then
                                        v_pos <= v_pos + 1;
                                else
                                        v_pos <= 0;
                                end if;
                        end if;
                end if;

        end process;


        -- Generate H and V sync        
        process(h_pos, v_pos, visible_area_h_reg, front_porch_h_reg, visible_area_v_reg, front_porch_v_reg, sync_pulse_h_reg, sync_pulse_v_reg) is
                variable h_sync_offset : integer := 0;
                variable v_sync_offset : integer := 0;                
        begin
                
                h_sync_offset := visible_area_h_reg + front_porch_h_reg;

                ------ Generate HSYNC Sync pulse
                if (h_sync_offset <= h_pos and h_pos < h_sync_offset+sync_pulse_h_reg) then
                        vga_hsync <= '0';
                else
                        vga_hsync <= '1';
                end if;


                v_sync_offset := visible_area_v_reg + front_porch_v_reg;

                ------ Generate VSYNC Sync pulse
                if (v_sync_offset <= v_pos and v_pos < v_sync_offset + sync_pulse_v_reg) then
                        vga_vsync <= '0';
                else
                        vga_vsync <= '1';
                end if;

        end process;

        -- Generate H and V irq        
        process(h_pos, v_pos, vga_v_irq, vga_h_irq, disable_irq) is
        begin
                vga_v_irq  <= '0';
                if (h_pos = VISIBLE_AREA_H) then
                        vga_h_irq  <= '1';
                else
                        vga_h_irq  <= '0';
                end if;

                vga_irq_en <= (vga_h_irq or vga_v_irq) and (not disable_irq);
        end process;


        process(is_h_visible, is_v_visible) is
        begin
                if ((is_h_visible = '1' and is_v_visible = '1')) then --or (h_pos=799 and v_pos=524)) then
                        en_display  <= '1';
                else
                        en_display  <= '0';
                end if;
        end process;

        -- Latch to handle the irq.
        process(rst_n, vga_irq_reset, vga_irq_en) is
        begin
                if(rst_n = '0' or vga_irq_reset = '1') then
                        vga_irq <= '0';
                elsif(vga_irq_en = '1') then
                        vga_irq <= '1';
                end if;
        end process;
        
        vga_clk <= pixel_clk_25MHz;

end rtl;
