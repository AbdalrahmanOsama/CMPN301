LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity BranchExec is
port(TargetAddress:in std_logic_vector(31 downto 0);BranchType:in std_logic_vector(1 downto 0); en,clk:in std_logic; 
FlagStatus:in std_logic_vector(2 downto 0); JumpDecision:out std_logic; JumpAddress:out std_logic_vector(31 downto 0));
end entity BranchExec;


architecture archBranchExec of BranchExec is
begin

process(clk,en)

begin
	if(en='0') then
		JumpAddress<=(others=>'0');
		JumpDecision<='0';
	else
		if(rising_edge(clk)) then
			if(BranchType="00" and FlagStatus="001") then
				JumpAddress<=TargetAddress;
				JumpDecision<='1';
			elsif(BranchType="01" and FlagStatus="010")then
				JumpAddress<=TargetAddress;
				JumpDecision<='1';
			elsif(BranchType="10" and FlagStatus="100")then
				JumpAddress<=TargetAddress;
				JumpDecision<='1';
			elsif(BranchType="11")then
				JumpAddress<=TargetAddress;
				JumpDecision<='1';
			else
				JumpAddress<=(others=>'0');
				JumpDecision<='0';
			end if;
		end if;
	end if;
end process;

end archBranchExec;
