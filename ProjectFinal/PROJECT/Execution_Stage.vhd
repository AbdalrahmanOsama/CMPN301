LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Execution_Stage IS
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
        IMM_OUT: OUT std_logic_vector(31 downto 0));
	
END ENTITY;

ARCHITECTURE EXEC_STAGE_A OF Execution_Stage is
COMPONENT BranchExec
port(TargetAddress:in std_logic_vector(31 downto 0);BranchType:in std_logic_vector(1 downto 0); en,clk:in std_logic; 
FlagStatus:in std_logic_vector(2 downto 0); JumpDecision:out std_logic; JumpAddress:out std_logic_vector(31 downto 0));
END COMPONENT;
-------------------------------------------------------------------
COMPONENT sign_extend_16_32
port(
      input : in std_logic_vector(15 downto 0);    
      output :out  std_logic_vector(31 downto 0));
END COMPONENT;
-------------------------------------------------------------------
COMPONENT sign_extend_2_32
port(
      input : in std_logic_vector(1 downto 0);    
      output :out  std_logic_vector(31 downto 0));
END COMPONENT;
-------------------------------------------------------------------
COMPONENT MUX2x1
port(
Input1 : in std_logic_vector(31 DOWNTO 0);
Input2 : in std_logic_vector(31 DOWNTO 0);
sel : in std_logic;
F: out std_logic_vector(31 DOWNTO 0)
);
END COMPONENT;
-------------------------------------------------------------------
COMPONENT MUX4x1
port(
Input1,Input2,Input3,Input4 : in std_logic_vector(31 DOWNTO 0);
SEL : in std_logic_VECTOR(1 downto 0);
F: out std_logic_vector(31 DOWNTO 0));
END COMPONENT;
-------------------------------------------------------------------
COMPONENT aluCU
port(
	execOUT: in std_logic_vector(3 downto 0); -- el msb howa el enable, wel talata el ba2yeen homa el aluOP

	aluEn: out std_logic;                    -- da el en bta3 el alu
	aluOP: out std_logic_vector(2 downto 0) -- da ely howa input "s" fel alu
);
END COMPONENT;
-------------------------------------------------------------------
COMPONENT alu
port(
	 En: in std_logic;
 	   a : in std_logic_vector(31 downto 0);
  	  b : in std_logic_vector(31 downto 0);
      s: in std_logic_vector(2 downto 0);
aluOUT: out std_logic_vector(35 downto 0) -- n-1+4 = n+3
);
END COMPONENT;
-------------------------------------------------------------------
COMPONENT CCR
	PORT (
	CLK: IN STD_LOGIC;
	CCR_EN: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	CCR_VALUE: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	CCR_OUT: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	RST: IN STD_LOGIC);
END COMPONENT;

-------------------------------------------------------------------
SIGNAL ALU_INP_1, ALU_INP_2: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL CU_SEL_1, CU_SEL_2: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL FU_SEL_1, FU_SEL_2: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL EXT_INDX, EXT_IMM: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL FLAG_STATUS: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL ALU_EN: STD_LOGIC;
SIGNAL ALU_OP_SIG: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL ALU_OUT_SIG: STD_LOGIC_VECTOR (35 DOWNTO 0);
SIGNAL CCR_INP, CCR_OUT: STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN
FLAGS: CCR PORT MAP(CLK, CCR_EN, CCR_OUT, CCR_INP, RST);

CU_MUX_1: MUX2x1 GENERIC MAP(32) PORT MAP(EXT_INDX, REG_DATA_1, CU_SRC1, CU_SEL_1);
CU_MUX_2: MUX4x1 GENERIC MAP(32) PORT MAP(REG_DATA_2, EXT_IMM, X"00000002",(OTHERS=>'0'),CU_SRC2, CU_SEL_2);

FU_MUX1:MUX2x1 GENERIC MAP(32) PORT MAP(MEM_F, ALU_F, FU_MEM_ALU_S1, FU_SEL_1);
FU_MUX2:MUX2x1 GENERIC MAP(32) PORT MAP(MEM_F, ALU_F, FU_MEM_ALU_S2, FU_SEL_2);

ALU_INP1_MUX: MUX2x1 GENERIC MAP(32) PORT MAP(CU_SEL_1, FU_SEL_1, FU_EN1,  ALU_INP_1);
ALU_INP2_MUX: MUX2x1 GENERIC MAP(32) PORT MAP(CU_SEL_2, FU_SEL_2, FU_EN2,  ALU_INP_2);

BRANCH: BranchExec PORT MAP (EXT_IMM, JMP_TYP, JMP_OP, CLK, FLAG_STATUS, JMP_DEC, JMP_ADD);

IMM_EXT: sign_extend_16_32 PORT MAP (IMM, EXT_IMM);
INDX_EXT: sign_extend_2_32 PORT MAP (INDX, EXT_INDX);
IMM_OUT<=EXT_IMM;
ALU_COMP: alu GENERIC MAP(32) PORT MAP(ALU_EN, ALU_INP_1, ALU_INP_2, ALU_OP_SIG, ALU_OUT_SIG);
ALU_CU: aluCU PORT MAP(ALU_OP, ALU_EN, ALU_OP_SIG);

ALU_OUT <= ALU_OUT_SIG(31 DOWNTO 0);
CCR_OUT(0) <= ALU_OUT_SIG(34);
CCR_OUT(1) <= ALU_OUT_SIG(33);
CCR_OUT(2) <= ALU_OUT_SIG(32);

FLAG_STATUS <= "00" & CCR_INP(0) WHEN JMP_OP = '1' AND JMP_TYP = "00" 
ELSE '0' & CCR_INP(1) & '0' WHEN JMP_OP = '1' AND JMP_TYP = "01" 
ELSE CCR_INP(2) & "00" 	WHEN JMP_OP = '1' AND JMP_TYP = "10" 
ELSE CCR_INP;

END EXEC_STAGE_A;
