-- testbench for  Traffic

-- Title:					test.vhd
--	Designer:				Eissa Elbashir
--	Date:						7.1.2022
--	Target board:			DE0 nano board


library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
end test;

architecture test_bench of test is
	--input--
	signal clk : std_logic := '0';
	signal clr : std_logic := '1';
	signal push_bottom : std_logic := '1';
	--output--
	signal lights : std_logic_vector(7 downto 0);
	-- clock period definition --
constant clk_period : time := 20 ns;

component traffic_light 
	port (
	clk : in std_logic;
	clr : in std_logic;
	push_bottom : in std_logic;
	lights : out std_logic_vector(7 downto 0)
	);
end component;

begin
instance2: 	entity work.traffic port map ( clr => clr, clk => clk, lights => lights, push_bottom => push_bottom);				--to connect the testbench with the original code

--------------------------clock--------------------------------------
process
	begin
		clk <= '0';
		wait for (clk_period/2);
		clk <= '1';
		wait for (clk_period/2);
	end process;
	
------------------testing the reset bottom----------------------------
process
	begin
		clr <= '0';
		wait for 40 ns;
		clr <= '1';
		wait for 500 ns;
		clr <= '0';
		wait for 40 ns;
		clr <= '1';
		wait;
	end process;
	
--------------testing the pedestrian crossing bottom-------------------
process
	begin
		wait for 40 ns;
		push_bottom <= '0';
		wait for 40 ns;
		push_bottom <= '1';
		wait for 1000 ns;
	end process;
end test_bench;
