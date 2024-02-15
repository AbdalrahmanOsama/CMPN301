LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Execution_Control IS
	PORT (
	OP_TYPE: IN STD_LOGIC_VECTOR(1 DOWNTO 0); 
	OP_FUNC: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	ALU_OP: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	IN_OP: OUT STD_LOGIC;
	ONE_OP: OUT STD_LOGIC;
	CCR_W_EN: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	JMP_TYP: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	JMP_OP: OUT STD_LOGIC;
	SRC1: OUT STD_LOGIC;
	SRC2: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)); 
END ENTITY;

ARCHITECTURE E_CU_A OF Execution_Control is
BEGIN
		--TYPE 1--
ALU_OP <= "1000" WHEN OP_TYPE="00" AND OP_FUNC="010"		--SETC 
	ELSE "1001" WHEN OP_TYPE="00" AND OP_FUNC="011"		--NOT
	ELSE "1010" WHEN OP_TYPE="00" AND OP_FUNC="100"		--INC
		--TYPE 2--
	ELSE "1100" WHEN (OP_TYPE="01" AND OP_FUNC="010") or (OP_TYPE="01" AND OP_FUNC="100") or (OP_TYPE="11" AND OP_FUNC="110") OR (OP_TYPE="10" AND (OP_FUNC="011" OR OP_FUNC="100")) --ADD. IADD, INT, LD, SW
	ELSE "1101" WHEN OP_TYPE="01" AND OP_FUNC="011"		--SUB
	ELSE "1110" WHEN OP_TYPE="01" AND OP_FUNC="100"		--AND
		--TYPE 3--
	ELSE "1111" WHEN OP_TYPE="11" AND (OP_FUNC="000" OR OP_FUNC="001" OR OP_FUNC="010")	--JMP
	ELSE "0ZZZ";
------------------------------------------------------------------------------------------------------
IN_OP <= '1' WHEN OP_TYPE="00" AND OP_FUNC="110"
	ELSE '0';
-------------------------------------------------------------------
ONE_OP <= '1' WHEN OP_TYPE="00" OR (OP_TYPE="10" AND OP_FUNC="001")
	ELSE '0';
---------------------------------------------------------------------
CCR_W_EN <= "001" WHEN OP_TYPE="00" AND OP_FUNC="010" 		--SETC
	ELSE "110" WHEN OP_TYPE="00" AND OP_FUNC="011"		--NOT
	ELSE "110" WHEN OP_TYPE="00" AND OP_FUNC="100"		--INC
	ELSE "110" WHEN OP_TYPE="01" AND OP_FUNC="010"		--ADD
	ELSE "110" WHEN OP_TYPE="01" AND OP_FUNC="011"		--SUB
	ELSE "110" WHEN OP_TYPE="01" AND OP_FUNC="100"		--AND
	ELSE "110" WHEN OP_TYPE="01" AND OP_FUNC="100"		--IADD
	ELSE "100" WHEN OP_TYPE="11" AND OP_FUNC="000"		--JZ
	ELSE "010" WHEN OP_TYPE="11" AND OP_FUNC="001"		--JN
	ELSE "001" WHEN OP_TYPE="11" AND OP_FUNC="010"		--JC
	ELSE "111" WHEN OP_TYPE="11" AND OP_FUNC="111"		--RTI	
	ELSE "000";
-----------------------------------------------------------------------------------------
SRC1 <= '0' WHEN (OP_TYPE="11" AND OP_FUNC="110")	--INT
ELSE '1';
-----------------------------------------------------------------------------------------
SRC2 <= "00" WHEN (OP_TYPE="01") AND (OP_FUNC="010" OR OP_FUNC="011" OR OP_FUNC="100")	--ADD, SUB, AND
ELSE "01" WHEN (OP_TYPE="01" AND OP_FUNC="101") OR (OP_TYPE="10" AND (OP_FUNC="011" OR OP_FUNC="100"))	--ADDI, LDD, SW
ELSE "10" WHEN (OP_TYPE="11" AND OP_FUNC="110")	--INT
ELSE "00";
-----------------------------------------------------------------------------------------
JMP_OP <= '1' WHEN OP_TYPE="11" AND (OP_FUNC = "000" OR OP_FUNC = "001" OR OP_FUNC = "010" OR OP_FUNC = "011")
ELSE '0';
-----------------------------------------------------------------------------------------
JMP_TYP <= "00" WHEN OP_TYPE="11" AND OP_FUNC = "000"
ELSE "01" WHEN OP_TYPE="11" AND OP_FUNC = "001"
ELSE "10" WHEN OP_TYPE="11" AND OP_FUNC = "010"
ELSE "11" WHEN OP_TYPE="11" AND OP_FUNC = "011"
ELSE "00";
END E_CU_A;