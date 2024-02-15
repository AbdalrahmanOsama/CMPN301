Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
port(
CLK_processor:in std_logic;
RST_processor,interupt:in std_logic;
IN_port_value:in std_logic_vector(31 downto 0);
Out_port_value:out std_logic_vector(31 downto 0)
);
end processor;




architecture arch_processor of processor is 
component fetch_stage is 
port(
Clk: in std_logic; --CLK_process
HZvalue:in std_logic_vector(31 downto 0);--F1
HZindicator:in std_logic;--F11
jmp_decision:in std_logic_vector(31 downto 0);--F2
in_port:in std_logic_vector(31 downto 0);--F3
in_port_output:out std_logic_vector(31 downto 0);--F4
RST_fetch:in std_logic;--F12
int_fetch:in std_logic;--F13
pc0:out std_logic_vector(31 downto 0);--F5
pc1:out std_logic_vector(31 downto 0);--F6
mem_address_to_mem:out std_logic_vector(31 downto 0);--F7
mem_address_from_mem:in std_logic_vector(31 downto 0);--F8
mem_address2:in std_logic;--F14
ALU_Branch_result:in std_logic;--F15
instruction_fetched:out std_logic_vector(31 downto 0)--F9
);--(CLk_process,F1,F11,F2,F3,F4,F12,F13,F5,F6,F7,F8,F14,F15,F9)
--F5 ->PC
--F6 ->PC+1
--F4 -> Inport output
--F9 -> Instruction fetched
--F7
end component;
component Decode_Stage IS 
GENERIC ( dataSize : integer := 32);
PORT(

--input 
  Bit5_7 : IN std_logic_vector(2 downto 0);--D1
  Bit8_10 : IN std_logic_vector(2 downto 0);--D2
  Bit11_13 : IN std_logic_vector(2 downto 0);--D3
  write_Data1 :in std_logic_vector(dataSize-1 downto 0);--D11
  reg_rst: in std_logic;--D111
  Write_Reg1_Address : IN std_logic_vector(2 downto 0);--D4
  invalue: in std_logic_vector(dataSize-1 downto 0);--D12

--control
  clk : IN std_logic;--CLK_process

  reg_wr_en :in std_logic;--D112
  one_operand : IN std_logic;--D113
  in_op: IN std_logic;--D113
 
--output  
  Write1_Address : out std_logic_vector(2 downto 0);--D5
  Read_Data1 : out std_logic_vector(dataSize-1 downto 0);
  Read_Data2 :out std_logic_vector(dataSize-1 downto 0)
   ) ; 
