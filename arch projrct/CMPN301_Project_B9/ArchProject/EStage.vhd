LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;
USE BASICLOGIC.all;

ENTITY EStage IS
	PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	DE_ALUFlagEnable : IN std_logic;
	DE_ALUOperation : IN std_logic_vector(4 DOWNTO 0);
	DE_ImmediateValue : IN std_logic;
	DE_WriteBackEnable : IN std_logic;
	DE_MemoryReadEnable : IN std_logic_vector(1 DOWNTO 0);
   DE_MemoryWriteEnable : IN std_logic_vector(1 DOWNTO 0);
	DE_Data1 : IN std_logic_vector(15 DOWNTO 0);
	DE_Data2 : IN std_logic_vector(15 DOWNTO 0);
	DE_DestAdr : IN  std_logic_vector(2 DOWNTO 0);
	DE_InPortData : IN std_logic_vector(15 DOWNTO 0);
	EM_WriteBackEnable : OUT std_logic;
	EM_MemoryReadEnable : OUT std_logic_vector(1 DOWNTO 0);
   EM_MemoryWriteEnable : OUT std_logic_vector(1 DOWNTO 0);
	EM_Data1 : OUT std_logic_vector(15 DOWNTO 0);
	EM_Data2 : OUT std_logic_vector(15 DOWNTO 0);
	EM_DestAdr : OUT  std_logic_vector(2 DOWNTO 0);
	EM_InPortData : OUT std_logic_vector(15 DOWNTO 0);
	Flags : OUT std_logic_vector(2 DOWNTO 0));
END EStage;

ARCHITECTURE structure OF EStage IS
	SIGNAL Notclk : std_logic;
	SIGNAL ALUFlagEnable : std_logic;
	SIGNAL ALUOperation : std_logic_vector(4 DOWNTO 0);
	SIGNAL ImmediateValue : std_logic;
	SIGNAL WriteBackEnable : std_logic;
	SIGNAL MemoryReadEnable : std_logic_vector(1 DOWNTO 0);
   SIGNAL MemoryWriteEnable : std_logic_vector(1 DOWNTO 0);
	SIGNAL Data1 : std_logic_vector(15 DOWNTO 0);
	SIGNAL Data2 : std_logic_vector(15 DOWNTO 0);
	SIGNAL DestAdr : std_logic_vector(2 DOWNTO 0);
	SIGNAL InPortData : std_logic_vector(15 DOWNTO 0);
	SIGNAL ALUFlags_Out : std_logic_vector(2 DOWNTO 0);
	SIGNAL FlagRegister_In : std_logic_vector(2 DOWNTO 0);
	SIGNAL FlagRegister_Out : std_logic_vector(2 DOWNTO 0);
BEGIN
	Notclk <= not clk;
	DEReg_ALUFlagEnable: ENTITY work.Reg(structure_b) GENERIC MAP(w => 1) PORT MAP(clk => Notclk,rst => rst,d(0) => DE_ALUFlagEnable,q(0) => ALUFlagEnable);
	DEReg_ALUOperation: ENTITY work.Reg(structure_b) GENERIC MAP(w => 5) PORT MAP(clk => Notclk,rst => rst,d => DE_ALUOperation,q => ALUOperation);
	DEReg_ImmediateValue: ENTITY work.Reg(structure_b) GENERIC MAP(w => 1) PORT MAP(clk => Notclk,rst => rst,d(0) => DE_ImmediateValue,q(0) => ImmediateValue);
	DEReg_WriteBackEnable: ENTITY work.Reg(structure_b) GENERIC MAP(w => 1) PORT MAP(clk => Notclk,rst => rst,d(0) => DE_WriteBackEnable,q(0) => WriteBackEnable);
	DEReg_MemoryReadEnable: ENTITY work.Reg(structure_b) GENERIC MAP(w => 2) PORT MAP(clk => Notclk,rst => rst,d => DE_MemoryReadEnable,q => MemoryReadEnable);
   DEReg_MemoryWriteEnable: ENTITY work.Reg(structure_b) GENERIC MAP(w => 2) PORT MAP(clk => Notclk,rst => rst,d => DE_MemoryWriteEnable,q => MemoryWriteEnable);
	DEReg_Data1: ENTITY work.Reg(structure_b) GENERIC MAP(w => 16) PORT MAP(clk => Notclk,rst => rst,d => DE_Data1,q => Data1);
	DEReg_Data2: ENTITY work.Reg(structure_b) GENERIC MAP(w => 16) PORT MAP(clk => Notclk,rst => rst,d => DE_Data2,q => Data2);
	DEReg_DestAdr: ENTITY work.Reg(structure_b) GENERIC MAP(w => 3) PORT MAP(clk => Notclk,rst => rst,d => DE_DestAdr,q => DestAdr);
	DEReg_InPortData: ENTITY work.Reg(structure_b) GENERIC MAP(w => 16) PORT MAP(clk => Notclk,rst => rst,d => DE_InPortData,q => InPortData);
	
	ALU: ENTITY work.ALU(structure) GENERIC MAP(w => 16,w_max => 4) PORT MAP(a => Data1,b => Data2,cin => ALUOperation(0),s => ALUOperation(4 DOWNTO 1),f => EM_Data1,flags => ALUFlags_Out);
	FlagRegister: ENTITY work.Reg(structure_b) GENERIC MAP(w => 3) PORT MAP(clk => clk,rst => rst,d => FlagRegister_In,q => FlagRegister_Out);
	Flagmux: ENTITY BASICLOGIC.Muxer(structure) GENERIC MAP(n => 2,w => 3) PORT MAP(x(0) => FlagRegister_Out,x(1) => ALUFlags_Out,s(0) => ALUFlagEnable,f => FlagRegister_In);
	
	Flags <= FlagRegister_Out;
	EM_Data2 <= Data2;
	EM_DestAdr <= DestAdr;
	EM_InPortData <= InPortData;
	EM_WriteBackEnable <= WriteBackEnable;
	EM_MemoryReadEnable <= MemoryReadEnable;
	EM_MemoryWriteEnable <= MemoryWriteEnable;
END structure;