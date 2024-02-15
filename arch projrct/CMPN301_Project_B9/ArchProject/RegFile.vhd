LIBRARY IEEE;
LIBRARY BASICLOGIC;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
USE IEEE.math_real.all;

USE BASICLOGIC.custom_types.all;
USE BASICLOGIC.all;

ENTITY RegFile IS
	GENERIC(
	n_reg : natural := 6;
	n_in : natural := 2;
	n_out : natural := 1;
	w : natural := 16);
	PORT(
	clk : IN std_logic;
	rst : IN std_logic;
	start : IN std_logic;
	we : IN array_of_std_logic(n_in-1 DOWNTO 0);
	inadr : IN array_of_std_logic_vector(n_in-1 DOWNTO 0) (natural(ceil(log2(real(n_reg))))-1 DOWNTO 0);
	inport : IN array_of_std_logic_vector(n_in-1 DOWNTO 0) (w-1 DOWNTO 0);
	outadr : IN array_of_std_logic_vector(n_out-1 DOWNTO 0) (natural(ceil(log2(real(n_reg))))-1 DOWNTO 0);
	outport : OUT array_of_std_logic_vector(n_out-1 DOWNTO 0) (w-1 DOWNTO 0));
END RegFile;

ARCHITECTURE structure_a OF RegFile IS
	SIGNAL ram : array_of_std_logic_vector(n_reg-1 DOWNTO 0) (w-1 DOWNTO 0);
	SIGNAL writeenable : array_of_std_logic(n_in-1 DOWNTO 0);
	SIGNAL writeadr : array_of_std_logic_vector(n_in-1 DOWNTO 0) (natural(ceil(log2(real(n_reg))))-1 DOWNTO 0);
	SIGNAL writedata : array_of_std_logic_vector(n_in-1 DOWNTO 0) (w-1 DOWNTO 0);
	SIGNAL readadr : array_of_std_logic_vector(n_out-1 DOWNTO 0) (natural(ceil(log2(real(n_reg))))-1 DOWNTO 0);
BEGIN
	PROCESS(clk,rst) IS
	BEGIN
		IF(rst = '1') THEN
			ram <= (OTHERS =>(OTHERS=>'0'));
			writeenable <= (OTHERS=>'0');
			writeadr <= (OTHERS =>(OTHERS=>'0'));
			writedata <= (OTHERS =>(OTHERS=>'0'));
			readadr <= (OTHERS =>(OTHERS=>'0'));
		ELSIF rising_edge(clk) THEN
			IF(start = '1') THEN
				writeenable <= we;
				writeadr <= inadr;
				writedata <= inport;
				readadr <= outadr;
			ELSE
				writeenable <= (OTHERS=>'0');
				writeadr <= (OTHERS =>(OTHERS=>'0'));
				writedata <= (OTHERS =>(OTHERS=>'0'));
				readadr <= (OTHERS =>(OTHERS=>'0'));
			END IF;
			loop_in: FOR i IN 0 TO n_in-1 LOOP
				IF writeenable(i) = '1' THEN
					ram(to_integer(unsigned(writeadr(i)))) <= writedata(i);
				END IF;
			END LOOP;
		END IF;
	END PROCESS;
	loop_out: FOR i IN 0 TO n_out-1 GENERATE
		outport(i) <= ram(to_integer(unsigned(readadr(i))));
	END GENERATE;
END structure_a;

ARCHITECTURE structure_b OF RegFile IS
	SIGNAL ram : array_of_std_logic_vector(n_reg-1 DOWNTO 0) (w-1 DOWNTO 0);
	SIGNAL writeenable : array_of_std_logic(n_in-1 DOWNTO 0);
	SIGNAL writeadr : array_of_std_logic_vector(n_in-1 DOWNTO 0) (natural(ceil(log2(real(n_reg))))-1 DOWNTO 0);
	SIGNAL writedata : array_of_std_logic_vector(n_in-1 DOWNTO 0) (w-1 DOWNTO 0);
	SIGNAL readadr : array_of_std_logic_vector(n_out-1 DOWNTO 0) (natural(ceil(log2(real(n_reg))))-1 DOWNTO 0);
	SIGNAL busy : std_logic;
	SIGNAL we_buff : array_of_std_logic(n_in-1 DOWNTO 0);
	SIGNAL inadr_buff : array_of_std_logic_vector(n_in-1 DOWNTO 0) (natural(ceil(log2(real(n_reg))))-1 DOWNTO 0);
	SIGNAL inport_buff : array_of_std_logic_vector(n_in-1 DOWNTO 0) (w-1 DOWNTO 0);
	SIGNAL outadr_buff : array_of_std_logic_vector(n_out-1 DOWNTO 0) (natural(ceil(log2(real(n_reg))))-1 DOWNTO 0);
