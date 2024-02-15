LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity HazardDetectionUnit is
port(Stall,Flush:out std_logic_vector (4 downto 0); EPCenable: out std_logic; 
MemIsWriting,MemIsReading,WriteBack,ForwardingUnitFailed,OutofRange,TakenDecided,Swap:in std_logic;
Instruction: in std_logic_vector(31 downto 0);
address_wr:in std_logic_vector(6 downto 0);
memisfetching:in std_logic;
Memoryworks: in std_logic;
collsion:out std_logic;
load_use_detected:out std_logic;
load_use_hazard:in std_logic;
INT_RETI_RET:in std_logic
);
end entity HazardDetectionUnit;
--F D E M W
--  F D D E M W
--    F F D E M W
architecture archHDU of HazardDetectionUnit is
begin
        load_use_detected <= '1' when Instruction(31 downto 27) = "10010" or Instruction(31 downto 27) = "10011" else '0';

	Stall(0)<='1' when(MemIsWriting='1' or MemIsReading='1' or Swap='1' or ForwardingUnitFailed='1') or (load_use_hazard = '1' and Instruction(20 downto 14) = address_wr) --fetch stall
		else '0';
	Flush(0)<='0';

	Stall(1)<='1' when(Swap='1' or WriteBack='1' or ForwardingUnitFailed='1') or (load_use_hazard = '1' and Instruction(20 downto 14) = address_wr) --decode stall
		else '0';
	Flush(1)<='1' when (OutofRange='1' or TakenDecided='1') --decode flush
		else '0';

	Stall(2)<='1' when(Swap='1' or ForwardingUnitFailed='1') --execute stall
		else '0';
	Flush(2)<='1' when (OutofRange='1' or TakenDecided='1') --execute flush
		else '0';

	Stall(3)<='1' when(Swap='1') --Memory stall
		else '0';
	Flush(3)<='1' when (OutofRange='1' or TakenDecided='1') --Memory flush
		else '0';

	Stall(4)<='0';
	Flush(4)<='1' when (OutofRange='1' or TakenDecided='1') --Write Back flush
		else '0';
        collsion <= '1' when Memoryworks = '1' and memisfetching ='1' else '0';	
	EPCenable<='1' when (ForwardingUnitFailed='1') else '0';
end archHDU;
