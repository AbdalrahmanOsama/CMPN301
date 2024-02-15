LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;

ENTITY FAdder IS
	PORT(
	a : IN std_logic;
	b : IN std_logic;
	cin : IN std_logic;
	s : OUT std_logic;
	cout : OUT std_logic);
END FAdder;

ARCHITECTURE structure OF FAdder IS
BEGIN
	s <= (a xor b) xor cin;
	cout <= (a and b) or ((a xor b) and cin);
END structure;