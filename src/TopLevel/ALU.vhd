library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
  generic(
    N : integer := 32
  );
  port(
    i_A          : in std_logic_vector(N-1 downto 0);
    i_B          : in std_logic_vector(N-1 downto 0);
    i_ALUControl : in std_logic_vector(3 downto 0);
    o_Result     : out std_logic_vector(N-1 downto 0);
    o_Zero       : out std_logic
  );
end ALU;


architecture structural of ALU is
  component add_sub_N is
    generic(
      N : integer := 32
    );
    port(
      i_nAdd_Sub : in std_logic;
      i_A        : in std_logic_vector(N-1 downto 0);
      i_B        : in std_logic_vector(N-1 downto 0);
      o_F        : out std_logic_vector(N-1 downto 0);
      o_C        : out std_logic
    );
  end component;

  signal s_AddSubSelect : std_logic;
  signal s_Carry        : std_logic;
  signal s_Result       : std_logic_vector(N-1 downto 0); -- added: internal copy of the result so Zero can be computed

begin
  -- ALUControl encoding:
  -- ADD = 0110
  -- SUB = 1110
  -- Bit 3 distinguishes these:
  -- ADD: 0 110
  -- SUB: 1 110

  s_AddSubSelect <= i_ALUControl(3);

  ADD_SUB_UNIT : add_sub_N
    generic map(
      N => N
    )
    port map(
      i_nAdd_Sub => s_AddSubSelect,
      i_A        => i_A,
      i_B        => i_B,
      o_F        => s_Result, -- was: o_F        => o_Result, -- FIXED: goes through s_Result so Zero can be computed
      o_C        => s_Carry
    );

  o_Result <= s_Result; -- added
  o_Zero <= '1' when s_Result = (s_Result'range => '0') else '0'; -- was: o_Zero <= '0'; -- FIXED: Zero flag was hardwired to '0'

end structural;
