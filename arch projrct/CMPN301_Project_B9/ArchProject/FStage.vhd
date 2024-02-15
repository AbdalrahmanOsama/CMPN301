LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;
USE BASICLOGIC.all;

ENTITY FStage IS
	PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	interrupt : IN std_logic;
	InPortData : IN std_logic_vector(15 DOWNTO 0);
	FD_Instruction : OUT std_logic_vector(31 DOWNTO 0);
	FD_InPortData : OUT std_logic_vector(15 DOWNTO 0));
END FStage;

ARCHITECTURE structure OF FStage IS
	SIGNAL Notclk : std_logic;
	SIGNAL Instruction : std_logic_vector(31 DOWNTO 0);
	SIGNAL PC_out : std_logic_vector(15 DOWNTO 0);
	SIGNAL InstReadAdr : std_logic_vector(15 DOWNTO 0);
BEGIN
	Notclk <= not clk;
	
	PC: ENTITY work.Counter(structure) GENERIC MAP(w => 16,w_max => 4) PORT MAP(clk => clk,rst => rst,we => '0',inc => (0=>'1',OTHERS=>'0'),d => Instruction(15 DOWNTO 0),q => PC_out);
	InstCache: ENTITY work.RegFile(structure_a) GENERIC MAP(n_reg => 2**10,n_in => 1,n_out => 1,w => 32) PORT MAP(clk => clk,rst => '0',start => '1',we(0) => '0',inadr(0) => (OTHERS=>'0'),inport(0) => (OTHERS=>'0'),outadr(0) => InstReadAdr(9 DOWNTO 0), outport(0) => Instruction);
	mux_rst: ENTITY BASICLOGIC.Muxer(structure) GENERIC MAP(n => 2,w => 16) PORT MAP(x(0) => PC_out,x(1) => (OTHERS=>'0'),s(0) => rst,f => InstReadAdr);
	FD_Instruction <= Instruction;
	FD_InPortData <= InPortData;
END structure;