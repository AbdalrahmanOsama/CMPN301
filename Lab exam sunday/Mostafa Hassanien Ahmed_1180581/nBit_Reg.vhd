library ieee;
use ieee.std_logic_1164.all;
entity nBit_Reg is
  generic (n : integer := 8);
  port (
    d         : in std_logic_vector  (n - 1 downto 0);
    clk, rst, en  : in std_logic;
    q         : out std_logic_vector (n - 1 downto 0)
  ) ;
end nBit_Reg;

architecture arch1 of nBit_Reg is
    begin
        process (clk, rst)
            begin
                if falling_edge(rst)   then q <= (others => '0');
                elsif rising_edge(clk) and en = '1' then q <= d;
                end if;
            end process;
    end arch1 ; -- arch1