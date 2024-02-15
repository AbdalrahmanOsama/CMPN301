LIBRARY IEEE; 
USE IEEE.std_logic_1164.all; 
entity triStateBuffer is
  GENERIC ( dataSize : integer := 32);
  Port ( Input    : in std_logic_vector(dataSize-1 downto 0);    -- single buffer input
           EN   : in  STD_LOGIC;    -- single buffer enable
           Output   : out  std_logic_vector(dataSize-1 downto 0)   -- single buffer output
           );
end triStateBuffer;

architecture triStateBufferA of triStateBuffer is

begin

    -- single active low enabled tri-state buffer
    Output <= Input when (EN = '1') else (others=> 'Z') ;
    
  
end triStateBufferA;