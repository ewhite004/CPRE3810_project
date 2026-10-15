library IEEE;
use IEEE.std_logic_1164.all;

entity control is
  port(Opcode   : in std_logic_vector(7-1 downto 0);
       ALU_Op   : out std_logic_vector(2-1 downto 0); -- was: std_logic_vector(4-1 downto 0) -- FIXED: ALUControl takes a 2-bit ALUOp
       branch, MemRead, memToReg, memWrite, ALU_Src, regWrite : out std_logic
  );

end control;

architecture dataflow of control is

signal s_out_vector : std_logic_vector(6-1 downto 0);

begin

with Opcode select
    s_out_vector <= 
    "110110" when "0000011", -- l*, lb, lh, lw -- was: "000000" -- FIXED: regWrite, ALU_Src, memToReg, MemRead
    "000000" when "0001111", -- fence

    "110000" when "0010011", -- ALUi -- was: "000011" -- FIXED: regWrite, ALU_Src (was setting branch and MemRead)

    "000000" when "0010111", -- auipc
    "011000" when "0100011", -- s* -- was: "000000" -- FIXED: ALU_Src, memWrite

    "100000" when "0110011", -- ALU -- was: "000001" -- FIXED: regWrite (was setting branch)

    "000000" when "0110111", -- lui
    "000000" when "1100011", -- b**, beq, bne
    "000000" when "1101111", -- jal
    "000000" when "1110011", -- syscalls
    "000000" when others;


branch   <= s_out_vector(0);
MemRead  <= s_out_vector(1);
memToReg <= s_out_vector(2);
memWrite <= s_out_vector(3);
ALU_Src  <= s_out_vector(4);
regWrite <= s_out_vector(5);


-- ALU op
-- addi, lw, sw and R-type instructions enter ALUControl.
with Opcode select
    ALU_Op <=
    "00" when "0000011", -- lw: address ADD: 2-bit ALUOp
    "00" when "0100011", -- sw: address ADD: 2-bit ALUOp
    "11" when "0010011", -- addi: ALUControl decodes funct3: 2-bit ALUOp
    "10" when "0110011", -- R-type: ALUControl determines add/sub: 2-bit ALUOp
    "00" when others;    -- 2-bit ALUOp


end dataflow;
