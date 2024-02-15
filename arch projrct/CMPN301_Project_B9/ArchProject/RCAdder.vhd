LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;
USE BASICLOGIC.all;

ENTITY RCAdder IS
	GENERIC(
	w : natural := 16);
	PORT(
	a : IN std_logic_vector(w-1 DOWNTO 0);
	b : IN std_logic_vector(w-1 DOWNTO 0);
	cin : IN std_logic;
	s : OUT std_logic_vector(w-1 DOWNTO 0);
	cout : OUT std_logic);
END RCAdder;

ARCHITECTURE structure OF RCAdder IS
	SIGNAL carry : array_of_std_logic(w DOWNTO 0);
BEGIN
	carry(0) <= cin;
	loop_add: FOR i IN 0 TO w-1 GENERATE
		u_adder: ENTITY BASICLOGIC.FAdder(structure) PORT MAP(a => a(i),b => b(i),cin => carry(i),s => s(i),cout => carry(i+1));
	END GENERATE;
	cout <= carry(w);
END structure;