LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity modulus is
generic(n: integer:=8);
port(x,y:in std_logic_vector(n-1 downto 0); clk,en:in std_logic; EqualZero:out std_logic; Result:out std_logic_vector(n-1 downto 0));
end entity modulus;

architecture archmodulus of modulus is
signal sigzeroes:std_logic_vector(n-1 downto 0);
begin
sigzeroes<=(others=>'0');
process(clk,en)
variable VarX,VarY,VarResult:integer;
variable zeroes:integer;
begin
if(en='0') then
Result<=(others=>'0');
EqualZero<='0';

else
if(rising_edge(clk)) then
VarX:=to_integer(unsigned(x));
VarY:=to_integer(unsigned(y));
zeroes:=to_integer(unsigned(sigzeroes));
if(VarY/=zeroes) then
	VarResult:=(VarX mod VarY);
	if(VarResult <= zeroes) then
	EqualZero<='1';
	else
	EqualZero<='0';
	end if;
	Result<=(std_logic_vector(to_unsigned(VarResult,n)));
end if;
end if;
end if;

end process;


end archmodulus;
