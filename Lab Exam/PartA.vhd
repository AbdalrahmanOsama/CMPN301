LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity PartA IS
generic(n:integer:=8);
Port(a,b:in std_logic_vector (n-1 DOWNTO 0); 
cin: in std_logic;
s: in std_logic_vector (1 downto 0); 
f:out std_logic_vector (n-1 DOWNTO 0);
cout:out std_logic);
end PartA;

architecture archPartA of PartA is
component nBitAdder is
port(a,b:in std_logic_vector (n-1 downto 0);cin: in std_logic;s: out std_logic_vector (n-1 downto 0);cout: out std_logic);
end component;
signal tempB: std_logic_vector (n-1 downto 0);
begin
tempB<=(others=>'0') when s="00"
else b when s="01"
else (not b) when s="10"
else (others=>'1') when s="11";
u0: nBitAdder generic map(8) port map(a,tempB,cin,f,cout);
end archPartA;
