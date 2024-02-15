--completed
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY basic_adder IS
	PORT (a,b,cin : IN  std_logic;
		  f, cout : OUT std_logic );
END basic_adder;

ARCHITECTURE arch_basic_adder OF basic_adder IS
	BEGIN
		
				f <= a XOR b XOR cin;
				cout <= (a AND b) OR (cin AND (a XOR b));
		
END arch_basic_adder;
