
Library ieee;
use ieee.std_logic_1164.all;
entity Decoder is 
  port(
Enable : in std_logic;
Address: in std_logic_vector(2 DOWNTO 0);
Output: out std_logic_vector(7 downto 0)
);
end entity;



Architecture a_Decoder of Decoder is
begin
  
  Output <="00000000" when (Enable = '0')
  else "00000001" when (Address = "000")
  else "00000010" when(Address = "001")
  else "00000100" when(Address = "010")
  else "00001000" when(Address = "011")
  else "00010000" when(Address = "100")
  else "00100000" when(Address = "101")
  else "01000000" when(Address = "110")
  else "10000000" when(Address = "111");
       
end Architecture;
