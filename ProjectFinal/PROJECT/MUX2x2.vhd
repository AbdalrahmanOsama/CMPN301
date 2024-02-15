LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity MUX2x2 is 
port(
Input1,Input2: in std_logic;
SEL : in std_logic;
F: out std_logic);
end MUX2x2;


Architecture MUX2x2_a of MUX2x2 is
begin
F<=Input1 when (SEL = '0')
else Input2 when(SEL = '1');
End Architecture MUX2x2_a;
