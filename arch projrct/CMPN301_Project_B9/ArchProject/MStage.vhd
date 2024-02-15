LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;
USE BASICLOGIC.all;

ENTITY MStage IS
	PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	EM_WriteBackEnable : IN std_logic;
	EM_MemoryReadEnable : IN std_logic_vector(1 DOWNTO 0);
   EM_MemoryWriteEnable : IN std_logic_vector(1 DOWNTO 0);
	EM_Data1 : IN std_logic_vector(15 DOWNTO 0);
	EM_Data2 : IN std_logic_vector(15 DOWNTO 0);
	EM_DestAdr : IN  std_logic_vector(2 DOWNTO 0);
	EM_InPortData : IN std_logic_vector(15 DOWNTO 0);
	MWB_WriteBackEnable : OUT std_logic;
	MWB_WriteData : OUT std_logic_vector(15 DOWNTO 0);
	MWB_WriteAdr : OUT std_logic_vector(2 DOWNTO 0);
	MWB_OutPortData: OUT std_logic_vector(15 DOWNTO 0));
END MStage;

ARCHITECTURE structure OF MStage IS
	SIGNAL Notclk : std_logic;
	SIGNAL MM_WriteBackEnable : std_logic;
	SIGNAL MM_MemoryReadEnable : std_logic_vector(1 DOWNTO 0);
   SIGNAL MM_MemoryWriteEnable : std_logic_vector(1 DOWNTO 0);
	SIGNAL MM_Data1 : std_logic_vector(15 DOWNTO 0);
	SIGNAL MM_Data2 : std_logic_vector(15 DOWNTO 0);
	SIGNAL MM_DestAdr : std_logic_vector(2 DOWNTO 0);
	SIGNAL MM_InPortData : std_logic_vector(15 DOWNTO 0);
	SIGNAL WriteBackEnable : std_logic;
	SIGNAL MemoryReadEnable : std_logic_vector(1 DOWNTO 0);
	SIGNAL Data1 : std_logic_vector(15 DOWNTO 0);
	SIGNAL DestAdr : std_logic_vector(2 DOWNTO 0);
	SIGNAL InPortData : std_logic_vector(15 DOWNTO 0);
	SIGNAL OutPortRegister_In : std_logic_vector(15 DOWNTO 0);
	SIGNAL OutPortRegister_Out : std_logic_vector(15 DOWNTO 0);
	SIGNAL OutPortWE: std_logic;
	SIGNAL MemStart: std_logic;
	SIGNAL MemWE: std_logic;
	SIGNAL MemRead_Out: std_logic_vector(15 DOWNTO 0);
	SIGNAL Datamux_Out: std_logic_vector(15 DOWNTO 0);
BEGIN
	Notclk <= not clk;
	OutPortWE <= (MM_MemoryWriteEnable(0) and MM_MemoryWriteEnable(1));
	MemStart <= (MM_MemoryWriteEnable(0) xor MM_MemoryWriteEnable(1)) or (MM_MemoryReadEnable(0) xor MM_MemoryReadEnable(1));
	MemWE <= (MM_MemoryWriteEnable(0) xor MM_MemoryWriteEnable(1));
	EMReg_WriteBackEnable: ENTITY work.Reg(structure_b) GENERIC MAP(w => 1) PORT MAP(clk => Notclk,rst => rst,d(0) => EM_WriteBackEnable,q(0) => MM_WriteBackEnable);
	EMReg_MemoryReadEnable: ENTITY work.Reg(structure_b) GENERIC MAP(w => 2) PORT MAP(clk => Notclk,rst => rst,d => EM_MemoryReadEnable,q => MM_MemoryReadEnable);
   EMReg_MemoryWriteEnable: ENTITY work.Reg(structure_b) GENERIC MAP(w => 2) PORT MAP(clk => Notclk,rst => rst,d => EM_MemoryWriteEnable,q => MM_MemoryWriteEnable);
	EMReg_Data1: ENTITY work.Reg(structure_b) GENERIC MAP(w => 16) PORT MAP(clk => Notclk,rst => rst,d => EM_Data1,q => MM_Data1);
	EMReg_Data2: ENTITY work.Reg(structure_b) GENERIC MAP(w => 16) PORT MAP(clk => Notclk,rst => rst,d => EM_Data2,q => MM_Data2);
	EMReg_DestAdr: ENTITY work.Reg(structure_b) GENERIC MAP(w => 3) PORT MAP(clk => Notclk,rst => rst,d => EM_DestAdr,q => MM_DestAdr);
	EMReg_InPortData: ENTITY work.Reg(structure_b) GENERIC MAP(w => 16) PORT MAP(clk => Notclk,rst => rst,d => EM_InPortData,q => MM_InPortData);
	
   MMReg_WriteBackEnable: ENTITY work.Reg(structure_b) GENERIC MAP(w => 1) PORT MAP(clk => Notclk,rst => rst,d(0) => MM_WriteBackEnable,q(0) => WriteBackEnable);
	MMReg_MemoryReadEnable: ENTITY work.Reg(structure_b) GENERIC MAP(w => 2) PORT MAP(clk => Notclk,rst => rst,d => MM_MemoryReadEnable,q => MemoryReadEnable);
	MMReg_Data1: ENTITY work.Reg(structure_b) GENERIC MAP(w => 16) PORT MAP(clk => Notclk,rst => rst,d => MM_Data1,q => Data1);
	MMReg_DestAdr: ENTITY work.Reg(structure_b) GENERIC MAP(w => 3) PORT MAP(clk => Notclk,rst => rst,d => MM_DestAdr,q => DestAdr);
	MMReg_InPortData: ENTITY work.Reg(structure_b) GENERIC MAP(w => 16) PORT MAP(clk => Notclk,rst => rst,d => MM_InPortData,q => InPortData);

	OutPortRegister: ENTITY work.Reg(structure_b) GENERIC MAP(w => 16) PORT MAP(clk => Clk,rst => rst,d => OutPortRegister_In,q => OutPortRegister_Out);
	OutPortmux: ENTITY BASICLOGIC.Muxer(structure) GENERIC MAP(n => 2,w => 16) PORT MAP(x(0) => OutPortRegister_Out,x(1) => MM_Data1,s(0) => OutPortWE,f => OutPortRegister_In);
	DataMemory: ENTITY work.RegFile(structure_b) GENERIC MAP(n_reg => 2**10,n_in => 1,n_out => 1,w => 16) PORT MAP(clk => clk,rst => rst,start => MemStart,we(0) => MemWE,inadr(0) => MM_Data2(9 DOWNTO 0),inport(0) => MM_Data1,outadr(0) => MM_Data1(9 DOWNTO 0), outport(0) => MemRead_Out);
	Datamux: ENTITY BASICLOGIC.Muxer(structure) GENERIC MAP(n => 4,w => 16) PORT MAP(x(0) => Data1,x(1) => MemRead_Out,x(2) => MemRead_Out,x(3) => InPortData,s => MemoryReadEnable,f => Datamux_Out);
	MWB_WriteData <= Datamux_Out;
	MWB_WriteBackEnable <= WriteBackEnable;
	MWB_WriteAdr <= DestAdr;
	MWB_OutPortData <= OutPortRegister_Out;
END structure;