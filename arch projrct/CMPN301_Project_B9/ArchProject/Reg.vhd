LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;
USE BASICLOGIC.all;

ENTITY Reg IS
	GENERIC(
	w : natural := 16);
	PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	d : IN std_logic_vector(w-1 DOWNTO 0);
	q : OUT std_logic_vector(w-1 DOWNTO 0));
END Reg;

ARCHITECTURE structure_a OF Reg IS
BEGIN
	PROCESS (clk,rst)
	BEGIN
		IF(rst = '1') THEN
			q <= (OTHERS=>'0');
		ELSIF rising_edge(clk) THEN
			q <= d;
		END IF;
	END PROCESS;
END structure_a;

ARCHITECTURE structure_b OF Reg IS
BEGIN
	loop_ff: FOR i IN 0 TO w-1 GENERATE
		u_ff: ENTITY BASICLOGIC.D_FF(structure) PORT MAP(d => d(i),clk => clk,rst => rst,q => q(i));
	END GENERATE;
END structure_b;
