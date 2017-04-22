library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std. all;

entity RNG is
  port (
  	in_bit : in std_logic;
	rand_bit : out std_logic
  ) ;
end entity; -- RNG

architecture behavior of RNG is

	signal X0, X1, X2, X3, X4, X5, X6, a1, a2, a3, a4 : std_logic;

begin
	process
		begin
		X0 <= '0';
		X1 <= NOT X0;
		X2 <= NOT X1;
		X3 <= NOT X2;
		X4 <= NOT X3;
		X5 <= NOT X4;
		X6 <= NOT X5;
		a1 <= X5 XOR X6;
		a2 <= a1;
		a3 <= a2 XOR X3;
		a4 <= a3 XOR X2;
		X0 <= a4 XOR X1;
		
		rand_bit <= X6;
		wait for 1 ns;
	end process;
end behavior; -- behavior

	