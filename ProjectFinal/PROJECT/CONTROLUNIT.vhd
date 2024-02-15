library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is 
port(
Opcode_buff:in std_logic_vector(4 downto 0);
index:in std_logic;
Excution_signals:out std_logic_vector(14 downto 0);
Memory_signals:out std_logic_vector(12 downto 0);
Writeback_signals:out std_logic_vector(6 downto 0)
);
end control;

architecture control_arch of control is
component Execution_Control IS
PORT (
	OP_TYPE: IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
	OP_FUNC: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	ALU_OP: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	IN_OP: OUT STD_LOGIC;
	ONE_OP: OUT STD_LOGIC;
	CCR_W_EN: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	JMP_TYP: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	JMP_OP: OUT STD_LOGIC;
	SRC1: OUT STD_LOGIC;
	SRC2: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)); 
END COMPONENT;
component memory_CU is
port(
OP_type:in std_logic_vector(1 downto 0);
OP_function:in std_logic_vector(2 downto 0);
Stack_op:out std_logic;--m1
push,pop:out std_logic;--m2,m3
MEMW,MEMR:out std_logic;--m4,m5
mux1:out std_logic;--m6
index:in std_logic;
memory_c:out std_logic;--m7
mux2:out std_logic_vector(1 downto 0);--m8
RT_RTI_RET:out std_logic;
WB_INSTR: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
);
end component;
component WB_Control IS
PORT (
OP_TYPE: IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
OP_FUNC: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
REG_W_EN: OUT STD_LOGIC; 	
WB_ADD: OUT STD_LOGIC; 		
WB_DATA: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
OUT_EN: OUT STD_LOGIC;		
SWAP: OUT STD_LOGIC);		
END component;
signal e2,e3, E6, E7:std_logic;
signal e1:std_logic_vector(3 downto 0);
signal e4:std_logic_vector(2 downto 0);
SIGNAL E5, E8 : STD_LOGIC_VECTOR(1 DOWNTO 0);

signal m1,m2,m3,m4,m5,m6,m8,m9:std_logic;
signal m7:std_logic_vector(1 downto 0);
signal m10:std_logic_vector(2 downto 0);

signal w1,w2,w4,w5:std_logic;
signal w3:std_logic_vector(2 downto 0);
begin 
f0:Execution_Control port map(Opcode_buff(4 downto 3),Opcode_buff(2 downto 0),e1,e2,e3,e4,E5,E6,E7,E8);
f1:memory_CU port map(Opcode_buff(4 downto 3),Opcode_buff(2 downto 0),m1,m2,m3,m4,m5,m6,index,m8,m7,m9,m10);
f2:WB_Control port map(Opcode_buff(4 downto 3),Opcode_buff(2 downto 0),w1,w2,w3,w4,w5);
Excution_signals <= e1&e2&e3&e4 & E5&E6&E7&E8;
Memory_signals <= m1&m2&m3&m4&m5&m5&m8&m7&m9&m10;
Writeback_signals <= w1&w2&w3&w4&w5;
end control_arch;