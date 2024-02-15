LIBRARY IEEE; 
USE IEEE.std_logic_1164.all; 
ENTITY Decode_Stage IS 
GENERIC ( dataSize : integer := 32);
PORT(

--input 
  Bit5_7 : IN std_logic_vector(2 downto 0);
  Bit8_10 : IN std_logic_vector(2 downto 0);
  Bit11_13 : IN std_logic_vector(2 downto 0);
  write_Data1 :in std_logic_vector(dataSize-1 downto 0);
  reg_rst: in std_logic;
  Write_Reg1_Address : IN std_logic_vector(2 downto 0);
  invalue: in std_logic_vector(dataSize-1 downto 0);

--control
  clk : IN std_logic;

  reg_wr_en :in std_logic;
  one_operand : IN std_logic;
  in_op: IN std_logic;
 
--output  
  Write1_Address : out std_logic_vector(2 downto 0);
  Read_Data1 : out std_logic_vector(dataSize-1 downto 0);
  Read_Data2 :out std_logic_vector(dataSize-1 downto 0)
   ) ; 
  END Decode_Stage; 


Architecture a_Decode_Stage of Decode_Stage is

Component RegisterFile IS 
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


Signal Reg_File_ReadData2 : std_logic_vector(dataSize-1 DOWNTO 0);
signal rst : std_logic := '0';

Begin
   Reg_file : RegisterFile Generic Map(dataSize)port Map 
  (Bit5_7,Bit8_10,Write_Reg1_Address,reg_wr_en,Read_Data1,Reg_File_ReadData2,write_Data1, clk,reg_rst);
    
   Wr_add_Mux :MUX2x1 Generic Map(3)port Map (Bit11_13,Bit5_7,Write1_Address,one_operand);
    Read1_Mux :MUX2x1 Generic Map(Datasize)port Map (Reg_File_ReadData2, invalue, Read_Data2 , in_op);


   End Architecture;