BEGIN
	PROCESS(clk,rst) IS
	BEGIN
		IF(rst = '1') THEN
			ram <= (OTHERS =>(OTHERS=>'0'));
			writeadr <= (OTHERS =>(OTHERS=>'0'));
			readadr <= (OTHERS =>(OTHERS=>'0'));
			busy <= '0';
			inadr_buff <= (OTHERS =>(OTHERS=>'0'));
			outadr_buff <= (OTHERS =>(OTHERS=>'0'));
		ELSIF rising_edge(clk) THEN
			IF(busy = '1') THEN
				writeenable <= we_buff;
				writeadr <= inadr_buff;
				writedata <= inport_buff;
				readadr <= outadr_buff;
				busy <= '0';
			ELSE
				writeadr <= (OTHERS =>(OTHERS=>'0'));
				readadr <= (OTHERS =>(OTHERS=>'0'));
				inadr_buff <= (OTHERS =>(OTHERS=>'0'));
				outadr_buff <= (OTHERS =>(OTHERS=>'0'));
				IF (start = '1') THEN
					we_buff <= we;
					inadr_buff <= inadr;
					inport_buff <= inport;
					outadr_buff <= outadr;
					busy <= '1';
				END IF;
			END IF;
			loop_in: FOR i IN 0 TO n_in-1 LOOP
				IF writeenable(i) = '1' THEN
					ram(to_integer(unsigned(writeadr(i)))) <= writedata(i);
				END IF;
			END LOOP;
		END IF;
	END PROCESS;
	loop_out: FOR i IN 0 TO n_out-1 GENERATE
		outport(i) <= ram(to_integer(unsigned(readadr(i))));
	END GENERATE;
END structure_b;

ARCHITECTURE structure_c OF RegFile IS
	SIGNAL regen_trans : array2d_of_std_logic(n_in-1 DOWNTO 0)(n_reg-1 DOWNTO 0);
	SIGNAL regen : array2d_of_std_logic(n_reg-1 DOWNTO 0)(n_in-1 DOWNTO 0);
	SIGNAL regwe : array_of_std_logic_vector(n_in-1 DOWNTO 0) (0 DOWNTO 0);
	SIGNAL regclken : array_of_std_logic(n_reg-1 DOWNTO 0);
	SIGNAL regselv : array_of_std_logic(n_reg-1 DOWNTO 0);
	SIGNAL regsel : array_of_std_logic_vector(n_reg-1 DOWNTO 0) (natural(ceil(log2(real(n_in))))-1 DOWNTO 0);
	SIGNAL regclk : array_of_std_logic(n_reg-1 DOWNTO 0);
	SIGNAL regin : array_of_std_logic_vector(n_reg-1 DOWNTO 0) (w-1 DOWNTO 0);
	SIGNAL regout : array_of_std_logic_vector(n_reg-1 DOWNTO 0) (w-1 DOWNTO 0);
BEGIN
	loop_inx: FOR i IN 0 TO n_in-1 GENERATE
		u_dec: ENTITY BASICLOGIC.Decoder(structure) GENERIC MAP(n => n_reg) PORT MAP(x => inadr(i),f => regen_trans(i));
		regwe(i)(0) <= we(i);
		loop_iny: FOR j IN 0 TO n_reg-1 GENERATE
			regen(j)(i) <= regen_trans(i)(j);
		END GENERATE;
	END GENERATE;
	loop_reg: FOR i IN 0 TO n_reg-1 GENERATE
		u_enc: ENTITY BASICLOGIC.Encoder(structure) GENERIC MAP(n => n_in) PORT MAP(x => regen(i),f => regsel(i),v => regselv(i));
		u_din_mux: ENTITY BASICLOGIC.Muxer(structure) GENERIC MAP(n => n_in,w => w) PORT MAP(x => inPort,s => regsel(i),f => regin(i));		
		u_we_mux: ENTITY BASICLOGIC.Muxer(structure) GENERIC MAP(n => n_in,w => 1) PORT MAP(x => regwe,s => regsel(i),f(0) => regclken(i));		
		u_reg: ENTITY work.Reg(structure_b) GENERIC MAP(w => w) PORT MAP(clk => regclk(i),rst => rst,d => regin(i),q => regout(i));
		regclk(i) <= clk and regclken(i) and regselv(i) and start;
	END GENERATE;
	loop_out: FOR i IN 0 TO n_out-1 GENERATE
		u_dout_mux: ENTITY BASICLOGIC.Muxer(structure) GENERIC MAP(n => n_reg,w => w) PORT MAP(x => regout,s => outadr(i),f => outport(i));
	END GENERATE;
END structure_c;