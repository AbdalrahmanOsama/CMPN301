
lIBRARY IEEE; 
USE IEEE.std_logic_1164.all; 

ENTITY Registers IS 
GENERIC ( dataSize : integer := 32);
PORT( 
d1 :IN std_logic_vector(dataSize-1 downto 0);
clk,rst,enb1 : IN std_logic;   
q : OUT std_logic_vector(dataSize-1 downto 0)); 
END Registers;


ARCHITECTURE a_Registers OF Registers IS 
BEGIN 
  
PROCESS(clk,rst) 
BEGIN 
IF(rst = '1') THEN 
q <= (OTHERS=>'0');
 ELSIF rising_edge(clk)  THEN 
     if (enb1 ='1')then
       q <= d1;
      END IF;
   End IF;
      END PROCESS; 
      END A_Registers;