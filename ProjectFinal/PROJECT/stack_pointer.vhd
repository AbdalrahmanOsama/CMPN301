LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY stack_reg IS
GENERIC ( n : integer := 32);
PORT( 
Clk,Rst,En : IN std_logic;
push,pop: in std_logic;
out_of_range:out std_logic;
q : OUT std_logic_vector(n-1 DOWNTO 0)
);

END stack_reg;



ARCHITECTURE stack_reg OF stack_reg IS
BEGIN
PROCESS (Clk,Rst)
variable pointer:std_logic_vector(31 downto 0):= "00000000000011111111111111111111"; 
BEGIN
IF Rst = '1' THEN
pointer := "00000000000011111111111111111111"																																																																																																			;
ELSIF rising_edge(Clk) THEN
IF push = '1' then
pointer := std_logic_vector(to_unsigned(to_integer(unsigned(pointer))-1,32));
elsif pop='1' then
pointer := std_logic_vector(to_unsigned(to_integer(unsigned(pointer))+1,32));
end if;
IF En = '1' THEN
q <= pointer;
END IF;
END IF;
END PROCESS;
END stack_reg;
