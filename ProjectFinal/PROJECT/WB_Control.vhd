LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY WB_Control IS
	PORT (
	OP_TYPE: IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
	OP_FUNC: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	REG_W_EN: OUT STD_LOGIC; 	
	WB_ADD: OUT STD_LOGIC; 		
	WB_DATA: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	OUT_EN: OUT STD_LOGIC;		
	SWAP: OUT STD_LOGIC);		
END ENTITY;

ARCHITECTURE WB_C_A OF WB_Control IS
BEGIN
REG_W_EN <= '1' WHEN (OP_TYPE="00" AND (OP_FUNC="011" OR OP_FUNC="100" OR OP_FUNC="110")) OR OP_TYPE="01" OR (OP_TYPE="10" AND (OP_FUNC="001" OR OP_FUNC="010" OR OP_FUNC="011"))
	ELSE '0'; 
--------------------------------------------------------------
WB_ADD <= '1' WHEN (OP_TYPE="01" AND (OP_FUNC="000" OR OP_FUNC="101")) OR (OP_TYPE="10" AND (OP_FUNC="010" OR OP_FUNC="011"))
	ELSE '0';
-------------------------------------------------------------
WB_DATA <= "001" WHEN OP_TYPE="10" AND OP_FUNC="010"							--LDM	
	ELSE "010" WHEN OP_TYPE="10" AND (OP_FUNC="001" OR OP_FUNC="010")  				--POP, LDD
	ELSE "011" WHEN OP_TYPE="01" AND OP_FUNC="000"							--MOV
	ELSE "100" WHEN (OP_TYPE="00" AND OP_FUNC="110") OR (OP_TYPE="01" AND OP_FUNC="001")		--IN, SWAP
	ELSE "000";											-- NOT, INC, ADD, SUB, AND, IADD 
-----------------------------------------------------------
OUT_EN <= '1' WHEN OP_TYPE="00" AND OP_FUNC="101"
	ELSE '0';
--------------------------------------------------------
SWAP <= '1' WHEN OP_TYPE="01" AND OP_FUNC="001"
	ELSE '0';
END WB_C_A;