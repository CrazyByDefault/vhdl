-----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----------------------------------------------------
entity alu is
  generic (N : integer := 8);           --word bits
  port (a, b   : in  std_logic_vector(N-1 downto 0);
        cin    : in  std_logic;
        opcode : in  std_logic_vector(3 downto 0);
        y      : out std_logic_vector(N-1 downto 0));
end entity;
-----------------------------------------------------
architecture alu of alu is
  signal a_sig, b_sig : signed(N-1 downto 0);
  signal y_sig        : signed(N-1 downto 0);
  signal y_unsig      : std_logic_vector(N-1 downto 0);
  signal small_int    : integer range 0 to 1;
begin
------Logic unit:--------------
  with opcode(2 downto 0) select
    y_unsig <= not a when "000",
    not b            when "001",
    a and b          when "010",
    a or b           when "011",
    a nand b         when "100",
    a nor b          when "101",
    a xor b          when "110",
    a xnor b         when others;
------Arithmetic unit:---------
  a_sig     <= signed(a);
  b_sig     <= signed(b);
  small_int <= 1 when cin = '1' else 0;
  with opcode(2 downto 0) select
    y_sig <= a_sig            when "000",
    b_sig                     when "001",
    a_sig + 1                 when "010",
    b_sig + 1                 when "011",
    a_sig - 1                 when "100",
    b_sig - 1                 when "101",
    a_sig + b_sig             when "110",
    a_sig + b_sig + small_int when others;
------Mux:---------------------
  with opcode(3) select
    y <= y_unsig            when '0',
    std_logic_vector(y_sig) when others;
end architecture;
-----------------------------------------------------
