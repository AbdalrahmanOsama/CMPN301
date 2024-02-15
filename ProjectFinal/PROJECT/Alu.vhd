
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


------------------------READ THIS----------------------

--bossy ya samiha, el output beta3 el alu:
					--awel bit (msb) howa el reset all flags
					--tany bit lel zero flag
					--talet bit sign flag
					--rabe3 bit lel carry flag
					--wel 32 ely 3al yemeen dol output value beta3 el ALU (A+B=F for example)

------------------------------------------------------------
entity alu is  



GENERIC (n : integer := 32);

port(
	 En: in std_logic;
 	   a : in std_logic_vector(n-1 downto 0);
  	  b : in std_logic_vector(n-1 downto 0);
    

      s: in std_logic_vector(2 downto 0);

aluOUT: out std_logic_vector(n+3 downto 0) -- n-1+4 = n+3

);

end alu;



-------------------------------------
-------------------------------------


Architecture arch_alu of alu is

component singleunit is

port(


   
    En: in std_logic;
    a : in std_logic_vector(31 downto 0);
    b : in std_logic_vector(31 downto 0);
    

      s: in std_logic_vector(2 downto 0);
  
   

    f: out std_logic_vector(31 downto 0);
    --ZFout: out std_logic;
    --SFout: out std_logic;
    CFout: out std_logic;
    flagreset: out std_logic                 
     




);


end component;



signal aluFsig: std_logic_vector(31 DOWNTO 0);
signal aluCFoutsig: std_logic;
signal aluFlagResetsig: std_logic;
signal aluZFsig: std_logic;
signal aluSFsig: std_logic;







begin




Keepol_3adaweya : singleunit generic map (32) port map (En, a, b, s, aluFsig, aluCFoutsig, aluFlagResetsig);



aluSFsig <= 'Z' when En = '0' or s = "000"
else '1' when ((to_integer(signed(aluFsig))< 0) and (s="001" or s="010" or s="011" or s="100" or s="101" or s="110"))
else '0' when ( ((to_integer(signed(aluFsig))= 0) or (to_integer(signed(aluFsig))>0)) ) and (s="001" or s="010" or s="011" or s="100" or s="101" or s="110")
else '0' when (s="111");



aluZFsig <= 'Z' when En = '0' or s = "000" 
else '1' when (to_integer(signed(aluFsig))= 0) and  (s="001" or s="010" or s="011" or s="100" or s="101" or s="110")
else '0' when ( (to_integer(signed(aluFsig))< 0) or (to_integer(signed(aluFsig))> 0) ) and  (s="001" or s="010" or s="011" or s="100" or s="101" or s="110")
else '0' when s="111";




aluOUT <= aluFlagResetsig & aluZFsig & aluSFsig & aluCFoutsig & aluFsig;
--           1 bit            1 bit       1 bit      1 bit       32 bits

end arch_alu;
  