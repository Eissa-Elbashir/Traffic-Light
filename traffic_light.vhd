-- Project Traffic Light with Pedestrain Crossing 

-- Title:					traffic_light.vhd
--	Designer:				Eissa Elbashir
--	Date:						7.1.2022
--	Target board:			DE0 nano board

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

----------------- TOP LEVEL ENTITY------------------------

entity traffic_light is
	port(
		reset_bottom : in STD_LOGIC;		--reset 
		push_bottom : in std_logic;		--pedestrain crossing bottom
		machine_clk : in STD_LOGIC;		--de0 nano board clock
		traffic_lights : out STD_LOGIC_VECTOR(7 downto 0);		--LED to the traffic light and pedestrain crossing
		seven_seg : out std_logic_vector(6 downto 0);		--seven segment display
		seven_seg1 : out std_logic_vector(6 downto 0)		--seven segment display
		);
end traffic_light;

architecture traffic_light_top of traffic_light is 
component clkdiv is port (
		mclk : in STD_LOGIC;
		clr : in STD_LOGIC;
		clk_SEC1 : out STD_LOGIC
		);
end component;

component traffic is port(
		clk : in STD_LOGIC;
		clr : in STD_LOGIC;
		push_bottom : in std_logic;
		lights : out STD_LOGIC_VECTOR(7 downto 0);
		seven_seg : out std_logic_vector(6 downto 0);
		seven_seg1 : out std_logic_vector(6 downto 0)
		);
end component;

signal clr, clk_SEC1: STD_LOGIC;

begin 

	clr <= reset_bottom;
	instanceA: clkdiv port map ( mclk => machine_clk, clr => clr, clk_SEC1 => clk_SEC1 );				--connecting the top level entity to the clock divider
	instanceB: traffic port map ( clk => clk_SEC1, clr => clr, push_bottom => push_bottom, lights => traffic_lights,
											seven_seg => seven_seg, seven_seg1 => seven_seg1);			-- connecting the top level entity to the traffic light
	
end traffic_light_top;

-----------------------CLOCK DIVIDER ---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity clkdiv is 
	Port (
		mclk : in STD_LOGIC;				-- INPUT
		clr : in STD_LOGIC;				--INPUT
		clk_SEC1 : out STD_LOGIC			--OUTPUT
		);
end entity clkdiv;


architecture Behavioral of clkdiv is
	signal clk_signal : std_logic;			--it is signal inside the code, don't has actual input or output
	begin
		process(clr,mclk)
		variable count : integer;
		begin
			if (clr='0') then				--to reset the sequence 
				clk_signal <= '0';
				count := 0;
				elsif rising_edge(mclk) then			--when the clock at the rising edge it runs
					if (count = 24999999) then				--it divides the 50MHz by 25e6 to get 2Hz
						clk_signal <= NOT (clk_signal);
						count := 0;
					else
						count := count + 1;			-- := because it is variable 
					end if;
			end if;
		end process;

	clk_SEC1 <= clk_signal;
	
end Behavioral;

-----------------------------TRAFFIC LIGHT---------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity traffic is
	port (
			clk,clr : in STD_LOGIC;			--INPUT
			push_bottom : in std_logic;			--INPUT
			seven_seg : out std_logic_vector(6 downto 0);			--OUTPUT
			seven_seg1 : out std_logic_vector(6 downto 0);			--OUTPUT
			lights : out STD_LOGIC_VECTOR(7 downto 0)			--OUTPUT
			);
	end traffic;

