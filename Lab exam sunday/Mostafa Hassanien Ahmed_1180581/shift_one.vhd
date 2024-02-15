library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_signed.all;
entity shift_one is
  port (
    in1 : in std_logic_vector (19 downto 0);
    out1 : out std_logic_vector (19 downto 0)
  ) ;
end shift_one;


architecture arch1 of shift_one is
begin
    out1 <= in1 (18 downto 0) & '0';
end arch1 ; -- arch1