LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


Entity Counter is
	Port(	en:in std_logic;
		clk:in std_logic;
		rs:in std_logic;
		count:out std_logic_vector (2 downto 0));
End Entity Counter;

architecture archCounter of Counter IS

	signal countTemp:integer;

	begin
		process(clk,en,rs) is
			begin
				if (rising_edge(clk) and en='1') then
					countTemp<=countTemp+1;
				end if;
				if (rs='1') then
					countTemp<=0;
				end if; 
		end process;

	count<=std_logic_vector(to_unsigned(countTemp,3));

end archCounter;
