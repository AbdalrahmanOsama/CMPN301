library ieee;
use ieee.std_logic_1164.all;


entity n_adder is
generic(n : integer := 32);
	port(
		a, b: in std_logic_vector(n-1 downto 0);
		cin: in std_logic;
		cout: out std_logic;
		s: out std_logic_vector(n-1 downto 0)
	);
end entity;


architecture a_n_adder of n_adder is

signal temp: std_logic_vector(n downto 0);
begin

temp(0) <= cin;

loop1: for i in 0 to n-1 generate
inst: entity work.adder(a_adder) port map (a(i), b(i), temp(i), s(i), temp(i+1));
end generate;

cout <= temp(n);

end architecture;