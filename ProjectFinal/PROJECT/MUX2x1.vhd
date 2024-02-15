LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity MUX2x1 is 
Generic(DataSize: integer :=32);
port(
Input1,Input2: in std_logic_vector(DataSize-1 DOWNTO 0);
SEL : in std_logic;
F: out std_logic_vector(DataSize-1 DOWNTO 0));
end MUX2x1;


Architecture MUX2x1_a of MUX2x1 is
begin
F<=Input1 when (SEL = '0')
else Input2 when(SEL = '1');
End Architecture MUX2x1_a;
