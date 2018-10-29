-----------------------------------
-- Author: Shabbir Hussain
-- Email: shabbir.hussain@mail.mcgill.ca

-- This module handles the synchronization and timing of the VGA output

-- Horizontal Sync
-- Configuration   | Resolution | Sync    | Back  Porch | RGB      | Front porch | Clock
-- 640x480(60Hz)   | 640x480    | 1.0us   |    2.3us    | 11.9 us  |    0.4us    | 25.175 MHz
--                                96 pix      48 pix      640 pix       16 pix 
-- Total pixels = sync+bp+rgb+fp = 800

-- Veritcal sync
-- Configuration   | Resolution | Sync    | Back  Porch |  RGB       | Front porch    | Clock
-- 640x480(60Hz)   | 640x480    |  2 line |    31 line  |  480 line  |    11 line     | 25.175 MHz
--
-- Total lines = 524

----------------------------------- 
-- Import the necessary libraries
library ieee;
use ieee.std_logic_1164.all;


-- Declare entity
entity vga_controller is
    Generic(
        MAX_H : integer := 1688;
        S_H   : integer := 112;
        BP_H  : integer := 248;
        RGB_H : integer := 1280;
        FP_H  : integer := 48;

        MAX_V : integer := 1066;
        S_V   : integer := 3;
        BP_V  : integer := 38;
        RGB_V : integer := 1024;
        FP_V  : integer := 1;

        PIXLS : integer := 1310720 -- Total num Pixels = 1280 x 1024
           );
    Port (
    --Inputs
    clk         : in std_logic; -- VGA clock
    rst         : in std_logic;

    -- Outputs
	 pixel_x     : out integer;
	 pixel_y		 : out integer;
    vga_blank   : out std_logic;


    vga_hs      : out std_logic;
    vga_vs      : out std_logic;


    vga_clk     : out std_logic;
    vga_sync    : out std_logic	 
    );

end vga_controller;


architecture behaviour of vga_controller is
     signal hpos : integer range 0 to MAX_H := 0;
     signal vpos : integer range 0 to MAX_V := 0;
	 
	 signal vga_hsr : std_logic; -- Temp registers for 
	 signal vga_vsr : std_logic; -- Hsync and Vsync

    signal pixel_xr : integer := 0; -- Pixel position register
	 signal pixel_yr : integer := 0; -- Pixel position register

begin

    -- Map to DAC (digital to analog converter)
    vga_clk <= clk;
	 vga_hs <= vga_hsr;
	 vga_vs <= vga_vsr;
	 vga_sync <= (vga_hsr and vga_vsr);
	 pixel_x <= pixel_xr;
	 pixel_y <= pixel_yr;
	    
    process(clk)
    begin
        if(rst = '1') then
            hpos <= 0;
            vpos <= 0;

            pixel_xr <= 0;
				pixel_yr <= 0;

        elsif rising_edge(clk) then
            
								-- Set Hpos and Vpos
				-- if (hpos is less than MAX_H){
				--    add 1 to hpos
				-- }
				-- else {
				--    Set hpos to 
			   --  	if (vpos is less than MAX_V) {
				--        add 1 to vpos
				--    else {
				--        set vpos to 0
				--		}
				
				if (hpos < MAX_H) then
					hpos <= hpos +1;
				else
					hpos <= 0;
					if (vpos <Max_V) then
						vpos <= vpos +1;
						else
						vpos <= 0;
					end if;
				end if;
				
				-- Set h_sync
				-- if(hpos < S_H) {
				--    set vga_hsr to 0
				-- } else {
				--    set vga_hsr to 1
				-- }
				
				if (hpos <S_H) then
					vga_hsr <= '0';
					else
					vga_hsr <= '1';
				end if;
				
				-- Set v_sync
				-- if(vpos < S_V) {
				--    set vga_vsr to 0
				-- } else {
				--    set vga_vsr to 1
				-- }
				
				if (vpos < S_V) then
					vga_vsr <= '0';
					else
					vga_vsr <= '1';
				end if;
					
            -- Set blanking
				-- if( front porch, backporch, h_sync,  v_sync){
				--    set vga_blank to 0
				-- } else {
				--    set vga_blank to 1
				--    if(pixel_xr < RGB_H-1){
				--       add 1 to the current value of pixel_xr
				--    } else [
				--       set pixel_xr to 0
				--       if(pixel_yr < RGB_V-1){
				--          add 1 to the current value of pixel_yr
				--       } else {
				--          set pixel_yr to 0
				--       }
				
				if (((hpos >= S_H+BP_H+RGB_H) AND (hpos <= Max_H)) OR ((hpos >= S_H) AND (hpos< S_H+BP_H)) OR ((hpos >= 0) AND (hpos < S_H)) OR ((vpos >= S_V+BP_V+RGB_V) AND (vpos <= Max_V)) OR ((vpos >= S_V) AND (vpos< S_V+BP_V)) OR ((vpos >= 0) AND (vpos < S_V)) ) then
					vga_blank <= '0';
				else
					vga_blank <= '1';
					if (pixel_xr <RGB_H -1) then
						pixel_xr <= pixel_xr +1;
					else 
						pixel_xr <= 0;
						if (pixel_yr< RGB_V-1) then
							pixel_yr <= pixel_yr +1;
						else
							pixel_yr <= 0;
						end if;
					end if;
				end if;	
			
			-- WRITE YOU CODE ABOVE
			-- DELETE THE 7 LINES BELOW

			
        end if;
    end process;
end behaviour;
