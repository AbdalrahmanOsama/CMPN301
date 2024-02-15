Library ieee;
Use ieee.std_logic_1164.all;
entity IF_ID_Buffer is
port( 
Clk,Flush  : in std_logic;
stall_id:in std_logic;
Pc       : in std_logic_vector(31 downto 0);
Pc_plus    : in std_logic_vector(31 downto 0);
opcode: in std_logic_vector(31 downto 0);  
input    : in std_logic_vector(31 downto 0); 

Pc_out         : out std_logic_vector(31 downto 0);
Pc_plus_out      : out std_logic_vector(31 downto 0);
opcode_out  : out std_logic_vector(31  downto 0);
input_out  : out std_logic_vector(31  downto 0)

);
end IF_ID_Buffer;

architecture IF_ID_Buffer of IF_ID_Buffer is
begin

PROCESS (Clk)

BEGIN
if(falling_edge(clk) and Flush = '1' )then

Pc_out          <= (OTHERS=>'0');
Pc_plus_out       <= (OTHERS=>'0');
opcode_out   <= (OTHERS=>'0');
input_out <= (OTHERS=>'0');


elsif( falling_edge(Clk) and stall_id = '0' )then
Pc_out        <= Pc;
Pc_plus_out     <= Pc_plus;
opcode_out <= opcode;
input_out <= input;
  
END if;
END process;
	

end IF_ID_Buffer;



