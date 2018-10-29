--Author: Bryan & Jay
--
----------

-- import the necessary libraries 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_score_keeper is 
end tb_score_keeper;

architecture behaviour of tb_score_keeper is 
	component score_keeper is 
	Port ( 
		clock		: in std_logic; -- Clock for the system
		reset		: in std_logic; -- resets the score
		paddle_left	: in std_logic; 
		paddle_right    : in std_logic; 
		counter		: in std_logic_vector (3 downto 0) ; 
		score_left 	: out std_logic_vector (3 downto 0);
		score_right   	: out std_logic_vector (3 downto 0)
	     );
end component; 

--inputs 

	signal clock_in 	: std_logic;	
	signal reset_in 	: std_logic;
	signal paddle_left_in	: std_logic;
	signal paddle_right_in 	: std_logic;
	signal counter_in 	: std_logic_vector (3 downto 0);

--outputs
	signal score_left_out 	: std_logic_vector (3 downto 0);
	signal score_right_out 	: std_logic_vector ( 3 downto 0);

--helpers
	constant clock_period	: time := 10 ns;

begin 

	dut : score_keeper
	port map ( 
		clock => clock_in,
		reset => reset_in,
		paddle_left => paddle_left_in,
		paddle_right => paddle_right_in,
		counter => counter_in,
		score_left => score_left_out,
		score_right => score_right_out
		);		

		-- this process creates a clock signal 
	clock_process: process
	begin 
		clock_in <= '0';
		wait for clock_period/2;
		clock_in <= '1';
		wait for clock_period/2;
	end process;

	--this initializes the system by holdind the reset high for 2 clock periods
	init: process
	begin
		wait for clock_period;
		reset_in <= '1';
		wait for clock_period;
		reset_in <= '0';
		wait;
	end process;
	
	--this is the actual unit test 
	
	test: process
	begin 
		wait for clock_period * 3; 

		--Check that the score are initialized properly
 		assert score_left_out = "0000" report "Error" severity Error;
		assert score_right_out= "0000" report "Error" severity Error;

		--check right score
		counter_in <= x"0";
		paddle_left_in <= '0';
		paddle_right_in <= '0';
		wait for clock_period;
		assert score_right_out = "0001" report "Error" severity Error; 

		--check left score
		counter_in <= x"9";
		paddle_left_in <= '0';
		paddle_right_in <= '0';
		wait for clock_period;
		assert score_left_out = "0001" report "Error" severity Error; 
	
		--check right block
		counter_in <= x"9";
		paddle_left_in <= '0';
		paddle_right_in <= '1';
		wait for clock_period;
		assert score_left_out = "0001" report "Error" severity Error; 
	
		--check left block
		counter_in <= x"0";
		paddle_left_in <= '1';
		paddle_right_in <= '0';
		wait for clock_period;
		assert score_right_out = "0001" report "Error" severity Error; 

		-- This will stop the simulation
		assert false report "Score keeper test Success!" severity failure;
	end process;

end behaviour; 