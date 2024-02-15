LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;

ENTITY D_FF IS
	PORT(
	d : IN std_logic;
	clk : IN std_logic;
	rst : IN std_logic;
	q : OUT std_logic);
END D_FF;

ARCHITECTURE structure OF D_FF IS
BEGIN
	PROCESS(clk,rst)
	BEGIN
		IF(rst = '1') THEN
			q <= '0';
		ELSIF rising_edge(clk) THEN
			q <= d;
		END IF;
	END PROCESS;
END structure;