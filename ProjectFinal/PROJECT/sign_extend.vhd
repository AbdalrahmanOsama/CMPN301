Library IEEE;
USE IEEE.Std_logic_1164.all;

entity sign_extend_16_32 is 
   port(
      input : in std_logic_vector(15 downto 0);    
      output :out  std_logic_vector(31 downto 0)
   );


end sign_extend_16_32;
architecture Behavioral of sign_extend_16_32 is  
begin  
 
output <= X"0000" & input;
end Behavioral; 