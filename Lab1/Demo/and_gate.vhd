Library ieee;
use ieee.std_logic_1164.all;

entity myand is 

port(
a : in std_logic;
b : in std_logic;
c : out std_logic);

end entity;

Architecture myModel of myand is
begin
c <= a or b
end Architecture;