LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY a_my_adder IS
Generic ( n : Integer:= 32);
PORT (
a:IN std_logic_vector (n-1 DOWNTO 0);
cin : IN  std_logic;
s: OUT std_logic_vector (n-1 DOWNTO 0)
);
END a_my_adder;

ARCHITECTURE a_my_adder OF a_my_adder IS


COMPONENT my_adder IS
PORT (a,b,cin : IN  std_logic;
s, cout : OUT std_logic 
);
END COMPONENT;

SIGNAL temp : std_logic_vector(n-1 DOWNTO 0);
SIGNAL b : std_logic_vector(n-1 DOWNTO 0);
BEGIN
b<=(1=>'1', Others=>'0'); --constant 2

f0: my_adder PORT MAP(a(0),b(0),cin,s(0),temp(0));
loop1: FOR i IN 1 TO n-1 GENERATE
        fx: my_adder PORT MAP(a(i),b(i),temp(i-1),s(i),temp(i));
END GENERATE;
END architecture a_my_adder;
