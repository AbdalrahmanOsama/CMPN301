LIBRARY IEEE; 
USE IEEE.std_logic_1164.all; 

  
ENTITY RegisterFile IS 
GENERIC ( dataSize : integer := 32);
PORT( 
Read_Reg1_Address: IN std_logic_vector(2 downto 0);
Read_Reg2_Address : IN std_logic_vector(2 downto 0);
Write_Reg1_Address : IN std_logic_vector(2 downto 0);
Reg_wr_en: In std_logic;
Read_Data1:  out std_logic_vector(dataSize-1 downto 0);
Read_Data2 : out std_logic_vector(dataSize-1 downto 0);
write_Data1 :in std_logic_vector(dataSize-1 downto 0);
clk,rst : IN std_logic ) ; 
END RegisterFile;


Architecture a_RegisterFile of RegisterFile is
  
Component Registers IS
GENERIC ( dataSize : integer := 32);
PORT( 
d1 :IN std_logic_vector(dataSize-1 downto 0);
clk,rst,enb1: IN std_logic;   
q : OUT std_logic_vector(dataSize-1 downto 0)); 
END Component;

Component MUX2x1 is 
Generic(DataSize: integer :=32);
port(
Input1 : in std_logic_vector(DataSize-1 DOWNTO 0);
Input2 : in std_logic_vector(DataSize-1 DOWNTO 0);
F: out std_logic_vector(DataSize-1 DOWNTO 0);
sel : in std_logic
);
end Component;

Component Decoder is 
  port(
Enable : in std_logic;
Address: in std_logic_vector(2 DOWNTO 0);
Output: out std_logic_vector(7 downto 0)
);
END Component;

Component triStateBuffer is
  GENERIC ( dataSize : integer := 32);
  Port ( Input    : in std_logic_vector(dataSize-1 downto 0);    
          EN   : in  STD_LOGIC;    -- single buffer enable
          Output   : out  std_logic_vector(dataSize-1 downto 0)   
           );
end Component;

SIGNAL Reg0Out, Reg1Out, Reg2Out, Reg3Out, Reg4Out, Reg5Out, Reg6Out, Reg7Out : std_logic_vector (Datasize-1 DOWNTO 0);
SIGNAL w1_en_signal: std_logic_vector(7 DOWNTO 0);
SIGNAL r1_en_signal,r2_en_signal : std_logic_vector(7 DOWNTO 0);
Signal Read_en : std_logic;
 
Begin 
  Read_en <= '1';
  w1_Decoder: Decoder port Map (Reg_wr_en,Write_Reg1_Address,w1_en_signal);
  R1_Decoder: Decoder port Map (Read_en,Read_Reg1_Address ,r1_en_signal);
  R2_Decoder: Decoder port Map (Read_en,Read_Reg2_Address ,r2_en_signal);

  Reg0: Registers Generic Map(Datasize)port Map (write_Data1,CLk,rst,w1_en_signal(0),Reg0Out);
  Reg1: Registers Generic Map(Datasize)port Map (write_Data1,CLk,rst,w1_en_signal(1),Reg1Out);
  Reg2: Registers Generic Map(Datasize)port Map (write_Data1,CLk,rst,w1_en_signal(2),Reg2Out);
  Reg3: Registers Generic Map(Datasize)port Map (write_Data1,CLk,rst,w1_en_signal(3),Reg3Out);
  Reg4: Registers Generic Map(Datasize)port Map (write_Data1,CLk,rst,w1_en_signal(4),Reg4Out);
  Reg5: Registers Generic Map(Datasize)port Map (write_Data1,CLk,rst,w1_en_signal(5),Reg5Out);
  Reg6: Registers Generic Map(Datasize)port Map (write_Data1,CLk,rst,w1_en_signal(6),Reg6Out);
  Reg7: Registers Generic Map(Datasize)port Map (write_Data1,CLk,rst,w1_en_signal(7),Reg7Out);
    
  R1_tsb0: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg0Out, r1_en_signal(0),Read_Data1);
  R1_tsb1: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg1Out, r1_en_signal(1),Read_Data1);
  R1_tsb2: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg2Out, r1_en_signal(2),Read_Data1);
  R1_tsb3: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg3Out, r1_en_signal(3),Read_Data1);
  R1_tsb4: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg4Out, r1_en_signal(4),Read_Data1);
  R1_tsb5: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg5Out, r1_en_signal(5),Read_Data1);
  R1_tsb6: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg6Out, r1_en_signal(6),Read_Data1);
  R1_tsb7: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg7Out, r1_en_signal(7),Read_Data1);
         
  R2_tsb0: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg0Out, r2_en_signal(0),Read_Data2);
  R2_tsb1: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg1Out, r2_en_signal(1),Read_Data2);
  R2_tsb2: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg2Out, r2_en_signal(2),Read_Data2);
  R2_tsb3: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg3Out, r2_en_signal(3),Read_Data2);
  R2_tsb4: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg4Out, r2_en_signal(4),Read_Data2);
  R2_tsb5: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg5Out, r2_en_signal(5),Read_Data2);
  R2_tsb6: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg6Out, r2_en_signal(6),Read_Data2);
  R2_tsb7: triStateBuffer  Generic Map(Datasize) PORT MAP (Reg7Out, r2_en_signal(7),Read_Data2);
end Architecture;