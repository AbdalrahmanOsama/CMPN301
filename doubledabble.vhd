library ieee;
use ieee.std_logic_1164.all;

entity DoubleDabble is
port(A_in:in std_logic_vector (7 downto 0); Clk,Rst:in std_logic; F1,F2,F3:out std_logic_vector (3 downto 0);
 A_out:out std_logic_vector (7 downto 0); V:out std_logic);
end entity DoubleDabble;

architecture archDoubleDabble of DoubleDabble is

--signal Calculations : std_logic_vector (19 downto 0);
--signal temp : std_logic_vector (7 downto 0);

component nBitAdder is
generic(n: integer:=8);
port(a,b:in std_logic_vector (n-1 downto 0);cin: in std_logic;s: out std_logic_vector (n-1 downto 0);cout: out std_logic;enable:in std_logic);
end component nBitAdder;

signal threeOnes : std_logic_vector(19 downto 0):=(9=>'1',8=>'1',others=>'0');
signal threeTens : std_logic_vector(19 downto 0):=(13=>'1',12=>'1',others=>'0');
signal threeHundreds : std_logic_vector(19 downto 0):=(17=>'1',16=>'1',others=>'0');
signal CalcFinal: std_logic_vector(19 downto 0);
signal Calc1: std_logic_vector(19 downto 0);
signal Calc2: std_logic_vector(19 downto 0);
signal Calc3: std_logic_vector(19 downto 0);
signal Cout : std_logic:='0';
signal en1 : std_logic:='0';
signal en2 : std_logic:='0';
signal en3 : std_logic:='0';
begin

u0:nBitAdder generic map(20) port map(Calc1,threeOnes,'0',CalcFinal,Cout,en1);
u1:nBitAdder generic map(20) port map(Calc2,threeTens,'0',CalcFinal,Cout,en2);
u2:nBitAdder generic map(20) port map(Calc3,threeHundreds,'0',CalcFinal,Cout,en3);

process(Clk,Rst,A_in,en1,en2,en3)
variable ShiftedCalc: std_logic_vector(19 downto 0);
variable VarEn1 : std_logic:='0';
variable VarEn2 : std_logic:='0';
variable VarEn3 : std_logic:='0';
begin
	if(Rst='1') then
		ShiftedCalc(7 downto 0):=A_in;
		ShiftedCalc(19 downto 8):=(others=>'0');
		CalcFinal(7 downto 0)<=A_in;
		CalcFinal(19 downto 8)<=(others=>'0');
		Calc1(7 downto 0)<=A_in;
		Calc1(19 downto 8)<=(others=>'0');
		Calc2(7 downto 0)<=A_in;
		Calc2(19 downto 8)<=(others=>'0');
		Calc3(7 downto 0)<=A_in;
		Calc3(19 downto 8)<=(others=>'0');
	elsif (rising_edge(Clk)) then
		ShiftedCalc:=CalcFinal(18 downto 0) & '0';
		VarEn1:='0';
		VarEn2:='0';
		VarEn3:='0';
		en1<=VarEn1;
		en2<=VarEn2;
		en3<=VarEn3;
		if(ShiftedCalc(11 downto 8)>="0101") then
			Calc1<=ShiftedCalc;
			VarEn1:='1';
			en1<=VarEn1;
		end if;
		if(ShiftedCalc(15 downto 12)>="0101") then
			Calc2<=ShiftedCalc;
			VarEn2:='1';
			en2<=VarEn2;
		end if;
		if(ShiftedCalc(19 downto 16)>="0101") then
			Calc3<=ShiftedCalc;
			VarEn3:='1';
			en3<=VarEn3;
		end if;
	elsif (rising_edge(Clk) and (ShiftedCalc(7 downto 0)="00000000")) then
		A_out<=A_in;
		ShiftedCalc:=CalcFinal(18 downto 0) & '0';
		F3<=ShiftedCalc(19 downto 16);
		F2<=ShiftedCalc(15 downto 12);
		F1<=ShiftedCalc(11 downto 8);
		if(Cout >= '1') then
			V<='0';
		else
			V<='1';
		end if;
	end if;
end process;

end archDoubleDabble;