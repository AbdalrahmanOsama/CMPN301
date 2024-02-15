
-- Completed



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;



entity singleunit is 



GENERIC (n : integer := 32);

port(


   -- CLK: in std_logic;
    En: in std_logic;
    a : in std_logic_vector(n-1 downto 0);
    b : in std_logic_vector(n-1 downto 0);
    

      s: in std_logic_vector(2 downto 0);
  
    --cin: in std_logic;

    f: out std_logic_vector(n-1 downto 0);
    --cout: out std_logic;
    CFout: out std_logic;
    --flagreset: out std_logic_vector(2 downto 0) -- ether 111 or Z da el 3 bit version
    flagreset: out std_logic                 -- ether 111 or Z da el 1 bit version
     




);


end singleunit;


-------------------------------------
-------------------------------------


Architecture arch_singleunit of singleunit is


--CONSTANT nve : integer : = -1;


component fulladder is

GENERIC (n : integer := 32);

port(


aa,bb: IN  std_logic_vector(n-1 downto 0);

ccin : IN  std_logic;

ff : out std_logic_vector(n-1 downto 0);

ccout : OUT std_logic 



);

end component;

signal Bsignal : std_logic_vector(n-1 DOWNTO 0);
--signal CFoutsignal : std_logic;
--signal coutsignal : std_logic;
signal fsignal : std_logic_vector(n-1 downto 0);
signal CinSignal: std_logic;
signal CoutSignal: std_logic;

begin


--port mapping




compadder: fulladder generic map (32) port map (a, Bsignal, CinSignal, fsignal, CoutSignal);




-- el tarteeb beta3 el selection lines zay tarteeb el alu instrucrions bta3na


-- 3bit flag reset
--flagreset <= "111" when s = "111" --RESETF
--else (others => 'Z');

--1 bit flag reset
flagreset <= 'Z' when En = '0'
else '1' when s = "111" --RESETF
else 'Z';



f <=  (others => 'Z') when En = '0' or s= "000" or s= "111"
else not a when s = "001" -- not A
else a and b when s = "110" -- A and B
else fsignal when s= "010" or s= "011" or s= "100" or s= "101";




Bsignal <= (others => '1') when s = "011" -- dec
else (n-1 downto 1 => '0' ) & '1'  when s = "010"  --inc
else b when s = "100" -- add
else std_logic_vector(to_signed((-1*to_integer(unsigned(b))),n)) when s = "101"; --sub -- di kan leeha taree2a tanya eny a3mel not b wel cin a5aleeh 1 bas ana faker enaha kanet betbawaz 7aga fel output betala3o 8alat

CinSignal <= '0';


CFout <= 'Z' when En = '0'
else '1' when s = "000" --setc
else 'Z' when s = "111" --resetf
else 'Z' when s = "110" --and
else 'Z' when s = "001" --not
else 'Z' when s = "010" --inc
else 'Z' when s = "011" --dec
else not CoutSignal when s="101" --sub
else CoutSignal; --add 








end arch_singleunit;
