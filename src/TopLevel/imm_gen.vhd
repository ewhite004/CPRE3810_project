
library IEEE;
use IEEE.std_logic_1164.all;
use work.RISCV_types.all;

entity imm_gen is
  port(inst_in: in std_logic_vector(32-1 downto 0);
	imm_out: out std_logic_vector(32-1 downto 0)
);

end imm_gen;

architecture mixed of imm_gen is

component extender is
    port 
    (
        i_sign_ex        : in std_logic;
        i_data            : in std_logic_vector(12-1 downto 0);
        o_data            : out std_logic_vector(32-1 downto 0)
    );
end component;

component appender is
    port 
    (
        i_data            : in std_logic_vector(20-1 downto 0);
        o_data            : out std_logic_vector(32-1 downto 0)
    );
end component;

component mux2t1_N is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end component;


signal opCode:std_logic_vector(7-1 downto 0);
signal funct3:std_logic_vector(3-1 downto 0);
signal s_imm12:std_logic_vector(12-1 downto 0);
signal s_imm20:std_logic_vector(20-1 downto 0);
signal sign_extend_en, ext_type_sel: std_logic;
signal extension, appendtion: std_logic_vector(32-1 downto 0);
--signal s_B_inv,s_mux_r :std_logic_vector(N-1 downto 0);
begin

opCode<=inst_in(7-1 downto 0);
funct3<=inst_in(14 downto 12);

with opCode & funct3 select
	sign_extend_en <= 
	'0' when "0110011"&"011",--sltu
	'0' when "0001111"&"011",--sltiu

	'0' when "0000011"&"100",--lbu
	'0' when "0000011"&"101",--lhu

	'0' when "1100011"&"110",--bltu
	'0' when "1100011"&"111",--bgeu

	'1'  when others;

with opCode select
	ext_type_sel <= 
	'1' when "0110111",--lui

	'0' when others;

s_imm20<=inst_in(32-1 downto 12);
with opCode select
	s_imm12<=
	inst_in(32-1 downto 20) when "0000011"|"0001111"|"0010011",--I type
	inst_in(32-1 downto 25) & inst_in(12-1 downto 7) when "0100011",--S type
	inst_in(31) & inst_in(7) & inst_in(30 downto 25) & inst_in(11 downto 8) when "1100011",--SB type
	x"000" when others;

ext:extender
port  map
    (
        i_sign_ex => sign_extend_en,
        i_data => s_imm12,
        o_data =>extension
    );

app: appender 
    port map
    (
        i_data=>s_imm20,
        o_data=>appendtion
    );


mux_app_ext: mux2t1_N
  generic map(N => DATA_WIDTH) -- Generic of type integer for input/output data width. Default value is 32.
  port map(i_S  => ext_type_sel,
       i_D0 =>extension,
       i_D1 =>appendtion,
       o_O => imm_out
	);

end mixed;