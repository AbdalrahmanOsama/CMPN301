Library ieee;
Use ieee.std_logic_1164.all;

entity MEM_WB_Buffer is
port( 
--Inputs
Clk,Flush  : in std_logic;
stall_wb: in std_logic;
Reg_data1: in std_logic_vector(31 downto 0); 
Reg_data2: in std_logic_vector(31 downto 0); 
IMM: in std_logic_vector(31 downto 0); 
W_add1: in std_logic_vector(2 downto 0); 
W_add2: in std_logic_vector(2 downto 0); 
ALU: in std_logic_vector(31 downto 0);
memdata: in std_logic_vector(31 downto 0);
--Control Signals
wb: in std_logic_vector(6 downto 0);
--Outputs
Reg_data1_out: out std_logic_vector(31 downto 0); 
Reg_data2_out: out std_logic_vector(31 downto 0); 
IMM_out: out std_logic_vector(31 downto 0); 
W_add1_out: out std_logic_vector(2 downto 0); 
W_add2_out: out std_logic_vector(2 downto 0); 
ALU_out: out std_logic_vector(31 downto 0);
memdata_out: out std_logic_vector(31 downto 0);
wb_out: out std_logic_vector(6 downto 0)
);
end  MEM_WB_Buffer ;

architecture  MEM_WB_Buffer of MEM_WB_Buffer  is
begin

PROCESS (Clk)


BEGIN
if(falling_edge(clk) and Flush = '1' )then


Reg_data1_out      <= (OTHERS=>'0');
Reg_data2_out            <= (OTHERS=>'0');
IMM_out                  <= (OTHERS=>'0');
W_add1_out               <= (OTHERS=>'0');
W_add2_out               <= (OTHERS=>'0');
ALU_out                  <= (OTHERS=>'0');
memdata_out          <= (OTHERS=>'0');


wb_out  <=  (OTHERS=>'0');


elsif( falling_edge(Clk) and stall_wb = '0')then



Reg_data1_out<= Reg_data1;
Reg_data2_out<= Reg_data2;
IMM_out<= IMM;
W_add1_out<= W_add1; 
W_add2_out<= W_add2 ;
ALU_out<= ALU;  
memdata_out<= memdata;

wb_out  <=  wb;

   
END if;
END process;
	

end  MEM_WB_Buffer ;



