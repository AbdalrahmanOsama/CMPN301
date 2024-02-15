LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity Decoder2x4 Is
port(in1:in std_logic_vector (1 downto 0);en:in std_logic ;out1,out2,out3,out4:out std_logic);
end entity Decoder2x4;

architecture archDecoder2x4 of Decoder2x4 is

begin
	process(en,in1)
	begin
	if (en='0') then
	out1<='0';
	out2<='0';
	out3<='0';
	out4<='0';
	elsif (in1="00") then
	out1<='1';
	out2<='0';
	out3<='0';
	out4<='0';
	elsif (in1="01") then
	out1<='0';
	out2<='1';
	out3<='0';
	out4<='0';
	elsif (in1="10") then
	out1<='0';
	out2<='0';
	out3<='1';
	out4<='0';
	elsif (in1="11") then
	out1<='0';
	out2<='0';
	out3<='0';
	out4<='1';
	end if;
end process;
end archDecoder2x4;
