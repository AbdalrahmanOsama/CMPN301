library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity ctr is
  port (
    in1 : in std_logic_vector (3 downto 0);
    valid, en, sel : out std_logic
  ) ;
end ctr;


architecture arch1 of ctr is
begin
    with in1 select
    valid <= '1' when "1001",
        '0' when OTHERS;
    with in1 select
    en <= '1' when "0000",
        '0' when OTHERS;
    with in1 select
        sel <= '1' when "0001",
            '0' when OTHERS;

end arch1 ; -- arch1