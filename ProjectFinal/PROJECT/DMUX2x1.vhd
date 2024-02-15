Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DMUX2x1 is 
generic(n:integer:=32);
port(
F_DMUX:in std_logic_vector(n-1 downto 0);
OUT1,OUT2: out std_logic_vector(n-1 downto 0);
SEL_DMUX:in std_logic
);
end DMUX2x1;

architecture arch_DMUX2x1 of DMUX2x1 is 
begin
OUT1<= F_DMUX when SEL_DMUX = '0' else (Others=>'Z');
OUT2<= F_DMUX when SEL_DMUX = '1' else (Others=>'Z');
end arch_DMUX2x1;