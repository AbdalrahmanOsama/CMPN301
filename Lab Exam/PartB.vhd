library ieee;
use ieee.std_logic_1164.all;

entity PartB is
generic(n:integer:=8);
port (A,B :in std_logic_vector (n-1 DOWNTO 0); Sel :in std_logic_vector (1 DOWNTO 0); F:out std_logic_vector (n-1 DOWNTO 0) ;Cout :Out std_logic);
end entity PartB;

architecture archPartB Of PartB Is
begin
F<= (A and B) WHEN sel="00"
ELSE (A or B) When sel="01"
Else (A xor B) When sel="10"
Else (not A);
Cout<='0';
end archPartB;
