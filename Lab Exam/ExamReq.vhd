LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity GCD is
port(A,B:in std_logic_vector(31 downto 0); Clk,Rst:in std_logic; G,Aout,Bout:out std_logic_vector(31 downto 0);V:out std_logic);
end entity GCD;


architecture archGCD of GCD is

Component my_nDFF IS
GENERIC ( n : integer := 32);
PORT( Clk,Rst,en : IN std_logic;
d : IN std_logic_vector(n-1 DOWNTO 0);
q : OUT std_logic_vector(n-1 DOWNTO 0));
END Component;

component modulus is
generic(n: integer:=8);
port(x,y:in std_logic_vector(n-1 downto 0); clk,en:in std_logic; EqualZero:out std_logic; Result:out std_logic_vector(n-1 downto 0));
end component;

signal Xin,Yin,Xout,Yout,Rin,Rout:std_logic_vector(31 downto 0);
signal IsEqualZero,enR,enX,enY:std_logic;
signal enMod:std_logic:='0';
begin

uX:my_nDFF generic map(32) port map(Clk,Rst,enX,Xin,Xout);
uY:my_nDFF generic map(32) port map(Clk,Rst,enY,Yin,Yout);
uMod:modulus generic map(32) port map(Xout,Yout,Clk,enMod,IsEqualZero,Rin);
uR:my_nDFF generic map(32) port map(Clk,Rst,enR,Rin,Rout);
Aout<=A;
Bout<=B;
process(IsEqualZero,Clk,Rst,enR,enMod,enY,enX)
variable VarEnMod:std_logic:='0';
variable VarEnX,VarEnY:std_logic;
variable VarYout,VarRout:std_logic_vector(31 downto 0);
begin
if(Rst='1') then
	VarEnX:='1';
	VarEnY:='1';
	enX<=VarEnX;
	enY<=VarEnY;
	Xin<=A;
	Yin<=B;
	VarEnMod:='0';
	enMod<=VarEnMod;
else
	if(rising_edge(Clk)) then
		VarEnX:='0';
		enX<=VarEnX;
		VarEnY:='0';
		enY<=VarEnY;
		VarEnMod:='1';
		enMod<=VarEnMod;
		enR<=(not IsEqualZero);
		if(IsEqualZero='1') then
			G<=Rout;
		else
			G<=(others => '0');
			VarEnX:='1';
			enX<=VarEnX;
			VarEnY:='0';
			enY<=VarEnY;
			VarYout:=Yout;
			Xin<=VarYout;
			VarEnX:='0';
			enX<=VarEnX;
			VarRout:=Rout;
			VarEnY:='1';
			enY<=VarEnY;
			Yin<=VarRout;
			VarEnY:='0';
			enY<=VarEnY;
		end if;
	end if;
end if;
end process;

end archGCD;
