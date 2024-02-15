LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY WB_Stage IS
	PORT (
	CLK : IN STD_LOGIC;
	
	W_Add_1, W_Add_2: IN std_logic_vector(2 downto 0);
	WB_Add_S: IN std_logic;
	
	ALU, IMM, MEM, REG_DATA_1, REG_DATA_2: IN std_logic_vector(31 downto 0);
	WB_DATA_S: IN STD_LOGIC_vector(2 downto 0);
	
	SWAP, OUT_EN: IN STD_LOGIC;
	
	WB_ADD: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	WB_DATA: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	OUT_PORT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));  			
END ENTITY;

ARCHITECTURE WB_STAGE_A OF WB_Stage IS
COMPONENT MUX2x1
Generic(DataSize: integer :=32);
port(
Input1,Input2: in std_logic_vector(DataSize-1 DOWNTO 0);
SEL : in std_logic;
F: out std_logic_vector(DataSize-1 DOWNTO 0));
END COMPONENT;
--------------------------------------
COMPONENT MUX8x1
port(
Input1,Input2,Input3,Input4 : in std_logic_vector(31 DOWNTO 0);
Input5,Input6,Input7,Input8: in std_logic_vector(31 DOWNTO 0);
sel : in std_logic_VECTOR(2 downto 0);
F: out std_logic_vector(31 DOWNTO 0));
END COMPONENT;
----------------------------------------
COMPONENT triStateBuffer
Port (
	Input    : in std_logic_vector(31 downto 0);    -- single buffer input
	EN   : in  STD_LOGIC;    -- single buffer enable
        Output   : out  std_logic_vector(31 downto 0));   -- single buffer output
END COMPONENT;
------------------------------------------

SIGNAL WB_DATA_SEL: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL IS_SWAP: STD_LOGIC := '0';
SIGNAL WB_ADD_SEL: STD_LOGIC;
BEGIN
-- 2x1 MUX:
--inputs: W_Add_1, W_Add_2
--Select: WB_Add_S
--Output: WB_ADD
MUX2: MUX2x1 GENERIC MAP(3) PORT MAP (W_Add_1, W_Add_2, WB_ADD_SEL, WB_ADD);


--8x1 MUX:
--inputs: ALU, IMM, MEM, REG_DATA_1, REG_DATA_2, 0,0,0
--Select: WB_DATA_S
--Output:WB_DATA
MUX8: MUX8x1 GENERIC MAP(32) PORT MAP (ALU, IMM, MEM, REG_DATA_1, REG_DATA_2,(OTHERS=>'0'),(OTHERS=>'0'),(OTHERS=>'0'), WB_DATA_SEL, WB_DATA);

--Tristate buffer:
--input: REG_DATA_1
--enable: OUT_EN
--output: OUT_PORT
TRI: triStateBuffer GENERIC MAP(32) PORT MAP (REG_DATA_1, OUT_EN, OUT_PORT);

--SWAPING:
--First clk cycle --> same as given signals
--second clk cycle --> change mux select
PROCESS(CLK, SWAP, IS_SWAP, WB_Add_S, WB_DATA_S)
VARIABLE IS_SWAP_V: STD_LOGIC :='0';
BEGIN
IF(rising_edge(clk) AND SWAP ='1' AND IS_SWAP = '0') THEN
	IS_SWAP_V := '1';
	WB_ADD_SEL <= WB_Add_S;
	WB_DATA_SEL <= WB_DATA_S;
ELSIF(rising_edge(clk) AND SWAP ='1' AND IS_SWAP = '1') THEN
	WB_ADD_SEL <= '1';
	WB_DATA_SEL <= "011";
	IS_SWAP_V := '0';
ELSIF (SWAP ='0') THEN
	WB_ADD_SEL <= WB_Add_S;
	WB_DATA_SEL <= WB_DATA_S;
END IF;
IS_SWAP <= IS_SWAP_V;
END PROCESS;

END WB_STAGE_A;