LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity BranchDecoder is
port(InputInst:in std_logic_vector (31 downto 0); clk:in std_logic; OutputAddress:out std_logic_vector (26 downto 0); 
OutputCmd:out std_logic_vector(1 downto 0); BrALUen:out std_logic; OutofRange:out std_logic);
end entity BranchDecoder;

architecture archBranchDecoder of BranchDecoder is



begin


OutofRange <= '0' when (InputInst(31 downto 25) or InputInst(31 downto 25))="0000000"
	else '1';

process(clk)
begin
	if rising_edge(clk) then
		if InputInst(1 downto 0)="11" then
			OutputAddress<=InputInst(31 downto 5);
			if InputInst(4 downto 2)="100" then
				BrALUen<='1';
				OutputCmd<="00";
			elsif InputInst(4 downto 2)="010" then
				BrALUen<='1';
				OutputCmd<="01";
			elsif InputInst(4 downto 2)="110" then
				BrALUen<='1';
				OutputCmd<="10";
			else
				BrALUen<='1';
				OutputCmd<="11";
			end if;
		else
			BrALUen<='0';
			OutputCmd<="00";
			OutputAddress<=(Others=>'0');
		end if;
	end if;
end process;

end archBranchDecoder;
