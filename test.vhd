-- testbench for  Clock divider

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
	signal mclk : std_logic := '0';
	signal clr : std_logic := '1';
	--output--
	signal clk_SEC1 : std_logic ;
	-- clock period definition --
constant mclk_period : time := 20 ns;

component clkdiv
	port (
	mclk : in std_logic;
	clr : in std_logic;
	clk_SEC1 : out std_logic
	);
end component;
begin

instance2: 	entity work.clkdiv port map ( clr => clr, mclk => mclk, clk_SEC1 => clk_SEC1);		--to connect the testbench with the original code

-----------clock-------------------------------
process
	begin
		mclk <= '0';
		wait for (mclk_period/2);
		mclk <= '1';
		wait for (mclk_period/2);
	end process;

----------test the reset bottom-----------------
process
	begin
		clr <= '0';
		wait for 50 ns;
		clr <= '1';
		wait for 500 ns;
		clr <= '0';
		wait for 50 ns;
		clr <= '1';
		wait;
	end process;
end test_bench;
