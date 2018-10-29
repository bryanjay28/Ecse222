--Authors: Bryan & Julia
--
--This Test Bench makes sure the clock is being slowed adequately
---------------

-- import the necessary libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Decalre entity
entity tb_clock_divider is
end tb_clock_divider;

architecture behaviour of tb_clock_divider is

	-- Declare the device as a component
	component clock_divider is
	Generic( slow_factor : integer := 1000 );
	Port (
		clock		: in std_logic; --clock for the system
		reset		: in std_logic; -- Resets the counter
		slow_clock 	: out std_logic -- Slow clock value
	     );
	end component;

	-- Inputs
	signal clock_in	: std_logic;
	signal reset_in : std_logic;

	-- Outputs
	signal clock_out : std_logic;

	-- Helper
	constant clock_period	: time := 10 ns;
	constant run_time	: integer := 5000;

begin

	-- Instantiate the divider
	clock_div: clock_divider
	port map (
		clock => clock_in,
		reset => reset_in,
		slow_clock => clock_out
		 );

	-- This process creates a clock signal
	clock_process: process
	begin
		clock_in <= '0';
		wait for clock_period/2;
		clock_in <= '1';
		wait for clock_period/2;
	end process;

	-- This is the actual unit test
	test: process
	begin
		reset_in <= '1';
		wait for clock_period;
		-- Check that there is a pulse after 1 million cycles
		assert clock_out = '0' report "Error" severity Error;
		reset_in <= '0';

		wait for clock_period * (run_time);
		assert clock_out = '1' report "Error" severity Error;

		-- This will stop the simulation
		assert false report "Clock Divider test sucess!" severity failure;
	end process;


end behaviour;