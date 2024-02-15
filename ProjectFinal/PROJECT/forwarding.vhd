Library ieee;
use ieee.std_logic_1164.all; 
entity FWD is 
port(
buff_fetch_decode:in std_logic;
ID_EX_wr_Add_1:in std_logic_vector(2 downto 0);
EX_MEM_wr_Add_1:in std_logic_vector(2 downto 0);
MEM_WB_wr_Add_1:in std_logic_vector(2 downto 0);
--add,sub,pop

ID_EX_wr_Add_2:in std_logic_vector(2 downto 0);
EX_MEM_wr_Add_2:in std_logic_vector(2 downto 0);
MEM_WB_wr_Add_2:in std_logic_vector(2 downto 0);



HD_Unit_exception:in std_logic;


subselect1:out std_logic;
subselect2:out std_logic;

selector_1:out std_logic;
selector_2:out std_logic
);
end FWD;
architecture A_FWD of FWD is
begin
selector_1 <= '0' when ID_EX_wr_Add_1=EX_MEM_wr_Add_1 or HD_Unit_exception='1'
else '1' when ID_EX_wr_Add_1=MEM_WB_wr_Add_1;

subselect1 <= '1' when ID_EX_wr_Add_1=EX_MEM_wr_Add_1 or ID_EX_wr_Add_1=MEM_WB_wr_Add_1 else '0' when HD_Unit_exception='1';
subselect2 <= '1' when ID_EX_wr_Add_2=EX_MEM_wr_Add_1 or ID_EX_wr_Add_2=MEM_WB_wr_Add_1 else '0' when HD_Unit_exception='1';

selector_2 <= '0' when ID_EX_wr_Add_2=EX_MEM_wr_Add_1 or HD_Unit_exception='1'
else '1' when ID_EX_wr_Add_2=MEM_WB_wr_Add_1;



end architecture;