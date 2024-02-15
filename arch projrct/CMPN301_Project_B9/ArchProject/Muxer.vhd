LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;

ENTITY Muxer IS
	GENERIC(
	n : natural := 8;
	w : natural := 16);
	PORT(
	x : IN array_of_std_logic_vector(n-1 DOWNTO 0) (w-1 DOWNTO 0);
	s : IN std_logic_vector(natural(ceil(log2(real(n))))-1 DOWNTO 0);
	f : OUT std_logic_vector(w-1 DOWNTO 0));
END Muxer;

ARCHITECTURE structure OF Muxer IS
BEGIN
	PROCESS(s,x)
	BEGIN
		f <= (OTHERS=>'0');
		f <= x(to_integer(unsigned(s)));
	END PROCESS;
END structure;