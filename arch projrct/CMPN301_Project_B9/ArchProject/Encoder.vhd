LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;

ENTITY Encoder IS
	GENERIC(
	n : natural := 8);
	PORT(
	x : IN array_of_std_logic(n-1 DOWNTO 0);
	f : OUT std_logic_vector(natural(ceil(log2(real(n))))-1 DOWNTO 0);
	v : OUT std_logic);
END Encoder;

ARCHITECTURE structure OF Encoder IS
BEGIN
	PROCESS(x)
	BEGIN
		f <= (OTHERS=>'0');
		v <= '0';
		loop_bits: FOR i IN 0 TO n-1 LOOP
			IF (x(i) = '1') THEN
				f <= (std_logic_vector(to_unsigned(i,natural(ceil(log2(real(n)))))));
				v <= '1';
			EXIT;
			END IF;
		END LOOP;
	END PROCESS;
END structure;