architecture behaviour of traffic is
		type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9); 
		signal state : state_type;
		signal PB_signal : STD_LOGIC_VECTOR(3 downto 0);
		signal count : STD_LOGIC_VECTOR(3 downto 0);		
		constant SEC10 : STD_LOGIC_VECTOR(3 downto 0) := "1001";		--time 10 sec
		constant SEC2 : STD_LOGIC_VECTOR(3 downto 0) := "0001";		--time 2 sec
		constant SEC6 : STD_LOGIC_VECTOR(3 downto 0) := "0101";		--time 6 sec
	begin 
		process (clk, clr)
		begin
			if (clr = '0') then 			--to reset the sequence
							state <= s0;
							count <= SEC2;
							PB_signal <= X"0";
			elsif clk'event and clk = '1' then 			--when the clock move to 1 it runs
				case state is
						when s0 =>
									if (count > X"0") then 
										state <= s0;
										count <= count - 1;			--to make the seven segment display count down
										if (push_bottom = '0') then			--it saves if the push bottom is pressed
											PB_signal <= PB_signal + 1;
										end if;
									else 
										state <= s1;
										count <= SEC2;				--to start the next state with 2 sec
									end if;
						when s1 =>
									if (count > X"0") then 
										state <= s1;
										count <= count - 1;
										if (push_bottom = '0') then
											PB_signal <= PB_signal + 1;
										end if;
									else 
										state <= s2;
										count <= SEC10;
									end if;
						when s2 =>
									if (count > X"0") then 
										state <= s2;
										count <= count - 1;
										if (push_bottom = '0') then
											PB_signal <= PB_signal + 1;
										end if;
									else 
										state <= s3;
										count <= SEC2;
									end if;
						when s3 =>
									if (count > X"0") then 
										state <= s3;
										count <= count - 1;
										if (push_bottom = '0') then
											PB_signal <= PB_signal + 1;
										end if;
									else 
										state <= s4;
										count <= SEC2;
									end if;
						when s4 =>
									if (count > X"0") then 
										state <= s4;
										count <= count - 1;
										if (push_bottom = '0') then
											PB_signal <= PB_signal + 1;
										end if;
									else 
										state <= s5;
										count <= SEC2;
									end if;
						when s5 =>
									if (count > X"0") then 
										state <= s5;
										count <= count - 1;
										if (push_bottom = '0') then
											PB_signal <= PB_signal + 1;
										end if;
									else 
										state <= s6;
										count <= SEC10;
									end if;
						when s6 =>
									if (count > X"0") then 
										state <= s6;
										count <= count - 1;
										if (push_bottom = '0') then
											PB_signal <= PB_signal + 1;
										end if;
									else 
										state <= s7;
										count <= SEC2;
									end if;
						when s7 =>
									if (count > X"0") then 
										state <= s7;
										count <= count - 1;
										if (push_bottom = '0') then
											PB_signal <= PB_signal + 1;
										end if;
									else 
										state <= s8;
										count <= SEC2;
									end if;
						when s8 =>
									if (count > X"0") then 
										state <= s8;
										count <= count - 1;
										if (push_bottom = '0') then
											PB_signal <= PB_signal + 1;
										end if;
									else 
										if (PB_signal > 0) then 			--if the push bottom pressed more than once won't affect
												state <= s9;
												count <= SEC6;
											else 
												state <= s1;
												count <= SEC2;
											end if;
									end if;
						when s9 =>
									if (count > X"0") then				--pedestrain crossing state
										state <= s9;
										count <= count - 1;
									else 
										state <= s0;
										count <= SEC2;
										PB_signal <= X"0";			-- reset the PB_signal so it won't change for the next sequence without being pressed
									end if;	
						when others =>
										state <= s0;
				end case;
			end if;
		end process;
	
		OUTPUT_LEDS : process(state)			-- for the traffic lights LED and pedestrain crossing LED
		begin
			case state is
				when s0 => lights <= "10100100";			--"Red,Green"	 "Red,Yellow,Green"  "Red,Yellow,Green"
				when s1 => lights <= "10100010";			--	pedestrain		north and south	  East and West
				when s2 => lights <= "10100001";
				when s3 => lights <= "10100010";
				when s4 => lights <= "10100100";
				when s5 => lights <= "10010100";
				when s6 => lights <= "10001100";
				when s7 => lights <= "10010100";
				when s8 => lights <= "10100100";
				when s9 => lights <= "01100100";
				when others => lights <= "10100100";
			end case;
		end process;
		
		OUTPUT_SEVEN_SEGMENT_DISPLAY : process(count)			--for seven segment display count down (remaining time)
		begin
			case count is
				when "0000" => seven_seg <= "0000110"; seven_seg1 <= "0111111";
				when "0001" => seven_seg <= "1011011"; seven_seg1 <= "0111111";
				when "0010" => seven_seg <= "1001111"; seven_seg1 <= "0111111";
				when "0011" => seven_seg <= "1100110"; seven_seg1 <= "0111111";
				when "0100" => seven_seg <= "1101101"; seven_seg1 <= "0111111";
				when "0101" => seven_seg <= "1111101"; seven_seg1 <= "0111111";
				when "0110" => seven_seg <= "0000111"; seven_seg1 <= "0111111";
				when "0111" => seven_seg <= "1111111"; seven_seg1 <= "0111111";
				when "1000" => seven_seg <= "1101111"; seven_seg1 <= "0111111";
				when "1001" => seven_seg <= "0111111"; seven_seg1 <= "0000110";
				when "1010" => seven_seg <= "0000110"; seven_seg1 <= "0000110";
				when "1011" => seven_seg <= "1011011"; seven_seg1 <= "0000110";
				when "1100" => seven_seg <= "1001111"; seven_seg1 <= "0000110";
				when "1101" => seven_seg <= "1100110"; seven_seg1 <= "0000110";
				when "1110" => seven_seg <= "1101101"; seven_seg1 <= "0000110";
				when "1111" => seven_seg <= "1111101"; seven_seg1 <= "0000110";
			end case;
		end process;
	end behaviour;
