library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity memory is 
generic(Initial_File: string := "MemoryFile.txt");
port(
addressused: in std_logic_vector(19 downto 0); 
datain: in std_logic_vector(31 downto 0);
dataout: out std_logic_vector(31 downto 0);
mem_re,mem_write: in std_logic; 
Clk:in std_logic
);
end entity;

architecture memory_arch of memory is
subtype word is std_logic_vector(31 downto 0);
type DataMem is array(0 to 1048576) of word ;
-----------------------------------------------------------
function Initialize_Memory(FileName : in string) return DataMem is
    file Mem_File : text open read_mode is FileName;
    variable FLine : line;
    variable Temp_BitVector : bit_vector(31 downto 0);
    variable Temp_MEM : DataMem;
begin
    for i in DataMem'range loop
        readline(Mem_File, FLine);
        read(FLine, Temp_BitVector);
        Temp_MEM(i) := to_stdlogicvector(Temp_BitVector);
    end loop;
    return Temp_MEM;
end function;
-----------------------------------------------------------
signal data_mem: DataMem:= Initialize_Memory(Initial_File);
begin
process(Clk)
begin
if rising_edge(Clk) and mem_write = '1' then 
data_mem(to_integer(unsigned(addressused(19 downto 0)))) <= datain;
elsif rising_edge(Clk) and mem_re ='1' then 
dataout <= data_mem(to_integer(unsigned(addressused(19 downto 0))));
end if;
end process;
end memory_arch;