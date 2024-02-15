Library ieee;
use ieee.std_logic_1164.all;

entity memory_CU is
port(
OP_type:in std_logic_vector(1 downto 0);
OP_function:in std_logic_vector(2 downto 0);
Stack_op:out std_logic;
push,pop:out std_logic;
MEMW,MEMR:out std_logic;
mux1:out std_logic;
index:in std_logic;
memory_c:out std_logic;
mux2:out std_logic_vector(1 downto 0);
RT_RTI_RET:out std_logic;
WB_INSTR: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
);
end entity;

architecture A_memory_CU of memory_CU is
signal Opcode:std_logic_vector(4 downto 0);
SIGNAL WB_DETECTED, W_ADD1_USED, W_ADD2_USED: STD_LOGIC;
begin
WB_DETECTED <= '1' when Opcode = "00011" or Opcode = "00100" or Opcode = "00110" or Opcode(4 DOWNTO 3) = "01" or Opcode = "10001" or Opcode = "10010" or Opcode = "10011" 
ELSE '0';
W_ADD1_USED <= '1' WHEN Opcode = "00011" or Opcode = "00100" or Opcode = "00110" or Opcode = "01001" or Opcode = "01010" or Opcode = "01011" or Opcode = "01100" or Opcode = "10001"
ELSE '0';
W_ADD2_USED <= '1' WHEN Opcode = "01001" or Opcode = "01000" or Opcode = "01101" or Opcode = "10010" or Opcode = "10011"
ELSE '0';

WB_INSTR <= WB_DETECTED & W_ADD1_USED & W_ADD2_USED;
Opcode <= Op_type & OP_function;
RT_RTI_RET <='1' when Opcode="11110" or Opcode="11111" or Opcode="11101" else '0';
MEMW <= '1' when Opcode = "10100" or Opcode = "10000" else '0';
mux1<= '1' when Opcode = "11111" or Opcode = "11101" or Opcode = "11100" or Opcode = "10000" or Opcode = "10001" or Opcode = "11110"
else '0'; 
memory_c <= '1' when Opcode = "10100" or Opcode = "10000" or Opcode = "10001" or Opcode = "10010" or Opcode = "10011" or Opcode = "11100" or Opcode = "11101" or Opcode = "11110" or Opcode = "11111" else '0';
mux2<="00" when Opcode="11110" and index = '1'
else "01" when Opcode="11110" and index = '0'
else "10" when Opcode ="10100" or Opcode = "10000" --operand
else "11";--empty
MEMR <= '1' when Opcode = "10001" or Opcode = "10010" or Opcode = "10011" or Opcode = "11100" or Opcode = "11101" or Opcode = "11110" or Opcode = "11111" else '0';
Stack_op <= '1' when Opcode = "11111" or Opcode = "11101" or Opcode = "11100" or Opcode = "10000" or Opcode = "10001" or Opcode = "11110" else '0';
push <= '1' when Opcode = "10000" or Opcode = "11100" or Opcode = "11110" else '0';
pop <= '1' when Opcode = "10001" or Opcode = "11101" or Opcode ="11111" else '0';

end architecture;