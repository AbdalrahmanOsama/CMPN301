--------------------------------------------------------------
-- fpgagate.com: FPGA Projects, VHDL Tutorials, VHDL projects 
-- Memory initialization in VHDL
--------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity mem_array is 
  generic( DATA_WIDTH: integer := 32;
              ADDR_WIDTH: integer := 20;
              INIT_FILE: string := "Memoryfile.txt");

  port(ADDR: in std_logic_vector(ADDR_WIDTH-1 downto 0);
    DATAIN : in std_logic_vector(DATA_WIDTH-1 downto 0);
    CLK : in std_logic;
    WE : in std_logic;
    OUTPUT : out std_logic_vector(DATA_WIDTH-1 downto 0));
end mem_array;

architecture behavioral of mem_array is
--Memory array
Type MEMORY_ARRAY is array(0 to (2**ADDR_WIDTH)-1) of std_logic_vector(DATA_WIDTH-1 downto 0);

------------------------------------
-- function to initialize memory content
function init_memory_wfile(mif_file_name : in string) return MEMORY_ARRAY is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
    variable temp_mem : MEMORY_ARRAY;
begin
    for i in MEMORY_ARRAY'range loop
        readline(mif_file, mif_line);
        read(mif_line, temp_bv);
        temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
end function;
-------------------------------------
signal Memory: MEMORY_ARRAY := init_memory_wfile(INIT_FILE);
begin
process(clk) is
    begin
    if rising_edge(clk) then
        if we='1' then
            Memory(to_integer(unsigned(ADDR))) <= DATAIN;
        end if;
       OUTPUT <= Memory(to_integer(unsigned(ADDR)));
    end if;
end process;

end behavioral;

