LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity MUX4x2 is 
Generic(DataSize: integer :=32);
port(
Input1,Input2,Input3,Input4 : in std_logic_vector(DataSize-1 DOWNTO 0);
SEL : in std_logic_VECTOR(1 downto 0);
F: out std_logic_vector(DataSize-1 DOWNTO 0));
end MUX4x2;


Architecture MUX4x2_a of MUX4x2 is
begin
F<=Input1 when (SEL = "00")
else Input2 when(SEL = "01")
else Input3 when (SEL = "10")
else Input4 when (SEL = "11");
  
End Architecture MUX4x2_a;
