LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;
USE BASICLOGIC.all;

ENTITY CSAdder IS
	GENERIC(
	w : natural := 16;
	w_max : natural := 4);
	PORT(
	a : IN std_logic_vector(w-1 DOWNTO 0);
	b : IN std_logic_vector(w-1 DOWNTO 0);
	cin : IN std_logic;
	s : OUT std_logic_vector(w-1 DOWNTO 0);
	cout : OUT std_logic);
END CSAdder;

ARCHITECTURE structure OF CSAdder IS
	SIGNAL s_i : array2d_of_std_logic_vector(natural(ceil(real(w)/real(w_max)))-2 DOWNTO 0)(1 DOWNTO 0) (w_max-1 DOWNTO 0);
	SIGNAL c_i : array2d_of_std_logic_vector(natural(ceil(real(w)/real(w_max)))-2 DOWNTO 0)(1 DOWNTO 0)  (0 DOWNTO 0);
	SIGNAL carry : array_of_std_logic_vector(natural(ceil(real(w)/real(w_max)))-1 DOWNTO 0) (0 DOWNTO 0);
BEGIN
	loop_add: FOR i IN 0 TO natural(ceil(real(w)/real(w_max)))-1 GENERATE		
		first: IF (i = natural(ceil(real(w)/real(w_max)))-1) GENERATE
			u_RCA: ENTITY work.RCAdder(structure) GENERIC MAP(w => w-(i*w_max)) PORT MAP(a => a(w-(i*w_max)-1 DOWNTO 0),b => b(w-(i*w_max)-1 DOWNTO 0),cin => cin,s => s(w-(i*w_max)-1 DOWNTO 0),cout => carry(i)(0));
		END GENERATE;
		other: IF (i /= natural(ceil(real(w)/real(w_max)))-1) GENERATE
			u_RCA0: ENTITY work.RCAdder(structure) GENERIC MAP(w => w_max) PORT MAP(a => a(w-(i*w_max)-1 DOWNTO w-((i+1)*w_max)),b => b(w-(i*w_max)-1 DOWNTO w-((i+1)*w_max)),cin => '0',s => s_i(i)(0),cout => c_i(i)(0)(0));
			u_RCA1: ENTITY work.RCAdder(structure) GENERIC MAP(w => w_max) PORT MAP(a => a(w-(i*w_max)-1 DOWNTO w-((i+1)*w_max)),b => b(w-(i*w_max)-1 DOWNTO w-((i+1)*w_max)),cin => '1',s => s_i(i)(1),cout => c_i(i)(1)(0));
			u_smux: ENTITY BASICLOGIC.Muxer(structure) GENERIC MAP(n => 2,w => w_max) PORT MAP(x => s_i(i),s => carry(i+1),f => s(w-(i*w_max)-1 DOWNTO w-((i+1)*w_max)));
			u_cmux: ENTITY BASICLOGIC.Muxer(structure) GENERIC MAP(n => 2,w => 1) PORT MAP(x => c_i(i),s => carry(i+1),f => carry(i));
		END GENERATE;
	END GENERATE;
	cout <= carry(0)(0);
END structure;