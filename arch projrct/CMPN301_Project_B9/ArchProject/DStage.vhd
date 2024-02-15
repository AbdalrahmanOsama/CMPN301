LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;
USE BASICLOGIC.all;

ENTITY DStage IS
	PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	FD_Instruction : IN std_logic_vector(31 DOWNTO 0);
	FD_InPortData : IN std_logic_vector(15 DOWNTO 0);
	WriteEn : IN std_logic;
	WriteData : IN std_logic_vector(15 DOWNTO 0);
	WriteAdr : IN std_logic_vector(2 DOWNTO 0);
	DE_ALUFlagEnable : OUT std_logic;
	DE_ALUOperation : OUT std_logic_vector(4 DOWNTO 0);
	DE_ImmediateValue : OUT std_logic;
	DE_WriteBackEnable : OUT std_logic;
	DE_MemoryReadEnable : OUT std_logic_vector(1 DOWNTO 0);
   DE_MemoryWriteEnable : OUT std_logic_vector(1 DOWNTO 0);
	DE_Data1 : OUT std_logic_vector(15 DOWNTO 0);
	DE_Data2 : OUT std_logic_vector(15 DOWNTO 0);
	DE_DestAdr : OUT  std_logic_vector(2 DOWNTO 0);
	DE_InPortData : OUT std_logic_vector(15 DOWNTO 0));
END DStage;

ARCHITECTURE structure OF DStage IS
	SIGNAL Notclk : std_logic;
	SIGNAL Instruction : std_logic_vector(31 DOWNTO 0);
	SIGNAL InPortData : std_logic_vector(15 DOWNTO 0);
	ALIAS OpCode : std_logic_vector(6 DOWNTO 0) IS Instruction(31 DOWNTO 25);
	ALIAS DestAdr : std_logic_vector(2 DOWNTO 0) IS Instruction(24 DOWNTO 22);
	ALIAS SrcAdr1 :  std_logic_vector(2 DOWNTO 0) IS Instruction(21 DOWNTO 19);
	ALIAS SrcAdr2 : std_logic_vector(2 DOWNTO 0) IS Instruction(18 DOWNTO 16);
	ALIAS Immediate : std_logic_vector(15 DOWNTO 0) IS Instruction(15 DOWNTO 0);
BEGIN
	Notclk <= not clk;
	FDReg_Instruction: ENTITY work.Reg(structure_b) GENERIC MAP(w => 32) PORT MAP(clk => Notclk,rst => rst,d => FD_Instruction,q => Instruction);
	FDReg_InPortData: ENTITY work.Reg(structure_b) GENERIC MAP(w => 16) PORT MAP(clk => Notclk,rst => rst,d => FD_InPortData,q => InPortData);
	
	RegFile: ENTITY work.RegFile(structure_c) GENERIC MAP(n_reg => 2**3,n_in => 1,n_out => 2,w => 16) PORT MAP(clk => clk,rst => rst,start => '1',we(0) => WriteEn,inadr(0) => WriteAdr,inport(0) => WriteData,outadr(0) => SrcAdr1,outadr(1) => SrcAdr2, outport(0) => DE_Data1,outport(1) => DE_Data2);
	CTRLUnit: ENTITY work.ControlUnit(structure) PORT MAP(OPCode => OpCode,ALUFlagEnable => DE_ALUFlagEnable,ALUOperation => DE_ALUOperation,ImmediateValue => DE_ImmediateValue,WriteBackEnable => DE_WriteBackEnable,MemoryReadEnable => DE_MemoryReadEnable,MemoryWriteEnable => DE_MemoryWriteEnable);
	DE_DestAdr <= DestAdr;
	DE_InPortData <= InPortData;
END structure;

