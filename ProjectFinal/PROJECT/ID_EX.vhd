Library ieee;
Use ieee.std_logic_1164.all;

entity ID_EX_Buffer is
port( 
--Inputs
Clk,Flush, STALL : in std_logic;
Pc       : in std_logic_vector(31 downto 0);
Pc_plus    : in std_logic_vector(31 downto 0);
Reg_data1   : in std_logic_vector(31 downto 0); 
Reg_data2  : in std_logic_vector(31 downto 0); 
IMM        : in std_logic_vector(15 downto 0); 
W_add1     : in std_logic_vector(2 downto 0); 
W_add2     : in std_logic_vector(2 downto 0); 
load_use_in   : in std_logic;
INDX :IN STD_LOGIC_VECTOR(1 DOWNTO 0);
--Control Signals
ex	: in std_logic_vector(12 downto 0);--13bits
mem	: in std_logic_vector(12 downto 0);--10bits
wb	: in std_logic_vector(6 downto 0);--6bits
--Outputs


Pc_out         : out std_logic_vector(31 downto 0);
Pc_plus_out      : out std_logic_vector(31 downto 0);
Reg_data1_out   : out std_logic_vector(31 downto 0); 
Reg_data2_out    : out std_logic_vector(31 downto 0); 
IMM_out          : out std_logic_vector(15 downto 0); 
W_add1_out       : out std_logic_vector(2 downto 0); 
W_add2_out       : out std_logic_vector(2 downto 0); 
load_use_out         : out std_logic; 


ex_out 	        : out std_logic_vector(12 downto 0);--13bits
mem_out	        : out std_logic_vector(12 downto 0);--10bits
wb_out	        : out std_logic_vector(6 downto 0);--6bits
INDX_OUT :OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
);
end ID_EX_Buffer ;

architecture ID_EX_Buffer  of ID_EX_Buffer  is
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
load_use_out             <= '0';
ex_out 	         <= (OTHERS=>'0');
mem_out 	         <= (OTHERS=>'0');
wb_out 	         <= (OTHERS=>'0');
INDX_OUT <=(OTHERS=>'0');

elsif( falling_edge(Clk) and STALL = '0')then

Pc_out        <= Pc;
Pc_plus_out     <= Pc_plus;
Reg_data1_out      <= Reg_data1;
Reg_data2_out            <= Reg_data2;
IMM_out                  <= IMM;
W_add1_out               <= W_add1; 
W_add2_out               <= W_add2 ;
load_use_out             <= load_use_in;
ex_out 	         <= ex;
mem_out 	         <= mem;
wb_out <= wb;
INDX_OUT <= INDX;
END if;
END process;
	

end ID_EX_Buffer ;
