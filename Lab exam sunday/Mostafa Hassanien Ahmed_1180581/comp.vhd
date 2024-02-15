library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity comp is
  port (
    in1 : in std_logic_vector (19 downto 0);
    ones, tens, hundereds : out std_logic
  ) ;
end comp;
architecture arch2 of comp is
    
begin
     process( in1 )
     variable var1, var2, var3 : integer;
    begin
    var1 := to_integer(unsigned(in1(11 downto 8)));          -- address ---> std_logic_vector
    var2 := to_integer(unsigned(in1(15 downto 12)));          -- address ---> std_logic_vector
    var3 := to_integer(unsigned(in1(19 downto 16)));          -- address ---> std_logic_vector
        if var1 >= 5 then
            ones <= '1' ;
        else 
            ones <= '0';
        end if;
        if var2 >= 5 then
            tens <= '1' ;
        else 
            tens <= '0';
        end if;
        if var3 >= 5 then
            hundereds <= '1' ;
        else 
        hundereds <= '0';
        end if;
    end process ; -- 
    
end arch2 ; -- arch2


