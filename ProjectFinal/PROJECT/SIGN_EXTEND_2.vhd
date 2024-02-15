Library IEEE;
USE IEEE.Std_logic_1164.all;

entity sign_extend_2_32 is 
   port(
      input : in std_logic_vector(1 downto 0);    
      output :out  std_logic_vector(31 downto 0)
   );


end sign_extend_2_32;
architecture Behavioral of sign_extend_2_32 is 
SIGNAL SIGN_BIT: STD_LOGIC; 
SIGNAL EXTENSION: STD_LOGIC_VECTOR(29 DOWNTO 0);
begin  
SIGN_BIT <= input(1);
EXTENSION <= (OTHERS=>SIGN_BIT);
output <= EXTENSION & input;
end Behavioral; 