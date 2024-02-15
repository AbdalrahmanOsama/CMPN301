LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
ENTITY reg IS
GENERIC ( n : integer := 32);
PORT( 
Clk,Rst,En : IN std_logic;
 d : IN std_logic_vector(n-1 DOWNTO 0);
q : OUT std_logic_vector(n-1 DOWNTO 0)
);

END reg;



ARCHITECTURE a_reg OF reg IS
BEGIN
PROCESS (Clk,Rst)
BEGIN
IF Rst = '1' THEN
		q <= (OTHERS=>'0');
ELSIF rising_edge(Clk) THEN
	IF En = '1' THEN
		q <= d;
	END IF;
END IF;

END PROCESS;
END a_reg;
