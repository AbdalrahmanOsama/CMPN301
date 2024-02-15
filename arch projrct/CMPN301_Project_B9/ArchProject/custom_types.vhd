LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

PACKAGE custom_types IS
	TYPE array_of_std_logic IS ARRAY (natural RANGE <>) OF std_logic;
	TYPE array2d_of_std_logic IS ARRAY (natural RANGE <>) OF array_of_std_logic;
	TYPE array_of_std_logic_vector IS ARRAY (natural RANGE <>) OF std_logic_vector;
	TYPE array2d_of_std_logic_vector IS ARRAY (natural RANGE <>) OF array_of_std_logic_vector;
END custom_types;