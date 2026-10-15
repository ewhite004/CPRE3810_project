library IEEE;
use IEEE.std_logic_1164.all;

entity ALUControl is
  port(
    i_ALUOp       : in std_logic_vector(1 downto 0);
    i_Funct3      : in std_logic_vector(2 downto 0);
    i_Funct7Bit   : in std_logic;
    o_ALUControl  : out std_logic_vector(3 downto 0)
  );
end ALUControl;


architecture dataflow of ALUControl is

  signal s_RTypeControl : std_logic_vector(3 downto 0);
  signal s_ITypeControl : std_logic_vector(3 downto 0);

begin

  -- R-type instruction decoding
  with (i_Funct7Bit & i_Funct3) select
    s_RTypeControl <=
      "0110" when "0000",  -- ADD
      "1110" when "1000",  -- SUB
      "1111" when "0010",  -- SLT
      "0010" when "0100",  -- XOR
      "0001" when "0110",  -- OR
      "0000" when "0111",  -- AND
      "0110" when others;

  -- Immediate arithmetic
  with i_Funct3 select
    s_ITypeControl <=
      "0110" when "000",   -- ADDI
      "1111" when "010",   -- SLTI
      "0010" when "100",   -- XORI
      "0001" when "110",   -- ORI
      "0000" when "111",   -- ANDI
      "0110" when others;

  -- Main ALUOp selection
  with i_ALUOp select
    o_ALUControl <=
      "0110"         when "00",  -- lw/sw/address calculations
      "1110"         when "01",  -- branch comparison
      s_RTypeControl when "10",  -- R-type
      s_ITypeControl when "11",  -- I-type ALU
      "0110"         when others;

end dataflow;
