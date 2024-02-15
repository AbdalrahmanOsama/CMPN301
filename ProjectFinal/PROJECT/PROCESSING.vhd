Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processing is
port(
CLK_processor:in std_logic;
RST_processor,interupt:in std_logic;
IN_port_value:in std_logic_vector(31 downto 0);
Out_port_value:out std_logic_vector(31 downto 0)
);
end processing;




architecture arch_processor of processing is 
COMPONENT control
port(
Opcode_buff:in std_logic_vector(4 downto 0);
index:in std_logic;
Excution_signals:out std_logic_vector(14 downto 0);
Memory_signals:out std_logic_vector(12 downto 0);
Writeback_signals:out std_logic_vector(6 downto 0)
);
END COMPONENT;

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
	CLK, RST: IN STD_LOGIC;
	CU_SRC1: IN STD_LOGIC;
	CU_SRC2: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	FU_EN1, FU_EN2: IN STD_LOGIC;
	FU_MEM_ALU_S1, FU_MEM_ALU_S2: IN STD_LOGIC; 		--MEM, ALU SELECT
	INDX: IN STD_LOGIC_VECTOR(1 DOWNTO 0);			--[5-7]
	REG_DATA_1, REG_DATA_2: IN STD_LOGIC_VECTOR(31 DOWNTO 0);	--FROM DECODING STAGE
	IMM: IN STD_LOGIC_VECTOR(15 DOWNTO 0);			--[16-31]
	MEM_F, ALU_F: IN STD_LOGIC_VECTOR(31 DOWNTO 0);			--FORWARDED VALUES
	ALU_OP: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	CCR_EN: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	JMP_TYP: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	JMP_OP: IN STD_LOGIC;
	JMP_DEC: OUT STD_LOGIC;
	JMP_ADD: OUT STD_lOGIC_VECTOR(31 DOWNTO 0);
	ALU_OUT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        IMM_OUT:OUT std_Logic_vector(31 downto 0)
);
--(EX1,EX2,EXV1,EX3,EX4,EX5,EX6,EXV2,EXV3,EXV4,EXV5,EXV6,EXV7,EXV8,EXV9,EXV10,EXV11,EX7,EX8,EXV12,EXV13,EXV14)
END component;
component memory_stage is 
port(
memory_en:in std_logic;--std1
Stackoper:in std_logic;--std2
stack_push,stack_pop:in std_logic;--std3,std4

datain1,datain2: in std_logic_vector(31 downto 0);--vector1,vector13
outrange: out std_logic;--std7
Clk,Rst,en:in std_logic;--std8,std9,std10
operandsselect:in std_logic_vector(1 downto 0);--vector2
addparsed:out std_logic_vector(19 downto 0);--vectors3
datamemorydata:out std_logic_vector(31 downto 0);--vectors4 
rsignal,wsignal:in std_logic;--std11,std12
datafinal:in std_logic_vector(31 downto 0);--vector5
mux11,mux12,mux21,mux22,mux23,mux24: in std_logic_vector(31 downto 0);--vector6,vector7,vector8,vector9,vector10,vector11
readsig,writesig: out std_logic;--std13,std14
memeout:out std_logic_vector(31 downto 0)--vector12
);
--(std1,std2,std3,std4,std5,std6,vector1,vector13,std7,std8,std9,std10,vector2,vector3,vector4,std11,std12,vector5,vector6,vector7,vector8,vector9,vector10,vector11,std13,std14,vector12)
end component;
component WB_Stage IS
	PORT (
	CLK : IN STD_LOGIC;
	
	W_Add_1, W_Add_2: IN std_logic_vector(2 downto 0);
	WB_Add_S: IN std_logic;
	
	ALU, IMM, MEM, REG_DATA_1, REG_DATA_2: IN std_logic_vector(31 downto 0);
	WB_DATA_S: IN STD_LOGIC_vector(2 downto 0);
	
	SWAP, OUT_EN: IN STD_LOGIC;
	
	WB_ADD: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	WB_DATA: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	OUT_PORT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));   			
