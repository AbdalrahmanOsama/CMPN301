LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;
USE BASICLOGIC.ALL;

--Todo: Add inputs and outputs for interrupts and flags
ENTITY ControlUnit IS
	PORT(
	opcode : IN std_logic_vector(6 DOWNTO 0);
	ALUFlagEnable : OUT std_logic;
	ALUOperation : OUT std_logic_vector(4 DOWNTO 0);
	ImmediateValue : OUT std_logic;
	WriteBackEnable : OUT std_logic;
	MemoryReadEnable : OUT std_logic_vector(1 DOWNTO 0);
   MemoryWriteEnable : OUT std_logic_vector(1 DOWNTO 0));
END ControlUnit;

ARCHITECTURE structure OF ControlUnit IS
ALIAS opcode_type: std_logic_vector(1 DOWNTO 0) IS opcode(6 DOWNTO 5);
ALIAS opcode_config: std_logic_vector(1 DOWNTO 0) IS opcode(4 DOWNTO 3);
ALIAS opcode_num: std_logic_vector(2 DOWNTO 0) IS opcode(2 DOWNTO 0);
BEGIN
	--ALU Flag Enable operations:
	ALUFlagEnable <=
			  '1' WHEN opcode_type = "01"
		ELSE '0' ;
	--ALU Operation operations:
	ALUOperation <=
			  "01010" WHEN opcode_type = "01" AND opcode_config = "11" and opcode_num = "000" --AND
      ELSE "01000" WHEN opcode_type = "01" AND opcode_config = "11" and opcode_num = "001" --OR
      ELSE "01110" WHEN opcode_type = "01" AND opcode_config = "01" and opcode_num = "000" --NOT
      ELSE "00010" WHEN opcode_type = "01" AND  opcode_config = "11" and opcode_num = "010" --ADD
      ELSE "00001" WHEN opcode_type = "01" AND opcode_config = "01" and opcode_num = "010" --INC
      ELSE "00010" WHEN opcode_type = "01" AND opcode_config = "10" and opcode_num = "010" --IADD
      ELSE "00101" WHEN opcode_type = "01" AND opcode_config = "11" and opcode_num = "011" --SUB
      ELSE "00110" WHEN opcode_type = "01" AND opcode_config = "01" and opcode_num = "011" --DEC
      ELSE "00111" WHEN opcode_type = "01" AND opcode_config = "10" and opcode_num = "100" --LDM
      ELSE "00000" ;
	--Immediate Value operations:
	ImmediateValue <=
			  '1' WHEN opcode_config = "10"
		ELSE '0' ;
	-- WriteBack Enable operations
	WriteBackEnable <=
		     '1' WHEN opcode_type = "01" -- operations
		ELSE '1' WHEN opcode = "1001000" --ldd
		ELSE '1' WHEN opcode = "1000010" -- pop
		ELSE '1' WHEN opcode = "1000100" --in
		ELSE '0' ;
	-- Memory Read Enable operations
	MemoryReadEnable <=
		     "01" WHEN opcode = "1001000" --ldd
		ELSE "10" WHEN opcode = "1000010" -- pop
		ELSE "11" WHEN opcode = "1000100" --in
		ELSE "10" WHEN opcode = "1100001" --ret
		ELSE "10" WHEN opcode = "1100011" --rti
		ELSE "00" ;
	-- Memory Write Enable operations
	MemoryWriteEnable <=
            "01" WHEN opcode = "1011001" -- std
		ELSE "10" WHEN opcode = "1001011" --push	
		ELSE "11" WHEN opcode = "1001101" --out
		ELSE "10" WHEN opcode = "1100000" --call
		ELSE "10" WHEN opcode = "1100010" --int
		ELSE "00" ;
END structure;

