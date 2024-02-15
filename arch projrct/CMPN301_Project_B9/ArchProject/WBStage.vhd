LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;
USE BASICLOGIC.all;

ENTITY WBStage IS
	PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	MWB_WriteBackEnable : IN std_logic;
	MWB_WriteData : IN std_logic_vector(15 DOWNTO 0);
	MWB_WriteAdr : IN std_logic_vector(2 DOWNTO 0);
	MWB_OutPortData : IN std_logic_vector(15 DOWNTO 0);
	WriteBackEnable : OUT std_logic;
	WriteData : OUT std_logic_vector(15 DOWNTO 0);
	WriteAdr : OUT std_logic_vector(2 DOWNTO 0);
	OutPortData : OUT std_logic_vector(15 DOWNTO 0));
END WBStage;

ARCHITECTURE structure OF WBStage IS
	SIGNAL Notclk : std_logic;
BEGIN
	Notclk <= not clk;
	MWBReg_WriteBackEnable: ENTITY work.Reg(structure_b) GENERIC MAP(w => 1) PORT MAP(clk => Notclk,rst => rst,d(0) => MWB_WriteBackEnable,q(0) => WriteBackEnable);
	MWBReg_WriteData: ENTITY work.Reg(structure_b) GENERIC MAP(w => 16) PORT MAP(clk => Notclk,rst => rst,d => MWB_WriteData,q => WriteData);
	MWBReg_DestAdr: ENTITY work.Reg(structure_b) GENERIC MAP(w => 3) PORT MAP(clk => Notclk,rst => rst,d => MWB_WriteAdr,q => WriteAdr);
	MWBReg_OutPortData: ENTITY work.Reg(structure_b) GENERIC MAP(w => 16) PORT MAP(clk => Notclk,rst => rst,d => MWB_OutPortData,q => OutPortData);
END structure;