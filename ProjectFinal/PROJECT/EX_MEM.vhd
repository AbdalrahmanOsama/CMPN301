Library ieee;
Use ieee.std_logic_1164.all;

entity EX_MEM_Buffer is
port( 
--Inputs
Clk,Flush, STALL  : in std_logic;
Pc       : in std_logic_vector(31 downto 0);
Pc_plus    : in std_logic_vector(31 downto 0);
Reg_data1   : in std_logic_vector(31 downto 0); 
Reg_data2  : in std_logic_vector(31 downto 0); 
IMM        : in std_logic_vector(31 downto 0); 
W_add1     : in std_logic_vector(2 downto 0); 
W_add2     : in std_logic_vector(2 downto 0); 
ALU        : in std_logic_vector(31 downto 0);

--Control Signals

mem	: in std_logic_vector(12 downto 0);--10bits
wb	: in std_logic_vector(6 downto 0);--6bits

--Outputs
Pc_out         : out std_logic_vector(31 downto 0);
Pc_plus_out      : out std_logic_vector(31 downto 0);
Reg_data1_out   : out std_logic_vector(31 downto 0); 
Reg_data2_out    : out std_logic_vector(31 downto 0); 
IMM_out          : out std_logic_vector(31 downto 0); 
W_add1_out       : out std_logic_vector(2 downto 0); 
W_add2_out       : out std_logic_vector(2 downto 0); 
ALU_out          : out std_logic_vector(31 downto 0);


mem_out	: out std_logic_vector(12 downto 0);
wb_out	: out std_logic_vector(6 downto 0)

);
end  EX_MEM_Buffer ;

architecture  EX_MEM_Buffer of  EX_MEM_Buffer  is
begin

PROCESS (Clk)
BEGIN
if(falling_edge(clk) and Flush = '1' )then

Pc_out          <= (OTHERS=>'0');
Pc_plus_out       <= (OTHERS=>'0');
Reg_data1_out      <= (OTHERS=>'0');
Reg_data2_out            <= (OTHERS=>'0');
IMM_out                  <= (OTHERS=>'0');
W_add1_out               <= (OTHERS=>'0');
W_add2_out               <= (OTHERS=>'0');
ALU_out                  <= (OTHERS=>'0');

mem_out	<=  (OTHERS=>'0');
wb_out  <=  (OTHERS=>'0');



elsif( falling_edge(Clk) and STALL = '0')then

Pc_out        <= Pc;
Pc_plus_out     <= Pc_plus;
Reg_data1_out      <= Reg_data1;
Reg_data2_out            <= Reg_data2;
IMM_out                  <= IMM;
W_add1_out               <= W_add1; 
W_add2_out               <= W_add2 ;
ALU_out                  <= ALU;  


mem_out	<=  mem;
wb_out  <=  wb;

END if;
END process;
	

end  EX_MEM_Buffer ;