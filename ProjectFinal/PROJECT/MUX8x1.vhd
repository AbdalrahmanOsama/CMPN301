Library ieee;
use ieee.std_logic_1164.all;

entity MUX8x1 is 
Generic(DataSize: integer :=32);
port(
Input1,Input2,Input3,Input4 : in std_logic_vector(DataSize-1 DOWNTO 0);
Input5,Input6,Input7,Input8: in std_logic_vector(DataSize-1 DOWNTO 0);
SEL : in std_logic_VECTOR(2 downto 0);
F: out std_logic_vector(DataSize-1 DOWNTO 0));
end MUX8x1;


Architecture MUX8x1_a of MUX8x1 is
begin
F<=Input1 when (SEL = "000")
else Input2 when(SEL = "001")
else Input3 when (SEL = "010")
else Input4 when (SEL = "011")
else Input5 when (SEL = "100")
else Input6 when (SEL = "101")
else Input7 when (SEL = "110")
else Input8 when (SEL = "111");
  
End Architecture MUX8x1_a;
