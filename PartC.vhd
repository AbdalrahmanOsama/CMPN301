library ieee;
use ieee.std_logic_1164.all;

entity PartC is
generic(n:integer:=8);
port (A:in std_logic_vector(n-1 DOWNTO 0); Cin :in std_logic; Sel:in std_logic_vector(1 DOWNTO 0); F:out std_logic_vector(n-1 DOWNTO 0); Cout:out std_logic);
end entity PartC;

architecture archPartC of PartC is
begin
F<=A(n-2 DOWNTO 0) & '0' WHEN Sel="00"
Else A(n-2 DOWNTO 0) & A(n-1) WHEN Sel="01"
else A(n-2 DOWNTO 0) & Cin WHEN Sel="10"
else (others=>'1');
Cout<= '0' when Sel="11"
else A(n-1);
end archPartC;