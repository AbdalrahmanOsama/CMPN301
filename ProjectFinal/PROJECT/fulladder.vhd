--completed
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY fulladder IS



GENERIC (n : integer := 32);

	PORT (


aa,bb: IN  std_logic_vector(n-1 downto 0);

ccin : IN  std_logic;

ff : out std_logic_vector(n-1 downto 0);

ccout : OUT std_logic 



);
END fulladder;


-----------------------------------
-----------------------------------


ARCHITECTURE arch_fulladder OF fulladder IS

component basic_adder is



PORT (

a : IN  std_logic;
b : IN  std_logic;
cin : IN  std_logic;
f : OUT  std_logic;
cout : OUT std_logic );

end component;


SIGNAL temp : std_logic_vector(n DOWNTO 0);
	BEGIN
temp(0) <= ccin;

loop1: for i in 0 to n-1 generate

  fx: basic_adder PORT MAP(aa(i),bb(i),temp(i),ff(i),temp(i+1));

		
	end generate;

ccout <= temp(n);
			
		
END arch_fulladder;




