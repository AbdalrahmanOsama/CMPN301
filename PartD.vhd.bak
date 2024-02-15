library ieee;
use ieee.std_logic_1164.all;

entity PartD is
generic(n:integer:=8);
port (A:in std_logic_vector(n-1 DOWNTO 0); Cin :in std_logic; Sel:in std_logic_vector(1 DOWNTO 0); F:out std_logic_vector(n-1 DOWNTO 0); Cout:out std_logic);
end entity PartD;

architecture archPartD of PartD is
begin
F<= '0' & A(n-1 DOWNTO 1)  WHEN Sel="00"
Else A(0) & A(n-1 DOWNTO 1) WHEN Sel="01"
else Cin & A(n-1 DOWNTO 1)  WHEN Sel="10"
else A(n-1) & A(n-1 DOWNTO 1);
Cout<= A(0);
end archPartD;
