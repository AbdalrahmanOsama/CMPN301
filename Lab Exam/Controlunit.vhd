LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


Entity ControlUnit IS
	Port(	CountIn:in std_logic_vector(2 downto 0);
		clk:in std_logic;
		re:out std_logic;
		we:out std_logic;
		CountEn:out std_logic;
		address:out std_logic_vector(19 downto 0));
end entity ControlUnit;


architecture archCU of ControlUnit is
signal state: std_logic:='0';
begin

	process(CountIn,state)
		begin
			if CountIn="000" then
				CountEn<='1';
			elsif CountIn="001" then
				address<=x"00200";
				we<='1';
				re<='0';
			elsif CountIn="010" then
				address<=x"00200";
				we<='0';
				re<='1';
			elsif CountIn="011" then
				if (state='0') then
					CountEn<='0';
					re<='0';
					we<='1';
					address<=x"00500";
				elsif(state='1') then
					re<='0';
					we<='1';
					address<=x"00501";
					CountEn<='1';
				end if;

			else
				we<='0';
				re<='0';
				CountEn<='1';
			end if;
	end process;
	process(clk)
	begin
		if (rising_edge(clk) and CountIn="011") then
			if (state='0') then
				state<='1';
			else
				state<='0';
			end if;
		end if;
	end process;
end archCU;
