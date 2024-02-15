LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity TristateBuffer IS
generic(n: integer:=8);
port(in1:in std_logic_vector (n-1 downto 0); en:in std_logic; out1:out std_logic_vector (n-1 downto 0));
end entity TristateBuffer;

architecture archTriBuff of TristateBuffer is
begin
out1<=(others => 'Z') when en='0'
else in1;
end archTriBuff;