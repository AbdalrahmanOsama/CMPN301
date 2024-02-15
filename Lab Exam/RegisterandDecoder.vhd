LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity RegisterArray is
port(clk,rst,srcen,dsten:in std_logic; dstsl,srcsl:in std_logic_vector (1 downto 0);databus:inout std_logic_vector (31 downto 0));
end entity RegisterArray;

architecture archRegisterArray of RegisterArray is

component Decoder2x4 Is
port(in1:in std_logic_vector (1 downto 0); en:in std_logic; out1,out2,out3,out4:out std_logic);
end component;

component my_nDFF IS
GENERIC ( n : integer := 32);
PORT( Clk,Rst,en : IN std_logic;
d : IN std_logic_vector(n-1 DOWNTO 0);
q : OUT std_logic_vector(n-1 DOWNTO 0));
END component;

component TristateBuffer IS
port(in1:in std_logic_vector (31 downto 0); en:in std_logic; out1:out std_logic_vector (31 downto 0));
end component;

signal ren1,ren2,ren3,ren4,ten1,ten2,ten3,ten4: std_logic;
signal abt,bbt,cbt,dbt: std_logic_vector (31 downto 0);

begin

r1:my_nDFF generic map(32) port map(clk,rst,ren1,databus,abt);
r2:my_nDFF generic map(32) port map(clk,rst,ren2,databus,bbt);
r3:my_nDFF generic map(32) port map(clk,rst,ren3,databus,cbt);
r4:my_nDFF generic map(32) port map(clk,rst,ren4,databus,dbt);
decdst:Decoder2x4 port map(dstsl,dsten,ren1,ren2,ren3,ren4);
decsrc:Decoder2x4 port map(srcsl,srcen,ten1,ten2,ten3,ten4);
tri1:TristateBuffer port map(abt,ten1,databus);
tri2:TristateBuffer port map(bbt,ten2,databus);
tri3:TristateBuffer port map(cbt,ten3,databus);
tri4:TristateBuffer port map(dbt,ten4,databus);



end archRegisterArray;
