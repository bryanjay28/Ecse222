--Author: Bryan & Julia 

--import the necessary libraries 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--declare entity
entity score_keeper is 
	Port (
		clock		: in std_logic; --clock for the system
		reset		: in std_logic; -- reset the score
		paddle_left 	: in std_logic; 
		paddle_right 	: in std_logic;
		counter		: in std_logic_vector (3 downto 0);
		score_left	: out std_logic_vector (3 downto 0);
		score_right	: out std_logic_vector (3 downto 0)
	     );
end score_keeper ;

architecture behaviour of score_keeper is 
begin 

	process(clock, reset)
		--internal values for the pong module
		variable score_left_reg		: unsigned (3 downto 0);
		variable score_right_reg	: unsigned (3 downto 0);

	begin
		-- reset all variables 
		if reset = '1' then 
			score_left_reg  := "0000";
			score_right_reg := "0000";
		
		elsif (clock'event and clock = '1') then 
		-- this is where all the core logiic belongs 

			-- left player missed a BALL
			if(counter = x"0" and paddle_left = '0') then 
				score_right_reg := score_right_reg + 1 ;

			-- right player missed a BALL 
			elsif(counter = x"9" and paddle_right = '0') then 
				score_left_reg := score_left_reg + 1;
			end if;

			--set output to register values 
			score_left  <= std_logic_vector(score_left_reg);
			score_right <= std_logic_vector(score_right_reg);

		end if; 
	end process;

end behaviour;