library ieee;
use ieee.std_logic_1164.all;
entity mux2X1 is 
    port (
        in1, in2 : std_logic_vector (3 downto 0);
        sel : in  std_logic;
        out1          : out std_logic_vector (3 downto 0)
    );
end entity mux2X1;

architecture arch1 of mux2X1 is
    begin
        out1 <= in1 when sel = '0'
        else in2;
    end arch1;