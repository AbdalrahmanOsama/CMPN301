LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PC is
port (
 Clk : IN  std_logic;
 Reset : IN  std_logic;
 PC_WRITE :IN  std_logic; 
 OUT_MUX : IN std_logic_vector (31 DOWNTO 0);
 PC_OUT: OUT std_logic_vector (31 DOWNTO 0)
);
End PC;

architecture PC of PC is

begin 

setPC:process(Clk,Reset)
variable PC:std_logic_vector(31 downto 0):="00000000000000000000000000000000";
begin
        if(Reset = '1')then
                PC_OUT<=(others=>'0');
        elsif (rising_edge(Clk))then
                if (PC_WRITE = '1' ) then
                        PC_OUT<= OUT_MUX ;
      end if;
   end if;  
end process setPC;



end architecture;