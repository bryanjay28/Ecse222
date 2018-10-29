------------
-- Author: Bryan & Julia
--

-- Import the necessary library files
library ieee; 
use ieee.std_logic_1164.all;

entity ledPong is 
	Port (	
		clock				: in std_logic;
		reset				: in std_logic;
		paddle_left 	: in std_logic;
		paddle_right	: in std_logic;
		leds				: out std_logic_vector (9 downto 0);
		score_left_segments		: out std_logic_vector (6 downto 0);
		score_right_segments		: out std_logic_vector (6 downto 0)
		);
end ledPong;
	
architecture behaviour of ledPong is

	component clock_divider is
	Port (
		clock			: in std_logic; -- Clock for the system
		slow_clock	: out std_logic -- Slow clock value
		  );
	end component;
	
	component counter is 
	Port (
		clock 		: in std_logic; -- Clock for the system
		reset			: in std_logic; -- Resets the count
		count			: out std_logic_vector (3 downto 0) -- Value of counter
		  );
	end component;
	
	component led_decoder is
	Port (
		count			: in std_logic_vector (3 downto 0); -- Value of counter
		leds			: out std_logic_vector (9 downto 0) -- which of the LEDs are ON
		  );
	end component; 
	
	component seven_seg_decoder is
	Port (
		number		: in std_logic_vector (3 downto 0); -- value of counter
		segments		: out std_logic_vector (6 downto 0) -- Pattern to be displayed on the 7-segment display
		  );
	end component;
	
	component score_keeper is
	Port (
		clock			: in std_logic; -- Clock for the system
		reset			: in std_logic; -- Resets the score
		paddle_left	: in std_logic;
		paddle_right: in std_logic;
		counter		: in std_logic_vector (3 downto 0);
		score_left	: out std_logic_vector (3 downto 0);
		score_right	: out std_logic_vector (3 downto 0)
		  );
	end component;
	
	-- wires
	signal slow_clock			: std_logic;
	signal count_out			: std_logic_vector (3 downto 0);
	signal score_left_wire	: std_logic_vector (3 downto 0);
	signal score_right_wire	: std_logic_vector (3 downto 0);
	
begin

	-- Instantiate the components
	clock_div: clock_divider
	port map (
		clock => clock,
		slow_clock => slow_clock
				);
				
	spec_counter: counter
	port map (
		clock => slow_clock,
		reset => reset,
		count => count_out
				);
	
	led_dec_inst: led_decoder
	port map (
		count => count_out,
		leds => leds
				);
	
	score_left: seven_seg_decoder
	port map (
		number => score_left_wire,
		segments => score_left_segments
				);
				
	score_right: seven_seg_decoder
	port map (
		number => score_right_wire,
		segments => score_right_segments
				);
				
	score_keeper_module: score_keeper
	port map (
		clock => slow_clock,
		reset => reset,
		paddle_left => not paddle_left,
		paddle_right => not paddle_right,
		counter => count_out,
		score_left => score_left_wire,
		score_right => score_right_wire
				);

end behaviour; 