END component; 
component Execution_Stage IS
	PORT (
	CLK: IN STD_LOGIC;
	CU_SRC1: IN STD_LOGIC;
	CU_SRC2: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	FU_EN1, FU_EN2: IN STD_LOGIC;
	FU_MEM_ALU_S1, FU_MEM_ALU_S2: IN STD_LOGIC; 		--MEM, ALU SELECT
	INDX: IN STD_LOGIC_VECTOR(1 DOWNTO 0);			--[5-7]
	REG_DATA_1, REG_DATA_2: IN STD_LOGIC_VECTOR(31 DOWNTO 0);	--FROM DECODING STAGE
	IMM: IN STD_LOGIC_VECTOR(15 DOWNTO 0);			--[16-31]
	MEM_F, ALU_F: IN STD_LOGIC_VECTOR(31 DOWNTO 0);			--FORWARDED VALUES
	ALU_OP: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	CCR_INP, CCR_OUT: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	JMP_TYP: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	JMP_OP: IN STD_LOGIC;
	JMP_DEC: OUT STD_LOGIC;
	JMP_ADD: OUT STD_lOGIC_VECTOR(31 DOWNTO 0);
	ALU_OUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END component;
component memory_stage is 
port(
memory_en:in std_logic;--M100
mux1,mux2: in std_logic_vector(3 downto 0);--M1,M2
stack_push,stack_pop:in std_logic;--M101,M102
datain1,datain2: in std_logic_vector(31 downto 0);--M200,M201
outrange: out std_logic;--M105
Clk,Rst,en:in std_logic;--CLK_processor,RST_processor,M106
operandsselect:in std_logic_vector(1 downto 0);--M500
addparsed:out std_logic_vector(19 downto 0);--M300
datamemorydata:out std_logic_vector(31 downto 0);--M202
rsignal,wsignal:in std_logic;--M107,M110
datafinal:in std_logic_vector(31 downto 0);--M203
mux11,mux12,mux21,mux22,mux23,mux24: in std_logic_vector(31 downto 0);--M204,M204,M206,M207
readsig,writesig: out std_logic;--M108,M109
memeout:out std_logic_vector(31 downto 0)--M208
--signal M100,M101,M102,M103,M104,M105,M106,M107,M108,M109,M110:std_logic; 
--signal M1,M2:std_logic_vector(3 downto 0);
--signal M200,M201,M202,M203,M204,M205,M206,M207,M208:std_logic_vector(31 downto 0);
--signal M300:std_logic_vector(19 downto 0);
--signal M500:std_logic_vector(1 downto 0);
--Memory stage(M100,M1,M2,M101,M102,M200,M201,M105,CLK_processor,RST_processor,M106,M500,M300,M202,M107,M110,M203,M204,M204,M206,M207,M108,M109,M208)
--outputs
--M105->outrange;
--M208
--signal inputs
--(M100,M101,M102,M200,M201,M105,CLK_processor,RST_processor,M106,M500,M300,M202,M107,M110,M203,M204,M204,M206,M207,M108,M109,M208)
);
end component;
component WB_Stage IS
	PORT (
	CLK : IN STD_LOGIC;--CLK_processor
	
	W_Add_1, W_Add_2: IN std_logic_vector(31 downto 0);--W1,W2
	WB_Add_S: IN std_logic;--W11
	
	ALU, IMM, MEM, REG_DATA_1, REG_DATA_2: IN std_logic_vector(31 downto 0);--W3,W4,W5,W6
	WB_DATA_S: IN STD_LOGIC_vector(2 downto 0);--W100
	
	SWAP, OUT_EN: IN STD_LOGIC;--W12,W13
	
	WB_ADD: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);--W7
	WB_DATA: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);--W8
	OUT_PORT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)--W9
);
--signal W1,W2,W3,W4,W5,W6,W7,W8,W9:std_logic_vector(31 downto 0);
--signal W11,W12,W13:std_logic;
--signal W100:std_logic_vector(2 downto 0);
--(CLK_process,W1,W2,W11,W3,W4,W5,W6,W100,W12,W13,W7,W8,W9)
END component;
component memory is 
port(
addressused: in std_logic_vector(19 downto 0);--access1 
datain: in std_logic_vector(31 downto 0);--access10
dataout: out std_logic_vector(31 downto 0);--access11
mem_re,mem_write: in std_logic;--access100,access101 
Clk:in std_logic--CLK_processor
);
--signal access1:std_logic_vector(19 downto 0);
--signal access10,access11:std_logic_vector(31 downto 0);
--signals access100,access101:std-logic;
--(access1,access10,access11,access2,access3,CLK_processor)
end component;
component FWD is 
port(
ID_EX_wr_Add_1:in std_logic_vector(2 downto 0);
EX_MEM_wr_Add_1:in std_logic_vector(2 downto 0);
MEM_WB_wr_Add_1:in std_logic_vector(2 downto 0);


ID_EX_wr_Add_2:in std_logic_vector(2 downto 0);
EX_MEM_wr_Add_2:in std_logic_vector(2 downto 0);
MEM_WB_wr_Add_2:in std_logic_vector(2 downto 0);


ID_EX_dst_Add:in std_logic_vector(2 downto 0);
EX_MEM_dst_Add:in std_logic_vector(2 downto 0);
MEM_WB_dst_Add:in std_logic_vector(2 downto 0);


CU_stack_op:in std_logic_vector(2 downto 0);
EX_MEM_stack_op:in std_logic_vector(2 downto 0);
MEM_WB_stack_op:in std_logic_vector(2 downto 0);


HD_Unit_exception:in std_logic;
CU_Unit_control_start:in std_logic;

subselect1:out std_logic;
subselect2:out std_logic;

selector_1:out std_logic;
selector_2:out std_logic
);
end component;
component HazardDetectionUnit is
port(
Stall,Flush:out std_logic_vector (4 downto 0);--stall => HZ1,Flush => HZ2 
EPCenable: out std_logic;-- EPCenable => HZ11
MemIsWriting,MemIsReading,WriteBack,ForwardingUnitFailed,OutofRange,TakenDecided,Swap:in std_logic;--MemIsWriting => HZ12,MemIsReading => HZ13,Writeback => HZ14,ForwardingUnitFailed => HZ15,OutofRange => HZ16,TakenDecided => HZ17,Swap => HZ18,
Instruction: in std_logic_vector(31 downto 0);--Instruction => HZ100
address_wr:in std_logic_vector(6 downto 0);--address_wr => HZ200
memisfetching:in std_logic;--memisfetching => HZ22
Memoryworks: in std_logic;--Memoryworks => HZ23
collsion:out std_logic;--collision => HZ24
load_use_detected:out std_logic;--load_use_detected => HZ20
load_use_hazard:in std_logic;--load_use_hazard => HZ21
INT_RETI_RET:in std_logic--INT_RETI_RET => HZRET
--signal HZ1,HZ2:std_logic_vector(4 downto 0);
--signal HZ11,HZ12,HZ13,HZ14,HZ15,HZ16,HZ17,HZ18,HZ19,HZ20,HZ21:std_logic;
--signal HZ100:std_logic_vector(31 downto 0);
--signal HZ200:std_logic_vector(6 downto 0);
--(stall => HZ1,Flush => HZ2,EPCenable => HZ11,MemIsWriting => HZ12,MemIsReading => HZ13,Writeback => HZ14,ForwardingUnitFailed => HZ15,OutofRange => HZ16,TakenDecided => HZ17,HZ18,Swap => HZ19,Instruction => HZ100,address_wr => HZ200,memisfetching => HZ22,Memoryworks => HZ23,collision => HZ24,load_use_detected => HZ20,load_use_hazard => HZ21,INT_RETI_RET => HZRET)
);
end component;
component IF_ID_Buffer is
port( 
Clk,Flush  : in std_logic;
stall_id:in std_logic;
Pc       : in std_logic_vector(31 downto 0);
Pc_plus    : in std_logic_vector(31 downto 0);
opcode: in std_logic_vector(31 downto 0);  
input    : in std_logic_vector(31 downto 0); 

Pc_out         : out std_logic_vector(31 downto 0);
Pc_plus_out      : out std_logic_vector(31 downto 0);
opcode_out  : out std_logic_vector(31  downto 0);
input_out  : out std_logic_vector(31  downto 0)

);
end component;
component ID_EX_Buffer is
port( 
--Inputs
Clk,Flush, En : in std_logic;
Pc       : in std_logic_vector(31 downto 0);
Pc_plus    : in std_logic_vector(31 downto 0);
Reg_data1   : in std_logic_vector(31 downto 0); 
Reg_data2  : in std_logic_vector(31 downto 0); 
IMM        : in std_logic_vector(15 downto 0); 
W_add1     : in std_logic_vector(2 downto 0); 
W_add2     : in std_logic_vector(2 downto 0); 
load_use_in   : in std_logic;
--Control Signals
ex	: in std_logic_vector(12 downto 0);--13bits
mem	: in std_logic_vector(9 downto 0);--10bits
wb	: in std_logic_vector(5 downto 0);--6bits
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
mem_out	        : out std_logic_vector(9 downto 0);--10bits
wb_out	        : out std_logic_vector(5 downto 0)--6bits

);
end component;
component EX_MEM_Buffer is
port( 
--Inputs
Clk,Flush, En  : in std_logic;
Pc       : in std_logic_vector(31 downto 0);
Pc_plus    : in std_logic_vector(31 downto 0);
Reg_data1   : in std_logic_vector(31 downto 0); 
Reg_data2  : in std_logic_vector(31 downto 0); 
IMM        : in std_logic_vector(31 downto 0); 
W_add1     : in std_logic_vector(2 downto 0); 
W_add2     : in std_logic_vector(2 downto 0); 
ALU        : in std_logic_vector(31 downto 0);

--Control Signals

mem	: in std_logic_vector(9 downto 0);--10bits
wb	: in std_logic_vector(6 downto 0);--7bits

--Outputs
Pc_out         : out std_logic_vector(31 downto 0);
Pc_plus_out      : out std_logic_vector(31 downto 0);
Reg_data1_out   : out std_logic_vector(31 downto 0); 
Reg_data2_out    : out std_logic_vector(31 downto 0); 
IMM_out          : out std_logic_vector(31 downto 0); 
W_add1_out       : out std_logic_vector(2 downto 0); 
W_add2_out       : out std_logic_vector(2 downto 0); 
ALU_out          : out std_logic_vector(31 downto 0);


mem_out	: out std_logic_vector(9 downto 0);
wb_out	: out std_logic_vector(6 downto 0)

);
end  component;
component control is 
port(
Opcode_buff:in std_logic_vector(4 downto 0);
index:in std_logic;
Excution_signals:out std_logic_vector(8 downto 0);
Memory_signals:out std_logic_vector(9 downto 0);
Writeback_signals:out std_logic_vector(6 downto 0)
);
end component;
component MEM_WB_Buffer is
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
end  component;
component MUX2x1 is 
Generic(DataSize: integer :=32);
port(
Input1,Input2: in std_logic_vector(DataSize-1 DOWNTO 0);
SEL : in std_logic;
F: out std_logic_vector(DataSize-1 DOWNTO 0));
end component;
component DMUX2x1 is 
generic(n:integer:=32);
port(
F_DMUX:in std_logic_vector(n-1 downto 0);
OUT1,OUT2: out std_logic_vector(n-1 downto 0);
SEL_DMUX:in std_logic
);
end component;
--Hazard detetction signals
signal HZ1,HZ2:std_logic_vector(4 downto 0);
signal HZ11,HZ12,HZ13,HZ14,HZ15,HZ16,HZ17,HZ18,HZ19,HZ20,HZ21,HZRET:std_logic;
signal HZ100:std_logic_vector(31 downto 0);
signal HZ200:std_logic_vector(6 downto 0);
---------------------
--Forwarding signals 
---------------------
--fetch stage signals
signal F1,F2,F3,F4,F5,F6,F7,F8,F9:std_logic_vector(31 downto 0);
signal F11,F12,F13,F14,F15:std_logic;
---------------------
--Excution stage signals
---------------------
--Memory Stage signals
signal M100,M101,M102,M103,M104,M105,M106,M107,M108,M109,M110:std_logic; 
signal M1,M2:std_logic_vector(3 downto 0);
signal M200,M201,M202,M203,M204,M205,M206,M207,M208:std_logic_vector(31 downto 0);
signal M300:std_logic_vector(19 downto 0);
signal M500:std_logic_vector(1 downto 0);
---------------------
--memory signals
signal access1:std_logic_vector(19 downto 0);
signal access10,access11:std_logic_vector(31 downto 0);
signal access100,access101:std_logic;
---------------------
--Write back Stage signals
signal W1,W2,W3,W4,W5,W6,W7,W8,W9:std_logic_vector(31 downto 0);
signal W11,W12,W13:std_logic;
signal W100:std_logic_vector(2 downto 0);
---------------------
begin
v0:fetch_stage port map(CLk_processor,F1,F11,F2,F3,F4,F12,F13,F5,F6,F7,F8,F14,F15,F9);
v1:IF_ID_Buffer port map(CLK_processor,HZ2(0),HZ1(0),F5,F6,F4,F9);
v2:decode_Stage generic map(32) port map();
v3:ID_EX_Buffer port map();
v4:Excution_Stage port map();
v5:EX_MEM_Buffer port map();
v6:memory_stage port map(M100,M1,M101,M102,M200,M201,M105,CLK_processor,RST_processor,M106,M500,M300,M202,M107,M203,M204,M205,M206,M207,M108,M109,M208);
v7:MEM_WB_Buffer port map(CLK_processor,HZ2(0),HZ1(0),,,);
v8:WB_Stage port map(CLK_process,W1,W2,W11,W3,W4,W5,W6,W100,W12,W13,W7,W8,W9);
v10:FWD port map();
------------------------------------------------------------------------------------------------------------------------------
v9:memory_stage port map(M100,M1,M2,M101,M102,M103,M104,M200,M201,M105,CLK_processor,RST_processor,M106,M500,M300,M202,M107,M110,108,M203,M204,M205,M206,M207,M108,M109,M208);
v10:HazardDetectionUnit port map(HZ1,HZ2,HZ11,HZ12,HZ13,HZ14,HZ15,HZ16,HZ17,HZ18,HZ19,HZ100,HZ200,HZ22,HZ23,HZ24,HZ20,HZ21);
v11:memory port map(access1,access10,access11,access2,access3,CLK_processor); 
v12:MUX2x1 generic map(32) port map(F7,M300,HZ24,access1);
v13:MUX2x1 generic map(32) port map((Others=>'Z'),MEM202,HZ24,access10);
v14:MUX2x1 generic map(1) port map('1',M108,HZ24,access100);
v15:MUX2x1 generic map(1) port map('0',M109,HZ24,access101);
v16:DMUX2x1 generic map(32) port map(access11,HZ24,F8,M203);
------------------------------------------------------------------------------------------------------------------------------
v16:control port map();
end architecture;