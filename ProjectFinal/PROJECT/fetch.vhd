Library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity fetch is 
port(
address:in std_logic_vector(31 downto 0);
memaddress: out std_logic_vector(31 downto 0);
meminstruction: in std_logic_vector(31 downto 0);
dataout_fetch: out std_logic_vector(31 downto 0) 
);
end fetch;

architecture fetch_arch of fetch is 
begin
process(address)
begin 
memaddress <= address;
dataout_fetch <= meminstruction;
end process;
end architecture;