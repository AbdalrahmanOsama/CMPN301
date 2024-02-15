LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY onebit_reg IS
PORT( 
Clk,Rst,En : IN std_logic;
 d : IN std_logic_vector(2 DOWNTO 0);
q : OUT std_logic_vector(2 DOWNTO 0)
);

END onebit_reg;


ARCHITECTURE a_onebit_reg OF onebit_reg IS
BEGIN
PROCESS (Clk)
BEGIN
IF (Rst = '1' and rising_edge(clk)) THEN
		q <= (OTHERS=>'0');
ELSIF rising_edge(Clk) THEN
	IF En = '1' THEN
		q <= d;
	END IF;
END IF;

END PROCESS;
END a_onebit_reg;
