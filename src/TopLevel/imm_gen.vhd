
library IEEE;
use IEEE.std_logic_1164.all;
use work.RISCV_types.all;

entity imm_gen is
  port(inst_in: in std_logic_vector(32-1 downto 0);
	opCode: in std_logic_vector(6 downto 0);
	imm_out: out std_logic_vector(32-1 downto 0)
);

end imm_gen;

architecture structural of imm_gen is

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

signal sign_extend_en, ext_type_sel: std_logic;
signal extension, appendtion: std_logic_vector(32-1 downto 0);
--signal s_B_inv,s_mux_r :std_logic_vector(N-1 downto 0);
begin

ext:extender
port  map
    (
        i_sign_ex        : in std_logic;
        i_data            : in std_logic_vector(12-1 downto 0);
        o_data            : out std_logic_vector(32-1 downto 0)
    );
  
end structural;