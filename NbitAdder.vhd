LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity nBitAdder IS
generic(n: integer:=8);
port(a,b:in std_logic_vector (n-1 downto 0);cin: in std_logic;s: out std_logic_vector (n-1 downto 0);cout: out std_logic);
end nBitAdder;

architecture archnBitAdder of nBitAdder is
component my_adder is
Port(a,b,cin:in std_logic;s,cout:out std_logic);
end component;
signal temp : std_logic_vector (n downto 0);
begin
temp(0)<=cin;
loop1: for i in 0 to n-1 generate
u1:my_adder port map (a(i),b(i),temp(i),s(i),temp(i+1));
end generate;
cout<=temp(n);
end archnBitAdder;