END component;
component memory is 
port(
addressused: in std_logic_vector(19 downto 0); 
datain: in std_logic_vector(31 downto 0);
dataout: out std_logic_vector(31 downto 0);
mem_re,mem_write: in std_logic; 
Clk:in std_logic
);
end component;
component FWD is 
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
end component;
component HazardDetectionUnit is
port(
Stall,Flush:out std_logic_vector (4 downto 0);--HZ1,HZ2 
EPCenable: out std_logic;--HZ11
MemIsWriting,MemIsReading,WriteBack,ForwardingUnitFailed,OutofRange,TakenDecided,Swap:in std_logic;--HZ12,HZ13,HZ14,HZ15,HZ16,HZ17,HZ18,HZ19
Instruction: in std_logic_vector(31 downto 0);--HZ100
address_wr:in std_logic_vector(6 downto 0);--HZ200
memisfetching:in std_logic;--HZ22
Memoryworks: in std_logic;--HZ23
collsion:out std_logic;--HZ24
load_use_detected:out std_logic;--HZ20
load_use_hazard:in std_logic;--HZ21
INT_RETI_RET:in std_logic--HZRET
--signal HZ1,HZ2:std_logic_vector(4 downto 0);
--signal HZ11,HZ12,HZ13,HZ14,HZ15,HZ16,HZ17,HZ18,HZ19,HZ20,HZ21:std_logic;
--signal HZ100:std_logic_vector(31 downto 0);
--signal HZ200:std_logic_vector(6 downto 0);
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
end component;
component EX_MEM_Buffer is
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


mem_out	: out std_logic_vector(12 downto 0);
wb_out	: out std_logic_vector(6 downto 0)

);
end  component;
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
Reg_data1_out: out std_logic_vector(31 downto 0);--w1 
Reg_data2_out: out std_logic_vector(31 downto 0);--w2 
IMM_out: out std_logic_vector(31 downto 0);--w3 
W_add1_out: out std_logic_vector(2 downto 0);--w10 
W_add2_out: out std_logic_vector(2 downto 0);--w11 
ALU_out: out std_logic_vector(31 downto 0);--w4
memdata_out: out std_logic_vector(31 downto 0);--w5
wb_out: out std_logic_vector(6 downto 0)--w20
);
--(w1,w2,w3,w10,w11,w4,w5,w20)
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
component MUX2x2 is 
port(
Input1,Input2: in std_logic;
SEL : in std_logic;
F: out std_logic);
end component;

