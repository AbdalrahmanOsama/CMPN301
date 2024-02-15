LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;

ENTITY Decoder IS
	GENERIC(
	n : natural := 8);
	PORT(
	x : IN std_logic_vector(natural(ceil(log2(real(n))))-1 DOWNTO 0);
	f : OUT array_of_std_logic(n-1 DOWNTO 0));
END Decoder;

ARCHITECTURE structure OF Decoder IS
BEGIN
	PROCESS(x)
	BEGIN
		f <= (OTHERS=>'0');
		f(to_integer(unsigned(x))) <= '1';
	END PROCESS;
END structure;