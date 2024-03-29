LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity HazardDetectionUnit is
port(Stall,Flush:out std_logic_vector (4 downto 0); EPCenable: out std_logic; 
MemIsWriting,MemIsReading,WriteBack,ForwardingUnitFailed,OutofRange,TakenDecided,Swap:in std_logic);
end entity HazardDetectionUnit;

architecture archHDU of HazardDetectionUnit is
begin
	Stall(0)<='1' when(MemIsWriting='1' or MemIsReading='1' or Swap='1' or ForwardingUnitFailed='1') --fetch stall
		else '0';
	Flush(0)<='0';

	Stall(1)<='1' when(Swap='1' or WriteBack='1' or ForwardingUnitFailed='1') --decode stall
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
	
	EPCenable<='1' when (OutofRange='1') else '0';
end archHDU;
