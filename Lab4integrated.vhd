LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

Entity Lab4Integrated is
port(	Inp:in std_logic_vector(15 downto 0);
	Outp:out std_logic_vector(15 downto 0);
	clk:in std_logic;
	rs:in std_logic);
end entity Lab4Integrated;


architecture archLab4 of Lab4Integrated is
signal countout : std_logic_vector (2 downto 0);
signal counten : std_logic;
signal addressOut : std_logic_vector (19 downto 0);
signal re : std_logic;
signal we : std_logic;

component ram is
	PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		re  : IN std_logic;
		address : IN  std_logic_vector(19 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
end component;

component ControlUnit is
Port(	CountIn:in std_logic_vector(2 downto 0);
		clk:in std_logic;
		re:out std_logic;
		we:out std_logic;
		CountEn:out std_logic;
		address:out std_logic_vector(19 downto 0));
end component;

component Counter is
Port(	en:in std_logic;
		clk:in std_logic;
		rs:in std_logic;
		count:out std_logic_vector (2 downto 0));
end component;


begin

c1:ram port map(clk,we,re,addressOut,Inp,Outp);
c2:ControlUnit port map(countout,clk,re,we,CountEn,addressOut);
c3:Counter port map(CountEn,clk,rs,countout);

end archLab4;
