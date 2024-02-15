Library ieee;
use ieee.std_logic_1164.all;

entity MUX2x1 is 
Generic(DataSize: integer :=32);
port(
Input1 : in std_logic_vector(DataSize-1 DOWNTO 0);
Input2 : in std_logic_vector(DataSize-1 DOWNTO 0);
sel : in std_logic;
F: out std_logic_vector(DataSize-1 DOWNTO 0)
);
end MUX2x1;




Architecture MUX2x1_a of MUX2x1 is
begin
F<=Input1 when (SEL = '0')
else Input2 when(SEL = '1');
  
End Architecture MUX2x1_a;