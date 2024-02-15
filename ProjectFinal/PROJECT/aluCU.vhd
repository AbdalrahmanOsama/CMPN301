LIBRARY IEEE;
USE IEEE.std_logic_1164.all;



ENTITY aluCU IS
port(
	execOUT: in std_logic_vector(3 downto 0); -- el msb howa el enable, wel talata el ba2yeen homa el aluOP

	aluEn: out std_logic;
	aluOP: out std_logic_vector(2 downto 0) -- da ely howa input "s" fel alu
);
end aluCU;

------------------------------------------------------------
------------------------------------------------------------

architecture arch_aluCU of aluCU is
begin

aluEn <= execOUT(3);
aluOP <= execOUT(2 downto 0);

end arch_aluCU;
