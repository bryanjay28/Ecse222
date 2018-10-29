-- Bryan & Julia

-- Import the necessary libraries
library ieee;
use ieee.std_logic_1164.all;

-- Declare entity
entity tb_game_controller is
end tb_game_controller;

architecture behaviour of tb_game_controller is
-- Component declaration of Device Under Test (DUT)
	component game_controller is
		port (
			clk             : in std_logic; 
        		rst             : in std_logic;
        		shoot           : in std_logic; 
			move_left       : in std_logic; 
       			move_right      : in std_logic; 		  
		  	pixel_x         : in integer; 
		  	pixel_y		: in integer; 
        		pixel_color	: out std_logic_vector (2 downto 0)
			
		);
	end component;

--Inputs
signal clk_in: std_logic;
signal rst_in: std_logic;
signal shoot_in: std_logic;
signal move_left_in : std_logic; 
signal move_right_in: std_logic; 				  
signal pixel_x_in : integer; 
signal pixel_y_in : integer;  



--Outputs
signal pixel_color_out: std_logic_vector (2 downto 0);


--Helper
constant clk_period : time := 50ns;


type state is ( init, pre_game, gameplay, game_over);
signal game_state: state ;
signal lives: integer;
signal score: integer;

begin
	dut: game_controller
	port map(
		clk => clk_in,
		rst => rst_in,
		shoot => shoot_in,
		move_left =>move_left_in,
		move_right =>move_right_in,
		pixel_x => pixel_x_in,
		pixel_y => pixel_y_in,
		pixel_color => pixel_color_out
	);

	-- this process creates a clock signal
	clk_process: process
	begin
		clk_in <= '0';
		wait for clk_period/2;
		clk_in <= '1';
		wait for clk_period/2;
	end process;


	-- Actual unit test
	test: process

	begin		
		pixel_x_in <= 0;
		pixel_y_in <= 0;
		shoot_in <= '0';

		rst_in <= '0';
		wait for clk_period;
		assert game_state = pre_game report "Error: When init, current state does not change to pre_game" severity Error;

		rst_in <= '1';
		wait for clk_period;
		assert game_state = init report "Error: Reset does not set current state to init" severity Error;

		shoot_in <= '1';
		wait for clk_period;
		assert game_state = init report "Error: shooting after game over does not initialize game" severity Error;
		shoot_in <= '0';
		
		shoot_in <= '1';
		wait for clk_period;
		assert game_state = gameplay report "Error: shooting does not start game" severity Error;
		shoot_in <= '0';

		assert false report "Test success!" severity failure;

	end process;

end behaviour;
	