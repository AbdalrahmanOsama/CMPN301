library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity counter is
  port (
       clk, rst  : in std_logic;
      out1 : out std_logic_vector (3 downto 0)
  ) ;
end counter;

architecture arch1 of counter is
begin
    process(clk, rst)
    variable var : integer;
    begin
        if rising_edge(rst) then 
            var := 0;
        elsif rising_edge(clk) and var = 10  then
            var := 0;
        elsif rising_edge(clk) then
            var := var + 1;
        end if;
        out1 <= std_logic_vector(to_unsigned(var,4)); -- Value   ---> variable
    end process ; -- identifier
end arch1 ; -- arch1