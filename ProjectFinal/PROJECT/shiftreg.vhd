library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shift_register2 is
    Port ( MYIN : in STD_LOGIC_VECTOR (31 downto 0);
             E   : in  STD_LOGIC;
             Clk : in  STD_LOGIC;
             Rst : in  STD_LOGIC;
           MYOUT : out STD_LOGIC_VECTOR (31 downto 0)
);
end shift_register2;

architecture Behavioral of shift_register2 is
BEGIN
PROCESS (Clk,Rst)
BEGIN

IF rising_edge(Clk) THEN
	IF E= '1' THEN
	 MYOUT(30 downto 0) <= MYIN(31 downto 1);
              MYOUT(31) <= MYIN(0);
	END IF;
END IF;

END PROCESS;
   
end Behavioral;