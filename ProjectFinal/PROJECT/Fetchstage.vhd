library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity fetch_stage is 
port(
Clk: in std_logic;
HZvalue:in std_logic_vector(31 downto 0);
HZindicator:in std_logic;
jmp_decision:in std_logic_vector(31 downto 0);
in_port:in std_logic_vector(31 downto 0);
in_port_output:out std_logic_vector(31 downto 0);
RST_fetch:in std_logic;
int_fetch:in std_logic;
pc0:out std_logic_vector(31 downto 0);
pc1:out std_logic_vector(31 downto 0);
mem_address_to_mem:out std_logic_vector(31 downto 0);
mem_address_from_mem:in std_logic_vector(31 downto 0);
mem_address2:in std_logic;
ALU_Branch_result:in std_logic;
instruction_fetched:out std_logic_vector(31 downto 0)
);
end fetch_stage;

architecture arch_fetcher of fetch_stage is
component triStateBuffer is
  GENERIC ( dataSize : integer := 32);
  Port ( Input    : in std_logic_vector(dataSize-1 downto 0);    -- single buffer input
           EN   : in  STD_LOGIC;    -- single buffer enable
           Output   : out  std_logic_vector(dataSize-1 downto 0)   -- single buffer output
           );
end component; 
component fetch is 
port(
address:in std_logic_vector(31 downto 0);
memaddress: out std_logic_vector(31 downto 0);
meminstruction: in std_logic_vector(31 downto 0);
dataout_fetch: out std_logic_vector(31 downto 0) 
);
end component;
component MUX4x2 is 
Generic(DataSize: integer :=32);
port(
Input1,Input2,Input3,Input4 : in std_logic_vector(DataSize-1 DOWNTO 0);
SEL : in std_logic_VECTOR(1 downto 0);
F: out std_logic_vector(DataSize-1 DOWNTO 0));
end component;
component MUX2x1 is 
Generic(DataSize: integer :=32);
port(
Input1,Input2: in std_logic_vector(DataSize-1 DOWNTO 0);
SEL : in std_logic;
F: out std_logic_vector(DataSize-1 DOWNTO 0));
end component;
component PC is
port (
 Clk : IN  std_logic;
 Reset : IN  std_logic;
 PC_WRITE :IN  std_logic; 
 OUT_MUX : IN std_logic_vector (31 DOWNTO 0);
 PC_OUT: OUT std_logic_vector (31 DOWNTO 0)
);
End component;
signal f1,f2,f3,f4,f5,f6,f7:std_logic_vector(31 downto 0);
signal i1,i2,i3,i4,i5,i6:std_logic;
signal ii:std_logic_vector(1 downto 0);
begin
ii <= HZindicator &  (HZindicator xor i1);
i1 <= (not ALU_Branch_result) nor '0';
x0:fetch port map(f2,mem_address_to_mem,mem_address_from_mem,f5);
x1:PC port map(Clk,RST_fetch,'1',f1,f2);
x2:MUX2x1 generic map(32) port map(f5,"00000000000000000000000000000100",int_fetch,instruction_fetched);
x3:MUX4x2 generic map(32) port map(f3,HZvalue,jmp_decision,(Others=>'0'),"00",f4);
x4:MUX2x1 generic map(32) port map(f4,(Others=>'0'),"00",f6);
f3 <= std_logic_vector(to_unsigned(to_integer(unsigned(f2))+1,32));
pc0 <= f2;
pc1 <= std_logic_vector(to_unsigned(to_integer(unsigned(f2))+1,32));
end arch_fetcher;