-----------------------------------
signal std1,std2,std3,std4,std5,std6,std7,std8,std9,std10,std11,std12,std13,std14:std_logic;
signal vector1,vector4,vector5,vector6,vector7,vector8,vector9,vector10,vector11,vector12,vector13:std_logic_vector(31 downto 0);
signal vector2:std_logic_vector(1 downto 0);
signal vector3:std_logic_vector(19 downto 0);
-----------------------------------
--Hazard detetction signals
signal HZ1,HZ2:std_logic_vector(4 downto 0);
signal HZ11,HZ12,HZ13,HZ14,HZ15,HZ16,HZ17,HZ18,HZ19,HZ20,HZ21,HZ22,HZ23,HZ24,HZRET:std_logic;
signal HZ100:std_logic_vector(31 downto 0);
signal HZ200:std_logic_vector(6 downto 0);
---------------------
--Forwarding signals
signal fw1,fw2,fw3,fw4:std_logic; 
---------------------
--fetch stage signals
signal F1,F2,F3,F4,F5,F6,F7,F8,F9:std_logic_vector(31 downto 0);
signal F11,F12,F13,F14,F15:std_logic;
---------------------
--Deocde Stage:
SIGNAL OP1, OP2, OP3 : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL REG_RST, ONE_OP, IN_OP: STD_LOGIC;
SIGNAL W_ADD_1: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL REG_DATA_1, REG_DATA_2: STD_LOGIC_VECTOR(31 DOWNTO 0);
------------------------------------------------------------------
--Excution stage signals
SIGNAL EXEC_RST, SRC1: STD_LOGIC;
SIGNAL ALU_OP:STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL CRR_EN:STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL JMP_TYP, SRC2: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL JMP_OP, JMP_DEC: STD_LOGIC;
SIGNAL JMP_ADD, ALU_OUT: STD_lOGIC_VECTOR(31 DOWNTO 0);
------------------------------------------------------------------
--Memory Stage signals
signal M100,M101,M102,M103,M104,M105,M106,M107,M108,M109,M110,M111:std_logic; 
signal M1,M2:std_logic_vector(3 downto 0);
signal M200,M201,M202,M203,M204,M205,M206,M207,M208:std_logic_vector(31 downto 0);
signal M300:std_logic_vector(19 downto 0);
signal M500:std_logic_vector(1 downto 0);
---------------------
---------------------
--memory signals
signal access1:std_logic_vector(19 downto 0);
signal access10,access11:std_logic_vector(31 downto 0);
signal access100,access101:std_logic;
---------------------
--Write back Stage signals
SIGNAL WB_DATA1, OUTPORT : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL WB_ADD,WB_DATA_S : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL WB_ADD_S,WB_SWAP, WB_OUT :STD_LOGIC;
---------------------------------------------------------------
--IF-ID buffer:
signal PC, PC_PLUS_1, INSTR, IN_PORT_BV: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL Flush_IF_ID, Stall_IF_ID: STD_LOGIC;
------------------------------------------------------------------
signal EX1,EX2,EX3,EX4,EX5,EX6,EX7,EX8:std_logic;
signal EXV1,EXV2,EXV11:std_Logic_vector(1 downto 0);
signal EXV3,EXV4,EXV6,EXV7,EXV12,EXV13,EXV14:std_logic_vector(31 downto 0);
signal EXV5:std_logic_vector(15 downto 0);
signal EXV8:std_logic_vector(3 downto 0);
signal EXV9,EXV10:std_logic_vector(2 downto 0);
------------------------------------------------------------------
-- id-ex buffer:
SIGNAL Flush_ID_EX, Stall_ID_EX: STD_LOGIC;
SIGNAL IMM: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL LOAD_USE: STD_LOGIC;
SIGNAL Exec_stage_sig: STD_LOGIC_VECTOR(12 DOWNTO 0);
SIGNAL E1, E2, E3, E4 :STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL E5 :STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL E6,E7 : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL E8: STD_LOGIC;
SIGNAL E9 :STD_LOGIC_VECTOR(12 DOWNTO 0);
SIGNAL E10 :STD_LOGIC_VECTOR(12 DOWNTO 0);
SIGNAL E11 :STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL E12, INT_INDX: STD_LOGIC_VECTOR(1 DOWNTO 0);
-------------------------------------------------------------------
--MEM-WB Buffer:
SIGNAL REG_W_EN: STD_LOGIC;
--------------------------------------
--CONTROL UNIT
SIGNAL INDX: STD_LOGIC;	-- ??
SIGNAL EXEC_CU_SIG: STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL MEM_CU_SIG: STD_LOGIC_VECTOR(12 DOWNTO 0);
SIGNAL WB_CU_SIG: STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL OPCODE : STD_LOGIC_VECTOR(4 DOWNTO 0);
------------------------------------------------------------------
SIGNAL IMM_EXT: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL M_PC, M_PC_1,M_REG_DATA1, M_REG_DATA2,M_IMM,M_ALU : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL M_WB_ADD1,M_WB_ADD2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL M_MEM_SIG :STD_LOGIC_VECTOR(12 DOWNTO 0);
SIGNAL M_WB_SIG :STD_LOGIC_VECTOR(6 DOWNTO 0);
signal w1,w2,w3,w4,w5:std_logic_vector(31 downto 0);
signal w10,w11:std_logic_vector(2 downto 0);
signal w20:std_logic_vector(6 downto 0);
signal IMM_DEX:STD_LOGIC_VECTOR(31 downto 0);
------------------------------------------------------------------
begin
v0:fetch_stage port map(CLK_processor,F1,F11,F2,F3,F4,F12,F13,F5,F6,F7,F8,F14,F15,F9);
-------------------------------------------------------------------------------------------
OPCODE <= INSTR(31 DOWNTO 27);
OP1 <= INSTR(26 DOWNTO 24);
OP2 <= INSTR(23 DOWNTO 21);
OP3 <= INSTR(20 DOWNTO 18);
ONE_OP <= EXEC_CU_SIG(9);
IN_OP <= EXEC_CU_SIG(10);
IMM <= INSTR(15 DOWNTO 0);
Exec_stage_sig <= EXEC_CU_SIG(14 DOWNTO 11) & EXEC_CU_SIG(8 DOWNTO 0);
------------------------------------
SRC1 <= E9(2);
SRC2 <= E9(1 DOWNTO 0);
ALU_OP <= E9(12 DOWNTO 9);
CRR_EN <= E9(8 DOWNTO 6);
JMP_TYP <= E9(5 DOWNTO 4);
JMP_OP <= E9(3);
-------------------------------------
v1:IF_ID_Buffer port map(CLK_processor, Flush_IF_ID, Stall_IF_ID,F5,F6,F9,IN_port_value,PC,PC_PLUS_1,INSTR,IN_PORT_BV); --Flush, stall_id is missing
v2:decode_Stage generic map(32) port map(OP1,OP2,OP3,WB_DATA1,REG_RST,WB_ADD,IN_PORT_BV,CLK_processor,REG_W_EN,ONE_OP,IN_OP,W_ADD_1,REG_DATA_1,REG_DATA_2); --REG_RST is missing
v3:ID_EX_Buffer port map(CLK_processor,Flush_ID_EX,Stall_ID_EX,PC,PC_PLUS_1,REG_DATA_1,REG_DATA_2,IMM,W_ADD_1,OP2,LOAD_USE,INT_INDX,Exec_stage_sig,MEM_CU_SIG,WB_CU_SIG,E1,E2,E3,E4,E5,E6,E7,E8,E9,E10,E11,E12); --LOAD_USE_IN missing
v4:Execution_Stage port map(CLK_processor,EXEC_RST,SRC1,SRC2,fw1,fw2,fw3,fw4, E12,E3,E4,E5,M_ALU,w5,ALU_OP,CRR_EN,JMP_TYP,JMP_OP,JMP_DEC,JMP_ADD,ALU_OUT, IMM_EXT); --RST, FU IS MISSING
--(CLK,CU_SRC1,CU_SRC2,FU_EN1, FU_EN2,FU_MEM_ALU_S1, FU_MEM_ALU_S2,INDX,REG_DATA_1, REG_DATA_2,IMM,MEM_F, ALU_F,ALU_OP,CCR_INP, CCR_OUT,JMP_TYP,JMP_OP,JMP_DEC,JMP_ADD,ALU_OUT,IMM_D) 
SRC1 <= E9(2);
SRC2 <= E9(1 DOWNTO 0);
ALU_OP <= E9(12 DOWNTO 9);
CRR_EN <= E9(8 DOWNTO 6);
JMP_TYP <= E9(5 DOWNTO 4);
JMP_OP <= E9(3);
v5:EX_MEM_Buffer port map(CLK_processor,HZ2(2),HZ1(2),E1,E2,E3,E4,IMM_EXT,E6,E7,ALU_OUT,E10,E11,M_PC,M_PC_1,M_REG_DATA1,M_REG_DATA2,M_IMM,M_WB_ADD1,M_WB_ADD2,M_ALU,M_MEM_SIG,M_WB_SIG);
---------------------------------------------------------------------------------------------
HZ16 <= M105;
---------------------------------------------------------------------------------------------
--stackop,push,pop,memw,memr,mux1,mux2(2 bits),memory_c,RT_RTI_RET
std3<=M_MEM_SIG(8);
std4<=M_MEM_SIG(7);
std1<=M_MEM_SIG(1);
vector2<=M_MEM_SIG(3 downto 2);
std6<=M_MEM_SIG(6);
std5<=M_MEM_SIG(5);
std10<=M_MEM_SIG(1);
std2<=M_MEM_SIG(9);
v8:FWD port map('0',W_ADD_1,M_WB_ADD1,w10,OP2,M_WB_ADD2,w11,HZ11,fw1,fw2,fw3,fw4);
v9:memory_stage port map(std1,std2,std3,std4,vector1,vector13,std7,std8,std9,std10,vector2,vector3,vector4,std11,std12,vector5,vector6,vector7,vector8,vector9,vector10,vector11,std13,std14,vector12);
v18:MEM_WB_Buffer port map(CLK_processor,HZ2(3),HZ1(3),M_REG_DATA1,M_REG_DATA2,M_IMM,M_WB_ADD1,M_WB_ADD2,M_ALU,vector12,M_WB_SIG,w1,w2,w3,w10,w11,w4,w5,w20);
v10:HazardDetectionUnit port map(stall => HZ1,Flush => HZ2,EPCenable => HZ11,MemIsWriting => HZ12,MemIsReading => HZ13,Writeback => HZ14,ForwardingUnitFailed => HZ15,OutofRange => HZ16,TakenDecided => HZ17,Swap => HZ18,Instruction => HZ100,address_wr => HZ200,memisfetching => HZ22,Memoryworks => HZ23,collsion => HZ24,load_use_detected => HZ20,load_use_hazard => HZ21,INT_RETI_RET => HZRET);
v7:WB_Stage port map(CLK_processor,W10,W11,WB_ADD_S, W4,W3,W5,W1,W2, WB_DATA_S,WB_SWAP,WB_OUT,WB_ADD,WB_DATA1,OUTPORT);
REG_W_EN <= W20(6);
WB_ADD_S <= W20(5);
WB_DATA_S <= W20(4 DOWNTO 2);
WB_SWAP <= W20(1);  
WB_OUT <= W20(0);
v11:memory port map(access1,access10,access11,access100,access101,CLK_processor); 
v12:MUX2x1 generic map(20) port map(F7(19 DOWNTO 0),M300,HZ24,access1);
v13:MUX2x1 generic map(32) port map((Others=>'Z'),M202,HZ24,access10);
v14:MUX2x2  port map('1',M108,HZ24,access100);
v15:MUX2x2  port map('0',M109,HZ24,access101);
v16:DMUX2x1 generic map(32) port map(access11,F8,M203,HZ24);
---------------------------------------------------------------------------------------------
v17:control port map(OPCODE, INDX, EXEC_CU_SIG, MEM_CU_SIG, WB_CU_SIG); --INDX IS MISSING
Out_port_value <= OUTPORT;
REG_RST <= RST_processor;
EXEC_RST <= RST_processor;
end architecture;