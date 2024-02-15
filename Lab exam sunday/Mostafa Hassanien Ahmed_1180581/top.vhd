library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity top is
  port (
    clk, rst : in std_logic;
    A : in std_logic_vector (7 downto 0);
    F1, F2, F3 : out std_logic_vector (3 downto 0);
    A_out : out std_logic_vector (7 downto 0);
    V :  out std_logic
  ) ;
end top;

architecture arch1 of top is
    signal data, A1, A_final, A_reg, A_op, A_shift : std_logic_vector (19 downto 0);
    component my_nadder IS
GENERIC (n : integer := 8);
PORT   (a, b : IN std_logic_vector(n-1 DOWNTO 0) ;
             cin : IN std_logic;
             s : OUT std_logic_vector(n-1 DOWNTO 0);
             cout : OUT std_logic);

END component;

component nBit_Reg is
  generic (n : integer := 8);
  port (
    d         : in std_logic_vector  (n - 1 downto 0);
    clk, rst, en  : in std_logic;
    q         : out std_logic_vector (n - 1 downto 0)
  ) ;
end component;
component mux2 is 
    port (
        in1, in2 : std_logic_vector (19 downto 0);
        sel : in  std_logic;
        out1          : out std_logic_vector (19 downto 0)
    );
end component mux2;
signal sel, en, c1, c2, c3 : std_logic;
signal ones_add, tens_add, hund_add, ones_f, tens_f, hund_f : std_logic_vector (3 downto 0);
component comp is
  port (
    in1 : in std_logic_vector (19 downto 0);
    ones, tens, hundereds : out std_logic
  ) ;
end component;
signal ones_flag , tens_flag, hundereds_flag :  std_logic;
component mux2X1 is 
    port (
        in1, in2 : std_logic_vector (3 downto 0);
        sel : in  std_logic;
        out1          : out std_logic_vector (3 downto 0)
    );
end component mux2X1;
component shift_one is
  port (
    in1 : in std_logic_vector (19 downto 0);
    out1 : out std_logic_vector (19 downto 0)
  ) ;
end component;
component ctr is
  port (
    in1 : in std_logic_vector (3 downto 0);
    valid, en, sel : out std_logic
  ) ;
end component;
component counter is
  port (
       clk, rst  : in std_logic;
      out1 : out std_logic_vector (3 downto 0)
  ) ;
end component;
signal count : std_logic_vector (3 downto 0);
begin
  A_out <= A1(7 downto 0);
    data <= "000000000000" & A;
u0 : nBit_Reg GENERIC map (20) port map (data, clk, rst, en, A1);
u1 : mux2 port map (A_final, A1 , sel, A_reg);
u2 : my_nadder generic map (4) port map (A_reg (11 downto 8), "0011", '0', ones_add, c1);
u3 : my_nadder generic map (4) port map (A_reg (15 downto 12), "0011", '0', tens_add, c2);
u4 : my_nadder generic map (4) port map (A_reg (19 downto 16), "0011", '0', hund_add, c3);
u5 : comp port map (A_reg, ones_flag , tens_flag, hundereds_flag);
u6 : mux2X1 port map (A_reg (11 downto 8), ones_add, ones_flag, ones_f);
u7 : mux2X1 port map (A_reg (15 downto 12), tens_add, tens_flag, tens_f);
u8 : mux2X1 port map (A_reg (19 downto 16), hund_add, hundereds_flag, hund_f);
A_op <= hund_f & tens_f & ones_f & A_reg (7 downto 0);
u9 : shift_one port map (A_op, A_shift);
u12 : nBit_Reg GENERIC map (20) port map (A_shift, clk, rst, '1', A_final);
u11 : counter port map (clk, rst, count );
u10 : ctr port map (count, V, en , sel);
F1 <= A_final (11 downto 8);
F2 <= A_final (15 downto 12);
F3 <= A_final (19 downto 16);

end arch1 ; -- arch1