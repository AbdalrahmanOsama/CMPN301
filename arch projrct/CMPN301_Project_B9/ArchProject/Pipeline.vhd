LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;
USE BASICLOGIC.all;

ENTITY Pipeline IS
	PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	interrupt : IN std_logic;
	InPort : IN std_logic_vector(15 DOWNTO 0);
	OutPort : OUT std_logic_vector(15 DOWNTO 0));
END Pipeline;

ARCHITECTURE structure OF Pipeline IS
SIGNAL FD_Instruction : std_logic_vector(31 DOWNTO 0);
SIGNAL FD_InPortData : std_logic_vector(15 DOWNTO 0);
SIGNAL DE_ALUFlagEnable : std_logic;
SIGNAL DE_ALUOperation : std_logic_vector(4 DOWNTO 0);
SIGNAL DE_ImmediateValue : std_logic;
SIGNAL DE_WriteBackEnable : std_logic;
SIGNAL DE_MemoryReadEnable : std_logic_vector(1 DOWNTO 0);
SIGNAL DE_MemoryWriteEnable : std_logic_vector(1 DOWNTO 0);
SIGNAL DE_Data1 : std_logic_vector(15 DOWNTO 0);
SIGNAL DE_Data2 : std_logic_vector(15 DOWNTO 0);
SIGNAL DE_DestAdr : std_logic_vector(2 DOWNTO 0);
SIGNAL DE_InPortData : std_logic_vector(15 DOWNTO 0);
SIGNAL EM_WriteBackEnable : std_logic;
SIGNAL EM_MemoryReadEnable : std_logic_vector(1 DOWNTO 0);
SIGNAL EM_MemoryWriteEnable : std_logic_vector(1 DOWNTO 0);
SIGNAL EM_Data1 : std_logic_vector(15 DOWNTO 0);
SIGNAL EM_Data2 : std_logic_vector(15 DOWNTO 0);
SIGNAL EM_DestAdr : std_logic_vector(2 DOWNTO 0);
SIGNAL EM_InPortData : std_logic_vector(15 DOWNTO 0);
SIGNAL MWB_WriteBackEnable : std_logic;
SIGNAL MWB_WriteData : std_logic_vector(15 DOWNTO 0);
SIGNAL MWB_WriteAdr : std_logic_vector(2 DOWNTO 0);
SIGNAL MWB_OutPortData : std_logic_vector(15 DOWNTO 0);
SIGNAL WriteBackEnable : std_logic;
SIGNAL WriteData : std_logic_vector(15 DOWNTO 0);
SIGNAL WriteAdr : std_logic_vector(2 DOWNTO 0);
SIGNAL OutPortData : std_logic_vector(15 DOWNTO 0);
BEGIN
	Fetch: ENTITY work.FStage(structure) PORT MAP(clk,rst,interrupt,InPort,FD_Instruction,FD_InPortData);
	Decode: ENTITY work.DStage(structure) PORT MAP(clk,rst,FD_Instruction,FD_InPortData,WriteBackEnable,WriteData,WriteAdr,DE_ALUFlagEnable,DE_ALUOperation,DE_ImmediateValue,DE_WriteBackEnable,DE_MemoryReadEnable,DE_MemoryWriteEnable,DE_Data1,DE_Data2,DE_DestAdr,DE_InPortData);
	Execute: ENTITY work.EStage(structure) PORT MAP(clk,rst,DE_ALUFlagEnable,DE_ALUOperation,DE_ImmediateValue,DE_WriteBackEnable,DE_MemoryReadEnable,DE_MemoryWriteEnable,DE_Data1,DE_Data2,DE_DestAdr,DE_InPortData,EM_WriteBackEnable,EM_MemoryReadEnable,EM_MemoryWriteEnable,EM_Data1,EM_Data2,EM_DestAdr,EM_InPortData);
	Memory: ENTITY work.MStage(structure) PORT MAP(clk,rst,EM_WriteBackEnable,EM_MemoryReadEnable,EM_MemoryWriteEnable,EM_Data1,EM_Data2,EM_DestAdr,EM_InPortData,MWB_WriteBackEnable,MWB_WriteData,MWB_WriteAdr,MWB_OutPortData); 
	WriteBack: ENTITY work.WBStage(structure) PORT MAP(clk,rst,MWB_WriteBackEnable,MWB_WriteData,MWB_WriteAdr,MWB_OutPortData,WriteBackEnable,WriteData,WriteAdr,OutPortData);
	OutPort <= OutPortData;
END structure;