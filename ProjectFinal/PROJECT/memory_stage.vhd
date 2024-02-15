library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity memory_stage is 
port(
memory_en:in std_logic;
Stackoper:in std_logic;
stack_push,stack_pop:in std_logic;
datain1,datain2: in std_logic_vector(31 downto 0);
outrange: out std_logic;
Clk,Rst,en:in std_logic;
operandsselect:in std_logic_vector(1 downto 0);
addparsed:out std_logic_vector(19 downto 0);
datamemorydata:out std_logic_vector(31 downto 0); 
rsignal,wsignal:in std_logic;
datafinal:in std_logic_vector(31 downto 0);
mux11,mux12,mux21,mux22,mux23,mux24: in std_logic_vector(31 downto 0);
readsig,writesig: out std_logic;
memeout:out std_logic_vector(31 downto 0)
);
end memory_stage;

architecture memory_stage_arch of memory_stage is
component memory_access is 
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
end component;
component stack_reg IS
GENERIC ( n : integer := 32);
PORT( 
Clk,Rst,En : IN std_logic;
push,pop: in std_logic;
out_of_range:out std_logic;
q : OUT std_logic_vector(n-1 DOWNTO 0)
);

END component;
component MUX2x1 is 
Generic(DataSize: integer :=32);
port(
Input1,Input2: in std_logic_vector(DataSize-1 DOWNTO 0);
SEL : in std_logic;
F: out std_logic_vector(DataSize-1 DOWNTO 0));
end component;
component MUX4x2 is 
Generic(DataSize: integer :=32);
port(
Input1,Input2,Input3,Input4 : in std_logic_vector(DataSize-1 DOWNTO 0);
SEL : in std_logic_VECTOR(1 downto 0);
F: out std_logic_vector(DataSize-1 DOWNTO 0));
end component;
signal x1,x2,x3:std_logic_vector(31 downto 0);
signal check1,check2: std_logic;
signal StackOperation:std_logic;
begin
StackOperation<=Stackoper;
f0:stack_reg port map(Clk,Rst,'1',stack_push,stack_pop,check1,x1);
f1:memory_access port map(memory_en,x3,addparsed,x2,memeout,datamemorydata,datafinal,rsignal,wsignal,check2,readsig,writesig);
f3:MUX4x2 generic map(32) port map(mux21,mux22,mux23,mux24,operandsselect,x2);
f4:MUX2x1 generic map(32) port map(mux11,mux12,StackOperation,x3);
outrange <= check1 or check2;
end architecture;









