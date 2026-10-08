
library IEEE;
use IEEE.std_logic_1164.all;

entity control is
  port(Opcode   : in std_logic_vector(7-1 downto 0);
	ALU_Op: out std_logic_vector(4-1 downto 0);
       branch, MemRead, memToReg , memWrite,ALU_Src, regWrite: out std_logic
);

end control;

architecture dataflow of control is


signal s_out_vector :std_logic_vector(6-1 downto 0);
begin

with Opcode select
	s_out_vector <= 
	"000000" when "0000011",--l*, lb, lh, lw
	"000000" when "0001111",--fence

	"000011" when "0010011",--ALUi

	"000000" when "0010111",--auipc
	"000000" when "0100011",--s*

	"000001" when "0110011",--ALU

	"000000" when "0110111",--lui
	"000000" when "1100011",--b**, bew, bne
	"000000" when "1101111",--jal
	"000000" when "1110011",--syscalls
	"000000" when others;

branch <= s_out_vector(0);
MemRead <= s_out_vector(1);
memToReg <= s_out_vector(2);
memWrite <= s_out_vector(3);
ALU_Src <= s_out_vector(4);
regWrite <= s_out_vector(5);
	
  
end dataflow;