library ieee;
use ieee.std_logic_1164.all;

entity PartBCDCombined Is
generic(n:integer:=8);
Port (in1,in2:in std_logic_vector (n-1 DOWNTO 0); Sel1:in std_logic_vector (3 downto 0); Cin1:in std_logic; out1:out std_logic_vector (n-1 downto 0); Cout1:out std_logic);
end entity PartBCDCombined;


architecture archPartBCDCombined of PartBCDCombined IS

component PartA IS
Port(a,b:in std_logic_vector (n-1 DOWNTO 0); 
cin: in std_logic;
s: in std_logic_vector (1 downto 0); 
f:out std_logic_vector (n-1 DOWNTO 0);
cout:out std_logic);
end component;

component PartB IS
port (A,B :in std_logic_vector (n-1 DOWNTO 0); Sel :in std_logic_vector (1 DOWNTO 0); F:out std_logic_vector (n-1 DOWNTO 0) ;Cout :Out std_logic);
end component;

component PartC IS
port (A:in std_logic_vector(n-1 DOWNTO 0); Cin :in std_logic; Sel:in std_logic_vector(1 DOWNTO 0); F:out std_logic_vector(n-1 DOWNTO 0); Cout:out std_logic);
end component;

component PartD IS
port (A:in std_logic_vector(n-1 DOWNTO 0); Cin :in std_logic; Sel:in std_logic_vector(1 DOWNTO 0); F:out std_logic_vector(n-1 DOWNTO 0); Cout:out std_logic);
end component;

signal wA,wB,wC,wD: std_logic_vector (n-1 downto 0);
signal cA,cB,cC,cD: std_logic;

begin

u1:PartB generic map(8) port map(in1,in2,Sel1(1 downto 0),wB,cB);
u2:PartC generic map(8) port map(in1,Cin1,Sel1(1 downto 0),wC,cC);
u3:PartD generic map(8) port map(in1,Cin1,Sel1(1 downto 0),wD,cD);
u4:PartA generic map(8) port map(in1,in2,Cin1,Sel1(1 downto 0),wA,cA);

out1<=wB when Sel1(3 downto 2)="01"
else wC when Sel1(3 downto 2)="10"
else wD when Sel1(3 downto 2)="11"
else wA when Sel1(3 downto 2)="00";

Cout1<=cB when Sel1(3 downto 2)="01"
else cC when Sel1(3 downto 2)="10"
else cD when Sel1(3 downto 2)="11"
else cA when Sel1(3 downto 2)="00";
end archPartBCDCombined;
