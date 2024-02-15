library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_access is 
port(
en_access:in std_logic;
address_access: in std_logic_vector(31 downto 0);
address_access_mem: out std_logic_vector(19 downto 0);
datain_access: in std_logic_vector(31 downto 0);
dataout_access: out std_logic_vector(31 downto 0);
datain_access_mem: out std_logic_vector(31 downto 0);
dataout_access_mem: in std_logic_vector(31 downto 0);
mem_read,mem_wr: in std_logic;
mem_out_of_range: out std_logic;
mem_read_access_out,mem_wr_access_out: out std_logic
);
end memory_access;

architecture access_architecture of memory_access is 
begin
mem_out_of_range <= '0' when (address_access(31 downto 20) or address_access(31 downto 20))="000000000000"
else '1';
process(mem_read,mem_wr,en_access)
begin
if en_access = '1' then
mem_read_access_out <= mem_read;
mem_wr_access_out  <= mem_wr; 
address_access_mem <= address_access(19 downto 0);
datain_access_mem  <= datain_access;
dataout_access <= dataout_access_mem;
end if;
end process;
end architecture;