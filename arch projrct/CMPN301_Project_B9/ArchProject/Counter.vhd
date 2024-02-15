LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;
USE BASICLOGIC.all;

ENTITY Counter IS
	GENERIC(
	w : natural := 16;
	w_max: natural := 4);
	PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	we : IN  std_logic;
	inc : IN std_logic_vector(w-1 DOWNTO 0);
	d : IN std_logic_vector(w-1 DOWNTO 0);
	q : OUT std_logic_vector(w-1 DOWNTO 0);
	c : OUT std_logic);
END Counter;

ARCHITECTURE structure OF Counter IS
	SIGNAL load : std_logic;
	SIGNAL r_inc : std_logic_vector(w-1 DOWNTO 0);
	SIGNAL r_new : std_logic_vector(w-1 DOWNTO 0);
	SIGNAL r_old : std_logic_vector(w-1 DOWNTO 0);
BEGIN
	u_Adder: ENTITY work.CSAdder(structure) GENERIC MAP(w => w,w_max => w_max) PORT MAP(a => r_old,b => inc,cin => '0',s => r_inc,cout => c);
	u_mux: ENTITY BASICLOGIC.Muxer(structure) GENERIC MAP(n => 2,w => w) PORT MAP(x(0) => r_inc,x(1) => d,s(0) => load,f => r_new);
	u_Reg: ENTITY work.Reg(structure_b) GENERIC MAP(w => w) PORT MAP(clk => clk,rst => '0',d => r_new,q => r_old);
	load <= we or rst;
	q <= r_old;
END structure;