library ieee;
use ieee.std_logic_1164.all;

entity adder is
	port(
		a, b, cin: in std_logic;
		s, cout: out std_logic
	);
end adder;


architecture a_adder of adder is
	begin

		s <= a XOR b XOR cin;
		cout <= (a AND b) OR (cin AND (a XOR b));

end architecture;